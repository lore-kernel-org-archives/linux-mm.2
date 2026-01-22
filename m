Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42731D46952
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 12:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436406B0189; Thu, 22 Jan 2026 07:51:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D6526B018B; Thu, 22 Jan 2026 07:51:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20E746B018D; Thu, 22 Jan 2026 07:51:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAD56B0189
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:51:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBD72C1799
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:51:00 +0000 (UTC)
X-FDA: 84359584680.08.222EE45
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 882C52000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:50:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TAkYNJOd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FhZ3TNvF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=;
	b=Aith10p4A+ESwA5grJb7trzw1PGTcdtqHOOHhL/NWe5ogoDpZyrB8OXOJD4CgBzOsX9gOF
	1S5XJE7W0Pj31SRWh4uBogv0BxpD2Ji8oc2lbQXm1H0c1HNKo+zbvE/oZDK+W+HrK4S5IL
	WprlegcYcpra5sP6/CL5dycGpcrzzv0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086257; a=rsa-sha256;
	cv=pass;
	b=l7TnN78x0OzT3lBDMRZOz23J9UGRup2ugyQRuAUqisNEIh0DIS53yR77Uj+Qr7C5Qc9Z/N
	9sdE3OHow3Ff+uqOxzYW3IO52Xz0ED52IPz9vMTVjx599a6659o6ZcZTEXbjLamIU99Gn3
	98oK2ojZujnQ655Fw8SfHEch46cR9VE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TAkYNJOd;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FhZ3TNvF;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LMa2x83869559;
	Thu, 22 Jan 2026 12:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=; b=
	TAkYNJOd/gLAolavMOwfcVsXsmNE9ASUVv1nSBT6jH540B8ARMZ0WnBl1A4yoQbo
	k/TW/vHEbJZsUJXWqFb4XDeSUccB82V4p4NRHXYgdMX8+JEiXRwasfKJn0W5k7OL
	6di/LeIdlqY4wDiyLy8OapPiCverS2cf+QRSnPeW1+0B/gX5mz5PDizGl40i5/iv
	4DlSJgC1ARcEu85fOgzvBsX1IbBvpN/XnYnBLpAv+4UhuiEQdLeWFOJLdeYsX5VF
	pkCJBHqOpbDc//Cr9SvtuVlyS7GqIQA9D0gsc7ecTu7S8wdASBXAyK+3hIusyvZ/
	23UtafxcdFr/f/XoGeQObQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd469k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MBt33P032828;
	Thu, 22 Jan 2026 12:50:47 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010065.outbound.protection.outlook.com [52.101.46.65])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vgk1n2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 12:50:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t8+BjEIgwst1o1DyqWH/NG2cThlmurgF8VLDDs1N8Ft3fKCTynaHXb7AIA1aX//Mvcm1dw4pqKhdvOueZCrgWqWOkYtCI0htO4YGFEXMUk5KV/L99sg8mphG4koLQAVeouqOE4YQOZR79TySVZfBC7y3zOl+5vwD9oMVRmH5hZF+Ai6/c+8eAlVZYCuyx9JGDBYybxPeSxf1dETT2nx8/Bg+j8dHR5Dj5eryy/zIwVYPAFnxl5uX4ILAjGVoDB5R8B7HgmhGWNZoqrWaGba8ti+Qu/pUVVBNeMt4Qw9CCuaHb3gLV2LdY/2zlqJRVpX0hGjwH/mGOaqrnTQE/NUfog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=;
 b=MBXfoAI+lYEUmFAV0zPs8tNCWcHw5ZMyyJ5BE5UmaQ1Xq5DiCc6prZUSTy0qk3OYQs8KA1J7b9t7Lb+Rv9/bWy8hfy6LVOgxW9tcOoc7brDsnMoEG5CCBAFYv65KMTLqrOMIIYN+BgI+pe/3WMcdVsS9a8NvtVvo0tOXwhwLlu3K/gs+5vzOXMT1QXM+MthlcRAWoJQoNVOjhWyMomqGZr3as2Eki/LmtIZokzqxDTLzhtYEakjH9NmmRpV+Ns4o+RGyivjLY4oThn371QTBGeI3YOJsipfLmunVp/c0WOn1fLvHvslKslINbefhxfMb+SyBJRRWXZPERbm0hYrVVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VO5s2D7XD1EWYcxMVMxWMOoJfjbN1QHSq9LYqgJZmnY=;
 b=FhZ3TNvFfro14GD1QgE24GHcFL2V+3g9pY8v7XMnrtbHoE+hEzcQnsThEECsOwF9aoUgV2Edk96/j82EcQyqfuHEjCMLt49cmRIrDH7ziAYSU+Cpjc80Mgp1Brx94/kJEIBJftBYyOChcX+AWzN7MIgfLswR+1GZQJBziF4BZL0=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB7904.namprd10.prod.outlook.com (2603:10b6:8:1b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 12:50:40 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 12:50:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v3 5/8] mm/vma: de-duplicate __vma_enter_locked() error path
