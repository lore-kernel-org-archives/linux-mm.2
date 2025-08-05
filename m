Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8231FC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 18:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 281766B00B8; Tue,  5 Aug 2025 14:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2593F6B00BB; Tue,  5 Aug 2025 14:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F306B00BC; Tue,  5 Aug 2025 14:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 055F36B00B8
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:25:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0AD3114D61
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:25:52 +0000 (UTC)
X-FDA: 83743532544.24.2733B8C
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	by imf15.hostedemail.com (Postfix) with ESMTP id E61F5A000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 18:25:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kPxhhn5q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754418351; a=rsa-sha256;
	cv=none;
	b=7SbMcbhb8+64pud6H/zHXlFqwh3MJDt3Sw84uBRUkDmw4nbo9KzJNBE9xZQ1EuLUiinJjw
	3QdjUkHfiLzOTGFeL6uUt8w5AgQ4jPnIXFyoxpC3l57RjD2ZwpzvldWRyKZNDC4T9wD61R
	YUejCB3ocbOEOP2e2ZvoKmp1VEaLAYg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kPxhhn5q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.54 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754418351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o9EeB+1emdum1JbpeYAQmZA9Uj+oYMbJnd+IAHAtzMM=;
	b=ZTXUf2Ho3bszI6hnGbZskUfxIZNbrnJqwUq46VewPN8F0JuMflTPBeU+5pI+KVXMl/xlH/
	67/JzjaMfKpAgia+QR9Ub16W/JyfoC6gsZ+31CzZzqYad72ge6v2O5a/B6UfZLWBuIzgtf
	ZUleD2NwnRZ9LxeuQFKKhjL/ptxzbRA=
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-87c241da47dso258598939f.3
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 11:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754418350; x=1755023150; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o9EeB+1emdum1JbpeYAQmZA9Uj+oYMbJnd+IAHAtzMM=;
        b=kPxhhn5qgf9HXGnCh6jHDd234xpWAx4nlz2x/hkHzmP0f7jORA0TNts7gEWBsmQ/UL
         Bowm3hHW8kQmBhjLZuOREygidLFHAD7fm/1xkm1pzVwGsULXt+780FspajDl/eAzwZsu
         Y+TdX9tVZ87kwbuYqXY9eorLxiSDo+2IaoNYzcDF6ZQmpuD7wUezWn2ABQAmfT9k2EbV
         YuVhFnirgwoUPtJ+iIPIlgz15sVPanDWDp+kbZ/h3L7j7b0dVv7FELjsCKiuRpTh5QKe
         4bSTPX2DvoD0iK4eG5cIULLOcJrAQMQUABBiXvH0VDmf+k0GOMiV+IgxBcOFTmF/haUO
         GZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754418350; x=1755023150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o9EeB+1emdum1JbpeYAQmZA9Uj+oYMbJnd+IAHAtzMM=;
        b=mPOaKmx0krzWcGKNXgagLV0TMBjs6DnrQ/zAXSTqVPl+Ti/3qMQLQRs4Fi9ih4sKMB
         5EMvpC1NnVR6JhkG7bkDaa2iITRFG+hAF/TeLdgccaM6eVNT05uGnvM4cpEKaTS2n0rQ
         YcGnqQWbjPuIl7ATob273LcdPNpGWpXj84G36gyvGxrXoQccbzNTw1jNeN6a5O57k1dF
         2TzAntpDk0/Xf4HKl5PmtU2tXGaegq8sR2CHQiVSlZmZcdd9BJgiVnst9tikCOwldIUI
         9sUmUq9MVgSB1EqKRsCNMm16gLG4L+yObrFaKBFQdLHx0QWkVSnko0k9EJr01UMKMQ8C
         UAeg==
