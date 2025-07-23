Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15DEAC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 13:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F406B00E4; Wed, 23 Jul 2025 09:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FF66B00E6; Wed, 23 Jul 2025 09:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2D96B00E7; Wed, 23 Jul 2025 09:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9483C6B00E4
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:35:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B6C7112EE8
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:46 +0000 (UTC)
X-FDA: 83695627092.07.34FB786
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 223684000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:35:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pIU+EtA8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="efJ/tCGx";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fO+P3SaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HbHWMqU1;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753277744; a=rsa-sha256;
	cv=none;
	b=k3As4K2q9I4rhMtV68dACKDRka/USIBoiaG2x8OFx2YkmlBF9uPLrQIWb8weQ0F5n5t+wC
	cI+Qxe+3xXDYcNA9nmRSTX7ov48w97eLDJjkH7aXfMK82olyMs7YDqjxGPjHyIbhYaMdtA
	4srOqICFx1zfV5o0lBfd46FZAvOwp2o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pIU+EtA8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="efJ/tCGx";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fO+P3SaX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=HbHWMqU1;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753277744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kwt4ZHwY1m6GY4e/lZYHq4MwJCFodT+GlQ0rZWrXgu8=;
	b=zfs4EL5/L4yRzrQMjuu7oQlcF9BP92Xt2Jb2HdYNX76gabueiyQyMwswBqE66kwmV3cV1C
	8uYb2KAZX0k8IeP9RLUx1g4gLIcD0ETONbCiDfCQbz9m5GGapq7OceRDGJKhTYTc6iOP4q
	fgNJjq3tt+qI40jjE3AInPG88MMrURE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D39572170E;
	Wed, 23 Jul 2025 13:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277704; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kwt4ZHwY1m6GY4e/lZYHq4MwJCFodT+GlQ0rZWrXgu8=;
	b=pIU+EtA89DmHQ8XLzmRdvpJ81P7E27eZfXWeARqeU6dL7EJxZIc2/SM+o7P7oLqM/5AYz1
	EG7p74AVzmH/IWyLz1YFDNm9Ff1bguNJSTSMDulnO/8jCefzftyu2ceIp8SlqX9/PcR22j
	LixMLyYwvzWb/eaBJwBE6TOtDOxK2+M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277704;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kwt4ZHwY1m6GY4e/lZYHq4MwJCFodT+GlQ0rZWrXgu8=;
	b=efJ/tCGxuZyOky8yVb+lp9fWqE5w+mBnPscCEVEMaKKNdhq11nRf/TSyLrF5qfZB0t8tUS
	aEZv4fey0iGTwXBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753277703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kwt4ZHwY1m6GY4e/lZYHq4MwJCFodT+GlQ0rZWrXgu8=;
	b=fO+P3SaXPXEaEK098hzF/u9vDADd5TWZnZ4ZuPWKbaleZ728Vjhr8hZBSs6XR0MOgcFDln
	CJEhmrckU4MJ9B9XigfJulYPppvgF7t0iPFEl1bkn2A9iCplUN4RgXiUswdGATlZUeCxqb
	AJk5+80PS2dbMlkL8nm7Xp8J3GkIzig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753277703;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=kwt4ZHwY1m6GY4e/lZYHq4MwJCFodT+GlQ0rZWrXgu8=;
	b=HbHWMqU1Hk0x2SKGRmma1tOhz9lB27zb98FDbzAjBaOphxGViTyeyPp6Y9lEJu2+tLQB58
	3tiVJNDmUr0HRWAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B885213ABE;
	Wed, 23 Jul 2025 13:35:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Zdu8LAflgGh0IwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 13:35:03 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v5 00/14] SLUB percpu sheaves
Date: Wed, 23 Jul 2025 15:34:33 +0200
Message-Id: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOnkgGgC/23Ry27CMBAF0F9BXtfIM37EZtX/qLrwY9JELQTsJ
 GqL+Pc6oIKQsryLObq+PrNCuafCdpszyzT3pR8ONeiXDYudP3wQ71PNDAVKALS8fE2BHynH48S
 jjx0V7pQC61AApIbVw2Omtv++om/vNbd52POxy+TvlLAgwEiDzdagMNzxOfjw6V/LVGgbfxem6
 8s45J9rtRkWbDlVUGustZiBC55SFCFFbEjou7V0mPEf0AJBrQJYAWu1QyLhjPHPgHwAEppVQFb
 AJWetSjYYJZ8B9QAU6lVALQ183cVZDMqrB3C57ZrpNNU/Gm/jsuAL8Tjs9/2421ikNmnjvHXCt
 RhAghIRgkxUXyW1Jy+C0FCxyx/8LcpH+AEAAA==
