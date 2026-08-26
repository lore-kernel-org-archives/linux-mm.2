Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61597C61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231796B0088; Wed, 26 Aug 2026 05:04:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2696B008A; Wed, 26 Aug 2026 05:04:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083AD6B008C; Wed, 26 Aug 2026 05:04:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D27D76B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:04:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2EEA31C0C87
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:04:39 +0000 (UTC)
X-FDA: 85142835078.05.85798E9
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010071.outbound.protection.outlook.com [52.101.56.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F0F6140005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:04:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iuS7iNM7;
	spf=pass (imf09.hostedemail.com: domain of icheng@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787735076;
	b=U2n2pEeK8cqb9KLozu79aZRqNl1POvbXM1/eovApHokJSzjJ47T7XRaNNAQ7ZyRTb4Oz63
	ZYoK+kBomusA9J3Axjb/kwv4Mh/ZQIi+5rMGrkF5Kbwt2HuICMEYsCNYK/NtouZwBgu83x
	u1P1HxFmY9sMg/PfvPi32/gwrS/RF3A=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787735076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rblnGl/TCdSAJxMVSGhWvzeh9VL8vpviygUmxik6MOA=;
	b=M1QfMZDV9OM/0hFtgP3VKEDOIrBVI5jO3GalvqC+yf/ES9OuEerwFpC9w8kiyuOGlgIEJ4
	Wk1NCxZesS0IHQGE08+uUs/4QT2VMZLfICq66wfSfJd5h05xTo4Be0vD39Tdzq3BcelxUs
	kqvBJC8YwidhFGJBz5UoFIzdRSlTOJI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=iuS7iNM7;
	spf=pass (imf09.hostedemail.com: domain of icheng@nvidia.com designates 52.101.56.71 as permitted sender) smtp.mailfrom=icheng@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D+TuGR/UBsUKSqKr3cYs+552jQ2Ef8eiAEfWMFW+t/PS/NJqssM96qQZQMRDJxps2K+hzoIYYpDxjvktf1V17eus98pT9j6SwzM7L41SKpchWwRuyIPfM8wwXVRPfGyenNVK0NVVpyZAoT5sAKMx1LtN6YBnk+9EpA+pMLeO8RM33CThvaDJrzkCM8aUS3cyWWQzrhbbTaVWjZKPzMKQ0g3J+27kwkrW90uOxZiUgFyP4vdugMz7XDMlk/1ygry9xTAsaSE1FVjSU+LcrZaoaQ211wTtfHKAGt0KZ7WQBJLmWJ1VunNzo6Y+GScm9hMMOeVvSty/OzSKuyhwYHYCjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rblnGl/TCdSAJxMVSGhWvzeh9VL8vpviygUmxik6MOA=;
 b=nslBh/l1NtBZjjR/6Y85wh9tLHYnGI8nz5GiYrKf7KsgKxf6caX24oBWTda5ANqOi9Ld5QZa9FES5dx1Ao+FSCgGpRttPqS5YGDbSwhCwXeD3WvrpByBocZ1E/mI4o3Y1/5zn1dethdzJemhDPQdSajAaG3Mu2JEwJ57tUdi1UHloIPIYbyUS8nnlHhsPzdh15hX9JQKf6GWDiVBGzTZYekFYFLnYyyjVUNUnwA6USIrR8Km4OamkG4rOhujfZwN7DVaxDSAJ/k9/xIBpFz5hFwMp2aZ3OzjCgLmNKuwT4KSOqlUB4Xk3bMbUO1THM5JD1WiknvLKiuoI9mqrhKngA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rblnGl/TCdSAJxMVSGhWvzeh9VL8vpviygUmxik6MOA=;
 b=iuS7iNM7MJDr7EHB+2c4t20a0tvWPjBrZTjZMMhZn13IdFOCoiHlkRbj86R/gYblpmhMD7WzTaGPTH/9A/TZHjBS7KXZD2upwL2PPnFOZQZEmV9K3ZeZuKtsA2vjvlMyNRaquObOro0QqXOrfUJ7BbiloJC2BdvJ4zx7TsDb9MEAHZKyKqoWNxwBmSVfTct49bWZs6f5AF9n4W5sSfxgAsMf2KbjcpzU3Ms1PSfJRNzBtQvAPdFcwflqtcNJ/QYOhjIR5Zm4KxkXvL6HKjAo6f10DyF9LQMEoi9Sbjl3Uxg6gL0z6GlI3FB1uxvTkvj4d/bMrXyYOsA/TUSJpgxoJg==
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by CH2PR12MB4039.namprd12.prod.outlook.com (2603:10b6:610:a8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Wed, 26 Aug
 2026 09:04:28 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%7]) with mapi id 15.21.0360.005; Wed, 26 Aug 2026
 09:04:28 +0000
Date: Wed, 26 Aug 2026 17:04:22 +0800
From: Richard Cheng <icheng@nvidia.com>
To: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Cc: linux-cxl@vger.kernel.org, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Jonathan Cameron <jic23@kernel.org>, 
	Dave Jiang <dave.jiang@intel.com>, Alison Schofield <alison.schofield@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <iweiny@kernel.org>, Li Ming <ming.li@zohomail.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Mahesh J Salgaonkar <mahesh@linux.ibm.com>, 
	Oliver O'Halloran <oohall@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, driver-core@lists.linux.dev, linux-pci@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 09/13] PCI/CXL: Disable and re-enable CXL regions
Message-ID: <ao6qbt6JNYxnIfLF@MWDK4CY14F>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
 <20260825022628.3651434-10-fabio.m.de.francesco@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825022628.3651434-10-fabio.m.de.francesco@linux.intel.com>
X-ClientProxiedBy: SI3PR02CA0012.apcprd02.prod.outlook.com
 (2603:1096:4:295::11) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|CH2PR12MB4039:EE_
X-MS-Office365-Filtering-Correlation-Id: d5baac45-698a-4fe6-da0b-08df035108c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|23010399003|366016|7416014|376014|4143699003|10067099003|56012099006|5023799004|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	nxTUW/JPBt7z/it0QoJWdHcqeVboOA/3TOZwOlm4wqsw/H86J3tvVtq/HWe6ayT7Eh0EQYMIfQ44NOArniLxy/BDSOx7r4JK15yO0kzVe6bSap+Od11npkxytNWhWnbmEXK1DgXl/VhD9EnAVIeL08c6L/xPRGydhxhlrvcPlQ7EHirYYA/zflnxMQi9Mkqg5QykZ5N0c8ohXgZnrSVBG4MJH2IuPSaEW/1gFM2g1jr5SFvXr2kyYaJwRKzwdXCUUoPUnZAx6M9YEjQCVAVLOVtyJVxrZLw028KITCOo9MQcgVem98Kx4RZ0UEyAQD8EuE+iZeWA7/eWQ5UxI0nr8iHLJMOQTbmVokSJLqZAqLhJ1E8r2lGisO1l3ev/eOk8sI0bLMYubY8arRxbTN9bhJJXYudICBSQwif6riIuCF61C7HQmSm2VtK1fqnapzEKq/wcGtoVlC1tLQ83ilvYUw+LETPn/7jEApB07DB0Bcr29XGC7Ey3ZlJ7BkvCXpl9lWKhALXsig3+Ror+SxP9MpJhvQCPLV8LpMk1TSyoTxf36RNO91bGThI/+GOICIUJ8tgAC6LBWMIOb3e2hS7HpExfAPONYYO7xdxNibBEfZT7nknrm3oNGmulkAmUDd1iIwBbJAExJcvPbxSQFsp8qig1lm5D2rW96iLdvecJ6eQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(7416014)(376014)(4143699003)(10067099003)(56012099006)(5023799004)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?J7WEku+yBZy3d4CuLZwXgqGh7/V/UgmObUN5KyVXyMaWs8HeSMAA9S+Shm8n?=
 =?us-ascii?Q?dB4JEbGDVAZ2rYBs595yI0fUhW/OEO7lAVR/lHFq5hNjoyqH4I6eSI7DEsHO?=
 =?us-ascii?Q?x4xhyqPhMBJO2wMn5xAdLyZOSs92vOJ2hhv/Gd0yxPfTdtIgVi+7yz13x43L?=
 =?us-ascii?Q?vCjOTli41EbQePIx1fmBYKkKU2VEbfAwEfKbTalgL2l28z9Y8fzcm4b0jrzD?=
 =?us-ascii?Q?rCn4XJtEN4/mqI7M3D3UjWehLPc5NX3Lf39XOy6lqCiuF02bbo+FtqXdUXRw?=
 =?us-ascii?Q?HqeoVA4UVy0KslLS58XhvRgl+d7PC7Y9O13cFngqbe6sSK7J5O/ia3IKq9aC?=
 =?us-ascii?Q?Suw5QadYBIo5wS2GGdQP09IaSxq+GVUr7dUrWJZQNepfyMfFi9bH/zkij1hN?=
 =?us-ascii?Q?8OVi2CfdLekx9h11u4944PIgrDlkj1KZG61LcL7ZdNFj21JsTsh5ARFNTVti?=
 =?us-ascii?Q?ITioGk33QkTxnII2RcCbOXYQA1Dq1b79ehP+vZuv/YEK+BSv0NjzvI/eRhvn?=
 =?us-ascii?Q?lhgyxG4s3kaZKhwR//Wp/4PBrZimqtxYr/Ma2Yfij4R/CWDr9ZtUyhmSND5r?=
 =?us-ascii?Q?lI9A7tSqpIIUL36O7muMdOj99Q5GT8MDnLoDa4tk6mjz7rUv7Q0VhdSVVRGG?=
 =?us-ascii?Q?au9Y2taGNLHg5nPm6sFSS7jvFZilVjroePJYf2kaWWDjIZcp8PbnC9FWW66G?=
 =?us-ascii?Q?1GoHNkBXEoEjcnNjqMHoWqGC5QPqFPl3dUjcYQ9KnHsDvrs7OhSTAFOqafkH?=
 =?us-ascii?Q?ieRnuCbEKEq09+bW9kSOQXGNfsBMu0nXM+48fc3xulHiGKs3TfaPtJtE9sTZ?=
 =?us-ascii?Q?U02X/jDgW8KzzyjhYhtyUkbGbz80xSghgMfT91H0C3JWLvqD14QCz8dK/+/M?=
 =?us-ascii?Q?RdxFycRM0mY9VkCJb+khLOo6/bIjEkTyJU/haM9aMusPJLhr/J4A4HdARH/+?=
 =?us-ascii?Q?cQ3D6hmTkFxihz0oN00ewnftLOr66iYnA5S1/6iQ3E41h0mh6Tjc5xlB8mpI?=
 =?us-ascii?Q?Q+LxDfbKenyvye+2/sO/FDQ1AFuTjtqDECU2kPQpfZo/k/yjS1QxhjpclkVz?=
 =?us-ascii?Q?swnWGys85a+7jdmsn93gJUYDd60ulvn2dlmb2K4/hour4EKL669aOVsjW1Zk?=
 =?us-ascii?Q?T/fewTtwCRSjgVQmpYFo+asgoZi+FCF24Wces23gu2uPduID28EmgGA6qFoM?=
 =?us-ascii?Q?GmBuBBoiaMTYKjJXYxn2O2YsoiGPuseGaNIlv7aOhz4cHuvt2Vw4KSh1W4fo?=
 =?us-ascii?Q?+JduC8eF0dxHMZ+yQQxMjBIM4KpGcZgYWIwVHvlB0B3y1L6DbXrkYfzDvdi9?=
 =?us-ascii?Q?CxfovznP6nJ36g75FSHDL77K83icLcxXIWTP91Qv5XDlLB3nXKHyjgb418rC?=
 =?us-ascii?Q?psVVPFlSt1TxLWpEgYYjqdiiwhv6+X7q8N7IPkZfHPlVJbEB9KrI8gHGcBcE?=
 =?us-ascii?Q?06atXkW0mMZDtuBrDPr9O/vTqW0cFv6IU3U3z6diE1tLHJGufNAi5PFMWDn5?=
 =?us-ascii?Q?haZCF4q6mMotkVLAJatIUkJxleSWh4xgAJ4sPwr0UscXGkV076Pnu7QzRKrp?=
 =?us-ascii?Q?Snq3dJ4TymvXZ/0MTag2kGJr2ZcixUotLYnxEQtOOLBWHJ5nvJlO5yV2Bbiu?=
 =?us-ascii?Q?O9hipxxm3Cym7AR4ofq5dqC7+MeZ/sJTBXFooOB+SI+49YvJTbkSAmYT00OV?=
 =?us-ascii?Q?JgwNb7NCspICkBxQUKxCUHBCw5zlXulB/pt+IpuNYHbWSRKvftSqmCc26uCg?=
 =?us-ascii?Q?e11BZhQ4MA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5baac45-698a-4fe6-da0b-08df035108c9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 09:04:28.6512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2jej7qlJbs/fygqJQCY59X/0LiHyOWkaFWoMSAs9m8XHqmvwhmP9jIPsJQbGg5cGSjDnr7shUJNemCqKyXEFJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4039
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F0F6140005
X-Stat-Signature: uyy58i1b8mx5x5en8n68hz1ok4i7qdmg
X-HE-Tag: 1787735076-90413
X-HE-Meta: U2FsdGVkX19Sngl+c40+WUPmMxwPCShRvfcVEg/jiEMroy4rVHh/eiazQ0LXQelPJooc4J6srxD4OMXuWUhZ0Sdu2tgj3KMJ68YquRrFYmFApxFKTizsz2BSUIof0sFC3mCAWrSVNFdDHk3y2TBQNxOVrRrAhKeNTRQxe0KyQuMj7yaHEqEROFvFf84HYVawJih6wnNaEoF97Wz99dW8S0iJwYwfnbHmrr5mf7W32UMnoL5ViL/yYPbKafi2eIIvYgReZGStLTyRZtfJlxNb3TJMDgTI50jxTxQw1gkJMXo++FumeID5BpkdB9m0FH/e9BIHAJLx9+btLYGQYo/rRatnoUzgu8LY+BQmxWjzjmBer7u7ahL+SnyGpwUbBj4aYNNleNVlCgOzXnjK9AVvuaGF5E9JtzyAju2LPZT52qElphFVckqjLT+idk1l8eIhBibXge/yqGu8rlj/8JiKH1UJdHtSnfV8F2bw9Ac3E+J+ex2SvjW62xOOoeVkqbe8wBBAzI31vN63WuqAerg62B6QQjHOTGuUbLFCwM7JvOxxhTaKNIZbFRcVa3uwv0/aTsCqzhDM/5pbRJJf30zbdSfRqf43X2edJ2X4k/PlwHoPXAZodHKu1w2XyQQ3q+OEdgQoCcIi3wLFQBq717/tGFjUOZEG5jxqUAfmsAr3ZYv5+fWXd6/CHBgz4Du3ptsuvgwTCxGeNo7T7unzbozHSmb4cWpIbgay+K8vIcwlG525b3+9KCdoDozZl3nb8E3jcC9LQh5UsIlBKryuX9IL1z33+DRpNReX853c2jwyWD100LJvwBoh7Wm3M7UarfDJSkngOjdKluH0pyVjr5EKqzms00zuWC4pHh1ZtgCG9M+ON3pW4jOCi4eeC6pIE7NVaKW85TPKyt005FhVCyvM93+BfVZsnraf1jZFLJhPCViolF+fxYNNRTUxiWr2aePGdmCI3M24tx7bJ1VG34t
 os0zE71y
 cVyuqwTo57qtI2rRVrAuAVTyttPSJxMFEXv0U++qCvUl2UWVxLL8DH73A+54JsTIw5lk+5tS2Si3cY+U8tCZD7doPL6+supHAGUvVL7IEGWcdjdv8Wd11O1J0GeLgdMKR3CJiQ4eL6JUc2nHbPAn0AZz8O560tFsqZZKbgZy1B7QjIRGaSMF9nUpVM3BTHNJKX7iBfiBplmokFWkP3XLfJ7tjfF9l286zQORXcpMzeL6RptQp6BrvEeOsUKxPrjjCM2V5VRF5JTbEBtwvR+R4WwP5LCgW2l2bAxsWtCd8/AstVy8Ij2GuyK0JzOahUUMO+wyImwl3Hn6D6bg6BG88cGY6+cGVHfQnL4iOV2pEeFC13u7ah3NHT89ON/4B8B8aqWW5W7Ai0jVaNtJEAE2Y7OT7gJPZ5KrBXsDHpzHxLisKfZ5vYbgJGG7CqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 04:26:24AM +0800, Fabio M. De Francesco wrote:
> A Secondary Bus Reset of a CXL Downstream Port needs every CXL region
> routed through that Port disabled for the duration.
> 
> Add struct pci_cxl_sbr_region_ops, holding a disable_regions() and an
> enable_regions() callback, and pci_cxl_set_sbr_region_ops() for the CXL
> core to register them. The pointer is NULL whenever the CXL region code
> is absent, either not built or built as a module that is not loaded.
> 
> Add cxl_sbr_disable_regions(), which collects the regions with a member
> endpoint below the Port and disables each one. If any fails, re-enable
> the whole collected set and return the error, so the PCI core aborts the
> reset before touching hardware; re-enabling a region left untouched is a
> no-op, which also recovers the one that failed midway.
> 
> Add cxl_sbr_enable_regions() for the other side. It restores the HDM
> decoders below the Port before it re-attaches any region driver, since a
> region cannot serve memory through decoders that are not programmed.
> 
> cxl_sbr_disable_regions() records the decoder registers before it
> touches anything and cxl_sbr_enable_regions() hands them to the restore
> and releases them. They are held in an xarray indexed by the Downstream
> Port's struct pci_dev, so resets of different Ports do not share an
> entry, and they are released on the abort path too, where
> enable_regions() never runs.
> 
> Register both ops from cxl_region_init() and clear the pointer in
> cxl_region_exit().
> 
> Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
> ---
>  drivers/cxl/core/core.h      |   9 +--
>  drivers/cxl/core/dport_sbr.c | 152 +++++++++++++++++++++++++++++++++--
>  drivers/cxl/core/region.c    |   3 +
>  drivers/pci/pci.c            |  13 +++
>  include/linux/pci.h          |  12 +++
>  5 files changed, 175 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
> index 077a2af9cf0c..b250fa346184 100644
> --- a/drivers/cxl/core/core.h
> +++ b/drivers/cxl/core/core.h
> @@ -57,13 +57,8 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr);
>  int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
>  void kill_regions(struct cxl_root_decoder *cxlrd);
>  int cxl_region_invalidate_memregion(struct cxl_region *cxlr);
> -int cxl_region_disable(struct cxl_region *cxlr);
> -void cxl_region_enable(struct cxl_region *cxlr);
> -struct pci_dev;
> -int cxl_sbr_collect_regions(struct pci_dev *dport_pci, struct xarray *regions);
> -void cxl_sbr_put_regions(struct xarray *regions);
> -void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
> -			       struct xarray *hdm_state);
> +struct pci_cxl_sbr_region_ops;
> +extern const struct pci_cxl_sbr_region_ops cxl_sbr_region_ops;
>  
>  #else
>  static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
> diff --git a/drivers/cxl/core/dport_sbr.c b/drivers/cxl/core/dport_sbr.c
> index 233499bc1fad..2b6f840e22a7 100644
> --- a/drivers/cxl/core/dport_sbr.c
> +++ b/drivers/cxl/core/dport_sbr.c
> @@ -21,7 +21,7 @@
>   * Context: process context. Offlining and driver unbind sleep and take the
>   * memory hotplug lock, so this cannot run in atomic context.
>   */
> -int cxl_region_disable(struct cxl_region *cxlr)
> +static int cxl_region_disable(struct cxl_region *cxlr)
>  {
>  	struct cxl_region_params *p = &cxlr->params;
>  	unsigned long block_size;
> @@ -72,7 +72,7 @@ int cxl_region_disable(struct cxl_region *cxlr)
>   * Rebind the region driver. The System RAM is left offline; bringing it back
>   * online is a separate administrative step.
>   */
> -void cxl_region_enable(struct cxl_region *cxlr)
> +static void cxl_region_enable(struct cxl_region *cxlr)
>  {
>  	struct cxl_region_params *p = &cxlr->params;
>  
> @@ -93,8 +93,8 @@ void cxl_region_enable(struct cxl_region *cxlr)
>   * cxl_region_disable()/cxl_region_enable() run with the rwsem released (they
>   * unbind and rebind the region driver). Hence snapshot the set first.
>   */
> -int cxl_sbr_collect_regions(struct pci_dev *dport_pci,
> -			    struct xarray *regions)
> +static int cxl_sbr_collect_regions(struct pci_dev *dport_pci,
> +				   struct xarray *regions)
>  {
>  	struct cxl_region_ref *cxl_rr;
>  	struct cxl_dport *dport;
> @@ -141,7 +141,7 @@ int cxl_sbr_collect_regions(struct pci_dev *dport_pci,
>  	return 0;
>  }
>  
> -void cxl_sbr_put_regions(struct xarray *regions)
> +static void cxl_sbr_put_regions(struct xarray *regions)
>  {
>  	struct cxl_region *cxlr;
>  	unsigned long index;
> @@ -159,8 +159,8 @@ void cxl_sbr_put_regions(struct xarray *regions)
>   * requires. The caller has already disabled the regions, so nothing reaches the
>   * decoders being reprogrammed.
>   */
> -void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
> -			       struct xarray *hdm_state)
> +static void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
> +				      struct xarray *hdm_state)
>  {
>  	struct cxl_dport *dport;
>  	int rc;
> @@ -179,3 +179,141 @@ void cxl_sbr_recommit_decoders(struct pci_dev *dport_pci,
>  	if (rc)
>  		pci_warn(dport_pci, "HDM decode restore failed: %d\n", rc);
>  }
> +
> +/*
> + * The HDM decoder control registers the reset is about to clear, held from the
> + * disable to the enable of one Downstream Port and indexed by that Port's
> + * struct pci_dev, so resets of different Ports do not share an entry.
> + */
> +static DEFINE_XARRAY(cxl_sbr_hdm_state);
> +
> +static void cxl_sbr_drop_hdm_state(struct pci_dev *dport_pci)
> +{
> +	struct xarray *hdm_state;
> +
> +	hdm_state = xa_erase(&cxl_sbr_hdm_state, (unsigned long)dport_pci);
> +	if (!hdm_state)
> +		return;
> +
> +	cxl_port_put_hdm_state(hdm_state);
> +	kfree(hdm_state);
> +}
> +
> +/*
> + * Record the control registers of every port below @dport_pci before the reset
> + * clears them. cxl_sbr_enable_regions() consumes the set and drops it.
> + */
> +static int cxl_sbr_save_hdm_state(struct pci_dev *dport_pci)
> +{
> +	struct xarray *hdm_state;
> +	struct cxl_dport *dport;
> +	int rc;
> +
> +	struct cxl_port *port __free(put_cxl_port) =
> +		find_cxl_port(&dport_pci->dev, &dport);
> +	if (!port)
> +		return 0;
> +
> +	hdm_state = kzalloc_obj(*hdm_state);
> +	if (!hdm_state)
> +		return -ENOMEM;
> +
> +	xa_init(hdm_state);
> +
> +	scoped_guard(rwsem_read, &cxl_rwsem.region)
> +		rc = cxl_port_save_hdm_state(port, hdm_state);
> +
> +	if (!rc)
> +		rc = xa_insert(&cxl_sbr_hdm_state, (unsigned long)dport_pci,
> +			       hdm_state, GFP_KERNEL);
> +	if (rc) {
> +		cxl_port_put_hdm_state(hdm_state);
> +		kfree(hdm_state);
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * Disable the regions routed through the Downstream Port being reset. On
> + * failure re-enable the regions already disabled and return the error so the
> + * PCI core aborts the reset with the topology unchanged.
> + */
> +static int cxl_sbr_disable_regions(struct pci_dev *dport_pci)
> +{
> +	struct cxl_region *cxlr;
> +	struct xarray regions;
> +	unsigned long index;
> +	int rc;
> +
> +	rc = cxl_sbr_save_hdm_state(dport_pci);
> +	if (rc)
> +		return rc;
> +
> +	xa_init(&regions);
> +
> +	rc = cxl_sbr_collect_regions(dport_pci, &regions);
> +	if (rc)
> +		goto out;
> +
> +	xa_for_each(&regions, index, cxlr) {
> +		rc = cxl_region_disable(cxlr);
> +		if (rc)
> +			break;
> +	}
> +
> +	/*
> +	 * On failure restore every collected region and return the error so the
> +	 * PCI core aborts the reset before touching the hardware. Re-enabling a
> +	 * region left untouched is a no-op, so enabling the whole set also
> +	 * recovers the region whose offline failed midway.
> +	 */
> +	if (rc) {
> +		dev_dbg(&dport_pci->dev, "%s: disable failed (%d), re-enabling collected regions and aborting reset\n",
> +			__func__, rc);
> +		xa_for_each(&regions, index, cxlr)
> +			cxl_region_enable(cxlr);
> +	}
> +
> +out:
> +	cxl_sbr_put_regions(&regions);
> +	/* No enable_regions() call follows an aborted reset, so drop the set. */
> +	if (rc)
> +		cxl_sbr_drop_hdm_state(dport_pci);
> +	return rc;
> +}
> +
> +/*
> + * Re-enable the regions disabled by cxl_sbr_disable_regions(). Restore the HDM
> + * decode first: a region cannot serve memory through decoders that are not
> + * programmed, so its driver must not re-attach before they are.
> + */
> +static void cxl_sbr_enable_regions(struct pci_dev *dport_pci)
> +{
> +	struct xarray *hdm_state;
> +	struct cxl_region *cxlr;
> +	struct xarray regions;
> +	unsigned long index;
> +
> +	xa_init(&regions);
> +
> +	cxl_sbr_collect_regions(dport_pci, &regions);
> +
> +	hdm_state = xa_load(&cxl_sbr_hdm_state, (unsigned long)dport_pci);
> +	if (hdm_state)
> +		cxl_sbr_recommit_decoders(dport_pci, hdm_state);
> +	else
> +		pci_warn(dport_pci, "no saved HDM state, decode not restored\n");
> +
> +	xa_for_each(&regions, index, cxlr)
> +		cxl_region_enable(cxlr);
> +
> +	cxl_sbr_put_regions(&regions);
> +	cxl_sbr_drop_hdm_state(dport_pci);
> +}
> +
> +const struct pci_cxl_sbr_region_ops cxl_sbr_region_ops = {
> +	.disable_regions = cxl_sbr_disable_regions,
> +	.enable_regions = cxl_sbr_enable_regions,
> +};
> diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
> index fc0bec991a69..d1dd4924fba1 100644
> --- a/drivers/cxl/core/region.c
> +++ b/drivers/cxl/core/region.c
> @@ -12,6 +12,7 @@
>  #include <linux/idr.h>
>  #include <linux/memory-tiers.h>
>  #include <linux/string_choices.h>
> +#include <linux/pci.h>
>  #include <cxlmem.h>
>  #include <cxl.h>
>  #include "core.h"
> @@ -4263,12 +4264,14 @@ static struct cxl_driver cxl_region_driver = {
>  
>  int cxl_region_init(void)
>  {
> +	pci_cxl_set_sbr_region_ops(&cxl_sbr_region_ops);
>  	return cxl_driver_register(&cxl_region_driver);
>  }
>  
>  void cxl_region_exit(void)
>  {
>  	cxl_driver_unregister(&cxl_region_driver);
> +	pci_cxl_set_sbr_region_ops(NULL);
>  }
>  
>  MODULE_IMPORT_NS("CXL");
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index 77b17b13ee61..417b6b44473e 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -4844,6 +4844,19 @@ void __weak pcibios_reset_secondary_bus(struct pci_dev *dev)
>  	pci_reset_secondary_bus(dev);
>  }
>  
> +/*
> + * Registered by the CXL core to disable and re-enable the regions mapped
> + * through a CXL Downstream Port across a Secondary Bus Reset. NULL whenever
> + * the CXL region code is absent: not built, or built as a module not loaded.
> + */
> +static const struct pci_cxl_sbr_region_ops *cxl_sbr_region_ops;
> +
> +void pci_cxl_set_sbr_region_ops(const struct pci_cxl_sbr_region_ops *ops)
> +{
> +	cxl_sbr_region_ops = ops;
> +}
> +EXPORT_SYMBOL_GPL(pci_cxl_set_sbr_region_ops);
> +

Is the lifetime of this callback table being protected ?

cxl_core can be a module, PCI reads the pointer without sync or a module ref.
It could see a non-NULL pointer.

I think the callback table registration needs synchronization and module ownership. PCI should pin
the provider for the complete reset, for example with an owner field. Unregistration should first
stop new users and then wait for any reset already using the callbacks.

What do you think about this ?

Best regards,
Richard Cheng.

>  /**
>   * pci_bridge_secondary_bus_reset - Reset the secondary bus on a PCI bridge.
>   * @dev: Bridge device
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 64b308b6e61c..2feb0e355305 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1606,6 +1606,18 @@ int devm_request_pci_bus_resources(struct device *dev,
>  /* Temporary until new and working PCI SBR API in place */
>  int pci_bridge_secondary_bus_reset(struct pci_dev *dev);
>  
> +/**
> + * struct pci_cxl_sbr_region_ops - CXL region callbacks for a bus reset
> + * @disable_regions: disable the regions below @dport, 0 or errno
> + * @enable_regions: re-enable the regions below @dport
> + */
> +struct pci_cxl_sbr_region_ops {
> +	int (*disable_regions)(struct pci_dev *dport);
> +	void (*enable_regions)(struct pci_dev *dport);
> +};
> +
> +void pci_cxl_set_sbr_region_ops(const struct pci_cxl_sbr_region_ops *ops);
> +
>  #define __pci_bus_for_each_res0(bus, res, ...)				\
>  	for (unsigned int __b = 0;					\
>  	     (res = pci_bus_resource_n(bus, __b)) || __b < PCI_BRIDGE_RESOURCE_NUM; \
> -- 
> 2.55.0
> 
> 

