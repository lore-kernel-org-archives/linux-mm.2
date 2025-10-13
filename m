Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ACE7CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 14:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28C08E001F; Mon, 13 Oct 2025 10:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF9A8E0017; Mon, 13 Oct 2025 10:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15878E001F; Mon, 13 Oct 2025 10:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A14758E0017
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:58:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3587859259
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:58:33 +0000 (UTC)
X-FDA: 83993397306.05.27A47D6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 806B78000A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:58:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yARdaJDo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JGG2Btah;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V2Kj+Euk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1DkU73VJ;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760367511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qcvuerjXx7ZIiFOwSPYkO0MEVGe90oiiAUJVcvRd3Fc=;
	b=bA+gF5dfitvQikcMXh26nNENetKqQpM9ioAWZEifPrpmLzDNhsJt9uHd4vpD6W99N3QuDD
	SBxEVf7FKYPefn1uEAvkmwXCCL+U9MshjM+IpU5Ct6DKv87V947Fs7TH/YiI70KMuVQoTR
	UdfZHequKqDlEXL25/Hw+61mFJrZXD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760367511; a=rsa-sha256;
	cv=none;
	b=C/u2EGaPnL63ocfS5e7ulvr5tI6RNC+r1xM+MqsfUTSnIJX4Y7otBblZOUfPUiyahkZFP8
	sRZSiGZ2H4jKPfPtP9ZlaE1s1qGaQcKNi+ect8weM4mG0wYz8dEUiSXwAZDilaVbiDMj91
	17WO54VoT/mXcyV13uGbWMmaMo84eVI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yARdaJDo;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JGG2Btah;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=V2Kj+Euk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1DkU73VJ;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CD49921246;
	Mon, 13 Oct 2025 14:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760367509; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qcvuerjXx7ZIiFOwSPYkO0MEVGe90oiiAUJVcvRd3Fc=;
	b=yARdaJDoEym+6DuoIJ14UBqZ6qDODq3KlgbIjHdtN4KSqzlO9BHY+T4gcxRRINVn8b3CJb
	tcHw5TQ0J42s4JC8h0hQ0mM1P1IX01SuI8nk9FXBNb9pD77fCTxOmmpzT/jnGPxFgEtg90
	MEz8QFYWpNE6ynXunKDslm+XdokyPfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760367509;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qcvuerjXx7ZIiFOwSPYkO0MEVGe90oiiAUJVcvRd3Fc=;
	b=JGG2Btahk4A1b6L6yzw2/gqML91UOlHl4jLbGieAHvA0XKSlxZXHvEDIu6FQMRwnGTsLTl
	Gf0RqDZhrhEPD8Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760367508; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qcvuerjXx7ZIiFOwSPYkO0MEVGe90oiiAUJVcvRd3Fc=;
	b=V2Kj+Eukw2Nmbfkq7SfhMit7Kpm9uyq49qc8r0IiUOuTX8wDKZxVpA2aQWiv66X77Y5pq+
	OFkWa9dujt/MjM9caUDkTXhtcnHoFDKQ0qQNQPXKJenK20Yym8D0e8liUnlKiYw1ZACVZi
	cWxNNz0deq2Ql9Na4yuqk0B1HWnZ91A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760367508;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qcvuerjXx7ZIiFOwSPYkO0MEVGe90oiiAUJVcvRd3Fc=;
	b=1DkU73VJvf1A7kvmsYiY3hPW/iLjPsoX4SS/a8dvuMsZUq1t5Wm+bTfJkbxKVhFy2NRvQt
	u2PWqLBfd1BMDvBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B01471374A;
	Mon, 13 Oct 2025 14:58:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id d6SoKpQT7WhHNwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 13 Oct 2025 14:58:28 +0000
Message-ID: <692b6230-db0c-4369-85f0-539aa1c072bb@suse.cz>
Date: Mon, 13 Oct 2025 16:58:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [slab] af92793e52:
 BUG_kmalloc-#(Not_tainted):Freepointer_corrupt
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>,
 Alexei Starovoitov <ast@kernel.org>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Harry Yoo <harry.yoo@oracle.com>, kasan-dev@googlegroups.com,
 cgroups@vger.kernel.org, linux-mm@kvack.org
