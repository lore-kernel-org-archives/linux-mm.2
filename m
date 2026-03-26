Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9E0510AB819
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 20:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B64E6B0005; Thu, 26 Mar 2026 16:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267B26B0089; Thu, 26 Mar 2026 16:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 155C56B008A; Thu, 26 Mar 2026 16:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 040796B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:02:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9DC3BDB4B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:02:43 +0000 (UTC)
X-FDA: 84589287006.12.C7DD296
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 942F914000F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:02:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WoJ/vdxI";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774555361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcCJsLGawkrffaMXgThFopnLf3sG41HR7iXKRErTNqU=;
	b=dQHs2UZz7JNm44h9kVYShnRwmx88uUZu2fqmAhJlLaF1VcSXrqc/IuuYDSXCFmh4+Wk2tR
	mWMElWd3HQQ+zuedkh1qgbsJY+rRSJgEXrUFFt4DO7HRCgBQiN0s2QT1KHXdA5QwBuFsfK
	+Xa17LVknnxqn3eI4kgMEKDtc9YAmI0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774555361; a=rsa-sha256;
	cv=pass;
	b=V8rMrKYXmpMTqZDaeHHRLwxnftmvMaVAJCPvYH5hgWTcFetzCyzOgYaGEtyjwqBBb6SS31
	cDv0l1iJdxpOwIwo0xIvuJfLPlujd8k4/5NK3Mi/jN3mTIeDDZXoPPCqHlAEOTttyAlva4
	nWt7uD9T9b5gbokQ3bHmhme8AdzABQs=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="WoJ/vdxI";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6628cc1bd69so645a12.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:02:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774555360; cv=none;
        d=google.com; s=arc-20240605;
        b=WT1UmjIl74VWdTkJ7hayOCVZ4oZ1/QOofZgl7A2IFffpV/9YDH+5UxDGwlBFUqMVzO
         /Sw8b/nptnP2at8vNDBz9V+JWb26KusOVtnHm/oj2tS6m27d1pRzxuWqrSx4m1JUGZVO
         TMRVDXbq7Rz6iuCiabcXANSqAL7BMr1SL7FXwcB2Jp/E1mS+m+JFXSDbAthLkTmBIxzP
         dkYf+M8TMCsdqpVAXJf1RGQppH/+YoE5bcTaeRf8pat/W5tGRLCOsoKpFQd025dP7RU3
         Y6MbwXW/ekgxyHzTkPUBS4NJzApFy26fN1v2ok1yfXS5rYEvdA2GuUasd8dStDspCnxT
         M9VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YcCJsLGawkrffaMXgThFopnLf3sG41HR7iXKRErTNqU=;
        fh=W0dkw4FZb9J2N0mteCZGPNWZyQuCLATiW3J68UQTml8=;
        b=EAWzDj8hb6TiYFxJymfa56SyH/BQ+jnJxrL37QkgLdtPt0IAlLk5ojfWpsyfRTQQuh
         jaK4k6/E4R78UjOZjzWM7CytOFdbvAnrKTPFVLBdMQQV95KdUdrzyzbqoNf44IeF2gPj
         JEyJOtRt/IEtE3bU9sxlxNZjlCnAVBiSJ/pGDvFRNXoxaAkti/YCcP9FS/wQdbBqOjmB
         rMk9clbTlkNnVFz+8dU/rux8z/BUZqONceBJv/BArXzuJ97U2KFc/4CH5efm4vU3sFCL
         /2VkQn5WV9u2DalWoGJgBAnvosTMLN0pgnOISGasZemA5ExalGTLTwgferA+8I0lL2TT
         dg3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774555360; x=1775160160; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YcCJsLGawkrffaMXgThFopnLf3sG41HR7iXKRErTNqU=;
        b=WoJ/vdxInCFej3MT2IuLrQyC9525ehNH0BLLcrlgNjerFNQdNWctxw+cguGqOV223w
         CsppJgWlygHpPRt1WV5aM9BmbndqWx0B/J1l8hbuG5PiEpRaN+vUheosLV8BwZ6J7c4x
         KTTQSRQFMDqYOcKWGqt0pjFgOuII39sUeIb/IWr5EiKuEgwZOQhz50/As8/2ftLVrEgW
         CNlcHEYN1L+uZN5N1kcskCGJ0nind8co616n8abFq9wWuRLJb/+LL3o/kYvXZZg+gB7V
         S6V5BXFNIFjnPIFcUXZr0GpD6S6R0b2Mq8Nd2oVsGyJWHchzs3IUIrjX02ig11yF0aXc
         ALvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774555360; x=1775160160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YcCJsLGawkrffaMXgThFopnLf3sG41HR7iXKRErTNqU=;
        b=f392ABUTDQJ8dB8OfysWaTZ3m4RV7YR2mzPpY3r8p4Ro3GyKLRT4z9wNZ7aNitbT+3
         bsqFaWSWCb0IxMWZbViRCzgCJHlwAXbljeWoxyghGzp47N3lXJMqGegNWGv08eshTz+r
         hgYgelz/giabLLggkl4g0g47xLRaBrA3VqVZv2/jZgJ2n7oePL5sD+qSWcAgGqdp0knd
         SPQtQA1AN/MVlHH8RV5qyES+b7940LeT/534fDBp1TmnBqj26N6xmjUdnVUadgy3YNrw
         5sqpVymfElil+m/ihdo/zaD320jXfLVX1FJ3Q40wV+UozfYJlkPb787FQFK6zU7VxKPt
         93cQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUnys4yrnHUFYul6rzV9tmY1ttJnbOFp13tUSaM5ims7hxkWh/KmKxb4REHLZrS+saZnOLbdXc3w==@kvack.org
