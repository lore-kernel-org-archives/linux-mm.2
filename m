Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3F63C5DF8E
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 22:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D162D6B009D; Thu, 20 Aug 2026 18:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6D56B009F; Thu, 20 Aug 2026 18:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDCC76B00A0; Thu, 20 Aug 2026 18:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 977CB6B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:20:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20D4C40321
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:20:17 +0000 (UTC)
X-FDA: 85123067274.18.3DEC3F6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id F303120003
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:20:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0wOXg2ig;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BNzF3pqd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vbnUn4D0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FB17yxxo;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787264415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UYo1YUmYjiLsT0KlUjloBndh6L1gE7npqqcdG7O6gk=;
	b=pdF0T4fmYfoicdIt9QVyIAk3GGgNVuLGYT8ENBg5SxvgvSHSb5AHGlRVF4orCClcEsdj30
	Rio3tY/sL5Qg1BlGmqoue8yeQCut5waNiQv7zy1LQbthgRBQH5NnmChDqX3d404PZS+EzX
	jN1RmEASYp15nd0H+ffDqgh2TXcw7tk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787264415;
	b=0w5Mn+X1RUXJ7W/m+TTqPtZ/hNXTrb5tDKdb0b/1w14LOYLSZJUllRiZDVHD2ifM9BH1lA
	nOwPOY18lNK1P+LCimNX4m91F0o+4w2ggc3qYjWhJj5XxYWT3IeLk1Q+EiH7hCWjAGSOUa
	kse8MNv4/+q+c9DXuwiXUWul2KypB/c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0wOXg2ig;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=BNzF3pqd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vbnUn4D0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FB17yxxo;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1F9F6836AD;
	Thu, 20 Aug 2026 22:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787264409; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+UYo1YUmYjiLsT0KlUjloBndh6L1gE7npqqcdG7O6gk=;
	b=0wOXg2igCLpLElcvbOXInsEu1wTk0thze9mBcB3HxlRJ9iw5pwDtWF7+ECgPFjRG/eE2NU
	mSDcPTyVHmmRI6oxs1kJAZTLp8tadsHEDXpjTc5uIHFN/uIZsIqHa4FAlyE3KN1gBBrvpY
	oKN9/v5Cp63otwX5tqixf79m+PjLuOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787264409;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+UYo1YUmYjiLsT0KlUjloBndh6L1gE7npqqcdG7O6gk=;
	b=BNzF3pqd0X8ULDWj1tbBA16qZ0M3F+T8XUUL+e6gxorjotnvdYoDCHCBfMXD5sC7qPo2GW
	AUKJTLALnn8gc/AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787264405; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+UYo1YUmYjiLsT0KlUjloBndh6L1gE7npqqcdG7O6gk=;
	b=vbnUn4D0so/Dg4cjNTfXXym2RGI52o7ZHwOSAPxwcZIZcZobLK6HM1yDxXho0cEZSgnxt0
	ys9+mrQ9xHQLYCtfDnRX7H8QOrwl7V2eSI4lu/oqWK30xTKM2fy8oVsOQVa28PFEPgenFL
	NY741Jhz+6FRw4HoDANqJrRkNZVMDD0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787264405;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+UYo1YUmYjiLsT0KlUjloBndh6L1gE7npqqcdG7O6gk=;
	b=FB17yxxo6SQVjG7FjqFd8dURhcYaOSRi0YYKWwJ2a+So1bh97XaU9EiEnYj6zs3A0qa6F7
	P2S8oAXKR3VA5dBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95D3C27A8;
	Thu, 20 Aug 2026 22:20:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id h0w9IZN9h2qQMAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 20 Aug 2026 22:20:03 +0000
Date: Thu, 20 Aug 2026 23:20:02 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: kas@kernel.org, usama.arif@linux.dev, hughd@google.com, 
	akpm@linux-foundation.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, nico.pache@linux.dev, 
	ryan.roberts@arm.com, ziy@nvidia.com, nphamcs@gmail.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	stable@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio
 on zap
