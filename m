Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39B17CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 13:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715F68E0017; Wed, 12 Nov 2025 08:43:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED388E0003; Wed, 12 Nov 2025 08:43:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B53C8E0017; Wed, 12 Nov 2025 08:43:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 457A28E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 08:43:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE7DA13B223
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:43:30 +0000 (UTC)
X-FDA: 84102072180.15.D87638C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47290A000D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:43:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Tix4SF2V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UZmrqYAT;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762955007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/blHTn9XQl6oGdr8PVsXhS5Fi+3BpZKH+R9TNPjyLA=;
	b=GfBhZnug8vYfhubo0LmteufUz0LRmQdtnN53RUemPHkDg/ZNnYvOqzc8OAQenhI5IMazzg
	/21l96gT/3c5lZ37JAjNzn5WQjpet39ifijZ+tD+kRMRo/buFWHS/4TJlYeaZ30b1NPCEJ
	tHyxIat21wsDbzMHOTdwyD2EnhNSQq4=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Tix4SF2V;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UZmrqYAT;
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762955007; a=rsa-sha256;
	cv=pass;
	b=It6vpQMLir6tZV8B5h7dIh8Qf/uz5+QpzHgDpCyQJO8IWW5/Iwp3yn2U8c9NMksBeGjC4T
	GDphmojv4mi+aQjT7r9qfqxQL2pYKF0YfQASfMkZFH6xHBfjnHzMJEykknINogMpvJ/mlg
	Iil2+mS/U0yGkPOqozpm+j6RDCsLm18=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACDBKc5018763;
	Wed, 12 Nov 2025 13:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=t/blHTn9XQl6oGdr8P
	VsXhS5Fi+3BpZKH+R9TNPjyLA=; b=Tix4SF2V7dlTvWau3jMzKbU+DDQk0+1MPQ
	M9DaJzhA0hHn1CYjs1s5lTD5EbZIKqJqFK+ZEahDNRUEY1FEaxDB85E3hp7DLAiX
	1BZfy6SmcCuiZjiZJ4Zy/V6qAVKcoOndICx3GjllFGJNzLo+KYYvfjs2iomlYDpw
	rd9+7CUfjhTq/z47wjPi+mQmViK8dxZTcHAA1b1eSJCpgEAuUUJImlzi0buLg1FG
	oW4fT6R8k3ry81Ih30et/6QjXVff6AOgkQY/KTrlO5+RE0+HU3ST+yK3yN3hDuBR
	8sVYNTtkrtx0T7AXcQgHAIKVripDncWA1D3OdVvNpYXvZUQU+nxA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4act7p84r1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 13:43:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACDbm9B010108;
	Wed, 12 Nov 2025 13:43:19 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012034.outbound.protection.outlook.com [52.101.48.34])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vamfkrs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 13:43:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kc3l2uv3me1DL0bjDiW2ripkPQlSS82OLhETtXxrU3OSk7ZyTpSkvN3Zgz+KEW+UyLNBZnYn9qDZCxr1AAP+HFHS9pJOl/6BOXY2IuQC/9aY3MLeP+APaRxJ5t23wxucXJa7+ZE8p/rlMuk9Wmsld91HgiwDWkcgX+8lCoerLTOGX3/xdtu60kVURL5Da3oQ/DOQEQbr19ovWZXdFp2JsKXTTWpyNqek7QvNDRoJVm61iEIhPywxMG1SJXfzrkRazIR/nScaBHnQcH6/Fx34dIZLt2zpsFmNrVBZniUq1djQNUi/Iy3fP4KTMjQncK8edP613qMVp+8qQzLAmmldaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/blHTn9XQl6oGdr8PVsXhS5Fi+3BpZKH+R9TNPjyLA=;
 b=XZyN5lVCtY0Z9GpMpSdKkFcKA6524QwsH08nx47QOocly48SLIxi3TEk3oMG1P78H/hZcPSU60ERQvLyLjs+D/DqGH8E7gs//CX5O9b2ivEYK7xyGNZUPBjlFG/r2OMErnVLQ5s8UhUSef/XOVS6IJm0NqsCld7k5zZxXhAlPrbpniTnuuBQ+QBkhgsBpOY8NyH3jO6Z3S4i+fLnEsMlzrPUmerJnTTUwJVyRiG7IByL7f7lV16hxYtCPftdxCV1GtJKapAnWgt0od/MZJk3xRKQzun1VFQQVLSYUfiBvfovB+5EgvmOINdmI4poLcQXvj297aViU5S+VSqlKI786Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/blHTn9XQl6oGdr8PVsXhS5Fi+3BpZKH+R9TNPjyLA=;
 b=UZmrqYATpGVuBChUYs2fgXpqU1zIdP2DgG94/JeNXqv3NzHoxjmlwO3uAyig7aKaFNCLhAhKRid1lZmS7WzjeM7nLJGOJ5LyLQTMo62tw0EenQ6LMahyhud8M17EAtYoILmS3Ar7aSyqxASX9Q/xFUtwhISxq1uPX+jEteCtURI=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by LV0PR10MB997567.namprd10.prod.outlook.com (2603:10b6:408:33b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 13:43:15 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 13:43:15 +0000
Date: Wed, 12 Nov 2025 13:43:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, David Hildenbrand <david@kernel.org>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/huge_memory: softleaf device private fixes in
 remove_migration_pmd()
Message-ID: <c5ebefad-2b1c-45c1-9a82-17a024d52d1c@lucifer.local>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <20251112044634.963360-2-balbirs@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251112044634.963360-2-balbirs@nvidia.com>
X-ClientProxiedBy: LO4P123CA0614.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::15) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|LV0PR10MB997567:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d97129-0a6c-4684-f59d-08de21f16e10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LD+/CFQSWgSxPDAvdxL0LGKZlw9m3dUrjG4GbWu4+JrRynYVtjIbnTQhxF3A?=
 =?us-ascii?Q?UGNVAmWqxEq7Du9I8uDaOr1fUlubzxPzeVyfF6rvLKyoNqm0L9931+4qNd4c?=
 =?us-ascii?Q?8/OKDVeMDLEzpXPxdhm9EYGQD3rkxgdxDfcTgUpOddUsESMp/+NFhoBSFBZH?=
 =?us-ascii?Q?TBVo+M90+xpxgIWgTBi3gobxpJ8Xa4YxW0Vh+Cs/jrhdTXQH3yp4SkT1qBSr?=
 =?us-ascii?Q?+Vu1go818AuxhZmvDt3AlyeMcBTwDRo9hjmVZ93igRWlIbIq+p5rWdRICWwE?=
 =?us-ascii?Q?RbOqVHl3xk+KEOkQULwE+X9WEw8XTXWGWlPq6mTlEn3PTYUJuh6hmXsOwLff?=
 =?us-ascii?Q?Cji1eRcCQCutCfcHhFhJsTv4wzWumzfWCbSPauwcLgMmM5cjaHWOJwaheN8R?=
 =?us-ascii?Q?Vd6nSRLpiaIcf2H9RRlu1QEc7yRwnsle1M36s2/0gI5DrbPnwxqU9ZWX4ejo?=
 =?us-ascii?Q?C+kwWrlohxO5GxvGQ1peTdWd9KieRRmYj3iz6BxCQlrKP6FigPS6pLcQK8XL?=
 =?us-ascii?Q?YI4XP/oE3nubtxJCU5FsAFT25BKrsgpjjFidEbcIrOs02EnggLrFXahOqIf8?=
 =?us-ascii?Q?Qeyi/6EMoYSbD7k2CXBToPwD5/GoBpq96dYx9jeTF8PEz/3yosHp47MumrQp?=
 =?us-ascii?Q?VEcclZZEsfUsnmNLC1k/4AJ7Mryk8mxDxBkfzQDh2zKZgcS2oKEha9Bug3OQ?=
 =?us-ascii?Q?hlIGYX9p1gFWiwSxcMpSXBAUlIkkfdYEAFKfB2SHi6mV3bhtuL+C8bIOv1rS?=
 =?us-ascii?Q?LkGFjVMg5wSbdcKYuhwl0PrRWNoUBhRN6QtMancu28oW2Hlt6qgEGI0LSjY8?=
 =?us-ascii?Q?EsCQJ+q048wbPdcghTgafT5MhIuVrInjtb6xq+vXy81Q6DXkJNjB3V0MARwD?=
 =?us-ascii?Q?mgBxBA4HXOto9m57VkRZuZ+nh6aHOuGz0nTTVQpiAcQJAxWZTgvDDWeGhAYe?=
 =?us-ascii?Q?GnXY+kx1Dq0kP9UHEyfQ/nLyM+mbDMHvKPJzCPkJHNaQREmbv5SJEd9NY3uk?=
 =?us-ascii?Q?kEHT44R+ZVvjHah6jlPklWFHwUxU0+mQ8RDQrQ5gG8J2L3jQXWn4szIs/kDg?=
 =?us-ascii?Q?ZQ6MLwhSRH8JWjzhpihvLAFjY9LVHZNoUVzqUGUMEMxAlL89MZk9R47s2BxR?=
 =?us-ascii?Q?i40j4jEhMOYkSwAYbx2OAYmjIoBUcVzFs0zku6EfTN5uc8s5B7FU1pBjIogO?=
 =?us-ascii?Q?EBgzxyYlbsohXEsL52Oz+lvQ7ie1FuBZAR2dTHtAkK0Bx9oQH1h3wvrzkCwA?=
 =?us-ascii?Q?A9Hjd4uGbqs+q76Ez5bBhAqZeGwqRxDma0/CGmbYdIMTkQK2BTyTAFEhyDhr?=
 =?us-ascii?Q?y8OkR+sytT/CEA9ZooM2J8nWjCmiItHojO8iaMoIa/gjeNlG1+hmjzOLfscF?=
 =?us-ascii?Q?HDToqaa8PYdQGyet7dZ9/Hz89QzE+ZvulCHdeVZdiOsV9bIRQpLbeXTr2/6f?=
 =?us-ascii?Q?C5F4Mv+mn2GTcGHCE90mTFg6TWoaHaRj?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i8pg803WFlJtF0qx125qkg2xofcVOr9CfPEzGOs+Xqc7hJgMkXEUU2cpIkbV?=
 =?us-ascii?Q?cLupAQ+kvnaJSucPg1teLCRLfzGCsDuPU1bb+WMRYBK01cqAasU4GS6hhi47?=
 =?us-ascii?Q?x/lP5wDmAyeM9LULimIscYBFqAJ5M5B0KUJulDPH1zvlbomJKE8DZx+GAU5r?=
 =?us-ascii?Q?VXJbkt+mPCBahKul4Ky4PtJ5ooKvoRd8ueX1+9Mntgy70yDi09kL6CLYPkwu?=
 =?us-ascii?Q?75Q+bjmXKTXeF+cfadl+akHC2eXP7bH5dV3RFitGtH2SHZx6siXYz+ap69ke?=
 =?us-ascii?Q?wGTVrMG8WZyH/XBAR8etdDUMHMQazJzQto87w/QU6BkUQFA5pihdAz8LbKBt?=
 =?us-ascii?Q?r6ZJIeYEopCktTS3KzOv1Uld3fcwhUMft2Uuo+0yDGKkwvEiErmYgsbel0+G?=
 =?us-ascii?Q?eAwyaogxaq3mDUoh7RHtgPAuOwqTVXUZmWuVD8WgzrLWm8YZ5N3NWRdIHJ2i?=
 =?us-ascii?Q?uYICdwG7eImMDbDdl05hkX4fho9Yb07RSsm+BM1wb/e3jmSZ/q7mOuRwcuwE?=
 =?us-ascii?Q?e25AZmWHG0NXbTnQSJxCAOrq6UVNv4gBv2uYv/mBPXTExlQLsz0B7pbCfB29?=
 =?us-ascii?Q?9DJ2bSKqDF8UUAM1ioVkikVA/qui0Ijt+l5Wl4XRH0Hm7oKCKfviOObns/pq?=
 =?us-ascii?Q?0tS1XsZzD3juh7R7IUXoZzj5ApDsW1+pE3dwrP90Q4NXHZUk1HJBVapeg7e/?=
 =?us-ascii?Q?kCj8nnT3Bbd7VhEsSLuOcRqiO5inINbW1Y6CN06z1ieTtUUEEhZ90s9oI8rg?=
 =?us-ascii?Q?0+3QtDB6x67Bs1TLQFnNmiBZGyWWcuFdzmk8x158TzdomZmIwoTvWutrKBSC?=
 =?us-ascii?Q?LLiZroGuyY+lAmBX18vzms+72EzmSlh3egTMxIlEjpqPbTAjw51nVx2mZTWx?=
 =?us-ascii?Q?/cj0cE0JsZVno0ZTjaqayNtx/aUbqIjX65hfP7yyrBM+iNiIRQli5uGX5f9f?=
 =?us-ascii?Q?TpHrUFz9uYa4qoL9aPk5LnGv217F60CmfAeCDvszY4rR0RwR0/GtucAm1NMn?=
 =?us-ascii?Q?LuXKvIFVmHZpKK0SO+yaD+Ghnx/W5/nPIBDRjMKYTz0Ik0j81Nodq12wLtDw?=
 =?us-ascii?Q?ZyNGe3CRNfOHZhu3ixNLZ9B8yBYaoHFscxcTjCiY/FNZErGsIDyZLtq5/PBb?=
 =?us-ascii?Q?tXi5F/npDoDGrhmCkaQ/ne0DFNax70x+ltP83ib40WkS45suRLYYFkCXCJmi?=
 =?us-ascii?Q?N1nLfbgcDK8x9/oP6HUPxzA5+rpFTs+mdpqtW3HcMks+WKEBv+xLSBOA+RBP?=
 =?us-ascii?Q?EJ7EjvaK7h9jzZ/FJVIJLX/Q9E7A96XO01qg3Ci53Hs47tjvLbEldB8GZAIG?=
 =?us-ascii?Q?he2TqxSfXhLIwq/naP8wN8VpB313kKY8LjYD1tYVFvJUIhh1ckLgmzCirxm3?=
 =?us-ascii?Q?7SSmcTu0VTa1cYaBme84AfToR3n/1t0VKrQiAji7J7Fz0LBCve5H/AB4ZmFH?=
 =?us-ascii?Q?CI0ilYulFF/AiDgTAvXpdgYQ1P0GwpORaGR7HLJ/ACA/czSHql3gPAa/SGdz?=
 =?us-ascii?Q?KJ8PbUoPHevAKVGqxwy22JPWPlgk3SwydadehBbewFOlTe0ANbV1ISCD9+W9?=
 =?us-ascii?Q?iMRa76MbGbQftilOWAx8m2jq7C/at5iXpV8yvXxLdJSHJ5fBDZ/1/f0CsR70?=
 =?us-ascii?Q?fA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Byl5NJ2xFQ5GZeyyqsIljCisR55uSb+3bpMTX+cRng4hOqF1/vUFXo+gyT6s2CWJojzlRey/7K4yciSqgGIgW5Jp0dU/93tuKlf9xO9XFXYtzQIkvYjeglROpd/OpUTj/D+XvhU0k7ezOwx+n8mVEWnSAv4JCDB18ah5EXADOWnqbiYrqEe00P6H77v6hPvKfW9eXJerTmlb+ttiQJ/r0TQbluAjfppfynxNFtSUIT1Lb0GS2sTM2+CRdnAAzNogrj0kQmV8EZueZTMVLIZ1vw2MyxtKzUdQfOF3GdTVcGP/gbSYH+vUOvMHffkxLcxOoEJ2zRK237bU9T0n2Px7I+KOpEPdkbhHgrPx79ISB1wGny/6J8/KEnZoOAUX4vycW2FinvSkzf1V+fCL2BiNxDuEUaIdTIC5rLA6sCHC2RCVebLvjD8uRFqSbvKmaAmrUHDhC/h9vTz+9svZ+XX7xlkkiEYjqqVYaM3hyAYy2oFbqCueqlM5hUNul0m/bbqCIP/xTqSUswwUCrB3huUYcJ7Ub3kizjp+LxDshspN++1usfXkjFLG0y692TEgspyyWqk1YvirJaUzpT+pTLO09zX9vMCEl4i+sZBviWbSwuU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d97129-0a6c-4684-f59d-08de21f16e10
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 13:43:15.1433
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MeLuMS+OUK70ZPwntOaOpZzJpBMIAvR3MobuzSiCf7NkZl3+07Vkv9n/sMJFT1PA/+OGZ48WfHIpCJowma4kH0zttmh01BLxberXZzPJtjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR10MB997567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_03,2025-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511120111
X-Authority-Analysis: v=2.4 cv=OPEqHCaB c=1 sm=1 tr=0 ts=69148ef8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Ikd4Dj_1AAAA:8
 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=PRfKf8xcJO_4-veeR3AA:9
 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf
 awl=host:12100
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEwMCBTYWx0ZWRfX+6WStE4J6BSN
 IG/usKQp+Q0CkHV45FX01l8oiF9zEOmICXMdXr3QIse+SclnorSSS2QfrQWGbikU2CnEVCHveQ+
 miT3zKFLyJB5oosNaHfLk3HHYux0aK6q3DXIhW+yezXbr9n4o/cCnmS4Ldtmk3W7XpkOVBMYNjI
 Vk27uGRYcsvpV8WXqKB6Ok3wC+aWvBk1JaFlfLAKXOFQwu4/FnGNXt+GDnG2j4HmQjxC0Y8E4WF
 v0Demz6WamsEq1m66IS/M76OBWCo8mpIT7Z8f+j+ndUHyBKNyjWZiqXQFPJnFETfPTjPZFSgSgV
 Ql7fyEK7GlwcuybQsNhxtDzhuNh3hGw88FXLhRvgAJjpJevnNi626dktR13XkU89lNYWVYqQ0XF
 /+T5EJw1hiTk6im+NGovg2PXWOQwHaRw0rh9dmJo6m/FQzKXA9k=
