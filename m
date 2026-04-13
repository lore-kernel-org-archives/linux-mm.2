Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6AFF531C3
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 19:21:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B9926B0088; Mon, 13 Apr 2026 15:21:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791296B00B0; Mon, 13 Apr 2026 15:21:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680DC6B00B3; Mon, 13 Apr 2026 15:21:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 581396B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:21:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23DFE1B7401
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:21 +0000 (UTC)
X-FDA: 84654501162.19.545BF4C
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012017.outbound.protection.outlook.com [52.101.48.17])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1776740009
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 19:21:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TeIAjVwA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776108078; a=rsa-sha256;
	cv=pass;
	b=osFm/UMsijQgrBUi+SMdaciIzaAezhpaIYDzhppDsxDTL5KTh/uUOQQW0gaTXk4qbZR6Oo
	sIeU6B3gJSu83AfuYco23vQhe08obbIr6mv2kQnY4h9HhNXm6ha5sdF6YvRZbh2BibcmIr
	T7ZAB8BTtVBaSujvjdW7XqBWhiJ/SPk=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TeIAjVwA;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.17 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776108078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yActp2s80GIDcma74HmE47OX0r+m2huf1uabN+Ec8II=;
	b=bYa7bdriuPsS6TNv+l2MVqTyfIeHyUrHQP/I+DQ/wU62wOd7lBfob5XnIG7A9ELigoscnp
	yHEdwkwESOC5H6zNDUI8Kza/5HWjKUrDX9REinorKkJgDMTOXJi0hd/HqKq9HBeGUIUT+X
	2ZdjVVcobdUww8qq4vcb/IQQX7lf+50=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=glhUXnNZ5KGVw4ogruX9y5v2DRxjijggR5oQrXcheBPBbxeWH6DNu9Q1hCcxcpfmHGYat17O1bBAxDI8o8f37Oc/yBOKRaok/0FxycnXeb/Tf1Ci1UX5qSskpZWod/9CSBc0pGySd2HbJbRqdrTHKeV6Zsek7HuXUBqleHXsISY4IG7/mWyuL+lXD/k/GMb5SczWJYNwS58zzsrp1sUvD4vssbIIKjiGiSlCk2tk3SvYD1lxUO0z9/PKtVBH85bpGGLcKrCbqAtEx8hT2xCUO22v7r3abSzdTbqW9lJPz5160LggB/c/+J3RkUvhKVXIfKBTxUPcu4tj4qmAiZvyTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yActp2s80GIDcma74HmE47OX0r+m2huf1uabN+Ec8II=;
 b=Jr2iMsN56g+5Ih904UAedLNR+f11wVYYRSNmk+pS6VlE+YvKiVjsXAVxrPWfa03lh0savJfYbftj9wnv9nuns90SnpMPET5RsXETw8UzQdkYsqZGi0jTQP4fCn8qCGskBc0msW8yD4LGtR0AOumol4KCq7BlqtAd+4Ik3bioICynRfy8q7y6r9cYYTDBHR73O/YFv2T0E87+mFxKKqXRNrPHNlA7wjeiFNFNDOMW2VtoMtJHx9UOV2bAR0VCUJziQVgMC1ekeN4l1PKE58zx+vD96+2lqMNLkq7YQ/Gh2Y3JJsVpyqkU5docePo1ZjOoAV/prnbL/OC8RCdrIT6LGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yActp2s80GIDcma74HmE47OX0r+m2huf1uabN+Ec8II=;
 b=TeIAjVwAHy4rP0ZE06UoNjSs9oSmfXbqm4bqQ7e1JFTvi8frgluISt+P8n8SZnUqw43ETcPdszzhFIGrw+FsRepfNQRpdPAS2uoELCZ4ipqlOKefHof0ahM0+/H68sl7wpQCuYatbQAFzPZhYMqhmdJHiXYgLHxRoH3GXw7gcEc1U08TKB7eTpB3Uc0HhGDc7Z3ySkPxkHJxZ+mAtZVPugcD3xuUxYaPnC72E1HHAKtbiWLPQ6cFOFlbAknE60GPDzoO9j6RtsM0mr5b05XXo6rsUQ8PDiYLyDpOqSNuumV9UceyqrZLvf7aSdvBRNEAldwoWT6x9ZX/nf8K9fX7dA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS0PR12MB8444.namprd12.prod.outlook.com (2603:10b6:8:128::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9818.20; Mon, 13 Apr 2026 19:20:45 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.046; Mon, 13 Apr 2026
 19:20:45 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v2 03/12] mm/huge_memory: remove READ_ONLY_THP_FOR_FS from file_thp_enabled()
