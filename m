Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2EBBCAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 08:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB438E0003; Sat, 13 Sep 2025 04:29:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C498E0002; Sat, 13 Sep 2025 04:29:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21D5A8E0003; Sat, 13 Sep 2025 04:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3DA28E0002
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 04:29:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 801EE1DF930
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 08:29:39 +0000 (UTC)
X-FDA: 83883553278.25.AB19950
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8371040002
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 08:29:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NIhFoz3V;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757752177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PIeQDW6Tdi47ZNT16hYEbfLPFjdOb5UbtK5p18GEOMw=;
	b=TjkwM8BLifg3NYOdSrPt5M4eF0Ak9zNTGJOi3xovhvLv2ZMtq/EsqF0JPr5s/zxMchdvkp
	u46OPsoZ0raPCawJx907cCKMTiZAhQhC76KIUeOOzcHZz5bd96gVpwCUJyAS0cpfOjVGHy
	pC72r2ycNVHGsk/MwONeF8z0K+PUtDk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NIhFoz3V;
	spf=pass (imf04.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757752177; a=rsa-sha256;
	cv=none;
	b=O2D1gQKvDumuLSiEMczRtBSv5VRxmsnTLk9Wc2xI1RjOGitJDHpu05fWbvsGg4vceuY+iP
	XHeC2S5sm7iVmqHXGjIt6M97CMINpDmVOh9Vgu5YiTpKGrSPWbbZ+KjSFRk5jdClkGnIM4
	FlxUa+bqogA3fyU32hScDD8rtIpjHmQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757752176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PIeQDW6Tdi47ZNT16hYEbfLPFjdOb5UbtK5p18GEOMw=;
	b=NIhFoz3VgXF/QGRvyO+03CFEcS/Wfn1/wQo9xj9wzr3WSi3a34y+cc4XmfPE6qMOV4J4ZU
	v22SfJsqt7o18NDLohGsBrbnYqvVxy5lR1BYsGrBMJAn25UOH7Gk8jJzn1PDCI1QIbcsg5
	2EKjt8cUrPUQS6FCFjPOho21979wBd8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-212-Ke3lSLs4P8SczzOZFgRwfw-1; Sat,
 13 Sep 2025 04:29:34 -0400
X-MC-Unique: Ke3lSLs4P8SczzOZFgRwfw-1
X-Mimecast-MFC-AGG-ID: Ke3lSLs4P8SczzOZFgRwfw_1757752165
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 965251953943;
	Sat, 13 Sep 2025 08:29:24 +0000 (UTC)
Received: from localhost (unknown [10.72.112.45])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E99FA1954126;
	Sat, 13 Sep 2025 08:29:19 +0000 (UTC)
Date: Sat, 13 Sep 2025 16:29:15 +0800
From: Baoquan He <bhe@redhat.com>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	andreyknvl@gmail.com
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com,
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
	trintaeoitogc@gmail.com, axelrasmussen@google.com,
	yuanchu@google.com, joey.gouly@arm.com, samitolvanen@google.com,
	joel.granados@kernel.org, graf@amazon.com,
	vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz,
	kaleshsingh@google.com, justinstitt@google.com,
	catalin.marinas@arm.com, alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com, dave.hansen@linux.intel.com,
	corbet@lwn.net, xin@zytor.com, dvyukov@google.com,
	tglx@linutronix.de, scott@os.amperecomputing.com,
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org,
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com,
	mhocko@suse.com, ada.coupriediaz@arm.com, hpa@zytor.com,
	leitao@debian.org, peterz@infradead.org, wangkefeng.wang@huawei.com,
	surenb@google.com, ziy@nvidia.com, smostafa@google.com,
	ryabinin.a.a@gmail.com, ubizjak@gmail.com, jbohac@suse.cz,
	broonie@kernel.org, akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com, rppt@kernel.org, pcc@google.com,
	jan.kiszka@siemens.com, nicolas.schier@linux.dev, will@kernel.org,
	andreyknvl@gmail.com, jhubbard@nvidia.com, bp@alien8.de,
	x86@kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 17/19] mm: Unpoison pcpu chunks with base address tag
