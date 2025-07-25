Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C31CBC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 11:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9186B0089; Fri, 25 Jul 2025 07:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B036B008A; Fri, 25 Jul 2025 07:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8E56B008C; Fri, 25 Jul 2025 07:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DECE36B0089
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 07:08:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F1225A3E7
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:08:54 +0000 (UTC)
X-FDA: 83702514588.29.4DE7D02
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8DDDB4000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:08:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d2ne2uLY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753441732; a=rsa-sha256;
	cv=none;
	b=CdjguOnx2hOdkvaG28d76d02uStTL1GaS+N7kv8in5KGLQ1WN8DlYDXIeYva6ugJABJflG
	sttC46doEnWl6H44jEoMUZgMoa9qBd56fHfARw8Xbxh5q4gDdBlia0wwPmBU1jvzSF1utq
	MVgK3bG0ZrwCaUhwfaQ7yc2G2DkvX5g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=d2ne2uLY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jannh@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753441732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLCJAxauY0TBG6NK+a7XThqW2O8slo6BrQZ0Ungqotg=;
	b=GkW2rtv+wOQuip7Hn1xN/31/jnswK4jV5vkoaSmtqxDjNKLpwjnqqhnD1ADh0K5jYxgnrJ
	DLH7G9DT7LP22D4wckXqdZqqCXL7tfI55gNQC8YT4M6GJiFKxQyJm/uGUQ0xmE9OktirBG
	laf+6DIYrnttYveTtCriEle8UqaE/uk=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-611d32903d5so8460a12.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 04:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753441731; x=1754046531; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gLCJAxauY0TBG6NK+a7XThqW2O8slo6BrQZ0Ungqotg=;
        b=d2ne2uLYdGA/VzEsWk/ZoaNvutLO5VwHDA1g7k3A+TTlfW2N1u1xpALaPlLteMt+GD
         I900SN5QcKt13r0urmsTqYYqFag2otujp81Q1Jf8/MH/+r8bCU2Jx1ND/UQfkrQpLit+
         +4hSodiBMUAQOtwNED+Htx9qKClrhfFWzBJ8CnPRfr/Gx5FY4R1QBK63vA/QLXde5HYl
         oKOAydbCt2P5OezI8Ed3NXHNBpCJzIu09IKBAWXLz1gwtTX1gO/rjQIj7ODiCW41Qi8m
         kWDr9TM6eqZdpHEQ8pb0dEs70hr7jLoNkvU2Ulycwp1HeSO5Ew61tnuwx+nRYmUeDJ75
         X8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753441731; x=1754046531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gLCJAxauY0TBG6NK+a7XThqW2O8slo6BrQZ0Ungqotg=;
        b=S0s5iAnmou5lcidGo7qfb6wftjeglE2eKjhD1DH3nQUJHH9HTkD/Ja+3R8fMKsF92Z
         Eqedhc9pWOUI2y4uEAx7UsZg9ZbpZ2XzVLz2f0YjzlpeMWrBbGv7PR8mNlhjDAjlfAUf
         kAXTckjy3LBUxaa6Mg4DOLAAQKFzebt4f9f9SFuX3JuNAWIPE4iF963Ul/6fF/t5gRnA
         4mN60r6Woe/fnMp+Ne82OW8/z+v3kKNmaSufDvE9zqrnBKrsyz4yGZ0PMOK0uBjs+Wsz
         7AuxizGnTVVtiO74kSXCSEgC+e165FxkL9IZ+yNwEyIylTC/uoyTtItRPlXccmv0icE6
         +i8g==
X-Forwarded-Encrypted: i=1; AJvYcCUHQ49bqHz0TvauYJaAAemyGAvC6bIsi/mQA42Rv3z+weGjvxuzjJ2VQM2QUZicJ4g4MnAD+Hvdfw==@kvack.org
X-Gm-Message-State: AOJu0Yw5UNLs+QHpEm/3vC4pGC5/PqDvwXfkr6jVVGKBzjZejEZuLiyq
	D5UA0EuTyaK9Y2L7bAxFgtAkDyEPyW4kTGq0E9l5OZf/sOA8aLS5J6ARDqaTYP9WbOSrt28bqpg
	hQAKMmiBVzbZHY0+AYML5XC80a5S0U7A51NDv6+dPtqArtnfFpfGyz6rmYuQ=
