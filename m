Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13202D46638
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 738406B00A7; Thu, 15 Jan 2026 18:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7103B6B00A9; Thu, 15 Jan 2026 18:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8126B00AB; Thu, 15 Jan 2026 18:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD6E6B00A7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:16:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA5A21603E3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:16:17 +0000 (UTC)
X-FDA: 84335758794.10.83871B9
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id EC844C000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:16:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pd6puINf;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.70 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768518975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NN1GxXDBNdstytPKTXTsb0uKd96L2dqnbLUKD7V0S0c=;
	b=CfzjUDfapf6Bcbhrpyjx957F2K64hVbiguK1y7pFa8pvQwV0CzVq6RPEOmM4lsYQovWgA4
	FjSGRFKotVa20YTMR64x+4wqrurpwsMuJ3Flzwfun7QdFA2a3T5jj+44X5VBpOR4tOruXw
	XyyygdwceMT8b4Vi9L1mNGf75VIjL4Y=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Pd6puINf;
	spf=pass (imf28.hostedemail.com: domain of balbirs@nvidia.com designates 52.101.56.70 as permitted sender) smtp.mailfrom=balbirs@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768518975; a=rsa-sha256;
	cv=pass;
	b=NeATd+BxUh7syKBhomAgo9PLfN4pzSXBw8uLWjMEX4nBGy1y6AFuWoHBMmEHMXwT7cHgvN
	gTnjFCg5BJwFsL0XF6DIbh6qrDvQ4zHo72VJLhHpdE28v+xbpmj2mNfq1lxG8vRYDzbfNr
	UrSUbZwecsfY9Wsg+TacfCKNRjkvPWQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JZBT2rFINepoMfQs0E7c2Olxd9eBr/QRb9DdxOE72cItDwuFB5dS0xgjBFB5IWSrnZUtHIi8dM/ywwfYX3I4QRhVgUgFF6+LUE/u96U8P3Xmi5ljEkEYEU9bnq4W/8+LZvpXLL4TiWfsVP6qId5D991MxovpBSR4s1xB1E4hZ4tcoVJXYuSPKnTANpxx40qydawYpmo0k3cMDE49vz9ZwcsiTIZGTYcPj4IuqrFySMBAQuMlBZ9SGecGXeniM8DUucjNe/z7PrEBwkwei/C1KlOuTnurfNiwznjWROitClgjNWsYLzJ7LFzU8xMxBhyoctokBuJ6ZI+mdjNf84IN8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NN1GxXDBNdstytPKTXTsb0uKd96L2dqnbLUKD7V0S0c=;
 b=AocQKiGts5UbqC9saP+htlTkvhnXJSpoGHGnXjFHRzfBT3FSRUkQr8QoPxhHtGjAtY5YF6MRHHREr8umdcLN7mbwWVnvO40WhB0TqRfLyCyKtHpTwBudVSWVdYvnp7XK0WAU7lisMpNtrkZegGrmiBmPXA8oGvIJL8xKnmE7FGC93RiHIRkXKIv2X9TstbUkjBaq9YdT/E4zxR7tR38LFJWgw36kGsRYkTiDX+53Lg3bhg/DB4AIrrEDjodXg5+RrGHbzSfYmAfgA86XndTxhQCqUJRwHNh3mCRgiBKwZ9giUCCuQ8w27TH8rP2Yl+owiR7rnLAMXSNLb35HFoD9ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NN1GxXDBNdstytPKTXTsb0uKd96L2dqnbLUKD7V0S0c=;
 b=Pd6puINf7xd2bAdGwWERwWtkmF/05+QCvievdkivLiNUGfEB5btUh5inw7OlGFJB59mfLksUebrQC7fJoWDGQcNbQ17JlDheKwqh0G6tHJRv0iQG3I2edhTm7hVxFX4Wx/yIX3iWf/LWjFn8jP4G2gbYlDcPAmtQVx4IhUrx231sHdR6NXO+5HVBjCrM2PyO4QHLyfsSWZfn7wrvbFiF74H4VnWnRDKkaV45mjlpJNKAtXnPWWr6AMUSA64juaQsuJJei9Zm22jnwd+d4WbgZlNR+I5ZHG27QTBIyf3D/QjpYmCkO8eOXJxTcMVEWM/EV/KvWAAp+6XbxlT+TUMYYg==
