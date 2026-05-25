Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E14CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59C9B6B0093; Mon, 25 May 2026 01:25:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54D206B0095; Mon, 25 May 2026 01:25:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FAB6B0096; Mon, 25 May 2026 01:25:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2B96B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:25:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C37411A0159
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:25:46 +0000 (UTC)
X-FDA: 84804805092.23.0ED2E46
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2BA5F4000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:25:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2D3kGnnE;
	spf=none (imf27.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779686745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbF7MJcCgIyAYXJD23Ro/8c5fqjTJVY5GxCFHAVpzuw=;
	b=2JaJdLJREtmm4KkfMBJVNEqCIt3rr4YMhGb4xSschXDGFrrazIc+8VHuQStwT4xLRkmn5W
	6VKk3j8eLT7VNijUUnyhTDUEKChInRRYDhl3D648/D05RvHm5yttjyKH0nWUScxYHKZdc7
	pznrY8FmNXCxVde1NIFuHQ1/hF/P71I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779686745; a=rsa-sha256;
	cv=none;
	b=bEw8CfvMAg0ayd02I2Ab/coSdfjmz625UIGoAQqNksZwdF31RwHKzkmMHF1ICLHLo8wEyr
	6wdjTDVje9L03fOIGExPfY/O5PlQo0fmEz9Jz/Q1ofQzFdD0ttVpGjII10ZpPxoPOHly/b
	d5hFHBnxUWxNkS11QtjHngtD+oIgpYs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2D3kGnnE;
	spf=none (imf27.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dbF7MJcCgIyAYXJD23Ro/8c5fqjTJVY5GxCFHAVpzuw=; b=2D3kGnnEPa4tteIstuM+in0UvE
	LjeBx8ypFM5ooVAOA8OTtXN/xgEtB19J9VaFXQ8cnLUHS1ylPfHvIPwEBelKgbQV6/czNp6RAqMco
	BRSO9/6fowpf776p+3OcZnNayjzGcKBL4si1XlWyby486whG8YsUUhcVatRYSX27wrNg/hm9vx8wR
	71rjXNlyO6s4hBrS2FYFqvX1W4SMCCyp2mXlOEcKjj7gtYF+mc3kS/I2UIp814X41CawZ5HeFzNML
	whtOifCXxXuh3Naltgb59vHRlxLUxFODiui0yiXcd7D41akJCHw8WQ0CyITPVgzKOUZFF1PY3qz1h
	PbxYOihQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNos-0000000GJqa-1Dxg;
	Mon, 25 May 2026 05:25:42 +0000
Date: Sun, 24 May 2026 22:25:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 3/4] buffer: add dropbehind writeback support
Message-ID: <ahPdVoZdW5WRePbb@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
 <d98a35c1-882b-4752-a2c7-378872fc97a3@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d98a35c1-882b-4752-a2c7-378872fc97a3@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BA5F4000D
X-Stat-Signature: xaxhzz64o5877zyo4btqy79jfsq7dap6
X-Rspamd-Server: rspam06
X-HE-Tag: 1779686745-722464
X-HE-Meta: U2FsdGVkX1+pQNaEydf7HSp4J/BjJPwTdOvmNrrvkihJfNyzzFjixyG0/utMMGHsHL1Q5HQdCmFw5k9bJs95KEaPzWFmoo5Ah6TjH/mos9RKM2AjcC+uA2rOlQxwZo8hv+j9Pk5t1GQDNT1W0Cjb9zl20GAAqSH5rA9airF9lb6dyJrQj5Egpk4ZNPtG6vgS6puVlb7zl7YddURQww9N4etsORJvSnnpuw4TsH4g5jc2g/TQOWwxTRirzLUubREBBZEA28TU33JlyA1MJ3Vk2YgElJiDUhy2U9OkfjeyrVzy06FDqpWUDTeWhGKNUhVQNLyrTAwF5+uyCYN+mxA4RRw5sBzS2TVyIr9eaFJxDfamr/x3j0+sbvbJyWC1gbTErnDM52qUVRSf2IbPa/yVwqyveVKhP5bYnlGByQCJymguFroBo5PAOom3f/81p8HIUAuwhn5qh7SRS2JBxPJTVXpmbm5DbqgITMQnUctiyVRWhCX1ZEX/FB5kzbHj4tsCgxF1EUE8AgupKoh1cjy/QTT94Ot/KG4w0q0VzUsAfyvDj6fT1FFNgL33NtzioY/JTFzoWXONTiEQi4Ipk5AR7b3OveRFTmiNz6vmghChkwrx5iRsVfOZjFM0upX1CLckizSxle+kvpK+L1dAv4lSLDBTVx9TP5VybnshEJrg46qrH15O/szGZ2d4HbKkYc6a5yyU5xH6qX36rwUARQ/Udq1aBWo1vYnOn77gTMXBSVtYAWQu0zvN3gyo8kWiM8A2eYmXwjuS6B8J0aIii0KrxppJ5agk4sAMJ8HETYtC37iQiFJqKWbPJOZgRV/zrKFlVky+LbwFKVp+6qexb2wmHvi5vfq7Gm9un64y2H4ZccinTQDQ1uGe+sG/zNKDknOn+7SLkALEwhpxr8CRT0zJH2jGQuoLV7FA3k6b0FySoWHYvWjsFA9VX2C7WzlkQsVoLxXNL71/ky9iucb4G4A
 gwOos88H
 66OnEL/gQ7QH9nUQEb078aH4myhU61dJPBbL2jV6BMq0L6hKWeqbBU1c1h2Sa7gKWN0rjEP5HYTL/IgQrUbXHlXwVI5/+TEBEkogUXi46PeJRT/p2uXTeDh2qBOT7HjQr0x43dp+/CSqT+jVoxndEX8gk2l9wwY2EDagDPbfaDjqZMFFtHyHn3n9YeMPH31pzaSbjxWe3T195K8A2eLS9313FMMf2wJJhtNbGHTnQUIosgqEUgNhHNoejqS+auXluRY8woq+I7oDa+ipyBkz7I54B/RbeCl4e/di2DICuEUEpCB0+tvQh6SDupe5ZbroouzzUqK/F9BQ3abSLhHyumkAdJi6XbfbxZlO53yqbcU74zYNHAKzlYTrb4Wa4/dgHglySCCGS0ejunVK35XvJ46NSbyruDyzP7Qjew/y6TIxm9n8k7mIt+cjfxBISNZdHYjSSJapZsoUsulMIIrCv1/A+qyDrpPecB0n/OZDuO8WeUrZY4nTrR3nHjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 07:14:46PM -0400, Tal Zussman wrote:
> >  	if (IS_ERR(folio))
> >  		return PTR_ERR(folio);
> > @@ -2160,6 +2165,13 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
> >  	*foliop = folio;
> >  	return status;
> >  }
> 
> Q: "Is an EXPORT_SYMBOL() or EXPORT_SYMBOL_GPL() needed for
> block_write_begin_iocb()?
> Since the legacy wrapper block_write_begin() remains exported, it appears
> filesystems compiled as loadable modules (like ext4 or fat) will encounter
> linker errors if they attempt to transition to the new API."
> 
> A: Can be added once filesystems want to use it.

Yeah, Sashiko is really stupid and counterproductive here.

> > @@ -2715,6 +2727,9 @@ static void submit_bh_wbc(blk_opf_t opf, struct buffer_head *bh,
> >  
> >  	bio = bio_alloc(bh->b_bdev, 1, opf, GFP_NOIO);
> >  
> > +	if (folio_test_dropbehind(bh->b_folio))
> > +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
> > +
> 
> Q: "Does this add unnecessary workqueue overhead for read operations?
> While task-context deferral is required for asynchronous writeback completions
> to allow folio_end_writeback() to sleep and invalidate the folio, read
> dropbehind invalidation is handled synchronously in the reader's task context
> via filemap_end_dropbehind_read().
> Could this be gated by an op == REQ_OP_WRITE or op_is_write(opf) check so
> that read bio completions aren't forced into a workqueue?"
> 
> A: Seems worth adding a op_is_write(opf) check to avoid deferring read
> dropbehind completions.

Yes.


