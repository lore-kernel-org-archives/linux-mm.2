Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C1C606A336
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 07:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Vt++KaRT
Received: by kanga.kvack.org (Postfix)
	id BA7476B05B2; Fri, 30 Oct 2026 03:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7EA26B05B3; Fri, 30 Oct 2026 03:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D906B05B4; Fri, 30 Oct 2026 03:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 805C96B05B2
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:31:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C78F1A0429
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:31:04 +0000 (UTC)
X-FDA: 85378471248.22.855EBD6
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 289A1180005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:31:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vt++KaRT;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793345462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ricWTCs0M4NsESlZHHSGvxdphtzZh7pRSrlVHDLTA7E=;
	b=bHDOJMWUjtmgCMsycvAJxst+rQKcrrybhSc/WX3RtA3t19XwwzJCJCLyaZ2havxSdepNOj
	7iu8BqgVmi79z6MhMdWBoIaVyau/KKDvhnJlKR/kH+iiKNGM/zZeYZypHPWAgsLQMak8Yj
	lChAC+t2UZJ84TuDV7BsibZ0ZT9+gyI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Vt++KaRT;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793345462;
	b=4Btqjd3LrI0OOjq919o6i1LYdwWJK8URnGL+V+wq7nEKu6rKfIrdZ8JB/aj6uWSV73svyH
	V87AQKvmgIMbFCbDK6Sw4vHGvPsuAIvE3qTFiJEi1S/O84XtNTEBciybwhbD73S3Agtn5H
	/nPI6qviRP/H43ezmz5il7MCjhNuqGo=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c49b431f022so44991766b.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 00:31:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793345460; cv=none;
        d=google.com; s=arc-20260327;
        b=AGkTYqtxFxuxZM9t9dA/ETkC+TaYkjSP8j9s9/DOl/oDM98bgsocx/gia5qtHCZNj2
         n1MU2kgM0qAnii+o22syK2rUcMb9iQfAfYM/pHrn7e2VNsqiS1GcgpoDsH40qBxHDRpK
         7GGQbi6OAeodNtujVnNpxVTOFltrPfRMXa67oKAr4LpO+85D6xMz3QQ8CK5HXPKaWilC
         CzbQ367ZztIe4KAbl7fff5oiSFXI81Xahqes7yT1ZnQo6JV1HSnanabUhoeW97FUNDCS
         sewnE/mND7BLmjqb9fiMa3jWHzRWloRl9Zb8HSMFS/+t30shTTQbFDIWHpizJJ7N+ucg
         tsNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ricWTCs0M4NsESlZHHSGvxdphtzZh7pRSrlVHDLTA7E=;
        fh=3Np+9/rGZr8XfWwOJxEIupgT1kKWNfWxjLHhMoRdfeo=;
        b=D7cjKAPxqg7pqJmUwyMQclhu7jg6LbjzUKWzh+wQyDozy1OJOUbDfNbXi26s+Ulz77
         vSyBu7tCWebrWj04+Da7wjKADnjxku1WFsgvBU5cmKyoUaalDacuYizyDC7lqsiwuypJ
         QSLGag2egR818pXKEj2T3lSHdpKsK5SXbDFoOT8e2jKb5QotouiwIEHYCDYApyAnYPQH
         yc+hJMY6JBD3hY/s6M/SKQER8IIhbYQo8g+Ql7ghWa9fMKRF1ug1rZW9JKrZNjrrLdHP
         bPy68KXo3hqNwZ3AsMGCd8g6u59HYBZP/D17K5mtcGXxpNjFaiPWjzKTdPyx+cGrw4Ue
         083g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793345460; x=1793950260; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ricWTCs0M4NsESlZHHSGvxdphtzZh7pRSrlVHDLTA7E=;
        b=Vt++KaRTnGmthz0mXQZoCc0BBSDWXwdWbTaPq8HMKHGCijES3S4xm/alrZh2exgRy6
         cER+MHPpi2l3+a1sABBpCKWy9iit6eIhsbMabVRtpIIWbv4eidWqvQpqp1TsH8J5JSsU
         2pSKqTk24BOuqqoSkxBX+7aL+kkgUZhBty6U5U0UULQ0Nqch+gDJtnis82kAT59CsA+8
         o2KEvdrXkmawNe7LPs9MA3fj9r3c+nXDczswjtKoguLKnVBNFfIPBnUQf2utprEVyuWy
         yshAamGGawBR2+hnww6p7b9idG5oZWi7JcVgCVAUxObiFje091eudGpErv48GfgkOm3i
         b2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793345460; x=1793950260;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ricWTCs0M4NsESlZHHSGvxdphtzZh7pRSrlVHDLTA7E=;
        b=duuRoPOblHQzG6KgXetj+DZoUpc//J3RuFm2Nwl+7vVFjA3GqZdOlyPrNc2xPDtgtx
         mTyjdRnrEK4X+J9E78I+9Y+H3Kmr6lfAcIL4GR4hYxwGsSL5aWE5QUxCpiuia4is41O7
         nw/0rcL4WUQxyGiwhkrtfwfoGRBrn+pRWFf42cypWZSgF/GVzzLGwbHlTO7xs5jmglJQ
         QLebRJWriMr+cXiV0slFnf5zHsP4jXoBrRlvQSYiyHl45kogb0ZJwqqLPiKADqpIrzPk
         e+1PfRMZpLRG9y400/afk1RJfr2G6nfkZ/cBODI9E+W7qMHYQDUki5FmiA5JHEdW37er
         MK2w==
