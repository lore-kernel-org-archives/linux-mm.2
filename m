Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABD0ECCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 22:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3058E0142; Tue, 14 Oct 2025 18:11:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA7D8E0090; Tue, 14 Oct 2025 18:11:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE7288E0142; Tue, 14 Oct 2025 18:11:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB4AA8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:11:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 546F513BB10
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:11:24 +0000 (UTC)
X-FDA: 83998116888.08.D0FCB56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 66DE1A0007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:11:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQlRrx87;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760479882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aAL3SHZ14Ua7l+7DDPM23RdWK67qlCiZLxLMXHuLGYE=;
	b=dM38BXqZoNtpmwKe8R2WXZDFkh3UUoVjm0eSkUPPVinjwnJ8+vA/fGzxstdzncBOjNLzkc
	b7jnee8GXtQ5OdHpOjg89DF+6Gk7hDK/7eJibaDZ4nOW7DnseC6sybknYVa8b716cBFYOV
	u1kGtwpmB9PNAOJzplJy+stU0FGJ4Pk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dQlRrx87;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760479882; a=rsa-sha256;
	cv=none;
	b=1G1M0L9I45eyIGBuuRG0W6v1HLhjYdnKKKQYnJihBvXUnXJnSdrv4KIifDfjDX9EPgx+4z
	fbIEnchz5yCYAZrIjlsoyNsrOVs6QcvG2qObBbeHn1BRVY7Inx6LyTv473kJv6Y0sza/wo
	jyaYfHPjAnXkgoVexFN9rzv1mXr94Ts=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6797A62421
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BACC4CEE7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760479881;
	bh=T2FrI4BHqlU+vTUy6TWn7iut3KkHBNX7D+L9o/26ZdY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dQlRrx87iAhi7b7b2yDGK0/bdEQmcnFV5jpIDRSGBGkOFUt4xMfP3j6buAYD2a1vg
	 UgePgNxAcfjUnJ+7Psq203eviOfFXGjY//IIngigJpyLaAmoO94j/4RbszhkxHPc4R
	 dwrVJXIZgtzSbi7nlaLiHFrUvmodDAS0q51dlInEXmMRWUS/9NmW1SObaCs/AF099W
	 5tHH/BL/HdCjsqRyIUyKfTbN+fG9qXPoXdLPBtOSWYznpddn3x/LBdA5Db/EvpRAIf
	 +b7SH61P3kXBdmTxwZMpkn9ldVcrou0BMLraOdvXI8J4QVnb7xJyOlMXcixKJE5oPy
	 9y/EQXtC6F6Tw==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-63606491e66so4396283d50.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:11:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU95rG0XCyD77gzjb/vg65hCMAyroi9oBqhQrT4SbXgFgwZZzWlOLSG9N0XXVnQQ3tdK63Ihfrbnw==@kvack.org
X-Gm-Message-State: AOJu0YxlT5m1daO0ps8Fk/BGjtI6MzMurVt2Ggy3OO3s8jSgvhVCg6oR
	q8qUSJSO6hdqwsr+buTgWzpbmyoPj+O8nI6GkIbTi6qwMtCPERmPhmp9Mi/NtuOotn4GA4orWdr
	kvnpmKaEu7KfYCl1a5tPNJH4UcRHbR8Z5AaMin+G13g==
X-Google-Smtp-Source: AGHT+IHMWuS+7BN4bh61WDBywMSj9Ezqgg77FcygbKo5QuknhonJTuy6qi/woQZC8xQpYaI+nOiyEPSpHBqKSYD/UNg=
X-Received: by 2002:a53:8444:0:b0:636:149a:f579 with SMTP id
 956f58d0204a3-63ccb868f43mr17848748d50.23.1760479880428; Tue, 14 Oct 2025
 15:11:20 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-3-bhe@redhat.com>
 <CAGsJ_4y4CLu7qeHijhJtL+NDrehfiWpu9mtsVGxmn5rBy03v0w@mail.gmail.com>
 <aOx42iLkuyYqXBMW@MiWiFi-R3L-srv> <CAGsJ_4zSeMfiy=9Pa3A3UtdNigOc=w4eWc1KQpkBbD4AdvmPTA@mail.gmail.com>
In-Reply-To: <CAGsJ_4zSeMfiy=9Pa3A3UtdNigOc=w4eWc1KQpkBbD4AdvmPTA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 14 Oct 2025 15:11:09 -0700
X-Gmail-Original-Message-ID: <CACePvbVfRCdGaqu4SgB0MnZWUgBRDH7VJxs=XxrLfdqjU4z4Dw@mail.gmail.com>
X-Gm-Features: AS18NWD7OlH7ZMLdrAQwuxmJWYfxAKC9jRhigT44DUcti8OifRk3CGyLvMtyokQ
Message-ID: <CACePvbVfRCdGaqu4SgB0MnZWUgBRDH7VJxs=XxrLfdqjU4z4Dw@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 2/2] mm/swap: select swap device with default
 priority round robin
