Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02048CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 17:50:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEB268E00B9; Wed, 29 Oct 2025 13:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FD38E00B2; Wed, 29 Oct 2025 13:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14D08E00BA; Wed, 29 Oct 2025 13:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B14818E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:50:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 780591A093A
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:50:02 +0000 (UTC)
X-FDA: 84051890244.30.39AC222
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id C6EC5100003
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 17:49:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pjPtrmXx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t9Qrmhyt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761760199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6NWbwRJ0M7nmTWbbScYr6K8SCXo7Kb3zL8BXdfZsfs=;
	b=PeMnkM6L7NZs8h3G/JCuoukmCEmkLSUlRsdUlDSkMlnH/nlkfI6BkO/vlVaMSLwXHd2LPo
	oNqh1NbirrDkh8DfibuVQfNeh/Kzxdx+3KJyBRTyQvHZkMhxdTK3KT3O7RXDc4RmcVUPL8
	ZIYsGi5HWSoO6iI/AWxXxgMXOi/loKE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761760199; a=rsa-sha256;
	cv=pass;
	b=rEpP493+0r9xxjDVIFMwi5+jM63RvFQax52iMr5GXVVf4gsvL7ICTtx2zYN4LCiH3USQR+
	Z+GU3TQuNh4WZfTLQZphxSll2aTCnyZS1OQHs0/zVm+jvxeZnLuH3PU7YbxeEjFR1awV5n
	MFzjDLPrwNCkanCif/5/L/qc6lDCr/U=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=pjPtrmXx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t9Qrmhyt;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59TGg3hQ031116;
	Wed, 29 Oct 2025 17:49:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=b6NWbwRJ0M7nmTWbbScYr6K8SCXo7Kb3zL8BXdfZsfs=; b=
	pjPtrmXx8yPR2nb6qcHPzcbPx7uL/tHhIanV3hFucqtkU3ddl+7w/efPyvo6BeJR
	JrYic7NgCdtnjTpxZLTK9pTMJRL5e8QphEgVCqCjOX2RSZfJFc3Eh9rEyjBHdBcy
	JLW3lciOrGREioChuiH0ZS+YlO+7QL9PezymGeumOwHTCHjVuC5jn6yyi+T4bgxz
	DLq//bCpFXzUixzVI6IJXqj5FlgTDFJo7zH6dFiDBHcCyXTxEBvmem3lY+F0+d9r
	HU+xzNtxMpPpQbjRrCTe2ls2bvSm6q3dAwHrR5lquF+nS78kxjwH6UikPZMyLz17
	BVdAwNZSo6YlDj/cT8Y6qQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a3bgkssuv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 17:49:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59TH2B5v031695;
	Wed, 29 Oct 2025 17:49:52 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011020.outbound.protection.outlook.com [40.107.208.20])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a34ec96q4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Oct 2025 17:49:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i/BkyZkEY/uhTC0ZlKVNNf7BFzCrv8bwTqy+X/sfjmtNx5IXFKSxd5bwsGfSakB/dz5WDSS7MEdEebGacRAIGKzV/Nxd95m9Tvq7p68C5B6odm7/AnNK1l+MZSHBrrn9ejRJxxk9B4blQ2/rPVvzCoEVAgvveBpkJV8yWJ1hCUcj2UckttDKn+Aw7c3Gqjjs6ClkDqV/vjF8lf6E/iuUZPLvjlj8ia9KRMUssnGcgNAFe483odk77DH98/jSB67XHSz6VVJvvYUGB9VZ+8pgIJG5BbGkJGfrxwtREGFZoWLYcuCrsIQ6+7sYjfu8yokXUvnru/awcb8358XdEP3Rzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b6NWbwRJ0M7nmTWbbScYr6K8SCXo7Kb3zL8BXdfZsfs=;
 b=iT1XodJOPymfS0tPkb9NMqnfkMhQk9EFtegRlHjTxNQUXPG8LvHXeg5nd0cVAI7zx89svqF667u+frbAkJYfyqHgZF2Q75VKmTsGAbh63vPhbxiBbt+HsBI57Qh189KnwL90vYtDz420hsEdFeIfMAJBYzWOHOFsqtQIqY0lmUT81ukDAZ/U72pVBAVtR+4zJjqsFHqSYAZ0ewkJLYJcTtDxBsBUTcFVuFZEF6B1XtsysJo3s+AwBU9ZpMJSJyFWfEciWFUBSniRimK+n+VL6Cd/yv6Nc2hH7YW3G2Q46dls3J5XSOV0sIXwL/18boqE+Z25x4mJPRe6lqUPHueP/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b6NWbwRJ0M7nmTWbbScYr6K8SCXo7Kb3zL8BXdfZsfs=;
 b=t9Qrmhytel5a8GiS4tFU6U278U3ICRX3pMo4Ik4/TvoMgMVCMr2zK7wikzqFjpyNgl9OKps8IZJCt7QGmOlH9sLiy9PFqMqMsoz7qIRtx8Ar62LLIVrqpBJmqK5ZkJSB1mz/fsxIldxmPvkJpjEyPMNS6oc2xnxgOV3/WdBjQYY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM6PR10MB4298.namprd10.prod.outlook.com (2603:10b6:5:21f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Wed, 29 Oct
 2025 17:49:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Wed, 29 Oct 2025
 17:49:45 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
        Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
        Kees Cook <kees@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>, Pedro Falcato <pfalcato@suse.de>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 2/4] mm: simplify and rename mm flags function for clarity
