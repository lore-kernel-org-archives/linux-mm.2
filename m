Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E459D41167
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21A86B0088; Thu, 15 Jan 2026 05:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5E26B008A; Thu, 15 Jan 2026 05:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87566B008C; Thu, 15 Jan 2026 05:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 955786B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:37:38 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26D441B548
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:37:38 +0000 (UTC)
X-FDA: 84333846996.09.73BA1DC
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf14.hostedemail.com (Postfix) with ESMTP id 55A4C100008
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:37:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iOq7DtjD;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768473456; a=rsa-sha256;
	cv=none;
	b=U7xzxwwDMncvqm1LyaWDzIzpdSfOiuj2x0FZfD7uz9ZuuInoCttG3/iHZ7K+fNyYPo+u1/
	nStPjMVgIk28fSG1kpn7Wp1VNaMTqDYsgLEEMNrSo/ul9aZY/dUiGn4e+G9Js9NuzCZ8QK
	VPvAWH2NtI7YIz+benYLJA/03up9HN4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iOq7DtjD;
	spf=pass (imf14.hostedemail.com: domain of safinaskar@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=safinaskar@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768473456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMHfTGtCn/Cp5rCdpRSRQAoNuPzm8mGo2uEIkJzXPew=;
	b=tpWjGSuMaT5PW9I56+8XeJCPuMyEzQ6MIJ9Tp/uF1q3MAyq1NV57CluumjqI8cm1KWv7P1
	Vw/x0gEvOnAeVPMwobb0sX0Wo6oBuHWyH7yxVO5Vde3lncytNSoJ2gs/U5H7m6OUOPnfzk
	BTqAZ5ndEU2FcaQHZtsQrN3zGLODf5A=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6455a60c11fso509126d50.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768473455; x=1769078255; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMHfTGtCn/Cp5rCdpRSRQAoNuPzm8mGo2uEIkJzXPew=;
        b=iOq7DtjDnUDVkG/DccZVZ3p9JkMuWQaJB+JyAaDHEvvVdraL4KQVaGp/QFAwshWN+8
         8z3asPWVC7+tjd3EGsAb39KEVQMEA47Uin4wv7sfP4XDTeaNQRc6mFo+liOkvqWBnvYC
         FOZrFuaq7T90Yr+LTs4Uu83JgTpTh1LI0roZ1DpjYHjEj1au1Ss83DkqPEhNNSHc3ADv
         Xf0jPs8COnAVOOoI9fWmUECSdqZ2z3NrjifSvR+25gLn1QycO+AWo8I5gzxFBRvjzafR
         Eo+G6JLKG+oDZsIuKZdgO2al+U9LdAo59K8nXHSNt1TvyuqM3AbBH7Je3Jyfj8V2qhGE
         KImw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768473455; x=1769078255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wMHfTGtCn/Cp5rCdpRSRQAoNuPzm8mGo2uEIkJzXPew=;
        b=Wn7M9ovq5z6o/Tyoa3Wj93kvCWDXq8DcjqjnmQ4eye7BZJ8okkJS2/taIjU7tPgLkg
         Qhv7VMjnm6jVVEvFUuv+mIZuLwFcKJ/Om0GypmKYapBr0vswhIPueDO3ibFK3U6RsqN6
         h5sbOlzJ6KmGegPFRPDT5RCEOMqwdWz8i/LoOR0JF9vHdchEIOHNZmWQJtgO7YykrNi/
         /gp8Eah0IqAuDQ5XMpbnT7qD0MS0BJpVSn4gBDE6AC6G0bSqxfXsNE4L4baM8cn/3PWc
         6nlBol7449RgCFZaTYqvIct/01FzLnDqrdlQKdRBW09ARntheczZK3EzF0A9YbgVnrWC
         oonw==
X-Forwarded-Encrypted: i=1; AJvYcCWKLDZ9nmrlIft8qOslm9a8zzwl3fqT2k9DRE1KRcTiA5RzdP14GL91ZxP3ye6uHHLFZ6hP7U1xPA==@kvack.org
X-Gm-Message-State: AOJu0YwW3TcpyOoFgXL3irOo/jVgET3Q6D7lP15DFdxCrQhv+zcCTQXg
	4LmaYTFxJ5ASwyUnG73E3YtZhuzBlQjhIdZc6r2+vuBFcRN5QhwaFDNGHJtsyPJS5jUjnvD7erF
	9RaQ4INQ+todcFSaMTSy/GBcSqmhM3BQ=
X-Gm-Gg: AY/fxX5RHpMyzs3v528aZr6DDXZUk5AeLsrRVIe9tk38P/Nlkd4aR1CAHo9pVlSvbD4
	jT0X0kO5zH/G7MMf7stW+/IzcizUMG+eu0CYSAVbue/jCKvSqpfJPKbJnhd5e6YX5SB/280n1D3
	8gK/HljMMeJOzUVA1rmwR/qiymLCUBY1r8mNUJbV+qOxWqFiNTk/ZiuEOTv1rJ+j6RFK4Ii3Axu
	YDrxB9t5YndXUnl4MW4Ms2HrjQ1aqG1fLgxSEDNq+BKmbJB3IFQrW4QpTm4ciTgqaE+00A=
X-Received: by 2002:a05:690e:1893:b0:646:5127:ad81 with SMTP id
 956f58d0204a3-64901b29241mr4226063d50.95.1768473455240; Thu, 15 Jan 2026
 02:37:35 -0800 (PST)
MIME-Version: 1.0
References: <3f3d871a-6a86-354f-f83d-a871793a4a47@redhat.com>
 <20251211182429.3300562-1-safinaskar@gmail.com> <eb3a9746-83a0-8271-6bd6-867ecfa49aad@redhat.com>
 <CAPnZJGAvA+SpkMeOdZx+SZG=qZxSXOThO+Or1bgw=3QqCoEDgw@mail.gmail.com> <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
In-Reply-To: <fc1d7900-3a5f-4b31-8aa3-8c8cd317d646@redhat.com>
From: Askar Safin <safinaskar@gmail.com>
Date: Thu, 15 Jan 2026 13:36:58 +0300
X-Gm-Features: AZwV_Qhtkh4Hv5K6ULjZc1z1XJ89DJDGm5amELxKsmdkaAk7JPublSpdt5t7sQM
Message-ID: <CAPnZJGBkR-ossXKGAj-62Wf-stiuWUwKQUGNo286J_jEiA+nDw@mail.gmail.com>
Subject: Re: Hard system lock-ups when using encrypted swap and RAM is exhausted
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, adrelanos@whonix.org, arraybolt3@gmail.com, 
	cryptsetup@lists.linux.dev, dm-devel@lists.linux.dev, gmazyland@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 55A4C100008
X-Stat-Signature: xffu37meoq7hauzax8ddfihxn9anhqo4
X-Rspam-User: 
X-HE-Tag: 1768473456-514439
X-HE-Meta: U2FsdGVkX19Z6gpesp5970l3g/yxWaI5NKjkLXP7iI91ktnmRMv+tsqsoXkmEDeje5gG/ho85e8mfT36ZCJnvMwQcFg7R7a/G1KOB/4k1dK/sN1eWmWjufZ6lUBv0d/1xbIGXEk0+gB/I5ppZlkULSKcUIQEtX0/Gyfuxz/eEd8jlQioJEP0myDf8dVu2i5+ut/IbSLhEQmOwlmdazR3FFUX2lubYq5BNmrWP/6wKELUNytSCupIEbQXOFGmleONai5rUVcOcuxnQfUmghTlc8AJnIPyKMWHvi8gseuU6V8MpiGSIajCgi3sTkitfl3asMsmduRblYMDSYrsungDTIYqJxU/cI9d36aj4wly1T5ccTTlMFkSm3xMQ5dN1aC4316W3Ron3/wtWA65x0BkNfuutfUdAebf11hhubzb+ybzyBi5tsGkIfC7njm2QWmlFnBgfq/zc3XEabhNt/LXR+8BZYKwH07JQxW3djvB1eFz+AEBDHJ/tJsJiQWPHknQGp400JAMN7ljM84XztilsZr/50rYeDTJKG/XHdigAah0NHTMT/s/VJ7YtEdOXLnjzjIkuizNHUJYFHzG9eS2A7oMZKm4i0HyqlabYZJ4gMoeFG14Xffwcyol0Xgv7DMehI6WEk3xNIWKifrrz2ehCvzF6bfpEZ6ADBmDt5Ix6GyipwQxt/p/rg57DOyrCIV8PYTHTNJRTxXvc6fNCMYI3EcXbCUdS97mNAe2dSmY4Fbw9bkHjY+hZ5OtuiKvDNvFrCYqs/jJWkL41JLCD/yLDF4tamj1fkO01K9HuWbvDAIj2CvJOciY+AXcb9KKGB3B+WKytT+RXGF7UYVEQzRezPi6tfkjpNWcbuRi/F9zM7CiDsiH6thlJFN+J5/8W7vMwxzvT2xzKtw+40aA4e9qNYFLPCkO/LBX/b0uLfimzz7X1FmpvTwZRQCohiTIDZNdLOuFY/UF2JOnSdKJ5d+
 gxZGJ5fb
 ysz/Wdv+NXzXbvGgETc5ZmJDg46t3RJ3xbDGUyyWE+dzBGLZEEOaBXRWCj3gV+9g1wicP+56NnOR2P12C4Mm6sB03lC9UZ07q22P0UknOG3f4fC8ZyuA2plxYKunQlGZuuYeRMBitDQF8JttrhOQh7NXeblyUxHQUdWL0tf1dmxlgL1r6CkpfKU1Ra15Xer2uEXyUcSB4CXWkFsZuIc5CYs5Fu5Uw5pZn1BSV3LS0UHqESy3wEj2oO5uF099skYHmq3p0U59HF3hfX+fT3bcVME3DCQRKBjSzBDMbUrwSIMjAfYxFXiMk8rt/+zB2TmArX69SaViHY/qlrcUfnWxkVXrVLaDkWo40BNSmMGCdKe6hf3gQdyWijLDLww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000032, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 11, 2026 at 4:34=E2=80=AFPM Zdenek Kabelac <zkabelac@redhat.com=
> wrote:
> You probably do need to configure your systemd-oom killer to prevent gett=
ing

[[ I think I know why I get this behaviour, see section "Why
dm-integrity behaves so"
below. ]]

I don't like systemd-oomd. It starts to kill processes long before
both memory and
swap is full.

Let me repeat what I need: I have big RAM and big swap. And I want OOM kill=
er
to kill processes only when absolutely necessary, i. e. when both RAM and s=
wap
is full. systemd-oomd is opposite of this: it kills processes long before t=
hat
moment, in misguided attempt to keep the system responsive.

But for me my apps are more important than responsiveness. I. e. 4 minutes =
long
freezes I talk about are lesser evil than killing everything.

So I explicitly disabled systemd-oomd on my system.

> configuration - as OOM is supposed to kill userland RAM hogging task much

I will repeat: "free -h" output at that moment showed that my RAM is full,
but swap is 23% full (87 Gb out of 378 Gb are used). So, there is
a lot of space.

> So I think you should also show whole device tree of your system and some=
 more

My system is not unusual at all. It is a laptop. With 64 Gb memory and
378 Gb swap.

I will repeat: swap is located on dm-integrity.

CPU is Intel Core i9.

> information - so there is even 'remote' chance trying to reproduce your s=
cenario.

Here are steps to reproduce:
- Take some high-specced machine. I. e. this should be machine, which
is fast, and which never experiences
slowdowns in normal situations
- Put swap on dm-integrity in journaled mode
- RAM should be 64 Gb and swap should be 378 Gb
- Open a lot of Chromium tabs until your RAM is nearly full and your
swap is 23% full
- Work at your computer for some days (play Youtube videos and perform
various other activity)
- At some point your whole computer will freeze for some time, say 4 minute=
s
- You will also notice that this happens with journaled dm-integrity
mode, but doesn't happen in non-journaled mode
- (Kernel version is 6.12.48)

I'm nearly sure that everybody will be able to successfully reproduce
this. I don't think precise device tree matters.

=3D Why dm-integrity behaves so =3D

I think I know why this happens.

- Some process needs memory, but RAM is full
- So kernel attempts to send some memory (i. e. some page) to swap
- But swap is located on top of dm-integrity
- And dm-integrity (in journaled mode) write everything twice: once to
journal and then to final place
- So dm-integrity layer at first writes that page to journal
- But journal is cached. Using so-called dm-bufio cache
- And this cache is located in RAM as opposed to disk!
- So that page is written to dm-bufio cache, which is located in memory!
- Thus this page is not actually removed from memory, it is merely
moved from one
memory place to another (!!!!!!)
- This means that the system is still short of memory (!!!!!)
- Thus kernel attempts to flush to swap more memory
- But this merely causes whole process to repeat

I think that is why I experience freezes. But I'm not sure about this.

Also, I will repeat: this is merely an experience report. I'm not
really interested
in fixing of this bug. I merely sent this report for your information.
I personally
switched to non-journaled mode, and I'm happy.

I'm okay with sharing more info about my setup. But I will not test any pat=
ches.

--
Askar Safin

