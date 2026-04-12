Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62614E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 17:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898E26B0093; Sun, 12 Apr 2026 13:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A5E6B0095; Sun, 12 Apr 2026 13:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738876B0098; Sun, 12 Apr 2026 13:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6183A6B0093
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 13:43:05 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 100C0160A06
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:05 +0000 (UTC)
X-FDA: 84650624730.07.3986D30
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id DDD6E160003
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:43:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MfAxFacC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qFcephQM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MfAxFacC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qFcephQM;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776015783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j1Pyf/mINB3oNud+B/5lyHbf7GLWtERFciMG2d7vOUk=;
	b=a/WxPFOGhbk6gT6yq/1nKD4W8xz8etjLKXNqAIeB3elQECLUIf5PsgyOuatxnA9F+kk6hn
	S0i0McHwZ00TgBJKrUOPw7ZVHETDphfcc+tG09ZtG1+ONbYFn4hDNHCeDGcXpLmhaa774S
	SQ5mFWynMmyNfXK9SW8HrGX4n9W/6JQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MfAxFacC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qFcephQM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=MfAxFacC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qFcephQM;
	spf=pass (imf08.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776015783; a=rsa-sha256;
	cv=none;
	b=zqEMw7Vx6y7ZV40c7v/mwjFDi0vKGj/otZWyynFhDRq7t9oXhjvtni8smOf+zHp6IfoY2K
	f/OWBcaSs+JHVx+iAbKhI2V+4hIHNJ2V8WdG0Tu7XIrP/bd2gNPyKBF5kfJwTQ1kRdhMz6
	XOYqQivl+TKlX2kxdA0D0cP5VNheEio=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0BB195BD7A;
	Sun, 12 Apr 2026 17:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=j1Pyf/mINB3oNud+B/5lyHbf7GLWtERFciMG2d7vOUk=;
	b=MfAxFacC9cM450UKgCkudBXTRMBvDvYDVk1IZyDaofT5MvpMhAqL+boP/Xs+x89ZehIzNF
	eNQgLc8puFB3q6TFGH7vwZ9TDMUOr6tH1h1GdtuaDCk6yTu3ZCBWan+myFlqAbr6er+yNT
	3KqsJkbZ/Sp7/CeH+w98gyHww8i6xhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=j1Pyf/mINB3oNud+B/5lyHbf7GLWtERFciMG2d7vOUk=;
	b=qFcephQMH1WvLC2JQ72QVfjIg+r9R7GWNkpxESAQDyU+9E+HlPhNRGGTjZNap3k1Qj20Qg
	+6EA0clXcg/eblDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776015781; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=j1Pyf/mINB3oNud+B/5lyHbf7GLWtERFciMG2d7vOUk=;
	b=MfAxFacC9cM450UKgCkudBXTRMBvDvYDVk1IZyDaofT5MvpMhAqL+boP/Xs+x89ZehIzNF
	eNQgLc8puFB3q6TFGH7vwZ9TDMUOr6tH1h1GdtuaDCk6yTu3ZCBWan+myFlqAbr6er+yNT
	3KqsJkbZ/Sp7/CeH+w98gyHww8i6xhY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776015781;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=j1Pyf/mINB3oNud+B/5lyHbf7GLWtERFciMG2d7vOUk=;
	b=qFcephQMH1WvLC2JQ72QVfjIg+r9R7GWNkpxESAQDyU+9E+HlPhNRGGTjZNap3k1Qj20Qg
	+6EA0clXcg/eblDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DF474AA48;
	Sun, 12 Apr 2026 17:43:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YzavG6TZ22miRQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sun, 12 Apr 2026 17:43:00 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [RFC PATCH 0/7] Implement a new generic pagewalk API
Date: Sun, 12 Apr 2026 19:42:37 +0200
Message-ID: <20260412174244.133715-1-osalvador@suse.de>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: DDD6E160003
X-Stat-Signature: ef4c373tbt4nico7u6e9typxp4rjahya
X-Rspamd-Server: rspam06
X-HE-Tag: 1776015782-876357
X-HE-Meta: U2FsdGVkX1+eJMu6l3adSMGJnM3+7CrQyuGkAiv83Cs7hCHTod/knjzotgpZ+6xm3S82/6LiCOPvGxNfOYRKyjgS+R9NWYoiVwh7zTt4VhQ8qCbKXqhq3ylFJ+egh8/OE6Gt3/ZmSOiuRp1O42lMokaQ69oYt/1Gjm7dkxfVUiUQmb0hPxM6a9JN6lRbsodGeeom4UHN7OH6lg9MLLb4faXz6vrCxD5dsZfFq8AZJElPWGXMGG7B69VD1BJyngvN0/uYM0Km9pKSoiPC1EyFP+L5ClAhaxK9OrwJ2t2Ir3kZR1ywGf11r9Xab6j1TeBml+OUY0HZ6qdCho03Hjk9u0FXoOoeif5WP2Aq2WRtFHglhAh3KXcwlUdC2TkqOv/JxYX/S55jTVfOR5V9xVFZLht0+0RLKVIURcbdlqtLGFj3olMCumwzIVwry7pfJtseKLfnm6bdotZa5K5Npsm51MggQ5v4gLIo7Arrof8uIUTADAtHv0ZZkpDg91vBru5U2KInZiQKDhQG4i/kfTbAZop1LbKUoqZWRGG+sWTKFnWNbENUccVPogeWSUFiJlqzveLJ+XlHg4V1Ol7Fduxmm62kPWo6aZXFntwdbDnvPsbX12mZIGJ5JUSSY9XAJFCl7cZcWkD2hCqObCyV8G/YPJ5jId6V2pakNCmr6t6+4ttFeJTCaZ885yYaBnF6SS9rgN0/uCd5MLvPBv5MNrtczXhzG4CS+DhLfOak27xmuV3dT1J9frvezo52TTO3JA7lMmzYkIKmEo2CWNHfZ55HLwCFNF7LqsAKEbg/0F4fH8x6zIInHW8vx6utqugfFLFKe4YfbLOdx5DFvf7HybNzvkDqMn+IC7V2Vy08r9OrWw8dJflemDN1HMD1Hb2wzaNnniaGWDjelfLZKPtNcJyxC+AYsZKhyTU9BejRfxgjM2n9VBdGRSgS7plMsekcDgrbqBU+fonFeKRHx3G8y5p
 fQRaCe7m
 jDZTvSAsXXesRi0vqGRVGxD1iwKM5jXHqKZUsMEIJK0PJdHl6v83RFK2Y0OghIjBLXj38Xq9J9Hu/bCkMV79JAYNh6fFxatxZLCCgTujxmtdyg33bhEN5pr2mXB5mitLW9dzk3/WFrqaZJr9mnBR2rNcWq/vbhRHlHv5qMmzyFvtAeFaaCJPp381Wy0sDVSYmppH7w1vYTk/NnDqZ3g6NK+C4Z+9aGouXQ5tsRRkyi9gNXUGdoyBttlUFw+Fty9s+CS8X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[WARNING]

This is not yet fully complete, but before investing more time into it I would like
to know whether 1) this is heading into the right direction and 2) this is something
we are still interested in.

