Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5DDCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 11:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373338E0019; Mon,  8 Sep 2025 07:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34ACC8E0006; Mon,  8 Sep 2025 07:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260F28E0019; Mon,  8 Sep 2025 07:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0F5D08E0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 07:20:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C26635CA04
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:20:02 +0000 (UTC)
X-FDA: 83865838644.10.FD634B1
Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id EFEF21C0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:20:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PSkX+DPk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757330401; a=rsa-sha256;
	cv=none;
	b=MG7ku6VsHzRh+LF/4NPatw1Ad0S2IliC8DJkQkYlQgkTK/DsXuRPcNdhlkQtaYihUKikHw
	ViXw0pzFh5t6fFFBp2zX7/NZ8ag1JicHyHxpKED+FK0SgSdiLfvKdQiGQxqI/Tacg1sMMV
	da/7a2txWGcWSUCS3Lq1i6pPo1kBevA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PSkX+DPk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 209.85.219.175 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757330401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+mV6w8heF12OmGZHtiUEbs9VXpSREDvA3sMDlFD6ww=;
	b=6njovqir9HSZK7L8b75MDtQu5Vlsx/XM7t82shXCmMigdd+Tp64kdv3re3nyIGJ0HIAm3H
	vqO/snKj7wMuK+EGIhF/X4l/zrhcq6CPcDjKeG8C/NzxND6K3Ic6RT45BcQmDd891S0Rva
	/TPhJDObtUzxPXGPJQnJOIADgzPzhiw=
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e96e987fc92so3592192276.2
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 04:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757330400; x=1757935200; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W+mV6w8heF12OmGZHtiUEbs9VXpSREDvA3sMDlFD6ww=;
        b=PSkX+DPkC37zR6OlAuojLoEuw2c3EQHVVA/7ytmrptlS4LNgEZGxBm2SusnJ9h8f77
         oYGO70YD7pawZqS2ukLeRhWpNl+AEgSYvQdR4kzgm3feriV1AGXWw299dOoxCjZBGJ65
         dTZIl5xbJEiE/R/YZ9e03yyF3uWJg/lg5tkvOzLFXJYLvhMGplZONlXXP+uhdJJr5kkB
         /qsJv5qF+4PAby6jd9qw+uusqlrQWt1evZOVVKTfgctAcCSHshqpIHNDJRDwj0S/salV
         CcRFAv3bQSV49pGOZsRvj4WIJsK2umoz/1FU+R/zV98ZItJjNcPpcUjpSfiSy8AjTjjM
         ROfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757330400; x=1757935200;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+mV6w8heF12OmGZHtiUEbs9VXpSREDvA3sMDlFD6ww=;
        b=VnEKbnh7DlXuTaJSbeZR3nHbeYAF42Z00vwIEofqKpCC5FEnMg2Kh1xFbUfvkTvoyr
         6fLK9c/V/zc10RweyRoc5R9rp9nMG5BZwRhLlBlqESt3lmro040XNhUYUOO1QdfesU5M
         Gs8eW9tJ2YRxSkFCRxGOrOMgYpbrlDL7YgOBIprHCPKwvR9kwFsTZGoXMFoLUIKkE918
         wcIKLIMUf4LN/SngyHq204aDK1sN77XsUkq1W215S+oWtB4Mi5t13qeLio1ToayWC7kE
         /Yz116fuw47Hhhl8cy7VvRlvwbmrCZoHzqtrqDn7aAOteNPdBlnFHyaiH6wwKHU+frSp
         +qVA==
X-Forwarded-Encrypted: i=1; AJvYcCVUktctYjy//A1MB9dgu5XPugMqwXx/pkKqMOfkrSucQZ8g+QbdDJT5uA/FAbcV77L2Ysb+WLke6A==@kvack.org
X-Gm-Message-State: AOJu0Ywl0lHFhhdoROSyOjkoR6EhXxcI+OmIDtuHFLAz7IixT7OpYynE
	/7+QFHf1Tnmy3TnQIdVDFyrHcSIMQJ534GyfzCtIUiAV2WzZhZPBGTTP9jKlphz4DQ==
