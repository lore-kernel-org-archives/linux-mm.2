Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84072C5B572
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 15:58:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E29D6B035C; Sun, 16 Aug 2026 11:58:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6930F6B035E; Sun, 16 Aug 2026 11:58:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582156B0361; Sun, 16 Aug 2026 11:58:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 229926B035C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:58:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F60EC0555
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:58:20 +0000 (UTC)
X-FDA: 85107589560.21.150D36D
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id A83231C0002
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:58:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dqz7tM+U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786895898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LR0TtAas/eFnB61nrylzS+NbRXuds/iGjGALOg9xS1U=;
	b=gCg7U3L0zQEZuldjSsvJnjgdki1Ncr2rdB9LH/6aLefWrdIQsSC+mYDojFvjiJPeKjbOm+
	61hWrFQQA5KTe9RrIKCL1F5u532Kr+ISNjB7aXblAMvR7ikrryfRSUufMBm2uewvlABNrZ
	5uMiQMB9t8NgiahxXfRGP9skh8AxNE4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dqz7tM+U;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of foxieflakey@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786895898;
	b=SAn0xVEuKhPRgnuMGZJCNQEIbEJOCgFuZL4mI+vQX+NWMbdg7btn5sHcZ2RsPo8Vh5Z4eY
	/GUZVEQMP7w7OlzZDqC0Xd8ZWm5XR71iPjNa/bYwncKtn4RAQRBvEtON4MkNnZm3TZLv/+
	SExc3mzzATx4Qg1SgxAjNEkcEYT55BM=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca7d1dc4554so708449a12.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786895897; x=1787500697; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LR0TtAas/eFnB61nrylzS+NbRXuds/iGjGALOg9xS1U=;
        b=dqz7tM+UoM0i8TFXhwSf4ulb+O/+8+QeAI92iu6vcpBLVTMbMO66LTVJyVvGe+sjTt
         psUZu64T7Q8XAsIr6J5kt56cPeEG3mvhUD472N2EWlM1qCW1/htz+csWJVq8Kr7Ub/qX
         /xebGIhZ3NH3jp75x9GfcxP5gw1d687713H1fgTD8xisaNriXhdgXUOmJ02sSsTOCDlD
         NkcSayTrI2QvXKb02m00ZkK1OqZ1/oMl8kNNKUCyBR9XZLEsyVl8KsfKmp7wxl6fLTSN
         9U0gvhsHpsEOT26E6ZoqKeA1UkLI4VEvSrimXXizGtg0J1dEuTVbO20kGRYK+1WbNBpx
         Tkeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786895897; x=1787500697;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LR0TtAas/eFnB61nrylzS+NbRXuds/iGjGALOg9xS1U=;
        b=sWg9TPi0nSkR5quvB50fKv3FeqHloCEL5rb3QkAlXikXuOLtfi9gyrCMfb2W/qiUSl
         rBEcpGH1VXWg0IsMkfBuCWucQIk7Uq2HVPX0fA3brPJ/5rQhUIRl29nJa/yrkuiHi3ru
         pXs+MgPPrjDWlYQdCf3TUL3lifgK4+am1OMR5R/2ZpI5+l2+nH3mYRHGDraD2M7taaZZ
         fUY59eNz+qkkbd8pK0Uyg8Nv8MGaQvGQVppOVDYyW9dEsB3Y5AcVAQjAj5vr3QRGWq79
         JyoaT6GyUT+kkp9WF9SltacQJR/ib0eRlYoxXACIewRLn59lMY1+wMyZF9s+/dSc/tJE
         XOzA==
X-Forwarded-Encrypted: i=1; AHgh+RpkO0v5nREA5gdrx9xHSWaxG6lj3cv1XB8z3bHhhjSU1M/wnXtAz/VT6AK/OV4qV7ni9kmJ1HcNCw==@kvack.org
X-Gm-Message-State: AOJu0YyIutJXLnK97E+4rjrbhzpXrltuKJVN8iFauhLBolJl6cvDXDtC
	40MP5otvaPU6RU9uKQWbTjGZHGuq1lXOBo+3IFGbTLD+ol8qtOK5FbiJ
X-Gm-Gg: AR+sD1257N+bU2qy7KpPGzVpdyWNaQAEkR6YeZNwtdXNIOtrboIVrZ6nggYSF8xByzg
	UhWYVgGpaMKEIcOXSUek64cBamTtF7nmGilPbJFNw3RJCjrHvUw7/7rgKARzFOGXPUqkwTCUMCZ
	eKouRao3TT61LFtCOTonHAyAeEDNYVWyBlHKAsCtsulj8Czj+8qsL6Iw+nKN2JdPt6MwXGExuKM
	VusDfTf6KWLpjB738clqMnk8LJ1S0NhF9UkdeJNXRvWQoCCir2tfhz+bwkj1wsRXfiFNIWZ8QkE
	OMfGBNdEgR72q13ywDou7cEf7ri/mm8ooIw9E3B7og85z73ZtS0pPTrnf1K81lGRuAIFzvBLVbh
	g4E4ra69FZ8ow4ujF4c8W2hs/1PVU8JL67JtRkXpwBB7YRWkPXsnZDWAMpkMr4UshXrntvjFdwE
	PgdKNns+5I4n8abB9MUahrn8wCIiFHvS3zoEPnzT+o/yM3CHwddzI9