References: <202510101652.7921fdc6-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202510101652.7921fdc6-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 806B78000A
X-Rspamd-Server: rspam02
X-Stat-Signature: r44f9y4kg9t4w8ar3hjnstsxp6honyf6
X-HE-Tag: 1760367510-476297
X-HE-Meta: U2FsdGVkX18acKT6wOYq46fgdYPlLV0NNbXw6HFzBYGn6VGKL9kbOddzd8j0WgLTRl3Sc9YijC+Zt4fC4rm3RCe3Cqu3rZsGNAXjyBI/QB0Pwr77LTmsz6EIMP4Gm6blxjURJ843LBEUL9baQg4qxx6mDeKJcRyslLBwbXHbanLCLHVaqCKuBIyVb6OP3+v+3n1aXw10DUqwzD5EVTsCEps0EUTNx+zu6e/RcYKn6oD1ls660OBWBkje4Nq6c3rCCQJdUhZvUm/Xm9oCFOatxmkOe1r1F8NrfeWKAhMcenuBf9+Ninw8caMg7mftLOq3mIRGz60Xil5MDnUo5rLUrfw4hme+Wij5TVVAG6zoNXMQtGL++LnXcHdGi8sXF25Ld+kvrsPJFwXrsTVuyX1XRra9ZNMY07CcqS9oei1SgJOkoUCzF72Ct95YKHFYwlYyw1m8/f3YhrlS8E9Tw7gw2slB97RJGwAtdnDT+D9plj+Lt01ANp+naheseEet8eafAztMQDAs/of1C5i2glCGCPdMAPOxKrKgUDN9NMkXnjACfrO6fLZU5IxFR2+jGxpeRCzEWqenmmQu1NmnbU7L7Yvs8dqbnpZQsRjXAWCmGR7p6RQJJ8wXtR7fPpaG+c1xFTOgYUQWEfNx0ADFdsVWSpQVh0XQ8bqVbH8EL556ReR0+YlbBsYUMCZovAlrGQOwyRrsaZfK3LcariCUr/PUlPE9489WnM+sDb0fNw1I5tPP13+0uqa1Nel2Ou+neOJHZ4vBb+rZxQH3YvzPKJ0icOWPYNzf8n1g0hMfgIcukPMn5NDujhvIie59u2cenfiAR0VYj1C+wIHLSYvB8Ul0jOD5mr26FpDLbis/YMiRWnfJAh5Hc08B121BWx5cHeIf+08At2fz1CkHTs9VnvqRD7QkknLhGbvy0Xm+q5lVaCJ6/jMyNB0xZcjs3y6dp7lx1PI6Vl6rT9tgvCGWKuT
 gfDw8LE+
 g7OmnS+89ylyfjI+g40/uucl7cbvP+gKVyGElpHLw1JQFMDJs98sjUnsIvz5jYMc4wfr4MNIZMcpUCnv+KJVUeLVhOxBgyKaNUcJqDxRj4w+LkA5me8gUXFNrN+1jnHN6P9rspCmOk9sxVC3JdbAt72pB/Pu5n+GNUMs137buEyQkjvai8Sd6JhYugOMw8YQI0Cq42tmE2WaIWsrdPM8bC4XdcBA3Lw46WUU8RvlDmDqtoE0+CbhbRlGHi0o3a3+0A5NaYD0Un1CLtmiuxSQgHgMvgIvOKjnJp4P9iLN6hmrM3Gi2A1t1HN7096xshEG+lGm/f5r/YzmN5EGhDotR2zS4FcDYSejVamM8WSLn//gOJAEqJehz2o1wAsPFbA3q1GgV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/25 10:39, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed "BUG_kmalloc-#(Not_tainted):Freepointer_corrupt" on:
> 
> commit: af92793e52c3a99b828ed4bdd277fd3e11c18d08 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> 
> [test failed on      linus/master ec714e371f22f716a04e6ecb2a24988c92b26911]
> [test failed on linux-next/master 0b2f041c47acb45db82b4e847af6e17eb66cd32d]
> [test failed on        fix commit 83d59d81b20c09c256099d1c15d7da21969581bd]
> 
> in testcase: trinity
> version: trinity-i386-abe9de86-1_20230429
> with following parameters:
> 
> 	runtime: 300s
> 	group: group-01
> 	nr_groups: 5
> 
> 
> 
> config: i386-randconfig-012-20251004
> compiler: gcc-14
> test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G
> 
> (please refer to attached dmesg/kmsg for entire log/backtrace)
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202510101652.7921fdc6-lkp@intel.com

Does this fix it?
----8<----
From 5f467c4e630a7a8e5ba024d31065413bddf22cec Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 13 Oct 2025 16:56:28 +0200
Subject: [PATCH] slab: fix clearing freelist in free_deferred_objects()

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f9f7f3942074..080d27fe253f 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6377,15 +6377,16 @@ static void free_deferred_objects(struct irq_work *work)
 		slab = virt_to_slab(x);
 		s = slab->slab_cache;
 
+
+		/* Point 'x' back to the beginning of allocated object */
+		x -= s->offset;
 		/*
 		 * We used freepointer in 'x' to link 'x' into df->objects.
 		 * Clear it to NULL to avoid false positive detection
 		 * of "Freepointer corruption".
 		 */
-		*(void **)x = NULL;
+		set_freepointer(s, x, NULL);
 
-		/* Point 'x' back to the beginning of allocated object */
-		x -= s->offset;
 		__slab_free(s, slab, x, x, 1, _THIS_IP_);
 	}
 
-- 
2.51.0