Date: Wed, 29 Oct 2025 17:49:36 +0000
Message-ID: <2e956728c7af82d66286429c040451905b6acc7b.1761757731.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
References: <cover.1761757731.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0003.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM6PR10MB4298:EE_
X-MS-Office365-Filtering-Correlation-Id: 71f8e9de-13f1-406e-99c6-08de17138bee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q20JeR3OfbR1Evqn36CE9AMAibZWh9Q0hUFembtnQLPnygLdVI8dqu33+To8?=
 =?us-ascii?Q?+1Vwgp0M6zoIQvNAehnocy+qLYEyfpeKm+X+LcybsbZDNviR7fy2WLO9mQRU?=
 =?us-ascii?Q?tpWS4xgVJTBb5KR+YaUnRFeRMYkGNtqdO9Fsgp7Z/fTRF5yRxi9paT+cUEsw?=
 =?us-ascii?Q?y+iP90SzpB/LPtOYVSfRlKZ0RTAn+61DDdPuJ65qWNr5FGHXJFR4hI/KsoWm?=
 =?us-ascii?Q?NJ7xnRGlB0jEdWdd+KTuo7pnIe40A9WNJ0NzaFDUbuuBOseWRcIQrhjU2ro7?=
 =?us-ascii?Q?bOZtKoapK8x7quRMtsBZ2YSMcfMQgJDs2ygGQzl2i6OfZs5m/5Rp+gV9uCUs?=
 =?us-ascii?Q?RHbOny+IcsVL0vCWGZIekMFuvdCWRHMx7pxB1ewp87U5RgtQ9lG0xf8AQeim?=
 =?us-ascii?Q?YAE5R6yad/V+OiEtFC/+CkrWGG5KG5WdfFV+RC9sbHfeMN5nToMir2s3X5dz?=
 =?us-ascii?Q?IMGW/lw5xw6yMrHjyy4TmsJ5QOinEZqKO7aXTjk7Lio7csG1vaLIu+i0pwx6?=
 =?us-ascii?Q?s+RlKzZcjpfEw86DqKfp+A3kycTVLqJUkG74cOBASsxoU7pmunBeudxg3chV?=
 =?us-ascii?Q?rCJ9LpdtDq6PWODTWAuPUtXzSS1cw1qS+Df1+uqzvjBZmCfxSGpaSKeA5xzR?=
 =?us-ascii?Q?Y+1zdiAElUjaBjUjK2C6QeO4BDKeEaXROD7E9H5+nT8NRP850eo+RooZFlid?=
 =?us-ascii?Q?6UwBJlmHhRkI/iywZ+12QAHFySn3zz+MEYwXfrX6flzz4gPy/xQ8UGC6L9+2?=
 =?us-ascii?Q?WfRY/tQDTDkBUtG/TlRP9QNx7JX2nzGzzLCsA4vz7th2uu4f06m222QRwyAO?=
 =?us-ascii?Q?Cr8L7LmNsShz7A/wwiUTstSej2YrPikF28hPN3aNsS8QSb8ieEvaOAD/tESz?=
 =?us-ascii?Q?G76dIWNwGMDAg2/u+Ut+vTNmye7c1NHUeIHLBY7hsRg0vVy2pZZ/s9dqG358?=
 =?us-ascii?Q?TpMzxeuTxnLqYkuaSTPvUd1PpOQduJNZrehFOyuiztCMhXnp1Es51mryHong?=
 =?us-ascii?Q?wKYUs4dPILvj4tdfhhWmgTEBwE5q/FaWHuPgT4w48ss0HmfdHGb3pRiJ2yxa?=
 =?us-ascii?Q?gi5wSA4E1pjsWc2lNf6PjMQF297qhIRBraF2l76OtTFtyF5eO8cfixjE4ZPv?=
 =?us-ascii?Q?vhzTxfPAkCKrLxLsAwr1+ZGDuFHVqqE1MygKET0cTGtDZMHNtAuJKatAahfn?=
 =?us-ascii?Q?C+exlpV3vidYz0vx4CLGV7/39oLpYrah8U8Eq5N12E2TC07CWnJqIyMAHS7v?=
 =?us-ascii?Q?hrvNEWWdz1LYRoRzLs53+EdBU+1J4Si7buBt9K4DffKqze08OAb5xc4ylXfx?=
 =?us-ascii?Q?FNhPXCwtA+1XahQ37Mp9buUgukVt7z/A2mGqe1I7FeoPYwhA+QoWzSywTLxK?=
 =?us-ascii?Q?+/0ZecwGyI8yPtqt5eNs1eSI1feEbA0YCu2u+EnoV7IyX9gMC6g8kt42cZjK?=
 =?us-ascii?Q?k3rkTXQS2VBHq1DQy/+9p9lf7yioYKxy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4QEgTxqjbzhlF7NZfiG5M/Qd1tOjT0hCT/wvPwVXjLwpXgseg/u/4aKX7u1c?=
 =?us-ascii?Q?6/Ns51uxjL+H3SnDqnaA7bg9IcOfCHftfcZC12SntqjdtKvr+bYAVpTzsCGC?=
 =?us-ascii?Q?ZdHnkPxsT3txcB2dTmhbvrdQRZhbBLFMGB5IeBAUArzPXArK52pVL+c91zq+?=
 =?us-ascii?Q?yGajF7U6nJ3hve8pnu3bKnxO7HD5LzRH9iF4tl7t1wxQ4lxfxqhl/NLjRa0Q?=
 =?us-ascii?Q?ldUyG5Qghr4NFJb0UxTUZhqZeqkc/WHNhbRp+ILxfAMaL9VCq9hHMF8RVahi?=
 =?us-ascii?Q?9sqElGQGSfmG06dgNMYUR9XBIyfRhEJrLzzbJSeaX+yHRhLxGSrd+DWE7Gcj?=
 =?us-ascii?Q?W4t3YRGDUmFhdduWxHOwZlovqeNy/Kd9FXi3/Ya8LltoP3/W08sFYitBlFlG?=
 =?us-ascii?Q?VlcyBz6AeWGQBKcrQFFuF8uN1GScAvKsaJxdhsLrscnP7OTxuzjXc6Um2w4+?=
 =?us-ascii?Q?e6vipptO9j21WnJLegGa61yew2mlkskbYyFkKoHYNkrvWI5Q0v7lyAH4pOH4?=
 =?us-ascii?Q?ip2l/4YTxKt/By1nqAIhDX3950Y0dwFQpmH/IfexwAz6qPRiZ6Pi/HFd8Jc1?=
 =?us-ascii?Q?OhP74nE6RvuPCYhhNbpsMHXG8JHZObZd3k7TpawOEWFtknaYt1e1mBpZZVd2?=
 =?us-ascii?Q?DP9vT1jxyYxiUUGjT2JGgwtE34mYmhZcALqvIL0v6IvznLeT8YkBAREiPL1B?=
 =?us-ascii?Q?Exb4/Fzar+/2frbDYfpF2Pr8CXYVtcbECzfrCAr4vrUL+ug8SKqF0C/dd0zA?=
 =?us-ascii?Q?H7esSgdaEkQ3zMLb8DKOrS+zpeVImr2xFn0WwkoPZgKKbsSMuAN5/oRsOHjB?=
 =?us-ascii?Q?sqbTz+8WbspjUudGqa+Q7q2mSK6Ue+LUrN7uAiTfbDPVaC8lenJcZGEvRkaA?=
 =?us-ascii?Q?pY8GQGMugOSl9I2X0blT6b5bpRHr+z9a/76oEPTMx2jMVimAvpLdpngZ46fW?=
 =?us-ascii?Q?JqzRqPCiW1C/KVIsWEKHg+jkyWlpbQfik+r04EF4ygRuBHXWy95KQ0MZPVWr?=
 =?us-ascii?Q?pkNPD9KLtiD7SHOsa6CWqs/mw1gZGzvg714WWgan1jWZLoe8oJvvpHxOh204?=
 =?us-ascii?Q?V3rfVeNXCyqmWi3m6dbyOCwaPLx1waxnfqliG03szu4IhFQESo0FvZUcO6q+?=
 =?us-ascii?Q?IrTOp55oVf7fN0ayWCMNAThfE8li8+LLRrFMM0BkscGJP3ULhirC594GbgNR?=
 =?us-ascii?Q?rOi187PZzxzDZsK1/BLHRLgAJvVB4rEEQN6zAEJzbCO9ql7G0VeY+4EDF+tp?=
 =?us-ascii?Q?qsZzaG03ETIgrzRWFxcD1ps3v8Jp/dJUnvL7Dprq0YBtD0PkBTBCcll4/LgE?=
 =?us-ascii?Q?hdYLwj73uHs6erMp/4Ra8gawhyUg51NBBvMuxNusRAXUSGxw7XlSrCdU8dhh?=
 =?us-ascii?Q?tWi7HGfH4qQQrjSqmLF4uYzKgSNI/I630tIUfHyDto75wMsjKMcNnpxt3P4Z?=
 =?us-ascii?Q?JcpwQyOi2xPkanmhAsIcgMDQCHEuKxgE5gUrYAMJ8DAtOea44iaFpfkbEolu?=
 =?us-ascii?Q?TMvTtIOkHDVXxFncmSOhlGZmGn91laLnHtE+2BGlMBNubh188Mmz8rj3X+T2?=
 =?us-ascii?Q?XQG4oV4CsGm5E/0zDVOIE3LaWNFsqkfgA+8BJ43SWoJDvXRApPZeDV2Hbh3o?=
 =?us-ascii?Q?7g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hFF2+bdifrLywT+lt5HGMkTLrjPHNYSDnkFcNIerUuRlCTbcT94plCXOMN7/fsPpYzFEMXrwC7W6xvXAEBQwz+5OVSBlVqzFr1a50+GDQDI7gUW4y6Ygob8xYjCA3WH4mQH3Uvk4D0i7hJPaY+VdKg5+XJyVCnJCJxLZ2F959eOkx9BLjlakS5FMoBHlzwIZ1/LgCFDgNWn5qlxFQv4as0lg2aVSWhuI/hZb3RQ8fAVw7TBoS2YxOK2URKSafoWL38Mj/05oSR93kJyECUEswJanlB78z7nIJJXXwqhDUIyHUrz/pgJ4gTyVpsxwSCBbH91q2rUlju8noCeDMWGo+XfJGbzMgQky23ODa41cliKC8o6/NunPNAT00kHZLeLv8eL4LCFqK3PdqtBUB/ZCUkvfY58vclVreuuSdqCrLDJkL5SC2GgInMaIJkB5S+4cDjbfVOKFQygqAbCxJGc2DNfvvjwv0JWU06pM9ualGf92HqD7GuILpY+LhPABXT17sgmTxuuW5ebIS9+t7bCsP4MhOI7cxULR9BTmbo0xDDiFcl+FeHCfA4we5iZe+Rtrd+5epYzbBqc7QlJEPL8ZAKX0DCdH0o73+mwcwhHqY/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71f8e9de-13f1-406e-99c6-08de17138bee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2025 17:49:45.3324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RX0Rr97UjNBrVUX6PnfZO5Qr9lhnEFMjadcRacP9kbJyXSSZkpTdMO9FFVcG79sdsztNQUQlNoghm5JaJ48mYyzS3DHtUzKykuibCZOOZHA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4298
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-29_07,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2510290142
X-Authority-Analysis: v=2.4 cv=Y4b1cxeN c=1 sm=1 tr=0 ts=690253c2 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=IW01juKAgdGzpw-y0VQA:9 cc=ntf awl=host:13657
X-Proofpoint-GUID: pfuidtylRpKzobOh2GSLW2f5d08J4P1G
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI5MDAyOCBTYWx0ZWRfX/NvTTyjpozVR
 OVesxNhCd1ryfytB0g5Xb+KnzF+5Wg7QWP+Kc8+n/K3aeRcIzqYGyy2W/lasQqVVRrQLoQSFolx
 MSc/uKvQXh1AkNlnkSMlzWlIbmB9Qi2j0oSia5OMUAIt332EsUyyLd5yBJ94bYPtE1e0IssdjB9
 Rq5C0mINUMbpLeRJBFf1kzSjU7eWVSq0DZFkLF1wvV/cfhZOgLvntukKIKTJPybzgqowUQRlsEX
 f5Oqx7CTtb/7o8UplmVD7yl+q3jaugiD1UNoFcUY4JyVHwx1dIX3sBuwkKeByKL/5S3XIX6X2tk
 ib0oG85gNy2d7/4JI1/V/wDGOuJHMfXhsaNEpVMsWV3aFhFoqaBhSJMBX6iULybgOhTR8t/poXJ
 empOB/MYDnl6/sy6gvUWIX9ZfXpTLoRydH87+s+aFzqnWGpCaPk=
