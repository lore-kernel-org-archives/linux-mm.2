Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 252E5606A31B
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BtG9PuG7
Received: by kanga.kvack.org (Postfix)
	id 465DE6B06D1; Wed, 21 Oct 2026 07:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43DA16B06F4; Wed, 21 Oct 2026 07:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A416B06F6; Wed, 21 Oct 2026 07:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 056F56B06D1
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:51:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2EACA049C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:51:46 +0000 (UTC)
X-FDA: 85346469012.20.BB1C14D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 29EA640002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:51:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtG9PuG7;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNGxMQXJMdTjnSOv10aQKb/ppFNgCMDdDlSf+doGbnI=;
	b=ZbUrPwUVYlY8xfUvHff7GLKcc+uSvXsq1hBAcvnmSXNsxDBPc3jVsGsftEeAF+8f290vpW
	tqDdftSkmLg2SkrL5bTNINNqUk74nukqubAMaHyldb7VgGzOlAWEwdtffTsQZZkYmoZwnh
	pO38iPyRn37qgjD9B8A5+8NzyCB1gaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583505;
	b=pFyvWxXyoRbLVyt4Q5Dvu3B7Ua2vcptGVwoqNtaJUqfBxnD6WNEP65xFJloHgdBYmNRVoO
	SaCl83KBYXVmDFMB3tZSWzzCb8eJ1/Df6GycGooKRI1kjLlkNgISIADUj/1/WML3Ee4oGI
	CDMZWa8234jpKZZ2yEuTUNFlw8FsA+I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtG9PuG7;
	spf=pass (imf27.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABC95601F0;
	Wed, 21 Oct 2026 11:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4751F000C4;
	Wed, 21 Oct 2026 11:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583504;
	bh=NNGxMQXJMdTjnSOv10aQKb/ppFNgCMDdDlSf+doGbnI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=BtG9PuG7VaGKIXkWXibhz2PCSsATBTBkEm2LrSY2Y343uHvevVYcopKMX5TehF69x
	 x1xCzOfknTAYZAaYrATXygE/jy9CLTHP2IU1xfb9pkcnd7ZXLCRQahK5ET4qBm684J
	 WNCbZVP4Ty/LLwMRjTebM0RlduZLs9vqiLLZ7NNFL0DELf1YWuzS28cx2e4lU2AVkY
	 WDRfwlh19vCdfj4IRHdbOKIgl+wEwVs5RnA6uuZWx6z1Wfhs0DoAmOPStXvqLwmECW
	 /WVwqgT+LciSEOJ941TtrzHyGviNvJ/fyPoyvFc9aTJeWGk2pr1VqLsNx7t125xZF7
	 uLBx1KbTSJYOQ==
Content-Type: multipart/mixed; boundary="===============7595896769208109114=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <13ad2d54c140d070976519eba79bb098d6c2d95b64bd8c51640b45c9972baea2@mail.kernel.org>
In-Reply-To: <20261021112437.1799213-2-zhen.ni@easystack.cn>
References: <20261021112437.1799213-2-zhen.ni@easystack.cn>
Subject: Re: [PATCH v3 1/7] mm/page_owner: extract page_owner_next_eligible() from read loop
From: bot+bpf-ci@kernel.org
To: zhen.ni@easystack.cn,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,ihor.solodrai@linux.dev,akpm@linux-foundation.org,vbabka@kernel.org,surenb@google.com,mhocko@suse.com,brendan.jackman@linux.dev,hannes@cmpxchg.org,ziy@nvidia.com,shuah@kernel.org
Cc: bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org,linux-kernel@vger.kernel.org,zhen.ni@easystack.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 21 Oct 2026 11:51:43 +0000 (UTC)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 29EA640002
X-Stat-Signature: 9wr86w9dddnjzz1ng3pztj5gid7e7fkq
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792583505-848554
X-HE-Meta: U2FsdGVkX1/qDZOsYHIWKO2P9gZVZMAq+LbnR0eMB1H1ofgs/ee12GPyVH0+V/pvuL4a597qoP6zBwHB+93tnLSQvct4tIWPnQP66gcBgURqgzV2lJW3kzgksF8d3d3yQR3FrNHx2sQiImxsjde8h2jIDuzwYavj3ZeTb5HhLh3p6zS27QkrZ2Ol4U/u2A3DIhFUNn0HjSZG5PV09g1e2DhCrC1rShGZ/EGn9cmsyZMHglDatKBYBpEuhJs/fBfbnJ1hwFVTaYPEin+S9Bpfwb7PdU1p8QAAUnFyTY3sxUMJ0BKwbnJnymbEtnoZCSYr9GEP/ogq67+mVE1Oba7ZIorx801adlXYNph0C+dynZLr01WkGHQJNNhWiJoN8hY2p/FG9apA1oXdphYaSn4eLK63auYhCtYSdHR0RtIODS1WfZxxl2SBj6cBTHYmz+bIPrcad39ZOilf47FNsnbukDnK22SczgI59+0LjTpsRWFxT5DZEBH2CpULBDYrMac6+kRQoROplVyjVTKDrKaXhT6M8qOjuj5quq+fSoHizUzmYOqGfDs4Ko2JTeCSFl4A3j+wYFshGjyslDql5oP1/uWhjfm4zxBdInrWzUfcUPyQYLHiwHAR8+q67WiIl3bX+GUAaMVOlnsRAqLWOHtruGqat4bJkCLlL9yisYBphTKG0CSJMv/Qj+9tH5xYpuD3CyaTZxyJSyLExN7lgkHKyTJdk9GQVR/Fb5NhmtN1D/jnrDWpINt5WsWq33ViOKXZIic6JH+6pXcuWdTypEXZ1tF/c7ULw1PIYTRGJatoPeL2keGDNZoTD0fM/9Tquw1dTpF7DX7fXU2N3Hq5ItmwmLuofMNp4BczHi/Lwnp6u8LzYBW5HFpc/3Zejad+V7otyjPyfdaQwliqrJCeP+u6ni1H6FIP6/lKItgJRTJs2ifxjD7hrXNltoX5DVMpxQ1nyGyL9JS+1TRjmQf/zuH
 i6jir7nV
 yn9KIKJCPHJSk7GgH9xcNz4UY6cZHqMeQFLAFgdHUHosRVLhnre0WeELu+7ERNg+Xb8y1dwaBR0cmg3tgsli2nc1/tXbSefFFD7fTvOlg7yT1MawkMHLnz8LuEoN6ZkWABGe4QL6EbCn1C/nboxs2vjCbjiY6l7UvR9MergIUBxmqJYeswHqWLJkgGlwCnCrsYGyBg4/GbtB2OcX0fYKy55Tf66wn8ZFm6/WWf7nMpZHnWn9eR/MfVLQBeNltP78Y6GctcbZAamtaiNyA0gHPdvbSgu2OuXLmJf93OCZjI3VC6u4bokKOkdScM1sBVe20cJUmbRzPKwihzyGyQORHHhtYlrCX+BXA2Td7NoP0Iy8r6DDo4RWiOhb1X+6FjTe2ax291OcgPV7yygoiSGtWjFQkKsJGIcjJndRyv6iMCMAiWe3fXfoI7Z12Qtz32ZQVBTVwvvOdL2I1h/CtP/ZcE0czaHUBZBRDUEeuh6p7LP49hsZ3OPPXh0tTbCCptnIx61QWPZVvRl7lfS+es2wg41CWNWX03+bxuper
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7595896769208109114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> mm/page_owner: extract page_owner_next_eligible() from read loop

TL;DR: The nid filter's page->flags read now happens outside the page_ext RCU
window, so it may fault on an unmapped vmemmap during memory hot-remove; later
patches fix it, so it is only a bisect window.

> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index fbbda7ba914b..92a92cdf74ec 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c

[ ... ]

> @@ -798,13 +794,45 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
>  			goto ext_put_continue;
>
> -		/*
> -		 * Access to page_ext->handle isn't synchronous so we should
> -		 * be careful to access it.
> +		/*
> +		 * Take a snapshot of the page_owner record inside the RCU
> +		 * window, then validate it, so that print_page_owner()
> +		 * reads the checked handle from the same snapshot.
>  		 */
> -		handle = READ_ONCE(page_owner->handle);
> -		if (!handle)
> +		scan->pfn = pfn;
> +		scan->po_snap = *page_owner;
> +
> +		if (!scan->po_snap.handle)
>  			goto ext_put_continue;
>
> +		page_ext_put(page_ext);
> +		return true;
> +
> +ext_put_continue:
> +		page_ext_put(page_ext);
> +		cond_resched();
> +	}
> +
> +	return false;
> +}

