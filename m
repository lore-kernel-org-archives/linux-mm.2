Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CECDBF42135
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 18:25:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0ABC6B0005; Wed, 15 Apr 2026 14:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBC26B0088; Wed, 15 Apr 2026 14:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A835D6B0089; Wed, 15 Apr 2026 14:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95BC96B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:25:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EF8741A05D6
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:25:22 +0000 (UTC)
X-FDA: 84661617684.28.B08812D
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011066.outbound.protection.outlook.com [52.101.52.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id DAC7680011
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 18:25:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dfCQJIdg;
	spf=pass (imf30.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.52.66 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776277520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4rCORCZUrDIswGomzzXoi80PnU6YWQ8UcX2vVfV7Pk=;
	b=1BpQftRQBGYEkPH/ZAERmHmZLWHiWLitLx0vSax/2e88CWxR+eO1H2UKHK2EfwgGhyk50M
	9QCyQMYl9a1IJe35YlIS6Sp/xWtBSFrUkV6PvVO8jp4NyIrIkvB250oZS63DExP4FBPwOx
	kO6Jn7QWqLjXhttZgAf7kRUjZzS1My8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=dfCQJIdg;
	spf=pass (imf30.hostedemail.com: domain of Michael.Roth@amd.com designates 52.101.52.66 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776277520; a=rsa-sha256;
	cv=pass;
	b=3JIXJ9Vn5a7y1vREpPYDUJzUTDeytz1Ph/QGkMLfaI56Jh/kAZ2UeVrKsgftLxewu0l2QD
	dAB5b5lygyvkg1MwNQJKjm3Dl8eUIedMSNC8SNOxZ+39lu+d6FEio2OMI+SZKFLoI42JJ5
	xjD8tiRArwEzwPoLSPfg8svEi2JfFgU=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gf7yIrYYPesDLtsBMcEZuW2BpWBEEIiZt/NqgevNcbIHsRVkkl4voxuqQ0pETI3bAjsQ6IwDR+epzJlZPxuWxk99Zd3WPP5/VjFV6Rw+fZpsvlSPZIh6xLTYNDeO/1J4ZiIsMVh1ZIK4ZtJnYkVJDTTtwJfx45pIxJGiiebs3qQpzFlyBpPGtk2ScbFq31ifFp5gPw9cF36Ukj8h1j+OxZqsfKMUjpGUKpGrwuQnXJE/4BbIhlfbRwcOo/8G6RqPqSOwohL2NXcPKkLMFZOcYo7sW7qs87eGLVv3yWZMuztAKNZoOXK1s7zWs8MJsnfKaikjL+mvopDrKFzhkifu2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P4rCORCZUrDIswGomzzXoi80PnU6YWQ8UcX2vVfV7Pk=;
 b=E79syLiBH3ekD7XdqwxzeWQUnWRs8sSf9fTdz/9VVYY9LAadIPk2/wyYSc42TdPjIeJkXrpHiUsZQQYOS3s8upfI6BP2mqRINzL4lYtMwIIox0Ajumwd4zRFbj5iIKBNsG40w2NrncZJbq3e0mPCFHqlqq7GjMWIw+LvIZhqPktblYHGkPPIVsOZZE15zsHw1aWwyFQGsKpKZN8iMJHDf1FExzu7GUNPNklwZQ9jiBjV8U+afLoPo1YPSP/OGLogUYtwJMN7OTjs3obI8agmUmmaPKITyoSWXfw4aWMU+1oVQYq/mF+hLjSaQkox2IO5/b7YNEN6YDfEypsMgdynAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P4rCORCZUrDIswGomzzXoi80PnU6YWQ8UcX2vVfV7Pk=;
 b=dfCQJIdggMjH+Pknf0wE6p5ZPeq0itMmdGUzE58rCGVBBXjHQ/oAOGFpow+Vo0H0StnPuskXEf/uBMfz+FvXVMJnRWynfPjBRP31avPpzAvW9HeStW5sEi2I6t37fpwNpmcsjNJ+vB8x5UWlGeKHF1BMNRU7lSd2j7KC8tBKQSA=
Received: from MN2PR14CA0006.namprd14.prod.outlook.com (2603:10b6:208:23e::11)
 by MN2PR12MB4256.namprd12.prod.outlook.com (2603:10b6:208:1d2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.20; Wed, 15 Apr
 2026 18:25:14 +0000
Received: from MN1PEPF0000ECDB.namprd02.prod.outlook.com
 (2603:10b6:208:23e:cafe::e6) by MN2PR14CA0006.outlook.office365.com
 (2603:10b6:208:23e::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.48 via Frontend Transport; Wed,
 15 Apr 2026 18:25:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 MN1PEPF0000ECDB.mail.protection.outlook.com (10.167.242.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17 via Frontend Transport; Wed, 15 Apr 2026 18:25:14 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 15 Apr
 2026 13:25:13 -0500
Date: Wed, 15 Apr 2026 13:20:41 -0500
From: Michael Roth <michael.roth@amd.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <aik@amd.com>, <andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>,
	<brauner@kernel.org>, <chao.p.peng@linux.intel.com>, <david@kernel.org>,
	<ira.weiny@intel.com>, <jmattson@google.com>, <jroedel@suse.de>,
	<jthoughton@google.com>, <oupton@kernel.org>, <pankaj.gupta@amd.com>,
	<qperret@google.com>, <rick.p.edgecombe@intel.com>, <rientjes@google.com>,
	<shivankg@amd.com>, <steven.price@arm.com>, <tabba@google.com>,
	<willy@infradead.org>, <wyihan@google.com>, <yan.y.zhao@intel.com>,
	<forkloop@google.com>, <pratyush@kernel.org>, <suzuki.poulose@arm.com>,
	<aneesh.kumar@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Sean
 Christopherson" <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Jason Gunthorpe
	<jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>
Subject: Re: [PATCH RFC v4 10/44] KVM: guest_memfd: Add support for
 KVM_SET_MEMORY_ATTRIBUTES2
Message-ID: <3blpenhpvysb2ig7efegedx4v3flppl5ftnz6vhpqlatfk3ycn@vmmhs7mvjieg>
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
 <20260326-gmem-inplace-conversion-v4-10-e202fe950ffd@google.com>
 <2r4mmfiuisw26qymahnbh2oxqkkrywqev477kc4rlkcyx7tels@c7ple7kdgpo3>
 <CAEvNRgFkusZeKxGctUpTTbYjdi7nZL1ZZar-gT7XRUOCZ2xtpw@mail.gmail.com>
 <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <eiiecl7jvywvqb4drq7cchmcabcrdka25wxr77uavxqineeedm@rfcnhdz6xoxf>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000ECDB:EE_|MN2PR12MB4256:EE_
X-MS-Office365-Filtering-Correlation-Id: 06494f9a-b0a2-4bbd-0640-08de9b1c5634
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700016|82310400026|13003099007|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	eMuIns9H4BpWzkuuji+ygO2xBt5NvIY+L9FLNDpbUZii2en+dlg+l/yUB7m925t5/uxKfeelc6gee4aYPYe35JspOp2KJz5YtrMjO3wfIh5QmFB6uz6r8TcgfxeldUCaTKikjNBAGcu/VfLDMCbaHLgTKeuoGkFyOpe3vbn4lg2/V+tNN6gV9g3R3Z3jURUy7lAgmJTPJluWjEtyzthREk5leHIp+ddAOdfaj/FDUw8bGhH82+zGwwZoQWDpJIZeo4Y7NZrY4eko/JOykVh3JGEHbKouACsMIbGZSxv//+E17FE6vcqgm50F/XQThWW2pBeInfHSDu30tyMAi4hsEUGvmO3bW3IP9uAskeet1gV2SF/EmNh4K2PskQy5amJIV48z2NL5w+xTj78yAGTYG/TGdhZjRgtQfuqYdNJ2QeUDIdl+wv4xOBDO6M1xH+sGSeW9SNoVmuBlvP3NO25XIwcP025016jPoHdX0IFMxzj0XtmxRxhcbBY04mCEqp0Ue8urSULxxWZfHpxlMifi+DXtfErWkeXthIgURNQ1gv1YDuiumWc9l4HA3VOGMcZidiZ6b2y3bbhq3T6xJ5vlTrgUTVMZSZBCvsXhIdfLq3Dw6ftcXQXz7Z4T0rC+yVX7jr/lq0l8PiuUA+ZT6jBmRnxQk/cNo6nkODnpzRqsEW0q0OvLES5C/2HbtYNxdb4Y5nZvtQJXAcmMym3IQ8GeYL+VlEiQyuei9bE/fB1B9QgrWHcN6hJIjEbT4AK1TFPFZgXYj7FAo7j33LVvVjCKfqG2pkyU/MHDHdhzKGZiusA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700016)(82310400026)(13003099007)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	5vkyB7KZa7YBGZNkyCjrpfpvq57bQRtgSz5GHOYNmxkOtZBBKsTkm+LHQOpillmTZi5AL0UDfzuU6LrkOGJ7a+ZVvVdM2fT3WUCEOGn5j41mTgrqiQZUydjQ6J2ZxZV4Q64WXxf/5fp9eNFeQVmduSz6z0olD0ySkaIAAVWRkPdK/Tja8hb0so/gYBkfFCA1cd1eJpz1H7g59LBEt7OzjfdxPJdcZAitL+/9QVUWGdHSkqxLjRNvvLxbtqQUVrLoMPuD1m5MEJxACLz8oXbWkmgybcf9OP2Z6eOyOVkn0d/TIjJD+FF7S74xRrlVfAD7jZLu/rZsfMvypPPiC1SRbIs/7SQt5Nbrt5EdcGVaje+3mlrLH/DIpudSceffXYWB5kXJlpa82eSRNX5EnzA/7i1XlJXu4JHYVS98J1XlP/O5RNyujIdXsgeU6iMb+dGQ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2026 18:25:14.0299
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06494f9a-b0a2-4bbd-0640-08de9b1c5634
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000ECDB.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4256
X-Stat-Signature: p13i3ccb9s5f6n68fqbznx78g4a91b4o
X-Rspamd-Queue-Id: DAC7680011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776277519-464093
X-HE-Meta: U2FsdGVkX182IXVTGyxxSAZA8/x4x7pGfAepl+t/CLoysUfSU+hmf2Zub+Pe+QNRpHIfjkHEdWLtVgw9JloNmTEFfafQHNRyKwpj62S5Tfi9iqYkmq098p42UMRgFh3KkbnH+DljTYRsfrCsmqbXhFIDx66uHXSICaCGuPMFMlw2zkI8ILYCZ1/ZD8WynwU5Jf7RODJ1vMhVi5Y89VRvHVPh7iw3R5+vhppw5t0y8fqixg5AMVkMIe/l+Wahwjvg/dyHXqA2AY/FTpXAejZMNyh0/Z/ATMrDQmITYAiNycYcLKxgwlBrtQVg/Xj41N7ZzCAfQl7/9fXiqRVjcnhA3lYVpYAac//qfArowz3yGR9zkNxDR8qAv7t7a4CcbpnsIO/yqEbHlJo0bXlwaelEOmg5B8UFbUXXf7vzmR5sgb/GT/SldK8CpbfaqdjSooiiUyMfcDM5gKcdHxslhyT7tNt0Msq+l2vjjiYZ552/GSHhKFsjEhbBKr5qgbT1pXEX8k5+Uc4LFh83et+lCTzZWXR1Wj/ttDBpKUi5EHUPHTSSDRofV8NviLasy1Fip6pInY+jmIPyCLeHMmpX0lp+WixEtct/b7rDJPSRDZYC1R/VX3i/ExeNfR6t7mHDmgYnsPbkvB699Yjrmf99LvieJxC6yn1QKG0hhkCnLM/AA2W1z9Kf0i89CpLmeAefDhQkHS0xKqY9JJvu5gNyLZ84Gmyapq2ipO5is3qDXQpHC8WnfBLyxpnO0k80J9vO+OKtY3gYlh7nODPykvoOIOG25wUalLQWNia48+XsU3FQU/DZ2Y6cSFOtRX5VaCgEGDeiABucNts/S2rhtC3Y88AXStiuDPcUAsHrsKeg3gwJboIH82t/HZY47l3aBrFuEahcRAQKcGGljsVQVrWNEDEbbcBgdOtcP2nFNVueuwiqPzQsy8b++/T+3EtrtkL+8B8FxjWNYIHoDE7etwMndqM
 jCUrLRZL
 MqBs12udfHtr7h/lVXHmYuCDPHPFosKmsJzOCpNbwNAcOZ4UcfSxLvNl5bVkiwoqKQSyc3eeThyXVLq4MMAooOokEuumj1nWHh4Ai3UQvIPjarDVwPiiWJo7Tt7pocFG7+23WB8d+REHlz+jabVuxuADoELINEFJbAP6/3a+7ve261AUoCgGP2huXf4tcI5jr0GLgDgIEDYm1l8IG2hPSZxRso6MahQxNgZ4UbVcjjcT38qfxDc2Gf7TXcmv6aITukjE2Z00IXI6tZFkzsxCcUC5C9rkv0QbS1iS7BtxeK58EMkfXkqelTIRt26YLIyAqzokcQoP81EVGk5HKeAaja1ZG3nC4gvd43LLPvoy5PojiExsUfqXGCV+fBtDZuYE97Ty0HJfiXnMrtTIWA9LYWdJ/KAQwhI8G/rmQvaVox6OmbcMs8guKaRUauoSlvuo77ka/U4h6QAI3YhaEEve+kV2zATOzPpCT/FyPY7y915K00kSJ1ED2K87sNyHqmpVGkIHc/kylmmSXb/2TWk+uDorqdS1LhpvHwP8ichRnLu9Y/yiJUNIsFnGIYSaWq/0cprDTr2GALGa/ZxuFetuvm2w7wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 06:37:00PM -0500, Michael Roth wrote:
> On Wed, Apr 01, 2026 at 03:38:12PM -0700, Ackerley Tng wrote:
> > Michael Roth <michael.roth@amd.com> writes:
> > 
> > >
> > > [...snip...]
> > >
> > >>  static unsigned long kvm_get_vm_memory_attributes(struct kvm *kvm, gfn_t gfn)
> > >>  {
> > >> @@ -2635,6 +2625,8 @@ static int kvm_vm_ioctl_set_mem_attributes(struct kvm *kvm,
> > >>  		return -EINVAL;
> > >>  	if (!PAGE_ALIGNED(attrs->address) || !PAGE_ALIGNED(attrs->size))
> > >>  		return -EINVAL;
> > >> +	if (attrs->error_offset)
> > >> +		return -EINVAL;
> > >>  	for (i = 0; i < ARRAY_SIZE(attrs->reserved); i++) {
> > >>  		if (attrs->reserved[i])
> > >>  			return -EINVAL;
> > >> @@ -4983,6 +4975,11 @@ static int kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> > >>  		return 1;
> > >>  	case KVM_CAP_GUEST_MEMFD_FLAGS:
> > >>  		return kvm_gmem_get_supported_flags(kvm);
> > >> +	case KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES:
> > >> +		if (vm_memory_attributes)
> > >> +			return 0;
> > >> +
> > >> +		return kvm_supported_mem_attributes(kvm);
> > >
> > > Based on the discussion from the PUCK call this morning,
> > 
> > Thanks for copying the discussion here, I'll start attending PUCK to
> > catch those discussions too :)
> > 
> > > it sounds like it
> > > would be a good idea to limit kvm_supported_mem_attributes() to only
> > > reporting KVM_MEMORY_ATTRIBUTE_PRIVATE if the underlying CoCo
> > > implementation has all the necessary enablement to support in-place
> > > conversion via guest_memfd. In the case of SNP, there is a
> > > documentation/parameter check in snp_launch_update() that needs to be
> > > relaxed in order for userspace to be able to pass in a NULL 'src'
> > > parameter (since, for in-place conversion, it would be initialized in place
> > > as shared memory prior to the call, since by the time kvm_gmem_poulate()
> > > it will have been set to private and therefore cannot be faulted in via
> > > GUP (and if it could, we'd be unecessarily copying the src back on top
> > > of itself since src/dst are the same).
> > 
> > Could this be a separate thing? If I'm understanding you correctly, it's
> > not strictly a requirement for snp_launch_update() to first support a
> > NULL 'src' parameter before this series lands.
> 
> I think we are already sync'd up on this during PUCK, but for the benefit
> of others: Sean pointed out that if we don't then we'll need to add yet
> another capability so userspace can determine when it can actually do
> in-place conversion for SNP.

(in-place conversion for SNP during pre-launch/populate phase, I meant)

> 
> Right now, this series effectively advertises in place conversion at the
> point where KVM_CAP_GUEST_MEMFD_MEMORY_ATTRIBUTES reports
> 'KVM_MEMORY_ATTRIBUTE_PRIVATE', so I slightly reworked the series to
> include the snp_launch_update() change prior to that point in time in
> the series. Thanks to prereqs and changes/requirements you've already
> pulled in, it's just one additional patch now:
> 
>  KVM: SEV: Make 'uaddr' parameter optional for KVM_SEV_SNP_LAUNCH_UPDATE 
> 
> I also did some minor updates (prefixed with a "[squash]" tag) to advertise
> the KVM_SET_MEMORY_ATTRIBUTES2_PRESERVED flag so it can be used by

Though I'm not sure how we deal with it if SNP/TDX at some point become
capable of using the PRESERVED flag *after* populate... but maybe that's
too unlikely to worry about? If we wanted to address it though, we could
have both PRESERVED and PRESERVED_BEFORE_LAUNCH so they can be
enumerated separately from the start.

> userspace for SNP/TDX in the kvm_gmem_populate() path as agreed upon
> during PUCK.
> 
> The branch is here, with the patches moved to where I think they
> should remain (or be squashed in for the [squash] ones):
> 
>   https://github.com/AMDESE/linux/commits/guest_memfd-inplace-conversion-v4-snp2/
> 
> I've also updated the QEMU patches to use the agreed-upon API flow and
> pushed them here:
> 
>   https://github.com/AMDESE/qemu/commits/snp-inplace-for-v4-wip2/
> 
> To start an SNP guest with in-place conversion:
> 
>   qemu-system-x86 \
>   -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>   -object sev-snp-guest,id=sev0,...,convert-in-place=true \
>   -object memory-backend-memfd,id=ram1,size=16G,share=true,reserve=false

Sorry, that should've been:

  -object memory-backend-guest-memfd,id=ram1,size=16G,share=true,reserve=false

> 
> To start an normal non-CoCo guest backed by guest_memfd with shared memory:
> 
>   qemu-system-x86 \
>   -machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
>   -object memory-backend-memfd,id=ram1,size=16G,share=true,reserve=false

and:

  -object memory-backend-guest-memfd,id=ram1,size=16G,share=true,reserve=false

(and both require kvm.vm_memory_attributes=0)

-Mike

> 
> Thanks,
> 
> Mike

