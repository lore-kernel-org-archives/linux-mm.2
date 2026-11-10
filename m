Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A5360A260E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=j6U0B5x4;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SerslcNO;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Ye6SrqMU;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=nupH0Gw0
Received: by kanga.kvack.org (Postfix)
	id 72EB96B05C0; Tue, 10 Nov 2026 06:25:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DDEF6B05C1; Tue, 10 Nov 2026 06:25:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7E06B05C3; Tue, 10 Nov 2026 06:25:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 195D16B05C0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 06:25:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A341CA0521
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:19 +0000 (UTC)
X-FDA: 85418978358.01.8697830
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7896D180002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:25:17 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j6U0B5x4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SerslcNO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ye6SrqMU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nupH0Gw0;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794309917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuudWVgrS3U0W2Ftt+AqT6mImlT0GC7ZxcnFi16YT/M=;
	b=riTc2Bkh65XO2jV45jLKyMcJ4p5sz8j8FpLN3S2Mdth6hT9JMGZ0Ru4ze/zF2HWbqOqnCW
	Ibk9HH0txCI715tDHOS7FQR+smzV+C/mf4dAC6LtEMD026ZEAALqiBzKMPiG91hyStaFWT
	MlZs1ANs7sUyj0xI4Q7tK89ISP8OXcw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=j6U0B5x4;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SerslcNO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ye6SrqMU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nupH0Gw0;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794309917;
	b=tefquTmi77oInuYEBnAUClwoqlKnzUUD1BoFMk7TZGiXxQFthr734pX7C1tKIq4rXV5Cgu
	XWZGKcRnqGYXy4VUFgqq0npBfD67HVdGosVdz/q5Oft0FZYpm+TNrVMj5NNJW4VLLAeDaH
	iVI7/UCrFFBA8jaiPEkMSLl4csRPCd0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E399C1F7D9;
	Tue, 10 Nov 2026 11:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794309916; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuudWVgrS3U0W2Ftt+AqT6mImlT0GC7ZxcnFi16YT/M=;
	b=j6U0B5x4LMEF2SqldUZ6WxGzciuHvpc4XKOQfSwA0jlM+Ngq3gqlLwdx0U7k99r6K1YgTx
	jDmT0ToxeqhQ5MhnFOTxqMLupcalIlGwySTIkUwm9S557ue/oomLSn8W6Z0VO0caP5lR57
	kcQBQfIAs3Lv+LELjQKVWOABCxQ6BS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794309916;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuudWVgrS3U0W2Ftt+AqT6mImlT0GC7ZxcnFi16YT/M=;
	b=SerslcNOHfjDDAH8G69EmoWXx/SdtWHShxQ5iGsseiz2FpcDxcMWA3d0+oDrgcHlVxole5
	MYYCbgJQAtW9HyBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794309915; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuudWVgrS3U0W2Ftt+AqT6mImlT0GC7ZxcnFi16YT/M=;
	b=Ye6SrqMULx+MGMKXtvnn8CDcR/nANw6pzsd6c2htNEZ03gV1WLqnJFR8TysAS0B5A6nmSr
	GBiUvW2s8no48CwxY6mZXOIFpq8+67DMSjRlgp5LpPPkiOkmPUFdXP2ZFudpX2MuM2hy8c
	m/I6EwHvb46J/dWFL2nrg7NgSdmPmaU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794309915;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuudWVgrS3U0W2Ftt+AqT6mImlT0GC7ZxcnFi16YT/M=;
	b=nupH0Gw0To6sosww78CwUKyfabAeLUUaTu42aBQqe2aQBRcBHwT/toT4a67En2U2WzLtVZ
	K9u+O/q/RHoKfYDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C0A6B13479;
	Tue, 10 Nov 2026 11:25:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fZNmIhr/8mpCZQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 10 Nov 2026 11:25:14 +0000
Date: Tue, 10 Nov 2026 11:25:13 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Seunghyun An <san55@wisc.edu>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Jann Horn <jannh@google.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Suren Baghdasaryan <surenb@google.com>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/rmap: use vm_pgoff for anonymous VMAs in
 linear_anon_page_index()
