Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2087606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 14:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WMe6IWuz
Received: by kanga.kvack.org (Postfix)
	id D06886B05B3; Tue, 10 Nov 2026 09:19:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDE5B6B05BC; Tue, 10 Nov 2026 09:19:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF51D6B05BD; Tue, 10 Nov 2026 09:19:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9DFE96B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:19:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 251F740928
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:30 +0000 (UTC)
X-FDA: 85419417300.13.8A50E06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6A3DFC0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:19:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMe6IWuz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794320368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTBUIEs6ouEm6gFVWs5zgJQtIAZwsuHyVb8X2AjSH94=;
	b=aCpuHgaQF0xO/JUmeosXA2DhTr2xyrRP0X/XhkVnu5qQj/dNHDo8W1lwQFvzE6XEdF7eM5
	RMfejbJskOrMUJFWjpxcAF3aJ2/NinDVq7qnqREFxGKblLtbTqa+nGhsJe7n16LbM2JibR
	Y6IeMu+XWuJ+TZQ12G1LktiQZ/xRgo4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WMe6IWuz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794320368;
	b=v0LTS5bldKDTFmMdr/p5P5U7ENqdnBNPxbKti2+kieGysDqKbAKM9iw0XNYWv+ee/ftx5D
	g+d9wkIQGW+VeY53HfSboM+Ar6JuGqkNYg2JLqXmP4WwN+RHykMKUnx6Gq/pPWlNOTHaFY
	Tk8JH2yXKnLQgxrAe0z/hkP2RwakU24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A60142E3F;
	Tue, 10 Nov 2026 14:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29C71F0089F;
	Tue, 10 Nov 2026 14:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320367;
	bh=rTBUIEs6ouEm6gFVWs5zgJQtIAZwsuHyVb8X2AjSH94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WMe6IWuz6RSl2oWDeCvTmq2AwMHnOUtZE3+45ZoasIZO5gRYR47j6+YK/Q+r2Qc71
	 Oynj7cycBSCuBdt8KkwX56cq+rCF8kX9Zzb5xI3P9bsXLaWOV4P8f3pHjQOtbS4Tg0
	 CGkKuCYIGAlPSmPbmEagI8zZZw1sBZh4bHwnptq2ZznUUFMBvdahE8aTUrqlIwhf/F
	 Ht3foWksmT8HKlJuImlG5f2peLz8nkfL2laxeybA+NE5dgHPVlHiGQ/NnbabozguCw
	 TT8uIeer0qrWFhEuotb+keRYw3Lv47vT4jSxpdsAUBOUXXhsDZENanCsrb8jGTDHRj
	 zMPaXkLyFY0oA==
Date: Tue, 10 Nov 2026 15:19:22 +0100
From: Christian Brauner <brauner@kernel.org>
To: =?utf-8?B?TcOpdmVu?= Car <meven29@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	=?utf-8?B?TcOpdmVu?= Car <meven@kde.org>
Subject: Re: [RFC PATCH v2 3/3] io_uring: set times inline when the
 filesystem cannot sleep
Message-ID: <20261110-winkt-kennung-geadelt-75390f787646@brauner>
References: <20261104110604.126717-1-meven29@gmail.com>
 <20261104110604.126717-4-meven29@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261104110604.126717-4-meven29@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A3DFC0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 986ypcsye493tzkepzeio91mf5rewxeb