Message-ID: <aod88sqdJ6qrNBxc@pedro-suse.lan>
References: <aocFPRgqieScf_yo@pedro-suse.lan>
 <20260820165334.36401-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820165334.36401-1-lance.yang@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: wwj7cyfhiibff1fs5ypx6rkszewfb4tm
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F303120003
X-HE-Tag: 1787264414-10264
X-HE-Meta: U2FsdGVkX19xmPIekRvN/amjAtpAnzJIEmagjm0zhak93qdSVumpBBkquKHdVtQpz53jHh75oHsdJqQj0x0SzVYdaiSoYxcCyH4efgRahhy1wuLaI3OiUPDrj3Pz3nkp+NVy1hevpowQkItMG4A+2MJSZoD6X76SMHvx+nkzlVeFWT8uUsSVgKG2vjDZOXvgTxgV6XuptYpyT9N3l8NFw3HV7l6Mt6kZ7XLgYqWXim1jExVrsLXM/orU22injyUg9NDAbJL437NLq6NFNN8Gm9aL3uDZG8Zfja1EzRrQgejrgbQoyeKxiusycT+Ws5dyNJ4NAHQtvps+HMnoM+gNpTVqYG1Kp0fAXZkGQxrFVCGrK/wClINX85LJaa380qQeQLj29u+Feg9LxAvUcPmMfu68crFRrXttDOoJ1IwFYmSPzejwKaAihlSr/2+HytgpwJdvvJvgl/92KpqkJK4e4pbqIPhYVIyFeZ0FXJT9LnWJcXSxUFm5PQ64MSP9NklxemzVNsjUnhPpi6+SzjX+0KVIdBKDok9LTz4OeaKYyhTo4+TCeo4i7+haC8m1XziJG7aDHmzxX7q6ySNno5KYOpocKSO/Lze/QfPBhNzSuZaWwRwSnTe9rAQUFunT+mMz3g+UpNrS6NGSeWLiWgKZqLVfqWRlIDnQVGNtyA6rW+btBiSgcrDnV/vtyq3Rgh+NZCPfMrpg30USbV1wp8XVXScleIPzf2UWt08+7TYNHgoxBayEwirVHn2NQr4bbZNEJdclif42RRr7L5zkJQheY9J8MylLE4DUKIF9wGr8jQAxfUupn82rtir5xTnvQ+0vCrPWkSfq0EBuv48hxaNxFD/ZE1ferwTziJcv1OXDfguYhxCKTRHlUTp98nHMWqjP6DvaDq6RjxkK7tX44cNzcFlsxItbcPBtro0uGRBqZf6foSS6n5HLNLyTRvxaItq5q68RCizb0zwdVi18L/T
 GNt5oefv
 k2C2FZAfmFnz7wDp0lNgXIxjmxeTf7N9KIM00MdC+klznHJBQr3M4E7UgvfMFyAvlex+avdqYnobwsm5PRTA2EEFOTb4cwKtD8z6Rgr6tosvjBmiJEfpHpIa2UZQvlMfjzPZCJVJTAqBsWZQ/aqKZeZ5KpefFM2NLXv4L1diGPuOhdgcXXweD2zXP648EddlpeWucwmXA2Iv3mB99I6gtgBcOikkSOS7nlhP4vHPWjFlR1UvY8dscNTU0Gn8KhtrWDg3P/RIkmRUI0I8mF6AlG5wlaazke0zOe6AKUuNLij3Ulflf+7iWPDQwtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 12:53:34AM +0800, Lance Yang wrote:
> 
> >For some context: we were discussing (off-list) the recent report that
> >systemd-journald had horrible write amplification, worsed quite a bit
> >by large folios. At the moment, there is quite a lot of write amplification,
> >but _only_ on mmap writes (if you look at the write(2) paths, you'll see
> >write_begin and write_end which tactically only dirty what you actually wrote
> >to, block-wise in the BHs or iomap IFS). This doesn't need to be true.
> >
> >What we conjured up was the following: since WP faults always happen on PTEs,
> >you can simply dirty the block(s) corresponding to that particular PTE (which
> >naturally points to a page inside the folio, whether it is large or not, doesn't
> >matter). That way, you can avoid fully dirtying the folio's blocks. This is
> >something that ATM isn't done by any filesystem, but it really should.
> >
> >Obviously this whole idea is thwarted if we keep writable shared file folios
> >PMD-mapped - you can't get meaningful write notifications apart from "someone
> >wrote to this folio", which isn't particularly useful once folios get 2M+ large.
> >So PMD-mapping on a shared-write fault is antithetical to getting useful,
> >granular write notifications to filesystems.
> 
> Just checking I got it right ... for a PMD-order file folio:
> 
> read-only mapping  -> PMD-mapped
> writable mapping   -> PTE-mapped
> 
> Then ->page_mkwrite() could dirty only blocks corresponding to faulting
> PTE, avoiding whole-folio write amplification.

Yes. To be clear, when I said "mapping" I meant "page table (PTE/PMD) entry".
So something like an mmap(PROT_WRITE, MAP_SHARED) could have PMD-mapped folios,
until you actually wrote to them (otherwise they're wp'd and huge-PMD-mapped).

-- 
Pedro

