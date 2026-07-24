Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1E21C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADF1F6B007B; Fri, 24 Jul 2026 06:20:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A69936B0088; Fri, 24 Jul 2026 06:20:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9092A6B008A; Fri, 24 Jul 2026 06:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 519466B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:20:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF4B71C080A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:25 +0000 (UTC)
X-FDA: 85023275610.22.2DC2AE1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id BD0B680002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:20:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VDT9W77a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bn2TWpyR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VDT9W77a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bn2TWpyR;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784888424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SePwpieQyuy4I1jGDOGIB8gwV902Jt9JP/rZL79vbug=;
	b=U1GEqmoT+UNE6jOghjNuc1xuXcyAetpIiLTcEHwDk3FVwofJ2XQJ4umpxjWWMKVvh3ffYy
	N693uFG2B+ONPz7on1/Hkv8c/SD61ahLVmMcukyefqBMrcccVTZLZteRoCXpo681X9RoN9
	SEfx2aXN4te3y7k8y6LJ2Xun5BwE5ZQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VDT9W77a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bn2TWpyR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VDT9W77a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bn2TWpyR;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784888424;
	b=3AhOZgUJFRSUEnm3HQ0/14eyuZThA1Ijorc+pSKVf7KkcYqU/m/g68msVfRjqMhkZGZfzW
	SERhMypTDAbrlFu7lwZx+/wm3jEOVGlq/AUGyIo2vhRdTq/MvuOBbSWUhZIKMgo/AC5Bc2
	YqNktV4r1U42Qci+MXj4P49swjkFzuQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 5047B3E84;
	Fri, 24 Jul 2026 10:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SePwpieQyuy4I1jGDOGIB8gwV902Jt9JP/rZL79vbug=;
	b=VDT9W77aoBJtno7DnLsVeBLRgtj2LXvFKwTE0PXCYEdHHfO91QqREBPGaLCIhTGHDFNntC
	AiWg4dDHFY6+8unZqaryY3sp2ZEzsVaeyRKvQeyjkdTU3XMYZyz4UYgSLyTJ+7b3zMxUl0
	mY2USsenCuGvMW3sy4pS2u2oFzaGYYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SePwpieQyuy4I1jGDOGIB8gwV902Jt9JP/rZL79vbug=;
	b=bn2TWpyRVadTfHe1fCfM1+C+Z0Xe/9VGdfB1U9tnLWA+i0QkT9sJ6DMME1JIwKJpQvjKX1
	0vPiy8tbTwcCApAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784888422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SePwpieQyuy4I1jGDOGIB8gwV902Jt9JP/rZL79vbug=;
	b=VDT9W77aoBJtno7DnLsVeBLRgtj2LXvFKwTE0PXCYEdHHfO91QqREBPGaLCIhTGHDFNntC
	AiWg4dDHFY6+8unZqaryY3sp2ZEzsVaeyRKvQeyjkdTU3XMYZyz4UYgSLyTJ+7b3zMxUl0
	mY2USsenCuGvMW3sy4pS2u2oFzaGYYc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784888422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=SePwpieQyuy4I1jGDOGIB8gwV902Jt9JP/rZL79vbug=;
	b=bn2TWpyRVadTfHe1fCfM1+C+Z0Xe/9VGdfB1U9tnLWA+i0QkT9sJ6DMME1JIwKJpQvjKX1
	0vPiy8tbTwcCApAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0C0E0779BA;
	Fri, 24 Jul 2026 10:20:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AJmVOWM8Y2oSaQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 24 Jul 2026 10:20:19 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 0/5] mm: add basic PTE const type-safety
