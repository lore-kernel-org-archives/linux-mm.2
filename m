Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96AECC53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870DE6B0096; Tue, 28 Jul 2026 05:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 848C86B0098; Tue, 28 Jul 2026 05:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738316B0099; Tue, 28 Jul 2026 05:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40C046B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:07:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B77B11C0941
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:18 +0000 (UTC)
X-FDA: 85037606556.04.C09EC94
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011040.outbound.protection.outlook.com [52.101.57.40])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7DC914000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NERggjrf;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785229635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=77MW3RZQhQoBpiBp/UgwTvyXy4l72lwSq7caMmPLbGQ=;
	b=ptTF0aT/ln6b2RpnkERD21hzbkTpP6v3icjW5l1NqlXOhOQp7KsAx5lANe4FSl+mU9+ZQ+
	8/BMDUUAHa2TQ7dTQIcfyQANqZCsdM9tJSdLsA7uAOdPhVYVp5qXRSh/3lX3RwGvENMhSR
	6g6GBhvvsmWSYTYtzvVGe72HUcB+7DM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785229635;
	b=00lbx8Yn5wpgeqAVBfHM93h9loXQIe+nPndqjmSHSPdRqskihL79IRmb/IC9Yfhso60J9v
	5UtsaN6Wsg8mki3zEJgLhmLk4S0S0JvoXWeizitE6h3vqdkPe18NxLUJQ4GH4jqOJkUMAx
	9hwgXdvX89yDifRe6lcf4/ccZB5SrLA=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NERggjrf;
	spf=pass (imf04.hostedemail.com: domain of shivankg@amd.com designates 52.101.57.40 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q7gCQ2QbnPaFhpRmaAYNVpCGvPkCpWBnWTS00s4TvobJwqM0RlUXq4K2orxVvVzYJmXPYZJmnB6XmbZpMEvW2PqoNxgLBUHxs+TFL81x2OBVpje581Hk+lCTin5UR0oKooL0oUjjpQUXisz0cZIe85lKGlmzhJ8Hlh5KZiAHQ/N6Yjp3fKhSPWkT/5eP3F6fmloQhWTbLTZQPQ7pGIDoQtCeSGn/hJjcI07PnlMw3uunWjY/rVsEKDv/gdT/NyY8sKE7/8xqJorLFZRlqJESEdm8EonfL3yr2AUDi0LWAxQ0TJwkg46iVQlSdPNNu8iagM6jaiRLxjZdao1Uh/B5Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77MW3RZQhQoBpiBp/UgwTvyXy4l72lwSq7caMmPLbGQ=;
 b=NbbIoC+a/UoFJtSOuZT0V/9V9nB3NA7x4y4O5AgCj2Aqhu3Xi1yd6hprtwMDFVlCYes4g0MMD6D+6DkhGX2O5NxAdjuyg4dexTmJuTBwbcqVY9ibqzUyzYljeuNUM048Oi2a6ZehFYQYhazXegHUaHap2Lh9+t7PM3JXEcyQRSRzZ0F6crTTTo3sLgf/XuANqmzIBR1qvkt8X4gXDIGFEU3OSFREvKxy0JHAor+zFYZqm+XDya8uRw5mPIQ6doO8O/p2ap0YTkLLq61AU0aYxuiI74I6MzcmYd/RradXBnjb9b8Kg5qWt2JOsF+X/GQFPDzIv5zsDwCZSnEfIh+Mcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77MW3RZQhQoBpiBp/UgwTvyXy4l72lwSq7caMmPLbGQ=;
 b=NERggjrfHRvZc03o8b/PFO+r/K+o+PmRihYnvQJYNPL4baCPO03InQaduyYc5IYNM+HqvkfCx7lKvuRqvj3GiRJhdziedCln3XwjLgWHqMBqa8S7IjoaoXfL3pbcmtmXdUS0q+gwpADdI2VizaOAUWPaDpjHFruZi3AkNw7mTDc=
Received: from MW4P221CA0005.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::10)
 by CY5PR12MB6201.namprd12.prod.outlook.com (2603:10b6:930:26::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Tue, 28 Jul
 2026 09:07:10 +0000
Received: from MWH0EPF000C6193.namprd02.prod.outlook.com
 (2603:10b6:303:8b:cafe::4f) by MW4P221CA0005.outlook.office365.com
 (2603:10b6:303:8b::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 09:07:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6193.mail.protection.outlook.com (10.167.249.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 09:07:10 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 04:07:00 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Tue, 28 Jul 2026 09:05:34 +0000
Subject: [PATCH RFC v2 1/4] mm: split AS_UNMOVABLE back out of
 AS_INACCESSIBLE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260728-shivank-gmem-migrate-v2-1-269ac1f84e2b@amd.com>
References: <20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com>
In-Reply-To: <20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Chao Peng
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, "Ackerley
 Tng" <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ira Weiny <iweiny@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785229610; l=6122;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=K0pVjONTLVz8u5U48yQZGD3h2qK7JZpnj22+jAR1tWQ=;
 b=PjRS/QTfiha58SjcQO42KbCyjUwA6iSGp9wZU6zf/2f2SUtJ6uNtml7R325Iy5rPsKwbw9613
 PO5R82GDdb/C10lqbzYutJBS0iShAGKw6EgzkcyzLKLrk7Xvh8PIQON
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6193:EE_|CY5PR12MB6201:EE_
X-MS-Office365-Filtering-Correlation-Id: 557dbd9e-4f96-4622-30a3-08deec879b7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|23010399003|376014|7416014|22082099003|18002099003|11063799006|10067099003|56012099006|921020;
X-Microsoft-Antispam-Message-Info:
	5phDcpjubYga0DsDNk4jRxyv1a+KwG3J0aaFTAQHi04+4DnxTKpxwpuQHz1t5iOi9iOuYHORNSi3Ydns0vWwavbBvUVKb83i6Xcn3h0SSYDtdLryoygH30F+GhQN27QfViTzS8VYS1FHZkewgyWVu0udYtIhcXBnRyJCyA/UzzEv6QxfnDvqQOfyVaLpbdRsDFXcYadFzLysEbpFJ5SgIAKdvCKHETKWbhrF1JV0Wihwu7/X4u4sXPEL5u/TjOmHha1MtZ4DzL0rj2+rrTvAhqsrFdQgpy+rbeoVwd9ddYsbFOqEQxmNkNuJyDNaxvjppXKYskoqbJbg4Rx6nR1BnJY7khCy8pL7Y9oR0mQfgJhBPaH5twhlCo32+9yhfzT++A7KnzumcCjZMQuRO58VOp6oEMzQezauIevpZ4fN9gJu/1xH1X7paJND/OYViwiYfsijIFMJQmXiuvWVrkUG75TgJFKInraxOczxiAJ98kfobBnukhPTLZcG8lQuNjtPOortFN+PpAKEF6JiSTpl7P3xPxH+ghYQz9jn+z+sPdA1+/s+sTj7dG29Isw/E/omxC4dcipwdS/puKiXhP6AxBnGbRb+MYxly2sD6uLjqjN94NP4jNqWrIP9L+Hf17id88xgQ/C5sArbO8WW0ZpFCGng/copxljtkjo39JT5t+Y0euvxz7hE89JUgPyePNRXAiSvfF6/jSdpXJzbmKk+z+Jrq6TYaNvGfB+xLS1hl0LfkkW4RQxIBVtCOxZfgw8h
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(23010399003)(376014)(7416014)(22082099003)(18002099003)(11063799006)(10067099003)(56012099006)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+rm5smrKUMmGuly5SP6mbPtVqNZWi1tXyBcOq52hvl92ClHd3UlXumQ8iNlO2uHZoq5Tle9cwYIlb3OqmupaDbcvPEwLoycRmMlrfEQXpfeZolNyl651UVLp1a3Dwna0ZLAa5R6ao/299IVpg+uUb0F2w/OR256JqVo+Cp+yRi9+MNSqbd5crVPvWtHwlsvg8j7Aidva0W0Z8m+VRAxm4gvnp83KY13LDYEGfsnVJIMKlPLhg9xHg6BqePG3TslnoUGjA06Wt+S8136spXQCEmnz9w3qjkwpRrd/KzAbpWr2bn/v8n9c7rrQrmPBFTTzCMgeeE+78GFiPM9+A11CdgDzTsD/fMPIZm7poKEhHv0iQUmguuuGuEIxNs8ZrzqRaBNVdTeyIS5tUGajt24+m55c9YrB/DUJGxodk4WmLFBl2hYdmFDEo4yrnOpWlJ8c
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 09:07:10.5018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 557dbd9e-4f96-4622-30a3-08deec879b7c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6193.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6201
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7DC914000E
X-Stat-Signature: g8e4p1fmsa3hfrcz88ist43b8k3jpiar
X-Rspam-User: 
X-HE-Tag: 1785229635-408044
X-HE-Meta: U2FsdGVkX18HjdWssnEXgQyDXvgEq1nD62I1m4r6nFazz+pPwEqOTNgfprvdR5gfjfyfb3lcvEym8eoVco8dcAd8lXLf015oZ5XnhhcaT5/24qY1PScAn6GO+zBmfWLg7Js31U7DhK1W+QwzSnuh/GeuNK7n5pBYrqeQhr5VtJ0Mb+LU3JwcRlumCgn51MTBOT1Rok5y/1iqfQQdBygaARhmzdnOJgu87NloLgR7a/vL9KatkIUMq48HHFhOhcLfEDGUub0qeF7wZ55+dlMl1aoOgdLRf1UiHRwBaqrlkmcegWdOy0VJIUgcFzlWFtg643/WEaktaIiLq6aI+zBiHLzFOXAuPoWHHM+cuD1FOjfhUSKEmDneK0RW+Md5ZUVwBQ1hGhQxZ+uCeSgRPt87tVR++2wrK7pE9/knvZ4jQr5wJR36+scFxKOxNvCgm9CgUp6dJ63XtJfDd/DKLIyUid8U+kvViAJ7+qPouDWOC3qEogMOwCy8KA9ppQPB+DFn3sIS6dNXKkmn4AXNlKawFwC6ZVcWIeG0z7TC1h49paYZN6kCx+sMeuCsJuF3cqZy9yzlTRHP2mQC1fuKokx1Xn0gLZRFZ43m6NXs7l2C9QVHHUiuZzS21+CSi2qb8O805Dbqozm4EdeVLutWgiwAKmMldJs0UaR/H228hxA+9T9KEnBjG3kps/MhTupZOpKYRpe55Qsrs0pCa62ctbgIrDKsBNxsnDsldCfg7jUyrRh+/BL2CG5W6DXfmYZsKXFXt0J0a3LGOY2OoJROCR+I3H/gmWc38E7AHBcu1T9ggak81wBDegWpGFoEbYEijldCx0RBOR1MNXszfGNFFmwEPXxubSO64MYWXeh56ezrnkQKSfxZaNCbhz9eS8vTtlxbL/czHF4dHNN7QRgWy6+hkeXab9AXBqJLW/kHQVDsrTX/eG+3CxRVTNHW9e+15gYZSKpjGo3Ou2J3ux2QEbi
 p/TG1AZd
 ZXjm2BHDPB3v15q4GxWLwQrPITVsjhofGs9ibB9EXDS/jL1dQWZg1enxO1h2gt9jUQNrXGStK+ueEREzFkY9CFQnLjaJG7EFJGbC/mitDofWIHG9N59rrIRFJ+GaEvr+sSUjBA0mGpPTc1nZqD+QdEkB9UhTjkDntvSoN/9CoUKXVp1ZEkCqtsDQpPe4EqGAikGDOWy4kr6k0zAI+2RPH3odDOYb1vTubdPWChVRnyJlorMl6GrT+X6VSHCwi1k/cZ9HzNY8G4U8IBb8aTaMN22apllZxBztBAyX7l4ptYIuKD/Xr8p7kToBEjyiyf6QPXAyjmZdRdoDMl5qzcKamV5aTwzSAy0aiDV57OHSImsIDquFGwNnYVXr4/R5BHuvVTHw1Wtr2SwEtsxwN+3c8zf4XxKqxP69OkhxBTy2+9EhrYHGi3bYNiQXiLIt8EblgFYbokAEUBmYppxFOz2lrgFoWD1U62p27tFogs7L7Y5swV+/8MK4hLaEwnu7rfW0zgql1RrzqPAAEmYrhwuXDLeVHBqqWpLSvsjD7KKRQvzfj294Af4k7kGBzQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 27e6a24a4cf3 ("mm, virt: merge AS_UNMOVABLE and AS_INACCESSIBLE")
folded the two flags into one, on the grounds that guest_memfd was the
only user and always set both. But the two flags were added for
different reasons and guard different things:

  AS_UNMOVABLE (0003e2a41468) marks a mapping whose folios cannot be
  migrated.

  AS_INACCESSIBLE (c72ceafbd12c) marks a mapping whose contents must
  not be directly R/W accessed. Its only job is to stop
  truncate_inode_partial_folio() from zeroing the folio.

The merge assumed unmovable and inaccessible were the same thing.
This cannot express a mapping that is inaccessible yet still movable,
which is exactly what guest_memfd wants.

Reintroduce AS_UNMOVABLE and restore the original split: truncate keeps
checking AS_INACCESSIBLE, while migration and compaction go back to
checking AS_UNMOVABLE.

Currently guest_memfd sets both, so the resulting flags and behaviour
are unchanged. Preparatory change to support folio migration for
non-confidential guest_memfd VMs.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 include/linux/pagemap.h | 24 ++++++++++++++++++++----
 mm/compaction.c         | 12 ++++++------
 mm/migrate.c            |  2 +-
 virt/kvm/guest_memfd.c  |  1 +
 4 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..a7dcaa66e4e3 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -210,6 +210,7 @@ enum mapping_flags {
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM = 9,
 	AS_KERNEL_FILE = 10,	/* mapping for a fake kernel file that shouldn't
 				   account usage to user cgroups */
+	AS_UNMOVABLE = 11,	/* The mapping cannot be moved, ever */
 	/* Bits 16-25 are used for FOLIO_ORDER */
 	AS_FOLIO_ORDER_BITS = 5,
 	AS_FOLIO_ORDER_MIN = 16,
@@ -322,11 +323,10 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
 static inline void mapping_set_inaccessible(struct address_space *mapping)
 {
 	/*
-	 * It's expected inaccessible mappings are also unevictable. Compaction
-	 * migrate scanner (isolate_migratepages_block()) relies on this to
-	 * reduce page locking.
+	 * The mapping's contents must not be accessed by the CPU through
+	 * the kernel direct map or other internal paths (e.g. zeroing of
+	 * pages during truncation).
 	 */
-	set_bit(AS_UNEVICTABLE, &mapping->flags);
 	set_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
@@ -335,6 +335,22 @@ static inline bool mapping_inaccessible(const struct address_space *mapping)
 	return test_bit(AS_INACCESSIBLE, &mapping->flags);
 }
 
+static inline void mapping_set_unmovable(struct address_space *mapping)
+{
+	/*
+	 * It's expected unmovable mappings are also unevictable. Compaction
+	 * migrate scanner (isolate_migratepages_block()) relies on this to
+	 * reduce page locking.
+	 */
+	set_bit(AS_UNEVICTABLE, &mapping->flags);
+	set_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
+static inline bool mapping_unmovable(const struct address_space *mapping)
+{
+	return test_bit(AS_UNMOVABLE, &mapping->flags);
+}
+
 static inline void mapping_set_writeback_may_deadlock_on_reclaim(struct address_space *mapping)
 {
 	set_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);
diff --git a/mm/compaction.c b/mm/compaction.c
index f08765ade014..e6b0fdfaf79d 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1133,22 +1133,22 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		if (((mode & ISOLATE_ASYNC_MIGRATE) && is_dirty) ||
 		    (mapping && is_unevictable)) {
 			bool migrate_dirty = true;
-			bool is_inaccessible;
+			bool is_unmovable;
 
 			/*
 			 * Only folios without mappings or that have
 			 * a ->migrate_folio callback are possible to migrate
 			 * without blocking.
 			 *
-			 * Folios from inaccessible mappings are not migratable.
+			 * Folios from unmovable mappings are not migratable.
 			 *
 			 * However, we can be racing with truncation, which can
 			 * free the mapping that we need to check. Truncation
 			 * holds the folio lock until after the folio is removed
 			 * from the page so holding it ourselves is sufficient.
 			 *
-			 * To avoid locking the folio just to check inaccessible,
-			 * assume every inaccessible folio is also unevictable,
+			 * To avoid locking the folio just to check unmovable,
+			 * assume every unmovable folio is also unevictable,
 			 * which is a cheaper test.  If our assumption goes
 			 * wrong, it's not a correctness bug, just potentially
 			 * wasted cycles.
@@ -1161,9 +1161,9 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 				migrate_dirty = !mapping ||
 						mapping->a_ops->migrate_folio;
 			}
-			is_inaccessible = mapping && mapping_inaccessible(mapping);
+			is_unmovable = mapping && mapping_unmovable(mapping);
 			folio_unlock(folio);
-			if (!migrate_dirty || is_inaccessible)
+			if (!migrate_dirty || is_unmovable)
 				goto isolate_fail_put;
 		}
 
diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716..e48ccd5a9485 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1100,7 +1100,7 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
 
 	if (!mapping)
 		rc = migrate_folio(mapping, dst, src, mode);
-	else if (mapping_inaccessible(mapping))
+	else if (mapping_unmovable(mapping))
 		rc = -EOPNOTSUPP;
 	else if (mapping->a_ops->migrate_folio)
 		/*
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index db57c5766ab6..d3b1186b03b3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -593,6 +593,7 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_inaccessible(inode->i_mapping);
+	mapping_set_unmovable(inode->i_mapping);
 	/* Unmovable mappings are supposed to be marked unevictable as well. */
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
 

-- 
2.43.0


