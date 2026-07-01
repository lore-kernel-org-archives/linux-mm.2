Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04F0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEC846B00A6; Wed,  1 Jul 2026 08:05:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D716B00A8; Wed,  1 Jul 2026 08:05:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8E276B00A9; Wed,  1 Jul 2026 08:05:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96A696B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:05:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 178531C1F4F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:05:01 +0000 (UTC)
X-FDA: 84940076802.20.337D12A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0FAF9160011
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:04:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vXVifsuE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0ZSPYLM2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vXVifsuE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0ZSPYLM2;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782907499;
	b=6KVkbh0qBe/Fny0Djn54PG/WybYKAxhm5esVfp1FqmeBpjSINWR5bG8vFtesrJN/Ae39mx
	1sUt3nYBa4yIW7s+X2ObixFSux8uMtXwThTBmzLZ/h2YLCwLYijIiobAM9li8TJ3DIIqOR
	Pwo+TF5JWhw0gdjyrfLjAlII9wUSJGY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782907499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4id5fjRmUwpHNxQihK2Flg7ASSDlcpvubHpyY4zbP0=;
	b=LGgfLXZs5uHZwK1QyVckxDrNZgLbnILt0A3rHoLDMlGizCCAF/BTurlKPoQd5yNqNjoCfn
	a39mNItrzP/q5b+wI9onAEHshKrkLj5ASUdOm9yA51azGNSE5oPbrqYH4AuY8x62lmai8s
	uIJSZY2GgYvp/NOwn5EOdccc1YplhB4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vXVifsuE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0ZSPYLM2;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vXVifsuE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=0ZSPYLM2;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8625573A87;
	Wed,  1 Jul 2026 12:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782907497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4id5fjRmUwpHNxQihK2Flg7ASSDlcpvubHpyY4zbP0=;
	b=vXVifsuEykeck4AJwZB77cLwR6YJw0yhLqR+m5xRmsX8vq54XX5gra5wMueWQT5RrmrvpD
	/aOJae1W+TDd+fzKg7lylTCC6SBA1HYvMCKDTpKr6EFrGhAYPqup2YB/mUVPuzJnfl/mnF
	/5ygqQ6aga2lAh7t4mQGF5lZG6vux1g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782907497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4id5fjRmUwpHNxQihK2Flg7ASSDlcpvubHpyY4zbP0=;
	b=0ZSPYLM2d+cLZqPDTeSjIa4VUFkbRqoThRELy++4mMn/9ECdBkBektt66UhlLhgs7MWGJZ
	FUQWBxC0QgnczVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782907497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4id5fjRmUwpHNxQihK2Flg7ASSDlcpvubHpyY4zbP0=;
	b=vXVifsuEykeck4AJwZB77cLwR6YJw0yhLqR+m5xRmsX8vq54XX5gra5wMueWQT5RrmrvpD
	/aOJae1W+TDd+fzKg7lylTCC6SBA1HYvMCKDTpKr6EFrGhAYPqup2YB/mUVPuzJnfl/mnF
	/5ygqQ6aga2lAh7t4mQGF5lZG6vux1g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782907497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U4id5fjRmUwpHNxQihK2Flg7ASSDlcpvubHpyY4zbP0=;
	b=0ZSPYLM2d+cLZqPDTeSjIa4VUFkbRqoThRELy++4mMn/9ECdBkBektt66UhlLhgs7MWGJZ
	FUQWBxC0QgnczVAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 977AD779AA;
	Wed,  1 Jul 2026 12:04:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZRmcIWgCRWr6MgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 01 Jul 2026 12:04:56 +0000
Date: Wed, 1 Jul 2026 13:04:54 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Gregg Leventhal <gleventhal@janestreet.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Song Liu <song@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Eric Hagberg <ehagberg@janestreet.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: Subject: [BUG/RFC] write-open file THP cache purge can discard
 dirty page cache
Message-ID: <akUCJvTLD-bPm0s4@pedro-suse>
References: <CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com>
 <akQIIav_zaK6RmIC@pedro-suse.lan>
 <akQO8JtTxmp89GS8@pedro-suse.lan>
 <akQekZUyoKadiGCH@pedro-suse.lan>
 <akUADHLWEetveHLp@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akUADHLWEetveHLp@casper.infradead.org>
