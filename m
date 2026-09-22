Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54179C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 10:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A756B00A6; Tue, 22 Sep 2026 06:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33B4E6B00A7; Tue, 22 Sep 2026 06:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22A4A6B00A9; Tue, 22 Sep 2026 06:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1A796B00A6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:21:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DFCFC0424
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:21:00 +0000 (UTC)
X-FDA: 85241005080.20.637E426
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5769420009
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 10:20:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="pH/IjMeu";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OvIiBQPU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LVyxfCN0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="SmHGB/SI";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790072458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tq2QDVpBjjYWYAhsxdz+8PGZW/rKjO4PXD0rtR+Sk7E=;
	b=0WLnStAVnRbTJ7XzSyDgKihRO4lwJszgHoc5Cj7oxRFAuDGZRdUlwWSbJ/VG0RqV+Nmw7k
	vWSx8Gp4IxBKfYo/F7a3Bo2d6ZF6FQ4n5IZZpAJIxgJag9gVe5+P3KZz8FICldHCuUdwGh
	mArYFjF2nnT2qXJ5+AAklqbaloUzg7w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="pH/IjMeu";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OvIiBQPU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=LVyxfCN0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="SmHGB/SI";
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790072458;
	b=D56HlIhRGVYISL2CPDKy1In1a6iRmOcuP+0W0802UrC59OOnHfHX2VTghXopktjqpUUDzw
	TCuvi2kz+PtM+g0yieuz6bHNyTqvuFqOSOiLr5jRNvZaLv38FSUV52PVqa3/pB7qndzmuC
	xGDaz6D+a4pwNY8i3fMYqlmvpth3yX8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AAF7021CE4;
	Tue, 22 Sep 2026 10:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790072452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq2QDVpBjjYWYAhsxdz+8PGZW/rKjO4PXD0rtR+Sk7E=;
	b=pH/IjMeuGAJ3LQe6XHHZbPMlZpk84c/SjMDd/TOnxDdCSOFROoMvdeYnLT5UqXP+/yevxi
	fvAPcdYIYnSDCk4XE5b7rD5tRx77a3LEjXsxaYOsaUfGo7oo++pC9CZoTM8tlcJafwx/KB
	+MggSO1tBd9K07UsKLn46hXu2hO3ybg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790072452;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq2QDVpBjjYWYAhsxdz+8PGZW/rKjO4PXD0rtR+Sk7E=;
	b=OvIiBQPUnBhJktefDYsIHOdJs4oJ7XXgV9/pjWdpYYl5Nrsp0bblnHw4bZNmb0eefLe0z2
	0eW1w3Z1AQXZYCBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790072448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq2QDVpBjjYWYAhsxdz+8PGZW/rKjO4PXD0rtR+Sk7E=;
	b=LVyxfCN0dT3V/fWCa+D7ubIyjCziP1KpZaBraLyP6vmbwzbkwbgc0zqD19igGtvTzer9V5
	s34/9cn9h4gb8BkDQZmyouIKkA9fzazIvcqWsXLaG95GwHnnP4cEHYpk0AfsOU2FJXOjKq
	lL+AmEXL5Wgskan5o2LhhbgcBZRPRjU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790072448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tq2QDVpBjjYWYAhsxdz+8PGZW/rKjO4PXD0rtR+Sk7E=;
	b=SmHGB/SIgoix+o6WIHsJQwJbpG3IlM383k2yj1MUdF/MD4xU0J3BimrF5maYlprlVkos6X
	noyw2ZTiZQHZ6JBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D89D9132D3;
	Tue, 22 Sep 2026 10:20:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 3mGhIn5WsmqaIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 22 Sep 2026 10:20:46 +0000
Date: Tue, 22 Sep 2026 11:20:40 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jason Xing <kerneljasonxing@gmail.com>, =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Jiayuan Chen <jiayuan.chen@linux.dev>, Willem de Bruijn <willemb@google.com>, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 6/7] mm/slab: Let a bucket set handle __GFP_ACCOUNT
Message-ID: <arJVktqS-CL7zNX0@pedro-suse.tail5790ac.ts.net>
References: <20260921075811.too.775-kees@kernel.org>
 <20260921075820.1718334-6-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921075820.1718334-6-kees@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5769420009
