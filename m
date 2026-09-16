Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 435C4C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 043476B009D; Wed, 16 Sep 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A596B009E; Wed, 16 Sep 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BF36B009F; Wed, 16 Sep 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B54A76B009D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:55:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3DC7CC06FB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:55:32 +0000 (UTC)
X-FDA: 85219470504.09.2F74743
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011054.outbound.protection.outlook.com [40.93.194.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2905440007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hJHVgTgw;
	spf=pass (imf11.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.194.54 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789559729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fOSelVshB8tt+z9i3a63f+uWxxjJMxzG7NNd33A9O0=;
	b=w7wO64f8zNyBWN1dgfmLNZCefrxXL7IllNglm6NwLY0ZM2FLiJjIZFJsVfOEMHzObAiV/d
	TUVEJsc3vzxVZ8YUkuRlHPXML5BmX4kx5qtFGSZitDGxIECfhnMqzjoQUqtcTQM98LVcm8
	iNq51GraQHWCRoDfX/nXkGxGCk3qnq8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=hJHVgTgw;
	spf=pass (imf11.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.194.54 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789559729;
	b=NK6SatyYc2SSIRGv5pdehatXYaGvpDMBI4nV9fca18MaODe7HvisNdfF6vT1w8+QOVv8d/
	uwquz+MBfD/Mm1B9lVcQ3bekHAjpPsV0l5z+O9XKF+JNWzQO024bPYbjevANY7nkasWwLm
	pBsg2cKVrn++FtcQ8Pxi6f6mt0QKl0o=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TZy2ZJrkMF7OCH9yN7sKyjTdWF7pgDVN6EGs0NLiBABwnnfINtahWOBYqwOz/NWr6N0AN5xk3KZ9gnYsR5DRJMFpXYxh6z5BOA4SqDov1+Py1rv1VdX8JfLWi2Iu9VC//4ZTsve+l1KibkrziEneP494mzlK+fKQ8Y6ZYsA72HeYMG2Hr2hrH/eH1tEk+QrUFUMbjHI1RdRPodHPy4kbR8OzqIx9MnVk7cuU+a0TdPj82AuZaqRcYaxYTHwARqMM06dsFTyWbujX389/moTRtNEA9l6ZTCBwS/3FOhSuXIjxLzfOGe+Ae7jc9Z5xx92b3zLyVpM45P9ZGWWrKZixBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fOSelVshB8tt+z9i3a63f+uWxxjJMxzG7NNd33A9O0=;
 b=jvahsYYrSSADIREzYZklS3cfIwMu0Zmjl3U5BvdwOD0bHjS79vNZLV1090cMPL6Uddm1Hw+ha8DsRIl6P3D7x0Ofg7n5e0eXwx40OjAREYnsDswkBOv39tT7q/bKNNpUmqXWpuNLksT0urT9O7eswM+0t9pB45isrHcK6lFqM8UdcQiBDw4Vb33gF6dsB3eyhqYeP32eJFGEnfmG5DILEG7wekx+bPb9r8qXvsuX1N7LC/toA2ovW1QUEOVq6z514RTOhjhfZBxnBBRn+Dlr186XJ+X6ysknfcEZXH08zx1mABhTDn64ZziAWAzDtRO8T9+PFyMF6nB9sRZuzltbiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fOSelVshB8tt+z9i3a63f+uWxxjJMxzG7NNd33A9O0=;
 b=hJHVgTgw40xSH04nc9KEY2kTfcBikFvdZzQOK6y8fFdlPWQ206tziMwKbuHLq2YsQdsWnXpxBJBN+nC+uIlM7TQItN4B4LBXEVkNpnzIbo0qAVLlJlMgBl/jaNSuWF8TLglwQGLQXYoBSkSvj44AiMmqUoZVh4d3hV9YFqdWZsw=
Received: from BN0PR04CA0192.namprd04.prod.outlook.com (2603:10b6:408:e9::17)
 by CY8PR12MB7267.namprd12.prod.outlook.com (2603:10b6:930:55::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 11:55:12 +0000
Received: from BN1PEPF00018545.namprd05.prod.outlook.com
 (2603:10b6:408:e9:cafe::a) by BN0PR04CA0192.outlook.office365.com
 (2603:10b6:408:e9::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:55:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00018545.mail.protection.outlook.com (10.167.248.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:55:12 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:54:44 -0500
From: Alexey Kardashevskiy <aik@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-pci@vger.kernel.org>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Bjorn Helgaas <bhelgaas@google.com>,
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Marek Szyprowski
	<m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, Michal Hocko <mhocko@suse.com>, "Catalin
 Marinas" <catalin.marinas@arm.com>, Jini Susan George
	<jinisusan.george@amd.com>, Kees Cook <kees@kernel.org>, Michael Ellerman
	<mpe@ellerman.id.au>, Nikunj A Dadhania <nikunj@amd.com>, Ard Biesheuvel
	<ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, Kim Phillips
	<kim.phillips@amd.com>, Joerg Roedel <jroedel@suse.de>, Ethan Nelson-Moore
	<enelsonmoore@gmail.com>, "Tycho Andersen (AMD)" <tycho@kernel.org>, "Liam
 Merwick" <liam.merwick@oracle.com>, Michael Kerrisk <mtk.manpages@gmail.com>,
	Suresh Siddha <suresh.b.siddha@intel.com>, Xiaotian Feng <dfeng@redhat.com>,
	Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, Andi Kleen
	<ak@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, Tony Luck
	<tony.luck@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, Lu Baolu
	<baolu.lu@linux.intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>, Jonathan Cameron
	<jic23@kernel.org>, Jori Koolstra <jkoolstra@xs4all.nl>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Ian Campbell
	<ian.campbell@citrix.com>, Jeremy Fitzhardinge
	<jeremy.fitzhardinge@citrix.com>, Petr Tesarik <ptesarik@suse.com>, "David
 Howells" <dhowells@redhat.com>, Haavard Skinnemoen <hskinnemoen@atmel.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Christian
 Marangi" <ansuelsmth@gmail.com>, Dave Jiang <dave.jiang@intel.com>, "Michael
 Kelley" <mhklinux@outlook.com>, Ilias Stamatis <ilstam@amazon.com>, "Sumanth
 Korikkar" <sumanthk@linux.ibm.com>, Simona Vetter <simona.vetter@ffwll.ch>,
	Toshi Kani <toshi.kani@hp.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Vinod Koul <vkoul@kernel.org>, Jiang Liu
	<jiang.liu@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, Anshuman Khandual
	<anshuman.khandual@arm.com>, Kefeng Wang <wangkefeng.wang@huawei.com>,
	"Palmer Dabbelt" <palmerdabbelt@google.com>, <linux-coco@lists.linux.dev>,
	<xen-devel@lists.xenproject.org>, <iommu@lists.linux.dev>,
	<linux-mm@kvack.org>, Alexey Kardashevskiy <aik@amd.com>, <aik@ozlabs.ru>,
	Santosh Shukla <santosh.shukla@amd.com>, "Pratik R . Sampat"
	<prsampat@amd.com>, Scott Soule Cheloha <scott.cheloha@amd.com>, Ackerley Tng
	<ackerleytng@google.com>, Fuad Tabba <tabba@google.com>
Subject: [RFC PATCH kernel 04/17] crypto/ccp/tsm: Use TSM API for DOE
Date: Wed, 16 Sep 2026 21:51:44 +1000
Message-ID: <20260916115159.1938195-5-aik@amd.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916115159.1938195-1-aik@amd.com>
References: <20260916115159.1938195-1-aik@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00018545:EE_|CY8PR12MB7267:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b0368a-0e2f-42c3-de47-08df13e95d65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700016|32650700020|1800799024|23010399003|7416014|376014|22082099003|18002099003|56012099006|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info:
	78xBYQC3+wj95ztS+jhBh7cicxBkBZUOOlFcfH+bxAVFisXGI8GTXus06sBoYkM4BHUkb5zK5O7yhQwpaF6Ip7ekJl/G+pCPCtnHlkIbjjDv8+KUNHhK+PJ5RhP6SlzTgoe81C/Eh+DyMDQXye78SzFJwQW40rgBDQmTb9VchioXMTf4z/5CzwrtVTOPqbyMg+Y8jjHpiDtfFf8zitapJgCESsXZOSM9HNHyJ0Um1NQ7D9s0uHUfcT/dzxDylcymM2S+Ld5yStPeE7mCxLl6qhrLFr3BSHwHwIQKghVjXLTcDnqt3GYaRiw1yz3V3OyeUjtuGPCVf3AbPcfXsEjBmGX3h2tdEuTQRVG2yu5p2hVO7DHZiUoLYTEA8rUsbspBT4rewvZj80kJwOFeoOC9mrD53/WOfp4jUrKfPm1SisbB+kyVpNsgZZv5etsg5Ftvdv2z1q+jSldsTRs0LfdHF3TNYwTFEs1O7ZDtHQkyvUMGi8Wd0Q4cAhiexEAvh9HeKXdpy7ly9noT4dc7jyjth76Lc412wIb3GxzcBx4uGvx9TbHy30dbUYFWfGVgiRyJ4kKr6lWWtTrwgeUS8GP8q2WbaMspMBnT3PljHdlQYUHCU206jA3P1Ax0KDSFRZmCQHobtyHO4o9tJVYCppnHdmpteVaf6qX9JvzuwR/35nR2qu87SdsvzIJ/RRzcLYid
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700016)(32650700020)(1800799024)(23010399003)(7416014)(376014)(22082099003)(18002099003)(56012099006)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	2+d9WKfuRzwiWgMdluOVo4qJNhnH2FvmuZhqqjP8Ga5RudmSdxm4o30kD3JGM+JEJhea7Mw6INW7XT3nm6ypzdPviJMk9OK4Pvzn2FWUxcA7Vdl/e56ub2ci729tDDVfvh9CVw61K6ffH4bM+JOXA9hNl5odzX2HLX/1echQ9gdSp7MdJwUJI64mKFNnvbf9aUbAqNw4+4SJCg+XD9XffbZf6fjl0LBtuDu0HjfarKrIabaGlv54VhQ3oyYEtE9psLNTPckbXz1N2avdxAcXqsvWJ2kLmfkkwZ5KVqB55EFLafOAfCbw5IMEhQaZWZfVjmI54+4RWFQcol/rYF1TFVzsYPTn+eBGFcEeCuS6BT7+MsDtPowlpnYvJ/R4X0x3YM5wuUYpDWv4dKXLhb6UuiqPb5UM6Mz5WR/m9mvvSwqSgI6A6Nq+5hSnCXyY+hAU
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:55:12.4634
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b0368a-0e2f-42c3-de47-08df13e95d65
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018545.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7267
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2905440007
X-Stat-Signature: ssqzirp8ji6igk7tde8rf4wj8a5zrff7
X-Rspam-User: 
X-HE-Tag: 1789559729-847255
X-HE-Meta: U2FsdGVkX189V3HPvy4eC9Zv2TmmNZgzbHnS7slJtvaVblVeuyMcQ5PbX4acZJ32MOft2DeYystFOKivOr5hILL0xvqOaMNcMljSc70rC0MMdOL4N8Z58ftYJVx03OQnr/tFoDzXHoaSio4YdSuT6Nz2kZNCq7YUeY/W1FOPn5Y1URN/NH6ddJT0GlPbmxF/SsNUg6YXQRTrK2NADSeZBajkNlcPXorjmVwzenjahVQOzrUBGDmXwh7KtZTb0YFco1Aka6GOrfsgAdMP670J7ZHxpBFhqvuyEF40Fql/GqiIiUlRH2bjbI3hEj2tE2mbbbBWGWnEx+lK3S5qVL3K7nGozwJdR/i01qICznu+INC1GNRUSkgJ8K2uqitzXQ5i6UaIyAfnHlZi8y1DNUsfpzj96kn9ZzHVMaY2AqubgH7t0wAS+Z/Df/63muZXO4jsrtS0uY26AQT1gxQHMZnPgz9IEhwo+j6lbzruKeQWl4m1wuFtjtAYI5PMyigow/t6rcuQJmOZ/QQU4PWO052MgrdlkyBl6OKWfDQ0r9ilbO1taLai6WY/Y3E3NQwTGhR43IrinRD2SmuFafUc39GnlesEvsGsZgnKf1OJUs1ss0G9w1SOUi1xTGhfNd4z0QiVh1+pngHk3BW3O3tXIlv50h7RoY/tG7QLBVBzjJUBNzJjVdwBN++OQUiSsRgHn3rBpFutExYXyRTn+SUsbLIwUbeRt8ElyPBKwcBMDfQA5Fn0pQhwXcmRUm1eEiQ6UJG/34GKXPVolYCDX/kiHO76N9G06lQ60VOReCqxccmNcBZn8apoaPHHvX0/CiBClZvZXJulQ5nSuZPhB8Qgel9wUPb7Up/khOH5G9VGlUhsJzVjZu1vI9PCQUJCSoOxUhYQsQB2HpVyrh9mJU+4Jdqk1XyWdJNAO7RVKvSynvYVdp/ygtxDJms3e6BdnXJqoaRiXTuNRTC/Yn4jpsl3YC+
 tYKib/7l
 g2TLzLFZp3smHifMLfXyNkEbWXJ4j0DvpPbOn0Xb1YJwVbluQ6CY3ZSAR5d2AkCjP1YbitXtWUnJypj7bbeevdUDS0NlNVPeU1f4Rm0uiVcXwzlCTvK2ZgT+xQrWz9muuAxjc4JsdrbcUCI8lLZ3HRaf4R4JBZtmKTvNdxI43gd/dIhujkeg3OJC84GPXgMd3+QBR8ZDSHBEMtSyfDr+nax6Fe8iMQgsAke8UZBgAtbTJd7SW0OKUutC4LfflXc9nAET/olmNk5Dnf+hZc82jNuP1vIZGtnkaU7dDZUOT9q5eZmP8objg5Pr3FQqTKwzeBnpiO6VoDuC1r4ymT2zCErM+SbQhmcVklXo7pF9wWOinfGPCG+UWHxSMG/xDmeYbclMwOoatBsgJZJqFyPVqWvNF8IIBjKeucPoIiZQuLt+fUBtpaTAVLbyocRATNv0WAYpfuXwd67tXa1BOwt9pItjOE882Fc6KEBR1B5nxqJGu0AzFSIcpUg0nNJXW25rd5nko0I46RLtgskHsUzYUd3jQzTcKhTX8HVl8avkw+01Y4dpC95SRBwskbQKdZUnsYLU5LlqN8HprWIv3jBqc9IDi3hgZvUURelRUeWKEJQyUDFx3nE0n1IYBa32UA6iPgrR46oDuGIVjD8hc8Q9gJSNrvCjt/dCUQXym
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compared to the currently used pci_doe(), the pci_tsm_doe_transfer() helper
performs a few more sanity checks, use that helper now.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/crypto/ccp/sev-dev-tsm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 46f2539d2d5a..6e704ad239af 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -40,8 +40,9 @@ static int sev_tio_spdm_cmd(struct tio_dsm *dsm, int ret)
 
 	/* ret > 0 means "SPDM requested" */
 	while (ret == PCI_DOE_FEATURE_CMA || ret == PCI_DOE_FEATURE_SSESSION) {
-		ret = pci_doe(dsm->tsm.doe_mb, PCI_VENDOR_ID_PCI_SIG, ret,
-			      spdm->req, spdm->req_len, spdm->rsp, spdm->rsp_len);
+		ret = pci_tsm_doe_transfer(dsm->tsm.base_tsm.pdev, ret,
+					   spdm->req, spdm->req_len,
+					   spdm->rsp, spdm->rsp_len);
 		if (ret < 0)
 			break;
 
-- 
2.55.0


