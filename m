Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF2DCD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:35:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22D26B008A; Tue,  9 Jun 2026 07:35:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D34C6B008C; Tue,  9 Jun 2026 07:35:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C26B6B0092; Tue,  9 Jun 2026 07:35:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B7416B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:35:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1069640559
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:35:57 +0000 (UTC)
X-FDA: 84860169954.01.483BCC2
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 38750C000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:35:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zgn0KlFF;
	spf=pass (imf10.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781004955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tTVbdNvFsHy/4J7oFF22y14P3b+5jff+s5QxYuRgUYw=;
	b=7Er8pWjODJSYG6MWq+IFEXuZJoXdDaAxOlD9Bwr8IIm9ha/PBX57x1sxjlXCN2SjPH3uLU
	cvNTE1BSn0u7UY1RRCXe38eKTzu+JotdFlaK+fgUbBA3H9KLMG5d8Q1rcYQ0pZpNO376td
	SYb8QvwpfNE6k4sBeeBRHexLARb5l7M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zgn0KlFF;
	spf=pass (imf10.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781004955;
	b=wxWyJ3SSnqS8sCnT9OK0/3y7ivxalkhNDGRCQO8NYsfhvWKu16QrARTT/rZnXc2pVxLh4A
	iHLZMpzwHDsIMDL2Scxn7S/rVD8X1pWr4mEOfj9XMiNsjQnK9vodPIg74E7qq/EL7oKnM+
	xVZU2fI0g7O7sCZ06mKfxG3hjXybhkw=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-36d630c0e35so5719356a91.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 04:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781004954; x=1781609754; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tTVbdNvFsHy/4J7oFF22y14P3b+5jff+s5QxYuRgUYw=;
        b=Zgn0KlFFNenCqR8MbVnsEiM9iefBz+SxqTylgjB1gczMhh3/3gV47fd/9n+32/rPzv
         L9dtQsbQvscjcxjTFKfSXgv/FIux6gnq7iBPChjNbdHwBl1vccdZwJN5d9/CwtGV+DUH
         kKD+o+XySv0bgqcszo2VkiHykpc+RVvPsl2GI386rRUVP4tbSNeJ1XoREluW1M7tyUo4
         bdmIrNRAwJVtu2zvXvB1xxhKnemR0iqJfz65GQkAm6zGMwY6vLrST7Y+s5o5nU91yK90
         eIEKDLunwYeIhr9tPAlT14y+S4q2urKTGDnmDi8qB0MJqd+h81A1OKXrYuQ8LTQl25cf
         mG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781004954; x=1781609754;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tTVbdNvFsHy/4J7oFF22y14P3b+5jff+s5QxYuRgUYw=;
        b=AjUH63enWMoBdqKFovFLmeXkJ6GXONRhpV0SNW5+dICjlDRR6Mo6Knp6aiPWzqSKp/
         TiVEH5mMIpGQj0jMrnJ2uexOV+cQuJ43eObFcOTGkLflYXrLOmizgA401PwLmBAwNhq5
         EX8DByW8r5MCqnK+b7vogDuDEKCXUUDuwirMd7q7hidoxHgh4XHr/UDU4ab5BNvwNzOc
         UFMIellKIPsN400tu3rC6XmPAo1n3p8QVRm7fZW8NYNoHQ4i32arAEx+YKDfkpXXiFR7
         b52lQiFpS+ZekXbOli9hC/eybxGOHUcLv2jO6kehWO9blVKVENY76kIVs62O6SEhLgnk
         Zh1g==
X-Forwarded-Encrypted: i=1; AFNElJ96CjjPykItYX+Mcsw7yiGTaQIXiTDmGV9W1C0qDJBoRiyjNe5y8WhE0YcW1Wyf38jYm3w3QFmfvw==@kvack.org
X-Gm-Message-State: AOJu0YyIBc2IbiaXodTm4bq3Mlsgpzy96cH1sJz7SDQkC4KOeWtjduKa
	MhL3MVNPlZNjSp2HraWlOc3cSnOjwfVjAo9LAYHas69p5Efu8Z4H3wZM7Lmf0Q==
X-Gm-Gg: Acq92OFiun9Z9CdzkkT7B/P3f3KG+y4XACf7oY//f/Trr+9vIl+KpjlLmSSIQ0o+CEw
	2TdUSY2rurOqsjzS+/pFdYDRBqNhC9liZqqZYlhJZOpqyL7sIXGeEAsESDV837a86RaTMYijLmv
	aVEBL/5zscRuQGwq+YPfvTBtFDcgOstow3C5mW1b4Hc82b8wOcVEJLAkstf3vB/Tis0769QUg/u
	DcB3dCqV/bSdVAR8747niyWMSdoQhlJNdJNyFyTpxK2iF850F/txZSR/+jGRAsD5hmo+bPGU7gK
	jZ1PlT1mXUv2Xg3fwz8ewasrSs0Eqw33GpIFcoLUDl4V8XVXHFFxRR0T1chfB9e5udQZjMyDfrI
	FakfxKSccKjNAG5CPAPoxa20CY1h7QDV+XDTZ8vkeEPVFyLhZScj9LRCv3tXDySBSzx5+Mu+9UD
	6sfPXIsr6vhogXk2aeUhSe31fSgLn5iuO/2KMxxS0o0DSfJH3AqQ==
X-Received: by 2002:a17:90b:5345:b0:35c:30a8:330 with SMTP id 98e67ed59e1d1-370ebff342fmr20517545a91.0.1781004954013;
        Tue, 09 Jun 2026 04:35:54 -0700 (PDT)
Received: from ubuntu22.mioffice.cn ([43.224.245.232])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6c668e98sm19655292a91.5.2026.06.09.04.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 04:35:52 -0700 (PDT)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Barry Song <baohua@kernel.org>,
	Wenchao Hao <haowenchao@xiaomi.com>
Subject: [PATCH v4 0/4] mm/zsmalloc: reduce lock contention in zs_free()
Date: Tue,  9 Jun 2026 19:35:16 +0800
Message-Id: <20260609113520.3507783-1-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 38750C000A
X-Stat-Signature: i8j5jipppqartwqmq9prh1u48yakbf7i
X-Rspam-User: 
X-HE-Tag: 1781004954-423336
X-HE-Meta: U2FsdGVkX190RcoPatPtn4nW7pBLUv2552AB/rbH0hjSqwrmlrrm5ZqdRJiyxwIh4Mt1ITal/16ITvMb+jt0f06XSP26Y3mPr737FxtgYl9fWB+cPWoBZjCSE7g/tSrtZjjHoTsNHg6tUY33rR0wAV9jjAM7+6pzy1D/yCJa4DQ9JfiV0oSbQa9hnB+n5eIP555cJgo5UzD0tEOzK0D38pjmgeyt7JNpII7AZOG/zD7TudclMjALXzgWx5RdyMTm70R+YNFGCvjRJG3DaXTCPPLmAPaKSJh9UJDhcwcN2DBw8U3Kug5XcQKKbCP+x7ZVqKQy010jz+XfuEMjC+tm71U2VF4YYaTPA1t5aHd8iT2M7YhwZmwhYVjbPKNotxnlQ4Z/6r/UuOr9zBGG39oEiqfRYc6dr1Vwy5Z/DSJ3zs7izAoP9+Ft8bxP73q4fTap0xfVsm2xwuBGtw04H1pZPQjTELLHHk9MPhxztOU5x8FtOPAGuTbJQjcMaPDqyx1gs22KfXm/y0YCuxb7ziiXwe65D0jxAEaXe7iq2BZPmqEQX+vW8kZsY9MHCqX8ciQKFU0miIZe2ubh9dCE3/QTRZIKYnaD7/EhlapQJfk15UU1SPcyoRbJrnoUUp2hY/73HWhzR7WqF8OwmhJQ+TBzQONtPbeQ7EwttKMJ2eViBIDD3o8+aqQpLz4jF96JjyWMg8Q9aaIUA38ub9wDfp7Zx8C6k1UtgtUfr6P/RKP0gZnDZscx2X8gHeJwZpjAW2cmJ87bg9WdHIZLbI+0AIjICL5AOdg0U+nuZaHaRw1lzauS1jRm8jq5f8j8DSSEj5mJoN51XAUs1Rg06vOlSuhO5MmK5bmDJ4HzZYaycSU0OiqymHEB99cCMBzg5PiNoRKPE5oQ7ICZZfjdb7zLEMvT1s+U2xiZMy4hrwAKuhiih+/IR6HkwSpQEkL48qplZFineayu5dvjDPoW/e8Zk54
 vOMWRN29
 sIXUJLRAWIwL4ck6XLY1G4X7QcnQBQsGSrKzSuwi9tBfPoumOLD8BPLmUWtC28HO+ceg+uP8SAh3MmdDhsrNHz7I3RdZSsHGZFTMemZFfFBnW6V/AbUS+EpXE5XTD7dU+1hD8XJD1k5/yk7QTqAQStNrk3njClMfICJOPiG1z4to5QYvPPClG7VAIIURSLeVD9DjYnJPhNoQKvkvBx1/Zzj9NbUTVedo7KnMYgQQp0fSsajYrXYX6+yM93fycbFfEF/WZZgPZ9qZY+vEUCAPSbacGo24rM5zBzZ9USVhUAqdw6atmXrXZuObvqRBJH+eE9QMJ+6evFxgv3hq4FZrya/hSz++ipTLqsV9Q8G4Gqg3CtEF+LWzdp8LlN8p8IC3tXanONF8sP4Pyroe6HiKQTaX2fxIiDtetrjlB70P9Z7vMF5VYGiWD9Pfq9FjjIPfHfUHuIC/goAPO/Hp8miA5l5mdtiM+9o4oUdPhYlSrF3+aJ2RtaVLYdLjqE6tZWiUQJnD8Th41ZpnoNJ5iV0JV2oHG6b2MyqGEkLYS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wenchao Hao <haowenchao@xiaomi.com>

This series reduces lock contention in zs_free(), which dominates the
unmap path under memory pressure on Android (LMK kills) and on x86
servers running zswap-heavy workloads.

The current zs_free() takes pool->lock (rwlock, read side) just to
look up the size_class for a handle, then takes class->lock and holds
it across __free_zspage() which can call into the buddy allocator and
acquire zone->lock.  Two costs follow:

  * pool->lock reader-counter cacheline bouncing among concurrent
    zs_free() callers.
  * class->lock held across folio_put(), so any zone->lock wait
    fans out to every other zs_free() on the same class.

The series tackles both:

  Patch 1: encode size_class index into obj alongside PFN and obj_idx,
           so zs_free() can locate the class without pool->lock.
  Patch 2: drop pool->lock from zs_free() on 64-bit; 32-bit unchanged.
  Patch 3: move zspage page-freeing out of class->lock.
  Patch 4: document the three free_zspage helper variants that result
           from the split in patch 3.

Performance results:

Test: each process independently mmap 256MB, write data, madvise
MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.

Raspberry Pi 4B (4-core ARM64 Cortex-A72):

  mode        Base       Patched     Speedup
  single      59.0ms     56.0ms      1.05x
  multi 2p    94.6ms     66.7ms      1.42x
  multi 4p    202.9ms    110.6ms     1.83x

x86 (20-core Intel i7-12700, 16 concurrent processes):

  mode        Base       Patched     Speedup
  single      11.7ms     9.8ms       1.19x
  multi 2p    24.1ms     17.2ms      1.40x
  multi 4p    63.0ms     45.3ms      1.39x

[1] https://lore.kernel.org/linux-mm/20260508061910.3882831-1-haowenchao@xiaomi.com/
[2] https://lore.kernel.org/linux-mm/20260527115930.3138213-1-haowenchao@xiaomi.com/
[3] https://lore.kernel.org/linux-mm/20260605084242.1549811-1-haowenchao22@gmail.com/
[4] https://lore.kernel.org/linux-mm/20260605084242.1549811-1-haowenchao22@gmail.com/

Changes since v3:
- 1/4: gate ZS_OBJ_CLASS_BITS on a new spare-bit check so unsuitable
  configs (e.g. UML, no sparsemem) fall back to plain obj layout
  instead of breaking the build.  (sashiko AI review)
- 2/4: annotate handle_to_obj()/record_obj() with READ_ONCE/WRITE_ONCE
  to silence KCSAN; sync the #if predicate with patch 1.  (sashiko AI review)
- 4/4: clarify when async_free_zspage() runs; pick up Reviewed-by.  (Nhat Pham)
- Drop Reviewed-by from Nhat Pham on 1/4 and 2/4: substantial logic
  changes since v3, please re-review.

Changes since v2:
- 3/4: drop likely() hint and tidy up else-branch braces, per review
  nits from Nhat Pham and Joshua Hahn.
- 4/4 (new): document free_zspage helper variants in a single comment
  block, per Nhat Pham.
- Pick up Reviewed-by tags from Nhat Pham (1/4, 2/4, 3/4) and
  Joshua Hahn (3/4).
- Fix patch 1/4 and 2/4 From: to match Signed-off-by, per Barry Song.

Changes since v1:
- Rename obj-encoding macros for clarity.
- Make 32-bit / 64-bit handling transparent at call sites
  (no #ifdef in callers).
- Extract a helper to keep zs_free() unified.

Wenchao Hao (3):
  mm/zsmalloc: encode class index in obj value for lockless class lookup
  mm/zsmalloc: drop pool->lock from zs_free on 64-bit systems
  mm/zsmalloc: document free_zspage helper variants

Xueyuan Chen (1):
  mm/zsmalloc: drop class lock before freeing zspage

 mm/zsmalloc.c | 219 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 184 insertions(+), 35 deletions(-)

-- 
2.34.1


