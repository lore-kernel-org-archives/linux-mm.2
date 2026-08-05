Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A95CC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E616B00B6; Wed,  5 Aug 2026 02:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565436B00B8; Wed,  5 Aug 2026 02:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4561A6B00B9; Wed,  5 Aug 2026 02:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C15F6B00B6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:43:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0757A1C32
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:43:10 +0000 (UTC)
X-FDA: 85066273740.04.7DC4896
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010061.outbound.protection.outlook.com [52.101.201.61])
	by imf19.hostedemail.com (Postfix) with ESMTP id 73CFE1A0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:43:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=thk3Ob3U;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912187;
	b=Z0rYLsCfHwwWrexLVrFGjcBlNMTpqE68uxw/azUNso5Zbc8xqb6HeobyC0FASULEBdOXB1
	TFmTZbdc3zaT9Fh3hPH/YfhWdSMOcQWE4oY1U7kKh+UC2W8shi2Hly381d+UjUvy7foyXR
	kJxY/P2kzOf54Iz/OzGvQxlDxCwuvIg=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=thk3Ob3U;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 52.101.201.61 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KluDXZtvgna1o0d4YwHrU57Xg7C1lgIo1nAtgZVkTzU=;
	b=anOffyhMO/uOpoJYwZgXFARBPzeDEhXfXpqEfn62ea4Ug54XILvRL95PbplANA62BKkDt0
	UAoNLxQZtkLBjZPws0A+IZdQtbu0raUsfX083KmeDsJlJJS0UEZKdroXdOJUh9QD3hVjW4
	7HyjsfxoSSWY3XGNOshckOmvrghw1ao=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KDRfZ7YhNtS11dC0lciJEJH34WzsET9kXwKNWkn6/Fx+Jr9JTr7EgwPgzSy4euRe0o4VaQj9IuhuNYIMmUk2PF3KDXYk+d/WgCgSjneucsijjnRfNfXiAly5ZIMxARdXRPSoXwi3p8fd2KHlpYB39K/wLAK9mQfV2b/vdEkexKoKCOSNP5hBws5MJJFnwYISrv2dpgOTsxUPnXPmKTqu2RTRGAq3sms5blaKsYxT7SCVegrlxal4yQP3KKZ27Zp70FdA0gchMxXzPJfNr8CYwI21TQ1jbavlgmhmeofh6smlNg1vt6UiXZ7LPcHyYk0WBwhiakgmMKfGwH8/FCcP0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KluDXZtvgna1o0d4YwHrU57Xg7C1lgIo1nAtgZVkTzU=;
 b=gdEKfzVCL8gNdHmkIC68rvfaGJIjh8NighUzfW+NUu7zhkTBR6ojMCI315Gy1F84FmDYWbTyw/uVQvkmTdOIZmRSRWiOBennJC+PNh6ViCZR+DitZOR7ROq1QmPq63j/JGq77GMTxTQ9o49mUzUKc7LC2qlxLD75QwwsyoP7/CLdlNU44YttRJeMiZRYJQq0Rku+6e1/v7SkCCundTxAkAn1L5C5OIVWD9X1jvIPLELfR2sI2A1qi9MF7nu16FdPJFHAQaZvFM/f/5zZVMjSRaaBBcSl/NZ5uCjf6CRkgMIDx9QXZL02g/sFNLpOIDjabPIgHkADBRiIHY9nmrQWTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KluDXZtvgna1o0d4YwHrU57Xg7C1lgIo1nAtgZVkTzU=;
 b=thk3Ob3UoNAwasxdD3XhBKJmpHkXOj3SLpthqGZgZmrpgOdIYb3ImcBHUIehUy32T1W03yER8kNxq7imN2RrIFGACLphOHJhz4prsk0JUh1ZsYd5CB+MBjY5Gc5Fglpmiu/m2TdTJhUD6u28acq7QVfBFL7t4DVbY6EOw+490fs=