Kudos go to David, who was the person suggesting the interface and
he gave me some ideas where to begin, besides providing feedback
on early stages (in case there is something stupid don't blame him, blame me)

Also, I would like to thank Vlastimil, who helped me running this
patchset quite a few times through Claude, to catch some fixes.

But nevertheless, it still has bugs, and lacks some functionality, but I
think it is good enough as RFC to see what people think of it.

[/WARNING]

In the LSFMM/BFP 2025, there was a general agreement that we 1) would like to have
a generic pagewalk API 2) that replaces the existing one with callbacks if possible
and 3) that HugeTLB can use without the need to special case it (e.g: not having to
depend on .hugetlb_entry callbacks)., which means having a lot of duplicated
code and also having a lot of special casing just because hugetlb lore.

pt_range_walk API tries to do that and replaces the old behaviour of "in
HugeTLB world everything reads as a PTE" and starts reading HugeTLB entries
the way they really are, that means interpreting them as PMD/PUD entries and
contiguous-PMD/PTE entries.

In order to achieve that, we need some infrastructure we did not really need until
know, in order to be able to read HugeTLB pages as PUD/PMD entries.
E.g: softleaf_from_pud had to be added and some other pud_* functions.

In a few words, this API goes through an address range and returns
whatever it is in there (swap/hwpoison/migration/marker entries, folios,
pfn and device entries, or nothing).

These are the internal return types the API uses:

 PT_TYPE_NONE
 PT_TYPE_FOLIO
 PT_TYPE_MARKER
 PT_TYPE_PFN
 PT_TYPE_SWAP
 PT_TYPE_MIGRATION
 PT_TYPE_DEVICE
 PT_TYPE_HWPOISON


The API also handles locking and batching itself, so the caller
does not really need to bother with that.

In order to handle contiguous-PMD mapped hugetlb pages, folio_pmd_batch,
which is an analogous of folio_pte_batch, has been implemented.

More information about the API can be found in patch #4.

This was tested on x86_64 and arm64, but as I said, it is still
incomplete, it has bugs and it still lacks some things (e.g: pte_hole functionality,
test_walk functionality),
therefore the RFC, to gather some initial feedback before investing more
time into this.

For now, only the /proc/pid/(smaps|numa_maps|pagemap) have been replaced
to use this new API.

Thanks in advance

Oscar Salvador (7):
  mm: Add softleaf_from_pud
  mm: Add {pmd,pud}_huge_lock helper
  mm: Implement folio_pmd_batch
  mm: Implement pt_range_walk
  mm: Make /proc/pid/smaps use the new generic pagewalk API
  mm: Make /proc/pid/numa_maps use the new generic pagewalk API
  mm: Make /proc/pid/pagemap use the new generic pagewalk API

 arch/arm64/include/asm/pgtable.h             |   32 +
 arch/loongarch/include/asm/pgtable.h         |    1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h |    7 +
 arch/s390/include/asm/pgtable.h              |   38 +
 arch/x86/include/asm/pgtable.h               |   52 +
 arch/x86/include/asm/pgtable_64.h            |    2 +
 arch/x86/mm/pgtable.c                        |   18 +-
 fs/proc/task_mmu.c                           | 1369 +++++++-----------
 include/asm-generic/pgtable_uffd.h           |   15 +
 include/linux/leafops.h                      |   46 +
 include/linux/mm.h                           |    2 +
 include/linux/mm_inline.h                    |   32 +
 include/linux/pagewalk.h                     |  104 ++
 include/linux/pgtable.h                      |   97 ++
 mm/internal.h                                |   75 +-
 mm/memory.c                                  |   22 +
 mm/pagewalk.c                                |  400 +++++
 mm/pgtable-generic.c                         |   10 +
 18 files changed, 1483 insertions(+), 839 deletions(-)

-- 
2.35.3


