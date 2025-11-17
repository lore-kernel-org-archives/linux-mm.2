Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A67BCEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 08:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D9A38E0005; Mon, 17 Nov 2025 03:27:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0DF8E0002; Mon, 17 Nov 2025 03:27:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EDBC8E0005; Mon, 17 Nov 2025 03:27:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2AA8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 03:27:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C4022C0B95
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:27:52 +0000 (UTC)
X-FDA: 84119420784.18.F0A8F18
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id ED7CB120006
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:27:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/NCxRXU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763368071; a=rsa-sha256;
	cv=none;
	b=MqA9bcQpHkIVGBRAXPQKqUm9nNfKC77xlNb6suMPhAILw55ZX8PW/BMq8nKgUC3XmhJFEn
	Gie54uBemOGrtOP3TSlEsCOHMPD1wJ8U99YtW53UeO+y2MOY75T0OebxIjqPToUC1Y5QVP
	M5yGkOa2zlfErwR0tGLhcbc8HHfeUmM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/NCxRXU";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763368071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GND20+0Mmpyw4zdDpL4VRtyrLXIbMuGUmWIjNw5QtAo=;
	b=Uq855cCiSUIEbgDibkM4LVpRUsMaDiE/W/m6ronV8/3/9mQhXMJfRxiLVLi3+OHRcbSTak
	f1Ka0QjU7572/Yav1D1BAp1b3BWfKp7XY/Du473DZTWOul000y+F4i+Gv4tbcX3ALpC13v
	W/+1NGAIHw/u5sCYe43GI8F9IQGW928=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-880570bdef8so39731676d6.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 00:27:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763368070; x=1763972870; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GND20+0Mmpyw4zdDpL4VRtyrLXIbMuGUmWIjNw5QtAo=;
        b=Z/NCxRXUa4nO0gEyQtY+k56Cu2KOGHwQbhdKW55P08P6LPqq7KUr3WAGn3lLVSD8+/
         7Wi9IlkcZTrLsBTTvUUIgA+NJICck7S+/wiNnPKtB4GaGxrrKXPqHq4MXAQrHyPVI/v8
         C082tRs0lyq+hSBC4yu6ciPTJMk6Jk74EjiKc9o3smoCJmMkVMH3hWk2PehXM+uL52jI
         GRzCo0g1K2937NajDoJNUt5PQSpk3PBaf1bz4ZmD8pdry0cjeiWjnx1g3wogY5FeHNQy
         ZiI83+h/EomFCN6ikBxS5GXLz2BTnDXs1N2LyBmboYliIGuepp/BCQgDriSPIGQcYCLg
         Gm1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763368070; x=1763972870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GND20+0Mmpyw4zdDpL4VRtyrLXIbMuGUmWIjNw5QtAo=;
        b=LCFMk03IWPzxY//BFz+FQma7FMpcB8Z553SsNtFqesx7IsPXqI+jj4n5Z1+sPmBkU8
         yZUgRbp9LqJi6Gusf45cTsTH0lDQ6Vnb3yqmpZ4M+yOwsA17ypzy2c2s50YgLqJ1O1w6
         09qmJsYOiUf1706cFnzlmo3vbEP7RVdt8YSb/GMCa/El3j8m/YRXWKgPw/9JxE9RIFCQ
         h+Zq+FTXv4GbCd47jRhiM1xeKWHeE0OS/8pTYUUm1azNfnid8tHAGDtgF8u7YchFknSI
         d7XWbzW7pOLDXPZAk9ZHFtQgZk88XxhUdwcgsSFIzJKPrGDLLaC6Deo+RfoIrbgxEsUx
         Q0ug==
X-Gm-Message-State: AOJu0YzlnnqQ/RcmO3t6POFsSgJU4cYoylNqHfYRhyD/S+Suhyv0f1Pd
	HnopbKettTNl9RoRC6rI/KiziBW+onorZGw0tWquIaZA6Bdph6XqohK4gLBSBkotHhwUnQ02OOJ
	Ln4BKfM0eGJbXHtb8NbmLt6r1372hATM=
X-Gm-Gg: ASbGnct/dinWT1mr1AuKgarg7n/YFTgJOtbrgeOdjjvP9ANGoNvkx1MzyLxonynZUES
	2xKqBFTXt42nE+WY2DI4Nb6166Tpf4uYbCAAYbjQ2A8Vx0BA93law2IDno6Ohpmcvx3PxYj1gmI
	Qlf++n/ecYo4edtPg41/j8BMCikUPte4RWeg5KU0MQ1nOtfmUTE6+PdqlTuFvmAG1BOu/g0C0EB
	u8q/SU2waSxNC4vXGNstnv0VAjgQe3aUhbpp8cRxlkDN/Sxyk+3GPlC4lzow8x01ApWTCRu7CAZ
	S8Ik
X-Google-Smtp-Source: AGHT+IEI3TdbG4BeHitiknf6t87SsJf4IZo33I+9ElgJiDYVSJ02trHza6P+cgIbNS6CblJ6nvUVfTqlBHfalQyth9c=
X-Received: by 2002:ad4:594a:0:b0:880:4eac:8689 with SMTP id
 6a1803df08f44-882926b1015mr202109406d6.57.1763368069868; Mon, 17 Nov 2025
 00:27:49 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com> <20251117-swap-table-p2-v2-2-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-2-37730e6ea6d5@tencent.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 17 Nov 2025 16:27:38 +0800
