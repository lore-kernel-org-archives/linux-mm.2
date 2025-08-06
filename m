Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7797EC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE508E0013; Wed,  6 Aug 2025 06:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57A58E0001; Wed,  6 Aug 2025 06:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DF08E0013; Wed,  6 Aug 2025 06:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B784F8E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:20:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97AC1816CE
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:20:26 +0000 (UTC)
X-FDA: 83745938052.30.6A9FE83
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 753831C000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:20:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VTF7ly1E;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vnYqMu7f;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A4qB39q1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Nfq0QB6H;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754475624; a=rsa-sha256;
	cv=none;
	b=inQ9Q+QXsRpFmg5X0RrAHWHeTy0XYuZaZh4AXj7weeuAcWAWxCZlfWmKFAAzgzpTiCJkDn
	JI480EJTghgMuczqLxJd7J9QSH86Zz9oyEjer0/6Yy9weIrZmet+frGIQIzfehyWuGJg7n
	Rou1aE3XriUBjYdojVEmSlW0CUWYQsw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=VTF7ly1E;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=vnYqMu7f;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A4qB39q1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Nfq0QB6H;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754475624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFFPp9EM3GvVUWkraSvSCTNKuPEXbGOhmRF4SL4Qq+U=;
	b=XU7sxccVHCshT+tR8dRY+9bz9Tdnk8vS5bZWAT5LnsQmMPTY3JzVh+5bEUxZ8kFSeIXFgQ
	FmpzEJQMypQ2d5VZnpkq3hJxxFnOaIHRCOxstBUOGzeu/C8A5987GA9yyvayGPmxSTQqsr
	QJTjW6GFcZPGjClZcrpQx46PD2ZdZAE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 76F0C21241;
	Wed,  6 Aug 2025 10:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754475622; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aFFPp9EM3GvVUWkraSvSCTNKuPEXbGOhmRF4SL4Qq+U=;
	b=VTF7ly1EO9zrWehsk9qKEe9JxCW1R7d+UoxP+66022gZB+27a2j2rXVWtyc7LqlYYCxdyH
	jo5a3oaU3zXxfYbrs3bzWmNsyKv4XyzgYlnDPwzth3YwdcfqJskMn5DuZSweJDA+iuknBH
	UzihOCAD6MriZ4QLhW7PHZkTjNYKZyk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754475622;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aFFPp9EM3GvVUWkraSvSCTNKuPEXbGOhmRF4SL4Qq+U=;
	b=vnYqMu7fP+d6QyGNbxRZRM6e5HOJyHi662W2Vm/XTwhSRZ7ummqQlF7YZ9m6OoIZFk6IJB
	ZhbGcX4aVjyPKNBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1754475621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aFFPp9EM3GvVUWkraSvSCTNKuPEXbGOhmRF4SL4Qq+U=;
	b=A4qB39q1dGl+vsB7xAfD1t9vfyVWbXmJZj8xaPmkLvS5DsU0VZXS1TX4uym37Wl3V+qyEs
	uc7k4mY0Q8ao7YDjt4jf13HwxQTRQvjJpuByE9M8x+MPtG2kq2UXN3EW4C9XN8NqOcHLXJ
	bMEyNSD/frH8xmC6nMMnx8KApfirRtM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1754475621;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aFFPp9EM3GvVUWkraSvSCTNKuPEXbGOhmRF4SL4Qq+U=;
	b=Nfq0QB6HhnG6zWDyL/rnkJuJ2vY677m91UbqU5RrVqTraEwFnc0rxCuYd8vXJjaekofTXW
	91Ne26eUbzVmiwAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 00FB313AFB;
	Wed,  6 Aug 2025 10:20:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2JJaOGQsk2heMAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 06 Aug 2025 10:20:20 +0000
Date: Wed, 6 Aug 2025 11:20:19 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] maple_tree: Use kfree_rcu in ma_free_rcu
Message-ID: <tbm6emntje2lcwmg5xa6whlhsghwflbyb6p7m4y72dffenttqz@g2hftzczixxx>
References: <20250718172138.103116-1-pfalcato@suse.de>
 <l7kladnev3bfxcg2n2rk6hdi757vro5warlwp44ripj3qmnsfr@2jlwi7hhsfot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <l7kladnev3bfxcg2n2rk6hdi757vro5warlwp44ripj3qmnsfr@2jlwi7hhsfot>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 753831C000B
