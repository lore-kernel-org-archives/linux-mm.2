Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BAFED340B3
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 16:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E0186B0088; Tue, 27 Jan 2026 11:42:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68DC26B0089; Tue, 27 Jan 2026 11:42:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544F26B008A; Tue, 27 Jan 2026 11:42:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41B636B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 11:42:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EEAE4B7125
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:42:55 +0000 (UTC)
X-FDA: 84378313110.19.ACAB6C2
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5984840007
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 16:42:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UhlwAyvt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ioglwGEj;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769532172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRhnAw4ZTAPz2MK4mJEgfrHMO9HReSgJsJs6A038yUc=;
	b=jdo7sQ/OkSHPjunk0GTLdGYo0IZuAccWOQMr6WIl4aQM16WfS+b8VG64DCx2tu+VTi74dX
	+O9irVK7fWAxp0rBt6U71Nai06K/a1ICK1NsmrT1tcPtb3/HfCOwAYjfL9lmCP42kIX6T/
	6qhlkX6dcctjrHifPZMdbKQmik4Yj3k=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UhlwAyvt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ioglwGEj;
	spf=pass (imf04.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769532172; a=rsa-sha256;
	cv=pass;
	b=T8umiqG295vxu6DsSgekDQRHZYCgAtejMfG8J8sxhKdfyHqHIeAp3JLn9niUOuFGiW9dsN
	sjGhh8vbjhPfokHu+uEBu51zp4UhUJZNI4Kz5tlERTNs+8l9j3Q5DJLboI3owl8DyO6ODa
	PG/ib9xYKO8BYVoI4a54TBW0BWnRpHA=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBENwx4055931;
	Tue, 27 Jan 2026 16:42:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=sRhnAw4ZTAPz2MK4mJ
	EgfrHMO9HReSgJsJs6A038yUc=; b=UhlwAyvtVjDxNWRnAEXpy8KtQ5Cn/e9oWK
	8MGYl8vModsEGUEKJapwhDXcMNSqD3zCFmDKylUD62lBbgME4nsubLwMa6zCcQl2
	Z7JoGEPLBeLhKEJQ7ozKZ4W6JF75sMMI8ryagbaZhQLu+qy3bOydRGxnH8S94X4m
	U6T4dBmJX8iB1j1RXnzVuMhGHhvLwI7jLyFMuYkkx8vUkx5XjWSlvX+WgK2+aY56
	bxjU7iTU40mPKSKr2bhswD3uysFUk6Da6Ln54f16m+l6WZdJao/QfQB5KnQuYlBV
	GOFt0mfSmLtNh+03+oawBmoFPFodp2tjeGzp0QplKHosvzvBjaSA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvnpscbdx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:42:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RFFC8B012190;
	Tue, 27 Jan 2026 16:42:41 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmh9psy6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 16:42:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W7Ql0yWI/N4Bv+CGFtP5Act8h/bSJwEC2LBgyR5q2rbAmekpqHKCeBMD6uX7ByJa1jSrd6dG7ErmTmgQpNgh3j+dkltxJWN46KlCGPjdtByhtp979hs7zXSJrPCOazLGq4DXJKe5xAvEB76NbDIn5Cwy79INphA+ooUL9+GLwiF3NGXaQ5rh4y+ePx2UCqiDEHhQ9JV3a9CBRqaJAIwI8WuZAouzHFcFM9x3GBhJhX20JLbaRBoq/onqTa5Ye3BG/bjpn9KiwHt80u0r0sWRNyweTu1XslT9ao5pkcEy4dlkU91xRg2dqZ5X1ciP5CG4402jAnhppFb6o1R4GbPWXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sRhnAw4ZTAPz2MK4mJEgfrHMO9HReSgJsJs6A038yUc=;
 b=BFexlfzYCjFAb2/Uy1rBNF1nH6oH5NwLWGpfb0KcUOAEa6UP31XYHKB5H67/bMobHPhlPgFsVMBNvk0+VUWSm+BT5lnoPc7VqFKirhz9pN1q1L9XdQna8pMyPIDMRSQOHBr2eP2vNHZol+kjca6NeD2mNocQFDhm9SDqgupXeNDZRt/1aBlsKWXhqtxzD43cOMSgaMVNx1dETFt+6STPe10OtcwbGzBTTyfWbg+/nYji0/BymocioGmX0hxowj2Gi12Il6lIjjpUYEA3cBSC3mVe6RvP0x9dCDUpZEaN4nY5d0MZvk+9HIZ+rY8XM+7hvM1vMj19f3DtOiDPzeulDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sRhnAw4ZTAPz2MK4mJEgfrHMO9HReSgJsJs6A038yUc=;
 b=ioglwGEjeoWYXr9aH/qY0bqi9hEDxnlItH/cLaOil3m1ET+w9MqWNLAxm44ZhxT/hJjTmYczt3WTHyNW2CUPUBrRyBTs9QZHFLs0cJjTtaLtwY5FoMblNib7CIAQhFXRavn3IamB6wXwwlFhIi/m6KvsJZQon4dqp92RTlj1Ov8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPF8DB18B996.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7b8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 16:42:37 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 16:42:37 +0000
Date: Wed, 28 Jan 2026 01:42:31 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <muchun.song@linux.dev>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        Michal Hocko <mhocko@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Suren Baghdasaryan <surenb@google.com>, Hai Li <hao.li@linux.dev>,
        linux-mm@kvack.org
Subject: Re: [PATCH V1 1/2] mm/slab: factor out slab_args_unmergeable()
Message-ID: <aXjq99QW3EzOuyYP@hyeyoo>
References: <20260127103151.21883-1-harry.yoo@oracle.com>
 <20260127103151.21883-2-harry.yoo@oracle.com>
 <f6b85926-04b6-4c02-a6f2-1e141c9426b0@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f6b85926-04b6-4c02-a6f2-1e141c9426b0@suse.cz>
X-ClientProxiedBy: SE2P216CA0143.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c8::14) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPF8DB18B996:EE_
X-MS-Office365-Filtering-Correlation-Id: 59889dfc-604b-46ea-1ab1-08de5dc31450
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GW4cYanRgHfWawnBtb2OFWdlxtw6wYpKXMwy8bktfGwqwo36G/32dtmotLX6?=
 =?us-ascii?Q?NdHn/EzT/rB0jecFHxCc82PjPy/F54qLmXGnCfhpgrw5j0ZGRSuzji0fQYiH?=
 =?us-ascii?Q?oNko5uUhBTKE892OF2pyyvEmWehIZBFzY9wz4xesD+8IeFyWm1+pzgFpA+5W?=
 =?us-ascii?Q?ca2houboKPlJj/E5vX3p+v+oGqzWnV3SlF+R8sM70gzxivvxp6TEce7uiiOk?=
 =?us-ascii?Q?igZabwKyVJLG1EsWofK3yZs7YUnjPxG8BLIo+3iBaERvUdpG+lNj6JnWwKzW?=
 =?us-ascii?Q?m4+MlkBbytvYxi/FS96LRJdxUHphUqjpGEkeqQ/Nut8VngyuLIgjbmbZYfDQ?=
 =?us-ascii?Q?yEZrvqOwEhQ0NvVn4CU+RVErQTtNHrYXVTinIbv61qas25jdniKO8GTXPdND?=
 =?us-ascii?Q?XRyDlrWIcDvhGuNF8D9Y7OG/TgB3fHGMrflhBHaes0IfE1VklUxcuu7WF0cB?=
 =?us-ascii?Q?idGMoBDGDrMhIxpSrUdEuDZBmj24j8zxbpVBzfKe3sM8o7s2VEG1c7vTCmUq?=
 =?us-ascii?Q?1Qs6CJwjjc/4X1S87G8178WlISlP9jxESomQyYvZXFwZShrLK+W2STmc4CTI?=
 =?us-ascii?Q?t2YfxwsEVfyX1w9PKiAq0nqKow570JDeAW2nf1hcroF8OhcyxW3H38dOp511?=
 =?us-ascii?Q?7nP5RNN412iB3rMi2lAuQRE7aVMLd/SyrUatgZf0iu31stVQh5Fz+JZBiRea?=
 =?us-ascii?Q?ddPfUrBnmkemBNYdTyJQI8iNjc7PBwsrofDbkxh0Kk5IHOewqBIVyVshbglg?=
 =?us-ascii?Q?13c69LpuElEplkaEZTsdtO7c5CL28wYKaphdEDVCGkte9RqpbOJioki013wI?=
 =?us-ascii?Q?10ZEvEJx2+R64IKxiEiG44pg69kvyhk37T8t4ipZrrUgcLvCSxW5XlJ7++XG?=
 =?us-ascii?Q?ztNKsWud763jTRWeynUractU6c0QMBV3maZL0aUU2AOdX9yW4mHDLfdyFsPR?=
 =?us-ascii?Q?xAlP+5O+tQo68SoPvV0vL1HzvZJa29WU/xt2v4WIIa7/OsVtCACNuMrxPGE7?=
 =?us-ascii?Q?uWuT/IK4A/c3jlBnXfLnDozEddYxBjpdhXTP6s56mLHUCutGQNoOt7Yxcg06?=
 =?us-ascii?Q?HBLexqcesnQhmBi9IylUi7HFpEPolWI1eXO5HuwkAJ7GJDOHtZWeczDGikSa?=
 =?us-ascii?Q?6HtOIyBsSihMVvdDOVg5i4qCdxUE/YRa8HdOWh8Ls0wtn2H3oklxu+gKpBYH?=
 =?us-ascii?Q?pVQtoCJS5KMXZyiX5GAR7ogalpjeiLj7LDAMgwWvUWIQE17zTHv4ToLfP6qx?=
 =?us-ascii?Q?8y442tvu150hVzj8WYnuA06+9s6Y2xBFjfxZnIHf0Ijkp3fgS1/cW011gT92?=
 =?us-ascii?Q?nn8IIWlEEwjL/SzJZkEgM671sZDhiZXodecZoPaXwgmHV94VeiBYrh9DQdP9?=
 =?us-ascii?Q?X+gNwaFWOTSpbjfZCoqdD0twk9Ix//u6XLWfuyGPE0nQI5/tVAokat44P7/9?=
 =?us-ascii?Q?p7+Yu7/ZMiUTWFZCzVbpRK+k+Quo5u5R9kFSXiDaw6Gf+Ue7UT+JyAGf30nD?=
 =?us-ascii?Q?TkfQ8ivocDyEgGUQda5JN3ca2l1DofNuOF+DQUCR9j/6sRlJ8c4KFqJbUgup?=
 =?us-ascii?Q?4qebDvN+w5NpTUx2byo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6VBp2PvQgJ4ryZfg/gusrbDoBb8jpw/mundxVfg66KiVODaNv4tj/sRxgFNn?=
 =?us-ascii?Q?ccxNGaVajMzhAfYsPkxRi6b82HQ2MrygmhITlWbhyQ4Or+KvdpU+Rw1m4vB+?=
 =?us-ascii?Q?n0r4jHDAXQOEnO3FPoXmoU1k+vYIQ8jvXUeGpl73cCyL08acUp6qGbuua5kF?=
 =?us-ascii?Q?tMVzin1tYji1o2lOwvrK/Hxuig/oa1kIE5ihgzOBID9hVsOuOWXfZptUBed6?=
 =?us-ascii?Q?6gKYAXaSzYmGojpVLebD3xVkvDsVp+A1ArMqE48E2XfDTHvplFLoKOTSu7XD?=
 =?us-ascii?Q?sZDjPGwJbssH8qi0+QODNiGc9IP16U+nB3HNdLgq1aHozzcNTLkYTvpcdEgq?=
 =?us-ascii?Q?9CitL1qg1J1R2Qd7o+i17H01n4SrludcGTVsN6Xmp9NdjtqdOwRgOI8knXmO?=
 =?us-ascii?Q?1BPYS9ErLCS3SOuBUxwiyRPuzM+ohtxsCa5fVi8Gn4gcDT69xVTGBQfx0gpn?=
 =?us-ascii?Q?180uV8yGfGOM9HKaw8O6cTLuv7dbbGQ+LTAGAJd0ZdeBjR8nA7/qWb5EzO32?=
 =?us-ascii?Q?nP6noxF4509DgX6jgelhj4d27RvwH3a+7unCFOyDBo4jGW7azmhn/l5hM0Ag?=
 =?us-ascii?Q?EoD8anKJQiJSdShyOAS51lzH31V2rmFTJtGWZj3QPGR4tFwA+Xzns0Cezi8a?=
 =?us-ascii?Q?nirQ1+bkIsBiocunTCxa7x1OPNaHClABIZ5ppCsA6Pg4KqYLFobA/X7s1UlM?=
 =?us-ascii?Q?3+gRGfgUBouqxkvPqz3htF/pol1+bUd1SjNJinQr1em0Oa1hi0bnNhjkhcrD?=
 =?us-ascii?Q?1rHgSrxXv6cCuznE2wJkhv/W/sKvqOWPUpGGr4+ymK1Ljyxd24x5AkLFg4Rm?=
 =?us-ascii?Q?zA9CaSS9Vc97WwXHRyA8EgKWytJMEcteX9ktbXQhaGDLr9EonJWyZS6hxeEo?=
 =?us-ascii?Q?DmAqNdaeLCpf6DqlHdGtyG4zp9pqDryGEaX2w/22cMmBtmXGxe+L9VS0lp2U?=
 =?us-ascii?Q?WR1Hw8FvydwbLS6+pv+tB6eRKRmn7QaZP9B7VWhhOc5vwFt0awp5nBCFX5Um?=
 =?us-ascii?Q?lwss+ltU5m08w1IyGAu+5I4y2Ct3Y3OwrjUKXQP92QmBGqkR4yBGNnRxKK4u?=
 =?us-ascii?Q?u0QtiW5psmwuUYYJQqEA+dAPf90cQHFZWim0u2pHlHhmKstu9tUKfJfSz7Xq?=
 =?us-ascii?Q?K9SFH9NiV6Cn1cnyPbaShaV/QEi/8GwvPi7i9SSx13XfjArsxZZZiqkKbH0t?=
 =?us-ascii?Q?kPdYIPYSKo8+V5cJkBykrO6yjqxgw/JJirZy4uyjWcwojUppz2hNaXMY0AwA?=
 =?us-ascii?Q?GYNRiO6TzWETJkODv5Jw09SF/P13e3FJ4PAiWvva45q7meRYKrL021VOtzzS?=
 =?us-ascii?Q?r9lKmZXFZ9Y617AhvGzBiOl7bmg4z98CAhHqo1wTRAgk3WesfJ2OzWRU+Om6?=
 =?us-ascii?Q?V82U+HSmKyyyObQrYtr4v0dxNDfyGRoJGRkVTj+TxIyBHvu3mDbTjMYYqE5f?=
 =?us-ascii?Q?qiBF7pAp+vwebs7PZGYh3MbNIrEVLvzSxWFzk2GnJkT2JOmAcC1YXb0syXdd?=
 =?us-ascii?Q?xyW0VgdnvCSVpEPJKeecTd+Gc31x7Upn8g4nPnR7BhkwT1m7MK9UyhQN2y68?=
 =?us-ascii?Q?9ScIk7bNuBbEtveJfV1vDpgD9d9pE6nYuhtVCEdOoCpNvJ3+ulrKFVVSf5yj?=
 =?us-ascii?Q?Qu5BUbLg7ZjB/PD7dmBAR9tccU+RPPc1M087NgCjPB1NC5Ccie7DRtYzr7rp?=
 =?us-ascii?Q?8lhXE6uBsjWmfLyKTIyqpPWaQA54MbG1AB4a04GsZjFrWyC+FZ5sfbn4zL8f?=
 =?us-ascii?Q?XHGLdr0lMw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1mgfw5tXj3WNKLZ0Q9+rfZxwr+wpS7dInjJ7Sd7+Xc7D1gEqqI0pR2MuDybOzf1jUUiF2DQTSj9/IupgeffSpN05xM1cbJCkuFHUXpTvK4/mP5Vo9glcRbSj9leWkARFLfIVnHL0yBzQIEUfBYQW+EBGV5aKDsmYTjp6dTHk+SHHtznZ6Q8IGaCnsjhNMIWYiGMd8ZhNkDEM1UPetugfJ/MtIIiJqqm2IJk9db3iwidBwj84u4Iy3nP6GPjjNNaM4S4nxZ00jegqscAyurtLjsL/xvF7APtG9tdY+YWdQEIy1SHUNQ6UmeAW/P5sH+8vpF24JpqHD4L+2LfkLUjDQvdfOWNrMoHlJiGKOH3BhoWVHz2qJpzNbX9ghVoaidKpi/MG+/3cO4P8hXheR1YmKa/TScMfyaAI1LG6B9Ywp0XnpkI0QMEgRbySnPoT1Qy7m7Dpc7qK7+f1ZCMbV2BL2Eqhx7PXU1foQqwlbagWq8PNnWIxX5vJ8xfg676GSBnDSX38AKDhFUvptwPXgOGs66WoB+ORiG7eXVP67Q3rk2EmA9En7dU3f01RYF2Y233CE3Z/wlOv0+M33V1jkuOHrZT1/ssFf2L8mUKRw9a7tvE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59889dfc-604b-46ea-1ab1-08de5dc31450
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 16:42:37.5241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7ptBmhMgDbCEaleCxVRV0ylGThhCeHS6RXihVmMhzRE2ToiJPB3RZLZSk+UjWtlW47jhwbOUaDsNH9PoljC1cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF8DB18B996
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601270136
X-Authority-Analysis: v=2.4 cv=dY2NHHXe c=1 sm=1 tr=0 ts=6978eb02 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=Daav6VoAPN-8F4mqMqMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 2ZaN9ux43QZKhUCtx-w5EubJXxjHGhuM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEzNiBTYWx0ZWRfX5bsGu+lZ+y4s
 tk3/6XMeNSXmmYIdvD4my5mfRCZy65to9dye23wvmamGXOaubc0BlhHOZh1YyCCszKA+mgyP+Hz
 w40Z5hNwxih6aK5629CO6VBz4ceNkeldqiYwTYAIF8gvWth1ZuqqtdmxH7s+e7uc+v7fXYBboyP
 tqv9OttEjK8rUP3uRx82xqSFZS5v1LL2tS1YdTzHxWeuI1kPZyMCESEggXbNgoL1wXHyXexahFT
 uiTEroFQ8HkGgEWV7+fKYNzBLiIxyRZkMsoEdLwA/XxTEqEMDjibNg/3APYond2H7zSuK/6vQfz
 5i08Ai1H+EAsoCOYHGjG+YzYg+x9Tw9S7TSqpjsA/dn4cZqKvpfw4peS+KwTDIYvarz4V0oJQYh
 mlvMULyzpSdtZnz/YuQlQzIQOjr2g+Yu+3JALx31GW9W62kY3DL5Iswlsf323s6VdbNDDU10kNu
 /bVdcR0BpMTuC1FyeWQ==
