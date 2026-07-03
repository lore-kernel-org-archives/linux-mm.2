Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EA96C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2F86B00C1; Fri,  3 Jul 2026 09:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 474206B00E5; Fri,  3 Jul 2026 09:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CFE6B00E8; Fri,  3 Jul 2026 09:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 092806B00C1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:39:18 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3C2D1C5E61
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:16 +0000 (UTC)
X-FDA: 84947571912.18.5EEE949
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 400D2C000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:39:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iy2MjFOD;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085955;
	b=rxxdavkJ47NxJrubCXl5HUkMEiS8GprLz2N5QVzO/DadGSixssBOY45p1KetylIdnK9LU6
	BygZzAh5Uziw3g+rdXT0N1oJrGWQnRAr3Kv41UZ2kS+SLJ4aLlZma20uGBmoglxNVSO+s4
	olnyfOpRxMe3M4m1Amq92mDmGL8xpOw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZAdfsOK4tFSPJR7Aj2D7TzZA7j60EZxfwd8tWq9E3E=;
	b=FA2qUpv1aPevCzuD+dZDeecavVBvrK80YLqRoZMSZfPoR8SyTFJfYHUf6QHYhRmwd+ms4t
	4xlVLcsUgEhhH+3rsq2EXV32jSO9Xm5N/sRechRwiCulrcMQ/dMJ8/2u93W+DgBTC3Uks0
	08lZu5M+f9iOWNWCw0n6wukmTGjsgio=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Iy2MjFOD;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A5A441978;
	Fri,  3 Jul 2026 13:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187FE1F000E9;
	Fri,  3 Jul 2026 13:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783085954;
	bh=gZAdfsOK4tFSPJR7Aj2D7TzZA7j60EZxfwd8tWq9E3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Iy2MjFODHI3xorm5lCCn7X6KmOVRg3yW91mvKPD3two97lMxlZP19piRDprB1eNYc
	 DYlZMhegN1/lp/SjFedKlM3U/uDlvrL/9FgXMqyE6u/yL0Ujaob2xTzV37rWwMRkoq
	 RD+Cfv1Ss+ANInYh8hjtzd8vOZ2qyNFX0YLUuiDSmBvMQl4DJfBeWFbgehjn15IkuW
	 pLv3nUbJk9Vw7He2DwneABC+WC7/sy307tOrWzutaUbX1KeUAFwPxeahHXI0Vw6oyu
	 0/7olW/AWWlIiQs2eKZwXYIiO1DZHs2HA0/80RJmZuQ+CO8dQ46MDNubibxQD7ahra
	 YV7D3efGERuwA==
Date: Fri, 3 Jul 2026 16:38:48 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>,
	"surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>,
	"jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>,
	"riel@surriel.com" <riel@surriel.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>,
	"coxu@redhat.com" <coxu@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>,
	"yosry@kernel.org" <yosry@kernel.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>,
	"prsampat@amd.com" <prsampat@amd.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>,
	"pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>,
	"thuth@redhat.com" <thuth@redhat.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"urezki@gmail.com" <urezki@gmail.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>,
	"rafael@kernel.org" <rafael@kernel.org>,
	"yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
	"vannapurve@google.com" <vannapurve@google.com>,
	"jackmanb@google.com" <jackmanb@google.com>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>
Subject: Re: [PATCH v12 02/16] set_memory: add folio_{zap,restore}_direct_map
 helpers
Message-ID: <ake7aPB2O_-dAXhI@kernel.org>
References: <20260410151746.61150-1-kalyazin@amazon.com>
 <20260410151746.61150-3-kalyazin@amazon.com>
 <DJOUYOKL6N3R.BFIO8HEL03OA@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DJOUYOKL6N3R.BFIO8HEL03OA@linux.dev>
X-Rspamd-Queue-Id: 400D2C000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 48gnp5bmcaofp9epgaj8nrpjdnoqdu7z
X-HE-Tag: 1783085955-201850
X-HE-Meta: U2FsdGVkX19nf3YgXaWwAxNoF078PJr5sC6WazEeMVzyC1oPnQVTfbenJ8RXd04Jsf5sG4ZZHayzusLlgzFrr6Vr9g+5tGiPaGGrvXBWN1IHhLGdZ5/Btg3F4dGMSHV4KaxvZ8t16b8PMCwJGGXcEdYfDmmF/paSpLboyLTq1hydhnh8nzfl9suuPWFL0CfGNY/hCVNx5lnjW3xbZIyJRicuKdgCnfkSJLwAGLUTrekCJxOMCEDiK+bJTAa2ZmA6pkBb8QRuNKdU5s7M36AYLS9QOqtELkZjD81LojC45cUQcNNxhbNA0R9uUJHbTb9RLCTlRkyXbY80QIAHcz23GhXATtGVHXYlC04Y3guNZprIRdWl+0+4oknc5kKh0CXUwVmxaljoJVbSVxZaip98h4KBcAFLBr+ediilR5825I3md7R7CQu+RtHu6QX6v6rOEn8rcpdSHCRqUMGxugcsteurIS6TCaoN5jyfoRknWkY5iLp0QHW1kLlcZjQgdmkZwM3iMJrR9cml6atpo6sgf1DnV15tP5COdNnnNmvnRWSPgV4tCHZdiLOHYDgOodiCT7A0O4n2fEA/KzQMosRzq4wNEWD+Sv9JI5TA1emvxOyzjxh2LTscnnZnI0o7P4q7NZqtT2XTm/5OUB9K6qq9v5HHbJ3eLhJ+wH9UPhizFClaFpLPEcO1dMd5Hg3ctoqJc+stdYImTX3SO+lIXoe2ynOk/0fC007an5B9eU604L2OPyvAiRSePNo3Xu23DzuHNPq8mrM+T59Ru0xVv2eqV/BkySYjBfbaHEvPM5u5YV8+pt88zWHrSiLJdUgYmE9VCJYtLEnAgbJFm9aJDGfqpmXqtMgrODZqFvBtiJqgK6gsXp76H+iZ7ylnuayn3XRp8UHq0Msa2Ofd8IGA3/ZHa6eeSyRZRza2FpcoP4l5XoV4M2PkHUAIK0UyC8PmYT3ub4TA6cGf5B7nnz7Fw3R
 Uf4wR77e
 XCd13NpJr8Cv4mxieVhUpKXekWeojcCw+7LMZ3rK5YTgUfFWq/ygvn7Oognrn65jUsNsqo7gAmQ89nDmXt4fIMVWVjnxMle5MPRv0LxH2TZGDei8hdQdZKOmXmxNjdq7C5CcsHBjzHYA00dRMfKi91J/QtAS0HMx62DINUu/URsTZu2vA2SyUaBcSTv4SFL6Nh3Ztt2JL24+FhckswbFCqWXwkmxL80PIdfveNDvwO24C1EAHQSzUtU144dj0KopGd3JwuuTCkzzmga8mioT9M97XUWHvNb+Dy0jOGYD4WlGHQDXN3dzIE8EQzl5x9FmMvGfRrOXCtp4+nqRewiJJ+AHbcIaBlAnghKZBxTMIlLFHDaXtggL6n+CeR+FyeSbJQGqCsMPZ0F24hARnaV20ayHNM6j+G182mVZPFMkM+s0vUcbyOo7haZ9Vf+jkto0iujtfKTjni3NKEbU3nFUXR/bGh+0L0i1flAKc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 10:19:10AM +0000, Brendan Jackman wrote:
> On Fri Apr 10, 2026 at 3:18 PM UTC, Nikita Kalyazin wrote:
> 
> My local Sashiko run pointed out that this is broken for highmem.
> 
> There's no highmem for guest_memfd but there is for secretmem.
> 
> ... but this isn't actually an issue with the patch, it's currently
> broken in Linus' master:
> 
> Su[   30.071284] ------------[ cut here ]------------
> ccessfully allocated and mapped 2097152000 bytes at 0x3a449000
> Populating memor[   30.074614] CPA: called for zero pte. vaddr = 0 cpa->vaddr = 0
> y...
> [   30.078636] WARNING: arch/x86/mm/pat/set_memory.c:1840 at __cpa_process_fault+0x34d/0x360, CPU#5: allocate_secret/570
> [   30.084789] CPU: 5 UID: 0 PID: 570 Comm: allocate_secret Not tainted 7.1.0-14063-g4edcdefd4083-dirty #10 PREEMPTLAZY
> [   30.090937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [   30.097543] EIP: __cpa_process_fault+0x34d/0x360
> [   30.100514] Code: ff ff 85 c0 0f 89 7d fe ff ff e9 3d fe ff ff 8b 03 8b 00 c7 04 24 c8 ff 64 c1 89 44 24 08 8b 45 e8 89 44 24 04 e8 53 7a 00 00 <0f> 0b c7 45 f0 f2 ff ff ff e9 fc fc ff ff 90 8d 74 26 00 55 25 00
> [   30.110829] EAX: 00000000 EBX: f64afe98 ECX: 00000000 EDX: 00000000
> [   30.114799] ESI: 00000000 EDI: f64afe98 EBP: f64afe04 ESP: f64afdcc
> [   30.118785] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010246
> [   30.123020] CR0: 80050033 CR2: 46c48ffc CR3: 038c8000 CR4: 00000690
> [   30.127010] Call Trace:
> [   30.129078]  __change_page_attr_set_clr+0x5e7/0x870
> [   30.132275]  ? console_unlock+0x99/0x130
> [   30.135069]  ? irq_work_queue+0x36/0x70
> [   30.137853]  ? page_address+0xd3/0xf0
> [   30.140421]  set_direct_map_invalid_noflush+0x52/0x60
> [   30.143782]  secretmem_fault+0x128/0x210
> [   30.146560]  __do_fault+0x25/0x90
> [   30.149053]  handle_mm_fault+0x6d1/0xcb0
> [   30.151759]  exc_page_fault+0x135/0x3b0
> [   30.154487]  ? doublefault_shim+0x150/0x150
> [   30.157416]  handle_exception+0x130/0x130
> [   30.160137] EIP: 0x804d29f
> [   30.162307] Code: 89 54 08 e1 89 54 08 e5 89 54 08 e9 89 54 08 ed c3 0f b6 44 24 08 89 7c 24 0c 69 c0 01 01 01 01 8b 7c 24 04 f7 c7 0f 00 00 00 <89> 44 0f fc 75 0e c1 e9 02 f3 ab 8b 44 24 04 8b 7c 24 0c c3 31 d2
> [   30.172936] EAX: 5a5a5a5a EBX: 00000000 ECX: 0c800000 EDX: 3a449000
> [   30.176927] ESI: 00000000 EDI: 3a449000 EBP: bfbbae18 ESP: bfbbadac
> [   30.180897] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00010246
> [   30.185161]  ? doublefault_shim+0x150/0x150
> [   30.187979] ---[ end trace 0000000000000000 ]---
> Bus error                  (core dumped) ./allocate_secret_i686 2000M
> 
> Fixing this directly in secretmem.c is kinda yucky but if we can just
> make folio_zap_direct_map() a NOP for highmem folios it's nice and easy
> so I propose to just fix it as a followup to this series.
> 
> Alternatively, we maybe should disable secretmem for highmem systems
> since it evidently doesn't have any users.

Yes, please :) 

-- 
Sincerely yours,
Mike.

