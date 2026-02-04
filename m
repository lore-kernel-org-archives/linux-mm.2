Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A79D4EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0996B0089; Wed,  4 Feb 2026 15:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA6C86B0092; Wed,  4 Feb 2026 15:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5896B0093; Wed,  4 Feb 2026 15:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A58186B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:14:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53C17C157B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:14:07 +0000 (UTC)
X-FDA: 84407875734.27.145BA02
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012050.outbound.protection.outlook.com [40.93.195.50])
	by imf21.hostedemail.com (Postfix) with ESMTP id 604CB1C0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:14:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ht0HvEvN;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770236044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxQqv4oC02qTvVVUv3AyHa9iU7pPK69+QtzbH5vDJcw=;
	b=2W3yXHmOpTfZVaxLxX3Go6NVWfmxcrkM6w6fcgX+CsFBrPzG6uEvBSJugsfv9uqJzGiyl1
	nKAPqRAGjW7Wn0UizR7SD3mPyPXkfXFVK/xEq6aijkIyqlu1qrehXK1fOg99KmZGKga4MZ
	NGgopo+0ZnCixWjVIMXgr+03tGWL1iA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ht0HvEvN;
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770236044; a=rsa-sha256;
	cv=pass;
	b=gZj7WNUEqTiUIdiaICozFyU9njT1i+jRASSfJnStCCgccGezUwd+BGvFO/lzqSrqKfiirB
	ksJPuMbdXb+SIzFJkvwbDYSuA9c4E56NAPYG+JKr8r4+/o+ZiaDW23Xj/GOv2cQ//8uLyt
	+L39tKFsrYFk6VJK755gur5kmdGrIlU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CYmI6hkMQQ1GJNrDpga29smiZ9DqCZzf5t6GWrvHYRaiHwAn3bsKJBbtuegvIPmbQ5DCSnvs745jpXljoD8NXhq5VfxKR+6Phc3/z7KcQF/sfkwrQ+ABm9m2oGexqscAo/KtI0gE3e5YV24OIA1oNM2Fw7+MwBxPfzZ5hGhYuT3I7PK0gsXEfVek6h3arFBJlZlf5F40U9YjD/FlUCTlQGHxfsnpdeOqG0p0Ig8/fhuil6GbaC7K7S9OQTariKVP7Pd/zJbYTPb52rYfBaVHp68OnpUImQ80P+FMN4kQUCvQNliLDGzEtLHKmaxFhMUiFElQQ6SYN5Hg6zjhFhd1qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IxQqv4oC02qTvVVUv3AyHa9iU7pPK69+QtzbH5vDJcw=;
 b=KTKri/swU9KNinsqT2UMJO74ii2sqLakl66nh86iF+wOlL+q5aMNUW6GgWZRwFtbziGDYiCQS7g56CG1yinIogdJOFcreD6SwpV3PJGhWO8A4ykm3eaOaLJelp8b1Ad01O/pl2cXUF7OV6pLoXbOm1p43P68DMBXqPFSNXjvyN9SkA4Ak3whUdiWqEN+PuzOPztFiKSn8bUQXzxASBi917zr1V54xgaW/LU5+OBQI7/fyNIWkJwETBo3NEdV7jFfkl5EXwgF8o7GbnA/w9slObs70iI7/CPofL2FlcAD6a9DPg80z96TohKGQS6+TGmndRFrBXZ5WYgZrWaUx2mUlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxQqv4oC02qTvVVUv3AyHa9iU7pPK69+QtzbH5vDJcw=;
 b=Ht0HvEvNtrpUfOJExhr7DM7mKISCoLWcuaCpBqIaMaNRNpGrTO54aHmk7/K9JJpUO8JsM1idcl+GBFyj80BVBq/7Gv1TIYYciN3QJT2czU98uoGaFTsTdhsJm2iuG6TlNd692Ig0SQw9SMKoUFXT+EbF94sd4bFjibIcK/f8we60TBWXxLlHCHiIYcbhTfHMkMSXYZ/upu4nTjI5bD8brFPJYA+C4Pe49shVsy0s54tygBNQRVJEAzaW+xA0ohSgJzxUVR4Rp5HXx/rQzlVZJYHtL9U9AygZay8vqLQqDWdFFH4En8bMn9c4fdDJ1gLW88lx2Wn94+sW9s92NJnYgg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7780.namprd12.prod.outlook.com (2603:10b6:8:152::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.13; Wed, 4 Feb 2026 20:13:53 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Wed, 4 Feb 2026
 20:13:52 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: =?utf-8?b?5piv5Y+C5beu?= <shicenci@gmail.com>, linux-mm@kvack.org,
 linmiaohe@huawei.com, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
Date: Wed, 04 Feb 2026 15:13:49 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <86002E57-58EB-4940-A7F0-7AE4A60484DF@nvidia.com>
In-Reply-To: <11399c99-f966-47be-bbb4-a7d4e79c8c38@kernel.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <9E046323-740A-434A-8B60-B8A32D0955C0@nvidia.com>
 <11399c99-f966-47be-bbb4-a7d4e79c8c38@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BY5PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7780:EE_
X-MS-Office365-Filtering-Correlation-Id: aca26890-ba46-43b1-7a1e-08de6429eab6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oMA70VC/OJTiXNlMWJZ5Fu20NJKoZoWMgZr+YC2CQgY1JaWqMrMRerTLLIT2?=
 =?us-ascii?Q?3YqIgfrshtGlB7emc3EjCSfR5JXtvuekTnbwyeBX56PdBlqqtleIgPu6YQUS?=
 =?us-ascii?Q?wiYktKAQnc/XDQ7lmTUyo30Qa+xyex2tlC9ag/V3Zpn1emuA7hzPVQAtqzs8?=
 =?us-ascii?Q?FiSzLLp52I19o8BdjBlSY9j8ZYL0/a3N4CKUsXfmj5DsnpmNYaGhgkvYgcX2?=
 =?us-ascii?Q?lPSr3y8KGVdIpZtmYbx3Vqd9TV4dgiw3a646ReAWmtgUw5ib2n6cLUPD+Qjb?=
 =?us-ascii?Q?u2HpJ8D94ZQJpkfN+t57aBWxCO/uBDCkIJj0vT2jxe3PjLSbfdOxS1AkpylO?=
 =?us-ascii?Q?64JgAjvdGaMOoD3wut4dkFLwmHH54QddF9VE0TXb+S5dsCudW1oA5i3azJb7?=
 =?us-ascii?Q?uf6GPQYVzNgt5snbJ+r1dMIWn3fQCrjH89jgoB2QWwwPXM5XrcAtMBwuLHP0?=
 =?us-ascii?Q?TG1wcKLua8teGvy29vWmoIlpug4qa3HNRfwD5cN62LOq9A8kGhZI1HLVAD14?=
 =?us-ascii?Q?DNSzzV0HG8LclhTea+WgRw5sLuLm0uvmFM19A+Uy46BjgBh5OT50o8wwl/kJ?=
 =?us-ascii?Q?SDyz2RNIQGE5RN5krGR1j2lm90hjP17zvLiWRuUUM9gs85C+Jg6Dc7RLqBuf?=
 =?us-ascii?Q?g//+q4OXwWYMy6SkI4V6lJLgPIpI832u0F1OkvjXFJ8GvOhqWI1oxcIOWc17?=
 =?us-ascii?Q?gU0cnX709rydlzVgNAMgeuTiecIXfgOfSfeZ9jpzPSJ9Ah9rMYkZJelT3WAL?=
 =?us-ascii?Q?gWI8fItJ7empz9Iildl+U40g4QSYlXpIe8RTja43/McOHhlewZZyPoeDvUvS?=
 =?us-ascii?Q?6Ye2YWC26Y53U6RroXTFFhD0iMftAmGn467V+dLnT6TC4fKz6YN0hPZZm+fp?=
 =?us-ascii?Q?Df5E3Z2W6IL0tJtKJUNHEHSHxDYFDQppxFtnhyTROn7w0ksZajMAIEG0Y0T6?=
 =?us-ascii?Q?bbWUHUEgVVtlHzQpOCOQup87CINyMDT+rcvQBoEGWMwoQ39DWJ+TiOqRLGPx?=
 =?us-ascii?Q?jttFt89EAmkmnLkZc1a6adMU2yBL/jmlRPGl3GIc3GjQkvjMZroxlNKsN7nm?=
 =?us-ascii?Q?QPvhVQ5oEGBy0Bj0D5WAbxaGQ5CYiSeFTHqDyYlKClQRGzuvDZ1afGfSw6EP?=
 =?us-ascii?Q?nYRdJFv2IQ3R/YF7LPJVufSOD3s3pEcNBN7on1N+gjMbTQIM8BcGPv/vh4aD?=
 =?us-ascii?Q?WiB18QOJXPAkuHtdzKYl73KJdHEPJhj525D2yF/qdUvUItpypYDu8aXB9tL4?=
 =?us-ascii?Q?aqB0E1m+2491gThKv4Ih/Ye8zMbUNAOKyxCFms4rterLz8NUMBi3f68OIAGH?=
 =?us-ascii?Q?8JkCwoVb0TJfZLj/9LOBIvufQdnX/1eP3xHxGfw80IpP6Rxy4hR+wVfKE8Uu?=
 =?us-ascii?Q?QXVdPJ7ilnlOTmmRP9RDBnYb28hHyuFZyaMcQisxe2JWYQ6L9vUxx9th1yz5?=
 =?us-ascii?Q?9w+iU4ZIIyTQRo2lETub7mporGkH+v1lA1tDfTMxyq6gut0SfCwBeBIkDFpb?=
 =?us-ascii?Q?WHxFRTaTau+gfRi8umDTU/bcNT6KnO8gMzrZJD0xUwNSXjL1PlxAoiGfFZiG?=
 =?us-ascii?Q?ASUg+C8fm5090u5LIhsgk/+Myz3m4Rn86BavwQR7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?utvGPNA7di8GbOl7SrchNiFfdLt6Ynw3IzAoXUVZuXwlCGZNH6zUiNeUb9gt?=
 =?us-ascii?Q?friza3GJT8UU7GXljbwDEb0hInbVnuCf79dnmXWRVwRTOZVHeWqBJHdbN+Fn?=
 =?us-ascii?Q?wEdoyA3Wd15/Bb3wZYNrJrLpoI4faT/gOoEKhL19yvLP/qJcpMU9UAtCidxe?=
 =?us-ascii?Q?N0eix55yL0RiGmlsTRVzLo2ZGyeYMdzMM0il3hpahueO6TrEd1gvOdhjM/l1?=
 =?us-ascii?Q?JdmaGqdHsUYHJ12mHWn1ZeKNW9b9aDH99K+3DnRoiFf43SBE8bVbvD2f4PXt?=
 =?us-ascii?Q?2DkJlD+A/+b10ERFLTTBow2yIhJhDAYK0pM4x5DcshoiAf29HrRAMG//ayWQ?=
 =?us-ascii?Q?P0AJr47hCMFVwpiSZKDh5NIdWczsfG85t3Kj2PM0RhD9Vz3ck7XO9gs+9k/q?=
 =?us-ascii?Q?7GdsYJT+zFfhZ8VZTIRzEYeNmVdQnXoX2896Sgt5mX8iU1uSFGATOI1SoxaN?=
 =?us-ascii?Q?r6/ibDgF/3dS5QyHVtKVKhxKOOg2Gqr0PzZmWAgeqW6ZVfkgamRVx8zrIA2E?=
 =?us-ascii?Q?DoDS3jhJunkQF8EDmpgiE+PNAOBW4QdwSWlrOyC/xZ7JCauP0eD5Qw6stBxz?=
 =?us-ascii?Q?z55xnvZ468viFzzHeh17B5jOO6ssA2U8NEhanZuASEsi8QVIYA43eENStC5Y?=
 =?us-ascii?Q?fNIt+F9AVT49CMjS+iu1I6Wi69o23lCccwTiXOn/aorm2KiD7VZ7bqvIUYhR?=
 =?us-ascii?Q?t/GlEGpc2Z/qLQkjyx1fmUTQHDELK6dtsbQTH6F+M5sVQSKaQ1laUxM11/gw?=
 =?us-ascii?Q?pPqic/8RizTyt+19pOEUrp9XV6uVxQrqi6T1ZGSqIS84zHXYMN70pJycP+zd?=
 =?us-ascii?Q?WGOneZVwmaJOq5Ify8qu2IhfdS2sMuRFx6gkrZc5HNhAtGsIKNt/019MbOAW?=
 =?us-ascii?Q?44Vq9kwXpwHMEO9MSRAaWHKvHPmKRqE7sMWoUK4hsjlT+DQSrEbhPUt5oVQX?=
 =?us-ascii?Q?038JThdbopljz1JeBdkO1/Xi3CqqWb97Pjub/gZE5f5K35Cr7U31qRNecxr0?=
 =?us-ascii?Q?YwFaIYu/JVJFJ4DiUWhzyWSdlf+b24gqqZ+brqDCujo/ZYcxOUl9m3yjiw6u?=
 =?us-ascii?Q?uuQMtapdInRFHNtd5G+cQkWX9qCsSjvPPs0v/8+Int9GZOXRNqVrjhVT0rJy?=
 =?us-ascii?Q?7sh8n/fjdN843uA6VQAxKs1INwiZ6SgAAUCk/6s1kLr74jJaW+7d0Wk/GBYZ?=
 =?us-ascii?Q?fm15zxvEyXui9GYaTQCP0oFIhqSF0hnB5jF+eHrakY0dtALsrNgFd/OWzY55?=
 =?us-ascii?Q?6qC/CZZELbgh1v8UN987SgRsfE64gjoA3dRLYkxhAsnkbeUKL0HeYpkFOeaV?=
 =?us-ascii?Q?jxtCgYcitqyYVi2D6LkJ1by7nYuHKvbV555CYvGFZIz77oS3NnnkZNIjxRPu?=
 =?us-ascii?Q?q4kwaQPQljqw4+I7LW0dIW6A4v6AzVNKD9Zl1vw3KmPxBOEuyzIMfHW6VP0L?=
 =?us-ascii?Q?/kAQl/0AiMfo6OCmVduz9wn77NQIrlzYXw8heYxacfVNAfnWal7FQJupWnyj?=
 =?us-ascii?Q?9WXBO2efL7tNKcY+Ww8fC0vhxFJhjaYz1IihUDdNpVflj4JHLq8ylZV+jsU6?=
 =?us-ascii?Q?41yMayM7mI+EkGtGmTCaUz/po6pJDevR4In1IJabkJBoS6Q8zSjoS8TUQ0Iu?=
 =?us-ascii?Q?slFNEfOOBR1ofGivYObb9vTXzI7qfsYoCJnBgPn4nmFS8AIqSIjt1zkWTh25?=
 =?us-ascii?Q?h+rYaaR6bImdaZ230CjAVh8CAC6AXNd5+Sr2WIU4iCV8c57UWNv/NXGfX5gz?=
 =?us-ascii?Q?Z1E391zONg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aca26890-ba46-43b1-7a1e-08de6429eab6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 20:13:52.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OP58+6kMMHwRWiwiCmuYG85ydKgdcf41arZ5PAKgOPlPtiz0lqq05wZ06qTAxxWc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7780
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 604CB1C0004
X-Stat-Signature: r13xnwxept3dk7fbujdfbtrgbyyddaxt
X-Rspam-User: 
X-HE-Tag: 1770236044-900355
X-HE-Meta: U2FsdGVkX19tCFLeoBLirfqLMsaYgcRvw2ucMnRQ7hwUcEWYH55kcTY4cqYUWAla/yYf67YKBfXCpixJsjAvIosc4VVe3JLg7nInUAm9m1Yhg3PZayTA8YKbNG5FsleWZ0K0MCD9PQfQEn27AJGKzG/Qx6m+t6SfGefuCccM91s+i9CA6HC+6toIouFJmBj1hey0qUYzX3dYFfqbFzjOLXYpleaaXFzSpFlMNxiC3FyBd2dFgF6tuJFOcNEyKHmSp9b8QMLn+aaMqHybOpf6avXXrZs6Gg0Eo27nc0jiWs1FvlQo13HihTWZLBtfJgY+b7F6t1oJfEn1UdbvqNGr14v0wriQOJGTJQzaT3UtBG26jJHqp/QIdcyFSxzXNPxvQ7bNerPgM71ML8M7J4N6ucZqAXAy3Dl1y/QetpXg+ggGq2Y8/3GexWcHbJom/Euj65Yw6iaTJp1QP8J3+9XWLJSD4YMI+vDYKpks5dUbzQE36Z5K/YkWMicgkmrigZ9wwSaNauwpvco05mCi7YvlBDCjT30eijxTv76A3e0WvxsUcsCGeYBXtOyyfdmHivpNtsCeyjXaa9Z2yDMbyvv74Ds/kGYv/lMel2bEs61J3m8zCgh9BxAS2HBKT49hhuO1a+WnRYosqWcRjZnL+8PIx8WcJ+UvdLehHbwj5Wbh2tuLEU2I9mW4zz5l5y+LmNzUS8I09xw0kMRG7UXUV3eDeE/M1WPqh01/y9QYvLuEWLFwsvrWK1zJDfgjYHfnBBjG9mGae1VIxU4up7NT0RnLXuA0gDCmmaLPmdSZmnJ8JO2NuCDWJ6RrlXV9XonVlYVTgnyaiBGuLXk/+TzuP6JySaY3X1SHv0nCvVFMb7n5SQAtAgajHm29M+zNRA7thsDKxFyPZb43iRKqymv4sUPVpCVGjlvWVYLoY5vgYhGGgYsXgLCtdcyrDGdAi/2jL4i9nxOtxrh03OX2csyPQ7c
 O7DiNT5b
 C9NzHxKgsNCrUSGixGd7CjwU59z7voyl+me1fgNe/FX3qUzA0h+a7EkUxV3ryKL6YlPwsWff3forc8DyDOh3geTjr9slAIPcFh4/YDV4pyJmSt3IgYqB8Z+KGmZzRfVYHHQsZZcIIGsJyaSLEWpAKAxr5gWqz39G2bzm0ONOm2cTV2HwQQ7rRxPwgwyANrrlSFQ1CBRpdPic/0zmC5u1k0r4xxWhOt67bmLt4beI0VkyJemTos/tb7/ERJ8MGE0YavWe8HtdQm7nxu+Aiv+CHp3GHPNrH1YGgIWnhjRjbZxxssLf8jmDlfAZFXBniePTM/zJxi0+jzX/sBIz9lf8kC7auE/vNDeQl3flBntA0CjJfBXp5WQw5TRMZ8YcgKrXn6aOuv170FwvDxrfJpzdiGs98J6msUCi0tkHsXdRhsI8BVBrOrmJIs8udwwl0GVoju+9t67oyIB3yd0w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4 Feb 2026, at 14:55, David Hildenbrand (arm) wrote:

> On 2/4/26 20:48, Zi Yan wrote:
>> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
>>
>>> On 2/4/26 18:41, Zi Yan wrote:
>>>>
>>>>
>>>> More details:
>>>> later at sg_vma_fault(), the driver just handles a page fault by sup=
plying
>>>> a subpage from a pre-allocated compound page[3]. We then get a large=
 folio
>>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>>
>>> We can identify such non-folio (but compound) things by looking at PG=
_large_rmappable IIRC.
>>
>> What do you mean? Changing memory failure code to only handle large_rm=
appable?
>> large_rmappable is a folio flag, memory failure code should see such
>
> Did you mean "should not" ? :)

