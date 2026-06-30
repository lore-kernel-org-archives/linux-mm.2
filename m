Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5714C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 18:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67D9A6B00A9; Tue, 30 Jun 2026 14:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654746B00AB; Tue, 30 Jun 2026 14:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56CFC6B00AC; Tue, 30 Jun 2026 14:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 202096B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:49:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F219C2BE6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:49:16 +0000 (UTC)
X-FDA: 84937466712.13.46E614A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4D4ADC0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:49:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=u18grtz3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sGHaEjKp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Z3C3/oGO";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jiGaKDSG;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782845354;
	b=a0azJdT3aXMRyqxc7UIL8Lu75DO11ddzgnJvzsopA7VY9O5w0gp/53OhL5YAO8fGWTQjEJ
	60G9qM7FuEFE7vKj1qdPw4jcRlgxQd6bLskgpYzIofShYZs0mGw1F6otBDHefV3a58BG2v
	5fsp8nJ6eMKwUgom0ZFFpiNk1S/H9bg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782845354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsCa3RNAA7O69TzyzAjIqux3S4SG5DUxACORIUg1Tps=;
	b=XVo50F1U7FnrUD2vjYJ4SoQD7Ta9FvAZ4hld7LO/4xmKFGxuasHtKPdIhR8I7y3kSqlRVH
	vykaME8Fu1qJut1S7z83Npf//fiK75kdW3/gH0FjjPBKGeTXnuWAirDb0Q1rXsodGTDRTA
	Qbm7Xz4r1m+n9BVXK5u7kduG0Tn/jns=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=u18grtz3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sGHaEjKp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Z3C3/oGO";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=jiGaKDSG;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9F2D875A5E;
	Tue, 30 Jun 2026 18:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782845353; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tsCa3RNAA7O69TzyzAjIqux3S4SG5DUxACORIUg1Tps=;
	b=u18grtz3pS8lgC+oV44hYee4ph60d0uHjj8YpHsmry6VgI+x0kq3T2fuZP4bRfE/9+moId
	2yM3tRbHCeY7S+yOh/QFqU9frwiaBCAF+BbHZa+Mjm60/DumVICsGH1Snt9dmT4Yrjpxpa
	dgGbVerXbZtEde9ERY+7qThv2CQ/SaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782845353;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tsCa3RNAA7O69TzyzAjIqux3S4SG5DUxACORIUg1Tps=;
	b=sGHaEjKpAswitz0sN6p0SX8lABGDefKe7XkhW/8GofXp5HC/6bH8ou82rY8xbs9HQ/80BN
	cuiy28kOX0wwQHCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782845352; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tsCa3RNAA7O69TzyzAjIqux3S4SG5DUxACORIUg1Tps=;
	b=Z3C3/oGOkFrXPDFhBeNvjU+XahGABVHmMwB7O6+3VdWpwdTFJeFGNXGdpYQ2MS/8AiRmEu
	q9tQXxvhaPkRuTDqdeHQwq/5clXIrXNpVZksVsBbRawBZQeCd3/wZoF0cfH4GdyJkORW9v
	hJAbqXL/Vy7rQF7gBOdlo0jAXlFYbm4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782845352;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tsCa3RNAA7O69TzyzAjIqux3S4SG5DUxACORIUg1Tps=;
	b=jiGaKDSGbHvY3ULrhwKR6U6k8KcrcXtV8IB5jf6I5QCDp273jpCjKtdEk6ZkHROCGRxe8z
	D+KaRiZZ7jMC1VBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A418C779A8;
	Tue, 30 Jun 2026 18:49:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 598rJKcPRGpBAwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 30 Jun 2026 18:49:11 +0000
