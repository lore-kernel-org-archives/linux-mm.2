Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE2EE9B25A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 06:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF3046B0005; Wed, 25 Feb 2026 01:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0A36B0088; Wed, 25 Feb 2026 01:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E4E6B008A; Wed, 25 Feb 2026 01:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9936C6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 01:02:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 172CF1B6E73
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:02:09 +0000 (UTC)
X-FDA: 84481933578.07.9BE37F4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id 879C1A000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:02:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aUtNOoNB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iGCO+1q4;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771999325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FB1rXLFhx2LYRC/TfKAmWtWAdRFiJFproy8vahYN2ws=;
	b=SMdd6k1YmFB1XMI0VRWbySPqP8zHylVErpwj0BCR6lLkaZ3LNXzDgnoXJ0NzBjpqQBib2p
	Ldq9VPObfPUQjksAXC4CP9X8Vs3/h5f+9VmH2hWOlzvfUC29xwjwo8BauGDYFK4TL3KnRg
	R43IQLR8m98pdrtmrhM1ee3p6INmTiw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771999325; a=rsa-sha256;
	cv=pass;
	b=ntqm++6YvgW2iOD8TX73rl0duZ9USLy6FSCKbJRWZB1DZx/oU+nhFK0ep9Gbueycr4G+Gw
	qPXuISBIT+Njy35gzuU9HtXV3aSO3guIZJu2LMVuMJiJXGbJBngMEo+5sH7ellfyxUYqAT
	C7qfdoqyRJcb/KlTv55KkJptZgC5LMg=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aUtNOoNB;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iGCO+1q4;
	spf=pass (imf25.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61OIuA4D360731;
	Wed, 25 Feb 2026 05:55:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FB1rXLFhx2LYRC/TfK
	AmWtWAdRFiJFproy8vahYN2ws=; b=aUtNOoNBoTZjyFaqbD44hIVDzN0ui8RiMZ
	y432Rkkgm5o+BopPhV6/xjht3ckc1TvsEeYl84+E0qvAIqbIzbxl512gt+58nhYN
	K9k9rkF6Sy+sGzFD98GOuitNoiagUNMJ+i+C2T1ZI2QQ09UZ4xOsGNM1LVSUWoB0
	lDHba7z0Xq5ijpOpLFhnqp9rwNPvrIYgQ1Y/fS4eQHZpxawEp+ZpeSmKJMPBryqW
	RH56c2boGJKW/5dMuM43XIuBHkUIrHUwWUh5uq9Iql8vIqgZHJ4eT7aJie7k/dy8
	woDGQ1SOFpGzOJAQ5oVEHp2OnaJvH2uDOOKSdVPNuNdratGNR5OQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf3m7wj7w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 05:55:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61P4Rpf6015534;
	Wed, 25 Feb 2026 05:55:55 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012043.outbound.protection.outlook.com [52.101.43.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf35awjjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 05:55:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qVVmKvR/dPRTNRL784wkpv9wBwpn/eunYlW6o82Mei4FoeJ0mn9CnRKYrCLnSRZfahXCO2WnBPnMQmUMUoW1FxZ6C0QLjQKIBWyP+GdaTWHgnqx5BQabx3b8grXXooZan8TgIKrVyAYz7LPOY59Taxuqsp19wvQNzkTpBFN+m5ygh+sJO/FPKRSREp9on5CBSnO4QWNo2LcybmAAMWT7BYboYfJar11FTHyM/JlC+EBjwzvt+ShfCT1z2ptU3XhzfGRXjdsuEMcss6ZVCdBNl27KaV8WUDgPxt4f9MqDI4d5O2Edl21TT1EdQmGODz8dD98eOP4IJ873Ccm/Occr9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FB1rXLFhx2LYRC/TfKAmWtWAdRFiJFproy8vahYN2ws=;
 b=EWtC7WcYdXrbxcC+VdDAxGJYx9WkSLJM0MW4qUYt6EPDSU+SnZ9E0ygaxtSJ/OUO4j2R/1C0M880m2KZ1Kr8hxQPBzjGpkU/iJ9L8gPGRsKIVAcDzhiJGRUIGGyH8sSKukifPjeQNPhbaBrmlR4vrWvzCgmJGV+Fj5cH0tbCb3P6UeLUoIEV2iH4/tMtspvtBxFp8KFwZTK063BiAi1lcPFKUXTpkNmZ+hxH7EI7MU54wbiyxNEB0eytRbR+sjKg3QwQ8U573gq4XlxUj5inVL9pegCnufAstpcRMnWKQFP8LLwGWttXYzID3JnEsGomlakMvzKkDHClcKWKZ8rQOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FB1rXLFhx2LYRC/TfKAmWtWAdRFiJFproy8vahYN2ws=;
 b=iGCO+1q4vV81XVks4TCSKlsTMSWc3JfHf+ImlzD77ztIKo1oigbtOIlL8P7svj/+Or78OUi4rl91xpgaughACTYUAZzVnIQMKLecY0BrtTYpgIdXL6OnZNy5MxhMJjsY0Mq6Gpi9V1LO5R95mWKLPzgVb4GIqv8RlVN0MSdkIuE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH8PR10MB6503.namprd10.prod.outlook.com (2603:10b6:510:229::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 05:55:46 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9632.017; Wed, 25 Feb 2026
 05:55:46 +0000
Date: Wed, 25 Feb 2026 14:55:35 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Hao Li <hao.li@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org, peterz@infradead.org
Subject: Re: [RFC PATCH 6/7] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <aZ6O1-8SLXZxpz6g@hyeyoo>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
 <20260206093410.160622-7-harry.yoo@oracle.com>
 <20260216210755.GA1320175@joelbox2>
 <20260216213254.GA1469635@joelbox2>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260216213254.GA1469635@joelbox2>
X-ClientProxiedBy: SE2P216CA0054.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:115::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH8PR10MB6503:EE_
X-MS-Office365-Filtering-Correlation-Id: 55a12461-46c1-4630-149d-08de7432850f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yknZFddKGHEdvV0VMqQNCcBbx7TlrTwh+x28CvEjbVlH2zfa2wLTzpvCTsV9?=
 =?us-ascii?Q?k4cAQMPn3Ary6fIz/7cwBr8vuCCxDV8F+PgAAKBoXPHl4sh/2OXi254Ce92W?=
 =?us-ascii?Q?zRnCNZ+ArAtVLit0dLweBQ3Mk/igRQ3YL5ZkBJP8Edrq6W02XnNwcqX+uDq0?=
 =?us-ascii?Q?sDuJ2WveN+YmuSA7Q3JY48RrCGddbiJbP6GcIBiQ+0CgOoELfFErmY4e60fQ?=
 =?us-ascii?Q?dEAkCxShK8P986hgXmPUOYivfSQW2TvXyUvcJ/A7UhlfD2e1CXa7VVPXoAeM?=
 =?us-ascii?Q?wccIpSo4ftIjBojbNyv73AkXpTlpTtE83MVRLX4lO6pqztk+k7D1LW3n0Cm0?=
 =?us-ascii?Q?luhK1hDwxDeuqx9Ce/K9zHbvQcp6DIWF37ZCP6xkfDEiycznrTPMM1sBt7Py?=
 =?us-ascii?Q?ubF3gDT7tOycY1rOY4VnySt6/ahdr5+ynB2yCcZC6fd2RU3GuU7F3r7t/InO?=
 =?us-ascii?Q?uaSZssgxRDtuYZT6HS+njoxTEjzWnOgxProegKiYSM+zZaoWhB68Vmt7wRVM?=
 =?us-ascii?Q?Iw8t+1VqDAC1mi9rlfDRx+ahSQjNlK9VnxtNhFUZOxG8py7Y8n5dkwMHf7vF?=
 =?us-ascii?Q?EEz5Kz68Q2j05410qfHtlNVzdHr0SNCPWg9ybDqFSvRizFLv4x0DIxFvy6fV?=
 =?us-ascii?Q?N4SsWd6Cmff7Hz3xzU1BAqQYWS5b7EffkjfQzHyJyHlavbMOdbLPgfwYEjyF?=
 =?us-ascii?Q?qa6G5AbNM3IujTrAs4ipYcdiMVF4G/qCdUbpGo/0d1FaI/HtQ7IvchcE6b/4?=
 =?us-ascii?Q?03nz8mruOBib/rXejUbZL8ru3CBM7DwqYAEsTiTs6ZVII2VHHgEKHs8/BjbZ?=
 =?us-ascii?Q?C6n4XydjP2txqETakycje76O/f30TC1UTK6+jG5lTFPkw2I8qxdF98CkW168?=
 =?us-ascii?Q?XVfM6GbY3ZT4Uybn9SlKr0F8+UMnfzfiAQQ4S0ueRDXBGYgEOHOkJk4KD3rf?=
 =?us-ascii?Q?5+KRCZozdAsjAnMWCOk/0lewYYqwfVHb7UrRUI6fP77wSincMKR3ZOFRXH6G?=
 =?us-ascii?Q?SkRJRaCvAil0H75vnMEne9qLs2Vp7UkCbiE6AD1rTpuOMWVHp7w14ZSQQTzN?=
 =?us-ascii?Q?MGCQ8Lb3zzbkbmJRHDVXBBP6V2n4EvD8dUJPXmdUQ0PvjMS1SZUmn3ryU0fU?=
 =?us-ascii?Q?zT44q6KsRDN4OZItz2BE57xkJn2VeRsE6yU6crQw7mEBT2eRC1W+h0sRusb3?=
 =?us-ascii?Q?7rs3cLNn84+dBvoFhJJa5QEhk6FPGfZJT698amGs+PHUO/UU80DmQCQ9e+vA?=
 =?us-ascii?Q?Pi0LiPTjyUdZyOfNnURV8DDvZYOeRyUfiqBKJ4OVr5tM4pnl9NC/rnR+JbLb?=
 =?us-ascii?Q?cuBZsSqLrumYwfE/nrcpCT5sbhVeYK7utTXy1mzexm40+NJxZc8emRQdrhAX?=
 =?us-ascii?Q?EKhLLofRMkz2oit8okvdesiR4Zg2BorPIJGLGOgsNax6usun3nMc1e/EjS4c?=
 =?us-ascii?Q?+0Fmr6ihckj+IsYAcrTBW4CF6mGbXsuD1i7WoeGy6NRaOfaEeOHwFL8aoQTu?=
 =?us-ascii?Q?RqVmRYnwpgPy40zJb3Byz/v5nc5cnm1HTUm9QKq4E2nKD321rfqjqYKJNQ9K?=
 =?us-ascii?Q?xp2pz3ZFhEzSZ61eRoQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Q6xfka6B+gSr3WBd2oDqAQEuSPMXD/uhKOKh2uvmGS4IP+fVS2pbfqWAZ7/K?=
 =?us-ascii?Q?9oMifXz6VYTxioEXAsvDRtdo2Rovjj6FJEuwZ8V1w+uQEQVCnBPt0lcCE0R0?=
 =?us-ascii?Q?TnFj9WQdWfSONIk7mmsAmw+/ZLDaIz61orBFMhVka14UcTqb14cDfIQ5Y9qu?=
 =?us-ascii?Q?8lnm40psdfbDebDj28fHZEkzh2Te7wOTSpQpdul64L9+VJIjS0V8IAOQCeSm?=
 =?us-ascii?Q?+cF3uhcQaSJ7rj8pPQAzHtVauUl6qm70/opfJI7QS6JPTl3fuSrvIjl0x48n?=
 =?us-ascii?Q?uOntylz89M54QA0cvKEr7Cl1KIwoOOxYKWegu6q54McGFrqxyUUi6VSdmkuZ?=
 =?us-ascii?Q?cEbYtJtqQ3mg0V5Zn/ox7kCy5TtaNEzzt9yMdG91wD26SfSQuZh/4uxqCwGx?=
 =?us-ascii?Q?rLv6vUecsENIeQQVN08WmBOLD5TjZA+2cPyD6W2Iy6H0GjUgwpJdkTKfeEpO?=
 =?us-ascii?Q?Ah2nVPflZZXWJ6B8A8V1umKUVLHMVBjDB/fITZrUwhM5XQMA6M4YvUy+KCxu?=
 =?us-ascii?Q?Pp+W38ja96CJAihrnLGtIaOIhUG0OSWzGNHxW/UD+RaU028heVheWxr9/B7v?=
 =?us-ascii?Q?xZSV5qcK/qhqG4S0RExdckHB5CDcR/Gih+q/wyNlIjMaDeArD3VXN5SJsoPb?=
 =?us-ascii?Q?Hk4ELoQk+Fop+SCL/hz2YG0LyvJ2EQo4/50b/KPdNfXz/oQyWcIp5doO7wBg?=
 =?us-ascii?Q?KaQHJsYw84Emb8ATOLSOVRgOL53WRpeAOCgXf8WMk+rsBtfIbO7/htk1a/Iu?=
 =?us-ascii?Q?SC54EJlYtBnurNOd3dD0WdzKTTttQcuY2HnwnLpDVyb4F6XQlilVZ0l9Q0mQ?=
 =?us-ascii?Q?wbD9SVPgO/Oy9Hs2KBE3Jbhg0PVAbbQTt78W5jobe9mSRphu1yA6hcuE87RN?=
 =?us-ascii?Q?3Q81JAZWQMKxqeGOFjVuQp+ofpKJb+2lltLKMZOw9WPUi32Kew1xGi8BuoFY?=
 =?us-ascii?Q?L7hS5t35nrO2nsQkP77biYiEeSSV29k3KzLcxle3BCHPH91SpC5oLuZUi0ev?=
 =?us-ascii?Q?IJ/dbIdXCOcYHxpTuFtQrwK5p3kQSNQJ/jCVvgaxhdkcItSdFnVNGlMUTYXv?=
 =?us-ascii?Q?eV/4T7CnXrO/jfO8h8CaFrKacT1fkIqCjiwDnXvg4v8INmIEFhRp4QBexTEb?=
 =?us-ascii?Q?4MB5gNI5EOYXUezHz7GeA64vuLM4qsdRYMQ2EBqK2FKgth8gN0fVlbfUybEH?=
 =?us-ascii?Q?FGioqd/nru6w19T3JJXsYkdjoeOritx5er7BfykB3tTqkf20dcvM+YPOqEwm?=
 =?us-ascii?Q?IjYpjFjLsROcpVobh+LfezWGyn/8iKLwJT4+jLAwX65d2rpGcdpnRQph7rAY?=
 =?us-ascii?Q?yASHnAiZRn2eJmAmniB6ah/GalhyzrJwTkRPjK0HI7G7qR6HijSlk/TQn1qS?=
 =?us-ascii?Q?I165EjAWMKa1AzBFni5bs2dpr3kxwc34xJCVToZHGpC/IT4H6uT7YBX04tq1?=
 =?us-ascii?Q?XTfuYaVPqCIMAbyLsHRyE18WPSRgK9yAYEIbgeDDoqz5V7TCRkQmaYB+40L8?=
 =?us-ascii?Q?al20UCoFp32IXlDqQxZu3gZV5umuZ9xWX3lFidn0H5++9ZtCfdEeI+zzu34b?=
 =?us-ascii?Q?OeCtjQ5NddmYVU5yBDKQG+USBqrreiA2AysJAr3Rmr0OURUg2EW1i2QpQZ9x?=
 =?us-ascii?Q?I/vynmHTmoET4h/ZLZOhUqlDvfGZUlgWP/1o2QCUwdRz5KT8nvD6oE6qgqiI?=
 =?us-ascii?Q?HoNhVMLU+kkPW/oKABuwqPBnR+l5/dmXV9lfygs4FikK1b58c1Ys29Mxr5Pj?=
 =?us-ascii?Q?fTQIZSfBQQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NzB3Btz7xN4OhmEebizqcvq9MUxg8LTJ/t32ftN1BqX5sN5eCQ4lV77Spekp/baSojHYoYsbNACS/8HPpcwsvzrpppHkrGiwPH6RXDHbH51kx7kMMoVCB4VlrooSqyklTp3gHhnzayRxIwRF7JY8Dm76AhrxlHSBaeQQ7iNqm+aCHrPgL0KYiW9QBMcC+tjMsYs+7glws34FFlGADAIOJuh2zl0bD2RI1MxovUGzTdLj32mhv/z5CUD/N1ZbW3/nUK2RjibjO8J1W4Xe4kszdqtMumaOjbM9mIW1rIHLUC3M/R2/P5teC6dx34EZ/cr7lHYlTVXHAEOvMQ4BWq1QoWx9621SVwaWrQ3/zPEep4YNUkwOezR10Nd8ufnGcrwdCepC9CfD4g21pq5qdmavudMKso3NL6Sb6FNdYwRSnMr2wvtogKbb5VLPNGaxT9v7RBwXniD4VfQTB8t9x+e/KzKXj8/8/xQULYFNuTETCYgqfBl5yM3yLNX/TDP0sW6tLsjRwwopsA8fRpvO8h3CFSjBgduHVa8mdwO3iJ+a26OlG2z2EpSMexxQp4bBHj0zF9PejBiTdudf1DCVTXKkwe4YxBPQQhD4q80D+loiL2E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55a12461-46c1-4630-149d-08de7432850f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 05:55:46.4937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ChhaC0UZvXKs8ntx5h0mhcRaK+EaNZHucXH6+q99pmN69Bvr7Gk/9Pn0t+e8dVcVjVyqKmoGaJaejs5xgID5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6503
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_03,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602250055
X-Authority-Analysis: v=2.4 cv=O5U0fR9W c=1 sm=1 tr=0 ts=699e8eec cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=tGIt6hoU7VFQY1_QeA0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: DyVvEe1CldAA-lAi06IdTmgeR3sT6aGp
X-Proofpoint-ORIG-GUID: DyVvEe1CldAA-lAi06IdTmgeR3sT6aGp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDA1NSBTYWx0ZWRfX4pmd1pCuqYGx
 tnJ7WllFHpvHIPd2CsuEhHDfHpJer30ZuO2Ru6kIb58MqdgDlbs3wBSmNHyls8AxKyduHT1sIdz
 4pAYcGUHo4HKQeXYMVz0bueDyOYyE6eEbtLSWP9IJ8TZuWlJCElKMT8FGVIAT5JWyV7S74t6SW4
 yf2/9VYn8lWmNQ0Rzpsu95NCcQjjTroGvNB+Otmi4xzzBAo12w6FillfmkguuZcaD482hqNNHa5
 QW5Sped+50J75L5i8ZLGaQW3NKNSlbYcjc9nb5whzbdrUnS48/J2vsqgXdSb//jN4Rm1gKJuAdu
 bA6OfQbBFKJoYtFkbkfnCW0KDiIBQ/s+GP6V1Eh7josHnLaHolYumch9Ae5gdwPEA/AAth60XYV
 +4T8EuIjxtuX6DyMoHW4jblTcfi/s7c49o6IY9rWN4W6iPXvJmHr4qcls7Yjvul4CFk7uNKkP4k
 tpaKLu7minma3id/1ow==
X-Rspamd-Queue-Id: 879C1A000A
X-Stat-Signature: 66ym4nnujow3pgg5fd748s31u9oik1cs
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771999325-689024
X-HE-Meta: U2FsdGVkX18GjBcfoHyIWJcVPEhmyazMBMlBc6NUZzHJs+LPumFMGkO1+YzSq28oc0CRAGxXqZvT/69XIRjvzugBUvex7LyXqMdjFGzoEw1JqSYPjanR4Rk7oWiQCgLvd7eDpdFfs3mpTGszni595mN+JBe1xsnnmj6c4qZ6EYAWrs0SY5+V21jadr6/17V7t57nI4aRk9CSPrCuERXpsGwsk/Ko7JCwBPctm7h9mfgN/lniIQZKEgioP4HoOs+0kHXwGiHXgOuZMp88GELXRKWZqtv1cWuG4K8pBkKpvwOxrNdd7huufaeZ9TOBsUJgSVcOvbnbtCfQOQk+YzA70EvNI1mWyIOdIk+fRV5sGkRQoMNdvJEkldJjT5IywHT1SgkiRRzVrFnlDXk0NaK2bRVhHzivm+O8ZXOmxJotLYibby3uguRLV2brmVJWHksxtgliIpYmSc7qgVYTHFmjo7PEpxv93yfDTZMk1v+IXKsQrcSWnrnBDk4ZMDCdYS8wkZbglZ1OhDgZyJ4B9vXXP3NxnkUu/kMEuoCAeR8IQiRDVoJrHTeCldItxURDX6dfiP3lF1Zu9Kkek2JfNsrSvstyuzboNClj6xHUev79FssEV/2akoolBvEB9Sg+40ewbcOxzfSoFz5jZ3wadNDJYsZeRP4lxi/74IDK55El3kGbxZGKul71qJ/32mAgcW/drAyFZFcT/s9JzJXduXabSpkiATpa7BIzSnO2z9NaLrElQ/uIeF49zoLVEOId2SUuIg0XVfqTGEG7i9vV041StXTHC7b+JBRyhurwmlm/RLnK11pTRglnpnCiOlwg+WYASyW3sOX2b+nHd2LnqxLKP0f1TWlbOLd56bYumxypTM33UvA/6/jmmU09FuEayNp9Sj/XYIvmWm/d7ZF0DEnxnFrtLMWefL54EQBkdF28umwDMPBmtFzS4gvnXq6nR10yNbeajt6HTCCXWv5g54O
 zDGMQsgI
 uiaJwj2SfVzVvG3pIOgMcWROKXje89dpW7P3LxSshMcIUyTCx9oi+Mmmv7WEnbTfEBGFsRbksygBp0EGGj9NPMbrbvRKk0Db0Vnun4ok9/LnzSS6JPiJgGNcEz+Ifq6HKbHSS9r1hR3p+vY8EGT5efJF8OrWX/An2xfdUy98odPLytX737jr+ssBipMa5B75GiGTOdmgI2GpJMwhVzhNU5HRLcUZeqVd/ju0Nku61twKHotdonXehzH+cVYCOwCLXC3Wz3nQuSZpupHXz7B/F889EuVfkmfUzxh2l9Sy8FIvubLvps6y1XmFN8UzSGXrj1Z0f0MfaTSe9nZFh9/1izE+L3O6OXSC0GSkyhoFm5CsN4p/sD2WITQYBWE5GvGZqtAHJp67ZQUpT634mL8PIIAyijPEqXZ81HjvLhYbudgqvfXK1PeL/dEOiPiSFeWRcBdOmtaDUZVAgdXWhl+nCK5FfA9A4TLqickYQqUbU/FmqHYoS1F3q7k3O4N9OMGB9KZJPkYhC7gt6E96mO/f1hgZ0xHsheMHQncj72V8f0NmPhKRIYfOMntq2s0ZE5jWNh87z/Pz4S7UAG8sOp6PYDogn8AfKNHk8NQ9M3j8FsXPUc1xDI8G6RgsmEz0BIN5AKdIhuCJgZD0DZsVeuBb4qltZDvcsSOLOHxfG0Sb7POHZFLRBtyZoBf/qM8gDI++wmAZ3AD3QGU6vPiiH6VQIwa4oxLiJtoIxq4Lzxz/iCmw5a1gN53kpR2279Qc31IYEdY619Glw+VYKC3Q/A95d+6uW4SajUdtgNQWkXy2UE1+kGgUy+cVOOyEOGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joel, I appreciate your feedback.

On Mon, Feb 16, 2026 at 04:32:54PM -0500, Joel Fernandes wrote:
> CC Peter for real this time. ;-)
> 
> On Mon, Feb 16, 2026 at 04:07:55PM -0500, Joel Fernandes wrote:
> > Hi Harry,
> > 
> > On Fri, Feb 06, 2026 at 06:34:09PM +0900, Harry Yoo wrote:
> > > Currently, kfree_rcu() cannot be called in an NMI context.
> > > In such a context, even calling call_rcu() is not legal,
> > > forcing users to implement deferred freeing.
> > > 
> > > Make users' lives easier by introducing kfree_rcu_nolock() variant.
> > > Unlike kfree_rcu(), kfree_rcu_nolock() only supports a 2-argument
> > > variant, because, in the worst case where memory allocation fails,
> > > the caller cannot synchronously wait for the grace period to finish.
> > > 
> > > Similar to kfree_nolock() implementation, try to acquire kfree_rcu_cpu
> > > spinlock, and if that fails, insert the object to per-cpu lockless list
> > > and delay freeing using irq_work that calls kvfree_call_rcu() later.
> > > In case kmemleak or debugobjects is enabled, always defer freeing as
> > > those debug features don't support NMI contexts.
> > > 
> > > When trylock succeeds, avoid consuming bnode and run_page_cache_worker()
> > > altogether. Instead, insert objects into struct kfree_rcu_cpu.head
> > > without consuming additional memory.
> > > 
> > > For now, the sheaves layer is bypassed if spinning is not allowed.
> > > 
> > > Scheduling delayed monitor work in an NMI context is tricky; use
> > > irq_work to schedule, but use lazy irq_work to avoid raising self-IPIs.
> > > That means scheduling delayed monitor work can be delayed up to the
> > > length of a time slice.
> > > 
> > > Without CONFIG_KVFREE_RCU_BATCHED, all frees in the !allow_spin case are
> > > delayed using irq_work.
> > > 
> > > Suggested-by: Alexei Starovoitov <ast@kernel.org>
> > > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > > ---
> > >  include/linux/rcupdate.h |  23 ++++---
> > >  mm/slab_common.c         | 140 +++++++++++++++++++++++++++++++++------
> > >  2 files changed, 133 insertions(+), 30 deletions(-)
> > > 

[...]

> > > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > > index d232b99a4b52..9d7801e5cb73 100644
> > > --- a/mm/slab_common.c
> > > +++ b/mm/slab_common.c
> > > @@ -1311,6 +1311,12 @@ struct kfree_rcu_cpu_work {
> > >   * the interactions with the slab allocators.
> > >   */
> > >  struct kfree_rcu_cpu {
> > > +	// Objects queued on a lockless linked list, not protected by the lock.
> > > +	// This allows freeing objects in NMI context, where trylock may fail.
> > > +	struct llist_head llist_head;
> > > +	struct irq_work irq_work;
> > > +	struct irq_work sched_monitor_irq_work;
> > 
> > It would be great if irq_work_queue() could support a lazy flag, or a new
> > irq_work_queue_lazy() which then just skips the irq_work_raise() for the lazy
> > case. Then we don't need multiple struct irq_work doing the same thing. +PeterZ

That'd be nice to have, yes.

> > > @@ -1979,9 +2059,15 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
> > >  	}
> > >  
> > >  	kasan_record_aux_stack(ptr);
> > > -	success = add_ptr_to_bulk_krc_lock(&krcp, &flags, ptr, !head);
> > > +
> > > +	krcp = krc_this_cpu_lock(&flags, allow_spin);
> > > +	if (!krcp)
> > > +		goto defer_free;
> > > +
> > > +	success = add_ptr_to_bulk_krc_lock(krcp, &flags, ptr, !head, allow_spin);
> > >  	if (!success) {
> > > -		run_page_cache_worker(krcp);
> > > +		if (allow_spin)
> > > +			run_page_cache_worker(krcp);
> > >  
> > >  		if (head == NULL)
> > >  			// Inline if kvfree_rcu(one_arg) call.
> > > @@ -2005,8 +2091,12 @@ void kvfree_call_rcu_ptr(struct rcu_ptr *head, void *ptr)
> > >  	kmemleak_ignore(ptr);
> > >  
> > >  	// Set timer to drain after KFREE_DRAIN_JIFFIES.
> > > -	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING)
> > > -		__schedule_delayed_monitor_work(krcp);
> > > +	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING) {
> > > +		if (allow_spin)
> > > +			__schedule_delayed_monitor_work(krcp);
> > > +		else
> > > +			irq_work_queue(&krcp->sched_monitor_irq_work);
> > 
> > Here this irq_work will be queued even if delayed_work_pending? That might be
> > additional irq_work overhead (which was not needed) when the delayed monitor
> > was already queued?

Right.

> > If delayed_work_pending() is safe to call from NMI, you could also call
> > that to avoid unnecessary irq_work queueing. But do double check if it is.

I think test_bit(WORK_STRUCT_PENDING_BIT, ...); should be safe to use
w/ allow_spin == false. I'll give it a try in v2.

Actually, I'm massaging v2 to make the allow_spin == false case behave almost
similiarly to allow_spin == true case (scheduling delayed monitor work
only when needed - as you mentioned, allocating & consuming bnodes if
possible, and running page cache worker when needed).

> > Also per [1], I gather allow_spin does not always imply NMI. If that is true,
> > is better to call in_nmi() instead of relying on allow_spin?

As Alexei explained [1], allow_spin == false implies that the context is
unknown. It might be in NMI, or in the middle of kfree_rcu, or something
else.

Because NMI context is not the only context that cannot use spinlocks,
e.g. kfree_rcu_nolock() may be called in the middle of kfree_rcu().
So using in_nmi() to check the current context doesn't help much here.

> > [1] https://lore.kernel.org/all/CAADnVQKk_Bgi0bc-td_3pVpHYXR3CpC3R8rg-NHwdLEDiQSeNg@mail.gmail.com/
> > 
> > Thanks,

-- 
Cheers,
Harry / Hyeonggon

