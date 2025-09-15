Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A05CAC598
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 10:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0EF18E0005; Mon, 15 Sep 2025 06:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5C28E0001; Mon, 15 Sep 2025 06:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DADE78E0005; Mon, 15 Sep 2025 06:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C68AA8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 06:51:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 743F7C0538
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:51:54 +0000 (UTC)
X-FDA: 83891169348.05.D6CBA1D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 079171A000C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:51:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ibZQfB70;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CdiNkvfe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757933511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jeAiwwVLSOsc+G+CePI1AqJmKqNkm8dYmUOb+OaqyRg=;
	b=2X5xQ6IxjcGTOHIG8zEqOINdjsHz7Jlz4DUvH8sTTip8pXSiZX1v0LYOiUDbKvc/tL5rqR
	HiX1vvZVfsu7ndRHli9p5LaadqBZ+tP4lO8i5jYNgLnPlZFHPoMt9yfAoKiEQhKGkCzHxa
	vV2V8O91C/3B6hA1qBmsNBxwQykA2qM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757933511; a=rsa-sha256;
	cv=pass;
	b=CgW/3YDO9pnBdHh5/wv/GyXF/wadjCTBRD6wh80jnfhEwukFyAjEEP55jbHGv82gbg3Ncj
	toK5mMnYab3ZndcBAbEYIhvWznEkEupWi2nqY+Hw1vuPu4aBQ+YdKQuEGPNQYgJjUR3Rqa
	4+TJ1Tlb9QgR8mcKxvwLZ61lx0LUsmY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ibZQfB70;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CdiNkvfe;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58F6h3IL027827;
	Mon, 15 Sep 2025 10:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jeAiwwVLSOsc+G+CeP
	I1AqJmKqNkm8dYmUOb+OaqyRg=; b=ibZQfB70uBvtVFs5AclDCnkOopSnauTok4
	ivhrp0Sj6fdfW4WKi2PZ++HIHTkwiOyM1DwIDBykwN6ng7AZcpDyoxkZOHD3XYG3
	4IGqIJhqvjkgfcD7fg/8reE3RaXw2wm+kVPRefm18oI3a7peTTkt3LtAmVcU0a3P
	O5fLkAzKeyN6GOTM+RE7sLM4OPqs8SafphWpsiEp/MZ0TmEDfre5pbvV+t7pag1B
	tjj5FAQoTBu0BeWZXVggWHzE2+fOLPF2P6FYRIA14iUPena6KmGrMuh7RsOZwj2b
	8sn3icFRx1vZW1/yY+4puAnDOZNo0Wt2UBbPXIlemcg4R+RlJ6Jw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49515v22qt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:51:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FAgNXf015290;
	Mon, 15 Sep 2025 10:51:39 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013024.outbound.protection.outlook.com [40.107.201.24])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2h4fpn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 10:51:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DTzP8BXGJpXswMMaKlx+ZE4Xcb79ri13STfK/9D1hR5J2bnK3WyfpGXyxMvmv/5yVS4XxfE6TA+orXzEgHUy2q53tZk5ho7IpDKjHoU22APp3mH6zxrpHD2agEXPVHZjSFH8lJj22pqHiA9MMzBaffPvgO4YJ/AhFo9alaQObyKG7DAizu1m+G/cCO6eHNR18HzfyyIlgLOFb3V5UzZIm5KWHGfpLXVjnhW8DcYPkiwrcdn/k9PFAhYdZ2vwFSuF9mSbMSp1Cj5evIZY8JaKofghzY5vMlxpCwgv7DL1A64cjOTsBgVHdraeZp4X/WK0UdVxkoXNLapkjWveY5duBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeAiwwVLSOsc+G+CePI1AqJmKqNkm8dYmUOb+OaqyRg=;
 b=j+2YxbRVI309vC2/UvrGKfMQEOLozcxQCT8w0qLE0QlkUFqW8HDzFTLnPsIc86kO5D5w+BsqJr1QbJl+8JtX12hQI9qSg96FxRfLzoD0F3s2wDty+3tmTWRgLrcSNfnTvenE+B/CTkLYUcajHKUITWPN5forFeCJ4WOarUxdXvMY5KHQC8KquD8HlzaJRAvhxXX3+UkUg+EpxAp5MThTCl0Y94prwXpE3c2U5Vjef+ferZff0wTmCSnBDUQm+GN2Vt6ht/UY60vbag73XJMj4SD3NrNcPM5nzP1sM6tTcWkVqzepyZYhTx5MbHNLAiIgfcTwXTvKIdVwP59t1qL9Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeAiwwVLSOsc+G+CePI1AqJmKqNkm8dYmUOb+OaqyRg=;
 b=CdiNkvfeqH+7MLDTCLTraE166AS2qmaHM30JVk70JsYfBzOImPQJIGnOn8Xk4Y5DTLP4F21ZQ9KbfFAw6Dsup9UEzPn5T7ogwij9w2LmhqSxy4j7UQSNJ9RHR/Z5UanbQxIlVoOGLymhNtV7RaFioNPY3WZ0DXyDe4Fx4rWKVh4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB7189.namprd10.prod.outlook.com (2603:10b6:8:ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 15 Sep
 2025 10:51:37 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 10:51:37 +0000
Date: Mon, 15 Sep 2025 11:51:35 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Barry Song <21cnbao@gmail.com>,
        Nicolas Geoffray <ngeoffray@google.com>,
        Lokesh Gidra <lokeshgidra@google.com>,
        Harry Yoo <harry.yoo@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Linux-MM <linux-mm@kvack.org>, Kalesh Singh <kaleshsingh@google.com>,
        SeongJae Park <sj@kernel.org>, Barry Song <v-songbaohua@oppo.com>,
        Peter Xu <peterx@redhat.com>
Subject: Re: [DISCUSSION] anon_vma root lock contention and per anon_vma lock
Message-ID: <09d476bf-ddb3-42ba-814a-21308952a9b4@lucifer.local>
References: <CAGsJ_4x=YsQR=nNcHA-q=0vg0b7ok=81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com>
 <aMdVcH7KCXBvLtFP@casper.infradead.org>
 <CAGsJ_4xDRB_F-T42WnhqpmwLyiZRwLGqx9vDf_d5TFALsCRX4A@mail.gmail.com>
 <aMd-2argDQCHww_Q@casper.infradead.org>
 <b6d5c607-a9d9-4c1b-b4ac-41fcaa2e696d@lucifer.local>
 <88258e24-60d2-4068-8d26-bec51c94a650@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88258e24-60d2-4068-8d26-bec51c94a650@redhat.com>
X-ClientProxiedBy: LO4P265CA0004.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB7189:EE_
X-MS-Office365-Filtering-Correlation-Id: 86bd1012-dc1e-4320-e546-08ddf445d80b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6DPmD8pGIFBIJYuc1Q1HqT5BMB2H81S/FqOjpHSxMJL1Qwdr9ZZe7r5+cUCK?=
 =?us-ascii?Q?5z+gInVDhNxuCxk4O+rel4VU3PAcwF6zJ89w0jyVs5PQJk/DW1TQBVbA704q?=
 =?us-ascii?Q?Pdj8iAICR/7GnuzhyUNMOFLYbGnQtKqATT/BBE5fD9eDwIZpQEsPnqIITkOE?=
 =?us-ascii?Q?q2PL5ue8Hc7eJpvUf0THrhqKAYyiksXS+fhnlzHwm5O7GK0lU+q8DNlgDQw9?=
 =?us-ascii?Q?W5YXL/5ljHeaeP7EwG3evRLrRl2N0njwamS9e4kcxRkAlNsi7M1kZml2fHgr?=
 =?us-ascii?Q?sACkOYWj+iCW/U1loHD5SUTkNMAfdcpSwSyCMV17de/iteJvy7kAjX2OVIXN?=
 =?us-ascii?Q?uBYIR8riqB9Z9Nk42Ux1zIfV/+tnwypZu7xltmQ0kDvaEFmbdV74nCuGf1ji?=
 =?us-ascii?Q?fRJk1Ms+lZscHkMPjPOFM7B/W6M3I1S9oDXEfqPMykj2duvIWxn9aucKUHrD?=
 =?us-ascii?Q?4/aaTG/a5HqmVt2T+0+iOPJn8V09i7eKejQl1eXHNLxeGTZHMFIKiPJ5I/fE?=
 =?us-ascii?Q?L/u3OQST608nkI0R6A12Sc10/24mPDhp8wswvPYJpdD6uYZohmJZ/6yehvcA?=
 =?us-ascii?Q?jysYjtpASokN35+Uq4PJQipzj71dJO6riuUWDA3DFoQ3Vbye3wBziKjnrRJz?=
 =?us-ascii?Q?QdmF3m+kO4yBvC5S+q2LDGQj77rwWhbZiP6vQ5m8CecQVjeOhh7mlClXQGSU?=
 =?us-ascii?Q?sWxhPD5gWYvQnozGL1T4QeYolB8bzudruogozrRUdod1cFqoCP5tRhZ2zC+B?=
 =?us-ascii?Q?dx+b3hwgsY+mFwe02CE70BI4Jtg9c/6PuIem4OujcJ+VTakc4K/xtT1aH6A7?=
 =?us-ascii?Q?x6AsxcU8z0gZAgc4jHA/6LtblnQ1uDcmC1xryZrMlT499Qr2LlZ93qJFkaRi?=
 =?us-ascii?Q?7BAmnX+bxmujLG52Ko7F3R0Di4UeIif6SEb4u+wIN6hctaGYypHhmMad/wms?=
 =?us-ascii?Q?iUO2YSuKP88oT1OG/bbthzqR9MFrsAOQn5cfQPpuP1395uHn9FMBAhy/RQmc?=
 =?us-ascii?Q?i3pHSOra5TH56x1g8C94uv5EhAKwlGq2ndcqvxBhZWPQWHRs9qqz1VITIe6u?=
 =?us-ascii?Q?UYoMtb6cDxnEkIa9D/mk/24qdvTRanvpyDD27OAlFv1iYiYh+sS4JKm+U1BD?=
 =?us-ascii?Q?ZRhyP3sYs57ocydzNnWXhMQKkb4pKKK5FSOrdctScdNrt0iOkasy3Y51NPLk?=
 =?us-ascii?Q?RlXx3vFczXvmQB9rGZrK+SdWzCB9EgHAxOu8RkJgQB58ydwnU3P0N25/e84k?=
 =?us-ascii?Q?fN0J0fJ1MgI1rR7hel+owOPaVG0XbgsA8dowflEAXepIO+aFUyT7GeTwORxV?=
 =?us-ascii?Q?EWo3gGIZ+ldLa/eCQhENNpbezhxS8Ws6pHKmdAs3nqoSs8XIoL2KjaQ5fX5K?=
 =?us-ascii?Q?C7CRPegmeArMPEXDuRUanGt3Qazzdw1LwRhcrCDWXIfOmrVjdJwgRs1pOS7K?=
 =?us-ascii?Q?lUU8iX4mmwU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jABajsY3bhKbSPd31POlcbxv9m0BEJ1LT9D0xaSBNZMaN6IhWmmjaOxvzR9O?=
 =?us-ascii?Q?D3UdsvK+syOh/lnGEINqyTSpZ2Ad7amOAwoQPcn1qmEuNq5WxRl4tovufcEz?=
 =?us-ascii?Q?fYtqolq328002g0FSzizL/wlSbq1eOCQM0dem7OJqOAaV+eus83ps7A06Njs?=
 =?us-ascii?Q?Ln24cYOeusiAZ9hn021fuedZC8C5DMhZxekVxM7hf6gsH6FoaXRn0ArN/I2W?=
 =?us-ascii?Q?xUdedSOLK4pP2c0IBtSCsUWWpRFFMeMozFSZC6O2OUMePxC4bkVn7EdCWxY1?=
 =?us-ascii?Q?g94kJaljeBq5jiDlCvXnSfdl4J4HlDYcf7fh5nwjVZSJoBP/uMOBmtEO/yod?=
 =?us-ascii?Q?2jrxgQoTJKN54S2p1H/0mpWQh8Lz0+DRMfte0Vc5bUIms1hhgV2OZHZDquv/?=
 =?us-ascii?Q?AowGlXV7c2WlGp5sTiu9+bisQYq9LtwHPQUmyNZrF9lIT9Zxzbppm9dIU7dJ?=
 =?us-ascii?Q?+62xh72ALTa73rUGpoSB4p3FqA/JMH85VPO2HOP6VJoiWPNrEtIIUSE5D5Mm?=
 =?us-ascii?Q?fsLR1/AMiXFYn/p2cS71ZMaaAJkG5FopNikV40XPw+Zkcc+x+ovXrl52zd76?=
 =?us-ascii?Q?G8FhpMq2X0NBR+qdLoD8HzjjIiwwrusFh9nlh2LWHryib3YH3tMiF9Wefqd1?=
 =?us-ascii?Q?Zyt3q4jNGainwLZJqofupftxGCwM4hvPlH5omTTYGDssgO8Mgx7kaf48mgJt?=
 =?us-ascii?Q?2BGqkLLFJMmLweK9Aq/0rO2HMhqoqu4XUXeAAHrEETVYnCHVR8MWqG5PRjtG?=
 =?us-ascii?Q?KCljZm3XMdP8jyKNpQT83bQi+qLnjlakJqm1LgbjCc9GUhf9QiMIhWSQz+um?=
 =?us-ascii?Q?D8doTlkkbZyJkmkBQi+9oVcdsDgiLGHUED5jgX9d5NA4TouqcAXGz/m9ZA+T?=
 =?us-ascii?Q?0MeCw5PorlT+ThTyE0eqrSOiMs3kEl+/nLdSoVH1CEjx5KcSrpisObKcvo1M?=
 =?us-ascii?Q?PHd2If5/D/RNf1oovGewQLmRt9VJoijvD8UvDVzrAeTPTYvcor1mFSus0X/O?=
 =?us-ascii?Q?E6x470WrKg4w2pQf1XgGwVx1u+lPosF83oRITCAjDkGQsQ8OrPmca5Sdedw5?=
 =?us-ascii?Q?kLXxL2YQ7onV2VlJNvOlKVc0NOwZkN+iYb0N/YpG5g5jFBbMXd+8fYzTR114?=
 =?us-ascii?Q?vAtwoJCx0/qFjHoD5Ta00Um199PUhEjq45Ixhj9+5dmmYMb4+wZQXDb5cgUn?=
 =?us-ascii?Q?G4gczmZXAD3nHX55x4wArI4jlswlgxNR+uUoCpTqTxmZZ0SsYDKY0DVc8Wgx?=
 =?us-ascii?Q?U0h/duUgIq/Rtzvnq5LJG0e2telgPy8wq4//GAAX7tIM59p6xDy0lRH07vqO?=
 =?us-ascii?Q?RtZOB59CkQz+rMHvfhklchI+GsI76rcFxpoqF5d7rXyKOb7FHAjk25heCYul?=
 =?us-ascii?Q?bn4wBlbq+b2V0K6VwYYdTVs/CwOQfRgkJ1fGBiXaPCXVSHdi6UnFxqhC/HhU?=
 =?us-ascii?Q?+r05pgaXO5d9JZAR1kO0lmFz7OWbUjpBYkr/O/B93HUfn33ePXMg/v3hM6OL?=
 =?us-ascii?Q?S8wpV8x+z1413zwjKVflBJynh6a2RCuKnfYDlaklkViUISRbNTUyULeREHSq?=
 =?us-ascii?Q?Ym2HnuMDQXLLEs3JHqLcmHDhbYE1G3GHX/ZkQ6vA94HAwnqKi4Z1rZUni6XT?=
 =?us-ascii?Q?Rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2RaTIahj6qHxscjy36gMAKVgc0IUMf0dOVTYy2PWY+xx75CzcAq+YeM7vqOOlGGyG5TdqA9EgWgXWJo2ye/6h5mNiXp6TN4zNVbeiQ4AGnmzdnDfqSgrm7X5Ptnsosk4t+UjLpQOpRjINrd1/Q2+yRaPha5qs5LVm9SyM93YeBQaL3hjrS4DqzcKi4YxZB4BXhOhkXxyz92nYORDi2Un8PMop1singFF9ZQh9n5Ujmadfx8IVNuPBn4wL+HR6rgXD2JyLCigZrBVUoeEVpDwRgJoSBSd8bQjVjTokZ96QGUELBK1fzeMQY6ZLZcy+gP6d2lncU87rODIDCcAvlRAXgYSvNeiXXMgKsTTqelxzcAwpo+9qH4twDcDUlVWTfRj2zvLqKCnOw8tVkKFlke6GgkshXfmLUZefYmV/55nnqRNqWREN5+BRGoUK4n1wihjysyypMInPLkR2NC6344xIE2JvShH9wZwvMNPhMaGQQKlyIxn6EuNUt626jYJDz/jkEGzH60PIpv5dM2VzU6WopQenbSc1RF/9OD+fc9D+7N/l0JsjWrkWwg7F9Qbani/sfNpjK5a1HKA/v39egd9Q674KD7+uEHIinC0+0jvqn0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86bd1012-dc1e-4320-e546-08ddf445d80b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 10:51:37.1625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EKDRrflK+Cg82kV7Ns0B9yZzMNNuoULFKUWe/S1SLw1O5J2R+WFxuEXWty7G+yymWyh6/hLJymNph/FmviIM03wzvlFM7PlBC63/ncTwYow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7189
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_04,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150101
X-Proofpoint-GUID: N3Utw2S2ssJDlHluplJdHTvk2sBeHmYy
X-Authority-Analysis: v=2.4 cv=RtzFLDmK c=1 sm=1 tr=0 ts=68c7efbd b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=q1yNTglCYE-_cvBzoGcA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAzMyBTYWx0ZWRfX8shJTMn1lfsJ
 gJTTssRsjIgHLXErd7wakrBblRPDePFB6jKUg2eJcDV13Wq3TGZgKJig4JdIyKuTLopymrq+IMo
 A8NUh4abhCwHMU/thGnQvn/fKcGRDoAucSQYObRl3YjwBPM+MZgJwimrMMDRIw7XjSF6wQkBHhN
 7w8zJds3/jDCBS6QtheFSQJ5WFX8EQVOj9Wb0/jr4gwe9h/mjPwmbdZmf7eA9y9IsAJNVSXOJod
 G2LCFT/tK2Km5d3zz7hdL2T5cUUlr5Mn7v5scptZO0PPwffrrxARpZejX6M8VQnoUHv7ddkdUyr
 hxY+O9xoJOFLduaO8okOauiwXCr0OcmBhSyAyyr3oSocVUUdYlIpPjdtBYMm2GTzljA+RzwneZm
 Mvl/GiwCy7KjpS1uxJTdm+2WCWOIrQ==
X-Proofpoint-ORIG-GUID: N3Utw2S2ssJDlHluplJdHTvk2sBeHmYy
X-Stat-Signature: aqk5stob5i31wi1gdetx7f7yxr4qhpn8
X-Rspamd-Queue-Id: 079171A000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757933510-393820
X-HE-Meta: U2FsdGVkX19PYJlcpT/oAEMABMZkX2iaKCBMbYfErNOrk4aU7WUYFQtfCIA3hbHogpCel9NMpcdFOaiwSJrdgJsuKpYSGBjnmhoPk1xQXQuAaH86RmKvB1NknyyJ+rv/nYBYCplUJTJSSYqQAkQazls1d6KqEwJseYXRwpg3J5+Ifi8KKk3rV7+a25SO/X70scAqD6duTZJogkTy3+I6MnM3fHCviiwcuAJnbBsRZbZX9f9gqngGpLbxvU50ECM8g0PzbrV8LHxTPcGLiV+hCFieLAzdcKjCOtBy+y4+5kh3iZGVypLm+oIYAcG/7YaLmZB73NFwm+Aswxq4vOiuoNi70xw7xiLXCagFKHZPbAkhykPrbCf+CNFMnWCV8jfCX6CqANuT6JhMXqyOA8AFRV2zsxIYNokEgAWCUj2gyZUxOSMYwxtPkWyY4Mcbg2lCS3C8yg3bU+eqINuVt3iynfjL2oenhhqYVmT0eaVS/he37TP415pyn0/p70NrdfHG1oI1+1UdJHH/Y7Xk4JAFY79uxklXnS0T7AaDZu/or/LTZ73897U50l17C3YK9rPI+xcmzeHoabX8W3F/olk1ZV5XkD3+Usmz78I/7cT/5mkkg8Q91l47kI9gUI25I4UclU4CCo9nKge+3yTsHoQVwyHOycBsUlxTbRKRmw8gPDUBdaVIANs758nJaAwsKKEJFrQ7HfRzz3lB+akrTE7mVo+oou1FJHbweEbkZ4a/ArPHEboerYUkQ24edB3m1BPLcvCI5ZJHjTV/2vRFN2z8uCTjKtea51OCOkdN8jjkgB+Skt5AA0M2PnbfT9ACdoKQMyMtumo8G+EY6hugyZH+WCsltWDJQ3Cx9hvwdjuqX1JrlmQ7Ze1CpivdqZxFyKghgnRgZCbSoTdMh7KCt/gEHljFkw7DtQCViirWWvwxEKS7olC+pRFJxRDA6jFw+pE8kWI6MBSioJddcnY3P05
 5DJWATPo
 0Gwur2yHp1imLUelVhkbzqw9d1GogiH1iJyiV4JXWtWilM5YBJ/3lIJSjDrrqbcqyz8wr4psexAponwJvaBmzyJWhYKfQk8LvZqlxtoLiVLjIq9xJ2Z8GhYbJ4X7vaFPP+fp7Ipxp6CRsJ3T2oNSfDnakVN66Qw56NKvA7dorDp2LQMbaRSmrbXpV3ul3u2OTn5TY4oVAvpAHMGKVqY0Iss6hB/274Wd90lcDepqzAsK8A+VOQFiWXcJNiXm8sqBmoCD2UMOgVVdcGzlJ6lXvl1eB9WGGcQ9y1x+demUvj/5PLhfDH7LKKrbkfOg8NE93IyehPyTpdLDAIwJbf+AL1TO1NOYJXyWRZRPdUrVDLmWbMZUO2POXWhQ45lsWjhNbCToVnVC0kWlNIxeQFDoBjbxO67merxRU3yP7IDAHQrxqZ3dArtUnaZw7hfb+XQsiBdBGnbVbZpwWl1lVevNuGvUSHCLrCqZbELVKGxgyAheJuqmsXorEiZ1EHCubMzGL4wlBr13hBtQPdpOdznAg3dNLmLvVmFS7hnRUGTIHLccJVPjsDvF8hEOv6Ajs4O4fBVooPCF4+9qUQiEI2QAxe2Wb/K78daQYsJu+8ZrLSqQcHv7ucBSaS4qjUFocirkjH5eg9UPkFymxz0XlIrxWhlirzq3P/wt18VHlyQnZEl9UKwrdoJetcSXpmTuMILpNq4OlfUU7bAduwSrbHZ+vM9gxCmtaVrhuNWvGbEJnN5ZQh2UnFOqidJqZaZhtbczUi7lO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 12:41:52PM +0200, David Hildenbrand wrote:
> > >
> > > Another point in favour of COW_NOW or EAGER_COW is that we can choose to
> > > allocate folios of the appropriate size at that time.  Unless something's
> > > changed, I think we always COW individual pages rather than multiple
> > > pages at once.
> > >
> >
> > I don't think there's any practical way to do it any differently because
> > you don't know what's mapped/not at the point of fault.
> >
> > How expensive would it be to have xarray for anon, I wonder... :)
>
> We had a proposal least year I think where someone wanted to bring some
> weird FreeBSD semantics into Linux MM and proposed a secondary tracking
> structure for anon.

Yeah ok :) you've brought the big guns out to shoot down this... well I won't
say idea, cheeky thought :P

It'd make some things easier, but come at a really big cost.

It's obviously of great importance for the page cache (otherwise, how do you
even know where anything is there).

For anon this isn't the case.

>
> Tracking twice is obviously more expensive than tracking once, so I am quite
> convinced that no, we never want that.

Yup :)

>
> --
> Cheers
>
> David / dhildenb
>
>

Cheers, Lorenzo

