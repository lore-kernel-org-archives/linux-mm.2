Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593E9C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 12:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DB246B0088; Wed, 22 Jul 2026 08:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AE16B008A; Wed, 22 Jul 2026 08:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A5E6B0093; Wed, 22 Jul 2026 08:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1286B008A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 08:57:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97C761A0185
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:57:20 +0000 (UTC)
X-FDA: 85016413440.02.6308C22
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46BF6C0004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:57:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FG8Vnnr5;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784725039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p59Nbp/0h4piYzBzwlGNI1UeD/BfGw1h5BEhep/TnC0=;
	b=AgQnQIRSganZEWTp+HdeUUqEFu0AellNRRlvaDhLoNDsJjbevmTAgxtdVuN85juzBqQFmj
	wsogPb6+ZbfzAg6QSgWq4pvIv7Y3RYqlTy8Z4ppDex46DXq3k5dq7we7YY1H878M6L0CjT
	Qdxc2QWMp7pmT3UR2zw761b8U+KLcVw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FG8Vnnr5;
	spf=pass (imf28.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784725039;
	b=mEdpysXwnZLJkN9aPNXs07+bej2mw7kwKcVl6CMnOum5T9Y88IPA4tuM7kPDw6DQY7NA+4
	Y0xgJSzOxpamgOloHfYdtDJR9V+yXgjUjkee58zU4HGbLFEJOHSgC/zhIRFMGbPohvo+L3
	0bU8rke17GWI713+ETft1Opj+eDrwCU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=p59Nbp/0h4piYzBzwlGNI1UeD/BfGw1h5BEhep/TnC0=; b=FG8Vnnr5vsMTMQEAvY86l+uFLk
	MFr03IMgedD7PxKczlkMDex/jp2DPkTKFje3UCyjtQZZAkg+SjdPknKc3cowMxn2i6EKmGRSHhKkF
	cJA622u2TDgVKKTu44nTU7Rlb3gfh3GJXCSY6H3Og4K1kpvqIEGvOt+DMqOEiE2rFpXNefa+/Roj8
	43NDfueASEFzxNzaIeGozY4SiAGGrLXtaxHrqBvXh4GMU4yrHaNYH/N6hl03LbudAPHPTQWK0c2Xo
	9JK+ej6shPeaCnznYybCTdecAoTPclBpMXdu3dmrgEqvSxsEAIOsa6LDT+fnLE5vOS4WzoaXz2e67
	4R4wRhaQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmWVb-0000000Fdb3-3ARC;
	Wed, 22 Jul 2026 12:57:11 +0000
Date: Wed, 22 Jul 2026 13:57:11 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org,
	Qu Wenruo <wqu@suse.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH/RFC] btrfs: fix folio lock leak in writepage_delalloc()
 for folios dirtied behind btrfs' back
Message-ID: <amC-J7yzwk4Z5tHW@casper.infradead.org>
References: <20260721191152.101118-1-borntraeger@linux.ibm.com>
 <20260721191152.101118-2-borntraeger@linux.ibm.com>
 <b226a6e9-fef2-49bd-b17e-9f9b015626c1@gmx.com>
 <83290932-cb8b-4741-bff0-6a7d8df2c637@linux.ibm.com>
 <224d56d2-fcad-41bf-afe3-6f5f5108172a@gmx.com>
 <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f12f70e5-d84d-4a9f-ac94-693be4c863ac@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46BF6C0004