X-Forwarded-Encrypted: i=1; AJvYcCU083YjkTTglydPywJY1bROP5AQWBXU7HXko6rPQzhR0O0cH0wbFtCmn7ZUJJrGGXfDjh5+c39GBg==@kvack.org
X-Gm-Message-State: AOJu0YzP21Txkfn1NKFo/rp762lh5Yiqh6y1B3MCpl7BZ1NVOZdOX9Lv
	Lg1f5CFAxJYjPxJKDTfRWErFjHCG8JcXXJdfrabX5fYaeojq2DvU+G8OFKgfutBJY3IbqyMfcX+
	oup1IDD9SWcGJh1S2cHlq50DsGwoVzdOHND0UlY0=
X-Gm-Gg: ASbGncvgUKzNpjUAYEemRUYav7MHeDJCj6pvSR4/wO9R4LUlohe35b8fzf87LD6J/NG
	9cObUJnNoMOl8NzNk44M8YuDShZ/4BVUXqN8a103NZX11MK0RwTVt1WLO9q89tVmwmjvybGxqa5
	xrK/PDDIPDBomk2z1ZuExL92/l42q1+TGCdYFtP83dKiDpDfi39EPSri+/Zo6pj5rOJ/9jz7/Dl
	f7lz7O8jfBWi65QFQ==
X-Google-Smtp-Source: AGHT+IE9FzFBhHPMY3QQ7wkukSPptxGF8FF4UEpSeO+Ge2fnothK63ioC2GYfBc9QIW0W7bfUesIgaTBOhSowIgVcCg=
X-Received: by 2002:a05:6e02:1f87:b0:3e3:ef79:5a8c with SMTP id
 e9e14a558f8ab-3e416192470mr249792875ab.14.1754418349435; Tue, 05 Aug 2025
 11:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250805002954.1496-1-sj@kernel.org>
In-Reply-To: <20250805002954.1496-1-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 5 Aug 2025 11:25:38 -0700
X-Gm-Features: Ac12FXxTkTAMGIGoiKPmp4ITZb3pkWxkQz7zEcqlIUZRbb0Pn79u_pP5gw1w1f4
Message-ID: <CAKEwX=Pv4+nhG5j=qech3ox6CFKJL6Ox-xy_Tb+cyyXgZU1oPQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E61F5A000C
X-Stat-Signature: edzp4q54opzxw9gwjdbg6e1fiyk9zjkj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754418350-956269
X-HE-Meta: U2FsdGVkX18Qn7ILaODGb2nd8ZrF2g5pby2gxNXNlAWp/02O/VSy30JMwDwqPcxAPvlsO991Z8C+TMHCBSA+xYBBnLibXKiPVSU5LH5s3kYa/2mPWC98sILU+Sx0LGjO+xQ8r3jG9RiBqS4OyyZ9uJzrCBPDUMq90pHxVCcP/C1CpaN31NzjlutPUhXrPztU74Pi12stq1nPTXeR3EKoPsjdkSlF+RdKugxv293Q/NW8mZkmeO8lgeClTKnBaANQDGQjWHClgfTK0m2EFqA1ftmG+EB/GYW4ja7lK5fBuySneMGbg+xUbOGGqW2SRIniVbH4eqpVpmIUybYjVlGzrnVFCPS+yBMrnGXV0SSXQyulz9Db0vAwx948KSG9Dj6UeH81uEbXD7vll8CdFg8pqSoN7iEQhuc3NW7pzBDwY10MSfoTi5cMzklcvy1UfP4CKtnOXaVj8uc0gM9SQP+qeJEh63uwsVb9GHLK+x1ZQGvXvZy6hbeJuUquQR9x7udzmcPqWx+20Mo/1IWXnX5BmV52secOkfa7CHn5n8U74QGufspbAwRiItaWjy0zag7JJwN3AU2LwG3bnlNjll1CjsNKGB1H4X09dreSzejbkGkavf3FLvCcjIH53yWj3R8B2WIhKX06uO9hBTWtwO+wcmj37z+2Rcs9Zn4oq6rU6JBQpX7Sq/Sc8QR/i/vIzvGhfg4EVrdLduMxFWggR0klXzkuI+fUIsF1yUuzZvvh4oCJGNEHh1qqfEWRA3HnwM2BNiM9hf4gVpzNAn7Tnlkd6dqvSOdoBhsgwR8JjlPU7SpNaJZVtMLnSBnVNZdvMWOdThcavO0q1RQtcQrOvGDZ6AJ0XZ8wY8YwjrCL6WUxUNRSW4XNMuRqob88CefYIJtkVT4ufjJy4D7LChTsqIQm8tqH+jo5+vVbFhVTpZ3b2rbINXxUoI3ckiY5A0afXEjly3aerD3NOueCravgEiE
 UBcU81aL
 mzp7HS7J0vIAIzD0H0a5RM2JaPg0qYsZbABy4ZcvWdt/JWVT9TJjgMIocj+6SnN8/5HUSo0z9fhzPlZFgV1+A/eCCMr4uS7Na+4DEoMnzCdJt4+aa2NVeYLLtzV3oLxfnhIQQDwwnIJgZev+YpEcI92i4+cn+IKlBPCwcZ4F4a8KH6zts3W9yNHaouM5lqbP/6ILE8U8DEZ4pnFzVII+8tZ0fVYyWMly987WHOUktXOGQj9dtayQAj4Mf7vjWAAf5B9yjhXgvHHJUqtV5Sq8SswMjDZXq3thKAR+bdmHtUpbMHZ9lOZ8kqVRp8vQm+SlAnZlHY3IjgKSf8Oog+CFD5UXlm3Kwv5SAMRQ3rWNeRVTim1U09OGgR1b5bbALKkau/COi9953EtKgMVRa/r4KTrTKFStJiWJMjm6xUAdsyPQ5R/TqwqxHDDyGkizdmiviZFUm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 5:30=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> When zswap writeback is enabled and it fails compressing a given page,