X-Gm-Gg: ASbGncuIpnMEy4TTacnNeFV71Ibr4fdRCFqnzkApWGfEYclVZg3XSjX/5BA/t7jKc1x
	SymZgA9NBxeKky4KuH883Zj22btlnSAkvx/46ZEmtlX7qx+/qE7TQ8NpT4NrrUsr78FLpEIdMpz
	/s2C+LxHOc68xHAFntW359M8KSrA78m5S5f5X51UdQ1faVmZyy9HRlqrZvijtZtcyqq/3Vv3Dhx
	8VSLi7Z16gt1r0hvF+3TucINjK9C5zbgrF7lpkxfUgrlfir3EySftfFsuV5PrnOZxyw2jbQq6lw
	w600HietEm+F+quQ3AFda4gMBA88Lc/mMT/CDQm4CvROuFYbDE9hC9d6RlxNSolu1A4h6fxB9bd
	Eg4+26nTQAow7U9aFgUic0UXjeToxrV6ms815MCqWpXudOgDUp9ExAl8/Nggkw3XBmt+HpsdFy9
	2sHUFK9D0s08eXnw==
X-Google-Smtp-Source: AGHT+IGwP/DGaMPx8sqPtEuyoQ/cibcMbeJ68ZQrZFoDtJ7AQYVALSu6fUPBwSzdzcqEeHYDylLwPQ==
X-Received: by 2002:a05:6902:6c16:b0:e9d:6bba:60 with SMTP id 3f1490d57ef6-e9f664e7e0fmr5771362276.3.1757330399789;
        Mon, 08 Sep 2025 04:19:59 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e9d5e4b9182sm4167005276.16.2025.09.08.04.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 04:19:58 -0700 (PDT)
Date: Mon, 8 Sep 2025 04:19:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 6/7] mm: folio_may_be_cached() unless
 folio_test_large()
In-Reply-To: <7fe2380f-a83e-4a9e-8c5e-8459c9af0d5f@redhat.com>
Message-ID: <7113d289-fb8e-4589-7eb5-1f7139965ade@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <861c061c-51cd-b940-49df-9f55e1fee2c8@google.com> <7fe2380f-a83e-4a9e-8c5e-8459c9af0d5f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: EFEF21C0006
X-Stat-Signature: kqmr6yhgt7jqcz3q9rch81rebkppqctm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757330400-79318
X-HE-Meta: U2FsdGVkX199kdAVX8I8MqR4n204cCigELu823AJmE+6vhnR/wSiIVyPt13VHdeKfxKY4f+lhsFRjv6pR0Y+y8c4YySeOF78hEHCMqfW3bhoGRuWzqPgLkDiCuHELRkYo4CojljyqMDfYZGCDjubzATHpdu8o6A8uoHh470aeF4OuTxi+oAeHA0gwIO4Bn0PZbfXh6ZTqYIAXh1YJ/9toLWmzyaR8cuptbNXSQ90IoWMmYFWN5p+Fxqgpc4Cel/tbwMqOtWM31nm3x+NOmjTgiewbXZsgm0XgRprcqEVDUg17Cv5NhCwUJ2rYjNT6vCmsmkW720zOXhX7F95jHds2zaWj5DGAMqKdaMVNwrWCXxh4tRQZoFLnRb4qfZUM3fMCjB/mh1IrIWJ9w3FoZxXyuPrPo7aSguVALGtsPx29jKoUDWNsIWLhUCyjaf0t7ylA//f4kwFUs+LNwyQowUzHfi+dyDiEvib2CIm/eXUtwNmMj4gHnB1I0NnP/iC+ON/WzjcanTEn4W1DO2KqUSzYrBOCKi3gwFup+sli/71TuL8easwwBrElFVZ7gybNQLhxjwIMnnLJ6fwemTlQvH4hNqC3ypuE+0VybrQ1iodxwxOTfQN+2RxQ9Qv7znpYdYFX/n/WshI7wjC3KzDBXgDxQNFGuG488eLv8/Q39itxf9KIlYaAhHXVrB1GgJKXSZnRJjIiSY/0ZeI4u10GIsNdgFucE8q+DHhenGNRX46iO4Q4zEEqzyrTGWqCl3YzINyQ4SOmThti+OG39xbw3FeRTa484D0rbv5xSYcse7uNvyqy1NFZ9byLe4hjYmkTiTIdkvb9z9pBWCFWw6o/phPNQq1kkcjdAMsRM1/RqvEqpVDObGDscO1HD9CTmpQOAq8a5J4q69CGhCEy2SiEyVEJg9E9c5n8LfruQnqGA6WCl6ccI+NY4uRMBkYn0XjMfXTK8obH31ebWY0MYFV1Qo
 eIRF+4qn
 yvRvNffTi/48yMUhC8Uem21BGB6RhAk1DK70mRjkuVXXQ9gvehTsZ/LkkmvZ3dSqs+/FY6GUPW1cKCJc/391hAUZmgcYYg2fpXiQOsbsd2KGgbqta7JMf9CpDVr/kAXRNb7NaR7BcNo7hFduxvIbTtNQjbeFuUcTp5Jzol6piOfo7FjCr+lsiEmbyvaBSv2yVEEjcBBQGwS0qdf9xXvLLYbmlbJcWOdgho6e3/z/szTWyekflSVNU2TODoRdwTavGQkdwKRsVPawGY+nnGFvhiw5k7Lp2z4TEUL9/17/J91EgSS+WtB3u4hiHwGFKffD+kGADiN1NuWJHgxCXahWO93hm2i/VCJ1CJ1e/MAyNeKbKAMrnBVyaK3IF6dzLfMzcewahr2Vx7Gqx9QQtDYvfZYAD65jTfsJ3S6XxjakAvBcsZIcg3ORD7TQ+UnlHTJ/wFMZg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025, David Hildenbrand wrote:
