Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B962CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B321D8E005F; Mon, 13 Oct 2025 11:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2FA8E0009; Mon, 13 Oct 2025 11:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D2668E005F; Mon, 13 Oct 2025 11:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 887C38E0009
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:43:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37DCF1603C2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:43:31 +0000 (UTC)
X-FDA: 83993510622.09.F638FA4
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 61C8C40006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:43:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3uBLGEU5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760370209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvE2QaubCaNe+b2bi3Ii9pwdFgyDED1xYIH2KKqTA4w=;
	b=3Uia2a9MA1drFLtfpsc5frEmFxq0IGKBzF6xY/CH6YLQ7x5NQIYvIl1rIgkgQs2f2ysjzs
	SLxqd9x/3zKqi2oyaZwBLnSgLfWERfyubewJIPqGkAmUuFg8u53U35M37JFbMo75VGR2zR
	dsr9r8xCVQPJOFcHUQZscNlY0Nn0ng4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=3uBLGEU5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760370209; a=rsa-sha256;
	cv=none;
	b=rcalL9/oCzUBAZQs1YOaEjeO0zuU2XUPfh4LiWuM6A4XE0oMvepDvADXY3y4bcU15slyl+
	k3uIGI6eoUrDJ7GC3KYP/Sw2M70C52/YZhE4lWWuj9rmaN5LlonXlErNWYSO5V+g9rNNqX
	rq8o/glz5OxyHhlEMNazAA4UmAZFO1U=
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-4308afd43f0so1374485ab.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760370208; x=1760975008; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GvE2QaubCaNe+b2bi3Ii9pwdFgyDED1xYIH2KKqTA4w=;
        b=3uBLGEU5HlWDFczTOwDkAgiY9yL6tqHoIuNEp9otE8pSmmz49YABv6OVf8K5H832Qy
         47j0PZih7j3baO51qhr3A+Ub7GgTJ7ldU9bVHL5VJa2Vpb5PLlt7jf3GqP4BjhXyi2Nr
         iH1UN1p8dYAsds1jgwv79bsq87Z/YKvOL+6m+vjBnwrkLz10KZQWPp2H7IMn9bHxNb7G
         8BjJUJZ7WcpKk2e5zz1y/K//YgvheO3d+l/N3zRdjBTAC+3Vhv/aYhtKwJ9aB5joSoE1
         nMakhwrnS5eYu8XuS+ZfxF5m/OOmlpJQyYXnuVIvNGOW427lu542X23neUAfi7p6fcgQ
         NoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760370208; x=1760975008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GvE2QaubCaNe+b2bi3Ii9pwdFgyDED1xYIH2KKqTA4w=;
        b=UQ4g4002mUS6ZWnzY2BWzid8OH00iYrpZZJoi58rsJQTWeVbAFosqwqnmmYvN+m2qZ
         Pup/8Vmq35Nms+ySJ+2wUX8em1AVX5D2prfliABL+6fJJwxBezIUOaA3NCrvrhG9SO13
         rEbUuwWC8SVtgEqCxBar4up5yDXvUqDomLNCaY5gPSVzIPI7QQYp/iT7w499DHVV6hPa
         Fi8EDDKTIaDsJvNTFQCZdjk3+dNm/L7JbtjwnpjbIHfdcOkFziTYk4cQzZLnh+tzMHN6
         0AS3LIjIy8/OfHTDs+VKGtY8XjN4sadx2O2EKMGsD1ihPlRw+xj81+16Zi8peEgbUP7/
         ImBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOhu4/ByJAti7YWZP8+spdqlaB4xLvXM6gZUrwHhKUnw3FyHmUMqbErOyv7LNcKDfhYslL5IZDoQ==@kvack.org
X-Gm-Message-State: AOJu0Yx+FahqViNypn5UBNWEhSYjJyv3wCFLrEBXq0Ev/A4FbwrGYbr8
	diD8Rtydta5lYfz6WRMHjVg2fougCTNUmaphJKkm0zpsOtBYLqdqRQhtB8OV/BttQbYDvfB58Si
	rWmNpZMCGFCkSxvbe4Qxed8Ynm06hsEh690ruTDLV
X-Gm-Gg: ASbGnctuLWCg04AHWDSALrvX44JQgbap/KENZTh2yDi5JDemZES2UXzvK+ElFD+sg0f
	oyB78FStmL0kxBImI+JzvPnA/y2aRUO/ha4XifpEF8uiTHC7xwXjdiv7pgOEOfrFPmj97wLKDI/
	uNiE0UfaIVvKGzlHbvYSUMbjysR8KhTll2sIaoAb1LPKntDlJnqp6YpFXs5bY8Naj5HN2UD0wPc
	aQ9z02rEO+BpBqzYLHN0KpxH3xbIyywqjiddXm+D4SdtouDf2Ui
X-Google-Smtp-Source: AGHT+IGi9WTnaWtP/uIr7PgRC+0JilLcGDbVVnkS9tGZZgbSezgQwLrXzu3IZ+mvJsC1St6EdcqZZFWTwoYrtUBb1Hk=
X-Received: by 2002:a05:622a:808d:b0:4e6:eaea:af3f with SMTP id
 d75a77b69052e-4e6eaeaaf5dmr26573411cf.3.1760370207737; Mon, 13 Oct 2025
 08:43:27 -0700 (PDT)
