Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97A3FC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69E576B00C9; Mon, 27 Jul 2026 11:48:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64D876B00CE; Mon, 27 Jul 2026 11:48:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E826B00CF; Mon, 27 Jul 2026 11:48:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21BA46B00C9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:48:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98827C0727
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:48:51 +0000 (UTC)
X-FDA: 85034989662.18.266983E
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF33A40003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:48:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mpiej/IZ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785167329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4cQ5DrEsm7Cq0UTRATKjB278F92qDsZ00k1HS8Sxy8=;
	b=OCmpjPC1YVNHI0OGhM0uUHaruOT+VzfUwSg0dtJ1fN0mGsFZ/1emjDyvC5X9WQkZwWPuxH
	1TsqCbjh/Ba29ad10Nl/lpKRa4CuZwdmar5/5JMfb7eLsb/3o6Ui6vysG8YM7qDOVz39cl
	R+rEV9YGVNUd1/8ks9er+7zAvxox3Ig=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="mpiej/IZ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785167329;
	b=X30A2B+YfhV0Ngzc+bVf+Z3smACW/pNnP1m6e66WUf1mexrXq9x6r8fYDHmCYv4qkr6H17
	e/7AJ4ymqfSV9650MTlc6ccWg11CmelxezEBk5yFn+TCsvmp3Kdy6QKLEdwdRqTsTbWiKn
	N04SUTLHKM7IdNthpfAdOdtmXMkWGb0=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4758bd3731bso35026f8f.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:48:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785167328; cv=none;
        d=google.com; s=arc-20260327;
        b=LdyNLd3aoUzQ2nDYjvUjbfYdzlo8Po2R7zrBe1cawFdoAWUDGQ4IoNg7pUtMTnG3+M
         ZTyP5XYmD5R2YjsF9S0EJzEt6Ji6hMRD1QTQxavcsFaFlSAPBoxMPAGB4B4bw00LnsSh
         OxAERvBmuSILso+3Qus5erini2lQg8zIt/4iKgA/soQ54pw0slgjLbB8P1vrAxpXu+IB
         qlzPb0MqSy6E4AFwaCamM6CPzy46cE9UVcNMWRLcriXiMsl55t/+/mwcaTXlurqtRT/l
         0HocoHcs9FUTt6ApAkMMiNfhdpefnPqgOEYn7NOR6qmN0rz/6dHr893BLjSnI0rsChuL
         Tkqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N4cQ5DrEsm7Cq0UTRATKjB278F92qDsZ00k1HS8Sxy8=;
        fh=8XrvDq9ieM5Z8DKkNaqXCuIJMDO3DtmjupLh6pGzwJY=;
        b=ohJB8FV2u6ZEbhd3W3NLqASJs+8LKGiO80XHFDMYGSs+OmWTg1ekyQ5dYbj1tsPK/P
         wgTcKO3B+SiKsMB14stHA2eVT1V21veNEY7zaYmaLCw+lqzX+YhK0V+rFYULuOSC+LPQ
         V+E2Wt7B2EWjSxjyAhHA6b6GAttHntZr98TUE6nO/HcHfjAcr4oDIO5W5KzoLt36gDRQ
         fuctHa3w1ofGCTdBAyt8H1az9WqM9JgueB626vzs76Idu1VVCykWvuJSsV9Kk3v+7J5y
         /8nqfxXSbcn2C9jCCl3M8ySsjnGY/1VvZh3exPDXvdDWq/NEh6yrYP+tTqneKTaMX48O
         VCSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785167328; x=1785772128; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=N4cQ5DrEsm7Cq0UTRATKjB278F92qDsZ00k1HS8Sxy8=;
        b=mpiej/IZMdP22QrWv9/vTR3hSMpKPcWYt4Q+nADa83htmIDKWZ24U8ZSMf5DhhPPMJ
         CPfg2ZBfMmZrdz/rRchfirl7Ydeqr9x+VrclbNagl4eTZ94z3K5mJG2+PBAiMmaHJaJx
         nYji57AJq6fOqj+V2zJv9eQ7/4rR9IspNaCJUvndisrsvGbkGQcpJJkrE+7lRqI+KvSO
         pQEWVsPTiAshwZF7r7sKGZoiVyLIgk+WBpAkQvN7cCZbJWrpkWN8WrKdHWe1vlTkIQ+Y
         Vu5z3dcOaxHTwTcYqQPPduvZpXioFgRmGACK4AG56yerTUeKT9h1jWkxupzErERY9OCQ
         5c0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785167328; x=1785772128;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N4cQ5DrEsm7Cq0UTRATKjB278F92qDsZ00k1HS8Sxy8=;
        b=a78Ex70NzTYxVLOBRR6EixLFbRxTQQ1pfY43yFgVMQwituFCKzYbUqUJREKfKavGw5
         BAnKJ+X1K6bT1K4wrx/BC2j5300WXiwYQBktAfi6uF8LsjL57HGPFhCsgoVqFYdlkWB+
         LgBX9WUtzP6XlL5DP4RyuhMi+HVZ6+78Qaz+2IhgU3tmN0gn2aFL1HWXYTsSQ2k6LpVl
         esRAIliqiXFIoJCRBM1zYJFCWgK9tvw5TlikrSJ3EM9dkiXf1p6z2cb0GjO46kYenjGG
         wOXw269z3xsusKHdgQ+gv5maL0BosdfhOco6vVJDKqTR8m0Sbj3aAkgCS579Tc4Su93p
         Av6A==