X-Gm-Message-State: AFq9FYJ1n+591uEYM9ZoawjVBGdpjfVwSHA7VTSQEjG8SjYSUNjqsw20
	nVSLFIzlGALi3/EMpTlz4AWwLhgDBbk6dYXKekT+Xol/pz/lYUWQvEk9U2ppZv0IeI7Tv8HXvQI
	358WHI5suu5jmtbdLR2m72MKAaGkmdNA=
X-Gm-Gg: AYBFou3rFORmLyThfmm7LPV6KIEGcU7tUGCF12pbJxSzAjeafPhGzSx7wMa8y12iMxG
	nlkh3Zry60RlImv9Gp5+9b8pCMsDoZxHJZL/RA5od2Nfo31zVZqM+aYlEYmjvz1MT1EojCxjINo
	2IW82WPos4biwH03LKWY5gG3v27aYEgkf4up4akz5h9/5ELDM38za8/Lp0+rGE+eaCDKYgpB1QK
	5GYYJAwnj3aaHlo1ouAgupVZkBmv9ief6H8GqR0Sauq/zEiVhptDquxfcHTCnyzRdGdYFT4lG5x
	94kjLrrDmFErDbjUbckYQrXGZnS/gw82ZNkm2rsfJes5iYe96MELUKn0wFzp+GJNoOKzGyG2JxW
	l8OOnSl5zktJcMxrg/oVitD7pAIp82kzxToN7kNKeMsujseZ3uujrhplgI8r2hfzhzKTP6Q==
X-Received: by 2002:a17:907:60d3:b0:c31:fb29:a137 with SMTP id
 a640c23a62f3a-c4ca7a72d9dmr122779566b.21.1793345460293; Fri, 30 Oct 2026
 00:31:00 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261030-swap-fixes-v1-0-73f73a59f2fc@tencent.com>
 <20261030-swap-fixes-v1-3-73f73a59f2fc@tencent.com> <CAKEwX=MJcyr1GjKNQ81x+fUS07T=THXGivjebt=W0ayjjZ3fgQ@mail.gmail.com>
