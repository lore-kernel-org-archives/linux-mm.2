Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC02606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=arSMc7Jk;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xzmt3b16;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=arSMc7Jk;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=xzmt3b16
Received: by kanga.kvack.org (Postfix)
	id 30E166B05B0; Fri, 27 Nov 2026 17:14:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4F46B05B1; Fri, 27 Nov 2026 17:14:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6636B05BA; Fri, 27 Nov 2026 17:14:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA3926B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:14:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BB06160505
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:14:47 +0000 (UTC)
X-FDA: 85482304614.15.742B14E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id 17FC94000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:14:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=arSMc7Jk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xzmt3b16;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=arSMc7Jk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xzmt3b16;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795817685;
	b=BhAO3ejyENlngV6mpYfn9jqfmOb3oJx/vNg1ZoP6whW5imrDx8Zwct4FJQc7SjHcglojGH
	haVLYR2vWn1/EILp7oxemp73qQLl+iifBfvpp6IGfZ45Aw40/QboONv1s0y5Lm9BW1a+5W
	uCKgfTNOdeA6eay5sjK9kvVTX7biL8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795817685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Bi05ngae937veh3VTPCl3E+t1DmeQqROSZ274a2qhw=;
	b=rrtl1cQt7U65vi7NDumVno4rp8CWVYiK9hXRQw4pKveG2cbWIs8p7TukFnzj9WxYYZoldX
	RkGEdHcyvsXLnrdfb6Pk8qKUYe+e0BFpl46RIhuk/P7yhgQ0j7V5WB0e8+3eiYbjAgZcp3
	oHIHYYbtDC6Zf4E35qU5/XwZoS6nhxA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=arSMc7Jk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xzmt3b16;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=arSMc7Jk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xzmt3b16;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 945F521CCB;
	Fri, 27 Nov 2026 22:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795817683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Bi05ngae937veh3VTPCl3E+t1DmeQqROSZ274a2qhw=;
	b=arSMc7JkORFVEr/Ng4920N9REF+5mWhQYk9Vbe06+nDQ+Lpxr0w1oc+N0aTyOWn37BsY6Y
	ULK9ZOpM4vJughdfsjvUBAk7eBgOt/moe9xiqS0ESwqWkyQC34PTCsfjHuUiVHWA9GHEEe
	xTvpHfzgRmwWng4AbKqGzqeMK1pZyrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795817683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Bi05ngae937veh3VTPCl3E+t1DmeQqROSZ274a2qhw=;
	b=xzmt3b16eGWvBe6vNk78O3ka+SO6Nqz7t8hhrHRxf9l87ulmLm2N7l65Xc0Fq6P1JMzgQK
	bqRkDQ/nl57MYBCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795817683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Bi05ngae937veh3VTPCl3E+t1DmeQqROSZ274a2qhw=;
	b=arSMc7JkORFVEr/Ng4920N9REF+5mWhQYk9Vbe06+nDQ+Lpxr0w1oc+N0aTyOWn37BsY6Y
	ULK9ZOpM4vJughdfsjvUBAk7eBgOt/moe9xiqS0ESwqWkyQC34PTCsfjHuUiVHWA9GHEEe
	xTvpHfzgRmwWng4AbKqGzqeMK1pZyrA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795817683;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3Bi05ngae937veh3VTPCl3E+t1DmeQqROSZ274a2qhw=;
	b=xzmt3b16eGWvBe6vNk78O3ka+SO6Nqz7t8hhrHRxf9l87ulmLm2N7l65Xc0Fq6P1JMzgQK
	bqRkDQ/nl57MYBCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92313134E8;
	Fri, 27 Nov 2026 22:14:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2bMxGNEACmuzKQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Nov 2026 22:14:41 +0000
Date: Fri, 27 Nov 2026 22:14:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
	Andrew Morton <akpm@linux-foundation.org>, David Rheinsberg <david@readahead.eu>, 
	Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Alex Shi <alexs@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, 
	Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Arnd Bergmann <arnd@arndb.de>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	codalist@coda.cs.cmu.edu, linux-mm@kvack.org, Andrei Vagin <avagin@gmail.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Chris Mason <mason@kernel.org>
Subject: Re: [PATCH 2/4] mm/madvise: don't declare OOM for MADV_WILLNEED
 swapin
Message-ID: <awn_JzICZBkxK8Qn@pedro-suse.tail5790ac.ts.net>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
 <20261127-mlock-madvise-mprotect-ai-fixes-v1-2-e46b2b1eb435@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-2-e46b2b1eb435@kernel.org>
