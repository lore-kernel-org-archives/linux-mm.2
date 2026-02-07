Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E00EE0AE7
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 16:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40EE36B008A; Sat,  7 Feb 2026 11:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC3F6B0092; Sat,  7 Feb 2026 11:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FE36B0093; Sat,  7 Feb 2026 11:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12FD16B008A
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 11:12:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C178B9956
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 16:12:55 +0000 (UTC)
X-FDA: 84418154310.21.0C757B8
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012037.outbound.protection.outlook.com [40.107.200.37])
	by imf28.hostedemail.com (Postfix) with ESMTP id B68C9C000F
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 16:12:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dn8c9WwL;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770480772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWfo8FCUI3Gr0CUpGO75l6H9Efu9SGGFlC4+7ixLP9s=;
	b=2IiNqKgYcWS19yktEYCaFdOQETQQJ0o+D4cKI7uk4SjIGclo3hqKc6DfcfzBWRb2U41p5C
	13/bSzHusRNfmcms1zxjO9oBUxB3uhUnqwgVWHjlXbnJvi9O2MSPVr3g2Q3pkvJqtbVMcp
	L5FcgbwUZoYssSlP51gsULxuoeffEig=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Dn8c9WwL;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770480772; a=rsa-sha256;
	cv=pass;
	b=TsiQzykGMj43nngLTTE8V1vLO8+3OXWFINT6j7yolUYVvBYgTZt0iL0Zo0L3kGUGmo0u2A
	ydaWNgt5uk9fzPFxUsT54xtbmt4x9SrE7qOgWncvntBbrzKOseEVKKXv2+02NCF2/jq2YH
	k4gUE3fJc0Gce27YEIHdajMW0oLQPTM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FvbmgQ/2mW5Ixt7RbRvvbTysCDft2wP41opfFc9R8QfEILheZZU3Y7vl34ezB2r8KnlNvhEZXE25yBuRFwp/HZTUDu1FFGzGpPHJWf4YeXuZLIHX0TUOQ6GqPmzyBrsoa15qbmY65KceaVP/M0a4X/Iz5pva6fzILinyYfrAVIV6RkNd6xd6xD4a0YHxBNdIu/DUuxQm/IxlsBo4p69sqa2sH1gXz1REt9dDq2irmn9pQZa7mZ46ma+qkPum+ZnwTWoeUBnj1Xnt1xMIIkHDfoIzUDSfQGYPdZnHXwP/5tH4YPmHXpbIUOtNAL+U7EzUvEJ0Fvs9YjWPUVXztLVyHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OWfo8FCUI3Gr0CUpGO75l6H9Efu9SGGFlC4+7ixLP9s=;
 b=SPQF5Xuww80XqtlEyry+ji0PjCUxvHBBJEk0+5d0E8GdGoEx0n4eT2FTiGT2MfOBpuYn7x7wtmzq1JaDIZ98r6dFnWPK5cr1ptgsak7tMQqIe/x0EP2KPE/cSdJDkEDpFhgLwCBg/I7mL80c6gBe16nqGeT5H32M7vf1nK+CHtjx7UeQUEHXkUtHdzPxpn8MNbCnRSVTzgzFi5WyAcxJh2W2kZelnYRRqeG25DDFDrF2haZVp3hjGluQvOySk6NDlYYWmQ5Ih5sywmP7Gop1j6BMnZvdemGxdrCXCUD4OtdEd3z2uwtXO+ZqcOHmy97KNsvVp/Zopabv7sQxn2vsiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OWfo8FCUI3Gr0CUpGO75l6H9Efu9SGGFlC4+7ixLP9s=;
 b=Dn8c9WwLNf13OLEWyt2b42qfDjSbtZ8kOL9ugJTZPONCw0vzLGHBtjzQuS7XcVg7++adZokXBSKyy6E9by39L783wHopQTWOFZZ/NuBHxMHyXbvS23f6TAOdoQcuywbIxp2P95ervQmlK/X9b7e3fs4BnNu2z4+iAYQ/m9YPV7BbCLxic8emJHIOYPgdx8Y4G2f4He3xPoIbTwfv7vwQFBSpgNE9v+VLbOazwkCaqPpvSrpiU6MKAhHjcP8/TpZjE8lB5BQ/Q9H6Ua3mBAJwIwJdEMG80cQW34geCYmbolLmO+60Pw18BcKyBmKrwl9R6QWc20icMXuD7JqVOzAeNw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH8PR12MB9766.namprd12.prod.outlook.com (2603:10b6:610:2b6::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.17; Sat, 7 Feb
 2026 16:12:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.017; Sat, 7 Feb 2026
 16:12:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, ryncsn@gmail.com,
 stable@vger.kernel.org, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, mhocko@suse.com, hannes@cmpxchg.org,
 jackmanb@google.com, Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2] mm/page_alloc: clear page->private in
 free_pages_prepare()
