Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8ADAC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:42:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0BEC6B00B4; Wed,  5 Aug 2026 02:42:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6DC6B00B6; Wed,  5 Aug 2026 02:42:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC4F6B00B7; Wed,  5 Aug 2026 02:42:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 470B76B00B4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:42:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A4051A03D7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:56 +0000 (UTC)
X-FDA: 85066273152.28.81DA111
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010010.outbound.protection.outlook.com [52.101.61.10])
	by imf26.hostedemail.com (Postfix) with ESMTP id 65CD8140005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kO2Fu8CJ;
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KklIybxAVesquBLCUQC12uQsLRjArXF17xfa2W0HOEM=;
	b=oU1NXcP49vU9XqiPTGiqwcfRZJ8FEPlMwolNI1vz2/Y6/MFyaLz5hYFC7kYQX+UAHUupdw
	SYa+HvZfhUIVqSQiwabCtV29xWCPe4H/1lgsoVbhw0Co3JWNCn1noHbDXsBZnGCEMhprPC
	H3P7Hem50H16+gBUguE8l6dwdMbohWk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=kO2Fu8CJ;
	spf=pass (imf26.hostedemail.com: domain of shivankg@amd.com designates 52.101.61.10 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912173;
	b=kxQPkScWkmZfOq3ffPl4C140ji8BdMLMe3zhafTeNoAuuivLMwAgIa8ML4HjACOAV7UnAz
	4BnlNV/JiBywJDZ8zcpArTxY9al7145do1a6iz9e6n7uZzJ+HZy6PNfewtLxSND0KCK3v/
	idqTaK7lbgG6ZB1BiHPAf+8G82JDaaE=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qMhxJLBQbIhFe+o8QIRcSpMzMhVTFFezozalyL8n35CZZFw42uyH7IFGM89jSl+KBffgx5M6cKnPcB5d0c2dABgnboY5rOEhksEVVwcC3EPQYc7cVtJ+CvKknCyk02c7dD1UdPp8mwRk5vPnsAmOjDtpGIp5bEbJrZc/YIXKfvcJj9lHlHWka9v5blaBHQzCFi7c+QjHwhTq0KiuoEZFZ6hjNyBf20ArD4GynGCqf+hdSX2aFvDROXRGXCWB0ebk2bK381MMSNKrYbcPgQQ7hASUSZfE1HRqcksho2I+zWeXE4JDHEeAinLtkDptUOHF+6ydWKvO3NKbIL+uzPnNxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KklIybxAVesquBLCUQC12uQsLRjArXF17xfa2W0HOEM=;
 b=mFz2A4dyqvzT0qnE5DD+VLKCD2Es5cbHyvXK+bDxBM5XyER+hAVUyy5hWyfV6qPb+Qq3imriwBSnVLQ6ebIJVcQSijFw7vwun4GQ9WbF+Ewcn3sUajD9rZrghdvj+0PgA89Wmj4yqm2W7bYZIcpFwlLAedaYYRmv3rL1SntgLFDCgpDWTItlr60Asc5mLAyIpKq0Vi8rln7JsRmo5zIdQ2NCW7RCexafPYyOT/Jm4MT9EMsftg66S8vbBwz8IV9qCVQr4Y1YGp9ask+9CBPY0+1Dc3yohp3nm/asdX+Jt4kaQmugd0JkM00sbKgQZadcwRsA+ifm/SHm+CJdQJWZXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KklIybxAVesquBLCUQC12uQsLRjArXF17xfa2W0HOEM=;
 b=kO2Fu8CJWPfPLEUtu3UkpVDyrEHGF1UcD9xeGzzr2QxJpslmoS2sLT8iEpfDM9/v+nbqNvTHHmBkWnzOIXwpbA6kN9Dm2slzY/03LA3yLqWa+gElb86jsElynEgCac/vXOWwhZJGNfdp8PhY/LPJpSlgpTXNOV+Gf5fCoYzHsnE=
Received: from BL1P221CA0040.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:5b5::15)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Wed, 5 Aug
 2026 06:42:45 +0000
