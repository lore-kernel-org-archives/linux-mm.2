Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EC60C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4276B00A8; Tue, 30 Jun 2026 12:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284CC6B00A9; Tue, 30 Jun 2026 12:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19C016B00AC; Tue, 30 Jun 2026 12:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E044E6B00A8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:22:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 739621C709E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:22:44 +0000 (UTC)
X-FDA: 84937097448.25.605265B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5317E40004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:22:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xanAlxAE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UBfuerEf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oHFP4ENY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0lpiglbc;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782836562;
	b=aDmc7yOCFanNzytY6GrdQ0GEmUD+22lwldStQK+VkM+GOPjKeT5zzeZaTKnmIEfp+ph0rv
	MVAPHViy+aOfUkbvnB/ey/gyJDFduYRw/vatqYl5sE3dljrrsNfUIWUl0LxbI2/FdKo7ES
	+zipeY4apKALkYxKNod1tihUCKl8im8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782836562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3P5pjkD1/OgRERI6ED7nD9LZ5+AzRSareSV95urOYd8=;
	b=cubxunENoYs5gFWGLpgJe7iwe6qgR1j2Rpu3erEnMDT7U9eSexBsuToEab+2/6yR9jSfXm
	HTpR/HcqXLHgRnc8hZyB69n3X/CRPbz+OcP67F+6PBbY4MFpgpbNQfD4TeBImtodGPNKDe
	2N/A2aKQRBRGeUEkSpy8ogoC7lpPyl0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xanAlxAE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UBfuerEf;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oHFP4ENY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0lpiglbc;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB92C7369F;
	Tue, 30 Jun 2026 16:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3P5pjkD1/OgRERI6ED7nD9LZ5+AzRSareSV95urOYd8=;
	b=xanAlxAE0PhfSU+Gu+saEOo8LI+pL5rVWt0WeycHwueC8nEl+a6rF325rrXaj7BvWCuvW7
	oXZh9tElAgFdqir6pGeDn4GavPtrRL2IzPro/eMuBZ/Ehv3reOi/Q/U134jdV0x/Mfh4pu
	UqotFk+XaMohzfZ0HckE7IKFH8Mw63Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836561;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3P5pjkD1/OgRERI6ED7nD9LZ5+AzRSareSV95urOYd8=;
	b=UBfuerEfwAZrYlBwdz4DQ6Tpt8wOyPmXe2+W8i+4kVtk2x+G9sn8OdN+U1A2eDIork/Z2B
	hr0mqJXq+7vMDPCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782836560; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3P5pjkD1/OgRERI6ED7nD9LZ5+AzRSareSV95urOYd8=;
	b=oHFP4ENYNv7g9kLl6zkw6zv73BimWy1yhufP/7bGIu05NSQrEeT55M4BMy0EHq1qx3AlhZ
	MaHL2S6tHFhC1z69cbiQQOTozoWcUwQjQcy8/X1/qTXhXT0zUzQOLgN5pQ9OnwCHUX0HsK
	B5O+uVKIhghBy7u11eTWdVIdWYBPxoA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782836560;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3P5pjkD1/OgRERI6ED7nD9LZ5+AzRSareSV95urOYd8=;
	b=0lpiglbc+8uxUKdL0rSvsTa4T5PxU5MQ6R/5AOHsIORSWnpYHi6oRKpABxz1ssGvdgrcil
	RSDYwUAR1H5Lp4Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1EED9779A8;
	Tue, 30 Jun 2026 16:22:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W4P+A0ztQ2oJcQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 16:22:36 +0000
Date: Tue, 30 Jun 2026 17:22:34 +0100
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
Subject: Re: [PATCH 07/30] mm/rmap: elide unnecessary static inline's in
 interval_tree.c
Message-ID: <akPs-NFWs5WE3GIq@pedro-suse.lan>
References: <cover.1782735110.git.ljs@kernel.org>
 <ed5fd5358382217a92f0a6afddcfaa030c933055.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ed5fd5358382217a92f0a6afddcfaa030c933055.1782735110.git.ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5317E40004
