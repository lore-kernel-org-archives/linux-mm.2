Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1A7E92734
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 16:41:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3CB36B008A; Mon, 29 Dec 2025 11:41:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB6E6B008C; Mon, 29 Dec 2025 11:41:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98A26B0092; Mon, 29 Dec 2025 11:41:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A88EF6B008A
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 11:41:05 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56D5E14025D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:41:05 +0000 (UTC)
X-FDA: 84273073290.25.3C9807F
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	by imf24.hostedemail.com (Postfix) with ESMTP id 786C6180016
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:41:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s0PblPa6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767026462; a=rsa-sha256;
	cv=pass;
	b=ou0WzITF332LLGufg4SsTjdpzubKdLAZKLDufDw3nvGUPy2W8IJIOt32STUKUnkeQ7+/zT
	31gd/dnKH7aL3NzuG/D+NADkf2TZqP9FkWC3RplPYNDjVGp+/kkfqmyGElXEvA7IaofBFZ
	rZ/snoupTTIP/x/PdUQnjIVWWqcqcHc=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=s0PblPa6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767026462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MDIoh+mPugToF2eI+YxN1F2kSdmJlrxfMYRuwZYE+M=;
	b=uEcism4A/nSYV5rsYhnZYHjEVTK1FipHF7GtCHdqfpr0PyFaWjZKHRrilFA9wBJpMxkQmr
	RePwQzHIIlk0+gr/hwNDpCRuirb6ATYSLHzGxvo+ed/fo1G01CPF3geUY1ov3lMxIHCPt/
	5D3AZccZVpvmixjpuv/tS8qTWea3+KE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hg69ZfdTtLEVZ5//Nz8Y8Gga9CYZuljGv2QKo3kiO1Q6h6uUnAfZbR3bx4qgD+hy2lkdhDV3KsnQNaAuwXVwHAtsukbeL8gq7QcKMKb+NtlxEpD4KvS/HMEIK908D4BZh4A/6hnQ2/vtbSBNA40wOSvRukT9eP7ZLNHUdvQiK598SsLo2vtsAKv9gBaKRwY58cj/DWXVkLOcVUE0RyPGWlaXIxTZOeywhAjivTquD08BnTHMdaXk9rN2f2vKMX4VBd1JM6Tc82iBO7YEUkxfT0G/S/jNfXM288NxwbL4su5O9n0gP9II25li5DOXhlXOFZVkiFLZr6EKLcj7aGZmbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0MDIoh+mPugToF2eI+YxN1F2kSdmJlrxfMYRuwZYE+M=;
 b=NFLUbbmXpFU4+9m5rzuoSy2+XdhC8/DmodYyFWKqWtjfHqfv3JGmyFDKTqRg8RWW8d6/aBJ7laIXu5nMwOV7+84tplXLG3PvKw5N0D3zj7dtjuD3wSt95XuVoQctS8HgQbGc8EnRekhpqnmvkwMga1dqitQPhftMhtpw5B1jQoN8jCCWHIcYvcKVspvGZhrLModnAOYW0gPtmZpoY+340H3bRzt641qGD7ZIozD6Q5bgOjUg8aLx841++gDjwYerh5K/VjY/VZgIRX8l+yjLyBj3txLQ7u6GlN5sdSTWQfNdCxVo5GwVkPlWNXl0nh93AohKNFJ77zhcqhpFoIoz9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0MDIoh+mPugToF2eI+YxN1F2kSdmJlrxfMYRuwZYE+M=;
 b=s0PblPa6ImbF0XrTwQsxBlGqvo9oafF/AbehloOL+k3j4S/MDHj9FqwYu35bTbKYB2GW3n9HApHrzRjHTJo4k4NAYdV309OmnRj/t+Ekj4bnNwPtN58xV70r2hpKN376ga2Qhr+iwwPYVzaclU5dl1w+jzhD4zcPYcnAEr4madUPg9b+HBI5Nu6eqdhK1rptEJh10I8FD1BB0OEWLhHRi1N4T+dKKbL4sfyFIaubPbfr/iMGmX5f4UbC5Gofc5smhktXqVFE2D2P4BKKTkkLFdxmMrqwAxsklSLzid+fRE13InPBxEjx3pE6j5bgB7skfr2HVWai9Oy5319NbFLsQA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB7288.namprd12.prod.outlook.com (2603:10b6:303:223::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 16:40:59 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 16:40:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/5] mm/khugepaged: change collapse_pte_mapped_thp() to
 return void
