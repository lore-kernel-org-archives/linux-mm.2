Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57DFE606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7CI7iwW
Received: by kanga.kvack.org (Postfix)
	id 69D1A6B09F9; Thu, 22 Oct 2026 18:20:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B626B09FA; Thu, 22 Oct 2026 18:20:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58DB06B09FB; Thu, 22 Oct 2026 18:20:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 363826B09F9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:20:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A861D16031A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:20:36 +0000 (UTC)
X-FDA: 85351682472.06.0E2EF9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 47AE520008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:20:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7CI7iwW;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792707634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPgAzjNkQiqM+WkpAExnh3Qvvaifknshl6X+/hr43fA=;
	b=WyZ1AZqK2aInmVEZu8/fu4qn3uuwAwfizXSnmvWiwdnEuMjxKxVgk6NqYMZdtsdBTDKzhT
	scVE7UZdJTkuM7LIL2DhpKSKWMwVSoGuV1PaPD+w9/Y32N/mku9pcXY6wRe+P8hkKtmdi1
	8Q2ewIKDnXf9AjIwOHG1EfZXPNsBhak=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7CI7iwW;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792707634;
	b=GShFlRao37HTuhkj1nTsw0dmVrNzsnp5We03unPyeWyVQi723DmlEpkIsIvLsHtKVpxv9t
	O7c3v0xyVBVPsin8pzhvMFZs1+7NzUKjYSRhcjaq1kcYFcgC2B3yh63IlRKhOvO0H3Jl8H
	mUedPjKoHSqgf0X9yaA9QLr+2m5qRME=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5CE7060210
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16A901F01828
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792707634;
	bh=FPgAzjNkQiqM+WkpAExnh3Qvvaifknshl6X+/hr43fA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=U7CI7iwWy/UsWWO4i3RccVaPj+tzN6BNF90oNNKhhno5jxftGJSP0bPFEtpn6rkHu
	 RLrWnxoYMB3eFUIxb0xmTAn2DFpRboRc6wnUn+qFXog0d4qv1b68912bWXkMcJ5/FD
	 Ay3v2pbV4WEKxhGEvZcc8zWdukJzy8+6udHBFW/c3Zmb12ipmiUEEx1IoHhAP5scV9
	 gRl0h5DM1byicpESdI+HtndXbhNswRXtt9Ow0zOAK2UntREH6+W4hHDmXIBKQwb2m9
	 +JPs/fjgnC14iOicZUsZysJePS0MAkmqwXjdq2HdI42ZQkyZnwW4JdH3ww1ch1QVmF
	 VpYanze6gpCtg==
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-9196d8543cbso3707366d6.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:20:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy4oNcietIruMYTSlrEMr5V93C89rLRuqkPwECWyRH7Bk5ael+HPNQAyXBXIQRf8ZoaPrVdBoB7BQ==@kvack.org
X-Gm-Message-State: AFq9FYIHF3OFQKqpf0b94ttCCmzSq1MAiJhj5uVFXvvMFfHmVkjByxTO
	5oYUgfIQWuwEGI5vctWLlp9gPX+VLpRqRnizJae0JxzKn8wfvNCZpKYzSv796kvRBebMqDkcyyB
	fEktFo/K/LCkTMKW/YUa0f60GlZDJD3w=
X-Received: by 2002:a05:620a:6848:b0:93e:e394:78df with SMTP id
 af79cd13be357-93f6f879ee3mr154580885a.58.1792707633528; Thu, 22 Oct 2026
 15:20:33 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261015080157.269079-1-hui.zhu@linux.dev> <CAMgjq7C+EXJBdLUh-JxLGkZHb6wiuvLsq85V7ph6+gPND6mq2g@mail.gmail.com>
 <94afeb74-44cc-4e02-97dc-961309a12364@linux.dev>
