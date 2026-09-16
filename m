Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E260CC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFECB6B0088; Wed, 16 Sep 2026 07:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6256B0096; Wed, 16 Sep 2026 07:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5226B0098; Wed, 16 Sep 2026 07:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 88C1E6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:53:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06FCEA06D2
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:53:23 +0000 (UTC)
X-FDA: 85219465086.12.3A27236
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013063.outbound.protection.outlook.com [40.93.201.63])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8D28C0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:53:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=N0hikTVZ;
	spf=pass (imf22.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.201.63 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789559600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SY2PXIfdH4gQPL2ZLaN4rYd0hBg60SV0RgUb/GbX15c=;
	b=O1+bqpNLMRNv2gw/3rOihy6iSF5W8nZLMt3bIf6L7cb+DjRELnmoz6zHXJruOH2JRRHe1N
	p4Jrr3f3KzgX/tv24dev8+jtJvIe56CzOoeB+RqusK/I6LNimKy1b1wiF1F/y4NG3Lvjsg
	Qn9lqqeEWH4P52As/lEZ9LHeG7pG9VM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789559600;
	b=YtHBsui7hqOCZiwNct/jRJzfBCvuAH4U6T+h59Rlv6lcV5X3c5fkS838ZyT2ZrZWJrS8k/
	tXlNpvvTKGXtHDoCC4UmKienvxUdSjxVcD7SWzvYuzh0p4PyAvh2FiMBOGWFrSMR/czYQ4
	El5+E/UuQ5KNsDgbo6RjtKv2RrDhZLU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=N0hikTVZ;
	spf=pass (imf22.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.201.63 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DYBwkp72ulVUxF0lRt6GqSmvMXRJuEgchxPBZV/zlmhjFqryWjHMaYuPxYbaNEDnO4QJks2xk+oc9A9ndQr7YmFhO+NF055lbq0zdSj7NpghIoxft6CM/AwqJ7STor8ECQhDY863hoe56iY7QuqZIM97lBhkNg9SKq29wTy0wiw9s++TkF7B6zFbMvVBVvAj/NHVbEdLlWLM/j+NR67vn8g1Sf8o1NlAPy0TEbNNyCy1Scgj8r+Hx+P3GGavevg7NfeXesR9NPGOyW00QWVftoO1tpwsv1sSCEh+B2fV6elySji0oGLYe95aAyYxHDKAy98SCchlKTkzpkdaqKFjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SY2PXIfdH4gQPL2ZLaN4rYd0hBg60SV0RgUb/GbX15c=;
 b=ULct9KQj2LIhQ/B/hbSpdfU0x2GV/D2bWqLj/X1urkO5IZ0QSHU71OHI17z+INNJnIJzalFrcBRmNvkI7J2m8/GrbMcJbOGYdS5XqTEaDe7YB+O8bx/yGrGa6r+QfHZ9ZqVLOYQe6uxFVPIJJOGdeJODKbpCiEYmTQuh2qpVenYQ4dwIXHgF2O08hMAMEwzoPi2ZqHkDTq+pqTHCMrdXTz/Rh40AmQzwbMjU2ifmLIFtGmRI9Y/GuJEVSIfzmNeVnAKMaT3wKva1auS9TFNtbhGKSl76LJCT4cwmNI25BkNiMdgtbOSeJX3HJDfl46BTm/Jl0Ko7zFWyWEY4XohYUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SY2PXIfdH4gQPL2ZLaN4rYd0hBg60SV0RgUb/GbX15c=;
 b=N0hikTVZLLlKQRQ9LljQNzVBYbzKHH0cYxZSKI6Hs7pNoviNSEjKHhzWdLDlHjsbn73c0xoZU6VRevsCcGmPydi7mrdoPBzv5blnhya4oMO67gLF4YjYQYkks0qMDyMH3CTQuolNJzfUJ/MBaLhFG8bA5Ui6P5aQl5qA7zDvPmg=
Received: from CH2PR02CA0009.namprd02.prod.outlook.com (2603:10b6:610:4e::19)
 by DS6PR12MB152050.namprd12.prod.outlook.com (2603:10b6:8:410::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 11:53:13 +0000
Received: from CH2PEPF0000013B.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::6f) by CH2PR02CA0009.outlook.office365.com
 (2603:10b6:610:4e::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:53:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF0000013B.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:53:13 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:52:49 -0500
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
Subject: [RFC PATCH kernel 01/17] pci/dma/tsm: Call disable DMA bus hook on cleanup
Date: Wed, 16 Sep 2026 21:51:41 +1000
Message-ID: <20260916115159.1938195-2-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF0000013B:EE_|DS6PR12MB152050:EE_
X-MS-Office365-Filtering-Correlation-Id: c368b172-fea0-475e-27fd-08df13e91646
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|36860700016|376014|7416014|32650700020|11063799006|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	lTbYfoL+zluMIQcZMX9c7spGZjQpXCynFv3y/cznROcYIxht8DJBw5ZLo8zGEnnTVHWw2qAb7J2BwF5bOjDhq2N7DkQjd+elST2JCWUXpyO/R7ixu/Y59GDjQCR/uX8ZJ+hoCcjGzuqzxqwPZXIA6Hk7NfEDjKLWbuLEDawfl+W/8sniBWPuDo0SLKRlToGBM4tAHn3wgj4XNq50zxnhK9OWU+/Uz7JOxe0eq8qmeAsPXaKRemotGofnQnu8ao7ULnXSqcvYntuzx9WaCWFn78Y/xe3xyWBxlXjnLOeKMRPYU8Awk5LhRYyxlO8X4icA6IA0TovktSJsx89DNS2jZ+rz2QQocNbqmXHIPUjolM7ehwfHWGGircyk9GCfbwD5P/dinhquBfDUpmQOaBvDs/hVTZdaGTRt4GjnIM16Z0Qh9iKRtXw83BfMmVUMpUWdhLJDb4aAgV/tvLtChQNrN/M3QS+2TyYtxV4Mr6aAhHGRBzZZ9WhPAwr2MBDMzjUvo/C9cItn9SfcwirGV8FnAJQ8SrGXwK/w3dUgRGcXKqar2Hycqq4M/oDb1C4fmeZKQ/PM0JxtOO3H6wDkXhq7aF/cV6gI7TNZEN09Ydt6mnEzfpGmAI96cLvtJ8/t5fmTuHmALW6bARpQlwaLinJNEk+/A9eLsr+jqbuksFvGyT8YqV17Z36rwxQPVGoerdCHYcA8GGykuJuX3HK9WyMQSg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(36860700016)(376014)(7416014)(32650700020)(11063799006)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	8Car1z4HpXq9pf9mgugQAiDX2M+RvASwLDL9yQIeM+kN/l86aDUJkLlLhXbA7h5FyKBkYdpkEvfnzFtAY1ypdABOLbjCcnRxFBKj2AqHYp3MJJkkxZp84M9m9JgKaBp3rXD4byWsdFprofXiibB3C/Aqe5xf/4+mDSyGncGAsfcoYA69DAfAmCeT0Weetem3fMELGDOK5EChaoFW5WWc17UwY4vkz4nFMdZngDqMXJiDZL4Jz7mkbzgsggHXldh7RY6AEc9zJSlma77wuBATEvSpwK5DjBoSX/o2xKHp1XmL2zF2qZ3AVtfjXHVaJg3js5x2DOxzUGU7365U9zN119sIeHjs9Wk0BELZkps29710E9Z5yecIj4dG6BrhgdrlFzWsRus8rYj7S96/IwFvQzh7ArrzAIHx3s8UCRtb/sMfMykBapwtCYQpoVQ3QXGs
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:53:13.1361
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c368b172-fea0-475e-27fd-08df13e91646
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF0000013B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS6PR12MB152050
X-Stat-Signature: bo4wsud5fiq4swuxy1oqi4db68t1mfiu
X-Rspam-User: 
X-Rspamd-Queue-Id: D8D28C0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789559599-757883
X-HE-Meta: U2FsdGVkX18MZ0SFZb+NuPqaJvlzXSySeLcQQrrEt+lAwp8DMpDDPdn5wgDVIdPe6I6t7eqybO1CA/Z4HON4wQ6EWw1IBIFtI3iQEt5RCeg8njHzYdvHVvit80iCd2xQWw1d+dCWoN/GPeMr8vFFpXQGrhYL9Pk1kI0GviKlTVMXF3MmU6EbYln0C4JAS9wA6q2HV/VkSp/D2/htqarrPlwif8WXsyMkP5kjGtLtZwa4eledfafXPZ1g5OHPqkJzT3CdFS7hWhGOmPbbC/6QZRXQBzd44OwSl7jhwlMx+okgoQ9NhZYxzsLMO6Erl7dBxxKybLd9Yop3GCZuf4CxoDT1UMYH6pKDNN5pDSM9fUMLZkU0W7nDhwKh3dkBJV+K5hGtCHjAJyJaVOWyZonaUxIp0z+xkiXlJShTfGCtmRZl+rA5hs7Bj3nYzgiWFkFgvjfGIZ3tyCrqUPDWGmBUgWBDJr0uMe8A8GfmlAyNo0g0a2gAogqLpZ3MZROvVPzSpGWn4NQgmL+7NQ4LJnFVmqXzAZRK7vwugtASJAMJWkdrKedVCUxfJ5e4yk0LKV5Llj2da4wTtGMPbxvFAGXv2fi4Z55Sw5abQ16I1XcOTB8AouXVlN4xYeHib0kLfX66odzHwTlEBoWu75fhlZewIAM3oSybifviclnwz6jRED34bnaEtW5BPJesHh2uNf3yvzeDNyJ/N4aQd5pBvBtdi6cQNmE2VVguhrY+gGMFDKHM2X6S85Q5AK2k/wZOx4sCfM3r4ScIoMJ+BXvUTyugGQeSjGFG+aAfMjspTwpKaz8UvTeAB+6RQJhgD/wGXdNT4bxTdnkd0RbcjfyVsYXJWNfk/L+x11qN8xKDRKvpfCeAiX/9NFGh224ujrXf/Af6Xq87EJ9g/HqDVsUWMcemqo0fOjmY9/NSdvLJJpJENePJbN7Iqb6e9eceP962xv2fkknclZ2b8wM2hUv+L1P
 HZKBL5XG
 RM8cSMnmGJENTd7y8qyJGfJlTJy7Rl4pfrCegD1WYAVdYlbT5+ZXPfrWyVjBuuncWSAVsNu16VCi4XWqCiR8RnIbfIorCAQPSK9CldysE5B+FDPA9efeKSIHH5hgY9iefciztYStpbxLr5P+y9L48Xdn35X2up5UhXzO6m+sehUPI0QvWHzFLwP2bdLziZYIcf16aJkxkzmBemHAM2rq7J5scg7XR84fLcoseJV/YQtQcwgnr1rNvzmvVcTlD+HN0BZ4WLch/GmeP4h+UI5eiI3RIu8//M4+BsD67TngTMHNZVg8bgxESlKe0mRV/q9LB2gdZDB58Lc+/2Ri82ZwY6pG3tIktib4rhJGKDvKtBb+tmw8XM/K8G/2g7cCn5pvP1BHRocviHqvhjTG6KZ+/4x5wCsvMoZEXH1EiO92DpFswqhd81KricwdvESrXnb7tSMyxY7hzck3CtAbbpUXvdrHzh73TXrFLjf0y6XGoHtNP4AKrx4GEK8xVodDMC3qGjh66TRG6Ll8Btjix65KsIKUgMEXqfJw9Qx/t8t7CkY0nImqfJzbfE/Kt5SBkX7oqyEXoih0cYmC0Yd1xOkK5bINwar8ZKGuPo7SfFhkHDzJQJir0iv6K72vNvzVuZMQllUXoAJwENYZ4YRIXRSUO0BaD+w5ERJQ0fGqQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since XXXX ("PCI, device core: Add private memory access for DEVICE_TRUST_TCB")
the TSM subsystem relies on the PCI subsystem to ask the TSM to enable
DMA.

That misses teardown path to disable DMA, add it now.

Fixes: XXXX ("PCI, device core: Add private memory access for DEVICE_TRUST_TCB")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

Squash into "PCI, device core: Add private memory access for
DEVICE_TRUST_TCB"?
---
 drivers/pci/pci-driver.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a036f3d7e6d5..633926b55da6 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -1739,6 +1739,9 @@ static void pci_dma_cleanup(struct device *dev)
 
 	if (!driver->driver_managed_dma)
 		iommu_device_unuse_default_domain(dev);
+
+	if (device_tcb_trusted(dev))
+		pci_tsm_disable_dma(to_pci_dev(dev));
 }
 
 /*
-- 
2.55.0


