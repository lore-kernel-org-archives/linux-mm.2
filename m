Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E7DAD3E79D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 07:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BE46B0007; Thu, 11 Dec 2025 02:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665636B0008; Thu, 11 Dec 2025 02:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DCD16B000A; Thu, 11 Dec 2025 02:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA0A6B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:06:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C42213B9F8
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:06:29 +0000 (UTC)
X-FDA: 84206306898.08.08679D4
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010006.outbound.protection.outlook.com [52.101.85.6])
	by imf25.hostedemail.com (Postfix) with ESMTP id 06E90A001B
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:06:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OQZcZjeW;
	spf=pass (imf25.hostedemail.com: domain of ankita@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765436786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXwRJw/kXuFWvbzfbPcGe2EuO+zSv0mwjKJKiQmd5IE=;
	b=VRooTPkGh0USA4DEglxeUao4W6m0NYoTxHW2FY94F35VLpa0HPion64NxMFTofFSSOYKYr
	anL5E/G/+rkiQIMcycXLEaVS+NkEKy5PmrppT5VRndxzWci/aNIgpOExKtplYfKsp/HmHs
	/fnFhELAbby4tC9TnhumsaEZ/I2gN7I=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=OQZcZjeW;
	spf=pass (imf25.hostedemail.com: domain of ankita@nvidia.com designates 52.101.85.6 as permitted sender) smtp.mailfrom=ankita@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765436786; a=rsa-sha256;
	cv=pass;
	b=byYenb//7OQYWLxt3eyc2xpkmn00CKMujN+qxyVCypLTSVAO6Q+XPfBbKonY15y160UFGY
	HkN3mv5HuvsRJ80cMehSdepJXMxxB14Y0/jY44IFafrvNmFiGFwfQsVuKCAnxdrkPguaoC
	3vwCrAc309Xna+4iNHbI6OrURFmVpmY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ndvcPTdG8K561eI+/xxoF56GW17hy2QopZNGA8SY27VhEcqlXQJgiAIgKgu40wfftSXkx6PRholgtWCDfGKasbk7L8idrCFuGu2H/SNBYhi9Uf/N79nMZG3glV4v9zpqD1WLAwHkYw+IraGCZRn5blFOosfIC6kvs+eB+b9xFk827A+l7Ls90AeOIaLcLV7HYVMImweTsf9TT1Yql11onqjPsIuGPajoN/8Jlapc0PV32o5dVgHdZEJNu5WKczXZ8uPyGPP90UdZdIuJwAw0+0dzynFLnEv+cVwzY/B6z6BK8+HtdzgB1v2Kmeh1Etv/hP5BKvm4M5/tB3ZQoGzTkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FXwRJw/kXuFWvbzfbPcGe2EuO+zSv0mwjKJKiQmd5IE=;
 b=a5/igCGqRwIEGWSvF0lSY7PfrWNjUvGLAVtgErdYBpFxYs2OWRLc3+Cguqj3+94MNKCNNvVola/YoENsomyeDwthyxEu87gg5K2a2bmx98DWgn9lUGuHueJCFColdc6riSM0EtT6Q8hLl/RUpdwUdtNUKt1yxKj6FjgzZJvuIM9DY+4Qs3vV116u/R6VMl0aPvdOHNQfUPhzlHHm9VLuv8uYUO7VNBBpqVL6CEa2ocfj+EzujL2oVisbD6NLjqx454ekkULdMkQJuWOcKmvAKlcNPlX47tZ1uWtK7uGZDl579Hp3eCK7iNVt8RgWZ4WBvuBAxyFq6myY9pZ7v4+taQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FXwRJw/kXuFWvbzfbPcGe2EuO+zSv0mwjKJKiQmd5IE=;
 b=OQZcZjeWpa8De4xVKR3XbIHMmI54cLewjKiTkjIHZjjYdHlEFhDy/hVOFWKEJ6eWbe460usxY5VjTXyuHZmgw2SXnI9aiIpaGBi3UjS2tFUJ77vcTXcNzx3CeGmu7z1tZsvkSTU9CzGb1zNMxb2NvPdn6Azd76rEEFpgsFYLOCL5/pOG0K2kpq/0pAS0hMPjB2Rj5M4w7gYC46Cnz73ymcvDj4GMRyE6364Hfwbbc5oxOodK3vaQqV8HYpimiDuWTb+BwHiWGG+lQhY3npLtIgRqjZTwdNskd7MQeOJsZkV8bfM9SV24oUwh/kM2s/mfOmcyUp23YLGFnIPc9IKuQw==
Received: from PH7PR03CA0010.namprd03.prod.outlook.com (2603:10b6:510:339::27)
 by BY5PR12MB4066.namprd12.prod.outlook.com (2603:10b6:a03:207::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 07:06:20 +0000
Received: from CY4PEPF0000E9D0.namprd03.prod.outlook.com
 (2603:10b6:510:339:cafe::43) by PH7PR03CA0010.outlook.office365.com
 (2603:10b6:510:339::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9388.16 via Frontend Transport; Thu,
 11 Dec 2025 07:06:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000E9D0.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.8 via Frontend Transport; Thu, 11 Dec 2025 07:06:20 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:05 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 10 Dec
 2025 23:06:05 -0800
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Wed, 10 Dec 2025 23:06:05 -0800
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <vsethi@nvidia.com>, <jgg@nvidia.com>,
	<mochs@nvidia.com>, <jgg@ziepe.ca>, <skolothumtho@nvidia.com>,
	<alex@shazbot.org>, <akpm@linux-foundation.org>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>
CC: <cjia@nvidia.com>, <zhiw@nvidia.com>, <kjaju@nvidia.com>,
	<yishaih@nvidia.com>, <kevin.tian@intel.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v1 1/3] mm: fixup pfnmap memory failure handling to use pgoff
Date: Thu, 11 Dec 2025 07:06:01 +0000
Message-ID: <20251211070603.338701-2-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251211070603.338701-1-ankita@nvidia.com>
References: <20251211070603.338701-1-ankita@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D0:EE_|BY5PR12MB4066:EE_
X-MS-Office365-Filtering-Correlation-Id: e674c306-3ae4-46cc-99b8-08de3883c996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bxEPiqhuFIUn96+NY8yeuejrhGAJ0mhHC7AdNydTZs8pWZWSlsVtxdFBmBbq?=
 =?us-ascii?Q?w3t3MOmO9pzYk67PGMDIyjpXDi08Z7xaSovniOZWF5yZMtx1E6MNyY2CMmlF?=
 =?us-ascii?Q?sm3/3d9gVo+6tvby/TDd1Xi8Mdlqrceqwk9vMN+69y6+N1p3YUCF7bQILkQj?=
 =?us-ascii?Q?DJC9cJW0s7WCBpjslXC0H33FHRXTZDIaoM3qT9M+3PXskc2NNEZEYxJBavfX?=
 =?us-ascii?Q?3iNwq4f88upGHPZ+F4ifXSfGjYiIvZCeEEEOp2I8qA34855IWbHF1NfI+f41?=
 =?us-ascii?Q?eakZK/6Srn9Eebhsq90Lurn9D+dTxp6WyH2Fzg8vKvNXPNHxebgH0bHlAZXl?=
 =?us-ascii?Q?XgCetTlWuMhJIibiSVSGKhCavpxaOo0Q6ZcOxfH74rzrfyMUI0T00pjabQlS?=
 =?us-ascii?Q?VMMzLLslJTMwOpZGsgWAW16JZEZ7WS4l7z6ort3pj7w1zHYboDj8lLVFTot2?=
 =?us-ascii?Q?Di2kjs3wnGGpGE+QN5E0TUI+QzCnDoM6DVmLNlOz78ARo/mc1fH+uHCtzAmi?=
 =?us-ascii?Q?tTCFHSQWUPZn33mt8MD4WkejmXS4InND+eqK38N00vdjNXLzw85QjqL63Ecf?=
 =?us-ascii?Q?gfwFPnKtk5DxyTE/b9JnJSF8Ug4dXh/tCfs+RJ60WBfyUvJZh/2bA0yef4BZ?=
 =?us-ascii?Q?w+93RpsJ/BLstWpi9Rhf8VwKZT5nO5pUu6/jgMN1k5LtjW/8BKZ3liFJb+wi?=
 =?us-ascii?Q?NhNJbmqEK8O0dESP5CyrKg6o8IF/g8JdT0bpXqAWSFLwbqtq9F42I7JoHizm?=
 =?us-ascii?Q?VY2WvycZTZzvC46ZodpMo+bhi7fGiRDluwDuuJNDxrkwmhanHBpEMuMCC0xF?=
 =?us-ascii?Q?QBSRdM2tVjfrTBPkii5lnxt2ZUEWe/4jVCGCUKonOSI7IAQDCfnvyxLNF5wc?=
 =?us-ascii?Q?oIyNY7dwAdmdLQ3fjrozbk9/QL5h67rpXpmzjxX00V5aQsL9r+1HTvR8qL/f?=
 =?us-ascii?Q?ujKgR7qLdsXUkh+P+FL5UVPzkh/fhz0j7GTCWiD1XICYqMLl/6/Nl3DWXY+E?=
 =?us-ascii?Q?6vvbePcyjpISxphP2UUxIQUiG92lVPZ5/l1pw9/yrUEs00ID8xqkSxv+KC3v?=
 =?us-ascii?Q?9Uk9lBrBW1Vaakj/APhy5/5FXaqn0KJAVM+n8hr09Sv61IkUd4IHsWA9yG5V?=
 =?us-ascii?Q?PyEGlZh66xwsX+y4eUK2N7LMwbJ+KKQtg/eT9W46b2MaJg5izP0CkeC3tnTA?=
 =?us-ascii?Q?yDdwtxN4CDlG5YaGXYZWWxFPY76V0GyuYI59qIWwNr0UOFplP8rk5Q0whyid?=
 =?us-ascii?Q?NgAQZLg/o9Ht+LQBfnPA65OuRSJlgJNQ0IRs5ljU7xYDQsxfgIurup48cwMq?=
 =?us-ascii?Q?EESha7c/RCgCG8n2JqfsN+sRpALAd97/0eoSzhHpjjjmH0Hqbbuqqja4X3fx?=
 =?us-ascii?Q?7LJG++/ZB+46THNUbV8zogWx+8lLu2wkoN5qGn8y5OtidcMgJ8H/xNHJpiBM?=
 =?us-ascii?Q?gOFAN6sSa/Y2V7JQvgzoOv1vXo8nNwOwcvFYrFLJTfeBtHx/GqyDGfdvXwNK?=
 =?us-ascii?Q?+Aodm/WDLzLS29Lgc4807BQBd/QhWbaiMSHEeFm/2ZrSstp7axtQ/HOT38YQ?=
 =?us-ascii?Q?zlLZ+jSm3sYahBxC9Da/oLoy89e0gt7J84c++rJ4?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 07:06:20.6004
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e674c306-3ae4-46cc-99b8-08de3883c996
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4066
X-Stat-Signature: mk7qqkbodsuxm7ixnnypg5r6dguo5ogw
X-Rspamd-Queue-Id: 06E90A001B
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765436785-854193
X-HE-Meta: U2FsdGVkX1/sD1CMXq75HNJoGkF5k292Vo/sF6wV+N3Uerp8Dd0lb9OmRbu4P2vcRfVrJ5KAKdvoKWcGG4dyP50foVraSBnDz/SC0tSzde7mcHP+m9SS70oTBnrOnvKkGBFyXnMJevjomz2v7B65ij2dv/uA7BDEnNjI8WTJoHdp9sQ05C/Ef9tXMD3UVX50IxNyjzn7hBIXFBzIUkM9swuOj5a9mWs9Ggp5Nnm0Qh0GAn7/pDuqIb3WG1BXzECM2K0rbvJ97Uls7+6zEAojOdqV6XVdZpN4NoZBkZ0+ZHAm/mKM6kVojKMpAChWjAeaUbsacjdYybsn6/Dq6E9zQyO/RDkh9VKPHBNDXbCEinBjIImIz6zj6MB6++zpZjb4glvcpuifZWQVPtyvHvm3oJSECetL5TIIqmzUtR+vdP3hYg9H8pohIUrHb8WkuEtmPJ0CvxsdwhQY9cJT2QKHqFBHzpCcFrHhKLyvkF4lWad6GDgN4diAW2+1GjupUsTIunZlxogKOg9ZjkUjQtX9W9qOHz6dNfN7xahxepIxZqGqihnh55Nuqa1OKslLFqjinNY8LdIUt1hBRig3anDYt9G6DInw0VnImR7ZFPhxXO0BZsdhBEUW+wRNu0teBxv89+IGIqAZd7aphZUW3emz4Z+ESWFEi9ZX1mgYj/Wd2EO5ebomFzVYzyAQ5dxzzOXefuwE/e9h2mlunUGKiLJJ9wRsjQ5VjOjEYYlnE0FrvSGmCYPuNNjSdcg/F7llzudZhw8daUOowSsJ4CzFREMv82v2oEAJv+EK81K5lcecrGOfNma6HtXgnxvEpGN+U8+3T1hdMlUwuNysoZ8ZrHLQtHKI/XriLaROqjAWDSHN1tvLOJn4zIY4N+Z4OAsqlulfRxTglACms5aDX5JBsk8dllGll3cCthKHfmT/l8W0LFcRU5YjFfPMdY0mEIejDJMyOD2an9ivAIvijK+SUFy
 30g6cceA
 MwBi6ECYBWaSJhokUo+wcFQn4UXMdMIlqluLhWKaAjuOUWpOpqfCUJFHBRlGR7dK9IKGnq1vra5TTp/uMoiR7JBhPQQU6neoOcSeu1DC/NCXWjz0I9xuHNxjLpdU874MVaCM08w/pSt3peS+RONer0zNJGBdNfrVxllJER11uNGcE6ccqwzAYhsM+qI+1b5kE8dr/o2a4LKm28p02aDwe9OCN13zVfJJJEmjDUgqfbp/xNn07PSdI7JKhKqgMNzBVx9zHeF95inC8Qx7QtcvvphnWmjYGSYHfOEk32pvQw8gYOeNfMp0loLVfmTwEjj1Avsen7XGpd/X4kqFX1swOeMeqEdncrJpbskFLFTtxfK+uA8vkxeetaQ4QZ5XL7/VBTBBZ+LwLpNy49dUNN31lBx3sVA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ankit Agrawal <ankita@nvidia.com>

The memory failure handling implementation for the PFNMAP memory with no
struct pages is faulty. The VA of the mapping is determined based on the
the PFN. It should instead be based on the file mapping offset.

At the occurrence of poison, the memory_failure_pfn is triggered on the
poisoned PFN. Introduce a callback function that allows mm to translate
the PFN to the corresponding file page offset. The kernel module using
the registration API must implement the callback function and provide the
translation. The translated value is then used to determine the VA
information and sending the SIGBUS to the usermode process mapped to
the poisoned PFN.

The callback is also useful for the driver to be notified of the poisoned
PFN, which may then track it.

Fixes: 2ec41967189c ("mm: handle poisoning of pfn without struct pages")

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 include/linux/memory-failure.h |  2 ++
 mm/memory-failure.c            | 29 ++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/memory-failure.h b/include/linux/memory-failure.h
index bc326503d2d2..7b5e11cf905f 100644
--- a/include/linux/memory-failure.h
+++ b/include/linux/memory-failure.h
@@ -9,6 +9,8 @@ struct pfn_address_space;
 struct pfn_address_space {
 	struct interval_tree_node node;
 	struct address_space *mapping;
+	int (*pfn_to_vma_pgoff)(struct vm_area_struct *vma,
+				unsigned long pfn, pgoff_t *pgoff);
 };
 
 int register_pfn_address_space(struct pfn_address_space *pfn_space);
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fbc5a01260c8..c80c2907da33 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2161,6 +2161,9 @@ int register_pfn_address_space(struct pfn_address_space *pfn_space)
 {
 	guard(mutex)(&pfn_space_lock);
 
+	if (!pfn_space->pfn_to_vma_pgoff)
+		return -EINVAL;
+
 	if (interval_tree_iter_first(&pfn_space_itree,
 				     pfn_space->node.start,
 				     pfn_space->node.last))
@@ -2183,10 +2186,10 @@ void unregister_pfn_address_space(struct pfn_address_space *pfn_space)
 }
 EXPORT_SYMBOL_GPL(unregister_pfn_address_space);
 
-static void add_to_kill_pfn(struct task_struct *tsk,
-			    struct vm_area_struct *vma,
-			    struct list_head *to_kill,
-			    unsigned long pfn)
+static void add_to_kill_pgoff(struct task_struct *tsk,
+			      struct vm_area_struct *vma,
+			      struct list_head *to_kill,
+			      pgoff_t pgoff)
 {
 	struct to_kill *tk;
 
@@ -2197,12 +2200,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
 	}
 
 	/* Check for pgoff not backed by struct page */
-	tk->addr = vma_address(vma, pfn, 1);
+	tk->addr = vma_address(vma, pgoff, 1);
 	tk->size_shift = PAGE_SHIFT;
 
 	if (tk->addr == -EFAULT)
 		pr_info("Unable to find address %lx in %s\n",
-			pfn, tsk->comm);
+			pgoff, tsk->comm);
 
 	get_task_struct(tsk);
 	tk->tsk = tsk;
@@ -2212,11 +2215,12 @@ static void add_to_kill_pfn(struct task_struct *tsk,
 /*
  * Collect processes when the error hit a PFN not backed by struct page.
  */
-static void collect_procs_pfn(struct address_space *mapping,
+static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 			      unsigned long pfn, struct list_head *to_kill)
 {
 	struct vm_area_struct *vma;
 	struct task_struct *tsk;
+	struct address_space *mapping = pfn_space->mapping;
 
 	i_mmap_lock_read(mapping);
 	rcu_read_lock();
@@ -2226,9 +2230,12 @@ static void collect_procs_pfn(struct address_space *mapping,
 		t = task_early_kill(tsk, true);
 		if (!t)
 			continue;
-		vma_interval_tree_foreach(vma, &mapping->i_mmap, pfn, pfn) {
-			if (vma->vm_mm == t->mm)
-				add_to_kill_pfn(t, vma, to_kill, pfn);
+		vma_interval_tree_foreach(vma, &mapping->i_mmap, 0, ULONG_MAX) {
+			pgoff_t pgoff;
+
+			if (vma->vm_mm == t->mm &&
+			    !pfn_space->pfn_to_vma_pgoff(vma, pfn, &pgoff))
+				add_to_kill_pgoff(t, vma, to_kill, pgoff);
 		}
 	}
 	rcu_read_unlock();
@@ -2264,7 +2271,7 @@ static int memory_failure_pfn(unsigned long pfn, int flags)
 			struct pfn_address_space *pfn_space =
 				container_of(node, struct pfn_address_space, node);
 
-			collect_procs_pfn(pfn_space->mapping, pfn, &tokill);
+			collect_procs_pfn(pfn_space, pfn, &tokill);
 
 			mf_handled = true;
 		}
-- 
2.34.1


