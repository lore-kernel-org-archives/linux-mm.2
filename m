Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F63C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 02:50:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2296B008C; Mon, 10 Aug 2026 22:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452156B0092; Mon, 10 Aug 2026 22:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368E26B0093; Mon, 10 Aug 2026 22:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0627A6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:50:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5E5F1402FE
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:50:23 +0000 (UTC)
X-FDA: 85087459926.18.6921167
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2275D40007
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:50:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bwZjyn67;
	spf=pass (imf12.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786416622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=acdbH9fKwYoyiG7hBwz6wBMxKJBmLIf01OPkTkxGfP4=;
	b=nIg7Xop6hQpXNE19ML84ZNN4Cmnz/gWJz9fSdVg8YAIVRqEnrhJJqcu7crOf6A4xJAsnwT
	0fktPuu79XItdrh0nMsfPsSmUyYyaY7Jr3mCdpQXSkN6hTM2kRYd8uzrd5aWXrjfGnTxgP
	FfaUN+kipPe11DC6pdElY/UF5IDoKh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786416622;
	b=BaX+2JtGemQXa30eUk3+Mqp4g3a6Xe6uSo8irVqt05GEMRrCQLet8B+jHUkfWbxLXJpdhh
	ECE0/OfjEUOiAOUuS2aQydja24sHG35TudWgq8VcMX4e6QvI1FeGKklotd+207/wnfL1rC
	btgmSz1AYzJYhqD7PyhMcCuw7jQbINY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bwZjyn67;
	spf=pass (imf12.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ccdf36f63dso32925ad.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 19:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786416621; x=1787021421; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=acdbH9fKwYoyiG7hBwz6wBMxKJBmLIf01OPkTkxGfP4=;
        b=bwZjyn67OntPi9RwyuhlyviRFzMqmY9aQTFGscJn7K2prZ6XzKMMKm6lgbpbmAqnUj
         9yq70UhLwAffhqaAnuf8DfoiAWLLqm/sIy4xI8FL3EfODpZmFp+T8yHM+IsQ6kNpJgHQ
         iox3oyZAJ5yyMMn6vBH7OlvwgFtJQnj4XsSHIkKKEKSf7lJawJB4opHCX4qO5CdT5sDx
         wmFX+GoJMSajiO9P7KNUK4tPoA9KKE3BZtlbkATYbObZ0KMfrrxU0XiFzS9Kr7xfAiN/
         TT98WHzl60gZZ9g9hrEd6Fw8h0J9DiZlt5Gz+tuTzBpBNqVKXeLxOSzWDXz//RBp/wW3
         6vow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786416621; x=1787021421;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=acdbH9fKwYoyiG7hBwz6wBMxKJBmLIf01OPkTkxGfP4=;
        b=NF8Yl3HKSUSDrusLguKFRTbdY6o3o4fudclyIR9Go8uAhcycjEWxpCbTQUXvNxDuSJ
         m7H+m2zUSakdMQg7fw7S/0pNkDFsvmL2I3IDqy6ktneO3MYkS5T6tChdmf1gOJZIEoaL
         PCocWK66tKqd5PGva9l0Vcbs4XO0FBfmG7TTbVcHzYQGmZkKuYzZ9lXHkYexvFyiv3rC
         EUbYdUGr9IaP3GpI/UEX+VGP8qVytFL1N+/wAYYSoXrZL6E+maVIjGkJ7aeImMhyL2cx
         ZnCak7cjS3bMbpdDeZ9v5s9f+nLz3hFXv6KDSiLfJyNVuu2j369qtw8Qqmi7S96uajqL
         0dFQ==
X-Forwarded-Encrypted: i=1; AHgh+RrPX627aNntM8vlONXjI3rYiB6AF8k4JJxOwZZi5d6ozCWTRU+kK6TbhAQhSmZ07bfMdWZ0P7zW4g==@kvack.org
X-Gm-Message-State: AOJu0YxY5MgHlKN5NclSlnXEdz+mVwzIZx1okZ1VsaLBI7mBrH9OLKEH
	Bkq3mofmBJm2VaTX/sgPzPN2cjcQMPu233vnWJfEklGs35xwLtECRnNnUpstBFc5wA==
X-Gm-Gg: AR+sD12XLsydrnTDpn9h1rxVWUDpZv9GCtyegEwEeAd/xx5ODIaFXJQOU4cnBDgQrBb
	78qOZTQdOf2SIUIjtiKMAMW4cH0DfyFuLV5eFdvE/eriiONT94qGiDgX1HtcpWfvZiFLO1JWfU7
	SzHrSxieTv9Y1fpWrUmLkqhlfHmVxd4Iheq4NmoZq4c8ocKahBBCQLlnOpRbe3py+5I0ZcxzJ3I
	CJwb9Xblg54GsJl1NGIOPg1XQdJIlrGBGQ6u2xMU8Y8i/ngEDQwdt0o3YL7t6iWW4QwV8c/K6fu
	TjjktKAGSxA+LoyqzFKeRJFSRbFX7E1w4DyzUBGi8jHf+2oCrtK+PdECXAghAEGkYtoeH82nKeo
	+gxAfTVH02Re8+iyVKnL7SABDwy7TeMd6n4ou8QHzrLeYYkH+prYzUgfGRRVpBGP3y63m3JF1QQ
	ApUq50GhOM79PkkrT3Qi/KmaXAVu9SOW/rcALn97Vsk6dUEY14s7d6s0sCR4h7Fqnh9RyAU0feN
	aeBbnWEwjXpYNEfckhgTS3cO+x2uTF8QUIp3A58ZBBUQUHLauUUHm6VWlZbEJ4hZLZ+r1DrI84c
	LTeKLCjF8lIk7DEcXqjgO7G6ztizFQ==
X-Received: by 2002:a17:903:37cd:b0:2b9:e831:5e5c with SMTP id d9443c01a7336-2d317208d60mr481185ad.4.1786416620399;
        Mon, 10 Aug 2026 19:50:20 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d315ef11fesm540535ad.5.2026.08.10.19.50.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 19:50:19 -0700 (PDT)
Date: Tue, 11 Aug 2026 02:50:15 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, aliceryhl@google.com, arve@android.com,
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org,
	davem@davemloft.net, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
Message-ID: <anqN59pDZEEcz1vd@google.com>
References: <20260806200548.3124802-1-surenb@google.com>
 <20260806200548.3124802-3-surenb@google.com>
 <anoZL76y3WGXMArB@google.com>
 <CAJuCfpFCK5ycO6s+dD35YtU6zgNdivfe6P3cVnd2VxPYfGXHDQ@mail.gmail.com>
 <anojoFPijbCloUXL@google.com>
 <CAJuCfpGXBTRUUtCCpLPT9v1LZA6UHo0yM3y68Kwhxs7S03z+5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGXBTRUUtCCpLPT9v1LZA6UHo0yM3y68Kwhxs7S03z+5A@mail.gmail.com>
X-Rspamd-Queue-Id: 2275D40007
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hdshhfk89btbniyee1xxn4f44k31uimd
X-HE-Tag: 1786416621-933108
X-HE-Meta: U2FsdGVkX1+TfGL9aF2Kkjl10fzA/YyDlvgRINF2GwSVl3oaU2OM7FDUqQxddteXPBreBulE+neijFOOjGEF8FGF1rtfqrxJj+qDTktqijP9HYZ9qTHNYxFIw+Eu8HmMOoRyYKcfyzW5VzSHMSl16lYrM631W8KCQvDdtiKs6ObsMLVH3tmidBCVNF3PdFvxBSnfbxa3qoA5yi3U91dOgrQzD9EGYjeMA9PKQfiDre3dpTyINHzK1QdR1KgAmSKb521aDoR1D4DRJ9j5lVR84QPX5d07vq7dupFZ3UFDIzchsXL091nLi8p/98iwp31frzm4U2Y8GkNJUZclU01EEdxADlkyfVRRLoiV4agvmNLp+IKBKaQLMg5Nt4qUZuz/vtgsmjzT7ScM6821sH+nvdMGn5u8fbBJy6XFrbMklHlmnRELBvoeWBn3uWHpZOnJCI7aqUOVPso4wy4/Xzhn3O+bkgzvadzWsVxtkiLYabrIUl0FZEF+Lt8xhDwtzaMMAyKVp1SdWK5yUe4Pof2LW7KkYfV8DZyw2Xe4QHR18A4aLNHNwV19zggk2weYOeLElSFN03ZWe+Dd5mD17SbotRD9J5DuR84YSWv2z6mjLib/m9BEO9WQakDAMMsSfqhFiU3EMA5PUxz33E78JQVeT7jUFw0Z32m4GsDwe245uRLYHbDIi5PDa58WQgRYl9sD1MKhBczXwS9OmdT9mfz4o1fZvlB5UzSuw8V4EpGYEcxbt/feFAh6+I9Na7Tp4OmuG7jb7T2kloiSmYVaXjoMPeQSjCbR4ZIr8Y8EjJSGxUODDeB6bwLOgoAD5P25ILVQBhSrlWuSwXTvVVkk59myc2kzIKuTcay3N1fzmyiLiZ8caaHE4LBYW5oQQFylFZkyYyM3Hxe4OUe9qFyO4G5QZ6gD8zsgaR/J0j2hGHfq1f1TLj60AISbuRNs11RndN5cQgpe6o7gviEdde4w9yl
 CWSa7AaH
 6cmZsSbUvV/IDV+3TwgUkuKFskW45Jdz5Ru5Mk55KCamccsbdY7cO+LyuUxCeqbeWWQwQ8eE0kfNNBk2bCKXz9yl67+olZKDBexZs1smwoPlBhBUxkYJGYN8Q/cvDTWohTOxhTkO1wj7hRtVlwSqeBS6sX2m9DKsI68VzBfe9DPk6IfUXaf24elwKLeYXkLISDl66z1eKZxgi8JRhl6jNd+U6Fp6CF24twE/f8WFE0eW1ndEMNcOcho+GcZWfZQKu87bYZI5fW5oxkB9Cyvb0OVhepC7SaHyMX/i9fmx1mQBncuFAUzIBSgL/Ns4dLLI1gDBQxn1IIedSEXnNPw7u8oOBTTpUsN7WfKCGEgfLgglBv3WRROTsFUr6AVVyJUhBzt/xPvXyoLr5fZWgC9r4/63iRxPL14H+aIfBTgacLGj1p6Swxfu0Evyxo0xZEwA60PPqGKytXSSJTu2afckHL5XDvKqfmsQa2ju0HcEtyeoMKZwchxHB4bOsv8LKktzv8Xq3pK2i+w+Gt890Sr/YV1xtnOSnjIEXEBFVaxpl/7J0RdIJyEjXE2oD3g5GdG4W3GE2MGnzwVo34qX6RWp8YGp5ya40XmPFwGLY6js+NnL+mTdSCGaqup9JxNHEskqHmcQUEzVEhiNwjMrqvUcdKnYXkVYiOhokoKu0nMCclRM23M2ha0lPy3pE2pFcZwRyBfzfLTwrhwOY876ZfW3BZ7x3rZbiX692A5yWn0Lt0Ua3EopDvDOen0296IOqqR1IG4kX1Iv8sOdVAsupEFn87cPNwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 02:00:14PM -0700, Suren Baghdasaryan wrote:
> On Mon, Aug 10, 2026 at 12:16 PM Carlos Llamas <cmllamas@google.com> wrote:
> >
> > On Mon, Aug 10, 2026 at 11:54:04AM -0700, Suren Baghdasaryan wrote:
> > > On Mon, Aug 10, 2026 at 11:32 AM Carlos Llamas <cmllamas@google.com> wrote:
> > > >
> > > > On Thu, Aug 06, 2026 at 01:05:45PM -0700, Suren Baghdasaryan wrote:
> > > > > From: Dave Hansen <dave.hansen@linux.intel.com>
> > > > >
> > > > > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > > > > it and mmap_read_trylock().
> > > > >
> > > > > Long Version:
> > > > >
> > > > > == Background ==
> > > > >
> > > > > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > > > > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > > > > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > > > > support for the per-VMA lock, but left mmap_read_trylock() as a
> > > > > fallback.
> > > > >
> > > > > This was presumably because the per-VMA locking can fail for several
> > > > > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > > > > to mmap_read_trylock().
> > > > >
> > > > > == Problem ==
> > > > >
> > > > > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > > > > essentially already a non-blocking trylock. The main reason it fails
> > > > > is also the reason mmap_read_trylock() fails: something is holding
> > > > > mmap_write_lock().
> > > > >
> > > > > The only remedy for a collision with mmap_write_lock() is to wait,
> > > > > which this code can not do. So the "fallback" after
> > > > > lock_vma_under_rcu() failure is not really a fallback: it is really
> > > > > likely to just be retrying in vain. That retry in an of itself isn't
> > > > > horrible. But it adds complexity.
> > > > >
> > > > > == Solution ==
> > > > >
> > > > > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > > > > will not persistently fail. Rely on it alone and simplify the code.
> > > > > The removal of the fallback does not affect NOMMU case because binder
> > > > > driver depends on CONFIG_MMU.
> > > > >
> > > > > Full disclosure: I originally tried to do this with
> > > > > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > > > > trylock semantics. Claude caught this in a review and suggested the
> > > > > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > > > > I guess.
> > > > >
> > > > > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > > > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > > > Cc: Vlastimil Babka <vbabka@kernel.org>
> > > > > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > > > > Cc: linux-mm@kvack.org
> > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Cc: Arve Hjønnevåg <arve@android.com>
> > > > > Cc: Todd Kjos <tkjos@android.com>
> > > > > Cc: Christian Brauner <christian@brauner.io>
> > > > > Cc: Carlos Llamas <cmllamas@google.com>
> > > > > Cc: Alice Ryhl <aliceryhl@google.com>
> > > > > Cc: "David S. Miller" <davem@davemloft.net>
> > > > > Cc: David Ahern <dsahern@kernel.org>
> > > > > Cc: netdev@vger.kernel.org
> > > > > ---
> > > > >  drivers/android/binder_alloc.c | 45 ++++++++++++++++------------------
> > > > >  1 file changed, 21 insertions(+), 24 deletions(-)
> > > > >
> > > > > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
> > > > > index e4488ad86a65..c13a588c37de 100644
> > > > > --- a/drivers/android/binder_alloc.c
> > > > > +++ b/drivers/android/binder_alloc.c
> > > > > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
> > > > >       struct vm_area_struct *vma;
> > > > >       struct page *page_to_free;
> > > > >       unsigned long page_addr;
> > > > > -     int mm_locked = 0;
> > > > >       size_t index;
> > > > >
> > > > >       if (!mmget_not_zero(mm))
> > > > > @@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
> > > > >       index = mdata->page_index;
> > > > >       page_addr = alloc->vm_start + index * PAGE_SIZE;
> > > > >
> > > > > -     /* attempt per-vma lock first */
> > > > > +     /*
> > > > > +      * Attempt per-vma lock. This is essentially a
> > > > > +      * "trylock". It can fail even if the VMA exists
> > > > > +      * for 'page_addr'.
> > > > > +      */
> > > >
> > > > Do we need to explain how lock_vma_under_rcu() works here?
> > > >
> > > > >       vma = lock_vma_under_rcu(mm, page_addr);
> > > > >       if (!vma) {
> > > > > -             /* fall back to mmap_lock */
> > > > > -             if (!mmap_read_trylock(mm))
> > > > > -                     goto err_mmap_read_lock_failed;
> > > > > -             mm_locked = 1;
> > > > > -             vma = vma_lookup(mm, page_addr);
> > > > > +             /*
> > > > > +              * If the vma exists, we can't continue because we cannot
> > > > > +              * remove the page from the vma. However, if the vma was
> > > > > +              * unmapped, it's okay to continue.
> > > > > +              */
> > > > > +             if (binder_alloc_is_mapped(alloc))
> > > > > +                     goto err_vma_lock_failed;
> > > >
> > > > The comments seem redundant, the label is enough. This works:
> > > >
> > > >         vma = lock_vma_under_rcu(mm, page_addr);
> > > >         if (!vma && binder_alloc_is_mapped(alloc))
> > > >                 goto err_vma_lock_failed;
> > >
> > > Yeah, for the binder maintainers what's happening here is probably
> > > obvious, but when Alice explained the logic to me, this comment really
> > > clarified what's going on, so I added it here. If you insist on
> > > removing it, I'll do that of course.
> > >
> > > >
> > > >
> > > > >       }
> > > > >
> > > > >       if (!mutex_trylock(&alloc->mutex))
> > > > >               goto err_get_alloc_mutex_failed;
> > > > >
> > > > > -     /*
> > > > > -      * Since a binder_alloc can only be mapped once, we ensure
> > > > > -      * the vma corresponds to this mapping by checking whether
> > > > > -      * the binder_alloc is still mapped.
> > > > > -      */
> > > > > -     if (vma && !binder_alloc_is_mapped(alloc))
> > > > > -             goto err_invalid_vma;
> > > > > -
> > > >
> > > > This introduces an "extra" change. We'll now release pages without a
> > > > valid vma (e.g. after munmap()). Before, these pages were expected to be
> > > > released via close() in binder_alloc_deferred_release() later.
> > > >
> > > > I don't see anything wrong with it. However, it does seem out of the
> > > > scope of this patch which just drops the mmap_read_lock() calls. Or at
> > > > least I don't see how this part is necessary.
> > >
> > > This check came from this discussion:
> > > https://lore.kernel.org/all/anGrFIYiPhjxWSkD@google.com/
> > > It's added for consistency when handling cases where the original
> > > Binder VMA is gone.
> >
> > Oh sorry I missed that thread. Yes, I agree we can reclaim these pages
> > earlier if really needed but my point is this is unrelated to the change
> > done here IMO. I couldn't figure out why that was needed.
> >
> > If you are keeping that in the same commit it's probably worth adding an
> > explanation to the commit log?
> 
> Ok, I'll amend the commit log with an explanation for this change.
> Are you ok with keeping the other comment, or do you want it removed?

Ok, let's keep the comment. You are right that it is not obvious what
the intend of the binder_alloc_is_mapped() check is.

Thanks,
Carlos Llamas

