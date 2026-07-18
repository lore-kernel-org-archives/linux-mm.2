Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E913DC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D756B013E; Sat, 18 Jul 2026 01:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD2C6B013F; Sat, 18 Jul 2026 01:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A71A6B0140; Sat, 18 Jul 2026 01:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 571116B013E
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:11:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D75F280356
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:11:11 +0000 (UTC)
X-FDA: 85000723542.27.4194C26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B0315C0006
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:11:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FP0GUH6S;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784351470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2vgqs5coeUIbHydmceWGGvDiG5E8fZEgppKDMGv9CM=;
	b=zIgTYsM26ul/ydSgj6t0SJiQqtUC0c+55r3pwB66fgCpfIBels/qGOVolhFpQ0hzQuFHuu
	EirOXZkWjsP6hFUFtb8GcA+u25vbsoUFA65P8DLExnuOQG28pcKaYgmKybJqxtODGSQ3Yf
	Tc5ULmOy6x2/oMWLxxxpY1FIfjJ5NLo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FP0GUH6S;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784351470;
	b=IYGC9pfm7n1rA4u3v3FGTaro1F1zvJv3y1xab7vYNou1zZmFvvBzKQeRfa0jwY0d9SO/3q
	twtb6+w3B/dMuZyv79bgKZg6180Sgy7Ixei86tMNMRuqNfLzeFbA/zpumyd/LEk0kK5zsf
	tXSxyjQdNE4UNZACHvmh8cocKBXa+Uc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 071D760A68;
	Sat, 18 Jul 2026 05:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB761F000E9;
	Sat, 18 Jul 2026 05:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784351468;
	bh=W2vgqs5coeUIbHydmceWGGvDiG5E8fZEgppKDMGv9CM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FP0GUH6SagTE+JjlnB97/VNhyY4BnupLN1jU8MGQQVNJRvRmjS2RQk1YIYpUxcarN
	 LDoIUqlLDSh82m5hhspcHQbgdyvm6VbvMQ5OCGZya5e9nsHNW9BuiQfV6PWjn+URDC
	 +trchamr5RBVtbM2qzIS8ESWgD18BDJ3ExhJPr+w=
Date: Fri, 17 Jul 2026 22:11:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <enjou1224z@gmail.com>
Cc: linux-mm@kvack.org, pasha.tatashin@soleen.com, vega@nebusec.ai,
 roxy520tt@gmail.com, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/1] mm/page_table_check: widen map counters
Message-Id: <20260717221108.c6caf7dd11a47bd7c32aa6ff@linux-foundation.org>
In-Reply-To: <b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
References: <cover.1784337674.git.roxy520tt@gmail.com>
	<b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B0315C0006
X-Stat-Signature: emrz7ac1o38dstwwi5a1q7ciad4jn1wo
X-HE-Tag: 1784351469-402160
X-HE-Meta: U2FsdGVkX1/2ZXa9gp6YGmgWKh6AE6sheIabavF4cv0moovJUAfnD/KBBdfGga2vfb6jgNHp42Bni4iGQXWdb+lSG6K/cyiMuWhyjpeuDDFV0ob7LbJuzDZxE8POo/ZThVUHhtuhbPbD2Gh1ZtLJ7Q0RbzXcJQFzZWweiADsAZ0MR+2x+JMTU+EvIOawp+zwliz7a58eqRh7fiujHhWU4fHDQf6RwqzrmWXGgFXKj/wYGZxoXIhgiPdNL8fDAtcnC3HmDp6dZndreX41gN2FXUlwWqkHpOuay/8Rh+k+22q9e1VBCRRFu7ZNZZ17ra/MWc9ZIP+5p7Oz/t2pN5Mr+xKiXTX/QxZbrRVRy1YWQAh5xRmstOxRt+oBX57T30fpasjQKjD6tUxCbVoCfgxM0MBcsrBq/NRr2g8eiCMl1opNG7G1F4zwOyLno4W5v+ORKLmqqBGgGUhhZkA26uRBJkQQ6TEdC1vO9gAb2M+jud6kfCKMf7DB+HH5hzmzgdpnxCF3skP4UNmlGTdd0L/sk7lhc7NRyO8ERR0dhx/U3LUEgpjpvp37tV/0jLDh5AxXkXlDeAfVykwNk8DS8vloPI0N2Fud6GJEpytKiArgNB0iTsFm0U+z+tBqPPLARWLprPYhTfO7Mj8rRs+ui5psA84ldpFqGmPXfqyHCUZSdlNWpkhip/ux62ekiEOA7xH0++zgsjFnyCSX0YahpbGWlgDkxWDqKeBtrlc51BiGdBZZKyYk/L3kR1M3fmfnRgPRRQiVCOSV6G3tl3g2xYW24H4ULnjRhXUw2SC3Tl1oD2fjZXDGJ0GP/uHhU5OqV//kK8o5EcAl8AoRjqH3CCrFPxOA2CPx1Rh9hyWfm/Kn7mAqFd8DIIP2pgUL4Cr7poahB23O9lyiy2ahXF5dSWbxKhQEZ7X52IMOWsFypolviFCGhsiMDNacfuEdYJpVMHsxjJLrmb8wd2ecuo8u8/4
 ww4xc86Q
 CM8PtQPBiLRCt8w8G9cXWuN2GfRhUKSZd227ugDHad1+gwqaMBRw2V5hTIKKgnGd9Qfse74GF/tw5Q4Bqr3NDUH/Q5gy3IMFCYyYNKkpV6YocqvXI1oHDKP6Nq924qyzYTpIMklClQ8EvURgyAN4zZ/q8JALZDZMdjPIH7xltK78B2N72HLG/bm9kNd93GRG02T2xKXHixQftp398LhQwB3N0J+pki0xPLBqrdnzPGU30P5aiz4+Eet4gIOr04ETZrKhqUn9SOSLAMdZxNm1G6+Zvp7iJXX8SDmDlKCwhej4uPxKzugtKNfUhzWVGrTTsxPpvzB0I5PasU7XHOEDK5/g4Q/PgEMA5uzdNaIxdcKbY86eWDEa1Gq3uuJxK6gCsHeCRCB2eIrGj0Otx1BnrPFqg4w==
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

Thanks.

> Fixes: df4e817b7108 ("mm: page table check")
> Cc: stable@vger.kernel.org
>
> ...
>
> index 53a8997ec043..edd9d9edf6fc 100644
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

AI review suggest this might cause problems in, of all places, page_ext.c:

	https://sashiko.dev/#/patchset/b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com

My googling indicates that a 64-bit atomic op on a 32-bit-aligned
address is probably usually OK, but it doesn't sound smart.

Probably adding __aligned(sizeof(atomic64_t)) will address?

