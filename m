Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58CA9CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:09:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7819B8E0003; Mon, 20 Oct 2025 16:09:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758808E0002; Mon, 20 Oct 2025 16:09:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647848E0003; Mon, 20 Oct 2025 16:09:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53CDA8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:09:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BBF0413A6DD
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:09:42 +0000 (UTC)
X-FDA: 84019583004.12.25C9309
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by imf21.hostedemail.com (Postfix) with ESMTP id E1FF81C000F
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:09:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ubITTw5/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760990980; a=rsa-sha256;
	cv=pass;
	b=4lZX2RHhZE2yZsWUauQtIN75ctl+g9GHwDyJRNQemwaZHl6L5P0+he8g8PE6pB+FaADFr+
	ALGQmeF4DzZGKXsO5GavhhsNUT37TcfeqExW93qAKrhfjolGz7DOnt/BTdX8QbSFqHvoX7
	sdQxRdt+xho2T7IHAF2isXbTTpolRrA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="ubITTw5/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.60 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760990980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSC6o/u4jaXab6iUZ9T8J93E5fJty399aHKHubzFWdQ=;
	b=ucwsOPsHwKkOA07DWdiD5eJ5T9flbdN6BSlvbqYEYxjsXw+M2bCE/cJKz3kIwDoRHulfp/
	YDQ7FbhiLDrzC56a+VT24NgUn6qO+G4n9vumLzQpezLC2afaEJ5gKn1Hrc+28r2V4wFV/h
	XTBcuSzqqnr87wwhgmyAX20MbHRlkNc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oKYIfgYoFpYJ5t/nduQNZQoNFM/ZIlO86R9dggFevVG5g8/NeXAwiHqkJBkvFL/Gaif+QFcvyLUL/iC9R9RCNxpRjKw66OoFaSntJ2kz0eioZ2AtxnK2WvxorHdQ2ZTrLkZSwJQ11YzI0CWo1bcWNJYah+zjfxc4BF6UJAfs2sCXGJUSSZ6tU7ft3zk9tmei30Flz34aAqDNBAikRileXLGmMHQ8v1UV11af2ruiv70HCN6KRYDY/PDnjeTlnpZkJn3svNB4bEBKKe2/reT4dxQn/GuGIGGceVLQIGDznsGcGzob0ibBA4eMWBgRJYWA1BTbd2QO/gFdIOug7lOJdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSC6o/u4jaXab6iUZ9T8J93E5fJty399aHKHubzFWdQ=;
 b=GWqGSsx3JFyor4x3HEueb3/yRGhHsrhQ988+q5o9cGe9lJoK1VC1hEPFOvGaTZQ74WYM98UqHZdHgtaV3S/cNLnPmajbzFGIUh/F3woWPjrBgpY/wnm0lAQ5X8bUkz9AKqroZK7+K7t4+V8NAGmV/bzNJAYKWPpXk6hO3Iq/MfrPdLgCxW2Q9k2IL/ZQqy/lHWfTmBIMaMzad54d6DnMLwI2jT6gKPJQahcw01IhmXKA/8QEto/L9msEhDPzMJfS40rV1axIHnyajpfFooCxkfq0gjnbDXUWB4z6gbnK8hnt4EJWcBIJowly/Af0TTMhFHbcUMhSaviJg0xrE7+Oag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSC6o/u4jaXab6iUZ9T8J93E5fJty399aHKHubzFWdQ=;
 b=ubITTw5/RyEyDLovBvdOjRfnKA5EWSDJm+Uen15M2NEads93k8yzJEDZKV1I6yMOQjp04tDvoB4bCmVW2MZ8SDk4uepYufOjT2JoJkPXGNEFhZ2B6E2K1z9KSENgkIahRfU87rpoX20Dj4O2cItXpyAwAL98PJsR4jlsfXsuqE9qxc5MeE0XrLNZE4pClqX9rg5dvteJ5p9O3oNnkdXU4jTHoRN0p8/c7C9O0uDxlJFA9e6NxIIgVf7WS6h3NG4MRUsn1nJh5myGP7xypwPP/ERDsKnLtLJNzOGixM+v0sT3kcR/clhZFyR22+HeO2ZmWNRGVvJ3ruVvsb4o8hIMtQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM4PR12MB5889.namprd12.prod.outlook.com (2603:10b6:8:65::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.16; Mon, 20 Oct 2025 20:09:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9228.015; Mon, 20 Oct 2025
 20:09:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
 mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 2/3] mm/memory-failure: improve large block size folio
 handling.
