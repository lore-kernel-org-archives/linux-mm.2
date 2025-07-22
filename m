Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEC1EC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 17:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4626B00A5; Tue, 22 Jul 2025 13:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A4B76B00A6; Tue, 22 Jul 2025 13:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26C526B00A7; Tue, 22 Jul 2025 13:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17DB06B00A5
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 13:25:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B57D51329C2
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:25:39 +0000 (UTC)
X-FDA: 83692577598.14.7DF0674
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CD564000A
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:25:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eSgy1zBs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="b/M5n4rO";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753205136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0Oe6AW5zaAE+JwKZ+KDBk/+GtF8AEK3vS1ClI8Nx9w=;
	b=zlM7uNZvaZRuV5wvJo3sq5Xo4MqbQKceaGriZTrseb0M2DFPh0ZxXc+Ghpwe1ihyxcJYos
	uX9BHEM/xPC/1g+IvKcid1SPhUJytbq5xIFUBrvSqNOczu3Q2tqqzobGuoBtvr+6egVKO9
	KNUNTfVdh2zfQA4eLG+X9fWA5kdUTI0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753205136; a=rsa-sha256;
	cv=pass;
	b=odBQD1yUNJ9RnhtAKwyMUc2/c8MLVNZQV2l/8NhdKS6dVYQH11/tIT5loYqTkZ48vd4MwM
	o2Tqw0kIbTNZEgagESLmMT9jHfCgYXZi0kNbUCT9OSSfGgsluzOJzEO0IFlIPcdC6mPFzK
	si582KVJvBSXe3jtd9DNeqjwr3io9+Q=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eSgy1zBs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="b/M5n4rO";
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf27.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56MFXuvt012114;
	Tue, 22 Jul 2025 17:25:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=w0Oe6AW5zaAE+JwKZ+
	KDBk/+GtF8AEK3vS1ClI8Nx9w=; b=eSgy1zBs1wvcbM3NdJI4wEarb6BLve6NDV
	Y3LDSogv64uCYxk7pRgHW2sFzevgSg9JKqNdbneri1iM7D/5g+MiBD5oleGvy7FZ
	3zYMcf8EryIjnwmyMByrYCJKvb0cZ1X36HeRZJM3uawVzJBn/9gM4u1LLod9Gjar
	Y/dnGUBjM8JDrm1JeB8AlfYc/3oX6IFNWRM3sElNDybE3Q8PkgAfBfgjjl62kdw7
	SU+CRkOa3+Wjvixks4wf+jmku2iJDxrxQoQIA2vEUz6jODMdJeFHL8HP95OoaRH0
	xxzE4DXb+UgTnDJ+yWFA6OwRS3ouzkcj+HllL+YWzFug+pppo+Hg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48056edw3n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:25:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56MGI7rs037682;
	Tue, 22 Jul 2025 17:25:33 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t9meyg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 17:25:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LinHDQlSNmsT+yFuKlvbRvzDK13JtJiTJummOqtg5STxZEzEk1PYTa5Niq6/WRrSTVArAKjTAxbg1qMEtm+63I0CHrKTeGudzRDoUKzMnWjNQJD/NkAgATifw03EB76WqBhVcKgFBbeD+/boa3dK5cFkLwqUAlKJwxkRyE4DH5EQU6yzJf91CdA0S+fCHEj72yuwXjFxz87611jxnVmqSK8CIGZMEP5H6BtKtKmkeMA1hk4wWMNkWOB/f8/MJZ9onFyOJ2Ow99ZB3PXS+FFh/w9YZPc0y1eh76QISe0KESuDG7hpc74o3oKKz+4Df8U+76HPVLTNoVizXDLqIkYNlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0Oe6AW5zaAE+JwKZ+KDBk/+GtF8AEK3vS1ClI8Nx9w=;
 b=R3DhnVdQlrhAEx3W92+Etx3QUJywkJ8cEzkcGAs7LAgTNnMwaqCVDF46ZfdDrivPvN1Ep0YAKLfST1s2PyVXjq2PbpEndCxIybpqWrfUSQJDIX4nsxPwgsf3gK/qZv049qQCJBKujcL6p8/I+OPx14AeaYGbote5jzub9v6lzJdO76vuSIc+sY0nzTkiMVBgQbjUZ9Nz9TsMlkTi13/YRTFoOkzmzrtDq4GDAsEN7H0fUUATBvxv6kxBRgt4J3xH/Lv9aIhqC4x54srplzXFrnrla90Td+n1duA11CUlaMEiDJZWPEgr4q57WrzNibGM0LKnTODV4op2hMIBvnSGNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0Oe6AW5zaAE+JwKZ+KDBk/+GtF8AEK3vS1ClI8Nx9w=;
 b=b/M5n4rOAas+dCGleM8i9JQBMwKxtI+oyu7SK356cCt5AZJLIxMh/VRtB4vRugURiH3O8r+vcL0vcmY2RDl2poUcFjcxKDGDDjLhsJOKsSGkck5SM6wOtReacGkfkGesyke6k7KAsG/b1HdCBSAnHQbRslv+2B4875HnglNlqpo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6345.namprd10.prod.outlook.com (2603:10b6:303:1ed::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.24; Tue, 22 Jul
 2025 17:25:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Tue, 22 Jul 2025
 17:25:30 +0000
Date: Tue, 22 Jul 2025 18:25:28 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>,
        Oscar Salvador <osalvador@suse.de>,
        Alistair Popple <apopple@nvidia.com>
Subject: Re: [PATCH] MAINTAINERS: move memremap.[ch] to hotplug section
Message-ID: <f1e8e236-1275-4a0a-83a2-29e37b997716@lucifer.local>
References: <20250722172258.143488-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722172258.143488-1-lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO2P265CA0321.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f7ba9c1-143c-4b62-0107-08ddc944c1cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yaomDpypdLV6Hzfyl9giBkdr1Z/RlsgmRuZYBXJSJPDTpL5OHLZ9WKi8Scnj?=
 =?us-ascii?Q?LEJaY1x7vpOJ/iKAb+QSBintpKZ271Ub69bRVmW6ydIUh9neWYao7tlzipXH?=
 =?us-ascii?Q?mQxVlgVVwXTdcFETtMlzF1akpd0DR7CUif2AEKq1Jc8+5SoZ7/J8NTm1ql0r?=
 =?us-ascii?Q?iEys7omFVpXnahDFWyZJ5GVLihUsf5szNi3j0/Uu9tJSief4yEcXfOvoRnBj?=
 =?us-ascii?Q?JBPPXyU0O53jbDkyF4Hnonc/Ti2V90+wkxCPFmF6Jbvh6J9L5ExEqqSLlWJL?=
 =?us-ascii?Q?bUg7QpgAZDTw7IppZiA4cup0Swqca/2jmhc84/bRhOfRqDDC6CATiySJUA1I?=
 =?us-ascii?Q?ASPoz/4VLZQAUJJWHa+irVl5GdWHEs9dawNQmJAxICPpORDPMrXvaV8pFAel?=
 =?us-ascii?Q?1StxCun3m0tBB8VrGx+UZqJ2yWVnetbiwoQlpqa65/7jo3G26QsIdGEQaSCq?=
 =?us-ascii?Q?PlSD8fjVPohD4J507gs2GI4O0dYpamTbsVd63rvTF46tamBm1tRHZW/7HtZt?=
 =?us-ascii?Q?GpU6bAmAyP4eAVS4ALV66Rrp0CNU0PHqRE5DsjncBwOIJ4fYnRmlpp3+kjdq?=
 =?us-ascii?Q?TnKEI4uPDiKnwr7uMShG7u+vqc97ZxDMML28OTtHzl8qpluXsTWiH0MtNHr9?=
 =?us-ascii?Q?b6HVUg14DofdEwMOVo6U9UcmaKC0cXJr6qnX63HQURrX+ol6p6+bmCJM+3BD?=
 =?us-ascii?Q?MrqlQqhmlgLH+q/YLUsjz18C0sHbzLV5lqzO7H0vGau8J8GWkk082qR/VY7T?=
 =?us-ascii?Q?z3CFUndmcgqiVRJPqAD6pVk+BAXckk4ZNVh5NGM1tJ2LzuSRW++7a5NDAZcj?=
 =?us-ascii?Q?2/u/5AD6wnN0lqLy3rSUlytD/Sd2LO6AuhYndD0qF1Y7rYVC9nYLApupDhf2?=
 =?us-ascii?Q?PqILeGb4PGglM0xP4uQI7ZZuLec2noBgr4HjuthDsCJgvh3343C9b6wxTa8T?=
 =?us-ascii?Q?ZgSGspKGtYPJC/ZuPuR0EyQSTc4PLJfAYRxcK1qPkn4yrnrAO7HpAPQKUY7w?=
 =?us-ascii?Q?aYu+oYVtVE+7VGkqQM737ZgeRMFhUOa80JQVKn9y3QnyzBaO9d2WDGcy1ntG?=
 =?us-ascii?Q?eDLdT//f+BQcmPl0D6vdD9xlfiT1gjGTRFlgqK6STAZWKgDjgjA4nqj1MlCK?=
 =?us-ascii?Q?3tNTFKSuWyUicDeIrJ32Z1GQzYlnGT56hRv6fVjQbix5a0O2MOrBIKZG+tdd?=
 =?us-ascii?Q?IejYWb1IK2TwmqaMDi4VcYEAzlI/pcxcZHHeEIciED8EfWx1upqPV8/BtUuM?=
 =?us-ascii?Q?n1i7EuPqwSoqZlxPH/de2qxUWVNjHI39UrsZpkPDF7Q5GiO6enX9SQ8Gsr9g?=
 =?us-ascii?Q?W4aOuslTYRXHOtLzQr5OTxIqkOV7gE/JeMxZtJWDJonvKV/sG5piBK44cvWP?=
 =?us-ascii?Q?yXqke6HC71dFLtZqpUIsAAdQaYyogRmZZkdlVhIZ454iVlH59Z0ayYWqhhqZ?=
 =?us-ascii?Q?2HiVRlL1wE8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m+5tqKQH/hwIInZqhnfykOcKeOSR5Unn6dacTvM8Vlx6kBACd/4mzpvbPyRx?=
 =?us-ascii?Q?RKO+OH6fbemeYUiAN1b7sh49xJr7z1nNtcVVj7u7ubiaU6aYDVFP0K/VKYzb?=
 =?us-ascii?Q?8tqw6So+WMTCq4WlS+pqwnUBO2yKeY17C1bepjlLK6wkmZ9gaGB2TmqGsheD?=
 =?us-ascii?Q?4folWP/iOW8x7lluKJDEiu4hwLEg4qDc917f50kHc1BBDLMA8lJbdYX0X058?=
 =?us-ascii?Q?fEhHg8u4cjwFUoYj5rjk7QLD1yc3Zf9EFZ+uUvVQbOkVuNzPeAdp3MqkFOrw?=
 =?us-ascii?Q?XspHUGO535BAkVGGFt8gi9HsFn6FMdJJ2h+3L6O+OXO0HhRj9rXOwDOKRfDA?=
 =?us-ascii?Q?XSjWj7slW3q98QyKbbZuaPP8nELP5+nB2Suv/0vlTPjco3DxSNKRNWupuTUV?=
 =?us-ascii?Q?vsH5MM4zM/gq8g6WVd5TDhFjl9LG++WKCuEt1nv7rU/aOxxf96vqAwrYCbMT?=
 =?us-ascii?Q?m8MVk1FxfqJAIYSYmlLzbKlnn3aVAQPVbKSCAPEIunZdFqqY3YPmb6VTbFsS?=
 =?us-ascii?Q?tpN/6HtCV3XJlNrBMefvr76FKuqb3L7l0aEfe+fjdAO8ZF9rdZXGxFHPsDJZ?=
 =?us-ascii?Q?wDYaquDtCqj6YjhS0isOhPDU8l1Vin8ipcveD7xspSuWJZzDJgVeL78hc00/?=
 =?us-ascii?Q?CZscTB7hGIKW/BeX+oUEh6GVaa19dhSSiUzF2/m6qxLx5L3HsU36MUikiKuA?=
 =?us-ascii?Q?KlOxKv05vZa5DJval6Wj4p5Cbdh575S5LWOfsAwy3MylQdwpQMWEYeS8Cdm6?=
 =?us-ascii?Q?dPZmOTTB6DiyI1S2uZ6bgFcJ4DWLAXiEkyRkLi+KyUXG6Ts9Gh4YHAXOtHFW?=
 =?us-ascii?Q?weBX1lzKA3bpbk2N3MOMi6n6WUR+tGsTfC+DTYG07yi/6V8FTpNZKGJ4Thv0?=
 =?us-ascii?Q?sFqRnlbngrfOrJHls1W06xaALuXLGuIzci5eihZKlUnp56PBErznL4u7S3Hq?=
 =?us-ascii?Q?l+eb1ODhqxOAUe5TuO/N7IaHw+LPrz/88H1mlXJ6OLFtFhyVjArW/myKIg91?=
 =?us-ascii?Q?st+Ou10TlDTzs7Nao8RSND7Oelba+9n+Q53Fcad+bK98f9zowYglwTsmDEAm?=
 =?us-ascii?Q?8a3j1t/ysn9IvmAZSzQ7ZzGc6gsmBDdPxAK58ncYsNw2fe1bhUw2f+reZc4W?=
 =?us-ascii?Q?VnFf5JeAVyMUHEJ7tOg0bGpk2z1hDXCH61laKLDpyZDrh5F/clqdi7hKE4KF?=
 =?us-ascii?Q?BFX3vCbqXltlNh5z61fEHN+lrQsIz8ILLvjE/4k+SDq6gkFSPg+boQh+xEYl?=
 =?us-ascii?Q?QDn/m1wPqUWScOuMgraxkS1GDuc8nlkznQntAQtygnIA8uTEqZbvZMZKTTqU?=
 =?us-ascii?Q?G0pEAG49pzgCb70DjcQo0108DUxqGr/Xgk7qheOr1LAHUcDH0+QtEPBx4kDZ?=
 =?us-ascii?Q?i+3iymn0Xcb4mn/HsRPxR/EyGr09UDdXecEKpVe8p08atarCKx7lHRnR545x?=
 =?us-ascii?Q?MPcXxckFRE+Zty0RtZ6Ho5/t0G+iKwGzOTdIbQ4cEGOCiTF1kYUB2+J0oQwq?=
 =?us-ascii?Q?WbzfEQdXBgK0kkvD3TaE+3u2G916Hgb8DpkhLUAoB2hkwfUaqmvYMp5VT8dR?=
 =?us-ascii?Q?pU6+ESe0Nu1SUP43/KQfWAotl3/nh81LrdB7OZOkPRSGhHs4spUpjm4++GTm?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	C3Zi9PIpG2jWp6SprwCx4oaeWBE+Dv6noXdGR1MjXvypN8jAs6G894kDsyZE3LumNCFsRlZ+2PIXJLbGQc33woQ62fAvSiymRyNJKb00DIQqyy20BwZoP5wr/Etq0trJJiW+fZOVpSE88Qcg0kyqw0KUmB0IGqqtW34MzS6LmNXIeJWiR2wv4xUWsxZUFaZOY88KNlB1+T8aH6dxrr4RrJY1RSLjkKsoo+brFVSL7dDATTKD+NfTCYcrbYTIqcNPEizTRb/mvsh3uT8eQe4EDLkB0h6h0ARi6mR4dxy2V+oyaFQn1N62plSo2tfyBv1KGNyPg0qx8EdN/G42wnO4lngfa68ow8YtjzQ3rS0MdnJRLfpvDAXZDCUxYtxd3K7cfj4qcrR63Pq8wWpGCGU77kIHkeXtj22V0Uk7bV9Gf53P86lhQO/C77dG0o0ddSIDttf1U/phOBifH8y+ZYRf1ErGqsxXnwX9wiUyWzL3N4aeuttk91GOZFpkprtHHrsdB9F9fsxlqj/lR7dQFzX9IgDLp32R+HnykvcWMnrm3XvhzOudjSigxo77jrOYXw8WtThG83ciL7OCo8ollkDJKh8ceAWUQVtQihBOygazgLc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f7ba9c1-143c-4b62-0107-08ddc944c1cc
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2025 17:25:30.3360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w8AI/rTLjymqQkGlWa28v5Y+nxiCBeZNDvAhfG/WKp5HGRJrCDNkxk8b9IAotg5sR3/txrE3/fuqnif0WY6w9Js0Z557eJqJnbk9RXRQdNg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6345
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-22_02,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220146
X-Proofpoint-ORIG-GUID: 6m3mdA8hj4zAtpqJTKnvB2_Ta0t90UZ0
X-Proofpoint-GUID: 6m3mdA8hj4zAtpqJTKnvB2_Ta0t90UZ0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDE0NyBTYWx0ZWRfX0huFHkShw3z0
 03VHDbPAp1D2yNOlNzq+vYuqWZrVIUOA2/1GmPMhMmjZ+bau+oYblXZQlxwaK71RNlmoiZg0bUD
 4Lz51MrsYwiCUgdMcpyUmGlxYhyuRoxuG/r3LRvKNWtlk3JP75r8CzciWM1JxovlVyNpep/03I5
 cEJYOEpDx9e4peApYlujYSQF2VQvOtQcRAuUv/VPFYE05Vs55J11kcBP9Cyb7IcMF2pMiWy7wor
 tsKDeHoNSBIzg9sh5jO8+uFIXu8CewncvDx8q9ywMJU0NC8dnJy6HqBypWgVYcb32WUHXMnwIj5
 1qa4rwGDwSJRUc7g/qvu4XCT5frMhFgx3WgpIQauuykXwhIG/jd7vQ0W5tP6b2fc6ngMPB24hCa
 ZFGGEoEc8qCHq54ElbVnPoPmvn+UOKxiQSjhQ9tnJMgHXBFT2ZxgjCEgXGKR5SJNFtdOoegk
X-Authority-Analysis: v=2.4 cv=Ef3IQOmC c=1 sm=1 tr=0 ts=687fc98e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=yPCof4ZbAAAA:8 a=n8uIMLZTT5jdB-RBLG4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12062
X-Rspamd-Queue-Id: 4CD564000A
X-Stat-Signature: hbw3wqd6htncndwf4t7gn98z13x4s5fi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753205136-997667
X-HE-Meta: U2FsdGVkX1/TrHpBHXvvKjliy3TmaNGehnHca7Ltg5e3d2drHl9av/UFf5dK7adKloDvCTvCs3jcO/kXYmx4i8KWCsxCalLNF837mZstPfwF/Xp+MxGKIVU5TyOPpYt35gDMy03rCov9Mkmo8oRjK97bZD+5CWIRJz71y2XO3w82xe/wmn2iq2kFTQwf6ZGkk9gmBI3Pcoq7vy8+qFih9JUZbyhOtUjm+q08xBrbTybsHAWyudqUXUYLDngTSvvFtxXfqJb1xPgLlSFEV25X1PmuD0/56f9/XzC7iM8OKtx21mTofvnYsY/BTc9kyU5G8rgGn7xc90bu+8EQwA5MWX8s8o0ARD/7vN+unh9449taZ1/sQHvVqtIwxSi9FRICeV4tVqzlrkvIjEcpQ6yORI3RCIYUuv/9aoAu+yi664u0cfnIJempkgQ80QI65hu4pxMJrl5aAVdGbxWNQ62UhCm1gcrPvYf0vDfasI09Ub5JALCwFh0FGGPUyCUUyWgyHIvvpfe6VqfZqrzGD0jSqbh1sT8HNhGawKtJ0m0A6jEUZZdpa79MkiD13ZFqir4M1p+WOhEVwWbEErap5EW+IkjlacNfxFGBjfHKeGLd2jY68qVD7Ap/4UuwAnjggak7hvc/Zr2z7TA90Na10oy6mvuEwXBZiil6K5GVv9cQr7Q1ya2x8KWWSUL7cohJTEnogptKLVbURy1aYNYLTLdwHahvz2nKsdXOgZS4JQTdrCmhtRGMiSF2aptv0hJ6leNabK/ucDMitymgYnhFZPoaHnU4HqQSFGlvAKR25Xx9Vrai/dNYmhzad7HfGlY9xp8r0gbDrknkIxoEUqL2rKlIE/KtYxRfy9V5JQeiHFAqEMxpoA1jL3GDNODtDRNcb5iCm5T2q2XugN4vIwHnzVGWJfEWyJRE8v4idg83QGVCJxL/1G+nUh4Q/kHH4dGzXZ34lFGCtwrwMgTwwSI1x5R
 SPyEAb4m
 t1GmqaQuhECZc8dkqz0ZWXT5End7UAN7hGfWzEX2CepRPtlU022ABovl0Rk/6/HDzCkGKRF3gdO5YAvBG8oXwJlvYg1uAoO8M/5YhK5UfgebPbB2ZvDFWiwznzk2sg6if0FMVoxFM1/z8baELYl5pKq1ZOBKgNWsbUixd9YD7uaUCCglaQ6Mwz2MO0h/GwojYYdQUFVQ74z5IIsKj04U5zGVEKrFuxDXIjPZ4GvcQR76pIOizrO3puriF4RiMOb+ycDBEL9p9csfst3KtlFf1S8XVV8X0mWp4ZXLQbhhfz9YmEFHp+dHtLbxjBK5d+BTe9Ea9+ybd3ot0bNsuqG/T9WRXSzsaq5xIIA18nq9sBKexjvGwJvd2imJ8Fc4gIuYmpiwS/xAPcMXWlvoDYT7wjgQg+8Ai9ZlzmuGAla/bcjFjIabm45ory+gsnAwA/pN9lQ1wNrBl/V+KSmOdsTZp6Jm5nfe4A/1nqljLAMWHlVeCYT9O6Uu3T5ithehMp/ZW+2kt5n3OXX0vfCNPHY8+AjvUqhqdgcYAJ6upHThcwA/z0UsdzuC7PXqDxyFPbGmCoIfMNuyv7HbX+qzE5QTlpgcv3+tR8QKpamjimMr2WpCAhLXiKDlNlfwOUszw9V67GNvs4t50vu7QJKSjwQEIArJttOYaDiqBurWTLap5agZcaO2Z3gt87YmUIOj7P88ddewCDbUoHeedlvhTKTyHL+wm2vtvO57A6RDB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Alistair

So sorry Alistair, I had noted you were interested in reviewing this, but
then like an idiot missed that note and sent with just the file changes :P

I'm sure people would be happy to ack this change if you send as a follow
up! Or could fix-patch? Let me know if you want this.

Cheers, Lorenzo

On Tue, Jul 22, 2025 at 06:22:58PM +0100, Lorenzo Stoakes wrote:
> This seems to be the most appropriate place for these files.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..68b8407926a6 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15729,6 +15729,8 @@ F:	Documentation/admin-guide/mm/memory-hotplug.rst
>  F:	Documentation/core-api/memory-hotplug.rst
>  F:	drivers/base/memory.c
>  F:	include/linux/memory_hotplug.h
> +F:	include/linux/memremap.h
> +F:	mm/memremap.c
>  F:	mm/memory_hotplug.c
>  F:	tools/testing/selftests/memory-hotplug/
>
> @@ -15747,7 +15749,6 @@ F:	include/linux/memory_hotplug.h
>  F:	include/linux/memory-tiers.h
>  F:	include/linux/mempolicy.h
>  F:	include/linux/mempool.h
> -F:	include/linux/memremap.h
>  F:	include/linux/mmzone.h
>  F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
> --
> 2.50.1
>
>

