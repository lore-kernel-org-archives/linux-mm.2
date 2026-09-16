Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCD64C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECCBA6B00A9; Wed, 16 Sep 2026 08:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D7E6B00AA; Wed, 16 Sep 2026 08:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23FB6B00AB; Wed, 16 Sep 2026 08:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8C5E6B00A9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:00:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2B7DC1206E3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:00:24 +0000 (UTC)
X-FDA: 85219482768.15.E44ED14
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012034.outbound.protection.outlook.com [40.107.200.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 927C314001C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:00:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gl3xaf2Y;
	spf=pass (imf26.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.107.200.34 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789560021;
	b=SNCLBot5tHaJnAVuvqGUugFZ3ftgQeK86WeDl9U/Bml8g61mwaoeSitARdhlJ0PQBcumfK
	f/D5M7NRMGKZ1v0Ku2uz1FfJ4Kgf3bvr2qAJZrvN2i8vMND1LDX6u15H9ouFUixoMi7A/C
	tGpdRjEmXYB99lUOSqu5VoWfVmWzOfg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gl3xaf2Y;
	spf=pass (imf26.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.107.200.34 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaFnTLlUeuS15Vco6JUFNTtjEg2/GLK2yLIZqCLTaAk=;
	b=DVN7X5/MtzMWHYRKxDcecO3BazCPMJE6GT0KrpIHnV/vY3exrtw2BaTT5gyirwuM27TPv/
	XACaRf2T6fllSuPRjiEnO9d0P0F4alYcfd8TyMBPrc8NWD6yugkKkGScq1Oo+ffmAioJnX
	Mn8isBnhCgmcQ8PxHEAIJRCLD4ZRVW4=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOT7sVRXy9De2202CBbsIjMNa3wpE64zrj65FxGGKS7PGb1MplltqpoLeCUpGx7ERZpY3Wx3NAV/QLDD5ajZ8TWBhHAmA7svGZ0jRP+vm0EfeMRqzOra+gqEXc3wU2EUl3w5PL74Psv9aAjdKrMNFUdLmRVJkQK2/JK/tDQMJIp5RWvNbrsOmDMxwqf1AYrbxWIFO9Q6nLPhIlAHBFeZiskQzoJuvogtBFK//uDXAZC/DiazhNPFh9XmflxC3nO/YGV/6XeV9IWs6D0zAN0r07oXvJZZwudZ9ulmklLYQEAsk+qdJ/Qo0ulexhdhaCd/lK0XwXDFaXjI9mK24RPtWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jaFnTLlUeuS15Vco6JUFNTtjEg2/GLK2yLIZqCLTaAk=;
 b=Q5qrJsNAJXmzz0ze4iE6i1fEBUGJQFh0UxYftcksk8ufaz1yIDLcrj4GXAK8nACOLg6tFJdf36XWt0fiuVrvSDAcZVafTi+ehnmYjj/Bcc6GqwKJB0oncFHWsDbq+FKYYIVLek3mX2tJJhtqKAUChv3FCxISUBsAUFX4KWQw4+O+YaaDU2dxRiPqDCEHgUKL89cqNcuwbWD3oLQ5qPOjVAlgf7lgsqbw52wuZeaNyOWuVLUV5BeUYZvtR4ZH06sTqUsJchF4+DCIuIq/zDzCxVKC2Py6c7IvuS6xtZM5PncphGiKcCkKflcuw2KKxDCCQZ/KrxVKCadiD8iTS2wqng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jaFnTLlUeuS15Vco6JUFNTtjEg2/GLK2yLIZqCLTaAk=;
 b=gl3xaf2YW+xaUIdq/Ze4Vsnj1kQ2CrbCHsosjClYBGfqZKutdv3pYi+i/jzEWmd68FNLaEXIyXR//z2vbzRuO6R+38BRzH0IfFjoSr/u2P6BUTDTi5bwX8GkZ01py42Csy+noYDtShAmBDoL57gbb5TnjyLoMF0lpOHKJkgiW4U=
Received: from BY1P220CA0011.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::11)
 by MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 12:00:06 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::d) by BY1P220CA0011.outlook.office365.com
 (2603:10b6:a03:59d::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 12:00:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 12:00:04 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 06:59:40 -0500
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
Subject: [RFC PATCH kernel 12/17] coco/sev-guest: Allow multiple source files in the driver
Date: Wed, 16 Sep 2026 21:51:52 +1000
Message-ID: <20260916115159.1938195-13-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|MW6PR12MB8663:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b51706f-555c-417b-6072-08df13ea0b92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|32650700020|82310400026|376014|1800799024|7416014|36860700016|23010399003|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	c1h/v5dfyxtiJ0WMVLNUDUgDxQatd0LMYdCKEY7e04HynA36o8DyKva5ruSvgqLaYCZoACqFUTHJK34ToQWM2MCCBg8Kk7vj/2plyvqelPReb5cAchDM+rTgWz3R7+Bnn8ph2gDyR2gM1wOZ3eh96GmQgRBj+zLT5cv5IdSYd3m2550ol3Ju1H9Km4MeCRVLxS3P5tQG7Q6T60yUsavCTOXu+/lSdcNSXfH4XlPCpgcpdFxRyqXRxBfbCDZiWLw0jYPQBg+gnHcm43Ypv3xHiGWQZTrQCmEP5i4jtweCR3YCmnazEVmPJCF5QstAYvxEeM743M1roHVrc9DqPuzMr8zHM0+lYfjxrS1wZoed/qJt1s5IE2AwGFgZuW7dDZtT6kWHu/51GndcomO9IWD/jwWkOFsL7bzdnTa7mI57odOgfeKiGNW5KML1b9MMJHQlon4dZskVmWAL8Sz4TeZsfI2snrZQqZHw1VeqP6cNOd1+SAikuN0yICPz2mmXFbsY9kDso0V8ykYrmJaFLk+T0sI6wo9CqW8wOzY2zQE86bI3j0nzMoUhX/M92d3xvTibl5Q8beTHkpAFkouRueVl86YNLgpODk3wkrrQXf65BdnneQuNWY7Gj2PWopz3bSypTYcLY/pRErszp3XubjRa2THlRPuWrl2ob/Hd5ZjCxnrdU7d5A7UKCUOQWy0Tr3m4DZo2fK5268pMv5G9i3j5zA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(32650700020)(82310400026)(376014)(1800799024)(7416014)(36860700016)(23010399003)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mS/imRrmbpxps67qGJxsphoc6eABPi9uEQAis97tyVjMcE7n1lUTb6+nlr386lpHVT/77AfVBAUGjtAsAI5U9VXIwQoNQqyOCrtenVvuZ6eZw8IQ01EvVcJIJZKPAyUI4IO5d87YjfhcEbh3mwPSHX0ytq1np4FzH1zAlBJzgfTo8p0WT7ftEYpWH/8xtuWrky0lg7Vb96bVRK0Oeh6Z/Bqtz30YVY0Ax3IUkvh2HhjL40wS9DrhCJBLx7/jYYe/jKEXsV+a4EnUeg6An48phGGuN8HGBTtQ3lpe6CODT1Jd3R3JIsEO3VlQNWWwvtg/FD5FsLXAXzDKQGVzf+GeBuklrtxXE/UOq8e27ANdgmihgrEF0Zlccza6kUJgBTwzV1Cp83zG4TJU548hlWxppR2g/9S2jzp+mAiL2crSmfzp8SlYOzleDPsozfr+5czZ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 12:00:04.6040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b51706f-555c-417b-6072-08df13ea0b92
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8663
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 927C314001C
X-Stat-Signature: 9wxewnz9szyj67ryajihq7nqxxygwk3n
X-HE-Tag: 1789560018-352744
X-HE-Meta: U2FsdGVkX1/7JD3ii65yBg6LaeARgS/vU+VsElv2Aem9QLUB1rG4Q9ZIPmunWipe5h7ksG3nKh1bO5I9p55U5OWp96mRhSlt/3siOV3LLdnOOFJkLP6NPyVgER78hN9Dd1bdZvD4OFV+S63Nv3aC002G68ULSoFJSBmkhLsozJxX94e9Oz6vWqmys1+c8kQsUjuhuD4gfU0eAOVpVhBEvaLA9mWg25xPgkh97Shzm35Ftd7blQ57t4t+L6TFBpsVfJ9uRMh6TJQlgUyOzehcnb2aZgwPLg+WloZBbTdU94R1tVciHY3LNDFyUNIazy9os5uCKY1s6HJBSKD3ZtVrZGxxxk1PU2QVuJqCrQl539bwQWoIgkSu/lBnOb6nCkYYMMtDpR5zUy3VaZ9a3RhsfgnEtIzGYJ0ZOB+0I82TMu5so9dJRLcmcauVc9SHZNtaRRzwA4P7neDrALZfBF8hcmfseH3D9MZ8fok8sb74+3nTdMUAKW4IotE4xOtmbvzt6XlDQ3avefuYu3+SiJT6009OVU1Cm9YdcezmpwEFH1mQPQXG0gmceWmm0o8I7JElr/zVsRGv2nmZNoHBNfRyzIBEnh68UvFLvkgfFvTw6I9SQXUPigcDWFDk5FwooUo6r+rSODDoylC0F8A5QnIXF0vENhTqvg5D8kaONp5QfB9N2CHL7Jxvz/3JBZPHa8LCaceY2yie3Q6t0sKnHipcvxax2evV69TNKn3ztBel74jIpIt3f4UzI/hMhW3hvcpOU8157qTgDz0/NGj1rAMZ3XGDOqe6n7F0VXTLO9okppgGnC1fkT45inKcoxE34DV2YoxEAu0i4pz1Udfr0051cnEmXGdnqiuraVmootuL9aB5faTpw8Z043g9lnbyFI9IojjDiL49kve7Pb9bsO4LtDu7+1K3hIaxO+oPyva6ctbnJqB5SSnr7B2npLlMEGKJQV6DvzrI+rIbb+bt4yq
 xMdQkdCh
 LQNyCjl6OzON8Ao2CkYFwe6hY+akBC61y420czLO9U/Lu142Bz92/Ve+CzCm0C6oIcsR4dCidA9Jij31Np+qi3M9w/kuwkAJWae8VqdEgy8rJcDnJUvesHkl/mxWThOhPB0NYTT1hg1dGF6ZcvtszSdYedIB1X3PLxc2ffl9DYWj3jPuQaB70Pszc0vwrln7t2mEZo5kVVJsfaXhxhzpA2zpiRlV4q92A44EMcmb5ZieYQKbC6ZTN48tnaj0BeZp15Wx9WG4fAXqSLUueQoQlEwtT4sEaYek1RoI9nDbU5pButzJyG5f6Lq0jcEJv7ZJ2CKP088slC2JdiAqu3JH0w01J6FeumXSnO1G7bu6f8K9pIsGxmP8qI5KskJu+5YsNfrHKtINJ660BhHlqyBR+pjxgwjQNIB2QN4MgiGRBmBAGNdNXAiASEGZVz//IjXN/qta0bTnSAA305NyoPfLXDMJg7yAvSdremKcu4PFsK5vAV+30d6keLppm0XzNVkAMabTz6QOHSjDjyd1qQVzoq+QLxQi3+VvuXFWhqopOuKyGYv/6EGh5DAfbnZTIfCFsaQOx5AxB7Uaekf/uN5gUDMZ4DCIU4KJTbtSHJsenNculfiGBQSyB9DjhmLU57QGo8LwC5rYrfazvVTJkCumwRBl0xf8WCw5CWV/aVXacYK8uf+I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for SEV-TIO support as it is going to equal or bigger
than the existing sev_guest.c which is already 700 lines and
keeps growing.

No behavioural change expected.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/sev-guest/Makefile                |  2 +-
 drivers/virt/coco/sev-guest/sev-guest.h             | 16 ++++++++++++++++
 drivers/virt/coco/sev-guest/{sev-guest.c => core.c} | 10 ++--------
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/Makefile b/drivers/virt/coco/sev-guest/Makefile
index 63d67c27723a..a8eb28b6736e 100644
--- a/drivers/virt/coco/sev-guest/Makefile
+++ b/drivers/virt/coco/sev-guest/Makefile
@@ -1,2 +1,2 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_SEV_GUEST) += sev-guest.o
+obj-$(CONFIG_SEV_GUEST) += core.o
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
new file mode 100644
index 000000000000..b2a97778e635
--- /dev/null
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __SEV_GUEST_H__
+#define __SEV_GUEST_H__
+
+#include <linux/miscdevice.h>
+#include <asm/sev.h>
+
+struct snp_guest_dev {
+	struct device *dev;
+	struct miscdevice misc;
+
+	struct snp_msg_desc *msg_desc;
+};
+
+#endif /* __SEV_GUEST_H__ */
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/core.c
similarity index 99%
rename from drivers/virt/coco/sev-guest/sev-guest.c
rename to drivers/virt/coco/sev-guest/core.c
index 935537a41469..98f698809720 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/core.c
@@ -27,19 +27,13 @@
 #include <uapi/linux/psp-sev.h>
 
 #include <asm/svm.h>
-#include <asm/sev.h>
+
+#include "sev-guest.h"
 
 #define DEVICE_NAME	"sev-guest"
 
 #define SVSM_MAX_RETRIES		3
 
-struct snp_guest_dev {
-	struct device *dev;
-	struct miscdevice misc;
-
-	struct snp_msg_desc *msg_desc;
-};
-
 /*
  * The VMPCK ID represents the key used by the SNP guest to communicate with the
  * SEV firmware in the AMD Secure Processor (ASP, aka PSP). By default, the key
-- 
2.55.0


