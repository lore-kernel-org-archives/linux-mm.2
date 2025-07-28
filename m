Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71C9BC83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122F66B0092; Mon, 28 Jul 2025 13:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D46B6B0093; Mon, 28 Jul 2025 13:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B436B0095; Mon, 28 Jul 2025 13:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3D7B6B0092
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:43:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9CBAE10C004
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:43:41 +0000 (UTC)
X-FDA: 83714395842.12.05FDE79
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id BCF371C0005
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:43:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yh7y5z0X;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753724619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEghI5pYEjufZFW6NqCQuT9m+lJJtlDUIlnDJTdNb/A=;
	b=gdYQ6W3Er+mpTM9sfrWa/8WQXLpmYEZ2eQ3/WR263bzUcBbaSmhmOr0orSiR1DEbohthcl
	A5nWQjR2hqnpWByySTSm/r1eiLKF0eENiH1Hi7I/hqJBodF+cG2bQ0n7jfpXuMMMwvNFBc
	O8105ZzNTVQwBmdOiy+8u/uGnyB2CCE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753724619; a=rsa-sha256;
	cv=none;
	b=D51YCevkvxGwo7TgwTgAWum4zbRcYxZf1w6XQ+iY/Yaqt9pnXrsb+e3xjuamp5c9KYzYjC
	P3pE+T6OHWnzLjuvNFLegTfyaY8ykF57a0BpvZrIc0Gx+pQVnaoGqHFvCAXyq7a4vMWdex
	DhTTMGJjC+pl6MBnG+1uaB8r2inqhZI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yh7y5z0X;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso51781cf.0
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 10:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753724619; x=1754329419; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEghI5pYEjufZFW6NqCQuT9m+lJJtlDUIlnDJTdNb/A=;
        b=yh7y5z0XguSzxPboVYLakKdj0T3W0OMAecAmmlbR1VC176/FpaMlRgQnNmmPuL9wuV
         m5DmK7Dq2pa6YiNwHwRohJ9j5V1b2qOJ/R+I2WNEN8cqkqYIFaUEKUgWW7lMe3EVk7I6
         0Jl9q9JLrnD9H1Q8w6xjQptlPumoYzqzR4m4K24gM+elkcPNlDsm+RxktBwp63kid+g/
         mT4va0c6Np6JZ4j94u+o8K6gNaOdKrvVeEY+VwPJAfEhEHuTurOSVLMfRQRTzzbWhYpn
         RbnkohAFiz6Jl5yIICWzHhJf3DfRF+w3Ff4fBQQdUo/Queo2rLSj9N4pmARLKQ3vfbgq
         EpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753724619; x=1754329419;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BEghI5pYEjufZFW6NqCQuT9m+lJJtlDUIlnDJTdNb/A=;
        b=R4PMcH8jlf4fw+d4svG/TqD9AFz3Mz9BOYAW8DMmV99romcxyJMptbG47d223MvOH7
         9rvuMLHt0bvvRREmwXgJOF+Jmi8e/K5aIzSsECU/i4PHZdj2fBEkgt3U7PB1/VXTnSh5
         Y/4beluWH9VNf75A6EvWwa2qgj9kZlbmt9uc5j1oDNVqNTIQy6EY8fx+ECRlnMd4lthY
         TSwDhluEe7oZrjSvelxxIoNxNZfEieiqUVyIKIt85rLSqKtH4I4GI2NqMHrLjIE+KgIa
         xSimJKQYM1m2qzNrTrVRM/BRQpGeUP4J6FfqDR9qZbUYXpedcegV82IVvKs2X1MygtHQ
         vQqA==
X-Forwarded-Encrypted: i=1; AJvYcCU8/5to+hbkx0d+5b/ySKungp+LpPgT1nP8uh7ZgH+F49nhIdXaRuyNKzhc5mmdce+hDTWcKyzHgA==@kvack.org
X-Gm-Message-State: AOJu0YxDhGNlYsosoQwb4rmd8dnYHWw/bogTaVP+bNoZJQW+xUksf4ju
	Q514t2cJ24OsnEeRiYuIcKtGaeFaUVnMGeH3rM4yDHrL3GEYQuxNm1RojwvMM/+vczpx9YRowCi
	/9UiTr27lzc5lHf8GPWwJaoSsyq4+ME8WKrC/kyQ6
X-Gm-Gg: ASbGncu7tV+HjkghtAN2IEdHBtTbw6tNFxZCDrktCC+VOzWnnCGj9CoU9Ae/OvajNM9
	oBZJPyJftrmDXcjLSV+ty+xUk4zViRvIzB23/8OyDhZN1bDZkaMofedctNiW72RZhq7BWmL4/sk
	fh0HCiRCJ8TjnHupAh1wy2YpkX7O8M8CbWKrOMIXCqWd+0c0mYLZi+CpCtH65lJ8oAe4TJej/+D
	g6R2EwuM2PAPwp0
X-Google-Smtp-Source: AGHT+IHxByOEzP2Xq3Dzg1Babc28QbNqFKhq4fL9Ckik/VGrbhh3ukcLUktDijqaR+JqVUL0Q5B2QLam3WeUYEHkrQI=
X-Received: by 2002:a05:622a:143:b0:4a9:a4ef:35c2 with SMTP id
 d75a77b69052e-4ae9e887e3cmr7745801cf.23.1753724618069; Mon, 28 Jul 2025
 10:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250728170950.2216966-1-surenb@google.com> <3f8c28f4-6935-4581-83ec-d3bc1e6c400e@suse.cz>
 <CAJuCfpGZXGF_k_QVQqHWZpnypB-sWB8hwZeOYMOD0xmAFOBxkA@mail.gmail.com> <97938dc6-5dfe-4591-ba53-3729934c1235@suse.cz>
