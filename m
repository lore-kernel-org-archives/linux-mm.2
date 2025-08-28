Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B985CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 13:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 312C66B00AF; Thu, 28 Aug 2025 09:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB316B00B0; Thu, 28 Aug 2025 09:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 191B16B00B1; Thu, 28 Aug 2025 09:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E80866B00AF
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:27:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8BABF1A019E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:27:15 +0000 (UTC)
X-FDA: 83826242430.02.8D7D0B4
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	by imf12.hostedemail.com (Postfix) with ESMTP id AEFCC4000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:27:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rQpn04c6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.84 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756387632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLwGmU6h1uV0qCtV4HRWJIIn0VTSZ/dqI+IK434meUc=;
	b=H1sdPFKCChgR8Xe8jrWv/ozq6ooiLx528496WBoG2gAv/LmLLOWghDJpTE96CDlgdM3qi8
	OvIKoDnDhuPBCZA6TfDLBlA0b+YdobZDhrostGxdj+92PscU3NNSl4vInrGd1qYcpq8u9A
	w34BOQWFM+R9HjcZrelh5rFrc+UYYV8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=rQpn04c6;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of jgg@nvidia.com designates 40.107.223.84 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756387632; a=rsa-sha256;
	cv=pass;
	b=Ih9Vryi37ZezFfRUojavZpC0HdRxzuzERRxWJdrekuQ3EJTBNryR6Z91UnXE4lWwsNsJZq
	REnjqoiiFQEswqqy5PLi9C6Um0Tx6YNZt0OupB4WpCQmosjRE3pvghZGKNIm9OOMwJ8xPn
	WL3T1sT3vsMilXy7XShXvdM98Njd47c=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gd9eEAx6A2rAYOyJozqfEX4RV8pU71nHjjF8ahljVKWx1NQMvRardEdElvB/WLJWdGfh1iWphfsop7gmU4O83xGqhwKe9CMp2i5e2ww7gtcmDzTPUhIKFGmVqq5F2Y/aY4iyTFcqZReAKNjmRMEtEXVaenDa1+AR0NhN6rqkys7BYzP5lU8Jxd7NWmd9eR+pKxlYB7YeT/MTZ9ecVbk4NAIjOvBSqjE4QBOl9F8HkU75w8bfq2ymm9BUHal42r04VkHnkOsARFDL4T73ds0O89kh1jHQP40/eugTRr53dwFEuVUo2NbjhoAq98tw99MHu0qQEymri61OZ8Pg4KEuEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLwGmU6h1uV0qCtV4HRWJIIn0VTSZ/dqI+IK434meUc=;
 b=coRESzXsKw6oIUoaQOkD/Z2Hb/qmwWanRcWqsFG/bil84hSJg2sWTljACrFB20kddSUSHDJ6RDvQNZsJJNejQE6C3asVyiCy+RLXL+nAD+VZSxLSgOlZ0KHoCmX3fmjAV7NWkAZ+dWR5dwLYJKd+2REngROjN+WlYAdMbdJ/yBCKUX/ZvH0aLUDOdwqXs9oA9IM9o/xgthMbD6qAQO395y0BF4TGMKTzBqprQ/1AoidryjoluftRdfCK3fGNLWuZ5IbImpCh2bzBeEjm6+zxXvLIN/yqrFhDKd8maQ84tmqsPUV3ig6nvXgIt9BcnHnGm9yqB6EpLk/MPpCEITFOMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLwGmU6h1uV0qCtV4HRWJIIn0VTSZ/dqI+IK434meUc=;
 b=rQpn04c6Ye9UKItxO6SXH14Ix8cRtL2UDHs4ISRAWIIqMelceLywwl8MMECLUBEUSVsX8JNQAHJ9BjCdev2psJbKyCBRJgiXxbxP5n4S6irWwHUo4Kyha2w5jeoWEkqtzb5b60BgXLyGLq1w3pI4tCxJyyMMA3hlOo/2v61c5neNn+vGhy1FO0+SQBm+aV2rN56fd3v3X0WWne1zDGq1WGRGT/zTQEXRga0PySUWzy/D/eFx9qrUphcqSrkh3CyGi7/wQBvVHa5kHMvyxipnh9THsyTDw9nEDUIDvEiN3VUAKnfO7kQJXrXL+wODlONxrGiGsTo0NxZu59wsBKAiDA==
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CYXPR12MB9280.namprd12.prod.outlook.com (2603:10b6:930:e4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 13:27:04 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9073.010; Thu, 28 Aug 2025
 13:27:04 +0000
Date: Thu, 28 Aug 2025 10:27:03 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v4 04/16] dma-mapping: rename trace_dma_*map_page to
 trace_dma_*map_phys
