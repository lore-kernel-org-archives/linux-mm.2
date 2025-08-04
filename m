Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1801FC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912566B00A4; Mon,  4 Aug 2025 15:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9C76B00A5; Mon,  4 Aug 2025 15:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D8C46B00A6; Mon,  4 Aug 2025 15:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7866B00A4
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:00:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 308A31DD447
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:00:37 +0000 (UTC)
X-FDA: 83739991314.01.ECEA7C1
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8A1C8100002
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:00:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c87tWqTN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754334034; a=rsa-sha256;
	cv=pass;
	b=gm1qmW+Ksmv9Fb7aj82OR0FeuklnRUNG8VXsg0X1R4B+dzf0PR1B7pSqmtCOX9OU10wp4B
	CJKyexn7vaEzqa9ZgBn7A7HklnJiptINOxDjTfUDj9iomO8CabmGPXHe5JzKoKxuD09uV2
	hvuFYZ2VUGwiHXYAgriSpnUjvGJbPf4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c87tWqTN;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 40.107.244.66 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754334034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9vSycWbe1YxzBrdH4Qb5Omqz5bKdg1XGkizBFtZ6Uk=;
	b=3u8vDZuMYfGO6cvyRicJcS1Sew/Q351J7AuzqQqhd/YGiV/i7wZe3QWoA2jJuIEy5f1qTD
	y7PzjxgFfqoSfM42f6AMfSXtzZQTTM8E33m4Xqr7SQnrqXvJDFq00F5/rORoIGrKtjBPaU
	RBDMG1y9a4B5LDb2vmdZYV+4wtcfVAg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iBSuxvIX4doIfnqwTHn0zL+3etCwyCGdV1AD5SMbmC59CZSwhGAPuqFgAQRX9f0qPB643u6EMIGjZTOnjJbzqcETFmvNxWA9xl2MlCG7ZF/AXcNLHCXtMJnzcqZdjV9WYVWsGBUPyIWIw8+IAn5mt6HrEZTOZoH2R3I8iZXHKfVPrTCvZVN1tGuVFSH9guTGoQLr9W//4vMS9w5kKH+tpjGkbtmly+6XaTxH7Yig45LMsVRviIqKesUdJF5a00UEXreVV20IHachrIWp62KV5efVRVPzrmmGMjMlJNZhxSww/zRCr4AS59zVHwEOYxXzu1ephZ994tTPn78VXXvHdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9vSycWbe1YxzBrdH4Qb5Omqz5bKdg1XGkizBFtZ6Uk=;
 b=XydlMyImHWAbcJVf1rfCIiS1D2VKMKSAoYFyIHKc8NUzWY83gNbFmGk0q1qQG3SpUH2rf2HgCj0N63d0NX25fGj54T04Wskb7jhlnRhZ78eyktG9smXHSUhMLWEP5i8O81AWnvS9TkL8T66rFQ3dFiquN8oie29M6QQaQqUpxQ/jSl/cGxqVSeqkCQ6aQ26wZd8EWkiu/Gk1pCUD453vcRA+wBiBXtCKWA7ibpsOqWpiORPbjDnEC22/GtY615Ox1XBpuQ1Bc9B6MB9nZTBN+ayCKoP2Hmv22moP01V5Jg9m/56RQYs9dbWUflHffNvXDdRedUWcbT2DJxQlgeC4sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z9vSycWbe1YxzBrdH4Qb5Omqz5bKdg1XGkizBFtZ6Uk=;
 b=c87tWqTN/S5nbaPEuY80RCauzDj4RYfzg/aZYc6nemrR9lbht/iA7wRYo3ekna4xjyy/c5TTBFCLiYpGhaYspFTEXpJEGSjSX4tL1Rp6IFS30bRRCUfyvIiQSwT9NEnmqZjFjLn6/l2MIX6G1+6mYHJoGETTgsAZHY1yw7sNpv/acxns0IkqJZHzUt3e4bWQHXy5hJVQEzDVrz4vlbyYcDtC9LacIHIqpeSSserqp4HWwNaJlLqZc9VBpODCtvWNqfcW4FiwGjKTw6lGoktfCy9ULeEFc9rULo3fif9uff91ot2laSCG8QFHapwaUHky3mt8lCVNVmUBjrHZTfrNJw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN5PR12MB9510.namprd12.prod.outlook.com (2603:10b6:408:2ac::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8989.20; Mon, 4 Aug 2025 19:00:30 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.8989.017; Mon, 4 Aug 2025
 19:00:30 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Juan Yescas <jyescas@google.com>, akash.tyagi@mediatek.com,
 Andrew Morton <akpm@linux-foundation.org>,
 angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org,
 Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com,
 Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier" <tjmercier@google.com>,
 Isaac Manjarres <isaacmanjarres@google.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
Date: Mon, 04 Aug 2025 15:00:27 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <8A3D2D44-DCE9-48FC-A684-C43006B3912F@nvidia.com>
In-Reply-To: <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0205.namprd13.prod.outlook.com
 (2603:10b6:208:2be::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN5PR12MB9510:EE_
X-MS-Office365-Filtering-Correlation-Id: 017c7657-774f-4cbe-5e7c-08ddd3892eb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UMU2mA0H5igYGj4zTGk2b6MF0Rwif6Zy1JcmudmCE5pnp98EtWkq4Tz7Q4vB?=
 =?us-ascii?Q?1+8AqF3hTj3hD+w+g1PSJiq44nLf2Wzndb2NztQztzI0tAKYAU50w/gKu6Tk?=
 =?us-ascii?Q?MwhvgV2nO1rkHunmowuflE2qohRnt8cWLYidcmCXEabp3R3MjZr8xdsL6mtD?=
 =?us-ascii?Q?cpu5a9xEtOZrsJdbNlvlA7+qQkZCqEJtoTyndKfFXBO6T2PFu9RMnBrgYEkz?=
 =?us-ascii?Q?Z1B4qec1J1SInvra7nOXEBKeuUXghiIC4U/LRG81o/yuvbclF79AFCAvMsg8?=
 =?us-ascii?Q?CGf0k+yn8CTVEsgBrF9QJ/ynBtEKrhHaStiIZHW1aQGNzDMNwi72a1waSbII?=
 =?us-ascii?Q?Ec12AJY4Vu3B8rEDFHVIxviU2VMFzSEY0J4QiLTkD1WYDXxtIpHK54+EWfD8?=
 =?us-ascii?Q?KB0ZgFgAwZECPqRNsuFeRm9a3frWmBXoqNvq2pRjiQ0ht0WDvORlG3uFVh6b?=
 =?us-ascii?Q?5E3V3zd5+81sx3gVazsrdWRuP+OvkKjRZWhcSlAEOpIwH9kZAbUaYuUh+cmr?=
 =?us-ascii?Q?Mo5XkUHLBrlm3htXLImcERcS7B7fuLqEV1Zj66CRX+3XICe0hheBZDv5RDF6?=
 =?us-ascii?Q?lYlitKH3MMG/S0XKLfD0HIRw6rSFs4JI5DKgQU2/n2cOnY+0LOFpco2DRM7h?=
 =?us-ascii?Q?3XbYFxdS3z/g8eAx/RtquUOVuV0oImpC3474O9HijSznL12/EswABg4R1tGu?=
 =?us-ascii?Q?1PKTO5RSQBM4ZrTtx1MUeyMVYC+HOBBIRIC5LEZkS0YO4DddKJmhqDYcjvIY?=
 =?us-ascii?Q?UCAZulJN1+2nukwXHprij3TmMi7oz1b1A3fxG8MfYfAMG+em7+kofeyVNruw?=
 =?us-ascii?Q?ldx2XNNG572lbWRFYsQJgIHJ3HJ3SCjJI6Td+XMm3YAGTKd4iwhw7m4bMCgm?=
 =?us-ascii?Q?Vh2ro9ga/72FQdT6Qwz2gQf+pTsdgUj472C1r9oMzomDHsodCU68aeEmGzUy?=
 =?us-ascii?Q?Us9y1MOdGdO07kGiATYGQwJZSxHz3UzF09eaI0W1ZUjN/XsYHFnm8zd7Ozl/?=
 =?us-ascii?Q?fJtRwlTrNeSIobfRYleQVmV8E3GI++/ciIcvkiQB0WrRFsaG57yBn+dWJl+v?=
 =?us-ascii?Q?/0w7s5I/OEoyXPe1JqsjNc/Fj8M277vMpmFuf5BBGIk0J/N903/JpDJm5TCO?=
 =?us-ascii?Q?QWfjjfmxHg7UmnO0ItmfDU5cio630CVqG8zAcMjpv+hi/nXVw8Ihe69iKcTM?=
 =?us-ascii?Q?AyBNsQwPE+Sq/cT7ES6LjC0J0wlAJApiahARGSpmk2JEfUoYv5Q8ehoklmqq?=
 =?us-ascii?Q?IXUPLY1pLN6s41Dp7J7lxFoKxPkkAG9rxV0gMoyip5D5BmpaPkhzTUZHIYPH?=
 =?us-ascii?Q?d39B0o7bpsoPiP8UwMDgxndm3ojgbUAxB02j+q35Lgr9Tl+VQdfknP6CkLw6?=
 =?us-ascii?Q?+TULtHU3pneWdnCqL+URg68KzXlmqC7xVG5RoHOGNOR9YW+TCXKRLIrXxyWw?=
 =?us-ascii?Q?dhTmpYgt6L8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gLjVPctGu/FbVtsGURHarDkWHQXnkxpSMs9H76U9CO7lctLgT81gqsOn/t7g?=
 =?us-ascii?Q?C8rNLWiaA8lFRNXqEs3usy2b+svOOu/wqN8myM+mdgXHfZZrHSO2L5eTsjg0?=
 =?us-ascii?Q?BupvohYqBDyNNaCBwRWrzP2W2qof5uIBdtUASkqdIfxe3Ae/mNDy7oczyAii?=
 =?us-ascii?Q?xfYEjFe5mx/tHvLg0HjNx4HhJTr2mV6b9h/3ky0uTgHDeX5fsJgGlWWWJQpl?=
 =?us-ascii?Q?4e3IA4zj2PwXzsnHbHK5GvP/0KTQjimwHCSefZ0KK/SDJShctERFwsXCPXzp?=
 =?us-ascii?Q?PHVpb7uxJbQKg9OG59JJzhA9PWDiV+TOjLM7Vk/QEdsjoPNBfzdOX6UUc440?=
 =?us-ascii?Q?0CuUc1bCkN4kuOFtXtGuLevOaTYMRCMLkX7z1EbhzLp+Hb4wRQHIAMccbEI2?=
 =?us-ascii?Q?Vp0+MD0Mvl8ZPk5Kjm9okfhe7Upb83SPEw/eTtzDG/RFfFLptKi9UHxAALEJ?=
 =?us-ascii?Q?JLmC43tWZS40w3t71RBLALigGTQ7PZQuiQQqO5cdWyt+FsGxQurhVw8asFq8?=
 =?us-ascii?Q?ijaQGPsZtBjPso2FjAHpx0zP4svAt2F37fAnv/EF/I4/wDQWgnFvNk/VWO7m?=
 =?us-ascii?Q?44wTIj7YcUd3jh8tvUc5AHxwD1qJyAu3EwvfpLdWwVa03Ne4dKUV3i17LFk6?=
 =?us-ascii?Q?iD2j24lCglMqa/TvMBgDB8hhbi5yWPXjYSVrbjMmuqx5Q3vXdJvjSleMXRdp?=
 =?us-ascii?Q?WujmYXZ/8tTRe5Zi1gGjObvckXTfAdQNL/Y4YQj++7prbFiLMNcYaBeG4Nao?=
 =?us-ascii?Q?nyndDPqjgX4T1WuQbbdRLmKtQYi6/7lSLDGIa8fKadFTLyaSDrwWGwEyhexn?=
 =?us-ascii?Q?Fd/1JkqZVHQIQZjN71kWrOt3EFTIeatuLyPnRTDIYf+UfunAC6lMyfxQAbso?=
 =?us-ascii?Q?v+PK0hLc3hjHisu3Th3z7R51WozhMuCqXGA9D/Omr54JIDMLcQm3XOaYUvLs?=
 =?us-ascii?Q?FFYYTaTBOIAFoiKDdpK1mMorAGxZvgIp+OUizTsfUkYuQUeCwExxKKp3GgS4?=
 =?us-ascii?Q?OUDxejLgD84exA74DUNR/l5iJZL5PkKyqjalwimZziqNpQXKhgFFOUeckQNF?=
 =?us-ascii?Q?35CRwKoGLKPtCh1HGpO5BhhoHvMsbCX8WmjWQtlsMCkqfKImJnd3UcL4of7N?=
 =?us-ascii?Q?qxZPcD7wjGmJp+Jer8gcF4maQ58Jzy4sIgLtmwRSzQVZAQd3WudKnxD02XFt?=
 =?us-ascii?Q?GneVBtsrE6ioIjLYMjin1umTpsRumjXkaX06lJJQOfpud78OdPHphWhhGZ2t?=
 =?us-ascii?Q?UYwzIZre2wj0P840GmJeczXgkaJ4tNoKlgqYypNln9pjt94LBNlKJFufgaW4?=
 =?us-ascii?Q?aDULGiBDqnugBH9GYbfGXGp0icfN4VHW3AE9SQYCzf1tSz4wftfujr6GwZyg?=
 =?us-ascii?Q?IQkHG6lpQhbZiPUhG21evqEGoBXyFAqCtkgVRKei1Mxy19uzA8cxFuxwrpH/?=
 =?us-ascii?Q?vI//sA4QYgklXiDGXF/NZALhtGcoq3lHXX1kO/3yFKBqoMUaVrvbPJuJGHZl?=
 =?us-ascii?Q?SqxgT70ioccWVTx/A5tpA6usPirfZiSf9HZVa9ZPZWtQ8/JOmfYFh0xUPhHI?=
 =?us-ascii?Q?+cimEz8KWQLVP5gWMOBF5cETtffEOdAQpNgbyKIA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 017c7657-774f-4cbe-5e7c-08ddd3892eb8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2025 19:00:30.5429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e/l+Q1aN4rqh1Qsi+ktmAxktc4d9J9XhyevUww2sxPLZxXnZr8vngIdXtL53fpTp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN5PR12MB9510
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8A1C8100002
X-Stat-Signature: jtgkhjdaar9k9ydujyhr3631xhm3ucs5
X-Rspam-User: 
X-HE-Tag: 1754334034-498320
X-HE-Meta: U2FsdGVkX18MSqVqbIu+fK2525dsp7Yp7I9i9+xQkbtIgp83GUj/iICemS/N/AfuJDJIcdK9JURu+Tw+m016qQMdRRADVIkQd06rVeGuro7si+7HaOq6nSxU7kV4mQpEFSzH8HKYEmqE+yOxrpnXTyniw+9sPp3EydMIFl7tANgDFuYqG2mnu/N66bi+kZTtDJx8iy+wDO2QbDBOcWGfA/IebXgghOtyehEbVCcSRtjRsIj7ebD/+emeOSYxr7RBseim5/AOaFQGFssekE1/9Hi6MTjOoNVS+gXD95JdzYARfi5oDqnAXjhfkDvijSfzxyyW/KlYqTIxubrb3JwcQ6dN91H7+6hId66lgn8bILdgSsEP0ThyObJK90YfH9YSqveSYh9jGuH/5EKLC3GK4veoxdpcIE3W/1Ag+4OyUFYkQwf5UZk2EffyXbbnobaSRhoTWCoRRbWotsbAKFBcKg+DdhqWM7czS6nDfbCR13AbgpMCjISA+fq99KOPZh1yucqO6NRXkYnScaBJkyA8N8+ZBTpYK4DSTOfkxbvx3hK4hUc5wD0IXxy4azTdtRmimZAYJ5bX+9mr+v+C0+U3rD8GOk8J52yvXi8AV3LX4r/EXoIL41JC4yaLZADmZFaGjI25yzAbQtQ0B29l7kJ4BiMUOGxiTa68PkaRUUBpsPViKKio/eK9FgFnrxEJIrHdph5QstgVMqnJqgLKlkKdyqrMM23Al7dKQf3foPx7bnfa84FiAuOBkm3y6oWd9dTWRzNaeAl8EuVupbLLfIUOAemAnaRGzM5DXiW3Aeu8GvTwd7U3OlYswDzlSGyDLIHv7vMD9/9Rwnjg8Wqee2IoqiyFF7M5EKNZ8VGBTyjSTMWx9f0Hj0mdJ2mHBlb8f+gA4odI7cxIYdtcXU8l7TY9xUKrn5YDPHs9981kOioLsulx7/KysAZtFi/RAu9LzIVqo6slOInP1//Phyvl+A0
 lr45hggU
 UAfsJSH0Yw/UoURyj2hkxGVr1EMsDo907DFkBQ2QN6JOpMOXFIWmK3FF8TT/0XN/BPNj5teloXbI8w0XTV+oCPR7ZNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Aug 2025, at 14:49, David Hildenbrand wrote:

> On 04.08.25 20:20, Juan Yescas wrote:
>> Hi David/Zi,
>>
>> Is there any reason why the MIGRATE_CMA pages are not in the PCP lists=
?
>>
>> There are many devices that need fast allocation of MIGRATE_CMA pages,=

>> and they have to get them from the buddy allocator, which is a bit
>> slower in comparison to the PCP lists.
>>
>> We also have cases where the MIGRATE_CMA memory requirements are big.
>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 50=
0MiBs.
>> These cases would benefit if we have THPs for CMAs.
>>
>> Could we add the support for MIGRATE_CMA pages on the PCP and THP list=
s?
>
> Remember how CMA memory is used:
>
> The owner allocates it through cma_alloc() and friends, where the CMA a=
llocator will try allocating *specific physical memory regions* using all=
oc_contig_range(). It doesn't just go ahead and pick a random CMA page fr=
om the buddy (or PCP) lists. Doesn't work (just imagine having different =
CMA areas etc).

Yeah, unless some code is relying on gfp_to_alloc_flags_cma() to get ALLO=
C_CMA
to try to get CMA pages from buddy.

>
> Anybody else is free to use CMA pages for MOVABLE allocations. So we tr=
eat them as being MOVABLE on the PCP.
>
> Having a separate CMA PCP list doesn't solve or speedup anything, reall=
y.

It can be slower when small CMA pages are on PCP lists and large CMA page=
s
cannot be allocated, one needs to drain PCP lists. This assumes the code =
is
trying to get CMA pages from buddy, which is not how CMA memory is design=
ed
to be used like David mentioned above.

>
> I still have no clue what this patch here tried to solve: it doesn't ma=
ke any sense.


Best Regards,
Yan, Zi

