Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BBBAC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6EB6B00CC; Mon,  6 Jul 2026 04:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586B36B00D5; Mon,  6 Jul 2026 04:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475D36B00E8; Mon,  6 Jul 2026 04:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 137B36B00CC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:28:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EB3DA030A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:27:59 +0000 (UTC)
X-FDA: 84957673878.03.90BCE45
Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9AE34100003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:27:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783326477;
	b=z+/9ZcRe2Mt0iu3TrNW5fQGDZijCHW3mfxPZzp21tYLTMTbeRsahtqGK1hCE0bTF53naE4
	7EmVzghXDrmGtLPxeRLFihWqRX5kZ+KgPtDbxl2FlwQk2aJeh+3imqF549TQhvUbVrVx1U
	Q1r1UVYzvUO6ZaVzPGQJWNHMVgqDr3A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.221.169 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783326477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A5U8eBS1xBnGHS1H48wCYYFnJ/P0Tt1uaY/u5QzxFvo=;
	b=SHG2f7X0k4JH64oXbB1pSz1HrkseysbmSYNe46Lh32rsvfIMBinqtv7G88r4gtKv8ZyVGb
	twVLfx0TJxZR+YqGCoW4CBwDMZgaNzC78zyVDkZYhOZ/8Y4hS0ZY0zkagHsja6szwij9NX
	Cu84HrnzqUo7fe2ZFMwn9KjKNicTGX0=
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-5bbd26a2729so2065411e0c.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:27:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783326477; x=1783931277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A5U8eBS1xBnGHS1H48wCYYFnJ/P0Tt1uaY/u5QzxFvo=;
        b=BLiHOWKCt1YY/i9Vi7lAhL7U4X++Bbv/M34w3S9lBAfEbd838q7Gh0r6QlKGa4s9Ae
         HSnK29jN3v+Uxi1NxinMY/AkVGRwrwbO746Ec+5Mzd+VDoxTnNzIoLzRcSWsPmlHlTqS
         SIHBxOPOLJFTsS4wgm1hrwwZSMVtnC24CI2cMFFvHnQ0C6gi474ggNL3r6zpum8/SLOY
         xmGaTWhMkCAN4hEyl9rb5wgZaKAcoICUY9HYazD03ugGb5NLMZ19NLhKPhwEFvlpyjbI
         D+d7HEzSnrr4B/nGc377LEBLTbtctLVJdsT8ml96cS4MU1D3ogYWFsp2hi8/lbzYMDsK
         YBmw==
X-Forwarded-Encrypted: i=1; AHgh+RqXVPuABrHrOo8NSBrbdW+Rwvw+RISRT3OZGsVuM7sKSjiWZX1vHhRZsTZX4ZFtEV9DIz3vPrmDYw==@kvack.org
X-Gm-Message-State: AOJu0YypdarSK90A5bhrBPDlY8ICtxpb+olzV3SA77Jr4cOzEeQNBT/T
	AEe9nLfGQlYLpCejRnGUKYKNlH1X6KhyNQGNz0Pv5zIHTSJCla3jsMdH/2K6dgZ3
X-Gm-Gg: AfdE7cnmo3LnE27z0WE2T/Y9lMqyX7h6cESPpGpaCh19TYK4cX/RdikCEOEwcqy+1DL
	bmJaLv40fQ94T9kEzvcQyApcxNjV/xBhj2ZVuekAigISen2D9exQ9h4JPHSqGphfI3xAFfWMVug
	sp9zQlbCrUu1PKy8Hw+8uiVt3pCWS5MixUGIJUSBmzZJ4bfShtevJ7xoDnVG5uPGcv6vYEZX4Bp
	Kb6muFgSpuMbxrJjcvInsI+pxZQ4116lE+CLd6x9NfKnIDYKTrQ2QJGE38x5aVGsWEFwwTB5nin
	QYu85IOvmlYcn0LTUXrGR7HysWxEYT7M8+xU/0ER0W7hcoAd5IQ3i64RVZSuYIkwLrYsNitEzId
	cygJCPwJzYfqNeLetK6Tlcbl6ySZ5rzVQBXV7oLkm3zUFawX1p2spm+O41tIkkQPei2zzrfR0pG
	98+qWr902lCVWkyCHvNxL9c42QyALnAu74L4zbB6liOjnRyFV+adKnLw==