Date: Mon, 20 Oct 2025 16:09:33 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <3AEF55E9-5E50-4F4F-92B8-EA9955296BFA@nvidia.com>
In-Reply-To: <03be502e-0979-42cf-a6ba-dea55c4ba375@lucifer.local>
References: <20251016033452.125479-1-ziy@nvidia.com>
 <20251016033452.125479-3-ziy@nvidia.com>
 <03be502e-0979-42cf-a6ba-dea55c4ba375@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR01CA0045.prod.exchangelabs.com (2603:10b6:208:23f::14)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM4PR12MB5889:EE_
X-MS-Office365-Filtering-Correlation-Id: 48a2a5a8-e6ee-4b8f-c33c-08de101496d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LGmkY8lLNVCxiBuk2ycNPk598/gov1ytR8bGCoYa8p6h6s6Z3UNkR0qpRuM6?=
 =?us-ascii?Q?/OUet6nwdLgZC0zH77XovXKLLUbKN3x3UqMWan2puQzePPZ02DMsXddw4kfV?=
 =?us-ascii?Q?HtA8J5spddWdECAx730unF7B9mTDLWW3eyxqrM2E2rHyLgc1kJTvV9qOmoOp?=
 =?us-ascii?Q?FhCQPlQu+K/u9EWc8QWe38kiykFMY/DopZF8C0PjTdyHi0vbyCjePVJ10Yk3?=
 =?us-ascii?Q?b2kFtzv73Si0sOp7IJ5wMC2ZK6Jy9mEC470blscHppF33h/G2hjg8sBKKi7Z?=
 =?us-ascii?Q?/hmixP9FSRpleflb5E41jK/ZwLP1ILsUKEMBDlm97eROklt4wv9VpqMqLrOf?=
 =?us-ascii?Q?ktHtu4DMk5rRO6bhnaWZhKMs0q1iumDq8s0t1O4vHgbpjUNBCo2Jh1zj2VhX?=
 =?us-ascii?Q?FbCAmih7YREGUi/Ho7/Mkc5AE3m68Ereo7h5LKhnvsKuTahmTeToYc5iL/3D?=
 =?us-ascii?Q?MrXAmkg8o86FBI/db8CyDcAY989CjHSWlXS7fyjIZ8bamvi/W+lX0OFINr/z?=
 =?us-ascii?Q?u7vIdKkBWyhVyw1VYmoRp26DEH+XTfhXqzVlFxtJOqC7iWP0Qx16UYmRvnXS?=
 =?us-ascii?Q?P7hZHaHX93DqdNU3BU7h75C2XZA7AdRldNkcgL7aTCk9UOgL5nRvQ+kJWlMf?=
 =?us-ascii?Q?KbmJtNe1p2HWCdYBb+ZYBZYZxskhUODl7JjVdWkHPIwDaJarkasBC03Tbob2?=
 =?us-ascii?Q?BvZPWXFBeT5zv+JuQb0VAIKE+WAHRBkYr4PF7VSvFY1Ku9wH8wDgFem6SFuk?=
 =?us-ascii?Q?e/BRkdtSKHcxBJyb4P0pUR/6/aGzOqGEsaRGEvaOY8be2Jtq3m0xsnLl3DZs?=
 =?us-ascii?Q?5Ph5SQ130p0H2SmhErZpriQIg6R4N//g7rUW0Ztv1Yg7kfXNMkbZZf8qdawJ?=
 =?us-ascii?Q?OUfb3n6LICZKSRIY8BXvCAUAbHs1+bYKQyeyD87obb1TtlOF2p7sf/Rz0kx/?=
 =?us-ascii?Q?9GV/0e+GTfR//rtRlqgqmD4kiH43lp0N42MwAyi6pMGm7DLoJVv6PS0GW5MQ?=
 =?us-ascii?Q?RDYeKzDNNE2TXbAiuO58d10jBrf2GVDrcqP9h1eEs0O7HT2eeL05ybrG/mIO?=
 =?us-ascii?Q?gxqrYRVA/p5mhzgABAwXKVn6kNXHhCU10PiKEeTGj43JAYIdMCZgJTUmv7cX?=
 =?us-ascii?Q?bZps/ZUTr12NqnucQWgGU+C/9hxZxPiE5GuD6zCHeVkgEyxufYO6Cdc8IGfN?=
 =?us-ascii?Q?n8ljBPB0iqFkDItRP90h/ln5YeRnjJWmCus2jKzrkzH3KuduAzOVsomLaDdr?=
 =?us-ascii?Q?wFSOwLMfzhsPozv493XfeYhSEdEMXbOXP9NuU7wRdvr0JK3B/LVXPJUYDhFX?=
 =?us-ascii?Q?nfc1hhMIG82IaUQSH4FyFxOypfpuWJ10V39kSh+1NR16ZJ/aVgLeupdt1A68?=
 =?us-ascii?Q?5zP70ZOF/EfhG3NERTwByZUtPdeMsDrFGk4h0qwAB4m1d5r7WYrbM7ayqrBc?=
 =?us-ascii?Q?CB18fOFVq1NFRYDduQhcn/U1fRrfn9WF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dNaeQL2keYVp8tim2UUzOxmzMdPRi98Sj43iwEHOwhLuypQiklVyTAn+jqad?=
 =?us-ascii?Q?wqjbw77x4D5hadb2c5slEFxmskIM3FUaPr9/oRsVtXXC96OQDqdEHdEIY+rR?=
 =?us-ascii?Q?j5tTApST5MYOx7tHIbJmvIdY6ThypH6oH/NlTFrEZqhz2RDZtd8XSRexEUS6?=
 =?us-ascii?Q?/jLQgaffLzkpDHViampyBpf541wXVImQmzppIgc2TjGv6a1qs8KRZzI0xX7s?=
 =?us-ascii?Q?6T1rC2OepnjQqqJTpurD1L+qNrkDLBGTlMfClm6vHVYSC1icU8bV6WNtw0WH?=
 =?us-ascii?Q?O7AxaAZMPwUqZmOk0pcCQ5PgGWnb2F1RkDqTgCjbfwTEiGI5uXI9RXIVFi9E?=
 =?us-ascii?Q?90PIb0lF/QUk/lHuOtjPE4Ij91aF0kQZ5500bAxWJS9JiCKyfF2nBWI2JQSS?=
 =?us-ascii?Q?ekdz6dDzO/ra0QSqKXF+hu7F6Q9yatYWQvqdW7WCDIQKt/vDOEEvTM7O82hn?=
 =?us-ascii?Q?qg6GCh15fuPihfcGSxfPGeh0fkkTWYSzlUQPnW07ErVy+E5wM4ebVO+nIZSU?=
 =?us-ascii?Q?RYSQeBTLCDMprUeDtlmw3g5Ji36kbjGPHuV65alyeCdgjeJgfkJ9o5hK1BR8?=
 =?us-ascii?Q?vA6nit5xiNawfFaMpRTJvXTBnzjyIwoNAgGK2QVM/yCnUvcWEZzoyJ6w0cKp?=
 =?us-ascii?Q?hVr7Pv4AglZTIjQDt+TzPCZ1l72C1wJ/ycHTa+Li+tkeaXMvaViMD9BQ/bo5?=
 =?us-ascii?Q?6jPnia3m4Pvjktpk84P/iKghThlnCyDdHf3VzFq0hxugT7Z0r6rv2LGxVHiJ?=
 =?us-ascii?Q?kBNzcU4QaDYNkLNTpyzEhAiRq+JzKUBMuDRIAjJmsd8NdOltLqfHek/Ze8qB?=
 =?us-ascii?Q?3lkRGLKciw8xgmp8l5oavQTGr6N1W29tbQiC+EMpIXFVq3i0sChjmqQfqt1p?=
 =?us-ascii?Q?endYs3zNkxww8bGA2aP6i6iI9l7KUvNrCQD1hHAAgpeDf7Qbs1qrY95A64pR?=
 =?us-ascii?Q?NZLlZMnQ9x7GH33Y/8x1OgZhv+3k7DRiNqENE2OLNsyWqpuuLZcNtIxMbqA1?=
 =?us-ascii?Q?ihkZWxspaf5Q8zSMf+2cuisRUkBGz5TSyiNbQTZ1GoIqZEitXRWEP9l6KHub?=
 =?us-ascii?Q?BHOaHe3f1VuzXSIm13Rubs0gM8bk1MpC5Ho03t5x1U0cPMh3ri+r0/pe07Xb?=
 =?us-ascii?Q?wL4JvL/PUKi8BiyLTyDYvq2CQNTAHg2KT4wxKPnuwykyQg3U7zdfrj4uqI07?=
 =?us-ascii?Q?OipGqiyGvyE8W6ZdneTOCYfrZWYe+N4QhgCDDfTBtHf9hQCAwlcvmbfEUciX?=
 =?us-ascii?Q?ta6MCmxQG/bxBJo1xwY76RLnJ4pYm757xT124Ff+u6ZUxoyBtP+wI0XPmI5h?=
 =?us-ascii?Q?hQ74OFo6gS7ag9dwGplr4EiYYWE1Hqc4P5UI5G91tM1E3qzNRtjow/UEUZtm?=
 =?us-ascii?Q?noB+Fu5S8JeEUZeXQcT84uQaVhx+vjnnpHgYHihnDd3xYixkfoVsBmVYSMZC?=
 =?us-ascii?Q?aLtn5jNi0mU18EpBe/sVYUoX7x/3/fh7An9lmN02/ADbZCrQTzpjZpo8orP8?=
 =?us-ascii?Q?Z1/8gUp/eJGrAK4Ry4/xXc3Ew7rqKkWoJX8j90Q5f6POuRQnKl6OtmNaWDUk?=
 =?us-ascii?Q?/sdGClyK7Ar3Gw8LxGSGyuFqnrQyLGPEbGaF5YCb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a2a5a8-e6ee-4b8f-c33c-08de101496d8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2025 20:09:35.0637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2D1ebxRwjuXAztTa6iEHcAl2MtxKvet+GLguKo5Cth+0XokMFDmAmhZtZwO55qYf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5889
