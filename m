Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C134CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B218E001D; Mon, 15 Sep 2025 23:36:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34818E000F; Mon, 15 Sep 2025 23:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E71AE8E001D; Mon, 15 Sep 2025 23:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2BC18E000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:36:57 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 941B313B014
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:36:57 +0000 (UTC)
X-FDA: 83893702074.04.55446FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D9AA91C000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:36:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CNf7AHxN;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoUtYaSqpxJxvLloy7nshr4G6vpZl850tw+AAmUwDdk=;
	b=6B/ZIJFFmVkKcBwIrWfk8B7qnnQnq3BAu8Wsc1gKAnjJ2O15rEOs6ZjAKgojw8Zn7FbbhA
	v0n/RxnxMRszCYRWrREDximxtqaXwvBRtea/fkoDYiWKK16i50HmubrAq4sW91DqBqBiU/
	OLGOrgssVNxi6lAh1ZN3Lh7OkmbYxnc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CNf7AHxN;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993816; a=rsa-sha256;
	cv=none;
	b=KdYYp1R80fz9WHyvXHTAf9Q5yoiet2WFA/d8MKIij2DL/syBiLLjOCzoyj0SkGn1Yh0GYY
	tH3cic6abNrSsUiHXn46QafwYYm/yt/cpJIqoDeaP26cO1MiwZ27H4NjCtO2yvngttuGb2
	O98+bQLNXYjnHnv141qk8FTkpAfc73w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7F3040716;
	Tue, 16 Sep 2025 03:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04DAC4CEEB;
	Tue, 16 Sep 2025 03:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757993814;
	bh=CfVil0FdRSS0PaXQXnEL2MuMd3+XojlUadD8GRWQi7w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CNf7AHxNVzyFResUYW5usorS95/1cgWEfQBxIXzVgEh5LcEryf/UaE9d6FXnmevp/
	 hUOvt/SIiD7/Xfzhk6DVSSkzymHadep7a/+dLaY5Vb+n0WLbUQmf5rY9iYjBaJbYhP
	 EK//AR137efTrjN+qYgc2VP+Ya6Cv8E6hGsRI3+Y=
Date: Mon, 15 Sep 2025 20:36:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, ryabinin.a.a@gmail.com,
 christophe.leroy@csgroup.eu, bhe@redhat.com, hca@linux.ibm.com,
 zhangqing@loongson.cn, chenhuacai@loongson.cn, davidgow@google.com,
 glider@google.com, dvyukov@google.com, alexghiti@rivosinc.com,
 alex@ghiti.fr, agordeev@linux.ibm.com, vincenzo.frascino@arm.com,
 elver@google.com, kasan-dev@googlegroups.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org
Subject: Re: [PATCH v6 1/2] kasan: introduce ARCH_DEFER_KASAN and unify
 static key across modes
Message-Id: <20250915203653.c17d501a5f4b68936a0e3ea9@linux-foundation.org>
In-Reply-To: <CACzwLxh4pJOBbU2fHKCPWkHHCuLtDW-rh52788u2Q6+nG-+bTA@mail.gmail.com>
References: <20250810125746.1105476-1-snovitoll@gmail.com>
	<20250810125746.1105476-2-snovitoll@gmail.com>
	<CA+fCnZdFp69ZHbccLSEKYH3i7g6r2WdQ0qzyf+quLnA0tjfXJg@mail.gmail.com>
	<CACzwLxh4pJOBbU2fHKCPWkHHCuLtDW-rh52788u2Q6+nG-+bTA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D9AA91C000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7sosesbo5ssmydsrg4wq6d13tqh7jjh7
