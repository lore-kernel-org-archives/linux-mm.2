Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76981CCA470
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 18:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF1F78E0012; Tue, 30 Sep 2025 14:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9578E0002; Tue, 30 Sep 2025 14:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8378E0012; Tue, 30 Sep 2025 14:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 981CE8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 14:39:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5482F1A07EB
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:39:16 +0000 (UTC)
X-FDA: 83946779112.17.D1B59E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11E4340014
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:39:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BdqRu4TM;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759257554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOcI1ZIbD/HvHYX2YhFw02/XoFtTTRUFMmkH7W3cd1M=;
	b=O+kWRf38Q0x9uArJMn2QGJo8QwTok5UHC/KkbXKL/Bq21TT1UelXKVcyDBDBqVxQu0rzH3
	ZLVC7yiY+xM7khkAsoy3A5VF61Y3WhIm3DEQ++6OyTbeQJEJvLBDyAWfyIiy4+upaW4FpE
	mQf6T3jgEH0fNc+B7Jx7aLWfWjfCYXQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759257554; a=rsa-sha256;
	cv=none;
	b=NupuYeRw7zs6Iy3xCbdR3IHzVYTDf6H+UmjLSUotiayOjr/X+ZN1ZI8tAurgm9P1oazDjN
	pp/zVMujPx2YqiQlf0EDva+oI0d1K75HjKgtis/DB5xUksEcuDerJqAcpVZZarOU6jzaRO
	9dP9FMa5WlQ4Js6Oy4kBGItlfLwmWWA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BdqRu4TM;
	spf=pass (imf01.hostedemail.com: domain of peterx@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759257553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eOcI1ZIbD/HvHYX2YhFw02/XoFtTTRUFMmkH7W3cd1M=;
	b=BdqRu4TM5RPp+ZKTCMH1H1R8hB+IntqL0kCSFVGpQbkWxudc6DBZdjC+TZJWGVaXT5oQOH
	z4KGaSeMoE2aHUC2RBAlr3XFfwS+an/FY5yWt5FeVSEWsU/Q3lJ5F1HSWYJExR+Xx1TCfS
	C7sgEVC7HrM0mnQWwHEI+58CwByuQUQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-O7ZNyZpGNUqsKFqDrUTLqg-1; Tue, 30 Sep 2025 14:39:12 -0400
X-MC-Unique: O7ZNyZpGNUqsKFqDrUTLqg-1
X-Mimecast-MFC-AGG-ID: O7ZNyZpGNUqsKFqDrUTLqg_1759257551
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-78e30eaca8eso178367796d6.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 11:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759257551; x=1759862351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOcI1ZIbD/HvHYX2YhFw02/XoFtTTRUFMmkH7W3cd1M=;
        b=ks1PcF/rOOiwD9ekpbot4459OwCom4134zKjrvBOyxa60qWLnb/CDIObuJR/wHuDC5
         HBvSJXc5YutmU7XPnzc0yUP/wFyQhmm50Ka1GAxbH8UYeKF7VviltDjTXlp4iJ36oLk8
         vXNvrT/cTVNWMxSdSaQdAwCIVXgT89J9u+vZ/NB0H0ZHo4nnu0VSh6ZEqaTilObxWotK
         EY/BQ+VTYK6UunbIE9quOnJTQqObrrjAqfsoUzzN2oGzqTkLfPhmgyTD2RLXxcVJtUwG
         FT8A2wYLxEdCAs3lesYpgO36AKfLIJ6W3F4nAE+8/5L0BwGNwUYfBGwW8MfmFJkpUmP/
         gkBw==
X-Forwarded-Encrypted: i=1; AJvYcCXyjpG/eLOG1uEh8Uk9gJ9J2CY6NKEgsVoxtXUaam4v6XqNnOC1V7L0cB5rqVSTeTEslfsFxhEa8Q==@kvack.org
X-Gm-Message-State: AOJu0YwS/5dfO9gbLJGewQvmaXqr0pE3OXm6axHrgnibMbn/LvpmY2Oq
	nha0c8tmjnCL8Lj4pYucDG5/722aH4rSaU4NcvmFA5UW5iTci5qgS3lWQz/aZ01CNw/0pvuXcYe
	wW+8Zzwop3y05tnHbCrbrj3AxCCBM5DYUS2Uzkl2VinhEOzddmk3lPu0XU0Wk
X-Gm-Gg: ASbGnctaQBBUSdMFWBlveSXKUZL1YN83xdqRc1kh1rLu89+VrjVr4vchvU1dQnbLqtB
	jfhYd4RuRM4wJEOrDULBIIFDsdg4euJ2y3l+Iu+wY2kJK92tSKT5nWIqn2L9eRqLSaxNuUWoTUc
	LIxSu9awjVh3dQf9iIAPA3LNGbJf4Px2YOoezKua/2j4NjuS5JLtZHtPV+R/nML/wG12NKcm7tA
	Yx5zqMZc96F3WdQePLt85MSmhvMy6FcRC0rv+ydKRPsKFkfgm1Eh/ZK9jhD9zDls32jUbs07zQg
	4q2UsqH79hbTO1IYfBl5Ro7WPOpmoK7eb/wzHw==
X-Received: by 2002:a05:6214:f25:b0:86c:1f66:e2eb with SMTP id 6a1803df08f44-873a4dca4ecmr9343196d6.33.1759257550941;
        Tue, 30 Sep 2025 11:39:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IElCA+Ys8V7FHTo8o4fXzI+Tp8Ue5gMs0OVn2KTplxlHdrIW9wKkjuDv1J29s1qR50z6aY/Dw==
X-Received: by 2002:a05:6214:f25:b0:86c:1f66:e2eb with SMTP id 6a1803df08f44-873a4dca4ecmr9342926d6.33.1759257550445;
        Tue, 30 Sep 2025 11:39:10 -0700 (PDT)
Received: from x1.local ([142.188.210.50])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8013ca1f1desm100257506d6.23.2025.09.30.11.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 11:39:09 -0700 (PDT)
Date: Tue, 30 Sep 2025 14:39:08 -0400
From: Peter Xu <peterx@redhat.com>
To: David Hildenbrand <david@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Axel Rasmussen <axelrasmussen@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>, Hugh Dickins <hughd@google.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v3 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aNwjzC1mlnHwEgsd@x1.local>
References: <20250926211650.525109-1-peterx@redhat.com>
 <20250926211650.525109-2-peterx@redhat.com>
 <f1da3505-f17f-4829-80c1-696b1d99057d@redhat.com>
 <aNur9nbdnlykqbU7@kernel.org>
 <186ef2e5-bd0a-46e1-a88d-2fc5448c1c72@redhat.com>
MIME-Version: 1.0
In-Reply-To: <186ef2e5-bd0a-46e1-a88d-2fc5448c1c72@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZFJwLoatKrZa4nnBY9v7aDbD9MbZ8Lalf6m7bDnaZSY_1759257551
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Stat-Signature: oeqs3de1wynrrym9pnohd1i8tgzrypkq
X-Rspamd-Queue-Id: 11E4340014
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759257553-5668
X-HE-Meta: U2FsdGVkX1/+PjMf9G5Wx7r5Wb5aFVHFKpMz1wPC8Qu5NRyfy2Xkix6fnVFV7gfrZjvq60T5z28Xg0yG1u5rHZLMncIQqASURSwg7VsEZtSnGVbpG0DZj2SOgvwoDZnzoOiCD+wP0s7PEZKtJsQ9X6ZNFewmRBECVllsrOMHN+j5lV3qyeLNiji143NHzE6Z2+PTcmolFns5Iw0AfDR/lPZ2GtQn86NLSQ4WczmOwcXxcVJeD2dw/TqztggcHJT945YBeZPOpQrCg9oOJCD7gpDH8GQSug9ZwDIcSlVYq8m2s4tI3IuUx5Jh3TvJGu3iFeTihH1Kqoocs78GI0mESEIbZquveYCUjDw6RoDKVORnylBmvvyvSp5JRy0AOz0PQD6/lZSKi3DBv9ybpatOkw0DmIgpEuSB0VlJk75LOhbg0oGGyYSXsALMQkqC3xAyfhf/vfUdHjjDqrFFrafhkW3gnRYX9rmkYVZ+oUtyvqoGypbvRD7kWjRg92eD61aBOH/PmH6ODJ8bjhWGcQYYeTgkaj/1mm+xbgOTntLkMaMlAANfbL2Ju9qmK7t0GUs/YDRWfcsOp1f5BQK+4Gn74L64vVPQPheQMdMLeIFC/zp70NEXe/anx1xRmF0njhlXQjKscTvKctUAvQouYgsNdXzOO3+5H6K17QhFVoL2Vqp5cz7V3TjFVp99FQ3iMWSyQ4sGlMDBzfVmyYH6P1mdiGcN5NVEyf248ie2w29FmIJCuEqJtdkp73ceKtdCaajcwFcfLEDjbo9eDxVd63paPYPjplqXNKROMZcS5vMZrhqsgLScrl5mUHrT3c9vZyvflv8sTNPOUrR0tpWtTk7Kr+rjyoC7Sgw59hQDqIT0nvn2q1JiQSrh1yz4AeI6jaRTiSor8JK7c/wXw924gylS+QI++pduYMdotO+xqmwaVy3GOfmA0Gu35PC5TiApPLfyONEZUfu8FIJ/3tPzgxh
 aak0ZowO
 XUaiHqm43t2o6Kvdiuvfzg2XPYySyOgyHsCeuWoizuLbV2p/WGO/8Da00PqBUkbtt+bjLGpUI+IKzKM6TdzEO/rdecSWcQ9lo6r9xgaOioWiC2QnZT6D5rKjwo5pXqZarSGkwj2s1BJN/uf8xZfGkZfU+Nv9TXiJAWHYSkf8wYoj7PuXbFH7NVaz5vpnJMaqcHns65yGyI8hZrp/LbyaaHXYk1qML8QscV/WAt1J4BVGhWY3+M50krbXN/VbleB+8iPtu7bDbNiQUzrrhjuFnUYINyM+GhUGerudB0t7iMz1sBG2HEUIabBhseOL39RW8CV21casBs7Cu5d4BpJPR5K2LrvWH9BJ8lI/TOVbgQNNep4pCadnwWZ21+Ukmum/3LOHPnx7ittI7rXsrnkwG4TPqKoADiRjgE5NxOgeZi/Wk834F6juexS+bExClGoGYp/Tbef/OhE5pps6nLotwq7S+ufuuWEjzMaXRQ0X8Td+/Usmi6QVYBVJyV56HE3A/3brHZiXu8HLkhYUtzcYBIFIkIvlQuGg/9qu4E8X242IjRbqGgP6dkRPfgZiio6xVBC+QwJFqdUP9FpI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 30, 2025 at 12:18:37PM +0200, David Hildenbrand wrote:
> On 30.09.25 12:07, Mike Rapoport wrote:
> > On Tue, Sep 30, 2025 at 11:36:53AM +0200, David Hildenbrand wrote:
> > > On 26.09.25 23:16, Peter Xu wrote:
> > > > +	/**
> > > > +	 * uffd_get_folio: Handler to resolve UFFDIO_CONTINUE request.
> > > 
> > > Just wondering if we could incorporate the "continue" / "minor" aspect into
> > > the callback name.
> > > 
> > > uffd_minor_get_folio / uffd_continue_get_folio
> > > 
> > > Or do you see use of that callback in the context of other uffd features?
> > 
> > If someone picks the gauntlet of refactoring the loop in mcopy_atomic()
> > we'd need a similar callback for uffd copy. And as I see it it would be
> > different enough to warrant emphasizing minor/continue in the name here.

Sure, I can go with uffd_minor_get_folio when I repost.

> > 
> > I also think we can drop uffd_ prefix for the callback, as it's called as
> > uffd_ops->get_folio() or whatever it's be called.
> 
> Agreed. I got annoyed yesterday when typing vma->vm_mm often enough
> (vma->mm! ).

That's also why I kept uffd_ because that's the tradition mm/ uses in many
important data structures like vma and mm.  It helps most tagging systems
that most Linux developers use to avoid global name collisions.

So I tend to keep the prefix for now, until we want to switch away from
Hungarian-like notations completely. But let me know if anyone has strong
feelings.

Thanks,

-- 
Peter Xu


