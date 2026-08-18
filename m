Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3750C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 01:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919CF6B0124; Mon, 17 Aug 2026 21:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAA26B0126; Mon, 17 Aug 2026 21:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B9AD6B0128; Mon, 17 Aug 2026 21:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5661B6B0124
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:13:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CF321120922
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:13:07 +0000 (UTC)
X-FDA: 85112616414.09.BEB3F6C
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf12.hostedemail.com (Postfix) with ESMTP id 054C040004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 01:13:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zavrgz9n;
	spf=pass (imf12.hostedemail.com: domain of foxieflakey@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787015586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVdCmxrOU73gzkdYKIQmTJ04meQlGgXgR2+JhAxJ3is=;
	b=X4cGYR2I+mLpy+21mHbs6eJAw2hkK5CjZOxM0ycAlRvnyoTZuyl7YF2NnPrNr48BUvil8i
	c3gmtpE0NjCH4nj2nmlMBMETNBepOhIVj4gggibDYPoHiS/mmWkAgnyBW9l3GztGkBRc8B
	KnP/8LYIW06MKOsE0qTnoGt/EWd/eLI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787015586;
	b=WKfbT9i+q4uCZXZDxh7Z05jLvmBOLfeHmpqpm5OSpv1MDyGCfHR+BHbQo5b+xkan1Bhzqk
	IBqFq9o5Pth8Y7NK8JpJrOgqV+LmNReYeIbp8f4du2Ju9NrZpy0148qMH6LyMkniScBFBG
	daknsifazfQtEnjbYvsITSL0vGSj4Ts=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zavrgz9n;
	spf=pass (imf12.hostedemail.com: domain of foxieflakey@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=foxieflakey@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-38dd55ad76cso487204a91.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787015585; x=1787620385; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UVdCmxrOU73gzkdYKIQmTJ04meQlGgXgR2+JhAxJ3is=;
        b=Zavrgz9nfkiP/PX/al853aHErQu/0rljhibciJYoK82r2S0MElYAdRUFbEb60F8foW
         Y4OcezIPaJZyIHjBd+WzeDXOlBgjORgMaWM8PtOjcfZk3XVnDW4VjtqQxOLAwtb2Wbzo
         dz4oWMQZqsOeIqj5gGoAeKGHpiKXtBe+yeorc/eDHT+3OtVlvYM3k3r3b4FvHzzMKNgX
         SkOEgX3zsOuCsdfml4NBFB8OMjXk9z0mUfgU6YEwgHHZBnCSLCiCTcW4I3Q7mIZ6Cq2E
         XfHreU8VfI5g4jkf82btMVe+lV0hKyuBk3SYRolEfUDWLsCNDi92fiSyuU9H2zAAl0Bc
         jZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787015585; x=1787620385;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UVdCmxrOU73gzkdYKIQmTJ04meQlGgXgR2+JhAxJ3is=;
        b=dsgB0x5zMOeQAhrW3tMTC/yblMxjdGj59wZhP6pe4qDsQqt20Gok8HhDy5y2N1gvul
         4Xe3PNDRRWmnZmopj3+/S7bJC/TaCsguLktbIQFhDb0L0l4iW+NkWPDkhJE93l8hrqhK
         HHoHlUq82JoHqPNI7OMvwEnRj0VHFaK346R/6nB8EQTt2OCrzi3EW0w19DaPqELEtVlB
         WVWE2+g6tV3iLwNptZ2ZQqmytJyvlPoDcekc5jM4epzdoRNFYNZ3wAc0KgfHSWl1X8F7
         EJ0YpRnD8EJLKJTmdBOYD5wMqcTEcGwnCJzWqPs8pUTefsEiiyw6WvE2xd9DWdLkHF5r
         7Dbw==
X-Forwarded-Encrypted: i=1; AHgh+Ro3VDAiSD1dlcupxGbzo0fdLEfRy0VuwhrDILKnZXU9cFacfrhmaKiahXhYtAtTcaWxuKbk/BBpFg==@kvack.org
X-Gm-Message-State: AOJu0YyXnSuIou3qIkneWDo9cFptBzb/hdn9Iustx6f3ZWjeIdsVU5Gc
	amBNf0TnzQzBwDouuKO2rtAylY2Rf0cZbkQo2gLpnzRcrkcTq+HJY4b6
X-Gm-Gg: AR+sD10XgZ+Yy+z62U5gaYHU+C7L/2MxzTGvDb6mbcF1sq04Aid+WY5Ar2OVtXgOit9
	OW8/8kTh8siFPFXCWmjleJRPeOxUsr2dF2BWqm3MkhxFdBBE/jzy7J19351jMiv/tDUQ+gW4zKm
	eXlihN6zCid+gh/1AOPwX5eTcPHtF2R0M62oA2kIw9J+mBmtCd81BkgkNkIWSxTIhHC7WkIvDPg
	NTlpNuS/O+aDyCVo7D+cwdgMZW4OxNcB0Rj0rUdJm0mg0SgprpuXy3YUvNacargy9uyyd8LawN7
	+uDsRC3PkYnG/R6FdAdJG0k1cdA4Hh2FyuRP4AgA9p7SGIOKQUy2fG/DQpXLiJIr34pRX6OhI2A
	/0Wddh7XBTlMaJIYgbKA7XsidvgVQ8d+Nz5nYDzL+IJX4WrydWMVFbqrYqih/NGpP2VC6I86Sqh
	fRjJV2l+9kFZht8B+uwag/TGOFxmaFnq+xlDOnQqiz4rusEgLrUbmdM6qUhaAmm/lZZI4=
X-Received: by 2002:a17:90b:1dc4:b0:38e:a52e:a3c9 with SMTP id 98e67ed59e1d1-3955f0f209amr2677133a91.8.1787015584591;
        Mon, 17 Aug 2026 18:13:04 -0700 (PDT)
Received: from 192.168.1.6 ([140.213.202.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-326793c43b7sm10302470eec.7.2026.08.17.18.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 18:13:04 -0700 (PDT)
From: Foxie Flakey <foxieflakey@gmail.com>
X-Google-Original-From: Foxie Flakey <foxie@gmail.com>
Date: Tue, 18 Aug 2026 08:13:00 +0700 (WIB)
To: Andrew Morton <akpm@linux-foundation.org>
cc: Foxie Flakey <foxieflakey@gmail.com>, rppt@kernel.org, peterx@redhat.com, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: reset err to be 0 when move_pages_ptes
 succeeded
In-Reply-To: <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org>
Message-ID: <ae1cdc48-4293-8b81-d142-3c656f2c2cfa@gmail.com>
References: <9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com> <20260817152605.5d2bee3fbf1a2bace4c0eff1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Stat-Signature: fhimn954twp7nz1ctomgk8np1b5rn5zk
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 054C040004
X-HE-Tag: 1787015585-582773
X-HE-Meta: U2FsdGVkX19qmOPevcNZPT6n4tkILASJnvanU0JahnVwAj9kIbg9tu/iEX598fjOHjHnv8kfhqMk092CnQu1PHyUUpTw79S0bRjHaa7mg0WrEQ+I3tKM1wogpTK1TVvpaERJVO98YRucORshxYjdljY1QB06GJlEjWQfFOFLLvV7VdJ/0/79CSTt+2yvLEQg51kIOhz0WuysmhLjIcjTH8ls/nOClAcpE0h/S/N4rh+yGQyOt5NuvKlz8XmT1HS74es8J/ySc5Pp7L2ciYmTE3uR+t5kudLolFpsbUyqljPF7SqYmYjV7kzXzDSIDIhuPTzA6hNmG7oItwLls+0aA2hZDlKyZ2EANZyaOy3xJidPUr+F4cO0A+q/3ghIGuiqWTxqczWvCHFxgQLXGAxpONC9icgPjPnC2yZjckl5MpCWP66rtpj/lZHFMTT/1X1Ir8GbZ9O91gaaClqWdgMNrqpao6fMcexQWPQaxJ5FhgZ1d04DhNw5YytKTht9kB5Po+uZX0SFWB8+pErJogLJzCvH+8x+DHkdoOnY+ktZQ6HeZCeQQRl9jAKcxFVnjF5cB5z2aYbenQhq7GsrDrjV/0aM6+wpsmtCeop9kimjsQyICOqAw/RTnXwjVri/hB1WlduKxIm6SLTCA7yhE3PR72wC2ctZMhkZxjpwEx30pPKf1ngzdIfCjUHrhndqwq7LkTH4IgUXDsB02dXzAwDDB1HZwgXV80+MleMlZD0ALJAuE1Q82CvUZeMoicyJ8C595hKM24y6Hr3oBYIxxuCsUEidfAzrPQaAECELP8GR7425PJQDVOkpBQhDCBP49ARmFIKjcuLxSG2WgYORIrb3ZKsCYdITP3+lj+As0yrS2In4mS82OgW4rUl8N4dYUyHO4CEUMFTS8Ce9IU/Ygn7VQ4RAvQqX8Yzl0KmUtIMOO1RlnmuR+i47o5kaAQxtqAZCksupvSvhoy9zkPAdhY8
 nCmbdSs+
 MdLpMrH3zkGeWE4qfdIonrFSPoS6Ijn8BzxXLv1kN+q8XhFMI7PwS8c1p3W7GGmRg2TSnTqwY244U1lB1FuQIRdc/CorDcBG5tzCLUc5Rh7fa2VxXwFq9xEn2NeE9c5jvOYoIBOxOaru7++Fdtd1wY564NrO+BM8G8+1aESS883rcBrbSqsScpvxv2sKuFeVXBZbUdN9OqcUIUXNUSYzJ2Y/bTiBKyDbHomWU4dOZ6SSiagZKt4FOVc5S0hgFe/FrJCZ0+btD4gN5+849pa8Qa1NRPbGIKJk5vvCEuyr11tu3NCgz8g5YaCh7u+IUzJySeWl7XPZyYK3wkM9UncDJVZMskld9Cdy2WOUciVvtQt2mkN8jFy4flh69xqK0jDEpwPlzJ3R7EbshOtxZxW654BYxD0Yv31moM3SFu242bIcagTk7HsBTjwEm9F4B2AWnZkxboJEODDdTMHiX8Pu0+kiUNzPoL/tqSm+fQlkuGw1Bu7xfj4xDLRMILn7C3V8jOBQEJqZs720+1MuArL8VjsmcJpjrZl1MECSrFCFyy27eCJnLjub5uaeGFprn18HVc2WaGEyhQUqLun68G0254LY6DYeCS1/mxUixMkr4CO+E1Cu+0cJeL5PODBOVHhmo9rQOp0MMffm/o+I85qQUQbLdGR73mZpO+uPwjYT5fVNsluY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Andrew.

On Mon, 17 Aug 2026, Andrew Morton wrote:

> On Sat, 15 Aug 2026 17:42:12 +0700 (WIB) Foxie Flakey <foxieflakey@gmail.com> wrote:
>
> >
> > An fix for edge case can occur if move_pages_ptes return -EAGAIN, later
> > when checked and it is EAGAIN, outer loop would retry again on same page
> > and succeeded but the err isn't reset so the outer loop would think need
> > to retry again so it goes back again and move pages again. On third attempt
> > move_pages_ptes will fail because it already moved and returns an error
> > that is not EAGAIN when outer loop checks again it sees non EAGAIN so it
> > dont retry and break out of loop. When loop is terminated it did not update
> > the "moved" variable from successful 2nd iteration.
> >
> > That behaviour manifested into this at userspace
> >
> > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> >                           ^     ^
> >                           \     Kernel moved this far in actuality
> >                            What is reported to userspace on struct
> >                            uffdio_move's move field
> >
> > When the previous behaviour is
> > Source:      [ .. unmapped  .. ][ .. mapped    ..]
> > Destination: [ .. mapped    .. ][ .. unmapped  ..]
> >                                 ^
> >                                 Reported to user space via uffdio_move's
> >                                 move field
>
> Thanks.
>
> The text is a bit hard to follow.  I asked Gemini to redo it and
> perhaps you prefer that?  https://share.gemini.google/cOWn3pQadvVw

Yes, thanks. I have already make cleaner text from feedback on other branch
of mails with Suren.

> > Fixes: 50944692052b ("userfaultfd: opportunistic TLB-flush batching for present pages in MOVE")
> > Signed-off-by: Foxie Flakey <foxieflakey@gmail.com>
>
> Yes, the pseudonym is problematic - it is contrary to our written
> rules.  But I'm a sucker for fixes, sigh.  Perhaps if someone else were
> to send me your patch with their signoff also, the rules would be less
> offended.

I see, I'll post the updated patch and work on signoff issue later (there
has been updates, I haven't posted v2 which updates the patch and
description following a feedback. Why I didn't? mainly I'm not sure with
answer for signoff)

> > --- a/mm/userfaultfd.c
> > +++ b/mm/userfaultfd.c
> > @@ -2069,10 +2069,12 @@ static ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
> >  			ret = move_pages_ptes(mm, dst_pmd, src_pmd,
> >  					      dst_vma, src_vma, dst_addr,
> >  					      src_addr, src_end - src_addr, mode);
> > -			if (ret < 0)
> > +			if (ret < 0) {
> >  				err = ret;
> > -			else
> > +			} else {
> > +				err = 0;
> >  				step_size = ret;
> > +			}
> >  		}
> >
> >  		cond_resched();
>
> Maintainers, when reviewing this please let me know whether you think
> it should be backported.
>
> Sashiko did what it usually does when we make it look at uffd:
> 	https://sashiko.dev/#/patchset/9c936a9f-ed27-e510-872f-5b3b8c680975@gmail.com
>

