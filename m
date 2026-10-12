Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4AA9CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF076B0088; Mon, 12 Oct 2026 07:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0286B008A; Mon, 12 Oct 2026 07:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9EA86B0095; Mon, 12 Oct 2026 07:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5876B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:27:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1182D1A0C19
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:27:44 +0000 (UTC)
X-FDA: 85313749248.21.693F3F0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id D6823A0004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:27:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FIiOfmm3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=19ePpgeE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pUZxb2+K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=V2f7c6br;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791804462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7URtRlrLncshXlKL+R1mPLfjQj1qLjdYf9TgSXwUEA=;
	b=zn77q3SsdBtyjJtsQuJVqqonGd5dhKeFuRhSz3zm22PTJzKOijrZtQ1Ql4OxXF/c7m+mL0
	0hOR1zkx+cPgnDFkqWFXCwyKGwF2X/nlDrPjkKzopNG3CIw3OyOgw8xhPlTtjDn6PUfgoc
	aers7bs2bHbcT6DWrHCUXczYDLBvsuY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791804462;
	b=1z0rA9XYLbdIGjLRKOZrmhlX8l72P1m/NY1jedfuhDGpWcBGW2SRori1LKWycSUat8goZx
	0rziCTyUkv7LbvSo1oZmnFNLTgx66CQLy+4kq+SE3NxJuWWX7QuFdVS0Lls/TyR3IGU2p+
	+d24HiwZEOPBBQf57hrCQDa0RD+44Rk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FIiOfmm3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=19ePpgeE;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=pUZxb2+K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=V2f7c6br;
	spf=pass (imf25.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32CFF21E6D;
	Mon, 12 Oct 2026 11:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791804460; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e7URtRlrLncshXlKL+R1mPLfjQj1qLjdYf9TgSXwUEA=;
	b=FIiOfmm3WiGwlbwlvmU/o7lh73JKxJk6jRrh4YnqzL1iKhn6kVrMkf0Cz4jTOLrn0pl9GL
	4cqss1QZ0s8gUAfTrYr4vDb+pCIaffQ3XTig69/cv0t4WHIbFq2dfylrgnkEbYzeUV9vvV
	+3ZXCwKp/03upxfIaCCcgsMDZiCV2Qw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791804460;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e7URtRlrLncshXlKL+R1mPLfjQj1qLjdYf9TgSXwUEA=;
	b=19ePpgeE3U/db48kzgafY/O5xUlLkepuslhjp2tkcqxQjr9TnnkE+obaST50H+s2GBurQ2
	Nmmf3qWo/KpOsgCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791804459; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e7URtRlrLncshXlKL+R1mPLfjQj1qLjdYf9TgSXwUEA=;
	b=pUZxb2+K5f70i1geYgipjXtfMskAT4DzIOnaqfHKuIxpxjn8+u+3KVTHDG1raolhnxTgUV
	uXqEw4Ydqt9u1FF6BGY75AKg8useNVZ3hiMC+T+oBEEwtqFE3dtxusLwGuB3I5Mflc7G0P
	vToGH9G3tB8eRksZfETAMwixqoHwLFw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791804459;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=e7URtRlrLncshXlKL+R1mPLfjQj1qLjdYf9TgSXwUEA=;
	b=V2f7c6brHU9jkAKrdRDTFZagMzhHqj8YSaddNi+5kYphK7dV08VR+z07xnGfrgXNAKpmEW
	QbXOCghu39nNBFAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5AF2613314;
	Mon, 12 Oct 2026 11:27:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DwC/CirEzGpnagAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 12 Oct 2026 11:27:38 +0000
Date: Mon, 12 Oct 2026 12:27:36 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yifan Li <liyifan21@xiaomi.com>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, mhocko@suse.com, 
	netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/1] mm: page_frag: account page_frag pages in vmstat
 and meminfo
Message-ID: <asy9PzW41-Wi0JXC@pedro-suse.tail5790ac.ts.net>
References: <20261010025941.1253-1-liyifan21@xiaomi.com>
 <40fc5d04-2a20-42c4-9557-7277bc981172@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40fc5d04-2a20-42c4-9557-7277bc981172@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6823A0004