Received: from BL02EPF0001A107.namprd05.prod.outlook.com
 (2603:10b6:208:5b5:cafe::77) by BL1P221CA0040.outlook.office365.com
 (2603:10b6:208:5b5::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16 via Frontend Transport; Wed, 5
 Aug 2026 06:42:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A107.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:42:45 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:42:33 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:37 +0000
Subject: [PATCH v3 8/9] KVM: selftests: use allowed NUMA nodes in
 guest_memfd_test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-8-00d8bdec4e1d@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
In-Reply-To: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka
	<vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
	<david@kernel.org>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, Chao Peng
	<chao.p.peng@linux.intel.com>, Nikunj A Dadhania <nikunj@amd.com>, "Michael
 Roth" <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>, "Ackerley
 Tng" <ackerleytng@google.com>, Sean Christopherson <seanjc@google.com>,
	"Vishal Annapurve" <vannapurve@google.com>, Nikita Kalyazin
	<nikita.kalyazin@linux.dev>, Patrick Roy <patrick.roy@linux.dev>, "Pratik
 Sampat" <prsampat@amd.com>, Ashish Kalra <Ashish.Kalra@amd.com>, "Thomas
 Gleixner" <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Peter Shier <pshier@google.com>, "Jim
 Mattson" <jmattson@google.com>, Ricardo Koller <ricarkol@google.com>, "Ira
 Weiny" <iweiny@kernel.org>, Fuad Tabba <fuad.tabba@linux.dev>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-doc@vger.kernel.org>, Shivank Garg
	<shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=9670;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=dXBKg5fXAKj1J06FIg2E6wP+hH1T9We3hGHWo+1DfNo=;
 b=fEnKoB4vUmtZB8Gn/rrd7s8r/2ht8VXIf6eXKlSSKmEeHW1pP9j7LmJE+1I1geWMb4KMAFZ94
 BwEelGLJTQJAFGuuSutcmpWgWzQ5RqYFrqMUaJzbD1PZUieRevGjmqv
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A107:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d0b4bc4-6280-4b60-4493-08def2bcc1f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|7416014|82310400026|1800799024|10067099003|921020|56012099006|22082099003|6133799003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	uxNxHJuLF3R7JCfKtcEfwbwUYIayFowGDM5XEwTUIGTgwERC+/FCHLREoWylThshr1K6buKjwmRR1tMv5z8iR6fXtmKxbk3vsmq4Z8KvaS8qMBtsPrd8pGaykWt1+bNFmCyTWbW4fr/CnOqte2Y7zUAqNiRnWRCh7NsRd/3c9LPEJmUEXmcWJ8pjXcqFYg7xy5sCFv9Lv4fm5BoMsVqFkUK+HW8OnwCY480YjWg2ftlNnw3xESrM2rxoSf/lko9e0yWGB6bpgsk6ubZ7JSTA8qZ6nOhj8h62e2QTQRnzUiggqlUT66S1ZEmeK2qEFxNe3r5JSBlnNrslQgay7oxEzhFxvIMe/i7k6B3aH7scNK/pN6ccWOWtqdRXpqjV1OeUS0JuB8wdHqvW9MAMKcHFsrNAwz9t6d5guxt7iJaKYexhUsknz+cQaX6S1okIufIRz13X2F9egDKpBdb9VdbN5NDM3enBMHEH7pdrMBlzC9qUHYGYNfQ+35/18bldGBesbjMx3AmOFPU6+k6g0CupZlQaSrWwMsI1pBFbxGBeFkhDgfbcmg9ndi5Cs0eEJp5WtMvgALbEzw4KuOQW4+t7HlKOGDtMzKzVrOPX6J/+TFjKANOWTqbjtD0MZJv0CLfRaBN/zB8DKxI1OcosER4IMoRaM/xrv8jREzrFITMVx77G0VE3Pksm8fcLxILYjLGQVDhhskLLvEYbfBjvgJQ/z2EgekSOLDS2PImPktgmIu9oUxyr41IFfabLVNgrGwKK
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(7416014)(82310400026)(1800799024)(10067099003)(921020)(56012099006)(22082099003)(6133799003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	umN9UwDa4vIgPV8V1aGAERKrXNwxhqJGshZtyZnk0F/fdSj8w6HU8r7N/AQs3UzGjriiupqU9lnk0Da0LNn82PHFndnoF5Ui29EOGq8uykW/C1l4uwNwado0wbTqE6cp+M+OuGXsBQNxd4V6iII7tPGLSI+x7g0kpxOUfagkVm9ZE2UM+MniN2FysX26Nq19wIt84BMB4bshxzdH0joLJTaPqjLLmP+r4EmL1eFeiDhOdOCBRxBwZpDIrOiYnkc+ep1gsmzFkRRhX1NMvi+Xed6NuRnmjmVoeXsONvr6jCrpQbw2TfzPpLmVsHkWLyHoJGL0+MSSGT7HjyQJ8zhVMPCkXn6bZbMYH5tsoRj6KdFprbeV8VQvvQEQaQuYV7FrxTkPJ8AxfjH0tM853+fVaQD9Gd9lCkKQBa2D7qBGvXjKtQjlJqSR86igPzl0KteD
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:42:45.4792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0b4bc4-6280-4b60-4493-08def2bcc1f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A107.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744
X-Stat-Signature: 6ggznxonjmorkt3qnt3jmssws5t4x355
X-Rspamd-Queue-Id: 65CD8140005
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785912173-898036
X-HE-Meta: U2FsdGVkX19eKW+ZJBCYvg0UXsU1i4boEc8xwxCZrNYJ4n+xQFEHwtG7dXXErlrDKiWV38yY10QqkkRatKUcDNF7XbXFlI/8kptxSccun7RERIBorWovUM3bsjK026jJnD/RX0Kr39BHZsBC2chDGvyNQIUV3w+DfwxrNtLLKxLDWAUL1qGLG4vk0qbCqhW/zxr7LfndVQCheUFLD1n1kB5HpOtIWB9mezdlxuExZ2j6yrnZ+q1idpkg2oSiJth5SOtMDSkM9hzdUvLABMwmji8SWs666vnMNPR5nyvQ9EsKu6hRFYh+2ClVbj/OFpOzBeCa+Z+4D15qmaKNjlxyPYBjy2vt9EVNDJtsI2PQRcYJ7WmESNQsanUKmrNzJn0w/dNjA47o4og2q3hmxurCFfvqpYLhdNGy3GDwImdU+9GvY8q5nOb2gRg5Yn/wkTTn2xWYPeziO/zSkoYmfXWwcVDDA98VqUP4e43lKViaxIpSozyNk4hEvN0elttSmzF5zBEFzQvo2i1mDsAiKvTeUHVQQ27bN+58WwY/GnoQhH7caUgEP0jmrSjeRU4EHiVqzrMpww88l1RfRFwVcPLKUq7hjAZCd7ENT1zUUBBYM5zumSUBPIpP1zQVW0hVlj2iwzhEi7qPvub2dxxXpWgebwiZCHtmeulzNNx2NlGU4uN2k6EwNVge15wmy+2sEQyaHxG+zIf6UlVmslLaAS0hYvH5g1F1Y0BuSsbpdAKvvfHJa3GSOuURe/7UfrtOojRQKQKbTxTq39xmxZCo0CBZQuwnfYT46b0hPpa53nm8cx5p10zfTyzNWQszsoGTzzq/SelJz5Qp9cSJpz+xkRJiYQq0NCfRoCHWUl/HSJs3ZSV3wGggU9QXT+1aYo8a0y9oyvzBbNa5joYWUETixDbFAc469UOEbiaxQCbpjE3nHStF2W0g5JWiA462T9zZUbM30qstK9xJXDf0eXaeKzE
 0q2XjrjH
 XW/I5R59eGX4nVdNKwTHfpSOeceKPZOk/6tv1dH9RzxBd5kKd9UimnsAhxQqWIq7mRZc6FK5M9x4IIziwKJ1w8nJb6kWu9iMa4GKrYRfM7VslGJ1i5EnP9nsnKBiKp23Cz/QD1R54oO/YY/XbmZnncvvY/fONC8Tz1OWfn/I96UYA0LGQLIkJs0jWh/YNxv9Um/eQxymFS2PeoC6JGR69JJbUTyMThlAnJqNoERXNnbHDfWkJ58HNRzFbB57rnFtZuJaN3K6I7TlUVSMrte3LYvMAa9m0euTvS+u+N0cvCnKzN25dIn5wyHpP2jfe3eMrfP+cGowpmVSTUbIxbc4oBWiapxWrD0u973qmo5pA/oPJWBiynGp3CZsrnsu4kfUbEtpa4S2uiaGFM3BRWE53AiA2xhZoNRj3M9OaSvmvi5fceALfhWhOPXu2I3hy6i3XD5ese8yJyCIQEp+FYolVftJ4YziE29MsXzTPhxZ6dStlKpMRUkiyVkfVk3nzXsRN6VnGWwnw/EmEAXO2UkO3fwscAGFC3v/61QkGfNJrBz71SYIUdnr88Qa+rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd_test assumes that nodes 0 and 1 exist and have memory.
is_multi_numa_node_system() only checks that the maximum node ID is
nonzero, which is not enough for sparse or memoryless nodes.

Select the required nodes from MPOL_F_MEMS_ALLOWED instead. Use the full
nodemask width plus one to mbind(), and let test_mbind() run when only
one memory node is available.

The sysfs helpers for finding maxnode are no longer needed.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 86 +++++++++++++++++---------
 tools/testing/selftests/kvm/include/numaif.h   | 52 ----------------
 2 files changed, 58 insertions(+), 80 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2233d871a38f..aee80dda6229 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -76,33 +76,53 @@ static void test_mmap_supported(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+/*
+ * Fill @nids with the first @nr_nids nodes in the allowed mask.
+ * Return false if the mask contains fewer than @nr_nids nodes.
+ */
+static bool get_numa_node_ids(int *nids, int nr_nids)
+{
+	unsigned long nodemask = get_numa_mem_nodes();
+	unsigned long nid;
+	int nr_found = 0;
+
+	for_each_set_bit(nid, &nodemask, BITS_PER_TYPE(nodemask)) {
+		nids[nr_found++] = nid;
+		if (nr_found == nr_nids)
+			return true;
+	}
+
+	return false;
+}
+
 static void test_mbind(int fd, size_t total_size)
 {
-	const unsigned long nodemask_0 = 1; /* nid: 0 */
-	unsigned long nodemask = 0;
-	unsigned long maxnode = BITS_PER_TYPE(nodemask);
+	unsigned long nodemask, bind_nodemask;
+	unsigned long maxnode = BITS_PER_TYPE(nodemask) + 1;
 	int policy;
 	char *mem;
+	int nid;
 	int ret;
 
-	if (!is_multi_numa_node_system())
+	if (!get_numa_node_ids(&nid, 1))
 		return;
 
+	bind_nodemask = 1UL << nid;
 	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 
 	/* Test MPOL_INTERLEAVE policy */
-	kvm_mbind(mem, page_size * 2, MPOL_INTERLEAVE, &nodemask_0, maxnode, 0);
+	kvm_mbind(mem, page_size * 2, MPOL_INTERLEAVE, &bind_nodemask, maxnode, 0);
 	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem, MPOL_F_ADDR);
-	TEST_ASSERT(policy == MPOL_INTERLEAVE && nodemask == nodemask_0,
+	TEST_ASSERT(policy == MPOL_INTERLEAVE && nodemask == bind_nodemask,
 		    "Wanted MPOL_INTERLEAVE (%u) and nodemask 0x%lx, got %u and 0x%lx",
-		    MPOL_INTERLEAVE, nodemask_0, policy, nodemask);
+		    MPOL_INTERLEAVE, bind_nodemask, policy, nodemask);
 
 	/* Test basic MPOL_BIND policy */
-	kvm_mbind(mem + page_size * 2, page_size * 2, MPOL_BIND, &nodemask_0, maxnode, 0);
+	kvm_mbind(mem + page_size * 2, page_size * 2, MPOL_BIND, &bind_nodemask, maxnode, 0);
 	kvm_get_mempolicy(&policy, &nodemask, maxnode, mem + page_size * 2, MPOL_F_ADDR);
-	TEST_ASSERT(policy == MPOL_BIND && nodemask == nodemask_0,
+	TEST_ASSERT(policy == MPOL_BIND && nodemask == bind_nodemask,
 		    "Wanted MPOL_BIND (%u) and nodemask 0x%lx, got %u and 0x%lx",
-		    MPOL_BIND, nodemask_0, policy, nodemask);
+		    MPOL_BIND, bind_nodemask, policy, nodemask);
 
 	/* Test MPOL_DEFAULT policy */
 	kvm_mbind(mem, total_size, MPOL_DEFAULT, NULL, 0, 0);
@@ -112,7 +132,7 @@ static void test_mbind(int fd, size_t total_size)
 		    MPOL_DEFAULT, policy, nodemask);
 
 	/* Test with invalid policy */
-	ret = mbind(mem, page_size, 999, &nodemask_0, maxnode, 0);
+	ret = mbind(mem, page_size, 999, &bind_nodemask, maxnode, 0);
 	TEST_ASSERT(ret == -1 && errno == EINVAL,
 		    "mbind with invalid policy should fail with EINVAL");
 
@@ -121,17 +141,19 @@ static void test_mbind(int fd, size_t total_size)
 
 static void test_numa_allocation(int fd, size_t total_size)
 {
-	unsigned long node0_mask = 1;  /* Node 0 */
-	unsigned long node1_mask = 2;  /* Node 1 */
-	unsigned long maxnode = 8;
+	unsigned long bind_nodemasks[2];
+	unsigned long maxnode = BITS_PER_TYPE(bind_nodemasks[0]) + 1;
 	void *pages[4];
+	int nids[2];
 	int status[4];
 	char *mem;
 	int i;
 
-	if (!is_multi_numa_node_system())
+	if (!get_numa_node_ids(nids, ARRAY_SIZE(nids)))
 		return;
 
+	bind_nodemasks[0] = 1UL << nids[0];
+	bind_nodemasks[1] = 1UL << nids[1];
 	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
 
 	for (i = 0; i < 4; i++)
@@ -139,34 +161,42 @@ static void test_numa_allocation(int fd, size_t total_size)
 
 	/* Set NUMA policy after allocation */
 	memset(mem, 0xaa, page_size);
-	kvm_mbind(pages[0], page_size, MPOL_BIND, &node0_mask, maxnode, 0);
+	kvm_mbind(pages[0], page_size, MPOL_BIND, &bind_nodemasks[0], maxnode, 0);
 	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, page_size);
 
 	/* Set NUMA policy before allocation */
-	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
-	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
+	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &bind_nodemasks[1], maxnode, 0);
+	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &bind_nodemasks[0], maxnode, 0);
 	memset(mem, 0xaa, total_size);
 
 	/* Validate if pages are allocated on specified NUMA nodes */
 	kvm_move_pages(0, 4, pages, NULL, status, 0);
