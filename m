Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96EF6CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 18:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C731C8E0002; Thu,  2 Oct 2025 14:46:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24118E0001; Thu,  2 Oct 2025 14:46:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEBFC8E0002; Thu,  2 Oct 2025 14:46:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5EB8E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 14:46:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0678A87A27
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:46:02 +0000 (UTC)
X-FDA: 83954053764.16.343E22F
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010047.outbound.protection.outlook.com [52.101.56.47])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2A80410000F
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 18:45:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LYPoIMse;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759430759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0QJmOveXlefynevJ/1Ua6bmJLHJRlcLREhFYGZQ7Jo=;
	b=UTDXnpdDLOK7bSX5gJ0Fx0YpPgXMtT/Mbj4+KPCzY68xKBox5QRGxG3e9GrB727JhEUWan
	mBHKI6v7cm2NY9FMU7Q2JO2lX1sO/V6b6m2LwvvpcB4M17z7dRYCQGD5ALU/5or9LDAgnG
	MdR2DcCB9owCdUWFGmt3reA/e/5wTAw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1759430759; a=rsa-sha256;
	cv=pass;
	b=fnXZWN/j/ALPA4x66MjAWAcUc7pKpW4V+Ss0xC8+3H1ZyVS0Lm1gSaW0iEtnEMwNda/wWS
	yWsztuf12t/JmeUYuiYYM3iikTvfk0TY7DCwuFogcZMZGBgEhirYhYbwpAy6ngajrTEfwP
	hkVqIkH8Qe7dhlBUEAiLKCh9M/+aWpg=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LYPoIMse;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf14.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SD+O+sBUP51g7LGpWN6EDbUnkdQC7y+P7rJad7/LE6/xyZEzGErP0662i/mJp05sHcSS5y169r+z7dVG+ShOFepcJ483cGkzuZ/x7J6M33ZKVzfdkq+Z+ss5h7IHlqdrmClNDqVRFJRx5BH+vO8rOwEQ86gbHCH6qXmcgUrdo9MtrYyEGFZSXWnzQOCIWp1APafXdPZpdCcBEPEtF5qrD7sX0ahUbtJM36h0x5on29I0EIifW6eNmbA/k/8JzHboZoTbhVwFICoogVe8W9U/78c1R29gLmybgjkyVcDo3gpHa4fdQ3f+u9XM0qNaJ7qY+4QBHUoqlbxGfUkvH2qxAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0QJmOveXlefynevJ/1Ua6bmJLHJRlcLREhFYGZQ7Jo=;
 b=UAbPUZbTzTqWx8a03GJ8fyRFNqFhvHfcHlGwLPaYw9TTsBUIlyRJDLFz6G5EBo894jaSKgn3jde29IvgLn/Rv5Gngrh9dW/EqBaoVCTlGqAIVvov0uNxDfu56gYhKTzUFX+P653/ZWx+q+GCWJmSK9yajJ3yQa2OF5H4cjQuMVFRF6udb+rk4C5QJh/SxtFb5GNusFimG8kqv5yhkZfIhzlNOD8Tw1gyJfUCxgo0doi9FNGMOOXQERylG0Ary6WlAsmUtJ6PHw6YCZiFA0h1ZUsamraVXsK7Xmwx2udngr89+swiC3/7I9FLGZ/Ynf7lGNZWUf/vhdQrKZO5Kr/wcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0QJmOveXlefynevJ/1Ua6bmJLHJRlcLREhFYGZQ7Jo=;
 b=LYPoIMsesLqfbYCfUMOCuijtCKLC0hWNy3kKnq5Pa3akDLljgkN5e16oAW/Zf77Jp0mgsLVfBqwNBLP9FRjV1u3NS4kncNfkedlzHT1a6yvQoIwbz/til65cvUtGkf/hdqjcFRW+KIZnVTwZFVn3rkYCuIySfefEtoTklBA/6lR/bRd8YAHdqmczf8wIk0jl+mAVS3PDeKJ6o1ob4SrbJtz50HLLkUf2iKLyhYR8bZ9lk/7e63IOwUcaniow73Tpi/RAwBqYRSugs0HDRr8iv2szN3um80C5dMagxq7wB8l1uiZjybvOfGr2/QLvsbq1tjlzm/IQEmp1jpOt1xRPmQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB7771.namprd12.prod.outlook.com (2603:10b6:8:138::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.18; Thu, 2 Oct 2025 18:45:49 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9160.017; Thu, 2 Oct 2025
 18:45:49 +0000
From: Zi Yan <ziy@nvidia.com>
To: jane.chu@oracle.com
Cc: syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
 syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org, david@redhat.com,
 kernel@pankajraghav.com, linmiaohe@huawei.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mcgrof@kernel.org, nao.horiguchi@gmail.com
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
Date: Thu, 02 Oct 2025 14:45:44 -0400
X-Mailer: MailMate (2.0r6283)
Message-ID: <32A2C338-EFCC-470A-B5ED-E53C38395E51@nvidia.com>
In-Reply-To: <d60770df-a967-498f-9e0e-25a6a145ff55@oracle.com>
References: <68dcb33a.a00a0220.102ee.0053.GAE@google.com>
 <2afee6bb-b2f0-4a86-ba8c-d33b0b477473@oracle.com>
 <637BC0B5-B911-4A79-8107-BD7CDB351660@nvidia.com>
 <A4321695-9F12-4C7C-ACC9-72FD84B6DB2C@nvidia.com>
 <57d9aa32-2fc8-48d2-b68b-3308c7d58125@oracle.com>
 <CD6D8EBD-F139-41BC-9A59-5033EF5A09BC@nvidia.com>
 <d60770df-a967-498f-9e0e-25a6a145ff55@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR07CA0065.namprd07.prod.outlook.com
 (2603:10b6:a03:60::42) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB7771:EE_
X-MS-Office365-Filtering-Correlation-Id: 8342f441-94ea-4f8c-38be-08de01e3e78d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|13003099007|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LXTxO5FoecjPEqY/mKAwxCitLTSg0IGmJcVK7l50N8P/2wM1ybv5fKPQvrcf?=
 =?us-ascii?Q?qw1KH2bDiYSwW3yWvYvLDhax8cXIQvNXnmP396cV+5UxSRjJJV/5tYMbdFoz?=
 =?us-ascii?Q?F7OiChy1VVewa6DBU5HAQiPTcIFRNkiQQWjcQqBfQjpU6KmvOcX5lqgfBn5C?=
 =?us-ascii?Q?OnoeuiK8B8Hw+nZfDL0xKjANstQ5f/IEwS2BLuyMoa6jcBM+B5rUFECfVbGS?=
 =?us-ascii?Q?0hgryhs53Lu1XvdKSQnPHLWE1QY7zaVGsT9u0miN58Y58Kx/0ZSBaA8nwXsm?=
 =?us-ascii?Q?Ho8eMEPCXSWMx6EQMfkzah0h3KJJXHwoJtgjoM1ZDLkfc3hEicxVxyeqhmZR?=
 =?us-ascii?Q?aDbDmTSZqKNYPnbWgsQZGpAOhWJEb/XqjOYHOU1IfyD6wHJWAABy3bGw1GTZ?=
 =?us-ascii?Q?mdOfhSv01B0CNOnDZrt6SkKdNMjBLPaFs7V8DUh4XND+wH4nN4n1Mn2prY9b?=
 =?us-ascii?Q?WqzSukQJ5iArB0j+u/XjzwaG1aYQCHjZEAXOslHH99iGk7V69L4aBrWan6vB?=
 =?us-ascii?Q?+Uh2oxBId4HSd405PFWDvRc6CDDCljDOH9cKWf6aadaJEd909QcnN5pmMiKq?=
 =?us-ascii?Q?4+XtW1GKPZ8U6eFdQ4jpiqixUr4v9DCA5uzyuQJDouBYI9lGqKJrCQc2hZrq?=
 =?us-ascii?Q?MaGKLRQ+6TBlfCngyTzXRLzRAB1nlkbjyJ4frroMoMOiVa+hIzXrsZHkG4Dk?=
 =?us-ascii?Q?qFu7iL8zCR2kzsFKxcGQ2YRvl9KiwRPjucGdMK/QGiRDvqNV/bzEe8S6Qlpc?=
 =?us-ascii?Q?3Qy3yCaHbUbG9xREYUqHJmuvUvu054BkuJdhRQ5dg+KF2BfBRXHxdxDKZD5T?=
 =?us-ascii?Q?ROvWS7Gqo2A45vs2bCt6giRjUjwLWXqDHt7CZXxglpXmy1xidC4VVXKAk+oe?=
 =?us-ascii?Q?68ZJKjWIbMT+1sjHhTPUuK41qJyrXS5NLdQLIc/yIhJ4aTHkvZNILpV4A+qs?=
 =?us-ascii?Q?ZdLwHRAogG2oT7gOKlwy9sCDZt2/G61pkEtNuYK0yoVqnl1RF3chWWvmn6zF?=
 =?us-ascii?Q?Rxsc6R8idYCUS/Aa5mTiFTMxETBrksOaY4ZsjjJNSRLZXOOJ5EoZHV+30TSp?=
 =?us-ascii?Q?6Nl64e+oMkrywLLMaAPeOeeWTbSQvxFAQFIbGcjsqMB33Cx3fQo8SDBl2DWg?=
 =?us-ascii?Q?WEIOkAhX1r4iG8NQeMlW7mRgW3OdD24vWD8dHiONUYszsV7SS8bFxlg0l4xu?=
 =?us-ascii?Q?9x2bNGCYiJ0ROQX6DXDYMXSqCWCKQLf2WU3z+bNmW6CELA0JsZ+V7QPSc1iK?=
 =?us-ascii?Q?fvEP9o5PB4LnLcI64v64vqpyD3XkoBOa+uAc3hIxguyQCtTFygJYS2t9oC/9?=
 =?us-ascii?Q?urIXL4q9bd4Tjc/2lHctH67wvkmPfsSL0KllQHa4Y6jujJjCSHBBhHIlmP/a?=
 =?us-ascii?Q?vbKJ1bixjbLuEwfgLm4xJidRKTv4o0B2BXudkWzJKBTkJ3/Uc0YIEm4HVCim?=
 =?us-ascii?Q?6xOvxUoNC+FIb+nXMFLVrwg0vhCGegZH7sOKYZIc4Jt2HcvWFK3KgA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(13003099007)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3UWmK6pYbWsOiGr1Zn1IukHjYeI5x9vK/vNU2uH6K0JM0OKICfxAkXkSEQdR?=
 =?us-ascii?Q?g8uL2SAXgdPfHuUC4MhA4NYVb4QHrV4bD0Pr1vyRAtyX2+IGRXLAeQ2zCXam?=
 =?us-ascii?Q?qt8vvkNdp/mOF2M4cpOx8+AcUOsYhB69QGf2Cbb3CWfITJe359PVLWb9x1vT?=
 =?us-ascii?Q?zu+AWFHYZ39M6nYzrpMfE49h8/b+9Y+BT8yJvvww4bc6gn1816oDtNeZYlRK?=
 =?us-ascii?Q?G+K4yKeovYrDxs3oBoATAkL2WEyT/4I4VXPGNb9sndS68YIMUQDfASfdzp6r?=
 =?us-ascii?Q?3i/CR1TwwXVQI8B1JgWxUw5r1o3uPtMw0W5/tP3f9H+TdM1xKCr8Jf+mReYD?=
 =?us-ascii?Q?5EI0FZHUkd7ITTUBXsfgbnC+Vy4fgC5vTlov02UL1elxsxu5Vw+CjOox7AgW?=
 =?us-ascii?Q?b6eAHGJkc/5tcxhTKU655vccxBgFtVI1OlwkCglhcAq7/MkyrFFyCMI+6kx4?=
 =?us-ascii?Q?+uRsITCeNM8AIt2MVKgwZ4L0DyH091Xw1owIjKFDsTtDKQho7bLkGEtFnN4g?=
 =?us-ascii?Q?qrAATL7S0GTOM8HGscnuPmkgn3DS97wyUSAOSJ7zFI6z/mNkF9t8Jf6wDV12?=
 =?us-ascii?Q?8USzQqFvD/D5Bfkf/JrlxzeVDLwNVQ161rPlLqfjOPGcJJ0CMSEGo1f1w6fd?=
 =?us-ascii?Q?CayhDp1zav9myVw+lzKNVbHmqJti36KuVSsnxstuiBaXox/H8VUWr/xsnK8Z?=
 =?us-ascii?Q?Q/UIyz2/r8O8ciCjbVtuZkVNyKroLAbVVOh3whiZlyaDfP/LH3XKV3mP+B4p?=
 =?us-ascii?Q?4JA7BvKL8B1f7GF9DqDo+x1qR2f7XEn5qTPDq4z5GTD+d6DE19I2xiNVibAw?=
 =?us-ascii?Q?6uim4aMML1zNFyG7f93HXtU1257aaEsQneaWwpb845uJt5LL4Cf4wg7Bs8jI?=
 =?us-ascii?Q?st0YJ9pwv6TokuSDTOqS0xjxdI6HRamP6GO1ar8KVBNcG97QAwvv6sdysCwW?=
 =?us-ascii?Q?tWj4CuJR+v9tszkYIXTWqGM18hVVUmB6VI4GEW3L1AAnJwxaidy+++v0OP2P?=
 =?us-ascii?Q?J2mxJA2jg1VpXj9wA+Fr+1Og9LNGaM7950XF6zMeEYlQKccgO4m9J7X2TvZI?=
 =?us-ascii?Q?TVLk0rWNFf//tqcCuyz6ATdn/02LFI2A2FjnB8wUQ0at04WEcYJUjloe4//o?=
 =?us-ascii?Q?twSRRskiv+lAcVJaM6GM/YNUMLHN/aRFEZrZ3a/AccIdrqdhFqAV9a8L2o0T?=
 =?us-ascii?Q?DzTzkPZ0cVF1SZG42aShpc/zddh1EDMfAsjZ0WyJjpWrST/Y+FdqU92j9tL4?=
 =?us-ascii?Q?YjaraxSgoZUSKAwaiWMXrGoQXSpRJ3gCG94fZi1GnckUyONOsfv9bebUQ5BH?=
 =?us-ascii?Q?9F3aAaz/+S9gk47fFdbr+57NrYOAaSphQS74b3G2vcehd9wsfbHVGDPaE+GR?=
 =?us-ascii?Q?brpyRc1SEYSQ2gVOAbLJzg3tix7Q8tGwUapXjsmyccWWpz3IvzC+kzETOE96?=
 =?us-ascii?Q?onoXlvKgBpf4HhYMXftRirLUEUt2PLO8T4KbpYr01Lp99hwsmPoiE5x81pt0?=
 =?us-ascii?Q?w7VURWj6q0cnslD2aarVMOVJHC6meGX1baibH7vPTzctfyhW4sqZG8nofSma?=
 =?us-ascii?Q?OpALYtKTG9qWDT7cjx8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8342f441-94ea-4f8c-38be-08de01e3e78d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2025 18:45:48.9343
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZXRsA+zUkJOjnTwkjgU3jNjX9F/rprhYPPIrUGNg9mexuCcDm4erg4xgI+9RM0+l
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7771
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A80410000F
X-Stat-Signature: 5xsag5hu9txmpifptc7fcc6ouhgc6i4p
X-Rspam-User: 
X-HE-Tag: 1759430758-912141
X-HE-Meta: U2FsdGVkX18k0qjICA/IIYwrx/qbTWJAv7GRdiPGHsU4t9QVbGUAzbpibo7KfzwJi/q07DnYJm8GL4LeZZuDSBLwlSho2SHG4cUpkZox3PsrZ3O/KTXxtsKz7tv17ZOqjFOXj5TLMoZQ/1Bqtvwvv1HtNUS+0mTIp6rWECFlkS2Mv3fVT3iiB3kPq02zOM+S4ozsDVmbgB3NwAY2oCo2e40/R8Hi8oJHBH1Mxglg5YaZ2O2/DQceuHUvyJDy6sH7gzDuKIzq5jpaklz2GLhoS6m+j1nCc6+EGY7kw0iBmyoKH65f4j1e61JtFmCypl2lCbsl3AjvYp1mn4MrcCe/49ZzcR4nQZqHdSW5EhWGx2dHUDERwT+M7wtQFQFviR0SeDeZx60vmKhqXMelMfYajHn7rO8aWo57k/DHZWei6DOXCEMrD8uPJ0ylap+pc1eK1cH8KNsTLmY5lqIvmGc4xpfi8RaEQ8y7r/n5MuImM9Hln5zgkuDN9ldoLTN5w3PyPy2RwvSQLxXISVk1Rs4d3eXsei9SfYu6EQRBUPJ51iiHPgmF6H8KRaInUsYGvWDYHNL4/2eCnOqjM9foy+cKiUxi4mH0kjTUfbhReYWMvOvR1d7waFe20F0aY8l83KWCHft7UdIrpiVHu8lPCsJIw8adSqYlelRXiB7Uj2bYA1gOiEhkwNkExmFbhZN3YHgCsR2ipuYx3goNVaghFUu6eH58qCC/s8htPjKhmblaiFLfLPJTEn1WmosNxVF62WNZbEtJsnJp94GBHGxZLn5AFjyJCtlP8PP1CfPSOKrzXz8yYI9H2/o3cH7FxxgTi7pHIdHmkFhWlR6HvKT2C0kTvl9ppEuoJeK6vH8AG7jgoZl+RfU8iPwnxWROa7jTJk0QQ3bTfzTEIaIa65RTF0zE5Ms7kN2220IKdsD5/c9ADagN3MaXQBFS+Nif2okCo9DKyhtxFQdbrqgGLuWwjt1
 5ijE12b2
 sF9+mLItPEIkn5Cfv0jJ8BPjrL5/vhWyfQRwOGKkHxoMF6kyk36ZDHBjPaGMRKaavLkU5X0MGT6/zA2T8bGLsyR/79z8jYE/dZchjHSnXxILYgaXRdFKXVC3Rmc5V2LUB9qSnOtf43PF3kME1CRtvcco6J+3AD2s+JZRtitUzAEHkLvA27wVmpCjO6GVQBqzkOBWkEFmYcLNkb8qPZgfsjbCFz8pPYIcpm76Zkz5u1vhmqOZFneofjPWUlzytZCL9AnkoVVSH8nKVtPWDK3ShtK8QkKau6MmsiWJn4zXEf0s433AfiJ3RM1APliWEPCmGe7091zJ9BNCIHo69UHHuYGLpndx//wiurY8IDRbhCdkltl8xfazaGNyzmsgHL/8S7oQ88nTVvm6VMdPtIUyT3H7c33gomBVQVju32p1txiJsuskMEr7gTEsZ6igQ7W62x1NNnAVi4aVSpbeqxjNnxTSEnby4KD4S3ZMZIzA+f85zv1Bg3Z51vbhrgDEq/FtShKggehV/BuaLtWroi5mENSuDs3eMYoibJG2WG7G1k4v/Ar2U0zaykmPtu3089GWP/yn4plEGRFYZYG1ySK81o+vhOHyEmi861Q+hh03GqMTO9hEvxNZlTsfQq4L+0LUGJw3EqR4fmVhRsLvljfgchjltTa83AALHOiDZpkiPVTcU+vQ4brg6PgXi/+n5IhVtIY+fYLnTORNnRkNh+SNh6E98nYoIcSajemKkGkJzAEv3+OCB2kuarVImCWWyAjOHXZOFXtz/zaltBTaXsjgvTIVm2bbBOpKIKnI5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Oct 2025, at 13:54, jane.chu@oracle.com wrote:

> On 10/2/2025 6:54 AM, Zi Yan wrote:
>> On 2 Oct 2025, at 1:23, jane.chu@oracle.com wrote:
>>
>>> On 10/1/2025 7:04 PM, Zi Yan wrote:
>>>> On 1 Oct 2025, at 20:38, Zi Yan wrote:
>>>>
>>>>> On 1 Oct 2025, at 19:58, jane.chu@oracle.com wrote:
>>>>>
>>>>>> Hi, Zi Yan,
>>>>>>
>>>>>> On 9/30/2025 9:51 PM, syzbot wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> syzbot has tested the proposed patch but the reproducer is still =
triggering an issue:
>>>>>>> lost connection to test machine
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Tested on:
>>>>>>>
>>>>>>> commit:         d8795075 mm/huge_memory: do not change split_huge=
_page..
>>>>>>> git tree:       https://github.com/x-y-z/linux-dev.git fix_split_=
page_min_order-for-kernelci
>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17ce9=
6e2580000
>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D714d4=
5b6135c308e
>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=3De6367ea=
2fdab6ed46056
>>>>>>> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9=
f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>>>> userspace arch: arm64
>>>>>>>
>>>>>>> Note: no patches were applied.
>>>>>>>
>>>>>>
>>>>>
>>>>> Thank you for looking into this.
>>>>>
>>>>>> My hunch is that
>>>>>> https://github.com/x-y-z/linux-dev.git fix_split_page_min_order-fo=
r-kernelci
>>>>>> alone is not enough.  Perhaps on ARM64, the page cache pages of /d=
ev/nullb0 in
>>>>> Yes, it only has the first patch, which fails a split if it cannot =
be
>>>>> split to the intended order (order-0 in this case).
>>>>>
>>>>>
>>>>>> the test case are probably with min_order > 0, therefore THP split=
 fails, as the console message show:
>>>>>> [  200.378989][T18221] Memory failure: 0x124d30: recovery action f=
or unsplit thp: Failed
>>>>>>
>>>>>> With lots of poisoned THP pages stuck in the page cache, OOM could=
 trigger too soon.
>>>>>
>>>>> That is my understanding too. Thanks for the confirmation.
>>>>>
>>>>>>
>>>>>> I think it's worth to try add the additional changes I suggested e=
arlier -
>>>>>> https://lore.kernel.org/lkml/7577871f-06be-492d-b6d7-8404d7a045e0@=
oracle.com/
>>>>>>
>>>>>> So that in the madvise HWPOISON cases, large huge pages are splitt=
ed to smaller huge pages, and most of them remain usable in the page cach=
e.
>>>>>
>>>>> Yep, I am going to incorporate your suggestion as the second patch =
and make
>>>>> syzbot check it again.
>>>>
>>>>
>>>> #syz test: https://github.com/x-y-z/linux-dev.git fix_split_page_min=
_order_and_opt_memory_failure-for-kernelci
>>>>
>>>
>>> There is a bug here,
>>>
>>> 		if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>> 			res =3D -EHWPOISON;
>>> 			kill_procs_now(p, pfn, flags, folio);  <---
>>>
>>> If try_to_split_thp_page() succeeded on min_order, 'folio' should be =
retaken:  folio =3D page_folio(page) before moving on to kill_procs_now()=
=2E
>>
>> Thank you for pointing it out. Let me fix it and let syzbot test it ag=
ain.
>
> Forgot to ask, even with your current patch, after splitting at min_ord=
er, the old 'folio' should be at min_order as well, just not necessarily =
the one where the raw hwpoisoned sub-page resides, right?

Yes.

> If yes, then 1) I am wondering about the value of the min_order?  2) pe=
rhaps

I think min_order depends on the filesystem config. It can be like 2 (16K=
B) or 4 (64KB). Based on the reproducer[1], it seems that block size is s=
et to 64KB
(see ioctl$BLKBSZSET arg).

[1] https://syzkaller.appspot.com/text?tag=3DReproC&x=3D1361627c580000

> the syzbot test need to reduce the number of fork()'ing,
> as with each MADV_HWPOISON inject, one page cache page will be lost and=
 stuck in the page cache, the difference is the size of the page cache pa=
ge and the number of pages.

Right. the lost page size is amplified by min_order.

BTW, I do not see fork or loop in the above reproducer, I wonder why the =
test
went OOM.

Best Regards,
Yan, Zi