Date: Mon, 29 Dec 2025 11:40:56 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <7A313858-704B-4E3F-8133-020213D108AB@nvidia.com>
In-Reply-To: <20251224111351.41042-10-shivankg@amd.com>
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-10-shivankg@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0327.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::32) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB7288:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e411dbc-2d37-44af-7b56-08de46f90b77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FRIKDmaeQTfi46CApEpT3nUs9Pl+bYo1gs2TGPOwNh4I6DcvUvTnTQYAWBf8?=
 =?us-ascii?Q?eAD/C9xBtT8RRlIHKmfEMN/j7UQ8c/I1FAQgoFVeBfafihslnIqAYOgLAkXC?=
 =?us-ascii?Q?zVker+WCl7EEUJD2B2+eX3SJYHYlC6AzPrnwf0JoU2gYPcfU5FI5chPsBMqg?=
 =?us-ascii?Q?9kWoDxsRhZDPzwbgtXtWF4Q2q2+HepmEVEa1/NAv8DMDX+SpKrD5Mxsacvh9?=
 =?us-ascii?Q?r30WsDLwq4OiV7/z9oahWOB7ARplbcQAi+5tkLv5EmEgp+bMjYG0zjCly37V?=
 =?us-ascii?Q?pjQC3O5tng/70RvcNf9OpFk+ospgBZ3K6Y1rnm+024GcU1QhRhNPL3xjXudq?=
 =?us-ascii?Q?hCnpDUjeZdhkq7SzJrEiLoqAlF88gM0pl6aI31jiv/APbsG7sbsp/I1XkjQA?=
 =?us-ascii?Q?qhrq6fNwdE0nu+SpuiJ5ojo0WKCOO0uoMz+mUH0hCl4Ro2I1zKDPhTvPf9uo?=
 =?us-ascii?Q?iYKLSmxZWs731ounmlunBbR/Z+WshzxBUT3YtMbbM2iZOTY2daHJPw9+vxJb?=
 =?us-ascii?Q?RmqqbU0sS47XyheNSO5uRnCYkm9qPQGhzSeRFb6QBfJ7IKIqLsVzcTr28TEP?=
 =?us-ascii?Q?HzrfGIIVNSQrL0dFbGx2vRSjGM6kmZFs2mY2qQEOUwXnm0nKS7dSbq/Di+3I?=
 =?us-ascii?Q?62yuR8dtNRprIdOI2T/frVAnlaZ9QHXP0x9dIgVTkNVsw3y0OzZwvBomQQd0?=
 =?us-ascii?Q?6nertKz/lfCqJbMcMMLuM32LrfgNKLtr2Cr/j5S6O/CTYoZenv64w6oQCFvB?=
 =?us-ascii?Q?4fE9NqnS2pTssKMbWUSWZdYCP0/vEEwroXUqhz97SWPImDJ+b0qISbEG+8Z0?=
 =?us-ascii?Q?tgDncZEZqtyKJhzC+IXG2pFhY2u9s6g/dx59so8ZTR6bkLZBGXWI6dv+3IdB?=
 =?us-ascii?Q?fiTPY3N9DJXpMhd/4JioSkeL6bGKxwckcSBFMFmIuuXmBStebqv2z54DpAQM?=
 =?us-ascii?Q?4OEl159vf+VOcn1kb06Xwjo9w+S4TRQPhH3kAItUAk1sPYV2IA8N5a8cTJ/B?=
 =?us-ascii?Q?OCZzoIVuDtRjWfM320yCTq9XYyn5w9sIMg25XZ3oS7MeIjrvVfJKLXpLFXcw?=
 =?us-ascii?Q?WWXkp0IznQVyHoLswIgh7RS7w2Hh9bWHcKYH2Bgq50y8n8UnvP8wJYdYmfYe?=
 =?us-ascii?Q?DtOpglXwLKqpCRKS0RBzVc8gcA6xxHxyKrVAHD+mKiLe3OG+XEu3K6d5ACxi?=
 =?us-ascii?Q?NehEkd9LtZ0aXjQdNvdPBGKspOI7SdXJfRbdSsRfsZ+HZ3bZj4WYuHLzO3HT?=
 =?us-ascii?Q?YpKGAQm+bPPUiz1KNfZCKKUDvhIBcb7sTj7endaN3FUbrKQVXLlTyftunDTk?=
 =?us-ascii?Q?ytoEODjhsKpeHr2Zj35O4sbsdX9TCkLcizWM71dWkmpF/Ljd/k4RICtDVOZq?=
 =?us-ascii?Q?rBRc0RL4PO0Mt4/vEDRQXZW1uoqfrMpWlNVKCQA6GeJma6SjpmoH/MqP8voS?=
 =?us-ascii?Q?K7TE8Ne9acq52j+E+ZQG9FsRdovYDgIa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CToIZhrVuUwEOV5HdoU5GNq2Vb4EvmpR6E5tgQy4qQCmDarybNofEjVM/e2T?=
 =?us-ascii?Q?dO5BjrL86eck1aIJSeDYt0hEW/diFrfBlAm45cvRxqNg+IYM4/PRCw7Kt3CT?=
 =?us-ascii?Q?bFBAFqzgY3ldfxPmoX1rNeuE8bP80sD8aqRr7aLu/aVHVSRSpR2zCxj4Epk6?=
 =?us-ascii?Q?3HaVvFo94LgEOQvg46zFnURS4RQ2zOLgYJDT71rA9sByGgpaFlvsDp7Fb8xb?=
 =?us-ascii?Q?0uplpgxYeESUEIXyzgUwzJNn0tk7EoVQwti8pC5XqffNOtdiFvM7mmqdNpTu?=
 =?us-ascii?Q?ND0jSyLJh1+ZTkmPvj1Ne6GaMBb9YP1NC1F9ya904//kf9rOYYJ31IXod2tO?=
 =?us-ascii?Q?SPdOF/f2F8/ddgZkQDMKwoBw1GMolalrgGyvQ7k1h5a0tOZJQSadEHCHnfxq?=
 =?us-ascii?Q?XthU9cGd0hp0kR7gbhkFRqA5E9/PuI1lYmxEKofwcxGsbQuFBTQZohVW0m/k?=
 =?us-ascii?Q?0iNmYchnXXu07yv9DFh1HI3R/Rc+Vi81tOIRAYBLXh/AqSgbdq4Bny1em3Oq?=
 =?us-ascii?Q?zlNbHarG/wqDZdMuPPCxba5dtfHsRCOKqe80KWyigZKOV7yW5n5T4XVxQ8sJ?=
 =?us-ascii?Q?cnRVkDgUZHd1rhxVGfl7hCosqOnK9icMDv1z/i68oDwEIYlxAZcKR278/J3w?=
 =?us-ascii?Q?IiHqkAPiQJLyz9xXOyjrh66j3kL/V8vHH0ZGrug/c7etwVV3Bn8VOxyhZLGL?=
 =?us-ascii?Q?XaF7x4BIRgDncj1Eq01ryGtV+iY6DmRdleSX8kdaxOapLaIdcIGrXsEMmEN6?=
 =?us-ascii?Q?7rVcjzh68M8tAJoRb8Dv8ehUwYkdJuWhn+r8gbP4XtZ47WlWOqSausY6BmrA?=
 =?us-ascii?Q?21UGeViZxreBTUTt0auk7OnMYUmowRGUwk24yG2QYqi/Z+rCu9Q4qlgV8GkN?=
 =?us-ascii?Q?ORFYcK/Eq4Xsh6UJHqW7sAhhZKzrElxo9KYEcxY+2wA5eVKgQ6RcT4t8sZue?=
 =?us-ascii?Q?IwhWMjBNg+8xAMpC66vegcCY1lSuGJ2M04acltgcHIjlZeUoOxEUTjfGKrOr?=
 =?us-ascii?Q?+HRO9IqlISwayqEJOk9xtADFfR1VVysmJoOhb777lNpJpUgRjIrVk1cnDADV?=
 =?us-ascii?Q?LnRjox07Itn61pMpueIO3lXwxfzZIXOheagUFLeNrPgwLImOdRzefGGMGxIi?=
 =?us-ascii?Q?uRMmv+6IPMiwDLmmgFWEmKE3mCaywWjbCrcdCehZBbCkTWNOPzVn04Iisf+0?=
 =?us-ascii?Q?p6MMFX8EMAiq9nWPZguQOOOe6Hcrdc1Z8H3eAeir/9tRatbmjGcjq/NwljD1?=
 =?us-ascii?Q?sxkqE2uI9NpEuFUYqxc1Jf4yETAfA0Da6bnmA1WnrrhCkpE2HUCXYKrefNKu?=
 =?us-ascii?Q?yUe/WjunzYyse7gSbbGXJsZp+D+UsqqsOkCMa0ptMW078pQSuczSSsrIjoCy?=
 =?us-ascii?Q?f8NAKRL8uGiRi6De9FpxsFpM5yoXZ0eaGw4v5Zk05FpywT0EkrFdrGFtLUNJ?=
 =?us-ascii?Q?Q98Eujwq6uRVWooWc9HW82TNF4W8kVPMKSo3fufyjuc5+xmAoVddx6Qr1H+j?=
 =?us-ascii?Q?mJ7drTiY1M+ha2GnF8JlzyCpUTOtSDfhzjjFlv/zZ2jly5WsBwlpmBjeyJpD?=
 =?us-ascii?Q?Tt1EtNx7pJis6gIPtQAQxAOiM2oldLowZosGJlHBCFYClcSUCkSpDl7Dos7f?=
 =?us-ascii?Q?htglHYUPhG4SE+JBOcaBxY6UVBkb3Dl0WgVQXBByvKOtkjLJ4ojENhkY9lOP?=
 =?us-ascii?Q?W9x4AyW1NoETLjfPmNgtU786FrEtDrapJYjujYzKIbD+EVwj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e411dbc-2d37-44af-7b56-08de46f90b77
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 16:40:58.7595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Bt+CNbGfhqkAXuh98qqPPdUF/isFo31VkrMpXthYJ6L06Qc894A8uF3hsoyQyCK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7288
X-Rspamd-Queue-Id: 786C6180016
X-Stat-Signature: b6skxakp1ubykxi8816nwdesanu3na8y
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767026462-936649
X-HE-Meta: U2FsdGVkX18NkjEjcbieh3g6gfdpFL3l2Jq/qgcRYhPAHfXylWah0UTK/0m1HvkEpYQkjrFSquN1lC6PL4fjz/15i4hhfaDQW/8Y+uKy12SX0q8fttJrLwRVclEJOqYc5EduORyVGepEMoPk1tYx0OgyYLbHD21lJ/iJPtriWw7uJfv1UJZkTfJxm1bNIYQIfQ9l/0sjtAQgfigYBfeCf3lyzBhdwu9BXz+YAY4o/zclUW5g6YWrvDSt7Hm1Pqeb6Hw2ACATjO1TZXlQIUo5Vcdf3loAKtQPlJc+J53ngPL4m2bpKaz1xKF3BBN5lvJTkGfavT9kXf1Yeq4DDmD2p83UbyfT4sYuN4AVjqLWf3FvCZUkSWkgk5/zoQVd3i08BJPGSP6t943b2Ut58gjWuKH4tD8g+9MKThSb3uhqI2amVinWKQLQKFRQYFXPzu9b+3n9yw3AferCzgkekQ/COUO3uv6ZFR4s5ooPeAkpxylcFPYKBjh0gHwgpkSbNAwqKvNvGRGSd6qlsayLbMPpDbAB4UTVmC1pj2t4i1CnDQnALCsMXXhh4Yve9689L1VLywhGlDHoUvBlEpOVoeuV8+VZ9uKDUPSMTl5EBHZi+XxIblTzh/RJ6SLGMgoTFOfl+Q/F9cCzEs4WdMHh50YtQtdqQbtpClKBKUmvmf4otoGEGE6k2/RFKfM8VFKijlKaddkNyk8cKQjJvPdAkMX56W+tDxch8kw5CA0YBlb1oYCJLJ+a0hV45vZaoULpWP/mKBmLcmj3ioYdZKMbtgwgTb+X0A4bljdOdRMejYxOwvogEhAJ4dqiTQd45eLkIOnASoQKYguLMHtAeRrA7roi5JYSRLAk4pt33LG9bfqpi3L8irjklCuXOTNrd7c3ly1/cqxAxS8kZA2+7VBaqLZ8/dUsr5qL23pMB4batyB94yji57MqT9Ls8F2z6nOSCyY5OLK2cOz8fyojDlKikAT
 nj2CpmZg
 GrNIhNJ5NUlRQ/z+aHcDvnk1BIizI3ztY++6qDBiVeP+jcjHPZvhdpPAbyJGoIG0Pq4r0UBcLc07dHOwy52ACGWHFZCNKhuyIsUepl/dr2Tw8a8CuNJ387FTzN33D0Cr8D4NkV/3I62sPvwTySpdNU7RZ8C8+cPayXTXXaMPxwpa+8sACFypsON5jtzd64iJM8SqFa+Vup6LQpbf/24lmTsaK9GUPmDS+Mvcx4yeyhTdPYxuC1ZnF9jOSBPoW0YCPOh28j+ArT2DathTmYwJRIrnV8g6CF2IQ6cogqAZHzkBmwbl+22o5ejpvPZyApLsotTxPWaRPH+XTP8sDRt6YwCH9/P4luaoveZlC6DOIV8JG92hZwkNJAzF1pyGzb0MVCHb2hFA1UskL/KvbWMZRFM86in9ChuC+MY9U9H9cjPW8zfcvX5ROfMxJjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Dec 2025, at 6:13, Shivank Garg wrote:

> The only external caller of collapse_pte_mapped_thp() is uprobe, which
> ignores the return value. Change the external API to return void to
> simplify the interface.
>
> Introduce try_collapse_pte_mapped_thp() for internal use that preserves
> the return value. This prepares for future patch that will convert
> the return type to use enum scan_result.
>
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  include/linux/khugepaged.h |  9 ++++-----
>  mm/khugepaged.c            | 40 ++++++++++++++++++++++----------------
>  2 files changed, 27 insertions(+), 22 deletions(-)
>
LGTM.
Reviewed-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

