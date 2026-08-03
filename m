Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78E84C55196
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 19:43:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90D6D6B0088; Mon,  3 Aug 2026 15:43:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4806B008A; Mon,  3 Aug 2026 15:43:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FBA16B0092; Mon,  3 Aug 2026 15:43:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 50ACC6B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 15:43:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA9EBC07D2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:43:57 +0000 (UTC)
X-FDA: 85060983714.26.C5A854D
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf15.hostedemail.com (Postfix) with ESMTP id F3508A000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:43:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gtkkHQYQ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785786236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fP7XfXAPHNP7pNiZJKYeFh1C7B3PixBZpsJ42VTDiD8=;
	b=fgpjSjT5WajwGRVkoeD6biXu0/miwE46WXhHUO/xJhFxRDYxeK189hcgxROwTFzRlmZD/d
	GuxI+hBvc28b4fqLEj6OlAbw47Y7HWTi5L5G5In1gtf4rE5wP5J8wqdYp399cBErR7mPAJ
	b3TuQDynWn0psUGDb3BVdz2eczm0PfA=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=gtkkHQYQ;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785786236;
	b=x3uKyb9BzeG0Ks7drxMrFqjmmx3lL/KLzZUl9z2RQaY/J4kFP4VveRTLxmtBlnWLrEISCS
	8lg5rph/t3YicaSSlhR9LSCIH79D7h6E+Emd23Vu9CIusrnj36kxyHAUBin7QeWgyklLBD
	OHoZaebSs3xXYYedVvJe0u1gD/z6p2c=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c01c79467so66581cf.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 12:43:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785786235; cv=none;
        d=google.com; s=arc-20260327;
        b=sKK82vXlg4eUbamYfTfV8nDdwBoOtfUFaQdCCdMGq9m/47ptQuSXK1iZYQniJeUprD
         kxQKdPylADLIgmtKqogmOCkXWOtsT8teh5h5Ux4q+FrDTyhwiOew2GRHGnY9bNflYw/y
         Ayuo1Vk/dxIZvWKuRqzJSxxrcQHcgJp4oSOJgUmtOvfTgJXLc6xa3fF5VHhszQhvhGZL
         F320pWDdWet02zL5i/X84fy8WIPitPp7m10FWHCsNToPJB6JfyKaLUhAiVlZRHyQ/R8n
         mcADgeA4byJbD28SRE3hBM6Y9TnIawY6k7cWCypxgWMmOU9Sy8Rm1hTUFrBaAqVWVmZ5
         AVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fP7XfXAPHNP7pNiZJKYeFh1C7B3PixBZpsJ42VTDiD8=;
        fh=+0q5aUyuo879lvCoQYH4mqugYl/YfYbAJiHbKFDfo7E=;
        b=ieLwbEWnIPns4sfq6kZrpriO4G6oDPln6IZ8gre3cqhmpyACUyR23rvzWhBsSUDIYd
         Fm8Rmv3IbjC6KZQXm1mWP9Kzj+JjwWdgAqTzwSDJgbuPZIfMlgG/UycU1ZBNJc5C7V8o
         zC8cfifDv9Zxhz46q62fpG2Euk5eXgVk+H9gnFVF4Urpq9cQoDL+DR2Or2jZHwD7dbat
         hAKyQLmjucZvr13P+oZN9m7sj6mes5cR4MqoIMWtUFsPDklGHaqwJbvFw6UCrC7qJXrd
         dcClIj3TM4Wqb0XyjOcgMXPdLrtDH7sac/ks8jJW8WcI+VSjjV47df5rseyPFlrfuVY7
         Y5Yw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785786235; x=1786391035; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fP7XfXAPHNP7pNiZJKYeFh1C7B3PixBZpsJ42VTDiD8=;
        b=gtkkHQYQOaHq3Aea3/zhFuQJfW7wEkcc2gYomfjLjFM25JcoujxxFjj1npemUvP4uN
         o3kUr2bujHejKNcAdGS6MwmKd0fNGpvWzFm+NPqq4gu/G+JWCPE74ZLMZYXO40P5u7i+
         43FAzIWrN/fsFPRPZbKTPcqNpMJEdWOqyFbsoZKEeYg3vfT4wPOKdqmxzuUbBJuXFzBH
         kKdOZiUuDsFwvtv7WfiRbHw1zY3m1vNu8VzSoz+hjIQLSRs3DG8fTAHMpsXHOHVuZmMO
         OWoARszMAtTU0Ky1X73bSotfDIbtwgMsJMWhBKqP9zIjHUtAnZv0yacQPZocdfa2O06L
         Agpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785786235; x=1786391035;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fP7XfXAPHNP7pNiZJKYeFh1C7B3PixBZpsJ42VTDiD8=;
        b=i7MVev1lf6McmLZghPVDjLgUgjZ++7+7mM3OWlZy2GrABjqobDlF7gT4UXUmHlcgUq
         ciLyJxtJPpUfz9Zw/fv5ZhuU0ia1eLy1MP/HB8uqEUZCMAQ50tlK83f4R+rpp3KEEmIk
         BYph7sv5OnJ4icMxPN4vZr3sg+8memsfYyMJHn/Tnwh0O8X5O7RNgLT7OFSXWWsgYgJD
         olXfjGuwaXsvQ/oKiDReQNSgc9MZ85nTOpZA5GJKTgR2KkYtIaUD++2XJXvYwQgsKQ4U
         zc8b27vt/MCkD9MUdU7qQmzuWMvfiQwNtlXlYROKeyPNzOdbXsEdtqpEPggUUtcpviyb
         xZwQ==
