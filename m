Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA2DD65C73
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 15:54:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938F06B0005; Wed, 17 Dec 2025 10:54:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E64B6B0089; Wed, 17 Dec 2025 10:54:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7746B008A; Wed, 17 Dec 2025 10:54:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 684956B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:54:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2083E140B7D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:54:00 +0000 (UTC)
X-FDA: 84229409040.06.F697A26
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id CB8F3140018
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:53:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0mH+XEKZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="BE3+/BSx";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ax3zdwol;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HMcl5yOd;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765986838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JHFIvIf4X7tzBP3WHe9GPlUT1dw/aTjq/zGheurbhqw=;
	b=j9I+SELdWorQikNGU6yNOMa8y4OW8vgshcFgr7Wxyio9Ko0Af/y2CTNhZfMxRZiBTk1bVQ
	KHWg+xf3CbZKTJKVq+4QQf7jWwyckRgAeb7kAsRNZ0sWiooQlQ8q3c3bpJjbqmOvvXHOzS
	RzJ6ifApPfid3lNzdpr2Wv1arfEwhjc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0mH+XEKZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="BE3+/BSx";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Ax3zdwol;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HMcl5yOd;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765986838; a=rsa-sha256;
	cv=none;
	b=7AHbNVxmLXjq2mxM+KlFKoPp9WZl/PyC5JnV1fWckmsveoFZFyKEThWU16jYROCNQeGG0y
	idPVuv+wbVHStXI/h4IBHM3qStQUW5OahnuWDgoYr9ZXgdKNIAl6o1o9Q/o38Wk/vi7RlK
	2Pa2aBmgXtrN+YFnGYqNWP/OJIzwJqE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D1A7D336D8;
	Wed, 17 Dec 2025 15:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765986836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHFIvIf4X7tzBP3WHe9GPlUT1dw/aTjq/zGheurbhqw=;
	b=0mH+XEKZL78Va8xWodZEwRFIWw1NmCCShFfNSvgzCMgBOuGug6lrrXaC2CoAJsRVTaOShv
	XXopdV6f+OBSTROywp792jw55meW9LW6oXoOhPBAKXuaxdmiaAPO+izV5jlX9om0NuJNQX
	R5lTE4tKsgEY2KDXdPgKHX2Iq81WX7A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765986836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHFIvIf4X7tzBP3WHe9GPlUT1dw/aTjq/zGheurbhqw=;
	b=BE3+/BSxtQk+bDOhKRSpL7bAxIjuKMbsaJu7oaGGEZ4LLMdfYbFVtsBZdj3G1kYSji8Gv6
	FJ/+yhxqrtFKd5Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765986834; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHFIvIf4X7tzBP3WHe9GPlUT1dw/aTjq/zGheurbhqw=;
	b=Ax3zdwolktO8nbJcmOJ35BvzMMD5ZvBwvX1hZhwzHHSZOVEr5mVEFKoctykTqM3tL6At8h
	Wfo38GRsiAyxybF7CPFnePl5vJmwcvdGSkIgKbQFz79QslVJv88kilGNHZAChTM131ZKvL
	oLiRrd94ugBz2AJaWCUTp6DaqcwxXis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765986834;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JHFIvIf4X7tzBP3WHe9GPlUT1dw/aTjq/zGheurbhqw=;
	b=HMcl5yOdrasV3iwvHWXmyKF0GQv8z43BFLDS/eN5xvLg4yCmRt1QuvQMlJBus1MFJYJZ7T
	WBHXzM6d8d/TZBBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9BE23EA63;
	Wed, 17 Dec 2025 15:53:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I5TOMRHSQmliWwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 17 Dec 2025 15:53:53 +0000
Date: Wed, 17 Dec 2025 15:53:52 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	David Rientjes <rientjes@google.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 1/2] mm, page_alloc, thp: prevent reclaim for
 __GFP_THISNODE THP allocations
