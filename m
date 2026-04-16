Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E95FF8D746
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 13:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA93F6B0005; Thu, 16 Apr 2026 09:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A810E6B0089; Thu, 16 Apr 2026 09:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FDE6B008A; Thu, 16 Apr 2026 09:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 851346B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:57:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32084C2D07
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:57:09 +0000 (UTC)
X-FDA: 84664570578.11.47E315B
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010056.outbound.protection.outlook.com [52.101.193.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F449A0011
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:57:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="dJp/Vw8h";
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776347826; a=rsa-sha256;
	cv=pass;
	b=3BK0GHvSMjzAPrX6+HlvgWPuO3GXjn0l+51wSxonYpyZh1jLNco3Sr6QL+IMvWtzYy+CZS
	Fc8B7Z3hBHhE3PjVxd3Wzf4l/aQSE6rK12V75AY6Tlubr67bzw8ec7kfBHs6kXXYIQ4Jzw
	sKoTGTIC1st3i8hOddTynSD4oWJROEI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="dJp/Vw8h";
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.193.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776347826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdepszNcjxM6RR+RmvKieMDmDfCnzB92TJIjMk8oguU=;
	b=cwOHdF0oZWh/gwVyRe0Nbg+aj9mLXsZZbO2cU9P8dFGH35O99MZfQv24xOPXY7I6zpQ0us
	EU0ydJXZHtfm2+UTF7Og5O81t/G0QfZS2I66n7R5IPsgGwFjU+g+s6WvfA7/0SLL2SxoZs
	Lmozd5NbrZG1JA1eZ+Q85t5ZxgPxDC4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J/mlO5mYVa6kk/svTly/ynt/RAwTx4kiMiHSGTMjkqrjHT+4oxUiXnSvNK+qgvhv1Tx6cL7v/hs8VBbFk7q1Yd12cjder/2FyyBReRLtk+5G9/N8pUf4VeQhg3enZ5MpPQ11CVn1ACPqLYSwf1uQ4D6QTCjJa5ClbqjbYXAxuBwN0yIbu3IN5X56vdUxHtfe1E0vOa8LQ9mv76ypmpKVkNVFVnfWXXxWi4/OybYl8ZLSZPe7Z0Mrq+B5Yn7d1Z7vdOLAGLfKmgIiEgwgtSqeStAT1mH2nIj0+k9Z+rnZSt0QdeWlN58BDFjqvkl9ggrUQp9l+Yexvz3RzioSXYPQmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdepszNcjxM6RR+RmvKieMDmDfCnzB92TJIjMk8oguU=;
 b=AOiX5ueHuFS4xe9wEvjhJ+vI9dWDXAXAaDkZcNTISAM2FZdYQwqzsHXFQ0PkfDaiwUoYPm2o/kkIRbhSGK8tvx9bBYUMnumrFB9lB70gbZTCuPqXzV0dcXWIb6tjhbhOVX0dcQsiqviDdRcglT7rAeQlk5IKZIzaecOLE1HT/oglKFa/unKcu8pCGA4qjQ8ZWq6oH/tgvWsDJN92YZuxSJY1h56SeX2qVJvfDA+/oLtMqFZddwE+1bIg1IvTwFLCW1Gu8aUTMwDPYNjVUQBjjmW1Mi9c7+sGBcv+i/6kY26rCrvnMFiTSkSQ1TH0oDq6a2bv1dUbQBcCYGIwpgGKNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdepszNcjxM6RR+RmvKieMDmDfCnzB92TJIjMk8oguU=;
 b=dJp/Vw8h7ra6ftHzMuWTPFn6kNqFCKUlJlFa9e5f3rOj9BS9k9ym9Bfsy5F+T77KD77T81d+cIoyQVTNsUeNuDXW3SHf6pMuDmHlYh/UjHgcajSwJzuWj2zCSGfTMq/SCzxuENZBAozObhpPZsUM/MlEGbo2lwfnyvzyPpBpbcao7QcWNisiA2bxRQXz7Mfqm/3VVjXzzjbeX8bxzZasDWnv/Y31/zcXilZUSFtGBzU6zUGSrUohLN1jOjXMPrJhqIhcYy3TJDGJ12bRMdbRDOa+ufih3HDFcqJpocOX3SLd4lP4cXjV/xSqdopY27/Y78+vtz2v09RQWFqfnOQMjA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 MN2PR12MB4175.namprd12.prod.outlook.com (2603:10b6:208:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.34; Thu, 16 Apr
 2026 13:57:00 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9818.017; Thu, 16 Apr 2026
 13:57:00 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 05/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check in hugepage_pmd_enabled()
Date: Thu, 16 Apr 2026 09:56:56 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <7267856C-FB66-42A8-AF5B-F31C0DB1F581@nvidia.com>
In-Reply-To: <8d95a9ad-4c85-4b8e-8724-af843e1b7859@kernel.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-6-ziy@nvidia.com>
 <ad1TMjF1L3usYIC5@casper.infradead.org>
 <05F00072-7E06-47C9-BC26-FE3736F557FC@nvidia.com>
 <a4d477a8-71d8-4219-9cb3-153f2c01e184@kernel.org>
 <84B8F641-A3DF-4219-AA57-6BA48E9B4998@nvidia.com>
 <998c02b6-2612-42c1-8099-d65ae275d1a2@kernel.org>
 <7468C68E-FB09-4714-94A3-4BED63453295@nvidia.com>
 <b7aa5515-6908-4ec6-91e9-eb79d5ef70b4@linux.alibaba.com>
 <afe0dfb9-feeb-4243-bc4b-305e5e33b581@kernel.org>
 <38697379-cbba-4c64-ae65-6774b01021d9@linux.alibaba.com>
 <68F85F77-8EFE-449D-B643-AEEB38CB50B2@nvidia.com>
 <8d95a9ad-4c85-4b8e-8724-af843e1b7859@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9P223CA0004.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:408:10b::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|MN2PR12MB4175:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a1b7ce-b2d4-4f15-214e-08de9bc007f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bw3vylpVxyRJoJAwPKLb2YKXr36YTyO5Ue+EOTzqclEI3TRBm3LfGdYz6sGmifReYQkKLXhst4ZS0+AgbBSqrcGcgpmCDoWM2B04dajDL8Sng/QIWNDrd2ACLtNfoOx/1pXNne2aMG5ltotSDQlGbJcYua5sKe6ETXTMME5KK/ANgn+YnK+1sYnU0KEvjBFIta3FckOidSQtfZRzf8dpvBJ2Y3p5/q825/dIGWQ7z1xQrYUtqFczTMe/qIBXt5k8afG/DFFZ6kniA4JM5bhv/LTilIAX5HTCjExPuwgfWKbyjznWN7+2zYOwIZ/juw8jcHzwyeAjUp9KCBp1OVsyen3Jh6dxld/a2DQloDlHgOzdmqPlZDthWwmoTGx6HbkDnCkAtHaNHCwbyJ72BcL0s63268PICszVXyWUhmSaGcmAkbWTfOg2DQIWB21dVyGVTfM6PRuGJOpQlYCl/OM3x05Be8f6A0zY4OKbVEshYFpF9sWN3xjWxC8r5wIMvao/BWWScHfbKJBVOUkdOPkiKVA2w8I4BiUgz1HOV9ouI3kI/vRDRPUc75TjdAL/H7ny1XA/BRKKu4tu0n6vtRVe5Fc25IpjUQ6S8DQ+wIdjFzhj0Ob2UQMOQJRIgC5ajNVl75pu/QfQZ7tN7l9pmmaCEp67D+ypaNUwZdN3d/dvSn1QyX1AGQMAno6SZ1PKyIOVlw6QNMPxniCAUtZEoQjjBJQgdjIm4AiYeFiCx9OUJpM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q2IzcjdtdzVkcm92MmU0R3I2dkowdVJrVU1uUHk5eDdTMHY2UDNQcnIxN0tW?=
 =?utf-8?B?ZGVXWmNwOEF4WkpzNjFwbnZ1ZDBiU05zOVRSZWRBejhpMGpaZXZQTFZld21B?=
 =?utf-8?B?T2oybk95WXlmWUJtK3YrbDBhSFBYNzJqK0oxT2ZCRCt4ODdIU3FOS3dvS0xi?=
 =?utf-8?B?Y2dMWk9iSXFscnB1TXBwVktKdmRiODVNU2Rsd1Q5ZE1sNHpUQWhOUUVSZkVr?=
 =?utf-8?B?Vlh6Y3V3U29ZZHliMzhYQmJpNzJkbjZxd29Ed2NIdUovTWlqaGs0Zlpzbzdq?=
 =?utf-8?B?K3NUMFhsSWt3dUYrMVFtTlQydlFMMGxPalIwRElNSy9GWFQvRS9lWnNOV24x?=
 =?utf-8?B?RTA3M0hSSm4wYUxnM2krbVJuTGpxQkx3K3BCS093Nm1JeEg3WkR1ZXpUVnJ1?=
 =?utf-8?B?a0x3dENkdVNna09yTWFJMEZHY0RNNWZyRUozNEYvSjVjczdtSE4vUnRsRVdS?=
 =?utf-8?B?b2NvN2k0QmpxZy9zZFJmVUduVGNDVVB3WnptaS9zbmo2Y29xUkxjZVFIUmd5?=
 =?utf-8?B?NDZ0WXRFYUFndC9EY2h0dVI3VW9LTE0yL2ZxSmRCYkZIeksyK09XNXdWYzdz?=
 =?utf-8?B?THIwUWxqSzhKMVc2blFqU2xnNnA1ME1JUzBMbTZ2M3RMMWM2bEh6U2lHbTcv?=
 =?utf-8?B?Q2h4TXlXbWQ4dEdTQTQ1RXR4RmZwU0gxNlBseVlTZ056a2hpQk1DQ1l6R055?=
 =?utf-8?B?SmlENHpHckhJWjJ0WVMvRllvNWpGUEsvYVNCQzBoYXMxRjZreWRkWjhCSlFX?=
 =?utf-8?B?RjJqUCtNZFlUSzRMNldoZ2VzVHBpRXFvZTA2Z2oyVFVFUm9WR2Z6UWozVXRM?=
 =?utf-8?B?SGw0enhZOVlHNFZRTjQxYmo5TGtZS1YxdEp4ZjFXSkxtZXlPZWExMHcvcVl0?=
 =?utf-8?B?NjNtanhqTlZvZUhJWXJRWVhkR1lJWXJnOTNGR3dDRjBhVUxuNEtmckxvaHZF?=
 =?utf-8?B?a3JxTkdsb0VWVWlISjV4cVErRzgxeU82UndwbDdqMFl2MGtIajJSZktiNlFn?=
 =?utf-8?B?UDlVMjFCeWFjTDJVd1p2OXJabGVwWnk3MGJ4eVcySHpUZ1h0VFozam40U1FG?=
 =?utf-8?B?RndESWFXbzBtcXVMU0lxaCsvZVFjSTlMN1NXWGlxZzFCTmlaUmJVT0Vwd0ti?=
 =?utf-8?B?dWRKZ2dCZThBVHRLWTJuTXNENTNFeVlZVkM1VUxQc3l3c3AwQTltbk04MUxI?=
 =?utf-8?B?ZEFURGpNV0hKZi96b1ovY3lxVmJkVXpwdlhsb2M2OUM2SHo4dDczR1IvSHdh?=
 =?utf-8?B?M3o5YUxSQUVTUXZPNERZbTBlUjh3MDZ1eFNJNHpyc2M4dmtEb1ZQWTFEMGFL?=
 =?utf-8?B?WXR5Sk5CT1J3WXdRazJZMVZ1ejRmVTdtSDY5RmVaV05FazhMQmFtZ0pkNkF5?=
 =?utf-8?B?ZGNIQjl3dHhIMUpET1ZCY0V4TjRDWWJWTVVuMDhpNmFscXJuZG83eU5ueDB1?=
 =?utf-8?B?cGRHZUFtYlFYUlRCcGJ2bHVlN2ttT3BYSlhuWmU0QkpZRkNsZW9hS1ZVdkRi?=
 =?utf-8?B?di9MUVUyb1ova29RU3lwNXhCaStzaGhHZTNkQUlTL3FNaTNmeWRqbnFxVzl1?=
 =?utf-8?B?WVJ0ckdGWThkTnprZENldE9HWW5uY2xJRm1wWHhhRXVwV3NuYzlIY1BVYTJX?=
 =?utf-8?B?TWZVTlhwU3FPSVNIblhJcGs3cEFGVlV5aTBFSkxQQXU1b0pDSWxkTVlUbkgv?=
 =?utf-8?B?ZEZUMXkycnJ3THVxTkpCdmEvZ0t6TjRUNk9kVnpobWpsVFIvMDlPeGpkaUF1?=
 =?utf-8?B?c1VHUjY4dDVUeTk1K0E5MWExSnR1WVoxUnE2aDZiSHZ4a2dLY3JheVhlMUxD?=
 =?utf-8?B?eGR2YkMraWdEdml0OWdQSmYwWEtqcHVsN2JxbjhRZFdZMUJZd0h2M2xKREJP?=
 =?utf-8?B?K3JDTCs0VUZxUXlNNVM2ZlBaNWdNbjBWUFhyU1dRTG51QkFjUzRMRnRmUUlz?=
 =?utf-8?B?aTNNSDBMbWt6MVA0blphSDFTT3NscDNSdWtDaFRTS0M0Z000b0hRUSt2L2U1?=
 =?utf-8?B?TjNJaGNhUGlrckIxbTh2TnZNbkwyMmFPeVhMMjlNR1V4RG9tSFgrL0NWSWJr?=
 =?utf-8?B?NUFtNm9TR0xrVy8yYzhobEdjempBV3g4eE93UWZIU1BkWGo3QVhCbURRS1JN?=
 =?utf-8?B?VTNMK3J2cDFIWG9ya05TaHZNa21mTk9GTE9KQU00VVd2aGxuQzZEZi8wL1J5?=
 =?utf-8?B?WFAybitOQVh4bXY2N1g3Ty90UEFOK3JRZTN5N3ZCaGpyTUpGOXlTazUzZ29r?=
 =?utf-8?B?RnNUSGZ6NnhLOTFGUWhCZGRZYlBrcDFReU9PV2EzclhlYWlyZTQxckN0RUdl?=
 =?utf-8?Q?n7GFRFmUp4V7iSt0YL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a1b7ce-b2d4-4f15-214e-08de9bc007f4
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2026 13:57:00.4033
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yaWKieiXfYphwfVhhjAylmrXz5jicLWfhHM572pKiYOyM9NZGBbMLrOHjWFkHimD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4175
X-Rspamd-Queue-Id: 2F449A0011
X-Stat-Signature: hwmimyn57k93w96u9fsrscaudsrn5rbm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776347825-980934
X-HE-Meta: U2FsdGVkX18v8B2oHqYHwilFJldXdySBgPdVcbLae56YT/HvNuoAB3DUV8RQpi1IUO1ezcNM6yZG04wgWh+TpRPqoluLVS4QFtWonTJFE+EJrY6WsYUFbe0tLnPhluCqKMDnNH+Li/awcU3AyGVQr2PKsqQplkRyQWlBKB+8pJsDLLF6sMqom3ojj4azSGXShdxwXrKBghwiFlSe65tBRHWaRPl+0bo4Tp0yhkg2qmDGHBHG8Ib7Cel8N+34J2Te6SR3PgBf7fqo+5kZPh6v324q2H0+60lunFbnvVE+OvHR4R4TjERvdeXC2ZJyqzEUQtFTqF2kTyq9GbNDHMPfX1nfOhuRtMhQ7/myQvF7n4Acp4gtwjPBjb/Aio6vGS4rdFrKgc6dN1DLoybYyz0BodHcMmHFFtIdlu4K0/PDnDBHeoacQmY5fo1y88bzlhTGCQlsT4xlpSX8K+aZEWC2w0NRwFytUvySriE6xfYPJAjbl8ZfZgrZyFRlouC8ekBPXg2JEuD/dETymF9FpwLeA6n5aSzX2XrtzL4PfWxAzpWku2qs+FwfClgJ2K0Bwu7KomlFH67k+CzAbQpcYtqhi/ZBYX6RVUivuuZ81DGcdreh5kGPPGlA4faKzIBPR84LcZJa8+PK6zs5BgKKDiQ5aTmgyOPM0mIxUkaDXv8ipvhWkOnaTov+BrWbBbGQJrY5CMTfsc2CIiqKVTwazRy245mB/zasb67mPoaGOSRneqOby3I0K8ovUFPcHgOftq8fkWCAxw0ncm6/gG/tsiucjQYWM0KqbM84RiUQWZBHmBMiFnQHJCvfU/aMFP3U48j4R2bovrWWjYDwyLQGqQjH5scYCflpbu+5qyEN4RAhG/s6B3EHygDzzDZmm6xxLp1NrcoYnyTMtZPGsJwB2Qe+AHHNZ3TBpPOAqsP21osQ3SZDmmCuvA7ao/37Gd6eqyxgULm6So4gD0zctGGA0mg
 R6woeyxy
 Eyh2e2jiVK1mNZm1sLcMRAFt+QrzkZS2k+JDOwOk5hquU1iZPUg8d91VYNi6gZbcAarpXsb6CZ5OR3JhIaKxQQ3PVtvg+lN205VvxlPOv3FTC1uWDmTyMgG5XDGuqFFrQPO70xk5WA1eq13TBAz2+aLAUrZCVQmKc77vkcApY0N7VIH6Qg7feqha6vCOYFbJXOT9RmWfB2V57J4s/xgM+mjc0n17y46Ac5zvQmYGBJ4YiAp3w9so4ryhF/v3ja5hm55JtZHUvHiIRDlfJEUADkxumJujhpgvJuhQhCcIpv0p8M9TXakD9+Q244wMlRYEFLPPxsjniU9r9FRTRqlP7FZ4v1m3k0lMtZ5LMcrJNimU7zU7ePLF9OCuQf1rTIxEvTPReEHB7zHtDDWX1avK+MgIaE6tIhyu6cXVVDFmCNbZyP6P0zUsqbFmHcQCek4d+dkGB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16 Apr 2026, at 4:47, David Hildenbrand (Arm) wrote:

> On 4/15/26 20:01, Zi Yan wrote:
>> On 15 Apr 2026, at 5:21, Baolin Wang wrote:
>>
>>> On 4/15/26 4:00 PM, David Hildenbrand (Arm) wrote:
>>>
>>> My comments are in reply to Zi=E2=80=99s comment:
>>>
>>> "I think hugepage_global_enabled() should be enough to decide whether k=
hugepaged should run or not. "
>>>
>>> I=E2=80=99m concerned that only relying on hugepage_global_enabled() to=
 decide whether khugepaged should run would cause a regression for anonymou=
s and shmem memory collapse, as it ignores per-size mTHP configuration.
>>>
>>>> The question is really which semantics we want.
>>>>
>>>> Right now, there is no way to disable khugepaged for anon pages, to ju=
st
>>>> get them during page faults.
>>>
>>> Right.
>>>
>>>> And we are now talking about the same problem for FS: to only get them
>>>> during page faults (like we did so far without CONFIG_READ_ONLY_THP_FO=
R_FS).
>>>
>>> OK. I=E2=80=99m fine with using hugepage_global_enabled() to determine =
whether khugepaged scans file folios.
>>>
>>> My concern is that for anonymous memory and shmem, the per-size mTHP se=
ttings should be considered.
>>
>> OK, I misunderstood the meaning of hugepage_global_enabled(), since per-=
size
>> mTHP settings could also enable khugepaged if PMD_SIZE is set.
>>
>> I will take willy=E2=80=99s original suggestion and make khugepaged on i=
f the global
>> setting is enabled. The below is the new version of this patch. I moved =
anon
>> pmd huge page code to a separate anon_hpage_pmd_enabled() like
>> shmem_hpage_pmd_enabled() and cleaned up the comment. Let me know your t=
houghts.
>>
>> Thanks.
>>
>> From 92b92f2b2ab41c70b41dd304ce648786ee6a1603 Mon Sep 17 00:00:00 2001
>> From: Zi Yan <ziy@nvidia.com>
>> Date: Wed, 15 Apr 2026 13:52:50 -0400
>> Subject: [PATCH] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check in
>>  hugepage_pmd_enabled()
>>
>> Remove READ_ONLY_THP_FOR_FS and khugepaged for file-backed pmd-sized
>> hugepages are enabled by the global transparent hugepage control.
>> khugepaged can still be enabled by per-size control for anon and shmem w=
hen
>> the global control is off.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/khugepaged.c | 26 +++++++++++++++-----------
>>  1 file changed, 15 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index b8452dbdb043..586d27ce896e 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -406,18 +406,8 @@ static inline int collapse_test_exit_or_disable(str=
uct mm_struct *mm)
>>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>>  }
>>
>> -static bool hugepage_pmd_enabled(void)
>> +static inline bool anon_hpage_pmd_enabled()
>>  {
>> -	/*
>> -	 * We cover the anon, shmem and the file-backed case here; file-backed
>> -	 * hugepages, when configured in, are determined by the global control=
.
>> -	 * Anon pmd-sized hugepages are determined by the pmd-size control.
>> -	 * Shmem pmd-sized hugepages are also determined by its pmd-size contr=
ol,
>> -	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
>> -	 */
>> -	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>> -	    hugepage_global_enabled())
>> -		return true;
>>  	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
>>  		return true;
>>  	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
>> @@ -425,6 +415,20 @@ static bool hugepage_pmd_enabled(void)
>>  	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
>>  	    hugepage_global_enabled())
>>  		return true;
>> +	return false;
>> +}
>> +
>
> Works for me.
>
>> +static bool hugepage_pmd_enabled(void)
>> +{
>> +	/*
>> +	 * Anon, shmem and file-backed pmd-sized hugepages are all determined =
by
>> +	 * the global control. If the global control is off, anon and shmem
>> +	 * pmd-sized hugepages are also determined by its per-size control.
>> +	 */
>> +	if (hugepage_global_enabled())
>> +		return true;
>> +	if (anon_hpage_pmd_enabled())
>> +		return true;
>>  	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
>
> BTW, can we please provide a stub for shmem_hpage_pmd_enabled() in
> shmem_fs.h such that we can remove the IS_ENABLED here?
>

Sure.

Best Regards,
Yan, Zi

