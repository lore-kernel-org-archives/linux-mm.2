Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1EF8C624D0
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED44D6B0092; Mon, 31 Aug 2026 11:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAB7E6B0095; Mon, 31 Aug 2026 11:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74656B0096; Mon, 31 Aug 2026 11:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE1C36B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:01:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ED08A019F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:01:26 +0000 (UTC)
X-FDA: 85161878172.08.AA40E72
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010067.outbound.protection.outlook.com [40.93.198.67])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7CDB41C0003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:01:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hx0M07h6;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788188483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j0f88eQjYRrTIyDNxYOVNOfrypzuDH9b/DFJgRp+iP8=;
	b=zplQKc2A7JjLG+GNhOntEzooMwpuoenyDLl0fXNRtOYr/uPqrmYVco/FhRQIQbL20IHqK1
	P3DkmnnNgMwEX5YVZEMt7RJmdMXg9E2h5RnnYLZ3dDDuR79l0ZPkLQD013E2+fL7NgTzgd
	2U3PSLDVgmpShNf2XlTSpepOWcQkxq8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788188483;
	b=8OCwn2Ey3aAZzpH+uxsIUfsIyh3Dr9+pnT2Su/2e7lYWQ8UB8reXksB0ydRKqmdxDByipD
	YJQOwlkUzLhgjtAa/+VkGRJqdStAAW8Gabla0q8CQheGaBboMdjS/9Dl42OyL2+DFHqMOQ
	arQ4ne+oy9b6ewK+H3K0OQ7TPcrYWMw=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hx0M07h6;
	spf=pass (imf18.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bz7FYEtgN+CdHS1ZjfdBker/StHTbcm/l18z2RZgxeekxqrhzL0rey7ztnJs1GPB18xH+2ESnpfR6+2NsuLJawrUIN8/fYzEMMMGuArUIcEdwcbn09MIkPhpFEFW1NqEt/qWB0KOJjO+JSNC1O6G+oveRGPe5Zjsktvo+CI8iD47Mm3yR2hGnJW8LxhDWTGluTJ+EZyGFVvECIF3LmMxc3ezO03eujPJysG9Y7lTypsP9KftnEaW/q0n65K7/MY9MLKK+EOSy2VeloVicUtxtAUCiCZ3ism8i4R55C5ZSMU3gLxZcCrylz2EM7A1kghRX2j+5ebRSpCAq8KTIOyW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0f88eQjYRrTIyDNxYOVNOfrypzuDH9b/DFJgRp+iP8=;
 b=gW3FmaHjIRJJjtP8MwusJ5chZQ3p15fFnrV2hGrnQDEiyrxf6DNSPk2NWdP/LVqqwNWAOXdGXOZJbQM7ExwEdbNTcnPercSOZ2lWSKEPDZErIXMdQAZehc6eC02UCuVoPwT/nkKNVUpmkQ43PGa0rTPfLTiZS1aLjTQr1baIcDPQGe2lwvSdC0pZFbqtJZzTBr2kMwhQ46oFLlRr8kZ14GR388kTV+5M2PnDkzs2XMcAmjJ2gMgCOBPnc2UlNNXjMrpbtMzmNhpdp/dgLcdtWqzgIIJB4iZWmrlpCkS4yUSqY8fmaej1aiwOCenRSapO11NWbnX4N6eP4mtuOfGKxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0f88eQjYRrTIyDNxYOVNOfrypzuDH9b/DFJgRp+iP8=;
 b=hx0M07h6mxytCq0MNZjzsTVrId8yHYzg2oDOr2UlcJ8EBsgqxo/0hGpzg1rNeAqwoeHSuyKRNRuFowqnIyJWaxp/JP/P9oXWM4mVTzqP9ZJzsJCo5q1xNDsppBuPKVsAdp8rHaYyNAx1y4UWvHtNZP4GSfKmkQ5nGcJBSjo8olit4Z0fkepuJKnj4lbdI+aU7gAwKbTbzDo2Fx4K7DpW0Ufo0lZRkvPbUhILMUrzMNp8bdbmcWgiQaoguxjErmRvWfbiFrQwU7CLI3SlM3n0a4PdodYlb1WL3w58a3rN+P9SE4g5uGRNjEVgK/7jElF4hwUKlujGcNwJ0ef1ydInPA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DS8PR12MB333896.namprd12.prod.outlook.com (2603:10b6:8:447::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Mon, 31 Aug
 2026 15:01:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Mon, 31 Aug 2026
 15:01:18 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Nimrod Oren <noren@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at 1
 GiB
Date: Mon, 31 Aug 2026 11:01:16 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <28FC994B-F63D-493A-B86E-F87E37B303B1@nvidia.com>
In-Reply-To: <8411e51c-92fe-41b0-9de0-e9cfc5a50301@linux.dev>
References: <20260831075635.2244437-1-noren@nvidia.com>
 <8411e51c-92fe-41b0-9de0-e9cfc5a50301@linux.dev>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0254.namprd03.prod.outlook.com
 (2603:10b6:408:ff::19) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DS8PR12MB333896:EE_
X-MS-Office365-Filtering-Correlation-Id: 400cbac5-27b5-4248-e42b-08df0770b61e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|4143699003|10067099003|11063799006|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	WN5iLciBRR05V3A/UbZQ53kOQR/b7j7tWKouUP5M+0D1fFQPCky1yddCGtoxNQxj1+qLXz90XodzDEybM9dOiFrwxlA6GXGEspOuYgjbYJQTsYTSzkumbHenu8y7oUC6EcOdcjV57Ug7+gr+qyqqCF5DjLjsvPE9KQhEuwj3RSueIrneM9CwrptnpI2LYOucnB8k5BONJKgN2/IPLbHw5xn7JqQdxLODdBuexK9d7M4NcvNps0fnebjJuNCWz04tpV4NP01Qb/KpLMJDoy0m1ADqf8qeW+hTqKaC6szp5XfrgGhoGkub/myQzSHqeeZsBjqcZB5A0XSbyn7KK5MQfS8PkKtdKKbwd5VYYEfwB6bvh2mZiHHEy6W3lObX3wQMkxqsecUrgh/Mhs2nCbfkauLC1xXo21UF5asNctIWJXZSSn4u44N5GiJLX20J2E1OBOF8ChlPvUQovhCKI6v1lj/0pSM+NEEkSTAqjhWLWHXUWlzh303AovUCZJj0+eg0PqZSXr8Bk9/sUC/I2z2vST8QiKBwT8jTzjJsFoN7HPjwn1mzRNgyqOwSEL62tlfsAGkjmeRNjdDqYSrp7Mu0TkWGe5tQrCdAqqqibfaI8bc54f1Ig2mKR/Kf999869U9+xbtBCxNt1UxGmHupzGnJ02gQLqytTaNll3JTCHO1vc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(4143699003)(10067099003)(11063799006)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kXA3+4wByRiGFgm+IE/eRRe5mr14BVlRIIQEP/ASQdb4gHSO+c4u8Maf483b?=
 =?us-ascii?Q?WTvXYiuSTp3FQ3MIXFQAW0WuhPeDxufqcRam5Edij2XWiShpaHTW3soRP5+m?=
 =?us-ascii?Q?HcIqNFGd9uc7GbCyPCp9zztflUK+eGu+Cv+r+Yr1NqQvvuBjazijM/zzR0wL?=
 =?us-ascii?Q?e2BFaNNFqVbkFA+KY0P0vHxjxpwpIW7aSDaM9lkq/Tc3MzZabC72fsfVIMg1?=
 =?us-ascii?Q?/VqpE9MNOiMucPmUfsSt65m7X82WhppyCUxmzUhA6VYpzEeinuQFdJ5KbpY0?=
 =?us-ascii?Q?WZw0kXRTcbHFe+scdhQJjaRQfG8kNUOBNw7DhKG7CafnnR9uvHTqDKFVbDOC?=
 =?us-ascii?Q?s72xPo72R03gZAvSOPfstGBpPyETcm5tb/X/vDbnorSPj8HcndOxQ9Mfn1sX?=
 =?us-ascii?Q?QTkeXghkMVoLZiV4a2r+YL8E0slYvsWWMD29r57NGLDoXXZdCU9jOveSaVpF?=
 =?us-ascii?Q?juuKEiDEQSW1vvFv1muA+Lekr3KFUz5wOvyBTJmArM1kNf0bWnX0nJrlhsQU?=
 =?us-ascii?Q?/nPUUsC7003+/OJ6TUOdY/rXBqyO96ZaDU0fKzPDTV1X2chW6CAQsol4dhY7?=
 =?us-ascii?Q?RDOMbEEm5Xq/OKfsNxkNiF/5oqVfG17u/myr4RpWTunm0yC+U5Yi+YOB9+8T?=
 =?us-ascii?Q?mPnkSa80WHv1/3U2DK5KW0RShec2KNHZGbHiyzOnaRP3ckm3QGqcbtLDOlo9?=
 =?us-ascii?Q?VOog5d4ePiX7SuVlwJ+vqixIk/3oU6pQixEoZdMp1HlD5+PhTk3nQmVk8+o6?=
 =?us-ascii?Q?DyUt/2XsFudRwjFcTJzn866mim3zbdN1WdtDxEYo4Rpi+bYd+HGoy7B7mpUj?=
 =?us-ascii?Q?xUYpVriHEWyT1NOVdUMWO762jAw7uKqnSV/sMO6o8G8HJvmce9CMfGOfdrek?=
 =?us-ascii?Q?t50CQbUx49SM9MYBROunNo0ewHaJJbPFWDeslsSHNe/l8AJ1M5tV+EE4fWXF?=
 =?us-ascii?Q?nbugbTTw/7CSeWSCUcINJyMlNbNG8MLZOgOOOeYo3vjFMjoFLY8FG4ZXNjGA?=
 =?us-ascii?Q?0IEGf9YK+mVk8zY9j/bcUUh47kdtz5NoX0Vqc5mlfFE/1K7JA3laNa4NRqTn?=
 =?us-ascii?Q?QQ0RlteXxpSnPcxcPjLwP7sHaAME8zaPCmMP+m+G9kQIuakW1HC+3EZoWO0Z?=
 =?us-ascii?Q?6wSPNBvVNN+gtnBzUmg9UJpvoxujmuP0IX/DJGTIQ1TXHuTIF12107W1pPf2?=
 =?us-ascii?Q?yjomAClB3Gl0BdWoBS+eu9B4fdqDJ5O2QIdSYoM5QYt2C/o+83ImcJwpCjBF?=
 =?us-ascii?Q?PpUQ9Q973qG4ZFqWkBcslhN2SL/I5YQJvCG3ZqcYW1nZa56iaqwjqP2lltxn?=
 =?us-ascii?Q?JI+xYKH3CJbP3vyZ+s2ZpSyB2tXuQNcW6j5RRyLQxHfAr7u73EJHYtc03iPV?=
 =?us-ascii?Q?gRnnB7UtkWeqrVS5RyrieePw5/1i/VO+5LqCaZew5ZeGpFIo1K+8gZgx9YeW?=
 =?us-ascii?Q?KQf3QNUT3WWwUhQjPC65VonmRz0VkUNUgvfOClM9a6i6KD/pgLdY5s9DAQDn?=
 =?us-ascii?Q?VkrAEPkx+uAMCi0J1TMHS86/dVdd2kXJ/kCYSeStCf8kJutF7DfdO+zeGVgR?=
 =?us-ascii?Q?WlyrQpJIr9kHR05kiudG3EWV6CRgWqzm3x9qefdlX44M2EzLhG6UGi/BZb7Z?=
 =?us-ascii?Q?5Cr0Kyg8QM0zj/v6DOAL1Rig6JZDPznZHLZ9EjVYBHnVpwS0dEfXD8VyrP6R?=
 =?us-ascii?Q?0esmn8/Plz9MCWsCJzlcX6xnralFWwCIvuRWc+57pD0cw/HZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400cbac5-27b5-4248-e42b-08df0770b61e
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2026 15:01:18.4948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zvz67CQUdLLaCt3fYaSpHspW6AsJxOe3lpTxwJF5875FRBHkNkTs+Ew/CNzfwIcn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS8PR12MB333896
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CDB41C0003
X-Stat-Signature: a3b8w643ebf663qqo41e9zpeb4y8gwko
X-HE-Tag: 1788188483-18626
X-HE-Meta: U2FsdGVkX1+MgEaDiZEv4vMk5zdlqw1BbG/p58hvRhz5OWyaMM0O9B3yfZ3+YbLBRulMLX5B7jGm1x2HNrmB4hR989AVJL+OLxDGW1K7aAIqrrR9P8o8kzJpQ6kMnkQV0QtrXWUl0UUuo8XGxiDj5UmqGyw8pf3FLwmnS6OTTH+v03rUuZF6eDEPZsmFtdfCu7zVE89uN7hkDyEHYdIqu5pXRYM+FIUW+XBTRNH7r7zTCQza+K6WVjc/NyXOENvN4ipTnZqg+YIxNzbDr9hryK3LqokP2xTurIwvp16C+PJQyElz2GvkGlmO82gD51p0P2S/vJbACXDZWHP+/vhMy31C1u+QHaikps7xbsHSti/O95cccIs8+uJIHuFljWOQMU+dJ7Fpx4LUg++FTHtvI7U98wCz7SY6f/Tnetg9Meo6CLH3OSOvRrJTGeYWj6Z18YBvU2zOd7XGjGZyjbcJs5Hmh504AE2wbjRhsoYDda5AqSTQhrF0vdEU6Sc0dM8bmhNDt0ToBDH/r3mLjDVTmCO4Syjug7JE5e6D5B0zTNl0cqOIJ99Sq5NuF5+WAxBmOiS4FWWZJmOzhLue970mwsHrNz/kS4abceSu6KLrcBbDY+QcDtbfT9h6xcb4hD8ep0Zp840e12dUjQWWasbPethA55LBQcKdm7jrUDXjjzKnL8gWsIAa9NPGYwSb/Oqp9KHyhtdwZsA0MqWyX6wzQldr0l9YQ0jz1ZjMsododTO2e0qsQ+DdUMvWONXSHFppt0m9z0gUXkidv58UiRwRwwsnyWWbX1ysHnfMxN/+gBgzyGw5dsQf/mtha792gHZ072SoNfh8cpWpi+qzKHMR0HOrZiHBk9tjg9Xk3Md5laMQWyjg0xzCcIKwNA3Vay7CN0SRHnddLYLNrcP5H3o7XnnR7skKwlXiThwyxh/PlMHKohH4oKijVw/0yGRtXI8mgbGO80u787DE/B4tS8n
 WHLVUXIA
 etdrOjXuyOuFmVmUxfcAicascgaFuoTspiXyloOXxWBEPdrpd17Mr1KPItFjhDX3UjWIYPBU8tFvkE+EwF1Acb/tFMPvvHOrhGxxtUClua+YyvZjtvo+DR/koWNJ1FquAPHifK+i1EdxaWIZPuI7gCQEZqEn40h5jW24mWmxcdswMfctQaStT5BFGim+8MyXHiX2suJPRx5D9/n1snrOhms0dnDHjaACDfcacVZd2fZjbgjcJ/Fr1aSxc2bBih0CVq6AbHXjzCN09qMwy450m038dfep8le9htjbvviLEtqFwI7L7OiXL21XYQU+NqGN8z4kVSF+iwQ+olm9eycUJjLzHYwHzQBo6FlqvBb0bJwixthuIgmOQapr1aoWvEWpVPRacJoAgybiHOeZTn85UWH4/eRTxToyzSOex
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31 Aug 2026, at 5:00, Lance Yang wrote:

> On 2026/8/31 15:56, Nimrod Oren wrote:
>> When THP is enabled, set_recommended_min_free_kbytes() may raise
>> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
>> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
>> pageblocks for every eligible populated zone before capping the result
>> at 5% of low memory.
>>
>> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
>> configurations, but scales poorly with larger base page sizes. With
>> the default arm64 pageblock sizes, the contribution per eligible zone
>> before the 5% cap is:
>>
>>    4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>>   16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>>   64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>>
>> Consequently, min_free_kbytes can reach excessive and unwanted levels.
>>
>> Add an absolute 1 GiB cap to the recommendation, in addition to the
>> existing percentage cap. This bounds the automatic recommendation to a
>> sane value on systems with large pageblocks while preserving existing
>> behavior for typical systems with 2 MiB pageblocks.
>
> Sorry, I haven't been following the previous discussion.
>
> One nit: why 1 GiB? It feels a bit arbitrary to me ...

It is. Just better than 5.5GiB in the existing configuration.

Best Regards,
Yan, Zi