X-Rspamd-Queue-Id: 0FAF9160011
X-Stat-Signature: y9jbq8k87mitozg3hbaqczbfh9qti75z
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782907498-394070
X-HE-Meta: U2FsdGVkX18mgwDi79Mo6e4Q646bPAFV/NVgTtWs2edWUAoemyCz2gJ3aXwqcYgCfJ2v+PBo00LM/bPG93RfhbmGOYWGHv3GUjzaGVvScpCYAXzXFfJ+zo2VTRvlcU0qqvudg+DwuJ9gRyyNx1E7q4uBMDgaXtBe+8MEOGRKr2/CJbMleavvjilfZedjzPSfUquYWOLodOchrfE7mQxp9OoUIzMOXO55vzer5ivehmMi8w4OO+rKbdwIMliFwmxriviCkwFReLl8YFZlL0hLNvniHUGt+Wc5hstQM9HXZLPprNaQxgSxRTHwi9PoWi7QQkaomSuhuAVsa8vIpdU7l56aA7TbwSF3Hqr+Ei5mq8EiNx0y/CB7vuh6RG3+SI8r2YIVbKNvIUCoXWnRVnHKZ0DGZnTN8vI/+f6l2LZBHFmCPgV3KpXRAx7nO+ygi7iLdl1a++E/mMuBrrUGvZkVm8l9RoEk2TJPjPctBLDium4gUVdOZtb2Mu8sFLRyXDKosJrG5RsATVoM+JBACc1MY/RU4m7D1Ptyb/QrP8aRxJLCuYe3sTEOteesnULk8KiKXNHRbWAoh57W39LPn4VkD3ZNMpvRggxGopXTil3LwfQy9MoN6sfIYwmJxYsXlKrChUafvqYLHtqQDR6waJj4rvmkHip+Rx0g9IPkUa42Hpj0+GZums/Y9iZdVheC1ogCna6CITkflKggwuNT0qwZWDZHwjhTaXcmjWF6GS9HCLByuAmxlj6PxC1Q9U4Ed0ZEHBnPSgDo0MAIONvJnXkY5pbg8mbGvkmy4xEPZ/7qNTNlmteWnKtzkfjziJuIwJzBuEj5KcE3fyLetbtvFS578bQ9YTgKqe0NyG8Q58xC+IeUbaXC15nzr6/fpXR/vFRO2HEBYd569L1Y4My2SwNM9JRCyn4+4sjCVXA3Aw96bhQIM8p1YMlFWB7rBqC/upWvJaRucY2UMpSX/KxfvCJ
 KXIia6b0
 j9sqLOIK6ajLsLBPg2eHuPhwRsuzRB8Q5j+LTIgJe++aCd4Ow4PrbejZhRtZQvG1hFChmk/u3BLKV6MBNJCz0EOV2oV9qpC1xg1Pgyo0xxlqKnaPFnAxodc9UwAj/Nddi19oU00ap3F6H0bhJUOzXLRcg4zK4TvKfvWhpcxk1F525eUYf3zv2Jt5Ch9TLQZwWvwIpSi6mS/uz3TSpeEe5vqaY/vy51fqiK88XBg0SsmUz4pffjE8xNOkFYAbo/3BN4jteQPlCS6Wxu+WXZU8euKwTc5gKiw/LosVISbvDWEfe/oSBMM/YdVu9Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 12:54:52PM +0100, Matthew Wilcox wrote:
> On Tue, Jun 30, 2026 at 08:55:12PM +0100, Pedro Falcato wrote:
> > @@ -2043,6 +2044,17 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
> >  	 */
> >  	try_to_unmap_flush();
> >  
> > +	/*
> > +	 * If collapse looks to be successful, flush any dirty pages
> > +	 * out the page cache. With the nr_thps incremented, there won't be
> > +	 * any new writers (nor new dirties).
> > +	 */
> > +	if (result == SCAN_SUCCEED && !is_shmem) {
> > +		err = filemap_write_and_wait(mapping);
> > +		if (err)
> > +			result = SCAN_WRITEBACK_FAIL;
> > +	}
> 
> Oh, the other thing is that this should be conditioned on
> !mapping_large_folio_support().

ACK to both of your suggestions, I'll send a proper version (once I figure
out the proper way to send a stable fix that does not hit mainline). 

-- 
Pedro