MIME-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com> <20251010011951.2136980-2-surenb@google.com>
 <aOyf5FxH8rXmCxLX@infradead.org>
In-Reply-To: <aOyf5FxH8rXmCxLX@infradead.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Oct 2025 08:43:16 -0700
X-Gm-Features: AS18NWAw--9GoJimKYZPU6XtnCpJ2t59ru9kAaQP92i8jW-vrfiHymNpWuM0LSo
Message-ID: <CAJuCfpFs5aKv8E96YC_pasNjH6=eukTuS2X8f=nBGiiuE0Nwhg@mail.gmail.com>
Subject: Re: [PATCH 1/8] mm: implement cleancache
To: Christoph Hellwig <hch@infradead.org>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com, 
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, willy@infradead.org, m.szyprowski@samsung.com, 
	robin.murphy@arm.com, hannes@cmpxchg.org, zhengqi.arch@bytedance.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, minchan@kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, Minchan Kim <minchan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 61C8C40006
X-Rspamd-Server: rspam03
X-Stat-Signature: bqufdf6jxbc7ttjfjqf1zf56cd6s3h5x
X-HE-Tag: 1760370209-434635
X-HE-Meta: U2FsdGVkX18pBSL+/yuh9KfuiJP9tB1HngpBEjjat/gSPVveCzsOn582WGA1PD9Kjc6P7D6FZwwda8QEuLAmLzt1eY7oBTYw/OoJHrJEfw42W9Cw8FZFCnH49GCqY/oc+azWvMbdG42Z04ssbIGMyLrbvRNKn5Sj1KW+Fbq+UG/MBr6jzNXZMzFiaI5jpNv3qf9HoaIf3pA5O5sx9uTj5XnsaCzi6JUPI2ewIgsHADHiFw28YA/ejwmrkRy4qRZoeqkQdixRQ5nyu0RMI5xoWYiGnzewfM67+j925Ryr+ho6UA47U+6q9ZMdEczF51CJjLXHGVdrT2oJsRV9E/7EAuJWyNq5+R6BQbLIP7EEXmDQSBEyQCbkVof5MpXPEnDru2zx/6Cv6gJg6gU6q53m9yuLZgXJoyexYI1xK+rt+nNSlsmHHm06Wj55TpYwsvkmzQoolQPuBfPU5HPchZa28zvsVpsldM94TxwCAXV5YhZl9QHoHZrTNzHv7GAzioA+ICBYRIilMSY9nlWiQw+wEOgT36rfxHYJ8etpanfYwAWT4rpvkEv1+Ry32OEM94GZZZC6XmFgB6NI+tJFBlvfDns7Jtcz0KRvt+GuYkkyG2iiObJryx5EgCbTC2VI2OoRwq/WjIqyG/7xWR4WdCnfBZqthPo6t+FSB3S8jk1EaLWIDzl2DpQdWaakdpBMYNRyiYaBLr1Ht7u2y+sAL0hVLPh3iMkSr6nFXuvqSs/l0f+aF1+PXva/nLi7VN831OBBWGSI6K9NtcbkAo0InGAaocoz1qCfEG0FlJP3HmE72ncsAm+mN6QRxHftwFbmZwZEsQgj94vv1ZHPkh4xUu9Nm2wQodF3oq9+6toODDTnT1Ziu3s0yZgTKHgyfYLun6oYfUHQXPHEs2CgPKjlVSyXjZtYME7mFqfysORx/tuSZIv7RuwOpaUQy4PQRScKQ0i1wT5kK0/5+NZzV7yGF0t
 g/5VCjJ2
 bq4yeSFGhAs7ZLSRCW/gzKzV8H2npRIaDjSewcdZf5Lfv/yEqu/CNvigrwUPP05Bd4Bqk9TKlA7tEdlSb2ecLigej1f1+U1QdRDMlWdie6Tz7i7nKClBzOkSST3/4ma3EKhVFCW9u3D7YYZe5Lru6waRRu3sr/o54I8dNjw93AHIQeTZihcvXbfCSpNtwOU6qk7v0tOjLYJLvVTjg3oPzIP1DG92OwkvptJvIsb730w7xTI3UM2HMDM48DQhCb23PZYRLJ8B0dhIIvrON4vqgSyPAI5qRL93SgGe6o/A65QbYDzY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 12, 2025 at 11:44=E2=80=AFPM Christoph Hellwig <hch@infradead.o=
rg> wrote:
>
> Please don't add abstractions just because you can.  Just call directly
> into your gcma code instead of adding a costly abstraction with a single
> user.  That'll also make it much eaiser to review what GCMA actually
> does.

Are you suggesting to fold cleancache into GCMA? GCMA is the first
backend donating its memory to the cleancache but other memory
carveout owners can do that too. The next two on my list are MTE tag
storage and memory reserved by kdump.
Also note that the original GCMA proposal from 2015 [1] used both
cleancache and frontswap to donate its memory. We don't have frontswap
today, but this shows that it doesn't have to be a 1-to-1 relation
between GCMA and cleancache.
Thanks,
Suren.

[1] https://lore.kernel.org/all/1424721263-25314-4-git-send-email-sj38.park=
@gmail.com/

