Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDEB0C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17896B01A9; Thu, 13 Aug 2026 02:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE4D6B01AA; Thu, 13 Aug 2026 02:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 904616B01AB; Thu, 13 Aug 2026 02:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68D9B6B01A9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:36:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF90FC0583
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:36:16 +0000 (UTC)
X-FDA: 85095286752.21.02655F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id F395EA000A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:36:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgdGuyla;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602975;
	b=Vf8oo7kkGUR+ZcqSHzkGavkstMuRU241mlo7uPMHgkMh/CJG23yj6ja1+/3Cb/+c5hCQx7
	LgEOhJOzgtkKmQlv9tXvJemG9tUMhPNqPxa4MJ/NMYnYx8VttsTuA9vCxpQK4XFyjDJ8b6
	meSZjdYcQXbTrxj0g9iX5vS/Q2vWLVA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HgdGuyla;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pJcMxanDgMnTAugEE/K0eDeMUIGS8jiVWVxEhvHnfA=;
	b=UFRwpZHJhJQJYvd8NvmGefzp7+lQkGCsMNoeFsYC6VDuXzSWuX35P+D63JPpxe+iWrDBRd
	tYWElw1kRvEXBg8lhQSinPoOqWntaa8fdiSDW+/SDnDUxEgi/Ok8/tpeQVBTYVEJQIqRIC
	TlhPZya3QhKDc17vw1JW8+GsWEm08Do=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F98943F1F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:36:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D711F01558
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786602974;
	bh=2pJcMxanDgMnTAugEE/K0eDeMUIGS8jiVWVxEhvHnfA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HgdGuyla+PsGa4wDlUISiqY+BaIf/byPELr/9j9vCktfm95hm+9kfLb5SdR2tXou/
	 7+uqk7MeMZIvvXs52Kl4GXpSuUI3XfGHhrwAU5dRmY8BXPIFwMOSH8OPtLuHLQhuKj
	 36PB+suHNQTthHvdVPNArreyicYs3Fv/Ljhsec2jyjqpPxwI+uKxrxTXMGV2DleNkv
	 0PyCeFqkuK18xnoGpga2mALkB5xLzOLNcamUTXBRv2M+CC1sFpLKe9jMoviSC7hcv8
	 Mot0GCaARqE7MJHJud6ngrNgLQ9VbWbKZBI5tWz9fMg9MKum/Yh8YivdqdG+nPZPAg
	 jiOg67oGy7rWQ==
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e6c4a867cso114344785a.0
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:36:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqejRzrNykScmRR6KFOln7nSq3JyYiNtJvYoTZmBAdbJyKHHdVQsjqnuhAcwpqYOGmfsP+S69D4pw==@kvack.org
X-Gm-Message-State: AOJu0YwZHJP7xtb9/xdxsqbCOgtmxHw2VfjyN9G/ZHYqkaHTqxVleXke
	7OJe/pAmT+IdBDad307WS0CyBMeeF0j5zK20pQ0qIQQxx9zODwHAB+nM1jqVzsElgSRpaqS7Z1j
	wiDP+ImaRSDPMD0+BiibZmizr9aJSGqI=
X-Received: by 2002:a05:6214:508a:b0:907:b32f:9b79 with SMTP id
 6a1803df08f44-90a809d5aa4mr28990396d6.6.1786602973130; Wed, 12 Aug 2026
 23:36:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260813061019.49806-1-hui.zhu@linux.dev>
