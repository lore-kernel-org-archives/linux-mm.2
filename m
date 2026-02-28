Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F034E1048924
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 01:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFD126B0005; Fri, 27 Feb 2026 20:08:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA4E6B0088; Fri, 27 Feb 2026 20:08:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7ED66B0089; Fri, 27 Feb 2026 20:08:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3B406B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 20:08:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 546481A0A6F
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:08:24 +0000 (UTC)
X-FDA: 84492079728.19.6FA5CEE
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011040.outbound.protection.outlook.com [52.101.62.40])
	by imf26.hostedemail.com (Postfix) with ESMTP id A0B7E140007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 01:08:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UKhf/9dt";
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772240901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=iJTElIUfz4ezm7NxO6OphCmGbdnNbHLjBP6OPeWDOyw=;
	b=0H3r0g59+lZj+8n7JhbeoDbrz0b2G6gWRa5MsSTyli2V2lw8vfmo1t9UdAKtm35KrgsRDb
	4TMqS4xOXCtHEGIj3ZTu36FMwvbxI0Alf0PRq2ePXHfOS+TZkrISboOKiA0XJRUf2A9cvG
	NuyTtB4kGbhAftAiAr/CrNDE87wn8CY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772240901; a=rsa-sha256;
	cv=pass;
	b=DH2j5pe0CzooJtHiAbAmfq3/QjVAdTh5GkZRj3Hp1WhhTC3ptmzc24xW886HsUb1pYd8cs
	LL8+nlhlA7um3Me5Z8xXYTI1HZofXK/BIaGLV+OZLs8Zxy0KSXZh//oVDevm3tUn9/4PDm
	YIRQJFyIoPyD+SQ7qa8yK9EZSDMA/t4=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="UKhf/9dt";
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.62.40 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dWNy8XEnBQ9ab31f5NSaeCRfiRwCGRAypTh72FuFw84jzIta/izSI1j5+jFjTLjLNCBDHMMFU/YPqeLb5BBGccWP4SQemS63tCLHb/mCjCNU7W4dpxW3HUb8JO64qlTC4mpKhKtNAWVIoUjUC3yiYXYm9hO/qqnKvR0Q+YfDeOB6yMsJPt0Qe6D3ZhMnTQ77jMRoPNVmCPhjc2d7hzzA/teXhO8W82a9gcOG5v35wJe5nj0Jg1faWU+ab1U7JcvEZD/PZIg6lW8wHx83SoUdc9r9PBjnjL6MT5x7SVkj7Dy9vmBtErOsNoFi0Rct7Bs/0eavt4sJm6Oz1slTQgfOaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iJTElIUfz4ezm7NxO6OphCmGbdnNbHLjBP6OPeWDOyw=;
 b=CsqCkepwNdWT/6jio8NlzHnJV49FqTmesnhvRF/MoqrNp8e9j0A3cc2uvmd3alhD+lk1PTPhkrPrjvAdG7198FhvitFedbqK+WoCXIY158ePuXzi65jDFTHT57x+Qlw0Z+jvOZVKwkMTCbZHVeWquVNBxdofnVNKf67virjeX9vZ0OVoFwb2JoRvp7MyDILFqhIOIN5ovVxPMX3VwqvBTdY9CmNjGbZZnjiDPgBcwfYVVs9/G+k161XH9IziQHVXhyJlWsAvFWLtAj7MdZCJeWMuJJjg7Iyu3xv1qOhGfUcRrHJxtpbfpdZZxb0RTulR3MTjmIXHwG2FG2cdMJfukQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iJTElIUfz4ezm7NxO6OphCmGbdnNbHLjBP6OPeWDOyw=;
 b=UKhf/9dtL5q7v5m26eZEOO9ArjCTc9vylrG1y9duOwYRnkJ+i3BHugz6V875t/j+pTxTqc/RBsf3S/tL/wOWDNKF/MiCjoPjawb+XQlaaHoCCTiB/S18rLKZG/rTDBpFOD1AzO0iRQV5VjIXs0ca8fBEa3PPUsh61WyGzrhAnWyTjygnQAuot+VN/TLAYahrYngnAk2onsFpa8gPe6wGji9GcdPV1fLe237iKjys97p8skXHy0AKpX4Dr38mtqyHQlXTKOXa9gs+7cObLi67+kH6QFNWefKfDix6Q86MX+xM2RztbVMUnVYJt1EPoU+uFhobcqiO87WIKP5EJNUiIw==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SN7PR12MB6816.namprd12.prod.outlook.com (2603:10b6:806:264::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.11; Sat, 28 Feb
 2026 01:08:15 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9654.014; Sat, 28 Feb 2026
 01:08:15 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Bas van Dijk <bas@dfinity.org>,
	Eero Kelly <eero.kelly@dfinity.org>,
	Andrew Battat <andrew.battat@dfinity.org>,
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] mm/huge_memory: fix a folio_split() race condition with folio_try_get()
Date: Fri, 27 Feb 2026 20:06:14 -0500
Message-ID: <20260228010614.2536430-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SN7PR12MB6816:EE_
X-MS-Office365-Filtering-Correlation-Id: 367ab079-753f-44ea-1c35-08de7665d9fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	VcicW8mpbs4JHHpU9YAXxo2/1DCLxg0WBR/mm5bLDEbKQEEQpz/F71UlTfc0dCTKA7/a4yk6o8VKJJQs6Zz5YDB2hK2oOsYRZKHRiJWz7roW9NXpoXTEvjAM/JwIrp9rhuO0TVE4d6fv/KFbFHjfW/qXL80xMx7RiVI4W+5Frn+VGQyjvcm+pa+fqt1HFQE5xyOe8+5KjzrmixJq6fpCPB/oUd/qP3uK26xbxGGrxD6C9eLzKZ56D/uJpA9Z/nMhktzY+oeYOLVt4E0azcr3PPvkizgZv2tBTsGX79VUEvsorOnZS+fLrjV8NeYBOqKrthqeNn+o3sIYAs+B901P/S+kCZ3dTU4J37fAgXPCbIcbIpfdSMJBb3qU7esfcQosAm6M2zf3kERkKkrr2prJvKMMJ2nh7yJrWZU4xanXTPGJL8Xojx1kUUr/4w9CxX9tVIjhkc6uJNX7tnvtzbQLy/vtEINowXl4uEsTkUrZvlGHqaPkSRHKfADvFgAZ77cZdE4mJGCrgThtYr2RPRTS4+vXQj8zeJjYdyaa35m4T1XqS2rud7GGdrDsYYvBShsD4wwFHNDjdn6D33cqQHNeDs4EQi5yYk7kmc/qF78CthXvMU+FbfPHsIQlfCxlm2DU2t6UZlocCnfC7V7Lh6mml65cP5GlsWkCSeBJJNS9zqyO5npaElXwhx/ImloZ7tyD9Dft6J5YAe5dqUYCaOc4EeCjUwbh8uHZHPpDhPyDKxU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TCpq8VnFuQSx8EiHROMCG1eIMXbMlrOHKt11mnx/YBvqdFf69zbH6JSeESo4?=
 =?us-ascii?Q?WuDZSIUXEGI5rNEXTXKufr2xnrszjOtMsehjkX3VOEF5oTInW5OwLYfGdPW3?=
 =?us-ascii?Q?wAW3KXWi669qaUnzuZKSD9L+ZlTiECL8mwEkxV1C1HW0+lzCxlprYqVtmM2H?=
 =?us-ascii?Q?X3YQmoQmmbn6+t9LnIoKt26xTB89kFYCOVw50k6OPf2rMmQ1jCTHjWNuBJFN?=
 =?us-ascii?Q?2EtDVxJyamJFbJ0ZiwIkBFtI37ZHNMt3xvpOhL4z2OaLGMgFm7MAriHgX+Lc?=
 =?us-ascii?Q?3NqepfZBQttiCVV4C8Ao4OIOkZo+4oLMHbQxeNtTQjFxdE74hCPq5alds4I+?=
 =?us-ascii?Q?QuY/w2pO42nwgc71F3iQz6H8yMUYdlQfYaL1Xp/xbSrZPE/06nlsm/9JFxqp?=
 =?us-ascii?Q?AGUWZfTndugTRKdTfCOPfdOQ9QGpWaj2LjmlKaZiHDnV3MobqDycPOtomPPV?=
 =?us-ascii?Q?3grhUpUjmXklYzHoHY0+6PnMU64LTlHAxqjcKyL4LCWPiZp6RW8yGBRlerfe?=
 =?us-ascii?Q?5x+uGCgjD0JB9SOnlObsZNYH5ccEIHx1YqMDA6bJBcGzKeYiii3Iai/oeCu8?=
 =?us-ascii?Q?2dLV4hoswpu8r0tANU7NYvu73HIlilQ/2juRoDg85MGSq5/xA7WM9EDtxU8y?=
 =?us-ascii?Q?OoWi/CpYtlxVCndv7PtKsdAnDVcxCBNLxeW+pVuABbCjyAmAuAYCI7dFiAB8?=
 =?us-ascii?Q?r36+H49wkqQlSPWtL/c1adxoHdqLNnvtKn1YeaJtegJgKua3hwTR2nvcr6NJ?=
 =?us-ascii?Q?ExbuQ1TgJe/7oYHA8Ic+Mz65DZrxOomKlqXUVEs/HMPB8LZ5u4nWTwOVaWQU?=
 =?us-ascii?Q?F9Ji8oYTgUPkr0K08dmRVuSWG3b2ycpmqBxrPlk8ecqV7zq6KDYsNoWhqAVj?=
 =?us-ascii?Q?sr1jLn2+QnAdqDwhTpBKOv35BoaaFQYWoK/rCtEkPv99hPXurFLSJAb9jyZS?=
 =?us-ascii?Q?tDVoEen/UX8blak3Qbidom9OwY5a6z2vAnCoRVTXSZzGLSLfUJXWvfVdVAUJ?=
 =?us-ascii?Q?+mNFtuNHhtjBRlD7IhgCBkttrmwns7UNs4JfPFgq7eoVCDrGjszdwEN7PEY9?=
 =?us-ascii?Q?GrpawDPQ4INV5bow2KtTg/SruBxeUTDJdSubR88UPXEyzIAZNxyZL+PUtrHa?=
 =?us-ascii?Q?znn6wEtyzDPPN3q37WdZdbM7b2r7JqTKO8l+dh7jOMAFL3wOlj0VyZyQ37MF?=
 =?us-ascii?Q?rNnua0uCg9Zv7GYQJcF5bLXI+bM+bN66RlNja7U5728KKVd0jpLsy6QDFG66?=
 =?us-ascii?Q?I0ZFCOQ8bPUXIh4J/+2w6XT5zUGaxo8Vw9Vjf+Ox3bXCGh6R+vm8bBlGgsc/?=
 =?us-ascii?Q?qGr0xKvFeGCSw3lN/FWKupv/O2VCn6nWR/ZeecPuY1tlqln6t9mtXUSGRdee?=
 =?us-ascii?Q?9XBLkNAkIu16d4U+9FT+6Dq1r7v4CWKB63t4m4z09qiqKyALmj8b2YgiVp1y?=
 =?us-ascii?Q?tw3Xm9Tp6gUQGYGbA9mzqtV8NKmcO3BZjVsGv7ijUf9YMHRr2tufQTvkzfRc?=
 =?us-ascii?Q?R38kdAESYgp1x2SubEvTymH4V9opHmzg1T3udcADcHg8ywJJDz3y4MU2oxTN?=
 =?us-ascii?Q?z0H4Uv0F/wY+hFFbW/oV5tRW9QxFvGdceflIgdo5vB/eRKTW9CkvE8qNfqQM?=
 =?us-ascii?Q?UOsM91sg3UtYUXX144D4u+wnfR0wpItLubYYEJZvkXHGpQhZoG/9XYvAZtzF?=
 =?us-ascii?Q?4gR3KCQxlNCQ9yQMZ5xQqeQffy5EuXQELoYtoNfUVsR261Kr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 367ab079-753f-44ea-1c35-08de7665d9fc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2026 01:08:15.5685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E0sn6FFadIaA1kZqCWS6D8rnCLQ2n5mP74jx4WKFjy3oN2RlzP8ypmpl94Xy23YO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6816
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0B7E140007
X-Stat-Signature: 4jrwuxj7cd5cq8xqj8n9ciq39b51je18
X-HE-Tag: 1772240901-21785
X-HE-Meta: U2FsdGVkX1+vOvAQ/WYHlXiok2+pceALfzzRNikAtCpPluabm9i8gqj0uq4ru6IkBN5/hmBO08Mho+r9ePguUxM+121XUkCI/UaeBag05UXFvOPGe2JyUpxJ69jYsB1vIEE0A0bhAdk9Qz1dasQjcTnRnAeC2dG2AuAzLBQ3J5SLSB/GniIgvBImKwPmFyZQ3EBQAx6tSW38WqYSGTDbNubH2/YW9dTEkOgJzx6LuTIvicNZnMrdXOkrKGlMcN8sR0hsHgxV7oOQQv6e9lUBdsXivgvT1YkBDgc+Lzs1jXp4U/1WDdY1dw9hfeCWIvc+pCrOPwdSdIeV0vs598y0EodoC2eNI/6KnAIAlvMBJwg81Qe0qd8xc0/5xR5cmhmWzYmWE5+OMUMYtW9GhJZ++btphpTWCKJE3w8y2bhxGvXB10J3JtbZ/WNkynUkg0HuafE9eWg6RCMU8weNRfQswAqKhBdEVJQyBs9lUmlzJiTCFz7Q5EzYl1RZrDaQXyW6qVN68xtXWuIY5IPTdFuSunKmcVd9yt2p/HA5sXmzJEZrC9S+hegFRnHwXeIF67MVDI/3w31CrzAzi09VxnXOsuIA8UJGNhqFvNjBxUwGxef3nzZt4FMcSGkbf/0OaVpABuStKC+hXcwmqW9PzjTKq1soiwoWnUkcjw73Y17j7T3wc4nVNVMgUt20zd2JNWhSwjOpI5d+M2ovzvwnyW9LdAuq0TFfBylvnGMeBCxbWn7kmvzB8kzIZG/UAuOzbHTNQNMrOlV8QRdMlWOT8eUjZ02qogL5ZDXEBTn/7jKS8nVGC1GP/By1/hmF/r1v+vGPeI/IlUiwzNldwWn5/Tm+DF3S+vuv3+NW4ArgExiAgXZOeP6WETvznZZNVXxOhDJUhwKXZXnxHZKJP9y+fw+yxXrQT5ZHq8NJMNB+e6y9PfiTNHf39lE+p7t33lDnTN0txp6wNu2jNUQYXu2Rz6D
 ThNH9gDM
 vddN7MQYig8JVfpkOgnitnh3CkmEXqczW6Cu8EeEYoJKPT2v63Vtjvw2UuUHT4xCMUQtaAw+WBQ8XUuaQw9GGi+hxbKdqydv0V53y7ZR4BdFTJxlbzJ/QGK53Da1EP5lsGYUaEygkfbjtsK7n/BH7yW0OwUa+vQUXwhKMBUurTWNx7OB51MPQbwbe/ppa87sl1AbClU/S8+jEPPgdPVUSgLewFEPUY3AKGBrw1N05uwZSZK3fhgF1tRod6FRFoaX/ucKliNbvRAgK1+15KArUNtsZU3qp7UPTUR1V43S9B1xeIG+mbotRiV2OGleO2AZ+qZVINLe42ni2TtSjHmmJF9kfyvBSNXjH75RhTpdri0t/nijCeaOY+/9uLea09CpB6pQ6mEHK+YYZEp54x9P6OHzJnIn0do+K9qi1avmUeeG4fK5QjCJrWHYqMWmhWIdBTUWBUNq7bbyhnI37PY0Bdn/OM/M5cx5f4O5n/rMAmq+Sls/6Y32LcoUwALaLBtcBNv3OY9tGdy4rBcZx5qmnltQ0yj5d57SIY/Wa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During a pagecache folio split, the values in the related xarray should not
