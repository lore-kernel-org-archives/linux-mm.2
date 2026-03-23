Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D42D6EC01C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A6EE6B008A; Mon, 23 Mar 2026 06:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 458096B008C; Mon, 23 Mar 2026 06:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36E176B0093; Mon, 23 Mar 2026 06:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25F146B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:47:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02A671A0ABB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:47:52 +0000 (UTC)
X-FDA: 84577002426.27.05795DD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id C68DC1A0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:47:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uh9FrYGB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=smn6tA+A;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uh9FrYGB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=smn6tA+A;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RliYgQJC8jQUhkPteaeL8ZeUHX19DiNVUvaChowf08U=;
	b=W6zMb6hK6BzHyr/K3a+eG77ZTfEtxqgMO41nYJqO3ZlMRZZK8W30el/NEFw1xZCJF7pL9l
	9hnYGuvg7HJX7vykevpnhcUs9J4FoA70MYOgRKr8dctathS0vgPivsz4crBqFMWY1RbI2m
	N16lcpdUDbyik7VOA6172Nygd2Z3Hn8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uh9FrYGB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=smn6tA+A;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=uh9FrYGB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=smn6tA+A;
	spf=pass (imf19.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262871; a=rsa-sha256;
	cv=none;
	b=M9+MAQbhSYkIfvEoHsClBO9F80RcneFHHAfPTIEecIVKUVc71HhHa9FihIUU3ZcJ76ttmd
	0GtYHtLWTMfXmqHwfIvdw3iS48ZjYTqNFvPWn0GLjxV6We/Aw+7+oKpfFyS7CHwykk5wR8
	YbiLfOP3qcuXBHIl78QpcHS9R6sm/EM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D58034D2A4;
	Mon, 23 Mar 2026 10:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774262868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RliYgQJC8jQUhkPteaeL8ZeUHX19DiNVUvaChowf08U=;
	b=uh9FrYGBkxG4m2NSz3fJmo1Oyc+toviFsNlJ5KFZmjTPa6Cw4M7pQ7oDK0q8cZeHwuGFMD
	iLUIqwoo6RhsD/q1jNSM09aLtv+8r7wRsTpUgEVO0h17y4ykFJCEyNaOrj99wjvNCS9V+N
	1Gqe4iQUv45obzUx9DVHZbEEr0VoUFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774262868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RliYgQJC8jQUhkPteaeL8ZeUHX19DiNVUvaChowf08U=;
	b=smn6tA+AL3m340ugt/KV6xLX/8KgpJN8+2karVG1eldOuAF6Gz/4XIJ2A9lOe3+PQQ794j
	+oxrXxhNxqjT3MBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774262868; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RliYgQJC8jQUhkPteaeL8ZeUHX19DiNVUvaChowf08U=;
	b=uh9FrYGBkxG4m2NSz3fJmo1Oyc+toviFsNlJ5KFZmjTPa6Cw4M7pQ7oDK0q8cZeHwuGFMD
	iLUIqwoo6RhsD/q1jNSM09aLtv+8r7wRsTpUgEVO0h17y4ykFJCEyNaOrj99wjvNCS9V+N
	1Gqe4iQUv45obzUx9DVHZbEEr0VoUFk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774262868;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RliYgQJC8jQUhkPteaeL8ZeUHX19DiNVUvaChowf08U=;
	b=smn6tA+AL3m340ugt/KV6xLX/8KgpJN8+2karVG1eldOuAF6Gz/4XIJ2A9lOe3+PQQ794j
	+oxrXxhNxqjT3MBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2642A4382D;
	Mon, 23 Mar 2026 10:47:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Q3kPBlQawWk3NQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 23 Mar 2026 10:47:48 +0000
Date: Mon, 23 Mar 2026 10:47:46 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Abhishek Kumar <abhishek_sts8@yahoo.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, syzbot+606f94dfeaaa45124c90@syzkaller.appspotmail.com, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH] mm: fix data race in __filemap_remove_folio /
 folio_mapping
