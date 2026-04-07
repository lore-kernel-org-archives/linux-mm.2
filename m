Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC07FF5125
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 16:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D51356B00C0; Tue,  7 Apr 2026 12:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28836B00C1; Tue,  7 Apr 2026 12:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3E876B00C2; Tue,  7 Apr 2026 12:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B22566B00C0
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:32:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63281E22D9
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:32:58 +0000 (UTC)
X-FDA: 84632304036.06.96C2D29
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 41E278001A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:32:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOgUqsVX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775579576; a=rsa-sha256;
	cv=pass;
	b=JjaN206V10hFC1irwsWPkg6wOi30MdjcUb/u5DY04JMJ7lV6EMIIvUAadZTLpNofZxgbSk
	Drj8dDPAYfdNOq31VroCWnfjREtkejP26gUSNDFxrda6TCnMudvkiKCC9hbhWjrNal+y4I
	PJurmInkT5CN1FOMaZq1M9tkDJLCFVU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775579576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D08YF3C7gaIOrt/KDm0mueNU5cX5u2VSKpuLteAqV1k=;
	b=yLZljxng1W55CX/wn9HQqPTGe9fohc3iAjIU4PPtACOuDUjpq6M/cwkHOEC3ZjqFXVHrnY
	JAuKDC5McHYI5avQx0qb5i05PsBXXvsQeH3TBbB4H2klQQ79RlyTSzICsR62LUvaJEWUQa
	5VCP4Iia2aY7IVKanNXkqcBY/n51DXM=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QOgUqsVX;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66f916529d5so148719a12.3
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 09:32:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775579574; cv=none;
        d=google.com; s=arc-20240605;
        b=TgeIJzy+59q6LYNBxgtL2jI7KK+6HmV8vTj4rbr4gP15Mww4v3qYOXcSl/W14Rqpxy
         DHfSlM/bGCah82Qws7ec30L3OyTbhONAaPjOs3LyqYTSbosTK3PMJQSu9W8hiMo3Xcjd
         UOgxfLQr0MjXOfxdzbgstGvI62cJdtmqiLorDcOMKgCYws3g6xVBmk6RTrK0pQxgi0tl
         KEp1LGWqvfnVS00L1K5OzSzTzqSY1jNwOaD3hdODM3iaWv3UlnhXt+TnvDTY/0FgvhQF
         II3NfD7CRrDNRjeUtQrF7ATPjRlOkUAhiWLSD+BfndMtxRWbyQgtpetOpRzVUnyLfSvV
         bKYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D08YF3C7gaIOrt/KDm0mueNU5cX5u2VSKpuLteAqV1k=;
        fh=hkrBb/2g37KxFzHvOmrZ16gLM4mN69IbESmnfDdBawM=;
        b=WJBoKI2MRNS0f5pBleFG3I+6TwwXq9FOQcly9S4L8sf5aTX9ejW7FNHRlZlDYnhuVo
         YUPe3jwu2j0R18PYVZxIdgd0X9qK0IK8CSMpiiEFfJH4cEl6nSDUVI1fuUBRIA/JSsUA
         DAfj1q6LrBHxev6Qusk0+IS3NlWKlLbwziq4kR37iem3mnQMh+N6UqelA3eB0eOu8YI/
         4CbyUOBxKJaxC82pa3E3y8rqNFQXwy99bSy7+TMr+WD5ykBCEQosSiUs17VV3gjS6/9O
         ed/f5gpG1kzlIynbcVNoOkyxRQbGMQ69HQu9y7VbB99KCmzn2rrjWVp/8HkaNCndyCZm
         tc/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1775579574; x=1776184374; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D08YF3C7gaIOrt/KDm0mueNU5cX5u2VSKpuLteAqV1k=;
        b=QOgUqsVXPoHtT7kVHn2yrNEuDeqkG3U2ZLfZXTJaBdeIQvsivA8j7/sl5PrxalLhCA
         jGFNhTNms9F3HKOUR2ChJNp3X0X7UDiCigNpQ6XgppCoaqLyPRrMeJQPY4xuEz4AoY2q
         H+5LC8fkKd+dvon+9sd/JRS6C8Y46y/AOiRaZoMRzGiHbhkDTms28OVsb1Ms7eDJJ1qK
         c0l9K5PLh1kW5EPHI6keB6s7DJaNEYvqT2+GfDlafLxYZpYjyYQqXr8f/VZpBosuVkBm
         2P7TsK6v1eyVcwA5+Okm9U1zawey98cnAlfnjbcwvydiu5rop98A5xp52z31Znu0sEEV
         5w6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775579574; x=1776184374;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D08YF3C7gaIOrt/KDm0mueNU5cX5u2VSKpuLteAqV1k=;
        b=sfuNlzoKgzKKqpd7lT0uLC6Mov/Rkw8xOp+e9nfgaGp1D2bFtk3f3XaMLGCHwf5lWb
         9vtL2F6CjXQFSdPheyp49eNF1O1khHvOGdlDdOvEI/veFudJYRFKmKF7yCf0c+GMaZM4
         veu4y0d6y9Uqt9wIUD5/52arXD/bO5Vsyx3xafLtpAF99ymHAqlq29O7YI/5YpGFnPFL
         g9FudQ8EtRcdKoebLjt43EHVpzgq2ysa8bR+KPbanOtwMv5k9PkMtfJTeyxnhwuE1vSv
         lJ51uzkTjjY4aKZP4+A0aBNBALoKH1/pIWXOuIrzqJHX1MHiFScYMjDVPpGpxTpbwNHc
         QlAQ==
