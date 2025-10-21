Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAAA7CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE098E0020; Tue, 21 Oct 2025 05:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD398E0002; Tue, 21 Oct 2025 05:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E128E0020; Tue, 21 Oct 2025 05:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C9D68E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:45:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BF84B96F3
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:45:44 +0000 (UTC)
X-FDA: 84021639408.01.EFBA19D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1D65F160008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:45:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oVtH+WdQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dYQa3bwX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761039941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4AsGv0nBcN2l1rjym28ZTsCKhHGAk4LEPbZ3IRvwCI=;
	b=hTcrzZ+pGwDWVFZoV2CqJwXleBOMTMYuvnoylzJQuC40rhPPNK8jNguoHPLStuscRXVg1M
	c3iigf1WZBAOwui2rVqCBeIeECqGlVO/nHhv+QAKG8mQ379U/P9ATswZAFAipjskqB9yTh
	x5zFVUWbP3TQlNG0K74iZ69Gz9YG17s=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761039941; a=rsa-sha256;
	cv=pass;
	b=8epWd67iOSb94a9yDv+y6VnoenG5A5mv8iLuRi9pcBx8yDnl5K8aWQWvNv7STqivJUUhqt
	7Vgc+46b3+u9WPx4Xu8H1Q6eWWpKuSYTYVckSHhjzJUq+oXNDlDcnWf/Eo5IyEwT9PzqKY
	Ujh1J71wmg5yML0JlToPNkzMpdi8WF4=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oVtH+WdQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dYQa3bwX;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7uNII027943;
	Tue, 21 Oct 2025 09:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=K4AsGv0nBcN2l1rjym
	28ZTsCKhHGAk4LEPbZ3IRvwCI=; b=oVtH+WdQXDDVTGOGI9lsZ7C9UKDunBv+I4
	dmybCGAfS6ZoQYLPxKvGS4A1uRuzKGQslUByrsk654FodX57rSG684ZUl9+0FiMi
	fUghphcqPymdJ4btZqRkKxH6WttaWytU26mxjnTYCwAGe6jPGJR1tB2l9k1MJt2G
	BrC5/Fe7ZYLPllyH/HhGBJTxvhHEU82vANZ5StTPPUVfc3fWN4Zhfa2HyIX3VD/v
	6lZ5kfgs6c1+nvR6URjDRM7YMzqbhOas5IFSV+Tu5hbWxYPbo+bkVE5oF8pMT9gI
	79/2f24PnmilmS+i+FPBgofOxhy00vPoKo3yCUPTPJ2nXbYgT4lA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49w1vdkh46-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:45:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59L7E8xu035161;
	Tue, 21 Oct 2025 09:45:29 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013049.outbound.protection.outlook.com [40.93.201.49])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcppkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 09:45:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yondpxG5M6Kxl4rGCEgqH/hI3JcJ9EwVEQ8QRW3fGkaEVFoiAavhrel2Wg8pwj2DkWsguXKSP6k8o/NLv4IqwzoEDpzqgryaW2CGJLMM2dT6hRdIlqrwINeD5lwKoaOQhg4ZVJ9x+cNRFaR2DOI9AkOS16vai55aTvbEx8AmVEH9ZECEGEvHQvYirySCSHzdSxohESSa5kWMSeck+85qBVu9HEjot/sXTqbClAYnymzt0ZPrwq64rsj3F3trIxaPZnco5uXHIUBYlwMo5UVmZyoCBPcH+FTKJDzNrmrabRquMW5EAUTiZ4mNJleJ19hV7Y+crYM1VYNTsE0as7/w9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K4AsGv0nBcN2l1rjym28ZTsCKhHGAk4LEPbZ3IRvwCI=;
 b=zKsJ7uIur6VjtuqR1VCQfWX+OiaODzT+7naVKR+RHstgstkUP3MtNsOHtdywkzbJ/BQF7BYjmMXTuL9uJ3TD8zo2PednwUXnonjJyxL0pqKqQ+jWdDWF4noCuMsd6LucV+rbW9LKsdFIl9AtSsEzWFmskoDAM1XIhswyD25xD3EH4th+sYdb2gRgK/vXfZ8zdp+xrxElhUv6sdv7did0Hp6sJCqDh5lbzniVprlfqZC5axGLfAnBrfcd//H7RsmyObuQB5qWRhbeWfvdmI4RgjiZVce+HicQNlNcApqS8qTziRX9L94WkVpwBTX37h/D8IwquMwiVRtSMRxCYovJJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K4AsGv0nBcN2l1rjym28ZTsCKhHGAk4LEPbZ3IRvwCI=;
 b=dYQa3bwX4fl/os6Q4OdMJikfxEc/7zjR0wftN62h+/3KqAO8DlrBef7yfql7UHrmUxlWSzHDDxpInungSSGeBmyq4oQd9K0juZwL/g/vg/xzWxG86emIpEW8UyvNJRzI4y/ZoR5PcB+DTwgTfFLWq6LU7+MNxlcSqmjKOI7uGUo=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7548.namprd10.prod.outlook.com (2603:10b6:208:490::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 21 Oct
 2025 09:45:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 09:45:26 +0000
Date: Tue, 21 Oct 2025 10:45:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
        Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
        Liam.Howlett@oracle.com
Subject: Re: [PATCH v4 3/4] mm: mprotect: convert to folio_needs_prot_numa()
Message-ID: <72e2f6b9-d241-43aa-9a3b-2f13c763bef8@lucifer.local>
References: <20251020061845.3347258-4-wangkefeng.wang@huawei.com>
 <335895bc-c2ef-4ee1-a423-06c673a67147@lucifer.local>
 <1a97f0e2-fc97-4257-8540-cff06a789e32@huawei.com>
 <5ff1ee06-375b-4d5b-b513-7b8cab4e8139@redhat.com>
 <f1d3d11b-6ac8-4747-b2e7-952d4fc3e09b@lucifer.local>
 <719c8df8-b4c9-4a6a-bedf-d62becdb09d2@redhat.com>
 <759578b3-d582-48cc-90af-491210ecd90f@lucifer.local>
 <3ee89484-9cdf-4c50-a5db-79b9f2ca6886@huawei.com>
 <967f61db-0ee3-4257-a44e-69ef15ced012@redhat.com>
 <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <944fe458-6391-4cb9-8719-dbaf69f3958d@lucifer.local>
X-ClientProxiedBy: LO4P123CA0263.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:194::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7548:EE_
X-MS-Office365-Filtering-Correlation-Id: 624ce1dc-661a-4bcc-fe60-08de10869007
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u7qfiB8IxNy1714Y/5kcQWoDly8Z8BxWtmIlvtQpl0FAlc1dPDw2DBf1Js5P?=
 =?us-ascii?Q?x/NIRai3+1h/JarmFk/7YS/za7GPvYIFS35foyc5SBrTSMEyoK7r4dooGK67?=
 =?us-ascii?Q?ZLLWAJtzux1grJrZXsJf/GiBI4iecwPW1/j6WuMKdl175G82klO77On3QZPP?=
 =?us-ascii?Q?NVwYhgtXvR8w3OkOndZ7BtRAullR9l6p4csEeHXz5aZHvvlMoz4IuustM0IW?=
 =?us-ascii?Q?NGmnwGPzyD/AEZhXr3o/u4UHlm/jPwjC+MTZeIQW67Sk1C5pjabHh/Fch5eZ?=
 =?us-ascii?Q?MFXM5ghDl+Zcekwfog4efJFPqteQc5GR304xu3ZkyX7DBMIXBsX08xICEcXB?=
 =?us-ascii?Q?ln4liH5ffU8PTa1M2IR2euvdvACkUYu5RTEV6V7jhpAyH6gvv9p8ZTRS4uZI?=
 =?us-ascii?Q?Z1pMfxfbNy6f+nrutsghf/3BeiQY6qrgKlP2y5y3n7znPM2CFD51bgzxE5Gh?=
 =?us-ascii?Q?gvKk2JPZGrAFzRINVYg6LrEdQWEmL5vfphH5YrbI7IRWq3n9OWlnHdNZ1XZy?=
 =?us-ascii?Q?BE0WvrqvYAKj7PMFd8JuBKLptyhS58QYUJ+CcDR6lmr+vKG5F8gDxQ++LyMu?=
 =?us-ascii?Q?HBMjDwWku+OFdVpl7vom6zGDVxuJtsjf3Wkv6qibsBFRzxgV0/umVAYhGgKC?=
 =?us-ascii?Q?Ntnf2mdp0tVN2NJQRP7f+IQ7IrpqmnImxsRg7zcFeR1MmAgbeHZSCFNXKyri?=
 =?us-ascii?Q?U/8v95qGfRcl/9njlqLbjLaGVdz9OrYRtBlMEUmHofEbSFRPAgQRG/y4A0xH?=
 =?us-ascii?Q?XxI1WWwMmCXr5ZRqUzX890VoqVc/XXQyAZAlpXUa5qpmErnxmPADYbsaDngU?=
 =?us-ascii?Q?HAUdHhqPVhLn4/pgPydplXiJDJhMH1OmiaHh9FM5neZmOmJyUe44tD6Ginn6?=
 =?us-ascii?Q?ePS+6Erv3P7m68vov4w47kSSpjTIZDGeCrBM9hyUf5e2OpCMltIEsM4N9zGY?=
 =?us-ascii?Q?m5xkiUuu8LCt/WGGU/C1S0A3dJ8XG9oEfP64KoyG7XioYgxY2OM7XMZJfDhW?=
 =?us-ascii?Q?5BKFNdPpgAib3rosbdp82b6AwLSEmJ8WzGrjl1fFLr5I+LSecH+mMz6y4Li1?=
 =?us-ascii?Q?3bvxHV5hWwZwYG1wiPuzN4NnAkOBh75MY6WwCeMCN/vtVydAoRMcBI49WiPM?=
 =?us-ascii?Q?470tZpoGCoaDxjGrQDuBdy7JMpivBFnI+XJshwF0185j9R/j8fFuLYQPKuOQ?=
 =?us-ascii?Q?8QEwrWUc9FG8G9CBvjDqYZkHwH4dE9qqScgiJ5xhXYOuTNEP45ctEtP0qWGR?=
 =?us-ascii?Q?JQTFulgqA4dYcxs3sQl0KaKlrSrnSllInO3wlyvOUe6j42PMYnMAccproh0l?=
 =?us-ascii?Q?x0BUkNuNTU5IAtnJO8+hKHPh0oEuKb5aP6kxcIBGtSTUNnYFnASDXxI38A2F?=
 =?us-ascii?Q?UCpj/O/rcVQwROzz/CJflaqM7etf3hYQPoHAVt5spfk/lMatADDgSQwXmNAo?=
 =?us-ascii?Q?DBNlPieT1Vi5SFPWhnxQQaDWeKiPCCpT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yZSk+glC5Nkp+nMbUAq3HMn4CeXiDLs7LKfHMVX3pIkg+Kq/1hKqpsVvPokn?=
 =?us-ascii?Q?wiLf2D6/S6RJQnpk5qvozEruRb0L84CW62weBHLcZUEPJe8ER4GAEX5XL7c5?=
 =?us-ascii?Q?00E3n5mAxPRm+GYC8GUgUQlEHExuk2B6A/Fetf8p5C3LQ+OCPsCCJh9h8xv2?=
 =?us-ascii?Q?lLK6/LXhMel5iDPBv7f4xcf4KL44UR1pykyDyZunk2Wu3n/EOr6YqwTzy9hJ?=
 =?us-ascii?Q?zDLt1gifeOOiMFwltFBu+AjXL9lu7k7h3ohw+SJ7bIV9DAQ6oIDA7ycIDvGV?=
 =?us-ascii?Q?7x3pIRxngklFe6b5D3UzKwxO5Px/0j9/d4XoskpzbqnHGFQIzN5nSRAW7fZI?=
 =?us-ascii?Q?KZFa1XOGt55eU0/HQ/jTlUjPIL/xOYtQe9npfg1qevUzr5KQZpKVBiMv/Az6?=
 =?us-ascii?Q?IfJUUoo/MSL4Dr3EShAUdX+rF9t4gnjTGCA0SDCYNOLnN2j+DlM67Spgo1By?=
 =?us-ascii?Q?Uko/3AZAjrMzMqCubKDWveWsgsNk8pbYMkbQTCTSe/WemWBZbgSaA+LScF6I?=
 =?us-ascii?Q?f5Y2///yZuVoyXQ72/3c0yN5ll2CU2wX8fbbqRmcJzed1OvDaHNHImzpRLQT?=
 =?us-ascii?Q?v4v98OuYTz3koFHxqoXyfUG7/ZFL1SN1emJHqEvC4xkcu+7hMH3/l/HfQZN6?=
 =?us-ascii?Q?j7z4kKFeFiJ6MwFVbzSdpStjtgy+BVh0Z/n6bq2Yj8IXZzUJOioObHT1o7rR?=
 =?us-ascii?Q?MwYC8FCuuDDAbX3H8eG2dTYCALMkL36oSh7FVA+CY2IZfd+9JECYbrol1+iZ?=
 =?us-ascii?Q?hZTjGyHvu+lcCaFyDzvH4IStsfE2PG/2rbhmJ+i2DpSHz2hggmgXL9CGOL4u?=
 =?us-ascii?Q?09DYIVWDghhBQhxoecRlqMclphZlfTEUB51y1N++QozFWEYYNxczv8KoAXt0?=
 =?us-ascii?Q?K/hWf3fxUbq1wcDDoTXLkCLhuTryXDpHTzOpVvOmFRqKqXwPms5Jx0yU+Nkk?=
 =?us-ascii?Q?Sbc+l4QHW3u3fsDVWiEGO2tgg9PylG0lxva8qewU6OsHKmeTRftbQ0B5+sHP?=
 =?us-ascii?Q?2BQAAVNv1Wfsd0mY7pPmAdNfktQAlOWece3RQTSlQ+DiTkyeD+z9jc4JF5qK?=
 =?us-ascii?Q?4mY6aK4pja6cel9kJB/UmgzYFSt/38tkIj8xr5BNcoe74VYNsAA2KB8pRzli?=
 =?us-ascii?Q?4ag816G6ocEdhdeul5ibUEiV1K8I+XLlz5OSgvcmF8D+sSyQGfFsBity8pdx?=
 =?us-ascii?Q?OCpKMQqekxEq6pLZ1FOWAEGOnXAad75I9Qy9mD892an0jAxWWFfk8/Exi3S+?=
 =?us-ascii?Q?7R7L40GVZq2RqBwPPZe0uniO6o4WaYBAqpG33+QDVrB48c1WDsyElwlEI71A?=
 =?us-ascii?Q?M1QqTLGoBV2yL65Simr03HJHG8BingUW1fJaOZCxqrBpsWhaYLPz44tRl36T?=
 =?us-ascii?Q?ArHRkkq0tblW041izi6B37SD+BpDrKO/FAUCkKBDuufBmAS8MDSn+kqL+3j4?=
 =?us-ascii?Q?jrcpNhrnpHkLqBMzvzaWbCg+MFLK4q7kKjFoKlzttjjG/YXh35tljmYLVCtu?=
 =?us-ascii?Q?kL6OZUg+LfbV6/dHAZY5fe48al3rg7s5zrTv/NVs9ABAH4wIyLyuxkUeZGeS?=
 =?us-ascii?Q?lsc8TirfIdE5/XhpfHqsSZVoOheH5jrAfeZOxKjxlfiTFiXfBg/BJeBLJyFD?=
 =?us-ascii?Q?0Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4yIysRYaWCq7eETUZ5klxMyy37k7pMAOCC7rsVnkRxntK3JXpQGf1kYdEuCKZr2jphfz++BINww2gQb1/dnm5NAAcr2Stc9IO21DRL2LOCfZXivTBJQ4nZDHVeXJHwfhBRHTQVSJnM7/cK5VYzbcU4XGitIIW6n6udlCS7xEeqsWq3DoU5vavCMEPC2X7bP69W4u3ASCkNU7RDbQNFdHWSFTauJLuWiCA7qzv3x+rd9JxuQ4OggKV1cGXoKHKEvaA0k9Yb26vtwJZ19QB8iCX5X19nmxgpRfyBhPjcfZ7p+SpkeH90p94MTbGLn89ITlkuVj7xdORiBNzONpghKe0CCK0kAumVl+cr5dS9j9hDY5GZv/bZNGeQJ7ZyfODb1BcJ3eAg4xhdJQ3A1F9G9X/uWpYmZxMedRZTdngfHbOJlqod02PWX8CVRgHMPm9nOd0sHYioGH/cayfvNxYwxZTEBHvI0WqWtQ6EGbTaZS3aqfzV7YZMUqBMR2YfmKnol4cW90A11HKrCfn+ok61RPsVjr5RLjAewj8qr91Q6FqRkKVZNHpo6rOHQTNgZyDfvihmFlLmmGeADGzG8qem1obuH1I/7m3j3B1q6K/x/mcJ4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 624ce1dc-661a-4bcc-fe60-08de10869007
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 09:45:26.2002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vt37nPkVh2aMAeDinLYlMI55A3Qx1LQBXjZYTyM2SFWBiANUIQzlMIfXZQyngWBol24J+p61qEuIuLclhNQRXQqrT11xzMEmBXoYwRQWCz4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7548
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=845 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210076
X-Proofpoint-GUID: c4LcsvxJqVj_OIkXCQcH9vxZfl2rXy3m
X-Proofpoint-ORIG-GUID: c4LcsvxJqVj_OIkXCQcH9vxZfl2rXy3m
X-Authority-Analysis: v=2.4 cv=WaEBqkhX c=1 sm=1 tr=0 ts=68f7563a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=b1ZsPvnPEJ__XLo7NCkA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10 cc=ntf
 awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDEwNSBTYWx0ZWRfX1UP6ztBArU6f
 H4emTCxvZkaFWX5XJBMid9oV+0SwIoT5f+k0hmM3d9c+/ETEfAHWGh5j1Jz9E7kI37UIHzFdqAh
 vIEAYG64ZIRQco18WxybQHb6Gu/Y+C6/6yMN1aVVKun4zpaVk0ZP0mCq4DaIh+6D/lU+MCHfBvI
 1qe6hjSapns/cVtFikvSo8/jBDwE+f3ErgAsil9q9Z4Gz6gp4hENizJx65D44uwFURbylgP/hyb
 2vpcNWnCPAo0iPQCATJvUMW+nKe1eTlbe1qfgyO5Dlh/CdVYlaECUs0pB2fpKmRicFTIXJBRaVP
 bvB50baQBlHLBT57GfDynhPjT+NAEKpfmXIfxYm9+xfIm0G/HC2CaaCBgoJ1hXPFobSBRPVP6FW
 jvYbj/F9Pnv/wjQGBHiY+gcnZYxG18qH84vscwCQ0X9efTN3ctI=
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D65F160008
X-Rspamd-Server: rspam02
X-Stat-Signature: 5jcdayuknej4rryexq5ud5gcf1ugmirn
X-HE-Tag: 1761039940-163918
X-HE-Meta: U2FsdGVkX1+GV9GV2BiIemxi++riCF08OixaQjNdPI2cgEceNNe0B4QhODf9Ml6Tm9ySq91DuGH9XgHTjTMQ+3XWoZNUcin3zd+km+ecmwKN1l/HfrNYK0zzAYDEPm18flBz+ros0b9O0PQM+tyzCZWhnKBuAhZpiRJoc1am17Vw1Lca+/3stCu/pbpBIMuVW3RobD+NxO9V7EVmMqgrslVEm9LaegVphoPTPJ7F0VAk6ztwYeB4g7UMLgFvRWszTVnpxt6LavsN6C6ocbbfDP6ZpQaHcJ4A+wQL404PI9QZQYW8DyYsQKGnVRMzBacn2EqgXzN4b0kW+n13itNvGJX8/iEDvP/cqYstUw2IHnYbe1ofJWQVfV57YWNn5dL01digiI7bXoGBPgpRpd6XrcHbDIsLCJfAB9zdA8EcWE0bBeUmB3cXRg8IVx6xvEZo4sjRltDOEDzz6n3i33jUd5xz3SzJhg/SASt8XfTyRo2/RJ73jWA7V9P4I3gftY2dU0qLv8LUPy4usBNina4fRkb6xaV84vHz4qIfySy43c6/1qyD+46x0qLfbzH1W6/UmpOJbrMUDi+WYdq9/IfnR89FKr7ra+nigSmCebrDn3jUXD5+Cb90ayVkgiQxKkbHUj/fd71/UWc7bkLNpAH0YcTh1MzG7sqyvlRvEHTT2/rRHlXMNsQK4CtUYNAHdHk7KBhUhx1xUynsFeweoW5WcTaBwzfDwNu5bndZm3ma/2tU5P9PToNf8DGxE2JOMzcoomc1FrE2RgbHtGi3xuvllhESOzi+WhlN9PAA25fY7gULEknyr1YxPBm8DkfxcP/iZQFu7Ww3DWui0kV4zdH1Rr8nqjMk9APG11DVijA7/3XPAAoQHjBMeBZTxTehTw2pXpieQ0hf57JRXz3+tGN8xHasGJxy5RjKI0ocE3hTK5oY9dVA6RPkt7rwlMflHypODx1kGDyOE3NvN7N0iQf
 Ip3NFkpZ
 HDlL1eUPhs1fxQAEFEPnV3xwgQY+LI5XSx8mkSnfy74LtMm/Stms9+Vrr470v0oSJ8bs3t+rmcKjCQrmNKtbpGbivfkdOp+ZCpFzWcA7Me0UbhpcRt4737RblKzIEo6XvUDo3xxUOrgsIjmsAtCHDdsAfoezk7pKb4lvkCiNKXIplDFsY1u7hmpbffcXq5zfSOzkS2XzBYWZFCJrMYGJ27hv2mV+ESW34fjQdh/3KG12O7oxIcHukW55lK2ZO+BcQAsQTJa0f1qXOkY1dSKrVB0tl6ra4WG6ZqWNlFBFQYtUsMC/nwuX+I7j+N4afjy/GPJMCGiTlEIQqKq4p0qR9X4eYwX7JRiRwSKiQajPnLxcQMzqTyqQjjUq2hkaCehO8m+p4PW6C/+yk1iR0xzqjFGju+bwByUM4AZsyA2SK+bSrZkk+mOenMIhMvjcV8alpZLAeHAR6+lnUxXm2XizkezTgRiOfqFBgHjw0MFtPhtaNQaI9ZnXFw383HNBubw1bDms1QtIxpGEyEt/JqRIdfAvMycv+IB89wjsPNhXBqAgA5Auaw3RlFEBzUwkJgI/LlOK13x5PvZhYS1fVU6MTQQGcAwhCkeOWWdiVU03Uto8RdZwnBhbujkZo3xDRA5ZiPLqnczpTPlI8ZXo3p/I9bu9iOpNISuQqg+vKk+g74vb01bZuGwfps2Ed1ST24bRZ0s3I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 21, 2025 at 10:25:08AM +0100, Lorenzo Stoakes wrote:
> On Tue, Oct 21, 2025 at 11:13:32AM +0200, David Hildenbrand wrote:
> > On 21.10.25 10:41, Kefeng Wang wrote:
> > > Maybe folio_needs_protnone_mapping()?
> >
> > I think prot_numa should be in the name one way or the other, because we
> > also have ordinary PROT_NONE unrealted to NUMA faults.
>
> folio_can_map_prot_numa() semes to me to be the best choice.
>

I don't want to hold up the series so if you guys feel strongly, leave it
as-is. But this reads better to me.

Apologies for this noise Kefeng this is hardly the most important thing in
the world :)

Cheers, Lorenzo

