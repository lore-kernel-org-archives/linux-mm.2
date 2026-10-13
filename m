Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63809CC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 19:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5061D6B008C; Tue, 13 Oct 2026 15:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6A26B0092; Tue, 13 Oct 2026 15:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A60F6B0095; Tue, 13 Oct 2026 15:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD796B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:17:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E59321401DB
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:17:29 +0000 (UTC)
X-FDA: 85318561818.06.B1BE839
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id E9AD41C000B
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:17:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V07DQowR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TqiwOtq9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V07DQowR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TqiwOtq9;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791919048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=cF++8BVZVrGiDDS9hC3HiwLK+MpGEhXXJUyNn8U/+AU=;
	b=t/LnOTZtm6dukjipD7RmTWOi+O2XYNuD3ww/vMD91HhoVdn+s+KdBGCdT2Sg8qgdd+UWmE
	PZAA0wh3mV7vySZ1W9W2NaMxbuWaJs+9O5oPiDFC9dN26zvwvLFHSpREb+d+Kt7+3ptmR1
	Qy9lNQuPKk9NFnei28EwUw2iTsFjxhc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V07DQowR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TqiwOtq9;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V07DQowR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TqiwOtq9;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791919048;
	b=CqhXhKXA43L/VBBX4GESgdg1JzjoY7SxjJKxbHgt05O41Paw2cZ7FgeqqLVRWecgSkTt+6
	/nOTV4uujpgwchqrfo7E/YNouDlIOa2axDuW/6ZIhRO0nJLWWjkMLG/5/bYFFMYGWltpEK
	K7iWU0WgfYa9L1+j+iE4r5aDlZw0pWs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 698D62207D;
	Tue, 13 Oct 2026 19:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791919046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cF++8BVZVrGiDDS9hC3HiwLK+MpGEhXXJUyNn8U/+AU=;
	b=V07DQowRw5cSNIekSiThhmE+WgeWE/eDexQ8P78wEPnT0yyxHOJ2aIHZm5a10LDz6Cu57R
	+itXNcIuX0y86a7vKSMlb63GwEXhEQ+hQ4KNO3SU3tLfi0juMYgUIShzxmGemBORYMQaNN
	lEQkcnUNAle8wo5majv7PBn9YRN2VPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791919046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cF++8BVZVrGiDDS9hC3HiwLK+MpGEhXXJUyNn8U/+AU=;
	b=TqiwOtq9g9nFfVP4LdR4J1zkbQfORf8raA6WWoihrViO+0tLn2WGj85pwtVMvUiTHk86EU
	ExBbbtKO35IejyDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791919046; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cF++8BVZVrGiDDS9hC3HiwLK+MpGEhXXJUyNn8U/+AU=;
	b=V07DQowRw5cSNIekSiThhmE+WgeWE/eDexQ8P78wEPnT0yyxHOJ2aIHZm5a10LDz6Cu57R
	+itXNcIuX0y86a7vKSMlb63GwEXhEQ+hQ4KNO3SU3tLfi0juMYgUIShzxmGemBORYMQaNN
	lEQkcnUNAle8wo5majv7PBn9YRN2VPk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791919046;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cF++8BVZVrGiDDS9hC3HiwLK+MpGEhXXJUyNn8U/+AU=;
	b=TqiwOtq9g9nFfVP4LdR4J1zkbQfORf8raA6WWoihrViO+0tLn2WGj85pwtVMvUiTHk86EU
	ExBbbtKO35IejyDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 41DDA134B8;
	Tue, 13 Oct 2026 19:17:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XkRpA8WDzmpaeAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 13 Oct 2026 19:17:25 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	stable@vger.kernel.org,
	Samarth Narang <samarth.colleges@gmail.com>
