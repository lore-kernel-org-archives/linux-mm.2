Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77862C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 21:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1066B007B; Fri,  1 Aug 2025 17:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA12B6B0089; Fri,  1 Aug 2025 17:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB6A76B008A; Fri,  1 Aug 2025 17:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C54C6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:47:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0CE880536
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:47:43 +0000 (UTC)
X-FDA: 83729526006.26.5FECBBD
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1596C140002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:47:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LwiVmyq0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754084862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzab8vfejFy6BGVYexdP79Amr1wH4zaNM7RRQ0cASzc=;
	b=ZCbCXIvYuVnqQt6HUyMHpLG8356OYK6/fo0kzErsnwrleieP1kMzle9WuP2hb07+SqSRhX
	wmCVZDFYN9AYZ/AlA6BTUYzhH0bHWkE9duLdobjtv2rRcG40KmgtXpMrSxS+V4E/NzUsSb
	3sOYDnVHeBUaiQVVnQFfQQeGgbmdG1k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754084862; a=rsa-sha256;
	cv=none;
	b=y83JCdGQJJYdkl/cdQ82p7uxD1oe06mb/HPJlZRBk9Wf47AOFgcHSkZZ4mPEC+H033E25Q
	Nfwe0EWQ/6cHvNCKZlTi2Y2iIuFm8yn1yId8MkMIsmQnLVvRVYMHaJ2m52nwGGjhHcvT0d
	DhoRX4Dp1MTiVl4BSJNNQalREt8J798=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LwiVmyq0;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ab8403b6daso22506471cf.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 14:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754084861; x=1754689661; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzab8vfejFy6BGVYexdP79Amr1wH4zaNM7RRQ0cASzc=;
        b=LwiVmyq0iOjQFASYbgVRGPQCxR96VBkmMGtRkEZPAK2pTm8arEcfIqHKjCzUZMzlSu
         YnQPhtzN8CejLxO9Xisppsuhu/jgXXzpI54TRZ6/8P01NZlscah085wiMeK3h0PJP2Xq
         BYfttBlSdHMOJx8VK6o0iiu6aYnvJKVu5rWkyThnwebOb3oSaDcHZSveDk/5chwEWHri
         xtaASmWBQzuuGkxdOw150Xt4xB8SlgzSYztqAuz4DUdF17YBkYq8wRXcTNKCaldupB3/
         5mlv2YOOqgvWQRm5IC+rmEZ3s+WugxDFZztuV7DwPrE///R32HB2slK6+PipzuCCIu8P
         eLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754084861; x=1754689661;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qzab8vfejFy6BGVYexdP79Amr1wH4zaNM7RRQ0cASzc=;
        b=iLMbYz+lj/OWQzJ/iyw2m+hIHAUy62D5nbjTXsAF0f2pFFUYd04ZBTm8xGwJq7tOCY
         TpjZ7XurguU1F5q37bk713m54JmgA6MgreH0pZnGfZ2+gI8Q1TJU1W+VPqwYUIeM9Zbg
         +gmMUkDKdm7lbdZnGCslkhtnz7lBJ+JsMhQhM0FHUYbytcPSC8r+2aUC5WbwQP0E3WZm
         qtvE4K9h08CYvuOUIDAeqerO+Gj4QLTu9gZAqtEvNUsW0xNt8fOu4RO4b42gkifwBLa1
         VSPJes+wUH/oTboMuYjUd+bT/+HQVaRBjRS2/pw+gim2bGReVDBp9Aj2qfMhtx0q+jry
         QVwQ==
X-Gm-Message-State: AOJu0YzhY5mjQ67sDK2knQk7iEuX27WrtJd3yc10YRozNxlmemwl/pzB
	6G/cZdU3MjruQ4pcc4DUmUJfyI4M3WhbVoFC2z3q4hjod6FkaJcEEb/RGDvjTv/DCfcVAQMqA8D
	N19UCfMD5vFsMMmkyK8fM/H4M3ogFSSg=
