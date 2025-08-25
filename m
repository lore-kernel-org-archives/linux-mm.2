Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76766CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8B18E0053; Mon, 25 Aug 2025 12:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378818E0038; Mon, 25 Aug 2025 12:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F25E8E0053; Mon, 25 Aug 2025 12:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 071268E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:49:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76409139406
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:49:24 +0000 (UTC)
X-FDA: 83815865448.29.3B258DC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id F38824000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:49:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qyCW2XRT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tcmyRe+P;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756140561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mr+7oe7+GxNHzPMJFG0Z+83h6tjj18cS0qE1HtztNag=;
	b=bDymAVPNXNCetOXrYpHaYz8wD9MW+ETYA3lvgrck3z37lN3LcXXEBlYWzHQlTvRSmsfKCi
	NSk5+QPe2U2YjbuL6bYepRCkeDkU+Uiuq1x8IWXNmTgiVN7qegnRlf4Nw6qRLK5j6vsJsu
	Q9GG9NZGAdEMVfJBkKb/nb9A6Lk1h8s=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=qyCW2XRT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tcmyRe+P;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756140561; a=rsa-sha256;
	cv=pass;
	b=UZ17lzi09WOjc6nKIgM/WvhQL3yJT3f9+Qyag7hgVziphmbD2C+cRZM9sC/vJKb+BaTwQ4
	9fTUGKJMVXQQnNSPyPkKUfYXkZ1xz4v+W7pEdOEM7QEacEGjcTG1RsWvqWlx2S9QD9KGuN
	osNu45//euhrm+9eMwZlmUrL4W0iozY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57PGmXdN017797;
	Mon, 25 Aug 2025 16:49:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mr+7oe7+GxNHzPMJFG
	0Z+83h6tjj18cS0qE1HtztNag=; b=qyCW2XRTBj9ckXjkDU3X7eJtYxXtrhe8B8
	ZuopXuxZN93RN9jvzUzYUrfDDLCtTP4S7PFjlNWLfhExeixJfj/I122GUanwakBW
	O5hS5zu1AVx3V3YjNltb+n4OPLo2mZJqfTMknUVwSbG+0WDSYT/oXkTEt4P2gWcO
	468AsyHcL9n7bLcJ5/IO9wZJ5BiiGRjgSxBUmTEYBnyZDR6lDxN9kMLToLmWMTls
	vaBe1z6Cf0soxyrG1nPMeekp4SZGR39BHOsTRxOo3JiJJfi3a4mVTjGUqZrckzWj
	Sbkvf3xZ3Z0F9sitntUccdSn1yAFsWiFqo85Hzg7Lm+ZsX4VpDKQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q678tpr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 16:49:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57PFDerG027115;
	Mon, 25 Aug 2025 16:49:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q438d9pf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Aug 2025 16:49:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjf6sbWYpFyMyH7y7TEY25AGeaSnk9f8/IL8x1hMC6bU59gSEj3ZgbYUN3XQlqPS/idX1GgB350tRzFhvmYqvsTotIoKmH/LaLdeGr9LvKFNtVB66Ggw6Rt2g7zCqiqSbrQ32wCagVSLs64vtnQB8s/hFKyBLC4nDcus4sYTZkl/dbg/KksGOFO1jv3vHSVj1Px23XVCDNljhhc8hZp/yv50Wj/o4LuH0U/Cgd2bOeNKjHj+fI8pbiYBKIwcA9nQCUQk91AQgYUXYOAfqD+l5VyW1KLceIZWQbcKfx4dRsOGvYQGcegH88nB4rrUATay0llzTWV0SW1LyvYl5jOjSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mr+7oe7+GxNHzPMJFG0Z+83h6tjj18cS0qE1HtztNag=;
 b=Xt5rRWp264i5e2sVtyifLjKSL8IXwUQqZUijGN5OD1eCLCsY960idSDAlwxzZtDo+28UtOnq+k1B2hbicOBXbppWdf01hTfp7cC17xJL4vMAYmJJgmkhP45UahiPcU7gL7//7ojSUaTX+6oYQ7M4FusTFoP+L14w8G5WZfsTh4EgSImkS723+wgqfIsShxgoIKlk4PqUVEmNWg4UWltN2p3tfN+q0QGmusRIcX6u3KA7ebZOpveEcefyi6VmtTu81G6zhOmHzpvsmKhKsYDrXp6yNdQ5bhK+Jltyiat1MFbG6FLM3zuElrdsWuIhSGjFpBg+vcYw3TaxSJEGvdVoqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mr+7oe7+GxNHzPMJFG0Z+83h6tjj18cS0qE1HtztNag=;
 b=tcmyRe+PeOHGdfWVzSCGUrk74xtDmIYBeI+hk2AL0Z0EYLTlHHwamKfr04xwM4TJIjfo6y4bqrym0DIj6eNP6Iex9H+DbP0d5mVz4sWHscAjMp06lD44eva7+vjk/BIa6fwE2d5eon6w/3n12DFULCtu8RTiMPH2e3e29QfJeAQ=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4707.namprd10.prod.outlook.com (2603:10b6:303:92::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.25; Mon, 25 Aug
 2025 16:48:36 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9052.019; Mon, 25 Aug 2025
 16:48:36 +0000
Date: Tue, 26 Aug 2025 01:48:25 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Marco Elver <elver@google.com>
Cc: linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, Florent Revest <revest@google.com>,
        GONG Ruiqi <gongruiqi@huaweicloud.com>, Jann Horn <jannh@google.com>,
        Kees Cook <kees@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, linux-hardening@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH RFC] slab: support for compiler-assisted type-based slab
 cache partitioning
