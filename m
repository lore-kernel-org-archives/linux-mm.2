Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFF9CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 01:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 830CF6B0088; Mon,  8 Jun 2026 21:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E2426B008A; Mon,  8 Jun 2026 21:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F7D36B008C; Mon,  8 Jun 2026 21:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 604F26B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:44:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0ABF814036D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:44:56 +0000 (UTC)
X-FDA: 84858680592.16.E8A2F37
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012020.outbound.protection.outlook.com [40.93.195.20])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2B4011C000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 01:44:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JN5YVtUE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780969493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCsCVwycKyOWOO4nIEhUh0UmGOrLFCsTQvGHRGgT+t0=;
	b=ac8jPKGyAjiw1aCrXnU732gnpPVlY2RICz1iqEGx72h4xfvvD0gabYcKUreGPokGl7v3IT
	6K4BfmPRQk9nYH4DzomoJAc91ON4G64JIyaqT8I/4ExxFCtM8eXFJm/OIdwLTt2tvQS5mb
	JN7O/sL4K4H5MHFOmxPFExak1N7Ks6o=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=JN5YVtUE;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.20 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780969493;
	b=B5MKuvmYmQSoKlaQE2F/BAD/CiFIR8viEE8iZ7g4mNEsAvH4LWyZxlDm47B9sKlMwIatZ1
	8Gv7PNoJ6Y1Q+rPWIeL/F3pcQL27SRK+OIuIOUW9pOcx0JBuvZGYQ55oH/RBq21GHOu40D
	Sn8Pj2p9a66qgqBOK2BF2E+jAJO8iPI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FDYb3Yv/cBlaSR2qSBPEWv0TQOd1xajsbjuqMeIYVPOVZJqjfedjpzYOVjeYJ2cufimyWPeMcafocnDyg/CVn6TYJq33ZqU5ngJKqN2MdlUN6l44hNNnvilKYiKaKgmqHf2Y0pIdUBxRxS6pR3DrbLnte41Ja36jDJdhSMfDseSvNSmViIvQ3SX+3HDIdWNQUjG1PSLRSQd67b2341S4XcyofgrhxntbUDYffAPKrSCmNzCAst9P1xxTvbnViHmo0P9exdVQuKZIwHN9RV33l5BKXOOxMX74VFolBIgIP9a79Y/4YhcXLocn3RW+HSLyihJW1MM+3/zEGRVpzWEMtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kCsCVwycKyOWOO4nIEhUh0UmGOrLFCsTQvGHRGgT+t0=;
 b=GyM+kXHWusUdcV074DC/qGnHZI/YKbj5I7fZdMJPs8XwiRAKyicndvm+zXvDt91fCYRz7bYbkn7I4n2DYCKUnsXelLs7f0WLsfh7TetsFdwypH9X15Xs3v/aWk3q4Scir/loh2vnQWQSBJO6Jqlx26mDBPFBZcmnfteOQc8qlsbl6bY+05X92NHEFA6+t0p0aTBjhKO25nI88eJEVVx82IfazSJMiLYm6vOpBfT/SNYGwxzEUAS9ZLY8UNo4Q6MeupmFEI9iSkvKuyTb0VKKcldbI1vM8E09Ho8Dk20uMUF5qvUUgw2zqSVHXEeOCJwgC9NVqsqTPj/PmDYLsVDypg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kCsCVwycKyOWOO4nIEhUh0UmGOrLFCsTQvGHRGgT+t0=;
 b=JN5YVtUEI7DC/WjIKvtgkFbJqU5WTXQwfPfU3j587tPdLDrxyysQKIFJO8coch71fgcL6/lvMlHMvZRZilkWvYiooVbamcJ933GlWb68eAnlPw/veuvEZcsV/wwECgTi6fxhyqVWNoAaliqyK+RTCVQN4GZ9ZVXAVETCmZMKvbut/EkvirgV6zyTBubrHKZxlQZRLNHXp2M0xQdGOvINSpbEAxcdOwGi3SMY0tU1VmljAp0CUcrPzxXPGouP/MdZpfH0sTgqd2+Sk723WLeynyXGNH/a4/vaBINy+2VRuB+U9ECuFm8jQFsZCHVQXz21TdeA9PSlX/FsregG+ZH/UQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6924.namprd12.prod.outlook.com (2603:10b6:303:207::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Tue, 9 Jun 2026
 01:44:46 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0092.011; Tue, 9 Jun 2026
 01:44:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 kernel-team@meta.com, longman@redhat.com, chenridong@huaweicloud.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, rientjes@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, tj@kernel.org,
 hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context
 nodemask
Date: Mon, 08 Jun 2026 21:44:42 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <8C4E5377-F5CF-458E-BA49-3D962CB75477@nvidia.com>
In-Reply-To: <20260609002919.3967782-1-gourry@gourry.net>
References: <20260609002919.3967782-1-gourry@gourry.net>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0279.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6924:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b0b462c-b443-439e-2e9d-08dec5c8af3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	X2O2Ra1NdE88w8XxK+jT1Ctm3GN+QPdtBDFuGReHukYMT/MUpCNOLw+gNJScVaifdzcEEegK0pvQ+qKbCyXspPgoQsL+nSFjCFDvuwShlLw73zW8YpJ0uhI3bMBR1UsuTcDEihnFW1h0gqV663VKzSw5e62MaVJZqoIdKZzKl+ISnvqq/Db5JAQ4uH0FIB0iBe/jzk+vULR5DW8Hg+i/K8KboaERrPJcFv23B2+tr2lHshiy7ZQ1IhulbYcExd7QAzMdvblfc6mp0MYkgPNzao+mbG70YLiXEQ/sFmKYHWWG2w7gyOMxULVFYY1vK1TFC5LX5Yh04wYk4nbZWWTuLRXPayBMLz0IUqjqyJoCdkiFzeMDMIcze3ppZ04g1U4hhA9fyR8Fw+wUpwh/4qfne/HSjUCsh7fhxIdy6gqBaTo1KpdLHPmWi64DItpTXruCL9PPi7ia5PfQrU1QLDSmwati0Kdx2Jhh+12pRP5i11xHvfZvSsw+5trH0kY9pQnlxuVkD4HbNfL8tKTRKwlTWwFqGj1WepmOCTLDsqIaTAbQ00WRBoHZY+uU4FgTtvJeLB1nnu5PZ/sP1PS2NeKy1GbCdu7694wL+Dsp4lhi1ByldFZkQ5wa9ggbtC98sw1Rn2lgEJNIMi4s5F9c5mL/unfS/ELCzZk9Y2Fx+RYyDwoxs3fMQGLcAPNsXtfWBipP
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BE0wPIPA7W8b6ch+M65X5xgqQcNEYbSuA1A2Aef96sKd56PYgnBQEmPOMs8Z?=
 =?us-ascii?Q?AHFZkNsob9WiCbHMzOi/srpPJmpj37P2rzgiEUWqfGBwunf25gdt7qeDvBPf?=
 =?us-ascii?Q?CjbLid04vmdJ63MipC59LGDCXlCKPmtFm1ByhqWcqF3KFY15mBZgK/q0Ay0q?=
 =?us-ascii?Q?+DvJsvnQgHcmckgDjX2NikO9foFheHbzf3ehXl9DRxnigvvSwm/756OoX4MV?=
 =?us-ascii?Q?qOsruKK6bz9nXBj9MKXQZOgk7UNe1xZKpB8rOZSpdEd5bXxUmfyelcCxLXCT?=
 =?us-ascii?Q?EFCXAEjevHjPXOy/HI70iMpyCEfFKH7WsDTnE55oqVselg2B+AdLnKA0oPO/?=
 =?us-ascii?Q?w462kX0zm+fe0PN7J2Tm0+HFOnsVy7gVDeTP/MuHTwh+WisGwc8B5/QUMuq7?=
 =?us-ascii?Q?6kaB5H5g/xZrjOxAQsLlyUzNnHJqr/ispsZERyuXqdmq6fsiG277+TX+kkUr?=
 =?us-ascii?Q?ldLrE1qNRXhzU7glw8UgoEU/eQ3xRgpU1L83UXDh1SSZn81YgelbDf09ifAy?=
 =?us-ascii?Q?tobyJrFEyoCSsWwcwMOGeX0NgKBronuyjZZ3i6HFxBdIsuafaPj9PgRRdOAB?=
 =?us-ascii?Q?Dsu7CgF0OVLvMq8i9kvY2MbHtirmPZ1WDAFctkHmuJbRiZdv292XdSO1rMFa?=
 =?us-ascii?Q?i1F1/tpy2r/k8l0Np/uSmeV5xpnjK45Y+n6vZwbDP18u7EJa26T5dQZG4qIa?=
 =?us-ascii?Q?2qpMdibbIk8K8M6zSgPy1wKvgPeMtT/h1dNUxmUL8j20E9BVwp3XOFPzyEe2?=
 =?us-ascii?Q?yIVhodY/5RfS76c+ksU2IH58lhHVcvYmbI1MX3ew9f9SlE23eLoh7qi4Ip9d?=
 =?us-ascii?Q?2sB/+XrJl/mqLOFKkbdNsH06cl5aix/3aPdpqXwPvnWLjufJ+ASHKnTUYFxV?=
 =?us-ascii?Q?YJouCVBic4rxJC+m7NaLyNY3Jc4et08egsX37LKRfSSxULRhhgfxjoMpbR7P?=
 =?us-ascii?Q?oPC5Cjs544EZyF9sTkBhs8cjkkmmuWdpZ2QYNWkxJ+QaBVyuDFYJBOLGxxtf?=
 =?us-ascii?Q?tMxPnLe5bIZu1C0REs6k5BC2xzGB9t98Qbu32aDf58p6exFpsCierjNKIPW4?=
 =?us-ascii?Q?O6eW2GA7hzm7yuMkO/S3mKlHCjVhNr1Yc6jDhgxhdaHYjPeC2PPPzbC3oKyN?=
 =?us-ascii?Q?pwQ316wE8CQZD9DkaNqr8ea8lwToLmmh7oD3C4iMRiAftuqAG8SPx85k6lBx?=
 =?us-ascii?Q?ociCjOVTOtWwukiQxs5Pq6tqWW3QdefMocJypBIdUQ7yHXV499AuUquzhVOi?=
 =?us-ascii?Q?EWOeWcepgTmq8mUBjdwvv5mQV4qx4NIxC244+LEuyXKtOoJ8lyW6YgpmKsm5?=
 =?us-ascii?Q?ZWbUr02nfB6MWtGLgFUO2VGo1tpjixCbUAnQWigPT+rHYwNZNGD7tfBzzfrC?=
 =?us-ascii?Q?Wc86ergAvq5fedjGEPesd6jZmELrcq4FGuf6GI6tEI60ppCfP54CBv+mys+x?=
 =?us-ascii?Q?3b0gswtCNmb8IQ9O5/CRzkcgfKdJH6YJnISOQmt5jZ9PmfU+j1eV9upzXI9F?=
 =?us-ascii?Q?F8nvtUYbzzGRoY133ig60rKg0Uypeq5iA/00WAII8a0TTSc+/naG5mwxwdA/?=
 =?us-ascii?Q?rvnUe8ozWLP9uaPJk+pwTsvKhRsnTRZ5v3eUSTFhgugAFWgMdjY91rhOUUec?=
 =?us-ascii?Q?40HCr+hCqCY2EjCfEQSESpZqediqKghVYQrzQSxmnILnvmnrTutYSV2T3J84?=
 =?us-ascii?Q?5zk2h3E5+9ULKSpvkKu37w+vjTqihUbljJqdFcBZJCGuwDlv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b0b462c-b443-439e-2e9d-08dec5c8af3e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2026 01:44:45.8344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l1Va6ej2yxcT6uq+5GeKkdNt9aVontAKJSw7aPub+jUjN3qfeLZVh4xWqB06gH+v
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6924
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: e5wrg11bp67o4cdoezg8ne6hc33qey5e
X-Rspamd-Queue-Id: 2B4011C000C
X-HE-Tag: 1780969493-835735
X-HE-Meta: U2FsdGVkX1+kOsijG3h3vu/k9+ZyX9FK0bIO0ohpg/DByc7ZsRGn61Dk5xQmIJ8UHda6J++ahMk4y3dhmkWrEvflpsGgkBrkWiGJ2vx2pjDWAyBqhugDPC9VZRll2hw1FbZxcW0tmGizJB9P0LipLRqg9Cwc7tbrADq5JcdWSfdpP93QEK14XWwOsf4FpepjNRzu4b0+KuG7Z5tEKiphwXf2R58ywFhAspbZm6niKhQ/tqZias75A9azXU/XBbTdDaL4JY0i/4L6QLERQI896Nln09AHuLnA8II8QpXCcW2JPFRWDQgmyvYXOt77hLG+ycddlUGi3qTD2/cmqkPzq9qQTvMl2wT8xzvjxhVSJLu37diICfXLrWcc9h43twpR5fvP9etlFp/r7J99WswryD2zbXx908XJTXgs30c97twvwl95vjfzmY77orConHeGNTwc8poiBj3JOXnbdBYqBRaszjdl6XDEivYoy7VlMqyATH5M7b1fO76Zs6f7eLkATZepaeqVd9SVjLrpbJ6vbw1baqOMQgGJwmCu06x//NQ1EOvVoh03Wy05n/FG6r54KbYPAK4cC1F97G2+ZPRjBia9zSfgx0QLqRlKnoABPfufp3vfXH18EadX5QqH+g6vEUN6F3mBCoHNAAImQ5pL30fu6djsZCt/A7Q1gnXGkvwG1Da/FLsZNOuteY1gpadpt3QP5OlVLhSiOdXVe5x+geLZX7oH8kXSb6fGMdDb9dxI67aeZwC+gvsOnDnlZvTULzDV3tge64qm6PmoLNOf17sRzcd3hx7k75SsLb7UwpClEUmIB3mLKWKSLRKezvxOfKjy4CfGIUiAPnxpEc3eJmniyj05s3dV9LAUoRJqp202zgkZpAWBH8GcmTSo5XfSra08n3QwDVRy5InJJIczW4zXAzvHETabcpY6L9kaRXks4TPnoD0gaXdCI+5r0u/2EHAGq8nHiLpjrFMzzYo
 K22JJ+gy
 8J2s5BTlWzd16q/rxuJmhv2V510ZMkh6tZrP8IH2K2PWGnE7ZMDFVQyGEkb/3a6VadUiUBW8HW3FsDxs6kDLyFyVtp0KU796aaig4RE2+s+IXaQGXuHU1rr7AqIAeM1IV+XbUbz9lipwEh8xNVGl4qN9tsKNRTEbLHUAtcQ9nEu2sZfbhWeAdVXunD0YYqh8jEfVM+JBOtePKP6qNzUSKWepUbv/BRP9okN5inDqAB6+Dv5pc1gSPyDHVAma0nW2OOSPtodkUhnNitg6e7bqQ0Vems9Ebi0qoddQ6F0C3XMK+C/c0xxM8QxXyh7TQXbLQmXjhiYuKGcccF38t43Pnb2Kli4SbUrgA0Byn52IDSaO9f4p2uEpPFNDnDSw0I9qgUZ5SZTgjqaBQdGDpvGl3nFISdUv4yUBcAFxtu+L6q0I8fB24nygru7wHzlfpW6m99bpriblWhUPIcTC3LEVw1txUVHGUr5BqHvReCw5ECh0B7cRV2y4vQHIeHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8 Jun 2026, at 20:29, Gregory Price wrote:

> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  include/linux/cpuset.h | 4 ++--
>  include/linux/mm.h     | 4 ++--
>  include/linux/mmzone.h | 6 +++---
>  include/linux/oom.h    | 2 +-
>  include/linux/swap.h   | 2 +-
>  kernel/cgroup/cpuset.c | 2 +-
>  mm/internal.h          | 2 +-
>  mm/mmzone.c            | 5 +++--
>  mm/page_alloc.c        | 6 +++---
>  mm/show_mem.c          | 9 ++++++---
>  mm/vmscan.c            | 6 +++---
>  11 files changed, 26 insertions(+), 22 deletions(-)
>

LGTM and it compiles. As long as Sashiko does not complain, feel free to
add:

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