> On 31.08.25 11:16, Hugh Dickins wrote:
> > mm/swap.c and mm/mlock.c agree to drain any per-CPU batch as soon as
> > a large folio is added: so collect_longterm_unpinnable_folios() just
> > wastes effort when calling lru_add_drain_all() on a large folio.
> > 
> > But although there is good reason not to batch up PMD-sized folios,
> > we might well benefit from batching a small number of low-order mTHPs
> > (though unclear how that "small number" limitation will be implemented).
> > 
> > So ask if folio_may_be_cached() rather than !folio_test_large(), to
> > insulate those particular checks from future change.  Name preferred
> > to "folio_is_batchable" because large folios can well be put on a batch:
> > it's just the per-CPU LRU caches, drained much later, which need care.
> > 
> > Marked for stable, to counter the increase in lru_add_drain_all()s
> > from "mm/gup: check ref_count instead of lru before migration".
> > 
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >   include/linux/swap.h | 10 ++++++++++
> >   mm/gup.c             |  5 +++--
> >   mm/mlock.c           |  6 +++---
> >   mm/swap.c            |  2 +-
> >   4 files changed, 17 insertions(+), 6 deletions(-)
> > 
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 2fe6ed2cc3fd..b49a61c32238 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -385,6 +385,16 @@ void folio_add_lru_vma(struct folio *, struct
> > vm_area_struct *);
> >   void mark_page_accessed(struct page *);
> >   void folio_mark_accessed(struct folio *);
> >   
> 
> Two smaller things:
> 
> (1) We have other "folio_maybe_*" functions, so this one should likely
>     better start with that as well.
> 
> (2) With things like fscache in mind, the function can be a bit
>     misleading.
> 
> So I wonder if (a) we should just add kerneldoc to document it clearly (lru
> cache, mlock cache?) and (b) maybe call it folio_may_be_lru_cached(). Not sure
> if we can find a better abstraction for these two caches.
> 
> Thinking again, "maybe_cached" might be a bit misleading because it implements
> a very very very bad heuristic for small folios.
> 
> Maybe it's more like "supports being cached".
> 
> folio_lru_caching_supported()

folio_may_be_cached() -> folio_may_be_lru_cached(), yes, that's
very much better, thanks.

(Settimg aside that I've never perceived those pagevecs/batches as a
"cache"; but lru_cache_disable() gave us that terminology, and we've
gone with the flow ever since.  lru_add_drain() would be better named
lru_cache_drain() now, I've always got hung up on "adding a drain".)

"may be" rather than "maybe" was intentional: perhaps too subtle,
but to a native speaker it neatly expresses both the "we can do this"
and "might this have been done" cases.

kernel-doc?  I don't think so, this is very much an mm-internal
matter, and I don't care for the way kernel-doc forces us towards
boilerplate ("@folio: The folio.") rather than helpful comment.

Hugh

