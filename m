Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC0FC61DE5
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 10:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DA46B0005; Sat, 21 Feb 2026 05:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B266B0089; Sat, 21 Feb 2026 05:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD336B008A; Sat, 21 Feb 2026 05:50:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AE216B0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 05:50:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0577B13A9BD
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 10:50:58 +0000 (UTC)
X-FDA: 84468146196.18.C0525EA
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0CB0F120005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 10:50:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=grVG2jbL;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771671056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+aReRVSH1h9SjGJ7WnDbxbUNqLv/01ztoB2jWcU4nk8=;
	b=Hql8dggAdD8/n7ptwEbnPzBCN9hxhSIkyeSR5lt+yLtEkEuRfm/svk88iAKYOh/wIn/O+l
	LU1u4SE4+YZreTNgEIpygrMk0xMsF+SyqE4QUT4KRg7DkyjPYCDwgWEKqMFSgsP46VYI50
	9ryyXPIN40dEBWU11JYZJtPER0+b6Kw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=grVG2jbL;
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771671056; a=rsa-sha256;
	cv=pass;
	b=0rqvQaFFq0nxOawswq4/QJ0I7yXJEKYCrccW11FIxQSjRMA7ksvFD7J5xBg3R3ji6EG5Rn
	emD586VuFXQiLXCFMvqbQMglc9JIDLgzceBly6blTLZHTb9lXzMrqUmQXyW+aPWEvXQcG0
	Y53RQohkatnwRiMg9FxhJuspjdcSbH8=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso3324598a12.1
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 02:50:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771671054; cv=none;
        d=google.com; s=arc-20240605;
        b=iA7bfpfzZhFCoBkp7jY0Bg4tK2oQ4Pg2bbZnxjt0br9zGW3s386b4Zwh5dTAcHO39N
         8ucZpltQJdCdfFcceR1nCs/8229706dqZ0zrNTt81PT0B+CaY7suvJ0kKW8GbRdWd4Ca
         fd+IhBlWW55o5QyQLDyMKatUnle9lolj4akwVJPtcPDXUUgvy6cLCQPsQlBC75AedGMb
         rGvFvcsyGYTeTBhBo+wV70K0D5XES/lRQg/z2WyvbHVgl65K2E5Vcmgi/ke01pVRVjWL
         ez53HcwWYiPcTczEFtQPFOh+PrCbLBKw1Nn93DlI9o6DtS+BHjJNuOd+lZo/J04Y28xW
         rWqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=+aReRVSH1h9SjGJ7WnDbxbUNqLv/01ztoB2jWcU4nk8=;
        fh=0D+G6ihJLVTciY7IUXEfF3y69R0mmh46moKlP6A0fBU=;
        b=f+T7c+ZXgXBj+WTUMRYzs/rGm2AJ9n/GeDT0JiN9dWMjuZTQ5ianViAFOADUcIeRdz
         cswyhbTvmZ+MQQA6UMWreek3ebOGg2Yh8zkz/9Goj9rolSRkRCUK5GMU+poznSSPQ4A1
         13cnoLjG60m9VVnhFRO5eehoXK2JVGI2KpSm4XmtKk9ObG7sTJsvDg+wfPuC2H1yQFEB
         pXWFyGFMYjpm/kJFnZ/7OTGsFsNW9ZNN7dTGCXa5GpAYH8jCeiNOhJRNusm2xL4RU4qC
         VkE9p3rrTmyciqeXoO86PHFxSSfctGWWOxBrZp5vR5Jir4uMWqHRPtv/KqsQx+YQw353
         f8NQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771671054; x=1772275854; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+aReRVSH1h9SjGJ7WnDbxbUNqLv/01ztoB2jWcU4nk8=;
        b=grVG2jbLm1/fiWHQ1RdidXgwc9q40xKfG9+Y4TteMn0uSV2PLP4Z9ItpsbChtbCMy9
         oT7kJHtf/fepe/Z6himBRjpJaoKMVqFLHcEixBzakOytOYeaiF5pWIruJKXVsh6fhxE5
         +Fk7sWOD5KZ1un1pB5uXi62ikFs2ZKBQXkGDbiEsmtVhzC04qNaDrZMTRFZRxlIPqj3O
         JgtVm5Mb2RzlJKHfKCdIDswLRcnjiq0FkqVs4pOsvZFdt5A/QPsa3Hvf7sTbv8s9Q0YR
         hBYlgLfN2d+H48ADaMrkqDAb3CwP3YZe7SGLLwY67OHpEhgy+PwqmOLzcri6ROYkMHNV
         XULg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771671054; x=1772275854;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+aReRVSH1h9SjGJ7WnDbxbUNqLv/01ztoB2jWcU4nk8=;
        b=seKNXoh70nts8Pj+dSz6m3p6k4hy0wj/SwWCiFfDFpOWPX5f3rP7yQzL8BYLg4WAln
         0bWnukmQlBYBR2Vx04OPYI58/KVIS9MilzOBnbNW2nbK8ufUTsTcpCu8DDaTOSwiv5ly
         WI6g130z8Q3ALD2mJCXsWLKexJK8RPpHjwayjhqMknVLwdO70CUG2RpIGaJCvU9v3hea
         Lzn+oV03QtAVCGRRPxllQ6NphltrmImA59LduDymoHDVzXbiwmL9t/lx7L9qZ9HIB5C4
         sRZ6SsYqY5YK0ghDzjCMmi5nwlvzFU2EirjrIItwOkvmRUWjmH8cs1JuDkodcY/gsUZx
         XgvA==
