Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5E80C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:08:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5EF6B008C; Tue, 25 Aug 2026 03:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56ED6B0092; Tue, 25 Aug 2026 03:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9455E6B0095; Tue, 25 Aug 2026 03:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1DF6B008C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:08:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D33B80344
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:08:28 +0000 (UTC)
X-FDA: 85138913496.17.5ED3BD7
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 303FD40003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:08:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=IdqS9Cis;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.173 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787641706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FUPUaRwtppzW7Cz0zNlhCOY1JMoitTGaOwtquxqzhgM=;
	b=KQIIW4pbleJW7VgiOEbCUUBaWhSb8P8tsDeosHRIC3Lpndk5PwxrOmj5buGzbPyIzYixM7
	PVBiojWr9Lk5nGq1MvzO+F8XZFOhB9BrII4kkr8C1g2T2uxtAI+euBB6P/ynkB5zBrk8d5
	o1DKXExa34jNdSIJH0hgnIP/KIFcthc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=IdqS9Cis;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.160.173 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787641706;
	b=Sf1u0Dl/gquczmEVqkOgi4ka///nk8Ek5ow4nU9DKReRfOBJ3Q98oYgkeaAouNrHPwwVw6
	qWOJJ7dshl7JlL2xlvHg6QR0kNmYCA55P2UpbGzmvDbeLkJPxg3l+0te3C3injTMmWkz7l
	b1UKYUmb6gan8nz/xRr0MbKKMeXlsds=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c0c45c580so28005521cf.0
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:08:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787641705; cv=none;
        d=google.com; s=arc-20260327;
        b=Q65NRSI3Ji5AQVb0cPH8tnj4ljsbY2q03i7lEI6hd3uGx+h56vZsH7VycPUguJQ3Ry
         D4SU3ShT8fUb+Wlp14gPMYWaQFMcR+sGfBqf5u5cqGxXKWW6vfTEtsJ3fuImfogSJg5z
         Nl8vukie1Ycc9LViSw92pzPw2ws37mm2KrIDXThDVgrR38/pLr31VAzvMA7l5/J59/eS
         05N27gnhBdaU84HNCerhPQwN/iqUSQmRukOTEJtAKCztXu4x9y8sS6btYTnxmJUOW+Fu
         ujOJtjy9K33vES7K3iSFlhgFMSm/FsICrxF2/HbYxqAvtzxF70wWUDWh2gtuK23V3PtK
         egfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FUPUaRwtppzW7Cz0zNlhCOY1JMoitTGaOwtquxqzhgM=;
        fh=DLYCiCQ+6DYJxmQwWuOfpgHFgVhh+1yMpbWSzgF7f2g=;
        b=tBWTyp3AugZPFlLdHdg93cpR36DJTYDPZEfX1Am3SHLzvT7Yg49hjmd/Z3DgSjdKe5
         EuZWTHGap7ZOmXLEJTjcRCJvouxvT22uyXPBVnfX3+J5o1uzy6yn4SiFjTaOGmXEjBvU
         pwfmKoBw0TnUXb8NYKnBu2eFrQm1nr3rJ/nn5MzAb89gzoOURNgZEnsGN6YyxP0n1kkR
         o+dFljotbewTlXe3gY2KajA71cyCJS0vBbopJqxxLBsYUWvcU5rDrTU9OWDy/wN2Gj0N
         pIoMpW9vX3uRNJufDiRtaWCdMjCLrzZ8LLbDlVZSxEFTCIXzVhKWWL4DsMi2QA1YMX7J
         5zLg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1787641705; x=1788246505; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FUPUaRwtppzW7Cz0zNlhCOY1JMoitTGaOwtquxqzhgM=;
        b=IdqS9Cisi6aHY9+FyhJCvfOIYTF9rxO32QsdrG0zBiH6KhO6wipE9KX0Mxelx1XEip
         0Kcw6h2B2dV1I2Csx1XCmZvtNJwP1Fj9FpvWFAe5+im1MkBd1jSVJue2KkDA1ZUjv+6S
         XJveiDFW2dYYWexQZX5cXMj72IU20pJNhDXlY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787641705; x=1788246505;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FUPUaRwtppzW7Cz0zNlhCOY1JMoitTGaOwtquxqzhgM=;
        b=GMGE27yC5C6WjTfoyxX7SKrm3iWAm26GfFkJkRG4vAT6cLRaYYqV1jRxskP+ctChpu
         ANtYDaffBvsrq3SKZScP8sd9+Tw8Fza4F7TKRupmGhYtlEbxq0TgDX3hMsVguJtYVPTm
         OZMpKA6HAGI9Yj1zlglbz27eO+szY7K+mewtlMHBHpC4bLbhjukBahrj8DzKcCpNbDNo
         XFUWrbyaMAUg61dT8A3h3bo4RQ70ca819S00yV9Txgp418ageHl/9/+m7Vw5ItqExUpU
         bCyT9ECMSm8tzWi+08TdU6XEZ4NTP/NX/8+KpFSWdlQtPwJgqDOldD7WWsc4W1AvmFL4
         3QIA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/Ac//edt1ZfVQlEPr4urmwYfbyxT3/wHPqYOaqCRHCQ7JzTJuxLYrAtJHUYLCiiNw7aTvryCtlQ==@kvack.org
