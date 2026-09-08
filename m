Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A99CC79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:08:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB12D6B00A5; Tue,  8 Sep 2026 12:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E62A76B00B4; Tue,  8 Sep 2026 12:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D78006B00B5; Tue,  8 Sep 2026 12:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2DED6B00A5
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:08:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53A094052B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:08:35 +0000 (UTC)
X-FDA: 85191077790.13.C444240
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4093C1A0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:08:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FsZhA4KR;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ZRky5Q4Vf1326tpyqcdGWIP2cKltS6aBzaezaZXYDY=;
	b=Tsa7pD6X2GVpjYwv5ANpxtZVNDbrq5/eUlyavn56Eun/i6GgWNR/j6fJB5PVYrPqkm4DWt
	eyKFXyITK7xb6XBtueiUkT9EqJxqJHe7asIr0Yzh+D1kAkZ1D7eYlWQaBdQozjIYMqG6c+
	GxgWiCE1rOmtZYDcbq2rm4LaThQ0Gyk=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FsZhA4KR;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788883713;
	b=RzkHeRRgmEMfaYetlvshFjkR7aj33S9TYLWoegs4tw37mFJULKWaK84dlZi/LMwwUvpH4/
	se0GNaJSU3sTjmiF6+nhoHWfzpu53udnf6da0YVBj6zaO/lL8ph9UfGNu9Dl8ZXlzevIrh
	q8JazTSaPot6olxrXVkofrMWi/mq070=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a5d8fd8d88so32236a12.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 09:08:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788883712; cv=none;
        d=google.com; s=arc-20260327;
        b=FQ2p8eMTmf/+maMuCCxfGCSjJd/JlrhGVPzZHewS7UjrEONOeI5op8BQvYBHvoGyQK
         UZLCWNOOffln5MteX6sedHy9lydNcCOCWjTfXFGfSUNcQLBCuerJT6H2BkvjuOqWynVP
         HNX5RulXs3v5ow77/YVPjYaD2sSpdtQXkFsAYA8KEKUqSsxu4PgslS98ts52OTUBWqyI
         gDz/QdWdjMeBxCBVRecUXxeGLJtMx5NsyBlTNR4+S6zjH0nlNjbBABJS9wmmYf6mVRcX
         YQvzJpXoxcKViDKO0W4AXkJoCmn9MQZAQt1ieEkCA6nfidqwAAjyLLUef2+x2EowoxKY
         pOMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2ZRky5Q4Vf1326tpyqcdGWIP2cKltS6aBzaezaZXYDY=;
        fh=5r+0qiH5G0X3p2C8XJoEU/owAjONcRTsTtkICy/Z+z8=;
        b=NuFIXTGfb8YSqybuZzqoN3lrmQJeHeZO7pk2s8YWRA4ISMP2J8bEW7F5COdhesEmlZ
         /r9B4lgagru3nY7Syv7I0V32T0nCrEWchSLVHmugdZQZWVrw61mwK2gG8583HoFzAkP4
         8crRqTyWdCKoaEiHu27SF/NVME4aQTV5a0OHWGHk2gg7MUkuJGQmxrAMv26xn8OZkdwf
         BJGJnDhJvXP42syiMjJikSqLT8SgTtYbp8BaHw73FfQcii1WM/SeDJGhPfMN/b4Xf3LI
         tpVN5LVKYRed8T/6dop34oGiaHotOwd3bQ5xbqLMKIVdZPdqw+6mswV0Z09cLnqRKF6c
         nbrw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788883712; x=1789488512; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2ZRky5Q4Vf1326tpyqcdGWIP2cKltS6aBzaezaZXYDY=;
        b=FsZhA4KR+YJgb7mYqZ1Rq+3YBh+PRoVQ/nDK6xaZ9cz3U/5RTkrq937kk29zvUja2u
         XS5P2w5bzwiNN+xrkStBtJ8ksfT6cWN1/AgZ4Qaas7AmiNVCP3NcoV0qCxrlIVdpvCAf
         adj3gCZgkXMWxz6dKtCPcfAm8lRcabrDhGDfhT80LiKOQP6kMiCiZL/OLMTgsVcgWAgI
         uY5Kog0RHIpau4zeD9yf1NtAjGeK4AbYJ4yQJsSU1ItzuI23JSd9XOVcLmGDjULjU/5v
         EynrEto8m3tjs2ZVi3j1v11rIa7GkgT12GxkiqSdb5qVlbhbhjGKUOpuyrH1Zfy5eBOp
         lkAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788883712; x=1789488512;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2ZRky5Q4Vf1326tpyqcdGWIP2cKltS6aBzaezaZXYDY=;
        b=rTg3t4Bz+VU5GCUFwK6HumQYRaI251UvmVihHzZnAN54ZxlW0tn0jGhufpvNc8dDNp
         bhfOkNpbdSZoLos1yMtxUs8tMprvEfnzXnlOLEcCSOfL255VjqADK3VtJgrrQWU04eK6
         fLbkRXf+4LxOv9xEmfzyPAyjaA2kssw519Zx3oTxcT/2o/j4DTxmDNhO7d8mG+pFW1eX
         PjDl4HDOCciZvAbLjLBl4jQTyug3EM84cZ7QYwGH+SFJsyrQnbuMQ15ZAxFMyUSunPwu
         SJmAgXaYDOO5XLnAnrbJlZppT98vK0/cQL9d4IMHGOhlq7vW54CzyH2xXgvodwdjjcit
         FG8Q==