Date: Tue, 30 Jun 2026 19:49:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Eric Hagberg <ehagberg@janestreet.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akQO8JtTxmp89GS8@pedro-suse.lan>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akQIIav_zaK6RmIC@pedro-suse.lan>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D4ADC0003
X-Stat-Signature: 4p3ah7r939arhx9kg9cfjwznxowupqbf
X-HE-Tag: 1782845354-422870
X-HE-Meta: U2FsdGVkX19OkEdqutQXs5SCnAO2M/4Q4YCoJxQCPswjxl+TjTRSV/QEWrSpHH9z53J4FDmvA5AZ9y2F+mxTOOs+Go5C+cfwgclfLzpl0ChM+1nHPA9AUuegaZO/XJV38G9k1xH4iUoIimosJPZNCCW6kMnKd1dkU0ZIgDeqgxOlV31pACKgYy5HQHDIcnQRRXrl0gKeMvkKaJAlayu4qNINS1UxZklny29VcXMjmQxqWmSWqQcNhFqvbOGlzKGJ1jOZhMtaqJ/GJQC9OMQWEzzTNCd6cmmOb8iAJ5oxNGe9N43J3rQacbwZSEg0sSrhwyQWwVJsakG+cvoRz2uB7TdGVGFaMguoTC7865ReU3yqFClpJCSLpbIX3LfUhSylW2jCvpReMTWEv4z6nMEdttAyASXgnxyXyM/SZeu0GoTnKQ+wS/pe3KPi1t31gmrtfMvHBYsW7bjf/QdTUcJTj3kuXCpBB3p7YKWgSrSA7tob8a2aH11wKarTd3+J1fuqtvD1cdfUoNwUIdvNHWGlUL5mHDcxO/qD5y4m1KtK05UemGblv81pVCW2oR7npTpVtez7bzzBviiZM9ZnzxEBwQQLc6wKKGtOtURrGaWbFChu1Sxv8cc2e6TVh9XCh8s9yPBEjkhatzbN3o0v/X5b9vKo0kXRMk8Cnzd5fYBF7lbXJTfg1lx6GuB2WwFpoavLExyRLzGYTnayK6BB/O56qTz6lkAFy3FgWM99dIvTbbmv4h4j/r/B7nI0WsNRDULAXJsokmcHXSpGMzVrLu5kEjZFfCbQaDjjgwY+taCsGm9LFB/2kxGCnXSfHGTsBze6rTg5bFFpfqbbZeo05woTEfY4EE2QMze8f7fyK25pV147YT8ZAmx61vhcNiZm5SRUSdVEiqXselozkdPlsTXDjDUf01RdT8RUEUvSmEqoDGuWCYAh3xK9bmPSeAuoI2cZTowOsDXT8iANYLN4/XJ
 TQ5wYf+X
 mhYedA6qqBjEZf7regKSWA/PmGZ9mVfxLNrEl9Larc7B7mrkPyijNxSnmllviSMWr3rdr+fllVHpzYV9X0aL4Jy/+1tj/eNxp1U4l+XZgBMJquy+6dPVlxaoXOFPa3CcK6D93oJoim0HNWHl+RTTVyD69v47gsw5Lbo2sbXBsdCECjQAkcHnPTLHNwJo0o+CKkjGio1P3+PsjO+EVGctw732kt/Spzz8u6rG5l+pVXpJpKB1as2C+GOIeHAe53RAdVTbgGzsLaqBbroyHcEm9ZJC5zOpfkZEiakMizf7r4qtglUiu/btu+ZxNReRaoy3ewymPPASnZI/9R2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 07:31:07PM +0100, Pedro Falcato wrote:
> +CC some relevant THP folks
> Quick note, your email client's spacing seems to be all over the place, making
> this extremely hard to read.
> 
> On Tue, Jun 30, 2026 at 01:01:53PM -0400, Gregg Leventhal wrote:
> > Hello,
> > 
> > We (Gregg Leventhal <gleventhal@janestreet.com> and Eric Hagberg
> > 
> > <ehagberg@janestreet.com>) have a reproducible data-loss issue involving file
> > 
> > THPs and write-open, impacting filesystems that do not support
> > writable large folios.
> > 
> > 
> > Attached are:
> > 
> > 
> >   - thp_write_open_cancel_dirty_repro.c
> > 
> >   - thp-open-writeback-before-purge.patch
> > 
> > 
> > 
> > Summary
> > 
> > =======
> > 
> > 
> > On an affected 6.12 kernel with CONFIG_READ_ONLY_THP_FOR_FS=y, a file can
> > 
> > contain read-only file THPs installed by khugepaged / MADV_COLLAPSE. When that
> > 
> > same file is later opened for write, do_dentry_open() notices
> > 
> > filemap_nr_thps() and drops the page cache:
> > 
> > 
> >         /*
> > 
> >          * XXX: Huge page cache doesn't support writing yet. Drop all page
> > 
> >          * cache for this file before processing writes.
> > 
> >          */
> > 
> >         if (f->f_mode & FMODE_WRITE) {
> > 
> >                 if (filemap_nr_thps(inode->i_mapping)) {
> > 
> >                         struct address_space *mapping = inode->i_mapping;
> > 
> > 
> >                         filemap_invalidate_lock(inode->i_mapping);
> > 
> >                         unmap_mapping_range(mapping, 0, 0, 0);
> > 
> >                         truncate_inode_pages(mapping, 0);
> > 
> >                         filemap_invalidate_unlock(inode->i_mapping);
> > 
> >                 }
> > 
> >         }
> 
> Ugh, this is embarassing. So, good news: this code doesn't exist anymore
> in mainline! Bad news: it exists on every other upstream-stable-maintained
> release :|
> 
> FWIW I don't think your fix works, there's still a race there (what if
> you write and wait, then someone dirties a folio, then you truncate the
> pagecache? you lost data again.). I'm attaching a very quick WIP patch
> that I wrote against 6.12 LTS (again, this does not exist in mainline).
> I _think_ we want to go roughly in that direction, either here or in
> collapse file paths. There are still problems which are invasive and
> I haven't dealt with (GUP and other "temporary" folio releases being
> the main one). Some of these problems may simply make it so opening
> these files writable may fail (there is certainly, AFAIK, no way of
> waiting for GUP and other temporary folio holders).
> 
> We would probably be served with a custom loop that forcibly yanks
> only THPs out the pagecache, though. But that requires a bit more
> code for a stable-only issue...
> 
> Anyway, the patch is obviously ungood and uncromulent and is only
> here for a rough conversation starter. I don't think it works and
> it will probably never work. mapping invalidation is simply too
> best-effort for something that Just Needs(tm) to work.

Other idea: perhaps doing filemap_write_and_wait() after the nr_thps
increment in collapse_file() will Just Work and result in a _much_
simpler fix. And it avoids any weird forward-progress issues as no one can
write to folios at that point.

-- 
Pedro