To: Barry Song <21cnbao@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 66DE1A0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ttsaieci75ke3apdbjxm8sff1grygk1m
X-HE-Tag: 1760479882-415954
X-HE-Meta: U2FsdGVkX19fcrcqBi1hDosC/Cf6Y7pT33cVgSpufOAUBEhLla02xmJckV9HjB64I2gA8Rw/qjL4mkJINF7KjHvHdobWfodr++zVUoYJ/Qw8u0ikR9YChVz7ghHGe2F/wdpVgLn8iT0OIwkxOuhQvBZ7vobE81sBcYpTQT/P97DvMs2VmU7jss7udKFzzk4khJVXK08VtC8jL4MzVthQKWcnpnkTVxYm2f9ojiW3sPp7s39R55g8JpM0KVH9jYD+VrX7cSafXk7b2D1SYCl+8AwwRrAuWlU6YuZ7JklImi4Ma+rzPAhuyvkSo0pVHMuNIMJUZVFR5jZz0BdDCuzvZdqyL0TRjJAPzr9d8+EGQDMNAH0IWrljUcvpVusALNeiZnTZqkbKd6Onudl7XqzYkyNPCAJ2L3jl1EStkafK6Zk+xJkzF/8nIpgKVY/LgizEQBeEQx9w3OHYr/MU9F+Jt4IGWts8TGFr9A6ZaREBIcRdTvuICwKpE4mEugpDrtq1Vi7JarJs754sy55mwQkQ/4itB3ffnNI+qtJ+eScP12eXCKBf3xnMIWf/AecnPz+a8q5q/1NxqEKpEDLEFLpc2UoQYizoZaupeHIVDpQ1aAT/cavhIBGRU5LrS2qt6XWJpoQjgdry4x6vnBJA0LpXr8gqiG7SjQWlTCtbAMd5grMbBUs98mSfZSINipGouYD8A1ftQvLQSYQ2yosd0wwMN7DpaTnnSyYhSL2/nxsj9LylxSxau0PHq4sxSTfukvGJ5Y11wJE37oGMTmPX5jB9HmfTINORi5sknDog/qZG8uxcKEZQXChyUNrnxuPmveHW5Qe/QcoEj8zo1FD+Whpiu5PD6Sv7vDGsJc8Dtv0N6AQFWomIwAn+QOPEAOL2T2oK14hd2kzy4VGZAgGsWKdnv810oTTARupPz8zZnESYQurQbkoC0qluS2DWPTB3vlHLR3G1ifCtSkPw3oqVOau
 xTIUTEJa
 nVNOITTHWgyFRiQRRv2Nh7TG7LIleCppGnL1+6v1jrvcGxWmNXYBF74jlZudo8HHgmcJmaJwfW+QKe1CwjUyP0/hgeXQzNra2T2/27UL6Rej5eW03AiUU9iG7fELOZfgnaAf26DknitiT2aM6ihltOxsGMGq6qYOUV92NlvsN2kqhr7cx9gtgGTlR4cjToOoJGf65M2L4SWNxe8pW8pfzEokQZwgpaJkUWW2d/eVSYnCK15vE6HF8xjYGs7RbsPx0TNGWgGzgIaijezsE5bmeNeVVZtU8Nnak6m/7+2OtxliJWXKtEooR8TYU3vLe8mU7GfbM31df7hzQfijREJ4cBjLiPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 12, 2025 at 11:17=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
> >
> > However, after commit a2468cc9bfdf applied, above behaviour had been
> > changed. I can give an extreme example, imagine on a system with one
> > NUMA Node, node_id is 0. Then I swapon several swap devices w/o node_id
> > value (namely node_id is -1), at last I swapon one device with node_id
> > 0. You can see the last one will have the highest priority to be chosen=
,
> > then other swap devices.
>
> I assume this adds logic to prefer swapping to the closer swapfile first,
> while still maintaining the old behavior for non-NUMA cases.

That commit a2468cc9bfdf changes the default behavior of the swapon
which does not specify a priority.
If you claim the revert breaks the user behavior, that commit also
breaks the user behavior as well.

> > So I would argue that if people realy care about the default priority,
> > it has been broken since 2017 when commit a2468cc9bfdf was introduce,
> > and complaint would be heard since long before. While we didn't hear
> > complaint, means the default priority doesn't really matter?
> > >
> > > Or if someone sets up Linux assuming that a newer swap file will only=
 be
> > > used after the older one is full, then this change would break those =
cases?
> >
> > Hmm, it could happen, but I doubt people really count on that. I would =
use
> > 'swapon -p xx' to specify explicit priority to make sure it. In the cas=
e you
> > said, swapped out pages will be swapped in, it's either not guaranteed.
>
> Personally, I also dislike the behavior where a newer swap file
> automatically gets a lower priority than an older one. However, since
> we have a rule to never break userspace, is this considered such a
> case? Or at least, do we need to update the man page as well?

See above, we should update the man page as well.

If the a2468cc9bfdf can break user default swapon behavior by
introducing node_id in the first place. It is totally justifiable to
break it again to revert it. I fail to see the logic why the breaking
rule only applies to the revert but not the commit introducing it in
the first place.

>
> BTW, we can achieve all the benefits of the round-robin =E2=80=9C18%
> efficiency boost=E2=80=9D once users set an explicit priority in userspac=
e for
> the four zRAMs you=E2=80=99re using?

Possible, it also depends on your setup. The zRAM experiment is a hack
to simulate the node_id behavior. The reason for that hack is that the
kernel does not have a node_id block device driver can use for the
node_id swapfile testing.

Back to the swapfile si->lock. Yes, that is a contented lock. It will
benefit the user if split the swapfile into a dozen of them instead of
just one.  That is even with all the swap allocator optimizations to
reduce the si->lock contention.

Chris

