Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD646C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B026B00A4; Wed, 16 Sep 2026 07:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E02276B00A5; Wed, 16 Sep 2026 07:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCA846B00A6; Wed, 16 Sep 2026 07:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEEF26B00A4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:58:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1ABA7160690
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:58:19 +0000 (UTC)
X-FDA: 85219477518.07.4FA695C
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012011.outbound.protection.outlook.com [40.107.200.11])
	by imf11.hostedemail.com (Postfix) with ESMTP id 10DFC40005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:58:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=aotvzm2t;
	spf=pass (imf11.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.107.200.11 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789559896;
	b=vgrZUGWqx9aOdHOfpgCvvG6mJ1N4DeS7DX/MUHbkmTzAqS7yBSU8qc8+NCJHBepGkacKBa
	a2voALL5pCRmU2iJKGSGtLstUgotIes051b+6m0zCU8vb0LOdm52+j6HvdHVCoXVXJLmBl
	L38M5Yg9xQukY17BELgoCV6OK1OaZSc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=aotvzm2t;
	spf=pass (imf11.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.107.200.11 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789559896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGeG5UViy26eddcMIwAbSGGeZIQdkW5rZ6uT6XlTNXE=;
	b=2ifAjMb3HV08/R5FtHDGdRSB91WV1pqFhu3Rzt9Z7vcZ2gCYRuJc6r/d32AwvBIqFBm3vD
	wfHpTTsj1rg3o2uX9FbC73G9vVec4M+D7HRCHrdfD7ZVe4nYxOzyMhJHdZsF9oCf9AcrpF
	7EcGDDeCPkqGzrDwB5V3evzmywI5rDo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NV6s6jceu/ZS4M3BPMMEluiazfdQPZuri/VXYG8FSfB8pF5RfGvI8kksyzvJh1cHeYt/hP8szR5ie159qViXlrh1SY9lGvhbu5dmTufyXT3sseJQWm7Pdf9lFLEPolNneGtHOSsAPz4dOhG6k/04XMJPxpRhi9RsKQf3/j3tDAfdc19utjvRzEEeURrMmYgdZniUX5L0/5du+sMEWpdDNq6CLuMA59yRjSJj0pM+vNWjCwJbkNMtb1QXcm20uIZu1+OR/cVOiIBt8lHb4RHA0/BWbFA+9vC5le/fcjxzpBZVjIBGuncX6s9Q7e+GYDbnsSjglIrstaxnFVONN1UZ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UGeG5UViy26eddcMIwAbSGGeZIQdkW5rZ6uT6XlTNXE=;
 b=HgyaDOT99pzp46n9b4AsZkH2yBSKUG7QnzEUnYQY0d3JALrsGd4BQ175ZVfWaB/fAeQ3azTOA777KO3QyiJ5nGvIBZRctI3Hp01RwZB9MNObD9LC7jJVcXxkY6lelR683vnAao7EKvyM0D4ReLoDRIbMe3Ekd0Nkg4RWOIsH1FY7yC4XxFFuVD2NKkwwudPbVFDQEqFTF/Bc/jUMIl9FO0CF5+3XIGlczkJQlvL5frQ5W3h4UJvtcjvEG8TGICB7pcmiH/yVrQx9dlHzfO0x8Iz5iNKpRFxp1+uDRBVqWag6GTNRJ6yGjoPbFC5SZuiYOZXU4birCAg/yPJNAnXP0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UGeG5UViy26eddcMIwAbSGGeZIQdkW5rZ6uT6XlTNXE=;
 b=aotvzm2txPYMiNm37GYVZcv7nTGw4HjZldkCMfRHaQJlMMOX8qvwe9G9Rz8pgbK8ERMmHtcJhBs2ICDnRYXhQVvOv4OufpOw4mDEkaGW7vo6JlWmN2HF9VO8f/8dOBcSdgi3YXa9aQOmeqMyLY0xEDySEcjlpqVkM671GOxBUhY=
Received: from DS7PR07CA0016.namprd07.prod.outlook.com (2603:10b6:5:3af::18)
 by IA0PPF6E99B1BC1.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd1) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 11:58:11 +0000
Received: from BN1PEPF00018548.namprd05.prod.outlook.com
 (2603:10b6:5:3af:cafe::24) by DS7PR07CA0016.outlook.office365.com
 (2603:10b6:5:3af::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 11:58:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF00018548.mail.protection.outlook.com (10.167.248.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:58:10 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:57:46 -0500
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
Subject: [RFC PATCH kernel 09/17] dma/swiotlb: Force shared DMA for allocatios from SWIOTLB
Date: Wed, 16 Sep 2026 21:51:49 +1000
Message-ID: <20260916115159.1938195-10-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00018548:EE_|IA0PPF6E99B1BC1:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c3e0d42-9d65-43b7-68d7-08df13e9c79b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|82310400026|7416014|32650700020|23010399003|36860700016|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	+GpeRrECie8z1D9ALNbaVkKslqe0K7+pREljkkHFWG+hTQaCiH4sIZT/MbiDR9MWL2T4L5pH8K9j6eQ0rPFIDktbKEJDVnSuavSQT1pE2jVKFVNcZeVDNx1QdN1qe+tQrVTtPfXe1thRZYFJl66uOmMmrKN4p4eZq3FxsS3dfsvFDmVKMuVncBGmBZ94WsHCgoFBLUSKVBOURsbaEoFJmN8osu4Q5Jdzr1Mlybij83EhAXICHeMQfZj3qDJW7raZ3TZvvNacja2NlGXKd/3Udyegr4sgtV/CWHzM+NlBC01JII9KMW+8CgIE6ADRG+b2l/ytc5sLzQGRZiHwgwS3WhB1kBADN6PSYOGmLGrvc03O66rDzvj9zt5ccDEaVWWDp4xN0o1v19z9238kLIaG3TFeJLDYOimtILWx9CEXluW4aDKRpNacF2iPneJboZ4b3NI7C885/y8n7nl/rlX3G8joXfFxsNYKvidXEIee3uDf67C9SEXZObD9PDP4YcmLGAJHNTwGORAMq61qBVd5+9on8qBAR2rWkQICNPkOEJKhdBxGAn3NLNCfoOJBbFOzvOWrGMQafUoTEqoIND74/TgH5zaPBLDC8XM1WgWm13XRATv7g8ynhEC9qN6OZMH1vv2U9Kf6jd3kloorCsRTL9A6DGb7AAJXpHbFlYdR7xiwANKrXsl/T/0jj9plvAsnMc4wMsrTs6HOkDX2GX7gVQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(82310400026)(7416014)(32650700020)(23010399003)(36860700016)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	N+QQCCWsHa7bqeHcyE9nTBdDa+bifDbun1axL/Jp+ouegH1jwRNDqGgZk9TnDMM0NkTrcFPDnH+mykQQ0BMSQxgY6hyIlPAIwKpGIAO+SlfWu1uY4kl2tIJYheErrmKT6AiYJLReu57IKXwx/n1iCmnQ/1sNR6Qx9rksJF+r7pSItlxQmXGUdxLCcqTz478u3FI20fTD5nJ7nyf37O4NpIHYbh3xpHya/3WGmaKBccRqqiF3pB0m10k//KIaBQcKbtyc1vuVtbYs5hu5q1T8AzJnqKlTvvdi8qtlFANfaGhlnhwnJA1w32iuN27yG1NExvnhRTcGPXtxAlggmbrjRRMf0VoeT0wKRj6X5ZhXvBNi9Egyrep6YAHcKOkokxnLq1riiT/QoWOY9upXNI8KANCUiE8B4qkM6/pLLtlzFqVPEro4k8b8NJ5zTk6WRHf0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:58:10.6516
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c3e0d42-9d65-43b7-68d7-08df13e9c79b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00018548.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF6E99B1BC1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10DFC40005
X-Stat-Signature: mp5phfbnz3ftuk6d3a78uf6u4b67h8ou
X-HE-Tag: 1789559895-624173
X-HE-Meta: U2FsdGVkX189Chy9/5gRA5GbKKhQxcY8gdJBB9crjHbuGFctqkrUIvLBLtlxfQ+VwZUg0EhC7cx+hFYaqCDhshk7w2URpPrDCBcR+SS3GcDpw57x/kC6qKlLaMDnX/yL3KO/AqujbzpvvgKynuVWbwn6XlNR9q3LQAtkPWEiLmw7VGed0CnmSVelQLOcF8LB+T2Y8NLFg04vYxXTu0VdhCB+PaBujHqeEGTlfSK0Kj6QvLtgaeLqcRuEVQTaMZqpY2pPD0SE0kaGDO6mHkmPJHvUcK7ne3BD0seEnm1hngVL+b1c/lgHRyGX76WVgcQLsD3Ldipa//7eXwcDXyMsqQoPqDS9YGNKxNOsGXB7UVwAWV6NW7UYxouCuVxL5woy+ycQ12LJiKEVn/ZNWWkBJPMC6i5V45aoyUk/LkXZixKeQZHw0dEYE0IbCg07kSdFTcKBwz5AoxEyowIl6rgixXmqzCDFFGZQDxO5/akNKEDnUgFeFOO8hd4QsZpkPmwoiHBOaAkidTsPlMPqrNQfpPLuCAmoXv3byVQIqMRSiSld97lmD8s05dh8trvSC6Si8BzatJMCZBO9iFb1Iyu50YoD0TSTUCQDG1HOhO5SKJUPAsQolNUjyYr3CXJCw/3Se2fctwvRezmQpgQqF+6CIxLJ/5vKeci1g7xYugJqgtNxbxXmfNIo4umNmS764yEisaojd18QEDOkCIj+qHxomNQbAU1nFq+KwvSPDKwVtMDgkbAw//u1VmrltpC3RJiMM089OZzrQ1EJK+1J5Mps9dQ+/KoAvmvATZxDEIM3iIffcxF6B7lDnxJV/bOmYiAfADB034Q6SQ290bZjz5mXbqTwFhBnTa/3z46mmkNY+UgPGOXBfvaG1Rtg971Tpr3LUIWSgVIJVNT6jXKm4AE5a41ijizMiO53K+yd3ODYQSQKXrT8ah6CsTzojVS9M/D7TtlX1wLcPWumEtR/kfC
 QoxFVFpg
 KAz4xCslgqSMKw1PFkotHtg3DSxr6jha53NI8v0EpnVUuuOTSgUC8YftXgOE0gEOu/LI+xA1ainH0j3JNS50+GF3slK3X+6DjYIIvnyEbjDus9SZob6QOF1g6ebvhnPzaZ8paLuhvXGkTeXwuN+JXcOO33sgvFm4obiXqHhoi+W6TC3VpGLBuyHKng6E7hXfRUgmIy20MuExVy4hvkgk7CNBO+28IOgzFFfM1qpqXOpWrc4gbFYHAwSyO6HNkypWxm/r3s3f5ebTLv1dD4sPpZFywCjaaEcDewQAoPtvVf4COHIzD2FvcFY4yBd+W7dt+ful9mwyswmxFghGkk7+BpmUPlNWiu2fv9neoXL1wMRAEmMA4oO0vxONNz6/xgNSY+sNnnG44HyjM5LLa8sPMyUyRXpIt9ZHh00JJW+9vtb4zwAb1pEE6efkEzTKJq1PnwX7ndfAkb430pyJTr824WGechbLvosj8AwMUTaMKvUmYGw1swIrjebOzc7MJVD9PiQh64p8YQNNLYCcLrWlT2ckd2Bf+4kri1eJ4KUFhoM19+Siy8RJIg4f6zMgVYffkCQWp0/BTBOtF6C4yJCqJYcd9O7w+2gyNM0eQFK7GQv9uVd7DapJlLSZ+gROmm8rFUDZIK5DWHK9b/Zc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SWIOTLB allocations are always decrypted but the DMA layer is unaware
of those and will miss to adjust the DMA handle.

Force __DMA_ATTR_ALLOC_CC_SHARED if SWIOTLB is used for memory allocations.

This will be exploited by AMD SEV guest vTOM feature where DMA handles
of shared memory have some high bit set (not to be confused with the
Cbit).

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 kernel/dma/direct.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index da665ca22d5c..dacf513d45fd 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -273,13 +273,14 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	}
 
 	if (is_swiotlb_for_alloc(dev)) {
-		page = dma_direct_alloc_swiotlb(dev, size, attrs);
+		page = dma_direct_alloc_swiotlb(dev, size, attrs | __DMA_ATTR_ALLOC_CC_SHARED);
 		if (page) {
 			/*
 			 * swiotlb allocations comes from pool already marked
 			 * decrypted
 			 */
 			mark_mem_decrypt = false;
+			attrs |= __DMA_ATTR_ALLOC_CC_SHARED;
 			goto setup_page;
 		}
 		return NULL;
-- 
2.55.0


