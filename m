Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F30CD4F21
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1906A6B00A4; Sun, 17 May 2026 09:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 167F36B00A6; Sun, 17 May 2026 09:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056BD6B00A7; Sun, 17 May 2026 09:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E89DC6B00A4
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:56:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B09DC12036D
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:56:06 +0000 (UTC)
X-FDA: 84777060732.04.B163562
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011015.outbound.protection.outlook.com [40.93.194.15])
	by imf28.hostedemail.com (Postfix) with ESMTP id 008D6C0003
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:56:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ywggp+JT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iTkuVwAayFRgMWDzCX1iXk9uJZuvi7IfRjjsvF77/BA=;
	b=ZAuFExgO90uTEXVjfcSy4J44GXXA8by6SQHWthYKlS2JJVSn+PFLFCsqr9E5f3IQhKVafD
	vipuqYAy3RfJcDx/9nUZbD0siRcHsXWqhoSDl3EnCtOY8NmyolNYE60mTXmGhuqMlI4Pxf
	SgF0Rxw9xOZPKpEzoP/5OQLjcD8ijGI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026164; a=rsa-sha256;
	cv=fail;
	b=muB1rLxVuBKf/okJmxP/6MTM3YMo/NaAaRwxG9yppacGNCXA9yTEX2FFc+S4ef6tRDLK2d
	VgfBa1WQ9l/7LpBgGrp1+8Tijug4hmV7Y0gpzpgkNWq+ouqKsfBXhCokbN2DPl/Ym1pTs4
	Wm1FfmvkQ6Irkkxv09Hg0QYj6IkmSQI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ywggp+JT;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.15 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J1yvW7Vb/AHyxNpIUROkK9xsyKPNv0XtJfgBf2HPqkxmk4GFqj+dAlRZJiHIg9lhtLH924tvRbFbeq6Co1eQ0HHVuxrF2T976tJoTXGKFHyWgIEA7Bw8Z7UsMzOugylzN4fx03isaZNkPXv+ppQ9G6UgId0dPfkqGWIUxS5xYdwCT1Fnc8PfBMYTqvgmI3dzlJN0zzIchmEIh0/8WzVkVAG3ncQbKIXAy/6Aam8rxvF3FsqqgjkcCRIh3dzUVO7MKvTbQgULMvGoaFxamek0GMGGk8g59P1LUVDgp5GI8pOc+ClTy/OdZ7SJjri3w/AgjdEryK9YdH5sY4IoXYbUhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iTkuVwAayFRgMWDzCX1iXk9uJZuvi7IfRjjsvF77/BA=;
 b=oXRPYbmkaj/OUCjzGso60l8Vui82dU8QXBYZwehi/scyaCTr4xkS//3KSyHuQsI2XbHARmViZFPDS/ZAlaLYVTdJqkw3wVG0DFErDKkXwOVUWawp382DpSaQGQ6mdYGikvmi7brpJPbj6g/ScMB0LOx1mDd2tsYZpTzXggKi1Q2+X1Qu+pfhOF4l9lzPTvXnrUSB6bHLJnXxjUfKn4NAWYB9HH0vNqfoFXylYMxu3Caq0XNkl8f+U9yCoNLUkumBsQ0ns+tYkHppY+CsE9vY6WzZMqF8a6LFoWla/doH5781aHTSGDLEmoRs3qmNzZfFP+5dDf3I5xfAMwi9jCkHNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iTkuVwAayFRgMWDzCX1iXk9uJZuvi7IfRjjsvF77/BA=;
 b=Ywggp+JTv1Oe3pXH6bgv7XuBRXa3mQjeEToSdXJU/qsDysqnFv4bR0oKyxizGfjeIKOVbw2jQrCVTPGSElpWwVJFVNfZ2VxkhwAqYcqfvIulHDAaC9w9VvmqqOiIKXNeU+puu0lNwTGCOcVxhEgva5VYQDjSkbkDXosueoRpIXBDz2jsv0TTW7oUyH76pbFChzRtmEnSqoW9DtvRRj9uvHQfCkqKqtZ+3ApkINduJYsx6ABnl9OooGxdzhPv1bnv+fuvpMYE/oERW2VnvJXX6haYW4XZtPbVCQmffCbPfyAunaFz5hXw1kNBgVxbiilGTdDSRf5PMca2MGi+GCtqxQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:13 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:13 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
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
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 12/14] selftests/mm: remove READ_ONLY_THP_FOR_FS code from guard-regions
Date: Sun, 17 May 2026 09:54:14 -0400
Message-ID: <20260517135416.1434539-13-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR05CA0017.namprd05.prod.outlook.com (2603:10b6:610::30)
 To DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: 7275ef07-19e2-4980-15d6-08deb41beae2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	4k8pw3ZmMTS/JUQcmq81Z/qGHLhzkQR3OPxaIOKzfv4YK/HgEUql11bCtGxgMwkhcuofpfmhRYGcfsIgD3xZDof3e51tudRXUhuxf37jsshmr+FBPuQkh01wpMWWKLIK3sFuHbQCZUu8MUP39uAU3Esq0gY/wYBEe0yswNdILP/6owrgx9V6n4lSSCUw8sTfB1iK5sfAzjO2rxvhYq2+lrq7cizf24KXsXVQjf6IcBL1AY0aB03QLLVxEq2SMDY5zh5dnEvBpmy2n1W6hBTtMM7w6h2YEuPEpnBT6Li9OsEB612kyI5Yrw3QrcJ1J+Da2VhSTq7MYAxSxWlIyDT7E2X5oJBuR7zsSnT8ajcFZkwLikfefwE2vfuRm1FSe9lmkYCUAFF+N6ZZqG2t+qjZ4bHnE7+ltwEEhSa7IfVZDxIp9xuPbZ7oLBNcRVv/BSDb/vSnFlYAIUkW4A0momXc55uNXSbhgGDAL8RrrNWee3ZrZAWPd8vzVBzkkLrjnlQ8SolZ7R0ajdLO23SCKbO8ij65je7KwFLq2ITVR6ORC5/gAfTJ8N9zUtFGJi+yyAUP5ZgFzijrroJTwFfmQF44OzakujK9ifNrAdzgJM6RdkC2qvSL31WTAj4loLRxRR9GfgWNg2q5MQ91natCCWLEvgqFkDcIv/hRyl6PXHMmdlydgb4V9s1G4qPWxF7Dvfg1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/eKYREkqW9GTZdjOtI/Fz7B3Oox9z2QbdRlp5pPu+W3t7QomTpTeHMxstfNF?=
 =?us-ascii?Q?MESK6WLl2RWvKTvUJvfTcsT3M7nvsusWvDhriTfY2yUGA50OfRvjFWpokPDt?=
 =?us-ascii?Q?o74MvByZYUcEIqoPGTl0etIAH5oLDKu3ZId1tL33ykyT3bmN+rF9VOhQcnij?=
 =?us-ascii?Q?PMCvBrjiFDoLoLG/FEnmYkAMpsYsCzuHe7ADTtB6U3ReCpNduRVVcptiFoE7?=
 =?us-ascii?Q?MPO0Md8J5vS+/zbVU4PrmkZFihkaCr1Zpe3Mv3rQYHogj90/h9GrJZRrZj0X?=
 =?us-ascii?Q?lqr376okN5AZmCst9k+sQq4s03WhFRSquOMM2Heu89mPkDWMN2PcsX2vxIJy?=
 =?us-ascii?Q?oA99+FALxgr2fQjYdQF/46Zq5QrWD7Ce1xUKG39JwQbtU2o14Dpq5U5ydP47?=
 =?us-ascii?Q?DOPcgDTfnSfGp1c+wPhYpuuhEx34ecSBwQ/H154/CouRbsK+L2mfs7Cc8dDQ?=
 =?us-ascii?Q?s+Z6wDDEPVHHIgGbACvVj/eyqRDA0Pfz4x5tRBXlxf1ADFMERpF8VPLuBjHP?=
 =?us-ascii?Q?lktoB7HQsVSfhsFtpF3+x5PSFtauvUa5+GPMwyIT7ABDsWPBgwP/nINfJ3Po?=
 =?us-ascii?Q?bPqOEg4OjDJeaOlO4xioVmbyVYT6e48B6hI4eD8+yPyPAOEpMn/83pF6qtvb?=
 =?us-ascii?Q?kGEcudFZ+lPDsQnq+OiWFulNF4dDIKzhkJw9jvslOjCc8dsI7OOBysecHybL?=
 =?us-ascii?Q?wT62xjwmOSnL9GaO24OveOjinw5FiYTPsfX6C5yoI9oUXfmnj2Fvl+zWb/Zp?=
 =?us-ascii?Q?b30xUKldv8BjQdtVvlgAbOLaHgA4dpu4euf28AAYzYCslS2nsBAkYL3fHFIz?=
 =?us-ascii?Q?dYS52A9yRP+gABJEUGCwUtQgqnOgihRVMIOwinaMW/5W8TgOuqKzyapqACCf?=
 =?us-ascii?Q?Xt6tklH2CxINzr3ql9pw7XnsHQ1LJQLAF+Ys6BdWJEL+urVm8HYgm9rClJSt?=
 =?us-ascii?Q?+7kI8EZLW3dUbaAsGra+MdwPKX4VC4ZNxt/rh8w4Rvs4o5RfBvXPb7iFJtQt?=
 =?us-ascii?Q?Otc2BI6MBt9PAC9C1Ah/XDjGs45y5YJcOQYFIR5iuiCKNNKz0swyVcOJ3QU/?=
 =?us-ascii?Q?mssoRJiauMQKKZHvnTW3kcL5Ko398Zt0nDm9TBLbHD0hQNd8feFqC3JQi9Sh?=
 =?us-ascii?Q?eUW/J2dm+v8YeT4bKO38bGDeU6ErPwjGAqmGcen52gOcikScJsyTowUQcU7a?=
 =?us-ascii?Q?+sloX4ApLdjyazGL1MwZzpI52k2Sch6EzB1akl5is2yp9kYiczXixFLmTwTb?=
 =?us-ascii?Q?vE8ImXXqBhtRZ9lrYqXHQY6um5HrlI+DSnzgVWkqjNGLRcxis4shZWZZ/7xP?=
 =?us-ascii?Q?DcpBEoIhjhIy65HTffLog458GSAPrnCwaK8GfSu11prIzPmnGQRcAwDtppkH?=
 =?us-ascii?Q?vnBKU0705A/sITTmj+pC+4XU387pS5Y2yloSl9Uq92kSDYf0RE51RGeRmyfE?=
 =?us-ascii?Q?Uqwf9kYSauenG+H2c8QljngmyMhnSwvi4BaQQTYNZj/L7MFHuDEl5Lq9SLxo?=
 =?us-ascii?Q?6uCQzBASflRcVUx1Kqlr3sB8bPXqQjZikKDHcWt4ORoonr170fzL0RLe4p5S?=
 =?us-ascii?Q?xpuu3tEoYoB8UAcylo3zLRZwzIHyF4YfK/oQqdxNqzIsDzHRTrNAvWUUqTEw?=
 =?us-ascii?Q?Nmt8i3Lu4Qx4udx/vcA9VeIP0ey5AvSa0dTewVVfq4YDrlHAs1zYaNsNVQo1?=
 =?us-ascii?Q?54VftX1ld3r7O27rldPBlQrg07Uxa6H1ViBYSJ6R1+qQkwcx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7275ef07-19e2-4980-15d6-08deb41beae2
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:13.1926
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KLawt0Vg1t3TzyYYuDg+vRk2IfQu2hRY739dABhNR0R35o54/ZRXVaOjRmhRYJ2D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Rspam-User: 
X-Rspamd-Queue-Id: 008D6C0003
X-Rspamd-Server: rspam04
X-Stat-Signature: jb5r3mfs7iaitjzwckao9trs73khq9io
X-HE-Tag: 1779026163-460542
X-HE-Meta: U2FsdGVkX18nBgAnAjmEXubvsLlcrjMMKTKjTFheOUigyc1IP0s/8TC+0Pkz0kMMChPqc/Q7/SEUu3QjfZwaRpbvZyXq9wdZsSTJrToNUegNfLgHKh9QVe/hT3XsGw167pMoek6UmqId/688d1Yb07TCuyMJe3gYqRPcK6leskmKGYCZfnRdAsXGMb53TLeCyMHVHLGLFr/3i4iZvLXciPugTyibvfAmMLEm2Z4AdAPNJHv3ueUhDLEnJ4j0yWWsMi89D4V7dA5C7jb1M1qx13HieqzdZyykGlZ7RawxP8FNgSOtpjXmX9B33z+MJ4ppIPZiXTSxhmjXaSSz9yo0JgESurIASeTWXMJT2Lk4FPmLnFImx13dvJvXQ0J+jtPGb1xr5IxXZJSHoBh8BkqfK5kpE623aMe7kpHsRjeDcF5naA1rGRWYY8ve/b8e3+ZojAanfSzjYCLk6E+jruTRRkK/t2AZT7W/XdghUQ4mUWmQiVTQeYhkq0/pbPEv+wFwHx0paalpvvMRrGG7itnDeWnqnMqvuWgCPhIXuut4RTOsGzs7skACgR3z8z/rWgm9e6uXlHecpbCCRTTxw0gMTEYSLH4IVQLGbhrmTHIqtvGrDR/SEhGOLlnriKXmEF/ptztrekoU9psBERIAaV2bB+KDBSvxReRDZArzDUwTTXE0TqdECMo59ac7TZa8jfUtFYqb0JDhaTzCJvjBZ3W2aZPlhY05QkkAJNeNVGqHM0suu2X2F3IuCOpipHlIuIgvw732lt+ga5lQoyN1NxLRbdRNNp0VtQzezEe5p8lbNHjhUlhD/4m0EPYCxQ4mC21ZpnObxWWH88pC+M0ZZXHHtoa0OzXIvm3BV7TfJ/7UaA4ULnxMOevdaskhBLzoSilzdzh9gZBvi+HcHj0MlpPHHcPKAj8FXbhxy/Fq/4HeBN+W+3g0VNrpybNXzgCCJgel/ovj/zs9RY1epVhZgSS
 mRaiaxy8
 ClE8gqtzFP/fN6p8I/g911s+wK6t+NdKgCP/4Wr+8mMIbhYmB0K6UK1FBtP42NzD/+MEn1Vmk/NPURK6nx8Kc2dHczjh48qT2RI34v/TmgT/knvY34I5olPL3XkC2826M+EjQaUUu7baJ1K3PxlDw70zx1OkMQLn3UTyA6GHEKx4BDGKJ7+0frlHCktvUQjatju20xN15YOcOZjdKACuCTPlPDHFd8BX1o1gksuX0xkswXf4de93pcC4Je/reCMMT3VmzAbQdzmwl+Cf01ogksf4C2V21kvujeRPHjbzR7hRr5/uG698wo1s7w34qsRzYfJi1NWKF0PNl/tlJeD9nf3AIni6R1JMp2J2bqZ7MNWgabaA/e1JegjFpOS+xljq5W9bRDhm3n4cOAaKzxFzeENzqoi8+bZ+C/uoYd44V24PBsSPBXJpjvvoJXE+bATVdNnuXAkdSKx0oYo4j/HAnhL/8Ir7UlVFnHGjpvcm2diOtCNs1UoyZ+Wqbk8nKEUMFQ+GRLE2HqHon79L6Eo1S64xr8ugLDVZjZaNcTETAgWBerCSW9r5//PluzUDo9OWfq/uxDfQW8GxTgteSeDNTtsXCp4I2WPJDQEY9daMqy6pqlIz18RjCvntBcxmKcFSXnRDo2oRcGJQHTRzOU8gr8FX12EqxLXi4TYqmf8JYkfcoSdkDs0M0TrpDERxd1njcmKAViLwAF5EHbETGiuyVjVUNLZlxVc0OlDNBeLunwqKQfklAstaaHvu1uVxVZGZGP/knL+6NcRTm2un3ycQ7OeKw+pzuq9e/8dP+3YTzHswOJe1h1PH5pXeeuoQ15NmT2Y4q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Any file system with large folio support and the supported orders include
