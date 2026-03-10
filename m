Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1125DFD4F16
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F203E6B0088; Tue, 10 Mar 2026 15:07:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD466B0089; Tue, 10 Mar 2026 15:07:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE306B008A; Tue, 10 Mar 2026 15:07:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B32386B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:07:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 404171B7643
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:07:18 +0000 (UTC)
X-FDA: 84531086556.26.1AC06BC
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010012.outbound.protection.outlook.com [40.93.198.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6338CC0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:07:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nsvwt5Zv;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773169635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1e6WkVs+Ud1j9fDlIP7LmWTZHNNwdfJQsdhsEokSKQ=;
	b=Ly9ULzxYpaNUA9tnr9QwsqAFRgl5GT9R2CLo30xT9IjU+MYpxL612aPgVcuDfPnrFhGR1y
	7ItOOAqPKwjHSZUtZL3hGyvFoTx/gYzoDUf0hDWHmkMP4foPjRDEDN4fzz6n7XWLG1wyWH
	3/YjIncnXGcfucG5O0TlU1riOtUYAYs=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773169635; a=rsa-sha256;
	cv=pass;
	b=rdsSt4qBx8j6VCJWZiWMq7pvL6s+YizpuDlLEv0yi8OdMtdOcGBzrV147vc2G1JjOALcRd
	8kAJD39AfWnBeUvxtTFduhc5SJtqXD1FGyJzRWl/8YWrZPTJJqLLAf09Jza+ZifAggZYWp
	IXGef1+oci+QVn8WJrpa55qEg6q+1Kw=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=nsvwt5Zv;
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=niROF3dLfyb9wPcrmR7yBYdCsnNzJhVl9pVD+LhnJI68lU3eitnYwdT+0MSYpDPvnpcCB7IA53sXWu116DcLJNnXQDYXJcUfX9kpdF/0HlJ5V99hShNtYsj32KDwizfb+b/GPC/4DHaEeda/yeg44RjRfeM/GQCv74HhX/fKxOzyUTQDaWlL9NdVXpTCp9CdGh2d+1ENytj2dtUP4ApsEzTUmaa/Oh+DAdJzh2kQd3r+HTnkFSX7TG29mGOvhCBRf7raGd1wq2HuCDY4/YO+YW1jg5NILKcoQEtOYPmyJ9ksF5v0+Bf7nig6GVPW9OD1Nhdf/EKxLZYYpgcjLfMguQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1e6WkVs+Ud1j9fDlIP7LmWTZHNNwdfJQsdhsEokSKQ=;
 b=ThIzIz2LnZYnZ4hWD1rVqYtgR0VQ0Da6VlVGDfE/3PK2OAnHTzdUmHM8aMcmMdlLLzAl3phK0DeVc30TCVx//bO0HNC0E2mNTjQag1hdv5bTdLNjmUsMQsnu0zB9tZBknDs/QllsaZbI6QtMULYHFRYoa8YiDiP6cBzJA9qSAlVEWpD6LYKn9bUA7aOrDnvYNWWfBXdGUrPGv+ytoYPvHnApN4P+pPWqkDUUQ6eAK2vskdqWb2CfddlO1XB0x0gi3HQ7qUjg4t9rkqN+Zw+L8OW2+gSuCK6MW1PY1lto3qJ+RMwiIskFYTUYoC18Na+mC0m4EZ/6hg05aHPozmfy3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1e6WkVs+Ud1j9fDlIP7LmWTZHNNwdfJQsdhsEokSKQ=;
 b=nsvwt5Zv/MnOywHm709L8vj15eRcB3n86fiTrr3p1JjdtJEQZW8pyv03tqfOtAvjMpfu8w7al1MJRntWHfCawu/UsHn7WT09KhZIpzG1FOSKTBlNfGBXdl97gWutcEU5t8vbEcXxQTcUZrknnudv5zGtKhuO1ryjdcJaVxOpTrTmcn+0EcpJU1l0UO0BVWAjyHMmGl9tPoAjl51phVdHUn2ExSAt9O6bF2zq90Td4ZUlALizpGN+0qzJNDXDa9RBtSIXo5QB8+zymlMsaKPk3bov9ggonDQsDbAIk8tBFK3DyeQ8bMeu4/JEaZj5qcovpIVcK3rYBOfcbA26LsZOeQ==
Received: from BL4PR12MB9478.namprd12.prod.outlook.com (2603:10b6:208:58e::9)
 by CH2PR12MB4152.namprd12.prod.outlook.com (2603:10b6:610:a7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9700.11; Tue, 10 Mar
 2026 19:07:09 +0000
Received: from BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1]) by BL4PR12MB9478.namprd12.prod.outlook.com
 ([fe80::4d08:451e:a51e:33a1%6]) with mapi id 15.20.9700.010; Tue, 10 Mar 2026
 19:07:09 +0000
