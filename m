Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1480BC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 05:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BCF6B0199; Thu, 13 Aug 2026 01:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE49E6B03B4; Thu, 13 Aug 2026 01:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985AC6B03B5; Thu, 13 Aug 2026 01:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7FB6B0199
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:56:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C36731A0547
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:56:18 +0000 (UTC)
X-FDA: 85095186036.22.67629A5
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010006.outbound.protection.outlook.com [52.101.201.6])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1F32A0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:56:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Og/LdkRZ";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of nikunj.dadhania@amd.com designates 52.101.201.6 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786600575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSvMGikNgE5zus4122FZQaZAGi0LeU+OXuLh5KzOoxQ=;
	b=p8hXN8ziIqwjdaM2Kc3g2/JNh98076kjhyjUFGc6RmLgbZoPHtPvhGNoX9b1V33tJ6T2Ig
	M7DUklC4iZV0LXdfz9FpXu0A8mtMuX60r1PMw6WjpdzmVF2GfeluYr4tmGSHy9eTOsVwEO
	YJMjhjwuD5hxQ5kKuQ5a82tXbjpHe3w=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b="Og/LdkRZ";
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf15.hostedemail.com: domain of nikunj.dadhania@amd.com designates 52.101.201.6 as permitted sender) smtp.mailfrom=nikunj.dadhania@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786600575;
	b=q0vDbiPBwAxOWxC2rSo9lG90Q7/+mIpkII9tYWlIl+VNhaXOQgoHurAjFAOiK/1l0wEBJ9
	Y0FUVjsyGqHJvVewo44wmihfxcSH4ZNfXAEuDiTDiX8CwVSeg89ZhURPwPOGedMogsnz4V
	hNssAoMzNiwkzwc8lKU6LKHUG/evBAg=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pGwveSvaP8nZvvGRRJNIMPqreuDGH9Z3CRZPWj+smyVdwLdvUoPRSFx6HHhpy1qvNGNywP23vyaxgnfmxDP6t0VeEyOG6pCfDUE6dp08p58MTo+h96NkJs12o4aKBADqdV30KPDJeOTLIt4bGI/pVe602+RdNh0puNUHTd8FL7Npa3H0yJ6aBTfS6fcaz/DrtzQUB5qKvKJRBDAKVFkbH0Y85afNXKwu9vo6bs9SlIEiYXagMjyHHFagi6D1tLIB00meAZA4FD2rVrgJtU2XnDJA3uVcXvp3CMCmUzOblRZfQVoB+yBl4+NjEWcRiLktkxKqhyGn8vf/uRf91c1rEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lSvMGikNgE5zus4122FZQaZAGi0LeU+OXuLh5KzOoxQ=;
 b=F4X6NqVFo7i4wjQXu08g6IEqbYnJTeqCl6JUsl9ChyY4yikGFn7FwRh/6GBEQQN0r3ypJQ4D1Sgg/vv/FtC+PLiWHS94emR/s00vma29SsfNMgD77gLyhWhkTTAyvysYjJgu8dg3+3l0Kh3BFQLGPDPKAgv0PT/O73s5LMYYtC/aEWjzfokFfgr8xFmotqVTsNlY2PUEb4T65K2ptvQtUpeqEOXF1vGXEnJ0fsCM385HeJK4qz2MBiF4yGzq9heOADeE7B2aGUClzayMt2QOb3fIuHMi/q0JbfH2cImd2r9hqBouFegiOsWjE5wC+by7oCGOq1LAr/UqXbEOpfzw7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lSvMGikNgE5zus4122FZQaZAGi0LeU+OXuLh5KzOoxQ=;
 b=Og/LdkRZK9zJnYxfmu0lsMI+nZhsX+BRVozhG5M62fszv09jkQrLxkW4aidGQQ2PjWwiJLk70GGVWPjRMAFonVM+CV095J46N4qZVdPZh6b6trJOn9xDXUsPzOuvpejA2XjS6V3k4pF59IFirCm6gmF1LU8PYQTY/98luziL+D0=
