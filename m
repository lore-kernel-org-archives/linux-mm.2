Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C29CD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 08:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19E9C6B0113; Sun, 31 May 2026 04:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1504E6B0114; Sun, 31 May 2026 04:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F026B0115; Sun, 31 May 2026 04:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7D896B0113
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:54:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 889CC1202B0
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:54:46 +0000 (UTC)
X-FDA: 84827104572.18.668A1DE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6A32B180006
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:54:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1PfAKGNY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ksGbBsF0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1PfAKGNY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ksGbBsF0;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780217684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=E5gQWW6znk1YjlnqCIl4kHUdg7PYEZUplove/sASg7VIIjNS6raUQj624xyjkZfapZ3FIk
	xLbKKuE/cjZyL/QauL80IUC+0kooyseCyBZvWEFvG1d+YqFu9nfMpPj4qmLdeO1Td/BFJB
	Zh+LterdCCNfDu4iEBEXWVu4e2H0gHw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1PfAKGNY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ksGbBsF0;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1PfAKGNY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ksGbBsF0;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780217684; a=rsa-sha256;
	cv=none;
	b=j7010bAEabf18/YKUWN/HcfXQpwXz3MD7Haf2zkpPZq7Ro4FWwAQBZ2d/d74WtRJLs87rA
	fymPnHJLS4gpyJ8zVU5Jrq2fe7aL3F5usbKctP2fGijbbtxcicdqmdVuKr1kZqVrV5plzz
	3oiqAh4f33JTH2X7zJfCnYeoHWm9jUA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A2B286BA92;
	Sun, 31 May 2026 08:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780217682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=1PfAKGNYLhagnBvHtb+ubUaVyu9eogDCXRol6ohlXDMFxCVLhFUItxHBits6KpctmU2d6t
	hjOkZY+H+sW25hQOlhwUmoBGxnvWinhWyOjXTFHii5/+Zyi1L4jRc0FGHpofRv/ahs6J5V
	2o6/tAb0rqCc+3mrBE1xUVyLpmVJQ3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780217682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=ksGbBsF08j/fhsEIBfTY36miAanUPKePhehRER4eUB5+fCdFIDz6w/p2pNFvC/CmI5vu1X
	Bh+SJJZVD3cLMxAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780217682; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=1PfAKGNYLhagnBvHtb+ubUaVyu9eogDCXRol6ohlXDMFxCVLhFUItxHBits6KpctmU2d6t
	hjOkZY+H+sW25hQOlhwUmoBGxnvWinhWyOjXTFHii5/+Zyi1L4jRc0FGHpofRv/ahs6J5V
	2o6/tAb0rqCc+3mrBE1xUVyLpmVJQ3Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780217682;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oA5hgG6eSfUw2CEvXNqok4AuUZspexuZlfa6cYW2Y4A=;
	b=ksGbBsF08j/fhsEIBfTY36miAanUPKePhehRER4eUB5+fCdFIDz6w/p2pNFvC/CmI5vu1X
	Bh+SJJZVD3cLMxAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6892A779A7;
	Sun, 31 May 2026 08:54:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wCuGFVH3G2qdXgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Sun, 31 May 2026 08:54:41 +0000