X-Spam-Score: -13.30
X-Spam-Level: 
X-Rspamd-Queue-Id: 17FC94000D
X-Stat-Signature: uk3rmbyjbyigxodhdn39anm7t341gkr7
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795817684-124930
X-HE-Meta: U2FsdGVkX19y1NpJAMH6wWmuwANEK1Lrs50d62J98sCvEsZE4YnHLQtHlZmgrrP1T+mtt5UgrriLy4HVr7i/f/xhA0aVvKQDSub5ciXxkNicPWmIW+Y7SclH+3GUXChDEtAB1xWMcn00rmLR3+VOG+OfsS5XjVeCx7UFUt5qxHNjtlEex5mtJ0ovz/VsEXKysKRmRHrk6mugCSKm5GS/DZ2AwWZx1t5ePq2HQtfmdVBz8DqzK7WDoo+Lg9+gDwbQura4AlOUcWC99Aii4Kj76z7a3YeA+LmAs4q6HXAFJb8cQmcDcTacHvIKR+/MeRlAcNA3Uux7n3DxbL9nw0JUjLhUS2Xe/BNvnvHw6kJXLMlK9g4WnBHCie6lnrXvyWoxZ0+gofeH5bmmc/5zeiR6vtWUFlnMPmXYDdyj0hrtppXsh8+LVpTWViy63dwT+giStgEh3Cu8I0NqEfx2Ig171CR7DRNVblqGvf1o+qf9TR8mH6ShZx7hWV8UHS/cZAs6R8CyOSk4VnT1yWunHrTEK30PsIv1FgKhmhvPFKy6cyrkdR9epHMpTduCMotbrY8kw6t0MKhZ2TdVCGwxvm4p3t6yLEJbMCtZwAz948qXbwZwiz6Zu6debOWfqd7VWgZPwcDPVGOqH0Yzy7kt6DVrUyPpvQoBktyD+lamqcYkO1bPeGRClm3HtbfU6oOZdu3DjQb2phR46sVH2FSnnWeTb3tIM5fJUmU43LF4AEqYGZfuoJamxCh9M/M4v5vam1VkogDsv+EGMaeA9Pe7HRlKIOAutSaza7bIMnwItya4vgjwBfe5hh3K+tmHl3HxUSxyDkwtiubC9KhEG3KX5ikpEfYUIAGLACpRwIAI3/7u+mlkQ8yzYmFEzv08yTo+7/VWzuCX+t7vWMvx9YwYiceuL9eSyVCHx+OYyYYIm6kNHuX/jbAEa8ktE4oNW6zmqHO82QlsFlpO425I2ez+PA+
 Xbc0Bp7c
 0XYGO0AszgHmKz+xQnNYUAT+cmb6xOmEYA2DZkQY6eR6QsDo8fxqlj16+uSMbtU6+vTl+KnfAQwVBc/nFhwS7bpdfam3CM3WBLP8m4CB28H6Wgc2Q7gszUE6HN6SjhYgF4xKz2cJTl8Ks7368p2dsfOo61qFSwYQW6AnhSM8IMIbYMaa9chF/T3i9aPeegzq89Ak5vxVMKT/dfPFsfVED7cTj05jJafMo2jHcgTZaojBCIlhVHweu7jjR/ftaJa/9dHKs7qLDerQOzVUInQPTsSpRE9UeBSbYahCz/K1iG0EUpbpR5Y9FeVeKwjYE5oevEbog5aI2ndZPbZKMtKPj3WVdd95zDaDrZc17DTOtSY1jlM16SHYmKZxX9sXw3uj7OsKykFbI1ciVWJ/U7TX5MgZ1vICMhpBfR/g3XnT/OIgezPP3hgHxRkBzTqPe9F+hvEQdXWdQ+/M0MWASHxxCkG+WL/Qhmvzbgyh0JNcdgDuRq9AW5KjAobaDPO1cH9muE0Lol8+LWsxTkou5W51lTDuNM931WAbWVj0kJHavX78qJUpR57QEjoWwTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 27, 2026 at 07:45:41PM +0000, Lorenzo Stoakes (ARM) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> MADV_WILLNEED on memory in swap can OOM kill a task when the memcg that
> the swap entries are charged to is at its limit.
> 
> The hint is only a prefetch, so it has to give up on a page when memory
> is short. But swapin_walk_pmd_entry() and shmem_swapin_range() call
> read_swap_cache_async() with GFP_HIGHUSER_MOVABLE and with the gfp mask
> of the mapping, so the allocation and the memcg charge can both go as
> far as the OOM killer.
> 
> The charge goes to the memcg of the swap entry, which need not be the
> caller's.
> 
> The fix used here is to allocate with the gfp mask of readahead, and to
> flush the block plug when a page fails. madvise_do_behavior() plugs the
> whole walk, so the swap writes of reclaim can sit in that plug. Their
> folios stay under writeback, and with no retries the rest of the range
> can fail as well.

How about we don't do that? Something something separation of concerns.
If we want this functionality (and we very well might), I would suggest
we do this in reclaim code itself. Something like

blk_finish_plug_or_flush().

Because I really don't want to set the precedent of making every direct reclaim
caller aware of block plugs.

Either that, or we let it fail.

> 
> The hint can now skip pages when memory is short, whether in a memcg at
> its limit or on the system as a whole, since neither the allocation nor
> the memcg charge is retried any longer.
> 
> This applies in particular where reclaim has to write to swap to make
> room. Skipped pages stay in swap until a fault reads them.
> 
> Fixes: 4c6355b25e8b ("mm: memcontrol: charge swapin pages on instantiation")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ ljs: commit message tweak ]
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Aside from the above:
Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

