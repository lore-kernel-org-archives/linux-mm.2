Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E5CCAC5B9
	for <linux-mm@archiver.kernel.org>; Sat, 27 Sep 2025 04:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04288E0005; Sat, 27 Sep 2025 00:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3838E0001; Sat, 27 Sep 2025 00:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA558E0005; Sat, 27 Sep 2025 00:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABE1A8E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 00:46:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5819A87B85
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:46:20 +0000 (UTC)
X-FDA: 83933793720.02.B5872D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 45D0D100002
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:46:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h3/YjpvS";
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758948378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8EpzuZfoiA/X21TgMop4djwI7oF6MQwigXpkFo/6K0=;
	b=KmhzRuhA03koGqTSumD+Bz8RhbCajZ0izb/uU0Ctj+KXZMHadCz/7Y+kXLM9QksD/GBLBN
	Cuzepf3dYcybHl9mBa1YeIxvx0TSRwMnpWBtJmeZxACVOBV3WgVNaClUHZQJYP4gDpjeEl
	oBbNOyFTg3RTQnzwc8XLksOzuqIUYJA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h3/YjpvS";
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758948378; a=rsa-sha256;
	cv=none;
	b=cdVKmxn/U+tljcU6RQ6Ma4CqghYb+SJN75g+7Qg/4N44rKMXO0R0kGZ8mflP0bE5jFS9Eg
	F6Bu92wCWaTlA9QtwKGUSkH4/8SrRL/fXkMX4T7h6801Rs0NCmFPR6lszfWcIzDVPwobRp
	y0M8idjoy9H1t9m82avBX9hHFaKdyc0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C3EFF444D8
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:46:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0790C4CEE7
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 04:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758948376;
	bh=vYI/c1/8U32oh7pUdOvFd+ICMizHAKRaCVoLxUzLz3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=h3/YjpvS/TiY9u2hUMkqzi1WuiHnnVuPGDey4WEG/F53T54XioNNFVN6/Tp7m56Xy
	 /QuSP3et9SLuPmiUUm73Exzzkcw/XLj8fAEyb8DA5qZNsoouP8qmCLb0GPtTlkZn9C
	 EOnE52+c7RnH/3zABJSSerxQ0FIIdHoxfHvwInrm/6IT6CndR5jK06xdu9OLxv5Zv7
	 bWr9+6GBA0UiGkD0Ek/GrlcU+Lsx8/nA/DTQWVzQaVnCTOsrjXjgWPZwRC8pdoMPHa
	 armiz97eDY+adkH1jK/krrld5xSrPRfRn0nfrtM5RtXWvjmoulNZGGAlwjeeNjX43z
	 18ZbFc4oKThVg==
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-6360f986fb0so2277309d50.3
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 21:46:16 -0700 (PDT)
X-Gm-Message-State: AOJu0YwLL2bE9Yv2pw8ZLO0rzE5tetLCgk67N6AYCMUGC/Tkp8Edvroh
	QyxdCS57jvIIPTdcq7EdnmbFV8ev4BKH+TAr+p8PCzg8lH+uVZU2dTpqCIqPt2Uee4Yg0ksKk3H
	IzMzaiqS328tm2bAGzoskEqmj22aDYw6Igkfts8H1uQ==
X-Google-Smtp-Source: AGHT+IFSrqzTnakkgxLERTLMpW+5jb6QIg47V31ZJ/SzbZe4Xm7qEEcbIofS3VSrleSucWZRUUYJfe3txk5ri4C9EDo=
X-Received: by 2002:a05:690e:429c:10b0:636:d3c3:67e2 with SMTP id
 956f58d0204a3-636d3c36fcemr7362546d50.21.1758948375893; Fri, 26 Sep 2025
 21:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250924091746.146461-1-bhe@redhat.com> <CACePvbUhnNUgqbTUrBYoMK-VeCB1Lntkeijof8ehOz77M8H6Bg@mail.gmail.com>
 <aNShH7WWxuBEvIuh@MiWiFi-R3L-srv> <CACePvbU485gPMEvBeK2CN4Ept-zS3ZYXfcVC8Fbk83saX_2dzQ@mail.gmail.com>
 <aNaxvEiMgh+EqGjt@fedora>
