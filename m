Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EBDE9A053
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93CA36B0005; Thu, 19 Feb 2026 12:26:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA236B0089; Thu, 19 Feb 2026 12:26:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF386B008A; Thu, 19 Feb 2026 12:26:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 632CB6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:26:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14FBE1B58D8
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:26:15 +0000 (UTC)
X-FDA: 84461884710.02.7EB80A6
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id 344891C000F
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:26:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=na4B2Teh;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771521973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JV97SDQt+B4S3g9wifTSiOcyvSjPUUf+slORBauOG/0=;
	b=xcmq5TpgdPxvKSmaNhc6caV0oQK41GVv079L0NMEX9Et4+vz+czDoreu9cReNuOazy7DSm
	d8v2AYeEtIOlIK8wHf6Bhxbx6cKs+D4R92p+jbnauwULsiDkDDR070hlEFoxftlk3GNEjS
	MNah3rXWW9ZHN/qo6jZ/wemI0pAs8MA=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=na4B2Teh;
	spf=pass (imf21.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771521973; a=rsa-sha256;
	cv=pass;
	b=TKiAXL2fuYCNweAfYbtNaIdFSyfnDMeZQYBT2zLz4Cy7lJ25890s+y0PM+3nNWu1XS+NK+
	gMeWXe2gjQlhiH7/uLOOVgcr9+20Kub9ij6/WmfZ327ULCpmYnlJ57tyLUUg4tkxhcIaKX
	GSrPMQgYYfPauWm4zxfEfPBKw5mW5w8=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b8fbe5719ceso235046766b.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:26:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771521972; cv=none;
        d=google.com; s=arc-20240605;
        b=JTe54y8Kqpwrmt/AU/fAPAEq/b2Alcg8u823nNJDozBwG6aAUX3Igpe6r6cHuYVSzM
         2P7ZtIRsPeAA6dD+icH0AU5yFLjqf0ujtaSM21pBqw/97qEX63+t/ZT31HwrJ6IRZHEc
         TShwh02ITjheuxK8RzGGAM7d0GmXKxj653J/tfKfcLHqCkfEuDm2CF0mkdQa5hkocf0C
         jnN4zobewHBnuRNoyHsYR/v/+i1hBPSANnnBSX48UMobzUXCqlqXYDb5qUQtrmGrItLD
         j1l31dqJ8lZJ5VL4KQGuOgioO41mrSFNtHGbINzAJRBPipE9UpFpwTgAFqZQE0rwj7Uk
         bocQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=JV97SDQt+B4S3g9wifTSiOcyvSjPUUf+slORBauOG/0=;
        fh=wpV44rI4wWBVcTTH/ZkG+tNZCQYPez7Jaup/MycB+Sg=;
        b=N1LH2a2e/inNohNEbhqOxnt+CwykNDRbRf7ltuk/x8ZyxxThic3tdGywZ4pGAqjYmw
         XOxcxTA4jyZ5MuRBvN0id2AC2Ig/vLjNKGtHoMrfD2/lY8OkJZx9kaVUyQ3uaWEyxOEk
         LNqsCv0eE9W6pQrMTMtP12pBWbAkyb1ihpXoc6xeIX2kzXkg7MttEgJRifhOY5prtnnV
         f5/P+/MqstJCLrwtvPdwCJRY+879U7thttJTRXy84DZPrrzfUe0gcybuqWlgqGh+wBK8
         tnA1r96r35bJ51ZeEOeULLkKLOfrrnh0+FLnGG8AT739uiOrk3mX484RZoHX87IvI+rI
         yfWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771521972; x=1772126772; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JV97SDQt+B4S3g9wifTSiOcyvSjPUUf+slORBauOG/0=;
        b=na4B2TehiLLby/DBoQWFHA1iEwraZl4yahY5jXU8kd92B6LAcOMjCuCBnIwksXA9AM
         vaTfORfgC59MRB3/H3HA34N0lCIB5InmczPHh213fovgGHN5t5GjIzTtpkKMLu3//ku8
         bhwOCzsIZCTQ80wf4NDk36V/RkskecswCV42cC3+jdXKVINJLpwTzzgPCVm6Zq2796//
         QEPvE0YFPwrTls/k4j0VJY0/M2ZFmXIUoPKl/pe7VHKke59hl6iiCt6iDCT/0v5f9sFa
         39QhFtAVm9WiLucPWkjQp5TXhVU5FhXg8V1Cwug52ydiOJfhdQo8iNnhAuKGuQmUKyGU
         4a2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771521972; x=1772126772;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JV97SDQt+B4S3g9wifTSiOcyvSjPUUf+slORBauOG/0=;
        b=L2WBlwpAqClC5IHUnfniBmwbv0i4OTT3OdRW8DTZV2TC0du+0lchTAG6UiwzDDv7No
         ZfSKQRIqjXpG6bp7gOxtTIAroPC9R54PdI5rL5T4zf7PvU3KrMHLXhguVL4Lkco5iA6d
         0qIm0MA/FfmPmzLjPyTRRUEojc2+8aBfar2YIXIgLNZtvOOEZt3SPXLyjVHqNx+n8c4T
         9HUbM4mZjRPJq37JHzHLGkHitcZktYhrUokxNZPiKDZWdJ90nNEAuji+5iFerrgus/W2
         DPKMr8pX1KqpOiohIBCpdva4G0RmTmkKsj+mX/6PBpu1hGbKNQ5016c5r6Re30imzSF3
         Q3hA==
X-Forwarded-Encrypted: i=1; AJvYcCXmo0n7jR+GiG1wBwlO6Igp926unJHEHZZpnFNwlwlK3kVnDPds43iu7BADEn948y9VUE7WPCffuA==@kvack.org
X-Gm-Message-State: AOJu0Yz33f3QnstzwO10fn2HlCuPLtqCIn0R5HFsUTpi/SxiETMRwQ3q
	QZ5X9v0CL0fODwn/9TOTH03gb/r4+zBL/Xj7iKNvAhnu++rLxAUrGuSvR4pnJSz/ewi1Fr4MUEu
	FsLfjC3TwnpKf7o8nnZE1KpbhssmIUDA=
X-Gm-Gg: AZuq6aIRVEBLAt85VV31C7S0wcg1KcAlzfZi3eNgRPeam5fQpo8dQKpE+PYJS3/Vviq
	RSlJli7HLjR7grnLsd1+zOrupbL5/Balqzk7UYQbq40v01zlxEjc7zN6qZt5ltdO4w/iekMF0Vo
	aHTUeFKQoo4cK8COyvzhKbBlinJFnC3Sz+Q+Qe3BxqmOGIvc6erLPwAgWjTVZllou0jtdUlznEn
	fJ5U4NeVZrZGOjMFzZbFK5jE6QpYKZofVfmEAvKYSlTDw4++HviXPgC8cLbE8aLJWNbt6zWQ2tp
	ih21W4XU7UOTQcC8RHUdKCoRmwNYDYpcpzW4GlGkuaNkjOYtIbE=
X-Received: by 2002:a17:907:7215:b0:b8f:9fe5:fd62 with SMTP id
 a640c23a62f3a-b904dc6a2fdmr209711666b.42.1771521971313; Thu, 19 Feb 2026
 09:26:11 -0800 (PST)
MIME-Version: 1.0
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Feb 2026 01:25:33 +0800
X-Gm-Features: AaiRm53zhnzPLnk8KFWJHfDt0AptWFmxbQsc-cOjtqp9oLQwO5DcZyTr-Critbs
Message-ID: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
Subject: [LSF/MM/BPF TOPIC] Improving MGLRU
To: lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 344891C000F
X-Rspamd-Server: rspam02
X-Stat-Signature: w764zbozo83nmo8dtb9axtg5gz7xq7pu
X-HE-Tag: 1771521972-294737
X-HE-Meta: U2FsdGVkX1/LxJX/BxJqYJUVl5FloGIAdENu1zwPKnkKc5Q8xmmwYUex1EfevccZOM2mfVnJNb0uZQvCcq3CNUazVRp9MwFKYXK4SDu0iXyaQM8nqI61GSTlQekihPJQWik7zJ5C0/F5fbYr7Vp5Al8LmYr+3NRcpqDJvjk+xmC+S0KUzIeyVRxiWOrtMLo0pXtEdhNZIGKYGgbBQfS5pq/YWexyGEk8B8nhnpfQERL1RL9+P97SGSB7VA8+BksHoqVBMo/vXcH8Fd5JvBV92ZYERcyd3soWxp2VbNB6HGMxF8txZtKWrfLHLWsnjh4l88ptptpFWawkGfgZ6GPPUFYZ+KRZ4LvLvkpG6zvwqU84Xztj6JkA64bZBTNkDwQoMBxQ7BNJvvth2GqsfN1EdAIGCkrtRtItuSgG5VZj7aLpXcaSMm1ryfqsGrqM99LvxaG6+DkdaSc7uJQQ+Shdqtx93qqR/E72gPQfvYsCdX4foY7VPUIYg/gL3HmvHqbNyFMM6PZwYh/drKhWhp4AWB9/gu80gAmkesqvAdcZTD8Bo5CTpFABxRrS6M4EhsrdlciKFFBzvxmqZj1W+8spGWo0lK/T/XQHui8ECafF8DFeWiKdLEsdZC2+bV4TzWwQlkm+n1Hlg0yYmpHxQabzIF5tNyNMrrYasx7Dv4pCp+37rUCn1j2ViH9vYq0SZ0k6ni3a2ANMOwLWTKK+RwhFl/2IJVj8o+feSwvtawBFTclJlFOEK3vrZwASjZ7d5eA3vLlo6wDDKsXmJHavkCcCTux9UUNU1Jqs0RNshxE1gxQxiAPgc4OkI1nVaE095/rheLmFB6Xg5uwwxQTVbZsvc6SwMnXB6flnbwjNlj63Pi3TnfAW8zW8oD9u5ZCIBdjyqI2prYUHdGLhvKYadJicKUO70D030YlI0cYsCwggPKWATxoFtYKJIWSg+4ZeWDyUh3wOLFAzo9ko3UL0IQf
 Ja+tDxs8
 BtnslZ2uW/L7HXNkYFy+ujALoQx3QUfbtFvBKU3NXjY0cFMPZiuaM33yRu5cvClMMeD6o32CHt8W5h01MxLikvJ3XCoeIWZRcwVWQhlcvfGqEi4gNln3lysvsOMiw47d6oFrA+BzZoVwFYRFMYtuzbpYq6ptDz054w7NnTG9HeFIZYKzDw24WLR/0DcAvPH8HW7XiKU16oV2Z7AZsXMC522bg3toSc2Iuur/linyNZ4M7xju5gZ/7g12TNpKOz79od4vhPXNiMtZxTR3lUXE++dwaS10Yd7hKAAIrWtGN9afSvnJp2fY+Ip1QS/pWY6sfWckXNWHIei6I2wwHvZCni3Y66ZitU+TsMV0iHKLNlbxSN6ECnf2bMWFPie4V6xHFvwXXaMZav2n0yzd970I+DnCVrQTQODdbW3ydfx/bUPE1MxnJmbJ7tOK6pHhPdnKRnOQexG5B0m+zL7NebE0RAjBPEZYw/70BFJ+ggXg5IBFyOHdKQ8EIjvLVFKK+oOZpMJSY+SXGG3VJ64qakKZQJdlrGw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

Apologies I forgot to add the proper tag in the previous email so
resending this.

MGLRU has been introduced in the mainline for years, but we still have two LRUs
today. There are many reasons MGLRU is still not the only LRU implementation in
the kernel.

And I've been looking at a few major issues here:

1. Page flag usage: MGLRU uses many more flags (3+ more) than Active/Inactive
LRU.
2. Regressions: MGLRU might cause regression, even though in many workloads it
outperforms Active/Inactive by a lot.
3. Metrics: MGLRU makes some metrics work differently, for example: PSI,
/proc/meminfo.
4. Some reclaim behavior is less controllable.

And other issues too.
And I think there isn't a simple solution, but it can definitely be solved. I
would like to propose a session to discuss a few ideas on how to solve this, and
perhaps we can finally only have one LRU in the kernel. So I'd like topropose a
session to discuss some ideas about improving MGLRU and making it the only LRU.

Some parts are just ideas, so far I have a working series [2] following the
LFU and metric unification idea below, solving 2) and 3) above, and
providing some very basic infrastructures for 1). Would try to send that as
RFC for easier review and merge once it's stable enough soon, before LSF/MM/BPF.

