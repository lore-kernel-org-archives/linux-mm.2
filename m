Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2C8ECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 163936B008A; Wed, 14 Oct 2026 09:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115236B008C; Wed, 14 Oct 2026 09:34:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003346B0095; Wed, 14 Oct 2026 09:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D19926B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:34:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655EC1A055C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:34:48 +0000 (UTC)
X-FDA: 85321327056.06.A7022C4
Received: from MM0P280CU010.outbound.protection.outlook.com (mail-swedensouthazon11022081.outbound.protection.outlook.com [52.101.77.81])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8D5D918000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:34:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gaisler.com header.s=selector1 header.b=NZBseKHu;
	spf=pass (imf16.hostedemail.com: domain of ludwig.rydberg@gaisler.com designates 52.101.77.81 as permitted sender) smtp.mailfrom=ludwig.rydberg@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791984885;
	b=jcckpN2z2tEhOtuFaYPw5oYDhCeV+OKWierkvakYnVMdMAfnla6MzCjfYeeC2Xqu1oVMBd
	LkTbaBP46tcCYmDC9PFtxqLhkYvuVfi7DQ4NzfgTCZP1wvr1HYahemA7j3sqz2xY9w24iQ
	8sMvZDxtR99tRk7PnvyGFQ8/9o0hXDk=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gaisler.com header.s=selector1 header.b=NZBseKHu;
	spf=pass (imf16.hostedemail.com: domain of ludwig.rydberg@gaisler.com designates 52.101.77.81 as permitted sender) smtp.mailfrom=ludwig.rydberg@gaisler.com;
	dmarc=pass (policy=none) header.from=gaisler.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791984885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4IeQSd4355cED/fQa6Y5W2XHjkCHm1D9jP1tUI5iL8w=;
	b=JV8NnuVS9Qzs1xpiLRdcWwj1R0BnxSvY8tD3nfGFj6ZQ4lgsRtdbf18dIsFKJ899WhHLjW
	otJ2k2rABJkzMYWziowoUseikjT5FUAK5lI0Ohtwc8MOVurPyznwwZmDrWKVFvvdzNhI+B
	RV3CdVo6Ez9hSWrB58yEUK0exEtCZIA=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o8Mmugxo/vB6ItOtZC54hPopZbfHidZhIDK+0VSphbFwSXMx844pAkC7xgVloh1DwawhQO7NdfKR+/lrGNTvh3jw2cd83xtp9MhYT9BibiOc2eDXjD9WwWkBR0eXzV399TQSQrdcB9eimzU2FmzyEJLLvtvYJjpLiznPH68IobXUP5N3+p6WsdboEwwrJ9ninVICyNK14hzksvILmCjvrOP/eJktoUfubW5o0wFRtLduY3F3cof07EHgrQAT9Tss1JM9Rd3m3K48b6Dp4BMvzLJpEgJd2toIPxKfSNwecmTrFkp9w6rk2Lwl+5aLZ7Ftaj/NiTSY29+QVIJtJRH34g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4IeQSd4355cED/fQa6Y5W2XHjkCHm1D9jP1tUI5iL8w=;
 b=T9LA0qzxB136Df4McnrAyGTeX9jR+l606r6N0VhoGXKvhqNmRSewu6NVH5iqANm2Az6N6g2gthSEMS5dEBqgM96paRSOgqmMHo9MFVpoI7LBpj+IlCDvr30Pzx3dGUz/KhNzQNRQCmUifO4mevwmDrviXdRF68U9NIV+gH9ZrCdokQs9MIZQmj6G+vIGODT9ErKeAW5Z/mjhlY9qI8bEHs1871TvVUGQILo+3vgdfGSJFBTmMAHqTVnNGZenlClzJ/wYer0lcvzqsnZGtWBXRrG9LBk5nQrdLUeyAMaCnZZZAQw2jZ6/zJwVV640u59ZvvKuDgG2PJSV5z/83oPAWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=gaisler.com; dmarc=pass action=none header.from=gaisler.com;
 dkim=pass header.d=gaisler.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gaisler.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4IeQSd4355cED/fQa6Y5W2XHjkCHm1D9jP1tUI5iL8w=;
 b=NZBseKHuMjmXshDSJH6p0zQzzyTY/hjFxYoM+QydTEETMq8Imgk27i+ypvkRuoi6W9sDNONgx2JUjMMlWt2NFBUCxfry3wW95038hSV+B1UYwvLrghYDthWboB2sbNnQv5elWtr+Tr10XGzkCxdhstHUSoEJi0cLPi6LPi8JoNNtHFsNP4lsOBlnj9fNE3vNuoye7BBlr+keFQEcSIkMaVdy47k0dPQAL+HQV0f/dMeZYTfQlPyaZN7RLvqnzBO81dhxYDOz7rYcgSnXz/VnaJL2DyCodXEfqAmgEjg87KUb+e/ESNvAKh3OcEw78YFJWVw24gHJqbFLPz7CLa9wDw==