In-Reply-To: <aNaxvEiMgh+EqGjt@fedora>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 26 Sep 2025 21:46:04 -0700
X-Gmail-Original-Message-ID: <CACePvbUusk1D_=bTuzB_brDNgpgmbbKUxr1fXD-EExGp=A_=dw@mail.gmail.com>
X-Gm-Features: AS18NWCKngIdNpJIkIqVPfWDpjiyxj8yjZRxJt0lH8tO-2W1RblcluUn9Fj6YSw
Message-ID: <CACePvbUusk1D_=bTuzB_brDNgpgmbbKUxr1fXD-EExGp=A_=dw@mail.gmail.com>
Subject: Re: [PATCH] mm/swapfile.c: select the swap device with default
 priority round robin
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	baohua@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	YoungJun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 45D0D100002
X-Stat-Signature: c1z15t7si3urz9yok1q5u7rcpj53jrq1
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758948378-604545
X-HE-Meta: U2FsdGVkX1/RcfKjlshR0ClpdUXtvNbnTriGLuFou1mEPAZWqgPSoZExHd0PGqzXvkalm8OfYz0ol3rmCJSt+Vtp0VCCgkPzVCK5WqWqXjtFdHAcGdHEqTdNJyd6uP9DtcoarXZJIBRzqfhUigMiPPKVbeL5FPFMLitWNqhC/M0kMjBWMNnfhNQ/VmphfV5T/AfKyUyP56lauUu7KrP08TWqy6L3r42WuW8nFGmH9fCRY5u3pY2bJKfLfZiUcqozK+Dc857tfl3FEsGB2z0R7nm2sgX3o3tXNx4cwfzQkcrowhTkHaMQvFbEQqEcfFfd4mnIWt1IwEbE3cMZI82iqWMQ/cJV9ulMy8UdCtAM6NzTOFUZiKbX6H11qiFbYsiHRTW/reXztWr8pTvio+cNHGuzzE8xPCITlbwr4E3f9FfNtNcuklzy+4EolW6DXC/oVN391pFNYQKmSEhmfaJ3tE1DHd1UBTwgy+qG/mSoIPqP0cwd+HZKzXbFW3whNs6LtYJjcFQmqFMv5HOaOwGnR+PkjpRjZuFCTZ+8Exqb1blxrh6EpaFh3TPZ4grlOa/4ijhO25OX6FFaLXGrxXPwrqjsm/tFIrDuxPynS/0KAxNs/AYc/qk/rbSBqOtf3F76Ja6iEsV+TP5PVj58dHO75YNVS5WLF7AqETAun4PJEe90NuinxG4f6ENbPCaKPZSwRPIUL1QYS8rDjtzyMV9bPkfbq5MSNwKHc1G4oyh0jlj/hTWcpEJHu7k4h1kXQErxSYVcIvwaqmg/owUboSI/a9ufGJbU+xlghz78CtPw+zgGulVauiqjyVCAptG93kN7Uw3eeCLTXyvMk0MQ5CGMBFWJ838v7+DhPXgNBJ7Hkf1mitUHvkXD9nZItinlj62LeHzi6Z3jWasFOWVWhLrxqvrvQEovAImRE0KwWmYoxwLNExRSfy1KO6X9hA/QUSq9klWMUQsNCWgBLK4B1fJ
 FZv7kgrI
 mtVMTtslc+epCfik/nI6UNYKTrtI7MpEuPPsFdeokIUqg+N8TLte5pltyHqtnm4G0/ufC+pORBWTcKY2fivnQnnS1iIyNz9QVpH8q5jlbcR3dHH5Ai2Ig4ICJ8b2IqRvmokSzZw48cKO7daN3tDSMcOSEzgOhndBxigNz37XO6nSKYDeV4Db6NcyxKgAqHWCVcNMyT9BYimvyuSE+qP4VkAu11+k5f5t0Exmjt1NpzW2Lvkx4Igsa4A1n3reez6iROHS2UYbB59LegFjmydDtK7OkQ5HS5umM79NtUdhjmQA8fjdCNWZFARgNaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 8:31=E2=80=AFAM Baoquan He <bhe@redhat.com> wrote:
> On 09/25/25 at 11:25am, Chris Li wrote:
> > Just curious, is setting to "-1" matches to kernel behavior before
> > a2468cc9bfdf, if not what is the behavior before a2468cc9bfdf.
>
> It should be like below. It's not a real output, I made the data to show
> what it looks like.
>
> # swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G 15.8G   -1
> /dev/zram1 partition  16G    0B   -2
> /dev/zram2 partition  16G    0B   -3
> /dev/zram3 partition  16G    0B   -4
>
> I just apply this patch and set the priority to emulate the kerel
> behavirour before a2468cc9bfdf. In kernel before a2468cc9bfdf, it sets
> priority to swap device from -1 downwards. There's only one
> swap_avail_head plist for all CPUs. The behaviour is very much like below=
:
>
> [root@hp-dl385g10-03 ~]# swapon
> NAME       TYPE      SIZE  USED PRIO
> /dev/zram0 partition  16G    0B    0
> /dev/zram1 partition  16G    0B    1
> /dev/zram2 partition  16G    0B    2
> /dev/zram3 partition  16G 14.3G    3

I see, in that case it is not a simple revert. It is revert plus a
change to make the default to use round robin. I suggest you split the
patch into two parts, one is the conceptual clean revert, back to the
pre a2468cc9bfdf without behavior change. Then the second one is
changed to the round robin. That will make your behavior change more
obvious.

I suspect that even pre a2468cc9bfdf, the round robin might outperform
per node priority already. Which means there exists a much simpler
solution all alone. Even though I am curious, I am not demanding the
answer from you. Your test data against the latest kernel, which shows
great performance improvement is good enough. We don't have to test
that really old kernel.

Chris

