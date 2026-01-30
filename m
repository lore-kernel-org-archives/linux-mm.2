Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67812D73EB8
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 03:52:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906386B0005; Thu, 29 Jan 2026 22:52:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3BE6B0089; Thu, 29 Jan 2026 22:52:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 740FF6B008A; Thu, 29 Jan 2026 22:52:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 608006B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:52:11 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3A4E160443
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:52:10 +0000 (UTC)
X-FDA: 84387257220.15.9DF2772
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010043.outbound.protection.outlook.com [52.101.61.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2F64FA0008
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:52:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C17WvFnj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769745128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YNL9/Astls3whxLVdPXv45xRRjmYoYnaL8lRzk0um9A=;
	b=Ja3lFhny6DMMwYx1Bm8Rv7NI255fOrFxyvVTzHVBhNeP1yqEAfqiL2Q5P+O0YtckHnosyJ
	o1V5NK9sNF3qQRahlPQMNMp2uC7spTlXfvFOMtTPmWQdUTeMAHCcjwSsLmrBLpSLqQVqRH
	xL0T0ktkrEDYyX3RPXQYIUXYoGOGp90=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769745128; a=rsa-sha256;
	cv=pass;
	b=dRMkvCmlY6KqCNyL7za/IsNhFNbCEjWnrYUVh6qinQqpMoyJeoCJBPnQsCSrEseQirI1JQ
	eyFpo8FXiSjihJUYjsv+fWlTbew7q9K9Iu2yN0rzXE6JacwL34lu4foxTLMbZ3I72yb4XO
	eqaxSoVvrSFw9RRs+TA9HUE/Q1hQIek=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=C17WvFnj;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf25.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.43 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Mg5o85panGrkA5OS8zute15i2zqZ8iv8GycpnSDXn79/VSitWCw/X2XUn0tlugzb2G0hlQIr6yzb08/UTK4TylGk3EOpvu9NT2G9Q0RJx5l9uDva41clC61FDxWH7r2RduIV4GFrOWC/4TzPwzfU6aYlvMh0P5JiAZxK305FEYk0Xchv/eufiKxwSW4qYB3hnsfPP/zitWPB1sWxbRwxKUK+2UdIQDliX0uQPXDNvr3RDBJ1s04PPZ0UejP7dyaHzPnrlUoxpfjB/IVzuk2xDP5wPMkwYoeLIFlaKthjp7FJE07SdA5c2RHU+d6sQOs1iD7uA1kM5afU8MSVNjunSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YNL9/Astls3whxLVdPXv45xRRjmYoYnaL8lRzk0um9A=;
 b=V3F9PvX1NL0ls+6S3aGAGIoRfgC1nASDQbboP/US4NOhgLI58Z9Rxa0LRieye23aiaQfJFv/IOJATPtbYeFRXvgUIROn/ThErrm0rGufI363bP+xxlddNRxnAkCCUPQ/H77x1slbqwipNLzHcKUnEr7FoDXSVIXnIKNG+xq1o2ZSwb8PVyjOZGRq8N5DhC7QAuhhGw+dvVVqaZ845P5VtAEITrDEujGTbRV234n6wyGZ/aI/6P1XYUc86tXjK3JBBJjwbNOAm6GQTyKMPQLHY6SaYYEWVsi/ZLQtQZtGY4xIaVd/JX7Bvgt2Da8X14duPFuVJOCa1aotAqoc7YUY4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YNL9/Astls3whxLVdPXv45xRRjmYoYnaL8lRzk0um9A=;
 b=C17WvFnjlYwybFODO6QyUUe5TjiCbGLZ2kgPqLk72KG0roTak+NrVUF8MmgboGPZFw5/jEHIZsF9k9Rerso2W4pSjs5su5oDglaawz3WWrw9PSsEBXPgF7FBB9DICyofyxB6zcNYG1obQ1J2FXvDCXq2ISLN5LlKsaoCMrNnRjHtZlJYw//ZbsqRDWFtH/H3tEoom/5ni0yBQBJWhDOv+/+pRWLxeFJKbADXKnXNSSBiKsmAk6Sm8Y9nzCvzrPXPAfmhWHXncCRGSbEr2yM7xYdj9kkyeu8bHMYfRwubXTHI+fnDpMjua/Bnsl6/CwvvsbDMq1tGlBPsLtjDVY4S9w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 IA1PR12MB8312.namprd12.prod.outlook.com (2603:10b6:208:3fc::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Fri, 30 Jan
 2026 03:52:04 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9564.006; Fri, 30 Jan 2026
 03:52:04 +0000
From: Zi Yan <ziy@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jens Axboe <axboe@kernel.dk>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [RFC PATCH 0/5] Separate compound page from folio
Date: Thu, 29 Jan 2026 22:48:13 -0500
Message-ID: <20260130034818.472804-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:36e::6) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|IA1PR12MB8312:EE_
X-MS-Office365-Filtering-Correlation-Id: d4039194-0c7e-47b9-8474-08de5fb2ee6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QX0LQDXA3hRbmDY0vItO+5z0h7OnAN3NdHlw7Kwi3OKyn32CNOYyj5lZ3XVM?=
 =?us-ascii?Q?sSzMAHBbAsVPX7AB1+Q6kwJyaC8aAhAwpi0wu/mLB4Tpqb6pJfBWNTHVE4al?=
 =?us-ascii?Q?YW9idQCTNSJbZT4mTQmVcZf/htSoLY9D+g5Y9gnQkqi4JcDoVBRakXb8e0kQ?=
 =?us-ascii?Q?H7BsG3uCwqyztF/xqbzyI3PP2j/bVK+5jAhDI9iwsmGrfNCbfW4tuiiTB9Pb?=
 =?us-ascii?Q?caFngHQ9+J5JqH2Bxta0EbGJ7CUezJ+AWhR7CzJQ+BkckSmyhqkVVn/G7K+0?=
 =?us-ascii?Q?QwUuAeEwhIxiqkIP4TM4h24vMHMNvbQBHHqLqXjvlYJH4zzo24qDo0tYkkfU?=
 =?us-ascii?Q?5/CLxm2Dx6IuvCbRilNl50gkQRaiMQR5hatoWjeA+OCPF8P/utvUZ6sbGioD?=
 =?us-ascii?Q?1yEpTkZt3rsFb9EF4wMQYUnZ8ryRa5w4wmR+rqQQ0Y0+tew165CTtb/A9uq9?=
 =?us-ascii?Q?n72SuKwmoo0v/SMZ/1ffYzhfwU3a+XrR05VWS2hIdV4Sd7co91n6gdi9AAvJ?=
 =?us-ascii?Q?QM4oQRA16XxVoTUbYPld3bwJYqZ1yn8dLDbq8m9Y+3GgIwjchnBA2ZLJqiIj?=
 =?us-ascii?Q?TSa7jjFCRWBKDLm+OXJ02o8tHcAXetses0PB0Ai8N6mIrGcPZW09Os02JRRA?=
 =?us-ascii?Q?16Wldn2POIrp6uGLRDY4cw2LWgaepJ8gfY1ObCbn3aWQeaz88TKYziRtkFNA?=
 =?us-ascii?Q?4nmZxPCLObCb27RqYmfbWq/9tBWqYo/paG9/KDu4EXuZAxfQbQBhN7GagCb4?=
 =?us-ascii?Q?nG4QG1FiSlJUoLZeeCt1KkOLk/ObcLDdGqwzXCyaUdt4vH2/KNjz/qgB3nEH?=
 =?us-ascii?Q?gCbt1g9+gQnhy5KHGPg+lPbLZiyWiwkysQOlV8aoQC6syju6lQsqdkiSpsOJ?=
 =?us-ascii?Q?etERzYFzdUrjbl3WM9W3f9L+BL7x8FJuIkv/FJGGsFiHhKJyqFCadKX0osRl?=
 =?us-ascii?Q?XBMWikOWBYIIQX2jT9WfeTqS2FMdL3IgNeG2afnJHW1tAL/Qpwn2y78KEHwa?=
 =?us-ascii?Q?l2OUtFsrnMXK9S3oY7wiFZbEEdoCz/TqIaYXI4pZiwPFC19uYX0lREX56EQh?=
 =?us-ascii?Q?AMH9xQ0wJKC266a2VDKLW7YoZLssRMYb5APhRmV+qVG6sM7T92ElOoF15jbw?=
 =?us-ascii?Q?ClG8ejvZZiIBocyCDCYyB3VGKKk1+Uv9VDst4XHGQyfboclSzxhU5/EhxxS6?=
 =?us-ascii?Q?IBWRJbOgE8KdCYeU1hc5ptxKx6Pe7mX0L+ke8CX0Wo4oA1Y6B8XRDJTOzUCb?=
 =?us-ascii?Q?eV1U9huF8Y8FO+2i4DiaL1I0yt5VKs9P2qEJYmWJIbNsmdK2RAE88v0MW6rJ?=
 =?us-ascii?Q?Ft04aNiGdS/pnQXoRk1sVaJL0Ho+N0pMqUhX/WRTSojmyk0YAWkJRvhdVRn9?=
 =?us-ascii?Q?o/8bjB/lf62v8X4JcFcPGhYOZWMGxo3oPDZHbbQ6RvuuC3BXb4oH2Cj3I64y?=
 =?us-ascii?Q?aqgal0vF5inJJT/vlh/znc/cKCCfvkpyWlCo8QZY4F5CZRPMRClRNyffgh0D?=
 =?us-ascii?Q?9xDH6saAQnM3aytglT7qwVT39OejVVXCn2Hr/IQ5bgTJbavphcq/CX9i9C5Q?=
 =?us-ascii?Q?WPFiI//zy4/6yOFyP8Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?QQmQIbocdO9PeoS+Rt0uLxdgEmKYT7dLxRIVs7YpbYeE/eCxf0O4bWAkPzct?=
 =?us-ascii?Q?6cau+9b1l5tGlQ+h2iKUhETt7KjS0P0YarniGMtCxS4qrDFHyidiT7tyUHtQ?=
 =?us-ascii?Q?pMn/JP9BBcvcXisPuPX5CmjzH9ke2wUBUde93kz7/upTgN8kTbo7J1aX9b5x?=
 =?us-ascii?Q?PXC6P34PIcGl7tSXOf1jLUjLkzMoSQy8mCfZ39J7wGW4v/FmPP6Ihe6l9HfG?=
 =?us-ascii?Q?rjTijJt2rz7dySCXVIzbO+M97bUy0Ra36XpKHGTWoa9SBceh76PHlgqYUh02?=
 =?us-ascii?Q?pBeTk3lHuoWXCMioPZFSXO+/G4otAahrctiyP8pwEmUJMrQqmwCy4GasYoTa?=
 =?us-ascii?Q?8ovZjtABtX2Jg98q5HL0v4CtL/MfuLmX4MXLeA9qkxdPKNefffXPYNATDVnN?=
 =?us-ascii?Q?jBswufhpkkXEB6hkRfW4pwwyHYVnAQ9BLl5id05WoqnJQkKULhIWOcbazZ+c?=
 =?us-ascii?Q?tlELSGdW4ZtyeUgIhkvy8nVFE8Unj2ia4fz1ATnx+gPqtrL6kRPVceaIDAVg?=
 =?us-ascii?Q?kwWOBBP4aemjO4yzdZ/DGhnvQejnN8agZoFTShCrsKtwBMOs8ZiPwNjpR8WE?=
 =?us-ascii?Q?edqo6oAasHb/aN6UCCgFE4Ifyd5yuBYMgvUrzvRlNhSIUT6W625x1n3SLktV?=
 =?us-ascii?Q?1gz8VRstP7LOfH105hBpRgT+nP1HvrHR0Pmbl1ZR2HilC3E4+CyP8bbAHxFy?=
 =?us-ascii?Q?gLg0wilEqhiwMBYcqU+p5eU1Bck3pw/lHX2c9s39c4+khRvrMM2Vy3Uu35EB?=
 =?us-ascii?Q?55JrIpIOOq1pKDh5a+hFJjy0XoT35FLGSIAWRe6NbeiBX8StTqyeJjXkzvKf?=
 =?us-ascii?Q?7X2a63UgmkHUruZcTnP2VmMGkQk/oAGpwLj5GY+Ohay4+5dK8vJzR5AlicEE?=
 =?us-ascii?Q?QFQAEpqPhXK3IGq3l7F58qdZVO7rCVmy65qyxVvNka3L7s8brmjqfuJg0wUL?=
 =?us-ascii?Q?fqYWCd6WBYtIz8KOuP7OS+45DNy53fh3fScBDM9X8PCHjhVYybEjF4EJ2LvK?=
 =?us-ascii?Q?TVDIZk47hodalJ2ARs4opBaTvEGCJuBLj2AQ0CYtmy/LM6p7GvwgTiIBN9n+?=
 =?us-ascii?Q?GXRDUCpgYq8fZLu84pJ2a0jp1byX1kuvOJwtuPdTCeZVQKGQ/lfXD4mZF7Mi?=
 =?us-ascii?Q?Ba2DYdax0PHIixsq+bnxy1hLaXpLrK3CNEV3nAHi/C6CWu+N+zEl+sZh3JDr?=
 =?us-ascii?Q?jbWg0HNKtD92Mg6K3lb1qhguT33cpDLtcCCY94fUKGrDqa3H92h0no5pDODf?=
 =?us-ascii?Q?9QXtkvLQ6kemUbXNyJPtvqVBfHolHMfWTT+Jt+61lrKdHh7GxpLsKLh2113E?=
 =?us-ascii?Q?ZQ3Yrevv7TL1E8xJ/YttmetuejiOIF16rWAgSvwyUnf4ebPGEFaIAlUnycjT?=
 =?us-ascii?Q?DJwX2CWtKRMICiaOXbgyQAdPL8BBwNu3mPuUGr4DYC7skKTZtiT0LTJCXHX5?=
 =?us-ascii?Q?YeXiTK22I1rrH5LZgz9sD5ON88kqb9tN4fCiyQpquLTqkSBDEOaX4zBwJZEW?=
 =?us-ascii?Q?hIQugEgft+jqcEONSaLmJbhUFht721rCndF0D7zerrbtqpjZJMMs+ScWb9bC?=
 =?us-ascii?Q?IpEr9LWhug5d5Cocp96qjgZ8GOgFRp9z20ThS6uuvvrFQQ+L2i6yFtyMkV6F?=
 =?us-ascii?Q?rWgE76KmV9X0wZC4eSHEzEE6FiMwH2IJdZ2iOaGcrFkEzOc+I1ahVMvC6SCk?=
 =?us-ascii?Q?S/2NVm8MxWWAlAHt10vZIus2MhBfukViySjVroI2zJ9HiwIg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4039194-0c7e-47b9-8474-08de5fb2ee6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 03:52:04.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6LfAYg4sGgD11vueTDpxN2N/S7tdYEiIBRoAp8vpTN8+tlxB6l/mf9tF8FZPsKSS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8312
