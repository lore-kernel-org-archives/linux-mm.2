Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66B0CCFA19
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4AA8E000C; Thu,  6 Nov 2025 11:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216558E0002; Thu,  6 Nov 2025 11:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE198E000C; Thu,  6 Nov 2025 11:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBADB8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:33:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A94B385A1A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:33:07 +0000 (UTC)
X-FDA: 84080726814.06.BDF5B76
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 037F9C0012
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:33:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R7kHFozn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YFg6bma7;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762446784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nv7Z4TysRONcUkSkRNmaXuy3oX1dXXlFpGABNdSyzAw=;
	b=XmUOPZOWUWwUwwVuKQBK6kXtYoJNyjzJUBwmp9t8aU6krNblLFTL5Ob+t6ob3HercPl456
	8f5SMqnWUKV209uK5r/xIhzJrvP/yCt2H/noMctHLGxSNGGQAV2ltpMpkqAdOeZ/oKbPSt
	iW78kGORbU9hf6WYQQbiJ/XRxHxjmn0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R7kHFozn;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YFg6bma7;
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762446784; a=rsa-sha256;
	cv=pass;
	b=8Finm/tc9j2mvSeccdwVRPV0B5v3+4y1QooOUfSzakQ+aGEbz4Gc0KDd7/NdsSnDUsF/HF
	wqenA97mQ5/6flt+JfjW80K8iD24IwUm7MNTNl7TNQjhOfAM3Drf4vohcK5vIZcT5/MZ0I
	oS9Qkb1MDQxsGNR1rQNTv0Sav8zf79c=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6BeIIb026023;
	Thu, 6 Nov 2025 16:32:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Nv7Z4TysRONcUkSkRN
	maXuy3oX1dXXlFpGABNdSyzAw=; b=R7kHFoznLUFiO1NrorYrsSVXJ3kb+hXz9p
	1bfb3mpJKQXPsaqT/WyR//OmZbIdx8IofMD+pMnaD6yFipsCchJa1anTqBJzLdY0
	fecgjM+pTef9FENe9idBSzIcJj4izibt2GEEnUgAqgXPdP0zBsDQUzWs91wVNNNy
	unbRUJT4JTPsVSOtWtT3BkeBTt+RVSIS5sTUYwt060McHiU4h0vItn9j+tlAZWL6
	v0NbIz4gFhg0VhWwMJRx3qU7BtrQdYnTc1csqqXXBUdKrUObE+hQJje8VXMJOc2h
	1QFwLLIKt8mjoEaxrTuh7Bw/pLz2pGw61VAjCuD61joc9P2w22gg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a88akau49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:32:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6FrWaR010936;
	Thu, 6 Nov 2025 16:32:55 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010028.outbound.protection.outlook.com [40.93.198.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ncmutu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Nov 2025 16:32:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rv7Lu6yt9P9cauyXh+d4DUY6RwCZjtEC+xPMqrwb9ej/nFR1C8QaI6daJj35NhQOTvDje3CPUiivxbVB/ctpPVtSVp8ecw5ru3U2HMHdhA3UZ8kM0yFz5ZGikgobuCuJdMqH7tHgr+N35EFCDqBRPN/ywIhlR7xJvq4gPD0koGcD9Uep+fl+9Vo03Px2H68zs59+gRRMFwmTdiWFGDnMARGp0IYcsRgHAEm2578M1+7T/Ng2X/ZWAuzKGE2cQdT8zsZFL83+bxOIGNU0l5bFYML9W4i+PcKGxjSF0xshWV3uTfsn9BdG5XdP9Tuzn1EOLtLknRhRYsThPn6H0pqxHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nv7Z4TysRONcUkSkRNmaXuy3oX1dXXlFpGABNdSyzAw=;
 b=c0o75tWHn/pHktL5QZY+jsAqjxEmxjbB3+vXLEbH38CD7dv8ccDPKT5hWxe5T7iPd4m7eGlxSY5/cY/46Sq6BHvnsX4JIQdNDkB4nKVRE6LOkUcvUsu5Xi7QHwdISAEveHYUNMg4175/VKpPwCJpJtSu2Vedz6QHnTJehgZnOQYGHSuJ40uGoZ8Z+Dp2Nir3AFyqSl1JSbKDAO57dzo7Nz69rzws/kFgmZpLigq2r5zSDbOhRpzpTLoe/AB6nUk4NLkTCGrq/Yl0+aCEVroO+Hhkc/rZz+VOdEnFXVWJ76ekAYrcy/TDpXMmL1DLtYgQ1NQKNI7AV2BjzD5C+ACiyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nv7Z4TysRONcUkSkRNmaXuy3oX1dXXlFpGABNdSyzAw=;
 b=YFg6bma7z3WxxveaOXDZNBuMr2vv2reTjt4RnOBwCK85AYHia4fZIB2H1y/r+czN3HnYvgZB6zXAfJkSM9sdY/Vat0KjU/PLVdvprxj/1X9rZ6Slk05I8df9zrzDIBnUKHmyZYW3GnI9G6isL69syTh0WbfqvqRWbVo/AMZSNlE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH3PR10MB7701.namprd10.prod.outlook.com (2603:10b6:610:1a9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 16:32:51 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9298.010; Thu, 6 Nov 2025
 16:32:51 +0000
Date: Thu, 6 Nov 2025 11:32:46 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
        Peter Xu <peterx@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>,
        Nikita Kalyazin <kalyazin@amazon.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
        Ujwal Kundur <ujwal.kundur@gmail.com>,
        Oscar Salvador <osalvador@suse.de>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <mnjrtg62qh2rd353mbudryvs3neukt26xtovyddm5uosxurmfi@lldnrp7a3666>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>, 
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Nikita Kalyazin <kalyazin@amazon.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Axel Rasmussen <axelrasmussen@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, James Houghton <jthoughton@google.com>, 
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>, 
	Ujwal Kundur <ujwal.kundur@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Suren Baghdasaryan <surenb@google.com>, Andrea Arcangeli <aarcange@redhat.com>, conduct@kernel.org
References: <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
 <aQO3Zko6Qrk7O96u@x1.local>
 <aQPCwFZqNd_ZlZ0S@x1.local>
 <d0b037a6-11b9-483b-aa67-b2a8984e56e0@lucifer.local>
 <aQPU-tyo_w68cnKK@x1.local>
 <7768bbb5-f060-45f7-b584-95bd73c47146@kernel.org>
 <aQkUwbx7Z4q1qcSB@x1.local>
 <5f128cbf-7210-42d9-aca1-0a5ed20928c2@kernel.org>
 <aQmplrpNjvCVjWb_@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQmplrpNjvCVjWb_@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH3PR10MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 2867dd57-2861-4977-4d81-08de1d52211b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/7xaBCZX8mZAhot5NTFQbN533N3ZLisN1XGhZ+5UjRsNG2KOGeVaEHBqqayD?=
 =?us-ascii?Q?KqfwRy4YL+QHu9TVxUNS5teV9BNiR1tvsmm7/GWXautEROuaL/BWUzVzpFbe?=
 =?us-ascii?Q?ezuXgw7OvLaCd92DWOOtUO9P6/+zDg4g0Uzwer3Df6ZUaXpyPaOJWxtlgWwS?=
 =?us-ascii?Q?XXGzOCCf1nQ7PLBze20sHNvdAhvYHfq+AXvPMensBBvgGUFUAhMOkqXeEQMm?=
 =?us-ascii?Q?l3sueb04qn19OpfDq2nVHgZxKjJAxwNzN6LJZ/Dj+irqVIYdwI+qhwBnQK/g?=
 =?us-ascii?Q?rS8n82m/q3zwoyiKPm15DMjEE8fB7IYyiBAbYp+EKHDUo5CY9BrVI44dyymG?=
 =?us-ascii?Q?YMjutMfbYHS46wXwmjf5gBTI9QS7Aq9cWZX8MmUDbROIW1UYw6U3R5UyfMtv?=
 =?us-ascii?Q?MTxWbd2l08knz8Wko66F7vD2enVZ2F4jRV+DHeW0UhJx2NeKXcuUMFFk88TN?=
 =?us-ascii?Q?dpiUyTDeSVTk6kE/H7G6fFLNlLR5GZ9fOmAL02oC+2EsOO7r7LmeARWr5nEO?=
 =?us-ascii?Q?Qm3/gqGwoF0oUkV0EkLibyOJhvvWKEa/rfJ+2f6xC4NtoOjhkT5PcTtlBSOp?=
 =?us-ascii?Q?OjQclZDQjy/bc0GYKmo+u7VFnobQYyj4godQfbpltKW+/1g4xYzZ3R8I/61M?=
 =?us-ascii?Q?98vfl1YgOU97g6wMZEAgVGR5aX/Vv1c49mFG3/V2BlDY0BENOCHUa7/tEFpe?=
 =?us-ascii?Q?dZ3KhLKAWbQMIDiCUJ/VGwndOtK6eXzEUWuDKuxdwbHMBCamiCnZyREw30Rg?=
 =?us-ascii?Q?Fhm9jg054a53bpNG41qkSFVmaS8gDcDkURF7QLMazk75xmwiS8UPDysatvMP?=
 =?us-ascii?Q?p1mVZZStH3eX33RnmW6OASoRluP2y3srrucGs2MBGblBVkQBr63W3NWLq8f6?=
 =?us-ascii?Q?p12s+/8C+ouzzwwkruzwNGNXiQH9ya3pui3fTfiJWwAInffZ7/dRx733drTl?=
 =?us-ascii?Q?/qdni6kyfIpsFv0Msn7k+8PGe7XQVprtse9j830/uyW4rI9vLYf8uld+zIBg?=
 =?us-ascii?Q?NmSsytjLyzuRKPPNz99NO/Czv5vdkH/rZnmSuw1DhHO16bZAv3XeWJgh/ox5?=
 =?us-ascii?Q?sEmGGhgZwEVRDJgGj2hOgzlyOHBr4FtGq2RHt/hIhMWQbn7E+fo3HeIbJaZK?=
 =?us-ascii?Q?bBzX2pCW47uUFKKFjUyIQE5I5nlggH3WClSgol+rrpiywIXJcmBS0XpYNttH?=
 =?us-ascii?Q?swZUUdqEjk+N0cLlwJy1JiMM28s5VifNXp4bSoinYz6Q/u31gItbQCrhjI/6?=
 =?us-ascii?Q?oa2RFI/5lZloZApdCQa3tqd0lDay3MVDmrH1rhSkFewAEANiLKeuv/9G1kTm?=
 =?us-ascii?Q?J07FrJdEvxhIu4F7ghfix2vwkDo88vJY0Tnj/xW+RGcRLN745DJNIaTyqh02?=
 =?us-ascii?Q?8kK0Z9FZmiqxqxPSmMvjDee2/5wh9QnLjOsoYuR6eoDqUJkfcw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?m6mWUGTjFSKVjlZt+SX38W43TNOaII/6fAuqlrzhuYXhTaRwBIQLTSKo66ye?=
 =?us-ascii?Q?nxPmK2RB7sRyKmLMqzR5lZttjLDEEZnvpHfs0JPTIzzDTfyDqhmoD0ZhjRcy?=
 =?us-ascii?Q?6CmhdAm9PEbIgnAS+M8s4to/sCdeRIGKwGbYXbqDtAA3gp3I4yCPYEV2psaM?=
 =?us-ascii?Q?3PiYP0zk6q8bdP+s5rMI14TkcEhbN6bZL2z/e5LcCDDH/LvKQdG8mqQVLveA?=
 =?us-ascii?Q?wetP1vufTGETFHs08L3NbKc/n5PdJJGoPcZAIpb5PiL4lnytbsodOkAazEGx?=
 =?us-ascii?Q?6f2rC0CtZ6+srZwV/wOjtlRILcRwbg/lEGEJ2NCF324Tb5id5zOgPNPBzddE?=
 =?us-ascii?Q?/xxEY1liNBm0TnKMpCQxv3DlNco1e+ZRqoLPqIaUf/ckOdwSS/O0lBskWr3n?=
 =?us-ascii?Q?L7rL2fpWi042BskdF+pP/Bkxv3cokB75U2HoHV1Aa40IFQv1E3vi/T7ulMzp?=
 =?us-ascii?Q?uEfKIO1dq71BIUu80U6wL6xm6pQwVislflY6rG9bstBJNLXw3nKTHsotaO13?=
 =?us-ascii?Q?omVf0xoVBsH7Op35UPKPHBAc+AoJk+cZUISEDGgH7/eHis34KjJou9qPRNg3?=
 =?us-ascii?Q?2G2AjZFwWe28NLWVlbV3wg7K0iJ/IPMn2tHNrjI1U2DFAyjP5Q+YzryzN47h?=
 =?us-ascii?Q?aIhcQ5cTNTFBZIo7PE7VEZqU95Ml/0RDVRFUBKlqMmcsu6Z9rCrYW78PQwuQ?=
 =?us-ascii?Q?FaNnVj8flSRuDw0bxTCnm1JB9zreOJ2IoYs/nY7v/xu6+kLLoSJUcO3PAftN?=
 =?us-ascii?Q?tL730HZVXfG54mULhkRqhuJuPIT7pidVwxnAfyzXsdpnpR+ZaEnLIai742fv?=
 =?us-ascii?Q?5ysmB+jF0qSaHG9sGWRwFFpYoHUgT67Uv1rYJlC+AuKDUJilfCT714eyJ0rh?=
 =?us-ascii?Q?jUQylY1BygRTSN+kNDP7qJpsNj01ALT+LtP2TfAb4338m9/iCI1yF79vLPzQ?=
 =?us-ascii?Q?xD0k6rNVVZvfwpUOfxg05gRw9W3ZVARDQ/hGK7IqFtPuMSMAk4LGN+QyjhPH?=
 =?us-ascii?Q?GHMlzoTK3NsBRjqQb194/i3tBx1xK1jxa0M/o+iRa/d26v2y1l0lapO8LpnY?=
 =?us-ascii?Q?x0SXz3j3Wye3MjhIB0vkzJDgMroU2KJZQOZd4ke7p9G/tRRclkWdH3XbgGjw?=
 =?us-ascii?Q?ww9M0K9+29YM3GvwV+JuNLQPRg2WmAQATfENpVJMJhBXjvERou89HfAZAlho?=
 =?us-ascii?Q?qApVHNCPc1gzHgm8uX5mUhMr9/ybtOW/dsLEwnaoC+2tD1vRRmdv4jnAd0Qk?=
 =?us-ascii?Q?XCUS4UGpB+gNmSeG+fjpp7Kk5MBUKfma0RBlqRFLWsPtZKP9hza59ZV6Srw7?=
 =?us-ascii?Q?bqd6CCQUiUUE3Wu5a6aTFLsJXegSQymBqaVJiNwmw/6VW4tj9PzuNjLJ80LH?=
 =?us-ascii?Q?vs/w3Oef290k4jclK8a4dIqJheu//D3oY/eXIDprlvvu44n65GxONXILurp0?=
 =?us-ascii?Q?+vojBm4uQCGWufXkP3nrQzNfgDazTNluxYxXUkFzQFKdHX7M5OrgxD+6CDzc?=
 =?us-ascii?Q?H27DR928PM0kMhERDy4sHrZryWIvyAG0nE3NrYoLhoRYx7VQBt/HnGEQB58d?=
 =?us-ascii?Q?o46iCvLos5HsdF2MB8NkONZ1ah59nzh4I3Fy4bD7?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kZu55T49Epxg/hSJg93TmfcUJzCON0LURo+os0EOqicpn6r5bUlNsUZuzyXMaAqbluJwLGWDpMjRRXx0KiTqRPg8nBYomiATD4zGBKjtvVQ6vhzZ4g/MATKNQOdP+L/y0x2nDWFxNmUwgtw0Ut54vPA0eUQK6TVltMDpsJKMv8mINnl1auvNZMEtQilxRKqSWE5BkShi4kb6d5AC+Y1P5f0Qws7FuiIcEJGIuFRXyzakXJczCUS+PwoSWC2e/wcfB/1+hfql/CfYZCNeI+H8DS/i5HV+kxnXuH4bVQTw+LQblxQMQKsSmcnavVDsk3AlMqOsFCjmmhNL5rL0n8bPL0Qw03DCOs/4jsbYIiAVtdxiJUIzfUhx6oCl48W+Iin0X/XHaFEwlvt6BP0sFSVLYszoDrLJ7sLGMnSxQWTdpXhunC39WU06IxbrpfksnrNHabeK6lahJMMQDteSwNViR1Hz6lr772/9aMRaGw8RX9Es/tZruLi2DIyBDVK04uAS9hw004h4mq8DejO1wDuH0eo1dtUhTr9mUVtDmrDO41a5XSyuehQ6sMCZA1pJx6MtUcIJHDwiWe50Sh9PfFcT1k4cMEX1zjcD084RoauQa7o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2867dd57-2861-4977-4d81-08de1d52211b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 16:32:51.4954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RXZv6rgTMFed8IzErLFDuNhp0Olf+1DpLjhNdNTuQyHZFPO1qgqQyTEvEzgG0vHMxWh44jNVgBrAkFIYjzApw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7701
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511060131
X-Authority-Analysis: v=2.4 cv=LsGfC3dc c=1 sm=1 tr=0 ts=690ccdb8 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=VwQbUJbxAAAA:8 a=TeIMf7dAvHId1ZiLINEA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: DBlwXiRcgXD-TL8g-OYRmAJUWvQwQAur
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA1MDEwOSBTYWx0ZWRfX0QvHkfWAo/qP
 PwLanF8uGiWdxOZvV7s4bHlK11GwqWyJNe434marlONvdC8xlfxABjnU890MNf9hzacFpN/Vhvz
 HSdSE+JbGZsjOtnRPQ8Ej6h1SoVtQkHGIA4ABbGNr4mdQcG3ODu4t9fowfCNmBptfhXHOwGbk/L
 UWX2ES1GW02C+HlwXf05f3ReIB/iWNowtCSzsIyMOBtJmdgdmqWnCi/rISKpxo07MWP0qJdtAbU
 5kQPlLJVg9dMLJflNABxih6lUGEFrAJNRAe+olzy0ugbuGJuuodFt5tjmKXJKWnjMgpH0NhCEeG
 WWp6hIj0r0elLeKumEPqaehTi4DfF8hPC7pLXWXOAel960SIpDgJ6TA5vKaqHN/4rG1aZar/j5r
 D1dttJRI9HzfEAtOk6AXmAqCfJ2JqQ==
X-Proofpoint-GUID: DBlwXiRcgXD-TL8g-OYRmAJUWvQwQAur
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 037F9C0012
X-Stat-Signature: jurkegc1trng1hdxwwcg4e4bkgyamigg
X-Rspam-User: 
X-HE-Tag: 1762446783-716536
X-HE-Meta: U2FsdGVkX18Wzz1i669McyEPxtZIwG+a6f4YmFKJ1ai5s28puRUv4lhMXLEOqF8bqDXGL2s1UPLohzo6dX01vO9p+vU7F9X++ipg3QQmrBvg5WeBXG6c9GM2mMV+xeqfhamgjn+bZSd3QWJf15DDfFxED/E5cDeib3qDIq3I+qGlK3jSjdkdM0gu9vBGODS1cZ0P0RwPwCGggF6ejJmOAEbroXxMnGxKcgbD7SbyA1CStPpHt7MOXAXgJvGPASnERnvhHoiAG/cXOoaWNg0ZAw3Yu3bJP0Gm1NFyOeJ8OanZYDCuDUYtsYCnBnw1VRQ4RLw8ceeFnh4OFAu7f/yHdnYi55G9uUT68vb3vHS7A1SSm2RiGmb4yi04tpqlShv+kvcgkJ6QCXEe5xuXUhVMJbNYWTpsF2B4jOJDpaAdduNRpO1EWKeoFr+q3V3Xq68jwrwHl3vDv0I71lpdHY+chrFFIRgcsmnf6zPyZI/fM0z2I3PXdHePoQgYBuckHTll1cd2PzufO+0zvQHTuo/i1LH6/JvjwnNREjxiBRdQ1P5CmXAVfPDtjYqXD3I6VW3YN5pT+VknyOf0bADiLIwAV0EQfgyfucd6Sx9ggPgkZlnrj88KZcuNBbDDuFXebvSD0WgagnfpWCb0yDuparAZWH+g/ys3hZmAn2dFTcTpD/9+HIxRmZGs13QGKL2xmWoBJQY5MXb/k1LRziKC+kCGnJvGUoQupoxQrDZqQnVrETUDEXnbfYdjoFm03s2vWAg9j/aQ0DBnxCCtQ/BLW5YfGdtBbrciDiwBjelZ08bvSYxqIJWT4ODI4BNpPZ66AaV7mIQrd2XqFnlJfH5c4mzhzOJct5BjuEAwWD8jMiVvWZfC30A8QyOCgQ8z7+gvoyBHpBhuQH3CPMMxYXr0kgEC/Rdb0pEuPQIhJpAFEdz51q2rOytwjv0wKdfLbfOLD5/ICkmRqGdY9tDy04caqdX
 C3/O6Ly/
 m4Whh2OxcM6+1QhXckQI1pZkQXWCWGSBfOolpyCCnELFhXfd7csUbCrZYqKlVQ7yVmVrCmedUHIKVubgnEgShWwekDwGqSsaPVLmEbJtb4KvFYO2fxbqWcuW+Q0oGHmdfOqlcZYH5DNsF4r/8Ss5Jry3G87XbU/EMv67dNLclIVrUViN6/jzk6AzEtHnshZGlaPT5WIxgQA9M0m++EBprxTjQN7SekyG2y1I4NZFchjPpMUC3xslj2de9mlKX47Z3idSQ+YaQOHfUo2S8vIiuvb/ykkYbVq37YZPKSmnlABqzLgg6uQaDSYNehm/ncWQwyaImMqVQ+0NRgseS6pZmJsKnO5LPLhBc3l0kGT7RV0ltfW0aPSuoSIBdk8tOp/Ij40aqeZylWG5vwTJqce1SyE6JsTgzDCEqJh2v1o469FC+xnquFEHO5SryghCGkrYyLTk1FPqehygXX4ppNYR0wxS/J9WeqtTF3h+BFGC3cDH95wojLECFnzyV92pJzGJX9JjrC2pb3KFwHFTvvciROl82FEhx9a03t2jf9yXNtDeTzNr6J0v5ZHwgbXOFQdA52G6EGtpkBcl99Wiecl36WXMDMGFIYjX0k+eWq40N0nWcWfodJ3hQOaOYxJlOzGSHCwtcG9K1apJwPv1jTZ5+e1NI7aJcvvCx5FzofJCDP0ASSYx1Z/8+0e0lWXY1KpYUmRWT9Ddr9gBqGTEqZlykPt2uG3eooiKqStL/oYRGAXJRrcc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Mike Rapoport <rppt@kernel.org> [251104 02:22]:
> On Mon, Nov 03, 2025 at 10:27:05PM +0100, David Hildenbrand (Red Hat) wrote:
> > 
> > And maybe that's the main problem here: Liam talks about general uffd
> > cleanups while you are focused on supporting guest_memfd minor mode "as
> > simple as possible" (as you write below).
> 
> Hijacking for the technical part for a moment ;-)
> 
> It seems that "as simple as possible" can even avoid data members in struct
> vm_uffd_ops, e.g something along these lines:

I like this because it removes the flag.

If we don't want to return the folio, we could modify the
mfill_atomic_pte_continue() to __mfill_atomic_pte_continue() which takes
a function pointer and have the callers pass a different get_folio() by
memory type.  Each memory type (anon, shmem, and guest_memfd) would have
a small stub that would be set in the vm_ops.

It also looks similar to vma_get_uffd_ops() in 1fa9377e57eb1
("mm/userfaultfd: Introduce userfaultfd ops and use it for destination
validation") [1].  But I always returned a uffd ops, which passes all
uffd testing.  When would your NULL uffd ops be hit?  That is, when
would uffd_ops not be set and not be anon?


[1].  https://git.infradead.org/?p=users/jedix/linux-maple.git;a=blobdiff;f=mm/userfaultfd.c;h=e2570e72242e5a350508f785119c5dee4d8176c1;hp=e8341a45e7e8d239c64f460afeb5b2b8b29ed853;hb=1fa9377e57eb16d7fa579ea7f8eb832164d209ac;hpb=2166e91882eb195677717ac2f8fbfc58171196ce

Thanks,
Liam

> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d16b33bacc32..840986780cb5 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -605,6 +605,8 @@ struct vm_fault {
>  					 */
>  };
>  
> +struct vm_uffd_ops;
> +
>  /*
>   * These are the virtual MM functions - opening of an area, closing and
>   * unmapping it (needed to keep files on disk up-to-date etc), pointer
> @@ -690,6 +692,9 @@ struct vm_operations_struct {
>  	struct page *(*find_normal_page)(struct vm_area_struct *vma,
>  					 unsigned long addr);
>  #endif /* CONFIG_FIND_NORMAL_PAGE */
> +#ifdef CONFIG_USERFAULTFD
> +	const struct vm_uffd_ops *uffd_ops;
> +#endif
>  };
>  
>  #ifdef CONFIG_NUMA_BALANCING
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index c0e716aec26a..aac7ac616636 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -111,6 +111,11 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
>  /* Flags controlling behavior. These behavior changes are mode-independent. */
>  #define MFILL_ATOMIC_WP MFILL_ATOMIC_FLAG(0)
>  
> +struct vm_uffd_ops {
> +	int (*minor_get_folio)(struct inode *inode, pgoff_t pgoff,
> +			       struct folio **folio);
> +};
> +
>  extern int mfill_atomic_install_pte(pmd_t *dst_pmd,
>  				    struct vm_area_struct *dst_vma,
>  				    unsigned long dst_addr, struct page *page,
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b9081b817d28..b4318ad3bdf9 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3260,6 +3260,17 @@ int shmem_mfill_atomic_pte(pmd_t *dst_pmd,
>  	shmem_inode_unacct_blocks(inode, 1);
>  	return ret;
>  }
> +
> +static int shmem_uffd_minor_get_folio(struct inode *inode, pgoff_t pgoff,
> +				      struct folio **folio)
> +{
> +	return shmem_get_folio(inode, pgoff, 0, folio, SGP_NOALLOC);
> +}
> +
> +static const struct vm_uffd_ops shmem_uffd_ops = {
> +	.minor_get_folio = shmem_uffd_minor_get_folio,
> +};
> +
>  #endif /* CONFIG_USERFAULTFD */
>  
>  #ifdef CONFIG_TMPFS
> @@ -5292,6 +5303,9 @@ static const struct vm_operations_struct shmem_vm_ops = {
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
>  #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops	= &shmem_uffd_ops,
> +#endif
>  };
>  
>  static const struct vm_operations_struct shmem_anon_vm_ops = {
> @@ -5301,6 +5315,9 @@ static const struct vm_operations_struct shmem_anon_vm_ops = {
>  	.set_policy     = shmem_set_policy,
>  	.get_policy     = shmem_get_policy,
>  #endif
> +#ifdef CONFIG_USERFAULTFD
> +	.uffd_ops	= &shmem_uffd_ops,
> +#endif
>  };
>  
>  int shmem_init_fs_context(struct fs_context *fc)
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index af61b95c89e4..6b30a8f39f4d 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -20,6 +20,20 @@
>  #include "internal.h"
>  #include "swap.h"
>  
> +static const struct vm_uffd_ops anon_uffd_ops = {
> +};
> +
> +static inline const struct vm_uffd_ops *vma_get_uffd_ops(struct vm_area_struct *vma)
> +{
> +	if (vma->vm_ops && vma->vm_ops->uffd_ops)
> +		return vma->vm_ops->uffd_ops;
> +
> +	if (vma_is_anonymous(vma))
> +		return &anon_uffd_ops;
> +
> +	return NULL;
> +}
> +
>  static __always_inline
>  bool validate_dst_vma(struct vm_area_struct *dst_vma, unsigned long dst_end)
>  {
> @@ -382,13 +396,14 @@ static int mfill_atomic_pte_continue(pmd_t *dst_pmd,
>  				     unsigned long dst_addr,
>  				     uffd_flags_t flags)
>  {
> +	const struct vm_uffd_ops *uffd_ops = vma_get_uffd_ops(dst_vma);
>  	struct inode *inode = file_inode(dst_vma->vm_file);
>  	pgoff_t pgoff = linear_page_index(dst_vma, dst_addr);
>  	struct folio *folio;
>  	struct page *page;
>  	int ret;
>  
> -	ret = shmem_get_folio(inode, pgoff, 0, &folio, SGP_NOALLOC);
> +	ret = uffd_ops->minor_get_folio(inode, pgoff, &folio);
>  	/* Our caller expects us to return -EFAULT if we failed to find folio */
>  	if (ret == -ENOENT)
>  		ret = -EFAULT;
> @@ -707,6 +722,7 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  	unsigned long src_addr, dst_addr;
>  	long copied;
>  	struct folio *folio;
> +	const struct vm_uffd_ops *uffd_ops;
>  
>  	/*
>  	 * Sanitize the command parameters:
> @@ -766,10 +782,11 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
>  		return  mfill_atomic_hugetlb(ctx, dst_vma, dst_start,
>  					     src_start, len, flags);
>  
> -	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
> +	uffd_ops = vma_get_uffd_ops(dst_vma);
> +	if (!uffd_ops)
>  		goto out_unlock;
> -	if (!vma_is_shmem(dst_vma) &&
> -	    uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE))
> +	if (uffd_flags_mode_is(flags, MFILL_ATOMIC_CONTINUE) &&
> +	    !uffd_ops->minor_get_folio)
>  		goto out_unlock;
>  
>  	while (src_addr < src_start + len) {
>  
> -- 
> Sincerely yours,
> Mike.

