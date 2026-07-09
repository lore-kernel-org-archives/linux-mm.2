Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6CE3C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 16:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97DC6B008C; Thu,  9 Jul 2026 12:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6FD06B0092; Thu,  9 Jul 2026 12:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38A06B0093; Thu,  9 Jul 2026 12:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F1D86B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:12:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2953A1C807F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:12:04 +0000 (UTC)
X-FDA: 84969729768.25.4BC2D31
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010000.outbound.protection.outlook.com [52.101.201.0])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2848E180017
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:12:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h4VDIT1P;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783613521;
	b=uLV0PXLndeOE4+PG5NKgEiC7vJhiIFQQSqmcykqXSPeDg6YCcAEFWjTrris/6Xrj3cGLDM
	Rqj7BhcxOLv2d2HIyKskUAHMf6CzmAFB1py7O7Fq8rsQM6aC27NFT4q0GalR22AxycqC9R
	W9soBCaclnTzkN7nRWqxcjnRNwKm8Y8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=h4VDIT1P;
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.0 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783613521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQawvALf/mN94vq0/5DJX+DiLzEyzW+dlFRlHIfPoYk=;
	b=EuBQO2Ap3IrONEBbMhxsw7/6y07KJhjDp/Lq/5b7qR2nscVyZyPeEHUYN6yH8b/n+Sc+6G
	NcRRofISTTUwZwo4NMi3D9ujHNj+O+31xJ4rOogWbjq/oNDn0vl+XjOYgwhljT324tsTFT
	aNEhL7PqJNMWBQnYwXTLGI/FP9Bs+zQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x+NYjsLLfT6S8N3Jxp40/Ho1oYWoXv9mU/r/NcRee2nMoHE7UVCoVfp1S8pHKiNcq2NaYwrbVABpjKClPAPLypT4M7S7COWibTQAV3l/Ejf+Yvqz+UB4ZrNWNnOb3ubQYCN517i9eX23JOj/k0Eg6dHMqA/E0s4/EllRGXuEzKg8JAfsVSVqZQ0lbShdZXxCtw+WM4rXa/znm9XT3eHHTb3XOn+C6sJOt0B0U00z0M2ewaQiwWmLSIvOHTEujU4j99xhLsbhTEmxavUl3LF0dppv2PLPUVLCGlpX3fEBTyeY1+zHHX/C43bnqyK463hULdFzFX8XHOKJ7mJo37riJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kQawvALf/mN94vq0/5DJX+DiLzEyzW+dlFRlHIfPoYk=;
 b=RvkbRT1ci61z+Ey0Aa3SP9UmLxw9DmHFlLvhW+rnzQVKcblTymik0wFGNjKnSHL9eu1i1oRpf5qhITvNEXvtrdcxHDDELDlmr8gM01naeKvmYpcud6x02ziQWw1T16QL0yXPNBYs+nJ8nNXZ01l0HLhoLrJmKS3J9tIhKIolru8EWRddhDEttCIbN+jcQMg3cesagezhK45kKuK+KZOvSCb0DTPAF2c9o1KnhuqBu/YjIQet1K+uvyZ5FuT4uIyvut5IbqiPwfSqisk0/Y1JokBkxeWxtyX31/ByZZrzeJghGa2VxBq6M/wbJPQLce7S0Iz24nMkIj2XH79hW+Vbxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kQawvALf/mN94vq0/5DJX+DiLzEyzW+dlFRlHIfPoYk=;
 b=h4VDIT1P/dglH8oxVRfz+Ki0dEa9+bwtH5g33lUSHxlzN6/9a7AERPBeEpIyzhkna0ft6gd8QEN0qa+3MMyjU5oB7oS/JPhmurkpQhWyibEseEc8QkzvLO0dKVVIUR4pg/80YhuhuisKurA5YUjJbNhwlZvsXAScnewz2caac+Jpz/u+N/II58MqvgjDsvGAmmYbTb4swJN1hKFZBKHtWM+Ps1CbwEUd8uR+oLqmZ1XWZVGH6da+QOawJYaEgOZoy9e6+upFWeWvjTxrqNbNRJu3ygL5MrR+W8dzUs7mX50OBQrZgjLDyeT26/+5N7hmQYpea920BuxSbbXYuJ6L4w==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB6886.namprd12.prod.outlook.com (2603:10b6:806:262::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.16; Thu, 9 Jul
 2026 16:11:54 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 16:11:54 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] mm/huge_memory: add page->private check back in
 __split_folio_to_order()
