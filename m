Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B29C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 16:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FE56B007B; Tue, 29 Jul 2025 12:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E9346B0088; Tue, 29 Jul 2025 12:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D7D96B0089; Tue, 29 Jul 2025 12:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB0C6B007B
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 12:35:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5DE0801DF
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:35:43 +0000 (UTC)
X-FDA: 83717853366.24.5377E7B
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id B3D18C0005
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 16:35:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xrvslf43;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753806941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lv40Dlr5B9TIJUCPEQGZxzFejkaL+qCdmU+tMwtTk64=;
	b=bNYsKz+ulwGhtNlUq0PVw35HZGflOSI/gz0yHV03IxFZSqCJH2m/2uaDqkuZtGwO+TK7HW
	sj24ikEBecIxtCcmqBzYAaRI9kSRvOkTO/zKB3oGJlOUenlAR0VHAlx2rbmkwfkPTv3xCg
	hpnICHARiPboKh/3B4XdVz3sk2+R89E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753806941; a=rsa-sha256;
	cv=none;
	b=1+YJKPBz/IWwkOuyY+SDVoQusuPJpqcfhDR1K027toG0bHGtlEOMDFEIwdHEZlHLgGgsv6
	aVBgLhSv9XRmJRLm2zhU/jHm9wM4sgohaERqaYQHdyCs8Ec0K/LG90gjTRx662mU/TLBBm
	hAgt1AV/xwofPobkxHcK/SW1/8QYcho=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xrvslf43;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of jannh@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=jannh@google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5f438523d6fso12699a12.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753806940; x=1754411740; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lv40Dlr5B9TIJUCPEQGZxzFejkaL+qCdmU+tMwtTk64=;
        b=xrvslf43wMH2+uGXYoWdv2Z8FCY1/maKcUkJMJRu+Fv0oiKbasxxVtLzlbI6AxiVNb
         bGsPlXyhVFB2KpzowNNXkacphIshqevKGlrYu4jYaa8Qyg1wqvsSMFeOaciqhFh0j6BT
         Um4nJqrwerhzlZuZiA/l1suiCENhpfEO+F4ipE3OpyZ0Lz/eDb8/78x141oLcXRPsbfT
         Ny5z+PFQ0nrKt7qHmZHJAY6+W4VQZshXT7zk3fjE1ugSqBVyHxAL//+R9I7YwRQSy9BP
         Ny0Rwi7ExmHpCdciIsqNZn8WQEfGYjyEUMh1lWxJtG4TGfbYdAsoLz9nsy0mUpEZS9Fo
         9PwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753806940; x=1754411740;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lv40Dlr5B9TIJUCPEQGZxzFejkaL+qCdmU+tMwtTk64=;
        b=TGBSMegODnCUAjQr9SsKmKAE+79XuG/fvoh8LANR4bthYngXcyrZbzOyD7qORxqLdV
         0Svpce8tGx1oCusA5RkDPm/dQkp+mbJv1086ynotLRaBEVfrSSHCbAH0L/cFTmUXdW8b
         5W3RJxBEpcwN85Eus8KT7OS/LyA4ZTUcGbtyqjzWI4o+TsOHHnqF5q/hBwc6jDnsGWwQ
         KEU18vEDbIGU6vS484lhvdmAR6CKfp4ELwMfgue+SzE9N2ilhlE7UPPbYZM9FIelDRl6
         Efw9g2q2I3+VCGUtow2DOVA2C3ttMjGnD+RYyX33Gc+InhMwxqhzEjwL5TNXL8zOEryO
         2dwA==
X-Forwarded-Encrypted: i=1; AJvYcCVN6bFzzVMYH4u8rZxg6klUl25XIh3fwzaAkx/MjRuQM+2zWUt8y6z9v5N4kPPybcbLGUz/fl5jkA==@kvack.org
X-Gm-Message-State: AOJu0YwB4eAnyZS8Ongb0wpgi1PZI82Mv8RuyJch8foSYd0feT1n7Fgf
	DdoKS074YFfw2EIwKE+wczymC4vytykSj0Dkzj0e2FYIVwMBap6yzuDFPGDnlFfNeadYgJJCsMH
	77zM7H3SM5YnoOrDDiK00HfWLZIcS02Y4xR9U53se
