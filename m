Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2581FC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 02:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B9F6B007B; Sun,  3 Aug 2025 22:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5CA6B0088; Sun,  3 Aug 2025 22:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F2A6B0089; Sun,  3 Aug 2025 22:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F0566B007B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 22:25:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBD0EC0C46
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:25:39 +0000 (UTC)
X-FDA: 83737483998.22.1AD64CC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5DF9BA000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 02:25:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hr8kGHRx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b8cQ8s3G;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754274336; a=rsa-sha256;
	cv=pass;
	b=YYlL2tUiP+45WdJIaFRlWF3n9cobXECMpG+MbEqXMnre76/txb1mm1G0x6ToelmCcJR/Ss
	IAieujRGBfuGStKYWELaOMDSXtKkeEPU1YhUBLK3W2tUksm9qb+VtzUhkLsnVwcAnRmwa4
	9ZkbAnNyXeh8NqaVA5rYqtY5dUMZTC8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Hr8kGHRx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=b8cQ8s3G;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754274336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+c0JXe0JTDR1FtnKYhx2NsEgqnYHBfpYalBbdx8D5s=;
	b=bxkZsXVwoW58k94L8SBiDvP1dVPGxablSk1AvJI6xIC2XjyzypsenMbRychk0CZ1tmTljc
	XUNKOL7a/lpgShXCCoUK2cO9iaMSIjIQhm5M+VzmTUHkPLVd+7RBZkLmvArw/esGus0y2t
	rrxOam4lsikpzdu8n7JQU634ENIPzNY=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 573Nl6Je008635;
	Mon, 4 Aug 2025 02:25:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=t+c0JXe0JTDR1FtnKY
	hx2NsEgqnYHBfpYalBbdx8D5s=; b=Hr8kGHRx/YUScWMac1+5AH0clATFb90awL
	6JjfBbiY1M/18Sj/3yD/A0mpLNqBdJH0+T0MNcjWMyHLsg1cN21EHFCtB7e/Gjtt
	T10lmA+XRiv5JWOVIvQLDqISOxFPUGe7YbvVVT4Tg+FVnnPUp581vMMUCyeCAU22
	grnDZZvI7xyGDdoSJmIt9hYocg9xwUqM32NkDsFGxjGMnhKsmQr/aGeJGRwdGW/x
	jC/RHIM+NPJO2+L7n6a3lfASA5QoMBduKNQ2r21uFMZIIc5BabkwvRsb67zVN+Wf
	SfEt1oy04bTckCrp9i29D4hbg1I61LUZ6dm+Aojzak9fmhZ0o6Fw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4899kf9t38-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 02:25:33 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 573Nb0LI013595;
	Mon, 4 Aug 2025 02:25:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2075.outbound.protection.outlook.com [40.107.223.75])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48a7mqupr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 02:25:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fZ891KTcKrAO5bzrsY1ryyaDt0bgun5a7z0vEzd35myoLNKDrJLWeNUvWay60T2f2z3VRZpXcPaP02bKhOlGMwqYnrbv+ODn+31aCdLOPtdKsGeS/UhwTEFDrhjXIUo90QzQw/qdolAv7k2h1zCdbZQNfAurFEMqtUnq0x+j6/05O7pGZrpESor7HnYxL3ATbuRbUMaeLq07sYonEyWlQiStmT2z+lWm8DboqExGEgbCOWflsPO12qZ9W3ZCzR9LJSY/NoHhTYm4f0/vgpNzycFZJf2jmlgUUUvc6PvZL76CkH3GNBlVDprjDnpu4/T7ZxUWZ5lxZxeGowru6+CyPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t+c0JXe0JTDR1FtnKYhx2NsEgqnYHBfpYalBbdx8D5s=;
 b=ejtl/mKkljwfV3Ie9Kg89ui1pzSaTKFqfbvXn8T3TtWPOi4c7BdwNuvwsf+oY0beV7jC6mD8aCw+jPulbNq9TxFlqWc0Q88u8VM5/dzF5ZZ1VV5bhERRnZfPps/JfKjfPjwrYLSsCh0EkFJpEjJ696MnF9FHmE1f7zLgkggc1xYCQaPYe+uhdjTwuwdqhP8IViOXveoLWfzoahJmEVhFf3HsLLhUNtpeDRJaJPa1XleoW1QkQC3nx6GhnIG/RRlScQd4iq4m34Ia3L6vzcJTOfkfshVQvJkAVe0UvY/j1Ibws3e2qniD7U4uu8GZms+dCZw76EFkyHcR3TTmp5hPIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+c0JXe0JTDR1FtnKYhx2NsEgqnYHBfpYalBbdx8D5s=;
 b=b8cQ8s3GjfSya7j1aAlA8rF9r/yMdESzr94WHTMbWsom5Z+4aZ/Q9JwSUWmlqhQtPe6Y2p3ani1lHJOxfey8lnoUx7NNztqZ+QWmoYvz3emDTDQ1ZptGPLhv+IJ0i6IwHBgvXLE29RDDX6zlRfF7bOx2Ad8luQtKaww6GJ0CqMw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB4833.namprd10.prod.outlook.com (2603:10b6:208:333::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Mon, 4 Aug
 2025 02:25:29 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8989.018; Mon, 4 Aug 2025
 02:25:29 +0000
Date: Mon, 4 Aug 2025 11:25:23 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Li Qiong <liqiong@nfschina.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v5] mm/slub: avoid accessing metadata when pointer is
 invalid in object_err()
