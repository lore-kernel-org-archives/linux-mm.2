Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16779CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09ED56B0005; Wed, 27 May 2026 07:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0502F6B008A; Wed, 27 May 2026 07:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E807D6B0096; Wed, 27 May 2026 07:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D65136B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:23:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 793778FE74
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:23:37 +0000 (UTC)
X-FDA: 84812964474.01.DB96BB9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7BA6D40012
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:23:35 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cQkSSB30;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EkGTAOuz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cQkSSB30;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EkGTAOuz;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779881015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQymIob/bHvpmY35om5H+zfV6sgTV20OvOeUiMVaTTk=;
	b=WFdToQPTY21V+h26iWUDWnvcTAM7Iki+mrtCJ0yOWAOcDbxKdFNxSjWjWKIIw//KbgegcI
	3Wx0f+PnjADchyIgI0L6F4TKlppEouk3mbIPU1s+TIm4M+7L1dvemEJO0fw78kjt6WqP7i
	1JPnUbpXifa6YCWfFQkmUT6iGc5IBqQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cQkSSB30;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EkGTAOuz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=cQkSSB30;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=EkGTAOuz;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779881015; a=rsa-sha256;
	cv=none;
	b=t1znnY0Q8WLI0sPfdkQqfo2j6mBCQ0JltrLX/RIF8KvEQrDHH5/xy6s97BnI/MUwUlRG7G
	toQlvh/rNY1MyHkQ3vUZ32+SIIqC6MCIzWHgx8FB4FF+to9GmGIjI+g58dUUSjEMNSAnqy
	Sn5XVMMA46zD/MgzirgkJrMaHB8ERIE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2672366E9B;
	Wed, 27 May 2026 11:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779881014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQymIob/bHvpmY35om5H+zfV6sgTV20OvOeUiMVaTTk=;
	b=cQkSSB30Nn9V8SWFWhuaBkFN8vkGwfyFfnbmm84+ElI3TpFKPan28dYs7HrdQS7kU2zW9o
	XJomGoFsh6jLDIQwypT1E3uIZbfEXWMR735yMUJACGYOB2HEIDJJ48HXtgmwrgCQeQtoOD
	VZiWcXyE9aGUyvRWpjmhi2iO24udAbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779881014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQymIob/bHvpmY35om5H+zfV6sgTV20OvOeUiMVaTTk=;
	b=EkGTAOuzgsIN+8uGREd/BK/l/mWwjnKQGEjhMTWE3VG1spUBZIxGhruFkqvAovkW46ERdd
	E1AtWfcQlt6z9vDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779881014; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQymIob/bHvpmY35om5H+zfV6sgTV20OvOeUiMVaTTk=;
	b=cQkSSB30Nn9V8SWFWhuaBkFN8vkGwfyFfnbmm84+ElI3TpFKPan28dYs7HrdQS7kU2zW9o
	XJomGoFsh6jLDIQwypT1E3uIZbfEXWMR735yMUJACGYOB2HEIDJJ48HXtgmwrgCQeQtoOD
	VZiWcXyE9aGUyvRWpjmhi2iO24udAbk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779881014;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQymIob/bHvpmY35om5H+zfV6sgTV20OvOeUiMVaTTk=;
	b=EkGTAOuzgsIN+8uGREd/BK/l/mWwjnKQGEjhMTWE3VG1spUBZIxGhruFkqvAovkW46ERdd
	E1AtWfcQlt6z9vDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8E8755A7E0;
	Wed, 27 May 2026 11:23:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Xr8IHzLUFmpCJQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 27 May 2026 11:23:30 +0000
