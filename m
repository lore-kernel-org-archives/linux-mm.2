Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDE3FD8FEC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93F3A6B0196; Thu, 26 Feb 2026 13:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC356B0197; Thu, 26 Feb 2026 13:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB606B0198; Thu, 26 Feb 2026 13:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66D176B0196
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:08:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19133B895C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:08:51 +0000 (UTC)
X-FDA: 84487393662.10.0F15E3A
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B29580016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:08:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Mgk2aqaI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of jstultz@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772129329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Qnm2oa0MVzHK3SlIdevV2oCNgF9I6YsjdLLXN+h7bs=;
	b=GlO/sp2OOs/pSFawRQHEOEcjKgcwacNeDAhnQKNrGpNZSaf7oA+RyfSJkm6dBF8CWVbyBc
	B7Z5jSriUZXgx7tJa5AAQ4fmrePx8njaa7UGdWMx2lsEzBrwsxJMQWi0DkiWaxZ4H7dGBp
	MIy7fiF2x9G0AN2HJVQqhBady6lRnng=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Mgk2aqaI;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of jstultz@google.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=jstultz@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772129329; a=rsa-sha256;
	cv=pass;
	b=oZ4x3bcnHw99AyGZ9C5O/W9K2aDFjv22K9BHeHkDdC095IAuwTo3GiYNTTgICA7ELZ2Atx
	SMln0EKF5DNZZ3C4lHwPHyEeqXAqsXrsHM83OQ9OpYrneUFzNf0EsXu9+ro+JBaFZul95X
	e9vadpG8xuqJXwHlAlsFzevuVorUVp8=
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-59e5eaa491cso1443486e87.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:08:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772129327; cv=none;
        d=google.com; s=arc-20240605;
        b=kfwP8RPwTaLIJZK7W/Ai2phBUwspHc8vL5hkrBYliCWWdiumBEtEF8Kf1ewQu3KM9P
         Wgt0lo0wcX+jefacfqaAFgvqI4Byh216Rj+8+G+DoWnwayI5nL/OzV7GhjEROBf2s6J4
         0h8jV7iC6Hc6zx85/cVwy8QsYIY6eOeqbFO4ppyDetYWu3gyoMXMpJbmPs79mozS9QS4
         o4erofSm3ySLCIGX2Sr6btPI7/puAbf8b7fkjo3kxx7srnjwldUJaHYFelZzyJjrLQ2v
         f+QJV18HfH+mw3eDniuM9L5RZXq4lzrsLtPZgFnmxpJOUgCkK46rezGd6ot5WObBU3si
         nG6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9Qnm2oa0MVzHK3SlIdevV2oCNgF9I6YsjdLLXN+h7bs=;
        fh=BqoBWclTyhMy9wk1roKm7ce5jezJoKTgstCVgF6wLFs=;
        b=SdN3uFreE4MH5g3JpCa8mcNN4Fpjo+Tw8jljEpJn6fH7VAX2yujPqgd7sk5tt3G58U
         jsfrID6ZHJ40NXSyelG/BVxQZ5a3d6pE57TtWvXrn1d0z0qG9C+fLwbkhZEn3kxgc1j7
         61T3qSaxYY8ZftbHSIC8DpdOHADxiOjOZWQO1/SpSHsE3J+ZPxM+EdcS2/9xCkEKlucZ
         em8FDvOsEzcF4joTvY+uqQSbbZDQgGktYrIpB+Ws1qSARkObkIvjakY4cM/HlPDew1Ev
         EKZTxgrQhnJVjAwI0h/4TCQemw7xk8KjuyzzodLUJe09wQYnEm6sJNxePp+Oa+Sb1Bp7
         0wQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772129327; x=1772734127; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Qnm2oa0MVzHK3SlIdevV2oCNgF9I6YsjdLLXN+h7bs=;
        b=Mgk2aqaI82iktxGczwBDU58IqFo4feaRsYXopGkNJzWeE2I+SFhYth/hjzLvs/Y2kz
         rm1ku0A8TdUDXFqQeQpFObUvy7aepOXlDGdGWlxVEUS2+8AN5ODJYHFTazO6Oy0LT/wD
         UJeQgofO6GIQhU1kAECnmkqUn8iN3K9W64duMfJOaxySpHZFee6vPvSYR692gYlmp5Zn
         8maxaqmOpTJA5TuJUdLFqGVlSW9XD8GNIo20HSD8JyupvxWMEgzk9He2aCtJ8gneyT7H
         t3Yq5su8kC/f+UCBopmgrjov5ElGSj0WQz6BUAhcDGgDD/AkHUd6z6rvzxgm/n9P2nJH
         fjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772129327; x=1772734127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Qnm2oa0MVzHK3SlIdevV2oCNgF9I6YsjdLLXN+h7bs=;
        b=AbTCg29w6+6ugdgO+mv+nd4z963PpSGr1331sJGKZj33nZCpEUzdDqTf/UtS4xDaRi
         UWlVinhvD9P9kirN9DzDvDnJ13oJfPWeiklY+CYcfn4o7szR66YsYrsiAOXrT5A72bOh
         r45LqMkD819GynALi3LB7YoyPs5f8wOGHZq6NAQ+rlY+xgY0RIXowJXbkoTeuZNZmZWn
         xCvquSq6ASCsI/ZVEcaAUMGrGwMRRB4GaPmJmkyMyL8T5uiBminGLnfHs94yG3/kIGrq
         OxSqdxOh7XFOYkTrY9Fhy9OaNA473/cVVrJC5hanQl06a/d1OQF52x8Wg+vY/ojIqNAH
         DdFA==
