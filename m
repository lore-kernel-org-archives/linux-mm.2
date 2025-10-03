Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22EFCCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 14:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50B278E0022; Fri,  3 Oct 2025 10:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2A48E0007; Fri,  3 Oct 2025 10:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8948E0022; Fri,  3 Oct 2025 10:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2DED88E0007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:05:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04BAC451E1
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:05:06 +0000 (UTC)
X-FDA: 83956974654.09.E1FEEFD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id A82FFA000F
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 14:05:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Lfl21iMe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XA88JfIT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Lfl21iMe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XA88JfIT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759500305; a=rsa-sha256;
	cv=none;
	b=6e8PvasEriiaqLoLnCjCqvsf5OjPdg+NEjJlsDcRrwejuPdBTLsyG5gv4CJ/QT9kM0V0y1
	UDR0EX3zl+quH4VWfE5Tx3ATkttECh2BFeLq9Og3LxRGUdJ+6a6ASDnwuQUAtdonBMpp9h
	One1YVTR//Pwl/7GD+AzzKBHDthvwr8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Lfl21iMe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XA88JfIT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Lfl21iMe;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XA88JfIT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759500305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YpYYO0WBQtFMfWk/eRAGiKMSyw4qTIIMBy/MJIROsA=;
	b=bm0fa65esp/hdTFl1Wo6qVdaTb9STqy5HTeMMxUjBA1FVRCZ2LENpj9BLiHJKlHgJHBv46
	joCekN3NUDDgkPgL4Q12AZPyz/7RMdfPkL7DfLvDx6K/tW13tsuyapx8NOlnhZzjKKEv7l
	nD5kCW1ZgJqN3y4Fyq/PleKhas1C6NQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4B48F3369C;
	Fri,  3 Oct 2025 14:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759500297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YpYYO0WBQtFMfWk/eRAGiKMSyw4qTIIMBy/MJIROsA=;
	b=Lfl21iMeOXn9an/HNoczt8yAM7N6QlUDuUmND2LaXT4q44WYxSnEOPNOriKBMF9OTY45VD
	swOKCcEvBwOSXbI7J8ANiK0KNAGQYz7bF+bfruMp8b5zQ5Reh9RFwkI616rKveeE0VT86x
	9NPib4BxxiitGJFUH4jnHQn5c1Q+dYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759500297;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YpYYO0WBQtFMfWk/eRAGiKMSyw4qTIIMBy/MJIROsA=;
	b=XA88JfIT6APbj4/v46502XbSA4Hl+UJMJrnkQ9gDNvHARPrj9sfvoCqrVzXqZ6RBTKsF9z
	O180MpyW5JA2xBCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1759500297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YpYYO0WBQtFMfWk/eRAGiKMSyw4qTIIMBy/MJIROsA=;
	b=Lfl21iMeOXn9an/HNoczt8yAM7N6QlUDuUmND2LaXT4q44WYxSnEOPNOriKBMF9OTY45VD
	swOKCcEvBwOSXbI7J8ANiK0KNAGQYz7bF+bfruMp8b5zQ5Reh9RFwkI616rKveeE0VT86x
	9NPib4BxxiitGJFUH4jnHQn5c1Q+dYI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1759500297;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YpYYO0WBQtFMfWk/eRAGiKMSyw4qTIIMBy/MJIROsA=;
	b=XA88JfIT6APbj4/v46502XbSA4Hl+UJMJrnkQ9gDNvHARPrj9sfvoCqrVzXqZ6RBTKsF9z
	O180MpyW5JA2xBCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DB30513AAD;
	Fri,  3 Oct 2025 14:04:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Yo1oMgfY32jrTgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 03 Oct 2025 14:04:55 +0000
Date: Fri, 3 Oct 2025 15:04:50 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@redhat.com>
Cc: Byungchul Park <byungchul@sk.com>, akpm@linux-foundation.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, clameter@sgi.com, kravetz@us.ibm.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com, kernel_team@skhynix.com, 
	harry.yoo@oracle.com, gwan-gyeong.mun@intel.com, yeoreum.yun@arm.com, 
	syzkaller@googlegroups.com, ysk@kzalloc.com, Matthew Wilcox <willy@infradead.org>, 
	linux-ext4@vger.kernel.org
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <dglxbwe2i5ubofefdxwo5jvyhdfjov37z5jzc5guedhe4dl6ia@pmkjkec3isb4>
References: <20251002081612.53281-1-byungchul@sk.com>
 <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a586b5b-c47f-45eb-83c8-1e86431fc83d@redhat.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A82FFA000F