Message-ID: <20250828132703.GC9469@nvidia.com>
References: <cover.1755624249.git.leon@kernel.org>
 <d7c9b5bedd4bacd78490799917948192dd537ca7.1755624249.git.leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7c9b5bedd4bacd78490799917948192dd537ca7.1755624249.git.leon@kernel.org>
X-ClientProxiedBy: YT4PR01CA0293.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CYXPR12MB9280:EE_
X-MS-Office365-Filtering-Correlation-Id: 297629e9-d6a0-4274-26f4-08dde63693cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?czdNvlljPZsTPbzSSuugKdYWnNsYJthpm6ajyxrlWHCasD/3QUWoECGQ1E0T?=
 =?us-ascii?Q?jRhPZXNnjd9X2r7rXqWMakMIm3CMLyQzWXxiji5gNdlJvrMkg9r2sHbwk70d?=
 =?us-ascii?Q?EJTKr6t7B1UHuLxbuGZ89kzikre2Sg1AcVozknNd7eo+XihYfGlGj+b4MrP6?=
 =?us-ascii?Q?VGriNtg77zKiRNfyrOfRDm6XTZjEPiZW4w1tCqc1+I4XdGR+NZjPbUUqIbhA?=
 =?us-ascii?Q?XTl7CdVtpHFrzdIFiKePkXujr5QyRYFspeVDWq1tRTJUO3w0UJ/B3jfYNkvU?=
 =?us-ascii?Q?PSiC+7tyCX6m9QO8TKAgMUXNsA6uj51FE/YlyI23728UMh6Tb5/lhs5rwnyJ?=
 =?us-ascii?Q?FviOLoEdR0Gysx1R+sLsVQ+QFCkb7h5br+DAjgW/dz837ikefNnNDvxnI50f?=
 =?us-ascii?Q?WWkyqwA8hF4HbkP+v6ZtQZwiMiJFHKUc82muWM9mrCU+CYGmkmYiHe9cF+Nu?=
 =?us-ascii?Q?cq63AcRoVoumS5h61MMx2QaBkGg0y24V8DNYrWP8lms78qrS/Bgisik5aYtm?=
 =?us-ascii?Q?1qIAP7bvtoBqMYXfNRPdBi6UO1uA/U47dWUojABKhRrTiz45gRhyNz6ra/Lu?=
 =?us-ascii?Q?U22LAfdCRgdDD+bcIWfVTdSPNjO37bg6EjKQz7x2lpo1Aborn4roOKrC5oTn?=
 =?us-ascii?Q?r1hIFhETU8+TYUi7U2X9alkuuss1FxJRxiHsJ4C1pc696ZDJiLb9tGGzAOno?=
 =?us-ascii?Q?SJ1Z3Z/5OK6GQkzSIfrh4TxN9DAOLxDF8491hljTgmQrMWki1eVYjfrQElE4?=
 =?us-ascii?Q?hU3yqGMsWsgTnda4ZD6iFniASa2cqo6hOcDSTW7TzjYiXdMY9NMZH8S9xT2i?=
 =?us-ascii?Q?ZItA0IwZQylPwLeZWr5EDDWLxmk9LHYpw3kTCSIqAKaU00dt4MWV8m4sXZIh?=
 =?us-ascii?Q?h4I6rPAJUth0U2gcJjonT0PwsrQV/NxHbV4VZi+GyB7jZsCEe6JVGoswD3yu?=
 =?us-ascii?Q?KG3hkuEiHT28V3bsajfefAdO5ti3/kqmhYJ55asM7+edmB6rhH7+IRXXZXd+?=
 =?us-ascii?Q?f+KVlyoR5IdWUtw6ScaV0SSH94eUXDrOflNMU/qaYsQWFVufY7xOXl+6P9N7?=
 =?us-ascii?Q?FSCMzGhv+nz80nqIIInjMYZ7v3/FP4A2vbGJ/Mcl1JkF0701tFtRJQHyEo2M?=
 =?us-ascii?Q?rM+Mu44UFIpfiaiVKVELFHCf12vjrW3ddKIsMhWWMKvvhsiveTG8OxjPEZnq?=
 =?us-ascii?Q?Yv0oD1SWyaeynNQZ6rpJAFtHMYy47sl3akZOs653VcHl1qcODZ4LPbnsRg/8?=
 =?us-ascii?Q?C6f9IdwM6mgY6zLzaj09wJV+LDYIZEWNBZLZSEjA6e/Pz417sBpIVWU9nzsP?=
 =?us-ascii?Q?rEeKG92slLYu+hEPVkPg6Rb8U53kZ7oCm3UzgsrX6SX+sFnEwCuBuvH+vocQ?=
 =?us-ascii?Q?kpQPVWVQgBdWZ1AdnmVFfX4C+IUR8D4PDIQLI69skou5Vw0Tw44kgP9KPXLm?=
 =?us-ascii?Q?sOiL6Nbe9uk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZAKmjLWoSz34gFmZnK/Uz5xPsr89Vcmg6Q1YT77QQxenOMeXPtDZ02X0k3T6?=
 =?us-ascii?Q?DG3OI34wAP5iIQkS/U4S7ya39155iSFgLhzJmeQnOBEKzOhR4Pi9Ozjg4pY+?=
 =?us-ascii?Q?K6hiepGCVodIn8tdfiCuf6a+SrWI5EHPVfkXoFQIILjJrYBQwzTa7jm+AgWY?=
 =?us-ascii?Q?9kS4Td7ddLAue+67qgmUTRv8BFFBwAi7h+AGAvo/y4rbGi3rR7hAXom6Y7cT?=
 =?us-ascii?Q?eFwMu+2o7uDeQNo/9sd7PkYcNvwVTSm5IgyNd5ZUXuz2nueFL1YKn+arh9K+?=
 =?us-ascii?Q?HjvkxOsaq9RFsWke+hB/3LA1kWO49y7DdJJGvnAcs7N9w2t2GNjY4Pv93wIk?=
 =?us-ascii?Q?6ilj+2AGI8nvTTX5HWUyJPZ/d1MO/TLKQe9rB55cleSlIT6E69RJgCyOLKeN?=
 =?us-ascii?Q?60xwGpNkCePzmIV5KYEJMcdDDYe4doYTMNRX/kzkNzNWrV3zIDY1vCwWgvnW?=
 =?us-ascii?Q?WG4mUE4bvSW170WTSDPb6V2ZnkUX9qhtaqoOjqeDc6QosbMHfXxt1hYKHPjt?=
 =?us-ascii?Q?rEJ9Dl1+hS04/VOmMqitUchhBJREEVoCd1amnMKOgT9PZnb3KBmTgeTQYbw0?=
 =?us-ascii?Q?54HrYK4YEoxB/6rpPe6KuGlcOFFgOCyN1IS3IQpz6g5aDOVPxRfvpA6WBVWy?=
 =?us-ascii?Q?UvkNDmlEquMYXfd1jCBc69iKHCqS3JBIZWCkOBaxm+YEjhORgByTuEZaj3zN?=
 =?us-ascii?Q?K/iIsUPmXRzUn8xIzuw9tuDHO2DKkNZohFrxVd0XxEtuid+tteoYGS64L1/k?=
 =?us-ascii?Q?oXeMH2ze0CXia91priLXtYAS822ItxYkcGe/mXIRc3YwMnnzXYmLddBBGzox?=
 =?us-ascii?Q?0ua445bUBZxYG3XpnJHW5se02szr4kukMu8xMA+S94P3No78I0o8wGKfOMgW?=
 =?us-ascii?Q?4/Pu/ZvxzE3RZICBYBH35cdT+UdXe2koKMnO06xwLEMu3QhLGo6RpB2Av66q?=
 =?us-ascii?Q?rxaoMAyQr7jlpLC8FS4+bpv1m46ptOYSnMLqZhw0dG1Ur5epxtL3CZTuFF67?=
 =?us-ascii?Q?zMQFAIVQus4PusJbVFUfWViaM9z2LdUb8qOKEVc9yHFSKZVhY4tMXQU4uelB?=
 =?us-ascii?Q?WIno3jK6BDm6Hzf/NrwDDsUXAFiQH5N5gDla1kh5yXNWssmvSKyR6nO1hKL4?=
 =?us-ascii?Q?lRngphKojir5/gDZy7DhPndm3G/Hoj46qaOo59FgXNnY+z0h4gTWwbEmLhDh?=
 =?us-ascii?Q?ZQKNRj8hEJEJqtv0MACzJMQI1tvS8G0CIw+ilHS+5uArgY4VKhcrNoZhCqiB?=
 =?us-ascii?Q?5MnnBDvglG+IfHWu6IMcX9t0KZ1728gzLjB833lLBE4qYcpD9cnES7T3Tuw5?=
 =?us-ascii?Q?dQeW9DjxbqE1ILRGOLB0/CsOFrKncHc6CxXHX6kxfO4QDESQ6qzHoD6bAHkr?=
 =?us-ascii?Q?P8nlsRBhh+eaPtkNqgtA/azmq6TpNKZxMQnn8eN8V5KuLioq7n4cjlOx0rNb?=
 =?us-ascii?Q?LFdNRJMc5g+0l5xLl7wWc/W7AnMpocDfyVDwUtkhrEY/S+Q5FoWzIL+ayFwE?=
 =?us-ascii?Q?VmTpKTDRNfqHN7SR91nghMOKa3EZk/r3karcJCmOXukZez9mlZ/4F6IgFrlH?=
 =?us-ascii?Q?ZO6xPcvjZRXhs6E3ap8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 297629e9-d6a0-4274-26f4-08dde63693cc
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 13:27:04.5221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QGO/7rFcEAJDfFVtKqdLW+l6RopuuLnfoyI6/MoVuOOAhziHFak0TU6alJ+R6uUz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9280
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AEFCC4000F
X-Stat-Signature: mcxm4e4nyntgdse7dqebpp3fwh1ffijt
X-Rspam-User: 
X-HE-Tag: 1756387632-728027
X-HE-Meta: U2FsdGVkX18GJtjOT3tuFrtXtbETtQr2bH7jusNlWTUiTvaW5g101UFLHxM/rKLtt3bCNSFc16QqprB0lpKk3l+QhPYxqHbC8oMC3MVdiykgZ8M/sualua+diuLlbaA3D2rqaLcpeP1G85nYyOegwxmLCJIpNsBHdUYSP9XVrkOxMkoDZZZZo4yppd8ajHWyygXksT1NQFVTLwRMMNXszwkgeo10RmuaxKd/8VFdnH6z8b/Za8aYk9jWdZ4tFhE9MkRKWDYCOG65uNGKSFfDTr/rXe/WZi5tuqJ3Gw4F8oUcF2kfQxOIy1og3aBuk9OaqA9efslqkhV4KcXsJoV82zHdxB9vRSUvrhIraC8z0BmU8z9HEAvqueXRfVHSsIaYjSl4q5L1PTcvHWZy2Jwhs7O80bNvw5flp7yyxFcwiZJ+2lobs5Co79dMduJOypWNpvAoBv4qgR1MVGwwvBdW1QJ+aSZUUzsIJ3LV4RJdxsPWA64sf22880DHN5X9czVKO/uimtcWybWL3If2uRDjfMF7FBw9aL8V6VlXpocndJLn1ePlDHK6Wa+oB4znX6aZq+JZbNC4zYx69J9TU+gFppYGSrXEgBQIix1mHHc5yW/dl9AhqxCi0tpJeX+zI2m+NzNSXKLgD51yj1wcabpe/gb1kM2wW6v5U+pKOM5i7hkt1gM/xHZqfSpe6IX87n9/e+HhV21QRSQaQG8tfq8rQYzcyTiQvT266SF6C9dZzEKoqzdSCNfWfSBV0nffV+cFxxr0gQe4AC+oyPqyAJLL+oRDzvOB/qEAJfFC1AEWCqyldwEx1tkWryMzZacyOt5es5LGk2YZThsNYhOY8++TP63OOWqKOiTlw9ZFlCyXOqupp1xA29EvhQxnqvN72NzSi3pWuFEje6B8hVIGWxUyLERmhmdILEMgAa6iGXaSYPv7kmb5ct/CSE6aUJ6f9N95jGAKss+2wOnl6BjeRIf
 KfUnjKCG
 h2tQtPXTx1/1CvPqd0WDbfWLjPpsfd3UkVSHLQWiriBKzlHNiJY0n6YWLtSiGxOmD+K2kN1DV/VGUsc0enzDBUsi07+0zgzqgQAhj3APdOCPA4PX4Hfdt6S8/qxq6n0ReJWygLUcpB4QHnRqpNQSFSBUdlWHhkEgbI6AFH0Hup/eZV65r0gZG+EFxzrRnaXFSL/QvSIRUzuDypkgU+yLr6F9hv9Y1n7/Urw3ViG34fNLcpVFjxXYmZNwqfLji5TSBUGxSbATVgqip7YLeDFwemdi5r3QKgwTWMKTdzfOoINJqEJaXbkw519ROLzo8AmWDy8VSl6ECdwSyx1V5kf74pAtrb7C+DD/Pj0pqwMw3iv6ZoB/SyBU6LtDohWRNQTch61RyY9DG6QyoyjkyFAgOrNFh5cHBs1MN3o39ON7ps7Xmo5PgxmxLNodTs/Pcxoe+P3Pr67DPpEVQDMrStDYenuPLcCmVp7TdqAe6PfZD/0QayxKs+ZZA443GtInzXnWYdRqmtcy+DDvx1LNUt4H37FssGkA8GwjSJuqJGfKnq0rjZSwkK9VLa84i5KULQ0sv4xBv3hWcenb6AuDWZw6RqG6WZuHNZZ0mBpD0CM+INI08Q6OlONFrH+NcBZH+I3yUSJc8r5rgRjMTrb8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:48PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> As a preparation for following map_page -> map_phys API conversion,
> let's rename trace_dma_*map_page() to be trace_dma_*map_phys().
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  include/trace/events/dma.h | 4 ++--
>  kernel/dma/mapping.c       | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

