Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45628C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 23:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B5176B0088; Wed, 26 Aug 2026 19:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E6A6B008A; Wed, 26 Aug 2026 19:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DFF66B008C; Wed, 26 Aug 2026 19:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE92C6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 19:47:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC1C11202D0
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:47:56 +0000 (UTC)
X-FDA: 85145060952.25.B14482A
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012002.outbound.protection.outlook.com [40.93.195.2])
	by imf21.hostedemail.com (Postfix) with ESMTP id 867141C0004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 23:47:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gqgj54Tv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.195.2 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787788073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/LB5u9HnbSWzaAtAvaqkHg4Fpr0yIoYgthxH10Y4ko=;
	b=lvnLzPdm6dbyjPagsMsPDVqVWIhOrQExcaZQCTlYmuO5/jhFbaGGaNtUveuVKKeuvxVbcd
	Ra19Mh3O03hdK1UgW4Xjj1/XHAQqvOC9VzY+KPJYlwvTUxA6qOCvZ/9i42Mrz7uOMuUwZP
	S2BBic44L/nQV8U+6gi6cJv8WVllZS8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787788073;
	b=ujS1u8v/OclKws60fqbeSPG1WI5ZEwQwrQrjdTR69CNI2+nAQNzTNviGQbAlcLt+9jwz1j
	nwv0ghTAsCyDNlU7RnUdlc0nR5GWo0vZLgT8agXPXzVkKhylWQLXboL+PflWjS6My4HajG
	XqXj0PVjXQLE38pQLj4uYz8viqVa3us=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=gqgj54Tv;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of Michael.Roth@amd.com designates 40.93.195.2 as permitted sender) smtp.mailfrom=Michael.Roth@amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k4J/V5gkeGUavS86YJ1T9xiJ51vThv2EwlPenwdDOUVPJiWy++dxjJPLXPcTpZIUMbuQVOHomTR5ytES2x5e0m8RuynY+Fs55UWII38wmPgNJ0mSerAWJIZNJW8o3I45hKbMAqC/8Pbern4R7/Ip0lnfOt++kru87F5ET74aMAqPrkOJfRZH4ETzURU+iXEJ+KMRdrp1a65gqo5fu+AFSojJ06oIPRDBIzRqp6Cjyw2hEWVRhjj0KswFa5L9N918h2vvT1NRgn3Ptsz0ZkMp3bd0QQeHtxDBwmP5cbh3MeQoC0+TRv+v7v4dvfUkPTulQrTqe76u1yOBn8iOifQjVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/LB5u9HnbSWzaAtAvaqkHg4Fpr0yIoYgthxH10Y4ko=;
 b=eC6PAdZ95r0qTEaMap8PXTdlDQCXXnVXWSxQ8XgyLkhgUQ/UU+W4oST9+8O8vCmR6imIK6ik1F9kMWgge817usRt87TKGlC/joVTjktYjsOc+/5NUmBPWBjFvUcYLhfnHrp73RNeUvAH6yXYLvxhb5sd/kC5lP/nxodpI7/otqEEIXhn8cDGvZWhQKcMr1VnsdmP4fWZaHDq6UJuCpdu35/dzCAUEA8t0/9x2SrzRNQfPSgSgdIVH4DTF38s+KVRZNJqVzC+uReUK74ki+zE9Xtpzx08xhX7XJRCRZxToBWSxW6hOthHG7/yeLYGjwcWHNNdOT3pMHirocO5Us8UvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 149.199.90.133) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com;
 dmarc=fail (p=quarantine sp=quarantine pct=100) action=quarantine
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/LB5u9HnbSWzaAtAvaqkHg4Fpr0yIoYgthxH10Y4ko=;
 b=gqgj54TvCGRRaotBr6UC6bDFWysdMRR/NeuYxSFbuRsslNoslmqlTYrAI6D5O7RoNNmBKf352qJkQP1ATVTrr9ibFYy9GK5jhwsnyw2sxuDQ4HM/3yKnnPl+KVAKzja/5IRIpMhA48Coif6km6Skt7aOMi1QnqO8T1mvSnCQ8Sc=
Received: from BY1P220CA0003.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::10)
 by SJ5PPF183341E5B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::98c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.8; Wed, 26 Aug
 2026 23:47:44 +0000