X-Proofpoint-ORIG-GUID: 2ZaN9ux43QZKhUCtx-w5EubJXxjHGhuM
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5984840007
X-Stat-Signature: 6toro7cd9rqb16d8cn8thhyfkwmqkuk4
X-Rspam-User: 
X-HE-Tag: 1769532172-4963
X-HE-Meta: U2FsdGVkX1+D4XHNU8PdIYW+tg7vZDoafADQzitRmQRtqwuxldsHOna6JQKATTbQ6QEEoDusvikwjsUAj1rg0TsGkWWLLLitqwViX5SG59ilNaIebsNDfilTSyg+vYpNm2sADmazN/M0vseaKU61zsR9/CCTb2GNZbqrQJnliwLRE2UzpaAkCqyONEEQ2KXnORLSYAxcl1wXPPPKAV93a1adN4E6V0gPP5ffKDseEBSEHsUZ3yJuFk/dFMHhh3h54eyNxN03cCm8FcEiO/q6Hhfy2tukd/3hx42j9urSLKyt0Q01UafTr+RIeBm9PNJ7Xi3Q5/7w8OXYRHIqi+w500BfqG22HphEG0qOMPeuel/O9lPw83o2xPsruvXb3pdJ9527nPFLs9+sScqF9S3KXsoaoaUkVki0XgD9DfEgtOgVVRwX2qG9EgHbYcoSFyyNbXFPUbEPdVGd8VSOkwDPJM69nORMf52uoAq8h4jVT0nz/jEAlQ3jFoKq8iDr9iky48Fw1cnuTB4xXS7fehR1KXuKuJe21MpgOTBt0keh6gkUKrt1dzbrJz4N2gDmhshmCuVpx0Pj30DUXWtfsOVbWisCD0fiRIMXYrolknousr3aDnMfjWfclDTV+929BWuIuA4xX5uH5Xws9aW4Qz6//DsmDJqhsETDnBafw0CrzocByoISE8geYW4YDRV0rb4WXHN5mKYyNXnackdCPE/eNGZu7JYR05JAYgKk/na+ptFmc0ePkN4H9H+H5Vr6nEIsNHMQoMJj19cFOzJsWhGSUyq1VWJtRI5wScRqKaqzJbn40WJos4qCp/srHVzhQHUhpu2Gdb/KmlHNCaktNxhdOOk0cG+ea1X6xdGkpBYVmlFDYYilZHkWhlNx46da6VQVhLpz2zuRZqzyTytZB1LwAO9nd68/so7cuS9za26EGlKV3b4mvzAmfE2jAXRavNF63/tJ1aWzDj3q52eQzL4
 sNzBOwvJ
 qd3u9cm/2YC8ZmxLjs08I7nQPWwhEkQFoKLApTn0dm2a+CP+SYk0osBb3LvQuOJdEwgEKi/h7yl6wmCN03dtEFMbNLm29Nc3F+Bt/0T9DKo/yau35QorzIjrUZVT+w4Ehrl3SzIvt/f7MtSnwajTNVtMf/9hhI/IMHJZ7YqOfRvR9WMc4Q6vnMa+MeCc2gQnkVgDqm1PWjC+n+B2gXuCk69b8t4Ea1L760jOpllXmVomKmDIH6iGi//RXQgQmebgUv46UIrgZMxQR4MFaROddSSHU3rEg+uirBS+hmdPLCVDjYledZDusVZ4YiilKr1SsLyavmdkm+MbWQ3HFxU6ZrlRiWQG7NDzl7ortpY+CKGWF6YOV0+ucSLSwRXXlTvo3iKiHw/MT3w0qhIsMffV+uH5rrCaKs8wGqC0Egwe1e4u7pCE0DeLNx6Bd3dbrfb3I9pfVTudlW9iHA9h3Efb0WZQJxCNwytUBi9Pj9zbT0fgAIONkHX5ecjmDQ0wGvFQZV4FqsNBWGnrzT24KXNBHiduGHLvtql4cA43pMXT/f5ptYpbvgCCXuRvLavLQZVvGwFxMn+VtINDvKB7G9NuKU/C2hdNWIgP6fWF+7Sef7mKfkv0XJecP/0SgZ6JQDGeRwZfyvfMCWlc/XqC1hj/Ai7ajzKEb6qGHP8vXlo3oQzgpugJgtB/xAczWU3w635VAZ7MM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 27, 2026 at 05:35:50PM +0100, Vlastimil Babka wrote:
> On 1/27/26 11:31, Harry Yoo wrote:
> > slab_mergeable() determines whether a slab cache can be merged, but it
> > should not be used when the cache is not fully created yet.
> > 
> > Extract the pre-cache-creation mergeability checks into
> > slab_args_unmergeable(), which evaluates kmem_cache_args, slab flags,
> > and slab_nomerge to determine if a cache will be mergeable before it is
> > created.
> > 
> > Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> > ---
> >  mm/slab_common.c | 28 ++++++++++++++++++----------
> >  1 file changed, 18 insertions(+), 10 deletions(-)
> > 
> > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > index 2e80d323f550..904414c3ebb8 100644
> > --- a/mm/slab_common.c
> > +++ b/mm/slab_common.c
> > @@ -174,24 +174,32 @@ int slab_unmergeable(struct kmem_cache *s)
> >  	return 0;
> >  }
> >  
> > -static struct kmem_cache *find_mergeable(unsigned int size, slab_flags_t flags,
> > -		const char *name, struct kmem_cache_args *args)
> > +static bool slab_args_unmergeable(struct kmem_cache_args *args,
> > +				  slab_flags_t flags)
> >  {
> > -	struct kmem_cache *s;
> > -	unsigned int align;
> > -
> >  	if (slab_nomerge)
> > -		return NULL;
> > +		return true;
> 
> I think this still logically belongs to find_mergeable() and not here, so
> moved there. Agreed?

But then patch 2/2 should be modified to check slab_nomerge then?

And even slab_unmergeable() does slab_nomerge check, so perhaps it's
more consistent to do it in slab_args_unmergeable().

-- 
Cheers,
Harry / Hyeonggon

