Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 070C3606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:09:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=f3hBN4yS;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Q/0K4tT3;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=f3hBN4yS;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Q/0K4tT3
Received: by kanga.kvack.org (Postfix)
	id 1CD3F6B05B4; Thu, 12 Nov 2026 11:09:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DFF6B05B5; Thu, 12 Nov 2026 11:09:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04C976B05B6; Thu, 12 Nov 2026 11:09:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D327E6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:09:28 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 64DDD40623
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:09:28 +0000 (UTC)
X-FDA: 85426952016.16.A634978
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3745D14000C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:09:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f3hBN4yS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Q/0K4tT3";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f3hBN4yS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Q/0K4tT3";
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794499766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Pc/BE/Q52yGpOarG+khdx5fMHXqENwQm7w1VOmz/Yw=;
	b=UcEVLna+RKhAfBliP0gTToNQYdxyOelOrVLR/GCCYL0dkIW+9CIac0oftKPti/DmLoUGvc
	o0TZmGfW3MeN864Mx5WaMRx/CtF19FIVa0PmWmZW/GAmRsWUNtEH5IebEyB+rJy6l8bpne
	ktGi7kGDU765wJZ7aAxPKC+Eu3kIbok=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794499766;
	b=4E9k0G+07eJBJ5L0k1XqNbIqjKD0djdX6T32luSBdDuz/wstQt7XwLm4f5HX1nakczE2ZE
	qPMrOnG+TQYPyvj8f77ypwHBrmy8XkriVdC7aRyfKnmmJL8VSuk2TzxCaVMXLxmgeVBvrF
	RHkC+SlgE8HqrDTVrvrfM1dyRHBEMSA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f3hBN4yS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Q/0K4tT3";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f3hBN4yS;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Q/0K4tT3";
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A7CF921F92;
	Thu, 12 Nov 2026 16:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Pc/BE/Q52yGpOarG+khdx5fMHXqENwQm7w1VOmz/Yw=;
	b=f3hBN4ySnI5cE3+JOrCGjRA72FoPDSvg7l/cfGo4h8Pb6UVyomrX8BVx9nHgU+xs9gEwss
	ujUehcaCloAwFhIinMiH8O4Qln8CGDqwb/Y0DpQDDjCVj0+rTZ4hSs+mELBV30sLzFHbC5
	QjO749plQy0hMCimjtG0AkfgbBoQBjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Pc/BE/Q52yGpOarG+khdx5fMHXqENwQm7w1VOmz/Yw=;
	b=Q/0K4tT3wWzPs6dyZFiJZ+LbOgcn3qLlYvBojekxSRY39yB2hPRNbNMlskKRDxKXiFjQi3
	sat9nb4bIhSpXWBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794499764; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Pc/BE/Q52yGpOarG+khdx5fMHXqENwQm7w1VOmz/Yw=;
	b=f3hBN4ySnI5cE3+JOrCGjRA72FoPDSvg7l/cfGo4h8Pb6UVyomrX8BVx9nHgU+xs9gEwss
	ujUehcaCloAwFhIinMiH8O4Qln8CGDqwb/Y0DpQDDjCVj0+rTZ4hSs+mELBV30sLzFHbC5
	QjO749plQy0hMCimjtG0AkfgbBoQBjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794499764;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2Pc/BE/Q52yGpOarG+khdx5fMHXqENwQm7w1VOmz/Yw=;
	b=Q/0K4tT3wWzPs6dyZFiJZ+LbOgcn3qLlYvBojekxSRY39yB2hPRNbNMlskKRDxKXiFjQi3
	sat9nb4bIhSpXWBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B421013432;
	Thu, 12 Nov 2026 16:09:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qCrxE6/k9WqvLAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 16:09:19 +0000
Date: Thu, 12 Nov 2026 16:09:17 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Song Liu <songliubraving@fb.com>, Rik van Riel <riel@surriel.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Steve Sistare <steven.sistare@oracle.com>, 
	John Hubbard <jhubbard@nvidia.com>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, linux-arch@vger.kernel.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 8/9] RFC: net: limit folio refcount when splicing
 pages into skbs
Message-ID: <avXknD2x_JsXoMw4@pedro-suse.tail5790ac.ts.net>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
 <20261110-refcount_overflow_stable-v3-8-318625d63a98@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-refcount_overflow_stable-v3-8-318625d63a98@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3745D14000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 659axj3rwfmsh8b7fp6p1t78sdnf3kbi