Received: from BL1PR13CA0275.namprd13.prod.outlook.com (2603:10b6:208:2bc::10)
 by CH3PR12MB8234.namprd12.prod.outlook.com (2603:10b6:610:125::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.15; Wed, 5 Aug
 2026 06:42:57 +0000
Received: from BL02EPF0001A106.namprd05.prod.outlook.com
 (2603:10b6:208:2bc:cafe::1) by BL1PR13CA0275.outlook.office365.com
 (2603:10b6:208:2bc::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.15 via Frontend Transport; Wed, 5
 Aug 2026 06:42:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A106.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:42:57 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:42:45 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:38 +0000
Subject: [PATCH v3 9/9] KVM: selftests: exercise guest_memfd folio
 migration
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-9-00d8bdec4e1d@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=4976;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=x9mCImPZZ95LBaPAvQM4Yr+g5CzISa/q8Behw3tOl54=;
 b=o0gAm+7J32zcBqS0662iidu5c8LsJs0m/rRg3/FnQlJK94ko8zN6sChtFrw9F+gAxsL/ozB18
 dW/FSFHQtONBFWmm/Mqy0YoxKwJqL8Rm3Lt5Yq812EGhHHTmDfSJ2WE
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A106:EE_|CH3PR12MB8234:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f2cf7af-9d70-4ebe-0a8c-08def2bcc927
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|1800799024|376014|36860700016|23010399003|22082099003|18002099003|11063799006|56012099006|6133799003|10067099003|921020;
X-Microsoft-Antispam-Message-Info:
	rp5waTDFcRdw3JW5v3hkTCy7geZlxfLzqo3rYQf+9gJ99YpSnDOabce+5U9gmVEqWmmBAOgYf+e7003wNoGKeXnf538SDE58MAq+t4NU2yP/BhN1zsRzc4yxInF50t+jMX3NhR9oBMbLcSTjwtJVbilK099P8McX3rY6+H44840uiPg7Dib9X/s/hskR47QUL5mavbwuXaORi6zsxLA5xX1IoIjsiMGRFuZfpdNZaTWFnsUWvcCXBZKZ0GT7wwJBKHodkn52qZ+zFhcr/37+kH//LgW/h2lx1OHTMQVUvxgzi1wX4l8xq8JcvOdWmwcMaqwJIquv/73WiQjz7lzlNJJ0+Cfbxg2Gd6bx/zglmfAMI8vSKS6hhm8ZMuuxADSR+nygTlHY5A3z3Nkc7I0s/9OaVgO1qdhN9+wny5ZoO3Fl4xCKwtJfjgCCr+mjRL7KfGRJawf/MUW7tn7NmV2TFyjcJzJvtEg055VNOrdAZVcPX2A4YeEJON8Iq4WBdV7NJ7VRGMuvLpbWCBYlvelHlovCG8euc7ASDNswcnO0bHhdjkXpVL56MBjTAptkb+nimVkz8L81D+PYKcAn7aRAp7JpYJUJw22qH2lP1ibY0rPb4Rj1KKm20fbIqB1z0FlGhezltKvdca5hNAuNwD5pnPnPN9xhC+XgXIFvgLb+HpbGHEmNejhxbK8cSOAjUf0WAkiTsam5Jei8RoqMeIOWK6I52prO8yvub4v+/kinbfMQUpFyvNG+wxV/SeflxSpb
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(1800799024)(376014)(36860700016)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(6133799003)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	UWyezu04rPxAuE7/3/xmw0GJCyaDA+ommDVJxVFejAbK3pihVH8OIx/tQ5jDFaIZB/zTFwdxUiOFTiRTKMi++EgrwXdXlES/1aIkez/j8NjZkVfYxd4y9qpiei5SFi2VBe+TTKdGlxeLOaSpWcYxCIJ6IpzxQJw/cGdJfCJBAW/mxlIUgynpQiCWFn0JYNgxhdtwVkSyODrmCDT0HKUiNurk1fJCIQkatXuQH27jTpZZgYZkIMmC0qbSKVQMQe4Olmr/UHvOHIEjc/+uj0vyeoogniagfYuUoYpN+r+hgj93tjvq9pBvJ6MiQljemnf1WaTOvZwq5wtnOuvpxfiQQ+i1k5YMiMHSZKDaIDn0cogIa8thsW4c/ct7d1ihWvbY1lTGO3EUrOzKIis1DaHslwF8ZdY1CJGywIv9A03wlDOXhsTIjdE/DOXd0uVip7z9
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:42:57.5300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2cf7af-9d70-4ebe-0a8c-08def2bcc927
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A106.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8234
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 73CFE1A0006
X-Stat-Signature: erqttpc3rsqanhkx4mn8zpxezi4t17rc
X-Rspam-User: 
X-HE-Tag: 1785912187-53166
X-HE-Meta: U2FsdGVkX1+RlKEkGo0JrFHtlh29LdU5qCwOQiGSRTuuY7IsQYYcoKOmyGWb38W2Q/5A+bPPZf/p3c9PzYTi+4NKn1rkRtoLrDmFLr5QIRsfndUluE/fYw7HaKDQtxbi2oB14/BLi0Ahq3QGK2sjuD+gNrDluuW5qZ5jHCOtFxfwg7xuS68M+kLCyq3BQ9l5WJ5fm+OMBms2tOdLOEv61zMi5kwRnl5S4qYGt2Lfr40A4ZCoRcYR3ruKBJxxpYIQAWR7IbNwWnhvSfCdBbFnRpfhVBNopmxwk2P/Z4wtAZZ8EDf/qyaBjwZTO14upYkOf73657C1DNS1H+YGxylbOId6RbX4tzVXJUTX3LH/HZ0APHWLf5aJe5xFrDE3IZeEsVFwhplnh7CYGtAgJhVI0Qp+BkTvJJky+eqtZMTvWzb00hBbh+cAWKaWw/hX7X2qQZz392dU4E2YU0sJlq3US3PIIgCbdTm0wpy/FBM4iwdy/fN66ZYKOOMtwqzyC0BEMPlNngMbAfQVSVKgAZK+/hY7oecFfoAuUBv6Q9WGlwFVomscW4/nbPeJJUq98/uSGASba78cE2L1Hv4z2f5KttY88qDCYXVJf8oOcHGv0OMGrIkchEWrbnPdU0Mg8BC4ODrhCnR1Ko7b7/o98hDxQrBAtH635e7nzIW7/SvB/wZoz7ShPHbSNkZUKHmJ00DHF7gsyd2U2xm0xMKWrR+/9LzwrbpMAwaeliuw9gSZanlxUeX8UONx2FVo0Z1BZcxO9pyvDT+X4IQRMCn2YmYoKQVUdKLbPmmeOenZnzwEJfLMZYUY3s98HZk6t0XCTwbGA+zlXeA9jBwTE667/XpINWWjWgOYX+wyoLdxOMe4atJNlS/nD9uPSkl5KpsMMMRb4jTAQiW81c8vstNSeP2/1V785LGgm89XDO8FUE0ezRm80tbuzd9YsA9VfLIhQpfbOCEaETqBc95Pnsbyp0I
 UcIDSVrQ
 w7VMDe7ILH4KhCAU98Q5QLyj+HP/9Tuca9y8LAG+9nQB0zZgIccl+ZWuENBw19bEzALIHxQVNQdvjjC456OAvGrkuuDjhtQeysgCWrHPu1d0ggrmBGbaAUVQc7sZ8sRPkIT8zxgsF4QeZQDRcUCGmGus966nxOAWUmuMi80DApmSone7xynZYEaluo5Pyjh4z7a4FHZ5EZo1K0l78OrIWERwfwJDfTvTVxA7m6coUCoiET/47OxPzoaaY35chG0pYD9cHTd0OVnD4ZMMakGImBPo3oSjcK0fo68bHTQQOQo7ppWpzVtawAbOT1rUIw2FNL5MfWctjUPH6ecShx9XEL2+cu7wZ8PccvJ9eTfbVLlVN8WnPPclNokz8YOSNOlq1bMVHDMUgCNm7aZEViuecq1p4H7eVudlTH3UFilw3sxkLIVU5FgTf0WFfbh5xvHeRp1O/UyDaRgrRRXbKRYHc9bPutHIMfOXVp4odbZv1bQxPqgoof5FEfFlmTBtADBpHiip8ioWchk5+UVHytgjhnKrSfRwu98gBI+huhUgbfIyb0HkfcUTch/bitQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a move_pages() test for guest_memfd. Allocate the folios on one NUMA
node, move them to another node and back, and verify their location and
contents after each move.

Migration is opt-in so verify that migration fails without
GUEST_MEMFD_FLAG_MIGRATABLE and succeeds with the flag set. Also run
the existing guest_memfd tests with the flag set.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 107 +++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index aee80dda6229..6e1c551fec80 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -201,6 +201,102 @@ static void test_numa_allocation(int fd, size_t total_size)
 	kvm_munmap(mem, total_size);
 }
 
+static void verify_pages_on_node(char **pages, int page_count, int *status,
+				 int nid, const char *when)
+{
+	int i;
+
+	kvm_move_pages(0, page_count, pages, NULL, status, 0);
+
+	for (i = 0; i < page_count; i++) {
+		char expected = i;
+		size_t off;
+
+		TEST_ASSERT(status[i] == nid,
+			    "Expected page %d on node %d %s, got it on node %d",
+			    i, nid, when, status[i]);
+
+		for (off = 0; off < page_size; off++)
+			TEST_ASSERT(pages[i][off] == expected,
+				    "Page %d corrupted at offset %zu %s",
+				    i, off, when);
+	}
+}
+
+static void move_pages_to_node(char **pages, int page_count, int *nodes,
+			       int *status, int nid)
+{
+	int i;
+
+	for (i = 0; i < page_count; i++)
+		nodes[i] = nid;
+
+	kvm_move_pages(0, page_count, pages, nodes, status, MPOL_MF_MOVE);
+}
+
+static void __test_migrate_folio(int fd, size_t total_size, bool migratable)
+{
+	int page_count = total_size / page_size;
+	unsigned long nodemask;
+	unsigned long maxnode = BITS_PER_TYPE(nodemask) + 1;
+	int *nodes, *status;
+	char **pages;
+	char *mem;
+	int nids[2];
+	int i;
+
+	if (!get_numa_node_ids(nids, ARRAY_SIZE(nids)))
+		return;
+
+	mem = kvm_mmap(total_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);
+
+	pages = calloc(page_count, sizeof(*pages));
+	nodes = calloc(page_count, sizeof(*nodes));
+	status = calloc(page_count, sizeof(*status));
+	TEST_ASSERT(pages && nodes && status, "Failed to allocate page arrays");
+
+	/* Allocate all folios on the source node and fill in a known pattern. */
+	nodemask = 1UL << nids[0];
+	kvm_mbind(mem, total_size, MPOL_BIND, &nodemask, maxnode, 0);
+	for (i = 0; i < page_count; i++) {
+		pages[i] = mem + i * page_size;
+		memset(pages[i], i, page_size);
+	}
+	verify_pages_on_node(pages, page_count, status, nids[0], "on allocation");
+
+	if (migratable) {
+		move_pages_to_node(pages, page_count, nodes, status, nids[1]);
+		verify_pages_on_node(pages, page_count, status, nids[1],
+				     "after migration");
+
+		move_pages_to_node(pages, page_count, nodes, status, nids[0]);
+		verify_pages_on_node(pages, page_count, status, nids[0],
+				     "after round-trip");
+	} else {
+		for (i = 0; i < page_count; i++)
+			nodes[i] = nids[1];
+		TEST_ASSERT_EQ(move_pages(0, page_count, pages, nodes, status,
+					  MPOL_MF_MOVE), page_count);
+		verify_pages_on_node(pages, page_count, status, nids[0],
+				     "after rejected migration");
+	}
+
+	free(status);
+	free(nodes);
+	free(pages);
+	kvm_munmap(mem, total_size);
+}
+
+static void test_migrate_folio_supported(int fd, size_t total_size)
+{
+	__test_migrate_folio(fd, total_size, true);
+}
+
+static void test_migrate_folio_not_supported(int fd, size_t total_size)
+{
+	__test_migrate_folio(fd, total_size, false);
+}
+
 static void test_collapse(int fd, u64 flags)
 {
 	const size_t pmd_size = get_trans_hugepagesz();
@@ -483,6 +579,11 @@ static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 			gmem_test(fault_overflow, vm, flags);
 			gmem_test(numa_allocation, vm, flags);
 			__gmem_test(collapse, vm, flags, pmd_size);
+
+			if (flags & GUEST_MEMFD_FLAG_MIGRATABLE)
+				gmem_test(migrate_folio_supported, vm, flags);
+			else
+				gmem_test(migrate_folio_not_supported, vm, flags);
 		} else {
 			gmem_test(fault_private, vm, flags);
 		}
@@ -501,6 +602,9 @@ static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 
 static void test_guest_memfd(unsigned long vm_type)
 {
+	const u64 migratable_flags = GUEST_MEMFD_FLAG_MMAP |
+				     GUEST_MEMFD_FLAG_INIT_SHARED |
+				     GUEST_MEMFD_FLAG_MIGRATABLE;
 	struct kvm_vm *vm = vm_create_barebones_type(vm_type);
 	u64 flags;
 
@@ -517,6 +621,9 @@ static void test_guest_memfd(unsigned long vm_type)
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
 				       GUEST_MEMFD_FLAG_INIT_SHARED);
 
+	if ((flags & migratable_flags) == migratable_flags)
+		__test_guest_memfd(vm, migratable_flags);
+
 	kvm_vm_free(vm);
 }
 

-- 
2.43.0