X-Rspamd-Queue-Id: 2F64FA0008
X-Stat-Signature: 31ot9goy1mjjbw7pt8i5qpip3a1izxux
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769745127-610937
X-HE-Meta: U2FsdGVkX1/cG5qDt7VmKCP3IkHQ/IxnYqCHreINeJbjkGZob/U0nC2F+9pQsJOpekCqgvSNAXSvcJKBj14LVfs8KzZ3QmkTHWlMh3pyLN9dDee37jKaue+iHzmKRJh24r7phT81GMaxqGOmqwZhVAzf1afUnbSke3DBxmQQLlo8ImXuiLS+q0LaZ7QEPhBUUYTKKR9O/yjajfETBPQSkEcBcAaKmYDjYsDhW4Uoc42iF1gst4RVQATCiSsfnNZXsZJj57BTi/FG5ull6Sz9bSVEa4jPsTMXAsKmTJiqboyu/TAf2QNbReWo4MlsBjLje3Lhu6kpMmUoFDUc1Ei4mX+sxX+fHQH01T59su4hYdsir9iIQ7rh6jP57EmGtlgdHTVlSXsCO2DDjk3vFzNiLDbYLAKeePLM8w/GvtBrqaU6+2suVecYvasfugCR1gEp39las0gTuxjmOgn0j3FPrCb6iP5gtcoiuyxVPp9wW6ZPV19iGmxapQFuZkeMiGUA3FL9cNIZ6Gi1sLaPlUCxJr1GpcP8enwYy+i8M0Kg1P4yWIePlN9Uzl9vUa4iQT8UhLLGULA23yAq2mmFGFzirk49NcG/PssDnwBUN4Riu8GepXPpJyskK477tF758fZE1ZiRKnoERxA+RCH6pxoLCBuYgYTp9bYYKvHCy3vlrGXwNk5MrX88JG/czHZK6sgDGnJY//WyRmkHFQn5uurEXW2fuEVPyF1jxy3EgQD+NrPD/WKkMPV+cDvAGUwfLa7A/anTvAH4Kur1m69cwKBNX+Q+CqzrN9rRWIZez8JUQgYuGF8YI86eRqSI904B7hpunDmPZLiW139x3DNEMK+db/vqzSi52xFtAwx0jlfnS5FbsMZCkElqC5UTK/Dq9aD+W8VVcTLOf/JrAG0UD2rn3H8qWcL0kWmu5IaRvR7qKAouvsHtWZenoHy8RH45FoFNL7SHYogLeh38/Xrhu2K
 IFwtKoh7
 9GA76VLIXTb8MrkPmHCclrXs9mjc6iMM+NLGqvmbSgse09K6rl/qA6ON2gn8pIqontzaA4DNVWP4InlUqgKeVCnwMHF3hCXJ3gR+iTxlf/EmQCmLSdGtcT4b4uGGlAqo3DM7Yb9eRbdjJbTnwNUV1G6YDilpS5w0MBIY7q9rnp/lTWu/O38TMqO/3bOCxGrlDZydAnoSjezknY3DHengt8JJQrKNGa809BD9DOIbZdHkShD8v8oHqOkY1KfVKqDXTrcPiR/eYZ5++LaoQjdj+00/+QKyPo3YoGw6lG2I16Sy2ZtaMwZq+Uxz9LJpnQO3uYz61Zez+GM690YvPxRruZGsnkEeYEUaBSu0JjXLQLkIU6N3j81/RZ+7GMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Based on my discussion with Jason about device private folio
