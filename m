Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19029CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DFCE6B0092; Fri, 19 Jun 2026 07:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 790196B0093; Fri, 19 Jun 2026 07:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681BE6B0095; Fri, 19 Jun 2026 07:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD026B0092
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:58:15 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8E129403EE
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:58:14 +0000 (UTC)
X-FDA: 84896514108.25.0DEB876
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 977AB120003
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:58:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xcG3Mp0c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JtD485uw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XZ0i9o1H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Jm3/gCzH";
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781870292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOTWgH3E4efc1DupZXjdNhTQSV74w9qLI0tTsa0YRXM=;
	b=PDqpCdGSGHdmDRgcaELD4Aa7cuPaZZcmrcajfQvK20ZHjAHn0dlM1IWKnuk20CLFlefTut
	rCfzQN6+NsHqYIiR5TrLlWGA/kfFygKURmPiHgl0or0/hVQWp7c6/gOrcKHjFupSeY7+KN
	tJoTFCEH1ec4PNIqKx3yAjL2A5DeG2g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xcG3Mp0c;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JtD485uw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XZ0i9o1H;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="Jm3/gCzH";
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781870292;
	b=6IsnBab6BjXpmB8uC/UUHDfHPhxQdMdoLpkcnPy+xvMxcdQ/dcFJ2dhNH07/i7kqGvoQ7E
	5pH9BYQlmTXs1mAdcq3NVWs+8Q8rjAPPO9k7WZP+blXskaZHhjPYOYPCDe8i4qqO74tyOg
	BLG9KkqitLMS2d+O5D2GpW9uFHRVyU0=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DB811760DC;
	Fri, 19 Jun 2026 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781870291; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wOTWgH3E4efc1DupZXjdNhTQSV74w9qLI0tTsa0YRXM=;
	b=xcG3Mp0chCVY3q97c2+ASVvMLOv2ytxXf5DiYRpiCCeP0vByIZuRBQk4S1Le8SsO4j9WHg
	ZlC8Imrh4AG8o/0Te8lzHu/1zGLxRczeVj7ubpc3bwrqkuWV7X3FnKg4OJ7yvSMlfvxBEg
	HUDIigaKtTZmZOuBjNG6/OaIL7FRB+A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781870291;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wOTWgH3E4efc1DupZXjdNhTQSV74w9qLI0tTsa0YRXM=;
	b=JtD485uw0ODNLUc+pAK1o0gU/G9U+50Ja5ITBvVHV/WW1EgIw4wJwZM7feAC3a9mhR0zSp
	I1TpWbMK9BNMMDDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781870289; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wOTWgH3E4efc1DupZXjdNhTQSV74w9qLI0tTsa0YRXM=;
	b=XZ0i9o1H6UuMo4I/zn7EcsBePI9wPDcCAIwJnosYZD1FFOGwdJGxlj/Ik7oUDWvgVKQenf
	8EZbSvAQOMuWj/8UnLyzGrsoylCYyU/s+U0y9qRECr1dFyTQGE4kbVegAlQwKpHIo+xIRo
	jWYjmlcx1Whd4iuzpyp86/QYEvT5eeU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781870289;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wOTWgH3E4efc1DupZXjdNhTQSV74w9qLI0tTsa0YRXM=;
	b=Jm3/gCzHE0tCe1rhtXeHiX5IcIkL9Nr5YtH19aZgD4qySbwBNlizfNpdzht03A/wbrPDGz
	EaMRX8UBFpGb2/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38890779A8;
	Fri, 19 Jun 2026 11:58:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id koXVCdEuNWp3BwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 19 Jun 2026 11:58:09 +0000
Date: Fri, 19 Jun 2026 12:58:07 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Frederick Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixses] Revert "mm: limit filemap_fault readahead
 to VMA boundaries"
