Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 300C0F54AB9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:38:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7178F6B0099; Tue, 24 Mar 2026 09:38:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EE816B00A2; Tue, 24 Mar 2026 09:38:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DDC06B00A3; Tue, 24 Mar 2026 09:38:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 493726B0099
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:38:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4E1E93766
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:38:15 +0000 (UTC)
X-FDA: 84581060550.10.F1EF270
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010039.outbound.protection.outlook.com [52.101.61.39])
	by imf17.hostedemail.com (Postfix) with ESMTP id EA3AF40002
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:38:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ujso6Bdr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774359493; a=rsa-sha256;
	cv=pass;
	b=nlyac0dkx8+fPM8Sc7arTOi6QKDOytH04CFuGkJoSh68ConyVlXIMVaPXSBChLYCSqwfA5
	YzEGVwdUUr+WiKv/31IPKjWu//Te3JLgUo+vJyOEnuZ7qh/EJU3CYAF3DrWQxnNxkOVXq6
	PtBQsYGxVoMp85iDWIMcMJYB8OeWubk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ujso6Bdr;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.39 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774359493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/faBWtWsGwuWbhjX6PGGsqeJiUkrN14Pn9/lLRp9Zco=;
	b=2dciU1OapP8cydUcrJDsEil4pgOZYnCKR0RyG/FBi9iR0rAJvj5K+zL/qKn4/OZKIxJrzg
	ypV2TM/ju+d/eBFIi+kBrTGtQT4xsUOaQ8SMtv+0tBn8n+3oUKGXqQrbpIQP6KpasnIVGF
	r1MP3Lk+lk8/N/5q7UkNw1JL08VeRGY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dlbjBO4LCQZE65Y72hDeijb/sxV3h0xIQsJW/egCgWhKv3h6T0nxvvO44IWqgCziJmysNUIdJIpmpeK7frwD2HyZxUQBNpBMLGgnyDws7lSA+UFn59nMyneS7pTVQVtodOgF6qamXuQ8jIOMP7wA1QGWEI3nZqZmKSwQ/a7Az5cGbRTCDdFh6DhEyBlJbtpRkIdbFvN61laWETIzOOtp6Vf0ez6G+Ns/4lhFHaYMCObmtmxOk6gERZaNTNsp00TsqokLl+ZDu8jC9P0FlmzFoupvjEeeJecGfzyMbQqWgjf4SWbAwQY8G5+yuhumZBMZwhv0KK/KfD5v38k9znKAVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/faBWtWsGwuWbhjX6PGGsqeJiUkrN14Pn9/lLRp9Zco=;
 b=QwndCzNLbNpBFO9+5Zf3xWzn9uELoWC7QopAdCoQKrqLriA+Hcf1xP5FO0DAkipqNNkmYQE451KkAxFz48tSXg08C9Yx/7Z9bBDJTBKwVajNF2r7JdpOjvu3Rr+w9NPHNXywxeK4SJPj4/JbB+YLxpCQAZL0m+jCK8hr64uiL8jxcgo2Yf4j2g8HARwNZUj9jfrV42NX30IUItafT4MmV4h4k6xJZJZIN1r+2PFfuiVUKkbKHSt71ceubfpzCACgPQ6oa4jGNYv1HIQRqotpQO3Fb7988X0K7Pbb+Ocgnju8y1sMPPD14+/UPRVdHFbIPEBT3v6G6VmnKLNJ6hsvqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/faBWtWsGwuWbhjX6PGGsqeJiUkrN14Pn9/lLRp9Zco=;
 b=Ujso6BdrwcTAzHKUDImCMoGv7SygdojVoyO167rbYAyVSFj8kDIXRiL2T5fgKiF6Yst2tqO+ARIYwP4A8feCiowInmcEfIANJROF1+gd9TM9DXUPmUuMCiGKePO3r3V7nxFyqZiBHQsJ5lMqbTxD34yLAcDUcssu+wgqSIv/bUtDtAp2nzuuH/jpya7w4/gyNO26e7jthypfaZDwlDM8edSBwMJrxD73fGkKu2rRzxxiTZ1j1CaMV12nQqbxpZpb/NljIZaPmW14+tkiU428NOCLLUuwmrtgu1t7HoWkK0+KLKp8yyr/Ema5MwIld5dH2mGRlxfvhtZ8bbvW4IWu8w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ2PR12MB8649.namprd12.prod.outlook.com (2603:10b6:a03:53c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.17; Tue, 24 Mar
 2026 13:38:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Tue, 24 Mar 2026
 13:38:07 +0000
From: Zi Yan <ziy@nvidia.com>
To: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, willy@infradead.org,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Tue, 24 Mar 2026 09:38:01 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <54398FC0-2F68-410C-B9C4-2802810C119B@nvidia.com>
In-Reply-To: <20260324114720.864478-2-shivankg@amd.com>
References: <20260324114720.864478-2-shivankg@amd.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0129.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ2PR12MB8649:EE_
X-MS-Office365-Filtering-Correlation-Id: a9e8b0ae-b97c-484b-463a-08de89aa951b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|22082099003|56012099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	ZNtbKz+WxEyC4Ho9kKpy+CQoNtvD/HHDBYIKpYTC4MK8AP9jabTEEtermeO5p/E3CxPZQ09eiZSbk2lQLKSpVfocUuH8G19r0wosjbs3PQUGEwVQCNkgP7iTFJc25mLTsWgRbHNdqcJfyobSjC/sSz0sudSFjvQnQLkSsTUGR2X8dN/d67bd9X7pPkXqMkqdwbaQsJ75U/vIjCRArqeABhjkzeDPysZGIE1IGEJ/a628WGT7HdUzRCQSVPBuo9Y9KOBJQguslc3TkQsan8gcK/Bzu4ccXwVHnaAhBQasCVFvGPN3E2VSdiJCnSRg+xjjPxWyHUtKfNczvCLQdH2z/oRvt5BGtvMxzucbFaMlfrR8lCdC6yTpzrczYiEo5Vx4aRlwPCFqVnhG58bgzhEM/e0oymvyOYObLMWUih60BgE02U3grXawH3SxowBt4WA5pPjnl79Tvr6Kv3KXaR01lfra5UeKCT+oYGqEFTqH14CFH1KkzCauR+knUsl//cZFOKvZgU16VCWVm5oL7jkoy1yr/9IWeWhPGjqANDo549DXh2iI4y2wv4PRzPV+ce65Iol87PsGP4PnY3rkT+4wJNlM4LwXVCBhz3FXB9cTHuJPF74zOAqghwj4hovt4tvO5xrFDLlHFU1QTSktHa4NDNh7zxgQzxrR7RUjG93Xq6Ukb9cmURXHs9nkAzN7STRGa6w+6tinKnt8NB/TXq/k+mSO52lV1w769SeLBxH4DWW9ySWXeEw5HvtzBR0dr19d
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(22082099003)(56012099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2wTc1d99/I7QRy1IJWqK2hMYhkbdwsXrS2uSgbEVz5GpikDwOf/r7JDfMHP2?=
 =?us-ascii?Q?wDbRaTfudwKSAJiF3Q5Axxpw58kfAL92QCIMHHd3plukXNcOr/a3ba12oQ4D?=
 =?us-ascii?Q?JI5lLL5XohrxqaXjzpvPgVgUinvBmMTlLecSIILvxKrdoO4u/faubF61QdDM?=
 =?us-ascii?Q?lpuqqqC9jiblZVx/8L5w+P5V262UNQ/Ag+WBVakMahGfMMBtDHQju23h8idn?=
 =?us-ascii?Q?PddFBdGYW/9hEzvixSFg342696a8t44INkPrJzn9Y/g2XLyc6cnfwPfdAHHx?=
 =?us-ascii?Q?45JlEyB0b5x1jYpNyvh/HjM+QeXovHgG8ZLUVi/qPlWsOFY85aWZUM5cIBL1?=
 =?us-ascii?Q?ppgdETrCegLgez1QhHRa8HL/OYooypt/D6f25vlELHTJTR3ePFXsK3VXxo8a?=
 =?us-ascii?Q?pFvGzco88TupV8GCDRvRFo31ALzCX01uZZotDq0SSNEPdTG3d5FK/NNz5svC?=
 =?us-ascii?Q?xCo11Tot1JnSOEVdO4CR3gqOjke/+oYYFYGudoBZdyrM0iG8cKeXxzfF2pBj?=
 =?us-ascii?Q?DksQkGfB/jRrIOM36Neu4FzE9f/02o9r+ZGB0mEtjKgdkm1wgwJlmgfCFm5t?=
 =?us-ascii?Q?iPo4OkoAmP9EBx3UOzmTVvtjQdSUxXHGq4Ka4e1mdGB8k7ND987S8j2RJGr+?=
 =?us-ascii?Q?bJPcdOjADyBjxElArz2tND+ZAdShLcNsQHqh9grrlN1ZmCqFp1fnA1ldBFkP?=
 =?us-ascii?Q?goMTOIJ/f83ezsfBrZYGES86M525EuwCc+WsyEkSKoZeKJ/5me0W49KD7GtL?=
 =?us-ascii?Q?XJtnb1L9mV7nF9GjtWoNIV12KsjyF3j2LaKFI/m2YEXzc+emd7P/3Ieg3lxf?=
 =?us-ascii?Q?3QYE8YeRx8AN/UnFg4Dv8ZJPtJ3Sg9vt7t6u3SnC2A6bGZI4rgWoSbDuRkym?=
 =?us-ascii?Q?SwOSQ9W5X/C93Z+5htMquGRyQSNgczoAmnArCB8zdZEtFZ8dkNLpghZGZaWx?=
 =?us-ascii?Q?rI6H/3C0HlMIVEdWcpi3vMEbbqnAvxieiCfWeVWt+8GcabWcQ1/hddkEBHrb?=
 =?us-ascii?Q?BrMhT5H2MGETz6eRZv8BTM86tthvgYtEcpMIIXQq2VNq0ySq4o9CpBhZRnM+?=
 =?us-ascii?Q?71EHaqz4Lar+asfV5HR7a7+tAs0qkanCaRBJrbKQIUzWeQYhfQ3gj2T/W1YU?=
 =?us-ascii?Q?BVgymq5iySrdVqpJsljod2rQSCb37Nd/lEIyY7s+WDpU3fCQHAjdgtPgrnvF?=
 =?us-ascii?Q?JiezeIeR2679UxAypnr54vsgh5mAsQI5AIqGlT2Uf/WEJ+1co+aYWTWfvApk?=
 =?us-ascii?Q?jZ7IAetPWELIBsfh5+w0OpqpZ07tbpIv4AzgHjeg72ANo3yE81RNR4bG8wls?=
 =?us-ascii?Q?w+C04PFB5Mitt4TQ5JvPfw8+iNdkdQkEyyjoMaRRWQYB4ck//x7w407WDXBZ?=
 =?us-ascii?Q?wXTeP4PzgBObO5UWn4/tPA+8SRn+ghxYEvAkcT7hrd6iDu/2QXQPwf8iDU4t?=
 =?us-ascii?Q?HB1d1PFPyzOi28LEtqKamw04ZlvKbqcD5pN8zGTZFjmHCMf+gEVJkSCPeOz0?=
 =?us-ascii?Q?1w2dAzdtflkI12AmSA0M8RXmNkNKs/0OyXL9DptyUhSqvHRuPfC5Ck05N9/A?=
 =?us-ascii?Q?fsSGETk0u/Sl5GMLFuchXxw0BD3J0euB3RlhSy745q3VwQJ9yAezjAyFrDlj?=
 =?us-ascii?Q?kTdFrR9/7/f3u6GHt1A3T4iWAtb1RFJg4V6FP/ZHIJjtusfuWY/shUkB2bhg?=
 =?us-ascii?Q?FYqOKWvc10pXFHhXFFgBsn6JDTIb28wzz6YaG4r2BC94Hh1Pbg3Mjd2I8SQP?=
 =?us-ascii?Q?0jkoWwGjVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e8b0ae-b97c-484b-463a-08de89aa951b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2026 13:38:07.3382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HrYeAUVFmxHJ9u3qlL8crFMTJRUVL8l8tpBUm77JF0vaxg98LIMCkToh0gsTvjMM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8649
X-Stat-Signature: sr4gqs34h7fxq18c1xsrrghj1ubheoy9
X-Rspamd-Queue-Id: EA3AF40002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774359492-395277
X-HE-Meta: U2FsdGVkX1+JTj+rCGeHhUjn2W82ugQol9VS0ow3PDYoxzU/CnCwhFHxZMdTGeyRpeNWEBT1p+OsmG0f8L1hKTFLuP0FpZgDdf+wbMLsv/3Re+5E1fQbOchzRuMu6W6LA36PAaQCNeOIKPkft5Mvpdp8qJtLlq6wW4yYb4juqRY7SQMtgwp05iRI6bJdvw0Qa/SfWSq7Bg+qvaGcrcKe4okbHOoHrlyrHVom58YyaEFT4IgmZuAj/Cuie+87DM24Oe3jX7ZZgrej5V0e0h/htgYJi1ZjfS5vfkocPeAOBcuTmtPU9LvtnzYLxDU8yLdQUqTkTETiNTVCPT4GI1/QuYXzHgb1VnjNVKuoLP7MNBfBtF8q1aTWna9TjBRw+o+K3owspQ8rLQI6aH6LtTJVtrk1hj0LMrh+0t7zSIxwTVDT+pL3lzyBpUFlDP7QV9zrzDdSaC0uDxP9vIP6TDtmyMAst4d3/8cAXNTESsU0t8vAqlLtPkUBWmkFGeFI0NKzB5RrNG6V+eVpSjJz8r+A2oPWjlhxZ16Jw1er+5LLS+PpYxzuMr0e9n63DZRmCZlogvGIqKzBmXI9+di8smZE/hSvZZBOcZe7XVdIVnc7bdovsc6s+GkIz4rGQm6B25rkyDMiTn5fWzOpJp/991DX9lR2OIu/w7xK87RhvQi8Fn/K8e67W6Xyfh0Eo0lhu0PhgpNrPhCpMiT6/MgjkfD1uhldtNHw7XyuwDyZC/sFyxE3DzBnlCab7Le5dOkWuluzXDJrA/xsYocDhIxEPzkXeopdX+i/IHRCEtcgQTwFrIoC/2/xEBVvl8pFC9psROah9BaN8voe/g72SbwmKq6p0QOh/7VAmXtYlu3z7lOpw3wNSvjaAeqsfK2gGuPNqKzB4O0HP9gvfwk79HbMotNVh57DdpqZQAK9G3DYh47U+Fr2TCpe5PWMyXPirN5hZm4/L8lpnp+gULVPhmUAPqt
 6i3gnhsD
 tyRAgGrYPtfAyNhC5lqY2D7kq7bjLRr02DKBOi75shrWdQFxa6oPWtduFcVesxCkuoavNvTxiViYerUptXaUV8yfoS1ZiZJF0JyjyxtV2PhpVcSZui04Lf9Vf1d46q6BeWEGZQOhHVCGCO0lCVQQVOb2/wS2ZnwsIMG5TSqzDeLY81nJ1CQsXLmPce8r23x/CGwYRrtmYbgwqa2ILxl5qfaB9n7UPrxpYH5j+lrdVKLuLEDFnO2BJYdUVtDyyoOZiSFwx8qVG+WBXt+M7iPA5Rmc87t/PMmrgpto/VfFMUTGYaIZfY1caKL6/6qQBuOwvCtXG6dDnatlmCH1s1S6Ez2o/eFBvSWm7dZAkxww/6SHvs15O4Y+OPYlvkre26QObVkbudCLt+cXcv8ep8kP06KgAq5JJEzV6uV0yKHZFHTvj6Ft31YuOI3caxRTuLeNTS+Nt52B8sWddpE2XWMhxL0yIJaZg8LCyfwNcn3izpX9e9JysLCBthnGYCTAnoz/1LBvL/4EtQmVxUB5A8fdbMmxdxqWEienh2aHItSnIc7Gn+WE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Mar 2026, at 7:47, Shivank Garg wrote:

> These flags only track folio-specific state during migration and are
> not used for movable_ops pages. Rename the enum values and the
> old_page_state variable to match.
>
> No functional change.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>
> Applies cleanly on mm-new (02b045682c74).
>
> v1: https://lore.kernel.org/all/20260323141935.389232-3-shivankg@amd.co=
m
>
> v2:
> - Rename FOLIO_MF_* to FOLIO_*, per feedback from Willy.
>
>  mm/migrate.c | 46 +++++++++++++++++++++++-----------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 05cb408846f2..7dd6c2f2e1ef 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1135,26 +1135,26 @@ static int move_to_new_folio(struct folio *dst,=
 struct folio *src,
>   * This is safe because nobody is using it except us.
>   */
>  enum {
> -	PAGE_WAS_MAPPED =3D BIT(0),
> -	PAGE_WAS_MLOCKED =3D BIT(1),
> -	PAGE_OLD_STATES =3D PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
> +	FOLIO_WAS_MAPPED =3D BIT(0),
> +	FOLIO_WAS_MLOCKED =3D BIT(1),
> +	FOLIO_OLD_STATES =3D FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
>  };
>
>  static void __migrate_folio_record(struct folio *dst,
> -				   int old_page_state,
> +				   int old_folio_state,
>  				   struct anon_vma *anon_vma)
>  {
> -	dst->private =3D (void *)anon_vma + old_page_state;
> +	dst->private =3D (void *)anon_vma + old_folio_state;
>  }
>
>  static void __migrate_folio_extract(struct folio *dst,
> -				   int *old_page_state,
> +				   int *old_folio_state,
>  				   struct anon_vma **anon_vmap)
>  {
>  	unsigned long private =3D (unsigned long)dst->private;
>
> -	*anon_vmap =3D (struct anon_vma *)(private & ~PAGE_OLD_STATES);
> -	*old_page_state =3D private & PAGE_OLD_STATES;
> +	*anon_vmap =3D (struct anon_vma *)(private & ~FOLIO_OLD_STATES);
> +	*old_folio_state =3D private & FOLIO_OLD_STATES;
>  	dst->private =3D NULL;
>  }

Just an observation on folio->private, it is void*, but page->private
is unsigned long. It confused me a bit. There are folio_get_private()
and folio_change_private(), I wonder if we want to use them here
instead of direct ->private accesses. Feel free to ignore this,
since it is irrelevant to this patch.

LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>


Best Regards,
Yan, Zi

