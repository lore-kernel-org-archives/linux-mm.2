Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 210F2EE20AB
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 15:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622356B0089; Fri,  6 Feb 2026 10:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CFEE6B0092; Fri,  6 Feb 2026 10:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4875E6B0093; Fri,  6 Feb 2026 10:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 378896B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:46:18 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B8D57139AFF
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:46:17 +0000 (UTC)
X-FDA: 84414458394.16.D311511
Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012065.outbound.protection.outlook.com [40.107.209.65])
	by imf15.hostedemail.com (Postfix) with ESMTP id 165A0A0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 15:46:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PwWZMjxE;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770392775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JsBga9no5GBWYuxzSqokYeguiyaJF0LsMVPJGTOmvzA=;
	b=4/kt/pIXhEKFyGs+Zb/F7rF++MoI426s9V3oVyN2/npwiOtNQVJQyOAy9CBN5CEwztE8ob
	I57I7sqooYqUwslVhe2sTurxXMZes+TxM29FsFuGsAVoaCxDDQ2MJtj0Uo/5ZM/AHgy5Bd
	60+QkMRoNUwoGxxKBk+NyAuEG7lWixc=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PwWZMjxE;
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.209.65 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770392775; a=rsa-sha256;
	cv=pass;
	b=PzgIDPDgifENg4dWxrRzVcmPHT6q0Y8X1prf9NI8RCfnP0NInBLLk0hzFSskJ7CY9W0MFC
	2bNmgTVKBT61Ku5cSI75xz8jf42tOx840tgyMH4YJEQuV0zfUX5jVGoEOFbL9bEQv9a14y
	WZb2eRHNudYYqt9Uaqfe2zED44LSgEE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OfNw6EknCpRBGuGqrdrGG9AIVioAJek1DIOVV+BX9KZTPrC3/grK+MV3QcGLOwbfdIq49vWmvwgtljEbl/lRr/8YKa+ZGTUlrBX4fTVKcxOOLjhIf5FjLWLACl04srt0z3NYQSA3/HKptTZNwDDC4UEmgKZg2zqquQWxIcBYlceIGNul07kwlIqcEA5WGmdHm5rQsrv3Expf0rkk5VfA3szHO3hDHXBkbuqC5MzXt8oJ3D1gE4wweI+nQSyvow4MQeF4yP8A6tp+rgsVJCLdSdsqBFFo7xpRHci4+G1hZhoVU+sIv/1w4XpafRg5Pzv/OS/proIkQS/GJD0esLl9WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JsBga9no5GBWYuxzSqokYeguiyaJF0LsMVPJGTOmvzA=;
 b=XbOwfUlu/NXnkFAtQ10ygQxBDUQlW+IVbpdG6KbxYocKCsD+38lGmwcIHA5nz8LA9Z2yTeiH8GhtbbMyoYAc7IN2KNXx4wEsZfFqD94TJB8N7RImn8EsIchCkmlqYg8SMR8/4FyNF+89285N8SF34a6VaMU9PF0eSFfX9Dl+YZdyIOWXf2WiMAj1c/QRKqjizO2udOU/Of/jCrUx7Viz7BGZTOc6/jru5fRNmrDSk6To2IQjS7WqXX9BzHPnBXtZ1dfwDJbXs+YcZzaMvFmtVeuttxfPCGGhAW/S0CyPS2KXkQoJDqCILSCtb/W+Y7J4+pT9phznWzbw3pYfOn0i7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JsBga9no5GBWYuxzSqokYeguiyaJF0LsMVPJGTOmvzA=;
 b=PwWZMjxEJyjkCUnyY2cvhwsGsYOgKOs5l9BnHIP9v6tTuC+b2/N5M7tQnB35tvi5n132VYwUtK7WNIzsWAN2Y3+HKA+/nwW0joGqbpwzCJcR1qIIoTqNx5E3cy56I+YY9qnhu0qpMxi9DW7GUPRNn6tgOwB0KTwLQifeMoZo6Y9SPzDlBxPcI5hmk0D/jzIOfGLLb8/aE0g+nQ1RxIeKwFRfwfCFoYeNmARfk0bkbc/G7QCh+MVTNjrNOAg1Bp3nTpI4u+r9rmCjaYE0Zo70rIdDX0XkktOa1JjvFUS2GLGZsuDU212mZhx82vQc1nbOerbp2HGGZHAam97AAn03uw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB8014.namprd12.prod.outlook.com (2603:10b6:510:27c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.15; Fri, 6 Feb
 2026 15:46:10 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 15:46:10 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
Cc: gorbunov.ivan@h-partners.com, artem.kuzin@huawei.com,
 stepanov.anatoly@huawei.com, alexander.grubnikov@huawei.com,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Harry Yoo <harry.yoo@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Will Deacon <will@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: make ref_unless functions unless_zero only
Date: Fri, 06 Feb 2026 10:46:05 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <8D231B3B-C82E-4F71-93B5-8ED272EBBAE0@nvidia.com>
In-Reply-To: <20260206133328.426921-1-gladyshev.ilya1@h-partners.com>
References: <20260206133328.426921-1-gladyshev.ilya1@h-partners.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:a03:331::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB8014:EE_
X-MS-Office365-Filtering-Correlation-Id: da9900e3-231c-4153-7357-08de6596d9aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5un1eOmc2/boGwIKekVFZbafoWlz6LkydwarXhDYcFBWwdDeaVfmEClLD4EH?=
 =?us-ascii?Q?LWMUZV/d55uQB5oDVzWzm3t7p+Jr0Mc0dYwHcy1Le1At9WSM+7wUZbcg256G?=
 =?us-ascii?Q?Sle/b+SryFCTdi2RQhQrJwxUSoOhCKqQDTTcK3Ac5WuSOWxI0hCwB8xcnwns?=
 =?us-ascii?Q?AzOppOxCcPKX7GQULhL1byM0CUSjbRSkqi4hrXHMSHHMR+WfVUowTN1pLYvl?=
 =?us-ascii?Q?ADgT7JfTjoxjI6KUkRW4PBl0s0c2HhThjBHr0LNopZIIZjzMrHofsbDKDsJ4?=
 =?us-ascii?Q?KDTv0SPFTpRC42WRh3Ey8AcSoxKmLJarCXIwFGfYZqfaCNIH5WwPH2pJ0qQp?=
 =?us-ascii?Q?MpxbQnlCWoBdUmgHBlZCTt/XfsTyhnVn1E4aC9htrseKnArPKCXZsTO7jDpi?=
 =?us-ascii?Q?zd9egE/7nCGYS9Rjqmn206hY1nojbitm3BUgLSwSyk99F0oo2S0b2krYL8F7?=
 =?us-ascii?Q?Bl0DldRdl44ZJJgdbPDYZ1TzA1d29MAkpQHSndEP6c7jV+stv0vcGFlOgYDS?=
 =?us-ascii?Q?XSvxcdeEtLWCew+Hi9bFU7FauA6S38ArzpwvT4ZaaVw4bR0JZw9F4AQsFEH0?=
 =?us-ascii?Q?bh4UnU/HWmAB17XzDrZzB1E4xRKZrCjTtU7ZuwE3/4WzLy45zv0LfNFUbor2?=
 =?us-ascii?Q?5INBdjbG/3TDQIbJRHV/IrWd9Hq6ORm13kqNoTBUmj1L7xfvURJwp+8jS3lG?=
 =?us-ascii?Q?8eWhCValFrsF2aigAu6h2vEikmJjDqO8MBbjsCc/EiKMHPhrjfsAN81+ZZqM?=
 =?us-ascii?Q?FHMt3IvYl1JEGzdlN8d+WZrPm1BjqNYaJeP+yoecrUrPWBaA5iPfbKeGWlJ8?=
 =?us-ascii?Q?eTx7tbfMFcb5csvJru0PKXVuZKsTRGm4va8g5Qbz3p9DCt1J64TXiAb8M55g?=
 =?us-ascii?Q?X9lTHVzw1J4w0tKSYhetZobt4hzy6tDx9jBwyD6fXj60VksZUqzg/P1RAJAk?=
 =?us-ascii?Q?/uLhU+vEeWJ7y8RtbFQS9zddwyruT3fmSGzCdFCBU8hj+35N1JUYxaUJRwUj?=
 =?us-ascii?Q?nHubERpLgbfGg1CP3WoLWcDwEkj99+7Yxui4pve0TNvEoGxUAH1S+9e8+/EB?=
 =?us-ascii?Q?iySIVLTYkLZWmZfL8bRSvizp6IIiIDMDX6nMEgd4GMbt+P2UTQUlPyEs3/bj?=
 =?us-ascii?Q?nvIBlsnGMRJf0QhQoqn9TlLRg2ams0w66D8WT3ct6Y6snj9YFNSDL/phWFuT?=
 =?us-ascii?Q?2w0Blz057gNcvIVnjHVcI7qp/mtNcNW/L/YE3oLsx/74Yb09Jp/uM8+HGGjj?=
 =?us-ascii?Q?fXWn64U2Cm/bSILWmZYsCV24Hs5hQJU6M7DIjuFD8g9X7Au+HVPw02XHUEPp?=
 =?us-ascii?Q?RO5esefHytmauAaAhvHX7DpZ89dY11b/xaQzZFB0PbdVyS61Q1KQbp627rZr?=
 =?us-ascii?Q?afd/DKdWuC/iRqRWYGn7w+rNQruXJy0ydL/J1ujzkd0rLatsNTofvVa9t27n?=
 =?us-ascii?Q?sbfBu1EAHcQ7jALeqNuaXG8ZlK7BFtdZxG1M0IXUZmZNK54yOfbCTTihmiyi?=
 =?us-ascii?Q?M3SEJCO+faweTSghDfSnt/2+HQ1CH4Sa95/yvdBGJPw3tPCxmUUeZ/WUXZmI?=
 =?us-ascii?Q?GYzW+WO6Ly9K8B0YgQc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wW5+nDvfT+yWM6e+PGnkHNtWLGlsMYwgH6vcJSZQy0+iVxSfAYmNYf3/zj+2?=
 =?us-ascii?Q?lmRTvjeX/FrgvrjkeJTNrkA5C5y6JpwW0a9JOsVLLCEZ7STPrDNDPL40NseK?=
 =?us-ascii?Q?Dfdm6PuVoh/YRgcVCjDE9Phy6JpBJLkSP3TWyVgRZK5oBSgok5+QZ1NHw00O?=
 =?us-ascii?Q?AAWzqyjosfOolT7HWfIx7FmiIrRy0vKTc6t9UBPm9yv3jBMB2JxaBmD37JLe?=
 =?us-ascii?Q?IUV6B333AMnHbD4+kOpHA9ku8smQMXPVg5nIPCe9PHinbJ3muiBt8mjKhW2s?=
 =?us-ascii?Q?LzcfN/lT06fvy3bcNAumE/L5IVAS0zlzQOUJi53FNt496P/AbbylQunxoBL6?=
 =?us-ascii?Q?5dJRPRD0Fr5k0vmQqwItc0dCqFhFzrLCneoXQuLAx9BuwHPmlTquh4tjDKG+?=
 =?us-ascii?Q?AH0ELHfgGX4RikvgOEYRL/WBPJK3es4EqCSWYVDzOvzDcMiw/oyclbQsr41d?=
 =?us-ascii?Q?ujsMRmYIc2gZsyKEHCbH3HDCJW0iOCsQQrLVDsvx69meDDqKR3BEml8ax3EP?=
 =?us-ascii?Q?iwd3kdR+Um9v291l7y6/WYYhJUJPgjqh8LsWw+k6/LLmD6ZodC83n+XYgIVp?=
 =?us-ascii?Q?WrphOVo0JVA7zf4YMQJIJ4OadoEaiBWyZR64VByK+8d5i6mKkqdQud6qvfip?=
 =?us-ascii?Q?1mfueuLFHwIsVlcGwnAZBsVj6+wFUz+fxHeTG+qYceEEWvr08iEiJlTz3Zu9?=
 =?us-ascii?Q?+tMyCZl09nB5IBXNIxQ6amV0/WN2gS8cl2QDu0oo8D3Tqj6hNSQle+67gOTe?=
 =?us-ascii?Q?Yi0k3e+ptciIiegx2Jqils+6OXSM33qVcj7o8TvQ8dYjt0JmCuCU33n4fRxq?=
 =?us-ascii?Q?4Zucywr3XholCGsAU8mlcUF+R02qYXF4NUQaK17qxTIB9RQ6oAbCIMOrITDe?=
 =?us-ascii?Q?bCufEboxpEW8ZtfQZhXPRWbiBAI9C9wvn8ZfkbEYjVqWuVKL2jm+eS7ixwd4?=
 =?us-ascii?Q?JkpzR6AXorEvnZZMR537fg4WX7wxj7tFnb+BPKMGYjAqPgZ5GlsadcfmFdto?=
 =?us-ascii?Q?Z9FHt23sRl8qnRwGg6c35P6JrWH+CNXFgU3PdDW9P5jdNmDMDlTLPyd+G+yH?=
 =?us-ascii?Q?bKqg2mCUfU3XPuI+5DC052V65ioQyB89iaJyM1JHapvxDze/fY5RqOM/sj/A?=
 =?us-ascii?Q?T1h4Ka3QK4LBzzonVryAeemUqzdYo190YspthlwzhnbjlTypF72NE+LBqaJb?=
 =?us-ascii?Q?HolI7s+OuwjVacTxtH9Dpvu0LP4fUM6ZEMas3w81R3Llfsy4ktjq42/i/T2/?=
 =?us-ascii?Q?NEtrqd3zgj2W+p+HO1aYFKsxogDLud3w287AR4XGFq3TjqJqG5h03ALJ5j6V?=
 =?us-ascii?Q?pXLFGC+kf4tzXtKMqKBI6ZAlxuuX/CNEyt1w6Ki0YXPdViSKcVj8I02OWuKN?=
 =?us-ascii?Q?Mwceex15D8BGmMnv5xn7+sgysTzue4QkNUEysBGBRw/2xfsSFaHpRoFNF7Fg?=
 =?us-ascii?Q?gBASR3MkwBtfYp1/2/gZ1WH33O7r5wNv3DMcpI+ps8kl6Vet7wbzYBdXcgg5?=
 =?us-ascii?Q?a077nAn8icg8aYs/8QQ+KBTM4jRaDQFiVr8zwaGy3ez+Cb1mievcp6BM+HpN?=
 =?us-ascii?Q?1UOKG+rSpRg15xQTm2yuSPoWw5raeAyQfEkTiMh35PNxmYL59TRgXB/OwDoG?=
 =?us-ascii?Q?n/y81hQBeoK7h4cSOYcjcqmOUdqOCvE2VuUSQYLHxFO/w7pNl6HL5kr0KMG6?=
 =?us-ascii?Q?tos21qrf4u6zThwXrNEWhXlHkLOoWTHOQw3owAqZ5ALipXvx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da9900e3-231c-4153-7357-08de6596d9aa
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 15:46:10.6088
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /o4QPPyUEizcL5j2jM3IofcGaLLsEtPEe/g9owhIU3+8gAFsRwVAG37PPfV/sK52
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8014
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 165A0A0004
X-Stat-Signature: 568mbbpcqdmzmwgbgchrgezhu9s3fnqo
X-Rspam-User: 
X-HE-Tag: 1770392774-780594
X-HE-Meta: U2FsdGVkX19hGFu23cspF6o8O/s8jB1ELhKZM8ClDDT2PTR/Ovj4eOdX7XzJXGmJwyiRVnOT/MD0A4znK1N0Nkntc25gfPIeNRDw2m6y2EoKwFQtSyrH3BY+NW6XT4HTqlyqOWD6f48PmsR086+71JHxZkuIAW0SIkrA/ZxcxjCG0MKXjdkmlaTr+sqoYN0RD0sWTiv+qmUfxYx0wu3g2eAyA+jjrq3sPoDxdFFO2eeADg5cPkYcp5Ga9DEyAFy/iQGFnuQuNhBy7vKEdvLIAp1K+wLXX9D1YSzFtKhb4jaAPe8NSbiUVw0iCvPJLIghyg+sk/iOSjaN6j7IHhXjXua+Ne/OUUd7YkBwFabtBAnrbmSdbWwJC1c+VYKK0+CdPZZQ41OetA8bZERbJYyZb+BIocSTteQYVHFjxJFdorq1RQxTAKQ7Qj/QY10PNtPMI+DrorkxNDgotqDSboEvHa9TD/EY3QDaCXfxNIeT5N1ehUCcH7vujV/ugeHqEIajmEr4lyCWQRmdKDzAo/Og++m2ruUGDDu0PR3LZ7LASGjjybBP5OQZkqa2lD+o5M5fjoyhvpNyWQMMEumMLzjTE2M+X6NgjAg9u9J7GiZvLhO/vot2/TpgJ8StUPhaTMdjzaaWHemASig9WBdyqf65HjMo8SSKQaUkXOfMOKZ0yE2uoULGAgYrTq414wQQ5gGO0bcqIYpk6UbrTHJT4d6ODvE+EmVQ/r3gRx7jZTnCeyYfe8KaJojPeUD1udTgZZjfYcdo1JUJp0nYNCmH0Q0N7DRCXsEBKtk/PJSMpOM5KqxOMWVG2xdlTF45P6NhNaRE6M1SeiulmQaqDP9gpSXN2qiekjo0swlQvLZOmxbhq6KQT0XHrDm2CmTwBX+GJBHImhsTKdcZQGp/ErCDarsHRZ/tP6f28Qv2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Feb 2026, at 8:33, Gladyshev Ilya wrote:

> There are no users of (folio/page)_ref_add_unless(page, nr, u) with
> u != 0 [1] and all current users are "internal" for page refcounting API.
> This allows us to safely drop this parameter and reduce function
> semantics to the "unless zero" cases only, which will be optimized in
> the following patch.
>
> If needed, these functions for the u!=0 cases can be trivially
> reintroduced later using the same atomic_add_unless operations as before.
>
> [1]: The last user was dropped in v5.18 kernel, commit 27674ef6c73f
> ("mm: remove the extra ZONE_DEVICE struct page refcount"). There is no
> trace of discussion as to why this cleanup wasn't done earlier.
>
> Co-developed-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gorbunov Ivan <gorbunov.ivan@h-partners.com>
> Signed-off-by: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/mm.h         |  2 +-
>  include/linux/page-flags.h |  6 +++---
>  include/linux/page_ref.h   | 14 +++++++-------
>  3 files changed, 11 insertions(+), 11 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

