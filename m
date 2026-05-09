Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FD35CD343F
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 08:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3ED6B030C; Sat,  9 May 2026 04:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7753B6B030D; Sat,  9 May 2026 04:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6635F6B030E; Sat,  9 May 2026 04:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 527CB6B030C
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:45:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFC091C04A5
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:45:54 +0000 (UTC)
X-FDA: 84747248628.03.92BE2A3
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id C57B0140003
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:45:52 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=exhVSmtt;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778316352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LEEs85gLt8c41rfe6nkdoU4jx5WLcVvqOUISi8My+7k=;
	b=e24NTs+6R6Z3czlgsDE64BnqkpMUyYd6yW8h8mVJnEudF9aNQu7UCgXTVS2GNW8m9tVXjV
	oC59vJBdNUgbPu1DfYwIouPvgeM5HpUiExU2chVAF8oXSSlhZ8dFQIlI64w9rtJsPyphCC
	64ZXBI1hajczGnCU222iIGy0Cj/ctdg=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=exhVSmtt;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778316352; a=rsa-sha256;
	cv=pass;
	b=Uo2gqFr3bYBjPQLRLqGu3eMn6rNv3HXaGEmm01viBlxnbICXJAHo3w+mVsJlXfiXU9xkTT
	AEsBWHrKRRTNMgdcOebu6prSqN75ImjygUXlCCDdwAk1T0hfSTuTc8X/rhE2JX+ZMucX8Y
	rgQFlvrglge1Nb7rjWRSe/culCZH6/c=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-654672a6d68so2979985d50.0
        for <linux-mm@kvack.org>; Sat, 09 May 2026 01:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778316352; cv=none;
        d=google.com; s=arc-20240605;
        b=VDysv3zJnahDszDB98x+U1xJ66fWcrqSCxv1fCFemFgEGd49ui5cH4EDdngq4qh2e1
         xWVxdnI6V4JmVHh9PVMac9PcG2Q8NNO9CbQG6I4I848fDRU1QcVBKHo2a0eWVYeFTbZD
         3FdSJAP0+oApQYF7/3tw6v0VBVYsTeRb7/uMOonnQzKvJeqA4vWWP7qyEgFF+efSGwUv
         7UnwVNahqXaLIdPP2oYnXzXxYyeQcB7DCUG7om2fzpo8zLTgyrlneQj7j/hMRSXJB7CL
         Juaa0y1Mw8+Ywf+SXxfmxCvtrVFNjyDvwZgQdxkEfXxaXrc3BZoXY2afyHwnTxVRrY7z
         95bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LEEs85gLt8c41rfe6nkdoU4jx5WLcVvqOUISi8My+7k=;
        fh=Xh7j9AcN3Uw6QfhB6PJBFiSVMkZvjMDd7nOUx9ByOKc=;
        b=WySwOm1xjazbveETTEcNWQNWzLbWbgE7IsFXSEOpxm/rbJJHjr3nhU2GhZvpnsfqWz
         j4VXqkuoYwJxvGvmHdJ/H64Pdr75WAruAn6i5yNqEOJU8mTEPg+qbm0bdITQUop6OD82
         h7rdbRJ1MNO1it7GE81LxZ7+4DhkiyIHUe1ui4g00pXsexxIPMZHIVRvku610zIlh23X
         30zpvuh+1FkcCZHjpN53YidPbJkZzy+k3427Xuph04l1MbDLbQKG8MhoaJuPJWICHXPE
         lz/hugPd6QxWZh9htNjocDgoI4S+cKve6wgKpT8avP9gMCXz2d4c/1KMSsxXbfa+P3+f
         8WhQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778316352; x=1778921152; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LEEs85gLt8c41rfe6nkdoU4jx5WLcVvqOUISi8My+7k=;
        b=exhVSmttGkxPUy0QA5VmfFkfeaBhJjvTunCaIDEqSjsEC3XYxYKS2R/g4kHP+1FVjW
         6jOAZKuAehWhRy0nQqIaE/NSJq6t7xsvdTGuwhKYnPTRsxsutNQPbs3mtyyeEnhDd+oH
         QgAe0M5bqpoDRkzhCalVIvOcMy4GLUVf/9DVlpi4Sxyl203FuOs2ysehaK02vQsZ9wzZ
         Gin8QLFBBbYH53LRSxY1QVmFqfwzc7QM2A0MyN/EMnUPDvRNJud9Mt834iNoYnSm94e1
         XjMQwmNDOC8UaRd9Au6H1zobHXe997q0YHXYN6ARgnzCsu6Ney8bJUtYGmEHp60f6LZG
         rMlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778316352; x=1778921152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LEEs85gLt8c41rfe6nkdoU4jx5WLcVvqOUISi8My+7k=;
        b=hTizlc5sPcbFsRD177BJlCtYhJPpC2xZDbIv0k0/sASh4qlXoPRyXK9RpFV/4dQUd0
         /xTpWd/ugqp74dMsMTsZNTjSaCvc2R0IC/SkArj1QhOkqIQNRy/ox0AFk6qPlMARHxyQ
         uC7XwESBSdtwFr1znYFP5iM761093MjXNFlolrNG2ZD1U++Pk/MXQ32NWG/LHogq8MTk
         pd6JhpA6htmvdbVScdnxcVcVtTAKkR8RxkSL3xu7cUzguuH6ZoeJAG74NNuvaAELRsjm
         KuYsh5E20SXSk4LhD7rn6Ju1DPoAQYaOcLff6Tp9L9iLUZmAmQJi3gCnI+70D8AE2eUs
         ouQw==