X-Stat-Signature: 6t98sc9yc7y1pssthj9yxz4rzp3ymxfh
X-Rspam-User: 
X-HE-Tag: 1790072458-799804
X-HE-Meta: U2FsdGVkX1/sWA33tcY7Otqf1cOARiA40ur88ne4sfaf/ElfoRfZyasyzUTdEUYnrlZWYQwHrIv3tVA1HfJzx2jDo4jjQCEu3ZQB3rxGfXF1vzrP9IIDO+LN/AZSB1Q1MqGg5MJkyfZFLjDvXA18E9xgwAnsD5i88Pc+/YDS2DSzMeHQ2bR9QrDlBRYUDip3/d31aXLJHw7KcCH/hS8cULjoyR2HscksczznY1AjyW8F2LoUjRjClXVhC1fpYJjEyGfYtWPg5ghjRoIKGYVqrdIFN50jII5c+qHB/+iUjENoba/0n5LuKf/eeUZHBKABUK6tDaIvvOaw03Tk+1KjdWLaCBpCyfHKBWj59bG/P7+RVSJzwRAiZZ1s/4PjY9a+xrPXOYFYQvCp7UMxAGbr39RWty58bg0ZguPnK+yXRSPdygIcFH79bgvednVIfGZ7mivbk6Mr+tY9FhGBkJDetlgCEczrb8sclCPJ/vHb89/eZF0YYHeuGCnb2Zml7deEZ7P98tWulvp5qYGPB7ka0ODN0koXh8EivVB4QCeuKzEB7bKB9dheAfP87hgStrUMCggcpE/ieUZxWQ5vE4elEYb8MtHeAceaI4AnwZWOMHVP9WBjF2AoNbFosSGeqQYXKIRE6PHKFrXWAfg0QuN2/QOmmDGUraYdxRLLjIF+TOAlBvFdgQstQmEcFtKsArPNasYxmhctgXGpDveNwYrVfr5hQWsI7ehk0Xvp/SKmLNxxz6Gvnasz4F+1Od6gxtZDVC3FaUUO84ihCPQVCUvetppzpgh/xabjKPjElIoW9VKY72zNxMD9jTLv5hZqlNRJoX3Z605mX0nynbpRHQzO84gBinQVv4DFrAvo7Au91vXlvZH7ZAqO3tioafelLgp/Syxm6O+HiHKjT5hEDw/MP5XFzSn2KyyhmjzXqYnr3eEyu6agElwyLRBoVNgCl4MmBUmU6X1QmS0SJ63I67C
 a+673ahh
 aSdFyvCNJd79Qn+R4AfC+6TNYA95QHyA1+C5oMBOLZfnFfqT5chAinUo2dfavDKrBgX819PLf104CX53e0jLf/o/Oj/zVB5nEp6mf1NvyB200Geu0iq2DqocFF4hgqjH3wm9YKI8OmdfdwEcFDFlOp+eq1ZvZ/wQflNaoJ7sS/I5aZudzrckXeapo8GSCHZiSM97Zvwr6ejjnfGsTWl/IowO/Rhpu2KoFg5BJ4Z6n1ezcBcn9G4RPWS0rCauK0DwTbDZlyhQ+CK2aJdz1WDu9F+lXnJyd3jTaZLUAzprcRc6HjNNtnY+JhGuibQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 12:58:17AM -0700, Kees Cook wrote:
> A bucket set holds one row of caches, cloned from KMALLOC_NORMAL, and an
> allocation of any other kmalloc type falls back to the general caches.
> Extend this to handle __GFP_ACCOUNT, so that a single bucket user can
> isolate either GFP_KERNEL or GFP_KERNEL_ACCOUNT allocations, as is
> needed for skb data, where AF_UNIX uses:
> 
> 	sk->sk_allocation = GFP_KERNEL_ACCOUNT;
> 
> The coverage is selected at bucket creation time:
> 
> 	b = kmem_buckets_create_types(name, flags, 0, INT_MAX, NULL,
> 				      BIT(KMEM_BUCKET_NORMAL) |
> 				      BIT(KMEM_BUCKET_CGROUP));
> 
> The prior kmem_buckets_create() function keeps its name and defaults
> to only KMEM_BUCKET_NORMAL, leaving existing users as-is.
> 
> Only the accounted type is offered. Nothing wants a reclaimable or
> no-obj-ext row, and of the twelve places passing GFP_DMA to an skb
> allocator, all rare hardware: b44, b43legacy, prestera and s390 ctcm.

Well, yes, BUT I don't think silently falling back is a great option.
I would rather things be done Properly(tm) and kmem_buckets allowing
instantiation of most/all kmalloc cache types. Given it's security stuff,
I would prefer being quite explicit over silent.

Perhaps, to save on memory, users could choose to fall back to the default
caches. But at kmem_buckets_create time.


-- 
Pedro