Date: Thu, 22 Jan 2026 12:50:25 +0000
Message-ID: <2611b2b6957b7aef587e9ae62712a888159dce60.1769085814.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0571.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:276::10) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: c924df34-a4f7-4a95-f9ce-08de59b4d8fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sIeL+9OY9FlvIEuwQnjrjZfuG5wj4smsPoKCFpmz0FpIVR/tbSl6IhO8ES6t?=
 =?us-ascii?Q?yXDn7yn6ep53pQjDCPP5VpLlrczmv4qJvw4NaF5zeAyEQ7plPehHrFaK6twf?=
 =?us-ascii?Q?QFYOE7RKeB5xzC1NEQU9T38jlSJ4aE+v2Ua82Go+3GA1+Bl1rFTKdHdqXNuo?=
 =?us-ascii?Q?OIwykR4WlcVWs1tcj4VktLDyJKpZfKfUSeSF1caOy8UYrP6uMYbRmrRNYZNA?=
 =?us-ascii?Q?9olQDDEpIsCiDr7zAXnPjuO/R1QxtAHi9Zpf1Tvsj4sEokwVkETTIQPPrfAt?=
 =?us-ascii?Q?XO9Lm82+9EfuNO6wrKbxO33gQikNk3p2yvtSlU7HXeY65yQOj0gxUO56R6fh?=
 =?us-ascii?Q?HoyTDfaUndjg4ybifyjWwpDGNyuFHEUV+TvbXVTUqRAtjVyIa32u/u/+L1ay?=
 =?us-ascii?Q?ZiwGq1olTWEuw1MJTNLToVC55sj/FnZoxesRyxMATDa5j7XZMS3Mw7jNg5m0?=
 =?us-ascii?Q?A61H3Gkl2hPXwc6VOo843yhpBm0tcmXe440DSZBTuC9ePiUXM7+I0Y/1JYtB?=
 =?us-ascii?Q?LLcAHpDXA2zbAXXBlZuMg05k7B+bNmIjj13fxRqH3Lt+Nrh6KYd2f3aNntN/?=
 =?us-ascii?Q?OVOc2C8yv1p5YoVUXML1o/RQWgeTNvQ9KbN9BqyGOiXYlwGSs8AyWvlPRSqo?=
 =?us-ascii?Q?TLV0vyHpXKtiZ7FBiynKnd6Ci46RYjTJKXypjfpbToXd1FpZCqvh+GPn0tCk?=
 =?us-ascii?Q?ALUlWzzxYbWf0VEdlnebtZrgLO1uFM6izMPTqjx19uAIjxrQILTdhczrBuNE?=
 =?us-ascii?Q?stF1SEzwB4E67juxWXNLOzpJ0ITXTtUzSe1cbCICCL/w/Ll4+ix08xazrw5y?=
 =?us-ascii?Q?GNr5+/AqJoLv1CLAYcavUkLNQZrk0IAvik2+A0Pv6AjCK97RQeFJyY1XRn6F?=
 =?us-ascii?Q?4k3UHzemBu2UXsoHUTwZ7i0ixO7we496uZDkyvSnvQB+mxQajQxt5s3HWYxR?=
 =?us-ascii?Q?HDZd5mLKmIdAwoKAdCHMaBXiK9u7MDIXxwmF2gCHSjsRTYD7qjA+Yx0dWGxx?=
 =?us-ascii?Q?eck6ZCinfgWHdjq6bNkYVljM3WV55WVTuUjkuY5tSOjgaUNjLuyc2FAAb6Wz?=
 =?us-ascii?Q?tGnMLRz7SUjiY/lxJ39Gk90WxDq0GioPY864YzJdWHz2HLotxwcRUEMBM4TU?=
 =?us-ascii?Q?AKp4D064oyCtWnkLCLhiBbdtiICm1im/Ov60QYgt2YbPc+O7U7gNN1a6M+Sx?=
 =?us-ascii?Q?aqxGjvAvy0i+616RGhRg1cVFrjvcNmM7Hyv/FfPtXT16Z01Gc9tPMc9yg1HT?=
 =?us-ascii?Q?dRXDz5DeZcRWFpHylLY7TbtW3Yvz+6IKGaVCwbeOpN3Ax4CmJ4rpZpedJB7l?=
 =?us-ascii?Q?5F5qrHxQnpfcO3Fd9N3HYnjJFeVdUgxOq0BYu9a3oMbPnIDXyGsr0mf60k4i?=
 =?us-ascii?Q?/e8EY7XwpERT9LNiUKHYPnLJSVzYWWK69KJ9JlDORl7kqrsCroQ9aOmgnGbr?=
 =?us-ascii?Q?53IY4kCIuVZok/MsQMysrB9DocdUEYwigxHi+apd/Gl1HEMpgan++GlPnjp9?=
 =?us-ascii?Q?QNpetc1isDTA9vgOUlnatNnl5NCQG5a3TyK0FzQzWuA5ty9GuS2vqHQZaW1Z?=
 =?us-ascii?Q?2jsGWSmTUnFUMIOgynU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KwBx/0RrvhCfa+oa3RCmhKFo6gBVVOXvf2+8Ygdfg0mzkWnQ19ffmR/mXihk?=
 =?us-ascii?Q?pkg5FK7sGJ0RFkHb1BOp5QDH0c+oB/GkDGkvtu2YYdXYbAFPEzh66rYAnR7/?=
 =?us-ascii?Q?rkUjQFZdwmwoqjIWdNspP9BwOsjTjhPvw14shODyGMH2GefyvMnf9lGSzzdh?=
 =?us-ascii?Q?Ecko7UUOPU65bE2almhuAjqqj77h6X/CTYpV/4Nhhuop43GD0dxEJwFcqM61?=
 =?us-ascii?Q?ggMAMiammuOVQcRlg/hr6NvDnlT/oD3hUR94+2PfZAQdaAkodSjGHjwsi4Yv?=
 =?us-ascii?Q?SZ93f2SvSC1TTcd2wVijUqP8kzkWvzIQjXNVL5FrYvfPehkC/MNYZLbBjlAL?=
 =?us-ascii?Q?WuvG0K0hgnUsMeWz37FZicqtnyZF5rzmW4zCH5uO5RNa76inEObTgaW+9+Np?=
 =?us-ascii?Q?ba8QYWqgq4xeCcwiiFDoGvng8dzux4eS1dULnllA1fUqnom+kT0PASphuMSp?=
 =?us-ascii?Q?MxbPv8c8h3dhEWzYW4nMn89kDBHABXrMbfrfABRgS9YLLzqfLBhO8h9nbIPE?=
 =?us-ascii?Q?jrQ8U1HmrTDoy1m88BXEqmhz3h/1fDkh2wEqoYRTTcvJV8CViSsQ7JYsC4dA?=
 =?us-ascii?Q?hVD+3T43kJ+6QPV6fftDJzATfDEjkjZpoMMj/Bj4z10m1oZxpyFXK2U9JrN8?=
 =?us-ascii?Q?YOG4d6t/QwNBQ/yAxsvHsunJaWoj76KcrzF45mSBenP2eXryQKrr0uLixGVG?=
 =?us-ascii?Q?EboWfPh0aPdXyGYHVP1TERZ9gN3m7v4SxgLL/lYcoNs2OQtzluTqBN4F3y1K?=
 =?us-ascii?Q?FsK7jA/TqA3pmJsYHfXcbYPhM1D3XZ+ZI0upa+3TiIPw/lnJAK4r7AmRy7GJ?=
 =?us-ascii?Q?mqWpU/UtY4ZLMf0BGoApa6RseIzwi1gom9UQHRErB7nG5dCOH4sg8qggkGQH?=
 =?us-ascii?Q?l4oRjAnalYZY9BbQlBo4l0wtJcb95zdVVOtVd3g27NDzE/o5Ww8tIjyCRY9K?=
 =?us-ascii?Q?4TQomDgA6V9MjkhqlpL6ugapTZhVC/z2qHbE6SPD93pUpCfRwS/Jke6MIjmn?=
 =?us-ascii?Q?Zfs8V5IH3dJJgIHP1cWTzwnlBXP5qOMd9sLdMg5ACvq4wMi+Wvi9E6Bh1kWb?=
 =?us-ascii?Q?yf3iZio/NQUp1OAaAXWqTFp1yHwwEeJXcztCDXjUJoxTxNefcTX/s9NbSluf?=
 =?us-ascii?Q?UR6bm4N20vXC4oX32pV2L/tYwsIrD5jgBH/s/YJA7Z5aKEpAS7ApFPVbtuQ1?=
 =?us-ascii?Q?KCQepQ1RhWjB9Wkq2s9xznlbrozsyLR8oycY18D+KcKK0U6iORc6odKhLTkJ?=
 =?us-ascii?Q?GI2jP9q2Fp1pAXUA+EZufzdR6aqZixAC4wFlamAwwRKNpxsh0EM3STcQVEu5?=
 =?us-ascii?Q?+4U2yuJ2qiZttNERyBuUbqDsY0C4MK2qh42UioC+lDJLkExMwHZEF0QYXwuL?=
 =?us-ascii?Q?ERp5M3LnbdZzPAncq2ZEg9+6KopM+n98fBOWFwXUIUC7H+Y6i2eUCoEgXo+K?=
 =?us-ascii?Q?seVLPQJbzar02zxCdtAqX2ZQqEUkcI/LmJccprsUbVZo8LXZlrCwhK6Qi+jZ?=
 =?us-ascii?Q?KxPpcBb1Eia215Q+NRPdnJJtlIx6QOS6cXupSK1eUJG430XjGAyl6lQDgSN/?=
 =?us-ascii?Q?3v6h8nhKbo5JlCCRVUvEUrcC439mtKeQtLz5mObjUk+WjLe+rbaC2tNT8GO/?=
 =?us-ascii?Q?CffoJiq6JWgd/9KQfZ+lSWwVC8q4BUaV5FaMZg3xJAjP0il+wFl82U5HXBoV?=
 =?us-ascii?Q?OvJda8pk6AJmGlx54Rhp4pd3ZIj8/y92bZbDcY3392c0JykWzLzLGc/XgEXm?=
 =?us-ascii?Q?RCtPBMHT9jhtb74EzHqOnyLUdlRDI3Q=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xNNMdzP6ZQ80bS34hOKVXlwhf+Dq2k8Nxwb2Uqje5V43/DmbrWyoJKsjFYxnGLFXG57CVrcV34Yb4ZdVbJwfbVA2VTSNfkk5c/Jfx9kCnSQIggqa2uKprXisQcT9/ThAzm6bPy1EiedBrhcZ4Ucl/1GoLbCP4Qm1oxuanlvuz3bV6JZATPsqYnCIkd7e5eSz250rGsmh/sH+xDzmigECoTBbz2CpQuH24F1+oDgYEit3FpCO82u0BzSLBaTKFZS9jbvBVivkUR6/oOxJW4rtOHpjw2qvrov31PooaXHbz8KNI9Av7LgLnsGNTt2zUYRg/nCd5ycY0MfkJreOWWhH8Vbt958Ot2oSl+/3T2KvBHElZi4EomhApbHo/96lxTK5WwyGc4HuV+PqxxDU4SPx7/bXL7c4dHhqH4MkHfB3kjo5p5AmZxDuLbCH0Aq27OdnqJLZFoCamQFoAdzuaJW2eQyDTzlomiv0WW2WPdY3lZhcrLoCz2wifDB1QR7KaPCDGKG3hMRqibN3+pea+/8XdFq924fKOdgZfJxmBWKswurTR4eazwo+xOu5h32jEzTzF4463ZsvQI442wOFoTbqHcjeC9jPDhIiT2Z5wpCIJkQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c924df34-a4f7-4a95-f9ce-08de59b4d8fe
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 12:50:40.4408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HKFeEhTP7HrBENpmjCWvrKKJGo+nF9YcScs2SHR4mKJWFzYN7Uekb4MKXLgJqrZJUQu8St0o0LGWUK7fMDus29dte+t0DxAayUx+DzqLnHw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7904
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220095
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=69721d28 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=3lrxA4fjdKnX_o0fwtQA:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: i__S2MEXNv5_VKfKK5ah3nDMStZ9UPjS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX0EvJHstbLlPW
 HogOdPb4unVWSZfU9dlJiJL0DaZnVpgzXKX4tCqeNgqo42jg21gguQUdGIPZEJvyHpaDAfPWbID
 Nj0GcQ2Szs+oqPD9IImqSLJEfavDH8nccYFQjoRtyMUvAfqyvprHttUb+ajmLsaHUE99HkHTYRQ
 VgCR7D3ZWzOyKXwhDMBizvvZpxP/ZXygUN59WlWU8bxyYUaBIuQxoKwvi/8lzVf5sJoe41qWy5w
 QWVfl0o6nuz9w00slkgX+W2M+KDiW6yUjSavRcF+qgSb605/Ihx0zxwrQcQ1mnMW80XEDB2kx1u
 4hDTIyMdDsNDi0nX7n/Yzdf3uyQ3IuLOt2DzYrybiuxgHm5KRBVF9CMPNVcrYl4egTPzUXSzLwo
 B/Z4EP354pxy5uX29iR0lMhrMg/p+wyMNLjggIFwhQZ1fIuG62hvep3OlqAW3roI+jlKtd93rlW
 NOKh9phuYc+UvZWqXwhedy7OcqZKAVWzVg49ZWpk=
