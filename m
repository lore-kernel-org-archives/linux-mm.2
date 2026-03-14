Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F128910706E6
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532FD6B008A; Sat, 14 Mar 2026 11:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3586B008C; Sat, 14 Mar 2026 11:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFAB6B0092; Sat, 14 Mar 2026 11:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7AD6B008A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:25:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C59C51C395
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:33 +0000 (UTC)
X-FDA: 84545042946.01.DF52760
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id ED7731C000F
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ji9nwqPt;
	spf=pass (imf20.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dKGBFuBHRuN31ZFNKDqDxImcJys3tewsom9xKohaWaM=;
	b=1cwgEkdvInzI0EuLiaoyxeHpuwJ2rw4vIzdI100QUxQcA1kRFjhyiBv5QUyd6d4G8mF/ZL
	na3zJMhMAJO1UWuhGGpZM4rtYCLVaMGY5+sBOfaJ/VXgsotXJW558/YgrPuO3r5X1IhJro
	stKhKI/j4R2mqdqAefOxzXSVCH3aO1M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501932; a=rsa-sha256;
	cv=none;
	b=YYVrJZ+5z9iOSlh7knxb0SPPmzjRLsssl74G6RlSp1mn1HdDY8OexWJsj1xVBMf7MSbhF3
	CKkgFSENMxk0BfGVgRJYUVw6sBLAPvr3G7QkaHh8wkjsLKun3vLK17seUF+Qed2OE+NdhN
	EtA4TucmKo2FvG3jzOabgmZIdoPCaI8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ji9nwqPt;
	spf=pass (imf20.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.221.45 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-439aa2f8ebaso1951792f8f.2
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 08:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773501930; x=1774106730; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dKGBFuBHRuN31ZFNKDqDxImcJys3tewsom9xKohaWaM=;
        b=ji9nwqPtcFZPqtNs/ZsYYV6rBd8qv+WvfOyh8GWAqF3MAwRlz1TgRljuq+BV0Ri3z8
         3aB+Y9cH5wPhpceeHFxBCRQvfC+rZSiZe97vjRbNXbA+qgqF3iwkMW34tzBXMTkDakX+
         bAAggnC0zotYgAWJfLWja/t73dc/vDIO2aijbPklOPHzfYTpg99IgJmy7af8wsJ5EkIR
         JSDIa1m9FR0sZR4qwIaX3KZD5u3AHt4HSBdxljnRmsHrl6VZ3iml4UCZ/KD0tRiaEpmU
         U7mWmsCzOETwq2kxlrlIELvKrpZLnP7+bLZjbude7cIthyZzXC8cWg4VYCD5Z+JsIqoJ
         5Adg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773501930; x=1774106730;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dKGBFuBHRuN31ZFNKDqDxImcJys3tewsom9xKohaWaM=;
        b=YKhk8frD6VID2hS/8H5qlMqzjkjgyV9aR1oBABbQcP/awW/OCzsOQ5z3RWnwuFU34P
         AeNmhhQ7k4mUoC2Zq6LC8ZNf6ysu6ggkFjtjEU5UdIXRtvOMdMd4gZHhpOGi4wG2Gmoe
         y2+puv8ZdfpNLPZqoVI2+NxjnqQPw4yiUIFxwMi8nCdJpZGMsNGSFGrsGhnAOY67tjmq
         AJ5TXzRwkH5z5JUK9uHZHHmLFqrEn3GVk8jBLujZN7Yy4gar7+YUFF+E3gZLX9FK0l7V
         zX4Y+m5eGuqWOVIZy1XDJsyInM2riBSUPjD0O3+IIxY9BMMjCyQv/lRexqf3jckvth22
         IBRw==
X-Gm-Message-State: AOJu0YxSkGBkUfOOkRwVaZBhnYez/Dw3R776mcS9SqEfoCmxlLo+LtnC
	5tqkpgqRboStxwpGvL4OTECFeYqqwUc+bFem4Kisp9PoeXfq+EhZ3RON
X-Gm-Gg: ATEYQzzqGYBlmbZp6TC4Eq6R1/UFDv1W47qH4Mf8RWoGmlg0RhNiRHJ/f+9h18DDTT4
	PzyJSGb/jiZKn6zER4R+sWzHER0MUj44RZLBGXJThlTv4K4lxAIw/L/fJ5TBuFn5AdP/fXc12YE
	JfbW2hpmbJy/vb/HpkwVAxa8EHl3keM6UTzOEaPlTMLXakRqMn/Nut/7WdXZP+s51n360rEFdHU
	sF6TmPiNc5noIcOyeC6uRzIiLHiLCz58A9C26SGDVNN4Le4OQ//704tqzEGkGhNkO45z3vTYMCU
	JQBGs7u+rIU9jYaSW6TgJTnm6J0IgRr1/d+6AF0lmg44qQ+UooNfFHP01oyaY1zN9rVPWWpW812
	JR9svhFRs4Bx72KIVMMOgMq4TFRD+CgmQzxvqXyhVFrHr1nPCU6xgdCH6814HWpBFY+0NldKTOM
	STFPHpxV/jJmYYNRDsHQ9oFrFzLo1wLZU0fWNWeC3SCTah0oRLdYXTcc9Of2mlKYwVsS9yc8d3g
	M3/K/QcDic/9vu2Z7eBjbgaX9Fy5w==
X-Received: by 2002:a05:6000:2501:b0:439:ac8f:5da5 with SMTP id ffacd0b85a97d-43a04d7817emr13583033f8f.8.1773501930372;
        Sat, 14 Mar 2026 08:25:30 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe228986sm23705107f8f.35.2026.03.14.08.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 08:25:29 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH] Docs/mm: document Boot Memory
Date: Sat, 14 Mar 2026 16:25:27 +0100
Message-ID: <20260314152527.100295-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ED7731C000F
X-Stat-Signature: amhx8tzdgqupr3kpiuwckiqf6sa6znq9
X-Rspam-User: 
X-HE-Tag: 1773501931-437815
X-HE-Meta: U2FsdGVkX1970T/reRHwTgfnp4wLe8JEKFAaTyawGFZKSV74e/hRiCVW05KJbq7npv18Jvlj3IJb9HLRRR8wcztdQRb56i/0OtL8LM5nj9ozbhb/AVLk2pvrrM8UotdBafcT1DIE44FAB/0ZaA1Ot62ynSgfrqkuH2REDpvX5HsmeOLxmX2/Fv0Wjf+gGWLh5gwYZpyYqIRP3Jy2HNdR4bUd54x92SwPWVL+GGYqkDSG5oZrSm07N/28qIOH+Qm2xG5cbNXH9XPOykHZeVNm+yplULOb9d2nlTXRiZ1jUfKm8QH+2MDYwrftvnsEDu/AbSfTTslMxycwaz/Hb5THke9u4uPlvcgTsEf4qfKfjHpdlPA5SUKBaCfzGY/vkIiBMHGMTTZWlTKU3C7D0WHsmfXTDnxj7SzJnyNVjXzYN/SGyxfh+cjdQcU56f9qYRsVoxXFV/EPbPxCnJMDPaq6xxWLmQMlkqfyz73nwW+69G8oHuO9gMOdh5e4JM2DSoMFdYWdR9eCmExHlHI2gtauU2AlDJbB2RUZM+wZ9EUf26k17PdUyTwHFt7PUzHfPwO+VRO71jWKWQLslhyPd4coy6t96bxcmD+qMEhSSfDbwsPSUNUWzuN4EK2KXHSA5PQSYNIm0S2OBnWBLGZgkXjjsE74E2skJ2jYF6+UKbMhfM9a7gSKQC1bkmOp/lpzGyzUuUeB2rarkeZ+QTjUUlHJOY529mP7hQhOmcWC/rlIgYsdl68KmxAUqLmdwdTwN44JFPdMYW7cjJfSWIi7DNRy4vschwrehn72ABSEwMI1F6CO+oeOQKd32E0it+LgL9vLfxgJZO04jP8uLrBauaRoGk/wGBEf8zd4dJCzAgAdypVjhrf57FEok+VRbOnJlakTH9uLRfD66eOHft+GPO4wVdm7sE9b07B2dNywSfWOXaR7HSMuTarhwhx1jb5TI5Xyxiodcwnf7xyvI3JgzDB
 uzYHspjO
 AU2VLBvCWdP2Twm5p//Qhud423BhLej3K9qtfOpgNQUbHnV8FTrO2aTaKVQX42QPJ0LCHcF7Y49qgbcuactu0QlamVOHuU11cJlkjmVOufXy9lxDSTe3uAYBiEyjAVqmDRIWt94+4BU+fRFhSgk/lUjHnhqDIX5Me/xKtd2/PKduIh1c3qwNjm3pj2a7vinRsZXo93oxOnE0YE3fJEaFL4DRsTDwEG2AO6abazRFDLuy7WqaLUpuRQEiA6xYJ7WKzp0vY1SxubJSq9AcX8DpohasSjg/qK6GQ04gP9zzXxazMX9R9mqrKqMMXp9oKjxViUusrW8jZ+xUd/GXPQ3m1Tq1q2aXWL3WPtq57XWUYXuYGftmDxgEXW+GmchdbsVn1VvQfIOw9ewpUKgc5dyjUHw0yxgDYB3j5Z5ljYijM9kCdsBu98M1BYA3JBmmaPySbpCkYN7sh/hVaLO/Jdqjd0nCjX7SyNPTbpnfh5dDhNXJ11+VqrTZM1wCLXC05Pg7W3Fk0BmY3oaUyO5w6oPvjsqm/RGwVDRVsHzDLFD55LMs7BvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fill in the bootmem.rst stub created in commit 481cc97349d6
("mm,doc: Add new documentation structure") as part of
the structured memory management documentation following
Mel Gorman's book outline.

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 Documentation/mm/bootmem.rst | 139 +++++++++++++++++++++++++++++++++++
 1 file changed, 139 insertions(+)

diff --git a/Documentation/mm/bootmem.rst b/Documentation/mm/bootmem.rst
index eb2b31eedfa1..b20520f53603 100644
--- a/Documentation/mm/bootmem.rst
+++ b/Documentation/mm/bootmem.rst
@@ -3,3 +3,142 @@
 ===========
 Boot Memory
 ===========
+
+The kernel needs a memory allocator long before the page allocator is ready.
+The memblock allocator fills this role, managing physical memory from the
+earliest stages of boot until the buddy allocator takes over.  The
+implementation is in ``mm/memblock.c`` and ``mm/mm_init.c``.
+
+.. contents:: :local:
+
+Memblock
+========
+
+Memblock tracks physical memory as two arrays of regions: ``memory`` (all
+usable RAM reported by firmware) and ``reserved`` (memory already allocated
+or otherwise unavailable).  A free page is one that appears in ``memory``
+but not in ``reserved``.  These two arrays, along with global state such as
+the allocation direction and address limit, are held in a single
+``struct memblock`` instance.
+
+Each region is a ``struct memblock_region`` recording a base address, size,
+NUMA node ID, and a set of flags:
+
+- **HOTPLUG**: memory that may be physically removed at runtime.
+- **MIRROR**: memory with hardware mirroring for reliability.
+- **NOMAP**: memory that should not be directly mapped by the kernel
+  (e.g., firmware-reserved ranges that are usable but not mappable).
+- **DRIVER_MANAGED**: memory whose lifecycle is managed by a device driver.
+
+Region Management
+-----------------
+
+Firmware and architecture code populate the arrays early in boot.
+``memblock_add()`` registers a range of usable RAM.  ``memblock_reserve()``
+marks a range as taken — this is used for the kernel image itself, device
+tree blobs, initrd, and other early allocations.
+
+When regions are added, overlapping ranges are merged automatically.
+Internally, ``memblock_add_range()`` handles insertion, overlap detection,
+and merging in a single pass.  If the region array is full, it is doubled
+in size — using memblock itself to allocate the new array.
+
+``memblock_remove()`` deletes a range from the ``memory`` array (used when
+firmware reports memory that turns out to be unusable).
+``memblock_phys_free()`` removes a range from ``reserved``, making it
+available for allocation again.
+
+Allocation
+----------
+
+Memblock allocation scans the ``memory`` array for a range that does not
+overlap ``reserved``, respecting NUMA node affinity and a configurable
+address limit (``memblock.current_limit``).
+
+The search can run in two directions:
+
+- **Top-down** (default): allocates from the highest available address.
+  This keeps low memory free for devices with addressing limitations.
+- **Bottom-up**: allocates from the lowest available address.  Used on
+  some architectures during early boot to keep allocations predictable.
+
+Once a suitable range is found it is added to ``reserved``.  The main
+allocation functions are ``memblock_alloc()`` for virtual addresses and
+``memblock_phys_alloc()`` for physical addresses.  Both support NUMA-aware
+variants that prefer a specific node.
+
+Iteration
+---------
+
+Memblock provides iterator macros for walking memory ranges:
+
+- ``for_each_mem_range()`` iterates over free ranges (memory minus
+  reserved).
+- ``for_each_reserved_mem_region()`` iterates over reserved ranges.
+- ``for_each_mem_pfn_range()`` iterates by page frame number, which is
+  used heavily during page and zone initialization.
+
+These iterators handle the subtraction of reserved regions from memory
+regions internally, presenting the caller with a simple sequence of
+available ranges.
+
+Transition to the Page Allocator
+================================
+
+Once the buddy allocator is initialized, memblock releases its free pages
+via ``memblock_free_all()``.  This walks all free ranges and hands each
+page to the buddy allocator.  After this point memblock is no longer used
+for allocation and its data structures can be freed (on systems that
+support it, the memblock arrays themselves are returned to the page
+allocator via ``memblock_discard()``).
+
+Named Reservations
+------------------
+
+The ``reserve_mem`` kernel command line parameter allows firmware or boot
+loaders to reserve named memory regions that persist across kexec.  These
+are tracked separately and can be looked up by name at runtime with
+``reserve_mem_find_by_name()``.
+
+Page and Zone Initialization
+============================
+
+``mm/mm_init.c`` bridges memblock and the page allocator.  Its primary
+responsibilities are determining zone boundaries and initializing
+``struct page`` for every physical page frame.
+
+Zone Topology
+-------------
+
+The function ``free_area_init()`` is called by architecture code to set up
+nodes and zones.  It calculates zone boundaries based on architectural
+constraints (which address ranges can be used for DMA, which are always
+mapped, etc.) and kernel command line parameters:
+
+- ``kernelcore=`` sets the amount of memory that must be in non-movable
+  zones.
+- ``movablecore=`` sets the amount of memory to place in ``ZONE_MOVABLE``.
+- ``movable_node`` allows entire NUMA nodes to be treated as movable.
+- ``kernelcore=mirror`` restricts non-movable memory to mirrored regions.
+
+These parameters control the boundary between ``ZONE_MOVABLE`` and the
+other zones, which in turn affects how much memory is available for
+transparent huge pages, memory hot-remove, and CMA.
+
+Struct Page Initialization
+--------------------------
+
+Every physical page frame needs an initialized ``struct page`` before the
+page allocator can manage it.  On small systems this is done synchronously
+during boot.  On large systems with hundreds of gigabytes of RAM, this
+initialization can take a significant amount of time.
+
+With ``CONFIG_DEFERRED_STRUCT_PAGE_INIT``, only pages in the boot node's
+lower zones are initialized during early boot — enough to get the system
+running.  The remaining pages are initialized in parallel by worker threads
+(via the padata framework) before they are first needed.  This can save
+several seconds of boot time on large NUMA systems.
+
+Each page is initialized by setting its flags, reference count, and links
+to the owning node and zone.  Pages in memory holes or ``NOMAP`` regions
+are marked as reserved and are never handed to the page allocator.
-- 
2.53.0


