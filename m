Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDBAFC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:33:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F7206B00BE; Mon,  3 Aug 2026 09:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232306B00BF; Mon,  3 Aug 2026 09:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1213F6B00C0; Mon,  3 Aug 2026 09:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCD146B00BE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 55B0A1A06CD
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:04:50 +0000 (UTC)
X-FDA: 85059675540.23.51179C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9E99C1C0006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:04:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zsv0eghr;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/XUfGIvoA4j3etSQKLf6FYY8dIX/sJnsTjdfUFKFOI=;
	b=qSvASpZOuROT7BneRAAn8BKPBfEOWjrkHtX2T5uXJQ2CWE4S6x8FdKDpAfJfoa/jRvxd0E
	fUwc85HJgJjEik790Ed91cdfhRn3faAEHw9hZDu5cg3Vqg2y2XjXPSkbU+riLiUmDTOCog
	paR1PREOuFjb+S9U4i8/llz7i543DTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755088;
	b=CyNNCMBHJQMBbpM0lE/ZIU6gFy1vR2GjE5rDkcDDSTGIlHTU0A3/yn5ZHjVGZjhFrq0DRG
	Omjw2QgU1ikuXuB7b86gJyS6/8V3tA7QXXwlCNzHZwMo5VYD35h6g+HoiRsdTyQP4P6Bls
	Y+t7pjDE4s9H1KxwTBeouI/jnpTPkEQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zsv0eghr;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC5A544EFD;
	Mon,  3 Aug 2026 11:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB001F000E9;
	Mon,  3 Aug 2026 11:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755087;
	bh=q/XUfGIvoA4j3etSQKLf6FYY8dIX/sJnsTjdfUFKFOI=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Zsv0eghrYdg4APgwwpdlq9jq9kFOK7+sTCaGK59gLR7Qit/5M2o1jOSlHm5BI/6gI
	 PA6HI6tIwbph8Q3kVCjcL5nlUbn4VWseplhZ4H2RY8XRS5blQpDM5d9A+TUi1vzYmQ
	 8WZHI1zEnRTe0lWxPHlzCn4Td/HeDKQgOaimym80UBnKxrm+d1KJRXkH9ELr0+7u9j
	 8zSujSmHLpXtDo8M1Ml2tcGLEmuG78etm1mOLGJgWH5kxJ+YnHAYumzmujTBcG1XeC
	 zmURBlLhlYye5VcUjBuYgOerm+ECcqSZIoGjDRbqzXZkiqvQW0oulDeCRVyGYHKBpd
	 MGI3hZ/omJR1g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 02/16] selftests/mm: add folio-order check for VA
 ranges
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
In-Reply-To: <20260802195254.1937477-3-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-3-kirill@shutemov.name>
Date: Mon, 03 Aug 2026 14:04:23 +0300
Message-Id: <178575506323.1561566.1421184402954172042.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 9E99C1C0006
X-Stat-Signature: u8edmkctyis38bcfscwjyoacbcf6o39i
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785755088-438026
X-HE-Meta: U2FsdGVkX1+bMfPOev1EA4Wes3qq/bZjaF7573zOuGiDOt/fejV2hALWI6wGEhh22K6KqgfLNmoV/1O+ytMtCeyr/A2M/3zRXoibUfxt4OpaVgmhqPQcxBJ+UYEM7HmOppuTYm4HpkLk9vFJlmacZK2TCreAGR8y+K6QUXko3bjALjdanpUdGEHXy5mbeXHHOgl/2lbYuKh61JgQ+v2z0fB4xuxrGzKkwDHP+K9xtIwiqQY+BhWiVi2SEZl3w18CbC+KCKkSzPXRD3an1trkl8ejrQlkdxqxPZ7oPSqt0kBwRxGF5rR3dzCdL8U01WkjD59vOFHEgVIfM+JfpkrJQTWuBCO+KZqTRcvYYbcVKemE7OZUKd5QeZ66XhhZbpbigvEIiEljRHzAFhD+/+YHr1RjtqNoSbEDWJqRn49zp4vorFGUO0G8KrlKsCXUYSsD3W2bWAuJvnNxDOICcW4lEocrL1gkbDYKLMZ5Vf39Fl5tragHXyT8mlEU+Yv3Hwv1rLDo7waKugUmsEg/WXIfpaJ5v4gNFSUVxx8FUQ9I62tm2lK9dAbEkUC52adZYfN4R25C4CmYIfNmiHBf5Vh49dAq1OF4fA2Pt+oiskN2rA4RvyVEOYuVTHbNuaiQwZbD6Rrqw+nIR+PIvdWovbDiVR/f+mM76RG/qDP6B9gtG/OjRFIKA/8ID9huQbisRSrc6h45Gm77Zp5Z2sElKxhfYUDABlA7ZWVNF5/a4Q6OfNByQDZn4U7YuFUMV9JXK+BBuDf2gWKuiZoNT9opKsTWK5t5CQH3LllcHVOTuz7ZrgqO245yQ3kHfdkdQeym4FavtRP3LVfJUZV+LfB7QofS7WsirYctiexZC1PLtwtvQPkAkT8lbsBJbK781dSmtu6qC0YHN4fVzcppp+aGL8RVijszMV+3XprfUI/JcKf5CTJoEPm0uBzaz+yJDC17cq3wxIdWkWbljym+laBYnnX
 M6OJ+EPQ
 4UTA6LYQhCCOUIGiwj10a+xgAOz7ci9WiTKpMmtVeQL5EbikUrOxP25eEVk1+i67SLd03Xu5zS3UyWKpqpDHjA5NCzGKOMi+BuyrhtkPtEdHiMXhXuZH06+CznpubFFEM9Zm6EnXRbjIuX/4oh4Y8p94LvkI5GcO779ojdeAE8/jria+rox5u/A5XAMvybmPuArvyyUfhECeg+M+JULQLaxpgrrWGk7gizLVgLslM0RccFK2IHOA+7JJKsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> is_backed_by_folio() answers "what order folio backs this page", but
> mTHP collapse tests need the range-level question: is every
> order-aligned window of this VA range backed by one folio of exactly

Nit:                          ^ address (even without Virtual) reads
better to me here and in the subject.

> that order, mapped head-to-tail?
> 
> Add is_range_backed_by_folio_orders(): per window, require a present
> and naturally aligned head PFN, a contiguous PFN run across the
> window, and is_backed_by_folio() agreeing on the order. A window
> assembled from pieces of different folios, or mapping a folio outside
> its natural position, fails the check.

I'd need claude to understand this one ;-P

> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 343a15e25a9f..793342095420 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -365,6 +365,52 @@ bool is_backed_by_folio(char *vaddr, int order, int pagemap_fd,
>  	return false;
>  }
>  
> +/*
> + * Check whether the range [start, start + len) is backed by folios of
> + * exactly @order, mapped at their natural alignment.
> + *
> + * is_backed_by_folio() classifies the folio backing one page; here we
> + * additionally require that each order-aligned window of the range maps

I don't think the description should be incremental on top of
is_backed_by_folio() 

> + * one such folio head-to-tail: the VA range must be naturally aligned,

Please spell out VA or just use "address". selftests are userspace,
"virtual" is kinda implied.

-- 
Sincerely yours,
Mike.


