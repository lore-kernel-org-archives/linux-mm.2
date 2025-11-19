Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AA5BCF394B
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCBBA6B002C; Wed, 19 Nov 2025 11:35:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3066B00CC; Wed, 19 Nov 2025 11:35:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A91D36B00CD; Wed, 19 Nov 2025 11:35:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94B9B6B002C
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:35:54 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37F93C0565
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:35:54 +0000 (UTC)
X-FDA: 84127908228.12.C51E7D0
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010019.outbound.protection.outlook.com [52.101.56.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id 59BD420017
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:35:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kgVXxDh2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763570151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvKrtivbei3vY9NsD3AKQbhFJWxpYD8fNsMajL0CteA=;
	b=KxEoSy0jas5RFmeNA2RDs8shduRVs5EpmGtkTmCimqfsxwwIdBN0opn5XaPDbJBCaWbIb2
	t+zbKgtVnjnL48hgacSLrV8sIXlfc7DCtThPH8ymCfIjbIn+a6YNSAW4YRK8KSQRYj2477
	JtJPnoLPki6OK0xpeGVbo+lKuAPViZE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763570151; a=rsa-sha256;
	cv=pass;
	b=luxSHBgSjpOi+fy2nNiUvZowIy6nBmgL6BjPzX/w5Xi/rhqosgfKzzXzBSSjhfG/oGAwte
	GJQt5UqHWSf4ysqy4PPuPxwCj6e5wQ4RkYTGabm1nvSy1Li1FD83qD5PdxdLbLfh2tjY+4
	oWQ7VdHQHCqsZ3K1OIsIGGK6MqUb5f0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kgVXxDh2;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.56.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OTlfs5uqBrJdSKRZoupgZFS2atjsfRta7/7BTvwuqP0yDF1+BwqJoiL13IPfw+74nsQFjWJOZStFBJpAiqAppxLBrPDDWURXi1IOYbnLW729T7YGe7Qk2vMJ0sxY5vVb1Wld7mxfZXpBKcj2+R/lZv425PJxYr3C05IFn8MIsspi0s3g/AzUznBZcXIV4Ze83A7S5z+bwJ/GaNEgyMKq546m+J0cMVhSF+Hvz4AxObAnqlJ0vG5InFfXvo1WuUcbCFFCJOCwcInXOf93YRGPRJrzXRecz9nLbV/SqsZPmPaLPSU8RuLTT301W/p9ASC7ckmLnMH0q+XM3rXJzd1XoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dvKrtivbei3vY9NsD3AKQbhFJWxpYD8fNsMajL0CteA=;
 b=pcvE6faK8omqgVJ4VMGbLqe1E0tdO2sTGgVYPQX9XbTJwfmt/hPUigNQ5crU2CTnyy8wMscDKr446/a8Ej/Sc7YlvKQgqt2XEumaykoqn2tT2ovQC96J1h0Twoum/B9WPIIdW77JczZPNZxpaC1gvicepIO3UP30Brqpel+wvrfVpo02pbTGcZjLHCoLC7tU0cqrZhYLG7cS9oR5ccs5CC2GIAczFVTIJlClMuJqAixQsN7UhO4sscGeW4JFcSBrmQyAKxX4GB43ZGkStdrIIMlILDX45vpGEwqlDV4tKOgfqO0Bn9h75uxxKdI7LBGMKxJ4EFzeAFZZl+CrkbB3ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dvKrtivbei3vY9NsD3AKQbhFJWxpYD8fNsMajL0CteA=;
 b=kgVXxDh24N4+MJYiRRwvO8Y0EMfywUIzsJOsTifcc5LvTfw4CFeWcNgw20Q3sAQaBA0FqfEqn0U9bGqQyBg3+l4XgX1SV/U85O1V8pdCp4712blqmdshE+OxJrNCvxyG2xEJ6C5/X3aoCy3I/DVxtbTr1vjsnayKcY7vdRsAxwre8fbdK92Vdl0U78f1n+1yffdcF63EPUtW+PamRBNeTmnVyXeDxbc5RyaQRoE+aUh2UbSMmhs/1MQs4CPjSH3p1dkTBUxowaeE1KJcH1ZMyARwIxz881xR4pqJKGnVfosleX90YiswG8ckQgQW3rgeb9AlK9KrkPtdlbf0X14ppQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYYPR12MB8870.namprd12.prod.outlook.com (2603:10b6:930:bb::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.10; Wed, 19 Nov 2025 16:35:48 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 16:35:47 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: akpm@linux-foundation.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, inux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/huge_memory: rename __split_unmapped_folio to
 __split_frozen_folio
Date: Wed, 19 Nov 2025 11:35:45 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <3217C13C-4D64-45E5-8EB3-BCBA4993792A@nvidia.com>
In-Reply-To: <20251119054639.244202-1-jiaqiyan@google.com>
References: <20251119054639.244202-1-jiaqiyan@google.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:408:fb::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYYPR12MB8870:EE_
X-MS-Office365-Filtering-Correlation-Id: 7717d11b-9321-43d0-01c9-08de2789b1a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QkrBHD7eSvtq1pZF5PevyzFRD/QjqAbrxje7qh1IYzaHXSuCXr0nXhA6365W?=
 =?us-ascii?Q?+s4UC4ouVgbcYtZTeQO8s6NE4rJl2JLhF9/aw7GTIKyARUIXtAj+f+LwIewI?=
 =?us-ascii?Q?KgrbiBNu41Djw4lVdPGOSnWKKRHySDTsYEk0XMeACE8zojex04PeRtxm9ONj?=
 =?us-ascii?Q?sTxJx2ShteamaHH/kKf4OsPqebwQP38AyODgByP+bXCyWdKvvJrDN6u3rrAk?=
 =?us-ascii?Q?P1kVt50h/kOl/7lOOhYmX9pH4mC8CddTu78X3kY6THpr1DE5W8KO2UluIvrK?=
 =?us-ascii?Q?JoEA/KpWkNqWe93GF+2h3eq4K84FAIFJgv/iTufEbk72shkKHVOwHt1eEgBV?=
 =?us-ascii?Q?eaM01LvdLab0uR0+YL9rTHDQ/Y+EFLIk+2S+RVpsLsnENtBRJIU5lAot9tMr?=
 =?us-ascii?Q?4EHklm+uMrYnBHaLGt4QtaU50Mvf8fi2asE7ntHG3fOGGKNYlHECU/q11Wwv?=
 =?us-ascii?Q?1OeyrHs6wI7ZSMZVVRzN0Af05Qu7kFrqtkSI/uf+xNL1VRlLUOz/toTDRc6h?=
 =?us-ascii?Q?4teOKIJgzOOCPG10Y7d0YceiD1WI3v4H+L0RLIPXgT851d5gVxVH5oOQXGDB?=
 =?us-ascii?Q?1u8DF1FMsI+CVWIGfLYWN7O2/fBuNhNOhtdqlrlm5ROCe74toIu8KOcBkY82?=
 =?us-ascii?Q?5CnBrD+JKVWHi8M/VmkR/yT0EzQF6dSXWY4hjMTZulZFuyUTbfDVYBP4/MqZ?=
 =?us-ascii?Q?kX2jVkn6bjEGRCsE/ZnHGhfL7xJTC+a/g81rdKxp5gjpVgbhW42/4bcgXVgp?=
 =?us-ascii?Q?NmU6g/8bYHcKSAD/YuOyRMJdR496VC3yaFQFcZGynm9igIE2Gdthne0m+EHv?=
 =?us-ascii?Q?C/cati35jwh9CD43XueBY2g0RKSLRIRffvZFmz0AFvLEFck4d1vQ9yMw1Ewi?=
 =?us-ascii?Q?iamQO4oFGmLdx+Aq1XlIJ8dKyW+gojsestCGmQSc5GEc/2m6U2YgdT8IxeKv?=
 =?us-ascii?Q?+/gT7DgqUsYZpcGc2LK/CD+kT0Tnmoe65kFS9DwbUt6InMlMTZ/qcKvSYhWA?=
 =?us-ascii?Q?jiK9PMLgELa2LT7jM2iKffRIiKKjTPY0GDrmHa04NZ9acJ2r0nLnGyN6mMAP?=
 =?us-ascii?Q?ZNjpkTiN/TsUq1eGab1CFvo73EMg4bGo2tQ9VBAZ3lbqVWRGvsNMrycYnpRt?=
 =?us-ascii?Q?hKJ9PQYGSntqgUkVKtrs024DmnrfOQ+35jlvhMs7+099rFyutDItmJwo4XPz?=
 =?us-ascii?Q?2tw4ObSr7VfgR4hQBX5HONPcpu/KZQE7I0c63whmjZN+WMgVvy/+HZtv8m2c?=
 =?us-ascii?Q?2vYP/ubWj5umPPP377+/C92npNrefXQ3r+7a1PiH/nCGhwnqBRdhuS35OE36?=
 =?us-ascii?Q?Ttu89pxKXOTAVFWQWFQEprI/uvF/5UKAnfrDOzKk4P8h6YqZBTyYUtxwOK0h?=
 =?us-ascii?Q?7BXREqmkRF5UPZCf3k82b/w9/vmorhycZdkW0k11riDAFSep65zGpzAj0Mp6?=
 =?us-ascii?Q?8kYJIv6+2lb6lR+dUvo2GQPO9bZibgZLBCWyaLZZ1DiwrAftqi01mQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aUjVIRI80f3/w4ZE0J621M2uVNYrsUUl0e2lkmeU1b57SHcQm0GX6swZmJ2x?=
 =?us-ascii?Q?wwC8KoCIOIKSyjcqEIitrDEkWEPXNIV+OWk0rVzlatYMA9RP8i2CTXLy1Wln?=
 =?us-ascii?Q?Ne4KRylek1rEoJZwA+/gPGwowiDSllxEyuZSEJ5CXuOVoumNFto9qstGSv8k?=
 =?us-ascii?Q?xShjxC5UobLjB955Fz2BkAcxf1UvGft6vEL7KXlLigH7LoOgN+MUkjO4dbQE?=
 =?us-ascii?Q?lYr0j0SNHz/0WwSu2902g6HJ7BJR5BusgfgzTiFA9beSEQ/9ZL1Q6LgEPIP0?=
 =?us-ascii?Q?9UNQ7f4ZnRKKcmqSTCJJZAq0ceXA5qgwQlZWRQ39nMYe4DBKc3R7KvTcMef/?=
 =?us-ascii?Q?pxVUt17l8h5QhHuxQTDl6rWG9WUqlfuG9CTtZEn54tUeXq/rt+L+YnED1PpJ?=
 =?us-ascii?Q?ScLIvISRrG1oAbtnU17BSdw5eaw5LD/f/W8goKw2s8XdFLnNVmexKVDgrSJN?=
 =?us-ascii?Q?ShEDKYtLZn02suySsHyuo33U5fSmxo1v+msrDa5xfqLsOKte8yPxwfyn7hqK?=
 =?us-ascii?Q?WD26z7hXsx7tcWtFOckKchGwJ+jA9hR3IG1H++2Qq4CWtiIVkH6K7XKFr5LD?=
 =?us-ascii?Q?1HYqA9n+NmQw937CkWAYqcBn9ThYgGoHUMyMv4lP/CzDz2G9YFxrcrYFYQNg?=
 =?us-ascii?Q?+z0AsXmHOBlfe12zi+kZTkg4KVW/ETFc2wLQL4mxNNIqDovD4hMt8mv2Vvh2?=
 =?us-ascii?Q?r34oy4R2+oxVdKG+seY/wUnItZPY5rpeNNQylv9qb0yAsvrLcwqy3M8XUnnE?=
 =?us-ascii?Q?7A5ludl/Kz1Km9gVVqMrI3tflpnmJGBIhNEyElYa7CXbmJ0OpTZeuOeUDawE?=
 =?us-ascii?Q?gaOgKAy8pNfYbg0ZL2qq8QFB7Kme58F+s+CBKIL6zuqewxK8BhvbYuDODYkh?=
 =?us-ascii?Q?m2OaILgoKBAPMSTWGeEkH18nQWMSPkObX7iCcpimNTYPJGYi7uZAs0yaCyIn?=
 =?us-ascii?Q?FnKlYPnyeOL3yCBXDOm53oRCULamGmNddidLJu9m73+kxXtVpvbIY/ef2wKE?=
 =?us-ascii?Q?J7QBYlAOQAG7x0OOKhZyO8uSR8nUnqMV+eMu4SGKif+qGW9tjcCHH8NgbAhe?=
 =?us-ascii?Q?tNnqrD/gGU406HwzqbXknSPsQlS6iKFpXDETVE3BottvPjTjCMGI4xnBpGYL?=
 =?us-ascii?Q?90QEySB2W1NEt3/iF41eMwQ6NvMpv07eqLcpwzvKZpriroMoVeV7/UfUGf+r?=
 =?us-ascii?Q?0bIoOFEzhCnaxTi0UEXHJtkcdGQjbwAyBS1ORpm8A64FRWbZA0ZowA46T/SL?=
 =?us-ascii?Q?sueW/IgzS9Ioc4cuzzr0J1SlDc3EA7ebImiieOv+SU4WBz+kdsFAQl8b7zxf?=
 =?us-ascii?Q?B08u0NKi27kMjqfG9lyoqDIJgHFCg3bib7b5G7q+fhpfSKWxdHQys096OVCO?=
 =?us-ascii?Q?UGBL7rf/XRU+x4HhhaToClZWHmfYOs6VgwJl3u9pVEJDZIrDevykZQ02Cc1A?=
 =?us-ascii?Q?zslW3P0kx/AGwiB+D0W4a2XBTtg6rz84u7CaWmOcCmBsamXCcXJVS9NNjWlx?=
 =?us-ascii?Q?KYzw/Iv/wZkQkK7mzKMTa7j5W3FZ1Jj+sAMvjMIgjJim6OLgaqh23zTboL+L?=
 =?us-ascii?Q?eetEe7NTy8zSvNSOhcHLonRCAnUguNe1xF7rU1Nr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7717d11b-9321-43d0-01c9-08de2789b1a1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 16:35:47.8874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +0nZpQlu0pBctzMFdK7S6Tbo9/Do+3YZ8sSxKnwwJByNYu0a6gM2dyxPAV517SeC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8870
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 59BD420017
X-Stat-Signature: hxd15h436zoisfrfzhsmfwg5tdo5jym6
X-HE-Tag: 1763570151-741553
X-HE-Meta: U2FsdGVkX19N7dnXl15og9rbK5svQuXbX6l+Wjf4orwzhkY/17r6ylnmhC7D+Q3On8t9o1jsKv8whQOt08xc+X9hq18Yc7HCSi4+VbPVQlJ378d/9LW1+b2lVADWERy/7LRAsdwkVp1jLFmHRxVNj9MYXJMOUYaaTW9ibJGoqKN86NF1xuz6b+jxxa/9lmU5IyBneHwowl//0Oczf6m5CDejHW7HneLhtsm+bKbJsWq7YRq/PeMvLZftm7Db0buxso8VZC4M4Q92oVfQ5RfstUQ+HnkHLv581GNPXnlxWV9avizar6bXVmfK2A1TxKtshua1eYbrNZrPyxBbwSJxCCwm8KsDWYf/WB6R+vRQcnZUcoQaKdx32YdGH2ixHPfP3m96O0dIvG6ifVteUzVNPXosVIBPrllVW6erCIpw5JPHp7dPGGGYnItddGIeBhY87vAsjsN5Y/3NJnHRVt396Np2yRt+D1Y8YcYSZ0vTDAA0YRTyPfBvko+Rq3t/BTJnXRQEt57IMX6sLBFBK8KB6AAWQUu2B0Z2VM1UK93NTGRb0SvQ9peNNp1d3W+T/lgI3jUpie0daDn2lXWtowG8BnzpiUCCefW3HmSsICbxVLA1uveMLoWmdi1/HmvBSn/Mg8JzAPpanzxsxll/3wmg1PyncdgOVxUuTuZWPqUqFoHxDAF7KxJMFwhDW2DVbrx56VpklRnVanw2UrHiluDGe6oEFBxyV2pH+xpJAfvvtAw8MD0PUX6nJC3roptPSi3TAGxpOm3SlkTs5w4577CzF0mFraapCvPqBiB7wimSF+kdY2CDLZG1X/dkpXVOKPskH57oGL6BQXWHtc9VsvKDZ3tWC0gsrBtY1g2jahPbEPSIEbzPTibqBd8oTNppVF7gWzeITK6lwVM1OJBTEGyzgS2fb7sJWqF+D+B8QF4hlMXhNrL+0fukdE11ViEIOIbP89ggziRQBoMXbD0xdB7
 87gE9FI1
 ya9zh9fnQb9KCCYCAdItsZtLYKD+k7+MXROohEtcxZlMDNrMGPhMCgV3Hy+k29VvU2pcS/+0QnRdNuHZeFPBIxXxfAW3mozyaiomx3trXK6GBD0BkXcZJrZaMMPE+qT2jPmfohzhgoRQ+GcHEZyqntIEzn0yQmEqs4FH0SyzYD0dKlpz3vy8ffC6WbhVIx011wvUJ3jxBvvNnoEj2Nxb3/sH1e/iVr6hDWvdF9Hma1ZuQXtAPHVhfaLeEhWfgiqt7u+71MCKneG+CBNVaCh6qky8vFbjqS+ln5XyolJnOUvFsrTJ1oFI8aDuQAn5d6tGMohTaGnKWEeIhkDCrhXjesNxoYVQs+usJJFGFpXEWhk8/WiGXwtQUejQPHLW5LKFar9ffqjJa92Un7IrHbODT3OJmFoPf7VihOSLAph/IeDKnOFfSX3t/JK4v5wjqRTVKz0XBqnjlfj7B2t8x1znP8zzO4RwYxjlup1d2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Nov 2025, at 0:46, Jiaqi Yan wrote:

> The correct prerequisite for this split utility isn't really about
> if the folio is unmapped; it is more about after unmapped, folio's
> refcount is zero and has also been frozen. So rename it to
> __split_frozen_folio.
>
> Add a warning in case the folio has non-zero refcount.
>
> No new function is added.
>
> Tested by running split_huge_page_test: testcases all pass and no
> warning is shown in dmesg.

Thank you for doing this.

>
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  mm/huge_memory.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2f2a521e5d683..5b9c3725e9265 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3390,7 +3390,7 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
>  }
>
>  /*
> - * It splits an unmapped @folio to lower order smaller folios in two w=
ays.
> + * It splits an frozen @folio to lower order smaller folios in two way=
s.

s/an/a

>   * @folio: the to-be-split folio
>   * @new_order: the smallest order of the after split folios (since bud=
dy
>   *             allocator like split generates folios with orders from =
@folio's
> @@ -3428,9 +3428,9 @@ static void __split_folio_to_order(struct folio *=
folio, int old_order,
>   * For !uniform_split, when -ENOMEM is returned, the original folio mi=
ght be
>   * split. The caller needs to check the input folio.
>   */
> -static int __split_unmapped_folio(struct folio *folio, int new_order,
> -		struct page *split_at, struct xa_state *xas,
> -		struct address_space *mapping, bool uniform_split)
> +static int __split_frozen_folio(struct folio *folio, int new_order,
> +				struct page *split_at, struct xa_state *xas,
> +				struct address_space *mapping, bool uniform_split)

Hmm, bool uniform_split is changed to enum split_type split_type recently=
=2E
Can you rebase your patch on top of mm-new branch at
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/?

>  {
>  	int order =3D folio_order(folio);
>  	int start_order =3D uniform_split ? new_order : order - 1;
> @@ -3439,6 +3439,8 @@ static int __split_unmapped_folio(struct folio *f=
olio, int new_order,
>  	int split_order;
>  	int ret =3D 0;
>
> +	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio) !=3D 0, folio);
> +
>  	if (folio_test_anon(folio))
>  		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
>
> @@ -3583,9 +3585,9 @@ bool uniform_split_supported(struct folio *folio,=
 unsigned int new_order,
>   * @list: after-split folios will be put on it if non NULL
>   * @uniform_split: perform uniform split or not (non-uniform split)
>   *
> - * It calls __split_unmapped_folio() to perform uniform and non-unifor=
m split.
> + * It calls __split_frozen_folio() to perform uniform and non-uniform =
split.
>   * It is in charge of checking whether the split is supported or not a=
nd
> - * preparing @folio for __split_unmapped_folio().
> + * preparing @folio for __split_frozen_folio().
>   *
>   * After splitting, the after-split folio containing @lock_at remains =
locked
>   * and others are unlocked:

This part is also changed on mm-new branch.

> @@ -3698,7 +3700,7 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  		i_mmap_lock_read(mapping);
>
>  		/*
> -		 *__split_unmapped_folio() may need to trim off pages beyond
> +		 *__split_frozen_folio() may need to trim off pages beyond
>  		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
>  		 * seqlock, which cannot be nested inside the page tree lock.
>  		 * So note end now: i_size itself may be changed at any moment,
> @@ -3788,8 +3790,8 @@ static int __folio_split(struct folio *folio, uns=
igned int new_order,
>  		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
>  		lruvec =3D folio_lruvec_lock(folio);
>
> -		ret =3D __split_unmapped_folio(folio, new_order, split_at, &xas,
> -					     mapping, uniform_split);
> +		ret =3D __split_frozen_folio(folio, new_order, split_at, &xas,
> +					   mapping, uniform_split);
>
>  		/*
>  		 * Unfreeze after-split folios and put them back to the right
> -- =

> 2.52.0.rc1.455.g30608eb744-goog

Thanks.

Best Regards,
Yan, Zi

