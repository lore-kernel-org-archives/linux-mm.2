Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A5910A88D4
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 15:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D30F6B0088; Thu, 26 Mar 2026 11:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7840C6B0089; Thu, 26 Mar 2026 11:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6723F6B008A; Thu, 26 Mar 2026 11:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54C9E6B0088
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 11:55:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 054E98B34D
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:55:44 +0000 (UTC)
X-FDA: 84588664650.17.5CB0E8F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3836D4000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:55:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UiudyLeX;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774540543; a=rsa-sha256;
	cv=none;
	b=36HZv/EkHS76IlfYpyucLy73Yx9Yc+1AWxSDXkeoHds/4EgJI5/OqUkVKJZ+a+SG4WtzlV
	wqCaq77lCRosMkxn8bSDpzsHwnHKtlwpSEFnCzANjUgRgK431lJBq92QhlGMZxgtrrDY9t
	jukmBtGFwM0rPEbwUr88bPem7TQlOd0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774540543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRMNAvoI8/jKpG3++5LCwSufZK5n9g0ksfmeuh3S+yc=;
	b=dx/9siGlTw1uuKiILjFvCD4iujN7GT/Mn3IJCripCPs+hftpIF9b0vNzyk2/ZLtbbUVtfs
	Vogd8cwIwRgm/l1GprZEaV2M0QhsEfYMF+s/rAMpnkHhpuywLoRj5iGuJ+roGC0fvFfIvg
	v4umgxgJxc5NrmV7bkv6xcfT1iUNb8s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=UiudyLeX;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HRMNAvoI8/jKpG3++5LCwSufZK5n9g0ksfmeuh3S+yc=; b=UiudyLeXKQzMSbmKfuP/Zq+N8l
	IJDs6wTduVJKqHnN/f0afsAgOf4cS3xdwL0PxL8RL0k30hz/63Kd87bxVbI800dmZwSpgXXLgzcdL
	mZR23rCOkayBzyq0F3GOwGI33G02XOgl6IxdMOJpMPmWjEJ1g9uOP9VrQhQ7vg8QHlnKw0NrQ5Pxw
	epgi4PS1GTbZ3rWTK/n76XLji3ba4JKjQiI5cCMfxp2zEjjtcNaAfb5+0y/W4v+mzzYFViT7Me/KH
	7H+iItNqVxtGm261E4WxJwf6Sxa4AVIWPLGHUtVHnDmM5EIixAKmj/bzZ6hfNTbbbCLSRJ9laMPxC
	eIrBO/zA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5n3K-00000000G5w-0Ka1;
	Thu, 26 Mar 2026 15:55:22 +0000
Date: Thu, 26 Mar 2026 15:55:21 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/5] locking: contended_release tracepoint
 instrumentation
Message-ID: <acVW6eFGwqACD91Y@casper.infradead.org>
References: <cover.1774536681.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1774536681.git.d@ilvokhin.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3836D4000C
X-Stat-Signature: saiuh7r9e8zfd1it7p4uckiskfq9fzg4
X-HE-Tag: 1774540541-458526
X-HE-Meta: U2FsdGVkX180LJeuiDIKe5HqQ41YyScI5Z3nX0pIM8MFhOPk1cozM2Z2LLc5C3HcvzjtRjilflL3VC0TFj4TE9iho7KKuGoPJjImrJk09GFZaERfCit1HJOp4A1fnkmE/Kf+jGeQUQWAtuesFQlU5T7Hls3W3HMMlgJYYu7A2hTY+zRy2i/GE0tDyt8BSCuD0kJn8i2g/17riyHsxbuKsRJN03H8WYX1cBHYJjW1d2lZBNrxS93fAxbW5eF/ndsi616tWE+QTT/DOJviO+YCHaU2FJ3qL6A4FZcmjYNqDCSPHc7mMDZW4pBcUmppEKkkHJQLf5b//muHz6ns+oLQr+rblNyx2kBMgMeyLhhZACIV3dSYrPEI5V21F9E2FMnt3sV/bxZZCP112yFSVJ++AIAgZ+OnIIjhkdPR7DId2X1SWR8LbSVSRsaogkNDw7lKOSxpCEhJoOmv62l24C+jcGK7joLX3hBa9A4pLPbQ8PXdFK1Zjp09tQb6GXsVWLtlSJWO7weylJ/skVEU8Jns/QkhKXijbcsuR/8b4WAMvT34o5DN4A57Nj71DAO0/hyarVjWAcumetZq272kbn4DBeEwpvkxsYcIYUt6sIheU7Nrims+yB7X5mRxOkzX6mXi9Sg/tkYG1CVBEEAKvwNzhMmUHEtOc8ld3PiYkR8GfQSVtNHo37RVGranr17uQEp9I4OiCIuJcm2omTG+JBtrju6xmUINMO13zm5UbzPTjPoDvfYbYsL8tQTtxFnbe+5gVZiW6t2UeNxia0+J0sdPiCAD8+LxGWHL5ulXYqO7DOG9jOFwHMZM67ltKmEsdAHpy1hRR/BlWvru0ZI5QugJ1D0HoOSKUfyh2ceXgoY3Ajo4D2QePWDdG2ic75Hejj+aQT48rlo+C+DyfUs+5NKT7dyTI/emFTZ7r0q3iYCZyX90FZgzwOMVXwTzDuPEsy58254kxmdERAcSbpT+pNK
 f65K3goP
 OQnkKOVPW0r8KdqDJDGBPlQIVHylM+rrZyCSNogNHNEmptJ5HlrcA8tz8cXqbo8uBkMMkdEngJgyuSahaAzgT/spz58cuXeHD8H/idF/UejzA21Ve0KpRobs1sMnAGhtASNLMXEm1AKzlz1jIJYH/y26MMl0+alWVuSdsqWHnmO4KXtZQGfokzr7xr0AmuuaXBamzhDVnx9cZpl9kyR0PG+6BpEvyMwIUD3kzupFaeROuU1obQAo+WKOsaQ/4eV3cUq+iymF5zSestaN01J03Eqq8IxwdBsjUgIOGimEmQZlb0EE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:09:59PM +0000, Dmitry Ilvokhin wrote:
> The existing contention_begin/contention_end tracepoints fire on the
> waiter side. The lock holder's identity and stack can be captured at
> contention_begin time (e.g. perf lock contention --lock-owner), but
> this reflects the holder's state when a waiter arrives, not when the
> lock is actually released.
> 
> This series adds a contended_release tracepoint that fires on the
> holder side when a lock with waiters is released. This provides:
> 
> - Hold time estimation: when the holder's own acquisition was
>   contended, its contention_end (acquisition) and contended_release
>   can be correlated to measure how long the lock was held under
>   contention.
> 
> - The holder's stack at release time, which may differ from what perf lock
>   contention --lock-owner captures if the holder does significant work between
>   the waiter's arrival and the unlock.

As someone who's not an expert in this area (so please use short words
to explain it to me), why do we want to know how long this holder took
to release the lock from when it became contended?

I understand why we want to know how long any given waiter had to wait
to gain the lock (but we already have tracepoints which show that).

I also don't understand why we want to know the holder's stack at
release time.  The stack at contention-begin time will include
the point at which the lock was acquired which should be correlated
with where the lock was released.

Perhaps examples might help me understand why we want this?

