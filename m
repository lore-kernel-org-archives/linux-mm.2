Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21F35CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:35:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F7FF8E0008; Wed, 15 Oct 2025 03:35:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C88D8E0002; Wed, 15 Oct 2025 03:35:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705C48E0008; Wed, 15 Oct 2025 03:35:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60AE08E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:35:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 049665CAA3
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:35:14 +0000 (UTC)
X-FDA: 83999537790.28.583D7A6
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2C34D4000C
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:35:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWStJk3f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513713; a=rsa-sha256;
	cv=none;
	b=u/cxDK4WHV6BUzu0a97L3eA0jOzWX5gQMmCnwNcD40B+ljtYTqp4Frzdx+CbdBuswOHvca
	dp3tyWMlA3gMPnmsvLMga4ycQd7WJUzM2rzd5lsrqTjRT9IbKI0SgvPk29s1p9AdQHNQqq
	hxLgeOCz6893TxSGemYiWFlN5y2BMg8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWStJk3f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BA3o1cHbuC0FFSVH6LGwTjiyg5Fjt24vDKqsTK1XeKk=;
	b=C+ayEc0V+8+pfVznRaSq/O4EeAaudhlFRgOB3oZhioLzgHCZsWj2AxvKzeKsxojw8BRlvG
	8SzN4Tfsch8ukXCUDM38EruHU+heRw0pGJYhRukq08K2KRgrmUEcb9LDU4c8NZ1442L8N2
	lCG1w1I6XExCjFbd+2sivS/2OoGMj28=
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-88e32ad012cso59638385a.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 00:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760513712; x=1761118512; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BA3o1cHbuC0FFSVH6LGwTjiyg5Fjt24vDKqsTK1XeKk=;
        b=ZWStJk3fSG6i+SW4MEQvL0+zXOhTnp0w1pzAc+kmoz4N2G5DUOM1C4AQrj6Smk2LHa
         VnEQ+pNFafFYOgFwPMj8MO4R5cicS4v8WaPpcGIzHqUhFiAu/+eeg/7wnxEf9cfjsRQ0
         4CP6Eruy5N/KbV4er/ppMN4c15u3Ultx8imeS1FCb93+in/PnYCATgvBnR5mXAS/hVqn
         6RJQTY/qpXGzzCtLEi7QrnIWTXXC4VlQkjppdwX7V8lJOwOEyrWIEF+5S7kUZBC9CWld
         rg1r5+NwaErAWGLHiBJSJmR480jjDnJNj3FRT3hXM2ZYRNomoX/D44MD83W0ZFDrngGE
         AWTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760513712; x=1761118512;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BA3o1cHbuC0FFSVH6LGwTjiyg5Fjt24vDKqsTK1XeKk=;
        b=osa00oy8L2DkqXjU+InTbvINUZV11np4/xacMsm3Y+YwjITflUIe4QJOzu5aCQgmCy
         k6SSda/4H/klWOb0QDiSL10NmiU4uXGeYmeDawZiCk/ZupIr46S6A/ZRfW5Iu+xh8ZUz
         jPaYvec8iNOFUH5RdQgmYSznZe821LUrQ52fqfmQQN1tooL6FYAeEAPmOcwoxPCRj/6n
         +yD5KsA7i9XD7YnWAkiDQwI14r2ae1kjPrY9uc+cB0PaaiRzxqEDUWRB0uMP0F2PdZLI
         3M51/QWDTezcjfuNTNRA09wBEt7uuSn71gzbaE30W1VeEBdSnLiCaEE9XiaGUGwb7xqd
         cyNA==
X-Forwarded-Encrypted: i=1; AJvYcCUEIuk32MRazgSBNMzpu0bmgl0IALoViKB1uzDCmo2UGLt1UYwmFOdNA1UorabIbs+kJC3dTYNSEw==@kvack.org
X-Gm-Message-State: AOJu0Yyyw3rfYdW8KYcDa+bpv6/oq31Rm7N5c+oT+sMV7uoWrlPibwia
	t5/7R42VNFLq90u1aWnlJXG7HizMf/7c/MHUbNIOP6q+KZVTHkmQrilwhPIZIl2AaaTfbX8klv9
	3pUr4G+YkQiplhF3GlTkqTiGwuO6uB3A=
