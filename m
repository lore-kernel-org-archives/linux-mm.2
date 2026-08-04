Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA9EC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 171426B00DD; Tue,  4 Aug 2026 10:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148ED6B00FE; Tue,  4 Aug 2026 10:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0376F6B0101; Tue,  4 Aug 2026 10:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B77F86B00DD
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:59:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98D851201F3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:59:16 +0000 (UTC)
X-FDA: 85063895112.13.072162E
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id AB5C22000C
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:59:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HGWmyV1q;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785855554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6N0+o6o8vh4ZAONfoxI8DFf15MDBQKWEc1yozc9H+WM=;
	b=K2isKUMmfrsF/opJ/Spv6BcbvUMozrNhQ5NxIO4oabGlnNVKa01JmsUbITrKMrYD38a7hh
	O7+MFbcvFvt7/fOFOrDya3Cyg5ftdjRw97K1IMjzpFnrPgvVlHeDWnsSuXBK5AYFcy/wq2
	wguSyX2lLyuMvyzsnMFF3Jh9ARD89JM=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HGWmyV1q;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785855554;
	b=srZ/4AS39bR4py9CdaB2qXas2S2s5PGtHi+hbZDrKoNkWi0IjMsErSHHSOqEiAsdWPf/U1
	I8dxgNYyDTq4o73wb+QbYZutonX5klWoNB5GSRt/S9sqbF3iT9kbqM5pzB3GoySYhKCghJ
	twcgbBcgdgIVGMp787Sz8VR84R8vOLQ=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c10e86e52so272731cf.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:59:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785855554; cv=none;
        d=google.com; s=arc-20260327;
        b=VUuttBawBvD9AT7Ctcn7RNpoa92P8vAu1S6uMEmt2B/m+WpSXLCBrJaKuCbLa8xx1a
         88zfiJq/8KYQ4usDD+WV0OUpJBkqExtFcNAWoPKF4qRrbqtGsLp6wAGAzbJ/YVMT5Iup
         LfiNE9iT+63D7dg9VMVi7/myx9e5gV7ot/lP3P2T3Jkc5Rp7e19onYayLkKfV1So2hs9
         8/9/ASfJItc/Wah1wsR1CTpEk0RKc2cMBXnkzgK54nmxM/seGCyRWR/M4x05jLhyXrcR
         cIcR6sMJKxKlbLCxVk95Gu4CNcjbFNf64zYG4aivR6LoVgHI8fNjf5jSMZJVSd98cEUH
         pnmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6N0+o6o8vh4ZAONfoxI8DFf15MDBQKWEc1yozc9H+WM=;
        fh=C17gkYDMLpY1RNXEuKo/ElVhR6DNFIaN/SmOyej36Mk=;
        b=ZBS0YQ4/OputYM3y0fsyAHpNnT6QJHwJMRCIAQZYCVhAcB+iE7fYLoYuNS0Q36k6sY
         YHJKZBd7s3LgM5OmWUF6UGuSB2ipBM3UrD6HWuAbPw0CAaOTUY0KmkhL9vgzxJH8/1SR
         l24VdZ9liB27uBo/sMZiFusgw/67gSjCdOKYAR98KKMLur+rNCz/+g9encC8hVrv0wQI
         iwUk/9F0BInuMkR+G0h0TwD6Ie0ofISS+XJLTNrbc/OZ40oOVPndEjfADT1DhZ2ZMaUH
         QMYrUNchf7Yan/d/KT/xJ16FHUtRTfMZ33A1YXTPpe44MN+14cREPMsXd9Uhd8RXDLz1
         0Cdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785855554; x=1786460354; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6N0+o6o8vh4ZAONfoxI8DFf15MDBQKWEc1yozc9H+WM=;
        b=HGWmyV1qC2DgUSyDINE0I1BoVBly5gR5y49mwAT/8ubqrON+REHyv7v8y/FFHvsgi5
         c8JNgwZAo/Oyv/I0tWrPskKBO7qcJ2zCWs7i/FLgAkG/OlWFAiBdvpmbSzCxCresyaRz
         32v9fO0asq1lnhqI3u6e9pUekrkL+j2EQ/o4m5uy7UaRqPNPeO4aepJfhS0Wau2ox6NL
         tI/qfE8+r10QPi594Vlyqy8TbWrXKmjHiFG9yBvpP93H299AtT92QmGl6viiYKe/gOSK
         VanDbbKK4ZXYrtwxdcVYl0hr1yeXJhltPzaDRxw9BeVmKWTVUpx6NTBKo4wEo54XZ6td
         OvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785855554; x=1786460354;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6N0+o6o8vh4ZAONfoxI8DFf15MDBQKWEc1yozc9H+WM=;
        b=Bl/ciN5rTc3O2H8g65mhO6XLmET2meSF/HLZWkqqJ7Qpmcvw2CMzu/pTOqT6oxGx7f
         I/WWAlQhFjs1sL3X4oooqOaBjAw2fMatGZSNOdieYkk4tZhUHmv2rFjiwaYBwHmwCWvH
         PdhgsOAr3MjYQAg8HBTF+6zDmM6I0gGaTDhL08eV4ZweRzyGBSnv68/OwMFOm83wmQc3
         jRgO1h/UXVGWrtY5vIwfI9sPISCsB6n6TUDlEVn40mB11RtCmVDiPRr6PKoydIckSDjw
         N+CkVytijXU7N72o3o7tVplFTsYfK0F8OvcmXw6DTZD0ZerEiAmGgni22aNfGKuWJvV0
         t4rg==