X-Forwarded-Encrypted: i=1; AFNElJ8rDL7lRrveAQO10qh5Uf3UNTkaC9jz0q2aDwKdtUKaoBvFOce74knpB4K47OBGNFXryjUbFYjDog==@kvack.org
X-Gm-Message-State: AOJu0Yz517Q48w9ikC7wOTSi727qoE4SxGO/V8xh6oZTpAnsiip4oPLI
	FPmRvqUULF8+4TibrNlEuDTJ+BxqDiePaNz5vashfn5SaTw71IpPWreQpYAOgu7utc3kl3TzeHE
	0hMnpfWNxxwFBvQq3ZUfzwrv1ju+TtIw=
X-Gm-Gg: Acq92OH/bs+WGSaeBHL6TMsE/oQuEtQk69BaxkSoT9I+9mZMB4BnVCKGeFk0IfBilRt
	rOfF+rAHcdzdiObLAbiUbivbrXO4Cn0xLM7X9IJAHm65LBianK9zZc4NDX+dNjlRj4vcdNleX73
	QI6TMOEKIv6BM+W8qojFqmy0WqEpUjTQzao82yl1t3qYno2QP4eYdtQSpdAMNvZ5oqeleK2i+G7
	L+E0L/bsHf0+nGB4m2CLxti0MM3YUeX8aom3fIbVL/4vNxumUfMrYPzRWbJjMelmdY0a63fRZOw
	YeX8s5Wq
X-Received: by 2002:a05:690e:480d:b0:65c:1637:9702 with SMTP id
 956f58d0204a3-65c79994bdfmr12597535d50.34.1778316351778; Sat, 09 May 2026
 01:45:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260508060724.3810904-1-haowenchao@xiaomi.com> <CAKEwX=Ood7Q4zv0zc+GCCGtWu2GLVdtod=4VC9151r87AZXpWA@mail.gmail.com>