-	TEST_ASSERT(status[0] == 1, "Expected page 0 on node 1, got it on node %d", status[0]);
-	TEST_ASSERT(status[1] == 1, "Expected page 1 on node 1, got it on node %d", status[1]);
-	TEST_ASSERT(status[2] == 0, "Expected page 2 on node 0, got it on node %d", status[2]);
-	TEST_ASSERT(status[3] == 0, "Expected page 3 on node 0, got it on node %d", status[3]);
+	TEST_ASSERT(status[0] == nids[1],
+		    "Expected page 0 on node %d, got it on node %d", nids[1], status[0]);
+	TEST_ASSERT(status[1] == nids[1],
+		    "Expected page 1 on node %d, got it on node %d", nids[1], status[1]);
+	TEST_ASSERT(status[2] == nids[0],
+		    "Expected page 2 on node %d, got it on node %d", nids[0], status[2]);
+	TEST_ASSERT(status[3] == nids[0],
+		    "Expected page 3 on node %d, got it on node %d", nids[0], status[3]);
 
 	/* Punch hole for all pages */
 	kvm_fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, 0, total_size);
 
 	/* Change NUMA policy nodes and reallocate */
-	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &node0_mask, maxnode, 0);
-	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &node1_mask, maxnode, 0);
+	kvm_mbind(pages[0], page_size * 2, MPOL_BIND, &bind_nodemasks[0], maxnode, 0);
+	kvm_mbind(pages[2], page_size * 2, MPOL_BIND, &bind_nodemasks[1], maxnode, 0);
 	memset(mem, 0xaa, total_size);
 
 	kvm_move_pages(0, 4, pages, NULL, status, 0);