X-Received: by 2002:a05:6a20:3ca3:b0:3bf:9142:ba3a with SMTP id adf61e73a8af0-3cc71d27285mr22710312637.26.1786895897321;
        Sun, 16 Aug 2026 08:58:17 -0700 (PDT)
Received: from 192.168.1.2 ([157.85.198.7])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-320d61e1568sm26721326eec.11.2026.08.16.08.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 08:58:16 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Sun, 16 Aug 2026 22:58:13 +0700 (WIB)
To: Suren Baghdasaryan <surenb@google.com>
cc: Mike Rapoport <rppt@kernel.org>, akpm@linux-foundation.org, 
    peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <CAJuCfpGAU+uLDNdcJNKaAG4f0VOoe_3=BSKUC8-Ui4S1gwfDFw@mail.gmail.com>
Message-ID: <e75a3269-4298-034c-e35e-ade3998dd88d@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <aoF_qmSHiEgujaH5@kernel.org> <CAJuCfpGAU+uLDNdcJNKaAG4f0VOoe_3=BSKUC8-Ui4S1gwfDFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1371841975-1786895896=:23962"
X-Rspamd-Queue-Id: A83231C0002
X-Stat-Signature: ms9tjwj3cacute3dhs9eo7577tfbpujh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786895898-299993
X-HE-Meta: U2FsdGVkX18g5LWXLX0We5a8j8mc6k4pLZoa3w98VxGZxpCpzKSwUS8eBfFLN4XB1sKLHtKKSU6HrJ+Hll38GIVSaPAjkv2Inu/Mg4TDGVY90LRk9vYTs8PL/rifX0n2EMg2enP6D+3Dt0lNMTEI7gBvibOHEfhVzIH0LGDTtOaf0pLoEfUFTNMQZ6bV/5+ceBCR2mD5euL1Nj0amGnVEFmfgQ18YTSRXS30SD964OoWIqWNbIGjsmmeDeSRiwPrWlbBf7HBsgQYobAbylhL8qLPYI9BVtASEDiEcpUVdZfy6SHH28r/b+KkndXJoj/N5NcnNWnqXtJOKUqWP66EDMkyLtILI/om3IcpZZQCXQOUKUylFrGHJ2C1rF13Bn59tJfExSatQ+LgHjtkPwB3WwNaWQJyvN/Rn3XDxYW/qoL1KPMeP0zz1US8pnC3n3pDxWZ0Cq+6r2EUaH4gWdMTYbHgGNc3PYNhKCM51jAGema7qG9B6dUDkn1xCZRkQlLl8qssMaFOqLUIOndr/LDdTgj62B6e/A0lvuwFa4EvQZ23WU4ZnD4gfiZJALebTqpVZJ89gx5oO5qk4TxsAkCiuDDrciDlBg5HwQkh45Zqdssc0OgBh0DFbPhNTdRLVrIkT//IQW7m9wKKAVPm1c2oQ/2K6cGWo8eHWijs16jRL0q073rgrFjYTIN377u8oTh/xhuc+/upykLCYN+Wa24EP68jq5UV5GMe5QRazvO2zkXJ2MJf24ItAWmNy5s2b3csvCOyb82BQPcmPCDiuk9AurzJvwgT7Y/caT3SrtNT6BUjlbMrR++v20SfnGf+n0nddQbILu1MLZtvBQpD7bdP1jgqS62thBJCTe4isWuyjFiYWYCyjAN5Zl2ZcOKw5HHeqs362dOuY9QFOVwjTSq0ynGFLnmEMgqot9ohVxpdzE4eEgbfo4nkOyV3TlJjk/M5Ow1pywDCX7LIne8dSfO
 6Qi4wuXN
 FD6ukYwiG/1QdlcmxIbR2z4HssdZ3eZE7ME3/bX4915Gm72Ak0NR+iw1Emb1ZsDe4gNKFFdjLIQi+8F5OgkFwwADUy0Z5s7s6GJ/uZi/qlehBZjbDWpFazphthhBJ+RufMT406SdRCGj9cszJRbzJqd4B/thREQl1VJF+CUdvTG8Zue2AdbkMjmq7Eq1QQOosauADK0rT3mzw8akVxmIlKO/BxkjRGxbicGR2Dm8Ka4MwSLXOKjMkWCcT/ZNb4c+9/lCuKbKl/QpsWUOyZWXs7WxHJcmpngORwkke9F5xBXxq8VuI3RNZb0yFyP09KQc/7dthlBGjZnz5E/sh4JmvAKbRmje/6RcQfyYN6uqAAYQlddSYFwceS8SyAdCC/ijvzt2n8FN0wWlQ89f9167qO4UagzSqwAtbirtHvto7bczujWZiYtr9Rj1VnSkrjjqGrBuNBtKbAkA9mdymISK3fVEXXQeQpio80LIwIm2j9CUN3pUpcSE7EztAwY4Ik1AEggjDZQmSkm88Peu8XyRXeVslxLcFGU/hABXozAeDqyHILiubJg1ocUDgs+aT286X5HwjEH0Im9+VTAz0kndOqR1z+7OXj45y1KpBQ4ZARtQtbkKMezOCLrLskZiV9hN0Ax30R7m+g6CmKvBMwPBRAyNdem4f5qwQvJdhPOyOPr2MPJDkfeArNKIQ9vG3Zq4XFZkPZZD1Hd0bcgffwLJruSyVLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--0-1371841975-1786895896=:23962
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Sun, 16 Aug 2026, Suren Baghdasaryan wrote:

> On Sun, Aug 16, 2026 at 2:15 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > (adding Suren)
>
> Thanks Mike!
>
> >
> > On Sat, Aug 15, 2026 at 05:42:12PM +0700, Foxie Flakey wrote:
> > >
> > > An fix for edge case can occur if move_pages_ptes return -EAGAIN, later
> > > when checked and it is EAGAIN, outer loop would retry again on same page
> > > and succeeded but the err isn't reset so the outer loop would think need
> > > to retry again so it goes back again and move pages again. On third attempt
> > > move_pages_ptes will fail because it already moved and returns an error
> > > that is not EAGAIN when outer loop checks again it sees non EAGAIN so it
> > > dont retry and break out of loop. When loop is terminated it did not update
> > > the "moved" variable from successful 2nd iteration.
> > >
> > > That behaviour manifested into this at userspace
> > >
> > > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> > >                           ^     ^
> > >                           \     Kernel moved this far in actuality
> > >                            What is reported to userspace on struct
> > >                            uffdio_move's move field
> > >
> > > When the previous behaviour is
> > > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> > >                                 ^
> > >                                 Reported to user space via uffdio_move's
> > >                                 move field
>
> This description left me scratching my head. If I understand the
> problem correctly, the issue is that the err is not cleared after we
> decided that we need to retry. If so, how about a simpler explanation:

Sorry for the bad explanation, but that is correct. To repeat again to
make sure I understood correct, move_pages() wrongfully retries to move
again due stale err.

> During move_pages() operation, when move_pages_ptes() returns EAGAIN,
> the error code is not cleared even after we processed it. This leads
> to a successful retry but then the same pages are retried again due to
> the stale error code. This time move fails because pages are already
> moved, loop is terminated and move_pages() reports a failure.
> Clear the error code once we processes EAGAIN.

Thank you, I'll update in v2. I'm waiting for answer from Mike whether
Foxie Flakey is fine in Signed-off-by so I don't create too many revisions
when I can combine feedbacks into one.

> > >
> > > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
> >
> > Is Foxie Flakey your real name?
> > Signed-off-by should be using a known identity (sorry, no anonymous contributions.)
> >
> > > ---
> > >  mm/userfaultfd.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> > > index c3adedaaf7d5..595e7e232f90 100644
> > > --- a/mm/userfaultfd.c
> > > +++ b/mm/userfaultfd.c
> > > @@ -2069,10 +2069,12 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> > >                       ret = move_pages_ptes(mm, dst_pmd, src_pmd,
> > >                                             dst_vma, src_vma, dst_addr,
> > >                                             src_addr, src_end - src_addr, mode);
> > > -                     if (ret < 0)
> > > +                     if (ret < 0) {
> > >                               err = ret;
> > > -                     else
> > > +                     } else {
> > > +                             err = 0;
> > >                               step_size = ret;
> > > +                     }
>
> This fix is wrong. It resets the err before we process it and
> determine that a retry is needed.
> A proper fix is to reset it later here:
>
> if (err) {
> -        if (err == -EAGAIN)
> +       if (err == -EAGAIN) {
> +              err = 0;
>                continue;
> +       }
>          break;
> }

I see, that one make more sense after thinking about it that retry should
clear err before retrying.

> > >               }
> > >
> > >               cond_resched();
> > >
> > > base-commit: 62cc90241548d5570ee68e01aaba6506964e9811
> > > --
> > > 2.55.0
> > >
> >
> > --
> > Sincerely yours,
> > Mike.
>
--0-1371841975-1786895896=:23962--