Date: Sat, 07 Feb 2026 11:12:46 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
In-Reply-To: <20260207153716.59302-1-mikhail.v.gavrilov@gmail.com>
References: <17A126A7-BACA-49E5-8A89-F8E665981136@nvidia.com>
 <20260207153716.59302-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN2PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:23a::27) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH8PR12MB9766:EE_
X-MS-Office365-Filtering-Correlation-Id: f36b6b8f-9ef4-48be-8e5d-08de6663bc42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7QVn9NKkmLFgG50x78n82E7ELQsPqZ9dIU48Jl76+wBEBn0hd40wIp37c6wF?=
 =?us-ascii?Q?YnXElTJ+IXYLwnyPMdA25eSC9vf+P4KzhS8edHRBOQr36m3jDI4AAkv9hE5z?=
 =?us-ascii?Q?/dmubmLJWJQrdJtlXFKje5FqRdD9I8pFvbh8kIDy//xDBr0drqOkUOYhFGqV?=
 =?us-ascii?Q?vUiVorOGTDbAUt6N0IXpkkeKbbJFvEAoZPksuAsY9JgasnSAEz8J/N8d9u8t?=
 =?us-ascii?Q?v7iZcCh3AquRiMEmvaNA3hCb2cXqccI54XfDohMlVtIqRqtblSGnsH1ybxQ2?=
 =?us-ascii?Q?0ILlUISpiIPMSimMVVkFQKRW1bejo+86/87ONIe+gy5Vhe5WrrUbGHTkufwm?=
 =?us-ascii?Q?hFkcQmKqGBVc97pCUXn3nEYL/H3Ul/HujSPGoXmZnZ2eY8g0UwttoRbNz5ro?=
 =?us-ascii?Q?AKuTI4uaCy4QxKrUzieikE0lhA1d4E7DLqaPs37QABRLLuM4UX56IWshaU7E?=
 =?us-ascii?Q?lhfl1+JAMgeWj7o8RjqvW36peFLmbohq/D2+kfTipquzpoX9UXDTVZzqvJ8m?=
 =?us-ascii?Q?sCcfZgEr1R63NHqOAnph8nI2+NnGRok5baKlWzB0xaGvrZwa3bqV9RuXRQbC?=
 =?us-ascii?Q?ultw6y5W1MOryoGMKiGevbxYFO/4L5rJXzQD34PC9hUNNPxTQUiE4O++qiS/?=
 =?us-ascii?Q?I7qeJn2XUqNvqyeOrHu1BPFbpcQFbkDqugwrMcO8qL4yrzIl79srNHkP5qjr?=
 =?us-ascii?Q?B9MeioK7qtkAEy9kN2Tu8zovor12EcO3sC6jtHR2ydezk+oMOtwV0TM6sv6n?=
 =?us-ascii?Q?zq/2dcR2iObdMllV/hg91EupQxGNVlGSctITTX4d9mF4/wGOdbG8+SsDE5fR?=
 =?us-ascii?Q?mzVze6mBFYb208Z0zOt/otvj7X59M5jU/tybXrnI1mjrkDf4KqZDIuGsgLtY?=
 =?us-ascii?Q?DVuqHRO66j++bhVaGqT76iymsyJPnLvREHxu7HbbiNKfr5ES2iVpYA3tewzA?=
 =?us-ascii?Q?Y5MlIF/sH2GwZ12onY5a1kZrQPRxODbwIUvUI2gYTGKP2yFQcQ9KPYCntH6j?=
 =?us-ascii?Q?8+8+unrpyi7Kwbz1VOFVoxk7neNwrhOM8Nu4gXnTjQ5tjnp7UrDkr89z5b6x?=
 =?us-ascii?Q?51w6xPdgGGKtl0HylZcjPwCp/VBZFMdy4w6T3vdJ8QNEMOP7VI3+eLDRv/7o?=
 =?us-ascii?Q?Jya26xqU3gkrrb8Io/AKMBQOpUdPIe1cEQ8G6+U1GtUKe2Yy7r0t+kSf0puW?=
 =?us-ascii?Q?gJFc/jvucKCNPe5o6rs/9ZH4NqQIM5viAxSjGREHsVXnjeYT2F8mAINXdvYh?=
 =?us-ascii?Q?YcNJDAS884jjPSuz8XyQY2DoHeRH6w+iqc2HHuU5uuYLpvYxSGxSznQBhMm8?=
 =?us-ascii?Q?WcR4OsPQnD6yB7vj6rSF4w/Zcug2qCDpbgYIxbQQlM07/Of2mlWZbiTgB6Dz?=
 =?us-ascii?Q?wHheuwET9vTLHVQtwNLIkd/+KVJMgt1WrCUYSPgaD8Mqo+V7b2Wa2otDQVBc?=
 =?us-ascii?Q?MYkX+gCMVOL2jC62r89UcDK9rZ/+b7MN+kQSJn1m9eeLHw1/61X+Nl7gi4sP?=
 =?us-ascii?Q?349qVgn9zS3cwcRqVPrXghKbJSE4lFZmOGehGX76eUPmxqhkyVrKvd5MTBEK?=
 =?us-ascii?Q?uDpviG/JGngN2If3Vqk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sjf0O8XOARJhuQdrnTkMnbh4c8PRlDZoMhM4wQ8fyhjcftBNAyjocl7ZFPsn?=
 =?us-ascii?Q?FmorJ5fegpU7Y9fXeE6SDR/jx8xzfX3E3ES8zyprz9dnojJpLojRGqeLwVGF?=
 =?us-ascii?Q?AE5REgCvqVohzDDW7sNmFRhd78J9A3jv4/p2CecjYIjpq+NW16rFoxwB1cQD?=
 =?us-ascii?Q?eYfQQphStTF8hDjI2F9E5sBR7j8VOW0KNnBlQ/X+ugybklCyqmiXdW06adWa?=
 =?us-ascii?Q?hTEVfxEho8Q9d1GzkpluTAjx2oFPxbtUPUQVIKqw6n8xLogbanSm51TZOB3x?=
 =?us-ascii?Q?nAY+cw3K7r7+xYijqKOF1qYKa8MjHA3XiiXpCdbfuM+/NjJWmknL8PVnNpjN?=
 =?us-ascii?Q?MhDgnwXYbD3kOuPEsbecUjg+xq9l0rv09Qusts+/EXbYi2S9mo6RZwXz/m/1?=
 =?us-ascii?Q?xwrpk8+kzXuCCzHFVExxl5KfKXCRy3aT15/LWhsLubu618olSeYohNdjiMCn?=
 =?us-ascii?Q?1oFk8HTi+NndCVcwwQEzOOAMvD8zNf+qhh+vlibig/bdUAT9qvLv+MPslHZo?=
 =?us-ascii?Q?5zfs9oFKoBE9b3hFY1VLovccximWGUDM06ugEnLgV33ddurTxbmbEpXyopvn?=
 =?us-ascii?Q?JK89r/tgMLw46L5vRyCtY+wtppj6cIWprT/kWr8a68DXvjA4yPtqLajDOUkL?=
 =?us-ascii?Q?LRtYX6Q/gO/yBBy1G8jzXKTl13nGyvvX9xcRPgslCdXLPV5LtIo5d/AYI0h8?=
 =?us-ascii?Q?8MgDiPrYvrcoKzvMgt3zJLtaom3rQEsrMcjBEuEbDmg8O/xFKaHQracVUzpI?=
 =?us-ascii?Q?Kuh5RjGtouMelhwAZYQz9XdZhk+7Wl8kVPzaBmu2tAV0SCSAHXkzMfde6/lf?=
 =?us-ascii?Q?l2dmB75eHIZ8UmDfXl/QlbSGqP6RTBSoV7Cw/iBgPVxEd5r1zMTupdHvNa31?=
 =?us-ascii?Q?06a7YTHX2aLYOM32FqjCkN+QRhGMsK2/16HtDs1USx0paqLIov7AsBY7pDuN?=
 =?us-ascii?Q?+D5n0Yru3q1d6D+AipctxqStEL+8wGZ48XgjZp48HZ2Yq2ult9RczU2n/Od8?=
 =?us-ascii?Q?eY8InIcOaUUs45VAkyKzC4N8sSzzWIG9hGSOFn9AJyhR9ZnS10YhDYrZhwni?=
 =?us-ascii?Q?2JQiKkO3Huxh0lrE4zA8jK6nXRDAV82ERabLj/oYrvpHg8h2Ojb7WNlfKKBm?=
 =?us-ascii?Q?zHiNtN45T8uUxOiO1OBD5GK5mUGjnT/HmThapsDKQRV33GDPDd+I7UxJ0QsW?=
 =?us-ascii?Q?rJbwfotrKreXmhMt4Va+VvWj0G5V0Rwgp4kpHIxLGGgmmzpq2XEZB851FqPm?=
 =?us-ascii?Q?/RHRgRo4wlXHb7TGyD4E21b3q5S+QfnH8UN7GHH6l3WgF6SmN3WcMJDDw5DL?=
 =?us-ascii?Q?DKJqkkVx3j7yrh6Xg113PU0KopYGPECJrvI6Jx1bOuJLCd8128qNACSK2Y5X?=
 =?us-ascii?Q?m0ANz7u6l2MJZa3jUBUTNVug0ch1GMVyFD0V03ObX4Jrnza9I7qDPsj/lkV8?=
 =?us-ascii?Q?+DfJzU3Ty4FkwC31nRkkArmfz5MERTx4JFSRqCEek4t1M0wy67091JNdPwAE?=
 =?us-ascii?Q?gL4y49z35w+rI4BMHRynusVTbTx8bQ7m53ZNFe/Oz2ohPo2e3IOTszzMxXAq?=
 =?us-ascii?Q?miICN66vNgf0g4VQudpzaY85/8yodEDs/VNGobGFR0BNQeNi897WApZCTde7?=
 =?us-ascii?Q?mlAXOh67u1fbZtmSPbRS4M7nSEagQYl6zZn9NMqBHSivyfpD3B8HocV/mCZI?=
 =?us-ascii?Q?5ipfj3V7PSjkRUvYAv0Ey60Djt8bq1oLKNPhYFacLPPfdC6+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f36b6b8f-9ef4-48be-8e5d-08de6663bc42
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2026 16:12:48.1282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +K8vr1aJTmJcgq9WyPfO6tYVdsSjoxGol9c5zIRoYkpRkSP0hkHTSMQzBpTdGQo8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9766
X-Rspam-User: 
X-Rspamd-Queue-Id: B68C9C000F
X-Rspamd-Server: rspam07
X-Stat-Signature: ihjfmeptbzgi1e5nw99ycsezwh94deqs
X-HE-Tag: 1770480772-763725
X-HE-Meta: U2FsdGVkX19JeQpgdYmyHSlZCUGBx+DPA86hFJk226FSjnvXMdsB6fvIhDtmXA/QRdCYm54mWuhTE8CqWjuoXdnFBUHfIrKgbAKLBFX5BPpm/4iR7lGYMVrVgL4nEsnpxqTcmfkv637DkIXIf3t/ErsHHWYH7CDxltn99YxcvE1tXataLwm0AdpHfL7R/CzF4ZeeUpGuvOrJsnpp6yVVwmj5eXUUQt6aw+gNYbmI3d7RkhLR56xXwAUoMS60noFm2tkUEJKu/SfChYojmt0bdTCrtbvXFLGoxjeOwIlEI4wksgfzdFUc0MJ47FXD0L7yyyrGz/XD79bbubdTKmvH/27sM4BHPoZaQQ2mua95dhGeivY0ZYf7qOwTOMKBcQffeLOvKPwOnkIux6QAc7tQS0fJl8SdWOb2RgQA6Zazr7jamI5ZXGLOWbJ4T8x+DTdFQQXcwO/FiSSjeiZwFdU3Likik82O1ZJkQHjX7kNC60YzSx7Qg0VlE06Y4ND8v+momlzRfO86FWREoEEmHd064ttX711mFSI8CL1dEKgeKWcT43jNlLmXJpJTslSMdNI+LpY5EkmTH8/kxehJXfIzKratEUfYUfJR0043cKRu1QzT1E7xeCK9UvLER1AlFYatqggOov0+CfW9kcznBijEeGNEOCROY867Wedh0a/xQ0jIhf1979DY5WT4fFYFSFrkJW3vxUCIaKpMiWAcH1dCmWJHjD84fB1ZeoNKRnUOEw5l1RjPTY4E2EWy/3L2/1Sh9ewvE550uqnUlpJtwZAlvvKCOlVUpaSPD1Q6AVd7yyLSLYE9pVDsuRzyjy4701zW6EQYvajxS6W867DaymEDPehoW8ClAFpNx70DPvjiKpkMqAyJpyUHCbIku2dJ9MtOQDpejXJL3efPQ2GcpAVOvf9XrT7S4bM2cadA/C44zDC5LCKf7B+8L2NxMSM/xfCReo0klamxAL7h4751sfD
 bd96JSXm
 9pAcwXWLaREio0eHnJpUHgHeoE0FkNLc3poFt8HRUMI+9XFawtgO5gz2qCcS1nOXvkT4M3889ebcxBg6Syna98eQgoGseG7pIm8OFT9Ek+/2+7xDycOH3KGH7xaDL8u2/4lGOo8YB+XWNvMmtJQq4y8seeFjCau7+vv1/QP6Jr7T4kMVg4wrXKrjFsrUObdKbcLG2buO5NtdHZfhV+CalqBc4CyPNEJEFhUhRSEm93YIIWIyOJIyo5V+6rgM1mD6LOQxx/O6Upxpm7B+z7kpzvRpdzIvv/y1LolqcxePucQVM+EMDXu8rB9jO9kXrcgdKE+bzq8Vqq+drVueNDoN2qRiga3Hirvu2fqfw6KEcObzd0SiXYTQMhLYun/SrxPBbmLq6i3rtLeLpwg/eTrdzkVeZL2Ith/3AbB8e9rnQxZCcXFMgfFgdZISSnrh1YZs5GLmS6Qag7GH3bbViKqzEF8RtiAbG03a8j/RV2+j09iyYYbgXApv3mhqnnYMa5gLXnBS9WjspVJ2y0UP4OU6UTukBtcDvOCzC5e6LMaTdvr4726k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+folks involved in the original conversation.

