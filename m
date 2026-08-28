Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33CCBC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30A186B0088; Fri, 28 Aug 2026 05:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26BDA6B008A; Fri, 28 Aug 2026 05:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5B96B008C; Fri, 28 Aug 2026 05:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF0BB6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:29:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B90580291
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:29:27 +0000 (UTC)
X-FDA: 85150155174.17.59088B4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 611EE40002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:29:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O4FYA4Rb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=O+F89elZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gk+e5jRH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="1koz1/ze";
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787909365;
	b=Z8aYyj0f4NE3zOflQqEZ4lmqV/7zMCtesCALYv0bE5tET9mBSPelT13u7KazOGsYikPuWt
	m8gbBakStZxl6tBEod3H2juNaKpVWHLUJGvE5ysKEakBXb1y4vsmGsiA2/b0cr5gYnxeV1
	O/XMz0m+PeawiBxtZtZ5e8ceLlxg9uU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=O4FYA4Rb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=O+F89elZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gk+e5jRH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="1koz1/ze";
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787909365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R0+yG+1bN20RSdMl6UCMwOfEUTtxXoxF8Axb3Ve+/jI=;
	b=MWXrenvjYbCxWqvLv7wPYItRo68TnEXki2yS4CNlASna196IqLaCoCBPh93x5XHvmhSKvk
	enhAdatcaBkkO1fZ0KFLiCzt+7YEgrKSIumO+QG4n9JN8gBwg6tpZ3SkVgRKBz6SNLl8Pv
	JdVixSB1biga6dXUG0qDF5JQgI+9pWM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9EA21FB62;
	Fri, 28 Aug 2026 09:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787909359; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R0+yG+1bN20RSdMl6UCMwOfEUTtxXoxF8Axb3Ve+/jI=;
	b=O4FYA4RbVJixP2zJBddcAkrp/ewWu0qU4f/QLJkPIQfOIBoMfb2Nvhk8gtN8I63OBy/nP5
	r345r02e7XaPDd8y8a9V7R9FXn/EnTQO83eF7Mqkiu2RLmDVgmcfG+WRRhma6Jl3d6xtRp
	Hq6m2EIE4lWrIPzxhrgchXpVsYm9y+I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787909359;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R0+yG+1bN20RSdMl6UCMwOfEUTtxXoxF8Axb3Ve+/jI=;
	b=O+F89elZiROAeuOGjX1wcKvutymEHMqY15NgQsCKisaoAg+QuapHtyAuJljMpCtcKxrE13
	67RaqiR4o2/qP/Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787909355; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R0+yG+1bN20RSdMl6UCMwOfEUTtxXoxF8Axb3Ve+/jI=;
	b=gk+e5jRHYxvSE0b9WE+tGn2kFt5rvxTZt7ByFcTJGa9p/Dk3Ovf3KMyc+xiPYLwJpUndPx
	9vzqd0QAZLbfitdzUvyrs3lxBtI22goXDS8hyksHyt51PE3JBTWopUXFCw7N6MDDU9Hqlo
	h3g/hucmLmtkK6F3lC9k+0jUkwwmj0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787909355;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R0+yG+1bN20RSdMl6UCMwOfEUTtxXoxF8Axb3Ve+/jI=;
	b=1koz1/zeBsS2C4mZty+80W9OUVX9cI5asaX8nmkWjTc8uQsAjl6YehNx2xyRxlKwWIcj8E
	jsRB706U2x5nlvAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DCF3813515;
	Fri, 28 Aug 2026 09:29:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vc+nMupUkWoEeQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 28 Aug 2026 09:29:14 +0000
Date: Fri, 28 Aug 2026 10:29:13 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Li Xinhai <lixinhai.lxh@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, syzbot+f12658786a4153df5113@syzkaller.appspotmail.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for
 MREMAP_DONTUNMAP