X-Gm-Gg: ASbGncufwiuRmwx7bLpk9Jv7MAlPnEuJcSCsR01MnMEOYs2//FCvPQR+pAn3vUWhomM
	itZrmf4HwCKm2dwI38kSxWx2y4/i8DN+/AiSY4CqpHAbrCFHoMvQ/fmrU1nVVqBX1vq682huIkc
	B98bwztysqeVjtx47sD63NIMd3RyzTWL/Hlg+SxGb7n2AwbMjuDrMWby6QyL2EysGgSLo+xppEE
	dEHbY9B9Xv/R49i/w==
X-Google-Smtp-Source: AGHT+IF8Bkr7PS7/P+w37YpYpvkm4jMRLLF3escBy9onGRRvAuSm5oEUYJawRmHEiGCmm5CjW7kphVKyIhE0/EfAlgM=
X-Received: by 2002:ac8:5716:0:b0:4ae:fa71:9ea5 with SMTP id
 d75a77b69052e-4af10d11525mr19086791cf.48.1754084860965; Fri, 01 Aug 2025
 14:47:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-6-joannelkoong@gmail.com> <ghghf7cynwbmthtozlthggdscnmgvkmnq6s3gkcl4qp2zxubee@azmf2dxubund>
In-Reply-To: <ghghf7cynwbmthtozlthggdscnmgvkmnq6s3gkcl4qp2zxubee@azmf2dxubund>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 1 Aug 2025 14:47:30 -0700
X-Gm-Features: Ac12FXxaOUKnRnhsre2EUbUqbED2JQEbEAQrHEZ5LNAO58jwZ4eXF6jMaZEnX1g
Message-ID: <CAJnrk1awAjCY6HNp0F2QUEkA10O_ZABr_QpJ29JdzRGq7E0ffw@mail.gmail.com>
Subject: Re: [RFC PATCH v1 05/10] mm: add filemap_dirty_folio_pages() helper
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, 
	hch@infradead.org, djwong@kernel.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d6znztasixzu4snuwue744stq9ambswe
X-Rspamd-Queue-Id: 1596C140002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754084861-556224
X-HE-Meta: U2FsdGVkX18CkUzTDCOOvtIlygMf8Z3zgF/WVZ3+AbI89aXtBAqtfoucrpb2iHckRdMVDm1WUXZKKSh7ilTxW2F4Tz698cztq4xZOpAjhNneeK4E3shup/9Ef6RSHeOlP+mzSe/De5r0vtJ4VB//Guh4jrKTy+HcKs3Zf9NRbfxS+mDiIKfTn4wk83oMyC4K4370tn6kpn8zhxLyWFGfJ1OGr+r8vgLCEIRoQWkggOQsj2N0bJk4rFlTNDWNe5WPuFAeVDDhKOEj72/3aHJDuSx29dD/442gezypHeptkTzOszgBkdpR1EkuKixfTyo30CgZswfHpMRvJ+ax69EOTwYkD8Yb+0DUtdcy2pAKpup0ekYpiwLM0hbLkMZRipckpg1DJJpb1rPWYXae8IaiZxef2r2rlErj0Ye3Hqlo5XUcEapffj8jHWWXZhYG/nHcB9px/Z92MtO2agvYLorZkVbhQc+Q96yTJSHmjvWx7bRt/a/8Pxd9b2X6rzMKg6cfzYb6Umg+58xTnAFVCcbtY0NC18xQMjmKZxqTeNQqYDOErztZC7acnz4nV/run0bIw6t+tfaA0WKYWxxR6/KOJO8xyUW6K7MPcGMWupB4OtPrT3Zw+IIfCQv51CUcPBXfkrvfEWoa4PmRMmAGfuG3bUqqjTDEO7J4i1psKAFTI597eswUP79bzbo3Feb1/rMf/6wDt9uesofX/vDJ8mntaNzWcsE5ddwA4qtyfjMfQxs9xST2FcaUD1ncaPqBXdrDsdtAMG9aoAeW4srEGY8tAxAumF0Odwic5rFRsfXuoCTVTKSXQgYkpTRiZMeE7SYRjaMszyJi43a+7wDB/cfOFEtLHo7ss5JNruYKe6K/A5EE6sHvYdkl7fhx/cjtBFwBC8qLZ8ByRTzPuBuq6MmfitlBNo7GCjLUV41dqmX4u0gJPjfIcyr/+QLaZv4WHu9YZrQ8bgPEn389aiGdIsB
 YSfLqF2p
 Z148nj9fwispyhBtSvL7oOZAGkETDiFFH0lFMYIeuoDaGWk0L0OpnwbwIJoa+gz8MkLCM2byNnX4Iu2D1m+Z+pXDPGkwMQNaJ4bYKZJFrWJI7YejcoctUrhS6yhuLRaCFAYaSNbLs7hdzv5rNytQS9UET94UmDEcCz9oO4Ik5fyFGjxPk1a//hSZslxE2iTaxr239pLAZNWdZ6TXnCKGRl2U9HKD5jcjy8xrCPWOQlgfq16rbKy1GJurQyfwSAEQrza6hlkFQJmLZnof7aqjq0SKHDeTixISfVEn2KnrNaGeEZBRvcGsy3X41VoOFXXzEIQDil7cN4cAMjTZumA8MI4Mmc6vA3Nj0U1DZf+WC3HVEnxPRIaJHDh7Skg7/jBhzJP8DR6oQliUm+xPdr3hQSHrZ1lR4+sgg2bJbNFzZCFljjqWufuwHFq2v/nwsVZ0ZNmSzQ1tOHJgu1HKij4R6mkH0Bf3qIUyvICxH3NxNsdwccDs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 10:07=E2=80=AFAM Jan Kara <jack@suse.cz> wrote:
>
> On Thu 31-07-25 17:21:26, Joanne Koong wrote:
> > Add filemap_dirty_folio_pages() which takes in the number of pages to d=
irty.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ...
> > diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> > index b0ae10a6687d..a3805988f3ad 100644
> > --- a/mm/page-writeback.c
> > +++ b/mm/page-writeback.c
> > @@ -2732,7 +2732,7 @@ void folio_account_cleaned(struct folio *folio, s=
truct bdi_writeback *wb)
> >   * try_to_free_buffers() to fail.
> >   */
> >  void __folio_mark_dirty(struct folio *folio, struct address_space *map=
ping,
> > -                          int warn, long nr_pages)
> > +                          int warn, long nr_pages, bool newly_dirty)
> >  {
> >       unsigned long flags;
> >
> > @@ -2740,12 +2740,29 @@ void __folio_mark_dirty(struct folio *folio, st=
ruct address_space *mapping,
> >       if (folio->mapping) {   /* Race with truncate? */
> >               WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
> >               folio_account_dirtied(folio, mapping, nr_pages);
> > -             __xa_set_mark(&mapping->i_pages, folio_index(folio),
> > -                             PAGECACHE_TAG_DIRTY);
> > +             if (newly_dirty)
> > +                     __xa_set_mark(&mapping->i_pages, folio_index(foli=
o),
> > +                                     PAGECACHE_TAG_DIRTY);
> >       }
> >       xa_unlock_irqrestore(&mapping->i_pages, flags);
>
> I think this is a dangerous coding pattern. What is making sure that by t=
he
> time you get here newly_dirty is still valid? I mean the dirtying can rac=
e
> e.g. with writeback and so it can happen that the page is clean by the ti=
me
> we get here but newly_dirty is false. We are often protected by page lock
> when dirtying a folio but not always... So if nothing else this requires =
a
> careful documentation about correct use.
>
>                                                                 Honza

I think races against writeback and truncation could already exist
here prior to this patch. afaict from the function documentation for
__folio_mark_dirty(), it's up to the caller to prevent this:

 * It is the caller's responsibility to prevent the folio from being trunca=
ted
 * while this function is in progress, although it may have been truncated
 * before this function is called.  Most callers have the folio locked.
 * A few have the folio blocked from truncation through other means (e.g.
 * zap_vma_pages() has it mapped and is holding the page table lock).

The documentation doesn't mention anything about writeback but I think
it applies here similarly.

I'm happy to do this another way though if there's a better approach here.

Thanks,
Joanne

> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

