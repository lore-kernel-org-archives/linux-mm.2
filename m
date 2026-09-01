Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A5DC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 23:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D076F6B0088; Tue,  1 Sep 2026 19:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB74B6B008A; Tue,  1 Sep 2026 19:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCD786B008C; Tue,  1 Sep 2026 19:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5456B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 19:50:21 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D0851A0539
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:50:21 +0000 (UTC)
X-FDA: 85166839842.28.E15E35C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4FA7640003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:50:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=taf78+zi;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788306619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cO2NQpTqNyksv7OnpDCOabiznLBIQ5ThRsjNguJQrl4=;
	b=Vq3ZO9C+dGeJsb2GGAKTj/ECv0hWKAy0623tL0nnSoy6zBdOli+BcVCeyT8GaCqDLVnjCc
	YMu43L9rAOkus7GD1IzqXb1RGAI31rEH7hEhtx1lI2woAYgk1AyCBgPLBPJ9B1SzbD7XVC
	oMuBgUec/EGae4+JnDe251u9wGgrENA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788306619;
	b=yIp2Vw6+k8oFfXzgoLle9KTVcJi4Jh56SSU3RDJHcD6GVT+rM7d/hnROsqU8gzdU0I/P5H
	ACAMoGlAFXcRUYyP3k7fBaRFq2b1nFv8rvu6kA0V2VrVoOkEhRjrr81LonxnLun9n7Mz2B
	PU+Ss4nbj/7NJ5VoE66AEN4wa++iJVI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=taf78+zi;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71D85436A9;
	Tue,  1 Sep 2026 23:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313211F000E9;
	Tue,  1 Sep 2026 23:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788306618;
	bh=cO2NQpTqNyksv7OnpDCOabiznLBIQ5ThRsjNguJQrl4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=taf78+zi66bkZebf7dLDJOwNcMfwFaFJ1quVuqATGJUR2HutI2NHyhDf9PFUgC33r
	 nUGUG8JiAx+KGoEwgeLRzvAiCe0kpwhl4RS8LMm45jlCZYI1DEKbWxxcyJdZcM04ih
	 qlrwrTQPrkiG1GfHnGMBK6ivJoYgkn9kz+RxUtVs=
Date: Tue, 1 Sep 2026 16:50:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <enjou1224z@gmail.com>
Cc: linux-mm@kvack.org, pasha.tatashin@soleen.com, vega@nebusec.ai,
 roxy520tt@gmail.com
Subject: Re: [PATCH 1/1] mm/page_table_check: widen map counters
Message-Id: <20260901165017.78b57617473af4c4c60b0825@linux-foundation.org>
In-Reply-To: <b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
References: <cover.1784337674.git.roxy520tt@gmail.com>
	<b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4FA7640003
X-Stat-Signature: 39yisuxc6o365e7s991ofxb7raqby78t
X-HE-Tag: 1788306619-351152
X-HE-Meta: U2FsdGVkX1+kJN1iMH0vO18Mj+SRg/g272+seuhtrFVUBVWypSYzbrhtSaXJFqsUkNIKKeD7mxH/B/6MT4ejQ/1Z2wbEmaA4lzc+j0U8vqwW1DBHSin9b3tUjiJjHs3SIdZj62yXbCYVDHjZOPkIrx+RNnPsR85tV/OjElwvel+T1tmKiho9Y7idvQluE1gZQ0uFpchJOX/5WUaIktsBgOHje8iA+rIng+QdDUrUAakpNcB2ImhFhRwgoK/HEyfjbU/KPIcT5GXWsTH7gd/HQLJGWd+lYpZbzBVeupM8jQwWXeCEjIbZzArX1shqYi5Slwo1DbUjgxbNjdJ6sosIBmQ6jH7UinSVuuXXXzj6TrNlFOaC+gyOxtNqyvJ/WgH4ZvN35vVyHq8ROBG7S7wIyktGhHnHk/FqrfkAmYb3YBH1B51Dw1KhuUq2Nymo6wtrlwYZeA2jrusGWr+ZwXmWBHQev4VergPoIKjhnYGcOD1vWMuAI8m7Hr4AraPZi5OOyxQz66xKkIEtm0oscPG6Q2/OOk1v/FkAVPcv/d9XJQxzxlzVcvNVhwJmWOcHAH6og6YkZgiAwfgdCUIqck5/9vjaDFO++dNnXG24+B5sI/zKJ7+T2VaRgQgnLGBfISb7Lhiw8zwXpbw0WJddFxdWRFj/DFq9MHHETsaZdoYYfy139eiwNgSwUPadk5KkmCGxMpGeKnJMLuS7me84CVzUS0DxgEtsjAaiepWvgWYO0mLgjGX69GVj6Ck0hyG05GhGBHbxZl3kJlo78Ms3nlLh4tNtXj+QK7gC1NsWYLHzWo+7V7JN1fiWdUblSpv+ueBeV7AfnGdAu0xFRIJNr+saGYrE0jxuEe/N91EdPOt1uj4uFsLYT3n9ohdrZwK8g5VfTMLndiqwVzQnLzYkAEOoiBwUVYtiGa25qvhRPxX1C7euNDGnoqzzl3xLtO3CGBdRI0ilb8ZgFqY5ZpHz3ag
 tU/3UpTK
 pweFtliV1YFFr8h0YxxKHm4g5SR/EtHhMLKdvt8lQ/IchTzOUbkk2jJkrAb5X4iqD9JlS750TLD3QZkqZCb0HW1y002XlzffWwWW9HwCItJEkcmZ/1YeMbiiAZ9R6a2NH0gMPGFWpaaLjpBizK1H679rZVN46YPRJSk5UFxMjSu+3D79rrCEIYfj/XzAbse+rH4oNxTTFtAkocOOZ+8koe8WOgNv18Ld9gX2//DUzcL55Rtxy8/D84RmzRJbwrsmgRZSyFbi0J894GG9MKIJ+IaFSbRx0DQRxnPNnkvWfGi1H2nDg+IaDrg3QX6+KDUaHzzMRCv+XnEqoLN+1tLTJ7R6picun+5Tn7TN3RwUC5WKz0dBvNdDMmRe99xaLxEfBOAwoIJyEMcwFkkpMcE7oK7psJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 18 Jul 2026 12:27:20 +0800 Ren Wei <enjou1224z@gmail.com> wrote:

> From: Zhiling Zou <roxy520tt@gmail.com>
> 
> page_table_check_set() and page_table_check_clear() store per-page
> anonymous and file map counts in signed atomic_t counters. A page can
> have more than INT_MAX read-only mappings while still being mapped
> legally.
> 
> The global zero page is one example: repeated read faults on private
> anonymous mappings install read-only PTEs that are accounted as file
> mappings. Once file_map_count wraps, the next set or clear observes a
> negative count and trips BUG_ON(), allowing an unprivileged user to panic
> a kernel with CONFIG_PAGE_TABLE_CHECK enabled.
> 
> Use atomic64_t for both counters so page_table_check can keep the same
> type-conflict checks without overflowing at INT_MAX mappings.
> 
> Fixes: df4e817b7108 ("mm: page table check")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Zhiling Zou <roxy520tt@gmail.com>
> Reviewed-by: Ren Wei <enjou1224z@gmail.com>

Thanks.

I've merged Zhiling's "mm/page_table_check: prevent map count
overflow", which appears to address the same issue. 
https://lore.kernel.org/1f8848512d2e3ded944f8d595c29faee8fdaeab0.1784645969.git.roxy520tt@gmail.com

But the patch I merged is very different from the below.  I assume the
patch I merged is the one which you want because it was sent three days
later.  Correct?


However my question regarding the possibly missing barrier remains
unaddressed:

	https://lore.kernel.org/all/20260721135614.7aa2d8d9a8a732a66ba623c3@linux-foundation.org/


> --- a/mm/page_table_check.c
> +++ b/mm/page_table_check.c
> @@ -14,8 +14,8 @@
>  #define pr_fmt(fmt)	"page_table_check: " fmt
>  
>  struct page_table_check {
> -	atomic_t anon_map_count;
> -	atomic_t file_map_count;
> +	atomic64_t anon_map_count;
> +	atomic64_t file_map_count;
>  };
>  
>  static bool __page_table_check_enabled __initdata =
> @@ -79,11 +79,11 @@ static void page_table_check_clear(unsigned long pfn, unsigned long pgcnt)
>  		struct page_table_check *ptc = get_page_table_check(page_ext);
>  
>  		if (anon) {
> -			BUG_ON(atomic_read(&ptc->file_map_count));
> -			BUG_ON(atomic_dec_return(&ptc->anon_map_count) < 0);
> +			BUG_ON(atomic64_read(&ptc->file_map_count));
> +			BUG_ON(atomic64_dec_return(&ptc->anon_map_count) < 0);
>  		} else {
> -			BUG_ON(atomic_read(&ptc->anon_map_count));
> -			BUG_ON(atomic_dec_return(&ptc->file_map_count) < 0);
> +			BUG_ON(atomic64_read(&ptc->anon_map_count));
> +			BUG_ON(atomic64_dec_return(&ptc->file_map_count) < 0);
>  		}
>  	}
>  	rcu_read_unlock();
> @@ -114,11 +114,11 @@ static void page_table_check_set(unsigned long pfn, unsigned long pgcnt,
>  		struct page_table_check *ptc = get_page_table_check(page_ext);
>  
>  		if (anon) {
> -			BUG_ON(atomic_read(&ptc->file_map_count));
> -			BUG_ON(atomic_inc_return(&ptc->anon_map_count) > 1 && rw);
> +			BUG_ON(atomic64_read(&ptc->file_map_count));
> +			BUG_ON(atomic64_inc_return(&ptc->anon_map_count) > 1 && rw);
>  		} else {
> -			BUG_ON(atomic_read(&ptc->anon_map_count));
> -			BUG_ON(atomic_inc_return(&ptc->file_map_count) < 0);
> +			BUG_ON(atomic64_read(&ptc->anon_map_count));
> +			BUG_ON(atomic64_inc_return(&ptc->file_map_count) < 0);
>  		}
>  	}
>  	rcu_read_unlock();
> @@ -139,8 +139,8 @@ void __page_table_check_zero(struct page *page, unsigned int order)
>  	for_each_page_ext(page, 1 << order, page_ext, iter) {
>  		struct page_table_check *ptc = get_page_table_check(page_ext);
>  
> -		BUG_ON(atomic_read(&ptc->anon_map_count));
> -		BUG_ON(atomic_read(&ptc->file_map_count));
> +		BUG_ON(atomic64_read(&ptc->anon_map_count));
> +		BUG_ON(atomic64_read(&ptc->file_map_count));
>  	}
>  	rcu_read_unlock();
>  }
> -- 
> 2.43.0