X-Stat-Signature: nzjcso3wyzu686r1mnxb5drhtjo7wces
X-HE-Tag: 1782836562-858932
X-HE-Meta: U2FsdGVkX1/GfSgM77B66F4IVfSmEX5qYaXgsjPG0bpu2wNXiCksLxv/auMVUamvUFvorLIuGLMyr+96w3rNZ6+4cWHrmL6LusEb/yfGvdxACOUFXSVkS+avX6dTkZCRbkCCXdFVxiXDhWWrtno6Fp19JrNlXbe1vNBgYV9a7FbynM3WcCyGicrH4VVDFPrRXW0mF7qqJ2JAmcAgtMbFyD9O1KWah/UmvPrVEPQ/mZi54qVb+Si8y8au2sA1o9U5EuICRr27wgUIk2xtrWtYnPXMkkl653RlBvQ8CFPK7Qo2tSQ89wagBw/Q+vq8E4nF6i7t3hTuyU/vLT55Zsh5t1vddZYEieJg14ZgiYOACcBrZ8AgA9fd+XUMHqVrZaCMYbzAca27stN+Dv7BIf66b1iPgSRe6gDYXFYeV0cdHQxnjv38A/Shvi66BjpLxrWzr1F93/miAQj71/psZz3ob19R549EJwKBzzqInBMC+WJB6/dMnrr/Csjge+3StLeQBi2o/He2x2j7yDKJqHlLRwnHfaGxI21Le3uja0W7J+ZXYccNBCtMbrHvHc5OwtQPOyIvpXjqBGmQH3qSTG/1q/ggrl3vYJK9AgokVnDL6BXsMtN3kH3ypBHatysl/pklKk05CSzrZ3TP3n8w5hMXVXv116UcS+q8iX/0VZDhur1EVMok7WWCeZMH2QDx//c9H6jL1qpAyPOP5gpV3mqauXvZxDlaVEksZjPN2dPAl87rGm/gig3yizKNnPKgzpI1u9BkxVKBs2YvpVRZWWKoPfC2ASetkIb00PDVeAVLbib9wzdOMssuSYJlwXdY49xoFxjfklBH6kj5G+KMAhtU3lr9TLRmGu9wKDFVCwtxJd7NIqJ9R58s4i+Mnz8ywYvGNdRUv18AD+qBmJpy6zdTYLSup981L9tSeSdx0VhXD+iOpKZH35j9pYGBmrMrrPkE2Ilw79JuKWTYyJUoacr
 Jw65s64t
 GZC4VB/Ng8OwPgwQJAQdt+rTbKnipBu/q+gIZtzopOwBO9GqCiL6YDCKQjO+IZFNSbGy+l5El8g0LVkl+l8VHmivRYI+htLxqXzMSfHyTn8qEgGxQqpUqsKxrZbYJGQ/jlzHfoppnche8bUzHWNgjtgyJwI9tQ5NBEQd8WuPxFqOAXqBZLPG6MStnA3M7phB6SF9V9MaJgmUfXJoO//dFWAN1g2Gu4hK3SfA7UehXFaHJ4KBII51xPlLxeY5/G97QyrYX57ZfnjSjgZIHQImXfEfsB4FR8EdZK9jg30Rue2aqh7tWT6QYN43WNpH9Aci3n4vf2kT1T6cg/ySNHlStYhk3so9lmJYSpemWt2++BK3N4BavalGXC4zrkBHuTDcmsw9Iyr0mTPt87dw1TMLtdjCd8tiFOZgYJUb5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:23:18PM +0100, Lorenzo Stoakes wrote:
> It's not necessary to declare these functions static inline as they are
> contained within a single compilation unit.

FWIW I don't think it's technically strictly equivalent (I have a vague
memory of inline lightly suggesting inlining a function to GCC, because of
compat reasons). Anyway, doesn't really matter, practically any static
function gets inlined with -O2 anyway.

> 
> This makes the anonymous interval tree code consistent with the newly
> updated file-backed interval tree code.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

