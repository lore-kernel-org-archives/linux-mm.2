Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5350C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 19:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6995A6B0092; Thu,  7 Aug 2025 15:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66A616B0093; Thu,  7 Aug 2025 15:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A74B6B0096; Thu,  7 Aug 2025 15:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CD6F6B0092
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 15:48:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E99D15C0E1
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:48:54 +0000 (UTC)
X-FDA: 83750999388.25.30A2A9B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 102471C000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:48:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bxwiVxZa;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754596133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wFSxnKwuzrZsGAk9Mi7JG0vUdJDMSQzEw25HyCDeLo=;
	b=GLcmOL0E3SlGKeKb2xCMJ/jmqvTSeQQZ+YThoE7E8SA/N0jOMrJBpt8k0jEMCmkle2F6Wt
	A+yIftPkvyPB0oLN2jo8ZwbKnc2Bf+9AG4/MXOWNoS8yWlzhGX4WxWF906TcYv8a6TnZ6I
	/kPwGyD31+jr1G0T0xNVSA632MzTna0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754596133; a=rsa-sha256;
	cv=none;
	b=SimVB20+xmLXxFnbrMLenffOCIsg9gMbufeYW+RMXR9jCTU7CMEvKMPeTZ4WBMnhu4T1EH
	XKdFzRbaV/X60HcdIUh3dhpwa2g+wRWaVUoxnGN5wp7Adc7ZdhhGfBs7PIQyPy1KMK8/s+
	EG3j9tKvoolj54Btp35zqR/48yzZqcg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bxwiVxZa;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b07a5e9f9fso56261cf.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 12:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754596132; x=1755200932; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wFSxnKwuzrZsGAk9Mi7JG0vUdJDMSQzEw25HyCDeLo=;
        b=bxwiVxZai5C8tSArWAIZYHcdT6r5fdfIdgq2xykbmYJjHVHDjIqLgKURW47HI0dGcs
         lngULNhyJsy0xT5VorId2Md4YgD0KlRbLCJzVDsJ/zFTlL/oKg7tQ6iEy14unsdOLAbF
         z/WApFkI3RbmyN9tPukp18TgCIpoINzYCzaSEfha2VHDhsQPC9dH9e1ahQkKR1GQxTYV
         e8UO3SHI/fV1DlDugNSnUyNJVGTk4r/+/4z/AIsGkrtsC8hI41Pi2dsMN07rmNDDhrit
         S5cxhsGm4vS+ldTwSFrfRTw5hKjVa2DY/b0Vx2xfmLMQLMBBemwo8rzKNr5xO6f7tP42
         Ue2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754596132; x=1755200932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wFSxnKwuzrZsGAk9Mi7JG0vUdJDMSQzEw25HyCDeLo=;
        b=ATviHpzX1nXl+uGvy34EN6ftm86VgkBsnERivRHwj6UFOmNZ5n61IAE79RPscu+W0R
         /8muf17jd4p0v4AkW7jiMeslQfCjSYEaTSPj4HxyQUxMiIUVe/OdBt1DlSkBhFM1Xonk
         gzPjLL8kqZMZNi2KUC9JlN4uEY/kbuH9pph8LubHqN4PKq0MRnOp/pWhOe+DBAscuk3H
         zPHpb2Gpio8Bg97s303M2uBifcBp6qNa1zd+6R/ztFUqcbOmzhTS4eWR1miBaepjQC52
         U7P23Me6JxDxAWM4Ee1nF6/Z1FOwHpvIeHmbfU74Yk5Nsmz+oScuVeIuMnc0vm8p2g+6
         dm8Q==
X-Forwarded-Encrypted: i=1; AJvYcCW0Gx6ssXRrDHu4gAZuAMwG+jrnnLjHnviC1qs+HC8VbDKgiMTY85uKYaQEVaIKItqwn+4l6/3Nqw==@kvack.org
X-Gm-Message-State: AOJu0Yx8B55/ZocDVIrl748OabrbAVy+ut9eesKzMA8eh/KRMl+sEwWw
	9cxY53FQMiT7v9zLL287v+FHQQkS4gnJs2pbAD5nQXGKAlHg+Sl4iGfooiwFASXqTqA1FmhYhR/
	cSdqMggI/jku0yqFYjmyZRfdkEC82Alm1tTjSevZvst/Yq7nPI2Q1KBGX
