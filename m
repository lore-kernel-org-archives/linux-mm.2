Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69AF1FCE074
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98D26B008A; Thu, 26 Feb 2026 07:57:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59726B0096; Thu, 26 Feb 2026 07:57:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90136B0099; Thu, 26 Feb 2026 07:57:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 932AC6B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:57:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3B59E850F4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:57:56 +0000 (UTC)
X-FDA: 84486610152.24.E30F5C4
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf25.hostedemail.com (Postfix) with ESMTP id 63E4FA000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:57:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=TwPizSSA;
	spf=pass (imf25.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772110674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPQokzKIR4QEBWebfj0SvsNzvMWG4WPoP7HqHEXWzMQ=;
	b=oi6v/aCJ0s8SRYttJBqBj3C9SW3iWsjSXAkUPoyvrgCjStLTMzgoESwRN1orZ6gr5FdCcR
	92TVifuV9z/DIr/hKGtXJlodAFgGDvWE75ZtRphG6Ib6i5C34pq3/lgrnQbhLu51lq1PwX
	Tg4TZmV8Tn+9jRDAaijoFZUfaSByocw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=TwPizSSA;
	spf=pass (imf25.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772110674; a=rsa-sha256;
	cv=none;
	b=nq2/lg2XHJwHgqXn3Eib5j7O3EGOeLxpmQZQduzF9pVmnMMhVsICNy5WoZnBafR+kJxDXM
	7gyvKy/IApJV3VlYC/t0hOjFAwLn7KmC6AmOXZ9A5gCx5KJTcFZ2MIO/vZVcGrhl5uWWbA
	B8wRrvwYau25dSMtMZSEUG9j72osW+A=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=XPQokzKIR4QEBWebfj0SvsNzvMWG4WPoP7HqHEXWzMQ=;
	b=TwPizSSAdOagw0bRh7x9IGiFjHeSd1U4f84NwrsYKyLjJr8Foe70PHW8i7BQj+zKPj5JA4FlL
	rcmmpD+aswtkoAFS+xBNWtXQaq7zLngNReFKlH1HKQbjgDVT/QLZGNfJZC+C45XonlFGKnZM/6e
	a2vPgM3n9JYPmTQVeJCSTrM=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4fMBHD6WPdzYl5nV;
	Thu, 26 Feb 2026 20:54:16 +0800 (CST)
Received: from a015.hihonor.com (10.68.27.88) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 20:57:42 +0800
Received: from w002.hihonor.com (10.68.28.120) by a015.hihonor.com
 (10.68.27.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 20:57:42 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Thu, 26 Feb 2026 20:57:42 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Barry Song
	<baohua@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Lei Liu
	<liulei.rjpt@vivo.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, Kairui Song <kasong@tencent.com>, Tangquan Zheng
	<zhengtangquan@oppo.com>, wangtao <tao.wangtao@honor.com>
Subject: RE: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
Thread-Topic: [PATCH RFC] mm/mglru: lazily activate folios while folios are
 really mapped
Thread-Index: AQHcprbIkLI8koBjtkqDPEnVc1b3J7WU7U8w
Date: Thu, 26 Feb 2026 12:57:42 +0000
Message-ID: <2558f7d82b9a482387960f45409e1b76@honor.com>
References: <20260225223712.3685-1-21cnbao@gmail.com>
In-Reply-To: <20260225223712.3685-1-21cnbao@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63E4FA000C
X-Stat-Signature: 9mj6stfoqtjh154ichqufrfp6uqp84na
X-Rspam-User: 
X-HE-Tag: 1772110672-972189
X-HE-Meta: U2FsdGVkX18bA22gF3W9WpKZVqxJoKpsG+epMpt6RTKRKMGniYmJdY/a0whHM3vQ4x53ren1w/b1cohwVD1LtsMMs+wCnhiKwgSmmiTw4x/vDsk4nL+nMrSoLghuKjJj15SE4jg6iYKHxxkbchzYawUaXJMWcDaM1Gw6hAjjLqcVA0gQ/vlW64uE35ifacfr4fbVq30ElNODZx0N0Yd+b1Q1uu7jkWF688fWhpgtQiGO+UtFgENrzed1jL4Dj7B7vLV6UcD52ySC7H0dBHqiJr7O3Po9bGXqn74StN0/jDHOV3udPZdEWySlRxgVx7aGHlp6a7S8BL7T4/ijZ5rDc7isZ8xlQqfjLggFntrLcE1tJMmY2RkxVowdupXIU1Og0dM4Oe5PJxgziViJwmJQl9Bw8G827fGt15paQY0+Tijn+ANJcXRzIT5T/N9BI3WVVeH1N7mZOVRfTZZb58QDk5ioypEhsxaDVUoPw/gLsItjKM3TVS7bN5zOelQrgbuLVIrrRx19SRWUcM44UYSXefgCAL+OxfyYqMbLOyje1OuoGNu7zgCMWtWaxSD6542jJZ/aCdRKu7E3NF1/BLR5cU4+Vtq3jAL61IjD/d6L0NbMFyPET/7ELHo/3TZpCvoCKOQ++V37mZE7P1gyL32ui8MwACS6JAjwwhoh9qajut3kYHQaDuIsSwEdE68V3352a2uHXbyngu8yVDHo1Do3qw+4uV8F9aAXhzJIfcuXwYZHtlpsi5lg7Ws7OjDFrIu971py4PFCYzCB1hhu1SRI2eI0wmsLOPjE1okB+T3Qx9kOuxGjO1/TmLzE566qWo535Jb4Bqieu6yqrA/P0UDJP1EP1VEEBfO+GJ+qFTkoaTDsBlpGY4SqlZFJgyCIM5rC/7P94cRgDeMnaK+og++Hzu2vEOq86qE5nA3VPhUiKbdq/YqFCSTDwm95a5gcpYciVGQdji0S/KOAXcHNIVO
 3P/186/M
 PVq8lzfzFqwnjOnPoH9gtX6WwRAxIStsYpX089fi859v7Ph3rD5wjUoA+uYScXxvJR9YW8wrQI0psENZpeV8h/0vmY3GV+M8hTgnDhSxsJeRBH4NuvqS/3WwVRlnZlGa1cWnQly+q6TmlT7ARuHw2lIaFv7c62ORollNXYUy6EmM+Q9aUCPFtAIUaQaWI936kYo8PE6Ji+DDKLPJL6I9rsoX1KEFHQwrnJ5UKikHqDsR7r1O4UL814itQJXyXN+2NooE/5nj07Xh7cUwoT7DzPSyCVeVtZBabtPVeS4XXi/d8TW7QRXuNy0tfirGFvFFfcPOTY+su+1Y8xgu+LLS4/A0msbZWnBWQqVJBayuc8WZb/3kwPjPUcghwMzXRhy0SQcofAr8hNSO0kDN46o+69xLg05NUiKwD+zzls4ygEZWNuR6dcqB+u02eQzQ4q4uUl7eaDUgo3o+vjIzyHtb+CyK4iGlHMiKOYLAfT9FOtLr1ugARtBnBVqRanS4w7vAqERBvOtaX44G+MIMcxSEqJfgL0aP/luQOBFnBEp2C6NOOYu3mgSMMQS0f+oSIzV06bLT+LWc8Fs6cUuNWI6L//3uyWyKeRiyXST6UMJM3F2Eg+aKJszVnRHzjewC6gNSciCLwbHAAEQWVxmwFbWOKjLYjqrIfPdYtQbq5i4NKPaLt9xmeS9G9ty0k/AuTbx4hZJrmKdVWpwRSayNJZe3J564HIYh54xCrMtii7iG8OgU61eo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> -----Original Message-----
> From: Barry Song <21cnbao@gmail.com>
> Sent: Thursday, February 26, 2026 6:37 AM
> To: akpm@linux-foundation.org; linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org; Barry Song <baohua@kernel.org>;
> wangzicheng <wangzicheng@honor.com>; Suren Baghdasaryan
> <surenb@google.com>; Lei Liu <liulei.rjpt@vivo.com>; Matthew Wilcox
> (Oracle) <willy@infradead.org>; Axel Rasmussen
> <axelrasmussen@google.com>; Yuanchu Xie <yuanchu@google.com>; Wei
> Xu <weixugc@google.com>; Kairui Song <kasong@tencent.com>; Tangquan
> Zheng <zhengtangquan@oppo.com>
> Subject: [PATCH RFC] mm/mglru: lazily activate folios while folios are re=
ally
> mapped
>=20
> From: Barry Song <baohua@kernel.org>
>=20
> MGLRU activates folios when a new folio is added and
> lru_gen_in_fault() returns true. The problem is that when a
> page fault occurs at address N, readahead may bring in many
> folios around N, and those folios are also activated even
> though many of them may never be accessed.
>=20
> A previous attempt by Lei Liu proposed introducing a separate
> LRU for readahead[1], but that approach is likely over-designed.
>=20
> This patch instead activates folios lazily, only when they are
> actually mapped, so that unused folios do not occupy higher-
> priority positions in the LRU and become harder to reclaim.
>=20
> A similar optimization could also be applied to swapin readahead,
> but this RFC limits the change to file-backed folios for now.
>=20
> Based on Tangquan's observations, this can significantly reduce
> file refaults on Android devices when using MGLRU.
>=20
> BTW, it seems somewhat odd that all LRU APIs are defined in
> swap.c and swap.h.
>=20
> [1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-
> liulei.rjpt@vivo.com/
>=20
> Cc: wangzicheng <wangzicheng@honor.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Lei Liu <liulei.rjpt@vivo.com>
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Tangquan Zheng <zhengtangquan@oppo.com>
> Signed-off-by: Barry Song <baohua@kernel.org>
> ---
>  include/linux/swap.h |  1 +
>  mm/filemap.c         |  2 ++
>  mm/swap.c            | 16 +++++++++++++++-
>  3 files changed, 18 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 62fc7499b408..ce88ec560527 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -335,6 +335,7 @@ void folio_add_lru(struct folio *);
>  void folio_add_lru_vma(struct folio *, struct vm_area_struct *);
>  void mark_page_accessed(struct page *);
>  void folio_mark_accessed(struct folio *);
> +void folio_activate_on_mapped(struct folio *folio);
>=20
>  static inline bool folio_may_be_lru_cached(struct folio *folio)
>  {
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 6cd7974d4ada..0b8f383facdb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3567,6 +3567,7 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
>  		}
>  	}
>=20
> +	folio_activate_on_mapped(folio);
>  	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
>  		goto out_retry;
>=20
> @@ -3926,6 +3927,7 @@ vm_fault_t filemap_map_pages(struct vm_fault
> *vmf,
>  					nr_pages, &rss, &mmap_miss,
> file_end);
>=20
>  		folio_unlock(folio);
> +		folio_activate_on_mapped(folio);
>  	} while ((folio =3D next_uptodate_folio(&xas, mapping, end_pgoff)) !=3D
> NULL);
>  	add_mm_counter(vma->vm_mm, folio_type, rss);
>  	pte_unmap_unlock(vmf->pte, vmf->ptl);
> diff --git a/mm/swap.c b/mm/swap.c
> index bb19ccbece46..e50b1e794ef1 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -488,6 +488,19 @@ void folio_mark_accessed(struct folio *folio)
>  }
>  EXPORT_SYMBOL(folio_mark_accessed);
>=20
> +void folio_activate_on_mapped(struct folio *folio)
> +{
> +	if (lru_gen_enabled() && lru_gen_in_fault() &&
> +			!(current->flags & PF_MEMALLOC) &&
> +			!folio_test_active(folio) &&
> +			!folio_test_unevictable(folio)) {
> +		if (folio_test_lru(folio))
> +			folio_activate(folio);
> +		else /* still in lru cache */
> +			__lru_cache_activate_folio(folio);
> +	}
> +}
> +
>  /**
>   * folio_add_lru - Add a folio to an LRU list.
>   * @folio: The folio to be added to the LRU.
> @@ -506,7 +519,8 @@ void folio_add_lru(struct folio *folio)
>  	/* see the comment in lru_gen_folio_seq() */
>  	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
>  	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
> -		folio_set_active(folio);
> +		if (!folio_is_file_lru(folio))
> +			folio_set_active(folio);
>=20
>  	folio_batch_add_and_move(folio, lru_add);
>  }
> --
> 2.39.3 (Apple Git-146)

Hi Barry,

Setting only non-filelru-folio in folio_add_lru looks reasonable and
should help with over-protecting readahead pages that are never
actually accessed.

For our workloads that already suffer from file under-protection, we see tw=
o
sides here: on the positive side, keeping only actually-used readahead page=
s
in memory could improve performance; on the other hand, since we already
see file under-protect issues, it's not clear whether this change might
exacerbate that or even hurt performance.

We'll test this when available and report back. We hope to have a
chance to discuss this topic at LSF/MM/BPF.

Thanks,
Zicheng

