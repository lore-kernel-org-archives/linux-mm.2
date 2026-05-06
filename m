Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FAACD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B440E6B008C; Wed,  6 May 2026 11:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C0A6B0092; Wed,  6 May 2026 11:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A580D6B0093; Wed,  6 May 2026 11:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9941B6B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:42:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38744A021B
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:42:54 +0000 (UTC)
X-FDA: 84737413068.28.72BC6BF
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4F6F312000A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:42:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kSh8dIPP;
	spf=pass (imf29.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778082172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+8u7ZeVl4jM3ubfIv7a6q2qcz+9XFAVFIgJhK8Wcji4=;
	b=KoZuSTcfPzRNgbk5V4GMvtDy1cZJOXUqcbHDLB/FwccYIxRldCpuUUWGyrIrBKq2waE5GQ
	j35OLioecBD+VhciHDGpJlGdwupSkdPq0ytXFT9Y8B5mMWg0zS845oclELnU3TbZpAbKe4
	77+DVjSr58pvbbo7owY69W0YsqkD2tA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kSh8dIPP;
	spf=pass (imf29.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778082172; a=rsa-sha256;
	cv=none;
	b=NqJBdKOKygG7Q6lX7kCvdfH9h00erQ7R0zcQlqYAp4xuNAqCMsI/XUFtfk3YP8A6UGjEvk
	2BUOUbxvW8v5odSF8xv4K9A6/xzx7SYUyLH6NL9Pt4TnmJ01JXD96oAAdg/sGpo/2OPb7E
	d1BSWUs/NCsPQkNOIZ3etXGzo942atc=
Message-ID: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778082169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+8u7ZeVl4jM3ubfIv7a6q2qcz+9XFAVFIgJhK8Wcji4=;
	b=kSh8dIPPuOZFcTjB5Rm5KJfMnwa+1I18AUuqRdsZcu7LQIaBnGw+8ZMr04P+PGmmJ2EWQZ
	z6EK+PiL4kk/n9jcTd+Bp0GCbnIjW8/BPeuIljqVQ3DaB5fSL/1fLPaettRyuYsP+yD5n2
	EJBM5jlM4hErxw4my6YJIeh5bKPl0c4=
Date: Wed, 6 May 2026 23:42:40 +0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
Content-Language: en-US
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: "alloc_tag was not set" when running mm/ksft_hmm.sh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4y9oi7iyo3sb6w41wszacg3a3fkew1fu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F6F312000A
X-Rspam-User: 
X-HE-Tag: 1778082172-496691
X-HE-Meta: U2FsdGVkX19kXmedUPdJYhVj2gstTC9tbGAF2gzQvgdRSWR4LTyzuGpLvUd4E0WkN6V8p0++hUOMnOYuvzrVPMPHR4tUozMZNS9+Fe5SWJHR1265a9bV2Y2QZ4qLQpkKrcmC5ag7dsaZ1HHfOezGl9dX+JEo24/6lYk45ZWHL9ugC9E+/nNd9QRkimzvmMhNJQteeOh09AtuaJIUqWxkBVk7os36PLjWHADB73mYG9zPkFaBd/hAwTl5HXERWFEjF2oJ2AnkUaIl8CmGyXoC+WBsubdlfLuPqpVHUyzKV4E7EfdTWRqBH8hXtagRg0AwXqIMqp2NoSBdPBhFzXFF+YxtCO2tpEH2bM+JAgz2KIHZLsGU8F8JGUgNOvJjRiG9ggTVBbjhKp1JVkBSFXW8e8fqgSYtSqM0U4p61lFJTAsjUtMeqZnGbJqziFzljRYXA8ltdllEN3SORK0zUrvbpSScRYUY6q4abNhl2i8+yKP2qk7YPtWWqqU+1fIHJx7irb/YElhB41ffBn9YLdZr/HCPw6QzHHlrXi8kxP+RC+EykWINzOblQ5W7lT29OrHmMsOBMoHkIPy7hVCyhmCU0Ee2qhKfKqdVkz/OimlSW3ddseWU6LmO6i6Y4o5qTgux6VsIx+zB6BPKD+TrHS85JddJ8k2aVeBO1zAZVNjIQFjbYqIxWPbxBWxlsINUQllK+JkgF4eD2ZAmu4Yi+4UkmGPobhjEZPajMSgJUqmkwFcUfNc6VYbSFcaLjCX1z/Off0QNjWUls478QuTIrqy+Mi32AtB/r5vW4mQOStbGRRdV8UDF5I78xt0T6PuVZKE/nKb9BPfheMHhOz1PA//ViqnovkDiZW/YdzWAXEwsRg33zH0sYoPRbf+2IVCYxHsh+siqLtCJpnlhQTSp5o021GCI9RE72+wwQw41AQ+GYi3mYerr1Ot+5uVZrvGypz6HO3Qj2GPwJ8KZoVcj5N9
 EJW1cB8w
 SZCYzjNKf0ZQ110OGDv6QJYjHp6NDTHMTHVy8z/nceynN2CKcTpijHfFIet9qBcuCDePVnlztDw50tZOJalgq9hYxtruojrlKoTLBv4WWwhNteN0khgCkJiF8TtbRasZz438gh4VNHOyJOa8YvN2hTo3alymWft767+lunBq80MQJlgAwlmtyx5AFLpH/ySnl07URj7nQJ5Aq1pcroun+flo0ka610ZNrn2WcsSbcZFoo0FjhJ3ljzbhReZjxRhOo2GDakYWYi9knTFfpMgL2GYVtQu0fLfodAhIviAL0vOZ5QhRW3OTvOVtlNjyBqmEodQKH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Running mm/ksft_hmm.sh triggers the following splat:

 ------------[ cut here ]------------
 alloc_tag was not set
 WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0,
CPU#5: hmm-tests/2020
 Modules linked in: test_hmm rfkill drm backlight fuse
 CPU: 5 UID: 0 PID: 2020 Comm: hmm-tests Kdump: loaded Not tainted
7.1.0-rc2-00099-gadc1e5c6203c-dirty #285 PREEMPT
 Hardware name: QEMU QEMU Virtual Machine, BIOS
edk2-stable202408-prebuilt.qemu.org 08/13/2024
 pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
 pc : ___free_pages+0x2a0/0x2d0
 lr : ___free_pages+0x2a0/0x2d0
 sp : ffff80008345b530
 x29: ffff80008345b530 x28: ffff80008345b700 x27: ffffffffbfff8040
 x26: ffff0000c41cb360 x25: ffff0000c0c64008 x24: ffff800081aae400
 x23: 05ffff0000000200 x22: 0000000000000000 x21: 0000000000000000
 x20: fffffdffc5f20040 x19: 0000000000000000 x18: fffffffffffe7c78
 x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffe7c98
 x14: 00000000000001d1 x13: ffff8000818f3d58 x12: 0000000000000573
 x11: fffffffffffe7c98 x10: ffff80008194bd58 x9 : 3ffffffffffff000
 x8 : ffff8000818f3d58 x7 : ffff80008194bd58 x6 : 0000000000000000
 x5 : ffff0001fedb1088 x4 : 0000000000000001 x3 : 0000000000000000
 x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c7f58000
 Call trace:
  ___free_pages+0x2a0/0x2d0 (P)
  __free_pages+0x14/0x20
  dmirror_devmem_free+0x13c/0x158 [test_hmm]
  free_zone_device_folio+0x144/0x1e4
  __folio_put+0x124/0x130
  free_folio_and_swap_cache+0xa8/0xcc
  __folio_split+0x664/0x7fc
  split_folio_to_list+0x50/0x5c
  migrate_vma_split_folio+0x13c/0x25c
  migrate_vma_collect_pmd+0xed4/0xf68
  walk_pgd_range+0x598/0x9a0
  __walk_page_range+0x90/0x1a0
  walk_page_range_mm_unsafe+0x194/0x20c
  walk_page_range+0x20/0x2c
  migrate_vma_setup+0x18c/0x224
  dmirror_devmem_fault+0x188/0x2b8 [test_hmm]
  do_swap_page+0x1458/0x185c
  __handle_mm_fault+0x85c/0x1ba0
  handle_mm_fault+0xb0/0x290
  do_page_fault+0x1f8/0x6f8
  do_translation_fault+0x60/0x6c
  do_mem_abort+0x44/0x94
  el0_da+0x30/0xdc
  el0t_64_sync_handler+0xd0/0xe4
  el0t_64_sync+0x198/0x19c
 ---[ end trace 0000000000000000 ]---
 lib/test_hmm.c:705 module test_hmm func:dmirror_devmem_alloc_page has
16744448 allocated at module unload


It was tested on kernel built with arm64's virt.config and

+CONFIG_ZONE_DEVICE=y
+CONFIG_DEVICE_PRIVATE=y
+CONFIG_TEST_HMM=m
+CONFIG_MEM_ALLOC_PROFILING=y
+CONFIG_MEM_ALLOC_PROFILING_DEBUG=y

Thanks,
Zenghui