X-Gm-Gg: ASbGncsgYGSQCK5J2xdkCfJIVH/tmuRBm5NLP9DL9rrhfvOUsjcCEhXoy6AsdzddyUu
	PRp0U+0idBc+itjdA8s1N0cDCzE2Qh+t2mNGDrrXOablxarnK5Cq+AL6BYdDLkOIov1VMBlVcTe
	3AH73tpBSvFyOjMpBpw1nsQdTZsCexcG9AsBlEDBr0+g4ZO1HK1AxC27+3TchMfxk9BNFLfR6zG
	d5tTh7xyV4iGBb6lx3Cwf3KDlRL0M3kjkzU+eqxLsEWMw==
X-Google-Smtp-Source: AGHT+IGAnzFGc75ayYfRxWbh7uLxZSTdYzNMshPpWSpmNdU9XPko9zKPro5GAtATFgigXkkdyna/EGGm8ixjXrUw3W0=
X-Received: by 2002:a05:622a:5d0d:b0:4a9:e34a:58a1 with SMTP id
 d75a77b69052e-4b0af27f42fmr657231cf.21.1754596131723; Thu, 07 Aug 2025
 12:48:51 -0700 (PDT)
MIME-Version: 1.0
References: <20250806220022.926763-1-surenb@google.com> <3eba855a-740c-4423-b2ed-24d622af29a5@redhat.com>
 <CAJuCfpExxYOtsWZo6r0FncA0TMeuhpe3SdhLbF+udtbqQ+B_Qg@mail.gmail.com> <43f91e3e-84c5-4fd1-9b63-4e2cb28dab36@redhat.com>
In-Reply-To: <43f91e3e-84c5-4fd1-9b63-4e2cb28dab36@redhat.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 7 Aug 2025 19:48:40 +0000
X-Gm-Features: Ac12FXwfQ6qiGrsCKNHq-ologii6PPu3d0YnpfdjkTe6XUo0_mB7-54uzVqhRMY
Message-ID: <CAJuCfpECC9w6RdfbH34Y906uV=egUDct=6H54Xn79okKK80cjw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] userfaultfd: fix a crash in UFFDIO_MOVE when PMD
 is a migration entry
To: David Hildenbrand <david@redhat.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, aarcange@redhat.com, 
	lokeshgidra@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 102471C000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4u7ebwgipxixnd51nhqzu7iuna7wbf8e
X-HE-Tag: 1754596132-210693
X-HE-Meta: U2FsdGVkX1+fgwAwTw2RLEbwgUicnRF90GCXF9TaXwE+7i+y9VO078U1sDGVgoQAX2avAMlLgLR2e7RCIalnM3XwC7+avfkE56O4hVJGomMpGWiHlZYjokAuLzjqoMNol7PCas/xUFkg9gH6X1NcPMQ8tqBjSxgjMt/pzZLl6r5cbYaD+OyuuYUhXjqldD177gJTe4+z3gZ+5Hl1oZAnvekoAtaHOsFFEw/QoUzETwgD66+6s7zdJp4wLEBaMgHG0j6MgmW07vdWHeTckgx4hRRLQpRuaJhXgYDOnIf6gVdsh2N2ynOJBjP9u/d7OwyBQ5bd+oaS3eEn+ANrOChMIPGatC+jZJxT9LlfVEZ88XIM7uLrse4jlnmx4Q9s9qMuz7085yWYCGjE7Qpq9gJoNwA6nrMC59sOyV3G5a5QtXJOkBcvKnBgSxC4qA2xoOvmGrJ4WT/uqalz7X1N9PN2KjN+HO5XQQoGkYqlNRF1Q8fX4UZwl3SQM3tJL27rqjXBUbXXURXhUDJZTO9nmtA1MJ8XE8LZEigWjQfZf9h2suR0DfCvYq6gBhQT0T7NWQqqMjm/TSMPUpD4BtiB/0HDrCvWGaVhZfoKC/epinK0Lfh0R/xWdn6LAduLnCaBeISqieUR47mP4pw4NcXRCmgleQRcN8TFU4PyG6K3P/QGbLktVCjDfzEMXCd6FN15K5L8VZfgIvJVB3U6glbUpLTYyEeBOElqxJD+HClJDAgh1OUPWwGXK0huNTBfPEiHFzH7PdW7tptwHwznF5yqeNi80q6F8LyNkcV+/MzzW4kI2JdVAjV1XdtfF3ys4N9cuCNZ39A1bBw92vrBU57MmkoMjC4PD8xSaMCSVLPKLUqBK/NyfbJ25HU4OZZf3CEhE02IwRhB7h75optJJ9E9t7mVg5+2sDmcCTR08XdGtYmpD/F8Bs4yuo5c9W8Qf1b9IlJhzk69/q0JvLgRMsmOdOV
 NXYFQXl8
 Q8vNqYgqUD0YHK/KbSn42kEz8u4gQozbyp80tIq1KxMRkY+B6eaAR46V705CznUX9RcXHH0fPvUifg3dDQpL5oe5n4cLkPO/S33Iz32G93zPjgOYOG5ztNYD97VT4aPNmCzU5TQzIOcrIEjovU4TDnw+zS2plCDv+yyXWwLIJS0m3swzJCc3ij/Om+JC0ym8Xi9QhJGCEePi7h7jDgFXpc4SZU3HiyNpeaYLxB1EVEzz6y0M/koY7NmfJ7qIIgrANNMdaHrYBurs+1oiSNoXTuDw5ioYYMXvTCynRlqGvBuFnvseBIoEx+mrNIatjLSOKOUtLBL8a45kz8+OAxppozJbnAfTz7/3ynHS+yqNi98KyyK4aSvtlRi0M8yybSwAu3fPb5tK9REx7cVLqPixaCQixU3gWkZG6Kfhtseezcx2FtAxEhdks4NxOHOZauT4ssUHZoJkF/UE6OEXdPXKIZRmFAulPvXvndUuZm36tEbaFdemrJGZyOsRL2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 7:42=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 07.08.25 17:27, Suren Baghdasaryan wrote:
> > On Thu, Aug 7, 2025 at 3:31=E2=80=AFAM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 07.08.25 00:00, Suren Baghdasaryan wrote:
> >>> When UFFDIO_MOVE encounters a migration PMD entry, it proceeds with
> >>> obtaining a folio and accessing it even though the entry is swp_entry=
_t.
> >>> Add the missing check and let split_huge_pmd() handle migration entri=
es.
> >>>
> >>> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> >>> Reported-by: syzbot+b446dbe27035ef6bd6c2@syzkaller.appspotmail.com
> >>> Closes: https://lore.kernel.org/all/68794b5c.a70a0220.693ce.0050.GAE@=
google.com/
> >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>> Reviewed-by: Peter Xu <peterx@redhat.com>
> >>> Cc: stable@vger.kernel.org
> >>> ---
> >>> Changes since v3 [1]
> >>> - Updated the title and changelog, per Peter Xu
> >>> - Added Reviewed-by: per Peter Xu
> >>>
> >>> [1] https://lore.kernel.org/all/20250806154015.769024-1-surenb@google=
.com/
> >>>
> >>>    mm/userfaultfd.c | 17 ++++++++++-------
> >>>    1 file changed, 10 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> >>> index 5431c9dd7fd7..116481606be8 100644
> >>> --- a/mm/userfaultfd.c
> >>> +++ b/mm/userfaultfd.c
> >>> @@ -1826,13 +1826,16 @@ ssize_t move_pages(struct userfaultfd_ctx *ct=
x, unsigned long dst_start,
> >>>                        /* Check if we can move the pmd without splitt=
ing it. */
> >>>                        if (move_splits_huge_pmd(dst_addr, src_addr, s=
rc_start + len) ||
> >>>                            !pmd_none(dst_pmdval)) {
> >>> -                             struct folio *folio =3D pmd_folio(*src_=
pmd);
> >>> -
> >>> -                             if (!folio || (!is_huge_zero_folio(foli=
o) &&
> >>> -                                            !PageAnonExclusive(&foli=
o->page))) {
> >>> -                                     spin_unlock(ptl);
> >>> -                                     err =3D -EBUSY;
> >>> -                                     break;
> >>> +                             /* Can be a migration entry */
> >>> +                             if (pmd_present(*src_pmd)) {
> >>> +                                     struct folio *folio =3D pmd_fol=
io(*src_pmd);
> >>> +
> >>> +                                     if (!folio
> >>
> >>
> >> How could you get !folio here? That only makes sense when calling
> >> vm_normal_folio_pmd(), no?
> >
> > Yes, I think you are right, this check is not needed. I can fold it
> > into this fix or post a separate cleanup patch. I'm guessing a
> > separate patch would be better?
>
> I think you can just post a fixup inline here and ask Andrew to squash
> it. He will shout if he wants a completely new version :)

I wouldn't do that to him! :)
Let me quickly send an updated version instead.

>
> --
> Cheers,
>
> David / dhildenb
>

