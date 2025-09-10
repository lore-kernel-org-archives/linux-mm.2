Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DD3CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 10:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA3418E0006; Wed, 10 Sep 2025 06:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52828E0003; Wed, 10 Sep 2025 06:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2F08E0006; Wed, 10 Sep 2025 06:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 795C88E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:10:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 11EDD1A0514
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:10:45 +0000 (UTC)
X-FDA: 83872921650.02.D5D5055
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8D0F710000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:10:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DsEb4Oea;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UzkTaHmd;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757499041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+wQAfiqTjet1aTwZkUpAGQXUa41LWqId1mY47HDbjU=;
	b=x/iOx6RYUekQY/EnXclf2Zp3siyyPaSovYRHhY5HXO5rHyuXaF+BMGcHDGWGRsDxG/eT4u
	jTtl0MxhjFvmV/yEn/RAq6XwgMIk4t6TNTRu1EM4auEJRbKpRE1jIO7Mt5eeTVA/jc7a69
	gU+vefWCHsgvyTTbN28I52JXJgoTISc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DsEb4Oea;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UzkTaHmd;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757499041; a=rsa-sha256;
	cv=pass;
	b=0vjRYLkFaoz2hh2Ul99jMixoU3p3LMjArrqOmV4bz2TPa1YMuCYRLp51jmQpiZujZa6U3T
	8trkcWmM3XfD7jSERUapgi1CUDjd/G/puxKNo6d48gIorXUfbBxCY3ReyOxa6vYE1BIKBm
	U/V8sohT1Emw9aISGYDUC1Nindk4rjc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58A9MlI8029081;
	Wed, 10 Sep 2025 10:10:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=B+wQAfiqTjet1aTwZk
	UpAGQXUa41LWqId1mY47HDbjU=; b=DsEb4Oeae9otD1HBtYStTcYf5s4HfIjiun
	UvFMCSNEv/RHQCWifsTiKDcZf/IGvS0GcbTHVW2OfqULV7rZS/2HIxaTGDiHrmwT
	3tnKEdkNKa8jEsGjCxu7M12azU/WDNTD/lLI9y0XD1yB0Lf8F63LIea/bIrpgz5x
	elZLaVxb0S4kvATHGL285VKdIycqHcjXa75NIzFsWfu0ZRhff8Vx2PkjLVgli1s7
	HKJo5mq6/s6mOow8bEv3w2XxKpBWL8fK1MOL62xJRw4uSeYUQj1LLi8RTyyii/sr
	YF9byefLJrurJ146P6tmbNXbkK72uuO+szo9vfWvOS9POen34n3A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922x93sbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 10:10:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58AA52dZ030655;
	Wed, 10 Sep 2025 10:10:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdash07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 10:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rzXlgwaeZzdzQoBkymcOEamz/3Hm1uOnVVTIDIR43gauK+oWDKRDk2qvXRp9Bo/eqFZ937MemYy/Ut3UzrJe9Xiy6DBD3p9EdAgUxCGaBSsAebBMid2V4flEdxs0uLs+PBoVt6y6XKMwJn8rpHZHWsjql+FOkLGMN4DQL9g3ukGgx9nZdLPipQKiZGRuMudiWbd3+lLTwob5TpJkGLdmL2CBcYaw4SSoXMuafOcfQpq/PtY9uFNf1VbZIfU5XnKyIuUJQEq79S+uIJIqwyi8Rjrr+zv7NpnTvJ9/SyWaar+rqF4t+IwuO8D6vPnxk2XZI5d96X5+BfCoLvompMZVbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B+wQAfiqTjet1aTwZkUpAGQXUa41LWqId1mY47HDbjU=;
 b=Y7KmXsGhC4t4tvYWaZklc4F3OgfFcax1X3EZR7iShoMw28JgfYRO/cMs0XbfBKFNXUwjyD/KnRVKoEg6o2ee/tn1h0iJ12alDvUVTkEWAdRTBcMuw5REjVBS5xzJA+aRsvVBC9KEtT+fCKpsjJgyWSf8AwJSIXqCLNOJridMsls9u5M8fNkpda0OyXzJ0N1PZ1ptnKXcIktRkJx3Cx7e4HYi6jOJYadLttRlPohwMXpOGsOuNqaYYu9QZRJ/M8BO8J6ZN+oGjzbh6w+DqZQiJrpMlXeIUzi7KTaRMzq9SuXfNN+2J2A5noNXq9yIhIeMLZ9WkLkVnj3ANEY1/qPUzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B+wQAfiqTjet1aTwZkUpAGQXUa41LWqId1mY47HDbjU=;
 b=UzkTaHmdzSmIA6SO9v9MpZ2VwgHJp5NpVuN378+VSaQmcTqKjAdk9ZdVCj7HD+vVCH5rkUqQbOWKrHOYSKkyu1l4+EW845ieyUhgRVsxjzyzTm1laf/NTjVlBjIUHiH0oSVgiLIE1y1+4l3mBkygYmXNk0W3RmzCs+ZhT86qgmg=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CH3PR10MB7986.namprd10.prod.outlook.com (2603:10b6:610:1cc::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 10:10:26 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 10:10:26 +0000
Date: Wed, 10 Sep 2025 19:10:15 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Lokesh Gidra <lokeshgidra@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com,
        ngeoffray@google.com, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>,
        Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [RFC PATCH 1/2] mm: always call rmap_walk() on locked folios
Message-ID: <aMFOh1NxaIP0GtGE@hyeyoo>
References: <20250908044950.311548-1-lokeshgidra@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908044950.311548-1-lokeshgidra@google.com>
X-ClientProxiedBy: SE2P216CA0002.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:117::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CH3PR10MB7986:EE_
X-MS-Office365-Filtering-Correlation-Id: dd38ce3e-2d9d-4342-8115-08ddf05242e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hxrVGm0/jIXGtRLaBycXKV8D+9Dh6Z1kfL7JV72H6TkUtSO2DpC5ZwUIOkon?=
 =?us-ascii?Q?r386yfNY03LkvNO/2gECpEX+Aw+i9HTL5HkMNeOpB3hO1FtixJ+9ogcmYQxo?=
 =?us-ascii?Q?BOf8lAVPFbaR6w4enOdRK42tF1ZWMyMxp6RqqrQARm2ZJlZ9vt6bhOUu3Ujs?=
 =?us-ascii?Q?HS+1Gt9JrHyvz8qce9LWYR5zjIizYRcxbCnUgiOFLbIzt8H22TLNiIbeGmaL?=
 =?us-ascii?Q?kst2FRAPGsXNk98mK7nTyMEE37HGEc2pQU5zJJ8Mtn0kN7XWK28Rcjnp+cbR?=
 =?us-ascii?Q?4R5fBXsMss1QrkpF4v/RAkMjNgkM/2WF4zVqGpmgEfBQw4g9qw2fOU+Qj+52?=
 =?us-ascii?Q?cQkv7+2aUgx+KuqTBmzZTuMM3KPJeETn+/MINFauUd8miiwW2iEG+BZeZ1mP?=
 =?us-ascii?Q?uzLkCLghOm5i+AoKilIG7l0XU+Z+Fz/ENtEmX1N+JJ8fclBv4yDZKUHrNlB6?=
 =?us-ascii?Q?1g9qZHMnWOVpixlllBSWzsuyQ9HrvOpNQu1FK9E08+/u29+QEKBimsScqzQ0?=
 =?us-ascii?Q?n687QtCNWn8zPD/kAr+gcZEQgqR6B4AF0xtIbtUUtFz5brg8s9hMpw4QxmE2?=
 =?us-ascii?Q?9kvu0Ebw3/NF7UGjTPVe0n18i7Gqz5D65yT20mRZsy0HYwlbGKzkUWf6Zth+?=
 =?us-ascii?Q?VxhEYvCREgSNAqrq6yDTCMMeaizuI683GZo+vXdfxxz5CGH2zcNQysqyST81?=
 =?us-ascii?Q?E+uO10enHPK24YnB8bxdSMoBjKkcuWBFTTzmU8kvIwC1OTl4DhsyZYE68boQ?=
 =?us-ascii?Q?WAt49US6IfdxS4Z86ASEjJ65BOpMrsnbJ6BzwtNRI57M8v8sLIN3yGVkc/ea?=
 =?us-ascii?Q?FQgYfohCRcySefK0KXdm6bpgedHFqNgxczYWb4U2V93Nd/2YMo8iMtYmN2GM?=
 =?us-ascii?Q?eiJ/i8utfiuAIj+GUteCsPNnOshdNH+elbFiGaJOgovZtIbNZCYKW4MWBUGZ?=
 =?us-ascii?Q?xVgoxxhvlOqptzXvNGErGzWB1zho0MicyOK4KJCYo1pgOcGA3KJLNGIB9++r?=
 =?us-ascii?Q?Q6YR1SZ2xGzvaEB2VP9rHx+ymsBituou1JJEA2/jfI5PlPUwxvL9KqPTrKY8?=
 =?us-ascii?Q?bmPVQxPk29uVfaLbP6WtkbqUfHOXysPiFd007M2xbEHRyhPktYdaL5kO0K5F?=
 =?us-ascii?Q?nibGuxtoC+Cs9BYhejpGwYCWUJ4b5CQAt4DhR0KIgw3lCxTvJMjFNEZ2ZsEl?=
 =?us-ascii?Q?XJImT+2oQu5rKlNvDJsg/2/Fty0t89owDttzKH82mYZvvTJgyrwRPokemLpo?=
 =?us-ascii?Q?+1AjIYQkgk6afGKY2mx+fEzjT3LQrCu0sDartwVLCjBVufhDAxeO211XUvil?=
 =?us-ascii?Q?uFzz+qiyyRxa4+XiYfbvl0ap8AR78wsarmQVvQ2sgIsUjeqG7QTW9wjzCrC/?=
 =?us-ascii?Q?TSoo3+PXIh1XUgxWF1SezqkfMKTyYvFtV+f6Iv3Y5nNTpZmpPgc1KILd8J8d?=
 =?us-ascii?Q?eGKtCA+cjIA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1O9ZwJ9+U81mON2MTv19sLlf7z0hIozvgdMi5Fy7o0QZyyHltfN2p0jPXgFx?=
 =?us-ascii?Q?sE4bZmMGcWor9Ub/A6uTde1aGnFch/+mw2g7DF8QqOAGX/ZUniHI0Kyj/oQq?=
 =?us-ascii?Q?BaxrjvuKIVPRrTXYAA1/0lUiXwUVLMISoOZOM4JMrDLMvZTKokyHN+R1dCmr?=
 =?us-ascii?Q?JWNLLmahuajkeQRuitZc1wG98k8LYV/MsvPZGlfOPQiempogTgDwnhiW/w5s?=
 =?us-ascii?Q?37DFYagmoLaQbJm/GUvng9YAr1s907yw06L8huwIUn/f4a6X/2jbpeSrAL04?=
 =?us-ascii?Q?SIo0pcX4u4oFctE28EW5hqTDvIeJrjnkINMa7q8Lc7F8Tg8neXMJfNX6PGQc?=
 =?us-ascii?Q?B2T5yxP1FH2kVE854ciDDbioc3CuYBwA8ZwTeS1Zh+mUrOeoVceYJSXXesg5?=
 =?us-ascii?Q?MraFut/fY5F165PRKA8fc3LuYFLJWqn4au38RDBTA2Z3k9CArm1OPFVzU0l0?=
 =?us-ascii?Q?te21z9uxMAlyByqj+AN6+scHveV8klOApF87zq+CgqJeXJTw2bWDDRldRPzm?=
 =?us-ascii?Q?4ZTOLoMQzhoI/bT8c/rYtr5wmQNFptz1DuVLumisGwta+9kYzGlWj3exCnmp?=
 =?us-ascii?Q?8CvDpmFKZf552BxEYzux1GwOzeZfz58rbL7fVmtRJJgTzYuY5vlCOvR3VhD1?=
 =?us-ascii?Q?m6fPaRiKzr0r10nvNQKXhDp+V4Ec5hpZ44Vu+rDfBZT0I7IusVeVk7zEfvhh?=
 =?us-ascii?Q?WzUGcOpL0dpl2uFvhNU0HmJ5YeKuMaol3HHGdSbLqMBZ/REuOh32cZvTzgvj?=
 =?us-ascii?Q?/IBWWjNPIUDSK1zShEgxnHAImHY0XRgPwB04yoaSSadczAnMTq6sOCCsOpXB?=
 =?us-ascii?Q?9JYURKEAtpBChFrCwq6UAo7dMMslGM+Pn5BmPLFDVRVPrifCcWeT4qq80Duz?=
 =?us-ascii?Q?5rFLj9rdmWPMDmrLxiBAP5e/dBqfoVJXaJXWmVjHrJE5ZYBotE7OnzKO3CVw?=
 =?us-ascii?Q?2k4qNXljzkKgRrLanOnBriNZGcUVgnkInegdEnUM7mY82WOTLZbEQ1aVaN2h?=
 =?us-ascii?Q?A6iytDkI62JnfSSf+8TP1Gt8RL0GeO0ypAVBelmSOv5aVL3aMPTY5qLjDyzl?=
 =?us-ascii?Q?2FEC0hUHtGpclxYV2hp6i6A4yIJL5J77GVQgMtaUlQ84B17M6nfv0Ni3qjCY?=
 =?us-ascii?Q?WD9MItfuyyjB+DApm9hFi2Af/hbji/cbCctZf3MExvjMvTJ8Tji1IH1qe0k2?=
 =?us-ascii?Q?hgyNmziKK6rskpL0j7fwwqOukGRhq2HvqkXwj5YaChYRBw4/kyATzMo1/1Rd?=
 =?us-ascii?Q?tPgSCPo3wN66X7j4zOruwnF1B+fuVMFr2wwr/+OnHbsmYW+lSXOk5HMzAgkV?=
 =?us-ascii?Q?c9xiRtW8VjXT3lO/cVkX9x8ehEfntMGU4y/IW0SNmFX/1+DEllrA/OiMlZcg?=
 =?us-ascii?Q?tA2nIGm8EJZTnA7/+2FIrf2y9PBOOVqUK1kF5I81z7Jb5y7ahyVO4bkp1Ldh?=
 =?us-ascii?Q?vdEQe/sNXc9nZyz/caCl1J1VOn09xK4XqmICbuPlErVcBWVUOcdr0gGHaoow?=
 =?us-ascii?Q?m7JpThAGgeXTABKUns7/7Ppm4hTLM6fcC1wGNaiEeMbmeO2xU6ExteuSob+H?=
 =?us-ascii?Q?DyVQ7V09lV4ajX/XTlvke4m0RZ1MXrqa4fqxzIWB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wCM2c+xQeopF8h2sQIHo5bpK/2l5HN6W62L4+2YynswM3Krh3WLuacNif0OkanoQjubiqr0Dnjk6Mu+Uepg4dyG96UGx90GpRfExkmk4Gk/nVbpUBsiW5j82PljQJF2q660XeUyqjee02w1U4K7XYkC//UYEUyJejMRsc2goJd8n7W49sqkaW0tITAPDWLn3kjE3tXXsXqsDO1EkeeBcwT32wRCn250ko8YZWHS9Ek/CoitWEGrJ0zJ8P/7ZM1QpvhVGfCCmdfk5A06ZH6fXEqi+F8LTbC4EudNjFHztBW9LOCg5o8BzFFXbvgMJq2UQQ46Hzk/ZuHJmVz81ONeXkAIvpaQdVOsH5B4uXICPSNbS5nfLH3T/N8zCgczwfIykgVD7IgBiKYz9skSkAGRfUF7MtGMQU7O2kRHkjtOjeBBubadyqPpLEargTlbesEQfTl2LpVXAcfZruTnYmpxqnvPAvEdQ2PAspnZ95B+gvEZ4qisuB+Nw1okbw3ezMRGNohWAn1Q1RfHNYIbs/XoWQAgzlC7ERuOAMuw+d5YJ6VRk9qTRl1UtTQS1i1xiT//OKj6AuleuxfpYgJFuAnX8/kyyJLWM6KXVHF4nN2WAXKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd38ce3e-2d9d-4342-8115-08ddf05242e9
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 10:10:26.3723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lCEY2yy6kEMt/IyH9eLTOIGkF5JQrxQk5Cp+KJsKx9m4NB2NErG+qvy6ui9pFBooNbwChZl7RTJxaROAS+7Y/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7986
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NiBTYWx0ZWRfX8mul4bm8qMXV
 +cTZ8TL+bcZpp0QniEmMSMB4HweQtrUsjjajyZjl1YkYUK4oqwkvQxVsi0P/L6dLzxzo8My9M8p
 Pn/VIeQMqCyVy9F4DqKuI42bZkuRAUukstXu6UnOR+sFQMnQxcMxqgfQyJ1Gw21MfcA910GvyvJ
 +w5VaSekQ9zOtXoKssg35fn5SmDLxrjFJXiAcVYg45/CgNghds4uKc1D5Qru8ogSrHV4doZuyLH
 RNd7Ycew7+vxuUdZkWISWaV5mfeiBVwdQGIiRMZkUWPKb3tOqU5Ll/gPl69sR1f7Dwai0sYPcfY
 Tws3tpctRYPaYeXHVtUF8bXZ9pDddWPuN2aWZHHM4MCuP0nsJrc5FobTjii/RZdrAXle6z6IRAI
 B2G/SFBe
X-Proofpoint-GUID: 6QXGef1hWj0FedEDBShmTgUxAC5eQvtb
X-Proofpoint-ORIG-GUID: 6QXGef1hWj0FedEDBShmTgUxAC5eQvtb
X-Authority-Analysis: v=2.4 cv=LYY86ifi c=1 sm=1 tr=0 ts=68c14e97 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=LjPVSexYwyB86n6HaLwA:9
 a=CjuIK1q_8ugA:10
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8D0F710000E
X-Stat-Signature: a7cgub7qywkw76et37eeuqe5ewf5omp6
X-HE-Tag: 1757499041-885096
X-HE-Meta: U2FsdGVkX1+V0s9dFJRNhB8hYnYZPGSNigZUOCh0olCo9X2BgFeLoC4Vlm00LDr6MSn3EC5ePVq55OmnEbo8WpU8Qj8DvqQ0yB2byLMRVJ1/LJ5yAieFVkqhBfi1gb6wAIEkpiaDhw3AEv6REL4TSWp4Vd59c6UmFamNmaDD4O0GEXU7jTvHPooM4irEDuO+5lM1Bc4Z/9XvNED/4rvpGEoPt+wfYXNWPeojODHBGKpOuWILRmq9hBtG8XJt5vKJcLbpGP1KdNFUtAyx+S7KLKtQvRnWNAY7/7+fiudQ0mWFaf2XsuTg7LYGiQKlBeSOEzjE9iyOXMiyhj46XuQsNN5gDw5q6sSQwUm83ojQpK9PMC/QLwKGWimgIyA4UnN9c7uY06ejGhhZTMjyk0YKrn4SUFz+Rn9YEiko4NDw6HrgRQ5iuOrQ8IIbGFePV3xkiGYCZJ42HrKw7g/MGNWF3LkZOKIj24n/Oeo5vWuM7C7htka9A8AbW11GXAmcvSb5WGe3sJYnNDCD1yF5fSJTvGdUpVJ3dmya+jMoGtjIvil8ePuBXwukYuu+lmup2Xg5Z4l9sybmSiAtITn/qA6nySlL3dmYix3h3FSuBzEAgGd+bOKLYn+94DgycxUizOWnUs3Gm54Tx/pBpNrNtw5wMLAP9lOODqMKYg8SsH9HbM9EcDLmIwZujHZJ3S+5d8nePH5dQelJQcbFaolF231bb7U3qFh36hqWMd6VRPPXlppHsFTpEZNfcsl1NKDPXZiRq2Xkz/pVMf4JIeFKkRwPg+azT5TQ0eVJHWjFxfV/KMC92yJnNaBHaoScQebh/aNaPLXFn1HfDKhnY0A92d13DjbbT/AlZte4ur4uz0V7ASpJ0TTCzj+O9yGzv8Nh4DJ63x7/SJcWrbqYcr7ZOhELoonMnZ+aV9c1p/LLtO3DVaTNnszOUnlAGfjuKDt87A7GqsbR1zrbsYoPikpJYW1
 yp7rD6xE
 x6npaR3rFs+lCUbmncBRV/GZsyBqp765OduhvM2x9ZqvvDVM6cDatF9LvxuvY6MG87VLLqZgfLdfRWdAr77PexcXVqTyv/hBterxwSZVxoWRTrSZmMSz8aeRl5oHk0iF9j6J4ZGWxqyxixyu3cBLWLkdc2rAUCKrppOchXBuv0pTqTzhGGGe6ZY6m1tb5EieuJsP5YKmBYChC5T1Ut6AgCdSj2J8mrzBXf7ioMdS3j9FFLgVh07Hu4c4PD92V5QyPIrceOnIdki0ltTX9h6oDOdx/M/WPiR4KkhNOWZLPwVT6O9YGTOBXUE9DBVZfo4S3SrUKmTKQ5cZjsMWGcDvDYBZZsgcbqJUVM3iXOxlh12d3/UZvo7jsgEkvBajswOoVfljFrc9G+zaay6Fu3IciQAQAKUYArxGtQZdOczpvrJH9TJ5VHJdbWxniUGSg5rzm/8WA1h/Fd0iiHAZowCPmE2L9ctJuQlyLb4Ld+dmW2lmeo60rtXOH9KzKRnodjkdE61oGWaWR+xFG9xebnr8W0XI4orTixJRn5WBgQfWqPfDpgu26QiCb6JblPowEpvcuqj7CS0cIRjyStFRyG8txoMkZrdT63H8HKDR9E2SEjAIk8uJEBcOYLDsh4uf/4wAKUHaYRkNLrU6DtcxeF9gaVW9YJCHaqcbkUPf/QfllDq6F38t4oC7M+3KDq7rU2xNjoq8DXdZDiNVMj8PnBr78T0MB0VRbcj9pvefCNcRtNvEW3BEKXKkvP6ZBbmUwPMzatfdghsv2MvT6B8yosLcDD4mTYFMwn9hXPg7XvsWENV7KX3VH81cDuK/TB/69qC7vGTOl7aZlXrtCRYmdcG6XpENQnHziTLjzVMnYYq70z9cMMLVwhVwNGN5lcp1gzSpI1cCIzRGOQJrbg8obIoB0iIzmHbr9w77kuPfgduXYA7pxszePtNAEd9iNg/yCCnrYTgE+1vJU+gMIDnQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 07, 2025 at 09:49:49PM -0700, Lokesh Gidra wrote:
> Prior discussion about this can be found at [1].
> 
> rmap_walk() requires all folios, except non-KSM anon, to be locked. This
> implies that when threads update folio->mapping to an anon_vma with
> different root (currently only done by UFFDIO MOVE), they have to
> serialize against rmap_walk() with write-lock on the anon_vma, hurting
> scalability. Furthermore, this necessitates rechecking anon_vma when
> pinning/locking an anon_vma (like in folio_lock_anon_vma_read()).
> 
> This can be simplified quite a bit by ensuring that rmap_walk() is
> always called on locked folios. Among the few callers of rmap_walk() on
> unlocked anon folios, shrink_active_list()->folio_referenced() is the
> only performance critical one.
> 
> shrink_active_list() doesn't act differently depending on what
> folio_referenced() returns for an anon folio. So returning 1 when it
> is contended, like in case of other folio types, wouldn't have any
> negative impact.
> 
> Furthermore, as David pointed out in the previous discussion [2], this
> could potentially only affect R/O pages after fork as PG_anon_exclusive
> is not set. But, such folios are already isolated (prior to calling
> folio_referenced()) by grabbing a reference and clearing LRU, so
> do_wp_page()->wp_can_reuse_anon_folio() would not reuse such folios
> anyways.
> 
> [1] https://lore.kernel.org/all/CA*EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5*4aDx5jh2DvY6UHg@mail.gmail.com
> [2] https://lore.kernel.org/all/dc92aef8-757f-4432-923e-70d92d13fb37@redhat.com
> 
> CC: David Hildenbrand <david@redhat.com>
> CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> CC: Harry Yoo <harry.yoo@oracle.com>
> CC: Peter Xu <peterx@redhat.com>
> CC: Suren Baghdasaryan <surenb@google.com>
> CC: Barry Song <baohua@kernel.org>
> CC: SeongJae Park <sj@kernel.org>
> Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
> ---
>  mm/damon/ops-common.c | 16 ++++------------
>  mm/page_idle.c        |  8 ++------
>  mm/rmap.c             | 40 ++++++++++------------------------------
>  3 files changed, 16 insertions(+), 48 deletions(-)
> 
> @@ -557,17 +554,6 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	anon_vma = (struct anon_vma *) (anon_mapping - FOLIO_MAPPING_ANON);
>  	root_anon_vma = READ_ONCE(anon_vma->root);
>  	if (down_read_trylock(&root_anon_vma->rwsem)) {
> -		/*
> -		 * folio_move_anon_rmap() might have changed the anon_vma as we
> -		 * might not hold the folio lock here.
> -		 */
> -		if (unlikely((unsigned long)READ_ONCE(folio->mapping) !=
> -			     anon_mapping)) {
> -			up_read(&root_anon_vma->rwsem);
> -			rcu_read_unlock();
> -			goto retry;
> -		}
> -

folio_lock_anon_vma_read() can be called without folio lock in a path:
memory_failure() -> kill_procs_now() -> collect_procs() ->
collect_procs_anon().

Not sure why collect_procs_{anon,ksm,file,fsdax} do not use rmap_walk()
functionality :/

Should we take folio lock before calling kill_procs_now() in
memory_failure()?

-- 
Cheers,
Harry / Hyeonggon