-	TEST_ASSERT(status[0] == 0, "Expected page 0 on node 0, got it on node %d", status[0]);
-	TEST_ASSERT(status[1] == 0, "Expected page 1 on node 0, got it on node %d", status[1]);
-	TEST_ASSERT(status[2] == 1, "Expected page 2 on node 1, got it on node %d", status[2]);
-	TEST_ASSERT(status[3] == 1, "Expected page 3 on node 1, got it on node %d", status[3]);
+	TEST_ASSERT(status[0] == nids[0],
+		    "Expected page 0 on node %d, got it on node %d", nids[0], status[0]);
+	TEST_ASSERT(status[1] == nids[0],
+		    "Expected page 1 on node %d, got it on node %d", nids[0], status[1]);
+	TEST_ASSERT(status[2] == nids[1],
+		    "Expected page 2 on node %d, got it on node %d", nids[1], status[2]);
+	TEST_ASSERT(status[3] == nids[1],
+		    "Expected page 3 on node %d, got it on node %d", nids[1], status[3]);
 
 	kvm_munmap(mem, total_size);
 }
diff --git a/tools/testing/selftests/kvm/include/numaif.h b/tools/testing/selftests/kvm/include/numaif.h
index 55124e2330ab..4bbbf314e9d7 100644
--- a/tools/testing/selftests/kvm/include/numaif.h
+++ b/tools/testing/selftests/kvm/include/numaif.h
@@ -4,8 +4,6 @@
 #ifndef SELFTEST_KVM_NUMAIF_H
 #define SELFTEST_KVM_NUMAIF_H
 
