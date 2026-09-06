Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89B2AC79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 09:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E2D36B0088; Sun,  6 Sep 2026 05:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193CF6B008A; Sun,  6 Sep 2026 05:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A9786B008C; Sun,  6 Sep 2026 05:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D98D46B0088
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 05:20:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 671ABA048B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:20:07 +0000 (UTC)
X-FDA: 85182790854.29.9401F0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 93AC516000B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:20:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2HGSTo7;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788686405;
	b=J2uU8mjCLtm6vzMNkTWjd8PpfZlWoNpZjZPWuIZYgRrxlq/v9IiJyszkexahyaCSPK6ALR
	NYT3RSoPu1Wc93ywy17nYYxj41d58px0fGbxy3lkXAp/UDWPUStQbZkKVuIusf5Hedb7Xc
	qDFJxl5OF38eE3LmX5cFXNv5ygRxrVk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2HGSTo7;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788686405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cYW1ROi37KqkEFd5TNsEKoOjauJGezJQOt/C6A47Gg=;
	b=GS254HuA0/o6xCr5j1vaZGk6WzPo5GKL56u9NgoV9Tdnc/4t7rh/f59t4N3pZ03nf3DQ7V
	+ZwlorwzzcFMlydULk/UMH92b6UUr59H3lpF7kp1+omavOnEGL711DnIp4qKA39DHWZgIE
	HtOMAlkrLpgNmk+g2hxm2bPgxsMX6NY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12995600AA
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B131F00A3D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 09:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788686404;
	bh=5cYW1ROi37KqkEFd5TNsEKoOjauJGezJQOt/C6A47Gg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=L2HGSTo7B4iRN9sfqV5g4K+SfsKOsum2FixJmbh/Rqgs6n/p3Sv5A0gLVb4XJUGF/
	 e/ikIJfx/9kEzeRGQPQ8nbi1t9ABlsAez9T+Vb3Y5lnuIK9ifDfO11lBXj7jQELlxb
	 I/b6edrWHniBGmULwcWBJmLooFESq560rtZ8dfQz3wmFXg1OxqLqbPVOCZN3MpxU4m
	 PfHdfX3VuNOz0LPPm9wjzvYqSp3Gg45anocl707EqTW0jmhXfj3aZlAjfxBoymuhNq
	 VjGYgYVP2mpmX2Lu3ICaFI8EpqK/qa6xM38Raw9TY+uZSt5S6zK2JHTCV8mYhXAiYU
	 je4VJibT3a0+g==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c262bc686d9so158077066b.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 02:20:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByg4FzeRRVJtZs3c1d+CrRvjhy/D1IpZaUS5euRXvR6If3Ehgg+4NZv7OIqLRbGtTEUEDcsmXHwVA==@kvack.org
X-Gm-Message-State: AFuF++n7BWHuDJifk3uIdDh3FAncV8UXoNYM7suSUJQ+MKdH7RU8KnHj
	jN3gcLSq5DwBILUODj4Q+gYsXxH1CV8Bd0J/10wzGc2a+CPUlB00n5O92KgmboR2NQKx2185vae
	FyKpWUaKjyyeze7fBhjFk0lvNcIZfbq8=
X-Received: by 2002:a17:907:72c7:b0:c26:30fa:7cf2 with SMTP id
 a640c23a62f3a-c2630fa7fb2mr218413766b.13.1788686403464; Sun, 06 Sep 2026
 02:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260905125101.2970456-1-xialonglong2025@163.com> <20260905160926.9836f2ca0dc977b89f2f146e@linux-foundation.org>
In-Reply-To: <20260905160926.9836f2ca0dc977b89f2f146e@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Sun, 6 Sep 2026 02:19:52 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPhMw=2+wyRYwbBS4As-zNbVnkcT3Y2ppqLo1AxPzaTAQ@mail.gmail.com>
X-Gm-Features: AcwNN1UCbtlS7EgmlQzmJJ99lyp_A81DiewRw8op0GuZAHVNhmi5SzYIkBSJIkk
Message-ID: <CAO9r8zPhMw=2+wyRYwbBS4As-zNbVnkcT3Y2ppqLo1AxPzaTAQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/zswap: enable static key after runtime pool recovery
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Longlong Xia <xialonglong2025@163.com>, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Longlong Xia <xialonglong@kylinos.cn>, 
	Alexandre Ghiti <alexghiti@fb.com>, Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 93AC516000B