X-Forwarded-Encrypted: i=1; AJvYcCVnk+HB36r9mHrnFywMiH4NKfkw+opmBwhxx92AHL+elWCbA+6jEwwveuLOO/VyhYL1oAb1NesLAg==@kvack.org
X-Gm-Message-State: AOJu0YxCEsfzRxhh4zO55bYHO8V+Y93dZMTm1m7hh83Oh8gxIILviMQL
	c2FU4Jdn1yQvnoqukdcbK43KoJiTnr4qTm2vnKp0DWZMftqybusYOO5t/uvn1Z3TZAjV7bno5O7
	BpBpZV975zxmi7yiaGAgIqjxwWRzVY74R3hSf5vAk3fW6Ai/EivO4/FUULA==
X-Gm-Gg: ATEYQzxMa2Oi+RyvSqQQ8uJALVrvcIA1DKD+LEDmYaLU5QS+Rgi/m9OO49uYIP330y5
	8IGhhSrhnMp9hyzfCTb5zgGyYlHl2DfjQXuCRjDDkSqAmGAY7wk+0tRj6pZdatMzexnDcRZH26l
	6RHBoso7ZhlZAA7vLw/yJsFopYeQJ5xO3yfa+up4OPCPzMSlIRwZ2nGlUKjmUd3Ecdea8kvPBeS
	QLGWN0jgAL7XYMPCfUVxybjofGHF8grz3kEv9SfMsx2hf+4pKF6f+MV4z9LjIbneWk9zBDEjg6W
	BZHTbca1jTxe74DyQAYGnayLcvDkJo9Yq6WM
X-Received: by 2002:a17:906:eec7:b0:b87:d255:39ff with SMTP id
 a640c23a62f3a-b9081b37fe6mr1411724466b.32.1772129014224; Thu, 26 Feb 2026
 10:03:34 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <CANDhNCqk9Uk4aXHhUsL4hR1GHNmWZnH3C9Np-A02wdi+J3D7tA@mail.gmail.com> <20260226-adaptable-vermilion-nautilus-0aa6f0@penduick>
