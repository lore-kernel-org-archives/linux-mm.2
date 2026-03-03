Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B24E67A69
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 05:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C80326B0005; Tue,  3 Mar 2026 00:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D9C6B0088; Tue,  3 Mar 2026 00:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A2E6B0089; Tue,  3 Mar 2026 00:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A363C6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 00:32:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43FC713B481
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:32:57 +0000 (UTC)
X-FDA: 84503632794.27.0A3C25D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 36A1440007
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:32:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=B0NJYVfT;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772515975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GPV+zg14s52g5SFoFfrYx5Ptt123SRCGdsVSmGW4Gcs=;
	b=XIzcgN581YXE2QvMmoEzh/crB04HcviYYJvyM7sjNSMwqazd+QkEGhmt9xIn8PgT8WzUEC
	ioRGWrn82fGiDcxM2dEH8IcR4MuWDzOjGmZs8CWejhD0c6/ultOOVtqf9J6dwoCpLwEqEk
	0RNjaTlkZvt2PDUBTSjXKcBKVTf8YG0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=B0NJYVfT;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772515975; a=rsa-sha256;
	cv=none;
	b=4TJiAtwazNyXdC+NFkTt9OIgaXL6fzACaNRrU4q5klmJ2WzJy48srH12h5sLH0UOpcChBM
	DKQOY7T//0rGADpbH+x26Gr8u84oukUPWtKfuw3RAsO0xIAbJnyX1rb2+pzxddFsYKE2qv
	t+sog0PmQxVboQAEUPIum8ks4dkPb0M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=GPV+zg14s52g5SFoFfrYx5Ptt123SRCGdsVSmGW4Gcs=; b=B0NJYVfTPQrwUmRyc/SBngXZNs
	H5h1n+NJNoO4prO4VMLunBPH9juYPi88vUvHivlxvubTjNcXFWHTZJ7alrBh/ThhUwesqbtGr+YFT
	9F20bfQfoObMbqrPd++hk84EjORkxhTqOmeGmHxqYQcxSGjMsXzrxVI7M5jHtDscb8mcg795WpK3u
	Z3A3mgGSxeRc2vV48jIVZME4xa+Wsm1krQg5ZMM+iaeSHPh3/WhjSi6VUc3l4Ziu250/93g9VtgEg
	iH03oAc6TZteIx/s6TaLgMlkp4FCgR00uNOKKlclZCetwu1lRff8nn1wvOT34T1na8siSvLEAz1lY
	RYl8A5oQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxINH-0000000Av9d-1mHC;
	Tue, 03 Mar 2026 05:32:51 +0000
Date: Tue, 3 Mar 2026 05:32:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: hev <r@hev.cc>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] binfmt_elf: Align eligible read-only PT_LOAD
 segments to PMD_SIZE for THP
Message-ID: <aaZyg0GT4_f52UEr@casper.infradead.org>
References: <20260302155046.286650-1-r@hev.cc>
 <aaW-x-HVQpSuPRA1@casper.infradead.org>
 <CAHirt9j-appZ+Mn=8AoG=SW3Lrqi2ajdZDGp8yYWiBWkzBbQ9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHirt9j-appZ+Mn=8AoG=SW3Lrqi2ajdZDGp8yYWiBWkzBbQ9g@mail.gmail.com>