X-Proofpoint-ORIG-GUID: pfuidtylRpKzobOh2GSLW2f5d08J4P1G
X-Rspam-User: 
X-Rspamd-Queue-Id: C6EC5100003
X-Rspamd-Server: rspam02
X-Stat-Signature: yt3u65uf3atdtj9arj38hwtr14hinikx
X-HE-Tag: 1761760198-767887
X-HE-Meta: U2FsdGVkX1/En3STELJWnwOoLFKFdyugBSGBFKOy9fXNOEnUm79e4CHg3yKessd6CsqRETvXwinNZw+a+KSsjj1mDjjJE0SHwdR1bycOU+NEOoRnruatXm7Y/wY5EZkBHNhx1OxabS41NHoeqPkspKBtLb7xa9hTKEsY5bgNxZyFNRFlR+VOmQRqDxU9VGJ0dlrEoz1dD/rm5iE9yhrzWqLj2pAMRENu3wVpT8CtYIpKylaL35z76EPEyXPQlDz/6Xez7E+KG1H9chNW7jYLQDFp1Khhlmu3gNCWTKd8S8ECNsvgp7UQjnbDqo0nYgbPDm7PpPwdlL46cptXKBiLUymcK1vsoku4XrgNEz/moBUjDkxqhllqpjpTR5puK0HIif1I5xCngVhpWFFei9Q0Gi1pp59LgiYjsyetbecfhv9vkzngjhR7YDfN25jGUBL+Y5MpB+/T/2HuvRtc6p07PWL7CFlPzTVSNPXU3O/MayGmsYVf1CDW/syDhZvalK48d5RUu6u8AnoamytYFw9eq31W5UFBU4//4nhITK2LfgRFE5LTZ/Klzka+vHPAud+Jwi2WccikAPIUhNmwCDhzAX6Sn2CC/4+9EIR0rNG+QrO7rcufFNKlWV383+Nz8pOBZvpYJqvEVcCKUBbz6qzFVqJScHm4hAYEbQxakdqer1oobxrBfp+Oky9cqV+i9VWliVbkBOuY1vkaL0V+2pKYi1OOymhc7yYxrF3MrHLNG4AdXQKIdSOBfK/k6d3lWweFzcYmt6mUAbIZ3KBgfu5Y2Ye7cFylSSGuOoOM2hLN/2XuvORxEtIospu5r7nondKTEdbCpalrDmlafqmdXS1P8Jwhac1jXbPSEXDaGVFqsLLKQeX2XjqP1dLlOT4z8miR8ve5GrSmRkGlwb5gkBRarU63fapOLGmwXVfEEadIoZL3Es9sW7gZ7d/0uBcEXoqOuoBZC2xIkEzGqGP0+nR
 3EmTrXUo
 LXPR9SBPW5W/JAPA6kkOhfyslgyPgNIWHDGHFHm6s7PsYta/OPOeHPUOLeg+UHwf6fz5HLO8xtGjVVOU9lII7cwVGCTszTqSyUOAe8A3W2QMPUK53BrWBdQhztl+soZgb+q96QAmPIZ6cSSC2nvH3UoD56fuqVbrEd8Crr/P264NzOaGxOKkpHW6dDbXdX2gDTkBOk0lu8spd6dPNICOAG0VjiQHfoGys4y4LKXtoyX4emvckxw7wZw1INNjSdP3VcMiV+n2mMVEqtDstCDY6CCUHJqCogG9YWZ6ApuYud7mUFl2ntrMOQfQ/YqWePpey9rMwMua7d+fEeWn8SpE5fRUrDzkfFZXuv2NfBRAwHk+oOwcb7xcPl3wNj+B3z8XZ0ka6slbFpn94/yR/lkq45hgdNfuYihIft5rjSCvHZO8ZQMlMn1w9rFPtRFfR5YH2Kh7eT9WNwxG4kjMvt7HJw+4EA1n+PeNEKRvY/pMN3pbJTcnm93C/6xUJT2VMJ1xSF3/t3bl/RqONyyn9unJCumI7aAheRf/2JtKDv6z6B6EXk7A/Ae9ZdqsBl/lhVqH1qoAxz+5jfIJYF6Oojm7wZC52TlWbdqETMg5bC7UJc0PtOkDzV/coPknbnDms+dZJ4XDIO1UffCZJ/YX84Qw42s4HjbyGslgCPJ1r2mLKsF0wNJDUa+du22MJKAKAaL41Bf2wSv6iDDSOwXDXdFdvRDDkg7LiTuYV7EieIsoCxIFAfNe5S6KfrI+biw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The __mm_flags_set_word() function is slightly ambiguous - we use 'set' to
