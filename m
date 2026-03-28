Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7E8B10BA434
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 00:36:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19C856B008C; Fri, 27 Mar 2026 20:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1272D6B0095; Fri, 27 Mar 2026 20:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 014DE6B0096; Fri, 27 Mar 2026 20:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1CD16B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:36:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2BD398EC4C
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:36:00 +0000 (UTC)
X-FDA: 84593604480.12.ADB5CB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9F67514000F
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:35:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y9qLy03L;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774658158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lBrT2ULZpMuSVHKl+0A+w7fpA4GdJsgINzXYejhUBGY=;
	b=B7eIvHbW82bt8/dU4F6fbVCUXeIF8SskaMue2QAMgrhN+ANTf8DcxalPy1LmNQ4bnnBDO9
	UlRsLwQVMxt+dhfI7V6p4e+BMdjZ1etUuF581Y8VG/rOp8AMKegjs/7U0APLGXeoVaabPs
	BDKcmV0FYTiJxa3gRrBqM99fa5eAY94=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Y9qLy03L;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774658158; a=rsa-sha256;
	cv=none;
	b=t/bMzic2pXPNoBctO/DRtQTdnYQUV+XlIqt7bvkifAc7JqCY62G/OHZMHjblopUV64ZmOJ
	ZYOqP9IsL0mNvd//L7SmRFI+qxyHTdyL2+F0qriuuIHskzWE4YmPL48+2mByWCEEvWM9qb
	YFYXLimZHosVfTkQzkwkvEemo3/OH3M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D831E60054;
	Sat, 28 Mar 2026 00:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43897C19423;
	Sat, 28 Mar 2026 00:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774658157;
	bh=h6Tk7IjG9yZpu1BCQvPI6noMo2JTbvhpbbfGx73+Odo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y9qLy03LKdAX10P3aoEQWYcqF6NlkNuAQpyt1wsdHQWKl+BVtHruV+Nzy90HZ9J6x
	 qiXx3d+thuu+aBnzGrAASn9DRzDzP2Vih0F8qWq9MlbES6avDEX3+4oEJIl9UbTAeE
	 w0Op9wanwiAuB/InG28i3FAH9II8LhoOFkhJ5DZ0=
Date: Fri, 27 Mar 2026 17:35:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, YueHaibing <yuehaibing@huawei.com>,
 Mina Almasry <almasrymina@google.com>, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: restore reservation on error in
 hugetlb_mfill_atomic_pte() resubmission path
Message-Id: <20260327173556.8feb91aa8b40d2510a20de09@linux-foundation.org>
In-Reply-To: <20260322052120.14021-1-devnexen@gmail.com>
References: <20260322052120.14021-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F67514000F
X-Stat-Signature: e7upn3c8qhqdoxuy99i7zqhg6otq6abn
X-Rspamd-Server: rspam06
X-HE-Tag: 1774658158-829612
X-HE-Meta: U2FsdGVkX19u95Nw+MZZMb74uuiKURu0975Oc8P6Xl1Qo6C3scHZmWg1VT9Apx82bwx2+MZPgOREvwWvqKQ5LWqi3B7K6Fh60nlxR69+G0H2i1XYJuEOm4ooRRdrPVp0h+l189QtGNYTMKs20za+4oCm2muLgg8Ckb+/9NciDqOE73sTBZ0VsrgiddHAHmx+tqCS01ZaeitaYW0fuvdZd4XQsWSQXWHbcMC9+l15uoWuw7kumj81yLL/4j35gbd6MJPfKiKq6czCMyvPOqobu4j83UCKR6+3BGliYim/C4CaElUyU1KDaquex9Lq3HvNp9fjIYYjVaGcyG803P5+c06Q9F0yUk9JzgrKUqVqP2dpGDYgh4auB/WMIbiRx130h/qToFxjypwXRtKUKrfB/H8FcwponmLUAU2ZH98HNzGwZiu8SbDLoxjKpBwktxFfB3IfbAoDfYerQeONQBaegADKRhPmKvemtPvFfl6sYwtSecMw4TMy57MO7MRBs9sSEWu1XhCfY9JeEXTXtRHpbeuU/nK0UACrKULuUQCap3Z6/oqCauAdvp+525VKvTLaYOPjfFiFe+lrScNhdOyPS2jTkAmBJaZ2hSUV0u5LR7itzzLbPceRozzS8pA+1lgxC756NxTf0PwG+RZxTyKGl3z3tn9xQttBNQcQTktE4FN0DgPjqgdosY0G6c6pQIYR7mt3UwunhiZW7hgTVL0DOrxaPhfY+hAvqJOwYfBi2V8DKrGgkHlP3vnkI59Ao1j7+z0Y06yqfWe+Jhb6RjR1IbtizoPDywFmzoI5gGrl924aJCEXAsgmoTa1stXei7tv0/nHEANZGhpWt+w7IztVS20mmJL/f2TXm5/VNVZThRbLdHJs/RuwnYaJqkkZDomCKYw8Uubqgf7rU3gDB6TiBFLOK+XzJVCH8uEXefDRpwJOmqdCDkOMXKYTGK5ztg0DCXTQ+QSyNCq+CbNRVaJ
 M+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 05:21:20 +0000 David Carlier <devnexen@gmail.com> wrote:

> When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
> hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed. If
> copy_user_large_folio() subsequently fails, folio_put() restores the global
> hugetlb pool count through free_huge_folio(), but the per-VMA reservation
> map entry is left in an inconsistent state.
> 
> Add the missing restore_reserve_on_error() call before folio_put(), matching
> the first-attempt error path which already handles this correctly.

Could we please have some review here?

> Fixes: 8cc5fcbb5be8 ("mm, hugetlb: fix racy resv_huge_pages underflow on UFFDIO_COPY")
> Cc: stable@vger.kernel.org

And agreement that this is desirable.

Thanks.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 88009cd2a846..d6ea11113f1d 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6295,6 +6295,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  		folio_put(*foliop);
>  		*foliop = NULL;
>  		if (ret) {
> +			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
>  			folio_put(folio);
>  			goto out;
>  		}
> -- 
> 2.53.0
> 