From: Zi Yan <ziy@nvidia.com>
To: Sayali Patil <sayalip@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
 David Hildenbrand <david@redhat.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Muhammad Usama Anjum <usama.anjum@collabora.com>, Liam.Howlett@oracle.com
Subject: Re: [PATCH 08/13] selftests/mm: ensure destination is hugetlb-backed
 in hugepage-mremap
Date: Tue, 10 Mar 2026 15:07:04 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <71CC3158-F540-4A12-AC14-10655E50B2DF@nvidia.com>
In-Reply-To: <2c8858154273159f964236810c7304dec665b28b.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
 <2c8858154273159f964236810c7304dec665b28b.1773134177.git.sayalip@linux.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0137.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::22) To BL4PR12MB9478.namprd12.prod.outlook.com
 (2603:10b6:208:58e::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR12MB9478:EE_|CH2PR12MB4152:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c2156e4-0477-4c46-61d8-08de7ed83abe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7142099003|18002099003|22082099003|56012099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	r1QnTTYB2i49+tX4xRRwAtqGCz4bY7E27F4CDiDZrRIb/B9bDIknMY8B0lZmwueGC4WMt73N2/DN1CA4mLEBQlUbcIrekU4feqPxQoFDdLlNHt5EDKWpcLmEL59G3EBE/6rLyW9pT0aYGt7kdmYWDf73O9Db14rpZB3xZu6EYALHk9a5u1cb0WBGDcQFeYoLFhSX9z2WyvKHhWliGhK8solQPMHEeRV42owdasJvHhyVcFz0M7NLttpS6dwDfrChary/RY/cSSepVRxeJ55bANS8kuhr/Xuqdo6nzQNL2vZmTuWeHGcrDmrW4J0T3WSkN8Y51M7FJOp42k4shy7rC1+WuvCHI8ypu551CnJ+SEOAE4M5k+J97XhWwzS2OcBdiiL82+ZnvlERFBm4pnCXqk+DPactl8j0hwpPZ8Hg0FV1fBg84wjXaDDvjfRQvnlrxJZZyb2zWeZC0R3Dlddc8JNGAiZ2cEyWLWyXbTpi0va4+BrEfn4GvcPvLejLMRq3dIH1tTGDtXZfPcaPPb+nLMgL+m8u+0sAS55NKjLQfaEclVMLx2Dp1+G+MCYliGw/SZl5vg/IxJttoFMM9n7kRKfcZSt+LfXDUD0DlahGDA0k2uoXUSij4PJ5Pmzsd9m37+lHAVVMs5Rwj2IL1/S1wgnPqvIcfui7qZlZ1hd3+H9r6Ko2QzSQ9lJsl1fVEfvIwib2XQgvECj9qfI5c77YY3KY7OBOCWi0RtCr7i9KeIY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR12MB9478.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7142099003)(18002099003)(22082099003)(56012099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OrgT+nARjUgVwpmG+OTPVVBzDRETwMVdTnSO77przmm2PgSBpzGXCgU+Mo6B?=
 =?us-ascii?Q?L07vkjSvbbCMxjefHf83NqPFQSZr7mYuP0y/EE+ADDcRyVJws5yFmCjfrksf?=
 =?us-ascii?Q?qrUdsw/NzTOOkXtQGfE7nsUbEh2SFNRUdjZz2hTZ9sfMZmNDGzQBtvX5SBn7?=
 =?us-ascii?Q?NG7FD2ehMWxWz5SVN7fq0F6i0rSkSfUOolSAwVKhJ9s7YQ98o4UggL++PJrQ?=
 =?us-ascii?Q?WGwo5LNkCT57sTGPdQoz20xZkn2WKz/Wp9k6YjNDj52BbiobZUZN5dSbiWGc?=
 =?us-ascii?Q?EN9oYcnLtD+W2DoWyWJbhNivWVsgpEYljNjnAp4/21lUUECewCsnp1S6tRw9?=
 =?us-ascii?Q?ceJ8B8MbUvSxyeThF9UvBQKk0bt77xIo8ihL5M0ltHUwbnHDQRCmrqknpMpm?=
 =?us-ascii?Q?4lqR1qKIkPYWNQZ9+EVZP8XDiVZzXc90UJI1Z/1S5OeCYq+kLLXJRasLajth?=
 =?us-ascii?Q?CcbeL8wxaQR5BN7ZT0HZP3VUrmXLAN09cKTgnwrNLJ/xzRzjqexEGrHDr9wO?=
 =?us-ascii?Q?OWbxG0m/jAeQyueb8gXC7E8I5RwjtIiua3JczgPe7xgFlKpU/nsso3k2NYdX?=
 =?us-ascii?Q?WDmh0rqvxt/lePki3tRFLrbefaADfY1ImTbmbnMrRPl4gWVUOciUhGSpGAjQ?=
 =?us-ascii?Q?4YHSpUAkUb0bltKFu0Zq4QquMQYRYR9rG7tFUMo3fY+969mvns18uYwyVT7h?=
 =?us-ascii?Q?eYa7rR3iX04VvyjDMB74gHlYbvTpmKly0a3yYXRlDp2wBqV0YVEY6Y5KtNuB?=
 =?us-ascii?Q?jrsUDcZe+AAWExFx0Kp0KTz9Sa6J28eDbiI0amOGTc2xcSVVKjQpbv2dc5qM?=
 =?us-ascii?Q?aWloGvSRrTxAjRT3E5gBD/fKOcjikqThmnLqYs7ihwLA9SNfreNh+cmNYrhl?=
 =?us-ascii?Q?b3AgrUFU3RF+4xuSFI0txDYv8s2ju7ZjZdpOAgclBMWzTrG58MPB+sqJ/j9E?=
 =?us-ascii?Q?jLjXAbNcKukhBY2hOrszV33jsR4gIgtsvJTbzmcGQLLjp2pSEYg/kIAsVsGE?=
 =?us-ascii?Q?/+izCFZhnEeZO7Gb3KG/612duER1F+WZaoFnxW3+8QTZkWuixjQCEaQ+OwDO?=
 =?us-ascii?Q?fscMKa4s/Y1R0nHg0khkpFuy87JcydvwDaF2aI+dvi4U+vSJEsHmyKQ4sdfx?=
 =?us-ascii?Q?tTCjzBhlD09Ee8hQ3VqjaqhfLc7Huzk2O3Y8teAXBULDwIkscEU8LAcLvHYK?=
 =?us-ascii?Q?lMLRGLDoyOSwpdyb8z60qZxEpAi7xYUf7XFw93r3FxqRpJm31zYzbF6bJnhg?=
 =?us-ascii?Q?wnKD28Y3rLRfj7LBc5FZrxXXHvQLM2IG03uy0jGRwS1RwHFUUrqZVwTAojxl?=
 =?us-ascii?Q?JtsUzgFwZkIurrn48IP4w7yYaK5zGOlef3pytCneUPADmAV30jcrH2x6Onur?=
 =?us-ascii?Q?fLYd1Rc/3oEKZdYOpv7PuFAOi2oAlimDwnQxYektF4WeOTVj3iADrRbQLv6A?=
 =?us-ascii?Q?gxlE9fw1Wy0oUXkivCJR54SpXWsoM87lSXqibCc4fVQqeMYN5WTprfUfxhVq?=
 =?us-ascii?Q?DuzszCC287YhT1kqt1Y/O/rc9qIwtScx5+ousYitKgpuNHWQifqKQhi4FCun?=
 =?us-ascii?Q?tLJOJThFXhfAKxzE4rQ8JRCn4G46VdDQtVx1Rgg+zgCuWB5c3yR+DH+si9p6?=
 =?us-ascii?Q?Gy6PVoCAxnTZz0fai+kMCwIyWQ3cOXOAFBvYPsX6zERqACxvdkpVY4sdY7cf?=
 =?us-ascii?Q?BFXaqIv+vKrVtzCDz56a9KwcnY/PeuZho5SVgrpn3Yd00fUkQTeC5FDSP8h1?=
 =?us-ascii?Q?PAysbetIFQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c2156e4-0477-4c46-61d8-08de7ed83abe
X-MS-Exchange-CrossTenant-AuthSource: BL4PR12MB9478.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2026 19:07:09.7736
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YAZaV7iaFO66e/MjEO+bupw3fz/4GgIDBodbHgH0/NJy6aJAvfg1qyq/DIHs8nyh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4152
X-Stat-Signature: pd3mk8bgkojzorir3kxn4t81uwbxh68h
X-Rspam-User: 
X-Rspamd-Queue-Id: 6338CC0003
X-Rspamd-Server: rspam12
X-HE-Tag: 1773169635-744972
X-HE-Meta: U2FsdGVkX1+pE0RriH8UB9Y/oroX63ndRsoYkEJkpavA7ovY5gz752725rc5BySZruxGJD+oDBFpgHKooQVTV1zmGRvH2qmp/TYPTVpntoN7qjeCuBQSWCoxDRGrEwX9CPWhyMpVR82DJlo6Ty8nxaV7LWgN/TAlGq/N3jJy+E6bkv/kYBJP3555sRSfvA6Ab2jTvTRo2gLeo15wH9DAi5biMgSFon/x2VWuNtpa9IKzUll4cnaZHXJgo0P/NRrOMKdlJlR8vmC+tF7k2FOR+IE+kEm4cFOaRNEAOeGOUe0jr5MpFy5AyTVcEVifvbt4Hct2XPgbUkvCn3aBi0l9wmIOpVD/MzBe4wv3QMYbrNwDXOZnT9YFVVBfyaoKr8W8pFEiCXvtIqQZqkTBO2je2pNHPkCSAmcLhLfslys3nS5huexpPCeqKVTXh/YeigknemJfKd4tPuki5npF5K+wd4H7crVQt7/fpYz7RbbhyEV256twwBEWGuJZgUOx/KzqJeG/Q65TACvSlGyDPxPILMJ+80QqvVb6C8y7tc9OzQn56gKjp4HLzGfjnFD589mxq6PmmJ0pZOAcShEAmv0U1I0czhc1hq9g0z30PgdZ2CWJP/n5WPwP43p3egD7BodWWJsZ6kvCkFk+gxTx6ckx4OUAprRynTTltRp4tD4qN3oAduJpoB+2uh11csxEQY6jUHa1nFlf4u7txvunDF898tG/NSgcPbPEVX7Hc96li3E7SEtqMVHd7W4xl+a9HDELeBQwfuHWx7ktLY+u5ofY/pKEiT8qMYUFgpUKMlauXn6FYQRmPq5NK5NCMc9smm8k59l0RChszhDeWzWLF5Oax+vB6HNiXLHCtsUW10X8rJ9QTI0nAOciN4gyCyi8Ehho5oKnBmgnNgK7VgKFuz2tZgfQ/s+ximB5Zy0C/XFGX71kdT7J/eC5NQWUHkkX/+Rj4u2EACfOJ3hc/pMdDQr
 gdQbDy3Y
 cmXmo8j8Gb3pEKJC3qyXupRpNceBiPAbq48kilMuvgHSCMU9QADM0Y/TRPxXwC3b89DSUjVLaz/QVDl/ddorW5fkW0cBCzUfmYBtZdiuy+xbLJ0kxVxm4hHMmeBIcd+RyV6l+smz857UXt3dX2H8uf/x/NrMJiazGvmXsgbGH7pLmSr5nUpkX11C39gwiYRmXqrq+absFYkK02sNaHzCmcZhPLGQ+HYHnk2am09mi0XBIi5PaNaa8ATyQV5jr1TbYjthvbFMobD/u2OAQpykat4wfWdq9fMLCMhedsdIM4s4A9jJXEJ4D++RHJei9u488LE339KK41ChThioEoBBVirN6sq5ytQuMUqPz7iaW32s31b1iu4bje5QnckUUBDFyewCiKY7Uap50OZlzI1rk4JFPePryeKxO5zhBQCrA0CmplZAePpjUy00oFeZU6S17gqcHLARPytFt1fq0alv02b7KFhEntcmbW4YY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10 Mar 2026, at 5:49, Sayali Patil wrote:

> The hugepage-mremap selftest reserves the destination address using a
> anonymous base-page mapping before calling mremap() with MREMAP_FIXED,
> while the source region is hugetlb-backed.
>
> When remapping a hugetlb mapping into a base-page VMA may fail with:
>
>     mremap: Device or resource busy
>
> This is observed on powerpc hash MMU systems where slice constraints
> and page size incompatibilities prevent the remap.
>
> Ensure the destination region is created using MAP_HUGETLB so that both=

> source and destination VMAs are hugetlb-backed and compatible. Also add=

> MAP_POPULATE to the destination mapping to prefault hugepages,
> matching the behaviour used for other hugetlb mappiing in the test and
> ensuring deterministic behaviour.
>
> This ensures the test reliably exercises hugetlb mremap instead of
> failing due to VMA type mismatch.
>
> Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
> ---
>  tools/testing/selftests/mm/hugepage-mremap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testi=
ng/selftests/mm/hugepage-mremap.c
> index e611249080d6..9558515c282d 100644
> --- a/tools/testing/selftests/mm/hugepage-mremap.c
> +++ b/tools/testing/selftests/mm/hugepage-mremap.c
> @@ -136,8 +136,8 @@ int main(int argc, char *argv[])
>  		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
>
>  	suggested_addr =3D 0x7faa40000000;
> -	void *vaddr =3D
> -		mmap((void *)suggested_addr, length, PROTECTION, FLAGS, -1, 0);
> +	void *vaddr =3D mmap((void *)suggested_addr, length, PROTECTION,
> +			MAP_HUGETLB | MAP_SHARED | MAP_POPULATE, fd, 0);

FLAGS is only used here, why not change the definition of FLAGS
or remove FLAGS along with your change?

Feel free to add

Acked-by: Zi Yan <ziy@nvidia.com>

after you do either above.

Best Regards,
Yan, Zi

