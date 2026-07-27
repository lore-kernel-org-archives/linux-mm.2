Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7069C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 22:23:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977626B007B; Mon, 27 Jul 2026 18:23:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927B76B0088; Mon, 27 Jul 2026 18:23:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8066B008A; Mon, 27 Jul 2026 18:23:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40E0C6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:23:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AF5C2140215
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:23:11 +0000 (UTC)
X-FDA: 85035983382.30.60311EF
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id BB17940009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:23:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=smj0Ko75;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785190989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/XC5XGybgP6aQhVoIMQftnKAoc955dwi/B0eQbg7BB0=;
	b=O312AiB1NLAuFLJKRoREzEX3V/ZDRFUaafF1jenUrWpcL8JNcabyRTFBoyYxGYS0LZlnps
	rTd9SwzuA62fUFQSgX5q85fE/ybpcr3HV/ummCBtfr/1Se6ozvejI+7x+iEwGNK85T0vLA
	wNhXgh+QK42hAARe41xCeZMy4e42F3g=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785190989;
	b=q3XNhWwgxRQT1SOjb6IbPPJp1qV2HLxk+Rf3UKK+13JIZB1Q9FE3KaNgBOm7dkvji7/mRK
	7C3qH7hGAK2ZCfh441hhrgOrwkNng3YkN7v8RvJ/7l229NjGUG1l9F8EZiyhqyxHOAOF/R
	yVK1QHT93UGygF4EiNHJk02N4vlpX0E=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=smj0Ko75;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8f29ec73064so24477046d6.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:23:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785190989; cv=none;
        d=google.com; s=arc-20260327;
        b=OiDuqL2FfpFAgLfZJSwzUhEp+wpslczam9GVoWLvK3+LtQyWqMtOYz2lAIaOQYcQug
         I9KhP2z/Kyi+FcEga/hm5fjVvc1K3M3Oq5wMylt/XR7vtS448LwLi2XlaZgUOMFdd0Pd
         tgLt5x8XzB6KnGzlOARB74LAqU8nmUGoJzgcVGaMeEoLDmCOi1daxVPuDCwKTNLpZuv0
         +d8/KKFhmw/e3UPYzkZ9AScix20sMHTko276NBPifBn8dfYp96zef4/MMbr8jV1EQ/tn
         J14B7N2+BDD4raETAYpp6uh44W6lLbneI+QaXpcvBk9JQsgnFc8o+FI7+cYu1jqECVqF
         x/ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/XC5XGybgP6aQhVoIMQftnKAoc955dwi/B0eQbg7BB0=;
        fh=67wglnrG0bNxW1Wen8RWRlV7/P99lVVyKEBv3JGQKaM=;
        b=pykegn/sfGEnRxMDExwUO6WU1DNYJt23lWkQlMG1/4Exwm5QKaQOk+DUwrkQq1uCmL
         F4MDzQO15F5CkC4fhal+zGcYQqfTFHXRb4vdzD4f6eDCRrOfK3ovkDDK0PavjEoNYodf
         QxGsKQuadMNEAR/VZ47e0kHhY1tTIib3OsAtw0NBzuLue5Q+PC8vLHrFrEQ/q01NhRIE
         2GDQLDGjLNIidQt7h6NiFPtk7LvEp9sM7ULkLb6IpqLal6tOXlgiSJ/nNzWi5gKN2hdb
         UjMY6A1JINgQYTssedy8jZwmZYry2SGY08HqsLijAL9Tg2Ak2MuQ3YzgKOX672nb5qDE
         2OgA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785190989; x=1785795789; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/XC5XGybgP6aQhVoIMQftnKAoc955dwi/B0eQbg7BB0=;
        b=smj0Ko75/iF15Q4z+l8AB2uR9Te1vmd+im1QSD4BIhbbtWA8/hlg40BX300WAVNWMw
         rBuuuR2FWh0lp+Wos/jk42hHs5KTSoP4xxhqoiIYYca5b/JQN0ymFNeKxhxf2+l5Jv/L
         q/R7luXHLCZNLb3pwLd9t1aOWOaqI1WTzr9G/8b3VWMUB/Lggfac6Mlo1S8/CST0OQhj
         cKCycQPfNfUtsUH5KBLBjBegPfgQHWtBCWF2MRT+Wvzqqp1fzHCoe7S0vZcR8Fn2ewt4
         AMktSjYPLocadqXX6/MrcP88BraHOtbl6EJGi6Z2XeRolyec0d6SbwSlJX5aLsCj8jJM
         75TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785190989; x=1785795789;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/XC5XGybgP6aQhVoIMQftnKAoc955dwi/B0eQbg7BB0=;
        b=eYkNSWc67UXwyPEALRt8fnwVMcIK1LPhtPIUebklfNp/xg1EYRur5ui2z+6j97yrGW
         eP0G2/lJLpvK/Drtn4qowdhB7DfehiMlKQYit+xIcjezaywrOudq2d96Z7eTMkGAv4yD
         m/ikzd5kv2pJC/T6qFouDDUppf8NHZ1FCkOvg3BJg2bgLxakLwe1sxTQUGsR0IheYbbA
         zH+of3JpqKfvyku2jFUfvbx/AtnJ0sx0+v7rP4b99AnKuVsCNXpPaNru89JM55Kui/00
         WJPhpys8gpB/6C33fBHYmzLuW5Uxfn5VrZZrafwQTryK58CiMWL0xqZ3vjW4AZdpM2Ij
         hbvg==
