Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FE19C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:32:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534B16B00D0; Tue, 30 Jun 2026 12:32:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E46D6B00D2; Tue, 30 Jun 2026 12:32:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387886B00D3; Tue, 30 Jun 2026 12:32:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06C6A6B00D0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:32:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71FC9120592
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:32:13 +0000 (UTC)
X-FDA: 84937121346.20.A2EF603
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4DAD9180016
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:32:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oln6Gp+a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K6CUKJRx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oln6Gp+a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K6CUKJRx;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837131;
	b=r6hoEsjrq+ahWdiyaCafRkXWD0Wz0tURFwCBcL5A5TNxa1o4Hs9mAC47P7w4t9FwZwn2CY
	zbu1WR477amUfJgMTgTCij41V/lYqYrl43Abz2LnPkLvqErfEjWC/2JHHSYPT75hCIb3QU
	Q+sPxhCnPKluyVwqd2JcHjXParkkbC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bj46aHd3P0qP06KPPng/jA7xnMpRZKdrlFaZk5YHEUI=;
	b=cRAGv+0JyRQCAI7w8YvZzAG9oLjt5dhqan9j+eAniHMwY3nzNXAuhaUcGhh7kKGoq2vMur
	URZ1dh/vV8F2+/QP2BoLjpyYuy9aoHwxg/wZ6LcO0Js3KO7cj3yAm4igVwNEJobQkwbN5T
	hBLXNQRcF4FUj1N5byZiBKcvCwF+7s0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oln6Gp+a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K6CUKJRx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oln6Gp+a;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K6CUKJRx;
	spf=pass (imf16.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1EAD071583;
	Tue, 30 Jun 2026 16:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bj46aHd3P0qP06KPPng/jA7xnMpRZKdrlFaZk5YHEUI=;
	b=oln6Gp+aZqEobfrbzku3yTI5LCsxkNY8CGU+44JjCaJ6YrK5aoDytJfuOdF42/DkFL0oqf
	+YJ6aGJ7A+InPvaWE3SaEAscugLUHr6UwmbeHzjX9sqqGmUgtOf35OjYiotEkSd9rXGyvd
	/AYl53jRW5BNSqyLj1+svAGG5barEag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bj46aHd3P0qP06KPPng/jA7xnMpRZKdrlFaZk5YHEUI=;
	b=K6CUKJRxqfsSaluzpcBH1ATyfDref91sgi1JY9lMK3i3ebN+kNzleEv1r+ctX8m1sl67BO
	LnuXVEjWKJAX9HCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782837130; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bj46aHd3P0qP06KPPng/jA7xnMpRZKdrlFaZk5YHEUI=;
	b=oln6Gp+aZqEobfrbzku3yTI5LCsxkNY8CGU+44JjCaJ6YrK5aoDytJfuOdF42/DkFL0oqf
	+YJ6aGJ7A+InPvaWE3SaEAscugLUHr6UwmbeHzjX9sqqGmUgtOf35OjYiotEkSd9rXGyvd
	/AYl53jRW5BNSqyLj1+svAGG5barEag=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782837130;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bj46aHd3P0qP06KPPng/jA7xnMpRZKdrlFaZk5YHEUI=;
	b=K6CUKJRxqfsSaluzpcBH1ATyfDref91sgi1JY9lMK3i3ebN+kNzleEv1r+ctX8m1sl67BO
	LnuXVEjWKJAX9HCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 91BCC779A8;
	Tue, 30 Jun 2026 16:32:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 91GlH4XvQ2qregAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:32:05 +0000
Date: Tue, 30 Jun 2026 17:32:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Lucas Stach <l.stach@pengutronix.de>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
	Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
	Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov <lumag@kernel.org>, 
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, Thierry Reding <thierry.reding@kernel.org>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Jonathan Hunter <jonathanh@nvidia.com>, 
	Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org, 
	iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, damon@lists.linux.dev, 
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akPvI4r1rnxxSbzW@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
X-Rspamd-Queue-Id: 4DAD9180016
X-Stat-Signature: qq8qpiif7t3a8hjo9trtryighoifi7cx
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782837131-741183
X-HE-Meta: U2FsdGVkX18/y/WygqGuecCejsGgfPxXU4NknjH+IZrs1GGU2Z9Yejq+okZ67YVoFBM01EH/uDZdak95R9Ey3Kc/iqf8BVUXd6MI51Buyt5544ghZ9rqaqUinrGcXsmCQDn/JRsNZi9YKHCvsG9Pw3esFBkEeMf9G17Gv1BlGRVvnumDzbG585K9s4lJKJe9Gt5JXsV1lO5PE+AxxDihwQzZYi/ihn6gHGKl2VKy/ihSPur/vY3YGwxW0c8K4VrQjBEKA/jmF08PIMyWooHJ2enKCnQ2gI67TPXpG7igKrFrVtwowC+QWNuodagNcN2167b5MiTS4lCNj3ruDl4BSfLKOhaU810AEt11MwR8QSureCWuJmD6usata/SVKDMLSGVhiyTt56h9zbMbeiTj/4h1X+Tr9XbSJd2Heq3+8L/QcrwZuK1VJGhpyWaXBfcKLlld5TXD/dan8XmrOwPDZSNwO66kS6Jot9j3Rm413N2HMgla+CDoRfQONt4qudlg2C7hMg7P20AAmJeVWxZwCxBmCOcHpa47u9vpEDXyu17vKkfhp5SBY0PHLrP1w8eHExS5GAiAxCgDDpmrxHoic65nd45DPf2S5/rR0+L+Fuge9y7qcNLtMNirOR3HsQtRuZ6yiRjY29a1H3KSGQx4xY1H4oVpLYQukS+gDfB7fDtSHWvndg9kAJ7012XG/Ccuu3cXX3/VtjY+ulJ5nR4k40k5lRaMk+0xxR2XLV9BBlnzBRFrvhIiEdHCeBQwU48KCnL/0i5vIDzz6t4ovGWokOe17G+PsZE8lkAQUtNHeTWTJqYl5u/RSER4JcIO7OUrGCXG8zCOjg/qQLQoFpg1iU14En4knx/C5YVWTZjT/59ZUAx85rzCbfRPkiqLWXef4RUL2nwO9ZnzN7u4FvQiclF0Dh/j8OqQx65EVqIbEhf++aymoEyT9WFKb18ilbsIWrdOE/NpBkFA7y/zbK4
 PtEs5IO+
 I2ahtHc85UgNjXXiWvNeMdLVgbP1bnuqWS4nR5hcBvkvY8mlJWXuDxsAT9xhjY0oTk3x5nd6SYySkaXbkr0XLCB6uJHpSC+hspDWX1xGYUVxjfVJcgQEzHBY0GLNjE9P5B9YSUR3GQ9x/AjY1FnImI4/+2YCn7UeAn4CehDN/y/cn6qOV8OyDyNK94bWLeS/5+O73ZIrMRNUyexsYYUW6Nve5RqFMfrI66eQhmUVldmd0jA8ztlDFbk+VEidYiwAmWr40qB0HNCHaQWR4nwS2LRxirYsvKeoEK8SDndEp31AREq5Of+kjXSuEJoYGC0TFdFGejRoyzCDo6KVYV/UQ/BF640ynInw1/OaUs07IrTfUMNeH06P8VRDE/QdoQ0IxOCtFcDRYrVZJUHPZUddwqPZcmMiYNFyJSFm/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> Similar to what we did with mapping_interval_tree*(), let's declare
> anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> 
> In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> anon_vma and the functions can figure this out themselves.
> 
> Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> to 'pgoff_last' to make clear what is being passed.
> 
> Finally express page offsets in terms of pgoff_t to be consistent.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Yay!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

I have a vaguely similar comment as for the file part (names could be
simpler, doesn't really matter whether it's an interval tree or possibly
even a tree), but I care less strongly about anon rmap :)

-- 
Pedro