X-Stat-Signature: 76xb8bic7ap4bf966ajqqbkyd3k13tz1
X-Rspamd-Queue-Id: E1FF81C000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760990979-837231
X-HE-Meta: U2FsdGVkX1++3LIpM1XduXcg0AuNY9klVWUu9dsWdhHvju4I7qmgGow+tm4OZHBU5lo1yNMgGFkLpe0uVXKexe7YLOQAsX9XJ+gfH7RaAhWBwTMwsHHgzyjmctBH/wFPCrNNAXNvOewNjvkzL/IkuhYnPQlAEm+Gg3oQR2mjBp0kHzzwez0XPgCAemYN9OqMtvgbpAB9oj3LXxiDE0pnp3uwdwOTAkNlk9AvWBRhi3l0IwPnfnSwN3NzvCrXRmoKrP/G1F9ofwSpSDSFn+3AsYHVS0oHleSisbD3ciFdz1ZC2QHFej7P0IUnkWdqzuW0vh8Y8CP63jhxn8hybgDtsSfGiMV8mU7184Gyzhi1pu61sx30LM5hS3CtEXiT5zwMxouubonzn5vabqlW+gNQ5fPSEtNktLZo4HJcjzMxMG84tAz5Ou4uMj79KNQAZwowCn+H/c9OuolrtpLWtxplcDFvZVk3UTjg6thWg3pjPUeH2EjAxcuGyID0tOGEwP3wMf2jTiP1yjYdECP0X7MEm232PeOV6+Nw3vEkI95wpKR8Ugh7SiXq9EQAwXrV/FvaD/oWWiN6S8RIBwOpylzqHD+gzbqhR9TSFicGtuDKSEPDJjJuipyG1ZS93ctrphml7nsX09+9nUx02EcoVHQXYn8z27RmTx/vjQAcOSzEjwnw3qbgJ3238IHZZYHlC5kHC+bhHPM0zwWpJCZtsHsm9wnWBSj3a58Aw9xa94OCILJiWmBkEd8qv0mMSyl/7VLziRhqT2Ic/Sx05uKHqv+wDIurMCs6ll6CMALEpSRw93ROjLXN/wLLiuueXg0y03xkzL8NnVfG9cN/CoBanYyXWhCsMN9LbrDJJZuQOTuibN+HZ0Q82y/xtA+9DCHk9yLP47vKrkD47SO3MMqX71kmm05gKZzyC+su+XJ7OuIG+VNWz9XCaI4wKr02WIkuG8IvRw1kUXsWR693HfX8Kpv
 /6RtiWRD
 uzqolYvlQjpI2ubYcFX9l9NhqAARMPn0HNBFoBTL/OtmBrYqY+8LKOKNwBSTenmtpi2YCzuU+Ba1hU3hRpjBFOlN17VStlVXZh1Ou4KD/eWUQhhb72W8byMwAPUeaYQA1JJS4gZKD0VmjHRAEdrZacXepJGoKxXO54qIX06STjsDfFcv3QiHrl1m80jXfyg1tyhsGlcf6u2BrpbsQ3g1fG3C659dINMtnsYWrvWvvIUCTzduYhkryexRAIImYs5Ox0R4FLgNsxnY0hq0MusKTgxNdI08Okiqhj9qhqfWDjAlXvfxJt1dMeWnYC6JG5MtSB6vhAGDB/1yCflsTDall+QuoCEteKTIkrqeA5V5GheCtEzdg9yyqBWt7ti+QBGEhoKPDSt8aSnHyJCu/O6JzNLr7VCtzoUGQbQS9nbWk1my4ZcLWawNwmImLGjyd0ytaxM2/OYIprAUL+p6Ay7U40HW3vdsYXjO1F6V3oP7jpM8iR7lNVyOgYFjIMaoI1UkIBxYQ1jkmvG9cLcuPvqV9mQ50q7/iDA7P5i0VQc8b3qEvouZnplAi4RpgLcz/twHOHp4BTNN6jYzYAt4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Oct 2025, at 5:33, Lorenzo Stoakes wrote:

> On Wed, Oct 15, 2025 at 11:34:51PM -0400, Zi Yan wrote:
>> Large block size (LBS) folios cannot be split to order-0 folios but
>> min_order_for_folio(). Current split fails directly, but that is not
>> optimal. Split the folio to min_order_for_folio(), so that, after spli=
t,
>> only the folio containing the poisoned page becomes unusable instead.
>>
>> For soft offline, do not split the large folio if it cannot be split t=
o
>> order-0. Since the folio is still accessible from userspace and premat=
ure
>> split might lead to potential performance loss.
>>
>> Suggested-by: Jane Chu <jane.chu@oracle.com>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>> ---
>>  mm/memory-failure.c | 25 +++++++++++++++++++++----
>>  1 file changed, 21 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index f698df156bf8..443df9581c24 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long p=
fn, struct page *p,
>>   * there is still more to do, hence the page refcount we took earlier=

>>   * is still needed.
>>   */
>> -static int try_to_split_thp_page(struct page *page, bool release)
>> +static int try_to_split_thp_page(struct page *page, unsigned int new_=
order,
>> +		bool release)
>>  {
>>  	int ret;
>>
>>  	lock_page(page);
>> -	ret =3D split_huge_page(page);
>> +	ret =3D split_huge_page_to_list_to_order(page, NULL, new_order);
>
> I wonder if we need a wrapper for these list=3D=3DNULL cases, as
> split_huge_page_to_list_to_order suggests you always have a list provid=
ed... and
> this is ugly :)
>
> split_huge_page_to_order() seems good.

