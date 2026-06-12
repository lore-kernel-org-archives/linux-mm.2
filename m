Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62703CD98CF
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 15:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C44E06B008C; Fri, 12 Jun 2026 11:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C806B0092; Fri, 12 Jun 2026 11:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0BC06B0093; Fri, 12 Jun 2026 11:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A09F26B008C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 11:06:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38B8812017C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:06:46 +0000 (UTC)
X-FDA: 84871587612.05.FE469FB
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011046.outbound.protection.outlook.com [52.101.52.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4286540014
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:06:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PhzCe4rf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781276803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iLPyusZSnMF4k5eAax3uV/OJp1yp28LJbcdeZGfQiXk=;
	b=keLSBv0P7VFTZvhvJ8sPNFW11s4M3p1pTol6lq217JraberZZ85tI603uAC6qm9VDWCIjq
	VG+YDh+nrchmq4IQtq5In1pMeucM54OmdasI3jdev8WzwdMXN4Bw9z11yGpiOafVBGrNTV
	gGy2bG4iIb/rsrLvmSaEVJ+liWav1KM=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=PhzCe4rf;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.46 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781276803;
	b=TzL+jqNrfMKnE3ddgCldoQ7wFZ+ka2rQwE/frMeQE7TgzDWRYJ7oHDQnWKPV51GIChqhsS
	PKRtwQ5acSoWDVmNwzyhxmpFTPwgxd8OlAmzsHHZI5xlzrmjwiA0d1mgbPvE8cFtUSZKCH
	1uFoXaYzyO/XTGzv0ZD0zJAl5PZe9O0=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wC5gHXjRyZ0aeg38YsNI4CRWqQ3+1pMW74SIQAUseSsqJCeFKMQyItGxF1zVRpbn3qYnzRQy+0bRd8d0OdTANeknZw5h3d6qyVyGIUYe6gI5s5JwvsLOPKKQwt53K1aiTlDKdHBopgIM6jXDT9yW3GMOhRuQNvR6xXjrYNNqIwH1NSgeRlSqJz+EtEBtGVnaKyuvXcn4ZY61v8beVUFXCqljtmGNBP43gQwijgO3zSxl6WlSWbbsH/crhNOo1gZld1yLTF8JjQ85qcXZCygd092CuxKM5puYpSSJpIDYP2oYMThKKyuw7N1OHUOEnrhsuJxmNCzRi9iuHnRgafB0/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iLPyusZSnMF4k5eAax3uV/OJp1yp28LJbcdeZGfQiXk=;
 b=mKaPX1jd603tPa3+O2KRu13FSFDGBuxv+GOlEaKbehCEfRFAEIaVyAgBsqmGgEQmh+4yXMaeueYl4NJBlA0UTqRtqBTPDLMUwFT+dJNZbavexI2lzsQ+lwD0aAiIBvu4Xr2k7GK0tKH/S/911vaJHqCxT/9bS3s0CII7l7MeIxe5EjfhNNKRg5sbvmpnqMFs9mfUGhhnJTEcvEibRsZXzPl8ML0d9r/8xpCSyXr5WCQ16aPJBwak5k6NziB5ELLVEEga2DHOefTAK1VztuP9XnnhYC9cbt8hEWHuj1H4jTs+kVbp53SwQSRTE+Aji1SS1VECNgtS34dvwvyINaIdGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iLPyusZSnMF4k5eAax3uV/OJp1yp28LJbcdeZGfQiXk=;
 b=PhzCe4rfBpfnyg6E4VWANhGU8CKczMtQUyB5sGCJS5OSMzr0ncJWASpisIC3U65m3OAHX71pnP2agnk4HwYtAkglSNIabVe7a3Lo4hLgHomdqcwP0UBEIRpQdPiqRwbpd4VJ14l53nGsiDRhk8Lj5JRqxOWr/AmJKNHN789SxPSj1s+HrUZy0nb7TAnPTUKHGNKfXXFiygdm1I6J9/grLW19FIR/i5SDtK60ctdOUWiix8Lf8jFT5m6d8zha4f5ltbshc8Td/3nDV5bq5mHsWI9JexHoVFwLp/GV4gfkOg2DySoWt8hcamjQgI8V0t8DRcS91nMj4an1cdGnyvNmFQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MW4PR12MB6949.namprd12.prod.outlook.com (2603:10b6:303:208::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Fri, 12 Jun
 2026 15:06:35 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 15:06:35 +0000
From: Zi Yan <ziy@nvidia.com>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
Date: Fri, 12 Jun 2026 11:06:32 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <02DF452C-DFFE-4B89-AE3F-7579F532C106@nvidia.com>
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0239.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MW4PR12MB6949:EE_
X-MS-Office365-Filtering-Correlation-Id: ddcfd7e7-ac71-458d-855e-08dec89431ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|3023799007|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	8WfYjdVZbypP7yR5eUaRGKVa0rSAtiOap6sTNFuboMoLgEoNVyojqbOsP+ZzjNMWnlnJhDzhs33xzhJOkQHxrMcLcrfMa+xHyeamnlxMx/PkmpiGfOPYHNYuig4eC3LfccEpFYhAQY1Vf6qn8Lt5B8+JyRg2ilLVfZ4ZKqe0qAtkwz+Eh7c/fuiln3Mjs1QRumv/SyoHYT+1+QiQlvktud7OcDUuFXWjF4uNJScwzOurVXPZVjd4oegEmzeG+w8dXq8zsR6zN2UelrpcKnVwDn+u0T2n178omCGjOZxnD6rmdgKLa5XXyZX9DjmQua1I9mmJWFGvDqxc3n4/6Lsti0ApP/9TxQV5ebdYYsSU/FtGqs+bm1VtuS1BdyPIpCaNtsuenJpnjc1NEJH8eaTUGe6eAHnKgYECViRpP5N6ZqqwxDXu1tajBOhxbBfaOMBWoaNq054c337VBW9DHJI1rwg4z+BZ6E4KqhdLlY//oJ58w5YtvHxaMWffC6ieSxqoCEo4qNw6ZUICHow/CnFRDgAnUXAt/dSKPl+QTjMiASmsZx88+N651V54fQOg0psbjwSSAFijkh+Icj2RdlAzsQfGBF/m/G5O2qtDTpHXiuFeTZ7v6Q2j3SGejene+MHi6xDIuAOAh2XjhBJ8qztRnHuDhdSdHTCq97+IEqXSM9s8zpRmZIY4iY2VA0TbQa7n2qWf9789znuvcIGNFOhS4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(3023799007)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vVrqZEsM2fOhbChUXtFobJBeSeQCuUbDhrxDSFfMiwpYBeD20Srtn1zQma/Y?=
 =?us-ascii?Q?gSRipotW/g1XOb/IIr2yHLuCbP7VofmXkgY0l7klKWebhfWPdt+1iKhSZ4QX?=
 =?us-ascii?Q?TF3VChZy1UywchCHUgDctKgUBMH3Fvbwnva2u9Cawe3vxMEbmRWVuZzdGm05?=
 =?us-ascii?Q?tKnDtuq7LD/ukHU/LNoFrz+6pLKIiRleedD7ttmOUHuqPjShl4oueuUP6dqk?=
 =?us-ascii?Q?C4PYbIPO+LooxabpuCSE+Z6yE/jE0qqINnutDCWHi+b/9UXnPoPE22W4g/16?=
 =?us-ascii?Q?8YL/q5mURhPYk3oIXT2NCfClZrbswC59c0W5YJeV/mSFr/vxLXV+HL0zJ+kQ?=
 =?us-ascii?Q?V3sGOWkpOC5J5PAen8umLqLw6aKG3g+phYJZ8PiChmoJhygI0VbAUIqhOcpR?=
 =?us-ascii?Q?LrXtmng+hvRypdBTkS/l/y18/aWkslxFT6NqCWChrEGpTt5IfXYIqGAfZbrf?=
 =?us-ascii?Q?iKN0UrCQzXua9W68Zp7YEJB/H7iffSlCCkC1Qeo10sIPa5mfye5v0Ap2q4Oi?=
 =?us-ascii?Q?03F8KWEM86ECOMf8EpUMNYHLO1Nzkbk+wbGps33nSK2esDJRmgvX2YHY91SY?=
 =?us-ascii?Q?2Fz6MX0hxBcQULGUkT4wnUxXb7S870c/H7gJ3sn2ek3od0C7TLho3yRAYQFr?=
 =?us-ascii?Q?sUAIj9OaMjzZMFusPaxehXV1gwdhmrpSrE0oBtRkNnhjFQ1rlm6Tg4JHjzZn?=
 =?us-ascii?Q?WrOUGdlylLLQAQxYi6MjxI32EDYIIq6UFiWk1bjmPcH/zJSdasaIiGMeeI9p?=
 =?us-ascii?Q?TWhKabAp1rtr5/nmyFOiNBm8LNeV15fyLtR6UZlyOcrfJvpdzSwnUQ5o6JGa?=
 =?us-ascii?Q?6FmCo/u/4ZFf5oMrA2xbdXnFPI6/VCxc4KNuLKEHsv7YThxa+a6uRcS8TATg?=
 =?us-ascii?Q?kRFs6VZOMOo8G5zlWzCZM2XXRmLK4DB5zJLNXkqnbVMf8VS3PzLK8oaHRxXA?=
 =?us-ascii?Q?8g1IcmnyKry8w1wdNPX0xhxRo5Vep4h5BvLxRhGGYjw1kuSM4PJVYpDC5KTo?=
 =?us-ascii?Q?A1JSJdjKiXzvKA+86yOGBEOAm0Qh0HtoT+kFSpsleVBZU5k66S3FT7cE72ls?=
 =?us-ascii?Q?OkaVONnnVbSROjFAl4vnwCYt5+yXDczkXLeeP3FLro9S2UIuwKCwScfbl35A?=
 =?us-ascii?Q?zt/2ixtr6OMrsFpzqp2lXc6TgBCIVfa0uH7B6pSDWbwWMedxDl1xvI7Rl0ro?=
 =?us-ascii?Q?w57pammO31eEFz1iMGjYohBzIrBYtmC5r0F7FcEHeC3fj3ymNLBgxp0klchm?=
 =?us-ascii?Q?FujpQlkH8O4DvSeo90wOwiGUpcsDOD9mRCNgk95L4vWmzBQzyBcolRhYbwbV?=
 =?us-ascii?Q?ajqELECMu6qQifUFlSB3KWtI/ejnezDQE13ArqjiVY9eubjCtasWU5+4KIbn?=
 =?us-ascii?Q?H2h5e/g9kL8h35ZIznEfJqrzG+OrRjvfxAPePhLRbawXbZerWYscHNEVKZns?=
 =?us-ascii?Q?Hqu3vst3iO5hW8EzIurPSgWB3fW8xiyBTkos8Z/yAiiaVD+QAtxLz4BxPRh8?=
 =?us-ascii?Q?rQsqrPBb8PdGaH6HAdypzPdoh6j+jL3EzlIHgHYc9nGz4iH3AmALFgtUULl/?=
 =?us-ascii?Q?cHq9xQDUElrARTkG93BiqNpJJyZUiQQdaEAG/562vpZpd0y+KmrtIak6YnNB?=
 =?us-ascii?Q?XXGKYrAqdibwzcVJQMFyDVIYYF+QM5hOJTFgSlok+ZrcjR2l2bbWZf2AgeXh?=
 =?us-ascii?Q?Ah0QcCx59aKX2P4SfPbvjL6eeyPAe0otWNZ46bpUkUKVcTJY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddcfd7e7-ac71-458d-855e-08dec89431ed
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 15:06:35.3559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YlfrVFhPC/Sraj9EYZaErVx7abWTpZw5oBaNtziuqxi9jMru2f/egQR74EAFBeoO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6949
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4286540014
X-Stat-Signature: iq31onqqnnryyggnu61sd7g6535wnjbf
X-Rspam-User: 
X-HE-Tag: 1781276803-371055
X-HE-Meta: U2FsdGVkX1+kw2hWc9cm/nUHq6DvoV4h6wBEGiPqrAg/DdA0AA6DacjPc7FyEewew93g6fU8FU0g1YsuN9dbyE6NzhRkmKADNnt6eB18z44mTHzIZA7cGHG7VWH4UbVqh7C1HeueN+Cqsz9aH9RIuWC6aL0N5j5b8EGZRcfCi7hoDJMq9S5HQvYmUcx7TRZ3VKlSMS1y+fEqkfCVH56K2K1pu+RGGWVEk/sR+RvDsgYLfTNQrj4HznacPfiC/qvnkSAARPqgYxkxuJg1H8wTxpX2I331yrM0pISmHrd9a97HmZfnMYG8xh4Wtnu6ZOeoB0DgoFDSBRB/U9rN7UV4zOn5HHHdvXCAk+JqXDwA4x36sl3uHbsz1fqKH3OyTd2bg+ns8CkFbUxZGVluw+xaS/Mx7fyPgpSPoGtGlhCBuTwWANh9VekCgv/Y5EOyC30ko3cptNU/Kw5IYH5IdSiXG+zup2tXQEyuvYNVLobJcVsJb9Oaw3FIxuUfIsQQO8cioxgZtAAWkys1POy+tnFpIE7cvPF5nVL7dnwYj2IqjZXzk35uSXHGNliygzQGOSX23bfpUTU74nX5WTJrR9IwP5RArL7n/FRkKYD0TgZfBfwn2QHSZXHTujbKcj274raMu4t4YTvydWBOIV2U0hi0kDFtNbGFobvXAjmxXRCzu/IvWx/es+70QD39Ztg6EQ4QM3zJpx2JBzty1t2NmOYxRf7tCf4WEobyIfl6iVhUiHvxY+bXVQwcYsZfDWf6ZoqFsDPI8B5x7MfpCxQMgJenvlx8sXBY5oOj6txJwzdv8KTVnNAc5Dwf+p1LNDvi33QpgY5ydu1MfQ1GA3u+r5aEUKLuGjx+P4UFSL2TwnAGJqvd3NtBTeI4KQffv12BSFvxEd5+gnRjtx2QQXmWiFctk8IKL8orfKaFFXYzMEiUJlr53XXrlSyVnU6TnSGXm5YJTRJMi4L1bjopuEhCWaj
 ajsy3XH8
 x67S28NEyj1ao2VD/HO1rL7vNEGuOGNvw4OCs1h/rqSzP62gK9ColWrKgaxSoLaJQNz2j5TjYmZpU9b2+qg3Vji0+0/mJnTqvIN+nRsML3T+eYPBAwPQjCldZ8g8yiV07RgRM9PlV3ugXtlHW4hPUf+s2SqsvDjkfq89vcS+1+yCXDyUHAaRW7IjErO9dB6+ZBaly3L8YI9lvKK2EYWvqEX192etjWDDiDgZBOho0kUMzTcYq2x6PQaJ0KZr+wBns7fiUiiEnt0L4X33JBNHfE1ydYReKvxaN8aS1KgI72KEH6C4fXgEjYkmhnWVxeADFTIeb2PbO8/1kfYH5NQd6q4HENmFCGgUJuAqmpnfFCPYcRL2M2RoIeE1mpq6OLhgQ85jGymUXUdLb9zxdthvFA3TYN7T9eh/NzUAOZFZH5Ng+EZsZ6jONiBVBHzb7lAhQRhZNkpkgLnWNMJRobfBxFhIjJh27q9qG1zVOS0aQXMB3g4OHeUoo75P2nXsSxZKGLSiWYEX/6tz1FTNbtN8lppBucOUV7LRqRTsvA9N9haPa+6s3+NA41oj9Uw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12 Jun 2026, at 10:15, Brendan Jackman wrote:

> This code uses flag equivalences to try to optimise conversion from
> GFP_ to ALLOC_ but there's no clear reason to believe it makes things
> faster. Even if it gets rid of conditional branches, it just trades the=
m
> for a data dependency.
>
> CPUs are pretty good at conditional branches. But, in my GCC x86 build
> it doesn't look like there are any branches anyway, the compiler found
> some conditional instruction tricks. (Caveat: This was extracted &
> annotated by Gemini AI, I did not actually read the disasm myself)
>
> Old code:
>
>         ae50:    8b 04 24                 mov    (%rsp),%eax           =
# Load gfp_mask
>         ...
>         ae5d:    41 89 c4                 mov    %eax,%r12d
>         ae64:    41 81 e4 20 08 00 00     and    $0x820,%r12d          =
# Mask both flags at once
>         ...
>         ae6f:    44 89 e1                 mov    %r12d,%ecx
>         ae77:    83 c9 40                 or     $0x40,%ecx            =
# OR with ALLOC_CPUSET (0x40)
>         ae7a:    89 4c 24 60              mov    %ecx,0x60(%rsp)       =
# Store to alloc_flags
>
> New code:
>
>   For  __GFP_HIGH  ( 0x20 ):
>   It uses the Carry Flag (via  sbb ) to conditionally add  0x20  to the=
 base  0x40  ( ALLOC_CPUSET ) flag:
>
>         ae63:    83 e0 20                 and    $0x20,%eax            =
# Test __GFP_HIGH
>         ...
>         ae6a:    83 f8 01                 cmp    $0x1,%eax             =
# Set carry flag if 0
>         ae6f:    45 19 e4                 sbb    %r12d,%r12d           =
# %r12d =3D (gfp & 0x20) ? 0 : -1
>         ae80:    41 83 e4 e0              and    $0xffffffe0,%r12d     =
# %r12d =3D (gfp & 0x20) ? 0 : -32
>         ae87:    41 83 c4 60              add    $0x60,%r12d           =
# %r12d =3D (gfp & 0x20) ? 0x60 : 0x40
>
>   For  __GFP_KSWAPD_RECLAIM  ( 0x800 ):
>   It uses a conditional move ( cmov ) later in the function to set the =
 ALLOC_KSWAPD  ( 0x800 ) bit:
>
>         ae72:    25 00 08 00 00           and    $0x800,%eax           =
# Test __GFP_KSWAPD_RECLAIM
>         ae77:    89 44 24 30              mov    %eax,0x30(%rsp)       =
# Store result
>         ...
>         af2c:    80 cf 08                 or     $0x8,%bh              =
# Set ALLOC_KSWAPD (0x800) in temp reg
>         af2f:    45 85 c9                 test   %r9d,%r9d             =
# Check if __GFP_KSWAPD_RECLAIM was set
>         af32:    0f 44 d8                 cmove  %eax,%ebx             =
# If not, revert to flags without it
>
> Testing with a modified version[0] of lib/free_pages_test.c (adding
> printks with timing)...
>
> [0] https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58=
e106e99e19bd3b98/page-alloc-test/page-alloc-test.c
>
> Old results from a Sapphire Rapids consumer CPU:
>
> [   67.157118] page_alloc_test: Testing with GFP_KERNEL
> [   67.157122] page_alloc_test: Starting 1,000,000 allocations...
> [   70.704446] page_alloc_test: Completed. Time: 3543002 us (Avg: 3543.=
00 ns per alloc+free loop)
> [   70.704456] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   70.704460] page_alloc_test: Starting 1,000,000 allocations...
> [   70.944672] page_alloc_test: Completed. Time: 239980 us (Avg: 239.98=
 ns per alloc+free loop)
> [   70.944675] page_alloc_test: Test completed
>
> New results:
>
> [   70.079015] page_alloc_test: Testing with GFP_KERNEL
> [   70.079020] page_alloc_test: Starting 1,000,000 allocations...
> [   73.669396] page_alloc_test: Completed. Time: 3586954 us (Avg: 3586.=
95 ns per alloc+free loop)
> [   73.669402] page_alloc_test: Testing with GFP_KERNEL | __GFP_COMP
> [   73.669405] page_alloc_test: Starting 1,000,000 allocations...
> [   73.905084] page_alloc_test: Completed. Time: 235496 us (Avg: 235.49=
 ns per alloc+free loop)
> [   73.905086] page_alloc_test: Test completed
>
> Seems like a wash.
>
> So, drop the flag value coupling here and let the compiler and CPU do
> their job. Superscalar CPUs are pretty neat after all.
>
> (Used AI for the disasm but the rest is all manual).
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
>
With your own fixup, it looks good to me.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