Received: from CO1PEPF00012E7F.namprd03.prod.outlook.com
 (2603:10b6:a03:59d:cafe::a2) by BY1P220CA0003.outlook.office365.com
 (2603:10b6:a03:59d::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.360.10 via Frontend Transport; Wed,
 26 Aug 2026 23:47:44 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 149.199.90.133) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=quarantine header.from=amd.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 amd.com discourages use of 149.199.90.133 as permitted sender)
Received: from satlexmb07.amd.com (149.199.90.133) by
 CO1PEPF00012E7F.mail.protection.outlook.com (10.167.249.54) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.3 via Frontend Transport; Wed, 26 Aug 2026 23:47:44 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 26 Aug
 2026 18:47:43 -0500
Date: Wed, 26 Aug 2026 18:47:30 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, <aik@amd.com>,
	<andrew.jones@linux.dev>, <binbin.wu@linux.intel.com>, <brauner@kernel.org>,
	<chao.p.peng@linux.intel.com>, <david@kernel.org>, <jmattson@google.com>,
	<jthoughton@google.com>, <oupton@kernel.org>, <pankaj.gupta@amd.com>,
	<qperret@google.com>, <rick.p.edgecombe@intel.com>, <rientjes@google.com>,
	<shivankg@amd.com>, <steven.price@arm.com>, <willy@infradead.org>,
	<wyihan@google.com>, <yan.y.zhao@intel.com>, <forkloop@google.com>,
	<pratyush@kernel.org>, <suzuki.poulose@arm.com>, <aneesh.kumar@kernel.org>,
	<liam@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
	<tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Vishal
 Annapurve" <vannapurve@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, Axel Rasmussen
	<axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
	<weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng
	<qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau
	<kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, Jason Gunthorpe
	<jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu
	<peterx@redhat.com>, <tarunsahu@google.com>, Fuad Tabba
	<fuad.tabba@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-trace-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH v11 15/46] KVM: guest_memfd: Call arch make_shared
 callback for to-shared conversion
Message-ID: <ztufznh6v5md5cn56t7pvokubvbpc3yki6dhiilgebb5uq3ju3@aa4xc6wwte5r>
References: <20260826-gmem-inplace-conversion-v11-0-0a15d8a799aa@google.com>
 <20260826-gmem-inplace-conversion-v11-15-0a15d8a799aa@google.com>
 <ao9CKMXAX-hScRSa@google.com>
 <mtbqvvvpwbzybgy6z47lwui6ag53kyubub3hkczui7u72zxesl@lnwsglrgwl5p>
 <ao9px1j7CLYXMiGP@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ao9px1j7CLYXMiGP@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00012E7F:EE_|SJ5PPF183341E5B:EE_
