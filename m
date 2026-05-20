Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3146CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8736B008A; Wed, 20 May 2026 17:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB04F6B008C; Wed, 20 May 2026 17:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECFD6B0092; Wed, 20 May 2026 17:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEB3B6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:14:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D0271C1317
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:14:36 +0000 (UTC)
X-FDA: 84789052152.14.4D3BBF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4DC782000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:14:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HK/SOOl8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779311674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rF6qiFpXobWU7JpkXbQs61u2QeAi7J+W2nUaLHy7Vk=;
	b=zSNaTQ5F4CKYTQiq9wTBjGlC5zeF2b+TdxfU7w2EOwJg2XOGmR0T8dyGfUBsbusfTRdU36
	oBoUdvsKSO3wmcEuKg6huxbaOgfSH92W09e/Rcrpxv2ao75yyOho2lDW/rzzLeNyx64e7C
	FuCMzjTK/ifeHDG+xxTCOHqIHj8iH/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779311674; a=rsa-sha256;
	cv=none;
	b=C+27FEN2fI6f5mkSWFIsz1slTSTPT1Td/+xaXNu/NcqoMvtyMXmUXJ4SN8u3BXR0OyG60N
	zrK559WrDLJGpLgaZuPVvdPvLqGx98/ANtAaDMZifro6k0GUgFHfc3HTFgMtAzMFJZ1sRV
	/ULnXiZqET/BgvNw7foCsRf0HmJvpvw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HK/SOOl8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C7A544498
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 302D81F00A3E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779311673;
	bh=1rF6qiFpXobWU7JpkXbQs61u2QeAi7J+W2nUaLHy7Vk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HK/SOOl8prV9nDfcU4qR27QfrnPfAvRTe04dADtuUvM/vASUzu7erWdJn65vHYk4W
	 bMjAyFw8jd0koqYYTqCWL5jLHS8XcZFVM+/LyEnGwj77SGWYvRR04rXQOmGrntAgcn
	 0P/iTap4ezpBnCuekLA0xkC6MDE6oDtTMC7MLcKWd/AHmn0N/aeOu750e/e/80nhol
	 UKg7K7q6AP+27tw/U71YnXT8I1+gEP1D3flmj1O9i3F0KUf5DZiwCbVzoonnS4SGIV
	 gpLlyKaLa63QwhGox5IAoKUkCp0H+ALsCmUihp3rverakPWUN/meBF+cjvZIYH/FPp
	 NFKqXA8ZQ8jVw==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-913cc4d7c71so541600985a.2
        for <linux-mm@kvack.org>; Wed, 20 May 2026 14:14:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8gv6vvwT/nmOpmJ1Mx+W4zghEXvvl/lzZuDB2P/oJGG5Y+F6JQe6BITWBta5Wxog0NnXhaXDjzvQ==@kvack.org
X-Gm-Message-State: AOJu0YxtKvQNFcBJ6g6M0LcSlVQtZU26yM4yFYCNLbIi1I3dPi+Txxlc
	fu//QOA+lS5LBV3RtH65HIIJCKkQPABAmo+3rDoHB1AC0RD3sK2s9RdXfBt7jJzVhckV6jjJ0tL
	TyVa/e6qg5LUSH4svhJu08NzN7aFxJMA=
X-Received: by 2002:a05:620a:4083:b0:911:1a2c:f953 with SMTP id
 af79cd13be357-911cd75d3e6mr3875314385a.20.1779311672425; Wed, 20 May 2026
 14:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
 <agrWuDNGddNmvMFD@lucifer> <CAGsJ_4zqLfdWoTH9s7FFaqWWj0mESfikYgr7=GcV64qcuXrPxA@mail.gmail.com>
 <CAJuCfpE0WQrB3zJp9qn3jvn5DthS=ttpX7gJJvyEhA_BJGrp5g@mail.gmail.com>
 <CAGsJ_4zgeE3ebEJ+j7GJFzWVoVYHeiOn4dOoOsmWCLA6s=oECQ@mail.gmail.com>
 <5zdaa5uv5oj27q3taopl3amops57ouxgyfsdveudz4ovmbdw7z@6lwrlyvmhcp2>
 <CAGsJ_4yKxg1QugcsJi3WD0KVGJKe-zXycgm5D6cRi9vWtNcpDQ@mail.gmail.com> <ag4h87CBd-gph9zX@casper.infradead.org>
In-Reply-To: <ag4h87CBd-gph9zX@casper.infradead.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 21 May 2026 05:14:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
X-Gm-Features: AVHnY4Ipz6n3Spqx2zj00QGF2vF70GrKqLnsMaayM8MuFibnvRKE25oqOs1hwAE
Message-ID: <CAGsJ_4zA8afu0xXy0WS+tMe-eesDX1W6UBmfAsuouUpcAgK8JQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Matthew Wilcox <willy@infradead.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, Suren Baghdasaryan <surenb@google.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	david@kernel.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, 
	jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DC782000A
