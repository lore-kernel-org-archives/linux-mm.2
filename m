Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40C05C61DE5
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 13:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3356B0005; Sat, 21 Feb 2026 08:39:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581296B0089; Sat, 21 Feb 2026 08:39:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4624E6B008A; Sat, 21 Feb 2026 08:39:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 341C56B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 08:39:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B00CE1A04ED
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:39:11 +0000 (UTC)
X-FDA: 84468570102.07.7E4AE26
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id CAAD54000E
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:39:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JCcA5Vos;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771681149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NlzYsZe90DjtvqtblrNeu69Kj4uAwFuPdcXlyGCTNw=;
	b=ga9PW+B4Q0KJmG7OwhJSE7FqN9qJZ3D11O7vRmadkXsabRk8IsaYnVpg0t+Jh390BI8F0U
	fcyG+qB5YYKfMyYuekFPa1taKnro4lXfa54cNiV7k4VyEc5oGfU31aVxXjlelcbvdP9kfr
	Z5zLZgW4E4dfFbXs0VVdChOe315e9ic=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JCcA5Vos;
	spf=pass (imf11.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771681149; a=rsa-sha256;
	cv=none;
	b=j8O+dQ31Nmj/QjDlO0UeuYA/5KYasNKzrJsfeDIiG0WEaDKN3efHhLV5dTVkGKX5BvbGlh
	YOlywn94hhb4woTxMh50kWtDl0hMHCXn6x0F7OHZjz1pOGnH+sF7zqhuAQAu88DxacQ6nU
	+s2Fa/HkjvS/Fog8oDzOaFoKIexXqC4=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2aaecf9c325so18499415ad.1
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 05:39:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771681148; x=1772285948; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1NlzYsZe90DjtvqtblrNeu69Kj4uAwFuPdcXlyGCTNw=;
        b=JCcA5VoshSSi7bZZvpqe6uQVnHXNwJ4J3DJB/HX+dvprxlhhXSHL0UGRIA4JU/D3pH
         vcmIELMEGZhMdCkKRq/+NisT6F/ndRaAQAuutgSbx/qSRG621nrtgOsYtGkGWbmhbH0f
         BYhCAqBzf9FPhhFCV0F6WYWh/ocNej/RtLna6NGWvsYBOFFnOO4uLJJIVuywjwV5+p0Y
         xJCH+R4jHBdEELCi9Ktvo6jSCfrNxQHQPte3BzuTA3D4+XNW2PqjFyEUwhcfyQNRDkzM
         v7g757S81dwfmnBQYxn93ZATLf7Mp3Of3GWmK0Qd90inL/0zLD8+g0X6h8ZywELpN9v1
         hcxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771681148; x=1772285948;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1NlzYsZe90DjtvqtblrNeu69Kj4uAwFuPdcXlyGCTNw=;
        b=n7Z4rFFkvk3zAhSYJdGkweE/NXNUUwUkO92rHoDj2b8QEasGSdbgm+u5yg7UU3AT6i
         mUz1AuIcUzABMhpwrAdF2fCqTgL8NF9I1Nu6ajP7YWrqojo62GDxe0Vg+hpJqUKYngY9
         74wzktbao65z+3kfTHfaFhMr76snejcRjz/BOeYOA8bonLpWrBHgMbTsSXRXkkxy1/FQ
         EUT5YcgiYeI8LfQEnp82EMi55t5f27uvtEMq+iLQuDP3ca81OsOIUEipP5dOtnG2Dp/R
         K++6E3phxRNpzE6AMV1v+xKOHspcy5VvkIEiwBTiZmxdNMHTOK+82yDJe3K07WiIQOn0
         NLyg==
X-Forwarded-Encrypted: i=1; AJvYcCVMptMQJaYdF4f09FoiAcf586fT0Z/NR8lZqaWtG8gPrhaD5xxv2RIA6fP3tIXFmYFxPQh6TRgV6w==@kvack.org
X-Gm-Message-State: AOJu0YwE3wuth7iqj4l2bQ/IRDPy3I9zbZNu8e+MD+0xWXamDSYvfOAe
	4qGvfZ1oLCmjxWzSoMG/deR6VusQTKrFfoUhxEDZk6hAU8hTEztQFN8w
X-Gm-Gg: AZuq6aJKt8FkIOX6HlS4KV9JmOOzYTizhv4VguSQnFn73xxSBgmOCREEn2VFHtPZHM4
	2XVJtn4pnhrFIJyZOqA84fw4LbO1gs9EvNoh+oD96YhptOttDv1CRv8HvWD7FZO4RpkcZwPdox1
	LPtpq7bgvTFeKlmUXbdNYD3F0hyWxmLvqp0uwJTh0/a3QzXI1OsLWKduC1KACH2aPjANfyibE8q
	TopFlzKNyRs3WtYAXfwnzrFMDLo/zQwEJvY8BcyUZKfOrd4bs/fHgpSSA4cdx5AHO2isRtf5dce
	fRux/6/E0iF+cEgt9tC4cc77drjuoY1T4xmEuLhUODsd5PPs9pBNOxUV0mGmERGZDb0gXFYalIq
	Fepm4ByQLtyjKGXc1H6WsQiKznB7J8gFTkqYAHB+ma27V4xXJSLpiAIAFvFM9/N/P14PuJmZmLS
	qMZ/KQmvR6g3pXTWlRnBTyHiRBSFC+C2n+8g==
X-Received: by 2002:a17:902:ce03:b0:2aa:d2f4:9c11 with SMTP id d9443c01a7336-2ad5f7019c7mr89837135ad.5.1771681148427;
        Sat, 21 Feb 2026 05:39:08 -0800 (PST)
Received: from localhost.localdomain ([49.79.21.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74e34fdcsm22206915ad.19.2026.02.21.05.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 05:39:07 -0800 (PST)
Date: Sat, 21 Feb 2026 21:38:58 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
Message-ID: <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-5-vernon2gm@gmail.com>
 <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CAAD54000E
X-Stat-Signature: s5yskt6mqey1cr6hf7zspf38dnzpwzhw
X-HE-Tag: 1771681149-385872
X-HE-Meta: U2FsdGVkX18NYQudT7ITMvVMeB1jGcpque6njmdVr9XY6FqQBnE/IlzGgA8XH3viK7S7D6J4F+yORbrC2pqnhK+SNNHsGgbGRGOOpvpac1yFB7m9CtJMGFjOnQl4I+R9MD7VGWrIWH9ws/3N07jpMDHLeQ0AGyJPNKmV1FWJfWddlMY1tSowhIIYqgT/XxCZPOpy6BJYuprmSTYXe4pcVwBpwN7wIiFJqI9gwtHY7gZxUDz6+WU+9NfNk+XS7vQYoLQzz17PzqspSXceUBzgx0L1B2oRhORx3QLSF4X3bgNCSejaBB6VymQMwssbV2+Yt6Ga9M3CxfXAVUXjGlpBg6qFcf72+9ZJWBY7QM1Fb2eNrm2rjY2kFCV4LrnutxgpbxO+jnW6n2xHDvSWm1hEV4zQdmDp8CbjXck5ZRsPsgaBN3XECdByw8tBV002OS8GlENyv8g9EgNIGn8jbXjMA+4K/gf7TuLmnAMb+hG4nCE9vSdlTQ9U0Vjzh/Bfi77nhkQG0EF0ITR1hLkUM1M7RIu1Yd0zPRYPwo3+ydYZ31ORxQ9PGzqsQ7UAwLTlTdfH2D5s/AdUkk31UP/ht5DECCZCOhzw9lP/YgnJxAn6hRs8L/VxBCul+T9dGB4B+kK521sXrR08meDizyN1uDLQj7Kcp9yXdSDR/+a2TESd3dSEkbs9anHZfuQkX/lY6mVSU9D/QSFK8b1waUkHVE+Nu7c4vzawLDcZY4xFy8f+K1ycPTr3qUfDXYiQbPIaFuD7/1hDKGecltPH1ljJP1Vg0VizOlA/Qx1aUIy71JIDmIisoz3AGC5Y9DpeM9k78heHK8iPg0oTqkSPdh/de+OlvQdwMmnwnwL4oV/zVD4YYhkkUEZ6UTtXKWTyWxXlYPA0itLZASZb5jlz+jJ9nUcRg8UASK22azz8gH4Rp5cT2dTlVRXas01gEKVmL+wroGx1CxzxHinFcbcqXZa7mUZ
 KRRdp8YA
 LHyVTSBr6DuX0k98YjKEMkd1Ik1Hla6DISx9VgvE644QdRbadDGJmEbS3b6YaIAhPAXOgyk0bNkke2cHNoaSS9EACy7wLBqC7Pfvb0Pk1+Q/XrnzySl6lEJfqx4jfu3iqFyVELHhzodmhNJ5Mi6DMiwsX+C97UznsWmhXfrH0YWVqOATilHw/qu0kVb/UxOhLr5XwBsX4T4Rm8GZ48dn17lQql4DFulhkjA+D6mt3+mOYqvDYgFZfbMCuUpB60L7CODteX1hVFSrUcRwMwNMxV0ZZK09giFMwHBllzH3daJGgFZws2KS7SppVVKdPTefMKTOYTJq+npEjh3q7k9jRVz1ynWiXy1Bgrlk1Eedl6FJsOfqBF+tz9v3WSzClHKTNWi7FZbGTxHFxnhLBiKIhTDxe2DWc4+caod+FvS7su3URKAe8wVfKhYeocbVk7hqbSOgr99CtiCx+5A6gnP/O492GbjNg5HPPLwPs7yZhtUuv1E2Jd0l7XBdNM5rCYbPr4Ne5TwkPPPPw/KahmnTXzsLJ24WyjiwXFAIFd6oWx6RH/bw7RK2Q81eQFaEtMeLXed7aP3aInMLSt8Q3zwSSPu+Ltg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 21, 2026 at 06:27:36PM +0800, Barry Song wrote:
> On Sat, Feb 21, 2026 at 5:40 PM Vernon Yang <vernon2gm@gmail.com> wrote:
> >
> > From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly and then call madvise(MADV_FREE). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > And if all folios in VM_DROPPABLE are lazyfree, Collapsing maintains
> > that property, so we can just collapse and memory pressure in the future
>
> I don’t think this is accurate. A VMA without VM_DROPPABLE
> can still have all folios marked as lazyfree. Therefore, having
> all folios lazyfree is not the reason why collapsing preserves
> the property.

In folio_add_new_anon_rmap(), we know that the vma has the VM_DROPPABLE
attribute, which is the root reason why Collapsing maintains that property.
The above commit log clearly states "all folios in VM_DROPPABLE are lazyfree"
                                                ^^^^^^^^^^^^^^^
(the "if" is redundant and should be removed), not "all folios are lazyfree".

> This raises a question: if a VMA without VM_DROPPABLE has
> many contiguous lazyfree folios that can be collapsed, and
> none of those folios are non-lazyfree, should we collapse
> them and pass the lazyfree state to the new folio?
>
> Currently, our approach skips the collapse, which also feels
> a bit inconsistent.

Yes, they are inconsistent, because this question need to scan all folios
to make a decision, and it cannot solve the hot1->cold->hot2 scenario.

> > will free it up. In contrast, collapsing in !VM_DROPPABLE does not
> > maintain that property, the collapsed folio will not be lazyfree and
> > memory pressure in the future will not be able to free it up.
> >
> > So if the user has explicitly informed us via MADV_FREE that this memory
> > will be freed, and this vma does not have VM_DROPPABLE flags, it is
> > appropriate for khugepaged to skip it only, thereby avoiding unnecessary
> > scan and collapse operations to reducing CPU wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > Acked-by: David Hildenbrand (arm) <david@kernel.org>
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > ---
>
> Overall, LGTM,
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thank you for review.

> >  include/trace/events/huge_memory.h |  1 +
> >  mm/khugepaged.c                    | 13 +++++++++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> > index 384e29f6bef0..bcdc57eea270 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -25,6 +25,7 @@
> >         EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> >         EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> >         EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> > +       EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> >         EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> >         EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> >         EM( SCAN_VMA_NULL,              "vma_null")                     \
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 61e25cf5424b..e792e9074b48 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -46,6 +46,7 @@ enum scan_result {
> >         SCAN_PAGE_LRU,
> >         SCAN_PAGE_LOCK,
> >         SCAN_PAGE_ANON,
> > +       SCAN_PAGE_LAZYFREE,
> >         SCAN_PAGE_COMPOUND,
> >         SCAN_ANY_PROCESS,
> >         SCAN_VMA_NULL,
> > @@ -574,6 +575,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
> >                 folio = page_folio(page);
> >                 VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
> >
> > +               if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
> > +                   folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
>
> I would prefer to add a comment about VM_DROPPABLE here
> rather than only mentioning it in the changelog.

Is the following comment clear?

/*
 * If the vma has the VM_DROPPABLE flag, the collapse will
 * preserve the lazyfree property without needing to skip.
 */

> > +                       result = SCAN_PAGE_LAZYFREE;
> > +                       goto out;
> > +               }
> > +
> >                 /* See hpage_collapse_scan_pmd(). */
> >                 if (folio_maybe_mapped_shared(folio)) {
> >                         ++shared;
> > @@ -1326,6 +1333,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >                 }
> >                 folio = page_folio(page);
> >
> > +               if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
> > +                   folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
> > +                       result = SCAN_PAGE_LAZYFREE;
> > +                       goto out_unmap;
> > +               }
>
> As above.
>
> > +
> >                 if (!folio_test_anon(folio)) {
> >                         result = SCAN_PAGE_ANON;
> >                         goto out_unmap;
> > --
> > 2.51.0
> >
>
> Thanks
> Barry
>

