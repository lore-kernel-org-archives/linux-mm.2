Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2244CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 23:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3FD6B0095; Thu, 15 Oct 2026 19:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC076B009B; Thu, 15 Oct 2026 19:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F8816B009E; Thu, 15 Oct 2026 19:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D5386B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:45:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2A171C283B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:45:08 +0000 (UTC)
X-FDA: 85326493896.11.055B880
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DDC024000F
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:45:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4sb3hyR;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792107907;
	b=4afxWUsCfVMShPBMh67eeDLlnuK13IwJhR03To5pczSAzfRVRWpxqVs76B6iDdX0waBq0h
	wiR4HofA/NSgACxr3NaLW0OfgFU/h2DYpRFy4W5r/kuKhYtFLBH/HPGRIXbDbYCdG2zvsd
	lLc3ktfB3G02D5A6ypZ/9Ix1v0HaADY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4sb3hyR;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792107907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FCVqDMzrGgpkq8WGhMSthtCX8+3wWMMPfMohVJNwoNw=;
	b=r5JuQ3EtL8uN7yWQBdZ4SW+2cTVIlsnMTpAW+WGrEOIv0z5EDNxvw8MjwDM1c2guXMpkmU
	b9oj1D1Gfrr0aJ76ja0U2O/KK+g/2WezNYlTf+sJftGYv+IQr6tig+rql0JRklbEX6/QDR
	Wz+AQnoxnknqiZMF/7O5XSnY3QdpJeA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DC13243FE4
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65DE1F000CC
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792107905;
	bh=FCVqDMzrGgpkq8WGhMSthtCX8+3wWMMPfMohVJNwoNw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=C4sb3hyRJFXiWbeZ/6XrHtDW54pSeydB8hmUsGSsctsu/OYM9RdHXcvZ6S0hBQo0k
	 wYSA53xBFPJM2Kytf6kKVPFiQaxmoBwBI1CzheBzIfKk+00lVeyWeKt9ZEp6JpO6xw
	 41OHUi866Dg4mI0A8DZh8m0X3T1L7uZrJmScX3LheLPhxQBf7qw9NvGDQtN1LhBP9m
	 rnDaZDjo45TY5oOOHges+qBZYbOSRhVePaHoZLR5OoTGmPNwGLO7VoG01EIhCqabbz
	 BnmfiJoHwXO/P6MUUF0Y7j+PBQhAJ9YBOPdPjwbH0sZQnil+Sk4bI2S7mL68TJ7+5e
	 ojzxrAiqOH4jQ==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6af8620a7d2so6951245a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:45:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzLFtDDuG73pxnOiglQRnNnVK3VNN48v78Xb0j91oQKpJn8HKMoCtRH3s92F/qTlJ+ig+xX+CPH1A==@kvack.org
X-Gm-Message-State: AFq9FYIw4Z7SVxOeWFohcxIzEcnKGbDZgCHzuWyzlvsKvKCzyYfXYmt1
	AWgGCQ7D/sXWX/mJO7Sy7I8h4LnosX3zxMNpl4Lb4iFX6iAb+5D+iB86dHB4iixiJaxhjQiRNP1
	cRC7u3x6akn0rEdb14bS+9EyqcRa8MWA=
X-Received: by 2002:a17:907:3f2a:b0:c2d:fc0b:551c with SMTP id
 a640c23a62f3a-c31a9fcf4f2mr1949378066b.16.1792107904655; Thu, 15 Oct 2026
 16:45:04 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <as-jZopKRfuYAiTE@google.com> <CACpmpoeS_cvXRWJXqiYZV9oykk=91efv8KtZgK2Pi-QwHnQH3A@mail.gmail.com>
 <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com> <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
