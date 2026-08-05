Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55CFDC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 22:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE696B007B; Wed,  5 Aug 2026 18:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF6C6B0088; Wed,  5 Aug 2026 18:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5626B008A; Wed,  5 Aug 2026 18:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD9CD6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 18:44:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3ECE31C0FCF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:44:31 +0000 (UTC)
X-FDA: 85068696342.16.2EDB943
Received: from pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.12.53.23])
	by imf23.hostedemail.com (Postfix) with ESMTP id 195FD140004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:44:28 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=BQbGGlUt;
	spf=pass (imf23.hostedemail.com: domain of "prvs=67042773c=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=67042773c=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785969869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AqdTahBef6W+qz0ca7YQRCVOTpwpbcb4mth3B7j9O40=;
	b=I2tn/2pATRfO9DVaQkxYxtbXB+8JjYkoRpqYUxULcOrzo08DONY4z/mj9kJDzBl/IOIAMK
	mzj7+kcu+zNCflBp1RkjUTgm6m68UAMioauVpKO/+1CZiqldGjXWgmRDvBYfRqnaNfRPhO
	0JoIBLl3LYyUW02vOkgTR73Tvq3TkRQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785969869;
	b=E/pSongQPNCGGXUZvnMKTJwUa99yil26/bu+T8eSWaQafWOedsPrPIuD7O8w/Qii7L9Vko
	fCz4FFOqf/XmtL1BoMorI2DdzL3BFjNGYoZOqZOPORdJC4VFO05RLFLsdKSC+8QVZZ3t/G
	UMemyT7YP8DWkdJZSSRFV7m6dDdgmNU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=BQbGGlUt;
	spf=pass (imf23.hostedemail.com: domain of "prvs=67042773c=graf@amazon.de" designates 52.12.53.23 as permitted sender) smtp.mailfrom="prvs=67042773c=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1785969869; x=1817505869;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AqdTahBef6W+qz0ca7YQRCVOTpwpbcb4mth3B7j9O40=;
  b=BQbGGlUtkQvBOl1rds2/v6cgVrgMzRTUyy0MuKtW5maWxUuAFSpW6uxq
   6ba8dSDoRaHqU8Ou9dHYP4ZMAXO1PixKs1eXF2eWhxYT4w8Nz2awJQS+9
   Qi6RoaCoEUxB0mNzJj0zH/PnpDeyFCOY63VHOf+cKBRHoUQBBprCSYX+e
   Zi+ECTZYjfi7Zwp0i9CUw+h6rH03bsVmgjhfMSohg4dF/OZpr8B3snEp5
   o3y50+WmVGeZx8y7i7GeK2vGMl8hHNpcZteXKnKYXTtDRMc5yRQ0csduM
   RblnTVPeTPAUDzTU+EEQIWvc4OyVDBGd4P1cMK4xZoSTK4BQgipDGuDwm
   w==;
X-CSE-ConnectionGUID: 1GH5ZLG8SWGFpXXvU+ZrHA==
X-CSE-MsgGUID: sNWm2TRFS42CX80lQetBSw==
X-IronPort-AV: E=Sophos;i="6.25,207,1779148800"; 
   d="scan'208";a="25093037"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-010.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 22:44:25 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:7366]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.97:2525] with esmtp (Farcaster)
 id c8a4d6dc-23bf-4635-99f3-b313ad40cc71; Wed, 5 Aug 2026 22:44:24 +0000 (UTC)