Date: Thu, 09 Jul 2026 12:11:52 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <CE3BB1EF-A6BE-437C-97E9-08DDB634B53F@nvidia.com>
In-Reply-To: <97d3831f-ce7e-4408-ae0c-60e45d00d69e@kernel.org>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-3-2970fe777dd6@nvidia.com>
 <97d3831f-ce7e-4408-ae0c-60e45d00d69e@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN0PR04CA0035.namprd04.prod.outlook.com
 (2603:10b6:408:e8::10) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB6886:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f690bec-81a2-42fb-b94a-08deddd4cafe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|56012099006|4143699003|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	L8/Dm4d+axeiqPRzDoxKVEY5t9OpSomrllel3SMw8KJC9q1wLLyTQdOq5FQ2KANytCphBLxAPG8A16XmYI0o6DSBKMOk11iV90eyn6nkFZTASM+D7/GnE55ZhZLrzIbZMV63L8exK58Dd5ri5+E/K30difmTSgep7OhYGwbUVBYp6RiTMXvrL1AlPSAkBloPGvKsuAKLRU/znMaJaHasTPNyJMY41ncAn00OObu0/dfy9JKvVZ7pYjRVooJcuz/yd9v3lolo2thnVDE4LAwUNqoygE+oWQjWejVzjw6VonQzH7b4tbD2oXuwh1LfL0PHOmPmxkzsGKmnmBAL1c1RKGoKA7dEAM4WmP9zOgpAtCUVG9x3bVDqMhHuZzXyom2JJ8PkZUClxz+RwIU52Ca8eHot4brZVY/c1stizRX64MSz3sLjtvrGHedU+jnR7DKUnFYVvbxN5ItXkWy85c9Hd0JxFx8Kunu6LAZo6gmyzQnLsnWRrseyY4vv/ZduNyJLyykhuRTO0phBw2RRrQR3RVOAAXofLFaDJQQCPxdOXiSYuY3q3qEHctGLXy6INRGCdA7FX40VF8uIjzfxt+s13rb7rSUb+7yXINv+fTcT1KGbTj22VloT1Hgw3Uhd1M0N1oJPx7ircfkr2XI7u/paHsWSXmSkNgr9p1itPQDvDWM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?C1wklhSOtSZ4jgxXVnAxZehEIflaM3wswRLwyIwrLaYLtTozosPRa0gudqQi?=
 =?us-ascii?Q?F3PcZOR78O3ZOxoDntBptW7QXN1z6/KBrWy2uS39wu+VJraEaAhn7dJ+fcSV?=
 =?us-ascii?Q?eU8HCIqmYaPxz4T2gApc4RoFsFgzs/R9Iy56erUlbx/WB1O9e9Fm1cvtzRwa?=
 =?us-ascii?Q?cKFKfyeVc27+bQHCMyyOmVN/vPtcf/roSntL8eKO13q5L/4d8wxhXkcT0psm?=
 =?us-ascii?Q?3musOIS6XqjpfPXYExiIbmmQQ7G4qWaXzFBzR6QkkBHuCzQ0Uj3OT3dhucqg?=
 =?us-ascii?Q?8m5/UXamVkCxCYc55rbWDvyZU+H6cO1G+acl6ZIX+IQE09vqx4RnGqp9fyjG?=
 =?us-ascii?Q?OiBd8sXU1+5KPHYS1P9LLaLgjjn/0mvFiXWvqj22ztfC8u9D6+S9klTzElrq?=
 =?us-ascii?Q?ajXCr4z3cL8zxojPEx3EIfCUewAPpLgH/pJ7W5Foqe+1uW9fxEw8PH4J4WUK?=
 =?us-ascii?Q?z51sSJPe9lyx0kAZlK2AH1d9gzL4qRU0dtTlPhhxcMxEAFXZ3znMWT3GeE0i?=
 =?us-ascii?Q?Skk4qM6SJzKnIcN8POQUVtac9ujZ5voHJsh7tkD0RS7NnGuWfYVH8MP4Gg1s?=
 =?us-ascii?Q?qC16vKVuIv2KSWFH4/9WeLN3K4EvVzdljXxQH3fS7H3JINl/fyrXI+c13zZd?=
 =?us-ascii?Q?pploWse42UU0li8iKEohJ658jWpHhC/c+9ZjPZvw7aVUn8mJsRm5dHUybCtU?=
 =?us-ascii?Q?IzLIFU+wNoP9gJBT5Ktv0fcO0UBmKXx73mcIAIYy+SQV0AlBbiBfK0KdgGkL?=
 =?us-ascii?Q?zEY/NVQ9Su8wPrD4VqFCm6/PM8B9ULNR4/GrRqlOGoKG/q3aCpBbweS7tKYy?=
 =?us-ascii?Q?9TgqDQgQsQvyqgMLfq07U6P2qxhiZHtY2KoaS305KHijsriWhgWI9hdWNG1Z?=
 =?us-ascii?Q?8MOHdOABjIkXGOR2zMgJdBLSmopgDPuK2wNcWyV76sDc7U8KbTRjuChjiNle?=
 =?us-ascii?Q?rlJrgx4g2T0T6WjYJOzv3v4VOQbAuhvcH2HIb1IarqLXojQ60wWiq6TfNeax?=
 =?us-ascii?Q?JfbeBRKzB6SGdWDw1Xxzf2d5dK4W4eERkg+dibxjA0fIB1RbG0is1pyh1fnP?=
 =?us-ascii?Q?rHZfB+wJplH/mpHfVgjwdIsBQESgUXf+Mas6vDS3Ph2WsdhqzV5G/MxEnm9/?=
 =?us-ascii?Q?15H6F/RC2j0tg6EFQuqaDrKiFfoPb+l/A/ppmvA5ZWBiVQvUI/IeF1+iexnF?=
 =?us-ascii?Q?vn9sF8fuQR5csdrMk3UATGtHL1IKWNQ2mBxrJne7SuDXfUD+PQecnjJvZ5Mg?=
 =?us-ascii?Q?rvQgI0+7TPk6tFatns5vIpdwBu0mSEP4KtZulfsz5M014KTbosT6O3WRWnwS?=
 =?us-ascii?Q?i4tBhtgM40tDDvrRRTn9Iu4Ppu3J4YryiFix6MThm6Sd+lDVN6EF8nPeyhui?=
 =?us-ascii?Q?yXfW/VFEhgVP36KlFx2tiV94xZD6VmTl63aWHn4t6LakX+LFSNmzZm976Gsu?=
 =?us-ascii?Q?0bvapLaTvAZ6No1FRarEl8NGIkn/Kd5eO1S3SfeuW54jFrpFDE1KZZfOk0fA?=
 =?us-ascii?Q?O3L7pbDFnS7MxjQ9uZhf3EQoD6fq+AELpNPL5remdo2sB+ZxhOBR4jRk/u1G?=
 =?us-ascii?Q?CqMFVYic522D4+n4DudbrWQ2kP3IX6bi2n6UuT9Yz5QUwDhdJ2/LJ1wJHFq6?=
 =?us-ascii?Q?M978+7Cg+y7XEDPbDUDQpN6b0nLgh1dKh9IzmRhwot/whrFWNYgwQ1858T6F?=
 =?us-ascii?Q?zV2WKmQYymEDgboGjBHBns6S94au7wBfvvHM/z2txMomCB2B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f690bec-81a2-42fb-b94a-08deddd4cafe
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 16:11:54.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GfytTj2j1KnroJeB/UbWfTLpWNmYR9bWrqzRHm+9qvGb4kgRJsU3MyFcL115m/p3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6886
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2848E180017
X-Stat-Signature: mpjoiyogdyzzmu7ipqbmp99ays4it6z8
X-HE-Tag: 1783613520-925744
X-HE-Meta: U2FsdGVkX1/Cl4TLBJzdWjSbQaq6K4LVlQNr6k6hclFH3Fqmh9wKjhoor2i0vrjrXPj+9rIside9hifxOjEQEYWxAPMDTEGTjH25zSyrC1ff3Zsgt106nLMXGIiRMldC8Vn7Ox7llnJEaISSjgdGrnEcGKX9sipw6dXy2vgj4Ihl0tEjnIaVI+H4krziAH23CEkKMH3FXc5f0Oo/dLzElQ8dUT/lZt6GT8cTU9LapzOJcmHMZJvTrUO1PFm5uaCAa5wqgAppFQCf8cQdWAmfqfHkPEJr9nwwPSQAR4jIPCR0J2//6lXWyDcHOROPHyx6hwS3XSjmWZWl8DJcGKG4fAGvJbm5F7FrJJm7F4PgxlfQFwuHCNyhSp5UwiYRvB2ixaokXcDhKSu4Lbqhgi/URj5gp6frqivD1k3Xcci2Jwwb0L2D01OF5AfhG8blZybb5Y3PibiY2uDjuwesnDsdZ7s/xhH6b8tExTNpI8VRnn1/SDJLIyNfHUo2yBgHFIZTyeg9colMFvgtFPvQ45ButNbwHVVq+XEmt1enGPtlRSFiiohgWyEIduX/llw9e+FVEh1tJncVZZ4ZNvacWaRY5AX7PpYlYHLb265kewi1mdCQVely6iRpRPw0g4itJ6+3dBUm8sg7ciX5cCcpV5uHItINYlXMPk1tGb2zwgbLwhmaCvW43dUeVcB6bLJaD6Suma6xRuoYNF5Ya9vxizqYicUNBtCrgSKAcGWguuPuGMePHSda7SqNHG95RuJ/wOqSNWfNuI6s7/SqGphAjl6R/E3mE9NoxPAPT8wEUJR/Ssy63ZsNVw9wR7xNg3XqpIptZstqlEMu1pI0BI/8BtrS/tyq8T+2IX8xI5kWrH3kxCRJw8kbAIcUrWFWhIAXfjDp3oeAluC6QBxmlEWj1uYGBCepEq4DFIhB9Um/xEfk+RwpH40AMvDYXmSvOblXKoPZozV6R/4K14LuFBQNigt
 84ifQHF9
 HqI7zRXHVWb175ze9fmF+NEft8A0AVNYKuMxZceIS7W1LikCkN+66CsghWhFkvxoPKxXenrvSGqIDPj9dEP0m8A0zUWBlj5EOWg2r30QWUFbyrvfk4oZokI2hdAbuZIU437cBYjhyljhkgnYecRtc3CbXPXQ4R+8PAd99QLBiffBX/P84+LLvv5uK0L9gTRkIyyzaIj9HDHlNwqNRkJma5uMJrDoB7c1epjGMm5tQO4ilfl4eKRfcbS4sA4iXlNQgP8zAkwdLM7FryBnicWt2pP9JmRWpM609+wjupYmTv6Y/nYhVRjosnu+7NPjxqgBPSDrjD8VZwtGGchJVk+AmK8p8t10QPel4HDO+3eobZWM0LHHv42wE9ppBAOULRSCggTfPhNo28qjcqwES6c/ynu5tA7agonHBkr00uL94914WFDH84XSjcZcl/jG4RxHPNn01mgfQLw8sV/w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jul 2026, at 4:03, Vlastimil Babka (SUSE) wrote:

> On 7/3/26 15:47, Zi Yan wrote:
>> page->private should not be set in tail pages. Commit 4265d67e405a
>> ("mm/migrate_device: add THP splitting during migration") removed it
>
> I would say e.g. "a DEBUG_VM check" instead of "it"

Will change it in the next version.

>
>> without a proper reason[1]. Add it back.
>>
>> Link: https://lore.kernel.org/all/13f3fcda-7328-4aa5-afc6-75a294a82b2a=
@nvidia.com/ [1]
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks.

Best Regards,
Yan, Zi

