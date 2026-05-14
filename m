Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66FECCD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 23:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A73F6B0005; Thu, 14 May 2026 19:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5583D6B0088; Thu, 14 May 2026 19:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447246B008A; Thu, 14 May 2026 19:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 344B36B0005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 19:02:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B16DA05E6
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:02:03 +0000 (UTC)
X-FDA: 84767550126.12.CEC810D
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 66931140022
	for <linux-mm@kvack.org>; Thu, 14 May 2026 23:02:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KikxnJEQ;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778799721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7wmE2rJCxinroXPaQBQ40WUqrEBuO0hmw6nHwl8iRM=;
	b=z4RESn3nKq9caZNb27bF2dn+bZP5VHHc+K8RXU1rr5+CfBX3FQmze9wfzsWlDLUEiDj9ew
	t9RHr8OjbV6adCUbjw0U4pMLw9SgORvZ8oLv2fjdovB1KIBVE51YT5LQWhfMl+z+eYXLWQ
	icSiZuLfcvAv1+5S8nHFO8Jc4iBgUF8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=KikxnJEQ;
	spf=pass (imf09.hostedemail.com: domain of elver@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778799721; a=rsa-sha256;
	cv=pass;
	b=umVDHImIps13hqdKAzV9eQv01DutViQNzo9Wcvfud6kLfV2wycTyrAX734klnCe9tBI0Cx
	BkpZhvQ169n5+r8ub62DiMKx/yeUFPJEPlMipmI+JCZE2ZwGR8Eu+hxNtF50APimwXEkBd
	UALiy/a04CyKUrOGjwDrhhHbZ067Eys=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12c8f9846c8so12827478c88.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 16:02:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778799720; cv=none;
        d=google.com; s=arc-20240605;
        b=GJavEaAL/+u7EIfg44gAyOgrFenrK9rOWjkWyBdyv0Ks9ko+00sKGQJ6rnwbOr0XHt
         /d6+OVBQ9S7l6OGtVyJ38e4UbB/lkah3Qq5MxnK3JK9S5giErJREYK/kCQYqXSPzDqvR
         e1uxorP8A9pyZ6Px7lw/ZThUhy7jyXkqZCxPr7M+nZZTqEnm/yegGjORbp8rSYcQe4k4
         Qm4VV7Vk3d2WpO0ikt8GGf4m8as6eRMEZ00ywLsh6u5KIG/bYBaF9WPm8KXbCWpE5UTb
         h62aOpTIXvBm4hLY0YPEyVuR+mcNKlqs6uEG9kgQdq/Fv823/hed1INbCgdQGVs6ows1
         FCUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=X7wmE2rJCxinroXPaQBQ40WUqrEBuO0hmw6nHwl8iRM=;
        fh=pZHvgHWb2MEfHVhpo4vDkEV3o/U7nYVCKlQlef6dPyM=;
        b=ChN7C1oaNWM2HbH2SjEtavNIZXhBYM8a1jB9eqHggbtDhYUSlbHTedwm+yS5ZylN5j
         KtkkfiqCkwENdfDeW3H7KbfG7S+yOYl0CUQyYoojf9K4ivXw+SdK2duHhEHJUvr4tuxE
         gq9c66xP2LgTALh+Z0y+ePywesRTdQ6CQDmp4nn6gEUEKMusNbVXhTyjH4kgUcJu4URB
         4A/p7AHjgCSzFl+MCLeqdmxuw55wLSAZxmHwV5Evkq/UAaVVJI2Mmy5nc7eDxaFOf1c0
         TL+QVRopfB7uDHQOv9FFHOMiGl03aet8TCCmhWzrEuUTWi7PK6ri+sBUcXRwywk/Afu9
         qBPQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778799720; x=1779404520; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=X7wmE2rJCxinroXPaQBQ40WUqrEBuO0hmw6nHwl8iRM=;
        b=KikxnJEQpTXNg6IDb1kuap9WxcNmaswmklWoDCQSWtLvMxlC5fj1UQSgdJvPlW3igV
         Wd4Zf9VKyY3C3VBXoQCellMMURXsyu0ZcssNnMAhZq7cdfd+KqkZH3DqjsEvW7az3FUJ
         LzAHLmJ1klQUGPzTA0oD7npksA2RbfC5LCH3FlkKzkUxtsYCVZEFNeTD4/5vlNwr98o1
         +pMwUP+DqZY3eO4tak08BTnV4LFBPGxsxrXvLZylbuhk9pgdttlSnuc0uP84knzbi7dl
         hgI5bZP2nPa+snKms2Ftl0gnKfP2PBTNSEENa34YTO+Nh1ckonyy9+qBm3Va9ycDuP0k
         T4pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778799720; x=1779404520;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X7wmE2rJCxinroXPaQBQ40WUqrEBuO0hmw6nHwl8iRM=;
        b=VHMiBo8b0FvaiLPz6ouyQPPJUv3f9+mWiF2WLO4FER+hwAOjK4kGmgTCt7wXS8i447
         4p/AMU8z5NCZYgbn8m4LYVeZ/r5igW4lHNzem/4Nxi1cTAA8TXFpPnoDn2BO79g3FAkD
         f7FkXDFt20FK477TQrK4hl93T8Vu/YG7E9blGN1b0Jxv0926zdYTPAC4Y2Fch85B4jC+
         qgizvus4ZxekltQHiT96nEsfuC3yl3dCR9aYCafQjE4M4f8tMFyfvtwc7R+Ac1i56NZn
         CneePVguKtpIrZ+DtKf4OrxXHaSx51NepoeXKpCngLAb1Ot5iBLlvHrRaC2PQkES+xMC
         Dp8Q==
X-Forwarded-Encrypted: i=1; AFNElJ/VXg/qtfXLwxf8yLTY67mFFOljlX0+HP6a/8pMVm68BGAQ+OLKqQx3fvsWuonkFsWEEWVwMCGPIA==@kvack.org
X-Gm-Message-State: AOJu0YxDOt9IAVyWtvo0ZA7Pubst/lziWnfB/Lb5DwqLifKI1wylsOr3
	/XRVy6gEJm5lZylOZScaKkwkBDep7R/AKPT9fc+VfNKlXz+lVI9XU3NpyxR9VtP2QrPOiAs22na
	DM8x877o/tH0K6H7vWq2friF0GeLZBM4neyHf1Uzd
X-Gm-Gg: Acq92OEmGR1ejZvJ0wcXKcvoDerJZUl7DSmw4QYgatNkN5xilq2WrjL4RZd3oa9lpeb
	XX9LnByEBdhBU6SGJrKu7t7PnWMmjkdswLXTStCF7mS/gtvDYC8P0IYe8SjAbpTVS+TsXFApw8O
	vh6s7ga+efLn0jnVgfPdaSwsnj+cxDT8FkksRvj5zeUIxucV0zX5/jsgQW1MtUHuTyXfL0E6AjS
	9WzCVTup7BbTjDibjjMxU88EkGAskDox/qm16J9Gh0vXlnor5tb1f2UAQF9+F+RPbY1zz8jrMX1
	PX8u2o0Lyd3oD9t86zP/KN0MmYH5kdCxsGU6Yk4A7mppKGA2DOWou8f0dBoa
X-Received: by 2002:a05:7022:6627:b0:128:bae0:e043 with SMTP id
 a92af1059eb24-13504943020mr671741c88.31.1778799719313; Thu, 14 May 2026
 16:01:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260511200136.3201646-1-elver@google.com> <20260511200136.3201646-2-elver@google.com>
 <20260514092246.12b7d1ee@pumpkin>
In-Reply-To: <20260514092246.12b7d1ee@pumpkin>
From: Marco Elver <elver@google.com>
Date: Fri, 15 May 2026 01:01:21 +0200
X-Gm-Features: AVHnY4L7Nz8QfeqrI3wCl3GtxJUpEhFvuQuDcZR7x-mFmRFeRPBj-Sj8PlxOnt0
Message-ID: <CANpmjNP96_pOrH1SPTL105e9ObXY2q7V8KwFM3sKqvX9ZWYH9w@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] slab: improve KMALLOC_PARTITION_RANDOM randomness
To: David Laight <david.laight.linux@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Gustavo A. R. Silva" <gustavoars@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Bill Wendling <morbo@google.com>, 
	David Hildenbrand <david@kernel.org>, David Rientjes <rientjes@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Justin Stitt <justinstitt@google.com>, KP Singh <kpsingh@kernel.org>, Kees Cook <kees@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Matteo Rizzo <matteorizzo@google.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, linux-hardening@vger.kernel.org, 
	Nicolas Schier <nsc@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Alexander Potapenko <glider@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kasan-dev@googlegroups.com, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 66931140022