Received: from MM0P280MB1058.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:2::17) by
 GVZP280MB0588.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:49::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.522.13; Wed, 14 Oct 2026 13:34:41 +0000
Received: from MM0P280MB1058.SWEP280.PROD.OUTLOOK.COM
 ([fe80::8e01:811a:7101:e192]) by MM0P280MB1058.SWEP280.PROD.OUTLOOK.COM
 ([fe80::8e01:811a:7101:e192%5]) with mapi id 15.21.0522.012; Wed, 14 Oct 2026
 13:34:40 +0000
From: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
To: Andreas Larsson <andreas@gaisler.com>,
	"David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ludwig Rydberg <ludwig.rydberg@gaisler.com>
Subject: [PATCH] sparc32: Fix pgd lookup in vmalloc fault handling
Date: Wed, 14 Oct 2026 15:34:31 +0200
Message-Id: <20261014133431.8003-1-ludwig.rydberg@gaisler.com>
X-Mailer: git-send-email 2.35.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV2PEPF0001A334.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::699) To MM0P280MB1058.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:2::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MM0P280MB1058:EE_|GVZP280MB0588:EE_
X-MS-Office365-Filtering-Correlation-Id: acdc2029-6246-48b2-2090-08df29f7e64e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|1800799024|52116014|366016|10067099003|18002099003|11063799006|261009223027099003|56012099006|38350700014;
X-Microsoft-Antispam-Message-Info:
	VWI1q+t5fIi18XTiDHEycNoWjtExgRP8tSgIhJO1jSf+ZqfrP0xn1IjE5iPZY4t4fLIE5n6Ocso9jqxn2+yAagd6s3Hf3xow1OHg8tuF1nW5zgiy2ZElgg8Y+yLgXEKnuhhMAhUZRWZCQdmOOUkxeR5+Crj0m4hsbIWvP4l4giQywb/7lCDhF0YhOhWoKw0Qj+xcNRHS811t7691/q8k+5WOhtVQrvYqP1H+7Qp2jtL45BeLLsYVwm6tKI3T7XQIMTNX/XUi1eL7Sj7nNa1N93RMhNb4j0oVNzTGdH6M0XOYIhFfaUmMj2sS0+zfyxfdRSpIUEkp9XljKjdgQoE616v6mh3bQt2AzhpN8MUqWhf252R2As9AcVq7hAQG2BLJNyKJrM66kYac8p8Sq27RkCHzEYmvgV0TGlDRGaJKft3RyCqBMh65RLe9OVweyhuMW44LDkGgd8pVdQItFL5l0fy7o93KaxMucZITzxJ9ujUaBpXbn/JeX7Q66oYJrGG4P4GMy8j6UbWQk/9VPH3dL0syZw914jjPywQx2mryKcCsVt29YUmOZV8fNdXMNgclxD+8s/1vmCUFuNOHJp/cQdVnDI2EzmSFbvVFKPLRUVVd5npyhceCJmNynu8KHI1NeqnH7eFV00ZupFLbrDC/jAMoXR+0E0pZk7Gzw+WFc2wGOmSJNYHCqF9qI/T7S76JEToDFqn9QuBSoIlQ9HM1Ow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MM0P280MB1058.SWEP280.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(52116014)(366016)(10067099003)(18002099003)(11063799006)(261009223027099003)(56012099006)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RJ7KtL9Do4rHuxhax0D1rBJRfSKRmk8EvwiXTceazoJgjUfP5IOnzAn0LcZ8?=
 =?us-ascii?Q?Vh/xyV2py6ucJDavoO31Ok/lzVHRglRcWWr72e7X5vClCLxFxEuL47MlGYdH?=
 =?us-ascii?Q?wAq6j71kVM30jET2kkDkMifUXW2EsYSPlnNi8bitXKb/7S1o2pIcxc/ZHOfu?=
 =?us-ascii?Q?VVo9vrgpjuRMwJ4+vgABtKln0VbDFacL7kOZmPXoVxhqzsGkW+L2lRkbAVS7?=
 =?us-ascii?Q?KyntKmTKdX2zoWtOBVAXUwKrg95o+LKEVSrlOURQMIkotpDmgiSyVgq/TP4m?=
 =?us-ascii?Q?bzPWBI/M54jTmI4T+DeaMc1XIUvat2ZsVQfLuRop2r7ec4XT2Yy7zNsrjfPd?=
 =?us-ascii?Q?QSjPt3iIFj4DoDacWsLC5DDgHBDDWffbpG322rmWKYncZBqa6oU/P/1YWRGd?=
 =?us-ascii?Q?OGv2YLJle5rBUzdhw5WMkEB13e/dmt1MnKl6fBtlsDgAppy9nZM3KeJqsiYI?=
 =?us-ascii?Q?Cs1gm9ri/XpFGiUkT6LHhH7NhujEwXGQMMJaI1jsKuXFQa1tEjN/T/QMqq3e?=
 =?us-ascii?Q?WLseKQx0eRsnNb26MJX2qWWt4JMrFjCpLBtk9i6o9p9u0pBEW6pmAfrFTliD?=
 =?us-ascii?Q?QLSmBh5W+fEn1wV2ltWfY7IKYg5TpUw+6eFeDDa7vDkReMynjdruDDUOCurF?=
 =?us-ascii?Q?im6h74pup7H/GqRuUT4Z7IjJnOVjdS1Fc5z2ifb5cU2NbQSX3PuqW9LBYiNu?=
 =?us-ascii?Q?S4tdzV1/QMOARn+kWyv0gT9KW6TqPi75ZXPF/3EIMxZyqhyvqtfqc9axqoqv?=
 =?us-ascii?Q?3D7pbEhRFfb8KlzN3XGPZK3jyUQW1Y8V5lLd1U8EZfKthB2mosyhl3JKUwdL?=
 =?us-ascii?Q?2elzS6x3d+o9/i3niE0R+N3w3e25bKjQdHDRi8gdemx90yyhwPNAyBqw16zv?=
 =?us-ascii?Q?M9iYpMfeInX7CwGPZnzYgw8fX2WyHNxWIvkBuL7zBd+u+E1WBRsHxgkQNRLD?=
 =?us-ascii?Q?Gj4juvcYlwuJS4PLND1RikSMnKyY3TztsrUwg2P8g4ksrENxkYuX1SsXHLuV?=
 =?us-ascii?Q?Ahvno35/jZrI4vLl4JftEAp8gx01iTQ24zeOJGldt7pEdQDPKs4TN1beBwVi?=
 =?us-ascii?Q?LM/G+6NdTyllZoGcWkhQYtvhQI4KzW5wT+9fQ4X5R/YbHn8gs7CVS8/QkYAp?=
 =?us-ascii?Q?a/FNYe6YNQiwUJSKRfTv0cOMUESQ3IOdeESvCZpE3iR7noPCa5hukGfH2Xur?=
 =?us-ascii?Q?6WSt6BGjcAKoljbgJ9+foHOjM0G698oqwGOS5EfpPqq+ash/tIF3Jd3mvxxc?=
 =?us-ascii?Q?IaRpe1FgbcIc5AoHzO9AivuDntUBoYgmmdfoixMTUqYIe+u4MooGIpisB6jO?=
 =?us-ascii?Q?7Zw5LHC9Y/lYyY/vQTg8iarhNvfbZ7LIMizwUTfFYnzi/WBuxu4VdxAosIfd?=
 =?us-ascii?Q?PWcq42r7YyiIXD5F3f/aQiuCUwtgWcxMbBxeX2cwoVrr4HDFCvfjjn+qljkp?=
 =?us-ascii?Q?2U3kGFdy67DPf0irjn4FzDP0MEyCfsHCvDN4zzkcXnNGJMmdmbNbjGkaDs37?=
 =?us-ascii?Q?6MeSoLrM+ijPNyllOEnNBJlFKg/PGlZWPZsgOgIbmFVbKMtm3iWzoxnHGfHV?=
 =?us-ascii?Q?4WkJOxObx0SarDegscoS6oEmVfQv7qNnZBLN+P4flPe1ULZvBJ5F9QD4hiX4?=
 =?us-ascii?Q?IsdKSta2tPREjhlig+x8ck3Xz1zWy/cJFvyOsSPq4a+XtU4JC+Jmady9+ISd?=
 =?us-ascii?Q?IGFcDNeNP8beACghq54OeFpnftTDjYTrlYgnOL1enrapHiGi28bg52M2VPQW?=
 =?us-ascii?Q?/cKWcR0JRPAeHuDUhlhxRmplvpCDJjU=3D?=