X-Forwarded-Encrypted: i=1; AHgh+RpQfY0X0JIDfpMdppaN3xsZ3G/nwzF5l8LBJxCw0lFDssTGdUp36HSBsk5m6JrTjjrkJEg01xk8XA==@kvack.org
X-Gm-Message-State: AOJu0Yx75TiODOIgTqqq+k9/S1tlaAdEYiju3/BAAhKk6CL3tHbI5Yt5
	/oWtVn/dGCdnfdwYk2k2qOt1FBG7RgbmFPA2Qbp3NE6ToLhMN5CTlRimm+sNSJdCsDPnd89P1Bz
	CYM78SXH17ZZgloGOzeSYjKeltPxS/A2DKJEaLC0v
X-Gm-Gg: AR+sD13TEL2tg1gD1LFYMqFJbIZC55FmXJ9/g7RKuQvlIhdFO0QH2bNh1X4IMRchF3J
	WudznmGkjIhR+dNw7W4tqyFdcGviWTrgLH3bjH6bbV/xVIWfXVpxMaDaqX9NLBmgT8UXqlUMj/t
	tQ5ctA4Vacz7A/Itc1jz/Y8DVVW4ERBddBBs9TbZJvfhSVqiVELfBhZF9cMpQzALy0iiRg+Bhho
	Xy8SmsFKljmLZdY9w7QHhep72zDh4IYl2SJeYxrH3HxPdYmDwQah6GDArf7FZDbaWLlFMtRp5bm
	X+fJhDUI8N4o+RYxIAIU2OKxOk6Dg/saCOztKYEukUA=
X-Received: by 2002:a05:622a:900c:b0:517:5ac7:332e with SMTP id
 d75a77b69052e-52cd4de760amr2551621cf.6.1785786234518; Mon, 03 Aug 2026
 12:43:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com> <20260802215459.2769283-2-surenb@google.com>
 <CAG48ez1w6oPobKZPzoRRN+Nf66PrVYRJwKQx=qwTLTR3n0EFRw@mail.gmail.com>