X-Forwarded-Encrypted: i=1; AKwUvBzLl+AbarpnFmhXqUyVifUOL4Z90jCCCRTsu9+UVhMikOlWidBPv4ujABR/T82kQUIy/LNxpEGp3A==@kvack.org
X-Gm-Message-State: AFuF++lDKeDgt74JsgcKdI92YS2jR0RPBiSep7skAbUgDBacZvtFkm7O
	mWXV+d8N7VHqhxjPI2hRdPZU2XiQTmePvydLphmmCbArPLhXeWg8nct1JreIvdEcsJ9xDyRg/9j
	y3SrJpCgnHV+QMEG7ptJTHbCdy/UP/urQE3V3rqe0
X-Gm-Gg: AYBFou1rjaobiZmshS5+6KziIUdk9lARuY16eO5HXm2//cPwR5HLI1uK9MKY56gdDOE
	o6KorZntyIpMk218yDp8ns1QEjstIJtezCcQkHLjLrGDcem6uhamLCVjkjUbHos29yD4xsNTVEZ
	xXk4gR/GqsbkaDKVnBtnnTldJ7JzNkJ3ZDwuNLEP4kEfHg4Qxr1qoPfdttqVaX4LxvQrFPgu7V+
	0sKjKpYgzcFraMhT/jpU1ZbgUTXW8QA0N5jiNuNcclolOmfTzlEUKBhOa/GwDijLkdW/aM/T11Q
	WUZ24eN1+80N0u6gOc7L7+P6LyWftfmnKVJlztdv2JjExrIG/lDzcm22J8WK3nXDceAgEMmZESk
	=
X-Received: by 2002:aa7:db59:0:b0:6a6:8513:7e14 with SMTP id
 4fb4d7f45d1cf-6a98df30f3emr443a12.9.1788883710869; Tue, 08 Sep 2026 09:08:30
 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260908160452.1548235-1-xueyuan.chen21@gmail.com>
In-Reply-To: <20260908160452.1548235-1-xueyuan.chen21@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 8 Sep 2026 09:08:16 -0700
X-Gm-Features: AcwNN1X03USG0tbC7AUd4gWC5PsyFgweG67SorhUtWJ-m6PW4b2RwVrgEorognA
Message-ID: <CAJuCfpEwbMQsax4TG6egJ+nD1C0JB-tY1BZKX0LeiiNoMev7MQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] read proc/pid/smaps_rollup under per-vma lock
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, david@redhat.com, willy@infradead.org, jannh@google.com, 
	paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4093C1A0003
