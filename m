Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 073D5CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 20:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF476B0005; Wed, 13 May 2026 16:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B00E6B0088; Wed, 13 May 2026 16:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09F076B008A; Wed, 13 May 2026 16:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBEA76B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 16:10:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8A10C1A0432
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:10:40 +0000 (UTC)
X-FDA: 84763489440.12.22BF7CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B1C21C0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:10:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sGkHuXDR;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778703038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZ57PgLixEYP+0lkyGE5a44oOptR/fse5Rzm4sfoUbE=;
	b=qY5uOUnOCZJs+vsBqYdF8HXx5jkt3rG6N+DxOfWC8iU9bnGd6NrIUUJRbD8H+MjAEo6Jhs
	jBrnqElaSOGasBAnudS0+ZzZAwY488Ax7vaiL8iXFNtFURzhADI5zCELyGZ9IpBuNK/Se0
	WxTISF79joVZnhdV2yyUg/x5xzS4Td8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sGkHuXDR;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778703038; a=rsa-sha256;
	cv=none;
	b=Z0XmvDyEeV2EUAJagEWs3OK/uERowK6ILpmUFmfT5jiZt1lVIZwKyixmYM1J8u27C412ew
	f/IVpEXgYYdkc09L8ELiUsiLPi1YFrZeQB0R1gbi+RsxMs1JNpI7KXLxtRQH3gQLjdhGpm
	KLo1Fpr0N7yMBQLCYkCN/aGRPT+2N8U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ACCE544306;
	Wed, 13 May 2026 20:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D228FC2BCB7;
	Wed, 13 May 2026 20:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778703037;
	bh=Ev9k3KiPdRHS9B+BjW0upluVxxYhTSv2oMebgkf2ShA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sGkHuXDRaCCU0nxxAGDBnblzSQhRReUx8USwaVA4cvDWXfAWRJpj0D8zQ7E51S0FJ
	 e6g8K2kvYVF5vIGWc+rZN2qdyA/Rd+zRQwumJWggxdG7DyPFiF5hArQdO+2mn8/jEV
	 sto0NYy8btd7x9JTg1K3aon0WvP431UqSg4CG8zlzefdF25D6wx0rYcyLvqBohNReD
	 vwzEaWe2IITv4KV/YxDWpkPDlj9SLQLYFnNsw8Db3Evl7pmEWPVvwFlspehx4+84hJ
	 olL/EQFbF3OPJdclgiGsF2k4/KRiFdBeNYL6cZ+Zz/fAgY+Q5d1eW6bgqP3ODAN0rY
	 7LULys9D6hHng==
Message-ID: <5712adbc-b2fd-49fd-9827-cace47eff9ad@kernel.org>
Date: Wed, 13 May 2026 22:10:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] mm/memory-failure: drop dead error_states[] entry
 for reserved pages
To: Breno Leitao <leitao@debian.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260513-ecc_panic-v7-0-be2e578e61da@debian.org>
 <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260513-ecc_panic-v7-1-be2e578e61da@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ob6errkcd7q9pxikwdu1eq6mc8wnu57z
X-Rspamd-Queue-Id: 9B1C21C0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778703038-784525
X-HE-Meta: U2FsdGVkX19BeTjrwOoQyPMY6xrRfNHYC0u5DO0/UplyYWUAtcNaGDt3BJf0EjfUVrGEvaoq90/GvjhHI9y+OCsRLf9cB6BVUFyXTqup0WIxI7STIVttlqXKJnukfa1ptCp58F9HDMSbbSeBPTs5/Bic3WvKNdNfRkn/J6rdBZ78EoPSlLruLbQRMZ38mkssPq8mT9CEc4IecctYuB7sx2Hpf8e+Lmx58BN5XSBS/Gm3T8Rr/4lzzdb4u15VMqZhh6SFsaBxwoauI5wkPjE70yywEukBonJuFi4UlZQle3vA2BSpCuVBEQycR7cc9YvaC66S763twEJVlb87Y7EeGm5/1jwBC5/MAPIwdpRpUMt/h3KfZqXh3s4DSdijv/9p20W+VMHO/CNk7pyj5VuzDaEgNbgRtV8dx9YO0RwkJ3P0TWM/qeimQK6/1Je0Kzp9Eo9QjOcP194D0coBf+XeITrv8Ni9sJIbadedlyUutvEbowuPMB4BIqvZyo77gFndOurpJrlQCItxQM/HoCE7mvPbjzTInY5vZ27pRigpW8n5sp09IWXER+dvHVKzPNa1WeoydyVRL1PVAWP64dQjlAqJ2J7IVmGAqza+VXBX4SUesvCkyAX1U2NTEuq+FKua+SUN+GeroRSUspHQpug0ckOp8ZqEYh5FGq4I/KuLVSd2lRXJrOsM9wj1km/zPE5qGf+xRVC7yymPPhjw2gY+BYRG+PyErjmY+80I9960Y2tnAm8O5f8ofEnaV9A7dn3ubYTDClXww++YAGktYm7p1fd8eUCig9DpkxEdv5CvbMQ/buW3c0Am1qfT9vaMU11cbZK0DolnFbJ3nKTMnk30W4sePq3qVYBEJn+CId9QDxPUbtihM7h1Y+/d5kahgvODsJLTvPATGa0l0Ld4ayoTbuLFX0lyXPwJNTR5HdNtXptiuhs894m9+OsH8HflFbqSqGPdo5D7G3xQALpV29K
 lxP1bDpJ
 8cIjxBsAJp+9z21wKVx3QJ+hjICcFD0qHqZ5kn0cIcUQXfnwApry02SOJsiMFauoE49ODd43NeFKWZ62RXC4FZFeGcC1l7NN6J/pTBzm13IumgRu445uEjgbrxEv6ziFY3/QRlsD98HwE3hh91HIn2U9ch+RsnHPQ/rKThE39QGB77SElYDxBw4KUf03p/eDwdSgt1eLI7iRcvstSTybUyp793Ns5U7tcbcqdNQi7MPFhLVE+u0mldMv/oI3zyHxBldkvPbns58+HkZVhBIwloqalD5mO8opAotOYUpsPJqXHtGIMRXVG+oJ7wcveE8IM+9ZTON5UqgMd1h+N3J90bAKgZsVxKQjewmayeD0J008hnUYdYp6nYQK/WpZYV1jj9fO5YdY6dSDmfj3c+/Vv9PnWktTJVaCqHZths3JkH47g2AY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 17:39, Breno Leitao wrote:
> The first entry of error_states[],
> 
> 	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
> 
> is unreachable.  identify_page_state() has two callers, and neither
> one can dispatch a PG_reserved page to me_kernel():
> 
>   * memory_failure() reaches identify_page_state() only after
>     get_hwpoison_page() returned 1.  get_any_page() reaches that
>     return only via __get_hwpoison_page(), which gates the refcount
>     on HWPoisonHandlable().  HWPoisonHandlable() rejects PG_reserved
>     pages, so they fail with -EBUSY/-EIO long before
>     identify_page_state() runs.

You should clarify why they are rejected. There is no explicit check for
PG_reserved in there!

> 
>   * try_memory_failure_hugetlb() reaches identify_page_state() on
>     the MF_HUGETLB_IN_USED branch, but the page is necessarily a
>     hugetlb folio there.  The first table entry that matches a
>     hugetlb folio is { head, head, MF_MSG_HUGE, me_huge_page }, so
>     they dispatch to me_huge_page() before the (now-removed)
>     reserved entry would have matched, regardless of whether
>     PG_reserved happens to be set on the head page.

See hugetlb_folio_init_vmemmap(): we always clear PG_reserved for hugetlb folios
allocated from memblock.

> 
> me_kernel() never executes and the entry exists only to be matched
> against by code that cannot see it.
> 
> Drop the entry, the me_kernel() helper, and the now-unused
> "reserved" macro.  Leave the MF_MSG_KERNEL enum value in place: it
> remains part of the tracepoint and pr_err() string tables, and
> follow-on work to classify unrecoverable kernel pages can reuse it
> without churning the user-visible enum.
> 
> No functional change.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/memory-failure.c | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 866c4428ac7ef..49bcfbd04d213 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -992,17 +992,6 @@ static bool has_extra_refcount(struct page_state *ps, struct page *p,
>  	return false;
>  }
>  
> -/*
> - * Error hit kernel page.
> - * Do nothing, try to be lucky and not touch this instead. For a few cases we
> - * could be more sophisticated.
> - */
> -static int me_kernel(struct page_state *ps, struct page *p)
> -{
> -	unlock_page(p);
> -	return MF_IGNORED;
> -}
> -
>  /*
>   * Page in unknown state. Do nothing.
>   * This is a catch-all in case we fail to make sense of the page state.
> @@ -1211,10 +1200,8 @@ static int me_huge_page(struct page_state *ps, struct page *p)
>  #define mlock		(1UL << PG_mlocked)
>  #define lru		(1UL << PG_lru)
>  #define head		(1UL << PG_head)
> -#define reserved	(1UL << PG_reserved)
>  
>  static struct page_state error_states[] = {
> -	{ reserved,	reserved,	MF_MSG_KERNEL,	me_kernel },
>  	/*
>  	 * free pages are specially detected outside this table:
>  	 * PG_buddy pages only make a small fraction of all free pages.
> @@ -1246,7 +1233,6 @@ static struct page_state error_states[] = {
>  #undef mlock
>  #undef lru
>  #undef head
> -#undef reserved
>  
>  static void update_per_node_mf_stats(unsigned long pfn,
>  				     enum mf_result result)
> 

Yes, I think this should work.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