X-Received: by 2002:a05:6102:f88:b0:738:be9e:e11b with SMTP id ada2fe7eead31-7427eb24baemr3421064137.14.1783326476620;
        Mon, 06 Jul 2026 01:27:56 -0700 (PDT)
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com. [209.85.221.178])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-73e1a447ffbsm5588830137.4.2026.07.06.01.27.55
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 01:27:55 -0700 (PDT)
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-59c9b666822so2336967e0c.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 01:27:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoF8xl5Gcl2hPfzkE6kvpsHZS/HCd8gFRDgjRFN1tO9smSY3ou2OtDaigolYYAHctYSnp07OsR2wA==@kvack.org
X-Received: by 2002:a05:6102:8689:20b0:739:15ef:cdfb with SMTP id
 ada2fe7eead31-7427cd0c4fdmr1857356137.5.1783326475557; Mon, 06 Jul 2026
 01:27:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260702012546.665383-1-thehajime@gmail.com> <20260705152708.582fd8d87561f600da23c0a7@linux-foundation.org>
 <aksn5J8Nr0JIsVpQ@casper.infradead.org> <20260705222343.5d5c78cbb54839c5efcaabf5@linux-foundation.org>
In-Reply-To: <20260705222343.5d5c78cbb54839c5efcaabf5@linux-foundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 6 Jul 2026 10:27:43 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU36O2UqfQkbbgOVSH5KFU-MZ_WO3jRsLumkUu22iC7vQ@mail.gmail.com>
X-Gm-Features: AVVi8CdT4DFWW41-N3DhAV42a0PfFvRIGJDxqXDPU_cW1gDcP61ff-stnvxXAlk
Message-ID: <CAMuHMdU36O2UqfQkbbgOVSH5KFU-MZ_WO3jRsLumkUu22iC7vQ@mail.gmail.com>
Subject: Re: [PATCH] mm: nommu: point to the write iterator upon split_vma
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, Hajime Tazaki <thehajime@gmail.com>, liam@infradead.org, 
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Greg Ungerer <gerg@uclinux.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9AE34100003
X-Stat-Signature: dwfy8mf3zmf6bbk6ieptg91n5ixnjru1
X-HE-Tag: 1783326477-197346
X-HE-Meta: U2FsdGVkX19xNDD2NEeHBJG0/MTwhFP2aV04wAdFlC3WveRRiy1XAm6cxAF7qyjnvcAOmS+G2qdF4tQqhN9lFd2sNrfJywGT8DHp6wjqMBJlrwrI7XiWrLMjufiEmCenz7tvkZNdpARRJgEk0eWnqzi1XecqQK+X83Vuo5Pw3t1kRR0Owaynan71CdZQOZ3TjWuXSzb1K6stOMq6Ak60aXEl4y1xriLhsPA7T4rbgEpJRXU/Qi0x7eRkP2rPjfdJxfM/8uZkFrhVPqkdoeeR1WxUUbE41BIbR+W5sA78n0FGdwfr9wii/tj2nXuLxKxRfQq1u8zGjpTTeQ3jcqWU17YJG36UsjBBHrBZzGwFhE6ukdAaoWk2eWZehvQsjg9vc8HPA2NCor6bvtPN9xCUK2F2UqklFeLq6qHfjGOIHICVwZHv/Kkf7rGhrpdNgWHDyRwbXHzUUx4vOgtil27SDqVva4UVVvbE2YD3ZKVQHa9svJaQNM9EoMuX1MZqrCoUyPjNMLlQLRPBGNqHWF3Ac6JGfiGOaf9TFllHK4uRVa4YMxZqLVOEYPw+/ghD0bYnA9x3Bvx2QrvHW0utr8G9Fmw5T4c1/NIZiofNpKL5MhloTutkD7TMe8rtgELa69erh5aC7Cl5qoVIqmLAJKY3X9KRvTMDexhg1GHCqCVY7dBQ/JJcU4UEgXxld5Y8HJBjcebodki0It1obIj2FC8FQnSAgusEDHp6kh7WHJTD30YUtfKsoivVa7B5oEfrJbXZqIHCEnlQ4lZLbikWmSa6Sp7pNNb8EJozH8tP/mSFgRtGIpWk5IriK2xyRdQgISJGW1C0Q/UnDl5E8RQE+vonaAPrWPM57KpAoiG+1jn1m46R/Yaoi+vYwX3bdlQdoKi9tKrAszLzGtud/tAtjqt7RvK4BwwCWLCAtqPXrdz9t9fLaI/iLmVFXVazX3VppQlbfrEpVcdUbHeb+yT9sWD
 Q5QbjNQG
 tpYwRXfswhcrb9HRC5gjHlCgNnsFBElE6N/o0P0VD7tB1o1xnWVFx7kwTVyYSU6wQKT/8rPM+6unRruXKMQaDOR87x7S6RjiauBPLFu1BHi6vBwiqArZfNsOPNad+Z6CmC148d2LUp00O8kdkxQte5jftuAXkdwjaC1giBOv3+JolikEBNlfUm19R3k+QRW7bn9Mn8aPK5hhudicA1YasVaCBHZYsZucGdXWGKTZQZfqm4gDiC3kkYQPpw7NBFLFUqZ7eMG1ByBxYNMHYmqdOHKlu57uKkbAQZ3crGwLEjxOyk/wdO2yVQx0mptYpZ7yHo+J1Yb1/rg6QnRU7pf/ruJ5njSyOF7k1L4aLlLiWl420xnrSxfQ3khXNA2MdpBm8jLX7iJ7kWmef/FKDts9gBt+jceHjvUaEXlMW0o7B6YYlzm3j9zTDAG8ICJ9UL9Oh15ad8EX1mKLSQ4n27M+0E5QKGYoZfubJAXNOq/fsm/ppczOeqfOtOcjIy5RlngBB2P4yiQ2d1mzY42FNgjOEfJBCs/5W0XJTmyMrVc9kBULiKE74IrV4E/NPTtMRiTGQGC8dsqe1CcwmcTNlSSaFnUYhTdyO9BeDpszZf9NbzFz8xwl50GtKi7t4NjETmJD8FquLTnrOx1Tlv2MFCYn7bOcRiZtMTiITb3d8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On Mon, 6 Jul 2026 at 07:23, Andrew Morton <akpm@linux-foundation.org> wrot=
