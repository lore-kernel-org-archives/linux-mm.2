Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5AD7E92FE2
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 21:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F93F6B0088; Mon, 29 Dec 2025 16:41:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A71E6B0089; Mon, 29 Dec 2025 16:41:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECAA66B008A; Mon, 29 Dec 2025 16:41:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DA2E36B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:41:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 91CB11A63A3
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:41:27 +0000 (UTC)
X-FDA: 84273830214.07.3074B3B
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id B1E8440002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 21:41:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Xd6l/A8S";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767044485; a=rsa-sha256;
	cv=pass;
	b=Y2NtOtRj3EKkFm8lQIpIZRWQCQ6nfi+BNivkDw2m++oT0OVEA9c8J1ybX8UCFmw2LSINJX
	FJvKLfCx5sFk1mGKRJhKVe3SYLHGQIdHpRjk/rgiqdAuJglFcaglST2jBrO6yeS4fati5h
	2XyHEMoslzW3wXDE9Xy0at7xykDD9DE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Xd6l/A8S";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767044485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wANueRz4jeCmGSNAgX7AeqCQxL6uQceED615CNCJFw=;
	b=Z9TUgMx7rZjP4cvsFX8u7Bzf/xthHmQR6lWiqjM+6fjB3uoQcjainbs9iCyt08oXSrIsxb
	omXP+J0XkUzHMXoXYfflIYzzwu2Mmjb5h3QN2WqrCsXrnbbu5yMiKnvMTABBHhn26W23bQ
	6ge/JkNqhlARuCL/ieV6PvSB30l3TVY=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-64b72793544so481a12.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 13:41:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767044484; cv=none;
        d=google.com; s=arc-20240605;
        b=PqjX4/a9Pg0LvCw9DrS8K58GHaTH7DpJKsrqqZfA4/B1LRMH3C3gF81PCtarNIUBa0
         +012oQWuAxcltJNbU1RS3GL8s9t/igFCVeY5822Z1euAQFUhpVXKJWoGrncc2JZOm5S8
         PQTY+Hc5SFQLfo4kWDorqZoddNLR2R8x2rHn4vtelirm2cc4o+AA3/eCSBqT2I8Xz/hq
         AX0NMruIXcOFlIHjMcSuylZFb8kdsTBRgjGo4uUUrjocGbhZ8cJlcVK3mBmu4XK+fYp3
         +YFn+mLEnh/ukk1C6WblRxJ3PFFdNtl7RjQHg9KWiEDC0jeW6++38POJSXRPDuSyLgzp
         348g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4wANueRz4jeCmGSNAgX7AeqCQxL6uQceED615CNCJFw=;
        fh=0a8mBNZ/gfEhGhrMr9OYQnc3B/k7QVszgcdHP+F/IUs=;
        b=fwFcR6d7LuOkK6hQxxr51yIaOTLSteJx/2kiHPcJftK44vW8XFpUt0PXvDRD6ejl+N
         depUYIzh7xTh+hpljy/QDPWZ2vaxBCTmGXUPXZ+a0andS9woSq+dHj9WuNlOUn6CCGg/
         McBLGaZEtdVai6XJvZIfeyG7ujQWalKyr91aOzqFrAk40cOAUSyh41Wyw3qEet7/wfj3
         q17r7zqn46sJHqkEirH5jgLTRPP/8VaDZQnYUBp+6qoNL7i2ztOM42LcXqbhYIu2WJIA
         iyIl+K44Q+5kF2RoN3ADeziMCdLBMAtUPEY46ndSM3UJrQaxCaY6tHxJddVV1w3bJeFr
         IOPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767044484; x=1767649284; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4wANueRz4jeCmGSNAgX7AeqCQxL6uQceED615CNCJFw=;
        b=Xd6l/A8SMKCqOaNN8hEqbqpSFIvXWw9hYVkh9casBEztkZMHgI2kBGHoU3q71BFVeY
         NKJ2rkeTBOAYEHz0dTC3dnatgANIbldF6l4qgchB8K9rbdlo0l4/y0RmlFn3t6FQI92j
         OcwKywwJ3ytkvWw2oRkAqrQgjXhDDG8481+IfTZubkwfnFXsp1VeHXFlApzAcPKAGbEn
         tkkjM5WpHmQKk8kuIr7j+GFvfoE7jEwzsmIaSSq9ZKs7bWjL9oVtbNrh0p9AOvCl5xJL
         SXEJG3kyWw/0whtChpHK2oAoQo5Vhy9nyACL1UzSrb14Xey0qE41aGf2ziuYBn5ePs8M
         zcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767044484; x=1767649284;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4wANueRz4jeCmGSNAgX7AeqCQxL6uQceED615CNCJFw=;
        b=Rxf0y3VKr7BUodNxmLXNPHhvwHiC+Md/AZrN4qAWa6m9e1LUKM/GVeD6u1NNZi9PUe
         IWU3XPUdbc9wd6tsxUHZzM8tyvP2D0mW8CGx/DzVzL51U2GvNUfA+zH7dAxdA1Qdv6TS
         epEiokyZ72aPx4DhG+SB4LEPoXXnR3bizjmkS2uOZDTP+Ovqkvc0u2q4EoK7e+ji6drP
         tBaKbBUfQfBa+So00/l6hbk3gtgo3UETPxrnjq6TmMl1W5h6FA/AK1oNHhcLnlXaIfdH
         4PeKlkFPeGP8Acrm1mMfik8W925e3+dJCwngRAUCNHY50pt/uXzkI6XhSg29WyjQFkD0
         k60w==
