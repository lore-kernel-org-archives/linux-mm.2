Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BBCCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 07:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A61E16B0093; Tue, 23 Jun 2026 03:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38FF6B0095; Tue, 23 Jun 2026 03:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903B06B0096; Tue, 23 Jun 2026 03:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 681886B0093
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:59:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2CB7A0371
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:59:53 +0000 (UTC)
X-FDA: 84910428708.14.847002F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1A2E2100002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:59:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGrFCjlh;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782201592;
	b=tUMgdP4vXVskIN3YDs0XbjmTw0V8deQJCQ0k9sf1Xnx2tr0HpPQam6XuXnkNSjFZ8RPJbI
	6w5UVc/1adrV2FtBriIhnKmU849FL1iIUaUt6akfLDr6dyGs3VN2C0w1PD4L2LQRZnq4pf
	EZKPX/SKR+bfysnEtB5z1NW6kA1NJbk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782201592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ReFzOAG/aop/XLXwnu7jqpdSGC0TM43hdACQPrs7w8=;
	b=dPbQZbLOkJt44hXrfoPDfhLIFaX8upaS4uxjW/imjIf+KqWp2dMTEY0MKjt/qUyLaILTfd
	prsgLCzKXwlNHnK02FkFloOHZOcNC7vjtIWot9HYHSVzYiY+54zAkTsgtYQwZXvSaAHMwB
	qfEq22/6HSYEpzYCntsAm/rZXSVxyQg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGrFCjlh;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0905C43D46;
	Tue, 23 Jun 2026 07:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E691F000E9;
	Tue, 23 Jun 2026 07:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782201590;
	bh=9ReFzOAG/aop/XLXwnu7jqpdSGC0TM43hdACQPrs7w8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=UGrFCjlh1/3KCsbFeugr5KMlYdzAEX110rDTHhR7OPJdb0hkYBhpsyiLNV1y82SLa
	 ghuhkCIK4raVycHuqabJ/g+wDVqpIQI8GtcrEbVijonVjIjR2wogh9GNM07nAxfrFy
	 nRWZnHVXH7hEFdWCL2wsFnrvnEgKgxtr5SUyeEy+BbwjQQDufaT8Dorm7U0OPugRV1
	 YQUrfPvfAd0CC2soZM7OrFnvqPQIbGZHXWQ6+GQucGNdse5JHYWgULc3Ap4QkJo8hY
	 5j9xVS8MsDAo9c0w5mUp67sTQNwqUOa5C8e9EVkOh57Bm8k8py5NpfPyvggJTbkUMF
	 1HukMqUMNsnIg==
