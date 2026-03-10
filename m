Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D933FD4F19
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6CC6B0088; Tue, 10 Mar 2026 14:55:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7945B6B0089; Tue, 10 Mar 2026 14:55:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B8C6B008A; Tue, 10 Mar 2026 14:55:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 424696B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:55:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CFAC11A0253
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:55:03 +0000 (UTC)
X-FDA: 84531055686.10.E608AD6
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by imf02.hostedemail.com (Postfix) with ESMTP id EEF238000C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:55:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kb+4giIT;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773168901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMQDqjJc6jpO0ZQtuvjBAeqJ5kPvnRzLtoivP0vdxhM=;
	b=rsc/e4RhdIKB+jzRJdSnARuRNGe6PfowyIq+GdkkxYnfbzItNeLXFyzEsrCg2YzLtrC0pn
	5L3dzqUHHncmq9ls1A6wP/EXBe3lSWw7V216Ohejjw2iLTgDe1MX5ajFIxBGANeAQTsMz2
	JYH+gxPF5dUsYlHUR5hrj4NgmcnBpVQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kb+4giIT;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773168901; a=rsa-sha256;
	cv=pass;
	b=SIsAUbXpjtl0WowuE/giabPnYkB6qO2ah2pRDOTwqDjfA/Wnsxr41dnXvLrzYEDWSkAF61
	NX7y1V4ezp4ORWE+Z1jw3pO4lykXHSIJeX0IWDRyoq8BzvlKMVJVO1SLPNwEsMgDZ2vX6v
	81pGMQUuojQnZlx75GA1AmqMcjm8Gdw=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HZa0CdFo/+d9vbj6QwTfFPduOKDdYc4t/NxY6mY+KyEwHgJN9nO3JGHR/kYTFhA0k5zl16VWXVPJ2BoJKDNFNEpjP0KzaLbM/A74u2XANKKIqxRds3Aj22iz7I+jSlPbrJFdeeohJWq51amwba4WZaPQO9qVDEpU2IrfNfbMjj+BK1OxJqr4EEQD+hRVocKey29uXyn+yXIl7T/AZUzPBRyZxy++vY9SitAfZ/MHs7sj6gswYbwxqMSfUFP2ZbrfFd3V2TxUA0/qRb730hV8ZY78eZHI821UrmIS8uac7weB6+Us/Gk1zGqTfwV0JN1aV7lsoxpnQ6YZ1sxPBPnVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QMQDqjJc6jpO0ZQtuvjBAeqJ5kPvnRzLtoivP0vdxhM=;
 b=MXBLUY9qEq1ztL2yz7Mz2EIxXxSgpYo+/LgAdPK2LkLq2LKkoEDUhss6WjoQSZYu6UjoKKaiFn6bzaA8Isn14xeM9VTljXo3zVaQfCaQsF3Q57tdypnF2VsmALbPFxYWkECxD9qLDSfZCC7MQsDW031OLMw/3SytReh4rCzaghyJQiNUXXNMQUd0G2QnWnTWY6zaKUcleqiGae3EGZQ0r/+fp1d0QSiGLyfNomZTHHeSsN+XeT6y851bZYPSWohzFSLTd44CmJnSoaE/EKCXsRuHHIKdeSkGrFnWXbqK68UcBcdufe0TMhBPQ0Mm/v3HMeaIZ6xe93CxN3Rz0hcczA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QMQDqjJc6jpO0ZQtuvjBAeqJ5kPvnRzLtoivP0vdxhM=;
 b=kb+4giITtY3TRPVZ2td+v+Ue2JgILCjXwNS+cpd6lJb04dgEqCj17GJobY9dJRHo64+B63HOETUsuqqkbSVMGGQwBqF1WKokoFdrvzWUzYlFPV2ypFFVEUjA9cmlgs38UBgUjk5cEDQz3X/13vCmb8zsbj47DDYqyrjR19oUDblSPe8dufSzbjAto4NfuM7gYafx7lWUrWVjP1qDyBWbkLRmz5VBXGU0C2jwL2HbRfAKcz0eWbvnxt345pqEhphef6DyUkBXma/hjJPnkKHZFETlyHrWp5HOZ4QXh0h5OAWS8exMxpjr8Z8/jtNYTgpvXl+kKxs95BXQMyJy1mYpaw==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by CY5PR12MB6431.namprd12.prod.outlook.com (2603:10b6:930:39::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 18:54:56 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:54:56 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, Liam.Howlett@oracle.com
Subject: Re: [PATCH 02/13] selftests/mm: fix hugetlb pathname construction in
 charge_reserved_hugetlb.sh
Date: Tue, 10 Mar 2026 14:54:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <499ACE91-4C77-411D-A200-8AD55020BFC9@nvidia.com>
In-Reply-To: <c0b65c67b24d67fd3bdb21dc35d86fe01a21b576.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <c0b65c67b24d67fd3bdb21dc35d86fe01a21b576.1773134177.git.sayalip@linux.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR05CA0083.namprd05.prod.outlook.com
 (2603:10b6:a03:332::28) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|CY5PR12MB6431:EE_
X-MS-Office365-Filtering-Correlation-Id: 64e859e8-ccc8-4324-cd4b-08de7ed68560
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	gK0TmqSj3yQGk7elr5vTce6xp/WExYIgpRqOBtNslwNWpbNsWUoXsU3M/d/Rm/lxh3TMIbBAckg8rGLEYWN6mM67aj31LBZrJkL8nN38VKDApMTJJrBppCTI22Di/P5k/ety7MKK2iPRdojq3rIKrGgXM3r6DOUuDvGdd7petbqOlC2OZhtRFgrpIq6PfI0fyJPavibzG3ZjgCZkIBo3x2+XXgtBw29E24CbqtcDW5/12dWRPSh+mTKZAb1me7ZZVtCiU3CwJS3MDeM3MEJHtmKYszEnYW3qKusU50mDRvnknXzKWEXtmMs4wPxDid0+FFBo/LQhJCL0KILHzfPt+Jr8DJHFhEbNZDvPM8/yoQqJQmbB5XKGxdfG4y1CYHH13G9Y1PmTa+ObKSm3GyfXgHKtBkm6E8XME/GhDddB1aHzK944Y8OgC6lxEaa79uODTMTpkcjiiTTXlNgW/tgh26wnoYxcWmTL4islSk7UvSGrNMSr1m81enGSgqBjnOPZSEPDUTn4W9Loo/KDoOflRfAId6zuIfh75eDA5F3YvKFMCf8mwYT4nkJB4JXhEeqkM08UeKMGPgd3Eyc/26k+ayZQQUdK9NAyBx6deYY6lrglZjYG7CktSuHQ6/QiWMMFb0KqRvGfuKlmCDKiRwXgSCGY23LXGnv+PNCa7oxAUoGM1Q6JNBEt48MRJnYobVp0aq0ZVaVrkgHSdGchhQezcjIEGk5oyvSQY+hNmuMqr5Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AXAHHNsnQWsZs1/bVWwkNOCrIjomp2mna+TWTArM8iP8hBgAuxHXFJY1VgmP?=
 =?us-ascii?Q?rAyhZYKAjwlo8OxdXpF49Y4YaSTdJRwuw2mK/v+Drdcao7akxQjOcWnjIN+V?=
 =?us-ascii?Q?fg8PYmSvFJZnu2JOf+dhpzB0VkjvSHRJDuXOpucix8xRBu+GmSXoF9SGJn9B?=
 =?us-ascii?Q?zroEZT54iqdadgprZ6uwPplAsCkVIbAlGRwmeYsd+RatES1wTwABwqYFjbkb?=
 =?us-ascii?Q?zggdFz7BkolVlBQfWcvt+Di4LneiCzoWYczVocBAU4rsssjync6bV9wAsiHg?=
 =?us-ascii?Q?EzMSUtmJ9jvK56V+24w0Tek5abS36dfSIQn+C5wPjnXY2DD2vGfmT8z0JM/u?=
 =?us-ascii?Q?gnxsyuGvCUtomH70Bvbud5vVutlvcPcxtaNF5cJb06Qe8ku4j5LX+FcIIm4G?=
 =?us-ascii?Q?pcSIptbQMvu3UnqXvlg+RHmTtNAgUUSqsYM9B5F9/VikSmrhYuoSAIa8OugP?=
 =?us-ascii?Q?wNKe3fZsYFkY3WLiFIUcU92hXlPaH1UwFYCsblq7M86wnRfkGuxBDDULf0tJ?=
 =?us-ascii?Q?n5ESP5KVlp69S4pqi4mEK86rLAXW5aHnYfwOg2YB6+YM3sO/GY2iB967McFI?=
 =?us-ascii?Q?7ALrMB4eSu5IbVdNhdKRu93zSYw0y+jHZ/3Ol+lkw0biXyeIViCr+7Pkirf1?=
 =?us-ascii?Q?s6Jpb5GWebWwjISm8hr4DVqU4Gs+8yQFd4UL1BZYoJgwSCPADH33H1vwDsJi?=
 =?us-ascii?Q?MdVwS5BW/J/HeUFhl4t17CR9MIMIMebFjCewMwmx0k5hROaK9vp2P1XFTMnB?=
 =?us-ascii?Q?HOCKpGgHPftgTSA7ggg1D2+vc0Fk2yR3UH1RdJzQnMzqqDQFNBsV5nYZXWTn?=
 =?us-ascii?Q?VSHsCl+fsIbXilpNuDMjzKxGjv/5RtF2FaeVnew/vB6ZWFYgAbbU/CpJZRm5?=
 =?us-ascii?Q?MvjyP1nWmLWcSG/ZT/c3wBXWE9WdgYXHBfYxV+1RIZI9q7F+r6nKTuuAOKV1?=
 =?us-ascii?Q?Su/yiVmmvB2tZZNeuOIb3PdeZN43sgl4EBkezATuAJgReF2F3KS50jYjrBQa?=
 =?us-ascii?Q?YZuwdI6UqLnriwt5PtbhfK4O71FHJEej6Du013KTr20dm6BCgZL6kaj57Jeo?=
 =?us-ascii?Q?zix9g7YkhfPUpzd1QVDSGQGnhoERmC2rw9CQ5NZJ3AAU44CZtFD/gn05OMeN?=
 =?us-ascii?Q?F953AoOuV9NvVrjVsJvQVyTP5PZOhU4gJRdk/tFrfAZVxqIb2F1OShkj/9YN?=
 =?us-ascii?Q?8eAuNaVRK7ja0q5XQK7EhkCOBayy8+RNUg93z0/kAvuZwjQHglKyRbz/Us6C?=
 =?us-ascii?Q?UV0ONJsIN0iLjIMy3ebBNzsAENrtc1b9NSuNLnBH7DEJl+hFzm11qeXyV9Xy?=
 =?us-ascii?Q?XQSSCiH8jLy1BCraNJ9+m7Dz2ki896SI9PU/ORIx/+ejUjH/X64muVy0+sOG?=
 =?us-ascii?Q?HRT6YHiCCYT/C3DKbo6R7IOxAz62zh9DknN1lEzeztI3KTeoJLcoR29wFNqq?=
 =?us-ascii?Q?D5RRjBfm2OjHzWVmwPb1nrAAbMHWEDX/NMRlXUA8SlATkbnHWTXzVHZ1P2lE?=
 =?us-ascii?Q?Nox+tv/58Yv1EpR8RjNdYHLAryB28gdg7ADV4UXYLcLo82zj4J5I/jmFCeTK?=
 =?us-ascii?Q?biu7VsCQ7byjdn+jTMS33p/CePezLGXh5WpV0b4cXMOM8s691AnyDBFTnclb?=
 =?us-ascii?Q?K415JTdTxBNBwn68CQrs1Ks1QcevUmlI6LsNV5OWo7B8MsRrudf3uY48Xarp?=
 =?us-ascii?Q?YmiQ7XVsgZKjzss7iEidzH7gXM8lHIzPMcS5vulzML+Yqvam1iDipTOLMwfM?=
 =?us-ascii?Q?qgM3bcw6/g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e859e8-ccc8-4324-cd4b-08de7ed68560
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:54:56.0629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUzOprBNEsufBrD/u4DUCI37dRUMP6uCc8cdT/MbquwUGqYbDyyYjkb4h5cUMwB2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6431
X-Stat-Signature: jquu8xi7dhfuc8suaraiarhi3u5au9hj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EEF238000C
X-HE-Tag: 1773168900-644315
X-HE-Meta: U2FsdGVkX1/V2ykL2E2pKcnnaTqrPsffVfOevW1DRMumBjE5rm3JX4U3Stmm/eCfLcE9jGltBy36orXbPRaqEIobLu/cGjeSDFPZ9b9Gr/1JwDCHn04xYpO5l3PAFgQDGqs+4ohFWvlwAiSmd5suZxnSxYQz3jzTxQbhWhsmHvTbb/vB6ZnvcibpeCgyKokz2QJDgwEQw637aKvLNKaTJ3zaCutnC8PRomXtsK1cKClQmgOwKbBqDXKPM8WzvrYLUkW0qc6SZSl8hX+8/x4d8oHSPqH4V+Sugh0zR6tQbUxBPWvwD4FSN3vUg2HHDYBhNtRJf6PtgG5cux0HP/KxecxKvmQLo3rn9/8l3r7As05HWrg15Wa3JQK8yE6HgB7Re5uOTG2L9gVLMhaZt1fu2e7SjJbsGzklGjVQ9orhzqec8QFlZmwUUosF+9E3NHNEzITlJokuiO5CVfSfRtsPlV9IBmrvjzkdicqZBPTMxw/sIKreIbAf+CJ2Ipsy3bXMU/B0bQ9qlvko4yNxLJVPXDRQzmAoMusiTWZWf9LjW737tc9j9lbKEdi+O7NmiIeTodx6FDSzxgzkPfEdC1BNHTrO9i1zPQGEJlmGkQ+tzh9Hj8qTEArLtwtgEp2JW9mLbO7CqxK7y/6plPhTOdyEevD+TyzoulKdekGL97N8H0yzwk8kE2E5u/M33D+zLdJgg0hz/NN5SuMTaha2iE196I0N8b9U4Ks7wYDsW+xmlPzifTQuiR5S/K7C18QEoYSkXjwuKpeUChGYB6WXZuoNJSeH4RcH6E7s1c41/tYZBf9GBFBJGFnPzhA63CSF1CWRdSONgS3xeVeJN7f/jOntcBc/F8amvsu6RhcsIu2dUEze4h7Vs1qFxJacH5jJQmIJS22iujSQG0IUkAJSEfhpuSidyAwPetEuu354P9JE+iT+8sGMQt+J58nuhxHGOJATD0NxFpCmES11e79Ps11
 mlVpXKfe
 ZYSG9aJkF650rqGRahN3TSLCZGwCP1Jg1FIt1xwvWRO/v43nO/osKsZ5lpzLjkjHGyMQn7zEYRh0Gy/Pkz/5xA94gM61GOORtHF2kuFRu9RLJhrqNvMfrmYP5edGLZ+3bpRj7L5qYNq+d0v+RHFpLyYlM3JkTamnN0f2hEIWpNlsrXyKIFgxa5cMOpb74l0TzBUCZO1LIDvtLD05ps8ux6jODYU9i/SK9P7ZXG6Piq293HA6MfQmUxV+Ro7mblD0hDZQCYsoO6F1MzoDiAF1/by5nlINUibQF5qQ8DLnyj9lrIIi6Bo64L7EBnUWd1Iz/7lG3HiACgXsLuuobJoCF7RHvXBwIDjkXh3xeJGyNAcem7ZvozMo0u7OduveUrlRsT+S03JItH2x7re+wP4EB8/FbVw1UoyvX2ACCe7axObvMufjvWmAa3AN+Smf1nojYylFE2ed5x8obpnqOxpouxV8Wg6tobR0AKmkehS5FhKxUOxOL2WCFT6hirdDa8Qgmc9DM1UVbLx46BfdqNo0wGxbi7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 5:49, Sayali Patil wrote:

> The charge_reserved_hugetlb.sh script assumes hugetlb cgroup memory
> interface file names use the "<size>MB" format
> (e.g. hugetlb.1024MB.current).
> This assumption breaks on systems with larger huge pages such as 1GB,
> where the kernel exposes normalized units:
>     hugetlb.1GB.current
>     hugetlb.1GB.max
>     hugetlb.1GB.rsvd.max
>     ...
>
> As a result, the script attempts to access files like
> hugetlb.1024MB.current, which do not exist when the kernel reports the
> size in GB.
>
> Normalize the huge page size and construct the pathname using the
> appropriate unit (MB or GB), matching the hugetlb controller naming.
>
> Fixes: 209376ed2a84 ("selftests/vm: make charge_reserved_hugetlb.sh wor=
k with existing cgroup setting")
> Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation te=
sts")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  .../selftests/mm/charge_reserved_hugetlb.sh   | 42 +++++++++++++------=

>  1 file changed, 29 insertions(+), 13 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/to=
ols/testing/selftests/mm/charge_reserved_hugetlb.sh
> index c9fe68b6fcf9..6bec53e16e05 100755
> --- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> +++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
> @@ -89,6 +89,15 @@ function get_machine_hugepage_size() {
>  }
>
>  MB=3D$(get_machine_hugepage_size)
> +if (( MB >=3D 1024 )); then
> +        # For 1GB hugepages
> +        UNIT=3D"GB"
> +        MB_DISPLAY=3D$((MB / 1024))
> +else
> +        # For 2MB hugepages
> +        UNIT=3D"MB"
> +        MB_DISPLAY=3D$MB
> +fi
>
>  function setup_cgroup() {
>    local name=3D"$1"
> @@ -98,11 +107,12 @@ function setup_cgroup() {
>    mkdir $cgroup_path/$name
>
>    echo writing cgroup limit: "$cgroup_limit"
> -  echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limi=
t_file
> +  echo "$cgroup_limit" > \
> +	  $cgroup_path/$name/hugetlb.${MB_DISPLAY}${UNIT}.$fault_limit_file

MB_DISPLAY and UNIT always show up together, maybe just use a single vari=
able
instead. But feel free to ignore this. Anyway,

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

