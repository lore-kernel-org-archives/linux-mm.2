Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C06FCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 15:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D24900187; Thu, 14 Aug 2025 11:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BD6F900172; Thu, 14 Aug 2025 11:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08598900187; Thu, 14 Aug 2025 11:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8A38900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:05:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8FA0E138663
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:05:03 +0000 (UTC)
X-FDA: 83775685686.10.8792594
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9DEA2100009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 15:05:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I2MPtueA;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755183901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHTTqKKdq/5V0+v/JW5V+lqTYrF2enAJRrocEqjtuIQ=;
	b=NJ0ZmY46+r6nukVZEc5aEVNB2V31Z5Kd/kAdrvRoQBYm82iLB9KErD1MbBJUJsE058DxW+
	G1Gm2nzPwpPSfUUim5GkTbLoqjKeNYIYktmZS9cIfhMz6+2MCSmae+lzBcj7fVx5ghSdCh
	Ngi0HZRWLSfIJBFgHHNiEXUsUWM/caU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=I2MPtueA;
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755183901; a=rsa-sha256;
	cv=none;
	b=4acEXLmuYMr1Js4T9GLakuzociTZZOkL1mlWJvRp5JxWxn32ZPwU5Nnxj22mn2Im7LNHgC
	ZhpMfCDWdZCGUnFrPzospdcCIk3lrASxTfKl7jZDBsxWIpbCxErNWpuVQ79VWUDbe5/Itc
	HDmQ4U7qDRbC6H1IEdw3MeVHVdXjAR0=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-618076f9545so9958a12.1
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755183900; x=1755788700; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DHTTqKKdq/5V0+v/JW5V+lqTYrF2enAJRrocEqjtuIQ=;
        b=I2MPtueA50qQsMRkCJ4R8GzI7lr1xkBlcMdziaWcsyyqpQOnE/Gq2jg35tyQVUTbkO
         QOl+fx2/U71QRb3v3p8MkKJ2uDcYHWalXDGotCT95xP8rdD06fQD4lVwxhm9VvF9PW6H
         Q4qEoigfcmEn3KziO7SMLr96PiP2/nUXDeQ0pbZY5Fi6XbPyVX6uNNQoPtTilMnwSsGS
         w/gczrCriBJe3t5B8JXdQ+uoVF6YKRk8m6OVk4QYGWKSpNhKXz6sEFqljY6yTfoaOW1q
         ccwpqlIk9TQoJdN1MPPrjMxRnoGZgshEhg32JZRc/UITeF2LN/3G1cc7GHDDWm96PXNk
         DDcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755183900; x=1755788700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DHTTqKKdq/5V0+v/JW5V+lqTYrF2enAJRrocEqjtuIQ=;
        b=v+610eFPdd21wXcnnSifGw2vveczR3D6fcGI8PLlfbXZDf1K37B9pNglNf1Huf1MNL
         uHZ70ueBJZmEGy6Zw5uo+y7q+I1BM109r+x2X2KySd0+CRjfU9shIOpku7U7wae8cUWp
         DtGHk0bfNwqNcXYbwCvnFVcwRvEyGT3DJO1mAXYC2Kokkyq62kCoV3uFqhSK80LsTOgx
         CzDUDWeAUPFxYWoW4Q2UjGtchDhyxTp9hXr9wE8Ge2eJl/LVzXj/O51BlTC3+tWAMVAF
         8lhquTkYaBtN7VkIppj2fqTC3LGb8PIiezyxFspqINLJS5jgXFOBamQ+S1EdwPB0dUNc
         Iysw==
X-Forwarded-Encrypted: i=1; AJvYcCVKD8h6/+TVCe8VJ/6nYdkVY2JwQc0rqgz7L620nMS9mvNI+/Nl4IdvdnypaMlnE+JhJQcm7LuKjg==@kvack.org
X-Gm-Message-State: AOJu0YxszMXDZKtz4cDzCbxoE7cIuSCDTy4tS+7T5lKe/cbfAoXjyOnO
	YbJb8JCcyYrDn8n9sYCGjga3no541cODDfR2osvlltiItmavz1BOI9nxu9LrHLvtSPfb9dkZ1bW
	gwv37EFXUl3W9rlECwRW8/MK+am0QjNcdOpfj9Fq3