Message-ID: <aMUrW1Znp1GEj7St@MiWiFi-R3L-srv>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <bcf18f220ef3b40e02f489fdb90fc7a5a153a383.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
In-Reply-To: <bcf18f220ef3b40e02f489fdb90fc7a5a153a383.1756151769.git.maciej.wieczor-retman@intel.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qheyVIgArcSOqsiww18nX8zjEvs1OLPwgK_tidRSP64_1757752165
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 8371040002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: w5pe9ezdyk7s5r7wrttm5fhtite6cea4
X-HE-Tag: 1757752177-535249
X-HE-Meta: U2FsdGVkX18SWoJ1mZhRRA14PErf4+7lfNY2dKJusSR2D4jKDXyhwFz83AtoTVzh+hKK0Dp2J09iL+vSiCQmW8rmAeei2+O373wCbiSdbicLODX1jUcV3KjgdJwfuoZrg0bgFayl5sU8WLNIrD3+iVGCiMHgRKhSLyeraZ95iInbEGDljfCNooH+eK8qYOIg++eLgoJpHeui366AK7QzZlMLsBqyNjXYwBFAsWftUHI2Q+ezlXSZMyEEtQPujauOGXCbO101gu1awE3ZpPwZodcUyiYJbMJFYn4TG3Nl1bhLVI3VKtC+saCs7LPUuOTzqo3oDO+VPMD+z0T9bfs4VTPnAG5pdZM+h0OF1XTEoGaLoTSmt0GhMqL41HKehaM5nj7vnbyRXGBIZZxBzETGZ0ucQ0WtExEH46odIYFGySR2GLphl2n+l66ZnpHGhKceSHxLrUXwT8BGu9Gk4+bsUCnOpjzetyEMKG47sR6Nrlg0xNY6/gIjUBeJHydyoA0VgzXbLGUvyDibgTzMIz8XfABZswB6NQowl3wIQRRIENKbwY/r8MqFcScnBFwvaMfwF2NiBvctz5N+UadJZnqjQZZkZIJg5jIQopE257qcQuZr4VDG9mKS2kHYIpkgFUg2STj1QLRLYpPEsd6s1QuebTKIQE9j26sDQvtFKepkPAN2FATqeYhUsKX2N7ENbJCjrqZ+oo5SKZbF4/0db5FObnZfAaYK5xND2ScVe6M8XPJxEmp+6KLFsHUg/gNHTpcyNkwnYzjhb2afTiTZRNFvZMs67V6zKI8VboX0UmooXOfz/cXEKQDblzrrTYJWpHt00ehBQW6vhhyDbe1Vzvk5KR2/WM67XnroQ2ofCano2Uc3SXYukuKo+wL1r4Geq5+Coy0b+BORWLr9E5I6hMEHN/IcTpFtE4/hA3yg1czpolTmcIkJpExRche04YKUmUDYTh38U7HZ8QK1rUBXhak
 XQbrQFnz
 kCb1mw2xlZctuqG+T1hWROxSI95SIfuiPXsC2pCNaoOIAtZKwz4mBDGfdb4RLu6QFk5j+DSznT6w42nn7gl5ASyVbN9o1bteRQ7VIrPgSLGTyI9gEo34h0p8HchUrnyvJ8Xuyhk6Qjyytxwodx5PvzKgiNn5pVntPehE4vOLvJJMnXkuy3BYv6rM0RCBUejk6tgfUXFW5WiGvnEJI0tHHjaeTxBQB4sddFQ5SMPuE5BNwTQwCwDL/p2+BC30iXyPzG6dKzocJgGT1gMqdvz5BtQ8aroPVWBKINYIEw6Vr1gUOYhD1zANjSd/EVpQK4u+8lfrdPTpjcqxqDbA6K/tkaEWWi2Ink8qyN+q06uFRiiQHE6qY3e6zZ8SDuKz3bJ9YsOFyGCEgUbVTmpLTmeUs0UUDU/L6yKXcn3I1XZdCxTjxk3Ex2Uxu4qhIXaxHnwkZ4oLM+oLm8CFHcF9DK+F5QsD38ew5jy0SG4hy/fTPOTGwL93YrAwjHiQk3+5WNjAgiRG5K3J/wzJoVeAWUSsenlWLnxNtvw+6Coj0BEzj4jXGowTOxDjd0QU5cb1+k0BFjexzRIOuDP5zKX2WlVsddkEGVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi ,

