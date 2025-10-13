Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65009CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 11:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1ED98E0034; Mon, 13 Oct 2025 07:59:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CF3A8E0007; Mon, 13 Oct 2025 07:59:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897BB8E0034; Mon, 13 Oct 2025 07:59:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75CBB8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:59:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4783913ACC8
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:59:34 +0000 (UTC)
X-FDA: 83992946268.20.7F8510C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01ADE180006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:59:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="YMlz/os4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ETy4GHph;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="YMlz/os4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ETy4GHph;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760356772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65YchmjaU4/afzOfYncGWxSpSpwMbIPUmdJHCVAQsJ0=;
	b=cX3uFPxJ1V3GHyu9BX5eMYtel5Nr3SRvIsuAv/+Xc8U7Qnoa4qdgiG/3IKlK99Qfs7aUGW
	PT7DXNmBYL05FOa/ksLQDvHr5J8RDGqFnthQlbzGPknJP3OLUBlSMXVAafsxyq1YmIyXty
	lfeGb+OBda9gqSuh7oFDICH1lMZY2Iw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="YMlz/os4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ETy4GHph;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="YMlz/os4";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ETy4GHph;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760356772; a=rsa-sha256;
	cv=none;
	b=BzOKviuUdFl8C8EWJCEUp8RngTJG1KP74Lu+oLTnXBiwy8IwB2PPDSXb9l0LQo35TEIEOh
	5XdrRMY0fog5yZuC4BWEtiNjpW4vKg3yLJD7H9KVromftCPswN2R916x9gdWb1jTCHRL06
	FYZEwNzsKrR5ea2UbDVIiv3wpr8kRbw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 54C23219BD;
	Mon, 13 Oct 2025 11:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760356770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=65YchmjaU4/afzOfYncGWxSpSpwMbIPUmdJHCVAQsJ0=;
	b=YMlz/os4GFl2vtP8mwGeoXm53hLwLCPEJblsob3IQxrWvk+OWwIKLj17v74P4CEvJ/VUe/
	+HVTKDtjX5NLglP0DFaoInVjGEEXfvUZM+HuS062SmrD9yAkwXMRPnBufJ7/CNHymNduLc
	l/RKCSzWDL81YSqHCvLNnFErKyCGxBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760356770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=65YchmjaU4/afzOfYncGWxSpSpwMbIPUmdJHCVAQsJ0=;
	b=ETy4GHphA8RJlkrrbZSA96ohF2idrC1LMJa2vT6HKHXqrWGzgPNhdSWb9Hxj2v1fxt4gDY
	P5DFm6ew9cL4HuDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760356770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=65YchmjaU4/afzOfYncGWxSpSpwMbIPUmdJHCVAQsJ0=;
	b=YMlz/os4GFl2vtP8mwGeoXm53hLwLCPEJblsob3IQxrWvk+OWwIKLj17v74P4CEvJ/VUe/
	+HVTKDtjX5NLglP0DFaoInVjGEEXfvUZM+HuS062SmrD9yAkwXMRPnBufJ7/CNHymNduLc
	l/RKCSzWDL81YSqHCvLNnFErKyCGxBc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760356770;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=65YchmjaU4/afzOfYncGWxSpSpwMbIPUmdJHCVAQsJ0=;
	b=ETy4GHphA8RJlkrrbZSA96ohF2idrC1LMJa2vT6HKHXqrWGzgPNhdSWb9Hxj2v1fxt4gDY
	P5DFm6ew9cL4HuDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4827E13874;
	Mon, 13 Oct 2025 11:59:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OmSbEaLp7Gj9AgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 13 Oct 2025 11:59:30 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E4B13A0A58; Mon, 13 Oct 2025 13:59:21 +0200 (CEST)
