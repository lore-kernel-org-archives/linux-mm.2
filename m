Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35AA7CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 18:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67B998E0006; Tue, 30 Sep 2025 14:08:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6320C8E0002; Tue, 30 Sep 2025 14:08:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F3738E0006; Tue, 30 Sep 2025 14:08:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38FC68E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:08:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC99887C1B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:08:57 +0000 (UTC)
X-FDA: 83946702714.14.62EF5FE
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11020129.outbound.protection.outlook.com [52.101.46.129])
	by imf29.hostedemail.com (Postfix) with ESMTP id BF5AE120010
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:08:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=XOf9A7EF;
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.46.129 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759255735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z78ftpTBJG4dTAw3euExCje+Xu2wIQuDC8lIoLdCZTU=;
	b=DXpZjr5KvrV+tHzN+0WrqBYUjiYkhhwp9InW86dAtVTW95v8/r2cxcimdlahqMvmOkGJkk
	DCj6qnkckwGOQU9Xm/KjT3CVmck8t4eY7y27Ingxx/LuFeN3W8JEX8EUIkXgt/D3IbQI4T
	+PK1AtkkF6eodz1aKTq5vOMGNiKvqbY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=os.amperecomputing.com header.s=selector2 header.b=XOf9A7EF;
	spf=pass (imf29.hostedemail.com: domain of yang@os.amperecomputing.com designates 52.101.46.129 as permitted sender) smtp.mailfrom=yang@os.amperecomputing.com;
	dmarc=pass (policy=quarantine) header.from=amperecomputing.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759255735; a=rsa-sha256;
	cv=pass;
	b=jrxL0IFjg5T6/qw3yt2YsiYLsqH5QTb7pmwaDUYuAgSmKpbEmGcPYVwiDUbCqQHeY8xo03
	C1uYf8dDe4cwfIIvxCyHmxmjsGjIatEpR2Ufv9iINkFnmzPtq61qp/1l1z/B1Tpg/bgFYa
	n5kXhKdJdBV72JwG3RbwHqVQULy2OYM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wdYUbdJLGpeOzb+06/TcEyObzZImWh12OkCss/A5jdIyE7ijLF3ZjAmtQdwtc4HezFer6+WIan+ELd4Rs9QHywqui59SQ55dFW2T12QOxb4oCe4fuC7e+cVI3NWFQuP45ucyOxgfxeHYEas6nl/0FNrsv8X0EcQb4Xa0nAi6IuNh6jYe/rLdn1+3/CcMD1N2xf5l56fOqf1hizcKP+6a8cNQM2N0//39PNec7AgM1uF/uFz2ZrWkEUJdw7u92qouRokKl3Olm9yf5E/KFgDtRrDhKZ7TrFDym+Ji/BNOg8gXB47PukOmNdK+APCz/lECigQanurNGqgYIZ86qxayPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z78ftpTBJG4dTAw3euExCje+Xu2wIQuDC8lIoLdCZTU=;
 b=CEJlu7C1wK0Wkauh6C2sKWBLZiRflvgPTjJv+kctzNk7lIrmb3vqkzgIJuQKKuhSrIk2SBbIYyzhOR2x7YWYFhIjWuZzb3rI6+7g/9/dNCVq6+nnXtvU5Z8nq/lUe1/dR5Gl9ID9+MfDTh6tDWknhtQNRgnx1ZUzmiWgIC+c9VR9m2VskbtdxofYFcxOswEk8fUZ8WaN0CbtINyNjyIAurhtt6uniz3y1mBGkPV4d4A0RQ5aatdgDUfaUHWIRcribnHkAxFEDTBIP/Cpuz39Bacnb5Fs2/7NNlfmZKtVXDMnCcT4EF6YUC3uUx5HfMNcLvh0/Qzq7RqGrMBB9DiHBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z78ftpTBJG4dTAw3euExCje+Xu2wIQuDC8lIoLdCZTU=;
 b=XOf9A7EFSsw3CpEZcEwuqfA2yDScMns5Ehw0cXCRCNvr62cJNsP7c8ItgVRHBOgAOEvx7rm+LN9lpq0/nDB2x3axWg3/kHti5lCV3E2Ooo7OdUJ2CJ9r23MUglWCfffwgrzopkgAB2FeNA3KRDhXV3m1r6cFP/B0L+k+l78ivgc=
