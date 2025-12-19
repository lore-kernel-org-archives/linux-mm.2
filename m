Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A150E6688C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D13C6B00A0; Fri, 19 Dec 2025 15:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F6C6B00A4; Fri, 19 Dec 2025 15:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 853D76B00A5; Fri, 19 Dec 2025 15:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 706AF6B00A0
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:48:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 152051A0285
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:48:54 +0000 (UTC)
X-FDA: 84237409788.26.AD553E2
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010058.outbound.protection.outlook.com [52.101.56.58])
	by imf29.hostedemail.com (Postfix) with ESMTP id 44E44120006
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:48:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C1l2dtv9;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766177331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsqJCgPBBCr46dYQ8HF1ldSe0v5lHwF4+yd0r/www3M=;
	b=oq5OkkElh7Isgsx9Kx0g8ZE55LzDOQ29M6QUmSj83IDo7R+DtvimgPIapsO4ds0WPiLcw8
	3rtEDqSwwC3obEIZPKq5HTPyRjpWzt5JEQygWz6SPGeVoICb/Yj7jgKFuYqrvYGRNvd3WN
	UBsWZ1Uug6+1HR0Si4vIm69D5Z5PCz4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C1l2dtv9;
	spf=pass (imf29.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766177331; a=rsa-sha256;
	cv=pass;
	b=g3Bzkg1OVTAWcKp6FUWRqxi5ltJkmkAAITlMtAVETR7tatv8SzJTqTZhes743DeAIICa/P
	ByO1CtFiHifB/6tGtB/kKi+vXOv33nx2XRsvm7JG8SfbKx4cD50VZEFOwn16qS70Og/op+
	ezbHO7bEdJweSKJGA0T6Mdm4+x8wPVM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BmwzJOy5v6I/JT9/VdCD/xV8qj8LfcDw+S4zDQTmVmzLySxtxGjPF723TJN9bEl1uX6xiXSXj8C0hUolQ3PiZ42+ak3aj7qfql+IMqKCGb5tZXetENKZt0t/kutQ5QR2OXeuuZ9dFC7+5ut1W0NVr5hJacVipwthV4Jk5Cdnm6Q8DxvlR0VmHp4UwG7XdEFvg4MBv6hg5d5t7NMKKDVymC/dn53PjyHA19qtkcpYnjBhuvOFvzCMm9nK8teqsrhDvF0btjHDuGzl5nR1q30e8E3fNVqnqyzwm0digdeo5EhuzX8zLfB5LvZXrui7WbOir6h6hF/XrH1r4oLI2tpt6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MsqJCgPBBCr46dYQ8HF1ldSe0v5lHwF4+yd0r/www3M=;
 b=X60z227Pey9N7hIuKb5Txxcz8PDrbtIacJRM1I3Hr7jRdeDPWDQCvJWY0JpXV/3bUx7nfT4YXnnQqoFNFVQCtc9o+xBB5RM39iSySX49Q1oCmNIn5JB1DeHnoBgqqRepDfRIcpQn+bcYNbpibyRfgucDd7fW3NbaoZgqxaqlSEATf1r9GPQg1jTAUdL1ZB4VegQvKIXhvs3D/GHGwDMCq9K8DPzsBiyu67oyXjhNo/CC2kljNjaLlBmYGMeQEw3micH1umzobeoGLasVEewQl4Fbd4ejbH2O1cJC36pA8txErcVo1POEj8hDZxKFpGHj+T/O0s3WFbvTdZtAQb56mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MsqJCgPBBCr46dYQ8HF1ldSe0v5lHwF4+yd0r/www3M=;
 b=C1l2dtv9vDoIf6eY48h89hFcmC7mrBH1OU5HItUw5vQeUXChKBmcpZD3dsruZ1Fa0ZzO70YzCctxI9NYoWuZkKhUCUYBIu9qqrBsq8QvLHzNFmbKyo8RyPFk7elFPUUCNCb4LfgKyBIRBbrGDWjuL0FV/E4AQdw7mn69w92jXhcsZFjxwWB0SvFe8HR98dbkL9RSuj67IbsUkFkJSIHIew1GO8I+Hi3a27P2FVNJSy4DakQRfETIT0tJJ3lidA3M1uF9Y9AJzaCjG4+IgUCJNALR7IjyNxvNRzzJsVPwjQ4qplatP+Ewahb/pIzT3LZfu+kmScTWzmmFqmLp3d3tMw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6060.namprd12.prod.outlook.com (2603:10b6:930:2f::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6; Fri, 19 Dec 2025 20:48:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.009; Fri, 19 Dec 2025
 20:48:48 +0000
From: Zi Yan <ziy@nvidia.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 richard.weiyang@gmail.com, osalvador@suse.de, rientjes@google.com,
 david@redhat.com, joshua.hahnjy@gmail.com, fvdl@google.com
Subject: Re: [PATCH v6] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Date: Fri, 19 Dec 2025 15:48:45 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <1E3BF4A4-C8F5-4FB9-A658-9D40804CDAD6@nvidia.com>
In-Reply-To: <20251218233804.1395835-1-gourry@gourry.net>
References: <20251218233804.1395835-1-gourry@gourry.net>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: MN0PR04CA0003.namprd04.prod.outlook.com
 (2603:10b6:208:52d::15) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6060:EE_
X-MS-Office365-Filtering-Correlation-Id: cefec602-fe5a-4f45-0b6c-08de3f40021f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+X90Cq5Ozk73rlWOJ4zCMeNtNUoyoZaqfoRAwO65YkV5F4Q6csVveRiW+0mS?=
 =?us-ascii?Q?9cox4lxOFFR7DCTLfsC1JarxP4RhDDZyPj30a4LUmI26pz5YsgG5mSEtfH/L?=
 =?us-ascii?Q?aShkc2V1P7uqCRglgWdIaL9UqvxL9WP+FQdxvpaYo5SttJin8d3fA8UHYFi0?=
 =?us-ascii?Q?K4j0DlTBuwmehkJje9+v8/krw6Y2TEluIGwXV1vV5VNME+O7qZN46vsYMnRW?=
 =?us-ascii?Q?alA4gVLGGv3/y1vKQqg+UjsV7cOIbpP822J04kOoKs2SF9DBU4z1DoxveXXY?=
 =?us-ascii?Q?727zxSLS/9QUEjZKbSlTwkc7BIp1KiUEtHWF8w+jshWSJkco+ZOpRL/G6cXn?=
 =?us-ascii?Q?oClrToDJBgzoM0lzIVfLoqMxCtyevHiAwFaa0ksxWEyBWMnJ4DIHh6heMyKv?=
 =?us-ascii?Q?62SiAte0djp5GBGHepLFluE6tFCkTDHJ81wMrgvHfZWk+WOL5sZKh9tsN6Gf?=
 =?us-ascii?Q?KNzQIbuB+YUgLrmFWz9JZ1M35C47kb2nA7hnHBfXAf2FpdU1YXtsQPHi4H3l?=
 =?us-ascii?Q?P77U/z7i2/Zb7CoajvG1RPkRc0cRb85tJt9jO003XWwzfRSpNVBxID67sbN9?=
 =?us-ascii?Q?V2QFKGAGSMxnW25uT28Bt2Mtx7nxrE+rSckoAOR3NFcI0m0f5/+/TvV2oouk?=
 =?us-ascii?Q?2j09BPnSLihqXgwubus4ws2ZyywqsM+I1X4KRk/Mh7X30uStCjXdCNOM4MRH?=
 =?us-ascii?Q?Ffr3CZFEQWA7aN1CKgJQSvlSSI3nMTYcyuhKfoqGi0hAamaxD4GJgf6KbZhs?=
 =?us-ascii?Q?xpv8SITxoRdEqt81WeoY20cDbcADIRB7ERCegtMU/IQTCNy/UWqgnuO5DKQQ?=
 =?us-ascii?Q?lrXufsuxrIh9TxGW/G5uZJuK34b4yr3g9+3RU26S00025A5Q/K7C/gupccq9?=
 =?us-ascii?Q?jcxx1UtmdJ5Lmot2tIVjuYae7+91CjPUsGsFgMUmBW6aZ+Dz+qWp6g8MaElI?=
 =?us-ascii?Q?d6wqB8hpJGIOldxUyz92d/OZ51AQhqXv2XpiGqaprRjdQ8KHwOM8hUdKZ5cb?=
 =?us-ascii?Q?gK1gXn//Vc4E5vZXB8rG0PHTs8DcdYZOUHesnuJf4OyKcU9S7T/UQ4YxtA0R?=
 =?us-ascii?Q?8IpTDeoPDpEIzXpWcSq+Qzf2S+iiavOobzl2BqLl3h+Ls9iErJRRNt47C7wv?=
 =?us-ascii?Q?y46mmesp/4kHj08Z8HoYnP4Y4CYBMX7v6vVImlcV2OgGlezM8aYzuoPRDfYV?=
 =?us-ascii?Q?BPe/7uTnudveBK7n2v21ZP73l5prMHCJ5CdtRUSHnjwwyGDGNi0H+WA8U7Ad?=
 =?us-ascii?Q?PlXyABGs/w5q5cjHZTnV/DBdj8/cL82M/tPESMUm9QOAPwiw68IghM629lqA?=
 =?us-ascii?Q?dodLNW2CknfR3+QEe5+zLQzul0EieCK1tRmMfTwUZZl/xfGb4oboXK0StjeX?=
 =?us-ascii?Q?SAPs9h3/U7ZF2xczdJEiezlD81QcnBp6DgJlHau1aGHsOP//xxEF6Wdehe8B?=
 =?us-ascii?Q?x0SNr4IldbX1XHbO7PgWlvuzTK9uTchTxMimvzry83zapHUZbzsHMQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?S/1diJwnUStKuZNVeJG9+6mJq3+991/sds4DBYJD0RYut2tlZTWAsU+LsCgb?=
 =?us-ascii?Q?IfW1qmi43SmEHTRQyg68D7E2JO/fJCajBwQWb+E40AqhL7q7ICwFCHmzU6Ub?=
 =?us-ascii?Q?gQW40Lyy10cGSbLaPAvwnQiDo0BQj8V3oW0lreEFZmluCYwOMlH3XO6pHUQk?=
 =?us-ascii?Q?BQ2LGcr2RPcasrI0I3luqXXtNXoyTpE7d4P68A873f353pYRui9izeNWbFdu?=
 =?us-ascii?Q?q0fbicNTy4O2gcSF9f/000YGqwgniWFIwnAVAnBGXIMML3XdUxYgtjpbV/wi?=
 =?us-ascii?Q?49+T/Et6a1ILapPMhyAwraXrqqyJxFM8hgy+FzzOre0DmyP7tm9Mpu9OawFc?=
 =?us-ascii?Q?Q/E+mTJc6j2BrLrlY6lUAJl1PD1aA/yPUEUYEnPG42rRJCg0XwUuTyIy9bA3?=
 =?us-ascii?Q?5B2bLeEVe4yEJoYO1NcQCEW2HR7XNHg0+kT5A+4kzV4m2MQp8vLTosRzZNug?=
 =?us-ascii?Q?aypgSYRbMj/IM8mq/LrdumUpqZs3cpj4AiwaBrbxVslPOC04V/xlosDA0ZgI?=
 =?us-ascii?Q?sfPJEQYDUEIZIUNgf7GSE72RTwjNm1/8bmMlx+ykc54uXBAtaG7OX11Lx4bU?=
 =?us-ascii?Q?RBxBBEAnsMVMSt8KbMRp9LnrdLKDUy+sHmKERHFo3Sk1rCqfAY52rjXzcmro?=
 =?us-ascii?Q?3jtIqnxdgMAJkAPS/IF0/wgz2NyuFyKGUj959ZSjr6pgA24HaukVK9aUdJbm?=
 =?us-ascii?Q?2fTM8Ig3BfS8geUiDlEfzVEbkChOekFbauVyMnsFSwVhy68Uv2P1TKQj3n3T?=
 =?us-ascii?Q?bgZofPoduIVMbUnqcVxGH/FD1rXjt9YvcrabcRqTw2O1XXZe9/qqgR/8f9on?=
 =?us-ascii?Q?yCHLnBNFuatYtXtDTTKjWho77VOTMCsp7vwogBafuMC6M4V93t+hkEXQdtqa?=
 =?us-ascii?Q?RqxUHjjl84m1Buo1R9XIKDTA2rW2maDjMmSbm/8KQ+3clDmQpmE9JaxsXxmw?=
 =?us-ascii?Q?BPUG/atfIDKX6gBYqw1DE8NQVeCtBPwRKe7rbRThj49SoHuULkLd1XZCZT6b?=
 =?us-ascii?Q?LkBYAagm5h/Vshh+oT8QXCprw1flWHVt9tKjJtKBtj0wEpFc5geCsA7h755I?=
 =?us-ascii?Q?e0V7dnNhhn/KlkAFyXnHuw9+CYb34JzLDXkhibK5Yk1TLyWxPZL0U8yYK6oG?=
 =?us-ascii?Q?L+qwj0801l4fiB8ko4ATJfWsNy9gU3/EPRmn1unr98CsCK7GAY63odOIQA2y?=
 =?us-ascii?Q?hS7CG31x/FZDijS9D9dR1v1L74mN0JDiDbmWPdgbdIkJ+WH77uFbA3Xi+p1G?=
 =?us-ascii?Q?jq1vAUwfS1YpX4TiWq3pDz0CBZXGExpFKkbZtJaYoRo2mxV9dPbceLY+zqaF?=
 =?us-ascii?Q?qYx3rqPQDAXQNOn+SzA0Ll6YLyX6dLFnlgOUxHcdrV/0IemFPl7Rkd4lpNyN?=
 =?us-ascii?Q?BI1iv9Ilf8IImRN1VOE6annD02DUkqWd8IF1ZklUsEdY19EQCjVMXY91Yqtu?=
 =?us-ascii?Q?WCsWGDNtEoFsoh+y6KzvBHZwc3kdEiA9tfIdEQ534hZPmpJLKVUw4kau/8LX?=
 =?us-ascii?Q?nvCL/NT6jekOAA5K+JFNvAjIiDhYhWU0Sx4fALDxBg6zSrC9zfeA43jvjCuu?=
 =?us-ascii?Q?bXgyHa4Yg+vnGZjuOi2BiF90zbIptyL7frBiO9tFAYpwvnHx2BzaKE46L8WD?=
 =?us-ascii?Q?jCViuYm2fVsdbvRGfNOJOWn0BIjg6w9zDiy0czrilHq1qeEYlcvBmV3pf1T6?=
 =?us-ascii?Q?sWW1TmK+vmlIyLUwUeieuup1zct1ARkkOEKIKO0kFxCibUBl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cefec602-fe5a-4f45-0b6c-08de3f40021f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2025 20:48:48.0287
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T9N9Qx8MPlegBklQfQ1Z+lYxV2pXz+vY4Z8YHJA/Ldju40vLN1aDBzPH8dHIObTz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6060
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44E44120006
X-Stat-Signature: r73pax7g3faifc33mzfhejzsxwu83pgx
X-HE-Tag: 1766177331-457376
X-HE-Meta: U2FsdGVkX1+eGjY7nxHzXESzfqxk/VGz6K/GixW+2/DKqaw2N2K3SnJUA9g2tUQa5rqlLgVAdmR7kskEdsklnObZhNNDAJFhnIHJ2O7pVYz/r5snNurJiZ3Kl+VWHb+8JbDTURcosFWWrQM5KuBYkY668iYvsnNlz3fxBkn0qHV8cCa25IBDkWeqRK2RqGsnInt56BZIVD2tLdos/9sGW3Tmzv7HOl2hZdMeT5mHqBP9FS5bXBsCo5ZAImrq+Cpg7VCFTGciYo8tjL8LJsRIJdUv4rBRq5SJ274oCHW78pDwzTNU7gLQNGNhkqk8jkMz3UiCxQv04oSa1gdlVgmuioRRuQXewNi3KcLTVG6WryFISG3g6nylY354joOnJCU/61kzD10rH4iV///bnpl/X81zsCuYz0Lz+3C36RRycF2Y6CoqW9n82MioI1X0d3712FVmdgpi5AP8+OsXiRTs2+Mh9vmx1xQ7eX52zF5JmPphavpmNCf1lOH5pIQTKOmYo4LAQygl8QL2xngb3p2tcoNXrugbrRBOORhMV+N90Y6Xx5oE1U4VgFQMJJ/B2ivJ9jILr8XnZumF8BB3dZE1n8tKHtQA71n0FTHWvVtjZlqFFQHNY1FDwrSEM9o5zynSFFOl8A7Ndl9GzOeVNuAe1VmYyQ6dGA2KzzEpCibHlD0fCyTERTY2aI+DwLyXT0chV96pAJo6LBYwvYL9QK+wcSn5ErrOLHS9Mm5weWNVjdmnteyv06uc+X5EQMggkWqt8o0Xpzq6csq6YqRa2n9HIe7RsBMdo6UboYRAjDvrxt4GKqnfbgX5/CHfV5A1YQy4G0DURgWXk6yfZNL9gYV5pA46TZlATUrhKFuycT5tLEw7/vG/lxe2nAB3cChLeIZsR0Yb04z9NgX36Np7ZMOzpqxq38CyfcgK05kcZKvc22nxLyxQJAC67hmTd6KYRCBhWoFQIWR6D7o5YkfYPNz
 lRdNgui2
 vRGa//IbNMva61oXYJf38in5FtN9HnF7bYs694nC5CEYACCHvaD2bNP4bzstJvZBajURUcqYX+gRkLG3fU0epJQEUXTNmzIikBgqOxnVWIICDq7ztUI9OoiLl2saZPWY+4LB8Qhl5k5JE4R77FZ1DThJXDuHLQV2sgd2RTxdhSG4ktwxti8RwlBWxXeJdGcMXntsajWa0yHw8Dr8Tvhwot9TfdqGVEsbs7LBk6JsXypdccNRksmlsBemshJXsCi98Bhy9uldQCDxDviJU/d56aDjtvrnS8X4bpO7mKB8ygpFGwqfbCvQMnnYcyTIkMG1xT3eAmY9mOLKaYqXgGxYfIU1XRiE5szmvoHS55dTtQix44455FvmyoFCKOIQJCI/MG3csueeDdG2CtbkI0j9BARlKF/7BAxg08mFexCjdzzMtX/4cnzThqbQPJbhT+a7VZvGHmvhXWTcOCG3AI1frg7kz+104XRSHLBTrs3cdKtHsCoBV4rS316c/HMHX1MH5abPXwY5yfP+oljAWSEODpJ6Fr1D8X+VElCJReBYki40cFExOurjwM0FvGf9xU4ACpsDRBQC/peld8yQ1fznGrUNDXGKvLwk35r+do/lFWKAUhh4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Dec 2025, at 18:38, Gregory Price wrote:

> We presently skip regions with hugepages entirely when trying to do
> contiguous page allocation.  This will cause otherwise-movable
> 2MB HugeTLB pages to be considered unmovable, and makes 1GB gigantic
> page allocation less reliable on systems utilizing both.
>
> Commit 4d73ba5fa710 ("mm: page_alloc: skip regions with hugetlbfs pages=

> when allocating 1G pages") skipped all HugePage containing regions
> because it can cause significant delays in 1G allocation (as HugeTLB
> migrations may fail for a number of reasons).
>
> Instead, if hugepage migration is enabled, consider regions with
> hugepages smaller than the target contiguous allocation request
> as valid targets for allocation.
>
> We optimize for the existing behavior by searching for non-hugetlb
> regions in a first pass, then retrying the search to include hugetlb
> only on failure.  This allows the existing fast-path to remain the
> default case with a slow-path fallback to increase reliability.
>
> We only fallback to the slow path if a hugetlb region was detected,
> and we do a full re-scan because the zones/blocks may have changed
> during the first pass (and it's not worth further complexity).
>
> isolate_migrate_pages_block() has similar hugetlb filter logic, and
> the hugetlb code does a migratable check in folio_isolate_hugetlb()
> during isolation.  The code servicing the allocation and migration
> already supports this exact use case.
>
> To test, allocate a bunch of 2MB HugeTLB pages (in this case 48GB)
> and then attempt to allocate some 1G HugeTLB pages (in this case 4GB)
> (Scale to your machine's memory capacity).
>
> echo 24576 > .../hugepages-2048kB/nr_hugepages
> echo 4 > .../hugepages-1048576kB/nr_hugepages
>
> Prior to this patch, the 1GB page reservation can fail if no contiguous=

> 1GB pages remain.  After this patch, the kernel will try to move 2MB
> pages and successfully allocate the 1GB pages (assuming overall
> sufficient memory is available). Also tested this while a program had
> the 2MB reservations mapped, and the 1GB reservation still succeeds.
>
> folio_alloc_gigantic() is the primary user of alloc_contig_pages(),
> other users are debug or init-time allocations and largely unaffected.
> - ppc/memtrace is a debugfs interface
> - x86/tdx memory allocation occurs once on module-init
> - kfence/core happens once on module (late) init
> - THP uses it in debug_vm_pgtable_alloc_huge_page at __init time
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/linux-mm/6fe3562d-49b2-4975-aa86-e139c535=
ad00@redhat.com/
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/page_alloc.c | 52 +++++++++++++++++++++++++++++++++++++++++++++----=

>  1 file changed, 48 insertions(+), 4 deletions(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..adf579a0df3e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7083,7 +7083,8 @@ static int __alloc_contig_pages(unsigned long sta=
rt_pfn,
>  }
>
>  static bool pfn_range_valid_contig(struct zone *z, unsigned long start=
_pfn,
> -				   unsigned long nr_pages)
> +				   unsigned long nr_pages, bool skip_hugetlb,
> +				   bool *skipped_hugetlb)
>  {
>  	unsigned long i, end_pfn =3D start_pfn + nr_pages;
>  	struct page *page;
> @@ -7099,8 +7100,35 @@ static bool pfn_range_valid_contig(struct zone *=
z, unsigned long start_pfn,
>  		if (PageReserved(page))
>  			return false;
>
> -		if (PageHuge(page))
> -			return false;
> +		/*
> +		 * Only consider ranges containing hugepages if those pages are
> +		 * smaller than the requested contiguous region.  e.g.:
> +		 *     Move 2MB pages to free up a 1GB range.
> +		 *     Don't move 1GB pages to free up a 2MB range.
> +		 *
> +		 * This makes contiguous allocation more reliable if multiple
> +		 * hugepage sizes are used without causing needless movement.
> +		 */
> +		if (PageHuge(page)) {
> +			unsigned int order;
> +
> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
> +				return false;
> +
> +			if (skip_hugetlb) {
> +				*skipped_hugetlb =3D true;

I do not know whether we should check if skipped_hugetlb is NULL or not,
since pfn_range_valid_contig() is only called by alloc_contig_pages_nopro=
f().
I have no strong opinion on an additional skipped_hugetlb check.

> +				return false;
> +			}
> +
> +			page =3D compound_head(page);
> +			order =3D compound_order(page);
> +			if ((order >=3D MAX_FOLIO_ORDER) ||
> +			    (nr_pages <=3D (1 << order)))
> +				return false;
> +
> +			/* No need to check the pfns for this page */
> +			i +=3D (1 << order) - 1;
> +		}
>  	}
>  	return true;
>  }
> @@ -7143,7 +7171,10 @@ struct page *alloc_contig_pages_noprof(unsigned =
long nr_pages, gfp_t gfp_mask,
>  	struct zonelist *zonelist;
>  	struct zone *zone;
>  	struct zoneref *z;
> +	bool skip_hugetlb =3D true;
> +	bool skipped_hugetlb =3D false;
>
> +retry:
>  	zonelist =3D node_zonelist(nid, gfp_mask);
>  	for_each_zone_zonelist_nodemask(zone, z, zonelist,
>  					gfp_zone(gfp_mask), nodemask) {
> @@ -7151,7 +7182,9 @@ struct page *alloc_contig_pages_noprof(unsigned l=
ong nr_pages, gfp_t gfp_mask,
>
>  		pfn =3D ALIGN(zone->zone_start_pfn, nr_pages);
>  		while (zone_spans_last_pfn(zone, pfn, nr_pages)) {
> -			if (pfn_range_valid_contig(zone, pfn, nr_pages)) {
> +			if (pfn_range_valid_contig(zone, pfn, nr_pages,
> +						   skip_hugetlb,
> +						   &skipped_hugetlb)) {
>  				/*
>  				 * We release the zone lock here because
>  				 * alloc_contig_range() will also lock the zone
> @@ -7170,6 +7203,17 @@ struct page *alloc_contig_pages_noprof(unsigned =
long nr_pages, gfp_t gfp_mask,
>  		}
>  		spin_unlock_irqrestore(&zone->lock, flags);
>  	}
> +	/*
> +	 * If we failed, retry the search, but treat regions with HugeTLB pag=
es
> +	 * as valid targets.  This retains fast-allocations on first pass
> +	 * without trying to migrate HugeTLB pages (which may fail). On the
> +	 * second pass, we will try moving HugeTLB pages when those pages are=

> +	 * smaller than the requested contiguous region size.
> +	 */
> +	if (skip_hugetlb && skipped_hugetlb) {
> +		skip_hugetlb =3D false;
> +		goto retry;
> +	}
>  	return NULL;
>  }
>  #endif /* CONFIG_CONTIG_ALLOC */
> -- =

> 2.52.0
Otherwise, LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