X-Rspamd-Queue-Id: 36A1440007
X-Stat-Signature: xhbhd5f3h4nwx3uara8ji1g7trfm1xib
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772515974-340186
X-HE-Meta: U2FsdGVkX198bIFP9AI6SKyA8HkerUIm0OWrb/37CyczQRMobaH10m0GAwjotIzryFChlnj0UM/gTuqoXQ1wGOYnnlz1/XKFheP5LzqvYB992sfepLPGQWLsJbBwozvzZA9Q0H8ILUsyjgwmVqhwpccd6Nq69ZPo9LG3rd8iWDzQrR10jtc7ZCo3znANPU/8s2MIvnNEx1pqX948JKt8xWxj29vlX9cuYnh1xApab4M4Uuu1XhpajHi44093WisE8mEBBX2jbLWL5Hipi3gnuxPOVkFYlbdlgTHMxXWVx9B0UPj8DjJgj46nDhw23ODJ9PMI2kY0AIGscJCREc8WeOFPNd6VZ06Ls8pr6mCcZwEsD/5YbytjEHfGeKJJ3S45mUOD7sXrn+FzJo7i7xq4TsaGBMMxpIfKFCcU/WR2pOQe8H7RKkUGZj5tQVb/zpYPkY6K7E4LBTgEmCndUSkADd/uYcMQZE79pIXGLDwByBVSLxYFJMjg87HqqO6AJQZqVAhc+ISNh2+A6zzTAQ67wg9AAA4IyeIG0GtxBSwtoVwGjyNmMgr0Kaq27/M8FC+Qd7OQqweIxvNjN9t90+5HxQNahYs59VsgzWw8EHqo1eBLfTRbgQU1tV6KrorjgwiiYyjmLiWD+ca/nlalYA55pph+kLM4cVndhv2SZIqLU9uoTIqg6BzAWn0+YIbl1yMJwDrF3u9oAv9PvuSlF0QDt5v0oZyoEUMIfjyjaUR1cMh2tef2a+ZMQVLvgyOTiV3YuJU0ncJQ0VJPWLjkgF48xKTCC1Sa7YTmVz4oVFtJZ2NyMFlar3tFTHT/XjyctHDqZ0jtkEi/FYS1AxRpXGNolAmZGEnsLEDtaK1xWL5mWXGLSIW5/xP2ZbAGjJh4tj+NZsAhTTCxyhSCCSIZ4hFQd9mlRJwAIJZhm+jOel5XFYewx3clpc2hkUlCPonciJifzwdPf/nPxcVSeIm7QL+
 dQ0Wvzlt
 56NVvkF69/noAFu6DiMVQVX4NoVsF6+/F/796m1kHUP1fpUEFdIdyqG4VPdw6yLQITJZYSQ8vFkxOju4P5HNDgP7qhW796Agowlz3lyOEolaurRxNCuWoPnQ+2dhXsVOahv88+7eXg9MQVFhDlbT5tXEPUo3wKFCjpTHDJ+Gu+cLhwMMoSsEuGtR7I3SpAoIhx4CrYQAANfJtYHoDFGs5YLiLstA0eBcoZFZ9J3YbpOp+kiKvrPOQ86waH8Xd9CttHnlc2XVU5Wqnv9XqrjZOg19JKT3GSsX/hb8yS4IjBzV+vcLczyC15hIIfIPPX3PGBOh8Jq+bX+BS2WLe3na1xDsyac6f4tzeO1EkSwlT/GpoInwZD/HjoF98ydE1lSLVE8kD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 12:31:59PM +0800, hev wrote:
> On Tue, Mar 3, 2026 at 12:46 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Mon, Mar 02, 2026 at 11:50:46PM +0800, WANG Rui wrote:
> > > +config ELF_RO_LOAD_THP_ALIGNMENT
> > > +     bool "Align read-only ELF load segments for THP (EXPERIMENTAL)"
> > > +     depends on READ_ONLY_THP_FOR_FS
> >
> > This doesn't deserve a config option.
> 
> This optimization is not entirely free. Increasing PT_LOAD alignment
> can waste virtual address space, which is especially significant on
> 32-bit systems, and it also reduces ASLR entropy by limiting the
> number of possible load addresses.
> 
> In addition, coarser alignment may have secondary microarchitectural
> effects (eg. on indirect branch prediction), depending on the
> workload. Because this change affects address space layout and
> security-related properties, providing users with a way to opt out is
> reasonable, rather than making it completely unconditional. This
> behavior fits naturally under READ_ONLY_THP_FOR_FS.

This isn't reasonable at all.  You're asking distro maintainers to make
a decision they have insufficient information to make.  Almost none of
our users compile their own kernels, and frankly those that do don't have
enough information to make an informed decision about which way to choose.

So if we're going to have a way to opt in/out, it needs to be something
different.  Maybe a heuristic based on size of text segment?  Maybe an
ELF flag?  But then, if we're going to modify the binary, why not just
set p_align and then we don't need this patch at all?