X-Gm-Message-State: AFuF++mHIyvtv39dSHmH57uTzW5vjgS4WR8p++at4oprh5RzEKReFxeY
	6RFFBo5z07PRZIN9duGTjEkrVrr1UEB0LV/u66h+0bBn4MlGsFDp/iT35ZreR3xLsfPUqgPTPWZ
	Yhki1aF8gZWdaV09yW0xrs623lKMhgxn0m/L48L1ANad6Q+7ipnw2l2kJCw==
X-Gm-Gg: AR+sD10+0MAQILiBicbCHm8ortg4K3iqYj52EFcf7lEd3Zu6s9urPgmUodonnz/vG09
	06M6FRtZDnY1RWkNxQUdSVQN7gc2RrNWNrObYLneMGd2cO+keYhh0L0bwlwq/21fi5KT8XR0Pa3
	aZzEJKj87S6XBZwxsfLldjb+neVrkHzglqrbtyba8VyiuvbaWkCq8Bo8gnsj+RMpElb9XL28WG9
	J8Y/5p51yqD2phUn7raCLbU+LH3sLLPhfjfi5fAbCtJRjGc1+2XcmewyFb17PMXtTwLoB04CnDr
	SPpdlaqimSEwv7xIc/+yd1HzI5Gufx88/t9Rl3FsajISfFa8t8+YrHKij3vzEyVHynZSEgTstdE
	NoBM=
X-Received: by 2002:ac8:5f53:0:b0:52d:6afd:7db5 with SMTP id
 d75a77b69052e-52df59ec0d3mr342600351cf.25.1787641705339; Tue, 25 Aug 2026
 00:08:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260820193343.3852967-1-willy@infradead.org> <20260820193343.3852967-3-willy@infradead.org>
 <CAJfpegvP3i8ZJc2T=+f4rAhZ4E1QcT5+jC6mQPLxtB-yoK9Brw@mail.gmail.com>
 <aoxHOSC9kTPbKeNq@casper.infradead.org> <CAJfpegv3Ak+qNLb=fTSCSz7-taQ3Ui-Hkmqgn4PaGPe=CR4cbQ@mail.gmail.com>
 <aoyKxvdQdeJQfPHj@casper.infradead.org> <CAJfpegtgenUaudDcvecJuV2_WkkVw=gdcB0Eqg=UFKPMZP1uKQ@mail.gmail.com>
 <aoyt5pL7mXYwSqsG@casper.infradead.org>
In-Reply-To: <aoyt5pL7mXYwSqsG@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 25 Aug 2026 09:08:13 +0200
X-Gm-Features: AcwNN1VLOxg4TFDsQzXPHVySuwqrEIZSjxOFz1CuAgo80c2cUSWOrt0F79eOWzI
Message-ID: <CAJfpegv_SKhArUNBFUtsmkXSn+JzYgOjhFOqVf-Yd9MnsjBY_w@mail.gmail.com>
Subject: Re: [PATCH 2/7] fuse: Use filemap_invalidate_pages()
To: Matthew Wilcox <willy@infradead.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>, Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	fuse-devel@lists.linux.dev, linux-nfs@vger.kernel.org, 
	devel@lists.orangefs.org, Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fsm5upm5tkmbfiytz5yfwit94w34tpmm