reinitialization[1], I realize that the concepts of compound page and folio
are mixed together and confusing, as people think a compound page is equal
to a folio. This is not true, since a compound page means a group of
pages is managed as a whole and it can be something other than a folio,
for example, a slab page. To avoid further confusing people, this
patchset separates compound page from folio by moving any folio related
code out of compound page functions.

The code is on top of mm-new (2026-01-28-20-27) and all mm selftests
passed.

The key change is that a compound page no longer sets:
1. folio->_nr_pages,
2. folio->_large_mapcount,
3. folio->_nr_pages_mapped,
4. folio->_mm_ids,
5. folio->_mm_id_mapcount,
6. folio->_pincount,
7. folio->_entire_mapcount,
8. folio->_deferred_list.

Since these fields are only used by folios that are rmappable. The code
setting these fields is moved to page_rmappable_folio(). To make the
code move, this patchset also needs to changes several places, where
folio and compound page are used interchangably or unusual folio use:

1. in io_mem_alloc_compound(), a compound page is allocated, but later
   it is mapped via vm_insert_pages() like a rmappable folio;
2. __split_folio_to_order() sets large_rmappable flag directly instead
   of using page_rmappable_folio() for after-split folios;
3. hugetlb unsets large_rmappable to escape deferred_list unqueue
   operation.

