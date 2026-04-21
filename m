Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E152F8FA9A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 17:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A104B6B0005; Tue, 21 Apr 2026 13:18:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 999996B0089; Tue, 21 Apr 2026 13:18:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EC2C6B008A; Tue, 21 Apr 2026 13:18:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AA5B6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:18:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E42191A02CB
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:18:08 +0000 (UTC)
X-FDA: 84683221056.24.D9229F5
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id E425A4000E
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:18:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MgoK5Z0R;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776791887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E7ItgLjIpZNkuf5BX0aU2dqcjEZOqGH3BDxCcKBSagI=;
	b=hC4vWZQKecoNOQsVswQAySmMNDsVG0l2jsTOakggMbDN8pTHIzqBGx58w8Y6uwk/E3Ehe5
	uW1tlalC6HRaMVRAhDozt8OEzLM4PqKHY+wwNeHLlczxVG6LZZDwPpjNORqQt03He3ddI2
	gNKbEz/Ul8CDewe9D8XW6WZTY0f70L4=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MgoK5Z0R;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776791887; a=rsa-sha256;
	cv=pass;
	b=4Bn740zUw7+BKt71w1I4gHMVF7Q9I5m2MLz8eIhAdbQvWd8bhHSu01b7qyiS+yzJsjM7PZ
	nju0P4hWhCn44LJysOMBLGRhdLRhtYzkWIBOT01ToLsbizWzH0cGlPlNFijRaLP52xC6HF
	JWliZnVuFUUMR1mjn1HrVRedv9qqlBE=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b9358bc9c50so597472466b.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:18:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776791885; cv=none;
        d=google.com; s=arc-20240605;
        b=SZYAOXOlSHp7P/IWHfd06nuzRv1LLpum/7ZCtbyTvo6u9lfoLH+9fwFQ3gkn+0zpGs
         H8S4lsWd2aoterbm3JYsuU/xfYEWfPJfKVpX8r4oBw5mECRmG5VsVv0LLXWmel8HTBuq
         oii4/msPJBUvraqZDai+uJoS5VOe9LuVdl1IYOuxtfKwPoebTlKcjNOz2+aQ2q+P4UcZ
         1COkbROFhtXAgat8O4mnmbITljin2QoAB6HwylhQkmUB4HZTuAfFEjlQo3xAR5QrqVRu
         tqMpV5X/jjcDCoIdwv+F5wotSXpNPEwWf/6sbxtU9QJF1NVzZzZ6q2SJIRmft6xBfV8T
         9JwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=E7ItgLjIpZNkuf5BX0aU2dqcjEZOqGH3BDxCcKBSagI=;
        fh=B3DtNRNBkfxKSPs1+eQmUNhKlTeGEMJCT/xVzdywfuA=;
        b=M7EvW2EZ/uL1XvPkt3mrTtAvVY35o/WIHdpVW8bCq3vDsQo/6yWjKNMHYsxOF7NCY1
         A60dOOBRp6nbZQFDjTrbd0CEOtIze6ePaDERWhPy7B/veF32o9omi6nvh0YbzXbfsnUk
         FzeCVuOOrUpT1rPu6hgID+aSwBWsobaUy4OrJFHEfCFyIpqSfagAHOjyQnaD803gXpeu
         49Q8OgA8DV5/l1Wic8MQAHDWBImixYUgNCNv4bv5akG4gcIA+L1/OooNhYOSDJ7xVR9V
         mcrDzMnva33Rlg7Ixq7aSehR2bxa9DbMQZ1pFTpAA/MqNYX+yl2MwOy3knWop3qDHWIl
         CG/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776791885; x=1777396685; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E7ItgLjIpZNkuf5BX0aU2dqcjEZOqGH3BDxCcKBSagI=;
        b=MgoK5Z0R6peZ0SYjJt+oqitWUKaP7rgqH2HVEHFyloFiemBpZjwnsuujPoO5AWRRsi
         ySVGeQ2MbfkcAobdQ42J7PZCWga4++9LRRP/xAgKjeSW8eCtQBUsLQlBqxpuiMMpAjBd
         Lg+fo3ka4LMy0+Oyco8TqKCmZbjxWBtWI+I0IPoCEZpRWbxonHHRR0SuqNcC3IG/hOdc
         27s2Fb7XGKDjJMj1kyrctXJK+r57JjuZaE59IYO6qu9XWFVhJC8ZxOmeyb/GiJf7+QSQ
         kEy9jTcsQVZFjG241IZvR0FRbNmyv50qmDpod9ebnhuygHnwJdHA4Q8+F/oWfx1oGkYV
         NQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776791885; x=1777396685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E7ItgLjIpZNkuf5BX0aU2dqcjEZOqGH3BDxCcKBSagI=;
        b=I54+iAOKMDgb55BIQNC0eNDdmr3mniKp+4yzTRU/L62lqMqQ+e4YC5uwZ1xNLfvpjk
         Vw3quD3Zh9F25X80agYvdJJ++w1VWmRbKFgXq0Nj8mnyuAU58anerEv9X7JGVpkM8jP8
         8gO5h0AQpIrDwAHNE86/aikQXlMGsvXKn8hWrCxOgOHKTqMIFIyLDSAPwRMfUExmb3nS
         6YHPeEFtgIlytFwe0dKI6nMgsPdSX2ovzwHt3MAuERVz5DzIdhYcYcqFdCg7muy43nT9
         H7QDsim27Y2S+b6cv8rEg4kBVerKesBusX9SWHdq1HrVzgMsTxrY4AnoIMOLajjxr6oH
         kDiw==