X-Rspamd-Queue-Id: 303FD40003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787641706-123517
X-HE-Meta: U2FsdGVkX1/Xpyn5tJitVAsNmek1EyGsufcbyVVpr+TwLBAMKsm3ZbTrP7iyOdR8i7khiWHMi7ds58SN/fFLO9Atr7s4x0k/gu8GQ79dWDml3SxWzZsgQLCDo5nA53uZDYTLbp/0y7Q4CaurMpNh4SNA8IrFuXSrrtcmN2+CLxCuibfK1Ai3phjanKz9kcSp3pjNxxRy+EN2xV46gPo2+a+cPK5MOpCHBkMVseqLQKdLUKOV3Jtol9JJos33yYfz2l1dbWDcy8dWX+7xgYBhjxf/4hgkWoGyUhhd3vJjXnXXusC/f4jy/jWURVQjR6JpkW7m9Sbh2Nv8908c4dKKhdlmDXVq0CJiICO/U6IscUotjUHJM1mDaYgPI3ceg5Vz5LL4qaU+d6zxr0RV5YQRJCa08GOvOQfIxKc/cJ28rYrk/RyL+ldZK6+IzobKsyhSPHm8i6Yw7sonvz15NVtvavfm/tkgxBBdvKTIdMu4KmFeX8k0z3LHaUIRyx65oPazLgFFc2aPU0MmLZlKgHluOmwRtosyE6xSh4GCM+aJ/Fueo1eG5qB5eKoyNkj8TOgAEOtuC6uB9zTz0Ps2dohEyV5qNZb5nA6ycdlLg64Nsjvwr/ZTUbvPQGr7VE3B4KNvgygCBKfdmxBZFc9INKHSbbzDJBGjlmF8p9mPvXgmtfdnoXwEhmxRAFI7mX0zNqfiOin7xI5Ohb9C9EOm0m0oHgV55QOQTYGf8LbAfxS6m/Yewzj8PB1qunOtFLwY/JG3QWnWInwTI3KFUV8NFK+El+CpXrdbg7JrvvMFKQiUjatn6zwK0kys91debi6PsfxyvraEFVvKPRk7d0KgkSu5DZf1V7jskCcm7hkwNXkUmr/koKm+P67l60ru/MwaWzKLwVZri6Dl3TDVRqmgblXaMGoonr1WiNFx/WxOokbphu1re1Te8ZpUlmkmuLGOVnhDnH+I0eBAP/kUDO7BSA8
 gx44EMNs
 TscF1SByrNJ0WnDRNz/jhYyGkLoYd4UxtfAfoy9Q9QjrBSqQcMyrlyu89+Lu5/lkI5y0ZKVu1zMCSvdg3UcKNPpjjdTiXf3jf1ALp+FF8GMVij/1lOccL7mtMTAEnMtr3Utse343cWzzvlzPw1EZXVppbWlX7ZiqGKiaVknY67B0yOJh+YCsh8CUxhOrEntgoaRWvXh/H7P7C+Pk3Xc0oGsnbsI2b0PYfSozqw8MDdiTOc3KBSpNfd5Z5748/IDpZEozt75dzfh5vdr3YlswLs2SCeO2g69JHWWnj29hMi83fpa/Ug4ThzVbDR3dgUgPc3omePqIx0IcopyYzpPckVj+2F5LbA6/I0UENfAad4LfhjQS+MYrAinY/bOBluk9QQVyc/FR5BNDp8gzd+Wl2dQzile4SKhtUgObPKmKZrMdvOqw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 24 Aug 2026 at 22:47, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Mon, Aug 24, 2026 at 09:33:03PM +0200, Miklos Szeredi wrote:

> > In the second case filemap_write_and_wait_range() won't write protect
> > or unmap the page, so it may become dirty after the writeback.
>
> But that can also happen in the first case.  page_mkwrite() can be called
> immediately after the folio is unlocked, for example.  Or the folio can
> be evicted and replaced with a different folio which is then dirtied.

Let me try to make up a very concrete example.  It's not realistic and
very unlikely to exist, yet something more subtle might be relying on
this behavior.  I don't know.   At this point I'm just trying to show
you that the two are really not equivalent, not that this has any
practical significance.

Let's imagine a distributed filesystem based on fuse.  It wants to
serialize accesses to a file to avoid sub page writes reverting to
stale data on cached writeback.  Cached writeback is unavoidable in
case of writable mmap, so it tries to handle this case correctly by
totally excluding cached aliases existing on different nodes.   If one
node reads a range of pages, that range is invalidated on all other
nodes.

The below example show store to a single page on node A and B with and
without launder_page, starting with both having the page mmapped but
not yet in cache.

1) with launder_page

store on A
  - send READ
  - server checks that no aliases exists
  - returns page
  - page is mapped in address space and dirtied

store on B
  - send READ
  - server sees alias on A, sends INVALIDATE
  - INVALIDATE is processed on A:
     + page is locked,
     + unmapped
     + data written to server via launder_page
     + unlocked
  - returns updated page
  - page is mapped in address space and dirtied

 store on A concurrently with previous store on B
   a) happens before page is unmapped:
      - change is written by launder_page together with previous store
   b) happens after page is unmapped:
      -  page lock waits for writeback to finish
      -  sends READ
      - server sees in progress READ on B
      - wait until READ on B is finished
      - sends INVALIDATE to B
      - ...

2) without launder_page

store on A: same as above

store on B
  - send READ
  - server sees alias on A, sends INVALIDATE
  - INVALIDATE is processed on A:
     + page is written back
     + unmapped
  - returns updated page
  - page is mapped in address space and dirtied

 store on A concurrently with previous store on B
   a) happens before page writeback:
      - change is written together with previous store
   b) happens after page writeback but before unmap:
      - since page is still mapped, store succeeds, page becomes dirty
      - at this point we have differing cache contents on A and B

Thanks,
Miklos