X-Gm-Gg: ASbGncvoBssUTH10AC9P76J86ysdZI8HN937p21En7i67iaTX85uqatgbXK0L7bnXLB
	yHqxCqUIIOK9bxTIWwJxfbgAmD1CMbGEEs4ZuNvtRm/pXJIACpZZLjIRl4QfxVDR7w31TdOV9vL
	PYzgQDy1G9WrsrCc/A6CZE6z/bKntoJPjhRyt1mnBqN8BnWtxu9FLc1darQXG7keeWQgPDP7TrN
	NbaLD2/5oNkFA6EFCoDlDL9H1+LOgdQ+aH1B7IiATS3U5t1cqt4
X-Google-Smtp-Source: AGHT+IFNlA66qRktjZlIhzbxSDgit4AZenfxz8oP467vA566LpdL7jF19DE2WZ1XUSPlup99EPs2+mDOQA3ziH554eQ=
X-Received: by 2002:a05:6402:b66:b0:618:527d:633d with SMTP id
 4fb4d7f45d1cf-618928d3d6amr59340a12.5.1755183899573; Thu, 14 Aug 2025
 08:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com>
 <CA+fCnZeuewqXSW0ZKCMkL-Cv-0vV6HthJ_sbUFR9ZDU6PmzT-g@mail.gmail.com>
In-Reply-To: <CA+fCnZeuewqXSW0ZKCMkL-Cv-0vV6HthJ_sbUFR9ZDU6PmzT-g@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 14 Aug 2025 17:04:23 +0200
X-Gm-Features: Ac12FXwcH9CZHsSNIO3sMGBaN83LZnV8U4fAqWyZL3Muxw72pDBQ5p_7Azu-P6E
Message-ID: <CAG48ez0OnAPbnm73a+22mpBjvGHKFGqYAA8z+XocZEHXJCcQiQ@mail.gmail.com>
Subject: Re: [PATCH v2] kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9DEA2100009
X-Rspam-User: 
X-Stat-Signature: dtadpgu4ajfpmpfxtxwprqmfiptze9g9
X-Rspamd-Server: rspam09
X-HE-Tag: 1755183901-5192
X-HE-Meta: U2FsdGVkX1/BS0fI70RubJgo8jdvkSp/k1d81Oqpzq7Pz4vD0MzXzY4SId25cev4n97KchnnjCM0FeF40aKoY5vg+9v/I1AMuMdpIDkvulkyUdGuwTp1aQml2IO8YfTTeVklbpCAs7zI/bSD7stGXXMLZTVbNFaR452kHzq5ULmsE4wKTb9q3N10EhgaZk1aLWUy/V3JxROaMysN60Wr14HwQ6ZILLcWMmH6WiVQ7aJO1kj5ti4JXmb+huHwWFhuEFYHqR8jDlX+DE+GjDxP5vseZhq1sFRuFTiZU9KsmFi4cGt27C/6YJtO7vIxu1auWLVVn27gtICuj6FzSKSK7f/YT9kv5gCiwId6yjmzWuXXlhkC2JWTyaWJT3MBZ3NcVW0zJZn0eQn60LOYhPkb/EXWH7MOYe1TiT+D3If44koDnTRUUcBLdJSETN0RystcdAyErqO/UTXFvAH3MxVsyWuGlAKefNL1H2Vl1l2Mk59y+FlJAtwvnPpS8zZ6GmaS6nbKD8zIMSOyhe4rC9Wfbc6jz3FHYlCEhwRmvy9EQfT2mNwjL7tCKNjPJ8UPOssZ2+TAlS+HZq3BEr53SS2XswB6ejWkx+5CVLHHBdOJ2RoQ2XaScP369wXi14gSX33C6i7hP+KD4ylP2el/xM36/jHjSxIsbCSyQT/FWe3J8dh93ErLS2eqh7Qt8CHDA4JPVrojqiRrQoL6RpbJXh7Kir7ga/G4W+6YYdMOiEBfKPKqz4awj6RM1gdhfiPIWa0LMKGw1OSXpl925p2rR8pd/qGptHAxtxwD6YYbXt36oblA6wWNU8vgH29/yV2o78+iUtKLwjzzb1dJo2qQmeHpI1U1BdctDDf9CWcUFpOn//gjIOH4GfVfb7FRqEBZEultoCvgwBMOk0RAuqvMPa9WAMKQlnQ41GM9hbFYSOIxD1+wFWuoaTnr/dKfcdoFLUVN/zpSyPWygrwaTkVS1j7
 Bi1MFUlX
 ltN/BHmTeZns/1EVtm9ktF3ox4iWHbx5JUDh2lA7ALmpBa36YgcPGPCthDbdzH8U4fU5MJWYj6sevwiKM8qoyGWN02OQRDgW66fSJ0ao2uh7dKuHIA3WHqdDkTBUdPbIhjZOKmiRSYf0A3eT2765Rr2EmEwtodMn9tcQOSgVSO/Wx4npE8fMOXALA7kQMHAfJAE7cCy58SZuGiOfuM5fNoySUmOqv8VmJ6MZyBgi92MisfP10nBjknX7cRvtdT5uvKWwpR1FYjoKvU6CGfrx92j/0LcytF/orvMjy82ubE44Z8qHRjllYHxcjinhHrtmiaWtd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 7:10=E2=80=AFAM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