Message-ID: <ajUuprlNICagBYHB@pedro-suse.lan>
References: <20260619112852.104213-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619112852.104213-1-ljs@kernel.org>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 977AB120003
X-Stat-Signature: pa7hj1rq9fmgqaguddu79dnj4j169oia
X-HE-Tag: 1781870292-114648
X-HE-Meta: U2FsdGVkX1/h/PJ4q8faqb6OyR6DKz7KrfmW7r1dsWB87u6PG6m6NZA6bpdrSxjiIBaP03DYbR7rnSgk478cnBWPJdrLlXkdgwxqYvfMhTPpNC7kigFGDi0HLaw5OJb5JYfQolnCAzU6FHXKiVc4RkarpvIwv7e00DhMASdTPc4luHpX2pUWtM2AnZKdC9E3A5RwgxSTt9YvQQwnaVI9wu2+u+m+f5Nd4ZqObydGR+ZGRGmOuNR4oGgf965cGu7JKvuxPpFlXUEhEqqeKwlZ5R8pJkqSgAl9lmBDIHsW7xU6aKoHbqvdWeK3SYdOhbDBWvnTFboExUJ6ouqHxpUQYJdp6aemCkvIcbW4TnMkaIUsb2PcGlJebraJ3NNsTk9foF6pQu/m6T/s7z2HbilM9c4iCK874iv8HyvaG+lQXO7wQz1ywKxEpiJtCDakZ9H+C4hCubX8azBk7KCgTz6m6ZlDO+iIILI2ruHqFYoIyAXlTDiNBPOfiwogOkVQ/vIachPJkot8SuRe8UNq5vZJN1LYPKypuFmqHzsllJOgUoaj+OQxHtjGbLrwS6Ja02rdPgRE3QveMkeFS2KSdEsq26xYajtBv8pVzE1O9v3xbDY7NwNs6uzmbT0mvg1qtDBhHcUeHxoBG8cQqAZ5D6G7A63VdmCw8P597POmmCXox3z4WQRCYbT+7LA4/8VCJxhiqzzHgTokUzoIC1BetSynINGLj1fRugiuB4xTj2GUbqab4TtBUlWhSHe7le8Nh2TmdK3w57p4ZqDUZBMYovw3ploFYziY8iRepO428DNCEdZR6+EX68nGPZzdY6+R+AjaWJAp9BR0Z/restIxG4ZRx34ZNzDYCldH8meIX8b2UKLf3sGPF8yNmzxX6YbOrLm/SZ3n+XxWM5Hpr0av5FNBgnggDxOs8NZdxjEuJsSKtlYjonYCL2RedDoulqveu2xl2Q2J8wi+a6RxMqm71MD
 FmpuCdXP
 iqWStyk+0B3o6BWgqIj6LT/41OLDBkVOn2oQPuJndpbnZDt7L6cJgmkIUVgCa7vczOsKL4wZlIZ0wWDQ6qxF4enBe2RWvdMx7WTAANPGtBBhZCJJEXKNvMS/4GXz63pyZ+bgRI+zdfxNNPIjgH7/YgqEKHyjGaR4evbTgTmE0tttg9XVX3YEiVTYjsy6WaBjpVhPdGAUED4tAlFaLcQaDqQOPpuMJH+92Y/jrump6VAhCfoAbkkP+aTu4r1X14syM9gpx3/rhd6pcm/hX7yBz/KddoXqxKQuA0LNJX4umhZo2gZ9mBQFlidLy6FrAFi5jdnMdC3YX5Fjpr+4C9XGc3DVVGD/WmIgVe9MK59VlmnmF+0UGCKLi7Jzxr11JzitNyYjH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 12:28:51PM +0100, Lorenzo Stoakes wrote:
> This reverts commit 7b32f64bc512b40b268776c5ac4d354b325b3197.
> 
> This patch caused a significant performance regression, so revert it, and
> we can determine whether the approach is sensible or not moving forwards,
> and if so how to avoid this.
> 
> There was a merge conflict with commit de97ae6222c1 ("mm/readahead: no
> PG_readahead on EOF"), care was taken to ensure that the revert retained the
> behaviour of this patch and cleanly reverts commit 7b32f64bc512 ("mm: limit
> filemap_fault readahead to VMA boundaries") only.
> 
> Fixes: 7b32f64bc512 ("mm: limit filemap_fault readahead to VMA boundaries")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: https://lore.kernel.org/oe-lkp/202606181547.617a6967-lkp@intel.com
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