X-Farcaster-Flow-ID: c8a4d6dc-23bf-4635-99f3-b313ad40cc71
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 22:44:24 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 22:44:23 +0000
From: Alexander Graf <graf@amazon.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <nh-open-source@amazon.com>
Subject: [PATCH] mm/mm_init: fix out-of-range first_deferred_pfn
Date: Wed, 5 Aug 2026 22:44:21 +0000
Message-ID: <20260805224421.15794-1-graf@amazon.com>
X-Mailer: git-send-email 2.47.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.19.99.218]
X-ClientProxiedBy: EX19D039UWA003.ant.amazon.com (10.13.139.49) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 195FD140004
X-Rspam-User: 
X-Stat-Signature: ijjxsbiz7zb58zd9ea8omhh7oyoojrb6
X-HE-Tag: 1785969868-266639
X-HE-Meta: U2FsdGVkX1+Zf+OUlWZS1r9JL/jQvJno3ZG6dJNorKWrZjbo1NWoSo45T4vsSNFb/9Z0ObEe2POvyzqpZfY05tu4XZos/O8qsg2GaU+DCS3bMUSmrUQr+O/Hms+9MnhejyRKEt3hM261Xwh+aHBI2m52CV2H3WqL70LO/XSHmqJOjbxkFisj9oy30GFk/ea5r4ryVZxaJW0YtJwHyltB1m5LJPRAWXppxEJoTkiQMcGhQR8XISBmumIjLpXrf8VteARr31h+s0ajcy0y0xRm6GOzq2jbWb0FZASB+qze7Devpc0rfJxAdHhTVoJPVXm8/Wl1rtGJMAfGQXDL9BYPkD//qYgef5THFQCy6aXpKU6kvC/mTgDlF3MKEgh3zag29Ap27TeogJgAr07vBjZuKp5JtwmgMPnvvpDtD1IBava3SlaqXnmyrQ0TH0UJtyodXri/oxlVNYe+eqSe1UMa10CVWWTQ/38orCavdB3hZWi9QpXvdBv594hZRXZ08zjL0aL3SUyAbvWi+OVP5tOLb6CuwEbNXMrjn3Z0KDy9QNvWdQcZw9w+Zc6XvvRk0HCqw+XdF+pjmjxylYylqngnC6nG+bBHf16CQA6OYdp3NVl3q4fGwVkk9SD2Dp34Oo68mnp0KkKrDXdf0GshGx8Xw9ObL8H6tS/l7S8IvJfcNKM2KEcsyl4g9feXhbaoH4HiJEbJ5mb6uXtejBokwRRze10wpSB58VRqIcFU5D7Byp6PvRiVCqoSGtN9Wq+yIM402CIUa82DO77qK+qVDcLFS4cMYGajde1F3q5STLGUOnsW5IdSAQpaqK9D6F5E12vufzNgeGq14oaiev2tlZHAb+LR5Q92D8yq1ewmXpd25/egvoPiD04Rv9aBCinsuaglFEjKMuQBFcn7ZYblCkpXxrqkPO5XPfw8nvVTFfoDfaiYu6xim60B5uBC6ShlCEULZnT8oM4ZFkWpC9oLYyy
 RF9qS3hI
 euLlunHCSz9nAJTWFTBhqseU52FGKfoABOwfBM65UrfuqJFX/0KatzDR2r7NnW6jjUWvLIyvd3KiOoGbP/T9bGnq+X2kMnoHDn63h6TAVthxfTo88Nk7/zGIO+T7eu/YX9S8vo/z4o19Wf0HzxZ6gs2XRyaDCpheHo9zRGAWxsL1NLhGC4rI/L++YdUAyjbjdec37lv2QFMhEFsMQPZjuZe3+MkY4pUWN+0E5XB1kW/QJpUvdZaxC7XO+/vgg/V/TyllihT6Uj+kqR/jSeH48jw53olBViyqehE8tK8KKMnKxH67oGvyXkq0WKmrWxV7w8DA8GnhAS9H5qad+PkVU9o4gMqKXd10fKHNH/u+YbHEY8biTJFxwnoGHA0IOUwjB2MYTOO57wKe5ksJwBTyB6n5UHEe8RrjuR+Uqdv4xUTZff7n9hnFiC1UUhKV11PN5CdyGy/WpY/DtAsINtw+9FjEnjlhEODCNz2Pwz8eXXdWe1wvwae38nhry9Oz8PrtJfQKEtt89YaB3RdgCcH72D3VKfEHfgtRGdzNi1oGVfrBBfuYE7+F4UWtZsUpb0hxRmEVGrwTVoF2TExd6+FLkXAjgZahB6v8ZorkSCMjSYxFKcdQ+p4u3k/dKrGr92AgFuVQaC8WBjqTL00g61P1W8xsXn/eBZx5CHtrP4SHZ5lKDeFjIxrSMc2LNc9NU0Cck32vUMxVVRUIXW2eKt1gvqPVzknZtPfb5H+M2GtyrkA8a6t9392Z7YX27LSNEaFFtoY447lhic9mUBXymi3QhAYc/phqHpLqhD6mFz0XKCu70+2M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