X-Rspamd-Server: rspam04
X-Stat-Signature: h9fgtf5qwazpagnjm9x3gi5xw5jq7t1c
X-HE-Tag: 1779311674-987133
X-HE-Meta: U2FsdGVkX18fTg5cGC/qymFQB+hu7xYMxy7f84Guzur8GJl2zw32QcFNZ1JkC1ZeJBAakU9Dc0a9SbI+bRGU+83iLP0Cji3IiF8M1Lw9YjZwhKgPYBGnAGgnEnqUbqnVCwJ4AoJGDfBPQovEfUo00+QZwywcEVIP8kUWmNFvfux5sYlm/6tvVLD6dbJoGU6OuvuLlT86i0L24guJ6a+rFTgLsVucQLnTFcK5O+0Yz2kac+xoBE3MAXoClKB5+yuUUZXmVNT7BKkMJnIMnQcYoYKFZfDIykNB6NjQyVRF2MLjyoY1/UEn3ZeqW/cSSvP1qoTqHFWvWt+6S6UMLXijY7G+7cVoU3LsHVPG06UoIYBRSP6J+rtlJ6XwqPEz84Tg2EeW2ONMlHqxxkHtdPIfW4WEyIrB2jVzsANzGccqltVHzYnCip37T2qaYNr3fjiVyJQoS3EIsSQq5M6VJQawij9dsYR7ZAOG8EDyxbRnBxaHSA2mhzYMz5NG5+pTNLbQ5bsmQX/M/2xvreQkfK3xcribe/jvZU3+bjkOUMhOL1pF9H1YR9+Gk9a8PjqG8iNQBfMOEp6m+ZgDD18FwDXLkKoMu0l97+IcoedkCKTQkVWJoWeEQFRdEu+QxcJR/daBQKkl9wtxZzuxUJtwqzLPX2hlPUi5JNCxfk0fT6ofVcwtkEkbXOFL8slcFDfqfOt9emgKC5bKVVvOoh8AG3NKtz4S0jGiqzd32/P+1tXVD8G/FSmPJIKMp3xMcy0CwSk6ppczTIQLErhNfcH5cizgYPPymGqwJanvO2hqF5B1GNKRR/d6eD/SYLymxbLJaiMgqB1FQ4Jp0BzQM4yxsNPOKgg8tX3i/38LBTsJx8AKNgn1EKZezQU8iM0tuzIGiVKpKgAftEieCCYE7YU0uQZiHhHfA+45/yLCGW/mMhR9PRbEXqKbhlA5OCwoQ8/RdzoYNH6izTTcxatV83Ag7cQ
 jn4rfwpN
 fZ19QW82qbImz02FcZ1wGr3q6EbisLbkwnkMskXwD5yDEyfRE/kJEmE9NLqIGLew2eFVfUVtdoTf5ko90wEzNsRJazCLCm4iScRQmhgV9TELs3xX8a5nvH6+kKJuaullaucpgB4SPWZvHL+4rDA/hq/6xPauv2Z5pALxgc7bt4Z6yWk9zVR12UYvdHSHjxbS36PORIRvvx/9N+ruxVwS/qkNMiVgTYb/GkurD8CKx8etxbrBR2QhK4+WS4+mqAM0m+Nw9kkD9rQvwy4YRSP4Ttbh/dFzMwTFiGm0mLId7QUf8PUdKWmIT5BXIJQyR92KzYMuExHwRGHZsIo20TcjnjZCKKx+L/Ticms/U0UAetosgOVg6BgaSL3r2Dme8lJvfWcZgB/YqFl1fROZMTgpy1q9jd2j2BPOr30A1qXi+6iTCPSlpeiMRH2UAsKhtPiUhU9rKdjbYUmew0Dw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 5:05=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, May 20, 2026 at 06:01:56AM +0800, Barry Song wrote:
> > > implied is that the per-vma locking may stall mmap_lock writes for
> > > longer than if the mmap_lock was taken in read mode?  Barry, is that
> > > correct?
> >
> > Not the case =E2=80=94 the actual situation is (if we modify the
> > current kernel to perform I/O without releasing VMA read locks):
> >
> > thread 1 PF: lock vma1 read ----  IO ----- ;
> > thread 2 PF: lock vma2 read ----- IO ----- ;
> > thread 3 PF:  lock vma3 read ---- IO ----- ;
> > thread 4 fork:  mmap_lock_write ---- lock vma1, vma2, vma3 write ;
> > thread 5 :  take mmap_lock for any read/write reason
> >
> > Now you can see that thread 4 has to wait for the I/O of
> > VMA1, VMA2, and VMA3 to complete, and thread 5 then has to
> > wait for thread 4 to release mmap_lock. Both thread 4 and
> > thread 5 can become extremely slow, because I/O may be stuck
> > anywhere in the bio/request queue or filesystem GC.
> >
> > So now we have two choices:
> >
> > 1. Change fork() to avoid taking the vma write lock for vma1/2/3 where =
possible;
> > 2. Keep the current kernel behavior and drop the VMA lock before I/O:
>
> Option 3: Say that this is a very silly thing to optimise for.  I have a
> hard time believing that any application will care about the latency of
> fork(), or the latency of page faults while it's in the middle of fork().
> Multithreaded applications just don't fork that often!

My understanding is that we should not blame applications here. This is 202=
6:
there are basically only two kinds of applications =E2=80=94 single-threade=
d and
multi-threaded =E2=80=94 and single-threaded applications are nearly extinc=
t.