X-Gm-Message-State: AOJu0Yzgrk0uPH7v7FyFjAR4KYBZdjWvG/6QyWk88fm6ts5t/s9Bq8sC
	ndXTsRqt5o3ewduqtnOI5PGBe4M4CLa9IjovZmeNDWlv2opu+3gDZ/DBxvC1Eta1y35SJ+stInt
	E73ApQg9gQxer23MCtSsdKmpjzzwT6ZPcxt/S8STE
X-Gm-Gg: ATEYQzzF7b7+CsqEgwixWf+2lhz+vQa40esC5vBDZUAl5uAtmH/crEV0ENiZ6sFrBqs
	CEFNRPrOG1XHUb+xjaWrSHle8ZxAWDAdLZOiU4M+E5L2DXNO0shUMewlXtLmUpKs5NbJbV7eqa5
	JKq1jZXGLtnoBa7tOtM/2cdI7FxHFA2WaKff0rkoSQnQLGW+KPJxlItYoiw68shaLTWDuzqca7b
	Mrn7q/H4x6p7gy3I1U01qJR2gyQjiqRjgo8+bQ2d4Z7+Y8rY+QitL1jA02FGn2mKkftGJEeaZyI
	vFZPKdZNOITFPdl3HBcfUeDl0f21cBMDupPUMedIBhDURp0=
X-Received: by 2002:aa7:d51a:0:b0:660:b029:3d4c with SMTP id
 4fb4d7f45d1cf-66b19d0164emr13748a12.2.1774555359373; Thu, 26 Mar 2026
 13:02:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka> <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
In-Reply-To: <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Thu, 26 Mar 2026 13:02:02 -0700
X-Gm-Features: AQROBzDWo0U0wUaqkKSuyqmT4EN_BjNNpF8nBBEpcH6xGqdHAo0H0pRxhZHomSQ
Message-ID: <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim (reclaim_ext)
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, lsf-pc@lists.linux-foundation.org, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kairui Song <ryncsn@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>, 
	Gregory Price <gourry@gourry.net>, Barry Song <21cnbao@gmail.com>, 
	David Stevens <stevensd@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
	David Rientjes <rientjes@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	wangzicheng <wangzicheng@honor.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Suren Baghdasaryan <surenb@google.com>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 464f1r6douyanon8cdf38h8pxi9ybnmd