In-Reply-To: <20260226-adaptable-vermilion-nautilus-0aa6f0@penduick>
From: John Stultz <jstultz@google.com>
Date: Thu, 26 Feb 2026 10:03:21 -0800
X-Gm-Features: AaiRm538ftOfa1UyUjDoV9Yd7b0SRwtnSHBghCEM_shajRcZSxbK21W611Pqdkc
Message-ID: <CANDhNCrpNU7QJgu+0CZRvdxLwKp8VNxZoG_zDo7qqxaE0mjoTw@mail.gmail.com>
Subject: Re: [PATCH 0/7] dma-buf: heaps: Turn heaps into modules
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	"T.J. Mercier" <tjmercier@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B29580016
X-Stat-Signature: 7ryqumkjneaacoejboqxu36wy1u595d5
X-HE-Tag: 1772129328-798019
X-HE-Meta: U2FsdGVkX19Hv6NqB+i21HuPVRZyxLLAyBMlFa3NpWKXGeUUcSQ0PFvRteK48mB49bqKWFmoQrPmj38UUrP2lY9U5lR6YYw5jTUKTwJ5ZMdHYHBBm4D7SsDlMqz+f2AvC5e7p/JxeNeCgW+899Bloc2geS4pxRbdpLNoVq8VoHZJKlJ/Tc12YPrlC1HpEkln1bhvRrb0I65RkhE7pvxZkX70BizTGtrqUB94P88R4kUh6vWsMnf08GEQdM80cbGg2F8vsSS1Too+lLmpM1mpwbiinck/eNY1NnCr0P04ywP2nmti1VY5xRSz0MR3P3O2pfDjgWAu7orvWCsNMxcT1qSMGxdnIukeuDHbR2TxLDmxm8XQfmc3YFnhQki2N7Ie0fcOvyrl7ltEX5yDnOQgMwWyquLQjChENGTfCM9B1lqIEsiE61yQV+u8+3IoRlG1KGupP4qh1TIV6GySdS5FXAGIObDYuJhytzDCy9Q8rsJcFAMwG4SxfTgrYzp//HdIpGoJBtXJmpBfbXHraDbamT7dn60Los9ATe51sBCcVMJC5gR3xIufZyU7oD0UbbYB2/jaYzLuZwG9g8zZxWfOh4kzH4fZpvOXzYSBDUBXXX3+eohBLGPOIZo9VtlSrATsD3l0KxwswNsYAOf+K+CdeSe0QCedp3Srf4OaeSC+ecBSRWtUDsLGhXTvpKAACmn8Zfz+Dj15+d4UKfumGFcHRMmXznp0MOOy0xYmW0jovyEM4kyICkZGBCa/4PVST0mJ7unaLLjlvH6uKe+azPQ3szPxJnM4vN6A/MF65tK+QR3zdWupQMLj1eQJCmyQEM9HbL8PzJ6/fJWZgjhFuwMqrK5dEK3oxyanAa5uQNMQGXi3LaYphcm8uVEqIZIWkBhGfjXBx7MR/jPa847xg6L7oTzmdXCF9DraqqGHh5UXOGtc3YCl0xAdYPZmUbEN5GIFgH9/q4d13TooAOmh0lh
 1J/J1mbr
 atTxJ4EKbkGQjLO46D1Hxxt7S4j/kBYpkUX2jxHdqJPJbbaNmR1GNfHENpru0DWA8QOrZOBumdR3bKiaM7paVsLkYwb7BVIzwnwpH/f3LFbmG+ZFipM0WAXbek0Vy2fnEtrsX8PdnyUFxDiIZjWvRzGAugytUJWdjdIzxwuNuho0oEqyVCOVAD9Hw2E3bW7Ep+W9M7Ng4maG91s8hUbyre7fMrEqqVq+BsZi+69jO97yrjlv/FUFge9qCgdgq50SnJSzJvc9XBjIm/l2PcrgGGT8W/K9B7m62vxHCOFedhmKKMxiLFzntYftQuAq2PviN0YQOKueun10MmA6Y8V93bddwvGL3HAZFFwGJdmJmyuAAzEbsehkNFiScJWEUqpWR/GOv81nvx00hfyQAA2NxPSw4R/W4sHy5GGLWxSdk4wZIGoj+UFcfs9ttUus5G0y7suLRKPS+Dz03CFCIwqTKieaRXkfrdkQ+4ZE1iIKqREMrYR1MWYokzZye+znyZtowjqJv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 2:18=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
> On Wed, Feb 25, 2026 at 10:51:30AM -0800, John Stultz wrote:
> > So heaps-as-modules is common in the Android kernels, and was
> > attempted to be upstreamed long ago:
> >   https://lore.kernel.org/lkml/20191025234834.28214-1-john.stultz@linar=
o.org/
> >
> > And it got a fairly chilly reception, but maybe having the additional
> > optee heap (as well as other proposed heaps) might sway folks on this
> > now.
>
> I didn't know that Android was using heap as modules only, but I'd say
> that it's even more of a reason to upstream it then.
>
> > There is also the kref bits you might need (which Android still carries=
):
> >   https://lore.kernel.org/lkml/20200725032633.125006-1-john.stultz@lina=
ro.org/
>
> I'm curious about this one though. It looks like you add refcounting,
> but never really get the references anywhere. What was your intent, that
> on every allocation the buffer would get a reference to the heap so we
> avoid removing a heap with allocated buffers?

Oh, apologies I mixed this up. You can ignore that suggestion.

In Android, once folks were familiar with thinking about dma-buf
heaps, some (out of tree) drivers wanted to be able to internally
allocate from a given heap (somewhat of a hold-over from the old ION
drivers). So we have a convenience patch to provide that:
   https://android.googlesource.com/kernel/common/+/8e1ec97355ef9927e82ec18=
c98312bdcd80bf289%5E%21/

And since we return a dma_heap to the driver to allocate against:
  https://android.googlesource.com/kernel/common/+/fc1310ebf8fe25ea7b983400=
e6fa41f5a6d11966%5E%21/

The kref bit is to make sure we're doing proper reference counting on
that shared pointer.

This ended up getting bundled together along with the heaps-as-modules
changes in our out-of-tree changes, and I just confused its use here.

thanks
-john

