Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D7E0C87FCF
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E34E48E0235; Sat, 16 Aug 2025 00:33:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDED98E0006; Sat, 16 Aug 2025 00:33:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE498E0235; Sat, 16 Aug 2025 00:33:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B64518E0006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:33:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5FC25B8CBE
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:33:15 +0000 (UTC)
X-FDA: 83781351150.29.A8C5272
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id 883B316000D
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:33:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1fxz52Mn;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755318793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PsRxtwwK15Bg0qbKyAiNtrwYfp9IiiWX2XFwbSp/aNA=;
	b=xE6mqu03dpCZfjShVo6+Byh0h9DdD2pQxWMGYoh9rSsiRf0Myeu5EtWsq+qaloxh0ern1/
	NZ2gi93qTJzwn83L+Jr4dARdL4vErTFCd9K4t+mBJ3CNZlhiWVPLoM8KuCkk/ZRZROMde9
	T8jP9Chl/XoBYyaHQEIqQMOp2xy2BY4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1fxz52Mn;
	spf=pass (imf08.hostedemail.com: domain of hughd@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755318793; a=rsa-sha256;
	cv=none;
	b=8IF1rLSjLrWY4LsTtBt4PstIF2e8+lyKrD0HzV+x5yAsgTv7gguOJM9rXH8S+vZSgjDtqw
	d9KvcM8cXdPF5pH/yRl0bbjRAAFjdwotc3jxJl11Vk9r//ugKeuEWo47YiI0wpv29pqH+f
	lEJJKn2lethq231/uWxk4hh1r+lwdm0=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32326789e06so2158995a91.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755318792; x=1755923592; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PsRxtwwK15Bg0qbKyAiNtrwYfp9IiiWX2XFwbSp/aNA=;
        b=1fxz52MnmT4kqC7Vv36sYa9RSZn0ok1ecmpkgG3nw0UByURsO0tWX27VA2im8/hNqE
         R+boMKof9rlMS2xnXTqdU/x3fYwznJWr7oFri+Pn9PMrmvuW4LUBsYy3Eg6YW70A7+5G
         NhbGnblAEgh0fZKFRpJoRnjSOiY89FRSoxM5AhHuzbOzXknnsY4Ch9lbubNWdPXVQFyd
         o21aJe9fVOxrQJhX2RAV8QoF552WrKesgmz6QTePt1RuvSHqEwTa0vC94meTpkhCCEDO
         oQzkagqPOA7zB0rYoN+w6gt+bE077XhBRZiL6Dvg6ITjryEdFX/yNNHziOPEpH6VGoX9
         KCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755318792; x=1755923592;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PsRxtwwK15Bg0qbKyAiNtrwYfp9IiiWX2XFwbSp/aNA=;
        b=bnufM+j+K2jhi8l90SZW0ryYptXRMNBEuhTvdavuK/ZQMJPJ+AQOFZvEEM3W8NbTg3
         jfwUAOdylcb4fUb0HvO6FEq55Fd8EIkjCHIuh/zK4QBPDrMJm05Y6CF7oBQ1tvMZGY1/
         lRIS4CJw5SinrLEHra1FMYbhdK6KUt+oev140Tg/RD8AuUuCH1fjo1u9EDhc/M6sVzmT
         JL3uBDQc+NsUHmcHfqf5Ast01HNnuFgwZjDknDEDqEAj17TFTusfpuOr1+3WwBEEqtWR
         r+kW+vO7q2ZTkUtHmPCVhvW3KPrgxA+tq0sWcRAidyOURnY7axmjH+qcrkPDxaGgBpF6
         uQlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUao2whD9OEuZn5n2vKjnn6Ttt2pPrL7nPMfMC/UcZQ/L/f4k9GRpm/hPxh/Rg39sYx4C+adOb0xg==@kvack.org
X-Gm-Message-State: AOJu0Ywy+yb80g3S67TMzsEEtxkKS8gYYswABbB+6M2kyBCPr5zlzer2
	NS8Dh6lF/qrCf/rMY+fZON/hNuFzcY8f3Iu/z1VGCZ/zrD09nXHVDY7tLSYONm51Ew==
X-Gm-Gg: ASbGncv5e3yXWYW32BmOtDEEqnAu5v7UHheRxk5yqMA3Ub+IyqhQUli9l4fF2vxUoSx
	UUHGuCy8yvKurXPU+xAXcgISwBN689U/Hlmo/lmU0timxvJZ2pYzRSybvV8S/YLFeUQkiXiAwHX
	NXL856qJwUBecGNFDQjGs92GsF2VeZ1keH1IllnsOpDT0WQZ2GpH3eyiZ4kFPj/UXOCdTTNB6Ih
	aH5YuAtMMdeyf/J1fUu0cSzLmXtVPQCtE9tcHOGbDaIG2n/xzLI3vodetlDPVJIxez/u7oWH92I
	bupoHsLInWGhSp+LKjM3LWOLXgfwDug9MiIy81LcBsQYoJijgEyprCfUT4zDi3NN7mpazQBhrGU
	+TZZAcblbAboGA6yH6u6jm8RXSpcASrO7UxqOs86CZX8WNeMm4xd1X11VYJYtwjy9Lb4ltbcxNU
	WegEks8OdoMt2WPA==
X-Google-Smtp-Source: AGHT+IFRvkHkV/M4v52bM46SWACcSKG/8sC45sXQrlbrPp0hgPn1IBR5PeJOCfpEfjyh07P94QuUHg==
X-Received: by 2002:a17:90b:2d83:b0:313:b1a:3939 with SMTP id 98e67ed59e1d1-32341ed8debmr6549218a91.15.1755318792114;
        Fri, 15 Aug 2025 21:33:12 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b472d794a39sm2619964a12.53.2025.08.15.21.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Aug 2025 21:33:11 -0700 (PDT)
Date: Fri, 15 Aug 2025 21:33:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: John Hubbard <jhubbard@nvidia.com>
cc: Will Deacon <will@kernel.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>, 
    Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
    David Hildenbrand <david@redhat.com>, Frederick Mayle <fmayle@google.com>, 
    Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
    Rik van Riel <riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/gup: Drain batched mlock folio processing before
 attempting migration
In-Reply-To: <ef85aa74-180c-4fbc-8af6-e6cca45eed43@nvidia.com>
Message-ID: <9a406ab6-0da8-fb8c-968c-2b403be6781d@google.com>
References: <20250815101858.24352-1-will@kernel.org> <ef85aa74-180c-4fbc-8af6-e6cca45eed43@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 883B316000D
X-Stat-Signature: rri71sta93pruzb9mkx3ny8gc7p36ino
X-Rspam-User: 
X-HE-Tag: 1755318793-341291
X-HE-Meta: U2FsdGVkX1+XrzuAK/5/RvXI0ebZuSV2Dgaex3FO0wxReE3AirYqYohJdgUu/hTIjvJH5GpG98mvZb4z4QNajl+x5oek2lofzgHdjXhfNfRtyPxdtmtSRyrLZwTCYpVCPCTuFDQVxuupcDj0HeQiJAp46hOtOZNCYcHEG+be9jQ9qn2eFs9nroJ8BE7kQQclN3yr/ksWcJatgLCuGTImTsdU2xXYT2JEOOPCtvzdwwRbsuYMy6ftJpEtJKqFkWaxU9AH7SqHS6erTwEDgg4wnML1j1rRAr9qYL9LJ7G38kI3RUzJY4DjDl8+Z+yrFuzObz5ftQSb0sAl0e5h05MXi52NqdkTQzpDIz4Q+/LqxuDr86lkrOAe9637mTTviuLbB0puO7Rc6ckh1wdrmS04OuBybItzhAf7tKvmYHv18LRNxPYIOLOQjUr0DsS4pDHb/CSkvSxOHaXncV0Xf8VJfOC1q/uxfuc/ENrEIVU+/PLbeMX4YY5/Qpn+rRE2QtDAwx5XDQquSq0+VJYsdCj5ImXeIFr7U8knqhiqhHSKjhkX9vWTPhlkwX9mM3XsPFZSLydLfz3nBC9BUF1xBkG3mXGTclq25EOoNjDLZfuZSvEoKHpm1u4BpTDwKJwo+43lfjrKoqzEP1FN2AbggyEhDl1nQBUodea+cyuuIjqeTv+BzDXyb+yo09n1QHYwHMisXJG52ne+GdLHjzXNT+CfIrQFgVl1HxpF8i5iZDNFtOFvFQvBDGcQ+eUBSPjN6FbWgFmxgcLZXxp/zVMqVs0G4fSa+tff4RsqIFOGWohNV7fu1DTn0d0oIzHwTnM/eN0wLQnpbFUFUVPyOd5QYvOXqCirLgzKi1ovIstjCjiFkSXRFB2ve6AdqvAQ/39fAFRwIGDFhkp4hWw77lWmWPGXJ5JRwZjp9PLUoU4qAuVXoji00LYkXzqL/OKGLqmY7tf4DoSaRbNRmYEfZRmldXT
 vE6nbHTf
 pPH5JGne23XDBzeyok4jID5AQ+2m01lLOv8gfU3ZUD3mlhkCpqTkFY+hL8+OCEwDpUzGy+/+fdqRZJyU/DWvPnTsvAtRhJQ6XQuCRGXyNBcvXSZeAEhFgHTKuUrQWrTkKYGApumNbk89aZQbElG3qyfTO0GTXC6EAuSrS+OFf9mOk4kd04K3mBP/FpE9P3INBGKx4C2mdqH1typnOkDv/fI12oR9pouKl/BkwqEvsVBjubidQWj/XJHQ4MNIh/034CSgqp+fTeqldq7GgY6qDFoAvuOgqjx7197QuU3I5z9ZTM390jkbx7HefY0YQl0a2laKdpqTEGZ49RiP6DEd3j7vpg0XXxXyjDk6O7c3uQf0+Ni1clyIgyddYswk3iR3+r2aVJrajMcuayik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025, John Hubbard wrote:
> On 8/15/25 3:18 AM, Will Deacon wrote:
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index adffe663594d..656835890f05 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
> >  			continue;
> >  		}
> >  
> > -		if (!folio_test_lru(folio) && drain_allow) {
> > +		if (drain_allow &&
> > +		   (!folio_test_lru(folio) || folio_test_mlocked(folio))) {
> 
> That should work, yes.
> 
> Alternatively, after thinking about this a bit today, it seems to me that the
> mlock batching is a little too bold, given the presence of gup/pup. And so I'm
> tempted to fix the problem closer to the root cause, like this (below).
> 
> But maybe this is actually *less* wise than what you have proposed...
> 
> I'd like to hear other mm folks' opinion on this approach:
> 
> diff --git a/mm/mlock.c b/mm/mlock.c
> index a1d93ad33c6d..edecdd32996e 100644
> --- a/mm/mlock.c
> +++ b/mm/mlock.c
> @@ -278,7 +278,15 @@ void mlock_new_folio(struct folio *folio)
>  
>  	folio_get(folio);
>  	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
> -	    folio_test_large(folio) || lru_cache_disabled())
> +	    folio_test_large(folio) || lru_cache_disabled() ||
> +	/*
> +	 * If this is being called as part of a gup FOLL_LONGTERM operation in
> +	 * CMA/MOVABLE zones with MLOCK_ONFAULT active, then the newly faulted
> +	 * in folio will need to immediately migrate to a pinnable zone.
> +	 * Allowing the mlock operation to batch would break the ability to
> +	 * migrate the folio. Instead, force immediate processing.
> +	 */
> +	 (current->flags & PF_MEMALLOC_PIN))
>  		mlock_folio_batch(fbatch);
>  	local_unlock(&mlock_fbatch.lock);
>  }

It's certainly worth considering this approach: it is consistent with
the lru_cache_disabled() approach (but I'm not a great fan of the
lru_cache_disabled() approach, often wonder how much damage it does).

But I think you've placed this in the wrong function: mlock_new_folio()
should already be satisfactorily handled, it's mlock_folio() that's
the problematic one.

I didn't know of PF_MEMALLOC_PIN at all: as you say,
let's hear other opinions.

Hugh

