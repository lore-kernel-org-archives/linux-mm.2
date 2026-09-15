Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D062C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 07:16:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08FE6B0099; Tue, 15 Sep 2026 03:16:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E1126B009B; Tue, 15 Sep 2026 03:16:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8B26B009D; Tue, 15 Sep 2026 03:16:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7486B0099
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:16:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BF181A518C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:16:21 +0000 (UTC)
X-FDA: 85215138162.06.A69C075
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by imf06.hostedemail.com (Postfix) with ESMTP id 07BE6180007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:16:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=qJXwduYZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of "prvs=3718115086=yun.zhou@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=3718115086=yun.zhou@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789456578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DVqg976GR3x4ouGVyl1R3iooAyYL8euywhCsAVMxd3w=;
	b=Mvei5RunG4N+5w0rhOgt24/gIwTbGmstEZSYqv9ZJPEwkMcDVVf9yCvFCDrLcMiDsagYI7
	xZsQPhqZpfCT6coln2iUhY+v9XtJDqjIljgMICrs/HzYXp696V4Mxsh34ZqJyJnWuSkjHQ
	dADzv3+V0QztAr/JGLjX1tIWNdKkrA8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=windriver.com header.s=PPS06212021 header.b=qJXwduYZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of "prvs=3718115086=yun.zhou@windriver.com" designates 205.220.178.238 as permitted sender) smtp.mailfrom="prvs=3718115086=yun.zhou@windriver.com";
	dmarc=pass (policy=reject) header.from=windriver.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789456578;
	b=vi2zQgnZ4c/09KjICyeyPZgJDS1JMu1B4MZKPSNO4CRXLFHUlVIsA35Wu2hxcWrrxG67hg
	cIK17exkUmcxwUmtMQZNG4YNgVluCHPHxI7NQeYLJGE4XES4SW8bKYWn0/GV+ORwtWluBp
	hqVPbKv4vILGJVkl02R5VKZHvS4qsqQ=
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68F6asQQ2946957;
	Tue, 15 Sep 2026 07:10:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com;
	 h=cc:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	PPS06212021; bh=DVqg976GR3x4ouGVyl1R3iooAyYL8euywhCsAVMxd3w=; b=
	qJXwduYZYOaCXraSq5mBUGMrfGW3W+vdQEmHUGh09IaNGaeJBHe8Mqcr0e5pbgw/
	cRnt333cZvw8JBRk0zicYkg4t7rN2oNt5AzfrbeYljTQhxRMGXkBaeiPsYaO1QSi
	MPmFNUDYOurWFMK3lUXCVTBwooLL3EDGreSbEDmMwwKusx+mZlOG6TI83JaQdYZg
	KOoGMxYFBmZx+yXTJ54/UAAQI0dO44jltumeiqHAqCfqggm6YiMpREVcxloOlf0c
	vlgcwoa0wPkNZuFQmLcxOIIXO31ppaFSARmKVD7uiGLlf7ANRVulRXXiIGH/OEUp
	Ieh9b9hwHfHlNj4TH+bBHw==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020128.outbound.protection.outlook.com [52.101.201.128])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 4gmxxnnhpj-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 15 Sep 2026 07:10:10 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S7cKuED+widYZIUGKwcnlj3GmXvaFuamwMFDMMp7ld5+DWfwldbNmprJg8LoWm97eoIkUj38dLcUXBw5wYLdC3LpuhDX766Zu3XdKqyakg0OAmHk6RkmNTatOdlZ49hqxwIAhKlUyv9lQbU16KKmxaxB/Meu6Tinui/20yR390orU5bs4Y0uIL/dER/0nLlmJZ/0UZpwfETgW/T0Ok9juqbsOHfyJR8/cXZRtu/7Ke+05cGbAjiTNCydR3RLzWNKAzRBQ7bswEvpGLgIe4pWyVdFXnDj7XmvFsnzcueNYzuxcDZ6WHPTO2IAqzZRNYSvXdIuF/E3GBUQEmaTG5vdMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DVqg976GR3x4ouGVyl1R3iooAyYL8euywhCsAVMxd3w=;
 b=LnmRL0/jzdpJi+vB2QFzHuYiJ+imVYC7/Qw/3JK/sxg1kNNSCV+lnGLPgH7lSON8iNRTzOa6GoQQ2/guxg5E4yn/rx2yiIcFxH+8ZcyHFGGAziLOWhrtDmaCD+qfpTZp3ivfsEJvQ5AahnoHQUOSMy5uVvMQEgvjjyCXQYXwIVyzzsyr+X8Db6DNXYOHb/MFQyapPvrx+N5DmW18oigbWmdf1SPXTwy4HgPZhasWp35qaCLZi42EoD8uhQ+AW6Ix9gybUBbaAyAIh18NiQfcL6cZr3KNuvv4Utpvxl2JjdvBzTZEfC7zZVbnTyybsjzgxeSFvtQrCdg5X/H70bVrUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
 by IA4PR11MB9177.namprd11.prod.outlook.com (2603:10b6:208:569::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 07:10:08 +0000
Received: from CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13]) by CH0PR11MB5332.namprd11.prod.outlook.com
 ([fe80::8f86:8d08:45bf:ec13%6]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 07:10:08 +0000
Message-ID: <38377447-ffa2-43ef-bbfa-43d05decda1e@windriver.com>
Date: Tue, 15 Sep 2026 15:09:57 +0800
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
To: Christoph Hellwig <hch@infradead.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
        akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
        mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
        ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
        shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
 <aqJEWmUN3Jsajoyl@infradead.org>
Content-Language: en-US
From: "Zhou, Yun" <yun.zhou@windriver.com>
In-Reply-To: <aqJEWmUN3Jsajoyl@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SL2P216CA0094.KORP216.PROD.OUTLOOK.COM (2603:1096:101:3::9)
 To CH0PR11MB5332.namprd11.prod.outlook.com (2603:10b6:610:bf::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR11MB5332:EE_|IA4PR11MB9177:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df308d6-f6a9-4a16-8fc5-08df12f85fba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|56012099006|11063799006|4143699003|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ia1vA+/71tApKpP8MIQLHK56nA/qs0ECRtJVOvJV2h7uR3NyCVKyzDYLzI8OrgZreUMVCokBIf2zmvW3Ja/DP14Wv8DTwlNHKKU6xeF7ErCLDYr8LXmFzdDA6MWI/e5Z7czpaBf2xsC6KWkVnAhFMP/Ap1zVpDHMwYwZwPziaMPoON88xz6bKWygEWW1HSExCZhJ4+yxTRa23DPsAo+oU8Dbsa9V7FlJOGHaV5Zs6YWlwT4MQf5xyB9nTOfng+LjFSXg0QdUXKmHdqJvBYf1E88BNeITmQpzt/BudzlRwxICt+vs6NN3rDDaplRsRH4sCKvME5LK8NZI4eGkDIYab/z0ZSAVHYCBuwfb5rCTKF3AXdBUtfAtJnS+0e+mAWixNa0NSK31HXlz3F4ikfDzCrid4aoNzjsSWEt/hGSKLhFxNc0AVoiKNCZh+rVMSEKKZetQUSpYEoNHH7CfEKVTy9dT0eTXIqokIzBwngQbr51BYIphZS6oEGozT5L3Sc/keEhWdNVGg6XYOrNyapi99iAcefi5jP+PUHIXe5dWt10xvVT6ZJQLuv97L6rZkBdtCcD2VdYM7If+BUMvQil+2sJ/ItcpmsdzOI9RDbxCCD3sGTi+5f6Rf1WiLfCvGmwdD1S22988zPQcHahSIXelKTvz5mQRnN+Ca/9zkitfv/w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5332.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(56012099006)(11063799006)(4143699003)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aUJDZHZnTkppVkx6UnNhWktjL3VoaVA5M0dOM3FySjRrelIyY0VXTXh6Y1l1?=
 =?utf-8?B?b3d0ZVR3TkZCbFFHMUpMR3lhd0FhS09SenBoRTl1dU1hYmVici91TkNudzFo?=
 =?utf-8?B?N2hhUFpzUk00L2Y1TkI0VWs1V0RrT004ZW1EV3JnKzV3N2dRR204NmNhYjJF?=
 =?utf-8?B?QjZWVGhPUGxWbXlFRGV4aW1FaEtUUmpxN2dtTWZ1STE5ZW1LKzhEMEJRbjNa?=
 =?utf-8?B?TzhzWFRBcGs5UGoyeW9aa3IrSjhhVWpsSjRPQ2F1VnJrQ0pMelpJd3F4ck9M?=
 =?utf-8?B?MnIxUmt1ZHZYT0VrQXl1WlV1azJqckNaSVp1SlNxTko3SHBOeE5OVm1nWDRJ?=
 =?utf-8?B?VHphbmRxNGY4cFpFdTB2aEtteXBacUlqaUliQUhocEp2Q24zTUt5bGtlK3lC?=
 =?utf-8?B?dHRFRWVwaStFK2grTFVMYjMyS2x3dTlPdXM4bkM0dlRGVVNlVzJMMmlEZVVk?=
 =?utf-8?B?VWdMckFvYk1yZWxuZkp0L0JGZUl4REphTG84V3dBR0Y4Q1F1RDRQbmxtM0xk?=
 =?utf-8?B?NVZ5dkI4M0xCaUFhLzMrdHZEY1pvSDV4cWpocDNhUWxKL1I4SVRxVFo5Q0VV?=
 =?utf-8?B?c2xyb05nbmI5WlUxVW5tZ2hzZEFUWlBxYk5nV0Exd3YxNTNqbWdBMVVoTGtq?=
 =?utf-8?B?SEk1ZDhoajFVc0pDaTRsK3A0TEtXSWlLZmhReDJuZS85Q3B2UXg1am1UTVFB?=
 =?utf-8?B?SVk5ai9FZ2RFY2V6UGpETkhrOG5EVFBrdllTTFE3VzNVNVV1d2J4NmhYaFRt?=
 =?utf-8?B?VGQvM01LSlpFNVNhSXQyYWhGK3hOcE4yVnFEU0p4bHh0SjFlNGV3MHR6bVd1?=
 =?utf-8?B?WE95ZXZsWkZmMmRQbGc4c1ZwRG9EWk9YWkV2S1lIU1doeTZ1NXZjT3VkcDU1?=
 =?utf-8?B?NHp1cVpwbmE0RStKQU9RMFFnSHp0ZzI5NFQzOS9oczhuYURJb3JRWXVUc0tM?=
 =?utf-8?B?cGI2UXYzY21VbnFVbzNET2R2a0I5V3B2cXZiRDEvUGxZdldlM21uTURuZ2t6?=
 =?utf-8?B?WFpUM29YY2Q0YWJhd1ZYMEkxZis2cUMxVklUeFRtODB2UnR4QXp6R3Rid0pN?=
 =?utf-8?B?YnV6a2xLSUxqakNUUkJZL2FYV0JoaGQzbmhsSHpCaDJKd2xYZ1RoNjJhTklB?=
 =?utf-8?B?a1VTTGZpM3duZi9oSXZFT2lkdHJ6Qzl4VUY3U2ZPMHcxTU15OTBBMCtrSWhz?=
 =?utf-8?B?dzErbFB5US8xdExjRzVYanB2a2ZKb3dHU29IQ2ttVlQyNjVBcGpjTlpsbm55?=
 =?utf-8?B?LzFWMEtidUZxYVFnczhEeFdFK2pPUnpOajUrdldsb3lTb3hRaVp2N2IxSG5i?=
 =?utf-8?B?OGh1NVVXdkZKS2JaTWJ3c3YxaUZJbU9YOE0xaTZJSWdGQlNycDJodVVoZ0VY?=
 =?utf-8?B?SmFqb3dacWtvQis5QVpCakZxWlExTHRROW5HblROUDlrNWk0SDZJRDhaNHJm?=
 =?utf-8?B?YkwzdVg4cE5JTUNVazVzYVZadzZjUDFPQmUwT1RIcU1NelkvLzl3SjdEU29Y?=
 =?utf-8?B?WlU2LzBWaFpmNzVnb2dPQXR4bGpEY1lJcDR5Qys4ZkNUR25jNHdDeDRyOFpp?=
 =?utf-8?B?TE4ycUxnUVZvYW9sMU8yZGdSd3ViUFRpdU1vRVk4ZGYzZDZSemROUk5IRDdK?=
 =?utf-8?B?TEo4aE9xSGZUbE9rVUpoODBGU3VZem1SeE5vMXF5aStySnRDdEhmOWQweEJH?=
 =?utf-8?B?VlFJSEZCMzB4d29VbXl0UFZrVEdDMW1WV1p1cGlKNjdjekJsU05tWDNVQk1T?=
 =?utf-8?B?KzVhRENGQTNoSTRQYlhMUE40WnliWXhZcFhQZndDaW0rOEk1ZVhqamU0alZx?=
 =?utf-8?B?ek52YlJqMFkwQURFRHA0Y0RJNGxKV3Y3QnV3SmxhaU9KWndha1BtdVhWOEdF?=
 =?utf-8?B?d0t6OTVxdmlaWVhCQ21BYXZta1BrUzRUVDQ4M0h3TlNLM3NIYXN1TGpwYkxP?=
 =?utf-8?B?YzFGYitqcXJvem9KZHl4QjFna1Z1cjY4VHVYNk1STzRLUy9TdUpjdWJLc1hv?=
 =?utf-8?B?UUMvZ3ZOaW9kdDFINFBDMFI5bHJCam42VG8vSWk3T21PbC9GdlNRcnk3YnZj?=
 =?utf-8?B?eVFvYUVzbi81WFo4UEVVS0p6ai9UdjdqNzBidnlvMmp3SUNSZkhpUHkvUXhG?=
 =?utf-8?B?NUR6NjBDZzFEQ3MyTC9Tclp3OC9kOEpmeW1OVGQ3aGZMZVV0bTZjMEVrL3p4?=
 =?utf-8?B?U0hpc1NjTGpXVlBsS0NpOEhPbXdLMGc1cmE2VlkyT2VGNnNVVHFXN2J2aDZ6?=
 =?utf-8?B?TWt1TUxIVEJEMngxZkwwc051VXlSaEFCRzBseXNsL29SUTR6KytDT3djNXpD?=
 =?utf-8?B?S2VvcTRTSVBueGRlRnpxSDlia3FuU0JwMHBsL09BaXE2bmNpQzhNUT09?=
X-Exchange-RoutingPolicyChecked:
	AZpbsy/7xFtHx/Sv2/C1lUNMfprswr0z6AOw/1B/PnWeweEod9FNRxdhvZ3/w3TbITTWmt9D0YzZ35QP+aoduB1yw8j0/RjUqgsqrALogIQBfs02sa4dv9j3u/GMDTXo7RgFLmJyRxOkDrf6FoeqsriJ26zE5Zgf87kvcML1VKSxVGbW31hQYOZ4BDzZf8VBlLt7c7q17nGxIOsZpt9xppusLmq+ULiTKJzV6I04z+4skst3/Dxi0TOTuSymAOeQluhs5NoqYk+zu1DY3jwI/r6zloqzErEG988Xb8SrHyz7DXaRR0J1/Lgjhn9PTPsX7qzv6MPBTwy7WQ79m5xmGA==
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df308d6-f6a9-4a16-8fc5-08df12f85fba
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5332.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 07:10:08.0223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hTRfg5omUth/lkESvenfnqjozRe1vXo6oDtMA2TGBFmh7Zjomandd74WVlW/9d4bVXhH/XJGeV8PAZow+qaeyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9177
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDEwMSBTYWx0ZWRfX1rJUDr7ByspJ
 jmpq4i9438N+pooXVBD0oDv75U4PkeNB8vN1ksaSXmvenILm4Oo2+Cefjdo/R4XT/QU5QuK+snM
 AewPehUROjUjHDby/UeVxfBIcz8TjM29J8bilhdnp/f/VTW+n+XA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDEwMSBTYWx0ZWRfXxBLUoRBTtbK9
 lQ1E9EGFCWoqdHe1wdHSlDFyYrSnPGBtshlyfoCz88g5RErFE0g0IIeL3BQjSBcEjKYRFhGSZaO
 T+0NFrvXpDNPRxxJ5NQBPsatx98/Vq78Z8RF0M7vPJb4cNMOn1X7g98ue+KjYgNOuUstnVbJOyV
 RiJYMp4+17TXn+eacfknLYg48iKHL4ksR+58aRg08djto4Kf4oSYl9uWz0l8AziKpO7eaYsu5kP
 MH4MS/C1dGybuzy3lf3TZBDGpwfE5AdYnNBfka6CnLXWBUC8Xki1zaK88EHcVPgjBP9gSa4P+Tu
 X3EJqYVYQZJv2TjjLD4UVuqvp9wvWULd8D4stzuB6rBjlHkZ1f/Uw8B/sOJyUT3iEklr3ojKQqC
 6UdfzfuvWnCaHrCyGDLLuvQ+U0itFM+TlmpCWY1apmCOsojUYbL3lBx/L/s7p6+lEKpv0YtsKSf
 vLJePfh0I+giIL0ycQA==
X-Proofpoint-GUID: KjWHkw3ntzdR0Kr38oGE2KFQfxVNvuSc
X-Proofpoint-ORIG-GUID: KjWHkw3ntzdR0Kr38oGE2KFQfxVNvuSc
X-Authority-Analysis: v=2.4 cv=R4mWitRX c=1 sm=1 tr=0 ts=6aa8ef52 cx=c_pps
 a=4KArvT8Zi35IyF0Kdx8dHw==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=bi6dqmuHe4P4UrxVR6um:22 a=klDOsUkWDRETUCZYPvoE:22
 a=VwQbUJbxAAAA:8 a=t7CeM3EgAAAA:8 a=Ho_WGFeys7JuTpoeC9gA:9 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_02,2026-09-14_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 clxscore=1011
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609150101
X-Rspam-User: 
X-Stat-Signature: ceu5w68kpj6pybz1tw7wnah8dyu4ijas
X-Rspamd-Queue-Id: 07BE6180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789456577-186474
X-HE-Meta: U2FsdGVkX1/Ftl7o6ejabrqf0sD0uy626p3j3pCE/w0GvB9nQ9YjhoQVZu9LBZIdL1lczN372es6of8MCK4EHahUkiEZyY1zhclaZS7IaWUvrHIp88hcvQkkP64s+Ax2An7CbtVh3dXdCJcNcN9aH6O+xgy1K9CZwEfjqdGvTppC9j7paQqLrzqd7RqwlVqJkG1liINWsyLHNf41Xx5jZW9J09D/Y3GJ6DyfrIwnt/y87ChmHjQVs8dgTYNzxz61K1Cjv35uhk8jvUybW1azr3SOZv1Uj0xXwqyv3QOM7N/fRdOr7CbJxgUQzl/tm8qjOVrWKpwEtr5SQxWTPxU77OQ4S4xPwB1Za4OGkq2UxLEEVPpNe97HeseMGyT4/4Sn25lfFNFZ8blHQliYn71Wz41EDgKwmw2NwFTqAlclVrg8jFC2wZfmoyJZEMvJIQr6/T5Y0G7INwct6xLZ25IIL2N+1+CUyY7+PhHhMk4ge5FOJmBkIJTP9lQd41w8PmW7jgWaVfN4mLepmpmDEQdnk9cBXzQzJkMwa5F+z9P/pQWrxJVK0qJ/4SOoc8k+RvS6uncjrP/JiNPFJn7mLMpwWiyvg3ntCh+7mTfmagBW994vRVDZsT9SKAyFxfkKziEKPKRqh7+/rHqvIsLCoTdWhNgzDtGBsMkxM0vnEFQWKJAn4y4Q6u7oEzNokeHNjUoSrIHWWQePPQpNUvtyQFCJs/DLCXjEStUDKrfa5IDypn6d2gvHGtHRcNyLtVuRd5sDw3Qa29ZZcv53PBVZgf8s1KynmLjMryHAKDVFRJhv7DYy0KptHSR8z85/JYeTBAtV6sX4bX6IFt3XIilg3j53Zf1TID6yic74275J5U5hRjiFsKIdauZdqi9zva7kTpw3nwz4xAVa3lpmojhp9YxqY0aPi6kkJHY8y3qkXASnNYlMvvJcEBteIqqAXvGEmULypqY1wiwx0gWD8Z419RG
 VdXFb4O/
 xKtM2CcR545CJ/9ZkTQgxxqheHh7M3JU/4kllmvh860PSTgabAEhMTJS0RyTJw8DQ0xQ/7nL3AbMJKk20WUB0zbBoPriqdskiGjiVDMGRMgAjtuXg93AGhJ1k9/1PgxXh1Bin7nYPJ4C21/0sNV+qpmkt1rF8882eZaQMWzCapICbs3ccBbn/2f+lHvpqR8UdS2iJpuXpZDTKuJfoqZIX3wRCgCrbQebFVb2ya126CQJLYRCdnJ8205gUEr/q+eQ8xyX7bzcs8PQ7oycokARw9rYdmEv5bSxW2DDGoUKTsT88Syv1cnq6+3YznY/8eIev+BJW7YQeIGGaGCySPTHs+rftDT1l85x+zcfJ/oEtmyMXyLSqkS7kdRo+ECwOdCUUJpDVIJuuhNLCyxoLVtbz8mZTJbwYTnZzd4kKofukRW1BYJ7ki9QL+dpG5XWaIwK4AMdlMObY6kh9OPgb4LcW32YV2DZlAAbYj2527QRCEkpQdNWsH5VqcM3xdcd5rymc94kK0unGGZt/2RKj9CScfchc1rCXa9XuvijkZWQrOZYJj1q8uuFA+Mo1pz9e4Ry014vuE+rd7N1jjYdHNAzYIy40SeNVecAsXP74KdvjSdR0FMn6r9Mx6JMbFFATPCHPN1mkmCi+tRbtQTZ3QaviV4DL+DB27QliiW2B4OtEWUCQwqFJsZYAUTYB6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/10/26 13:47, Christoph Hellwig wrote:
> Adding Yun Zhou, whoch touched this area recently.
> 
> On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
>> xfs_btree_split_worker() calls xfs_trans_set_context() and
>> xfs_trans_clear_context() on the caller's transaction, overwriting
>> tp->t_pflags with the worker's NOFS state. When the caller already has
>> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
>> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
>> the caller's NOFS protection.
>>
>> Use memalloc_nofs_save/restore with a local variable instead so
>> tp->t_pflags is never touched.
> 
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> Btw, if you have some spare time, it would be nice to kill
> xfs_trans_set_context/xfs_trans_clear_context as follow up given that
> they keep causing confusion.

Yes, you finished reviewing this patch [1] in July. However, I'm not 
sure about its current status. Perhaps I should ping Carlos to check?

[1] 
https://lore.kernel.org/all/20260720050522.3101824-1-yun.zhou@windriver.com/

Thanks,
Yun

