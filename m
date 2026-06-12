Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7289CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 02:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1110F6B0005; Thu, 11 Jun 2026 22:46:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C22E6B0088; Thu, 11 Jun 2026 22:46:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC406B008C; Thu, 11 Jun 2026 22:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DA06C6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 22:46:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7582A40743
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:46:54 +0000 (UTC)
X-FDA: 84869723148.11.A6B4A66
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012029.outbound.protection.outlook.com [52.101.53.29])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7E2F5A0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 02:46:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d+TXNtHe;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781232411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4ticpnGMsgGnXgQUn3AHzIzvOsJ1XnmJb2XzggxUMQ=;
	b=DEAT8CVA4ipr94WFUBAAvUXLWDRZsStQMSbb8RxuCmJzhryfow0SZbpjpLf/yet6udH1kI
	YUqt9o6lS6+G+alWrlv9eMkN4NcpGaxVa/gpETezxhVTZSsO6Dq/BrHoHR89M5bTimmUvJ
	ZYOeCqQbmpzmT/kcXZ/If1zcrrBDi4k=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781232411;
	b=uhMrXbZZSjv03oV4VvgNwIs6HuMyYshZ0h1lX2/ot4gdoQTe3KkdxpRJFxc9DitIT9Xzvp
	Bt+Xt0/TYe/WvrvFoVMPCYjSLJxCLXsZ3bAvJ+U+GDz2t8lTnG86/BETDFjgkRT+/BkVSe
	NV2EmDcqITrUtUuvqW3qryXboUbQ36o=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=d+TXNtHe;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IocuElNyMfmf/SrzveMtQBiHmm8GF/mn9CbyY9HdA4A8gQW1AoL1BmXK0YHyvebrakR7V+2MOSwpaZCNfxYxN8sjdDtw/hTmKVcj2fRCBBwUiIeNucQAY6qod1Ugz+4PVKFb57zksi8Vac6N4LkTGm8n9InyuaZwJuwqUd77TF6pbXknMNWuiRFgbaQjF4djqkMSLYyysiUz7fXD77vVCCOaP9hsCJ3zn/xD0uSphJeLPqyDyShPF51MX/G+zn25L0c5Fz5UnTcZZqZVtByWiicpVxsyvtxWEXRs/ZDImfOw616hcKCR4dzZ6mw9NUAf9Jbee6pC9ViOtdZA8UbysQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N4ticpnGMsgGnXgQUn3AHzIzvOsJ1XnmJb2XzggxUMQ=;
 b=hYsVR3FE1zc3R/YvzH97ax0+XJdeFHClNJx9wYOK1PAc+pSDVACJ8ytXPnM+rvRKG9+XAlqwzQTI+NxRvK3x3Lq5jg8QRlR9QtvOtSiXvTyVEVfDjBQCLyTZo30fZCIc0+oGEcztyMpCmeB4MjJU0fezSXOgc1L1Vw2Pnzeb3vNZ2RDklwebBR6sXHBmIa6aS5y72zLxGcunSPfyQ1QHU2Kyd985eLLm+ozgCKLTT+desg5/OxSZ7YvKPSc+vXnECNcld2x5QbNEjOxjo/VsODWnV4FIjDiwykNTGlzpITLfEROhRWHH2Vq8wtKhi9sh34CiyCgI7INsRzaWbDJOcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N4ticpnGMsgGnXgQUn3AHzIzvOsJ1XnmJb2XzggxUMQ=;
 b=d+TXNtHe24tYub6EN4Gz72O7ukUXch3AGLkuoQcoCrli5Aq8BytXkeDg9FhxA9QyKA6WUrlj0nMqVG9rIvACxcwx21XhlwXVlxHUY2x8ftgoJlsiiIJEsrBrBjbIMbA8qFuTwrB8B6sGhS6SSYJeNrCLY+T7Rfnmq1vUS7aHfBbCrhzk5Hv17z4IYbAu6aOxzedY3C4hJY2nKhUCQZaMfj3qJ9LtCITrytQB3eQgc8kY77AcAFHZUBMJHp5ghHVuDcQPyJF5vb+0ZMWeJ8S4rWwybp13vnzn4xhlmkvpEb+iUxsVSwIdR3qnG84ThYOQej7uFNAwT9lZ2tUqva4c9w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA5PPFB9BA66B77.namprd12.prod.outlook.com (2603:10b6:80f:fc04::8df) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.18; Fri, 12 Jun
 2026 02:46:44 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0113.013; Fri, 12 Jun 2026
 02:46:44 +0000
