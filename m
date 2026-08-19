Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 416F0C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:31:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DA16B008A; Wed, 19 Aug 2026 10:31:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2079A6B008C; Wed, 19 Aug 2026 10:31:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CF676B0092; Wed, 19 Aug 2026 10:31:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D643C6B008A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:31:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6786DA021F
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:31:51 +0000 (UTC)
X-FDA: 85118258022.01.9B523A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6EF131A0011
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:31:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSP5n2xW;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787149909;
	b=zZi482xCxaT5JQRN70PBO39OVBIY9zuLl+edYYB92emGcti5ySiTOMej320v2xNONw9bJ3
	GM0dz15XOQDYmoPqlVeUp4APXD0jg+B+rHgbMLZZ1O6bkTMTVVVes2/XYt0hogD40bgNq+
	y4yorz00EYSC4PtHt/zs3OG1OLBOuHE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSP5n2xW;
	spf=pass (imf19.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787149909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9hL2zPKdPgs0tnH+5d/gk+ueKMxp9P+vcuepzTiVwA=;
	b=wy45yZUnsb3/KTwuU5iy5bwWuo7MQVTk6crbeLyxyloug/MUHGyXWU+6muPpRqW0XFVIko
	pqQtL1WzhOMGkQCj/y2TT3Wva5rscQKyRP+EXVwroEzArcfJssmMAeR+BwSk2XDCO4zqJ2
	meHF/NCpqtdiAVZDov4CGDKy5OrEwrk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAA9C60AAA;
	Wed, 19 Aug 2026 14:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B5E1F00A3E;
	Wed, 19 Aug 2026 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787149908;
	bh=o9hL2zPKdPgs0tnH+5d/gk+ueKMxp9P+vcuepzTiVwA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hSP5n2xWxVocs+JOnjL7+TVh4fWHw+ON9XGYiY95OdunuzN5Xew1X+o+WeiwBMaeX
	 Cfae7yrOqIREMT8+3VTLBk+6XtFMaJbupCZIpsZKMMADmBvxmwfnP1NOgJxetnynHl
	 kNxHAmDOtJ62NtmBulrhIE7+o75v5vE27C9QgsV66y+4CPAC3wFP5sBJYl1UPoN9Fs
	 FgV4+3GaPbT6B5pmdZjTpp8oFqxDvEIsW75IgrkdoRaEwCI1eTynzVITAzeTommc22
	 QkkMXBlE/GjXepaS7rReSyyaaXWr1r6odQOtPzdpcJQ5VnAcyhbs8+pzHONCMDWaPr
	 NozeBn9BDdjiw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 851771980050;
	Wed, 19 Aug 2026 10:31:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Wed, 19 Aug 2026 10:31:46 -0400
X-ME-Sender: <xms:Tb6Faok3i-dm0H9rS3jUX0pvk9UpAelOaKToC4HOs9R-BtSwEjbRAA>
    <xme:Tb6Fas6JeZeTtHLs_JZqQ7Aaf-gSXkVXXP3CG9TvUb7cObGFUhjS_5uVF6DxfGGMp
    NG_ngo1k7rXzcUO7SX9OjmUuAY861Y9bmtu2FNE9lyZoLkVesCdTA>
X-ME-Received: <xmr:Tb6FajoGnUk1mdca6i9OLwpTyrHyQa9_7mTQqMQPLYZWveVvQ3p9cIA15RQ>
X-ME-Proxy-Cause: dmFkZTF42tJSbts6mf9F9oXTzfvss1tjtzDvWnFg8m061QZeTeF6vhFaQtDHjL2/3ftFnB
    aFPcb4p6MUdN9+3pb/2vojcWzemgyDQMIo0qqiBYTAENbnrXMi9Aot+OJ732H+/iOj4TkQ
    UW6KOX/5Nsng3IBn01i8dwcK1UIQbngydn8TCkAboN6DwoIpZieNOVoKs7klySzQYvfmy/
    CMNONe8gzzXK43jqFi8fypPcac9ti5PY7WBwwuIDD2R2A71esJbhvYZarcBkdAfthU2FHB
    IMDubUYkgARIYkMwk7hg4B+eywnxtAvE8QvciQ8Cb3tA61BE3eG+n+iuR5yFdyKKXuvOf2
    MUWP/gOzPpLyyJgH7J4k0hNNF5D1FLsfoxY1HA2dnEGlYWZnfD13tUkrL+d8SDmO6yWbmL
    Ihw3ACASJwTCqR+0xnPnByDptuOYfA2xwvoqlTkTUnx1cfLlOiuhLPErhrACzRlGtwP3tV
    ZEruxLZdn5cuBwphmxbOpTdGoELe6maSK8G3791ODUBQ66kSHieDPDWDNuzM015LiGlf40
    JVxZlacB/ThSuAi7JWj07OYQonYJOa5jJs/KgKdk5gNlZRRtdWpEADS2TuoMjO7vq817kb
    apfDs73DhCFvKWVdbneCaAvkzoPQSS9Vr0fXTackII+vnHFl28eXhupToV0g
X-ME-Proxy: <xmx:Tb6FaiRkGuqUee6HTPf8rrhL7Iy2hqoiH2zbWXY_Zt6W-pbS62a2Fg>
    <xmx:Tr6FaoWS9afcEduZQM4WavzqMSykfvLVu7uSi135f01UPIMOt1IuZA>
    <xmx:Tr6FahDvq-GC9zKAavZwR1cuCEYJJO1ZDaPVhCGKzcMBPmdCjAqmnQ>
    <xmx:Tr6Fans-9q00rNpr9Hh_tvdSnfNSC6scLBUwNNAroJps6CKERhzcKw>
    <xmx:Tr6FakrIA3RMIT7DTz4DYCAUxXHTebrJMM5bfyc-3yFgCAYdJKuv8m-g>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 19 Aug 2026 10:31:41 -0400 (EDT)
Date: Wed, 19 Aug 2026 15:31:40 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>, Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, lance.yang@linux.dev, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	nico.pache@linux.dev, ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <aoWw_iKEDLjKL2jr@thinkstation>
References: <20260819101222.3732660-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260819101222.3732660-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6EF131A0011
X-Stat-Signature: n34mbuw18we7nn6c1e4fn5cnkas1wmao
X-HE-Tag: 1787149909-97806
X-HE-Meta: U2FsdGVkX1+R978jukLWytjaF+LeH/y/SkKzntXu4duFO7o4UXeHQ0H3ovN5L5m/AXiVaJTBmdVZRBsKmPVFVggOen0Y+MuvjOepP7WY1TNQded9isqe0lNnNru4+tR4eZHsTEAd4koBWZSlU7a7z+1khpG6ekM+7qula30s3gUgxkWBa10jmfx4f270/oFXjsPNLnniZyH3+5/UNijokVQtM1g7OuQv+YO8vlP7QXDTxCf73EbYSrrqNuK5a1P1M6r3prOdO/1saYyboTY4Jlk8/tafcWjFTlEWysHG45hqyV9AWlPdU7yvmGwWDIaloWlUdZJJ6M3zPWUmmpD0Q1Mlv1hZNTXDrFD3gU/TJd3Chvx7J0E/kNGB/rOmKRZa4mrCGbdsWYXtwOUTkGT4EnX+ATBdMZbWwd6SDwF5ScqDW1cd9eCUgPzylRRHbHFHjOmYePlj4YHxHL2HYgwQdbnzTAfPfGNZiA65Im/ugbpujUweSJNrhhSLk6pCuLlOS3WrzS3jF4IY1wj41qPcaw9ee0NLaEZlcbHoEOi8p+JdNbCyEHg/jQ96Ug5Ohk65DowRk7NketeoankHzLbzGHnMADpMdjz1uvEuxN4Tz47hfvJQdBEKTkTwjTmu2ANs2Cyts4hm/0X/TEt3yIn7836jZMjFuO/ZinKG3iLAlCHGgttLHXierwa+gaSnbYJ+iYcbsMOX+L91f8LhFbA+Un5zv0ljJvIZK/mRcXezW7/rjqJFBMcdRPPNt4gXj6A+VDH5h3oshG21jVgHT+Enwq94u91b5NK0nKAzZsG54SPlRpcC0L/l48bSezeC8c5wgAMnnPZBR84X1ySJNSwiV7s4GCMEeAgQl/AAFACRrDMa4dCE8BOFr6lZJatznadA2NPuH6IOnaopKrthayBeaJJbp+qiStNswK6OwO2MQ/THfUDtuoj5c9LkcuWqF9c+OcQdPnziPoI0YE9M0Uv
 C+iJvhMa
 4vymtZwWxa693WFEAlq1QcdjndaM5JQOZhzpxVzNFZDwPLq3REHtKyIoRpCnSi6jKHq4YC9vtQtPeMSAHfVaZfs7rxY8R07g63+Fiaf5sHv2X/Bgb5HZ/NWtKjs5BKdhGohSlHZXwDkz8/5kaNoDtzG93KJZEy5LD6Q5hKV11cLRd/PPsHRQZFeGAbTefdlnd/ixLjiwcICfJ9V1819gkP+HTwy5F8Lb94cdOXi7FzYSIh4s2Nd6UfTPIiJFeteFIZ+cf6oXmpfN/wTnVLKdlglk+7ycTkRMfiagr1wqF0PxdYvUu81k2aKpBLhO2rzNf0W8xyHnaUxFvzul5VSw145TukJvoUhUx9Rnv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
> zap_huge_pmd_folio() propagates the pmd young bit to the folio for the
> file case, but not the dirty bit.  The pte path does propagate it, in
> zap_present_folio_ptes() and so does the pmd split path, in
> __split_huge_pmd_locked().
> 
> For most file mappings the omission is harmless, because writing to a
> shared file mapping goes through page_mkwrite(), which dirties the
> folio.  tmpfs is different: it has no page_mkwrite(), and
> vma_wants_writenotify() is false for it, so a *read* fault on a
> MAP_SHARED tmpfs mapping installs a writable pmd via do_read_fault().
> do_read_fault() does not call fault_dirty_shared_page(), so subsequent
> stores through that mapping set only the hardware dirty bit in the pmd
> and never call folio_mark_dirty().
>
> A shmem folio allocated by a fault
> is marked uptodate but not dirty (see the clear: block in
> shmem_get_folio_gfp()), so PG_dirty is never set at all.
> 
> Unmapping such a folio - munmap(), or exit_mmap() when the process dies
> - then loses the only record that it was written, because zap_huge_pmd()
> drops the pmd without transferring the dirty bit.  Reclaim afterwards
> sees a clean shmem folio: the whole swap-out block in
> shrink_folio_list() is inside "if (folio_test_dirty(folio))", so
> pageout() is skipped and the folio falls into __remove_mapping().
> There, folio_is_file_lru() is false for a swapbacked folio, so no shadow
> entry is created and __filemap_remove_folio(folio, NULL) simply empties
> the i_pages slot.  The data is freed without ever being written to swap,
> and the next fault on that index returns a freshly zeroed folio.
> 
> This is silent data loss for any process that keeps state in a
> MAP_SHARED tmpfs segment across an unmap - for example a cache handed
> from one process generation to the next through /dev/shm.  It requires
> the folio to be PMD-mapped, so it only shows up once shmem THP is
> enabled (which is what we did in Meta fleet and started noticing crashes);
> with THP off the pte path transfers the dirty bit correctly.
> It also only becomes visible when swap is enabled, because with no swap
> device shmem folios (which are on the anon LRU) are not scanned by
> reclaim at all, so the clean folio is never dropped.
> 
> Reproduced on x86_64 with a tmpfs mounted huge=within_size: read-fault a
> 2MB-backed region, write a known pattern through the resulting mapping,
> munmap, force reclaim of the cgroup, then re-map and read back.  Without
> this patch the region reads back as zeros and vmstat shows zswpout 0 -
> the data was discarded rather than swapped.  With this patch the region
> reads back correctly and the pages are swapped out as expected.  With
> huge=never, or when the first touch is a write, the test passes either
> way.

+Hugh.

Oopsie.

I'm confused why it took a decade to discover the bug...
Maybe read ahead of write for shmem is too rare, I donno.

> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")

This would be more precise: b5072380eb61 ("thp: support file pages in zap_huge_pmd()")

Reviewed-by: Kiryl Shutsemau <kas@kernel.org>

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43a..afbb5974bd225 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>  		add_mm_counter(mm, mm_counter_file(folio),
>  			       -HPAGE_PMD_NR);
>  
> +		if (is_present && pmd_dirty(pmdval))
> +			folio_mark_dirty(folio);

Unrelated to your patch, but noticed while looking at it: we drop the rmap
here under the pmd lock, while the TLB flush is deferred to
tlb_finish_mmu(). The pte path handles this with
tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.

Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and
do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
folio_mkclean() can clean the folio while another CPU still stores through a
stale TLB entry -- silently lost write, no PG_dirty left behind.

I think we need to fix this too.

Wanna give it a try?

>  		if (is_present && pmd_young(pmdval) &&
>  		    likely(vma_has_recency(vma)))
>  			folio_mark_accessed(folio);
> -- 
> 2.53.0-Meta
> 

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

