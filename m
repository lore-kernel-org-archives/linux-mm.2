Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5116ACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 17:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4265E8E0005; Fri, 19 Sep 2025 13:18:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FDC88E0002; Fri, 19 Sep 2025 13:18:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC288E0005; Fri, 19 Sep 2025 13:18:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C04A8E0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:18:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B02431A06B0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:18:38 +0000 (UTC)
X-FDA: 83906659116.07.55C8CF8
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010026.outbound.protection.outlook.com [52.101.193.26])
	by imf07.hostedemail.com (Postfix) with ESMTP id EBC5B40002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:18:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L0PfzlIg;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758302316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=toFLCevRpwag1VrXUBrVB6LxuV3AANV7NOun9c/ITys=;
	b=6s2f71F6IJJe1Y8tMlRMcBAPUf66rTEiLr9hFCLiLLlM72ljee4ndC/ZxDaSDWTBkPUIxM
	/JHnHl/zNJQGxw9ml5NIemEWtylgbqf67rfq+AoE0UHqvnVef2rTcRZEZ5yCk618wgkQzs
	VTJ3tIcBII+2lYi6kBDPQgzbGRRcq4A=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=L0PfzlIg;
	spf=pass (imf07.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.26 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758302316; a=rsa-sha256;
	cv=pass;
	b=uAXHujCN8e3Zo7faknqyivSSBguPUfYw2ySZF9GpzHrJ+yqW0dZDh6W1c//f/pbPgC5V5g
	l6kBpJYxm6oqUbdvNiQ1u0Q4HESwbjWFKbUoo6d6BFzKJCCabtE72VvpBY6SCOY395GDmW
	ET+vE5c5IKsZnlY2teu5vNy7rXG+M5o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E3br6m6L0cHNFD73wACIav+HEcgopezgn5QTCEwIReO2n2KA2n82ujYdKoa+1xWIsv77edgP9L/+v2Gt5UlUASXd7HQr8cuY5IPGGl3+HXM674M7oSBJn/AXmOr58ZQRytcE1/8ybyW5cJxod2/LTY7ZslLeNE6P/C+LvX+ssyQlXDkuUfLlkXPZB0wOFpFvtHCyj6r0BglZdJgNVoOyA+ICIWNuvuSKjRHY2zqXbKPHLgejLE31TVB+K4i1QWfTcsnjVgBIPoK2wnm2J6+DnKKpKFjMdwUeGuimJQsDiC8/HbL1gEgZ4eIxb4RHkRoR5+H1ConecPuFbINq/BS1dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=toFLCevRpwag1VrXUBrVB6LxuV3AANV7NOun9c/ITys=;
 b=a5E/NhCXKtFV9dAUjEFvu8tV38/BZv+waYsJpLNRf2MOCnhBcVl0ZWXWjImmLQbZ5tsfgsvkn1cKk6ZvWNee2k8TABKTCgZf56NubGMW9J3/vaqeXvrHnkdpmIoGZd8gcKQwRguxmkMLacEOcc7tnXuNRg1u4hSUQ18/zsKoCXkO3E0oUoW5SkOY65mKS1eNtJ+AnRqmkdpP+9J1itII6S/6chQX8ix7/WF7+YlkXul1s/zqOXx7Nrjw7vqpCIjIewt7YKdrpi+U0HMWarxV7rpuiIXTEC4bArwtBwDi/RwX/9TepfL/YL4VVxklr2UAra/esJrtBSh6BA2naoDWGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=toFLCevRpwag1VrXUBrVB6LxuV3AANV7NOun9c/ITys=;
 b=L0PfzlIg0TIx3auh8+JCKIWrYJsKzb7eRlpJvB5rN8xz/3tVxjGXMPThyUMIHdiN2YyJKsSzmdRDKptYQA1yXKYCqX/IHJjY2jYhwYjO9UYs6p5/N1ztUqlXfxf6HhZACvUHIcm99q4qPeN+o3G/WOdVgEmVAdEqvQBVGuEIaviSxgqTKXR79jECGbO5IYapJR1II5YfZnt8xK4eDibHxwqSRSX8nwvv3nQGXOr66sQOje0QPVVhSN1qWnLoqIFX5J8+DaKowVeU7Kk5fXImWphxqp6APwVYaqREe9ihF7C1a1bS/FVaHPq5SBY9bkPOGhuOkHmKrRK0JjTD66fM5Q==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6358.namprd12.prod.outlook.com (2603:10b6:8:95::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.13; Fri, 19 Sep 2025 17:18:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9137.015; Fri, 19 Sep 2025
 17:18:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH] mm: page_alloc: avoid kswapd thrashing due to NUMA
 restrictions
Date: Fri, 19 Sep 2025 13:18:28 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <6B65DE2D-3A40-4E48-9F5F-8E807066DD5A@nvidia.com>
In-Reply-To: <20250919162134.1098208-1-hannes@cmpxchg.org>
References: <20250919162134.1098208-1-hannes@cmpxchg.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL6PEPF0001641B.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: 02606b88-8db4-4400-9c75-08ddf7a08ea4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?asy5U2oRpWEmFffPgsCO15JRA4tqrVNVKClzgiWD0cePl24s+ndfPygrcXKc?=
 =?us-ascii?Q?qyFMNV4vKDQCeLb/sjo20RUU2IZH4Syu523xudHov2odPcE0mA1rPqSgmLqs?=
 =?us-ascii?Q?mo2m11uq4nquDfuHcTuDXgCXPTEZ4DTxVnAb82O9ntcLAWgEqW3nL93EgQqJ?=
 =?us-ascii?Q?UQ0wbJmhMsDSH75D+/diSE6zk7xzHxyqAd7KlFFM8416RBxJIsHHej7azBpI?=
 =?us-ascii?Q?xHJxTtXqosdCbRgLz/GgQ/HIe5sjnHIGTrMh38TtUGbjqcPCvk58GUbBt9dM?=
 =?us-ascii?Q?4195d91CNu4VTnsn976Ljfrbr8fgpAJ/jlM1YFmzaxiEno4MJsL+SOnCRC98?=
 =?us-ascii?Q?NJpd973a4vAypxJqnqBf1Qya4wK9xD0HPA+XXgr5Pxe1vkMOx7Zwthemn5a0?=
 =?us-ascii?Q?9l8UsEMtSvTR5xrpVUplDnu/pJbLRSWEDKvjqWYLZO31GkmAN372yyPy5KyU?=
 =?us-ascii?Q?dadEJRme8pedjpIA/BAgK/f7yr+bRLLdUSHuDefGlPIXE1/yE1m91R3RcUKT?=
 =?us-ascii?Q?XS9Puq8VcgknkVSxLZ+p02cR2wRbguIxzAGaQvLhFLeYRygOHoKJdo4JTPDY?=
 =?us-ascii?Q?9206poioVLYGalKgEfQ8ndj2AvxMXx33TJRPrChgU1ilwGkHvTE1k6R5H3wS?=
 =?us-ascii?Q?ddroAdBjIgWblvVh1auTds2Ub5cngdLL3t/vdg3sBXmSl/Ubw7k71vSxJ/oT?=
 =?us-ascii?Q?pObtG3h6Zv8LENcCXWIdKnL8+ZWT3fMkYFNDM3sMIQ0hX+wMlnMp8ZPvPPmo?=
 =?us-ascii?Q?wq4LJOz5dA1OWZ0gCDCRJkfxmgifwYaUnq6vPSRKZX3MaoAt0ykUY0F66hiC?=
 =?us-ascii?Q?m5mGtLO46s5JuSs+US9BzwiwPVwezbzxwUye2ODgqjkAi5h5IDjX/sAcb3Rx?=
 =?us-ascii?Q?A61D1RFtzFqKqM2VW850bDlbxERb6JZYkr2ekq9qA/Ly8nqmQVFIgKv4rC7P?=
 =?us-ascii?Q?BzB/hMMJnPn0UE3iCmIDzejpxvUFAsirbqKxzEi0o0eOkWaOfQUUvGfV03R9?=
 =?us-ascii?Q?NiD9/sNZfyRLZo6xLj3b5QeBVCemA5odcALOHBQnUsmDiqbGgIR+eVyo5pXU?=
 =?us-ascii?Q?J46b3zlXinq0tfvuc5aG/d34TxO/ICRTPWGzD3OqXWnM9aWGyERrg82peVdu?=
 =?us-ascii?Q?rPrj9L/3H2L67V6rogjS3kNfiTJF96qsGhszdBORo93Nxx4ulaYgLpiySEsD?=
 =?us-ascii?Q?cJgqMrd53vXBlBNSvj34VGf5K7Nh0HlMYWeU4L25j3cjibyQCP0b5YmBXqWF?=
 =?us-ascii?Q?t9ykjPc16qDHfpY6RDp8hdXY3MWQz+lFer23NUu87u8JMR5KgiooTNzoQ0Jg?=
 =?us-ascii?Q?eEfbq5s9hGUMY3B5SxcqcQUJrQpfV+OhpKw7UKKuhEJLRlIB7Uqmytkbkii4?=
 =?us-ascii?Q?2Y3UzI95vZecFNx5eNc/akYchDmzj6hXJ085KacFe5lwctZ3TVqGXMFg9DBp?=
 =?us-ascii?Q?7Z0kBfHBX5w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bsEyoLkX6RzugmO1rL5a0XwvXAyc+r5+6wO6evP4d3iC5gOm0Bb3iM0yqohz?=
 =?us-ascii?Q?zJ9TNLnUxnyy/IgDcdPjl+egWdy2l/DJM3tBBnJyTmshcS9RpQvq8SIUYbha?=
 =?us-ascii?Q?IBvR3e/IhKvmPdjPZB5MIWai/4DHdMiWRSN3XhsqYcyVWkHzEF3vB3FDh3jr?=
 =?us-ascii?Q?T7rgaGyOUYFsrx+xEVXGBOoOpWcAOo6rPDk7Tb6SW82a4klSwr8PU0yqdhIx?=
 =?us-ascii?Q?05x+8IW2eLeeOffdA9u7LGB4xhOne6fejizGxXgh6G6a4HJRN1+zbRRbRN++?=
 =?us-ascii?Q?PVhRbN0GoZfxk5XMwF4lfudAi6MVLGL1RSp7FTWxma6xtqZKmbk0G/fZv35R?=
 =?us-ascii?Q?zJ0QAPvYwiF/Sl18Q7VS6FKasAGyFHiClb3jx7tuKvgSqeZOji7xqVAs9IsZ?=
 =?us-ascii?Q?2Hgx7hs1pLnEJ/64c2RQh0CCvElcJHbEcLE0TbkEXbt/YsZoQdxxDj5mSAk3?=
 =?us-ascii?Q?MC5N/LnBzd5sfwTJohJr1ZvOFAoTx1ioLmmfQP7j5R/zKGFXROkWmAUPXAct?=
 =?us-ascii?Q?BT4vgGmW7n+iUHRFA91dCnZfU6hlOXE8rkAacYomSt5tkdmtPFSDzUVNsnpz?=
 =?us-ascii?Q?Z9cmAhOna98Y8drZA0fWrKOU+7OSPiZay9si++m0C1GoeOKUY7VUQZnnzKkU?=
 =?us-ascii?Q?b3uQ4x0Vxz/HFsJPSli3+3Fvkz/7NRmb4d5UVOq0fS4jX9mR84cjzi/A4X7+?=
 =?us-ascii?Q?4rMCghdb35L2UmUoE86ysbCxMMu6E0NbsG5hP8lNwsFHVu2uRYiu9FplFTT5?=
 =?us-ascii?Q?yzKNPNrWKcXNbFA4Na2Mm6xEuj0/fwJbdjmStMpDbq+tcoXQEMN46A5ZtyJS?=
 =?us-ascii?Q?DpuemrI1rQqs9z06WV2s3d58YJ4GOqXi0RAb4Y8+EXbvSqRcjt24UckgUX+z?=
 =?us-ascii?Q?CjdApvkzZbcv7DkL0eQDxGckcSfcnnohuXoEq1jxnLcYvEyMiC8CB37gMlhw?=
 =?us-ascii?Q?FLJZKu2lno2SZBTJqkHLM/jX9OP2Uof1TBC7CQunfI8MbdgjSeTeVkBM3yls?=
 =?us-ascii?Q?dlI5460t4n3aVbA/TPEv9YgbhhLV5TWn7zhzDxeQEMJc1DRywNE19kH6lpnK?=
 =?us-ascii?Q?Tcu4JQipFy1V7jxsVhu4RJrnukd1RaS9XsV9BwMvDRMnJJMZs4hoXtJ73lry?=
 =?us-ascii?Q?X9iw3a1jpTcZInIRN4M6t3gZvMGY/6GVUU48HO7eGJc5DqZI73GqlpOGZR3C?=
 =?us-ascii?Q?NOZBa6Xy/ta9/77HxI9nuPmd1HqmddYGL0GIEth3nt3fikDS8OidB5WtI519?=
 =?us-ascii?Q?WVlkGiYo2ZVWKG03tCDWUieL53bc+uKZFygSn60B+TvH41XUUMbEboPcpItz?=
 =?us-ascii?Q?MkPPN1Iw0ouI80gWLdl2P0xTs2/jbEPWcdSoIE6ZYIUO33sDi3wdOo3t6Xgi?=
 =?us-ascii?Q?R76tpQV+87ku+jq9Qpri5f0M3jo9lxEUNujBasXFDQT2iOHTA26Vtamnf6q6?=
 =?us-ascii?Q?2lVsZ81MeiA7alinWaYzshN4y96lrgLYFN9XrbuiOHBg5TIjuYo2SYQ9JfzY?=
 =?us-ascii?Q?Ky6MIcwpouYzyjfsEYmDPsPjtRZXR+5yysSLsl3kK7l6Qo0csPH6uW3AjF8R?=
 =?us-ascii?Q?l3mP8W/oYDFjg6TLp2Ldi4NC1x82JiNdtn1iMyoY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02606b88-8db4-4400-9c75-08ddf7a08ea4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Sep 2025 17:18:31.7909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FFlnj2qigPw7px8ne5F/oIAjGOvN6EvZmjTsbTbz2zUORBTh9IhSOBah5rd2+Y0Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6358
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EBC5B40002
X-Stat-Signature: g3uk8mahzj8zirehr76cwwmb4bgebke1
X-HE-Tag: 1758302315-649073
X-HE-Meta: U2FsdGVkX1+KnbXKtHkuZw4FxjHFugKEpdXCafLoMyuWjvLdikgpc1+mxP5FGgGCgrRKP2Afg1cPUz3assgAKtKvufBJ9G5whVIWPrJKrLOgeqITi9yK4mid1Ud6SlxjXoBLwGk9kdNTKGMazRrmN8B4vEc1RSxSzBrBhtP6QWLoM36FBp8PG6AYzCf3O1b8nSQMwnHsNChLYiINEsTkZOFIQFKv8u9yDPRlEKvFMeV6LWtNd72lh+tM8E3NoHp+VTXyF2V0u/nXwhYcD93VQtF098hBdbX8TIeyuXiWa3lHIlO65qpwxo3u7fUjvKR+NceDh4bE8RXSwDQTxCSkOF2D3eJjN0Sgd99EYufVNT0JzyIyvioy1yTR+7/7NbzFhovzkv2306giGb0xkf5hvEQie9LjgW7uMWDtR9vq8a+6YzROvFraCPphtjUHOcWPApdDgdOy7qfMm5BO+vzABakG2Jd/acDhEr2XymYgtWWaJJj7sgU9HAVWN/zIk4nrMtOQfmkBT8TNNUsacUx02C8eoMQQyicjetXu2Oekh+Msfno9nzpdDLbHWZ2uIvUkXvO6EdO6KzreB2hZoYRXS6Po3Iwqj3kF6G6owKDHdP0XizpiYNfQ1z+UU97C7nqXPS4Idrggpbl8qoZjKLvywYz7Za+Q0fsjjmElgLaRio8+8uBq03xsy1sGeNvo9GUyQ+2AaOUKk6jaaQ86jxEDIc8IyqGQ8JCzw268w0ExucfN0qrcHY6SVAkBu/ee9QK/jBcRzfU4dH5BKHmGd+H4QfNHhPjFsSmvO5xWotX0nrUee05q2We+cUiGBS5DwWZjW6ZTeqC70W6+G4yxPGofA/wffORuu6nkK4+4N2Nk4pg1DFqG+bex4EZjbWv1YciZg1KS9yqt2G5MN0DZie0IfClYw3wet5XPEPRdjn1KCjpj2ucx+GXoGwcTzdvUpO/rbjUDmMXVDTpV4NIaQl4
 Dtfrlskg
 9kzRzma1saIv0Wsl+sk5qgl81pbXk8bfP76UUFyEuJPIYhNNlwLko9rA2N4WQc4qcBYrSL+iBvZL6WMd8T15FR7d9t1QHzftP/dQIod3AUpBzLf317OhzfnlvxHJ2Xvs9ePJ1oxsEhbJDIFbaLec4BArcHXopRIUlAhK9T+zNPzLSElx7caOxikNvYZoH8JnpuhDIllHDovsZ7hHMEsLVZVAJttIyfMJf0RtDwKN9bftEWAlWzCScx3opKVrKDAV+lCG3DAEoGvHPT9y5N9KIhcjT1mT9PTcMs/RYZmv/NGTltHHMeGip9J4cO9Tp+IwwQGFbizB9d+WZOYwRBo2Vp07oFHQ49JCfjl75ijIytarSQkpeScnK6qL3yjoiCtNFqcjIHdG222YbY0rrrYZZH4D1ydPi6OdG5NxHvIrPdzxBuIxOgOFs2RUd2Qd33PelSyOKT7iozyREGaiak1ygSqRloBnbGjM7ewslHFlEgdWg4ZERG0mkMaNE9z6yj0F2U9E2egYAmQwVvs2WRrJMUweEWMCEz1Z31UgrdljZzi0OfQlBDXnkTKmHgVEVOYoj5vSJqhQHt4lJP0jsWL1okLFOBADOZi32cOzqrqh8WRNQmvGDXsMtpxbT90hHJtWFrnaVypuP6aFY55RP5zTn7c8aEeq1sLcxWhwgFd8wzizupppfbQ32Ewzjea6SQJuoVqHgUdFa8oaootcebKSL71adh5htrXZtr9ZT2H3B8R8Yjas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Sep 2025, at 12:21, Johannes Weiner wrote:

> On NUMA systems without bindings, allocations check all nodes for free
> space, then wake up the kswapds on all nodes and retry. This ensures
> all available space is evenly used before reclaim begins. However,
> when one process or certain allocations have node restrictions, they
> can cause kswapds on only a subset of nodes to be woken up.
>
> Since kswapd hysteresis targets watermarks that are *higher* than
> needed for allocation, even *unrestricted* allocations can now get
> suckered onto such nodes that are already pressured. This ends up
> concentrating all allocations on them, even when there are idle nodes
> available for the unrestricted requests.

This is because we build the zonelist from node 0 to the last node
and getting free pages always follows zonelist order, right?

>
> This was observed with two numa nodes, where node0 is normal and node1
> is ZONE_MOVABLE to facilitate hotplugging: a kernel allocation wakes
> kswapd on node0 only (since node1 is not eligible); once kswapd0 is
> active, the watermarks hover between low and high, and then even the
> movable allocations end up on node0, only to be kicked out again;
> meanwhile node1 is empty and idle.
>
> Similar behavior is possible when a process with NUMA bindings is
> causing selective kswapd wakeups.
>
> To fix this, on NUMA systems augment the (misleading) watermark test
> with a check for whether kswapd is already active during the first
> iteration through the zonelist. If this fails to place the request,
> kswapd must be running everywhere already, and the watermark test is
> good enough to decide placement.
>
> With this patch, unrestricted requests successfully make use of node1,
> even while kswapd is reclaiming node0 for restricted allocations.

Thinking about this from memory tiering POV, when a fast node (e.g., node=
 0,
and assume node 1 is a slow node) is evicting cold pages using kswapd,
unrestricted programs will see performance degradation after your change.=

Since before the change, they start from a fast node, but now they start =
from
a slow node.

Maybe kernel wants to shuffle zonelist based on the emptiness of each zon=
e,
trying to spread allocations across all zones. For memory tiering,
spreading allocation should be done within a tier. Since even with this f=
ix,
in a case where there are 3 nodes, node 0 is heavily used by restricted
allocations, node 2 will be unused until node 1 is full for unrestricted
allocations and unnecessary kswapd wake on node 1 can happen.

These are just my thoughts when reading the commit log.

>
> [gourry@gourry.net: don't retry if no kswapds were active]
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/page_alloc.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cf38d499e045..ffdaf5e30b58 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3735,6 +3735,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned i=
nt order, int alloc_flags,
>  	struct pglist_data *last_pgdat =3D NULL;
>  	bool last_pgdat_dirty_ok =3D false;
>  	bool no_fallback;
> +	bool skip_kswapd_nodes =3D nr_online_nodes > 1;
> +	bool skipped_kswapd_nodes =3D false;
>
>  retry:
>  	/*
> @@ -3797,6 +3799,19 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned =
int order, int alloc_flags,
>  			}
>  		}
>
> +		/*
> +		 * If kswapd is already active on a node, keep looking
> +		 * for other nodes that might be idle. This can happen
> +		 * if another process has NUMA bindings and is causing
> +		 * kswapd wakeups on only some nodes. Avoid accidental
> +		 * "node_reclaim_mode"-like behavior in this case.
> +		 */
> +		if (skip_kswapd_nodes &&
> +		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> +			skipped_kswapd_nodes =3D true;
> +			continue;
> +		}
> +
>  		cond_accept_memory(zone, order, alloc_flags);
>
>  		/*
> @@ -3888,6 +3903,15 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned =
int order, int alloc_flags,
>  		}
>  	}
>
> +	/*
> +	 * If we skipped over nodes with active kswapds and found no
> +	 * idle nodes, retry and place anywhere the watermarks permit.
> +	 */
> +	if (skip_kswapd_nodes && skipped_kswapd_nodes) {
> +		skip_kswapd_nodes =3D false;
> +		goto retry;
> +	}
> +
>  	/*
>  	 * It's possible on a UMA machine to get through all zones that are
>  	 * fragmented. If avoiding fragmentation, reset and try again.
> -- =

> 2.51.0

The change looks reasonable to me. Acked-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

