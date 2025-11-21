Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 578E6CFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52396B009D; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D02B26B009E; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2E2C6B009F; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9EB4A6B009D
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:14:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C6D64F0EA
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:14:36 +0000 (UTC)
X-FDA: 84135565752.28.1855DE3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id F37291C0002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:14:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GZyWX2Mn;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763752475; a=rsa-sha256;
	cv=none;
	b=68O73DDRJck2KGhRJSSISM3Cj6urjVpxYqmLt28PxpWTiFFnzkY6sykgKGNzyF/rZjOB9e
	gMUqcZQ/F1LNAmLJR+I74quWJZQ4D3mmrbja+um9dSTKXZ3SP0GhoTL8I8xBD57xiydi/F
	8ehm+L6znwNOuZmrs3vLIe1j0dsjpmU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GZyWX2Mn;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763752475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMj+h1QVkklklb0a5VIBYIqocl/ZOh9bETD1Zczozqo=;
	b=B7UApb5ON6ghRh/bGj7jqPkYwPInayoz7BsFmQvAZ/ZfOQV2YK11s9OqsNtXns5deqsjD5
	EwLErsK4Z3BhdDb5SnQJoLDtDpsGSjVPlB7wg31m4o+Zu4+R/HUZ6soS7dYlSF7sM2Tocu
	pKG9H5fwj5Q2GzcHYZr4hqU/J9Cktlo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B85C60145;
	Fri, 21 Nov 2025 19:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBEDC4CEF1;
	Fri, 21 Nov 2025 19:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763752474;
	bh=q14sVA4KCjPx3tNYuQ9FbdiV8V7LAz23UXdJHkuN3Fo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GZyWX2MnGcSSq4xqwF5sagJZrz9exyyUPLppcdjUp58ZCfOBZNazm5xYZneGq5o0N
	 JnURXsRyFJiqFdnPgQEtplCJfaTwJ96atEFgEH5SrFGonsOt473Ky3KQZXzZ+UK5nw
	 7qYtJwssGWiWJJO3+/CRFjlCP9HHdOnXRZQt88Sw=
Date: Fri, 21 Nov 2025 11:14:33 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com>,
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [ext4?] WARNING in __folio_mark_dirty (3)
Message-Id: <20251121111433.91bea9e742dd2a2e0a3ecfff@linux-foundation.org>
In-Reply-To: <aSC3OsxouD7lFKEy@casper.infradead.org>
References: <691f44bb.a70a0220.2ea503.0032.GAE@google.com>
	<20251121101155.173d63bd6611cd3c4aa22cf9@linux-foundation.org>
	<aSC3OsxouD7lFKEy@casper.infradead.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F37291C0002