X-Gm-Gg: ASbGncuWLl7Vsyo+zdHMx4wXsLmWTJfe2qWTSStq446ycKOYOfXEwXF0VzQh/VW/om4
	vd0tHuIcXEx+ZyJwgq3L7avOWuIYoU7UwMbKO04A/4GJWBm2PrPCTxfslEbROMUNCM0AXNho3+d
	eaSAxXr7P9leV+95pEnE6w2Pu0MYl77YKwauEJ5FWhcAN1MwInaljNYJsolflPT73+nbtAHW18j
	9GOP8xCa2wOKmj7v/dMLgR3LaYJqfrrHuRZ6Itk804VOg==
X-Google-Smtp-Source: AGHT+IFKv7YMKivBIj1BCg5i5urE/qc2uvAwLaB9UK66R72frDrbfA5Hbtvm74CaGOUjlmywh+U1wO9wezcqBXBbsmA=
X-Received: by 2002:a50:8a97:0:b0:612:ce4f:3c5 with SMTP id
 4fb4d7f45d1cf-6156680c26cmr111335a12.0.1753806939698; Tue, 29 Jul 2025
 09:35:39 -0700 (PDT)
MIME-Version: 1.0
References: <20250728-kasan-tsbrcu-noquarantine-test-v1-1-fa24d9ab7f41@google.com>
 <6aeb9c5d-7c3f-4c0c-989f-df309267ffbe@suse.cz>
In-Reply-To: <6aeb9c5d-7c3f-4c0c-989f-df309267ffbe@suse.cz>
From: Jann Horn <jannh@google.com>
Date: Tue, 29 Jul 2025 18:35:03 +0200
X-Gm-Features: Ac12FXw25dvpS-KcFMgDsvvBnkOQEQZAMrlZ9kHerHD3IUA1WAAg7ptbMtRjVbY
Message-ID: <CAG48ez2O4OvhKjdy=Y6fzuK0Qf79JQXCXV=uQV2ED08fS1RNpA@mail.gmail.com>
Subject: Re: [PATCH] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B3D18C0005
X-Stat-Signature: 74fte9hkxacuhapisuczwxxfu9rfoqsr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753806941-647610
X-HE-Meta: U2FsdGVkX1/U2yQ6YIw0ZpHndRx5FVPX6JVr+HSDrHPBTlbTusv3b82l+ysZFSY/TQjG/3Y2GRdiT+PdVeSBqVNIbCr0E6J4RWTGSv8rzdxMJhIUci7sFduzKP7W2Ec9Xm8/K4esS4iSsBwnnezyeO1JENJGT0ywg2lRri2u1f6/MmKaJiOpvURfHH2PjyffHDp0/xKq7FXyXmaKivu1/JcvC3vwDjHym7Y1t+2dSO6KK1IH9lEYTUpjy8kftGks9UmVIwJZ8qjTqYcELNNxWR7jsgCvha4GT4tU858Sw9bW72lMFFyP1uQ7iGP5XZ22wkphlsNzBRkUrGPqoPZKz9MT0TboO3N74KblFVMfSk4OWbWIdofUSSebKC202MsTFxCF9DBSltkBEaF+EqTkXkyJ0cZ8JdGpA4rxlG1CzcMS3ZXufgc/ExaWTeJO6Hsr+hhEAlDltpG61g0d6TyktZbMRtENxk0MUdfeDrByMIiZWLtT8Zt+Oryx5olVcGBY5wA/56RoppM5oOVJ4+hBcCJ0UNeJuE0yd1pj3s/g67ABNh+RsQ5xVaTiE3F58ysFE/8RK9xb+W60eCNyjikFnV2QO+bf9hIA+hoN/kOEDvNRwi7dCGg/MAms7YpG7sjFsCH2+UMF5zGPIt7zCKFKk7XbwgeYasEeabInQweAUhybyMzRBPS6UkVOKTKtOFaIaXJkML3H5gG4SZwhMhMm+t9yVkp5JKnlQlKRd9TmFXnIYO/1sQksXkoaA5i/cbYiu31IdfvGkt0Uh9s+0Nk82JHffiSfNNMpgN3sLzHUg9LKLrwCuyb1V7nNmmg9yAS+n6KYzT54542rwBF66lTp3vRkXORp5yanCVJNty6bDrYx3Yol3QzBJ3p4P0EXC9rw334Kzwf853dFPwyUwJxKQzupE3wmimE4qNsZ9VPyesFNzPCuzHB+0Kd8PLrVDCjduFNTIQCrbrBB223YK7o
 G8BxrDS/
 +9/bfOMAEdrlnZA1wGGa43Wj4ykQM+wJlIzd3zbuY6MOYzy/n1KW4JTpkA68dDr6WG6Z6Fszhb/MjUutWwe9Hvo+8mrDb9WCuGsZqBrfUgWjJStcajFpx1KokB64wdogOywxwN3B/LyJ8Do5uu5p4UEKOk71ejBCKeWJclrWHon3pTlvgqvsQqtECxdkjISZZSgdq6qGHWCSMo710arBCu+mIKwIMghEEiEghtIelmpYqmlJjfrDNpk6P6UAakQ6gZb6+B+xtN30cpyZhu/eTeV9ShUO5BB+fqvXbu8Nm3NLeu8cd5aL5SNV5bsgXDXNILtXd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 29, 2025 at 6:14=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> On 7/28/25 17:25, Jann Horn wrote:
> > Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU s=
labs
> > if CONFIG_SLUB_RCU_DEBUG is off.
> >
> > Suggested-by: Andrey Konovalov <andreyknvl@gmail.com>
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> > Feel free to either take this as a separate commit or squash it into th=
e
> > preceding "[PATCH] kasan: skip quarantine if object is still accessible
> > under RCU".
> >
> > I tested this by running KASAN kunit tests for x86-64 with KASAN
> > and tracing manually enabled; there are two failing tests but those
> > seem unrelated (kasan_memchr is unexpectedly not detecting some
> > accesses, and kasan_strings is also failing).
> > ---
> >  mm/kasan/kasan_test_c.c | 36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> >
> > diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> > index 5f922dd38ffa..15d3d82041bf 100644
> > --- a/mm/kasan/kasan_test_c.c
> > +++ b/mm/kasan/kasan_test_c.c
> > @@ -1073,6 +1073,41 @@ static void kmem_cache_rcu_uaf(struct kunit *tes=
t)
> >       kmem_cache_destroy(cache);
> >  }
> >
> > +/*
> > + * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
> > + * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
> > + */
> > +static void kmem_cache_rcu_reuse(struct kunit *test)
> > +{
> > +     char *p, *p2;
> > +     struct kmem_cache *cache;
> > +
> > +     KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
> > +
> > +     cache =3D kmem_cache_create("test_cache", 16, 0, SLAB_TYPESAFE_BY=
_RCU,
> > +                               NULL);
> > +     KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
>
> Hmm is there anything inherent in kunit that keeps the test pinned to the
> same cpu? Otherwise I think you'll need here
>
> migrate_disable();

Oops, right, good point.

> > +     p =3D kmem_cache_alloc(cache, GFP_KERNEL);
> > +     if (!p) {
> > +             kunit_err(test, "Allocation failed: %s\n", __func__);
> > +             kmem_cache_destroy(cache);
> > +             return;
> > +     }
> > +
> > +     kmem_cache_free(cache, p);
> > +     p2 =3D kmem_cache_alloc(cache, GFP_KERNEL);
>
> and here (or later)
>
> migrate_enable();
>
> > +     if (!p2) {
> > +             kunit_err(test, "Allocation failed: %s\n", __func__);
> > +             kmem_cache_destroy(cache);
> > +             return;
> > +     }
> > +     KUNIT_ASSERT_PTR_EQ(test, p, p2);
>
> Otherwise the cpu slab caching of SLUB and a migration could mean this wo=
n't
> hold as you'll get object from another slab.

Yeah...