So far, I already observed a 30% reduction of refault of total folios in
some workloads, including Tpcc and YCSB, and several critical regressions
compared to Active / Inactive are gone, PG_workingset and PG_referenced are
gone, yet things like PSI are more accurate (see below), and still stay
bitwise compatible with Active / Inactive LRU. If it went smoothly,
we might be able to unify and have only one LRU.

Following topic and ideas are the key points:

1. Flags usage: which is solvable, and the hard part is mostly about
   implementation details: MGLRU uses (at least) 3 extra flags for the gen
   number, and we are expecting it to use more gen flags to support more than 4
   gen. These flags can be moved to the tail of the LRU pointer after carefully
   modifying the kernel's convention on LRU operations. That would allow us to
   use up to 6 bits for the gen number and support up to 63 gens. The lower bit
   of both pointers can be packed together for CAS on gen numbers. Reducing
   flag usage by 3. Previously, Yu also suggested moving flags like PG_active to
   the LRU pointer tail, which could also be a way.

   struct folio {
       /* ... */
       union {
               struct list_head lru;
   +           struct lru_gen_list_head lru_gen;

   So whenever the folio is on lruvec, `lru_gen_list_head` is used instead of
   `lru`, which contains encoded info. We might be able to move all LRU-related
   flags there.

   Ordinary folio lists are still just fine, since when the folio is isolated,
   `lru` is still there. But places like folio split, will need to
check if that's
   a lruvec folio, or folio on an ordinary list.

   This part is just an idea yet. But might make us able to have up to 63 gens
   in upstream and enable build for every config.

2. Regressions: Currently regression is a more major problem for us.
   From our perspective, almost all regressions are caused by an under- or
   overprotected file cache. MGLRU's PID protection either gets too aggressive
   or too passive or just have a too long latency. To fix that, I'd propose a
   LFU-like design and relax the PID's aggressiveness to make it much more
   proactive and effective for file folios. The idea is always use 3 bits in
   the page flags to count the referenced time (which would also replace
   PG_workingset and PG_referenced). Initial tests showed a 30% reduction of
   refaults, and many regressions are gone. A flow chart of how the MGLRU idea
   might work:

   ========== MGLFU Tiering ==========
   Access  3 bit    lru_gen  lru_gen |(R - PG_referenced | W - PG_workingset)
   Count   L|W|R    refs     tier    |(L - LRU_GEN_REFS)
   0       0|0|0    0        0       | - Readahead & Cache
   1       0|0|1    1        0       | - LRU_REFS_REFERENCED
   ----- WORKINGSET / PROMOTE --- <--+ - <move out of min_seq>
   2       0|1|0    2        0       | - LRU_REFS_WORKINGSET
   3       0|1|1    3        1       | - Frequently used
   4       1|0|0*   4        2       |
   5       1|0|1*   5        2       |
   6       1|1|0*   6        3       |
   7       1|1|1*   7        3       | - LRU_REFS_MAX
   ---------- PROMOTION ----------> --+ - <promote to next gen>

   Once a folio has an access count > LRU_REFS_WORKINGSET, it never goes lower
   than that. Folios that hit LRU_REFS_MAX will be promoted to next gen on
   access, and remove the force protection of folios on eviction. This provides
   a more proactive protection.

   And this might also give other frameworks like DAMON a nicer interface to
   interact with MGLRU, since the referenced count can promote every folio and
   count accesses in a more reasonable and unified way for MGLRU now.

   NOTE: Still changing this design according to test results, e.g. maybe
   we should optionally still use 4 bits, so the final solution might not
   be the same.

   Another potential improvement on the regression issue is implementing the
   refault distance as I once proposed [1], which can have a huge gain for some
   workloads with heavy file folio usage. Maybe we can have both.

3. Metrics: The key here is about the meaning of page flags, including
   PG_workingset and PG_referenced. These two flags are set/cleared very
   differently for MGLRU compared to Active / Inactive LRU, but many other
   components are still using them as metrics for Active / Inactive LRU. Hence,
   I would propose to introduce a different mechanism to unify and replace these
   two flags: Using the 3 bits in the page flags field reserved for LFU-like
   tracking above, to determine the folio status.

   Then following the above LFU-like idea, and using helpers like:

   static inline bool folio_is_referenced(const struct folio *folio)
   {
    return folio_lru_refs(folio) >= LRU_REFS_REFERENCED;
   }

   static inline bool folio_is_workingset(const struct folio *folio)
   {
    return folio_lru_refs(folio) >= LRU_REFS_WORKINGSET;
   }

   static inline bool folio_is_referenced_by_bit(struct folio *folio)
   {    /* For compatibility */
    return !!(READ_ONCE(*folio_flags(folio, 0)) & BIT(LRU_REFS_PGOFF));
   }

   static inline void folio_mark_workingset_by_bit(struct folio *folio)
   {    /* For compatibility */
    set_mask_bits(folio_flags(folio, 0), BIT(LRU_REFS_PGOFF + 1),
BIT(LRU_REFS_PGOFF + 1));
   }

   To tell if a folio belongs to a working set or is referenced. The definition
   of workingset will be simplified as follows: a set referenced more than twice
   for MGLRU, and decoupled from MGLRU's tiering.

4. MGLRU's swappiness is kind of useless in some situations compared to
   Active / Inactive LRU, since its force protects the youngest two gen, so
   quite often we can only reclaim one type of folios. To workaround that, the
   user usually runs force aging before reclaim. So, can we just remove the
   force protection of the youngest two gens?

5. Async aging and aging optimization are also required to make the above ideas
   work better.

6. Other issues and discussion on whether the above improvements will help
   solve them or make them worse. e.g.

   For eBPF extension, using eBPF to determine which gen a folio should be
   landed given the shadow and after we have more than 4 gens, might be very
   helpful and enough for many workload customizations.

   Can we just ignore the shadow for anon folios? MGLRU basically activates
   anon folios unconditionally, especially if we combined with the LFU like
   idea above we might only want to track the 3 bit count, and get rid of
   the extra bit usage in the shadow. The eviction performance might be even
   better, and other components like swap table [3] will have more bits to use
   for better performance and more features.

The goal is:

- Reduce MGLRU's page flag usage to be identical or less compared to Active /
  Inactive LRU.
- Eliminate regressions.
- Unify or improve the metrics.
- Provides more extensibility.

Link: https://lwn.net/Articles/945266/ [1]
Link: https://github.com/ryncsn/linux/tree/improving-mglru [2]
Link: https://lore.kernel.org/linux-mm/20260218-swap-table-p3-v3-5-f4e34be021a7@tencent.com/
[3]

