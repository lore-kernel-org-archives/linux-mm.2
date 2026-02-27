Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD3FFD7F91
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 10:29:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A8956B0005; Fri, 27 Feb 2026 05:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57FF56B0088; Fri, 27 Feb 2026 05:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47ECA6B0089; Fri, 27 Feb 2026 05:29:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3A06B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 05:29:48 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA1411A05D4
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:29:47 +0000 (UTC)
X-FDA: 84489865614.18.F00A353
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id CB771140008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:29:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGqrf4x0;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772188185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xd17JnoJo6S2aV2mn8sK+M+XLw8HZ0TVxPbJ5OTC9MM=;
	b=hwIakSedPHFNBoBKDgh0a+rCOZf1S56+2KHs2yJXM9/7YTtpfcSJ2d6POxjXUbfj/cRfhb
	MbFmxKD1wL3eN5DQxzz6NCKubfMul9UpjUxQ+v6QfXCh6AlaeQfqwbh2h2ahKcS920NxLv
	5LWOsc21uSbKH4rnHhKMc4JKfFjPMDg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772188185; a=rsa-sha256;
	cv=none;
	b=10+RKrCOhusRBmIiOBoes7RwIO7aTzCRRa9AxWjr6nu7mGwU3YiuDwEkwDJEianksLCqBa
	P/axqpp+C6A6AnE33v9hswuYbQ8iOAtNXJcXoPGm85eapji/cJNJjdYAAtnqbxGn6qWgsZ
	ndHpL7WqCEN4g3ylkr8PPim3UGIOpCw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iGqrf4x0;
	spf=pass (imf26.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-354c825dc77so905445a91.0
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 02:29:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772188184; x=1772792984; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Xd17JnoJo6S2aV2mn8sK+M+XLw8HZ0TVxPbJ5OTC9MM=;
        b=iGqrf4x07cLSRRPFdtvKRd4b1fJfBzd+4o3gqp9+5irUVynzG/A8bA7hEeb4esnRIU
         E87C0QXg9lGhQ5Sr+ot1maoYF67c154o+Ojhd8PucjXZpdiBE/nQNUn/fkr5rqXC87y6
         tzL6APZhWvEzePc60vNxK5Wgw7nDzwwPy7qw7ch2EPsFSz0a8bdmDRyuTZzmXyMxz8/A
         QPjQdDCzIMzV4P8y3yHWXZVvFTTOA3/eO/cuj6g9Pzo+Cz/lrT+8O4pqqmn6P7HqT43v
         F5sKC6CnYPTOraBc0Oc4Kz7q0Bq1D4yeFrKujviMIK8m8z5UuGW+p2zs5b1kRAjgjNoi
         JRGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772188184; x=1772792984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xd17JnoJo6S2aV2mn8sK+M+XLw8HZ0TVxPbJ5OTC9MM=;
        b=GeGZXW6I/ZZxIg4rt8M5zWpT/b90hn+PVstXFOqB8ExZAapO8cE72+KbDT++idERE9
         ebbIc4tttidq+eujpyAuO2UWRAGJyN70PYUBhEHd/rxTSzHuiL7u3Qiz+HUQHsKOOgbN
         4bgafeVIe8L67+DVvFBCwP8JSa3q1bGShTh3Uj9e+0GN8EZWx2cgbNZT6VO9tSoy2rWr
         O2ey23x1idPPh9kfoeWlNoUa/aF+5vnBjUZhYby62d43VNqNDNsilqxBHIzSep9WMNg9
         pife1LkgC9kT8oC4wqO35h7p9cPusx/JuN1TkeP331JxKpg1WdhJYwIEqcsClb8S29Df
         xyig==
X-Forwarded-Encrypted: i=1; AJvYcCXW1u9FEn42FwDxGpPKE/5EO9Z363vwfP6RAQjuqia3u69XPZ/223u8pFMWVQC1UUrWr3cPDo6NFg==@kvack.org
X-Gm-Message-State: AOJu0YwaqB837lafWdKSZOe2LYnir7xRCdSEzD0u7oUNn/jKtfpnydiu
	Zake+ZcjqL3mlWvoH9Yf5tN1ojihTBG7SDSkHSMkkrkKQNkasGujLq4Q
X-Gm-Gg: ATEYQzydxEHugHsUM4oPW9Vcea6YlLNTZmyUicaNS0tluwBLFTAMFmW7OskvP81sBhh
	ZkvmnQR+0t2M41hPryQj80omW+hyrTrmTfPZdGN7zjZzH5KQMLiinxS0nCO5/9u8GsrulL7Iwdn
	CnxxGQlOo6q64E5PBrXwN/1Y+Ts5ppblJWlKXk7tLDDd8ELo5ni1J8pqJ2KRvhe7zYnksC4tKyw
	rqvw6Dag4bSrsYMIYyro8DC/yMlWYULKjjHLTZuUFUa6E8/gDSAGwkyqA4VM1l+bup2Nfyc6GVC
	9SiFjRgvRRQaEW1z4J7O3iMY62P1XyvmfN6CYrVxVI2bQytieKej70Vx7uxm7u4XsRIsY/tzRbB
	J/GYCnbQIyiE9eWWF5r8+FhPq7mhJXMxZhehaVUN+h9ryxkKdbRtpu0B7cwH7X6rfpPMeFuY2OS
	xfjHOTRyrh0YAR9mgMiXYWA6LEZJ/WacX8wJlWVWX3NwlrGoSjy1HF/jkk4V1w+zHBdVBk5k6pa
	h0f5Q==
X-Received: by 2002:a17:90b:1ccd:b0:359:1063:6aed with SMTP id 98e67ed59e1d1-35965c92637mr1922312a91.22.1772188184368;
        Fri, 27 Feb 2026 02:29:44 -0800 (PST)
Received: from localhost.localdomain (n058152022173.netvigator.com. [58.152.22.173])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3590158f6e0sm11615239a91.1.2026.02.27.02.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 02:29:43 -0800 (PST)
Date: Fri, 27 Feb 2026 18:29:38 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-mm <linux-mm@kvack.org>
Subject: Re: [LSF/MM/BPF TOPIC] Improving MGLRU
Message-ID: <f4c9b715-be7a-4587-90fa-97f6b72938eb@gmail.com>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
X-Rspamd-Queue-Id: CB771140008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: fbribzmypqpb79hbdqn114ye3zynwbg4
X-HE-Tag: 1772188185-672123
X-HE-Meta: U2FsdGVkX1/4KWrtDpioGL0+ASThJxwpLasleTOCqvtR2hWiGWOmp9zU4TzHMA/R3UNZnacNNsyJLRlyso4XFAW0aL6/JJp2n5ljByV13rlr9lKFB+X+cLW3eWfyFyqvDzMvK2VlirpTpgm9UkuwQJLNKUyy1P6ZjCGb7wt7lbNQ9ROb0wwvR4jDEOJQopdMAy5WPXeChg4GJDIZQ7B27IV6c17FeHn9kpEqx7k9o2OwOki6EkU3cAJCRb4P0r327ZdKJ26Gl9HoHqKPCJIKIm1e5k403uCJ9NP1xbJhL2lIB4v3sFO3/5V7DpscgsjKaJOBFy6BGRiObUMkFAnA4j/fCwiyLH2RgSTOdc7uXKrhf0JaJ37ng50epeU69C6snHMVjlBDy8e/fzznWF6+kftBmofNceFiYvJ+iftfxcnJ2dSKXjVZ8n0bU/ugkU2Z2lrcSSLuG+9DFyXzIltDdt21vpFVUwSYJfUV2K0m2bk7W9cSG8AAGARbp8pEHFvqtfuA9Nkd0GTqgvN3T+qWHtPUJDF1FyKqQQIFFjTuf6NxYV7g3TU4SZYAvq+PSPfwwMPB0eaiJ3yJKz+RjPBniPiV+3Iaz0MXOdKXDYzI7OK610xqdf5sFx/IlItvGe7Fbw5+4L7LUt/tMZSJeIo4BsS0Egym+rcXSt8NLq95jy4xNiXIKAK0UUtSiP6PDvspcQSJpGhvB1cH14rwZ0VdOf6iPJcOHR5D770PUAuIh3GAcoZ5YWZSVJOsZ6bBV7vMmkLoMr2mSKq488g9HbbEJ+rKbf+8vJUe1weA66GwfViG3Gl8DkuuX3M53x7Iei7K+ejo2acKK23kLKB7lqGtk4oBKnJ++AJcGWlT14ck+KoALdNsSHFVa7GYpfIKrg7kvLtNSf7ZXE/TkElK6fCpUXGYpA4ZfVZyxEM+9/rNgAvO9OriHThPZ7mb5vFMTnSGYVwVn2vG1TXnjUoRl8f
 ar1kdlfV
 OjnzBhOGM3pUPXp4NKeDSevO0mih/NOx49SXCZXrFBbsrZ36zvX4XcobHYs+cONX2gawfKmtUXYVPeWlg3/vrlgZEjaEwdfEHLi20GWZP/yOkTAhJ7hfEnGPQ1EDl+F8EcPwwj+VR+o0lP2WrYT1LEePTfqJX8r9+Nd1mNGD2pugQUuvq5ad6Nfb/DKoCiggY4SNMAMBaZ76ERMTM38aJPYDrOPBX6poUWPqAcq7msJIIp/MzffsuW1UmiYv+ofjBUG5S5h7U4ohl/8E9NyOcnR3QEr7qpmPns28Iwx+CuvVRqEaPrpeUBq5Qs2skWytujwRpJZ7824Y4laH95b6GjObZApyi23BpbyRhS3ZRNL8rLNZ+jEcba9LFcpk1UuF6+3mT7MV0uL8nQtEp5IPqtpbtERIrn8uz1Kp6HWYdxzGJw8Uyp+U/2E5rv0nENsklgCCfaQWdPS8Mq4OMTcJIDU4eVzC0lH4mJM+IoF93d/BD0wrV39fl3XEwkehK8LZr4s5Pc9wv94oIRMFjZoAouwVN5y9feKm4zgoICUJlq1l71Eo7ugR85zTcX1MeIPewc+TCgx6mUOK0vVrm+2KRiODTfTT4DwKwiYgwGfo4ziTSvLQm9cJw6aA1Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 01:25:33AM +0800, Kairui Song wrote:
> Hi All,
>
> Apologies I forgot to add the proper tag in the previous email so
> resending this.
>
> MGLRU has been introduced in the mainline for years, but we still have two LRUs
> today. There are many reasons MGLRU is still not the only LRU implementation in
> the kernel.
>
> And I've been looking at a few major issues here:
>
> 1. Page flag usage: MGLRU uses many more flags (3+ more) than Active/Inactive
> LRU.
> 2. Regressions: MGLRU might cause regression, even though in many workloads it
> outperforms Active/Inactive by a lot.
> 3. Metrics: MGLRU makes some metrics work differently, for example: PSI,
> /proc/meminfo.
> 4. Some reclaim behavior is less controllable.
>
> And other issues too.
> And I think there isn't a simple solution, but it can definitely be solved. I
> would like to propose a session to discuss a few ideas on how to solve this, and
> perhaps we can finally only have one LRU in the kernel. So I'd like topropose a
> session to discuss some ideas about improving MGLRU and making it the only LRU.
>
> Some parts are just ideas, so far I have a working series [2] following the
> LFU and metric unification idea below, solving 2) and 3) above, and
> providing some very basic infrastructures for 1). Would try to send that as
> RFC for easier review and merge once it's stable enough soon, before LSF/MM/BPF.
>
> So far, I already observed a 30% reduction of refault of total folios in
> some workloads, including Tpcc and YCSB, and several critical regressions
> compared to Active / Inactive are gone, PG_workingset and PG_referenced are
> gone, yet things like PSI are more accurate (see below), and still stay
> bitwise compatible with Active / Inactive LRU. If it went smoothly,
> we might be able to unify and have only one LRU.
>
> Following topic and ideas are the key points:
>
> 1. Flags usage: which is solvable, and the hard part is mostly about
>    implementation details: MGLRU uses (at least) 3 extra flags for the gen
>    number, and we are expecting it to use more gen flags to support more than 4
>    gen. These flags can be moved to the tail of the LRU pointer after carefully
>    modifying the kernel's convention on LRU operations. That would allow us to
>    use up to 6 bits for the gen number and support up to 63 gens. The lower bit
>    of both pointers can be packed together for CAS on gen numbers. Reducing
>    flag usage by 3. Previously, Yu also suggested moving flags like PG_active to
>    the LRU pointer tail, which could also be a way.
>
>    struct folio {
>        /* ... */
>        union {
>                struct list_head lru;
>    +           struct lru_gen_list_head lru_gen;
>
>    So whenever the folio is on lruvec, `lru_gen_list_head` is used instead of
>    `lru`, which contains encoded info. We might be able to move all LRU-related
>    flags there.
>
>    Ordinary folio lists are still just fine, since when the folio is isolated,
>    `lru` is still there. But places like folio split, will need to
> check if that's
>    a lruvec folio, or folio on an ordinary list.
>
>    This part is just an idea yet. But might make us able to have up to 63 gens
>    in upstream and enable build for every config.
>
> 2. Regressions: Currently regression is a more major problem for us.
>    From our perspective, almost all regressions are caused by an under- or
>    overprotected file cache. MGLRU's PID protection either gets too aggressive
>    or too passive or just have a too long latency. To fix that, I'd propose a
>    LFU-like design and relax the PID's aggressiveness to make it much more
>    proactive and effective for file folios. The idea is always use 3 bits in
>    the page flags to count the referenced time (which would also replace
>    PG_workingset and PG_referenced). Initial tests showed a 30% reduction of
>    refaults, and many regressions are gone. A flow chart of how the MGLRU idea
>    might work:
>
>    ========== MGLFU Tiering ==========
>    Access  3 bit    lru_gen  lru_gen |(R - PG_referenced | W - PG_workingset)
>    Count   L|W|R    refs     tier    |(L - LRU_GEN_REFS)
>    0       0|0|0    0        0       | - Readahead & Cache
>    1       0|0|1    1        0       | - LRU_REFS_REFERENCED
>    ----- WORKINGSET / PROMOTE --- <--+ - <move out of min_seq>
>    2       0|1|0    2        0       | - LRU_REFS_WORKINGSET
>    3       0|1|1    3        1       | - Frequently used
>    4       1|0|0*   4        2       |
>    5       1|0|1*   5        2       |
>    6       1|1|0*   6        3       |
>    7       1|1|1*   7        3       | - LRU_REFS_MAX
>    ---------- PROMOTION ----------> --+ - <promote to next gen>
>
>    Once a folio has an access count > LRU_REFS_WORKINGSET, it never goes lower
>    than that. Folios that hit LRU_REFS_MAX will be promoted to next gen on
>    access, and remove the force protection of folios on eviction. This provides
>    a more proactive protection.
>
>    And this might also give other frameworks like DAMON a nicer interface to
>    interact with MGLRU, since the referenced count can promote every folio and
>    count accesses in a more reasonable and unified way for MGLRU now.
>
>    NOTE: Still changing this design according to test results, e.g. maybe
>    we should optionally still use 4 bits, so the final solution might not
>    be the same.
>
>    Another potential improvement on the regression issue is implementing the
>    refault distance as I once proposed [1], which can have a huge gain for some
>    workloads with heavy file folio usage. Maybe we can have both.
>
> 3. Metrics: The key here is about the meaning of page flags, including
>    PG_workingset and PG_referenced. These two flags are set/cleared very
>    differently for MGLRU compared to Active / Inactive LRU, but many other
>    components are still using them as metrics for Active / Inactive LRU. Hence,
>    I would propose to introduce a different mechanism to unify and replace these
>    two flags: Using the 3 bits in the page flags field reserved for LFU-like
>    tracking above, to determine the folio status.
>
>    Then following the above LFU-like idea, and using helpers like:
>
>    static inline bool folio_is_referenced(const struct folio *folio)
>    {
>     return folio_lru_refs(folio) >= LRU_REFS_REFERENCED;
>    }
>
>    static inline bool folio_is_workingset(const struct folio *folio)
>    {
>     return folio_lru_refs(folio) >= LRU_REFS_WORKINGSET;
>    }
>
>    static inline bool folio_is_referenced_by_bit(struct folio *folio)
>    {    /* For compatibility */
>     return !!(READ_ONCE(*folio_flags(folio, 0)) & BIT(LRU_REFS_PGOFF));
>    }
>
>    static inline void folio_mark_workingset_by_bit(struct folio *folio)
>    {    /* For compatibility */
>     set_mask_bits(folio_flags(folio, 0), BIT(LRU_REFS_PGOFF + 1),
> BIT(LRU_REFS_PGOFF + 1));
>    }
>
>    To tell if a folio belongs to a working set or is referenced. The definition
>    of workingset will be simplified as follows: a set referenced more than twice
>    for MGLRU, and decoupled from MGLRU's tiering.
>
> 4. MGLRU's swappiness is kind of useless in some situations compared to
>    Active / Inactive LRU, since its force protects the youngest two gen, so
>    quite often we can only reclaim one type of folios. To workaround that, the
>    user usually runs force aging before reclaim. So, can we just remove the
>    force protection of the youngest two gens?

Hi Kairui,

I would be very interested in discussing this topic as well.

In Linux desktop distributions, when the system rapidly enters low
memory state, it is almost impossible to enter S4, the success rate
only is 10%. When analyzing this issue, it was identified as the
inability to reclaim memory. Further investigation revealed that:

1. This phenomenon does not occur with Active/Inactive LRU, it only
   exists with MGLRU.
2. If force aging is performed before entering S4, the success rate
   exceeds 90%.

Detailed memory information is as follows.

MemFree:          269944 kB
Active:          4095536 kB
Inactive:        2831960 kB
Active(anon):    2667952 kB
Inactive(anon):   247208 kB
Active(file):    1427584 kB
Inactive(file):  2584752 kB

Since its force protects the youngest two gen, when wanting to reclaim
memory larger than the "Inactive" size, the MGLRU hard to reclaim enough
memory. e.g. hibernation mode call shrink_all_memory(3G).

We addressed this issue by implementing a retry mechanism similar to
memory.reclaim, the success rate of s4 has increased from 10% to 100%.

If we could directly remove the force protection of the youngest two
generations, this issue would also be resolved, and the solution would
be more universally applicable.

--
Cheers,
Vernon

> 5. Async aging and aging optimization are also required to make the above ideas
>    work better.
>
> 6. Other issues and discussion on whether the above improvements will help
>    solve them or make them worse. e.g.
>
>    For eBPF extension, using eBPF to determine which gen a folio should be
>    landed given the shadow and after we have more than 4 gens, might be very
>    helpful and enough for many workload customizations.
>
>    Can we just ignore the shadow for anon folios? MGLRU basically activates
>    anon folios unconditionally, especially if we combined with the LFU like
>    idea above we might only want to track the 3 bit count, and get rid of
>    the extra bit usage in the shadow. The eviction performance might be even
>    better, and other components like swap table [3] will have more bits to use
>    for better performance and more features.
>
> The goal is:
>
> - Reduce MGLRU's page flag usage to be identical or less compared to Active /
>   Inactive LRU.
> - Eliminate regressions.
> - Unify or improve the metrics.
> - Provides more extensibility.
>
> Link: https://lwn.net/Articles/945266/ [1]
> Link: https://github.com/ryncsn/linux/tree/improving-mglru [2]
> Link: https://lore.kernel.org/linux-mm/20260218-swap-table-p3-v3-5-f4e34be021a7@tencent.com/
> [3]
>


