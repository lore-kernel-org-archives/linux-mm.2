Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE91C54EFC
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 09:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ACA16B0093; Tue, 28 Jul 2026 05:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D066B0095; Tue, 28 Jul 2026 05:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF2B6B0096; Tue, 28 Jul 2026 05:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2794C6B0093
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:07:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9A886A02F1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:10 +0000 (UTC)
X-FDA: 85037606220.22.4645D8E
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013015.outbound.protection.outlook.com [40.93.201.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id 549094000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:07:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ch64oEVR;
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785229627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VifYzjSZGoKtwW5iIF6tOlJciJLCM0v/2zb5EQpAa0A=;
	b=3EwPs1surxEEd7s9GfJ7qr3WxwjLXPrdHS1mxBz4KCrQz3PPQf4zFQ8bxYSqIMK5ZyFC8m
	AWaHpxQy5Fj52XiF7tEWG55MyH43UyqY4ByLkCmHdjlBReoYelICSkvdpKx1iVwddAhPiI
	5zNcrss5rgjy8R0gvu3Y2PFiHACcvZ0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785229627;
	b=kAKTey4Z9bcszJtk2rCH2eVUDpo53KZvb5PjS/yeEZWQfF+66w2xr6rgg5Wu0psK4/j88n
	Fbb/8/k6fxtgLdusnp+C9n3yf1qRiukN/l0amcSD4cQJ1vzM5zm1MkzI68wqUj/k7CrygY
	Vn2ASvDIvOk0EcxhOJgTLNlAX0WKTr8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ch64oEVR;
	spf=pass (imf27.hostedemail.com: domain of shivankg@amd.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ansdwPal9GvcSIQ3iuWunkHRKOxl1Hu5sEzx3Zr7rxONAyRc0dcBqH+K6Ri68xFDRS6AeJ8xh+fC6xu6ZNLr4IP7/9EAxwki8dJ/a0p7Fprff5dWbRKzxLHRYhJvPy/pVH0PZd34kbOHMK6VsaoRwASXILUpRVjmaAYiQQtOLciyt57P62W1NqUIiYc9HcDvuJEoJhlDjGVb0qjfZuGyNpGgJWAkIHupBdxt57Tn006J7p+tck/IXFDrWnkt+udkjBNoD3AmxAsojgMz2eblYSdFlxEf1fY2jcx5obg3kg/aVnRt7I2jTr58HVLG0fTugl8wxfaAFx5wSHICDIbtEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VifYzjSZGoKtwW5iIF6tOlJciJLCM0v/2zb5EQpAa0A=;
 b=XarkWw612ftbq9rEf79GzugUZnqFLmnkAuDxDmztE8TX3w6WU0/p5sKW8Y53FukMVhYXQVIxRt7stAGiAFHOJ5nEz7O98Xlvv/lILaGx802JS1sEd8Kl8qTlCqMFDBMYcuW2wNvp+YedPYsa6AlBPFLR55ylU1ZpUfojqh2+3K0Ssj42noVR9mABtU9l8UT47IAsdtFG5qE6dxYjruU5rost2cBSHFvvK2iUtT17URKpJR5cy4AfaF76mPoVOo/9kvCbefyN3H+EUZDF5qF8q48MwaCMR37VymYU3geAUDgxP8Ah2KeAug8o1j69SRDK06Q0J3FyUn+tvckBjwOSJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.alibaba.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VifYzjSZGoKtwW5iIF6tOlJciJLCM0v/2zb5EQpAa0A=;
 b=ch64oEVRRXXSPRK/i32NQjKAgmrKYRJc1w4DDzJcryMF2kjdto657Tj7dI+/42WFJX88JHzj5qIZA0F5ugK73VXOp9fAWRn2rqj9Nnnkxjfnk/rXZHVay4yDsHKDu+YnzHNVTUe0q0P0l7zG8A/tJW59AgdU0o9N49J942ytazg=
Received: from MW4PR03CA0207.namprd03.prod.outlook.com (2603:10b6:303:b8::32)
 by CH2PR12MB4119.namprd12.prod.outlook.com (2603:10b6:610:aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.13; Tue, 28 Jul
 2026 09:07:00 +0000
Received: from MWH0EPF000C6191.namprd02.prod.outlook.com
 (2603:10b6:303:b8:cafe::95) by MW4PR03CA0207.outlook.office365.com
 (2603:10b6:303:b8::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Tue,
 28 Jul 2026 09:07:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MWH0EPF000C6191.mail.protection.outlook.com (10.167.249.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.5 via Frontend Transport; Tue, 28 Jul 2026 09:07:00 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Tue, 28 Jul
 2026 04:06:50 -0500
From: Shivank Garg <shivankg@amd.com>
Subject: [PATCH RFC v2 0/4] KVM: guest_memfd: folio migration for
 non-confidential VMs
Date: Tue, 28 Jul 2026 09:05:33 +0000
Message-ID: <20260728-shivank-gmem-migrate-v2-0-269ac1f84e2b@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN1waGoC/32NQQrCMBBFr1Jm7UgSabCuBMEDuJUu0mTaDpJUk
 hKU0rsbcgCX73/++xskikwJLs0GkTInXkIBdWjAziZMhOwKgxJKCy0lppmzCS+cPHn0PEWzEp6
 ttK3shpMwGsr0HWnkT9U+4XG/QV/CmdO6xG+9yrJW/61ZokDllNbDaPXYtVfj3dEuHvp933+Ut
 z8huwAAAA==
X-Change-ID: 20260611-shivank-gmem-migrate-8c1c519b30a6
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
 Tng" <ackerleytng@google.com>, Fuad Tabba <tabba@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Vishal Annapurve
	<vannapurve@google.com>, Nikita Kalyazin <nikita.kalyazin@linux.dev>, Patrick
 Roy <patrick.roy@linux.dev>, Pratik Sampat <prsampat@amd.com>, Ashish Kalra
	<Ashish.Kalra@amd.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Ira Weiny <iweiny@kernel.org>
CC: <linux-fsdevel@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, Shivank Garg <shivankg@amd.com>
X-Mailer: b4 0.15-dev-47d62
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785229610; l=3732;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=SLQi18eoZj86Llp+lWDnOsrCYvdyBKQWIZHLvBCmlws=;
 b=5efGPm1+eSiBTsT/smZVADij8yblCcW4gJplmsUE8Wb2rJuD1LjqDCXQjzJAkmdRnxRA7ohdV
 9vWF+wUhmiuClYV25b+56aKDI6aIvPm+5rf0PjOwE6eZOz8luleZJdg
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000C6191:EE_|CH2PR12MB4119:EE_
X-MS-Office365-Filtering-Correlation-Id: aa8417be-4082-4893-f33c-08deec879595
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|36860700016|1800799024|7416014|82310400026|376014|11063799006|10067099003|56012099006|6133799003|921020|18002099003|13003099007;
X-Microsoft-Antispam-Message-Info:
	hCUAwKUKaZrq052vyWfkX9s22QfcFcgA/80gDOauK9DXAwUkUGzfeWdLBBjfw04yfKWnKa7bmP4yyONl7xdaSmdBDVBxnoS4fzi0YCMk8gkMJljzCmOjUpxbrgdJZdVDIlrhbS0Cd63r2j598qCaeZSiaLt8+gUPBeOUMxqa13R5W00MV/v6tnZ0es/C3BGkAha1Igw19F4OWVbrKViJ95EBXceRIL0onIY2Oy+Q/kLqdQoCNd2yXTxaPLbgQEQlnxzUSaR8ILrznVoyLXKYCMHUGkxAFs6xoseA6qcTEwsTbvg7mzsadpsHItiEtrln3k5SLQB2vTMF+U3EBEF326/xnmWwbe4bcvqckm01iBFevqH6Op99e54uCVtk/2sgpsPIPvnR7jvRSSP71NxJZceOHTa57U0hnSf88cnVXTFTpH2v5AFr7m4X/njwKBjHuTBfzmBwh3LpXqiW3Viu9ERkkbmYP6X0d3u84+56T7zdHWhNe010DSdXsgiHDXiSa6d14vsoi8zTgUcss0K8R8rGAH+hMkkQoF+9YeJNfL0gjiK3gMJ1aV+EmcabEghZ2uRby7onJJCulbRnRYv94AbftWA3iKgixZ8W7c08UY/r7sPZzj67qOl/wJzTjoZps8iCIPl/+EYgKwfUdv7HKDsHSZqH541HNB4QiwKhbds+iBnkE3N68V/sRKriVJ1b
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(36860700016)(1800799024)(7416014)(82310400026)(376014)(11063799006)(10067099003)(56012099006)(6133799003)(921020)(18002099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	OfCpiRSJyr2T3taXPyWfa+7rE4qO44P+lQrhuYAQzbV7patRCIxAhAw3JmuAi2q1YTkV2glvhVdQ+HobjBA1mDvgHdu3+qkN27Cmz+Zdf2rfy+nBt7EsYx/6TdpRzjiHnm25aDKqctg7gB8LzMRSDREwMkUtq1+69vLGpbAUT3DAQt8O9iF/4WQ95Rjh1918B0mzPqtqiw+dlJw+L0Qnv9Mo2QSU9EUi8XgNPrb3WY00vuxwdft0kPRN1u+ip39gXY2bUOlzkr5jsk1F7dRvCC7ov9YwG+64auJ8dHKHrKzHJXYTrGWw9B31zo9ztPIKmwvdpktqAbW146ThpjNAwkHU441+tDWiStnEslRN0UFNAoUoP5o2PZUYp1xKvBnzF4rNTRZGSCF90ZZWo9Tbfqyq0WOvxrapFR+8q2AC6mFPc5YXCItcZKZPbUwPb30I
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2026 09:07:00.6714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa8417be-4082-4893-f33c-08deec879595
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000C6191.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4119
X-Rspamd-Queue-Id: 549094000A
X-Stat-Signature: ists9wpkifebx91qsqy14jbofqyoc348
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785229627-66201
X-HE-Meta: U2FsdGVkX19MAwEZV3T8pczAHXdxiUIpOjyxe8dXt7eIjFCvFaLP2npWRVgDQJm55Ixhxwz3/MuDAnB/QQoDhBrt/IUhrHAfySvgQpLeyqJCkiVeZxbNh0OldHygOf9eec2PuEh4YAyV+xOgGMC45rZb6xAGM0Zao4SCiv9o2KzvTXw2MBQvK4TACi4ZEvuDPU9h5REPWXJ2LPEugPhvBpzI4OMgQqWL1Gr0Je40XLUHZxJ2EuCaqsyKtxG/A3WErG2XtXDYvAlTeJNjge/jk1LGIdbG0Z0K9Hf5zLMtUyuyojXnxEw6yPtFB6ZubY/r5gFVmH7yW4oEeL0cnJz4uZ4y815gkByza02c3fDLPZmfmOmzFueKP0Efzd7/kTtLUWmXAEdoEF8FPq3U45fC2497pUE7ohBy7WzZ1uFpwvs0Xwx7M2yYTcJqdPqCCSvNZWGpJhrLJHCZf4GrFw1PTDYa9/0OGBy5X9KU2TyCawiTmnLyQuw6u4zk4EPo3oTmL9mAS348ZiTERjh5ckr/2HnVNFFBJJADoTdz37X4mONJJNDZLUDSebjNeiBKEZt9JwmAd6zX3TIA88SWKnYcWMkhpt9NmatLGl6Rrb2okjY9ukAXaKe+lFQJX45/M2rr9K+99AwK/GLj1vUlh6B44iBnlnmb70gJOyKCKT+DxGSukC24Ge7FdinvpW9jQPXxl9WNkEWt1ZD4oCc/OFDIIBAUEgPHh2RYBwrfoVUIDQuJ1CFV/m8sG6XRzQ5Q3CXtKhKA6EIXfU1xg+nXiXSMQJhGe18RFTO9dyHCZBS+4pgkLsuoeslplk7mbUWEGX82Iv78KtO/VCxcz81HZPzd/iOrJYAl+svr2dsblcmG1uTw1jpATpQcMruubamMlCsPRpPRd0IFtF1pSXiuyIRlpu3PIotsHBmi6CKAv8cL5LcZ6JHMdcKJvR0lNegsewNMYIkNjbWbiL3BLMu4YH2
 i5UgttCv
 wmqwwROrxFHp3LX8E9dLZD8/ee7W3lOuAAulvqskXb6hoXm+YutkSBcw4nol4RoYzFodwqyLxyOpFZlMrlvL5j0qHoIAFRBkfrCy7ujrT4ybNLsDZcRpw6+EqRo5uWs1w1Ldxq/cyLzxB3pkPt/c5uD4b34qb6w7MG0EdUYlK3YLLBXiLvdcAxsoJqWzNS1IVFycM8L4IdSTMhG7n4ZGUo/Zt9+MJuOCr+Nqa67nTCkg/B9wtRhT/YX/2zwASF1/XSve00erCUIe5x26f137FRsRq1PmDMfSksRHS09u5wCc6xSr8+IXbweqeo74XMfr8DO9+Q4xv+Ss3IcUScnMq40lbpYRoHMw7beymd6vPMwe/VJ3jo3K+5x0bcBC5I8Mv59HMWZvrLdp71TuVSy3F6ddYvbRkvudEPZMuQcRLYK4rzvtm52ewBZDp41MP0dPgeAboHgMKY6/i5bnGWndy8YSmaciCH/db9bRFOz7ofpORsSMPxnbEuNlO6NGI53rvRsPIM1MlDN7AjUZ7rqJimRPXZENLoi2IrtRQoMpiAiAkushjCqpvsdz0xdZWJi6lH5H2Xhe/DRhicpZOzm7wgRjSVGHyH77ZsdJpxKrsuXHpuZ59vkniXRcXJi3udEV8ZXgBJ6ZEqAdvMuPioO2hsynqORVnWQzhu7Rb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd folios are currently always marked unmovable, so the kernel cannot
perform memory compaction, offlining, etc. This is unavoidable for
confidential VMs (SEV-SNP, TDX), since memory is encrypted and copying it
needs firmware assistance. However, for non-confidential VMs (like
Firecracker), we can migrate the folios.

This series enables folio migration for non-confidential guest_memfd and
also lays the groundwork for migrating confidential guest_memfd later.
Once firmware-assisted copying support is available, those VMs can be
made movable, the confidential folio content can be copied separately,
and the destination folio marked with FOLIO_CONTENT_COPIED so
__migrate_folio() skips the host-side folio_mc_copy().

Testing
-------
Host: 7.2-rc5+(62cc902415) + this, 2 NUMA nodes

- KVM selftest: allocate folios on node 0, migrate them to node 1 and
  back and verify resulting NUMA node and the folio contents at each
  step.

- Firecracker [1]: booted a microVM backed by guest_memfd. While the
  guest was running, forced host-side migration of its folios via
  migratepages(8) and explicit move_pages(2) of guest_memfd
  pages. Verify with /proc/firecracker_pid/numa_maps.

Notes
-----
- Sashiko pointed out a pre-existing ABBA deadlock between
  kvm_gmem_error_folio() and truncation. It's being addressed separately
  by Hao Zhang. [2][3]
- Sashiko also asked whether selftest should dynamically discover available
  NUMA nodes instead of hardcoding nodes 0 and 1? This feels like
  over-complication for an artificial scenario. [3] So avoiding it.

[1] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-hiding
    In builder.rs, add GUEST_MEMFD_FLAG_MIGRATABLE to bit-2 and pass it instead
    of GUEST_MEMFD_FLAG_NO_DIRECT_MAP to vm.create_guest_memfd().
[2] https://lore.kernel.org/all/ambEdSPjerZIVN0b@192.168.1.215/
[3] https://sashiko.dev/#/patchset/20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95%40amd.com

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
Changes in v2:
- Make folio migration opt-in through GUEST_MEMFD_FLAG_MIGRATABLE,
  preserving unmovable behavior if userspace don't explictly ask. (Alexandru, David, Sean)
- Add kvm_arch_supports_gmem_migration() so arch can control whether
  GUEST_MEMFD_FLAG_MIGRATABLE is advertised.
- Allocate movable folios with GFP_HIGHUSER_MOVABLE. (David)
- Keep guest_memfd unevictable. (David, Sashiko, Sean)
- Split migrate_folio() implementation and enablement as separate patches.
- Update selftest with new flag.
- Link to v1: https://lore.kernel.org/r/20260611-shivank-gmem-migrate-v1-0-2d266bfc6f95@amd.com

---
Shivank Garg (4):
      mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
      KVM: guest_memfd: implement folio migration for non-confidential VMs
      KVM: guest_memfd: add GUEST_MEMFD_FLAG_MIGRATABLE
      KVM: selftests: exercise guest_memfd folio migration

 arch/x86/kvm/x86.c                             |  9 +++
 include/linux/kvm_host.h                       |  4 ++
 include/linux/pagemap.h                        | 24 ++++++--
 include/uapi/linux/kvm.h                       |  1 +
 mm/compaction.c                                | 12 ++--
 mm/migrate.c                                   |  2 +-
 tools/include/uapi/linux/kvm.h                 |  1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 82 ++++++++++++++++++++++++++
 virt/kvm/guest_memfd.c                         | 53 +++++++++++++++--
 9 files changed, 172 insertions(+), 16 deletions(-)
---
base-commit: 62cc90241548d5570ee68e01aaba6506964e9811
change-id: 20260611-shivank-gmem-migrate-8c1c519b30a6

Best regards,
-- 
Shivank Garg <shivankg@amd.com>