In-Reply-To: <CAKEwX=MJcyr1GjKNQ81x+fUS07T=THXGivjebt=W0ayjjZ3fgQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 30 Oct 2026 15:30:23 +0800
X-Gm-Features: AclHuK_5zGeSFYxm22Ak0DBi9H9DruGl1-1gM-J338_JJvTdWweQtUaJ6xf3TVs
Message-ID: <CAMgjq7BHC=68=+2DsdZW7_1_PfdjCyd9fXN_2YZiaXFi1pHy=w@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm, swap: fix large swap-in across swap file extents
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Usama Arif <usamaarif642@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mani Tofigh <mt4022@columbia.edu>, linux-kernel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 289A1180005
X-Stat-Signature: ictwaq6tirar16r4kuwjoocaonwdberf
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793345461-427116
X-HE-Meta: U2FsdGVkX1/d6Zllo+L0EXrY2fS3qkGH6gr+GCXqQFrMxgBZSWPoHpyfRvxfi4HGxJWcPgjyMlDarukyZie3OKvsscwMl3bJWcrgC1IBsV+T86y3ed01Y8ZzNGKXtSbQ3n6MygWAX1PpasB1M9V+hVljM+enlA+g8rK+wHW0ybqAXlFIFF+v2D8yyPBDymWtp7lPfs9bEHtGDBAUHIV6CyGNvSC1Px6I1EE2qwf0aQgbK4D95rRsfgHQegjt0jzWNqlXdw9hfb5pYLS+PTrCKm7ISWpNjWCyuH+jS7RbZNKTN9oluYL54t6wG1H6TUr/2eaek/tfslwnB3Zv+3geMTgjkyaP9xC+T/1dYvjl4i66oKEiys45ZfPR2yrJoX/64hW5Kd8E5B4LthKanm4tSDuSZn3HxAq/Y7QGWOsWveldoSTsZHpygUYAr6K+KN76IqAq4ShraSoQqWxxpz0Ggzg41fvojOY9kXhjwDS7xHQX3Ufg71cK1GNrnLO3w74HlTY6G4DCcGpG6X/rqjWslAH7L7HschE9D0eH7GuvYpaVSrkaZTSpDhU9MMX2YDaTFBba4Aa7Nbyjd/hVJFajKOUJrqfiJchcXW1oiOfOid09G8XHw7N7vr/0Cy4GW66UXS2wQQ5qgNupJUZQKyIGAtdTs8fQOB76Mtpia3TqsCzG3RmqEDqdPNZDBBZf9oBzTwjFaTS2W2KEwgGeWTus/mwrVapckg+GWrTP9fXDTSLwVd9EIENktIYe+AV6qnb9j+juPn2/Ad7O4jhqeTXdZhyG0fAzTm5IvWNDzduzlQPTzJ/8wj8PbIq9qnt12QnASIIXQ1jNhVEd/0MFI7lqvxh4d9CalcsOSZyzkCvZqpRGQo8TKwB5IHuRa5RzpfAkYcgYKyCQRr3GdrZFzbTkGUornEYSaSYAQ6/gGJsUf2eZRzpfiQK+6v+qM1GKghC0J8y6tQ2+wd3K57FUcrR
 sqmNu02I
 IVpsS645ivOVDfeLeKgZNLx8DdyW4xobZQyCZtpC5OyoyPaarmtFGcjf0vyx/uFLFsV0+/oBeWcr050B55c+iyLukM2bPoaNxQJ+tcwWwPABsxNgPOdvMqm044eQKEga3cRR2xN5ALPhliO/OIfVYIk5JYEbciiBpuKnS9Ro0yfQFmxWKoldCuF03iwR/nurbQv5Yu4/YGBGQpkJP7HkZCpUUYY+Lz3cRQnYPpiAUOIndWR+LxSjI5n5Paj2fKRCn9iRnK7RLhcaPB8NjrpSaGavFm7IZijvv3860Ywq9QKj9X3yTpQ+0rkKTSf6i9eE5hhKr+FXKi3JGtNz8a4Vw8yUqEghei4rPijrqBMcRjwoMrMIc6fhaSNPfG8wC50WEfkm/pfg+1JtjluUMZ7GgVG8x/EOEIdJU4t36+tD/sO0+Juw0NwpE6A/rRouY2kNBKvOnpPEZ1Viqf3F7DlJbEEyl3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 5:21=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Thu, Oct 29, 2026 at 11:32=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Chris Mason <mason@kernel.org>
