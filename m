Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8193DCCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F258E002D; Thu, 23 Oct 2025 09:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0E38E0002; Thu, 23 Oct 2025 09:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8988E002D; Thu, 23 Oct 2025 09:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9573C8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:53:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63DF6BCFB1
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:05 +0000 (UTC)
X-FDA: 84029520330.20.8DA8A6B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2EDFBC0012
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:53:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ijZFYtF7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O22eaDaE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zQ/9KIKM";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GVJOpUcu;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761227583; a=rsa-sha256;
	cv=none;
	b=t2VUX7tW9a82fqVfJnS3ytR8FQoOrQKgWv6wbXD1/rAGVAfNEv8JC60GBXcP4ULMoMMlc9
	Uo2mzAu+Nb1OSR2oYkO5BKLts0RRjaA1/eKBueoK2Fx6/JcbpGOhhDEuvYpFXE9leMT8wd
	oOpGyv1oqOdtrIGgSoJmGdm0ANdOqxg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ijZFYtF7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O22eaDaE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="zQ/9KIKM";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GVJOpUcu;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761227583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lCq3wXn+tApmnVAfVNMGfQ1nbGBWrxbHUQ3MPoNIz/8=;
	b=ACYq6OaHLXVw8QmYJ/P5DF3IEY1R+0pE/3H32X3j6gv8zKCWFDpzyjt6UDH4Z+zZL8/uZx
	LpzhdbCeG3qW6W5ovC46QW/xpahqd7ix2suk/b2HNS2EWi31qNssR1lwuNMEjHOMT1d8JV
	fUHYeM+j2VcImIsanZwq6Ksj7yNA1+Y=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1401F211FA;
	Thu, 23 Oct 2025 13:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227577; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lCq3wXn+tApmnVAfVNMGfQ1nbGBWrxbHUQ3MPoNIz/8=;
	b=ijZFYtF7h+Iw1klSJS7j+3zbM/IKAi2CPcIdhf6Ml7RaEhpT266VVb7Sm8HlMGIxa/6r+1
	gfQK+X8UYIBPbcT/9qF/6aiKIt44WIHG8kkGLcEziV4+BjO7oH6jQAG2hSlAt9+LkqrzaF
	FjdHMTulpuIw5aoa3qLhdd2ZwkzH4i8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227577;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lCq3wXn+tApmnVAfVNMGfQ1nbGBWrxbHUQ3MPoNIz/8=;
	b=O22eaDaE/e+xEw7r7E1LJzbqNZZsv1PSAhQCT2RDde9fzrun2lwr23v3vZwyyXOEj8/L5C
	/X5/5N8vTHn+9OAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761227573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lCq3wXn+tApmnVAfVNMGfQ1nbGBWrxbHUQ3MPoNIz/8=;
	b=zQ/9KIKMawQebDjiH64guED/G61cvKvNBLfmQf1Cotiq3OsvSMA2EmNKoexFXqKAvzDldV
	D20vKQGrVutkBvsaeSdf10o187497/fnjdDdTj57iX7hHX0vsPW+0d8Vajc5xYddcc+Gjb
	o1j1QBKI4im1TQCQgILy/L5vTqp1qJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761227573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lCq3wXn+tApmnVAfVNMGfQ1nbGBWrxbHUQ3MPoNIz/8=;
	b=GVJOpUcubdpiA+LZKWSyAdCmdUEP7uKm0KLKhKPX8bes/KQveEZzpGVnv3P0VKUx1Po/bW
	cZjggb93ufBHD3BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E7217136CF;
	Thu, 23 Oct 2025 13:52:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ANIIODQz+mjvQQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 23 Oct 2025 13:52:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH RFC 00/19] slab: replace cpu (partial) slabs with sheaves
Date: Thu, 23 Oct 2025 15:52:22 +0200
Message-Id: <20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABYz+mgC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDAwMj3eKM1MSy1GLdtPwi3cScHF0Ls8RkQ+OUZBPzRFMloK6CotS0zAq
 widFKQW7OSrG1tQCIPxapZgAAAA==