X-Forwarded-Encrypted: i=1; AHgh+RoF0zOwMk6R7MgoGKTbOF9CnUf0KAkoI4hO+djSKWLzUnTMD0tluKEHhSbLK4c2fbbvjMoHChgEpQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3DRXuekO4fZho/a70YFuyczL4P+4iHKUPA6VMI7TOIy79FNUN
	8pJkY1EHAQrg0K7g7M9Dm7f5crRe+PyTYMHCx9w0zCeLZcKeDct8bpzXEc9hEoq95asFOrjNDQp
	Xvrw7mRnVAr25+UA5byOXcMOWEFCa2IZ2P7dqWmUy
X-Gm-Gg: AR+sD12pE1R8sJPGr9bPYIC9ITvvgZ4Gyf0JqoRCpUORam8iShTWSxpePv/kbC51rn2
	jcZiHRp8z5KbO53m/axJmv9r8fkX2pRz0poK/nXTPfd+b2cH1OCLn9l8rL4Z39tETt2j25wn+cZ
	EOsR/REezzYnkQPg3lqjc6QdNoD7YGvPnb3Qd0rOz3QYhKNXP0kw3WXEiH1Qz2deVAyOWM1WFMm
	NBmTgu7MKRIzkft7+E/ict6hxTSTQrpyuLXOjTAoqZodxjUhDnMTaUtgfXopPClUlez4CvxeXgz
	6vbOkMv+i64HABeDI6e/gP2TugVfvIoRo7aW4//krOI/NQyk8XaxoI1Klz0rqHpJvS4xsYasluY
	=
X-Received: by 2002:a05:622a:6850:20b0:516:ccc0:ee38 with SMTP id
 d75a77b69052e-52ce4056a53mr2078511cf.9.1785855552922; Tue, 04 Aug 2026
 07:59:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
 <CAJuCfpGezxdaSme_QpHVq-QVeZAUaF360_Ajvkrn3QqDcSQVog@mail.gmail.com>
 <anC1iE21eonDK06n@lucifer> <CAG48ez1=_O0g7rArdpoVwg84jOJuELEAXu5sw=TO_CWBsK=T7w@mail.gmail.com>
 <anGnOHgOd1q1jYXK@lucifer>
In-Reply-To: <anGnOHgOd1q1jYXK@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 4 Aug 2026 07:59:00 -0700
X-Gm-Features: AUfX_mwQTNrlkV3j7o_hqBHBqc6QYgTKXR7FHG-xiWygkBEgZziw2u25uHKbB9Y
Message-ID: <CAJuCfpFCBr127TJEWvanRtYxM2G21h-Y5NYK_hw9y0CrgWQF5g@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jann Horn <jannh@google.com>, akpm@linux-foundation.org, 
	dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5d6t54k37rchhxuyuoszzzzmg5g1cq1g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB5C22000C