X-Change-ID: 20231128-slub-percpu-caches-9441892011d7
To: Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org, 
 maple-tree@lists.infradead.org, vbabka@suse.cz, 
 "Liam R. Howlett" <Liam.Howlett@Oracle.com>, 
 "Liam R. Howlett" <howlett@gmail.com>
X-Mailer: b4 0.14.2
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 223684000F
X-Stat-Signature: g4syn4xeg1qu976xdiowemgm9nzof1f1
X-HE-Tag: 1753277743-666310
X-HE-Meta: U2FsdGVkX19OBl3eD6g/CMpyuD5+UdfPpV6LeDH07A1iKQ0qZ2/DztT0UKixsrMfVtMoTxrPJVEfkNi5GG7eGUgDhce2UpPx61lj/rDsac8pQ3I34f1jW6H1j3cfuUO1M9Wr2+ag3T9N6UROhYb17L3adI0ja5zWe22O8pM5/6BKzM5atquUi9V2urLu+elYHQj5ibGat073VPKEtq6E3ICp6e+P3D3F0q4eRl5jazppehDdEBuPZ1Vmfq4fczAVoSwbpYRLNDrquEtHgAaoJva9/GIoYUygKz/2GS4LO2KSXg+WfpU+N9hSDVLmf74J2Dd6hN8E53B3oIJhk4wYh8LWC7aatn28ZZOcbrBb0bnJXbBVk7LlI8In+yE8JRvDWC2cTlgY8+/eAxizO+5Y3VsnX6zoZtarWm48sgJBmFgfnU5ArsIjbWvj0TNxpKSZYCqowHJpQJQ6ntdIE/mQD6nUPlZsBfMdpU7JAmhcyWSQ3Xn1g2FDDpukv2us0GwQ4ygbLMFkPsIJ0rcHHc3gJiKrXTeP8RlObFXUEotmpTTPuOTnEas/FR4wCd+i5wvYiSt7dPo9rg8mNvKOvKk5kQCtnpqWIuTtnSoKN6CzK2heJGm7gKq3KIVBnn9ky1odW9SHZ1ICWbfmd/O22PqBToCRFA7Vs6EYTPH0h0uj4mZIuNAGSfWOu1RWo5TR/kl8x1XgRzSOjt1TNdlK9ddKJQtziXGtgYGAK/JK8cWBmKpV6CzSUU9cgMk844YN5K3IG5ChW6BvSC9geA2icXZljt5vMlO3cws2mJwrJ5mZ9o3a90c7FPeUE0aObAEVDBjMEGTX6hbTArn1Y8EiqldpKPaJrl+NVy57VzU62ui2I43RsWq7FE6CTyvSk0R2eWfO+zjffV/3pv+8K8CiefiAKk5QFD8qhr/db9sqiDnYwEG2uRj2rtsJGIHuU8iul3adWJJ3Zj/croair+j697Z
 cU/oiitH
 L/sMC6tCPuTrbkFPPTq+6TI126i0pNETj5fkKeZEF4w524zPp0WNgwA055m1ZkmanQulDPc6y4STwIiJ1EMzJoBOBfq+IidlGrcE7HdnSL27Hz0NPT+Mo2rOVawnNVsBFpF+gSAgHtufM7nqETuuAMqvFoBhC8b0+96jR7mQ/r0qXkeev38AWEIzC6CSu5h6O7I1MO06zV0F2lBf/9+XLi3ntnW+4Z7nEZXztW+sJ2pYY/0k5gunlv0ZVej4oBSCJsWX/3Pz7szVPsc1xLIAIxZUa9EAIPKgnp13s45M51r58MvSc2Jl5he9gL4+PFXw2KIorB1+0B8wn1lP5OAx7guBAP+9wOyraartH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This series adds an opt-in percpu array-based caching layer to SLUB.
