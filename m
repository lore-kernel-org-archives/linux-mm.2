Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB74DCCF9EE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 01:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9F258E01AE; Wed, 29 Oct 2025 21:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FE78E0106; Wed, 29 Oct 2025 21:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3E1C8E01AE; Wed, 29 Oct 2025 21:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C092E8E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 21:40:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E01114098E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:40:31 +0000 (UTC)
X-FDA: 84053075862.15.768237E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013013.outbound.protection.outlook.com [40.93.201.13])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9CC9440005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:40:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mQaUXYed;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761788428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2KV7sKEfvRxLIWD5On0kNmek7awOlqO6DQ9GAfZt0m4=;
	b=Vjynl2yy+MeRKBKn6AOptkxFBUOTJeDLGLH8uNZ3HCrxlY6MxJkdejc6E9UDOH7SHsrt7t
	URXwQ2NMCvdcDLC9kf5y/pp8CaGHOD9whZHKCFNb1Kc8MusO6IITIpdJerfdfNDS7FNavX
	WK0DH1uflPR0LMWO8iXiTYdc1i9ki/0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761788428; a=rsa-sha256;
	cv=pass;
	b=Gt4Z66cMEqAvTkOmlmbncLjUkIE8GRCgZrkhUVHHfWhlXZK+gjtbWYK/fSl7Rr4JiOKdps
	JlKujsCh1Q/0vgl4tF+TiLW+UevlEB+Gz4LFQdz3z33Ny/obeoDZStVD5IrGKzULBQe/+q
	kSRH+hR2cqcB/7OJoQhUPc1xjdzEw0w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=mQaUXYed;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.13 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXmGAIvdh4ocAk0gqzNRTawQDr0kehlrQu0dBIL29zs2yp/smw3yNGlxpTtEZJjZB5SFkZJXpAU3+bLXCfZyqu6U4PsqPVQj0Bk4u+astozrEttLOrnQxzagCIraAGf6oFId3AzOh9xqsZBOb03CDFYiJiLCKOtmYoxTxL07zplcH2SuiUmdtDGykMUrr3lyrzhflUZ4F0Xm3msJPNn2pU9Fk2oUs+Sz0Z8MVHNzKLjl6f+vA2DDX4d1V1lVSxQCzZBO2jhsr0qLpnnzeu9vxVcvyOWnoRnaNYnbEtHv7WG7XQrejWeQvJxfupBg77Lr6PvnbQ3M46mYQuzMNKg2BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2KV7sKEfvRxLIWD5On0kNmek7awOlqO6DQ9GAfZt0m4=;
 b=mDar8BRGEG/MPBUakHCNF8mP0J7cJ827ePSE0gIPqtkfnXg6sE0J8v8l/BHrN/sPAoN8RMdMsddeisolGsMG1jB4mqiAA78ZY3I/5sMI6u+GAVPOlqWI6uva+y3ymQWOeUU+JPAxjbgxWl3oM5g4YLXeU6bcZO0mqGsN6/OCEEwd6bJv9RcffNqfHf235tj3WZegYA3eQu8UJN+E8tjzZLCa8+VVOrWQIDYuYQhwFiO75B4F0LAw8hZXbqBjmCgyeWQvGR4F7cGywG3fkbGoPHQiiTPa+ujc0SoU9aWMudX5F2UzDKCId8deyU2X54361BlRjvt+58rKmUWYqYVe+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2KV7sKEfvRxLIWD5On0kNmek7awOlqO6DQ9GAfZt0m4=;
 b=mQaUXYedGSu4AknnFLubO+sade1toa0EhjBCu0t0wiHf8I/HPx1F8SzeK013kWYnBcZ06SdskNF7zDfhHqleoKsqTYWt6EA/yIw9hXw6yzTodMYV6n3GP8XiRESbovWoLzO6LiF+gt1IA6/v6DmVu8zO2To/IJbhxipi7xnQM+CasVen9qT+AHJRFUpdbi25S+QmJ/H/p/UdO36J2JZAi7lmT51DpBUevJJzbgBWxVGqsefkf61LUMGT63W42BoL782aOh4R/5uUCuKdfu4SkdziHr77rA/HVLacNkKjbT1GvHmSv+FlokZy0miG4zuZYhA58MomZIQQuIziUVipKg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8261.namprd12.prod.outlook.com (2603:10b6:208:3f7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9275.14; Thu, 30 Oct 2025 01:40:23 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9275.013; Thu, 30 Oct 2025
 01:40:23 +0000
From: Zi Yan <ziy@nvidia.com>
To: linmiaohe@huawei.com,
	david@redhat.com,
	jane.chu@oracle.com
Cc: kernel@pankajraghav.com,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	mcgrof@kernel.org,
	nao.horiguchi@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Yang Shi <shy828301@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v4 0/3] Optimize folio split in memory failure