X-MS-Office365-Filtering-Correlation-Id: 423b2555-ef3e-4819-d00f-08df03cc6d12
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|23010399003|36860700016|11063799006|6133799003|4143699003|10067099003|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	8l5FF3LbJE9olur0dvcSTHVeAJf8qAZoDXGPyZtiW3UYkD7Ki+JK6XcEDAefWFgKc2/fYpZEw9tyYhJDLs/lMTSsv2niW61J1rHrhWz8zYPNvO4WaES1+5Td9m9zo+v73i4uj00Of+bRZnBIvVyuxqS7DdfgqeatCPHP00pw4k/fjKDjGG21ESbX0pFETi12ZR3Ky3blMs3oYIIRmJlWjCuXZ5+Eud7ADqw3Au3w3CaEsLcwtgc0+pk075WzAPN5NvbWGyB+2ANgV19uAjWw+NpTo5Ba9zbQrl4+ML7kcJOPB+JmvUyc1KRB925UzMG5XZz+8v79VOzC3dMYAVJWxUouCrpCVdMcC0miD8pP2AjeFGZnQyf83nuRA0xtAzRB8zEbZmsCq26ybEpYOuZxVrA7LM5hSCxiiZYdiO4jszoJvhygcM9cu3Spa3pMGP9XBWKBgprnsdkT8o49tgE+NTtodZ+vZwORSDsMZ1EZSI9MIo5rQ3rP87C8/1NRYfT51v1MRuPzVK3M48jL1E8qvn9Kf9P8Ld5zADajjHq0gKhCEsNsobO0QwdJmv3pqh4+80h598lttp1m5n55w/BJIyhGaSPVuO92sx1B3eRn3UlCZIxUcNNSP2VukkdOfiOul0XQbGfo+AN4Jmgawd0fR0JtYQKRSvMKsfGkv7gWVUGE87rqQF9wB4InWtkZDyojojKohZMaymo2xdOhrg7P2Q==
X-Forefront-Antispam-Report:
	CIP:149.199.90.133;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:unknown-90-133.xilinx.com;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(23010399003)(36860700016)(11063799006)(6133799003)(4143699003)(10067099003)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	NysA57+XV03ryJZgYUKpVdKgsgr4tDGi4zBHUeNsKl8zF4KHY1X0bMcDzx2K6phhCrUHRzDEerlHkGtGijGGihpe02RKBuqJqqAKuowoT+c1u038Oht59wTzD/rgXfuuaymTIRx314hswzz0idXxVc3gSfdhhn7F53NAqYy7F7muYgYxERbWsYG/21Lu8dt0FXOLrBzqBxwVA67F1UJnEbDmOu8Y7ZPiiEe1h+pMIFUrWs16AOewOE5gqBDfWwKmK/N8cvE58fi90B2XOp7EIYggS+1Y0W+m9D5gQSEfmunf73Rsfjb76YSeLPaBCmKbYVU0OIRUQaUSFVhUM4dD9iaFlscimeVLVSEjXUvZGgtvgWExo7VJ4jlDslrsErV/SyHWYWGtpc4JM40pWusiEXj4jKTYOVS2Bp6WfPiozeTK0SVIK9u3EKSz8MU00HZX
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2026 23:47:44.6774
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 423b2555-ef3e-4819-d00f-08df03cc6d12
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[149.199.90.133];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF00012E7F.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF183341E5B
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 867141C0004
X-Stat-Signature: qrsqgj3tyt6odgy5se63j3x5t4cre9yh
X-Rspam-User: 
X-HE-Tag: 1787788073-565183
X-HE-Meta: U2FsdGVkX1/1ucUqms8S7NYjktKeA2V65aoIAI4dByXEf7nd7u8N/h21rdrceW5+5OLmIKtqeJrewjBG53dNWH1Cp8YKO+AF/HMnpSUCwoajR4SnIznsaLblwakgITMww+TCtxpOwj3BhsH2SpKb5Sx5r843zgx9uaRuKTCWKLzWUDvfqsftQHFWd+T0KRvLv2Au0Ik62xeTLWCsgEnNT7Cfu0XdAI5Sph1Gj+9KatB8hIVzCiRbLGv/Jn50PhsezdLBG50RoPRtj8mIJHxFrDN1nM4vsU8wYWS2RnwOYI1wOkywA742m0voC06xPmvTMRGL+/HBObvi4CY711w1Em9HwvMuuu9TT8T2gNOxR/D+PyrHWX3hm7XLX4i0YfGkXhRHw0Dwi4KWMZN4tsQlf+KTknpUQ9LHZoG6hrcb+d4Unbr5hbdF6eqwkybzYFKqZ8aAwWMQmP1/NtVB6EATIKrmM8YfEhoRZHa44qsw7fzu95N8ERQ65KDsMTJNYXWTUODwWQVuey3l2e5/hH3iFBn9VKId8CLn7ltiSgm0+n4cPVFQERUjzEtaPjuEmwE4Lwm5ZPmZN51xAjA4yTHc3AXrqzHetObNmPFNSLulcGzMN1vvmk6pRcRr5iwKYHhEwehCdLP4drpMG7hJn2/TkeEnZSO68YpMNeITyJ1lafpKDibmvS+7BAeOlUCR/epeaQiT4VEOtv5aJvPpDYIR9BR+oN2vl9IlWuHWKJEKJuXO4hMMSB2am5QUBIK5MCl0scyIYnTdRPdBfpOEdSEzNdDjJHA2IcaaC4ZrSAzAslSqfHPDv//IN1FRTXk4ucBOYQXOVs1+goyeHwT0eMM+ryKJQgIACMQv+ZaMjvPBGOrhOhN5HxjelbaBJ7x5YHvlY+/tDwgSUxyrnf4RPIznHv6ARs1mU6OdGkTs0X3nxIh2axrFqVeLgRo8+6HrNYXov1M48SQfc/u0cS5RaLy
 50DSZW+Y
 XsDpMp6ftg5QhRc/xlCp861xjUQ7EdoHzGHIOsxKyEE1yCwZaVLPEgwKA9AC7PZf3sbTE/K14i3WDTJn4YW39CfbM6JTu+8kbQ6y6i1ieeFP8KRhQjnApye6lwkT2e3uIIWOx7vuQ7wy8krrusn6PNrigJ0peKXY/xq72Ht53eYw/OB3wMOemdGQArPg+oovbBD2vSywt3QpFDVvQIsMuiAJo71ACwWfw1svfsRMC0dgGZYqYUkOTZlPCoRPN51/7Tgo84fOzMHGg8tDdd+OrmGFGtN6vI2H1xLY+TOS+cNTKMMkXVnAkyStlqRiwgLeKL2m1SS3SzGetNaTgM5XYtDl+9UFRtVb4qalYVcrG45ltBOBR/qY9RrAsd9yxykNR8Dwmddg7N2fiir7ER6vmY7AsUMEkZmtoRgOZSTtq3SZvjXo8sIpq38Flt9qzCj3Q5PYwPtAzZ0CRwG+DnyHW1xv6EiKpo2Sl/KYnXRYfcXcu03vY1MhnibQQGjj6r2Qu/bgC2fcv0dK0rdVauPOJCy0Rl1muKMuPFAZRwGYv9J7rxBYB0H1rd7MMVu7xTthOAppN+7CJlsZqg22L0fgEPuWZbsKugH3TLCLBBkte7w8QO6LCuQ6RO2AD1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 03:33:43PM -0700, Sean Christopherson wrote:
> On Wed, Aug 26, 2026, Michael Roth wrote:
> > On Wed, Aug 26, 2026 at 12:44:40PM -0700, Sean Christopherson wrote:
> > > On Wed, Aug 26, 2026, Ackerley Tng wrote:
> > > > Omit support for calling the arch hook to make private, since SNP, the only
> > > > implementer of the arch make-private hook today, would actually prefer
> > > > making private only just before faulting memory into the NPTs.
> > > > 
> > > > Calling the make-private arch hook would require iterating both bindings
> > > > and the filemap to find the intersection of bindings and allocated
> > > > folios.
> > > 
> > > Why would KVM need to iterate over the bindings?  Only the RMP needs to be updated,
> > > whether or not the RMP is currently reachable is irrelevant, no?
> > > 
> > > Subsequent calls to kvm_arch_gmem_make_private() from kvm_gmem_get_pfn() would be
> > > superfluous, but that's already possible, e.g. if an NPT mappings is removed for
> > > whatever reason.
> > > 
> > > > On top of that, SNP would need to figure out whether to actually
> > > > make private based on whether the memory is about to be faulted, or
> > > > whether it is a conversion.
> > > 
> > > This is a non-issue, no?  As above, sev_gmem_make_private() already bails early
> > > if the page is already assigned in the RMP.
> > > 
> > > I don't care terribly about how SNP handles this, but I do want accurate reasoning
> > > and justification so that if/when we revisit any of this in the future, we can make
> > > informed decisions.  Because unless I'm missing something, this is an optimization
> > > choice (eager vs. lazy to-private conversions), not a complexity tradeoff, and it's
> > > not clear to me how we decided the lazy approach would provide better performance.
> > 
> > I'm not sure it was discussed in this context, but there was some past
> > discussion around preallocation (i.e. "should we call make-private arch
> > hooks at allocation time to allow for faster boot for prealloc guests"
> > and then that ran into the TDX side of things where that would
> > necessarily entail pre-mapping into the sEPT as well, so
> > KVM_PRE_FAULT_MEMORY ended up being the interface we adopted for this
> > purpose.
> > 
> > Since then, KVM_PRE_FAULT_MEMORY was added on the QEMU side and gets
> > called after all conversions for both SNP/TDX, and even without
> > preallocation it's a decent performance boost to SNP. If we were to
> > switch to pre-calling the make-private arch hook then the
> > KVM_PRE_FAULT_MEMORY call because partly redundant and in practice we'd
> > probably see a small performance loss.
> > 
> > So there's real performance differences here but it's sort of been
> > addressed through a solution that offers additional performance
> > benefits on top so there's no longer as much to be gained here I think.
> 
> Or another way to look at it, eager conversion would allow QEMU to drop its
> workaround.

True, for SNP at least, but pre-map is nice too, and not really gmem's
place, so most likely KVM_PRE_FAULT_MEMORY would remain regardless.

> 
> To be clear, I'm a-ok with the code as-is, I just want to make sure we document
> exactly why we're choosing this implementation.

Agreed. My understanding of the current design choice is basically that
it doesn't *need* to happen here, since kvm_gmem_get_pfn() will already
trigger it on-demand when it is actually needed (or not), and that tends
to happen at fault time when other platforms like TDX handle it. To handle
it differently would be to go out of our way to make SNP special in this
flow in exchange for performance, but KVM_PRE_FAULT_MEMORY already offers
a robust solution for folks that want to optimize conversion path or
prealloc host resources prior to guest boot.

> 
> > But I guess that's a moot point...
> > 
> > > 
> > > > Calling the make-shared arch hook and not the make-private arch hook does
> > > > leak SNP-specific details into guest_memfd (as in, why only make-shared
> > > > during conversions but not make-private?), but the additional complexity is
> > > > not worth taking on until guest_memfd has a user actually requiring an arch
> > > > make-private call.
> > > 
> > > ...
> > > 
> > > > +#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> > > > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end)
> > > > +{
> > > > +	struct folio_batch fbatch;
> > > > +	pgoff_t next = start;
> > > > +	int i;
> > > > +
> > > > +	folio_batch_init(&fbatch);
> > > > +	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
> > > > +		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
> > > > +			struct folio *folio = fbatch.folios[i];
> > > > +			pgoff_t start_index, end_index;
> > > > +			kvm_pfn_t start_pfn;
> > > > +			kvm_pfn_t nr_pages;
> > > > +
> > > > +			start_index = max(start, folio->index);
> > > > +			end_index = min(end, folio_next_index(folio));
> > > > +			/*
> > > > +			 * end_index is either in folio or points to
> > > > +			 * the first page of the next folio. Hence,
> > > > +			 * all pages in range [start_index, end_index)
> > > > +			 * are contiguous.
> > > > +			 */
> > > > +			start_pfn = folio_file_pfn(folio, start_index);
> > > > +			nr_pages = end_index - start_index;
> > > > +
> > > > +			kvm_arch_gmem_make_shared(start_pfn, nr_pages);
> > > > +		}
> > > > +
> > > > +		folio_batch_release(&fbatch);
> > > > +		cond_resched();
> > > > +	}
> > > > +}
> > > > +#else
> > > > +static void kvm_gmem_make_shared(struct inode *inode, pgoff_t start, pgoff_t end) {}
> > > > +#endif
> > > > +
> > > >  static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> > > >  				     size_t nr_pages, uint64_t attrs,
> > > >  				     pgoff_t *err_index)
> > > > @@ -624,7 +661,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
> > > >  
> > > >  	filter = to_private ? KVM_FILTER_SHARED : KVM_FILTER_PRIVATE;
> > > >  	kvm_gmem_invalidate_start(inode, start, end, filter);
> > > > +
> > > > +	if (!to_private && kvm_arch_has_gmem_convert())
> > > > +		kvm_gmem_make_shared(inode, start, end);
> > > > +
> > > >  	mas_store_prealloc(&mas, xa_mk_value(attrs));
> > > > +
> > > >  	kvm_gmem_invalidate_end(inode, start, end);
> > > 
> > > The real reason I responded...
> > > 
> > > Thinking about the Secure AVIC mess made me realize zapping NPTs for SNP VMs isn't
> > > strictly necessary in this path.  The PFN isn't changing, just the attributes, and
> > > that's (obviously) tracked in the RMP.  KVM doesn't need to zap SPTEs to induce a
> > > fault, because the mismatched C-bit vs. RMP status will cause an #NPF(RMP), and
> > > AFAICT kvm_mmu_page_fault() will do the right thing.  A misbehaving guest could
> > > continue to access the shared data (assuming we stick with lazy conversions), but
> > > that should be fine?  E.g. it's not really any different than implicit conversions.
> > 
> > I think this should work in theory...
> > 
> > zapping NPTs means the vCPUs will keep retrying until they get the page first
> > vCPU that faulted is trying to grab from gmem. If we don't zap, then they will
> > instead be racing with the first vCPU, and if they lose they will be
> > generating implicit page faults that trigger conversions back to shared,
> 
> Why would they trigger conversions back to shared?  Assuming the guest isn't
> being silly and accessing the memory with C-bit=0, the #NPF will be tagged ENC