e:
> On Mon, 6 Jul 2026 04:58:28 +0100 Matthew Wilcox <willy@infradead.org> wr=
ote:
> > On Sun, Jul 05, 2026 at 03:27:08PM -0700, Andrew Morton wrote:
> > > Thanks.  Unfortunately we aren't very diligent about the nommu code
> > > (are we?).   Perhaps appropriately - clearly this code doesn't get us=
ed a
> > > lot.
> >
> > Should we delete support for NOMMU?  As you say, it doesn't get much
> > testing, or presumably usage.  I have this quote from #m68k a couple of
> > years ago...
>
> Greg is busily developing kernel code.
>
> > : I looked at nommu very briefly when I had my 68000 board on the bench
> > : but didn=E2=80=99t get anywhere. Also didn=E2=80=99t try particularly=
 hard. I think
> > : you are better off with fuzix or OS9 if you want something unixy.
> >
> > (i suspect Zephyr would also be good, but it doesn't support m68k, just
> > arc, arm, arm64, mips, openrisc, renesas rx, riscv, sparc, x86 and xten=
sa)
>
> Greg, how mush use is NOMMU Linux seeing nowadays?

Nommu (SH-compatible J-Core ASIC) is used in actual products, running
modern kernels.  The rationale is low interrupt latency without using
a much more costly app CPU core + RT CPU core split.

Please watch the recording of the "32bit and-or noMMU Linux BoF"[1]
at LPC2025 for more info.

[1] https://lpc.events/event/19/contributions/2097/

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

