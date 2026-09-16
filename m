Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4FAAC982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 11:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8BA66B008C; Wed, 16 Sep 2026 07:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63266B0092; Wed, 16 Sep 2026 07:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2B0A6B00A1; Wed, 16 Sep 2026 07:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A06206B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 07:56:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 17ED716067F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:56:33 +0000 (UTC)
X-FDA: 85219473066.28.F8CB433
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013039.outbound.protection.outlook.com [40.93.196.39])
	by imf13.hostedemail.com (Postfix) with ESMTP id F3E1F20003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:56:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=byrgDqtZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789559790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCqYaRgrO+KLB88pTWh3Gi1rxQIXg5tUAStrI07396M=;
	b=54pOxW5GUka32s1DKrfpiHn7yRiDruclBha8T7fdlRAEfzDX6CClXgPJUJYhcXqAoXHaV/
	NLgZ9kSYT0kV8RkhjQjKeJzd2WV3VdMejJ0fWmv6MUxuo48Uy70dR9mk2MTDSxcinPjum3
	j+l3VhEhojgTEVFoPLaenEuuhgEEdGk=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=byrgDqtZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.196.39 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789559790;
	b=c6SCqD79KlqohbgerufMT8IMfWMfMXTor+7k4W4VIaHbJIvArKTuUuZCmlOdCDiVODl/sA
	DSD8juLUo7Dy0PV7UvwT0s1y/BXXbdeGMDSYTYibrGgLzbFAiZvYnwlVcDfiKs5eOOnkqR
	z2/PN6gw6LvsuMvryxPmVSfpcruJ5V4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eu1rDpedbFlRmafQwHimTL2zpjqI6OnKvSPg9Cgt3hYuHfkU5jan9BFL4f/5mMj3e1+zKYrTfV2MP3UYyf6FT72J9oWO8ZLYglPsg+r42fpOkuqYAuQKs0bDNH5ueBumA5sJTkCwigmxX94BtGcTbmFh/v2U7uK02QUn5Qr/Xk6dCy9B4c+JZMWlBHBOaD4kmqhOpfniyJyYR9lyv0iy+a4cod7BhPM3ump9xYae6KltF4oHYrEDlGNxvNvB0/ZnNrekrCm116hWpFDVNZKDa66HPK9eMGcisBx8qiyhZYUq4cUrAHFOHWLwPXNpGJbUvfgKL21bq6fMtjScR5JXdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aCqYaRgrO+KLB88pTWh3Gi1rxQIXg5tUAStrI07396M=;
 b=UW1C31Q3ZMe5lzylroEIRDdlQWpL33tgWCFhwZ+FbScLUjm3lwEtx98dUT3nACRentiZuJKrlhHUAuor1f/Ugd6PQENRoMEQ2vF+e5LQjmYBYF/vjRmvqbYhCfzY5woJZWeS0gPa5f6Ft10ECJIzsRHn83wIcy+T7Y2m3JY7kUrykEoPqoeyw0wlJoMCSC47azoxh8Xu84CFqXUJOdj6N7KDzxLJcBC6AMb+39Vp9hCstbDyhREZt/H0+SdrIiC6YVRtdWfOQv4/4hrjFR9EhsqJfvZL5hIs0TbrANeqjvuzcRubAMK2g9CyeASLdJk4nEEfGzcmHUZwbMpVy+CC8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aCqYaRgrO+KLB88pTWh3Gi1rxQIXg5tUAStrI07396M=;
 b=byrgDqtZMilsSHENNMrnd3FZ6bJr030oMSRaGwqHUgCAurG+6q/KmZmZjvtsA/b4dD9IBYDwi66eYFBFv39PDsWU/ktcC5AIcn9r3O4VuQ8pGm/T6YmQ4AlOwiWlQ8s8plOk2r6Hc/OP5fpYe9ODvS+fi/e2DnX+ml01usyI/DM=