I wasn't meaning the normal flow for a well-behaved guest, but when you
mentioned "mismatched C-bit vs. RMP status will cause an #NPF(RMP)" I
thought you were considering the case of multiple vCPUs accessing the
same GPA in various ways (that may or may not make sense) and whether not
zapping before conversion would cause any issues with the handling of that
scenario. In that scenario there is potential for any mix of mismatches
between C-bits and RMP tables.

The silly case with C=0 is the specific scenario I was thinking of. E.g.
one vCPU is trying to due memory acceptance/PVALIDATE of a GPA that's
somehow still being used by some other vCPU for some shared memory
workload.

> and KVM will treat it as a private access.
> 
> 	if (is_sev_snp_guest(vcpu) && (error_code & PFERR_GUEST_ENC_MASK))
> 		error_code |= PFERR_PRIVATE_ACCESS;
> 
> kvm_mmu_faultin_pfn() will see "fault->is_private == kvm_is_private_gfn()" as
> true, i.e. won't kick out to userspace.  Same for __kvm_mmu_faultin_pfn(), which
> will call into kvm_mmu_faultin_pfn_gmem() => kvm_gmem_get_pfn(), see that the
> gfn is private, and call kvm_arch_gmem_make_private() as needed.

Yes I don't see any issue with the normal/well-behaved path, it's just
the funky edge-cases that seem bring about some new considerations, but
it seems like those would be handled okay.