X-Forwarded-Encrypted: i=1; AFNElJ8VResC3TvmwAEuaBNwH5ZFI6XXa3uo4bDPGzdBmTjS39knm5U86WMCtr0GgvKAkFfE3gDAtJS60A==@kvack.org
X-Gm-Message-State: AOJu0YwamppjIB0K80eoffP/hlaA3JvW8AGwN4gPua+d7wcUpwxnXAp6
	YPEcKVnOrCF02J6Pk1GRwOXKx+pGUuQAK3ezdCaEuHol55niM3el24H2IXCo6BHRyGFxAhoxi3j
	cP+M04egaLRR/tyxjM78dyKAVpTV/izQ=
X-Gm-Gg: AeBDiev3e0YHfHItSTjfYl94/apeNGLyUU2w+qMLBLg6jc/W+NypLQx6DmlXV54TJMo
	5DytnW69JIwnqcTcNrs1IrNTyCbwGKkZdfHD3mCwJRXlxYvjgeSjqAGCiT/ZYVYz5k2EGbmPQ0R
	4Vy8/HIHc90qFYS928/xp32CVRNx3UdYEJI713cUL2M1uWLRi0vbLgtz87a26LKu+0fzSq/NfXO
	Hdrqi8tLMp3yI7jMoG3CVHfFtiYx4ebntjNj7SYPsU5n0lTEKPT9ws2DGOOksdOkFqqv09/5Zwg
	e0U3lLY9soCsn5SBbxcNC1yJuJyBcs0K+4CzWdFI5jhGWqnyNww=
X-Received: by 2002:a17:907:705:b0:ba9:4db4:1671 with SMTP id
 a640c23a62f3a-ba94db416fdmr262191966b.22.1776791884727; Tue, 21 Apr 2026
 10:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com> <CAKEwX=M5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodwbf1Fe=gzew@mail.gmail.com>