be changed from the original folio at xarray split time until all
after-split folios are well formed and stored in the xarray. Current use
of xas_try_split() in __split_unmapped_folio() lets some after-split folios
show up at wrong indices in the xarray. When these misplaced after-split
folios are unfrozen, before correct folios are stored via __xa_store(), and
grabbed by folio_try_get(), they are returned to userspace at wrong file
indices, causing data corruption.

Fix it by using the original folio in xas_try_split() calls, so that
folio_try_get() can get the right after-split folios after the original
folio is unfrozen.

Uniform split, split_huge_page*(), is not affected, since it uses
xas_split_alloc() and xas_split() only once and stores the original folio
in the xarray.

Fixes below points to the commit introduces the code, but folio_split() is
used in a later commit 7460b470a131f ("mm/truncate: use folio_split() in
truncate operation").

Fixes: 00527733d0dc8 ("mm/huge_memory: add two new (not yet used) functions for folio_split()")
Reported-by: Bas van Dijk <bas@dfinity.org>
Closes: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---
 mm/huge_memory.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 56db54fa48181..e4ed0404e8b55 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3647,6 +3647,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
 	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
+	struct folio *origin_folio = folio;
 	int split_order;
 
 	/*
@@ -3672,7 +3673,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 				xas_split(xas, folio, old_order);
 			else {
 				xas_set_order(xas, folio->index, split_order);
-				xas_try_split(xas, folio, old_order);
+				/*
+				 * use the original folio, so that a parallel
+				 * folio_try_get() waits on it until xarray is
+				 * updated with after-split folios and
+				 * the original one is unfrozen.
+				 */
+				xas_try_split(xas, origin_folio, old_order);
 				if (xas_error(xas))
 					return xas_error(xas);
 			}
-- 
2.51.0