Yes.

>
>> non-folio but compound things to begin with, IMHO.
>
> I would say that we could right now reject in memory failure code any c=
ompound pages that do not have PG_large_rmappable set.
>
> I have the faint recollection that we don't set PG_large_rmappable on h=
ugetlb folios yet, so they have to identified as well.

Right. My patchset[1] is trying to add it, since hugetlb is used as a fol=
io
in most places and large_rmappable is a folio flag.


[1] https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com/
>>
>> I think we need to be able to tell between raw page (compound or not),=

>> mappable page (compound or not, especially for those used with vm_inse=
rt_*),
>> and folio.
>
> We can't identify (small) folios just yet. We'd need another page flag =
for that (just like PG_large_rmappable), and we all know how that ends ;)=


Yes, I am thinking about removing mapcount in struct page to achieve that=
=2E
And only pages used for vm_insert_*() and folios need mapcount. Code
uses vm_insert_*() on pages would probably have a struct mappable_page
with mapcount.

>
> With Willy's work we'll be able to identify folios reliably.
>
> How to deal with that vm_insert_* crap, especially for non-folio pages,=
 is also future work based on that.

I think it might the other way around. memdesc does not have mapcount,
if we do not have a separate struct for these mappable pages now,
what do we use at memdesc time? folio?


Best Regards,
Yan, Zi

