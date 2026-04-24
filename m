Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56200F34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD91F6B0098; Thu, 23 Apr 2026 22:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89816B0099; Thu, 23 Apr 2026 22:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0216B009B; Thu, 23 Apr 2026 22:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9789E6B0098
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:52:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F469C311D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:48 +0000 (UTC)
X-FDA: 84691926816.13.EE50F9B
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010032.outbound.protection.outlook.com [52.101.61.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id B8CD71C0006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:52:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Aih/lYxC";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999165; a=rsa-sha256;
	cv=pass;
	b=f4VgJ01jHVk/Y62fTm4OjciSUL45FYpgxt4MHmFq2si+JT8DaKTdCWh/imMKXqvm/h0qeQ
	osFEhZvXQSFmHY9kWQaKhEAaOgocPfys5i/YHyC/yijMLsjHyDxrN16sc2JP0nFA3qy3Dz
	X845+pyJJtJR5cVAtJJ1mvKPAIJEnKA=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="Aih/lYxC";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.32 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNxDzUAqaYv7oO0pbheEAqlVGsKkW+ZSFLS+vIIrA9M=;
	b=b8M7s80H53frBnS3zQppQyBB118eZkDpsySjNgWJ7XHMb+r2RKv4Wal3lCqwBYpgqChh+H
	IF8BsBMB6fQvWr2JljA5dNShPCLcMMm6LcNb0EK9m0paoL75D0YAcwmhha/lrbSaUpr2Wm
	wKlwh2aCPPSW8XSH20t6W43qU1ss7Q4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A9CqaLGTko3s3TFyAmfKFm8D8xsTSr89lElcyKwuEn+XJUqaKccNZM8NIZu1/jl1njqTD1a0FjjGYEi+DBnILeEJfMXMpslld5uukKmdx6fUji4HwdPXGOfYuv4EBemXLrjjVkYc+ddEMSQLBvTzvmQM9FrX1GCbE3WG2h5e4nSNNSBNQ9XMLkaDiin2A+viV7VgCzWwC44MJjMIqAskVXk6ZXQGt0iRssbTzclKh+Pks8NeODxC5Gsr5BZJHpWSgy0cOvdfzNleh1y7eTTPtNclBTFQV8oXtStFDlyyA4a8j+mq1Prf2BoXb9RI/lX5+oiBrtWTX6prcliUAyC4rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hNxDzUAqaYv7oO0pbheEAqlVGsKkW+ZSFLS+vIIrA9M=;
 b=Vf8b+S9wxTS5C+y9n0psazaxQoIwNpi/UbevcNoT4huma5E3tZOVeGFu56dKBbUwCJk5knpq6zN+0R06a6jlu6OKLZE8bhPZQYn+3Hs1TAVg+LEl4cRuF5z6eCQ8A2Hj5hf3uzwOhJJYkrc0AbNToWe+ADkGnLCrgjHAzDQBgWIxfImIamovVXcgcLWvE/K2ON443roJd9wMtaB1Sd3NO/GK7bB8vjz88nOipoJUmwhIhppN5B7rhS3ybo6jSk4D/NPA8fI7mV7P2wJZtqMphO/KgrXJf27QQZcQaHQ1QNUNQVLXvHkKPgUJWm1H3G7S3Snb4tEKPnndVuHQYInAEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hNxDzUAqaYv7oO0pbheEAqlVGsKkW+ZSFLS+vIIrA9M=;
 b=Aih/lYxC1ZxcjRJcQ3bVDBuUqqIWzFnimkI99+YrVCtZkU7pKDdTnXbz804FcXcv8L9u3Nl3kqdmuxF0UdOR25DzecVP6av6aQRUoxiBPxoCNdnF7GNiT4A8rUPeTT9lVwUfiefcCvx+zsjRT7wKGXD4WcVJ/zKZZ3moSK31cuF2mUKiwHvj2JbKg9MCZ0Z1l5wKlMwXbEcbpdsRf39tY9pcEQq9AUQnDvT54bNS8F4CZxGqewAXhVRBjgozSCuh6YSo6ayHoVpbOc+Vf7/FeW5NlI3Um7UjoJCB+lmtY3ezqBVNAyTJiloOS+emSmwtEbE5kul1DcSESqAOhNfwaw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 05/12] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
