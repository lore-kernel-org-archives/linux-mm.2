Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8282606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 08:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=EXiLonfE
Received: by kanga.kvack.org (Postfix)
	id BCB386B00EF; Wed, 18 Nov 2026 03:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B554E6B05B0; Wed, 18 Nov 2026 03:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE826B05B1; Wed, 18 Nov 2026 03:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 713FC6B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 03:29:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DAC44C03AD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:29:53 +0000 (UTC)
X-FDA: 85447566666.16.A4AC259
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011068.outbound.protection.outlook.com [40.107.208.68])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13792A000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 08:29:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EXiLonfE;
	spf=pass (imf15.hostedemail.com: domain of icheng@nvidia.com designates 40.107.208.68 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794990591;
	b=sQFpZEO6NDF9Erz3+09FVrrUiwPmcjjKm1FRT0l/DBCMj+bwMBCspCCxhx6+B4rbd+4tCN
	IJ9oxW998505KqVmskTVNiWl11sxzotmQcDDodj/JSm0rCKpPO3BZ5kGolsMxn2C8k4Tt8
	90WuUwK2z78uECUs9do2mcT88T7DKLM=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=EXiLonfE;
	spf=pass (imf15.hostedemail.com: domain of icheng@nvidia.com designates 40.107.208.68 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794990591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R6RnNqiWkogIz9PQ0eqwbL2QMul5hVFgEpmy8wdN4k4=;
	b=MObNgzfCSTRy7pxjqKgERUwkq57iB6q7Zvd0D9L9L8HvNCSNGEvNFWGnXinrNYSmkIdrQz
	iuuvORST5U7bZKap7Xh4gRCf1J0u0luSzacRokQ9mPGXxY1MHzhzxE/y0zhMBFisUPuC3y
	CSlSLm51IvYBCgntK3Ln6uOPqUk9Wa8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TCR9NP91Q3uRPIDPQWD+tAlwUmx27KJR6WEOqLCTJAorrU4ziFY6bCucCV5XDcXi12ShJ2UtLRnjfd9ncm08+edMEJX+tibErt+9c478sQccGE95q0tRtRBrCeBeLJepTTgyrLDQYigBTI5X5JOpgL59Wn0hjxincCmZO321kUCOA6IruLItZapV1z2Hhx+i3p611f7LpMbm5pKsp2GURCE5R2at/wsVb9mMWmmI4eYsIOobxpsOggeKbM/oUjCqNWYUtJX6h77pY7Oid/pLExknZOAfO7BuldoyAcQq60plrrQCppKROrzrdjpVXyD8m8cxRpCjZIsZE1g9W0MDLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6RnNqiWkogIz9PQ0eqwbL2QMul5hVFgEpmy8wdN4k4=;
 b=b+mIRNDGG06v3CkcWn30RqxcDxmKWXo7V8bcy1bpa8umuoFUH3Q++vg3Vq88WSq5GViyvS8Dbc3+ew+8+v5ncr3Zsy+jCw2/6l+aD+Ow9cFT32LeGrIpxetpZRQlcxuLiA2dPHSCUx8DJFn0JgrbTGKzDQ4FZMLDgULINof8Vd81K/cyrvwtXOoPxhtYT5QCaKSWbjlRzB22n7DbuGUvEKbkEjtNupMD5+KvtSn09i8osv9/9pyG4cjsBRSmCFIBrn4R8TdrKaPxP3tlMCXBf0xCXfnZuiwvnig+gmNItqbOAzYolHJz7y7RLtTACLLWOp3iHjUi45XN5k5QsxJ8ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6RnNqiWkogIz9PQ0eqwbL2QMul5hVFgEpmy8wdN4k4=;
 b=EXiLonfEyuhBDvbCx01li1UaP18t93J8jxbwqqJvmZK3DnkMU+MwmM41M4DEFxKqsqtN1Eg/F2GWLQX9To2BYxvVerpy0/MjcRGcLM2Vr1D7knRtkWowJKJydJb23XrIs5sbzAlP+lGfqSWl3NtAkMnrQAwXQulyz4XNzr2CWuZcmmpKdVTRUJTIkI8JaCGtq79wpp/OnHSKWJ/sz4Xlk+R5pb53QPeJSYzBtV6g0D0bti/aeOxCblLrCFdeCddgb8jEgNiKh5k8z9Qg4t25TwcJ6LLN3Mnr4z99+yJlZKoSbCpI/K+uq6x5QhWPfLwCJ65Q4rhBFwtQRnzJeb/uvg==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by BY5PR12MB4242.namprd12.prod.outlook.com (2603:10b6:a03:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.14; Wed, 18 Nov
 2026 08:29:44 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0615.009; Wed, 18 Nov 2026
 08:29:44 +0000
Date: Wed, 18 Nov 2026 16:29:37 +0800
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
Subject: Re: [PATCH 01/22] mm: add node-state-filtered zone and node iterators
Message-ID: <av1hKrtcATVjCnCM@MWDK4CY14F>
References: <20261114070959.3490008-1-gourry@gourry.net>
 <20261114070959.3490008-2-gourry@gourry.net>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261114070959.3490008-2-gourry@gourry.net>
X-ClientProxiedBy: SG2PR02CA0132.apcprd02.prod.outlook.com
 (2603:1096:4:188::15) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|BY5PR12MB4242:EE_
X-MS-Office365-Filtering-Correlation-Id: 5dab5d6c-854d-4d2d-1c43-08df454e18ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|18002099003|22082099003|6133799003|261009223027099003|4143699003|5023799004|11063799006|56012099006|261026140227099003|261028144727099003|261102123227099003|261026121527099003|261021123027099003|261021121427099003|261022105027099003|10067099003;
X-Microsoft-Antispam-Message-Info:
	l13Y5nDdpijjsnMcAiqIwAVjwA38McW8+xWmF2ei6gjrWeyXV9hMWMTMu6vhzs2/Kj/DeDwxNU96b1vjQsPlNfZlE8JJOX7mwH153+Of2AQZBg6wGgKevRR/Wm9f1lS5dekeQ7p/5LLfED1L5d3GKBAChPQPD1CVX2AiB0a76gQZVte5S39gMJl+n+IqayRxCzpKVLJFiKOKC8VOHlgEjGcjaX9vfFwIBVdqarrjLPzr4ksqthM3yOY7T2g1lRpyIvt87H+7hhe+o0brnC9BWGQzNxfE5bqH7PRk/Fb5+T6q+C2qlmyJnqzg0Msxc1Itxl1byduRi8mJnhfpkH0OyhlstqxUwas5oFiMQFsuGnEICFZ+ruY0dQ3BvG7N2mqVsD/IvBYcDHUCHzgF/6rM7RtJ+TxotVajl5uRchNsS8//dw9om4E7nuV4Kt8EM1bzCn18RyfFk1NTOpTyu42lNTaL0EUdfrhC2IyQaDR2nMjPgpiot7AXZu5Xj7KqZwRD2r8QYR9rwwHtnWrdLGFI+s+dcb5f/6TUOZt60MVrIVjKMtlqECLR3Qt9vI5af0kINfL5gw09YoaUB++XJZbO81wgJtx2KJ01a4T0e7czH42fLf8vu6JGM4z43S9AlQ77bsuSrJT1HftInn68Pozj/PWTuEUK32Ca2byCb+9BVVw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(6133799003)(261009223027099003)(4143699003)(5023799004)(11063799006)(56012099006)(261026140227099003)(261028144727099003)(261102123227099003)(261026121527099003)(261021123027099003)(261021121427099003)(261022105027099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gNe2P4ymbBaSsoAk6mxzw8bBStEIMKQqhyffCRJ3S58gbnWlW/7WcBHR24tO?=
 =?us-ascii?Q?0i/NLHcaAwTN06uh3aI3j69Hd9eGjO5zcJ/rP2CsI1uq4lEcTu8u3W6FuWfr?=
 =?us-ascii?Q?6+lk9/hjFAmQ+Xq6NVQ+1JFWATP8PcST4jOJxyCPF3+QCYH+qQFdMgVGD0eF?=
 =?us-ascii?Q?LFyNjMtQJxxkRsQe3CxQLgyvOB30YrgMIkWt7kJn9oVCoBRjvAtSEMtUWNvy?=
 =?us-ascii?Q?bQ5uu0xucXZTwXa0fVlWhek31GKanVb16v55a1qJnejqqPreNrRNea0WrNU3?=
 =?us-ascii?Q?p9d35iWbG/KB7KP6AAI8UrOIoN4RYKyssyTOLrLB1Bl/HgtOQ03KkjyT9Zhw?=
 =?us-ascii?Q?sTKjKSskRz+jlm68h2JmvyhfAT4EQpXmZ/gMm9Tz9+laLo9e2NnDrk26oKZr?=
 =?us-ascii?Q?FCLQ/mAQswtjK9uHw38Rvg7JgLKPyrKnl3e71On7ZbWWqBBJtE7/WIhQ9c8O?=
 =?us-ascii?Q?QPI3cWSEdDSGLoDh7wO/T9O+cNDZV7bhEjHIw8vmKmel8SE8hQN87xnH+MO5?=
 =?us-ascii?Q?TbrPBDqOHI9U4BCsXsc9PWfF5AVYzjwP2QvHCxYAbuK6ZXYS8AfYHkQ5Ga5e?=
 =?us-ascii?Q?UhHjBOV01vH1L+JfGVLlGsVrcF5l2+Fmz9u4ry8KY41lft3PY+dW9IVwiVDq?=
 =?us-ascii?Q?tEgwTZ4IAHzCKPxdrRgFCzAn40DQHF0xGLcg4rRV3LfdVkm2AXct/+x40CFX?=
 =?us-ascii?Q?5Zeedr5r3+x9Ek341MJTJv81RGNO0OQyEPLIrS5AFnjJtiMDsw5nD9qQxw+h?=
 =?us-ascii?Q?hbjwHhETBhmj/KPcwJRPeEhL5ObIWC68tV6IfsIWvjGZ1GoS9wrz7uJUoG+n?=
 =?us-ascii?Q?G4GJnZQmMGGaXSV+UQ/btDzm55llXtT7m771Tvinj1U29lCX63u4LoCZl1ic?=
 =?us-ascii?Q?sQyA164KfeN+BOn9JqAYLZFExzHtpC775T8HJeFZHDJ8K4n77pFHnElIpeQ7?=
 =?us-ascii?Q?ClwUJ1K8NBkMOLzzuIxa4o8FB7EyYmayfa9P/nKNOs81oraWVU9FqGHLWGBT?=
 =?us-ascii?Q?C/IsUfh9XM0yeV/OBPNMSP/aKeAD1kApgGCT4UopuX87T3xpvyirpxmUsaMq?=
 =?us-ascii?Q?uOp1ER/jqzDJzzyzFKQUl8dHoeBK9sXICSK/1dhsNWDx9yIexHSGkeAN6Boj?=
 =?us-ascii?Q?xOSo5GRoF5I2KogDq+sDcRrObuZiQ8j1lG9H+6vjY7Rj5DGk4uonNEOqphHO?=
 =?us-ascii?Q?9ISs+Uem+o/V/rGIQ9LxplQLAhfs9rXRUyYstCQle63BNOl6uJ5YTy++E0ze?=
 =?us-ascii?Q?50x8ZPGRE35KDG6WmJOUGx4vN9hUxs8nO4MxzFfE4+cMjnxAWAmFphLk7bus?=
 =?us-ascii?Q?FemZ5iAd0GrWgMKYbEVQ1S2w6X1IuzTelMbK85PPugNEdEgn9be5WPESv1nQ?=
 =?us-ascii?Q?obl0FFDuY1fG09ZDjvznnDI57+IpZvY4J4gq0soMjg30ue0l63vtZjfVYZ80?=
 =?us-ascii?Q?KOp5lbhsi1Ulza2zbz96oMU6CP79Qc5RLqfepRP4DdbzGY42V1llAH+o+wmm?=
 =?us-ascii?Q?ucqx+n+CCUNZdqJFPsVBXF4xBQDfK6HWD7MxBTs3R943VLyvBl6c6A7mdel4?=
 =?us-ascii?Q?f/fil63BhS0IGBtyB8YX1y874pGTdgQ2AlqsNLsRd2FMumIwvHNGTGu2j+4x?=
 =?us-ascii?Q?vs3fkRJpWC/LeJ3st4XrgDlvXc3wupV8CvW/pnRXeQmE3utll4WdNngQKElo?=
 =?us-ascii?Q?cn7nIE781pSL1KBygdFereEwSN0RMB4qWyuBwgGVYQIYIYHN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dab5d6c-854d-4d2d-1c43-08df454e18ce
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2026 08:29:44.0441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2w2lHtYFtHFvaERj4raXRWyqStqGCLwIhNCVAkU9cwzgkYQopVu6D0TE3l9xCeyHcSJ6av+w+GQa9Hbv9UeBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4242
X-Stat-Signature: o5ihiar3ffjg435gpoipiauwq5exuiiz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 13792A000A
X-HE-Tag: 1794990590-699601
X-HE-Meta: U2FsdGVkX19kEdutXh7aDvhbC59WO+Mu/io6GkREd1OOxOOiafQhJYUskDolaTIXPU7rvtra9U0U/GiXagXb818K5ddjndy9UY8+MoNGrIzAVvc9oM44lgQwSVktKqOv18yhAhzaxLBP1o+gzWgFoOiDCvuxfYPRI0YV+jRPkAPFP5B3QMHmSZrP63Dm0y70P92itWX9BMVsvHzmpUwdKhjBduogm7RPVJ2ZDddUkav1hubSDsH9wMuY4Q5NXCOKudRfQfHKif0SErIhCmmb1oSBpxbBt9tccKW9o809ebxF+Ksoot7l4rahUxz7iLVCcoFoVauvwD96PT6+Zn6XOYXxkiy+zZfS48ipbbxHhNjbaB2z8xbewVJQeir5ml+s23jQCzVmLYHHKTvhlAyL3hphQSzU0uCZtPggUGHHyvn5KxmXYZ9eFWMNGNji2Qg4pC/FeUFG72gSCIsdVHYmdYRB2bRsAQ/zpxXtszimacH9hJ0o3qpg9eG6pYjh3E9Ez4tmdtcIZS6RM13wZBHX2IkVSihSVROueLWGjY1ebpSAHv5qkrRu/UYE3gdhe02XLWnhNy2U8IkkbS0ZDr549QToYdVa6LdRxnHwqNh9w6ulRdwzXcBWxLfiVYxpdShlNwVvBUjgs/RgO7znezGTDAo6sKGAHTtt8lBUNwy2wghwm/4IlW/uHJe3jAlpEz4niHb3NuXG3VWvlOBf/mK/pEOMtj9nrMlvkspkX/WECDA1LnMxBlkA/dAWG18qVULetBSi/+9Pcp37XExaBzQ32LvxJgnfsmsJ9r/G6DevxQotuaKbiVuZawbrKzlfxyWZF/RrAXycIgkfs1wUGk/R4xr6ywLdmprOaw5qOnICWaLjMwxv724FvfAJBOXDaITMLrlxL2MtH1qls27i1HcQ+b/Hj8G4B7roi8awK8qMCYPG4cLj1d6FNl6pLADpbj+8xQs3UVWVFneToL1ac0Y
 TbZTfUip
 ONt1fpRFfbHnImzyZ2UFkcSS45aqii34eBiSUEeliAH5d/wkZ9Ev7Ad6IP0h2CSfp8rFztYNW64k81WvMz8xRvONWUlck6Zp/hRfHLdcNuIoXB9L9VjRTYm2MHXX1eVw/ZjpDoTgfAwqeSFs07Nhs96lGKEnAapTcI264GoGYmRkl4E+SLaBEvu6hXb0vL85tM52cCI1Eh1fH17Ejta3+77BavbTSL0SleVCTIcK8eI5qzDvP2h9x7zbyFATO7Yc7StGh8SKJO0UQ6bQqAEkmxlIB3UH9QwvwvU5teVBkY00N4LGvVPNhYk0zBhQ8dk3zTfJrOkkRlow8DlA/CLLEJcsfv+rQV/mV6O0Alkq955FpYJj6IXpZ9+Hh5ZLyXlt6kD01+qtma0T9yhSI0eBYvyxptNOWztZQcqzbo/F4ooTHfXukHXJJj8t+6lScWGreN+4Gkms2SJtNDjJ3VUgZgBL5lIFxU0GQSvYjGPYE6FO36le1KMpmCYt9Jij85oBRWMwXYMwuz2NHVAqCfDv9MPqyhGGmVx7NA1Oo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 02:09:38AM +0800, Gregory Price (Meta) wrote:
> Add node-state-filter helper functions/macros so MM walkers can select
> their node eligibility explicitly.
> 
> Add nodemask intersection and nodemask/state iterators using the bitmap
> intersection helpers, without allocating a temporary nodemask.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  include/linux/mmzone.h   | 46 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/nodemask.h | 28 ++++++++++++++++++++----
>  2 files changed, 70 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c161d563ce8fd..5ff190d870830 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1845,6 +1845,13 @@ extern struct zone *next_zone(struct zone *zone);
>  			; /* do nothing */		\
>  		else
>  
> +/* Populated zones on nodes in @state. */
> +#define for_each_populated_zone_state(zone, state)	\
> +	for_each_populated_zone(zone)			\
> +		if (!node_state(zone_to_nid(zone), state))	\
> +			; /* do nothing */		\
> +		else
> +
>  static inline struct zone *zonelist_zone(struct zoneref *zoneref)
>  {
>  	return zoneref->zone;
> @@ -1937,6 +1944,45 @@ static inline struct zoneref *first_zones_zonelist(struct zonelist *zonelist,
>  			zone = zonelist_zone(z))
>  
>  
> +static inline struct zoneref *
> +next_zones_zonelist_state(struct zoneref *z, enum zone_type highest_zoneidx,
> +			  const nodemask_t *nodes, enum node_states state)
> +{
> +	z = next_zones_zonelist(z, highest_zoneidx, nodes);
> +	while (zonelist_zone(z) && !node_state(zonelist_node_idx(z), state))
> +		z = next_zones_zonelist(++z, highest_zoneidx, nodes);
> +	return z;
> +}
> +
> +static inline struct zoneref *
> +first_zones_zonelist_state(struct zonelist *zonelist,
> +			   enum zone_type highest_zoneidx,
> +			   const nodemask_t *nodes, enum node_states state)
> +{
> +	return next_zones_zonelist_state(zonelist->_zonerefs, highest_zoneidx,
> +					 nodes, state);
> +}
> +
> +/**
> + * for_each_zone_node_state - iterate zones in intersect(nodemask, node_state(state))
> + * @zone: The current zone in the iterator
> + * @z: The current pointer within zonelist->_zonerefs being iterated
> + * @zlist: The zonelist being iterated
> + * @highidx: The zone index of the highest zone to return
> + * @nodemask: Nodemask allowed by the allocator
> + * @state: The node state the zone's node must be in
> + *
> + * The state filter is part of the iteration rather than a trailing if, so that
> + * this expands to a single for statement: a macro ending in an unbraced if
> + * silently steals a following else from the caller.
> + */
> +#define for_each_zone_node_state(zone, z, zlist, highidx, nodemask, state)	\
> +	for (z = first_zones_zonelist_state(zlist, highidx, nodemask, state),	\
> +		zone = zonelist_zone(z);					\
> +		zone;								\
> +		z = next_zones_zonelist_state(++z, highidx, nodemask, state),	\
> +		zone = zonelist_zone(z))
> +

A question on consistency. This one is a single for statement, with 2 new helper functions.
for_each_populated_zone_state() in the same patch uses "if (!cond) ; else" form instead.

Both forms keep a caller's else correct. The only difference I can find is that the if/else
form give a -Wdangling-else warning when the loop is the unbraced body of an if.

Is that the reason for the 2 helper function here? If the warning doesn't matter, this could
use the same short form and drop the 2 functions. If it does matter, should
for_each_populated_zone_state() be a single statement too ?

Best regards,
Richard Cheng.


>  /**
>   * for_each_zone_zonelist - helper macro to iterate over valid zones in a zonelist at or below a given zone index
>   * @zone: The current zone in the iterator
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 607373bd83ee6..28a456c3f5964 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -386,6 +386,10 @@ static __always_inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *ori
>  	for ((node) = 0; (node) < 1 && !nodes_empty(mask); (node)++)
>  #endif /* MAX_NUMNODES */
>  
> +/* Iterate the nodes present in both masks without a temporary nodemask. */
> +#define for_each_node_mask_and(node, mask1, mask2) \
> +	for_each_and_bit(node, nodes_addr(mask1), nodes_addr(mask2), MAX_NUMNODES)
> +
>  /*
>   * Bitmasks that are kept for all the nodes.
>   */
> @@ -411,6 +415,10 @@ enum node_states {
>  
>  extern nodemask_t node_states[NR_NODE_STATES];
>  
> +/* Iterate the nodes in a mask that also belong to the specified state. */
> +#define for_each_node_mask_state(node, mask, state) \
> +	for_each_node_mask_and(node, mask, node_states[state])
> +
>  #if MAX_NUMNODES > 1
>  static __always_inline int node_state(int node, enum node_states state)
>  {
> @@ -435,15 +443,21 @@ static __always_inline int num_node_state(enum node_states state)
>  #define for_each_node_state(__node, __state) \
>  	for_each_node_mask((__node), node_states[__state])
>  
> -#define first_online_node	first_node(node_states[N_ONLINE])
> -#define first_memory_node	first_node(node_states[N_MEMORY])
> +#define first_node_state(state)	first_node(node_states[state])
> +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> +{
> +	return next_node(nid, node_states[state]);
> +}
> +
> +#define first_online_node	first_node_state(N_ONLINE)
> +#define first_memory_node	first_node_state(N_MEMORY)
>  static __always_inline unsigned int next_online_node(int nid)
>  {
> -	return next_node(nid, node_states[N_ONLINE]);
> +	return next_node_state(nid, N_ONLINE);
>  }
>  static __always_inline unsigned int next_memory_node(int nid)
>  {
> -	return next_node(nid, node_states[N_MEMORY]);
> +	return next_node_state(nid, N_MEMORY);
>  }
>  
>  static __always_inline void node_set_online(int nid)
> @@ -481,6 +495,12 @@ static __always_inline int num_node_state(enum node_states state)
>  #define for_each_node_state(node, __state) \
>  	for ( (node) = 0; (node) == 0; (node) = 1)
>  
> +#define first_node_state(state)	0
> +static __always_inline unsigned int next_node_state(int nid, enum node_states state)
> +{
> +	return MAX_NUMNODES;
> +}
> +
>  #define first_online_node	0
>  #define first_memory_node	0
>  #define next_online_node(nid)	(MAX_NUMNODES)
> -- 
> 2.53.1-Meta
> 
> 