X-OriginatorOrg: gaisler.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acdc2029-6246-48b2-2090-08df29f7e64e
X-MS-Exchange-CrossTenant-AuthSource: MM0P280MB1058.SWEP280.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2026 13:34:40.8800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 91fa4a59-2167-458a-8318-e45d80469d7e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TH9vYLjBJ21a0Pa0QwdFsmvrFta5Un3rdMFQgGHx13GT2ZdK/UwTods+YXOt7oxGfBebHe2sW2MYFv+1X84M41+BNKn7VHH4TzrxYsMULEA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVZP280MB0588
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8D5D918000D
X-Stat-Signature: tt5mtiidxpyqiya5bqg1zh5cbms1wtnb
X-HE-Tag: 1791984885-668909
X-HE-Meta: U2FsdGVkX1/86tBLfdfjjGmfYizJh1C9kc5YTqJYXrhf14iB7oAoBWkutacP8JC6GNpD/4R9Ulnm/YXFPs+wzE64K0sWn/B2cOt+crysT27ujBgI9cOdJr6hZIct70/TdXza24poVyvi/+AeGCISni+rgN5B5CCOpglFqvhh52rrRk2Rmcg/kjlI/pIOavj+7TxopWqMnjn9eJz5PnSogp6R/lDdBCYEsBkkC0VkPuNRFty9HEIEWKpOXMce/j7VCIQk4CDECHHj3Ze0EOS1roQwiq2xUdaHmO5iPIlAh2cAEuqr9blu9AcytLHhJpRHLghRWijzI9981No0QOxGRgb+AaaU6GOJl7gFkUENYMCBGllpnQrMk2M97JfGs1g+06O1hRhf2ghQCy2pVon3C3VYBz9dW4jNlbfUhZBuKveITQ9rU2MniE4bOqpamJx1hahPc/AfZ+d4gv6vjd0DBLNsrXUjenioE8O57/i12Kk83h+TOffOuZowhsu1JejtIxtxu9NrkXXDpu6Wi3+pD7x7fnljJRtQ3CEB9TvyHsm80Rn2Ue+kv7a/PPTGhi8oUGA0uf12WdoDua2Sv6EQLJOcgoZFhzpCCyDVLsR9qbuHBhXlseVfakJ6wr4+adHsZhp7sskRI7oPX3Vb7/2Dm3lFn3oTWAs9UM1gZFAZrXd1Q7l4aEIGFfyT5hVWJeSSCWM8RwKIYxRyAeTSr0+ExXukRUirePweZFSUSYfV2hVtyoXj9f7wPYBjVr4JznBoI4GWC+jm8pLeCLy9rpPh93aG/ue6H4zBWsO1G3m0pIVf1bCijryHkLY0f23RqIYg1yItdAaxlInIXDA66UhXfxSSX1GGYx/QWmxAcHKlD2XTtnEICrjHS3wzfyuOkfimO1ADGTprn9ZA9osnvborVuigx0GKG/bDkmbKO15/MasQ1aUFdJj7lxX8GlgUKGrVDQpvKNRQHXHR/TL765e
 EOxoUo05
 gWwkqJLEVkQm1PHYSfmCwySAGuf0jIrObMTHL5Twjq879F29q7ztpmCALVOJz0vADMGYxLKdm5YjgFXJIZCv2pFxiAHrZ91oOnnS+mn98Tr+tkG/V5Y5/+YY/tAJnn5Q261w/CWAoyQCQamT6Lrx4U77e0RRot4FqdU6uizNZbPIAcFe7YrbgzLKoNTX+K6p3wC7ycfcAkHp/iZz6aayTx6MB5jbnXtKo+ldcDJYI74oW6bKxT1Gl3UL8eMFZPKUpm0Q43ugOe/kPFPWyJh1+6ztCmR/e7+vfLxytwwmEsQjGOjVKJEujgk3uZy8oLmZlE8YJpOx7z06JEHnrI8TYpveCyIcZXhl5Oy2I2H/QVR4qlYudxm7fXzNBxp4Q5BOcjO0At9wKR+dvOETtjcGc24DT+np7g3amP0/1fhrVj6YrcKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Check and synchronize the level-1 entry with the PUD accessors instead
