Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D78FC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:02:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2998D6B0095; Wed, 16 Sep 2026 08:02:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A2B6B00AC; Wed, 16 Sep 2026 08:02:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EA516B00AD; Wed, 16 Sep 2026 08:02:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D84E76B0095
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:02:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67E1516069B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:02:20 +0000 (UTC)
X-FDA: 85219487640.19.D28C71F
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010051.outbound.protection.outlook.com [52.101.46.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id 45C8A16000D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:02:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=lz4uBZzk;
	spf=pass (imf08.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 52.101.46.51 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789560137;
	b=prh5uVunKTayDaOtyR/KShp6+qzRFjXbz43CCdoAOfvQm5Eg4hOwIZTKe7aFKkMCYUBg+3
	FeKFIj48JO8kkoJqCkR1EYGW1xygBG5/tAvm2nyQpwR3iIDXiory6piTc5XUtqdHiN444A
	NR5yADsZidgRQcU0vKraHoGzqlh5p5E=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=lz4uBZzk;
	spf=pass (imf08.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 52.101.46.51 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWoH/Llw6YUXkVi9P/+pg2Cd/4z3RJ6aV+gYVYAAcRU=;
	b=fq20QTGX8Y6r2OLb2LinazLzku7CqISIMey8VscrLTiRU7QyRTLfGgESxmIo7O30+sO/R9
	rxd99xwSXodknajjmDqRCYPplB8p2sLIhHR/PbV+o+qwtRHP2B0Vr0asi9z2s6mJjPyTm4
	VGmiCceFK4zNhdZNKNN0QpoC6/uO2Qk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t8eW2LZEeLsU5jzpxmRNjLBvYNB9HJjnxAyywrycjmnbuC24mWlxMxocCel1hugJN4AUupJWDJgVSyJzWzoCX4/pU46IjkjUVNdxrno6uyb+z2qR2NNRxZ8qH8L0PtABQKeEBkn+SjuMB6Wm/EcYEni8RNHATQFQFhy/sni/UuHYvPIYoKZOfWxIG9ZXZ3q635KKVUl5OOoRTEHjClYtc6A/npwLR6oVNEMqT3fsQX5W2kvscbwhD4xAClMprr79hbM7OgScH0obY8Fx/pNwgpz83JpfbPAopW5v52T1V/DC/ACX8ot3jvUne5UADw8yYWZ17d/VPKGQ9mpB7vjSbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fWoH/Llw6YUXkVi9P/+pg2Cd/4z3RJ6aV+gYVYAAcRU=;
 b=hMkmTKVXm9niBUWx2oPRBhZNg8twP2kwB5XiO8t05lU0EP6ZXq0ajDmpl8R3ao1gX+VZ4pPdyOOIL2UKs5vlBJeiqZFVVPZ3XqGZawdPXGcVMCXd+ByEAGMYdW1TFYFvy87oKy1DIuvSDKsg7Rxsw/yRfOKlWgipq5e1AyMGY3XAUJ+PFshOIebUYvktTHQf4zTaStqHQMPQIvqx7GNN0cFEyenyUnM0Eu5OdoyylWRBnDhq4VhtbCHlvpUchvRbg2Hwdk34eB/nOPYKSw5AQp+k8thR9Rm3BEFrzG5eUcuYnPDMmXkS8HG7Ywa5AJVqW1SE/QZkkaTm1Ljvl16TFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fWoH/Llw6YUXkVi9P/+pg2Cd/4z3RJ6aV+gYVYAAcRU=;
 b=lz4uBZzkq+4GluEyz4oPAFXtUpVJwIPB1Z4Pi69SWOSJJcxY2nmirLEPj3jSXn39gQop7QHlYljA0TwzjJlf0suqyINmyDle7sh/5g91a+FSbsAmoWmQwwBnR6fPI0hjd2FnRMAZrbSa4IcPQbpp7ZPiHRBsKnqKm7bM1bBcdjs=
Received: from BY1P220CA0001.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::14)
 by DS4PR12MB248322.namprd12.prod.outlook.com (2603:10b6:8:509::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Wed, 16 Sep
 2026 12:02:12 +0000
Received: from SJ5PEPF00000207.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::97) by BY1P220CA0001.outlook.office365.com
 (2603:10b6:a03:59d::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.11 via Frontend Transport; Wed,
 16 Sep 2026 12:02:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000207.mail.protection.outlook.com (10.167.244.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 12:02:11 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 07:01:48 -0500
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
Subject: [RFC PATCH kernel 15/17] x86/sev: Implement guest TSM driver for SEV-TIO (phase2, DMA)
Date: Wed, 16 Sep 2026 21:51:55 +1000
Message-ID: <20260916115159.1938195-16-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000207:EE_|DS4PR12MB248322:EE_
X-MS-Office365-Filtering-Correlation-Id: 04cd4172-76ca-459e-f814-08df13ea574c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700016|1800799024|32650700020|82310400026|23010399003|7416014|10067099003|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	fUqLwP2yBeGwzHtiDcoNUQWtntKDgz8U8C25nqzqoH2MPw/rY1tOggSZ+v9VCWmr7NYblHy8WR/0Ct3cmbUgXyRiLYJOR0ufnlIDIe5ba9PIQT78mB8Hcif0UmdhR2Ge1kN4GcXGWlNWrQM+faCwl4gz+3WpdBHg6/yh3Ns59rM+SWtsH5M2cABjl4G87VuSRLYXQjyDFbT+BNehAs2POk6DDZNQkaz6QLBxnG2aNM+GSrlA31RMXxpLA4jD10Pa+9vPGPQOuPmU9ZtSb3gUlw8JuMQPUnVoIRdw2JS6yMnsUk7bBLGBCSFnX8z4Q1OLu6QLfdXLLaJ5k/7KFuiE2Qz0ear1aYyXia/PRJcGW8eSeAmiOzjw6IYGDHWELAi+I/07k1IdD2Ij72KerVCygCjsm/BjYhctwVC5phAeS0RKEuQWKor3Dkw5RAQ7taxgT/h6VvtZIOcx5aNT2AaCcAU7wS+gDt6PMP8p53Ai2OgUoeRSDZWwvf03VpSCTs+4JRd9KkUPKI3vc1C3iJ1ye2toJGCPNPcPz8fYWzz7lxWQP7XTB6OCJHZmLmQ+s0WajS7fIYUhjZyk/YGTgrYV5JxfZ2VDSjYC7R0tqjN63JghHVrecj/GqDCPWZXuaSUnQrq0AU/KPCLwsHEIEBC7fdCo0vvDzSD1pBe18cUaw5GQ6X+q4U/wfYPOPkscStdBLCjaX38cgupFrhidHOzoWw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700016)(1800799024)(32650700020)(82310400026)(23010399003)(7416014)(10067099003)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gwUS5QlepI1jB9RFz2eYhcIGjvljtIY8qky9Q+KRNfs9t0uqazvIMGtOYEiFlwPgXSP299Vg+7GXppDplxnrxl8KhzpfVTLl7nL/G8fzrL0YLtAU3zgDc2tq4LZyBUjN25O+7XhpKZFJyuBjunYQIZlUpKbteps681NIyuNeXgsHTIu9yVQw85BUurli3THx77HFez2QWV0+4dmsiUwpbp6zVqOTghTQN9f6tOvRVv82jbPF8+2gddvsKXUs2gOEifWhO0aTAJPnk1nNXPRO7YFgcLmfvp/PwzcSkUVYrw5GNbQnS6f32B5Uud9ZAFwtWYNuBc+hKuO6gIZrsf5gDxbU9w7VgqmQzZRZEHl899j09k1/qtZNa3M5qYG/6TAP6YcmFjZL85P1lu5Su6ofeediQUNa9ytdmQA3BHdB4h6EkWZluYv1Wh0vMZRrun0J
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 12:02:11.6575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 04cd4172-76ca-459e-f814-08df13ea574c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000207.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB248322
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 45C8A16000D
X-Rspam-User: 
X-Stat-Signature: gxkxzrtmwujgs6wq94daqm894bgrogfj
X-HE-Tag: 1789560137-413145
X-HE-Meta: U2FsdGVkX19KB2pslpsgxiL8Pi7iXnSiH4NpgKVVLeJuSWtSmMkzTGbN4LLs8RW1P7F9FibAVXdb1d+2Wtzl3hxhxNR/051RNMeJy9YJ90vmLVZj40+vmzhDpkHJGu2X0x+j9vLrEIr9eC/AF4qlSqVlz0HVZUon0IbeutnyiK7XliX1568FzjZguG13BxtSnumYiW7tNokN9SdmOxmo7rfulu+fgUnqlbFrS9z2DbL+4P473OhX36e5yOL0E2JjCgeqmEr04+9T/N3G5MGQwCNZFuCDP+HTVZXWsBIi5j23TGWlvIJFuxF/5fgzlpxKcY0wOQ6b2DAQ+OOwwdoaSl6XnCK7UvLwwsw+3xYu/46bZGWEKCU89ZKZlMroDKBdmck0yU5+5Ud+a1Tgyh2aue0WOKrTcxNF8GBCam4s8it47wyzenTNtTagJzlfNurZXT92IFM6AhUdEM3Jujhu9/wha6cDycTkUV992x2pmNcqqPBoM1hsBdTUD0/ksi9U9i1k/xF9O3iSSeVz+SwdYwnra1Oy+Sp9HCI2+pAwpxpucYEWdjGthVVelERdfmxLX0jRA6xEZa3orHk766QCsTtff0/eeaU58qz9T72dQvK/ZpGHJssSjqCr/SJOAA0QurOLtwZMZuEuvsZWzsJgbPRbFt1SaSEiANR6Ym8YONUvgpj5ZYrqhGAktkkS4Uy+1VNrXMUZQUTt4KNutKADhI/L8CPqhONlF6nxFmbOBvftRgrt5Bjfr47UmI4/j5kmaDiPSDmsDcXFuZcB3Wk7BPjrMSmqbcjLSsvlXF8wIuN8KhRO9OH8iO7B3xeipdATyYyqavXcTRnNuRPBrJpErTEJLVu+d5UoFDAnsUdRwakx9pzsWrvDfOJVpMLnSKhGsTd5veSxCBTa+IQLIyxKhp5ptpIln2u6tACxt7oWS3WlQZzJrs9sZ1fZqKZInuujOIalQ/M4R04qbhDMRaL
 HEvG/FYw
 jj6YMo2RZuZxmFOhvTzKNOfs2L5T1326aHbyOxpq+e+kc/M+d/qfc1IlhYeURdgWCOSQwESbw6R6XyW+pKgUoVzSatpThcH2zzWy3aAmlHS08Bt5s+wfYTF1L25dF+a9kznESzQJbr1quD7S2X8s4DOTWj58RVmuMBKjzckKyk6K1GlkrTRjqhFVPDlwrYrUda5g3VA9KBWMNtiog2BIM2aFgzoB29nK2Cb4bvruQvx2nLoEUQn9OMSUvwgpkD+5OE4erbx89mWhdLqhqXe29e1nFFFSmQASp/sbJxRzLj8MaurW86cRlJrkGDuGdqK3YWXXmYWJLCCH+zwEPmCT+wga7TRGGuW2nGBtrj+GAVB+JGkGpLQ7aqOI0TYX5t3SodmHuTX3ctR8hbZjuaN24dvrCYwvQgjp2ftch0HubvZ+VaaZB8OdfF9DM7yNXEITagxAUlfGUArGIfWii5ST8dWW/Rqob12vb0VnEzsZPFib7Fthyjyf4n+D7GGQnE7XNA6S8XZOFQCD51303THRFC36JFjgx8+4BkzeA4QijWsD7rKGBZhG6S7iArEQNbDGF6rrzYQ4eNOlX6HKlD6ZO9Qd+1b40DKRTy7SdDgvuqvvSbNPxMP4scziLV1RSQhXhvg2vtKxdx2zVB04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the guest-side PCI TSM backend for AMD SEV-TIO, wiring the generic
pci_tsm framework to GHCB TIO operations and PSP guest requests.

Register pci_tsm_ops from sev-guest on probe when TIO GHCB support is
present (gated by the tsm_enable module parameter).
lock() binds a TDI, constructs a devsec TSM object and transitions to
CONFIG_LOCKED; accept() transitions the TDI to RUN and programs the SDTE
with vTOM and guest access permissions; unlock() invalidates the SDTE,
unbinds the TDI, quiesces DMA and transitions to CONFIG_UNLOCKED.

Introduce tio.c with TIO guest-request handling (TIO_MSG_SDTE_WRITE_REQ
and related message layouts) and set cc_shared_dma_offset from the
configurable tsm_vtom so shared DMA addresses are translated for the
hypervisor.  Extend asm/sev.h with TIO message types and TDISP SPDM
algorithm constants.

Build tio.o when PCI_TSM is enabled and select PCI_TSM from SEV_GUEST
Kconfig.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 drivers/virt/coco/sev-guest/Kconfig     |   1 +
 drivers/virt/coco/sev-guest/Makefile    |   3 +
 arch/x86/include/asm/sev.h              |   8 +
 drivers/virt/coco/sev-guest/sev-guest.h |   4 +
 drivers/virt/coco/sev-guest/core.c      |  14 +
 drivers/virt/coco/sev-guest/tio.c       | 347 ++++++++++++++++++++
 6 files changed, 377 insertions(+)

diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
index a6405ab6c2c3..4255072dfa1a 100644
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -3,6 +3,7 @@ config SEV_GUEST
 	default m
 	depends on AMD_MEM_ENCRYPT
 	select TSM_REPORTS
+	select PCI_TSM if PCI
 	help
 	  SEV-SNP firmware provides the guest a mechanism to communicate with
 	  the PSP without risk from a malicious hypervisor who wishes to read,
diff --git a/drivers/virt/coco/sev-guest/Makefile b/drivers/virt/coco/sev-guest/Makefile
index a8eb28b6736e..84a8b0dd62cd 100644
--- a/drivers/virt/coco/sev-guest/Makefile
+++ b/drivers/virt/coco/sev-guest/Makefile
@@ -1,2 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_SEV_GUEST) += core.o
+ifeq ($(CONFIG_PCI_TSM),y)
+obj-$(CONFIG_SEV_GUEST) += tio.o
+endif
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 89aaccb053ba..375cb5346ec3 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -182,6 +182,14 @@ enum msg_type {
 
 	SNP_MSG_TSC_INFO_REQ = 17,
 	SNP_MSG_TSC_INFO_RSP,
+	TIO_MSG_TDI_INFO_REQ = 19,
+	TIO_MSG_TDI_INFO_RSP = 20,
+	TIO_MSG_MMIO_VALIDATE_REQ = 21,
+	TIO_MSG_MMIO_VALIDATE_RSP = 22,
+	TIO_MSG_MMIO_CONFIG_REQ = 23,
+	TIO_MSG_MMIO_CONFIG_RSP = 24,
+	TIO_MSG_SDTE_WRITE_REQ = 25,
+	TIO_MSG_SDTE_WRITE_RSP = 26,
 
 	SNP_MSG_TYPE_MAX
 };
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
index b2a97778e635..c823a782739f 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -11,6 +11,10 @@ struct snp_guest_dev {
 	struct miscdevice misc;
 
 	struct snp_msg_desc *msg_desc;
+
+	struct tsm_dev *tsmdev;
 };
 
+void sev_guest_tsm_set_ops(bool set, struct snp_guest_dev *snp_dev);
+
 #endif /* __SEV_GUEST_H__ */
diff --git a/drivers/virt/coco/sev-guest/core.c b/drivers/virt/coco/sev-guest/core.c
index 98f698809720..8448c123ab1e 100644
--- a/drivers/virt/coco/sev-guest/core.c
+++ b/drivers/virt/coco/sev-guest/core.c
@@ -45,6 +45,10 @@ static int vmpck_id = -1;
 module_param(vmpck_id, int, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
+static bool tsm_enable = true;
+module_param(tsm_enable, bool, 0644);
+MODULE_PARM_DESC(tsm_enable, "Enable SEV TIO");
+
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 {
 	struct miscdevice *dev = file->private_data;
@@ -668,6 +672,14 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	snp_dev->msg_desc = mdesc;
 	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n",
 		 mdesc->vmpck_id);
+
+	u64 *sev_hv_features_ptr = dev_get_platdata(&pdev->dev);
+	if (!sev_hv_features_ptr || !(*sev_hv_features_ptr & GHCB_HV_FT_SNP_SEV_TIO))
+		tsm_enable = false;
+
+	if (tsm_enable)
+		sev_guest_tsm_set_ops(true, snp_dev);
+
 	return 0;
 
 e_msg_init:
@@ -681,6 +693,8 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
 	snp_msg_free(snp_dev->msg_desc);
+	if (tsm_enable)
+		sev_guest_tsm_set_ops(false, snp_dev);
 	misc_deregister(&snp_dev->misc);
 }
 
diff --git a/drivers/virt/coco/sev-guest/tio.c b/drivers/virt/coco/sev-guest/tio.c
new file mode 100644
index 000000000000..99ff2b9c872a
--- /dev/null
+++ b/drivers/virt/coco/sev-guest/tio.c
@@ -0,0 +1,347 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bitops.h>
+#include <linux/minmax.h>
+#include <linux/pci.h>
+#include <linux/psp-sev.h>
+#include <linux/tsm.h>
+#include <linux/pci-tsm.h>
+#include <crypto/gcm.h>
+#include <uapi/linux/sev-guest.h>
+
+#include <asm/svm.h>
+#include <asm/sev.h>
+
+#include "sev-guest.h"
+
+ulong tsm_vtom = (2ULL << 40);
+module_param(tsm_vtom, ulong, 0644);
+MODULE_PARM_DESC(tsm_vtom, "SEV TIO vTOM value");
+
+#define tsm_dev_to_snp_dev(t)	((struct snp_guest_dev *)dev_get_drvdata((t)->dev.parent))
+#define pdev_to_tdi(p)		container_of((p)->tsm, struct tio_guest_tdi, ds.base_tsm)
+#define ghcb_tio_sbdfn(pdev)	((pci_domain_nr((pdev)->bus) << 16) | pci_dev_id(pdev))
+
+struct tio_guest_tdi {
+	struct pci_tsm_devsec ds;
+	struct snp_guest_dev *snp_dev;
+	u64 tdi_id; /* Runtime FW generated TDI id */
+};
+
+static int handle_tio_guest_request(struct snp_guest_dev *snp_dev, u8 type,
+				    void *req_buf, size_t req_sz, void *resp_buf, u32 resp_sz,
+				    u64 *bdfn, u64 *param, u64 *fw_err)
+{
+	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
+	struct snp_guest_req req = {
+		.msg_version = 2,
+		.msg_type = type,
+		.vmpck_id = mdesc->vmpck_id,
+		.req_buf = kmemdup(req_buf, req_sz, GFP_KERNEL),
+		.req_sz = req_sz,
+		.resp_buf = kmalloc(resp_sz, GFP_KERNEL),
+		.resp_sz = resp_sz,
+		.exit_code = SVM_VMGEXIT_SEV_TIO_GR,
+		.input.guest_rid = 0,
+		.input.param = 0,
+	};
+	int ret;
+
+	if (!req.req_buf || !req.resp_buf) {
+		ret = -ENOMEM;
+		goto error_exit;
+	}
+
+	if (bdfn) {
+		req.input.guest_rid = *bdfn & 0xFFFFFFFF;
+		req.input.npages = *bdfn >> 32;
+	}
+	req.input.param = *param;
+
+	ret = snp_send_guest_request(mdesc, &req);
+
+	memcpy(resp_buf, req.resp_buf, resp_sz);
+	*param = req.input.param;
+	*fw_err = req.exitinfo2;
+
+error_exit:
+	kfree(req.resp_buf);
+	kfree(req.req_buf);
+
+	return ret;
+}
+
+struct tio_msg_tdi_info_req {
+	u64 tdi_id;
+	u8 reserved[8];
+} __packed;
+
+enum {
+	TIO_MSG_TDI_INFO_RSP_STATUS_BOUND = 0,
+	TIO_MSG_TDI_INFO_RSP_STATUS_INVALID = 1,
+	TIO_MSG_TDI_INFO_RSP_STATUS_UNBOUND = 2,
+};
+
+struct tio_msg_tdi_info_rsp {
+	u64 tdi_id;
+	u16 status; /* TIO_MSG_TDI_INFO_RSP_STATUS_xxx */
+	u8 reserved1[6];
+
+	u32 meas_digest_valid:1;
+	u32 meas_digest_fresh:1;
+	u32 reserved2:30;
+
+	/* These are TDISP's LOCK_INTERFACE_REQUEST flags */
+	u32 no_fw_update:1;
+	u32 cache_line_size:1;
+	u32 lock_msix:1;
+	u32 bind_p2p:1;
+	u32 all_request_redirect:1;
+	u32 reserved3:27;
+
+	u64 spdm_algos;
+	u8 certs_digest[48];
+	u8 meas_digest[48];
+	u8 interface_report_digest[48];
+	u64 tdi_report_count;
+	u64 reserved4;
+} __packed;
+
+struct sdte {
+	u64 v                  : 1;
+	u64 reserved           : 3;
+	u64 cxlio              : 3;
+	u64 reserved1          : 45;
+	u64 ppr                : 1;
+	u64 reserved2          : 1;
+	u64 giov               : 1;
+	u64 gv                 : 1;
+	u64 glx                : 2;
+	u64 gcr3_tbl_rp0       : 3;
+	u64 ir                 : 1;
+	u64 iw                 : 1;
+	u64 reserved3          : 1;
+	u16 domain_id;
+	u16 gcr3_tbl_rp1;
+	u32 interrupt          : 1;
+	u32 reserved4          : 5;
+	u32 ex                 : 1;
+	u32 sd                 : 1;
+	u32 reserved5          : 2;
+	u32 sats               : 1;
+	u32 gcr3_tbl_rp2       : 21;
+	u64 giv                : 1;
+	u64 gint_tbl_len       : 4;
+	u64 reserved6          : 1;
+	u64 gint_tbl           : 46;
+	u64 reserved7          : 2;
+	u64 gpm                : 2;
+	u64 reserved8          : 3;
+	u64 hpt_mode           : 1;
+	u64 reserved9          : 4;
+	u32 asid               : 12;
+	u32 reserved10         : 3;
+	u32 viommu_en          : 1;
+	u32 guest_device_id    : 16;
+	u32 guest_id           : 15;
+	u32 guest_id_mbo       : 1;
+	u32 reserved11         : 1;
+	u32 vmpl               : 2;
+	u32 reserved12         : 3;
+	u32 attrv              : 1;
+	u32 reserved13         : 1;
+	u32 sa                 : 8;
+	u8 ide_stream_id[8];
+	u32 vtom_en            : 1;
+	u32 vtom               : 31;
+	u32 rp_id              : 5;
+	u32 reserved14         : 27;
+	u8  reserved15[0x40-0x30];
+} __packed;
+
+struct tio_msg_sdte_write_req {
+	u64 tdi_id;
+	u8 reserved[8];
+	struct sdte sdte;
+} __packed;
+
+/*
+ * Status codes from TIO_MSG_SDTE_WRITE_REQ
+ */
+enum sdte_write_status {
+	SDTE_WRITE_SUCCESS = 0,
+	SDTE_WRITE_INVALID_TDI = 1,
+	SDTE_WRITE_TDI_NOT_BOUND = 2,
+	SDTE_WRITE_RESERVED = 3,
+};
+
+struct tio_msg_sdte_write_rsp {
+	u64 tdi_id;
+	u16 status; /* SDTE_WRITE_xxx */
+	u8 reserved[6];
+} __packed;
+
+static int tio_tdi_sdte_write(struct pci_dev *pdev, struct snp_guest_dev *snp_dev,
+			      uint64_t tdi_id, u64 vtom, bool invalidate)
+{
+	size_t resp_len = sizeof(struct tio_msg_sdte_write_rsp) + AUTHTAG_LEN;
+	struct tio_msg_sdte_write_rsp *rsp __free(kfree_sensitive) = kzalloc(resp_len, GFP_KERNEL);
+	struct tio_msg_sdte_write_req req;
+	u64 flags = vtom | (invalidate ? 0 : SVM_VMGEXIT_SEV_TIO_GR_SDTE_VALIDATE);
+	u64 bdfn = ghcb_tio_sbdfn(pdev);
+	u64 fw_err = 0;
+	int rc;
+
+	BUILD_BUG_ON(sizeof(struct sdte) * 8 != 512);
+
+	pci_notice(pdev, "SDTE write vTOM=%llx", flags);
+
+	if (!invalidate)
+		req = (struct tio_msg_sdte_write_req) {
+			.tdi_id = tdi_id,
+			.sdte.vmpl = 0,
+			.sdte.vtom = vtom >> 21,
+			.sdte.vtom_en = 1,
+			.sdte.iw = 1,
+			.sdte.ir = 1,
+			.sdte.v = 1,
+		};
+	else
+		req = (struct tio_msg_sdte_write_req) {
+			.tdi_id = tdi_id,
+		};
+
+	if (!rsp)
+		return -ENOMEM;
+
+	rc = handle_tio_guest_request(snp_dev, TIO_MSG_SDTE_WRITE_REQ,
+				      &req, sizeof(req), rsp, resp_len,
+				      &bdfn, &flags, &fw_err);
+	if (rc || fw_err || rsp->status != SDTE_WRITE_SUCCESS) {
+		pci_err(pdev, "SDTE write failed with rc=%d, fwerr=0x%llx, status=%x\n",
+			rc, fw_err, rsp->status);
+		if (!rc)
+			return -EFAULT;
+		return rc;
+	}
+
+	pdev->dev.archdata.cc_shared_dma_offset = invalidate ? 0 : vtom;
+
+	return 0;
+}
+
+static struct pci_tsm *sev_guest_lock(struct tsm_dev *tsmdev, struct pci_dev *pdev)
+{
+	struct tio_guest_tdi *gtdi __free(kfree) = kzalloc(sizeof(*gtdi), GFP_KERNEL);
+	u64 fw_err = 0, tdi_id = 0;
+	int rc;
+
+	if (!gtdi)
+		return ERR_PTR(-ENOMEM);
+
+	/* Enabling device tells the HV to register MMIO as memory slots */
+	rc = pci_enable_device_mem(pdev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = pci_tsm_devsec_constructor(pdev, &gtdi->ds, tsmdev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	gtdi->snp_dev = tsm_dev_to_snp_dev(tsmdev);
+
+	rc = sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_BIND, &fw_err, &tdi_id);
+	if (rc) {
+		pci_err(pdev, "TDI bind CONFIG_LOCKED failed rc=%d fw=0x%llx\n",
+			rc, fw_err);
+		return ERR_PTR(rc);
+	}
+	pci_dbg(pdev, "New TDI ID=%llx\n", tdi_id);
+
+	struct device_evidence *evidence = device_evidence_create(0, HASH_ALGO_SHA384);
+	if (!evidence)
+		return ERR_PTR(-ENOMEM);
+	gtdi->ds.base_tsm.evidence = evidence;
+
+	gtdi->tdi_id = tdi_id;
+
+	return &no_free_ptr(gtdi)->ds.base_tsm;
+}
+
+static void sev_guest_unlock(struct pci_tsm *tsm)
+{
+	struct pci_dev *pdev = tsm->pdev;
+	u64 fw_err = 0;
+
+	sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_UNBIND, &fw_err, NULL);
+
+	/* Quiesce DMA */
+	sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_STOP, &fw_err, NULL);
+
+	tsm->pdev->tsm = NULL;
+	kvfree(tsm);
+}
+
+static int sev_guest_accept(struct pci_dev *pdev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+	u64 fw_err = 0;
+
+	if (!tsm->evidence->obj[DEVICE_EVIDENCE_TYPE_REPORT].data) {
+		pci_warn_once(pdev, "Cannot accept without the report");
+		return -ENODEV;
+	}
+
+	int ret = tio_tdi_sdte_write(pdev, snp_dev, gtdi->tdi_id, 0, false); // Mark everything "shared"
+	if (ret)
+		return ret;
+
+	return sev_tio_op(ghcb_tio_sbdfn(pdev), SVM_VMGEXIT_SEV_TIO_OP_RUN, &fw_err, NULL);
+}
+
+static int sev_guest_enable_dma(struct pci_dev *pdev)
+{
+	struct tio_guest_tdi *gtdi = pdev_to_tdi(pdev);
+	struct snp_guest_dev *snp_dev = gtdi->snp_dev;
+	int ret;
+
+	ret = tio_tdi_sdte_write(pdev, snp_dev, gtdi->tdi_id, tsm_vtom, false);
+
+	return ret;
+}
+
+static void sev_guest_disable_dma(struct pci_dev *pdev)
+{
+	struct tio_guest_tdi *gtdi = pdev_to_tdi(pdev);
+	struct snp_guest_dev *snp_dev = gtdi->snp_dev;
+	int rc;
+
+	rc = tio_tdi_sdte_write(pdev, snp_dev, gtdi->tdi_id, tsm_vtom, true);
+	if (rc)
+		pr_err("SDTE_WRITE failed, ret=%d\n", rc);
+}
+
+struct pci_tsm_ops sev_guest_tsm_ops = {
+	.lock = sev_guest_lock,
+	.unlock = sev_guest_unlock,
+	.run = sev_guest_accept,
+	.enable_dma = sev_guest_enable_dma,
+	.disable_dma = sev_guest_disable_dma,
+};
+
+void sev_guest_tsm_set_ops(bool set, struct snp_guest_dev *snp_dev)
+{
+	if (set) {
+		struct tsm_dev *tsmdev;
+
+		tsmdev = tsm_register(snp_dev->dev, &sev_guest_tsm_ops);
+		if (!IS_ERR_OR_NULL(tsmdev))
+			snp_dev->tsmdev = tsmdev;
+		return;
+	}
+
+	if (snp_dev->tsmdev) {
+		tsm_unregister(snp_dev->tsmdev);
+		snp_dev->tsmdev = NULL;
+	}
+}
-- 
2.55.0