[ ... ]

> +	/* Find an allocated page */
> +	while (page_owner_next_eligible(&scan)) {
> +		struct page *page = pfn_to_page(scan.pfn);
> +
>  		if (state->nid_filter_enabled) {
>  			int nid;
>  			memdesc_flags_t page_flags = READ_ONCE(page->flags);

Can this READ_ONCE(page->flags) fault on an unmapped vmemmap?

In the parent commit the nid check ran between page_ext_get() and
page_ext_put(), so it was inside rcu_read_lock():

    page_ext = page_ext_get(page);   /* rcu_read_lock() */
    ...
    if (state->nid_filter_enabled) {
        memdesc_flags_t page_flags = READ_ONCE(page->flags);
        ...
            goto ext_put_continue;
    }
    ...
    ext_put_continue:
        page_ext_put(page_ext);      /* rcu_read_unlock() */

Now page_owner_next_eligible() calls page_ext_put() before it returns true,
and read_page_owner() reads page->flags with no RCU section, no
get_online_mems(), and no page reference held.

The RCU section mattered for memory hot-remove:

    offline_pages()
      memory_notify(MEM_OFFLINE)
        page_ext_callback()
          offline_page_ext()
            synchronize_rcu()

try_remove_memory() requires the blocks to be offline before
arch_remove_memory() -> ... -> section_deactivate() ->
depopulate_section_memmap() unmaps the vmemmap.  While a page_ext_get()
reader was active, that section's memmap could not be torn down.

After this patch, an offline plus remove can complete between page_ext_put()
and the READ_ONCE(page->flags), because synchronize_rcu() no longer waits
for this reader.  This needs CONFIG_PAGE_OWNER with page_owner=on,
CONFIG_MEMORY_HOTREMOVE, a nid filter set through page_owner_write(), and a
concurrent hot-remove of movable memory.

The commit message says "No change to the output is intended", but it does
not mention that the nid filter's struct page access moves out of the page_ext
RCU window.

For context, the parent already read struct page without a pin in
skip_buddy_pages() (PageBuddy() before page_ext_get()) and in
print_page_owner() (page->flags, pageblock flags and page->memcg_data after
page_ext_put()), so this widens an existing race rather than adding a new
class of problem.  It does turn one protected access into an unprotected
one, though.

This is fixed later in the series, so it is only a bisect window issue:

- 915f86c7862f ("mm/page_owner: protect page access with mem-hotplug read
  lock") re-resolves the page in read_page_owner() with pfn_to_online_page()
  under get_online_mems() before the nid check.

- 2cf991a93cbd ("mm/page_owner: record the NUMA node in the scan cursor")
  moves the nid computation back into page_owner_next_eligible(), "to avoid
  dereferencing a possibly-unmapped page".

Could the nid be read in page_owner_next_eligible() before page_ext_put(),
for example by storing it in the cursor?  Alternatively, could the
mem-hotplug protection patch be reordered ahead of this one?

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39593164040
--===============7595896769208109114==--

