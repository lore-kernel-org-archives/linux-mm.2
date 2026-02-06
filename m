Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D12EB28FA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 09:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948F86B0096; Fri,  6 Feb 2026 04:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914F16B0098; Fri,  6 Feb 2026 04:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A4D86B0099; Fri,  6 Feb 2026 04:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4A56B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:35:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE89E1A07CA
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:22 +0000 (UTC)
X-FDA: 84413523684.17.89FBC0A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3BFBCA0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:35:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F0+cB9D0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WT+lpoWw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770370519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vVwIARNPaSokp6w8KIPChgxdRBOO5IciHt24hgAJG+M=;
	b=ABne/l7FAo2fXiXk7n7EEED5CjuegDaSrd+boihRKLYa+ae12NqHaaZX8MwE4MF/nq7OHe
	ldBXqVXTtl5a/PTHvIf+QdrccE+Nxb97jhuzw6HCTPA7S2wCP1zQNh19MYVrD2j+CK78NL
	r8JRBZaYgrWVJNkozp/1Gdv0FBoTLzk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770370519; a=rsa-sha256;
	cv=pass;
	b=PHFQ2aDAE4UPgU2I6nh6dB1/Fg4O99O7ZgsigBYmP7EV1uxp3rEbsXNcZLDaz7nc4hR8P6
	VYHWNlqxxh8XsMgifS7nSalaYsp5QNeokhQvkHmhNShpiUwlIKrIzDh97eRB7kYT0Vxn7I
	6cN3Gape6My/1UzftUbAq0IFV4EMYWU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=F0+cB9D0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=WT+lpoWw;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 615IQ7bQ1180537;
	Fri, 6 Feb 2026 09:34:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vVwIARNPaSokp6w8KIPChgxdRBOO5IciHt24hgAJG+M=; b=
	F0+cB9D0cSNcV4N2REiitjqjKdUCqLc8WyHRfcztNmVDd1SGK8nglhX9tfTl2Am5
	TT0b3+0uPMCc5dlvVlbC8w6Yxhja5BMUNFh63EwYg/OexcON3WZbZmq4fu3N3f6U
	+RYBaZOd41yTndO+Mn0xSrUqVoEI/sncn23pZc4o3tcwAr3pfh+VXFfj5rGn7m5v
	lOTPU8vCuhK6m1UZIh5zkHKlQ9T7fsz9BW7ns2Ut7Sm7xxXdNXDi3ZOklNN7rIfq
	+b2oYYoCmIpGZ+MuJAuFARlqT5nBzwAHAG2uaJ/ijcLCvhpaUn1Yv4PNHRk+Zij6
	rhKUXN3dYFWVDcm0cOsDpQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c50fmgw9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6167OVdv040230;
	Fri, 6 Feb 2026 09:34:53 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012055.outbound.protection.outlook.com [40.107.209.55])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4c55gbx3k6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 06 Feb 2026 09:34:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jivW0yeqAjKVuUwgfGS0h6qLAHGaKiOTCu/50Ev+6ph7DfRcfaqUcFXxrlkBKna3/Wn/yO+OyIN9dnmmBOB+XfwvX3fscQA58aLc8HDtE+RcpHeg3izW8Cq/Lrsy2zauqYbS0O5GbJiRwsQ//JO2NIliEgYm+fjGohW6LPh1HgC0vPgJ/Yf96h5pYMYmTDpbB326u0vWaNPXUMAqPziOIN4crMGtRoQAFrxflaRivbbgX6akucLDDdmVasVhsp1aWlGUmkepy4P6an7orSDh666e6grFgKAA7Jokt7BphOIl+IWg6svUzbON68IbKCqEE3qwY2//gBSpgKyLLek41w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vVwIARNPaSokp6w8KIPChgxdRBOO5IciHt24hgAJG+M=;
 b=ekdgQHNpspiPkLbfv9j6AbT39669rentWoKLQjO4efyAp0sKAuMmCe1RUs5Oxch7MR01j5Rvqv67MiQk1wZQvH1l6ES4pWws/ujtRCahtFPyb6mD6+yvsx4d6bF6zIb2CJsNVuLzyVjJIMGIslJqj0Ti+aq5LIQ0i/Wii5emNnE+D+yDNP2NUUTCMxTegnXoWTic4GNs2HmdbsUhREt3EqqddvbDVCiBg4K9tyVI0t0piSEvx+rPGx7bLbVjd7iWb6Nv5S4vu8nmFpTkZreJO/xVSUdd+iyaE27zR4RUT7EfLSE2CL2iEoX4l/2Kr8D+Ttv6bFFZOGH3/DNge7UqSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVwIARNPaSokp6w8KIPChgxdRBOO5IciHt24hgAJG+M=;
 b=WT+lpoWwv6ovB8DX+Jg+PxNZltvOFdQPf/TL2fwes6eEgcSht3dUGNbtOCmNXH72u7fBxY8f+1/W7HWIMR6NGwuvYA11CAKtHvapb5sOc/jniyDn/TjSUSu4qcPddTP37T3y52wI8KBKiLy8eg8l5v4MEyA1+4kXXpL9CIs08jA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS7PR10MB5086.namprd10.prod.outlook.com (2603:10b6:5:3a6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 09:34:50 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 09:34:50 +0000
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
Subject: [RFC PATCH 3/7] mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
Date: Fri,  6 Feb 2026 18:34:06 +0900
Message-ID: <20260206093410.160622-4-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206093410.160622-1-harry.yoo@oracle.com>
References: <20260206093410.160622-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0131.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c0::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS7PR10MB5086:EE_
X-MS-Office365-Filtering-Correlation-Id: c5eab4e6-cb24-4a52-1db8-08de6562f9cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?U+TMI4+D+SSUqA0eHcQ01MPrO2TYA8LPNGeo2NhTy/DxrV/wlVjbsZFM806g?=
 =?us-ascii?Q?blpzOVV0rPQhjPoQwQeWCu6srjmW+k0veNEHVoac6Wh3h0ptEH05QJNwmGyP?=
 =?us-ascii?Q?MDsCAXapH3KmdeoanEhPodcGGLyuLvJ12LhJKJ4QmQBhfW+kGy5J+x9Kghka?=
 =?us-ascii?Q?Mgn8tzo2HGtXWp7yByzS1msiMCgSJrQ2l4dLIDTfeOLKAgNfbudH7T6dje+K?=
 =?us-ascii?Q?eB19fb71eBFX+XD2KTI7eC6A9w542bExJYj14I0eO9+cXDp6DU/z0Y1KLE5B?=
 =?us-ascii?Q?5r6V23ONa26HsgpNSgOXtEtVdhHuVxZO5Neqq+0mWCEc1GrE4ggn/lqL98Pg?=
 =?us-ascii?Q?SRLSEKqCbFiu92vMOwVtNNSItKfTFssmvkIVS4pzVvh0M1wdyLzLgWVfdlj0?=
 =?us-ascii?Q?lP5Dgd+TfEt28EjEzi4KV2yCEMYjeekyHX/1eSz3KIyqeAY0CwjW+608T66C?=
 =?us-ascii?Q?QWHzOx8QJVnV7S6eCHMGMu9rpp7iWkK0F0UfvygQQjLWwHIy2f9GMKFmBJIi?=
 =?us-ascii?Q?RmkR/jqa+ePTbarD7EhXxqX42eFp6eqAJZcvdfm7+3KZAUD9SVX+NCl0KDe6?=
 =?us-ascii?Q?kO53mhQxPD83qK4SgJRbL3dY7PBcLDVaDysU/0C81SnFc5pTiOfytssp3S0L?=
 =?us-ascii?Q?VksAaoK+KnoMSM/n8C+wGy6w4UgriPHl1D7xDNGHmx8LVV6dg9lAuI00GVLP?=
 =?us-ascii?Q?oBELlp1401vwcE//ZRy7tmdDYT02X+JmJwTR4GaVWUbST4UVbxnbRaJhrN/n?=
 =?us-ascii?Q?kZl0cVsWemm+B6L4vur+4oDV8Qp47z3b6hwV1qKYRIZbpBnzMh8xLUciTAOQ?=
 =?us-ascii?Q?PrT/tGRK+FPYRwNa4A7uLk1V1+dnTpj4v77wAne0+O57JopadMjVXCFRwkxM?=
 =?us-ascii?Q?m00RTecjUjTpOwoz7agoFSoD4IWRphaWgDVNVzv1k95oUo4nMyI19JjSO26n?=
 =?us-ascii?Q?sb9ns2xGtF7y5E/fp94bXldBqdgS4ilAto/M98eXjUPyUUoDzJq39lWSgL2R?=
 =?us-ascii?Q?9kv8sD6pJBwbfdByHlLwJ4lidcqN8VoEOLtKKh0snZ4JmtEV/dku+RTc/4cg?=
 =?us-ascii?Q?J6BLhn4z5qUppEp/nXyD7QfSAicTahBJYL7hPNzYMzQ18IeUAm5skdnQBlnf?=
 =?us-ascii?Q?syPEJ1MdrGASFSIHBVI0yAdlUpqKo5X/YZtGS7TZlKIW5ZsWvm3jnawinpZ1?=
 =?us-ascii?Q?awi6OgEzRoDyFMxDzDgk6CFFrXUFm7T8j19hbjFuR+z08vxEL764qomG2lI6?=
 =?us-ascii?Q?JudhwP22BqZXgY+pnQ1XN1a417NFhtGC5Rggd2tV1RPwijwIzTKfDqZvg2pf?=
 =?us-ascii?Q?5ZPye96xBoyU+xG8VQoSGgqDbLPhN3l+s6QdutGJQPqKLyubAlsqf4Dkx2wD?=
 =?us-ascii?Q?wyK4W8QL77TJZryrvBpx0zh+pNbCIcnWGvgJM442Ez850bUur1LEHUDFWJBw?=
 =?us-ascii?Q?g06ODXM5xxYL3MBeouxRmwgVonqsIhjsKQuZe8Zafoda+9yN6sGNBUZg2UqB?=
 =?us-ascii?Q?2B3MzecPH1wXY5L+twYn5H59otEfFGaGijQAJS3SydstC/nGmViWSxOVM9D+?=
 =?us-ascii?Q?9DGMLauRJBAX0zef8d0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CFF783Gp10OdI52ytQ3s0oailTt1v0Pmuyj+gKdbkuszvcz8r36lGt5NKa+y?=
 =?us-ascii?Q?oRJbn2IhxZ4DDMqx9t4hYUwQePlZjCmHsT+jTltCelAoUWWEixOHBZ3IZMAe?=
 =?us-ascii?Q?qCd9Y9s2oBedODwtbs79wNEm1tOYxJMn7DoOyXSE1LdPxmbqcN2/a44Bkv97?=
 =?us-ascii?Q?h/z1Qx0qeMCW1O0N7t6MJklCZ19tbzNdAYhrvHvvkJ7DsIq9N/lDmve5Kn20?=
 =?us-ascii?Q?MjtSR3HBFC47PoFNWD3CJZYL5nFnRbYCc760JbScKtfG9jfmvMCUN1HXt9QY?=
 =?us-ascii?Q?vFfTyXooVYUpqatb6vjMn48ukmkgsD5r1AqDKFUMyXbrq+42u1dUz/KR9oGQ?=
 =?us-ascii?Q?9lEvwB77k62V6R5dkbmsB0VUmOBR0t5RzDTGdh/wSOUq81MfP1aKbeojuLMQ?=
 =?us-ascii?Q?Wxbm8xMM5n/8YskKvTFQ0oPlFVdPzEWw2Zr4ljOIJSMK/g4HjBZiBp7fwiSN?=
 =?us-ascii?Q?apv8QSMQI7UeRiipu/e4MoouaSmhtJNQmhQmDpC9pPWzMZHB/uBlqT1gw1N0?=
 =?us-ascii?Q?Z5xvUCo/oMJ1f1H5VfMxlVzbz84Jsk4ommE+zytuPvvj5/CLaJ/QLDz1iQKE?=
 =?us-ascii?Q?YuFnNQuRe/HRmmaaodM56BTdmJNGq+/3bnZB8xUhqjv/E4xKnhTUptzexFMk?=
 =?us-ascii?Q?6wLGCDtM+lQXB7A9fo1NKkaXphZlYuvQlQSlrptSvvpIJnid/HkEyhaF52jM?=
 =?us-ascii?Q?m2YbEiR5A0ubwyzn9WnmABnT/MQfLJWii+XNfMWy1snzMxN4JnOUvJ7iDwSg?=
 =?us-ascii?Q?awSPwKKTr2rirvxpLw1H3osV9tlZY7S2w4kjC5bARChmRwErT/hciiHuBhmn?=
 =?us-ascii?Q?jM0a04BoUS19+rxBLufi4tpmbPp0DLysKZ/ThC+ONuVn+/j0UDkG/JkHL8B6?=
 =?us-ascii?Q?8UK32pWBHqPRbm6uuOnv1SAfwh8kTr6XAHWfqHXJc/KQZzHpgJ9qHBwBEVS1?=
 =?us-ascii?Q?ABhcnMydSfn30iQiCz7Rl8ox/Mrn/IMPETqtCuhsGSxMmSJpxoaPxSsKsjdG?=
 =?us-ascii?Q?ZrYw5NHJWSX1AJV6EcritStF/6PmPH1G7/NWr/3BYHIoTMSUmrjMnsdVYCp7?=
 =?us-ascii?Q?cWLXILsSmkIjXyyLjxlPLzfPyRJYW7iAwHmu1vgY08Zs/RUYi6bAQsDU18y9?=
 =?us-ascii?Q?DwXMM1fPSlYczlqxLEP7iXMxTrCt8833k89u4SgHiRL/xIK8wd5AoQ0RwO3c?=
 =?us-ascii?Q?UZH5IDpMrUJbks7VQ7xVuz315AcUmAj54wwmAY+dnfetO7bbXzjCwXiHKm0L?=
 =?us-ascii?Q?ZyP4l+M9zXgC/iaXr4ADSLrkkIL4YrGWyohSb83zMusatE1ObCXk1DbkVfWm?=
 =?us-ascii?Q?bC/EaJ8q9DHzvLoxAzciT6KW2dVFrS9JzhUpVvssoTX82/ukKN14t0Skg5v6?=
 =?us-ascii?Q?rQT0E8myDdl0JsYOkaOjm/JtdMZ1p0wXbBC+Swja/arDXQgbhZTvdVSzK6aP?=
 =?us-ascii?Q?IFhbsliHIKZ41eChYpCi+9zcAHdT6Qkgo4NB4b8R09aD1zy+RKq3u8mBqO1u?=
 =?us-ascii?Q?uGjzn4ben4yHvNVYpMflKVXxbdTBMbM6wA4jGj1HPs8z0NcfeGlx38NrYpSg?=
 =?us-ascii?Q?cYpqWmtiSh4EYkFozx4HHK3xMYS3Oi8s1OkkDF8ZW7U1ob+gdtqnRfXIetwG?=
 =?us-ascii?Q?Mee5XotNnb4gzegh/1EPs3n7Ug/63MNgQdDdph0YKVbzdJX7dNtL45LPJCNv?=
 =?us-ascii?Q?W95DnJj0yCQDGs70mXrvFKtTxjlfyBG852/Oeisl9pL8tANpVHK3+so4DAQ8?=
 =?us-ascii?Q?JJY2uXfnZA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G9pJwYut816zMm9rrkQU7XUa2C2iAKn9l7iajXn6iyZsv4Vo5qwjJznG7msGsQ9EMmgDT7WPX7iJRJO8+zpOqjESoZs9C9eQSDMDL9wGu0xPYb0abQGYQny8RjT9Hu+6g0WiSDuSihst0uX2ccwFDvfeOr8fmFzOVZbMkMLKhIdTVhT4tj6JCNleXQNZWwUJeg7lLUkLc/AhOStpWJV9qzquAuC1J8hQ0LqikSlkZLMgeGZJekOoPmU6Man/wu3HNEGxKZs8NGLDV2Yq9KOlAn0cLz8HW5AADRlpgBG+R5fDCyYO3+Wyd7A6d0xSLOE/QuPvLCvu4vb0tOUXAmhrlG9F5p8uAhN7QsezPAAKKGnQDdKKjs/E5koy36ERfnm/ia75OBuqtR3NWQCDI9oQkFuffKAVhh1CFRsXd8n8jNGUxfvEy2eXJt0ZsyHPBVaiJV5Ys2DvAQoVqkIW4nXgtI6Z0rH9kMphYmRjyOJgyZg0sXJk7VVemir6WgwqZfHOSHCU8/j30d+N7LG+Ko933VvUatnGyQFh6VjeRYF3OtfeXCFwMpTB5AJ4eQI8LUj36AskwD3uJx8zGSXjYN/HMD1xCsxoR3jb16nQr82QqKs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5eab4e6-cb24-4a52-1db8-08de6562f9cc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 09:34:50.6572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cSDyVv4pKGTrnGq0QD+VtoNKCqYO4lRTl5A/qLYyBW6w3yBi2tMjKz11aWiDBC7fCioFrYjT6yj/rITSQVzfQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_02,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602060063
X-Proofpoint-ORIG-GUID: oRawLH1cQ-z3IbqBvDLgE3lR8g_a6D2N
X-Proofpoint-GUID: oRawLH1cQ-z3IbqBvDLgE3lR8g_a6D2N
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA2MyBTYWx0ZWRfXz0cc4Z2wj3eY
 4oeU4dj2kW8sDyCdkM420B6z2YNB+ifLqTkNEkFx7a+KkCKSHzFKdgpKHINb2RqN1u8A9EwtguK
 Kb4tb5IMvjOhr1ls1/ztNGq2avROE2PAA9xCRKJEbbzRgs7lNKnspXc8MwqFsNYn+AlePmvCI1g
 Jf5XlZlTVbhV0hFOMLP7PZs2Mqcsjrth4KvJ0JNtzj9PMKIsDwcLJvovpCXJsVrcymac7KakkjZ
 1bfHHMOSC6v7XcrZTE0DpZ6+L0p1LMOfiCDYycina+NZXsXVv8pomcHu/diRgUbMac/ndi9XAbK
 dKPGdlmkzmp3n47eZSHI6eX4H5DHE7QsbJTiCKSouu/b8Uy3d1tfAsa+5yWrqSCht7WZ+pWHCMG
 XGmCDi8WNPf9hIWR2dynLIrp1vC/ejDkVj/flrsREEgrU0tkh1uPwYKG563Pn8gAVzeKmDbdDKV
 mufJHoK9TGYCLf5jB7Q==
X-Authority-Analysis: v=2.4 cv=BcbVE7t2 c=1 sm=1 tr=0 ts=6985b5be cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=SUhaa6ZQdBBKXO6E7UsA:9
X-Rspamd-Queue-Id: 3BFBCA0002
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 6ffysjitda1unodriiokyejd6kji36ah
X-HE-Tag: 1770370519-584380
X-HE-Meta: U2FsdGVkX18xoPLrLkmHGF1DjGgB7F2dHYdnkUq+edDuYzaB1P/+pmyuvqy3siWqKvp62FACedVTYjehKrAXb57kQ3lzQlDUWPUckJlTkrOSMtCXKd5QhbCROCg71sjXwHIiRvGfgNj1gDyMMoPF+ofs+40NXhpAnFEISpscMRUn5WVw3UpR+UIFcNDAB/Y5cUOjEopvt9g8HZocnjrvMVvSd79h1TPpkt0WvGHiB6DvI/SIjNxKs/UsASK4L3O5tk8vV/8uv/KXavrws0TaQqc04p5w+b9YMSTgrWl7Xufa5qbzVyzqz6o1jL5vt9CqcVYQpTReUyq+gCTCgub5iuUKwEuRme40agrlYqekH5MzkN1uxraip/U5PKg1oCdMZBQXJPIAi5IUL2lRVsOxFcEgE2uXZyXIE/oYFKZp0YbZfy3f24YXPd0LhxxN+KpysA17g1TOV9aZrhnXrMFLc5HtsckO14eLj/e22cFqhDsVVP85K0nU5UVmP7X++0A8pVO7LkujysYrsthlkUyMPE1MhdJowTmiKBjY1r+0Alcw+p+/JXzBhKNFUZtgMN8kfyd87LEGnLYrXuAOm67pcr4eIcZLbMAQ8h57Bo+9WoVTd6g+amcpHm8PSG75HTlxE87BN8esMd+mIeQaYT6vQU7jEbfHPr1e/qYzpGWujJNdeCboO/WYdYOe654+gSj+HNmHbGdmmM4sFeZAd2a0BXarg5acKwKrqPgLq9+th9NoTsSH6ZYsc2P3nwm0ug4ELhoGsmgz3LBNQWHcqyLd1C7EtdUvSihQaoK+x6u0ojXAZ9COPMs3c+P+awe5IcGORqRYysuIrUrAKgOnjBB6TNIBsqX07XmXR3OaL+Eq/kwzl9LADM5SXtaLnt9s9Anwp8T+vlKtxsd072cLNlfbf4xkh7RlEJUy2ZW2BmxUW9V1JYe4aNvu6khojNIb04hHeNSzZcJ7rA7Us7V6qQ+
 bw8ldN8m
 o6o0jVYuoLqZSG+gqt5GbYAnKASEx4eHcGyMRhppHfXsmEhk9GyLJ2yIcVO7Nc+XQya3DRw/UpLgdU9fioMlQ1qgNsnjc7CaUVP3zB4zP7Vy8kZiVOdPOSCGGbyCbT+Ms720cPs6FBCxrT0Ju53hxhIJUpqA9Py3LD3feqlAldpebuyWJqBBFx2BBJyUUO1iv8mMOTrlnfxNPqiZ4mCEo7BpypWD0PNqO2EBo4/1ded71V3T15BKizRQuheLLQjHDn8h0QQuP8/M3BUJCO9z0an2/1fgOtmMfAyCeh6cD9AOWZ1Z8f11TdZROnMQUQCZOIeZhunZMxD24EUi9dJ4rxkv1e1U+11LfPAI0qmPqBDKuf5cQHUnGfDd9lL5vqjTsUml34+dtt5hI3XRz9BQ8Uu/ME2RAfpyOy0K0dygVBPPFnkP6hKj1PBkNLhjdFKwLli5ZFNDMTbwEYO1qTgeZS2FNJvqiDACxGe4b61r/JzPHaznVx9gmyK0yi+mr/eQ4hd7okGUXmb1ku3cEgcluU/8hT67DTEh/C0+93nFVDGMwhJM34r9xc3Z84h5EVkfFz881j6nv/NuxMrM9dW8L4RiEN8kxSyUzFdFc1tjEEZK+Cgab/zL0uRffSyPkIBfPfUDGjpwt8u285I9jPgoKXSVKckQGJwb6KLqg21v+ZtpqTmlylsBOGnCcRC050BnWk+7jMF5cZrgFB63H1Do5t6D3559NLCDHn5mvjZwEYq7WoYLCPnCo7j7AHTRMUWQhPRf8E3WxuuQBVK1NsrjVz7fYBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Slab objects that are allocated with kmalloc_nolock() must be freed
using kfree_nolock() because only a subset of alloc hooks are called,
since kmalloc_nolock() can't spin on a lock during allocation.

This imposes a limitation: such objects cannot be freed with kfree_rcu(),
forcing users to work around this limitation by calling call_rcu()
with a callback that frees the object using kfree_nolock().

Remove this limitation by teaching kmemleak to gracefully ignore cases
when kmemleak_free() is called without a prior kmemleak_alloc().
Unlike kmemleak, kfence already handles this case, because,
due to its design, only a subset of allocations are served from kfence.

With this change, kfree() and kfree_rcu() can be used to free objects
that are allocated using kmalloc_nolock().

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/rcupdate.h |  4 ++--
 mm/kmemleak.c            | 11 +++++------
 mm/slub.c                | 21 ++++++++++++++++++++-
 3 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 8924edf7e8c1..db5053a7b0cb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1084,8 +1084,8 @@ static inline void rcu_read_unlock_migrate(void)
  * If this error is triggered, you can either fall back to use of call_rcu()
  * or rearrange the structure to position @rf into the first 4096 bytes.
  *
- * The object to be freed can be allocated either by kmalloc() or
- * kmem_cache_alloc().
+ * The object to be freed can be allocated either by kmalloc(),
+ * kmalloc_nolock(), or kmem_cache_alloc().
  *
  * Note that the allowable offset might decrease in the future.
  *
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1ac56ceb29b6..de32db5c4f23 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -837,13 +837,12 @@ static void delete_object_full(unsigned long ptr, unsigned int objflags)
 	struct kmemleak_object *object;
 
 	object = find_and_remove_object(ptr, 0, objflags);
-	if (!object) {
-#ifdef DEBUG
-		kmemleak_warn("Freeing unknown object at 0x%08lx\n",
-			      ptr);
-#endif
+	if (!object)
+		/*
+		 * kmalloc_nolock() -> kfree() calls kmemleak_free()
+		 * without kmemleak_alloc()
+		 */
 		return;
-	}
 	__delete_object(object);
 }
 