> On Tue, Jul 29, 2025 at 6:49=E2=80=AFPM Jann Horn <jannh@google.com> wrot=
e:
> > Verify that KASAN does not quarantine objects in SLAB_TYPESAFE_BY_RCU s=
labs
> > if CONFIG_SLUB_RCU_DEBUG is off.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> > changes in v2:
> >  - disable migration to ensure that all SLUB operations use the same
> >    percpu state (vbabka)
> >  - use EXPECT instead of ASSERT for pointer equality check so that
> >    expectation failure doesn't terminate the test with migration still
> >    disabled
> > ---
> >  mm/kasan/kasan_test_c.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> >
> > diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> > index 5f922dd38ffa..0d50402d492c 100644
> > --- a/mm/kasan/kasan_test_c.c
> > +++ b/mm/kasan/kasan_test_c.c
> > @@ -1073,6 +1073,43 @@ static void kmem_cache_rcu_uaf(struct kunit *tes=
t)
> >         kmem_cache_destroy(cache);
> >  }
> >
> > +/*
> > + * Check that SLAB_TYPESAFE_BY_RCU objects are immediately reused when
> > + * CONFIG_SLUB_RCU_DEBUG is off, and stay at the same address.
>
> Would be great to also add an explanation of why we want to test for
> this (or a reference to the related fix commit?).

Okay, I'll add a sentence here, will send v3 in a bit.

> > + */
> > +static void kmem_cache_rcu_reuse(struct kunit *test)
> > +{
> > +       char *p, *p2;
> > +       struct kmem_cache *cache;
> > +
> > +       KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_SLUB_RCU_DEBUG);
> > +
> > +       cache =3D kmem_cache_create("test_cache", 16, 0, SLAB_TYPESAFE_=
BY_RCU,
> > +                                 NULL);
> > +       KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
> > +
> > +       migrate_disable();
> > +       p =3D kmem_cache_alloc(cache, GFP_KERNEL);
> > +       if (!p) {
> > +               kunit_err(test, "Allocation failed: %s\n", __func__);
> > +               goto out;
> > +       }
> > +
> > +       kmem_cache_free(cache, p);
> > +       p2 =3D kmem_cache_alloc(cache, GFP_KERNEL);
> > +       if (!p2) {
> > +               kunit_err(test, "Allocation failed: %s\n", __func__);
> > +               goto out;
> > +       }
> > +       KUNIT_EXPECT_PTR_EQ(test, p, p2);
>
> I think this might fail for the HW_TAGS mode? The location will be
> reused, but the tag will be different.

No, it's a SLAB_TYPESAFE_BY_RCU cache, so the tag can't really be
different. poison_slab_object() will bail out, and assign_tag() will
reuse the already-assigned tag.