deferred_grow_zone() initializes deferred struct pages a section at a
time until the allocation that called into it can be satisfied, and
records where to resume in pgdat->first_deferred_pfn.  Reserve most of
the top zone early (a large CMA reservation is the easy way) and a single
early allocation has to walk the whole zone instead of stopping in its
first free section.  If that zone does not end on a section boundary, the
pgdatinit kthread then dies:

  kernel BUG at mm/mm_init.c:2131!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 3 UID: 0 PID: 36 Comm: pgdatinit0 Not tainted 7.2.0-rc6 #1
  RIP: 0010:deferred_init_memmap+0x1b8/0x1c0
  RAX: 0000000000236000 R13: 0000000000238000
  Call Trace:
   kthread+0xdf/0x120
   ret_from_fork+0x187/0x250

RAX is pgdat_end_pfn(), R13 the pfn that was stored.  The loop advances
spfn in whole PAGES_PER_SECTION steps and only tests it before entering
an iteration, so once the walk reaches the end of a zone that ends
mid-section the escaping spfn is SECTION_ALIGN_UP(zone_end_pfn()).
Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in
deferred_grow_zone()") dropped the clamp that used to prevent that: epfn
came from __next_mem_pfn_range_in_zone(), since removed, which capped it
with min(zone_end_pfn(zone), epfn), so spfn could reach zone_end_pfn but
never pass it.  The assert is fatal either way, panicking under
panic_on_oops and otherwise leaving page_alloc_init_late() waiting
forever for a completion the dead kthread never reports.

Store ULONG_MAX once spfn has left the zone.  Nothing is left
uninitialized: the loop covers a single gap-free interval, and because it
only enters with spfn < zone_end_pfn() the escaping value is exactly
SECTION_ALIGN_UP(zone_end_pfn()), which is the last_pfn that
deferred_init_memmap() would have used for the same pfn range.  A zone
that does end section-aligned now takes this path too and loses its
zero-work padata job along with that node's pr_info() and the WARN_ON()
on the next zone.

To reproduce with CONFIG_DEFERRED_STRUCT_PAGE_INIT=y and CONFIG_CMA=y:

  qemu-system-x86_64 -enable-kvm -m 8032M -kernel bzImage \
      -append "nokaslr cma=4768M@0x100000000"

Top of RAM is then 0x235ffffff, so ZONE_NORMAL ends 96 MiB into its last
section, and less than a section stays free above the reservation once
the early memblock allocations are done.  The walk therefore runs off the
end of the zone and stores 0x238000.  Sweeping that free remainder from
96M to 288M in 16M steps, an unpatched kernel dies on 7 of the 13 boots
and a patched one on none.  On an 8 GiB cloud instance that reserves most
of its top zone for a memory pool, roughly one boot in three panicked
before reaching userspace.

Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Alexander Graf <graf@amazon.com>
---

Notes:
    Applies unchanged to 6.18.y, 6.19.y, 7.0.y and 7.1.y (checked against
    v6.18.39, v6.19.14, v7.0.14 and v7.1.4); the deferred_init_memmap_chunk()
    signature change in cbbbf7795fc3 sits outside the hunk context, so stable
    needs no separate backport.
    
    First seen on 6.18.y and 6.19-rc distribution kernels.  There is no public
    report to link, hence no Closes: tag.

 mm/mm_init.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 498d62c4ece3..91177be58a00 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2214,10 +2214,13 @@ bool __init deferred_grow_zone(struct zone *zone, unsigned int order)
 	}
 
 	/*
-	 * There were no pages to initialize and free which means the zone's
-	 * memory map is completely initialized.
+	 * The loop only tests spfn before entering an iteration, so on exit it
+	 * may point up to a section past the end of the zone.  When it does,
+	 * the rest of the zone has already been handed to
+	 * deferred_init_memmap_chunk() and nothing is left to initialize.
 	 */
-	pgdat->first_deferred_pfn = nr_pages ? spfn : ULONG_MAX;
+	pgdat->first_deferred_pfn =
+		spfn < zone_end_pfn(zone) ? spfn : ULONG_MAX;
 
 	pgdat_resize_unlock(pgdat, &flags);
 

base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
-- 
2.47.1


