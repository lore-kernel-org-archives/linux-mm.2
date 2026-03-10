Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33B7FD4F1A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD35F6B0088; Tue, 10 Mar 2026 14:38:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81DF6B0089; Tue, 10 Mar 2026 14:38:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59C16B008A; Tue, 10 Mar 2026 14:38:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A118B6B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:38:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0210E13A229
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:38:43 +0000 (UTC)
X-FDA: 84531014568.20.4A15060
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012005.outbound.protection.outlook.com [40.107.209.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5C99C180008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:38:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E2lJEeDg;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773167921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YowJK7DTSJXTJlleiQNZfkx844aXfOvJ0plGsxX8R8A=;
	b=1Jzw59Myo02v6OqJABIo6nzyUUDVfLVt8A/JBc0KHOq4OQmVOqgx49qPGjcLiNl1qH9HTM
	lbDXcZErOFkWU8i5S2vorepuXJRZ3wqWFYj2dXIftTohMHQTZ/6ao+rY7JrUGb9Y5nyZXM
	aGYqJwRo8WuWkcN09bH0Y3Glw3g9koQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773167921; a=rsa-sha256;
	cv=pass;
	b=bZCXY1mTh0hWaMyvRGhH0twTJHSYRYTRO4Yef0uzKweF3ta+Y65bKOb3BDNIijdz0kfxDy
	86FTJk7iDutFvflS6VvFaPfDwE+OL2mUmrwJSzQvs2kiUWnS4dEsF71gdQ6kcHUUQhoJJ7
	4hohVX2uI5hp959I+TQ8DO44wcbc248=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=E2lJEeDg;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.5 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YOKFHxM1wxn5amFO5Im0i9sjIZOwl5PUiQIWKbNsgqszM7gpe8TCDiG8Iwf0hQAGtWHQLhhJuV5ENCAySFHvux46OmVmpUr1teD7Ek0kgabOziiBvQ5aav8GM4YtTXEQzT/sqr6xafJj+5bAXCpLdQ6gr734alSHpilyvccYJF7uMsaQH7yX9eTL4Ca9FhsbgjWWchIBsmP2N6P1OaeKdP6sx5dSXMCKWvZLV3z9aw9CZLIXW/uef3z3EjPilSWcYuZPtLR93tsKp8cReCqZKnpWbjKsDf/zd9gQtaab+iySuJDbPa6MYQa+lr25HZZoWCN8NllS0pd4Z5w9z5YYvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YowJK7DTSJXTJlleiQNZfkx844aXfOvJ0plGsxX8R8A=;
 b=pKBbcCRs2TLBqkRpSP9iGjVFyHstxqMWuN0PjCYcZEV3jfPUkjbpUr/uPaGNYJ4LoZKxlCrveAs2fYWLZviFOrH72pVJjzaT9R4XC7ECSYGGe9vTLLJhW/veTnhjz9cuJOSHAIiQR/om4sz107M7V5+IjqJDUG+NDWP89UFMYe/JpcJUd2EE+ZsKkBSSNTvrTDfaUJmh86+08Q5XDsSBTvAyB8xmeK/IKnLJ6K59Xk/d+u9oDMwjqqGKbvbZN4Luj4EDJDn+tydAPsB+F9wtyMHUljXye0+2ZWibSNlNxgMU14QE1zsWSWaSgoLpg1/fZg5CAVMq+kmjsnuHzqkGnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YowJK7DTSJXTJlleiQNZfkx844aXfOvJ0plGsxX8R8A=;
 b=E2lJEeDgUSi3eZCSpNipOPJtyH3CjbNxu1kWDt+tnxd0XrTmYM1tfwhPddMWQA0CRqitWrnCxF1KbEDTi0BJG84OBbtr+vU7q5Ef1IsJDj8J4zAmhLeNmTH33SGFUw7/WLVoSOLdsxzx4N6K55F1P2pCSCIIMThffVbpKRaiy94U96bgrMFznOpMVP7BY40MJVmWh4wKtt5VI7t4Br75EfV86FVoMiRtcoqyu8ftW8NILzqfsiTAfeZcAAUz6IJe20jDJ4UXm9INsIuo2yumfbggJ4OxATDnLkm9JMrGxUjlZ47ZrwIwXiLNqS+73/I3juhr+w50HxaheaEGLKiE+w==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by DM4PR12MB6400.namprd12.prod.outlook.com (2603:10b6:8:b9::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9700.11; Tue, 10 Mar 2026 18:38:34 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 18:38:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v5 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Date: Tue, 10 Mar 2026 14:38:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <BCE46335-796D-4350-945D-193314822A92@nvidia.com>
In-Reply-To: <20260310-thp_logs-v5-2-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
 <20260310-thp_logs-v5-2-686099175bf6@debian.org>
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0050.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::25) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|DM4PR12MB6400:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ac941b4-bf88-4516-0b57-08de7ed43b05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|18002099003|56012099003|22082099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	SIA/NOUEzxXCEiK+HlONPPAMWaWPt1+dlxeqD5H+e16HOBOCHHblzsPnOavmPxo+EMqFbiAHZlyi11hD7UbWynaUyaXinHpHcQD91rQLR3kgBhDuBhNdxUST+8fkWY48rxx6mOm3h8ppvvNyTKK95R8reShubG8zkk0noVvkOcXD9eIS4m65KCkUoD8crVMCfRIVs5Yq5lg02/RXMSk3+JifflDTQOaRcn+u4OyFFQoqa0arJhmqs9q29Kgh9uvZdJzi3JibT0qrzr0RCvqjRBCScfUQ7YNTAZnWRKJIWLXWeamLEMUT+/6erbxBZsZhhJcWoXP3m75okLEEYdpBOWP1MGcVJgrz1uWgjBw6+VphujjoRTt4Pnnm8MfghxxB6eXbh2p+qREn/ErdsogwSgy2YD6piHX3pWAaNTChbCBUtwTkKUdELL7j0HnUDH+u5cUJ3FZy7UWEXGxT4FRRgLuP47s/7Br6I+v1KPJgGjrfxxbAIcdCQzBsPt6LiVEUBWgdPLLaOSvu8Rc4U7QLggOAGBGe/EGL9KYmDwEqIY8D9uHRIs7nwasWsyQ73+F6vnGuJ7eV9meGuZ9N/NWkRu0qp1U/LI+9gHswSuxVr+3X7z94m2+pLVXTs+Wv/uv8NvIAEI64KK6zB3p0sW3oEfhyhm6WExin1nKWb1s7ARIeqvnegCyT69SWf8gUT3cStaxfjLIYChUx/XFGeDoiapTlYXBsja31ZjF5lQ9y0T0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(18002099003)(56012099003)(22082099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F9MU+IISLmaoxBfRLMAN4Uge3QhVIMizApu2UCGLXoTXPJFs1Z3tnY4NgcSd?=
 =?us-ascii?Q?OfUcPYxfamWXsO/Cx+UW0ts6Mb/C1OBq0EL5ApJPFk2bWKjkiamagFpbc/pV?=
 =?us-ascii?Q?3ObNVxZ3gIwapmNfCPhmzUDwZjwCBMKsdpKeKmnrMX9D+MnUd0mvdnLf6CYF?=
 =?us-ascii?Q?m3HbaMqJhVyLd7rQEW5mkHkVzxILOt5GrHQ2mLPrmZ22ZfPLr7j0a7jba9GJ?=
 =?us-ascii?Q?FFk1rw/UW6HMZyRqVCyLy6/gVv0/lIEBRhdeFXThXaDqfCZrikX/49Oxz608?=
 =?us-ascii?Q?CcM4O7EUpTZXzakbFSsHllHDZ9eRkBCit+nyRzXQgq2tzkVLxT980mz0z3B2?=
 =?us-ascii?Q?uBTb4GZbgOJXkJbGUxUnYbRxnMqNRlN2Un2Uyzu2KoBMOKTCs37FotQNg4TI?=
 =?us-ascii?Q?p4f5yEstViUUaoH5mbBQlRI3H5ZqnXL+gOcC6KCkrGPwNo9c00JZrUNpYpCW?=
 =?us-ascii?Q?NePQA6O+MsvXHWVittzqChxUFeY5i6PgLWuyUs3jvNACwEo0CNBfv2bLpQL3?=
 =?us-ascii?Q?96EywFxS5VH/qGOqxkJ+ikZn1WimvI6HBo3+WGo7OFJg7FLv6q+D+JWOnlJy?=
 =?us-ascii?Q?YYRh2ed7Yj6EmRHivuCbzukN8AXsM/j7HD6hY2jwuog1/xKWjeVhgapCi1XH?=
 =?us-ascii?Q?A/vegkhxZW/CfucQBNz4SIGkszj5EPKQ+1JadxG7XMna8/JQjs+PBnqZFB0b?=
 =?us-ascii?Q?7lkd2vUOJI0DiNxQLsHKE1Gy8SSbYfQJ7xoSJXz4CRGN4mVZYuXmlZ2txopM?=
 =?us-ascii?Q?KA+lN3LhZHF9lN30g0dvUKd/A+C9RF3KBIClm31TpS9BvlgdtUrEVgp2ynWO?=
 =?us-ascii?Q?MNuqMWFEG6BHbhzvWyXOgWp+QNcp08dWqL84q6xblGXBrUFXZegH++vFtYpZ?=
 =?us-ascii?Q?ul3p7hustwfTdAYFL6S7K/7adKDxgGGSOUzt1IXl7KUFSNx54Ky9bUmEHjq3?=
 =?us-ascii?Q?xhvCddGntU7SalZlTqrFys8DKnRQQ+lHDXh+zpnQDIMpZ2QCQXqxWJkKw2U7?=
 =?us-ascii?Q?wRaMdAvAEggtw8JNq6WJhB1r2GVzswQ1a+cP0YnFWvd262rPo+T6i654pa4z?=
 =?us-ascii?Q?oEO5U+SMFe1yUEPk8w5ZhOyCBqefoXGNYhi/HcDDmyuc3UlVcMbQBMOxKCf5?=
 =?us-ascii?Q?4eeBbOGIIZa8X+GT1iGkGb83k5LNmYAQVpF1tAplJlr2yGf/LJNSTaVh81cC?=
 =?us-ascii?Q?DbuOo5JpXOiwpIh6vCtUc/VxgpsI5zP7j+N7wwoXpVhZ5q6KHh/9u0RFi38D?=
 =?us-ascii?Q?KMVslq88SBpG6oc5PVA5bDFJmMY008F2QxHq3iT7oGaFLCuJszi3G7XFGwUT?=
 =?us-ascii?Q?n1ywEvAVnbbMqQaHCZOVQvDURtisWXm8cZtPxt3qo19CNsHoVkhMNXyllmFQ?=
 =?us-ascii?Q?DyZcClXDZT2atVI7HDNPJgi0/vI5j8NO0X3+7oOsfKjK8y8awPYgPYl8DrQP?=
 =?us-ascii?Q?11h8qZU9ZNWjuVJslH1Kth/ZQc4ei1VsV0ziNLbKQY800UtmlZdFKgPihwS8?=
 =?us-ascii?Q?Q7gODaHP/30Op/95NQbOZsmFJKThCX/JKK7H96YqKnOxpJbanBqXc0sYcuAL?=
 =?us-ascii?Q?2Ka38taAdzdyyTSq47L6Hb/PytNNN0WNmIkeVXytXWAVqe6axjr1xMnmSa1k?=
 =?us-ascii?Q?w3uQBYTWYymh7Q5GvOIjyOOUgU+kpGpLFmU7dc8I0Vh1hbNWIuKENZWV7vDv?=
 =?us-ascii?Q?0WYNcClZMgqhX6ve3w9PUbBsuj8Olmhd29TsWTyboZ30h5TZTQBStZuvPzr6?=
 =?us-ascii?Q?mB7s3ONBsw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ac941b4-bf88-4516-0b57-08de7ed43b05
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 18:38:32.2985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xc0ym8kBOZrDgxZZdR7/t3Zwa0+/fE+emKz/PZGhU59yB8P/KH4wfU0jUvLWkg13
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6400
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5C99C180008
X-Stat-Signature: 916gpmj9juyki1pnac95sbaxpabhjyc4
X-HE-Tag: 1773167921-929637
X-HE-Meta: U2FsdGVkX19qP4V28AWUjXlxD9QZ/DvuViqtC5xuAJhTg79HGkrJBI2yDbZb0eoneUwfDKvOTjasVeogKFeWX+zMm8nEV3aWnDfVUHD3w9Kr150yHM8N094z2MDrQgbC2l7tCI7GXTs9/mCkKVnIeX2Mb+ryQAHdSjrPJn49p8Ky0cHD++9DBc4mggFTeYrzmRxY3yANSAxAluvtyiqIwVm4otwVoSc8ONCP4P2mMyQKUlrV0ehZukBzswydUJBk+K+U3GXWLZOzRos/qLt6LoMs6q578fL7YaWBAM2G3BZjFFEFBDKauYK0mb4wH86t4RZY+RcSMU3IVdRX25A1jztW0P8f0QJDSzCuft6zlfcBHeUOSIyrf2Ht2v7WKQIrLAUAh0OswIgJ81yDviMmV1Lo80uW8d8uaHFg3db3VWPFtgWBDncEe4fDk6yrTakt/KVWPJr5kIuhGDXym6txDiRcvPkC8/z/P2kBS1141heYtLSR72ceR1WZeX813/IZgFYGgbNa7U0SzDYdvQC583wkUgHuAL1n5yzzeeZsQ5beBuIqlDGR839GZpUsdzyYzEXQg0OrmINfV/4NdlghbfvXNm7x5QEc/V3oa+6VpEtrqDAs+hO6pbHfkLcx17e13JrUpMtN9ZbyYK/W/t9oBBdoNhw2zmeTOOvb8aY3qqmJxOQSvmD8ueahNUSkzg2y1A/5blRHtBOjOWV9/8OU5s0pGBgzHVoSmat+9XU4qbtUvGOxZxbEzcEVnswwqEIJUvPOyZRbndCf6gRH7i0Dfl3sUfiIsLKrRlOoe0wRrjzNPv8GypNo9HVdOQZtG19y6Odr/TVOt2aJsL+ZpaM9dZQZRnERxILoKB6K9u/uxf62CGTs9EkbWcAWHstIRN6iVS+88vtL0A9oJEiT73FmouNOtBs6z20V32L1Je6RjwKYLCeWnp6JFOZDXXL7PJO3cEhf4pDMwgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 13:57, Breno Leitao wrote:

> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
>
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
>
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
>
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 52 insertions(+), 32 deletions(-)
>

Nice cleanup.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