At last, the page freeing path is also changed to have different checks
for compound page and folio.

One thing to note is that for compound page, I do not store compound
order in folio->_nr_pages, which overlaps with page[1].memcg_data and
use 1 << compound_order() instead, since I do not want to add a new
union to struct page and compound_nr() is not as widely used as
folio_nr_pages(). But let me know if there is a performance concern for
this.

Comments and suggestions are welcome.



Link: https://lore.kernel.org/all/F7E3DF24-A37B-40A0-A507-CEF4AB76C44D@nvidia.com/ [1]

Zi Yan (5):
  io_uring: allocate folio in io_mem_alloc_compound() and function
    rename
  mm/huge_memory: use page_rmappable_folio() to convert after-split
    folios
  mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list
    handling
  mm: only use struct page in compound_nr() and compound_order()
  mm: code separation for compound page and folio

 include/linux/mm.h | 12 ++++--------
 io_uring/memmap.c  | 12 ++++++------
 mm/huge_memory.c   |  5 ++---
 mm/hugetlb.c       |  8 ++++----
 mm/hugetlb_cma.c   |  2 +-
 mm/internal.h      | 47 +++++++++++++++++++++++++++-------------------
 mm/mm_init.c       |  2 +-
 mm/page_alloc.c    | 23 ++++++++++++++++++-----
 8 files changed, 64 insertions(+), 47 deletions(-)

-- 
2.51.0