In-Reply-To: <94afeb74-44cc-4e02-97dc-961309a12364@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 23 Oct 2026 06:20:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yXe0hEG7pUhddas+ex6QmA1A6u_P04UKYF8mPxrW31xA@mail.gmail.com>
X-Gm-Features: AclHuK9qP1mgPJEEaUrfuuFK_eh9pkbInHEkTI7TgyHOfXSR0gKxedCumCxDQdU
Message-ID: <CAGsJ_4yXe0hEG7pUhddas+ex6QmA1A6u_P04UKYF8mPxrW31xA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v7] mm/vmscan: throttle MGLRU eviction when
 isolated folios pile up
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Kairui Song <ryncsn@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 47AE520008
X-Stat-Signature: 4ytxo814o69qjot6sryeaj4et534rwk8
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792707635-343551
X-HE-Meta: U2FsdGVkX1+GP58mLbQ6Rr9/2b40n1uzQ915RVVGYaumeBbTSJbTsHfnZAJ42wX0Eb+KMPOAZZQIRW4oeR/hai1vbeXAA1UWvADGTM2kWtfUj4UWf/pnyTbGQUSFvhbpVoVwPu6Vo3dvMaY4B1uxIfyBdEsBg02/7jh9C7q0Zdk17wWo+6y4f+oJT2Y+Mgo2GAzl8Eb2+yFFYp0WCpqqkwpVrkPvcOaZSdTFURRri+RovO/QEFSzWw5Ds/zBMdheR+lTIwl7Xtn6PI+jxPg3bl7gc9pr/+NK52bR0P8j0xKmUZJ4ekA/fZUjN2mocpjblPeuTLEAohfEbFlGIO52KAR+WeVGbLmQuOjwuXces4rhUs44ZFHxH5Mmjm6zQb55fYuBbkpoKp2CIEsX1bwnz0Vv8Adto8N8wxc1msQ2kayaVoe1S/zXZJf7zfYCR1vesRVcU4+VpfSCyEkfA4oLCIXlBv0sYTExqpAVuLreGur/h8EjmiuXxcxfTyujVHtR0f8K+hpPRsbcT8ExLhw4tI8G3+DAesQL2IcWbUgRG7fahnILx9MX2jHbGp9OIFrNGRIKTZKFe31/GWvGi6355syxQavZ+0sCf6w6PMW3tkAKVwpYo+ZYC2KVrZOwFTcJ7toHo1eWVHCxa825RYu8WdqxrU7ZGKw/BubFh+p+PGvF+xmYMqf+FDGiovhIJ1PDjizsiu/8mptYAhzos0X07h9J1KDTicVkz9LLBejcexT3/fr+SoCRWDgO7nok3V8uqEXC1hUrPAhUdQVPmpcZTzeOJU3+TzFb5XenTvUNSZY4UB4yUiSf+iUlsqoCy6Qg9uftvN6X9qS0LADQ26cc1TBxK0v3CGBS0fm7c1PhDd6Bpr2BC/6xIajVG9EwchMbtVdAX4a66fttQ5KC57vVBdXbHbkJw2E7BO5AlfzkCQ4RAgRXxjfRz3mjT16bv2lQyrqbh8FeJat+LUI77T5
 rXFZEk3H
 iwXnFywT96z/Kw3LPeBy+ou6a2FD81O6PzurRZhi2l/hEIKBqe4La4+oVbU6v9dOz+UkFbXnB0BkR/p7ab/DEUbbIfrUJ8mNe32ixRHUwIxDQ7bm7dkqBGK6hWyv7Ym8MsgN0gtRNIJ78NpheIrqwgboKmr4SEc6hy8HJ+//Wh8BFlsIlzmCN/Hf63l4Hnb9ivl6tg/Kjx8XZAp6NeyyzvpH+3ryBdHRtnumiwzBaVolru1i5CntOmiwnVYdkzv83c/aVbkvgvqt5G31rGzPzJHKVLwyDCqUYdHOAA560W4cf5hW9Kfu3vtZ3Hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 5:29=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
[...]
> >
> > It seems a lot of trouble is caused by the design of the reclaim loop,
> > so will it work better if we calculate the number & type to reclaim
> > first like CLRU?
> >
> > There is a demonstration from Barry:
> > https://git.kernel.org/pub/scm/linux/kernel/git/baohua/linux.git/log/?h=
=3Dkairui_scanbalance_0.3
> >
> > And instead of throttle at the reclaim loop, balance the scan budge
> > based on (size - isolation) number, and throttle a while LRU simply
> > when the total isolated number is larger than total size /
> > MIN_NR_GENS.
> >
> > Just an idea for reference, seems could help get rid of a lot of comple=
x logic.
>
> Hi Kairui,
>
> Thanks for the pointer. I had a rough look at kairui_scanbalance_0.3 and
> I am quite interested in it.
>
> I think that branch still needs an over-isolation guard. The scan budget
> answers "which type and how much", but it is computed once per
> try_to_shrink_lruvec() and does not see what other reclaimers are
> holding. Each reclaimer's in-flight isolation is bounded by the batch
> size rather than by the budget, so N reclaimers entering together all
> see the same state and all proceed.
>
> On the other hand, that branch would also make the guard much simpler
> and clearer. Since evict_folios() already takes the type from its
> caller, the allowed mask, the type rewrite and the fallback restriction
> in isolate_folios() all go away, and the throttle reduces to a single
> check on the totals in the shrink loop, which is basically the second
> half of what you suggested.
>
> So I would like to ask what the development plan for this branch is,
> and whether you think it is worth moving the MGLRU too_many_isolated()
> work over to it.

FYI, here is the RFC:

https://lore.kernel.org/linux-mm/20261022220203.91911-1-baohua@kernel.org/

Best Regards
Barry