Date: Thu, 23 Apr 2026 22:49:08 -0400
Message-ID: <20260424024915.28758-6-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0033.namprd05.prod.outlook.com
 (2603:10b6:208:335::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f334f70-de1f-439b-0069-08dea1ac7e1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Td50qHP6a66IRxyZkLs/hnua6iH/3VKsfgFJDYp6iFIkHRHZ1MsOYVLb6BHfIrZ2LsV/Dnd6U4BG63lrSty1GOMzjnIqBxE6izEzmgLLGlXlmVVIMmU5pjbaogFyCu7hMqz+5KHbFS0lOET80k/ng27goMU5fAEoZ3RH9KnEb99jRM3XXfsbjf1B7iJLYQPPEYWR07iomXotCFeIZQ9W1P4cjN0/08QzM0gGOfaPLT/7nk1yY0+P1Rr+QMIMnKV9eb7jsKjhM/zLaMt+LpzVDDOTp2Rn0BZNKyCDtPIRpR0YhVH+QE/gk+5CJMZMKyEjUeOZ1Wc28oCHFoU87LMCwO3CFpueAeseWmaRNEHoG12ItyXC/7TV3YKAATwAc0xtyKezJiR8a5wze/Xwi1tZCqSp5JiiYhvpIENAUaRZDmm3AcFy4vlptXIKYPBgnY6Nlq5CEFPjdPFoFwcgahcWCqBAeMvgMge6gO6AHZqpLG46jMq3d98Be3ssFAV3n+HVzsbzYewIP+OPLo40LNa2RK8NCqfsx8psbkmLocl9x0bglwaYYGUdfnvWg5FljUyAO9nYsUznf1P0Jnpfqy8Jzjmq1pSmAvokrpHr2argDCjdC/WXLzK9gbss3qdLEoRv7YkTVoAkO4IJaEwPiG4qbHCNruwGIOxSTYW5Mua/kuerxQEwZnDrk0oHVWXNcZDn8+sqSRYS4ClyCpDWVanA+5ktKMJloJZTwvzL5trHVjc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/QeltMXTEUtam6VGi1pu+rMorLZHMWci1zEDUA8a6rKGxEEntdIORnXIaidS?=
 =?us-ascii?Q?ZPzWzHShNyy792VbXJjnblfA9FwEZMPUGhClZQybFTP3kQ6o073Iq7afrCJe?=
 =?us-ascii?Q?tuRZCejYY6UFBdgugK0KB3mLzXbSFX3XIvQyfib++aDpQwCQPrW7Xf3Dy5P4?=
 =?us-ascii?Q?ESz1YgDgmL4AZycyfsN7d1Ewb+xJCeQU3Op7fXikZG29qhL0SxNjYcoGA5tL?=
 =?us-ascii?Q?CNJFXQp/WGV29XnVtP/xbtz6NUHxUqOiXSrgaC79JBLGfeLsFv+9aKt683Kv?=
 =?us-ascii?Q?ZQ7zahi972vqBagPRDxbdAmRZb7sH+P0NTG/bXrzu02++GtN7hz3LmeKbHQx?=
 =?us-ascii?Q?zUN5BqcxJnu/lQSi6RM/9AMICHsBvzwz4oT5MpO0KYO2OipimTW3IMfk3Dyp?=
 =?us-ascii?Q?RhR86boIOAwW9kBHM5Rol0lDTPBxjdORr+jjwhyxJev6hqVWrLZh29N/bDEB?=
 =?us-ascii?Q?CdBnTtxj9AkPq15CM6pwvhR8/2adQZUnP/SJCrSkGav1cj+bW3m4u5nXRH03?=
 =?us-ascii?Q?ZEOCwxtp1xHgpiRRh8BRjCquO2T93Delda2ENvzXOl9Ii1O5raCiPqe7vR3T?=
 =?us-ascii?Q?ZzauCryYmYGxKIANKkmkJzUhLJc+1oi+jU5zFfz/i7WCV7y3B/9Dl7mzshY8?=
 =?us-ascii?Q?adaJO6CzawPb+TPHJEo9g94NVTfW5HEgwUdTdafcF5HstW2j6q8z49srTMpv?=
 =?us-ascii?Q?/dTZydshi0S528VQllOSr+slIyW/xcdKOqzIcbDbnh2hO9TLBhiPkO5kzd+V?=
 =?us-ascii?Q?Jdk1YL6T8myhtcrp5hYJRjNxORKQdC7rS+asacNj1+8xBUMTGA9qJTW4V3ik?=
 =?us-ascii?Q?TDeGpaqWXCiVuld1IvE0wKQyVmJBOYZY/+qzhOK8WVSMSppTjovJa2GTiQ5M?=
 =?us-ascii?Q?K6qFCImly6U9SMRrhTEGl0cQgh6vIqnOrBx5KewE7skiT91pdWy4LQIrMsBX?=
 =?us-ascii?Q?VM2n835+zhW24Za2j5IxePrHBNJ6XQcnJq3XjswenbhWuzM/4Om81TkO1Ce4?=
 =?us-ascii?Q?sxGLqQMTlOcK2KUkeG0zovWN12Fc8TFUoH3h73c1i2nEXWltg3WkIdWK1ENI?=
 =?us-ascii?Q?EPowMYaenr5S0lrWe4rK0ZlmwFBEnnrYfo6Ss11SW1LPh8GVNN4QtCHRYdUs?=
 =?us-ascii?Q?vz6WMEGa86+rER2Iae9Z/THzYSWMLCB0kYnAPkzdtqdRVCgQjB9T5hR/iHvZ?=
 =?us-ascii?Q?1M5wmPvRwcBF0xqRQGG4zlI/HPh/kqLAJgnkNaAiphA8IpFSfYrFLfy+O5gP?=
 =?us-ascii?Q?Ai0RGyBZQO2jVbsyTiTmHUVMcef61iVGOewS2r/WxjYgoLM316r4HHtFZ1kT?=
 =?us-ascii?Q?LHxviSc5Qhf30H4Xu12lZ/OS3axoNvwq1Vpw4arONTl9uz/eAHXoxbRi2j2H?=
 =?us-ascii?Q?frqDd9g8CqJMedkM3uVOZ0m+vtxUkbijyeT8cYU0MFhgvcd6R3V1Lnu1FsRV?=
 =?us-ascii?Q?YgUp5Xh37EU6nugeQKld7aLLpmLBy8Xt9EMVkPpuuGROcpUmbiw+EeHYO1UN?=
 =?us-ascii?Q?DBfbpFw/hNnH/++PE3+Orwdh+upgXKNFdv9fEtbFgvutysu4Y4dv0zPrXXFX?=
 =?us-ascii?Q?voQZleWmexFCfpjeYN53+GrF1lnTF5FExkICYrdaYn/GBX8zeEDVvY9ta4cK?=
 =?us-ascii?Q?azul0yI/PffudUEiitZlmE0tzGmH+Gs2lOtlmXgULKCny2a4l6nbMA/zupa0?=
 =?us-ascii?Q?xgEr4EJBfLrrtVEgxs4jtTybPoh6BZqqFNSAkhjDL7OJrjnb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f334f70-de1f-439b-0069-08dea1ac7e1f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:15.6755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fbPpcoRkPAhxgRvYiNYUrAgEmYK8+8oZrs4he+8Ui3y7iZBc2cDUx1yTg72v/xV+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspamd-Queue-Id: B8CD71C0006
X-Rspamd-Server: rspam12
X-Stat-Signature: qxu4w3mbzyosk9eq5qs18er39h3ys1xc
X-Rspam-User: 
X-HE-Tag: 1776999165-335421
X-HE-Meta: U2FsdGVkX18cagMtNAKn9UPbPQdxQKcnQJuOAe3srE/hciLeTXZaSLDF9UumUiMc3qq7oQ5GyvNf2YVPnqOpYpOYK3VCSUylzJsQIVIJjua0vjnwF9Pu7lQtptxD9GgGGI0xWX7eEom2+98iaSmIhB7UFZvbtXS4ntwPbiwbPDxuHMYE66tu33WmoUdp52VTZwCJyVUVsDnyIkOP/C8bDVTItoF1wsiFzgRGb1iYR6ZUg51Kq5zb8exOiAUVoEeuXZxfi+5kXGs7771O4r8OF8XObx5SO8yl38FCK5irHe6icI+huFMdG9Q6ttf7VYUKgJmScxXS39Ff7ISvIkbU50/KSxSIcGm0hPKDVmKjwWk5QXrgAASiIRlUpiq4CAOoOY0yAS2vwq0dRjLRyVRFjar0TTVpcssEoM3GVJtbbHUr0CQ9EXEXWpGC2pTLIFWS7PplzIQOK0owyKSpj70bqfm0sVqp8rvB9Z4tY24bPlAjRAqHVM/1yLkCXNUA93j3WNPlntfKWLFgb2CUbGi9qShsTkaXbPit46wPOaeB71JlB3Rm6foFbUvYzfgZTrdSRvQh9uN6nq1RwPodHdU7QLCS8RAHC43WemZWFzBknUcjsH565kVAkdL3O+ymGRnetgRXtFo7R1p+J4XtZLOV3Cj+U2WPPQy0w9dY5ouB6aTTVCGNfSf08w/tUhWRTFx2VRYfuGfV/jtxpw5/HnsZMRg23WDoHVM/q9hj7caz+aLqfQ9f4EItxvqR6BPiEh6hP93atldun29tRI1VCpLyntnNOK1ug4Ot49ipt/Cm67Qdj6nXyOVMdgexR/fyHvJ4TlTtBdkMsU4GDBwGdYYc+640Dmp9uoZLFOTyjlqD+C0swlgLszawVdyJaDIFVyFat3QQO2mXzG44ue1srdL+cxa8zusXX2EU5NwaAQ588KGVhAHqhU6QvtyEe4boycZCntp3oIs+NHDbbLWOY6I
 PnQ5CZnW
 HGDoDICIeCeMpIOOGJS01JNSld0xKEZJQdW7hgxhyT6zh6JlAbz+WfISXBFXyAGQhe+bEjx8H1zYxZ9yyZNknqY0c43tVzvzqtmtBiyBBwvX19mxmgIH5HkiV2tVjSfvRkYo/++AH3QEfsFyc2eFxpNBZRgyBq28TZETpoLXRqdSGa+B1XrEJyNwCZn0yGtB3Nc/SDXDhKaclxVum6AOkDYYaZq3pPggPPJsM0vsLN+GsnCsm44x6+c/4qg/w+PJ+zNwdybFQIArYh1JepJ0pTCXetysSrCmAz/5REX7dSxigvBU/1r89uYwvoebXzvocjwa+6V5kswc1QEkvP3brCSmgOMBoKZ7s+TFrKQ1zma4kNzbMonRKB3AdOX4gOJQDaOaYgOMpWOt7EKJVZGO3f+yC/0Yc64GVTrLjS7A8yQN4EH5kuEtGixjIwHo3v9ls/i50EpTLjOOfuztpQMEbvZD5VUU/HwbsZumj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
mapping->nr_thps, which its safe guard mechanism relies on.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/Kconfig | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index 0a43bb80df4f..fcb6ebde7e29 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -938,17 +938,6 @@ config THP_SWAP
 
 	  For selection by architectures with reasonable THP sizes.
 
-config READ_ONLY_THP_FOR_FS
-	bool "Read-only THP for filesystems (EXPERIMENTAL)"
-	depends on TRANSPARENT_HUGEPAGE
-
-	help
-	  Allow khugepaged to put read-only file-backed pages in THP.
-
-	  This is marked experimental because it is a new feature. Write
-	  support of file THPs will be developed in the next few release
-	  cycles.
-
 config NO_PAGE_MAPCOUNT
 	bool "No per-page mapcount (EXPERIMENTAL)"
 	help
-- 
2.43.0


