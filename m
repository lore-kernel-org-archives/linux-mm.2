Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20243C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155426B009F; Wed, 16 Sep 2026 07:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12C746B00A0; Wed, 16 Sep 2026 07:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BD16B00A1; Wed, 16 Sep 2026 07:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDBFE6B009F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:55:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F1861A06D3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:55:59 +0000 (UTC)
X-FDA: 85219471638.12.3F48A5E
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012023.outbound.protection.outlook.com [40.93.195.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0154320007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:55:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=msinSkf7;
	spf=pass (imf31.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.195.23 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789559756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v0t8hG0A53D6hUuYqrsRHML1F/umVz5zdX/nWs1UwOo=;
	b=D/uwFE+iotAazoSxB6UdaIZX7rx04wmW3oC8AxRByDs08zuHksMQCuuC1p8hcy65muWSsU
	OCdWUIMHbmD+uMzgBKuhE8fd0ytn7FzuoIrZP0l34ylitVF/qg9a3v/Yx1CrxeXcUtTdoa
	pWyl16jDcn2LDv74Rbb53VSqq1NJW64=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789559756;
	b=LcOXtygFy47wWGfeIe3Hz+jUhJsboNl/Nirlh2XYaK0u08JVLjRKydE6GmkRESAOs6WsOV
	mloAsw9b2lW3MTLlfrA1ZJQATy91EEHtQLBa19caQ5+KfXr7BqOEvfj1kjXtgzmfkdhsaw
	E/IvoZzPWhxU+kfYIX0/MWNG21oLeas=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=msinSkf7;
	spf=pass (imf31.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.195.23 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LQfhMPYkhD6AnR3K8tdXf9QINnpy/KelrwnnDKg8EXRBdKD5of7YfSCTWdYSnWOsr0I1VYtFD35pu4D2udoh2lwT7n+aWyHtcfLM8eiK+6MMLJnbiGXsAZ7g7/b0RZhuEjRnuK9qZFWawxSaB5ABeeYkymtRbvub0kuSGYcZTZgc5f3w7ZudNJye3VGGqZA9mRWofXcfvs3d4xoGVYv2yTkAKTz1JQV9yJsp9oX3ehDxru2HNYJAxnvuUe0rYlpjD87snl2N5POoCnMxVWdVdvi7fUSG3k9jm9EzBv/bfLH2Ck+YIwo5A3A52Y2CtCPdKsvHIjB8rUBJ7Bw4x84O/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v0t8hG0A53D6hUuYqrsRHML1F/umVz5zdX/nWs1UwOo=;
 b=EzdtJjB28ig+7GsTxViWodfdnFK6WufDnsBFEiO1UwZIo17Tcz25r3ejAPYwQJydY57Nl1h9wYB4IiARz1qyJs6NuD1klpbFoeDR6qXIke2xYhkWTyHALBr9cRTlrCBYbsI2lHbqgWF4N1b3eJuz/4sPgOqFRtYUUoa/of0m3KFZOqnWcohj1slFfaYBXPk8vLMsuhaUmvIAEmUZ/q6QU8sMW7QOnJdvFbm/nywajodTdM7mTFc49uPK0VyZqNanscCphpSWAE9S7XW7dsVbq/w1PnSnOSNgjq4/1cTW9hh3tdO7CQepZlV1RLYebeXM44aOtDLRC09UVng/PrzDQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0t8hG0A53D6hUuYqrsRHML1F/umVz5zdX/nWs1UwOo=;
 b=msinSkf7Cpw75oiMTS2aiOWLwlb2KTeD6N02xI3NUB3lkqrXiCYf5cqgrZhvjcor9u0jz7IU2WTVgRWhwjRHkYRzThUKIqa2E80Ewfzu+4aQDo+fC6yLyJjOVWT/8zBaB8ULBRJoVWrIKVs7xr2fHRlUDzE85kFEG7NdNyGUS7o=
Received: from IA1P220CA0022.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:464::11)
 by PH8PR12MB7027.namprd12.prod.outlook.com (2603:10b6:510:1be::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Wed, 16 Sep
 2026 11:55:44 +0000
Received: from BN1PEPF0001854A.namprd05.prod.outlook.com
 (2603:10b6:208:464:cafe::29) by IA1P220CA0022.outlook.office365.com
 (2603:10b6:208:464::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:55:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0001854A.mail.protection.outlook.com (10.167.248.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:55:44 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:55:20 -0500
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
Subject: [RFC PATCH kernel 05/17] tsm-core: Register nevertheless
Date: Wed, 16 Sep 2026 21:51:45 +1000
Message-ID: <20260916115159.1938195-6-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854A:EE_|PH8PR12MB7027:EE_
X-MS-Office365-Filtering-Correlation-Id: f0628022-b809-4ddf-e51b-08df13e9703a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|36860700016|376014|32650700020|7416014|82310400026|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	7y+YJ5Z+OyMGOf2iurea6gWtIJXfcQNlJ0b9e0e2ih6oXqh9RVnwVlOKmPJLGMLMS6FZcGH4V6tgofrJMpnmvNmT3QePntJclBhTe4VKupQBAuiwbR9H79UATphkzqpFzkWlblZDDX9yazeeCUCNS5MpFkOetKOx02UbALu3b9eO5owPfy4OLOxFlFqV/o3vkI+bDZ8K7SDC05IwrAtkvFCQc5+HxLHYR/rpE+fg3arpfN+l8PnhQhB1b8uA/v7XsYGtzl1PKpYg2dVhJb1/nI5NGKqoKTMcPdCiu7vxkN84812ys0WVum587F9iiI05Eeu2pW/kTv0tkeZ0UFE1oS/gaDC+dxrummeYBtKnQon0zn+8VOMQSxAUrDajnM/ZA1b/+KaOCO1dlMauuUh3Om0Uz3TaS8Bjptwi0eOetEq8KZfzm32mXgwFsxjn/3x5v7nDS7Pwq6+ao5rhwXx9DgiIs+c04mY3+QYreV/B1j6V833CBCe9RDV3XCArkxJVka7fmYIE/hIftnRsQ19pRInVx/zRmYRnLEMVHorNHCIbSliJkLdTV6ioxSP1hU+nx4u2h7OEGQcbl7BYvtWHmTUpJydOz6Gr77oCqF4/sUyr/c5HERIvY/RPq1CQKe4suHTwchv99EAEG9HM54+eUwc5mstMh0e3kVG8B2bQxKjgvrTXE9XJjUQoVE1hbhdLidU1hUqNS/UcIjNiaYtHEg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(36860700016)(376014)(32650700020)(7416014)(82310400026)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	7gfBfw3cwrGt/CVo84j1pCRkyKykdOlikms4I9xrPxtU7a2fA0pHJxQRzxTWM+6b8a0csSjVoT8mKS6Fh5S4p3/YacTgzDsLs29wKHI/s+zpKWUZ9S53dJFYpvBTT8StmCj/fj7zbUsH6N3b3bTHkmBQGnkn/4VaLDkXK1yxeo1yCrpPf2lmJw5/PllWcJJ1K/31arILyJ5yLqnpqII+99EtP/UBjAfpsm3m91xjaz98+aj2kvIGKlc37TDCjygAK12BGRa0qB1t6adk5ILZ5QyUIz9UON+TI362rNKmbMy3uhfCJSbGQeiK/Z6JtG/alh0EOQsQ1KHtKtn0fEg+o8r4RyTZSwI8qaVd+PCCgOLfSASKmbQA3ZdpRcL0VYNSVfc+YyIvcuBrdeIIq8yhycKS3ykvz2dFWZDSJIsRnWvuMUrENy0ph0XkYNEq2Oau
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:55:44.0564
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0628022-b809-4ddf-e51b-08df13e9703a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7027
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wjfemcynx3rt5uugn3uzzs3966bs5unq
X-Rspamd-Queue-Id: 0154320007
X-HE-Tag: 1789559755-507730
X-HE-Meta: U2FsdGVkX18oCnMkqaT7vlwUNW8IvPsmBt8rrmi/rCHesysFyFNEM5xWy522SnB6xbBEguKX5ZT16ix9fdVbgICcQutbwbuJLdCNQ3yd28WSy3g8R6Ce70adKLk54PtH6zfRAq1FjmUaYXW84ajD/09SLBU31qKhhduff4dFk2TXfonYPSagQFsIvG1NZjQJ37f7d/BIV/7ozOab/QPwyHA/gyvoyfJTLNE/y57mBjRwat+eYqEOGh2WUFSvaY8r1DliwiX2yprrDOpAU/8sI6QbaQCKSmOgaRlm8B6S8NILpHsOFF/PfCgX3TRiVrSh1m+qMWBcNCor5PWFZYAWoW/isTtrBohh7lhxMyo8j4UC4Nm7kQV9lG2Xa4VxWn/CfJTM+KU17N82YOZLQ8eo0EhPuuNemgzmOEANjsElSm8kCM/AQwTFt1uL/O639yTuqbz1YvXEpCU+kgfBVJd25eBYuwQexzagrjKUvFcjx3dGzup0p35xBmduWo20I/CNrjhDTqsM1KO+JL6ym2XEiJ1cmc7IdYRq+P35Gnu56zLhexgMGabKiB0jPGEt+C9xtu0DLGo6qb3P+9TdOvflAKxoq+Ag5H2fHAUHJpDrLSfn9T9P837pv3FY3iEAQU0kcm8HG/OmXiWrsrPwD3gwoI8PyrfXN76xs671nJRs1KXwuUn8OXy13mCQZfSGECQELrRA47s696vVgblPhrwdFxMeySIhPOSy0PH06RrfF87em5qltVKmzvFYJgLoQr01kAk48+X3uXq6d0rOxA2RabUYsCIFiZBzkDESrcURpM4QGmfjvUmObhmuQyCYfToQDpHo46HzFC0ZPIHeCojfVbL/2sq7R1dFaydyBS4S0YhfYn5Y2XbQX7R880kyuPatMduQJScxqkT8uBI7RHWeQHweGHZG+n/Mo/lytjKp1bBHjqiY7YZyf+8WduZDp3c/OPT2YyLpUqF5fe55lWk
 FMBe3lWe
 zJX7QEzvGyGyDtvVimBHeGlQaNUwxBUMJnbqkfLZH4szcKTSNgy0cU+IxpGXg6hjBUDP0aUlcO55+fFa3Ivrjrh30+dC7PqR1vCPAj6DibxC4Qmc4YxqdavGRKBJKTHh90V6W+MxINgXhAewbuKE6vUVzUCSvC/S62BZuLYOLGLJha2Q/XOMk4XM6cKbdfRzmAey27PccpER8LLCjJgeHHUzSHSkf1hzvemYnfRo8AQpn+PHqPTt+7Jg21obwi4Vd/kckcpy7UFbxiqCGx7YXY5y+3ENx809wzFu07tZSv+eWGGL2GSxsfkmko+DqY1gpjATolifjAQo+oUGpIEk2B+WsSYhAoK8wDtP+0AIz12i3TVfKZAWHagwPYXfIQt/zGom9AA8myGODz1uohN/h8CD9Q9zu8B/vVgvc2A5uyR5J1eytfe8lVSKLYNQfEQN+RGaHph10qdhWreO1t/ApGtdRDPSyUEJ+gW7vPbEqO936TQ6RTvfvz5mHvhn5wr2c0tRn9UbO/Vm2yXDWiutmUzpGPCQZH0hOkPWYdidmkjuifP2MxFteW3YTuRZifl2MtTxFmixdrZxbl/FVuX1ncG8lAU5yuGaV8j8NeqB0qZRzcqRqf+YKGKcQnoAOPrLlVQpdchTar9v8J2A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When this and platform TSM are built-in, there is no way to control
the init order other than alphabetical.

Force the class init when a TSM platform driver registers itself.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---

The alternative is making it a subsys_init() and drop tsm_exit().
---
 drivers/virt/coco/tsm-core.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/virt/coco/tsm-core.c b/drivers/virt/coco/tsm-core.c
index 0843b77c6549..accee6a5cba8 100644
--- a/drivers/virt/coco/tsm-core.c
+++ b/drivers/virt/coco/tsm-core.c
@@ -51,6 +51,7 @@ static const struct attribute_group *tsm_pci_groups[] = {
 };
 
 static void tsm_release(struct device *);
+static bool tsm_class_registered;
 static const struct class tsm_class = {
 	.name		= "tsm",
 	.dev_release	= tsm_release,
@@ -58,6 +59,14 @@ static const struct class tsm_class = {
 };
 static DEFINE_IDA(tsm_ida);
 
+static int tsm_class_init(void)
+{
+	int ret = class_register(&tsm_class);
+
+	tsm_class_registered = ret == 0;
+	return ret;
+}
+
 static int match_id(struct device *dev, const void *data)
 {
 	struct tsm_dev *tsm_dev = container_of(dev, struct tsm_dev, dev);
@@ -82,6 +91,9 @@ static struct tsm_dev *alloc_tsm_dev(struct device *parent)
 
 	struct tsm_dev *tsm_dev __free(kfree) =
 		kzalloc_obj(*tsm_dev);
+
+	tsm_class_init();
+
 	if (!tsm_dev)
 		return ERR_PTR(-ENOMEM);
 
@@ -254,12 +266,14 @@ static void tsm_release(struct device *dev)
 
 static int __init tsm_init(void)
 {
-	return class_register(&tsm_class);
+	return tsm_class_init();
 }
 module_init(tsm_init)
 
 static void __exit tsm_exit(void)
 {
+	if (!tsm_class_registered)
+		return;
 	class_unregister(&tsm_class);
 	xa_destroy(&tsm_ide_streams);
 }
-- 
2.55.0


