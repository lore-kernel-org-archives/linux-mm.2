Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0478109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49AA76B0567; Thu, 19 Mar 2026 14:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471AB6B057A; Thu, 19 Mar 2026 14:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3612F6B057B; Thu, 19 Mar 2026 14:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 271506B0567
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:31:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EEA548C20A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:20 +0000 (UTC)
X-FDA: 84563655120.18.15ADEF2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id CCBBC1C0018
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GullVxnV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=srw0mnD8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GullVxnV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=srw0mnD8;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hSx7bv8Io0WvEooYauGgMzHaSt+I4iTfFMNYxZKKaAs=;
	b=c/s2IXAi9pU0BmluQo2xRdTH1lrnlDESH0rzMdoCBb8DvQzQ3lsKe7uadQSQwBvPnUm3Xf
	5eh39yZJGyq3bEgtjHk0izzit2ULN0CGWxDmLsg2cDhJzzahY+Yzk2YRLAlk2AJGBidIp6
	sCtCkSxqRyjzxToTpgnDm/gA3/EGmrM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GullVxnV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=srw0mnD8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GullVxnV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=srw0mnD8;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773945079; a=rsa-sha256;
	cv=none;
	b=FVW9X2/J4oXD2i2wW8G5iEHn5yYlXXXDSuXd7GF/j4kQe7qsDLqqlTgT/fr40wumYMeLrM
	EJQQgV1SzHOn6EoqrI1f0vRT0XK5O/4j7mz0Qenpahu+TO/wzOVJIagXCdsP+E2iJiIZ1Y
	dmrm9fxLy1pwYpNpLsKzUE7hisczipg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 142B65BD82;
	Thu, 19 Mar 2026 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hSx7bv8Io0WvEooYauGgMzHaSt+I4iTfFMNYxZKKaAs=;
	b=GullVxnV+wSv0PobuV32Br6lLkFgYky1BkSkpNxpSDpMcaRFswSRHSH1+uUP9fYzDgTi69
	EokZgtF3bB6cH6fYTSST/hwlOPS/rMI3wx3my42gWYcRRvSwIcxxcKMmg+U/QJ/+JkowPE
	dXYI7lKS8eBxUOEBZ8Zz1JVgQDxnC9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hSx7bv8Io0WvEooYauGgMzHaSt+I4iTfFMNYxZKKaAs=;
	b=srw0mnD84e7+KCvUUq+YBv09wFdhwyNZS7zXWnNVjF5YWEWsaoJLr7em6Z1RmKcOzkeioE
	+jQpjTHhlQIcxxDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hSx7bv8Io0WvEooYauGgMzHaSt+I4iTfFMNYxZKKaAs=;
	b=GullVxnV+wSv0PobuV32Br6lLkFgYky1BkSkpNxpSDpMcaRFswSRHSH1+uUP9fYzDgTi69
	EokZgtF3bB6cH6fYTSST/hwlOPS/rMI3wx3my42gWYcRRvSwIcxxcKMmg+U/QJ/+JkowPE
	dXYI7lKS8eBxUOEBZ8Zz1JVgQDxnC9U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945077;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=hSx7bv8Io0WvEooYauGgMzHaSt+I4iTfFMNYxZKKaAs=;
	b=srw0mnD84e7+KCvUUq+YBv09wFdhwyNZS7zXWnNVjF5YWEWsaoJLr7em6Z1RmKcOzkeioE
	+jQpjTHhlQIcxxDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 383DC4273B;
	Thu, 19 Mar 2026 18:31:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZHoYCvRAvGmbdgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Mar 2026 18:31:16 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>,
	jhladky@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mm/mprotect: micro-optimization work