X-Forwarded-Encrypted: i=1; AJvYcCXwMKtGAMMwW5m98DEHVtqKVrAMoGtl8CmHhkJb25viRYvcp+znCnHijQnDe99tQEZgmrhdkwHDDw==@kvack.org
X-Gm-Message-State: AOJu0YzxFa3xJ1pcVgTyxy6/OqHNKULoZkFd8sIb6/2Oiao6KFRNNq7k
	WNE+RmjbzrUmVjRzJCjrvQ+wURTQ8y+Amc/PL7UZsxn926CKMaWz3FVxYze917f4cJ5Vu/sqRSf
	cG9jxmsOGR+8QWPgqVjgGlGAjC9oJ1aEaUfb4vJMT
X-Gm-Gg: AY/fxX4cz4We978D/NaUxgnSxUYUyAx0B82dDERmFWYDUy+k6cXHbWutkdVSJbSd9S8
	VmUwv65IFUiugLzzw+7cD25M4gzdJpXZFjM5WWs94O8LMF6DQ6sUd9781Z4SMweDLoxYgP+7B8R
	wKh3nge29SNQoDn/kMvBaUtzQZCm0JYzlE/RB4UB6B0ayXWj2Q/2Y6R/W5pWhnxMNiqQd51z7MA
	ZuspzpNy7S1JTwqO2URKcgwKmDPyQQzO3Z3qqB7HTlPWq4xSmfX6P+7RpkwseavVM40XQ==
X-Google-Smtp-Source: AGHT+IEKTKoGKuUZ6XstoTPGgSzgEMULnsqvcatZXTwtzVGO48aRQNNbhscqov80SCkAfkEwVMw9e1KkO3IYXz8rHSM=
X-Received: by 2002:a05:6402:2293:b0:643:bfa:62ca with SMTP id
 4fb4d7f45d1cf-64f1999a03amr1144a12.8.1767044483908; Mon, 29 Dec 2025 13:41:23
 -0800 (PST)
MIME-Version: 1.0
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <b2b22973f761a97751487144f7726bb0cf868305.1765970117.git.lorenzo.stoakes@oracle.com>
 <nmflwd25h3zz3vrdpfgaztko2dcascl3bbfyk6slml7n472kms@ysxtp4xlxf6r>
In-Reply-To: <nmflwd25h3zz3vrdpfgaztko2dcascl3bbfyk6slml7n472kms@ysxtp4xlxf6r>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 29 Dec 2025 13:41:10 -0800
X-Gm-Features: AQt7F2rPeL5rndOONNQixFF0S70XVIIJAFBT-b0uXfLanUEd0xpb6P4JU-MCmQo
Message-ID: <CAJuCfpHq0G=kLBD=_0cgujT0Qu6yQ-EDB1uyXQJPGWmpSQGYGQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm/rmap: skip unfaulted VMAs on anon_vma clone, unlink
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>, 
	Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B1E8440002