Message-ID: <xow3biulatuampfmzfbmnmrc4lkzgbhys76gpwrxrdwesr3y6q@c6bpczjcgact>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216-thp-thisnode-tweak-v1-1-0e499d13d2eb@suse.cz>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB8F3140018
X-Stat-Signature: udjbzw48sypza4xcwj164ejxco5jehba
X-HE-Tag: 1765986837-935167
X-HE-Meta: U2FsdGVkX1+8Bt3MnXG9LGb48AFny1VyY8OhzreqiXYDyYTRI0RbNXdGYoRn9gZudARVagBi5NLJNaY27PoJZlnPWnVK1wx7YXDjBtWqXHCCr2w6uLxp4XkOzXGZd4DhDK1dk8fZGHmYs/epgalWoZd/l6FhNDXzuW/sAbAD886o1/d4Xjw6T1FtYeElpqLEOlU94imcIjJstj7CdUxi+JVm5IFLfHT76qpte8hhTFXwrDEFSRt8jz64krKCOb5tCG3ImQPWrDtm8EYcBWwPsW59oGG/6PwC32CqBzReta+Y/wvJdmRqI3BmimZLBjp5GQxmOpzdXlakbzkGHfYy6Ax3HAv/1Bpqh7DQCNOivSedrTyPbva/H3MVOvwEuaKyergEOYdiR3wP/x/KxkiCnG4hkODXaKVw+80cU5LivvgTSEXx+Dy92K7jyJvfXFxHBpDHqBe2baVtq8f0hSr6ANjinjBpmJI1hMZR7+jrLupjISXOuuY6+aHUMuTtqIPaBua10y7F33JxumnK+5zFLCF97pgI4fP6kyJEC+GpdMOcZl43NX7RTuU3hClXeb5VjJRSNW0oh3N6ErjCdK3/INjLJSpXqX+Tso5C49mjgkBA0McLwpVQ7LU9n+CgFqepz2u+61TAufbBPJcJjUStb6wXCATe9YvGn8vc8VpyPkreg5RyRcgBeS93ylhpD1LO785FUGNLTaCL8g5H1MemjYJv+Td+jxOiUrv38iB86ttkFWboSCsfluhekgRyIppC8HyzECm9QEjFEpsQ5Z4KttfAMHsRyVXd7vSncbMGhQ9v5+TSUJZWrfTQJHDjy4t9ecQHG7h9qenuzMx66Dx+GBHIeK7yKNpkMFc5FTjccguRlxyq5ScTAb0sCQY89V4czGZ1hiW9eVPqOoE4OOJYi2RaaxjbCfb8Re948OqWask1al7ECx5JDGKGMkuKLBATsByuTtslero4qakJGLY
 qZFSLI1W
 t3istYUbF56IBbjogd0au2dE07CdfzQavWTVYzddMDl/nCTynQ53hcdICNk5ZCOB/vgQ/BNSxAQqqb0mlbSJ1mppWs/NclM1D1gGfXzPv1PoRbXutTnYC5UiGzulkCVChzwm5gLhXueQih3sT1rZaW4Y3WBBWGNbAqd0kQSgS7G21INUFyIY0kzaaJxgatkmPnUjkM235PBVHtGMgKpl5tqtdHu7I2AU+aq6CBecBjMoHLeQ0fXQnSLpOBJ3ti0sSrbOCvmlm831FcZkBZCUzvWQKGF4vAJa3uRS6tCE4IMPX0mooKDZpYXy5O3h1jote+1dskVUs4ft/k8clRhACGsRz+O0HS822nvjEnOZ8895UGhWAs+xBNSr1pmnxIBh9YcH4J1hXzmqGudAmw+5bKv5nHSNbIorWTOItamY7Tau5pMk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 04:54:21PM +0100, Vlastimil Babka wrote:
> Since commit cc638f329ef6 ("mm, thp: tweak reclaim/compaction effort of
> local-only and all-node allocations"), THP page fault allocations have
> settled on the following scheme (from the commit log):
> 
> 1. local node only THP allocation with no reclaim, just compaction.
> 2. for madvised VMA's or when synchronous compaction is enabled always - THP
>    allocation from any node with effort determined by global defrag setting
>    and VMA madvise
> 3. fallback to base pages on any node
> 
> Recent customer reports however revealed we have a gap in step 1 above.
> What we have seen is excessive reclaim due to THP page faults on a NUMA
> node that's close to its high watermark, while other nodes have plenty
> of free memory.
> 
> The problem with step 1 is that it promises no reclaim after the
> compaction attempt, however reclaim is only avoided for certain
> compaction outcomes (deferred, or skipped due to insufficient free base
> pages), and not e.g. when compaction is actually performed but fails (we
> did see compact_fail vmstat counter increasing).
> 
> THP page faults can therefore exhibit a zone_reclaim_mode-like behavior,
> which is not the intention.
> 
> Thus add a check for __GFP_THISNODE that corresponds to this exact
> situation and prevents continuing with reclaim/compaction once the
> initial compaction attempt isn't successful in allocating the page.
> 
> Note that commit cc638f329ef6 has not introduced this over-reclaim
> possibility; it appears to exist in some form since commit 2f0799a0ffc0
> ("mm, thp: restore node-local hugepage allocations"). Followup commits
> b39d0ee2632d ("mm, page_alloc: avoid expensive reclaim when compaction
> may not succeed") and cc638f329ef6 have moved in the right direction,
> but left the abovementioned gap.
> 
> Fixes: 2f0799a0ffc0 ("mm, thp: restore node-local hugepage allocations")
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