X-Stat-Signature: 7n8a4y5soqprkzi68jyuh68bf8ie6u8c
X-Rspam-User: 
X-HE-Tag: 1788686405-53336
X-HE-Meta: U2FsdGVkX187YCxIoqeo/mzu+q575Frp9SBE30O7TvphUvn6kBRQw2FAjz0LfbYd3Hgpj2Q8ITAym83SLtVvOB6RNZZK4hiV2znIKwExTn7vFwb3xDe4JIS8D1PdAi5h0Gmc3USdvJh4fhLDwCCJeivlwy6b9NWZGqQeKxXpze/oP3EJ4pBLvbflQX/IBPDUp+YA+ij0QL2B5BAB0WIlx1YJtD9QHITmbDU6qNdo0s/dYkUtppantu455RoAi2rress1PY82ksVOhx5ij4NinrDVYeXbJCYx1n82/vTu8xpMOfaO+lHHFY3h2veQPMr5iljJUaggJxJjb6kpnKsFneXqVteEmzXesk8zSg1R1i6EFOb0lO4Cc1RxOoyMG6/GO5laIL3ul6faRptDFeyMh7yoyfuwX+qfnse6acOO8vDGccr8EnqVvqVJVUOSm8SuTlieRA9+TO7ahoo/lkU9bjHyUvvDFO1gIw95fHe5bOTP6tWgA/2DwoAWVwvD9FQQTV4qqX5HNJXq6m2E1asSJm2kESTrRyo8wdv7U87G3T1kl/OtdeA1ROhI55PQDa9g+z1Oy83OVt9hhHHGbFL5m1AXoaXhlfg+irnPbHi5ldbxlQSFGlt6HTRUSkyPkcKOwllyGChhZBr5i/pA2N+MfOBLIx24o6TuhKO9XG3cdAZ2RhppeOKQcu4ln1c+z3joB5BE67daOwKQ/DqFWzmrFoLvbnTp4Yh+s5bptYdbH07YYoJtqGG3fAsh8+5vBmyWNPB2KpUtBjstd36ieeyW0AQviNx4zW3Bi/1AVwwD93ydumxAdLIcSDwFBUP7YjCFWumh1EBgL8yVKGRxcjLAV/hUrkXmdjcwWZWhvnsGvkh+kbt68n5JGIbD7atQBUFiUHvAhcTrX2mQQMxX158BkmKLMDDzocCE/VdfoQdWqhqE2QO6zoHwsf9tVB7uG7f2QA0+IaL0iMAMKBJ+m9f
 mpDOZSFN
 AUKaUKFlGBvhRk/ZnIFvNT7YMbNFo/psWOWoSdIJgSJCatc/QWey6at5a/okSda2YnElDUrZel8CizORHOtb48QTaMA2DUnoDP65KjScrp6iUYsou8JfVHPCtp6CSMTJZ4e1j4gOZCt2mZPdn5zhN7n30BMvrxJgc2dwv8unCURNS/+8HyJ2UI/IM3gPaa10PkVZ/5CL7NsI/RIh2TAwYZnHEyBhViExWHfhgRCOsudYIa9pcmdZ49TLmxAzVXg/RFJoiCRy/oU647kfzO5xyaiW+fmphmgcqZo/oaytC42Ml9hoJ4DaJoeoEKWA19yoFduM+exggdyRU67vHptB2hJ+8LY4IfC6TPkXFeVIa1jjwUdS1aF15GcfbhjQek27nsPrvGjLtTXjh3H30wA7VOwGERiaU65ljrcOX5Xvd8zIycKFczxqiox70beRChVwca2en
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 5, 2026 at 4:09=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Sat,  5 Sep 2026 20:50:28 +0800 Longlong Xia <xialonglong2025@163.com>=
 wrote:
>
> > From: Longlong Xia <xialonglong@kylinos.cn>
> >
> > When CONFIG_ZSWAP_DEFAULT_ON is disabled, zswap_setup() can complete
> > without a pool after a failed initial pool creation. A later compressor
> > parameter update can create and publish a pool, but does not enable
> > zswap_ever_enabled.
> >
> > If users then enable zswap, zswap_store() intercepts swapout while
> > zswap_load() still returns -ENOENT without consulting the xarray. The
> > swapin path therefore reads a stale backing swap slot because the store
> > skipped writing it.
>
> That sounds bad.  I'll leave it to reviewers to suggest whether this is
> a sufficient description of the runtime effects, and to decide whether
> a backport is appropriate.  Please.

Yes this needs a stable backport AFAICT.

A more high-level description would be:

If zswap is enabled by default at boot and pool creation fails, then a
pool is later created by updating the compressor, data written to
zswap is corrupted on swapin.

>
> > Enable the static key after a successful compressor and pool update. Do
> > this outside zswap_pools_lock because static key updates may sleep.
> >
> > Verified with fault injection on a stock kernel (compressor builtin,
> > CONFIG_ZSWAP_DEFAULT_ON=3Dn):
> >
> >   1. Boot with zswap.enabled=3D1; pool creation fails, init completes
> >      pool-less (static key off).
> >   2. Echo an available compressor name to zswap.compressor; a pool is
> >      recovered but the key stays off.
> >   3. Enable zswap.
> >   4. madvise(MADV_PAGEOUT) a pattern-verified 512 MiB region, then
> >      fault it back in and verify.
> >
> > Step 4 reads back 131072/131072 zeroed pages (zswpin=3D0, zswpout=3D131=
072)
> > without this patch; all pages intact (zswpin=3D131072) with it.
>
> And thanks.  Sashiko might have found another issue in this zswap code:
>         https://sashiko.dev/#/patchset/20260905125101.2970456-1-xialonglo=
ng2025@163.com

Hmm I think this might be fixed by Alexandre's patch (in Usama's
series): https://lore.kernel.org/linux-mm/20260818131202.494754-6-usama.ari=
f@linux.dev/.

Instead of always returning -EINVAL for large folios we only do so if
they are actually in zswap. Usama/Alexandre, assuming I got this
right, can I interest you in sending the zswap bits of that patch as a
standalone fix? :)

