Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6031C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962946B0092; Thu, 30 Jul 2026 09:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913526B0093; Thu, 30 Jul 2026 09:00:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D986B0095; Thu, 30 Jul 2026 09:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF026B0092
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:00:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D4C1A03D7
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:00:43 +0000 (UTC)
X-FDA: 85045452366.23.B83C868
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11013019.outbound.protection.outlook.com [40.107.159.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id BE65C20018
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:00:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ehFlbI73;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ehFlbI73;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf13.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.19 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785416439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TGN+4FAAC8jIvrpXYh0SLEvL/4I+/62MbZ2lH29z+TY=;
	b=Q+AsSQsEPBbi+742Bv0Cbgwxi2WUo/11qJpQTpS+GfmjECzCP19Zsp3vPklkP7Xf41qRrj
	6+PCK/TZbGgEVBqrCZCCCbSk+s6WuFx6B8GAM2BQ+kZiS5RTFrUBoOJq3yL3P7JGdp7g3n
	8un2dFc+RNRnfMS9FB+gae3jRkSxe/w=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ehFlbI73;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ehFlbI73;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf13.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.159.19 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785416439;
	b=hdLyQ/5QwwGn1mrYM4H4KPq0r093K7DsbAIVtGy8joX6Zl9XrNRdXnIEbjwXNjngm0Ls0w
	GlFMqzDWRY4FmTAB7urSGELWbihjscf9HoWNY/tZ2cV8gzEaFICOwMTDRHkSOV1qdSKrTg
	klcxEcPM7ca/sZFdPezf57UMnddfpTE=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=brhowPZaixhmItoK63D6dRP2HdCj5SxXd89zLkHVw7pOcFVeXeRa6dsm8MDQH2QdjHHroEFd6Vy44UqOzVenBzRaPsvq2w0EKl4/IUBXwYzmU5FD5qK98zkuVHmMIddytylp7fEVQEld1svrp9/gpgB0caXUxONBqz1/LErICzn4gwYGnJsc2+Ui0OSVwjry+j4F6v4JP23HSx/RTzA3YyUr19kWue54mZA4bYjLI4JtNd6PCkBYE8kJv5fNgQkVHSUF7DU8DJg2hcoyi/4JyMN/cq8S6/kq5jWAIfuLSDbG0lV2pE89qdy98lEN93IhPQHsGpZjPMIkgE+4LHtuHQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGN+4FAAC8jIvrpXYh0SLEvL/4I+/62MbZ2lH29z+TY=;
 b=ld77FhXLKU8yRLcwuOJoBUXZowlHzw/KREmKaaKSNP4IboVn1/jT58no8kAbEK6CO7RiQ3p4rix/RkSc9V/9IDg45FUXT8q/DlphJbEYrV4PfD8jZXRgsWDWJMygGRuNeMbioQzSFFGYKFVVCl68TCsTTNZvnv2YGt/BxhdGB3WppribI5+hiH7pCMPEnErfjlebi7ZNwbSJ0KaFmFQ1Fgu0OiackJx4pHAYbXNXv22/TQ/kaXfhMZi/2H7eRZacVj8ZTjeEEZYZGVHsgt6HSgxqEJ5CwmKUZpLR4FO4z6UIGzXJ1PXVATOciDArVN7cGHl4zvT358xsO5m2ssZlpw==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGN+4FAAC8jIvrpXYh0SLEvL/4I+/62MbZ2lH29z+TY=;
 b=ehFlbI73LoxtbByzSNijQF7loKC3ZeZkxXqfibb33CjVmDNBoYQoepnyr1q1+I1wvvtby/Q9VRDpUKgcH09WljEJj8R5a76S1CKxrdWBk6bf1e/WMFtGccv8XgrF/uT+BZ9ZnJ9h1+A9xjW4ASKIJeakwn8760yq3o5hOm8kHDw=
Received: from AM8P190CA0002.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:219::7)
 by PR3PR08MB5609.eurprd08.prod.outlook.com (2603:10a6:102:81::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.14; Thu, 30 Jul
 2026 13:00:32 +0000
Received: from AMS1EPF00000049.eurprd04.prod.outlook.com
 (2603:10a6:20b:219:cafe::9d) by AM8P190CA0002.outlook.office365.com
 (2603:10a6:20b:219::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.14 via Frontend Transport; Thu,
 30 Jul 2026 13:00:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AMS1EPF00000049.mail.protection.outlook.com (10.167.16.133) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Thu, 30 Jul 2026 13:00:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yyx+ToOaEnOvliHo5S5zNq7kYBNmgVSRSL0orMykREc9hqSqjsYxQs6C+lu7IYnDXiqlAhPCkdvWBpA4SH3qEK3mFGCnmqynn1L1wHgf/2D1/REgmU4jA1bZUfu4FJEoB4cUaInXCuzbVMHLc0/hyx9184MDrGAS4+YSQsaH2F8L4/e0zrFC6u2XZRkGkB+IRw+ipGNzOdlsNWrP94fZj8M5j1frcD0vHU01l0imGM/TFij8bUMMESJ4CqovmhZr4gEwzrh75Y7b9jhjgHkFozLm3Ik0uwrs9XixxlPemeJLSTjwELPeh+384IKVCn7ncub1OMEh+EfEplfh0oYX4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGN+4FAAC8jIvrpXYh0SLEvL/4I+/62MbZ2lH29z+TY=;
 b=OPOKjo3Rvy1I4POMIdhajtkJh+RtxKtxGV3xKvUK1yETsg6IzZIMYDDo2cAhLp1PGVZjKFQ6h+aM6JDuMdFWgOTq5x44s+3uUK1oEUbjJLJnVvcq8Ey7XHaO5Lp90rsOH65dFFx0AEyuzASd8q1VpHZVGCp1IHM+Njtzh7zFI5BkKadZCXEjFo2WWCmTIzp3QTVC7Wvb0frWM/amTwik2w880RYlT68zBtZ0gsz6n0kvCxcgn6eF0mUG3KquYfe6ExEhGkpWanzhMxR/C3/ueWLSOH7blAEAxexih86vrVpfwxsrr+Zx77zveIZpbP7Ato2fWzoLhPG2gG6HjGGhVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGN+4FAAC8jIvrpXYh0SLEvL/4I+/62MbZ2lH29z+TY=;
 b=ehFlbI73LoxtbByzSNijQF7loKC3ZeZkxXqfibb33CjVmDNBoYQoepnyr1q1+I1wvvtby/Q9VRDpUKgcH09WljEJj8R5a76S1CKxrdWBk6bf1e/WMFtGccv8XgrF/uT+BZ9ZnJ9h1+A9xjW4ASKIJeakwn8760yq3o5hOm8kHDw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by AM8PR08MB6499.eurprd08.prod.outlook.com (2603:10a6:20b:317::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Thu, 30 Jul
 2026 12:59:27 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0270.009; Thu, 30 Jul 2026
 12:59:27 +0000
Message-ID: <fe1b4098-6ab7-4cf1-ad6b-ffadabbd587a@arm.com>
Date: Thu, 30 Jul 2026 13:59:24 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH RFC 07/11] mm/mremap: use ptep_get() for the destination
 PTE
To: Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-8-usama.anjum@arm.com>
 <50dd77c0-b6cc-43e2-abd5-6d44a29b5597-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <50dd77c0-b6cc-43e2-abd5-6d44a29b5597-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0022.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::14) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|AM8PR08MB6499:EE_|AMS1EPF00000049:EE_|PR3PR08MB5609:EE_
X-MS-Office365-Filtering-Correlation-Id: 2422e5ee-63ab-47d4-de99-08deee3a8993
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|10067099003|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 FC2/f3uqOPNNy96aL5tW8wkHImrCfVxh6gQab1ZKH0Q8V9H1vUmueEs6OtDiI8UtXir4rhhqasBx4ap8cYLSYxigO/kvUNlrkbD2UFdd/IpSC7NMQ5r2AdxEt7Dil8zElmXunvRoE5Tlg5sGnVdcymp/0GRd7uQDnxPOWfgMmzW1CCGhDM3v+DfMPVFosD2QLovucjpI0mdWXiiv3LhVLTTiqh85ygjUz5tiRxrntpo8otSPv4PIgvvvuRnm2hI0to5Mdar/A16FWVJK++gzpBzWDlclVVy9ObW6E9YNTB5AcXTLB2BRmht6C+LJ73SIGkvhND+munjpvjnCNX4GM+dv+iNc2yrnOKf3hduUdhhmqBZMJfBiFIXH6AC6j8q89bevK/2qXILNDQRfolUrwjbzI9gX0tiwMteCnIQTjkYrfh1NWlAMJBqRmVgkez0L1229MzW0FFHciClGqnCrHNlhG9+3JkyI/D1HQnoUBzVW2hMioefk3Nl3IAFu1t0UCQ9ab0zh4eIjPXw+czTd5wh5/3SUeVS2L3txx6cDHO6mWTMfg1iPlJNryIjRZOG4tQgZcfzHN0355IoQ1BJo9CIYMiBMGUUM/pO+t0/1P/UVaidrsdU8W1nwX5nKncAJfTqvDhCcwLQvvX6sZpr1j3KIOss8CU0HxU3z0QangmQ=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(10067099003)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 PJVqIA2lDgDWhewu7hYynL9BtEIPBvddMwyA6Osilo+gjydcsIvk19XXBZt97+CSHOBCcSG1lF5ESd//62FEcnuW0Op041L9mUSopM9qIiRcFzs6jxJ5UjR3ygaJFlN1jkDri8tj2JilMkEJV/f+jXbciV8JLgAAjrVUK1FCu8cKe10e2R3XzHtcJB0d0wf+6uvadBsnplj1Vi9ZrgFvKbcSQ3nWsFAKAwekW3nE4LknTIXxlkyGUKh4agwsjc5N6hK6U9AG4+8fxKtOCwiJW0F14FybdRB0nEtZgFHfgnVXGE59pb5a47YhLFojq6ZdSXR/ked5yu0EJrH2ID3F1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6499
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4668f8d0-8f81-4de8-943a-08deee3a6347
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|14060799003|7416014|376014|36860700016|35042699022|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	O10KOqaXNNUMGR3ls13Np733WLe/+mOUvsHHZK/1xvrOwAaQ3gFyBxD+l4l/yBYETpIfea/UPYyKQXoQWiI0DSf1odiOCn6popV8LeIpeABO8yxkDTap5/ruOMVRfjZLI+0dyHD2AhwqvqDKwora12Uzpxg5urIAPa4gB4EupFRX2Hn9n44kVOaLGJvtbo8AwcybPdx/0cJa2AJXutypzyXOBgYu01V+1NdEtnTlnYyeIniUXiAnZO49zzm2SNvplb2ENgqH6kDZY6eds91aQiTx482FiXo7rQjGer9COEf14KfzsCpgPlo1fLcsJHpS0AhX+6OMTsFA8hsTeu15rGfNPkZrHHJ26Ckw3dA+BOJgVzXOj23My+cRSUZNShklge4arjFOhFMdufo1oPFS8qTpz2tmePAKyDSH7nPAGbR9xQbXnhP39MsUvAYKW9rqMxOtkcT0WsbMA10oUDQ75qNh/i9wl7+THUtbY6fK2MtIFC1s36xsX/Ic+6MccQazOuyXmxWpeY2nLID1Otx4XZpVckuFKv3PMeX4Jz/TThbno8qKIDdQQ82uFvW1ZyzaBwGQdGB3vQ/wX3zoRXr+FkEefBgM9O9xHiFWaZuexJKpGcJY0/ICp7lY2aJEmvGBR/wlK5Irpmo3gcy4rrPqBVgZzL8WivKrJwxuvXgYKM6AzbyC5XB5RWoaraT+RnB+bvHE26VpYqRqh7ejd3XkzA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(14060799003)(7416014)(376014)(36860700016)(35042699022)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	O0tk75Jwa84mlQCh/jghGzah7Zx4wyBrsFKWBapww83B2Rc5zJP6DKPrz2Uug6JPaPNE+9z2QJlnOBHI5eVJvoivlaP5RB0CDEgLDuDWcRD+uFLUl7J24b6Fh42l/El51riqiL/qx8KLaCiZ3QEA+zMCBEPyTCyleaxfiFROcNsSg7Y0+OwvImkIDS3t6ybum1bYLPDeEvQ/niHon1ljqZi8pGpTndyPvy9tSEgttv7Cwu5YZ0FINdmLMPGMOdm4dq6a5pPvgR0KIEK4XtfwADa29iGw+N9A5AaE3kjZpOuY2T60KxAgD44ofaWhiDmg/gIpQeLlQgG0eGkeGaAhv8dZj8ZlgZmaMiccf1N7/RZyq3/dv3uUyldCsqo3IFF21Ksrf85EBWTicCY/fo8/58SOakbPyIkgIp44+9WMgCZzxrQeA0gufUQ9J4l3XfkD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2026 13:00:31.6304
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2422e5ee-63ab-47d4-de99-08deee3a8993
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AMS1EPF00000049.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5609
X-Rspam-User: 
X-Rspamd-Queue-Id: BE65C20018
X-Rspamd-Server: rspam01
X-Stat-Signature: chpjp7rwdkgk698pzwgjw1paygt87p64
X-HE-Tag: 1785416438-113492
X-HE-Meta: U2FsdGVkX19jS8QAp6nHhWVXu8otUL5c7hzkh+y6T3QQsgX3Zc92WkefuJ3IqG8Ss8ek070tnararyIDG6vAK46O9FvFZALY2Og4HoPHvvVTtuFvzWEq7ensLSNOEXL/2K7lr73uS3L8+lECelFVLRrtvGEpeSzhI7tz/5vvhlgTAn2w9iiXZRL5ed0lwv1fz85K36rtWCYUQH6gT6vlFLVcbxgpX/ReyKLwKA6J8BPBSE86Z14mZTP18iSDD/4dLP09w5AdYmDs8e5gdXJNzQpW0+UZqicMAw+n3ENTJ/TDMmxR+D8789RjO9xxfVHq+eJZocv87meiW5FljM20ORYz+ySiS586oEeVVkBv+4jkDE22Mq6rdSickLW8CPVagcIQMIOr/JXSQe4TBskEdHyo+Hl6uLOS958yXRdqMnNTeIhHWcRlOlTwWfdHyOlM/zRAJ33x0KqtT2enLQtxioAGow89zW1UbBISVF0LrmjRh97eyk7QAa4j3aW7lxz49rnm8tgyIlPD5SS5SF30UpJgWPtFWW+PS0xpFOcZbrzh5ZM9fOLDE0v0LsL6mdiYQ7E+vrH3aVPapp2+n1o5X5Yl2WKJ4Q3K4kJ/wQRNsSAlSufE1mT6ihfSz3wXnRQWEarptMCwVEX6LBBsVdsGeXUEDtHUmD4iGOTViGwZ5jLnBkdlJiyXY859gaNIQOj9zzgRbDNJ5Ld72CxTCckbK310NsxFXzGYUlKs3KgMSjCMEAQVSdFtBTNTFMr8fnKkSlyQJ9tFKeBfw7jDWKpMrk647Ua/h9go3GCHs0/0NfbYEP4PnBe0vHAtDy3K7PRLIm5wwEbCdSfpQMhEIAZiDHngmKz6bS1fn1BVc9Pz5AFsCeVMrZ4s3sugE2s0Br2wgBNRmb6WXpgJPlmbTT5qQaRtdbGz9No0F+gcBhZYrYGumK5BgzfAwsCWyLQARqJe1Q9Net4vq3lfd5sO1e6
 7gW9OX3W
 mIX3YqKihc2vBTZSayMDAQijGDHRySa+1zzl1QDBgooX6hJoNNY2pFLXGfc1Od7w471O+OzNAz8H+oHnirFQSY29R2V5ner+KjpUIBln4c8VFEDDiHqi61NFyRu5QEoRrV3lEFmApstiGDSQml1QVx1AT4Q1KoLOx5S395lpiXaR6xz/Tb88B5XrszRwsrCY15Fs1KKAx5397QMITXzrEyDBvDhMnWq8ptOJWhOvfQv7IHGa3fdih0xMlJZMw6n5Yf7oajUy+TpZCy/uL3EoiUc++dMM6Qiy8333E2dY23fjis4ttb/HxnvQvAc7Rc2hssFU3sraHXwMPwYTHZdlrhyXmALTIG17NyvB4JOxA7jyfsnbee4PYqEnQmj1Ul99GI/Qahc0WRg46Af7xqVwmYswNaFnhHjxfqgocx1y2N+F/q0J4Yii7lgkrUVv1EVaFt59QwXHDYR2kC6P09ICubpdDW0ZQ2vwsY9EUOoozPUFD46WTrwaoWj8o84CAB4NsQLg1uRmBRRf43mSOh5N5DnZSkl9tL8yaiQPjlpCeM/1EIQ4uXp+Gege6TK9xmYD4AvAdyDZlDW6lNsEiZTqgJ+Dc2fOgJGDiEyJJpThxd7Hro5z/Ze0iq+DbcsnXaDPAdSbVjUl6aumUk7nCRuREskVnWjiTz5/v5/HcEM5lQ5oFSQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/07/2026 12:29 pm, Alexander Gordeev wrote:
> On Mon, Jul 27, 2026 at 05:46:58PM +0100, Muhammad Usama Anjum wrote:
>> move_ptes() directly dereferences new_ptep when checking that the
>> destination slot is empty. new_ptep now points to hw_pte_t table storage,
>> while pte_none() consumes a logical pte_t value.
>>
>> Read the destination entry through the standard ptep_get() accessor before
>> passing the logical value to pte_none().
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  mm/mremap.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/mremap.c b/mm/mremap.c
>> index d966ee8248b6b..ecb90ccee6fdd 100644
>> --- a/mm/mremap.c
>> +++ b/mm/mremap.c
>> @@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>>  
>>  	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
>>  		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
>> -		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
>> +		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
> 
> Same as the previous patch, except that I did it already:
> https://lore.kernel.org/linux-mm/20260720141633.501799-1-agordeev@linux.ibm.com/
I'll drop this patch.

> 
>>  
>>  		nr_ptes = 1;
>>  		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
>> -- 
>> 2.47.3
>>

-- 
Thanks,
Usama


