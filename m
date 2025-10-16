Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 344B1CCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 08:25:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFDE8E0012; Thu, 16 Oct 2025 04:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 877F68E0002; Thu, 16 Oct 2025 04:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719248E0012; Thu, 16 Oct 2025 04:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5558B8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:25:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 01DC085E06
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:25:42 +0000 (UTC)
X-FDA: 84003293766.14.35674A0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 74B2914000E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:25:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BF4vYLj3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iXRgoi+D;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760603139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUpLv6ncdA3R6EjsHayUfHhoVP1FiXoN0ND6TQ5nrRM=;
	b=AQvfYfAflwIlLHruxKiJlo/up6TSPy56kP+GZvUYjwvI2cX8/KmSw35Jrq39GUVoJ1GSGf
	77qiPm6SvVO9weXXdZGJ8iDs7BySDySD7IlDdsJHNfF6qrw2DhI3eDKoZsRfcp38uL+l6S
	mvKr8iRZrdjggx0M4zfd6uJxURoERqw=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=BF4vYLj3;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iXRgoi+D;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760603139; a=rsa-sha256;
	cv=pass;
	b=pdNMJ4VMNOVojtk925Oeiggejo6oKluspqGXLB8fm1hBaZH7S8Pb0WkxgDRrqVj3NM5pl3
	ictLD6iui/Ap8UYhm30+23I5kIBC7wJ33vLtWEZLqqi/RFr8ZtE/SRwisMLhLK+RiKQ4XS
	yqOvG6U+KypgSCNUPe0+KbgAlSHQgBU=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59G6ga96014761;
	Thu, 16 Oct 2025 08:25:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=tUpLv6ncdA3R6EjsHa
	yUfHhoVP1FiXoN0ND6TQ5nrRM=; b=BF4vYLj36Eph/3p9v4d8rQ8YagUHfy1UKz
	5DuOLK6syri6PSSSfwOqDE2l58GGPKZeubii4vE0oqdZxEX6z50g9kkN3Za6Gtq8
	kD1P+CtrpOid36QZwnUTaebMwyJRejIs8fEe2xEZak/USzLJW9acnQQiJmTGndpg
	4zdSFSMCTcgtPn3B9hvNL/4evSU8DfUhEn15Tv//bgRtjd1ZnS3MnroZBYiYlabR
	rf1PloAKO1AV+p8UFfAw/umN8NgGlGBwjdwvZ144upAS/MY61YyVq5PZ17QuXkwq
	g/1aF/x74t3MKexgzlZ9w6YVyVjPjc5Nk+id1iapdNg0sW8qAY9Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59gd09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 08:25:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59G6F4Uf010020;
	Thu, 16 Oct 2025 08:25:22 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012046.outbound.protection.outlook.com [52.101.48.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdphcsga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Oct 2025 08:25:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=boVHtLi5In9o8Hx9J7oKfuZwP8D2Ry1T7HKCRs/Ml8gnqBFiEM+aEa4c103DYcOa8FUGjsLviBCzQ+FPvUTTHG5aI4C8S3mN2L+3DQCX9zUq+JP/hNyi8TpZEHHLMG2xF3BwMgVGJB5vSfTl1UhzOmRJgqlWbNNJc5D1mokLeumstfxRzARoj7o7n6H7MPBqDO6hPRhN03cAmSONRrQ2GfkMu6anYc3fc11oDf1UppMU+q8fbXXYXD2Gbz7iCExeUuyANpR0ukaKv/w1MEIMbpw4dzlEi1v/9ZYD+U428f2J6id7UKUKiQYrBcY/MlMviBNCqxbE/axXYkwHjFrPww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tUpLv6ncdA3R6EjsHayUfHhoVP1FiXoN0ND6TQ5nrRM=;
 b=WlzxZjWOY/NGNqHWkJiQqgNUSh//Is8liwK/jy9v7S+Fujy6+xZAGAHzvBpM/ESyhyke77o/t6l5PI6FrEZ1PoK7LSYiWrYmhud0zJJRJWppbzyP82NSH5/xzy0LdurDQaCuoxxFJk2l7eJUW1Zq/TpyycnWBAR/RwPDQ0tZBLNk7H2y3OT9Tac3/hXxzZDmsemvlt5q3Csqelt1qfcRBKupP5GEtY1mHhnL/VJwGBjk4/il+ebC6YS1wIl3GyYeDeex+e0k3r/ijFunvFQEXuVR745mvlX44VXwqNLlGHgI7mplOhGcgulsR3PnSsQAUxtyQWZrMuPPk1LkCNTRAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tUpLv6ncdA3R6EjsHayUfHhoVP1FiXoN0ND6TQ5nrRM=;
 b=iXRgoi+DpcrH+xIRkjLFhNy8RixHHaU6oVmurjhfx4mtBfZN1OGN250jl1rQAeQd7hBa++Trw0MvYKwLlskvgRTrCc8MQEWt9sQJdB/k7cNmF7j0MY9swnP2pNa6ZBQhDAriH1WxF/jjIOwCZFtX73gue5B8G72dNAUh8G/0g6M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7227.namprd10.prod.outlook.com (2603:10b6:8:db::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 08:25:18 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 08:25:16 +0000
Date: Thu, 16 Oct 2025 09:25:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: David Hildenbrand <david@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Yicong Yang <yangyicong@hisilicon.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Yin Fengwei <fengwei_yin@linux.alibaba.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge
 pmd
Message-ID: <3fc642be-b8f3-4fcb-b13c-3359cd52e921@lucifer.local>
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-2-ying.huang@linux.alibaba.com>
 <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
 <87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
 <d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local>
 <87bjm7lh4u.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bjm7lh4u.fsf@DESKTOP-5N7EMDA>
X-ClientProxiedBy: LO4P265CA0265.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::17) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7227:EE_
X-MS-Office365-Filtering-Correlation-Id: b8d21c35-8ac1-4ea6-21d3-08de0c8d88f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/s11VM1ThaKRu8/PmI7xov2/y3ep/9RyMkw8XCVTfY6UfHyOpm1GsmVdSppl?=
 =?us-ascii?Q?neeUv/Bq/vO4KFovt7KWXcQ64Fc6Pd/9moM/rquZiD8rXCwM40F2lIytFkMq?=
 =?us-ascii?Q?o2Hr/gUzzwPSpBN2JSTH0o1541e1F+TtXhv5mqWe30BiNVeyLAKQxcMo+/gF?=
 =?us-ascii?Q?FigSKmXYT+piPnA8af6kUBN+XKFOnQL12e0ws0Izr2t+rN+I02MsipWJrnbs?=
 =?us-ascii?Q?21DUC9z5gBYTFH57HsoPHPCuLojb5xHbBn9OjDbUl+/tOawO4wgVYxKYXam3?=
 =?us-ascii?Q?Tjn/0Wb9F9K3lNRQgHvNOs81d+WUCJHthKX/pHkDCCu6Mx7rFx/nRBppR8Db?=
 =?us-ascii?Q?tWrvGjQvMAR2GCUNaf3XbRqtYiIqrOSXVb+ikdwowcPAK/Iz/G0gwyZsCFOm?=
 =?us-ascii?Q?cG0RQfwKWf1ueb82HaMYJANzZHP/yaaFVKUcAoYJkvAqwuJkWGk+VSR0XsrW?=
 =?us-ascii?Q?c2+nxZGz5LzN4M2QctZzvK5T7txY1/uwlfDAtmzB9HRAdZn5LDTbtF011gUj?=
 =?us-ascii?Q?JvaKeAmBXsUmcW3CYO83Xh7Y5NIRI4qMDOuvCpeIirxqrpfQLzvQh7p55696?=
 =?us-ascii?Q?LfEGIEle7c+eS3eU6fFY/vonrex9vxzu/abWq3dmRu1jqiV5ihLX8d60w5P/?=
 =?us-ascii?Q?lcOkto7PuiF6r97mYXiKSyQeXCAf1n08fgFXqWgwMI7N/HOO13COdAG9R0TJ?=
 =?us-ascii?Q?SK05+TUJsIthrM8I8aZ6SMcid3GKaf2HJvB1PHvSobwQjG1EbQVy2sCuRppu?=
 =?us-ascii?Q?pxGmUVcxCzBnPuv5wmPKwOERyw1J6BylSC3DjEuEQ1ZJ+NUDRDD9id13erIb?=
 =?us-ascii?Q?q8z2Xv1mjx5+MZ6Z4vPhD20WcXC2oQ5JDkGq4LzV4oOmopkcroJy5/JgbxbX?=
 =?us-ascii?Q?MBX3j8rlMzYT7RmRhAAw3BX5RS2VFc3Io8U+Fsh/ALFfjt2sDSVx2AomB9Yq?=
 =?us-ascii?Q?pYyXnm+oiJTi/sf/LoPbJU0ytf5Xwxyr49VpaqFUh5+zFcbaNFR3d0/ty2CG?=
 =?us-ascii?Q?RIPvIEZSB5PDYW9POau3hhoVuVOkig48XzqJGmV3CtgI+O7498xU4FzI/OMy?=
 =?us-ascii?Q?HIPCEpYeX5rMqGAYpkIWTJHkNOTkmv/hcPeMLbpUIpYuFFxZKiLiCk3C2Sh3?=
 =?us-ascii?Q?0UjHuZqNEb52xkA2wP0q3n4qU5pTqokZuyKwhQ6HcqtIcRbayC2EWVp2zheH?=
 =?us-ascii?Q?tggIDTbO/eyWh6uPVz4wEYU/Q/T1FEDu/RAI7gEYh26kc9uXbwAi/aNavlxA?=
 =?us-ascii?Q?gdp0DWYYuxhZWEgegNNCaraiB8Zz4JzReoKjiqYeKoJ7L6+mLZxtXNmRYOwW?=
 =?us-ascii?Q?idfklFcuMfgiaTk9FyFjkmJCfRDn/3JIvy8YxoQkwI0h7iSW7gO3qNh0eo11?=
 =?us-ascii?Q?M+U8i/vyDeJkWd5ibFWeSw8s1eE7fLLqN0DYMH1nLDky5NGD23D7yX3HDHFR?=
 =?us-ascii?Q?uEXaX32rDDarQ/uAZ/hatjrxv1fv4gAB?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RaWNd83dfJobwXqOCKhjtr8jQUZgw8H7GEU6L3aPEsyjXPe9MzaPe7uoNiEd?=
 =?us-ascii?Q?c6Pdzyq0oV+sMIQId79eGdFMBpbOSHuaF6UjtGs3tTl2A6Os+qJVLo0GkC+L?=
 =?us-ascii?Q?y2rKeRWkxrv4u+WJW39odCkIACsnSauxOYNMha21aX6clwHPESbLZdwRJJky?=
 =?us-ascii?Q?buLvwAIOx5KSmcu3LwIWPdDBcspS7EB4eR7JvbY4Oe3OeQUmRjuCi1Y7Lyob?=
 =?us-ascii?Q?7cmqnAOH8omx++rkXeQbwALhogkU4Pm4GC+IVS18YlwyU0UnNLvgO3EvPsFC?=
 =?us-ascii?Q?hhpGk6Q5nHBdTkb9QVUaiD0iFugESsn2mWvuiQfZBqfqQDRy93uBXDP/jDNg?=
 =?us-ascii?Q?A+YNzEGTRsvnJBcHQtWeoa/vW3pzQN8u3QKppdSjnOPArjU22Ud/4b1//0HB?=
 =?us-ascii?Q?O5qfZQZ+SuoxNoN9glqiTJ6dAtsXvhr2h+S6xpDnd1bbaMi/jZmv5S9V2P2g?=
 =?us-ascii?Q?Hey7exRB6Le3wGQsWsaBWgz5AW3YHclyCgCPqXFbuTZjCUzqzsYeaQh3U/lH?=
 =?us-ascii?Q?SnA5QUkBt9l8QlItZXEoPPD0PxqFa2SXwJk1DEy8ZXM+UqiInVwwyly4/Z4A?=
 =?us-ascii?Q?GMalzrW0FjIlZuWi8y83ggsdhDdGlpnSZT0XLApb5p4I/EPvBqjRYJhxjrfM?=
 =?us-ascii?Q?GkWvvTSkc7JrSgcdhk+r/e6Ny4QkVjEze9BXzA4WuhxJHc1tzpIH+7YTTC/n?=
 =?us-ascii?Q?tzeE1/IRkTxwlEX+jQt0rAXjEYr19pOR3sax1GxZjanx2FIhPaBp0uwfHP0F?=
 =?us-ascii?Q?58c4hHMpiFO4j8322FOoABr65y9jR3zXMclLxjQwZoI5GMH/P+/95FGLUb9y?=
 =?us-ascii?Q?gLu1L4DcQpCCdP7Bkk+RHTc51Dyv9P9YOPliLt8FHGw/EDJrk5JPzReoe1N4?=
 =?us-ascii?Q?b+R3OQFB+pup02xSRS3V7HRNZSGqLZXdH41l7ODUJz0+LmIvTBbUbHbxVFVv?=
 =?us-ascii?Q?MpXpik2l6K0fTl/pSc8mRPcI5OtcUkuOAt4AoElTRyq0DojxeAX72w/AvBru?=
 =?us-ascii?Q?fdaJrRbfCioZbX7Galcu6ob7gbs5jvsy+opN3kmYkqO0+uxISkgXKGlO91RM?=
 =?us-ascii?Q?p/Zt7PMrwJP2x+D9VXGexqy7ECVBnkdRL+n4O0W2eLGuhQHlSM0TZ/onJBEp?=
 =?us-ascii?Q?3uQFzy3u9wlaSOz6z0XiZPw/Jf2fZotDRFlyXE4I3PHB8RYEYpMJrtmZk54x?=
 =?us-ascii?Q?k9JALHD0FFjRtrz/1VMMZtMZuAi37O+i+G98X7VxG+0v8LeCbbexW9P49NDp?=
 =?us-ascii?Q?ivwS7J9uindi1Nc9aCDk7yDsFfHl7kTgspST5zyJnrTl2cGuWlh0LIlEsdFN?=
 =?us-ascii?Q?FBBF+/UHKboUm7e9PwhTS+vWbSQm2W7tZMB1OHjCo+B8JBH01J1N2h9rT0qq?=
 =?us-ascii?Q?8bpAV27VKhhMUteMw45yj3CMvlKfRxcHjkN0ArXp9WyyXDo/O2m3FIliQR04?=
 =?us-ascii?Q?lskuM2L1VA5MHdMX7jVQYmhNQSQo3G7UrtDQsHzfCptLZ3SP5oolt9IfW3nQ?=
 =?us-ascii?Q?updl7azcYB9bb/AmXHUhNAttPSYDYIrPX+3YwqaSMN8ndZnvRWgH1AH+Hbnx?=
 =?us-ascii?Q?lyfu0d9SjnbPTx8gqfeibRx4KPa86vvRR7S5I7GDWUTjnzA45fumhAR3ItaT?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7kWEVoJnMGm5wHviVJ5usQFLCjov5qVKZeP10NzO6znzkPbmPB4Fr4/Snw6Y6eVrvyZ9lu/N7VfaBksPGcdKPprboAvV1ICCGRXWis6bX7BqyGUCDxCcw1gV5LqcdbHIoSCD2VKJYbpbi8Zd1/3LwEiR2PmPW+BCQ630ymcPSlw6SeEzKAFWmtN2hfqh9h8aPZfzOZEt+Fc+2sgwRlwXWkGb3uvLbzEQsk+XQ9sBH2BLvrnzbQqE2AtYbvKQNqcoeY2zFARjhCzrg9Fs9FelyCWyppRoGK0wbWfCViz9PzAzZsix6jOQAdf1YP4HTAJtgqyv6N6eWjAyOyOEPDUNbw6i/V9UKxiNEr3GK+dZCQ/njwpeO3aq3NLmq1lNEe0u6tcdH9LLkXN3TIt+NfBB928TGxVPxonb9s+EByRiSxvPkEJMX3KHbv44HU6lJksJq5Sp5D5lXiF9iYTtv8IJsWv9EDe6PfbHeIpKX/6vfKR+mM7O4mJYYUxvyKF8HIfTXVvCkDSlsh0HMGtU3k0ip0vM7XuQbvrvDgaK0DJBfFI4oYRYA0PvOirTcMBHnk7MtdpsDVmVEt4uJzu6yGzsJzltxgOoMC0Ca5Lgd2lCgpM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d21c35-8ac1-4ea6-21d3-08de0c8d88f3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 08:25:16.1461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MFiUEMTCexs5UAt+Ti8Hg/UyR9oD2bmcNhGZLkhH/d1QbX42b8eWvqYzzXckNh63S9khdWmWkyx5p/QzUG8lxXyiscNiVUSC6nS+jjBYOgU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7227
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-16_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510160065
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX9hkgdc2vLihy
 kZqxEQFWLhEOhb3AuxEOUr4NWqelddhdZV1DbLsogS1JpSioM6jUlbxmmexmgSSUBEVPxAXLMmx
 1hICBJEJ8e/QjgOCTqbkJX5NxD2OW/4ZA6fSUU54XHD9rNZUXtnL8pt0ygwU1f0HfLlJV7vufIf
 pYFr2Hr+Ob5AK7Abe1+mC8Kk2KVBcKqOjMcqy0+BTmmHL36bMtAyHO++tqMCtbDdnfsPWTpL8NQ
 fe40JGKg7SmOBnTwT/IIfjEm0OGpKInjhA2Bfpbw134Gb7XS5Nw3dpMFJRCIiw+UV8dSog9q13O
 BhXkTzxt0ZJqtSecKtPlxjvMjk34MY6w4xbkXdS32tb+gG3E9ZKyUh5qfHoMe93NTKETy7J5ReI
 KsJTJqynq2W9faxrTyIyMZ+WbzT8bCDxdS9zR4sPr2rAwr768pg=
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68f0abf3 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=9EvGX9jzj1MgWw9qC0gA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12092
X-Proofpoint-ORIG-GUID: 4jEnxdO3wRrYGz2doEUhrjyCWx1jWovK
X-Proofpoint-GUID: 4jEnxdO3wRrYGz2doEUhrjyCWx1jWovK
X-Rspam-User: 
X-Rspamd-Queue-Id: 74B2914000E
X-Rspamd-Server: rspam03
X-Stat-Signature: aoszy6zn3814wswuxjjmd9hos4jjtysq
X-HE-Tag: 1760603139-316501
X-HE-Meta: U2FsdGVkX185jXgzRkU8YjroErdk90A9iXNBlAb7yAbjuFcb0BfclGfYq8d/kgY4Jr4SGO7NjJE86z51r5PMSX/a2pQFbSc/ntXxWleGJqeXRPCbewHBzZIlgfawfJEBg/7otaOwPnhU+GWWPt6+LPqRP2VJRxoNlDMPh3sUkmYbbSelSYBluTZRaR/3EV3NsvkMOv0xNDUPPhZdiGkzqXSTdN2chUcYc8UC4EXDGdsjDNbu59RanPK8P239WgUoTB7Jo95DufgBnrPYnMz1gJ6rKBC91si1xJ65fLyy1OyxU2IFoBZvSWK+uFWdPtVhyo/fb/PWv36ua1ZPV+4fG8vBwE5umMv+jTUhDNZLF+Wa8f7TBUWuKhxvCvAMmYt8BwfYYvq1DsFQrNVqnFGduwvFHSVaECXNlquv9HYzIb9e063c6Qo91RtsSPD6awWK6c0HVRZ2ZMVKfCMAbglg12mkiQlbanOWtnGL64HhO/yngYHRATvmHSGXM/prNKU06eg7fnbuY3fqeksSpesyqqKknE6EjqQwfDA/Y+BAtUnxUYu/76TxEII39OwIgYu78n2/H68qXzaiwblIKXALJ5zP0lbNsBZ12kQS0s9838kH9LffQ4lIDldCQQLe9790evSaSMGPEZYPvWV3PuBa2lcMF4/rWofsFxOHKZPJJdzDn4TFT773DOH/ucz6Yt2sZM9m/vHZVphZywplNBEGn0DLrVSVHuoWmR/4+MsPLcfif76aZcFFo9Q0QhEuVUebqITrpMpudw6lm0T3v1vJBEYu6eNPSEFdczfWJYmCFDBUvptjZ31OZKA3J/NYilN9inua4ySK3XvxMaVKaYCro0IIgbGpsjnJStU9oq+6zFzYE4OnbkocxJYKFMqFOmaRToDfVE7gCHQtJuFC+YF00yoF3GFMbJ270e6rjr5Acjzle/N8jLmNq/X+pfsIxjSZMINQmOSV9+PIt4f+wCp
 TvuywZ6o
 muaA6Jf8/DUJ5sSJhruO02c5Em8VFP2qKfe7ItQtVKijdAbbl+/d6s3f1aD2oShD8zVDuzCtV937/Lt1ZGkhlduS9ZIlhLkJUIEpH2owtxvc4oLuVBYgwAPevpznKvF+vsqnOWL0uKcDHTHDwA4DHfUefjlaF3s8iAiH7MKZ88pvHj9MFRKxTow/ly8Z7ru/YOTZPNQeOdtgI7ZQ+ni8MYu6kPPJ7Ssl4R+OnTw5u3xkDSDtrPcCr6iAJ+2C8mbV1Ms4OFqKbqDD/rKdOsPOlg4Xo+HR9p/vgaMXIXo/Dm5DqH+Wv4ttAnuTFAGkA8OhStVhnPjjVODM0vtEAB2pbgcDPQTsTm/KLQ4FGvk5Ui6Cth6kRu5fNAcWiozwzFGUEnGrZkS8OjwXC+Lhe99g/r1y00FqnrbMe02DdkmeV5Da17T1GPwFqmtfuuls4WqbUkHAwYyzCx6vrH8n0d79/SDmtsmrKJadEn1KW1+EJgLImsOyjIJhuqAamrxidhcw5wJh7dVZnsRnhbZoIGQs7x2GBzEXA0Sdr/FtX0b5Hn1jEzKR3R0YBBS/KJuYWuQRYefSBOoWQaVDdz9p0pSU6/hibJ+KdGSNq9NwjB6v2YiElMrNO0EDKuTeTQ/Ad/95cjEJI2uAjtQsiLL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 10:22:57AM +0800, Huang, Ying wrote:
> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:
>
> > On Wed, Oct 15, 2025 at 04:43:14PM +0800, Huang, Ying wrote:
> > OK this is great, let's put it all in the kdoc for the new shared spurious
> > faulting function! :) and additionally add it to the commit message.
>
> Sure.  Will do it in the next version.

