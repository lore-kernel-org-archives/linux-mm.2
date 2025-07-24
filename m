Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B34C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 09:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637186B029A; Thu, 24 Jul 2025 05:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E74C6B029B; Thu, 24 Jul 2025 05:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460F26B029C; Thu, 24 Jul 2025 05:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C0956B029A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:58:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DC64B86B5
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:58:31 +0000 (UTC)
X-FDA: 83698708422.26.3DA382B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3C2AE1C0005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:58:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PJ3UFuvk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="C/J8DsZr";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753351107; a=rsa-sha256;
	cv=pass;
	b=iCOcdEz2uAs3cfEjFLkSGdDZG5eJyoanpX1NSwcRrIGw4uu9qUEEdva//vucltDz0Wmtgy
	ezSfLr15tCQ9wxa/MlofXlEMMzICyAy/6fEtkoEJknvtqL0uLdgT+nQf0FTMwMj5//eavg
	nzv/4SCIcksSIitEf4a4IcMmIeFnxyg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=PJ3UFuvk;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="C/J8DsZr";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753351107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2si7F9RfH7Y7BNejSOCZ8KRCKc6bFtDTdNoAIRMDNxE=;
	b=1V/s5f9Z8e6Lmdt1SziUFkZyfVmcD3EzUIXkEi5jJcfz82HBoymWZZxhSyblYkRIOLvmmK
	PhYppxx9VENYYPfoZKKM0D4icdr03Ed+JiACBneYxl7UmiCZU8LCe26wY+Kn4taQQcd5ak
	NCw6j17xto2tHJnD3UaDD6wHYOze61Q=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56O6trnp007835;
	Thu, 24 Jul 2025 09:58:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2si7F9RfH7Y7BNejSOCZ8KRCKc6bFtDTdNoAIRMDNxE=; b=
	PJ3UFuvkYTlpVmW2wMgp4tEvSrpL8SDCQfQ1hlCv7T81Saj9og68AanYcmlUaISX
	bNbuF2tU9KCHHihHl8V1WZ1jMD2U8r5CfE9jFZuh2Ch+37FnsfCiM9smmESdGAVh
	zWWQRRzkoA4NeDOw2aaJQfnXh5pCN9L6LjOgfysRbMIHVH0cyH6tnFL1UdWHQXnE
	cRRQw5Ru/nPe8egUR8TCbKFZZ60i+mYiw5MOfr67IWozDEHcMqblKLS3kMo9mWra
	s7NeNZUNaUrt79EFoQIIQEescLnWZFywJgcUzjFmCpDv1sD3ULyB50LaEdHAZqgj
	MQCCnqq0pzf6bhSRlyR2ug==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805hphbfb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 09:58:18 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56O9598u006053;
	Thu, 24 Jul 2025 09:58:17 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070.outbound.protection.outlook.com [40.107.95.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4801tbnhv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 24 Jul 2025 09:58:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PuxXaeWYBEBV/TBPpvrxSRah/7jgBVzUV0iavtUjTw1Mm+DjNRVSIWBQqdDzMCiwgeEp/w2tcVj/kdUa9ijq8AjUgklzrNoOC2bOybOyekUpzf8uo03qk5rsi/OlQpSVN2wZpX4McnsCesiWPoIxYtZoB1S/2Yv7xKG280krw8QLxT5v6ZljlSZNgcdZZGSWxZ+JRbk1jO2Injtuyt9HLMU99rK93wPg78PXj4z1v4IJjNwpbnR0/4qXHvXJ7/hViFRZEPWJ2nkavBB4xlusH56VEQVlgvVY7DuTtc/1wcwWhxFl1CnGB6tArTgg5XEiwK9NyS6yqrNBvrJeC+9CYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2si7F9RfH7Y7BNejSOCZ8KRCKc6bFtDTdNoAIRMDNxE=;
 b=wK6AVvO/2Vm/6OaobEwc0iNzAggSxJj2FyEaOKyUAA6CzufWuBqb0F6BJknfxXZOitrpWOvFhKxnpNxXxiKGKXoRhuOEIRBgUph6p9pJh1XhpaESiWib+p8vW5cZrFogZiXlZxp2w378xaGy0Gss+ACmE0w6gMzXBYIDpCxz1T+zuO68wa00ZtqmP6UEs5sF33qMN7Eu+rrI//xQzfCgp/BUrYVam6+ZK1eurhWYUIzpEMrEL2A+6K3s0RFl+bCCpzUGVrwbITl9DtOXhf97okPcXYWPiR40q+uiPS8PxeYLxOS+G6nT1E1AIREtwKHGPXYln+NbwFzkCBeYdE28qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2si7F9RfH7Y7BNejSOCZ8KRCKc6bFtDTdNoAIRMDNxE=;
 b=C/J8DsZr9eyJyWmA+vPkcnTsxirD3Y/510QMoXUijotqJocsKprcGDfZWtH/M/3fvlbdfMet8zSgICr0yr7v8P8ltMl6932WIYuzXIa1wE4zL+/titk74EhvlTRu2d+8WxqqK9nA95Y1ewZ7qsPqClrtNl9Wy1ai8YmNu+Kk+cs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5778.namprd10.prod.outlook.com (2603:10b6:510:12b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.39; Thu, 24 Jul
 2025 09:58:14 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8964.019; Thu, 24 Jul 2025
 09:58:14 +0000
Date: Thu, 24 Jul 2025 10:58:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Huan Yang <link@vivo.com>
Cc: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Christian Brauner <brauner@kernel.org>,
        Usama Arif <usamaarif642@gmail.com>, Yu Zhao <yuzhao@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/9] introduce PGTY_mgt_entry page_type
Message-ID: <a7f8b628-14f0-49ae-bf71-14c4a3f4fd89@lucifer.local>
References: <20250724084441.380404-1-link@vivo.com>
 <86516155-f2d9-4e8d-9d27-bdcb59e2d129@redhat.com>
 <cc560d48-884d-4c8f-9fb0-565d74ad769a@vivo.com>
 <e9bb93a6-1e95-40e5-ad10-a60d80735432@redhat.com>
 <6d14e212-418e-4734-b256-b75c6fade25c@redhat.com>
 <23b986e2-80d6-432f-8188-7a11d6915c9f@redhat.com>
 <cd253bcb-3ffa-4871-ae11-59d158fafada@vivo.com>
 <f21b75f9-0650-44c2-bf47-516390364a8b@lucifer.local>
 <10484264-e863-46e9-9797-d2d76a531557@vivo.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10484264-e863-46e9-9797-d2d76a531557@vivo.com>
X-ClientProxiedBy: LNXP265CA0031.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5778:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ef917ef-55f6-4f7d-db97-08ddca989b21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGFuUkdxMDQ4K2FvcFF0aUZadE9mSkh3dlg1UzdDS0ZBZnEvaUxxNUYxMnRQ?=
 =?utf-8?B?c3dXcXlDOWNCeDMzQUtPZnU3QU1vamdzQS8wbnM5ZFFiNDhER3h3VEFJS2tI?=
 =?utf-8?B?TFphUXRyaDJBYjRwZDVTdW1uMmk5eUF2T3hmN2RkZmJmRS9yY2VkVjBOdnpQ?=
 =?utf-8?B?WG1ZMFp6YWkvS0ZFSWRLbjJGNS9CeFBXd1o3VE9aZHMxS3JjQys5c0lwcDdr?=
 =?utf-8?B?d1Fra3pZRCtqNjV3Qjlka3VlQkhaREMwQjVLYkRoZEt2UGlrNE83d3NISERX?=
 =?utf-8?B?SHRjSUVNallwY1ZBU2ZhcXE2czdvUnNVVmlxQWhEUFdJRGdqT3ViQnZwK202?=
 =?utf-8?B?SkNHYUNLZTVKdVdOMmpDU0w1dTZDM2FLaDBsaDJaZ0FCeFdtOUpDdVBwWk1n?=
 =?utf-8?B?amduRUtzaUhIb2MzYWZPMHZtbEI5ZVFGSHAreEtnZGFENlBkSEJkdG1xTlZx?=
 =?utf-8?B?Y2hEWFNJOXM5QkdJQlpIaVdTL2trajUzUDljbENQdERuVlRyYkFDZWRSWnd1?=
 =?utf-8?B?Q1Bkd0F0ZmhlZWxGSGNWUzFOdjZnMlM2MGkrY0lRck5OMnRrRXRJTkw5eFhE?=
 =?utf-8?B?MFIxZ0EyS3FUZldnVk5HYlNzbTE2R3FnS0RVZCtVMHgzalgvM3Z5S0FXeldu?=
 =?utf-8?B?QnVaZG9naXVIM2tmTmkrVmpkZUhEK1lySE9jSER2LytZajdKdnBQa1RhcnlB?=
 =?utf-8?B?QmxPcGI5THpoRHMwQ1lUM2l4S2tZV0VTMjRFK2tweTVnYTJ6V0dGd0tQZkhw?=
 =?utf-8?B?YzZKWVdCTXdrVklQTXBvcS9EZ2hPTFlCSkp6dVowMEFIaGZFWUVLSVJBZkRM?=
 =?utf-8?B?SS84VkpZWjN0MXd0ZnE2U01lZURiQjVScFRUSkJGcTUvdFBhRGJnZ3NDczV0?=
 =?utf-8?B?V1Y4eHVIaXIyR0ZrY2pUQmtCaERVY091NG5yUGViTjFYa0JpQWFJYkNSaTY2?=
 =?utf-8?B?dld0WEFvemFWOTJqT2daQnZTd0pSR3lqWmI3MENHajZjVURla3hWamxjUFFl?=
 =?utf-8?B?TERoUlJjd2ltN21TSForelJNR1lXQW5pUjlqQTZYVnJ1QjNNNHVweDRud0Iw?=
 =?utf-8?B?RFlhZm0xU2g0K1YrTnZVWDlndE1zcS9FSlNEZVlvdVFHVmFqRFRMd0R0S05I?=
 =?utf-8?B?VzdHdnFFbWp0SHdxRCtrN3l2RkluaFNvdlpxMEpTWmVFeitzbjZZWlVVdE5C?=
 =?utf-8?B?YXhLQnh2RG14T0ZtbkhCd0xhc21rMTd5WUVqdkI5WGxhMElIdjRvTUJ4Z2ZU?=
 =?utf-8?B?L1dla2V0MzIvWk5xa25ieHI3NlllSC94c05VVVRPeWF1MEY3ZkY3bHF4MFNS?=
 =?utf-8?B?SmozWm5DREhvK0Y0ajVYM1RJTDNteGdUV0FyTEtRbjVYbisvMk9MWG1tYlNp?=
 =?utf-8?B?Z0FNbS9tanhEUEI1UFA5UTJFZy9yUlBhUmNzdFpDM3B1b0V0N2crcExCcVFa?=
 =?utf-8?B?MnFuZ0tQbjkwa0VQUGVBbG5YU3RTb2djaGtBeXdadkV3ZGFvQk4yK0MxeWM2?=
 =?utf-8?B?eGVnQzQrY2VxVE9SdEcwa1BMM2taQlBDQ3duYkloRCtHOFRhcHlkL0JHU29Q?=
 =?utf-8?B?YjhRTVB1V294UjdqWGFJVXh0cG04TWtYQjhzdlZ5eVlsWEt3QXpNZVZwbi9X?=
 =?utf-8?B?UzVsSHNwZ3MxUmRsenhKNnRMTXFLM3NBSzJqbTBWQlYvUUwrY2dLWERUTWJo?=
 =?utf-8?B?K2Y0MEZ2VVBUTk96T0V2UlZPUW5RaG5UNUdtYkJTUFF0bzJWdXBQU1R5ampY?=
 =?utf-8?B?WEFEQ3UrNkdFT2lPMkFjU3pXRzdFR2ZsUGpuNWd6TjJnMUJlNkMwVW9lcUtx?=
 =?utf-8?B?UHBPck8wN044OTRTK0ZmNkkyM2ZzQjQxV1BPK0Z5azJnWG5jWjhTRG9rZFFa?=
 =?utf-8?B?aVRyZGpzc3ZrcG5NUUNRT0RLdnhuN0x5U2xEZnYrckVTNTZTQkE4ejBuSlps?=
 =?utf-8?Q?doJtI1rATAg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bmU4VmEyeEpJTDZ2cDZuSlpsanBrN1ZUZDBLbW9jYisyK2tRS2lLVFh0aXZ2?=
 =?utf-8?B?UldqeVVOZThqbW9Sc252aTlPWDBpbVpJeXp5R1hGL1A2THVVMkhuQ0Q5em1i?=
 =?utf-8?B?TGZId3ZPSTBiTjFQdXFwdUdJYVArWDh6bVJMcEtlRWIvVzd3SW5CZnpBN1Jq?=
 =?utf-8?B?elBVM2FTK01kNkpQY3V3OWM3TmhQazkraGZYaGFsNkUzWStHMzA5Y3RvR2Fn?=
 =?utf-8?B?WE10Y1NHWFJ1TWRmN2NzQyswTmUvZmVvai95YVRkNktaR2R4MlJxZVVGdjB6?=
 =?utf-8?B?cW1zWUNySkJxdldOZUhkcEZKNDRBMFl6NDJTOEUySnF6bDB5dS9WSitDdjA4?=
 =?utf-8?B?Y0R4Z2EzWmNnT0pSZlRMdCt4dnRuQjBhSWxUY2ZhbmZMdmRRUCt6Q29IbnVp?=
 =?utf-8?B?ZnlGQXpKSWF6UE1Idm1ZV2FOSjBkelZyRDdNRFJ0RFZkOEJkM3owOEZBTnVs?=
 =?utf-8?B?UmlxdmNPS05IbXI4R0Q2bFMxQ1hoelp1VDBtME1jSTM5L0NObDZ3VTlReEsr?=
 =?utf-8?B?ekNIUzFTeWwwUThmaUJXSGovYVh2Z1k4MjhGRjFFYXdrZENaWjNKajZmeHZ2?=
 =?utf-8?B?Ti9Oa203eEk3ZXlRS1hkeWlKZ2Y0WTJtV3dnOVFHR1k3Tmk1OG41cU5Qb2k2?=
 =?utf-8?B?RnJhcGRkT2RaNG9XY1NvdzlpTDlBN1lnOGcvOXVOK1hlYmVEUm54Y3phaXZP?=
 =?utf-8?B?Kzl0S3hYdENtZEtLd3RTeGhGT2ZDMzJrakxqeXVDdjhnL1lTUEhKZGxuKzBk?=
 =?utf-8?B?dXRwUHlDM1lOZzAvMjVmRHZKcmoybmZDL3Yrc2NIMVBqbjliSmF3ZVBsNVI1?=
 =?utf-8?B?UW1KbVZpeUlvc3IwdkdnQjRnL05FQTRqV1llMEdCQjR1MUk3eUl3OTIwY0lX?=
 =?utf-8?B?Rm1MbzNrZVU5UW9lcEtidWZqcXN1dWczYXk2NHBnZkR2WDQ3RnRTV3ZOdklu?=
 =?utf-8?B?cTl5aS9NSG5xQ2IxdnZyWnJMZE1zb004bCs2YWdGZWVrbXhabFQ4eFBSQTBp?=
 =?utf-8?B?NGpXUytKd0VPZ1E5R2gvTVdTZ2ErMGpwUkRFVjRtcStZZlo4MlJScFNxVmor?=
 =?utf-8?B?YmUyaTg0Q1ZaUmw5UUdTRFF5S1ZDdGEzYlhrTm0ranI0MGtINmMzMlJDN252?=
 =?utf-8?B?UmtvdkJBanhhWjErSnlsMXptZTNVVko5UXFTVWpLcllCQ3BZKzExL3BXSVhL?=
 =?utf-8?B?ZjRjTWpXVk1VMCtDMlF2aDZlelhaM25qSzVzeEZCMWZZbkYzNDVrNVNjVVVZ?=
 =?utf-8?B?TndlTm5qNy9uR2JYeFozY0xCZEY4amFxWnZJMWRTVVBtS2FuOWV2NzgxV3I5?=
 =?utf-8?B?NHBYYm4wVHF4L0JyTng3NFlYa0N6YnhVcHJwSHZ6NGljTFFMYzdyTGJ2d24v?=
 =?utf-8?B?R2RCTFUwRndURklwTXdLR2txY0gwRWJyWXNSKzNrSTB2KzMrejFmc0VwVExD?=
 =?utf-8?B?cnl2WlFJVC9OUUFqYXhxb0dydTgzVHI2UDJLYXI2T2pLeUV2T0Q4VlBoR011?=
 =?utf-8?B?SzdIcVFzMVczcmJoSkZVUGE5a093YjNqUUpWdzl1QzY0Nk5wbnVaMW9seHlR?=
 =?utf-8?B?TWV6ZkVRQ0QyOHNZT25LWXlLZGhVaVI3MzRjY2ZPNXNCU2hoUXlXUjFZdzNw?=
 =?utf-8?B?WWhTMUxnRC9pN3FSTHJMcTdmZkYyUzFHQUd2Sm9WTjdaUXNkNDRnZkIzcDA3?=
 =?utf-8?B?djBSeFpHWUo0bnl1cWQzc0hwT1IrZy9xWU9VQ2xVT0NYa3hrTTBlbXByYyto?=
 =?utf-8?B?Y2RYNEVlWW1IUjdmVmYxTlZ3b01qSkVwazdDUFZxNmRpMWZzN1pXU1RGa2ZH?=
 =?utf-8?B?UlVUV3FTcGl1bkp5SURRZXc4THJzeWlSSkhVTTBjRFNReVBtU0ZXRGhFcG5B?=
 =?utf-8?B?dnQvL3llSHpUQ0hUT3RDWEVsRGxFWGZBRmQ1U21Zd1U0OU1rU2VDWTlOa2E4?=
 =?utf-8?B?T0RzNXpuc3FMbnhZZTRYOTJzUDUyeGhKeis0SmE0bjlNR21qNnlUY3lJMVVC?=
 =?utf-8?B?WjFMRUYxZGM1OWlJZmg4cCtJVGVaMUl4c1F0QjNwVVFzRjRiS1JjMnRTWXZo?=
 =?utf-8?B?S3JXdzR1UFNXekJIWGpJcmJRVmVTZnl1VHpHM1Q4cWQxVys4alpPNm5wTE1u?=
 =?utf-8?B?dDU5SllyY3pTVml0RWRMb2xrTDJWZEtqWkZHclF4S3lyb091dFJHVUE1RDRm?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jvMZuxxXEp8IpnpJBXhFKL+KuAhjnhVRwCgvPGSzflJZ2EOe54SAYqmCpqPWkS2vFFft+4NOij0k1TGmgQctmFbmYmZZdnQ51cJIGFVRdWdYUhytoGrDM/Zh52nxybxIR42qAVZj1XEXNe9w8zLInmqdtuwJv0Xv/SUYJnMiRIOzeLzomuKtKE5VoEbEYmknR8p9H6LgL9+iLzdmohZB1xDN6UbMpwA66zH2zHEwpgT2L2Lni+1yByq05mcFAgjcLC0m8XcVZ7almZURafyPwzY1qdzMRzQyh7Gv4akA426+KdGT18MBbJH7sBLG0YeEAem9/0fMjjg11SppzJ5Wuw+wRBBUvSsUntMW00J7w9wZy9AdfOyRXZHPeK2eRUuoE5A08O15Xr0pm/k+muQCR7/xMj71UEZZ46juCP9BBH6avSbq8vZxBkVTbb5z27YgG7wr9qAGAWFpy7QtIBMWjlOxtRGkkKUIwXdxk7RCgjh3cXr0EfRV1iV8DYK/LjZa8GoSchFKLSKSf1jWR9B4IhH6vpt/atCCoGFbFuMGHtKUGXfTMB0OW30mH1rbPUyfPSC4i14EULJCq4kTBzOMyCtKfuEzQgWGBRR2yn5eqXc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ef917ef-55f6-4f7d-db97-08ddca989b21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2025 09:58:14.3883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DyZaM15BZQFGdR/Ch5EaJQty6hhPFv9NpGC9ZAfDxAJN/BbvlO/K4QT1ZDTKLfb4au6ziW46r8j84ylUPF537le/W5E9gyQ6ZehE7fgQ2Fo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5778
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-24_01,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507240073
X-Proofpoint-ORIG-GUID: VIwec6rehG-TYD0SoLEaloE-cxJfCzC_
X-Authority-Analysis: v=2.4 cv=YY+95xRf c=1 sm=1 tr=0 ts=688203ba cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=bQDVWgSrMSpXkyIF4woA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: VIwec6rehG-TYD0SoLEaloE-cxJfCzC_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzI0MDA3MyBTYWx0ZWRfX5fxUGyVcv8+k
 IbdV1/1fmUrP/vqpPoSHT2LAfgZUI/UlceIUWh4uMo/a3cVSFg0frrHCQ97VcoeYgnhZ0luzC45
 BxK0ivgnl7dgDuV+jVyN/Dg4up/Eo0MGA9FcxafmE2e62SQ5t6D3DMS57ulRDoIKTjAUSPsbQ1U
 cN1YT6FWyuYBuXJQUOCAnK9iBeP2vfcYsb0Olvrr3c53QzuxpLHsSMtW9DcFoozySqZKOMJ5+5o
 18TkwCjy3/jnwe2RJVsgv5Yb1uulLFur2u1mNw/ATig9+JruRfzxP72IT8qMgv9hqWSO10gCsDG
 7PhI3uq4IL4hEV0se2xUyWW5SKBHf41oAoqU5pIVBeOpin8eWPBxh/2RMMs+LcHDyf3Nl311QU5
 S1TJ8DHJH4ko9pd1wrGsVLR+U4OZwAjTpMl68qLdZ224fOhrfxrlR62KTvN/AshxHnc4jRKD
X-Rspamd-Queue-Id: 3C2AE1C0005
X-Stat-Signature: 35c6gdhiniuc16gcjg5notfuhj9a8hu4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753351107-457918
X-HE-Meta: U2FsdGVkX1/jlQTAiMnwybdbJwhjCCHE2qvo3KFIBlYdBcrJxxMVENQglZOVd6+KmQWGQQ2z7R5Gorh1XhcKRNbpDMd4ibuUQnuFmCBmap78q2Dsk70VVbUNHNJMIe8vjoh0kzmt1rqorRq6HD/F56xlb4MStL6m3bRIb0UEokTMD26Gpzjj9pIapKeRUsRrRLR13bsN3COATwwsFXIo8ReWXVhsTuw2oKcjgt951NR/dEi3mITsMOYgqoQe7FxU5HH6nn65s4UZE8OPEtCJBX4oGOA+kO2k+FfBSQo7fiXA8uwljhJ2MQ4UxskhVXFAEKD38XjnTb3HPu1qHPuoXdBT0efCHZcoUdOZ/463n/+fxRakRqRhYm5R21+HGNkew55dxQCJqGDnLGjH0u5Sng4YVJ8UQgwhKNDdIwH/6ceDo/NX6UEvErfMQxcHaLKfew2wacFB6aBdVCdKxqCbTNaKj7r35ws6ImxA8/QAQifxfIZEdyHXMkom++4kJISmBqRqta6LrsxBgIobG8J8P+gp0gqKofG+zocrVJPjlPRqjeR02mMkR0n1bMbGSSLqCCgT78NbBZsBUk6FJFJcPFKmfwJd0KfBasXErunCjgLiaPpFemFAx8zw7PZLJotU50dgRT1vWtrl80VXRo6o1fvicHAYlVZ3gvleiJ+DWJtXRR3H3oPwhvK8oBREPDDQ//DLxmcseFoJI9oT5RZqnAeIeO3KPICiRTTTuKePRfgbGnUX/3E22o13nGO5UM5utBosnzUbMjdNseSyJDdo+8hIbW9HJojrqqkOMzSyPAJvPRrCO/Y0IvyMujCrppssr0mYV3WhqlxVX9wuuwwWW19m3W+saE+l0Kh82BBJOHr95uIydZ/nKkCvqH8uAs3R9ofXnM+fOluvXy+1xtaH8CL1AAIqKOAGNt6GzdrvOOOOWoG2hO0ouEOkWk5cHnTV6e82FfvQCewLHB4T3FQ
 f8jmz0CZ
 4EosaYOxR+rZlQNE/v8EXEKshrm9McepQn5r53cS2TRBDfWXRtPZRZheRWam9So7Ao35iWMyoSnTXYJsuqAiSZif2uhRnkVUGWPYcnraUDKy/U0mPK/UcnVElX/UUIdcl9XNFpXoVnCe8VHMeyOhwIRdg3ETK/swLoeVw7Yt6QY/xWPxGN+zunTWs9KItiTX0906GkxCA4oomv11fGnnLdgwhLnCrlyQwODZt8EAyZkGsSCTDNsKAcsn1Aq+egyEEzZnM+sA1a12i4zLkdA1f5+ufnu5JPCWxi02Nhots6Wi6RqeV/Jo0l/m5PhpU2qGIeZQUV4T5iUMsMI5nId9FntVCbFyWXWVetkQ1k5TSqzGVLPuUUy7Z/X42DZWtAxQsqvg5Tqz7ZVh7a4V4e4Rm+VQqVVp0uTshreWrJJFKqvvuRRBzYgICV1llKx6HG1Y7GPtV3efVkSy3yvUTB2bfV2Yih/gfgKjoQcp53lvjD1zE45luQ/ydYhDeL34r2KX5AxxYNgjX/gyFmwv41+IV9Q1LuM3dy1OWQ+arc8aHzPnKj+DIcpButsL9nIJ+0D5CP3W8/YYZYnpQM9tgBvuqdxe/faI+Y4CNiEDUedN27Y9MWkBt2r6j6ZyfgfhosUbsOQ4Z5KcobaBowW0vP1Yjj0M8VuUScXZrnJ2dEe7hsp0YZRwLefT7v9fYtYuRC2hEZLKhTnO+be+25hb/am/+I6y69R2Mp3bg01cvYco+Qf2SoNRnveCjU3VEGbRdsl2Zq3t71awi1es7hiXlaR8XXqdUUY5W8c8/P6PwnB8RBgIeCWqAwwC+KmmYdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 05:56:09PM +0800, Huan Yang wrote:
>
> 在 2025/7/24 17:45, Lorenzo Stoakes 写道:
> > Having looked at anon rmap in detail, I have come to think the only sensible way
> > forward is something fairly bold.
>
> Woo, that's really interesting. I'm looking forward to this.

Haha thanks, I found the one person in the world who's excited by anon rmap :P

Or rather, the only OTHER person ;)

Cheers, Lorenzo