X-Stat-Signature: q7tidxje15issrob6suez89sz16u8g66
X-Rspam-User: 
X-HE-Tag: 1759500304-805600
X-HE-Meta: U2FsdGVkX1++EGh+FY/39zrsA6nqZTevDqxOxJwWu+u09/NbtTHst1enSZcjLVj+WMlXTn/gwG/rNdvswkWIIgfsK8VYNTz6h+3AKTxwYUj0eFNf9xLyDeO9QJuv1ouiAOIfzakjUdvIpJGXr3Bs6C0Ac2+40parrThuFpFGiz4KOec67dH73+TXhZ589MOYbMN83jk+1r69jm+pGrQ9ozTKTeb1H2oa5xJAkbSyFAbZf33/FosN1n74QyPGDak+CYUFEQunLdcvBgudDvav49cgfccD9VCEz47QgTSL3JxjT0IU6L8V7lS35qsVAPVMUwoCLRbP2xMSNQcUbVmVYGHprF4BtWJL2b6SN+og7BDcJ5Dkhcdy8JZX/SRGjKysxSuhCZbLFO9mciLZ8dpmNw7FawafJL+c+gwtd8D/xGRLQeBxA9LgMEPAdtAMRa5uQBwzpn2ul/g16yRoihhLAbkGXAlb47YIkgNio5N2B+5gIMrHajw/0hIokrvsnZBQOLlgA70+8sW5N7ncgbkFgBmUv5wcjhhruRSrNNo4rg6zu17oh/zqewXXK4DFobsIJkjGcd1GjxAMBWFSe/JT7+TsDw6FPLcmDVqnVJGllOMQ8tSJokMZ40/RLQ4EurM2UT/uOukXvorLGRNTdyc4qkA3vjvQnXOzBF03cJJC5mdwVMTlY7op1L57QG5UViz6WYWsqaveOcTdnhDFkIVr9BJk4IE9fpnpTidaEdBwkwnURPJgDZn48eZec2FjTaL4JEv0qrfnBLnjlEZSvurlx4jgU5quyb+oWu3zgIOex7f+9QDN11ow07BbxCGWmyRPB76os1erjj8gRMKSJal+Y2MRsxPwnKl21DjE/gPfQ93ixiwBEloh6y7LjdS2s0HNNrh0sCn6wkac395Q4EIzhUV0d1v6ArIB5Jx4+KJ1PWiqhjP72azMjbyDljbAVYtMgx5Ef6amnqWBy5knd1b
 flp8UnXG
 0t/Hw0noFjaO/z7wGWWU+kkVv1ATm5ktWOcZjiWVEL54uCs4k5AwT5XfzmBCaDlkBdR+cihhbcrJggbLVxtvVdedSaE2NAEwJBFuDlQlFZH9RD7mHxxU2zWo5ahnNWrKsUeg821JPLR+Xj24rlu2CbH4KirW50zeE2z5t78xJ34O1FOmQbavx7HR21XjVNYu0aHl4JbVa0jLSKR6ifmcGXSkfWUD7zDsPSo+n/z3dCvO3fqn3RsGhtLKAYklYfVc/VZYq5BHRvSe37bAQ/R1VfeqsDKUR4jD9fhOeD/dKXwmu5his3u+NLWpFkMWPkaXU7GEdDukf0OJfWTpFkwg1UGV/MbWoDNLrmvUcaOvi5rgEsv0EYtk7kiQhiRxsyFPirYB4Bhp6DQmbCagfaEBhEodxwO2vLR7blaJ3rh37MyWfhBE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Adding ext4 list to CC)

On Thu, Oct 02, 2025 at 01:38:59PM +0200, David Hildenbrand wrote:
> > To simplify the scenario:
> > 
> 
> Just curious, where is the __folio_start_writeback() to complete the
> picture?
> 
> >     context X (wq worker)	context Y (process context)
> > 
> > 				migrate_pages_batch()
> >     ext4_end_io_end()		  ...
> >       ...			  migrate_folio_unmap()
> >       ext4_get_inode_loc()	    ...
> >         ...			    folio_lock() // hold the folio lock
> >         bdev_getblk()		    ...
> >           ...			    folio_wait_writeback() // wait forever
> >           __find_get_block_slow()
> >             ...			    ...
> >             folio_lock() // wait forever
> >             folio_unlock()	  migrate_folio_undo_src()
> > 				    ...
> >       ...			    folio_unlock() // never reachable
> >       ext4_finish_bio()
> > 	...
> > 	folio_end_writeback() // never reachable
> > 
> 
> But aren't you implying that it should from this point on be disallowed to
> call folio_wait_writeback() with the folio lock held? That sounds ... a bit
> wrong.
> 
> Note that it is currently explicitly allowed: folio_wait_writeback()
> documents "If the folio is not locked, writeback may start again after
> writeback has finished.". So there is no way to prevent writeback from
> immediately starting again.
> 
> In particular, wouldn't we have to fixup other callsites to make this
> consistent and then VM_WARN_ON_ONCE() assert that in folio_wait_writeback()?
> 
> Of course, as we've never seen this deadlock before in practice, I do wonder
> if something else prevents it?

As far as I can tell, the folio under writeback and the folio that
__find_get_block() finds will _never_ be the same. ext4_end_io_end() is
called for pages in an inode's address_space, and bdev_getblk() is called for
metadata blocks in block cache. Having an actual deadlock here would mean
that the folio is somehow both in an inode's address_space, and in the block
cache, I think? Also, AFAIK there is no way a folio can be removed from the
page cache while under writeback.

In any case, I added linux-ext4 so they can tell me how right/wrong I am.

-- 
Pedro