In-Reply-To: <CAKEwX=M5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodwbf1Fe=gzew@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Apr 2026 01:17:28 +0800
X-Gm-Features: AQROBzBzKZZoRm3ovdQFueIgXrOTz3tmgRhk4RcaEKf7oJ2WCHZR_g8A6tDHomE
Message-ID: <CAMgjq7Ae_VH6mLQito5MFnxmp7ScZvF9xw4P-yU-yUBkPZ9_YQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Nhat Pham <nphamcs@gmail.com>
Cc: Wenchao Hao <haowenchao22@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E425A4000E
X-Stat-Signature: t4sfpybuo7hst7b8t3grzwy59xyrsxnh
X-Rspam-User: 
X-HE-Tag: 1776791886-416703
X-HE-Meta: U2FsdGVkX1+jz+6R9BUTXF6qbI3VcH1cPIoT9YW+Azr6d6oFZ2dQFO7tYzjhoWcE4u0A9AgXKosIIuznZPSaX8NTNmLy3qUaML+uiKufkNl0WOXk5Nb0ToSkw+iGdtSYtD2dZZvTtXS6srSEkTzcXQIeoeHMny4w5A84KoOGupV70oruG87lN+XeXJA+YEvGZKbcf6d7wJ2gNnlmHmCIzvNw126rz+cFcNPaPYdVWSUUJArBfcwYoHVeVN2v+MvliPwsGXHerODyB0YLQ7cmDHcI7VgOoePzbe51E6QIg5Sk0CqLVCdT2w3yLfxMCzD+FVNK+DeTPEqj2xOWn7ymX5GlXGjclMqhlGmVYa56ioanzR6InWPfAkY6cjm6P+q8z+XFIQuM41Ot+vqrAyhLc1UWya+lCfK7hpeNlxthLE8DYELWmDxctDGGFcFrD3EH3qOsPFlpMISrMsMA+HBdEoaPowVJuQlAe6weunosogqysBR0NUckDtfdUzzFejOg2ln+g85dchTBZiC3wIQ8n4vfmsuy/miPclSY8s7ttgQOXSzaACy511aPQTH1uTqoUylEBlj+hV9s4syfiWMr8ydf43h0NQF+U4Q3FtlpwLP9eyWcb3IanhZktjx75h52OdisdTh6jyKA7DLkSQL+TlBRgE2rS82FU3ABnzzOAgqKjWiFR1i08cShosqHX5hwFl66KhUB0MBYKNtaGSGdp7NcbFbuMqNzZmPYGOLi9xG8EUbFUD/aAoJ9KkLgW1Pi369x1+smvVHDUDpaucUd5UMIOrHfYxDfPyQ/V2xccKz80tuESMIkEQ2pSDUhHZDJpxwqVeKhKoFEuJjjYjD7033Rmr8Ie8o2pB+vnKzKh97tltmouXLRAvtPnn5rJOF5M9+lehGJs6WG9g1kQKdK3pv9KkS1PQ5koRH5tuptlp5kju0I/1aPR6gGmpuvrN0goJQNH4z0RVH01Bc5N0h
 Hq3Iw7mF
 /m+HhGNb57/zQIM32ldBVnoqfUZaBT/UMbke8E5qVxL0hhujYuwb8k36tSc+2Pv6BHGQdiEbSIstSu8BO0RP0X2k0GdTAbxTiz6T1Mg6LLi5jfiqDz16n8bHE05bOtf+Jm5alx/UBdFekz29HBdY16qd4RoCXBFzWV/HlDIX2rfiwWXGqbj2WB5XwMCN5AirBf6RzRbeFXu7zxBC/MBALx9GF10DmfQt+UazJpe3a7ONB1u5RUcO+rnzL8FrKi6zx4a9bPrp7Cx0I120S1/DQIjxBgTJ8ItrIE00ZvDzrFC2nbRzSlvOIxl9bAWvGETowmD3AlF8a0Bfd7TncmT5/q9iDs8PMlubkjxbaDs7U5sjLMCivAhkHp64h3MtPupKfzLuA8IFZ5rpYHc3b5eBSPYQgxYfaECH18FbSyTCVnAq+AL4yXeB2Yj6WoV76oVFg6tOs2imBbOuIfT4raLfEWDzzXGwC66R3PDx7FGPH6xkskFNxf0R0iCdLEZ0PlQqxaOaQP10txs6dkZf2Wk+xZ6JPKsEcTBLcJasbsCDfXnUrQXWYDKVjNUQz5pb4O2Qcz0GI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 11:55=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>

