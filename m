Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DACC9C982DB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447456B0005; Fri, 16 Jan 2026 11:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407D06B008A; Fri, 16 Jan 2026 11:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5526B008C; Fri, 16 Jan 2026 11:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 162A56B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:56:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A841088CF7
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:56:33 +0000 (UTC)
X-FDA: 84338430666.28.A6E50F9
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 07E6D1C0006
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:56:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ikUYtPqo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yn4M9PhQ;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768582590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXCkT5sm1xQ0PIy1po2npjs0EpNf1QoPKjSmTdQc03c=;
	b=XSTdPNu2Jk8wEwPTBYrZ8IZ0bcEXPjyswJpErxIcMYPIbrW5VV37A7EM0oCDNmlZWRzpUU
	7tdkTXD+0ssHPy0la/pB/NwcrhGt0939YfjJ0hTTu1G5GYwsWR6wChfzlwcI3cA5ZBn67g
	pxa8L8OeGybZdEBJTh0H3CyCr+g85Gk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ikUYtPqo;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=yn4M9PhQ;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768582590; a=rsa-sha256;
	cv=pass;
	b=O1CHMQ2Z7YFw2zM8kAORagy7hcouLZs72Awf/fZuRugZ3g7I1okOJnV4hlyiqembPtWZ1x
	IKWy6LIb23dw1Ksj5Dgwnqx95nubr7AFxCirLC03W4+TcOsuc0U/5VQ6xRl0AHnSjZJsqd
	2fMWc1/9S9W4UojC4XB0AgqmluBisX0=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GDV3OF1433051;
	Fri, 16 Jan 2026 16:56:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LXCkT5sm1xQ0PIy1po
	2npjs0EpNf1QoPKjSmTdQc03c=; b=ikUYtPqogcPvzzwohBekBuTF8y72zMIQVy
	rDkLc7ikGHDTF6PgkGoFV33xZ6i3hLatD0B9B8keqZsUnJWftlqmFFKnHKEVib6U
	VHrJM+PIEvaavxs4h0COvu1Abz+ROAO+fr/WroG47PvQVEbFbIDmSP63lj6JDN1u
	ygJDfQsONuMpvvLXRMPnLG3wYa7nEN39gd90aheDDhQFCkQ58YOKPxmEaIyhxFWE
	FL15pnjKuqUuqMc8LtyeRtYxrd6w5Kr5mJPAGOjDvSdoFSFKLgVrZ+iaZKsnl+di
	rz16/uNj9INrDYAjmvEaKnBSx24fN6QBLd9O1ePbbjwPLbzR6l1w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkqq5a8qj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 16:56:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GF0cHt029228;
	Fri, 16 Jan 2026 16:56:16 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010028.outbound.protection.outlook.com [52.101.201.28])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7pwbxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 16:56:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bRH1PiCIRbUQRgnbp3FMpS7dx6noz2iWYq50ppr02fR+vch0oIDB/0Fal+SDTO1cyEdKM0mgsQFC3rVI0Ym6ZstpjOBn9bZzlJfHIjhnHUdA6PE5ZB4azBoJNSqmVB3NW9+FWyp8ltXuepnLn8p7FNHgzMebBsUTsHZSYcQIop+QFIghXj7o89kfbXTKIfMJB3HNbI96SKzHeniz2pCXd++r5cmRwVyJc8ckxQq0BCNbuD1QMmwXz8XSayxufOdzu41R6WFuoHgcuQRLiLoedKEHyM5I9zHX/PrjsGRYE1SvXJZsP0Z2pqZp5/dXsVxBaL9ugob/xoaSZ5gcQppVKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LXCkT5sm1xQ0PIy1po2npjs0EpNf1QoPKjSmTdQc03c=;
 b=LNvOgq69SQ7wImSfYsyDMAwBtt+vINgMiijiX7y8h3DziSfnlOZBYVc+NlchQH1efCWv16noT9ZZhxyqbD322i1uoGbBbl0siLNzwkfLo+xin9AWQMxz5QBy/JlsSx8WqNEuSzyr8rDrQhrcnghNLX3O7aMcYyec8q9l3lXGT3PLv8oB0spxlZjVmTjd/qQ4hR03uaSeZ0C73LI7JDTRmZT10Y7dYU78ccIHVNRk7K+jixoPmYFNyNGbLKq9Ob6arRqgxdkTyhwQMfxn2MOA0QyAxwJ7GP9xWnfbc0cZbx56wVVbewsJ63x/HdV0XDpwU6zwcGFRureypdRJoJUDDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LXCkT5sm1xQ0PIy1po2npjs0EpNf1QoPKjSmTdQc03c=;
 b=yn4M9PhQIYfSWVIgG2pUhsjGllKG5INYeW6kseBlMEMsTzZ2Phg1lDLng2IfyDkZ1ZOZcc+OIJgfpL+nNmQDXb1EGhgJOLUXy6zLvrQ6pMOUUcls9BktH7xLRGvbCQ6vjaWhEd3ua7xE10JsKlnjAORng6B1c67hY7GO4ukJs/U=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA3PR10MB7023.namprd10.prod.outlook.com (2603:10b6:806:313::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 16:56:06 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 16:56:06 +0000
Date: Fri, 16 Jan 2026 16:56:09 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Ingo Molnar <mingo@redhat.com>,
        Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
        Waiman Long <longman@redhat.com>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update
 non-lockdep asserts
Message-ID: <75459722-0bb9-49a3-82e5-e034307b09e0@lucifer.local>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
 <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
 <20260116151215.GH831050@noisy.programming.kicks-ass.net>
 <99818e30-9f88-4751-af82-0bed019156eb@lucifer.local>
 <20260116155743.AuMKcTAO@linutronix.de>
 <5ca7b2a2-1e9d-4d90-8459-1aa35b30b49c@lucifer.local>
 <20260116164139.8Sm2sJxG@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116164139.8Sm2sJxG@linutronix.de>
X-ClientProxiedBy: LO4P123CA0560.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::18) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA3PR10MB7023:EE_
X-MS-Office365-Filtering-Correlation-Id: 05e19be4-65a7-4da2-57f9-08de5520240b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T7Vk50uXXgawB3AnWzkCIhJHAdayYWfPW0j6svyr52I+2gY50isQHl008jaf?=
 =?us-ascii?Q?e1hvlNehPwGa8827yt3tyq617phdIJPb8BlVYfMG+ERFFua67G58rFTJl/ZG?=
 =?us-ascii?Q?3OhyQuLeod+B6kfSpjL/W1b/x70V+a7MOVxhn4/0y5LfXNWZtAPqVV58Uy4p?=
 =?us-ascii?Q?0YgYttQdWZSJzp6f0MJf1CF/pA3JKCZlHTQ6xk1XaE7JK07HCjUdnzLDH60m?=
 =?us-ascii?Q?3Q6USzGubG6v7qvMnkRVBqe/FwZcKRAn03E/V1wQ/IvlZYDwQ69p0TUGrnpJ?=
 =?us-ascii?Q?UzybY8BS5T5Rnj9YD8kHmL9/Qf1aGKFPYnGDxkoDnyQ3I3ve8QZYTW7xbwxE?=
 =?us-ascii?Q?oXoi3MeKf1LxHJ8/SgbWn4/BS5CNAj/YbxXkbGk6GCm8gLtqVwgtRnkaEMBn?=
 =?us-ascii?Q?lwQwq57gsUPJM/6Jb+F4aXmOLD3HCZDPi1QV3V9WYLheXUWi+OYCcsh6RYzA?=
 =?us-ascii?Q?v/KzXAC48GL2hoAtiPf4wTacrXvoQL07+tPeXZpFZVRzBa2rx+tGGi7Qdirn?=
 =?us-ascii?Q?/bR0vXZNno3yiwS+SgqtNjcnBnknPXsyi29xg68e8/n/YPLd32AM4pnVzKXE?=
 =?us-ascii?Q?7KW1kvTxMJ4z1mPVUJLXmKRS8eddpA+hjecYzu8jQzrTluxG4V6kdzuzeK++?=
 =?us-ascii?Q?8ysSaXL7Qf07eg4I7FCr5wFraQ8ICDF/3183sl5ePAdsiP+WHNm0QRYXEwjK?=
 =?us-ascii?Q?ojfebX3wWKv5blbH5sS+JszzyYi+PNB591J1z00X1Sf/Gdle4GtZV4KMzlM7?=
 =?us-ascii?Q?VhIodaev6zUpcGuTxOjOo0iW4mWDrhsSE5fG038vkZfpMCP18VA6u+C4B0T6?=
 =?us-ascii?Q?c+ot9tngFKzpnI2arzQ3ba6xtzkz/FkcCz51UBeTjnFqMW/3jQsRJxp4C9U7?=
 =?us-ascii?Q?MXelFcrNgruvViX0FGMpk9/KZNe5XZHts+6RJjQYF89ZbiIVVqL0zODkn277?=
 =?us-ascii?Q?9/KrNb/649I4JPOXaVLFfTkVeqqDiVDG+R4+uo7yGHFVIR3en97/A3cF7BRj?=
 =?us-ascii?Q?6wQYk3Uc8EIgNWrMq2BvQKFhuRZPrd5SJmf1IHjpCdZs5o9JeqUyKIxZvUvt?=
 =?us-ascii?Q?RcADulgWNJCgMiAXKQ2ShgTafBy3mA0kUgPG4FMQyfwieG+01LzxE4b69DEZ?=
 =?us-ascii?Q?tHxMiDJRO9YRbNhvDrZTAwVLMZ4RB/FFfAH91aXtfbuzg6RBszSkhgA2nDe1?=
 =?us-ascii?Q?VMeQjfC3Lw6wWV4Ulgeb0HQQs22BJX4F8W2neAlgdQpRagajqGCvmpzk1huO?=
 =?us-ascii?Q?PS0iD1BQe+RPKuXbrxqucinMEha9vOTAZxqPDahpDUAKvHKkMpo0/U4P3UKl?=
 =?us-ascii?Q?DDXOIv78BKBlOseoMP5YgMv95G3bAUK+aZ+AHr3hyp+AFvgh52JjVH96I7WK?=
 =?us-ascii?Q?1xzl2skij6ImmtUT6tnju1PpgT/MRsmsc1DCmdTYlCw0Prc86uz/varANzX1?=
 =?us-ascii?Q?c0WwmiGIyURALQoo7m63cgoZy6eTqkbcorQ0o7eqV87oLRl4EDwutRUJKRRS?=
 =?us-ascii?Q?d6zsGks0fwERuonFEQi7cTBZj7EwYFGx3ypkr2sy7RoJoGftaxaYvtkv3if4?=
 =?us-ascii?Q?ivn18mfNeN6x0LxE+Ww=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fy420mn78QjWo6Yuzx9LPWMc1/QBha0WCdtvFQf3Afk8bwOm5lgXvRY71kOA?=
 =?us-ascii?Q?pkbodA8iQ6QFQwIX3iTGZIMnDVFbxqDg6H/5Qb3g1/9/9lIIuLvsa2Wozjod?=
 =?us-ascii?Q?gSXJDmf7qXvPk/ugv57N8QWOFK6RD96FUrLKU8IXHtW6oHpTrkBsO3jtKgch?=
 =?us-ascii?Q?jkKblpoLzhf3FwywNsuAKGIPvM6hR3UvLbpRkZWHsJtSyAzxRPpa0zEFOHuH?=
 =?us-ascii?Q?/NS9IYwaAqZEQfQ14TDM1UWxtZw1R2FsRQGLEu/6XBs7xpuDM/7DdaPAHbgS?=
 =?us-ascii?Q?jdbQHtDkOcTLx8LFVd5UhcR8+1cHQPDtSrUhcIg7kaf9bBNB5eH+GX4Ofvkq?=
 =?us-ascii?Q?BaU/C202jqM0YIRGd/wJ04tDv/ks7GtTTfxxBmj5m9SQT66fXdh5YcAg3rqd?=
 =?us-ascii?Q?BhIUW0Vd4CTOhJKt26Fg9sQ1aJzQnZP7bcmmGjF2KcFuqkKccGbohSuI557S?=
 =?us-ascii?Q?vBO7Oy3v5yLM1vy+FcmmkJtJKN38HUtjVMn81+awIMh/uYELfFpPgc6Ol+mJ?=
 =?us-ascii?Q?o/K1ZeSkOYLwDjOPd2D3tC7lPJJpeWkax5r1LFH+kRT/AEhgE+ut2nuGJT2H?=
 =?us-ascii?Q?+LN6g0A2bphxZ7Zk5SfUmu89HawK2ITrbvBZzprs6xW/engmbSo4CXS+QlHs?=
 =?us-ascii?Q?sdQdqq4hqvJehSQGBQ7HWwYruXpO9Nn0+jZfwhtk/yGBKTnLHDMdszxAyBLL?=
 =?us-ascii?Q?IfMZw7DNVwvi0vwr3LTT6mU/Wil66ElU40tMkuanUWdp9rgtgxPn2NCuvZ4G?=
 =?us-ascii?Q?GfiBXgjpN6zWurAGzWWXVg0KYA4SVWo0uMqj0TueTGN9nPiU8dpuK+fkeI8d?=
 =?us-ascii?Q?/QtC45TfQyrL+z4ILd7vgCxuv4d5cFDrJrGNXA8nIYIKoahK3SW2j4NtJoX9?=
 =?us-ascii?Q?eZ+KOli9G1MMY4ufhS89isvTeJ6TJ5EXiA0VgbL17fT2+MdpeQ2vpdHw20kW?=
 =?us-ascii?Q?zu95M4d7diA0R+HRdR165xCGXszqzzhb1egRMJyh6EPLmvzj2vEqduWrOYW8?=
 =?us-ascii?Q?kqSxvpeVcXhbsIqoljWlnRSGbOE9hK1fZbbJNeReJ+gkQ9ScYAPgyU6Ij3+4?=
 =?us-ascii?Q?ICKutu8M2YAqrL6y0YaddON+iaGhWk1KMRT4D4MKLufgm9ZJPZgXQywPFiQz?=
 =?us-ascii?Q?b4OVtNCau/6UUQUf77jyy3M9XhLHKg9tAVyOYIPRJci+TJpWsrff/t4Hgk6K?=
 =?us-ascii?Q?xXsu3aYn43O9oihsb5G2QV9tRpLGS6giDSdo5mhuPmahA26Tv1X2rZu98k7s?=
 =?us-ascii?Q?2aSAa+JO8c6XpbJ+y8NrsUF+gQzgqWz6N8XtrLuaXYC9s42zyiMc8MaSz8Sb?=
 =?us-ascii?Q?jDpvkHqz2TERClBblnSzoyIGqOfOpLsz0J9AN4laFaSoXO9UudI9LW5S2qzR?=
 =?us-ascii?Q?oMdcbDqPxBg+WiWDqIXbIJd57G7giQcswdUqIhaDztynxz8npwAQ/gq/yqBy?=
 =?us-ascii?Q?GJSbGL3oWFUaQlWqYtqfVRkn2QIn/4heHyfXhF8je+O09LOl/XimwuyHpZwm?=
 =?us-ascii?Q?+TBAfkT9dxw2TM7YlR9N2WrTa66Mxvp6hFboxpUdgHlTWpI+x6aiZhVA+SKi?=
 =?us-ascii?Q?YjyFBrSmtvmfojgx7GSbYakpvGRDNBBEMZb2KXWTtUPQi0s2la2Jc3uRWh2d?=
 =?us-ascii?Q?qLl7G0iJhdINzI31qWE9ZdfF6DsL2YWdIc/1/63HiDXMaY0m3gyecEF/Kpgz?=
 =?us-ascii?Q?q7M6B4DQzka46iiNeqPBLkIpV4Uu5aV/yd4oOVIqUh0aAjmGwRF4b0B6u8Tv?=
 =?us-ascii?Q?xMJGaDDLsFFvtZKKjOHZGGVyyb84WS4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Pm4hbrjk1s9Pe3GGEMJJs/YG6w5a50yZWAEuiL0b8k5XMOKWWYBATbbWHI50QWD+r5ipWWF/rfNYz/wWcl2h6jAN3AqejPCYZdCwwMWTwnF8lw7nbfjmzUkTXqK98qxA+mLkP7jMmPlOdtw5KHd+bn3wyP3eerMoSad8Y6GR4tZkQJDDA5hKYAf/H4jvMDgXyj6YxkQAIB8yqbzokm0MAoGm5FLLhLpH2+9kf+Ha/aRvDf90IUNgVl0jVK5hJqDmIZdg1nAshcz7zXI+B4nAO80HVri8QxKsx6YppSo9C58CD4q0y0yisP/2C7b6PD02c4r5D37/H2eIANlnWy4u4yct3PcZWncB7xQ7VvvM9LeBYaRbYrv9tcVCeAgnlCwDOTPgI8kOvYQOm8stxqQZyc7UotuknyUp6ogJNUL1QDpsqXvn3vFjM1OrOLxHwbrCrusGeLeRfmFlbiC9ScUET0/aSG94XMI3FS5q2qRVYY+X848l4QL7yCbDvgQbeeZGgLI/UBBzGxTcpex3rh+fR+718wU/YMvcRdg+55HpLskMl3sqbRBPxhof6uavBPz++yUw0E/db+dOcdr5HGq2ZvnpnJqUP/e44kWQXatyPS4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05e19be4-65a7-4da2-57f9-08de5520240b
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 16:56:06.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CAKPJbwo7tXlnCPmRPuuBEjNDvupQZDnOj+3W/aRqgIYMzIM5SoAk3iH9w946CHfctagxO6f6bRwxmz1qSvABViGc8Bef4Zj4VbC2+3v9s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7023
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_06,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160123
X-Proofpoint-ORIG-GUID: 6fbrK8fvNEq7S8Y0AVk1rr2cETWwCZ9B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDEyMyBTYWx0ZWRfX4zUWbP1nuA2L
 JNB9U5empewHX++7ZRrrFVMNotM+zQwDzpfqaWLVywstDP2Io9YCS6rPqBr0dlcer2FNKodS7GU
 QMhBI69Kmjckz+SNDKq034w9pSKkaqE0WMb7KFjmrQwiQJyy9Ff4N2ObYaWpyE6cVCkUKPuT4wj
 Tv2PUzPw9m7HSQHiK3sbmxqMvxxVTYM0f/cLepKBrpkTEzk0CcBcEpQESivS14SSZHsqgPEQQl8
 tY/oayS1kROkZHFHn6aA3V0bAyZ5TUcYH6QcfY8qLdCT3fvSMSmP4Jl0iuhrB8HukQvFVh1hut+
 v2xI3/pB+keghLC4NglL9qTAhiZiSBazZUhkjP7iatagaUEyG91JofkffHUrAx6A6ayieR5AYu5
 19EkJhUQUBgmlXISvaNEUi3iUnUT/h4Q+sCxd6wMsz6Tbwbxr/Pnr+yC/eqR74Ip7pmmhgEhwWk
 WKUgN9J7tFsj8h1VmzGY0x9OgzogXIPX2rlq4y1A=
