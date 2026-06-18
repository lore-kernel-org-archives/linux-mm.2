Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42F2BCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 11:54:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14C656B00D8; Thu, 18 Jun 2026 07:54:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123E66B00DC; Thu, 18 Jun 2026 07:54:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D966B00DD; Thu, 18 Jun 2026 07:54:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFECA6B00D8
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:54:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 547651C2D50
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:54:00 +0000 (UTC)
X-FDA: 84892874640.06.ADDAE1B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 12E6B14000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:53:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DM5TGA/H";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JexkUVao;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FadwPL3k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ghuIDtx9;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQQaq0JXVpampDDkCoj4SM6iiwGNqXeAIhjWEGe6LmY=;
	b=FD48JQ+3ufpi0QDeuYWgfHB62/o9/wzxwTUGQGHl9t0czeULKAKaVPoLI5B+YaQ8FeLgsB
	qK9eM7yjxspzmbqL7MDFpnu5l0Gt8LAKMKHPM0QZYTqfmIFzrXj1FLJ3dMyaC6aBoMVmnm
	8nb7JS5cGMJcSbQrtYtRoTuMv72WXoY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="DM5TGA/H";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JexkUVao;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FadwPL3k;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ghuIDtx9;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783638;
	b=IBz14HX0niKUdAwZMJH6h19Zdx9oBZ8XQoXxbc/bnfQXmu9nuu6FXsCuhu7J43q9TN1QgA
	KhE66fP8LgZHxewk+A+9YQjvL4S+XvDv0aiTXfb8RTJT4F58wNB/7vcc2TFaqBmCi2II/a
	WWmWyO3EjcLXporIpyRiMLzkfIUIjEQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CFD8175C20;
	Thu, 18 Jun 2026 11:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783636; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gQQaq0JXVpampDDkCoj4SM6iiwGNqXeAIhjWEGe6LmY=;
	b=DM5TGA/HMdg986vC+yKHSU4zRUmb46lYgTsmovvmMKu/N95iBBW44vDfuUxMeZaxDJV1sw
	hWxOgQiTm534NABAoijqdx3yim6AbyQXEKe1pRaLCz7gVRvf7xTz4h7Ab9PoofcwvhIB8D
	a3658gTGMcydXMC1UyrrTH387JC/R4c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783636;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gQQaq0JXVpampDDkCoj4SM6iiwGNqXeAIhjWEGe6LmY=;
	b=JexkUVaoQWpw7XA9UoaVrWr20CSZi3rRaUp+7Rqkz9kP/AU5/acwBs27pzdYzNG0b7WyZ6
	35qp6G1OwmsR9hCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783635; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gQQaq0JXVpampDDkCoj4SM6iiwGNqXeAIhjWEGe6LmY=;
	b=FadwPL3k77g3hDuLcNZxG0tsdGdGZraJZhsAEZT2pbzftoldn0H9uHGupRx0pGn8m5Iulc
	O0RPO7kTBZwpebDPAzsBe9fxkW7JbqW2LQQj1Xu0qVr19MOas79YBu1+sBW7w8s1dXoXwv
	6iOMYC9vi+x+GmPAdiGYGcL7EHL3dZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783635;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gQQaq0JXVpampDDkCoj4SM6iiwGNqXeAIhjWEGe6LmY=;
	b=ghuIDtx9X6VLUGXMUA63Uh2IUftVBZnrKq91lFvpKGrRWeZDMr2bSWiSqVb6wD57oe7brN
	qYTlUeHLe0lGXfBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2E264779A8;
	Thu, 18 Jun 2026 11:53:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3k4QCFPcM2qpfgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Jun 2026 11:53:55 +0000
Date: Thu, 18 Jun 2026 12:53:53 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 4/4] mm: migrate_device: use walk_page_range_vma() in
 migrate_vma_collect()
