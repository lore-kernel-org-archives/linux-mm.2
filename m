Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9CEEB3649
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 01:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271136B00DD; Mon,  2 Mar 2026 20:34:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 217C16B00E2; Mon,  2 Mar 2026 20:34:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F9A06B00E3; Mon,  2 Mar 2026 20:34:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F08546B00DD
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:34:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 985C91A04AD
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:34:22 +0000 (UTC)
X-FDA: 84503031564.01.216C336
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id ABC0912000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 01:34:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z9R/BExF";
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772501660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFFANA4NLA1lXyEbQZZZ7Ain6z2WPe+5QVqKB6Q26vw=;
	b=LMggClqWnSuoHuw+MVEhiAivcOLSNxnfn0OUp681QCQLhLDMdEOXiNGNrUuHEFJ8dOn1lI
	6pQAkjPemphGZHjNHmgyXNoq066+XFQstx72EDi2/1DPFwgEsCCVBL2ifrme61pc8FpIbJ
	kWrFMmNOSJDcWXgJeir49dP8F//zUKs=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z9R/BExF";
	spf=pass (imf29.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772501660; a=rsa-sha256;
	cv=pass;
	b=DYQ7a5DdUmjK74tOkaZzFNBa2y9SpYxCGyWmneoMxtJN+/ekpgoX8g1vdC4k562dLw84t1
	5B3CmFIHq7KE+y1O2JI1Njx4LjpICKLEiiv7clT2lo8XOFFmjsgufdS/odXCDLZJTLIEoq
	/bIIKglWxWzoeFhFkKHdJDwmdNXHSBE=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8cb3fb47559so617775385a.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 17:34:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772501660; cv=none;
        d=google.com; s=arc-20240605;
        b=DYgXoIsXI6qHhOjnjOY6SfwkGAlKxAY4xXnrxST5i904HI4iXBRI2EVSUEOlD8qyRE
         Q2e8tvKzxfTXr9wp1HvT9+0zvfB8EdOXjt1PZR/hTGLohdrQsKzhQOJf4PGBiF/FxYe1
         IpTMQX/AXrM4zO82116JiYse7cbz9n+et2SWoFxXifpL/4JzbX8QDNkzJ38U/ifjEfNv
         OOpSxAucPdJnSfIqDE80bra2Iv4eYBGUh6e8CxMAE7+2AX7zw4nzTRD1JPRxwwfE/+r7
         pNUyyQR+pP+0d5IM1RowlEavOMCTROEUYituexkx8MxZOJQI7rQxtHFtMu88mQjmlpTc
         eTfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vFFANA4NLA1lXyEbQZZZ7Ain6z2WPe+5QVqKB6Q26vw=;
        fh=HcUTgejSIs4Qqa33Hgs0oEcLiqGThlKKxWSMizqFsEc=;
        b=LYbsxnmD3V92gkbnHZ6bQLkpn2nZ8d/lXr62Dk/vzrllC9hYqr7VbgGUzldpTrMD3h
         NMpQl0BdRqvWOHIeUXwhqmw0ifuC70igqct66DHUQ7gQ4LGMzpeAcfmYV09Df9X9jQqL
         n4ZvoPLjjdyB+A1zGbwv2g9U6ti81euQFr5vTo+6aDm7ngGeMwik31ochbYRHeUKuANM
         MIXoZ5b0GuPuVn2RDUs0dF97W2s86NuP5ONzR91zAVC+7l7tu7rxTQEOlV1RGksA0Zzn
         VQeq2wdN7b6+qdOumibxsYy9OXJpefO1G+FSZ+hlPlptdnpta+/RJwiPikKSOuDscyFx
         ENfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772501660; x=1773106460; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFFANA4NLA1lXyEbQZZZ7Ain6z2WPe+5QVqKB6Q26vw=;
        b=Z9R/BExFSm9wRLxMp0tol+CTT+q+QiVK6BaFtOHUHTMhUZnTnVWTF1Qug3U8TtJtsk
         URV4g6rUXMm7rlld0GOaV53fYuJlOurqKAHgj6RIuFa/mrE+pspWXLnnellL2rgP7eSf
         SCuYqNe2He4VYRUtLa4pTCamhUTR/GEV2/DhQqrVjtEkYYgL6X/TglAccN7KuVk68JFq
         pnUUEDKnHKbouG/vtKfmikk65z7/kQLm/M5SI6Siwi8rNP4ba61DdmaY1U3nU9D7wHdr
         IL4QqfbQHUk36dcsUJpjDfBT/OQpMWsGN9KIRdPF8TsLhmaArgpzhLcpkpZi1/pAuel9
         NG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772501660; x=1773106460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vFFANA4NLA1lXyEbQZZZ7Ain6z2WPe+5QVqKB6Q26vw=;
        b=dPG3UygJSWXuYy0rs6O5Fr2wKCrb+hG8pWE9ahRej6i6ikxppBnphs5nr+xnE7Bfyv
         OyZV30Qkt8zwhQ7KBGZzQd2NJFd9mKiyKwFDROa65AksgSgDOftCWIGh/vwSEoE88AqD
         I+vDWQWvabWVEFK6+q6ueX9PvFehM2vLRqG1nIAcVmbjkrP3xsIU80VMBO6W6J9M1Xf1
         6xO2ceQZ6ML12THMSHCKCHCcmtPt4MwtpEak6Rs3Ppg/d4BP4d1TIxyh+Dygfio9Bm3+
         YhbH84lzWLrsvdy0mkPHBUo+x1SYmXFkB+MIBa01xsExnRZNkkS84SgiU2lnKUO0mimR
         I0Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXJ4TmwQwkn/UmqktafiyVzjOZQ2z16nR7GAib/5RlNLAcSj9hiRhze3tsqnuhWSCNduQ0VD/+OZA==@kvack.org
X-Gm-Message-State: AOJu0Yx1kGMuSQme8aHGmDWxszsDl9u/LkrQiB8SJfHRCyVrqQmTlE6e
	rhu/GK+M98ZejGYvE1PCAmr44rlsQFxNUdgt56zhJlZ2MR6fgWQohYTCQ2FOwYJ/37o6FuuDixv
	FKqgdxdPEAuW1+Fd7apCHxsPufQ7nYB8=
X-Gm-Gg: ATEYQzxC1Q/ZpxJJ0OYbQupYufXOViv/iGpi8UAlJTytq6KmfpTP7a9hAFvzS+1U9Du
	KVao+3+2547ca5cD7lxahUZsx4sGMteB2VL6u1Yp4ZoNMb1fD0st4wwsmSrurn99qTfJgvxkdNo
	Uvf8bE8Xn/4878SGcLrfClZgaqowjF5LdWON++ag/r+vfUyJ48dxmueM/sjm7UEFGg8V9KnSTOU
	DqJT5CqL+GJ38LEwRgBT/57UJMmbZckBPPcn0fv+sZqUxMchKPpN+Vd6NlNfvRL7H1iW349CNHE
	JY25Sg==
X-Received: by 2002:a05:620a:489a:b0:8cb:3bca:bb3a with SMTP id
 af79cd13be357-8cbc8e0d7bemr1628233385a.67.1772501659462; Mon, 02 Mar 2026
 17:34:19 -0800 (PST)
MIME-Version: 1.0
References: <20260228161008.707-1-lenohou@gmail.com> <20260228212837.59661-1-21cnbao@gmail.com>
 <CALOAHbBKr5ni=Ap2ASq2hx041WAghd+CzqbXGBSFPExBMJzcUg@mail.gmail.com>
 <CAGsJ_4xA3tApXCs2S-sZh2qA9RK_1masQ7nb1NYyCHXwnP9FAQ@mail.gmail.com>
 <CALOAHbBRBot0EXmzPNb2zpgC2GV5NfnzAZuosTb-iygjaw3U=w@mail.gmail.com>
 <CAMgjq7Bqb0M4bjCeaxjAgaB-Kj_kWKVjMMNdG7528w+uTwGnjg@mail.gmail.com>
 <CALOAHbCma=SW4nu_GPv_pbuuXv1V5JPB-9cA3z1TeemWqU68tg@mail.gmail.com>
 <CAGsJ_4yAkaqqzSu7SS=_fgZ_AQCqtbv8LmuPGCb7SiFpGk4csg@mail.gmail.com>
 <CAMgjq7AkvgzW96-JQzEg5c4oW0cMsjPHcCnukCUZXgSvXL4-DQ@mail.gmail.com>
 <CALOAHbB3rQ2b7ABqFegt2afYRL7KjpWREucrhOYfTT=onV1+Gw@mail.gmail.com> <CAJj2-QEO=9Nt+HP6m=xtFD8qcXCdGCRmESmcs0haeiMdqqTA1Q@mail.gmail.com>
In-Reply-To: <CAJj2-QEO=9Nt+HP6m=xtFD8qcXCdGCRmESmcs0haeiMdqqTA1Q@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 3 Mar 2026 09:34:08 +0800
X-Gm-Features: AaiRm53w2EiKy9u9A2b-vDg7zdi9FSjLbvrfvWYH7Ixw4iVRWIqYoRI1uAOSfz8
Message-ID: <CAGsJ_4ynhyROTMsy1m3AZNsAzFsjZY3EYpSOSTLR0dQSxO+akw@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
To: Yuanchu Xie <yuanchu@google.com>
Cc: Yafang Shao <laoar.shao@gmail.com>, Kairui Song <ryncsn@gmail.com>, bingfangguo@tencent.com, 
	lenohou@gmail.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, weixugc@google.com, 
	wjl.linux@gmail.com, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: ABC0912000D
X-Stat-Signature: r1qhrqqis9mn9t7c3f36eopiph1x9skt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772501660-873211
X-HE-Meta: U2FsdGVkX19zDhUYf1fyGHuC/xzDtfE9ULejVlU4MZn96ooYoBfp/+leCtVZbC/mgTt4e+utaArB898RWpaPoaI0OZ2Zno78exj+VN+MUBqcG/m8CdWqH9EXuiWZtT6B/6nCItIhi/tTXkWGmq1+9Y98U9wBj3wN/HhCODUvoxVN57v8fEKsT4d6DHTJX7R3yXeVSY0PZiyyzGvkjVxFwh7wVdFovpd3i8+ckOZv8ipAL0YbPp0UnPpmvVfRAhH6zYri1ME+v1R2O55m8KDsDMOVNreNmWsyr3BuW4f8BLSQDz26KjlVyLzgulfuMDyOViQdFk4v8wYK7ZVh9YcMa60x1Y0eS93wPXFGt6/8/PyftO9qgPk+aNlE6/RhSbvwVEZhCi8Xw0ByrSgKuXHrlrLkSpxn+QEH6N1h1Pn3/fNfG7QmZRwk57k+vWW+r2lDngiiKRwfhYWuuJUYrhehTHR9C+dXqtp/pBqlkeRjek3WXLcE069y1/GH3ixr76C2OumLVRY7sYDrx/SF9pMqLzCB4gHxG/vJTQg9f+C3fYxjrNiopOvzzCgWG+iG/qgg9IYV6tPagH6T6SdHctj7YTeKhEggL38Hxvv3YzzKUplLlWwfeoEkSwMLZoUQVR04ThZSMoeMiBT27zW9ZDIauClBG8GhBN04DokNhq8OZa/FmRDGDfgLK+VhePdQh6Fg58+3bxNR9kwaSplV+hLGhYOvm3p9NR7LgxBZb/0uu7wQ5EmtyM3t4ZrgvpsOZFzihdE7du2RypWlJQFAs0AfxNpFM+SwTS5DoiYReibFqlc1CsNcBKrXnxOguYBSscphWUVOa0y7oaeH4LzCPUrvUWDxGi9X4eAWqcg+cWuhT0aQXfefzp9g2NVenarS9SwciogsoaGPDfyeZWeV9LMdswe2FJUvL658ZXKVyjDtO2tMdzziM/xCmywxhfcQDwltjWLF2/pnIflb1np8FOa
 PuRaojve
 fLCgoQJ3QPBcBc8OR/OVcgmcbeQfJJpbcMuIUO8kNgsaq1W/DRxEcqwRI0nNLBPrUpUg1xYnXRSoFnlOsMrU05axyqiSiGmRytoP+5e2/wuuwJSsqO7fJp7Ot3pnSCrd8f3sW2AtsonyTgMUq1iJkxwjmX8U9DMBUp4tdkU3/vX+vRWXh4stvbuISHCFq55Lr/rRz87EB/KQkuYO499vkK4duRorr3PiOMZSo52CkCE3IsmUM3z6K6+HK2ZvvPVLM/JO/7pZp+CmlG8UVNCUu0At5Bu+7okgO899xwflbENl5QfSAQg1CUM6nFAX56iN6GsM1dxJLJyvUu9R83DkUShjzgfCa8e+vyPg0ZX8q/6tOiCbGsa7Qj+bp2tjXAdndrpwsHT4eUImxjvrN/dovUAC4RP2+Yc2v6uRqUK06isZqSTxRBWhiYvMLRBznWKvjb4tfdxR3yqWcAkgEbwyES1+rgxGBycpImoYYarc0buTX3LcvpQ111/H3HmQ8ITT5mPQjGZF4UI52Ka4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 1:52=E2=80=AFAM Yuanchu Xie <yuanchu@google.com> wro=
te:
>
> Hi Yafang,
>
> On Mon, Mar 2, 2026 at 8:36=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
> >
> > On Mon, Mar 2, 2026 at 5:48=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> > >
> > > On Mon, Mar 2, 2026 at 5:20=E2=80=AFPM Barry Song <21cnbao@gmail.com>=
 wrote:
> > > >
> > > > On Mon, Mar 2, 2026 at 4:25=E2=80=AFPM Yafang Shao <laoar.shao@gmai=
l.com> wrote:
> > > > >
> > > > > The challenge we're currently facing is that we don't yet know wh=
ich
> > > > > workloads would benefit from it ;)
> > > > > We do want to enable mglru on our production servers, but first w=
e
> > > > > need to address the risk of OOM during the switch=E2=80=94that's =
exactly why
> > > > > we're proposing this patch.
> > > >
> > > > Nobody objects to your intention to fix it. I=E2=80=99m curious: to=
 what