X-Stat-Signature: uuj83komz7hc9687bzhnj8xqq35a5qcs
X-Rspam-User: 
X-HE-Tag: 1788883713-629402
X-HE-Meta: U2FsdGVkX1+Ni7SNXIsq7aiC1ygc2SljiYodHuO8eBf1H7KqaU5Xjtyn/mhsM6OFT4YKZC8PB4tIJpuqpxPGo45bR5o6haqMOSKJUTvor96rzInqGD29UuXJlAeLxqu3ZHAw8QMsxisqAQohbL+8pnkhLDhav0uWxfjDXvq4rwaz2dXpMBjAc5TVhzRaJJTPe1fpc74raL5qmuknSw8Xp4uGX/lZzLNI3xVhI3YFZAU0pRKI/Sz5xmZD3k+LXoyG8MfjbLeGcVsGoI2dOZ+dx8EsZUu3Z3efZD5zxtr05LSJtawskWScbmqimI2gb3Gu0jIuS+SNERj3ARc4nsq8wabw0GIHtlRnGQ5U4GHmZk4eBx8aT1hLIYSDjRVdEsl6UmDujy08oy7E/7iUKb8lhLgxKFUF38UesibDyCFwHqlbiFggx1Lk8q7ZHNxB7ZSWntJn4H77vFeW7kKCZ0/tP6+JWZOaeK/2wW74NvAZIHqOdH7THrvmk7kPbWrWK6mY5UEl9MFMc3h7fKUy4QrI6S23Kgsi5T2+sVASpnmCymKXA9GOLlGg5NKy3vUyCxYFwUFjESoc6XG37GReUaosoUEqyJYnt1//pYgbXnYN5WTssX6yK8dsrlFTFsLso9fYHMMi5qaXlButIX5SsKnUvGj/M8MsY5MNXeM3CGTHmnxuAZqNnLFon7wq/RugD4zeJ6rDlUJmqWYtj3sdcxh1/KTE/BkQ/j+U7sLsS+/ULjcOZ4vGSdDjVo6ALpTQRuftw9bQo6k/4mmQ3NQst2Hw7cvdAyPTatwt15UjSm3ZrnwnnapmieEMvhtNPq+gpXDY4ymj2q53qzVrH1t/uTn0S3UQb5gUBjUyUeGZQFJ+8D3vk8ehhmofyqJUyX350c1iFdZ0Bra+V3iyDQxZ4RdoA9Z6XHkDwmwwybTMMm3Xa9m9BH7Y5oDs/Y+I9rUcTJcGEJRLEWwOGAoeUyG5pwE
 Io6Je8ak
 eD5lTkuv0mr5YUVfC7CCcXUkDuArTgkTeXTdvbxQfsmltcoqRp59jiWtDNMBJLyRQ4TxM8bqZFX3TnJ5Lec0pofXHj+GNDpfxUNa0UsAXqUAVbkfvuNe6hgSi+YzBJTL/2wEVUORm5F8SRKc+r9jx9I870Ahpy2MKHAbv1Ci5S7eff8z1QNsfgdbaN1P2h0Momg6wKxlg4tGoBFp+Amx9IPVeQ66nRqcfZzNs6d7nfiNbRZOKAIqeR3T8yhEbe4H3sdyl/3S0Pc+Bf2UUvz90vAsrHqJkX6pGE2sxEYJioF2ySE16wbOWzfhgzzMlo3cz73MjuqIWK5dAZuOyFrUcySh9wpLkt8tbchA9w99tn6QP6ARHkKa6AxYKWTsk3SDC7RqzRR2BFcJ8yT4WOaUuGQWnX3hE7oNZt+FteoirwflT290=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 8, 2026 at 9:05=E2=80=AFAM Xueyuan Chen <xueyuan.chen21@gmail.c=
