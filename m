Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5456C606A322
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 00:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ayG7VA9R
Received: by kanga.kvack.org (Postfix)
	id 5D74A6B00EF; Wed, 28 Oct 2026 20:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF366B05B1; Wed, 28 Oct 2026 20:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0346B05B2; Wed, 28 Oct 2026 20:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1242F6B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:34:58 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8CF40A0246
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:34:57 +0000 (UTC)
X-FDA: 85373793834.05.9DF7819
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf27.hostedemail.com (Postfix) with ESMTP id AA73640008
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:34:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ayG7VA9R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793234095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5QSZtmmBwsZEse/gnhOiul6mMk02INnjVORNY8/ULQ=;
	b=n/9A70xqVDNJ7we2YYbpmdZbPWMGoW77sRDA4V6e8G3Mw8S8GtsOeBewyl5xf09SmR6qK1
	hJSxGdXGY6yvK3RIGvs85C3iLlDoEon65MibPpiTHUvTwOPwbsx95Gzg2eq95GOecemAgj
	vBuI8oXeNs69hPzaQjDn0F9pckdeyuo=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ayG7VA9R;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793234095;
	b=OzURYKLTN1gswQV/u70846RcjNjGb4ghi+C+8EZivK1ZD/vVznPvS3T17vqyEXriHArCrY
	8WXsGS1r24S09QpXklKfHy5UJNn8w9CBxx5sZtE1FvwUi+UwEILmw/IVV42252wsQm6duJ
	7Y14NB63uqSXDuQmu/Syqs3C2+eOEeM=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1b12de661so5406a12.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:34:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793234094; cv=none;
        d=google.com; s=arc-20260327;
        b=WottRm/CI0465M18n/vd1t4P0YJujObpeClR1p+FMwUo+9J5ztcidgztqT0NobiTxG
         QXnyzKUsdPLrUFAICBfGc2nfaHdfGZ1X3pjHn7/nAj2OYFbFRZfo2nB66bTkQ7pMwkDN
         CDI118VaE07lF5OaFQgPT0i/5URhsNoIQQ/tFLOXyI271+l2Ht+wbfR4F8TQxye3qwTB
         3bvMPgZQpBwInftV2lfBkJPpOh411l4CRnEUuAydKbYQY6+DmihYLTa4xmUbj6gIsfhg
         HRk1GJb8kKPLanBISM3BWktTOFWEx5XOhXs+w0C2nWq8IUE4UWUjlZZte3ye2Y1Mue3E
         jIew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=D5QSZtmmBwsZEse/gnhOiul6mMk02INnjVORNY8/ULQ=;
        fh=z9MfZE3ay06shGqRfeXd41bijzcD/ZCy4eBY8LPEQLE=;
        b=mbFrpthea0NjZ990uRbUGbOHzlvS7b5zWQRQ3tRcO81Vc1r5mNRJxORaPDJz0SFBLe
         L2LtrUevi073AuW71NhgPl9xhTWaNnqrj4c0OZj0Wh1h68i597z90d3AaCuZKEKaA42Y
         xtXWALhdFqOSyMf945LeQAUyPCk1CuXh30/X/H4qxLtyKdaJLDT0eg3nFMwvCdKuPha3
         /n34gywYfXiI6c7et27cLGLXfN7D+HrrzqazknzyxjhEUxP4wqLh0hCfdHv0MimVGDFY
         vY02yGE/dwIqRwiCOttqqsma6cvHv/qh3sfDR0/VW2Hn0i+g1J+BoqBnuSqTuFprVyG5
         ZPpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793234094; x=1793838894; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=D5QSZtmmBwsZEse/gnhOiul6mMk02INnjVORNY8/ULQ=;
        b=ayG7VA9RDB4ciY+4kkQoiZFT1O4UdcFz9Tthtf6xiuXdu+9XJMhbIVzx8HE+NbARwR
         /Tj1/1gIq4m027vo31DepOYKre06knT0zJksMoxs1+9jha7PfIexGM1vbAeWkmFzw7oD
         E+y72As3Q5OW5Y/ASyV1FPEh/uwJHfsSnQyLLQNriYIK0QA4fPryNWCNv5NBpdgg6VM4
         BWtvIX25h4cQjW9CNXOe1skHP1X49sdzzjhy9+EoOQJzG/4ZLu1OxzN9Ofvlx7IBRyYL
         rZ89atKvwVHH6IqgxdfL3WFzuLgccfEqd32mtTRn2ehqPyC/voV+EIARjs8YrWbIDJlO
         Qodw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793234094; x=1793838894;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=D5QSZtmmBwsZEse/gnhOiul6mMk02INnjVORNY8/ULQ=;
        b=1Q//iWsMoamnQQ0lVsLpHZq8kVjO4CrokSmDAKinhYBOfRiECBIB6rCANYPy+tXMXV
         7K+PMgTeh1Rd3QakgIdTrE9NTZBT5qIvKe9/bSnVh2Sx7g3kawLnYJ8z331MvHVZlVT4
         CVDm45wzoK6+WXBV4dhbTUlhGwi0d9nVGiZHg/IPMvVwxWK7Pl/Gkc3Sw4JyJIv721qd
         nUU5Telv/dvlCAh4bQ2eSM0ezzM/VQUpdj+MF4wTnXq+gSI03IfjchYy0obzGvdEVyoV
         OaucVXUEwV8Th38OXqvhvqqo9ceks9d5yCjlg6JZS8wN8LlTIXm4of2/ar4tkqCEYK6r
         KUZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzzHdj1xtywVV6mV9hNqTnORVTNIh7oLpJYYJk6BTglrgg3cpXAmAVLG41fmIi/ZFegtLJXekSnLg==@kvack.org
