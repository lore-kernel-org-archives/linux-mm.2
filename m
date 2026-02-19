Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADC4E9A052
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1360B6B0092; Thu, 19 Feb 2026 12:10:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078046B0093; Thu, 19 Feb 2026 12:10:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06006B0095; Thu, 19 Feb 2026 12:10:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C44D56B0092
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:10:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 86E961B58C3
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:10:07 +0000 (UTC)
X-FDA: 84461844054.18.7C129F9
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id A2B4E40005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:10:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QrYABH3J;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771521005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SfOnUUghgm3+fdRkPGu24cbqVbuOmL72xyd/b5ck1c8=;
	b=m4xSMC3KASRmS7RuSvcb3OvEVMLDTu2vKE7tNF0NUe6CqnjuMgBbCrhZFhVTaUK2JEf2zR
	6DhXmb5ai95QXQEQEHGOgxcsyNo89VAc0brMHvaDj9aW6fsZVIMSQae0ObnpRNyyFLIAtF
	fur4QHX0xBMn9kNpErFXVyrMxgtgtEM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QrYABH3J;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771521005; a=rsa-sha256;
	cv=pass;
	b=J4FFz9kwhx8yOK69ZxOI/vK9NaVcWdZxsR1srShtoi/WbvO3ZftKWuyFcf6haNEIVbCmDF
	Id/2L4BEzJP5RK+1XIkpyHQui5qQD0wX4FXkcT5sDGDRKeOee4CXWzJTN2y0Wh2acTJWYH
	Ye+ieTTcT0y3p0YY9CCrMkXYV31HqkQ=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-65c4152313fso1300061a12.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:10:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771521004; cv=none;
        d=google.com; s=arc-20240605;
        b=VuISeWG81aYmgf2CrF++J0PAuMqBVnTu54ASHNsDHLZpI7m/dMtnBW75OjZ7MMfsJb
         H/BOgMqlQkOV+vZ4qBbAht7TNr/DxbERgmL9im+RCF3LRT9eKwy5yoW3XkOj/meWbQiy
         Bqw8JrLs9Yrco+T6O/K7T5G9Bfj3vI0dzfKvKIMf54gv33s66YIYpxR+poQonxB2lAzp
         wigsM/OGp08DBex0vzOTe0YYAY7GHCZ8f8+Ign8vzMF5AB0oON8cqW2OKC6h2LbXSJoa
         fy1X+MkGx19htz9GWzj46rKhwPm5GDD2+g1qFg/IWIcpPfDpGnt9pozVDm1gRsRLHebm
         qWRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=SfOnUUghgm3+fdRkPGu24cbqVbuOmL72xyd/b5ck1c8=;
        fh=rKaOCJopJKH7YSN7OXnn51KxqeHH6mO8BaFfO0Yae2Y=;
        b=g6fjfF2mxubZjM5gsNX1BuClYG+cYZ+JowMD8R9qR109GSQdv4tw59j+UcjKbvOSEI
         219gCsDBiVoi7/AdmnLxedcN2ABXqPDwrzg9+h1heGxBPgtiHVLpjs6DU2eUp2ZBFVz2
         wQcyn70iyTzWZe8dxi7VCfEXcNAiFdpnq9/LS+APXfmEhdyNU28ExW/vVWXB24lbz5Pw
         nkVojXHL00bEg8SuMbP0CcknQgyJnxp/VbGtyQY+oKOgBWJ1Fo+Rl/0afbrVbtFrek6+
         V0fq9iQDA4rfJdTNxFoh3cKCua9TUjoYf45yUhbo0F0k6hT5o2TVnzhSa+HtUqZ2BSuo
         ATRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771521004; x=1772125804; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SfOnUUghgm3+fdRkPGu24cbqVbuOmL72xyd/b5ck1c8=;
        b=QrYABH3J/+kRYq5edziRfQC+cZ9fE7TPAIzMSd/aetDK7OBgegcqzn0Pquz0G39Bz8
         jj8OOWSBJN12TH61S9i6NfKDYXn5T9alYQY04cHhpcKpMKnF5YVXlI976qzYqwAjqvi+
         CIQbKqVdRZvm3P0XRZPFD3MITlKO6rKIgbB1dfrO7ygMeREQXMpVSwaGUUSw8IIfJcZc
         qYR/RS7kB7jZfqO8iKLJzjNXYualPPvEuKT0laZiJ5IAvm4PQ5fVcyQO6YjXulp6n1dL
         nbqVnuAloZZFH4KJtH4+hcOF5873Zl55s8fK/QScw2M5hr6t2h0hC4UTKzJ4gXSyRWqM
         ZxZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771521004; x=1772125804;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SfOnUUghgm3+fdRkPGu24cbqVbuOmL72xyd/b5ck1c8=;
        b=gK+LaaMacwthdqfEdS9fTtGCR5+7VjSzWgO7dnWpGiy09Cqi+GXmQNSTpjWN308k9a
         PZt3ZSbpqDKTo70mKUdarpykYT+QOiqMg6IiOns0k6HMK074MifJNMjxzN4wrfZbR1jR
         R0PEULH1wIaIdeyH8t60Vp/LrX62AtoPMKC/ZZpEypcFqoRPC/lqLfPZOiLvc7ksjLUC
         Ma96aDBJlqK/JMBAjR+39JyEKXcTfkAwQXibgzxY1HGmR8fZ8UAoP/chkhhxt1VUrwlO
         HHENjJ6Sf56RkAIQa5QIY/L5x96Iho8/OtKkYsAMIWcggYhfZ6w3Mj5nhQ1lqXXEQ4Ij
         AZUQ==