X-Proofpoint-GUID: i__S2MEXNv5_VKfKK5ah3nDMStZ9UPjS
X-Rspamd-Queue-Id: 882C52000B
X-Stat-Signature: rknew415mtnep4c1iezdojeo9iw16ff1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769086257-386564
X-HE-Meta: U2FsdGVkX1/CQ8Uulyex/CiJByOvMRM+xOmkgJ75wuowS2EiZUVPKAompBerALiCG4Di1/LwyyWm004LjnFk8zXmjCAwRv2EQTgvppiGSYheqKQZ7sZxApyH1Eq2P8efUlO8zAtrQsBQ/i+oz/fCCEiiqJqXPOrewxc2HG63gocrb2v34u61RoRHDuOvrlZwCEnJOv3pbpMn9HnKEsAO+r4aEoKsl8gIdyjwbudO/qod/iP1klkZWBRAh2nmDJ82QVDfa7I3EoUiwoAzzr7EhDA698pQOUWtieqa+E+UYYyQ/IiJmZN+wjPH9OUfA4nZ9eZKpJJAsgpN+BG/3nAfy0U7i/jL0XcMfiL06QF0irlT3yJ5EBswI+HHRN3D7CQUFQqMbuCDwzJRVZM/6kV+0GfgeO04Ar01ktfQN5QalK93iR/xXZrgMfm2pC16DCaWy4Fez74p2Q/OHs+oXI8P0TeHgbAsw56wXjiSpoUxhT0fbCkBLjc5kbDBe3sVLVv8OGheCWCyjZQn1n9/yT384336XQEb4dqlAgppNgpM6u111vRLXROMwtbYTI7Z4aVJG7mdCIVEH2pB3D65JCU7BxkshwXDbRwq3JwbcbNyv9Ek9A0oxXpUj71r30hrow9QoGSHlHWDqh0bwq+vvhk/BoiWKVhuWw4cSupX8fghbJgmEpPh97g2sSosP+PWLPo7gbpTbJvxCSXqaVM+CsvNmo3paj6H5KCgmGcri7jQTUSBSNd4cDj0h6qNe9KfpYLB/8f8c7uf+37yGdDUqB0sAVyefcOqYS428wPNJChEServvMIydHqHJfFLMbonx2qvpQQQIFRLi2Z2KNG84bgO0yMTX/Gc2IB+bftvqg5M4S573G8IqKkxArX3/+8BredukonREy2Ik1ermtc1BElC802x0HhXoD/HxFZl8WO2w1I5YXp0zSnlz1DiLy+aU32ODQoN6m1g+cUPJW2d3uu
 jqHSpVcB
 Q/xjSTh7xly0bDjbe4Eqq+kVlSYSTNJGA+A1sdiikuwdTz6crf59Hpu0GppKfV489hH3HJ1DZYgkCB9nvLk4fLj/EzFRbxga7qgLMBN1N49lypyuxDiSRQkImaX0fYdqjo96KCmwv83vi8HcxT0iM9BnuI5nzxwkCsfSGwwSukzAe7IAjCb5eeiYOULsiTRAtBXAqdrsK364d4i8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We're doing precisely the same thing that __vma_exit_locked() does, so