X-Forwarded-Encrypted: i=1; AJvYcCUXtvCqKIFQQSGUKrwaQ0RM1vz6pvl+ibYjaxGAcAllKYlAqF/khR5xP+4c6NABzR5I/PWdd6R2CA==@kvack.org
X-Gm-Message-State: AOJu0YwuydiLzWVEnrLDHyjVBSozuJoC9ZMNr5Tk1onThcYkzMtBDUi7
	UIZCmYrTILtAtkeYX58eqjsk3eM/kYnPydBkaRHZf2zV3GBV8FPb1+TVaeYpOXxdAxcv4ScbhGG
	8s/bZa4Pnf6GfmplAB7oKxWbYtp6aIi4=
X-Gm-Gg: AZuq6aKTWg8le1t5b/m7StI7fNnbG6wvhh83gfNoGpsZc/73Ez8FVNeFuPwyXARwN5e
	OxDnp1fXLAp0TbjwIbnjW9080T3aOl/fl2YgB3OhtTvllQTIqPjumVThwaSSo8P+W3GcI1CZ/gW
	exsOQZd6pxMWRqVm1q/f560sH/dNWExVpGiY2QNmfpZzCv0XJQufKl2DmGiGa4EVbEG6JwCVXsV
	irYurU56UeOUYRCvrqBkmC1x+Ym1eQ8yM3U7XSEXj2a9swmmzSd4AtJ8hkrYB4NyjoGTOvTucrD
	J8eE98v3ZXWusjki0twkC9m/3MUF2zVh0CFv4cxq
X-Received: by 2002:a17:906:eec7:b0:b87:115c:4a2b with SMTP id
 a640c23a62f3a-b9081a4c646mr157993466b.25.1771671053969; Sat, 21 Feb 2026
 02:50:53 -0800 (PST)
