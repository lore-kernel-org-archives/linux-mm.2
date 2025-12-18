Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFBDED711CD
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 23:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F956B0088; Thu, 18 Dec 2025 18:11:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7536B0089; Thu, 18 Dec 2025 18:11:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCFF6B008A; Thu, 18 Dec 2025 18:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D49866B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 18:11:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77EFF13AAA8
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:11:10 +0000 (UTC)
X-FDA: 84234139500.24.0E1CAA2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC97C140012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:11:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l7+mXb4n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r2ImGikt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766099467; a=rsa-sha256;
	cv=pass;
	b=dfZ7BL0hXDHA7RiFm0dNloFymwXVRHpLEE4v1VX5FgQGulNXegpw/S6Ndgue39zZOkZLXO
	krM81BDHo3dlIGKfZn2ZAnqQHOvoTgsGhGBa/PZG47YIRxSOl31cCJkLedkVOxXQr3SvS5
	+IBedGAyoJ+FYWrUdNfebeDi0fD1dgw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=l7+mXb4n;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=r2ImGikt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766099467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CK3FjlOn9EzW7kMDkGfBfz5Vsl1yedCyVA6/zuvGR00=;
	b=t+7nmrexCrjU2F/CF3y08asC5rDHmCZTGW3XcbYCjvY6S6lq0CHuEqaWetCCizlegTfMTj
	IpO3MLXG/ROcmPNXjdQ5PCeyrblCTNVnWKkbX3wiIUL4v7XLAGKLhrM2FhKh8dpFBnMedl
	GJ5j9gsC4iLZB45gG5735l8VTwBvud8=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BIJkLXo2012388;
	Thu, 18 Dec 2025 23:10:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CK3FjlOn9EzW7kMDkGfBfz5Vsl1yedCyVA6/zuvGR00=; b=
	l7+mXb4nBR1blEjkBFYxk5snMQMGWrEeEZ2/LEhOhLdrXj9oSe1lNXq0U6pf+PUl
	3jKlBSZjoZkjbuiqJtquOJ2mjseT6FG6b/ZZow5M51LW0wI7QcCAgUrASw1GWUEm
	TcD3rUGivl6ZOE4S7Mdpzk6mxnGIkozfutwBzY15/diYsKDGLqPE4TcPGa5KLfqI
	VAsIa7Ol26RYj4xoM9qMgmpJExdQy3HzbH5kDh01PwDchtl3iZbgrPPctJHkYQ7r
	BwS71i+ag07fK116djX7OK3jFoAWL4kHXaRJllDntfnXvbI447UkCPNqZoSckynC
	PDp5UJPcS7hE7Mh76ht5NQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b4r2bg870-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 23:10:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BILRMeC023428;
	Thu, 18 Dec 2025 23:10:54 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010067.outbound.protection.outlook.com [52.101.46.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4b4qta6yyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Dec 2025 23:10:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hMuTKRLLYuxN2JLHx9OaLshT7PnrLLoP3u4PtYx5rPrkZkyDTofBB5DeEVnt5ir0DK8LfMmBkKoABRcbNveM/TnH44mHkDVSi+NiNFut7AR/u1n1sgI65XY9twozX8vQ/MeNpD5t8mhusEB+ubexHOKTxdQp9Tny0FXhQyi632vEmNORehw6B37S5v3P7DJ0XeMp1bepFV2amZmYF+LUXabqKdkTp3rsGUGUD7r6g3C8O+sXUTAzpK/hqWbmdBqrMulMH5jACLlm3GD+6P+BfJcQB/J9oNS9q6ukd4EHHW+eCSUxSFKraf0Udku+psQcbYX2GY75tyrXcYza9uEl+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CK3FjlOn9EzW7kMDkGfBfz5Vsl1yedCyVA6/zuvGR00=;
 b=GBBksybEkkcIBiQyL+TsT6h3xMbqRO90zgfOZQgb19Sz8/Xw+CiAbaeLYSW06BFBS+lE6Vhz1WSfqbT+azwDEJG8j5RljbRlWRn7lTb1vutiW1hydx0P3CXcADy0IkDc8WP40M3jL4eu0Emqy+DoImxE25S6V6n5nTzG5CxquUAbQE8jmIy+LJKTZa96V5Btp1NSXUyXLABSPMjTmqq3DL+a12LWnRwYAmX1BdGXURoRfsHsvt2kEnT/K7vxBTga6BFWeqliC6WBUdx6Us9vlLqCbHz7vkeDS5M9Vf0wT51JLKhof7jadLUFmMwrIMub7bj4wE2hIFH5JRXuh3gd6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CK3FjlOn9EzW7kMDkGfBfz5Vsl1yedCyVA6/zuvGR00=;
 b=r2ImGikt4tWtKogo+ZB483F1LE6kJxCVPVLKxbmbELC8eLEA+0k68j3FcdXWyT04k/EbVW+sI7/8hRdhz4qa05cRsC5YZG3KSz+yahkRvSgqNxHT0MnHNE6H4QIQLbo2Qo4QZVb137jBMBQEw2tADWDuoMa05Dcj4Pr42hWqGmU=
Received: from DS0PR10MB7364.namprd10.prod.outlook.com (2603:10b6:8:fe::6) by
 DS0PR10MB7901.namprd10.prod.outlook.com (2603:10b6:8:1a8::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Thu, 18 Dec 2025 23:10:48 +0000
Received: from DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f]) by DS0PR10MB7364.namprd10.prod.outlook.com
 ([fe80::a4df:c903:e1aa:322f%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 23:10:48 +0000
Message-ID: <55542653-8902-46ea-b416-776fc58bd644@oracle.com>
Date: Thu, 18 Dec 2025 15:10:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        "David Hildenbrand (Red Hat)" <david@kernel.org>,
        muchun.song@linux.dev, osalvador@suse.de, linmiaohe@huawei.com,
        jiaqiyan@google.com, william.roche@oracle.com, rientjes@google.com,
        akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
References: <20251216215621.920093-1-jane.chu@oracle.com>
 <a7cec1cc-bcab-4dff-926b-f3d3c5136f61@kernel.org>
 <609ec743-e989-4c50-904a-80388d6a0096@oracle.com>
 <duh4px5nbhpuy2t3oztp7gersieo5q76kdlbzkgya27cxmaoxs@uvzwpigeknpo>
Content-Language: en-US
From: jane.chu@oracle.com
In-Reply-To: <duh4px5nbhpuy2t3oztp7gersieo5q76kdlbzkgya27cxmaoxs@uvzwpigeknpo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH3PEPF000040A5.namprd05.prod.outlook.com
 (2603:10b6:518:1::54) To DS0PR10MB7364.namprd10.prod.outlook.com
 (2603:10b6:8:fe::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7364:EE_|DS0PR10MB7901:EE_
X-MS-Office365-Filtering-Correlation-Id: cc03daa3-59cd-463d-bae6-08de3e8aae0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YVlBeDduR0ZKb0VLSTNUYkk5dXk2TUduNDNQN3NQbHB0bXJLam5XRWZxZmhw?=
 =?utf-8?B?dzNJaEhrTmFFSHR3b25nQ3R0NVptTGViTTdxeDhvek9kNk44LzVQcmgyb05n?=
 =?utf-8?B?a3JPUVc2MUw5MHNOWWMySmZWNTdoV2h5d05Sb2NqSFN5UGhrYlpqU3QvaUZG?=
 =?utf-8?B?WEx5Ny93Z3NPZTJBU2tZWmx6SWdrZDBwVlNJZXBxTDJodTFBQWpZbHlWK0cv?=
 =?utf-8?B?N1RQS3FwY3FqTGYzbHFaS0dpTEtxMmdSQi8xcnk4cVhPa2xxaS9QSmhSSWhC?=
 =?utf-8?B?MndTdlZVZDJxb0RMZlNHZHZvUktkTmUzY0JXT1AwQ2tVWGgwSk5QaU5Ybjgv?=
 =?utf-8?B?UEJwS1NocXNvMktFYnRCMlpCY2J0OXYxeGRSSG15SWhPUjVFdzU4amJFblJk?=
 =?utf-8?B?T1BRdXlCalVkVldkWnFSTDUvTmtmQTU2Rkhzd1NNWWx0UzFmVkZndnlKeWJL?=
 =?utf-8?B?MnNBbHNSZVFGVUxXVHVJQVpIOGtSMkZ3ZklhQWhlQTlIaHY0OG1TODNEVTZO?=
 =?utf-8?B?bktTMUtzamxsVVlZbjRrK1lrUDVsYUFtQkdtcWo4SDIrcDhGc21xU3RIOFlX?=
 =?utf-8?B?d1VRcEcxNXF0Ym11bndwU2xlUjR2MFVzdExXSG53U1BaSk5GTVprWFFvUzV4?=
 =?utf-8?B?TFNheGRwUTdXc2dyYmFwWTk1Skw1WHFReEpxMVdBVWhUUVVzMEpHVUJYOURx?=
 =?utf-8?B?blp2Vkpjd3VVWE1IK0ttMmRaQk05Ris1UzdiWDcxMVZvSjc3aWtKOC9LSER4?=
 =?utf-8?B?ckUvMDJFVHUvbW1zc3FDTStuR3hCdVUxQU4zQVhQZzJTRHd0eFZodnZuTzNG?=
 =?utf-8?B?KzNYUHdUMlU5WWtLK1hhdDJLZ3FuS0NSZVlaMG9VcVo0UTRaNm4rOGhEZ3RV?=
 =?utf-8?B?dHQvT1EwOWwvSUdhNDRLUG1NYTZ2ZzBtM1NQUENqa1lnZGM5VjNwQW5DaWhy?=
 =?utf-8?B?aTdiTFhGbmpvZUZiMkp2Wm5MVFlOd0M5RWlXck1MbnFiZTQ0TGJkNU5ObldI?=
 =?utf-8?B?Z1RFNmFKemNaSGRaa0g2OEU4dlZCaVBOY1lxd251NXhsZ0kralZwYnpWTlVZ?=
 =?utf-8?B?a3owUDRnS2l1VEJaTWdxS2lCZEdxemZtMWlicnkwSTFsNUQ0VUhDWU00VjhF?=
 =?utf-8?B?YmNtWDkvcy85NHZhVlhYZ2Ezcy9vWi9PVW9UZG1PSXhpSTIwaXFnN2RmdGhZ?=
 =?utf-8?B?ODdXY3VCMjNxNmNuZ25Ud055V25HL3MxNkN6OEdqWlBEYmlwcWh4UHB4dFZo?=
 =?utf-8?B?MWc3SEhHcUNRVlprNjZrTXBhcmg4OGpYVk5TRVk3cWo3K0dPS0lsNGp1RkFI?=
 =?utf-8?B?VDE3YXVIekkwQjlaS1FHUm5jekhXNXB2R2pxMEozUEJLL1V6Y2YxTkg4WWpz?=
 =?utf-8?B?ejk3LzhyZVQwdG9aQUdFV3lpa3VkbHVQWWpKQVZtNDg0VjVWMTRNeU5aK1l1?=
 =?utf-8?B?aDBvNnV1RlkvR3FaTlg2OEx4M3dadXgyUWlwMVVWKzM3WUh1cm5ZR3FPQlpO?=
 =?utf-8?B?NTdNQW4zK0M0cGM2b3RNMFVLd3pvaFdDaGNjT3pIdWxpRGJKZC9LSnpSOEVh?=
 =?utf-8?B?RVlINnBGOEZscVoxenZBVWlMd3RwWGtDSWM4YjlSYVJMRnZydnAzNE9kSTQ0?=
 =?utf-8?B?RStpZEQrYWp3UGF4YUpuYzV0MFpSL3VBYlJuWkFCMThNc0lCSUp1Q1IvSEpI?=
 =?utf-8?B?ZW9MZWlUaGpCWjI0ZXhRaTk4LzFOaWkveXNOVklaUkRKR2V0ZExPY2tPZFVZ?=
 =?utf-8?B?enhiS2ZuNDlNMFJOeFgxM0RKUHpOZEJGL3IydHZnbExEMW1vdmxhdG41dHg2?=
 =?utf-8?B?b0dPV2l5cDg3Z29EdHhaWEcwaHovUWtNaDlVc050SEU0TjVSaG51VGhCRG5C?=
 =?utf-8?B?a0p0M2wzcnN3ZEV2aDBzVkZORldOTUNQTlhhM0w1SlpGcHNrWUJSdndFUU4v?=
 =?utf-8?B?Z2huMHpBY1FLaHVsdjBzRjEyRXBkWGZvdjg4c0tuT3F5Qk1MNlNnWDZvaXlL?=
 =?utf-8?Q?ei3lU94qd9Mf3yNpokQi8z3P/Viw3w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7364.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?L0dQUG5zSTI5WEhVTi9paXYrY01DYjd3MFNSaUYyc3NUTEtWQjZOSzRMcENM?=
 =?utf-8?B?di8yMnNkdmU5TEZQalFOUHBxL3pqQk4zL0lqdEZ6NXFxT2dHUC96NU1rTXRH?=
 =?utf-8?B?WEMrVXVpNFR2VWo2REU0R1E0eDhSRFU1OXZUYjZYaUl2TXdZTkpPSlZNQmY2?=
 =?utf-8?B?UFAvMmZwNHBnMTdoVnJQZFdnL1dUSHFWY0dUOXhwMzJkaVpDN1lYZmx3V0pj?=
 =?utf-8?B?bDE0VjJ0dUg0VHEwWlk4eFhaVlNUV3czTkhtNnRJc1VXS0FMdHNmcTY5Q1lo?=
 =?utf-8?B?WHl0cnREN1ErUzFzT21kcDVPUTViSUJKVDFKRTBpY3d0LzlOM2VULzNXVFdy?=
 =?utf-8?B?L25QRmZxWktmdTFSeGNUbHc4TERtU2RyK1dNaVJzaitJRmFJTEdNZnNaRDgx?=
 =?utf-8?B?ODlsYzV0cmxYMmZvZ1AyVEw2V05FMFRNT0ZIZVlJM0UzVGhLMlFWZ1g5MFJU?=
 =?utf-8?B?K1oxWVFNUFluaXZJRmE3cWdRd05meDJ2bm53b29UVElPQnJ1MlhJNUszeFdE?=
 =?utf-8?B?OGM3OGd0TFhRTlJtOVh1RG5XTzRRbTdYOE1LRzRpRkhZM3R2MmZ4eURyOVZQ?=
 =?utf-8?B?eS9oWTNrNStHYjJ4aXJ5MEVLYndGL3VOaENxL2xUdVRjTGNqbHpHNmY0blRh?=
 =?utf-8?B?VTZxamtOdXMrWThFU0YrS21SbWVWRkxIMk5TNG85MkU3Mnd3enZxYTZmNU4y?=
 =?utf-8?B?RVFWRjFhV2Qzcm1ENUY2NGdrWEhyUFA3WUlXVUhjQStkejFJTzNqQ2VRRFc1?=
 =?utf-8?B?MEFoeUtpMDcvUHo0MDAxMUdYMGRlQTRiYllNdGY5WHFqbFQ3TlpxWnUreW9z?=
 =?utf-8?B?aGdIUkFIMzNOSDJ4Nmo1elhQNVNHZEx6dEJQU3o3UlhndWxsamJkK3VEYXkz?=
 =?utf-8?B?WG5wY3gzbTl3WXFjVjBqSGp2YllhVGZ1dTlVMHNsR1B4RElJenF1SWF2d2Yy?=
 =?utf-8?B?UXpFUU5GNzRoN1A3QnY2MFhmaC9rNE1TYWZLYUxROHdHRGVTUWU0TVRTaFgv?=
 =?utf-8?B?bnd0OFg4VktTRmRnNTFtZDFqNmJkVHZNNC9ndDFGazhGcHhaeUFOeTZYU3Nm?=
 =?utf-8?B?NkZuSU55Y1luYmVJc1FuaXdYQW1XYzNUY01pNmtmRWlsV3NZdFJtblhlV0NR?=
 =?utf-8?B?bkcvK0tPZTBTNVdzU1RSamx0R1BuQUFMQitKVXpTU0hCbzZHb0lJdXlidldx?=
 =?utf-8?B?akhJTmlleW9Wa2FrbnFDT2Y2UHVJVmVRSkNtUEYzcnc3SzB0Y3puUU85WGkw?=
 =?utf-8?B?d09FbE9HQnpHNUxqUkFvOXB3d3R4Q21mSXl1Nll4RkIxTWt6aVo1bDY3Zmw5?=
 =?utf-8?B?N2lkdFRGZFFrR29maTR3ZjNaWjFjK2lPbCtDV1M3bkhtamRNb3dwU3JzZmJs?=
 =?utf-8?B?d3F2c0tzaHNvVFc1WmpiT0g4QlZsQmhvQUxsMWJqUmhWeS9zcUltTWxrWmwz?=
 =?utf-8?B?V3BkNWJ0VThOUzdDbEk4RVVCblNjdGpaNVN4cVpxL1hsS0dWYXdBTHR6cldZ?=
 =?utf-8?B?R3RxSFpwMmlsWTZ6OHR1ZXc1QVFTczc4b09yQkZ1OXIxM3BkYldKMzdvMG9m?=
 =?utf-8?B?R1FmdS9SeUN1N3ZQU29zbGNDYWNPWk5pUFl2US83L3pCSzZzTHBidFBVSlp1?=
 =?utf-8?B?SFR0eFMxS1A1RXltY2VVRVIwMjlTVkxOZTlFVU1CM1VCaFdhb1ZyZjdJYzJX?=
 =?utf-8?B?WTAxdmg0dkp5OFZuK3lxaE95NXhnZHRzYWg3Z244ZVdxVXF3YTA0dUZlSy82?=
 =?utf-8?B?VXFNVTQ0bnZvN09iR1hYTEhkYTI5RGpXR0p6aEVNQWkzWFl3NUg4ZkFTUWpq?=
 =?utf-8?B?S1lwREtlTVJoQWQ0L3JaOFBoK2hQV2JBOTBqbTlyZi95YWJ2MXhnb3Vlcks3?=
 =?utf-8?B?UmNEaDlRWjlrUG9zWHYwMFJ1b3V4OUlTTDZ5ZFZZVHNOU2VsSkNlaWZmMmNa?=
 =?utf-8?B?SFowMHdyT3RKZnh0MmZSY2c3K2pXZHEza3ZuYWUyUktualhaQ09vblBXdU1S?=
 =?utf-8?B?L3RzOXRpcjljdmdWUDFkendUbVVVeTZrd0k2aTVpSndjTkR4VDhTN3JBaFFn?=
 =?utf-8?B?NnB4MTcvd0xYOVc3WkpBdHc3eDRLTE43QVRvNW5jZFdQTEJsV2pUTHdhQmp4?=
 =?utf-8?Q?1c/r7USfqTDK4qxsSj2ZDWayS?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KU+9oNDAoAd8zzPbAyN5lpLtfYgeE6tJVq+hHnhTTobDSUF+m/APNms/FrBMuoIv9+sI/Bs6TTVfrqAbkDohlzn/gRwQYOucGUxvFGEx9CnSBKAJjRsyeVO+KdYLbKhQoP0Pdlr3Lk4gG1XW9oyLvFLWpVSJzG+vEIzB0mN+10tB0AnVjQoE/zeYIZEh5Ig7MWi0/KEiAhFBI/9B3MFCbTWrVK7ANmVmTMOXM5T0wZP2mSYDjcVyV6kKEl8jCLaEpsInPORGASD4y79uHOlt+rH8jqFZgpPDTz+qND1oCfkTN2G2CYrOL6QfOIy1dKjVvSWWvYp/gLXrTmWbiR8M6zB7ia+OkDuq65+hVgmIJQzInkTvzLTTkTzYznx3YlBJwhSUN7udrB2qSXVykYCW6Uwaw+7c3wD4WqYuk7O8rg/FIzRosBxamxSrYZ+5kHGQnhRvV6MD50L2hO0rDTEyD6wse9GiFFe6dw6errRj63yZwR90AN2zwQVsAMk9NnvwiYcfdHD2oguqphAh2JXKoe6VIez9eRD8sOs+T2s1FteZDpGUjz3AGhiISOHp0BmCSEFGeC/JcE9dCxy1tz9zLLrvCeC9oCWaDkswBtOk1u0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc03daa3-59cd-463d-bae6-08de3e8aae0e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7364.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 23:10:48.1360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oDX52E2fkqOgNlasKRt4nNUhqqCok71BiC5Pw9wOsCfRveVBzY3XrDqojC0fIJAeLvigTBi22DmQ6AdApZt0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7901
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-18_04,2025-12-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2512180192
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE4MDE5MiBTYWx0ZWRfX/2HR8RUXjl+I
 TRiFyekQLHaJ0b3vG8fm8XekwCuglA/seNNONPA2lM6pPry4oBapNPWMJymvhsmo7/69PgUz1vb
 PLD/gyIvrejJgS31C5vKN0Ic8KBklailkfsKGOwJaNAyQfIJxnKC/fzEGjFfVfwP3F6biLZIPlk
 7NdSLf/d0KAWrrCDlLRSbuhAE9OgtwQK6ozEUWF75YgkWmApp0S7d0ly5c83zkeKgz1twcmePqH
 9CCKzRsaoL8DE2+dR3QEY+VbbtA4q7cpmlRWedaenKREQPahFD5dAB1kMxT/oLVaqW7yaNK0SF5
 P7lGrexxGFk12RCbiFXkJlwq6ltcd0FT1wD9C6ZdPmuy/fR7+03ENnTiKwwPWFpY9fZmVIgIW/J
 ZiqmftjADOAafFBtKnaNkbfchHXJECSkcSmV3s2mRD4IoUR9YCRqVSpaA2GLzLFWVPjGTgjrJNE
 WP2/eD8P/zLpWaXB/mQ==
X-Proofpoint-ORIG-GUID: TQXanPgQrIlOGOoa87FBlmLj-fKMOOZh
X-Proofpoint-GUID: TQXanPgQrIlOGOoa87FBlmLj-fKMOOZh
X-Authority-Analysis: v=2.4 cv=ObyVzxTY c=1 sm=1 tr=0 ts=694489fe cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=fK-H9Fk8nCuYdnkHjqYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Rspamd-Queue-Id: DC97C140012
X-Stat-Signature: fwu7y7zz9j6hikkoy3gsg8uuiba1huxj
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766099466-73428
X-HE-Meta: U2FsdGVkX1/4qWvyL1dElN0cIzfRSjSfQ69zxyMwPClhvt4DR+bbPjpDzJFILJVUitbiaLNCbal0r5knTT8MaQQ9M9t/6HmONBvKsFnmxFUNBr9lrCkrldcF971OJTHAM+ekNtpElo/e4OJWSHZTUin1L8Du/m+tYBHRzjxlipCaem4l7oerB+M8ExV1Jl6M1UwoH4MHq6EK7zRFbyMw0OBAjALBS1aCi7P3SuCWl8x4jb9NW5BcExYPlhRdZFsx6zV5AZ7ypCANRsOfGKqQ7C4VDnD5lBFzee9BLbcjmHTnIu5dirTmTPqns4J/f9WMiyBemc4WY+o+H5Z9CHMcq4Utnq9pzQjFWn4t+C1JIIsdrUF06UovliRJ8iC3Lh/F5mOqat3sk7K7qM/zpEVqm1YzubAKdAs7nht00rML3TlMwKP1bU/LnBwkuUcI2iOEDYu3Nuo34OFtYISJjNkc836Jm4va+3ZmbGkLAPQJ1j6HN7DUVJv2DFF/Y2T5+6S5dpCNRUZwMvmROy2gbxnVobyxhT/mjfLJ7f29czMiyUxbEBmlfW85C2wL2aixv0p06tsxuKV8eLpHFDVxawe8X+2L9S3LdkZ8ulqaPY8d6/IvVNasGCFNSI2C5V/beQ1pp36FmG2z2C/BxJn1HVKRy8ciDEenmZzdU8p16Z081JkJ+AFJw9iEfbEHviWwX/ysJmLBRkqowVmSxpa860/R+ncCCfV+gs2JSpje7YpIg00HcXNd/XBgZj6ALRJwMqu9AZbFVMjpqd4KH2+jNOQ+Po9VOPoeVHTckD+GYDbvCWC5uiaJh7u+K4ZMy/qv0J9ehtY4wczXnlkeas90KsYTLOv77s5K1u0iZSPowhkUptIjuY5IXLR8AGfmqvkXeM5rzCQb7VpSEcFKcs2mrZigXHZFFpSoPa16g9RGEgXODPr7UX5EpvnnnNf6Bd4Fh9CLnGD1pjdUOGf1oqIuubo
 wPtZrZRo
 //TtL/jcA/RxAAgKiB6cwqsiye/doS80On97svdrPrZV3R1BvzXboWXBnD3WdelDi2K/AZFq1CqN4bxn6a14ckKQrC0q8HHkIukPWF0pHe7TbJ+tlSelwS82nBiH99Fsu67IAUAD+TGml9tzq5hG675exTS27ZF57nbIFXJ6tN598Bj3pUrSW9P3+7UkWlaG5FcYZrC+j0696p/mHvyEULzYFgy0l+3ouQqaNA5to5aHsnTVhTM6Kch1bwHPSR6p4M9S2a/WHlC8zrLVuAldJFeKHq4P6ir66QMEgWxI5sYCcYWiGmDyc7A9a2M9aunESaG/PJsv8W/etVFREcn8mdnS+QSmFz2oiHfYvq/uaGo+fF5KZ8Qh3TCALEBmI4x+j3jUcs8DqCRavkaqH8Gmeo2T1X9NUFF6MF/RA1ETqSzWLsgo6OXALT9UPYMpRaGc9OMmNtxU9KxtaGSrI90IqgyjylPG2bGcp1GIfjk5XL7e/GkfCWTjEkQihMcmSpCweAXXDmHDyhXD85Ie/LzJ+qZJlmlKGQCLSesZPvB7vF6j93uNB8plUohcEzT+0V/JOeSZf7Vd87wLEZ45pqgBOJz5L+G06aPflWneRpT1xTC2iAkK4li7BNHMJys5twdPl4FB88+KtYfSfv5y5bgOJ0ZBgGizHioCV2tgtzfY3NgLPkNdTUQug3j+uMbyRddmw1cjFRNvrQksOQh7mPgxbmUh9nnkPpBMBzBCnBVwCGCObXVk8zOLf92m33A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Liam,

Thanks!  My reply towards the end.

On 12/18/2025 12:26 PM, Liam R. Howlett wrote:
> * jane.chu@oracle.com <jane.chu@oracle.com> [251218 14:01]:
>> Hi, David,
>>
>> Thanks for the review.
>>
>> On 12/18/2025 12:41 AM, David Hildenbrand (Red Hat) wrote:
>>> On 12/16/25 22:56, Jane Chu wrote:
>>>> When a newly poisoned subpage ends up in an already poisoned hugetlb
>>>
>>> The concept of subpages does not exist. It's a page of a hugetlb folio.
>>
>> Okay.
>>
>>>
>>>> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
>>>> is not. Fix the inconsistency by designating action_result() to update
>>>> them both.
>>>
>>> What is the user-visible result of that?
>>
>> For the purpose of observation, and potential action afterwards.
>>
>> # cat /proc/meminfo | grep HardwareCorrupted
>> shows 'num_poisoned_pages', the global count of poisoned pages.
>>
>> # ls /sys/devices/system/node/node0/memory_failure
>> delayed  failed  ignored  recovered  total
>> these fields show the per node ->mf_stats, that is the MF handling results.
>>
>>>
>>>>
>>>> Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats
>>>> to pglist_data")
>>>> Cc: <stable@vger.kernel.org>
>>>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>>>> ---
>>>>    include/linux/hugetlb.h |  4 ++--
>>>>    include/linux/mm.h      |  4 ++--
>>>>    mm/hugetlb.c            |  4 ++--
>>>>    mm/memory-failure.c     | 22 +++++++++++++---------
>>>>    4 files changed, 19 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>>> index 8e63e46b8e1f..2e6690c9df96 100644
>>>> --- a/include/linux/hugetlb.h
>>>> +++ b/include/linux/hugetlb.h
>>>> @@ -157,7 +157,7 @@ long hugetlb_unreserve_pages(struct inode
>>>> *inode, long start, long end,
>>>>    bool folio_isolate_hugetlb(struct folio *folio, struct list_head
>>>> *list);
>>>>    int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
>>>> bool unpoison);
>>>>    int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>>> -                bool *migratable_cleared);
>>>> +                bool *migratable_cleared, bool *samepg);
>>>>    void folio_putback_hugetlb(struct folio *folio);
>>>>    void move_hugetlb_state(struct folio *old_folio, struct folio
>>>> *new_folio, int reason);
>>>>    void hugetlb_fix_reserve_counts(struct inode *inode);
>>>> @@ -420,7 +420,7 @@ static inline int
>>>> get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
>>>>    }
>>>>    static inline int get_huge_page_for_hwpoison(unsigned long pfn,
>>>> int flags,
>>>> -                    bool *migratable_cleared)
>>>> +                    bool *migratable_cleared, bool *samepg)
>>>>    {
>>>>        return 0;
>>>>    }
>>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>>> index 7c79b3369b82..68b1812e9c0a 100644
>>>> --- a/include/linux/mm.h
>>>> +++ b/include/linux/mm.h
>>>> @@ -4036,7 +4036,7 @@ extern int soft_offline_page(unsigned long
>>>> pfn, int flags);
>>>>    extern const struct attribute_group memory_failure_attr_group;
>>>>    extern void memory_failure_queue(unsigned long pfn, int flags);
>>>>    extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>>> -                    bool *migratable_cleared);
>>>> +                    bool *migratable_cleared, bool *samepg);
>>>>    void num_poisoned_pages_inc(unsigned long pfn);
>>>>    void num_poisoned_pages_sub(unsigned long pfn, long i);
>>>>    #else
>>>> @@ -4045,7 +4045,7 @@ static inline void
>>>> memory_failure_queue(unsigned long pfn, int flags)
>>>>    }
>>>>    static inline int __get_huge_page_for_hwpoison(unsigned long pfn,
>>>> int flags,
>>>> -                    bool *migratable_cleared)
>>>> +                    bool *migratable_cleared, bool *samepg)
>>>>    {
>>>>        return 0;
>>>>    }
>>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>>> index 0455119716ec..f78562a578e5 100644
>>>> --- a/mm/hugetlb.c
>>>> +++ b/mm/hugetlb.c
>>>> @@ -7818,12 +7818,12 @@ int get_hwpoison_hugetlb_folio(struct folio
>>>> *folio, bool *hugetlb, bool unpoison
>>>>    }
>>>>    int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>>> -                bool *migratable_cleared)
>>>> +                bool *migratable_cleared, bool *samepg)
>>>>    {
>>>>        int ret;
>>>>        spin_lock_irq(&hugetlb_lock);
>>>> -    ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
>>>> +    ret = __get_huge_page_for_hwpoison(pfn, flags,
>>>> migratable_cleared, samepg);
>>>>        spin_unlock_irq(&hugetlb_lock);
>>>>        return ret;
>>>>    }
>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>> index 3edebb0cda30..070f43bb110a 100644
>>>> --- a/mm/memory-failure.c
>>>> +++ b/mm/memory-failure.c
>>>> @@ -1873,7 +1873,8 @@ static unsigned long
>>>> __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>>>>        return count;
>>>>    }
>>>> -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct
>>>> page *page)
>>>> +static int folio_set_hugetlb_hwpoison(struct folio *folio, struct
>>>> page *page,
>>>> +                    bool *samepg)
>>>>    {
>>>>        struct llist_head *head;
>>>>        struct raw_hwp_page *raw_hwp;
>>>> @@ -1889,17 +1890,16 @@ static int folio_set_hugetlb_hwpoison(struct
>>>> folio *folio, struct page *page)
>>>>            return -EHWPOISON;
>>>>        head = raw_hwp_list_head(folio);
>>>>        llist_for_each_entry(p, head->first, node) {
>>>> -        if (p->page == page)
>>>> +        if (p->page == page) {
>>>> +            *samepg = true;
>>>>                return -EHWPOISON;
>>>> +        }
>>>>        }
>>>>        raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
>>>>        if (raw_hwp) {
>>>>            raw_hwp->page = page;
>>>>            llist_add(&raw_hwp->node, head);
>>>> -        /* the first error event will be counted in action_result(). */
>>>> -        if (ret)
>>>> -            num_poisoned_pages_inc(page_to_pfn(page));
>>>>        } else {
>>>>            /*
>>>>             * Failed to save raw error info.  We no longer trace all
>>>> @@ -1956,7 +1956,7 @@ void folio_clear_hugetlb_hwpoison(struct folio
>>>> *folio)
>>>>     *   -EHWPOISON    - the hugepage is already hwpoisoned
>>>>     */
>>>>    int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>>>> -                 bool *migratable_cleared)
>>>> +                 bool *migratable_cleared, bool *samepg)
>>>>    {
>>>>        struct page *page = pfn_to_page(pfn);
>>>>        struct folio *folio = page_folio(page);
>>>> @@ -1981,7 +1981,7 @@ int __get_huge_page_for_hwpoison(unsigned long
>>>> pfn, int flags,
>>>>                goto out;
>>>>        }
>>>> -    if (folio_set_hugetlb_hwpoison(folio, page)) {
>>>> +    if (folio_set_hugetlb_hwpoison(folio, page, samepg)) {
>>>>            ret = -EHWPOISON;
>>>>            goto out;
>>>>        }
>>>> @@ -2014,11 +2014,12 @@ static int
>>>> try_memory_failure_hugetlb(unsigned long pfn, int flags, int
>>>> *hugetlb
>>>>        struct page *p = pfn_to_page(pfn);
>>>>        struct folio *folio;
>>>>        unsigned long page_flags;
>>>> +    bool samepg = false;
>>>>        bool migratable_cleared = false;
>>>>        *hugetlb = 1;
>>>>    retry:
>>>> -    res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
>>>> +    res = get_huge_page_for_hwpoison(pfn, flags,
>>>> &migratable_cleared, &samepg);
>>>>        if (res == 2) { /* fallback to normal page handling */
>>>>            *hugetlb = 0;
>>>>            return 0;
>>>> @@ -2027,7 +2028,10 @@ static int
>>>> try_memory_failure_hugetlb(unsigned long pfn, int flags, int
>>>> *hugetlb
>>>>                folio = page_folio(p);
>>>>                res = kill_accessing_process(current,
>>>> folio_pfn(folio), flags);
>>>>            }
>>>> -        action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>>>> +        if (samepg)
>>>> +            action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>>>> +        else
>>>> +            action_result(pfn, MF_MSG_HUGE, MF_FAILED);
>>>
>>> Can't we somehow return that result from get_huge_page_for_hwpoison()
>>> ... folio_set_hugetlb_hwpoison() differently? E.g., return an enum
>>> instead of "-EHWPOISON" or magic value "2".
>>
>> This is an option. The existing return codes are as follow.
>> __get_huge_page_for_hwpoison():
>>   * Return values:
>>   *   0             - free hugepage
>>   *   1             - in-use hugepage
>>   *   2             - not a hugepage
>>   *   -EBUSY        - the hugepage is busy (try to retry)
>>   *   -EHWPOISON    - the hugepage is already hwpoisoned
>>
>> folio_set_hugetlb_hwpoison()
>> returns
>> 	0:		folio was not poisoned before
>> 	-EHWPOISON:	folio was poisoned before
>>
>> To get rid of 'samepg', how about
>>
>> __get_huge_page_for_hwpoison():
>>   * Return values:
>>   *   0             - free hugepage
>>   *   1             - in-use hugepage
>>   *   2             - not a hugepage
>>   *   3		   - the hugepage is already hwpoisoned in different page
>>   *   4  	   - the hugepage is already hwpoisoned in the same page
>>   *   -EBUSY        - the hugepage is busy (try to retry)
>>
>> folio_set_hugetlb_hwpoison()
>> returns
>> 	0:		folio was not poisoned before
>> 	1:	        folio was poisoned before in different page
>> 	2:	        folio was poisoned before in the same page
>>
>> The whole point about identifying the same page is so that the re-poison
>> event is not doubled counted.
> 
> This means folio_set_hugetlb_hwpoison() returns 0 on success but
> positives on error.. this seems to be going further away from the
> standard way of doing things?

Yes.
 > > It would actually be good to remove all magic values instead of
> expanding them.
> 
> I think what David was trying to say is to have a local enum that states
> what these numbers mean so that the code reads more cleanly, instead of
> digging for the right comment to decode it.
> 
> For example, in try_memory_failure_hugetlb():
> 
> if (res == 2) { /* fallback to normal page handling */
> 
> vs:
> 
> if (res == MEMORY_FAILURE_NOT_HUGEPAGE) { /* fallback to normal page handling */
> 
> You could spell out your other options as well.  Maybe something like
> MEMORY_FAILURE_HWPOISONED_ALREADY_COUNTED
> MEMORY_FAILURE_HWPOISONED
> 
> This would avoid adding more magic values and increase readability.
> 
> If you changed try_memory_failure_hugetlb() to use a switch statement,
> then the compiler can catch unchecked enums for us too.
> 
> If you don't want to go the enum route, then you could use a different
> error code and propagate it through, like -EEXISTS for the new case?
> That way the return is still 0 on success and less than 0 on failure,
> but I think the enum idea has a number of advantages.

I am open, actually prefer enum with switch statement as you suggested 
above.

What about folio_set_hugetlb_hwpoison()?
Indeed the conventional way of folio_set_X_Y() returns only two possible
values, but we need three.
How about changing the function name to set_hugetlb_hwpoison() to 
deviate from the convention?  afterall, the function does more than 
conventional bit setting, it maintains a per folio raw-error linked list
to track the poisoned pages within.

Thanks!
-jane

> 
> Thanks,
> Liam
> 