In-Reply-To: <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 16:44:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
X-Gm-Features: AclHuK8pqaYpWR70T_a5K64RldUi1KMaCsjej6fZWhQkmdzR1e8fyDYr4JkyQVk
Message-ID: <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: b71h5j5jpb5613geq317yb8oixb5m97y
X-Rspamd-Queue-Id: DDC024000F
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792107906-794546
X-HE-Meta: U2FsdGVkX19blvRwr+BCdnX4R5NBasp1vR9XfloUMLMe+NSd1cc433meUVhdGgUn9YtA+sGyPEcTJXW2c34YZRq1DVS+lWjokM966dCb5FXXGiLU/67LuEJgm6kjbpmv8R/eXxsDwPH4ia0FO9XgHE2mDy2sH8GGPoF0XP9V/QUXgdaKlI9q2LDmF6E8q4ZOEW1HQ4vvsQxWrjYyimed2jI5qXuS6kToR7I0yUeSV7x8WFZQdyZ6POuiYW8qsdClYnIH46kvecfimNgbOmGR/lzsc8bNCzc7wodNfw+EcGm3Tnt9Vli3qYpv3OBcfC7PwdiBKfjjejH9evon8QIGxLIR9iAC9jBtgucIhYQwHhbrxwyKqCGhGXxwa5Q+0sUbTNGYBJ/ePtip9RUHv8GpYkbHWdENVZzZ+QgnejSJtfMMUebx30q1NIpZppzjUz8lMdk83f+8aGqpefVI5xx7dmsGq+ujT9HJ9Phu9hy4A6h7YWAzoZK1F6FnLgX/UAxzEWbUoOy5SHS6o4TKvT+Be6DK8D4ZAGKIAPl8DPOdFmFw7WW+apsP9AOin5nRAX1rNLQvaotlc6tjHRWmpS2we17Re4kr/mYcQC03JU7WZdnhVeVvPko73pcWrUCdGAybTM/XSUD5NxyebJubNh0vTQF7mw4pjj+UPSTdpEqDnQrftzSFyCGUnprV048ms8u9GSr+ZHDyOHAQ0yeUXvk9bfYMkBF10wQYL8zgmxmp0sm47KNvxLSG8nyx79HqbnLtYuzOJxJOfYINBN0CM99INzJP2XdAHzXCbqqmShpm+fTUnGYu9q/M1ml7XvJLrcilGmDHfIOG6rzvmeURvuzSKrl+vxqqDQIP3L/YGhU/yZ1x1qh70kB2NswB1yXSWsLiMgbY/mOxJwH/o365vG4T1g5Pk3xSarkK6G4vcSNeqQQLQ9ea1eV4yCdNRT1/Q/Bm6+0VTl3H+q+gutWVHif
 snz4z3Ue
 F+ckmXZ9bIseyj0WcpNzoyZw5NZbR9yQIropRj0R5KRSDlaWs+OHJGKjV/+CjlDJuP3nRVIHmsKqePdBsW7wj/c44fMPOKyU09sso8o2/iqYBpXB4C4hc9sbgCGSCjyWWw8J3jKGis6xE3Vjh3CmPW+YIk8hhohNKnlBlbChW6GUtq0s/dno7MNIQ1ufDEy3ZA0CzPWB1R/RAUF8+Dau/93O3YHHvncOcyjJVVvlNdzVRzMdC7XNRS6xp09F2fTEdWq2/ukkGvBLGjCxyGr/i3Hs7hakbiTknFR0x89W5SfRQHqZpBmv2wdWpSsH0ah552qxVGi+/wJ2xPxs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > > > > How much of the performance benefits come from patch 6 vs patch 8?
> > > > >
> > > > > This is how the performance changes: Average throughput is averaged
> > > > > from 10 iterations of usemem.
> > > > >
> > > > > patch 6: 19,119 KB/s
> > > > > patch 8: 17,593 KB/s
> > > > >
> > > > > So the acomp_do_req_chain() path that ZSTD goes through with patch 8
> > > > > causes a regression, even though it provides a generic batching
> > > > > framework in acomp.
> > > > >
> > > > > I was able to retrieve performance with the following change in acompress.c:
> > > >
> > > > Why add it to begin with in this case?
> > >
> > > Patch 3 ("crypto: acomp - Add trivial segmentation wrapper.") was
> > > co-developed with Herbert. The request chaining for non-segmentation
> > > algorithms was as in Herbert's original implementation. Since this
> > > causes a regression, I would like to get Herbert's Ok on replacing the
> > > request chaining in this part of crypto_acomp_compress().
> >
> > I mean, why add patch 8 if it doesn't improve performance? Seems like
> > even with your diff, we only recover performance, but we don't improve
> > it after patch 6?
>
> Patch 8 does improve performance over patch 6 (19,578 KB/s vs. 19,119
> KB/s) by 2.4%. Besides, patch 8 provides a compress batching framework
> in zswap, which is the purpose of this patch series.

No, the purpose of this patch series is to improve performance, be it
through the compression batching framework or otherwise. The
compression batching framework made sense as it provided greater
performance gains with HW batching/concurrency. Without that, I am
honestly skeptical. 2.4% can be within the noise.

> zswap is the
> first user of the crypto_acomp compress batching API provided earlier
> in this series, which I think, is a great starting point for us to
> evolve this further, as mentioned in the cover letter.

Without a non-trivial performance benefit (e.g. with HW batching), I
don't see enough justification. My advice is to try to push 6 (and its
dependencies) separately.