X-HE-Tag: 1794320368-358982
X-HE-Meta: U2FsdGVkX1+Nsao2EoqegIVTz4mvexpzxsW+wXPklE7uAOLifAe1eI0j9AxQd9bzaeye9W0WdAQinRHrF7T+nIDqwlkq/zBrVg+pk1UXFQNy3X85w+9fCoNq9aMPsEUBfBv+yeHMRDdmPm/oLgBGYkDoo052NqchIOCT6NMdLsm68VSjFac0JHyJS+EzubKnBCwP8tYwvqv9V6astYcLhveS+1of+1SHkllqOu2Fwpbnf/ATkEvPbbgHDcGkORDraR7lGMsfLIOuOGfT9/CDNnQFmFN6+o3GloZ+cm3dXh1p/+b5da+Zi7qBic2Z/KwHQrLsSuspS2gVtnHM11ta6w6TptkCpAus1J43bjV0rvmR/BJy7qbBj4eXB6O9Iz6jL1pHcuROPbFAJxnHuoV4TGIMhAvhNB1XV9zTonIMRJcEPQmcOFrvHH8tKi+a25nHGAk9e2ppDSGHK5WXInaxHbBTWBxx0/eUchxdoEH+wzi7GLDUyG9m25asgJqmCQo1wi1qbgXbzKHpYjjkQEGTJSXmjqVO+2nwrNoZI7f+ICIu56ggHHMnWX0K1KM1PnjoZdIF0IhiCnT6XePdBZl3OA4IbP4e3kKDVBQWgQICb+3llkwJ1fmNVApV9t37QAnBiUMdOglERnZhcSKUg3uVyEkX/ZsbptsW547/XRArtyG6MUwPUIEOqkcVR9kMGetDeCfPnCNf6GOSV8TYkTm+Yt4ib6+n+pxb5teYoDdeYxLm4l7bol7VGRhQkhcytffnFckiSvAinfrhrJVhpPyJG6acJ0W7xzITxGSwPSy5U/f5wMLkjT0VJhk6D8XlvmJ7Z84AH6XLH5oAQ8m003WG4CvRNPC/2IjW/11I0HRz0VNQZfUP+eNpSlSrd62fxDKuxP7tfvq358Kr78n0g5ABdO7MWTTqXMBl39gKrFs5b6d0JjgxsZa8MiBRoIUZCc6xWAtEcKhYIdsfuk5/Caz
 bF6/cbap
 Qa88RjvMundqvMvU+eAKckAgDXXIKxSMpUSZ8ZCBasg2xVYM5HZa5hF7g5w1PM4CmZToSVwjzKzZFrQ8xsul11WAZhlU0LQu0ZwRcU/CDkHIdggghNK4JVYMWJGx+Z4aLIU1xpVR62+NRU/Z7vrgYjf/hCleliBwnEFxRTuGKwtka8/cuCS26lfTd4tGbEufRH6Qk+xrGBS/rHHd7N/ppd6SnnWPIoE0T2Qj77vbiKRDFD6FV3D9UAKkOMg1FvOwiUH/mKrzN1TN5r8V6iSS3d0cHfAXkTYshQi2eKfeDlWoo9pAufWOxvjE/5HIB3pKLxN3oeu460N6p/K2ayHlN1RijYP/hpf0PyzTbX5GLQXjLyIBOXu/DyUe79WRd8/gbXBz2HPy/gReWaNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 12:06:04PM +0100, Méven Car wrote:
> From: Méven Car <meven@kde.org>
> 
> IORING_OP_UTIMENSAT always went to io-wq. On tmpfs the setattr only
> changes the inode in memory, so the handoff to a worker cost more than
> the work: 2000 files took 7 ms with utimensat(2) and 20 ms through the
> ring.
> 
> Try the request inline first. The lookup uses LOOKUP_CACHED, and the
> freeze protection and the inode lock are only tried, the former with
> the new mnt_want_write_trylock(). A filesystem whose ->setattr() never
> sleeps for a change of times alone says so with
> FS_SETATTR_TIMES_NOWAIT, which tmpfs sets. Any other filesystem, an
> uncached path, a contended lock or a delegation returns -EAGAIN, and
> io_uring sends the request to io-wq as before.
> 
> Signed-off-by: Méven Car <meven@kde.org>
> ---
>  fs/internal.h      |  5 ++++-
>  fs/namespace.c     | 20 ++++++++++++++++++++

We do not add a bunch of generic APIs in a io_uring patch.

What exactly is the the idea here? for tmpfs io-wq handoff costs three
times the setattr.

So it tries the request inline with LOOKUP_CACHED, inode_trylock(), a
new mnt_want_write_trylock(), no delegation breaking, and bails with
EAGAIN unless the filesystem type sets a new FS_SETATTR_TIMES_NOWAIT
fs_flags bit. Bah.. and then only tmpfs. ext4, xfs and btrfs can't
because ->setattr() starts a transaction.

The inline path still runs the whole notify_change()
security_inode_setattr(), fsnotify_change(), and
security_inode_post_setattr(). That's all blocking material.

Every request on a filesystem without the bit does a cached lookup with
d_weak_revalidate() and audit_inode() side effects, fails in __vfs_utimes(),
and then io-wq looks the path up again. Eew.

Not acceptable in this form and for sure not with all this new
machinery.