X-Gm-Gg: ASbGncuOAncDQJBtyEgd6B2h2AUe8Nr6+efTIULoFHYQ1N+noyWUWG1vsJppuXWSj3s
	1g1ORlJikjIFyBPeAUQYThNcYwmynOPANh0vAop0kr3De4fgetsNVfTwXdGsaTy1dL6jZ82KQ1a
	s3EeEA7rYMJ/Mv6g020R4aGuen4eMT4+bciTTVuf469ncjdhJHIg0oTryQF6OvdZcQPmlJ6zxnG
	mY+vYxlJ89DcayRt+R95doZr1grCf4ZXis=
X-Google-Smtp-Source: AGHT+IEMTDwjyL4+fhFLe3ohk28hL9nR7cJsI4d0+0IyjLdUTX5kyLugNJfv0jM6zKjvqFnigkMFKZTQwIs4QvJUeew=
X-Received: by 2002:a05:6402:50c9:b0:607:bd2:4757 with SMTP id
 4fb4d7f45d1cf-614ea6ecc46mr64310a12.1.1753441730560; Fri, 25 Jul 2025
 04:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250724-anonvma-uaf-debug-v1-1-29989ddc4e2a@google.com> <85c4a092-14df-4478-811c-f3789610e4b8@redhat.com>
In-Reply-To: <85c4a092-14df-4478-811c-f3789610e4b8@redhat.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 25 Jul 2025 13:08:14 +0200
X-Gm-Features: Ac12FXzjxVOOI28yZxJhKS1I6WTue9iDCrodBiA9h3gKa9DeS0XWfCckJLCwVKM
Message-ID: <CAG48ez1O+7ciCNDVnh9MPh_1_1TLWd-=H9L6p90J_9AEbav27w@mail.gmail.com>
Subject: Re: [PATCH] mm/rmap: Add anon_vma lifetime debug check
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8DDDB4000C
X-Stat-Signature: 9y1ronh1ynx7oxnmuxrx48abdw43jdde
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753441732-910465
X-HE-Meta: U2FsdGVkX1/ekx12GRWcm6rxx6sUMc4mKkrLjoYyoYYm/rCDvoAmLmpC84AQhO5/zijTrdblDdWhz8FJzzPK2wMwUnQt8LrJrU2YtOOLp/j6tQaJHBsdnNXF9BVhZLz4+KvvjzG8DUq/d4WYjhzuIOVz90Le7qfIHcDKv6Ai0jeyJmnC28sIhVYR1JJtzkzAgLCIuaoe2/o8+IrlKkletOqqiBHNwBhrWoXMv/bqyUvPSVYQC1pnxVmi7kfFML3OW7XRE6sSmw+q5T0bygk6RSaR/ACuN66nk6yRqwp4Ur/vB9yt7btUp+XBBwM3T6w14/1sbq6mQgUPxO2Dc9PPb4zAdqkxIBuvSRA6JZ9dEDZ1j/uSCKWhqD7bWRcgqIlMcdryD1qbeSFu3Lu68cnz0xjXZda6fHJKypzGDZLg3KHxJaLdcAqZJNKzIH54LIK6C7XFrj0mQlUbEsp0xEH8RnjWgfvtu2QdrO6eDyARYGOQp/SUrYj8dIOO32kmKJbWNKm2ZXMteezJTwi8B4nffseJydRkyOPtAYlZ92p6xZelteXlN1kh/7xo+Zm7K4uzf29l8YFXfoF5WfhjycovdokS0atETTGn65l0qXn8+JM5AkTy50zb/08U6HXixldESTlFtPPV/ceXT+Zgk0oxkjz6pEoFCHNiO7dTK004mVF7cRIQR+XRt5krvq798HWHED9XNjlU2dvl+Fo8exlegO4obG/KdvKZh91l1F35IJ+idDnSPPHBtlyAmpZgCWX3g187QTn0Jb2gsLBKMPxDIhFqBI9zNVk7Vgq2Fclr0rYBuATh1D2xwTyXTg/9gnlo6r3l3ANC4+DDcerG+fsofTuwy0uJx5rHFhNA0113nQmwLaRic46KovExUSCnO5D4PsS2AYxifEtwVB1pCwf7N3Bxlq+x7oB7EPkUsEu2xxo4hL6bhqWF19w75iaIDianv3+rTbpbMKB0pq6jSKm
 E+i6ccr1
 nzdxyLSiW5xGzWx+dgJvc2m+qKasZN8jilQ5tw6aJnyZNRpOmnIZFlHHWoHvk/DBvxzJNkEephIW4ljvAwJRom3ygK5rcNeOXD8D2H73uMtuEb0CkAUDpQDtw4eCp2ZL2eZlGiTM3ulxC2tUmct2OS+PPu41Vgnnm4ok1q0iA4Hi5RkmuxSAJAFcSY+0KwqqekHnvusb2KIuLqCDeD4iMzv8cyV2dQuQMcP6FOYyEpXgziwfnSY95GfA17tk6Ow3oRW0kg//rtcZbQ+HgnGZioCkJIpevDsHURFhzFeBUEAIGaxDou2EiemL2stH1/zg5keEcV5sCIRkk9dEICg2MAjMeMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 11:56=E2=80=AFPM David Hildenbrand <david@redhat.co=