On 08/25/25 at 10:24pm, Maciej Wieczor-Retman wrote:
> The problem presented here is related to NUMA systems and tag-based
> KASAN mode. It can be explained in the following points:
> 
> 	1. There can be more than one virtual memory chunk.
> 	2. Chunk's base address has a tag.
> 	3. The base address points at the first chunk and thus inherits
> 	   the tag of the first chunk.
> 	4. The subsequent chunks will be accessed with the tag from the
> 	   first chunk.
> 	5. Thus, the subsequent chunks need to have their tag set to
> 	   match that of the first chunk.
> 
> Refactor code by moving it into a helper in preparation for the actual
> fix.

I got a boot breakage on a hpe-apollo arm64 system with sw_tags mode, and
the boot breakage can be met stably. The detailed situation is reported
in below link:

System is broken in KASAN sw_tags mode during bootup
https://lore.kernel.org/all/aKMLgHdTOEf9B92E@MiWiFi-R3L-srv/T/#u

After applying this patch 17 and patch 18 in this series, I can confirm
the breakage is gone. Thanks for the great fix, and please feel free to
add:

Tested-by: Baoquan He <bhe@redhat.com>

========================
CONFIG_KASAN=y
CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=y
# CONFIG_KASAN_GENERIC is not set
CONFIG_KASAN_SW_TAGS=y
# CONFIG_KASAN_HW_TAGS is not set
# CONFIG_KASAN_OUTLINE is not set
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
CONFIG_KASAN_KUNIT_TEST=m
================================