Message-ID: <zomsk45mkrop54w4iijusollwafixqul6zrgzczghenrpyodgg@bgo77hcidmko>
References: <20260322190319.85301-1-abhishek_sts8.ref@yahoo.com>
 <20260322190319.85301-1-abhishek_sts8@yahoo.com>
 <acC6P6ULWgxKXFiK@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acC6P6ULWgxKXFiK@casper.infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C68DC1A0005
X-Stat-Signature: m9h41knkew4dgpxuboku179fgdzweqjz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774262870-567781
X-HE-Meta: U2FsdGVkX1+5KuOSAKvrfdlmA8H/adV/hQOvlhZmbVDHTI+FtBhVZYzmUSil4cIYN4QBuVsXNwkSXmkQ+LUW/q0vtNCjfM2smpxJIMXoq+vd6ygYS17nD90RRqS9ZbUxtp7X/GQuCCbnFB+AGjxmcY6K60E39GKlaCk8LxlPFf9HP/1P3O+WPXmZ1xAmxaEYKiIgQuui64/PHmWFEu5mYTdRWbYxaDDRWw2RMiOtXxlUQLDacsgzzM9bmm62+xO+cp3LE4HtUWB1imZfa1+ARMjMv2p2U8j25q2De5UDr4lMMfdPemFfzvxuUV2ig37W8q5lNSu+WzZFZJn0XQ62FNHYLq/JRvLJovTvdFjfrDCMVuWvSWWvIM8hmZ8D0cWOuFwnThJRW/hwwMu1kmRGVfuqfzukQEkOths3aGuxy7maKjNfHdfsNIpt3YrikK0l+q73EHzys+W769vMtKUbJ+PLECizSIcDh7qCQZljYRX8bwXld2Y4J2KLvpsrGK4Bwa1gKyjBr/hGe8X6rBn4vQQ7x2hGrfrRvqkLIdnmDqGkl3OahyZ8mpVsKOq6yO21SFnuTOCASk2rMasnxTKrd7muMfYqgDL0xoeI+K40akPVXGlej0ZX6U8f5ZPZ7WYigGH1x72qFGFUdlktB1agOur6dyUV8oH+7rQbCoFIlSouOLBndrNszNVkPvwIqyFoYiLIBwESTtD+E/GReKbpn8CWoEVl/JZG3Lb+cwxwwfBjUZ9zyutgq9VI4vMqXUKuhNIu5ckbBlazLUmaoMy1xZteDaez+NRoeNQ3qaZJObqITZLHFZNE/HmiP+E0Qf3c0iOPDk2cFhgqEPWG3oUaM/YTnFnQ1tRDrpWsbG4M0vP8VB6WF/ZPFHR8BGBUPGM5K5ZmL+IIbJtAMMKTyxeoILk0O92Q/KbYjx3jYnHXsUsClVKHeVMg3zszjpyJA7OU8DqplO1YDXj6jOd4/c7
 iC2pZEcG
 +gIVKZm7LOmv51y2v9Ku6ey7F1sP5500bTuAVTp2SDTvNBE4nbY4aaJQKuaXOk1TmhPVWafwPjwpWB9lW2Ch9bDRqRAGTVDCR+/sJ/AziYeSnwCRO2a3G8Pxa0lIDjlG8XLJvsysnGJSNuSfOb1lKMR7IxEL7VH9HMYvd9m64oNUwyBpfLHTkLssGWhvB7A3lqOv/rKPHXsB7P6YAg+h9jTcoaSVEap66T29PIs3gIiCwPZqYx1vV09/35Gu+syeJYD4AJcOoC7wJPh8pAAAqoNVQp/9vG7c6nGFq7prVRbJow6TtuWxKe6T9/KjY2HCXKRoa5LNtUogxBtvK47d4HTr7CfH4OTuglofpy8g8opp0MrKWiMvNHyQhx/ViT0ENjLXmCO18EZ36Bm9FsnFqFYeHWWShI8RizFB8VJUAFHFja1s6hD5fg9BiORPEAf85E2dc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 03:57:51AM +0000, Matthew Wilcox wrote:
> On Mon, Mar 23, 2026 at 12:33:19AM +0530, Abhishek Kumar wrote:
> > KCSAN reports a data race between page_cache_delete() and
> > folio_mapping():
> > 
> >   page_cache_delete() performs a plain store to folio->mapping:
> >     folio->mapping = NULL;
> > 
> >   folio_mapping() performs a plain load from folio->mapping:
> >     mapping = folio->mapping;
> > 
> > page_cache_delete() is called from the truncation path under the i_pages
> > xarray lock,
> 
> That's not relevant.  The important lock for maintaining folio->mapping
> is the folio lock (see the VM_BUG_ON_FOLIO line in page_cache_delete()).

Not only that, but holding invalidate_lock or i_rwsem can implicitly make
the folios stable by excluding out truncation.

> At a minimum, this changelog needs to be fixed because there's already
> too much confusion around the locking rules.
> 
> > while folio_mapping() is called from the reclaim path
> > (evict_folios -> folio_evictable -> folio_mapping) under only
> > rcu_read_lock() without the xarray lock.
> 
> Umm.  First up, this is MGLRU-only code, right?  Adding the so-called
> maintainers.
> 
> Second ... I'm really unsure how we want to handle this generally.
> This could be quite the game of whack-a-mole; we have many, many places
> in the kernel which dereference folio->mapping without holding a lock.
> 
> Perhaps they are all fine; but 12 of the 455 references to
> folio->mapping currently have READ_ONCE attached.  That's a lot of code
> to audit.

Yes, and a lot of these just aren't trivial to prove 100% correct. e.g:

fs/ext2/dir.c:

static void ext2_commit_chunk(struct folio *folio, loff_t pos, unsigned len)
{               
        struct address_space *mapping = folio->mapping;

Racey?

int ext2_set_link(struct inode *dir, struct ext2_dir_entry_2 *de,
                struct folio *folio, struct inode *inode, bool update_times)
{
        loff_t pos = folio_pos(folio) + offset_in_folio(folio, de);
        unsigned len = ext2_rec_len_from_disk(de->rec_len);
        int err;

        folio_lock(folio); 

Maybe not, but we don't revalidate folio->mapping after the lock. Racey?

Then you look at the ext2_set_link() callers and it is rename, which holds
i_rwsem. This plus the reload in filemap_get_entry() should make it sufficient
(and excludes against reclaim whacking the folio).

But there are other callers of ext2_commit_chunk(), etc, and ext2 is by far
one of the simpler filesystems out there :)

> 
> > The race is benign since the reclaim path tolerates stale values --
> > reading a stale non-NULL mapping simply results in a suboptimal eviction
> > decision.  However, the plain accesses risk store/load tearing and allow
> > the compiler to perform harmful optimizations (merging, elision, or
> > fission of the accesses).
> 
> I think the bigger problem is reloading.  As I understand it, this code:
> 
> 	struct address_space *m = folio->mapping;
> 
> 	if (m && m->flags)
> 
> could end up loading 'm' twice, once before the setting to NULL and once
> after.  That's more plausible than deciding to load byte-by-byte, or
> whatever else these "merging, elision, or fission" words mean.
> 
> > Fix this by using WRITE_ONCE() in page_cache_delete() and READ_ONCE()
> > in folio_mapping() to prevent compiler misbehavior and silence the KCSAN
> > report.
> 
> Just to be clear, I don't object to the patch itself, I'm just scared
> of the consequences.  And the locking comment above needs to be fixed.
> But please wait a few days for discussion to play out.

IMHO this looks fine, particularly as folio_mapping() is practically
mm-internal (but there are some other users in fs/, for some reason).
And shouldn't be problematic as AIUI KCSAN will still report WRITE_ONCE+plain read
or READ_ONCE+plain write races.

-- 
Pedro

