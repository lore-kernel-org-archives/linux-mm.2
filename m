Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78C78E98FB0
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 05:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC246B0005; Thu,  9 Apr 2026 01:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C696B0088; Thu,  9 Apr 2026 01:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892556B008A; Thu,  9 Apr 2026 01:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 729D16B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 01:51:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19B141403D8
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:51:08 +0000 (UTC)
X-FDA: 84637944216.09.D223B60
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7526E1C0003
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 05:51:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="2jwv1M/T";
	spf=none (imf21.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775713866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SevTQiMUPxnzE7hB73BHC4x9bLPrhVzNNZ0TFANaSpM=;
	b=lttRtuhpEuCuvX5FEQXuncXDpCbGNjVS2Q//8zlgk8wmY2RICH7EYw1xSFiFj2OnpmpqlX
	8mm31ahXd8rIufCRVFB3cPjgWyexW5jWG3NB/Hp2ddt8Lh/r8VwvzzAftInNMxQIpFmRaG
	6Md89NYL5mQdQ8n/TmlvlFPaYDtKNqs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="2jwv1M/T";
	spf=none (imf21.hostedemail.com: domain of BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a4de8e1a1e27f13a2878+8264+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775713866; a=rsa-sha256;
	cv=none;
	b=zSRNFHxaY/VNrE5S0g7MdanThX43LQCfiy8irHZjsLavshRlOBeTxylaKwZBmHVvoEFHuI
	KbuGFBYQcMmSIfDJXsrhKMoJWtHOBh0Q8zWLfJuwR5FNc13aWAU30fFKjJdXYAhjP7UucM
	mGKnQUOCeDcLVQUZ5l8jfts6eYotYV8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SevTQiMUPxnzE7hB73BHC4x9bLPrhVzNNZ0TFANaSpM=; b=2jwv1M/TAmBmK5jU+sXOIOzevv
	5FsTHueWHde19wdB+LAf827ZaszQ0qO37U/NRQfwdy85NEJ9Sr68n7oGkdBAPLx6+OT9Azk9xzGAF
	PwGijCAQkymLFrwlWLQvwM+FvmlKmLnmOVXxNUF8PIg3mWAC0QitPNrHF3KJgmZAQTpvk+2KW/xSQ
	dfhW3OvCiJkfQYD0mddjkrEqm2Mt4iTaX7ZYAhdlugkPQL8UcOcYKGUZhLuvC/oKl1tHnW1mNNCnz
	sByYSlLk3+l7d01wRvp85DK6stgHw4yH8zvNB6/LqYU8osGmsVHTK4C/SJFxGc23xN/pB7evMA02t
	QIF0eABg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wAiI7-00000009jXc-2g7T;
	Thu, 09 Apr 2026 05:50:59 +0000
Date: Wed, 8 Apr 2026 22:50:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Chuck Lever <chuck.lever@oracle.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/3] mm: kick writeback flusher instead of inline
 flush for IOCB_DONTCACHE
Message-ID: <adc-Q1iDWHD5yxHH@infradead.org>
References: <20260408-dontcache-v2-0-948dec1e756b@kernel.org>
 <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408-dontcache-v2-1-948dec1e756b@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: num18f5tehe65i8767k47ndbjfy49i3n
X-Rspamd-Queue-Id: 7526E1C0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1775713866-319012
X-HE-Meta: U2FsdGVkX1/Gx9i41sKC0UVDK83ze3y43xpS+a3ac+MXi3BYwMc647kaYTOL5pncaxalQQzFQENs6ezxUxiErbAFbWcsLzhwYtZLe5wvqnWDENEZS2T1+AfFaU7Wyz9ODqV26cT2I+rjZxdlPoAlR3E5eqWYPlgOMPTfVBudmZlMwxJejEZGF8Oce1EaSYOqVYgfyKpV3MN9SWz9U89y0dCYiIqpcNqY8JcaYyi4lL56JmF50DKb5+Ij3Mqcr/0h3a7iZlncIBCh9RpYwkXDKS/CjOfFDo7Z4NwEJidzXTGj6cEzPQDdcpq+4VS+GedEC6iKrnOVCyfxIW3acC9oqL9uOUmh+LzXF1nYGUwBTIyBlbTcoLF+ZRBSsFnQwqHEnhiaVKwgu+dwI8dT3ojCmoIs1lWlRWnPC7zR9nZVDTsqInKC5WkQCWyBOg5hL5V1h3tbiIn4LNvTH2uEg9pNV69OZ6M0W7t1ConWnKK7ra9E5S0jK01zh0dg5wXAWzEUVpDy/JXf5D3H8EyJ1uImwA1YACAi4IwIgh3JjifS7Fshho5+iER8IgIaYIndfgzupCsMt5M9rMB0Qo5wYkv5TxaG5IuE/PrChkG5I4zsjWIrqCxbEI5n8lO9hpDdmNQ73JI43zBf2kd1TCT7CnJaA+L4bxjtKdILRRF8BU8fcjlcyRjGvTBStJoYFTiPeCRrnLmh/IchrxkhUvO9EzyuMk+0o4tc+M07133SqQzLZUuoVXNpzt4ll9hbqPACJpyAEwEzbYDEa1zp9c9DZQ5y8K14Tnwg+qKQ1G9o3bZ+I/0DE/SDIsGzJ0IkmU7M7Bx/+KugfCG5/mSN8Q3QoDc6cIoRqaiUGIG2yGFtCnyHTGf4zTxBI72e3IZv0qF+KehRIRjeEyaOdF6XGCmx6bOgdoicVfE6c4nfDaYjuJT1oqBcrW3t3YE2MXxMMwxVxIKsuHpNQW5bMJabos32W0u
 7B0QU3lG
 oIfUuZjE4mvf2Euc4xUrfGu+7n4KvR2HxgowYwq0ouqnSlNZQpw4SRT8wWcWenMlKM6fP0oXCoXS8fEBPC6BF58NOclfSe0ZP7yXhLilk3sAhCetN9CvrAiBdOIjbVIlYZ6oDlB1Zflut4QXnBImVc9y6wmill9LTL/UnY6xB8di5KgrshuJFHjlQW8FTekTcehLzIg8mTA4/26HwlLznXprwLC2ntjWGlQKN4csuwtg/7IN+seT0tOALiA7WeKegUKpUK44voEro+AXA+348MkBo4LFJX719Pys43dmZh0H/R1Qr2Nspd9WOeKgxhua4VvrG59bfhbuBgIYmuyp+kRPxUZ9PuxFGJp/n/9NCx4rOM9eWSpAaMTeoj3xo4XpG/6G4UdG1vOwkQcPUHQUECDRqqz177Wbpq1A5qGBgk6kmtCeLm44syP6Qa55UeIBUPq0Iul2SMfLXSCoWBIeoqv6/llyX1wCIW9Bo/jRbroK9L1rif4d8WQhj/pMLFadFTr1AIliwyFAN3pPLIGV8HR0x/yaPCSxf+Nnc0F2jkIcbHfo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 08, 2026 at 10:25:21AM -0400, Jeff Layton wrote:
> Replace the inline filemap_flush_range() call with a
> wakeup_flusher_threads_bdi() call that kicks the BDI's flusher thread
> to drain dirty pages in the background.  This moves writeback
> submission completely off the writer's hot path.  The flusher thread
> handles writeback asynchronously, naturally coalescing and rate-limiting
> I/O without any explicit skip-if-busy or dirty pressure checks.


Having numbers showing the benefit here would be very useful.

> +/**
> + * filemap_dontcache_kick_writeback - kick flusher for IOCB_DONTCACHE writes
> + * @mapping:	address_space that was just written to
> + *
> + * Wake the BDI flusher thread to start writeback of dirty pages in the
> + * background.
> + */
> +void filemap_dontcache_kick_writeback(struct address_space *mapping)
> +{
> +	wakeup_flusher_threads_bdi(inode_to_bdi(mapping->host),
> +				   WB_REASON_DONTCACHE);
> +}

wakeup_flusher_threads_bdi ends up calling wb_start_writeback eventually,
which sets WB_start_all, pushes the reason to start_all_reason and then
does the actual wakeup.

The flusher thread then through wb_check_start_all does a WB_SYNC_NONE
writeback based on get_nr_dirty_pages.  Which seems wrong - we don't
want to do a huge writeback evertime the some DONTCACHE write finished.

So I think you'll want a new WB_start_dontcache bit, a new
get_nr_dontcache_pages() helper on a new node counter, etc.


> +EXPORT_SYMBOL(filemap_dontcache_kick_writeback);

EXPORT_SYMBOL_GPL, please.



