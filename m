Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DEDFEB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91406B0092; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51606B0093; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECD16B0096; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 973E86B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53CA4140842
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:17 +0000 (UTC)
X-FDA: 84413523474.06.2DA92C6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5B62C0010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r9Vx0f1k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yd4YvniS;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKkjmSBUGRjoly/+nShsD26xNV8Qphw999ArVcCaMq4=;
	b=Yzf8nsMihOCR+W9i+3zRt+eFQdmCeaEpf/GcJdhB7Nug51QJLr9EW8w9FsXQAnIjuTzmWs
	9+Qryc8DFgn9k2w8x92OUUWKiCR/TuUBf6TMJMYk9E01T6XwDjGY2mWWxHMgwfSdvSFJ6H
	wxz8KBjUWRV6ZA2hVk0Eys1ZDnJcemM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r9Vx0f1k;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Yd4YvniS;
	spf=pass (imf28.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370514; a=rsa-sha256;
	cv=pass;
	b=ohJlMDMG+D3+Z0THFokDmMPW8j4/CkLweWcQzO0PDZCdYMPqTlI9oMogeI2cJoLMVas18G
	gLIkSwCOj+yBJFcfVJ6JxC2PJxSBh3gbO/kLJzMiiNnnmbV+HDtDWNLbBEO8DFPviszldo
	4Xv7hHTD6IFFAi24pwE5vzCLzFSWFj0=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6165p0Bu839794;
	Fri, 6 Feb 2026 09:34:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JKkjmSBUGRjoly/+nShsD26xNV8Qphw999ArVcCaMq4=; b=
	r9Vx0f1kXZKRyI6N+qCaiqrx+A5YQVN5CWWGUQ7vxg7p/r7mgyCJQqBnMAVSUzyl
	dhgpWb0zxr3VoeugWBXWEOb7H0htuQSMWcvS6Wqgy0csLSvdpxEbp14g513MFWkJ
	w6IH7zKXpktvlaGCyf281lm3sj8BlAPm//QashH3i8CCdfKbapzZr7Wm0oRXX2ai
	x5STIyrgTdz/6W29A+osXEYP9OFJUUjgEVGxQnQatYXE6q+qJbcPQUDrozwrTfhX
	M8rE0e2SrExxgmdtsLlR0QsFs28j6dlmiZ3djyiEQhoYQVYHZJZhfYvAeAOHGwGI
	+QxKP4iP6wS0uqU+22VzUQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3k5g51px-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6166fFxk030591;
	Fri, 6 Feb 2026 09:34:50 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c186ecmw9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKQZ5F4dS+cXtxeMB5BMeZOhlKIRy8S+9PVj7NRvTOKuFmV5jCvrUaxCNs80xhygnwd6EyL+zPY6uO0vzBFzBH+0QZPjUyBt4VxIVU0aufXO8XbUC0Jz4lLC1qL+b2CoiVtYrnqKZUn3nK5Xzlbb5pRj2BFOnkU4Ka+IUkn7avg4NQ1FXh4Nk5XDBRV9M4bkReY+RLuI7wUJMpk3ayZLKXJkdA3ely+vD3ukzPxwj6KuBliaKJI8LcUJL4QIAQHg3si/xitRzucPXTkw/nTkiS+LdsIrXxVB08I/drtoelntCzY/Tf/bfS1Y/Dud3I21/Rd9A4v4TRGWC1RKc3UKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JKkjmSBUGRjoly/+nShsD26xNV8Qphw999ArVcCaMq4=;
 b=vIFf1M/kIecV4sNhxLCFf6LfIWUrkjx9QQu3ICipvn6Qt8mgJh6JijegYpmKOdBBP04utNBpFUVjusMfmuGIqjvM4AqUvYIwG0/lhSL2vz3lWOTZZonuunRQgbp/iRfGBI3ku58UUwaAPuaC7jNBM1PzSgwexFjWn0MvEcBoODiC8Sset1uuwkqEc2mIScGob3DZWui7zvnovaUjRtOSWFXtQjKm1DctgcLkuaa5a94XPJ5f3k5+l9uIznkIvyQE5YwhTiPa0bhmgIByq2AMgWs79c4jyvpAPXwX7KzukoWOYJf12zDr/XNC3gSaZ8/CDbtPII7mtAeMCur1vJS/Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JKkjmSBUGRjoly/+nShsD26xNV8Qphw999ArVcCaMq4=;
 b=Yd4YvniSYUcPmDCO8F8mdlrd7+Ox9yqWE5HFYLw67aJsm7vxkSmUwSnLefR0zz/9qh0IYf5PnXMpbErSf351jarcYJcfWFRAywucVrkPhmT+nUZ1KDY/0BkeFJ3tV0dwL6C5oicHmloOMATW9MKZbfEnqe7WbMTC4eFDCe7/MEA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:34:47 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:34:47 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
        Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
        Puranjay Mohan <puranjay@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
        Joel Fernandes <joelagnelf@nvidia.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Boqun Feng <boqun.feng@gmail.com>, Uladzislau Rezki <urezki@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>,
        Dave Chinner <david@fromorbit.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Muchun Song <muchun.song@linux.dev>, rcu@vger.kernel.org,
        linux-mm@kvack.org, bpf@vger.kernel.org
Subject: [RFC PATCH 2/7] mm: use rcu_ptr instead of rcu_head
Date: Fri,  6 Feb 2026 18:34:05 +0900
Message-ID: <20260206093410.160622-3-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0140.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:1::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: 881f42fe-697f-4d0a-fcf5-08de6562f7ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aC/SqC8glPx09o0tyAn8E1F0VmECGH1hRKJIOvSXSYhTwIuh1kl47uHjBAhX?=
 =?us-ascii?Q?8xcP3qgFxftKptIai4l3sESsE7dg3uG4v0IF+My4AouCn3Efv7ZpGiE7kqwY?=
 =?us-ascii?Q?K5PIPDKTJr3IIJkzW4BmgpFUD2T3TbPPUAa7XJnxvLFd4MGCqCsByR2lBn6y?=
 =?us-ascii?Q?mX7LVBmexWUsuad75Mg8V8GuhbNPYlaNVgjJURv0J6BkgAK+d5yjpkmas9G5?=
 =?us-ascii?Q?h564lwr/csIdr7V35ZjSqwzP9HHqzKW1wLA79M9MHIII0yNDHl2q03RIIAfF?=
 =?us-ascii?Q?Eq46fSaHhgvY8ybyrHtz/cGTP3zPQsgZU8WjpCFwTTygzHOQVTpO9eJDDfdC?=
 =?us-ascii?Q?m7ocY/ZA7Q+KKPEYSCx90GD6Zo5FnvJk2nt80cnrH/hTKvK3EyDOwrI2Yo4B?=
 =?us-ascii?Q?/Mbb23jZqQ172D2r/CWwswlghvJnE//eJw0NcFvnx5pReNAL2tR9RCGeRHl9?=
 =?us-ascii?Q?RBiB0Xj/7WI4v2lXPbMoZwrET7EFmFDBXsDB/KbddChht5CXHKvbgCJMyYZ4?=
 =?us-ascii?Q?rMw3FySD414hxyKWc7kYAuA3/wzCygFB7onffshl1rGCFxyZrWLBbAKI6gVb?=
 =?us-ascii?Q?s0L8ODNpYNUXzI1cZ8JBoWwT6E7YEbb2Mn/2euxKY2lkIBgO9ZhLo+lcRlxK?=
 =?us-ascii?Q?X+qLk+Lqd6keQTf4u7oTgBkE4yiMYX9CbhyIAx7+ID1NZmQwW6GiqIilC/Cp?=
 =?us-ascii?Q?v9/qDAKY4qlX9xVlEvf+plJ/xp+8hmktKTifbJbGokQ7oznBCsUmsMwqB8sv?=
 =?us-ascii?Q?0AjJMlWumQFwpwIaBmQ6tHlGTfmsIEnEH9eiWtPQq5ZuCnZylglOO1C0xtQa?=
 =?us-ascii?Q?7F7wB/DtIX+DSbDpM2nkcxCAuDpk0O9mzpdOcT7gmdK9id2cw/uazyfTgurs?=
 =?us-ascii?Q?1MoJ5zL4EmmlhHp5HU/6Qq4ZcA7PwPQ+b9a1h9tCjLrk8i8n3SunDgsvLpNP?=
 =?us-ascii?Q?XMpOvgPidDvzeAH2Ks1h0JjXzYnY2qBj3JMDp4YNTgoIFOPBHLEjlBgxhDtK?=
 =?us-ascii?Q?k07RT9FGilAAtyYC09t4Rk3IsG9hjPoiTuslbpqkh30aKE1tAWHGOADjFbni?=
 =?us-ascii?Q?ZxF7RywPKFDJZmKCub1K8/Qj6RzDI0iDdQky37zh1ghhq/N95F0AsMpQD5t9?=
 =?us-ascii?Q?icDqBm4Ba/u401mhCEojA/XWMwptROelMWN6bfUUtc4da0IUdwcZjvIQhgaU?=
 =?us-ascii?Q?qHWCgseGW0X2mGfopTg4v85tKosp6qyi3orR6e3z1PNRYgOOCey54vwdBXIe?=
 =?us-ascii?Q?/9FMmaF1Jb9eh5bS9mTz8rdXyXyMz7XR1eza3fiPIfpPZttN0Y+3tNQ1BdZB?=
 =?us-ascii?Q?E6B/Thhs600Xfel+W/7glpKjrbD+j0ezr6jq8SjzfCjlQCzdAaBY5IlpH/bF?=
 =?us-ascii?Q?eiAd/OKcrOI/uGtckRVBrnoli/PPuZMf9AKqXH00wyAXq3KJK18SqXUwLRmT?=
 =?us-ascii?Q?bxTxh7ONnYzkrM/PyM7oUHdvOBV8tkB7LfA1MOSzxLh0bQwFTpxmW0RhppAm?=
 =?us-ascii?Q?Wz46N+N25+HTa0VoivIBOQoJW+USOof+flbHsRGY7RPkYAyyHE+2NbO7ix+J?=
 =?us-ascii?Q?NbVlUPJnu5bfNScWp7o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PrQJrO+Y7pEvG9n66eyIHf52OLkLfFOUqvVbYUrBWMT0xQZ1xfIKT3vjhMYC?=
 =?us-ascii?Q?0RtGDOSqF2zV83INafpM7ipBhXNbtncyyGK6uu7V54FNzg6ZMQEsr3BZhAzu?=
 =?us-ascii?Q?nu+cM4LYu6kRLDY3nAXrv0Ehyd4OMnwlUP22gUzc+LDy5obCM90vFlnYa4IN?=
 =?us-ascii?Q?VTF6j1RUwF4SSthZKa/r3lRo+K0IJ9qJdpoI11rJTEUaaAjDCb/n1oM/iWJW?=
 =?us-ascii?Q?MXI7+Sh2Maz/xqg3vpHqdxToLSEJz5fOS8v1shSps49qbmXUnYbX4hhdC0ZH?=
 =?us-ascii?Q?2LLdGmTLLwkjiBrEgHpGC1jkIcVEBM18fDqd9yFO4NjkB9+KyUYWPFMDbPSe?=
 =?us-ascii?Q?+mTUzlvygef7lhCeyE9kNa9SpbsqRw/NGvh4uPvp4giTAIVpuwqOgNatqL37?=
 =?us-ascii?Q?9/t3to85Wx2VNQ70WKtvfXNTH/4zNiPoYkY9bSLGQXwzPCNSvTnktk4lFXmy?=
 =?us-ascii?Q?ZTJTkFKCKby/Z9uvykYeY0tiYgBeFYfRtZ+jh3FF9dSSYsllvl3USdXlRjO0?=
 =?us-ascii?Q?dp+H7MVvuzsIfJDRI3xHGYW1zO1wYbphF0tzKTeMxIMRpn3JCwQZZiGENiMP?=
 =?us-ascii?Q?7wrLqaWrgy5Hr8y1HdxQFHdqwypuOuAkLTlbPQst2wKmXQq3X+M8ygvZSaxc?=
 =?us-ascii?Q?MWvSTSDSWscUgKD1y+Ijtq8vbJ/yXYoSIf8q/jP2scMndo8U4SUBAexCZQBQ?=
 =?us-ascii?Q?+vw2g+AP9vB6hCkYailW1rEb+X8XKZi7Kt9gKN6ju+Uwp572pX5Xmk+4L9Bx?=
 =?us-ascii?Q?jkJR9BUIJV5i6r/HUJDGV/oEHO4w53InIM83G5Y4H2PEvpfP4VudbrCAXgmn?=
 =?us-ascii?Q?1azKBhR19ETxaOfwda0A6KvmLY1sEOBvRGLVEfpIh7U79ZJ5KbH3A8tDevUb?=
 =?us-ascii?Q?fezBj/j1I3VvNSCpwaGZhdg1KgC/2y1neZrUMiIwnRYQhiYXa05B/B2NuHtZ?=
 =?us-ascii?Q?jqIUrB0Qbg/Zh4DR9bwhYI0RLovjeX9vJepWtPG0ix1fERd8mCCUPUg6PawV?=
 =?us-ascii?Q?3CbzBNzEsAnwTXA1hHvWf19THt5X77k/JnGETswiwLG2WQpNgeRl4QpVRXlm?=
 =?us-ascii?Q?9eBKGH4RpJEywuMTGQELGDRv8irV5E8U96O54VvJ9Y87V2zkk5GCpAd0tWNv?=
 =?us-ascii?Q?qXc8dUoUzhGRk11Wo1CyuB2dUpEjgNOjCNna9vlxAxVIEUOtOsbCpfAjWKLu?=
 =?us-ascii?Q?02cV2kZfELEboBGnyd388dtDkCjsEYfDIloCbSOacWOADiDAOEgZx0oM70D+?=
 =?us-ascii?Q?OQwCYwxYC/dA9Wz6QJIrKWUMPQUXAwH2oxgSf7BO1ZSGfUgdofoyXY4ArgY4?=
 =?us-ascii?Q?booyq6UNuMq+/9UsHrrC2Gi+iXpiaa+k7hZomr5fmv4iamc7IqBs/vnXVSKW?=
 =?us-ascii?Q?aQjc08mVkejRaZ+feJOPw/ABcUAwcNCmbgqH2maTUPsOCRh+7/vut6g62ft6?=
 =?us-ascii?Q?KeYhjOspwQ1jjeJLo/3Td5hqBmg0rCGDl173DkJJaNwqiX10cYiFp9Wumap2?=
 =?us-ascii?Q?hPqxRzvoNQ9TXsc5wcg2WYCX1Ne5IIR8eRdADriralyxW7d0tQ7Q+jIT4srz?=
 =?us-ascii?Q?/H5/v6aYgzz17OdqfBgZfw1xkU5l3cxRLm3tBPgHHtqgiPfSoLR2aQO1dhYj?=
 =?us-ascii?Q?LLW6gu55ValpuTKnSBzjPnn6A+7C0kbLpQ6EGwvSce1VAs2OoQQqG/qaVyuz?=
 =?us-ascii?Q?AplhQYLP8f4CaxER1/8KL6iOThSZsQy0PK/BY0Gn93635frakFW9sH5A/mER?=
 =?us-ascii?Q?H+RWXkqzng=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tz1MUjyGFLhkfQcZ2mOwtkBm/4fMS3q1kTWyoTFpb5PnhEXYZgpsWzd5aHoxQLtyExwVbrwQdh5bSMsqj4RwhMZzIM+htUFUFpN1bqQ4C1n9mio+nzxPTPudhzyr8/aUWRVk10GtiTgLWCk7FU3QKRgnHJWfYLlzAlaZIDgb58GgIkDtqWL9VMu1FLfTF1LQCzg05qAA7zg4Xzr6cYLa6Jmr+VcptxbGtxK6X2/Xk1A5/fQAHIiSuYaRwvhSYkgB8nvOEz3keNIflbnOsKMmKv9OU+mqMbomhf72pCSpP6wCOOzE6rwpb1dEI33NKazfbKL0hpiP0CnYdeQH4VrNkn8Qqpp1FosZ6hPcOAcWOdfxfOfxQV4vLAi+kKisvh0B7IrHWFaRidPbKNhOHFuCKhlUoi0C6Qzl8LHwtuOH4iFWe86kqe09AVJcf0cbfKKdo3+aTke2BhB2S/Jfx8aM43raeKWq9ovAQAqq/4/OAGMf3/r6ssq4hkorWJcEwDbv+mpMcx2100u+s9BUUzcAQNe3cQaRF9RCerHRmtQ2KlQ2RWHyFHdsQRBNmUtYPyvTjoOah6ASGbsBauz6eDjFs+i7UDAXrM8zn7OvoW3oJ7U=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 881f42fe-697f-4d0a-fcf5-08de6562f7ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:34:47.2243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X44TU3m+en9yPxBSO2mTRPgU/cn4A5Bb0yVV+dyEwcdeI/EWHJ6lJRYhXhg3QGAR0jnE6HJUCPjsDwaco/OTKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=856 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602060063
X-Authority-Analysis: v=2.4 cv=Jor8bc4C c=1 sm=1 tr=0 ts=6985b5bb cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=yPCof4ZbAAAA:8 a=x9Aiw9FezRBkBCJUNdwA:9
X-Proofpoint-ORIG-GUID: o1EFGlijl_x_V3FHMtE3XJb5m4ZjunZ2
X-Proofpoint-GUID: o1EFGlijl_x_V3FHMtE3XJb5m4ZjunZ2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfX8RJqxkZqD8jB
 q9to64c9VuTpxT+WkJzuvky/ZoSuqVLpsOh3jx62N2V8jwr0w6zyKaUIY2+PIgsuJ3DjC6MEQEY
 6GON6sd20e51xE9yFiE40ZAOSHKz7KnOONv+jrjAKZm+THfLwjPArQrGKDtKNuZyfE/d/3Z6cgo
 Pu/er5uKCj8MQVNkQ4xeo3thyXK1sj/LVbbYuhwpr369jqK4JAu+cv+I/GtBMSHyZdHZzTSfi/+
 LRzrBMnE0nOIdDMmfP/UXtwXpGgrWa3V5PlDhobUXuGaIyss3FW4q4DvY9FvO7EMhqXuGZt8l5/
 GcO2TQtzZ0aye0At80ZZRfVcyQk50JXoiJPXAAu1g8LbjfGWDdPsSQWex9bNkEUJBleDIKLm+MT
 +1ClVISGYraq+Ya0cal/g2ysNULSWZWxU9ZvKMKwhVJReBvH2SFB7whbUBkUVWhaGcGuT/Bcz18
 LB1rXVeo09hElvYQxpw==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E5B62C0010
X-Stat-Signature: y9r8soxy15387h33w58k59fw9yfjcdbj
X-Rspam-User: 
X-HE-Tag: 1770370513-829102
X-HE-Meta: U2FsdGVkX1+J4fZJUXSM0zg5yrOHga/7BIFnio4dzQzyzuFDaE2WktKk7xQeUB4VDSFUrTJYToRXmxxoqNn/bQ+T/udtWxISkQDKyx/AhBO/rCAxYaopgarZG9DHZSVc4SbrCi035wE4xrwChgy0B03rmJl2+AC8AkQF0XRlIlSKjT4Gu4tiHsz6Ubfd6sVVMJV2r/iuUiR0xX++Vq4GLMpDYW0eOf4XrmB5yCrGqbbBh8FubhjeVtqjj7SvSjOF4L8hQ7i7jUfteTY3tgJ/HxznzR4Q2j0u8tIdwgoZjOwjBnNOteUxZvRRB24dmrCTt6fpsT5U87KR4RESCcFzbPNrSeFpM0fyiY8zwMEFeLn2zrQVY7LewPhskCWdUlB1mcTAgsqMFbW3985lGkWcOcmcXneRhwIgOJ6pudM+RTbsBKbndmD9dr8A/pxJoSBt3xakh0+AnC3oQc/fohE1LlJtudFHirUuUcE0R79Fm6nyoDAtn9QT2f+UAcGd9PDS5h3AB951WXBgQdhBMJ4CpN5oed1mC+Bnx8uWRmXy8MkN+ZGiZSvqu4V997S/ZqjPwO7qhFLrArT2D6JS3lSLSqtSRClXmIkanP7MAiutm1qfWuWtXZpyIsQN5EE6dz6bf1iqGrAVLcs9IrbA4IR+LM68c53agZ7F2S9e0bCcBocnBGgV8aN0brOmZnMK79nZIXCRsAaLN9yC5Eo/C+g9o2GGpOsIgXcF0peTCRS/Qs3wswz9eqOksUL7WMqc7tYNzDNyy3nHRBNzfRptN/KN8+bmtwyVYFoe0/5XBmVSpaP/wvcb5ZUv7okk+dR1MKLsDvkEUdGNDyaNKZw1cg4uFpys7aJoMKCE0+vsp0FBjpYnaPxl1FlwNQ60PnP3N3BWbfJHJyvE4Cz6MMf4OJ+FtPC4wPzMjQIyZ9edlu7b+biorOYl2ZZbOR36BFd8e9QKXI1LMtjdgaN785ki8c4
 2RzIyhXB
 HFcUrCORdU8TLzshyVwzMecfjsknvsFlzP0QxEcmlbcGidxwILCGmUBi1ENEVzjgY9kN5G9pxR2PZ4kXf4iOEqsD8u/fHCuWZdQct/yUn01UaV+ndd+9O7nZBMyi4m5SR7kPJunrVkTwnIQIP3G6kAJJYtL0XHvGz3BJO1hcxhU1qL7hOcOvr2DnZ/jzGx4unXmSBrkl4HihWSUk6O58qRaiGs+bxjbY1HweMrEcSO520h1WBeDa+e0odZ1Mlq8Px/5ekjqquvzP21AMd18T5peptKcw9B8K+86BZhWUSq5G/XegYQbcloTF2gbe7YmJGh2Ub+/f9uHZmPKKJ+Usp5Fr1FtmWKHmXVoPxqW5K0LVJsoqtUVOcimSMxhFmHf+Au6A0e0Giz/FR/+8zJ58hO5zvWA1UwBIBAnK297Zf2/ytbXPL1/Zo59Ad4W+Pz5SDCq1rMNHGtLuNXhLBysRuqKes2hpJNoOwW7I5GvntckXhXe032iXVlwgvOiajoqbCm70DTJ3WtwCdoub9Y6nFyrbcrDANSKJVXw7jr1MZGzV+wCUyLuWShgtq2DpscCVYHzgcNsi+0pqycf/bv04hwW0EztcqJ7MLMMM+DkGr4O5MTO1kPj8AYWmlBkPYj641fbCPIPk0/rcdU0F8KXIdUDAW124ti4rOFD56jirXnvsUsg7TTZ79WXQ8v8y8CcZevecYkqrzjux35ahgGjx5fNJueDdxHaX/pbujCnVwbPCC4Cev9OQ7RsyS5jBMuqplVLki4r9r9rPT/izNk4z4k+e+WnVGXnKkadr0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When slab objects are freed with kfree_rcu() and not call_rcu(),
using struct rcu_head (16 bytes on 64-bit) is unnecessary and
struct rcu_ptr (8 bytes on 64-bit) is enough. Save one pointer
per slab object by using struct rcu_ptr.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/list_lru.h | 2 +-
 include/linux/shrinker.h | 2 +-
 mm/vmalloc.c             | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/list_lru.h b/include/linux/list_lru.h
index fe739d35a864..c79bccb7dafa 100644
--- a/include/linux/list_lru.h
+++ b/include/linux/list_lru.h
@@ -37,7 +37,7 @@ struct list_lru_one {
 };
 
 struct list_lru_memcg {
-	struct rcu_head		rcu;
+	struct rcu_ptr		rcu;
 	/* array of per cgroup per node lists, indexed by node id */
 	struct list_lru_one	node[];
 };
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 1a00be90d93a..bad20de2803a 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -19,7 +19,7 @@ struct shrinker_info_unit {
 };
 
 struct shrinker_info {
-	struct rcu_head rcu;
+	struct rcu_ptr rcu;
 	int map_nr_max;
 	struct shrinker_info_unit *unit[];
 };
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 41dd01e8430c..89c781dcab58 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2596,7 +2596,7 @@ struct vmap_block {
 	DECLARE_BITMAP(used_map, VMAP_BBMAP_BITS);
 	unsigned long dirty_min, dirty_max; /*< dirty range */
 	struct list_head free_list;
-	struct rcu_head rcu_head;
+	struct rcu_ptr rcu;
 	struct list_head purge;
 	unsigned int cpu;
 };
@@ -2765,7 +2765,7 @@ static void free_vmap_block(struct vmap_block *vb)
 	spin_unlock(&vn->busy.lock);
 
 	free_vmap_area_noflush(vb->va);
-	kfree_rcu(vb, rcu_head);
+	kfree_rcu(vb, rcu);
 }
 
 static bool purge_fragmented_block(struct vmap_block *vb,
-- 
2.43.0


