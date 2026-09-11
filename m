Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A455AC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 880576B0092; Fri, 11 Sep 2026 11:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 831E76B0096; Fri, 11 Sep 2026 11:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7218F6B0098; Fri, 11 Sep 2026 11:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43F5B6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:26:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF4284027E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:26:45 +0000 (UTC)
X-FDA: 85201858770.12.A9B58C8
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010047.outbound.protection.outlook.com [52.101.46.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id F29FDC0004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:26:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jmZ/beMa";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789140403;
	b=0BpgnwQ44hkp93Wxo3eS66hNPazHKzN7TZousxj4EQQTlu7Jdc9yFGi2h4tidWAXZrvKyb
	GuFTyJ7n8hTT3qx6AsFQ4vqfwt51ejN5ILo6JfXhoHYIvP6g6/ZNk3atJtKcDltP9TIkSB
	pt0cfwyidV6oHbK80i/E4XSCObCYvq4=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="jmZ/beMa";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of ziy@nvidia.com designates 52.101.46.47 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789140403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZcebxwBwm/CpTEF66jE2VChDK3d8/p2s/e0oZguYYM=;
	b=CKd0XrS7zwWz+jekX3FQ/9o2ThP4V9fINmktcQEZtHBL4IOn4YpONWvRRML/QphaoWyFyU
	6yRUXK1XsjsJSwqkgyAxdjG56FInQfrg92uHTDPUGV7GWx9u1rwyXhDOqWrdZ33JHIM4FY
	utLpZXHMIds9MViOIPIRVCjvvLkoxfk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ky23akb3zQyhT5DuT1qRbeoGh53BAcP9aikkzzTx56XbIkstyPT1yWsB5kBtghLw+T3s7ke+L5BS6/87efqSWtp1DJK0Ae1WlF1ErF5LbMK+4pt8Qt3DUD/UYSkuCehdBr9+p3fBS9Ba0Gw6kyuMBH/Ug1yFmnQ4GpiKAuEtclxqTKkeyUELJLAScv4aosJ/N7w/bFG3xJdbjMfWBzeq6MPbDXn6cu9yVNx3/585f7CjgHqazSd7DDN4e0p6B6G+RzE14hbnqD6JTJA2OiiFKi7NhBnhpCbDci27B4ETfxgbt3AnWnHRznAM+qtm8BEGrrIuCdf9nICVOtEDj5FjDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vZcebxwBwm/CpTEF66jE2VChDK3d8/p2s/e0oZguYYM=;
 b=cxgMi8iFxkhtPuF7qdaf696mQ9DebjgCyUMU/bOA31T5jSmNieJ8XR5XSMpPvvNj9Q6d0NiK2tLHm/oYk3al3e7bOlq7aUNnrOuoMzjeluFgLeiDGIU2hSgT+ZaaDvfO6EzKcWQey1lrrg5BNhArfO7o1MnqAaHjAtZzQ+oM48wdC9Bg+DSGDO0XVpA3XJz0/Q8pFeUWclYt7edmv389vJfGvVXhQqfDI4M5CHpghMSwpCBut7hJ0+p45SWt1V4jrJfnHUAeWECwD8+KrE8W0pz2euLWI02fm4pdfj2ZwiLGth3V1+fepwMMPKZM5ef8FXxbv5v6/n/Oxmze0P3AcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vZcebxwBwm/CpTEF66jE2VChDK3d8/p2s/e0oZguYYM=;
 b=jmZ/beMa1P8svcWrbciX/1HatM08tZjGC39VQuntxgvpuJ6KhATh0n5DozCv9rg5VS6rYqVkIFnHYaIy+t/Xfv3PJdEUsysF6AUBY4R3ic9Li5SZdQVA0VX5tZ2978oIaqYgCKdDZOO/brMYmaOMbybKvWw1sQoS/3M0N4JDilxVWypm2iJTme9QgWVtrRH2RzOdoX2wnYuhoxqhzXpHvA5xi7us0rPTxdnaXJAPytKTTZv9yPWLuc2I8Qg2SNK8hpOoP5L8YZ9fKzZBIbrZT78QmVVTmf0eOogvz0aEJCuM9mbF4x0u2HdJq0d2u2Fwqrc2cLY4Srj1scXxP90yLA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA0PR12MB4349.namprd12.prod.outlook.com (2603:10b6:806:98::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Fri, 11 Sep
 2026 15:26:37 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0406.007; Fri, 11 Sep 2026
 15:26:37 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 09/12] mm/collapse: open-code collapse_single_pmd() in
 its two callers
Date: Fri, 11 Sep 2026 11:26:39 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <EAC13ADA-9B0D-4B16-A731-66062266854A@nvidia.com>
In-Reply-To: <aqQaxyxQYD_1KHju@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <20260910120238.2529819-10-kirill@shutemov.name>
 <DLCKQ4T6VJZA.3KVN87GD21IBI@nvidia.com> <aqQaxyxQYD_1KHju@thinkstation>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0699.namprd03.prod.outlook.com
 (2603:10b6:408:ef::14) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA0PR12MB4349:EE_
X-MS-Office365-Filtering-Correlation-Id: 92cd523e-b971-4cdf-f198-08df101911d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|4143699003|11063799006|10067099003|18002099003|22082099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	0epPkXweWWy/aEL/gRN/8Lk7r33u0qdeLCJ4SnZ3v6dBzbqvlnCj211YtO6YNbEUtogTBZXFh84n8J5RhgWTiX2gRkNHYq65OZzneiuSsEuwgys9AcQn7wGpdl68zU+wukjl+YiRPshJN6EQ+p508NPZ4hN8ebmnu0Y6Yay2+qpBsLY94b1SxuRND3UvAj9CW3LaEAiwuZKi86RfiVNbjc0SK/HBC90B7uRnBrntxeYxfsRrEc2fMJCD6G1JDwmqHg4sBukAjUABLteytb/OsT/Fkvxd5YNzTEiMdmPyoo12il7HgneWfzF+3bH6YLATr9TgiZu63iewbjbbriHsYdlJUCdLZXWIZBj+iJlDxBQd+Q/hQqBhNbJdheDNXyap3y/cpPNMPflLcmQCtDcyAVF3QSwcT3hv/oWsQ8+LAT6Wfxumcur7yeR5PQWyOqyysiWbuJMOfP6ZEhQF1G9LvuC4iPnBe46jUUO9MarRdn6qSmiyfFcx6NKE69TYRXc5i0bG2ywCzbL9QZ6xvhAxavYVUy8AQ0Q2Lad54XytXrIz+/L7wwX61an03+lQ2PgN/9zW5eW1oPtGQrdDJ+Hwfa8NVd82b9G574g2/4ZOZeztU1+9JTTdLaoMpk3NlFz1+zMrAe+Q9FJyW4yhHyjVm1LOOQyWTBuDMZiC+auskO0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(4143699003)(11063799006)(10067099003)(18002099003)(22082099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YZO9ocI3b9SFPdzzgMPhPgzZL0H+JbW0MWqHmaOhEBRu6PNjRTv9Zho5eTgT?=
 =?us-ascii?Q?bYskcTSGKBaMkKsz0ym99h1VoKdu+gdfAGXEYNcl4mKfB53inY+1FcTijyrC?=
 =?us-ascii?Q?zOreWsYssk43jAkMXYOE53+o511hREwqTy5BMmjU6sfAtI54YYwE5qby/OHA?=
 =?us-ascii?Q?6EjxerUlog3+EYbXmEKctEXpLiCPR72+UcsWhAgvwYJVvHbvwfMRTZM0jFva?=
 =?us-ascii?Q?EFJfh1TF3tiBlI8J/QE4J4e8BxiWYSpmeDFMbixg0LQdpluRB7ypVpXPpeiU?=
 =?us-ascii?Q?0kkImufBcq8D50/KmX2ItZyKewT2ZX0Hwpc7YrWCNUAUVazskL82DN2Ke/AR?=
 =?us-ascii?Q?kk0A9W2SUaAj6FWyp81rBt3BaWZyOkue/28qf9PpPFuUieHh2Bnel9EPH5Ig?=
 =?us-ascii?Q?cbrotz9CVio7rG9snTgJpOWewm9eti1kFPpTT2HBJs0izp3OeQ3wfAcxQqAX?=
 =?us-ascii?Q?qNZrxH71hux1XOINR25Ti3NlgkXKACVIWDpBtJ4rdAMaHy2BPy6qVaMrdRrJ?=
 =?us-ascii?Q?/x89uAtNOVUx2Z+yFF5kuPNuuGiTFhX72xQsqWSLCCCLBpWmFQtzTeD4Sb8q?=
 =?us-ascii?Q?93MK2KqBw0Kg3o0Ppiw02b/XppUBEGvQcGx+DnIXoPAvf3sK7KyOrc16fTm4?=
 =?us-ascii?Q?dSXVwd89WtVYUVaRyYc9txl7ULN+PVkLakR/WpJjQUCWpPbFOEfSVYQ8Rbr7?=
 =?us-ascii?Q?WqwETYSplRKnn/BNMYCmNd6w1EwA+YR4zSz3cBlixUK4ln2HzY5qM2+6mxdZ?=
 =?us-ascii?Q?M1lV+e8vf+uSihjlYONpJXqaKeZogziPdAMYQED2dC7mSLrughSXuaEnE9u4?=
 =?us-ascii?Q?0XeMk9T8KKV6FGFamSlhkYulGVD8U5Rk1mNUeYeTPwz8uk9uSJ3oCpZj00s2?=
 =?us-ascii?Q?wRqcjIYBZKwJh/7lf3n6UoEzBm+3aa/8nGErZzL17aVH/bc5hvj39+MkaFdD?=
 =?us-ascii?Q?MrRWKx1C+DuruIswZTGOztt5cI38GyYldFqVG0792XLHSYL2sqFNQPaDAA9X?=
 =?us-ascii?Q?ZUnW8EEy9Pi3hO3gmMv6ku4vQnuZWofvc9M/HwnXVbNhSeVi4Y4X2YcEArr0?=
 =?us-ascii?Q?mjR/X3/Gz4pchwWqQOrD3WQG+2Wj+HqntAXQntnkz0/cd+BioyS7sW0R/3wL?=
 =?us-ascii?Q?9/H1nmtffU/j+u9bWWOoRI2tGgnFcXE8X0iTTeoxdd1v88h7mCAGTY+KUD2L?=
 =?us-ascii?Q?/sdEAxpwOnE8A4yy1+oQqx1AQKF+ibpAvnwd7OFqRVsHyq3i2mv4PSPivSRg?=
 =?us-ascii?Q?bYHiIYZ/0RFDi3z4u34u2pIjfGF0+N41OY9zxP7p7/ClzBL8um9EG7tiTs8p?=
 =?us-ascii?Q?SR+2mCHZc69IzD/KobUd3kVskEZIfViCmn3LQ7p4tGVjWdV47WGUYidwNXbe?=
 =?us-ascii?Q?dVieQB9UsFRop9M/VpiM/OXE21I+PWWqf+U2QjnvLmcbirE72j5x96qqzKoI?=
 =?us-ascii?Q?uTVmd0Yr8j3ycWtmKxlkJX1ferNU67vW0yf/15u+88v5T+myryANAl7xFEXw?=
 =?us-ascii?Q?/OH2hYNeYul63pJCYILHngmUlDzN7k7QMdo1MMM+LWahh0rNCgver426V03R?=
 =?us-ascii?Q?iCuejshiQRE7BSNOWQhUdA5EyTt/d+sXOAy4tst40iJPXUBq+cfgAahK2ayb?=
 =?us-ascii?Q?K4R/xf/W2nU5wIRSmvHS/stNS07amwKUXD1lsWeNOqXScsyG4ofJrLW0Ycs7?=
 =?us-ascii?Q?VNAdx6sTIa9fcC6E3R0spm/YP2pTVTBcjKm4HaBrkQg9qtkW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92cd523e-b971-4cdf-f198-08df101911d2
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2026 15:26:37.0689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b6xrQ4xghSt9EtSSD8zq1Y6P1MQ4ILC0o+F/72NQbClv/Ttc2mM+HatvnyqnKb/i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4349
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F29FDC0004
X-Stat-Signature: phofbfdr1nhttcefnj9e75ia5i8eaa9s
X-Rspam-User: 
X-HE-Tag: 1789140402-136171
X-HE-Meta: U2FsdGVkX1/TiFlkY3uD7jb5xeQP0OwQpoNz/jgVqR5MzYE9rtQHQQZgKOwy9uAySeEUSdWdBJBVU0V7rCGAYAxUxlSNdIbllJGN9PQzwYZmSCbMR8skrXhluoqIm1/y9nhv5H/CseseM28WT9McID/ajtNqUgnIOcOXsK0JDyaUEXC5u+TL4VnlK3/q6hFdXbqm7wLMHvxzfwpuQv1eVUuc/jdJzl/g6CjIvjU3+527Imb6eiG56CzWAxIi9v/ocSN6bMM9V6qyZuBdCj5/W4B46k5xCMVGtoqtrw8xtzX8mkrYHt+XIVTWMZB+Eq729WQpN6dsVjzzsCcDtYF6URLGndkRHlSlem5N0+tbD8jViUO5S4lThFo9y7HTOWxVYH6PVQ/rg2mtUT54C8euPuQxG/Bw68zzzn7Rv+s5KLvjwbzerBr641PJ+77AsKMC7NoxbZr9OQebz3V05SrPKuRx1AXdqjn3QHRWfQrgPKxege6uZgEVgaZXYupWCMcsu3s1SnPny/MRTDTY4Oh+/lNP2ssSJpi57lAtPkF0pH68H+dvqL+xxbq3DXNGhZT/u/LhwPDFYSx8y6sFrtdEZjLXtCmqlZTEC+RHtd66oNVmKd8r2xQFBYfUfAo1+VoPLY8mPCtTxwpZ9nwAS8dzq84JoBtEl5vXxddXcjtjr0I/ERjSqGEWoGahZ23D5XGfQw8d5RGgD1nQ/1DYtdoM+OWQZZ5weU9goSmksm7balUEFBl0j19RL6raIOBaweTc3je0vqp6ayNSYrd3Ug5WNn2/CHymmcu5UTN4cPogktb/u5O5pteMVilEIyDVyZdaDWuf3Sx5WBcIDWSbOTfWgXxW0z8cA8qY62RIKEAPnGQKIivdVTlYXDu+K7+sOpRMZ1xc4lIL0rD7QLVYzAWn793rmfriiuLRac6DkguactzHxpF8Y79IoYOWwU1eR8DbPBF4IgT4RBKyCFOu4mW
 P0Snvz4E
 1S/zzpcHXAJqK+wSui7mJftQufk3AOhN70KBdf1aHdwMH5Dxq4C/Xww5bKG+wj7PzW1NIC/nfL5doGpzH9Dzu6FoT2VjMSb95pJx7+uwlTuT5ao6ioaUePwcQdCIH9tfANqVdWwGaof1+sE7FxIj9AyQdDwwFRqI17YfMjLooZ+Mnn6OnewfnTEPo8SIbRobWuIevUTvCIFxasPcgZHd4bW5zQ7CiFUaG/grwJEqvWcHliT086dHiwKhzeUFDOKMBpxYzCETPObnilymoPGBrvEvaMl+DeVTw/Tn0Q1S9efZNk/Xa0lD1mmbOr/hamRLnhJFAM0AItNwACSbiCTEnJSL1F2UYlMj0HDbXp8FSQ9JkWwPcWCo6N252mCf2prw6/qsJcvb5tQ5N2d6jAg7J9OBshEHqN81NTZJODrfhlUMcVSbU/GQly43L/NglOZd9CLLu4IymixQ//IU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11 Sep 2026, at 11:24, Kiryl Shutsemau wrote:

> On Fri, Sep 11, 2026 at 10:57:46AM -0400, Zi Yan wrote:
>> On Thu Sep 10, 2026 at 8:02 AM EDT, Kiryl Shutsemau wrote:
>>> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>>>
>>> collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
>>> contract.  The scan is called with mmap_lock held for reading and returns
>>> with it still held.  The collapse is called without it.
>>>
>>> collapse_single_pmd() kept that boundary inside itself.  It dropped the
>>> lock on some paths and not others, and reported which by way of a bool its
>>> callers had to carry along and then act on.
>>>
>>> Open-code it in the two callers.  Each scans under the lock it already
>>> holds and, on SCAN_SUCCEED, gives the lock up before running the collapse.
>>> khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
>>> the code dropping the lock is now the code that wanted to know.
>>>
>>> khugepaged's walk carries on to the next table while the scan keeps
>>> refusing, and ends once a collapse has taken the lock from under it.
>>> madvise_collapse() re-finds its VMA after a collapse, which it did before,
>>> and now uses a NULL vma to say that it has to.  It still reports the drop
>>> to its own caller, from the line that does it.
>>>
>>> The lock is given up and taken again at the same points as before.  No
>>> functional change.
>>>
>>> Assisted-by: LLM
>>> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>> ---
>>>  mm/khugepaged.c | 102 +++++++++++++++++++++++-------------------------
>>>  1 file changed, 49 insertions(+), 53 deletions(-)
>>>
>>
>> LGTM. Thanks.
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> One question:
>>
>> What prevents us from doing:
>> while () {
>>     1. mmap_lock
>>     2. scan_pmd
>>     3. mmap_unlock, bail out if needed
>>     4. run_pmd
>> }
>>
>> for both cases? It improves readability. What is the downside of
>> dropping the lock during multiple scans?
>
> The scan/run ratio.
>
> Once memory is mostly huge nearly every scan refuses, and a refused
> table is cheap: one pmd read for SCAN_PMD_MAPPED, one PTE walk under the
> PTL otherwise.
>
> In your version of the collapse loop, mmap lock/unlock plus VMA
> revalidation would dominate the cost. It is not productive.
>
> Note that scan in khugepaged is bounded by pages_to_scan so we would not
> hog the lock.
>
>> for madvise_collapse(), I see mmap_read_lock is held when it is called,
>> so it can be dropped at the entry and the code makes sure it is held at
>> the exit.
>
> That makes every MADV_COLLAPSE report lock_dropped, including one on a
> range that is already huge, which today never lets the lock go. The same
> performance consideration as above.

Got it. Thank you for the explanation.

Best Regards,
Yan, Zi