X-Forwarded-Encrypted: i=1; AJvYcCXuVQMArVXuG2ZlRB3Zq70yASb9OhNSMHxW6OgQUmTtBkmi7ms8MqBsszG+e6DR1GT0cbXWCWHZGg==@kvack.org
X-Gm-Message-State: AOJu0YxkbvRBI/q5SCJTwo9/pIY5x+LgW02nhsK3nxMhNNtRTs0Vf75M
	R3AOkUIFvkslGYsdU1gi+PQdJTtlAhIBHIxZyaDVUk24XezZDbIhJv1CYlSfeGGWVt+QvGBDoha
	VsqtUwPCPsZ3A+JT51RSYAz5nBY+7z1GDcDj+e2IFYw==
X-Gm-Gg: AZuq6aLInVEw1+4/ytfVdMmD56JtsIaSbyiXKDpokOwR+GqdSOsw/BI4jP4/YZyhcEk
	Ma8Xzwg3gVju0cuIjog+0/TmgVP97g7sb0/5VMvN5qbNGQnMH3E0pF53AiNYqpO3rPXHEZxEyiq
	xd2PcutXv2w5qoDmfWCulGSVk2DJdT03tQzLsv9AtWs9SGEC3yFJKS3i9FH4sPyLIOFIH24iMfd
	bcZOKHYj9jPTftT9fNznfyZlAp5dYkP4oqWXUO9HdsLTSGnSch2TVH1iuEoLH12h/MQiJfFYg8m
	/WqgY27AxOTdyQLPaHTtDatjV+eF7sAME9jBf+76
X-Received: by 2002:a17:907:7215:b0:b8f:9fe5:fd62 with SMTP id
 a640c23a62f3a-b904dc6a2fdmr206963066b.42.1771521003677; Thu, 19 Feb 2026
 09:10:03 -0800 (PST)