X-Forwarded-Encrypted: i=1; AJvYcCXh1EwgBZtRfAgmvrBCMyhuuN72matwMnCg7o77zkAdC/ffBeNON1VsXjHe26XvkKLinqqVupQY+Q==@kvack.org
X-Gm-Message-State: AOJu0YwPaDBt9nxoT/ijIPFb/7gwEZ7VKWsWAsMCrghHqoBcgscM+heZ
	+eraVMwEsKDlkDEXOIXC5FQQv4ITdrxiRkzIVvbeO5+6IkgCjGOpMRDE9lVlVc7a7+KOfA3im2L
	SFk7u0/5R8L3X/asnrtfXnYo6maQ1A/Tsfpnf1WOXfQ==
X-Gm-Gg: AeBDiesNuGrW0MDFnUlpJUX5KP/yqc15ApGtnTs7whHcGqx7lGQ00aqti2uFoH9ECug
	upXNmKiB3B80fBqur1yeOAuS0FMo71jjIUbUxruRpQ76sHtLAZrCAdD4W1s0YMBA+y/NKDmfc8C
	WnzMJqQhggZD7HkJlUHZXXV66CzrwKNsqZL4mcGqtDrVd5sZD2aI7Y5A65GVM/X90MMvjK3RZn0
	tw85OPG6vLUx7RbjIp738IjZZH5CTJUnQrILD8qaqDYZTP0odsEMlAT2eHfOBPOGEOMFvDlCpHZ
	OG6/nWiLSULclq/GnaqowmP4qVft0HOzB/DTPUXyFu0h2dOa
X-Received: by 2002:a05:6402:460e:10b0:66e:5664:1e2f with SMTP id
 4fb4d7f45d1cf-66e56642201mr5605470a12.1.1775579573998; Tue, 07 Apr 2026
 09:32:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-2-mclapinski@google.com> <abptg2AObfxkkxKf@kernel.org>
 <2vxz1pgravke.fsf@kernel.org> <CA+CK2bCSoKGxfV+0QL46p_GqC=rj0YhcvP__bLrM2rVTgTNr=A@mail.gmail.com>
 <2vxzse96ah20.fsf@kernel.org>
In-Reply-To: <2vxzse96ah20.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 7 Apr 2026 12:32:17 -0400
X-Gm-Features: AQROBzDr_wa6PG8u3aIP6J0dUOY2EAUmN-EmDNqiTUddHsGQiNSzAqI7mC7Gp0o
Message-ID: <CA+CK2bDVKdyT8aFPhn01r3wL+2Z27iCH5ErJY1rk4qxFmajfyA@mail.gmail.com>
Subject: Re: [PATCH v7 1/3] kho: make kho_scratch_overlap usable outside debugging
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Michal Clapinski <mclapinski@google.com>, 
	Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41E278001A