of the PGD ones. SPARC32 folds the P4D and PUD levels into the PGD and
pgd_present() always returns 1. The PGD accessors therefore skipped the
synchronization and the handler dereferenced a PMD pointer derived from
the missing entry (seen in this kernel panic running v5.10.194):

  Unable to handle kernel paging request at virtual address ff780000
  PC: <do_sparc_fault+0x20c/0x3c8>
  Caller[f0007ed4]: srmmu_fault+0x60/0x70

  do_sparc_fault+0x20c/0x3c8:
    pmd_present at arch/sparc/include/asm/pgtable_32.h:193
    (inlined by) do_sparc_fault at arch/sparc/mm/fault_32.c:358

Fixes: 7235db268a27 ("sparc32: use pgtable-nopud instead of 4level-fixup")
Signed-off-by: Ludwig Rydberg <ludwig.rydberg@gaisler.com>
---
 arch/sparc/mm/fault_32.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
index 86a831ebd8c8..f9befdbb3e72 100644
--- a/arch/sparc/mm/fault_32.c
+++ b/arch/sparc/mm/fault_32.c
@@ -276,21 +276,21 @@ asmlinkage void do_sparc_fault(struct pt_regs *regs, int text_fault, int write,
 		pmd_t *pmd, *pmd_k;
 
 		pgd = tsk->active_mm->pgd + offset;
+		p4d = p4d_offset(pgd, address);
+		pud = pud_offset(p4d, address);
+
 		pgd_k = init_mm.pgd + offset;
+		p4d_k = p4d_offset(pgd_k, address);
+		pud_k = pud_offset(p4d_k, address);
 
-		if (!pgd_present(*pgd)) {
-			if (!pgd_present(*pgd_k))
+		if (!pud_present(*pud)) {
+			if (!pud_present(*pud_k))
 				goto bad_area_nosemaphore;
-			pgd_val(*pgd) = pgd_val(*pgd_k);
+			pud_val(*pud) = pud_val(*pud_k);
 			return;
 		}
 
-		p4d = p4d_offset(pgd, address);
-		pud = pud_offset(p4d, address);
 		pmd = pmd_offset(pud, address);
-
-		p4d_k = p4d_offset(pgd_k, address);
-		pud_k = pud_offset(p4d_k, address);
 		pmd_k = pmd_offset(pud_k, address);
 
 		if (pmd_present(*pmd) || !pmd_present(*pmd_k))

base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
-- 
2.35.3