From: Zi Yan <ziy@nvidia.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Lance Yang <lance.yang@linux.dev>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Chao Yu <chao@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com,
 xiuhong.wang@unisoc.com
Subject: Re: [PATCHv2] mm/huge_memory: do not add dropped split tail folios to
 LRU
Date: Thu, 11 Jun 2026 22:46:41 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <953254E6-4518-4CE1-8A41-93EFB9364413@nvidia.com>
In-Reply-To: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
References: <20260612023456.2424044-1-zhaoyang.huang@unisoc.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: YQBPR0101CA0168.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:f::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA5PPFB9BA66B77:EE_
X-MS-Office365-Filtering-Correlation-Id: 6879892e-cde3-48b9-9f3f-08dec82cd6d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|18002099003|22082099003|11063799006|5023799004|6133799003|56012099006;
X-Microsoft-Antispam-Message-Info:
	d10qIFHlt4rCNiCqXmoqhBDi0APBOGCQy8EesAmveBu5CudagW798G5zJRHgxmTHTnZ/QdrwFOf8ZOQzEHq6ad9Q9y3U8Qkcg6QdfARRx/JGcPM+1B95rAx8505+vWiNFf08shBOueGQ0PtR4d+aXlGClKiZyDRZrJWrd0xDZZWuCeOMrxdACZbjsp9h7skKlx5ox8hsxwt9yFBA27Hlf16ryMKTHW2qxlxRRenDB/P1K8Hk/MR7FtQQg3puQxU3B2lqbdKndwdyQS95QDKhgWlVpF0XNbjUhzg9QhNx5/insXaMoUM6j5Dx3EZ0OZbBdsBQCRA0U5wc6aoeB8Jh8sm+7ogI94mIpECM2xwBsl8AW5BZ8dGqA+hVRhxHO04t7y0tMRnP2qeTeNYO7hhf9NsMJa0/cRoGfrP2KKwheb6yZ3LS8zJafmVuuhpR6QTxh44CjWcYntE+9Odowr94UXnJ2qaBA8lheqGM5XDa6fTzn8z/2ZFacM8JCyXWna94UQno0zAALrJqQMgnpH1XjGbu90th+cVRIVHIaSmeJfyMXtFt7oFGhEkNjESz8L22h+rMSE7hBl/8g1F0hDSYWJpHQGVgaKzDIAa2XVNGh6KjIu7GcGsy/56Z4aCqNn9IlgRrpMGoWl+rl5/TxBKTnK7Y9/RKth5OziL/ef6KJhZbc2fqz7dG8I/O4922iSmr
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(18002099003)(22082099003)(11063799006)(5023799004)(6133799003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?muFWy/si6E0JEAshlBdUo7pM8oFD2v9zoCMIUpnSlZJ8ebfMFkMP4EuKMK0N?=
 =?us-ascii?Q?4yZRUabQCK3HPv+rsR+QxoKMpSqHaYQGhk+05IC6YqXtth/inQmlKG8AnfFo?=
 =?us-ascii?Q?RvVlg1MFxRME9bf2tQSp/yNzLdsLktspFfyYm/ycWGzxhrbKercgTGUaLXmv?=
 =?us-ascii?Q?Ps4zpGIbDKwPzEvCwj7nAkfl4xdX5QFgqqEBpW02ClIVq5lsYbqFb8CCxS2j?=
 =?us-ascii?Q?/gkPKg35vI1pM0lI0L+Vraxd5TYpZ4FneOyhyOFX7U58RGuQl2PiG53LTccr?=
 =?us-ascii?Q?5quVrYHLTMS6/6+78SoJ/qb0+qR4eUOnF+uSmcQBO5pguvDEUbUtshRSKrs7?=
 =?us-ascii?Q?lz+T+Md/Nv30D8ZvMCjeP+hrHNRdcZup4xbi24c9bsDmORMa0LH4xJz3ubrG?=
 =?us-ascii?Q?SCNNvYeTT+SzqumNTU5wFSvtaeJqGGqH95mJLYJ4wrvfCf8f3Jomo+GklnXA?=
 =?us-ascii?Q?I1sZb6IStioIzM4M5BC+hlvbMFmIznh3qAUPwkYv0F15pfUjg+3lDncfYznE?=
 =?us-ascii?Q?fVnuVs+QrIouxighp3ZvA2N4Ibno+KaK6MocaAxJfPEjVXpptY2bXNFtx9NM?=
 =?us-ascii?Q?8nH99a3PzwCyOzvd1p912IPOyf5WyXd8/gLXqxT64WFIuUpagvPEY1M/11bw?=
 =?us-ascii?Q?O6dOuEbDhRyvCn5hKFJbkW/Sb/H03pDI6B4tRee1YIgSx/SdkxtODCamC43A?=
 =?us-ascii?Q?ebZy/4pBYxBSrCXWiHKS58aUfV5OgFjXR17l5xQTydS3tElTZerU/rmz3SH3?=
 =?us-ascii?Q?d8dIQXPucbuIBDU/wfXHHJawPF+B+hOtisPKbnlSY5criOvT0GyhMWUZwGMB?=
 =?us-ascii?Q?pF20Rn6XOnlqqT1SssSntyI4agU9heaM1+vS6VEEDapkIAuq+9g6G5FZhfKf?=
 =?us-ascii?Q?73dPWwzk/0UnTzDQ9bT2Jy7jtVxnhQN5LRClSAz3HsYe5NiVQWCHWCib7Fkz?=
 =?us-ascii?Q?QQ1MkmeUa2yayV4RpJ/tc07vPEJccJqFTSTIvZ9hTR3BjD39OQNn8SfaMjzw?=
 =?us-ascii?Q?5F5EUOtKob1mTvekosE5gNEGlCAyzxT7aKSygwzfEJN85812iYHLn7Givp0R?=
 =?us-ascii?Q?vi5dmMSDXlB6BEM3DLIn0dgGDrMewtSULp20wRXGcdQaYkpRWhmYl9a3AOKR?=
 =?us-ascii?Q?qclIj2NBL+uCmEbem0t1Gmjd1pXcr8Q5VCSft0VoiLUMaz2ucP12yujPN2oD?=
 =?us-ascii?Q?OIrGYI0h31WRllV7v/TxpBgQEmg839nJmnv6rY0kj23I1VCEsKKz+wysfMZj?=
 =?us-ascii?Q?F6AmvawP5jCgisYYQinyoXbUB1acMMpS5iRSx3xCdNHJH0tv9l+ef9FAEPFC?=
 =?us-ascii?Q?2gbeMKCxeZp20smkQj5+FSvLqLbFdW/4kSbeTROPNGESz6Klj1oOZUrctP4K?=
 =?us-ascii?Q?dGl27r37Zk2BlOBf7rZ+WP2C/3btEWlrW05sNqYACC5a+10lW3sHGRlSXhSP?=
 =?us-ascii?Q?TPCad/gqAFR82zKxKHMDnC8e5HRQj1vSVyeyzQzzDqTJdDTbmzZpS9fnlZPM?=
 =?us-ascii?Q?x8zh8kfNjrvdR++A++Ek1hKxXaQ0LpRppZuZS+YDuur7FhcHy+f+sZMyQA4i?=
 =?us-ascii?Q?9Syx8tBKR4VevJ223B7IZsjCGCK+GQVPCPnBjXC7lsPkgy6PFNIWDeFPilUH?=
 =?us-ascii?Q?olLx3f/5XICiIsQQ3K+bQNfjFCO+z3Rsj0DIhtsLXGF2IyKNzBkrL4b/2brb?=
 =?us-ascii?Q?4u8LEMy6+Ght1ooFYbj1sKZP3Z28EtBVo3S+nVykCQ+tMRac?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6879892e-cde3-48b9-9f3f-08dec82cd6d7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2026 02:46:44.3110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P3pgUOHYRM7Ip0cPT/gAmxNDOI3BTW1u3i+PPIG907tUXj7HvKPB1fjsWc2cCU1Z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA5PPFB9BA66B77
X-Rspamd-Queue-Id: 7E2F5A0005
X-Rspam-User: 
X-Stat-Signature: 75b3r19qkdf99mx3w4gr5gm6c9t6gsse
X-Rspamd-Server: rspam08
X-HE-Tag: 1781232411-129365
X-HE-Meta: U2FsdGVkX18DZ/dCG+Muz7bXRZ/DMolMOEKoL50pZBKBkypcPB2E3DhDketVpYKXm3cu3/VE4WX70dIEnwkUpYi3kdrV5jD57gGw+FAeLldy2NlncNSJj29AG0vBsU7m5fUilO0txrN6jzVOXd0wnn2QCeAg64R5pVaeVbS+9VhCFB0C14sbw4+F36uxZq1ICw9NHOyJhVi1B1VunNBxpETggLifX/QrjbnJVpTw5fbXclDllBVKhKw444HApTbS5bzJ1lUBSIRGu4xAB5n0wyz0MIOL3pJgcOU4c/Q1PZvTMqkoGVAxCetFkGbxrqyc2UlmPw46macee8qdeOk/fDuiHWQ8tpOYQASCwyAU2aSAWTpdIj9eor6IJmH40eraUhl3YU52h0Zn487l4MoAugR2hkY86HK5u/UAgCkAyLwlrYu/pBo8pNEIeRI75y4J1laHM9YNR/xUATfSFGJVJUcYg6zBCIHT++QaAoBCpnRot+kwjL5t3gcCC4aEX9ol0+tN6xf2P5OFzJDckqk3meAsI+Ry51Wbmv4ZiEYGW231TeopiW4LZXllqKNjvZEgOvH2rUwcPyRojZBcBM5LkqR3CuzXpOjXsBJlnqk9J8dPhr3RQfWzngTDFRBsjJqpQuWEFrh610VUuTEDf4V1YiigqIJhT6MDIDkT0clwwFxWyoRVBVNyY4nepMyYj6r1kIkxLUIwahuYeAbQDdIhVfVBxAWi0E9AXtQ+6jv9b96gQMrKGnggIVhnNrRFm41niQB8wEPQbIgQs+HYrxs2raJIFLAKLNgmYJq/AgH8xYoEzV93ZeMchk86l0J46550OgFp+TqOXvRGcrHJ0n1v3vasTlgK19gKgaSsdjoOGGhAAwckdcvFvJtvdqeVDFKYvx2k+y6m/pvbvEmbFHcwuk24JFa7qdPGyzWHoYZBVNPyRtrIn7PG5qEFRhyZruIgxp5D/WR8w3IUzDqvZsv
 rt12/8vj
 c1jGRDLyvnWZUzpFVasM3c0AqESeluAPJnGWLq2dj36a5GGe1ja1tqiNdWaTXzPdVVz3nXJflh07hBL9LI5b3xorl4pF+IwdxECWxjUa8RlPxXJHmgthQySp0GERVhlT4STEsHWVE3dfzLNRlb62WeMRmcwHscxGjEFn6RROagOIyOPGsqD6KU5hgJpk8RsJ74/jxJSMOTtIRQI/U7S/7QBoIgbmJBvVJFLO50hE1pKvBF5h/R5H4LMky8bk33q/owiCPbnX/5XWU6/tMLK3YWlO3UnT9BYLjK1JxAArOQ4mGH/jWW7DBZK3Lo76f5LHlA3B/LBRIdCvPluSNGmAPxccc1IbskCiMYSy/tiNoq9FRg5cIzDS2o/WyRdUzLbzuLTyHpP+oe+2vIzF6wRw2143MKjQ5Iu5JQWJ0IFSZOjslcaae9BW4U3/Byku4OfYzi+chQq2Gi6IWLFJrK1tdNiNHgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Jun 2026, at 22:34, zhaoyang.huang wrote:

> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> The kernel panics are keeping to be reported especially when the f2fs
> partition get almost full. By investigation, we find that the reason is=

> one f2fs page got freed to buddy without being deleted from LRU and the=

> root cause is the race happened in [2] which is enrolled by this commit=
=2E
> We solve this issue by reverting a f2fs commit 9609dd704725 ("f2fs: rem=
ove
> non-uptodate folio from the page cache in move_data_block").
>
> There are 3 race processes in this scenario, please find below for thei=
r
> main activities. However, by further investigation over the code, I
> think there is a common race window for the truncated folios between
> split_folio_to_order and folio_isolate_lru, where the folios lost the
> refcount on page cache and remains the transient one of the split
> caller, under which the folio could enter free path and compete with th=
e
> isolation process. This commit would like to suggest to have the folios=

> beyond EOF stay out of LRU.
>
> Split:
> split_folio_to_order() can split the big folio into individual pages an=
d
> put the resulting subpages back on the LRU.  For tail pages beyond EOF,=

> split removes them from the page cache and drops their page-cache
> references.  A tail page can then remain on the LRU with PG_lru set whi=
le
> holding only the split caller's temporary reference.  When
> free_folio_and_swap_cache() drops that final reference, the page enters=

> the final folio_put() release path.
>
> Truncate:
> The changed code in move_data_block() lets the GC path evict the tail-e=
nd
> folio from the page cache through folio_end_dropbehind().  Once
> folio_unmap_invalidate() removes the folio from mapping->i_pages, the
> page-cache references for all pages in the folio are dropped.  The foli=
o
> is then kept alive only by temporary external references, which allows =
a
> later split to operate on a folio whose subpages are no longer protecte=
d
> by page-cache references.
>
> Isolate:
> In parallel, folio_isolate_lru() can observe the same tail page with a
> non-zero refcount and PG_lru set.  It clears PG_lru before taking its o=
wn
> reference.  If this races with the final folio_put() from the split pat=
h,
> __folio_put() sees PG_lru already cleared and skips lruvec_del_folio().=

> The page is then freed back to the allocator while its lru links are
> still present in the LRU list.  A later LRU operation on a neighboring
> page detects the stale link and reports list corruption.
>
> [1]
> [   22.486082] list_del corruption. next->prev should be fffffffec10e0a=
c8, but was dead000000000122. (next=3Dfffffffec10e0a88)
> [   22.486130] ------------[ cut here ]------------
> [   22.486134] kernel BUG at lib/list_debug.c:67!
> [   22.486141] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   22.488502] Tainted: [W]=3DWARN, [O]=3DOOT_MODULE
> [   22.488506] Hardware name: Spreadtrum UMS9230 1H10 SoC (DT)
> [   22.488511] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BT=
YPE=3D--)
> [   22.488517] pc : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488531] lr : __list_del_entry_valid_or_report+0x14c/0x154
> [   22.488539] sp : ffffffc08006b830
> [   22.488542] x29: ffffffc08006b868 x28: 0000000000003020 x27: 0000000=
000000000
> [   22.488553] x26: 0000000000000000 x25: 0000000000000004 x24: fffffff=
ec10e0ac0
> [   22.488564] x23: 00000000000000e8 x22: 0000000000000024 x21: dead000=
000000122
> [   22.488574] x20: fffffffec10e0a88 x19: fffffffec10e0ac8 x18: ffffffc=
080061060
> [   22.488585] x17: 20747562202c3863 x16: 6130653031636566 x15: 0000000=
000000058
> [   22.488595] x14: 0000000000000004 x13: ffffff80f91e0000 x12: 0000000=
000000003
> [   22.488605] x11: 0000000000000003 x10: 0000000000000001 x9 : ffe8572=
1f0e25f00
> [   22.488615] x8 : ffe85721f0e25f00 x7 : 0000000000000000 x6 : 6c65645=
f7473696c
> [   22.488625] x5 : ffffffed39b23026 x4 : 0000000000000000 x3 : 0000000=
000000010
> [   22.488636] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000=
00000006d
> [   22.488647] Call trace:
> [   22.488651]  __list_del_entry_valid_or_report+0x14c/0x154 (P)
> [   22.488661]  __folio_put+0x2bc/0x434
> [   22.488670]  folio_put+0x28/0x58
> [   22.488678]  do_garbage_collect+0x1a34/0x2584
> [   22.488689]  f2fs_gc+0x230/0x9b4
> [   22.488697]  f2fs_fallocate+0xb90/0xdf4
> [   22.488706]  vfs_fallocate+0x1b4/0x2bc
> [   22.488716]  __arm64_sys_fallocate+0x44/0x78
> [   22.488725]  invoke_syscall+0x58/0xe4
> [   22.488732]  do_el0_svc+0x48/0xdc
> [   22.488739]  el0_svc+0x3c/0x98
> [   22.488747]  el0t_64_sync_handler+0x20/0x130
> [   22.488754]  el0t_64_sync+0x1c4/0x1c8
>
> [2]
> *F: big folio before split
> *T: tail folio after split
> CPU0 (f2fs GC)              CPU1 (split_folio_to_order)          CPU2 (=
folio_isolate_lru)
> *F: pagecache refs =3D n
> *F: extra refs =3D split
> *F: PG_lru set, mapping !=3D NULL
>                             split_folio_to_order(F)
>                               folio_ref_freeze(F, 1)
>                               ...
>                               lru_add_split_folio(T)
>                                 list_add_tail(&T->lru, &F->lru)
>                                 folio_set_lru(T)
>                                 folio_unlock(T)
>                               /* T PageLRU set */
>
> *T: pagecache refs =3D 1
> *T: extra refs =3D GC + split
> *T: PG_lru set, mapping !=3D NULL
>
> move_data_block()
> folio =3D f2fs_grab_cache_folio(T)
> ...
> __folio_set_dropbehind(T)
> folio_unlock(T)
> folio_end_dropbehind(T)
>   folio_unmap_invalidate(T)
>     __filemap_remove_folio(T)
>     folio_put_refs(T, 1)
> folio_put(T)
>
> *T: pagecache refs =3D 0
> *T: extra refs =3D split
> *T: PG_lru set, mapping =3D=3D NULL
>                             free_folio_and_swap_cache(T)
>                               folio_put_testzero(T)
>                                 /* refcount: 1 -> 0 */
>
> *T: pagecache refs =3D 0
> *T: extra refs =3D isolate
> *T: PG_lru set, mapping =3D=3D NULL
>                                                                   folio=
_isolate_lru(T)
>                                                                     fol=
io_test_clear_lru(T)
>                                 __folio_put(T)
>                                   __page_cache_release(T)
>                                     folio_test_lru(T) =3D=3D false
>                                     /* skip lruvec_del_folio(T) */
>                                   free_frozen_pages(T)
>                                                                   folio=
_get(T)
>                                                                   lruve=
c_del_folio(T)
> later:
>   list_del(adjacent->lru)
>     next =3D=3D &T->lru
>     next->prev =3D=3D LIST_POISON / PCP freelist
>     BUG
>
> Assisted-by: Cursor:claude-opus-4-8
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
> patchv2: update codes to eliminate bad page status