In-Reply-To: <20260813061019.49806-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 13 Aug 2026 14:35:59 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z3gfk9n35cPf3HhjKRrqJ52EHtZHb5eGzOVrxcHcOWKw@mail.gmail.com>
X-Gm-Features: AUfX_mzVo1eHv_rjpqFtS4mU3q7IQxF4ec_BH5u5ctSmwfp_LCILiPXtaEk9w_0
Message-ID: <CAGsJ_4z3gfk9n35cPf3HhjKRrqJ52EHtZHb5eGzOVrxcHcOWKw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/mglru: Fix young counter undercount for large folios
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F395EA000A
X-Stat-Signature: n5zhmo14js6qrr4mzzc3zop1icsfwp6f
X-HE-Tag: 1786602974-941623
X-HE-Meta: U2FsdGVkX18v7hw71zJ1A0Z8a/d7RNoHU5PiVKq+vyD+Napb17L+rFTe/JKs2Ppp6Sohx+0Z68zDUmgO4iUhWSObz/eACRw3k1YcV3NWRr4aaJ4KhwNFC/hy8F3gT41qo8bTM7wWTSUmJ/XF5PZfzm2tpgAN/KkWe5AC0qNu/J7EzPElvNtQnzrswyd7YztrkP5K621IckvBTxAHwLkNyHSjT2TYa2hBs01Xbj8MmU03jajmbRsxvv6vXqdM09gRstvGJNGt1Fj12gTH1+uvjj0WvFd8X97Gt+fPu9nv+QinKtzmBLDP8uCN9nBbVCpvdlTGQpPwLWu+HkfXjr94DJQYzHaC3gGXX6qq+r6ee0eRDUn2pSi4Zpof+sxp8ABhkdx8VDBDWpuSEQVfJ8VN05mSLqXql6iilE3IwMH+kc7GV0Mo6UAHBgLsmyv7RboptUgDelbZ20IkBm2ZfD9j5I5lQbr3p1l2snmLOViafgGe3s8E4kQueeD3ZRnnCY+/47lJR5JRxe//Y4+ct186sQnIcAUJH1loXfsIab7gxZ6IWYnUJaU7v0mafUDLQ1d8pBIFO6kKLpx/c7cVL4a2e+Twt7O6ZeLrZVnABqcjkCL6S91czMGYD0Uaf+wAxtlqot+xD7m6jHnLi0zMyuC4PW6EnqILyZnwWMvxkb6P8vk21F076kywFSirXbSuCQIRn2C1FM2NRvl0puTwje/4KkA1grs9N3RQpiqDJOACstQgBPlF/L6nMhGJvI8ATIrRKMkFSTm6wxvE6jSKQHQIQq0WlguTM+u6WHr3H7l8wiuyqLTNMdNItrPvnexWCi79fAlYTeY9aXcRWBnFihUCX/yhdFMF0zhnvzo8y/wODZgaHHtVUqFPboHGSqzMrMG0LdpeJyRzM+vC9AJlCGoP6nk+YQCOaYBDCMTl0h+gNLe7Wwp7mVHmLK9Lv9jCMH7ccv8z6zs1YGCIpqJerlM
 UaemFecf
 is3bOVmTOF5eWvzYml/Xg7PYTep+duOwCI4R9Fh50fk1iLJFP1l7nwlgHajzYAp2z/sk0hASv2VXQZNfFLLqbhHuCONt+Pc1jQXLMEtsAjw4ArFhzHx0EEWOYsiqzrELyqshIK89XyPjn4hgTxuZ84uhpAZAvrCC7pFupDRvCl0EODaSVJSvWzE6F4dMn8MoZdGw28xkTS8px+xB3R56prroHR/MtjJKB0byWACDkYfppH1KS5j8T1Y7fbw+GokIvTXkQzcQ7ZRqzdr+TYdh4k6E61IfDxxE4Xury5Uiy4K/nVC7+89FHg66kD1Uv/FwwfygANtJN/vQXZow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 2:10=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> lru_gen_look_around() feeds its local 'young' counter into
> suitable_to_scan(), which decides whether the current PMD is added to
> the bloom filter and checked again on the next aging round.
>
> The folio triggering the look-around is processed at function entry:
> test_and_clear_young_ptes_notify() clears the accessed bits of the nr
> PTEs it maps, and the function bails out if none of them is young.  The
> loop that follows therefore never recounts this folio, since its
> accessed bits are already cleared.  Every other young folio the loop
> finds is accounted as a batch (young +=3D nr), where nr is the number of
> consecutive PTEs it maps.  The triggering folio, however, still
> contributes a fixed young =3D 1 regardless of its size -- a leftover from
> before PTE batching.  A large triggering folio is thus accounted
> inconsistently with the rest of the window.
>
> Initialize young to nr so the triggering folio is accounted the same way
> as any other young folio batch in the loop.
>
> Note this is a deliberate overestimate, not a measured value.  The
> test-and-clear helper only reports whether any of the nr PTEs is young,
> not how many were accessed, so the true number of accessed PTEs in a
> large folio is unknown and can be smaller than nr.  Counting the full
> batch is intentional: the mm core tracks accessed/dirty state per folio,
> not per page, so a per-page count is neither obtainable nor meaningful.
> The only consumer is suitable_to_scan(), and the bloom filter it feeds
> tolerates error.  Overestimating is also the safe direction: at worst a
> PMD that saw little access is rescanned, whereas underestimating could
> skip rescanning a PMD whose folios are still hot and reclaim them
> incorrectly.  (nr here is the PTE batch size, not necessarily
> folio_nr_pages().)
>
> Fixes: 56e5b60b2114 ("mm: support batched checking of the young flag for =
MGLRU")
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

LGTM, thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