X-Gm-Gg: ASbGnctm3dk6gM84H0v059Qtphv7xV2weC+GsLHkJgvgGwU59aBwrnauEoBkwnWJWAA
	V3Jj8p3F5Kz6Asu9KVdief8T+b6NDjEhqm9Z1hAUA63MMMNLSE9RJ1mYfpE6veyqHEw6+aP0JCN
	l1SayEvNNas/iTpx+bTQ7OFsU8vqxTsQLHXfO3heNs+KoDe0poaQ3IlqGNU3t9CJhRXbHqG8lEv
	CDIfv6MdyTZL9O400wIkuMTc0Jj8FKP3vLWu/lXzyrO1t45mhXh46ZCfpt4mhLUSnNY
X-Google-Smtp-Source: AGHT+IEKuviABuf8paTr2eaaeUlS/nUOTJ25Ra9gag22Alb6I0Md3LX7r3aaI+eo4s+XoFak3t65ds9W83VxSzBmJiE=
X-Received: by 2002:a05:620a:f13:b0:812:c6e3:6663 with SMTP id
 af79cd13be357-88350c678bdmr3682430585a.34.1760513711989; Wed, 15 Oct 2025
 00:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
 <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
 <CANn89iKC_y6Fae9E5ETOE46y-RCqD6cLHnp=7GynL_=sh3noKg@mail.gmail.com>
 <CAGsJ_4x5v=M0=jYGOqy1rHL9aVg-76OgiE0qQMdEu70FhZcmUg@mail.gmail.com> <CANn89iJYaNZ+fkKosRVx+8i17HJAB4th645ySMWQEAo6WoCg3w@mail.gmail.com>
In-Reply-To: <CANn89iJYaNZ+fkKosRVx+8i17HJAB4th645ySMWQEAo6WoCg3w@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 15 Oct 2025 15:35:00 +0800
X-Gm-Features: AS18NWAHXtYVOjzGMsZVpeCyed9cBDk9Qc-GpblFolpgSoSOaZV2-smc5Nm5TAA
Message-ID: <CAGsJ_4wYrQuhGY6FuZJzQJjQfx6udRAbP4XZvEevknrpqnkv8g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Eric Dumazet <edumazet@google.com>
Cc: Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zxzwnpch9y9a847y9iizxa8tqt6tuyji
X-Rspamd-Queue-Id: 2C34D4000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760513712-123806
X-HE-Meta: U2FsdGVkX1/HnOtdbRqLM/ZCGUJ6lIDgOpYsfvAaK84B2Wm+ERqnoGn9T+qFbb/MTu5dr9wzTFCGuNYEwTawxATGB43lZUfqBALoLE68Iu731gI64KV2+k34VEw0Ez8xUuYTJVkfHLG1Zbhco30yyHtetYwtliewywazRoDg/6X5zc/vqCEeTWPUMavrxVcsctRds3tCR/CIBhJ5EyZM8Ms7L69+oR+4sJ/PyJSSuxS/Mm6eizX661KLQenwZ1h/zhMrrMX1A+t5JNOAQlIbkCSHPTgqCD9r2MGCOt7vDzrSEgoffsDBWE1h3u47sQGQXhirPh7fR2r5dPbca0rvmkx/AXGiecZs5ObsoEHXE6JXibRHLZVhGHQQNp4HV5gQs17aj88o06FnFKGJG9Z7S4Yd7bGf+4vYUpYWvp/mfyW9yHrORjmm8l5s2bDc+bX3hoHG1Ur2Z9XZ/OOyJQbNW5fn6j7FjFzMaLR50oR0l6D5tslfxlkE6oS8NP/jHhAz0pLKhAD/S6q7LZwi9CU0mP2C/InSetwybh75/VGQMFhqHzWomo++3fVoVNgx2su8NMpVxYd9BafLIi/Eucny2evbJWgfuP0DbIOnjaPh8iCqLankJMCotFJs2F/oa6+4I0X2jd2EaoDSXmL2FUNoSMfzddkvzHzUVVsmRkLr1Ya14jKAKkzIMDGRvlM28O8WU6T+0zjLRU2qcP19aekVVg7Ag7UXAOq9VvATg6rGppeLd3+2nFHOYH3aj8Uoj6N1nPw+ywSbghMi4Jv/a/6RcaZSJ0GUk8S/1sH1h5tYLcas6fGpJGEa04/1ckP1tRo9zeyxni6cONhE1DznBO6yLJN43Thw0Ugz6JsHJJmECW26Lu+Yy73470lY4D/Qhu3W0KLGPqJC1AWnH532rX4ezmBcgrSloV3IuVlffbtMK7QLSJLNu2GNHJZ9Z/O6kggNpYrP0foDV3C5k/MRCkM
 zg9aoXlT
 u6siis0bzT71YAHHkoexKcMocBM3RSXAkGE4UfLXncKGupZ4tMHPKqc6+2fWnbS9ZAXvyWKOnZg9GueK+uP0CUsaoScmk7BizYvbYw4v6cTKzaeOp8u78XZ4pPIY5eJZgP5AQLvCX4FTd8SfzR//R8aYYwcomNSzrDjvxRLNR+VH1EOClZV9l8g9LUhwBFHyHD2TWXYLXumaThCDQOIqh7/0UjVYx4KykQK0JGydzYd/AavOH6gwlXUNLWa9YeOFhjccn4YR69SCeObL0xnp0HOTD8hNUaYHDH+Ty4BVJQSvYfjT9DcmczTKnha+bHapD78CU8XocEl+qS/RRi0wbXLl3kRn1K9JxnvfxaLHSFd94Lq/n6QFrPxtiHVwj0tvEw1uS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 2:39=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:

> > >
> > > Tell them they are wrong.
> >
> > Well, we checked Qualcomm and MTK, and it seems both set these values
> > relatively high. In other words, all the AOSP products we examined also
> > use high values for these settings. Nobody is using tcp_wmem[0]=3D4096.
> >
>
> The (fine and safe) default should be PAGE_SIZE.
>
> Perhaps they are dealing with systems with PAGE_SIZE=3D65536, but then
> the skb_page_frag_refill() would be a non issue there, because it would
> only allocate order-0 pages.

I am 100% sure that all of them handle PAGE_SIZE=3D4096. Google is working =
on
16KB page size for Android, but it is not ready yet(Please correct me
if 16KB has been
ready, Suren).

>
> > We=E2=80=99ll need some time to understand why these are configured thi=
s way in
> > AOSP hardware.
> >
> > >
> > > >
> > > > It might be worth exploring these settings further, but I can=E2=80=
=99t quite see
> > > > their connection to high-order allocations, since high-order alloca=
tions are
> > > > kernel macros.
> > > >
> > > > #define SKB_FRAG_PAGE_ORDER     get_order(32768)
> > > > #define PAGE_FRAG_CACHE_MAX_SIZE        __ALIGN_MASK(32768, ~PAGE_M=
ASK)
> > > > #define PAGE_FRAG_CACHE_MAX_ORDER       get_order(PAGE_FRAG_CACHE_M=
AX_SIZE)
> > > >
> > > > Is there anything I=E2=80=99m missing?
> > >
> > > What is your question exactly ? You read these macros just fine. What
> > > is your point ?
> >
> > My question is whether these settings influence how often high-order
> > allocations occur. In other words, would lowering these values make
> > high-order allocations less frequent? If so, why?
>
> Because almost all of the buffers stored in TCP write queues are using
> order-3 pages
> on arches with 4K pages.
>
> I am a bit confused because you posted a patch changing skb_page_frag_ref=
ill()
> without realizing its first user is TCP.
>
> Look for sk_page_frag_refill() in tcp_sendmsg_locked()

Sure. Let me review the code further. The problem was observed on the MM
side, causing over-reclamation and phone heating, while the source of the
allocations lies in network activity. I am not a network expert and may be
missing many network details, so I am raising this RFC to both lists to see
if the network and MM folks can discuss together to find a solution.

As you can see, the discussion has absolutely forked into two branches. :-)

Thanks
Barry