Yes, this suggestion motivated me to remove unused list=3D=3DNULL paramet=
er in
try_folio_split_to_order(). Thanks.

>
>>  	unlock_page(page);
>>
>>  	if (ret && release)
>> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)=

>>  	folio_unlock(folio);
>>
>>  	if (folio_test_large(folio)) {
>> +		int new_order =3D min_order_for_split(folio);
>
> Newline after decl?

Sure.

>
>>  		/*
>>  		 * The flag must be set after the refcount is bumped
>>  		 * otherwise it may race with THP split.
>> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags=
)
>>  		 * page is a valid handlable page.
>>  		 */
>>  		folio_set_has_hwpoisoned(folio);
>> -		if (try_to_split_thp_page(p, false) < 0) {
>> +		/*
>> +		 * If the folio cannot be split to order-0, kill the process,
>> +		 * but split the folio anyway to minimize the amount of unusable
>> +		 * pages.
>> +		 */
>> +		if (try_to_split_thp_page(p, new_order, false) || new_order) {
>
> Please use /* release=3D */false here

OK.

>
>
> I'm also not sure about the logic here, it feels unclear.
>
> Something like:
>
> 	err =3D try_to_to_split_thp_page(p, new_order, /* release=3D */false);=

>
> 		/*
> 		 * If the folio cannot be split, kill the process.
> 		 * If it can be split, but not to order-0, then this defeats the
> 		 * expectation that we do so, but we want the split to have been
> 		 * made to
> 		 */
>
> 	if (err || new_order > 0) {
> 	}

Will make the change.

>
>
>> +			/* get folio again in case the original one is split */
>> +			folio =3D page_folio(p);
>>  			res =3D -EHWPOISON;
>>  			kill_procs_now(p, pfn, flags, folio);
>>  			put_page(p);
>> @@ -2621,7 +2630,15 @@ static int soft_offline_in_use_page(struct page=
 *page)
>>  	};
>>
>>  	if (!huge && folio_test_large(folio)) {
>> -		if (try_to_split_thp_page(page, true)) {
>> +		int new_order =3D min_order_for_split(folio);
>> +
>> +		/*
>> +		 * If the folio cannot be split to order-0, do not split it at
>> +		 * all to retain the still accessible large folio.
>> +		 * NOTE: if getting free memory is perferred, split it like it
>
> Typo perferred -> preferred.

Got it.

>
>
>> +		 * is done in memory_failure().
>
> I'm confused as to your comment here though, we're not splitting it lik=
e
> memory_failure()? We're splitting a. with release and b. only if we can=
 target
> order-0.
>
> So how would this preference in any way be a thing that happens? :) I m=
ay be
> missing something here.

For non LBS folios, min_order_for_split() returns 0. In that case, the sp=
lit
would happen.

>
>> +		 */
>> +		if (new_order || try_to_split_thp_page(page, new_order, true)) {
>
> Same comment as above with /* release=3D */true.

Sure.

>
> You should pass 0 not new_order to try_to_split_thp_page() here as it h=
as to be
> 0 for the function to be invoked and that's just obviously clearer.

OK. How about try_to_split_thp_page(page, /* new_order=3D */ 0, /* releas=
e=3D */ true)?
So that readers can tell 0 is the value of new_order.

>
>
>>  			pr_info("%#lx: thp split failed\n", pfn);
>>  			return -EBUSY;
>>  		}

Thank you for the feedback.


--
Best Regards,
Yan, Zi