It has evolved to a state where kmem caches with sheaves are compatible
with all SLUB features (slub_debug, SLUB_TINY, NUMA locality
considerations). My hope is therefore that it can eventually be enabled
for all kmem caches and replace the cpu (partial) slabs.

The v5 is posted for reviews and testing/benchmarking purposes. After
6.17-rc1 I hope to post a rebased v6 and start including it in
linux-next.

Note the name "sheaf" was invented by Matthew Wilcox so we don't call
the arrays magazines like the original Bonwick paper. The per-NUMA-node
cache of sheaves is thus called "barn".

This caching may seem similar to the arrays in SLAB, but there are some
important differences:

- does not distinguish NUMA locality, thus there are no per-node
  "shared" arrays (with possible lock contention) and no "alien" arrays
  that would need periodical flushing
  - NUMA restricted allocations and strict_numa mode is still honoured,
    the percpu sheaves are bypassed for those allocations
  - a later patch (for separate evaluation) makes freeing remote objects
    bypass sheaves so sheaves contain mostly (not strictly) local objects
- improves kfree_rcu() handling by reusing whole sheaves
- there is an API for obtaining a preallocated sheaf that can be used
  for guaranteed and efficient allocations in a restricted context, when
  the upper bound for needed objects is known but rarely reached
- opt-in, not used for every cache (for now)

The motivation comes mainly from the ongoing work related to VMA locking
scalability and the related maple tree operations. This is why VMA and
maple nodes caches are sheaf-enabled in the patchset. In v5 I include
Liam's patches for full maple tree conversion that uses the improved
preallocation API.

A sheaf-enabled cache has the following expected advantages:

- Cheaper fast paths. For allocations, instead of local double cmpxchg,
  thanks to local_trylock() it becomes a preempt_disable() and no atomic
  operations. Same for freeing, which is otherwise a local double cmpxchg
  only for short term allocations (so the same slab is still active on the
  same cpu when freeing the object) and a more costly locked double
  cmpxchg otherwise.

- kfree_rcu() batching and recycling. kfree_rcu() will put objects to a
  separate percpu sheaf and only submit the whole sheaf to call_rcu()
  when full. After the grace period, the sheaf can be used for
  allocations, which is more efficient than freeing and reallocating
  individual slab objects (even with the batching done by kfree_rcu()
  implementation itself). In case only some cpus are allowed to handle rcu
  callbacks, the sheaf can still be made available to other cpus on the
  same node via the shared barn. The maple_node cache uses kfree_rcu() and
  thus can benefit from this.

- Preallocation support. A prefilled sheaf can be privately borrowed to
  perform a short term operation that is not allowed to block in the
  middle and may need to allocate some objects. If an upper bound (worst
  case) for the number of allocations is known, but only much fewer
  allocations actually needed on average, borrowing and returning a sheaf
  is much more efficient then a bulk allocation for the worst case
  followed by a bulk free of the many unused objects. Maple tree write
  operations should benefit from this.

- Compatibility with slub_debug. When slub_debug is enabled for a cache,
  we simply don't create the percpu sheaves so that the debugging hooks
  (at the node partial list slowpaths) are reached as before. The same
  thing is done for CONFIG_SLUB_TINY. Sheaf preallocation still works by
  reusing the (ineffective) paths for requests exceeding the cache's
  sheaf_capacity. This is in line with the existing approach where
  debugging bypasses the fast paths and SLUB_TINY preferes memory
  savings over performance.

GIT TREES:

this series: https://git.kernel.org/vbabka/l/slub-percpu-sheaves-v5r0
It is based on v6.16-rc1.

this series plus a microbenchmark hacked into slub_kunit:
https://git.kernel.org/vbabka/l/slub-percpu-sheaves-v5-benchmarking

It allows evaluating overhead of the added sheaves code, and benefits
for single-threaded allocation/frees of varying batch size. I plan to
look into adding multi-threaded scenarios too.

The last commit there also adds sheaves to every cache to allow
measuring effects on other caches than vma and maple node. Note these
measurements should be compared to slab_nomerge boots without sheaves,
as adding sheaves makes caches unmergeable.

RESULTS:

In order to get some numbers that should be only due to differences in
implementation and no cache layout side-effects in users of the slab
objects etc, I have started with a in-kernel microbenchmark that does
allocating and freeing from a slab cache with or without sheaves and/or
memcg. It's either alternating single object alloc and free, or
allocates 10 objects and frees them, then 100, then 1000
- in order to see the effects of exhausting percpu sheaves or barn, or
(without sheaves) the percpu slabs. The order of objects to free can
be also shuffled instead of FIFO - to stress the non-sheaf freeing
slowpath more.

Measurements done on Ryzen 7 5700, bare metal.

The first question was how just having the sheaves implementation affects
existing no-sheaf caches due to the extra (unused) code. I have experimented
with changing inlining and adding unlikely() to the sheaves case. The
optimum seems is what's currently in the implementation - fast-path sheaves
usage is inlined, any handling of main sheaf empty on alloc/full on free is
a separate function, and the if (s->sheaf_capacity) has neither likely() nor
unlikely(). When I added unlikely() it destroyed the performance of sheaves
completely.

So the result is that with batch size 10, there's 2.4% overhead, and the
other cases are all impacted less than this. Hopefully acceptable with the
plan that eventually there would be sheaves everywhere and the current
cpu (partial) slabs scheme removed.

As for benefits of enabling sheaves (capacity=32) see the results below,
looks all good here. Of course this microbenchmark is not a complete
story though for at least these reasons:

- no kfree_rcu() evaluation
- doesn't show barn spinlock contention effects. In theory shouldn't be
worse than without sheaves because after exhausting cpu (partial) slabs, the
list_lock has to be taken. Sheaf capacity vs capacity of partial slabs is a
matter of tuning.

---------------------------------
 BATCH SIZE: 1 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 115660272
 bench: no memcg, sheaves
 average (excl. iter 0): 95734972
 sheaves better by 17.2%
 bench: memcg, no sheaves
 average (excl. iter 0): 163682964
 bench: memcg, sheaves
 average (excl. iter 0): 144792803
 sheaves better by 11.5%

 ---------------------------------
 BATCH SIZE: 10 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 115496906
 bench: no memcg, sheaves
 average (excl. iter 0): 97781102
 sheaves better by 15.3%
 bench: memcg, no sheaves
 average (excl. iter 0): 162771491
 bench: memcg, sheaves
 average (excl. iter 0): 144746490
 sheaves better by 11.0%

 ---------------------------------
 BATCH SIZE: 100 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 151796052
 bench: no memcg, sheaves
 average (excl. iter 0): 104641753
 sheaves better by 31.0%
 bench: memcg, no sheaves
 average (excl. iter 0): 200733436
 bench: memcg, sheaves
 average (excl. iter 0): 151340989
 sheaves better by 24.6%

 ---------------------------------
 BATCH SIZE: 1000 SHUFFLED: NO
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 187623118
 bench: no memcg, sheaves
 average (excl. iter 0): 130914624
 sheaves better by 30.2%
 bench: memcg, no sheaves
 average (excl. iter 0): 240239575
 bench: memcg, sheaves
 average (excl. iter 0): 181474462
 sheaves better by 24.4%

 ---------------------------------
 BATCH SIZE: 10 SHUFFLED: YES
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 115110219
 bench: no memcg, sheaves
 average (excl. iter 0): 100597405
 sheaves better by 12.6%
 bench: memcg, no sheaves
 average (excl. iter 0): 163573377
 bench: memcg, sheaves
 average (excl. iter 0): 144535545
 sheaves better by 11.6%

 ---------------------------------
 BATCH SIZE: 100 SHUFFLED: YES
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 152457970
 bench: no memcg, sheaves
 average (excl. iter 0): 108720274
 sheaves better by 28.6%
 bench: memcg, no sheaves
 average (excl. iter 0): 203478732
 bench: memcg, sheaves
 average (excl. iter 0): 151241821
 sheaves better by 25.6%

 ---------------------------------
 BATCH SIZE: 1000 SHUFFLED: YES
 ---------------------------------

 bench: no memcg, no sheaves
 average (excl. iter 0): 189950559
 bench: no memcg, sheaves
 average (excl. iter 0): 177934450
 sheaves better by 6.3%
 bench: memcg, no sheaves
 average (excl. iter 0): 242988187
 bench: memcg, sheaves
 average (excl. iter 0): 221609979
 sheaves better by 8.7%