> the page is swapped out to the backing swap device.  This behavior
> breaks the zswap's writeback LRU order, and hence users can experience
> unexpected latency spikes.  If the page is compressed without failure,
> but results in a size of PAGE_SIZE, the LRU order is kept, but the
> decompression overhead for loading the page back on the later access is
> unnecessary.
>
> Keep the LRU order and optimize unnecessary decompression overheads in
> the cases, by storing the original content in zpool as-is.  The length
> field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
> whether it is saved as-is or not (whether decompression is unnecessary)
> is identified by 'zswap_entry->length =3D=3D PAGE_SIZE'.
>
> So this change is not increasing per zswap entry metadata overhead.  But
> as the number of incompressible pages increases, total zswap metadata
> overhead is proportionally increased.  The overhead should not be
> problematic in usual cases, since the zswap metadata for single zswap
> entry is much smaller than PAGE_SIZE, and in common zswap use cases
> there should be a sufficient amount of compressible pages.  Also it can
> be mitigated by the zswap writeback.
>
> When a severe memory pressure comes from memcg's memory.high, storing
> incompressible pages as-is may result in reducing accounted memory
> footprint slower, since the footprint will be reduced only after the
> zswap writeback kicks in.  This can incur higher penalty_jiffies and
> degrade the performance.  Arguably this is just a wrong setup, but we
> don't want to introduce unnecessary surprises.  Add a parameter, namely
> 'save_incompressible_pages', to turn the feature on/off as users want.
> It is turned off by default.
>
> When the writeback is disabled, the additional overhead could be
> problematic.  For the case, keep the current behavior that just returns
> the failure and let swap_writeout() put the page back to the active LRU
> list in the case.  It is known to be suboptimal when the incompressible
> pages are cold, since the incompressible pages will continuously be
> tried to be zswapped out, and burn CPU cycles for compression attempts
> that will anyway fails.  One imaginable solution for the problem is
> reusing the swapped-out page and its struct page to store in the zswap
> pool.  But that's out of the scope of this patch.
>
> Tests
> -----
>
> I tested this patch using a simple self-written microbenchmark that is
> available at GitHub[1].  You can reproduce the test I did by executing
> run_tests.sh of the repo on your system.  Note that the repo's
> documentation is not good as of this writing, so you may need to read
> and use the code.
>
> The basic test scenario is simple.  Run a test program making artificial
> accesses to memory having artificial content under memory.high-set
> memory limit and measure how many accesses were made in given time.
>
> The test program repeatedly and randomly access three anonymous memory
> regions.  The regions are all 500 MiB size, and accessed in the same
> probability.  Two of those are filled up with a simple content that can
> easily be compressed, while the remaining one is filled up with a
> content that read from /dev/urandom, which is easy to fail at
> compressing to <PAGE_SIZE size.  The program runs for two minutes and
> prints out the number of accesses made every five seconds.
>
> The test script runs the program under below seven configurations.
>
> - 0: memory.high is set to 2 GiB, zswap is disabled.
> - 1-1: memory.high is set to 1350 MiB, zswap is disabled.
> - 1-2: Same to 1-1, but zswap is enabled.
> - 1-3: Same to 1-2, but save_incompressible_pages is turned on.
> - 2-1: memory.high is set to 1200 MiB, zswap is disabled.
> - 2-2: Same to 2-1, but zswap is enabled.
> - 2-3: Same to 2-2, but save_incompressible_pages is turned on.
>
> For all zswap enabled case, zswap shrinker is enabled.
>
> Configuration '0' is for showing the original memory performance.
> Configurations 1-1, 1-2 and 1-3 are for showing the performance of swap,
> zswap, and this patch under a level of memory pressure (~10% of working
> set).
>
> Configurations 2-1, 2-2 and 2-3 are similar to 1-1, 1-2 and 1-3 but to
> show those under a severe level of memory pressure (~20% of the working
> set).
>
> Because the per-5 seconds performance is not very reliable, I measured
> the average of that for the last one minute period of the test program
> run.  I also measured a few vmstat counters including zswpin, zswpout,
> zswpwb, pswpin and pswpout during the test runs.
>
> The measurement results are as below.  To save space, I show performance
> numbers that are normalized to that of the configuration '0' (no memory
> pressure), only.  The averaged accesses per 5 seconds of configuration
> '0' was 36493417.75.
>
>     config            0       1-1     1-2      1-3      2-1     2-2      =
2-3
>     perf_normalized   1.0000  0.0057  0.0235   0.0367   0.0031  0.0122   =
0.0077
>     perf_stdev_ratio  0.0582  0.0652  0.0167   0.0346   0.0404  0.0145   =
0.0613
>     zswpin            0       0       3548424  1999335  0       2912972  =
1612517
>     zswpout           0       0       3588817  2361689  0       2996588  =
2029884
>     zswpwb            0       0       10214    340270   0       34625    =
382117
>     pswpin            0       485806  772038   340967   540476  874909   =
790418
>     pswpout           0       649543  144773   340270   692666  275178   =
382117
>
> 'perf_normalized' is the performance metric, normalized to that of
> configuration '0' (no pressure).  'perf_stdev_ratio' is the standard
> deviation of the averaged data points, as a ratio to the averaged metric
> value.  For example, configuration '0' performance was showing 5.8%
> stdev.  Configurations 1-1 and 1-3 were having about 6.5% and 6.1%
> stdev.  Also the results were highly variable between multiple runs.  So
> this result is not very stable but just showing ball park figures.
> Please keep this in your mind when reading these results.
>
> Under about 10% of working set memory pressure, the performance was
> dropped to about 0.57% of no-pressure one, when the normal swap is used
> (1-1).  Actually ~10% working set pressure is not a mild one, at least
> on this test setup.
>
> By turning zswap on (1-2), the performance was improved about 4x,
> resulting in about 2.35% of no-pressure one.  Because of the
> incompressible pages in the third memory region, a significant amount of
> (non-zswap) swap I/O operations were made, though.
>
> By enabling the incompressible pages handling feature that is introduced
> by this patch (1-3), about 56% performance improvement was made,
> resulting in about 3.67% of no-pressure one.  Reduced pswpin of 1-3
> compared to 1-2 let us see where this improvement came from.
>
> Under about 20% of working set memory pressure, which could be extreme,
> the performance drops down to 0.31% of no-pressure one when only the
> normal swap is used (2-1).  Enabling zswap significantly improves it, up
> to 1.22%, though again showing a significant number of (non-zswap) swap
> I/O due to incompressible pages.
>
> Enabling the incompressible pages handling feature of this patch (2-3)
> didn't reduce non-zswap swap I/O, because the memory pressure is too
> severe to let nearly all zswap pages including the incompressible pages
> written back by zswap shrinker.  And because the memory usage is not
> dropped as soon as incompressible pages are swapped out but only after
> those are written back by shrinker, memory.high apparently applied more
> penalty_jiffies.  As a result, the performance became even worse than
> 2-2 about 36.88%, resulting in 0.07% of the no-pressure one.
>
> 20% of working set memory pressure is pretty extreme, but anyway the
> incompressible pages handling feature could make it worse in certain
> setups.  Hence add the parameter for turning the feature on/off as
> needed, and disable it by default.
>
> Related Works
> -------------
>
> This is not an entirely new attempt.  Nhat Pham and Takero Funaki tried
> very similar approaches in October 2023[2] and April 2024[3],
> respectively.  The two approaches didn't get merged mainly due to the
> metadata overhead concern.  I described why I think that shouldn't be a
> problem for this change, which is automatically disabled when writeback
> is disabled, at the beginning of this changelog.
>
> This patch is not particularly different from those, and actually built
> upon those.  I wrote this from scratch again, though.  Hence adding
> Suggested-by tags for them.  Actually Nhat first suggested this to me
> offlist.
>
> [1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
> [2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
> [3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.com
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Takero Funaki <flintglass@gmail.com>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
> Changes from RFC v1
> (https://lore.kernel.org/20250730234059.4603-1-sj@kernel.org)
> - Consider PAGE_SIZE-resulting compression successes as failures.
> - Use zpool for storing incompressible pages.
> - Test with zswap shrinker enabled.
> - Wordsmith changelog and comments.
> - Add documentation of save_incompressible_pages parameter.
>
>  Documentation/admin-guide/mm/zswap.rst |  9 +++++
>  mm/zswap.c                             | 53 +++++++++++++++++++++++++-
>  2 files changed, 61 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin=
-guide/mm/zswap.rst
> index c2806d051b92..20eae0734491 100644
> --- a/Documentation/admin-guide/mm/zswap.rst
> +++ b/Documentation/admin-guide/mm/zswap.rst
> @@ -142,6 +142,15 @@ User can enable it as follows::
>  This can be enabled at the boot time if ``CONFIG_ZSWAP_SHRINKER_DEFAULT_=
ON`` is
>  selected.
>
> +If a page cannot be compressed into a size smaller than PAGE_SIZE, it ca=
n be
> +beneficial to save the content as is without compression, to keep the LR=
U
> +order.  Users can enable this behavior, as follows::
> +
> +  echo Y > /sys/module/zswap/parameters/save_incompressible_pages
> +
> +This is disabled by default, and doesn't change behavior of zswap writeb=
ack
> +disabled case.
> +
>  A debugfs interface is provided for various statistic about pool size, n=
umber
>  of pages stored, same-value filled pages and various counters for the re=
asons
>  pages are rejected.
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 7e02c760955f..6e196c9a4dba 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -129,6 +129,11 @@ static bool zswap_shrinker_enabled =3D IS_ENABLED(
>                 CONFIG_ZSWAP_SHRINKER_DEFAULT_ON);
>  module_param_named(shrinker_enabled, zswap_shrinker_enabled, bool, 0644)=
;
>
> +/* Enable/disable incompressible pages storing */
> +static bool zswap_save_incompressible_pages;
> +module_param_named(save_incompressible_pages, zswap_save_incompressible_=
pages,
> +               bool, 0644);
> +
>  bool zswap_is_enabled(void)
>  {
>         return zswap_enabled;
> @@ -937,6 +942,29 @@ static void acomp_ctx_put_unlock(struct crypto_acomp=
_ctx *acomp_ctx)
>         mutex_unlock(&acomp_ctx->mutex);
>  }
>
> +/*
> + * Determine whether to save given page as-is.
> + *
> + * If a page cannot be compressed into a size smaller than PAGE_SIZE, it=
 can be
> + * beneficial to saving the content as is without compression, to keep t=
he LRU
> + * order.  This can increase memory overhead from metadata, but in commo=
n zswap
> + * use cases where there are sufficient amount of compressible pages, th=
e
> + * overhead should be not critical, and can be mitigated by the writebac=
k.
> + * Also, the decompression overhead is optimized.
> + *
> + * When the writeback is disabled, however, the additional overhead coul=
d be
> + * problematic.  For the case, just return the failure.  swap_writeout()=
 will
> + * put the page back to the active LRU list in the case.
> + */
> +static bool zswap_save_as_is(int comp_ret, unsigned int dlen,
> +               struct page *page)
> +{
> +       return zswap_save_incompressible_pages &&
> +                       (comp_ret || dlen =3D=3D PAGE_SIZE) &&
> +                       mem_cgroup_zswap_writeback_enabled(
> +                                       folio_memcg(page_folio(page)));
> +}
> +
>  static bool zswap_compress(struct page *page, struct zswap_entry *entry,
>                            struct zswap_pool *pool)
>  {
> @@ -976,8 +1004,13 @@ static bool zswap_compress(struct page *page, struc=
t zswap_entry *entry,
>          */
>         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
>         dlen =3D acomp_ctx->req->dlen;
> -       if (comp_ret)
> +       if (zswap_save_as_is(comp_ret, dlen, page)) {
> +               comp_ret =3D 0;
> +               dlen =3D PAGE_SIZE;
> +               memcpy_from_page(dst, page, 0, dlen);
> +       } else if (comp_ret) {
>                 goto unlock;
> +       }
>
>         zpool =3D pool->zpool;
>         gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> @@ -1001,6 +1034,17 @@ static bool zswap_compress(struct page *page, stru=
ct zswap_entry *entry,
>         return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
>  }
>
> +/*
> + * If save_incompressible_pages is set and writeback is enabled, incompr=
essible
> + * pages are saved as is without compression.  For more details, refer t=
o the
> + * comments of zswap_save_as_is().
> + */
> +static bool zswap_saved_as_is(struct zswap_entry *entry, struct folio *f=
olio)
> +{
> +       return entry->length =3D=3D PAGE_SIZE && zswap_save_incompressibl=
e_pages &&
> +               mem_cgroup_zswap_writeback_enabled(folio_memcg(folio));
> +}

Actually, this might not be safe either :(

What if we have the following sequence:
1. Initially, the cgroup is writeback enabled. We encounter an
incompressible page, and store it as-is in the zswap pool.
2. Some userspace agent (systemd or whatever) runs, and disables zswap
writeback on the cgroup.
3. At fault time, zswap_saved_as_is() returns false, so we'll treat
the page-sized stored object as compressed, and attempt to decompress
it. This is a memory corruption.

I think you can trigger a similar bug, if you enable
zswap_save_incompressible_pages initially, then disable it later on.

I think you have to do the following:
1. At store time, if comp_ret or dlen =3D=3D PAGE_SIZE, treat it as
compression failure. This means: saving as-is when writeback enabled,
and rejecting when writeback disabled. Basically:

if (!comp_ret || dlen =3D=3D PAGE_SIZE) {
    if (zswap_save_incompressible_pages &&
mem_cgroup_zswap_writeback_enabled(folio_memcg(page_folio(folio)))) {
        /* save as-is */
    } else {
       /* rejects */
    }

}

2. At load time, just check that dlen =3D=3D PAGE_SIZE. We NEVER store
PAGE_SIZE "compressed" page, so we can safely assume that it is the
original, uncompressed data.

