Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0215CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9A96B00A0; Thu, 11 Jun 2026 09:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481006B00A1; Thu, 11 Jun 2026 09:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370A16B00A2; Thu, 11 Jun 2026 09:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28A846B00A0
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:06:33 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E29DF1C34DF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:32 +0000 (UTC)
X-FDA: 84867655824.10.79EAFB7
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010021.outbound.protection.outlook.com [52.101.56.21])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D92C160019
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:06:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NXLHaqB2;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781183189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EfbkZXmmFzTTcMljeslZnR+zbaNpTdlfJkd0sm9M0fc=;
	b=HBmvOT28SUseqRWNd8JAm+1/IiKR1CrI8iSwRJLdWP3112zi50LERFYHfKEtahIMKp1O+e
	VN/yqmUmS/OExVxDxfs3BuDTKj9CC/ldvM7+SirRzoRImKelAAhsUqbouL7/V50euh5RJO
	HzXRK6Psd/HbcQ/H6NTtW3TsKlP2rY4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781183189;
	b=xGYMlrrJVNNyWun4oTPHkKK0Smz0tMqeHCANL11+NRKRgldWXFjfQYr9gmttuxeTa3J9QV
	zIb+zXz8X2g28+lxPD3VwO6MLCieS/OFtMZSYcJpCKBrWBOL1pbIdU8eh5SW1qRbOlrAtg
	cPtReF0n8z1ZCutgsCOEmGr9wr7amXk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=NXLHaqB2;
	spf=pass (imf08.hostedemail.com: domain of shivankg@amd.com designates 52.101.56.21 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eMnhtHJAbgMOzYMrg8Fld1hyeQDnY7y7P96pnnRPP8QvXIIZ6xkBKVCViO7I0ciCT4lcbMZw7O0JRGlCosXpkWwHiKgF9/xazTyVJiN369Ufs+0B3vW4p21uaGYMbpJoO+N7V5VoGW1bu5IGFGmfQkU+OtEMBeGy6EuPZU8FLpYWjUROSfcV17He9AnlIxaV+La/7yyiFXKeAT4GWk2dINi0RenqRdGSULBOlHuTjxi2e/ttc4Z5dAqDJOTQ8XwagsF+0Awmxk2ZmIFobF+PUNoWsr/dS0zxHGKs+IrjFKEDPln7F+tykQfzHGi1+I5nXmS3BEI+UWmw7QGL0wFVQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EfbkZXmmFzTTcMljeslZnR+zbaNpTdlfJkd0sm9M0fc=;
 b=OoxVEZ2lNJce2st/IkwgS50fG80eLtyfCLdwxb7jKdUGdaf9NkSi4WoskD7AsIMd35BhLfkYcThUalf+RsBiRDACZbDENtvzSX1cLComFtHk8MiCkwiabu8HcQffrSIcZwfadFzl5plnH19BBXa236f/Wta+rkGQNec/xUIN+kcK2lfzlFLgBl0l/CFClQANSnrL5yfhcsci4EBRhhxUtqWT8lSmKBHZHCwIYLDgDgEzIbquoq1vFukPfFv13nPsa3hYQ2H8+9mo8/6bvgidoGfUXtyTtCxQ5LiGCKHNFnvRHA5R1hdBOpb2bc7Qp/5arSUXN1r4ldT2E52CMnM1lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EfbkZXmmFzTTcMljeslZnR+zbaNpTdlfJkd0sm9M0fc=;
 b=NXLHaqB2zH1RvLIYPLmbtk5hPWQyUTx8Qgh/zhMN7zfChZpjJXTL6OHRvLudrbPB5199aOpJF05r3rfhWhu5M8wcQk17oSZJznlLPJ3AgrUh6BSa9tU4MElglzq9n6ImPzG60lYbImrdxyVQBxZ+qJBrpqYquld1JdQSA1Kw5M8=
Received: from BY3PR03CA0019.namprd03.prod.outlook.com (2603:10b6:a03:39a::24)
 by IA1PR12MB9064.namprd12.prod.outlook.com (2603:10b6:208:3a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.14; Thu, 11 Jun
 2026 13:06:25 +0000
Received: from SJ5PEPF000001CC.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::8) by BY3PR03CA0019.outlook.office365.com
 (2603:10b6:a03:39a::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.113.14 via Frontend Transport; Thu,
 11 Jun 2026 13:06:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb08.amd.com; pr=C
Received: from satlexmb08.amd.com (165.204.84.17) by
 SJ5PEPF000001CC.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.113.7 via Frontend Transport; Thu, 11 Jun 2026 13:06:24 +0000
Received: from Satlexmb09.amd.com (10.181.42.218) by satlexmb08.amd.com
 (10.181.42.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 08:06:23 -0500
Received: from [127.0.1.1] (10.180.168.240) by satlexmb09.amd.com
 (10.181.42.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Thu, 11 Jun
 2026 06:06:15 -0700
From: Shivank Garg <shivankg@amd.com>
Date: Thu, 11 Jun 2026 13:05:09 +0000
Subject: [PATCH RFC 2/3] KVM: guest_memfd: support folio migration for
 non-confidential VMs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260611-shivank-gmem-migrate-v1-2-2d266bfc6f95@amd.com>
References: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
In-Reply-To: <20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com>
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
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, Ira Weiny
	<ira.weiny@intel.com>, Michael Roth <michael.roth@amd.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Ackerley Tng <ackerleytng@google.com>, Fuad Tabba
	<tabba@google.com>, Sean Christopherson <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781183157; l=3567;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=0vEf8TcJYj/jra3f7/gl1PJYMpUia9Tb4gpiYZ1ToPU=;
 b=v793qmU10vx9OQOPZ5kJ4GneAizF1RxE+2QmnGpF5lHUGUFQYZC8PT6apxiv10xlnBbjhpCpE
 0hNueh7rmCuAq3sn1Svsd9acaYISnjzvkft1JArWqxZIVQjOTIi0efa
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb09.amd.com
 (10.181.42.218)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CC:EE_|IA1PR12MB9064:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b52ceb6-4f0a-4452-ca58-08dec7ba3d72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|23010399003|376014|7416014|921020|18002099003|22082099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	ttF8yth1YCBvNdGCvGEocW8V0qFHg9u3xlKhiGoBn6kMBGTroMfOkcOVBmdhcORbRZMzRruQvWnQw2PZiFsVtWXGh5ocJTfJsl6+s4yt8/qPFkQseDcFv0TwnkEcRuAFjGGMUiNRbVHSp41xpY2xNFTVkGfHerRS/BpupjPsqeY9gwDdkHEfFzPmbI1LN1DfwatapY7eGd2URtOBkWeXVX/dOD5n9UMBIZiIAY7JtHd9cLHyQj1yO+Bim3GZEdAMUST5fJxD/4818uaf2q5OfiNGB+60Me+536rNmGGbCGUXkVB9mXXfrv6OD/BVYrw34TpyJe3l4Ft7Y4Fxa6aU/vrgCqI4kxf16pso7Hl5Kk01ZZFf7MQkKPftIX3oJ9+DzTsv8T5SiyzKjQVahReyKIQZrazP0NrsOp+SZCk2hshZCCwImN5Gh2PNmWKmeL8qn8w9QjQayITQePgIRT7U9vwDFX2K5Mr370WJC3GGPIj4trbBkoicCWWHp5pscyuKaKDp3dc+g3EjjpicPRVYRVyx4USZCC852GmeDh4MZtQvcdKV6ChsiB4/PcpiWOOQSGYcRsn2jd0hc+27yH/HhIA2vE+Vk8oiJtfMt9b1NBV9jEBOfqxZiSjHIlkR8jb9nLpekhbRnxunBNvGgsWEvVJ09z1bAosyA7uXJcuAkDbCkGT04cIhIMpTgpH7ieFCUJCChh8qVWBUx92QY/TApXmm7UdWQDTgM5ObxiNgkG9RawaPFbX7XVIauBTnSUFtOkCRHWeIcuQ1I1tg5GIRDEM/WQYq+SavNCAaJpjDcLM=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb08.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(23010399003)(376014)(7416014)(921020)(18002099003)(22082099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	dVn25/scKOpTAiq9Lkr/WkcH/U1GYQz4pMBadKEK0/93zmnadT/JQOYCjIRONe+YWCSlabHyadVEl69+x41VnjdfZcqEyvwjP9o/pdwPB6nLrO+aG4QoTcQStdkf5KP0aTnWBwFpDW32hZuRGPAcOyX5/MAfbdvyUBQwnHO0hosmwtlpqBkpTKX+Z+8ujQxRCz66EVt9CUuxReHkHz2mEmQlI30iWdVC0lL1dgFBvvxXaphGEUFi1h9UkcUk780jAs53cVqigyFHlAqyV/BfXmuOZ5XBcbxXjfeTrN+VP4CkEZfCFPvAqYIgHx8Ow8elcrhYho8SQ+QAgBglfTKzAvT7iV91Yw+QZ0F6W+gKl4xNRHsbnzo4bXc2HGTQgwuW8Lo1tWivQ9P5/0KWwQg7+/xmlP5Tonrw96/mh9cCNu7uGfrAffEdnohCLO+iHrNG
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2026 13:06:24.0874
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b52ceb6-4f0a-4452-ca58-08dec7ba3d72
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb08.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9064
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7D92C160019
X-Stat-Signature: 9bmw6kfcycqwqimqinrgrxpa56i3pix7
X-HE-Tag: 1781183189-632821
X-HE-Meta: U2FsdGVkX1+DGE2t6iPcqF4IaKuyuAC8sfYwLgZNEZ3u3Y6f9KJX+bsh7MunvxL1+FnlpKcJYkzj3doSqi3+HSi5nYFhnEKhH4VCBaQli+3sRqkyiZn9AZDuGn8NEBblryiqK5tiR7UWQeQo8zJ7FnB+Wk7MMOikxTMi6nCxXruET+ov8EL8uRe2eJg51SK4u3kNjDr4TNddOhY8gbWRGFYlZb37XsuNjX9IB1HwZcYGrHlMS7WNTRVht8NOUY/AFTjctF5GTeJV0m5M5NoDJyjrm+XRqpmQ4ZKBKL8Fz7bDL09A8j1mQTev5E3xWAnWCMFOdLjuoHXmJqT/8+TBpWyt/ShdWUNCWIgnAFK9l+lQur2D3bwhPWL4GHu4B2XUTTeBolb6Pe+TiUeOIouJUZYE9F3eYqam0veGyuZP0da5ORDHxC5IzwB4GV+GryKfM9E5jiOItIE/A0ubhQZYwjBI6G1ZWUneSGpLpMjHa7EixonnAAXzFqJAq7T5AjTL04e+FdoO8bJNMx0RaWzxBIhMvD09bfYdCZUdOKDZLxzeWOznT+6KN37uJQb8Y7OAUGsbahuFCdDbt9h4nMxtPnSWrmz8ONDqFg1rl7bz8bn2AzJ9+U+AV9JLRZhF4Ynm9my53mIk6kn/FHeIDd+Jos9x8k2Mi8XN5kbefczS5tUPOzwusvmZtwnnx5RHNUP/1uFdC/amLzjVLsIqNens7qRxCLjmEHwvqXU64sVq2byuoxRssFoVIutYsPdyhlHgQ95MupMqldseulfnn0ATbIlNwFvkch5OtnhKDHYz3pGr8zUXMuOJ31jT2D4+rxZj3fNfdk+3U3IjcHT03KAfRJ7YWd5gzQT5wHPBvf0zdYO8WiJbNWce93iuRro+Pcc05nwgK0vG1EIGGH+ZzI0VSTQA8AaYNVt6qKVnlNZjxBchI+wTH3IQ1j8XoFidHoPcNOfRGhFtEHufRce850m
 pgchuLhc
 n1rhJeF/EwWuVFX37j0Xj9uwJgtt5QuNLw11zir4WJg8L+5UO8FQSLTiCLf3bA5VFk/uGUwboiETzVPSbYoKNo4NSd8cJ8yoMki+xGNcL2UqkxcvjqLRtzzTqBnGNJblCrw5B1fLJ3TV+TCRAbKJuYAapCSBvx/8qxrxwGMuH1z0cmpxC6xDdxbBjxHNNBFtm0AcKJP4nda+vTnh3zahCF21T0JjcASkfseYfQEB1dKe136j99kHcuHql0vNu8n8hEqPR8W2QD5VIVLf+w2mZ+Ocq2LzJjOJa/IddwMJlbZFZhpmfyFxcHDDTD5wTc5qv0rDQOMfWndUe/iqv+RRZ2oH95D112ompMAw1Mat/MrrAJK7nLXSJ79gy1zRL08ss0u66u4V9iq1HtDr7L8ei7qePqwMuHBhyWhfDg63KN9TINgaHAGmPaytbpRFIb1NmivV+E+QbPUUx4Dlu7D7vYKvyp/JLlHJPNQT5e8SKef+lTLi+WGgkyctFXeYOg2tXCtjQxIfgo3VfXbmbeIm+pWwS6KqMbs1b5YLFLJaUXWeOjBcqZDOaX2/31xKYuIz4HdN8NTVi8RHzC1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd folios are currently marked unmmovable, so the kernel
cannot perform NUMA-balancing, memory compaction, etc.
This is unavoidable for confidential VMs (SEV-SNP, TDX),
since memory is encrypted and copying it need firmware assistance.
However, for non-cofidential VMs (like firecracker), we can migrate
the folios.

Mark non-confidential VMs as movable and implement
kvm_gmem_migrate_folio() using filemap_migrate_folio().

This lays the ground work for migrating cofidential guest_memfd
later. Once the firmware-assisted copying support is available,
those VMs can be made movable. The confidential folio content can
be copied separately, and the destination folio can be marked with
FOLIO_CONTENT_COPIED so __migrate_folio() skips the host-side
folio_mc_copy().

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 virt/kvm/guest_memfd.c | 50 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 806a42f0e031a1c7729f53c786316d2502532553..e4470106fc7792f328bce5275419683328c8b4ab 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -487,13 +487,45 @@ static struct file_operations kvm_gmem_fops = {
 	.fallocate	= kvm_gmem_fallocate,
 };
 
+#ifdef CONFIG_MIGRATION
 static int kvm_gmem_migrate_folio(struct address_space *mapping,
 				  struct folio *dst, struct folio *src,
 				  enum migrate_mode mode)
 {
-	WARN_ON_ONCE(1);
-	return -EINVAL;
+	struct inode *inode = mapping->host;
+	pgoff_t start, end;
+	int ret;
+
+	if (!filemap_invalidate_trylock_shared(mapping))
+		return -EAGAIN;
+
+	start = src->index;
+	end = start + folio_nr_pages(src);
+
+	kvm_gmem_invalidate_begin(inode, start, end);
+
+	/*
+	 * For non-confidential guest_memfd the folio is host-readable,
+	 * so filemap_migrate_folio() can copy the contents itself via
+	 * folio_mc_copy().
+	 *
+	 * This is also the hook point for confidential VMs (SEV-SNP, TDX) once
+	 * they are made movable: the host cannot copy encrypted/private memory,
+	 * so a firmware-assisted copy would run here.
+	 * Idea: https://lore.kernel.org/r/20260428155043.39251-8-shivankg@amd.com
+	 * Mark the @dst->migrate_info field with FOLIO_CONTENT_COPIED, so
+	 * __migrate_folio() skip folio_mc_copy() for confidential VMs.
+	 */
+	ret = filemap_migrate_folio(mapping, dst, src, mode);
+
+	kvm_gmem_invalidate_end(inode, start, end);
+
+	filemap_invalidate_unlock_shared(mapping);
+	return ret;
 }
+#else
+#define kvm_gmem_migrate_folio NULL
+#endif
 
 static int kvm_gmem_error_folio(struct address_space *mapping, struct folio *folio)
 {
@@ -592,9 +624,17 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_size = size;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_inaccessible(inode->i_mapping);
-	mapping_set_unmovable(inode->i_mapping);
-	/* Unmovable mappings are supposed to be marked unevictable as well. */
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+
+	/*
+	 * Confidential VMs (SEV-SNP, TDX) bind encryption to the physical
+	 * address and require firmware assisted copy, so their folios cannot
+	 * be migrated yet.
+	 */
+	if (kvm_arch_has_private_mem(kvm)) {
+		mapping_set_unmovable(inode->i_mapping);
+		/* Unmovable mappings are supposed to be marked unevictable as well. */
+		WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+	}
 
 	GMEM_I(inode)->flags = flags;
 

-- 
2.43.0


