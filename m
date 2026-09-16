Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FF8C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09BD96B00AA; Wed, 16 Sep 2026 08:01:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C176B00AB; Wed, 16 Sep 2026 08:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F366B00AC; Wed, 16 Sep 2026 08:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFB4A6B00AA
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:01:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41D001C2CC7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:01:09 +0000 (UTC)
X-FDA: 85219484658.19.25EB31E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013029.outbound.protection.outlook.com [40.93.201.29])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D7C218001A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:01:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="tAK/ysYq";
	spf=pass (imf16.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.201.29 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dA9IhLE51D9NYfND88bqQhl20dii5Ckm+YGWHKm39+w=;
	b=Ewr1gYNMvvJeGc56a08ysTMGckHNUsFGP/b8A+Zw/Oy8/D+H+sihFmeRikePkweWYfh7L5
	DGDN0RoHpWY/sEUZnyVxNWDGCfJ7Fk6wI97DyYtMdsUxgRQIsk4BUxERD4ACtiIBsoa6lQ
	FxP5OefhrqkQXj/rQY0TYfKnceJJbBE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="tAK/ysYq";
	spf=pass (imf16.hostedemail.com: domain of Alexey.Kardashevskiy@amd.com designates 40.93.201.29 as permitted sender) smtp.mailfrom=Alexey.Kardashevskiy@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789560066;
	b=gSVsf/2LND9xvIFRQftK4EfHqnj7trQCVOKJ3yv8x3CfpA7MGmC5QVMnfCa3Wm+FEi3f4c
	ioerLxKRydYpsZnJuDK9xi31AVwCfKJtzJDVQWeVfjqOe6NGIoCSMFG2L2MxogdqZNzXcL
	lwk6ZK8Mgs5W+vBscJOCR1htk8rbA6U=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RysGZKMHs1epu977SrAA1JJSXiIjQsbitUAUzo0og631gjBBRGn2BjxwjMCWcLdW9BsWVbm0Un2UWcNH5lE4IaOSolB+EkLLL8y2QC6InyHSCVH8JjNHWIpV/7BUTovPbEJnD7mVpQRQNLEHc8NGPHKTkozR+hormCPiq7qcpKgUF9ntpa0wTdJrnvqkVfL2LQAUffw4syw5+2lkQTDAErjXLyOf0hMFBwydmsV820C42XeGwt5YwL64AxB5caus6zS5j6nidzX9qAtb/5kccD2ijd+JMZACa8CX7RLp2vr6/GItAGOH+HS4AqSNrMwA18UolsJq2Z4l4JM/wgsoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dA9IhLE51D9NYfND88bqQhl20dii5Ckm+YGWHKm39+w=;
 b=Zq0s1qpS2T2DBAuVG1kAZEK2avJylW2WibH619MTsPJcnmCtsy1p2I1ivYzWdNAhUd5neykHRhgupx2s/Y/JvUhW8/IYB16p0wipHiXVW+9efx5+IxkXcL2HtMZ1R8vdNDDp6ZzjPSoXYbwziqKk1+1JJOG2NhcAatzs/Zg/c3y02nnp1NjdPLp2UJAcxfugXovube426MkdH85A+meTpKT/FjzKXkiDvbMhda9Bgkqb/IrtggNSTMnaQAMb1vdTZlFzcOAJUdISU6JFE1SCbpzE9wik9Usi7b5LGY2ahxnVtfJunrT8l9Ypo3DQBW1JfoVcadkhf+whT9WGqV7WZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dA9IhLE51D9NYfND88bqQhl20dii5Ckm+YGWHKm39+w=;
 b=tAK/ysYqFM0Y9x2ZqU5FZKr3ii9y+n+d3OlTvslr4zPgMTQ/QxQBNp5eDczxHclEBLKTBi7+YVb+89H49gjSJ8nuWbfMQQb/vKu1imImgR00hozdC6mQ2b97US6CJSaqjungVhFJjkw/Jne+utrpAr9Lj6257hszIYPZukzEU2Y=
Received: from BY3PR05CA0060.namprd05.prod.outlook.com (2603:10b6:a03:39b::35)
 by PH8PR12MB7206.namprd12.prod.outlook.com (2603:10b6:510:226::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 12:00:55 +0000
Received: from SJ5PEPF00000208.namprd05.prod.outlook.com
 (2603:10b6:a03:39b:cafe::43) by BY3PR05CA0060.outlook.office365.com
 (2603:10b6:a03:39b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 12:00:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF00000208.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 12:00:53 +0000
Received: from aiemdee.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 07:00:23 -0500
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
Subject: [RFC PATCH kernel 13/17] x86/sev: Pass HV features to sev-guest device via platform data
Date: Wed, 16 Sep 2026 21:51:53 +1000
Message-ID: <20260916115159.1938195-14-aik@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000208:EE_|PH8PR12MB7206:EE_
X-MS-Office365-Filtering-Correlation-Id: a5d7f197-52a1-412b-0589-08df13ea2869
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|82310400026|36860700016|32650700020|6133799003|18002099003|22082099003|10067099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	ggHAuYoxRsyDmpK7PPMyGhSXUVaxMF5B6QiwogeqTKeq8nrUfoGbiuHNraN3dkd0skkFA3zEvpk+aJnVn1HM6Jq20t56aRiGcpH2o0cXLweg0liKmiDcCC0rVTLVDHw4zu0r5TqyXPV0r1wWtMiMs1/Irbo7Nfa6QDPUtnkUGtLIwNkNgcyeCTpUK90LpQ6qZx7P9ESt9G85MtUYrZLY7RfJ0gid8yc/pnrWXBcO+mQK5o2S5b7YhtmRIDgvztr55XrEh67vlroLgrNb8jaYr8nDMz4i/9lByCpQdb8yQy/5NvY556JdFYDckQVfFZI2EE58KtUVYUcuccC2dtXmn0VRjQ1R67mNN1M1TQ1AGf0mdo1JmD1iSqgrgeONVkGWhNHvACyMuymSAv3ODDMMoQFLYkLE64NgcdAmHWnBTTrLWTajZCIk6ab/c7FKNX/qohLNMdzlwlZVWHjClgupBMitwAspZw2ZsvbTVeCLcjVVRTx6nmWmM+mnCK1M1m0gYtN34UqUkVnyU13gu5hdjshHC6Y8qotNQMLqVVM/aMxuBIzK6oYFKFNMirClvOi9DljNzBUDiHa93ScnhQhL24WJIy4czyUnL7X+4c3NSoj3fn+TF9i5jKlmOtlFxBDjRVI5c2PokHHhJoP1BvEr3EHgaPtjCbeP96Q3CO9/FQ1p6QHskScpLi4OdNF500oQ+7BIGtxXXQ6/VNPe/nAfsg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(82310400026)(36860700016)(32650700020)(6133799003)(18002099003)(22082099003)(10067099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5VNspuapkH17wbM+rVXflo4XP8xHnthNl+oOZFPFwbu0ugA4FoP8rAAUVJs6Yka2Pf9TSkZj8jDB29CK112ociHjGt5B00jAIadlkGTdc2UI8GMXYt1VAeMUUb9rwBk/stqu34Adiy3P+T4PB9eMdUYUn3yiLdaPs4ogEouoY829E5R2JUSrc4IFcPwjvID1T1VQnqBeoAkvC1D+na+ouWQLZxfoeQGeuOcqF+t+YyAZnPqe18nMmY1Z8bLPTs3psdy259oc24hf1xtUyjag9UpQQjQPxYFPD6njODKts36lplHDLXD9rIosqr1OeZ74O8VI8Z1SbXkE9wuewkr4EEKRq0wMQ2nOLq9AW5ex0ZCC2BRhFwfJzrC8XLCib2BFQxENnEquSWrDi2eR7wEJZ/Y8ZNN7UyQLJbqXj9h2mdsKjd55xNr0uBVojEztnq9l
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 12:00:53.0122
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5d7f197-52a1-412b-0589-08df13ea2869
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7206
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D7C218001A
X-Stat-Signature: p4m5erp9wge3o9yan4rkerdyny5p3fhg
X-Rspam-User: 
X-HE-Tag: 1789560066-418585
X-HE-Meta: U2FsdGVkX19fUtu+KfVbW0C3k/ufuJiw/pgURj4cfZnK6o8sQ0U7qdDI9OkuPLRVF7JTOZTanQZVh3g6wrvqE1STl3HSRfoz+Sn3OLceZQwE3zdPIwoqk9eUe3MRFL3NZ/FKIjhUMMrlmgBDq/2OP9k1dk9c8VY5SOosqF5PaV5bya8YnfJLhjyaCAOxJ6DhGsw8GTpKHd3SOy9kLld4MfIHS7IyDuIf35r7Rg6qQVk5vXwaiNJl9Cho/efCfuOI4a+ewArclmSSjAWNxuBMtnXZEnLryuRDekJ5hfQvBEzRinFpE5dB2/WZODOtT7AuI4OyepGaaJpIXOdBVLpejjodEpgNcpI7qyWsBTP7f0uRy4/i0yoD2kmRERfH9oYzJDA1b/WSNjtCdof63gJy4E6BnAW1RiBcENc97G59OiS6esve+ihL/KSydwwgucmHAaXN1jj/5YEpUN1ZLLGmitaxiCv52dvhVLIfXayzJ9PiT4LkN+j6JuCQBz9NgTkaIuBEFBRClbaI0zeR/MFlezRoTZiwVNiP9OjptwBdcT3tg37RoH6VCOllG3sG36DE6thoBVu2LFTCFYZSpinvHYtS+I6IsF4kj0p8t9gHXx0Xgn9v3X/nG7K/Ef/v2oCz7bckj5E232C1bUFwKWJFw7U80ivtlz7xRz5wkqtMCbPwSkUARGWsZF+WTdaHO2FExT4Do5nXlpYK3tzPN2ko68qd+QMmOCJa63gmuA82us8ia5R6F797g9yvi0SQ4A9o0pFegsQdorHAQyLSVqjb7mcWNNTc26bXzbnt5qFhqYnbTzDyx/4XkLosLMIjtPohIMBmfad+fMRnT3ce2isbsltXeg3IvDGr7lyMJZbp4W2jLNERh15QO+N/uCsglTOSupk92kbPhaksITxaRwX0X1lphqT0x9kPcDhE5nBu6MOMscDiyJLrs+Y5FKgQW/XV5DTLIm6p2SEoH5GIBK/
 6W8PRrST
 3Vn70PsrqoU9iJrnoDmprcNQBDYrsvJEx6RZX0bARaXSPADxuvpJxD3sH9A5Ndz/YRreL3+GMpwNdgx31OEDgO1aPmzYpwAYH3KPR5rCI6eEdbwlS7oB+g9TKyAgnweZw/2M81owlg+YI44g9Qa3giaSThN9KGgJ0WDnfQt1BQUrrj6QvGWu6JyX0VIhSls93Dmxq39DN/WiceVe8q4A8AJFyP2vsPQnIwzoaDxETEzTCwWFtB5sjodIpFdirp9RWSCW75j2Xrq+4nbHAjd32R7p6aXsZ/CFWDSwKSbe5X6DVliYubKNMEsqfHm5qZU5ZDejhOr7Ohx2zRB4gcY3v35XZxCgWBybBoM5DfHidWjXsa5FXv1IrFdoJie4hTd7wMPPHIP0r9I2n62yfqN8qaBcu1/GhodzzrSFVGnFqYiTUttibdEkZKCRu392vP6CgxFuowFTZubm6qvLKmFIaq8EkqivLS0nI1AtMgokBYi4QPEtU6sh7OMBEI5fQtJGb1Opt02GfxnIdFGH3Y/PJr4EqXd9SVL0vRgaTinf6xnCsPnrVG/LXZ5UzkMvwlhLMqj6oe0wABJfTqE0iHRbOvmXbFCgOxS6NKFtfabCTxcfYGA41DptvxqP/8bDrobWPDc5nbm98CtYF2e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The SEV HV advertises supported options via GHCB, the guest stores
bitmask in the SEV core.

The sev-guest device is a user visible platform device (/dev/sev-guest)
which provides the interface to communicate with the HV via GHCB.
It may choose to limit the functionality depending on what is available.
The first user is going to be SEV-TIO which is going to trigger creation
of "tsm" folders in the PCI sysfs but only if GHCB advertised such
support.

This should cause no behavioural change.

Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
---
 arch/x86/coco/sev/core.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index cc292d7c6fd1..5b912f42f493 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -1381,11 +1381,6 @@ static int snp_issue_guest_request(struct snp_guest_req *req)
 	return ret;
 }
 
-static struct platform_device sev_guest_device = {
-	.name		= "sev-guest",
-	.id		= -1,
-};
-
 static struct platform_device tpm_svsm_device = {
 	.name		= "tpm-svsm",
 	.id		= -1,
@@ -1393,10 +1388,17 @@ static struct platform_device tpm_svsm_device = {
 
 static int __init snp_init_platform_device(void)
 {
+	struct platform_device *dev;
+
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	if (platform_device_register(&sev_guest_device))
+	dev = platform_device_register_data(NULL, "sev-guest", -1,
+					    &sev_hv_features,
+					    sizeof(sev_hv_features));
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
+	if (!dev)
 		return -ENODEV;
 
 	if (snp_svsm_vtpm_probe() &&
-- 
2.55.0


