Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430BDCA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 19:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2B58E0067; Mon, 25 Aug 2025 15:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BAC08E0038; Mon, 25 Aug 2025 15:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F78D8E0067; Mon, 25 Aug 2025 15:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60D268E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 15:06:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EACA4B9CAA
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 19:06:36 +0000 (UTC)
X-FDA: 83816211192.12.F303B14
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8894F80009
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 19:06:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b9RaYaIb;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756148795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJCy6pMSth5ID8mVL8dsxoueMmqHKyc8szHkL4OXcuI=;
	b=c6mdL3trcf6bleCkJtUFU9hp2W00n0/ouSDUH8uqoYbRXaW9E0ALfugIU6B+I6v5uuP1dt
	eZuqSyKASVicbp7lGQN6XvPGf7R1ZvPLRINr0eR0N+RzYf5XA2S09zhaWO5KEC/lsAqbtS
	2VeAhPwea1rvH3U+QnLTOvjCQBiZv4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756148795; a=rsa-sha256;
	cv=none;
	b=s3ZQV3SjNfH41AvdLmdYqhugZ/w4F2c7VlzqeefynYLkBf94ENxGL3Ql8HaQC6WBevRh2V
	8L+eOBbqQIdtnyDrMG2u/0rCBlb6RvJ8SG9I69FUEfr+NbxMF++bNmfoVpHoqB0niX3CcP
	Vr6H/kPIq2XrsReG7RE/CXa6oAMB1qE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=b9RaYaIb;
	spf=pass (imf02.hostedemail.com: domain of sunjunchao@bytedance.com designates 209.85.219.181 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e952a2d1813so2205073276.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756148793; x=1756753593; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJCy6pMSth5ID8mVL8dsxoueMmqHKyc8szHkL4OXcuI=;
        b=b9RaYaIb1HLDjKUo5gXLmkbNRRz55nLPhbhWgROY5iNdY3pDjCUMpvdIwJMqdplhpn
         NBDT90RnxMjVi2huQEz9jFzFhyYeo02BE4iqn55Ut3cSAkefjI88HmbX9Y3sAO9Ga3iO
         B9zzwZzRBOohbNTW8TimNIUdwjmx+CKFO+8aEL4BMhLuzMvbeMuTKqqLQUUyjyQ4rXWh
         kuP53IXxoGD2U5T8X83jE7zyiRWwLXI2HtGy0A5VD4pgSuZGdPfFo01gKQlJ6p4XwAKN
         gx5WDrLXy9XDlMB5JZaJd+x5mogvmbvX8kFHwyL2RYZXSNG2TiSwmLLt8+3IxJ5+c/7d
         D2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756148793; x=1756753593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJCy6pMSth5ID8mVL8dsxoueMmqHKyc8szHkL4OXcuI=;
        b=koHTlQE9bMPWrzjACy5yKEnkg2gj7sbOl48Dcm/qbg0AGU8muEcBw/tWUU+dth6fPO
         5sB+AWevDgSmZ8krVsAHzad0hLVGbn9F4wtMVlp+C+IBLZXZN52tFk17PcHMf6VaryDP
         FklAi4TWCCOs6A/ZRiRrYzVddOf2KVw8jAA9GYzgQvxb2svC6RNSK5lC9tZmogbUjvWt
         L1GPMkzWWdzNwZFfm9+YTTQP8z0sXWn1LT2r+VvtsRSxriUyNELt6S8AVVGIMkhc5i6m
         94rev1aL3Zlo+cZC0mPZ2ZqRL4sNLE5snoZ4Z5s5f2ZcIfIWPzxvRH97hpwxW12d9ZYk
         t7vA==
X-Forwarded-Encrypted: i=1; AJvYcCX4hJYNTh9cN4skE8LbMtVjG/dtew1H+JDMXnpAU0ikeNW3wfWZInFs5TU0vMpKsvpvi4N9XKiN3Q==@kvack.org
X-Gm-Message-State: AOJu0YwR6SvX1fsrsnGvTwT2IXcYqyXIV9r6PIQaPN5dcZagU7v4axp6
	btzEOv8vIOoAZdskCLOqlsJ3p+92N5wlPIjD2zJclq7JWJYRCduaWJQDXZ9gcPqFG66geVTlgyc
	+8wrLKq+E810SVKIr8PPmDFDXCIpZv2QmFpSdn8+wlQ==
X-Gm-Gg: ASbGncuBbVvGhY6vQ+rG5EcV6Kno/IoBIfgZB9QRyWf1tcJOnjAFDgvxYUDUMZRfSDs
	vyBhFiMtveRhDQI6DmX8lGzX3XfJV0EQpVuAl70WrGaTH2pDO4bdhkgsSZaEl6E49LrjN1a91Go
	SKZapcz4VpNnTixXS7AZMch5TsYeJIk22XPoyBD77MGljkA4DsdgSKdbZywkFtYzg7eyWklloGT
	QqPFwwMaPys
X-Google-Smtp-Source: AGHT+IHAgyL1whKyieTbABDi2quj1+wuaVqtUcIrZ53ZFQBjV5RtdnhIK0bQ7dnHbDffx2GPfxlJyS52gocXhCBCiEk=
X-Received: by 2002:a05:6902:3411:b0:e90:6c6c:dc3a with SMTP id
 3f1490d57ef6-e951c33207dmr12818324276.34.1756148793135; Mon, 25 Aug 2025
 12:06:33 -0700 (PDT)
MIME-Version: 1.0
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com> <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org> <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
 <aKds9ZMUTC8VztEt@slm.duckdns.org> <f1ff9656-6633-4a32-ab32-9ee60400b9b0@bytedance.com>
 <aKivUT2fSetErPMJ@slm.duckdns.org> <CAHSKhtc3Y-c5aoycj06V-8WwOeofXt5EHGkr4GLrU9VJt_ckmw@mail.gmail.com>
 <aKyxE6QOR_PtQ0mT@slm.duckdns.org>
In-Reply-To: <aKyxE6QOR_PtQ0mT@slm.duckdns.org>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Tue, 26 Aug 2025 03:06:22 +0800
X-Gm-Features: Ac12FXxwKjce8jxJNNwjCY1pe1qCpWBlapoFKM06--smM3L7BAjrjrvgrdd62yE
Message-ID: <CAHSKhtcdRysJGAUOOXMUdm=dymQ3scJFUQ2nc+ShmXku+SAb0A@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
To: Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8894F80009
X-Stat-Signature: wa8fw4ym7nmz5sy1i879rjtwiydr53xm
X-Rspam-User: 
X-HE-Tag: 1756148794-985378
X-HE-Meta: U2FsdGVkX189ND2+Sye0K+4xmEAcDzT/AyRIqBIpJfBeTBw94M8ki/JgtQIKvJnhZUFdIHTszJAd608ABs775R6V5LyW73Tf0UIDbLqlIzAGBF193uI8/j772ktzvmXWZ6HKV4+rRs1k/fBxzxbpRMeKWVbqF47QN6Xab8MJTrwStcTPQfqHrsWN2eb/h4mhcYSVFBmtgmdqppDeAWJhKvJ0Ay7nLf64TJ+X1bKugvZIgsVuN/0JDSIiHFtXljG06qa51flCx0vf2d3Hv/YmBJkr2OdlLyI2xbrkHqQh6jpSxwK0OPXkhV0dzNnQ4/FhZhdlSaRtYiN0M9fxaJ+roEbX+JOCJFeOybvBCb5orQGDlgnGSQIJZauZZJvTPCkuAQsEb5EoOXjg4kygG7b4Ufj7yW9SrNKVCqejcTMHhu4ROtTUzWw52mh9oVpYOB6oHD43u3C7VkYMK0/UwonWbG2cCyhJPrVadkBrz0AVuLhMFpYseM+Cj+xNGl+qnMRVV53VBPULosPJEdMN351bwP10BdZdHVQzfn2y/7Y6KY2aAUR+EnT1Slo/XNFnk5+yktQ1rGemK0+tEECUmH2+wk5AAcTTz8FoPlV66T/zPbJOZo/t07IoBP4KS4fgw9qMUq5pN7T1BfdXANrc3HOSF+iOUmOJBBLehnh1Mu6MxU0WChPTsyUnaCp7o7mBosmgG+hm7ApqJdQosUAm3PX4IiJVryThjN+hmzbDG4A7J5LVemjEvw332krf8l5Y1P5XW6Uzt1BzUniy7aEhX9FUKQbDL882C55nWQJ6K62PeqO6Am1zBp+2lzBtz1JhUbSS4uCnMJ75otLwn7eLPfkaJhMWLxhU/k2kbrAojBK1d4FY9fJ/BdMwdxLrArTTlYKsQWE7HOBGd5cRGob4K5OSdS+0t6eAuK+ni7UIik14FRBfs3TpAijMQ2inFHtQ9+y1HrIe1qStjLug5gwN3FF
 aBPb4k7W
 qZVXZOz7AYnj3KvriX05fARbbHZuxXPPdug1Qj78X9ui9qKcQsoMkObD+GmQJhg1dMHLc3rTEjiogE/0HEcyldbX0PGUTkLpW5eedUmbAIdzIOHir/F5n0S90rtO118hxf069rP8nueUWMe4EXUsS4qzdhvYzQy1chi0EnHFHYuQo//8j37OWgrmEPg+KIzAOGsTaWIHvvAHW0q6ySsaM+6D94M2UzWzAQt6jUJSshezKxVvjozCMOJiEOMtcRwUjfS1M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Tue, Aug 26, 2025 at 2:53=E2=80=AFAM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Tue, Aug 26, 2025 at 01:45:44AM +0800, Julian Sun wrote:
> ...
> > Sorry for having misunderstood what you meant before. I=E2=80=99m afrai=
d that
> > init_wait_func() cannot work the same way. Because calling
> > init_wait_func() presupposes that we are preparing to wait for an
> > event(like wb_wait_completion()), but waiting for such an event might
> > lead to a hung task.
> >
> > Please correct me if I'm wrong.
>
> Using init_wait_func() does not require someone waiting for it. AFAICS, y=
ou
> should be able to do the same thing that you did - allocating the done
> entries individually and freeing them when the done count reaches zero
> without anyone waiting for it. waitq doesn't really make many assumptions
> about how it's used - when you call wake_up() on it, it just walks the
> queued entries and invoke the callbacks there.

Ah, yeah, this sounds great, many thanks for your clarification.  I=E2=80=
=99ll
send v2 of the patch after testing.
>
> Thanks.
>
> --
> tejun


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