[  100.907469] ==================================================================
[  100.907485] BUG: KASAN: invalid-access in pcpu_alloc_noprof+0x42c/0x9a8
[  100.907509] Write of size 160 at addr 10fffd7fbdc00000 by task systemd/1
[  100.907524] Pointer tag: [10], memory tag: [5b]
[  100.907532]
[  100.907544] CPU: 229 UID: 0 PID: 1 Comm: systemd Not tainted 6.16.0+ #2 PREEMPT(voluntary)
[  100.907562] Hardware name: HPE Apollo 70             /C01_APACHE_MB         , BIOS L50_5.13_1.16 07/29/2020
[  100.907571] Call trace:
[  100.907578]  show_stack+0x30/0x98 (C)
[  100.907597]  dump_stack_lvl+0x7c/0xa0
[  100.907614]  print_address_description.isra.0+0x90/0x2b8
[  100.907635]  print_report+0x120/0x208
[  100.907651]  kasan_report+0xc8/0x110
[  100.907669]  kasan_check_range+0x80/0xa0
[  100.907685]  __asan_memset+0x30/0x68
[  100.907700]  pcpu_alloc_noprof+0x42c/0x9a8
[  100.907716]  css_rstat_init+0x1bc/0x220
[  100.907734]  cgroup_create+0x188/0x540
[  100.907749]  cgroup_mkdir+0xb4/0x330
[  100.907765]  kernfs_iop_mkdir+0xb0/0x120
[  100.907783]  vfs_mkdir+0x250/0x380
[  100.907800]  do_mkdirat+0x254/0x298
[  100.907815]  __arm64_sys_mkdirat+0x80/0xc0
[  100.907831]  invoke_syscall.constprop.0+0x88/0x148
[  100.907848]  el0_svc_common.constprop.0+0x78/0x148
[  100.907863]  do_el0_svc+0x38/0x50
[  100.907877]  el0_svc+0x3c/0x160
[  100.907895]  el0t_64_sync_handler+0x10c/0x138
[  100.907911]  el0t_64_sync+0x1b0/0x1b8
[  100.907925]
[  100.907931] The buggy address belongs to a 0-page vmalloc region starting at 0x5bfffd7fbdc00000 allocated at pcpu_get_vm_areas+0x0/0x1da8
[  100.907963] The buggy address belongs to the physical page:
[  100.907970] page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x8811a35
[  100.907984] flags: 0xa6a00000000000(node=1|zone=2|kasantag=0x6a)
[  100.908006] raw: 00a6a00000000000 0000000000000000 dead000000000122 0000000000000000
[  100.908019] raw: 0000000000000000 b4ff00878bce6400 00000001ffffffff 0000000000000000
[  100.908029] raw: 00000000000fffff 0000000000000000
[  100.908037] page dumped because: kasan: bad access detected
[  100.908044]
[  100.908048] Memory state around the buggy address:
[  100.908059] Unable to handle kernel paging request at virtual address ffff7fd7fbdbffe0
[  100.908068] KASAN: probably wild-memory-access in range [0xfffffd7fbdbffe00-0xfffffd7fbdbffe0f]
[  100.908078] Mem abort info:
[  100.908083]   ESR = 0x0000000096000007
[  100.908089]   EC = 0x25: DABT (current EL), IL = 32 bits
[  100.908098]   SET = 0, FnV = 0
[  100.908105]   EA = 0, S1PTW = 0
[  100.908111]   FSC = 0x07: level 3 translation fault
[  100.908118] Data abort info:
[  100.908123]   ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
[  100.908130]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  100.908138]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  100.908147] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000008ff8b76000
[  100.908156] [ffff7fd7fbdbffe0] pgd=1000008ff0299403, p4d=1000008ff0299403, pud=1000008ff0298403, pmd=1000008811a17403, pte=0000000000000000
[  100.908192] Internal error: Oops: 0000000096000007 [#1]  SMP
[  101.185060] Modules linked in: i2c_dev
[  101.188820] CPU: 229 UID: 0 PID: 1 Comm: systemd Not tainted 6.16.0+ #2 PREEMPT(voluntary)
[  101.197175] Hardware name: HPE Apollo 70             /C01_APACHE_MB         , BIOS L50_5.13_1.16 07/29/2020
[  101.206912] pstate: 604000c9 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  101.213877] pc : __pi_memcpy_generic+0x24/0x230
[  101.218418] lr : kasan_metadata_fetch_row+0x20/0x30
[  101.223299] sp : ffff8000859b7700
[  101.226610] x29: ffff8000859b7700 x28: 0000000000000100 x27: ffff008ec6291800
[  101.233758] x26: 00000000000000a0 x25: 0000000000000000 x24: fffffd7fbdbfff00
[  101.240904] x23: ffff8000826b1e58 x22: fffffd7fbdc00000 x21: 00000000fffffffe
[  101.248051] x20: ffff800082669d18 x19: fffffd7fbdbffe00 x18: 0000000000000000
[  101.255196] x17: 3030303030303030 x16: 2066666666666666 x15: 6631303030303030
[  101.262342] x14: 0000000000000001 x13: 0000000000000001 x12: 0000000000000001
[  101.269487] x11: 687420646e756f72 x10: 0000000000000020 x9 : 0000000000000000
[  101.276633] x8 : ffff78000859b76a x7 : 0000000000000000 x6 : 000000000000003a
[  101.283778] x5 : ffff8000859b7768 x4 : ffff7fd7fbdbfff0 x3 : efff800000000000
[  101.290924] x2 : 0000000000000010 x1 : ffff7fd7fbdbffe0 x0 : ffff8000859b7758
[  101.298070] Call trace:
[  101.300512]  __pi_memcpy_generic+0x24/0x230 (P)
[  101.305051]  print_report+0x180/0x208
[  101.308719]  kasan_report+0xc8/0x110
[  101.312299]  kasan_check_range+0x80/0xa0
[  101.316227]  __asan_memset+0x30/0x68
[  101.319807]  pcpu_alloc_noprof+0x42c/0x9a8
[  101.323908]  css_rstat_init+0x1bc/0x220
[  101.327749]  cgroup_create+0x188/0x540
[  101.331502]  cgroup_mkdir+0xb4/0x330
[  101.335082]  kernfs_iop_mkdir+0xb0/0x120
[  101.339011]  vfs_mkdir+0x250/0x380
[  101.342416]  do_mkdirat+0x254/0x298
[  101.345908]  __arm64_sys_mkdirat+0x80/0xc0
[  101.350008]  invoke_syscall.constprop.0+0x88/0x148
[  101.354803]  el0_svc_common.constprop.0+0x78/0x148
[  101.359598]  do_el0_svc+0x38/0x50
[  101.362916]  el0_svc+0x3c/0x160
[  101.366061]  el0t_64_sync_handler+0x10c/0x138
[  101.370423]  el0t_64_sync+0x1b0/0x1b8
[  101.374095] Code: f100805f 540003c8 f100405f 540000c3 (a9401c26)
[  101.380187] ---[ end trace 0000000000000000 ]---
[  101.384802] note: systemd[1] ex
** replaying previous printk message **


