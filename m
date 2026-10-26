Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F206606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=xUTHZBxn;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rFNA1ckD;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=xUTHZBxn;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=rFNA1ckD
Received: by kanga.kvack.org (Postfix)
	id A35026B05B4; Mon, 26 Oct 2026 09:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E5EB6B05B5; Mon, 26 Oct 2026 09:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0196B05B7; Mon, 26 Oct 2026 09:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4B16B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:23:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9724D8075A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:23:26 +0000 (UTC)
X-FDA: 85364844012.08.2AF216B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 101F512000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:23:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUTHZBxn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rFNA1ckD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUTHZBxn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rFNA1ckD;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=54BFzYUW6swCFljasaktNgeI4y2LeWT1KlgHkjBqlXM=;
	b=jUyLrd07pRO0LSr1+V+hKVTQCrVN0G33xl+oWgqjyo+aUhAsXJ98eybYJaR7ykHEdtRDlt
	t2urNUci+F6/S2xKbRg3FLUy4ccDIWzDXc8XWR8lbBdWA+XwukxNvR+wZwwJGUnSeEuoX5
	LoCAFSuvoBPqbt2/xnOgIErfEtNBOn4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUTHZBxn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rFNA1ckD;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xUTHZBxn;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rFNA1ckD;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021003;
	b=USBGAIEsBgx2lduW8pcK88cMipIFD/sSD6zx9ly4e2EvgG5lEAHxhuDay5/5axgWsNvRGn
	MwIuJ0RiCNIr8rBhGyr+oOhMU2sFgGtn4kZBz8FjK3hX91t6kFEatl5ZYUNgEnxvhwXWf0
	zDX3klLi6saYp2JZepsG1mYNPrbX7Mg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A0B091F7A2;
	Mon, 26 Oct 2026 13:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=54BFzYUW6swCFljasaktNgeI4y2LeWT1KlgHkjBqlXM=;
	b=xUTHZBxn6Fo2g52rorYT5AJWKzV66Id23PhftBav30xkl7j6RiYh69IPrW90yW1RBaBcRA
	g4zduRyUpGY0uxhtNlpauSE01zaC7UwyXK6WhqS7dxLU2kTlG9/JEemDkwNUHGkwp2kjB2
	AHURIxwMFenZE6FTzRb5SogE2S0+BoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=54BFzYUW6swCFljasaktNgeI4y2LeWT1KlgHkjBqlXM=;
	b=rFNA1ckDmi0Lx++fuoLze4EEJUg5M/hJz+fhBtonx3VevMQAHz3F93vSWv0YI5az+v6NB2
	tDvWHLjF2Kk9sxBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793021001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=54BFzYUW6swCFljasaktNgeI4y2LeWT1KlgHkjBqlXM=;
	b=xUTHZBxn6Fo2g52rorYT5AJWKzV66Id23PhftBav30xkl7j6RiYh69IPrW90yW1RBaBcRA
	g4zduRyUpGY0uxhtNlpauSE01zaC7UwyXK6WhqS7dxLU2kTlG9/JEemDkwNUHGkwp2kjB2
	AHURIxwMFenZE6FTzRb5SogE2S0+BoU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793021001;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=54BFzYUW6swCFljasaktNgeI4y2LeWT1KlgHkjBqlXM=;
	b=rFNA1ckDmi0Lx++fuoLze4EEJUg5M/hJz+fhBtonx3VevMQAHz3F93vSWv0YI5az+v6NB2
	tDvWHLjF2Kk9sxBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 917C613408;
	Mon, 26 Oct 2026 13:23:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id e6j3DkhU32pqcAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 13:23:20 +0000
Date: Mon, 26 Oct 2026 13:23:18 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Hengyu Liang <hengyul@cs.unc.edu>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, liam@infradead.org, 
	ljs@kernel.org, vbabka@kernel.org, jannh@google.com, usama.anjum@arm.com, 
	avagin@gmail.com, mirq-linux@rere.qmqm.pl, arnd@arndb.de, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: return -ENOTTY for unknown pagemap
 ioctls
