Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395C5CD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 08:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A043E6B00CC; Fri, 15 May 2026 04:22:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B55D6B00CE; Fri, 15 May 2026 04:22:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A43F6B00CF; Fri, 15 May 2026 04:22:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 78AA46B00CC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:22:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1016F40872
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:22:29 +0000 (UTC)
X-FDA: 84768962418.16.6DADBB2
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 18C0D40007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:22:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QUZDSkIF;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778833347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFd43S0nsokHBWyO9gjybJonKVNEFvbWFO5/AY/Iqko=;
	b=p88upfn8e0Yae37Qn241WFnZeJnriafh0KTkJDwzplryHxx22kyuuqdu2rX3t05/rJ8VLv
	O1ADHZwsEhWBDZ32jVL9bG1nNNiAxHy9ozBhrD7RzurkcdWASjEqLtnKrNhob0LXk7GDNg
	vPcMN2tNWHhk3lNPimoqfIul88nrA8M=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QUZDSkIF;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778833347; a=rsa-sha256;
	cv=pass;
	b=JhRMCPxHbmLx024ALSBkbh27wXPap8kyKMbGWaosMnRUW7oEfHPHW5mqmcOoneg+YZSUX/
	YqFtt7e4tw+BcLPdsxWvs8QgBiV3gssXKjtOOQO7sGpnP3Kma371BqL9VDtYRIAn05cqiM
	dYYlbip/I2GQTBzYwICtcbYYuKiVO0c=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67c3cb1433cso15473219a12.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 01:22:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778833345; cv=none;
        d=google.com; s=arc-20240605;
        b=ZERMQuvOUB0OUTsnDgnziM5OVcIXTuyEez9Rzig9GT+M3NlTyOF1ct5rvLL4Ft6Lj5
         cdCl4s3rtq8erJLlBLccusd33IvzjBkXrv2MtWhEdx2xNzgrFcLjeXO4wJE5FEpZGhK5
         Mh9YEnT8pbb4vDaBv0zDxL4huRfrbTRyLLEpD24ccNHTapWBI5ffmxMQnZSwAbGEdcUc
         yUEPYV2LJhImK9SaEwRuzNtJIaPPDz43TdMs7UPdQZI5Jnk4J91jnnInDGWGzOvbrq/E
         ibjlF8cXfCvGyHpmTFb6H2SI0os0Qi8UL9JCR6OmQTs06ABKvzX42tbZj0O8MrAH4YYU
         VXSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QFd43S0nsokHBWyO9gjybJonKVNEFvbWFO5/AY/Iqko=;
        fh=qXVRxg0JM3wos9owo7qOi644zU+FWtM+AOley4//P/E=;
        b=M4H1qqN/9OxcVbAL64Uu0eU6E0geDH8UAKqUFqI6VSUTWUKK2TwGH6kIyBS3R7AHwl
         ljBlIVfxmvihFpvduAUpJ4rlgwv/Tx3tbBleUxIDA8CJRmNOG3TriIce9r0YatOGJCdX
         dRfLxaLLY+bifv9ICwDrjGVbiCqAUfsaFJdRBvRTYw1usjKxbGqDfvD3fyoyp7t4h8QO
         P+aeuiHYRAUENaskKXGOmGuLYrqWpZsaV+GHMzJm5CzsjBIj9SxmthH8PIWw2gUGRG8K
         lyiIFINEKWQ24r7ZCzcOTnF5Glq4k5f1CdvnlWcjPqDFhgvL0vF2KlxD22jTYzaU2p5/
         /QYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778833345; x=1779438145; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QFd43S0nsokHBWyO9gjybJonKVNEFvbWFO5/AY/Iqko=;
        b=QUZDSkIFTXVPM0tMtfwuU9mbh6BT+17+zMDiarywaSjwNZcNXqKYdc9gr+gLYUHyGx
         WfhgZ54qQwjhazkWedfqIm4ZDotxwbVzg4IAzylvwPADdWybppHU4zVFshpORFDkHrLB
         T7nvxLkedGVMyUpprXkSALyLJAwJHkhen8/Az8Kr87bcAOaY9vnkXTucXez+sXkZegJb
         80/ON+dVKdolGviI76f2dGSR+g9gu3tvueP2DqNBwsSyjlsjzG2+0ej5f7y0VQfT3LCc
         gKQStEIy3NpeMlb/IcNas1RS3r74oUtWkT6BCCGgK3rs0z6Uy8xzPLcOBT6oRPS9rcru
         WBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778833345; x=1779438145;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QFd43S0nsokHBWyO9gjybJonKVNEFvbWFO5/AY/Iqko=;
        b=aYKT0zXYAm5T5++fIEBz3YUT5/bfDmgnkIQZ9XMV3sLDrw5M7G6GXFzTEgXQ9BRvHa
         UQe6sanpiFvAtTI3i+kib7QBVrPtMAUsOFgKWXUTyQ6WMsPCypOEtHUJlwk3bwLpnduI
         5XARFtRO9spwhiwkCA9PzE+G87tWXjqz8uMC3E0pFvNfgxLkF7xT4KlfkMht2sTDH8BS
         oUeKXKVHVCluphTPMkfpRHjNMoYOQreCWJOf3voVS/MM7ABttg59D5514Gx0Aiw6RVrA
         faj0fesU3jUMLeWvAGaU0YB4v7/47jrVWcx9Ccrdjocv+euWfC8SAnnYKYCAUZ9Y8aZt
         mLAA==
