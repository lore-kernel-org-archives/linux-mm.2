Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8A6C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11FAE6B00AC; Wed,  5 Aug 2026 02:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F7A46B00AD; Wed,  5 Aug 2026 02:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DB16B00AE; Wed,  5 Aug 2026 02:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C7C836B00AC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:42:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 415321203BF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:11 +0000 (UTC)
X-FDA: 85066271262.19.A08DDC0
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011052.outbound.protection.outlook.com [52.101.62.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 09A251C000E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=H2qyaRsG;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.52 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785912128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ze9sg6BRov+gURM7aaIAO711ZASBEebsh+lEEAUSNV4=;
	b=zssS2k8rhEm0zeCBHBQMqms3uG91falwg7eVhM6G/M2ftz12BsmE2TlreD9buBRAY+IGRF
	MZHqJTM1nFWrKQKx2uEpIIpe9G42qlgoHKpPOH5XaMfG8SWKJdUvahw7srE3Qt85XOFvGG
	ytZ/6rn132ojOL4UnP3kAOAvu9dXrgg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785912128;
	b=PX6a9ntaHAzW1Xtv4eGi7Idj0D6jOcWLOP8qkZGDoY7IRbwr7CLcC9KaanHXDBY82UV3I+
	5Gul5lmRgYVwAO9MDoyWHbA0P7cNlTDF4azU5LDGJXDdf20Vz2mBgSK25CKyOUZp8x6fTq
	7ZvbDLi6NjPGzTSy8RLuZdLTaZ1xXQ4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=H2qyaRsG;
	spf=pass (imf20.hostedemail.com: domain of shivankg@amd.com designates 52.101.62.52 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pX8sGB7EfTBvqUv6iJpYdWHyd48fZQlX3YU54xxvTr80RhEpWTWaj8nQgdB5daCRof8bUmqWXRbDOXitv4pCutPewFMV4ljb5/KhidmToTwhAG60pgj9mhs+vZ6HLIdaSL2q5PWIaLgXRIQbv5rF1lb4sSC3KnfTwph3ch56DMTBSKEI26wTNv4cUezaDRsVgAFm6le5JD8/wt7Z5kjFY6B0Pc7Tp6qiMJ6ZJ+JQpqy9wzLSfbRweSaOoPSOovEGhZVZZVq6pZWQVFwKp4t36yC0hCJhCZiLLhrav9hFaGQUUkfw6DHj6cEaqYXeRhaoDxLQ6k5/ixQyNggT8WCT9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ze9sg6BRov+gURM7aaIAO711ZASBEebsh+lEEAUSNV4=;
 b=jw3eGQlhcdIhC5InluGbeORsM6njEmmc7p1pZfuQ5cAjlCYeYiV8K+yfFf6xnSG05/uR5THmjBbfG5NJQXlUpkAvL2ullNeZEYeFkX0Ikb/n+5lG0+6+/F9xzoLV7LOAEdiKtYLg+7WHESVrmtcqtl6hIN+3t0hQu9+2rmPi5uqgsfdDcj2CzUUcDCjg0mla8tBPE7XrJ1ugyXVRFn5h8emT90ea6yEItbR4gB3uROdjeqHLn+oFAh3kajVMGOaO06Gp4WxiSq4k97OtwApsAn9s7s7QOhnx9U8H27pgKIryVFNn8mTuozpZXoLsnhDyxbAjDEAh9716pokNdlXO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ze9sg6BRov+gURM7aaIAO711ZASBEebsh+lEEAUSNV4=;
 b=H2qyaRsGFvTK+tgCYK713GgTmC477VAfcWHn82SA/oHW8roAa5p1xb4FArDe2cCOJADoHMUgXHMjsm/J8CO4bCgYPXn0SovdgifQNSCr9FUzGKPjVjvRaYWY5jkz+VmEBHsS9x1I/otlCMCtY3JMpezNLeMRaKwrTJQB+z1+zbM=
Received: from BL1PR13CA0429.namprd13.prod.outlook.com (2603:10b6:208:2c3::14)
 by DM4PR12MB5771.namprd12.prod.outlook.com (2603:10b6:8:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.12; Wed, 5 Aug
 2026 06:41:59 +0000
Received: from BL02EPF0001A106.namprd05.prod.outlook.com
 (2603:10b6:208:2c3:cafe::56) by BL1PR13CA0429.outlook.office365.com
 (2603:10b6:208:2c3::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.16 via Frontend Transport; Wed, 5
 Aug 2026 06:41:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF0001A106.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.292.8 via Frontend Transport; Wed, 5 Aug 2026 06:41:58 +0000
Received: from [127.0.1.1] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.41; Wed, 5 Aug
 2026 01:41:46 -0500
From: Shivank Garg <shivankg@amd.com>
Date: Wed, 5 Aug 2026 06:40:33 +0000
Subject: [PATCH v3 4/9] KVM: guest_memfd: add GUEST_MEMFD_FLAG_MIGRATABLE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20260805-shivank-gmem-migrate-v3-4-00d8bdec4e1d@amd.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785912059; l=5974;
 i=shivankg@amd.com; s=20260518; h=from:subject:message-id;
 bh=UW99vnlEjKtw6Uukt3JuYaFIVOn3I1MNi2dXAdU8AWs=;
 b=QioaAc0rylkmD5ljqpqwKygsTAxiDzwteGibPSoESiYh/jhguOG48+7BL6wZ8qGynJF4Faw5L
 54297XX8mAeDs4iW9Q2PxiXND2Pvg8lwOIDsM60dtwtyUA2QeFCWo31
X-Developer-Key: i=shivankg@amd.com; a=ed25519;
 pk=2l2QGTeXuGkZTtfmx0nPQU8iFZfjYmX/ymMojitevx4=
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A106:EE_|DM4PR12MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a64408e-bfcd-49bf-e9d4-08def2bca61c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|23010399003|376014|1800799024|7416014|82310400026|10067099003|56012099006|11063799006|6133799003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	VTeuoAfeSMKToxYS5Bg0XSbXkwizvMOPkn9eE4DaXy8JqyPHKCEleen4yefteRWjY2iqOOWV6g8A6s0MoUK6s6Vum+cQJrd6+fOjdLabBit9pDNStBI0bnd7wR6eNOduO3pS3hKa82EyKzy5G5ZIS/N9uqwHrX/lgIw+HST2l2o1NqZR3g/R1HwPG9QCR3iLWrzezvls+zwQhPfCg75POo44iei/JbTK+TP3KFp1x2cXWrjtJSZnGd4YBZ6J1HiA/FtbUsFb1798FENLUXqdvb7Xd0cCPtew4wmM5188+rUNCyK6N9o7LBiuxBpzw8pP3rECtFkysMUtJQKOj0am2934TRJopocGw7q6go1tAJyqaH5E658AntMQDiosU0ZPX7FqpsXqclr/Kbl9RwiGwj0ZeU9wI4nHmZ/55XPwtbeu6Foyv7IC7hEK/hzbeGLS3pctVUu1rmrQswC3F7evxHyS5QJ4aTT9LL8nELfDLJHbirdg5no9ABI4pS6eMjlhiWbtfmV3JI9h7h89glI778B3knuwbrfdJqzfDnHVuNayW6q5TgZXmu4T6wuuFaqretrf+m3/10KdeMrLxJHjWUrTRzuJDP3S/z0SnJnXaj7HwEPxtu79gXBRGvHaqZ3m+ZJa8KO3CN+q0h5VlZc1xJWlntiSM0yY0sruTBv2V44vkIws5FhHhry98isZCspvtUHFMjIEPhL5aZSm939y1XIwggC8VLM1kJ5967ukubU6JhsS/oBz2oXxusvcprc2
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(23010399003)(376014)(1800799024)(7416014)(82310400026)(10067099003)(56012099006)(11063799006)(6133799003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ZrBelWsLTZD5TBr30msZ39WTC87si6zQAy9Mk8wEK5Fi4ZX4ozgvNwhHNjaU0l0h2ukfglRBqQIwT1nNy6/xvClYACkCfGoE6ycNAyWVV/dJ0CCZNi4Hr2PJCJTTItoWV2QzwvyHp/6xuTJndJHZHocaKkw3B5MsgdCP2PdDWZSeQ89Rw5YqAR4ejiq6K8VBrjucOaKPvkvmzTG9zBxqeuWOV+2kPgFWNG8pQOiKJsIC3m9xNyU9t0hLxccSch6c4GdzctKj2MTczNHmTKoBMslErkcgxoIXfcfMFPBGiqrGlLdcl2af5XyBQ5Woc7/xKhFPNeKqVnGXkn6edbujVHua7JbHuzNeVGnlUgbEVpXHly2+FxrAFrKorS56ITAQwAZb9LJqjgm3KAUNTlPd7vEsp8NIhMSy8+cTC9R2QiemXsGd1Zi3iaXr+co3mMoT
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 06:41:58.7517
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a64408e-bfcd-49bf-e9d4-08def2bca61c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A106.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5771
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09A251C000E
X-Stat-Signature: 4fiiqk6xk4c1z8gxg3oe8qhzyhsop1rd
X-HE-Tag: 1785912127-228575
X-HE-Meta: U2FsdGVkX1+1lvdcay1oVfycR8imBrxnAO6wkeunh120P35itNnp7qRC0kSQWjKcIfR0Xno9EAaRjXySdONiBRwbBz95mIkl/TFUvidRvVt/2zY4Av35TeV83WMvPncjmL0q9YxjL4O1Jsf2CZT2uawBwEStp8meZRe947eM0bbkCuR69TcQ9gRFkbCamKNPtGCRELojCOV5DcPggJgHWqM7moJvYghppvYm3XrvsmTnEMXoKT4Osg6HT5XMUF0xCFm7TAzAuEiOiyKmAHvUJ2Gxi6NlIpXhp1LwD+siIW7WI/1FX16TvYMPMxSLkm/8I9MaClfkbwTNI9d/IpzZ6eDNw2V7d2jiW5PtstEs85v7cbDjalr+MqSJ9xbxLjveyxbykdsXVaNqQ4Jrl29pc3A+8l/Q+JXrhJDEB6/HLVUuHVS+eLI6YoYXZqrTZsUg3+8sn1KRxD0IbAnq8m3KUJycSZEsKUWUF6GgIV2Qhb2rXM5m9w4pb0SpDzynRMw9CvVG5BX9HUs1tig6zR3YZX0ZGOOHsLMisqlno4IwDrvEClaY1w0o+vGH2tHSovvgfWWWt/0VJwz9LxYP8RovKe9ssJEpoaXm5dGdJ5pvMSEwfeJT7qGUkcDXUXZd7jgBTnrKvdS7asz9eIvl+805/RyEf1RaezqxwgkxjhFOd4+JxCZAfrLeJg6+0AwdiNgYZgOAWzTTTAf9cQQOib+Lqg648kUtZM1nXctL5fOYXpr74tkQZMl8POesTNBlTB2R9EeN9lldspEQ8huEucaK70l6KCzgNzARf51JgHXN1UQHwCQp3GPyxFGs5BMG7qnVssfRsa9keTJO+pYBI86wPgxXLta8Lw1ge7zIiczBTvgkmQZS/MYNDhEGMHaOUQqPdqKf57c9ES1qexZm+FPS6/M1et+sZZ5Lxb3oE8Q91J4QUehjRsp+Ozbvyvg9wtphwxxXwd6ruDEvMai3Pcg
 AI+Y9dkj
 tsC9K1ndNA/pi8gKNySQzTRAgMhI1U9JXrj5anKejkQZPTHWVAX+yOXnSbqXdtkdQMS4qGs4+BW2v0/UmTFfdbj8vPuGXKGRMR/rUY92tl98qvuJMUgZ+rJgWg0k7VUiRJt6/FVyX8pe3O1Rr0b/+RypY7Bd8mNUDdB9DnblvdFTPkXWdpRCc/2wi39anWRYSE8Q5dx5F46V2p7HbdfzYiXQL/apVk+qSoAKzrqAfH5seAVNFhSdKWwFiPKebsWXSjj174C1ReE/qnGsPKIOmHy5irqwkNKGVVo3588Bra4LH6RvLJVBYyJN+x8FCStINZyzf5dBdAioAZD6QP+ufpTBJjuMH7eonGwqF88WEt/mxkS4EVMNVDy6CWlymv+8Qt4mKjM/KxeezPupJ0Yx1aozixp6ZmckQgvU2An6oNtjk1+/XfoFjS6IaO3CtD3WNoN7Nh1di8TVc2W6VPY4f5htK6ySb9UxXtxj04Mo6xm4hc9mLpIG5Ty8Aom8HmyInLzMZWSRGh9RNawkJfQhAcgIxyGXWUeaxKD0oohrmq73tO0k02C3EUrerBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd folios are currently always marked unmovable, which
prevents the MM from invoking ->migrate_folio callback in scenarios
like compaction, offlining, etc. This is unavoidable for confidential VMs
(SEV-SNP, TDX), since memory is encrypted and copying it needs firmware
assistance. However, for non-confidential VMs (like firecracker), we
can still migrate the folios.

Add kvm_arch_supports_gmem_migration() so an architecture can control
whether migration is supported. Add GUEST_MEMFD_FLAG_MIGRATABLE so
userspace can opt-in to folio migration.

For opted-in guest_memfds, use GFP_HIGHUSER_MOVABLE so their folios can
be allocated from ZONE_MOVABLE/CMA and grouped by mobility, otherwise
keep the existing unmovable behavior.

Remove redundant WARN_ON_ONCE for checking unevictable mapping.

Signed-off-by: Shivank Garg <shivankg@amd.com>
---
 Documentation/virt/kvm/api.rst |  3 +++
 arch/x86/kvm/x86.c             |  9 +++++++++
 include/linux/kvm_host.h       |  4 ++++
 include/uapi/linux/kvm.h       |  1 +
 tools/include/uapi/linux/kvm.h |  1 +
 virt/kvm/guest_memfd.c         | 18 ++++++++++++++----
 6 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e3003a241d5b..976921527ef9 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6461,6 +6461,9 @@ specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:
                                without INIT_SHARED will be marked private).
                                Shared memory can be faulted into host userspace
                                page tables. Private memory cannot.
+ GUEST_MEMFD_FLAG_MIGRATABLE   Allow MM to migrate guest_memfd folios.
+                               Availability is architecture sepecific. Without
+                               this flag, folios remain unmovable.
   ============================ ================================================
 
 When the KVM MMU performs a PFN lookup to service a guest fault and the backing
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47cb9eba113b..7087b0b8f973 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14130,6 +14130,15 @@ bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return !kvm_arch_has_private_mem(kvm);
 }
 
+/*
+ * Migration of guest_memfd with private memory is not supported yet
+ * as this may require architecture-specific handling.
+ */
+bool kvm_arch_supports_gmem_migration(struct kvm *kvm)
+{
+	return !kvm_arch_has_private_mem(kvm);
+}
+
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_PREPARE
 int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_order)
 {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index ab8cfaec82d3..7b2f15b21970 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -731,6 +731,7 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 
 #ifdef CONFIG_KVM_GUEST_MEMFD
 bool kvm_arch_supports_gmem_init_shared(struct kvm *kvm);
+bool kvm_arch_supports_gmem_migration(struct kvm *kvm);
 
 static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 {
@@ -738,6 +739,9 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))
 		flags |= GUEST_MEMFD_FLAG_INIT_SHARED;
+	if (IS_ENABLED(CONFIG_MIGRATION) &&
+	    (!kvm || kvm_arch_supports_gmem_migration(kvm)))
+		flags |= GUEST_MEMFD_FLAG_MIGRATABLE;
 
 	return flags;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8..e1615a62ed78 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1654,6 +1654,7 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_MIGRATABLE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 419011097fa8..e1615a62ed78 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1654,6 +1654,7 @@ struct kvm_memory_attributes {
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
+#define GUEST_MEMFD_FLAG_MIGRATABLE	(1ULL << 2)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 583341d593c9..a2b7c2f1c49f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -589,6 +589,11 @@ bool __weak kvm_arch_supports_gmem_init_shared(struct kvm *kvm)
 	return true;
 }
 
+bool __weak kvm_arch_supports_gmem_migration(struct kvm *kvm)
+{
+	return false;
+}
+
 static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 {
 	static const char *name = "[kvm-gmem]";
@@ -623,11 +628,16 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
 	inode->i_mapping->a_ops = &kvm_gmem_aops;
 	inode->i_mode |= S_IFREG;
 	inode->i_size = size;
-	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
 	mapping_set_inaccessible(inode->i_mapping);
-	mapping_set_unmovable(inode->i_mapping);
-	/* Unmovable mappings are supposed to be marked unevictable as well. */
-	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
+	/* guest_memfd mappings should be marked unevictable. */
+	mapping_set_unevictable(inode->i_mapping);
+
+	if (flags & GUEST_MEMFD_FLAG_MIGRATABLE) {
+		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER_MOVABLE);
+	} else {
+		mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);
+		mapping_set_unmovable(inode->i_mapping);
+	}
 
 	GMEM_I(inode)->flags = flags;
 

-- 
2.43.0