Date: Mon, 13 Apr 2026 15:20:21 -0400
Message-ID: <20260413192030.3275825-4-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260413192030.3275825-1-ziy@nvidia.com>
References: <20260413192030.3275825-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS0PR12MB8444:EE_
X-MS-Office365-Filtering-Correlation-Id: 231d12ea-bb39-43b9-ae22-08de9991c1be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5NDOgR4HwSIhGpIwHEjN4Zet6vchKt1HgYzDlpxHEvdrySg1WtSv53U7wFIWOsF4NKetKd8DEUbxLSPa0aQpItYtWEJHayqBBjBF3V7b0N/eLzz3pF3OJ8tXrgrB8UCaTt+JsEwcfUB/00KlGFIs+xf95mtD6e1sGqG1aE77wSLxPb3e8sb1EjQMGhCcjpy7z+1wfGA72gk7AyKyaXW56neWg2lkUV6d6a4ESs4i6XBT3spOiWE/RVD+i6Mhj6r1rS+jPypYXxMTU4bCHVTlsa9d8p0cPwiGSleequEVnGpmtFI/652PhRBVhIGnviFhEI+62Y6zrgEhEVvk70d9NzQTLvfVEpr3R5i2+T5VcZ4q9D2ExoTrZAOlTZ98sZYtb6cQ6A6b5v7kdImmSnOxw8aKtr8gQ8GI9OJoQP3rRLVlN4dx2CGvwjmMS0NkMZ/4pN/1RF0Q14JB48u3PiyrMa+Uk1twT+yTWH3PdR40F1J9kjJFN4hzZqX048Z7IPCRP4tTECLFDqYcBLND+EZICYrTRG/CMZUjzlNZNFQ5GfvHDJpNi6xdy6EnvRfd/DY2bNUbjGQiGs3YRuy/G0gUCDm+9O8zUJTU5oYcShlkNMEXYya/XaWakJQhaTwew8+//CUT/RmF5SpuSAezKI85+vzKnxR+IXRx4/8H32X4RZ/vXvP8sYMr+e32Jxi+0q1DxYSM67y8+OnNcGgqX+BgJoccgu+TieXvtiaV/Qr/22I=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tLpAsomZlexGCJUb4FpCDdh4PAxBs2hV/df/ou3/JpkqNDrPBtEbUbfZz3fT?=
 =?us-ascii?Q?aeV8WqlEc5fUhkGecfrNXJkrUaRLgkUiCI8mOix8jPEuWQa55gQBiyIPHmZr?=
 =?us-ascii?Q?zcDf5JIjTvM47zj6QFXFiEnu/ueZol/eFT8v4xRpv66NQEzz0VR4KDrTshTV?=
 =?us-ascii?Q?BjGeGZwLynNZxb3W7PZCkQ59x6BKkdc/T88YlLGOrCN0dQ0ALJCQ7VkE1EcI?=
 =?us-ascii?Q?s+Wj8nYcU/pnVKXwDY6GYqkbBBLCkbmVGwl4HatR/iyb5OmzgDNzRg3net6z?=
 =?us-ascii?Q?7H5TsVuEGNlZHI6zR6Lfl8rG745+CQSIwPQf0KJWi278xVXy/s+dutEzKAYG?=
 =?us-ascii?Q?RNEHBqs1NZ9/A/fq5ULikxpYKxYrSWsO3IP3ieOfo8+m9PRJQS4CiULjO/Zl?=
 =?us-ascii?Q?FkGgCtUbA1hMOJawvah3R6wLU+jC5rP8mGTNyBxVePt5TQ0WLomjzFSqmXYq?=
 =?us-ascii?Q?1alIdFEihVYacZ7yUOrUvRSmBN9sDuI2gnXi2NK/1jOGfUgOwVsEWxh99hcN?=
 =?us-ascii?Q?rAK6WSEMoMJjwmEQvlyHlksdNFIpc10yQH/ghrQzKU9IAwQ1xdYIeoS7ENsX?=
 =?us-ascii?Q?jL+DEeMrPZOYcByvA+TbcYtdoqadHawuSBP7Aroz0cwcnLgE4xMxmBhkoVEo?=
 =?us-ascii?Q?Ij5n2+iMG8Up7s9/S4YKFI++cOur9gAkuT9Oeq/EWiUXerjytjJfEKpdtc33?=
 =?us-ascii?Q?c4LLd25Ch+ilz1D4BiqiYnbhE3PM+5jG0ZKu/EB6Y6BrsQZpiymonAAdYMMv?=
 =?us-ascii?Q?QMi2XdDTtyQePrno4gjq3Y/R9gM+j+vKdbIi82yBUNYZu5wnNxlZkVXR1x/F?=
 =?us-ascii?Q?hSZuyLccQyOwzKlC6hy/sKhLziMLh81FZik4hY7XCbditQ6HAsDKQktC2zPj?=
 =?us-ascii?Q?JItoMf24eiMC151tMSnvTb/OZozxiniFyI0cOnZ3pt/6u2pBccmyGr+2+J1R?=
 =?us-ascii?Q?wz7Yd92YpmnOyVd3wVxv4VPVvXK7P7TeRi7X7lIyeRU5F34+PMHML2WTJEHD?=
 =?us-ascii?Q?1m7P5orYlIs+S8UTGwUSghNqBqbvd1PajrB/UZqpQXxdNquHg90iX0LILPoE?=
 =?us-ascii?Q?chMLlBPWWtRgPhCo27nzHxuGQ0vRkB/7upAjDI+pHIcth+08Xl4UbyBNgrqj?=
 =?us-ascii?Q?0/NimvIarKHfr+KJe8Pl98NXQdm2qaeJcVJw3lspiW7oUrybD9DTGSwwq6bC?=
 =?us-ascii?Q?PAOTGco+7jjToTidR9zfjrojYPDLC8L2Sjals/hMNcmjre7xEmyQRmLtGznN?=
 =?us-ascii?Q?ukjCYaRwCJA7+mL2ERnHYk8qJ+IC/sWLgyNfp1auRo9JZq6mgQnFQxxbiRe0?=
 =?us-ascii?Q?rZDjAp2C17oV7BoHtPt90sA9G6MZlopGqGYnM+rGQlAoc58ACjTVIdhzYBy6?=
 =?us-ascii?Q?xj2lBGVH+cmGDhs2qNqlxPYbsRpKUMbBfoS0agCU+Kg6ADLQ61BvRKwcHKXb?=
 =?us-ascii?Q?IOUleBxDOg0KniY53gh4LFkSzRRA2sMIrvdiwmt+qjgbYKE+ZNMYDPBWMBjA?=
 =?us-ascii?Q?me9dWLZ2T5x79djBczYQDE39VUhg5YO+yP315nkCwzODzxJXstN9KPLFEe5M?=
 =?us-ascii?Q?ajb3HGGm5CrzRdFgsd3VEiPMKCaI/7R6QTyRrBiTLGYw7dGdkhN9DX/8+n17?=
 =?us-ascii?Q?f0pfv0MC0jVT7cHcZYw0B4N1UeZHSmcUhSERexhLojWC5urFT3p3XdsHP9lT?=
 =?us-ascii?Q?s/JpPkzfFz3kcZ5tYFLdaKQePVGouAD0ndJH0poKwr7Hjg1L?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 231d12ea-bb39-43b9-ae22-08de9991c1be
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2026 19:20:43.4147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7XuUF5NAp9tPG+SubHuh0viIFdwM+vmXmUNtg+vJepDU0oYYKoFGNMLxmZoWV8Bw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8444
X-Rspamd-Queue-Id: 1776740009
X-Stat-Signature: fd7qzurw9fqwe6w3aa5ujps5hew4y7w8
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776108075-241324
X-HE-Meta: U2FsdGVkX196zzKMGrabrW8k8yCyHkASs5QdDs5DzhpdGAIWcP0OU1D8Y1kVRVJnDqFMLu4YWBN2VMm2hmNOxBXjYIdFURThE6LSbClre0KiHJzXJrGmzfPpmVD8MUFTnlgeQMkbjd/3a7ayyHazfP04qsNtTPgtbejjRSJCkt0QnZV/clc2ry9+kcBC4h1ivZThky51CtQKmmjhU+FhMwDSpUn8XDMlip7vijzvwtVzCTEjMLPdzHif2+80ManAwgDzDvn7iD90ZrkO+ioHKphr30NTs7MMk2o36IoKo4WtoopZZyh8JXvMHH75atzEt/+rAgkrjJ3Il4GF4FmI6BZLA0l7W76Fanr5jIj7NK2LNp73PaJlAblgKdfiFVa+2o4shNNmiEweQQTYRfpnxENVh7ZwxiauaaDurOwPGHN7mSx2qisL7myhc1tIIyMOMmdgWGbWXqK6HOf8skKvOzrAwYcdVNXpPlFFg2/6js6GE/cFzzL1ZprVzgUFjtwkO7is0gcYY7Ge+SAJveaF+zSN9OCmW0TSEx9Z5mPcNDoN42WEz6CQC7aNc1gPvPHnFPoESvldX8o3h1zBfL9CUpsBFWTmfuOwXnuTQH4LvX3mfMKjAKEN0vILilUFNomF0HYOdw6jndibLbIQFeBih1ssi0riixIQ6U2ElVo5yRpjp6DRkfYZQM9ZisAHoBV6JW4Uhbbs8bkZPF4ukfa6ycZwQ5eJJRxlzEZjkKD14T0m92QEGfjuTLdIJsmYTRQa6XNK77GlFfx9CKD3PnekspjeqHJsVvk5hZg9fcA6CUqOgZ9/gccQtYBY2lUUyxxeWuG5KP9Vj0dvt6KZNg4BdWqlmGb8Uf0jRAf/nXyMgXsOnXMLc/ZhiFqldD3OzZADNzOx8ZzZ1oZYhIrGHMsb8hvzKnnMBKy0ssjdL5gkGfVuUfu8SztnvlIGhzEZGBxsCmStamXuW9k1k/a/HF1
 xKku0z4h
 oKsd7wmtY44VIiVQUhQvGbKp/2tL1cU6RS0aVfKIbtQxGDPsuvLHrhA+PK7wdJFLGl68OJ7ROU50twzjEnZJJ7RpdYlThrEfiVSRuX4OuxNZeitu8e1qJRUAYe4ojSjsnRKvjGSt2bSsQsUpYWYsHVmSW6n9Qy7QDVHeEm0NEyDYH6w1ZPfzIASzqSDYx2eaK9j/30r2FaKaQxtzyY3K5ybnio4ijZX0y112WOrdqnSfY+O70G1GDPOn5T0yHTd9vpmVRzYr7tGCMOu2cPMy9YuVrCIF33LUtStrDEuiEe2jZJegFSasmz7TcBPkVywuvXG66nziL4VrzZINgR6y+R5mhA0Ot7B7QTCAAn2grb0Boy5xNzTxd+HSp8alGIkAXVO2My/AF3SMNT4HxfUblf//1lpmY/XbDe0bwqGVjP3ufR5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace it with a check on the max folio order of the file's address space
mapping, making sure PMD_ORDER is supported.

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 mm/huge_memory.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 970e077019b7..a22bb2364bdc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -86,9 +86,6 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 {
 	struct inode *inode;
 
-	if (!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS))
-		return false;
-
 	if (!vma->vm_file)
 		return false;
 
@@ -97,6 +94,9 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
 	if (IS_ANON_FILE(inode))
 		return false;
 
+	if (mapping_max_folio_order(inode->i_mapping) < PMD_ORDER)
+		return false;
+
 	return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
 }
 
-- 
2.43.0