On 7 Feb 2026, at 10:37, Mikhail Gavrilov wrote:

> Several subsystems (slub, shmem, ttm, etc.) use page->private but don't=

> clear it before freeing pages. When these pages are later allocated as
> high-order pages and split via split_page(), tail pages retain stale
> page->private values.
>
> This causes a use-after-free in the swap subsystem. The swap code uses
> page->private to track swap count continuations, assuming freshly
> allocated pages have page->private =3D=3D 0. When stale values are pres=
ent,
> swap_count_continued() incorrectly assumes the continuation list is val=
id
> and iterates over uninitialized page->lru containing LIST_POISON values=
,
> causing a crash:
>
>   KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead00=
0000000107]
>   RIP: 0010:__do_sys_swapoff+0x1151/0x1860
>
> Fix this by clearing page->private in free_pages_prepare(), ensuring al=
l
> freed pages have clean state regardless of previous use.
>
> Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be =
split rather than compound")
> Cc: stable@vger.kernel.org
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---
>  mm/page_alloc.c | 1 +
>  1 file changed, 1 insertion(+)

Hi Mikhail,

Please include everyone was in the original email thread. Also, please us=
e
=2E/scripts/get_maintainer.pl to get the right people to cc.

Thanks.


Acked-by: Zi Yan <ziy@nvidia.com>

>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cbf758e27aa2..24ac34199f95 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1430,6 +1430,7 @@ __always_inline bool free_pages_prepare(struct pa=
ge *page,
>
>  	page_cpupid_reset_last(page);
>  	page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
> +	page->private =3D 0;
>  	reset_page_owner(page, order);
>  	page_table_check_free(page, order);
>  	pgalloc_tag_sub(page, 1 << order);
> -- =

> 2.53.0


--
Best Regards,
Yan, Zi

