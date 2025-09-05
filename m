Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C390CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4C48E000F; Fri,  5 Sep 2025 06:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAC238E0006; Fri,  5 Sep 2025 06:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9B1D8E000F; Fri,  5 Sep 2025 06:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 990D38E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:16:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EA8FC0624
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:16:53 +0000 (UTC)
X-FDA: 83854793106.09.3E4B574
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id BCA38100016
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:16:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aKjl54oF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T0ioAg1h;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757067410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=diLTmIMMTNhp0u20JujyXS3BjKrkE9y0sdB3frxMRDU=;
	b=zUDp3aZDjyWj8BZ/We0Ch70GQyYHITiBWyIU5KLizSqBZ7U7C9c3feSQNRMT5W2aDBKEQb
	pVl/o2oei98y7oXlUsurS5UcMeC5gdrsYUunkClfyryzdUSRd6QoMTAUQEVXiZ/+3JXH2j
	/zGyOz6Wk+TmhZNBs/F6k41z8YgioUA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aKjl54oF;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=T0ioAg1h;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757067410; a=rsa-sha256;
	cv=pass;
	b=VyhAxcVRVC18KhQbY/xVkpndsMB8lkLgQxnHWWeFuFGuulNtl7M4PHOtd/k85IdqXKKCCp
	QQ6VpT5i2bta2rie8YHU0SMqeGhy25iulUluyO8rohhg22dIF0GpGq4g0YsVh1eaqeZAPP
	HVDbyCUyi8ZlI0CZOifVzuVFF8NPXro=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5859nkYS004056;
	Fri, 5 Sep 2025 10:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=diLTmIMMTNhp0u20Ju
	jyXS3BjKrkE9y0sdB3frxMRDU=; b=aKjl54oFEAQxQWEaqb2jCQzjtjV9KUF3Vl
	m97S7pBSr/vvlDggb+P7u5WrWeFPFallZTccbCtFzUE0exGcLDfHGtViXCFqQzrf
	uax1tSY6LG2iNCjE1B+g2dG0C48MvlhGz9Lq+Jk86FLV9DjKYv0TxW/+bBL8cOH1
	vvNtlrGhus5iBIWUTZzOd7TBZkSqnpfkrUIUvWDMig5MYbeaFCzg1915paCv/qSd
	wuCtFfaXlVb+yWr7WGwnN4fWqnP3Kty5SgnUqV5EsFJA5vt2nyPjYF+torjfyEDo
	zveP3+y2ExfuFbwtwcaQ9tU5zHbTeyEcEBttSi9cvzsE/Si3Y+FQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ywjq81at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 10:16:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5859JbIL031709;
	Fri, 5 Sep 2025 10:16:43 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2050.outbound.protection.outlook.com [40.107.220.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrk23py-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 10:16:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bACG0qy8WVk1Ib2j5CjUDL2MrIh4ocPgP4mU+TC0kzQDHFlTf9ZvenrXeFNZOsmeFArCJ04QT7Ht+gKJgjxIyZBtE+fZ2UZ9c8DQ90i4qmH+tYhFLytgPMmsZ1649MTF0WXlJoSn3Y1knI0zocrvZ0EZtbr7CvKpEd3uBs3N40HegzuRUxCtRN3u/M4JaIxK/udYy+Q2Ks38PHB2pgK5KEqtzIcRj3y9fJEUz22LI4b0vI8jdxyL6hVpHiJQsuUxKs4RI7ng5hk+FQv3lCWgfgx87T2eDeJ59E1B4TjWV7C+kHSA+RiQS9+hLV4k+faM4g1b4XYuXoKDS7g8n9hSrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=diLTmIMMTNhp0u20JujyXS3BjKrkE9y0sdB3frxMRDU=;
 b=LUnAKaaxe2+G36RwLzJdgfF1VFWR89bacIWX/jFN+8Go2VOl2lToFIZUpKXjEduLwZby7W4bvTKOg8kQKJLAd20BxABr6zdXRTRan0p5eSBbkNXi2CPClPUvgnKs0nQt2h2FDctCq6v3bTh4QJndyY6JXpisbPwnF/8r98DK+hSIAuWeHDYNu5RveJEDuWd87djBeRUxlGE80ZzSjnx6p2RH7NuYqUWnSfXeoc7TwmWB2LObwjb+mWhS+HYbS7t6jiP7qoV3YHyrqWwfKPGJhjh3cgrxted5wOPWN/jP0ELTAKcqX60NPF6wDVsmkdUzJZThv/QsK2lbe0qqnRvvPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=diLTmIMMTNhp0u20JujyXS3BjKrkE9y0sdB3frxMRDU=;
 b=T0ioAg1ht/rLB7IEY4CK+osX90QOcCBLTR8DdCHtZtxQytOWdLKJEj4ZlY9mNZs2EB5CU8u4tZLJcIBtCXPGkKws3JcobA0+6SQFzB+ubcgIYvtHrT+CQ+PF1yu2ldIsbCj8oRuwog2BjtgE3VZpyzEmNMosYnOz68U3oakF0GQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB4679.namprd10.prod.outlook.com (2603:10b6:510:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Fri, 5 Sep
 2025 10:16:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 10:16:40 +0000
Date: Fri, 5 Sep 2025 11:16:38 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Michal Hocko <mhocko@suse.com>
Cc: kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
        Usama Arif <usamaarif642@gmail.com>, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH] tools/mm: Add madvise tool
Message-ID: <0b22e23d-f00b-47da-8e62-c8b0ced05e4e@lucifer.local>
References: <20250904175729.1029735-1-kirill@shutemov.name>
 <aLqqlkTpEM1SkvaE@tiehlicka>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLqqlkTpEM1SkvaE@tiehlicka>
X-ClientProxiedBy: LO4P123CA0673.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:351::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB4679:EE_
X-MS-Office365-Filtering-Correlation-Id: fda1f3fa-e86f-4a7c-74be-08ddec654e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6nual1zqEARkfsJwYGj+xySHnwlsz70aerYKq7X6zzUx/he1vhXEfSpwaQ6I?=
 =?us-ascii?Q?CAmnfNiNxK58Xr1y7nwoyAkhA4hjDPMk1ASSkgqcmFeW3n0wAC/TLu0gD5eM?=
 =?us-ascii?Q?GHdK14ea5J4E6KWFiZ6VEHp6VeUZPaetMys7ZVN9+DDdFGNNJrhy817EeMsR?=
 =?us-ascii?Q?u2FVZmFlxg6br+eq0D5EuaguNsv4+0zaQwvUnSxYZTQcrrhmk2eLpDbynPYk?=
 =?us-ascii?Q?U0xTHCyku/8M32DH+ZF1ET+4G79+Xl9I4ayqUqSk7RfRiw5qJOr10Wy57Xan?=
 =?us-ascii?Q?I+IhRW9QcG0kSqBx2Kb9ajZbULDOwm0xJbOpee3XB7CjtpZWmM9NxGj0N08n?=
 =?us-ascii?Q?+vUsGdYJwfNBiCmFu+NX9RPka8hNikM+zJx8sYwSqfqRBcErLy+1aWGj7xwd?=
 =?us-ascii?Q?/qjG65HmBWhe0rAQf1R4TaQr9ZLxEKtorlxL4zMQDdpUjEULS4qoz7/6YuX8?=
 =?us-ascii?Q?ldmTyz1klkg/6NbRqBLb/QHuwTCwC9m+trAIJALWnI8D+4SDNy3pPg5TQJcN?=
 =?us-ascii?Q?kAD3ZhOXEplOMZRkfnhnVRw0b/HnwPldzWZ5XfY0S1F2hiSln3qMOEjS/IbL?=
 =?us-ascii?Q?ndsryqYkEMxk9HpsRMUACs1PKDe0v1IWSz0Wnq52FexHtLTqTTnu4bT+FBLy?=
 =?us-ascii?Q?d47k6EJBvVw1EYcv1GDPFI9021BmVKuQhsPTqoqlaoM/v0gNl1WpGOhvcHAq?=
 =?us-ascii?Q?gJI/EJ0RI/WRFlRpwzZctF3ONwAHldG+U7YM4dYBEAqkO4j96/sE6E41Hoac?=
 =?us-ascii?Q?PeTfsOsRByea5p7A15YVOhG6u8Xc5Ug5SUvbUWm56pCd450gbvqzxRdWXply?=
 =?us-ascii?Q?hxzX4c0vUk6kMsrrhSjf0vsKMT98CDmFG/oUS8tAtrjTBFz04Ek0ThrWZRVG?=
 =?us-ascii?Q?J8575Ut6pLEQZ0t9EaAUVcnEFWkOkou5LT4t/l031Ae+mUFp6N62TE+nAxEr?=
 =?us-ascii?Q?BM7lYPQ216jF+kVC3cDhfAhNrmNxhLrnq/Ao5Q+aH9J8EnW9ZAsb3dZLY7+g?=
 =?us-ascii?Q?Z+k+Fic7yOkmSGc+sXEax4aAHsYAJu8hGfVeimdKnlrZsPfY8pf7dvWjWhy8?=
 =?us-ascii?Q?877I/1YQ3gJUyxw8bO7ynB/ceYIxqWcuUWi9hfU4o/q/M9prjqKu3ZkPXlDg?=
 =?us-ascii?Q?6GMC6q32D9skWRigGpoJO5yCShF94e6UAD5SMZavCEDTW0n2hS81ziBBWK4g?=
 =?us-ascii?Q?1aqEIjPboxfuBlVE0JQmbrrMg2gz6OCr/rfoftrDzQdMbKiN3t5kKyiwiGQ+?=
 =?us-ascii?Q?t+nYQi+SiiZyuMqfOJZP4ydEoY/0etMxZfMVAQf53ku/tFH60IXkffFxn3+l?=
 =?us-ascii?Q?YSxXuiRnAFiMKJOmqUccgGuAAfCdy/mWjc9guznCBzoJPC7mbQyjjAQj4Dtm?=
 =?us-ascii?Q?ZhBMoCQGs6rnswaqwhnYR3Y4yHZxKfNbOnrs16RfS/wZuJ/j+F4RAr4CSHyn?=
 =?us-ascii?Q?acL34QqmnSk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IJxsBMYAD6i6d5CyUgR9vtyTTwXUvBbgmBXnUBKUz4OrYiskqQWQJzOHqskI?=
 =?us-ascii?Q?g1owW5Ge1pE8VLB0dJ/E95PzYX/1TTOsFIDkVZtRnCS+XmvYT3bdP1NZ7Kh0?=
 =?us-ascii?Q?ytCP4Sm1aGt4CHnkpCJX09Ex5BVKH1Qz4vGq6ki1vA+FIyMz9/3j6nOjqDAG?=
 =?us-ascii?Q?WAfzmri1m9boNTxpIp3NetSLGCK1FVI4vh70q9kW4E68/SyFo9p+pJGTbxmq?=
 =?us-ascii?Q?2iJn/oNv0cJG7o4aBTioZdDHEQ8ugRn+xZX4IzVM+2UImy2Od1rF8t8z7fJF?=
 =?us-ascii?Q?qIywALNyhjpETNZh+RkjVbtgtOCHU5hniME+hDWKni3hZJqKVVz8yirRFBOV?=
 =?us-ascii?Q?hcmLddHkKcIuwtSNTcmbU4J4T/YefNh1Q57RgHk+8VKn0YjKqZwWiCk9XbFd?=
 =?us-ascii?Q?4/G4NptyoHL2HFBiocVi/Ezu5ZvFvEnRWsV4OAphMZ7BxklooY/Zj99kHKK6?=
 =?us-ascii?Q?9+yRmKVkTE9xtqMjzDB7/S1QWyrnJRt+qZcbLnKZQg1e1jveAMwSNWa7rjh/?=
 =?us-ascii?Q?JXw8DE6l9/heWsS8jQt+f+YtAskoC28dKEmNVM0NUTwKvoL7+NaeEaPBzbds?=
 =?us-ascii?Q?xlpSswBqkoRnF9YIQQm6GxVe5r62qcDLhjzcIH5MW1zRC74f2BkApkwI4hzk?=
 =?us-ascii?Q?E0ojSlkzXtYLaMxOPJWwPP1nVxShoAS3Zx6AldKGec+TmDcD4ntXEkqzTp8H?=
 =?us-ascii?Q?5ZY8eXqABnBPNFAetBVMR7dJqa33OfVbwSXzx+ajYFJiJ0yleWkh23IoxKnN?=
 =?us-ascii?Q?mAVZGAJl0w9dgpGKGi3uivk5DVje/TmjNQa1l9WMYKR34++AxZnDxOND/eNd?=
 =?us-ascii?Q?6H+GyzI48b3H1CgpANRTfdu8ZcQBGL6nGGhED+GdaUFsbdQxD4pX3cPI6kmg?=
 =?us-ascii?Q?YYbe2M2KyCnhulednZ6CUDi/jLiFaceqGGf6YH6uv2hoPI8WMFKAZPlZ4uDJ?=
 =?us-ascii?Q?/pCWTLoq14imnUwuhfoi5Y8DIn96zNSSdbCvLg2AYHFhTQIvOkT3KiKIeyYp?=
 =?us-ascii?Q?FdG1/ybzwQQi4lwxR0vLkxXFrPylMlFWhPPWFMW6LPVVjDv4rFDlRfwZl6yJ?=
 =?us-ascii?Q?+iJopHdI4Fmaom6rp+v4Cm5PkRLP6IF/DQUTyn2iELLOv5MvxO52YBGy057O?=
 =?us-ascii?Q?s+vSgU4VfI4iDCAOUNwa0B9xd94jJMyxhIKcPSO6zGNc08cQzp8mZoCEzPvY?=
 =?us-ascii?Q?KsQ8f7cjtzFG13Wfyq7bwjwugJ3Z7wZvSOmEqOIjx3/P78OGaS3tD9ZgIPMS?=
 =?us-ascii?Q?4yOm0SHVES1AU91bkV0WXskhFgE9kNYxDk0DdP1VtUb7N5EZ12IXd8eXr36W?=
 =?us-ascii?Q?QBb1S4wZLdDfh085e457+hAu60LlFRge3ITObrqMPNHfQilkZIgycNUwxyH4?=
 =?us-ascii?Q?QK2q0XYgEDwX5XWUL7jWOO0KtJZT2AIkzV+Rt3ObMdlnJv0M+doBd8Kd0+jG?=
 =?us-ascii?Q?k4nesB15PrS0Y/3nqDf+h619zgrTTvnQMaM4IZjHca15VRwFwp9Pr1EfY2BA?=
 =?us-ascii?Q?XWXqtn92JP03cj74iAWpd2BKxn73cEnoxDOWcMJhU+5x42CnfMdYUU8/y49A?=
 =?us-ascii?Q?ywYaV9YOrpTzfPYOIlqMSucIUnK6vGAPnkibqhaGarEUBNOA8Xv85zRD6eP5?=
 =?us-ascii?Q?bQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qU17lF9hLlfqPLRnHdExpmhxCp/PeJ3YoQzQmTn6jhHzBsnogbC8/86eaXrg6u+A+tA+NDtr+KDZk1GNhMLlSbux20HyrQjHKv7caOClMrqWD5x/q6hI5aTSIPH8IiIohmPqhHD1HTTIIC/cxWt1CkKgN46Dks01lbrkoUd1WseHvnThy3bVeZfs6GsiU0yJ4zchjnsxZ6lbWGg984moLY2BjzsC++OO1vXnVbUGEUJ5+fW8KmDPbM1VXdZIa3iqvpoVu7S3n9xD6mMtCdAMqgySF/eiNk83N2Nlm2NaJor+at904G0AcBzhzEftZ0ZbExXD0061WkQ54AgjcUHy6jHy01MKd+1b+aH68ijIcA9jzinHN26ATIFRu8LFft9CwcfVZYl5OjxuEGis8mZ2qOsd//0WIXI+ht9cvaTJftlcBqSFM8Ap+BCz7/jIEi/cQ6kU+5eef+1rhiIefGO4dW627MCIqQyQrqC/TobMvanFBnzrg/SrhoYTbQ1NZk+oti5PvDKSUTgQMH6ZLXfDas4veZziMfClC8BKPyO06EpznnSQnQo/uUyWL+DVyDvLVpM8h5o+hk9ADGrI/MogWjH24RzRfDUk8DyuAtBBJlU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fda1f3fa-e86f-4a7c-74be-08ddec654e77
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 10:16:40.9436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17aKPhM3ueddGTo2gJlO+4tOX0A+N0gyRKk7T0Cge5cSKMbIou+87AoQTLXfMj7Pn8kWZFxqX2BG62V76S5hWMpTLRvGGnmXVugOzEquxdA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=706 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509050099
X-Proofpoint-ORIG-GUID: 1AS3UT60ocyTDVCeU2I78LDg_JKhqSqs
X-Authority-Analysis: v=2.4 cv=CsO/cm4D c=1 sm=1 tr=0 ts=68bab88d b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=ryyql7X9j2egnI6ZKiMA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-GUID: 1AS3UT60ocyTDVCeU2I78LDg_JKhqSqs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDA5NCBTYWx0ZWRfX1pVvrZ6rxxZs
 O8qQx4gsv9VcgydGU04LFdMGOtRYiRGkalxg6Z24jxEdKdluGTIpmm/3GP5XiLMCAQ3hsvduOAb
 VDlErdO0CmJ4Y8ffkreL+c7oTEBDjnqBcvYNMtSQvhZoZ+DJauqT7OSB7lG27eHY+3GsAp89Tf6
 IF062DWnhXkzB8YUVkx9JCTCCopZInaY8FMCRdpdq1YOPE+nmhB8IZuBhZtq7AZdEnn7oG+2Kgx
 aLYFNQtPmp9AUMQ8ss1cfKZjtsvcETpTVmrqK+B62Dso/JM5eVl6WAMWOmvGwlemJnJjVtzwFFf
 1vWvrCtDYGHtYy5rgBJZlqWhqOopfLszH5SRhxqYn2hnPdSy3TjKTc8s01Rl0d5KM6/NTa/84WT
 K5HY6oMGyEmwOXHPL/h+ALAbG9kbew==
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BCA38100016
X-Stat-Signature: t7zeqw41hcfg568ru3yi9b4sc6qfr3nb
X-Rspam-User: 
X-HE-Tag: 1757067409-49467
X-HE-Meta: U2FsdGVkX1/eI7SRInHWFBlUEh2vacKsTTj9eGY5MZFiZdOcyFrAjJbXlT5o3/YhLJjlLy49Dx/xSktF4KLZMcEX1JDGQ0ab+OXiowtzPXQFYjAaFXHs0NC4AhxaoJLvq1vrhMFQI/TYCN+pZVfnxTr9DY70Rtu/zTMQUAzKeLgirHQJAX0uCwDlMOrLUNU5cAAfPoOxW1rJySFYPSzI2CnqoCF+ppmRxzvPWRFDLciiteJeYgKerxzhXkaQ1VRcEKBG+ZYvDAvX45k6Qv+Up6NpBFA2Nw34xdDOGXiJj1N1MQ0NpQv656v0ynOxmSMsUGtwEkHjb26mWzhmfaLPOhYPsYk2PMjRcXulMeuC1Ghkq66qBAPGKVR7XqV5cPxUE9hysYbwRqZWWk9KMw+Y5M1jlA6G9Pjswf6KvGLjUJqAtw5nbYTv3ScvTC5iOYaJ6wSiJ5Jbf2+ddk7Si10J+KEgVA3RipUyg4xQfOnRB+HC5bIqJebRC/b0dA0InsYj3SGIySla27/iBCcV2ON4VKW7Oq5qjVcY4KAYwNg6rNL4p6/o/IaA1ZI2UpMv4dD3T0UCaAdxR0UWU6EgyluYckgWC2l6uQLPudjJ+I6EqYPmz9XjkFRGeitXZxxm7GO36xSTuSYPPJ2UZL0cjm70Ux73kGt9HbtLEL9gareJD/ZJTHbxyveLNx4n+0INY1gUy3ZYtmLtOY6uPNkjKBpwH5S0fcLBSf7AjOQ0TEt3w8iHfQJX3F/5Nqd/GkB/hgfhImoA4UqnTokXNIUdNZ/AYW7URkySI/FP3Pmmy4/CiIG9ghVdZspNo1f0o8SjYVmQxaHIiRxoEpUPIa4rWej/KG82T+p6qdeV5vnKWQ4sl9gGpB7KSCtesuAJDQNfTCt5rMRDr45j2uuG8EC+E44vCbCPJW3+Z34kltiO+GfX/hWJkLeBIFh0uRNWxWNivwY7+LVZq+sGy2NC8WGNgK2
 LYM7b4uZ
 /tLP7RL/n+NudC7SYZV4Bz47Libp7GlRP2GhfUOYB3gAku0JTqgUASsUAsuMoC8t1z67Jup+klH1ne3DVoDVV7mvo218bWm6WLF20ISnyjXS8SxrkrLhN3ZECsYdmyntP6mq7kVjW1EJrYo2BJdIhMTHyUCI9UFDinrjcUVzthlVfAIfMpR7iBGjBQd7M3ofqik3rS0Q2CcNaQ+lAZs2CyxW5DhHzd/PSHU1ZnKJIYaW8GOLWekItWAuplTpV9S5X8zPmvymV2z2TeSlAXlV+XEG8NS1xa63xxEk2pArWakA7ekdUpn4KTjJl2bS2sYhk1mTVueZDjNjnHbbZyVma4geE0LhEaqszmj+kshJSXLyNapVeYp4bT0FP/rG1RMNSsOc2Mvc+guUMVrWssq5Cyo2MP9WUqI8ZmA488nTja8/IsyyvJQphJK9lTjj3hldG1Onpl93uN8xXiBc9AYShA1R+OHP/zQJyw9RrmcxkAfbO9SnMnp9L73aYOjsCeslKHvPtiOXogoJ9VymrbavTTZr1IMyV3BBpTdwXbh6kfyeOQT11NKUsH9W8aTkjQ7F9mIjUpch1wT8uFWc67Bm0LznDqa6xSn+M3Gmnzt+UMe5RL3Vhu85SEujFCCIRGpqn+MplswzbQJMcQRJPMOkvCNLJ2KydG1V65hBfbX9mMgUlafq+O/T8wpufGMBUvpBD0Xfze2Z0YfdUKGBH1lcPeP9wWA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 11:17:10AM +0200, Michal Hocko wrote:
>
> Is there any reason to have this in the tree? This seems like a very
> trivial tools that doesn't really need to be in a lockstep with the
> kernel source.

To give my own 2 pence on this :>)

I think this is actually quite useful because it invokes process_madvise() and
so can be used for experiments against other processes in a way that'd you'd
have to write code for otherwise.

I think it's useful to keep in sync with kernel as if we add more remote process
madvise functionality this can be updated with it.

Cheers, Lorenzo