X-Forwarded-Encrypted: i=1; AHgh+Rp+JcR1rvcbmA6nGvXMtWnZbKADBlOQG7mVMdeANIphqevyEVg+8zUs2gLNM2F/dEbPClz8vuapxQ==@kvack.org
X-Gm-Message-State: AOJu0YzqoszadOxr9CL3+WgDp1bL1TpPpegpRZ1TBM/xBDXy3dk88CRu
	YS6AcS2R237YjWjwZqpMhCrZgD+Yi2qovhqWdSRKd4Jl69KEkQMw6hQmWs4AJX4kFfG2YS3Ry4p
	bkfv5N75QoHa4CGWoMLkCjBx4TkgRaNc=
X-Gm-Gg: AR+sD12sLRnD3Vv+jVQIhAiwYk+n3M0Dghgah23sVNbYLlRdE+FIzeq5wsLhSlaEWGj
	4eoPM+9Wzui7MiLLSrTOWL/6brMu85pEMigojqYQaHuuCTR8jDOkeQNryLxTVFQUUkYtE5Yd8Fq
	gMZ7uwG+acei/e1VmBae5kiGRK4xLhhiR+WcIJM0xAAW3z2jTHw7Y4x4HfC32+aaMSeUWmptXTE
	WxcPMdWKiT84Kutg+PbgUYSdMvqhfanQI8bI74P4C+G3sGhlohs328gbbyzVPbzvxqaUFR7E+6d
	vaCiBfowX8+smotdsa8FkhDUjeDkUZSBnpvEl/tV1zg7wNlciS/qcdybxsPrlsIb6cNk+LSYlsc
	=
X-Received: by 2002:ad4:5944:0:b0:8ea:fb8c:2e0a with SMTP id
 6a1803df08f44-9081274b851mr17710856d6.28.1785190988688; Mon, 27 Jul 2026
 15:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260722142936.3287702-1-dev.jain@arm.com> <f3db438e-6cf7-4ccf-bd4f-379c549d1e9d@arm.com>
 <amXldUo3LfIGs-zs@casper.infradead.org> <0a312983-3d63-4d60-8ff4-d53dcfff7819@arm.com>
 <amckUdXO-7TtzhNg@milan>