Received: from PH8PR12MB7277.namprd12.prod.outlook.com (2603:10b6:510:223::13)
 by SJ1PR12MB6195.namprd12.prod.outlook.com (2603:10b6:a03:457::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 23:16:11 +0000
Received: from PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4]) by PH8PR12MB7277.namprd12.prod.outlook.com
 ([fe80::2920:e6d9:4461:e2b4%5]) with mapi id 15.20.9499.005; Thu, 15 Jan 2026
 23:16:11 +0000
Message-ID: <65cf6d71-9440-423a-9a70-b6b40622440e@nvidia.com>
Date: Fri, 16 Jan 2026 10:16:07 +1100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] Migrate on fault for device pages
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>
References: <20260114091923.3950465-1-mpenttil@redhat.com>
Content-Language: en-US
From: Balbir Singh <balbirs@nvidia.com>
In-Reply-To: <20260114091923.3950465-1-mpenttil@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR13CA0174.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::29) To PH8PR12MB7277.namprd12.prod.outlook.com
 (2603:10b6:510:223::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR12MB7277:EE_|SJ1PR12MB6195:EE_
X-MS-Office365-Filtering-Correlation-Id: 9484743e-3c41-4cfe-b2d0-08de548c123f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|10070799003|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NzdOZzV0SndGM2RHTnRBektKZWRWNUFDdDlhejJoNHFSN1lrSUFNbWxHNXRq?=
 =?utf-8?B?UXY1R3ZPYWV3Vm4yeVR5YnFJd3VPY1BDZDcrRTZ3Ty9JSGh3eHluKzVyVlRO?=
 =?utf-8?B?VFBNYTVoQnZibitqTXVNeU5sUzY1TG1DWVZtemt3MUNEa3pHK1VDbEJ0Q0Z4?=
 =?utf-8?B?cnROSHE0YWI4QWNaVkxZeW94NkdCakREUkxDSWhZZ3dGVXhlbDFMTmxyd1pQ?=
 =?utf-8?B?SVFHSzNtNjBxU1p3QkN4NGNFbEs1QkxHV1RxdVBPcDNYaXRMUENHRXdJVktZ?=
 =?utf-8?B?bUozTFFYaVBBdndrMkNWMWNUMWYwbkhvK3JUVjUwTGxvY1JtWW5XVW8xcWZF?=
 =?utf-8?B?RGZqVWkvNVZZc3g4L1MxbUFSSWtRZ01LVTZmd2hOeXFJdjZpQzJETjlFbUky?=
 =?utf-8?B?YXliazRMa3NkdVk1TysrL0RiK211ZUw0K0thVDlVdTRQT2h5aElMNW1aa3B1?=
 =?utf-8?B?SXZzRGhKL29XV3BUTmFoQ2hLak55NmhpS1pRcHp4ZWVTNHNPWlphc3NaNU84?=
 =?utf-8?B?U1NFZ3NkZGk3WXQyaUhLdGNIVEErS3k1SXg1OWhrZWxxYXJaWG84ZnlLSlRx?=
 =?utf-8?B?b2E3b1lSVThLTWZyM1VrSTY4WE9pL01rMmZVM2dFSlZ1dmI1QnA0QXRIN3hw?=
 =?utf-8?B?dnZ0YjAxUGY5U3g4bElYV3d5VDlQWVdFdHMvbVNQZDAwNFVaTXc4VWk3bFlU?=
 =?utf-8?B?NStnOFZPZnBvbG5VWXlkS1B6ZW5aUDl1dllyUmRTbXBRNUxOb0Npem5ReDVL?=
 =?utf-8?B?MTVLN3pzM2tMZlBPUUpDY3VNaE5LSmhINUVSL1NyZmxjaUIxcno1S2ZmMXRt?=
 =?utf-8?B?dU02QzVJODEzYzk4UGlHV1dsVWVoS1V3bTdCbmNzOGY1VnhudE9zRU0ydWJH?=
 =?utf-8?B?S1ZLWTFvQzAwbnkyNmFOdmNWc3FWcTk3bk9maTBER3FORWdVYk53QUtUdE1Y?=
 =?utf-8?B?VHJSM2xudFQ4TzZNbVBNVlFqdUNNbE9wejlmb2NGeHZwbklsbmNSbk1BN3p0?=
 =?utf-8?B?L0RpLzdWWVp6N2NFOFFEVjVJMFhkOE9UbnpoZGpiSmFCMFR0N0FxS3JmNmRp?=
 =?utf-8?B?WS91Q0pQRTg1Q21rOStadkxZN3EwM3YyV1RYYXB1QXl5WWcwOG94Q1VNdVBQ?=
 =?utf-8?B?R2szT3pjNHZreW14TjhReTZSV0ZnMUN1akRMa0xvdEZCdmUxWFhXVGhlbnla?=
 =?utf-8?B?Wlh2YWd3ZitaVHlDUnBxaEM5azlUNUNlZGxTTkVFd0xZTXVlYi8zdHVTd3A5?=
 =?utf-8?B?VFdQaXRjVnZJZ3RXWjY5dHA5b0dlT2phWXRVNTI4enExUkFBNkNBcTJnZDRx?=
 =?utf-8?B?MVA1Wm1VdDlXU0MxVk5aVDVkSnhGSUhTUXVYajBrYTA0TGt2cXpnZk5OTEtD?=
 =?utf-8?B?NXZXM1A0cWhobi9UeUdabnNYWFFWeGRjMUZaekU3WFV2UFFFNGhkdENRTGs4?=
 =?utf-8?B?V1hoeXhSdUN1amVKUDhJODRCQURMekpNcVh3L014OXFBRUpCclk0cVh6citZ?=
 =?utf-8?B?WWtLM290RmVHbnUwZktFc3ZPN1F0aEFIblZaQ1k4SDloV0FuVHdOdThRTHFJ?=
 =?utf-8?B?ZlY1V0ZydUJxWE5JYUN5S1hsemdpemJCK3pRT0U5eGdMTUQvam5PSWpla0hj?=
 =?utf-8?B?RVIycTVCdzZ5bldtODZFQUhRdE5hSzM3b2V1a1lXNUNtQkVUUXZpcEVHbSs3?=
 =?utf-8?B?UmFoQlBNd1VRNi9La1ZmVHBqLzBhN2dUcG5pSGsyOWM4TXVDUHhwSGFTdU90?=
 =?utf-8?B?S3NnWSsxaXNuNUlwdkZuYVkydXBKZW1LV2dLRGNRV2VTZVdxbEZOaDF4a0ZS?=
 =?utf-8?B?VEo0TW5DNzlMbFBUZGdQZjJnNTM1aGdWbmR2enQ1QUlHVFQyNW9NeHBIM0Ey?=
 =?utf-8?B?c1VuM1B1SUh6SEF4cDFJV1NoZmNtNHprR05PVVhXdmtlS25UTVUvRFJSbWE4?=
 =?utf-8?B?SDd5QmRNT2U4R0FIdkhGSDhVc0hJcjZxMzdXT3IwL0FmV3pPaTJuN0hDK0pC?=
 =?utf-8?B?S01uaWZ1S2RWY1l6VDA1U3UxS1pSUFo4bFozVDdjSXFGTG5ZTEtnRjhFOU5F?=
 =?utf-8?B?aThOcWhFdUR5ZXRtUTV3dGVaemNUZ3NNREJTTTA2K1NhcndJQWZmeDhjYVI0?=
 =?utf-8?Q?uInM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR12MB7277.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(10070799003)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aGllZWdLNG53ODVUNFBPQXhxWUs0TzRXKzhMaXlRamt5ck9lTVdkdHJLcmpI?=
 =?utf-8?B?VUVBNW1kUldDQlM4ckVYYTBlWHd1RWlyRCtHK3BZaFpwazFuenU5L1NWWXF2?=
 =?utf-8?B?WjI0WFNmYkRtS2s5emJJNDlpV0RvZTc0WU5IdTUwdGs1VVBQS3NNMEszdzRB?=
 =?utf-8?B?aVVFanliK2VOVU9Ya1pkeW1sWlpLYmJVdFdzRkVmbm5iS0d4ZStmVUE4VWhl?=
 =?utf-8?B?VWV3M2Zzc091SmxrRDJvRlJMN0hRWTFjNGNzYVd6eXhTa1NYeHNIVXVlSkoz?=
 =?utf-8?B?cm9WOEE3c3FsS1MvTmFMYjJZcWxjNmR6NWZ3RFpJS2FGRHV4NHFRa0Z6dGEv?=
 =?utf-8?B?OWRZSnU1bjY4THRJd29WNWhmREhBM3IwNm5CQVNlTHhuWTlFRVAvVnFpdUls?=
 =?utf-8?B?bU1PV2JGMzgwSDkySjhFWGNMS0R0a0xDZ2h5c3NPbXZJQXFlejRaNFVENXJw?=
 =?utf-8?B?VHhSV0NwQVFWNk5VblRCTXNueUFhOXBYTU5RZGlhZ3cwNllpSm5SVlp0SU9V?=
 =?utf-8?B?Um5qYTVmYnRhTUJMT3RKWFdHdHh2aE10bktpNEtnSHNidVpReFN6RjdDU1R3?=
 =?utf-8?B?VStvclllZVI5YTdzRFY2WExvVjFWanNPSm9PWE4ycWxrUXlHODl6anVvejRI?=
 =?utf-8?B?SlV4NGxYcTdhNmpvSXRmZUM3KzdqUDJMVDY2aXZrdW9JaVBrTGJZaHJPdEdR?=
 =?utf-8?B?TFRMN1dyS2laZ2FCQTJCVnptS0VIYnBCaG1ORitLV2JNT0xScUxqZGRMb0hz?=
 =?utf-8?B?WCttdHdtN0N6eEwyUFRSamhDc1hvWnBBRU5uajFlbE8rZlVOVDNGTnpLOGx3?=
 =?utf-8?B?bVV0UFBmcTgyS3FpRXZXbEdINVduajhWMkhiNjBnVGtLMzZFRm1ybyt0cmor?=
 =?utf-8?B?M2dwdEhrcDVOOFVjaGw2WEp5cGtGOHVtenhXVmJSc1BGRmJmQkZTY2JJS1gv?=
 =?utf-8?B?dUw1cWdRT05SSk9adEY2VXIrOTA2bkJjMS9nVGZNbExiaExKZ1NuenBGajdF?=
 =?utf-8?B?Zm55RWk3OXhDQmlCeWIvY1RBblhuWWExY1FoWDdmNmU5Q0ZDWThnMms5VWZY?=
 =?utf-8?B?TVMvUU1SUkMrWTRCTmFndWJ4aUZNSG93bGl6TmI5RUMzdGZNcWR3ZE54bi85?=
 =?utf-8?B?dk5Mcnk5TnplOXk0cXcvdWsrUEoybTd3eHdaR0FTRTBBTWRKUEMzM1lhNVpT?=
 =?utf-8?B?NlJRMUhCWnNCVXdnWDZBMEYrQVk0L0JMeXZVOTdGWFlHWjdZbjY2L3lHeksy?=
 =?utf-8?B?dEUzc295MHdCcmNKcFpXOEJDdE9iQlNjSnRoMGt0YWF3d1ZsN3NiVm5qc2s5?=
 =?utf-8?B?Z0JsQ3RzNXFuemEzRE9pTmlFSlFxOXkrckUraCs3eEpFelU5RWpqby9mdFdI?=
 =?utf-8?B?VE9vcnhFWEg2czd6bmRMR1FFdVZGYVVjMjVxbjRXTzBFVXVTN0pnTGtTeG05?=
 =?utf-8?B?cXVsN0pmQWJBRzczZEhha0tmWWpmZ2VodHhMMWs4R2dUN1dyYTlVQ09IL1dI?=
 =?utf-8?B?dUpCNnpTeWp2V3E2YUFZdUYwWGRKR2lPUWZDVm9FQmJEVVM4dTZPTUJJZlR5?=
 =?utf-8?B?L1FhaVBTeDQ2VmlKSGhkZGJRbHdZV1JQSUVIMlFNYkp5YVJoYnMzaWFVRDVs?=
 =?utf-8?B?cGhxcHo0TW1yNEZZRXBmc3pxamhYeHVtUE1BTFlTeUwraXI3QjVIRWdCQndZ?=
 =?utf-8?B?SDhUM0Z3N1NIbi9BeEVjOS9UKzVMeXhhRi9URVdLUC9LTW9aMzJ1b3BOYk1L?=
 =?utf-8?B?ay9wSklaS29CK082a1NuVWNqT3JEOUwyYlhIZ3RNUmF0aGlSbGIydXZ0VFFO?=
 =?utf-8?B?TDNUMVlTMzBQZE9jKzFEQWxqNlMzZGdzU2dTME5NVkNUUEFJSnh1S1ZjN0Zi?=
 =?utf-8?B?bGppa1g3UU8vd3BFVGFyL2NYV3BBZ2R6R0JPZ2I4SlY2MFVOcFpuUmh6VG8w?=
 =?utf-8?B?dzdrcUlWMVZyaXY5VUttTkRPWCt0bmpUdm13dHZNMzk4Y2hST0dLQ3V1R0lj?=
 =?utf-8?B?Mllkemp3OHFleVdybUo2T1ZMdENSQWFsdTY5dXM3b1VvaUQ1bDliMG53QThX?=
 =?utf-8?B?Mmd5SDU1dG9ZUUlJYWNyQWV2QVN2UWN5WWxZWDFiQ0hTdUc4VkFseS94eEE1?=
 =?utf-8?B?d0lZSGFKeDZrWUdGeXkxM1NNYXM2QXMwcmk3ZnRRdythdms5YVZ5Z295TFIx?=
 =?utf-8?B?cVg1eXpXdWppWnl3Y1BBMXlDeXM3Qnp5UXVaNjJDeG5jNnIvNlp0MjhmWUZ6?=
 =?utf-8?B?endRR0h0eEFTTE9mUVBaQitvQ3ovOXV2eGVvUmxlM0FGSlM5eVJnQUJFWEVh?=
 =?utf-8?B?cEY4QnVxTlBJK1ROclRMUTlwM1JkSnU4OW8vamZuaWJOei84bFptSTViWUdj?=
 =?utf-8?Q?yvEGqOd0IOtUmDYyMQ5KgKhqCzH3i5qjKeInTa2vkfwWH?=
X-MS-Exchange-AntiSpam-MessageData-1: SivPWG5o5qf01Q==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9484743e-3c41-4cfe-b2d0-08de548c123f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR12MB7277.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 23:16:11.3285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6SQbIrr+paht3c3Uz7TnI7McVjNRHWz8KRyyZFW1uOIV65VrjytszcfgiVbCMdCR7zZR2MPwxzcJk3y32SoMDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6195
X-Stat-Signature: q78ayukm1b1ckw4uhj97ymaioxkq16gb
X-Rspamd-Queue-Id: EC844C000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768518974-160578
X-HE-Meta: U2FsdGVkX18PONZ0whK37WNGzlyE/PHAWqD4V8CsSbjmSwM1nNUFwKyENBHuxs1GkCp01opzfgiira7Q+c5HbQD7OGE6/O0wBLj/C64II//VmEAQtck09pcJfidCsTN88eawKcAcqCaj8SHqq27jTTdXo24CJKSJsRFokOgzuZf+zkJyyLr2LRkrR/Hkr6kh1KjLSI9uZmOZL7h/PfupxZM8gsdwqB0s2UaF5IIZ3vwDO9Bg5phBCBPUsdbTAblYJ2+PATyFfA0vno5HvRSUFePNV9HiQqI51O9RV2H1XYTxn1w5V3e80e8R65DCH2/rGzQ5vMCulrp5hMj8Q4fnq6jUP1iKLUjvWgeweMJKmvz+Ny8gfiabfmlUnysZgfJeR89zOFUImGe5vw1U+ZW/T10N0k/LQl01zDu/2oOglPEM7A3qCLvRhcd0G5I0/fb1duKwojb+1ekXZuzhdzljrHtSoE0oiQxxzioh+pEeEd6YOQYTBYq7mcdCAIxMU0v3cxMXnMsO1i7OAbR4fk0LhLQJuXgrIRYyyJAfUeyoL3rHhfnx3F/KHIgYVFJ+jl3X0rmpjomLJD6v70AfqNSb2d7+8GoaIEV6Q9bTMevy+W/ACyMOzv6RJ82ml2oFBp7crq7d7znC43uFVJBk7UuRX52sZaysnPvCKwFuyi1xeq3vRJwmt4CxKp9OFf1KBSYELTadKavHq4bJkd10ACcjFs4RIjUzeVyChFVgdi8rpSJZed96hSs5xxHI5GvrOdihyt23NoHhmiuKvqtHm+bXL+xYn4pNXd6ZODe5LFLi4nnBe2k3HjpXQOM5xRTBWJ5bxyP/YYs4EVJLTQZ/bgLtqQsoa+G7IU29tZYcP98aMcuC9vbh89B8nB/hu+00lzbUBrP5i2osS2nDRy3XJPTzSz4TTbPdDYzIEFt3vHTUuOQ9b4+MjrUMyZzxEoPju/Nlic768VLnnmx6j0aTMAi
 r4CasNMH
 D1u1IBLHXXZZv92Jd0yIWv9qyiV67UKAOgs02Kr15cL4PSlbeHidPJsIoaxAKNvNmae0AJycBQoBt0qkApu4RP4cMil65swEBj7ZXzzyDuk+bGZAJFgO6tnzy7Av8O160Xz9nH8btdBBI5cbAmNQw/XrsaeJhCYCNKsfOXqZWwvHB9B5TibyK5fh4yowgBBX9ezZOa9HgIWFToqvvyB432qYtuEndfF9Wahk8dW2LgT/Ks5gwd0fiETGMvmBO2/7KSj6hotn+FUTD1x2WdCD1jgv1JiPdo/8DEnGPOAgQsh0Y5MuDOKvV+sIs1VZSYLJmtEEXUT1I+ub3YTlMlD47CkIULWe80iNasVy8GlSV/Bfod02zwe70O/RH1Ui74sQ3PCb3OTLpJUSH5/0c/AajFves8FgNb3osAq3QiWtOE88DoCOek6RkQyOd1V5ZAY6UgymAzU2Wb5IQbcSpxOzygw1oC7K2aAvZrmGfozZVpAo9b/RKgnVV1zpJuh5Y3FLj+4TNGzt4c7bX5hM93qiFcv7qAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 20:19, mpenttil@redhat.com wrote:
> From: Mika Penttilä <mpenttil@redhat.com>
> 
> Currently, the way device page faulting and migration works
> is not optimal, if you want to do both fault handling and
> migration at once.
> 
> Being able to migrate not present pages (or pages mapped with incorrect
> permissions, eg. COW) to the GPU requires doing either of the
> following sequences:
> 
> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
> 2. migrate_vma_*() - migrate the pages
> 
> Or:
> 
> 1. migrate_vma_*() - migrate present pages
> 2. If non-present pages detected by migrate_vma_*():
>    a) call hmm_range_fault() to fault pages in
>    b) call migrate_vma_*() again to migrate now present pages
> 
> The problem with the first sequence is that you always have to do two
> page walks even when most of the time the pages are present or zero page
> mappings so the common case takes a performance hit.
> 
> The second sequence is better for the common case, but far worse if
> pages aren't present because now you have to walk the page tables three
> times (once to find the page is not present, once so hmm_range_fault()
> can find a non-present page to fault in and once again to setup the
> migration). It is also tricky to code correctly. One page table walk
> could costs over 1000 cpu cycles on X86-64, which is a significant hit.
> 
> We should be able to walk the page table once, faulting
> pages in as required and replacing them with migration entries if
> requested.
> 
> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> which tells to prepare for migration also during fault handling.
> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
> is added to tell to add fault handling to migrate.
> 
> Tested in X86-64 VM with HMM test device, passing the selftests.
> Tested also rebased on the
> "Remove device private pages from physical address space" series:
> https://lore.kernel.org/linux-mm/20260107091823.68974-1-jniethe@nvidia.com/
> plus a small patch to adjust with no problems.
> 
> Changes from RFC:
>   - rebase on 6.19-rc5
>   - adjust for the device THP
>   - changes from feedback
> 
> Revisions:
>   - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
>   
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Jason Gunthorpe <jgg@nvidia.com>
> Cc: Leon Romanovsky <leonro@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> 
> Mika Penttilä (3):
>   mm: unified hmm fault and migrate device pagewalk paths
>   mm: add new testcase for the migrate on fault case
>   mm:/migrate_device.c: remove migrate_vma_collect_*() functions
> 
>  include/linux/hmm.h                    |  17 +-
>  include/linux/migrate.h                |   6 +-
>  lib/test_hmm.c                         | 100 +++-
>  lib/test_hmm_uapi.h                    |  19 +-
>  mm/hmm.c                               | 657 +++++++++++++++++++++++--
>  mm/migrate_device.c                    | 589 +++-------------------
>  tools/testing/selftests/mm/hmm-tests.c |  54 ++
>  7 files changed, 869 insertions(+), 573 deletions(-)
> 


I see some kernel test robot failures, I assume there will be a new version
for review?

Balbir

