Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934DFC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 04:05:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211AB6B007B; Mon, 10 Aug 2026 00:05:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2BF6B008A; Mon, 10 Aug 2026 00:05:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8736B008C; Mon, 10 Aug 2026 00:05:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D743F6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 00:05:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 56CCA120674
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:05:51 +0000 (UTC)
X-FDA: 85084021302.24.596F4C0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 219F3140006
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 04:05:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FaAWcN9M;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786334749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3mkdXzNugogzg/Uybf5Bwmxm4mLQcy7cnOBTawf1SE=;
	b=yO08nGdp1icvlTN2wAbECXIp6GU/LNPQyu+//WNpXtiaAqv0X3huK644/p2Jw9LoW0Up+6
	9qpOo5rbXkgL9zc1fWKMuDbAoPKCLP5uvEJ+pP2xI18wmnL38CovmUpMufnDLhBVQD8ODS
	E67FCClNs9gVsjvk6Lw/ZwPzAb5WeOM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786334749;
	b=1ph2WywLvs25mBXxSB4ShjHfkwukI9qSvIEtIUbSFRHzVflePIAtJLB181OgM0y017nAkO
	4Y2R1voEPErDyDQjX37ewep1UjdjanM3ZQk+xww56klkKuguT822qk45rsCTa4CK6Ox2EK
	mJX6s6q60x8opDU808FOTM95NedcAjI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FaAWcN9M;
	spf=pass (imf26.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=w3mkdXzNugogzg/Uybf5Bwmxm4mLQcy7cnOBTawf1SE=; b=FaAWcN9Mdmiwj1QIxlrzffFtQb
	dxdYnXJR468/2SRKtk66MkzRgIuZiN8DlX0d7MF5X9XQ9W1RFTLfM9CDmmZZ2v5Xbi3fRVcdzqQvY
	yqWlkfDvlpi6KAIFJleElHHAZeucAqerL1cWx+5zDn6NbBx8PynqZm5raW7++SP0b8iax8M92eEqq
	Afom2j4BBpsEGs2ORReT3iVHh3w9HujLDz0zjlba4HjJKDKdkUv1xo33AVkEN+ZQ66UJMwL0v4N2O
	oIhrfJ+QzuvBdE0r4ugnmcxAGuECJ29KJIdp/y7yoD2JAAvtXvCaMgygnsKUUtp/lIQUIDbhm3IuC
	sO+0NKzA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wtHGi-0000000AFF1-3vil;
	Mon, 10 Aug 2026 04:05:44 +0000
Date: Mon, 10 Aug 2026 05:05:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: vova tokarev <vladimirelitokarev@gmail.com>, akpm@linux-foundation.org,
	security@kernel.org, linux-mm@kvack.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to
 local privilege escalation
Message-ID: <anlOGOmO1HWVCMdF@casper.infradead.org>
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan>
 <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ancYCBUT8aB0qHwz@pedro-suse.lan>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 219F3140006
X-Rspam-User: 
X-Stat-Signature: tz67bhn83fpawtk9scfm4g55me77k87q
X-HE-Tag: 1786334747-963530
X-HE-Meta: U2FsdGVkX1+dMhuJgG31g4A2XfWlNPKJbreciV1lGrpnYw0sUiSOooWayl7waZzQw0GeBg8vBtikEWjhJzNdLV/UB1OLzFFB/O+WDc2BwnRHoRFfNl4JIoP5hPwYi35l/wiq/P+UDkVGQeD+rC17o++pBQNWKwKO8D27IkAT55Y1CsdnpBJjyH7M7wmXmAt62oHw1haEwZ5PXdoY8inYYJv/n1EBnUwdIE8w9AfCN8sjkFmE8XtFWMN6GMhYzxBEMEf5F0j30Aw5Y19tQqIymRYd25u7omZ5LoJBOIwe5EFbT7wBxyGfKwwxbC0u7JIYdIGuCYMtMDYBgJ8h/fcfbD50riTnrTvNw8V8niZMeuoXdkh3Zj4S02na0uo5rMdXustrW3wCv1WmrK04hbK9aJAY75Kg0xy/eFBO01ooxJy/P5fQlPwAYPZJ/gH2SXQeI54q9EQv5YQBJYu2UWPdRWtP/W/OwMl4ptGpyvl7e9mwFpgGojWrlsQNkIsrXTkSP/0AnUXPi4/izXmzNyVh1pYi1HtDPzAaJhOhrbyzk42UG32nlzWj5X9AMp7cNsr+1tEKwbrdLD4s9yO4ifKZ8kP/XbGjyquUVd391LEXNZS0lvfdgYlOd/GGHveOFJvN4ivCwPCGLXSTdV4WsSAV+SyMnvHgN0Up/uwEI0uEOOBp6I/DQsrVnevOPFl7P9GFPH8EYbMdPwYCKQcoo+cPf/pbppDEyGzW4mYwlJ64ub1hXZ4WrBejXXqLX/YlZ/8EcugmmvgK5aoixWk5klUtxO5cpGPBZ5ylvLifpsa5/0uZIA8E4CBhj0zA3D0RfaRXLavdpDDPI7eivr2IcpsnWQ2gd5kjfctKaXJTdAmzs75OS3VIQ4eg54/MFV+9utX+x/3QNhCHvOHDi1iI0kI6m/RGbX7W0PuVD8yMfLqO+1K+nvfxo5CdhfC1PJ/eJYFu8CiNCzSec5U7v0K0iH4
 OlMf0NFl
 iA8FpPrH3aUQcXTIG+o0Iti/Wu+i0N3Z1t/NxJYLXgel/9yvfUXJCBxAN79/XRByn+IpPom7eLDx3InrYuo9Hgppahf4F+BodCgp0c8PwXmFQqsw8tIREWbN6bgoK3acznHgZwOxTjjJus7ookRSEO26AWRl/ogiOAMpYOKnssNKONPqOQke3H43nOqoDLG3f+Qap3o7ea4e49FPsND7huEBsQheWVVVixxLP2TpMfpgs0SoouezBlMPU1htM5DnnZm+wuaoAu5OsH1VEin1kTG+gOjW+kj1bVeAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 01:17:09PM +0100, Pedro Falcato wrote:
> I'm adding a bunch of fs people that might have opinions about this. Please
> see the rest of the thread below.
> 
> On Sat, Aug 08, 2026 at 12:13:06PM +0300, vova tokarev wrote:
> > Pedro,
> > 
> > Thanks for the review. Let me address both points.
> > 
> > On the page fault comparison:
> > 
> > UFFDIO_COPY is not comparable to a page fault. Page faults serve
> > existing page cache content (read-like). UFFDIO_COPY adds new,
> 
> A page fault can also write to the page cache. On MAP_SHARED mappings.
> 
> > 
> > user-controlled content to the shmem page cache (write-like).
> > 
> > The correct comparison is to write(), which calls file_modified()
> > 
> > -> __remove_privs() to strip SUID/SGID.
> > 
> > 
> > This is exactly the reasoning used when fallocate() was fixed
> > 
> > across XFS (commit fbe7e5200365), ext4, and f2fs to call
> > 
> > file_modified(). The XFS commit message says:
> > 
> > "as various fallocate modes can change the file contents [...]
> > 
> > we should drop file privileges like suid just like we do for a
> > 
> > regular write()"
> 
> I can't speak for fallocate, or other system calls. As far as I'm aware,
> this is a best-effort kind of thing. As I said, writing to a MAP_SHARED
> mapping does not clear the setuid bit. It's a super trivial thing to do,
> too. But it's not a problem because setuid executables are not world-writable.

I mean, you're right.  But maybe we should make a bit more of an effort?
I wouldn't like to see this used as part of a chain of exploits, and I
can just about see a path where a confused actor manages to create an
04777 executable.

All the tmpfs on my system are mounted nosuid, and many of them noexec too:

willy@deadly:~$ mount |grep tmp |wc -l
8
willy@deadly:~$ mount |grep tmp |grep nosuid |wc -l
8
willy@deadly:~$ mount |grep tmp |grep noexec |wc -l
4

This certainly isn't a hair-on-fire situation, it's just a place we
could do slightly better.  Not so much BadBunny as MildlyMisbehavingMicrobe