Date: Thu, 19 Mar 2026 18:31:04 +0000
Message-ID: <20260319183108.1105090-1-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CCBBC1C0018
X-Rspamd-Server: rspam08
X-Stat-Signature: azfrjp9ppyy5q6b9dt598yzdu1yu57ir
X-HE-Tag: 1773945078-127061
X-HE-Meta: U2FsdGVkX1/4jyyPokvgdQLM27FfP+kW44L7bnBAb5STdk16TJs3wL5pG27rDcIWQLzzzFGYzerOBW9X1nbd/S6vqgBSqyJvLYBKYeuUdnGuMznT9QTkya5htah9Ryj7nHbcQNBWaVXXhyBtzIfB2bEYtgKcJN71z267t2ky6ZLHB1nBRV1AyIW5Tqtm7JFtmS1I+2iEYaWWc1KUVHfknPuVR7REdgeeezYS97Dib1gyfOHzI0JhiguGuJGsH6GgOKAn4JerCdJlZj8I/8YKodJu0b5v+1yuR1vCAQQd75gCTEiBcX1dvJepHkzw2f474tPOlTaDrnQJunvlv9Fzpl9kYiLHfLJZvR1nHIPipVUdDZFJOQqCZc/xddHVO+Z3XWd4+jS7YJADZ3eCJ6si9D/sasgmJmh+iJ20BX3U3UV6xueKTgIDRuHHDxwK8XRE7UxfQeMcdSYWAUFz5ysrfzKOQG+OqG6tWw4+exa8WNSjhThG+G/aX3sH5IVBuxQ3vOfKndtXQTOuYu0x1f+81cAYMa3VGHBHWU8oLb+aP+CPx9/CqAp5+G8veWk9RnO/jKkM/FZkiUrtsCL1ZtmMIfkRQOP16k9azn8lX+GxwrDucX2un0E6vbX8yNM2BInTzZVaJt6ZV5eF2X6MyAfLQDCzwaKxNsMFfpbuF4FqYXiTMzUSZyLUp1PSDnNc7um3LZItFyGsA2zlkNN/avcNJgmr7hJSZkZpUtqT4861nqcDjbhZivnR5qlVqWpjkXK4Kytd8O8r2gOaZHOG/sC55Qf2WoTE+zKrv/Eja2boWUUt9nhue1MvkU7fXplbp+gTWM4jFqYg8ZSpupvTaZGZv500ZNtx/wTDbA/CNS+OrA0jnCtWA3wz5bS1PPGnVmiGILoxSwaXeIUm8x/9IAkfNGqBIYr/RVppfXx2TJjFjg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After a long session of performance-cat herding, here's the first version
I am relatively ok with.

Micro-optimize the change_protection functionality and the
change_pte_range() routine. This set of functions works in an incredibly
tight loop, and even small inefficiencies are incredibly evident when spun
hundreds, thousands or hundreds of thousands of times.

There was an attempt to keep the batching functionality as much as possible,
which introduced some part of the slowness, but not all of it. Removing it
for !arm64 architectures would speed mprotect() up even further, but could
easily pessimize cases where large folios are mapped (which is not as rare
as it seems, particularly when it comes to the page cache these days).

The micro-benchmark used for the tests was [0] (usable using google/benchmark
and g++ -O2 -lbenchmark repro.cpp)

This resulted in the following (first entry is baseline):

---------------------------------------------------------
Benchmark               Time             CPU   Iterations
---------------------------------------------------------
mprotect_bench      85967 ns        85967 ns         6935
mprotect_bench      82402 ns        82402 ns         6745
mprotect_bench      86776 ns        86776 ns         8100
mprotect_bench      86463 ns        86463 ns         8087
mprotect_bench      73374 ns        73373 ns         9602


After the patchset we can observe a 14% speedup in mprotect. Wonderful
for the elusive mprotect-based workloads!

Testing & more ideas welcome. I suspect there is plenty of improvement possible
but it would require more time than what I have on my hands right now. The
entire inlined function (which inlines into change_protection()) is gigantic
- I'm not surprised this is so finnicky.


[0]: https://gist.github.com/heatd/1450d273005aba91fa5744f44dfcd933
Link: https://lore.kernel.org/all/aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb/

Cc: Vlastimil Babka <vbabka@kernel.org> 
Cc: Jann Horn <jannh@google.com> 
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com> 
Cc: Luke Yang <luyang@redhat.com>
Cc: jhladky@redhat.com
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

Pedro Falcato (4):
  mm/mprotect: encourage inlining with __always_inline
  mm/mprotect: move softleaf code out of the main function
  mm/mprotect: un-inline folio_pte_batch_flags()
  mm/mprotect: special-case small folios when applying write permissions

 mm/mprotect.c | 158 +++++++++++++++++++++++++++-----------------------
 1 file changed, 85 insertions(+), 73 deletions(-)

-- 
2.53.0