Date: Wed, 29 Oct 2025 21:40:17 -0400
Message-ID: <20251030014020.475659-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0362.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::7) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8261:EE_
X-MS-Office365-Filtering-Correlation-Id: 9de13090-f4fb-40cd-28ff-08de17554ada
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jxCyw0T4P7psYAHpYrnTtawk2fRhXWBltlsfivwWHPoYJnsc2Vjlzs8n8BYf?=
 =?us-ascii?Q?rNARCKi3yKBV3P+pyXUSnFGDoRp5pkfmCiKijC+xYvOBclA3J2+7lVBMopeK?=
 =?us-ascii?Q?QpfMCCtiSJQtNOEwa+el3wC82FiWQwI71tLvoPqz9+a265MNoFhdp/b9NBXV?=
 =?us-ascii?Q?an9YiEt8r32/LRyujYRA57cry+KafUbP5YZmaB7zeO9ck4+Lo2EY8R6RSy2Y?=
 =?us-ascii?Q?i5QjUbbR5ouB7XNvKh4rXyv5tOL+z1kxvgPmni2Fu38eO96quJ7yyBaTzP7q?=
 =?us-ascii?Q?0LJBmuOMxxdf06ONkWSDZ5RK8ZaMjX415x6QLGGUHPvPIa2hkTIMwnXIzMrz?=
 =?us-ascii?Q?QKvysKq94HNwGIkCtolOM4iueLe+r8hMfFxmDhcNQbVN9bzSDlfPNlqWgHc8?=
 =?us-ascii?Q?3imPTfo+is9082RrOIMYfEhBWJDPWAQ68sI6jRoZVinfwKU3sD9H336rcmNk?=
 =?us-ascii?Q?OjNTJ2JJ8dAvE0bUfWvCb/03Cogoaya1oV4SOa/FPHDOLwY7DyT9zuahVZq8?=
 =?us-ascii?Q?f5YWG+LDK07JyxWtItXwnzdBOVTdL4wurqIyew8aiDF7WNPe798hWlFWj/m+?=
 =?us-ascii?Q?DyFA4WGFMCUtpSfQleIGUJmDrMQfLpD/sMsIBB8qKZ0ujChXRmK+K37cLL2X?=
 =?us-ascii?Q?NZx8BJdGS71Zz09+f+KN2YbUuOu9vY+CFwG8aU1gvfPAUhzIm0bJ4FrHuBqx?=
 =?us-ascii?Q?2gx7zDaiIP7VCUPNl43oY6YzlwvcTgRYRvXdynpToC3HQ3FvO/o4Z0xO2okL?=
 =?us-ascii?Q?so0t8xKrLVU998Z1i1RSmc5LO2SOfBgc4TQTCsbuMbFNT8ja8nmRrnOUQBZg?=
 =?us-ascii?Q?5yIz+ZzD1RK43ozctGXDq0TZcNp0lOe4lC6IjBVmx2h4M7bTPykmg8O8q4yS?=
 =?us-ascii?Q?2aOBovUH2b+0UBicFp6Xm8NDun9JEhpTkI4l1R/Jy2+w3+IgrjXDYun4V8KS?=
 =?us-ascii?Q?AMzmw1Eud14sFbbHyC/zqlAQpogrpxOn1B3vN1YnuHmZX56i0Oi1XijGkZXp?=
 =?us-ascii?Q?4vlib9pondI23gQPaxdzLzUTDGC26p1pSAdp3aE/Nv0XQhmfpjf2ofizGpkK?=
 =?us-ascii?Q?MOuVz81ypWRSbxIlntHrVyP3bPK5ZNGbN9tQQk1CF3OgGc7MYRw1wJ84L3yk?=
 =?us-ascii?Q?/qBlmbV4lpMQUQQt8v77JYOqPbfcBBIlSpFbzyW20wlGpU4kALjIFrqsAFHZ?=
 =?us-ascii?Q?Zrh9YItQjkd75NYJ3Sw5eXqx/g2L5H/m2L9bpPJ3OXii1fN9QpcdSGZ43D+v?=
 =?us-ascii?Q?aWoP9WH3g7w9BnLGdhCUbIxy6anY3no00bg3bAiJ71E9Ibvlm3Klr5ryIiis?=
 =?us-ascii?Q?1rzyivwfCbTAVvOfLkupVCLfAjvzdd3wnTOBlKk0svL87yRN0KsS6o7Tkmfz?=
 =?us-ascii?Q?rZBN7Y+RmecalgBKu4WskLpszQla3vsCqA1/d8ATO7hjyCOUVOWqyagsw/IQ?=
 =?us-ascii?Q?NnBgbPC+3ZChYCmYgMvdZM7ptZR+Go31NJCoWYOzljTFwD9Iysd09Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Oupb5KVQdzb98JjAd0N86dg2a8q8HRiGv3azzESUc2DYV2aS6wibyW+FQ9YL?=
 =?us-ascii?Q?nLSM9EmZrJehwSlv1JkwOwLZzrDKLnDgz/FLJktQjXLqsmPg+/b+uQihfv2m?=
 =?us-ascii?Q?MoufbPjT+hKU2RhkiVjbE0nuEExKcg88iqyEIG9oa88GLHra5l2EMzts9tNs?=
 =?us-ascii?Q?BAKZH1wDR7Eb69ArY+v1VQgtJJRcd7g4E5nqS+2V3dtiR4gpjvlkuQTHdkiV?=
 =?us-ascii?Q?8Wgt/iYI9/2ExEyFLkmYQLwtwyuNvG6ldQ1l42UCqtfU0vlaxvQ3cstd1sxc?=
 =?us-ascii?Q?Ne+ysP1vMeZ3QvLzJ/FcfgzdkNXLAhCkWv4vLCiI1XNDNw+xykf+bvR+NI2I?=
 =?us-ascii?Q?Hh75Ih7Y7vJy+lagH2rjyLv4Hbx6Lq+b+ZWWJKA3poKHpDEyBKFD7mwaOPaH?=
 =?us-ascii?Q?W1I/oefl0+EOD9YOD3WtyjGlvL44EPueF/oxYCH/cl9OMWkWIwdoSPDWAitm?=
 =?us-ascii?Q?4z5uLKCg+bp9O9mlpIO4EQljGOi5LMIttmXKI8uSfptlByuvsr8BUVYKYQTd?=
 =?us-ascii?Q?LBvxT60zRGg6FehLhahn61dH2xPDNMaCGETRirVeEfHKw6Ceznm/NwHVjJXo?=
 =?us-ascii?Q?eWFSknVAvYF2C+vvopw8jS3fpYa3gkGTsCNmtE2IPdT6ZnD71P6782dO7b7Y?=
 =?us-ascii?Q?HZUTvpJnf1SlslwmTCyMTfI9ztv8zk8WEXYPPFApgtQrIAbQNkOZYrpxzL0c?=
 =?us-ascii?Q?NARZDqPxWBl/STJPgefYp3UKP/voAxlprt8EPnXpNN7eMKI90u3cXtEFazGz?=
 =?us-ascii?Q?RjJWrVZDplARNmzAmuT0EuXy8DKoX2+u24lp0pJ37J+ICBxxpcYOspEWrx//?=
 =?us-ascii?Q?NwuJtq+rOplBIHfO914tsbDUg7XYyOP6KWTJxwdIgHb3Jhb4SpZw3zWGWnFM?=
 =?us-ascii?Q?zRmjg0cCdj4XGOpR5rOwwsZHDv1ix/ewwM+JbgGrwRiM8Bg0r0wBgaULVb/1?=
 =?us-ascii?Q?B8vbMFvuRhjiVQIpp1AA1gtwJfZB34AafS2uNbZaXoubN/sUIb0IRZ3tOgxN?=
 =?us-ascii?Q?zrXXF71ZLeQyrDghnbEapKsBrp52ja+UE/o4ATZY9kypzwMgoYc8x/Oh17EK?=
 =?us-ascii?Q?Kyw8AXujXDRGD49JgNADA2N0ZLOke4yGYqqRqLkp/6gid17RWjF7OVwfCnDE?=
 =?us-ascii?Q?PicNkEJ9q0zkC1irgB8R74JnVJoSM2h70N0vPX7kkeHee9pvO1d8ZWnsyj9M?=
 =?us-ascii?Q?d/5LPfaWQxDO7QTkS5v1+Mh7E3lNYYOlO+sXhzdWXlkOMsjuAuc3K2ADKEhu?=
 =?us-ascii?Q?W7Yqt1bCuH0AVkFF+RfRKady58cSlxAxem+WHQws37i1Kc3sWrS4V2nxoZ6M?=
 =?us-ascii?Q?uR5dP02luMmtDIHUbc8Wv7rE40W3l+yHXuo/q8tvtpe7rnRSitw2Ha5dBJIz?=
 =?us-ascii?Q?DfpmquJix+5PIkbcZ771t8Eju+k6goMStco2QFmUUJxhhlE4kr+gBxFRnDVU?=
 =?us-ascii?Q?02pnuWVBDy29JQ2S0fP69VjnS1OVMYRl8hRCzeY5Tk7Wja/rDNn6efvxMTi+?=
 =?us-ascii?Q?+G+ClMKIjrKsBhleHcohoQ4JtKrs9cTSky3FT7LRfIvWGpiKqA7mEz7yg0Ne?=
 =?us-ascii?Q?s/SNm2ehAlEd30dF6bqzrQ0PrfuyOUsiYHDukjt0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9de13090-f4fb-40cd-28ff-08de17554ada
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2025 01:40:23.0460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RNdCN/2GaONCa0+7v/XG6yVUXwYxuKyJuAcBCSBtrV0PcI3sFAL8C/gJ2InKmK7X
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8261
X-Rspamd-Server: rspam05
X-Stat-Signature: m1ecuzm93ekzyqduwtz6s6kk6w5ksf3s
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CC9440005
X-HE-Tag: 1761788428-712845
X-HE-Meta: U2FsdGVkX1/wi+7y4MQGXR0htXl+1l5L7zJ0baCxl2BW2aHG/EbrnqPrDeMrooweBQn+OSiH78Lmxj6iO0JCm60gtUDkuxRrBnLtXmlfPpfbM66+KF2RY1yKfnR/rlhDxVLU/wnOy2EsNqBKPsWJE5NJ8gpF7+iWGtVtlxhr49wHCxr1C/tlSkXdgLVjpxv9aJ4+huHLCB+Q0xTn7SfrqRTtfFMHXSeYclb7NM3Rk85msK1graps9eEjOq/yojrWQGb5PZuSvcWwJWWWr89GCGglXDLdsRtqncCaQIL18madJHomqoltYEohHV2uuDxdwDMkqAhyliaApOOVmF6S/gfsRnzEoH+VZpVQVmg2Y5Qu0OjLdH1w8VorkHsmv29dG3obLmpJGU/TT/Kx6xDy8NzzdhOOtKI+HGx+TOWwU0yIxWiqFggfr85IKdrWOakHLARyhbxKMSeIa/wYZc6055zGlg7fOJqoWu5k+MFiMVfU7eCwpZ6uJgrZTecGhUBH05MAMaaGkgqGrbDgVo2EqyOM0rK5AueUvgphWOc3u7GN6Yp8VDjcYPPQuWfoD/4Fvyi0VHfPt5Y3aFQtEKAFFHCJtgY8Z/hfnQJnPNjJn8bjdjnnq4thsdmKML4fYcO+i3vRc5pAjfwshC5sAZ6JcE42B/fsyQSfhgPprdG5eeMLuR/6/R5IPyHJYROLx94Fc5LnGJbUoiSj8d3GWNigSKhF5Ll4+38wg1q3WG4OUrj8YxepnxbHXlb0Ww8FCo9qmNRT3vFIUK3EQI1sLxESlVnmTHl7F4GmcummIbADbGIDt60j4/J3SDimg13HZQ75dA862vaPbkRHLvYZudAEWKuTs4qU1ejtGhzLqus366T+yUejk05Wgi/4s2kQPydU67Os+Z3hog1lu7FKQH4JR5rzDL+TKkIMNymKhobcZl2oRQDcSmcw2n8W3JrbFKnhi0C09fYmp+35bQEmUh5
 8Ln5FRzL
 X+4rs/hgbuX435TtbEUFsq0BSF1Gd5y7VLqa4WPSZ8JKFQoCPB+TmVhJo5RSeJv7kFahPd8O56R6zh5xoaLkvSWYCm3OAfbqmAJSu7AQimq5awEE80lR+a2y/4VpLfYdIr2K8IzZp7z+cfqwV2mAbxX0p1FP2T6DEWwQ824WGMB1PCBLxZqbJJ+XQVOLkiCzbKe1V2mQUxq2WgvvMRE9ZCM9BbvZbfIhA2A4KS0gAsQxD1P5J2c2ilimnweRtD8GSpI8CmPpAFRxEfV3Ce0uvlvkHMhsN4Xj3Q3p4NwH91QusrFghQGnxnXB/pzCXAMHFxpslo05VFPmP1tLBdE3I55PAg3DJNkV35xBplq0mCRG3L2VljV51+WELKCD1jLKhKqQ/nm7Q84al2T5I3b2CO7ednT4xP8OR/IJYLgsDBgJDGv5g1Lm/Pz7ngyxuDbYZRcWv5SYzbWqKNRMuwGdGEQVyzT9vfjSwUgou
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset is a follow-up of "[PATCH v3] mm/huge_memory: do not change
split_huge_page*() target order silently."[1] and
[PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split
to >0 order[2], since both are separated out as hotfixes. It improves how
memory failure code handles large block size(LBS) folios with
min_order_for_split() > 0. By splitting a large folio containing HW
poisoned pages to min_order_for_split(), the after-split folios without
HW poisoned pages could be freed for reuse. To achieve this, folio split
code needs to set has_hwpoisoned on after-split folios containing HW
poisoned pages and it is done in the hotfix in [2].

This patchset includes:
1. A patch adds split_huge_page_to_order(),
2. Patch 2 and Patch 3 of "[PATCH v2 0/3] Do not change split folio target
   order"[3],

This patchset is based on mm-new.

Changelog
===
From V3[4]:
1. Patch, mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split
   to >0 order, is sent separately as a hotfix[2].
2. made newly added new_order const in memory_failure() and
   soft_offline_in_use_page().
3. explained in a comment why in memory_failure() after-split >0 order
   folios are still treated as if the split failed.


From V2[3]:
1. Patch 1 is sent separately as a hotfix[1].
2. set has_hwpoisoned on after-split folios if any contains HW poisoned
   pages.
3. added split_huge_page_to_order().
4. added a missing newline after variable decalaration.
5. added /* release= */ to try_to_split_thp_page().
6. restructured try_to_split_thp_page() in memory_failure().
7. fixed a typo.
8. reworded the comment in soft_offline_in_use_page() for better
   understanding.


Link: https://lore.kernel.org/all/20251017013630.139907-1-ziy@nvidia.com/ [1]
Link: https://lore.kernel.org/all/20251023030521.473097-1-ziy@nvidia.com/ [2]
Link: https://lore.kernel.org/all/20251016033452.125479-1-ziy@nvidia.com/ [3]
Link: https://lore.kernel.org/all/20251022033531.389351-1-ziy@nvidia.com/ [4]

Zi Yan (3):
  mm/huge_memory: add split_huge_page_to_order()
  mm/memory-failure: improve large block size folio handling.
  mm/huge_memory: fix kernel-doc comments for folio_split() and related.

 include/linux/huge_mm.h | 22 ++++++++++++++++------
 mm/huge_memory.c        | 27 +++++++++++++++------------
 mm/memory-failure.c     | 31 +++++++++++++++++++++++++++----
 3 files changed, 58 insertions(+), 22 deletions(-)

-- 
2.43.0