Message-ID: <97f2c4ad-c302-424d-a7c8-fdfa0fc0d811@kernel.org>
Date: Tue, 23 Jun 2026 09:59:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: avoid KCSAN false positive in page_to_nid()
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260623074157.578113-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260623074157.578113-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A2E2100002
X-Stat-Signature: j6e8kd1itnb1hasb9rz591jxqb9sh9w3
X-HE-Tag: 1782201591-465570
X-HE-Meta: U2FsdGVkX1/Kk6EOYzSzc9u3ngGVXPC8U3kL2EU6D3dzSATT9PHiiPJ0kjt0Y7R05YX3q/n2drEIQGyzxul3IDeKS0LtHf+mVYKDuuDoO/tc9SODkGVPAZJZTGGToqlx24ElPlX+Va5y6pHLjcI4fyJZZCOcXQDrjZknseaiTa1n7s/Y/ReRcYvIovTvuMhq5L7C3vOOqaUWD+a30A0nLlq/gjY/EzdZ/ZutIktT3wXinoaKEJ0gcSzaDZsdcTz82GqlTwlsLeLxRdJL4l9Tru0LEQg/vtpZwnzXTSwM+cAcLLfTLWfGgh10t6jlR5+ECiku94sefG9oWWTWQN6vak87Lv4pDH2nFdM+NK592N/trKAmpZGp4jkJYeW4MwuHGJifQbWVBXh8+KELdZwJl+8B7j6wyfyXVdpxAc8TeqZ6Yk4CCgFAX2+3cwaVYqXiCkr8eOrdZUfbIjfH+j2zuSgFC/fE+noeLLI0qn0TzzIur4Oc0tkR/zsKxE69c1Qse++HsQ3/sLg2H8VeqFUJTJKW46ZRnQu6yT6gIakSTiRqsxFe//Ixu05lWMqsC1s6+z5UoKb0FgcbFM/rd3T/gOJxh2PwhJZ1fOa7pevtMgrVPK21N5Tr0/Xh6NMqmw+65FCOOdyA7PgldZtHuhMyn33exVPi6e3Q6/3iXeUkRx3b1h+atT5GAS+o5iBYUvQn6yfeJz8vkZ//wvP1mcBAC2M1FIs8P5+7A5Lb2BrVqeDrmT0kGTaU5/EVoOBoy+UzRiyL7727WC2KURD5acLhU3/IgkjTyFU9TycXrlwAQ3ACNNFbV4wTGH+ZW41zSgqcQtw9DlfCUdnDBkz8H2lhWT9ExoEixF3yvp6JfsFNvg56Ev2snbli7JtLw4kYhe8DYv7HUe2uhjCJPky00QwoguzJNsnWgCilHUWkMFDzajxSR7lrW0Lauoc7+BF/tryYScjx6KhqfIlQ+sBZiQM
 MXqTLE/I
 jIQeUmhNnHWyGav1UGOtQOg4dOE96KSEYlKH2heTdib9omMMbioQYwrlcyRrJbPwNJwHchAPDcUVTMp+EPrx38MpLGSqTOoK9DaO8j0PCA1qnyXjwu9lDulENjwDD8/gEoNAJ28csDLtRyYpgoZX80w0wOZYzvvwVD1HF+c2MM5kUkLQE9lbqskZizTEANQHnA4IYNOCH/PUN5GBqq7KTJA2dqYn0hbhg34DFerCA73GCXaNSYt8GE6dMP23/FnCQi82ym64EjaL6al8rU/ZFJvy1U/4Jtq1yvF32g+up1SOGAyP3jeH0ubDMKTvLO2Cpg2iEuDmFKFm6xGXAJ8WnfXA9/VUedJyTom6fYgGp9yGSZlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 09:41, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid() reading page->flags
> and folio_trylock()/folio_lock() doing test_and_set_bit_lock(PG_locked,
> ...) on the same word from another CPU, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id occupies a fixed, high bit-range of page->flags that is
> set once when the page is initialized and never modified afterwards,
> so it can never overlap with the low PG_locked/PG_waiters bits touched
> by the folio lock path. The race is therefore harmless: page_to_nid()
> always returns a consistent value regardless of how the read
> interleaves with the lock bit ops.
> 
> Wrap the flags read with data_race() to tell KCSAN this race is
> intentional and benign, consistent with how page->page_type is
> already annotated for similar packed-field accesses.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  include/linux/mm.h | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..122d3b39369f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2296,7 +2296,14 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
>  
>  static inline int page_to_nid(const struct page *page)
>  {
> -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> +	/*
> +	 * The node id occupies a fixed high bit-range of page->flags
> +	 * that is set once at page init and never changed afterwards.
> +	 * It cannot overlap with the low PG_locked/PG_waiters bits
> +	 * that folio_lock()/folio_unlock() concurrently update, so
> +	 * this data race is benign.
> +	 */

Do we really need this excessive comment?

> +	return memdesc_nid(data_race(PF_POISONED_CHECK(page)->flags));

In memdesc_zonenum() we use ASSERT_EXCLUSIVE_BITS.

Can we do the same here inside memdesc_nid?

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 69daeeab7fe8f..76d3bb54be844 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2290,6 +2290,7 @@ int memdesc_nid(memdesc_flags_t mdf);
 #else
 static inline int memdesc_nid(memdesc_flags_t mdf)
 {
+       ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);
        return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif


-- 
Cheers,

David

