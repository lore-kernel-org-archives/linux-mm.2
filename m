Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE687CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 15:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A757B6B0006; Sun, 31 Aug 2025 11:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25D46B0007; Sun, 31 Aug 2025 11:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914BB6B000C; Sun, 31 Aug 2025 11:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79DE66B0006
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 11:40:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22846B9F54
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 15:40:24 +0000 (UTC)
X-FDA: 83837464368.29.A045DA4
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8C72100007
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 15:40:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=gwaIVq4d;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756654822; a=rsa-sha256;
	cv=none;
	b=ZRORb0TT3ZB7Ep1gQyMqqUxRPR9oWqImZZHhPmMUQLzMZ+ihi7yAeJZ1s7ajTWTwNm/SZe
	QYq5HvJ810gtoi2K6EdpQuRXXADdiYfb42emjXiNTxGMXrK78qp+S+wAbwJDPtqY0NP4+0
	OOn6hmIiID5x09vrcQDJvEOX2NIRCZ8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=gwaIVq4d;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf05.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756654822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UevTnzICdteIzOhn6dJqcmMyhQOKhAKvJOp7WGbG2U4=;
	b=l7bIhbb97vBXF4LTed75y6arkqwV5HOhDlDUUrONfbayaVq55wrb+jo0nJpgrIZEaIRZ1p
	ZvMxgnFDBVbzycul0FTiqy+0CF1NDT6L9W53rBr57ljgSKdXh50qX3nL3q0CmpZezECJIx
	xcxmZUIMj8lXcuh8wtIOn18UbnF9wlM=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EAD3940E0192;
	Sun, 31 Aug 2025 15:40:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bzt1d1lsJFp1; Sun, 31 Aug 2025 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1756654814; bh=UevTnzICdteIzOhn6dJqcmMyhQOKhAKvJOp7WGbG2U4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gwaIVq4dv6B7A01+RclqqyndJe0kXjEldcveKKQe9JTqcLjjPN3+xLox+zK75ThUI
	 C+qXuq8eHSghaezPramxtQe2MhrM/4LFQN6k/VGq2rFOy8Q1M9CrtOoJ13L5/uE5QZ
	 zvAgskkXK7vW4gOcSH9wDiM+CkUN3ts76rnulUHy8BP3TujgALc5RSJLUY4QWlUhIq
	 E94hEtN85FohOyQDMmgox9HXMgvODpagd2Jvi1z6EambcDZ4WNF5uVFQW54+vu6WqO
	 9LC77l9Rfo9ed/6zTVrdWGExvzCuGESOfvr/wD5zlkcwQAs0MlMjU1ZAKwgET6JK2b
	 PEvD9mEFFEWsjkBK0QghH5sXxhyIg5DBzHM/kYOAFKXnCm/SYqoQ0X8BTZBDr47DUC
	 qCIU5IrBC3xyenLoS9ELA7SbWdGlIJImXZdUfrYXPuWldtENzpga8WFCK3zAmwmz+o
	 GhVFSvpJkyfmJC9NHW7ku70wLDV7QiRr4qZwNuhHzhrVu4XgVYmpfJSK6pDawDCsGS
	 aSI8Z/bK9Sd4YHf89b12tUWbcKkgvqPBh/PymVaHm/q+6FwFVq862jeck/rbpQWpTH
	 idZWYMSGlPHkoMNS/4hsynyGOhLSnLOo8nkFsWKAOj6N9RWfI3u6vgt4BiKwDrE2t1
	 QgjLZb5EvEgdFs6e2ZE9c3sI=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 7C2A840E0174;
	Sun, 31 Aug 2025 15:40:01 +0000 (UTC)