Received: from BYAPR21CA0016.namprd21.prod.outlook.com (2603:10b6:a03:114::26)
 by SJ2PR12MB7962.namprd12.prod.outlook.com (2603:10b6:a03:4c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Thu, 13 Aug
 2026 05:56:10 +0000
Received: from SJ5PEPF000001D0.namprd05.prod.outlook.com
 (2603:10b6:a03:114:cafe::69) by BYAPR21CA0016.outlook.office365.com
 (2603:10b6:a03:114::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3 via Frontend Transport; Thu, 13
 Aug 2026 05:56:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ5PEPF000001D0.mail.protection.outlook.com (10.167.242.52) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.339.3 via Frontend Transport; Thu, 13 Aug 2026 05:56:09 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 13 Aug
 2026 00:56:00 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <baolu.lu@linux.intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <david@kernel.org>, <den@openvz.org>,
	<devnexen@gmail.com>, <hpa@zytor.com>, <iommu@lists.linux.dev>,
	<jgg@ziepe.ca>, <jgross@suse.com>, <jirislaby@kernel.org>, <kas@kernel.org>,
	<kevin.tian@intel.com>, <liam@infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <lists@steffen.cc>, <luto@kernel.org>,
	<mingo@redhat.com>, <peterz@infradead.org>, <pfalcato@suse.de>,
	<rppt@kernel.org>, <shakeel.butt@linux.dev>, <stable@vger.kernel.org>,
	<surenb@google.com>, <syzbot@syzkaller.appspotmail.com>, <tglx@kernel.org>,
	<toshi.kani@hpe.com>, <vbabka@kernel.org>, <vishal.moola@gmail.com>,
	<will@kernel.org>, <x86@kernel.org>, <nikunj@amd.com>, <bharata@amd.com>,
	<Ananth.Narayan@amd.com>
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Date: Thu, 13 Aug 2026 05:55:44 +0000
Message-ID: <20260813055544.25567-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <anXvODEvV4f_Taj7@lucifer>
References: <anXvODEvV4f_Taj7@lucifer>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D0:EE_|SJ2PR12MB7962:EE_
X-MS-Office365-Filtering-Correlation-Id: 3dd4b775-78d3-40ae-a381-08def8ff9306
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|82310400026|7416014|376014|36860700016|13003099007|56012099006|22082099003|10067099003|11063799006|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	hBed2QdmaJxe/8IGLWe+NryCu3Wq3HmUQamu92apJZ9VLix29EbJuvwTetnjw7Neh7SNJPYzmA9/zUbrNYVAUvsby8wkYczVUczJLymP3Mi6YKSGMpgqSi4Nmnn3WjUIKAt9vjGYROAxS0uxqXNvRAuYU+x5+9HOVZeqPhM74+BRNayZL2ZiJoeHTYP9uylWENyh8RoqiFM7VZPpzcy0P0wPBaiih15bbhbiaZJi5EO7UpWQpZ5GLMhc7IEygCE59Ym7JwHfleBfSTRzvgZxD1QbL5NqyLDYIG/T2/mo48/FukhTzfRjIrXevd9KB8AdG/5nzX16zHeWRyZRkUv9hDgh09oIKr93LAbmQhss2vYxF8E+zz+EN/Rp9tEolyIPykpYmFBKRt9Mg6M/SELJp0MexmxNU0JOfs3dhf9ViSXH8zwhXHjdPKcIhQQo6IO0kQJgdgej1UEbKGfL3/V6+8j+F1Rqp/u9OLAeXuG5ciPbkTjb94w4NBZ73b/o2JnHL9rWhTOrQL6U/WPkiwONoRBCoi+RRwNejiCgDGpAETRVscCb/AhQdX7Tp2MXef6twnl0viI1Ckc6LYi4c/5Rn53TeJdj4SKjv2hMI1a54QbAbEOCQ8P+s8p6Ee0BgGhRO5nZmZ0eRo0E4PiveNyZGrzJJnuxF/n9iJNkKqhjm4fkaItTYq1QCaO2oNcD9SjvC0DGeeEu6w14KjTx5/G5CA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(82310400026)(7416014)(376014)(36860700016)(13003099007)(56012099006)(22082099003)(10067099003)(11063799006)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	HQLRjanqRWHsJHtdL/8BZxzpbI8QtYMc2mWpBlw3HvlH+mfkHlCKaQ+beRFejTHC/ypSgcHTx+37lAK0DwpfcmuTdVCtF6BCGz6cEQIRxIg75HpI0esZ7PqiRAs+X6lhCtv+lSZytj58oB6+sKhBvbSoOb7sW48p3lpjVlfe5VU2kyRuMQgZpd4mhyD9YmHR+C4BdJxs01zpzeNKUC62Qj1oD5TmD1PQY0Yut/rudH8lTe8t8kYi767bVEQ9y2oNVFcckiwbxX/lsVgLQPm3fJvMNNp7T1wH/T7e95rjlSM4Z90lY2dCwa1k8qhDYR5UBQajRA2VDmXnzpsrVMzaQr02BnaBUZORhdLIHJ1D3w6zkL18hQnV4I3j8BcE4vbNMP7Va40uOY3xxbhRCazBme0NZHXnTnCwvFasOzzpB/8Gii4xTwe1jEV2CpW9A2yE
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 05:56:09.8975
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd4b775-78d3-40ae-a381-08def8ff9306
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7962
X-Rspam-User: 
X-Stat-Signature: o5ruox8m9nx733uyfjsig4tp78f4fyxi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1F32A0003
X-HE-Tag: 1786600575-39591
X-HE-Meta: U2FsdGVkX1+XvvKWuI1CMNEypLGMigzx78CTQ5Xv7BrZIj7bAeqdnT27M+ty2UEp6BOEmzh58vne5PfrSeYEbqZu1e+T+QS+zhPy6wFn/13cpoiz8/vYg2fvaVTUd5Pf605b6rIZAdPiL9R/5HeFqQBXGq2ZWsckgS1HwihNvGosGukAG60TLZB+GVgfaulTXLgjCz6A6Y3iaDdrMN6IibaON1pgYwGN/VID0pP1W+DLlTl59bqy08QiiEcfl18yIzffk7epG+urKhKc/r5YCsvgTALtATMfYgsKLglmPj2ewMas0KoQ0pJbzjzIbt4Tf31VEVPsV9ZFSUZIWyJ8XysFVIt3rCJC7sR2/aUYyFCtXnZTqkU7lM1uFKsSn6hT0gYlxrko/taNOQpeg2szTzDmrWGSah0QQuSmZwppid3GNDmeciofPp9LL6iiqG29CN970qTUtkXS6e0m1a/u5YDd4CIp1yKc8NShpcORF3iCbYzQeZuQi81MwktU7yiCO/+fxaXyN/l9lAgs6KVLk/z7U6zxLHWT9W7/8L3BrMrzYN5p+iQBjxcRQh5V67CaLVMb/saDIrdmAsnUoe11MgcyNaBKzGePoZOn/5IJqU2j6VmZolp6mCxPKS1WVuABMiWE1Om89k0O+VcUBogAl+GHPXTGbWtPanRULap85rx90SCc2lIilklp0U0vpDNaF2hTMN77R0tygWRBjJAzYBJU7gw/zb3RxHOMVQ3KT5DKIoIEb4CX3dmv5K83Dq6nztibp37n/OXiFIJqRZ1lazMwATzTRrsUg87fYpnS0TeXqus0nOkQKSOVzkEYIS4/zVv0SIR/blN5bIJnX43dAb/ldI8SHmA4EWlqbCjrdV4ArqROWxq6/QvN7d/XO1Rz2+XwpUrHl9DfpmGI6iq+eIhppQ8dpt1N5WdygMBnAQ5d9gJp0Mm0sE9bH/CQs2GBlzsOWxYRAeN3G/2NCD/
 PhtP2EJQ
 2hSBA7etAblhmgNHUC768S7E8W/u8fDgVCBtnV2sIiE3UN6Lum1IgIH9b7iG+czpufTmnG1/9jUI5KltIOTDpoxoZVgY/qsw2jjIpjsHAkM9v5qtq3x/iWinXX++hr4e7W76kEKDew2BbtYGDKQR13QwWi6zu+ayucHw31K9DvtNLXXK0tbMJyMMHUgN6kqOOEgF1gl19qztd+Js5FG/OK6RbLfZ71UpLWFXH+nf4ny5XBK+MUMt3l2S2Uc0xDTwIYR5zqXx58x4dmetOmGMYe5O7OVebAC1YZ6+Gz8Jw+4C+DIx5XiH9jsAe/mkD6uswY3qQqHfSwvLOh8hovlsAqgNoSUKK1qvUPVFaJPD5r+6hYHOBwTXXIvPoM0wHKlNjwP/ZBEfCHg15XdA/kdzz5EjYTOcm/D5edhiKREOz/kYkQ2FyAXaQVowMilh6OkMf1RV5dCoF+7uP7If83FdOg9Rki55dNSt2MFB1vAEJpxJKS08+Kw6U3Rjg6AsW+7CL0zcV1lwOkNJAjR+sg2mKDDNPObdr6P2KulL52b7ixuhe7PO7c7QmCj/x6g6/TBqtEA+Jd1rpuSDMznyzt2Z0EmvtRe2iA3sccSRyoraoChQcfs65UcvEpzuhkYPINARfDWyoTgr/WD+mv1k4JCi+PlGx7XC33NkJY10pBa1plB62+n4Jq9DF6h0SlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:36:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> +static void poke_vmalloc_pages_safe(struct page **pages, void *addr,
> +				    bool cross_page_boundary)
> +{
> +	guard(mmap_read_lock)(&init_mm);
> +	poke_vmalloc_pages(pages, addr, cross_page_boundary);
> +}

Tested just the proposed patch from this email (without the rest of the
CPA fixes series) on the 512-guest concurrent boot harness (details in
[1]) and still see the memcmp BUG, I havent hit the first BUG though:

  kernel BUG at arch/x86/kernel/alternative.c:2727!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 1 UID: 0 PID: 485 Comm: (udev-worker) Not tainted 7.2.0-rc5-pokesafe+ #42 PREEMPT(full)
  RIP: 0010:__text_poke.cold+0xdb/0x2af

The instrumentation captured the following before the memcmp BUG:

  SMP alternatives: __text_poke: memcmp failed at addr=ffffffffc06ce1bb len=4
  SMP alternatives: __text_poke: expected (src): 2e 2e 31 c0
  SMP alternatives: __text_poke: found    (dst): f9 b8 9b d3
  SMP alternatives: __text_poke: pfn at poke time (vmalloc_to_page): 8ece
  SMP alternatives: __text_poke: pfn at readback time (vmalloc_to_page): c6ce
  SMP alternatives: __text_poke: page table dump for addr:
    PGD 2f042067  P4D 2f043067  PUD 2f045067  PMD c6001a1

pfn acquired at the start of __text_poke() (0x8ece) differs from pfn
at readback time (0xc6ce) in the instrumentaion.

[1] https://lore.kernel.org/all/20260812063316.21371-1-nikunj@amd.com/

Regards,
Nikunj