> > > > extent do we want to fix it? Do we aim to merely reduce the probabi=
lity
> > > > of OOM and other mistakes, or do we want a complete fix that makes
> > > > the dynamic on/off fully safe?
> > >
> > > Yeah, I'm glad that more people are trying MGLRU and improving it.
> > >
> > > We also have an downstream fix for the OOM on switch issue, but that'=
s
> > > mostly as a fallback in case MGLRU doesn't work well, our goal is
> > > still try to enable MGLRU as much as possible,
> >
> > Our goals are aligned.
> > Before enabling mglru, we must first ensure it won't cause OOM errors
> > across multiple servers. We propose fixing this because, during our
> > previous mglru enablement, many instances of a single service OOM'd
> > simultaneously=E2=80=94potentially leading to data loss for that servic=
e.
>
> Would it be possible to drain the jobs away from the machine before
> switching LRUs? The MGLRU kill-switch could be improved, but making
> the switch more or less "hitless" would require significant work. Is
> the use case a one-time switch from active/inactive to MGLRU?

I guess the point is that if upstream provides a sysctl to
toggle MGLRU on and off, then that sysctl should actually
work as intended. Otherwise, it would be better to remove
it.

Based on the previous discussion, we have two options:

1. Reduce the likelihood of OOM and other errors.
This could be achieved either by applying Leno's patch,
which suggests shrinking both MGLRU and active/inactive
lists during switching, or by making shrink_lruvec wait
until the switching is complete via schedule_timeout().

Note that there is no guarantee the switching state
won=E2=80=99t change during shrink_lruvec.

2. Ensure that shrinking and switching do not occur
simultaneously by using something like an rwsem =E2=80=94
shrinking can proceed in parallel under the read
lock, while the (rare) switching path takes the
write lock.

If we want to keep the toggle, we could at least make a
small change to reduce the likelihood of mistakes?

> I do want to note that OOMs causing data loss is not really the kernel's =
fault.
>

Best Regards
Barry

