Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC4ABC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15946B0096; Thu, 10 Sep 2026 10:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB74A6B0098; Thu, 10 Sep 2026 10:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DAA6B0099; Thu, 10 Sep 2026 10:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABA36B0096
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:50:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3F7FA058C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:50:52 +0000 (UTC)
X-FDA: 85198139544.24.1ECEA66
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf11.hostedemail.com (Postfix) with ESMTP id CD59640008
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:50:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hlfQLRxU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789051850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fo5EGqeU1K9oWeUdrFJ6Uc8xV6Lo6ckrOaUTXHreas=;
	b=K+VDdvnGsNypU4GpCdpSwlWQUJlRs4Q6tsaxpN1p8FDG+5iVHoh5Nve2dLr4/e4fW7OvKG
	R9gRk2V8BxVIaCGUoPdLYwsyMYm/LU4ZNa/m0My1LVvGN1MOme54a/E+m8GYeD251pST/D
	r7mKD6oQSEDZ5NQakdoE33Vp2dDK3D4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789051850;
	b=Z+pvRfO9eQtTz6jUidPzW7eWi+lBN4vtWJ0jDrfx9jmNuZfmlio9w5WLQuFg7GvKPoAapX
	Yyh9kon1hIvu2o/bAruwL4QBKO5zRqGlvfJoD/O5PhPNGinG3DW6NEPPrdbiGcnj+SvFlo
	FrHfCiVHrTEWpvzfBHMQHWu0Tm4AS5w=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hlfQLRxU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5307425f44bso248831cf.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:50:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789051850; cv=none;
        d=google.com; s=arc-20260327;
        b=fbKovrhy53aIidaAX95qBztnK9npSd/b/w6x6tQelWPOnv4ji7VUyuWxcM3CYrsu6E
         M2hUmkneEyxFFfRzSSYgGSso2KN6NtNYW9DXKRIylVfYL+6kDUFjXqfH4RdaExvYeRnm
         aM+oyPXqLZLK68aiI2TOHw7HjPTZPZvlKNkrW/055aJL2eU2tTU0nvQB2DkcqOYVd1gv
         uT0sM5M4vVuHiteyRTwck9AB8+0SMCczNyjS5T5gOW0mLKzKG2UVRpIV5id1+hWZmYk3
         Q6RFNasIiuu9bIGNsUBY3pMiy3D6cfG4aR6Mf/1Sx21jlBWc2CHpIQK/w26Zws4dxeF8
         KYcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7fo5EGqeU1K9oWeUdrFJ6Uc8xV6Lo6ckrOaUTXHreas=;
        fh=STAXURySf+/Zby23qE0gTCVslhkCrPYaF0Okf/xDr3M=;
        b=hDnATebKM9NtDV/Mb6AP3LXvaP2hVd4irxhimoBOiJ5yyI8Ma3uN13eTjPGy5a0E49
         sGDj75+8JRi3OvOfDvFbiIwVdEJZQOMRPmr9mhRYMcw8cYA8nmH+yEl+6ZrQut/+xOHE
         8rkmbeUP3s6/hMypBERn0plsZ2Brb8c+7RRERTwNPdZnnpXSJU7X502B1/H54KmO6Cti
         xuZZg1m5+csleP9XAOXtxM7FVIvTZ36aXG90WgYjGvZkA+IigyesB7+K3aymSRMInXjF
         +ix3+F+rvWjrgksrHKav71fhv1PP1m7uJOeToL3VSJijajncRG6n0NfzXM35satjHrGK
         YqdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789051850; x=1789656650; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7fo5EGqeU1K9oWeUdrFJ6Uc8xV6Lo6ckrOaUTXHreas=;
        b=hlfQLRxU8/V9EJ1ZHGgPE+/3WyH0Tau89+4QPiVOmomANg4NMhGf+lRvDqBtkGF0cq
         u+QC91DyGOIa+vmhj5hBU0ePLCDr4QW6jvulEAXXqxXOV5bzR0xZzqlqHvRQQrZ5FRYC
         Th1aY0CYEVGTXze6X65oIRRUg3JtwRnTP6QvbJTVvRDVR/ncdIYGkEdjVpxsjd9Pn/EY
         Py05vldKuAyTVa3xrJBtXR+PfJ1dNNnNkIW70GQZDxmp/XiVeXrctQbSoAqTTFRTOXRY
         Kv6SQsO0jVPAxFG7nwUaza31iB7WrGc0zDdVZ7Ut3CA02Vv8D1zZNyR0QoZFUzAwdpB8
         BpHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789051850; x=1789656650;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7fo5EGqeU1K9oWeUdrFJ6Uc8xV6Lo6ckrOaUTXHreas=;
        b=HlEWwHIOLCZ5gnDyy6wkF5qYnldNDsqJfWu9O4nP5mCc9hKA3CNhNv4m78RfgS07zg
         fKr3jl1o5TqRR0Q9OENIqybVzvNFGITK9JxRvpVXtmLCyvfLcM0/i+lP4eoWyBoS3OHU
         olSXc7pn1qot8QSNKeu4onZq7QVCBwjG0uhMoXXY5clFnB2/s4iFDoXrrAjmCdhMLJZu
         lZIlI8j3rJMKmmw+FsKjdJlnMVrT3TkD9HwFCcxo5fWWhkYNs6F6lxniiGM5Se/9QN0g
         jZwA5ONbo5p0eftdUJfgHRZD9un40mYWU2IiqJszsLwWm6vWBskA892OHucWVprknEbm
         BJbQ==
