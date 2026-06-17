Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14354CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 09:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69696B008A; Wed, 17 Jun 2026 05:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A8E6B008C; Wed, 17 Jun 2026 05:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C30156B0092; Wed, 17 Jun 2026 05:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9305E6B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:40:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 103F21C39DF
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:40:46 +0000 (UTC)
X-FDA: 84888910092.05.E3A2A10
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 426CD140009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:40:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=a1NqyOZT;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781689244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/OJ3K9rTkOIlY7WWVITVWwnzTwDC6V7F9kkJkXQoTo=;
	b=Ky+9r/XTHHKyppoBArHUmYEdLB+SDKEpfDjDuQlyVQ/rxzMM8KOP7V3QA4TLEwGtEMKDG3
	CKtwrlFAo8kASZfgb5v+1tnobKpjw0mbXh6wygqn6VbrL7BXrePOiRIUdNrM4aMvKrlZhG
	CS46NixiZ7htIMtzbhrDjJ9ZY8TdJz0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=a1NqyOZT;
	spf=pass (imf23.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781689244;
	b=qlhxk2pN9UjNYkjfufOQidbNhzUIeJJl2Wrn0Yhuv6KAsStbOdvGDRQ095rrD4sVeBtjQI
	/AoSQ8c/mCkDN4cmI2IwbtrkJy/Km/xBaqO1D1a/qzc82LCSdJUE7gy6B4DgIchK/1b0tx
	8YldREHGMa+A6Fzko+qprj9CDbe7dyQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=o/OJ3K9rTkOIlY7WWVITVWwnzTwDC6V7F9kkJkXQoTo=; b=a1NqyOZTRvdH/2jRwOv2SEzPR4
	w9g+aT75GU3bVUstqfQFMqP3TvZgSLyAKzSpai1RgWWTlBC4ZgxP0AB9tB2i2GqbQzG6I7zVdv0U5
	r0eur5xDS7+7NiOIhnRSxPyGwzObWhKDLsAN57WGenyNSjVpZLcwBF7rMI0hVwbpz8jWJ3MsKwFxh
	5n1GUJfkhzzJkXhsX6JsqcjeITzTZeuCnQVrDr5OkehVDKWLgFLskCp+Lb2PTJRkP23suSb6xkAOh
	SR/lRmnaBOYtaw+7wAg8VeK2X1ur7ef62V/PCw1l+r7UuAAmSCooAWiSCshP2FTuujBJmPysig/9D
	CiFgGAKw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wZmkn-00EWde-0g;
	Wed, 17 Jun 2026 09:40:13 +0000
Date: Wed, 17 Jun 2026 02:40:06 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v9 0/6] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <ajJq-uVRBH5SBkwK@gmail.com>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 426CD140009
X-Stat-Signature: ek8qx4n8pehsbt1wdkxajecp6pu7j6s7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781689244-390481
X-HE-Meta: U2FsdGVkX1+0wSM3s20b/jQDdklKTltuMICubOYkzUnwRe9SxVSUPaBO6onEg3h1v9UL6pHIrw6ueaAeeYyZSpwey55810m+saRg/tbHhpyQKHDQ+dtYlBmX2LqU2wqzDouNBqVr3Y6OjWGSr6rJ448ff7KxEZdo6xt20u5Ntp9lahK2nCf3e7gIBnvpqHo0dIBoae2+wAHqAbSJ4FLXyq+NDj54wJyZWFCiAH/6xPhwzV1l+n8k4bf8KnH09bGxRrFIEg4Q6J82Dlz5Op2nONuFW+Y/MwxjflF/TDMbARfvzKbX50g2Su1KAGw07oa679ttfGF0c+m9lsTyYDY9TTeK0eQuCB4q2rntxa98XlOQSJb80wJdZOtUuJrsiVskPPNaOUAohhHR3TNKIrc7LNrU+/XehhCPEWEvVX9zd3EJxJ3zSIf1kf8vpn0FKwkelEn/q7s+A+u1HyX/CW6Wywe8IO/DBoig71SC9aM415FdwlwHU8cwPW1yAZa8EHcWvfKIy9b7PgGOW1zYEeg4vRgAt/va+pXZjfHzTxVRAPoTl6vp4jZNbBtxgvbvu7Rg4k28fRpgt8FprBmgyM3UzDneHfhOC1cREqJ9dWUl5zBq4XPML+GX0puog9z5t+oZmM+rQR7+VJmj935sux4fe3ORQX+n8o5F9U5zTe04yiIkJEkSrI4w0PmtA4yAQZ2WPU/oazNaqruT0fg0hAgQ7IRYYVISg8lA+dhP5dllXnSVb6tNpAIRebIUZsXpvHlIaxHxlfbfNOJ5JcMGZc2V3n/4xpFmAkE7uZmubu1201y9//3+/rvW6cKOoV2C6S4QGt7ttTUAGw7JtQFaNi4RDngw9ijJGFYZISZRPqqkutP5fR0CDGgPNXVzvnmVAWVM0G7mw1jS6OKMm/joPH9dv6ZiacD6kbLOVsXMgi1uLM89kGPV8S955YmW9XkPU4rYIFqrMv3rgbw/LkzKQZN
 n13IsDcr
 HXYBXhv7dyFHolCZ1dF0p3k+JjqawkI8MOFJnSp/1TbgW+CZbZ0qF4wrzTMRk1xSgMG2yzPXSZ9qYsXCihXFrf2Wv9/7N7nMze7aY+FCTwQHKE2rcUQSK/Fc2RUtbAHcTobWZJIGOr3jGtYF2JAhz9MRc7X3nwU5O/qcpE0ZUYvSwarqGnqNyxWx8YL5waNiG8mrIY3TnK+fuhRPgmTaBIQSsnbYcEq3kaklY0hgeZ0bauzuJRaEufIReXTnTi+TlK0ek+PaRo0kvx3xoNiWZ6wrjppQXWb6MuAVPPa2M6QfewtaNYbZWXWTrghn4mYvIKhCCdFpQ06Uu/wioIgVnIAjTe+/k44Uoz4x7IOPKZZUvBPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 03:56:54AM -0700, Breno Leitao wrote:
> A multi-bit ECC error on a kernel-owned page that the memory failure
> handler cannot recover is currently swallowed: PG_hwpoison is set, the
> event is logged, and the kernel keeps running.  The corrupted memory
> remains accessible to the kernel and either drives silent data
> corruption or surfaces seconds-to-minutes later as an apparently
> unrelated crash.  In a large fleet that delayed, unattributable crash
> turns into significant engineering effort to root-cause; in a kdump
> configuration, by the time the crash happens the original error
> context (faulting PFN, MCE/GHES record, page state) is long gone.
> 
> This series adds an opt-in sysctl,
> vm.panic_on_unrecoverable_memory_failure, that converts an
> unrecoverable kernel-page hwpoison event into an immediate panic with
> a clean dmesg/vmcore that still contains the original failure
> context.  The default is disabled so existing workloads see no
> change.
> 
> There is a selftest that test different cases, and I tested it using
> the following variants:
> 
>   ┌─────────┬──────────┬───────────────────────────────────────────────────────────┐
>   │ Variant │   PFN    │                          Result                           │
>   ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
>   │ rodata  │ 0x2600   │ Panic with "Memory failure: 0x2600: unrecoverable page"   │
>   ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
>   │ slab    │ 0x100032 │ Panic with "Memory failure: 0x100032: unrecoverable page" │
>   ├─────────┼──────────┼───────────────────────────────────────────────────────────┤
>   │ pgtable │ 0x100000 │ Panic with "Memory failure: 0x100000: unrecoverable page" │
>   └─────────┴──────────┴───────────────────────────────────────────────────────────┘
> 
> Each one shows the same call trace, exactly the path the series builds:
> 
>   hard_offline_page_store
>     → memory_failure
>       → action_result
>         → panic("Memory failure: %#lx: unrecoverable page")