X-Proofpoint-ORIG-GUID: 6dIIz3QTso_K3wwsoR_PkTy_dXLP2lLb
X-Proofpoint-GUID: 6dIIz3QTso_K3wwsoR_PkTy_dXLP2lLb
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 47290A000D
X-Stat-Signature: uoafbigxocrfducschjfqfgtt54z6zj3
X-Rspam-User: 
X-HE-Tag: 1762955007-749642
X-HE-Meta: U2FsdGVkX1/9Zzg2v+r3bmRpzcGGC0xEYDhL04VRTqGgWxAOwrrrwhdWq4L0T2UMJZvK7jR8AHmr8XGjxtGl7E9IZDakL0VhfQJkRblKjCCZqQN5A7YFSNm1X/cW5x6AGwUmrJBkecvCyd+o0SCU7eTTDm0qDNMvT/ketWzgdP0Czv+dIfbAbzboDlEzpDL8FExAH7cZglfqUSG2+Z77bpb/HXJ9CXkHnBCEYnxZ5bKFncgdEb8yoTRqNKbL2w7c7q9arfy/O2KmiQrkfjULv+B6XTSEa7YiuogQWhLHVZUyaoxKg0VS3YKDwONc4OwOYngAB/ZU+WnlyNnoX/8mCmQsqY4SxZkFoZiLEqZJ3mWBZhILjyiXPmNo7vGVGrqHWbqBDyQVyXD6ngkIKJBQfdA4TFCIT7Bj8HJVBW4TqTSaz2VpVpBhSDyY9dFQJ2iHmDG5Op4ouVQ8yfGAz/krdCwg3ot2T80pMm8SWNB28wkCc2o/zDFHA7E5FqOYqCtJvoTDZJyGMAirTzYUPQ0xeQy71tbEk8vYawOsi5G+yd213mmW8UJKVYsF+aWPmQ5s81nEl/nDeIGuz4xGdP1vT1NTrYBb3e17CKnB7TH8Ig5Ql794nSdXu41qDLIAdqIxzn0DGlXO7zWkkXTxXZk7bNzU2GFZ+0kSbioHXGHbatjA4fnR7y+QI8CO3CirebXACMrHpkeYmZ03Giz2Tq8n/VimHGCBo3n9vEZHE4X7xX2iBVC1zPKiiIWFapwDtOy8xiClGt+u37egeJ9AXXWeTKwt9gFYxUauIM3bQ7Yu3uUD+GsA26b91NG502Vn3K2Mf3j1M93gVJxuDyKh6IIDTIjVsRzsLUnx5kCfdCimUn7z1i44qnqqjj55MEiyTQnQOmv0r+YMFugEOmx+fTRyOp9xaO/Z1Tqmb3dzI/35WAfhm2l1dSqq3fyHw6/SoaGFilhvuUwmoy04+kK1VaP
 37YmlnAV
 kVH5MFYuUgB/WenZbaKE3WGR66FWQxbIqWsY4bPN872O3GPIHRPJIOK3Hwo9aGmboXMnEHrRFeP7hZ0sZrl506lPBks2AjWe4/s9mlwiwTswHfdn55ejiDYi5umlEFNh7eqvAhjbnrj4D3RftZ5N0auPPso0sqDAcz62wmjHblYzussVATew39R5+OIqfqe5HYo8v+oEXpj2Y5comAtZgPclJai0mKcH5KlWkRHx0/Ue0lHioKFq60Dg8jjtCGIDg56iapRZIQc5TgljAtsS/m24A+bl7APFGe0FeJQSaa5sPQFKwoE0SVjpr5ieuUxJb9OtDg/2IcCLplJzDwcq/cdTHqSq+VQasTBWJgTz1+M6ZJYuTWfHu23EU2cLLE5+hsZ7ciMJCBKUnGg5wde080dG4MzPfMR3SGmj8qgBWQDl+T5kEViRcsD6Kh3kM6GxyPwO2xVoiWV8KKDKt/9+KvVAXPvAlhjA9uFb1ZIYf/fYgwbiUeu1F0P1eo9KsKblw3jncTVX87Q2yvlZzy1x/nbraOvGK3B7/ioK69DShGNxG+lYw75tVxncOM0ECkAjd7mwd3Y4Y57Q+VhTmysU98QB7dYZtLUBywUzjAScSHzUpyk9s47AApfYQktL8M1Lefh8hjTlQEy+QClh2iH7pscuvSA8HQQau2QgInQBFg22Pfpr84ud8p31LFIzRLbtaDd+arexUTUZBN7iZ6suBF7HTIE/wJJIp+622ZPcqFxN+O1YhQdP4Gw+QOvRihbE3dyo4q1kISkXvsbggrrvMIvLDfmJaJpeC308usRTP7AgrfodIXTtC8uGagV33S74Rg0lTJUAHDlHpXUfzILR/eivBluTiKdmMo5heDacVZiZReLUbrYIIHxvxTVRDImrlRCeObZgzZ6XV0QMEX15acnTnRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 12, 2025 at 03:46:34PM +1100, Balbir Singh wrote:
> commit a6ca2ba46390 ("mm: replace pmd_to_swp_entry() with softleaf_from_pmd()")
> does not work with device private THP entries. softleaf_is_migration_young()
> asserts that the entry be a migration entry, but in the current code, the
> entry might already be replaced by a device private entry by the time the
> check is made. The issue exists with commit
> 7385dbdbf841 ("mm/rmap: extend rmap and migration support device-private entries")

OK this is _hugely_ confusing.

Is the bug in my patch or in yours?

Why are you replying to your own series with this patch?

You shouldn't reference non-upstream commit messages in general.

If the bug is in 7385dbdbf841, fix it in your series, then perhaps send a
suggested fix-patch to the appropriate patch in my series to make life easier
for Andrew.

As mine I think in this case was purely a mechanical replacement of function
calls I'm guessing it's a bug in yours? So I think this is probably the best
way.

>
> Fix this by processing the migration entries prior to conversion to
> device private if the folio is device private.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
>
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> ---
>  mm/huge_memory.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 942bd8410c54..82b019205216 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4939,6 +4939,7 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>  	unsigned long haddr = address & HPAGE_PMD_MASK;
>  	pmd_t pmde;
>  	softleaf_t entry;
> +	bool old = false, dirty = false, migration_read_entry = false;
>
>  	if (!(pvmw->pmd && !pvmw->pte))
>  		return;
> @@ -4947,6 +4948,19 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>  	folio_get(folio);
>  	pmde = folio_mk_pmd(folio, READ_ONCE(vma->vm_page_prot));
>
> +	if (!softleaf_is_migration_young(entry))
> +		old = true;
> +
> +	/* NOTE: this may contain setting soft-dirty on some archs */

