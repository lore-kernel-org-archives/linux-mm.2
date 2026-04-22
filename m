Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7FEF9EDC5
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 12:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9103F6B0088; Wed, 22 Apr 2026 08:56:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1166B008A; Wed, 22 Apr 2026 08:56:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B0396B008C; Wed, 22 Apr 2026 08:56:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65A3A6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:56:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FDFC160188
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:56:17 +0000 (UTC)
X-FDA: 84686189994.01.1AA3E06
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id B8C1340013
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:56:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z0QkewOs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E5DruJoR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z0QkewOs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E5DruJoR;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776862575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fE6IDxVoUkquxq5pDa4brdX8WdMdoNs2B8vTHhjhhd0=;
	b=wc8R2d96NtH+4Q8gLTder0oGNoa+sYk5G8HfcfuhnUw/GMhdUTPW9g4w72JQZoEjSkgGy3
	Wl+FvXhCj/fPevGeN0Gq/4X5vpz3lxJ8+QCuo/xpnrJV0Q8JbhrFi4igW4FK1TO4PMgqFB
	tohUsWXzKiNZIza5O/k+FLAEoe+VSh4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z0QkewOs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E5DruJoR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Z0QkewOs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=E5DruJoR;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776862575; a=rsa-sha256;
	cv=none;
	b=vy4Fi1JopEWcO1h+trbVx+gOkdYVOfAxbf450aoCBWhb33+eJe4k/ijiBdLYiQpyb/y620
	4tChDMSMsvNNjLNiVAaouZcHH5ybMm8pLgukcsPhc6XAY7g/kpkEhTW5hqRqIhXblw5xMe
	O/UQF90nVg9HaSlON3dfP+Jguwt1Mbo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1CC745BD5D;
	Wed, 22 Apr 2026 12:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776862573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fE6IDxVoUkquxq5pDa4brdX8WdMdoNs2B8vTHhjhhd0=;
	b=Z0QkewOslpetixy9qs52tWUQSyd3NqHtiJpTdRVb6vd6itAS7edKymMOK2gYCyWgvGCw39
	YIuNjYu5mHbffgN1sGUCTZGqC0guOraIIks3lsYga90t2L2pMrvv16I8l7V94hyo9Wpv0X
	+2/q0krp34emJRJcIzmO55DWwr7b4js=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776862573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fE6IDxVoUkquxq5pDa4brdX8WdMdoNs2B8vTHhjhhd0=;
	b=E5DruJoRKN4CGrP1gg9MYy4u3h+2lqSUDVtAtmLjxJBvwO7JUaxZkkH3Hkn4P/EFZCBxG2
	qmvvhSOUXa2LJpAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776862573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fE6IDxVoUkquxq5pDa4brdX8WdMdoNs2B8vTHhjhhd0=;
	b=Z0QkewOslpetixy9qs52tWUQSyd3NqHtiJpTdRVb6vd6itAS7edKymMOK2gYCyWgvGCw39
	YIuNjYu5mHbffgN1sGUCTZGqC0guOraIIks3lsYga90t2L2pMrvv16I8l7V94hyo9Wpv0X
	+2/q0krp34emJRJcIzmO55DWwr7b4js=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776862573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fE6IDxVoUkquxq5pDa4brdX8WdMdoNs2B8vTHhjhhd0=;
	b=E5DruJoRKN4CGrP1gg9MYy4u3h+2lqSUDVtAtmLjxJBvwO7JUaxZkkH3Hkn4P/EFZCBxG2
	qmvvhSOUXa2LJpAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0E873593AF;
	Wed, 22 Apr 2026 12:56:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id px2BA23F6GllBwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 22 Apr 2026 12:56:13 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id BFAE0A0B44; Wed, 22 Apr 2026 14:56:08 +0200 (CEST)
Date: Wed, 22 Apr 2026 14:56:08 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Frederick Mayle <fmayle@google.com>, 
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, kernel-team@android.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: limit filemap_fault readahead to VMA boundaries
Message-ID: <qmojyvlsbjcgavnecbvfwax6o3d7edzifpxp7raxbevbfcxtbi@mox2z7njeodb>
References: <20260422005608.342028-1-fmayle@google.com>
 <aei_d5KMKmLhMx3S@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aei_d5KMKmLhMx3S@casper.infradead.org>