de-duplicate this code and keep the refcount primitive in one place.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/mmap_lock.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 9563bfb051f4..7a0361cff6db 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -45,6 +45,14 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
 
 #ifdef CONFIG_MMU
 #ifdef CONFIG_PER_VMA_LOCK
+
+static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
+{
+	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
+					  &vma->vm_refcnt);
+	__vma_lockdep_release_exclusive(vma);
+}
+
 /*
  * __vma_enter_locked() returns 0 immediately if the vma is not
  * attached, otherwise it waits for any current readers to finish and
@@ -77,7 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
 		   state);
 	if (err) {
-		if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->vm_refcnt)) {
+		bool detached;
+
+		__vma_exit_locked(vma, &detached);
+		if (detached) {
 			/*
 			 * The wait failed, but the last reader went away
 			 * as well.  Tell the caller the VMA is detached.
@@ -85,7 +96,6 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 			WARN_ON_ONCE(!detaching);
 			err = 0;
 		}
-		__vma_lockdep_release_exclusive(vma);
 		return err;
 	}
 	__vma_lockdep_stat_mark_acquired(vma);
@@ -93,13 +103,6 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
 	return 1;
 }
 
-static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *detached)
-{
-	*detached = refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,
-					  &vma->vm_refcnt);
-	__vma_lockdep_release_exclusive(vma);
-}
-
 int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
 		int state)
 {
-- 
2.52.0