Thanks!

>
> [snip]
>
> >> >>
> >> >> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> >> >> index 32e8457ad535..341622ec80e4 100644
> >> >> --- a/include/linux/pgtable.h
> >> >> +++ b/include/linux/pgtable.h
> >> >> @@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
> >> >>  #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
> >> >>  #endif
> >> >>
> >> >> +#ifndef flush_tlb_fix_spurious_fault_pmd
> >> >> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
> >> >> +#endif
> >> >
> >> > flush_tlb_fix_spurious_fault(), when the arch doesn't declare it, defaults to
> >> > flush_tlb_page() - why do we just do nothing in this case here?
> >>
> >> Because all architectures do nothing for the spurious PMD page fault
> >> fixing until the [2/2] of this series.  Where, we make it necessary to
> >> flush the local TLB for spurious PMD page fault fixing on arm64
> >> architecture.
> >>
> >> If we follow the design of flush_tlb_fix_spurious_fault(), we need to
> >> change all architecture implementation to do nothing in this patch to
> >> keep the current behavior.  I don't think that it's a good idea.  Do
> >> you agree?
> >
> > Yeah probably we should keep the same behaviour as before, which is
> > obviously, prior to this series, we did nothing.
> >
> > I guess in the PTE case we _always_ want to flush the TLB, whereas in the
> > PMD case we otherwise don't have any need to at the point at which the
> > spurious flush is performed.
> >
> > But from your explanation above re: the stale TLB entry this _only_ needs
> > to be done for architectures which might encounter this problem rather than
> > needing a TLB flush in general.
> >
> > Given we're generalising the code and one case always flushes the TLB and
> > the other doesn't maybe it's worth putting a comment in the generalised
> > function mentioning this?
>
> I'm not sure whether it's a good idea to document architecture behaviors
> in the general code.  The behavior may be changed architecture by
> architecture in the future.

Right, but we are unconditionaly doing a TLB flush in the PTE case but not PMD
so let's document that to be clear :)

>
> [snip]
>
> ---
> Best Regards,
> Huang, Ying