X-Rspam-User: 
X-Stat-Signature: bdog795hakdcahjp5y3c31yuii8xebka
X-HE-Tag: 1778799721-744353
X-HE-Meta: U2FsdGVkX1/rbfEnf+xnMOe2bKVxxAkGuKLOwGNpvn5nEshLl3m0tW7rVBBYZ5xZUyN4vt6exOa6qJih7+Jfx7OdNvVKvGSj0rQA2zS5Cw0CzVeBVaZqPOPhfPnyNJKl4XG2KL4n7ACEHX0xG7xFsdm3+90oGXp3pfgnFujYOAeZWLmVqFiD1jb8t/E/AEBZTkAkZ9VlN+9MQcH7Cy8Bd5T2qAByuQN25O0/3XhpY3iIAdbPwOWLrlD/tZtDyev8+3kTVddAPNyGXnOyDIjRZuv4Aqyz0QpXaLbTJTa3IMTxqTC3n7BLZsgEA/rBSRF/sM5qHOw5DCMk4F4MX9A38pDgctTHQlgQoTSr/MHaaU7TfTGtJc3Ad9hQ9Wglwk/XrTmGjS7ptLmLkXHWeQWCYhgwm3nG4Dohu+NHhxpdQYeQu+8ongucF/cEnrqUqeBja+nVoiWiyibGLU5MgpHgKlDF6AhKdYlxIUfk3Fs+PVdbIZr22KXoHEWweXsyad7JEm5UdUPZ0/A8W9HRfVav6zvN3enNGcOovedY76dstZBi8wMd3N0WKPA1wEjJWFZfOA6cEPoJnANwD5ky3qBf6fWh9QQgUXxMkyDjXIoOZEeN2kHXmpQjiQEIBql/0wd4QuNPKYukE9xDNiaD2h4D7k3ksGXDY95pzHrRqgGF7wMBwXdKMQh0TR/ZEgCltdeOff71q74pptqP74bl3JeF2RNj1mt7+/GSYs8lGpkIsKvIppsvM3Hm0tySc26vEecnQsw6xdxnPPbeOEXRfDGlnmO8e+LL7RVFkVxzF6dl11/2+MhlRaiZVouEvdmRYl0nGgsLRm35FBfaLZlwS3ELP1bxjup4EKN14muoMMN0edyaJA1IWMZmUx5JN7KkzpGAaghojAeFvqr4UcYetWFHke/RoxXOTtyeXEUek1oXip/JJmvtLTgHvD9+IQ/GkDL7tarkngx6yYZzWR51BAD
 bLNmID/w
 /P7NcHQ5zu/9pFhlE6CP+gJscCHcOHR1qEjCmYtgEmp6wFbsKM33qWc/rPhwJto9p+ed5XIdEDYnFn1ndyKHU2CEhDxqZkBtdnNf6Qm9DrTDFGGSjateh0NXm6TDkFmvXzN7ordTbz7R6Mgofxe/VZbpa0eAH+4AkwPSUtDeb7AlRb+KjuJTmXjqvQiFb4nvPBJdHK1CFdIg4fbjI96mGe7HZiM3aF+P8aO9lBBycLf7vKrSSa8+8ZgA4L2kOR3rJfkKn3KYstnwQSNDjTHkA/6moaoY4CuhkMjECmi0MRt2s1E+yqW2fsBum0zXXrYoqtZJONLfm0ClPto129QuqxFiTY4lByXzZqKCd5nMxmzTGlNzvrpTvKe9X2T4fzUch4Addae9iTf5WaRNLsWKnsfWexhXOqH2BEzg31RYJOv51914=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 May 2026 at 10:22, David Laight <david.laight.linux@gmail.com> wrote:
>
> On Mon, 11 May 2026 22:00:49 +0200
> Marco Elver <elver@google.com> wrote:
>
> > When using CONFIG_KMALLOC_PARTITION_RANDOM, _RET_IP_ was previously used
> > to identify the allocation site. _RET_IP_, however, evaluates to the
> > caller's parent's instruction pointer rather than the actual allocation
> > site; this would lead to collisions where a function performs multiple
> > allocations.
> >
> > With the generalization to kmalloc_token_t, we now generate the token at
> > the outermost macro, and using _THIS_IP_ would fix this for all cases.
> >
> > Unfortunately, the generic implementation of _THIS_IP_ relies on taking
> > the address of a local label, which is considered broken by both GCC [1]
> > and Clang [2] because label addresses are only expected to be used with
> > computed gotos. While the generic version more or less works today, it
> > is known to be brittle. For example, Clang -O2 always returns 1 when
> > this function is inlined:
> >
> >         static inline unsigned long get_ip(void)
> >         { return ({ __label__ __here; __here: (unsigned long)&&__here; }); }
> >
> > To provide a reliable unique identifier without breaking architectures
> > relying on the generic _THIS_IP_, introduce _CODE_LOCATION_: it resolves
> > to _THIS_IP_ where architectures provide a safe implementation, and
> > falls back to a zero-cost static marker where _THIS_IP_ is broken.
>
> Doesn't that mean that all the other uses of _THIS_IP_ (which seem to mostly
> be tracking lock requests) are basically broken on everything except x86-64.

It seems to mostly work, but yeah, it's probably broken in some places.

> Would it be better to actually fit that?
> It isn't as though it is hard asm, you just need to look at how gcc generates
> PIC references to static data.

Yeah, I have patches waiting to be sent - I sent one for arm64:
https://lore.kernel.org/all/20260511201711.3249121-2-elver@google.com/

The rest of my patches are to-be-sent, when I get around to testing -
which I didn't yet for most of them since setting up test environments
for all of them is a PITA. Though I can send and let arch maintainers
review them - this would be the tentative list:
https://git.kernel.org/pub/scm/linux/kernel/git/melver/linux.git/log/?h=alloc-token

