Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFD1CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 07:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01B6F8E000A; Tue, 23 Sep 2025 03:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35328E0001; Tue, 23 Sep 2025 03:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4AED8E000A; Tue, 23 Sep 2025 03:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D17F78E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 03:10:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AB13868FD
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:10:32 +0000 (UTC)
X-FDA: 83919641904.27.815E6D1
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id 848CF14000E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 07:10:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BdkLqEXg;
	spf=pass (imf23.hostedemail.com: domain of 35UfSaAsKCAwx0wq4tsup3ms00sxq.o0yxuz69-yyw7mow.03s@flex--lokeshgidra.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=35UfSaAsKCAwx0wq4tsup3ms00sxq.o0yxuz69-yyw7mow.03s@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758611430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wR1lahi+FoqQzMw6Vp5c+UkfzyZUnSMWePgiKcSESBk=;
	b=dBAJsfMzPVfbdQpl1xA3+khZiSAJA3N0WzbMDdoU5vQD9xtWWfSzsDFA4v/sI9B6b6viH9
	6FjQ5FgMQXE7lCu175LFglcKfK3Jj/5fpyUl5qO5VNO0zcde/Bn6Em1C9yxRkCHxP5uge8
	8Jv4ksQtcRCmIuWOdy5HOlXINHR9yf0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BdkLqEXg;
	spf=pass (imf23.hostedemail.com: domain of 35UfSaAsKCAwx0wq4tsup3ms00sxq.o0yxuz69-yyw7mow.03s@flex--lokeshgidra.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=35UfSaAsKCAwx0wq4tsup3ms00sxq.o0yxuz69-yyw7mow.03s@flex--lokeshgidra.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758611430; a=rsa-sha256;
	cv=none;
	b=zTRRy9FU0YVQdYwqYfDrn0obNX3mTja3VxwF70TKP8udgX6yN3LuyYrNEtjZpBGvf2Je5z
	1Oz1gGloA+5If5R5EGvjJbun060qQGSyToGejs+osfysOHKwlwSkLfai58XwNxl1tSoDkG
	Q3sPPwQWCPmH6hUazFwZC2aNn/Y2K9A=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b54d6a67b5fso4042376a12.1
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 00:10:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758611429; x=1759216229; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wR1lahi+FoqQzMw6Vp5c+UkfzyZUnSMWePgiKcSESBk=;
        b=BdkLqEXgXJQxLRkSPBTGefvBePy0n4u3v1V+UptSh9g+ucBvP9VjWengYU4GRzLOVb
         JOEHczPx4Vn7aF3DvfkNJsI5omGMQfbSDrUyox+UxlsWnSZeGlWoddFZf61ir07OR3t5
         9qHPTYLDjqI6MTMvvx17gZBrInGh4CF+Z2FyoNiFI7gEnHCl9iFx8i1K2QcAy96iOZal
         nr6pbGHzwjYHhlW/mfCyZtHUYpo4H5PFkKsodj87FW2PGSaD/8nPjyX8KodP3wamsMFe
         SBbr1Wk2edV9AA8c8rvOJjCTyZUD4IpM0Dtt5eY/CxuLw+d1EWMY15qv6pN8y1te67KZ
         a2/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758611429; x=1759216229;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wR1lahi+FoqQzMw6Vp5c+UkfzyZUnSMWePgiKcSESBk=;
        b=ba4eDM2TnY3grbfoZypJPXLkCEumgwEj8zi0OHZmhPj34r/uEC1mM5HwSIR+AOv4b0
         Oz896RGadCDgjHwnlsdfv6a+RCIbdyH5J5NLxd2QpGin2NFGNX6nuaa6INrJ9P5SlF9R
         Kw/oPsq/umeSBpefAYpetgpPGB5yYA8g8W9qvSAbB6wgQXrm6gwp8oo/qnZ42cAB+PZn
         BSg/PxIsbhY4RXBa3ycEzCuedrKOJnWHGMkmKN8M8JyZkAb0Csc524g9sK8VB34pMACz
         0A8O097jvku2prmER/Zb1gJHGdRBDHsiW3V6kJd61Hjoa4+Wv36VYJhJZiuhHd7I9t4e
         8FAg==
X-Gm-Message-State: AOJu0YwWH5mnTRckDwH20ReO3w13tatwBV6XRiJFbSy/edVgMkhOFpeX
	mCKSZmWbnf1QjGW0tkg/v1TiOlp48fyPXd6TBZoWGmhQhuEKuOoSM63Y7jkJoDBSpn2TZWVOmNB
	p6SYnsiAICboFgpgyhOewUPAU3Q==
X-Google-Smtp-Source: AGHT+IGtw6LoXnK5PlDBdfsbPkuy7EOa/C0/hqKJmUMnhfzugONTIoIYjOdvkAFSScgM8z3D+XAVoxeMrGP61kSptg==
X-Received: from pjur4.prod.google.com ([2002:a17:90a:d404:b0:32e:b87b:6c84])
 (user=lokeshgidra job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e88b:b0:269:4759:904b with SMTP id d9443c01a7336-27cc8654a54mr24024865ad.58.1758611429259;
 Tue, 23 Sep 2025 00:10:29 -0700 (PDT)
Date: Tue, 23 Sep 2025 00:10:17 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250923071019.775806-1-lokeshgidra@google.com>
Subject: [PATCH v2 0/2] Improve UFFDIO_MOVE scalability by removing anon_vma lock
From: Lokesh Gidra <lokeshgidra@google.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, kaleshsingh@google.com, ngeoffray@google.com, 
	jannh@google.com, Lokesh Gidra <lokeshgidra@google.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 848CF14000E
X-Stat-Signature: sdpj36caz6hxz9hnkrdwyphpeprezrdu
X-HE-Tag: 1758611430-180516
X-HE-Meta: U2FsdGVkX1+xQBce2x4mIrZMUCw7eChcJHLVZVktTBJp+VzotI0BRUfHqovs9osIVx8z9pG1bnMwMafqRouGm+z+KH6VedrNgbFhm8rKaSDy1sDBxlOBPB7e2L0Pvk/DrrxGMKXCqdvCDi9bYjARMHGNQaQzBx2pdSxiN8zTyXcYPdSTeH0fkXAz263RB1A9N75GwqwEfwNqghI15x4K+spe6u01JtXADgnUhhWyEo8Q45Uy79GDq+nh2Z1huZh5Xe4aAkLMTEk57yiVxlyZ6dhzgDBxTtsNy+P8J0zGjNX0Nyu+y8ZjON9Bp7gQLwZnB6zkXm8fBx/2z0YAUQlkxLydLdenKxlIzGJP1wz89X36V4dDFaXTePDCeH6eJvM9SuxIbNe0ts+KEmOOSw4/PgieWHwaRpmTzqhT83J3EqvdvBMMy8xwbgfD6dkNg07pA4m+JlynHBmG5X/94DD7WQPGMACEDkPH94RF37KxGbMHxOURbSJElEb+xQ5MmFbTHTLJV7vJcv1mE2mgQ7P3kF7EyvnWn1aNtfogElHfVf16eIZXVZEbyzlN7yHzo1BFSkVcdV5kUSh12wxiYlZHHlYZhNI4yynA5WwBqC5wjei66t0PTFsU+JOHTN2eiigx704fqnG+6hGXHNwDy3hsqPqSh987GAVrV5qaPh9uLvlg95v/tqzGkLOxanpRcxAICNtYax6UwOVQ20k9pQUaQbqFoUCxsxF4RBD6P1BnU/5n0a4SJFOpnr5smVRjNSD6AGcQGq++m5TP2eNOjBDz4Z7IylaWNlVGW89k60Kv5sgzzq3V96ToIzTCJsDMRsnfmXg8zA8ElmajwlbQ5IQCplm0ecQ/tFVBmEEZ/j4SxUDwbToY5NKpsDH2O82I2Wa2qtupmPM7DPf488ZIRMzqqmaEQZkC59WEPeoZqd563vGJrpkztQVvDkv37MDt8a1ltSnB/HTJisP2EvXHsqd
 Kw7wa2W3
 x7qAbf9yS1zlPZ75ySnQHswZqXTHHAbYvy+kU6F9ZNItrwfqJDaib7BbnDzLewY7zSg0999XPrxO+4suM5j0tBn5Yfnh36pVI5CfalPwZ9PWm556UTUwF7ao9r3N73VVVtjYsEKx34pd5U21VxSK3bSD2AJqnPXtiHEC6B4AsZ2vaL3KhG8Nh5wKkxuBhSqsAxeamXBk4FAyyNFdwmupQ163Jr3iRbaxkEYLznElLZ90NQaBsbhCdBdkBnuwONkgsRcsumHX7nDAyuSI7p6cYADH0Nf+ifaxI2z0Uo41fqxY2ZcoaHkjpMM0KP+k5JYeHOruBG/wOb4m3ApcInlYBQrCCzbP4MvyBcXThZSwrB/n+g4fhM+YfwS8NvfGKg+aRkbL/EFsiDSMKVeL9HUPPL5I/00imWrCb/L4U49SFiDbR5AXMmbJIy/Zkr7QCLDTM10wIxi9lqwqZf90SfiZF9TT8jmJb2tecOW4aOdW8/Foa/k3tZqmbcM0+quLXHe/p8kQNEmNmoB6ktH9KVhO2YJwGsd36LigiD3fA8M8vG5lqVX62P/LQ39Hq/+/KGWS4Jq3HuUbGxzUfKQQZTNTvle0x+NhkM69mRg0krILMz/mYFckQRk0H4JVRJX2oZnsLPwwAeiw312HLlUS7xTG8CDqggLAgkLLkCZIx0KOcrG2SeG+B4jFiHz5g4za3iZU7g/W/qY5+zLb2LPZLoqKUZY+oFO26Wsw4W7c3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd has a scalability issue in its UFFDIO_MOVE ioctl, which is
heavily used in Android as its java garbage collector uses it for
concurrent heap compaction.

The issue arises because UFFDIO_MOVE updates folio->mapping to an
anon_vma with a different root, in order to move the folio from a src
VMA to dst VMA. It performs the operation with the folio locked, but
this is insufficient, because rmap_walk() can be performed on non-KSM
anonymous folios without folio lock.

This means that UFFDIO_MOVE has to acquire the anon_vma write lock
of the root anon_vma belonging to the folio it wishes to move.

This causes scalability bottleneck when multiple threads perform
UFFDIO_MOVE simultanously on distinct pages of the same src VMA. In
field traces of arm64 android devices, we have observed janky user
interactions due to long (sometimes over ~50ms) uninterruptible
sleeps on main UI thread caused by anon_vma lock contention in
UFFDIO_MOVE. This is particularly severe during the beginning of
GC's compaction phase when it is likely to have multiple threads
involved.

This patch resolves the issue by removing the exception in rmap_walk()
for non-KSM anon folios by ensuring that all folios are locked during
rmap walk. This is less problematic than it might seem, as the only
major caller which utilises this mode is shrink_active_list(), which is
covered in detail in the first patch of this series.

As a result of changing our approach to locking, we can remove all
the code that took steps to acquire an anon_vma write lock instead
of a folio lock. This results in a significant simplification and
scalability improvement of the code (currently only in UFFDIO_MOVE).
Furthermore, as a side-effect, folio_lock_anon_vma_read() gets simpler
as we don't need to worry that folio->mapping may have changed under us.

Prior discussions on this can be found at [1, 2].

Changes since v1 [3]:
1. Move relevant parts of cover letter description to first patch, per
David Hildenbrand.
2. Enumerate all callers of rmap_walk(), folio_lock_anon_vma_read(), and
folio_get_anon_vma(), per Lorenzo Stoakes.
3. Make other corrections/improvements to commit message, per Lorenzo
Stoakes.

[1] https://lore.kernel.org/all/CA+EESO4Z6wtX7ZMdDHQRe5jAAS_bQ-POq5+4aDx5jh2DvY6UHg@mail.gmail.com/
[2] https://lore.kernel.org/all/20250908044950.311548-1-lokeshgidra@google.com/
[3] https://lore.kernel.org/all/20250918055135.2881413-1-lokeshgidra@google.com/

Lokesh Gidra (2):
  mm: always call rmap_walk() on locked folios
  mm/userfaultfd: don't lock anon_vma when performing UFFDIO_MOVE

CC: David Hildenbrand <david@redhat.com>
CC: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Harry Yoo <harry.yoo@oracle.com>
CC: Peter Xu <peterx@redhat.com>
CC: Suren Baghdasaryan <surenb@google.com>
CC: Barry Song <baohua@kernel.org>
CC: SeongJae Park <sj@kernel.org>
---
 mm/damon/ops-common.c | 16 +++--------
 mm/huge_memory.c      | 22 +--------------
 mm/memory-failure.c   |  3 +++
 mm/page_idle.c        |  8 ++----
 mm/rmap.c             | 42 +++++++++--------------------
 mm/userfaultfd.c      | 62 ++++++++-----------------------------------
 6 files changed, 33 insertions(+), 120 deletions(-)

-- 
2.51.0.534.gc79095c0ca-goog


