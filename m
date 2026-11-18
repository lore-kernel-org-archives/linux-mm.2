Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1244606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=ST7cLqk1
Received: by kanga.kvack.org (Postfix)
	id DB6186B05BF; Wed, 18 Nov 2026 10:30:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D669E6B05C1; Wed, 18 Nov 2026 10:30:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0A86B05C2; Wed, 18 Nov 2026 10:30:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C1656B05BF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:30:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3573A120625
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:30:56 +0000 (UTC)
X-FDA: 85448627712.03.4C04397
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011010.outbound.protection.outlook.com [52.101.57.10])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EF09C0011
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:30:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ST7cLqk1;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of icheng@nvidia.com designates 52.101.57.10 as permitted sender) smtp.mailfrom=icheng@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bU75CPRwSGAiGxtzCU94bplVd/Wb7DcIU+vF1jsMTW0=;
	b=eewEIaVsHTmnOu6TAO89PWE5626zVryBm3IbjChNERsWbWUn8Ad7qzLo6HX0XrkHdzeV3l
	a4bnodjg03Cff4emoAqeI1sAUIFs4w+0l0OJxKqxnE1ZITuSWP3JwRFEN5NFHpjmddWUP1
	fOzRjV1VHguKvjzPlH35VCl0Ba+3OLg=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=ST7cLqk1;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of icheng@nvidia.com designates 52.101.57.10 as permitted sender) smtp.mailfrom=icheng@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795015853;
	b=aZBkkPr70yTPF4uEmsZx6kaWlvbcg6FcENAnFOiFMZ4yZwaN9NOqHmhw9PoDSPrCnGgVcv
	MPFHwgAFucz7ar1CYXTel3G7YKIvSq5ilpO9OJeCoEWEfjYh9IVFDuR7Z34gzfoz1vJgr7
	SzvJ7flANy7NqbhLjcfkchyVOB8iNvs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OekI4APU5UBWbpTi9mP0N3zbwpc2Q+KBw/wuWkrBL7OB0tM2svgvLrG/3l9sKWpjAvI0qGm924uFQUacMkpIJR6TfqLf5YYGaH/ZG8sgnq8VjONrraUjLuavgD40F201UxEG+UJwnb054TkJ5XiqqVLUas29N/zODSB/7pfJEM8NL/Bpt8AcRy8wtn3/ByUM8tleeLiSFpKMnWD19IqXGrhSEFlPNlHu6RWuR0iUeG3HPwGIQBAUHw5QDSvZj/elr21vraU9IzeEsFRJk6EBxs7V54qPq/yR0ksAFUGverSkhD6ISn2264XqERQ5XRdIdWv0FcdvCHKFsWZAZefQ1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bU75CPRwSGAiGxtzCU94bplVd/Wb7DcIU+vF1jsMTW0=;
 b=SU/i043vUHM6U5DQ6DqbzeTPb0MVeQqkjg2pUiX6E77OfNiqSrdT00PMzj+/k2ODO+5R/phbhY+izfqYi6wzot03EqATU+VH1QthLAyzTGfC7fk0MADBaJkyIto95KNdzcz/cD+lZibBCt39EEROCg/E9CIHVqz8/ySLY0J1bCNNX1YgaNCDyOvNxzQQLF9FiUg95ZDI76l+kP/8iVE7fqe/QPcjXl2ww0KzzWKkSWIDKbrSVkTBp3o+S4StK0+TsO2f/XKUfAQbqPLYBbr987SSPZ+yX8oB7LiqNmsKQ0kOFFtKPUU8a2bMPRZCU3uOKi13F14O78Cpm6uz+Y47Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bU75CPRwSGAiGxtzCU94bplVd/Wb7DcIU+vF1jsMTW0=;
 b=ST7cLqk1kQxoLWsJDREjtxX1kXrZWVAZgYODYjYlX6CL6/fz/L9D1+d8SYwurOCp19AGVE4Ei2qS5Pwy/mV50m1aC6BaGVf4Bux/dqPZ0nITRH9JC7qolfgFo5e1WtGsliocOOqpN/0VA298S/PJ4x5b3wiXs41NQsnxKDr1rtK305yzaqPNuDCberhJ/ApZOInDCrcgIhnrJa7EL3VrRf6FgV3cUx8zOo2AVq8HunLpSQIVhbgpvmVYcHEUs6l1UxoTSDiy8TuCI1mbzCLtvXKUa11FrLUQ1q718Qc/fHWCDXuf+ZWJnpBzz52LXLrmB34y/vcY9G/Ks2xqk7elwA==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by DS0PR12MB8294.namprd12.prod.outlook.com (2603:10b6:8:f4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Wed, 18 Nov
 2026 15:30:20 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 15:30:18 +0000
Date: Wed, 18 Nov 2026 23:30:10 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev, linux-serial@vger.kernel.org, 
	linux-pm@vger.kernel.org, damon@lists.linux.dev, linux-cxl@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, johan@kernel.org, jirislaby@kernel.org, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, baoquan.he@linux.dev, 
	baolin.wang@linux.alibaba.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk, pavel@kernel.org, 
	lenb@kernel.org, hannes@cmpxchg.org, brendan.jackman@linux.dev, ziy@nvidia.com, 
	sj@kernel.org, muchun.song@linux.dev, osalvador@suse.de, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	kas@kernel.org, xu.xin@linux.dev, chengming.zhou@linux.dev, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
	matthew.brost@intel.com, byungchul@sk.com, apopple@nvidia.com, rientjes@google.com
Subject: Re: [PATCH 05/22] mm/mempolicy: keep interleave and tmpfs mount
 policies on common memory
Message-ID: <av3EGWuHX2JDdlrx@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-6-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114070959.3490008-6-gourry@gourry.net>
X-ClientProxiedBy: SI3PR03CA0004.apcprd03.prod.outlook.com
 (2603:1096:4:297::11) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|DS0PR12MB8294:EE_
X-MS-Office365-Filtering-Correlation-Id: 779b54a5-31fe-49a8-6736-08df4588d9a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|7416014|22082099003|18002099003|4143699003|11063799006|56012099006|261022075727099003|261028144727099003|261102123227099003|261021121427099003|261021123027099003|261009223027099003|10067099003|261026121527099003|261026140227099003|261022105027099003;
X-Microsoft-Antispam-Message-Info:
	F3G++OhJg09+/fJ7lwBVjJ5XHGVbiJ3FfUmOich/5zJhOb3mfR/mgIqgjUMlnzJqn34hFTq+0f6eDl93zDSW2S0AWjhm+T3PdwEzcLwdFdfkkZgK3ndkKi/+jydTmUqR0xL0nXgudPNicKc95avZUqQF1ar/stmXiYlTE4g3hg4+hdD6dFO0PryJJktm8s4VJjG36Dugq5knUNBQz23mRbVYcCCtm4oqEB5qGvypXXIWqJbaTnOKRMcyUAVKewZ3hIGaIyFHRvflhdlI9B6AvvPC7/ZxlcYBbH5cupzdMhuDBUS9mQwctRMDoSyJetZFC8Ck1XIwcInvF9o6MaWxUnSGxN+g/gsRea+8wude0bc7MLVqVTTODCno6IqKxCG4CdFfeaqBwSJXLXFg5qmPwQmJ3C34g8iYXaE0FljCmD6EP8vGurJvl9FZZTjRq4OloO1oF+6vZt4kpKSEhVRt76dfqEFhTlDHcQ/9P4jrBwyT8zYcv4LdvGFzU3i3IjFMGFk7cbX2i/IJiEvHGVMkLqfdlWYtn2lwUo9YWgmUlcVGd7wluJoovfZE4y3STWnFlvbzFW1a9qSnoJ8T4FnTL/8q3MnCVzCnOJTJAAOJBvvcyNFIPwd5FdljsZewKTRox0p4m50UcPNokVWc9Fy9lIG1K0fnsFN5CgmrIPt+TDI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(7416014)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(261022075727099003)(261028144727099003)(261102123227099003)(261021121427099003)(261021123027099003)(261009223027099003)(10067099003)(261026121527099003)(261026140227099003)(261022105027099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tzs4tv6n7OuOUiljj2XYbaHlbgI3wgVrCO0rmPBi6vxs2nSfmkNbSYO3+1qg?=
 =?us-ascii?Q?W+eRAiuZwT1pzmo6+MPSnhvJaN0VQqfJoyzsCTaoqk4m+yQ7xYJh7QPNNJ9a?=
 =?us-ascii?Q?j5YjEKOw9xoHU7Y38e20OQfYgvLrGrDbEHNw0+DUuRiXrJNl4HrpsoK8Oxia?=
 =?us-ascii?Q?jLCSnw2xsuwoeBANBzDElnuxcEAW+N2B5LxEMsdGoaXRGare18S69DeAuGnY?=
 =?us-ascii?Q?oTaQLQ4ywVceRJlRQdYDyiALkJczu04QjflEEaET2tBJwxkhge4EaduK3S3Z?=
 =?us-ascii?Q?hyQFTu3hNU0IhgRKwNmOKO2uUepqnzkiBxD1Nqys9eKyKgkr7sMP55QPJFjL?=
 =?us-ascii?Q?xqlKN3z9C8qN0IWM78u2Nry9q7019iaQYqCO18hIeFdiJ7hyz3vEd8HZNUAo?=
 =?us-ascii?Q?eL/VyWZv9ZTjUgMK+jwa5hmNLYRFkEg4UmOsVlCzAGxDaRez1RpBSOxj/Xvj?=
 =?us-ascii?Q?s+5AUJQxqk2HIZocZBX4tvy66tFQfB3Bg0q3ceZF54hvBRpYNmztYYKn3nEy?=
 =?us-ascii?Q?WR/qoQkFKPO/hrDXegOo8ZoAVwP1Kt8AzxcVenNQVuaPpPKq0HfgUhDU4ER4?=
 =?us-ascii?Q?ee4BIx2O3vT+PluOWyYjYsHSq1qSgG4Q+TvyN90FyaVMcCrd2vSlhQw2c1bD?=
 =?us-ascii?Q?Cj6ITebUqfk8l+Rs+dN8v2/2s32zBNDPECDfE1jakWS/qALDc6ZqqBvO7rc9?=
 =?us-ascii?Q?jUysGxgBpd1AMeuvXV5Q8t+cAV28p9U4mk4O95Dx6XEM+rUO6Jgs2Gw8c+vF?=
 =?us-ascii?Q?FxwdLSPhYRNJXmAnelUMpIPe/8qFJI1qBB8n16FrD6esg05Tnx2m2UGoOTEM?=
 =?us-ascii?Q?AjdO9XKQ2n88kr9+IXYiizLKbyWpMKcTWkhr5I+nx4cUlHarQU+sgnxzWLxi?=
 =?us-ascii?Q?bIDg2/GUVEDpDrrsicKWchR9T/aU7LxanN0L78XWQKIsYONu22Xh0A0ycuxS?=
 =?us-ascii?Q?W+H7pJhQUKNGKK+Vdwi8mKc4npSMc3hY5+XEvX2/r9dZHBH35gY7jgM3w/GU?=
 =?us-ascii?Q?lkRKhjjDv/e4NTgc1czuGn2VQF/MhB24Wj3zfD/unaDmo7LXSdTMXWuVjCbf?=
 =?us-ascii?Q?j70+FP/+y+ock8/xRUhf2UQIP/SKFQ/f6abCc6F2FaKNHMF46aMI0gvjFYap?=
 =?us-ascii?Q?PAD5tVUT6mxZts73HCsqzUE6rMrVJ1Od1rZ7g85s51j0ZUSV0buMsRKxxsJF?=
 =?us-ascii?Q?tSQYS366Uo+vQ2gT5xOZZEpKHzytk+iMXIrRxs6F+v6HKpAgzGdcFbOfqi6n?=
 =?us-ascii?Q?t8PPzoLxy1MNn6Y9IQE+cQU6Ayejuto0bqslQNF/eSGu8cY0vHyYBhOD0rwc?=
 =?us-ascii?Q?d5CJzKFnTv9G9b6ZK8hnzylb8Cv5Gg6LVSsXxg+QBu5DZRTJ8HbFMxir+ycl?=
 =?us-ascii?Q?FeWrprH54hsXqxNqyW9x9ygqSaXVmNtkmwYg/J3p59YkrVqD1YV1pCBFWnbO?=
 =?us-ascii?Q?MusnzH3yTlcsz07v8PBonyVlFe3aNVOD72NS2y7yzwPwDwE3L6Yxj4tYCox+?=
 =?us-ascii?Q?P30E81xpD3bPm2DIZGjdrEVvqokPO/Hl46cBq9ddvOS4WyML09BQg2bcqFtZ?=
 =?us-ascii?Q?kvdN6jowAzgmxBmw36P4ddBd6ITJjq14x+dUaVN5bvoSegwgJsts1c7BlYI0?=
 =?us-ascii?Q?JnihD/zygbtzbhXjMSxXwFcBo+mn9YPKgzzplD0TVa/7vzEmSNY//mFERBAL?=
 =?us-ascii?Q?pyd9l2A8vgQUFja2PkhEplz/CyyS+YXtNWjrUQSQcpeisqXnpPTW9ksstmER?=
 =?us-ascii?Q?wMyheo+49Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 779b54a5-31fe-49a8-6736-08df4588d9a3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 15:30:18.3432
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DnX8jIXpMAUBR5mrklAo1G5Z+rwefgHttNCKjWXHMkkrJcRGq/4aniGH+dLbgmaNTyhoICpvKURJWOM7JCIz6Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8294
X-Stat-Signature: 3hnj5ux1ymmgcitcop8gdh1xoudwqx8e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4EF09C0011
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795015853-265976
X-HE-Meta: U2FsdGVkX19uQNcYtwWMXd8N4AokmDx0oH9azjX7aj4gjwaVPVS5PXgz37LLfYjhCFDmPq26LFJgqRjvruASQOZw8XHqPUViOX/WESQkLPBmPheGDFt67Ii3mL7njs6Mdqjv4jJVLKBZamzWH7uAm0PvFYxuAJgdQXF15FFe8yzuelyMGxArqs/Rq0necVe1Wgj1TIBZbD1L1w1IZMJXYkMH5SC5x4uARCOBuWrmPAF1vVVW8E+8hP/eAM8lKKgmjSlZOWyWWjTzhvz18sh+gynIKFUqan9VGzq6yD6taqUsZOBwNM9kNz4Xg4CgwY3ZBo7h6u5AmRqHFV8R1pv2bTWCmwskVCbBt+B3gm6xPJiqeVU2H/Nf/wpatDI3Z7IItvn9hy4fmlM0Ijp4Uj5LbDSHspxPuxFMncWos5OKpyYYJ/RNfqHm/b400ScWQr1mHeQ1fiS/ozwwyYhaXeOmOuwdwm7iqw0xPlbBlxv4bh1Vlm/o9W1BKCjkG36kWf7RCmSYsps9y0wn2u+yvqf7gY3ox/oYDsKvrkT4sAosl/QwxcIiD974cZhlsLOFAQiYVp7XxgRuT9PQUsT6ZXNK6/i3TD18yRrPZJs5TOhiJauPmH437nnVsu2uATZri1iTM2G9MIFqLzNmPlghiLgznopQU5GnUbzZFcj5xXVCnE2YZWt7IJJD6VkomcDAYcHVmauY6p8zd+XPiID6bA6jGvLfuo+1QSJRUmRcNiZ1b0c1xQrAk4Dyc4jdG/FSXVKdjkRhKhbOjZdNjkhmmJwjaZHqfZg4rNlQPTWC58kaoWvexz1tNG93VBhI/1REd7djDB1Sv+gY84FAu+4mKPgJfTeyWLkWR7QlmDqfO+pSe+GAQA0kmbVQa4NvFwuniipB8tHgkOM6fc5sIcYPGUlgQOjviiUOrBagHVCr7S1MFzDjHl1zgp2vL1IdUW6+qNrREKKc4QoI1pcN2i4etrS
 1jfn2MOx
 Sbu2W6okY1DcFX7b9guK7b+GO8T2v1bIimFAD4kXUdCWye4LZiD7txijRqFSXBccEmgr8IsXbgN2R+2MZ6P2MxuFy2VJ8PElv+CWefD59wqjKktuIvJ32HXVd6WwfcgUao1ElD1AHtKF29cwepBuxhemZMo7DlbPgy+oimMIwjmdQQusG0KebrhXiFlKV+QXP37SAyGbN+56O7weiU5I0WovnQQyH4WlkcnYgMH+XVq516SMV7ooIrFL+Lq8eauV4x+CY54Mko5PZgwtTGnKkL8UavFWd1OyCeMBWs7Fv+1Hv9xzQhJ1L61T69IqUJTBR2D+p/q//yxS7sSbI1KHcw/J0Wf2BGlBUx6zI49ahbh3JjhAf3F1hgXnxdgdEfdIwuaDi4rgJ/hrGRGiRy9hHYyTxF6my9URjmXQ5Q1uFJnyO/atUjg/3z6BsBmLiGHzpl+PK5UJQr++2r/WmQ0uCJRZSflhPksOzQ2aO842SUhZ4UW7kNdQxm3ABDVYL6vWHSa5KcYXuhiC8KDJ3e5iIPsUbdWDwySlkAdUs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 02:09:42AM +0800, Gregory Price (Meta) wrote:
> Use N_MEMORY_COMMON for boot mempolicy calculations and their per-node
> sysfs entries (weighted interleave weights). 
> 
> Restrict the node set mpol_set_nodemask() applies to set_mempolicy()
> and mbind() masks to N_MEMORY_COMMON nodes.
> 
> Later when an N_MEMORY node is omitted frmo the N_MEMORY_COMMON set,

nit: "from"

> they will be stripped from mempolicy nodemasks as they're not eligible
> (similar to memoryless nodes today).
> 
> All memory is common at this point, no behavior change at this point.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index b10c098e9c2a3..662ab420fe03c 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -213,10 +213,10 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
>  	int nid;
>  
>  	/*
> -	 * N_MEMORY can change while wi_state_lock is held. Remember the
> -	 * nodes contributing to sum_bw so all passes use the same set.
> +	 * N_MEMORY_COMMON can change while wi_state_lock is held. Remember
> +	 * the nodes contributing to sum_bw so all passes use the same set.
>  	 */
> -	for_each_node_state(nid, N_MEMORY) {
> +	for_each_node_state(nid, N_MEMORY_COMMON) {
>  		node_set(nid, nodes);
>  		sum_bw += bw[nid];
>  	}
> @@ -439,9 +439,9 @@ static int mpol_set_nodemask(struct mempolicy *pol,
>  	if (!pol || pol->mode == MPOL_LOCAL)
>  		return 0;
>  
> -	/* Check N_MEMORY */
> +	/* Check N_MEMORY_COMMON */
>  	nodes_and(nsc->mask1,
> -		  cpuset_current_mems_allowed, node_states[N_MEMORY]);
> +		  cpuset_current_mems_allowed, node_states[N_MEMORY_COMMON]);
>  
>  	VM_BUG_ON(!nodes);
>  
> @@ -3400,11 +3400,11 @@ void __init numa_policy_init(void)
>  
>  	/*
>  	 * Set interleaving policy for system init. Interleaving is only
> -	 * enabled across suitably sized nodes (default is >= 16MB), or
> -	 * fall back to the largest node if they're all smaller.
> +	 * enabled across suitably sized common memory nodes (default is
> +	 * >= 16MB), or fall back to the largest node if they're all smaller.
>  	 */
>  	nodes_clear(interleave_nodes);
> -	for_each_node_state(nid, N_MEMORY) {
> +	for_each_node_state(nid, N_MEMORY_COMMON) {
>  		unsigned long total_pages = node_present_pages(nid);
>  
>  		/* Preserve the largest node */
> @@ -3476,7 +3476,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
>  		*nodelist++ = '\0';
>  		if (nodelist_parse(nodelist, nodes))
>  			goto out;
> -		if (!nodes_subset(nodes, node_states[N_MEMORY]))
> +		if (!nodes_subset(nodes, node_states[N_MEMORY_COMMON]))
>  			goto out;
>  	} else
>  		nodes_clear(nodes);
> @@ -3508,7 +3508,7 @@ int mpol_parse_str(char *str, struct mempolicy **mpol)
>  		 * Default to online nodes with memory if no nodelist
>  		 */
>  		if (!nodelist)
> -			nodes = node_states[N_MEMORY];
> +			nodes = node_states[N_MEMORY_COMMON];
>  		break;
>  	case MPOL_LOCAL:
>  		/*
> @@ -3903,6 +3903,9 @@ static int wi_node_notifier(struct notifier_block *nb,
>  
>  	switch (action) {
>  	case NODE_ADDED_FIRST_MEMORY:
> +		/* Weighted interleave spans only common memory. */
> +		if (!node_state(nid, N_MEMORY_COMMON))
> +			break;
>  		err = sysfs_wi_node_add(nid);
>  		if (err)
>  			pr_err("failed to add sysfs for node%d during hotplug: %d\n",
> @@ -3934,10 +3937,7 @@ static int __init add_weighted_interleave_group(struct kobject *mempolicy_kobj)
>  	if (err)
>  		goto err_put_kobj;
>  
> -	for_each_online_node(nid) {
> -		if (!node_state(nid, N_MEMORY))
> -			continue;
> -
> +	for_each_node_state(nid, N_MEMORY_COMMON) {

Maybe I overlooked or somehow, but when do we have the assumption
that common memory is definitely onlined ?

Best regards,
Richard Cheng.

>  		err = sysfs_wi_node_add(nid);
>  		if (err) {
>  			pr_err("failed to add sysfs for node%d during init: %d\n",
> -- 
> 2.53.1-Meta
> 
> 