X-Authority-Analysis: v=2.4 cv=J9KnLQnS c=1 sm=1 tr=0 ts=696a6db1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=KOMtQaz_S5jxQzxE6_AA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12109
X-Proofpoint-GUID: 6fbrK8fvNEq7S8Y0AVk1rr2cETWwCZ9B
X-Rspamd-Queue-Id: 07E6D1C0006
X-Stat-Signature: cgdtt89n5gb5m6mww6yqf1me8nd58yu8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768582589-443429
X-HE-Meta: U2FsdGVkX1+0GGgTySyGSSXHhUyTKwQPczmXuBQNwTbrdokmeJrEyEKheqGLmTTvqPG6FcmONL5qegFEdkjHCltYS8NDRcgwJH29Wr/pEygxshF9uROMCHy2rftanZ6Zb6e9rqz0SPdZmMYxG+TIhmnxSbqeAD+z3SJ6z2hgmZNAkKypUU5tJZH8zCdprrp9SzEQm9t4/jtJtANqpzoqpYguZ501W+as/ZnDnlBfWvjEAm4IKgXJ/zlcQQi92gGrHJ9VpuBmAdDxpYEjhaaBs1GvI1ZSeji8px1hZ4AP9NHwtTiOmjrgxwGJNcVwRDIPKhkyDDyG9bvgFP26f7ks3AeD9AFjUluwBZ+I0SfOVZDEt+sKatplidK9sgfigwDAAE5zbONmo40ybkZuyDZJKpmwse2djrJqiMy4qxDJcKQHHp8VnNJjFfK2HmYYrA59+qvYVYByFXQgyMYF0OLWOAQFyd1zL+MtPXLShukSvclj2hTp3mRhJ3S5tRmy+ilgjrnziuJmQKrk470oAf8ONrnCBuz6fokybwYa3tGgRh+BBix/wTCDxTEY4GeGeFgc77KhMCjveQU+e5MY4dPKVLkBGDqau0DpJ7JnoGMrPXqsBHEIgt35alRUQrlMT3ySnPpsz/6zaiyF0c1QXgqMbLz3Dg+s7U7JGwyf7QX9s2bnYGQeyb1MKSLCEM5rTRmD5+Lo9siAgjyb2mEKG/DKczhkwLtmI95cTuoDQgR1dPqnmEo6/+R6N1p8f5HAoz5LE0VYHjc1iDJuXBWiCDiTcNFr+SF5h4Ye7IUZsRmkC3wHt98DaU4JUHngk9mhDMYMkh1R5icVTyCLB2ujFmAvawJVOZIl2HxaGqH3WkPsddsWVe+R3YUpFKyzmpn2BHeITgUBRojohDZwGzbrq3xMgM3gtMEA3/CP82/UrhkE1atCuJVO2RATGy90KAOgm7ph23Hx2cLmc1++5ZVzjcZ
 PUsMyqcp
 Z9Qb6ArzO3FP2sTcGIkyGv+EJjGmzJt1pxzXk45W2KzQhdFr3/oafyD+nlk9ALKBPPYOz0BjV9Uk4SQxQdvwZSP3g9kTpY7/cGPWps0eSEiZMBom3HThErDg55qCx5tx8cfKv89Nsq6XxUx0YVUEMca1IR3XNX83a2MVJMUUnEDeBW732QpHCMcr8/sn6PQ5BTa6xIL+YDaU7Ktjv4HngoKNy1pQJ04mxo2x0McF5q/uZU7k6oWzcmzRzOiSEzU+lF9eYSEAs7kZWF/+ZpLRb92P64AfTyq7xdXda44boRQYviiM/NwaE4oI1gIKYQcW/RYPGfmQd8wcufxrgI8Ke3W87SuDqleSSdT3JK2p7l61VsThDLcHnmg6qoE3pTr7YqvnSsy1Jk/s8TYOo/4JTGIqlNLEtUxr97faESt2vxqZyLSxHlVEbPE4h8c53r+JN2zr7hbtVWwadvy6QoALdmg9LgM/PflzgC0koKTd2LK6gKa9LvW6ykT15yy7senLPaKTUvdAUv9CR/lNcCcuaHMD1sF4lP8Vic0gJArwigTDWcczD/BjGabjQHnE87uij6a8yPB6itn7lp7VXmydIeK5HbJX6FGBmB99Xe0BJAH8WgiW3HI5stKNoKqschK4sqFwjLY2EP5k58XsSZAJe7GTNA00REpCjjJzN4vBD0+rikIl6KTjGCbgXODVwDX7KhO5XGy2If8Lxb6oBHQwQfd04Sy+wwaFW5XZAnny98txDL8o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 05:41:39PM +0100, Sebastian Andrzej Siewior wrote:
> On 2026-01-16 16:21:29 [+0000], Lorenzo Stoakes wrote:
> > On Fri, Jan 16, 2026 at 04:57:43PM +0100, Sebastian Andrzej Siewior wrote:
> > > On 2026-01-16 15:50:24 [+0000], Lorenzo Stoakes wrote:
> > > > No, but we need to be able to assert that one of two locks are held and we
> > > > don't want the failure of one being held to cause an assert when the other
> > > > isn't.
> > >
> > > But why don't you use the lockdep based check? That assert only ensures
> >
> > Not sure what you mean, the checks I'm adding don't exist yet.
>
> The checks you add are not lockdep.

I understand that thanks (?)

I'm not sure responding point by point is productive here, so let me
summarise:

We often run code locally without lockdep, testing isn't always ideal
across mm and these asserts are gated by CONFIG_DEBUG_VM anyway so yes I
want a non-lockdep version also.

Note that existing mm lock asserts already work this way, so that's
consistent (though mmap asserts are also at runtime...)

I can't just use existing asserts because I need to test that EITHER one
lock OR the other is held. If there's a way to do that with lockdep in a
way other than what I have suggested, I am more than happy to hear it?

If not I'll respin this with both a lockdep + not-lockdep version.

What you're suggesting, just using the existing lockdep asserts, won't work
unless I'm missing something, because of this _either_ lock requirement.

But if there is an existing solution that you can point me at I'd be more
than happy to use it.

Thanks, Lorenzo