Message-ID: <aJAaE9Bqb3eSHBX9@hyeyoo>
References: <20250804014626.134396-1-liqiong@nfschina.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250804014626.134396-1-liqiong@nfschina.com>
X-ClientProxiedBy: SE2P216CA0146.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::6) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB4833:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bfdfc99-b423-4f87-9584-08ddd2fe2dc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/LD5zTa23CaIjpolfTNNaIFTP4co7pTI3YldmdlHyIXiIXHvAWTgKwFftqzO?=
 =?us-ascii?Q?86mOgXajAlUlAyE1xn6GLtqB4q1ZIr/A3298v6ng1TUpq0sxXU2xRaHOUm+9?=
 =?us-ascii?Q?jZF3fWe7yxHYgorJyORAAoCykxU2mtqRWFAW4RHM52Gvyom9hSs1zCvhvOiU?=
 =?us-ascii?Q?dIQGZ7sIg8YllbMkg2CxTX2mJXcP+1yypnw7tgApgvRVK+7yiXfnLYUY2ANo?=
 =?us-ascii?Q?ISq+G+Qq+pZNrKklK724EsS2AjZVJNpH39WFoGwFHtguhADwWqwz83KEau0N?=
 =?us-ascii?Q?RJC/FukMkf7IxJ3Y3U86XxPGquGs1LRgDA2IIqzD5vNgqZQZqPCe+lIiBzZ0?=
 =?us-ascii?Q?N2mkovL6/vSBFVzYfLpaT9v42vl8V/x0RmBbI/a3vefjSiwOl2vnVd2U2ktl?=
 =?us-ascii?Q?JjLM8DZpg4IsCBVFluBxmeKEYtgTHU3eGspa8p+kJvXXIpPeeJYnC/vm41ru?=
 =?us-ascii?Q?Ntz58yPDIDGIguigRKuPm+DamK5CeO87qgEi7nQpFsQF/YC9ZI4TlpzxHoBa?=
 =?us-ascii?Q?L9o9QHzDfvnbWaEpwVvP6RKTO7OJ7cXSt34plUiaFcbe67BtEsIVbKZJFajY?=
 =?us-ascii?Q?YBeX6bata/mqXrZNi3EQ7pkHJRhsj+FVcn9b05tAo5UFouiECo35/+lLrTn7?=
 =?us-ascii?Q?3UlTlT+ZT9+L6DJn8dq1r0Ce0wHreCyRSDpnt1PFqEYHgRlNYcueTShQRiuP?=
 =?us-ascii?Q?bE0aFJyjAxW/5azMt4KJVUWSl7zRoVo77xIafIyjxCoehZ1wY4hKbq//77BP?=
 =?us-ascii?Q?iv0AGFC070N4+mXMxwGzNLuPZZ1nKkwTLcXbiHSoASEMT9GK/vV3M9O/nsB7?=
 =?us-ascii?Q?ZCzJh4xvomPxzM18OUSvMulUJEWH96T+MAkBjRHKwOnE1gX3KJ/iYxe95zzg?=
 =?us-ascii?Q?wvLJ3Tl80TsMksOANPYALdc0w0sDXE1pg6me64mjCDrYpaM995r7SQ/JG7NR?=
 =?us-ascii?Q?kgNDCxmF+mmwKkc1dhaah/dwIX0OWHNr1+xVTNfkbVEj0bGtqtDuSmA4gkR6?=
 =?us-ascii?Q?tzlgRR/VXsC/FpJrwl23/j/VfitJMrqahlurIy2a/4cHO+I7DKL4uD6QTLP/?=
 =?us-ascii?Q?Ezrcuy82FVXSW9l4HH5QUq5hXqT3qfoYmK55WonqwBpJ/1SdzApE0HP1jqYp?=
 =?us-ascii?Q?M1+cQA0o4xSF9RdyChzAc4Pahb76BJyPG9r1m1VQJDnvJO2YRt48x5LM4lLD?=
 =?us-ascii?Q?aXsr5AF08A+38IBCU7Yw/a2ANUoJ/BULI/kcgYEAidr63NzGm9Jq1vZ+ykv0?=
 =?us-ascii?Q?zSeV/zm8Ao2AbWRxqeBYiK5vbE4jiDfogbp/OVdnSmiEluZJv+zcrj2IqjfM?=
 =?us-ascii?Q?vmGAfYhMld1Snzi2xERdhyK9pHJjzTDdMbVd+YjI0iD78ASEzuCxw/QSsaKH?=
 =?us-ascii?Q?vISuKSOVo8C1H+nEAxbw4vzgD2Ppn09uJyxI6leKiqe/pWUttQCW/I6JwmEF?=
 =?us-ascii?Q?q5VoteAi7eA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DJLTAwcgKmEBNPev6y5vAfo6KNjSyllUlmKX/enHNqwEx/w/GfOnf7XVGP1F?=
 =?us-ascii?Q?j9tOOy9VNBUZoUytcW4WMl5V7OYOtQCgKjr6/lyVFwS9Nq93ZPujk4jvAjwt?=
 =?us-ascii?Q?Nj6HT8e0W6lQN1FGIx5owZSnmExjoFvi7CeCoa/XwyPjmF3KCdnGiLxFDOjS?=
 =?us-ascii?Q?unqTeJY5/PZUqyVlV9Is6HfuXwcSSIn0MTuddMfuUxPsr7BaG/lFkSXcjrAZ?=
 =?us-ascii?Q?M3rKeDEgh44iOe+t/8VdmHPpCqAMAFEz3dwm0RzGdQQUISoNyWQcqbp4wE1f?=
 =?us-ascii?Q?IRKpwA3YMmy7WsMY7Lno+M6p5QEn6BPFAyIVG1TT+M3OFWNQo7/k11oHwUBf?=
 =?us-ascii?Q?nZlKea/ESdoBXAYKu3L6RYn9J6AIoi4aQNRS6hY0k3CJrTMLMdO+t7WJ+b+n?=
 =?us-ascii?Q?34XNZWZvfyU2UuWP4lodP3ltOi+32lzmUXbfer7+fnBu/CNvJ/pjiZlkXlYd?=
 =?us-ascii?Q?/9fkvGHIQxdL2xEMpaUVwJ1eS804ssthVoVl2e16VJ/1aDpVe1s5c67K3VZ+?=
 =?us-ascii?Q?vF9sQhCdEbne+qLOl/+bIN1G4uGpJ5UE1vX+h9JNps6Hzt0zamI9docqGS2X?=
 =?us-ascii?Q?bfAt7c2p7gm7Aqznf1mPR4Vog5Jpsz3/eOTBA9LYJT/E/OhL1RQmvuj8k6ht?=
 =?us-ascii?Q?a8l6r+0JPDrGoYiT0gfxlZoHJT5SHi/LbwJkrmhTOPmI1o1AcYvsU/1zWJAs?=
 =?us-ascii?Q?4G6ahMLqut0HXAVS3U9P1kT0DQNpEvuBIHccGUCr4/3+hhCXaf8dVPXDGz4Z?=
 =?us-ascii?Q?gMo2IcGKQOMa3d3HU1J6Jhz8cjoJaKdVX3fbIXCyZAFRvJ9m6JL+bu4r/Ixd?=
 =?us-ascii?Q?pSgSDlw0OqbMjUtHR1B78mOUO2w8thqEA4udGnZWDWWcfimjCw8g6cfR/0Wi?=
 =?us-ascii?Q?bv7zQFXmCD1Ie/SSVW6YfL4sEPN0w4YjgRNetVei840kAu927Y8IO+hQ38bH?=
 =?us-ascii?Q?bI+fn33KpOxxYjRQGQo1/mkOLgr11BojLqO2BONBRgN3457MJUwC8n877MwS?=
 =?us-ascii?Q?9n/qtZfMxDIZ12jMrSdN6oFT95aQ8/nOemj6/E3Te33CM2J0GCL9JyEWI6rQ?=
 =?us-ascii?Q?bV5dmmZwCHmhno6C+0IPdwgEsSvT/sOgPmp2idKsluxGC/Lg+TnaM3on41ZO?=
 =?us-ascii?Q?uUX8G+E4RjLXEOKwHic71gIKQ4i/iO1GjakTP3E8XjJBFisVVs3YpHETR/yQ?=
 =?us-ascii?Q?fKHGHemjxwV3TdIJL58L3KXPO80ORe1HChHMi2gCocaXJnQ/jrHhKkUb2Mhw?=
 =?us-ascii?Q?zyoEwyH43oMK5ZrLDpV9mRpsMj/nPLGbzTKu7FiSQ5MAhQwp0JR/RIZ73+EO?=
 =?us-ascii?Q?gyKs+0ECCmxBvJt9C1Okf5u0e6Hdsp5itnZSUhrxZefD2+i+9nA55BkKh1sE?=
 =?us-ascii?Q?q+MVnpxAshoOGmnQ0uhoA1VRGFfm8pzZWoZWPoeJBYAuQ21ECoM07gPN3vY7?=
 =?us-ascii?Q?/Gq7Q9w484EqG+uZcYcmMxDahgDEDLC4lGOW0Pp+jK+tOEwYEIVjdSQwEFX4?=
 =?us-ascii?Q?Nw1kDl5ozRDvuegJqw9DXJWnn/7elKj2SddzqxQp4vgx7c5Fu5HzhkuiY6V5?=
 =?us-ascii?Q?kBYwb9DdvuSYolQgPAdb+zvdyZY8I80UR4SFcbwY?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KvrM9pvLUAL73EAi4Gp29bgtLKhgDnf0R/DGjcdI0ChK3uY6EBPUVJ8dFmP62AC4zq4yqq/T54DBVmJSS4wGHWYG/aRsixuEXVqwpOxN2EXg2qgqmLCjKjOn5WR2VNKrnqMMB20POezzXwp0c968Zewy1OYzN2d6LBSCPyajlLX/ewKF0N8ubIPkwM4AQt4jtVunwEppan6iXFul1PG7OFoV8s/jLBRCpJH2SAwVvy/FavhMpRl+YLtD0vHfm/Xawki4SN7S7oagYDC2OQKUDzjjKFgSnQfCP3KDza95Gm3C0za/h+Fa2qVhAFnyoYLW+rRzG4KXenyO4xpdBKdlD7qH+PJYiWN4gucIkQXw3SYehZsyWhqYlY7ReRvzC+jhuPF2q50iZSD6qyzDrMrydn+qd7yb8TILBDEpoCYoLQ0f0mG6Q3IRDrE7q7RADO7BHtfwkQ5v8CIb29mZeCwHfpKTkORT+djx4HfMSSP2UEYOr63d5pm40Yt5C/nkyw66Y1DkeiO09w5oK2AzArz2Sl0045NYk3Kaxx0ch/ASKaIV7XNyu3GDCVk8Ml/XJ8G3S/QZIqK9Eai6mJRENsrb3IXh2zTMgPH6gjvlseLidMg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bfdfc99-b423-4f87-9584-08ddd2fe2dc1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 02:25:28.9753
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nNwdAx8I/7fei4BOPox6yWrYsJp9o94YNujwUIk4siNjXMY36vzoZGpCVDD7HL+Mtdaeac3TaJ4igkurO1iP+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4833
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_01,2025-08-01_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040011
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDAxMCBTYWx0ZWRfX49s3MK90NY4M
 ANZigy6Y2zvQO/E4dFm5LwdNE8j/2leIxsq3mUAM2JTRZKqhMdeMmialP63ERdqz+6UY+8we2AV
 SRqhu1S3cpjoSHF5tcZNsUR4Y+we5t3N/tEVDMGjqKFyDCGWXbP62RWOr2DzJFhUslF5XalaXdg
 iv7+sOHgU0Q40nm9J3koxnkfbuC0Ahbw3eoC2RRavxF6Bs1vcfXUN1/dZw1L4M6sH9S4qDFycsh
 ME/dW1hpKiY8U31SGS+n4RY1JUtcJKirh1HOaAxUnA8dmPl2fQY4hC6A5FvLwRNEIGnBXMhNAAi
 wzQTn+arsy7OpUzG/W0tJuI5Vnz/w7MB8LMLNywVQ4xPDiSP474z59T5eR0Idu2yb7hQeNSRqIl
 3tsGBHGsMLdsK4VZiOtH5lJyR8o2rv6e1EDJKrzCsxWPIn5qOTunFL57jr7F4C3E/xzYUQRj
