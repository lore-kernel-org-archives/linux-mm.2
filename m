Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5ECEE606A339
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 13:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NhoVazCk
Received: by kanga.kvack.org (Postfix)
	id 717EB6B05B0; Wed, 28 Oct 2026 09:04:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8C16B05B1; Wed, 28 Oct 2026 09:04:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B83F6B05B2; Wed, 28 Oct 2026 09:04:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34D766B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:04:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE04B160C86
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:04:52 +0000 (UTC)
X-FDA: 85372054824.06.66BA5C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B73D920015
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:04:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhoVazCk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793192690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OG80Mz0mVm49EyuyKHOkJqtYHLMvKooWxYEt+ri6Okc=;
	b=hLw8x7IYsgIFCQFTJ7xkC6LZHjbFueGyDJspmjuLpd8ZIhtM5snzDGev5fKj5XTY2cLmDk
	ngF0ePwm5/kUl72+4+NEpa8H5CFM2bo9ZoLJhLHhFfgZfTxQGwm6DbZxJEmGMeS66jFJKD
	xophZjabp+6G0GxtdoPSBki9SMjqeKo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NhoVazCk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793192690;
	b=rjpsaGFq0lMYxuSKkx/y22LAD4hDVCO3rjjEL7Hu1jJNVLJF2N5eQBfKwZUbLpBgK75aIc
	jhXcSxAEM/Co9SctTJP/1e1Zj7bnFPX+0H3NBGeuoWqo8TEOcrKUWVVrrn2x/lwTLPHxwr
	N0Hn8O4DWlyO1vqDgq8vuGi1hg0ssSw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 163FD601FE;
	Wed, 28 Oct 2026 13:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9868B1F01828;
	Wed, 28 Oct 2026 13:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793192689;
	bh=OG80Mz0mVm49EyuyKHOkJqtYHLMvKooWxYEt+ri6Okc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NhoVazCkHOBZd/Zh8WtWlntaIO9ino1lTyefSK8Dzb4X7rZBNS7fhkNVtdGcP7Vdb
	 cGNbg6lFcEZvFjT9yMlCTwP0SqOF9qq5NhXW5cvhPl0xIwEr/6L1LkNZ/uQXf4aKoi
	 clPXr9aGTTc3EyDb+CotvlY11YlESdSO1VdrbdyIfTAyysBgktMbUkrEUpSh9IMlcM
	 ftZdaz6ql75fiVG+RctbuKjhXW5zisfa9P6A7RWIlUDFmg1y4qEYh9gGrGcv24aiMY
	 RQJ+Uor7BCdHWg/Ja0NxSTpMLPcpXq6FVL+09fkmcCDKK41pgGMTScRqAMVA7WiXTd
	 C1UvOifI78Avg==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id 72805198003A;
	Wed, 28 Oct 2026 09:04:41 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 28 Oct 2026 09:04:46 -0400
X-ME-Sender: <xms:6PLhamR2N2SYNNuW2COGtT0iyhIuZN4Ab6M11IdWYpzZuKhsU46euQ>
    <xme:6PLhasO4PXs2DpvcsOJdlR4DUwcFplQftBYqhk86Injx7DrJH78rj0Flf6xhD1ZCG
    9pRgr7WmxxhEKvC9jS3FNwkDCbgMXER2Q_-Oi7X5VYg422dDXLURdp2>
X-ME-Received: <xmr:6PLhalRzbQegRW9_6wGQEi1w56Rek9Y-7oRBd7AXEqBOGSgslElXkkEZ0hw>
X-ME-Proxy-Cause: dmFkZTFg4m4oPEAUf0wKUWw/Iv3SvfDuV2dwoufosxi56rG8rE3yzXkDOL9mHtdMD5t3xb
    TNtQvdWPVpliQZzMEq2j9Gt/Qeqa/rF77vTyxnTf5UOLPNJ2zUCh17VsnOcEYbxGgk6pd/
    jnrFGdaKttqtWNKjNbixKC92UE8SCbRpRx0WxGiIqSl0J0ICk0JQhy9Sr/LMCk3/IVcW/o
    bCjLH09OVr/VQlaboh+GTF0eV9P0WsRQ0NN8dvTtbJ5CULwJ3YspX58BzjPnKc4esZY0AE
    vCO/2EXsD9kJV70LTbLoWjGuNnwDImFpXgd/qrFbj8lz7uaYEYKynkoZbbntZlYoJ2cVe9
    /+rhqV/xdrC6ND9aiGvuSZn+fk+lMFKBk+CwBAGjoY66y4uTs5oqVkdwtiVpN3jnfufyiw
    mbFGB54MLhrD1QUgxn90nVffgd8oQRT4PZ2d0Cv8SF1Gpgx6GZU5qUwdlixKbbdcCnstPy
    C4OiiGs/7AHNy17plPHaquUuUuXG0T7RKsstw38S2VOjByMTyHT12LhV9xiy9nSaBbtkzo
    eBHrVxgrtsC+JoLewb5t0X58mNTZctuMyI/X+JJS417uckswZSke7odEKVKiXLKSFCGJgN
    lxiRKVDKgquvVnW9gYMK5Q2ompqZeG5/mSl+cviBwf32c/V8SUzaJThtISOA
