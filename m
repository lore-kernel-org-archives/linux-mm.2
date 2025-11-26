Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75663D111B3
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 23:16:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241C86B0008; Wed, 26 Nov 2025 18:16:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2192B6B000C; Wed, 26 Nov 2025 18:16:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12F6F6B000D; Wed, 26 Nov 2025 18:16:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F378E6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:16:37 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FF055060E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:16:37 +0000 (UTC)
X-FDA: 84154319634.12.CD0D687
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0611840008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 23:16:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UxUmBwc0;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764198995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMaoF3gqsWu97KKNF9bqDelTF6faCcdLQyjuhlYWXM0=;
	b=iJNdTkr8LZOD+HSmrKZ0w9ybhlKumLo2pEQ0BuBAUPAIVSEt7KaV2yRgEjE2SEYg9ovlZk
	1U+2M3mrVXH77cqJ8upLbwOadnNkg1yZq1OiDjhEa9Vl6rvgK6byv6kgDVaQSmYTCuf38R
	tlImH89EZ8cpxmGv8admKv0WJHsI6mI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764198995; a=rsa-sha256;
	cv=none;
	b=NVCxuEcf0W3x4LQrfOJaS++IpIYTNO0EUeOeZw/wh2OHFUyXbc4OTO8UX2jb2rhLrJnjZF
	CF2b96P1dqJ/yCK2fj1+YP89jbDzx0hAwTp9tXPWKM+LeSQaoSz6Axao5c5ODAm7B0bdlE
	XckkveU7lX70Hcd2M8wfT4gDrrlbJoE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UxUmBwc0;
	spf=pass (imf11.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764198994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UMaoF3gqsWu97KKNF9bqDelTF6faCcdLQyjuhlYWXM0=;
	b=UxUmBwc0scgZ3JuV3PmX7wpR+XjfoJAmri6ZH4RFu6U3tnAHN0q9zID03pVS6NTedMu7ay
	E+kPFUh36J+O96+csKmKz/VHhIo8ICHb8wfetnHDbSw6TYjz4S49/2MpI3THC9EzifeQ1X
	eRuPfvZsrk2s2yE0JRhtiK/FTjEtV0k=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-544-39HjNX2cNOmKL7PAkVKCHQ-1; Wed, 26 Nov 2025 18:16:32 -0500
X-MC-Unique: 39HjNX2cNOmKL7PAkVKCHQ-1
X-Mimecast-MFC-AGG-ID: 39HjNX2cNOmKL7PAkVKCHQ_1764198992
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-63f9be79c1fso347426d50.3
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 15:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764198992; x=1764803792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UMaoF3gqsWu97KKNF9bqDelTF6faCcdLQyjuhlYWXM0=;
        b=hQWVzpzLPziupDFA+421e0wQrLfzLPNnZyT4RysRSjxAXv8ivK01LYgpIofYCq356A
         m6GUKcclmnFyIxm2BimfkdSU12B9C5Kdv0h+YSrwrvNTIcQzKnD1hGFU5t+u0D55eMUE
         nfRHo3RAWC3HIMz97vHk5j1ypJQRpGY/bEhXZTNdszaNPR1MgX5GL4uKp6HAgCP7HMlE
         qZMOJ6Imvf6QHJ+Fm+eITRiy6SXZxx7nj7hxUvZRVfkMvaLfGyr8y/AWD4kgKCW1VG3j
         w1zVx4L/H5z8JN0yjW96TIHJlgeU7PZFtWvxheQvkoOg5/kk0fmWtS8qxa1jIPK0HUYN
         l3uw==
X-Forwarded-Encrypted: i=1; AJvYcCU8RdyRDKca7n+rwHRQ+x6cJa8zV/RnS2/T0vCToX7xT2a8LQfY6U0kAOiaR1pFoivFd+cBLYfFiQ==@kvack.org
X-Gm-Message-State: AOJu0YzDFb/t/CS8aSiy3V4fm8AVTu+VU4KcOBz+2y2UGD0aG61v0u/6
	fXtreWN0v2njr1V1PrM6Z6ya44euahHDnK329kt0TZjk9yPR+OFQyofeWClVedmMe4Bcqy2Y4Bo
	Rm+YB+1ccZomTrMhbXB6hsMfqDGN3GG4Ce+qhYo/Q0vsXI5jcwrbI2z9ecu/D3VdEQwuXnUr6Qm
	6Txw8Bhg1rKkVSmj2iRSY6LOOvpwg=
X-Gm-Gg: ASbGncv3UOMMkLnq5+gtRbvyr+Q6w3ZBiiU55b5aK/Vx17cic1FNKHDAnT3mEVThCy/
	qcHYZ1M47B6PdeHguvc9u6ygtEEztN0Q8LoaiH3CmY40XubYLH6QCvLRl0TK2XU6bbpW5a4w8xX
	/yh3KvDhW0gDf1eHj5e+ELneRM/9EbIZFIgUPyCsWj6FROM1fRQtJIcc6TH4A2fmgQ88T8OxLi7
	Q0AmDb2
X-Received: by 2002:a05:690e:155b:10b0:640:d3ef:3ff3 with SMTP id 956f58d0204a3-64302a8eefemr13305125d50.15.1764198992066;
        Wed, 26 Nov 2025 15:16:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH+QNGPicU5RjAdYvjG9xbNevC686kTjk8osJQTtyywrSV48lnib9InZNM3p9uysXVeTAEWqukeejzM9ZXOnQI=
X-Received: by 2002:a05:690e:155b:10b0:640:d3ef:3ff3 with SMTP id
 956f58d0204a3-64302a8eefemr13305111d50.15.1764198991685; Wed, 26 Nov 2025
 15:16:31 -0800 (PST)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-14-npache@redhat.com>
 <541a75fe-3635-49ab-b61f-d86afc96df98@lucifer.local>
In-Reply-To: <541a75fe-3635-49ab-b61f-d86afc96df98@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 26 Nov 2025 16:16:05 -0700
X-Gm-Features: AWmQ_blxvg-ak975oHQTjlFuUq6n3qiQLej596rC0gzOd4D75sF38pXcfAMCpNA
Message-ID: <CAA1CXcAhj3UKqjGLVCOwGmUY=eDJSnvMZO+byF9b6GJUR9gRiQ@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 13/15] khugepaged: avoid unnecessary mTHP
 collapse attempts
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	akpm@linux-foundation.org, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: EYZG3msmqCdGlI_yHs2__cQWwEKLtCHdvl65Ss1a2i4_1764198992
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0611840008
X-Stat-Signature: 56x71m48pkt54xtsqruy8uxd5xmwoo1n
X-HE-Tag: 1764198994-723970
X-HE-Meta: U2FsdGVkX19H8hiLq0HI9O241fEAZv2nF1SI9cY//+Hmx+kF0R9/TTrvdsoRY+jaE2ke0dcXjzvp+IY4faj+ttwP2orjlTVjibIznTkH/uKtaj61BxRxLKeePhmO4Do0cENf2auCNcbo5I+jrMVaui1yV1bRAm7oow4I2DD9Im885uPGXPqBz/qddsjg+WG+fszmNh37rBvVqT4efYm42JgxQDPygPTVmUpkIX/VtglUjFYtBxb5bvKkQvK63Kr+E/yfdymrxjLDtIT+JY6oh6vLUCBLfU3Ggb3s5xDCKPKF3R+70RUuvwp2m4xXtQOnt7QIoADn9ZxKIukOWtosd3JRfgMdffUkWhRkZOvfBu8Fc+prVraG0eyXEwYo7P0EFf4c5WY57pKoqdFIf/azEgAkMtq2qNo8JBZ6Fs+I7jfHHCzv1MGIknubxT/o9EXKXfvbzajL+7WsC/+gtraj2VHy7nZsTv1KezYpVpX053DtEWYzx8hE4krBb3tVSfOPgM0gLC7gbISm9oaOQhuUpH+ITFK3ycvMdBBFov+9RQWRBc7g86/QToRK7/0jtevX05cwvf91cFtnuKrrk6wHyPJMeWbZyjrRWExWqofOL2fNYd/CaZ7BMqG5f+8NMFHhNu/G1ffNYL7p+5uhPDggTS84j66q6y0hvBo7ebzgBYn4Z2PJOuAhd9gb5i1MBbEvJdJhnlk0kl+VXhDV56PBBKPLl6twudAgQ1OxmQpTjhNJRxZoiOUHA5ngJjcWxrGq2hjcveXic+fUhjqno7asYDjIQAiDlUF5cFMMkSuIs+U8ll4xtufGhADurgPTDPWd6lLNtcyPnj5wHOguXwkkA/NxjHYQfJ75DlwXRmmClp/Tf2VxsV9hgnt+L2F/Zxw5L1KJyDXTAcqd4dhDJmOAmWOCyY1HfJ/4H1EJT2iaTeDg+MRVDA7L7E9P+NdsAapxabqgBbAh5W+iuhQoxJj
 4XjSexBB
 +5ZRJOp85N7hq48UmMel3Js21dNSVT9PXk7LUvK3lrF+rKGeR23pTrk0Ic1Yu2v3kgyPSAlDFxe8ywrmrgdjxzBSxGIK3gTIQ9M1rMcC7xUmVOQZ3WNQ8qHcd/il6ZPJ0wiUEKMSl7SqlKgcl2d5Frajr4c5drGKCOwN1OyaA9UG7rtGLVK+IlNzygiUn8sHztaDY3kJSNDxOgswRnmHBiBp14YE6sN+MzvecLj5j+3ir4ROvR/KjISg3Oug3JC/gk25MH1U92siu2HausBqXx8A1ULCXdJCOMxs2aCizPXfIMaduLmUx9iCL57A3+VWaDtUEtQgnC58J6waB7zFwDX62cQNRAdn0vxEma/qOjZNPax3pc4ERoSPHbfQOLudu1kGvVv03VyK3zOiBn60GKslon/FD6TY3WdyRgtC8/CbcAFI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 5:06=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Wed, Oct 22, 2025 at 12:37:15PM -0600, Nico Pache wrote:
> > There are cases where, if an attempted collapse fails, all subsequent
> > orders are guaranteed to also fail. Avoid these collapse attempts by
> > bailing out early.
> >
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
> >  1 file changed, 30 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index e2319bfd0065..54f5c7888e46 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1431,10 +1431,39 @@ static int collapse_scan_bitmap(struct mm_struc=
t *mm, unsigned long address,
> >                       ret =3D collapse_huge_page(mm, address, reference=
d,
> >                                                unmapped, cc, mmap_locke=
d,
> >                                                order, offset);
> > -                     if (ret =3D=3D SCAN_SUCCEED) {
> > +
> > +                     /*
> > +                      * Analyze failure reason to determine next actio=
n:
> > +                      * - goto next_order: try smaller orders in same =
region
> > +                      * - continue: try other regions at same order
>
> The stack is a DFS, so this isn't correct, you may have pushed a bunch of=
 higher
> order candidate mTHPs (I don't like plain 'region') which you will also t=
rue.

Ah yeah so it should just be try other "regions" or in this case we
want something like "try to collapse another mTHP candidate in the
stack"

>
> > +                      * - break: stop all attempts (system-wide failur=
e)
> > +                      */
>
> This comment isn't hugely helpful, just put the relevant comments next to=
 each
> of the goto, continue, break (soon to be return re: review below) stateme=
nts
> please.

ack

>
> > +                     switch (ret) {
> > +                     /* Cases were we should continue to the next regi=
on */
> > +                     case SCAN_SUCCEED:
> >                               collapsed +=3D 1UL << order;
> > +                             fallthrough;
> > +                     case SCAN_PTE_MAPPED_HUGEPAGE:
> >                               continue;
>
> Would we not run into trouble potentially in the previous patch's impleme=
ntation
> of this examing candidate mTHPs that are part of an already existing huge=
 page,
> or would a folio check in the collapse just make this wasted work?
>
> > +                     /* Cases were lower orders might still succeed */
> > +                     case SCAN_LACK_REFERENCED_PAGE:
> > +                     case SCAN_EXCEED_NONE_PTE:
>
> How can we, having checked the max_pte_none, still fail due to this?

There are two phases in the khugepaged code, scan and collapse. in
between them is an alloc which requires dropping the lock, and
reconfirming values (in the collapse phase) after relocking.

During this time, the state of the PMD range might have changed and
our thresholds may have been exceeded.

This was true for PMD collapse and holds true for mTHP collapse too.

>
> > +                     case SCAN_EXCEED_SWAP_PTE:
> > +                     case SCAN_EXCEED_SHARED_PTE:
> > +                     case SCAN_PAGE_LOCK:
> > +                     case SCAN_PAGE_COUNT:
> > +                     case SCAN_PAGE_LRU:
> > +                     case SCAN_PAGE_NULL:
> > +                     case SCAN_DEL_PAGE_LRU:
> > +                     case SCAN_PTE_NON_PRESENT:
> > +                     case SCAN_PTE_UFFD_WP:
> > +                     case SCAN_ALLOC_HUGE_PAGE_FAIL:
> > +                             goto next_order;
> > +                     /* All other cases should stop collapse attempts =
*/
>
> I don't love us having a catch-all, plase spell out all cases.

Ok sounds good, quick question, do we spell out ALL the enums or just
the ones that are reachable from here?

>
> > +                     default:
> > +                             break;
> >                       }
> > +                     break;
>
> _Hate_ this double break. Just return collapsed please.

ack, yeah that's much better. Thanks!

-- Nico

>
> >               }
> >
> >  next_order:
> > --
> > 2.51.0
> >
>