X-Stat-Signature: ycgnb9domroqen6rhxqg9fzfg5efudsf
X-HE-Tag: 1754475624-871819
X-HE-Meta: U2FsdGVkX1/A+uPAWuOYlGr+bQBTQtTu/2Z9lo3aBnalcHyGO0CrtRv8wNdIAkJI405bzoyCXdBabvDtzLRggrDi7eWO8JYLD7vM51WlieKcEg3p0YRpyrLF5eeWtjWS8HYOJ+cexARksf2937TKtynwYtq/PmemI35iIP7TjUz/P+nPovhBaOKEm1tUaIEkwEiCuLs3PyWwEmSgBhmo+gk4GUw/T3AWtROGYxQua3FUIOckpmrRkNBe4Z52af8iJZ3M6k3fyd2h9QYgN6VhGf/PuEGWcz4GRHE4FwaBI7WwxApngSyQSztkDxsl0iYBPV32tCcfvThnof6xJhu6gZh02P0TgfcqZ+e2UYQNMpcqFU8rp0UGbpw/lkuMYYyV1oSIRiN/CKT74TpVlBi6YfKLxlq21K5EWPi4hne4qytTCEZPUEHjyG1TPQP64zCCF9QZCMP8GMcfoacs8z2u23Aw3ENF6qnFnoW6cHVY59LINdapfrNYtSJXQU17RYsm8zLvWmEQ20wBTb5D1Kn2v4nMoxjbJQbHzfgECkODLXJhJ+uPIZMi51Ga5iTbHiIAnXjo2QbN3llKD9Xxz8C4ZrRC+nfHlsv/jCmZVeLmuElLYDmKlij53W/WFlSVfaFSIhviqkml/N5K8eqrhvRSdth9tCIg0RcWEEbNuHvoygFnq1XK5E+BajUYhVJOiETNuFt/1bnIBRRGSQHw4YWboaqpHC+dSTVs5Dbls4jJFDJNULi977fd2tC0Lyckj3DiyvgnCOlsIyth3GDslKEoDReq5b/RFPCFcysuSVAkZpkFwdxwkE53PSVSawkcAnLoRT1erameiKKgAVtfY+JUIH9WTpjsxZcI4CD6N0vK5K2RDOJVf0yXRAHkuyAy2s8tcOHi8SdjTFDOouZtoEH+MqEU/Ioezg8RTHcPrdGOTwX10uxryRzEJ67MKm436S29k5RPyucoYmAxabP/ssu
 bJRpudUL
 YbUGtlVF1eRvBxeV8Vm8D03BZACEXWX4nM3Z06+xmep6VIF0RQ8Ao4bib0iQoDkxG2YSDmwYp4Yie30L68I07t6H5gyyd4v/fYV/JlVE6PbAs1Z6f29Mhpylq6fO9ef3nwSVl1d3bTBuRSczLv+CKqYB+A+rI0qyFve57xJNqueal0xDYhmX6Y8WUm28MP5G1IPD41iF2rkZrnEQnYcyoxSHwceUp1M6EJgzApWzGddEqbMOyo7Yi6GduFP1IkJIuFyqsnPoUd1a5hdvVa97EksrR4AdQ1aY0Zny3QJrHyEbxnD3b5HFQxLMDH2s6XNG91plWKkhGkbu/1AfIK46ERhVUylUMOUEnuv0f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 09:25:13PM -0400, Liam R. Howlett wrote:
> * Pedro Falcato <pfalcato@suse.de> [250718 13:21]:
> > kfree_rcu is an optimized version of call_rcu + kfree. It used to not be
> > possible to call it on non-kmalloc objects, but this restriction was
> > lifted ever since SLOB was dropped from the kernel, and since commit
> > 6c6c47b063b5 ("mm, slab: call kvfree_rcu_barrier() from kmem_cache_destroy()").
> > 
> > Thus, replace call_rcu + mt_free_rcu with kfree_rcu.
> [snip]
> >  static void mt_set_height(struct maple_tree *mt, unsigned char height)
> > @@ -5281,7 +5274,7 @@ static void mt_free_walk(struct rcu_head *head)
> >  	mt_free_bulk(node->slot_len, slots);
> >  
> >  free_leaf:
> > -	mt_free_rcu(&node->rcu);
> > +	mt_free_one(node);
> 
> Why are we still using mt_free_one()?  Couldn't this also be dropped in
> favour of kfree() or does kfree() not work for kmem_cache?

kfree() also works (since SLOB was dropped). I thought you wanted mt_free_one
for style points, but I can replace all calls with a direct kfree() if you prefer.

-- 
Pedro

