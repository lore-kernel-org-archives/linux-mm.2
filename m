Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D977C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C1FC6B008A; Thu,  9 Jul 2026 06:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778346B0092; Thu,  9 Jul 2026 06:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 663456B0096; Thu,  9 Jul 2026 06:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9626B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:22:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEB23C21C1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:22:52 +0000 (UTC)
X-FDA: 84968849784.05.4E3C918
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8BB691C0003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:22:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dje02QeN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtxxGKZB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dje02QeN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtxxGKZB;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783592570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zx4/K/592I8NvYZBqlKcnuj2Yy+ngX/K4XOfGwEMKkc=;
	b=xgT6GMkBtvXbwsqYdSspZwcufRytP2xAndcQE96sx8x8XYc5Rm7logPPy/tg49eixHTH/D
	9vGuXH+CzgOKszSr26pB7+G/qoWJm3GgvWS+Ju8lwc3twno2El44aw+BfJzoSudSPmJraj
	J7/VHrxD5xZrOyPk8Pv4yZLQN+FytOI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dje02QeN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtxxGKZB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dje02QeN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AtxxGKZB;
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783592570;
	b=fsmYtYY9M+UvXYrHfy27RSBUmWx7LaJHJALWRgrdkG4moMQngSHIABoJ4R++KcvvcqzokV
	SH2/4MctZzA77wxtd0dspLMVYAo8YubmrcVtJECB78WdCGU8m/55XNVFIWgoRxppyNsmeW
	OM6F9l6y9wne5G0Wa+lzJDI853M+VB8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C1D827610B;
	Thu,  9 Jul 2026 10:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783592567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zx4/K/592I8NvYZBqlKcnuj2Yy+ngX/K4XOfGwEMKkc=;
	b=dje02QeN4Kv4vewc8fdEDVAyiP6dM6F2MCy/4dbE0DPWyaDVjCCsl/AFlDNN0Y2GW+6mj8
	JzzCg5K0h0nYq6JIiWICW7w9elGyxQfGH2vXywtdYveDP6NlWkHRdGrqzPAFk7ntImzmD2
	3+NKc5X2ujcwu/aVbMg8TO/B/h58hn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783592567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zx4/K/592I8NvYZBqlKcnuj2Yy+ngX/K4XOfGwEMKkc=;
	b=AtxxGKZBJTGfrfXeBqEvc3IB14FA4a6umkjlwYGgREDYKTamlpyIeMBSz1SOAzSikCgSnT
	+1OoVmHVLMcm1dAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783592567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zx4/K/592I8NvYZBqlKcnuj2Yy+ngX/K4XOfGwEMKkc=;
	b=dje02QeN4Kv4vewc8fdEDVAyiP6dM6F2MCy/4dbE0DPWyaDVjCCsl/AFlDNN0Y2GW+6mj8
	JzzCg5K0h0nYq6JIiWICW7w9elGyxQfGH2vXywtdYveDP6NlWkHRdGrqzPAFk7ntImzmD2
	3+NKc5X2ujcwu/aVbMg8TO/B/h58hn4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783592567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Zx4/K/592I8NvYZBqlKcnuj2Yy+ngX/K4XOfGwEMKkc=;
	b=AtxxGKZBJTGfrfXeBqEvc3IB14FA4a6umkjlwYGgREDYKTamlpyIeMBSz1SOAzSikCgSnT
	+1OoVmHVLMcm1dAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B97AA779AA;
	Thu,  9 Jul 2026 10:22:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1wlCLXd2T2rmdgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 09 Jul 2026 10:22:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 66888A12D7; Thu, 09 Jul 2026 12:22:47 +0200 (CEST)
Date: Thu, 9 Jul 2026 12:22:47 +0200
From: Jan Kara <jack@suse.cz>
To: Chengfeng Lin <lin2530632123@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] tmpfs: flistxattr(fd) small-list slowdown after
 simple_xattrs rhashtable conversion