In-Reply-To: <CAG48ez1w6oPobKZPzoRRN+Nf66PrVYRJwKQx=qwTLTR3n0EFRw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 3 Aug 2026 12:43:43 -0700
X-Gm-Features: AUfX_mwmOzbiGwES3hfijNvnxdpVgWNCN7Te1gwkygr35PC2cl0u--Vvs-L81zk
Message-ID: <CAJuCfpEaYgMx0HF8SDRPOfBJusdyAiJOM3S0TRjeFGwtmSHj8Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] mm: Make per-VMA locks available universally
To: Jann Horn <jannh@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	aliceryhl@google.com, arve@android.com, cmllamas@google.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: F3508A000B
X-Rspamd-Server: rspam01
X-Stat-Signature: bcgnexgr1f4hem3fbh8ex3o7nfxp9rwf
X-HE-Tag: 1785786235-773003
X-HE-Meta: U2FsdGVkX1+HdOHhYafU6E9ihSBa1gqoP4rQbqx8YW8LDnvofknEfe19nRAdWqNvhtWqiua2YIpi2ADW6hAYqh+UzG0FRSs8EfwP/X4I/eoSyh2KnXswJYb/IFN3r+kUsxmooUOvCwdNT0GYB4sTw9rMijJwRW8rPKImKMMcoeNs7qpOWyhufQDz0/it2F9THr1S8LVntdsVknX0zCUay+2Y6vdrJEMYoYIfD9IxYXFmsPaxCSkEeZ6V5hjIEm+ZpPKYRK9t7o8rqf3ExN4UY0qOIOmnKLNWExf4GlOtXaW/mEav8zS0Rghmh6jN/kOP03I1pPNWvDsxDxPRaei3TnoGKcByi2IfYjj0YdbRClygKc4rRWVXPDam5CWH3bKk80kP900D6WBnLumSN05h/bh8nCZdXAgSDkRGJoRyn3A1qMblqZL6/BCq4RrFH6MF994xte31+OkihKkVC/rgByUfWSXU/27LfmTS8iVi6K8RiGltA6ZnmS5FxDCWN1hQsEEj12GZiqNq3aN4asplYDk4su7k6lwJwFfjBIXeiyJq+C3J4XyQu3O9ygy39mgrae/6r1ELx7CJac3ankataqQa1zlVCpfzgYSR7+igRw8po4ShCyjSNDLjWb5F0Kf5YCWLt9ZV3wV267XF7VKvpkzWttsPjnZ3JVngCXdFvM0R5GFflYB0Y7qhTHIqpdB6mLNj+6zhSTjvYokg29IiHTUUaTzc1r6qNJBU72mYsge20KmUrBatl7NQrHVHOOXA0JgYlNQQbwNH4dz6DgVOejxHCejbATtgRM7SRYVTq84X4fUpi/VpBhtmVR8BdioDpk+Y8q52ZZWiYM0Vo682V1y8rtoaFWLQgtluD4gUeLxp6vcfvbjjDOz1Vqnkv7uxt/v0gCLS6Ugx0H4UfKf7ZiEqCGbqJ7S5klhBsOpvg4tjc3/vlbj5eOPriF9FWOcRZ/iaOZfDRRwuhjG045s
 KDSl5wrt
 jDolkbmPm7ZmJQ4E14O6SOvjusjJ+/HN7lr+tvJyNbwm1QfQu+WNEgBtbXZD0deCUvEUJiiqbn9HX+TONdL7cwSdRKrsQGoIeJm19K7iSp3HFn+7U3RK0H12ikPr3qGwagzimOvM0T2WCnRnQdzCExS6ZftWfQfOcPhdsOfjnupvQKdK7ck8UwweldoTH1o0gIz7X8HAr7Lq8W0eIWHbPdctK2+mUTp2tQZmv0N7aBSDr9RsCrWLZs+LSRxnnpTQ2jlrxtcVd3xqZhwXD7NG75JNfqnlAyu9SH8h+JMk4lq6y8FxS2gHqgAzELdwCTDV/swMKrFcOgO2ldz05WKJPH80PtQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 12:34=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On Sun, Aug 2, 2026 at 11:55=E2=80=AFPM Suren Baghdasaryan <surenb@google=
.com> wrote:
> > The per-VMA locks have been around for several years. They've had some
> > bugs worked out of them and have seen quite wide use. However, they
> > are still only available when architectures explicitly enable them.
> > Remove the conditional compilation around the per-VMA locks, making
> > them available on all architectures and configs.
>
> Reviewed-by: Jann Horn <jannh@google.com>
>
> I've grepped around in arch-specific code in the architectures that
> weren't already opted in to look for stuff that takes the mmap lock in
> write mode and manually mutates VMAs, and couldn't find anything, so I
> think this is correct.

Thanks Jann!