diff --git a/mm/slub.c b/mm/slub.c
index 102fb47ae013..a118ac009b61 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2581,6 +2581,24 @@ struct rcu_delayed_free {
  * Returns true if freeing of the object can proceed, false if its reuse
  * was delayed by CONFIG_SLUB_RCU_DEBUG or KASAN quarantine, or it was returned
  * to KFENCE.
+ *
+ * For objects allocated via kmalloc_nolock(), only a subset of alloc hooks
+ * are invoked, so some free hooks must handle asymmetric hook calls.
+ *
+ * Alloc hooks called for kmalloc_nolock():
+ * - kmsan_slab_alloc()
+ * - kasan_slab_alloc()
+ * - memcg_slab_post_alloc_hook()
+ * - alloc_tagging_slab_alloc_hook()
+ *
+ * Free hooks that must handle missing corresponding alloc hooks:
+ * - kmemleak_free_recursive()
+ * - kfence_free()
+ *
+ * Free hooks that have no alloc hook counterpart, and thus safe to call:
+ * - debug_check_no_locks_freed()
+ * - debug_check_no_obj_freed()
+ * - __kcsan_check_access()
  */
 static __always_inline
 bool slab_free_hook(struct kmem_cache *s, void *x, bool init,
@@ -6365,7 +6383,7 @@ void kvfree_rcu_cb(struct rcu_head *head)
 
 /**
  * kfree - free previously allocated memory
- * @object: pointer returned by kmalloc() or kmem_cache_alloc()
+ * @object: pointer returned by kmalloc(), kmalloc_nolock(), or kmem_cache_alloc()
  *
  * If @object is NULL, no operation is performed.
  */
@@ -6384,6 +6402,7 @@ void kfree(const void *object)
 	page = virt_to_page(object);
 	slab = page_slab(page);
 	if (!slab) {
+		/* kmalloc_nolock() doesn't support large kmalloc */
 		free_large_kmalloc(page, (void *)object);
 		return;
 	}
-- 
2.43.0