refer to setting individual bits (such as in mm_flags_set()) but here we
use it to refer to overwriting the value altogether.

Rename it to __mm_flags_overwrite_word() to eliniate this ambiguity.

We additionally simplify the functions, eliminating unnecessary
bitmap_xxx() operations (the compiler would have optimised these out but
it's worth being as clear as we can be here).

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mm_types.h | 14 +++++---------
 kernel/fork.c            |  4 ++--
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5021047485a9..b47bd829ec9d 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1289,15 +1289,13 @@ struct mm_struct {
 	unsigned long cpu_bitmap[];
 };
 
-/* Set the first system word of mm flags, non-atomically. */
-static inline void __mm_flags_set_word(struct mm_struct *mm, unsigned long value)
+/* Copy value to the first system word of mm flags, non-atomically. */
+static inline void __mm_flags_overwrite_word(struct mm_struct *mm, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(&mm->flags, __mm_flags);
-
-	bitmap_copy(bitmap, &value, BITS_PER_LONG);
+	*ACCESS_PRIVATE(&mm->flags, __mm_flags) = value;
 }
 
-/* Obtain a read-only view of the bitmap. */
+/* Obtain a read-only view of the mm flags bitmap. */
 static inline const unsigned long *__mm_flags_get_bitmap(const struct mm_struct *mm)
 {
 	return (const unsigned long *)ACCESS_PRIVATE(&mm->flags, __mm_flags);
@@ -1306,9 +1304,7 @@ static inline const unsigned long *__mm_flags_get_bitmap(const struct mm_struct
 /* Read the first system word of mm flags, non-atomically. */
 static inline unsigned long __mm_flags_get_word(const struct mm_struct *mm)
 {
-	const unsigned long *bitmap = __mm_flags_get_bitmap(mm);
-
-	return bitmap_read(bitmap, 0, BITS_PER_LONG);
+	return *__mm_flags_get_bitmap(mm);
 }
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index dd0bb5fe4305..5e3309a2332c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1061,10 +1061,10 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 	if (current->mm) {
 		unsigned long flags = __mm_flags_get_word(current->mm);
 
-		__mm_flags_set_word(mm, mmf_init_legacy_flags(flags));
+		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
 	} else {
-		__mm_flags_set_word(mm, default_dump_filter);
+		__mm_flags_overwrite_word(mm, default_dump_filter);
 		mm->def_flags = 0;
 	}
 
-- 
2.51.0


