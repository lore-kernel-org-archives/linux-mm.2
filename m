Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B4DDC624D6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 03:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF3126B008A; Sun, 22 Feb 2026 22:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D974C6B008C; Sun, 22 Feb 2026 22:31:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C452C6B0092; Sun, 22 Feb 2026 22:31:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF07A6B008A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 22:31:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48FC71A07A8
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:31:17 +0000 (UTC)
X-FDA: 84474295794.21.714948D
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011054.outbound.protection.outlook.com [40.107.208.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6E4B54000A
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 03:31:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KgvH2CMG;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771817474; a=rsa-sha256;
	cv=pass;
	b=PoBqmgLncJvgEysSvY8zCCSRTgKJif+puSUvEAI8E4cGcbFl5gCd9P4c282cJR9mI0SuxB
	o2O1fq9NxfQEECMYiLr5wdQAFgHUvRp8yLerd96nzUJdwfM3WVs8nGYMQ4IIN3HnDTpm20
	Q16Mz+5R3uZrY0r5JCYJ0VUEXkCLIDw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=KgvH2CMG;
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.107.208.54 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771817474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A5/ekvOAqgmaMnRuTG0RPx+A+Yl3YCuZYrH+ulcka9Q=;
	b=fMrDZdvIJvNjztuP5L+QJJXyIAQnbBZwWeakjmA1dhf7FVlVyEyDt5lOjjSCm7TuIb5Nk0
	enqS+ltxU4DA6Q7nNlx7D7+oDvTpkD9n2YtQst6piD1AcKqq3sDla4R/V9tv1nuHMwUkqU
	BmvjdtCVCK4h/IUoV/FAQkvCwrwR9R0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IqjpkTf6ab0FZLiD4SpWvR/ahwS7+UUVk5FTvJ4e3Q5cZsfu8/fQk8QJsUQA7G9C5Mdg3RmmEzrPGwf/L5zJSWKQBMhKZDUDGVbjiEL+eareQVUbSN5raVTfsFjCeqD/sK2XxeLGN3qrtlfXKgq/kvCkBj34mIpEL+qCqPRK5CeHiy4lNe7iLv4VgzEandJCF3CWmcohulf+pGoGypT6m0u2INCtS6Av9Zdux+crYYopPYfFJlloFXakYmRpw/XbXecrBzDSpDFcQhzNzFA+Y0zkUx7ALSTPztF+UqlWTBZVLNuQV70NtWByDISp+jFrAUqogMwJhP2yjYCsxAdXpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A5/ekvOAqgmaMnRuTG0RPx+A+Yl3YCuZYrH+ulcka9Q=;
 b=mCmeJaKUqr6T4mmLAMuG/Dx5DJ0QrDhuoTyeP3ubh4tD/NfYDe74PcYhhvjbtQ6rGAKyWMZPGuTnGmQrGv9pG/IkrNFGiVglGx8IuUeNnl2guZGazm1AvOuFvaufd62m2IM3mUQtOMiRxDV7frR0xOBnZ70y7KP+ZdwTacdTDCQ2ocm3LvDHyidzrmgvglt6h9f1rA7NYfy5H1wJ4fjgXeYz4tDQ25+pPlg6o2pOa2klCKKcV7sYtBafuiQI15F+HYzLwlYiE2BWjY4ntnAxsl5J+s3anit7MGnwVdDSxCiaP2FuSa0jTJOdPpY2lEB8v+why8HKx4xonTPuC7lYyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A5/ekvOAqgmaMnRuTG0RPx+A+Yl3YCuZYrH+ulcka9Q=;
 b=KgvH2CMGL25xabPWjxTpSIA/R2Zl+IW693ZIc6H9+OPQM7SSPMVJ8SYyJ8Iaa82Q0fqnrMqHmJHWysb7kPtGVSBvX5b8CXehfKpKwP2wF7TgAMw3+J6na4jiieDOHyw0o9aevkBrMYBLDmaVxLLo9QOsi7MiByXF2Iq2/Dop+J7aqv8YkqdN1mr+AGnWpoZ9XMcr5+2VaQgi3bFB5YVEueGaBb7p5w0m4B7r0Sxr85Pk6SZP+4/l0aiACU3nslkTzmKhJbHtGBqH0QlnqNJSEWVKCBOHsoktw0kD9W0bDXOEOyJjA9n5pxxlBkV2hCFmJuXbUM8R+uI54T3UNWH9dQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV3PR12MB9168.namprd12.prod.outlook.com (2603:10b6:408:19a::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.21; Mon, 23 Feb 2026 03:31:09 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 03:31:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Zi Yan <ziy@nvidia.com>,
	Gao Xiang <xiang@kernel.org>,
	Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>
Subject: [PATCH v1 09/11] erofs: zero page->private when freeing pages
Date: Sun, 22 Feb 2026 22:26:39 -0500
Message-ID: <20260223032641.1859381-10-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223032641.1859381-1-ziy@nvidia.com>
References: <20260223032641.1859381-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA4P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:558::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV3PR12MB9168:EE_
X-MS-Office365-Filtering-Correlation-Id: 6618aa96-3655-407a-7a76-08de728bfc15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UeZ//bIwP4vgn6+c2L5zS099+Glt414NHeRFwiFOGA83CqAsag4tqFqOoZG2?=
 =?us-ascii?Q?08EFL+urEF0Yr5nVIbaYLdVGmWcRXLblph2vtTrXpW/B2di6qlNZ393Z5Vax?=
 =?us-ascii?Q?0MUiWJFswMHcxxAuBY0kmEnkguHO4GobCCYhuhe7wMPVUJc/HI4PaAH4fu6e?=
 =?us-ascii?Q?P0jBdGNxOVZCJ0uHNIC4f0ByQPcOG0Wf5XkGcokcYC5NBVAj55cUvDHzJ9Ve?=
 =?us-ascii?Q?DvSuRI+xWDlFpZaoKvH84EyLeAyeshRDKHFMf+G8aJcWvfCOu0SjEWXRsBI/?=
 =?us-ascii?Q?PBt1dgzlAgtkrbuLGVH2RfhYuri/b6Q5dpONbbRL2SumztmSytrFmBMU2dJB?=
 =?us-ascii?Q?DQr5jCWWyFnNdqMtgzuQ0ywhqkWIeiztJ6suhy3nprFBvAB9qVyHYKbywENO?=
 =?us-ascii?Q?vsKrS38SLWZFQLAT0htuYZOZ+Xado87R5AujW9hOyg+WDQEctfX6I41QeFpo?=
 =?us-ascii?Q?qoyVR81Gheg/hcFsNH69t9l9KJL7hlaC3Qrizth2I38IlWsbdGBd/oZLGibW?=
 =?us-ascii?Q?P2dPwHUDgN3kOkB7zx45jEBkFWYpi2kS+s/iEZHwTlmcJ1FDS819boc4tPun?=
 =?us-ascii?Q?YndmaSIJGyow2uwr4pPqQSvQA26yg+FodpUp35QNZ1YEfRhmBFLLbd//ocwd?=
 =?us-ascii?Q?Z+a1oosWWL8A9OVKefkKAZjRLZ/Di5IdFJtVt10Btdcfcm+4Ki2HkvbhPCYI?=
 =?us-ascii?Q?QzX2InMoBxQUQin0S/o3VfK/O3XE/aKfVPrwuOzteDlBze1+3gq5xQc4+uUy?=
 =?us-ascii?Q?cCLIfBAD/AP4niAQaErK9n8Edpp01EChRoTLQINmU/FA2vbR7hbwqVrNwcs/?=
 =?us-ascii?Q?EV5WpeeNPC2JcXk8kL8kIvVFgX33WrzSXoEiwn2qoGrLqYxp9PGXAgSbXAuu?=
 =?us-ascii?Q?KiIMZDv/Ta5y3Gbyh1F6xpzFjqxfSlj2/4aa8KsFSGcKIpD/DV1sf0ygy4EF?=
 =?us-ascii?Q?w0EsC6559YA9bVf2FOVDHxN1C1R22t/JTgCQvJEiuak6EZ1oxpDfwTlu/ajp?=
 =?us-ascii?Q?kbDEtaJgL5qAzBsIe/gehauaxXN8AXaz5BAN35YEy5shCA4jX4EJXpc/6HZk?=
 =?us-ascii?Q?cx72VDlnnFZMtimqtZF+/NWlMRMfuJqQ6xfc9SVxm7oXT/xqk6C0O/RvBV4r?=
 =?us-ascii?Q?cIf4MrQ+1rx3wdw9hdT6EKJV9BeczE9fzSpDFgxj1v93ZFqlXOw4UdImE8kw?=
 =?us-ascii?Q?ItA+ai0V2STgBKaunikOZwRou44nJrgxmlJaTrGkpor2Ra8vRbVLsaMyrxru?=
 =?us-ascii?Q?E4XnkDUIJ//8iXlj23SbDVKrge7Nnhnfq+VZVSGiGT6+ZMYY86LP4NPV184l?=
 =?us-ascii?Q?S7vAShb3/MAkOX3NmplH5oVbgnlGCNgVA/SdsN10MXxHytJlYgiM/i32FFv0?=
 =?us-ascii?Q?Gl1zgrMFN9TIBnrL49dZumT81hjL5bCH9sS2bqL+yT74hjWNez67xKvTudI7?=
 =?us-ascii?Q?B9WM4GVOComUEQRM6MDWQ3BaDxj3ihokR2akIymBSUH/hJieb9HWMERgfE/G?=
 =?us-ascii?Q?clihFWuTzgUMggbAmDOSKt26Ow+8bie3bnGOehNkR+Vk1zi/+prhDh1BiqlR?=
 =?us-ascii?Q?QCaDR8fK/QGd1o0gvlM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G5Jgwh7rR/Z+8BU1F6OYtEPzEZqysVibEAFktK8Jg6Lmye8+unScfJRwUrG5?=
 =?us-ascii?Q?cQfAngKN9NevymgDtnvv721DSHPAyvxIsVc8m/TmnXfxIpE28he43Nq0ZWDl?=
 =?us-ascii?Q?Y1kJCC8cJkidXul2Lc+6ZNAcfXoIbc+HYQQbf9/Z87cEtxvyOZVlxNUZLRpA?=
 =?us-ascii?Q?5tPLFarzW/DEybD9Ay8iB8YJGn5BQW++QOgWhL1AxWUji0YiOb/cVA36Bq74?=
 =?us-ascii?Q?oVn6EyUCuqkHFUqNSdS0elxeZJ8cSkHkf8BCS0pT7Izik9A51j5X0r0kVQxr?=
 =?us-ascii?Q?Wth/ETowiZoogSBnXnrzqU9FCT3gwj05ZtR/HzVfBRUEFvfw1AemUS78VtrP?=
 =?us-ascii?Q?FZETyjSmHonH5fKhjHb4arFPAgjzhCdRR/hMapK6fjxLBGiGV0DFJMWxQsEe?=
 =?us-ascii?Q?sD4hUwoT3CelC6vdHp6/FKZKvzTg3XjMO9952p2qVdxpOUF/xZWtU8VwNKkN?=
 =?us-ascii?Q?J1HcVMpvQkYuYkexpoEAMzgGlgYsCjJOhVr40LRy+Omlq9cZBGO3G5rYXgfo?=
 =?us-ascii?Q?/BO7TlSkQSJc91v7S7LXTpXEzUshlPTgOxAGPghCaKkAH0sWEsXpWGCu6GMY?=
 =?us-ascii?Q?Hei3D6INmcKkddxABMXqIF80rgflHc0TWCb8xUao9QO+XtM/t9GGWvJmyH28?=
 =?us-ascii?Q?tmRbVmbEnh8t/nsrkqFcbMYSkYB3tZkacSC79VxSIZXI/TsieCXMH35EDGbv?=
 =?us-ascii?Q?5Ja92Ct1ugbIb2seg9eJKKa5I/qP97/N0TrBQnI1ZMZG8XM0dxomuApgP1Rs?=
 =?us-ascii?Q?GvzgxKEdohhX7a1+WQ6zx/8BwsO9hWt+dPAqpJ/N9EDroNtz/R450tdImHsA?=
 =?us-ascii?Q?y51HmN1AUJNAIkAC4tmI9F46es7labV1FuFzQGhMykKRiBALbe/fyiNp04Uk?=
 =?us-ascii?Q?lNRH2UphWl7zSKVf8SwaIQ5ShZzeWZ309h6uz+uIBGQk0/WYFEY2kw38y/5o?=
 =?us-ascii?Q?zltyzu+TNMJoQARy/03+W+06AiGhqwJV/JmQGbVuY2JbLRhEGS/xw7b/mrcy?=
 =?us-ascii?Q?+yA8zXj2qWVxHVCOKDNkygDmrgxqADL6t8l8D5mXmLhJ1GOB8Y4RHwheGFMO?=
 =?us-ascii?Q?uZ/hqC9PHCPSIF1cr1vzWdta4I34lamVP/Ljv120hnNadAgA+6/yfGZAf5Vg?=
 =?us-ascii?Q?HivSw8hneLm6CarN2jW5tt9MzH1q27CDCbqLWmpROPusCe6a7Z/z/FinFFBR?=
 =?us-ascii?Q?XmndXA7pVapsP8YcOHtjnCBRQOuXyfPoK5MpB6vhIGdOh10yZqBhnSSGecdI?=
 =?us-ascii?Q?xp10TcYF7unHqtWvwcC9KkUY3jHC0Pj0o7ynS/TGPP+k0j6fC7Y4dfr44zUO?=
 =?us-ascii?Q?4oDZvgxLzntUcic983A69NNmrr7G/biSE3t4B92EZ5yPhAibEdkWONMY43LK?=
 =?us-ascii?Q?cn/U2ffFp7eW2u/8CnkhOWudiyrOobs/M4koyJUCGOgMl4OtNTAZgDttYY2O?=
 =?us-ascii?Q?R7A/KJtXzSx69pF5yDURrM76m0c36bMAIe4OQ+9Vvs5hR6o4bNgQDk99wPI8?=
 =?us-ascii?Q?GoyjwZ3uw3Im5konEJ+SawIscdHuGYrDfqJcNqxZUNmBAOmcnKIX6vVorUK8?=
 =?us-ascii?Q?gAwQFu9QRhOkWxVvTcP1cNk/Xzf8YrDpZLCGguSILtWY5cSC1H9/2Ztz10Xn?=
 =?us-ascii?Q?dovRsLQ2pKY8/tCEI+rXyGcJXRw9EJbSJZIhRx06/jJX1fboqA/+JXnPteME?=
 =?us-ascii?Q?oz+A/9sGdeTKu8YtetHumtrydJrxXJsrCpfrXDD6C6bN844k?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6618aa96-3655-407a-7a76-08de728bfc15
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 03:31:08.9493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GzjaWyzRdTgkhS8OqmcB+pb5WGMmidqhWwfv7UM8Aj0nqo/9yDtNibcNKB5zGuby
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9168
X-Rspamd-Queue-Id: 6E4B54000A
X-Stat-Signature: cjx9mbd5k9f7zhto166jess3pa65yc38
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771817474-1867
X-HE-Meta: U2FsdGVkX1+GfiAujN6Nc4FsaZzuIgGLjheYFLXtZS338e88nHBluB4GlUloDNoFzgKVfGn720YK51x8YdSHivM9je34m0CfBIRpToEKfjFKrF5ZcCimeLl8VQ5cs0xpW2+4d6p3cz1Z+hVMTHo3oAYCrKN3TdBH01uR3INHwq7K+WhQjlzisdp6UpAVsp94B+NcIENjl+pDDMuG8uTD8QhLEKT/ek4Ux+R36OLZ6TNiCkH2AutrHMPC3EwPwWSIyMugOCU9nAf4qOBEKS3qFDIoQPH9ArZr6napqunLm54MqJJm1HFRq2QPJL8+F/Qisr5aWPZ4zW6H10FyYwJDiaylCeHq5oI35mREXb+YBwXjOi4cCYJ7ybxWEXc9g1Uuzgj4aBhtM3D1E55ObavAD8qNlrYVFlurHeFq8l7/Dubgrkz5XC4F7tfNFfGsxUxwGXdQaX0aIEKN6DIPQtuzhdHEvMbuKLzSxRDUeDaO/g/0AAlUmIpeRIkB2TTIw4cHm3wDSZN5ptCFz8xUYjHkePU6Tvf3jy2giNCwYLTJdMmukan89nS6oa6eJtV6w+zlw+ZKBb2grlrqb8KlX6pc5Qo5NtnC+4Umb8LSMPrpDZyY+ciqe7Yzc/h/MsuiYAEhloN450WSi7xOAqkOTLl8zrzAMiiAOyIrSWC2XTWDvtqUTKMx8/te8K41cmhnJT76n4MtneY5DfZFycKbYaV4IF+dThMvDrwh3Ds4qy18J3nEj5wixYu/1uoJUFbEG5rXUviTHMA+Rz7vnCCltzjeeoraj48icHD2bQhtBMY75oo0A2PNhXys7nMixpdqaAozAy0IW6IMrBDSwq71uKMmFfMJ3Qyhh+4lSsRWgKFZbpkRRsvxp+ntrpxVkooEkJdEpbyPLFVem/JrmOC6vp8QJMsexwIEUjwowayFRQAvP+yJ54ie5q0NR80df1iptLDZ8I033jEfwYAxNa3D9jX
 84GZOoo3
 gHGaRp3A2tGWOzj9Gi4PGewjUl2N7mAgq6lHMBcr0koIPhe2k/8ACn0VIf2Jnm7agL02m4+IsWPqjMHTD1Fo9nXz4edmgO23pB2mAdlemZcREEMWMQ2pK1DBrOq8dDqRSNaAfMA/k4FA2E/taWBwIy590JNm7ct0UcVeZmj4he820ZofhqkAuNe7ihmXGU2+q3j+7ic7KCoFbQe76iRhAQut4SiHeJvdRreA8mhtXXqzupXKtIsyDG+JSof7pn1+zDmZdAGuwjMIWH1+qPlybbc5KFpckVlnBaQ+kdtVxEVY4fLybtFI/BV5NNaBYTeCXmnDZemnWcTQTPuqOwsfvxoSX/00xKsTX6v4YdZ2CaBd/ZRo6PleacZFwF7LNUF6Swa7a9jyOSWdwEdcdf3tvZPWtT8r8gnM8b25CtVsKDrLKWHxZB4R1oHpY7pRwbvR70n8bxbSScnQBPlk+hArKVehROQPYguuE5kCgY/Dwq8kfJX6ZX8MNB8cewDpsdIdoNQPU17JZaPg/z6enAMd0xlNn5YFXRFjSPKGnPeo+TBBMBAxRzH6HblGlBlrNxDIN485VZvsQiKj20Cw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This prepares for upcoming checks in page freeing path.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Gao Xiang <xiang@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Cc: Hongbo Li <lihongbo22@huawei.com>
Cc: Chunhai Guo <guochunhai@vivo.com>
Cc: linux-erofs@lists.ozlabs.org
---
 fs/erofs/zutil.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index 55ff2ab5128e..94310b70e6af 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -210,6 +210,7 @@ void erofs_release_pages(struct page **pagepool)
 			}
 			spin_unlock(&z_erofs_rsvbuf->lock);
 		}
+		set_page_private(page, 0);
 		put_page(page);
 	}
 }
-- 
2.51.0


