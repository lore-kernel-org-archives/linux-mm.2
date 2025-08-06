Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DED6C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DE116B00A3; Tue,  5 Aug 2025 20:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98DFF6B00A4; Tue,  5 Aug 2025 20:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 807B16B00A5; Tue,  5 Aug 2025 20:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 701496B00A3
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:33:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 25D551A02DC
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:33:54 +0000 (UTC)
X-FDA: 83744459988.28.E829ACF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3E4F6C000A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:33:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GNN8e5iL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RmFXWjq1;
	spf=pass (imf10.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754440430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFOKI5K1QjZfQjTFJYKa0QMErJxPJ2WMSdkaVUOe59I=;
	b=fT+/CW1gTjfXhkFz58VfyyoCKwrQepGBaSP+8SV67IY+W4wPMlFj354hQzmtB+2mGLiFvd
	r9CY03FV2lEzLU1TvMpvtHMrsYRH4LM73LY0nELDW+OgbenhyM7bhZIrn8jPcpPOw8FIsw
	0KPYFFm9hDP2oZkbdeVScOmWq4e4jIw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754440430; a=rsa-sha256;
	cv=pass;
	b=bRqaaQ+uBF0lR5bPGGS/WG2GOl+ii+TF4ePFS2ml6oehyYqYgd2NNj8GPehI6JH4pEs2AB
	Ecw1umnSMmFbAqloRLNVA+ud+UV5OKblqLQ0imD6TmCDIuu2XoKsCkX/RtknQyQYVGUyU4
	O4yH4ZgTzkZpUDfUawsR32KcaJZ3TCc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GNN8e5iL;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RmFXWjq1;
	spf=pass (imf10.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 575LNB2u025750;
	Wed, 6 Aug 2025 00:33:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IFOKI5K1QjZfQjTFJYKa0QMErJxPJ2WMSdkaVUOe59I=; b=
	GNN8e5iL6ktGHJtz09cM3I4pD2F+uKK23aAqVgw95EabEl1Epqwu3msC4QJ7vvZj
	ntxYR5kBPaAhiZ3qQojCic1YiSnU3CWdLrzM45ZtfaXjg0163N4KegLOzZMoLOJt
	VQu9odCWNbiLE7hR99k0l7ADFM35JIR1bjJiAXeIel7rKPLeNPwdej12AwKXnfK6
	JR9hevQiLMduQFVDYSM/En407W0qGtixduIXU/d28ocW3uxWiE3UkFNbduaV2MJW
	gTttgzWHaLg7FTpNQLHonAUz/hYUimSgUqc6ewI1KIkll0nnFfPvqDabk77OQgUz
	09DkhutW6bUuhO7VikOpZQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd0hsn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 00:33:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575NNE3i018366;
	Wed, 6 Aug 2025 00:33:41 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2076.outbound.protection.outlook.com [40.107.101.76])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwqbghe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 00:33:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ks5TOPnGksu4f8ADV3Fdn5N9O7epsLegWjmolG6YvcCGfMnkISWZErxeOdVXYS1uuHc34wmifVrDLLgNHX04kswOFFvkdv/ovH9KPfobv0kk+XLgLmX+T3e3LpPbk8xadDRNhDM+uN6DYt5HNpSt+z1rNr9tYtAN+QO1QTnLZToWPsLvEYM/OsRdNHV/xyS3NA1PDkduwjIvTmX22+iCg5AD4jUayHMdZnRqIMjHNhnsICEDkLRatut21oCovUv3whK6Bpee95Yrc5gAGhIiGdH/x6MS6V3VnCuyHR3c0jbpJSAqX6D2srYUxB/Zitv1TruFvo9Dh//EMCwq4+oquw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFOKI5K1QjZfQjTFJYKa0QMErJxPJ2WMSdkaVUOe59I=;
 b=DvjxmmlJIqIFRP9g/aXjR5hbnIQkU265HnG6ovgjZky+FTC0KGpPJqHK4z12YPy11Gul6zLFTYNiYi0ylUlfKJJBb+PHH3izP4biUknHlifNF00epjxYSSD1KymCLpAePyH/r1W9F+cfBSingKGfptzr2UTR405KFT1Owe470/0SkcX3RUhqVdvNTdc9+5/BcEP7/46ZUal73333FViHuCuyhHeTt9cGm+9YW6xtEl8Oh9PYK83N7HvABpuGxx81ozAuDM7G2yHbtXxkzWFDrYNmFel7zJMWOhis6GRGshhI2s7kXPzX3bsqaIMa6R4BLiYGin2meN/y+LYtgMEkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFOKI5K1QjZfQjTFJYKa0QMErJxPJ2WMSdkaVUOe59I=;
 b=RmFXWjq1qdku0ZP3rtSXYmbGsP5UZDEIGYru7sO0ewfenVvnROXVshWNkk9ezBxRpy/rdyMtte+TwSUB0g7KFQ5tDBsAkslyWOmnGpQs3aAwRE6suWD2+rVAXqdJMN0oS01jCnGhjKRWq3RgsvoRTaivMAj0wdM/pdL9IlMxR2w=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 CY8PR10MB6874.namprd10.prod.outlook.com (2603:10b6:930:85::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9009.13; Wed, 6 Aug 2025 00:33:19 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.8989.015; Wed, 6 Aug 2025
 00:33:19 +0000
Message-ID: <a8a8c674-6f8b-4aa9-befe-7ccdc66307b6@oracle.com>
Date: Tue, 5 Aug 2025 17:33:17 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: hugetlb: convert to
 alloc_fresh_hugetlb_hvo_folio()
From: jane.chu@oracle.com
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-2-wangkefeng.wang@huawei.com>
 <920efb15-581e-4efb-be74-088113bf2035@oracle.com>
Content-Language: en-US
In-Reply-To: <920efb15-581e-4efb-be74-088113bf2035@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::31) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|CY8PR10MB6874:EE_
X-MS-Office365-Filtering-Correlation-Id: ee15d951-e390-40de-43f3-08ddd480d777
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dHF4SkU4WkdDYW10NkQ2U25MbXRhbExqdTV2TXJKeldLbWN4MGRGOGZjOWt3?=
 =?utf-8?B?VkNpTU52U0RWaTdaMTlibVh2Mi9YK3RvV2d4Sko0L0Y1VFdhTnkzZTNNNVBU?=
 =?utf-8?B?S0VnY2VFSXJhZ1hENmRKN29nbHE4Tm50VmFsRDZtMTBBa0NoUWwvaFZwZm1y?=
 =?utf-8?B?N3dxVnlQM25vYlV4eGM4amtveVFKUUtRNWI1K2RIalNPbXIrRTJsVkNwNjZ2?=
 =?utf-8?B?NDZibU44ZUdSekNISnFTL0laYjJ3eTZZRHIxVG5acnZwSkdsNndTTGdua09C?=
 =?utf-8?B?dG56b3VWUm5kNkIxYUtnYis4VERVTXA1T1QrVVFzRGVZaXlLTU5XdUVTZnVU?=
 =?utf-8?B?NFlhdC9aQWxpNzA3YjBoSjUvMko2VGtLRkFWL3drYnoxejdUMmJDblVlVzJG?=
 =?utf-8?B?SUNOMTRqM0o5WnYyYTB2Nmg4aDZRSFBZbWRiZWVqTnp4YTQzK2Z5bWRYRFBj?=
 =?utf-8?B?dWpQbXI1eEtCQlBZQUw1ejJvbXJ5U25HUEVNWWJ1UnVJM25MM3Z2VDhJTG5q?=
 =?utf-8?B?M3E3emdLTWJXNU82NEpVVDhrdW8xeVd4Z1NNYUcxaFNGYVQzNjJwNE1jVFdS?=
 =?utf-8?B?Y0ZwZ25qNWlGV29zb04vdFdnNW9kNk83SWx1VWFFRGhqWEVkeWFQTFhBc25F?=
 =?utf-8?B?L2hMM3NIR1F3QzlDNEJHcDlMNmtTZGR6UHVYMnF0OGJ6TXhMaHlxaGZYLy96?=
 =?utf-8?B?ZkhlZnNCVHZqWFVsTGcxeUtCcW8vd0dyTHdBVmE1RjhuKy84YU1TcWgxbElx?=
 =?utf-8?B?WFN0QVM2RndCSFcydXI3YWNhWmJzYW42Sk1TRUEvUWcwOEVpUi80cWZnUlJ5?=
 =?utf-8?B?T3RXdEloOXBUVittekJDQ2NJOENieWRBa2plUlpaKzV5bXF1T21ReEw4djAx?=
 =?utf-8?B?Q2ZXZ3NBU0pFTUlIdGVGWEFWVUM4NVRRazlnb2k2ci92bUhhbnNiWllRdFFl?=
 =?utf-8?B?Um8zQnlQbU95U0hRZ1B5YU92SGZETVpVSkN2dUtCRDBvR2h2OVd0M214eloy?=
 =?utf-8?B?anltSjdoVlVJVldCZi9sdW1hMEFNUUtZeDlNSEkwWTVyTU1Zek81ZG5FTjJC?=
 =?utf-8?B?WDJpZk1EZ3ZCSk15d1VuMkFiaVlIZThjem5iTDVtUE45OW1LbWJXY0pzMlVX?=
 =?utf-8?B?UTM5ZkxTVTM1VHlzV3dXVE5nQ2FiREYrb1J0UzNjQkdNbjQvc2l5b01CaUVy?=
 =?utf-8?B?OSttbEFpNzMyWDRmaTNuN2RvTDRWdjg0Y0JmeEMveS80ME9QWFlORHNleHZL?=
 =?utf-8?B?UGZKQVhURXUrVVVRd3FuZnBycGwybDREWmNjdTlvTXJ4ZWV5Qk16bTBSWkph?=
 =?utf-8?B?VzVRaXAvZVVvaTB1Zld1dG1IcEgzdlNMNCsyK1JoZ3NsZyt0ODRqMC9VcitV?=
 =?utf-8?B?S0lXVlJvb1FxZCswSE5lcmxTU3BpZVE0WG56WTQ2TXgya0loTGpIMXdYRjNx?=
 =?utf-8?B?MERnYnFFNWl3dEJzYlZBVDdkS2Y0WkY2MmwyQ3JxelJ1RXNPSDdZQ1ltWm94?=
 =?utf-8?B?RVVOMWFORkJrOUFUdTRITWJZV2tlKy95MEc5V1VqdG8zUDY3OUJrbVM0akxZ?=
 =?utf-8?B?Y3VGZUJzYVBoVktUSlNrckdtekc3V1RUZ1VKZG5WZlBYTTVTY1hoSldTSFFZ?=
 =?utf-8?B?OS9QNGJxUTZTNVNpY1RITzczODFxRWZzL1BYVXRFQXBBQjdFazFoa0xnLzA5?=
 =?utf-8?B?dlM3bW16R1JYT0FKbGtIOTNMLzVrN2pOS1VOUGpZckw1WWVnZFBNNWZobHhu?=
 =?utf-8?B?TzJjK2V2SHl2ckJWZ1UyNHV3cklFQlNpRHRRQkk1KzlCSEx2ZkoralBtYlpx?=
 =?utf-8?B?bHc4WTVjQzdjRG0vWC85NVRmUVNuamh2VjhkMkJnVlEvdS9YaS9LRmZ5RHBN?=
 =?utf-8?B?M3V2djBVb21zZHFCbGZydDJZNXhhRnQvMURWZVROSUtCclJjWGkxR2JOaXFn?=
 =?utf-8?Q?nBBVhcLwC1U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TzdtbXIwWEZZWHdVNU41S2pJYmtuWDVuVGRFZXVrMXZmZThLajBoeXUzUXh4?=
 =?utf-8?B?ZUhRRWlYOW1IMkVOT0g2TGFpQ1FCZHNTOEtsRTlvQm83VlZOOFE2N0hwTm1I?=
 =?utf-8?B?OHduc2paOVpEUFVBanR3eHpvNkRaeVFYcUladzRrUElKcFgzVzI0ZHR1R2Vt?=
 =?utf-8?B?S0hpVUUvMEpoUnpFY0w3MVdlcUc1T25VVU1iV2wwbDZvQ2lBOVZYWXBMQ056?=
 =?utf-8?B?TjExdnk5cjVGRlNXVGl1elU5UXhsQlQrM0wxWExTd3BtY0dsYzlzSFVSU0FW?=
 =?utf-8?B?UndGZU5NUjhRQ0I5K25oNlFReW10QW1ZUldEVHhrZEtQNi9oQTRLY0IvNGdx?=
 =?utf-8?B?TDJOVW1aekpDYkZscVNUQkZBR21ORHNpV0ZmK0NKbVRmZGZUYzhyeXJhd1hx?=
 =?utf-8?B?Znp0RVN6elR6bXFjdzZPZFhrajRJdEc3ZjdxK1QvQ3JQUy9qZVdwUmE2Z0hm?=
 =?utf-8?B?R2JZc0hwRyt4cVIzcnpyWTRod3U5UlRDcVkxQ1VzM29LOW9FSnpLK1ZLOGNF?=
 =?utf-8?B?TDdqWXZ1cmNuNG1mNXBLQUxvdWJYaXM5UTQ0SkVLQXJDaE1lOCt2eGpCTUEw?=
 =?utf-8?B?VjJaQ2NNVkNVMDgrMlpteEFYQUVWYlNtTUFqZUdCMVoybVlFYmtnTWZwNUhK?=
 =?utf-8?B?cTdlOGVmRnJKYlVNdGdYdUtGNkZkUEhGNnZPamFyRmMzbkpxVTZHV29HNDF6?=
 =?utf-8?B?TEh1elhZYldvZ0RsZS9pTXY3eEtPc0J2MXR2cE1XZ0k0Vmt5cDlQQlVBNW1T?=
 =?utf-8?B?elZlVWJsdXlzOXAxdDZ6YzlVTzdLZzUzeHoyNmJyZGF2RExqRVdCWDhPTTQr?=
 =?utf-8?B?QXBIVzVEdkxVa2VTN2dFdEJwNWhUa205Ri9yTlZCQUpaMzhDeHNzOFBPbEpz?=
 =?utf-8?B?UjA1eFVUQUM1U0F2eVdHM2F3dHNrVk5CZWZFWGhid3MyN1B1ekF6VE9vcWg0?=
 =?utf-8?B?aG5UU0xraktScnV5ZkltNkpWME1WTFFzeGloZm9jTzNvN0xyNUtXbUtOY25V?=
 =?utf-8?B?ZEtCZjBaL1V0TlJjNW9yckM5M3NRN3dzbHpPeXRCTFVvWkVTTkF6UHl0MXM1?=
 =?utf-8?B?eEMzNDJIRHZkRTFnVEhtQlFySzRaWHBuSVNXNjNuWFJZa3F5NnJLd0toZFdR?=
 =?utf-8?B?a3FMU05PcG9ML3U1NVptQy9qL2dWZ084YkJGdTNuby9LYnhsWmpick9aSTVS?=
 =?utf-8?B?bUdJMno2QXFLS0xPWHNVZGp3aCtZaWlHSjZxUlU3UXFhUTNFcS9ZNC9WRzVI?=
 =?utf-8?B?VW95TzFhOVNvMmZaVUZqeThZUGRmMjd4RjNycFEyL1JEa0p3cVFYNVRucUVy?=
 =?utf-8?B?OEpRK3hvdXdRQko3aWlkaEVaZXhYNFBydUgzc1daL3hNSktkaHRLOXZTajZV?=
 =?utf-8?B?M0FsUDZiR2R2MDR6NWY3aTVNYmsyLy9KQkc4UmRLRlBPSEc5ZTFNRDcrYXh1?=
 =?utf-8?B?dzRFcHozeVhkVnBheHdHMWd4djl5bzhwdHhiVkVIQ1lZUWFIZU9lQTFRT1Jr?=
 =?utf-8?B?Y1BySFNic0xSWS9jMDBCT2JFNlVWNDZBSzF2VzR0RjFFT0RjaUtYaDhzM1p6?=
 =?utf-8?B?amZDYWtxVk5Td0xqbGdqczlic2JvWlBZdFZXWGtQQkEraFlUYlVFYmdFdGEw?=
 =?utf-8?B?RGt0UUtMc1hJNHJZaldxdGwwWjVXK0tMRkZEbGdvTFRubzg1ejh2SEY2U1Jj?=
 =?utf-8?B?akU3ZUM4b1Y5NTJLcmlQVW5tRlRtaWNXaTdXU2ZlYzdrZ0srbU5EcVVrRkFL?=
 =?utf-8?B?WHVqVzEzTVFRWVBUOTBoTHNWTllVNjFOL2xNZ1VSVEl0bGZISFFjdXpPcXNo?=
 =?utf-8?B?UzNHUHhCNFo0QUNOZXBzWFpQdDVFU3NYVkg3RHNWZExFWjZiYkZsczZZa0Y3?=
 =?utf-8?B?VVhSbHJuU0tQSXcwczNHaFVkL2VPaWdlWUtKSlpDM3UwM05wcXU2OWJSTGJW?=
 =?utf-8?B?QjdXR1NzMGZyckhBMmUrRFZ4d2hKQTRTb25ZbUkrcERHVDliN09nNWNmMllo?=
 =?utf-8?B?VitHNFg0MUJDUlNTVVUyQ3ZjTkttZ1FVcFhrTWZ1bTdjSUZuSjlvRng3bHZC?=
 =?utf-8?B?WXY5YmpNOW9ML3R0Yzc0OEJ4RlNpdzFkRldKT0xMMG14Nm9laWRUQjlhUjRT?=
 =?utf-8?Q?SEoJJ6XUJ2s4ZVJlKM5ZWCaeH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gg7WQuE959c1QpxDImNnv1agsZUX8GIiMudLL/GX+O/JPgm6qN/H0GLTRjqboCmnMLHGYyN4WoqDoQVBMFxsad7LN6uawDk2/bgMNL/PW7BlHPN8M/+h6DLkbcJmMgwG+OoU7+bCpZvFSsfWplV30nVTxolahC6s9V2OPwcdcRHpyArUKIUb9xbzjPAAmi64V1FfgkkZLepwrZ7i1H2wzgKbIf0nCMpHnKtveMMk+awfanZpf/6xrc3hz+FqYjDuv58CeU/2MSMMFEDsX6bgLpm8pKXDZppLZrJh58DH+UlTy/4WJNT1jcho01Gig50ETC32lt0i0sui6RsmZK7DhrExva0E4EbuqXT2isAWgdQ5WfoyN5dEJ/jVFGvC1GMxJq/yuQ47+j2K6kkW67VTia8D6usicYG7gsnaIx6NP++Mt8zwOx+OBy4oeP2H2giLtGt8T8tzsqn8mrGbS5toBQ28jQDxFvDX9y+P9mjM5nicD+KmHgxg9mVIJCgYDhjzuRiAL3g512ojtEDISudU8pZWaF443l/as5YUcBhmZ6I6G8CuN0E3WM8OKEzBGeCYUO/LG3iud1IuqmvQAxZIF6iIaSXB0WkjQnPumOq5/mo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee15d951-e390-40de-43f3-08ddd480d777
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 00:33:19.3948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yXALqSMzIETcyc64VkGkR1avJO5K8hEPJLCARHgQTdeMwy5if+/Fq59piJOPfYjqSLBLxKbrvlBKMUKUDPPUKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6874
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 spamscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508060002
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=6892a2e6 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8
 a=lOcTb-LnuX_ZKGQT-W4A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12066
X-Proofpoint-ORIG-GUID: cQdEs-YKarIqlf7WbVJpV2yK8ag4jgpX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAwMiBTYWx0ZWRfX2wKO7oaib/uj
 TqjnQciSgIx1TQs7esZ1hq+k4apYIK8HTPyULw4a4WnDp508CUyrRMd2stTgpkq9Z/Q8m28RZom
 XgnbzVkp3ZUpwlL3/Qf+NxBWnwKgdBaKdbqx88yxxSYdk8k3xNM393WgMYW5f+DSqLKasFtkWeb
 H8EnprgCDhYMO3l2lvZv6A8ZSYYsHdXr7ygZ4J8PYmxmPaxrybuOSy8oPulh9XYcFMBOibBHFeR
 +t9AAfe+ssc8j+WnLRv7d135lKQRf7tLT/DV0ybh6/wh6YcV2ByEcV5zgl0NLBBoUsIh7yHA4sE
 eCGv2ZkVO5ir4Ztgby2xiMkr91PBwqrONCZOc/5nBVCoaGQcNLxpCRR/YAFWosu3nXP0d9/lrmB
 /HgOQl/tQm82nSIYDe9z3jkZOKGDqaxuKKLxfpi6YsvMoVhBocwyvxOTMbiuwSmEsLY1L3Ru
X-Proofpoint-GUID: cQdEs-YKarIqlf7WbVJpV2yK8ag4jgpX
X-Rspamd-Queue-Id: 3E4F6C000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: c8jijarsqmcnmcgadyoicxrxcbcs57sr
X-HE-Tag: 1754440430-530350
X-HE-Meta: U2FsdGVkX18NI9xuI9qLd7oHbiQK4fvcPVw9p4DK6f/Fw7ZepylkyK3gHbw1IoCToFYlK//awVvG8kVNqWVqYQWE14FSmRW8kZj2s4oqI/MhIJL5NFfBC849f8/kvP94Q5Nhr2ByOrXITedMu5mdhmNPtDomSOhfywL3m//zMKyFQYN4cbKOB9jwGlldcZC7a6t8Zay+/zD5EVB3j+5ZN8rja47PvJYmy3CgiZR8qq/YC7UyPqxZeBv2mAJ+2QKXOmsvuT/Yaq9u6WdHDRtsCr3Pf4n9ow3mLgQ9pRKWgAlcBKKkRmFJ/meHq5/4qd0aYKGBq3XYzsk79U3c/EDFpd8SZYsAdJ5RM01Pei7Sqf7nKdaQJYLea5oacRFH++ODeXL23G9IMhyW+JJSaxKAww7TKm3Fhcec1/FyItz81HgTBmLn6TWQTEk8KxXk29y3VD2QbkFaSVstlj+/Ejy1oYAEDrdRsfuW/QVWfwgumIpZJ6x/dgzyt+fV4lzUgPLvx7NmniV+PuYVNQoXtfecocGfcjZOyodS3/kxfWCjK0MHl+V8QGBLXc1i7kN1nt9+SU66MBHnBIS6HZqM5rEbFLLClGHP7GSn22vdBzuCA7Bfzj/QezC9FIzoLv4xER1mzLyO1AkjGQCtBIZ8KX1QQcZ513D4CgJd6lVf0OyqZGnFiwW+bQ53glg+qpKcZH14nX4vWLRdX3tBG9+dOJK62hblodvVf/IhMDrSC7W+K2qtUY3zW1THbHStKKYrwkp7IKuFz0860aYabS78yHfPc0FNPo0SwiCtoSnBxj+6G9IinTMtU1lrrz71/sikjBLoKk4zKFrzVTVZL+8UMhu9DNdnF5MPi3KijwJlbcjUl/NGRnLq5TzbpDd6we2terXgLyu+CohdQ14CD2vx5q6tDAfb2PUPil3yjyT6vgSnh4DCndVHgPAdvsJOS5hXBnz1b1bHeZtm0gPlX0V+wLb
 nJHo/ORX
 bRG3uDuyTSqgkjsWoaZW4WF4Z1EAV7twp+FYBsAlD9Qp3Bgp5ouq6XST5AeWdaToZCFLLAzaQIjlH4gVQjI2FzXzgMNpfmO2H8SApSoM6LljBvnUxyrcPDOAsAmOgLDLYoKUZDOZbuepa/4tyQV1rSX/Uic9OXv1p4gSSTn+Ikt41Y6Q+/ro8JGkPkMC5h6UzgSP94BHM1aElQLo2zN46xMkiXBzbcTMQg/ZJECXuHIutHn+AYl5xes+9pKBRBAuu7YyRmfRiDUxk9MLwDAFVberSC3TQv5j1YJgggaxEGsDR19QfjngfsjHI5ZhL/j+IgCStHRQ9UyC5sgb53Ap9PtMRwCHsLb6t5I4S7odoEvhUwGfys5btGGAQIbs87McRmRSFCaBzRAYLancZWR6Z8HWDaCQyG1yavtIw2+R3kE2BSMysq5jjEfrc666gIX4m88Ndp7+wLy/5OIypaQ49XMvDcqhiZJ/bgUjxlp6PW8JtCqU9Ts5TiDsK06v+4DW1A9BwrhimR0I9MmLy+mNLcE03n7v5oj1l3x7bnAypaKZqPC1gp2/HmNSJvx90z73j2UiJ1l0qPiJeFkQoNuPCaT6v/yHB4i2ep5rW6XkPCtGSyfFBcVUzSscUYn/QrrKvMJ5C6Bh7uzZM7AvpejWjpUeC9UZ3PcUEXP7+wmDeYT7jvgPtghizd5fBGNVCeVNXccUGIzI1xFI3qBJeV5iSzJyVQBjIhXfvvVK9kk2Xe67t0DMQCkQCjOId8n4ECxUWrSpGwsz22LDAh8atVQo1206NPybcCpMJcBGOenLO9kR/3Abg+DBQIfRN72IjhBmzIBX3qj2z/j9e7g6FKxpW8YB6ESlDKwlYUHRymJUcVgi8srlvUDefKlqwNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/5/2025 3:18 PM, jane.chu@oracle.com wrote:
> 
> On 8/2/2025 12:31 AM, Kefeng Wang wrote:
>> Now alloc_fresh_hugetlb_folio() is only called by
>> alloc_migrate_hugetlb_folio(), cleanup it by converting to
>> alloc_fresh_hugetlb_hvo_folio(), also simplify the
>> alloc_and_dissolve_hugetlb_folio() and alloc_surplus_hugetlb_folio()
>> too which help us to remove prep_new_hugetlb_folio() and
>> __prep_new_hugetlb_folio().
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/hugetlb.c | 48 +++++++++++++++---------------------------------
>>   1 file changed, 15 insertions(+), 33 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 753f99b4c718..5b4c19e7a5f7 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -1906,20 +1906,6 @@ static void init_new_hugetlb_folio(struct 
>> hstate *h, struct folio *folio)
>>       set_hugetlb_cgroup_rsvd(folio, NULL);
>>   }
>> -static void __prep_new_hugetlb_folio(struct hstate *h, struct folio 
>> *folio)
>> -{
>> -    init_new_hugetlb_folio(h, folio);
>> -    hugetlb_vmemmap_optimize_folio(h, folio);
>> -}
>> -
>> -static void prep_new_hugetlb_folio(struct hstate *h, struct folio 
>> *folio, int nid)
>> -{
>> -    __prep_new_hugetlb_folio(h, folio);
>> -    spin_lock_irq(&hugetlb_lock);
>> -    __prep_account_new_huge_page(h, nid);
>> -    spin_unlock_irq(&hugetlb_lock);
>> -}
>> -
>>   /*
>>    * Find and lock address space (mapping) in write mode.
>>    *
>> @@ -2005,25 +1991,20 @@ static struct folio 
>> *only_alloc_fresh_hugetlb_folio(struct hstate *h,
>>   }
>>   /*
>> - * Common helper to allocate a fresh hugetlb page. All specific 
>> allocators
>> - * should use this function to get new hugetlb pages
>> + * Common helper to allocate a fresh hugetlb folio. All specific 
>> allocators
>> + * should use this function to get new hugetlb folio
>>    *
>> - * Note that returned page is 'frozen':  ref count of head page and 
>> all tail
>> + * Note that returned folio is 'frozen':  ref count of head page and 
>> all tail
>>    * pages is zero.
>>    */
>> -static struct folio *alloc_fresh_hugetlb_folio(struct hstate *h,
>> +static struct folio *alloc_fresh_hugetlb_hvo_folio(struct hstate *h,
>>           gfp_t gfp_mask, int nid, nodemask_t *nmask)
>>   {
>>       struct folio *folio;
>> -    if (hstate_is_gigantic(h))
>> -        folio = alloc_gigantic_folio(h, gfp_mask, nid, nmask);
>> -    else
>> -        folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid, nmask, 
>> NULL);
>> -    if (!folio)
>> -        return NULL;
>> -
>> -    prep_new_hugetlb_folio(h, folio, folio_nid(folio));
>> +    folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, 
>> NULL);
>> +    if (folio)
>> +        hugetlb_vmemmap_optimize_folio(h, folio);
>>       return folio;
>>   }
>> @@ -2241,12 +2222,10 @@ static struct folio 
>> *alloc_surplus_hugetlb_folio(struct hstate *h,
>>           goto out_unlock;
>>       spin_unlock_irq(&hugetlb_lock);
>> -    folio = only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask, 
>> NULL);
>> +    folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
>>       if (!folio)
>>           return NULL;
>> -    hugetlb_vmemmap_optimize_folio(h, folio);
>> -
>>       spin_lock_irq(&hugetlb_lock);
>>       /*
>>        * nr_huge_pages needs to be adjusted within the same lock cycle
>> @@ -2286,10 +2265,14 @@ static struct folio 
>> *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
>>       if (hstate_is_gigantic(h))
>>           return NULL;
>> -    folio = alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask);
>> +    folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask, nid, nmask);
>>       if (!folio)
>>           return NULL;
>> +    spin_lock_irq(&hugetlb_lock);
>> +    __prep_account_new_huge_page(h, folio_nid(folio));
>> +    spin_unlock_irq(&hugetlb_lock);
>> +
>>       /* fresh huge pages are frozen */
>>       folio_ref_unfreeze(folio, 1);
>>       /*
>> @@ -2836,11 +2819,10 @@ static int 
>> alloc_and_dissolve_hugetlb_folio(struct folio *old_folio,
>>           if (!new_folio) {
>>               spin_unlock_irq(&hugetlb_lock);
>>               gfp_mask = htlb_alloc_mask(h) | __GFP_THISNODE;
>> -            new_folio = alloc_buddy_hugetlb_folio(h, gfp_mask, nid,
>> -                                  NULL, NULL);
>> +            new_folio = alloc_fresh_hugetlb_hvo_folio(h, gfp_mask,
>> +                                  nid, NULL);
>>               if (!new_folio)
>>                   return -ENOMEM;
>> -            __prep_new_hugetlb_folio(h, new_folio);
>>               goto retry;
>>           }
> 
> Thanks for trying to clean up the clunky names and eliminate a couple 
> not really needed helpers.
> 
> The decision to do HVO is baked in __hugetlb_vmemmap_optimize_folio(),
> ultimately all hugetlb pages go thru __hugetlb_vmemmap_optimize_folio(), 
> so let's not to add on 'hvo' in function name to indicate additional 
> decision.
> 
> The difference between only_alloc_fresh_hugetlb_folio() and
> alloc_fresh_hugetlb_folio() is that the latter invokes 
> __hugetlb_vmemmap_optimize_folio(), while the former is used for huge
> folio allocation in batch, and then __hugetlb_vmemmap_optimize_folio() 
> is applied to a list of folios back to back.
> 
> Therefore, to hopefully make the names sound a bit more natural,
> how about
>    s/only_alloc_fresh_hugetlb_folio/alloc_hugetlb_folio_pre/
>    s/alloc_fresh_hugetlb_folio/alloc_hugetlb_folio/
> dropping "fresh", how is newly allocated folio not fresh?

MY bad, didn't notice that alloc_hugetlb_folio() is already in use for 
allocating hugetlb folio from the reservation pool.

So, how about just
    s/only_alloc_fresh_hugetlb_folio/alloc_fresh_hugetlb_folio_pre/
while keep alloc_fresh_hugetlb_folio() as is?

thanks!
-jane

> 
> Thanks!
> -jane
> 
> 
> 