X-Stat-Signature: powmszugirxdsg3t1oqjkhsroyqyusb5
X-HE-Tag: 1775579576-902560
X-HE-Meta: U2FsdGVkX19hDLS2kPWlx4D1GYeVe2m9TM7zA7jBRjGf0+suMWwwU+P4BKS6VHzU/N7AJIN2g8hQThCv03KO+xRrO9YOOXxE+hWqeW4NHpq8FjrFQFIOX3VhUkKON10FMzqDbFZOzEBGIOi/2f8buezwwfarG3ILujJcLwtwnkGyMUslJDzNYS8tyY3me+yvANVWwW+RiE/PBsSAQC4gkLw6paMLnF1yM6Hogfa89X1ZxSj/KEpq1/qdn2vK9EBmtFhWxT7Y6TseXbB9jJyOwaNHVadVfR5AUEAfwGxXl5RlI2BYTC+cVKwLqR6Oh1PLNJfKyC+IplhJwQXd35iHWMCNx3ZXFlaVgBDvdWOwwsMgbQ7jHt1ZrBtaI/pXRacEH9QODqI+DvY1v8o1cd4Qva5Jj16U/16Zyf8PhwD0kF6oqw4hf3AdZ2kv4rsG+tnQEAQ0eHoM3F5BGJQMS1RGgzPRJjocYm8nVhRDjgxRdoESvWouaSrF7gBVX+ZS8mbTD/mop4oij+3NGT/DaFiucgYoOm2RjiWvWu7aVMXKRck4kvYayeYom08uwliD1dHoLc/eT7xLMURg0P3mGkKSf4VPtYVT1iD5PKnDTfetk4A8jzFBZBXvM12CJyM/GLtWejosyviPFlOXk3qNXNt/J4IO8Ym6jB0TE8UHYH5kwMwNjFcIS90eMxQEI8jcZ4CCRxA0XKhC2nbDcYTYuxS/JtXzVEmCiGOh9wJjx7s0JCVQe9rNd85L3lIYwvXtdoryClRfCD0MWn0ScGsax//k3Rsxbz3eb2pJzg/cQ2inyeNB9TJlPYpXlJYX54Vjmggr6+v8nFvvl9P74MUi32PTbv8QlW+dxOVvtkQGa5qIjEa+GEvOoY2fZvgkbVFC4mEtXRI0lI3Qb0XdiVBwFhfHis/xv8soXygVHtnOnc5OUY8SBy6kvhT48ggecfGuJISbNPABgrHVcN0qBuCISSS
 gVg8GDwq
 yXwjwsYLdPfHHqChZ2fQojaUbhoyF3cchz6aiY+DgmkTVt5mLwJWyYWGHzSVBmqVF1y8F1lB/YYm6s57NAac4nOuyTtq5DzKKuiVqsHy1dEGVrBMD/k1vcLhewZt605rWVqvJTT9kBAhbNO1CHGaKAcJViY/3fd66LywGKhEK6F0b/y9sp2b0OPylNb5X0LQIPlFvCetUD04Uf2CQXcXMD2z2unMArVxwKTXhzMbmKRn1xRIQZEEmtCgG6jTMFx9yo8Vw0fpOzz9GjiO2r5dxfWNviunMG2sSE7tmkJFf9MmvonYteJrns92OjxxgtdccGvJppmURIo+yIVZ6YSBDwziMJkh7MhBEYEneui/eCTyOqiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 7, 2026 at 12:09=E2=80=AFPM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Tue, Apr 07 2026, Pasha Tatashin wrote:
>
> > On Tue, Apr 7, 2026 at 6:55=E2=80=AFAM Pratyush Yadav <pratyush@kernel.=
org> wrote:
> >>
> >> On Wed, Mar 18 2026, Mike Rapoport wrote:
> >>
> >> > Hi Michal,
> >> >
> >> > On Tue, Mar 17, 2026 at 03:15:32PM +0100, Michal Clapinski wrote:
> >> >> Also return false if kho_scratch is NULL.
> >> >>
> >> [...]
> >> >> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefil=
e
> >> >> index d2f779cbe279..dc352839ccf0 100644
> >> >> --- a/kernel/liveupdate/Makefile
> >> >> +++ b/kernel/liveupdate/Makefile
> >> >> @@ -7,7 +7,6 @@ luo-y :=3D                                         =
                    \
> >> >>              luo_session.o
> >> >>
> >> >>  obj-$(CONFIG_KEXEC_HANDOVER)                +=3D kexec_handover.o
> >> >> -obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)  +=3D kexec_handover_debug.o
> >> >>  obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)        +=3D kexec_handover_de=
bugfs.o
> >> >>
> >> >>  obj-$(CONFIG_LIVEUPDATE)            +=3D luo.o
> >> >> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate=
/kexec_handover.c
> >> >> index 532f455c5d4f..c9b982372d6e 100644
> >> >> --- a/kernel/liveupdate/kexec_handover.c
> >> >> +++ b/kernel/liveupdate/kexec_handover.c
> >> >> @@ -820,7 +820,8 @@ int kho_preserve_folio(struct folio *folio)
> >> >>      const unsigned long pfn =3D folio_pfn(folio);
> >> >>      const unsigned int order =3D folio_order(folio);
> >> >>
> >> >> -    if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE <=
< order)))
> >> >> +    if (WARN_ON(kho_scratch_overlap_debug(pfn << PAGE_SHIFT,
> >> >> +                                          PAGE_SIZE << order)))
> >> >
> >> > Can't say I'm fond of kho_scratch_overlap_debug(). How about we make=
 it
> >> >
> >> >       if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
> >> >           WARN_ON(kho_scratch_overlap(...))
> >>
> >> +1. And we can get rid of kexec_handover_debug.c, for now at least. We
> >> can add it back when we have something else to put in there.
> >
> > Are you proposing moving kho_scratch_overlap() into kexec_handover.c?
> > That would make it uglier to have #ifdefs in the C file. If you mean
> > removing this function entirely, I think that is too dangerous because
> > we have already had a memory corruption issue [1] that was challenging
> > to root cause, and having this simple check prevents this from
> > occurring going forward. The problem is that changes to defences such
> > as kfence, kasan, and asi are happening outside of the core KHO code,
> > and it is very easy to miss when something unexpectedly causes a
> > preservation from the scratch area, as we have seen this with kfence.
> > Worst of all, some of those mitigations use randomized or sampling
> > approaches and might not be reproducible on every try, so having a
> > CONFIG that tests it every time in a debug build is the only solid
> > defense against that.
>
> I think you miss the context here. This patchset uses
> kho_scratch_overlap() during MM init to set the migrate type of
> pageblocks. So it will no longer be gated by
> CONFIG_KEXEC_HANDOVER_DEBUG, but by CONFIG_KEXEC_HANDOVER instead. So
> there is no need for any #ifdefs. All we need to change is to have the
> debug checks gated with a IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG).

Ah, this makes sense, IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) Mike
proposed was just for optimization for debug checks while making the
patch is  making the function generic.

Thank you for the clarifications. Need to review this series.

Pasha

> So the function stays around, and so do the debug checks. Since core KHO
> now uses this function, we just move it out to the main file. And since
> kexec_handover_debug.c has nothing else, we can delete it for now.
>
> Anyway, based on the discussion it looks like people want to ask
> memblock directly and not use kho_scratch_overlap(), so the next version
> might not have this patch at all.



>
> >
> > Pasha
> >
> > [1] https://lore.kernel.org/all/20251021000852.2924827-1-pasha.tatashin=
@soleen.com
> >
> >>
> >> >
> >> >>              return -EINVAL;
> >> >>
> >> >>      return kho_radix_add_page(tree, pfn, order);
> >> [...]
> >>
> >> --
> >> Regards,
> >> Pratyush Yadav
>
> --
> Regards,
> Pratyush Yadav

