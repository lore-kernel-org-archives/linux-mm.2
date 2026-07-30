Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CB1C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7C76B0088; Thu, 30 Jul 2026 04:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF446B008A; Thu, 30 Jul 2026 04:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5806B0092; Thu, 30 Jul 2026 04:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE2CB6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:15:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 54FDFA1DBC
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:15:04 +0000 (UTC)
X-FDA: 85044732528.08.3262C4F
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7600AA0009
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:15:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FA/cOFGe";
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785399302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gU8t2nLiO6KyR9mHd5oQe5CKsSlNQJu7tk5IuJVGRSw=;
	b=HIc/dd78aVp2lP8Hw/Rr8UL+d/VwHqguuJM+pjl644X6sGNwIefpJBfK+ny2pT4Be2I/uY
	qPqowXDdjHBeKszZtPznttiOerLOtdHQMOlz2uk236/5glUrdoXDpzdSDCiL5Bppjv8zQ6
	D9975/B8mCiykS2u5WAaXWlRgIquCqg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FA/cOFGe";
	spf=pass (imf15.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785399302;
	b=3h0adeK33H0osR6322Drg6mb8dC//KGCYWbinLRUQ8XGGWf011m/OhtgsAodSkLgyV9ge3
	Pfjecl227HwbLTcFMBJh8Lu+2HN6gyYzwOhVRxhFA7eEAHJN4bNZPrLoGwRQgoKPo4j7me
	X0rZQW8wL74PC4gqn9ddL5HtUgUkCiw=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f93b2fe4cso1240317f8f.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785399301; x=1786004101; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gU8t2nLiO6KyR9mHd5oQe5CKsSlNQJu7tk5IuJVGRSw=;
        b=FA/cOFGeGyGuvqAoliIP0GGdvxCmmHazfgN+awDwa5mzrnnHj+BcFloPzIeZcGtELn
         KwgLkMYgdOHsdZAE94D1AtN1TmsT12KpFM1Lszl6Y2i/FJtmKJ2dDn5Q2gFae5ao2Mc7
         sZdBPasanjv7PfvbBZbnn2UIibCVUOW63YKkz+RwrMoaw8CaaSc3CHVt9QhTxJ8+lf2N
         YfnZ9fFGVmH7pPkfHfcsKQSEMkh5rxJhdP6CSWwZziOvMZJHnKIRDeTumP/QMZE2wrHC
         nMvourzyYsoW6uEpx3xQ0ehoD9no8CqidDTdqk+C3a806lVszYGcP12IHZig31MBt8s4
         cBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785399301; x=1786004101;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gU8t2nLiO6KyR9mHd5oQe5CKsSlNQJu7tk5IuJVGRSw=;
        b=KMLNG5Pkp/c73XhsccT+YKD+r5jpA16ShwcWenw1eT6tkNQIhPc8oBeRuSzNJedBcU
         zgme8VJmSFd6JmvBPLgXCheHdLeW0gcZfJnhNJ/01Nu4wdU4yllVX/+dcc01XRE1LPpj
         PP9jLAWiwO9Xd7N80cCUHDX1iGiNWo95IPP0CRHKf6aGtnZU+Z51+YFWh8zVW5jsmviA
         p361wSMvMQkH7v/T8g2zoShKp1vq2ROCV8oKTIoY60Ar7PWg1PYND+iePADYh0vt2GKp
         p9bWrY2Nx0EdlBXrutvkGnoQGLXRK9qRVb9ZzxNRIoBLEoBc4yvgcsccrwwQAEhWJ53g
         gtQA==
X-Forwarded-Encrypted: i=1; AHgh+RqxBzSCuiZpu2GOEiz4OHHt8hRszaftM9U2brPwEWzRrQqEJSPjEqrnCoGo1o0Xy5OZpTNqKZxalg==@kvack.org
X-Gm-Message-State: AOJu0YwzVyEsvcViBVjbuCWM/lRWdHkxe/qT0bqaPdOBcUQfGYrb6mqK
	56RUhwdhVHux8JHV5FoztuktbAztwaZYKOKyGj+v6Kr3LSl8LaIgifo7
X-Gm-Gg: AR+sD13cGssRg9vlqHmzEHj7lNzTUO+cuRoe2CA8T7z/C4UYPskiZMBy6/8siF8GJft
	JWIyh2XqqYo7ZMMEn4qCAWavYJc90lDEVEMD1KlyGL98OPl70xT6PE8WREJ/puklQRk9YDh4aym
	XKMo7SRaV63XnFTOdIkCQsQjLkHG6Ydh16MQKa4tIOuXkiiM23kQlGvbJfw5/IdaJRozce3MQGQ
	UgeHeDabWTpI2UT3hZ0Od2oPWKYVYrT1D+P195uhejNB6lA2dgn6EO42P15BzgsVhon34E38C4A
	oyiqhjKRkXcFicI8Fif4I6Z3do/csV/w7G4JA6i0BgjDKQuSRxmmWbBPam5sVj2pCePHgFHObIe
	qjazt1u28ciIGdkIOgcqlrjpJbg198EY1C6lummjLPcz+ff6vHQSR506E6C6uDnfK5jj+oabWza
	uNsE2mKFdoVFOlCRNtVRYn44CcDm7T0SNknDfQ1SCSk8Ft5W871sUdPl828ocNmL3XY5GazEWsh
	C1M0gfgtEe5KYQ6JvOwtlMWIA==
X-Received: by 2002:a05:600c:154b:b0:495:78ea:2687 with SMTP id 5b1f17b1804b1-49800eae778mr19575005e9.29.1785399300682;
        Thu, 30 Jul 2026 01:15:00 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49800f0ebfasm37683065e9.2.2026.07.30.01.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 01:14:59 -0700 (PDT)
Date: Thu, 30 Jul 2026 09:14:55 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org,
 apopple@nvidia.com, arnd@arndb.de, balbirs@nvidia.com,
 dave.hansen@linux.intel.com, david@kernel.org, kees@kernel.org,
 mingo@redhat.com, muchun.song@linux.dev, rppt@kernel.org, tglx@kernel.org,
 linux-arch@vger.kernel.org, linux-hardening@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH v8 7/9] x86/string: extend memcpy_flushcache()
 fixed-size fastpaths