X-Stat-Signature: 7fyuj9anhi3rf8txnnmw8zr5gkrinpdt
X-Rspam-User: 
X-HE-Tag: 1763752474-374818
X-HE-Meta: U2FsdGVkX1+v/+akq+ocjJhBNJ9DRQFo5d/40DbfXItpAFNEe6wzdF0N9X8Fd/qYF99WvjkpNIgfMHQ/c1Ee8ftIbB/+iVNTjTdKxZtpUavGzjayjcbaSbpe9ux/lhpSlhMHkoItnwnX4SoknfsM0QRf2vPbbueQnNGtNbmQQRPtQbMPtP+u9HjYppBmicWdFWOgRjyGGKEHtBjonwqMrDpRcdzICng7q7YYW+D0LUPva7qDrOgjkB2eu64ZHXL9auf6HgWxo9gJYLr8gpZwz+ueNpSn4nOUcCSfK0tT8mgHbWBpiBEintMd3NoNl9M9uxz4ip1/y7E3BsRRTy7EGs8HKEQt+JLLbLjrArMfFyZACWmRHxXT0q+dlke0sRCJVDoVC68qtYtEiL5u4HV6ij6BtvF7m+acRp6MSXUeRLYHtEeyROVCT62ooV7dtAsOJQL952171c/2KgnN60kdYMQ+Y0da4wuaH2+7RpedqLBruXDL17MXqASpWKHZTbM0bztlsHN7vDtU7yFnT9fi7D/F3aL62FyRaxw43OsXnbq6iDEwoM0Mmnuo5/4RAL63+hgo2YtzibScdcqYVRp70cEDoMKeaN0aq3KlMC+L/5CpPsaU6XGp9rnrK9bEtZZuYTjr/urSblZyW/vAn8w65HJsK53f6aurf3aRY7ZoTGm4RLFlIfLJWyvvIy2/Fs6Dqsau8/sKnmjbNB9oxliPcJK9Bo5+CmM2X9UIwSv/lUl/svcKIvl5EV12wIb4X/cf1QYnN+sq+fMuZz0se9VHrNfCQfrUH4bw++zYUHGWJriu8O+9ffS1aND5+hLfQdyZWkTtHRkaPuI+SO/3sPCJfJWqNjJAhnzzJrPCgck+wnKSXbTPYHZnpQVsOUTZvKki4pOA/Frc8Hp5x++roJ4AQqRYj84CLD7mOW1hlfoMVVlJx42ZFoueyx/bvLJdFDFtRUid2APTN0uBroRurLG
 9mk42Anp
 GKLshBNR7LBhQAlIVFWXSwZla9cs2Sy918sH7QNAWu0BoCqqBGMs+pnzPkDP/uSLUItZdkhksT7tsiCb8inyIoab+WoTXQCJwQvc+lINdGkSIHtpv7RNOicu9P+9qUT36rgN/T+GkCnYncVZisrooSZ9for2pTCdHwTzlpj02yWQVvtkgdCtiCRJbg70rbhGdIN9MBStsxhlaPl9axkj71gW0Ry2z9FpXt/HemcJks/18x/riM5c3fYzwTqkVtTfjkeOjW4jN+6mmtlRhYIo1JafdGHhl2UOepPcrwHEr2Habugsv33uBIDpSPJkD4uFIoi7qXzlf8orOLMWl37fhNJzOqiSsbfp51hYJ76szT+QFLo64We2QhVNEborBqPdn5pjqY5U/EPlzsnATjdu5RCcU3b8usENuvFtPomM96hkbykYiAMsHXIFWF/+tkoscowwxeRIwI4SbaR2EMzLwb+RHI4IUnxRTaVt+XS+E+IQXhpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 21 Nov 2025 19:02:18 +0000 Matthew Wilcox <willy@infradead.org> wrote:

> > I'm guessing that ext4 permitted a non-uptodate folio to find its way
> > into the blockdev mapping then the pagefault code tried to modify it
> > and got upset.
> 
> I think you're right, but the reason it's upset is that it found a
> !uptodate folio that was mapped into userspace, and that's not supposed
> to happen!  Presumably it was uptodate at the point it was initially
> faulted in, then (perhaps when the error happened?) somebody cleared the
> uptodate flag without unmapping the folio.
> 
> Hm.  I wonder if we should do this to catch the offender:
> 
> @@ -831,7 +833,17 @@ static __always_inline void SetPageUptodate(struct page *pa
> ge)
>         folio_mark_uptodate((struct folio *)page);
>  }
> 
> -CLEARPAGEFLAG(Uptodate, uptodate, PF_NO_TAIL)
> +static __always_inline void folio_clear_uptodate(struct folio *folio)
> +{
> +       VM_BUG_ON_FOLIO(folio_mapped(folio), folio);
> +       clear_bit(PG_uptodate, folio_flags(folio, 0));
> +}
> +
> +static __always_inline void ClearPageUptodate(struct page *page)
> +{
> +       VM_BUG_ON_PGFLAGS(PageTail(page), page);
> +       folio_clear_uptodate((struct folio *)page);
> +}
> 
>  void __folio_start_writeback(struct folio *folio, bool keep_write);
>  void set_page_writeback(struct page *page);

We have a reproducer, fortunately.

> ... it doesn't actually compile because folio_mapcount() is in mm.h
> so the declaration is out of order, but I can invest smoe effort into
> making that work if you think it's worth doing.

It's a shame to add more debug stuff into oft-called inline functions.

Maybe some hacky thing which uninlines these functions and adds the
debug?  I can slip that into -next until we fix the bug then throw the
debug patch away.

Of course, there may be other filesystems which are tripped up by this.
Once we fully understand the failure we can decide whether it's worth
adding the extra debug to mainline?