MIME-Version: 1.0
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 20 Feb 2026 01:09:27 +0800
X-Gm-Features: AaiRm50zrqp78V0Krn7VW-DgHg4OPDcNXDr0bwNcyrfHNUiYHaLGgQn9Ou5LHnw
Message-ID: <CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com>
Subject: [LSF/MM/BPF] Improving MGLRU
To: lsf-pc@lists.linux-foundation.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: A2B4E40005
X-Rspamd-Server: rspam02
X-Stat-Signature: hqomz83mbcg41eco7xp6yb5u55ym4gid
X-HE-Tag: 1771521005-998646
X-HE-Meta: U2FsdGVkX1/DUYEFGSUH0cye862iUqZp+80X5iVsLH0xzpyioHZJMnPTHIxRn4iqeoibOVzoyGla+RX4o/eWVa237bZAWCpz/9VUQ1Z5SREHPpJSPcrp7mJXhiMP9kRtnuivOIFoFUeo7ezG/U6aJH1fWy6FaEsw7YCdbJPCqH9E/NZT9F7TYGdADv+lcbb6UJn2d6/LNyk61HogwYpIglQP6DOHJhLx2bBj68PllZGfctwfnoqo6M95evThqDnI1qs9jouxRBMwDpgFbobRUsL8RBbqaW3qoQFIhFKnGSU+njBiV/6dCP1AMTvjDTsAupnScUvZZWbI4jb7jjGDMIYmr14W/lgPzqby529r6+HnDMi/w/h1/kTL+/JkUtGc785Msanom8tIJhNJgnlc8esa3VomCh0+Y2KMGVIFArrHuS9XlYt9eWFDgfVNcaZo04KEzPI4JHUKC4C4SjeSLgu8LzryjMbo3g0jAA3ibUAacK4CRfg3AEuQj/rZocRWSWt2w/g3JBXv5YWeKLiWFpUxUkfn0mZee+hxjMycPsTkAGA4VPNYTngnMSxCkcvNjYNMXG6czbQdvU3yPWpYt2vsc1ZYjrjOqLK6ZyqwWWU0sya7CTOoBw0M4iS1ZkkdHT13RQlsxZB+O/gNaIXQ3JWFIh/9NkQ/EqDgKtoWLyXr5kmAaq0X/9ruIULScisR5GLf80dHZHT0CfSXlu92N2EX+DoMuBC+1a+2QEd4/ss8tz0ZNfK9C+Xpc8N2sBQ/FSSnBxOEqbSN3yGfOY/Se8311W/cDRc9Q2yJUriYNzECMG+jhsdgp2GVrAY3ZYk22XUM3N6NSStWQBKeEShVQfDYsltWSzgDiEBCEpES7cVhznxmbw70oF4UVMf1JHcEZrqP8lXsl1JHMHV2dzAQyf2Xf2pcb9AxoTE8X8UqF2zxqSUgdlNJHKEuCi7aFxbMWnqZFrsb/qfA/7U1HUP
 HZl+pTkz
 TKeIT9bx3lavRoCmSI2yg9TLiCaxdGlkvII/cBTJV7S+SgeQHZc/wZK0F1+mkTLaIFEzmkg8Xz611gJoqN49874frBKZ9YGpZ+jynqTEHz0G/ND/fvm2R30mmjjwOPG3s5OolBDchlqIKtvFJFAt7C4sMfKfxfgzONosfXo0dXjtSeEda6gIRLv2eaVxOelb7XHu6p3lkGR9W4BVYKqu9NgzjTGowaZv1ItG6kiGI8zxN5FQ9lqFumJcmNv6wdoZlwK4YVWkBSRSuPuYyDfYGTnm6G/sngWzAHR9ZPba+RUfce1iLgU7lj98lOQLDsTZzjX12edE/PDlp2qm+x/oUwIiBGqu6GRMi2/4vOjMy1JLZDHhnHz6G1V7AewaZvha2xxUlD3q894JSDq3Adp8OmxGI0RNnFIFtVXPkmVks1uwFNs2mONSDDjf4xc+tF6TCXxDZJDhIduCWwGTHZQ0Iuitl9jBe8pih0zIY7Id3Bds5v904RcbmaeSYBN4g6qBNhVIIBy23cSGthISAWl3ljz+vEi4S3dgPr4R9CSlkNj1Zl8DfjJyHJ4JbS72ZAkxL5AdNVh7P61S2e6rU4E9VtUN9Q5AiauBk9bMO2Wh0yZMo95o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi All,

MGLRU has been introduced in the mainline for years, but we still have two LRUs
today. There are many reasons MGLRU is still not the only LRU implementation in
the kernel.

And I've been looking at a few major issues here:

1. Page flag usage: MGLRU uses many more flags (3+ more) than Active/Inactive
LRU.
2. Regressions: MGLRU might cause regression, even though in many workloads it
outperforms Active/Inactive by a lot.
3. Metrics: MGLRU makes some metrics work differently, for example: PSI,
/proc/meminfo, smap.
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