Date: Mon, 13 Oct 2025 13:59:21 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/10] mm: remove __filemap_fdatawrite
Message-ID: <t4y7xtgfnzfpfupnb7on33n6qzrfxfphsm2hqsa5rx4liqvvbc@wwj7ckhyilpo>
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251013025808.4111128-8-hch@lst.de>
X-Rspamd-Action: no action
X-Stat-Signature: qrsf5z834f1wpxuxia7pgucdreeczimf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01ADE180006
X-HE-Tag: 1760356771-187872
X-HE-Meta: U2FsdGVkX1+aCVMeKDli+u6u/NQxY79x/bfDJ4pHLm96K7VXfKb+U8FUW+RJ1bMlbFb8w8c1UJ8R67GNGGgxFAo+1v2hNMpP0Uo8p6dADYyabPA3HYWusaxFcPzrSaeaUhB1sphz7iZe6k2nKjtfza5Wup+FvHch4IDfGhdY8OKSqPz+vN6yQq+O/iEsXsi4tRG53GlCe8GtfD+Mcy5V1unbJdpnLqdtID+uoCtXRBHb8NZESjAPhpWiGC2PJTj7+0inkgWPxdFPBxI9N7NAP5kNTHJXRewOyeO5SRxXMcs0QkJxsNjIoS+LGyY4k+t1WbvobX0KcMXA+eNbcAXQfi8ck3w2Am6fUs+9pH6QILnpXNq25tUSKmCc26nRvkK186C/v93joxwcLcbuYm5GVSo6LSexfw2mUg1xOT2tvil6wlHX3YrF3h5vhDR/NlsGBsBb+b9TiJq4qce8v110vRz6y3iv8J5On/ca8s9RZNJ2ZnPeoeYfbCvHyGP3mBmpGrpacw7s4aLpL1IL/B6CVd04yQChPZRsWAmLKc3gX4TIWKY5ei9YHrkgqEBJcQ6v1UwVI3dg3/ptZCIJil9ct2wXnSoZ0K/oDKMwm95lF+FLgBfa/HqsPSUbYy3S/Pmp3YmyqibOA7qM54NvkSTUpvUujeJSMutN/FDOdM7gQBfhhzghNU2urIPphiCy7xOEj/CWfP/fp429+HsgrJqILzA2ssnwrZvMPStKIiFIOxFhxrbfaz/yRPWU4/QN0C+qNSo4a/QezjRyH1aMYcDcgKL0mArDThR2NGjAduotuja2fDvmv9D/qFwMIVovfnAiaavgqM1qU5L91OKt8tfcTPrcKxZtoKGejusab2McOQVxQNJEVbXWjbm9WDnZNKuVJl6SiU/rjYG5nm1jZ1E8Nd8+iKW/Vefcg2oVwpjtQW3F8oBlQi1ekFwOFn8bJsqwKEJ9VxZCsLflMosmZzY
 B7HJo789
 VJ9pz7Caq/eCe+ANPjDJ+pdkE3L8azEwyFnvBM8LS50jDP9qeDCKyuEfwHud7TlaXGRrNrK/TBaa4S699PdooIYCUcLULf9aA16QHtHZ8y5bF7l5v4E9M26PNH1XuQxCtJcQHelrpPDWOA+If96HlREbDP5FzIDsCvph8KueT7oEAwbqjOW96G93hXIjoFta40kI7GKlHgYKuc0Jk8vY19o691UwDpCOEa8BSYYE92drv5XPIda3344k/Pyy9AiFOf2iMhEYfTUdA4wfKhcwzABacXp6y6G/Q8S7XC94p+q1XNzCI6ejd65pWJlA/yOFLeUFocx111anbffS7jD1vlv8SSaEmJUzeQk9cXk9120dJGb+AM2Gmfi2PVdJUDVm+PeVLmCZspPjnnLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-10-25 11:58:02, Christoph Hellwig wrote:
> And rewrite filemap_fdatawrite to use filemap_fdatawrite_range instead
> to have a simpler call chain.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

...

>  int filemap_fdatawrite(struct address_space *mapping)
>  {
> -	return __filemap_fdatawrite(mapping, WB_SYNC_ALL);
> +	return filemap_fdatawrite_range(mapping, 0, LONG_MAX);

As Damien pointed out, here should be LLONG_MAX.


> @@ -470,7 +464,7 @@ EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
>   */
>  int filemap_flush(struct address_space *mapping)
>  {
> -	return __filemap_fdatawrite(mapping, WB_SYNC_NONE);
> +	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
>  }
>  EXPORT_SYMBOL(filemap_flush);

filemap_fdatawrite_range_kick() doesn't exist at this point in the series.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