Date: Fri, 24 Jul 2026 11:20:12 +0100
Message-ID: <20260724102017.141532-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BD0B680002
X-Rspam-User: 
X-Stat-Signature: yekj9j9s19wzt39suj15qm5w8u7rpdap
X-HE-Tag: 1784888423-67809
X-HE-Meta: U2FsdGVkX19LfgiedP10ME996D8HWsviQ6KWdYzeN74pfCMaK7cm8R19/7+b2wuhVv3ozj8Gh95+W16DkMG5OzKkNMJBrVgFQOfTfoMnvLAPF0T80St+TvjJ3DPdZcD07X6lHatYMinsr4DMMrBUK9etuQeZHWjf7OczUyYDuJYDvQ1H/h9v0zQi1uDmd26PR/NDWeXrMK36Nx2XWi5aIlfHbaxgUwcNKI1XKrUhaosSmTtb2meWdCfUG7tnFEN77ngeVT618qUFJ40QaXXKUASO1A5diCTy2cN6/gLtwGWw44BdqiAkFAOasxTrOy2dChHGLuKv/pa15a03X3OUJo3nGlXtb+s7DactA2U3pGgoQD6dgeXRUP9ZrkNmev5pqbyOBZ2UtFZUSo8qW7Of1+hWOEKvCMug9U7NAVCfpSsBQkiFZ3NRO9ltlF8/+fXlZo4Qae4AQkMgEBPi5s+9MvckE6YdEqub11spJUHggBaTnNSCgSzKCRijwxQq2uC90spf6JpdtIqMEVPtoziqR+tNN+D/zQ5xiPz3zy09MGIWrX1902WgWyUXVoJbwIeMTHCLbQ318W2CoKh9/5i6jLnH7lJ1Co1iFm3sM5PkGiPUHySu9w0FV7htw7U/ADveOa9dHkwJQfbBctPolN4ox3kr6rdIY+9LoP1nITYZiSieritRr3WpBzK5f4a8wNwmVQGt6eHw7y5fucfF621te0qIeXy0xXNM3RsBOLRRzJJhtHnVuNo9UJaNXtgYXVXkyAK3NRj+Qb4Ymclop3J8dA3uWQkCmRjpImV3MZtfvw5q7774Wk9LoGSqLubEcEt/Q9jngdQYNi8+V00UmGbnf2NGo4r4T+d2YU9rLSb/MccV8SADiv0S5X+ntprzfb/qZCCDjlH5lM+l5M3JSxGBFNnvIkOoMCX3GJ0eHirmaGvHGrSjD+VA5DIQ4lH9EBWUJ4zig1Rzd2QblY1gA2Q
 D5l/CDpt
 Hrqz5Y1XKHLWVV5g9PQ0fpyV6y4/6X87OT8j3esMVxfZxktXH+83wNxoEKVoJIIAlU2xRSXv/ra/ArA4spryvw0LbQ2sG2mhmloMPOcYuGMwJ+PlIfUmLD/9X+nHdhtt4jilctD5KMxSStGW+/BkQhscQzMtYm5QOk4iPEklh2DreqYYH+GnFBjY04LbY9b/H3g184FhWoZ0MZyGDbeyE7HG32RPnFTSTz12GOgLhPK7a5T3/sZUB6SJfh6hXV+pn0TF02t1tmMrIswZblZxxRQPUI2zFaVRPctbByQtHZfl/X9/T4bwqai2pQ0ZaCibJ21e1RJptcmpo46RC4bSngyz+fjlMAPgM0CUWUtKm29Q2gjkcImNQX9bHigCVhPkqf3K94ouyDLoGzFYocH6MUsMb7Xl3l6WPRcxvu+xlLoZdGqOtzdtYwI6IjMYdk/mVHRVNo6Q2Bj0ZPQXv6IoqxZx3FI/1LHFiKmPrJmZesEMMgwZ9Rp7fnv7UxsT7azjylGp1f0hiM30M/RkEzxihzjbdBsTNc+kwmjyv9M7/5LsV7wN8LxlbbWL73YPsh58O6dZ1xKXbxyLPWc8QfwIMGnQZE3ttwkk1CnzmrkwPTLueOl/LxO+mbPahXlx4rZ+IrbkEi7FYuMplmS2jnoVMKH0Nqy6P99jrVRNkQ1am4lHC2iCdcK1+Hjvq3beCwjnxzLgyYZiFsIA8eUEL9AauedERbuxTRJOXRSViduLL3wHf708jZ+MnlVIXKjHoMGeKEo5C54MT3obQVp+EMKYpIPk91Mw8F/kPD5VI5i3yMi3NnVQ82McIiUtzEQbg/S4qnoUxl9rzFlNdNog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since forever, MM code has thrown pte_t * around with no concern for const
safety, or typesafety of any kind. This is confusing. Attempt to address it
by:
1) Making sure pte_get*() helpers can cope with const pte_t * arguments
2) Constifying the pte_offset_map_ro_nolock() return type, which by definition
already pledges that users will not write to it.

These two simple steps were already able to uncover code smell from
khugepaged + do_swap_page().

Separate steps could include introducing pte_offset_map_ro_lock() for more
widespread usage of this.

Benefits of this include less confusion and better type-safety. It could also
futurely aid in efforts such as [0] which may want semantic annotation of these
accesses.

Based on mm-unstable and compile-tested on a handful of architectures.

No functional changes intended.

[CC list editorially trimmed for brevity reasons; apologies if you're not on it]

Link: https://lore.kernel.org/linux-mm/20260526-kpkeys-v8-0-eaaacdacc67c@arm.com/#t [0]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-parisc@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org

Pedro Falcato (5):
  mm: constify generic pte_get*()
  mm/arm64: constify pte_get*() and contpte get logic
  mm/parisc: constify ptep_get() argument
  mm/powerpc/8xx: constify ptep_get() argument
  mm: constify the pte_offset_map_ro_nolock() return value

 arch/arm64/include/asm/pgtable.h             | 10 +++++-----
 arch/arm64/mm/contpte.c                      |  4 ++--
 arch/parisc/include/asm/pgtable.h            |  2 +-
 arch/powerpc/include/asm/nohash/32/pte-8xx.h |  2 +-
 arch/powerpc/mm/pgtable.c                    |  2 +-
 include/linux/mm.h                           |  4 ++--
 include/linux/pgtable.h                      |  8 ++++----
 mm/filemap.c                                 |  2 +-
 mm/khugepaged.c                              |  2 +-
 mm/pgtable-generic.c                         |  4 ++--
 10 files changed, 20 insertions(+), 20 deletions(-)

-- 
2.55.0