MIME-Version: 1.0
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 21 Feb 2026 18:50:17 +0800
X-Gm-Features: AaiRm533b9aqm5IDc5d9EWVJpodFU3COq9wX3tec_FMWzWTz_Ri3EelkS5knl5Y
Message-ID: <CAMgjq7CCcsh2twG-Ud2b4U0hZrAMV8zmvLaM=NBDvmoaWziPqg@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Swap status and roadmap discussion
To: lsf-pc@lists.linux-foundation.org
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Barry Song <21cnbao@gmail.com>, Baoquan He <bhe@redhat.com>, 
	linux-mm <linux-mm@kvack.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: a3r1qqw4ctac981hcra19qzabxpipe8q
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CB0F120005
X-HE-Tag: 1771671055-569658
X-HE-Meta: U2FsdGVkX1+HJujB7pj56wc8WfYOe3tWFoEvmB5wwnE3FwMubX+MIrULlAHB2TIvnSpCOwB5lRTn1aLneHJw5JoKskJ2diaw8Uqb1Qk6mJAtxWXSCx74Jv+Y4MXcilrGo54R0iTU4I71NS6lSkXtBHcgHfvkV9DsUJiHSGVAHQetYPkkBuMhtoTlMEGT0vwKSD8uO9QKWCDEC2o+n13fMXJn5u6p28Ha/doJbO3fGWg9ebdQhAiwOrb62A/bo26CzxBNWTkprYV+BKtkLqMBQE4yCrau9BRQpM2AE8y01SCAF+WYR2hH0Q1kAxe6yGjAVg1JXxiNVGPy6m5kyUF/9/lPqm2PiLKm5NK5wxFs+o12x+Y4C57tgMBGa3WTWI8IdG/z66XTEiz4eadREV1E1ooCnigJx4rgBC6NSnp04TzCuW6ny9droatK7G1euYnJRm+8x7V7isbWweWixUta5/dP+wY9pd9COW4335iiiuMgIVbZgeV3f0pP97/ccIykiql+lW4wvTd/wZsoJev3awNURaJxFElApAOhvOPaPpdhnXuR9L2g4NrZrsqYVgmdDW9mn9mPv3/NNHijulscGFylYQpZZ13yODca9W5Q+yDbdDVVIdXk3v9YEKefcOlBy3Cawle+vmbMYrHVCwDorleZ53wuGF2GKFyc8rF4NvohHd9eysQcjT9TDoZBuQa7hS3ElFmdD3bFJDPBjE61hCEbJf+Yo3YlY807zm+A8MlARyee4YQVP32Xb2Fz6M9Ve7BXwBp0t5mWpwuX3pBbgz6Znvl2WLN6nm3NGDINOJqBxjXpCcqpVsAANKIq0p7Yc8b6wEGF6M9ekOL3Yq0qabea+7RJmbn/ThSftovuA8MpVcyrQTZrdklsp6VYedkvJESPfYEpyfCPmSJO/4vBwStPW8mt9YAmE97Meykk827vWJyarrpxS7ze3lblGUHz+L0w4xquzoNxywgJexo
 8Q8EhNuy
 udCNeqgjHEQVr+1YF/d+NLLlHUnGF+fIS39oz8dVRklcI9W9kodLFoT0EAigliL2/TKIKSRx3oSxO7de2z4EbEPF4jQSNoILgEOEFITtlY9trapr03meH0Z+xAU7lUH4z9iiyiYMDs3Xy8EnwrkwhaTg5/GKl71bVaVBenKnqSXW5PVkx02Gf1mgMUZqvKktM4nMZmYpyJ4572wG2qF7en7ebUhTl/QZniQcUDpWIryi/4yCzRHf/Go4X9msFAsZaMjxaoSGRSJYyeRbLSVS5Oo7cNgYYWhe0V9WuV5M6UiidJP/wW+j5x73jKssQ16tXA537C20v38nLmpxosDgI8mIe7tRsiJJWhMEqCA3mR0uDCFzIoZGWU/6EosP0vRBOqisczXdv0K18uF5o0RqElaJLP14284HB00nuZ9IXpHjekBXZupERaPe7MtQNuW4l0DXEmvddtnQrFaj3WsC5nVT+kAc72IyMYfimNFj6d0JiUxW3B2v76XkSFcny+B9D/AlM401egKolY7VWvBinoYJr3K11jTp1p3tEA6iCSmQ124QhPhvg00bfE4imttoROC8Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Last year, we successfully cleaned up the swap subsystem using the swap