X-Rspam-User: 
X-HE-Tag: 1794499765-933226
X-HE-Meta: U2FsdGVkX19TAXxRXSC8g3kv+mVIvHf+/J0hRiOQoWnBBKp4zPh8OaLrSGDcG0NqKojax3cGyvh3HW1BuFiIEGHla5+IhwVbgvUwPhRrCKVkFfi7wHFseCedueJdl3jwcjLdjpM/YXj9FWL3cV54RWlZiUMBVO72ASADtKrPGUHfQTc0SMXETF89UwmZYH3QoN9L4roCCzeAmzqSFKqMmgclFDHE2Wap0X7zhDywf2LWAyN27TDoQAFDkIP+NL/UuYmRIBlS9j9s9JITdIe276tKCWBSNmhriN561Uhxuzvz5WeHXyt4F1RLGg1lykymfr1p8uoKqOy8MAgIoi3V0jNNaWEogNDWgSInN5BKLepBffyASxQsPG0iIbajsIBGkfi9J/z5prCfQwIgsbXYlT1o8fdtPo0r/4XR1yIHFMKweRlHP/SL8qrG9MX4rlRP17fpgYf+r7JVAk7PqffINZDwcx3d4myORaMvRcoMyMiqZWjWQgspBRfWgCHS3StceM+EiuCZyNlYfwU4Rx0AZCz7dqOwzdYTEfFSVSPTYK0emBKpdpZe/0ZgUpnIu7Ko8PGTplvGw0L7sFBYDGmf3USANBSgq+vqbUJIQBu1uKl0BBRLdEyEdQWIHCSF1GtUdiYPHNUMgD0hmicguDcoqFb57xGPRpwIQJ+F74wzVw5BaYxOSx6UIOWdL5sSPl5Zle9HhWUPzEKi9As6ZMRpStIbBPlxl1GYWQf4zkfk9+CSex5t7z+Kvt9QYOSCTRiMQPzzmDEeJCz1rls4QHfIgQHJwWn6MKOS55SjWAh5vlSdIrESdpFxeRtMecpjxUzngFD07Pa72YJLsfWAFDOm3v5819hBvGzqIItMZv5OoVgwM23oEM0708za1ibdtfbY4qjGU+uJYvxMEGe4CwsK7pqOZY/81gxu188UFY2wsWBM6NQsZt/9LHQUA+zfa3IJamxDsEvP36LtsAdVkRM
 s3PjbUl1
 gSJkfr2x888HrBoUN75yBnxJmt6bRJQ5kI2cdfrp4fZxnnwm1DksSyIS9B00nvSrkvis+PiI3VPhRlNJ/Fv4FXzc5nhc8DD+6fkpxcanrR5Bc1c2pPmUA5cC9UH8ZrxD7XcteC50N3tyPD2xTCMgwMELF8wS5f+ve6nBgGuWPRy/dLwViWowQvLizmg+xLxwT/lkTtZBhiDeDno7rfvMuRjHNoy/8YDXwfFksxArkTH/PWgWFkTcFiOdNFl9a0N3mNWy0eFc/xFXaIA47k+qPUXV3YOipHlnTDU1P3HN3ZhmQVlH87oX0jtH2gXTUDPkzFKefeTbf55KyzBWbpUie2D91HSJ1EmioSwkFvLIgtDot3ME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 09:35:48PM +0100, David Hildenbrand (Arm) wrote:
> Various networking features use MSG_SPLICE_PAGES to add pages to skbs,
> whereby skb_append_pagefrags() takes a page reference for each fragment it
> adds. Pages spliced from pipes were already checked when entering the
> pipe, but in-kernel users like sunrpc pass pagecache pages directly. This
> allows for exceeding folio refcount limits.
> 
> This is not specific to large pagecache folios, but with them it is a
> lot easier to reach the refcount limit, as page table mappings can cheaply
> create many references.
> 
> Let's use try_get_page() in skb_append_pagefrags() and fail with -EFAULT.
> Don't use -EMSGSIZE, as TCP would just retry with a new skb. The only
> caller, skb_splice_from_iter(), handles that.
> 
> Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> Fixes: 793917d997df ("mm/readahead: Add large folio readahead")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