Please do not send a new version until we figure out the actual issue.
And this version still has other issues, like unbalancing LRU counters.

> ---
> ---
>  mm/huge_memory.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..c24c12f71157 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3878,6 +3878,23 @@ static unsigned int folio_cache_ref_count(const =
struct folio *folio)
>  	return folio_nr_pages(folio);
>  }
>
> +static void clear_dropped_split_folio_lru_flags(struct folio *folio)
> +{
> +	/*
> +	 * __split_folio_to_order() clones these LRU state bits from the
> +	 * original folio.  A folio that is dropped instead of being added to=

> +	 * the LRU will not pass through lruvec_del_folio() and
> +	 * __folio_clear_lru_flags(), so clear the cloned state before it is
> +	 * freed back to the page allocator.
> +	 */
> +	set_mask_bits(&folio->flags.f,
> +		      (1UL << PG_referenced) | (1UL << PG_active) |
> +			      (1UL << PG_workingset) |
> +			      (1UL << PG_unevictable) | __PG_MLOCKED |
> +			      LRU_GEN_MASK | LRU_REFS_MASK,
> +		      0);
> +}
> +
>  static int __folio_freeze_and_split_unmapped(struct folio *folio, unsi=
gned int new_order,
>  					     struct page *split_at, struct xa_state *xas,
>  					     struct address_space *mapping, bool do_lru,
> @@ -3958,6 +3975,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>  		for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
>  		     new_folio =3D next) {
>  			unsigned long nr_pages =3D folio_nr_pages(new_folio);
> +			bool drop =3D mapping && new_folio->index >=3D end;
>
>  			next =3D folio_next(new_folio);
>
> @@ -3966,7 +3984,9 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
>  			folio_ref_unfreeze(new_folio,
>  					   folio_cache_ref_count(new_folio) + 1);
>
> -			if (do_lru)
> +			if (drop)
> +				clear_dropped_split_folio_lru_flags(new_folio);
> +			else if (do_lru)
>  				lru_add_split_folio(folio, new_folio, lruvec, list);
>
>  			/*
> -- =

> 2.25.1


--
Best Regards,
Yan, Zi

