Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF789FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 14:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2554A6B0088; Sat, 25 Apr 2026 10:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2059E6B008A; Sat, 25 Apr 2026 10:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDE56B008C; Sat, 25 Apr 2026 10:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E90646B0088
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 10:17:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 645671A01B4
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:17:14 +0000 (UTC)
X-FDA: 84697280388.26.D8D01FF
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011006.outbound.protection.outlook.com [52.101.52.6])
	by imf16.hostedemail.com (Postfix) with ESMTP id 908CB18000F
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 14:17:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="L85Jo+F/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777126631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hkSrY1/k+MTpBbqK8/VdTaTRt1uFgKieojhBHVIwk6w=;
	b=Uu2r7uQJQ5YKcIuwPK1eHt3auezMld2nWBBCC3QQUm+8zreC+pirfCncfuFlO+5Ka6uRMV
	A14Nfv0PIJv7JlBkmpshyc0/mvs2PMeN6kmI7rVgGKoL25ie06/Pmf11inYnJINKPf3noF
	5k23RyNRNFuNRnCGXRoi4O+0tb5g9es=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777126631; a=rsa-sha256;
	cv=pass;
	b=vFN1YRadqYjXP2t9W1z9cfvVKRJ4Tqc89ZS5UNgsDiVdkAep0fmlyYuZVzNeQ42ApyTEde
	l2yolJqz5qW9warO5pPHRhd6egp3m7zi4tBPNxRqEgoa7Nz3hOKlOrOs1LPU4FU1fxqeQX
	kcfCfr9vaGITkJCuFBkG3+HXrwlb5Us=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="L85Jo+F/";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf16.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.6 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fgmf3XDT4ynIhB40VfyAxG9knogrJRl5TaL9k9yCjiGPZUp/7ZwWmB82XOp9OE/qSf14h83gBgytVYdMEiRTpq9FRsAsu7BXTVCnKe3MZF6LONDKHxJtZoqzblG0VuhIdtiLdp4ci8mbVw/TqM6QHzdig5E45vk/GIXZJmUQBqZD09bbFabBtE0oQFjbNBvYPM9ylGd87u5Jka45ecHVcJvFrvuO1+iKKA/COG+112x0153vI9lBY6hU4gIwlpZrqgXBpB6KBVcGebjeZhl43WpMjznxjL7oXmVzJyh4m4ZSOkQ9hsnczjJaRKrKjBqm7DgZWXkqcxAltemoAFsLgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hkSrY1/k+MTpBbqK8/VdTaTRt1uFgKieojhBHVIwk6w=;
 b=E0eEswxxY3phDFix6yq35cvzvHKfq03S5WCj3qa/rz/CiHPtSxTqsPTQ0S1Xkfnt6rdKVxUmi003aJp35iiTHHh1ktvS3MjugAnn4dMCpC0E2iVq8ze2CZpDxH3xLLP6yYSFOTAB93+ssuLW7HmG5hOnc0M0VhtuA3YF7UqoVexNtnrdw/IgDi8NYZq9JdiV6og0VlbjAyp2jPWKhyxzXCcj9xZWXhdgsakMdWsNOMd6mz0IxqLJPuIHKDbeTlbPjQqEZqWuHAcrQmuOsptrC68u2mk8KGyENyWCElNl4F71mDAwxS5ML52tw5TSKdpOyAdhoLlgfW9mMG1iQ7vTMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hkSrY1/k+MTpBbqK8/VdTaTRt1uFgKieojhBHVIwk6w=;
 b=L85Jo+F/IYGHJNSy/2ruq4YB+fnDI4J4e0gtD2GtTW/uDECFndi9vxjFzSQPHBMTmaG1UxQT20sgfXH+G23QYszqhFvFpzbcKg8hIS81WZ4hKVTmz5lXxBH/WXBvQETMzqXbNhN2S8zypHCSwMMpJXW5QNW0fwdhX7h/bJRhNEhzEyJMG4bcLoURlcHAF7ewh57/SrqpZy3AkYscGgPs8imz+2H5KL8pmdUWpZihvWRWT81rVkUDfqzBkWonJV1kyaiv7P3CNF1cwI7v9NMAov9quiB02dm0CbHdSCx52KoL0hVeOQLJ08jb8AV29uloLUji9kKeoBA8P0TBvTeFIg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB7035.namprd12.prod.outlook.com (2603:10b6:a03:47c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.12; Sat, 25 Apr
 2026 14:17:03 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Sat, 25 Apr 2026
 14:17:03 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sunny Patel <nueralspacetech@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/migrate_device: fix pgtable leak in
 migrate_vma_insert_huge_pmd_page
Date: Sat, 25 Apr 2026 10:17:01 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <2BBC72DF-CD17-49CB-A72A-5D534D4CD997@nvidia.com>
In-Reply-To: <20260425134453.23769-1-nueralspacetech@gmail.com>
References: <20260425134453.23769-1-nueralspacetech@gmail.com>
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0158.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:e::31) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB7035:EE_
X-MS-Office365-Filtering-Correlation-Id: 375ec4d7-0bcb-4169-2351-08dea2d552d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	v0SKqn2RiHcKpimkpxUt2mmnF2IPC852n8sSWwvxBDwWgmJN3pxDSosv+mS5yANOaBuIRJRNcY27zRuXGVXCkUQY3SBzCCDYXlu6zdE02D1hT8W9DnzU37W9Eh7hFLaS5hTGddY44klWx0j+kT1GZTEJ+5ydRz/+t2DkmAhaiYeUKSqEMmanM+xoV/p9y4ARFckhsr1UBxrf5kXdcXOO+/Iw62bPgs0Nmy6znr3JPjGLrB2+gpw/GXZAwi5KNq7pxectme9ciB4RWnNSXQRWC+wf11UIk9tXYNi1mgFkCjEQSu4sYP/mNyMY5kq+mch8tNLIMKLj/e4MPsVi3Zr/nYuxyEXaAaioVz0fBHI/D/vjr0P0ruSQXicgVsJx8S7HFluJDaRsMkDB8aU5TAUXqSJw5sfHDnge35N1cIvmSepN7mTuuP2QiqKEf+QZWuTvEo6OPrcY9bE+VzLvQATFW5DGITHleIP/pt6EAWaqCYzW74fNZ+f577lZi/3UoOP3ILOX7Wfi9a38Xy/hloHFX95LRkLlc0qUpJLK82pr6nYPP6clPInlFtvcKOlprZds2YaTfdnPq5M736+XObHwRv20XwDokyVzT2f8a+yNk61sNrEuVdA3n6QeY/PpWDcyyKN9CD+HshrFB9JuT+r8CWY6MpZr2NCGtLk6Nq7aO8SHVF7JfT/+jaGl+3kUM+ITMpgNVqE9cavkGdl+P5A4xBLaHF+z4uGiUCPsLpj2dgE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RUVVZzpyrE3PTldwfkNJWNQqYXwfkrnPc1iXd//8eiI/7jjmaMObg33ZaxRX?=
 =?us-ascii?Q?jeYlUBH1sYafYaUdv0ZdUUrXuQztnsFcy1EijHH1MiiklHt0uWoEVYb/YupX?=
 =?us-ascii?Q?rnsRUq5riCW7R3KVDfXXkrV9cjWW03TP8bqmmq3VVL9iHeBM3lIUcM3xHyA4?=
 =?us-ascii?Q?1WQynS+0RWqb3X9lIeBfyCw6Y6vro3oCb1QWAmyVKOammf18bK3n2l8OzIvJ?=
 =?us-ascii?Q?qLbyfRpDhGVJfYBFwRQDOoz8PNCGxP06jq4a2e2RCYfIakXYmfb0mnCBBhq+?=
 =?us-ascii?Q?lWvp04964Q4b0nyU5gv3C8POvYFeZykpaG1OVqU2BijWe++/586Y7ai6tMtm?=
 =?us-ascii?Q?6MJobFUOowxBJqkLASRnoX5fbZ34NIIX2cNjsplOUsxQykXXBgEn6Gzw6bWa?=
 =?us-ascii?Q?Xgp5RZHIOK0IZNyt+GbdQW9DV0MKgg043wALTRQvGAQbWWt9Qlva9Da5ZCwt?=
 =?us-ascii?Q?AkT9ryYVE9/k30D2KAInmHq0WZxmOL/L5f9DkHYrt3loWSWoD4jD1h1w4p2x?=
 =?us-ascii?Q?ufaFD0SAVkcgtdaWrQYX8LFvhg7MibNi8Re9/GnNZwHvVUssr4atLbacgreH?=
 =?us-ascii?Q?Fft252mwf9z/o094i55c/QosA1codXxXPcc2kFK7pavhgLOZuJL7EP8cUSTo?=
 =?us-ascii?Q?Ty3TsBQo0gohOKIT4oBNwEqF7bhw4sy18EhPZsbw6WfCAbXLtSn3LyWMkCzy?=
 =?us-ascii?Q?PVEcWp0eSRKI4EZLOIzegoKBVA8EbsBW7hGD/qjvqJgMC94IhJU1BudB2Iw/?=
 =?us-ascii?Q?2vyxkO9wUICr9uTaNwF4e7gWi11NV/+/9YSNL8MDKzKzZ1HoULwkpiSwnM3C?=
 =?us-ascii?Q?CbeJtDZ0h2ABzVjWj9ButFAVC2rd4Nmxsga8OQ7nBp14+yWohXA8e5Kjqeys?=
 =?us-ascii?Q?H/CerRRqBq13ZEu3lSF8jDnZ9jMFCvxmy3ACOh2xQNKgic9fbmtE4J1aYUVs?=
 =?us-ascii?Q?KBUI1MCMI93jgxJHna96FIbH+0Twi1O1BDTCCnzSLJq18AMy+u9yyx15YzQF?=
 =?us-ascii?Q?R7i5UoD5eHfYqtNXmIWNJlR8XmMfPSVSyhc5XZwNlmKYlqHOQQdyypz06Wuz?=
 =?us-ascii?Q?CXgXBCQ/odad04fOUiu8MO4a4OAgOy1gbFfurxXDZJ/nHjT7j0slbUyo6eUk?=
 =?us-ascii?Q?hJmM/7MyBjPygLikqCslaTcY+tbG8RiDlQrqgpyyjpuIeVuIYWvCSD4cn/kd?=
 =?us-ascii?Q?bGKLH4PF6PQilS/nsWs0OBoO94HrpR/kQZ411MXJbuo4yx6FV15LqI8r53XX?=
 =?us-ascii?Q?+BThbDM36lQBCrFOsMGXFgI6LqlRQXybTq8Ii88qF3EbPOKD0tQUWyjmJAQc?=
 =?us-ascii?Q?Vd8z/RQqjSvGy4/ZVQBzy0wF2yV4k7BfxDQDBtTUvPfaSJKLggCEKt+xe6K3?=
 =?us-ascii?Q?J4ZkBEvxz07Cx8vvcRagMEwUa/llO3PAug5KUU63JZp4TDoAUIHY2SgDFmcB?=
 =?us-ascii?Q?C1VUSHvB3zcngCPyfoBNBqumVqzEs4TV7ERShqVNKwStvLJr/+/rCvU+HBCH?=
 =?us-ascii?Q?KEM6OHGL4wgTf+ZHl1p71XhU8JZ+W4sX6KOSz1g+Ksyy2utV7O+hq4heDtGr?=
 =?us-ascii?Q?lku0VJ2vBxyct1to8+OID7+CoNmoDYUWxIHaAVs72HRISjw950lQsYBQ16f0?=
 =?us-ascii?Q?p1ym46Z1SHlmgm/OZizyJxWyuCSOh5sPnjQiEHeSwBWqvuQ99lXi6/v9YaoM?=
 =?us-ascii?Q?CyW9CVFzZSL3V0eVXwRfocbtwk0i8p+6lXl8pUoCCGFLftTx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 375ec4d7-0bcb-4169-2351-08dea2d552d8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2026 14:17:03.6036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpwhkoK/0Myf1Dq2LUGSmSoK+wE16x8bkUxjrTDwyQLeVFGKftcxz/YVAbWoL38r
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7035
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 908CB18000F
X-Stat-Signature: mzses6owh3qdycpgcfybgt8rruuq5xye
X-Rspam-User: 
X-HE-Tag: 1777126631-541751
X-HE-Meta: U2FsdGVkX1/EkhmmAxd3dW11hhJZ3brWGOyE1TRecln8FUYXIHsMyI0TR42uTC7J9nUD60JJfIswGlpLvqhghdvN0DPNqQXEh52NGGRh+J3eiH1AAe64BfFQa9nQCfF5Hr7zAl2RoALqAGsTazqu1cmlIt4aJlDNMuR9DZjYa7Tw/ccXsXnGC7OPMhegPwlccgj3j9dZD/2Qthv9fMvnYdsVogmlVzRBS9Agzx2feavSdFsBixyuMTdx9BvYn6rtip4fFL+BgaJyTukAA281FZRGaZ1VVsGqcnzV7VqG8ChGnCl5+AdzmbcfDGdoaJbVogtdf9y9EMQx6olhIju9COXh5r6CU/5FEFbSgIJPcFzK3iODgnSb6uwXTuvCcRudcNrKZD4ufIe3NC0EB3w5Rigvic3QKzCauUJVPBM3shdBdfY5HmCw0EHTbSXi1lfqHX8etsO2WDwfamrjQ/I0F3dBl+LEuT4vEgC8XjvmXNnrvotoh5YkZaVyHvUvmDiTQXwEJK8rBCy7LWbxVXciAopG5p+U+WUbPPPz65+1zT/iGvNNk4C8VF/H7azcGpcXP0PnA6r2rn+TqYY7gPF2k6b3rtiQKYVjVOSeGq3KBDwAJm62qHpjyrwXHtDBOMCQxF+Ymtl0PUzQNrpAqFKVhMYVB58bJBy92SVshiVRUeOM4UIwIN1mziq/e8+IBN+bm7J7boItuYOLGWnAns0QFxLoLJBZaztwD3u3x3CNeKB5oEhPIYuP/uPM+wnxotTl2L6u+814semWvICCSpu3AVNuEQrPCohAQ0URFOu7F8sYWOrVuG1HYm9qfezYweLtW5/nE9bILK3ZsJ9o1wFBM1kX1rEg03st6nkiR2ChXvB8B9QJwi4QiRdJAmKnzBX0zzlnKDkAnru6/po4+97zf6RSRIWejWjrvh3e0FFFjdocDfgs2ZfeWt1MTEvFzLeQ227VnkYlR0YmstGCbIS
 cpcNFC/V
 xRmFpA67l8KLCefmAoGIyKTPKbsdT0hyZ9M0T2RxdUKqON+YzbwYgiAqPkCgKWmA6AiVzPhqqYKOMkWx8dlt/q6wwrQKXPc4znzsXlCweDVRsJBPnV6ZgWB8AxHlGiIFjl5nxuZCM4kKr1mXj7FhP/fH3xwmQiAfD0T+5XX8uTorcAv4yHi/pvHy/wo4iR2ojZs0LWyEpipfObRP316JBTyOnxKmpH9tWZl/Rpt3bvclRZcbFLaluFelb4JRBhsroawJnWNebxAdaWcjSjgqgD53aNm9mJB1qBnl8CkKE9G0l4kuvdE9LMjdStApYb3TKlUuSgwteThlNp/XeSPVqg1/HXAjP3TfpNLwpMVP6JqThyfwAKY2VAPHa3WfS0hC73+964OMTbmct2ZNJA8cuS/30/fAXYAjBc/N+7/Dow22Nw/uAkG4BkHiyMw7hwY5IdZOdKZjUOZkXw/R9MfX0fSTQqJHA92Dt75kMuAB8lMNQbGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25 Apr 2026, at 9:44, Sunny Patel wrote:

> When migrate_vma_insert_huge_pmd_page() jumps to unlock_abort due
> to a PMD check failure, the pgtable allocated earlier via
> pte_alloc_one() is never freed, causing a memory leak.
>
> Add a pte_free() call in the unlock_abort error path to release
> the pgtable before returning.
>
> Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
> ---
>  mm/migrate_device.c | 1 +
>  1 file changed, 1 insertion(+)
>
LGTM.

Acked-by: Zi Yan <ziy@nvidia.com>

--
Best Regards,
Yan, Zi

