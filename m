Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2760BCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 22:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8C1A6B04CA; Mon,  1 Jun 2026 18:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEE486B04CB; Mon,  1 Jun 2026 18:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADDD56B04CC; Mon,  1 Jun 2026 18:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A10A6B04CA
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 18:03:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFBD31C0C7E
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:03:33 +0000 (UTC)
X-FDA: 84832721106.29.7644A58
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id EE397C000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 22:03:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AZ7K5tFD;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780351412;
	b=TifhtubcfcPKdymTGe5DTdbcfDxfzVSI9n8/YZre4anV+NLvF03PWhJbt0McxR7JP/VVTc
	XlEUJPPen8U8TB9F0isLU+EiglqVRirNF4EarOSNhMsODukHY8tnX2Y9GwLOqKy10/Flv9
	LH3JWCgnLltPiki+Sc/ck91FfgVURp0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AZ7K5tFD;
	spf=pass (imf28.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780351412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldPi0/vo1HBN6vtwxFpHQongTWGF3H0cNZG5BgrmAm8=;
	b=NFovYHXtbyoMgCgmU3jp2wNGga4S6/Q3m/iWCYrgfoLsUkI3uKplqXzTjplazcYp8tAkEN
	yOMnZ5Be2EdqoJzqwH975XIfzcVV2Mlwfi/FES2PljFKyLaTx8/1xsOA0rkQ0S4Gy7+uZO
	a7/jhhGwfKkhp8wz+fQx75jwXxGcpAs=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4909e3fa4b2so35368665e9.0
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 15:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780351410; x=1780956210; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ldPi0/vo1HBN6vtwxFpHQongTWGF3H0cNZG5BgrmAm8=;
        b=AZ7K5tFDevCJPN4eUji/cAyT/4fGIEO4CTaycvdPrC6M7+nBBe/Q67Bru4i1y+rS1Y
         xCFMTFJxUVVlfW8Lh4cEOFyO58jY+rRCOsx8xwyY0mRuCJbpDgMDrwrSG89WY5n5mPXL
         2I7x76172/D0zBgWvBS9jGFqSolaE5YYSr/x6BgbgYnvkzfsygGyQ5lVBuBg7N1Yp7nN
         y4I4YV4kEx27uTqp73C+yIT0acnyi45GJ+hQazdOPdvnqvc01qZuQ5P2A8paxZxfHVsQ
         bpGXH7t7WkVcmxLgL6Hn98XtxntIvA9kQyz/fp1ZQaiKBzT60rBz6+nHlKov7oI8DhO6
         Khaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780351410; x=1780956210;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ldPi0/vo1HBN6vtwxFpHQongTWGF3H0cNZG5BgrmAm8=;
        b=NU8T214WeNhmreaSdoT96I7nSSP7aDmoXEKKpFTKsZbqXKgeOaxJWhDXAzkrXM4m5m
         BZDTUfPN57IdbbwRO5ZvOCb7IRESNqkOc+Rbvv+HZDetGZ6dKm5BGSVQelNOlh35Y3yQ
         2bAWRhKHLgnn2ks4OYg/73hKGuAJbVnbIGXiAo44xtnC2g8PqtfS6tDh3j00IeUSc7PZ
         k47FICU2wEqtKic0QKiw12HkWTeohpg2tS6Ucv4WWvn8S79C8zbP4MiXUGX53lNxc8uG
         B/4zqkBV0mTVWiZLgqB1UyBWa5yXTRPaYRTlpPxxmSAPdO4OaPPTx7DWRs0dxD1EZQd0
         Bivw==
X-Forwarded-Encrypted: i=1; AFNElJ996AmZ38Un/A8cZ389B/i00GngYN5ensOgCGisEpfpRzlgJFj1mVzMtW32hKdOJX8+a/Dn2IZYvw==@kvack.org
X-Gm-Message-State: AOJu0YxL69MPzcs6KcjXit90ImwD7Dy9yX4b0c1aK6VQOJN8aj52C0NB
	jRlBNlL8nEaOycZt5MCEkIcTDAcaDhid95N+Ck8Yg26UviCmi+LX/ONZ
X-Gm-Gg: Acq92OHTnVBkI/M/WohO4pCEXD2akxvYpt8qBB70PTZ9ZsM4uaCSIgGiGqOx3EC2wfT
	ljUbAN9alQmP5tDOr9bMbajaKeXd+JzfPUbfeKifPJ4SJgBIlFnSvCQe3alvNG+/2tL2TYtWY6u
	R4gTRSmxf0BIETjSi7IzQYaPc6I1OLzlf5RpYpCMHizyeto6HFr+9dIQlbCq+K5JAzv+8Z5QJOe
	YLxOZI20amHaBh54IbP0qEYuO9+5Uje4CWtpODrBrZfXurtvuryFlcZL4P5ShcnudfcmOSDF8kY
	2TeO+BMY5tymgowi9bY+ZwM/zywb+BcmdRB47HfSxen8e6Tq8VE1J3nIhNZABRe6ej7GjwbiOeF
	+27PkEkXy4CfVNGyaBPVoyhyQCopcJ4fOF9JxNWc5SUtroGScZWxUA7iZHVOcTIMHYHLKg4qLcq
	Od695fCQ5QLkNhXUZMa+DHFTlmf5PlJdvj6aaj/+85OnF2n0EXObrkItK7W3h3sB1a00VhybU=
X-Received: by 2002:a05:600c:8b35:b0:490:5380:f2cb with SMTP id 5b1f17b1804b1-490b0702af7mr28495355e9.0.1780351410286;
        Mon, 01 Jun 2026 15:03:30 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c09ac4bsm84800275e9.3.2026.06.01.15.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 15:03:29 -0700 (PDT)
Date: Mon, 1 Jun 2026 23:03:26 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Chi Zhiling <chizhiling@163.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, Andrew Morton
 <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for
 large zeroing
Message-ID: <20260601230326.09981e44@pumpkin>
In-Reply-To: <rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
References: <20260601055704.167436-1-chizhiling@163.com>
	<20260601055704.167436-4-chizhiling@163.com>
	<ah2HfH3jJZDiNAQc@casper.infradead.org>
	<rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EE397C000A
X-Stat-Signature: h18sakqnc5knbh1caubph89bc3bd9r73
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780351411-17583
X-HE-Meta: U2FsdGVkX19zpB/7gYBwdqimYj+poPqy1BOgmltQsmVnJUKlJZ1GEJQhYz3GpLlK6un+FqTje/rLKwF7MJdfEOYGU6GuQ1he0wcmwQtA1eEuqipMqEePaU+VV1KwR9VJiy+8vEg1tkGOND/XNJKkQGz22z5UT+iCdpYfm6v4vdbZ78fA4w8brWLGzI1ab/iPzwk3Blq7pfzOOiDUwdE6KYHiGECj/zvughZ6YEJjQM6fExKh3RXcr+wIcvbdV9i/+dBVqS4hpchOAxIAlBVq8HYG/gVnf7ThGPJ3zA7cDGS3t+0aoIFSW3FMnao1HCUG7UU2nbunq74WgLiSM+SWU46WUrwg12a2/Vki9I4nn/th3LKp92r9NlIubLedjpIibuTXZko4Y9CaV5S903w6kUFat75y2YT8QOjoTsVkJhYeGXs9R8QDqXPRmYh4bzB3BLIy8QfsjeKSWYUtPyYbMiCTgerdQ+6+HSYablt+IKBAs7lOsjr9gKlAq2XW8jjy5EAQjCmu/Lx+e5sbZVYApjEyS+XfMKtvOlH1oF5s6TSNWmHyI7Ck39lQnzGPWfKwoIdbOhLLuwa0Ch1Q+PGvbAdoATzij25oaM9pjAmBSqGg48c4MUVXLZLvNvRJEkPb5zvuJuABqy8/VS5PtPobo6kKnwFphqQsWpEPU90VQz5kbbB9tYAbZz87oYderwl2et7gXQzG0ND9TZK1MtTBkslSzXmT8ZJVeKmmKSd4EZdsFMMOITdDsAOt3Mru6id/+RkbxVdtw+5XKEVoBtJYolFdKFD2Hm5p9D53HTtPjzAHTDTZOyGshsxx1eA8uDe6jYcoSF3e8bWmAFb09P+QX/yuVrwAcq49qSENaRcoEw8zp6JvCY4QLJLJjrLEZWC/zFT0I0dm829qgfG/KSh01rsxXbOjxqkd+6lQuer95PWinAgwYDH5a1uPBCvK5oJ+3iIlxCFtHCzSlbXupWL
 iY6PHLm8
 IAXOzB7f860zwjTUdPMqZOfe7c3meuqRAAgkNuutDQ3jEOrKWUjBFNUDva/JQlwWGDxEaINiD2n/T91hajsX+EpnXBFgCQgClIdNeL1Ja0nQZIyhnu0yyBHOsVLnDyb1pWxa1DUfjFIOi44dzzFJJUl7O7uC2kkjAbTu2f8DRJu4oJ5bYVw2MU232+pigWpP+Rnxe9aLsW5t6Sxj3dGB9E3KgaWc90zxTTc6BPeCOi/5PWzN1VlbCoOyUGi7HOPuDJs7G3S6X042np0HtLAArYQluK3xD3V5m9ov9gK4QOLyryQXIS++XLxI3YxINbOxst6XNNNONRL7lZM5ADG86BAJVCVq3A6mwo3uGcaHCSedGAGgZ9p+064bN19MgWpMrTxGLqReXZE+jL6EZy/14tsG5L1pG0JTkwYS0Qt14XQgc6Q9OGGRMw8t98BndWS75cJKYuLH89ygTnOvSxVtx+z4WJkdn6ERMZ18xQQkHfF1Y6otpEu8X+Oe1D+A8z6FZpc4FvFnJS7pcG9mgoDNeTmptXU6sa1TWZeE5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 17:02:01 +0200
Mateusz Guzik <mjguzik@gmail.com> wrote:

> On Mon, Jun 01, 2026 at 02:22:04PM +0100, Matthew Wilcox wrote:
> > On Mon, Jun 01, 2026 at 01:57:02PM +0800, Chi Zhiling wrote:  
> > > Currently, holes larger than PAGE_SIZE cannot be handled because
> > > ZERO_PAGE is limited to a single page. Add copy_zero_to_iter() as a
> > > wrapper to support copying larger zero ranges to the iterator.  
> > 
> > I think Hugh put this optimisation in the wrong place, and you're
> > perpetuating that ;-)
> > 
> > So perhaps we can start by moving this optimisation to lib/iov_iter.c?
> > And then you can redo your optimisation on top of that.
> > 
> > diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> > index 243662af1af7..06c54d719fcd 100644
> > --- a/lib/iov_iter.c
> > +++ b/lib/iov_iter.c
> > @@ -451,7 +451,23 @@ static __always_inline
> >  size_t zero_to_user_iter(void __user *iter_to, size_t progress,
> >  			 size_t len, void *priv, void *priv2)
> >  {
> > -	return clear_user(iter_to, len);
> > +	/*
> > +	 * it is noticeably faster to copy the zero page instead of
> > +	 * calling clear_user().  Shame.
> > +	 */  
> 
> 
> This is a rather suspicious claim. If clear_user is indeed so terrible
> that it is faster to copy, the routine needs to get unfucked instead of
> the problem being worked around.
> 
> I can't speak for arm64 or other non-amd64 archs, maybe these are
> horrendeously broken.
> 
> On amd64 some archeology shows the following:
> 1. 0db7058e8e23e6bb ("x86/clear_user: Make it faster")
> 
> 2022 vintage, replaces thoroughly terrible 8-byte per-iteration write
> with rep stos usage
> 
> 2. 8c9b6a88b7e2f33c ("x86: improve on the non-rep 'clear_user' function")
> 
> inlines rep stosb at the callsite if the CPU has FSRS, otherwise
> fallsback to a new routine which does 64-byte writes per loop iteration.
> 
> FSRS is reasonably popular by now and chances are decent the test jig
> used by Chi has it.
> 
> For a size like 4096 bytes, the 64-byte loop will be slower than rep
> movsb and even rep stosq. This needs to be patched and maybe I'll get
> around to doing the needful(tm) in few days (it's not hard to write, but
> some care with testing is needed).

I think Intel cpu from Sandy bridge onwards execute 'rep stosb' just
as fast as 'rep stosq'.
(I'm sure I've done the measurements for 'rep movs' and stos ought to
be similar.)
I suspect you get the same big gain (twice as fast) from an aligned
destination (IIRC 64 bytes on later cpu).
(But I doubt it is worth the cost of aligning the destination.)
The source alignment (for rep movs) make no difference at all.

The 'elephant in the room' is older zen cpu.
Some of those are no where near as fast as you might expect.
(Look at the issues using 'rep movsb' for all copies.)

I can test a range of old Intel cpu, but not amd ones.

-- David

> 
> I could not be bothered to check how the workaround showed up, but it
> definitely needs to be removed as opposed to being perpetuated.
> 


