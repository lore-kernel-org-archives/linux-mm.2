Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBC31C61DD3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 02:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD5F6B0088; Thu,  3 Sep 2026 22:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38EA16B0092; Thu,  3 Sep 2026 22:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DBD6B0095; Thu,  3 Sep 2026 22:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDE0D6B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 22:08:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 609DB1A06D2
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:08:23 +0000 (UTC)
X-FDA: 85174445286.20.56287B4
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7E8E380006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:08:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGdLDM0D;
	spf=pass (imf02.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788487701;
	b=sFveCEU4Y291WKgn1GDDYjsYHVzn15HeYay48vKQAgNWOtadyHmm9z5c9DXJdf4sRa3Rf7
	ep33UaKOToN/LQFg3iCTG+vgM9jUk9RsVNPvAMnUlWv2RPmT6BuA4Uwb/Q7Z/3GYfEVHth
	pnk9D2RSpLn30p58FDu9UOQVQ8GcUZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788487701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8Sx88G1D3cLQBFH9yUavJPElbl9q9H57N/owGoAbjE=;
	b=u4EGttVPVc+09P83EXOnC3nWBQJfoL7Bqvuicjvlp23lYN8QzPPMsSU7XyI1f8jOv2olL/
	D5yIt5oSx6Jvf62Ub4P0RTWPPxlrWsLMw+L8XQwBe1k1j+bN9Y9Hx2DgKapR6Xmib0nFjg
	k7KUd2mR3lLkhtKNmFvmocP/YCIzCa4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LGdLDM0D;
	spf=pass (imf02.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ce98cb8165so5712415ad.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 19:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788487700; x=1789092500; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D8Sx88G1D3cLQBFH9yUavJPElbl9q9H57N/owGoAbjE=;
        b=LGdLDM0DW2GxK/5CgrcAaj7MLYzWVhEkDEYyaBtZyiFdbiN563ecragNM+0yLsaRxm
         YWdWKyaX5WPWCcLLKB+8c6VG+YG7h3CJI9Jh8yl2mm1LH1cOcCHOa9FChbU3eciBJZds
         7hjm9g5ZgSArF9HNWq9No7mfRXsmpY9WmeHCnSxivTY3KPqTzz41eGwVraM4UxbH4DBY
         vciB0tiGY90vhCP20GRAzSq5w+Dj5OrmUgKMDyrkZsYSjykNf4CP7fy56Ngw2GlZERRW
         yuzJgl3K4wN6Vy5O8ZDTzTGpgtbkUqRXHzoKktpTxymC1msvkIi7US5nwhwJ47V089/M
         RmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788487700; x=1789092500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D8Sx88G1D3cLQBFH9yUavJPElbl9q9H57N/owGoAbjE=;
        b=IbYYs644f+Uei7TrvaHe0nOtrigEmvR14oetDN0w6kUFWHGqvw3QxceUFzumWDcZ/a
         18hCQNeYJvPR/DJjbHG/kR4wdMlLrsuLrCurOzppIChQ3dUimtMklqXL6pUcMrFpOF6u
         pVymtlvT4AWqliBJsHmd5wuzENg5WEt+u+EE3m6l6oI+eXVFXqp0muzuy56qwfIuzHhk
         lVu7k4DxSAKid1EymFtxAFF8eSBYSFD0P2itK3Dv3jhpA3jBc0aK2m7U/Kkh8XPW+bQp
         Fk/QGZYcgj3U94JUaEWTlFxLQxxTnOZ7iVR3F4TpEgiZ5RkMz6MDJBzL4nKDLgcpGgXL
         nNOA==
X-Forwarded-Encrypted: i=1; AKwUvBxunUhhbUqK59jZXhiV5WxWNV7B8hpxQSdfaOVPpLxqZm83RvTbJzt/7VdS0FIzNIi238cN5xec5Q==@kvack.org
X-Gm-Message-State: AFuF++nROEssWXRCryMLh/ErSWx2ZLdhhQEHaq5olqlR/x+dhz7NfjGD
	qrw3dHSalUSU06bnLPCAJWzBP6jxVVSgHzbpRLFsWLdAnGZ0Lhi/Qdr1
X-Gm-Gg: AYBFou2qiaDEGs6dtGPR1kz+qVQgJtN/aGT39twx/x1BScTKzpXxjykytkzabi+KqZz
	3bLj7WZYQBjeJys7pnF1XoninJO/Pkev5S+c2b/gSnM7f+JcINYnvIrv68OfCwu5KT1FYRQV3jT
	0mCgi12kaNRfAjMYLd6Uzd4uE1MHopbeP93WCDG24AibP5FWdChpAvd2R+6gSpxkWn4U414OH9m
	XVGsTZ5k6T7lmiGJjpuHGnJPyqQoCWhmpnVMoByZSiOftEvVjA1n+hMmjoYu2iVhCG1GyXm11g0
	1v00pTF2H6rsc0w0p+zz1VdA7a2KoBx8tMmXTNiIOkSFRipqXEiS8m+aQuLc+k6pQ59vLabkyXK
	rJ2dxw8QpxGgpnV0CCbLuvtfeQwn0flKZMFf/dNWIMqkMtYtm0895XVYeMIsoLoYAGK0JZuXrkF
	TasOEAHxScYNmGTTnmXOKH9sFcVoflyjE0B4gDZlzCA07iYK6XGyrnL+JtKjVEtE88phfK59urm
	bI3QA==
X-Received: by 2002:a17:903:faf:b0:2d6:ef11:1773 with SMTP id d9443c01a7336-2db159c66bdmr16943145ad.8.1788487700136;
        Thu, 03 Sep 2026 19:08:20 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db1497f3e0sm3022005ad.44.2026.09.03.19.08.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 19:08:19 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	david@kernel.org,
	mhocko@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhangbo56@xiaomi.com
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
Date: Fri,  4 Sep 2026 10:07:56 +0800
Message-Id: <20260904020756.4163139-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260903130304.GQ3004@cmpxchg.org>
References: <20260903130304.GQ3004@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E8E380006
X-Stat-Signature: dbwyrrkyuxmmckteu9tgbrbbyh3yiu5s
X-HE-Tag: 1788487701-494146
X-HE-Meta: U2FsdGVkX1+kvFL23MerSgueJaFyHulsvH3upz0DBlAZE4MkR6YhktVLyJye53D+osnOa/S7XhBnBE/7mkGyP6tHYbrXHnivj9n6KZLHPWLo/HI2UT5eajLTEjPobRL0dy8+oh/6LNBeSdhqKLmVlA0lTlQhlM7vF5BJ8GRZkg0rZjJuWRDx8ixKQOcUMNJpL1Ap5BnbV4QUFi68yMWSVRdBJi+ujj4N6o8RG1TopwKlUyXfl0FvBbbnkMek9eSyvszLkQ+/NFQ1Rr1pWiy7wwl9vICiqtZg4GJEKPwp9v2aWPMeXiq97SqVHOLu5sAWDjuX/jqfHTIVY1vA5STJ1/6wU2s/TIg7cvQNwkhIopNv1H7vtRyffZ7NKwXedfy4gptDdm6U67dSbdD0pEotsV4WgzU0Euqx/l4/SOIKImArVTcNhLpOvxe4dYR3n8cU5SZ6LB/uOMHLmKqcSMWzkNYBkUgoQy9NS6z2YkKhLFy8cjNqzDM+349UEiAdkULC0JJ0SCdVGkVh86GvpoBr5CBDojWK61Ad3EKRaElZnipAWQOWpvxgHzQVLD48ECp0RFZwhWNcUw6ohXOjI2dBACTsvbm/wN3S1CmSNjkRhZSK3evVJvlAjsQplFVn8CXStq2olwIpdxoVPpjVZmYUvepcDp56KgFRiAGsgv9y5+A1ee9HG6FWZ+LlyLNpt1WSItdQ8OJ6mtlX4/YOO7jEDcsO1LZkaYAKGn4Om8+5KPcHtwR9EtJA0IZM5zpQai4rbOhKS5hNSAX323IUkJkCDo5X1iawuPxk5S/HNKjwLXScJFEjgWNVrc+hKuvR6Jh1ZccuouLXmE7aYZh1ABUX4gpaRI809KLECRvSWoiHwQNXqxyKnWnnw42mIPVIVOc+I0QHH9S478g1iVySAY4WpEk+aGLB37X2+sGJrkF31DP86n878E1f2i/03VmlZb7F8Q+JSYYoQsMKRLrvDuc
 hrqJUKli
 3BMUiHsgDpibFLYxj4saR98iAdFBXh/eUZ/1zNQimhudh+ncrcl4jvb5Bi/OKqf9G4Y/uA0+Xnf6VsdsRX2cKTAu5F2kzRuYSXiAVw3K0VMB3d6p89mNBDwtxvQtzVxXbmPH49dVgNxXODA7L4T96bJOfQYcLeZ2FvW6XnB5QXg9KJ2qgFi+ffr9DlGgrY1COWbw7YHQgJVVm7IS+uoIH4pGmNkF7aa1ZpKiFOZukljEpNr+9EiwYjwyW34iNbrQMajRRUZdL9Mhv/4StZZtdp4zyaL5n7tAEP8wMct6e2Ac/CG4DFJ9oDNYi89TAEWKUQP7IobFb1TX5SJkr28yM/94JtH59rIFTUNpNy8av30h0iQ3sVtC/w8MmRrRhOehrsDSgg0CE9ILg8JPngzqXznqmvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 09:03:04AM -0400, Johannes Weiner wrote:
> On Thu, Sep 03, 2026 at 12:01:31PM +0800, Bo Zhang wrote:
> > We have observed some cases where memory is allocated with GFP_NOIO, so
> > we cannot reclaim any anon folios unless they are in swapcache. We can
> > end up spending more than 150 ms looping in `shrink_folio_list()` scanning
> > non-swapcache folios without reclaiming a single folio. This is pure
> > overhead.
>
> Not entirely. There is some value in aging anon alongside file, so
> that the next __GFP_IO reclaimer doesn't look at a stale list.

You're right, "pure overhead" was too strong - aging anon does have
value for a later __GFP_IO reclaimer, and I don't intend to skip it in
general. Let me describe the case in full, because the reclaim cycle
itself already provides that aging on a later pass, which is what makes
me think the trade-off here leans the other way.

> Can you describe a bit more about what you observed? What workload is
> running, maybe you have a stack trace of which NOIO requests are
> routinely getting stuck in reclaim?

The workload is app launching on Android. The NOIO allocations come from
dm-verity hash-block reads via dm-bufio, which legitimately use GFP_NOIO
because they run underneath the IO path:

  worker_thread
   process_scheduled_works
    verity_work
     verity_verify_io
      verity_hash_for_block
       verity_verify_level
        dm_bufio_read_with_ioprio
         new_read
          __bufio_new
           alloc_buffer
            gfp_mask: GFP_NOIO | __GFP_NORETRY | __GFP_NOMEMALLOC | __GFP_NOWARN

So the NOIO use itself is correct; the problem is on the reclaim side.

Here is the full picture of one such direct reclaim. It runs two rounds
of do_try_to_free_pages(); the target is 32 folios.

Round 1 - partial (shared) memcg walk, 169.20 ms, 0 folios reclaimed
--------------------------------------------------------------------
  prio 12->1 (~1.3 ms):
    cache_trim_mode is on, so get_scan_count() picks SCAN_FILE. Only the
    file side is scanned. Because this is a shared/partial walk, each
    priority only visits a handful of memcgs before the iterator is
    handed off, so very few memcgs are looked at on the way down:
    428 file folios scanned, 0 reclaimed.

  prio 0 (~167.9 ms):
    priority hits 0 without meeting the target, so get_scan_count()
    forces SCAN_EQUAL. The walk lands on a single memcg with a large,
    unswapped anon LRU and a tiny file LRU:

      inactive_anon ~335 MB, inactive_file ~4 MB   (~84:1)
      memcg swap usage ~3.6 MB, so swapcache is negligible

    shrink_lruvec() now keeps feeding that huge anon list into
    shrink_folio_list() - ~2400 shrink_folio_list() calls, ~93,000 anon
    folios scanned - and every folio hits the !__GFP_IO keep_locked path
    (not in swapcache, needs a swap slot). This single shrink_lruvec()
    pass alone is ~168 ms with 0 folios reclaimed.

  Round 1 ends with nr_reclaimed = 0 < target, so reclaim retries with
  sc->memcg_full_walk = 1.

Round 2 - full memcg walk, 2.37 ms, 68 folios reclaimed
-------------------------------------------------------
  With memcg_full_walk = 1, priority resets to 12 and every priority
  now visits the complete subtree (~78 memcgs). Progress is made
  entirely from the file side:

    prio 12: ...  0 reclaimed
    prio 11: ...  0
    prio 10: ...  3
    prio  9: ...  8
    prio  8: ... 18
    prio  7: ... 38   -> cumulative 68 >= target 32, done

  All 68 reclaimed folios come from file LRUs; anon contributes 0.

So the whole 168 ms is spent scanning an anon list that cannot yield a
single folio under GFP_NOIO, and the actual progress comes from file in
a fast full-walk round that follows.

> 150ms sounds awful indeed. Is this cumulative for a whole reclaim
> cycle or single shrink_folio_list() runs?

It is a single shrink_lruvec() invocation on that one memcg, as above -
not accumulated across the cycle. Each shrink_folio_list() only handles
SWAP_CLUSTER_MAX folios and is fast on its own; it's the prio-0 while
loop over the huge anon list that adds up to ~168 ms.

On the aging trade-off
----------------------
I take your point that this pass would otherwise have aged anon for the
next __GFP_IO reclaimer. But in this cycle that benefit is small and the
cost is large:

- The aging is not lost so much as deferred. Round 2 (and any later
  __GFP_IO reclaimer) still walks the full subtree; anon that genuinely
  needs IO to be reclaimed gets aged/reclaimed then, once IO is allowed.
- The 168 ms is spent scanning ~93k anon folios that, by construction of
  GFP_NOIO + negligible swapcache, cannot be reclaimed on this pass at
  all - the aging is the only product, and it comes at the price of a
  ~168 ms stall in a latency-sensitive path.

That's why I'd argue the balance tips towards skipping anon here rather
than aging it. To keep the change narrow, the check only triggers at
priority 0 (where SCAN_EQUAL is forced) and only when swapcache is far
below the anon LRU (below min(anon >> 6, SWAP_CLUSTER_MAX)), i.e. when
essentially no anon on the list is reclaimable without IO. Outside that
corner anon is scanned and aged exactly as before.

And skipping anon in this corner doesn't cost us the aging in practice:
with no reclaimable anon left to scan, Round 1 simply finishes quickly
and reclaim proceeds to the full-walk retry (Round 2), which resets to
priority 12 and walks the whole subtree - anon included - so anon still
gets aged there, just without the ~168 ms detour first.

Thanks,
Bo