Received: from CH0PR01MB6873.prod.exchangelabs.com (2603:10b6:610:112::22) by
 BN0PR01MB6912.prod.exchangelabs.com (2603:10b6:408:16b::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Tue, 30 Sep 2025 18:08:50 +0000
Received: from CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460]) by CH0PR01MB6873.prod.exchangelabs.com
 ([fe80::3850:9112:f3bf:6460%3]) with mapi id 15.20.9160.017; Tue, 30 Sep 2025
 18:08:50 +0000
Message-ID: <6cde8290-3aa2-411c-bf29-eb91a99e33a5@os.amperecomputing.com>
Date: Tue, 30 Sep 2025 11:08:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [v2 PATCH] mm: hugetlb: avoid soft lockup when mprotect to large
 memory area
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 david@redhat.com, akpm@linux-foundation.org, catalin.marinas@arm.com,
 will@kernel.org, anshuman.khandual@arm.com, carl@os.amperecomputing.com,
 cl@gentwo.org
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <20250929202402.1663290-1-yang@os.amperecomputing.com>
 <cc40d827-3b98-4e15-ad45-5c2033e4ce20@arm.com>
Content-Language: en-US
From: Yang Shi <yang@os.amperecomputing.com>
In-Reply-To: <cc40d827-3b98-4e15-ad45-5c2033e4ce20@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CY5PR15CA0189.namprd15.prod.outlook.com
 (2603:10b6:930:82::7) To CH0PR01MB6873.prod.exchangelabs.com
 (2603:10b6:610:112::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR01MB6873:EE_|BN0PR01MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ff1d223-79d1-49e2-9918-08de004c6827
X-MS-Exchange-AtpMessageProperties: SA
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVJXNGFsL1FXcVhHSU5YSnNkVW1wdnVrMTFsYUdkbTdIeGc5RE5kdXc4UU05?=
 =?utf-8?B?cEVTQ1JyT2dnMG96UTRZOVJuOG94dmtkbXBwVXcxdGszRHd4Y0dtUzRVaWJr?=
 =?utf-8?B?Y3Fzd2MwemxCK3duWXpIQmQ2Tll2cUhwai9vQlJjaFR6cUFNZFV6cWRrYW9n?=
 =?utf-8?B?RVlRYXRSUHQ0YXRHb0J4K2tiZndyd09qR2xSMUUwSFAySzRBY3RjbHpINDQr?=
 =?utf-8?B?dE1hdzIwQ0lsb3hPVVlJNmZjTllJaEFBSUxycGhPMlNGdXh2b3puNmorMS9p?=
 =?utf-8?B?cjNoY3JvRENsOGJ1c1VET25qVGxOYUw2bnBSVVI4d3U5SVgvN2p6aTgvdDVi?=
 =?utf-8?B?eUprYy81SFZhcDZsVGF0czZWWHdLNk4xSU14cFBycHQ3dmREd1hFbVVSZGhy?=
 =?utf-8?B?RTlhZ0RuenF0QnFWampiUGRWRzc5Y2dMMGpOeFZGUlhxeC9tVlljRHIvVEhI?=
 =?utf-8?B?VXlMeURkOVRUUEdUdXNhZ09JYksyWTNuNlF0UjZid205dFN5QXZvakhyMjFJ?=
 =?utf-8?B?ejN2R2pGS0pkRlZDUmtrVFFJUTY2WnA4VnBvM1RXQjhoSFdyRDdEbm9OSlc3?=
 =?utf-8?B?ZzhOMUxtb0w5NnVsTGcrRDQ0bm8vME5COTR1UDY1TmR4Wktaa1owRno5bHRm?=
 =?utf-8?B?RWtzM0pIcjJLS0cxWTFETjJEdzBDTUlObVJ2emNxVEdHc0djZVBtVHJvcW94?=
 =?utf-8?B?UE4rS29wckx0U1RseHFIVkd3b0VEeWlOeXNWMkZKR1hybTQxVUxudGdoUURj?=
 =?utf-8?B?cWtrRjRyeGl3Z1pXRVBpQ3FWK3BVdkloYUw3VWkwOXVsRktFcmFCT01HZ09B?=
 =?utf-8?B?YVhoOUpqS0JKU0dIblVkWlJmOXpvejVic1d0YlBrMXJKRS9GSWRXMGZJZFNC?=
 =?utf-8?B?eWVrV29qM01JaTM3ZlZZK3U2eS93eS82UklDTjRVNldKUzlma0d2aENJOU5U?=
 =?utf-8?B?K0pObWpWUHpyS0FRelhWTGllR3BtSXFHRk4ya2RGRWpVN0lYOTlPL1Q2aklz?=
 =?utf-8?B?U2tIZVFKeHY4VjUxSG9iUDB3c1BnSGx2elo2SGx3UkJVRDJXUG1SQWIzY2hp?=
 =?utf-8?B?a2dEZHNkSmZZSXBrNVZKQVFrVTZGaklFZUJ2Zm1ybzdua3JCcG9Wajh2R1VS?=
 =?utf-8?B?R1lKdDIwMytNTEI1aUxVYjVESXJUbjF1cUtvb1lnZllLTTkvODAyL1ZIejlY?=
 =?utf-8?B?VXZ0dmtJcE9yQjBURDY0NWtRLzJBWU1SdE5tdkFkRFloclZWZ0NxajU0aWtx?=
 =?utf-8?B?RHdJSVR6SVVoSEE0c2NMSXVPdDBxdkU4dEJrMjFsTFkySW83RDc2eStnVS9K?=
 =?utf-8?B?dDFDNTJtTHNhRWovMVM3Q1JzSnJ0cC96b0JxRzVndzk2RElwN2hDQ3VrMkZJ?=
 =?utf-8?B?ZEFvdms2TWc3TkRzZTAySmluWnY0ZnZoS25hNHdBRVRpVEk1TTZBeENUWWZP?=
 =?utf-8?B?K3NtNVhKTDJSRkZabEpFL1l6alE2VHJURHdMRUl4SmhMTHRzMUFiYStOTmxF?=
 =?utf-8?B?UTQ4TWRFZDFSak5zZjMyT2g3ZXMrOHVYQzVwSWFKQS93V2JrOW5zUkd4bHY1?=
 =?utf-8?B?MHhnRExSWXArODBET2NmaXBjaWJhYUZ2bEZ4TWpPNmF4V2dsQjhOeDV1R3dY?=
 =?utf-8?B?VHhQL2k0MGRTSDRnOTNjQUJNN0hYb3lpd1ViTXlDSFhvVWZGdE5wWUNYU2tW?=
 =?utf-8?B?RkFKQUxzdG5kQjVxRi9HOGxOcHhhL1BpWTFidFMySUFyTnRWeFdnM0c3Q1g5?=
 =?utf-8?B?SnF5Y0tReWE2WE5CbG10ZnZsMEhMYTdyK1RVSFJpQmk3QVZvM2tKUnh0Tndj?=
 =?utf-8?B?WUg0aklwWk8vQnRNb3Z4cy9Wd0xBSXdSQUVoeWlzU0pjUXF1RUhvdTlUdFRo?=
 =?utf-8?B?d3hFbDZpYURGNTE2NDJnTTJVYTNsckg0anJHYjhqa2tjanRrTHlVMFdEbXV0?=
 =?utf-8?B?Mi9mNU5nRmNvbFozSW5idGp0eTl6VXdvUjFDUlFyNzBxdnh6SWs3MDNYczFp?=
 =?utf-8?Q?advvcuFzXcVGZV2pcvk1KHvCPHmBYo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR01MB6873.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmlaOFR5YVpPR2dIWDVXZHVNMVVtSkthSkVuMnB1NmlpN1hKaktSWmlvcjB6?=
 =?utf-8?B?OGpQNDFJR3pGNXVvUXZmNUc1N2FQclJGdlo1bmMrOWEyMDhVNzZFTHZCK3lT?=
 =?utf-8?B?dXJZek0yZEJBaERoMzBEK0hlMmpHTGFRT0NGeldLWDlldHp4SkV1czltakFG?=
 =?utf-8?B?clp5K0dOZXZoY1NlWVdUZzd5dmtkVU5tTFE2WFFoRUZvS09Bd3Z5R1hsZVZ6?=
 =?utf-8?B?WFBEYUNiTTIwcjlMYkphTTBBWXZYTklKRFpoRzliWk1keWlOeGlxYVI2QldQ?=
 =?utf-8?B?c1M1SXdYM3hRU0tPTzNDdUJWbitFdWpidEVHdHhHa0lLQ3ZIdXh5TUd2NUZI?=
 =?utf-8?B?WVpNb04yait2aDJUTmllaU9nM0dmc2psSllnN0NYdXVINUNzcEhka3BjTVor?=
 =?utf-8?B?NjJWR3MxSVQ2b0pEYnRIVFNaRjRuaExaQnBSSVIwOVJVOWlQRERoaklqNEdQ?=
 =?utf-8?B?ZWU4djFTK0E5STE1d2tlVFRpMXJxUVptUWJtdlFlOTZtSGdVZGlPQ3F3S3M4?=
 =?utf-8?B?QitONWJYNFhidk9uRlpEQmlHK1Q5NEE1cmJXaitrRjhVOHZOQXFGblR6OVdB?=
 =?utf-8?B?VDlyZFBLQlQ1Uy83NHlzd3BQK0JvVW5Oa01mS01DZEpUaFVIM1FkSFFQczBF?=
 =?utf-8?B?bUZMQTFVK3UzcHZ2V0l5SXVWRXBUU3Vub2hWYmIxeDJFcGpHUmQ5K3BXcUJh?=
 =?utf-8?B?VHN1N2Z1ejBlN3VuUko1YXp1VjhEb2ttbWxxSUxpSFdyOW10MUlwQ0JTUGFL?=
 =?utf-8?B?WDZPTVo2WmNhRVo0bGhhQ3Y0T3JMQ3piRkM3eHpvMjVUNE9mdEpzcHpWa3hB?=
 =?utf-8?B?b0JDcG1UYkRHeWhENjB2L25lZktEMTBlRWVsOUhwYWF5Y0x3TFNXQk5SZ3RB?=
 =?utf-8?B?KzRSSStNYlVaV3pnMVZQaXdLSDJmWkxSWEZ3WllnYWx3TE43dlh6RVJpRUlJ?=
 =?utf-8?B?U0s1T0RydDhQSndGOEgzSWN1M0UzR0lMQzh6eENzVUVMdEJTRzdZNlNuTlNm?=
 =?utf-8?B?all3bGVCcWJVRnFzNVZoYTkzeW5lZ0FET1pMeXRrc0U5eDJwRFlIbHRXK3pZ?=
 =?utf-8?B?Vm1PT3I4U25jcDZ6Q3lZTDhJWWZIU3Myc3R1STU5cHRDWDhnc0d0Q1ROc0ZS?=
 =?utf-8?B?M3BNYStGcE9QTk9Oc2pNTnZtRU1jUUhDb3doWHpzUExjSlpBNWVyTTNaNnJo?=
 =?utf-8?B?Zmp6QTFrSHltZDdUeWtRak14RnJRMys2Q2xUMGYvcU1NUFNFWEVRRjZWVkNL?=
 =?utf-8?B?QjI2VmxJQ2E1Tmp5QWgrSSt3ZWNLV0o3bHdTbmdCRUFSa2IwTnlRaEpXKzNP?=
 =?utf-8?B?cXdaUVhvTllZYWo5VDJNNHI4SXptQUNESDVGUkVVK21tSFFtL1o3ZGVwbmpy?=
 =?utf-8?B?YXlObHh3NmxvQVRrU1NsN0RlZkhTRFljWmJ1NzlTVFdBYm5samJVb2o2UU5E?=
 =?utf-8?B?RzRVTGVTUlBWSlNmV2JhQmo3SWlWMWVmVmZodXdKOFVicXkvenJ4OXRxTUpK?=
 =?utf-8?B?TUR3T0t3aDdNQVNCOFBTckZBWFg1Y0VZcDRmWnVVcXRtS3dmUWtybUJNNnI1?=
 =?utf-8?B?eml5K1grZld4MEZaL2VmYUhKL1QwN0xSV0YyYUNFSFpNdUF2Qk5XbThndTRE?=
 =?utf-8?B?OXNPclJFTGxybmtDTzhXQzNLRU4xeklhd1ZVY3NaeEVUMVdtS3NYQ25iUGZE?=
 =?utf-8?B?ckp3c1NEZDlFUkFZVXByb2tYcVBOTU1JREJZRi9zaEhRWkFENktWS0JrZE43?=
 =?utf-8?B?QWpTbzV5N0E2bVZJTkw1MG1PaHRYenhTK1hKWFdDZUFsUFVCYUVleVF4L3Nh?=
 =?utf-8?B?TDhackRUYi9rUUZYdmNIZ1RWTlNpbzdSeFJKQzZSTnF3WE9MNCtLS3dWdGZH?=
 =?utf-8?B?Zk9UMTg5WGFZd2xSc2hrODM4R05DUS9FZmdiZm9oMHNoOEFEdXBianQ3S1RZ?=
 =?utf-8?B?YkNSNyszNnFGcWFKdUl6SWpMRGgyZUpkbXZ4Q3ROSmJ5Lzh2a28wNEkvMVd2?=
 =?utf-8?B?dUZHd2J3cWZpeDNRVXZyRW9kNTA5ZFNBLzE3WXh5TFI0eTV4T1o1dHpDZmR4?=
 =?utf-8?B?UWdnUTU2d1dZYzNUOURBdzJnUm5BRnRSdVcyZ2RQaFRVODM5d2NtTkdWU1h0?=
 =?utf-8?B?alJoMlYwc1Bpayt5TVZmV1J1ZDZvbW9GYVQxOC9Bd0FHQlkrK1hSYVFZY3Q1?=
 =?utf-8?Q?5rsYbcMQ0VvkuzGDTw0kB+0=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff1d223-79d1-49e2-9918-08de004c6827
X-MS-Exchange-CrossTenant-AuthSource: CH0PR01MB6873.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 18:08:50.0478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QzcF2ADWdR+mSoAqpa2gUh4105h2ilERthdBQ/D3yupV3HetT1ASErakxSRoe2ORJ+jvHkHxIBAL9mZBMjoQZnB5vKdPP1kEnjBeWasYcCc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR01MB6912
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF5AE120010
X-Stat-Signature: hpd5hc5h5ruogeehm5pk4w4ajroi4o7g
X-HE-Tag: 1759255734-570906
X-HE-Meta: U2FsdGVkX18/fccHXckHdGzpVMTF0w0bHbzcRi2y99xH9fwGYuLEjmmjdEMWfqREKQucjymukpaiw351i8Mdg6l/Rm+ANcmi+umUrH2TLvt+7Ezy1K+oKvF2BIEzd4f8mn1X+6Q5M5jV3/8flqoknCQTWZmIWz3w1AQnRXDTObIum5Yf4X4X7Z7OMgn5/jrsB/AEeVkK8lH+oxXyavtrjIWcJOeLrAvG1TinoJeVSvTcLXR1Puw4D9q5SNMujguvzYVth/V5A2Kl441tnOoTNaifU1d4opzszoW32QJAqM82O6CoFLtW0DtR0xYGnlXrLGLkTT9YLIXwdvJ/HAZC/hBv+xVGywySNA+R5kB/7wk4/RsIHN3rccHS+mAhH5BX9BhH8ozJBETJsd0CeAkfAXgH7t+5cs+mjCv5FY6ugxjiOAJQESXl7d0y1dsF++r5SXJNi3+clHJ3O5jP/Y+/MslRCP9WpUP8kF+Nva8zEDzj+3Fyt6p6yAEz3MzUUOaBYp3a9tEDmQ8afBo8TkdkP7LPlmgdA8IaX25IFCOMZM11g32NhOEvq1X6W5JBvLIyfhWCV2sHfKwB769WLu68dakqBKNe5uhTxHDnY8kexlbGfhfWqBQmK05aD4jgPKo+n6i5jKrf/UsLsdaNJgoyXkIPC9kXb3Vufd3UmmdqPORdekfNaSTF1on6ZGH9RQL3+v7UXGhygoprOLPUnDlupQ0A4vwewBLhXtTSrC1mLGPh8bAXUBFZny7GEAD1JnOyjTtnf+ftZa/01LFajnBct8mq+G9DPW9qbtvpXND7j/gVGO5o/hLHAdRfTV6Kusy39MtGvfk1u/8gHWFLcYVjNqtTrvJE91KtVSw+WHxbfbE7/D8NFkfD022DB4mjnFKUNqYv5KDMoVTdJAuQOIyagNz2+r2yhKwcTl3eIxLcnSA5lAmwfMA74MdaTfzK7HR6fDm8zewz0FiEH6qTmel
 NYHhaXQT
 OWWjoGO9UrQgu/Vt0+0WqHKKn09K/te7HTqzuvXFq3Loe2dSjKAxoYTyOISrtc/2sSZN00W5v/FwYwevYU1m/VClB2Se08KeIgNdeyLuhIrYR9A7/Pu9/eYwuZbzrh/8nDwycWucC87Vbq25Uu13tnLAw1CKl7NpgvHY2Q4AKf+zJvdC8Lv0u2SdLpu83tnhq3BRhGukOFWaWhnznv1Vok2K96J+ro2rRiK+3ItrdSVEIFNBEJPnAmY7Rk2ne9c2Pfo1ZkPn3UwqTmT3xfYNxDPbl4UUCGnTv0t8Rcj9k7JPTr+YNvY4njn+xn6yLSe8Qlc8glc/x3FF/vTTmsZBZjEVn6fr51uQW6mUkjApgv46OnF6qyM2xZ8PeLyd1df0KW7zwXTV+vbmDPdiNNaM3e036cZHoF7ANS9t5OawTSxWqNPVMNnJbQ7b/VRHPiiWEe1RP9H/mQnMoqFCDdrY9RooFtzfkjQ7OAgijt4aW42sGBcHo1hwp5CGUETylCW7a4nHSRIfuCKCIL6PP9IVc7eLfS+sYdV5+hml9tWDnB0g7DVvVdT+Xgkr0DKTuHsWHFCxQhRTLt4jSM4UDULAyl1tHQBi7YDW66NIoQ+4RkN2JElgeiZ0rZ/ejzomoM57d5oG/yyt+25wtDfjuZkjHyuRBWZIi+GIH3Jf8H65hLrtBkjLFOnewEhZQTWbx8l9WyFA+2yPhtY//nQWF5v6WWt9Pxp7fnrbtVIMqZWL6n+vmybZRDgExlS/YNDTp7+BOwPA5UnfukBC7xPceoev5YggbzMS91VxY+JVJRFYm9AiedhmhhQke/CB17w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/29/25 10:26 PM, Dev Jain wrote:
>
> On 30/09/25 1:54 am, Yang Shi wrote:
>> When calling mprotect() to a large hugetlb memory area in our customer's
>> workload (~300GB hugetlb memory), soft lockup was observed:
>>
>> watchdog: BUG: soft lockup - CPU#98 stuck for 23s! [t2_new_sysv:126916]
>>
>> CPU: 98 PID: 126916 Comm: t2_new_sysv Kdump: loaded Not tainted 6.17-rc7
>> Hardware name: GIGACOMPUTING R2A3-T40-AAV1/Jefferson CIO, BIOS 
>> 5.4.4.1 07/15/2025
>> pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> pc : mte_clear_page_tags+0x14/0x24
>> lr : mte_sync_tags+0x1c0/0x240
>> sp : ffff80003150bb80
>> x29: ffff80003150bb80 x28: ffff00739e9705a8 x27: 0000ffd2d6a00000
>> x26: 0000ff8e4bc00000 x25: 00e80046cde00f45 x24: 0000000000022458
>> x23: 0000000000000000 x22: 0000000000000004 x21: 000000011b380000
>> x20: ffff000000000000 x19: 000000011b379f40 x18: 0000000000000000
>> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>> x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
>> x11: 0000000000000000 x10: 0000000000000000 x9 : ffffc875e0aa5e2c
>> x8 : 0000000000000000 x7 : 0000000000000000 x6 : 0000000000000000
>> x5 : fffffc01ce7a5c00 x4 : 00000000046cde00 x3 : fffffc0000000000
>> x2 : 0000000000000004 x1 : 0000000000000040 x0 : ffff0046cde7c000
>>
>> Call trace:
>>    mte_clear_page_tags+0x14/0x24
>>    set_huge_pte_at+0x25c/0x280
>>    hugetlb_change_protection+0x220/0x430
>>    change_protection+0x5c/0x8c
>>    mprotect_fixup+0x10c/0x294
>>    do_mprotect_pkey.constprop.0+0x2e0/0x3d4
>>    __arm64_sys_mprotect+0x24/0x44
>>    invoke_syscall+0x50/0x160
>>    el0_svc_common+0x48/0x144
>>    do_el0_svc+0x30/0xe0
>>    el0_svc+0x30/0xf0
>>    el0t_64_sync_handler+0xc4/0x148
>>    el0t_64_sync+0x1a4/0x1a8
>>
>> Soft lockup is not triggered with THP or base page because there is
>> cond_resched() called for each PMD size.
>>
>> Although the soft lockup was triggered by MTE, it should be not MTE
>> specific. The other processing which takes long time in the loop may
>> trigger soft lockup too.
>>
>> So add cond_resched() for hugetlb to avoid soft lockup.
>>
>> Fixes: 8f860591ffb2 ("[PATCH] Enable mprotect on huge pages")
>> Tested-by: Carl Worth <carl@os.amperecomputing.com>
>> Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Acked-by: David Hildenbrand <david@redhat.com>
>> Acked-by: Oscar Salvador <osalvador@suse.de>
>> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>> ---
>> v2: - Made the subject and commit message less MTE specific and fixed
>>        the fixes tag.
>>      - Collected all R-bs and A-bs.
>>
>>   mm/hugetlb.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index cb5c4e79e0b8..fe6606d91b31 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -7242,6 +7242,8 @@ long hugetlb_change_protection(struct 
>> vm_area_struct *vma,
>>                           psize);
>>           }
>>           spin_unlock(ptl);
>> +
>> +        cond_resched();
>>       }
>>       /*
>>        * Must flush TLB before releasing i_mmap_rwsem: x86's 
>> huge_pmd_unshare
>
> Reviewed-by: Dev Jain <dev.jain@arm.com>

Thank you.

>
> Does it make sense to also do cond_resched() in the huge_pmd_unshare() 
> branch?
> That also amounts to clearing a page. And I can see for example, 
> zap_huge_pmd()
> and change_huge_pmd() consume a cond_resched().

Thanks for raising this. I did think about it. But I didn't convince 
myself because shared pmd should be not that common IMHO (If I'm wrong, 
please feel free to correct me). At least PMD can't be shared if the 
memory is tagged IIRC. So I'd like to keep the patch minimal for now and 
defer adding cond_resched() until it is hit by some real life workload.

Yang



