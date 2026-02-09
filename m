Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8179BEF06FB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 01:10:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5616B0089; Sun,  8 Feb 2026 20:10:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B6F86B0092; Sun,  8 Feb 2026 20:10:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064926B0093; Sun,  8 Feb 2026 20:10:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7E016B0089
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 20:10:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 68FF213B66D
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:10:17 +0000 (UTC)
X-FDA: 84423137274.12.1520372
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id BCF08C0007
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 01:10:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=axjAkwOg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PUZ2e6Q9;
	spf=pass (imf22.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770599414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVlbjX25M6lAb8QuaS3XZbeGdlgJUuVZln5ZUWOKaNY=;
	b=HZxZkL+xyDIRianNC6Ifjb7vEgPwsYjUaQv6VuOyMyHNOcfF+MtVuhCUsY3aTLXPDrVCxO
	DQR0ojdsMmNyHMCBxEPVm7t5ehWIxQtupmfUmFRuuhA2k/u0JcNrCGMq+Qj67qPP7/sQrE
	BiZdIKeuFYWcTBqnYjrgC5+ZX01ZGJU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=axjAkwOg;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PUZ2e6Q9;
	spf=pass (imf22.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770599414; a=rsa-sha256;
	cv=pass;
	b=Dl237+dgD7fuM8yCTC05O0ob20m1qAL86dO78Ft/jC/v6qbAckFxGE2a+rYqrE+tSQ2f+H
	x65zLzZXQJv2EoD++kSBhQJqMtWs4AC1wq2gg5MGog4azXFERIpNXd7yPiAxw+14bu+Oeg
	iuZ9oiLsjuTCogB65eCsxEQu+aj38B8=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6190H1gM194061;
	Mon, 9 Feb 2026 01:09:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=EVlbjX25M6lAb8QuaS
	3XZbeGdlgJUuVZln5ZUWOKaNY=; b=axjAkwOg63jGrwsKqzNbngzgb4yF29D36/
	/6ATARQApp0MofBE80O2qONM4TCAb95vGqGmDHWnBvXAGm0fKZTgG5jaU9yx9zIg
	okOFbUHF17i6sefrhFlpsc9yXhUOb4JqtMzyS2YtgsErUoRkTHbGjGqcpAxF1ojS
	W3bQMDWMyfz1muPYsknslttpiClyTIcel+Zc8O3Dxvs56SGhGAh1MokvViCMsWsc
	iPCBFLTYFvE+W+t3i64BLTfiS2q3amB+XB7tWpw3Qvu0ng0kcjyQLPls5sjf9VwD
	fEBQrBP+Sfkf4rF/Z2LNSI4b6Dix5PJ9igfwB0fqq7ZtVeM1b4Eg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xhu98b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 01:09:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 618Lln5Z031502;
	Mon, 9 Feb 2026 01:09:27 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010067.outbound.protection.outlook.com [52.101.46.67])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uujdvn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 09 Feb 2026 01:09:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YILQRpRPY4SZ9/OjSpiKCpn9RYSjyahggrLxglGx0BcPYN+OjZlypotXqOEwyV5bhCx70pOrjngSOyW5jYZJ2E7S3Jt6a1Tr2vV1Xo1+HP57QXbVUuUpc2NNxW/Gb6dzTEaduXuRM4CmVL/JqENCFyCNOULLn5+/f2NVbLCay7KqM408vi8zQC9E5/SiMcoWFY7ApWjTJxRwOBPRjmfYdeqnXMRpkgQnc+UzwPMBnf60wgABJMkOLKjBteKMUhpxkciklVwWA3C3rEcD6FeXNUuzxN6QACfqbECJuh+gNvKjlW3JB3OIQZWZgM0P/KRWA+S4L5bqzCBKchduzlHvEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EVlbjX25M6lAb8QuaS3XZbeGdlgJUuVZln5ZUWOKaNY=;
 b=WwiYlxLhx7d3I3thIQtNaKrdsTUSbdhEZ7j+/jwCeABTdKvlq5goJC1kDLlKDzHGZBMurhFt8UV6BkapuGMxKerPWvT1+j9rfdWnuUKT9XtUllC0f7M5Om8Heqt/5Me/eygmaoDvb2YlUyodXd4HjPBqqt3vJWyiD8YruSAXsLvRpKoN8bI77TuJ+FfRp5PZP0HXNnHGbffgG+XMDTWBBcPFWBoCFKBj++EEK9TnmF2Kb52yQL7NMSPLhf+hjHxqCKkEzU3XFZG6ujGINf10rwe8POIOWCpBBjkVN7nM0VvTgF+SvrQbsysBqmg8KkKZYng+NXlhmAId0NwjDaWskA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EVlbjX25M6lAb8QuaS3XZbeGdlgJUuVZln5ZUWOKaNY=;
 b=PUZ2e6Q9Lo6Y4Kxju5CY/YqB2nVc3uqt9T6lsgcLeaior2B/E3XJKGgR4ihxkXUAzcHuUj9v5X9vWVE9QB2VsBLbZE6UU/4gfiGierSWw9MF/J4PzzwIAKhKMT+9s77iz4UcbNXEkt22PFyerF9RAPbdSParD9S+YeO0lsyD8Iw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DS4PR10MB997669.namprd10.prod.outlook.com (2603:10b6:8:31c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.18; Mon, 9 Feb
 2026 01:09:22 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9587.017; Mon, 9 Feb 2026
 01:09:22 +0000
References: <20260107072009.1615991-9-ankur.a.arora@oracle.com>
 <20260206223801.2617497-1-ankur.a.arora@oracle.com>
 <9717eaea-9bbd-4612-bc45-c7f85fe1ba67@kernel.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org, akpm@linux-foundation.org,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
        raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
        lizhe.67@bytedance.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3] mm: folio_zero_user: open code range computation in
 folio_zero_user()
In-reply-to: <9717eaea-9bbd-4612-bc45-c7f85fe1ba67@kernel.org>
Date: Sun, 08 Feb 2026 17:09:20 -0800
Message-ID: <87zf5ibu4f.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0388.namprd04.prod.outlook.com
 (2603:10b6:303:81::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DS4PR10MB997669:EE_
X-MS-Office365-Filtering-Correlation-Id: 2741c1d0-b6cf-4ba3-53bb-08de6777dc1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XJGgmJNTkpGsiKrNJqtnmZq98CHSnuuhNu39TRQL7bayQo8W9zN4KvOMfoGS?=
 =?us-ascii?Q?c9mscZbq5ekoTpIoGLUHNQs6rX+eanR0MiZsRwkpuPyJz+Rblzy4PUUya1Js?=
 =?us-ascii?Q?b2ZKiF2BSC2MpBsdSpgsKNZwGTnJwSfzEydORpbcnJkHrCxXxChQ6HQ5Rz5B?=
 =?us-ascii?Q?1cRpER9u8Ox7GFNR9l3N4lnMCFApIrcqKnRa564DGq7JPvzzsKIXpSPp2c8q?=
 =?us-ascii?Q?VqiuQe7Evk+4Q6nZqvLP/KpiH27bs8+9FKCyU87gL98OVm5sT1TMrW7SwHjy?=
 =?us-ascii?Q?J+PBtZTka7j/6KOPOe6uZPBl1+lMm6u3E+Tf0PVKIxQd4s/msbD4E7DtCdz6?=
 =?us-ascii?Q?EiUoYLpYea9eATUZRRFXoy8NNrw8dFCEuJ+RErD6QU4qTyhvNW7joycHdweb?=
 =?us-ascii?Q?CSaF1wR4qaCwpP0/5+UBSXzI8n323e19s4dmKd9AEQOQUqasith5gNWKhMrl?=
 =?us-ascii?Q?N4mW3mUttT3pa40RsRORVE2QMv4TrXPr/qRB6Vd1jJhqzqAyeP9j9uNgaOMg?=
 =?us-ascii?Q?g6EOnchJfqi5oE+HF808RdkLbpd7ozeYjaymjNC4kpyaNZr/rIT3XwdEzeuq?=
 =?us-ascii?Q?1m8RNbhlSYkwvIxjRszfeCQ201IfACXGDDrtacpov0hvUL4uEAZug2nsWEER?=
 =?us-ascii?Q?/bT753qLkRhmLlmjMTjHQO/0TXkgo3bCXXgZNr2lG6ztKPuqq7V5QFbTHOWr?=
 =?us-ascii?Q?ENZBbyxZ3cNG/FAQ6kiukQ/gu+hCuRDg7ew62QUjWQi+JbskOJC77q1XLQr5?=
 =?us-ascii?Q?76gHkGN/aSRqp3ZMpMubb5huP4GEnGSKRJ2quVd2e9e0zSheaE5KVlfw5wfi?=
 =?us-ascii?Q?4UGVoXmHCcJJ3sqyupduorp+Ue+QZz4mKYd0rrbX9AG2Kct8Pfh7b7YKRwDI?=
 =?us-ascii?Q?fjcu3DgGaBbDQbumaHjioMX0P1Bln1pRlHqjBNjeZ5odMBEndroqVW0KwV01?=
 =?us-ascii?Q?3nANzO1cPFCNCWVZvoxStoRfa0QPxL6041M8YXeWIJmBzhr1P/cBZtStKGDO?=
 =?us-ascii?Q?WLiGRLzIhPdDTjQRN6D8frbLUnQrN2GDqyzHjXi1u0hM/HICN9yjf21UInho?=
 =?us-ascii?Q?8FCq3GT4EW8I3pT7qByfq45dqAZ1jqvyo+7wcsQgGITrkA5bW+RAHutgzkks?=
 =?us-ascii?Q?4BrTRpFUEQAnDycrbNR1edxHyTgtmgvWlCe6/fAgRB1q8Tl9xdu0kAvCxUZx?=
 =?us-ascii?Q?F3OOLBjzlQS4+ZF61m1GK5pBX4M7pG9LebkepfsbseE4u6hZ6v9/+A9o/8Nh?=
 =?us-ascii?Q?VOZbc5AMH/9p/UTkuX1HFG/PAUgkzf1lRR0fv+H/TKISGuIzc7h6NlpkGjB7?=
 =?us-ascii?Q?N70ZtDGrB1T5G10Ay59yqfUF+HIQ8aTawB4Jx/XL8Ky9iD6Z633CmIeJCUk1?=
 =?us-ascii?Q?WS06JnXwlhh8WYJtL6w+OllYsANAUoA3TorMbu/NWFP58w1MnhNZeg/9Ntvn?=
 =?us-ascii?Q?315yRw86UAWgNIFa2K3bfylO1q1ggI7uchLnmfiEl+R8aF71ZGOsz6HGGhL+?=
 =?us-ascii?Q?iXuJ73LyFSFuQkTjBG1zh9KpOHgedq0ckKToNjiiPwaw31H3/n///v0MxxtB?=
 =?us-ascii?Q?IWxpZEr3jJa3VXABkDY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mJPcL+VFrXVlfeBN08f59QUd8IifEon8jgeoL6GL2iyU9LXkvrpsJMdMf7+P?=
 =?us-ascii?Q?j9t3lIMBmRLe88mAsko6mPEqSm2SujRcjjEO5oJzgSPQ+VViToJdlYkOn0z7?=
 =?us-ascii?Q?+p/Gb4BsD0qf5dH2g+ivpdL7erEUw2yriFumUtF88y1ha4zzFTiRyEE7UCe3?=
 =?us-ascii?Q?mHiPMe32xSKR8HRj80xnLvrXiSm7otdWtxTKIsPykRBKQqPJ+k9uoMB8Y91N?=
 =?us-ascii?Q?n+6WOpoGmPIw/5qetsr/OgPHXXOubYlzZj6Tu/uyUe0ZAHyyNGjp21anZ7Nl?=
 =?us-ascii?Q?A/RZWT3i7kYrWEWDtIfJybDjzD3CasYbRNdxI116zbQlOnllnNeqrdZe8oAg?=
 =?us-ascii?Q?eZticy1FeZ0b9DHKZnO0UaZgK4WqQ9blZWAuPu+fJwk+YYKqgUqr4mzrVDe7?=
 =?us-ascii?Q?l/sNThIL1oeB3pwMf6e5oJmDssEa63IuZacMB16XzPZFh7SZRscx3MOV6lPw?=
 =?us-ascii?Q?BaaPOotlHnTid9S0RbBhzawpD1lO2rzsMHg2i8CXLuh9v6sPlqvUaSAFVxsv?=
 =?us-ascii?Q?PaieS7MRfod6DKAKhj3FHQ6har7ccU1WshFRRmaliPnvDw2BjrZvQ6cxB9WT?=
 =?us-ascii?Q?BzMBastwpq+SjDrAySiTV97x6zeTP86LkkSQJEgBS1OWQfEETLvRqV9PNyvR?=
 =?us-ascii?Q?A30NqYKzt/VptTdt25pqRf8ICC0jEwREeOdMlhM/anTMvrB6ukHjg3SGhUyS?=
 =?us-ascii?Q?gR+2QS/S38WFCYp8/eeC3PywGtvmSl50gEfMuJMrfatVyn0Qaqe/pFBUGs/U?=
 =?us-ascii?Q?2o0KucOzvlNZ/8+KVcOxryq0l/PeeF9VKe7px/2F3FSMR0WpSjDT1GuwBKrc?=
 =?us-ascii?Q?caFkWbAXTsevQUtooT0NAXAT1ADXON1BDRd1VUucwfWGUcRWnlpGJWb9LUAx?=
 =?us-ascii?Q?e1O0QhA+kaXd1xahQpErlbzqT9cDlHiQPpe57NSIYL6oHYb8MjobEVoeO9+o?=
 =?us-ascii?Q?0Vb86YK6FWvaIglW0AygXh8mtU/jlV7tUtGmZ6RnBzj3+bYWcHaZdbmy1yPc?=
 =?us-ascii?Q?FrXPj99V1beM6LCQdpXk07hAgUCwoW3pFPBFXkkweEew5+FX1c4q5hYOISbe?=
 =?us-ascii?Q?kG9p1lnas7m4zlauRQy4mAT+1PXftpnTLYacyPhEY4HY9rcf+XHnFZ/MIQ5m?=
 =?us-ascii?Q?0Rl1robx2nGE182oJ4YX5ghheGnzOAlwe6s7ayRxegwGO3zECD9yIDMl1N+4?=
 =?us-ascii?Q?TL5YXuEcLfCMVcA9GbB7z5ZJi6BQahVyzFpd/SiWDYbhIGcRBzaA/SiB+xpI?=
 =?us-ascii?Q?HyG5KzkBcmJqOUqho7GWuj/GUJwpDEgTW/zKTUI+Uyiu0AoywtFzQ7r+SSdd?=
 =?us-ascii?Q?gMeZTC6NVrJQK9jkB0RcQCGpNWVJFHKag3Arv7BSzbimFqKlJCnu01fcuVAy?=
 =?us-ascii?Q?ghN4/kstk3KjABFAaapc/a6TCFAWEczPA41XMJbfM5KHcrjLDeUpTF6NWdMz?=
 =?us-ascii?Q?BaxQyL9FrhOiBrpGSt/RQupvIjecnouo8KvwLRnxczPPB0tNfNmY3IjqZQq1?=
 =?us-ascii?Q?nLZ42mWa8prtMxDwfrUMoYezN7vTK51jpS8s7v1ZxqsYMDeKB7N9JTJD4w0C?=
 =?us-ascii?Q?Z7OhUkVJ9nLm3Qy84gO2eU2zaaZQ1BUqQJAsO/P8PmRdKaSc+qxYYAOnJ/oW?=
 =?us-ascii?Q?ot/yfj1jQmgXAehssJlWiJ0SJQbtVcBrQyvmxTzYjuY0KM2exB+NmUR+OVcM?=
 =?us-ascii?Q?dvzCWJiyTwvAH0qNUmHPKDygvkagvnKyJ/q39eo8UIBaDdA5cThZDnjL43XQ?=
 =?us-ascii?Q?IgYP37YbzF1TxUlUKJuxxb7V0XXas2E=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dUlcmc2eJhGKesSaIBUdStJ3NyktiX4ytalB3IMtRlBtuCOUcE1R23ZZIlmiQ00vMgjOiMFzLX7LDY84mkHY+T6Gpc4IMcVI2SXmvpGe/3AsVEGd2XGdjgZ4L1k89iuqhkIqlDe5gscJurHOphvQIilEn633z4YUwi44AEfYLAqL2FrmPNx7Vt7fe9sZs5RTqAhlzfJRVGNuE+koRbuvh2dhWbo2CLmcnSQIxa6ggi1hjxoU/+30HpfhVqh89yb/7Dh06RuknFPBcO4igpgRgQ47wLbBtvGsZhhiLmrKhgsIreDKFcVSgRaZFMBbWkC4zlQQsAOp4GDv/t5gs2b+bW0Tj5EdPNGH7ioJ+34yLh+NBS3ptYO15wuafuv++QJ1I3dNxWlEsMVsni6a/bw+UZtGKBipanQFHu4XT0BXuYWpyASY7WdxPyXsENSBrTZDmjtQreBx1FIVPTLQi/ZrBjXNHYiyESCBXGj+Q/HF6xfClbstiN34OPfL5wnS4C+rm39l/Js4/u2W7VG3YMoFPOzZBIPJ3aM1sEJ+aS5vdIOeWGsWMBNWHKBsGYc/L9mItj73JElKwqzWFYwxdJ4miTvFfgZJbkbbe5feND4icqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2741c1d0-b6cf-4ba3-53bb-08de6777dc1c
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2026 01:09:22.6591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: La14UFhzYMOFdwc/BL/U7zZ2p0ubg7iW2S9k78ZlqxkkrdbpooIomXcwwEQlmtZJO4SMBnX8pX56hWigtGS2UYc8ELPHZweIH+dF2bWphuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR10MB997669
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602090007
X-Proofpoint-GUID: 1XZYXQ7aUISWd45wkEQ89k4YtpGEwTU5
X-Authority-Analysis: v=2.4 cv=FIsWBuos c=1 sm=1 tr=0 ts=698933c8 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8
 a=ZBvnUGlFa_PvFjWE9QMA:9 cc=ntf awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDAwOCBTYWx0ZWRfX5LzOM8rH1RtV
 tXI6MNOogJWDHRa3zcnB7XnUFvOxOutSejU9lBumIYWI/jkb6sJJ9wvd31wczmaEi8wu92ut/6N
 Y4h/eupj8GIiQyhBgcS60w3TdtWS/T54+k/O9qasokGsXWhmnPitzw0mdOrNz0q+fhX3o9ZRusj
 P/Ng6eCjGRsxCRWZ3x+hZRhUMH7Je0X44pMq/2ltVpWUM0fX9uJigS+74jJAPwM3bYThW4yiciH
 SRbVAJKZoepPUuVYDZLmKFi799iKGKz3BOSFNR6+kDiTBewXAbkSV+xh52r6bUq/7XCLiuXbBrd
 SeczUnKG8cjXB4q2B+gg39q42Sq+lLefL2mHYapJvex/32JOCCxxLkTIm/PN5xBLCHYCswrcFyH
 GK044h3v45yq6wh9sx3/TvBuqK6Nymzl60jaaAo98AWsx2UeNtxJNPBkbjAPIsuvpyA7fLAorDa
 uOzBdbtofLNP2Mb9hBRzJ3Hxa1WGtFYcWLuyZPjI=
X-Proofpoint-ORIG-GUID: 1XZYXQ7aUISWd45wkEQ89k4YtpGEwTU5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BCF08C0007
X-Stat-Signature: ndho88k365jx3s7m3okjigj5b86wb7aj
X-Rspam-User: 
X-HE-Tag: 1770599413-984167
X-HE-Meta: U2FsdGVkX18GIiJ9UUxn8E6n+MN/dRd90k/8pgH56uWg52g35FGSNKaX3vohhiGGVqgXlsCf+qomZDcY19DatKzobYjXPPHU9FkvMY2mXUfyNrT7m7gxjlMS2ZV1KFXXgBUBae47KKqWC+1AvtGWm+piZGmKXqYYCUoq1+hbxoAePBrCz3gcGS9+nyLtoZk49PdBjqZD+byjvPLdLUXdDtHwKhxHhouG/DqPky8Yu8WYewwhwYI1+pxFSyC5EjOuYtRr6QBs3eg9/lIRWAx4J+dN9TRXHGPIhDrT5NoE1aBh9ADZOf5dLHKNKacEcqmMKVkSAzLh5lG6CDyX3tHuVO1fzBbHEjqYhM3r/nBN+Phzm58kL+zR8DgYK9dxa/Ljj4FytOY9mJYUytIYsqzuEmv0xZSEZPbertS7sfRDHGHxYnGehdqb0VhoRhu6tf4DGIiqMKvqoj3iCjI97lsduq2VAcfCYiB4onn4OBPjGrDRySAe0/yaStVYkx7jV0Jhp5OhHMIKUIw085Rhqx3F07/gBQzOJYUup8CD1PCBUedujjaEqqkM2bkxcw16AcRkV8DfMAbheX3IarCDWotYspFiILvVCj/EN3GmoSC4kLRNIxSX9A/AsjfcwoO0bkboX8hC/PmkXHH+q2ZXHjTdA+9lpVJulatHjnTs2PgNDnA2FJ2FlJPXIQNwhmTAUSYg62Nk8crgrs7oRxc63rp/5u2dOryZ9QXm/jyBQrmC1StZUSpydJJKYe8YC0r1aVny6JfvfzuYfXaGpRJSRjvzt8C7InNrTJO2f31w294L1nklEPgPi2HFvjz7vWwGnZlIpudjOu90KADDOreud/jmb1oiPe4L3Xcbv42zwzA+EguWGGfqw+lwxnKAtdrV4pmapYXlo3m8+pIhkgRQTrXxmV7eQHb0DieKpheXL4GKr7Ztf3UkyE31bpIlaKaTrdbcuFnZsvFZ0BRvsc6h0OG
 Uat3835y
 dbc4rHl8SuCowg9vKuOHkwptPCCudbOqKGJdHfRWeJwCKJlSvEodvJF3j8zBRBjPec5VTGratMuMCCRj3ZPlayHpXuGOmzwWMmkVCfJqSOIjQDWuxyzeH+9oAvRnJfVXUp/alOF6CIoM20iCXleN0Y5E0+pRaxFSafXGjfLPbehlQOK4wfaWhdN1/WTZsd8p4bppQ2c1XhXbazRhnUQovSbC0hkjMQfzpzequ0JW+ZuPP7S77OSnwMzlM2Ff+eHUdnrClGyHT4YrP/crtUTlERZs7sb/3UfYOxA98oiMhpCaLlOsp3JSke1jSEMzVtD1us5RHryDsOXBWXEnt0ToKjkVZjvSxlY11T+TsOGUH7lVfYWEbAGLzEWEkR2KvQzTvzMsXmBIQc7h9BQT7QuIKVyPjQECFyQjWkS4M4/hZcRN+y0ZnXStma7Wp8vnu5UBgW1XG8ygERZUsAQa8HjJ04n3LXRwNpPbFu3fTP9RwKMeLFURDLZu0X1iT8M6COtFD/bRlbvZ+g/JtLwpfbcwHaSw3bdBbQFl5A+/ekVP4/qz19lZ1JPirtI9zncQlaZoW8JLUzi2Par/UCky7c9CauUjdOFM8ND2GG0pcgcGKNJk/tj3G8QSuI4llkHA6RnMMn1jOxu8u939L+0jLz49X7mZ8Hqahq63pRjCv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


David Hildenbrand (Arm) <david@kernel.org> writes:

> On 2/6/26 23:38, Ankur Arora wrote:
>> riscv64-gcc-linux-gnu (v8.5) reports a compile time assert in:
>>     r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - radius, pg.start, pg.end),
>>   		       clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>> where it decides that pg.start > pg.end in:
>>    clamp_t(s64, fault_idx + radius, pg.start, pg.end));
>> where pg comes from:
>>    const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
>> That does not seem like it could be true. Even for pg.start == pg.end,
>> we would need folio_test_large() to evaluate to false at compile time:
>>    static inline unsigned long folio_nr_pages(const struct folio *folio)
>>    {
>> 	if (!folio_test_large(folio))
>> 		return 1;
>> 	return folio_large_nr_pages(folio);
>>    }
>> Workaround by open coding the range computation. Also, simplify the type
>> declarations for the relevant variables.
>> Reported-by: kernel test robot <lkp@intel.com>
>> Closes: https://lore.kernel.org/oe-kbuild-all/202601240453.QCjgGdJa-lkp@intel.com/
>> Fixes: 93552c9a3350 ("mm: folio_zero_user: cache neighbouring pages")
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> ---
>> Hi Andrew
>>
>
> Thanks Amkur and hoping you'll have a nice weekend!

Thanks and to you too (or at least what's left of it) :).

--
ankur