X-Forwarded-Encrypted: i=1; AKwUvBwg6ad9b1whjopjoqOCkQL0/xT0xolyBYLPSXfKn5oI+hrHq9YWmg0cSquG0NNZT5kPADkg5+D2jQ==@kvack.org
X-Gm-Message-State: AFuF++nA836r16tQ/qau47pjTwt6nGcyRXBPTh7LH5xU8nQG2QbZ/tm0
	FfYgoI7N+U9wlU6m9ODRanoHSmarnOLc0ffE8x2bEDGMQp4bSCb34jr5UQkU+KO0XkgMkdiNZGS
	fJ1pQAJbJfVe/pMFGBqg2ekIdnd1M7BzRIOhR7+qI
X-Gm-Gg: AYBFou3rFIJgX3ZRgeWFlXWLCvlTYy8pZmy6s319sDUEm6vrXSQDzP8kBiO9SDHTEoM
	9SlGBGbINsluWV4zFmJO+V9OgaF70xg7J4K3PABWu+8j2KBoYHLLa+h6CcQHvbea7M+3bjtcU3I
	Tb+i/dHTnfbhsH4p6TPMgfX3wGxah+erc2BlDOackulXg+pI1qfXSvPGaFflhOIa2cX/ueRWlKR
	RIYR0o6SZmh5wH4ZJcCkgW03Pkg7A+ql5fVW3a9AswqKa1UfpBZrEXKKk3zxTZpvTjS36xod48L
	RQuawp5MKJSgfze/oHYijgJxTN9nM/6gNkWaKK/SE0MtjlrQv/dbBmHABD3+XzsVCZJlob4dMj8
	sBZqzzezjivYCBci4Ek+Y
X-Received: by 2002:ac8:7c4a:0:b0:52d:9d62:6163 with SMTP id
 d75a77b69052e-530b62adafbmr17198241cf.9.1789051849244; Thu, 10 Sep 2026
 07:50:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260831203056.838265-1-surenb@google.com> <20260831203056.838265-2-surenb@google.com>
 <a4d74575-65d5-46cf-bd2d-dcabf2543811@kernel.org>
In-Reply-To: <a4d74575-65d5-46cf-bd2d-dcabf2543811@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 10 Sep 2026 07:50:38 -0700
X-Gm-Features: AcwNN1X_jRm0tBBbAYUSIvnyhEAYCX6eOrOg0SRx_RaTXlhhkG6R2zUlwcvhFQ4
Message-ID: <CAJuCfpEFmf0V0OuAkEPSpzYA-WScAjmNg2b6CJg7Z3WH9h6Qdg@mail.gmail.com>
Subject: Re: [PATCH v7 1/5] mm: Make per-VMA locks available universally
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, willy@infradead.org, 
	shakeel.butt@linux.dev, vbabka@kernel.org, jannh@google.com, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CD59640008