Message-ID: <q6pq2txjkc4hkdgo23s7t34l76rjsvbyebthqcawjq2dz6aiv4@rfygllbnj77r>
References: <CANGjgdm=gbQj=tmakUipHz9wR-mUvMVECfvJbTm=sEufxOe20g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANGjgdm=gbQj=tmakUipHz9wR-mUvMVECfvJbTm=sEufxOe20g@mail.gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8BB691C0003
X-Stat-Signature: gt1biy4atjgzxr7j8cmjfg3srfjtpdqc
X-HE-Tag: 1783592570-947381
X-HE-Meta: U2FsdGVkX1+n4axO7KQJo52mOFaDlj6AwcC/90SRi3JvFQ7ttfDJ63W55S5STwjVNpO/YOxDRILk/0ozZtmdeO1ZRS2DCmyuGxlF9z3MX/V4OD5GtOjXUULE3XPxzvyeD/AhgtRJ6EeyMaaNlC6EThZZdrAm4yZxd+TN4lMFXeSKCQ5dCHWpOCr1jwDLLKrpFWS3HDcCuvEeeIS4jE1+3y0u8ck5gTofg2gMw6gkQA49fUDyvWZ8RA4yR8KyPAp2n3jXR+Dng86vzy19olKYjGqoUU6DpELuC+2+h7G3bhku5+7vNdYWu/LcNd+XA9/PjdRjrCWLD9CJGkXbZQVclNTfd5MNFowSTFfEhNtvzxSbiRYw46FqkpzhUjJCVKQpsie1ghSweKwQDf6z7vzrj/ooy1tdOO6B8ERMQuqO/7H1PWXue7ZU/aMYtFb69/ohOLrDUtg4fQU7aKvYrcpyxRHtXo1ddK82p9908PXPyoMJeQzF1oKIf7thF0umk42TtCVShy7A01YmpLbtRqB0pBKxsgLiM3oAxQ/d6GR5NWSN/vU60isI1jTNyFxmuc2a2XfIfyLS0NdIy5K/53kPeB4mnk4jJ2OR15Ebl+ACZVTbJTwBM7Sb0Vv9eOrUyV10PdpB6h4T5pUncr3xTYFMavdqhxx+0EamiguJ0+7CLyDlNxvPP8xvlHo6ssjwAk/wOyErnyqYTZuw+/xhQ8hA9gUr6xLIuxB7zNUyvnK4ANIvP4tCBJb9Wo08c4BvmJhu8BLB7gxw5mKoFp4wr0kk1/EZyVHV9eThhes483C0yPqjyheamu7SkthMW4/0V7DDGG2eJFpM/4mp9IB7OgsLBsefjRONhNmqPYc9rzlJI7jM9Slk0eXAw+aTt57L6Yqt0+InMum949wzeW7YS3I+ePXbMn+4I1kFFWdgcxHIH6CJfC5D/abYGxgejYm3zjJ0env6uyD2Kyid92kIsE1
 0lXCxozt
 X9RgOi70Qc9gFw9LVJgtry28LfREM9+doDhoG8jOW0X1rDGih0Of6V57mtr/o84vV8Cr+XTGutyW1+pEMBo3M85MY4ihOXSL8Q6AgI2tuR9jv173IAnGKUJ3e1tlF9E8jmcWx8uqF1peZbpgOGupzMdrLvI3Nnje8vqWZ9AEEshawhzSRsRlWCFExhwdWzDayLy7Uh3r5CF6CjEbaIWxwh7Lgsdz7aNYbtY0RTNjaaF5q24dFimN0WQGhAC5klvUAJjhwIN7keJOvPVhzpiy8XBl7osbsp6zxYM6Dn9a8N6CcepHkgIhQQQGDZ9o12YwjkO7HzVLh/vm0frBb0PKhu9wRWm4o+dUasTPg/vQVYVixcgUT2dcfpCPMmoXyS7LWuPA957nZ6llkl3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

On Mon 06-07-26 16:53:28, Chengfeng Lin wrote:
> I found a small-list flistxattr(fd) slowdown on tmpfs while looking at FS
> performance regressions.  This is a performance regression report.
> 
> The scope is intentionally narrow:
> 
>   tmpfs + user xattrs + flistxattr(fd) + small xattr lists
> 
> The cleanest reproducer creates a tmpfs file, sets one or more `user.*`
> xattrs, and repeatedly measures:
> 
>   flistxattr(fd, list, list_size)
> 
> The single-xattr scenario checks that the returned list is non-empty; the
> count-gradient scenario also checks the exact returned list length.
> 
> The bare-metal test machine is an x86-64 Intel Core i7-14700 system with 28
> logical CPUs and 30 GiB RAM.  The benchmark was pinned to CPU 2, and the test
> filesystem was tmpfs.
> 
> On bare metal, the parent/child A/B around:
> 
>   52b364fed6e1 shmem: adapt to rhashtable-based simple_xattrs with
> lazy allocation
> 
> shows a clear jump.  The parent has the rhashtable infrastructure but tmpfs
> still uses the old rbtree path.  The child switches tmpfs to the lazy
> rhashtable-based simple_xattrs path.  I understand that the lazy allocation
> part is meant to avoid per-inode rhashtable overhead for tmpfs inodes that do
> not use xattrs; this report focuses on the small-list listxattr cost for tmpfs
> inodes that already have user xattrs.
> 
> With one xattr, skipping the first round:
> 
>   kernel / state                         flistxattr_ns_per_op
>   parent A, tmpfs old rbtree path         135.754
>   child,  tmpfs lazy rhashtable path      229.663
>   parent B, tmpfs old rbtree path         135.335
> 
> That is about +69.4% for the child vs the average of the two parent runs.
> The two parent runs agree closely, and the skip-first-round ranges were:
> 
>   parent A: 134.451..140.153 ns/op
>   child:   217.758..239.498 ns/op
>   parent B: 134.273..138.098 ns/op

Thanks for report! Couple of questions:

1) Can you still observe a difference in your benchmark between 7.0 kernel
and kernel after commit 1e7cd8a53b72 ("simpe_xattr: use per-sb cache").
Because that was exactly addressing performance regression for small number
of xattrs.

2) If yes, we need to better understand where the time is spent but we need
to analyse profiles after commit 1e7cd8a53b72 because that significanly
changed how things behave...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