Message-ID: <20260730091455.1242d01a@pumpkin>
In-Reply-To: <20260729234842.GFamqRWva8h7X59ccN@fat_crate.local>
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
	<20260727123429.5673-8-lizhe.67@bytedance.com>
	<20260729234842.GFamqRWva8h7X59ccN@fat_crate.local>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7600AA0009
X-Rspamd-Server: rspam01
X-Stat-Signature: cnmpmhsp1eqh5ow8yo593qfcmpacmuyi
X-HE-Tag: 1785399302-662494
X-HE-Meta: U2FsdGVkX18oP48UalvX5QKYHXBqKf4boTcl5pRDCq1YFJahQX7lawzH7shm5f8hsk/S9RVAHpfRp8iciwre//SqSzT+3n59MW3yV0tUNCHCtE/ZFMXSWppL9GEL8X1uU08hqSWiEagQDtSzPBUbpAof+EPPxbA7KtgPdsuPwi159YNhEN8EXGG7uvmSWx2HAvC1Ma1iyq8MENXYw5hkx7qoQdoHGJrh2VxeYH+IDfjb2CoqzDpZyeH+3M9j82bWKVlK2A5eDte1Y/KVnWLEc1Jozr+cpCWljx4lbShvRCdHkV62T3KmtMh19TX+jua8yuUGTmgk39YdKik2SHmeGoUa0s9lpWoeLNP2u9jOpVq1ZKFZtVW+JmxMnSIHgy8/QbaKwuc17HD1dAzVZK9UIG4Y9GJ3sVdIZ/RFpFP5RQBpVimNhOszB1eAo/No3qv1tPuzqAdLKLzBlzCqWKU2AbBvI7lQMH6NpnVXAiLINcVRLVtMOeniNTB8G7qc+uQQuEhi/aPCpDJ9RTcml/l4vnnruHSmq6RU2Xz9Hd9xgncwXXfqTz0KFbz4ssIIky4wABDWi9AmyS1+pXyUUNYd6UaQqcap8aplogpK3K5P1IdEMyJ6w9zdYlv1cG0dtFZSh11Km4pzAt7V9Deis3gIkEFBBek8DrwGv8qOYENx39zisOAg9XshYxXR1g2WoOhjq2pIvPO8ZKGnpWL+nYoHS1cQ6qoOwzI0q8jDuKvRmChX/gc3S1YJC+mgfoy9NDleX/N8u7t2GtrUJvHz4YfxsA5vSK0hjThQCU5AbhfzZbSqU/zUgLbnzJk9aAk1d2Irq4iMJKqOn4k+l2aA3ecajtsLn1PIssOGBQV500u5IiDc5GSkp3Wmm5dFkWvq0U7p/fPX2+SffzBz3dFsiRYd+Wpij2HnxPxXTXfKLOr36UdbElg0l3dBUH4dO8sXppcwWCXRFlNCRtaBaYYOa+P
 Ai/DVlVj
 irK+Wuhr9bFvh0fPDRKJ/WE+GhfHuW91NdzppXIXBvWIsBRYd4SKa9sc2eq0zjl7/ZxE8W43Y8FbwTkKEC8991IoQOiCJVnFPkMaOKSEvyKFhLEQNzN2jvZkkVN/MC6IYPROOBhBEenMNFFniDgMPF8u94JqNnIjwEECOu4RqHmtKu/y/NQcfRtOYtKMsqo5zZzqCzhvojoh1Aiwibkc6zMT+btuw9+GAgRgFoy649sGJPk7nm9bXNQfG8VC1S91taC79OibCkJKIahGV943KbCJkxKgNLiPM72JKiq+W3ZCyovLyWPhwDxQZwMg3htFmHoEkAphWhSQJcPWnLhVZa7UcBQz6uYR4+y2YbKN3BRWXagN8Q6bo2I3TR3BvDZYWF96RD0NS4Of9AdecnzakkA216vmYZcIXyYXx7bt039Zzv1mVngiMxh1LZZv+xghk127bFc388O5vCLMBbzeSbbaoaoQg8sinJHWx8rBSJPxbzcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Jul 2026 16:48:42 -0700
Borislav Petkov <bp@alien8.de> wrote:

...
> at least the code is making a lot more sense now.
> 
> The fact that you had to axe off so much cruft off of it tells me that you
> haven't really measured it right.

Especially since if you do actually measure the clock counts (non-trivial)
you'll find that loops are often completely free.
The out-of-order execution unit will (effectively) execute the loop control
instructions to generate a list of instructions that get executed at a
later time.
So provided the loop control doesn't use more clocks than the loop body
(and there are spare ALU units - usually true) loops really make little
difference.

This also means that unrolling loops often doesn't make things faster.
You do need to minimise the loop control instructions (and gcc doesn't
like the best loop that uses negative offsets from the end), and
intel cpu can't execute single clock loops (amd ones can).

Inlining also increases the code size, the I-cache reads are actually
likely to be significant.
You need to time a single 'cold-cache' call not just loops for long
enough that the result is also skewed by timer ticks (etc).

	David 

> 
> So why do I really want your patch?
> 
> Thx.
> 