Message-ID: <apFUzpx6zwAjhvC2@pedro-suse.lan>
References: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 611EE40002
X-Stat-Signature: tgt3tisig5ambotkaj363aspuwzj7ki6
X-Rspam-User: 
X-HE-Tag: 1787909365-7076
X-HE-Meta: U2FsdGVkX18B317tqc2Rd1qglb6t4By/CT7NH7I6Yzd+SqQQZwMji1J5QEhkvSgJTsd2ZUsBsK6MHJ8ZIxYzj3x3oUtu/+QuGuLWEgxOjuXiznhw3m8qZyvQOfRm/ofBJXWo2Ps/TRLnsE5JZ5i9MG+ivNu5mc8bArtcFM2GXfSp+ALMVMafa6NDa6E3anwKGvqYr5+iXem/SVuVUKg04YQwcqiDeXKuJaCFhC1vzM4V/qdes+uLxx+hRIEu6rp25cfQNCGbiBdzXhxR9o6bIIvQpTIjm12Dh0iFmrsA2wVhi/UTPTNuqbVMF6xzyOek0hyD0006+oKxp446H+oqhCGk5Wdg4CDERYYbdwvYHO/AQqu0dm+a40yVQBccPs4m1z///iK8sWjPkzPsL10+d1z6RWHr4KdINATAMlTqckXA2kAsE8jwJvNwqHdf4ovK8SSJmGMfRYWLXUmwYVkUtifi87zJ4Kwj1CAHIWvYxvV9vP0ysUBRLfAe8hRREWHjho2AmJCHGoV3tFWykWSce3gTQhS1tEp7VhZllNo5gkp0xrlUwbvs8PE3R52o3wqgYqYiqacrBEJcONBbmqCtYNGbEEGvjS9xhROWBJsj4vt1FW0pSopI2vcRtJI8OeeoZfXUthsg7eVB1Dtc27GK5Gc8FADn52p0WW/7+Fckjwqbo4Et8nOAcKDR0I/IzhcTU1aNfpDO6WnJp20nLYq35Pc5e1dYvkWIWRND8f/68eD723VaZVbor/2zPqKs21mj8LtLD4HTn3cphUiLg3MHr4zhQ56q4mZ8Ya/3j2Nfh3sv61oilt7onY7Offh5o4heXT7GB76D2WhL2iOlE69vGUJwbC8AESZP92n0syWyQ7MftT+jAzy/PI+6Ml/GCQC01XQIGM2rVuYXJtQkDk8PgpgtiSczpzRebUH7RJ2bB22rWWp+GYz3UolEN7Pvy5Cevt1CTfpukA9+qahDTKB
 H4LUF/+K
 IlLwvaMEeq+vEWiomgM6kJlaKcw6Yz1rExOJu0xwsgZAT2zzCdaU19htpn2QMoAOo453nEslhoDwdM0t9OHwJ3GknHTV5Wn5VbZnLb98F5LmHbfj5IETaPTMPl0Rhtxb8LUlRyuXTbFkz8LHbEx7FqKCbKsim5Paudr9QGb4zgbvbeuQ3lMYC84h1/zYQRp4MAnM9W4sQ+VgLuelWvN8TIS+exBnWJCPvyAl437zZgqvwYUhuubilxfn5twBlj75HXn806l3+NyZoV+MExM91LGx0exjBimobwUtqrBV0YxrgexGOEbab43CUXPVyLVK7QZx9PvcZrllR7cWkJ2KrVGgMnqPMvrVs4VRURcngD7heFVJzUtc0+opnAmz9Uj3DfiTUD+RSzEUBty4iDwaeE0sgDPDuYG+PoMSTMRFjz7HmYEZzOyayWpPXe3t0ABN4p5lc+Z5PTttYQwTUFKWUc+SAwgpOt0uJRnUcxMixzFM9JmU+VDdr1hcxC+OOMCrooWva30mFT6GCB7xQm6ZqYBwYONtG9w4euU78sNWfM0lZdHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:55:26AM +0100, Lorenzo Stoakes (ARM) wrote:
> Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
> a faulted VMA into an unfaulted one.
> 
> It does so after the page tables have been moved to the copied VMA with
> MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
> as the page tables it had are no longer present.
> 
> However, in doing so, it violates the invariant that the anonymous page
> offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> 
> This is because a VMA may have been faulted in, mremap()'d (causing a delta
> between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> 
> This condition is a violation of a fundamental assumption in mm, but now
> also triggers an assert in assert_sane_pgoff() which explicitly checks for
> this condition.
> 
> Correct it by resetting the VMA's page offset at the point of completing
> the MREMAP_DONTUNMAP operation.
> 
> Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
> Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>


-- 
Pedro