> 
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> ---
> Changelog v4:
> - Redo the patch message numbered list.
> - Do the refactoring in this patch and move additions to the next new
>   one.
> 
> Changelog v3:
> - Remove last version of this patch that just resets the tag on
>   base_addr and add this patch that unpoisons all areas with the same
>   tag instead.
> 
>  include/linux/kasan.h | 10 ++++++++++
>  mm/kasan/hw_tags.c    | 11 +++++++++++
>  mm/kasan/shadow.c     | 10 ++++++++++
>  mm/vmalloc.c          |  4 +---
>  4 files changed, 32 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 7a2527794549..3ec432d7df9a 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -613,6 +613,13 @@ static __always_inline void kasan_poison_vmalloc(const void *start,
>  		__kasan_poison_vmalloc(start, size);
>  }
>  
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms);
> +static __always_inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{
> +	if (kasan_enabled())
> +		__kasan_unpoison_vmap_areas(vms, nr_vms);
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>  
>  static inline void kasan_populate_early_vm_area_shadow(void *start,
> @@ -637,6 +644,9 @@ static inline void *kasan_unpoison_vmalloc(const void *start,
>  static inline void kasan_poison_vmalloc(const void *start, unsigned long size)
>  { }
>  
> +static inline void kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{ }
> +
>  #endif /* CONFIG_KASAN_VMALLOC */
>  
>  #if (defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)) && \
> diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
> index 9a6927394b54..1f569df313c3 100644
> --- a/mm/kasan/hw_tags.c
> +++ b/mm/kasan/hw_tags.c
> @@ -382,6 +382,17 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
>  	 */
>  }
>  
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{
> +	int area;
> +
> +	for (area = 0 ; area < nr_vms ; area++) {
> +		vms[area]->addr = __kasan_unpoison_vmalloc(
> +			vms[area]->addr, vms[area]->size,
> +			KASAN_VMALLOC_PROT_NORMAL);
> +	}
> +}
> +
>  #endif
>  
>  void kasan_enable_hw_tags(void)
> diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
> index d2c70cd2afb1..b41f74d68916 100644
> --- a/mm/kasan/shadow.c
> +++ b/mm/kasan/shadow.c
> @@ -646,6 +646,16 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
>  	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
>  }
>  
> +void __kasan_unpoison_vmap_areas(struct vm_struct **vms, int nr_vms)
> +{
> +	int area;
> +
> +	for (area = 0 ; area < nr_vms ; area++) {
> +		kasan_poison(vms[area]->addr, vms[area]->size,
> +			     arch_kasan_get_tag(vms[area]->addr), false);
> +	}
> +}
> +
>  #else /* CONFIG_KASAN_VMALLOC */
>  
>  int kasan_alloc_module_shadow(void *addr, size_t size, gfp_t gfp_mask)
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c93893fb8dd4..00be0abcaf60 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4847,9 +4847,7 @@ struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
>  	 * With hardware tag-based KASAN, marking is skipped for
>  	 * non-VM_ALLOC mappings, see __kasan_unpoison_vmalloc().
>  	 */
> -	for (area = 0; area < nr_vms; area++)
> -		vms[area]->addr = kasan_unpoison_vmalloc(vms[area]->addr,
> -				vms[area]->size, KASAN_VMALLOC_PROT_NORMAL);
> +	kasan_unpoison_vmap_areas(vms, nr_vms);
>  
>  	kfree(vas);
>  	return vms;
> -- 
> 2.50.1
> 
> 


