Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3EF8F01826
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E257F6B008C; Fri,  6 Mar 2026 05:29:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD37D6B0092; Fri,  6 Mar 2026 05:29:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA7476B0093; Fri,  6 Mar 2026 05:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B9A9A6B008C
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:29:47 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F1C71604C0
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:47 +0000 (UTC)
X-FDA: 84515267214.01.29F0CDC
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4F72B1C0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:29:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mw4kbSGg;
	spf=pass (imf18.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772792985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+Brq/6epKBsg4Pkewf6wjnSj/Rj8BpANFOXV5LwXOU=;
	b=Wf0H/GogTXuSM9tgfJ7sy+DLl4YRbhbrqFKItMOSoIdsi/bNnHnY1tqpMrIjZ7IB63hxiW
	DDNjhYqFHTG6Tkd6SFXehD1R9gCcaUQj7kfjdXQEobuqBa3QqsTR8bhd5f8B33pYg26YIq
	uqQrIBoQSw8pj6AT/HxMYJ+M/uVJQsQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772792985; a=rsa-sha256;
	cv=pass;
	b=fQ73xDivpUUCT5Q6ziSD8xY16z/w5gQDNU5s/3dD2miiT4/QoGL0Vgz4OSP52t5hyu3jfD
	8Wa9uSR8XKHdb9caA3/ucQr1S+bMvXCprR0vi4v9WqLApxCsbRmhDRSfOTaiDQaxUvZcxP
	9hhytzWpV8XlzWWlspqJpaUvbRidUgQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Mw4kbSGg;
	spf=pass (imf18.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-12732165d1eso9983953c88.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 02:29:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772792984; cv=none;
        d=google.com; s=arc-20240605;
        b=fsHrJc8x1nfQu3dy0EoE3+4h8dGWZyZh3x6lulDzAnuB2itzZUY0hROVKmbttYfGRI
         bEQvIxlRxMI/J+Z2zoUYIaChBy5MO91ERtmwntQplzTsoAAmYOZxMkQhkbwy8e+xODsQ
         W+7fB2G7HKEolliVAWk6nbYTLqFeYJMCjZcfqRgi2k6DecVvDSjcCMthOtY0/XH6Ii/3
         lWuMfnRR4ek0d7G2ObAztm9q/b/IzOOT8TvkvAnB85O+YjVqMWLvRR9OzvJHV+aGsDLr
         eXviYNOwHSfgYJDvqI10kdVhhztNVddazflcBun0iIoIpBTL+GmPZ+zU7fQOP8AOOJN3
         8dtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z+Brq/6epKBsg4Pkewf6wjnSj/Rj8BpANFOXV5LwXOU=;
        fh=lQcRyI4iInbH+Lz+aoedSKiyAu+mD1ZYiC5sjgMAu2A=;
        b=P8bdtlPeFN5mE/FlquPe3u+8D1Nhr42mM1Mmj7iJ5BLLGYh95q/vgWnl9DgnE6Hwut
         f4ICALeKcMSHSjozMt8XEry8hFD7DZ0xjtGTb6QmNW0ZOZEzZPrObka49UsO7b1+GClU
         FvquyRl4iFaYkJFyKdPxg1Ms6woCvYqtwwDTNLTzDGQc2sgGkDbhpCZ37VqaRPMh4JnZ
         jzXcMa8DPnuuoVX96G6xl0BdofVAcEbMO4pOBHyrRy9p5pw0DVK6BHsUNv/svn0Idm+a
         b49/HKLaBY2unHic3m9a3odLyBVmbePwhINs+nDqVJiJi3ZO5Wt+gYU+Qywo1sEgI8AG
         CucQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772792984; x=1773397784; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+Brq/6epKBsg4Pkewf6wjnSj/Rj8BpANFOXV5LwXOU=;
        b=Mw4kbSGgfWNo5kjtmZfAI0IbloVKOBmKXSnbrnKhw+vwBKztSD6JM9ey1lJJK/6wPN
         GjcewSoMIcSZexRobpCBbMAjQIrz27WCOeq9qREy+J7Ood8JeSA3856KoIoSILy+LOwg
         PwIBznifOimR6QS5Sz4CuFmx0s3voGV295Fv2D0VpVNcjolnNCk0i05AI1FJNUYcA5Q1
         CBNFY2Z7kFrCNIqis/u/QQcGLA0wbesBn5N3gbeQuRW1MgcEoMrhrquyYFuW7O/HMjNG
         QS2EuOjQLmGZ8Sl/Rqwz54f11Yx7NASWNBywlHBYU9Ltq4bP7OFT+G9VCkGn22Xl1G8w
         IAnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772792984; x=1773397784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z+Brq/6epKBsg4Pkewf6wjnSj/Rj8BpANFOXV5LwXOU=;
        b=jcwpYozFYqC5qOetofNFHPSAROZGYHWZjB2CXw4AJWtc5twgS41UHLjhAjBBfCl1sh
         fsLea0vuz5lqgK+rhEzJyjCrAOJidROKgl8I1rDj151+WT8f3J5C11xo66lteSKy2eOM
         hHkfzY7HiJqnb87iLKA+NO0GWzbzRY7/eePzpKFznUxwp0z+UaHgO08gSMkH7JJD1SJy
         ac67PBT1AcBbPIqtftV7Oltq3ITpZihVGY0/qCVISts5dGeb8PKzuTTFy1zigXYZ3t43
         A07wmNHmaJepI+a+Cz81IEjxtscGfu6DLs//b/81AApreyzHYEnaINr+9uOnNoS5bNT+
         J2Yg==
X-Forwarded-Encrypted: i=1; AJvYcCUtvsljwlFoMzUxSSQjXLU+diz8tq9asVnmLu8HlA0kTJbwHRlClJIkBFlDR8nsW6xX4N35kFg9Tg==@kvack.org
X-Gm-Message-State: AOJu0Yw75pPvU1aqEkbQH9TnHo3NZE8vKZm6DRYIqv0em820r13AR7+E
	jhUIMq37JLECSpqNxJMNkVJXkvGnaONVwExalPKOPSVU3lx6ET0IAOxU6kkUTt7KiWf8yD8DITN
	dDw8n9mI/fywJiHZS6HV+3RMS+jdI7gc=
X-Gm-Gg: ATEYQzwwAtlRP0AZ6Wr7v5yoIwl2iTYCbW7MwdFTmpSlLWd7LKWW/nFDBRSwO4jmEQ7
	er9LA09vSZVWTQNULfK+QtgXoQ1GkwL9ZaLaovsG76CwUn8ud4ZZ05KiUkSaBdfVcvhhEBPG/QE
	qHA4gSSyximGhNglWu/v4rq+5FZxmN/qM0Wzkwxri/FOB9yISJpxhF/T7d78HCDHYQnG3/rEHom
	bIIhzMrblQyIgjtnJ/kEZwp2ObpMjrTKvlHulfONyhwx0eBhD0dTWk2vBWRlLQ0XD9uUNtTt9vI
	dTT2a8ZFSoHjZpEV8FVVFxFqY6DDVWarGSZmig==
X-Received: by 2002:a05:7022:671f:b0:127:9cad:1a65 with SMTP id
 a92af1059eb24-128c2e1136amr744524c88.14.1772792983223; Fri, 06 Mar 2026
 02:29:43 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com> <20260306094459.973-1-jiakaiPeanut@gmail.com>
In-Reply-To: <20260306094459.973-1-jiakaiPeanut@gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 6 Mar 2026 11:29:32 +0100
X-Gm-Features: AaiRm53Jfg5bSHF6icJs_KFXZYY4iK_phz9SHYzN-JwsHFLACvMKwbEaczno5iQ
Message-ID: <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
Subject: Re: Question about "stateless or low-state functions" in KFuzzTest doc
To: Jiakai Xu <jiakaipeanut@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy.shevchenko@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, glider@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4r37pkwy53oad8su5ok7mf4mwr7hz6ur
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F72B1C0004
X-Rspamd-Server: rspam12
X-HE-Tag: 1772792985-8968
X-HE-Meta: U2FsdGVkX1+GFs1isXDnbwu12F8LWXIpXW8pW/T9qd0v1Fmt4z//ITOwWSQ8QAjt88xczj9/gZqw7TagZcHPGMaja6r3SJ2dBu3CaItwZLUN7rCIjnctnnsvhYlQpk9Nl9PGifhnLth4ZuGT4crA2CU3Hy5HOM6XG+lHHnwT+U2W6s4sGz6UWyD+krzir4P61HQIqet3fW9vfwOQQBiafATY75dX7JDVFaPx16Nj80wW2qFcwlvzwogZtOjrIQ1T8cpfeGwKz2OzYEmkLhst1IhvTibhWwyw9F897vztea/4YJjuXta2Yc/QqlH5yo6KeThJnCMcVJw2Jc7nlZ6L8oGVHnfKePqscsG74+tXu0BU/UVXEIziyD5f3TxxR/D6Gk2QxLhi1xCWgATw7wa3KJMExt3grByIs2ik9rnu55hF6flbf0zcUqegBxLvMW1ykRwknaZmTBAa96h5Zkd5KVR28p3SmIgS51Psb5s2uKDZ6AiJTQCMOIGkkHvqcoMBFrU+hmPM5Oh34tDf28AUokWcM49zmAa3/2XA3x8MD0d6l8J6TA2GK9ivkxkVvVhm8VdXGaHh+FKvC+AbirJ7MQfsb8JHwVCVvnp07+FyJhez09H8jymMNd90N9lKqAkOdTfcdDlaysl8TSS3RgpW53paszf94GwLEwpzdxuTIdEtWGnXIQ29gKUpXBnr7Q7AtegC5WEUER8mA74R8la93X6NNUx7bc45F4KAFJElqXl5kILas8kbmkHkkSHy7S1QPNoUI+5IN1wFuyMmf57Z3UeapzJGx0woIczEgmmqFc5Yfm7UZPD9WofqDIbyuzIzHPo+6ECQnO3KzNcD0aoUHdrn3A7+BKyDDA4aLQQQzHN4v2u1pG8cJ5olEX9x+8QW77eFUH7NLzppBbLfn04tlua1clXqUQ098j/ZAXD1EwHfpCQkrDOCYoBb7IAJFGL39k73/VGP5MSK3OB/YyZ
 4m3SuIJw
 luUgAaGXnKoKl4cwzmTLCO/POlZYd3fsT70KjYjnY+Dwe1f1w4erdrgi9GUGt45i68unBhTG+y9jD1QArtYMmCOMUgPzR+KvLG6MAqYXWXJSNZIbPiMRLGYO0T7H9C5o+CQum880htm8GJiXkwMsP3Fs/gzpbDzYKMaBiHWg3spPtpRM0JXhwyrVY61HbC6ubGcQnbC6CWfrgOQqynI1bKcVEX57IlINLL0ZQYmHTH1Lg75VTrsgDx2QkDwvCnSjpq9YnjgxS4E6kR5W8S5o+HFaq1GJX86hr95UuYckvq48gA73Cn0yRP+ZONSWSqehS9vg/gd+qL/Ao5C52EFo6a4mjso6wLLNCgBY5heUeq5ryJej9DVciNx5oxvH/ST/rm923Med8BwZSksl/NpV+SUghGBPLkP/66VHr9i8roL5CErV0zoGw+0aSqcc+MeLvyu3YYKz4cJeaynXusJpMcepviFbUqNaYGlfmVMtCDfiyX2JgPLrJezDEFfoyXmhjF4lB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail.com> =
wrote:
>
> Hi Ethan and all,

Hi Jiakai

> I've been reading the KFuzzTest documentation patch (v4 3/6) with great
> interest. I have some questions about the scope and applicability of this
> framework that I'd like to discuss with the community.
>
> The documentation states:
> > It is intended for testing stateless or low-state functions that are
> > difficult to reach from the system call interface, such as routines
> > involved in file format parsing or complex data transformations.
>
> I'm trying to better understand what qualifies as a "stateless or
> low-state function" in the kernel context. How do we define or identify
> whether a kernel function is stateless or low-state?
>
> Also, I'm curious - what proportion of kernel functions would we
> estimate falls into this category?

I would define it based on "practical heuristics". A function is probably a
good candidate for KFuzzTest if it fits these loose criteria:

- Minimal setup: KFuzzTest currently supports blob-based fuzzing, so the
  function should consume raw data (or a thin wrapper struct) and not
  require a complex web of pre-initialized objects or deep call-chain
  prerequisites.
- Manageable teardown: if the function allocates memory or creates
  objects, the fuzzing harness must be able to cleanly free or revert
  that state before the next iteration. An example of this can be found
  in the pkcs7 example in patch 5/6 [1].
- Non-destructive global impact: it's okay if the function touches global
  state in minor ways (e.g., writing to the OID registry logs as is done
  by the crypto/ functions that are fuzzed by the harnesses in patch 5/6),
  but what matters is that the kernel isn't left in a broken state before t=
he
  next fuzzing iteration, meaning no leaked global locks, no corrupted
  shared data structures, and no deadlocks.

These loose criteria are just suggestions, as you can technically fuzz
anything that you want to - KFuzzTest won't stop you. The danger is
that the kernel isn't designed to have raw userspace inputs shoved
into deep stateful functions out of nowhere. If a harness or function
relies on complex ad-hoc state management or strict preconditions,
fuzzing it out of context will likely just result in false positives, panic=
s,
and ultimately bogus harnesses.

The goal of the framework is to fuzz real functions with realistic inputs
without accidentally breaking other parts of the kernel that the function
wasn't meant to touch. Therefore ideal targets (like the PKCS7 example)
are ones with minimal setup (just passing a blob), have manageable
teardown (like freeing a returned object on success) and don't
destructively impact global state (even if they do minor things like
printing to logs).

That said, I'm curious to see what you come up with! I'm sure there are
other use cases that I haven't thought of.

[1] PKCS7 message parser fuzzing harness:
https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@gmail.c=
om/