Date: Sun, 31 Aug 2025 17:39:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Bert Karwatzki <spasswolf@web.de>
Cc: seanjc@google.com, Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Jakub Kicinski <kuba@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	torvalds@linux-foundation.org, x86@kernel.org, tglx@linutronix.de
Subject: Re: (Re)boot hangs and refcount errors on next-20250829
Message-ID: <20250831153941.GCaLRsvf1V_ST2GPAd@fat_crate.local>
References: <20250831141426.2786-1-spasswolf@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250831141426.2786-1-spasswolf@web.de>
X-Rspamd-Queue-Id: B8C72100007
X-Stat-Signature: j6nc8ithueg86qsy7xfdcw6wjeuwi5zc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756654821-935311
X-HE-Meta: U2FsdGVkX1+7VbOCbzTajnpgjtzdeZ0jlCOGHV4BYipmvGJmUTwd1K7qJ/CIYqVSOZG5AEcdHJalo1X40MHFyG3vDtk+pyV/xYkp6zL+Bojiu1An7Xp4KzkEnWqBr86QqKVNOY9g54Nq0mOtNehgy3GnukwJk806ulpON/Sy2XVHAjBH9oDWUgo/e00EgIvJ0P3+hhijTqs9YQQmIN0HSF+sJ2rsb6Ww2bZfBgcDsXuIlNdSnfLWxNN5PLL3T1jhiDyY3EnovqaX5FcYq1DkvDgXwdF6FICqhHFsdL56xufzEARFx7N/0Ag+AUHvET7DdDDs4nnv+qOlD7mURAQy8BCbJx+upx3b6eLBgcmUT10dpFVkxI16ZfYKsQw+IbnKJbKqXW7xBKY3VuHQe6aWEZTQWSjKqFFtkBrUUSzQExk7t/+oPauUk3Qt7zcZnEwKdOiLKquTUE8dW2Ke8HOxu1AOlZGX5BDYv7/Oaet1dQWzzyGrKQ0fXEbn08Gf1mMFoq5W/NFeA7mph9HkPTxSYNmWNSeeIC6FSksOIB6K6NXcKOl/bFi6WIha+UGoJgskFLEzXJCNiRk6JromMamINdea5nPOdGU01fbcwOnF0nCqzp6B4CV09BhZHFDsvzprfzVVifOPESW0RFW1Ruc2fjMqfE4TE7bojOd4aW2bjjyDQT7SQvWKAU7ocML0tLLz/be89LjaSMAbta+nE0lN09UFhPO8Dq67mDptAFkS9UyUG9Ot6JYxYUB3Jzmbl4120PGAn7X0AWS2R36++eIW8Z2UHkCV/+oZa9o19EhRu3we0rf8SY/1a7fbeQMrvSZJAuAIyHOMIema2qnHHnhRfACw1MUjUnWjFX6M/CNprWTfmIv29RHiuAX2isnCNlZMPbBAG4W5IEWasRynqY55+eK9KT+kd+wy8qBrN2C3hZ87qQZDkLRGcsljj3KPrlOWwQoyoeNx3ZxdCOLI29w
 Ffce31Ga
 wEu5EnKhQX0pjSBhL1cpRFRQPRezRsevDeS546WlHZE4Srp8M4jDcbkeQ/Hhd3pKAT/KwpUvJGTw0HPQpyQ09VvG/kizn6q6SVQalVTy/givdqYLOiUC9F8E1ZtN8uR+7moRFMNnUZRX7RRW3afU4KwpSNucGR2uWirpe1B/PFNOwMr823iIW4+aV3f81LrIvvVJXiGRBYk2sjfIYqBHFR5dODKtePgdSsYdkiRvgqG+cmLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 31, 2025 at 04:14:24PM +0200, Bert Karwatzki wrote:
> I think I hit the the same error (and some more ...) when booting next-20250829
> on my amd64 laptop (no VMs and no kexec were used here):
> 
> When I try booting next-20250829 on my debian stable(trixie) amd64 system the boot
> process hangs every few attempts (without any log messages recorded). When the
> boot process succeeds the following error message appears in dmesg:
> 
> [    8.337248] [     T44] ------------[ cut here ]------------
> [    8.337250] [     T44] WARNING: kernel/futex/core.c:1604 at futex_ref_rcu+0xe8/0x100, CPU#6: rcuc/6/44

I believe that got fixed, pls try:

https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/log/?h=locking/urgent

which got updated to contain the fix for the warning above.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