> >
> > A page fault can give an unprivileged process blocks of other users'
> > files instead of its own swapped-out data. This affects systems with a
> > swap file on a synchronous block device, such as brd or zram. For an
> > anonymous mapping it also takes a huge page size below the PMD size
> > (mTHP), such as 64 KiB, that is enabled for anonymous memory.
> >
> > A swap area is divided into slots of one page each. A swap file is a
> > regular file, so adjacent swap slots can lie in two extents, far apart
> > on disk. A folio is read from swap with a single bio that starts at the
> > sector of the folio's first slot. So all slots of a large folio must be
> > contiguous on disk.
> >
> > The swap allocator knows this: it only hands out a run of slots for a
> > large folio if the swap area is a block device (SWP_BLKDEV).
> >
> > The swap-in path does not. On a synchronous device (SWP_SYNCHRONOUS_IO)=
,
> > one that always completes I/O in the submitter's context, do_swap_page(=
)
> > can read several swapped-out pages as one large folio (a large swap-in)=
.
> > thp_swapin_suitable_orders() makes that decision, and looks only at the
> > swap offsets (the slot numbers) in the page table.
> >
> > Pages that were swapped out one at a time can end up in consecutive,
> > aligned slots, and are then read as one large folio. If the extent of
> > the first slot ends inside that folio, the rest of the folio is filled
> > from the blocks that follow the extent on disk. These blocks can belong
> > to other files.
> >
> > Reproduced with a fragmented swap file on brd and 64 KiB folios enabled=
.
> > After single pages were swapped out, a fault returned blocks of a
> > root-owned file with mode 0600.
> >
> > Fix this by allowing a large swap-in only when SWP_BLKDEV is set.
> >
> > Known gaps:
> > - A swap file on zram, brd, pmem or btt is now read one page at a time,
> >   even where its slots lie in one extent. Its swpin counters in
> >   /sys/kernel/mm/transparent_hugepage/hugepages-*/stats stay at 0.
>
>
> I guess we can check for this right? Look for the swap extent of the
> first offset, then get extent's size (swap_extent->nr_pages).
>
> Not sure if these users use swap file here though.

Thanks for the review!

I think it's really not a good idea to use swap over FS on a
zram/brd/pmem device, and we already disable mTHP allocation for any
such setups, and extents is a burden there. Without high-order
allocation, there is no high-order swapout, so high-order swapin seems
much less helpful.

So keeping the fix simple is a good first step, IMO. We may revisit
this after mTHP allocation is doable on these devices, and get rid of
the extent completely.

> > - With the posted "mm, swap: enable THP swapin for xswap entries"
> >   applied as well, the large swap-in that it adds never happens. That
> >   patch gives its swap device SWP_SYNCHRONOUS_IO but not SWP_BLKDEV, so
> >   the new check would have to let that device pass.
>
> Mentioning unmerged patches in changelog? ;)

I can help simplify that part.

>
> >
> > Fixes: 242d12c98174 ("mm: support large folios swap-in for sync io devi=
ces")
> > Cc: stable@vger.kernel.org
> > Assisted-by: LLM
> > Signed-off-by: Chris Mason <mason@kernel.org>
> > Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/memory.c | 16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index b65b56fe9714..944f57153c89 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4863,7 +4863,8 @@ static inline unsigned long thp_swap_suitable_ord=
ers(pgoff_t swp_offset,
> >         return orders;
> >  }
> >
> > -static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
> > +static unsigned long thp_swapin_suitable_orders(struct swap_info_struc=
t *si,
> > +                                               struct vm_fault *vmf)
> >  {
> >         struct vm_area_struct *vma =3D vmf->vma;
> >         unsigned long orders;
> > @@ -4888,6 +4889,14 @@ static unsigned long thp_swapin_suitable_orders(=
struct vm_fault *vmf)
> >         if (!zswap_never_enabled())
> >                 return 0;
> >
> > +       /*
> > +        * Neighbouring slots of a swap file can lie in two extents, an=
d a folio
> > +        * is read with one bio. The flag is set in swapon() and stays,=
 so the
> > +        * race is benign.
> > +        */
> > +       if (!data_race(si->flags & SWP_BLKDEV))
> > +               return 0;
> > +
> >         entry =3D softleaf_from_pte(vmf->orig_pte);
> >         /*
> >          * Get a list of all the (large) orders below PMD_ORDER that ar=
e enabled
> > @@ -4924,7 +4933,8 @@ static unsigned long thp_swapin_suitable_orders(s=
truct vm_fault *vmf)
> >         return orders;
> >  }
> >  #else /* !CONFIG_TRANSPARENT_HUGEPAGE */
> > -static unsigned long thp_swapin_suitable_orders(struct vm_fault *vmf)
> > +static unsigned long thp_swapin_suitable_orders(struct swap_info_struc=
t *si,
> > +                                               struct vm_fault *vmf)
>
> Nice, I think Sashiko is complaining about it on one of my vswap
> patches lol, and I was wondering how on earth is correct in non-vswap
> case.
>
> Fix LGTM:
>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>

Thanks!