X-HE-Tag: 1785855554-589694
X-HE-Meta: U2FsdGVkX1/h6+hXXOl7bxQMNoqX5GlcLJ/aRiSW1lwJXN0uhGX6ApKoKK4rWZpDmYVIe2CZPNHe6LUya7MlCAzDqV3AXlVCFrr08GlBwNkTzPlWS4I2J/g/ZGfDQxIHip5CqOmMhC9wwvs3c5ZFCSvKDfs+TakExbJPo5VZ2XtDz4IPbFrwhCtsfZ3c0/j9weCXZALoXEmAg8+I7h/eiu/WuN3H5pkANC+pGLAoDZviMpkueFehr01GS20SoyDHMj9Wao6vlw6eoVagWx5vMlOwrYz7gkNhr5oEegBqn0aPC86RSg1cHtjA4sYTn7Cmsq9L4OGXHUY8BQbHF6evdzS2WTSpuKR6h+HjhVuTMBGdQt7HJKdSk+j6Ljszi8A0yQvNsnxFUbzrM9DGffqP7kZXZUI1/QgFubnWQ3qTla3GQpAysB+0yk3r83PCLHH38r3utCTtwmKO1DfNJWJJ3gUt2KHDPNPvncn7f5nTf0cRX9Coe2Sp3TyQmjOoUdM1qtwRqJH0culGEmneXQ083PVTutpwn6AthVH7MV8UM5ykFkgcqdRPYJhjylMW+uVEOp9y29MJ44HBtUD4u42gc+FhCul+BeznnVlTrBzO8E7BQEvlLIW6sjlkjpfvHgxdwia8++y4WUR3Gsb5Ykd+o4wqxHg8DdwD7V89Jfz3g3iFziRQLaZdkBC3gWdUVP31T7glRwp9Nfe+6WlyYPRWTQtJxopO8CY5XolvnTy18yXMN10tdzGtD1498LqcGc/FP20K4CVgmF9MKxulOfA4DtHIhPZnUF58xhRIwkuqZ4RLLjGWrJKLyqMMPmOn8YSmjL8KNb3h35gY0S8zN/wJOcUOKoZkDovn2SrX4VnFyJDcE+MhzL64awT7wIM1gDQUB2c2g6yYkfVuf/yj4/KZxGFfuKkzVBoqo1rF5ThPo7REeOg1MstsY1U6BwMf1zXVvvuMsNVsANQeJbGskpQ
 FIq+LRuj
 lsabLMDbv+bKr5Fnly0h24fpO5bKViMgvFmqYpJsqMW0kMj94hSfgM+AtufzQuJglO2kQQCYGFtYHbjxlUegTw0aQFfFMsKIM3AdwKGCkH8SYpQ4jErJDYobBMPHkmov52SAk8ddDXN3rNiox2Bme+HDW2QBpXUEyCMYtB7JB0H5OZj1ATS6g6xIgwV9FVwP+l/Tr1XM0xVoGVdS2AwFHR2XJdOPBQOEE5vMYZjBxsqWJYzeHZ78Vc0Ott4LbiL41whQyHkx7KMTyhMod5MYQkJhA2gKZjyf3h6xUjkPF53sLdR2o5YTQFFUBmtySZj3iDyAGChITgSkee9ysqUgUjHbxzYA09qpizuHIPFA6DFyk6Qc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 1:56=E2=80=AFAM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> On Mon, Aug 03, 2026 at 11:12:01PM +0200, Jann Horn wrote:
> > On Mon, Aug 3, 2026 at 6:08=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kerne=
l.org> wrote:
> > > On Mon, Aug 03, 2026 at 08:24:44AM -0700, Suren Baghdasaryan wrote:
> > > > On Sun, Aug 2, 2026 at 2:55=E2=80=AFPM Suren Baghdasaryan <surenb@g=
oogle.com> wrote:
> > > > > -#endif /* CONFIG_PER_VMA_LOCK */
> > > >
> > > > Now that I'm looking closer into this, I think we would break NOMMU
> > > > case because nommu.c does not take VMA write locks at all. So,
> > > > lock_vma_under_rcu() for example would always succeed.
> > >
> > > I don't think anything's broken actually.
> > >
> > > Per-VMA locks was gated on CONFIG_MMU so nothing there assumes per-VM=
A flags,
> > > but now you have stuff that happens that didn't before but:
> > >
> > > * vm_area_free() -> vma_assert_detached() - fine - it's always detach=
ed in nommu.
> >
> > I don't think that's true, AFAICS vma_mark_attached() is called from
> > vma_iter_store_new() which is called from the nommu version of
> > do_mmap(). But I think you're right that one blunt workaround for this
> > would be to add a hack that prevents ever marking VMAs in nommu as
> > attached...
>
> Thanks Jann, though also ugh god at that :)
>
> (Really the ideal solution for nommu would be a 'virtual' MMU with noops =
for
> everything IMO.)
>
> Anyway, I think we could fix this with a:
>
> static inline void vma_mark_attached(struct vm_area_struct *vma)
> {
> +       if (!IS_ENBLED(CONFIG_MMU))
> +               return;
>
>         vma_assert_write_locked(vma);
>         vma_assert_detached(vma);
>         refcount_set_release(&vma->vm_refcnt, 1);
> }
>
> Here?

Yes, I think so.
I also need to make sure mmap_lock fallbacks we are removing are not
used in NOMMU, otherwise it will fail to lock_vma_under_rcu() and will
have no fallbacks.
TCP zerocopy and binder are gated on CONFIG_MMU, so that's fine. Need
to check the BPF part...


>
> >
> > > * vm_area_dup() -> vma_lock_init() - no asserts, just sets refcount t=
o 0 (correct).
>
> --
> Cheers, Lorenzo