X-Stat-Signature: 9f7ahfs4xygntesifi5xmyw7chjn1ied
X-HE-Tag: 1784725038-498211
X-HE-Meta: U2FsdGVkX18mOCtFGfRozmlSkZzt/P5Z6cjmMICs2VsL4StONHKPlNqPMxop4jZs9FR9p/4fxO666qNmq5MfGcUEyMktbkk9Toia78tbJRnN1I5MzJcToHLWrxkxvTt+yGCOctFiWSS758+qX/w33chQ4XE65/Q6u8PqhajYWC9aTgIvYdNTUZzvcvfrDVCpfPQJXkx1ssTyC8FhigLfq88vV07/Cjf7VAnung2kb42G4ool85l61+6umsu5z6JTBZuX8WUcSCI8WtCznnOFLs58DLQyKteK77IMPnFyBmlobbcdE2YJq/N4VLVKqtiw3RMcEQnRlUAnWsGmYkTOY3HuyO3DL//sDfwV6KeJvwwS8n0SWEUtsLAppF4VmilIop4/Rgw7gk5u6tbVYvYInC8alWGqWwmcUflpK5G6kA0EMPHtfhtgMDWJSr8avNqyDxO9VqfwotFCOtdFocgWT0qFyKaJQkMv0gJdw4aIk4Iy6KVODZdnSH/kEgy0sfOdbGm8dRg4dDp+bv9OJvItLNwjsoqABF54PBfz5lo8BrS74LFT30oaFQ5oTFbAo+rcMBvLNiDvflh2WqzLXVdd17RuXv5uBm1O9FZGzEIt618k1M2Q7iX8qBHx40Ld4Gr88yETstmmNScLw+snQBjYP8+Hx1hhWUFkK4LxhgygL7JyrcJVnAq8PfCufR7NjIFpCl+XH3i/cqZct2E+9lLpyfwPu0htuffof5u01iWFDTVeespXP8b1g2XsRe9edmD20HllQVnSnarthznEADduPug4vFjb/C0UGcqJfKJBl3EawNfRPxP5T2dCEikgH6xWUlhypNM3ic1LgpPDjbLT8INUcQsSsr9aG64gKXphhYEVuiVbWyZEB0UsaKqOOyX55K8WItpndHI7D2/no7NX4VlgB56lm+3Qkv6UmELSzpHKD6UptXduYWEmRbc0UlT9ORllAxwvgbgxj5Jcy5w
 WKiSeZc3
 rEz0sY5YedIl0Hh6qDToRVrifgiuBuA0bU3nZiOAiGJMkt9Rgwso9/muaWLTxCjWBmg7XtvdywvVyVeL9IqKtSwTjvpziu5M0n+GLL2Se70D/H752EEb7Bm+0oj6m8id89zjAH2l5qV+w1yzlfCanJZiBEn79D+KkcN5VKzipX8w8o8wivyGexs57ZRS3sv3L1qVCzOFngMnD8pJYoM0AtICWWYSkJylhbrtG3kqk+qpKMDc2A7Nu51TSkFyT8LB141LuVZfnod1sWPvRxjL5Nv09knddBFrHWiW+ppw2GZNYstuMxyXa8arxDUdrHY91o2G+B9JNal2Wv97APrik3Z5vnqHQ73700v8QhEpy4/F7Wno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 11:29:36AM +0200, Christian Borntraeger wrote:
>  *   4. Thread B loops sync_file_range(WRITE|WAIT) on the target file.
>  *      Whenever a full clean cycle (clear_page_dirty_for_io(),
>  *      writeback, bits cleared) completes inside thread A's
>  *      submission->completion window, the completion-time
>  *      set_page_dirty_lock() hits a *clean* folio: filemap_dirty_folio()
>  *      sets only the folio flag and the xarray tag - no btrfs subpage
>  *      dirty bit, no delalloc reservation.  See the 20-year-old comment
>  *      above bio_set_pages_dirty() in block/bio.c describing exactly
>  *      this ("other code (eg, flusher threads) could clean the pages").

There's your problem.  filemap_dirty_folio() documents that btrfs is
doing it wrongly:

 * Filesystems which do not use buffer heads should call this function
 * from their dirty_folio address space operation.  It ignores the
 * contents of folio_get_private(), so if the filesystem marks individual
 * blocks as dirty, the filesystem should handle that itself.

fs/btrfs/inode.c:       .dirty_folio    = filemap_dirty_folio,

so btrfs should have its own btrfs_dirty_folio() which does whatever
metadata updates it needs to and then call filemap_dirty_folio() to
take care of the page cache business.  See iomap_dirty_folio() as
an example, but many other filesystems also do this.