Vlastimil

---
Changes in v5:
- Apply review tags (Harry, Suren) except where changed too much (first
  patch).
- Handle CONFIG_SLUB_TINY by not creating percpu sheaves (Harry)
- Apply review feedback (typos, comments).
- Extract handling sheaf slow paths to separate non-inline functions
  __pcs_handle_empty() and __pcs_handle_full().
- Fix empty sheaf leak in rcu_free_sheaf() (Suren)
- Add "allow NUMA restricted allocations to use percpu sheaves".
- Add Liam's maple tree full sheaf conversion patches for easier
  evaluation.
- Rebase to v6.16-rc1.
- Link to v4: https://patch.msgid.link/20250425-slub-percpu-caches-v4-0-8a636982b4a4@suse.cz

Changes in v4:
- slub_debug disables sheaves for the cache in order to work properly
- strict_numa mode works as intended
- added a separate patch to make freeing remote objects skip sheaves
- various code refactoring suggested by Suren and Harry
- removed less useful stat counters and added missing ones for barn
  and prefilled sheaf events
- Link to v3: https://lore.kernel.org/r/20250317-slub-percpu-caches-v3-0-9d9884d8b643@suse.cz

Changes in v3:
- Squash localtry_lock conversion so it's used immediately.
- Incorporate feedback and add tags from Suren and Harry - thanks!
  - Mostly adding comments and some refactoring.
  - Fixes for kfree_rcu_sheaf() vmalloc handling, cpu hotremove
    flushing.
  - Fix wrong condition in kmem_cache_return_sheaf() that may have
    affected performance negatively.
  - Refactoring of free_to_pcs()
- Link to v2: https://lore.kernel.org/r/20250214-slub-percpu-caches-v2-0-88592ee0966a@suse.cz

Changes in v2:
- Removed kfree_rcu() destructors support as VMAs will not need it
  anymore after [3] is merged.
- Changed to localtry_lock_t borrowed from [2] instead of an own
  implementation of the same idea.
- Many fixes and improvements thanks to Liam's adoption for maple tree
  nodes.
- Userspace Testing stubs by Liam.
- Reduced limitations/todos - hooking to kfree_rcu() is complete,
  prefilled sheaves can exceed cache's sheaf_capacity.
- Link to v1: https://lore.kernel.org/r/20241112-slub-percpu-caches-v1-0-ddc0bdc27e05@suse.cz

---
Liam R. Howlett (6):
      tools: Add testing support for changes to rcu and slab for sheaves
      tools: Add sheaves support to testing infrastructure
      testing/radix-tree/maple: Increase readers and reduce delay for faster machines
      maple_tree: Sheaf conversion
      maple_tree: Add single node allocation support to maple state
      maple_tree: Convert forking to use the sheaf interface

Vlastimil Babka (8):
      slab: add opt-in caching layer of percpu sheaves
      slab: add sheaf support for batching kfree_rcu() operations
      slab: sheaf prefilling for guaranteed allocations
      slab: determine barn status racily outside of lock
      maple_tree: use percpu sheaves for maple_node_cache
      mm, vma: use percpu sheaves for vm_area_struct cache
      mm, slub: skip percpu sheaves for remote object freeing
      mm, slab: allow NUMA restricted allocations to use percpu sheaves

 include/linux/maple_tree.h            |    6 +-
 include/linux/slab.h                  |   47 +
 lib/maple_tree.c                      |  393 +++-----
 lib/test_maple_tree.c                 |    8 +
 mm/slab.h                             |    4 +
 mm/slab_common.c                      |   32 +-
 mm/slub.c                             | 1646 +++++++++++++++++++++++++++++++--
 mm/vma_init.c                         |    1 +
 tools/include/linux/slab.h            |   65 +-
 tools/testing/radix-tree/maple.c      |  639 +++----------
 tools/testing/shared/linux.c          |  112 ++-
 tools/testing/shared/linux/rcupdate.h |   22 +
 12 files changed, 2104 insertions(+), 871 deletions(-)
---
base-commit: 82efd569a8909f2b13140c1b3de88535aea0b051
change-id: 20231128-slub-percpu-caches-9441892011d7

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


