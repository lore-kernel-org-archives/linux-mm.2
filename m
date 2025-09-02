Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 146C9CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 21:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A466B0007; Tue,  2 Sep 2025 17:07:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AB36B0010; Tue,  2 Sep 2025 17:07:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABB76B0011; Tue,  2 Sep 2025 17:07:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 269066B0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:07:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E74D71DD775
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:07:03 +0000 (UTC)
X-FDA: 83845545126.26.A29F237
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1CF0A4000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:07:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NjS0xlal;
	spf=pass (imf11.hostedemail.com: domain of vdumitrescu@nvidia.com designates 40.107.93.62 as permitted sender) smtp.mailfrom=vdumitrescu@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756847221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5SLKgw6H461uDP59KqAWqULogMBuH8qf+/kmkUNiilk=;
	b=sVHEgJHBNC8QwfW5Z/fThg7Iy1gTtdvY85hPd5Zjzk56QYUtzaxAJ8BgVwKHwCXlBUP6Kx
	xpbLJNWJnKN26dEuoSK7MNy7UHjJ6qCv5cuCYhbbZ89ZLhPeBeyCFJSpn3QGFsYg9yzh5k
	nAY7uCMxlHxNZ0GQYK8Ce6rV7vcbD3k=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756847221; a=rsa-sha256;
	cv=pass;
	b=klqKG/YDoTbG0GZeGsqNvWtognlnEjZvjZf+KFBMEhXu/TkSiewJQKG7xpeb+WHtcXmufu
	hGkCkUnZzvPP0mYWau7EVRS7EJUXvjahsiNgzybUadwmATTs9+/m1tWf2PiWewiMdXMCF4
	ctIbe0l8VJQrnhJk35SpyS+YtuOPAE8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=NjS0xlal;
	spf=pass (imf11.hostedemail.com: domain of vdumitrescu@nvidia.com designates 40.107.93.62 as permitted sender) smtp.mailfrom=vdumitrescu@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rDdi7tndFO0n1SVoL4kCVuXQ7ApMa9FD8d8w15b8qqn/X9a23PsXeuNAg4ZnR4OM/zemFeF+H1XiI2dE2LWFRqJw9F0IejBiODJxHCtfI0+1vWp5iAhcOJs1/2k9pNXIBM++DEcGbixfCEpnFvzaWM9I9+vlCJl1h3KEudgJGGUzU+ZKsDINHux8Cf7TSok98/4eHjQ6XEIqimKsn3gmHK2ACcLxspL7ZpJeHn7WDI/dIN3xJwa8gqGlZdWTF5W+GpPeqhkpJDRVBmIVtAAfnM+MkxxoqZfjmd0mrHryPOdKfdhFyHyetacMB36mwgSLCLdBjvfF21X4Sz3VCusD3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5SLKgw6H461uDP59KqAWqULogMBuH8qf+/kmkUNiilk=;
 b=YyiDJdMwqATSO55K2AFZ7DfhgfRwBoOGxZwrfIHQwIGRveF9nsC/vIBVUyvwsOgYj+Xyt+EgDIYZkP9AYg+JX6lw61VzSipitElzJdPXUk8a79ZTS+V++CfMqmR2YCLhkwO/7FsquDht+VqobOP5T1ID3h90QkYevIt7qBlfBPJLBLkamttnKNJqoHrgjDQ7Xb0G2x1Rdz2jzRYLCV7tab+J4ErRVTNKqZVM6s8Srx07otBcYSaPbNYr8YG1pdlwuhdn42u0/dIvSidz6yoT5T2js34DSDH6SdEZEgGMmoNIu7f4jBewztq88MOy3jH6KqA+EZkVNa+emGUwSIkMtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5SLKgw6H461uDP59KqAWqULogMBuH8qf+/kmkUNiilk=;
 b=NjS0xlalCOTnw9S3hgb18OicYsvtxjWjUH9SIv0wqmuRGLtuYCT4Bw2fNrE9HPhxH2qlPK31GeS4h7mifY9JY62nRHXgKNyBiYlfZvB+p/uglNFYhPQOf9BF1+HUYuw9hkqpkJ7mZd5vgTUqAkmMU93ufkg1JH0pkSrxhhQcnk09juyRwQ455KoJOe5+X9wizf8FAP/hM6YLsFBIdjjIl+E5y4IoQAknnUW0cAbgYHvMj03hCJ4o1CXM6ea9Bv6I/WWPRjV1j09zIK0W1T0Eow9R/iMYZ6lAgMUG+yn9vY+AmCZsLs97Ix+iiusMRCLJoVgu4z7gYCAHbEkKtB4JDw==
