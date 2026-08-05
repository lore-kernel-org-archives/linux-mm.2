Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55C3C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5A556B00AD; Wed,  5 Aug 2026 02:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30CF6B00AE; Wed,  5 Aug 2026 02:42:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47816B00AF; Wed,  5 Aug 2026 02:42:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75D296B00AD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:42:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 01785A03E3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:22 +0000 (UTC)
X-FDA: 85066271766.05.93E5AC3
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012018.outbound.protection.outlook.com [40.107.200.18])
	by imf25.hostedemail.com (Postfix) with ESMTP id CA832A0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="InJL/Oxr";
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N34Ji46MQUOaxw7HEVol/v79VQNhg+WYZSyv+4DFDJw=;
	b=nW2BHUXQP9+M5HQ0ztU4tXeEp4IJc0ydxszqxdoe1Ij3RNwkTI1mPdPW6hes0Ph56clbYv
	/Gogip9PXT/KUtLk3AbjeJq9tvCMaw9v4YyVmNuTMSWUofe8QgmXgo6nOswnidPjdmAr0m
	39SUaZt2vDwld6C7vmXbp6Mlvl0fcSU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912140;
	b=FQbWh69BQytzAsA0D3i5tyPdWvg5XWzQwagQA+mn8bBQR57H7dPB7xBP4Chisp5O4tn684
	a/TzplucVJfGCEFvFzlecDI5/L/WWjBBT2GpLteIKq9Hb6KlnARChNDB2Gf2FG2EZTqj8e
	Diwo/e14L992dHeI9HcgyONwLYoFzRA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="InJL/Oxr";
	spf=pass (imf25.hostedemail.com: domain of shivankg@amd.com designates 40.107.200.18 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LqwfuxTk47EGYmf/oC36WbYWpsL3dbcYZ+QlOdTFwR5jzmkqLTcZFNTceYpcKuKG/V2VL99DtDNBZxoJGYtV7NqJPgBxUvolAMNO2gWV/HcC8Sxo0R4HAbfoDK4hYrlesAtVFGfN3zseTk1Mc4FG18AS2WqlG7v1PUfa1d9uQPumQpzMZaHIjaRIK5v2O81BavoaKkjuaWTYV+e6fSyErBhseZQL1d3bh6eEJVvnDsTy+13/YYqrVfYq/JyOazAax5vVSIQhxGaKBarAE3hJ+KqSzIIw2LrlfTL4OdvSzVlrB/fXWQV8F4ndm9vuGfqG2OKRFF0UhL2qv1IrOran8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N34Ji46MQUOaxw7HEVol/v79VQNhg+WYZSyv+4DFDJw=;
 b=Sp0cNEKSg1YRHwyFeP61bbb32CZ48vHEtDYWpskPrtXa18di6Nm5lhMHnrcY8O7LMsj71PGwbgTJUIwErDaQAa4ezOU3QGMuZEoU3vCbXgcXBePavw4GcuR6aLPpIhfgWnsRoutW1cj8ImASfd+t/Q8rq+WEypemJ1U/XzeCLRa4S5hEKCT5exyMPNY1tAyJdiBZafCZY0WTt7o4Jk+DQxhWhUc4yvd0BhXCKlP80+LUrgi9F5ACwefJLHmiXZ9xN1KteLgKs78zxKeYWUGS9XRrWrU0qrShyMIb+snfzatF4Cd+WTqxTPEXvDRFEwMYcykiqlPVmfgnl3vxgLsABg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N34Ji46MQUOaxw7HEVol/v79VQNhg+WYZSyv+4DFDJw=;
 b=InJL/Oxrz1UTTMSpBbCtI9+ByVKu9M7Uj7mS4R6gM1SLFu2zz9DIvxmCmTwDtU5uVJ6f1gZo3fk7X/B5sEtZCxHvj1VpfyqHzq8dnBOfYQMljiO6qV+nLyp3PjxlhYFS1TXYhPmq/C50wYaJYv6GyeO4aUDOPRZNc5GmKp9HAmA=
Received: from BL1PR13CA0099.namprd13.prod.outlook.com (2603:10b6:208:2b9::14)
 by SA1PR12MB6725.namprd12.prod.outlook.com (2603:10b6:806:254::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Wed, 5 Aug
 2026 06:42:11 +0000
Received: from BL02EPF0001A101.namprd05.prod.outlook.com
 (2603:10b6:208:2b9:cafe::71) by BL1PR13CA0099.outlook.office365.com
 (2603:10b6:208:2b9::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Wed, 5
 Aug 2026 06:42:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A101.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:42:11 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:41:58 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:34 +0000
Subject: [PATCH v3 5/9] KVM: selftests: fix maxnode arguments in
 xapic_ipi_test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-5-00d8bdec4e1d@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=1320;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=xdz0cv1bEGnNHOIr7trKMzS64Sig04rLZJRJ4QKywfM=;
 b=Yy5Onvb99RGNj+yemRKzIss6ntKGZUGY0iWot+iDqs9l3dwIpZb5T/DMFlFei27mIKPgCjRoa
 G7XzBp4IAVWBr/DDV3mYKt/wPmxhSwDDpLZ34miJURHzHaPFjE3UAcD
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A101:EE_|SA1PR12MB6725:EE_
X-MS-Office365-Filtering-Correlation-Id: b8bc933e-4613-404b-504a-08def2bcad9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700016|23010399003|22082099003|18002099003|11063799006|921020|6133799003|10067099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	Gk+eew8fEwUbJajpxZgPXZHLzxT0Oo2OolUlY2A+hmJ7xEnsdSLZeN6IL7mei85sNH2nOu5Zh9fMiCSIMHWnmpipNBgduJ9F6dJGuAjDrZrsQCVsoydqqMJ9uOkIkUbUtzNLASw+/vG5WkoFipWD1+ZGkDZdYinKlfID4BRz2LLHAZD3laTvmYm0opJ3qneLUmN0FoewYqee2PchJXAuSSKn3Tm7Q4e7Q1tS+kS3YyHpKBY5z6hwc5eJ/KHdzkwFCbEABZwo8Z8YHOEYYZaGn0jbQIQ5t4PMZrxCWayHoVeLy7i72hb47pjKDhDW1TX5V8VukidyT46RcUzMI3AZ/NL5C36X+nsttDG56DkvOAa30+S2PHXJvmMLywYeEyiMrlqDtFAALVWosUvod/xkDbsIvoujK6tWmhXa0zEwJ/8UlGdzh5g/n4wsINy2eJLfm9bcjAMTCj+LQASS0/35RAPOA7ZfG5WURdmkgMwoMBIK1Ub+kns4kgD8VcoNKWOh2aIHI0xJ85mVombYXAmgiQuPt7LV1TXE+2bESy+vdu23gKiXGkOES/F6lCMDGe6m92J1xE3Q5f1xh+76XN1GfKGYQyJ9zEKxaDcIycF+UsNeykFAigtb1s1kLPPC4f1u5cE+5CTSg4I2brqGZPt7D1CCMiMybXaw7ds0ZKRwfnt8HNuBSy/Le2f4iXXEYa5O9wNXvbqbTvHNXJw0FfITDr3Ffc2C8TPOABQWR/ocgv7QF+O0u6KNZdmTtVIWDFFS
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700016)(23010399003)(22082099003)(18002099003)(11063799006)(921020)(6133799003)(10067099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	+iRfefz4Iv3AXuRVXadVoJrHcSrgIkSCMYnoJpiw9xncj8ZF/s9ZDIF39Ui9pUTrbrknhKqeeW0IFqgzy6gK++PwMuoy+vTcxNLrPizIh5zYcRcbPRNsqXDd+6ukEkx56/1IoyjSZm7ql7Bzu84yf7ymyhzxLQnik5wEBGLG2ielP81ZSkUtzC1OaJloO8l4RsGNp8HL42/Z9ja1jOiJRMHafBRFTG9kEUkNGCANtftc1gND0jZThGX96WQemFYgHLcOQi4WVXeG+FR7l9g9jHizfnQgYY2g7Pt001C7dPUSAdW43Mw5+6+whroKxkymONI8k59QdgNKhGD+IrDoS0u0dPRzAHMdUE164w8I8/vD4xtLtMRSm9FUGtOGANLX/dLugIbYY11EkhTlVILRpDEyAIG4z1OoF9G6I5MUVUOAGSYvttNXNi+a9HwA/OWL
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:42:11.3066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b8bc933e-4613-404b-504a-08def2bcad9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A101.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6725
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA832A0006
X-Stat-Signature: n668qeeumcrxwc3kkzywywhhis7x3i3y
X-Rspam-User: 
X-HE-Tag: 1785912139-798144
X-HE-Meta: U2FsdGVkX1+e8RfLQkYgjod+jw9bzvXUPUnhdwRjJQc57RTMQT/pWVih4gDi5pU0UwAeN+YeOELj2c0eve8R1QLSgubNVgMkOjM++dLAcAdZohKMzl7WgNOFEoMDNl1w1TiGeNqqCVv1Nm5/ASljCqnoI6yef3/nPy+ElcybSgUpf/vIEFSnC/Mj36RcCvpJFzFDokdibLATmtduVNs6gN3Apt2ERzCh8w5yyIXViCh1hBy6vDw3/OyaD67g+ZsdCvDDp8DB5pwDXUyZ0tMdCDJ/qxScmpvS/Ir8WHZyy0zdLm1yIOAIDLhpEwsMn5QxrLLMVz5qf0V6uNn/RCdHGSw8EY/MUxzP0LJ+MbhfO02eZ8DERcx7I9BBvtSMj80EUHCyr7SCQDZsnXfEcmcVzoEtao6To6lWtEpH8CtcvqzqJlXqJNt5XM5BHJzNxH+q/gztgPTAvvTU96lazRl7IOcBJj6UQBrHExkWwUR2Y3VOm7+4sygox8eagowALCSEH+gvOSiJCTcCP5CKhk7K+j1fpGKEzcnZER5PUFGzPIliZ5ZyQZmGjJjSjcVkYwAnn2lY7IcCWcJEQ61/c5uW7+jat/wrE5xHRaOHJAPTidw18h0b3ccR4f6EZTU1nPeVe7HiF3670ckG1+HT9LC0J0078u2LrHgr5+mlUrri/7kTF5Mj3UbUnnLGqZTiaH2xdferYct0+33JVQCu7rm4kWAAMS5CRgoBbT6fbxeFz+auBhBSGOuFRdaPwZXQPrYea7ExiyHkrHe1w7fR4ZTFuu6nCYnyrK9WvwqPHjPJZCO2S4jJatj0ME23a7C90RwY6AHzS3TltZQULLGMIK94NNbwSBVKhsMJWeZ/4GjC+EtSscXLZEAEdjrldFGGiY7kuWCf4gdVImCVu0G7UQ9iIyo6tN27ow3/xXXqdeiJXuRWsFUENNnuhwdfcqP9yYtN3KzUm00AtAMAKTtF5K6
 RXvqXVQl
 WoLwpOh6/0leVKOFT8MOXyghQ4F8bWGyvhjyWYzCrz2A4H6mFTEjY7/vChD9FI9xK6RNxDP8leWVQHKQW+Q4T7IbGdMAo5qmwaQDAWdk3GjhqSUkCWrmqd1lacNxqRUnHIzLEQoiyTJ66H9ED/fsFwxe7FVtxtwljXXqEOdWFsejJ75XPOoTJB2cDrlt6Q1uYmnLC6ZKWEkiL1pEAWdw/DDaYOouLSwYEVYfT32Z82HmeJ/lC4xOMBzc8fjUkNn5/4lOWG2XkBwxPbgThYrz8G3O8Eqtq9p9x9CDGguZMavT5TI0ihYDNbmqsw3CVGlrZbmOWs/3IwKwbMDCPzPJM7ljnngCoh08kmDObp65evJBkuQdZLYtru1pAp13Zxkxc0zGhB7hWDN12nP7DvIXUUCbFSyiqmCRi13tNWKd5dPXG4yvRtsf95Nf/Zr4II5FTK/s4OEfHw/I2+qIBw2RO2xPgbP9ypZDadtl628sG/Tldx/iNqhhGhXDx07XhTfMMLxWEem7/hOOIHXqOcLY1LMSHYtAcWtaFp6XyWp4m8NIQQPpTJjzGYB3hzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_pages() syscall expect maxnode to be one greater than the
number of bits in the nodemask. do_migrations() passes the size of
nodemask in bytes to migrate_pages(). This sets the maxnode to 8,
so kernel only checks node IDs 0-6 even though the nodemask covers
node IDs 0-63.

Pass the nodemask size in bits plus one.

Fixes: 678e90a349a4 ("KVM: selftests: Test IPI to halted vCPU in xAPIC while backing page moves")
Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/kvm/x86/xapic_ipi_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
index 39ce9a9369f5..761e47e4cae2 100644
--- a/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
+++ b/tools/testing/selftests/kvm/x86/xapic_ipi_test.c
@@ -310,7 +310,7 @@ void do_migrations(struct test_data_page *data, int run_secs, int delay_usecs,
 		 * KVM_CREATE_VCPU ioctl. If that assumption ever changes this
 		 * test may break or give a false positive signal.
 		 */
-		pages_not_moved = migrate_pages(0, sizeof(nodemasks[from]),
+		pages_not_moved = migrate_pages(0, sizeof(nodemasks[from]) * 8 + 1,
 						&nodemasks[from],
 						&nodemasks[to]);
 		if (pages_not_moved < 0)

-- 
2.43.0