Subject: [PATCH] mm/madvise: atomically clear the young bit on THP MADV_COLD
Date: Tue, 13 Oct 2026 20:17:19 +0100
Message-ID: <20261013191719.95502-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E9AD41C000B
X-Rspam-User: 
X-Stat-Signature: prboodqcwrq1fju8fpzter9w4xibokfd
X-HE-Tag: 1791919047-407101
X-HE-Meta: U2FsdGVkX1+W3KlIeDrYt9PyObcBoGMNegBuRK3DgU6t3XdGP87BUSRm68tqmmN4zLYG6wnAEOEe3NCQz03+Bdt7rjn3XrNoFVaX7piP3bA6RadNC0F1WYSKuyJIeLqXu6EYWK8GFwLl0Gfx/skwlIkIYVarHxnF22PpceUFKFqitX0mh9KmX4GsUJtmiF/2trOP/g2o4j41Z8jBmyUmSqwiDlAmRvCetIpajMqt2WjzX4wVWBDA76Xq7k3IWPK5VH36+MYay07E4PjDToDRukD2IjChPKn6qYgsEZUJd9CgTOeTz21qNUqTYXr/fXYhyvG/F5pRA4iYWkUxJ2PHvIfsS887NeqFQZRZmUKIACVeW+LCBNBv5NjupTpqENtTDBOSS1EK16fJeB+qfdh8pSPWOps+GIdKiewePIPrECyHNGdLt/D/Or/qx5f1kz68jkxjUJ7JqruhQctsnloBvjxG+Rz+8S8ZE7tqfaIZ1+I4UzbqYiA17hHoBshn4RFOg/ZMrOqlAWiGJLIIjE1E16lcMHtjJgO/Wz55dFKabfv0bWCwD+7zWnjwPGuQWwAt4KGmjMWFqe1qME6JpSvNxK6YQsao05snrVGxq7JdtW/wM4LJ2h2Z7rzI350mHlZS9impc/roTp1+3Hhs+RAdfT1m2Fy07B/kFIzR98v0c1L7Futd85MGTkMa9vFfe5oOl0E/lLGnlPQb70Fpn45MLiXwduq1FSz8zet6R6UwIS+GudyQJBOcmv/QsLpagvPNYhf1QRwNHeSmwxcMX85J7soH6AJIRPYLf+4Mzu1neLRLNShMCOBgthoZLOw28nAYrWhT3ngpPsjmLGDGn8Auw5p4nKWIWYh0S0jaMs8GDtmWgfyvG0oC/p1ujfS3KJbB0mTETWcmoe6xGCnnfDEydskDi/0nCs8BHiLFtWw6RxL8zpMBeut5ZMyUSS6jg8N42xY4KiwM9EX3XwlDVA5
 phzZaCNJ
 /Wrbjst/rM4JTbutOF2SijA/lG+kAz2rZzczuuzP4QdkWK2wHzgr7O7x6bB8fBzQZqw43hqt+TwdGlzLsNEIAbF43CMYpWOgtisNy208qVhmKzN1ti7JMCTq+auVx3wDKhtE0USP52Mgr4Ty6iiphLbjdG5ZA0ZcWnXgYeh2g80DLKha3/HZHOVsuVYSP30F/XYrBFOAfZ+yG7WMC6YD1HRT4VOUPibaYJ/WOfygmmQ7r+cwkQKlCdyFqUi1atMty/3cS7yHgxqa6Gor4VqKn06ioIq4lC33alKvMixybxtIAtjg699ce/X3jKa08cdMR6fi31R3fUZU+Fs0ZFis7cjPQUNxwtWFlIkKPa438JDlIweW3gt/2OJOgrZ3XKJ4FVc8KKF4+SqsmVDIgY1SfyeJv+Q81YAXXruxCdMrtAcx0Kis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As-is, madvise_cold_or_pageout_pte_range() discards the hardware young
bit by invalidating the PMD, doing pmd_mkold() and subsequently writing
to the pmd again. However, it does so in a racy manner, looking at a
possibly-stale snapshot. It's entirely possible that a write elsewhere
set the hardware D bit, which this logic now loses.

Fix it by using pmdp_test_and_clear_young(). This is an atomic
modification of the PMD entry, and thus safe against any possible racing
writes. As a (nice) side-effect, this elides one non-required TLB flush
in pmdp_invalidate().

This bug can interact with the swapping system in complicated ways, leading
to data loss. For instance, if a folio is marked lazyfree, but was later
read from, and then MADV_COLD'd while racing a write to that same THP,
dropping the dirty bit may lead to data loss as reclaim/MADV_PAGEOUT drops
the "clean" anon folio:

T0                                T1
================================================================
MADV_FREE(thp)			|
  folio marked lazyfree		|
read(thp)			|
  PMD marked young by hardware	|
				| MADV_COLD(thp)
write(thp)			|   if (pmd_young(pmd)) {
  PMD marked dirty by hardware	|     set(pmdp, pmd_mkold(pmd));
MADV_PAGEOUT/reclaim		|
  dirty bit may or may not be   |
  set				|
    reclaim/pageout may drop    |
    the folio			|

Fixes: 9c276cc65a58 ("mm: introduce MADV_COLD")
Cc: stable@vger.kernel.org
Reported-by: Samarth Narang <samarth.colleges@gmail.com>
Closes: https://lore.kernel.org/linux-mm/20261011132227.413217-1-samarth.colleges@gmail.com/
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/madvise.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 85ab9bc76e06..19cd3bb4d1b9 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -431,10 +431,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		}
 
 		if (!pageout && pmd_young(orig_pmd)) {
-			pmdp_invalidate(vma, addr, pmd);
-			orig_pmd = pmd_mkold(orig_pmd);
-
-			set_pmd_at(mm, addr, pmd, orig_pmd);
+			pmdp_test_and_clear_young(vma, addr, pmd);
 			tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 		}
 
-- 
2.55.0