table design [1], and that's not the end of the story. Combined with
layered swap table, ghost swap as posted by Chris, YoungJun's swap tiering
[2] [3], and Nhat's idea of having a dynamic swap size [4], we can have a
flexible, feature-rich swap. And importantly, the overhead of both CPU and
memory will be minimal for all users in all scenarios, lower than the old
swap system. And every component is runtime optional, configurable, and
highly compatible with future features (e.g. I just noticed Baoquan's
swapops [5] which should fit well here. Swap table compaction based
on full list too).

We should be able to achieve a solution that users ranging from sub-GB
devices to TB-level servers will all benefit from.

Based on the swap table P4 RFC [6], we will achieve (see detail in that
series):
- 8 bytes per slot memory usage for plain swap.
  - And can be reduced to 3 or only 1 byte.
- 16 bytes per slot memory usage, when using ghost / virtual zswap.
  - 24 bytes at most for multi-layer.
  - And can be reduced too by simply using the same infrastructure above.
- Minimal code review or maintenance burden. All layers are using the same
  infrastructure to manage the metadata/allocation/synchronization, making
  all APIs and conventions consistent and easy to maintain.
- Every component is minimal, runtime optional and high-performance so
  existing users of ZRAM or high performance devices have literally zero
  overhead.
- The ghost / virtual swapfile has a dynamic or infinite size with no
  static data overhead.
- Migration and compaction are also easily supportable as both reverse
  mapping and reallocation are prepared.
- Highly compatible with YoungJun's swap tier, because everything is just a
  device [2] [3].
- Solves large-order swapout and minimum swap order requirements.
- The fast swapoff feature is also supported by just reading the swap entry
  into the ghost / vswap's swap cache.

And besides these, swap now has the opportunity for even further
optimizations, e.g. PG_drop for anon reclaim since swap now has a unified
convention; Reducing rmap lock contention as was once suggested by Barry
Song [7]. Growth of the static swap file can also be added later, so plain
swap on top of things like LVM can finally grow without causing memory
pressure.

And there are unsolved design decisions that need discussion, such as:
- Should we use swapon / swapoff on the virtual / ghost device? Or expose
  it in other ways, or make it on by default? Using the classical swapon /
  off provides huge flexibility; on by default is also doable and hides
  complexity.
- Should we expose special devices like /dev/xswap, or just use a dummy
  swap header file?
- How to, or should we report the usage of ghost / virtual swap devices as
  ordinary swap under /proc/swaps? We definitely need some way to report
  that.
- Is 64 bits really needed for reverse mapping? For the context, reverse
  mapping here is a swap entry recorded in a lower / physical device
  pointing to the ghost / virtual device.
- The swap device size is now just a number, to adjust that, we need an
  interface, and what kind of interface is the best choice? Or just
  make it dynamic (e.g. increase by 2M for every cluster allocated)?

Link: https://lore.kernel.org/all/CAMgjq7BvQ0ZXvyLGp2YP96+i+6COCBBJCYmjXHGBnfisCAb8VA@mail.gmail.com/
[1]
Link: https://lore.kernel.org/linux-mm/CAMgjq7BA_2-5iCvS-vp9ZEoG=1DwHWYuVZOuH8DWH9wzdoC00g@mail.gmail.com/
[2]
Link: https://lore.kernel.org/linux-mm/20260217000950.4015880-1-youngjun.park@lge.com/
[3]
Link: https://lore.kernel.org/linux-mm/20260208215839.87595-1-nphamcs@gmail.com/
[4]
Link: https://lore.kernel.org/linux-mm/aZiFvzlBJiYBUDre@MiWiFi-R3L-srv/ [5]
Link: https://lore.kernel.org/linux-mm/20260220-swap-table-p4-v1-0-104795d19815@tencent.com/
[6]
Link: https://lore.kernel.org/linux-mm/20250513084620.58231-1-21cnbao@gmail.com/
[7]

