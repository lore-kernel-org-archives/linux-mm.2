Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D51C7CD343F
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 08:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B246B0307; Sat,  9 May 2026 04:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 344166B0309; Sat,  9 May 2026 04:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 257D76B030A; Sat,  9 May 2026 04:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11E096B0307
	for <linux-mm@kvack.org>; Sat,  9 May 2026 04:32:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95227140591
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:32:18 +0000 (UTC)
X-FDA: 84747214356.28.AE0AF37
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 98BE9A0003
	for <linux-mm@kvack.org>; Sat,  9 May 2026 08:32:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g4zB88xW;
	spf=pass (imf25.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778315536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DFCUPxEdozXw9KoevvKNfef1+tdjRi6G60+cl7ZPQoA=;
	b=vpEyNfWr9xgMRs3y4Iro71bgG3ORn/sXspqg5hRbbtzAUSBmWPhKcf2c4GNKU2sPV3wh54
	3aX0OHO67PZtbaDJkKdUpNTqCgo7nSgEEUDwDB7Zs9pbWppIiEUzMoeT3pPNvK0KKOcEJg
	iBVwPqhX0d4eZF8LuFRrT/p2+Gdm984=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g4zB88xW;
	spf=pass (imf25.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778315536; a=rsa-sha256;
	cv=pass;
	b=uVurY9xt13IyAwZSYY3OJxF8x5oC7qv3GRaB3V5IF1T4TfU9ZdcAy/o3ckCs/buOStUzU4
	lMee8JO0EBZOLFUGTkWH/ja7T0cLf+3SaKWK2Ufn6L6hehOPuln6vigxQ829S9MCu1G3Yf
	ppBKksE3+HKeh4CHT8UDCeVwCqIDedA=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-64e87a81639so2985791d50.0
        for <linux-mm@kvack.org>; Sat, 09 May 2026 01:32:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778315535; cv=none;
        d=google.com; s=arc-20240605;
        b=VqTspNJRlkpziJb93qGSHIhFyCpM+8Q5Sg/+Zmn924WKUtgYDcwxuCicw2ZzeXta0j
         c2wJ5Pn7fFunkb9tCEp11ICPB0SVwuxpo871OrzEiUmsLsmUWfJs24QCS69AlM6jgVrL
         Od48N5O2gAOx/Mfe2t1/CxMX4xGL2PSeq4AsLlRIHOAasa7Z/J5qn2DB33pkCaBupgj2
         YjbF4ThsxP44YxUY8YG4C2NGob2hJ9e1yGt50nRUYqoaM7SB6szHylG1TLZd4gGnihnI
         5gdR6BhQ17Fuzdwks/2pNw8xFR9tS4FcIeTfoNw65vVWP3fDHC04YUhi/7chXPUbhYyJ
         1DAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DFCUPxEdozXw9KoevvKNfef1+tdjRi6G60+cl7ZPQoA=;
        fh=ovQt0PYKGrGozuedWQaV5a3hhvnviDtfFUcvVxpuBWw=;
        b=PkGHSGUIX4Y7LJXup3L+6MYgYaroO5mqdvRxzi6ue70v6yvqGzURpPbCEoYZoC/QKd
         STGHBaMGzIsH7DyPbjLAbfHpezbUcCK834IKxaWSoLWmSiKTrXSQFlxYj/KAr/9k9hKS
         TVJlzA9LzQ2Twx+OOLfxLI6h0j0fOKWxyCclU9KVe1N8qCdn3N/2CSi6nVkTfllZpI0B
         7XBWvwP7XJJgo+tIY50vnaJp4E7LzxEz5J4Rfu8ck8IDXOE7UTX86QVItPdvpSRRi/EY
         84u7oeYQLQvBaV0Gm94oVGjIP9dnQbZlNszL/W8C3pZZ7QouJyRsZud+uq2d95UeGMGh
         c+eA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778315535; x=1778920335; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFCUPxEdozXw9KoevvKNfef1+tdjRi6G60+cl7ZPQoA=;
        b=g4zB88xWaIJCfbY8uCGKEeHn/NtPdOSZ708MJSS2lD3zYiRwZGoLNQCe30pklBPbG+
         67bAGd3788jFzwUw9yIl9CfaclmOXTLzgdXyxN8pOp1xU8f7Ctf7Yo2pGgaezRdOiRd2
         67WeX9q/JrmuOAbzF7T+CvPjHxGSoWFE3GDVY6Hf1DdRGHzQq38b7vJghkQ5951RyJWE
         39XE/TismAUlGGoGnFFgnNcmjAIf6z2Q6kO4Hb8K1W+/QIRsI2ZEyB5L6A/FrJl08QKY
         64O5L3B73SkQ3CQv2b9CEN+E0oHRYTa+VqNV8+G118DQHpX50IcUvJogEDk5y9siPiN4
         lQdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778315535; x=1778920335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DFCUPxEdozXw9KoevvKNfef1+tdjRi6G60+cl7ZPQoA=;
        b=GXauXw8luKe3UIaQCVrwZtWXmKayGtei9ZpFjUo/L2Al1cgIa19EuBlS4efElfNgcb
         AuML8iCUUjSKZEFyzC7z4qiAQ7wCMhyErXuUjUzGaGwwsxZZGHT5K7fymxajFud6ALp5
         U1rcsZakdzfiHG3maqhnMP9DDmlaRvl6A3wnefLYULbW8z3/g4uF6fARr2AmOTVI3vmM
         fQGPeEX4F5FTqTiz/g06i71uK5bmhB4tG4ZPIyAtIK+wreIojH40D6CWY53xtPRC6y1C
         oWfZBsLbG1H9z/PNIvdDGrKGByJRybLoG3qiuohjdY2jq/YlFiJ+EA5NXzoWqZEmADGN
         KMrg==
X-Forwarded-Encrypted: i=1; AFNElJ8LsQ1lDgPXVOQBYr87v2UpsI5XG0prt4LV2PZVdC7L9sCGBAOz2IUdOSN1+bc7iU+59t2Wa73TWQ==@kvack.org
X-Gm-Message-State: AOJu0YwHZnC0ZO7sLeATacIBdCahAVoInklnFYYkMkaWVs0+f2y/fNN4
	0HUJlqokOnhiqUgLDz4chDuVagr5MAw9Sz9X/K2a057IKaHZ1mHKJbSoIwIESzH1GJAhXu/2oGe
	mgbTcq8zNN2gHt8WfRG7GwtcgIRbstok=
X-Gm-Gg: Acq92OEXoNS4tPsoCkGhtbwAXeMZNviLgj/XDVBxRFz11hmQdTewIv9a1xuXUzGt4oE
	ynQS5BuKZS3YKWSuphJqHLaY7vYVFnGxjytStMihWhDYvjHE8PWYCVhUn89eDxkFKCHLuZuwjIE
	Ddo7pQbB3ZEvB9QxwoFK3fWwIf9NlCv8SWg0HxS94kTobQjushALEI7zDT4z+ar8PptSSLPY7kx
	2pE6xk4zU6p/Imhy48NXHk54X5ouRHjVl7LiHB13if7FxpL54qdJiFKzGwchrQmsZtg9oGbchFN
	ROl48bg7
X-Received: by 2002:a53:bf12:0:b0:65c:6220:5fcf with SMTP id
 956f58d0204a3-65c79e5a8a0mr12116257d50.62.1778315535310; Sat, 09 May 2026
 01:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260508060724.3810904-1-haowenchao@xiaomi.com> <CAO9r8zO3GrMLDV57aRaiwRvZhwcduihKhc3rBpFGkbZKoq_iSw@mail.gmail.com>
In-Reply-To: <CAO9r8zO3GrMLDV57aRaiwRvZhwcduihKhc3rBpFGkbZKoq_iSw@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Sat, 9 May 2026 16:32:04 +0800
X-Gm-Features: AVHnY4LyhWnyTyP9L5IXX7-e7r_8EAGOYym_9fMZjc7c86Jp2ckAZ-ir_9aaUu4
Message-ID: <CAOptpSPY3YL5VFJW9KKP99Yb17+_rdXKsKj93FdEn3_Zb350ow@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm/zsmalloc: per-cpu deferred free to
 accelerate swap entry release
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <21cnbao@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ooe99t35fpp1fcmaca5wz4odwtiyd83h
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 98BE9A0003
X-Rspam-User: 
X-HE-Tag: 1778315536-446475
X-HE-Meta: U2FsdGVkX189qpXedQy6+JozZU50dyPHNs+hZT54EiAnq9zJTuXGLlEoId/8fqJX214xlZmHJ5PHOKZdbe6iD5GDadT3VpRNaQV1O+YPKdGysaR22U2hTPkefr2EWY+N1++wf2AILLErzfM1pv+bJ7RAPGHBKYe4tVZDmQwWPKDlZToCWHsLgtae0hA7/9lDAoj6eWFbo/lUC7/cLMPHZy3eEpzlCE5TmaFwyeYa5xufMxht2Ds1SpyVSePIeFoqGw1dRxkHv0EYgLSAPDrf5VsP7b6aLc1lbTkRX+rveLwOaUpkZur2eCe2pQhYpdi9q0ZvAPbEs0igsv2HY1zf5oSfJjOMZTHIotbeOIiDeSvu/6vwjE4X3nF2/xf2sR5GL6pQS4AB5AMiII0D9X8CccdHN9+JXN+WgK1UHIIzyTCfwR4shdxYCpBwWSL5RQa46AhmRa+NSTHIMvwF2iPQYHJbJ8o5cObTZXi9XTnwrKjXPNX8u/SCXpQUh/RMNcW/PgO6OTM5mgYIDK+FZSGcWULp6BxY7rWhfvFoh5yvAyzdyz3PUtAa7xJCqLkfRZ/kO2tANuL07qzrzHD88dF8hGarDKapPhsm5+8zMKoRlhBNY7blbdG5j4Nb0ysuoVxzvJzLojIQns5nyk4gmGETRBoRwApbL7j3JcA6syB3s499gUbQfD3y7RswhkUr5Xdo1SS0S5ZHE+/jsagzWHGjf9fkpqxBiOmY4Npjn1VnkhOXoPua47yKjIMstgqIQlThmiKFOupR8USBzpr4iWF4oqljIrGZWVuL5jIawmrCL4BJKFJzZzxfU/QYv0qqxapg9up5ZtbTx0C4tJaw+80ZfnTjfVwTlqu1xTZQ/sCOFp+89AMlQzuWlvBfuwoXhadUH8GVyiPhY43Qv6iA57ALrDvqNOW14/j6g5+A6M9Co8XQOAiRjjyIrxwxcQog7jPM0uQi6NS9L/Zmg8w1G4p
 5FKA8sxg
 snmP1+DGMwQ8yyOuaoemLo1+JJzCCvCFI+jI9juSonYUVB4lrUrGyvylWhGIbc/E/pEDkKV0WfCbclqdOj+qJSLDAG+MUOZr+dWhaVB+4ZnD3dnVbx1kgye5qFt4hP3fNQPnnHB0yoha7i4Nzs+dmSWa+dBzQkCqhthksEOW1A8+6zbR+GIASfUK4ZevDgo6v+J+a57V6wIbWjaRzFNOhUBeu8ZO/h/Z89UdG8HflCwPR29niAfOZ1Ld8GnRzGo+yJsMcYwvL0wMnpWRNlSGxQbc22idGZPJf5H/Jw3h8rH8yPqnuPhv9Q5XMj+VZuY/jh6Bzc77Ygl3tKJHOWlWUNix738IFvxnsVBIbUsp9wH2UCaEQGHKKNfcoaicC6POVDkYEOiEYmBlpErlQn0Cs3Jk2kHzaRDGp+8mZETYK4Rm7DqOuvPhKqraEVLljPQ1NylzeEJZAtyBoGYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 9, 2026 at 4:13=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
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
> > This series introduces a callback-based deferred free framework in
> > zsmalloc. Callers (zram, zswap) register push/drain callbacks to
> > define what gets buffered and how it gets drained. The entire free
> > path including caller-side bookkeeping (slot_free, zswap_entry_free)
> > is deferred to a background worker.
>
> How much of the speedup comes from avoiding the per-class lock,
> free_zspage(), other work in zswap, etc.

This series doesn't avoid the per-class lock. The pool->lock part
has been split out and posted as a separate series, so this series
focuses purely on the defer scheme:

https://lore.kernel.org/linux-mm/20260508061910.3882831-1-haowenchao@xiaomi=
.com/

>
> I ask because I think the design here is still fairly complex. I don't
> like how zswap and zram are registering callbacks into zsmalloc to do
> their own freeing work, and they fill the buffers on behalf of
> zsmalloc which seems like a layering violation.

The callback design was motivated by code reuse -- deferring only
zs_free() inside zsmalloc gave less speedup, and the machinery
needed to defer caller-side bookkeeping turns out to be the same
on both sides (per-cpu page buffer, drain worker, fallback). So I
folded the common parts into zsmalloc.

I agree it's not clean from a layering standpoint, and I'm happy to
revisit if the reuse isn't worth the cost.

>
> I wonder how much of the speedup we get by just deferring
> free_zspage()?

Below is the perf breakdown, sampled only during munmap() of a
256MB zram-filled VMA on a Raspberry Pi 4B.

Base kernel:

  # Samples: 491  of event 'cycles'
  # Event count (approx.): 214056923
  #
  # Children      Self  Symbol
  # ........  ........  ..........................................
      99.55%     0.41%  [k] __zap_vma_range
      97.27%     2.91%  [k] swap_put_entries_cluster
      94.37%     1.65%  [k] __swap_cluster_free_entries
      88.99%     8.91%  [k] zram_slot_free_notify
      79.87%    10.78%  [k] slot_free
      56.27%     5.99%  [k] zs_free
      47.61%     4.35%  [k] free_zspage
      36.85%     4.96%  [k] __free_zspage
      19.27%     0.21%  [k] __folio_put
      12.64%     2.91%  [k] __free_frozen_pages
       9.50%     6.40%  [k] kmem_cache_free
       8.28%     8.28%  [k] _raw_spin_unlock_irqrestore
       6.83%     1.85%  [k] dec_zone_page_state
       5.18%     5.18%  [k] _raw_spin_unlock
       5.18%     5.18%  [k] folio_unlock
       4.98%     4.98%  [k] mod_zone_state
       4.12%     4.12%  [k] _raw_spin_lock
       3.30%     3.30%  [k] __swap_cgroup_id_xchg

Perf of the zsmalloc-only variant (same 256MB zram workload):

My first attempt for this RFC was exactly that -- defer only the
handle free inside zsmalloc, keep zram/zswap caller-side bookkeeping
synchronous. (I would post this version after this thread)

  # Samples: 164  of event 'cycles'
  # Event count (approx.): 68803872
  #
  # Children      Self  Symbol
  # ........  ........  ..........................................
      99.24%     1.28%  [k] __zap_vma_range
      94.17%     4.49%  [k] swap_put_entries_cluster
      87.77%    12.09%  [k] __swap_cluster_free_entries
      43.62%    24.33%  [k] zram_slot_free_notify
      21.80%    21.80%  [k] slot_free_extract
      19.29%     6.42%  [k] zs_free_deferred
      12.23%     0.64%  [k] zs_free         <- sync fallback only
       8.96%     8.96%  [k] __swap_cgroup_id_xchg
       4.51%     1.93%  [k] __free_frozen_pages

Zsmalloc-internal items drop out or shrink dramatically. zs_free at
0.64% is only the synchronous fallback when the per-cpu page pool is
temporarily empty. zram_slot_free_notify remains high (24.33%)
because slot_free_extract() still runs synchronously on the hot path
-- it's a new helper this variant introduces to do the zram-side
cleanup (slot flag clears, atomic stats updates, handle extraction)
before the handle is queued.

The perf numbers showed that zram also has non-trivial caller-side
bookkeeping cost -- the work in slot_free_extract() in particular.
I tried to reduce that without deferring it (per-cpu stats, swapping
the bit-lock for a different primitive), but the results were
basically a wash and sometimes slightly worse. That's what led to v3
extending the defer to cover the caller side as well, via the
push/drain callbacks.

v3 (this series, defer all zram slot notify):

  # Samples: 82  of event 'cycles'
  # Event count (approx.): 33089591
  #
  # Children      Self  Symbol
  # ........  ........  ..........................................
      91.46%     1.32%  [k] __zap_vma_range
      75.77%     8.35%  [k] swap_put_entries_cluster
      64.71%    10.72%  [k] __swap_cluster_free_entries
      33.36%    17.43%  [k] zram_slot_free_notify
      18.03%    18.03%  [k] __swap_cgroup_id_xchg
      13.31%    11.82%  [k] zs_free_deferred
       9.10%     9.10%  [k] lookup_swap_cgroup_id
       4.03%     4.03%  [k] zswap_invalidate
       3.94%     3.94%  [k] swap_pte_batch

Absolute cycles in the unmap window drop from 214M to 33M (~6.5x),
matching the observed munmap latency (57ms -> 9ms). The defer path
moves the following items out of the hot path (base kernel Self%):

  _raw_spin_unlock_irqrestore  8.28   class/pool locks
  kmem_cache_free              6.40   zspage struct slab free
  zs_free                      5.99
  _raw_spin_unlock             5.18
  folio_unlock                 5.18
  __free_zspage                4.96   zspage teardown
  mod_zone_state               4.98   zone stats
  free_zspage                  4.35
  _raw_spin_lock               4.12
  __free_frozen_pages          2.91   buddy page release
  _raw_spin_trylock            2.48
  dec_zone_page_state          1.85
  free_frozen_page_commit      1.66

That accounts for ~55% of the base-kernel munmap hot path, all
moved to the drain worker.

Benchmark (zram, single process, avg of 3):

  size    base     v3       zs-only     v3/base   zs-only/base
  64MB     14.38    2.12     4.34        6.8x      3.3x
  128MB    29.73    4.26     8.54        7.0x      3.5x
  256MB    57.93    8.54    19.90        6.8x      2.9x
  512MB   116.77   55.41    47.90        2.1x      2.4x
  1024MB  234.43  150.11   105.06        1.6x      2.2x

> That part can be done much more simply by just putting
> the pages on a per-class list and having an async worker or a kthread
> consume them and batch-free them. If the rest of zs_free() is also
> expensive, we can do the deferred freeing on that level although it
> would be more complicated as we need to have a fixed size buffer to
> store them and handle running out of space.
>

I hesitated on per-class because there are ~255 classes, so a
worker walking them would often find single-entry or empty lists,
defeating the batching. Using a per-cpu buffer of handles and
sorting by class inside the drain gets "batched under one
class->lock" without the many-short-lists problem.

Thanks,
Wenchao

> A breakdown of where the slowdown is coming from would be helpful to
> understand what to focus on.
>
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
> > [1] https://lore.kernel.org/all/20240805153639.1057-1-justinjiang@vivo.=
com/
> > [2] https://lore.kernel.org/all/20250909065349.574894-1-liulei.rjpt@viv=
o.com/
> > [3] https://lore.kernel.org/linux-mm/20260412060450.15813-1-baohua@kern=
el.org/
> >
> > Changes since v2:
> > - Use per-cpu single-page buffers instead of a global list; the hot
> >   path only writes into the local CPU's buffer with preemption disabled
> > - Add a page pool for buffer rotation: when the current buffer is full,
> >   swap it with a free page from the pool and queue the full page for
> >   drain
> > - Introduce push/drain callback ops so that zram and zswap can each
> >   define their own element size and drain logic (zram stores u32 slot
> >   indices, zswap stores unsigned long handles)
> > - Drop the lock optimization patches it will be submitted separately
> >   as part of a dedicated zsmalloc lock contention series
> > - Link to v2: https://lore.kernel.org/all/20260421121616.3298845-1-haow=
enchao@xiaomi.com/
> >
> > Barry Song (1):
> >   zram: use zsmalloc deferred free callback for async slot free
> >
> > Wenchao Hao (3):
> >   mm/zsmalloc: introduce deferred free framework with callback ops
> >   mm/zswap: use zsmalloc deferred free callback for async invalidate
> >   zram: batch clear flags in slot_free with single write
> >
> >  drivers/block/zram/zram_drv.c |  44 ++++++-
> >  drivers/block/zram/zram_drv.h |   6 +
> >  include/linux/zsmalloc.h      |  16 +++
> >  mm/zsmalloc.c                 | 208 +++++++++++++++++++++++++++++++++-
> >  mm/zswap.c                    |  38 ++++++-
> >  5 files changed, 306 insertions(+), 6 deletions(-)
> >
> > --
> > 2.34.1
> >