X-Gm-Message-State: AFq9FYIDRxHNatNWixJwkjNdBNIKNOcSvZ/rfCxJt4A6ZUkpB0gj+O00
	37DrIX2+zG/aGrDRtBVXIh2sLXgVP51u7F57fwSewC74+mNPe0qSZsQ9Zd6QJRt7MFZyTZjP5lx
	srNi7CZxk+FpWS613JYhifgUyT0xHhVgFa9Qr5JlE
X-Gm-Gg: AYBFou1oACA7JCMaDcdTa2JYlM6U1mArfTso2HF4Q8zq0iFDr3UASpvCwBclyqk5T4G
	ltIhdGib+62g61M88EplZDCuzejFDdP8nMTFE3qLeSuZTtFFWHiJHMzbf9QhVFiqOoFQsH5fkHC
	qQIwLIr6qR+wANiSai5xJOQ2UIWaGV2WNBsA+r8177DK4kmp8ggPlS0IsLessxqgloiJIK7ave5
	iplGGzDvqKoBp9JM49BikNbvjoxwur+marzHE9VS1+bJNOcSGzBX36FMyB2p12kZB8eAU0+DCcE
	8ky46R8UxbuqFCralgtBcSoJJe3y08poXEc0G1HAIhnURih51CihfFr/4ZeWGN9uha5dC12gyQh
	gZAiGCocIp++rJ/N3IWBPGaZ1HT0lkLS6TgA=
X-Received: by 2002:a05:6402:305b:20b0:6ae:188e:e119 with SMTP id
 4fb4d7f45d1cf-6b4b38e71bamr17357a12.9.1793234093746; Wed, 28 Oct 2026
 17:34:53 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-fix-vma-lock-overflow-v2-1-9eb778b79b58@kernel.org>
 <atXjbsDn7DJybsHU@pedro-suse.tail5790ac.ts.net> <atYJA7nIu_RwpoCC@gremlin>
 <auIIxSorX0bhZNZc@gremlin> <auIPRjj2t0BcYlOa@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <auIPRjj2t0BcYlOa@pedro-suse.tail5790ac.ts.net>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 28 Oct 2026 17:34:38 -0700
X-Gm-Features: AclHuK9v-C5aWQDQlkF49lUxmcEnZFv5OCriejxPhNjzEUORWR_RPAcdszPg35Y
Message-ID: <CAJuCfpFVv-t08YGMPR3YHCyiOK4HY-YjMk5rB6tdBa=mq2MvKQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vma: avoid spurious write locks when
 mm->mm_lock_seq overflows
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, Daehyeon Ko <4ncienth@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AA73640008
X-Stat-Signature: embu4jn3hb6ro6r9ioap7d5fh1ifj96c
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793234095-469245
X-HE-Meta: U2FsdGVkX1+QR8vaI7pvCp+SGFzHoiLSvqrbf3II00Ssx2BfTkZLAOjiAQRmpyr8kJGKKwCFQ62XS77VWXgJY8jXKYY4rlUflb3lP/mg3kaGFcVs6XZF4l+n8GL4xqXSnHq5WUKrMuyaIlJubqtTMxg1wktIqfPwcl6wMG3KYiBPRwiDhvUP7c+/MU0E0YkvKxdZM2IVruJQyBphasxE9uEmFzecBesM2D1z4jevW8W2Tw47sI2RTpbR0hL622wOZJ45zI6YC0l9pQBH6uXc3QWVn+dOVMqpkjyl3H9yJAFAMQAv3A8XvKBlPJUHZESW0mDX0RMkPwQw0CwWVhT82ACd+clb1bfk2gX9WHC02Trep5tMXYqCi3sW8eGd+B4btQCc0bfOFs1XpnnGjV1kzwnAWWN+JIgxeh+r3sas02KNKe0xvxGLftO07LMDVSW5TPyyfhAj+IXDvxWlsxfceXmVhtCR2R25DiSGxVomS6kMiWpw294Ukt0lKuOti0lBgXcs/Rk0kotBDZvj5Ki31qLB+GFS+fwNwsxV/AdsU/bmjReTeUkkGc97NOLYTWBoCIoXuJ4t4TIk7eH7TaSQWHDYJ7qgH99nsw0T3ExVqwpcrtLcuwwxXIfru8J6RiGzqMCsNenPg6BiLL+YxY2akW2c9bgMR1MjbY3Fp9aVWovNtnT/U5zwhqaXlVVlZvMv6PEoGj0nCgzMYpVCdROutryF/+XvHQZfxpaL1ZwpQwVA3Oh7qExAEf3l4CfP76LjotmxzVK0HD6x0zbUfAqzu3n3j1V1za1KQrAJ+eZl8ob405BKiym4BDytsX3/cGTiEME/LE4NgzwgrVnyxywrCjvzEzD9vQbtsbDMPktQY67vHEtnmXNxYc0CDllmGySSaJKEpJ7nVUkiLXuRtsZu+6mfMLaCIQGeXTGY/tevbyC96aqyYXtyAwSodjXhlTv0IBa/j25nV6qHCwt916P
 kqxHgm0G
 eRBanZPCnDOJbj7wTyfJ839o/v8R5F4+sSCKgw+eBPQAdmJYe/w0v4NSUwMxHqQBpS/l9zrL9qAHxX7Z42TN33fP0gn1VK9gOC+NQyrklAaZwpxYBUxwOGqLI+rTks/OkHJYM7DGzVBnXimnkyE2Rcy+zdsvYNu0ryGreaP4kJPGYDOnBG6HuI/Wc9b9tOd4Dhn9IEkpu3fMOTFlrtPH8Cehr5vb8Wm3W94Qz+X88sRvTdsWqpTguwX9HG5kR0CU3qAkaUptNoyGlhKQRO8j2InhuictJXM98KjRm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 8:06=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Wed, Oct 28, 2026 at 03:04:07PM +0000, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Oct 19, 2026 at 01:19:45PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > On Mon, Oct 19, 2026 at 10:53:27AM +0100, Pedro Falcato wrote:
> > > > On Fri, Oct 16, 2026 at 12:34:33PM +0100, Lorenzo Stoakes (ARM) wro=
te:
> > > > I'm concerned by the possible latency when doing this to many VMAs.=
 Do you
> > > > have any numbers?
> > >
> > > No, somebody schloppened a patch for a real issue and I haven't the t=
ime to do
> > > even the things I need to do let alone 'here's a new task' stuff :)
> > >
> > > However, this is a simple write to every VMA, done at the point the m=
map write
> > > lock is held with all VMA write locks dropped.
> > >
> > > It was implemented such that:
> > >
> > > * No VMA write lock is taken on the VMAs.
> > > * VMA read locks can proceed.
> > >
> > > I.e. it amounts to a loop over VMAs and a write to a field.
> > >
> > > I don't think you could possibly do more to reduce latency here, and =
you
> > > absolutely have to update this field across the board.
> > >
> > > Under any realistic workloads this will occur at worst ~days interval=
s, often
> > > far longer, and likely you will see quite some gaps between separate =
processes
> > > experiencing it.
> > >
> > > There's also an upper bound of vm.max_map_count per-process, so it ca=
n't explode
> > > into something truly insane.
> > >
> > > Most processes don't have that many VMAs, other than certain steam ga=
mes :) so
> > > it's hard to imagine there really would be that much latency here.
> > >
> > > And the latency is occurring on one thread, which is performing an mm=
ap unlock,
> > > so nobody sane will put that on a hot path.
> >
> > Sorry, I forgot about this and didn't get numbers to back this.
> >
> > I had an LLM go get numbers on this, all in ms on my threadripper (but =
numbers
> > should scale similarly) with fork() + munmap() all VMAs for comparison:
> >
> > (all ms)
> >
> >       VMAs      reset    reset     fork()     munmap()
> >                 (warm)   (cold)    (cold)     all VMAs
> >   --------    -------  -------    -------    ---------
> >      1,000      0.006    0.041       0.33         0.43
> >     10,000      0.072    0.36        2.1          4.2
> >     65,500      0.61     2.4        14.1         33.5 (default)
> >    262,144      5.3      9.6        60          168
> >  1,048,000     34.7     39.2       237          691
> >  4,194,304    162      163         954         2810
> >
> > It happens on a random VMA write lock release, so there could be tail
> > latency, but it'd be tail latency on the scale of ~weeks for normal
> > workloads, and (assuming max map count reached at default limit) a ~2ms
> > latency for an operation such as mprotect(), madvise(), mmap() or munma=
p()
> > which shouldn't be placed in any situation where the latency of that ca=
ll
> > matters.
> >
> > One call in 2^31 is the
> > 99.99999995th percentile, far beyond any latency target anyone measures=
.
> >
> > The amortised time per write-lock cycle is ~18 picoseconds (0.018 ns).
>
> Thanks, this addresses my concerns :)

Sorry for missing this fix before (due to my vacation) and only now
finding it. From a quick look it seems correct but I'll spend some
more time reviewing and testing it.
Thanks Lorenzo for the fix! I completely overlooked this overflow
side-effect. And thanks to Liam for flagging it!

>
> >
> > Interestingly, the runner observed khugepaged-induced mmap lock stalls =
of
> > ~100ms, far far more regularly, which seriously exceeds any of these
> > numbers, about which I assume we haven't had too much complaint.
>
> Wow, that's horrible.
>
> --
> Pedro

