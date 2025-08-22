Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 610A7CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 23:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FF58E001E; Fri, 22 Aug 2025 19:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800E98E0018; Fri, 22 Aug 2025 19:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0F48E001E; Fri, 22 Aug 2025 19:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5887B8E0018
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 19:20:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7FF783A8A
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 23:20:57 +0000 (UTC)
X-FDA: 83805965754.11.3AE763A
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 03A961C0003
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 23:20:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iW3tJ0qZ;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755904856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sh6IXcuBHAVTh39jo2RRgKkLW87v0FUt1zqpSwM4a0=;
	b=FIrBro4G6VLMJ378j60q49mbwljAW2pIMJCLvB+sHzUDjIIWlTtGdoNxLy9N5VJNA/Nuk+
	q0/nsZE2hG6YcmA9n0gpSJgUkfuQHoc+3etcd2zQSMYQKZ5IEEJaUpqBd/fWw8dCFQrMOu
	LUknqktGaXZyklfCZCRsQE37kQN5EqA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iW3tJ0qZ;
	spf=pass (imf18.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755904856; a=rsa-sha256;
	cv=none;
	b=m6K/r6XfA7Sdssq3tx0QP09fQCP5tpT6q/ESc3qUDNkOl6E+dZ5/J9aUSIcqnvlczGe8Gn
	RuHvtsLec8IZq0z1fPxUZT3PYYwQ859z+XkYOxR/a0l+g30su2ZpMb7yhrKdfHpCwuYRMN
	nUcSyEnlxdWE/CIgRppv/E1hbWzC1wk=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4b121dc259cso20617781cf.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 16:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755904855; x=1756509655; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5sh6IXcuBHAVTh39jo2RRgKkLW87v0FUt1zqpSwM4a0=;
        b=iW3tJ0qZjaQdE01fBJsldKvpjmsCEeMe/eggP3zFwr74h6GXZmgsTROETr+MsD8ndo
         0yv72lYr1I8nvr7opek8LN0Ii2N9fWEPpcYHwT6ffkUVeVWpFXlg4CAIohv3ZGKeN8J7
         Qpr895wP5ldAgEVmP6+8xGKORcv2Huc76ph61Pj4q6rQVLsY2W3N5Djp4rikweseLOy5
         lcE9PE7KnOoAYZb7TVua54f7RNaCzx8vIobOcKPIpRDxnBsuzP/ta2VpQ0i3+54QUZoi
         BI248g+7cgHoy0ZOip/cuqEpyRJEGdRKVkNrbEonOUsR6CqSLvBqRT+/nEcwEoNTT1DO
         Zh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755904855; x=1756509655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5sh6IXcuBHAVTh39jo2RRgKkLW87v0FUt1zqpSwM4a0=;
        b=DC3dVHHXs83H9J8Hvd25FHywcg/oHpiGTWIEaQZOwV2cr7QY5+00aIfXa3sjhZEy92
         r3E5Jql8QrEBOvCs9rsz6yMvMec43vSlcK9hVMM3Nfim9/4kt1iz+kz6YswAfk0fSI+O
         j3iahlEOma5GTn7b2wm1YbJ+spWORXI8k7k8BUmS/Rif7hNuOR5CTIvVOjODy/D1n7ZQ
         Y5Kzo9eSgr9GnPIbRjaHyhqB5DvNV91Z/MnMPAsGQhH2HmZYwzwGgWq36PRC9NWdc3Jf
         /lpdZ6yPZEoSe8rIhyYNWevXrN/Pg2vxWLpfZedHYGsmmrBq+RY2M1ZiYLqEvfXvhNqb
         zFkg==
X-Forwarded-Encrypted: i=1; AJvYcCWvFdf+KnlgrCCFXwI3opghy4DhjRS+Lbc2GeQK5pC/lrBburhyUVJAO5sgqWHLFnhC7Of03Ay6NA==@kvack.org
X-Gm-Message-State: AOJu0YwbxBMtmaTBi6cVS8FykjBwEVPTB6ilsmQJL4TMMc6qYNS7l9YY
	hTJKMA2WXTZPUk629yzK/ydM8qfIhtWHixSkmAtGRxj31WsIx/dIV4r+aQ9ibyFDTopF3LJmwXs
	sQZ9SYWEOqqDQx5BbqVSV6Df46YjV4vY=
X-Gm-Gg: ASbGncu9bYzSJHo487T6N8CMvZ9Ph6YLX2mo4Z+moZ2ek4m64ygVDLwWxbSWquGL0Da
	PIaozyLBC2W5Mly6JzfASBhqdPgJwsBLHm6gNxRkofHdaKaEPTiI6Eo8matebf/MQZvKQGYqEwi
	gQePpdjCI7BtoIFvJM3d5gn5q009WpBuqjHuCiMI0LXi1tDsJlQOxGb+gApElCLaY0mUNYHxIgu
	xrSLy5U
X-Google-Smtp-Source: AGHT+IGehqz+qgc08Xs+YcOkmGwrUy5qnS9rSdL99LHlB32v780kpomgNOcSXYPk2NxdUlswHHM85BCB9iIqMOXXNU8=
X-Received: by 2002:a05:622a:1b14:b0:4b1:aed:7480 with SMTP id
 d75a77b69052e-4b2aaa401ddmr51256831cf.23.1755904854960; Fri, 22 Aug 2025
 16:20:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250707234606.2300149-1-joannelkoong@gmail.com>
 <20250707234606.2300149-3-joannelkoong@gmail.com> <CGME20250822214238eucas1p16934a3c0a9575e6044b61e11f3635af0@eucas1p1.samsung.com>
 <a91010a8-e715-4f3d-9e22-e4c34efc0408@samsung.com> <2acaa457-2c9f-4285-8403-2896a152f929@samsung.com>
In-Reply-To: <2acaa457-2c9f-4285-8403-2896a152f929@samsung.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 22 Aug 2025 16:20:44 -0700
X-Gm-Features: Ac12FXwS07sm5a02yhNB9fOsIW7cbSN95w93gPogkIo9eiP3evKdHTcMTXPf8kc
Message-ID: <CAJnrk1agKVGUr6jVapjHBaYJHrkV8zcmDVKr6k0mUu+n=iUqxA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: remove BDI_CAP_WRITEBACK_ACCT
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, david@redhat.com, 
	willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03A961C0003
X-Stat-Signature: c7qmwi66pfwbj6t58fndiodt7jhx1ua6
X-Rspam-User: 
X-HE-Tag: 1755904855-624298
X-HE-Meta: U2FsdGVkX199gaDuCknmRM9ChRDdPo1It2jS6FCnwH8kWDUA8Zj6fJyeSbhFXje9jYb5AmTTtqnrvsMV4078+dPBVjoeNcXJs0fUBZeXaqz9jzmi8wPDK0DMk+X6k5YY3zxqeEZmPpm0wYpmkI70oJ6/TrrIkxjh8wqgYfoJhC4xgHC2oIZ+FwbT+/4jQiVHfyor6xqlUdvAzusq6izPyZmOZjoYg/mDsy2nOljRu/+KcHkXtRY62hOGcqHcoc7nM6+kBpyVG1Swi1b8zuYZtld+Go4W2bnZbCfD6F+5L8R7Ci+TNq6rWivd+nGSUrPITLSYvwRWAo58zpJzibJ7/aH8acFvkp/XCcHcZFmx1zf1KBQEJ8t3gmeqv5zFQGrAOftCBQe/x6a3UdJJhzwE6Osdv4VmLgbHqs+DAFK9oFYl4+/kYkOdERdtIUbtb9UKBjj/WL4rhuG9iVHsHiBHe1DwytyYGcB6yOwTnvAwOlIhMJP310rZODmuCWN/0jzQCwaWGhspDwuoQ3VOy1+BwjqhAQQUcvfq5mrByDRgIvNjyEhuSETK+SAHq+8lFtNqfR43SUP9D2BDMcH20CVWfh0pfgnyTFZC1VYAWq5b31bCuWrAlUSX5HjKNYTyqgMucC5HVfHZpjmI0PyEZSIhVAGUW0DP7EXHQvwRDUvi7sCZTCUOle+fceATEx4EV4ruYDmbZgLG31VCmMxWWemyrkkY9L0Q4IRKHyUSv8jeJSokmhN2QPxaexDE0ZahiBzFo/UQZs2WkUaLRqu9YxDOTKzEw6jG2y5+FdK+ZA8oBRusRdzu1bsyFrsA0j9LPV0GRyXQ/Q+ZbibHbDd40NuraVP262Bp1quwGprtSb4T4ErIIjFFajWuT1BzPV1lyptvgjeEU8Jb/MbsZnspBxDnOxsbANcUJhZ8jrq9zFY6UCKS8jnS9ErN9rZgsSiqManV7KAfHg9xwShdz8WCcJA
 AtDXdURW
 tXnSxZ0d22BV7vqG8/+f0WpXqs9aCfLM8I40/x4FJ1Z8bc/3eLil+zTJt/pNXtE4IcuBjDcNS5+0aEu+dNniQs2+iHGsCH3VesVsya3SvGNO1nrwGUH7f+Am0vA3UOIHTXtc9XNg2d0hzH9J8KZL4T50MwsviZ6BBz+cWA7fH2EmHc+clMT7lywyAYfjqJRoOWcJD9/o19T3xGhssd6cR4eykzzQnBVQRQvM7AM4Fvg3zWq2ZG62pLJL8Da5pAxjB0xp09xjqKlHuYkYc4yftmVHk0Uh6mG2dUmH5tJpaJwIYPh9JCjTivR006Kq2fmlOxp+txLKruSEYWk3nAdRudp3/2DlQSKAq8SXLtlvYA/Yx9ikx0PtUW8XF9FvVBBqkDS+mLKPd6xuwfn8bYYqXW68IXPEXGu2kV/Rfu7JLHZvwA0ru9/pNWykbjaSmDKsdAoU5t+3o0fq2yQkajU2zm/P+kbVDTboopK9J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 22, 2025 at 2:42=E2=80=AFPM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> On 22.08.2025 13:01, Marek Szyprowski wrote:
> > On 08.07.2025 01:46, Joanne Koong wrote:
> >> There are no users of BDI_CAP_WRITEBACK_ACCT now that fuse doesn't do
> >> its own writeback accounting. This commit removes
> >> BDI_CAP_WRITEBACK_ACCT.
> >>
> >> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> >> Acked-by: David Hildenbrand <david@redhat.com>
> >
> > This patch landed recently in linux-next as commit 167f21a81a9c ("mm:
> > remove BDI_CAP_WRITEBACK_ACCT"). In my tests I found that it triggers
> > the ./include/linux/backing-dev.h:239 warning. Reverting $subject on
> > top of current linux-next fixes/hides this issue. Here is a detailed lo=
g:
> >
> > ------------[ cut here ]------------
> > WARNING: ./include/linux/backing-dev.h:239 at
> > __folio_start_writeback+0x25a/0x26a, CPU#1: swapper/0/1
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted
> > 6.17.0-rc2-next-20250822 #10852 NONE
> > Hardware name: StarFive VisionFive 2 v1.2A (DT)
> > epc : __folio_start_writeback+0x25a/0x26a
> >  ra : __folio_start_writeback+0x258/0x26a
> >
> > [<ffffffff80202222>] __folio_start_writeback+0x25a/0x26a
> > [<ffffffff802f3260>] __block_write_full_folio+0x124/0x39c
> > [<ffffffff802f4b6e>] block_write_full_folio+0x8a/0xbc
> > [<ffffffff804dbf42>] blkdev_writepages+0x3e/0x8a
> > [<ffffffff802030fa>] do_writepages+0x78/0x11a
> > [<ffffffff801f2e0e>] filemap_fdatawrite_wbc+0x4a/0x62
> > [<ffffffff801f6d66>] __filemap_fdatawrite_range+0x52/0x78
> > [<ffffffff801f6fdc>] filemap_write_and_wait_range+0x40/0x68
> > [<ffffffff804dacae>] set_blocksize+0xd8/0x152
> > [<ffffffff804dae18>] sb_min_blocksize+0x44/0xce
> > [<ffffffff803a0c7a>] ext4_fill_super+0x182/0x2914
> > [<ffffffff802a72e6>] get_tree_bdev_flags+0xf0/0x168
> > [<ffffffff802a736c>] get_tree_bdev+0xe/0x16
> > [<ffffffff8039a09e>] ext4_get_tree+0x14/0x1c
> > [<ffffffff802a5062>] vfs_get_tree+0x1a/0xa4
> > [<ffffffff802d17d4>] path_mount+0x23a/0x8ae
> > [<ffffffff80c20cd4>] init_mount+0x4e/0x86
> > [<ffffffff80c01622>] do_mount_root+0xe0/0x166
> > [<ffffffff80c01814>] mount_root_generic+0x11e/0x2d6
> > [<ffffffff80c02746>] initrd_load+0xf8/0x2b6
> > [<ffffffff80c01d38>] prepare_namespace+0x150/0x258
> > [<ffffffff80c01310>] kernel_init_freeable+0x2f2/0x316
> > [<ffffffff80b6d896>] kernel_init+0x1e/0x13a
> > [<ffffffff80012288>] ret_from_fork_kernel+0x14/0x208
> > [<ffffffff80b79392>] ret_from_fork_kernel_asm+0x16/0x18
> > irq event stamp: 159263
> > hardirqs last  enabled at (159263): [<ffffffff805e7e4a>]
> > percpu_counter_add_batch+0xa6/0xda
> > hardirqs last disabled at (159262): [<ffffffff805e7e40>]
> > percpu_counter_add_batch+0x9c/0xda
> > softirqs last  enabled at (159248): [<ffffffff8002e972>]
> > handle_softirqs+0x3ca/0x462
> > softirqs last disabled at (159241): [<ffffffff8002eb72>]
> > __irq_exit_rcu+0xe2/0x10c
> > ---[ end trace 0000000000000000 ]---
>
> I've played a bit with the code modified by the $subject patch and it
> looks that the following change fixes the issue, although I didn't
> analyze exactly where struct bdi_writeback is being modified:

Hi Marek,

Thank you for the report and analysis.

The comment in the warning you linked to
(./include/linux/backing-dev.h:239) says:
"The caller [of inode_to_wb()] must be holding either @inode->i_lock,
the i_pages lock, or the associated wb's list_lock". (This was added
in commit aaa2cacf8184 "writeback: add lockdep annotation to
inode_to_wb()").

The original code before my change set "wb =3D inode_to_wb(inode);" only
after the inode->i_mapping->i_pages.xa_lock was held, so your patch
below which reverts it back to this behavior, fixes the lockdep
warning. That looks correct to me. Thanks for the fix.


>
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 99e80bdb3084..3887ac2e6475 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2984,7 +2984,7 @@ bool __folio_end_writeback(struct folio *folio)
>
>          if (mapping && mapping_use_writeback_tags(mapping)) {
>                  struct inode *inode =3D mapping->host;
> -               struct bdi_writeback *wb =3D inode_to_wb(inode);
> +               struct bdi_writeback *wb;
>                  unsigned long flags;
>
>                  xa_lock_irqsave(&mapping->i_pages, flags);
> @@ -2992,6 +2992,7 @@ bool __folio_end_writeback(struct folio *folio)
>                  __xa_clear_mark(&mapping->i_pages, folio_index(folio),
>                                          PAGECACHE_TAG_WRITEBACK);
>
> +               wb =3D inode_to_wb(inode);
>                  wb_stat_mod(wb, WB_WRITEBACK, -nr);
>                  __wb_writeout_add(wb, nr);
>                  if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
> @@ -3024,7 +3025,7 @@ void __folio_start_writeback(struct folio *folio,
> bool keep_write)
>          if (mapping && mapping_use_writeback_tags(mapping)) {
>                  XA_STATE(xas, &mapping->i_pages, folio_index(folio));
>                  struct inode *inode =3D mapping->host;
> -               struct bdi_writeback *wb =3D inode_to_wb(inode);
> +               struct bdi_writeback *wb;
>                  unsigned long flags;
>                  bool on_wblist;
>
> @@ -3035,6 +3036,7 @@ void __folio_start_writeback(struct folio *folio,
> bool keep_write)
>                  on_wblist =3D mapping_tagged(mapping,
> PAGECACHE_TAG_WRITEBACK);
>
>                  xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
> +               wb =3D inode_to_wb(inode);
>                  wb_stat_mod(wb, WB_WRITEBACK, nr);
>                  if (!on_wblist) {
>                          wb_inode_writeback_start(wb);
>
>
> > ...
>
> Best regards
> --
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
>