Date: Sun, 31 May 2026 09:54:39 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Askar Safin <safinaskar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, 
	David Howells <dhowells@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260531010107.1953702-1-safinaskar@gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: wkej8go8189pw4osp3dhx51z8gur4t4g
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6A32B180006
X-HE-Tag: 1780217684-72656
X-HE-Meta: U2FsdGVkX18k1zJ4NfEFW/+mNe2AzWa/OlfAiNtONyNcAlKLehMFxYoHeJsf3hJoRdWx1DQAYhhBSuoD9N88CThSszqHwf4gYB4228nfYAejloz7/3z01bVSkJU077ehHP6hOp+5K9ZMVHGkOAMEB/BefphfpFKkH1DKQ9OXxlebuPM4znY6YhGcJBRTTGHzefyoWzLRoL4wbY5ljCM/LnfGgskIbG8yU/5ltbifpnQQw0qto87Zd8dQyYmC7XGjmo4e5oqs0IvYM3bb5JmlX25oNk/y8e5ghNat9P1LW+hPYYVrCUKKdU989wgBRL/DLbX9zHMI6VDUrpyzytF7m8c1NYaEJbbxQ561ciD6X4/IQvQ5OnwGfywDyxl5GfQ/qksinJ7phTPZaYAQBnEpcvF9SSXKGxoCiVWISlc4IqUYEjjn8/PDASubYDsLicTE5USWQvEgrqiqxTPWQbdvb5lvee2LUONIkRDUu6A8CHgrTe+/V28OW5S5yiD+xpEO3LX1zLv/PhfrCU1oj+dFGebMnwM6YPUoxk5OEV+4nBuCSHbcVfXzjEE+h+xGulxi3OBUxGe4Rci2PzZ1EdtNJk7HFdQR6EtNB//PCFfuQqhzxUQdQSZdOpiF8Qq72flNfpxb3nbLna6DXmUhvLRMdDfAJ9hB4srZVaXaAbNvp5kmIs04sm5z425GqFRQiPv/uSJd0Y2csioPx/ZoR6DD1bI8H8nj6EZ3VeUjZY3PGS/vkeHmGMXO7/hYTChCysnq9f5l8fmve+kSK3xkq5t875aKwgYVecsMTDRbOVartbOqBC9xPf6AjDX7tCxjMZUFMfIUj6rUpHldFycE6ENp38B0Z6A1gjCA/qqJnneqxfSW4KUnwoa4qeBF15kzPsqwwzup3tqUrJs5OP1qoLiYIDZm3HlilPg+f6TQT/s48EHU2OzByyQzZyTIIuLkDjt1jHd1u/i9mxPWbBlLR+a
 CVjkD+kp
 7IccHE6dOrMdhWPxfbbJHSr4uPYwLXtrMQ9FlwQFMF2L88k1oe1MDIfDqrzc4pGARBvNtLYUhQgdgArLMTcmKDsililuylPsClkuxwUk9Khw7Xmekd3FmbqmICIDFJxwdQkgmaeiIbwKS3Fo+Bt3oSUiUdNNCUAlsWW2tAav4dg6hlXOxlZwVV1JISHknqD+3nBGRNIyuc5lie+ouDeFUd02wrfEXDwwY7ifFxlPAHcrW9pj1RE5kojste++U26chYXpDfkHc4jubRzYCdoe/9PLu/hc0du5M4gxd3iX0NLCvmy4Jh+NtvOQgla3sV9fE61Ap9s2tiHov6gmeKtYgIuGMhoga8Ei8Z/KJzJkMLtw0SMy71hPuxsS39K5D24KrKU7WlfryqEp8dItzdd9L01H3hOS9iGc5xrXRFe48LWb0ek61auRLB6ppfKgpUgEc3ECJvCePNJDkFtM+ASZrDPtLXrhjdVlDLi38ENc+YvWs4qI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 31, 2026 at 01:01:04AM +0000, Askar Safin wrote:
> This patchset is for VFS.
> 
> Recently we got a lot of vulnerabilities in splice/vmsplice.
> 
> Also vmsplice already was source of vulnerabilities in the past:
> CVE-2020-29374 (see https://lwn.net/Articles/849638/ ).
> 
> Also vmsplice is problematic for other reasons. Here is what other
> developers say:
> 
> Linus Torvalds in 2023:
> > So I'd personally be perfectly ok with just making vmsplice() be
> > exactly the same as write, and turn all of vmsplice() into just "it's
> > a read() if the pipe is open for read, and a write if it's open for
> > writing".
> https://lore.kernel.org/all/CAHk-=wgG_2cmHgZwKjydi7=iimyHyN8aessnbM9XQ9ufbaUz9g@mail.gmail.com/
> 
> Christoph Hellwig in May 2026:
> > vmsplice is the worst, as it is one of the few remaining places that
> > can incorrectly dirty file backed pages without telling the file system
> > and cause the other problems fixed by a FOLL_PIN conversion, but it is
> > the only one where we do not have any idea yet how we could convert it
> > to FOLL_PIN due to the unbounded pin time.
> https://lore.kernel.org/all/agwFlBKvKytjURDO@infradead.org/
> 
> See recent discussion here:
> https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u

So, you took an ongoing discussion with an ongoing RFC patchset, and you
decided to reimplement part of the idea on your own, as a concurrent patchset.

Riiiiiight.... I don't think I have to NAK this, do I?

> 
> For all these reasons I propose to make vmsplice a simple wrapper for
> preadv2/pwritev2.
> 
> vmsplice(fd, vec, vlen, vmsplice_flags) will
> be equivalent to preadv2(fd, vec, vlen, -1, rw_flags) if you have
> readable pipe and to pwritev2(fd, vec, vlen, -1, rw_flags) if you have
> writable pipe.

This does not work. https://codesearch.debian.net/search?q=vmsplice%28&literal=1
There are users.

-- 
Pedro