X-Gm-Message-State: AOJu0Yyzsai2Bcw3fQvkrjgyjUn5XPZ5ydgnyxZGX6UzB/9VSAAScb7C
	wQOCZffzgbO3hm7ZDKtmd/nGCJadkRTGbAeBoWxZ2LBIu1jJb123fVLMYL32kjptJx7f4m3tgxf
	gho+WwVK+zrY07iAXahAGkcOh9whUQ7gYBYAAXx99lA==
X-Gm-Gg: Acq92OHfahG6Wg+dd9W0rFeRYqeIez5MoIUSnxRrLLVmQL3Cq2fLkZHv28g0OKTM08s
	Y8izIfHViMw8IJ1+hZRWfmBWogymzEB5DzxNudHBk0z3/7hViz76rX2Sng8GOU50nWYB1QqCL/D
	m8Z3tzgpWip2FaFfJlGD+yf7V16zIbXlJ5hxi4TKgUBOG21YhU3i6tC1YzuZ8nkRV3pmf1vZo/S
	kPUjETWyHNb1dtu4sJnjFVHIcOUgJWV3MBrhqklBOf5iszflFnc2ps6dm/kcn0UiNuqKtkeHa7q
	CZulHxboYTE+ykSHStht2J2E51QfqwKlu/vFscyp
X-Received: by 2002:a17:907:c28a:b0:bc3:c6f5:1d47 with SMTP id
 a640c23a62f3a-bd5177ba08fmr164951866b.11.1778833345152; Fri, 15 May 2026
 01:22:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com>
In-Reply-To: <20260513-swap-extend-table-fix-v1-1-a71dea851fb3@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 15 May 2026 16:21:48 +0800
X-Gm-Features: AVHnY4KtzqiMgKQujDz6p_ranjvtLVHEuP4kbQGuPX5GTgh8GmR9FVVWJrHiIfY
Message-ID: <CAMgjq7CQM+vzjQ-dgnAjvE8+czs1FmrK7Cv+EJ6jCGysa8OSqQ@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: avoid leaving unused extend table after alloc race
To: linux-mm@kvack.org
Cc: kasong@tencent.com, Andrew Morton <akpm@linux-foundation.org>, 
	Breno Leitao <leitao@debian.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18C0D40007
X-Stat-Signature: qw1o79y1bsc3z1b3c5utz4yqxhzw896r
X-HE-Tag: 1778833346-63152
X-HE-Meta: U2FsdGVkX18bSNj6j4tGJ+qUY/HFEb8+jRr6Di+ni5ccCBeQnEBHyUfJJTxlT44MT8PF41e9QDLC+aXEuqLY30AzTmfwlMzuXOI/jUhnSM9sg/YfjYFUieMcBLQk5ftBk1Yzull6oM/M+yZLEMhDEMdG3F29qef/utwrgBXwrZI7vJm5REP6sg42m7/EnDrW2cbOJ1q4wy4DpO2kn7+ta6ZzKiODiCmFQdQL8XjBSnxV6WUnWX0L40ZyiFhJtDfDAlcVgzlk4eEqXY6KrEnmYqYFwggELcg25OLST67Ocz/DvTSV/0IvSTJH0HwqjXrcHd1PLX3xqS2wf9FOqEp45d7kpCS6cWef35z5+gVgNaMpZizChL/wmXixXAVZWr+d8QFNW0Z+sR7rCkCkC1OW00jO7CiklVR2dUGXNmADOOWeUzNnXIGGBx3tf3ER5GDHFj1oEiQyk6MyZV1vYkiHjxLZ5p9kfEZ2g4WMif14sDwaFDVDPg2Lwh5mTXiMl0X+HaGhJFvPDR2DZ/PwVYisMoYomnPAyxJq1w/5CuJEDp28BUTv+OxQJxLRERn/zWgPqRkyFzrU3x8pQE8UinAhD0CPZyJPHHZd14oMp/7YlH3EkuB1wow8bGzFdfEoeFQPKHm3af8KOj9d4kPli7cHfFDsm7vR0FRBhjg4mFvn+1tts87JTghtoI1YsUzY7egvpeT6ufuf1Wh7lAjmLJ8D9Wi7hZL9NEDloEU2GzHIffskQ/AhKHTiL6XR+8AMqltJpuwJ7OeRkkOdZ3tDrUotl5FxAuZYW3oRefUif22M72zh2URPLFVczKsTVA95l875mzsNJgOrNR8LtxfnMVitpuBNvN239mkjfpkZOUdFgxfDoBMKcAO0ZWcrVdFAvLak+8EcLt/SXcSepE+i3TGhWvhH7xks0OTEI03wnbQhPw05pRLP2iESCYnKXLFSEgv/B4rGK2hCxFdfYUnTenG
 lnlNpOmg
 2QN0WJJqFeLTn2BoFXtDQFAD+zpL9agmlh80dJ4WCq57hbvuPWDQ6gwsiVw4f7CY/0YaHEeecdcmEBXWR8PfHBkgXFuZScAGt39dzQPHa9buZGeee+Xywy7s+0TdB+TTcOWMxVxRJkZWhCQm83zu8d0IxOQV9y3jiTzXNDD+X3diF6S2L1n0FHgs8/+Eo4SXNDfFZHlrYc0dENPJPjxk81MLcwE0Rha/B5jVsiIW8pLkkC5RAirNhLcRFuu975XgMMRrPGgohNiDIL9ycc96k+fSIwmBKxxsGHjL2rxfsCjDeyLHuqhAQ8xU40SW5WAksTxgRCVIioTTdjvq+Jiw6d6nM2LO9Uo59KoVXCU1ifhRCV/JZhvhyxdrcoEq08aIUsudjW7XfOCuP+yTY58KBDhtLTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding sashiko review:

> > @@ -1451,11 +1453,27 @@ static int swap_extend_table_alloc(struct swap_info_struct *si,
> > return -ENOMEM;
> >
> > spin_lock(&ci->lock);
> > - if (!ci->extend_table)
> > - ci->extend_table = table;
> > - else
> > - kfree(table);
> > + /*
> > + * Extend table allocation requires releasing ci lock first so it's
> > + * possible that the slot has been freed, no longer overflowed, or
> > + * a concurrent extend table allocation has already succeeded, so
> > + * the allocation is no longer needed.
> > + */
> > + if (!cluster_table_is_alloced(ci))
> > + goto out_free;
> > + count = swp_tb_get_count(__swap_table_get(ci, ci_off));
> > + if (count < (SWP_TB_COUNT_MAX - 1))
> > + goto out_free;
>
> Is it possible for the extend table to still be leaked here due to a
> subsequent race?
> For example, if swap_retry_table_alloc() publishes the table because count is
> still SWP_TB_COUNT_MAX - 1:
> 1. Thread A in swap_retry_table_alloc() publishes the extend_table.
> 2. Before Thread A reacquires the page table lock and retries, Thread B
> unmaps the PTE.
> 3. Thread B calls swap_free(), decrementing the count from
> SWP_TB_COUNT_MAX - 1 to SWP_TB_COUNT_MAX - 2.
> 4. __swap_cluster_put_entry() only frees the extend table when the count
> decrements from SWP_TB_COUNT_MAX to SWP_TB_COUNT_MAX - 1, so the table
> remains attached.
> 5. Thread A resumes, sees pte_none, and skips the entry.
> Since the count never reached SWP_TB_COUNT_MAX, does the table remain
> permanently attached until the cluster is freed, triggering a WARN_ON_ONCE
> and a memory leak?

That seems possible indeed. I can adjust this a bit and avoid that
potential race too. The change is minor, I will send V2 shortly.

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 451d20bb9f47..365b4caeef4b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1536,13 +1536,21 @@ static void __swap_cluster_put_entry(struct
swap_cluster_info *ci,
                if (count == (SWP_TB_COUNT_MAX - 1)) {
                        ci->extend_table[ci_off] = 0;
                        __swap_table_set(ci, ci_off,
__swp_tb_mk_count(swp_tb, count));
-                       swap_extend_table_try_free(ci);
                } else {
                        ci->extend_table[ci_off] = count;
                }
        } else {
                __swap_table_set(ci, ci_off, __swp_tb_mk_count(swp_tb,
--count));
        }
+
+       /*
+        * `SWP_TB_COUNT_MAX - 1` triggers extend table allocation. If the
+        * count was above that then the extend table is no longer needed. And
+        * if we just put the count value from that value, it's possible that
+        * a pending dup just attached a extend table.
+        */
+       if (unlikely(count == SWP_TB_COUNT_MAX - 2 || count ==
SWP_TB_COUNT_MAX - 1))
+               swap_extend_table_try_free(ci);
 }