-#include <dirent.h>
-
 #include <linux/mempolicy.h>
 
 #include "kvm_syscalls.h"
@@ -30,51 +28,6 @@ KVM_SYSCALL_DEFINE(mbind, 6, void *, addr, unsigned long, size, int, mode,
 		   const unsigned long *, nodemask, unsigned long, maxnode,
 		   unsigned int, flags);
 
-static inline int get_max_numa_node(void)
-{
-	struct dirent *de;
-	int max_node = 0;
-	DIR *d;
-
-	/*
-	 * Assume there's a single node if the kernel doesn't support NUMA,
-	 * or if no nodes are found.
-	 */
-	d = opendir("/sys/devices/system/node");
-	if (!d)
-		return 0;
-
-	while ((de = readdir(d)) != NULL) {
-		int node_id;
-		char *endptr;
-
-		if (strncmp(de->d_name, "node", 4) != 0)
-			continue;
-
-		node_id = strtol(de->d_name + 4, &endptr, 10);
-		if (*endptr != '\0')
-			continue;
-
-		if (node_id > max_node)
-			max_node = node_id;
-	}
-	closedir(d);
-
-	return max_node;
-}
-
-static bool is_numa_available(void)
-{
-	/*
-	 * Probe for NUMA by doing a dummy get_mempolicy().  If the syscall
-	 * fails with ENOSYS, then the kernel was built without NUMA support.
-	 * if the syscall fails with EPERM, then the process/user lacks the
-	 * necessary capabilities (CAP_SYS_NICE).
-	 */
-	return !get_mempolicy(NULL, NULL, 0, NULL, 0) ||
-		(errno != ENOSYS && errno != EPERM);
-}
-
 static inline unsigned long get_numa_mem_nodes(void)
 {
 	unsigned long nodemask = 0;
@@ -87,9 +40,4 @@ static inline unsigned long get_numa_mem_nodes(void)
 	return nodemask;
 }
 
-static inline bool is_multi_numa_node_system(void)
-{
-	return is_numa_available() && get_max_numa_node() >= 1;
-}
-
 #endif /* SELFTEST_KVM_NUMAIF_H */

-- 
2.43.0