Message-ID: <ajPcPPyXecvXee6h@pedro-suse>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-5-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618092845.3905740-5-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 12E6B14000C
X-Stat-Signature: r3mtqke5eax4spj11rbodqtdijazzk1q
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781783637-772951
X-HE-Meta: U2FsdGVkX1/rOl6SqaeAeK4WW0GT1MCJi1Bqa17fs4t96OgY+MryFXaV2QrkgC3eO4IRTUIeuoJw2Y4alPjzAv9YB0m2KfG/FnSW0Pxv3+gVzOn4LQO4sTJw7dUpFhh8eDieSleDQZ2tkFcE9SUZBcKVL0neyVx66XmixZOAN3JAzI7pFfBihSASwqUhB3ukgAf5bMsWB16XUGOwbqAnqoAry4ggq61lAxOsEdMuKXM1Sn5QNuh8cDsgwvvDHOtplxKJum0zIm1ShRWQw+DXkEkIpUSJPIUMhExgUgkw708SbtiC/MUZMAme2Xyl1dJmiSAKUMl1mr3Z5qYcpne1lg1Gvl7dh/wxu5HWmV+1YaYvuasVfvx18O6uwY55QqL3fIyys0S4AbTdUTlth6iFU1wefgYu3iiA+eHWtSDPxVwjag3A+WpERsDMQVVSm5LVZMX6WmTapXqGSz44iZXtxIE/V4UuxsSRTcem5J5u5F4zdPVeMYB1bR+5YhlTiWs424Q/THydrY6gNt0N3aG4gLhOsoJ29F2579HPyqBFjdsK9wkjb8opkCPeaJkFTqU3HqK9nJsW7S0REOIq8M2rBq7xU/Apo8r74JM93fm/74J/UwhQAo6/yYdncG4LvqM0MzIzcxdckwt9idv348gdpZakXq7FLjqvhfne1lJ0dpd4XQzfzLv5tzI9awWIaJfhCr2Sr48OH+Mc7WX3qOrQv16KiVygx5ViHuo5A2gY4AJqEBqY5SorO1Pv85sFrAoNiBd9cl/5Uf7JplIARwHkaVo0JtVW7LaxUARqeZM10bSY1SLDXryQEc1vsIITv2IzJ2tDtw0VoXRnQEXK8heHM9wX0HlMd/oi8iOfel7Ma9GNoHXS13F+nzi+YgspDkxR7sKDziJrSOnSKUWz8KQbx1U41dB2uWFUDS8QGuj23W61c9J/Tw4eMDJWu+3wwhnsJVPBEkgV3IJ4FHPR1Qo
 i+KMyhpp
 jbkxCIDLsMMFHEKkmWEJNDLxr+YKu+WqY82qZydQV40ORptg+mg4JRiZIJa8S2VyLuGT0KNpYimfVv6lBzv8IwnQ8Y2CMBVN3biIVJTYztfb/qV0ons3zlnD2sCdCigI4X4Zr2ddEzZnQw4fR9A3aMg4qHQEOGzXZl+yCgRtfqO1Q0GusuwjJRwCYWck9xp0V3WDYKn2RYHcXTRIREG7KWagiMUBwNv/OdyQxM7iaWDNblRtTXqPYWK5UOCHiObikk/VH9IvzcT9Q21sC0M/mlBHU5OH0tAck4IQgD2BJLqfy0kQ6QWqVtl4UF2yDr0YudlOT6ZrT0ylUxQiuMgd8FvrcpkcjBHra96/gnj75lS2IMfdtGd6dqiqqkugtkVyIokoKT3LoSylQaiCEtZ33TVXMqXwU1eYl9my6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 05:28:45PM +0800, Kefeng Wang wrote:
> The migrate_vma_collect() uses walk_page_range() to walk the page
> table. Fortunately, migrate_vma_setup() already validates that the
> entire range falls within a single VMA.
> 
> Since there is no .test_walk in migrate_vma_walk_ops and VM_PFNMAP
> was filtered by migrate_vma_setup(), it's safe to replace
> walk_page_range() with walk_page_range_vma() to eliminate an
> unnecessary find_vma() lookup.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