X-Rspam-User: 
X-Stat-Signature: snz7fxutpri467jmwt8aeezfxei99kat
X-HE-Tag: 1791804461-60115
X-HE-Meta: U2FsdGVkX1+rXyKFqcvCN5XyGW94Qli4JVuW4T/v9nt/bSSA8Ew/e6C5yr0HpSTRYW+AOsR5+Y1HHvhcGf9dvgC9o832VFnhprackaAgXDbZQ45Br+6bfx5asDmPSTm2EytI+GLni6XDHAY+v89Iv5UmERz+H0JZuFTYv6LDM1dd/GvhxNsdmWhD0PUO48d3D+zaSftK9lJSP7GFqkK+rW9AryuM66XNCzfFgaLp851h2ULm2C/FIF3L2lwXYbpJhJbZ+GXa49OI0tGVIzj2bDFNx9DN6HNLm+oUmqlDNzpaN6iCJitK5QcRRdvNOuPTkFtbL/csMuTF0sPQQA53fxo9jCGLTWowLC3AmjGrCceyZAtYcnbQnjDBKH0Tdc7AcYpZUi0mzp+VPRCvXFmmK9YftVX0xzcfmocnIhEora36RnHuIcUBwlG3e6QMajoP/9Jy9ME3D/80UW2h0WHXUuEH8zsJOvztPfw0r8Vo0kzGEcImzbQ3un287xNL4fkWX7xC3Zi9uXtrodY88Qb2fol3PcoP47qtva02fJqvGFObKMYU1BaN/4pdN62H7/Xb9krBatWPe+PoAZQrEDeRkE1gjR51oJnshHQSV6D672bknuL4a1LO9dJoRM+HzqMopUIQH6fHSwBJv7yoc1zvNv5HvXMeoCHT37nD+/sjm1tqu+MzuXeQgcYcYP8PaoX+Usu5mzjqlaLDa48sPVZWIF5iJhiinULHDWszBr6ewZ45ni1kfxrropYy07B1xD2tBYkeVJ5VlYmf6sY6DtZ5IvJtjW9TEHOcMbPENAPl5zkvrjk3cNXqNwJt+sHQIDk67sqfHd/iz98EoZCf/OugklO4cKEcWDmal74keO5egTngz1LPYsyWVScWum3MLROkKt9msxTdn4njSl/JFPrI8XeUiXUMwJe/bSsbwYEhZ5rdT3H2lnZHyVm5Yyj3SIX3AJYiK5+QrdWnBfXOC0n
 6GuyOl22
 /Vp1QGzcDhgZqITmfSp64VmMkj7Cl0q5zjQuBeM2TgeGRU7Dya2BncGjU6yJXadbqpCW4doa5WCe43s4K/0gNSeDulQAV/hO3JBJJswqOkrQJ40brhVQ7PxTUdSRz+D7KmDy+edOxIpEH+AP1BlxODhQRgunuzPsmaE2nOHfTeviG8DRxyaovfjkb9x41ayhDbbHBzLf+l/KalxDnTUfGoOncZwcWPPhxQlCidow6AvT8/gCav2H6Tx6/M7luvoBuyJXgBfFQgwO77kSaqhNsPeRUr94imLUoZqcRcySqQrbhg3Ke0JZqeWOv6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 12:36:35PM +0200, David Hildenbrand (Arm) wrote:
> On 10/10/26 04:59, Yifan Li wrote:
> > This is an RFC.
> > 
> > Pages held by the page_frag cache are not accounted by any memory
> > statistics counter, so on systems that derive "LostRAM" as MemTotal
> > minus the sum of accounted memory they inflate LostRAM and lead to
> 
> Sorry, what exactly is subtracted from MemTotal?
> 
> How would any other kernel allocations be treated?

I suppose those would mostly show up as Slab:. But yes, I agree the metric
is a little dubious.

> 
> > misleading "leak" conclusions, even though the memory is legitimately
> > used by the network path.
> 
> Assuming "leak" in such scenarios is questionable, sorry.
> 
> Aren't most page_frag allocations short-lived? Or is this more about the
> page_frag cache?

page_frag allocations are kinda arbitrarily lived. If you queue (send) some
data to a socket to send over the wire, they are more likely than not
short-lived, unless the protocol/qdisc says no (for example, you're hitting
the TCP congestion window and as such can't send more data over the wire).
If you send it over loopback/veth you get arbitrarily livetimes as sockets
can keep the page frag alive if the application never reads them.

On the regular RX side you can also (AIUI) keep page frags randomly pinned
as long as you don't read them.

(note that all of these allocations are bounded by each protocol's memory
limits)


In any case, I remember an off-list discussion with mhocko regarding a
downstream bug, where I suggested adding a counter for this, and he said
networking is somewhat sensitive to extra accounting on the fast paths.
Added netdev in case they have comments.

> 
> > 
> > The page_frag allocator (page_frag_alloc / napi_alloc_frag /
> > netdev_alloc_frag) backs sk_buff->head and the frags portion of
> > skb_shared_info.  Unlike slab (NR_SLAB_*) or page_pool, page_frag
> > pages have no counter.  A preliminary measurement on a 4K-page
> > arm64 Android device shows 14432 kB (3608 pages) of page_frag
> > pages already in use at boot, and the memory footprint grows
> > larger under heavy load (e.g. sustained traffic through the
> > virtio_net / tun receive paths).
> > 
> > Patch 1/1 adds an NR_PAGE_FRAG node counter and exposes it as
> > nr_page_frag in /proc/vmstat and PageFrag in /proc/meminfo.  Pages
> > enter the cache through a single entry point
> > __page_frag_cache_refill(), so the increment side is complete; the
> > decrements sit on the paths that free the cache page.
> > 
> > The remaining gap is on the release side, which is open: a cache page
> > handed to an skb frags array (skb_add_rx_frag() /
> > skb_fill_page_desc(), without an extra get_page) is freed via
> > put_page() (kfree_skb -> __skb_frag_unref -> put_netmem -> put_page),
> > bypassing page_frag_free(), so the counter can over-count under
> > network load.
> > 
> > Closing that needs the page to carry a marker checked at the common
> > free path, e.g. either
> > 
> >   1. a page flag: PAGEFLAG(PageFrag, page_frag, PF_HEAD), accounted
> >      and cleared in __free_pages_prepare(); or
> > 
> >   2. a page type: PGTY_page_frag reusing _mapcount, accounted in
> >      free_frozen_pages() (requires that page_frag pages are never
> >      mapped into userspace; true for the current RX paths).
> > 
> 
> Certainly no page flag.
> 
> A page type might be the right choice. I don't think Willy planned for that [1],
> IIUC, the bump allocator was something different, but another page type
> shouldn't hurt at this point.

A page type might not work, these pages _may_ need to be mappable. I know
that was an issue for page_pool (Yet Another Networking Page Allocator) + TCP
zero-copy RX using mmap.

Of course, if you have a page frag under PAGE_SIZE or misaligned then you can't map that.

-- 
Pedro