Debugging another issue earlier today, just found a kernel crash that is
hitting a ignored page later in the day, and randomly misbehaving/crashing.

 Memory failure: 0x140ae: unhandlable page.
 Memory failure: 0x140ae: recovery action for get hwpoison page: Ignored                     <-- Ignored 
 loop0: detected capacity change from 0 to 15241056
 EDAC MC0: 1 UE multi-bit ECC on LP5x_0 LP5x_0 (node:0 card:0 module:0 rank:0 bank:2 device:28 row:42700 column:96
 {3}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 308
 {3}[Hardware Error]: event severity: recoverable
 {3}[Hardware Error]:  imprecise tstamp: 2026-06-16 02:50:03
 {3}[Hardware Error]:  Error 0, type: recoverable
 {3}[Hardware Error]:   section_type: memory error
 {3}[Hardware Error]:   physical_address: 0x0000000aeccde180
 {3}[Hardware Error]:   physical_address_mask: 0xfffffffffffff000
 {3}[Hardware Error]:   node:0 card:0 module:0 rank:0 bank:2 device:28 row:42700 column:960 requestor_id:0x0000000
 {3}[Hardware Error]:   error_type: 3, multi-bit ECC
 {3}[Hardware Error]:   DIMM location: LP5x_0 LP5x_0
 Memory failure: 0xaeccd: recovery action for dirty LRU page: Recovered

 Internal error: synchronous external abort: 0000000096000410 [#1]  SMP
 Modules linked in: ghes_edac(E) squashfs(E) act_gact(E) sch_fq(E) tcp_diag(E) inet_diag(E) cls_bpf(E) evdev(E) sm
 CPU: 51 UID: 0 PID: 1 Comm: systemd Kdump: loaded Tainted: G   M       OE K     6.16.1-0_fbk2_0_gf40efc324cc8 #1
 Tainted: [M]=MACHINE_CHECK, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE, [K]=LIVEPATCH
 pstate: 834010c9 (Nzcv daIF +PAN -UAO +TCO +DIT +SSBS BTYPE=--)
 pc : clear_inode+0x34/0x108
 lr : proc_evict_inode.llvm.1771226604092943895+0x28/0x68
 sp : ffff800083f6f8d0
 x29: ffff800083f6f8e0 x28: 0000000000000011 x27: ffff0000c1378788
 x26: ffffffffffffffff x25: ffff800082747de0 x24: ffff0000c0ae9898
 x23: ffff8000819155f8 x22: ffff0000c0ae9888 x21: ffff0000c0ae9808
 x20: ffff0000c0ae9818 x19: ffff0000c0ae9788 x18: 000000000000001c
 x17: 0000000000000018 x16: 0000000000000040 x15: 0000000000000000
 x14: 0000000000000001 x13: 0000000000000000 x12: 0000000000002710
 x11: ffff0000c0ae9898 x10: ffff0000c1299b58 x9 : 0000000000000001
 x8 : ffff0000c0ae9900 x7 : ffff8000828db000 x6 : 0000000000005040
 x5 : ffffffffffffffff x4 : ffffffdfc05c8aa0 x3 : ffff000126470000
 x2 : ffffffffffffffff x1 : 0000000000000000 x0 : ffff0000c0ae9788
 Call trace:
  clear_inode+0x34/0x108 (P)
  proc_evict_inode.llvm.1771226604092943895+0x28/0x68
  evict+0xec/0x328
  iput+0xa8/0x310
  dentry_unlink_inode+0xa4/0x188
  __dentry_kill+0x74/0x358
  shrink_dentry_list+0xc8/0x198
 ....

