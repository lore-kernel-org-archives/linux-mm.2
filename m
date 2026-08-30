Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54000C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 02:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DACB26B0088; Sat, 29 Aug 2026 22:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D36826B008A; Sat, 29 Aug 2026 22:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8DB6B008C; Sat, 29 Aug 2026 22:38:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 903D96B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:38:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DC53140222
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:38:03 +0000 (UTC)
X-FDA: 85156376046.01.E987E5B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6660240002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:38:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QVajQr8N;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788057481;
	b=C0SBIkmjf98GOCCN15kB0bgLxbwWwzHjKsdiPKKEcomvIgNEbSL9yKjwpC7U2WvBo2OzKX
	ZfAAH6oxBxGb0xqe+7rFpO4KrWQ7HDytYwRJygFEyHZmQif1tzoYSoITZBxDliM+blh73v
	syRSlMcZDlS1gI5pfZcfMRH/WBecKEs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=QVajQr8N;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788057481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JYy4cwxYHYB3SLpHqiVEkE1C6SYKPTNsf1PpaVEnwg=;
	b=ZaIw/FRnco7HPic14HdNHrB4IIdqpuIWWmGATWd16ug6vNP3PB6EL/MSbGbKmj6S/7E14A
	K5kGXQNsCQO++BHlKXpdd/aaPEw+NbevBi4oLBrDiLa0Ydlr48tICGHk6+E2VxcKx+jCFy
	Q122V72Bgpp03D88OgSm+ZgG6EKEwoY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7006A600AE;
	Sun, 30 Aug 2026 02:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC531F000E9;
	Sun, 30 Aug 2026 02:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788057479;
	bh=8JYy4cwxYHYB3SLpHqiVEkE1C6SYKPTNsf1PpaVEnwg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QVajQr8NNF6WPo/YrfP06JWv6nBxuMXUVYkL4jV+k7kofGQyAqz7WQZ82AizCeFUZ
	 kAT3EfC07ssgCo3wsWRLa38WTRca6Bkg907opIQTsW6d1FYUAiYxWdnnhbzERCR/8a
	 erqZhgAOb21E3uccdcRdMiINp9YIOYLA7PNTvGX0=
Date: Sat, 29 Aug 2026 19:37:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti
 <alex@ghiti.fr>, david@kernel.org, SJ Park <sj@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kernel-team@meta.com
Subject: Re: [PATCH v2] tools/mm: add hwpoison-panic tool
Message-Id: <20260829193758.b251f3c89f8201bdc585a305@linux-foundation.org>
In-Reply-To: <20260803-memory_failure_rewrite_test-v2-1-ed020ce42129@debian.org>
References: <20260803-memory_failure_rewrite_test-v2-1-ed020ce42129@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6660240002
X-Stat-Signature: 1qzammo3s6cfncbjuje9rtudcuzayz8u
X-Rspam-User: 
X-HE-Tag: 1788057481-478119
X-HE-Meta: U2FsdGVkX18Ptou9nmdRuvWaCNy0DCjfvS6doAunH54NcPeQSz7tsRLxEnz8ved7ncwGcBvsz3hq1IPuN5qqYFr0bF/yA+76LhtUC3mO4HAA+F+N5JPlVKV5GRVZqjPpV0yfHbxfpLEHT3aUOI0mCX4z6RU2paQfwb3kEY1DyYyHr79zdaQuJSOp+LrapniUIRvjlWwpVq2uJA1T+70ndt51UkHZEZLQuW6xajYzoquHX+h9piUJv/Lcu7185Ea6GNM9CXjxdg/nSzAktPf//JqiACIJAEyf/m6dVNdS/d82hDCQZP5lMfsuYvhWY6zURYqkhuwZkm7kCyrmna8xYi+ykrNCsuSg20ViAVqefKX3g65BKZxepDw8NcFrlDqNfuGWtbVz/SA8WZfYC/Uh9uX6rRw+t5HtjZCkK1dnn6pVR5sjacYLUWxnv7+9c2de9NscPvhAZSB3QUYzheh3FRZpz/RbcSdw0nRdga8gTRecRDo0fL8LXRhDk1cZDUV5+NQMpbmZ+zH06Bm/sC8sknoOUktO1VP09V9yo/OONUTlZxm98C148dgXbulL3FY3BzpKH7KNZRL5XAM0mce9eyeUVLsY6JhZJmm3ZgFh643cKvAwHyUy4MAMFjhMAsic/yKNvi1QNFzyrEVBaA83uOjzV+MxPe7jnU0K4aBKrEfVHKcgdgp6FvRo1+QGQCl++W1ne9CrulaLiq1oBjdGHWv7913IZWdeboqRFnh2/LXlZ/lL+hAwjcetl8vHD+WG1g6q9BUYFuMHKotOtriqUVDP65cq4C0LcN7oEzEqK/JQjNjfZiky5Y9UHZ/L5q6qLKEnmMawI56I0luATdIHPBNDhbQUGxSsktLnfrFfhigaGJa8tP5V84PT3Oufy4bytYP1L+ChZSS1kiqUV607ET55w5S1JzoJksB2sSIovkGdAjcjJa2iTzzAIi7g/OHu7M0jUBeZ7zegztC88Bk
 lRB0SJA+
 ukh7j9edUXhSCd04PG15uNTTDa/apND4Lxd7ZPO53mdqg8Y6SkXaytfCG1lgjjh2eB244CZShC0bcQ42Q4SGsXXXJGsc8gAYq5nyLvPkmdprApzWvYOBw78APzfe4kL5Vh+91JIm4wg0D8yKdtBpq1+TpfY4Xpd7kZsBIBloIOBQKn79iwGVH8Zc11ZUciPlV+RKVAtCpmgiBCtfdoh6QBq7gBjuLqTEaLJeiX+hDFIZ6XaHywGAgLoRQffhWFw79PnYm8kMCdUqu4M/SVKRcyovOo6CsqLFqH8zDRxYdaWVHYl7RBb+Jl7PZmXr5j1NpD5EpuIi1zmEesyRm3DbG+LuPMn4YgD2A2d3W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 03 Aug 2026 04:31:20 -0700 Breno Leitao <leitao@debian.org> wrote:

> Add a tool that enables the vm.panic_on_unrecoverable_memory_failure
> sysctl, picks a kernel-owned PFN and writes its physical address to
> hard_offline_page.  Three page kinds are selectable with -k: rodata
> (default), slab or pgtable. In all cases the host should panic.
> 
> Example:
> 
>         # ./hwpoison-panic -k slab --yes-panic-my-kernel
>         injecting hwpoison at phys 0x100032000 (pfn 0x100032, kind=slab)
>         expecting kernel panic: 'Memory failure: <pfn>: unrecoverable page'
> 
> In dmesg, you will see:
> 
>         Memory failure: 0x100032: unhandlable page.
>         Memory failure: 0x100032: recovery action for reserved kernel page: Ignored
>         Kernel panic - not syncing: Memory failure: 0x100032: unrecoverable page
> 
> This lives in tools/mm rather than selftests/mm because every successful
> run crashes the machine, which is not something to run from CI.

I wonder if we can fix this.  Add a knob which tells the kernel not to
panic/oops/crash/etc.  Instead it sends a message "i tried to crash but
you told me not to" and proceeds.

Set that knob around your hwpoison-panic tool and voila, it's now a
selftest.

Wondering if we can sneakily use fault-injection to do this.  Add a new
i_should_crash_now() and use fault-injection to make this function
"fail", by returning zero.  Or something else.