Received: from BL1PR12MB5205.namprd12.prod.outlook.com (2603:10b6:208:308::17)
 by SA3PR12MB7999.namprd12.prod.outlook.com (2603:10b6:806:312::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Tue, 2 Sep
 2025 21:06:57 +0000
Received: from BL1PR12MB5205.namprd12.prod.outlook.com
 ([fe80::604c:d57f:52e0:73fe]) by BL1PR12MB5205.namprd12.prod.outlook.com
 ([fe80::604c:d57f:52e0:73fe%4]) with mapi id 15.20.9073.026; Tue, 2 Sep 2025
 21:06:57 +0000
Message-ID: <84bbc996-27c7-4f83-a8c2-4f88b439bd23@nvidia.com>
Date: Tue, 2 Sep 2025 14:06:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] percpu: fix race on alloc failed warning limit
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Baoquan He <bhe@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com>
 <061405e5-8670-2873-9b6f-0f152863adfc@gentwo.org>
Content-Language: en-US
From: Vlad Dumitrescu <vdumitrescu@nvidia.com>
In-Reply-To: <061405e5-8670-2873-9b6f-0f152863adfc@gentwo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0058.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::33) To BL1PR12MB5205.namprd12.prod.outlook.com
 (2603:10b6:208:308::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5205:EE_|SA3PR12MB7999:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f5f404d-2f54-4abb-6061-08ddea64a6d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VVRxY0w2dHY4eGk3RXZsaDJCQ3RMQTFPK3NHaHZFWEc2bk5TdzYyQlpWUS8y?=
 =?utf-8?B?N093WS9xaEsxa09ZOTRHZkl3Tm5jK0VVQU1vT3dDNjZFU3lBQy9Eb0R5enYv?=
 =?utf-8?B?VXh1Qy9FanE0NXdyeWRVdzlvZDlwVmlwWElNM3BNSDRXZFBVbjNBeHpsUjRS?=
 =?utf-8?B?a012ME5tcFN0MndCcVVjM3YySjlYQVRoWWROVHFSV2R3dXBXc2p1UG02SWJi?=
 =?utf-8?B?NUFRbmhPak5MYjRHSld6Qmk0MndwQk0yRHAwenNJaDRTOVVPb1VNT0RHRGNF?=
 =?utf-8?B?cmhSZDFuaXdSRVp0TlpvTkpFTEt5T2lrS2pRcWtUTWpSOFUvenhlT1JpS3JS?=
 =?utf-8?B?WHRva3NJYmVHVEM3dFYrTHIrNEhaNVR2VDA3OVR4dXdtYTBVZytLbFB0U0Nv?=
 =?utf-8?B?SEtNdmRFNVQ3OTgwZTBldk9ma2MveTBBeXRKQ3NhSG1JTnErdUFsVTdLa2FM?=
 =?utf-8?B?Nk5TdVRKMndxZWRvQ1RkYm9lYlk3Y2lha2RvcGliWkh5UmJCRkdidno1WGR2?=
 =?utf-8?B?eHJTcGV0OVV6KzZ3N3gwc3NtN2ROdmFCblJ1RTJQVE9ZSzBGb00xalRyMzl1?=
 =?utf-8?B?MGMvZGdNRlRRYm5wZUJEUGF3MWo1L2pYWitJRWQyY1NIQVFwaGtGNTVaRnZw?=
 =?utf-8?B?WEhWTU5BMTcvM05reXpmZnV0UnhIcXkyQzZYckZYUDZmVFZncXExaGFTNDlM?=
 =?utf-8?B?TmhmRExRanQ4a29CbDhCZW04WXdYRjJNSmNocWNCWjI3NlR1Z1lpY3RNOEww?=
 =?utf-8?B?Q2tZaE9TdENBQU8wKzZXd2NLY3ZOK2psQVljQWdDZDM4WTFETlVaU1lzZVE5?=
 =?utf-8?B?LzlIUFpOMDZXY1ZsU1pKV2cwU3pET3N1czNta2NWZXUyb2N3Vk9NemhqbHE3?=
 =?utf-8?B?ZFZoV0VCSnJJcXZWUXNOSC8yTVBHSVg0MkFIQU84NHJEZ1dJYWZERmE5cUdP?=
 =?utf-8?B?c0wrdjJRQVA0blgwNWkrWk9CV3d6MkxPbkF5MlhUblhTd1ZLbWllZFJzMG4x?=
 =?utf-8?B?YjcydjQxSytndmQxeEUzcTEzK0dMMHFsbDJSOVA5YWlkS25DODF3R2M3YUJJ?=
 =?utf-8?B?U0ZMbEVzeDJKRThwZUJtSEtMb3VMNmRzQkhvMTJkK3hrOWxyM3paUWMvdVRI?=
 =?utf-8?B?UlB0Y2hQU0tFV3IvTS9NYWFkM0crVWZTaGpzaFJodzVDaU1IUDhDUTVrWDR2?=
 =?utf-8?B?TGthMjJrcjBRMW1EQ0w2VzVOSkxjaGFOa1luVUZBUktXakFmZDBIRk13ZlNV?=
 =?utf-8?B?Yi9TSkVXWHJISkk2dFU3N1BVUytyRENDWExDd1Q2Wmh6MzhRc1lZdU1CUEh2?=
 =?utf-8?B?ZHBQcURhVkRNVitpeGtwaUlRNEVTTmlvaU9BUEoyQ0dXU1FUZFJyMHcrcTVW?=
 =?utf-8?B?VDE2WE1qaXlKQXdnQnphYW5IS0ExTEF0aUdidmZKOXJlTk13RWUweXRGaEs0?=
 =?utf-8?B?aUtzVlBpR0tWNmkyK285VG1LL0x2ZGh5aWluYXhqNmZwTVBjMmx3MDBseUth?=
 =?utf-8?B?d0lGZktVTkJpdFdGY0wwa1lRUkxVc3pFdzRZWWFpWEJ4VXlzTER6dFR6T1hI?=
 =?utf-8?B?WmtrVzBvSEgzMTZBM2JEbzlxSUdKWU01a1pyN0NTbFVlMjcrM3BrL05VbFNh?=
 =?utf-8?B?b09CcWNIaUxtTVFkbzZVVEZSemxyTGNUeGZYMG00NjgzaS9sc2lZZ0tuVmZS?=
 =?utf-8?B?L0VoK1dpbE5mUDBnYXp5NS96TERoQTBLbk1FQWpVQnlXalVGNUNhVTBRN1hB?=
 =?utf-8?B?dFBHZUYxdkJiYTVvRXVnbFdnZEhmYnN4LzFKckJCTmc2ZUdlZ0hIZVRlSEQ1?=
 =?utf-8?B?akZueElVemRuakR4amQvc0pNb1VNMUs4OCtDTk92SjhwM0kvNnJmaFkwWGE3?=
 =?utf-8?B?L0lEaUhGUkdrWE5rV3NkczZCMlViZytWdkg2V0NaOXlNTE5TOEtPV3VkRVlZ?=
 =?utf-8?Q?ecC03lzybDg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5205.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NTQ2aDFMU0hJRklpU00zNHF0dHUxV003RG5WY2tDQ0hhOG1BekJqYm5FQ1Ju?=
 =?utf-8?B?d2pDMHRPOXQxNXN4QTk0aFQ5b0plTEljaVp2QTRkK1p0djBsRndoZTl3cVd4?=
 =?utf-8?B?RFpEVnN2LzYxTFYzSVlRN0d0WFREa3QycHYrUFBXQkRjMzBGd1NqSy9iRWlS?=
 =?utf-8?B?V2ZBWFpZa1ZSdzZkZVR4VDBoMTJTZWR1QVgrWHBPa2tKVGplV3RzTWtjRkln?=
 =?utf-8?B?WmpzcDlvWmVyMWY1MExwRjJwVHRiZVdIQ3I4ZmNFMldCcU13c09hYTFia1lG?=
 =?utf-8?B?dC9OM3FIOVZUbWNDTlNpa1h3U0pyUmc4MEZBcHZQSU9DWG5kUWJ5N2phbGNT?=
 =?utf-8?B?TDRSSnJuQ2EzMm9RdEl2QjFmR1N6dGY4SXhmSVdiMGF4Vmw4ODhYYmFEeVJp?=
 =?utf-8?B?ZVVRaHMvcG1iaWxHMlVKNHliVkhOU0RLeko5dnphNDFJcDFhVEIxTjVnUDFI?=
 =?utf-8?B?ZlFHMWU1ZFdjWU04NTZXTjU3V2pKYnFYMFFwcUtuQmJzZVFubGJVZnhTeW80?=
 =?utf-8?B?OXFTYkRoeExkNkdIbnhiNzRjY1BvdHFaK3JoQmhTN3E2Mlc5SzMrRVgvZ0wy?=
 =?utf-8?B?UHVzRmo4RFdLUXR2UGFGNWxGZ284RDBUTElXaEJLd2NsKzg1cm1BazNFSElG?=
 =?utf-8?B?eFdWZFN0dC9xZjZCQXYyemM5ZHdBakJibTZPSi9XblFXa21HWmY3bEtsM2I2?=
 =?utf-8?B?UUk2eWFDMHlTNGJJYnFSWUN5NlJ6Y0J2MXM2aVVoa0M4OEJQUVRGT3VyTEM0?=
 =?utf-8?B?SWxqT2R2VGxtaG5yVWU5cDJ6Slg5K0t4eFBGRHRxNE9WQ2JNb3cwdlZhMm05?=
 =?utf-8?B?aUFRTnVFZ0F4RnlxVEI4MkJmSC84VC9FKzk2dkh6dmJsaU1yVkN5SmJWZmpp?=
 =?utf-8?B?MkhBOTI0UE1zTnRvZzdJZTFqOTJaMnhWNWVmMThGNmJpR0FwWERMSGtIWnJP?=
 =?utf-8?B?ejRrUC8wZm55NXVpTW5qQk82TkFDS1duaWN2TFZhdU9HYUJtT0FvblFJY1Fy?=
 =?utf-8?B?bVNoWmRRTXlpMTBVMmpHWnFqVjE4dEFNQnBGR1l6ekIyaXdTOG9OL2VmWGNY?=
 =?utf-8?B?TUVWbThYUm5HY0d3ODRUUFVlNHJ5bWNtQmg3RGJYNHNIKzVzZVFSbGxtb0J6?=
 =?utf-8?B?bXYzZTl0ZjJPUnRBckdndGxSY3ZVa0lFNC9mRFdCT29XYjgyRFd5bncxaDZ1?=
 =?utf-8?B?Y3dhandrSFBPWFVxRDhxSkFXQ3Q0TzNqeVorTy9PTVNhVVJhTHBaelRreE8r?=
 =?utf-8?B?bllyN3BPL1NrNGJKL2lvMVlQcFFjUGRxODkzczFiVVZYekNabUFHTGZva3Zy?=
 =?utf-8?B?dHliVlRuUTNjSWZBMXp3Rk1sSW9wUi9vd2lEOVU3T2ZrS2NtRjY4V3hwZHgy?=
 =?utf-8?B?Q0FVYW5TaFpabTBmZmozdWozYlgrRnc2cXlNNUdRWlFadFJYUUZFVHVZTlVn?=
 =?utf-8?B?dmNpYkRiSlpzK0RGL0htY2dyY2dkb3VPRGEvSlJTTzdKYW9yNGN6K01taUs1?=
 =?utf-8?B?M1IxWWx0UFlBWHZTNXA0eldvbXBSOVY3RGJKaWh3aFg1SmNhbmVXckEyTzhx?=
 =?utf-8?B?UFl5SWg4RzRIT2kycFVOM2pLZFBQQjRWczB3eHFtQUplcjRxZXhJS1ZpSUhn?=
 =?utf-8?B?T29sbmpjcnZ5NUFpK1B1Vy84UnFleTJRR0VHQ3FnWmZ3T2Zob2hIei9NL29H?=
 =?utf-8?B?SkgwNXExOEhpWGJoNnU2clJZYnNYT1FBMVpNcyttRWhuUWRjM3FMeTNOQVEw?=
 =?utf-8?B?NmxERytFVVl4bkppeEtnR3lGNWp2VEJKRWplbU84dlc5Z2M2eXE2d2k5Y0dm?=
 =?utf-8?B?ZnBtWWtRMFVTNUNKUlptU05zNnFLYnBpT1M1VE43OEViR3lGWDR4YkhJK1FZ?=
 =?utf-8?B?Mm55cFl5NGNBUTYvMERqeStQMEFrMHNPVmg3dGlkcTNxbmpRQzVJeC95V3hZ?=
 =?utf-8?B?QzVDMjBaMWp4eXNTODRGMzNaTHgwS3RkTGJVSHUyS1U4bEtWZGEvUWFnVzdG?=
 =?utf-8?B?a1B3TXBkcTZyM2hleUZ1djlsSHV5MVRpZHVlS1g1K0RKYWMzWUpUb2MvQnlK?=
 =?utf-8?B?c0ZDZkJzaDh1OXA0TnRvQ25hYmdLLzM4REp2R0ZQUFkzVnpodll2WlpvKzhh?=
 =?utf-8?B?TmVYeTlhNFN5RHhWMjhBK09kRlo1R09vVVBhbGpqVlFNUUZOTENUbVJwc0Zh?=
 =?utf-8?B?WHc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f5f404d-2f54-4abb-6061-08ddea64a6d8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5205.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 21:06:57.5317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OiJXABx30o7vcwxxY3ZMVhqVxc9HKZc9bvDnuRxVD2P/DdNopYgdFWuKCJXqC+nrYB/lX2BGb6BGxomwnvHrww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7999
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CF0A4000A
X-Stat-Signature: g3hs7axs9hpmcbcejpdj7f8th9c7ammg
X-HE-Tag: 1756847220-335920
X-HE-Meta: U2FsdGVkX1/ZOkcyd6z8TXbYPSU97yoZMZbBsHjGwj2yZr31+IcCXz6FzjzZYa3d+juj3YYyA0lDIxYO31MhM67wO+c6vgR/QAP4rAys+cfHbKf98yqb11L7FaOYME2a0blnnA9cvueIBwnBdpkQR0pO+FusELAhDbP7qZ5/Ix0wJLuoNk3NttqghoUaB5PJUb+qdTHSGW5CU3dbUBH89seFmjnx61ybqwI9hInRxo52aR5sdUY1fOJKLuaJ4X6gNoKdOp4rhJ0CS1QxRMrCFAz7RraNffleDX3W7pJ4gIjnI6GSlqxr4Gzu7LYmvWIGg0cpfCZZCXzUVHrzH9rjMp/uB4nHSZl8+rS1IFe6AAM3uuISMDNOxbIUPCSoQMP+EHJWBtblkZFjvvoYkkH1QA4C9QwWYPxk4mgk9xNsDFbbkla4HzI9e679gLhEKbmgQEWJV54jWgvAteIYJc1akWPNE0mS8pzALITKX26/fn4y3kPinv6+/Zdf1w/yLoioUlJOLMiRZsfA2euUxms1n+YU/TzxA1qrlMb8Xw/sBkTv+yw6d+xbdzmY9OGKIkngtzdXDiDxz0oiMS/ZV/A0DpCzRFFC5FBqGgQTf8los13N91bhBjNt4f7V5zo5D1aFwtAwLEjL2Rnh7Zrc7kysM7Mprk9w+FBP7f07pHO/AENkhPHpcCPdcnWxIHKHzP8tjDXu3OUoA2MMpFOdSOm/gpa5EjJ6407LYGzUV/0BemVRxnzxWSK2/FxT8CFQzcFSDOWGaIN5RomIISxQ4Lm0WyqD0kv9ufIPjUAowRQKBBwsjfPr9WgHYJpMGueoFsqEt+Ea2AFj0SiIXGhzHKJEBL+2/Orw2790U6oGDwPVwksWBlLNUiA1zDJqKlw2El454CSXHCJdp9Ihv5QBgSSmkzta+i9Ecg+a/YAJpGDw2SgAgfKW/KjPl7FRtseh/HQ1DSHBEthOkAcbrmZISAF
 uSSyzHGr
 F0621PMp2GgGmgjHeW9v2P2OFP14QmGldXoi1q2miTbk2Rfreezuju4U5F8ahsTJH6LQqhYqBtuxU3lNjyREcbOOz4DMZZmkUC/BEJc08n+ou9eID7fsDST46GS7EnoZcHOE7+iwVO16mg4l+mFdrZDQLlb32Ek8tdsjFpYe6Z85HBgEEdLPrr0XG1ZhYYy5J4gaEAYVtF+TsJ4fRwd5hGqXhR6QQbeLewhm20d/UZPDckLX0wDSNWbNpT2PFVAP22F2y+jxyNZbwpJA5XGDEf8c6F3GoVVWenZYyRznEOHgbn+euWfIkI92Z8kEln+y1iIuR0i3J5DXDeQlzhE2Re4I/SWh77FWqTeC1c1y7Z5eDDk0tO7/M11DKxLERosA2OBMChfSlGuJDW0KqLK3g5HLM3QVIvBRbq+9MzkCAI1dBIJgT19QVqFHU+H11PhAWGVB5iztzCeIR3gvbP8Gui0frY3Qkox3N+ybkxkqTCc5D5Mf0z+T6kbD+WQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 10:39, Christoph Lameter (Ampere) wrote:
> On Fri, 22 Aug 2025, Vlad Dumitrescu wrote:
> 
>> +	if (do_warn && atomic_read(&warn_limit) > 0) {
>> +		int remaining = atomic_dec_return(&warn_limit);
> 
> 
> The code creates a race condition since another atomic_dec_return() can
> happen on another cpu between these two lines. warn_limit can go negative.

Yes, which is why I mentioned it in the description. But compared to before,
it should be benign.

> Use a single atomic operation instead?

Did you have something like this in mind?

-	if (do_warn && atomic_read(&warn_limit) > 0) {
-		int remaining = atomic_dec_return(&warn_limit);
+	if (do_warn) {
+		int remaining = atomic_dec_if_positive(&warn_limit);

Should end up with the same visible result, but w/o going negative.

Would you like me to send v2?Vlad

