Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46ABFC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 467F56B0088; Wed, 16 Sep 2026 07:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43F686B00A6; Wed, 16 Sep 2026 07:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3203E6B00A7; Wed, 16 Sep 2026 07:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDBE96B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:58:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84BC01406BC
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:58:56 +0000 (UTC)
X-FDA: 85219479072.15.0ACDDAC
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012016.outbound.protection.outlook.com [52.101.43.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5B50D14000A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:58:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="KNHRx1/u";
	spf=pass (imf26.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 52.101.43.16 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789559933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uN3TtTwM+bwTehqyvzEhtWdo/9tbU5sGc+GO4ttJXns=;
	b=7F+JlyThBiOTp4bsLYmX8RSoleVDbGblC4LKQXRZ/+au4GsbulS4KkyP+YlsOBr9YCk2kY
	DEQsGvZT6BZ/U0Qb5FMuSZ5m73wlnspHLAHEtkW9UArr63YSZ42EwhXpu1EZTwjCQKAfDl
	fG/+S1cl00gJ+g4zVkpLLi/Bs/dC8JI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="KNHRx1/u";
	spf=pass (imf26.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 52.101.43.16 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789559933;
	b=0HMaPI4EzEMkaKWiR5XMZ/DahZ4MxYB7uDPtE2PWENJD3Br4fTGZa9VuYoeyYuuFWfk3S6
	66dbKj9wu2VCof+rFFMFFiVJVzFyyBiNqRstLXu2Au2EwiuoZqTG9D7gUZb2HDg08CCKNk
	JfARhGVViZH8s1+mUdKImeD5on5O+Zo=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=seol/ZRYlk9PRV/AE/0igGP4M475B8bTrWiYjR7Z5NVQdKgQ8Snt2Iybu43auxQTLklLTDj+/czXGPucm0VRfzcuHZnrtWsnzt9fa564LGCuzyXYB2wboIBU0JiXD2tXbkUw4vznR7ZJdYwkqjhER+nCBLKlLXXLD77GbCUVxF55cBM98geU4KyUAbObpDwGwPlX7OUjvnyQ/ErVPhnYwe35LYF2lgl5JKmTc092duqdYS/xqXIz44O5hNx1ujjZtaQrsdxqobZsO6EZPAGhyMogjMHX3oHd0JDOqY35plSg988uH9TBWL1tdirm3lgBThESwB5WN07dH7u6fQsegQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uN3TtTwM+bwTehqyvzEhtWdo/9tbU5sGc+GO4ttJXns=;
 b=XlTCsuXfh6cbbhbZNEiVEITWSHaHxkZnjq0bBeBSI5S9g72kOw6XGGLeK+K4EWewm32H7VlSEd4nr9nUOHdWNETpfESYKdGCr2rAYiTPH207To88lFcUGwNjCbRT5kfB/PfJJXyvT9Em+8pJ3/kxdg7x61bbkpD3JT9YQtyIVXR5ilk5oujw/aNZ0uubZrZfPpO/N0oLeVTV7PmLE9i4C+BeEl2/6Slm/wxe2mDrFRJf9rojTe83MvrKt2jeWQn8nrZyd2tWkH35wRnCkyEjLproJIrPBR1lP5u2c2UEo9YQu/qPilPg/lGoa9Pjy7GmzZv5ehcBcrlNaEp9KYwiZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uN3TtTwM+bwTehqyvzEhtWdo/9tbU5sGc+GO4ttJXns=;
 b=KNHRx1/uIQrLP/p1OqbUtpLgVwCk7UVtvYLpPsa2/jtKdsR4Vjqm3gQm0t1vp4EhK906ZcAgkkSaNp5GN9OT1xi2nBN7sRrVepy7neCrEzBcLk6mtscazitXsKE123nz5ng2gI1C17BYkbYjzOdNlcc5U03fFb1OlKx8D9A4k+g=
Received: from BN9PR03CA0782.namprd03.prod.outlook.com (2603:10b6:408:13f::7)
 by SJ2PR12MB8111.namprd12.prod.outlook.com (2603:10b6:a03:4fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.11; Wed, 16 Sep
 2026 11:58:47 +0000
Received: from BN1PEPF0001854A.namprd05.prod.outlook.com
 (2603:10b6:408:13f:cafe::37) by BN9PR03CA0782.outlook.office365.com
 (2603:10b6:408:13f::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:58:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0001854A.mail.protection.outlook.com (10.167.248.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:58:46 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:58:23 -0500
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
	<ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, Dan Williams
	<dan.j.williams@intel.com>
Subject: [RFC PATCH kernel 10/17] x86, dma: Allow accepted devices to map private memory
Date: Wed, 16 Sep 2026 21:51:50 +1000
Message-ID: <20260916115159.1938195-11-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854A:EE_|SJ2PR12MB8111:EE_
X-MS-Office365-Filtering-Correlation-Id: c49f70c9-81ce-478f-dac0-08df13e9dd27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|36860700016|7416014|82310400026|32650700020|11063799006|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	1bJ49a9trfumDwoyn9MewgHhdhH/vcO7H1vXItEBAR2GcC7Oz87Mn2l/avJzWfkRSChnShOjFI7hXwvbMP4FfIal/XfkCyAQO06jw07jp3OKH8Fv14GY6YOHfTvUSlnHRxfsxtpJfmrCwkr9GnKg5GXYolHH8kdXZuVQtH+PnHROr5jB+rRKZUZkw+jMKi6EB5sMFZve0dHPB2LyTXPZfcqQSwRzRnMa9JPAmrYk6BmjpPlY/zGIZMRL4ogIwgoaoBWgr2X3fJECn8xofhkS/dPlWE1gm4LGMM32AysHf5mzmXFzDVjFx/CzkJpupwN0nH8TVL9pWKTlpIbIQXDjaLx+FkjqAMfx3fzEL7R4946H7Hyse1Woyyf1+rbrQX6IFOCMqIQA75eNFofO3sWviWdOBrpPfr3KmGpt74PsgqnSShJAKfS1rBPn1YyDMZkLp8IRElEVCiFMgecxLvI7J7mj2+8+4z5F1jrSmVH0Pm+vouATGQfb5p4qKwJd5g31NtCxqwjL3sFapbwogiTa2xbrqJegMhJ+hMbhT1MYg0hV+Xn4w7KKLhnAON+dlxkAOXrgjAYJhDrg6VqYsK3x1ZmsmutuwzCbubbgs27aDBSaTnor7fzVXyE4z3gIdRZrtCPFmFIGs1Lxt9GqNBFoPs+7N5a4otqlL9gf7mHsWsJ4fS9vrcN8OM8srKTIfIU3IRe3qhs521WNeSWpaqmQQg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(36860700016)(7416014)(82310400026)(32650700020)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	qK/f3bcE1ASam6x2JuApZeSzxgwli4lwEhb+EPtO5GlbcvqWi2n0k+nCmOHidWa9c57wxnSKyVw6rpTH9uNaDmg3oJNXlIBXvGR1R/KFN/gP+3nnPsanWwrd57y/UdARYtTQx0oclZLQ0BGPI91gFjNkAlX5ujD1fxxig+qClAg8/i1f9m8YX9y28sjNZGmBEwP33TPzxrpHnN+hFi9AJNhz+zn1fgjuz4xCrtBlZIiJKBNAa55ix5MqPrc/Hp0hNMUb1/YlmECGfzThwtN1CwLiUVLLQlBKO1fcb1JIi5Qgv+5uPUz+SYTP5gl8NeH5pRlAUwiBM8wDq7PFX6NC37IA+rMpo1xfWlWcVjunL8MiE56oFApW110XZtgRGjDSOijBETZIzUKDFueWDJ8SMcnlpUO0wFZzFrYSoIR3W1JjxXGiUODmzMgF+4duPdAm
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:58:46.8022
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c49f70c9-81ce-478f-dac0-08df13e9dd27
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8111
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5B50D14000A
X-Stat-Signature: swu1oh87g6gptb8iy73e9ncr9upcfb4x
X-Rspam-User: 
X-HE-Tag: 1789559933-800044
X-HE-Meta: U2FsdGVkX19oFGmuxILVR8kvzhXXkFl8dzAkaysrc+gU9dv2P9Ox3iIXIkZTg8gvBK1CR92zGmE7XxUQHQfcINXY/JDtbyHYji+FaQL52jdFIshXObuevksxFzi2oC1b5hfRLMOSTF43H0EsNacis8+6/5T5U7uZPgMLUsrBc0XznfZzFcCwbRwhuxCgTuQ4enADVhUnrmmGPbFiOESE/vR5xSppNQOpEr3H+N/w00UjaNXLCrIcOfHihjmgQ+DaKak5Ppi8wZcjSFKMqdYeTEn3MeQZDfone/jO/I9GxRgtkoO1Zb21keqkMZIw6i+EhYu3AAbs3zc75wdn6IXVhOM24FDs1fwgRBTOvTuYLc62JfCpeOuh2rTdpOL/3rhrwZ8+tUaV8q3C1tawWqqHnyZAC+oeVSImwNitKQVugBqFJfZglFj+VmAmV/U+GAwGdfGiF5JqKSgCC9iQJntJBF25YZOBc16GepREfyG0xC9APwy98Y6Z2x1ZXPT9gfw3KrXFl8up5L7hs/Z0k09CHnCstJOfyAnIy/j7a+K06FohaQEMCq6cAF+I8MVIme1PB1AOw5uoiXWfEXbskZe0hJ5qTXcbxJJFg5/EaSvmonRna8FIywASjJEVBkmVhj1R7VGb7a02tEvo/b0hBURKc2di5PpGqQM/ewRasTCAVFPwvNC0/YGN9jxt11tsE9LQ08kPTAT02bLEQz3ZXhdD/IFcMrcl7Lg0nyY8Nh7G2HLngjGz7TNrjZI+ulzmsg9Gv45BMeOy3u4XtqyNMpegBjCUehSv5MtiCdmuECpmTHur3tBusu2moVb5OpCING3bJEGszr+aFa3RX2TWEzcpwJfhJqWwxiNY61E4q6PoLcgAcdUOWP8TRhk3dJRQVrkxZLT7kluep7IsvRgdZnx0FPNPlrAk+R7KOlQH+WCmeu7FTzuhCIWMj8Pvm/QmS2l6Pqzu9RnRgU1bRRyo+ke
 fAQkDQEN
 TlMOh2POBcsN3gew/rShK2Jc+H8P6XW1YevEDJJsTxdZzbj4GkTEHGTvtk5FrFh02XzmgLcp+/OZyZuc3oDvuo9uRdqOfRQeo3lBAbi3eOdghDDXzGgM7U0DcRF+pwlayO6EotYo+59/KLI6xMFXGPZjPqdgYilmT4TVuC7jPMu9NkGn4wc9gvhBKYTya7n2kTpMNKQpxgmaWirTQ2WIsn4IOjlopMYgS96noGPNqy/KuXp8eOAa0W4XIwMsHDdpcCUwAyR8kSHVWTe9oXc5nwtR2UiC7prDN3QpkQ+BHhCrIuonQHRPJdn6pkkMrHHvYKf1yfMW6/fYrjil5Thgl3ju4x/PKlhEkj7OQ2pXNifRXa2OQYfX7qRzFADePqDw9+5KzFCerGTLiTUVEtIbsqbeJhAVetcg+N1np41GERoHtrHpB8zx2Zxy9+TDaUhXFyUuA3E9qHX1xcs3q/aqqy7OXEpjk9NbTifHiEA+fppoBg77mLIXI4SgsJNFDU2Uqlly0MygxhjkcCjkDywVuvem871G55PGceKYp61Ep70sjggzi684bfbuek4BKvcVe/Zumcc5MEO/3TYNeYD2J19cGzshSVSE64bt66XFrUj1hpJ5hjo1IgR9f2DLiIGFZy0ROcxOmgSrG8NoyM00XSOPIOGISYJAOLLODcjYHHW5ByAWcjo5gqsxcosZHJPZeRRB08r2F8bMq5V9pw1e+6//Y1eKoC/6cixxfhmq6YmDLtphkmjAmCcEP9bkyAxrL1R9LcptieXCmhmiZw2X1saBmz8lzVrBTNg+34ZeG+nPAI4Zopb9jlgor1ziFqfegvpR5IoYBiEC0RJQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dan Williams <dan.j.williams@intel.com>

With the arrival of "accepted" devices, devices that have been enabled to
DMA to private encrypted memory, coherent DMA allocation no longer requires
page conversion. Update force_dma_unencrypted() to skip accepted devices.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
[aik: re-added device_cc_accepted()]
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/mm/mem_encrypt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 95bae74fdab2..805800ddbd79 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -20,10 +20,11 @@
 bool force_dma_unencrypted(struct device *dev)
 {
 	/*
-	 * For SEV, all DMA must be to unencrypted addresses.
+	 * Require unencrypted DMA unless the device has been "accepted",
+	 * enabled by a TSM driver to DMA to private encrypted memory.
 	 */
 	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
-		return true;
+		return !__device_cc_accepted(dev);
 
 	/*
 	 * For SME, all DMA must be to unencrypted addresses if the
-- 
2.55.0


