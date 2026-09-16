Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C371AC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:54:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3686B0096; Wed, 16 Sep 2026 07:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA506B0098; Wed, 16 Sep 2026 07:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9D66B0099; Wed, 16 Sep 2026 07:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57B5F6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:54:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 542561406E1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:54:05 +0000 (UTC)
X-FDA: 85219466850.08.E4B2477
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013011.outbound.protection.outlook.com [40.93.196.11])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4980E1C0005
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:54:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fUWyDB4d;
	spf=pass (imf20.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.196.11 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789559642;
	b=MT8FWovnP68S/pBD/Lcq7Psh4DaRvQEES+rUq6+muu2MG1Rb3UGfYgcaGD7RjpFrreqD5K
	P/Xj6nwTMVA0s7fijk0DkrCZMJAqb/Q0INo4ht9UO6S0v5IvItqHZhvZGuLeEXVWYEjz3r
	pU9M/SsR700dGHXYZlFcUykDAPef5+Y=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=fUWyDB4d;
	spf=pass (imf20.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.196.11 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789559642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdXMPNC37iRVDCMXKNEKZ2ifmpdSeHtP/V7TZt/SDC8=;
	b=xucKTh5SUHTwg5Wts78jYygs7Dl8p7/v8SngIT9A3rOdlGaRUAkqxylfFzshDTWCnM3tmL
	XSG+xse1bYvelMCTQfQMcgkqIIIc9hcSo5dMK9qIbZ5F0YZ694VDT7jtxQC1YTKAtRfSjK
	CDwIcY7sBcyG1jPS0uZ3gUtveOpWxVg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VTzZkWUgFSGTYEdYEZpPOMaVLEQhmQGq7QBUMCbWzotJQ27rAtQmjDP+9McdJ3+Qz/sUzSQQjoEminnXngDsnhUJLlmos9CTi9EOAycBw3LsUI+zk3luYdwCLlE+Oe7i+JYlp2ZQ14EDq4im4zIzlwZSdkGOSWlwn2CLRDnBfcKqUrE85+Vpfz/lUKwLFpYRmN3IsBcsTUPU7RDHs26AlbBReDMo7zlSilA6XdxPsEmUjOsJ9BjIhgNMQ7YcmrlnoW31AYHYVzKdK2MnDutinTdg19jp+cYj5iqut87RGiOdLEHW98ZsbKc93pfB3xGks/qX24tShdXW/8QwrsEmcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdXMPNC37iRVDCMXKNEKZ2ifmpdSeHtP/V7TZt/SDC8=;
 b=Fe+LOHyb0f3R9Z0gTpvD88qAkXG6x4cnFREewCHQdG4dkhPWd65F27J0tmrFme+Pj8b7EvY9Ah38aOWwEVXKzeI7NsVBKxTw+RqBShVu20bRGfJLBgcMUI6CJIzS7pfFAX19ogoeC4kRD8ddrwPJ0gxbMEQBE1XJlIOAqIiRrZf92UAd8DVrGVBwVDbmzDPd1F6jBZSUc1JC2ZXBtsRM5n7mmDHgTE9TB5K3Ch17IfAYpmnPTUk20P50+CFRkOFzvR5PsJIF5KavfoU+KbFr/zuPtUs19Ot/k0oMD5Z5PTQbaHrjjM5qCOzl1L87SNMqYSplg1BH8YuVyrECFZm+MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xdXMPNC37iRVDCMXKNEKZ2ifmpdSeHtP/V7TZt/SDC8=;
 b=fUWyDB4dKMWU3pNQM64UZ9R1E/1jXAdN/6P/dqK4FcokxpkI+zEkkScVU2SfrKYX32Vo9B8woMqS4wyNWcYEpzYehswUcnIGfjkhWsaszP7Jkdgt7lWY6ANDt4/u0I2m5bxDYCjb+gap9sRWg6r/Xii3Tt1llCKdN/HIt+bP8fs=
Received: from CH2PR14CA0052.namprd14.prod.outlook.com (2603:10b6:610:56::32)
 by CY5PR12MB6250.namprd12.prod.outlook.com (2603:10b6:930:22::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 11:53:49 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::45) by CH2PR14CA0052.outlook.office365.com
 (2603:10b6:610:56::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 11:53:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:53:49 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:53:26 -0500
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
Subject: [RFC PATCH kernel 02/17] pci/tsm: Fix stale comment about TDI report range start
Date: Wed, 16 Sep 2026 21:51:42 +1000
Message-ID: <20260916115159.1938195-3-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|CY5PR12MB6250:EE_
X-MS-Office365-Filtering-Correlation-Id: 368ef6c3-44c2-4fa8-6d72-08df13e92c0e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|32650700020|36860700016|7416014|82310400026|376014|23010399003|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	ty7fn9JOkvoiU24GPVZ/rmNQytrpaC2dhfMBHPhdzS00TZxP9WBKw5etuOyR9/ZWu2XQfWBGWkSaF7tmlvVKeZVMvFiZkVZMV4lOH00MqJdO9voSL4Z68EVgz+FY7R2pGsVQXtFvURVAFu3q8u+dl2exxvwB4eVgYe7crcTdoV8lr4hd6eN6HnmO51qX7eyzMRPLXQXQNpURKRaHOF99KIKMRwPmtBUm8LcvkLDBJiroyx0MJkncpp/0my7FU0IeQifDlirZuH0gXAkKO+gAG4rN5DP0MqzLs0MQvLlj0h6ezg+H7sF2QWO/jlQe8YyxBU4kitrVIvjdpTkls/SMRn1Ct6sKSCcHdHNzUeaf4cJFSEHdTirh/hwtT3jZv83FslMpXDnVmgKLD42MZqWNV7/fhFliSMJmd/KwGx7MD/i5gAUminPfEZJpsqoA/LtMtA2aeOCPpy2vdix3tbhjTEnASLqkdwmlM1tE3izZ6lEYqRwHCMepvS355O5VwM5KrvZTyuWEWSkAxSwuk96DQY1xxl/Mztr7El8q3VdfsPesBTpZpg869xG0kx9Sb3vMBVcI64R0d6UN+AkUINSbNwiCwk1oRSqtT1yx4UK0CpSEK3b2ZSK1WkVzcVSFu+JFKuS9aivdEPiiJ4QjM1bBZ/Nimxhbpia/x+La9XIjb+wOKtwQzkEnCmwTnYNLIKN1LLzOs8Ia79FoXUsN8zAgpw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(32650700020)(36860700016)(7416014)(82310400026)(376014)(23010399003)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1EwaPy9VnUgtfRgZAzstYDIfAgiTyXKXlbJfuTIyKOwSN5Prp96/PGgZjfYrQj9CaYl+G7vqsaWOQ7FjVnIRoOEruayIAheJjkTsvujYuDKm3S69YPRakGGFruhoAQfg0sSGIyUf3X4ekMEq/dKreWVi2JuGOz+xy4UzjtJYPwmKb4TdsKkd5b/9XT/YuYhcEbT5JWftmCA0MB/ESbaAT0fma4wtJw6R/G8hNQMqCdAbxjQIUDXCTbd/73hpaexsaV8I1m5M11Ady04jbTZNDw1S2tNDcqky+Ufo0UenqmrqC0cVkZaRmr3LOy4h4AIHj1e6qnbhY8WVC5YGb2ZgrAmw/V1aB93n1bLO4VB1r+zul35eBo4BtftZbYjuuVXsTS9AtyCrVvVX7Y9yJ8LxKnHqEtHB2RNplComEIpjTGDwUzE/bRbIoJZwe3qv6nwP
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:53:49.6782
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 368ef6c3-44c2-4fa8-6d72-08df13e92c0e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6250
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4980E1C0005
X-Rspam-User: 
X-Stat-Signature: 6n8efedcdt78jwcgaeo3rn37ytqry5fc
X-HE-Tag: 1789559642-209580
X-HE-Meta: U2FsdGVkX1+rr2ugYc4zmJLMmoErobZpA/mav0nJu/PIadp9k9/S8APEqQA7JxCUGjhHiLtLrGbW5iPg6t79/na8Cj6TYFxeWwTHdum+tGjjctxk0wzfsmdyOn76CY3v9MKeGCAZj4LBvNOCPCT3rKTFPYQ4aBfnnZey273gyVbAAGHvD/FTgwokGf8rdSa4/8qGKXq/BbIGX9OArun4ommTqx7ZLZxUgTR2QFdY6H2+u3xhP+yxI3UPn4mHdYRhlnGhtbZ68HyKGusrod/jnjHM7cu8c3Q/RjRRflQBQvoKukeOWkMYZOfCi2Ybqc4Qc7SSwLqak359cz+wU2m7qVHPgFo9GHCt9nVnlnXFwFzkXsbNttHHr7QHFj9yNRJBQDE1p1AnRVjeNB2Oi4t4PG4c92pLUxdD3t9WGeDEAzZ9MpFlN3Ov1gZ6yUeUKeA8gNrDksuF1+kBJIRczGuXQg1Vy30rgCiNMLY05MRpWaTiKujmEyQ6IecY82/K0UTCuqJb3UD8xY7daOnbXXWJX+nTauDelFzYrVwc7H4tLT3kmT9z/V41tfhFGt3RGXW6CuD+5dFU2epJgO+CHR7GtpPQQ0vWvDl4t2eLAEks9ByiNoABoR5odlixxcUBHej7gItO9A24PMqs1Mj0DB4wtsH3QXj6Jy+WAf/FLuTKQrd0wNZAifrtkWLToCjpfONj1K25YlzR+rzksp5Ul23KbS2F8aSqicCxUwsdYgclNpLHDusiMnE2snz/HQomaSSYHupXENsqGi5HZYALdAo1J8aj9G1LyymZi152eGIIv6gWMO6s7EWkqzPa7tXkgGmEnL3F5pvNlag5k/rgWosCmvYArDWwyjz3Lq6xO7lveOI1iPNrzWUH5AMKADD2SA6uR6V+R1lcrIizecZxU79B3r4TRKDc6mBXefQt521aoxVJ4kxo5a9hLEAlXvl4NYncVrFJZmtryoB6iNsMm7u
 66WoEF2W
 7SQxLsNkFKtl2vLRJZN2HXPlclXV6r7d0y1DaouTcpVqLYyZKO4d6sNHR3AWZ/h5oSvPfSIt182mjMMBy0lIuMyb7bddjvWMoaiVT6jWxhT3N+b8VAiH8PRsmqLfPzg5ACJJVJ0S747i35aazH7BQXIKNrfSSUP8q93n4gkvqSAYkKmwyYjYVoBq1iFlKB2T6XeI5ouiK82TD8NXkMpLnuur66JRyVKvnZnqS6TJb2fxio9zdNS76F5BahoUPlAGdbBDQ9IfijxTkB/bPVwfCubjPyTF4JO6Vw1nfieYkRKystCGBgwU9I9nSJE2IYAUyiCqfbaDbRK0tyt9UL172GWFAHtvT4YhflC2XOAkLsARsdEucD68VEgojj5HBM535jX8sffS3eckrOpueHBbotuy86K10WzkBFfeGqExc2z+iHUNhPh322Rhq6xifrozwnrXkUun/AREd1TiumnTskL3u+jForCeEhIgxZ2QaZoBB4KioZ9p8mR7B7q14lkLSnGDuBgs+/DQzaYMYent4JaOewlNZercYNIdWRo8kHb1YYG38UNc5Q4AeS315fwZAyEoV5Y4FeKiFHx68ivyfJ92k25tI6AgTgw3aij04Pw+x2fM/VIl1viWIuT+Yf6Ml3BR29Hv/c+/M0ZY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PCIe spec r6 and later defines the MMIO range start in 4K units which
was not the intention. The upcoming change makes it a byte address.
The structure is already fixed to match the new definition but the comment
is stale, fix it.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/pci/tsm/core.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index 9ac216ad896d..2a18be5be56e 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -623,7 +623,6 @@ EXPORT_SYMBOL_GPL(pci_tsm_mmio_teardown);
 #define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_IS_UPDATABLE BIT(3)
 #define PCI_TSM_DEVIF_REPORT_MMIO_ATTR_RANGE_ID GENMASK(31, 16)
 
-/* An interface report 'pfn' is 4K in size */
 struct pci_tsm_devif_mmio {
 	__le64 phys;
 	__le32 nr_pfns;
-- 
2.55.0