Message-ID: <at9Rqspz6uUpu7H9@pedro-suse.tail5790ac.ts.net>
References: <20261023181300.3366487-1-hengyul@cs.unc.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023181300.3366487-1-hengyul@cs.unc.edu>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 101F512000D
X-Stat-Signature: jrt1mffqusc8zd8by8aemco5x6dah5r6
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021002-974708
X-HE-Meta: U2FsdGVkX1+Y3fVpxpeTv3Ry4G7HRcZAu3sqSsJ/eTAyWZmy0mRunzOLj8mVgiKwEslFzutLMbqlba5sETGOVvMTPJ3XYGSAn1uS79r9LeF/JDCc15Ev8ZUMPz2aYTgND562ML4ixtVHE5/uGfh66UbrVqD+GLejjWS0SFADcoKDn55UdSpSuTSRGi3D3+pqI9uPiTFQvISFjUvQCcylvq2BXnKAqv+EdLucII9UZtdVKF9uOWjCrh3RTEfRphUwR3s5btrAun2QyUCDgCjXrKLTooRklzrJnevIFpM6tdbOjJojs7NtQE8pycwKAKAgrkOW3kpXIMDMCOvcpPifRT7Vj8NbhsHqf/UZUjN9fWd7eDcByDSdHjoxr6aC7Qwr0UqaCSI8xmxYrdxXDnWGLLKhfSE81Aezeef/9YItXW75QlLT1ATbcOqPcCTNBLzGUW/NMcw6ozZORCwk0pDvMPVbD8wo2ICGAcyFh9Oq9bt80f3sGi6JPU8MAHqa3L8kBXokqdekN/6UHpoA92BWiAxuhoDFOmxHRFUw1AdxtFvP33i3jUyhSv+WJSNluofg8mhE4cW0SVVWUe2bicrHS6lL97yEVaYV8N62/Ktk1Cv9wds7Wn18i09hPD8p//0qpuyoRO3uMP8FrBSm6fTxFocuxp4cnW882ttWCxf+M/XAm6vSZlHECnUTKE2GEp+uc9XbR2BnyklBqrtCB2rFkfDRHycPZVCOAs+SUcS72Pcn7ChpKSFzNkzizZ7qlCxd1u6sDOhhx0rkVUGNwlCOkp1fOtUj+WK/azuZh7NNATFtotM33s1Ds9YIgI8Frag6R5vjXzVZ3r7XuVeLEUs8hymrbPBNkaTC85Nf4Kl4of+0dJPrKwyvcgXOa6yox/pUBeDT+c3gzaVCGhx+mAuZfPH7p5ifCCPJRCshW/d2jDeFMRKVk1BlmY9Fgpci3T8NPNBtOEsw8OH8ItILlv1
 zpf3p6fz
 jb45uD6sYFJ1xL+18saUtsXVN/FRjY5RzE/yx9+G8p0msOx7uwzmjTrStB6Y07kfgC2zBy/ikKITEFzImNocS5pftPdd/y/OpMvYrEjZmjLOwqMiiVJ5g6F/lcs5qDLRgfnkQOJucv3DAMS7bKEPCkwtYjvKuOojhEczEAKL2L3tkRWweYJOw13OkH1/gkwIh2NQ7Iqmw7XQmTVvfDPU/zYxO3PItkhas0SsNeoYFMyxnIR2QrZJyo8uYezNVs4Sbqd37+TCd1npU+XW24QmqYGZK0RfGwcNRZAmvH13UYB2KxV59bmF4RQPF4MajcKwdXM8plXgWzCLYFuZl0UhZjISnm9UiyMC15CfR90vrXWA1G7RFWp8f71ePGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 02:13:00PM -0400, Hengyu Liang wrote:
> Commit 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
> optionally clear info about PTEs") made do_pagemap_cmd() the ioctl
> handler of /proc/<pid>/pagemap.
> 
> However, do_pagemap_cmd() returns -EINVAL for every command other than
> PAGEMAP_SCAN. Before that commit, pagemap had no ioctl handler, and
> the VFS returned -ENOTTY for these commands. As of now, they fail with
> EINVAL, so tcgetattr() and isatty() on pagemap report EINVAL instead
> of ENOTTY.
> 
> The issue can be reproduced with a simple C program:
> 
>     #include <fcntl.h>
>     #include <stdio.h>
>     #include <termios.h>
> 
>     int main(void)
>     {
>             struct termios t;
>             int fd = open("/proc/self/pagemap", O_RDONLY);
> 
>             if (tcgetattr(fd, &t) < 0)
>                     perror("tcgetattr");
>             return 0;
>     }
> 
> Before that commit, the result is:
> 
>     tcgetattr: Inappropriate ioctl for device
> 
> After that commit, the result is:
> 
>     tcgetattr: Invalid argument
> 
> This patch will return -ENOIOCTLCMD for unknown commands, as
> procfs_procmap_ioctl() in the same file does, so that the VFS turns it
> into -ENOTTY.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hengyu Liang <hengyul@cs.unc.edu>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

I would generally be scared of applying this change, but since this is a
niche API, and there are no other ioctls for it, this should be fine.

-- 
Pedro