'This may contain setting soft-dirty' is confusing. 'This may set soft-dirty on some arches' perhaps?

> +	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
> +		dirty = true;
> +
> +	if (softleaf_is_migration_write(entry))
> +		pmde = pmd_mkwrite(pmde, vma);
> +
> +	if (!softleaf_is_migration_read(entry))
> +		migration_read_entry = true;
> +
>  	if (folio_is_device_private(folio)) {
>  		if (pmd_write(pmde))
>  			entry = make_writable_device_private_entry(
> @@ -4959,20 +4973,17 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
>
>  	if (pmd_swp_soft_dirty(*pvmw->pmd))
>  		pmde = pmd_mksoft_dirty(pmde);
> -	if (softleaf_is_migration_write(entry))
> -		pmde = pmd_mkwrite(pmde, vma);
> +	if (old)
> +		pmde = pmd_mkold(pmde);
>  	if (pmd_swp_uffd_wp(*pvmw->pmd))
>  		pmde = pmd_mkuffd_wp(pmde);
> -	if (!softleaf_is_migration_young(entry))
> -		pmde = pmd_mkold(pmde);
> -	/* NOTE: this may contain setting soft-dirty on some archs */
> -	if (folio_test_dirty(folio) && softleaf_is_migration_dirty(entry))
> +	if (dirty)
>  		pmde = pmd_mkdirty(pmde);
>
>  	if (folio_test_anon(folio)) {
>  		rmap_t rmap_flags = RMAP_NONE;
>
> -		if (!softleaf_is_migration_read(entry))
> +		if (migration_read_entry)
>  			rmap_flags |= RMAP_EXCLUSIVE;
>
>  		folio_add_anon_rmap_pmd(folio, new, vma, haddr, rmap_flags);
> --
> 2.51.1
>

Thanks, Lorenzo