X-Rspamd-Queue-Id: 942F914000F
X-Rspam-User: 
X-HE-Tag: 1774555361-675732
X-HE-Meta: U2FsdGVkX1+9/VMBTCdDd3JVAqnKcFED9yqFY0JRo84anTKf8uKiGXTUMN/nZB1Br0nR0WcR8mcxRknaZYiT7FpDKCgcC6C1STvbeDp3anXmsqbpob/ictSB7OlWe8fPE8089mzqSJsMnZpEXiLUj21LE/c47CtGV+KYIErbSDXxIyEHuNQAtb6m9rXZ8JolkLPWH44HSo9npg8O+r8Va5tl1peV0NB7unEHGnp8gfrUZ3FVAW06ccND4CbXoWq8V7mf/cozCfWIEDv51kAnaSZO8zTZOeiww4wfGrxMYXYqiTbBoHD7LpdSMtbSssKNmHlkmNea6VbJDdzUk1HWYUQ7lnohhj6rOyIF+5uqDvQ9479rzNS4CRYYT4fVb5WXwifi0OV9Bwl6ja2khi2iflyeMUBUjhm4O0cWBF4+3kb9Nl08s8dclJJ/IHFMmJyx3DeWrG01G2e6xTrfJTFUeSar02wSuZvT2AJnp0tWryJw7YsJiR8rBnZbc8fggygbHDZzuWWoaJiFgN20UykW5Y6HUkLktlRzQnOMzUbyzYCYsJuTJfI3scQOkT8eaX0VP80gG4Ev7mU32wUiDTjJjvVcuqmofYzod4qfp0o2NmmbPovWApG5OPN6VWgW2BlaPNPUYwLuCABU9u3kpyQUZWwNuQCYKyXWN4S3NtMhANk0NOBVt+oam44lHxd5sQsiIj7nd1fLIvFnw1it4D9yS51fRl6l1gNaUgjhgSR7rsxW5IyxR4pQsT+BbO3QReGYfiDqSh8UuXAZbt8mMCPKKKowAwu52gConOdrBBH2RWa6DxZpfVfI/fCb9PyYYh5s+Q0vJsNZf9srK1jrs1aKgxyoqgk8+t+fie1bE2E+kMz0m2cGDlTVXhgVzfI8NIF7a77slMIEhPg71moaEzqCg/OoQhKjIPLSBn8gUlKx6Kn3DVgKOm1d6vvhnPBcN+5VqAVHfcwDDbM+Yc4wwZp
 ujNsECFJ
 lAvzcO7DYx/uRYgSylssfrKwHnDdMzDYCDJX1VM1Zmfe0fsRfvpe62HmzAJDSoJxLtShtrotMZ2GjF4hrisD+eLE/o0eDPdJ67lHItOfv+KC0cBPJdW/kYW0CKzm6VVU6yI8rvqrJo9cYpUzh32U/cVMJlSQ2a3n09vGFnTnOhQHrZGaIPNboyTCoY72+h4jghqhxmmUETIfdvnCByMXLvQuBTwRAnLTLERfW/bnXZPF4b1iSpqLK1CC9Jf21rWmON3HkTOjrnVgLBhhMKBsaJSr25TqErchKiJjtd7DpSeU+6BIfimwHWknkJ3MtBhIwcmUrPJLDtfkWAuvuLwcPbi2NI4Nlyu8QzbpY3f2isTvBa1gvJ9Fg7qvdXFatRuA5jR55BecwBHHUn4kkAAsgM0/xARusNYUG9ZIn/Yy6ftKm93kxBCXtA8gWGyYTU1/q04FqEGWAw5RYMAO33BXkBeqAAzEYdQsHrS06
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 1:02=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Thu, Mar 26, 2026 at 08:03:34AM +0100, Michal Hocko wrote:
> > On Wed 25-03-26 19:05:47, Andrew Morton wrote:
> > > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
> > >
> > > > We should unify both algorithms into a single code path.
> > >
> > > I'm here to ask the questions which others fear will sound dumb.
> >
> > Not dumb at all and recently discussed here https://lore.kernel.org/all=
/CAMgjq7AkYOtUL2HuZjBu5dJw=3DRTL7W2L1+zVv=3DSCOyHKYwc3AA@mail.gmail.com/T/#=
u
> >
> > > Is it indeed the plan to maintain both implementations?  I thought th=
e
> > > long-term ambition was to knock MGLRU into shape and to drop the lega=
cy LRU?

I think one thing we all agree on at least is, long term, there isn't
really a good argument for having > 1 LRU implementation. E.g., we
don't believe there are just irreconcilable differences, where one
impl is better for some workloads, and another is better for others,
and there is no way the two can be converged.

On that basis, I would be hesitant to add some complex abstraction
layer / reclaim_ops to facilitate having two. It seems ilke it may
make things a bit cleaner in the short term, but long term might make
that end goal harder (because we'd add the task of cleaning up this
abstraction at some point).

My preferred way would be more like:

- Look for opportunities where we can deduplicate code, but without
adding abstraction (e.g., factor out common operations into common
functions both impls can call).
- Identify gaps where MGLRU performs worse than classic LRU, and close them=
.

We could go the other direction, where we identify places classic LRU
can be improved, and port particular MGLRU features over to it. I
prefer the other way for a couple of reasons;

- My sense is MGLRU is "close", meaning as Kairui said in "average"
cases it is substantially better, and the gaps are both fairly narrow
/ edge-casey, and very solveable.

- Leaving classic LRU alone leaves the option for existing users to
maintain the status quo. If we start porting MGLRU features over to
classic LRU, we may introduce new regressions and break existing
users. Using MGLRU as our working base means we can iterate on it
without as much risk.

> >
> > Yes, but MGLRU is not there yet and with development pace last year or
> > so we are not much closer than at the time MGLRU has been merged
> > unfortunatelly.
>
> I'm quite concerned about maintainership, as it seems the MGLRU maintaine=
rs have
> not been all that active, and the MGLRU to me at least is currently a bla=
ck box.
>
> I'm not the only one who's raised this (see [0]).
>
> That'd very much have to be resolved and the community reassured that MGL=
RU is
> _actively_ maintained before we could even contemplate it replacing the
> 'classic' reclaim approach IMO.

Very fair concern. Time will tell but I think things are on a much
better trajectory now.

Barry's and Kairui's work here has been great. Suren's team (Android)
is dedicating a full time engineer to MGLRU this year, as I understand
it. I'm planning to do the same myself. I started by spending some
time reviewing some patches last week, and I'm hoping to send some
patches of my own in the next month or two.

I realize just talking about it doesn't mean much, action is needed.
I'm hoping in a few months' time everyone feels much better about the
state of things. :)

>
> I hope that Kairu, Barry, Zicheng and others who are interested int it re=
solve
> this, however!
>
> Thanks, Lorenzo
>
> [0]:https://lore.kernel.org/linux-mm/aaBsrrmV25FTIkVX@casper.infradead.or=
g/
>
> > --
> > Michal Hocko
> > SUSE Labs

