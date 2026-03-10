Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606F2FD4F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901866B0088; Tue, 10 Mar 2026 15:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B88A6B0089; Tue, 10 Mar 2026 15:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB7C6B008A; Tue, 10 Mar 2026 15:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BAC06B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:08:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D720A13A249
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:08:45 +0000 (UTC)
X-FDA: 84531090210.22.5D66D2D
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012061.outbound.protection.outlook.com [52.101.53.61])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0975A20008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:08:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="AqV/5lXM";
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773169723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaDBAflTCsD2zeMOR01gTBtR53M4oFh0PF5obk1a/y8=;
	b=vpbnQzBVI7Tsfx3i6FseegQRvZpzfGpZ6jRDqSrV7rfN6P1tojUgxdHBHGiWlBTu+0H3W4
	Ctee21O0ip9NWff43rk0L9hJNSHmOliJYaHX1KhfH/IfphdBV+4SjzBALVxtEePX/RhFMJ
	R9JVKphXDANOhuwWVvvVChBdChM/ItQ=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="AqV/5lXM";
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.61 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773169723; a=rsa-sha256;
	cv=pass;
	b=w+Vo7+JrWnzUmFwVsCIBEFocRjdFaBo83Ik+hVJiNtM5lXVZVytrWJTrgcfyIssbiXoav6
	Lg5Vi+AsTZLj9E9VqH6pLEU/srhGKIXWGKt7CbyN2Jl5NMdqyPkvnUhBl+de6xzMiikHAj
	cAGNUcFKulOQ9ytGS6fzPHMiLB7Sb2U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ebqYd+lv1oAKxMaHIhg6s7e4Utobugk0bHVi/nUprAArlvrLNXcES8rCN8ZPsdANJGMukZ4T5gfWkxXSF7w/1cyA6XvWSOM6k2Yp7PpvhW2JrCA0KjwUy9aGd6jqiYMr7SnYnY67fiSTktxYzKwdG/yjoBAC3+BD8fIeA7p0S+2Q8jrrQDvmOVcy5jyXyDVFzgSUIWOKKdnU/Vp9A5OXwbqo+D1WeVIAD6F13jTjgb+4QcXWmmAGqErDDcG+btBxb4sceC4JKcC7Ur3vTXKJZFyozYzsVPoYbiSgjVbjO2tT8GQ38j5cPR9g/HJK5xw2sXbUu13Zi51qNuKGLmXSDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aaDBAflTCsD2zeMOR01gTBtR53M4oFh0PF5obk1a/y8=;
 b=NCluEiW5zV7OehvhnxOzeXBhMFebyDBqhaqovCnVrOw8lmIcFk9DyJFFm/XR6Bh49KzJu0UhK2KxQtH8C0Gc7qJbjV2k7yvfmm+Z0jxYmsURoyH+DR9zvTsKJO2Xx5Z4rcZ5Jzoz4S1nHcyprEodVNoFyTuDHmFGaV6+HAkKsi6KlgFKAIwmsQT/ixzQYZJqR3awdLltHoK12cvSygdU1Lh3FLtyaDb7alXAtt7gJTDJGgkRRNRDvSkWh4QtrVVo4bnDUeP396P9a+Y/Xf/qBrcWj30SQMo0RRYotGaSLxK6AWIjZHzS4tXf+xOUxplt17hmagBr62WkaiWzD3eYeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aaDBAflTCsD2zeMOR01gTBtR53M4oFh0PF5obk1a/y8=;
 b=AqV/5lXMrVh4zC6wojRLSgFHrJzhQdDuj4+5BH+GlxLQAX2FVpxIbLYRfzMVGr0FZfrdLOonvVpTHdvj4kOLkdWaEBn1dUUnDgtrer6L2ViqtyXXWdGf8L0OqJmb8V3wrs+qPNvJ7H78P4BkyD7R7hW3yv0t1Awj/7bYFIwS1dCz56rHobjnVpk4BKDfny76qeo0Rzdr4WtACXMpw3wWulV32BqolSGGQ7yQ8cB+cWYYYNoYoitJ39eGGLNbk4P3w1W7plO4y7Xm9CrHACo1RjcYtIGMdqwsKZ+7hwXBhT4rEKUD1TzU3zvsn1TFxBUnWmDPMXqb+K+fr05DYJgU0g==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by CH2PR12MB4152.namprd12.prod.outlook.com (2603:10b6:610:a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 19:08:38 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 19:08:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, Liam.Howlett@oracle.com
Subject: Re: [PATCH 10/13] selftests/mm: skip uffd-stress test when
 nr_pages_per_cpu is zero
Date: Tue, 10 Mar 2026 15:08:33 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <64282EF5-A73C-4D20-94D4-06D2377169E6@nvidia.com>
In-Reply-To: <cca7aee2b9ed290ed1ac231edf2c9451e01ca204.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <cca7aee2b9ed290ed1ac231edf2c9451e01ca204.1773134177.git.sayalip@linux.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR07CA0089.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::30) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|CH2PR12MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ddb578b-0f31-4bd8-c24e-08de7ed86f49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	/Wc8D2tHWNYla1F54bTaH6NsOx75/kSNKCrlUc/aTPk8lq2zNXoc6G0vCqf4pHuMFIZFeePlSz29uLwH4lexvjhnA8LTeoc/FcjDeW8UqYnjpn+nRpeVfFO+4Q+jHDZTIlf9dYoP2DZJXkkbXSUwEIMj9HqWGE070K7UygqAzmD2w9sDRjP04N+ykjtyp26/THzWOjeqmepKqWIz06nfzq7e38WsEE5D0+G8+lFSnQWen0Bglv4GOnlS0662EwZxWFS2nEuLMEGsySW5snEvtcUJQW1vi+t7nH8yY5zx4kcSNNV90pOZp4NPo4mjVv4394sgFAhYc+Qw0odHYQm2TrjtJAvCs+V3b8IpxWnDLVoqX4jYX9J8bYLZFmuNIJ6Cm7SXbKjRinq95hLTNQHgb8p1/NLEHmsj9UEggEB5RDSVRTLz8uFw7+3B2uiAITdNTsJVf4zN2e6xVloD5NSpL9h6bLaoT6z/4PuXdPFVEt5AoHECmBodYGfl8Idt0wwUmsUY7PSQWIAg6JJfzJWMmx09W9agQfzpz6L4su/kY8OviE94ySXbCJwNLSbxHIdss3vDmGjkSYh+Pb1xxoi5UYciLq0wNjeIo+v4Q+fwusHvYHxxlq2Xblrzt6xahYI9rF2G7O1SU2QW+TxvsdbMVPmS4SaXWRSh1G+QthuSOoB0DVMuoYYlvN1PwfaKWPmSq1ZRGjwrMb5p+Qc6W3NTHMMtOfgQXpe4cn+jZKrqmS8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2XlcQAH1hYj27X+ldfDHBF3HB3QOul9HM0c1NeFZa0a4YFh1qIl9SQ6wkVGO?=
 =?us-ascii?Q?8m0DQhGCNu79Gv4oMO7ot9Td3HwyzLSkF+HpDWtHl4TdMTcaNXlyBn6FuCH5?=
 =?us-ascii?Q?fQ5k+z4RTM9sFP+JN1EKHuXqMQvWw1WGGDdBP6EstVu67m09vROCA3e8hcBx?=
 =?us-ascii?Q?ZYhiXTzr+VdeFoCP4YR6SXrcqLSk1RK0JMl95BqEqiqoJNaiepBstmL8Df0s?=
 =?us-ascii?Q?snvYAn3qdn9CyjrvPwgnH2/MmWKMwRG95c529XQHFVC7vS0jyj3HKQzjxgAb?=
 =?us-ascii?Q?oymCIvIcgVucUHuerZ9ZPxjG9m91Mc/o9JbjAx28hND7uzkK3xFIypASY6+9?=
 =?us-ascii?Q?aUpQTMDUaA/Kt/TPgUGyRoY5Re6Txy9B5j0wyJfJ+IdIQM8LB+aEY6409+Jd?=
 =?us-ascii?Q?MLdmUM1HZGiyA+9UAg83ouUFpPsClnXV3+ZeTeuGFhXUkNhtRdPu45fppOw4?=
 =?us-ascii?Q?BOZDr083YQfevNM3qvVdOn99mDjcrW0sECecY7Cm42hilgcwxv+sVh84J9I5?=
 =?us-ascii?Q?io+9CqYLRzPQE1+UQCVbTbb7dTfm84D5/pJd3PHZ64fI6v6RyWwWI7aE2lv4?=
 =?us-ascii?Q?Uo5kJ7JWSW3aiIoH1csj5U7LjV7rwdE4EnDT7tp9ApgK6TUhZxRToGsODjIC?=
 =?us-ascii?Q?HM3bRNvZ+giG6976gJjEidB/B0BJrrj6e7qoyOr0kkl3hOSjIQACOdiYFS/Q?=
 =?us-ascii?Q?ojL43ovgCvOmXjAHfu2xwNZhihDvCCN3XfkBaCpnB3xjxflvg/cHWZ/cUuxt?=
 =?us-ascii?Q?wHTqxgwlE2dKppFJYJPDbNbASlEjXwErH7y6Ii7G1l4wIRIuIUo7UcDKd04P?=
 =?us-ascii?Q?hIn3RKyjxyJLT3eiz0/GqRhjDizb28dtS7epbk5ILaAdbsZkErYhvxB5+FO/?=
 =?us-ascii?Q?tzk+sL7DTcXsZvTIbRFcV6I9zqdRA0Hro0l8HVJcPtaBGoxvIHSbAxWdNUm2?=
 =?us-ascii?Q?5JE3oCJvKzADVJ92Ex5VnNXfa5dh/c2RtYz92xZxeHkbL2tYhgc+Ru/VFdQI?=
 =?us-ascii?Q?CtYCxBHmQKQHfSqur86+DV9qjt26EOYWx5vjb9GPIV4ZUAZbOxoKdQv7WMoP?=
 =?us-ascii?Q?ICNCvE0YX1SvGdQDoU0u5OieO+B65uO5wbJGXbBHidGgJTPr6j/p9yXB36S1?=
 =?us-ascii?Q?EW6RAZt3X0bQvuNGw2aJwO5Ia2haeOkQ7BiOQRYiPeCCY92oIWBt+lHpS/oW?=
 =?us-ascii?Q?/cnF3DydwuJDgSd7DJffwEhmwfnan1aG6injNMWIKBtQBu9SmxEv8Clf9t5A?=
 =?us-ascii?Q?Srlx9cb/om1t2zLhAVyJx7tEUbq6PMEgOg+E7w+R4qD7bv8mO4BzFmHeL49A?=
 =?us-ascii?Q?mi2a/lcLGDKd56nkPpYGSB/R8oob/bFlPuSIAj3jnn4jnmzWHLKTy4cNarDE?=
 =?us-ascii?Q?k/+lX36f5/PMpqYb4KDIM5nxJw3DNS30SxhYE8Io2wdx0rYy4xCbQ4PJRRS+?=
 =?us-ascii?Q?+yy5E0liiXaU3ydWV5FQQJFrkIpc+11cMhF3zBatO+q3G5PqO6FtdqIo273A?=
 =?us-ascii?Q?NqMj3xmbzCeAkNTopelLD3nG83KpN6R7gES/POIvMpUhdNkjza4EHcdVv2e3?=
 =?us-ascii?Q?u1Skl5GOJl1dF4QbVAh+6rLIbsTIhq6I5z5zptZWVC1U8HNFvkdXHVG3pkC4?=
 =?us-ascii?Q?GMoIHYzVL+j4ipTnq+Ra0kGrcbCvkQiOIqAnpmV85+PAI9xqDGTs6IpAfYHl?=
 =?us-ascii?Q?A0GoH3iRsKnLzBotWFk6YsxEZrnDJ8Jl/n68oZk/hcHTZUvcNo5vxNFkgTNd?=
 =?us-ascii?Q?GkzipIQdxw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ddb578b-0f31-4bd8-c24e-08de7ed86f49
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 19:08:37.9323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t94cOo/D/sZzjQq4d0xXVXsnHb41T7YyVgIR4avMODAd8Y8Hs4Rb6/aOL/mi45+d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4152
X-Stat-Signature: 1e58r6ozwmcjuir8jcjwsbtg3q7tdycn
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 0975A20008
X-HE-Tag: 1773169722-303661
X-HE-Meta: U2FsdGVkX184jSJb1UwQWu5uIFcNjDY+TMv16aiFz/uT81865Hw+nIffdPBPu4RkpBxKszTea6+PWwZJZctq9sMAYOApABVFNgnwPVbgMn7eRXr1MKyKhKQqnZiKsvLGRBudZufMqfXkaq6KqXGl5K5RPHpwipsu8nr2QgkdTAU/RtowJSPDcj54mDOWqsnNQE9/FCSpArKC73J73ZSJw0pc8u7syl9pseitNi4IinW09bde1ki0EygQRAyYFyyrja7DFAxgiglZug0p1pPWaJoH/ZLx4LkX5DHFO+IplxR1ae3j1nReeX1ggTMNFtXMSNX3dQ4OJ4ckGyJyY9dGMrUB7sOHMwLhsYBDfC5B7SNrNqU+/GYXnVpGlRYus5zaGegrLWq2qvUy1SuWUCHlm8+0os7l6eTDlK1P3MSkH0r5t/40JymeC1/u9cUQIzTJZ+NyT2vA043LzUbxY2OC0aMJSthB/gSYpmP6L2kJIL8HHEgUiQl7VRBqwSP0ooMuXYFlphGrq6DRLQM+HySERWA054nq6fDEQOan3hhR8Eobq319oiDsJcPnLRzURS0DSN5uRU4tB6sF+FZgME2BRjhVFEEU8H9Sh6oimdMwne13em6LUwaO67VRGWLojiwV4m71cmeylVhQuoMiIrL0H4aZUcs8mFI+OFNu5+VrAPwIOIJ5KITMVngmXhnOVFThBFk2sQXjAagzl/Xnwkw66uljKuKehB+J7W+FbAc779xI13KcyK8U4Ag8a0A36bvEwIsPSpCgF9wr7AunOnCEFniL8pLD1bIfS15ET7HsFCCgIbyqwyF1jJEG/vmbrGAcr8Z6n7Hd2qxWDTLsxsFnoxo8t0FCXAPwTtjSaJ1SqfPExL3+ZKppCX6OQBkh3M4zwtmw10XrMX2tjdT8UJ0SoDSi3ZcXee9ZMGCzHuKuulLSpGpr21aMeY3nJLKAS/+SerheVR+PGl4kxriHmTp
 V7atTwJ0
 A8BMxDIptrm1+ZAypFvhkcC8BT/Rtjec8yFVyIGvvx5pJe/4g1pK7Vt4hY1SfsCLvbmaBgzg/Mf+cnl9qmbo96I6mC7cL/t34t+L2oiZEkQxCS/SDmBnaVBDFx0f3EywHbWTEhFUUa9OKj8qCWdw64AZfpOhgnXI38bMQH8BEPIOKt7Beb4/WaeEsp1k28BsXdh0PN1fr8ALkIgJ42QmJkavMQatgpJMwqQhwQW/jwG03+t3EH6btXSkJ7m2mJjydAIZZ3zne39z5PbIVwxy/BdbX7W8+gJZCuJ6BK73eZcGSeVr0O0i9AzAi4iY0IwVJfJeGHRXW8XYFkbYa485XsEVj/zeOna+P2I5NoerZNcoKTQU2j9XakZSIGTk4rk9SGwRVRtdTJ/KU4YILlcbyZT0ogVxJS/KYaVJZ/d9VhgfawSyqFxcvRECn66qzkSEM6wkTD7UcQ79WRuAB1ovUiKNpI1VnbxFWbMCTYxPae017c49d/C4z+J6Uzu36QdPfdn9/4WVKuG5PpQzBO3uWOXWfUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 5:49, Sayali Patil wrote:

> uffd-stress currently fails when the computed nr_pages_per_cpu
> evaluates to zero:
>
> nr_pages_per_cpu =3D bytes / page_size / nr_parallel
>
> This can occur on systems with large hugepage sizes (e.g. 1GB) and a
> high number of CPUs, where the total allocated memory is sufficient
> overall but not enough to provide at least one page per cpu.
>
> In such cases, the failure is due to insufficient test resources
> rather than incorrect kernel behaviour. Update the test
> to treat this condition as a test skip instead of reporting an error.
>
> Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress=
 gets bad params")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/uffd-stress.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
Makes sense.

Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