Received: from BN9PR03CA0220.namprd03.prod.outlook.com (2603:10b6:408:f8::15)
 by BL3PR12MB6572.namprd12.prod.outlook.com (2603:10b6:208:38f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 11:56:20 +0000
Received: from BN1PEPF0001854C.namprd05.prod.outlook.com
 (2603:10b6:408:f8:cafe::45) by BN9PR03CA0220.outlook.office365.com
 (2603:10b6:408:f8::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 11:56:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN1PEPF0001854C.mail.protection.outlook.com (10.167.248.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 11:56:20 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:55:57 -0500
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
Subject: [RFC PATCH kernel 06/17] x86/io/tsm: Allow mixed ioremap for shared+private BARs
Date: Wed, 16 Sep 2026 21:51:46 +1000
Message-ID: <20260916115159.1938195-7-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0001854C:EE_|BL3PR12MB6572:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fce5108-a749-4aae-aa96-08df13e98612
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|376014|32650700020|7416014|23010399003|82310400026|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	6BNZ2mu0j6dBjBOVar6cacjJVAtU+Ps0QvoB+UKPyfiXU0JmH6UJ3nG3n498jJiMjdGnOwpW7UBXYOtT44Poq/xKUtMHnotRE3puTY4NJ+O8CafJ7+HSBblgv3k/uwv9fPuz7JvZnsNR8qXlBPSgeQ9xzubjsJzvrQZiaNUnPlYQADHO3PjStIamA0JKZoREOrP+P+kpR2PXfo4VohaKyHZvIUsh65WgixlWDO+4e4peveBLQjvvGQN/O5wvQ6KN9oOsufipv1XvSNw7NgsTtpTDWZx2vah76oHoSXdsrZ54R0yPDPinCQ4BIxgqewcnMyN9HzxQtkLWzigy8nDKWSQAVP8O0HorWnb2STJwYEP/wFHlfZy2lBUirpszgx7yPUJoV+ba3iwvAQeaV9xoTgTWrvF9cnztobl5qtyTj+cabWqeXHL5uafvI7WbGGIPgg+xQ61T9id1rFDi20OVavrcHhNJUcuA4jlvLbjSaAdBVQTbhd5CCWKny28oephlhWhS8xvhRVCZj86K470/82FJihQatdvsP6zs/F+w6j71OIlOpKQqs8bFzvNVuQkLW3qD8zTcIojUo7Zd9mX0OFowXKBOV5m+vmuaNRyHzv6V1O0TkVAvA0TtGH40LvBtxw5mQJDejCz82szBtGtP+L+LQ0Ckq3+9An/Pq9HmwTS1qnfOHbdX42W9zuZAHTKx8uGTPJedP1hORo1+MFW+cQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(376014)(32650700020)(7416014)(23010399003)(82310400026)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5PrUQXodM/RpiDtbczG0PNLIWYOlbcHbPuTp2HvrSbS1YRU3oRAcjy53d6eJrT/DIqnNGJ6s7ddDqWIQ+0vGw0xO+7dhSgYuNvKdI7bkh8z5FNNNuoj60dyZ14zgPqaRReLGHqESwmB0AFK0325GqPKOjsGjjykn6ZiH6Onp2LeKKQcD8/IupxwkrskjpEFpGMFfvwDK/Nb5tp3Np8hbHe6YDFNDb3luVK+KBbpUPwvI1wafyYjlrws9LPZjYEopf8hNKZyntOR7AUqpGGDGrEgulfL9flLPiEHVtEmZlJAbsqYXdQi0Kd31InIG8AC5xbgmWRvs9osMt8JHGWo+sLi2IZqb9t+qBZMJgGfYaQZXrUR14BTe8N6NS8bbnxtZSSz9qgwMzR7ou45rKp4ej0QHU42hlrvYL5z/EuaBgM2DU6Dww07lxLiMN/yfePZ+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 11:56:20.7036
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fce5108-a749-4aae-aa96-08df13e98612
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0001854C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6572
X-Rspam-User: 
X-Stat-Signature: zjnajappdrjudpc9b6krrjyamwe5fz6m
X-Rspamd-Queue-Id: F3E1F20003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789559789-950325
X-HE-Meta: U2FsdGVkX1+8y7u5gWsejroWch6nEqmSgEyAm3Z9KzRtfXCNt8X25LzZZRb+RKsOzfIIWcJDyvuzAxENdj+7tvtp7+wFUXb4xiTlSmnV21CmOgbNpbVOry6rP2piZE4juMdGcI0/SOE/k5XhiYFrz/1NqZ2Vw/zGuU8CvFdHHDGWOf8Rf/OdKYcGFVrtYCbwlnBYNmvQQ1w6G9xyh67Jndmu/YQvqBYuNeCIgUQyFkLKzG5sHFIdydGRHyyip9w5sFEt16yuSyzqzEvANZUH8eOMpjToP40yGmk6xrA4RIwZpPRMawQXTdA+l+bnVGUhuNooYRR56J0jISNF9I6z4d7A4gAO14rMEDbaPGelwXIphUxJK5Nh+Ho/lRRCaWUzYZgLyFw6Y0GacQX38aLfljf32CU/bN7zVF9eZ0XffhOK3SNNPcsYmLOVE0EYLgP+5U5T1pL68+zg0vr2+CM6PLZZOfyj6jSJ+VYyCIwvuyeJrt4pdn5+Sxlhd+NLxGwCx0AFhSaCtPxChuu1CR0fZN8mSQyM9pekUXSRfgO5OLCmhF9U5Eqz6TvChLN3jxHXdAJRaoFKYKQyf+SJM4YTLEh9GbFjosOzOtoFeMzObvY0h6wIvI2soxsMmkj9gGNQlUsTOIv665yiEcS9bbja7CFOvePqBoYPI9udLqst61APWmY509QW0UpOmGO6jI80ux5f0Q5ksAynARGlvRiJ0hEhCGDM3iAeOdIh40VyqS+LbivyHq1tq+4ZQxMpbNqC3Terj+JAQyYsFYQlpR9XW9ztes63rfZ+Nxdg0ZBc0yP1+NRxTqWpXiO4yFV3IKbQuduEKOaiMjIydxpo46fPe8LkPSZ6f50R3InjGJOmohGjS5M4m665qGHMWKNVWLJCj2oRukxEvHg57TYyXIezfw3gVBqnr0dkERjao14oNUauvbro/QQuw9T9GdXHp6pU0/Dw26AiYZFa6z6jj1A
 kD6QICTb
 NWttamrYELpoYFmAOWr5wlVs+d0/ivlD5gyPZKA2N6rq9hpf87x9ThmU8jlCe14oTbxGdwD1Od4pX3bvCVIxSi9COFrSWwJHTmjqjNBtLrssg3OLzpVXy3xmcYDv2juBzREmF7J9WoCgNLsf55XIx1CwqyT55CixT9cq5mEzI41sNyeNf+7cEE57u9KmyyuxYZLN1R5fuXFvjnMTEIKhtFS9K2+udzLSGfrp+m1SGdHMIbONeRMDWx2vWUHC3UIKBhV/C96ErvURkzuBIibsF+iBSNUWoN6E4VBitYVJ4vPtEeW9QYnYt8/oBJdP9bHBOqPSY7oZ5uyusqN5Ay8ot3IrVL3HEv0DbmXTDBSfOi836SS97H8ikKwQfbAZArcT/W2zrVJgB/Gzf5iglFG/y09X22bm904inNNXDGW8xUMYCebjZYbPdj22hYzMu4rkF8X5XYDhLjiHzLPNvSi7KyB0ljguU2DJ56mcv3xcNW4sDO6vANrgfJgYKv7yMApNAVmcGSq5wTu9FCXRSwO390cyB5kccu22wFw/TYcTYz4xU7p2M8pIdY/Mr7V1IqRbgqHmN9SshmXh0tBaDcXfmANkUV3wEsxC93n2TjBk2K3kSlMT3DPbFEfiygsnf2kawIyK74CUcRNbPI+sStQ60cCK9eNTUy8DA72BsaFI+pAnA87s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A TDISP device advertises private MMIO ranges via a TDI report.
Upon transitioning to RUN, accesses to those must be made with
the encrypted bit set in a PTE.

A device can allow private access to a part of a BAR, for example,
MSIX BAR (when MSIX config is not locked or MSIX is emulated by the HV).

The existing __ioremap_caller() fails if not every single page has
the same protection in PTE and this breaks device drivers (usually
TDISP-unaware) calling pci_iomap() and such.

Adjust __ioremap_caller() to map such MMIO BAR in chunks.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 include/linux/io.h     |  8 +++
 include/linux/ioport.h |  3 +
 arch/x86/mm/ioremap.c  |  2 +-
 kernel/resource.c      | 63 ++++++++++++++++++++
 mm/ioremap.c           |  2 +-
 5 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/include/linux/io.h b/include/linux/io.h
index 0642c7ee41db..9f5d5928f30c 100644
--- a/include/linux/io.h
+++ b/include/linux/io.h
@@ -27,6 +27,8 @@ void __iowrite64_copy(void __iomem *to, const void *from, size_t count);
 #ifdef CONFIG_MMU
 int ioremap_page_range(unsigned long addr, unsigned long end,
 		       phys_addr_t phys_addr, pgprot_t prot);
+int ioremap_map_page_range(unsigned long vaddr, phys_addr_t phys_addr,
+			   unsigned long size, pgprot_t prot);
 int vmap_page_range(unsigned long addr, unsigned long end,
 		    phys_addr_t phys_addr, pgprot_t prot);
 #else
@@ -35,6 +37,12 @@ static inline int ioremap_page_range(unsigned long addr, unsigned long end,
 {
 	return 0;
 }
+static inline int ioremap_map_page_range(unsigned long vaddr,
+					 phys_addr_t phys_addr,
+					 unsigned long size, pgprot_t prot)
+{
+	return 0;
+}
 static inline int vmap_page_range(unsigned long addr, unsigned long end,
 				  phys_addr_t phys_addr, pgprot_t prot)
 {
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index 122f1eefb4b9..49d35b31f22d 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -444,8 +444,11 @@ walk_iomem_res_desc(unsigned long desc, unsigned long flags, u64 start, u64 end,
 		    void *arg, int (*func)(struct resource *, void *));
 extern int walk_soft_reserve_res(u64 start, u64 end, void *arg,
 				 int (*func)(struct resource *, void *));
+extern int walk_encrypted_mem_res(u64 start, u64 end, void *arg,
+				  int (*func)(struct resource *, void *));
 extern int
 region_intersects_soft_reserve(resource_size_t start, size_t size);
+extern int region_intersects_encrypted(resource_size_t start, size_t size);
 
 struct resource *devm_request_free_mem_region(struct device *dev,
 		struct resource *base, unsigned long size);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 12c8180ca1ba..976ce6d5cf70 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -298,7 +298,7 @@ __ioremap_caller(resource_size_t phys_addr, unsigned long size,
 	if (memtype_kernel_map_sync(phys_addr, size, pcm))
 		goto err_free_area;
 
-	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot))
+	if (ioremap_map_page_range(vaddr, phys_addr, size, prot))
 		goto err_free_area;
 
 	ret_addr = (void __iomem *) (vaddr + offset);
diff --git a/kernel/resource.c b/kernel/resource.c
index 1b9cf2244b3f..c575ed87d67a 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -26,6 +26,8 @@
 #include <linux/mm.h>
 #include <linux/mount.h>
 #include <linux/resource_ext.h>
+#include <linux/cc_platform.h>
+#include <linux/io.h>
 #include <uapi/linux/magic.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
@@ -713,6 +715,67 @@ int region_intersects_soft_reserve(resource_size_t start, size_t size)
 }
 EXPORT_SYMBOL_GPL(region_intersects_soft_reserve);
 
+/*
+ * Walk encrypted MMIO ranges registered for TDISP/TSM private device
+ * regions (see encrypted_iomem_resource).
+ */
+int walk_encrypted_mem_res(u64 start, u64 end, void *arg,
+			   int (*func)(struct resource *, void *))
+{
+	return walk_res_desc(&encrypted_iomem_resource, start, end,
+			     IORESOURCE_MEM, IORES_DESC_ENCRYPTED, arg, func);
+}
+EXPORT_SYMBOL_GPL(walk_encrypted_mem_res);
+
+int region_intersects_encrypted(resource_size_t start, size_t size)
+{
+	guard(read_lock)(&resource_lock);
+	return __region_intersects(&encrypted_iomem_resource, start, size,
+				   IORESOURCE_MEM, IORES_DESC_ENCRYPTED);
+}
+EXPORT_SYMBOL_GPL(region_intersects_encrypted);
+
+#ifdef CONFIG_MMU
+/*
+ * Map @size bytes at @vaddr to @phys_addr using @prot, splitting the mapping
+ * when TDISP/TSM has registered only part of the range in
+ * encrypted_iomem_resource and per-page encryption attributes are required.
+ */
+int ioremap_map_page_range(unsigned long vaddr, phys_addr_t phys_addr,
+			   unsigned long size, pgprot_t prot)
+{
+	if (!cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT) ||
+	    region_intersects_encrypted(phys_addr, size) == REGION_DISJOINT)
+		return ioremap_page_range(vaddr, vaddr + size, phys_addr, prot);
+
+	while (size) {
+		bool enc = region_intersects_encrypted(phys_addr, PAGE_SIZE) ==
+			   REGION_INTERSECTS;
+		unsigned long run = PAGE_SIZE;
+		pgprot_t run_prot = enc ? pgprot_encrypted(prot) : prot;
+
+		phys_addr += PAGE_SIZE;
+		vaddr += PAGE_SIZE;
+		size -= PAGE_SIZE;
+
+		while (size &&
+		       (region_intersects_encrypted(phys_addr, PAGE_SIZE) ==
+			REGION_INTERSECTS) == enc) {
+			run += PAGE_SIZE;
+			phys_addr += PAGE_SIZE;
+			vaddr += PAGE_SIZE;
+			size -= PAGE_SIZE;
+		}
+
+		if (vmap_page_range(vaddr - run, vaddr, phys_addr - run, run_prot))
+			return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ioremap_map_page_range);
+#endif /* CONFIG_MMU */
+
 void __weak arch_remove_reservations(struct resource *avail)
 {
 }
diff --git a/mm/ioremap.c b/mm/ioremap.c
index c36dd9f62fd5..ccf938628e55 100644
--- a/mm/ioremap.c
+++ b/mm/ioremap.c
@@ -40,7 +40,7 @@ void __iomem *generic_ioremap_prot(phys_addr_t phys_addr, size_t size,
 	vaddr = (unsigned long)area->addr;
 	area->phys_addr = phys_addr;
 
-	if (ioremap_page_range(vaddr, vaddr + size, phys_addr, prot)) {
+	if (ioremap_map_page_range(vaddr, phys_addr, size, prot)) {
 		free_vm_area(area);
 		return NULL;
 	}
-- 
2.55.0