X-ME-Proxy: <xmx:6PLhaiC6UtU4qiOKsaD5z32WpUxwn9JqWMWZSp2POMwzX3Gff5sviw>
    <xmx:6PLhau5rgYZr77ak_O9wBERlqC7gG-5MjSAFZcS46YIGK_q8Pomf4g>
    <xmx:6PLhanADBjgOZwiVxGQ_V1IaXvAzSFbWN577V2Cq37A223MQNBj2kg>
    <xmx:6PLhaicpZIf6CfrEn_5aKXq1MPBLbhnnSSAvw380Z41uC6bjcbw0yw>
    <xmx:6fLhaquilv7jS-EmMG921CB-BsfpaPFMfHQ-RZ4zKq83ZgdvbLzPWKgp>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Oct 2026 09:04:39 -0400 (EDT)
Date: Wed, 28 Oct 2026 13:04:38 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-riscv@lists.infradead.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
Message-ID: <auHxpuEHrpkvSFFi@thinkstation>
References: <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
 <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
 <4A32F5E6-977D-4720-8723-B19AFBC08FCF@linux.dev>
 <auDkbDlgSZxqlk2G@thinkstation>
 <7cb3dd91-f518-49b6-b311-9ec807b3c63b@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cb3dd91-f518-49b6-b311-9ec807b3c63b@linux.dev>
X-Rspamd-Queue-Id: B73D920015
X-Stat-Signature: wm7jy11o99nrrxf8o45ti4of9wtaw948
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793192690-370203
X-HE-Meta: U2FsdGVkX19Cy01GiCqHbcrmT9Llw5UPBj5L3em1l5kpPWFkufc+ZwHD7R3w4HlEn8zguctphZ89k6mROGRnr6KwxDVCJBC43ZtcA8J5mnEYby3t4U0h7nbeE47hilUoRMfbuHZvokStAiCwEUGw14d4AbkERJKu6K3I9NUUKboSaNV+w7awv/LyCoVipB3Hcsg9txyCzXqKJ5onCAiKJAkBNCNKJljuICdmsMpzTq+pdfKIAtB//1UyqiYabpuY9AAWvR91sf940HeAGffecBCNpCUyz+tgPica72saSLQgLik8vz6iYuvRg9TwAs48k9nIyM7meo0uPhoJrVCbbZOF2OHgJo+8AlSlATc6T0R4HC4pt8tXh1iGRtnfa8/Fy1TfoV7iRh7Kr17bYEObij/wE97ZlfjjEboTDjds3EHD5PGhobbExAl/dgJEMl+4ZLnjveCha+p5jlUkD7eS8PjfoXs30izwnS0CblCttYRIAlEW+uI5kjAKSZKamKgNAq7iAXqs4Z11DAudQ2M8bes3w14Ey2xrcF1F/sQxx/afNvHaw1nDQw1IYU9JrE+tKr/rJ1+4PSHdSVuk6MAUlDy3b8Vw+Ea0PusNKB49u2m9NAcsG/NtR3cxN9GVF7FBWQebDhoV60GBUfKiL/U4nWBduwoQnvs8jXBagaVChUF/XduZEac9j9fdylGDr0fuJUQykcUKBaK0fXNx9EJ0pZFYQDOnXyNqA+EJ64LrfyygUHG06e4ZjJ/u+IyoClMeZgVaZ8N84/Ov1osMlBHW2fXsb5jiGt4e1xoB/E4ObaOk2JjmPPAxa5Lhqb2OrZREWt5FU8bbuL5GaKZSoh+gh9wpsu8zGXmema1pTJuD9Qj6F93OBOhGQ5PTinrtZxxguXB0G/d2AVhH8FgC8h2tM6GiDpoMmKXhbV1BzdLQhyVvj+2YnJp71z/IcXnIvbgkNRnDg8AOEvKu7oRq9zh
 fGQQNaN+
 LQWD4cXmxFK5B0MLjytNwC8FZ724qZNojuMIeayGAYlcX+N+UJ9NXOfPZU9AGy+8zE8XZBj+cFmBWLONXNM32h820fJ+ylG5tP2Ox/n1MrGpTYBDNScnSDDYAN8SY0hVTy1XfX/y940GAywCCT9LCUzgcYFChxQDDq+VOzhFjLhvRiRi4VKI44eZtcsjzmyonZ2tGX6ut2u/2tTQx/ENH5+xy7tUarSZN0RvAsL0coBXLQ5KGpsnFu4j9ZDWuhwjinFf5jwIzfnT+lHm2Tn6UMJWWuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:38:22AM +0800, Muchun Song wrote:
> > Bootmem folios optimized in early boot get their tails mapped writable
> > and write protected later.  Drop the write protect step.
> 
> For bootmem folios, I don't think the RO mapping should be removed,
> because we are in the initialization stage of struct page.
> No one should touch those pages at this point; otherwise, they could
> encounter uninitialized struct page as well. This assumes no race
> exists during early boot.
> 
> Since such a problem does not exist during the boot stage, why should
> we give up the protection that RO provides?

Agreed. Nothing does a lockless get on bootmem folios before hugetlb
takes them, so they can stay RO.

I will keep the pre-HVO write-protect and post the patch.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

