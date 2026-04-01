Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F2110FCAC9
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3F86B0088; Wed,  1 Apr 2026 16:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B817A6B0089; Wed,  1 Apr 2026 16:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45B66B008A; Wed,  1 Apr 2026 16:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8786B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:22:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0FD50C0946
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:22:56 +0000 (UTC)
X-FDA: 84611110752.01.48F9145
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id DBBD040009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:22:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kh9nIqIm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775074974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2bgtfIq1zRS0GcFj3J4C74dQe6vGPo8AFkp0eGgx56I=;
	b=baq/Kpl9JMK8/LMTFEuw/pRwZ1WkpMMBsYhTlaRA2qW6gCD5/4NhJ4JdkRR8W+kR/XCTqC
	ne0UxbpQjg0LG2vgGalxJ6jZUuv/QAHT+R5sou66N3jST4y5lfW52aKeoOaChyIAZUnnZf
	VL574qYa2BUTYo7YrY+AElfrsfZ3wPo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775074974; a=rsa-sha256;
	cv=none;
	b=Lm4ooxCx+cICb3SYmlqUWd5JdVXQNhuyi6uhSZRmIRaxTs/TLzrWDt6a2ruidfkeLGqyeA
	qhucd6WhTGs+jjF40kH+H0ifiB/16FixNZleECC7qWVpUAGv+U8N8Lw5zbgypX5MF+5sKt
	XIVuBAzsNcF9cVGUdVNhUIkkQKLBemE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Kh9nIqIm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2CA0432C2
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B04C2BC9E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775074972;
	bh=N1dSuIgj7e/PoIrDkyO9MUAKq6GumfQ0T+iWjsXaZt0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Kh9nIqImRkvQZJAD16JbmjAiy6a1usqifi+ejwwqWIn2AHmMje0N55i3QWoOdBLIv
	 hFXY9iMGVh47QIGFSXmlw/pO9eMfvspCJd6aaqDNBkf2D1koZbiCrDTF460qKoYEtH
	 52IKTtu5dkuKofoOyKi+BnzVvKYBsoIe69Yg6BMhs+90/YqOf5df3Lq5OEPjCsrZh2
	 DBRNG2cW0WsdZo/Ow4k8z+hS31WJML1HCHWqmVSPaw4pAPBXCetN1dj9EPcyprngKC
	 l4tXY6j7vnsj+B5XWCh5QtOH2Q3FGhgXoWfA9m+1lObMjnSBKypSZFb9JYz6HCYQiu
	 rILbvWkXk4osg==
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-506362ac5f7so1113801cf.1
        for <linux-mm@kvack.org>; Wed, 01 Apr 2026 13:22:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVWlhGlTPwdykFdNQ0l5rUxwiarHdBbSGDk2nAkAnKUL/lgL7kyaicpSd3B5V3HX3OoqhiwnyKgAQ==@kvack.org
X-Gm-Message-State: AOJu0YwAzRYqIfBEF8wCRcwu/t1aMw4cBYbFI82O+QBOTpTSxb0B4zHy
	xoqW4tSjDATuwk3ZcWpeWuYRdnrE7PiyOdpp0+TLNDI0AxsgOXAbngn1VD88+mY3D9oA6J7h9wW
	qO/WvPTXJklMKm+g8kfYsZScFqOuuUe4=
X-Received: by 2002:ac8:5811:0:b0:50b:8deb:6a3b with SMTP id
 d75a77b69052e-50d3bd09e9emr70551201cf.57.1775074971885; Wed, 01 Apr 2026
 13:22:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260330071229.14614-1-devnexen@gmail.com> <CAGsJ_4zpre2gUcYdZxY3s57=ESf_av59L+DNCYd0hZ3UtHNvSw@mail.gmail.com>
 <CA+XhMqw59iWLPQba5WSaF5Y7HKDgf3BjjBLn_X=w=g5tAk26-Q@mail.gmail.com>
