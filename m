Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 328D9C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 08:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB538E0006; Thu,  7 Aug 2025 04:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C878E0005; Thu,  7 Aug 2025 04:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D55D8E0006; Thu,  7 Aug 2025 04:28:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 730038E0005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 04:28:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C4421162A2
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:28:27 +0000 (UTC)
X-FDA: 83749284654.12.5479AE8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id CCAF7120004
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:28:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EigrE0ik;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t8MoFvTy;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754555303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gkYFAhN+uM3qb4q7a994mtGdyIeX+t0NXd9l4fRtAI0=;
	b=K2zv3+a1lWon2isWn+yu8TaMNxRsyBPfY5scSZUIaBKWBpjMgvJ95pK1b8L1ssgaC0dXHD
	JSfn6CSEszvDpYsS3cY5Nl7aqbY0Q5FOiiZDHOOQ63vn1+XZRpn4eikmi0Jf0mQC59KQQz
	iJDqndP8uNo26tJkOS1qHUSQ8AuDPCQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754555303; a=rsa-sha256;
	cv=fail;
	b=KQN8Ag4zEduqP4k34guaaWcozfihgznGqTN9himmy7pADYp0fWKDOGmuj29WR5Gnh3yfKD
	lWTLncNUXJsstJAktzM3Fx6HK1NUwf2FDZazUmregpZbutHdHjUmpLxnDW2LuqvjuPSgWT
	q5o2mljcMb0kGDwCCPXQipie4+X7kyo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=EigrE0ik;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t8MoFvTy;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5777NIkm027315;
	Thu, 7 Aug 2025 08:27:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gkYFAhN+uM3qb4q7a994mtGdyIeX+t0NXd9l4fRtAI0=; b=
	EigrE0ikDJaRFCkKmOQ05E83MYcjGkVeTgRcBQj9xxOYaCob+vJJqh3jYjMBbEJo
	qiA6JnOH8tz9G8fCcOl7kKoKTvWgCdtUE6fXVA27yceDXYJHaNX+JSJMzjPeOrD0
	aIcBc8lOAruL9qOrFET8KmSEvc9HeQGdzzt1jWFux9rD5Mk67RQsN57oOHlVhFw9
	TQKksaT1Gd8JNsorqeQtIftQsFVi1hv9tykcPqwAI9DGH4aOWb1xE6pfFs+cnX5u
	uOZD7zLtDnLgju/GsPeyqVfxhwpf5yTkbSL6R6tZB+m19wngJ0vOC3XciQTMbKeZ
	ssh8P7MWNQ+ymP8rKJAj6g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvd3m7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 08:27:48 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57771OoI005602;
	Thu, 7 Aug 2025 08:27:48 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwy555x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 08:27:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CtJHjBT51INeGo6N49xrVGI4tswpGHPBXgNg4ZmneUq1CFwSq+7VrYYwH8EJ1Ge7OGI66nQMbskEZSECFS3T05ef3RC1uJDpcDgA4R6WFnfRCE3QoS2YPUSb5oOvgt4MWSDr4iqq/y0dMj1+iUdtapsz2CXH5iiKM212LXLjDaV9QGBoW730ptLy6YUTNkH4+XA6VLMfXUTmghhkylISQ97QdJd4mDkK4n7LL3HI+CifFtgq3vXhDu0ixHsQSmRjX1IyRKguBE8S7KVIORnkIvsNKtxjzaEqKhtO20BqD8ydvxx4di7LPjh+8vkP9k/kRztudT3EV06NyUQipzkRXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWisCQ9PL8hGhHU3Lg7GNBX2JIhgq/PaTRUPKYeM/pw=;
 b=QnJuhcrcOi2/Hg1ZAPZQBrEwdwQFoeTF2A2szD6aqAVO+7XYs1Yp0KQBUSjxKSm2DQUfLRLxfcDt1BhtIWVk5KVYW43LqtRNv+Lt8Dw5cKeFZ2IDftng1kN2RWH95XvZVBvtuiBXGm0bMQWiVewxMvro6JunpTDbOQI6tku2DdRIFshI91H4YezRxzjvp+8yO5yKPQsog9KNOvf/xM7NtTHQtwXVdcbs9HYWAOdNbBjNxRacu26vFg7DgUf7loDp/aamRPJdt6uHkezwxlQnXqPfs89JlySp5WF3UE6Y8DqhhKqvHXI5s1uePWmsIu5n12AgqPdWlRBKGzxA+z8dJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWisCQ9PL8hGhHU3Lg7GNBX2JIhgq/PaTRUPKYeM/pw=;
 b=t8MoFvTytQPS/wY3GKvONhOQM99uiWmIH3rnfnmINUMH8DqfxxWHLHQuTx8OhlvPlEiAqeRbcOYcKxtOIUAL0UVFEgUvDPas4l0WZHuSq1iXaKMuUycTbQkL8OPw0uDGY5gkh0yG7H2gpJ1er1KFEakyXmKuE0c6WwWpg3FKtlQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH8PR10MB6480.namprd10.prod.outlook.com (2603:10b6:510:22c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.14; Thu, 7 Aug
 2025 08:27:45 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 08:27:44 +0000
Date: Thu, 7 Aug 2025 09:27:41 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <oliver.sang@intel.com>
Cc: Dev Jain <dev.jain@arm.com>, oe-lkp@lists.linux.dev, lkp@intel.com,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Barry Song <baohua@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Bang Li <libang.li@antgroup.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        bibo mao <maobibo@loongson.cn>, David Hildenbrand <david@redhat.com>,
        Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
        Jann Horn <jannh@google.com>, Lance Yang <ioworker0@gmail.com>,
        Liam Howlett <liam.howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
        Qi Zheng <zhengqi.arch@bytedance.com>,
        Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@suse.cz>,
        Yang Shi <yang@os.amperecomputing.com>, Zi Yan <ziy@nvidia.com>,
        linux-mm@kvack.org
Subject: Re: [linus:master] [mm]  f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
Message-ID: <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
References: <202508071609.4e743d7c-lkp@intel.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202508071609.4e743d7c-lkp@intel.com>
X-ClientProxiedBy: AS4PR10CA0020.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d8::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH8PR10MB6480:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d11efd-7f2a-454d-c49a-08ddd58c48ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?6+7XvjrM4nAfrj0ZlS2yQmfgwjyPg+jzWLXlZlmcu+UsI0UVhuHuERvSak?=
 =?iso-8859-1?Q?Cj0tqgW9i/uJoFcP4dNHj6MQxDB9D87BhfHf3gQz1vvJLivG9bSWXZ3EIz?=
 =?iso-8859-1?Q?lcT1KX+1lowJ6SptblJMd6habU9UMSUPzN/RBe0VPwuxkjLjB91/F8T/hV?=
 =?iso-8859-1?Q?2cGwV2I2SJA8k4wUGRuQVMV+OehmDHFrWBEB7CeA1zCYaTy8QkwEZY04mL?=
 =?iso-8859-1?Q?wiS/8qqm/nXj1tBj3SGxwF3DrFaiiRNstU1LuwczGJ4PZz9fCNwKyEiGAp?=
 =?iso-8859-1?Q?+5xHoiJIVBTGcylb+eKaIPsTdKFQAtJ5gvDoaotRYiZOoB2EAlKT9gKrp/?=
 =?iso-8859-1?Q?C3c6Xx7nO8eZlv3CjLxNOchB6GPM3VMOnZkou3uUOVc8Lt5NWpN0ooF+PN?=
 =?iso-8859-1?Q?ZKN/7ElOV/awB2j2ceosWAOFnFDEPrcpyeayxiWq0ui1L6M20UYYVPo49c?=
 =?iso-8859-1?Q?WeHz3IqrqNe8SN3No7TpABNwF7eyC5ijZUcC43UxgsqmEu5QmjwqVe+XJp?=
 =?iso-8859-1?Q?8AX0XzRWy/uuLCvm45OjfTyAxTVQ1YDdnrHvYN04HuIllnLeRVQ8uk5lbU?=
 =?iso-8859-1?Q?ixYFWkZx+h9PirFGFRG6qlbzpOIDKmgbr02Bt3eFYJ/p6tK1piw5ErEC4t?=
 =?iso-8859-1?Q?Vd/oMGVOlTccYEqC3cjQjnJ9peMkFreH75d8Tl0odvEEz6EncFb1Msasz6?=
 =?iso-8859-1?Q?kztY4WwEW+i0N/4lI0uguQI8Y9KFKD3zWYusQ9wK8E2Wm4Dkbu31b/VfIs?=
 =?iso-8859-1?Q?OYecgVJvYZD0LLYZhDhNTpVWImzuajpxQxKV4AtIsfoBTzHuzItN8LD507?=
 =?iso-8859-1?Q?hcFH6wv+zQlESnehbpB9pSnPGcFd7mDZOkXrF30tALLJ82blYaWwq0yH6V?=
 =?iso-8859-1?Q?4wU8DxnkjZO9ssDfZfAbsFo9jmQY2kIng+JYTRrZkJwOJNy/xjvCALmVp0?=
 =?iso-8859-1?Q?OXVeyt37zj/6eFLyIAnkQyt05iZvo7tM1kcCDX6RH/vkjAtyHKk784t9C3?=
 =?iso-8859-1?Q?vz93I9VInlXwKw+4nlucwK55CT8NXp5p+wzYxcjuFcHUMf79KV9m7CqwMx?=
 =?iso-8859-1?Q?Z3qmbcKJ95XcgJ7QEcpYB40IgKDjJw1nQPWXUfPm99J2lj0lvf+bwXIBvW?=
 =?iso-8859-1?Q?RhVC9uS7GghaF8DWA/85vZ0ZDBbY7a0OA+Hlqv/AUcPzEp9oQIGtz9AhvQ?=
 =?iso-8859-1?Q?QuSBR5M9SBL0UbW7Eze6uZfCcdPsDyGgxgHd4jsqbX1a/enwWU4HTv8/bM?=
 =?iso-8859-1?Q?rwtBfBT43oPJ3w5ZWL8c4BEZEWPbCdt/59iLkvD7M64Ds1ODoU37r/KrtU?=
 =?iso-8859-1?Q?SUi2uLL6UOat6DyxNVNlYvbme1JEkNHHD2XdwNoIVuBtpYeGFSb6oN2PHF?=
 =?iso-8859-1?Q?ogIp06574Afxdg7PaIXtBoAdNfXvDox7fPt8ZFF6+vb0gDYxXj5d3rka+y?=
 =?iso-8859-1?Q?FgVuxs01w/xb484A?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?I5tZUzH89wz8mDW5W4ISIkDwcyzfC9WXmj3RC8HlW+oyGCxfwH6R02op1p?=
 =?iso-8859-1?Q?LEznrRGxWKAtQNlOYV1LEqDQrcmZALXQuAUOw+oqMBa3ClLbEYnVYx6LFD?=
 =?iso-8859-1?Q?JsY+Ec2QEx5jYKOAFLfwaiFwQTdpPsl5xyfLHjw7NcJ/heEiS7bjslZRVZ?=
 =?iso-8859-1?Q?cdYC1D0bn41jVs5earCJMqrKbxbqvpe7YPzFUVVmd7YO3+mUK3T2ZHmEer?=
 =?iso-8859-1?Q?ui6AdVRgm5K8ZAtJsvmGyRcSX25CWNsrr1nwyn2HmrjnZZxvQgHuYULuGB?=
 =?iso-8859-1?Q?7ih6As2iRIN/QGGQFMfWCWGmWc97oePbLZSwqdugcl4C+2LyavVYTiGCD3?=
 =?iso-8859-1?Q?+g3MQ2QPTFzHs5arpavTuFJLk3/PctwGqc1fR3N35liibDEsj1K+tpBoyK?=
 =?iso-8859-1?Q?/kPXO20B0CIdfbbPheq+7Lqr0W7Wcc080OK9x/qia0j4iz91BhfX2agUFL?=
 =?iso-8859-1?Q?SQ6LronRePTYS9J9PH18B+BK4Rtbx9J8AixQQXLdrao/WAWX/zC/jkHsXe?=
 =?iso-8859-1?Q?pEpE+yU0B1MmhamiT8id3yblHAXBpSJ/ZX4mwkxxqZYt0Tb3CoLCQqImx0?=
 =?iso-8859-1?Q?gBuR8zmciz4jDEYqvV7PnoPdkrJqLvZpwF+oxm4cvTPA2vhdXFj+AF0UeG?=
 =?iso-8859-1?Q?3GfuFvpKg6FFwW98z0vmZfrq1Gt8PkHWsdj8Xy5WA5ZR54nzg3gHOU9pxS?=
 =?iso-8859-1?Q?16QsBJz2/G05CMePW6R1PkK5aWmoyBlHCcXjphlPgwdPwPuW78llAznX95?=
 =?iso-8859-1?Q?t6tCZoHu0wuhMmqm4H0J66cK9qLyZYR4jKn8d93lr01pY4ZKCfKUOPjyjp?=
 =?iso-8859-1?Q?zy+gVeXGeSk77So5GdN8ZGpLn2sTkIfe0A5AbtOlrFO6Wg8DguhVQOQnhd?=
 =?iso-8859-1?Q?mXoh3ID4PK3XCWTj6j6Uj6k2z7BiiLqVyxZnJAWugAmTdFKWgHgv2obdkI?=
 =?iso-8859-1?Q?2zCpa6YwG+jhP+/3z7+J7x5tXwQHFnogv6HfRUTdZP0QdLZrBsNpI63byZ?=
 =?iso-8859-1?Q?mUo4vsXMufxry+FRFWrOjvkY01omnukzpPWfycmSmHjvZOgGnwBZukGqDR?=
 =?iso-8859-1?Q?uQ2MTliAeupuj9fZokyu8JJehSb9otmfpAG+ft5YTJmIW0OEV7w4ZYZu3a?=
 =?iso-8859-1?Q?l7p1eN1sBg3mjGtFcH7tciZNhfYeuatarudG4l7NPVFAK+QjHItgJe/rda?=
 =?iso-8859-1?Q?fNnBl+i5v5CbJQW04eog4yAP59GdqaMM039qlryqZKVCyv6g5xRfasscUw?=
 =?iso-8859-1?Q?I/JT6bLKaIWoQwVdwscitbeA0UojrwvvkPnR+Py+4YW1EbnEKS3yd9U/fu?=
 =?iso-8859-1?Q?RSRqUtQuqaxQKY8LbM1t37EMtAU2Ak4GWO/t5iKzU5I0LC5orJi6LYSzx3?=
 =?iso-8859-1?Q?0ypMtOaoI/+Ex9z8Z/ug/UeeX8u+jP+XJuY009zhGvR1djKwr0NckoePbh?=
 =?iso-8859-1?Q?UAa2kQaqrapRSVf7jekM7w/YcihAyTSJbPmMTBMXZtaFDITmV/3pyO15O3?=
 =?iso-8859-1?Q?yqOZ79d1tXMi/2MY5ZjRJXy0HhkCd4cHZ1QMMwnHCbCb0lK2HJXhFS/7fd?=
 =?iso-8859-1?Q?+j69FAwMS3SW+ADih3e9wOjuH/dwFIuOeOBA8mxCZsAx0r9YlPWpopcEpV?=
 =?iso-8859-1?Q?VkO3LvgDUqLJ2KX79q1fDjAN4kvMPcq/cRglsy6RRGGEI7saZLs8dcJA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oi2kmVEChYRlE2uagQD5jAieqcB09822f9B+AITIv61HdCgXtDzG+tO8TESXGhMBzSoSvRl/kLBHucgfwWX0Eia+FHdOzXa6674KMrLOaionG+DmleviVija3d3WR3B9uG1F/N4m+c3UH226fkMJ+7d9UAsDXmmjTJGVh+74u+rWzH5o6phU4/tVAE1232qxYFUL9+iCREgtjv09DR7zHKFAI1ydx3sXOA2GDkGFyALf/hDfJzglqan+sAY5nzB83cIwbXb+WsEznAvGvlUZQf55ZNDmKlI1iJ4q+5OMBAEYfXLteQ83/ZbwrKSvREC/ROgBAv7cX8ZZqhyqxE1sLsAYwWRynb+UU82EAkwTZ8QxJuHmif9gaYUWaNVN3jWJLfoB1RYf9fcRxV4WjsHIPXdrCJdJ2342XpuVNXGJj2d+0puUHUIwkNicHhuUeMyVXPqpU/kcqZ7+Vexy6V//4/uThKhs4goKxMXppei6L1HPsUS8/4pwLcdNzaOHl/DXx74+IYRZqTwxxD5UA8orADspCnSTq47b/HYk5vP6pASAgFZ/cxJidxNjxjNNZWCdLzTOgHxxPbHUOKbIhTyaFG9aQQF+mioxtN+tELvu29Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d11efd-7f2a-454d-c49a-08ddd58c48ad
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 08:27:44.9194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgxnynjP37qjm9swEbj+dBOLczzoW7MC05xgv6O18oFQ5RknsSuB3KDZHahcxyinJ4KThWanBDeMapAFc6jX2aza1hGrIksj7f7QgTzG5+M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6480
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070065
X-Authority-Analysis: v=2.4 cv=fYaty1QF c=1 sm=1 tr=0 ts=68946385 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=i3X5FwGiAAAA:8 a=YAzRl4z3mscFcTnjqTcA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: LzVRPn-Xx3jnFnQAkZB8a6h7NqLHWj8c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDA2NCBTYWx0ZWRfX6DxJmfF3c3hQ
 tEG83GgZLxxxkYsQa22BrZ6If3QQ4cgvbluDR2WJ4u8Ipt+P9N55p+ESRC111K3ObUyrR19xmSm
 zeqpzZeYAHLnstVhSMoHMO2nmBnzrLjQq87rBiSbWCfv6gjTY6bzvC0517HHwa82QWoS2tPIpa0
 F+p5u38X45I5Oa7GKbmUYV2XBh/PivQ285VfwWCYWHRL7SrUi/m87mqirkBscZ5CJdEHYGiabT/
 qOxmxMPeOm7LMaw98m8Wm/sa6vMdw5oxW1ktQssYoBJ3K2zWZstPWrpX8DxiyN8x5umYV7ntzrn
 wQogF+AavrMEQKUK+9DT+9sadTeO3vXUK94hfy8dYh7FGUgxAUJxIlxnsqlJNQCRFdis2oUgbOc
 H+BKU3iEqUQgF+kRaQHiWbtalXEiYP90WnVH/GzpYAFEfozJX7ctT8A+2sl5lT60HS0hSFp0
X-Proofpoint-GUID: LzVRPn-Xx3jnFnQAkZB8a6h7NqLHWj8c
X-Rspamd-Queue-Id: CCAF7120004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: a6n93o8zx3cqzaoj1xrmkyn66qgmoxm6
X-HE-Tag: 1754555303-988019
X-HE-Meta: U2FsdGVkX18+QTsMsfklvdkicduWfuzeI8by02P7hbRThk8PmOmBzWw1HawJJJ5i4uxO1e4kLY+22nSg3sYlaDhEAe11HXH8Nne9xeHur3CexEwejKsDbN+8dNYkUoK2MnMIwp1doW4kQXBc9f1si0PHRoiW7DSyMD1D6seZEkeIjDHg6BGrJC/DaMHtPXwlAhMDkpjCxzSnJHuXPK2Yt5Q5aTmqes4fiuXzUbbCdafIaomoV17A+JU8nImWZI+a7/X0JLfOKTj4XuZJPG3QHhVzywzDTqfF9QrWZumfwVGMETuU1vgEH/zMc4h4f9RJgUyiN7MRgA3hGeqE9FdwJEgu3RUTcp0YL3pvUfKcqMo3tffi8jHvwEdJZmSs+xryQ5xzm28185jHfOyhrwA2hfQA7lqlUm5qxp4pfMBfeMylXFpPsqaNRZg+two1p5zOFgOJbQtcTpeJBHoCblZ17KHCCYxJFZAM+b+BZUmlnzC25PMpIfMDIGPsOrBP1KFp+HGcUFPEPBm4rg4QAPSedeoRPx2zGedQsRj3DNB0EZt10g4Sk7CQ/SccVRZd/37qjDl2KhtaPW1hRrQon9Uxq96IRoXrywqyeROd4CEkufU9UJAY7il6Mip81WHKh0Vb3qg5KrfOOlHo5h2SQA+eAvTg9tS707xog7yntK23BCGbcp1yf+yrCtUmu7c3YR72DxKCKEfS0APXZb9VxAz1U8gwqAbpFb+GOgclmj56WefksJ8mRmClQr0H0CgdUxDTQtsT7++kk7ucTaXy5li+9q+1YXAfnAkFrizz5sNXRScEtgFU0ZzreQzw5fES0EPIUeMteZ0v1ojimP6t5oO/AOFAwI9at50aQTXqQSmsFxYYZiLzOCXChEw6qr7RzYc8NcJNnWSWYbgKo4oWxkfCes/elh4VU4qLCbdPptFDVIMd9Ypk6nvNBpuF0kdBdsCzDLF+fEKCe7DauwXmCvA
 1/Mz6jtS
 DtTLKIAlkotFNXlO0iEMFzZaCGQeV3KdEkH8R8GxUKqyI3kq4mlNcERU7j6n0swPx+UV3sllrmu9a5HmZJSu8O4Fnq9Z6tx3J6ktXaJYeXSzSoWIQ3l9eKIaTiogcV/BJjZ8ZlFURM7m8tLzgCUiR2Q+H9DNA60LMSD4lgzeUnzchvBSpylHnaClXdh0BUA0fSqH0FGHRunNcOeSt0xp+hrdqLex9LMdZ0o0+ifE1IRUUMV4JEfHhjL5QqWMyCESJCoJxHBLUGDLmg1DLrsg0wBp8GO0TDKFkDV97+Z9S6EC7LG7c/mrEvP7KUhnV8o1TjsqFhuJLDgjn6fS9ku+RfKjarakXk4doyoyu0+g5utv1WI7IjMy0Px3LeCvpeITSdzBf9rOzjXivCFYMxXAsTBZtc8kjcacnkOObfcdUqhYPgajI+dxILODBloJ7kZEIEIYhSF7kkvZHtN0IiuY0M8oObr8REM6er6qT3UuvGeHEdD1ibkTUNBY6qSzQQIt544iEzceVH3YedZreOfh42KCxAiVsg+KSHtEhkh4V5ot/DNZRw4j33/O+40MD21rJO9pNXkv80KN64lmpe98sJjNv/jzEyzmr5QEG4AVtMLTDBP4Et8pGzDnmc9DgTnpo1RJxrCoorONqE6bwx0491xxTWIGejeCm/6F0sdoLQ0mot/wNnb1cHnA4ChIQYjaUYTyN0RVH7qH+DsGAB7GHrIDWxB0UESEUK6sorlNOAneyhc28kdlShB4hNEwKJlrZ1XSUFB/Slsksn2TrXxVVgVoGesR6d1945kHu2TND6d6AL6VTrQ11//OPy4Q9aEYlKPH2128GVcyMp4aC0EMZnP8fHmFJIlXeizTsYDzI6zBHOkMVPaNXM6Fq/kCvQFX8r/d4whYiPCq8yALISRfVwOt6L3431KK3074Iym0XvX4wi4PFAHP6TQDYgpu3+JwpevLtcHd3l6Wkxqq0h5rlSb8aSl+o
 Rr+7bvND
 7JPOLCyR0t1TQanTPc7WFzZDsrWV8hBvGveJZ8/GPG0G7AQDvQHFET45EEGDdSfCmlBLSAv59Gk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>
>
> Hello,
>
> kernel test robot noticed a 37.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:
>

Dev - could you please investigate and provide a fix for this as a
priority? As these numbers are quite scary (unless they're somehow super
synthetic or not meaningful or something).

>
> commit: f822a9a81a31311d67f260aea96005540b18ab07 ("mm: optimize mremap() by PTE batching")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>
> [still regression on      linus/master 186f3edfdd41f2ae87fc40a9ccba52a3bf930994]
> [still regression on linux-next/master b9ddaa95fd283bce7041550ddbbe7e764c477110]
>
> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-12
> test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
> parameters:
>
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: bigheap
> 	cpufreq_governor: performance
>
>
>
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
>
>
> Details are as below:
> -------------------------------------------------------------------------------------------------->
>
>
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20250807/202508071609.4e743d7c-lkp@intel.com
>
> =========================================================================================
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp1/bigheap/stress-ng/60s
>
> commit:
>   94dab12d86 ("mm: call pointers to ptes as ptep")
>   f822a9a81a ("mm: optimize mremap() by PTE batching")
>
> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
> ---------------- ---------------------------
>          %stddev     %change         %stddev
>              \          |                \
>      13777 ± 37%     +45.0%      19979 ± 27%  numa-vmstat.node1.nr_slab_reclaimable
>     367205            +2.3%     375703        vmstat.system.in
>      55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.KReclaimable
>      55106 ± 37%     +45.1%      79971 ± 27%  numa-meminfo.node1.SReclaimable
>     559381           -37.3%     350757        stress-ng.bigheap.realloc_calls_per_sec
>      11468            +1.2%      11603        stress-ng.time.system_time
>     296.25            +4.5%     309.70        stress-ng.time.user_time
>       0.81 ±187%    -100.0%       0.00        perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>       9.36 ±165%    -100.0%       0.00        perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>       0.81 ±187%    -100.0%       0.00        perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>       9.36 ±165%    -100.0%       0.00        perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>       5.50 ± 17%    +390.9%      27.00 ± 56%  perf-c2c.DRAM.local
>     388.50 ± 10%    +114.7%     834.17 ± 33%  perf-c2c.DRAM.remote
>       1214 ± 13%    +107.3%       2517 ± 31%  perf-c2c.HITM.local
>     135.00 ± 19%    +130.9%     311.67 ± 32%  perf-c2c.HITM.remote
>       1349 ± 13%    +109.6%       2829 ± 31%  perf-c2c.HITM.total

Yeah this also looks pretty consistent too...

Yikes.