X-Gm-Features: AWmQ_bnPS4HEt9vqQL0zbiROCUXB1DHUHxb2lEPPWXqZ6I99bNw7guWJcIGCAu4
Message-ID: <CAGsJ_4y9sQd9x-kOqPZzaNPTtSOhFSYzFdjiRsJFjT2myYEK7w@mail.gmail.com>
Subject: Re: [PATCH v2 02/19] mm, swap: split swap cache preparation loop into
 a standalone helper
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ED7CB120006
X-Stat-Signature: bkxguz6oiyg4xp46abgd8ck1zufr8xi5
X-HE-Tag: 1763368070-739885
X-HE-Meta: U2FsdGVkX1/bWJSDWq0Cq3MipHzEspnt9rhZTBg3dwmsA1GvoEMq7CV0RvoD3t9scOfa0Vp7+oEYPoXWYxFAUrNaJL3qZ9i8hr/QU0TslpfdXv7nQ3NN6k1CJZSLAA1XFpmN1BDXMKif3pqobKCrTc9qr7TfDGR5eqct7cxcbP4birKyTaZYpv44sZrlLGkg0e12iuOVEmvu0Z/l1xNUzTjU4BQyzoihjOEv1xOBJSmuXn3jlrHBZHIOlL6lHjwZ5JqYMBvrBHDhRsYVGSBG8+U4YhJpiV103jkhPTvFHbM6+uep5YlCEkjhynEyAfndGUBdYmvhoifvb0Gzt+dJIFfr/n1G3N/6iTF3OvzZ0kCY0Z8mxJmdHaOZFHmeL3rbNJWI/i1fxfsG6vJHkIrekZ2x3Z8VI8TS+1JDoG39UqRhqxuy+4D2p9V4Clf75jUbw97+NPoF0tXGTaeb+cHqHH2Erx4ys/lNOTtHm6zHtoOOU0Cx+D2N9AVusDFEXmn4uiZdVjUhSYZCIdciHBJyRvUQ/ksAV0n278RKW9+KvqWQLvcAjZ13BxS56ERPWr9JWjwcHifIYzogQGOCPgjDUux1F/FSVjVUp/hrs+MrkO8ZWhlucJRvTgYuW6uaDuXsbuOozbLQJP7aCnUcXPZZSmkA8fpzhCDd2/rbY/3Ujln1y1Kx4V5iOq0MCzZyV6GCb/VObkdahqh1V+PuQ6jbIg3M6vPaX3YQnQDg/mi83SgnLeDk5uuP20dyuLOF3RDLZ0KT22tbqUGXEuGo1j++0ZCDCrSrwvWRoh5keHX4/evyQTKKzYdj0pVh67sansUspVIlU0ygX84aTkNv4JedW/i+ZFPC5wzT+YmhT4QtOdVu4eu6uphOnLow4ret4Ca6e0RD8iKCOCvf4vMwqwPjZd8XepBRhIP1ZEPE8WQeWt71rf8xal/lNuG8/1XGi9bux6hYParMWklOgPmNWNB
 L+g7TmHe
 sXLpZ8FsXKot2xO6FDQZ8aQTFsKk2yvbBmiXE9VGOy7N8uinvRTJVVojJ2WKm2r60qz2fe8q29jK03xThHtlzYMRODEI3AClyauucTMBWX+mE39mJO5kBXKrQpoTAJpNRDijNYJoeKv7DemvOd/A0mKDZ5lEeICAZnTYcMA7a2ZLlXmp3e1D9uFuc9V2GIPnsComZrB8eT9O+xOQuN1fRAm4JSVM1SoDvtjUtr6o5w7LQbI5Lv0pxD3B1mjm1Him6y4iuDiI4YkOTySKRujiEN60z1CCsLGrER9t7H8GPV+0h/zc1R5ZvctYriFv5pgpxbWPptagEFenxRl5vki81zw/QS+n5kMVIHki7p/5wd0PFMlV3da65tTWIoIKtfn+8FMxbtU8K3RNbOVm/4Ok527FzW8emq9VF5oI80uJOFaY03jg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 2:12=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> From: Kairui Song <kasong@tencent.com>
>
> To prepare for the removal of swap cache bypass swapin, introduce a new
> helper that accepts an allocated and charged fresh folio, prepares the
> folio, the swap map, and then adds the folio to the swap cache.
>
> This doesn't change how swap cache works yet, we are still depending on
> the SWAP_HAS_CACHE in the swap map for synchronization. But all
> synchronization hacks are now all in this single helper.
>
> No feature change.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Overall,
Reviewed-by: Barry Song <baohua@kernel.org>
with a few minor nits.

> ---
>  mm/swap_state.c | 197 +++++++++++++++++++++++++++++++-------------------=
------
>  1 file changed, 109 insertions(+), 88 deletions(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 08252eaef32f..7b93704fcbe7 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -402,6 +402,97 @@ void swap_update_readahead(struct folio *folio, stru=
ct vm_area_struct *vma,
>         }
>  }
>
> +/**
> + * __swap_cache_prepare_and_add - Prepare the folio and add it to swap c=
ache.
> + * @entry: swap entry to be bound to the folio.
> + * @folio: folio to be added.
> + * @gfp: memory allocation flags for charge, can be 0 if @charged if tru=
e.
> + * @charged: if the folio is already charged.
> + * @skip_if_exists: if the slot is in a cached state, return NULL.
> + *                  This is an old workaround that will be removed short=
ly.
> + *
> + * Update the swap_map and add folio as swap cache, typically before swa=
pin.
> + * All swap slots covered by the folio must have a non-zero swap count.
> + *
> + * Context: Caller must protect the swap device with reference count or =
locks.
> + * Return: Returns the folio being added on success. Returns the existin=
g
> + * folio if @entry is cached. Returns NULL if raced with swapin or swapo=
ff.

Not a native speaker, but I wonder if adding *already* would make the
comment clearer, for example: "Returns the existing folio if @entry is
already cached."

BTW, returning NULL may not be the best option. Returning an ERR_PTR
seems more specific?

Thanks
Barry