In-Reply-To: <CAKEwX=Ood7Q4zv0zc+GCCGtWu2GLVdtod=4VC9151r87AZXpWA@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Sat, 9 May 2026 16:45:40 +0800
X-Gm-Features: AVHnY4LqYFKPUFe8mDf2wOjhtL_IA_mI8Qb7K_9yOfvXtETfkxn61yoJx9h3qr4
Message-ID: <CAOptpSMQyu5oSbJoM5QsbbHgdPwm44XUHE3i-XuT9bujFLRG0A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm/zsmalloc: per-cpu deferred free to
 accelerate swap entry release
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Yosry Ahmed <yosry@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C57B0140003
X-Rspamd-Server: rspam06
X-Stat-Signature: spkkt7eq967dwxqdsc8ycrcoru4qndki
X-HE-Tag: 1778316352-683148
X-HE-Meta: U2FsdGVkX1+oLNC/3lsLOocEw5rTWNvZKb9iSyCePQOWJsWDItsH1TVwFAhHNmcL/vCZ5YtZTqWmQwqKy0SKa9UEV9lo1a6UdzfmKRG9cdWOP3Iu0qDD+1paAAjth30pzS9H0oI3tK9BJ1CFKB1clX7d/sl2DR4xFB8Elgj4drCTscbl4uIECR+/bhtAw9pZrZB7tG7QjiajCxTfB3Meo/HBgOEq4dOFWD9Rj+aAVgvzs10u0lcDlQIzRm4xGH2/mUOjYKZJsLk4TpPhi+E/+ZhXtx7kiB3qvYGL1BKG805jwdtcH71A+5G3crKchPad4rkrMDVf1iOelpHXnxehDcZpfNbWBr8uVzIU/yKq/Gf1AcadGBr4Wj7eXbHulIC+ndEBKAdoHHEgYqq/kp6hcC7FaCFAUVbTLHEgasro+lWm30KZWTiuUnZyuezqun3hsqlmjgVxuKlfFSc8V523knXyANEeZlG4Gy0dwQgbcyrpRR8nbVyg5autPEoJedFmoavHz3kxn8zbAd8YzN8uz4uBn5sAYy+1W4sUoBhtBkZbK1X8lL4KslcNtATjOTcb2LG1DR5TJhY91bGKp9HWFA0H5oc0Kv7q6aTjfMXk8OQzI0KSegHYKt6KE3fuZD1xycKlQXawie6j+DR9+xEhlkeTNf5f4MbQzN2eM8RR0LPdN5NmZHYTRJpcDV1N3VLedi68i9i4laVRXEeFXkalyVRZxBYLlkTFGFrm2PXL9Pxjw37WHPG+BJGQCxjlHryOz9LaLJb7PhmKHfZYPNvYtJH+J5VdHlkbkVXcbIkOneBGoaGwmwxF1nlyUfi/TETOckUJwjUg3GiNuiLApPvNQC0j4RRh/8WEITVk1lWeEo/qHBjPX79FRMoPJp5ANwG82Y5htz0O4uuPkhPwiehdwEXpO4uIpwNLyAcFWd2UguG3dkDOSuo7xrwKNzZlZaR9DpfEaKhR7dUIWt5Yqyf
 8LVtxS2c
 8ZYan6YRHKKNyIwNqlHoUS50lpiEsY+XKSWwKSKkM0ctwIkw3EP3Dw3Z2CZPaaj5CvmVQH4gDVu7OQCXsyIEaO0jFMraLiSWSc7M5bQd8EYkUvKa8Du9gTb5qrvtlgRGmFeKLa0vKs0EbVExe1sx2sNs8iO5MxlU1j47NQmfCcWbWFtpsPF9A+MgAi6170E/6TGhbnbfrZ56WOcFe+68njhHAFTBcSElXz1cdM+50i73WePhoEX2+btt29wBtt6Hf/69CDqTJUYbDiWC8V6ZnZENM5V3iL31MRQu806smPoVdOE5GxdFWZTm/f3V0JYNb1turjmNHxNnLFmAYdfolfVd7cbsUK79Zih/49QpRBF9SfFNak4RBQMb546WXjGmp6o38rAPjy+h9TKoGEnHh7eQyFU9g3Nc2Lqep0wOShKbYLdtBa5Xr0QX65JIAHJDGGpUf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 9, 2026 at 8:08=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Thu, May 7, 2026 at 11:08=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> >
