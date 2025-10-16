Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41ECBCCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 16:16:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0AD88E0022; Thu, 16 Oct 2025 12:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E28A8E0002; Thu, 16 Oct 2025 12:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91F178E0022; Thu, 16 Oct 2025 12:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 805CC8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:16:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 431EC1603A2
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:16:47 +0000 (UTC)
X-FDA: 84004480854.16.D642444
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 30707140008
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:16:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WqqY5u37;
	spf=pass (imf09.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760631405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LU4H/m2arF+mqUMYVRlHKE47q1ucl7Pu6ll61/fszag=;
	b=oCfLqApgOb7EWhWTDZlkIpbJie0Zf384W8K4rLRHKfnZCYUkcQ6ao285/tExFCtaWsvfOI
	FiTj+QgjwMU5I1HJDVoqScyIUlq2C9Wv09hk5YXthuW468NT6VlEKfCb5JVLC4wTsWmK97
	ozkSDKcKkeP1l9qH01CwOnwiAwUkA/Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WqqY5u37;
	spf=pass (imf09.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760631405; a=rsa-sha256;
	cv=none;
	b=7Dh+qbF8zkrjdb89kYzIcALPdcguHXZR3YulOiy0mNptUnwIhPo3RLUwbJ1CRlTWFU8KdX
	h8TeHO2CRQxVYGhYgV6TpSdcUhwMF9RdsBMYnfRyG1ttDrFil1AItlS5B0IB7GyUnnjy5m
	397iFsMeSlTht9T68Ojjhjb3dwY5vRA=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b3da3b34950so147208266b.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760631403; x=1761236203; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LU4H/m2arF+mqUMYVRlHKE47q1ucl7Pu6ll61/fszag=;
        b=WqqY5u37YKfUATOnoqN+b54zifXTL7V3sFl/OjgepMFpF77yO+l+mGUo5Wy7VntHhj
         5B48RkjW1mJuGb52zLSC+y2gPkR0SRjQLWjkocc0mJ9pTH9t4AczI0b2YgouvybYt1Ml
         EVCt/uK5PtH3zSB5CoirvrnmsPTaYIsSFEtEk4lJz2UHeY9cK7gMOlcTJrjh5T0ou34y
         QprvDBCdd4EXJOoR34myRsAjUpGUimwgDAYqPAA4tAVXGEWo26N9kKZS00STO7gBbUKS
         FobVZd3y7ZV9vMQP5NpWNCWtr56KKqbfv68v9wQ6K6kTlasvhCZfnLxy17VsLj1quCR3
         4JMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760631403; x=1761236203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LU4H/m2arF+mqUMYVRlHKE47q1ucl7Pu6ll61/fszag=;
        b=vZTfhbt4GllfDLwh35dwxdvylQ1+Q8X/ChN/HXbpvTpYpGKUE9D4BZLBN7mt6gEGnG
         +e3HOriniZ3chzg0lCjoLysrdyZN1lHfJ53kYbs51H/y8sqzLz2nqkZelmcZ4vqBA9kF
         qYwnx9Q91Xd83PiyFWh3TM5vS9EpCd/R11Cu8XbChsBbHANxceJnBDHGMPyQgO2TRoo7
         uplfJOUlYduNF5EJNlfy0XOTW0nasqNJlu6rBztKotK8dckAGYbZX3UKPtlfzPJssBKX
         HyzJr3ce82+dzQjIJah3xNtkNTN2SNMuwhyuwryeP/4YCZOfsDRWky0+e58VOWVOl1vm
         iXfQ==
X-Forwarded-Encrypted: i=1; AJvYcCV3nQsr8fa0Vk87qeTgpRVGpSBLf/W3OCzken60aksnvG7EbA5s/0VqxH4LX3Gx03JpyyOJrc00gA==@kvack.org
X-Gm-Message-State: AOJu0Yx+qcv2pNb4/kiCSiv8WVwdk/E7ykXC6G8Rkb+J+M8+tXkfy7gQ
	9BH3+xaRc7x4XAOotNtfBKuPxScW8o0pKL1n4dXEohAIAxX7vIX4dtbPLJocNlUdHneM1ptUGNj
	G2vWPhHA8AMtF+b7yKhcQLmbqO0tKWYM=
X-Gm-Gg: ASbGncv1zrZazidtV72ArfWYv+naWhADxwRdzNZOZbqA0FBCda4I8ZgfpgR2bqAr1oq
	Z8AAi08WawBqbcpvBP/pd6u+8axrd4Jd8GgOeGOyLArdtjGD9H//JHVoKOOW+4u+Rzbjz6b1XZ7
	hrSUZEd5iLzy2SUyKt8D0c9O/7JOrgLNMChNAkrRPxb+FuHQ+eBr47amLBnzVbJxgfKnYNWobil
	DuzEz/UBC5KLs3ko7+ddt5gIXIBDDMqkpO0VGqBg2s98lbqa+FXx9Q2k/K0979x9B66rCOfkA==
X-Google-Smtp-Source: AGHT+IGeI0c+J/vFikvKLQh7Q/TygfPMPFT9ewUwuJMXMjAiOuEpM5YJkGnX697MAOyb7hi1nyrkuoDilCUc0wP6mZA=
X-Received: by 2002:a17:907:2d93:b0:b40:e7ee:b5ec with SMTP id
 a640c23a62f3a-b6475510488mr53395866b.59.1760631403045; Thu, 16 Oct 2025
 09:16:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250910144653.212066-1-bharata@amd.com> <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F> <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com> <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
 <20250925160058.00002645@huawei.com>
In-Reply-To: <20250925160058.00002645@huawei.com>
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 16 Oct 2025 18:16:31 +0200
X-Gm-Features: AS18NWCi3W8UGN6S3h7IBg2byjYK79TJWWE4zkCP9FRr4Mz_MHN_5h5HNXTlxEo
Message-ID: <CAOi6=wS6s2FAAbMbxX5zCZzPQE7Mm73pbhxpiM_5e44o6yyPMw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion infrastructure
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>, 
	Gregory Price <gourry@gourry.net>, Matthew Wilcox <willy@infradead.org>, Bharata B Rao <bharata@amd.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.hansen@intel.com, 
	hannes@cmpxchg.org, mgorman@techsingularity.net, mingo@redhat.com, 
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net, 
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, akpm@linux-foundation.org, 
	david@redhat.com, byungchul@sk.com, kinseyho@google.com, 
	joshua.hahnjy@gmail.com, yuanchu@google.com, balbirs@nvidia.com, 
	alok.rathore@samsung.com, yiannis@zptcorp.com, 
	Adam Manzanares <a.manzanares@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4f7ea5dhcyg5w7k6fiotrqkdrybzsp41
X-Rspamd-Queue-Id: 30707140008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760631404-468071
X-HE-Meta: U2FsdGVkX1+EZECzC9M3KcBUMd3PaW1UzUF6SNWSoXV4ZOn5R7Ld3bw26tPqJQ73hyabkYshahzJVTmSEzVl3+uEW6xm6sTJwC1BxTawn/VAHz4EqDDdWU9kPXFzgQMF2rGl3vAEY9bUf4KhhHSWa9j+0freW8W4Od4INPp5pHYBN66SxTRGeR/o5ZsA+tbFcrIh+IVu0zFRySl4LgTGKJ2hnjKBocofnQWgRyCYKH6oNE281JfKuomOJNsgH8znmWUGjb13cIIjJOWrYMkcJnetig7TXJYO73dXEdUpPfkrKwNizRtRr9TdpFuVfV7GMs87x7tkyJPANXBAAUVEPZQV5DsCdecJrVSZpNqgOW+2Z3bQCkClQoio5TUamKjzBasmn9fquYDqG6wi3KXPriE9R6AVH6CYCojhzu/2kAyq3o1nx6Nfvh1xdnlq0x0+W8ZlvtvMIykO+agwIiYrGjrYmBZv+uqBex7Ir7O4SFwD1UpjhKWnkWZfNMphFDfhokRG1ctg3AIEQxUa0MhW2zLIHvOPKclrnOXyeErcakzWZJ98XXkzwLma/2yi+X0LY2yZCPI/CJucu0e8kIlwQQbjO1PbL7ObdLv6V6BkHyyLhgDfKTx3CVxC+bW8TBtFMzUCNiScwab6WmLpF3mBOBFuZBz1mrnoSuz9/YOr9qs9dVI3S8bp1BMUUsP9TW/QjT6WDaRUkHbOy8xwcjnx3OeD0N9omzTra74kizDznEJ+cxc2CF1K0yh2kR0tpTbuLA2qagZt+/Zr5CgM2nBjNEk78it3SSiS/PJ3H3fRKvYnVrljx+k/AQecjM7R6Ujd0j+VmqIeaYaXrV3ZCaVZqz0usEEmttZBlMyhMbz+okMnFpnYni9bYvh7pbbPL41xqhu7hCAdWm0/kQGniFozs+j0YbjldMs3bWQ+jz3xCoflD79DZszWIluas0TveDUamTFbcxkfJmFOQ7kwXpQ
 GCMyK7e9
 vQB599PQIbKxV2MkM2VE2PhwgFtI//KDySZ5+6A1A7wAajqlvzy4Slmj9X95V56yrl3SoTMrAB+z3HIUifWud2vvaBjdOlKFCza3FB+jz/quWK9OdmpG5hM+s0SAoA/CdfJBxqugQfXWfKU87F2pInv/xW2Q4NvT+VKOxgXW/L1xVrXzQmocfeG1j+Y+cv7Z1L7vBDdANxrc7V78pJB5TsK0RUbC/NzXTb0R4i5XNAesGpvY1PZcXHy59zka2TIne3g4LBVCDmsy5DQhgoq+HsaLEfjwjLfpPFPhbT5y3adQqd8JJOrp4Dfb85rHRDH3a1DUuvyLr4YlyXkkBxejae36xwaGRxXwKYVcBNaj9X9Cyc8WCutWGG5WUJlKTG3ivdMRX04JYNA0ZbqKSdUJTAy6F/Y+Ih+XhSQ10TSLpUOwrZlMGRN83DkbkJ61aQaQBo6SRQgSQGGIgqJB3bpba2bGmBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 5:01=E2=80=AFPM Jonathan Cameron
<jonathan.cameron@huawei.com> wrote:
>
> On Thu, 25 Sep 2025 16:03:46 +0200
> Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com> wrote:
>
> Hi Yiannis,
Hi Jonathan! Thanks for your response!

[snip]
> > There are several things that may be done on the device side. For now, =
I
> > think the kernel should be unaware of these. But with what I described
> > above, the goal is to have the capacity thresholds configured in a way
> > that we can absorb the occasional dirty cache lines that are written ba=
ck.
>
> In worst case they are far from occasional. It's not hard to imagine a ma=
licious
This is correct. Any simplification on my end is mainly based on the
empirical evidence of the use cases we are testing for (tiering). But
I fully respect that we need to be proactive and assume the worst case
scenario.
> program that ensures that all L3 in a system (say 256MiB+) is full of cac=
he lines
> from the far compressed memory all of which are changed in a fashion that=
 makes
> the allocation much less compressible.  If you are doing compression at c=
ache line
> granularity that's not so bad because it would only be 256MiB margin need=
ed.
> If the system in question is doing large block side compression, say 4KiB=
.
> Then we have a 64x write amplification multiplier. If the virus is stream=
ing over
This is insightful indeed :). However, even in the case of the 64x
amplification, you implicitly assume that each of the cachelines in
the L3 belongs to a different page. But then one cache-line would not
deteriorate the compressed size of the entire page that much (the
bandwidth amplification on the device is a different -performance-
story). So even in the 4K case the two ends of the spectrum are to
either have big amplification with low compression ratio impact, or
small amplification with higher compression ratio impact.
Another practical assumption here, is that the different HMU
mechanisms would help promote the contended pages before this becomes
a big issue. Which of course might still not be enough on the
malicious streaming writes workload.
Overall, I understand these are heuristics and I do see your point
that this needs to be robust even for the maliciously behaving
programs.
> memory the evictions we are seeing at the result of new lines being fetch=
ed
> to be made much less compressible.
>
> Add a accelerator (say DPDK or other zero copy into userspace buffers) in=
to the
> mix and you have a mess. You'll need to be extremely careful with what go=
es
Good point about the zero copy stuff.
> in this compressed memory or hold enormous buffer capacity against fast
> changes in compressability.
To my experience the factor of buffer capacity would be closer to the
benefit that you get from the compression (e.g. 2x the cache size in
your example).
But I understand the burden of proof is on our end. As we move further
with this I will try to provide data as well.
>
> Key is that all software is potentially malicious (sometimes accidentally=
 so ;)
>
> Now, if we can put this into a special pool where it is acceptable to dro=
p the writes
> and return poison (so the application crashes) then that may be fine.
>
> Or block writes.   Running compressed memory as read only CoW is one way =
to
> avoid this problem.
These could be good starting points, as I see in the rest of the thread.

Thanks,
Yiannis