X-HE-Tag: 1757993815-119186
X-HE-Meta: U2FsdGVkX1/A0ZvlJMLy1aQCIi1nJwXdxJuWV7Vxco8ClBBABhajyAe/ec1xpVZlHbWXuGLvsquGPPFbahmywdOqTiI9+joKw7CbuJoBNc3/drX/eRBXM57xapyQNajbNOa969NNzqIdlfrpabXRKCip4uhIdeBtXqh3jCPt4idf8LbnBth7OPxGmtvO+G3CFhKjRTg4w0+ROBRwZdO6gs+cIgJ9RfbOrJQZ3hmGEuD43MaWoYLY9GUZas5LeGsXwld93GTn1DBVZHPawt2YcQuee1shRogwjH6Dqb/NZLf/MCPkmg3tqDaWFounlhDGouGo7204WPHEYwjTbSIw0JYg4veCYldBxEYFQSWz5ooT26x93hFE0u4mN+PZs+vzUL0rDS8ghaY+3M2xMjUzxojcJPyShdSHLSnHC61Vti73FWOMlFHa207hmh+dUvdCzizPtqstU7qEKGfowxtkSjvS/HeRE/cZWSrtLJP6cddhOets0h1WMP3PAA7mmO0n4XBTYyZyH2p4Xr4XUWRdK8Pg2wTnDHPH2IRKIHD/k3n3Z8xlE6AxYpR4dwGh/LjkFrXNh4x0p+JGMuIytvj3Ivo596Bd1a53ymtCVkj2vwLeR5OxFMUI6rSzOH3kPQsoyGt73mnACENeV+aDN2GUxhEa54KsNyrTdxSx20NwplldKM9CJ3jhQmoiF1+kzxAAkvATbgwmxdygN7OkGtBj2p8OBIyWN5s3mdQzNVaPYEfPyQWjOAiR67y2dzjkJs6RQ2psLrBtvxygFB5c6ZU1aWpCmG1NtWmHZA1EAwpeLMJ5qfdEzmt3br5H4iwMXSQzCaOvzXMad7Qc0z2XLuKkqHZItaqELn9vHV+jXVdw30RRpt/GTETJt0t2swjBuNPaPdfKoFlpvrLdEuM9skJa4jIyy9Oh2HMVX7Z+vfhaFgCCC2TKDG5amVaGX3i8mTILcBC2gQpaagGujAaKU6/
 FLzEm7YF
 P/Ks8i/99f1Xo+e/35c1fpvSElpF0KiZWOFgwUtgaQL6DuyOuEMu3r80mHtFjTP5+zBHt6P/Va1+AJbyK5YbZGy87tdmZjMgmQwNvApEt2XF7Yq/CsJ1Sv5U7pIFvuDTDCP2lIxMKJEBsASJ0wTEKTIOkF54MAelDO8+go8DG4gvL9pCwPSWc0dzw+h6lL/my+rSBniE6F/fqmlEFlOg39JpqFwcipAnAofMla+ys4q5e0/VJGUGqMIfB0Tz52IOkh87CfP/nDypBXELDwyNH6KruOe/GH5a78l2itRoag9wnNpZLxGRtnA03sbn6GJErjlu3lsywiuCKmyrQ9x9jzOM2b4oPYBvM6lmuW3T4EEm3Wdzl8cln1FTBvWSdlFZeAVaoa/CUyC36EJXgeKS8OSMR07SQLDtXqmOJkstO/8NeFwQjrY5zsphIK/i+lAruQ7wL6O6LUZDz1tLRzVzh7mLyhF4UI9UI+Com
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 09:30:03 +0500 Sabyrzhan Tasbolatov <snovitoll@gmail.com> wrote:

> On Wed, Sep 3, 2025 at 6:01 PM Andrey Konovalov <andreyknvl@gmail.com> wrote:
>

[400+ lines removed - people, please have mercy]

>
> > > @@ -246,7 +255,7 @@ static inline void poison_slab_object(struct kmem_cache *cache, void *object,
> > >  bool __kasan_slab_pre_free(struct kmem_cache *cache, void *object,
> > >                                 unsigned long ip)
> > >  {
> > > -       if (!kasan_arch_is_ready() || is_kfence_address(object))
> > > +       if (is_kfence_address(object))
> > >                 return false;
> >
> > Why is the check removed here and in some other places below? This
> > need to be explained in the commit message.
> 
> kasan_arch_is_ready which was unified with kasan_enabled, was removed
> here because
> __kasan_slab_pre_free is called from include/linux/kasan.h [1] where
> there's already kasan_enabled() check.
> 
> [1] https://elixir.bootlin.com/linux/v6.16.7/source/include/linux/kasan.h#L198
> 
> Please let me know if v7 is required with the change in the git commit
> message only.

Neither works - please send along the appropriate paragraph and I'll
paste it in, can't get easier than that.

> >
>
> [another ~250 lines snipped]
>