Date: Wed, 27 May 2026 12:23:28 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: tao <tao.wangtao@honor.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, ljs@kernel.org, hpa@zytor.com, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	jack@suse.cz, riel@surriel.com, harry@kernel.org, jannh@google.com, 
	jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, xu.xin16@zte.com.cn, 
	chengming.zhou@linux.dev, nao.horiguchi@gmail.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 21cnbao@gmail.com, 
	jparsana@google.com, dvander@google.com, zhangji1@honor.com, wangzicheng@honor.com
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <ahbSwczOpsBKby7o@pedro-suse>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527110147.17815-1-tao.wangtao@honor.com>
X-Stat-Signature: 3g49uo8mh5jhad9q8u8a7fqe778ah6ed
X-Rspamd-Queue-Id: 7BA6D40012
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779881015-973950
X-HE-Meta: U2FsdGVkX1+ijby6/RIVLoTnooJ40NqjasZHqMLS8MW2fNlyfzZNoeNFyw+8kW5vzPGR2Hhrh9w17xudVQlZbbRbFciGGGmOO71YBnlBZZDKIGCPr337u9WVkYXgI2vKEt6JTGl8ejaMREcgBLvcElxjSnODPuF0t2517zwrJCLn0h5m1JoJH7wgMkoduifdhsNLxO/+K3BuWr92C1a8w7f2AJApr1tr6HeCUqWNtFEnjtlBi43FwXNsapu3n2nLs80JKOQCBnwZ6/9+fQqAXl2lIRhQbBSarlVoVGdkflDnPvlsIYmfEu2TDqmK69xGAf+UQW9cvWFKlTDAJwsfQ9IgpTeQ+0pduLpQgweqaNW2v4zUv6tOPmow411GLRfD2Fvpg2zyXKpR7tPqBiri8w+BiZ9CLLEFOj05OWu3Y5M/PhdSHMkJ4y0pbAPvffLzPYcuWGi9oIvKH7Lt9cSbo44/GS0tSyon6HDFyQPt3fEgBw70bxmDPvmTbexBVO0LPd9EXRFZNhrobshPbQmkyyCfwpa+kuCg0Pjm++s/GpWLb/EleMhCof6A1eJqoTUf0X0CKgo89cPmdh3AvlUTP/IFsusyOKaMsizQngSZm3PWA76jGTDaeOknjD+c0Vt9CeWJBT4YvODK63DihwWSLuepuSI8sClG6iLB2MBnra2TxUThQCA+42K0ViUeNRUV4Uo4Hx6dQPF3CaGygr3QrcuqdBlTgqGx5dWfm1D1YLfjms/kKLl4LLkDXkKE4RwMqBnxPoPuec6asnRW9KzuNVBe5eL6y9R4FQqtsc+STipIGquZzgGn/G3P0JLfWHGfSxOgLJzoG6grm+G1DXY5njTPE3VhCw5fidGsuCrWwjutYUMjM8ncCL2Oi0slvVwb1jDZSpnBRtrQ4HkjSx2ZiFqWigwSRgmSR0yqf8WtjqsMpp1oM7hf2HpmGEDrg808n279GnmJeb2aQVbovYO
 CKHy3nsU
 ChpLdnh/oqi1CEceqlzKFJCiaKXDD5SbXUsfsQPROPgCePbRtGNJC9lZl8Io501YQMKDCORgjV1oNxGDEe9OvE2ACDZ8xrPahXCMAutMJ0dSz4OIeXEEMq6s/WENafvstQjPzMiWDRBnxmCy7y/KUHTvmZKrV1lmaYu1DPeaFhUPZ6TJ8JcxcMCjzCyGNY+kgFAWAGVQ4XgGjXgUtfqUVEnHC67dtgbA0oHAMsuYP24cN4//wMlcOHbqfAggwc7nx6BSu6n7x2nVFhVapZiHkl2lKR4svLIoIa1JxpDqQ8oVs2K/qrLlgHu6ZVJhvc/yUR+p+GzrXiv1VpmsC4X2m6IuwVbyPGbYcvWZ916y1yPsbu8kAeDeLEU7kLyWvz/6evAziOe89Bm9voavUXgVQ8KMGWF+ZhD1zdHA/P/R68FFQnfVl2tdRQTbtdyQ7zJKdhPqe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 07:01:32PM +0800, tao wrote:
> TL;DR
> -----
> 
> This series introduces ANON_VMA_LAZY, which defers anon_vma creation
> until it is actually required.
> 
> - anon_vma memory reduced by ~92-97%, anon_vma_chain reduced by ~50-57%  
> - rmap operations on ANON_VMA_LAZY VMAs do not require anon_vma locking
> 
> Background
> ----------
> 
> Currently anon_vma structures are created eagerly when anonymous VMAs
> are initialized. However, many VMAs never participate in fork or rmap

This is not true, they are created on fault + a few other places.

> operations that require anon_vma chains, so the allocated anon_vma and
> anon_vma_chain objects are often unnecessary.
> 
> Design overview
> ---------------
> 
> ANON_VMA_LAZY defers anon_vma allocation until it is actually needed
> (for example during fork). VMAs that never participate in sharing can
> avoid creating anon_vma structures entirely.
> 
> Before an anon_vma exists, rmap operations rely directly on VMA
> information, so no anon_vma locking is required. An anon_vma is created
> and linked only when sharing semantics are required.
> 
> This series introduces anon_rmap helpers to make rmap less dependent on
> direct anon_vma access. It also introduces anon_vma_tree_t as a container
> to support both the lazy and the existing anon_vma layouts.
> 
> Once a VMA becomes associated with an anon_vma, the normal behavior
> remains unchanged.
> 
> Memory impact
> -------------
> 
> Preliminary measurements show significant reductions in anon_vma-related
> slab allocations.
> 
> After boot:
> 
> Object            | Before (active KB) | After (active KB) | Change
> vm_area_struct    | 117035             | 118176            | +1.0%
> anon_vma_chain    | 18865.8            | 8112.06           | -57.0%
> anon_vma          | 20426.4            | 613.75            | -97.0%
> 
> After launching 24 apps:
> 
> Object            | Before (active KB) | After (active KB) | Change
> vm_area_struct    | 196873             | 197345            | +0.2%
> anon_vma_chain    | 31477.1            | 15576.8           | -50.5%
> anon_vma          | 33280              | 2648.12           | -92.0%
> 
> Simple fork microbenchmarks also show a slight improvement in fork
> performance, since child VMAs do not need to allocate anon_vma
> structures during fork.
> 
> Feedback and suggestions are welcome.

I'm afraid, per previous discussions[1], that no one is really willing to
maintain extra complexity for the current state of anon rmap and anon vmas.
Sorry :/

Also, please don't send series this large without previous discussion and
_at least_ an RFC tag.

[1] https://lore.kernel.org/all/aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local/

-- 
Pedro