m> wrote:
> On 24.07.25 21:13, Jann Horn wrote:
> > If an anon page is mapped into userspace, its anon_vma must be alive,
> > otherwise rmap walks can hit UAF.
> >
> > There have been syzkaller reports a few months ago[1][2] of UAF in rmap
> > walks that seems to indicate that there can be pages with elevated mapc=
ount
> > whose anon_vma has already been freed, but I think we never figured out
> > what the cause is; and syzkaller only hit these UAFs when memory pressu=
re
> > randomly caused reclaim to rmap-walk the affected pages, so it of cours=
e
> > didn't manage to create a reproducer.
> >
> > Add a VM_WARN_ON_FOLIO() when we add/remove mappings of anonymous pages=
 to
> > hopefully catch such issues more reliably.
> >
> > Implementation note: I'm checking IS_ENABLED(CONFIG_DEBUG_VM) because,
> > unlike the checks above, this one would otherwise be hard to write such
> > that it completely compiles away in non-debug builds by itself, without
> > looking extremely ugly.
> >
> > [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.=
com
> > [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.c=
om
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >   include/linux/rmap.h | 13 +++++++++++++
> >   1 file changed, 13 insertions(+)
> >
> > diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> > index c4f4903b1088..ba694c436f59 100644
> > --- a/include/linux/rmap.h
> > +++ b/include/linux/rmap.h
> > @@ -449,6 +449,19 @@ static inline void __folio_rmap_sanity_checks(cons=
t struct folio *folio,
> >       default:
> >               VM_WARN_ON_ONCE(true);
> >       }
> > +
> > +     /*
> > +      * Anon folios must have an associated live anon_vma as long as t=
hey're
> > +      * mapped into userspace.
> > +      * Part of the purpose of the atomic_read() is to make KASAN chec=
k that
> > +      * the anon_vma is still alive.
> > +      */
> > +     if (IS_ENABLED(CONFIG_DEBUG_VM) && PageAnonNotKsm(page)) {
>
> 1) You probably don't need the CONFIG_DEBUG_VM check: the
> VM_WARN_ON_FOLIO should make everything get optimized out ... right?

The PageAnonNotKsm() check is outside the VM_WARN_ON_FOLIO(), and it
uses page_folio(), which uses _compound_head(), which does
READ_ONCE(page->compound_head); and READ_ONCE() unfortunately doesn't
just mean "I want a read without tearing", it also (intentionally)
prevents the compiler from removing the read when it sees that it's
not being used for anything.

> 2) We have a folio here, so ... better
>
> if (folio_test_anon(folio) && !folio_test_ksm(folio)) {
>         ...
> }

Hrm, okay. It kind of irks me to write it as two checks when really I
want to ask "is it this one specific type", but yeah, will change it.

These helpers don't use READ_ONCE(), so the compiler should then also
be able to remove the check...

> > +             unsigned long mapping =3D (unsigned long)folio->mapping;
> > +             struct anon_vma *anon_vma =3D (void *)(mapping - PAGE_MAP=
PING_ANON);
> > +
> > +             VM_WARN_ON_FOLIO(atomic_read(&anon_vma->refcount) =3D=3D =
0, folio);
> > +     }
>
> In general,
>
> Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