Message-ID: <aKyT2UKmlznvN2jv@hyeyoo>
References: <20250825154505.1558444-1-elver@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250825154505.1558444-1-elver@google.com>
X-ClientProxiedBy: SL2P216CA0148.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:35::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4707:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c865fb8-05a9-4a37-9361-08dde3f73bf8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JKt6hEVRHycJmZhy2g47ALsMybszRfM6X+Nw0ptjyWHUqSCHUEiyQp8omQKZ?=
 =?us-ascii?Q?Y8mhcxD5yScdKqukZLnsmPzOxALsME2K0OohnKQT1AF9URZdZxfVw7xjGBn/?=
 =?us-ascii?Q?JhzyIhWa6x62ot5Igm33AJNAIyuKO757PefhR/Qhj06t5JgN++VfxfjeogEq?=
 =?us-ascii?Q?fuy5BPXwIm8puvAMAw6obz8E8Lj9jRtOp71TPzEBBW22Z7jfNnaeHaWKNXdf?=
 =?us-ascii?Q?MxmAC/jmz/Dh+IGnrox2ZOukdmJ229Q3AlFV82xln3hVrTrrCakjl8cGulM5?=
 =?us-ascii?Q?D9RSI35GzB6Rb9gIfWuKCsEvmyTN43TVNMea5hjg/hqFBLhLRugmQqy/du+7?=
 =?us-ascii?Q?YnAuy5goMpXUrQPXs8X80v/v7/hcOmuEezyrNtk72QO3ZreNR6xOYGUgKp8+?=
 =?us-ascii?Q?knKhZYwMaiPzh6D63fLhwMgEqgsCOPJHsfv5iopVHkPHhsyB1oyF0OWe7K84?=
 =?us-ascii?Q?pDhYJ3JdlZlk+SUVFeW3sghm/NOqdcgrnzy7Y2U/qP9jGokd+wdNnM9JQr26?=
 =?us-ascii?Q?AMKlUCUTUef9I52S5ws57O8xs8OtqsCcjx8HjnmvDAPTff2EOMeHjYNVGwk6?=
 =?us-ascii?Q?S+Wrcn+rVk+DyB9VOr/ZpP35b9vUtgfxT1XTAl6S2LplSMHDd+DZK24bzYvi?=
 =?us-ascii?Q?Rp5R5e2yOgVcyqzf1K3uZk2Nq8XNDBNUf/yyX2H20nLsRAg1NoKXginINPja?=
 =?us-ascii?Q?Kvketdynm/eVDvhdjAZAxmSmAc/7S3JhWj7da/J59BbjYRzaSVRebuMGBXmo?=
 =?us-ascii?Q?GJooYg2gkB+gWMNrJNvWMoaBLz5+pwq4g6b2jBXpGBb3NyIxsLKLzGnGRGk6?=
 =?us-ascii?Q?pq56W9eYrXGdxAjzxV6PSALzHfbucMwKMlE8TnxsKJYKjKcRUXo/Q2GhtSoA?=
 =?us-ascii?Q?hagISV9auwCY0v7Ll4BQLIMx5+MwVDLdtIjk7ZXk16YArRXJwNyrrqj8fUcA?=
 =?us-ascii?Q?dFjcqTdmRzipyFVsEj1UXOL6wEaj0xKJJrlAbuPvg6IBsoP4fSdEnvd32Pxh?=
 =?us-ascii?Q?DUQWsOyDyQQZFlk9V2fU+x4gHxPt6fu0V/STlVfSHAkZ4u7RJV64i0V9T1Lk?=
 =?us-ascii?Q?+mftBvq/nW8/NEetyYXTCPdn5+KjRPK01dR1MX0ipD9JaI4V1ie0W25xXu/t?=
 =?us-ascii?Q?7rC50p/IvOqXGOzg/tUertA4XGZqZjQsL8x4huhkq72qNRNjg/NyloRZr3+e?=
 =?us-ascii?Q?b3TPQ6CZ0kqPE+E+VY1DAInTcqDYS7qQe9VS+0Yjp+m88us9BhyaOKBJSvHn?=
 =?us-ascii?Q?w+tJr+XxK+tp0Gveew05LXRCLzBkaHd8FiExOFuWBvrjr0x4SWQQO8N327Hi?=
 =?us-ascii?Q?s5hLQX7s33UOlLYbL0gkJqD7zpme0BOuMXUPAJz7fgNo6eMhaIwc7iMwa/S1?=
 =?us-ascii?Q?phnFBl+Z+OpwkYfIkFrXrsaC1deI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uTWAQb8W9cg/pDuZtoo6RoTJos3bm9Njr5cBH1VLnI1RvZpF//0ReO/V/mYB?=
 =?us-ascii?Q?PqBmi0YLPYiw0l1yRQzSWCy1tB/sYxPmIFL7tD8bwxQo9zoCaj3eC0uDC2Q/?=
 =?us-ascii?Q?QUuJ4jgJDheEUKdmJXgUvvpMoP4UvW7DGccCTx3Vl9FULgum3oF/tJr+g7h4?=
 =?us-ascii?Q?Qrt/C7rfTcuWLBW7GVT7DmvsKRk5+X6nJ69t3tPRSf3a8E4quL6SHUEjghNU?=
 =?us-ascii?Q?WdWxJo1jJUcn1T4y2E44gC+kHSiv0UJKCYbfXS7iniJOPSQe8+0yDWQrecHx?=
 =?us-ascii?Q?s3Q7NmQAyx8a7CHUi2RZ+/G6rOVJaND23xpv4oh9fVpurTTQFW9H7fztNd4H?=
 =?us-ascii?Q?5iA8ri53ID7CL/zoEtTBWZUwcRlb/zHf+UVN55z/HRDKnwxWQz4X6sEpJyr7?=
 =?us-ascii?Q?i+4xkGL0FqT7KrrcHxgNs3iL7VS0KQDHN6Xw76xjKR0AdtvNfELqY3nupcdA?=
 =?us-ascii?Q?kxlnBYz2Mkasr7oZqmKLv4PK+iEMH0/1XvUddAmtJDNK4sj96fdEex2zBZzB?=
 =?us-ascii?Q?ND0nCCVbXpsLuK02xeBgqIj1d+Owqn9ja0ApWh/l2Lw2LH11HNsC9YH09OLZ?=
 =?us-ascii?Q?JWnzobRucQrmCMkEFDUUsrsrE3mySvX86M5qqKgSUFB0gAVv+UfeuAHqLz9S?=
 =?us-ascii?Q?qSG3ns0vDQsU0FiRUDLkuDGb9FdJBuPZSSy0lHepmy52EfMNS3bgaG5DOUFS?=
 =?us-ascii?Q?gQftOw07CvjhDxqpgIJfikPJwbIPx7dr/BZ9cZ0mdj6LmbIxrb/EdIkdMwmi?=
 =?us-ascii?Q?1SGinNllWZKVHQOb5/OAAGZnAtyFVYBQZp0Rfn1dgBgvdARd7E4/5c/RX/FR?=
 =?us-ascii?Q?CebEuJlSkwENb0tTCriru92d+JLj73fHPBMQHzU7/oogTAydFOdDHA4lpgLl?=
 =?us-ascii?Q?gW9tKEZjcCXzV4U8UW9n2AGPcG0CkwMBFjw+njJ0TCTM/gHuoMvpOdUgKIpM?=
 =?us-ascii?Q?Bczm2U2lJo+LbixdyOJTl6+cnmslGKNxrYYOlF3b7OCZB1pj9oCzkHFM7ava?=
 =?us-ascii?Q?NG73qDjmy+Dg5ZRKmMCNwMwM9GhsVii9sQHDN0/wPhovb06gBbufSRAEGPhz?=
 =?us-ascii?Q?MDwBqL2DS1pqz3SVPZsTX1F6glS0W612Ul6WKdipCAN1ra2ND8gHUSsy5TtX?=
 =?us-ascii?Q?guSGAevHNhdps66gBz+uiswf14qqDg7U1vEZpCjR+1Ka+oqTG4n1VYpt4L0M?=
 =?us-ascii?Q?cDtlthPdkjh7OrxRM5VA/lKHR/tOu5BqZtaxFUaiKDqSq3nXroAHzTz7UzAw?=
 =?us-ascii?Q?nPc6l5CRI7fS/qsr49Ggn6xaP+MfNgS3hmdHJhodXkQO7RuWTQ+Ga6WNSPm+?=
 =?us-ascii?Q?CWMr57+iBnhKoEtCpPUdEY8Q0DBjGusocQ7cJI5hoYooYM5t8IBk32VA6ojm?=
 =?us-ascii?Q?cxcouifDDgnQPV912KJ42Zsm4D2axHjq8MoDxdr/ftlcuznR8ga8EF6i30FK?=
 =?us-ascii?Q?DGlW/7CzxBoIJ57DZuoDjnMapKA/outRcvGLXfdMNR7Yh+hpsJn1gLyfepqF?=
 =?us-ascii?Q?HBSu0g4IPIrTIc5w+z8RH54q3iRKq7MUlVsUaerLI9xDOL93JOFWgihA6DIJ?=
 =?us-ascii?Q?Mh4wQRVKafKhHxp7iZNO2N++a1dEiDZUgJkO0nSo?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wUtxIkwVThk9WUyJ52momCqYhFe/5ckJb1e5546OHSXdccTQr0dK/d2GrRTrx7LYQ215uKgEhe4MoVNtSGM9V2QeHZRWOGOX4EJNscRc2Xo3koIQ0bXsXuiY/2NJY9G5CrWI2BtYB2+/CypXNgk0+xzdZM6z4sYH2lyQuyZWL1a4Q4tkLR+IMBuUWBsL9MDYwxvu5z8+gVjlmQmwQBq+eM+TQ4wWCVcxNFEMsVHyu+p1pMeQBkdCN1qZAimO/ZAcQb70n4kVfF7l/XZcjLAs3TYRG3hH1ohkU051h+oBPD5s8t+5c8HvRb0AZDsxTEf65/OkrlLHf80BurZOsOcaIKJ+YQzD/QnqssSd33w4+mpzuEKVhDFwTSFiIV2GdhLVxVXI3Jnm+T5CJtGGCS4W7gLvybw5pKfFYQ7N0wmRPF6/i1/f80/0jVz+R/KeNx6wYILvSHJJRH5iADdh7phvEnpVyaAuahWx8k0L5PUax0B6BczdEDOoUndtL9aS+vpJIcDnFNbSY6bUji+MCywQZWtejq9ljmlQZGOdwBo6Nt/ajIWkyrQte5BbwuWMGFOHqCkr/frJJHKuIKiPr64MHLLT8W0t24zZw40nvjtBujc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c865fb8-05a9-4a37-9361-08dde3f73bf8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 16:48:36.0506
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +J2irPtPsqM08DbOIjDHfopo5wosGz4Luo1zvuYpzSHk78+ARz0wzAd6vGUtnC9kyUa2oe21cVSJGk8dL9bpxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4707
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-25_08,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=910 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2508250152
X-Proofpoint-GUID: FAoVjG1JL1ZneHmF7S2-Rl6wafGz4Ms0
X-Proofpoint-ORIG-GUID: FAoVjG1JL1ZneHmF7S2-Rl6wafGz4Ms0
X-Authority-Analysis: v=2.4 cv=NrLRc9dJ c=1 sm=1 tr=0 ts=68ac93fe cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=NEAV23lmAAAA:8 a=Twlkf-z8AAAA:8
 a=RaiE-mXtAAAA:8 a=07d9gI8wAAAA:8 a=1XWaLZrsAAAA:8 a=1XCi5IOhF-I_6B7-_WIA:9
 a=CjuIK1q_8ugA:10 a=-74SuR6ZdpOK_LpdRCUo:22 a=6wq-4gwl32YbjisUuCrp:22
 a=e2CUPOnPG4QKp8I52DXD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzNSBTYWx0ZWRfX9/69+ejzgd8Z
 4zYWpfisyoW3U2ND7xNuUJIYpbJGPucV5m3V/Am8cHYhTGW5Kq5KS1A2dvMf2hvxfW7Th3oIfS+
 rH/GOxfzFLavNWjshV4y9+UWsQW4zLbP0qeCNyDRUDhy/mXiSJqXezi5MzfG3IBzM6b7ZTKhbhD
 hHR/NyJJddd0J2F/COXcVUDIttTkWSXVGhguJiS4fNDXsKSmoBiQ9ySx18ZYirw11+BJAw1NeR+
 Zk9VAGeTKu+cUl0tbxQetoxhCKoo/G/whnOqMsnQ2aTezCe/vg0VAsCa6nal2Dhrccciyg0IWxK
 paonTT7yxSPwFLOJoAuGhgT56NS83hsxa1Ij9BL1oVY0e1JugRHNsIsY/y7Gq6TsTU1HqWA0Fkm
 gJQmMvcJ
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F38824000B
X-Stat-Signature: m93w357fiiu511c86ajwotkhsgmyftym
X-Rspam-User: 
X-HE-Tag: 1756140560-543453
X-HE-Meta: U2FsdGVkX1+r04X9qU8hW+1gEMlYj4+NCQi/3Z0E5ErZmD2fNdXluQ17NxjAkXi1Mj//DSbnQ1SEKRZXOI0MLaXDFehOGYbWGs4NhqzF/7K2huiCdOAzcB2e84NnRlediw2ryHWFGs/YqcOK8M5NCUg5zZeLAUgFSD/ZDXgNQYY/JATSIVUMii9vOL180lX8WPmaoFgsuZFilIGXzSantywWR8xU214Cqj79PiQPUehMFQp8gWDE98WNedcrGUrHVqmzF7JI3DNBQvupZTU1kIyYRf2JQksQjOUUc22b2tGYwvAdeUNeRBqyppPm9Nkt60Q/i9wo//uiABh8e8i05sEw49S8WnUTpIt3UcUq8CpGq9vFvyltbYBi94Cjk8rIiZsIjVmaMSrGkphgG7Lf+XWs11LNWShYP5ezNAlC2+boPOBP7HhSw8kgfp8orHVPgpUzLvqL2AyRjsRl8BgLX/NuSbKYVLkkw/3vuafnE2rjUbTp57sQbhmDEHE2Yuab3dnrHNFh4426KLr+h499/zfD1tgy/cAMgCx40Z+ea93nWXDeFuH2ttMDo50E82LpZkbfCAD+/9W6xOR8zU26B3uAH5XjTMjTWgz1H3CGRMh+tCoqlV+I82+rxX4FqB2yByeSZ5oEtG5kDouApcL1NS8SCJxgI2yvnRJySZzcA7yEsdpW312ByWa5Mjdki9SnUMg3UlM9VBJOZFT/9p5IjJhofj+E7e8U9WNkfPrhgPwpCsLyPhB8VrJdHLAdwtav/7otuvo9Xd6C7Wtw3qJ1VpSiStTcFWsfc9fEg0szTD9YUYLF6pb68yVDnJWlW6r8kBdYbn2oflt6DZ3DMMrQCRKGfeP9E6Ra9gOeSwFQ4xu3KZhH7ys0CnS5srNdn61oMkiFXFzl0uygiD5mk0m3GxysLZTSC5oZgaoin6uUe+QhUOrviIriDxiDLVTBJU1Tm8rQqIO9HQFrz5BP7kA
 VHlgnL2F
 WpEnAkCiQC5Q3FF1TlBD3IrAlW8gmrQoRtT8HGzukAxGlal8ElZJIyvFGaPxole/7yG4aKwvjIj1gFCfO4Jf1aobJOZ8P36nRU/XVufN1zEkz2XD75BsD27bbgUAUzyLipN1mKXyNXmR+7sCGV3WsAxQliA703lrkn4unEGeHiP+pjkmtPTJYgNAwZe93mKmhLEVZUkJgf7g6b1z1Z0YS9AfHloTtIoaIlwb9y34EqA4hjttSyAR+EY+YxWiuv0et1zJ7am5BRVpHrMqXARcrF9szdLrQW4W+uP2Yct15qcvswSCl4AQDgR+/LMkK0lBYMXr775/zLK0owkYCJk7lBPfUVV9vf8qTCyYtCMzYj8nF6978KMNCgAw6gxYXtpbiOZIWnq7vzt/r9yCY2+3e3GlarM96mVGomxz8/QdeV7zKG8VX3gCw13LREiSAnhnTUOYkWnRMDkB7tNsxfeoJNquV+2sY7js3AnAtdS7W2pgQEv6veWwTQ3lv77agqq8xp0T/NArqfFtiNMUY2/Mo/SRxip/55TKe3E9xOm1q6dM6N+I/MXZeTt4XXot8Px3ECb2X228xAseXTPWVLrFxWGQhuMD8s97k+JuqAG/T8nXWNFsMNE5OnOHV/MHvujthxyGwTrYPToAlHPyvuymesv5Ht33ZOZo/BRIakHc9GxV5Yygv2Vu2frPQiRwcOHW3IzmLJFveF/4GQL+IeQZ7PsTKY3hD0Dg3+eT1atZnlQm9WBkTjEp/Nsg4wVW1dCgT2MSGwXZC+gGJyTivpZjgB5sj8lBzWX8FmkPHAJAiTVzyuzMIj8o/s5J7cyTVJNJCF8CsCskPqWDd+4jH/R7mWCDOAvTZbDtCD5KenexRtqw7cGJfD5g6kuPAnjdPY9U/ZNpuX83xIlfYZH36ihGVWkSNXLcdYdLqf2UEuxLZOfPCbfjAz5O1jW/HIOkU0gz1kzX6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 05:44:40PM +0200, Marco Elver wrote:
> [ Beware, this an early RFC for an in-development Clang feature, and
>   requires the following Clang/LLVM development tree:
>    https://github.com/melver/llvm-project/tree/alloc-token
>   The corresponding LLVM RFC and discussion can be found here:
>    https://discourse.llvm.org/t/rfc-a-framework-for-allocator-partitioning-hints/87434  ]

Whoa, a cutting-edge feature!

> Rework the general infrastructure around RANDOM_KMALLOC_CACHES into more
> flexible PARTITION_KMALLOC_CACHES, with the former being a partitioning
> mode of the latter.
> 
> Introduce a new mode, TYPED_KMALLOC_CACHES, which leverages Clang's
> "allocation tokens" via __builtin_alloc_token_infer [1].
> 
> This mechanism allows the compiler to pass a token ID derived from the
> allocation's type to the allocator. The compiler performs best-effort
> type inference, and recognizes idioms such as kmalloc(sizeof(T), ...).
> Unlike RANDOM_KMALLOC_CACHES, this mode deterministically assigns a slab
> cache to an allocation of type T, regardless of allocation site.

I don't think either TYPED_KMALLOC_CACHES or RANDOM_KMALLOC_CACHES is
strictly superior to the other (or am I wrong?). Would it be reasonable
to do some run-time randomization for TYPED_KMALLOC_CACHES too?
(i.e., randomize index within top/bottom half based on allocation site and
random seed)

> Clang's default token ID calculation is described as [1]:
> 
>    TypeHashPointerSplit: This mode assigns a token ID based on the hash
>    of the allocated type's name, where the top half ID-space is reserved
>    for types that contain pointers and the bottom half for types that do
>    not contain pointers.
> 
> Separating pointer-containing objects from pointerless objects and data
> allocations can help mitigate certain classes of memory corruption
> exploits [2]: attackers who gains a buffer overflow on a primitive
> buffer cannot use it to directly corrupt pointers or other critical
> metadata in an object residing in a different, isolated heap region.
>
> It is important to note that heap isolation strategies offer a
> best-effort approach, and do not provide a 100% security guarantee,
> albeit achievable at relatively low performance cost. Note that this
> also does not prevent cross-cache attacks, and SLAB_VIRTUAL [3] should
> be used as a complementary mitigation.

Not relevant to this patch, but just wondering if there are
any plans for SLAB_VIRTUAL?

> With all that, my kernel (x86 defconfig) shows me a histogram of slab
> cache object distribution per /proc/slabinfo (after boot):
> 
>   <slab cache>      <objs> <hist>
>   kmalloc-part-15     619  ++++++
>   kmalloc-part-14    1412  ++++++++++++++
>   kmalloc-part-13    1063  ++++++++++
>   kmalloc-part-12    1745  +++++++++++++++++
>   kmalloc-part-11     891  ++++++++
>   kmalloc-part-10     610  ++++++
>   kmalloc-part-09     792  +++++++
>   kmalloc-part-08    3054  ++++++++++++++++++++++++++++++
>   kmalloc-part-07     245  ++
>   kmalloc-part-06     182  +
>   kmalloc-part-05     122  +
>   kmalloc-part-04     295  ++
>   kmalloc-part-03     241  ++
>   kmalloc-part-02     107  +
>   kmalloc-part-01     124  +
>   kmalloc            6231  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> 
> The above /proc/slabinfo snapshot shows me there are 7547 allocated
> objects (slabs 00 - 07) that the compiler claims contain no pointers or
> it was unable to infer the type of, and 10186 objects that contain
> pointers (slabs 08 - 15). On a whole, this looks relatively sane.
> 
> Additionally, when I compile my kernel with -Rpass=alloc-token, which
> provides diagnostics where (after dead-code elimination) type inference
> failed, I see 966 allocation sites where the compiler failed to identify
> a type. Some initial review confirms these are mostly variable sized
> buffers, but also include structs with trailing flexible length arrays
> (the latter could be recognized by the compiler by teaching it to look
> more deeply into complex expressions such as those generated by
> struct_size).

When the compiler fails to identify a type, does it go to top half or
bottom half, or perhaps it doesn't matter?

> Link: https://github.com/melver/llvm-project/blob/alloc-token/clang/docs/AllocToken.rst [1]
> Link: https://blog.dfsec.com/ios/2025/05/30/blasting-past-ios-18 [2]
> Link: https://lwn.net/Articles/944647/ [3]
> Signed-off-by: Marco Elver <elver@google.com>
> ---

I didn't go too deep into the implementation details, but I'm happy with
it since the change looks quite simple ;)