In-Reply-To: <97938dc6-5dfe-4591-ba53-3729934c1235@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 28 Jul 2025 10:43:27 -0700
X-Gm-Features: Ac12FXy5kos_F88NmjNLuh5BxW7TbmMP21eggfxR6rOr4N2InO9laPUKFKTi9xY
Message-ID: <CAJuCfpHgyzQxmAiriFM59KGi465ocxH6T5nBSBY1fcUazOj9Gw@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: fix a UAF when vma->mm is freed after
 vma->vm_refcnt got dropped
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BCF371C0005
X-Stat-Signature: 5i8rf7muumxspkhf9p875psehaa13g77
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753724619-781435
X-HE-Meta: U2FsdGVkX1/5YjiINM9PYlHFoa0cNLX1D7vOjmTmJELbOjdq+9V8RJMM7ARbKXd/IeDGCHaH3/BZ9KfA5AE0KCIUtjxfrANA2hWwlgC4ilslErUhWO/JJKJZns/1DXhPu5cKr1FyMYpkG8gsywex3I1xnbmTPuHJaBsKPRB5xivMSiB9UmmU5lEEbP8wnYTReAWZQNXyw2/3bxXPJebzcRmIZe8w6SuhINu6Tea5ViH5T7ceOCSE60Bj1dUeSYxn1TO7JMXcj1k+SvKoyD9qw+9H/BNLB55PQTatgziHb+SHv9nVaTFPkcIKHLPHV7U/jZkwwH0W3I3g3dIEPtKtiQOx9VBm9STNgbR1yqra3OQXz+voVjMVcLZ0zEOCbKsLbWVtxcYqayBckOQkCue4NJC0QidEkWKsEjllFgMpPUB+SHKxx1WHFblVZ+uxIErpZ7IGv1b3G6MyEgyWnE7HLnLZndDBSDlzjmSaFh/5x+BJQWf995oSvTwke59zovAZIYhDelvs7j91Xq2c2Plq7OL1iPCI5vd3jwPtqF9iq6duNFoMivtMo/0C/HkfChutpE3PJkdsn8Q/CpFGnNkSJaCKt30cpzuxb7gCu5bC/+QbvcVWvXY/00U9a5nejMCCI2WL4a23NfPU0gnoFgZwwqnqpvQm3WbRb5Uj87JtS8e/XPngExcPpzdLODzT1rW8UeMy3593f8Y9pE+VC4Ap2V7WB6GJME1lvdMj3MljvmDipPFeesBxR4DAD/FlYIYJEfaspZwv1CJ/qMxSAhWFoVk7CNDFOp7f8piFqSJSme9EgvCwMCbpfFaGcK1SotOTx+rjTQ+F9Z9PV4+51iqnCuiZVmhvsovoRIkNkGvi8BQb9VcEoShntyVaJYc06X01sEzpb7h64Q/bhml34J2m8GbexFLRbiayjPEEGLLmwDRrl3kAN9Evz7hCp/3bWEj3v9B1ZF4cVRxGxRYwHH7
 mUUT49s4
 eF+pHIt/OCiHFtnjYJ5T+txqQfErfVYo3pQza9UMN1dZKHCIXelI5vQ8Ik9vIpPEU8Px8SbR9eaZT5/bRf/h11ZUff6qU24VdRtJL81Rbyt5ctuNDR/x0/wCYzh/CpkiS5I1/86tZk5T5Bk7xrUp2WL+TJ1W5cTHyvFyDhsPSFQq3s5G4WZVWAWM9f/QMYZMoxDNrmwXSAZBNOrJAGiBJ+6uebgmypy/pOQL7nq1V6ekxpRs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:39=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
>
> On 7/28/25 19:37, Suren Baghdasaryan wrote:
> > On Mon, Jul 28, 2025 at 10:19=E2=80=AFAM Vlastimil Babka <vbabka@suse.c=
z> wrote:
> >> > +      */
> >> > +     if (unlikely(vma->vm_mm !=3D mm)) {
> >> > +             /*
> >> > +              * __mmdrop() is a heavy operation and we don't need R=
CU
> >> > +              * protection here. Release RCU lock during these oper=
ations.
> >> > +              */
> >> > +             rcu_read_unlock();
> >> > +             mmgrab(vma->vm_mm);
> >> > +             vma_refcount_put(vma);
> >>
> >> The vma can go away here.
> >
> > No, the vma can't go away here because we are holding vm_refcnt. So,
> > the vma and its mm are stable up until vma_refcount_put() drops
> > vm_refcnt.
>
> But that's exactly what we're doing here?

Ah, you are right. At the time of mmdrop() call the vma is already
unstable. Let me fix it by copying the mm like we do in
vma_refcount_put().

>
> >>
> >> > +             mmdrop(vma->vm_mm);
>
> And here we reference the vma again?
>
> >> So we need to copy the vma->vm_mm first?
> >>
> >> > +             rcu_read_lock();
> >> > +             return NULL;
> >> > +     }
> >> > +
> >> >       /*
> >> >        * Overflow of vm_lock_seq/mm_lock_seq might produce false loc=
ked result.
> >> >        * False unlocked result is impossible because we modify and c=
heck