PMD_ORDER can be used.  There is no need to open a file with read-only.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 tools/testing/selftests/mm/guard-regions.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
index 48e8b1539be3a..1176398919537 100644
--- a/tools/testing/selftests/mm/guard-regions.c
+++ b/tools/testing/selftests/mm/guard-regions.c
@@ -2203,17 +2203,6 @@ TEST_F(guard_regions, collapse)
 	if (variant->backing != ANON_BACKED)
 		ASSERT_EQ(ftruncate(self->fd, size), 0);
 
-	/*
-	 * We must close and re-open local-file backed as read-only for
-	 * CONFIG_READ_ONLY_THP_FOR_FS to work.
-	 */
-	if (variant->backing == LOCAL_FILE_BACKED) {
-		ASSERT_EQ(close(self->fd), 0);
-
-		self->fd = open(self->path, O_RDONLY);
-		ASSERT_GE(self->fd, 0);
-	}
-
 	ptr = mmap_(self, variant, NULL, size, PROT_READ, 0, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
@@ -2237,9 +2226,10 @@ TEST_F(guard_regions, collapse)
 	/*
 	 * Now collapse the entire region. This should fail in all cases.
 	 *
-	 * The madvise() call will also fail if CONFIG_READ_ONLY_THP_FOR_FS is
-	 * not set for the local file case, but we can't differentiate whether
-	 * this occurred or if the collapse was rightly rejected.
+	 * The madvise() call will also fail if the file system does not support
+	 * large folio or the supported orders do not include PMD_ORDER for the
+	 * local file case, but we can't differentiate whether this occurred or
+	 * if the collapse was rightly rejected.
 	 */
 	EXPECT_NE(madvise(ptr, size, MADV_COLLAPSE), 0);
 
-- 
2.53.0