X-Stat-Signature: gqni9sbr7xr8srii14wjd13zagp9wtkn
X-Rspamd-Queue-Id: B8C1340013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776862574-475472
X-HE-Meta: U2FsdGVkX1/DU9JNkDsSVfFmQ3Ju8KyyagG5gxoDv2LiABHitu44kbh4ZzDTLRvXg6/PzQwLwuTeSSkcNtlIwN12CIcPcd11DNjVAkCVBJvLzVgZScEOiWct+FWkkVc9vrW0jw1k2ov3iu/whO+oKnqm4DBfP/DRbzBqjW64uSe0ajjkXGWZiqmiL3fo7UI3X2ztu4T0BasXWk/JF4xe1zPitO9e7hf8iviqPCMMaHVzN4bXlN/b1GXcfZflG0IFO2NjYx6+LSdsS7jQfjJiRj8VNZcaJhV6m3hTHuHITnqSr1XPBBOQ/Z/TJJ7K/fAvb2JDsaZRNElK4HIWaOYg5hSynXnWkPIGYq41N2zgdZ1RHkh4gSvx4CIHxR5a/TsfN+kjsL94L9IvGOiPSSsMV7D1Qke7SwB9COPYMUmBTyoXYiQWT2x4r+/zPp/eCwcQB3xbQW4X4o8/TxQrqY6T7S+UTCK4XWY1E9AEncZhaybf+t/R9hwf21YoscfIpYcrvt+WarNeP7+haiHKv7rGPBPoprNJXq5+qlNuaTxzq5LRyX/Q8giDXfkt2qar9Nqrrahkujo3UiOvwdqF/ytnx2ZSfxbz44cdBT4setI1cpbogDE6Jqs/9OCdmr5j9nril2FeJm/tcL/U7mGbZJZ02gU9nqllDOAFRsBgfP2qL01UvQNzLp2LcuEDafbXBDn1g2JwJ455wFTAnpAaVv28IBm0Eb+P3G1COKHmrvGK1gp0Cj17npaeJvTMNbeJmwUx6NlXQqcMMKUb8wpBSD+KFxUfR3W9HEq1P6KlGnr4jlzmG5AgfP04b5oRrvcS2wvRTG4WGsY2MN6rZoZELR46qfCs4KlKCOZZ5LRr/45k+DUl5qgln9s2BDXAjHjQcM3UUXp3LkQLZmpsxTQ4oAhadt5Us3EFlVX08QSZ58zT5DIbXr0jTzbZ1dqhN0aVePfZgT/zqUiS9C75jPXl1c+
 /zRy+unH
 8Ro7ds02pp2FzIweaPXkTqYhW40BVO7NRWS0hI8WW6xN/gVV6nFvgRHNMjnfRL0xgoWuYAJYlKNOl+aJrDJ4CZs7jBHKCdz3JkIezXUSZlOjo8Rg2beek8RS2bMmj+upmDfqyfmfsHkaI/tssa+v4lY6QNrE+/MffpT7E0H1OGCDVUfl8XcUpvuojhzaVH0/nxXjm51Y5ztyq+ctzhyKkBiHiZP3RB7JLm/fQDfe4i+iBbXsbJlQfuZnQfgWbX+ZjzfziDsOi78FlzR+VBQcyGpn4/jTfm+Gncru8RQErkbscrxvJwR2WGGZfACAMZZs9bdjhDoZ8mwTfF8gO6XX3RHx2QyJAOx7YkdX0cA5wzF45zQHhw2AWwODSOY47Ro9t+FdMRIKZwrjz7aw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 22-04-26 13:30:47, Matthew Wilcox wrote:
> On Tue, Apr 21, 2026 at 05:56:07PM -0700, Frederick Mayle wrote:
> > When a file mapping covers a strict subset of a file, an access to the
> > mapping can trigger readahead of file pages outside the mapped region.
> > Readahead is meant to prefetch pages likely to be accessed soon, but
> > these pages aren't accessible via the same means, so it fair to say we
> > don't have a good indicator they'll be accessed soon. Take an ELF file
> > for example: An access to the end of a program's read-only segment isn't
> > a sign that nearby file contents will be accessed next (they are likely
> > to be mapped discontiguously, or not at all). The pressure from loading
> > these pages into the cache can evict more useful pages.
> 
> The problem is that we might (for example) use mprotect() to mark a
> portion of the file as being unmodifiable, but nevertheless still want
> to prefetch through it (since it will be read, just not written).  I'm
> sure this solves your problem, but I'm not sure it covers all use cases.

Well, I'm not sure whether all the usecases are covered either but is what
you describe above something you'd expect people to commonly do? In general
sequential reading through mmap seems to be already relatively rare...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