In-Reply-To: <CA+XhMqw59iWLPQba5WSaF5Y7HKDgf3BjjBLn_X=w=g5tAk26-Q@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 2 Apr 2026 04:22:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xqmCPCTnWNvxp+fTFgnJT64oOxFVNBnkVVBKOW26K7-Q@mail.gmail.com>
X-Gm-Features: AQROBzBoOjM5D-IXgae6XgnRkEpJbpi97gBWlUDLzHjnzkQ_MDvqB4MSuYBGqgA
Message-ID: <CAGsJ_4xqmCPCTnWNvxp+fTFgnJT64oOxFVNBnkVVBKOW26K7-Q@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_io: fix PSWPIN undercount for large folios in sio_read_complete()
To: David CARLIER <devnexen@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, NeilBrown <neil@brown.name>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DBBD040009
X-Stat-Signature: f7b8ahs85ufed6a3qwhn18i1gym1mxoc
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775074973-377843
X-HE-Meta: U2FsdGVkX1/Vin5GGlNlZB6Wz7lENzx7lTXA8rNmPpj3wICHU2n2HQTiUuOGyTlrqqnK7AqIGcrroiBh3DCWl0858UuSBUL911Afljc/cAhz1/A+zEgPDOwrSoZB6Lt8EQlU9VRCrC1LpPKGGtFiAD0s/WvTZKcYB2Oijp692cf57e8+UIU+WVxwLYLPYX6ATIDePQ9/ivITrmwcN0UuwlseOzmxZXgTzh04iR0YeRI9/d3/toXWoCVzrhDym/Tpsko2IYtR3aAO+3R1yZt2dP1zD1/X+7tqgCN5ARsvdN5Pjy8HtzEk8JSPf/9tNWTilXJlEgjHCqmNDeTGP7tTWCmVrHgSsrtBzi1lJARFP/bDcL7U1NEiPJ73OWInSay30duzPZ5jy779Miobb2w3jGGDw8P2ApgaFtIU/vS2z+hRX4zZlzjlC7a/67R1HYDoBW+gpe3EWwZT2bSbCBagEb95uHodxn27CXuNiKhIJkW2RdXXkO6GXhC0q3sC7u4hHbF8KUU7Sx6KQ5lI9C/qo7CjGyk3a8NaGLIG8KF8d0vCLtcEq0LJx3G7LKtMbExbatgGU64THZBPex8JF+TVh+mgxlS5tzwZnZa5Ci2SlIMQuw9OMETNXDjB5onf4er5a5DrbbpAS+F7BtCVEtGVedhBrQOUViBRtOkt59CurAJO7+z3V+VuS4kDYWi1ZvlQbnf5VQu9KOopo7bxwbkvZMxiBjaaPoXTMYF1Lv20hcSV7xoVFY7P+2xrt0KRv7KMy+pQ0CVYkKEohyMGyA6EJqprt4rwTuuxXhXRnQ1bKZ0chchVUwJ5/ADveui2HJf9vNHRA3ufEzLZcqWTxnxFXKW1IoL3w6ozCieop7q44Wm+0pLDSzPH6PQMsFAaReOX+qvII481mPMwtpcgOJ9FtO+mT9nWk50iOwhb/Yzv0DDLL0Y95uKFpeCPsiHqW82uPQIjTgDA9n+v+e0qX+/
 kbfbxSWc
 gdAWMn2rrG8quNaO6QtDIX4P1oDAsMn2vq3T3oa+3kgBdpcBzGoujV69F13BD3svSqatYFNC4PA6ij61v3/oqdslu8LUI3tdDnZRkksKSL2Ae3jGvc9828mEpDrTRwl3SGWfXu0fG5TsBQDJL6tPGEqfoo5uH6z1CbrDN3SDc79sWD1cebRLKZwekSpHuO1I9+L1wRgz9qvnRn1RRR5CiXMhRY4zEdn6MEkKtPHFJ0NPlKoMIIJfpJpKbMx1p64cNUJczWQZKEZWkW+i0Dt6G/JPb26rQkz7Qj4HrDDgR5lLLFgJR8Mt4ee3ukhFzOU6mrhtFmIopMcTTC0yfbrerSOO8vERcG/HVkjysBAUK99hgXNRpvr60eI/8sHAc7P/0jmyQDuvZxJusOcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 3:10=E2=80=AFPM David CARLIER <devnexen@gmail.com> w=
rote:
>
> On Tue, 31 Mar 2026 at 23:33, Barry Song <21cnbao@gmail.com> wrote:
> >
> > On Mon, Mar 30, 2026 at 3:12=E2=80=AFPM David Carlier <devnexen@gmail.c=
om> wrote:
> > >
> > > sio_read_complete() uses sio->pages to account global PSWPIN vm event=
s,
> > > but sio->pages tracks the number of bvec entries (folios), not base
> > > pages. For large folios this undercounts compared to the per-memcg pa=
th
> > > which correctly uses folio_nr_pages(), and compared to the bdev read
> > > paths which also use folio_nr_pages().
> > >
> > > Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> > > count since sio->len is accumulated via folio_size(folio).
> > >
> > > Fixes: a1a0dfd56f97 ("mm: handle THP in swap_*page_fs()")
> > > Signed-off-by: David Carlier <devnexen@gmail.com>
> >
> > The patch seems theoretically correct, but I=E2=80=99m wondering
> > where we can swap in mTHP for filesystem-based swap=EF=BC=9F
> >
> > In both do_swap_page() and shmem_swapin_folio(), we check
> > data_race(si->flags & SWP_SYNCHRONOUS_IO) before allocating
> > large folios. Am I missing something?
>
> =E2=96=8E The patch seems theoretically correct, but I'm wondering
>   =E2=96=8E where we can swap in mTHP for filesystem-based swap?
>
>   =E2=96=8E In both do_swap_page() and shmem_swapin_folio(), we check
>   =E2=96=8E data_race(si->flags & SWP_SYNCHRONOUS_IO) before allocating
>   =E2=96=8E large folios. Am I missing something?
>
>   You're right, I missed that. SWP_FS_OPS is only set by NFS and
>   SMB which have no bdev, so SWP_SYNCHRONOUS_IO can never be set
>   alongside it. Large folios can't currently reach this path since
>   both do_swap_page() and shmem_swapin_folio() gate mTHP allocation
>   on SWP_SYNCHRONOUS_IO.
>
>   That said, sio_read_complete() already calls count_mthp_stat()
>   and the per-memcg accounting uses folio_nr_pages(), so the code
>   seems written with large folios in mind even if the path is
>   currently unreachable. Using sio->pages (bvec entry count) for
>   a base-page count is still semantically wrong, but I understand
>   the practical impact is nil today.
>
>   Happy to either drop this or keep it as a correctness cleanup,
>   whatever you and Andrew prefer.
>

The patch looks correct, so I=E2=80=99d personally support keeping it
after cleaning up the description, as David suggested.

Best Regards
Barry