X-Gm-Message-State: AOJu0YyqLaPI0anFRspdBjpNkHm6Qa8rXBi0i42Z5iKQiLr2qF7cZUvq
	ZTSKuCg3UQCf4fi5i1Xqu+XJdvvqCv3dfXukTyR7epqi2Z/pLy7C6DMkmoE4RpiwdD+MA7t3YMN
	n6+CqnRKArg/R+XJil9RE89KtA542s1M=
X-Gm-Gg: AR+sD13PgYJYCCmt8e8DFf5ZU9vOmk/nunluMJAL/5g9CvjRzClZ9Is+sXcu75xz6iS
	Ra5acdBvxOKavqU4vgjBByr7a/hfhR4z14zep43eoJZSSs/a3ez7Myj7/DmXqorodxdUt/AqmZv
	3WjJVb4rJh4Ii6VAQNEzK7coMO1VephIgHjF4u4/5nsDycbM9vgwtCNcLHHvGd2nmpP/m2epBap
	LLvLG+u+TLPfYqs2F9djH5Kcl3xOlwDVfr4ZNntdzjXSAIClAQcQrkO6YlIpN0P6K7qoVmb/LBy
	ddoKgCeO5P+Z3Y+BuQ==
X-Received: by 2002:a05:6000:25c3:b0:474:bbbb:bf17 with SMTP id
 ffacd0b85a97d-47faf42fe3cmr147994f8f.0.1785167327996; Mon, 27 Jul 2026
 08:48:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
In-Reply-To: <20260727135029.1059441-1-baoquan.he@linux.dev>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 27 Jul 2026 08:48:36 -0700
X-Gm-Features: AUfX_mwr6ySB9AWACC0RchE9ZSGPGErXJFtdp3fFdEPyk0D5Sy0ZdIYh2Cp1Nhw
Message-ID: <CAKEwX=MNhfDr5WbkNAy7kO7z5JFcJT0DE+_hgMoz5Xi7vZ5_yg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/11] mm, swap: dynamic cluster management for xswap devices
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	kasong@tencent.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, david@kernel.org, 
	shikemeng@huaweicloud.com, chengming.zhou@linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: AF33A40003
X-Rspamd-Server: rspam01
X-Stat-Signature: dbh8ogmhc9t5k6jm43b6ppmtx9ruf9tf
X-HE-Tag: 1785167329-7150
X-HE-Meta: U2FsdGVkX1+lEwwX8FClxCpHtS6o2pM5eunUV0pJQuGQfZ2WyNrKLclSetUezK61KSrA8H0AsMoggspWBLZbPBnexB4/bM3UQ1njbHFo3zqFh2wJxCEsUQfLBdjMx9hsi4nJ8iAh0A+g9AegHK4ahQiUq7ey+mml05Aio0I+xDnbx6M0BHMHVLrBLaYuqz5gJAuqODsdLuLxGA6kk1l5FmumF7ECuKkMtxPzhiUyuUr0y8vymnDd0SxyX6clwLWCpAmBQpIIABJ+8HWjgwo+jC3In8DuMDcONo70jBkXsoJbhRhsdEX5FkqsY7cVGlc/nZA+5eoJXRJ6estMwO9BCgXKUdWvL6fNCvemX/igHafFzVkFSpmjajnsdlYxVpQ5MGBhFEB+7pA86pDJKu8sDuvQui24wMw2DkyG4kkLqEhlWVA5bRq1ZoqJUjwbnxdRLQy0cI8CfExCfzx2ithfGfW4oIfQfBzih9D6dLY3g6sZs6eKNLlKF25kHRCPm2l4bcaAetDOlfoEcBsK3PHbzg5WJ7dg4Widne4OGkQAgflVZ0d0lz938X1+GC8kg/0VPV+0pREUK7VWt12EDXINEWeT3Y+0QyBPOsudyU/NCyNpB9xw/J24wi1piIEbj+7mxUDAFSYRLlqRvaqmgK/oIOXPff27WdVy7BBtMYFPcHjWt5WZRBNV4/BJqkZZZ1WRW7udGxrQQy7rr+Y9ACjZlnToExncY0k2trsH6frGJzL5kLEoeJNtndfr8OHB3pt5fxKcH0+bgqfXqDN8jhHDTmqKp91jhQ681ND7gNHg/Y2dY8AsukU/47/WSUqKnYI9ezYcVQHxTiC+KclnAWBf42Xxn0FqQqyhJlKKQWI27p8aAqCdssdQklGJ8qsHl1X5Dmj+hGn+6Kf24Y+zqTA69dDFwHAyWFT9H00GZ3j2nnuCoXWPHPztfa2g3sn5GNNZhgXOYnI84bP13jfREZn
 TvXZb7p9
 rwv4zP5yfxKlfsWh8pAD+6fdIxS2a8dWUM4Zu6znLf842EnzUSFk6Y+udXs2bIDBb8kC/ZGMNiPepqeDB4DZYQi0jY3RYs2C7MsyEs0UWJ0lHjZjojfNeE0WYxT+NdHqFXu9G7E9OY/0zaRGsXVOg+BUi/wP+OVGFrsD6h8tDeiDTKCOBmQxlb/zv9wCFoAP/JKaDMJhc/r2K6D9Geo/nSnnHw30QBy6pedrhpfmJtbf8aSWFqOwiacD5kYhjsYugBJyIvZSNoHL+RHeYQG11zjxjV360olx8GPI6kznSfzjZYPOAr+rqwx9QT3SjwtyGGjt5mEMMxvOxWq++51wijKD3/Nx6ZGZEN1DQnAoXn0k0LcTfJC80i8UY6i8IN07KHu6r1HdCQD+QcPRLPYrN2sHryA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 6:50=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> This series implements step 3 of the incremental path proposed in [1]:
> a virtual swap device with dynamic cluster growth and shrink, backed
> only by zswap, no writeback yet.
>
> During the discussion in [2], Chris and Nhat debated xarray-based vs
> array-based cluster lookup for virtual swap.  Chris argued for keeping
> the swap table and cluster_info in the same place with O(1) array
> indexing, and suggested that the kvmalloc grow approach here should
> provide the cluster management VS needs.  He further proposed using
> the same grow technique for the future per-slot backend pointer array
> (vs_table), keeping a single coherent array layout throughout.
>
> This series therefore serves as the foundation: once the dynamic
> cluster management lands, Nhat's VS series can build the per-slot
> backend pointer, writeback, and rmap on top of it =E2=80=94 without an ex=
tra
> xarray lookup in the cluster access path.

Thanks Baoquan. I've given it some more thoughts over the past week or
so, to figure out a way to so that everyone would be happy with the
final results.

To be perfectly clear, I'm not married with the xarray data structure.
I only care about use case aspect (as you have seen, I switch over to
swap table the moment I figure out a way to realize Kairui's design
proposal - it's way cleaner) - and I've seen that you have addressed a
lot of the design concerns I had that would hindered the use cases I
presented. If the vmalloc data structure outperforms the xarray, it
should *definitely* be the data structure we use when everything
settles.

That just leaves the sequencing of our efforts :)

My only fear with landing one piece at a time is that that we land
something that ended up not working for the entire big series in some
unforeseen cases, and we have to rip it out or rewrite a huge chunks
of it. Besides, without an actual use case, we can't really test its
correctness, and purported performance improvement benefits.

That's why so far I have bitten the bullet and sent out the whole
series (even if it's really large) with the core use cases
implemented. I understand that it is big, and is burdensome for
reviewers - but at least you know that the core use cases works - and
if you don't take my work for it, you can test with it and benchmark
it, etc. And with Kairui's proposal, we still maintain the old
machinery, which allows us to even merge with something a bit
suboptimal, then optimize later. FWIW, so far in my testing, the
numbers have been quite close, at least for zswap backend, and the
core concern (memory overhead) has been resolved. So it might actually
already be usable out of the box? :)

This patch series has reached 700 LoCs, and I still have some
correctness concerns - I have commented one in another patch. It has
gotten more complicated now, which is no fault of you - we just need
more logic to handle the things xarray provided us out of the box,
with the hope that it would be more optimal. And that's fine. I just
think it would be better to land the xarray version first to unblock
users, then just slot your patch series on top as a follow-up
optimization. It would show the actual win of your data structure over
xarray data structure with concrete numbers :) Win-win?

But thanks again for taking a stab at it. Seriously, you're awesome. I
want to re-iterate again - this is NOT a Nacked-by Nhat. Not with this
patch series, nor with the direction. I'm just trying to figure out
the sequencing of our efforts that would make everything work. I'll
spend sometimes on my own trying to synthesize this data structure
with vswap design too, to see if I can fish out more gaps, and to see
if I can clean things up in a way that would make the switch from
xarray to this new data structure as painless as possible. As well as
the other design points we have touched on in our last conversation -
it makes sense to me at the time, but I need to code some prototype
out and stare at it a bit more.