X-Stat-Signature: 965gdpbtsu8suzyg54e8y8o9b9d5b4up
X-HE-Tag: 1789051850-162752
X-HE-Meta: U2FsdGVkX1+3EKOb6tZgRxr7960eKGrLdOk6nXAn9TeCyfLkS+i9VRC7K6lLBvUwJxzFOKggUPVji7iraHwe9tTj1c9qDT4u3WwQuKjAo/AmoHQa5dBMsGmfrBP+//OK45ghRQRQVXJiWsMEhhrnY76Eoc72yjkEg62vVlal2SCtodJ5Im6JVow5aP+k1wjAMd2GNnxBxNuNCSJSNzVcBU0ZSeW75a1mShbZse/oYkEXxMIPvXyDqw8vKQqdqkuUshLZFlBDAwDnP425U7pB2yC0mnEOG2QFMj8HsPflch2Z0QJhYdGkMmgOxIZDR6lG5NpZTxOy5YCuWBkLtgZXNaYWn9c9XXOrzsqq6sy6I1Yt+kDGsx0yrLWNBcrcwvcM/X0uhNAmiBdzt9J60uZNehyjItEIzOyuj7teNBVLbvR1ExhUPpRoZOUcxQgUMMHGcFOdESnCPySim7MoceNoLQzbXUJduVYW9hFXKP4UBzckW8RDL9ujl6/gMFSJCF8+rXX2r7WXpFWxl+AiewwHm5Q7Cryvt+Bx1QCzTZw4oxM+iuEJ0aPxIt5dNNs3jmaaNqusajV5AwMM+KGkmO2V+CBDbVUdnBP4dgE7cA0VptLakB1SwoQEwKMg8UWSXUTZ3tL+6RE+rkvoxcY6c8PYtZ0KZ407DGWcVRZPl+K54GjVf3HAw9QaL1IuaIPFx7jzJZ/jBwxiCBq/JIHmaBm9UGQWuIoA/PeDLWORmJ/jSgM/ieVkcchVI8d/uLYnArJQBpbQ8QLwfMl+8SWEdrnQWqoGg8VvDH6AiWj7vPap5uZQtAd7l1SBOU1p0lwJasglluqSuIWkjuX/Nbu/P+gcB7yhJ+GsYoPOHiaaVi2242Yh3kyNSnNSd1zz5iARD3cr8lc5Ue17wdVLEiSMj3/2Ga9yXc5n3cEFVeYV2OKziwBRtDewYKiWFMY1NTYXUChsjHRMd5sTlK2F5yZjlH3
 0suLz+qr
 IuY4RhaSmoWVdp8YnIatMn4ALXlDndBALu0B2YWwmqHVOTLVyCkq2ik6pt9EfpFc4ubfisDnprw3dMtV6cy2PDgYY23mnr7pgH0PNikWZMxp+J8L5NgLOX0UBfgzaNnlTV+l1doVa9MU89guQHr/Mh3sOyWuzvwaxMEe80zJsXJ9BRtmtUF0YnahD/JOhUCmtF5eBlhP0Hp62nta9kIQoqw8H44Cj32VNPrCt8+3oygftlxRSEheYymp4uDq9+1QJpzlAOrOow3KFcqf+p+ZyLXfkCaMybJ70XaT8TIvC0MSaB2VXfNZLnK+p8RpZLlJ61U87IyrDB2aHpajNEVW0ow4otUik4GxSHt/akcL0TOB+Njo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 3:09=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/31/26 22:30, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > The per-VMA locks have been around for several years. They've had some
> > bugs worked out of them and have seen quite wide use. However, they
> > are still only available when architectures explicitly enable them.
> > Remove the conditional compilation around the per-VMA locks, making
> > them available on all architectures and configs.
> >
> > The approach up to now seemed to be to add ARCH_SUPPORTS_PER_VMA_LOCK
> > when the architecture started using per-VMA locks in the fault
> > handler. But, contrary to the naming, the Kconfig option does not
> > really indicate whether the architecture supports per-VMA locks or
> > not. It is more of a marker for whether the architecture is likely to
> > benefit from per-VMA locks.
> >
> > To me, the most important thing side-effect of universal availability
> > is letting per-VMA locks be used in SMP=3Dn configs. This lets us use
> > per-VMA locking in all x86 code without fallbacks.
> >
> > Overall, this just generally makes the kernel simpler. Just look at
> > the diffstat. It also opens the door to users that want to use the
> > per-VMA locks in common code. Doing *that* brings additional
> > simplifications.
> >
> > The downside of this is adding some fields to vm_area_struct and
> > mm_struct. There are likely ways to optimize this, especially for
> > things like SMP=3Dn configs. For now, do the simplest thing: use the
> > same implementation everywhere.
> >
> > =3D=3D Considerations for NOMMU config =3D=3D
>
> Echoing what I commented on v6 after v7 was already sent (not realizing t=
here
> was a v7 after my inbox got flooded)
>
> Maybe the NOMMU "support" could have been had in a separate prep patch (w=
here a
> lot of the description below could have been moved), making the patch its=
elf
> just mostly a removal of code.

Yeah, that would make reviewing indeed easier. I guess current
structure is the result of me adding NOMMU pieces to the pre-existing
patchset. I don't think it's worth refactoring but I can do that if
you insist.

>
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