Message-ID: <avL5C_w-wo6bJJTj@pedro-suse.tail5790ac.ts.net>
References: <20261110000002.1834454-1-san55@wisc.edu>
 <20261110000002.1834454-2-san55@wisc.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110000002.1834454-2-san55@wisc.edu>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Stat-Signature: ztegobpndismw8kosibemowmskshiore
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7896D180002
X-HE-Tag: 1794309917-254170
X-HE-Meta: U2FsdGVkX18pd9yBizYfohltGhUwBd54lWPcsOK4Dar5Gp6e0ASR0m0rtDwOUMYNx+p7xLbzg0V/T/uOsLnVEac/5MUZ1BQ7hdVzSZo7crC5kWev9IrD5PxmjxL2b/wHc/BT8glwRMUPxXqZtCYG3vrW1bXidfRdIuomtnTqVTkZkDAH3RmqfXSHcEAJLZHFVWTmZ6qPzKPig7B2gckEv7P1n6Rv0OsU48Mv7FQSnYd+3Kejt6Kkb4wZry+3mRyPm1F3YDLKQnUGWa+4wIlOZan5oWk6SCwP2HCJoXU9kTehBJN1YaXnIiPoLX+cRPLn29rCnTUFiWcp39/DrO2iHnk5dQv/yr5q33G2aCOFRQ09tKszG877Gq3wEo84IklgeyGjMQI/8nfqOCC5l5ERPY3rMHaVZb8RYUkCGDM4lZc/gybze+FqNs3Kb/t0+lQP3shExj/5EiAwguHAZh6Bed2sMj2TLa/J1A1SJ8986z5E0jqmpsSbRjXySzB0hLQuK5CLuv2m1FVk2lZmNSRtd3XZkz+iIrRfAA8ba+fmFJCVUr20CyfeUUPpRF+4CZTd7DHL/rKNJ43fi8NtReMK+xV+H8f74NbM9TY00woo/vQdYeYl/UgG6mjte6BPpnbLX9YZol8Yr/Zpv/q36Ya+aLAKvEaxOZLynO18Fap+qmogAaqh3xh5qOhafgAJPE8Oc+E4MVwMkFqDMnsVPo9K2EqRNvfUbPUiMu0F8ZQPqNweItTyZSZaUHYCgpbi3B1jyZqHKHV9oiXSb0QxRWhauVyi82hmUY4bRRDs08O1qyTfPOXgYQRMDu8rs7hkgPoF9UluZPNnYxh86ZgrhiZ3Z+/J7oLkf/Nf4U5ETC/iO2zHY0El4CcFo++Y1pfHdgR3RvoDOhBbYKYaNYUkg63jmeO2A/tfm4prGw2BAvYnsKH6Qf5RZ3ahfVnVdiJ8b+JEZi7G1lKrRP6Ke2IKcI7
 1sdtDXHz
 KCdZW4UJ5btniHovrMdQOSrSibGoBfFIYUXxYaKnV/Ohtjx2ghgqSAEnWj5YhJsVJQN97OFrNNRJaiUazG1wRxd6W1+akZCM4kx1Izzy7bRSdDbyk/DkGguBcUCnxh6wFYtJBMCPT4T7aM3a0eanG8F17xy2oUZ5+hD40AP9rgWhuimaMcqOj6DVSg49krL/3cpEggC5o9jjs5r32/1iVK2Fa35FdiNBf4PKGNzTzoqB8uk/SUZKyUhasGeCiRun9ifVtjFcJgyradFjUfv+C9pDYsFYQPe3SkAFTqx7Q2r2VVuuYVykvveAfrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 06:00:01PM -0600, Seunghyun An wrote:
> __vm_anon_pgoff_hi sits right after vm_refcnt in the vm_refcnt
> cacheline. Since commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track
> MAP_PRIVATE file-backed anon folios"), which made anon rmap use it,
> __folio_set_anon() reads it on every new anonymous folio, i.e. once per
> fault that maps a new anonymous page, between vma_start_read() and
> vma_end_read().
> 
> When several threads fault on the same VMA, the other CPUs keep writing
> vm_refcnt from vma_start_read()/vma_end_read(), so this read often
> misses and pulls the line over. The extra load can force a coherence
> transfer and makes the following vm_refcnt updates more expensive.
> 
> For anonymous VMAs the anonymous page offset is always equal to vm_pgoff
> (linear_anon_page_index() already asserts this under CONFIG_DEBUG_VM;
> it holds for MAP_PRIVATE /dev/zero too since commit e59c9a971a9f
> ("mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous")),
> so compute the index from vm_pgoff as before. That brings back the
> pre-series behaviour for the hot path; MAP_PRIVATE file-backed VMAs still
> read the split field. Keep the assertion, the other way round.
> 
> Moving __vm_anon_pgoff_hi out of the line does not work without growing
> vm_area_struct. With e.g. CONFIG_ANON_VMA_NAME=y the struct is exactly
> 192 bytes, cachelines 0 and 1 have no hole, and the only 4-byte fields
> that could fill the slot next to vm_refcnt are vm_lock_seq and the lo/hi
> halves. vm_lock_seq is read before vm_refcnt is taken in vma_start_read(),
> so it would just move the miss.
> 

I trust Lorenzo knows more about his plans to use anon_pgoff than I do,
so I'll let him reply. A comment though:

> Measured on an AMD EPYC 9634 (84 cores, 12 CCDs, CONFIG_DEBUG_VM=n), on
> mainline after v7.4-rc1 (the base of this series). Threads share one
> anonymous VMA, each faults its own slice and zaps it with MADV_DONTNEED;
> faults/s, median of 3:
> 
>   CPUs                      base      patched
>   1 CCD,   7 threads        2.360M    2.369M   +0.4%
>   7 CCDs,  1 thread each    1.738M    1.982M  +14.0%

This is not particularly surprising. CCDs have their own L3 cache. I'm not
surprised the coherency penalty is much higher cross-CCD.

-- 
Pedro

