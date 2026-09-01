Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A8A5C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734606B0088; Tue,  1 Sep 2026 14:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C746B008C; Tue,  1 Sep 2026 14:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FBF86B00A3; Tue,  1 Sep 2026 14:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 341BB6B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:13:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B535F1604A8
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:13:35 +0000 (UTC)
X-FDA: 85165991190.09.5A59E25
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf21.hostedemail.com (Postfix) with ESMTP id D0B981C0007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:13:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rmxZ+fzw;
	spf=pass (imf21.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788286413;
	b=KjbiWHcN9fKMZW5gjE/HWsD6cAMas/LZC6JTnX3SV/IojEWpeg/gIXw8g32wJlfo2Df+cz
	AFb8ubyvVE7QF5d478sTxJY/iPe8wInR0IZUTHINsd2BtaXyKH33Ed+o2IDXOZiMvKKEJY
	t4xLiVY4URgpKLASqnX9cvQ+UyvmAC4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rmxZ+fzw;
	spf=pass (imf21.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788286413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKVx3FFqSm9L/iLUNqED5EbA9fzc0BWq3+4jXNxzr+8=;
	b=Mji6CbsQ/F7ONrjNHxVmIoA7UINVzvuj0I2hkAbRwoXKfn+4vql8/uEmZHwp8aB2P4eBPl
	GsQG9f/et3nLVOWk30/KgerEgRflfEwQE8W55CQbDOz4NNqkZ981cXN14NAlyb+ttwFavR
	DHjzsC0P7zm8Rd+XppfP96SKI14iZ4c=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a6165b4402so197010a12.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 11:13:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788286412; cv=none;
        d=google.com; s=arc-20260327;
        b=X6jTUDpfRUW6mL8X427G25KMDDpcIrd1/zfPt9vPAuegJv1hBiNHvnivf6251/KCGv
         FgjxxTmzJPfpEn7ZwuYmk7UXG4filrkrEJvFAhEIrQMEQlWXSm1/vXpPD6IoGPzBiLGq
         v8dJfyrLbyLDRWUnRECSVo525hoFwL2ZIFcEhOmJBvq+vVqQVI/ctLD3mEcxr8VLFEsK
         vAMXq0kFxUIR4iWuy5QFsOUUIH9aUOpnqeaVibjGUCV5JBOEjeYC4s+wWcuFNHh9BBQx
         wJVDz8/EZZUx2d0cU9jDx3vo9+/mqndtPgJ1A5oCeIHrqhc/ES8TMXjyih6DMXT8QaYV
         lPVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xKVx3FFqSm9L/iLUNqED5EbA9fzc0BWq3+4jXNxzr+8=;
        fh=jWR0dV1wiYj1OvtXxdceEgjerUAyrRuRo5dAC0SyQ9A=;
        b=F/7z9H7wOP1RNpI/mmDjwtmDMQl8rK3j5aeXLOjO15WF/U+QKLPzhE3WWcqiTrWDCl
         8tRxpYxfKX2134qawnyfnrH7KBLBMzLrOB6A4k7QYu/OZ4cxJOyxAlAg3tYMLyfq/lVo
         oL0QxSzIgFq0DDlLICcpYpNWfvA+98LJ9nJXynbgmb3FYFa6NW1U2sFX+SRy88k3sPIf
         B7c3RpuEJoWPHRN5fLpDqAT5g94CZN3yAnL3GKxEy9Y9DPaYWMoOEIR/lX7GYkxfXNcL
         GN1ptuHyQb7T8A5+iGK5HVMiMgAz2Ypd9+BZzDW/Fn7Qpr87VKQOVani4ULifRP9UBJ2
         MEJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788286412; x=1788891212; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xKVx3FFqSm9L/iLUNqED5EbA9fzc0BWq3+4jXNxzr+8=;
        b=rmxZ+fzwSPT6Oh5ko/t1jYlQZwseRYRipRCFyLmCX4nPAFrjEYMozdVI1qP/PLLvB8
         W3F3JgGNfgKleRbHzVn7BrUmsii5yaQBBNpMYXBYVwtN5ve0mSoMJuEgfykaVlT1LQZb
         bblp7ywaxhNzopPDMp3/Ha/Hs5YuEqilubuj65R2V5RQXRZVsw95769WdjtSd2j7mAyy
         edje1y5b4hGc7obSXnsBtRbYuPzvc8NWHz9B+pDVHdA91EK6EAG5aBRAtr0Xs6710ZRu
         OdrVizV5JlAMhSEmmyUQIjm5X5HOet8OoemlIizevOF5HE+FUsOm1SXNG4FyDFOGqoZE
         7f+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788286412; x=1788891212;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xKVx3FFqSm9L/iLUNqED5EbA9fzc0BWq3+4jXNxzr+8=;
        b=QddCVw3dZ0AFIBzN5iCpUeMc/URLCwbarKa27KSgOZXSdoBimqrzwgWefd02jcqO8V
         WZVWONwDUGH09v/J+wVlMWI20X/+V9EMF8YQdWAw0vsbOzP5/a7reSYW+Susj41UweQV
         /kktDv4ShvYH9r/hxtFGk+7KOnnA4hai+gOcjLWtp5AwqWsv0bHZvczirIKEbBH3UCk9
         Uf2dw4guHIA4U2uIbmLVd2sXEXpIA7+2S2h9GEvvt3lPXRwYabvcLPOmuL1WhG49qDPf
         SWFhc59wX/CauYxNuthXDQV3am4rDzTu6M3eWOQ8HU0U+gPTkzjUyRi3NqjZfBUfAneK
         GQAg==
X-Forwarded-Encrypted: i=1; AKwUvBzZjngCXbH0den1kxvYPBPIsy8JRq9S9/DiTh9THR7fUxDmc/QbBgGW3KK4Wcj4hRiFkad1D02nnA==@kvack.org
X-Gm-Message-State: AFuF++lqzmGdqqTcFWCM3p5paV3V66We3CD/sdI37TLBvIGGuU9aJcHn
	+kMFFzlIfvbEumNSQgteVwRH3AWF3QxMDq7JwlH7yu08m16ocjk5E4eXBxBHlaYJ384J6W1CW+L
	bfhFcvdBmexm0tjfOnu4K1RKSg2iBQclY/xCK
X-Gm-Gg: AYBFou2tLgPIeL+yFZWkvuwHtCjROKDi/F76jjG0jSxjgH/F3xpDAcamrIR8PxsZxTV
	uOjcuIBvqKrNoBWw2aCsjwg9R5Jl6e30s7btD2QkJjfeyDTpRHOOpqXW9TaWMzrVX0cWmZXX6Ce
	xQfuxdA2W2a4cOd5GvAovjwou1dq8VntA3AXmar3ItMEjqUjFSgDK00fuzaW+8Dj6QxvAV0YOwE
	XKz4a2U5Bpo/hbw+EjQE6RzKTm00I1MzCcQlFmTT4HzWpC5p6PjhQ30Pr6dVdlQR0kSl1y7zlFZ
	lHiAJHETxRCtIiXyYm9a4A+NYxM7s3o8UNR7QfsUrQ==
X-Received: by 2002:a05:6402:24c9:b0:6a3:714e:f5b4 with SMTP id
 4fb4d7f45d1cf-6a60d3a5f5cmr18630295a12.9.1788286411922; Tue, 01 Sep 2026
 11:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
 <CAFLp9PEQQVuDpJPwrNvLN1-u3w3TMwZPUUrf0+rOBrvDjBBf1A@mail.gmail.com>
 <anlByPDZmvEhWeXI@casper.infradead.org> <ffcij36vnozf3rginqd2opd2dwqyki7xhtdo4veuty734hhgba@utjav2k263o6>
 <nsd.1787001235.35928@mail.gmail.com> <w7vte4itudtkw2yf4vbmuofiumfffmp2y52dpu2bqvqtdgjvpd@5femyiozss3e>
 <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com>
In-Reply-To: <CAFLp9PGkVYZcQT5qAx-RKFOF-urZ92m417zpAeF7ZQempbS1HQ@mail.gmail.com>
From: =?UTF-8?B?YXloYW4gYXlkxLFu?= <nsd.project.dev@gmail.com>
Date: Tue, 1 Sep 2026 21:13:17 +0300
X-Gm-Features: AcwNN1V22bGPbMhIlSnvavlCYf_tFkyCNbIoZKs7OuDlgoLcbih34LFhVX-fmpE
Message-ID: <CAFLp9PF_EyESt1HbBphwKgcNd5E901-bhF3sEpk-f8XTpfGBDw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Neural Storage Driver - learning page cache prefetcher
To: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: multipart/alternative; boundary="00000000000056ddc3065a6fe07d"
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D0B981C0007
X-Stat-Signature: eh91n3rs8yhp9qq14joob6s8itogqidn
X-HE-Tag: 1788286413-275113
X-HE-Meta: U2FsdGVkX18umKPk59LziRYO2BiyJULHcAM8KCvJEO5oBArEbQ9QisCx/6iZbokWJG7W2Xr0FLnXSvmyy792QByUIKR58HMdyFBlWScCBR4KdnZV0AyYqmqLtC6wgtek+LKT4ZeHBctvmMJQnGpjbHtoiwdBiote9Fo6X4fHoTcGhznNAN3uoYNzIwmcwbYfqG42GTFdBUMrj9HHF/IfYhJ32b7MqQytPkXmq5D2UqpPAOa8+8niDDw0/fdDy0l5cfZl+0daf8if63ZkV+iVJZyLjYz6YeWIcujiwlDhNYuAUAwdZnoeLUDjKknrhAyygTYhWDTtYMUNrhWtTUYYW/gAT53FOY3+c6R/FqsVa1ocuvD7KlkKu2pMjuV7JQd0+ct7aeQUZdL3J6HMdZjIjfxUc52DRKhVwzz9tCOeA4GQpm0IdpAJr9unaII3r65AivF8oqdC/XUsV1jYQaQel48IGqBfz4lYY8R1eXkS8jDazUms1qqN1S+rz//3nF2Td5pVqTMbu4klDWhkqxpz/XClJl3S8jLFRb1HEfyrGWFswM0IBoaqm2dzGBgAmzP0UJl+58Ghflm4+5e9ShRtVOTdlhRYKEu0/lCRBiYmwshCuvil9XX/itCFeltM9+OMCJ5PGeye9moHf0enkm91oFR6o6ak0YpqMsmZjTu1wC/WHzWS4QNtBjv+w3y0dv7YIB9Yt1DocnPu5q5uCBt3r3F8bA21/Bct5g+COkkmbvG4g2yX81sH7/5XewmYA4rXWbVL+3d0xfGd4njLAvxnjmAN42OKtrp6W7sZSFX6K8bvcscUxU2j1687MBkGKe18zu2MX1NMtEN5QnsQZ+TaBWTibDC431JYfD7PEOkBJmnsjlZ3aTxeZB37y9HRRuup8W2pXzhA6Mw991t/ZPA9t1fJfs0ySigf+7EJb97t9zImwBE8esx79G6r5E0loJFq4HhrsF6wx40LFkznL+E
 J18w7u3Z
 5psIXFm2FLswhLBBwiRhLxP7FEsUsP5VsghiMbDx3lFXrd6+OTJtStDng5tdLCJzC+UNMjZZj4b5Ep7XSSCJh3t4Hkp6G04Xs+QqB0t6boJCaME0M+2Ck8GYDUH0dMUj+BQRmEAPPlRwEFt32PqR3CRSVixid+4p4CvihkeecKLcaEQ8ocL90yIYR0aeeUm6MUVoYTPL9Rf6WAFa8fYmNvcblLj7NuE4+A1on6DGyonEYSBRi+0Rzg1MnWThxrDbekp9kxJ73s9du1BujqX8VvibauvByghXdpjnC9tXme09crxqMTc1d4XcajcVex/X2j0nAo3rlWYC7CpiM4o//JBg/ToM+ASssdV/+OZY2uBnAkSOrMomxRwzs3dEVuV+/l4+BVZpxqFYgkVW4l9fH8IUnljnCMgnpx50Zk/0a0rvJNvJ/Z3WAXIX4BCD3II50GKYltZng6izFzNBpXNEWpCzj4CreUAdup7WfIw+c0sQGD4YocGO2NkopSj4+iyR4kBkOaJxX+11yhOm/kfUH/h1zGjh3D/FwZ4tf38N01e7keTOpcq38DVdCl2AK90oMjKUCvyDvyDS3vlM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000056ddc3065a6fe07d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just bumping this up in your inbox curious if you had a chance to look at
the window-size matrix from the 19th, and what you think about the three
questions at the end.

Happy to run more numbers if that helps.

Best,
Ayhan


20 A=C4=9Fu 2026 Per 15:26 tarihinde ayhan ayd=C4=B1n <nsd.project.dev@gmai=
l.com>
=C5=9Funu yazd=C4=B1:

> Hi Honza, Hi Willy,
>
> Thanks for the review and for the questions =E2=80=94 they pushed us to g=
o back
> and measure this properly. Since the last exchange we ran a full
> window-size matrix with complete latency and overhead numbers, and it
> answers directly what both of you asked. Let me start with the data.
>
> These results come from our current in-development tree. We wanted to
> share them with you before pushing anything, so the tree referenced in
> the RFC (upstream-prep-v1, 2026-08-17) is still the earlier snapshot.
> Since that snapshot we made three changes that led to these numbers:
>
>   1. Jump handling =E2=80=94 when a prediction lands outside the kernel's
>      readahead window we now always issue WILLNEED|NOREUSE explicitly,
>      instead of leaving the strategy branch to decide.
>   2. Kernel-window awareness =E2=80=94 when the kernel's own readahead wi=
ndow
>      is already >=3D 1MB the module detects this and completely silences
>      itself (confirmed by its own counters), so it never competes with
>      or disturbs a kernel window that is already sufficient.
>   3. Full instrumentation =E2=80=94 per-run p50/p95/p99/p999 latency, per=
-pass
>      usr/sys CPU overhead, and disk-I/O accounting.
>
> We'll push the updated tree to GitHub once this discussion settles.
>
> Full metrics matrix =E2=80=94 methodology: interleaved ON/OFF on the same
> machine, drop_caches before every run, 3 runs per configuration, 6.2 GB
> SQLite database and an 8 GB sequential file. Disk I/O is byte-identical
> between ON and OFF in all 96 runs =E2=80=94 NSD never issues extra I/O.
>
> seq64 =E2=80=94 8 GB sequential file, 64k requests, n=3D131K/run:
>
>   kb    | OFF avg  ON avg   diff  | p50 OFF->ON  | p99 OFF->ON   |
> overhead (usr+sys)
>   128   | 22.02s   17.11s   -22%  | 50->23 us     | 812->805 us   |
> 5.94->4.33s
>   256   | 17.08s   17.22s   +1%   | 20->15 us     | 824->1129 us  |
> 4.07->4.13s
>   512   | 16.81s   16.96s   +1%   | 16->14 us     | 1092->1903 us |
> 4.24->3.60s
>   1024  | 17.25s   17.03s   -1%   | 15->16 us     | 1903->1883 us |
> 3.67->3.74s
>
> SQLite Q2 full-table scan =E2=80=94 6.2 GB:
>
>   kb    | OFF avg  ON avg   diff  | overhead (usr+sys)
>   128   | 24.51s   20.48s   -16%  | +0.95s
>   256   | 20.05s   16.60s   -17%  | +1.26s
>   512   | 15.31s   12.18s   -20%  | +1.06s
>   1024  | 12.22s   12.09s   -1%   | +0.26s
>
> random4k =E2=80=94 100k random 4k requests:
>
>   kb    | OFF avg  ON avg   diff  | p99
>   128   | 25.0s    25.5s    +2%   | ~0.98ms
>   256   | 26.9s    26.0s    -3%   | ~0.99ms
>   512   | 25.7s    25.5s    -1%   | ~0.98ms
>   1024  | 25.4s    24.7s    -3%   | ~0.99ms
>
> random_repeat =E2=80=94 100k offsets x 3 passes, n=3D300K:
>
>   kb    | OFF avg  ON avg   diff  | p99
>   128   | 26.8s    25.1s    -6%   | 0.39ms
>   256   | 25.1s    24.0s    -4%   | 0.38ms
>   512   | 24.5s    24.4s    0%    | 0.37ms
>   1024  | 25.0s    24.7s    -1%   | 0.39ms
>
> Honza, you asked whether the difference goes away at 1M =E2=80=94 and yes=
, it
> does, for both workloads. The 128k default is the dominant factor; at
> 1M the kernel alone already reaches this SSD's bandwidth ceiling, and
> NSD recognises that and silences itself entirely at >=3D 1M windows.
>
> But the 512k row is the one I'd really like your view on. The kernel
> with a 512k window alone (15.31s) trails the kernel with 1M (12.22s)
> by about 25%, yet NSD with a 512k window reaches 12.18s =E2=80=94 the sam=
e
> throughput at half the window. Our block-layer traces show OFF@512k
> keeps issuing ~512k requests, so the device is not the limit. It looks
> like the kernel's window growth is capped at ra_pages, while the
> fadvise-driven expansion NSD triggers is not =E2=80=94 which, incidentall=
y, is
> why distros end up hand-tuning this value. Is that cap deliberate, for
> latency or cache-pollution control, or is there room for the growth
> policy to self-adapt?
>
> Willy, on the architecture: hooking only vfs_read and skipping the
> fault path was a deliberate choice to bound the first iteration, but
> you're right that it's a gap =E2=80=94 filemap_fault bypasses vfs_read
> entirely, so we're currently blind to mmap'd workloads. Hooking it
> with the same fprobe is the next step. On replacing the PG_readahead
> folio marking: the matrix above convinced us this is the right
> direction. The kernel's growth policy, not the device, is the real
> bottleneck at default settings, so we're moving toward a design that
> manages ra_state directly and measures its own waste =E2=80=94 per-file
> tracking of consumed versus expired prefetches with adaptive
> aggressiveness, which is really just replacing the implicit
> assumptions behind PG_readahead marking with explicit measurement.
> Backward access patterns are already handled by the stride predictor
> (negative deltas, forward/backward counted separately); a dedicated
> backward-pattern benchmark will be added to the suite.
>
> Two things we're still working on, for honesty: at 256-512k the
> sequential p99 regresses (~0.8ms -> ~1.1ms and ~1.1ms -> ~1.9ms) as
> the prefetch regions push the device queue =E2=80=94 the usage-tracking w=
ork
> above targets exactly that. And the random_repeat gains (4-6% at
> 128-256k) suggest the predictor does help beyond what window size can
> fix; p95 there improves from 296 to 243 us.
>
> Questions we'd value your input on:
>   1. Is fadvise-driven expansion beyond ra_pages acceptable as a
>      mechanism, or should the growth policy itself change?
>   2. What would a minimal integrated design look like =E2=80=94 replacing
>      PG_readahead marking with direct ra_state control?
>   3. If we iterate: fault path first, or usage-tracking first?
>
> Per your suggestion, we'll cc the page cache maintainers from
> MAINTAINERS on the next revision.
>
> Best regards,
> Ayhan

--00000000000056ddc3065a6fe07d
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div><div dir=3D"auto">Just bumping this up in your inbox=
 curious if you had a chance to look at the window-size matrix from the 19t=
h, and what you think about the three questions at the end.</div><div dir=
=3D"auto"><br></div><div dir=3D"auto">Happy to run more numbers if that hel=
ps.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Best,</div><div dir=
=3D"auto">Ayhan</div><br><br><div class=3D"gmail_quote"><div dir=3D"ltr" cl=
ass=3D"gmail_attr">20 A=C4=9Fu 2026 Per 15:26 tarihinde ayhan ayd=C4=B1n &l=
t;<a href=3D"mailto:nsd.project.dev@gmail.com" target=3D"_blank" rel=3D"nor=
eferrer">nsd.project.dev@gmail.com</a>&gt; =C5=9Funu yazd=C4=B1:<br></div><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex">Hi Honza, Hi Willy,<br>
<br>
Thanks for the review and for the questions =E2=80=94 they pushed us to go =
back<br>
and measure this properly. Since the last exchange we ran a full<br>
window-size matrix with complete latency and overhead numbers, and it<br>
answers directly what both of you asked. Let me start with the data.<br>
<br>
These results come from our current in-development tree. We wanted to<br>
share them with you before pushing anything, so the tree referenced in<br>
the RFC (upstream-prep-v1, 2026-08-17) is still the earlier snapshot.<br>
Since that snapshot we made three changes that led to these numbers:<br>
<br>
=C2=A0 1. Jump handling =E2=80=94 when a prediction lands outside the kerne=
l&#39;s<br>
=C2=A0 =C2=A0 =C2=A0readahead window we now always issue WILLNEED|NOREUSE e=
xplicitly,<br>
=C2=A0 =C2=A0 =C2=A0instead of leaving the strategy branch to decide.<br>
=C2=A0 2. Kernel-window awareness =E2=80=94 when the kernel&#39;s own reada=
head window<br>
=C2=A0 =C2=A0 =C2=A0is already &gt;=3D 1MB the module detects this and comp=
letely silences<br>
=C2=A0 =C2=A0 =C2=A0itself (confirmed by its own counters), so it never com=
petes with<br>
=C2=A0 =C2=A0 =C2=A0or disturbs a kernel window that is already sufficient.=
<br>
=C2=A0 3. Full instrumentation =E2=80=94 per-run p50/p95/p99/p999 latency, =
per-pass<br>
=C2=A0 =C2=A0 =C2=A0usr/sys CPU overhead, and disk-I/O accounting.<br>
<br>
We&#39;ll push the updated tree to GitHub once this discussion settles.<br>
<br>
Full metrics matrix =E2=80=94 methodology: interleaved ON/OFF on the same<b=
r>
machine, drop_caches before every run, 3 runs per configuration, 6.2 GB<br>
SQLite database and an 8 GB sequential file. Disk I/O is byte-identical<br>
between ON and OFF in all 96 runs =E2=80=94 NSD never issues extra I/O.<br>
<br>
seq64 =E2=80=94 8 GB sequential file, 64k requests, n=3D131K/run:<br>
<br>
=C2=A0 kb=C2=A0 =C2=A0 | OFF avg=C2=A0 ON avg=C2=A0 =C2=A0diff=C2=A0 | p50 =
OFF-&gt;ON=C2=A0 | p99 OFF-&gt;ON=C2=A0 =C2=A0| overhead (usr+sys)<br>
=C2=A0 128=C2=A0 =C2=A0| 22.02s=C2=A0 =C2=A017.11s=C2=A0 =C2=A0-22%=C2=A0 |=
 50-&gt;23 us=C2=A0 =C2=A0 =C2=A0| 812-&gt;805 us=C2=A0 =C2=A0| 5.94-&gt;4.=
33s<br>
=C2=A0 256=C2=A0 =C2=A0| 17.08s=C2=A0 =C2=A017.22s=C2=A0 =C2=A0+1%=C2=A0 =
=C2=A0| 20-&gt;15 us=C2=A0 =C2=A0 =C2=A0| 824-&gt;1129 us=C2=A0 | 4.07-&gt;=
4.13s<br>
=C2=A0 512=C2=A0 =C2=A0| 16.81s=C2=A0 =C2=A016.96s=C2=A0 =C2=A0+1%=C2=A0 =
=C2=A0| 16-&gt;14 us=C2=A0 =C2=A0 =C2=A0| 1092-&gt;1903 us | 4.24-&gt;3.60s=
<br>
=C2=A0 1024=C2=A0 | 17.25s=C2=A0 =C2=A017.03s=C2=A0 =C2=A0-1%=C2=A0 =C2=A0|=
 15-&gt;16 us=C2=A0 =C2=A0 =C2=A0| 1903-&gt;1883 us | 3.67-&gt;3.74s<br>
<br>
SQLite Q2 full-table scan =E2=80=94 6.2 GB:<br>
<br>
=C2=A0 kb=C2=A0 =C2=A0 | OFF avg=C2=A0 ON avg=C2=A0 =C2=A0diff=C2=A0 | over=
head (usr+sys)<br>
=C2=A0 128=C2=A0 =C2=A0| 24.51s=C2=A0 =C2=A020.48s=C2=A0 =C2=A0-16%=C2=A0 |=
 +0.95s<br>
=C2=A0 256=C2=A0 =C2=A0| 20.05s=C2=A0 =C2=A016.60s=C2=A0 =C2=A0-17%=C2=A0 |=
 +1.26s<br>
=C2=A0 512=C2=A0 =C2=A0| 15.31s=C2=A0 =C2=A012.18s=C2=A0 =C2=A0-20%=C2=A0 |=
 +1.06s<br>
=C2=A0 1024=C2=A0 | 12.22s=C2=A0 =C2=A012.09s=C2=A0 =C2=A0-1%=C2=A0 =C2=A0|=
 +0.26s<br>
<br>
random4k =E2=80=94 100k random 4k requests:<br>
<br>
=C2=A0 kb=C2=A0 =C2=A0 | OFF avg=C2=A0 ON avg=C2=A0 =C2=A0diff=C2=A0 | p99<=
br>
=C2=A0 128=C2=A0 =C2=A0| 25.0s=C2=A0 =C2=A0 25.5s=C2=A0 =C2=A0 +2%=C2=A0 =
=C2=A0| ~0.98ms<br>
=C2=A0 256=C2=A0 =C2=A0| 26.9s=C2=A0 =C2=A0 26.0s=C2=A0 =C2=A0 -3%=C2=A0 =
=C2=A0| ~0.99ms<br>
=C2=A0 512=C2=A0 =C2=A0| 25.7s=C2=A0 =C2=A0 25.5s=C2=A0 =C2=A0 -1%=C2=A0 =
=C2=A0| ~0.98ms<br>
=C2=A0 1024=C2=A0 | 25.4s=C2=A0 =C2=A0 24.7s=C2=A0 =C2=A0 -3%=C2=A0 =C2=A0|=
 ~0.99ms<br>
<br>
random_repeat =E2=80=94 100k offsets x 3 passes, n=3D300K:<br>
<br>
=C2=A0 kb=C2=A0 =C2=A0 | OFF avg=C2=A0 ON avg=C2=A0 =C2=A0diff=C2=A0 | p99<=
br>
=C2=A0 128=C2=A0 =C2=A0| 26.8s=C2=A0 =C2=A0 25.1s=C2=A0 =C2=A0 -6%=C2=A0 =
=C2=A0| 0.39ms<br>
=C2=A0 256=C2=A0 =C2=A0| 25.1s=C2=A0 =C2=A0 24.0s=C2=A0 =C2=A0 -4%=C2=A0 =
=C2=A0| 0.38ms<br>
=C2=A0 512=C2=A0 =C2=A0| 24.5s=C2=A0 =C2=A0 24.4s=C2=A0 =C2=A0 0%=C2=A0 =C2=
=A0 | 0.37ms<br>
=C2=A0 1024=C2=A0 | 25.0s=C2=A0 =C2=A0 24.7s=C2=A0 =C2=A0 -1%=C2=A0 =C2=A0|=
 0.39ms<br>
<br>
Honza, you asked whether the difference goes away at 1M =E2=80=94 and yes, =
it<br>
does, for both workloads. The 128k default is the dominant factor; at<br>
1M the kernel alone already reaches this SSD&#39;s bandwidth ceiling, and<b=
r>
NSD recognises that and silences itself entirely at &gt;=3D 1M windows.<br>
<br>
But the 512k row is the one I&#39;d really like your view on. The kernel<br=
>
with a 512k window alone (15.31s) trails the kernel with 1M (12.22s)<br>
by about 25%, yet NSD with a 512k window reaches 12.18s =E2=80=94 the same<=
br>
throughput at half the window. Our block-layer traces show OFF@512k<br>
keeps issuing ~512k requests, so the device is not the limit. It looks<br>
like the kernel&#39;s window growth is capped at ra_pages, while the<br>
fadvise-driven expansion NSD triggers is not =E2=80=94 which, incidentally,=
 is<br>
why distros end up hand-tuning this value. Is that cap deliberate, for<br>
latency or cache-pollution control, or is there room for the growth<br>
policy to self-adapt?<br>
<br>
Willy, on the architecture: hooking only vfs_read and skipping the<br>
fault path was a deliberate choice to bound the first iteration, but<br>
you&#39;re right that it&#39;s a gap =E2=80=94 filemap_fault bypasses vfs_r=
ead<br>
entirely, so we&#39;re currently blind to mmap&#39;d workloads. Hooking it<=
br>
with the same fprobe is the next step. On replacing the PG_readahead<br>
folio marking: the matrix above convinced us this is the right<br>
direction. The kernel&#39;s growth policy, not the device, is the real<br>
bottleneck at default settings, so we&#39;re moving toward a design that<br=
>
manages ra_state directly and measures its own waste =E2=80=94 per-file<br>
tracking of consumed versus expired prefetches with adaptive<br>
aggressiveness, which is really just replacing the implicit<br>
assumptions behind PG_readahead marking with explicit measurement.<br>
Backward access patterns are already handled by the stride predictor<br>
(negative deltas, forward/backward counted separately); a dedicated<br>
backward-pattern benchmark will be added to the suite.<br>
<br>
Two things we&#39;re still working on, for honesty: at 256-512k the<br>
sequential p99 regresses (~0.8ms -&gt; ~1.1ms and ~1.1ms -&gt; ~1.9ms) as<b=
r>
the prefetch regions push the device queue =E2=80=94 the usage-tracking wor=
k<br>
above targets exactly that. And the random_repeat gains (4-6% at<br>
128-256k) suggest the predictor does help beyond what window size can<br>
fix; p95 there improves from 296 to 243 us.<br>
<br>
Questions we&#39;d value your input on:<br>
=C2=A0 1. Is fadvise-driven expansion beyond ra_pages acceptable as a<br>
=C2=A0 =C2=A0 =C2=A0mechanism, or should the growth policy itself change?<b=
r>
=C2=A0 2. What would a minimal integrated design look like =E2=80=94 replac=
ing<br>
=C2=A0 =C2=A0 =C2=A0PG_readahead marking with direct ra_state control?<br>
=C2=A0 3. If we iterate: fault path first, or usage-tracking first?<br>
<br>
Per your suggestion, we&#39;ll cc the page cache maintainers from<br>
MAINTAINERS on the next revision.<br>
<br>
Best regards,<br>
Ayhan</blockquote></div></div></div>

--00000000000056ddc3065a6fe07d--

