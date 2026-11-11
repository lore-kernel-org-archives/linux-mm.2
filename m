Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CC95606A326
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 17:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=qLwB8YuY
Received: by kanga.kvack.org (Postfix)
	id 5B3BA6B05B3; Wed, 11 Nov 2026 12:21:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 589E76B05B4; Wed, 11 Nov 2026 12:21:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C7FE6B05B5; Wed, 11 Nov 2026 12:21:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF5C6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 12:21:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C80E140383
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:21:38 +0000 (UTC)
X-FDA: 85423505076.18.E84054C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3E6CA40004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:21:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qLwB8YuY;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794417696;
	b=PaaH1EZgRATqWCst239vxFLYUcPYIPFxjZWLe1dUOlq8GjzEmXbmjFCFyRfeSr96Jh3EfX
	pFshbHx6yfWx1YHh8uTtPTfzSJkzKtAxqdGTDlin4hNLynLbKiG/QvF1ILON1gJRfb1pHE
	vcLGSPcy2/MQpsk5/pU6Q/l47ZmE22U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=qLwB8YuY;
	spf=pass (imf07.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794417696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgdmcspbD1Yyk+0ecRe5xCyE0njK/qpMy7OsZTOU9pA=;
	b=d3Ra8iRQv4mlMpfeaSNNqwc0CG4ilKXldzK7Jspl5BgyRzHOdOt4eyvVEELrVWSXXgZLR+
	njetJNtLHhdXb6t1mBQzv0k6n57w7q/2e4teBluO+XKSvmnt/r4+WE8eeNRf0o4lF0FOUa
	3wRtT7txdwxDDop3+irELpGl1v298e8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mgdmcspbD1Yyk+0ecRe5xCyE0njK/qpMy7OsZTOU9pA=; b=qLwB8YuYISU6n72YmjlDMvwfBh
	h/z/COi0TrAJz8Ram/slbP3UEwSHIcCZ8uXK1SR1hXnlQ6x5A9eyX2KBtH4XdJRJCVzXnuicCaDZT
	Lbwrc8CCcJNtU1OKoNR9KjLyvMrOWIoEguIcmwkA/kztGB+02Go8rO/5RypB0KH35550pYv9h+AOc
	HO5KaRA758zKA+w3CEWhLZSfxsIVzv9MMRumia6IGlyfFIwlEoxP7rKaMZmDozt5oBFV00MwjGR99
	txipC4M+XXzb5LfgID9YmDCPxfCRN8jMpXhNMdQqMJhvYa59+HJJqFSZPnGM7C9jVB2lIYSSynqx1
	pfpIyoig==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRC0p-00000007IAb-2pCY;
	Wed, 11 Nov 2026 17:21:31 +0000
Date: Wed, 11 Nov 2026 12:21:28 -0500
From: "Liam R. Howlett" <liam@infradead.org>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/mglru: fix a no-op lru_gen_clear_refs() call in
 lru_lazyfree()
Message-ID: <4xqyzrl4lbxwbky22lc5k5mcvusudg75z6hspjokfoghp3dny3@rjuukqzxiuyv>
References: <20261109021611.22247-1-hui.zhu@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109021611.22247-1-hui.zhu@linux.dev>
X-Stat-Signature: wuukk5ixfwocu51oq8zh51rg8mautq31
X-Rspamd-Queue-Id: 3E6CA40004
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794417696-795223
X-HE-Meta: U2FsdGVkX19eY57vdTPj6R5Q7PbpRlfbU3pqPnFkpqZ7mqBR2keVjVDz3ILXAvVYeSvFwtFWlUjO8kK328N8zM4gL/Pb9xUPw3Kp2we7mfRqlwEQbLIv4deWzhqZr3LbDNhAKpYa8UqfZU/o2YCqTuaM/xYAQFFSNaLHtewOf7F9ZJu5CFL+vjvwdFSS2adM8U+w8KrxkARpREvR0m5gUKYFlGW24NxK+8kfjCYWDtdaK7ujL8QsNoGmH7qlBoZvxfHc7ET8uKedgW6C/YO7BxcNcwcX8d6TZZZKTog4Q7C1LMgt8zT5ThMSc1LV7R5hPA5ofmIjWxfqia4oDAq8hNJ24GRNVJixYNgw25yYxmyzfuMyz2ypGWok5DY/1fjAIIaJbkcB/h+FValsWU1Cq6zlMYskFGvCixv5WfiDrK2pg1b69RkXUTEdGILxTGQBXbanC7N7WisOaUVWpb9uwqrBz2ZDe0Bwz9KoOT9HOjmVd777Mp0ktZ0zky2pvLrfJF8hxhJZKUyZqkwA0nc5QjyAMjqM/idN2vYYNGX9kaw7BT4VFmNWreH0s0fKMSGh9wds+4UbK8D7orFixD1jVKG/XAX2gVO3crIuue2TuhJ0XOq+FIkc4VrWjyG13EQ4KkKelPik7CZ84cyW/xseDJBDNJOEVVYQPiRMSwN3Pneb3z5fBGkWy/e0slKISheAOqDDG7KBiLwpNmuyjeBL0WizjEANgaklRkl9PVFAm1326oZuXXVLFAosFX4G/bwNiR0TECMB5OWa8tHm3u+ol0Tny/A+d5YP/g9OY4yBwySAgI7vjGQ3uW2b9CHtTieXz73mi3dYaesH1W1pdVMu9GD2Cz42r8Vb1QuRO+860oOr4zbhJWZcH6zTcOr8tCJu3q1z6abU4822iRiONAidHWsCztijSjELyvY4piqyoDvUB4/cydtkHoBz0Cn8bVgOJISoXt1EAnXbRQcTHe7
 tK1g2iea
 ctCzR4TtCgQuWZmGTR+iCBm0tRoKAElicQM53sduaj+Asgwel8fJ6m5iT+adlabUIw1VPQjrP/OL3J6sl6chcmYaVtcKIZVdg/3aOm1ApYnSHhGRsKgOwMGffn4fNxva5VRTSmAOkFDzgvB2eN0/mSdFGU+m4+gxsYvEg0hoTL3M6feN9EiDnm8bTtQLgBJFWlTnuAxXwBdVroHCBGa8H4oaVxNKMhjWgFkKiWOcHaONUC2qrgSCCxpNUq3hVMMiYwoI3mpEGNrn1iGnfXZzHhMpIkcUXMJmIH8a8+qm8/W76MA9rN7fN8MM68IxU52RXZMEWTjv8Xrryaas+gc3M6+yG5nfiOK2cmf+DzUkGFEmWMsUMCKPjL3s1PsCUuo/JbfauPkilZK/Uivp03XL7De5WxM5c4W/jpHpv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 26/11/09 10:16AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> lru_lazyfree() calls lru_gen_clear_refs() after lruvec_del_folio(), but
> lru_gen_del_folio() has already cleared LRU_GEN_MASK, so folio_lru_gen()
> returns -1 and lru_gen_clear_refs() exits at its "gen < 0" check without
> clearing the refs or PG_workingset.
> 
> A MADV_FREE folio therefore keeps the state it had before madvise(2),
> even though madvise_free_pte_range() has already cleared the accessed and
> dirty bits of its PTEs.  lru_gen_folio_seq() places it one generation
> younger, and PG_workingset puts it in the last tier, so sort_folio()
> promotes and protects it instead of evicting it and charges it to
> lrugen->protected[], which read_ctrl_pos() uses to balance anon against
> file reclaim.  __folio_inc_gen() clears the refs but not PG_workingset,
> so this repeats every time the folio reaches the oldest generation.  If
> the folio is redirtied first, ttu_anon_lazyfree_folio() keeps it and
> lru_gen_eviction() packs the stale state into the shadow entry, so a
> later refault is promoted to the youngest generation.
> 
> Call lru_gen_clear_refs() while the folio is still on the generation
> list, as deactivate_file_folio() and folio_deactivate() already do.  Its
> return value only says whether the folio is in the oldest generation,
> which lru_lazyfree() does not need because it re-adds the folio below.
> Keep folio_clear_referenced() unconditional: the classic LRU needs it,
> and it also covers the folios that lru_gen_clear_refs() skips.
> 
> Fixes: cc8ec7be78ff ("mm/mglru: optimize deactivation")
> Cc: stable@vger.kernel.org
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Reviewed-by: Barry Song <baohua@kernel.org>

One nit..

Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>

> ---
> Changelog:
> v3:
> Add Cc: stable@vger.kernel.org and pick up Barry's Reviewed-by.
> No code change compared to v2.
> Per the thread discussion, the __lru_gen_clear_refs() refactor will be
> sent as a separate cleanup after this fix lands.
> v2:
> Call lru_gen_clear_refs() before lruvec_del_folio() instead of
> open-coding the flag clears; drop the lru_gen_enabled() branch and
> the comment (Barry Song).
> 
>  mm/folio.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index 35e242b48870b..ea3adb6a89d75 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -597,12 +597,10 @@ static void lru_lazyfree(struct lruvec *lruvec, struct folio *folio)
>  	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
>  		return;
>  
> +	lru_gen_clear_refs(folio);

Since you're not checking the return here, you could use
folio_set_lru_refs(folio, 0);
folio_clear_workingset(folio);

>  	lruvec_del_folio(lruvec, folio);
>  	folio_clear_active(folio);
> -	if (lru_gen_enabled())
> -		lru_gen_clear_refs(folio);
> -	else
> -		folio_clear_referenced(folio);
> +	folio_clear_referenced(folio);
>  	/*
>  	 * Lazyfree folios are clean anonymous folios.  They have
>  	 * the swapbacked flag cleared, to distinguish them from normal
> -- 
> 2.43.0
> 