om> wrote:
>
>
> On Sun, Sep 06, 2026 at 11:39:13PM -0700, Suren Baghdasaryan wrote:
> >proc/pid/smaps_rollup can be read using the combination of RCU and
> >VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> >required to safely traverse the VMA tree and VMA lock stabilizes the
> >VMA being processed and the pagetable walk.
> >Note that we have to keep the logic to drop mmap_lock on contention
> >because even when using per-VMA locks we might have to fall back to
> >holding the mmap_lock.
> >
>
> Hi Suren,
>
> I tested this series on my arm64 24-core machine, using the same
> command:
>
> run-proc-vs-map.sh --nsamples 20 --rawdata -- \
> --busyduration 2 --procfile smaps_rollup
>
> baseline:
>   Median   Minimum   Maximum
>     0.132     0.121     2.600
>     0.132     0.123     2.768
>     0.132     0.123     2.804
>     0.132     0.125     2.835
>     0.132     0.125     2.837
>     0.132     0.125     2.849
>     0.132     0.125     2.858
>     0.132     0.125     2.888
>     0.132     0.130     2.894
>     0.132     0.132     2.896
>     0.132     0.132     2.915
>     0.132     0.134     2.921
>     0.132     0.134     2.927
>     0.132     0.137     2.945
>     0.132     0.141     2.984
>     0.132     0.246     3.004
>     0.132     0.270     3.381
>     0.132     1.316     3.533
>     0.132     1.321     3.551
>     0.132     1.343     3.924
>
> patched:
>    Median   Minimum   Maximum
>     0.006     0.006     1.950
>     0.006     0.006     1.955
>     0.006     0.006     1.955
>     0.006     0.006     1.956
>     0.006     0.006     1.956
>     0.006     0.006     1.957
>     0.006     0.006     1.958
>     0.006     0.006     1.959
>     0.006     0.006     1.959
>     0.006     0.006     1.961
>     0.006     0.006     1.962
>     0.006     0.006     1.963
>     0.006     0.006     1.964
>     0.006     0.006     1.966
>     0.006     0.006     1.969
>     0.006     0.006     1.976
>     0.006     0.006     1.982
>     0.006     0.006     1.995
>     0.006     0.006     1.996
>     0.006     0.006     2.043
>
> So the median is 0.132 -> 0.006 ms, about 22x, and the worst case
> drops from 3.9 to 2.0 ms.
>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>

Thanks for the confirmation!

>
> Thanks,
> Xueyuan
>
> >The first 3 patches are cleanups making later change simpler. The main
> >change is in patch 4. Patch 5 extends existing proc-maps-race tearing
> >test to verify smaps_rollup content.
> >
> >Changes since v1 [1]
> >- removed helper functions which are not needed after per-VMA locks
> >became unconditional in [2];
> >- added a cover letter, per Lorenzo Stoakes and David Hildenbrand;
> >- removed is_mmap_lock_contended() as it's no more needed after [2],
> >per David Hildenbrand;
> >- fixed typos, per Lorenzo Stoakes and David Hildenbrand;
> >- refactored duplicate error checks, per Lorenzo Stoakes;
> >- eliminated special case of start=3D0 in smap_gather_stats(),
> >per Lorenzo Stoakes;
> >- updated comments, per Lorenzo Stoakes;
> >- moved original comment about 4 possible cases when mmap lock is
> >dropped into patch 4 changelog;
> >- added smaps_rollup testing into proc-maps-race test.
> >
> >[1] https://lore.kernel.org/all/20260606015729.1837935-1-surenb@google.c=
om/
> >[2] https://lore.kernel.org/all/20260813193433.3318288-1-surenb@google.c=
om/
> >
> >Suren Baghdasaryan (5):
> >  proc/task_mmu: remove unnecessary helpers
> >  proc/task_mmu: remove unnecessary inlines in function definitions
> >  proc/task_mmu: remove special-casing of smap_gather_stats() start
> >    parameter
> >  proc/task_mmu: read proc/pid/smaps_rollup under per-vma lock
> >  selftests/proc: add /proc/pid/smaps_rollup tearing tests
> >
> > fs/proc/task_mmu.c                            | 280 +++++++-----------
> > tools/testing/selftests/proc/proc-maps-race.c | 187 +++++++++++-
> > 2 files changed, 291 insertions(+), 176 deletions(-)
> >
> >
> >base-commit: e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
> >--
> >2.55.0.979.g7e5102b832-goog
> >
> >

