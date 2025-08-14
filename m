Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD8FCA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1859000F2; Thu, 14 Aug 2025 02:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68031900088; Thu, 14 Aug 2025 02:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 519759000F2; Thu, 14 Aug 2025 02:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3E312900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:06:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BA801116979
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:06:17 +0000 (UTC)
X-FDA: 83774327994.06.413886C
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6481510000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:06:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KMp4hUB6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ay0Cj+UT;
	spf=pass (imf05.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755151574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dg6efibAoVL4hlKUpNms3KDkFMWyl7HHHyFvCbMWSeE=;
	b=B5eJqMH9oP/JIicwipatPFoM/hJpqQBy+mst8dCnftoKaCPXJyxsEmphPLIV84tCxU62YW
	nmpjCbfYL4MhqEt9Fbc9C0xL8eVvGDsNrf15NWiMoYSvY8U6iGT9iRndjVzaKbh/YmcFwI
	VjppBiqiFdCbl2qAK9sQnadAPrZrgM8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KMp4hUB6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Ay0Cj+UT;
	spf=pass (imf05.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755151574; a=rsa-sha256;
	cv=pass;
	b=4Sdu2r4OMcaJuW9LWemfWIyACB0yelrFvPTzGScx2iYkIhgIUiSJ3AVHlgTpRQc2zys2W0
	EjyOnwumfN+kg3raqzin2Zh9M4dv1WAe20buQ5dk98+Ng0bE+p2djg4yi/Sz37Hz/vZXFb
	5Et881LLzhzVI2U9t8+TnEOpWSy7VXY=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DLu0gj019560;
	Thu, 14 Aug 2025 06:05:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=dg6efibAoVL4hlKUpNms3KDkFMWyl7HHHyFvCbMWSeE=; b=
	KMp4hUB6w0Yx6YiI+Cmg6zIdeB3Sk74z9A/6RFAGAlgfaOQ2BYgOUnuuX5O0zlfv
	6ye4v0vz7/eL+cZ0z+p6leU+GTY0yKj962n0iECeLbwZeW0lQTB8ySnnySTKUwP1
	+G+FdlD+qh+lNAHWS6VGM76SkHyBGgqewxM3MmkMhIerMH9ONzMsWOb1mRtkwdcO
	GAnYQ2MA6PDdocmTtc0p2NmnelZD5AvCWoaaOfMvC0JQzJjfs7nKAGwBdCzTRNk6
	zKwi1ho9SAjc1MwgWY8XlpkMiBuFzH7NvWLRH/yREKh6BTRdxTQaG7OJgK3BPnYG
	ZHLAERwgBRK4/5DOTG/vcA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxcf94gg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 06:05:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57E5fCXx017534;
	Thu, 14 Aug 2025 06:05:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsca6jq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Aug 2025 06:05:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yUXCtwC3xT4XuOJMPs17hmIXBdG/Vh19TQoT3ggg31ij+ISyrISyNXP1kpWFSXPx7LakEEPAj814Jxwe9epNFnX8dMRcLPvq8HV5v+dqPcApgt5qF+TJvUEPZ7soec2o4TlTlUCT8WHXHVUXw+hF245Y8XlWm6fmFIuPs8gZnPaXtEUeum126dGjvKT9U6Sm8zIN31ZSjCoZ97QIv5/Tj9EWCKoWBLnqtVoKYZFQxPc6HV4Ob234dux0+k8So+0yFuNvFdSBMdCQys53q9l4a2Pjs6Hn6KE0dH3cvGR0ekxiBES2xDbltxnK1SKnwQiyfPf9nF9zJm1n5sOLYeu38A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dg6efibAoVL4hlKUpNms3KDkFMWyl7HHHyFvCbMWSeE=;
 b=NaCjG4x6IgAGYphY4mX9HVRvfTf60o0Fehkcd/huiAXxt4iuQfA1N9mZNkCgr/HkKCTm2B8SRgiLiafXwYzMU4PO6mBlLbZ/AjnpVwD+j5iGgEUStMIXWKHKYwyaGoHopL8GqaPn8PJWBpeJznhzWVnxMC1EKRNjP3fPCuAw06qg6GfVogLUvieONTbsfvNK+NHNN27d4b81EWUIPNuDhzkzWB2u9XcGSIZyrNBQUUeQAP/+YJuIAbv6/DzcYJhV0bGvcyKCzLMKh6XeWK5qxPOYNnvxUNSrT2hbR2xcGDy5nDXJnwva64qmEOYFT1TtRljDSC1T5lvLY0YjYJZw+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg6efibAoVL4hlKUpNms3KDkFMWyl7HHHyFvCbMWSeE=;
 b=Ay0Cj+UTyAFCUJoOdEySbM0SaQQm+8ujKImc2bS7qu3lVZpaGxkpEkWGttapyImT+YMIR+DUyUX8IYCDwCcmazg7eLvvT28nmCTNfna6iD0JkbX/q4Gty0DFB4hkOPPbO58u8lh+ePxLRPLuhfICzwwQEk+zk0wvUUW74apDL6M=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 LV3PR10MB8201.namprd10.prod.outlook.com (2603:10b6:408:281::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 06:05:54 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::b7d7:9d3f:5bcb:1358%6]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 06:05:53 +0000
Message-ID: <1f5d5a50-2f30-4c1e-bdb2-1c0103cb5b07@oracle.com>
Date: Wed, 13 Aug 2025 23:05:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory-failure: fix infinite UCE for VM_PFNMAP'ed
 page
To: Jinjiang Tu <tujinjiang@huawei.com>, linmiaohe@huawei.com,
        nao.horiguchi@gmail.com, akpm@linux-foundation.org,
        xueshuai@linux.alibaba.com, david@redhat.com, ziy@nvidia.com,
        osalvador@suse.de, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20250811043323.899130-1-tujinjiang@huawei.com>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <20250811043323.899130-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR01CA0008.prod.exchangelabs.com (2603:10b6:208:71::21)
 To DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|LV3PR10MB8201:EE_
X-MS-Office365-Filtering-Correlation-Id: 634e164a-ef28-4556-573d-08dddaf8a071
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WTJSUG9SY1FHMkFVMHJvbmFjY1QzSnFPaXg4bFNmY2hXaEpReGZtWEE4ZkRp?=
 =?utf-8?B?eXlTMjRmM2RJaW1XWStYVU1oNXhOY0JSVTl4U1ZrdVdhcUM4ZTVDWmEyT2hB?=
 =?utf-8?B?QnIrekMyUVluUTNiNGVQT2hxTFZKamJpMDhybmU1TjRndFZzVmdJZS8wcXNS?=
 =?utf-8?B?WHVNTWtBQTQwRXMybXBZS2tXcXJkdFpxSHR0Yjh2NjBMWW5vT3NqSkRQOG11?=
 =?utf-8?B?K29YSEw3K1V4WXpabW41UUswUlRkSGU3dU1ZTGlYaGs4OUpod2tuay9MUGIz?=
 =?utf-8?B?cjYvSjFrdlVMOFRjM01iSnB1eW1uOS9nVEtSN3ZZVWJEZDFPREt2alRsOEdL?=
 =?utf-8?B?MHo4YTJseG5FeHBVWDlLRHUwT2N0ejNWUVZDU0tkUHhsRnRpT2lyc1QwYWNS?=
 =?utf-8?B?V1EraXFkVXlvMXRlNFJUOWNxRDh4RWpmRWpIZWIvdVgweElwek0rS1FUMmdy?=
 =?utf-8?B?bDBZazdoSitxSUhwL0N4ZnJGNXcvV05WQ01WMVNmR2V6bnNYL2xXYU1KQ2px?=
 =?utf-8?B?OGhDS1JFUnZlMkZYaHRJVmk0bnpUN1B0d1llVGVEUmFaMmpNWU5LRGdVU2hR?=
 =?utf-8?B?VGtBTi9CSTBoZ2l4K25CbEl5VVhLMFJRQWgyc0lMbmJEODdzbk5FZ2xreHl4?=
 =?utf-8?B?TXVsUXdKZnlUWmJYeWxQUk9jWDZvdjIzMm1ISEdNazZ6NjlsYVRudFdIK3VR?=
 =?utf-8?B?T1JyMEdjenlZVlZHSWp0dU5uS0Nxb1NnYi84OHVSdU5JdnAxaUtBUEJsajZF?=
 =?utf-8?B?aHdDTGVpTWpMdFdxdHlVbFVVenlpKzQwMWhYN2pxQnVPZmhHUnYvVDZjazRM?=
 =?utf-8?B?ZWtoME5yYnRTbzFYMUVPMHlWMEpCbnRNT1ZXYy9jYWQ3R0FSOU9rdlVnUHBq?=
 =?utf-8?B?cTJFbVRzM0Q3S2g1VnQ3Z0hhNzYrb1BIWDVNL2FQZkxraWlMUWw5ejlnRnFq?=
 =?utf-8?B?V0lwMlpBb1M2bzVxSVFOZ0RaazJsNy95NUlpVnV4RmNnZEFHNEFHdVhwcUZQ?=
 =?utf-8?B?Mk5uazBhOTRmeHhTZzVYend3Sk0xem9UTTBrKzFVOHYvM0hTeGFndGNxVldr?=
 =?utf-8?B?Nmkyd2JRVnVycWtlNHdYZ3dYbjhkbkpCS3A3aityaGd5VkoxY082OEVXeDho?=
 =?utf-8?B?aTRyZDNTbTRFWEpmVXdYTEJzb3E4SzRJK3JUdEZDRlNoWHdYUlBUdE9rM2Vn?=
 =?utf-8?B?cVpFNVpiV1MvSG1acE54ZVNzbWJnRENZdEY0NldteDNsVzBZVGEzMmVHcVdO?=
 =?utf-8?B?UXZyK052bm1YNmhTOUNmaEJZZHN2QVpIZDlNVThPTlFUSENPQjE1NUhOZVk3?=
 =?utf-8?B?M29DMW9nbStFRjJoN2wvQ3RUbG10Y0FSbXpLTkgvTk4zTmRnYmlLcG55THdR?=
 =?utf-8?B?elZtdUJzVVZOa3hnYXlpZnFISFExWCtDRkoxYjUySFl4MUNub0lTN1Y0UVhN?=
 =?utf-8?B?RDlna1hCNUk1bHgzTFgzdytoZ3NkeVBhNmtQWURQQmgvZzV3ZFFVZ3ovT2ha?=
 =?utf-8?B?ZFR5YU9teWRKV3JEdGszYWhDQ0dJNzcyL05nWDlNU0RBaUxCbUdTTnBZMUo0?=
 =?utf-8?B?eTJ3Y01BWlBWZ2N1ZktDVnk5THZPTGFHSzE4M1BsUkxtS3h4dFI3eTNJNjJx?=
 =?utf-8?B?SW41YnNXVjFBZXhSSS9DR1BNMUJuL1VvcUhPUWZGdEl4QmdHK0dFc090S1hj?=
 =?utf-8?B?SGM2ZUtoZEo3QXdXWFdVQnZDQ1pxd1pBWW1QR1IvV1lVR3RxVlFDY29qdDhi?=
 =?utf-8?B?V3VEelppNmRvOThrMlFEc0s5RjB4M05EMUVtRGd3dGdidzBsc084eGJDSUFk?=
 =?utf-8?B?ZkVMdWo5SG0wNEphU042YWFIcGUxTm1tMHVNTVd0dG1BUTZmdVhLOVVBendq?=
 =?utf-8?B?T0l6djRvcTlXS0tNeFByUFVlYVlmS2hSWnUzS0NzaXF1NWdCbXZGVFdkMUF3?=
 =?utf-8?Q?kG9+gNbpKnc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THI3TVgrMDJaV3FZTzJqc0dRbnhSQVdKRUpsajd5d3hlc2RPbVlFOW9SQUpH?=
 =?utf-8?B?MTNpb2tOeTFnOHFreDkwajBOYWkvTEREZ2lxaERTVDhiQlpzekowUTk4eGt3?=
 =?utf-8?B?S2tTVDhpQ0ZGKyswNjh0SXZLV1BYbzdRZEloSlJQNmMwbXhxbHQ3MEJZMVFJ?=
 =?utf-8?B?MTJ4SEtaaU5TRmJ3N2FuWmoxN1pCeXRLVHF6OHZkMEhUZDVZS2dONFNFM2JK?=
 =?utf-8?B?ZG9uNVduMEJ5SWp2VlByV2pZWldIc0w1d2ptcDlHUUpCazVnZ04ybVJFZ05y?=
 =?utf-8?B?VVFseXZLcUl2d1lKcmc3VmRuSFlVMDA5amJnRXBKZHJpSmVSVENOVHphNThE?=
 =?utf-8?B?OFF2SlJBZXRDaGtqZTJnalpmdDRQTkR4N0NieGVPd2FNazBwOC9tNElmKzBt?=
 =?utf-8?B?bmh1Q1ZRRFFDaVlBR1pJbW9HY05EcHo1Ym9lNE1Nd0phcGxVRGI1VUdMTDR0?=
 =?utf-8?B?b0p2a09YZDRKRjhKRitqS1YxL21wQStSeWVaU3JveSs2ZFBnbjNpQjY2eW5X?=
 =?utf-8?B?blhmRkU4STAyZ3RYdHlvcHZiRUZ3MFhnR0lqZFhZRTNYZVNxbXlTdGplbGx5?=
 =?utf-8?B?RDJyRm5QZUxoZTdSbGg4aUR6ODVsNXhQWVlPR0lJYldrYjc2MGYvb0RZeEc4?=
 =?utf-8?B?Q3JBd0Q5K2FZbkdzelRVZjNlaEFjUjh5ZHdSa1FwNnFWTFJQREsyN2lhcGND?=
 =?utf-8?B?dSt5elRkcitIVnJyemVYd1NobEdGWXJ5andOOGtHUFB4TVhnVjNaRGgzL0Fv?=
 =?utf-8?B?dkRQQUtpSThpWVpDbkE3QjFYNUY2RXdPN1NUeWxCczZLNGpQOHVMei92aHFE?=
 =?utf-8?B?cVYxOE5KNVNTVmhzS2phbCtTS2UySnZyWGdZNVJDREJJMzVTREsxVDZJM2o2?=
 =?utf-8?B?ekY5MjIwNEM5K1loUnpEMUhVWmJiUkY3Q3VPWGY2cW45TERkdzV6enRyYTlu?=
 =?utf-8?B?ZHIyQVNSc1ZtQTM0cXBxY3JIN3dxUWY2YjNKaDFEMEpMdjZTbHFSZ1lkQ3VP?=
 =?utf-8?B?a2xka1dVSjY1ejBuM20zWHl2N0xBTEo1cHlnOWFLMWxRcm1LWVhXYVYySXBa?=
 =?utf-8?B?eWVEdlBBaTRDMjRIZXl1K1R5UzZYOU5hZnRUVHEyeDAyOG9lZW9rbkdyazNi?=
 =?utf-8?B?TlhpWWR0S2QxRHI3bFZaaXozVnQ1TWk2TFZhbmxGNEt6Q3pKU2d6RkpJbzFo?=
 =?utf-8?B?eVBqeEFmUDVkNU95UnJqd1lyNTJRVW5sb1hNNHJVU2xWcWVocUhGdXBHeHRT?=
 =?utf-8?B?Vmk3Q05ZQTdLd2FMd3R1OWNIc1lRcEdtbUIzSGlJRE4rZklOeGNkR2Uwandn?=
 =?utf-8?B?NlJZaUVVMk5seGl3eUs5bzRwbE1uRGRjc0RGbXc2Q0hJeTZ5VFJ3cUoyeFNB?=
 =?utf-8?B?MXFJTWY4T2VwMkIydFdvRDZNbmt0c0JNL0cyM1hndkI4VmxHUUVPS3Z1dXA5?=
 =?utf-8?B?djVCK0VYTzNVODVYQys1L0o4dW1oM1ZvenJTZnhGMUlXTzZvQ2xSTGhqT0tS?=
 =?utf-8?B?S1VBb3dzeml3cytrRFUvamwzak52M0hSMWFNcmF5eTlEVDZLZHhSTXR4R1lT?=
 =?utf-8?B?Z2pTTFo2ZjZvUzlrQ2tydWttNUR6cG90RE4rSURUUEVucnE4NUp0SmJ4d3N5?=
 =?utf-8?B?VHlQSlU0Vm44alB1ZEhGSFFLbUtQa2lkZWJuQWd5WUQ2NUhHbTVqWDJYTUlm?=
 =?utf-8?B?ckd0YUkyRG9lT0Y0T3pCdGx6NlRNSnR2RlN1Nkd5MGhVN0d0QitxVGVlL2sw?=
 =?utf-8?B?Z3pCYTh2cFNVMmlEcCszSmVmWWQzT1FYMkovWGJqaFFYS1N3ZmdMS0M1M0pR?=
 =?utf-8?B?RytTa1lnYnVxbFZCWG9yV01BSFl3aU1lOUpnMWMzVVpRT0RKRjN2Uk5yYUZF?=
 =?utf-8?B?cjlXQ3pPSWNNU2FLN2h0TjZQVy8wcnIvT1ZKS1QrVTMrMG56REl5RDB3Z1BO?=
 =?utf-8?B?WFVvV2l6WHZKZGJKb3dLZ0pyZHIxRngyZE9RaW5wRzh2dFljNXJweXJxNmJy?=
 =?utf-8?B?UHZ3Z3VTYUZaNG1PdEpTeWhBQ1d3OXBTYkdKbWoxMDVIdXU5dWllNVZpMmdC?=
 =?utf-8?B?VDRPMER5T2U3UTVTZzRybElueXhWMU9vbU1nckt3NHJFcDhYaWpEZkZuVEQw?=
 =?utf-8?Q?/m9NoIw7BH6c9V0tXTya71Gtb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vUGchblKXQ16zOS8Q/zcN85isj7PxaD/f45WN2vIh6RxiVUcxWhG4anvxZT+y9tHl6RQi6w2Wy7dMOZBLDktzifPVik6eh08uUc+i6PlqSSqMpXSX6/ieZfuUkOVYtS3D6aSzB6jOITrRmnRb5bf2hRAirvL0lRzQm90igR9ewTM4g6dV6OzWMlhICCqSKJWEnDA9aY3bFrEJ0eHy7jlATC7GzkbekZZsuqvwTvWK0triDGUsqNK+WWOJte5GPjAfUa4RyNtutKyv/dF+uetI6uF+7a9caU7ZdfWedpU6EoS5vwzPcfHxbKrWvNPKJy8NNGehDaCTJx2YPrQBxejbtpAv+f6roo916fh6gv4peHlNYCkYqOoSyHz3U4snoe8BsSIaJsTHiczzstlno4wBH6EbbmISgu9WRWRAiCCq2g9MUiptK6+J0V//+XrU3bE9QJl/JVKRk5O0g61euk5SNPlTXe5rC1qZOCSpIjOvHw2u1nyGY/UOrVvdjeF8StCFibOrp02fA/AGAtvZiczvRSCCIjBk7zF+O0FBQNVmKhVongEWCRhpYwfgz/4hX+vKJ89eoOznltw0blSBEUrqogYPACpo6DCM3qLnDIU5L8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 634e164a-ef28-4556-573d-08dddaf8a071
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 06:05:53.7708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wv8Hb7ywjiTz6rN994kcGoAlAHUeDy4oqUpD91sDGZnJHUZpCX9zbnp20pR3x+RSJAwMSHL0V/cJoLElz/cfsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8201
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_02,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508140047
X-Proofpoint-GUID: g6Pm7uXtnHwoHkS3r7krDbsiNx8mL9P1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE0MDA0NyBTYWx0ZWRfX5pN0vsreO6vI
 3qIl7dPL5jBf9WVBVmlTUcwfkSR294qz7XAgPFy+IkpUJGMD6IDHukuhdOibdFVJruNxn2FhlsM
 FRkr0WEislSo0ct4t4/zizzK5ZEw2omnPc1jICyKBh5ftHEbeCi3ym89hr0KN6yxbOzntpUvC8J
 i4OLfdqVqWjxJcvMNvALogkPY3Z5IRYNrO1xEyy+Hut+ApM61oseVdBNRxVsuMElWr1/vGUJ1eN
 aZgw4hugFeJWhs3GTzjCHgFc8onjDI51rJ1CU6ydkxAAD0pAUpHzjTvn6XbJ/I5WCboUpjok4bJ
 i8P0YzisHDeATsfCx7Qj5cvEqx9nCQXjkYUMPqWzl2YNI3k75qdIrHbtja/4yjUAQdbY9cYXiTc
 eS4Hs7bc3ZU39+wtFn+MhLffTS3phHVv+5eQ9N2tqNcdvTD/0SaW2K16N4uKKkmfjwYJWnTu
X-Authority-Analysis: v=2.4 cv=W8M4VQWk c=1 sm=1 tr=0 ts=689d7cc5 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=i0EeH86SAAAA:8 a=yPCof4ZbAAAA:8
 a=qAiSCWvjBoQeJ2FlPegA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: g6Pm7uXtnHwoHkS3r7krDbsiNx8mL9P1
X-Rspam-User: 
X-Rspamd-Queue-Id: 6481510000D
X-Rspamd-Server: rspam06
X-Stat-Signature: acs3ccc4ntgdf8sc6kxw15wdu5gdfjfs
X-HE-Tag: 1755151574-704867
X-HE-Meta: U2FsdGVkX1/M3YwyY8F521xqE6bQLKXe9lo+dmQi7JCiTC7Z1e8mSRoq6ub2wRHNlx4231PMEGQ3Y798YFcJWaZirFyCU2E7+jUpZrnOZiNp8K4hjq2GwvJVS2bz9IWOseT4WQbvhsslDELkilItXa4ooLRT0cydlOLCYhTEp999xv2Yt+NN462Ga4xQyZAOY15ysOqowixcCsuWVUx1YfL8yjugLgbGe5Cz7TWrT5X8AW+6FncAts5EH71FjFxzul3L2tZJZTu7YV/4I4CexJigWDPkmhhIiRSYcScYBGIlF9PKwRZB50PyCxWZFIxltI/T7nPXe+5QbvK3qYS56pLQuGLhzP1yz0lYyI3XfJWgCL4SdPpVYuXxBlBoLJTQtTFMf6VJ2KRZtLSt2Nj0eEz3T+OBq7Lli13iUYkfX1GUg+pFPgS+8X6GZQWY17DvIHA2zVvHuYETnhFuNl4onYFErkY0W5Gw4PxKZ2zqQjbH9RlQZAPiFMBueiE68dt3r3IYrUQeilUEZBBhgw8wfUweNLHoFX9on5k+ev+CE3kQp2Cr5uoD6Q/3pygggojhZFxqv+k0bm/qEHBmhSyJC/p9wNd7oa6fCJXD1YDnIJbmLGLtJHnb1bD+Ap+6g+2NPyGk3C0SnZOBeBDfVcpmhETVlVVvJ40X+ZTEElEXfMjXiti3hz6Mc0R4eJJn0MWDdTlHlGqIBx1FEeOjwEz4fm7ApITz/HMrpz/PdQva59NjlNrMhUQRu+Y0aAocvS02ns5bWSfSMikTRz/Wo2RBmi1h24R6FE5Rsab1LsZHioYLSrcxlad6MpiFo1fJrfW5laEhyrJv61QfhSaYI6PxgEJAGUrPoTqZvNR9KWxNiS8EAXqrZoCR6RyXVAeD0ZSFkkGy+hFVZNm1BnonBvrpXDX0+yCXT56HBSTh15u+dWOZW9vkQGWYuxHgGHmAkeZsI2Dw6H3cOfFlPP0zdob
 oLDHVb1+
 IHSubQaZmIZ6foAxvy2NjT7dryHSxAJEvqimybXszf4Kei5llp/yDp672fdQo836yoiSH5AlugquazEB2o8x/TzrQGfB2r3sGOxwZSntV9Wrjm07JoDoByKx6N5H7/Q8S5khLCrYxDkGOWtOQIWgcRSwcbTVbMhtqm16owsGrp+kRRIcgUwchY6O8eLNhdYhExIFw0HNlK7tvuNc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/10/2025 9:33 PM, Jinjiang Tu wrote:
> When memory_failure() is called for a already hwpoisoned pfn backed with
> struct page, kill_accessing_process() will conditionally send a SIGBUS to
> the current (triggering) process if it maps the page.
> 
> However, in case the page is not ordinarily mapped, but was mapped through
> remap_pfn_range(), kill_accessing_process() wouldn't identify it as mapped
> even though hwpoison_pte_range() would be prepared to handle it, because
> walk_page_range() will skip VM_PFNMAP as default in walk_page_test(). As
> a result, walk_page_range() will return 0, assuming "not mapped" and SIGBUS
> will be skipped. The user task will trigger UCE infinitely because it will
> not receive a SIGBUS on access and simply retry.
> 
> Before commit aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes
> with recovered clean pages"), kill_accessing_process() will return EFAULT.
> For x86, the current task will be killed in kill_me_maybe().
> 
> To fix it, add .test_walk callback for hwpoison_walk_ops to process
> VM_PFNMAP VMAs too.
> 
> Fixes: aaf99ac2ceb7 ("mm/hwpoison: do not send SIGBUS to processes with recovered clean pages")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> Changelog since v1:
>   * update patch description, suggested by David Hildenbrand
> 
>   mm/memory-failure.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index e2e685b971bb..fa6a8f2cdebc 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -853,9 +853,16 @@ static int hwpoison_hugetlb_range(pte_t *ptep, unsigned long hmask,
>   #define hwpoison_hugetlb_range	NULL
>   #endif
>   
> +static int hwpoison_test_walk(unsigned long start, unsigned long end,
> +			     struct mm_walk *walk)
> +{
> +	return 0;
> +}
> +
>   static const struct mm_walk_ops hwpoison_walk_ops = {
>   	.pmd_entry = hwpoison_pte_range,
>   	.hugetlb_entry = hwpoison_hugetlb_range,
> +	.test_walk = hwpoison_test_walk,
>   	.walk_lock = PGWALK_RDLOCK,
>   };
>   

Looks good.  Could you add this to stable ?

Reviewed-by: Jane Chu <jane.chu@oracle.com>

thanks,
-jane



