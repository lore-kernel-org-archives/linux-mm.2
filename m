Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0483CC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160056B0093; Wed, 16 Sep 2026 08:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111176B0095; Wed, 16 Sep 2026 08:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF49A6B00AC; Wed, 16 Sep 2026 08:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C14966B0093
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:01:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 708301C2CC0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:01:51 +0000 (UTC)
X-FDA: 85219486422.26.C79836E
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010046.outbound.protection.outlook.com [52.101.85.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 457D5A0015
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:01:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RpT1pMU0;
	spf=pass (imf25.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 52.101.85.46 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m5Wn2u7LMPCPQqnkaKjK7qt1ozlCRrR1eh6v97NBG5s=;
	b=gTrXjs0O8DC6/Zd7NyxQnXbH+roSu70UYawJ3bCh8KBoZBwZfVYB673smGBHFSWQZYae4E
	yJKZ04uo1PMUOlBZ0u4CcXkZ2rx23bw6nyN0TsK2AvGzySaW9tmEKFXrOKEw8G6WckZ1kq
	kXnVIUwWU+BlOQLWT/1DERaynNjzHoc=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=RpT1pMU0;
	spf=pass (imf25.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 52.101.85.46 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789560108;
	b=TgVJETE2pLg3sUd4+LHXQuZoyhp6eUsWbOzLjXcHIE9bUYjaf8i6Y/C91pt9my4SeFdR84
	B5BILECsVFhiYJB3Cq1HGbZWnlEvSZBnW4RAXHv4HZY5LtnO3TbdsGjQBZ6O3f6k9GbtS9
	kMBiiqDTU9Hkbu1PMzL3SC01QOASnro=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ez46YkTXVNPBaIsUDadQp2HbzH2MzSUTArP8XRKzrau9uH0KazSMpiFMJZ490AM5RobEp4q9wt2iGXMEqV57xqQ+7WNBr4fQGROO8j5yxCaL+8MNG//M8krALapxAMwhH0SHA7PhBc8BE4SSX8Gg0OXxj1uSPdPElVL0l4smWPJNuUUi82ixmSnYE3t2E0nNUcMhb1jyWUad1pBSjYrqdnXzQZ9OGeJk0LuHacrJV/l7JM+tMqyuwog0xwrnbxr92smLbFOpUWBAHJ0S6F7Z0UoYA18POj44sijrJP+kH/+UbdPpNP/1PIRKMvGs1DUhohi4AWy+05VycuHa+hrnqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m5Wn2u7LMPCPQqnkaKjK7qt1ozlCRrR1eh6v97NBG5s=;
 b=dC4kPfCKMTsVvumw/AfwQJbkmA2qPNO9VhXvprucbnf+ClPy5GBqXj/tV0VDOf2g5yDmU0u3kPQdc/dBZ+tGAxSgry0KDbdk+UozBMtFTc4UVpv2hcxoxmcET0BtrW7p8YWVLeN2EMmJlBve0UzZsoImvYJ+T5uNcQro5PpgqhFTmVQfjUwK/KL/AxVBiCpG9LXMMX9WFxySQRqdg242zGeeUz+Ol/ak432vVMKWeabLzmlQDu4xGdWvridNCNHuqHZ40OGroIk/DF1zfd09DMAuWyMVZ5Fzr4n93OjBe3DrxRsxCXYA/8WmVCNSJpJOx+EsFYGqhMltn22NgCGadw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m5Wn2u7LMPCPQqnkaKjK7qt1ozlCRrR1eh6v97NBG5s=;
 b=RpT1pMU0oCMmamH88JBb2YcpTKg9WPNT5UC213Hyh3uJ2ZzAdSDTiHve1Mje7l3BusNT0TkBooD/4Qbrpjx4TnAppNG2+xKugKTq8jTIevcVjmt4MUN1IIdPrcPPPPxMNpDnuPscIwCJ0SAu8MamfhuIX1GeizOLAUYAiqFd8+Y=
Received: from SJ0PR05CA0076.namprd05.prod.outlook.com (2603:10b6:a03:332::21)
 by MN0PR12MB5860.namprd12.prod.outlook.com (2603:10b6:208:37b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.11; Wed, 16 Sep
 2026 12:01:35 +0000
Received: from SJ5PEPF00000209.namprd05.prod.outlook.com
 (2603:10b6:a03:332:cafe::8c) by SJ0PR05CA0076.outlook.office365.com
 (2603:10b6:a03:332::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.6 via Frontend Transport; Wed, 16
 Sep 2026 12:01:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000209.mail.protection.outlook.com (10.167.244.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 12:01:35 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 07:01:11 -0500
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
Subject: [RFC PATCH kernel 14/17] x86/sev: Add GHCB calls for SEV-TIO
Date: Wed, 16 Sep 2026 21:51:54 +1000
Message-ID: <20260916115159.1938195-15-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000209:EE_|MN0PR12MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: 43b471b3-312e-4f11-3c46-08df13ea4171
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700016|32650700020|23010399003|7416014|376014|10067099003|3023799007|6133799003|20052099010|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	/5G+nkTNRMJNQGSuiS6RRZKhS/KhosBx1ar6A3U+Yen4hddWoqMH8sZ3wb207pdmlf0+n/OzPd/tDMYtXqhUUSVV1cPUQ8F0erZvNy6rM/w6QV8wI/3i7R92YCzdRuxztFT05eYuD1VphA9OBQ1iM1Cw5YjQnrR1cQhe1GMX/T7+lB7WgHV2DFFqnZePUqxNodAa/Imy8E4w+nNI2OXHRKchZyt+I95+JXZj8Ww4qsCEvsPhzpEcM/JFQgSTpiSrjROv38LiYhzlpTW+O41JTbJPqj4GWBLFT5esxRrw136PSiIhRppB/qqNKj6DkLGUjpO7nQK3klmH6NDYQ8Uy9OuJSuRLay4fy8FwEOCrI54/BjnWWiHslCVUMoD7pHg8/sn4WcUc9MnM7rS1MoD+Tsic0kR4DsMjM8I8JQ4x7BjAv1Tob2/14Kvxoh82LRwbhsZrIZuhuKF2Q8B2nCJSiN+dbS6FAY1W7m/ULAGzT2Ey6rt4cJtRxkvAtEeH62ozmZIBcxg4Q5y5JQL93YMM/F20OqMGA+v2k89I8WiSaEh7Z0hvlHQ/1anLCNqI2jbHJ3atWpbmXAbPazrzonBx9HP6m8/vlg4rQs3J1QlaGF6HYKZaZM0Z6YsuplxSNzGoR3K9NIyLylTwMPtZE3FjYtWqp/1oCWdduhO0VRo7g1XoMXRTWtgFYjZon5qA+8wfMD30YexillBF9Jp4aRT7Sw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700016)(32650700020)(23010399003)(7416014)(376014)(10067099003)(3023799007)(6133799003)(20052099010)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	KGWqrxMpevRTUyLVG3M4M4v9Z+GrPszOWDRjjAtKr8gD+oIKekSZU1I1NEkcyDv7jCtK/HW59j+Q01lJZ5+zIvQt1Yhwllk/712KIEfEkfOUWdb9QDW/f1PSxKSNWqwa2Pogq0I/jKyYueKaGIv/XT+r1HVArzdQkAJ9qVWcdO8aFyoGyd/UNzEmgh0Tn/FDwDD2A8AT+3wBP0YhiGrwfhBW46lVveiCmlm6+h+mUnz3dFWiK9l4XDhlwlulUqJFOWY+5qRerR47gP50Op8Fn9lkliy0er94KZgjh1e2zYnNzdsI6FqJ8zf7rDPycm/1ljgPBc1U3QKNG8CeLDr9L3ctPipWjYJoyohqqivWF7/UVU1ZG0BjMPaUwVLmS9cN0G664BHbQ3K+kBgAKtcvax+3dNsK0RA8i0eVE/WZXPRECrI/mCBS5Waf/5k8hME0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 12:01:35.0080
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b471b3-312e-4f11-3c46-08df13ea4171
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5860
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 457D5A0015
X-Stat-Signature: dein87gm4j65omyn5x3udkkxo1rt9f3o
X-Rspam-User: 
X-HE-Tag: 1789560108-44595
X-HE-Meta: U2FsdGVkX18Cig41QFo0tYJDCMl/Oy4NEliuSiO/TRgRA6xzxM495MKrh0Mo4ZwIvqJuAxm9OuQDxAdtdidLdQVq7k1m+CWF1VTUtHpJDDbUS5BMdx4ZbA+eQa5aqEzw33UL5NqAw0wngbyKEQC861vQWctHHoJhbEpU5MlEuv5n07d1FUjipt7i5O8jWrSJ/SBl/d2vo1o6giM3chzjcZ01FODC3pOMZIxpIAR81Nma7/vw05vrk0vRAtV6/fGV76vkoNME61wva2LxIrvLvL4JVKWdcwCyENFPbIdtgm+ABtR+shE8EQHiAGWYpbFHY2ZsGwSZbuE2JD7hzaFAre8pr60DqLean3vfUTj1kma7Q5KMEYg/w8CuBR9da84uVOC7lWmD8E2Nhkw8KnW4b1uvgdI3bFHiApCEFULzQA6geerV5fmTPHby+oyrglpHehnMnc57hOc+CT0jV8dmpSYberjcLHtofSKo2l2BGth6MBGR9Y2f6+jgdciQSM/KRvoxjNUrvqjWH3exYoct1TzljYVo5rzlsh2YRQNOKTkVsb/d+V33b5uCuNFKHjpLePqJ8A0RcvFdvWDRWrquK+eLeiRCWh4sxk9K3WiZUaD+GFzGeCsO4+UiOPiY1k1BQ1Bb4BpcVoXwN14PWNVF8BTre6+oF1L8h3OAu2NJPAjVyf/b44M/NktVHq9/aQxAvyjF4D1ARUyKS6WuguSB5R5dWRJ84arv9nAxB21y5+v0CowNdZCi3ehKXhByDIBGrtkf+j6WHbsXFcaPGe8a2YsRRz5sKOutK7QN2+ccA1kzCeyVRa2aVb9hD9pU+c3z2AcDauX9KHoCJwhPKidx7YIH16P64EnfKq1owVMFaSOSABBN1mp3IvkHStUGX4WZ+3eXPPCf+/ze3GBqxpfXZNmZJgKQmqHbUdRiO3Hx+a0UqQY1R86bDHg9qS8xK4w6w3O1cuUM7e4kZw3qvwF
 NF6g0+5a
 tj0kzaQK+gc5P7zSqYjbjALqOCTaSdZ25rBTn06O08cts8sgZcHteblHiwj9QVT7CL3XrVdcImhJ7Fe4aHXNOxCJjwY0o4qe8ZVmNIQVcBAb0yMq1Efizkibqoa19szQyCUpGPO9lHvKdV8Isy/GAkhpfLUg2+a/yH+qoZHK33Oxt/rHQS15rfRvyDnom8Hf4UnmuYtfGo0PAgkrehuatd+M6GLLbxynIcpvv1yMq3Ta8+xbtiNcTagTH5VePEoY15J/FJ1JjTk5GRz325pLyGUMERQqrjKx5ovRMcqnNietO0OFvKwoNOfUu1uWzelnh6D9Dpc/Hli0e4eJRsu8JzFK3ZozignYpn9kUmIejVBcC3D5JGszmkeBndxxdeZezvExIdRFXwyz6eHgUTRL1+vAwP3CdK1puIxW8YdOdoe0/qbJKmC+TljCbDvZdCQVdJWrP+2+eSI9kIFahaS56yhfp4cmVirvZQxo4+sE+nLb/I4YroBcQhy4s/3EqdmkuwKIEx0+8JPBwYZOHkIqtEILfwPhFO9kXhuYEi4r40icVac1mN+BIGQZx8iW24RfF4uMdLTL2J6w7UHpJXQNgjDOqNFtx7/bdGkR6rdTDHanEbXwJqzdZJL8vC1+qYZMmwpnYPIvnC8LtVQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SEV-TIO is a PSP protocol allowing PCI pass through of trusted devices
(TDI == TEE Device Interface) to an SNP VM. The VMM advertises
the support via HV_FEATURES and implements new calls:

1) TDI operation: the host executes on the guest behalf:
- TDI bind/unbind to/from the SNP VM in the PSP;
- TDI start/stop which translates to TDISP interface start/stop.

2) TIO guest request for an encrypted communication channel between
the SNP VM and the PSP, it follows the existing Extended Guest Request
pattern to read device evidence:
- get TDI status;
- validate MMIO ranges (a variant of the PVALIDATE instruction for
  MMIO RMPs);
- configure sDTE (a secure IOMMU descriptor).

Extend snp_req_data to pass more parameters.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/include/asm/sev-common.h |  1 +
 arch/x86/include/asm/sev.h        |  5 +++
 arch/x86/include/uapi/asm/svm.h   | 40 +++++++++++++++++++
 arch/x86/coco/sev/core.c          | 42 ++++++++++++++++++++
 4 files changed, 88 insertions(+)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 01a6e4dbe423..ff763c3c5d63 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -137,6 +137,7 @@ enum psc_op {
 #define GHCB_HV_FT_SNP			BIT_ULL(0)
 #define GHCB_HV_FT_SNP_AP_CREATION	BIT_ULL(1)
 #define GHCB_HV_FT_SNP_MULTI_VMPL	BIT_ULL(5)
+#define GHCB_HV_FT_SNP_SEV_TIO		BIT_ULL(7)
 
 /*
  * SNP Page State Change NAE event
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 9e7a077c445d..89aaccb053ba 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -149,6 +149,9 @@ struct snp_req_data {
 	unsigned long resp_gpa;
 	unsigned long data_gpa;
 	unsigned int data_npages;
+	unsigned int guest_rid;
+	unsigned long npages;
+	unsigned long param;
 };
 
 #define MAX_AUTHTAG_LEN		32
@@ -597,6 +600,8 @@ static inline void sev_evict_cache(void *va, int npages)
 	}
 }
 
+int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
diff --git a/arch/x86/include/uapi/asm/svm.h b/arch/x86/include/uapi/asm/svm.h
index 010a45c9f614..93597ad492bf 100644
--- a/arch/x86/include/uapi/asm/svm.h
+++ b/arch/x86/include/uapi/asm/svm.h
@@ -122,6 +122,44 @@
 #define SVM_VMGEXIT_SAVIC_REGISTER_GPA		0
 #define SVM_VMGEXIT_SAVIC_UNREGISTER_GPA	1
 #define SVM_VMGEXIT_SAVIC_SELF_GPA		~0ULL
+#define SVM_VMGEXIT_SEV_TIO_GR			0x80000020ull
+#define SVM_VMGEXIT_SEV_TIO_GR_INFO_STATE	BIT(0)
+#define SVM_VMGEXIT_SEV_TIO_GR_INFO_CERTS	BIT(1)
+#define SVM_VMGEXIT_SEV_TIO_GR_INFO_MEAS	BIT(2)
+#define SVM_VMGEXIT_SEV_TIO_GR_INFO_REPORT	BIT(3)
+
+#define SVM_VMGEXIT_SEV_TIO_GR_SDTE_VALIDATE	BIT(0)
+#define SVM_VMGEXIT_SEV_TIO_GR_SDTE_VTOM	GENMASK_ULL(51, 21)
+
+/*
+ * TIO_GUEST_REQUEST's MMIO_VALIDATE_REQ/MMIO_CONFIG_REQ encoding for MMIO in RDX:
+ *
+ * T....... ....GGGG GGGGGGGG GGGGGGGG GGGGGGGG GGGGGGGG GGGG.... ........
+ * Where:
+ *	G - guest physical address
+ *	T - TEE
+ */
+#define SVM_VMGEXIT_SEV_TIO_GR_MMIO_GFN(r)      (((r) & 0x000FFFFFFFFFF000ULL) >> PAGE_SHIFT)
+#define SVM_VMGEXIT_SEV_TIO_GR_MMIO_RESERVED(r) ((r) & 0x7FF0000000000FFFULL)
+#define SVM_VMGEXIT_SEV_TIO_GR_MMIO_PRIVATE(r)  (!!((r) & BIT(63)))
+
+#define SVM_VMGEXIT_SEV_TIO_GR_MMIO_NUM(r)      ((uint32_t)((r) >> 32))
+#define SVM_VMGEXIT_SEV_TIO_GR_MMIO_ADDR(r)     ((uint32_t)((r) & 0xFFFFFFFF))
+
+#define SVM_VMGEXIT_SEV_TIO_GR_MMIO_MK_VALIDATE(start, private) \
+	((SVM_VMGEXIT_SEV_TIO_GR_MMIO_GFN(start) << PAGE_SHIFT) | \
+	((private) ? BIT(63) : 0))
+
+#define SVM_VMGEXIT_SEV_TIO_OP			0x80000021ull
+#define SVM_VMGEXIT_SEV_TIO_GR_MMIO_MK_NUM_BDFN(n, bdfn) (((uint64_t)(n) << 32) | (bdfn))
+
+#define SVM_VMGEXIT_SEV_TIO_OP_PARAM(guest_id, action)	((u64)(action)<<32|(guest_id))
+#define SVM_VMGEXIT_SEV_TIO_OP_ACTION(exitinfo1)	((exitinfo1)>>32)
+#define SVM_VMGEXIT_SEV_TIO_OP_GUEST_ID(exitinfo1)	((exitinfo1) & 0xFFFFFFFF)
+#define SVM_VMGEXIT_SEV_TIO_OP_BIND	0
+#define SVM_VMGEXIT_SEV_TIO_OP_UNBIND	1
+#define SVM_VMGEXIT_SEV_TIO_OP_RUN	2
+#define SVM_VMGEXIT_SEV_TIO_OP_STOP	3
 #define SVM_VMGEXIT_HV_FEATURES			0x8000fffdull
 #define SVM_VMGEXIT_TERM_REQUEST		0x8000fffeull
 #define SVM_VMGEXIT_TERM_REASON(reason_set, reason_code)	\
@@ -245,6 +283,8 @@
 	{ SVM_VMGEXIT_GUEST_REQUEST,	"vmgexit_guest_request" }, \
 	{ SVM_VMGEXIT_EXT_GUEST_REQUEST, "vmgexit_ext_guest_request" }, \
 	{ SVM_VMGEXIT_AP_CREATION,	"vmgexit_ap_creation" }, \
+	{ SVM_VMGEXIT_SEV_TIO_GR,	"vmgexit_sev_tio_guest_request" }, \
+	{ SVM_VMGEXIT_SEV_TIO_OP,	"vmgexit_sev_tio_op" }, \
 	{ SVM_VMGEXIT_HV_FEATURES,	"vmgexit_hypervisor_feature" }, \
 	{ SVM_EXIT_ERR,         "invalid_guest_state" }
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 5b912f42f493..ed0e4546d5e5 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -104,6 +104,37 @@ static unsigned long snp_tsc_freq_khz __ro_after_init;
 DEFINE_PER_CPU(struct sev_es_runtime_data*, runtime_data);
 DEFINE_PER_CPU(struct sev_es_save_area *, sev_vmsa);
 
+int sev_tio_op(u32 guest_rid, unsigned int op, u64 *fw_err, u64 *tdi_id)
+{
+	struct ghcb_state state;
+	struct es_em_ctxt ctxt;
+	struct ghcb *ghcb;
+	int ret;
+
+	/* __sev_get_ghcb() needs IRQs disabled because it uses per-CPU GHCB. */
+	guard(irqsave)();
+
+	ghcb = __sev_get_ghcb(&state);
+	if (!ghcb)
+		return -EIO;
+
+	vc_ghcb_invalidate(ghcb);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, SVM_VMGEXIT_SEV_TIO_OP,
+				  SVM_VMGEXIT_SEV_TIO_OP_PARAM(guest_rid, op), 0);
+
+	*fw_err = ghcb->save.sw_exit_info_2;
+	if (*fw_err)
+		ret = -EIO;
+
+	if (!ret && op == SVM_VMGEXIT_SEV_TIO_OP_BIND && tdi_id)
+		*tdi_id = ghcb_get_rcx(ghcb);
+
+	__sev_put_ghcb(&state);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(sev_tio_op);
+
 /*
  * SVSM related information:
  *   When running under an SVSM, the VMPL that Linux is executing at must be
@@ -1345,6 +1376,11 @@ static int snp_issue_guest_request(struct snp_guest_req *req)
 	if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
 		ghcb_set_rax(ghcb, input->data_gpa);
 		ghcb_set_rbx(ghcb, input->data_npages);
+	} else if (req->exit_code == SVM_VMGEXIT_SEV_TIO_GR) {
+		ghcb_set_rax(ghcb, input->data_gpa);
+		ghcb_set_rbx(ghcb, input->data_npages);
+		ghcb_set_rcx(ghcb, ((uint64_t)input->npages << 32) | input->guest_rid);
+		ghcb_set_rdx(ghcb, input->param);
 	}
 
 	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, req->exit_code, input->req_gpa, input->resp_gpa);
@@ -1354,6 +1390,8 @@ static int snp_issue_guest_request(struct snp_guest_req *req)
 	req->exitinfo2 = ghcb->save.sw_exit_info_2;
 	switch (req->exitinfo2) {
 	case 0:
+		if (req->exit_code == SVM_VMGEXIT_SEV_TIO_GR)
+			input->param = ghcb_get_rdx(ghcb);
 		break;
 
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_BUSY):
@@ -1366,6 +1404,10 @@ static int snp_issue_guest_request(struct snp_guest_req *req)
 			input->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
+		} else if (req->exit_code == SVM_VMGEXIT_SEV_TIO_GR) {
+			input->data_npages = ghcb_get_rbx(ghcb);
+			ret = -ENOSPC;
+			break;
 		}
 		fallthrough;
 	default:
-- 
2.55.0