> 
> I don't see how #NPFs due to the RMP being SHARED would be handled differently
> than !PRESENT #NPFs.
> 
> > and most likely the first vCPU will re-trigger an implicit shared->private
> > conversion when it does PVALIDATE. Worst case, the guest fails PVALIDATE
> > due to racing with itself.
> > 
> > It's a bit chaotic, but it shouldn't break anything other than the guest, and
> > it's only something we'd generally expect for buggy/malicious guests anyway.
> > 
> > However...
> > 
> > > 
> > > In other words, couldn't we do this (as an on-top optimization)?  The only wrinkle
> > > I can think of is that it could delay reconstituion of a hugepage, especially if
> > > we opted for eager conversion (because the guest wouldn't hit #NPFs to trigger the
> > > hugepage promotion).
> > > 
> > > diff --git arch/x86/kvm/mmu/mmu.c arch/x86/kvm/mmu/mmu.c
> > > index 62f751952ad8..61f3e270ab61 100644
> > > --- arch/x86/kvm/mmu/mmu.c
> > > +++ arch/x86/kvm/mmu/mmu.c
> > > @@ -1670,6 +1670,7 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
> > >  
> > >  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> > >  {
> > > +       unsigned long shared_private =  KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;
> > >         bool flush = false;
> > >  
> > >         /*
> > > @@ -1683,6 +1684,10 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
> > >         lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
> > >                             lockdep_is_held(&kvm->slots_lock));
> > >  
> > > +       if (gmem_in_place_conversion && !kvm_has_mirrored_tdp(kvm) &&
> > > +           ((range->attr_filter & shared_private) != shared_private))
> > > +               return false;
> > > +
> > 
> > This path would also trigger for hole-punching, where we would want to
> > zap the NPT entries. So we might need to adjust the logic for more than
> > just shared vs. private to account for that.
> 
> No, because PUNCH_HOLE uses kvm_gmem_get_all_gfns_filter(), which does:
> 
> 	if (gmem_in_place_conversion)
> 		return KVM_FILTER_SHARED | KVM_FILTER_PRIVATE;

Doh, helps if I actually have the right branch checkout out when looking at
code. That does look to be covered.

I'll give this patch a spin on my end as well and report back if I notice
any crazyness.

Thanks,

Mike

> 
> i.e. won't get short-circuited.  Though I agree with the implication that this
> is super fragile/subtle.
> 