X-Proofpoint-GUID: kZlokjieP7zj32KCyq86Oh_zCqMWaNT1
X-Proofpoint-ORIG-GUID: kZlokjieP7zj32KCyq86Oh_zCqMWaNT1
X-Authority-Analysis: v=2.4 cv=VMvdn8PX c=1 sm=1 tr=0 ts=68901a1d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=SlVAvriTAAAA:8
 a=yPCof4ZbAAAA:8 a=95r7aR4FhjnzYnCyAq4A:9 a=CjuIK1q_8ugA:10
 a=qesGs21RGGeVIEdTuB6w:22 cc=ntf awl=host:13596
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5DF9BA000C
X-Stat-Signature: pites7zyjwgpbox3czpzr76c9dan6ykn
X-Rspam-User: 
X-HE-Tag: 1754274336-373390
X-HE-Meta: U2FsdGVkX1+fv9cUyv9EWTS/yOSms6oYsNYjp/qtTqE8poRnNaeDmS8SEVHQaC2ycG8Gsh5mgeaGudpBqqof7K7lXlxRW7tW98M/+nPMGqzyog1iURMFtjs9UvHEebEHjLwkeN/lgg6You91djdbRB2WIEP3D9NKGdW/i+lkD+L2se3Tn+l/PUmo7aabMLfdAD3BAurUX8Wd0sv826LeHsqakOABVsnbkJmqLw4sEqMZQEi5z0Sbl5F8DQVQMRHbVr8e+WmTgYtNHGTD8jXtvdesHHowql7YEO/1BUvVt3TFn9pjQvESkdsZawbl+HLGhQIrdINoSzx9zQTBIL4f+b79exU3v+usGiH99kBeMn33Sb0RGPpgTKD7gWbnV7nXYmT2cagYQxxqI1mEOAySZBpTOdWYi/1Ng8EBcsRF7Widhnqq7YpKrvJBVHH2nt3wgPLNDFuekbnvU234hBWxHYhiExerA2DCHlc0gSdR5YLztNvVilnyKHCDrLgm/9INm+g+Mg4DQzNe5JqF+0Jd6/C98r8BDirtkXH71cvf/rhCRiVPBIbW2vTSvcHZWjupXvAwPzw8eTVUUvwZ/kC8uCCajpK+ABk9rwwuktJDxQFU8qhr59+RD+sR8Zbt4wNDcvbC9l6tdv06TvzoJodQDiBXIHrvkbPvTyZLlIKWd6b/u8mU+TNOWXe1b+CqlcXnnnSr/34ivduwmx1o5GsDO0g1s1aGMpKrPfyrto9/qlQanRKQC18bp89VhWw4dP2DW1novy2Uuxk9rtGXEWLINUXhIfhMRl53l9L1WT8E4NS+jLPgVuC+Ua4vOhsQSB687n7/fAL+rgE2b89IZh7Odh/2AWdYeOyyrYwVEvtLV/bBQ2Fh4ncAXy+HHfqWGiStEfhCldWd4uXLF5Ml6RlMu5Jc9KdW8X5KRZhm3hvDnuN1ivQ8xOpMOhTFGd4zZm2eS5OwS1bFkE/ReIIoTme
 ixXiZMR8
 qZinf2Xs3ZPlX1FBPjvyfLrfZ/QI4zNOcpRx/aE59LzP2PuywRxGf75YJDt17COHlKZFmjPik0SjOjhsslAdAdIVq3TJihIGcvH6BdqimYSuQc6Ex0JuXVUSNq8xBhsjXHOApxYyr8Kd+iGUmsR3+YbuqlWb4q3m3GtBy1n6y1Yiie6iDi/sWvGlgI686wx0iFqN8dNMRfe0rcXTBBz8VN3q3C8//iMJL3LeqTN48AHTTr1MA8IW5pYRpfc6IOOWTq1BpxCc2MeUJ/yyA3pw02pd6IMP9Q1inAfITDMlDBM33bbC3EQEZ8FJpUHaVFy+0y5IiAMlzxeEIenp7Z4cuJJh2BQleZvC72QdJAITX4bED2n4LCPu2tUaI4u1xtR/KzflHSz86cn6ReIo3jkpJtB78Bnzt98Jg/YmSI3nL15x43EgYJw09wT+OQXu38+/72e9UN2tio+D3kJloskGfuYFv7T411rSC2ItOwsqkfdQZP+A1LhUXKB4xEKTHzNd7FY7xNRjo9MQmsVRQWK/Ae62BlM/aRQnsiP9KPz6cAFdew7F8k0N4zxEwanZOvOw3WeC+Jl3fLwDvx9MUVn8ocQDWNuPSUDw+ElgHTmX2IjLI31RW6vx7yVeXNrmsrJH1tLVYVxWcDUgv9icvWrRMLKkrG6kgNuDhuk3CjG9pvHhWsWCjLZ/Te+vBJDHQjw1DyphzqJi05VHqv+DYIlELqc16ARJkW0D411hcX69rhfxFSI/Gc6fb2tg+kq1kMhrMHXbPSwEYtkG039Wr8NOUJcNOBqN9ygnQ/qO8iXwIdqNjOl6Ojb8ON8G7ZLl1FDqWrm7uVqUXi2J5C+vCqZ2YCX7D5POOFfCAXXrTdnjhXQCj5t4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 09:46:25AM +0800, Li Qiong wrote:
> object_err() reports details of an object for further debugging, such as
> the freelist pointer, redzone, etc. However, if the pointer is invalid,
> attempting to access object metadata can lead to a crash since it does
> not point to a valid object.
> 
> In case check_valid_pointer() returns false for the pointer, only print
> the pointer value and skip accessing metadata.
> 
> Fixes: 81819f0fc828 ("SLUB core")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
> v2:
> - rephrase the commit message, add comment for object_err().
> v3:
> - check object pointer in object_err().
> v4:
> - restore changes in alloc_consistency_checks().
> v5:
> - rephrase message, fix code style.
> ---

Looks good to me,
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

>  mm/slub.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 31e11ef256f9..b3eff1476c85 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1104,7 +1104,12 @@ static void object_err(struct kmem_cache *s, struct slab *slab,
>  		return;
>  
>  	slab_bug(s, reason);
> -	print_trailer(s, slab, object);
> +	if (!check_valid_pointer(s, slab, object)) {
> +		print_slab_info(slab);
> +		pr_err("Invalid pointer 0x%p\n", object);
> +	} else {
> +		print_trailer(s, slab, object);
> +	}
>  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>  
>  	WARN_ON(1);
> -- 
> 2.30.2