> > Swap freeing can be expensive when unmapping a VMA containing many swap
> > entries. This has been reported to significantly delay memory reclamati=
on
> > during Android's low-memory killing, especially when multiple processes
> > are terminated to free memory, with slot_free() accounting for more tha=
n
> > 80% of the total cost of freeing swap entries.
> >
> > Two earlier attempts by Lei and Zhiguo added a new thread in the mm cor=
e
> > to asynchronously collect and free swap entries [1][2], but the design
> > itself is fairly complex.
> >
> > When anon folios and swap entries are mixed within a process, reclaimin=
g
> > anon folios from killed processes helps return memory to the system as
> > quickly as possible, so that newly launched applications can satisfy
> > their memory demands. It is not ideal for swap freeing to block anon
> > folio freeing. On the other hand, swap freeing can still return memory
> > to the system, although at a slower rate due to memory compression.
> >
> > This series introduces a callback-based deferred free framework in
> > zsmalloc. Callers (zram, zswap) register push/drain callbacks to
> > define what gets buffered and how it gets drained. The entire free
> > path including caller-side bookkeeping (slot_free, zswap_entry_free)
> > is deferred to a background worker.
> >
> > Implementation:
> >   - Each CPU owns a single-page buffer. The hot path writes a value
> >     via the push callback with preemption disabled (no locks).
> >   - When the buffer fills, it is swapped with a fresh page from a
> >     pre-allocated page pool. The full page is queued to a WQ_UNBOUND
> >     worker for drain.
> >   - The drain callback performs the actual expensive work (zs_free,
> >     slot_free, zswap_entry_free, etc.) in batch, off the hot path.
> >   - If no free page is available, the caller falls back to synchronous
> >     processing.
> >
> > The speedup comes from moving expensive swap slot freeing off the
> > munmap hot path into a background worker, so that intact anonymous
> > folios are released back to the system without blocking. The worker
> > drains at a slower rate since compressed objects are small and freeing
> > a single handle may not release an entire page until the zspage is
> > fully empty.
> >
> > Performance results (Raspberry Pi 4B, ARM64, 8GB RAM):
> >
> > Test 1: munmap latency for 256MB swap-filled VMA (zram backend)
> >
> >   mode        Base       Patched     Speedup
> >   single      61.82ms    8.62ms      7.17x
> >   multi 2p    94.75ms    54.11ms     1.75x
> >   multi 3p    154.64ms   104.83ms    1.48x
> >
> > Test 2: munmap latency for different sizes (zram, single process)
> >
> >   Size       Base         Patched     Speedup
> >   64MB       14.11ms      2.18ms      6.47x
> >   128MB      29.45ms      4.48ms      6.57x
> >   192MB      43.85ms      6.62ms      6.62x
> >   256MB      57.01ms      9.08ms      6.28x
> >   512MB      115.13ms     55.58ms     2.07x
> >   1024MB     229.66ms     153.28ms    1.50x
> >
> > Test 3: munmap latency for 256MB swap-filled VMA (zswap backend)
> >
> >   mode        Base       Patched     Speedup
> >   single      152.14ms   51.26ms     2.97x
> >   multi 2p    186.56ms   105.42ms    1.77x
> >   multi 3p    205.83ms   153.32ms    1.34x
> >
> > Test 4: munmap latency for different sizes (zswap, single process)
> >
> >   Size       Base         Patched     Speedup
> >   64MB       37.83ms      13.26ms     2.85x
> >   128MB      75.11ms      26.73ms     2.81x
> >   256MB      150.78ms     52.97ms     2.85x
> >   512MB      303.04ms     130.38ms    2.32x
> >   1024MB     599.95ms     287.10ms    2.09x
> >
>
> Hmmm, why are we batching at the zswap/zsmalloc level like this? I
> agree with Yosry that this seems like somewhat of an unnecessary
> layering violation. For example, do we observe a lot more performance
> wins by doing this instead of just simply:
>

Thanks for the reply, refer following thread for the perf breakdown
and detail data:

https://lore.kernel.org/linux-mm/CAOptpSPY3YL5VFJW9KKP99Yb17+_rdXKsKj93FdEn=
3_Zb350ow@mail.gmail.com/

> static void zswap_entry_free(swp_entry_t swp, bool deferred)
> {
>     ...
>     if (!deferred || !zs_deferred_free(entry->pool->zs_pool , entry->hand=
le))
>         zs_free(entry->pool->zs_pool , entry->handle);
> }
>
> (basically what you had in the last version).
>
> One weird effect of doing deferred zswap entry freeing like what you
> are proposing here, is that the zswap LRU will be littered with stale
> zswap entries. Seems like you removed them from the zswap xarray, but
> they're still linked into the zswap LRU? At writeback time, that will
> throw off the statistics used in the heuristics, and will make
> writeback go through a bunch of stale entries, wasting more cycles :)
> Seems a bit inelegant, no?

You're right, that was an oversight -- thanks for pointing it. The
zsmalloc-only variant avoids this entirely: zswap_lru_del() stays
synchronous before the handle is queued, so the LRU never contains
torn-down entries. I'll make sure v4 doesn't have this issue
regardless of which direction we go.