X-Change-ID: 20251002-sheaves-for-all-86ac13dc47a5
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>, Alexander Potapenko <glider@google.com>, 
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
X-Mailer: b4 0.14.3
X-Stat-Signature: krcet651fxiddrfncg1peqdhx8558u7g
X-Rspamd-Queue-Id: 2EDFBC0012
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761227582-280814
X-HE-Meta: U2FsdGVkX1+dBskz5TNr5zlBFYmr7fLKZYvfpkOLl5WQZkslu9DDouZHznwaMIbaRNqdWund1+XQUK8om8i1v2tKjWFmaDsCkKhXuywWOHKY4wFAjzAMxPtH5p3s4NxJsH64gBV/1zdICJtadSfikFIASw01F7erUAFk0ySTYAUM44fzGOYMUEmMkm8BTD8pFZDnkps6gIUWpdS1CNc4MIwVd27iNVHX7y5cpRf/6+SKEffciq2wq2QUGr6dqoZ/A6CjgLbxo2N2WGZJBfK1+LVfeXG3qaKnJEsgmNpi7hJqYv8EHBUOlZerfpy2Q0z40eOi/wecmkL/6aOnRTD77xwX38vv3Zvi2yskKBipkbWkU7WUA8AoLgzY4VO7bcU6dUdHCSeFYjP3C2pKs/UzOong0QntdEQwIviuV4NJE55Oo+ljMMjsp0iPUvS+PG53Bwfu5lItMjjRBIlUT82iFQtnb5ge+FkiU0gqVt0hQD6GIMF3KJczL4+GN6Ijl4LpMSeO6A9+tNKZTN1Pp/8y19IEtJ8LiylhHDLcK93A/dkoXOwhx7X4BqDy9dDf8b/VoeQ9Q1C7fWga1t+mazmJCGlk1o8i669B063ZnuiG0m+CkNEFjSQkqSr/mK7+2pFhvNmULyuupI3By71qts27Ke/mR2GCZ7R28rh50a5D5KHdue/Qa35gZE8YsmfbuCDp7B2aCLFLKAEf0kUIH8nL00Sf34Yb2BopcLLow0HTXXIyMI+bJDkHPSMuoP9bEM0ZnVmjlCiAWjVKO7jciXt7KZUoXXwuryF1Tpp9bYA3U/AU78LFyBAtuvcyteJ5qlHqCFf10nZYBta7fDY1QRG49H6Uy+YYbZx+k4Zdj4a06kxCHkrmnPpDEmgD3Rv6tDntcCK7d/ty0KEpig/n64lLXGRIGsdkIClpsBowUvAOXInFWUaSw7e6JW47b0Q1R6+tkkHw0ToWf+UzoYtgW38
 Oto298tY
 N3JuFDXdvj5R+qsuEMLIqQo7afzCX4EBputZuVfMsqR5oQvOGVrrRPWg88m2omXcc5FJ+s1QyBX03bOl1fnS8BIS1wDQo7gc+LjyvF68CZ5vEVcPG1dan76kqBQhY/f2utKCc1Oy8WGtFU4VtENVjoRpW6tOQgfEcPUjYB0ppRDlnGdVJVc6cTa+X/pW4wFlpoMxktHmhT9Aa4dV5g2rGmdX9cEtZTaboT7aTgxcdoSJv20hh4EQg17ZJqazkxq606GUV9yF6/Kzq4HU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Percpu sheaves caching was introduced as opt-in but the goal was to
eventually move all caches to them. This is the next step, enabling
sheaves for all caches (except the two bootstrap ones) and then removing
the per cpu (partial) slabs and lots of associated code.

Besides (hopefully) improved performance, this removes the rather
complicated code related to the lockless fastpaths (using
this_cpu_try_cmpxchg128/64) and its complications with PREEMPT_RT or
kmalloc_nolock().

The lockless slab freelist+counters update operation using
try_cmpxchg128/64 remains and is crucial for freeing remote NUMA objects
without repeating the "alien" array flushing of SLUB, and to allow
flushing objects from sheaves to slabs mostly without the node
list_lock.

This is the first RFC to get feedback. Biggest TODOs are:

- cleanup of stat counters to fit the new scheme
- integration of rcu sheaves handling with kfree_rcu batching
- performance evaluation

Git branch: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/sheaves-for-all

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Vlastimil Babka (19):
      slab: move kfence_alloc() out of internal bulk alloc
      slab: handle pfmemalloc slabs properly with sheaves
      slub: remove CONFIG_SLUB_TINY specific code paths
      slab: prevent recursive kmalloc() in alloc_empty_sheaf()
      slab: add sheaves to most caches
      slab: introduce percpu sheaves bootstrap
      slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
      slab: handle kmalloc sheaves bootstrap
      slab: add optimized sheaf refill from partial list
      slab: remove cpu (partial) slabs usage from allocation paths
      slab: remove SLUB_CPU_PARTIAL
      slab: remove the do_slab_free() fastpath
      slab: remove defer_deactivate_slab()
      slab: simplify kmalloc_nolock()
      slab: remove struct kmem_cache_cpu
      slab: remove unused PREEMPT_RT specific macros
      slab: refill sheaves from all nodes
      slab: update overview comments
      slab: remove frozen slab checks from __slab_free()

 include/linux/gfp_types.h |    6 -
 include/linux/slab.h      |    6 -
 mm/Kconfig                |   11 -
 mm/internal.h             |    1 +
 mm/page_alloc.c           |    5 +
 mm/slab.h                 |   47 +-
 mm/slub.c                 | 2601 ++++++++++++++++-----------------------------
 7 files changed, 915 insertions(+), 1762 deletions(-)
---
base-commit: 7b34bb10d15c412cdce0a1ea3b5701888b885673
change-id: 20251002-sheaves-for-all-86ac13dc47a5

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


