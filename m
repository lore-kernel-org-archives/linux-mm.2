Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFCBCD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E74F6B008A; Wed, 13 May 2026 22:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9978E6B008C; Wed, 13 May 2026 22:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD8E6B0092; Wed, 13 May 2026 22:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 797FC6B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:06:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 190661606A8
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:06:21 +0000 (UTC)
X-FDA: 84764385762.19.D79601A
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id E3705180004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:06:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gC0BC+hj;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778724379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IAyMtvqeP/vr9LGu+3DeKX1bvcCtny0C/Y5rEZXOKs8=;
	b=XmwUWqf27SlAE1kINlsC5ghNNN2AxFvqgDPQZHsMSLyoqIes7iNgIyUyx1iKFRX+HWdH16
	vHdsLZlBg8VQBYreVDaiLiMp5wbXiwZpyvOlx1auU5TbGrZigD+QNSUar4IdmmQ7DFiNOU
	qdCph/1FxszyV0wSu2RZC9CwiE8rMN0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gC0BC+hj;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778724379; a=rsa-sha256;
	cv=none;
	b=J7EUjc4nfJPikJ5Y0TLYxAfX+zdbZbLgo/7QBFXvawRFJCXDuZsQgd6NiMiNiibkAtN26F
	wN7faEdbL6KsZxomcpzDlv22zfPOAAgjxSBLJ68Ar5zdzIm4G8cgI1YziwdWQTlNVtvW41
	FyQH//vQVHnt3cvgiXi7ETPv9LUyL6A=
Date: Thu, 14 May 2026 10:06:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778724376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IAyMtvqeP/vr9LGu+3DeKX1bvcCtny0C/Y5rEZXOKs8=;
	b=gC0BC+hjX+W2nWO5j0p3sh3YySs6ujuigMwTTi0auOpaMD5Hssh1IuEoRhxsm8Bu24/ISO
	QwDg/O3O3knZwhf26GJuq47rQP6ES/C/B+DIk8bI3JZrq3/VgVkZj+xxU5dtqOiq7yIbAA
	//wMCyTTBXYFRhrHbjWLz32oM54xkYA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agUuEizORebR3A0O@MiWiFi-R3L-srv>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-3-baoquan.he@linux.dev>
 <CAMgjq7Ap=hEmHg+5Da=NdOQS1JK1FY+WepmW=3HEC4XHfsUmuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7Ap=hEmHg+5Da=NdOQS1JK1FY+WepmW=3HEC4XHfsUmuw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3705180004
X-Rspam-User: 
X-Stat-Signature: 5wmmpkwy1y54zjf9z87r58zti3fpww4s
X-HE-Tag: 1778724378-687294
X-HE-Meta: U2FsdGVkX19AI+2oTyjoplbvcL2NSvlrzl6V5E1spPFto/xkMxu+SY3GwYdiLoFKURBhmFTMXb6V5b89SWX+BwdA5Y+Pj7U5eWHRyTAXZN5i1zF+VTDYp3kwjPgkm+xCFfcq1WVDXg/DJeaPzqTabwMHb4UlEObm+kCeYqlaHJXhG6lUtA4DMslpwJqA2vjOxh8rtDWVSYyy1eE6UcqnSC7mFs7yWVLJukNOYxZmsEvEigN8WmNGXzmVqzgsTulSm0BP8nFMlhbHiSYS/4zFHwteN88zYL5grZKhNp+mpiPiyy4Ojgg3vOaM7hgt2bpDtBQpYje/Xm2sHr166j18eGQV5NPI0HI0n/2i9lTOu9RbMPaMG9+Dj2phqHLgvdNTnxCi1qwLkWLVJSg1BM85idp9vOMyn4ggEeHC6WcVcKnmoU7XFpTQpc732QG9DS51jxUnrLbdEcBbi3fFWE/XX3dw0EwoI4amWa5UH2Y/+MFSY6A1RWvkW7DYXyBl14IpaTa+V31wb3CwsY2pgK/pk4lidG9pr/thctJUZY8JVSiDjnar1+cKlA/d4BKuAAVj7iaEniz4wHUIP7K04PsGefSkdVrYC5a358Qgnbwoyn5WWgExIP29yo5jDJxPvCrmyGI7x8J6Z5dK3I/Lcuks0SupGXM0bR/93WyqlmYF4O1Bs6tPn/UA1BixY8126QmNPsyltNUurE/q7om209dgiDX3KnmMKCVm8BJK3qxZHLBhkwL9/bl7hdJastPiPxIQu4Pr7fuym/aYzG9k+MESnf8KfdnuwnM4aMylkTttVlYc6NOvDnhg48l9U3juTRy0dwdvUtp2sXyecYNNBtvUUmi66S1f5IZD800Ap/b1vdJgtT9AXxFjKTzI1CpfqY/dX0+EfBPzgg5vdcNgscMrD2iT+l1XY2e5iTibp5tnJBdlfPMXSfDKuEQGFbHwLH94ARQLmFT/nai6iISGtmJ
 dpnt6BkM
 mF4dn96hH3LwDbqnw8jHnFvwpIXcHgAYM6FVVRX5/3Gr6yGCQScM+HEEB3WdFIAdFfXeNoBBVPz2MS3jEAo/gb9LVBz70N/gqt3BLDLkDk9VI1yW52Bk7zJ13fzc8hdOcvaGpBqdz0lL2OtC6SX9hSM9rVF2gqYmYI+yvh2fNMWJB3dUdRoANi+xR50bmhCnVw4F3KdOtfN/E7FJhkItx8NJ/h0rasf32OEnBUhO+wSx3S3sxNBvTbbpBLLs2ruGiKd8SqihxqkscTwaeIN59jDKgJRWC2ABrkRD87sjUwn9EK6gYxS4/CcXPpn4We73LuICJ0K1ga4hvG1VCcfnyZEQQvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/13/26 at 01:53am, Kairui Song wrote:
> On Tue, May 12, 2026 at 6:50 PM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > This simplifies codes and makes logic clearer. And also makes later any
> > new swap device type being added easier to handle.
> >
> > Currently there are three types of swap devices: bdev_fs, bdev_sync
> > and bdev_async, and only operations read_folio and write_folio are
> > included. In the future, there could be more swap device types added
> > and more appropriate opeations adapted into swap_ops.
> 
> opeations -> operations

Will fix, thanks.

> 
> >
> > Suggested-by: Chris Li <chrisl@kernel.org>
> > Acked-by: Chris Li <chrisl@kernel.org>
> > Co-developed-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Barry Song <baohua@kernel.org>
> > Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> 
> A few nitpicks below:
> 
> > -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> > -{
> > -       struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> > -
> > -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> 
> This sanify check is dropped and not added back in anywhere. This is
> fine, but it might be better to have a similar VM_WARN_ON_FOLIO in
> swap_writeout?

Good catch. In the old code, it's called by both swap_writeout() and
zswap_writeback_entry(). In zswap_writeback_entry(), the folio is
allocated in-place, we don't need to worry about it now. I am fine to
add it back in swap_writeout() because adding it inside all three
swap_write_xxx() is a little too much.

Cscope tag: __swap_writepage
   #   line  filename / context / line
   1    288  /home/bhe/code/linux/mm/page_io.c <<swap_writeout>>
             __swap_writepage(folio, swap_plug);
   2   1053  /home/bhe/code/linux/mm/zswap.c <<zswap_writeback_entry>>
             __swap_writepage(folio, NULL);

> 
> >  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >  {
> >         struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> > @@ -642,13 +664,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
> >         /* We have to read from slower devices. Increase zswap protection. */
> >         zswap_folio_swapin(folio);
> >
> > -       if (data_race(sis->flags & SWP_FS_OPS)) {
> > -               swap_read_folio_fs(folio, plug);
> > -       } else if (synchronous) {
> > -               swap_read_folio_bdev_sync(folio, sis);
> > -       } else {
> > -               swap_read_folio_bdev_async(folio, sis);
> > -       }
> > +       sis->ops->read_folio(sis, folio, plug);
> >
> >  finish:
> >         if (workingset) {
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 4840fd40f36f..8c42632e6765 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -3780,6 +3780,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> >                 goto free_swap_zswap;
> >         }
> >
> > +       /*
> > +        * init_swap_ops() sets si->ops based on flags. It does not need
> > +        * swapon_mutex, and must complete before enable_swap_info()
> > +        * exposes the device.
> > +        */
> > +       error = init_swap_ops(si);
> > +       if (error)
> > +               goto bad_swap_unlock_inode;
> 
> I checked the comment above previously and it looked good. But the
> error label seems not that correct after double check. inode->i_flags
> will keep the S_SWAPFILE flag. Maybe something like add a
> inode->i_flags &= ~S_SWAPFILE here and goto free_swap_zswap. Sorry I
> didn't check this part carefully last time.

Right. How about moving it zswap_swapon() because it only relies on
si->flags setting currently?

> 
> But fortunately, init_swap_ops will never fail at this moment so the
> issue never triggers.
> 
> > +
> >         mutex_lock(&swapon_mutex);
> >         prio = DEF_SWAP_PRIO;
> >         if (swap_flags & SWAP_FLAG_PREFER)
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 4b5149173b0e..192401f46de4 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -1054,7 +1054,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
> >         folio_set_reclaim(folio);
> >
> >         /* start writeback */
> > -       __swap_writepage(folio, NULL);
> > +       si->ops->write_folio(si, folio, NULL);
> >
> >  out:
> >         if (ret && ret != -EEXIST) {
> > --
> > 2.52.0
> >
> 
> Rest looks good to me!
> 