X-Rspamd-Server: rspam03
X-Stat-Signature: iad6be5jz669a6fn4xyqkm4fazq7u53x
X-Rspam-User: 
X-HE-Tag: 1767044485-136208
X-HE-Meta: U2FsdGVkX1/gRBJxAysr6LDhcNXRYCymfG7OZFrbHXIn7qtWmM/d9NApeL7X8oGTABilKgeB7qc8PwVr2jnlwBhDHrJogzzrbLqfa6DLUiccBpeGbvwdc2VXfCMHmR6ZAPNCxKh4BQGzs/qpxNLDwL7jtHfj+2w1E/+ubtMPpxNp2El5HfdvWkSrtY58RyuVNUWKupqDJXw/IGBPuu0CatG5VU3iTT9f8u8xQQW7L7J5Sl5eLSXYFnm6SKRu5Cbl+mgUOehdUGiWXf/Pe+v1gd9l7CX/3zbOS9B5ghyuAbpAZ47JsZ0QtGLvNQUXcZbsRbPaaGmme5MKsL5AaahvIMFnwg2qOHOltHQTQqXeCfFoQfC4dYwYTWNMjjQmzgKXwtJKQhPGM2rbwk/D9+lU64GS0+37k7HMM3A+/rfn1hm+daerj5JVIdRZSYtvjbXXeI9jpQVk80cjPzvNDaKzlPSMq3XyAprlbeAwXGNlAGPkXjd5oPptNGgmpt/HQ8t/cjhF/QMn/MJ4q1MeS5jeKjT+WzVNvGU7G1aprql7LZBtPFRiip2Dhi3Cm9/BgDRIhhRg1kvvZNn0ob4QOgoVtR4fw38BERF9KkdQvqQZwxzJEkmjaAc7NNcDRFTW+PXHGUdE4/Jw14XcIwsoSmKgYAeXRek/lAe9JyCELrxvcDS8g2s32pHk0tjc/3MC/zmFciAcRNprJZlcJKJBuN/RSz8vyoKhCdNBUdlnaeE4KUK8+k/UwSpcafeYaop0GJBveiLKyXreke8UgJlu9XtXCKawT4PbV2MF7CsR0jiUZaIPYltxL7t9TYes+7LpOWiFXr4xM/TjCsiLz5IGv6SljaGTpcUBHpVFm6SaYeT2je7CHDrp9mV4sdS3K/pw8IFHl7zjAn50p2fJr7ZTjuOKAKdahMnsqwHrWQhIGg0C79tvP73YyS/G5cwerlO5sskboMpCSaoIwOouR1G6YpW
 cL6X8fa+
 MSyVgVgVMdY9/cir98uex0ILD/Qwdu1xfYhiKCpRtd1PwU2HqYgtvd2ZPbWzBvCOVZZhvWlBG+DMKs27/PMuRjtEs98HuS44D1BE8Cx/F4cFe0EXE3nfmyalDQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:28=E2=80=AFAM Liam R. Howlett
<Liam.Howlett@oracle.com> wrote:
>
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > For both anon_vma_clone() and unlink_anon_vmas(), if the source VMA or =
the
> > VMA to be linked are unfaulted (e.g. !vma->anon_vma), then the function=
s do
> > nothing. Simply exit early in these cases.
> >
> > In the unlink_anon_vmas() case we can also remove a conditional that ch=
ecks
> > whether vma->anon_vma is set.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  mm/rmap.c | 20 +++++++++++---------
> >  1 file changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 0e34c0a69fbc..9332d1cbc643 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -309,6 +309,9 @@ int anon_vma_clone(struct vm_area_struct *dst, stru=
ct vm_area_struct *src)
> >       struct anon_vma_chain *avc, *pavc;
> >       struct anon_vma *root =3D NULL;
> >
> > +     if (!src->anon_vma)
> > +             return 0;
> > +
> >       check_anon_vma_clone(dst, src);

check_anon_vma_clone() is used only here and contains a couple of
warnings with "!src->anon_vma && ..." conditions, which now will never
be triggered even if the second part of those conditions was true.
This seems like a regression (you are not checking conditions you were
checking before this change). To avoid that, you can place this early
exit after the call to check_anon_vma_clone(dst, src).

> >
> >       list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma)=
 {
> > @@ -441,7 +444,8 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >       mmap_assert_locked(vma->vm_mm);
> >
> >       /* Unfaulted is a no-op. */
> > -     VM_WARN_ON_ONCE(!vma->anon_vma && !list_empty(&vma->anon_vma_chai=
n));
> > +     if (!vma->anon_vma)
> > +             return;
>
> I guess it doesn't matter because you just added the !list_empty()
> check, but did you mean to drop that part?
>
> >
> >       /*
> >        * Unlink each anon_vma chained to the VMA.  This list is ordered
> > @@ -465,15 +469,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
> >               list_del(&avc->same_vma);
> >               anon_vma_chain_free(avc);
> >       }
> > -     if (vma->anon_vma) {
> > -             vma->anon_vma->num_active_vmas--;
> >
> > -             /*
> > -              * vma would still be needed after unlink, and anon_vma w=
ill be prepared
> > -              * when handle fault.
> > -              */
> > -             vma->anon_vma =3D NULL;
> > -     }
> > +     vma->anon_vma->num_active_vmas--;
> > +     /*
> > +      * vma would still be needed after unlink, and anon_vma will be p=
repared
> > +      * when handle fault.
> > +      */
> > +     vma->anon_vma =3D NULL;
> >       unlock_anon_vma_root(root);
> >
> >       /*
> > --
> > 2.52.0
> >

