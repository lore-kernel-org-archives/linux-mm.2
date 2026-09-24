Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA5FC98311
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:15:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A8AC6B008C; Thu, 24 Sep 2026 05:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932A86B0092; Thu, 24 Sep 2026 05:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8208C6B0093; Thu, 24 Sep 2026 05:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5535A6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:15:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6DEE14025C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:15:21 +0000 (UTC)
X-FDA: 85248097242.09.3C7A4FC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 57134A0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:15:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790241319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lazfpGCtXFAVL+4wBGjWCG8JG70JLSWXT+eN8LMFAg4=;
	b=kHT6YhHRvo59m/7fNF+7MDitKEiCWIiL/S6M0gQrvKQ7MILOogdWXbvUcdFoxjG1eEf9kv
	3BF2fK0xkjklPFaH5svkSEsEQrvSzXlI1M7YW9qn1px1bbLw6i6NUOKBKD90El3mEawfuM
	IkjENFkeIV2Rwz1U2AkZVIDCAOeHgfg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790241319;
	b=Ky++dd9FDCs10gA/RiS9FHGb1nLgKQYk65bqgi5UWHxYbzCOkAoRoWnSgIuv9umbU3VO4u
	TE/CA3ZFv+9uC2wYz9O1XiIhFMrMwyZGV3fVyHtUw3YllQeXkPvid32KErxA0VR6qYP8oP
	ZUGlSG7X+O01Vjvwl6nFGyqGDM3vUIE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E01EC20052;
	Thu, 24 Sep 2026 09:15:17 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A9FE313668;
	Thu, 24 Sep 2026 09:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ycF/ISXqtGqqDgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 09:15:17 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3AAA4A132E; Thu, 24 Sep 2026 11:15:09 +0200 (CEST)
Date: Thu, 24 Sep 2026 11:15:09 +0200
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Ayush Ranjan <ayushr@modal.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jan Kara <jack@suse.cz>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-ID: <uf7lys6izqrxjsp3tstqxmdok5yy3w52d3bnpkfzyjm7uiyqzr@ickbg3ocvcji>
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: b9ffp9dpwcrg4wpr9pjk5ffhyywr7e3i
X-Rspamd-Queue-Id: 57134A0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790241319-367468
X-HE-Meta: U2FsdGVkX1+8E8Tjq5LRWN1tlYn3pXY7BqAWnIcjBVt8hYuKVNhAQsdqKKKtdq2GQwjILP70/rRulU0E3WvmpaAcipKnSFt3tTk1m6aAIBS9cEVB4hUqd8LP8HEs9i26H1D2TTnZasXBPsLxb4WPXoLET/gFvBm+ViLuvJomk1zKzjuThGnj5lfjuJARkhf+7PXgK/YjIpgek3VmUZ25bSeXMyBtkxrPqcw0ekMqiK3QaRxMbx9Ay3NDC1TJA36HoqpUgYb/umxUCAwEvAknv2bpXb7qmi5gUqH/Ggy1In6hpu4/A/hEwbY9sDhXEDsCAe5eatimg3btHQsT3ycMlf6JmO3OUkqXbsNwi7XE2I7SVmtcLA8VtcBM/gFtXW588Y1ttRzBVGyaJMvLvFEIciZRAFPggnKXNyBWEB4ynDJXTch4wuI+ZxvzdcLTln532ql20yy64ohOTM23lkyDKItwWdmM6E5ANLxIBcUhc1734kMc5OxcCuqBqa++Gc6XkF1CNIcK+mXMSXCroO7Is3BZC6ptCzonTPJjzPYTtmEWBM5GSygc8nRt5CaGlm/6qVGBlabMYG61D0ozfE4mcuRiwnVw70lj//50F1pXyAwQbiwYW+GST+9ugNEo6CKjYfiqWfl6quQsdsfzUba7RxjTu5sFH/lrXPDYofeV51lBmIjRsZGAkNOclrF0pWTGc2lYwNd5qTXP5dYfd5eub+sRSwGBgILTn1tYv0JZlBz+cQi5mRAz8Xk6ypyiFheiLM557H8dWg8tyJ3elECFHrQkrZ14JzQ360dYqFBglRsR2KswlMDzOWoCdwaYSy3TkrggrM5G4+OGB9X0JMPaGJ7OyjeUyVIcZWOHOUIyks8/qpxuwxa/Grah1KbmEdsGPT7VySQCj6OOZr4Kgg3Ix4U0BAjP/Z/vWewNx9gZ95cTPjCYL1TT7iSbqTTAyLUo59424TwZ/l15UmO/OTy
 1sTrhBmU
 pRknF7CrWbmKhOFc2Ch+2WxJeIBbLHcr0Jbm/GHXeMxtd8XGQU6ndgGfd6SNXkFVq6mWd7W//J8vYea7PG02C8YznBcJvbfQ21RQ0Y4pClujKXK9dESR+XjuX8gSjBHRys6dQVoN7MHJ50yv1X5aM6ijTZvS2tyh9cb/R8esbpQ54zczSb3vVri/wAaEkFlqM7SKx5IkeI96A9MLbTZkpD74CYbYGw1p5BekjNsVYPX93JPxWWV7JQUMbcPF8mMtspolt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 24-09-26 09:34:24, Pedro Falcato wrote:
> On Thu, Sep 24, 2026 at 06:16:21AM +0000, Ayush Ranjan wrote:
> > Here is my best understanding of the race -- corrections welcome:
> > 
> > shmem guards faults against an in-progress hole punch with
> > inode->i_private: shmem_fault() -> shmem_falloc_wait() waits while
> > shmem_fallocate(PUNCH_HOLE) holds i_private. But shmem's .map_pages
> > is the generic filemap_map_pages() (shmem_vm_ops /
> > shmem_anon_vm_ops), which does not consult i_private and does not
> > take invalidate_lock, and shmem does not use invalidate_lock to
> > serialize faults against truncation the way regular filesystems do --
> > the i_private + waitq scheme stands in for it, but only shmem_fault()
> > participates in that scheme.
> > 
> > So while shmem_fallocate(PUNCH_HOLE) is between
> > unmap_mapping_range() and shmem_truncate_range(), a concurrent
> > fault-around can (re-)install PTEs for folios that are about to be
> > truncated:
> > 
> >   - filemap_map_pages() samples mm_counter_file(folio) once per batch
> >     and applies it with add_mm_counter() after mapping; if the
> >     folio's swapbacked state changes while it is concurrently torn
> 
> But that cannot happen? We hold the folio lock in filemap_map_pages().
> The folio (naturally) cannot be torn down while we have the folio lock.
> 
> >     down, the map-time counter (MM_FILEPAGES) and the zap-time
> >     counter (MM_SHMEMPAGES) disagree by exactly one folio -- the
> >     +/-512 imbalance above.
> > 
> >   - a folio re-mapped in this window (by fault-around directly, or
> >     via a child VMA whose PTEs copy_page_range() installs after
> >     unmap_mapping_range() has already walked the i_mmap tree -- the
> >     dup_mmap() variant discussed in the earlier thread) can be
> >     deleted from the page cache while still mapped -> "still mapped
> >     when deleted".
> 
> No, I don't think this paragraph is true. Page cache truncation (via
> truncate, or fallocate PUNCH_HOLE) takes the folio lock for each folio
> that is about to be truncated out. Mapping folios takes the folio lock
> as well, except in the fork() case where a myriad of weird interval tree
> + PTE lock interactions make it safe (AIUI).

Can this be perhaps somehow related to the fixes in partial large folio
truncation Zhang Yi is working on, possibly even the tmpfs bug in handling
of folio split I've found [1]? It seems large folios are used here so that
matches, I just don't immediately see how those bugs would lead to the
errors reported here...

								Honza

[1] https://lore.kernel.org/all/5pthbyxtn7q6xi4fmkofvksmcjzfnujcw2g4fxmxjzfin5pbgf@zui3vcimb4cv

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