In-Reply-To: <amckUdXO-7TtzhNg@milan>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 28 Jul 2026 06:22:57 +0800
X-Gm-Features: AUfX_mwpfZInPOMiAbDmvtGKNJf_UoBehbwRIpXxIReBo68o9x-57uEnqdR_TZ0
Message-ID: <CAGsJ_4wGGSf2mhwykH137aA5enhgLGj=-asKe0B09tAOVP8qvg@mail.gmail.com>
Subject: Re: [PATCH] mm/usercopy: harden bounds checking for vmalloc allocations
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Dev Jain <dev.jain@arm.com>, Matthew Wilcox <willy@infradead.org>, kees@kernel.org, 
	akpm@linux-foundation.org, gustavoars@kernel.org, 
	linux-hardening@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com, 
	david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eg8nkai8663euf1ffzwkk9kuaexnhzao
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB17940009
X-HE-Tag: 1785190989-326671
X-HE-Meta: U2FsdGVkX187eWvPTWAA706XHxwrisgA490a8Ha3SRyqX9NK2N4GO67D/cILN9D8g8HUXXH9wqd0XrmF6Zn7mwPdmCVHr6HwMDzFpoLonIGVic/6zrjetjrx7v+B1kT8LCZINE2RcwdzQftSJ9eaeqQOkJI9utQ/F1TIkA39vAW7xYbIzgBNAWmiMdEIvrryQANIYXvtjlQS+Gd7JEwRjj7Apubx2JMuDtHDmHqG01earcvsmdbJU59QHB/ANsTEfbJmk9r++AAlKbhzGyX1SEJtkGFqZzTNmCJGFMCAlAmy2gS1iaBnzHnS8ZyKeWDHXZfnM0UyBAFW+4EAXWNFZOVt2BXdT4E7c2MR69C4QyLUDaEBGMEUin8Jgl/MiZY4V4SBa0+UNs6DkUczvudGi+h9n17JAA7/BDi+f0Tj+K8ZU79jV/YQxkxMyOZzy69a/ADyIZ6XLHwEoYZ5ZY5wds0k7JkpYNlt+/duCU/RiOp4Pc8vVg+i1C4FrfDExxvZTGZIWV63X9jJu7zAFCcSh5Pzs+yMPtBQvwJTc0GfnODT+EQOQtBeoDzTJ8qLeZSoS/ZAnTtQ0dRUfE9JNDdlhiX6MiPGeAdA0mP4USsc7Yo+B7nExkQh9GWVIksRPtfqySNpvy0JGGsdja3/hZREFmaEmOzTcqXd/6H1Ok0lqNc/nnlE9u6wKd/83yGrvMK/LCVRQkNBuhKkUA3u1JYdrcw+gcBG8gk2drvDglKCauUNodXDzYukbzM3CYtHlCjKCIki0qphAKYa1QLfdF6dcsYwOwY91pSvfAbRXdNqVNuyRDxErsC+c1JjM3nzBnwpmb98Rc6W6l9khJH46sid6NpLyG3ZzVk/RJaiN6ge6MO1Bk05YkEA1/H2ukzV9LQ/DWcRfMZ4zfpgztRJE0jUpb35PcUKCakv9soTGorClmW49e2NlFkUgVeSYaCDAokfOZJktiJdUHJJ5I3tWDW
 Tf8xP7mr
 ldvg9+F2tr7NM8RIVguN9QBMYOiT84mxdejr0swgEnugpCzdEdnHKgGcbUn9u1JhCwbrT2DTnEnPkOk6lbb7l1oAzDKz5jr1PntDg2dZ3NHWms2AxyTUtoCTF41BreowV5wX/KtO/gz+Re6dO0YHnY0r4q/J4xNOxL/tSCTitVgLPUWk6vgFm1fipBKCZbViZU3djPhc300SGBz0QgJ1WpapHtAgRKp0L3G9QBSmhU1+bVUkEmBhT/p+zKfAGOrONehbAN1HVC5Pfn90ljnOondOqvPlCHvsdpfAxvD1aPRbsW1aTKAZe838dxj0bvSs8AHclvBWlb+v1yCB9X/+YZl2S/0V45o2zyccUYokrVK+gg6628aimlFEtYR6dNKJMSYV3csei3bPxOG5qGgNQtzvwQjgUWNVzKZ5qRjGeYbcKSxmjB8Pav5jpj9TLefi6uJwmxDcS4gmQw67Xe2jLj+tBVdx0BbFg5UBtfho6++hEwjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 5:32=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com>=
 wrote:
>
> On Mon, Jul 27, 2026 at 12:33:49PM +0530, Dev Jain wrote:
> >
> >
> > On 26/07/26 4:16 pm, Matthew Wilcox wrote:
> > > On Sun, Jul 26, 2026 at 02:23:20PM +0530, Dev Jain wrote:
> > >> On 22/07/26 7:59 pm, Dev Jain wrote:
> > >>> The vmalloc allocator stores the actual allocation size inside the
> > >>> vm_struct structure. We can use this bound in usercopy instead of t=
he
> > >>> page-aligned va_end to catch usercopy beyond the actual allocation =
size.
> > >>>
> > >>> For vmap, the requested_size field is always page-aligned since it =
maps a
> > >>> certain number of pages. Same for vm_map_ram (alongwith, not even h=
aving
> > >>> a vm_struct). So the check is only relevant for vmalloc mappings.
> > >>>
> > >>> Because there are early vm areas registered even before vmalloc_ini=
t,
> > >>> requested_size may be zero. So also check whether the requested_siz=
e
> > >>> is set.
> > >>>
> > >>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> > >>> ---
> > >>
> > >> Sashiko:
> > >>
> > >> 1. "Does this locklessly access area->vm after find_vmap_area() has =
dropped
> > >> the busy tree lock?
> > >>
> > >> If an out-of-bounds pointer falls into an adjacent vmap_area, and th=
at
> > >> adjacent area is concurrently freed by another thread, its vm_struct
> > >> is freed. Additionally, when the vmap_area is moved to the free tree=
,
> > >> area->vm (which shares a union with subtree_max_size) is overwritten
> > >> with an integer size.
> > >>
> > >> Would dereferencing vm->flags later in this function cause a use-aft=
er-free
> > >> or a wild pointer dereference?"
> > >>
> > >>
> > >> I don't get it. So usercopy is checking OOB for an object but should=
n't
> > >> assume the existence of that object while using it?
> > >>
> > >> It is a bug in the caller if someone does vfree() while usercopy is =
operating
> > >> on the vmalloc object. I don't think usercopy should handle it. For =
example
> > >> we don't handle it for slabs currently.
> > >
> > > I think the question Sashiko is getting to is how we handle:
> > >
> > >     char *p =3D vmalloc();
> > >     copy_to_user(p - 4);
> >
> > Thanks Willy, I completely misread Sashiko's point.
> >
> > I think this is an existing problem? We are using area->va_end currentl=
y,
> > so we can access freed memory.
> >
> It is a bit mess here since now we need also take into account a
> requested_size due to vrealloc. We have requested_size, nr_pages
> and size in the vm_struct.


I see that vrealloc() always updates vm->requested_size to the new size.
So we could always use requested_size? no?

void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned
long align,
                                 gfp_t flags, int nid)
{
        ...
        if (size <=3D old_size) {
                ...
                vm->requested_size =3D size;
                kasan_vrealloc(p, old_size, size);
                return (void *)p;
        }

        /*
         * We already have the bytes available in the allocation; use them.
         */
        if (size <=3D vm->nr_pages << PAGE_SHIFT) {
                /*
                 * No need to zero memory here, as unused memory will have
                 * already been zeroed at initial allocation time or during
                 * realloc shrink time.
                 */
                vm->requested_size =3D size;
                kasan_vrealloc(p, old_size, size);
                return (void *)p;
        }

Best Regards
Barry