Thanks for adding me to the Cc list :), Barry started this idea with
ZRAM, which looks very interesting to me.

> On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > Swap freeing can be expensive when unmapping a VMA containing
> > many swap entries. This has been reported to significantly
> > delay memory reclamation during Android's low-memory killing,
> > especially when multiple processes are terminated to free
> > memory, with slot_free() accounting for more than 80% of
> > the total cost of freeing swap entries.
> >
> > Two earlier attempts by Lei and Zhiguo added a new thread in the mm cor=
e
> > to asynchronously collect and free swap entries [1][2], but the
> > design itself is fairly complex.
> >
> > When anon folios and swap entries are mixed within a
> > process, reclaiming anon folios from killed processes
> > helps return memory to the system as quickly as possible,
> > so that newly launched applications can satisfy their
> > memory demands. It is not ideal for swap freeing to block
> > anon folio freeing. On the other hand, swap freeing can
> > still return memory to the system, although at a slower
> > rate due to memory compression.
>
> Is this correct? I don't think we do decompression in
> zswap_invalidate() path. We do decompression in zswap_load(), but as a
> separate step from zswap_invalidate().

It's not about decompression. I think what Wenchao means here is that:
freeing the swap entry also releases the backing compression data, but
compared to freeing an actual folio (which bring back a free folio to
reduce memory pressure), you may need to free a lot of swap entries to
free one whole folio, because the compressed data could be much
smaller than folio and with fragmentation. And swap entry freeing is
still not fast enough to be ignored.

>
> zswap/zsmalloc entry freeing is decoupled from decompression. For
> example, on process teardown, we free the zsmalloc memory but never
> decompress (if we do then it's a bug to be fixed lol, but I doubt it).
>
> Zsmalloc freeing might not be worth as much bang-for-your-buck wise
> compared to anon folio freeing, but if it's "expensive", then I think
> that points to a different root-cause: zsmalloc's poor scalability in
> the free path.

That's a very nice insight. I had an idea previously that can we have
something like a zs free bulk? Freeing handles one by one does seem
expensive.
https://lore.kernel.org/linux-mm/adt3Q_SRToF6fb3W@KASONG-MC4/

It might be tricky to do so though.

It will be best if we can speed up everything, doing things async
doesn't reduce the total amount of work, and might cause more trouble
like worker overhead or delayed freeing causing more memory pressure,
if the workqueue didn't run in time. Or maybe a process is almost
completely swapped out, then this won't help at all.

I'm not against the async idea, they might combine well.

>
> I've stared at this code path for a bit, because my other patch series
> (vswap - see [1]) was reported to display regression on the free path
> on the usemem benchmark. And one of the issues was the contention
> between compaction (both systemwide compaction, i.e zs_page_migrate,
> and zsmalloc's internal compaction, but mostly the former).:
>
> * zs_free read-acquires pool->lock, and compaction write-acquires the
> same lock. So the compaction thread will make all zs free-ers wait for
> it. I saw this read lock delay when I perfed the free step of usemem.
>
> * If this lock has fair queue-ing semantics (I have not checked), then
> if there a compaction is behind a bunch of zs_free in the queue, then
> all the subsequent zs_free's ers are blocked :)
>
> * I'm also curious about cache-friendliness of this rwlock, bouncing
> across CPUs, if you have multiple processes being torn down
> concurrently.

That's interesting, when I mentioned zs free bulk I was thinking that,
if we have a percpu queue, at least we may try read lock that on every
enqueue, free the whole queue if successful, then release the lock.
I'm sure there are more ways to optimize that, just a random idea :)

