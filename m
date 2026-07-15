Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43CA8C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 514516B008C; Wed, 15 Jul 2026 12:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4166B0092; Wed, 15 Jul 2026 12:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5286B0093; Wed, 15 Jul 2026 12:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE216B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:35:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FE188022B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:35:06 +0000 (UTC)
X-FDA: 84991560612.30.EC7827C
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9957F8000B
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:35:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jde5zuMO;
	spf=pass (imf30.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784133304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pERiy6dVlA901+DL6zvyyrnjEz4Li9eRjQ4QFKdKZJQ=;
	b=xL7X91sjRaFtkmZyoxiQu62vfTZAOnYYyh1Oalfcp8zlS7sZV+SgGfVE+RRwGwH8cyOIaZ
	IlUWru341KJvWir0JOMdshN8lm7mUL1ol7Zt4abYvvy1ETtBu34AnJqdGuGBoD+Mc3XVXE
	G1WBdY2EUwIXc216gUM+5KeVKQhRbUQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784133304;
	b=mA6FiA3wKifDjHiPQKo3AjwLIH6jM+f+TUJXRlGaeuG/YdbmTUW3KzlvADf73foa0f85pW
	+tY8qeIIimfCXg4geVqtqWrNp331CmiU0YpJpQ70Z9uDRKAxmMlxAmCYAQ/nkx9WoE5d8L
	7sxjXuergcVBMAy6yaFQfkkoXNQhk2I=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=jde5zuMO;
	spf=pass (imf30.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-698411099d6so12266a12.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:35:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784133303; cv=none;
        d=google.com; s=arc-20260327;
        b=KFaEt/4c6QsaIMBrrnnIoxX3lg4zjXjKSNEECEnw2Y7HzEvMWZDJGM7+C0f24k+aKe
         VKkiR6rUCEC4SLXCSbbWGRU32PD6d8S5+uXgSJNde/EJ2ncZRY/jxzaxslnF9MlMLc9q
         gf85eLqOOWFETYwhqKk5DeewX8ho+/XSY9TPaRWMKV6T5qPjL9bn6gZeZw5b84wQtBWB
         2NFUUzHFwxMYIECiiZefU+duXlTXzGwUrVuNCruISPP4WyDRsA+TJFZ+ZA2E5CvApdrP
         BSi3bOCzWLqLSaMwkGepQj+IT97nJ0ksMPW9gYiiUrd5r7XEcr7stnZFl2uySKH+B24u
         lKaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pERiy6dVlA901+DL6zvyyrnjEz4Li9eRjQ4QFKdKZJQ=;
        fh=N/m+GBjy3jcjXC0wYHBzuQ3T99nBrZcz5UDTAmcZ3vI=;
        b=Aq7DdCeClskihhn2EcMgPVsN/RgOOdnQp0hOfnk7u0GMjzfF7Ys9LZpD8iEdPLWtJG
         gmNcLufwDIQ3c0efTiQXj4t4NCZ9Z2SEU+Jsxjc2/1SrMU2xGzfUDu8DthNqayjR5iQT
         /t7kp3eniO8wVrS4jCZkDU2yZd0NoJMx0Pap88+M+wS8ZHRAtlT50bDqK3e2FYFqBDFM
         fqRWh0zF4lO2C/LQOqIe8JqfsfwZf/58if8BRNSVO+6cuF+I4CZbEqAvjmzBvqT4EENN
         TuhjKcWDw3RAXk05itP9TyQKYnNFPJxPKkehQ+y3U75iJ4gLXR8tcEKAyIFNXNSdlawl
         clEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784133303; x=1784738103; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pERiy6dVlA901+DL6zvyyrnjEz4Li9eRjQ4QFKdKZJQ=;
        b=jde5zuMOXRhPVVcAoNF2dynYf0DlUIBngP8pEB/L8/j1PR2S6yAqyGjYK3SfVdSr9w
         83U3sSXXVqWtoxp+syY6Ifg5fmMk9gjcWC8UQC6q5i914Qn2IN8900YNj6vtfNPQI2t1
         BKoYs9PRLbyy7a2cS88scgXzMosXC3vzGiWhDneE6aBH9V9DSt6UPejxykeRYDAPpM2p
         yJsjnj0mOmTLlTRchQ/0jK4f+72p8SnQHAY3UBGImB2lOIXCgpjyY+w60NGxeyVWC6tO
         3LYXtvdnroaN1ipSv1AovW2zCwlQk1+68FotP3DqVNNXkrUYz4jzyvJT4ZJ1UVH0iFMd
         yZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784133303; x=1784738103;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pERiy6dVlA901+DL6zvyyrnjEz4Li9eRjQ4QFKdKZJQ=;
        b=Sk9/RjdTFKSHm3qgD3fWcrpw1GDG6nvR/yHducs0zVwXb+W+l5cGZwoVDFHnw473xU
         Wcif/k0n9nKPBdpmjWwLLvRk7Bd4cTf1NczuGG4eySko5AMAcFduYzeZ8+y2B619Y4Ci
         aBqk074F/arrPgpoqmHtdp6ooZZ2qebG41OS0c88pOgmGgF7j/EPGjBJBhyfvoDnPgL2
         j2giLbS7CSMnOgEBPb25rEThDZmIYRwr/iRcNejyHBXSzhrvGuaMi2OQb5hUUTd/ksp/
         +tjiOOXxr5bO7s/HzTsixQDQzSp9m5p3qECfcvaWOyZ7K1AHZDPw0q8CRxNYZ8zc+sS3
         E6mA==
X-Forwarded-Encrypted: i=1; AHgh+RpLmUJKDefOGxsiyv6sGMBc8vFdzF3jcUq73TUpHWLwNqfCGJGV+1GFEaQmOJVAraMku4byjeYSpQ==@kvack.org
X-Gm-Message-State: AOJu0Yy50t5NZUWesER9djmQnE4sSClwVHmJgFCAFE1E5pxjeFn8o40s
	nb+Gdkm8jd9rC+a/RHO2TMK2XBxL5XzKFI4ckUHU6jfbW5tgmmSVhBPeLAgUxYmVDQNC4190+8x
	uTgjO3HIFjW6FFrPsoS5DggxWP6kQweO6V3/fPJ9Q
X-Gm-Gg: AfdE7cmUpaW1nE0BTE5eUKvOQSjQiXsR9Zsh0T6LRyx/b0COhqEP0EJ3vo1HagCXiQm
	GzeAeLtE40DfYHHx5xz/OI/2/KfUKQvbdcfuBX7iUX+2wxWEnN7CblO4S7GDErML2KllhyrafGd
	UV82E78/pKpDA3sIfeyJUT3TEGO83xP85M9DU9jukgebUOiRwxo/b6BMuCWoSkfbpQCDjNh0B8y
	yule+Kvv6EFSUIV3M8gB+XqhfGt4vOp7SMfGG3kt+iGkmvvgSpWuqGGbm6MFjMceAPBD3w=
X-Received: by 2002:a05:6402:3255:20b0:697:9254:a66b with SMTP id
 4fb4d7f45d1cf-69ccf0a4e15mr209288a12.6.1784133302824; Wed, 15 Jul 2026
 09:35:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260714205111.2497151-1-mclapinski@google.com> <178409777790.255896.16691338963510282908.b4-review@b4>
In-Reply-To: <178409777790.255896.16691338963510282908.b4-review@b4>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Wed, 15 Jul 2026 18:34:51 +0200
X-Gm-Features: AUfX_mw4j5Tg0PUVoucFNnFxJRaEYRBEsBUaUuaX3fJCgHNZLpJrrA8egZ5It8g
Message-ID: <CAAi7L5e13dwTOJYhYu2q0XNxRHjaZz=EatOpK9_8+jacyBzNzQ@mail.gmail.com>
Subject: Re: [PATCH] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9957F8000B
X-Stat-Signature: xceudi64jr1ye51xde739ru51wznnofb
X-HE-Tag: 1784133304-111387
X-HE-Meta: U2FsdGVkX1/QFujaSeu+Rhv+Hb7vXrSQxaogUcKoLI5I7Gq2oAydmfrA6XS0dX8k57xIs1EFXKMB4iU21P8avbKyhNfdU4Ldoyx1TJXpU5+AD33Jf53ePEP7RZYrJKTWgbH7ANsmok1yCgtI1p3jrrjZjfNfx1E4uKe8Tbz0vK/IQpH+0XAYaXi+Wn/eE+fnX2cwMUbevIqYA3C+eXInA+e2koP9wRrFSR0cTp1Cl6slPi0UNX/HMmkiKbpY8USu10o56tmDaAccQb/Pkt/c2LroDR4mDiCNkvMUtdBTo3/w4ObCeqVM4v173y1YGMg+S6OaPi07y5Di/i2jmVRITCHdu3z6Oo8uav9PdwMZxXiU5TG9pgZVv8g/HRsEUgTF8jBwdulxImg2G6JvZWw8dXcm9M3GhokYMjTOMy7ZuGFD/l+srALkfHA/Y0CwLRGIb2TfEMJBfJulims+Dwkzm++bV1gIQpFtwSCYgiqnyHYRsuro+DoGCOtLh1HRlzGl9F5yfaOpUj2Wwk8tTKeKHvC0wy9D3wkVeJD+6fLXG3Y8fY5xmpbEZW+s8zRGHdnMaIiF+MJR0RlqS9P9YlStD1fMqE+d3elJ4BArVjW8SJ7nNCaXLFQYidYce4OFOHTtSMVev2k+IkN8Je4qKGHuGdRkg/zlt8ujpWsETxA2Zdxm2DgqxDbmDTwaA8585ScAiiTbUZ8rpFSv8lmnrBLmTxuBg4CQOweqaBfKS+ZYemKOrUe4dtmMtvi+5tHLEvuZu3bUXVD3Dcs/SNMfshJRnBRKj20GhRXm7CCzaR1PyzaryWsp6Q4H5MX18/fFm+fnwa05avquOhaqerBiwGy+ThONuM3/luMGE1NVFfUZS/KHAK97wyrw86r9xgy5S3z9HFV1yfz8JqKLdy/lDd5GH6DwG7I6nROFGIcL3k2jHlQUlvVqQMjEMj9/ProdJIxkQwP3shtn9Q82OCAQ4Xy
 PUqWicGF
 SstRihqYyLK61NEkdNRpi3HyjRXYKI/rITYS5cfkJrRs6FtJyOtSnsJsQ50A1FkD9iLmJe3QfUlgkoxYg8VdfHFWN56U2a3aKWioH5EMbAosSETbj7aELLuiMLAnTh1cPS2bXj20PcMJ/KnmG2IkBSGGl6uP7EB+v9QrZ8kYk6VWfEX9RKt1heH8v7CMdv1bUPbvckx2IFEkqCA8QqFvqep/czzT4NT4j9puyPAN9yR8ZpxQbX1rSaIzui42anNX6VNjfV0mTq/5+eMt93urMrGR37PCsA1DPqsTbVJSu8oPqp6rB3gzpuGJ8LICek5qWZ9WO7n7tPEUiNOmwziRWpP1mG6xXhGuTotBXhupzSzHQtsbzTKMaFwtd2V3UcNOiDbcBMiyWS4Jip6lzxQaB7qxzWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 8:43=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> Hi Michal,
>
> > I caught this crash:
> > BUG: unable to handle page fault for address: ff19164fffff8328
> > RIP: 0010:__free_one_page+0x1a1/0x6b0
> > Call Trace:
> >  <TASK>
> >  [<ffffffff913208bf>] free_one_page+0xaf/0x240
> >  [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
> >  [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
> >  [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
> >  [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
> >  [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
> >  [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
> >  [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
> >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> >  [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
> >  [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
> >  [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
> >  </TASK>
> >
> > deferred_init_memmap_chunk() works fine without KHO because free
> > regions will never be neighbors. However, with KHO, free memory
> > will be split into (free && scratch) and (free && !scratch).
> > KHO scratch is aligned to CMA_MIN_ALIGNMENT_BYTES (which on my setup
> > is equal to 1 << 9 pages) but buddy can look at the neighborhood of
> > MAX_ORDER_NR_PAGES pages (which is equal to 1 << 10 pages).
> > This sometimes crashes when one half of the neighborhood is being
> > initialized but the other part is yet to be initialized.
> >
> > To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages.
> >
> > Fixes: c6073743d0c7 ("kho: make preserved pages compatible with deferre=
d struct page init")
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 4834a809985ab..50928aaa33710 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -38,6 +38,16 @@
> >  #include "../kexec_internal.h"
> >  #include "kexec_handover_internal.h"
> >
> > +/*
> > + * This is the minimal alignment required by deferred struct page init=
.
> > + * deferred_init_memmap_chunk frees memory to the buddy allocator, whi=
ch looks
> > + * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
> > + * If KHO scratch is not aligned to that value, buddy can access unini=
tialized
> > + * struct pages, which can cause a crash.
> > + */
> > +#define SCRATCH_ALIGNMENT_BYTES (1 << (PAGE_SHIFT + MAX_PAGE_ORDER))
> > +static_assert(SCRATCH_ALIGNMENT_BYTES >=3D CMA_MIN_ALIGNMENT_BYTES);
>
> Maybe make it a variable and set it at runtime?
> We won't need to worry about different confugurations that override
> MAX_ORDER and potentail divergence of pageblock size from MAX_ORDER in
> the future.

Sorry, I don't track. What would I set it to at runtime?
MAX_PAGE_ORDER must be >=3D PAGE_BLOCK_MAX_ORDER and I don't understand
what's the problem if some configurations override MAX_PAGE_ORDER.
They can't override it to be smaller than PAGE_BLOCK_MAX_ORDER.

Are you saying that in the future PAGE_BLOCK_MAX_ORDER could be bigger
than MAX_PAGE_ORDER?

