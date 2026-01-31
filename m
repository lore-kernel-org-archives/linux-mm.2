Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BB8E6BF33
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 01:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB51D6B0088; Fri, 30 Jan 2026 20:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D9B6B0089; Fri, 30 Jan 2026 20:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B90486B008A; Fri, 30 Jan 2026 20:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7EA86B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 20:06:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 639A0B86F5
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:06:34 +0000 (UTC)
X-FDA: 84390468708.23.1858753
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF187A000D
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 01:06:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="bgRCHe/1";
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769821592;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6niAf9hGe4w9oPvmCTGyNtjBKea5D0eR+MRPWb1Frg=;
	b=Oi5WieLnsWEnX5KjNv+g6qhPoZG03Nu+8zFINUGT9I1YfFAZDrf/8dndcsGZ15WkVsYy00
	WD3Zd5pzh8JgIk4jY8uh6USjLQBjuP2vZLdWA3r7P+bato/1la2PuaJzHPb8JEXjab8ZKS
	ZuPKLcNOGM2CZIzu6R7y4TQAxDEn3Xw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="bgRCHe/1";
	spf=none (imf25.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769821592; a=rsa-sha256;
	cv=none;
	b=50X4LdeTbfEB5/6RxOqL5DrjcxcyVKu+gRgUEwbvsvNrkLMl0xW8Y2qraFaU/FP6D9LAUb
	IsK33IBxL8VHJ9sWyGHgJ3zO+bMztbfk3UGR2oPhxesJR2jjUTQ6EodA2BqSH8BMEvCWcy
	jTrVcut+mFVA3pCmx4EWhu6mVc9V9+E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=j6niAf9hGe4w9oPvmCTGyNtjBKea5D0eR+MRPWb1Frg=; b=bgRCHe/1HuJX1btyYG1KNZ3vno
	TCqbEHHU6qGFN6p0raUIHroX/2Mch+Dje7lhnqFfAJqsXO6HOqA7hIbTc5Ox2EyVbbOISxAEFdnC6
	W6r9RbXH0cnnhzNCiUhyza8AQbuIL4q3umghKXNiUTquST9A8JtmhoMfurM+zy30Rr9a+EJlhTbz4
	mYdFlsgU/wLW6TW33NJuVF5q5MA2CVNgEEq5fEtx1mxQWuXErxAlK11j+2i67Fvpc3vfpacoulXyo
	qXmAQ2zn5lax6oOz0fp9VhU1n6CsYyGOFMeanmsPrwfxDcQRKBhE1jubjYt0zbsFP4o9GMz2qqGl5
	v717ALhA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1vlzTJ-0000000D8c0-0LnE;
	Sat, 31 Jan 2026 01:08:21 +0000
Date: Sat, 31 Jan 2026 01:08:21 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Samuel Wu <wusamuel@google.com>, Greg KH <gregkh@linuxfoundation.org>,
	linux-fsdevel@vger.kernel.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <20260131010821.GY3183987@ZenIV>
References: <CAG2Kctoo=xiVdhRZnLaoePuu2cuQXMCdj2q6L-iTnb8K1RMHkw@mail.gmail.com>
 <20260128045954.GS3183987@ZenIV>
 <CAG2KctqWy-gnB4o6FAv3kv6+P2YwqeWMBu7bmHZ=Acq+4vVZ3g@mail.gmail.com>
 <20260129032335.GT3183987@ZenIV>
 <20260129225433.GU3183987@ZenIV>
 <CAG2KctoNjktJTQqBb7nGeazXe=ncpwjsc+Lm+JotcpaO3Sf9gw@mail.gmail.com>
 <20260130070424.GV3183987@ZenIV>
 <CAG2Kctoqja9R1bBzdEAV15_yt=sBGkcub6C2nGE6VHMJh13=FQ@mail.gmail.com>
 <20260130235743.GW3183987@ZenIV>
 <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgk7MRBj4iwQLHocVCa94Jf0cMEz2HzUAS9+6rGtnp4JA@mail.gmail.com>
X-Stat-Signature: z7rjms6bkxdhu8md3s946sehzajpjju7
X-Rspamd-Queue-Id: AF187A000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769821592-941660
X-HE-Meta: U2FsdGVkX19d+bdkx/3eWAz6OukoEwkC4WC48FG9tkXHI3fhUjgG2Mel2TXGfRoHTfEm2KR32fZny+tN0vMRrNnHsVtESIvcQBWaRVPzkLu0AELUfXnU1Zu7eB82wruLTDv4VXieeSCrTJnVFuHRb3bLb/xOE8kX2VwTFuR2I9D6TKey3JO6wR9jDLSyN6B1GZF13EpRlUG5HF/QTb/nzkxO8Pm3GIlQN1lphO4huPu2gYk85wFwfg1XTZNctHyACf4gO7Q98r0vxiWeRS5kxbZ0yimXxavDW4myPtNYHFuKcULBOgejfHlvxps0GzgV2WMUYWvXNrrn4PsFlFI28DfmVWq8ExeWUf66r2f7WLIpufYQELu3q6K1lupLALXjsPaTFk30RcgpxgTXv8vRA2A5h2zNhin2pGWZJ2vOSktBn3n+52UTC8NC8hDZAuqihDg4KntJSgYzoAPqTfj78HYvtc9Cr0H99QSbYFhs5uIZJAx6PoFFXr+2T/LFuA7FjQGFE+nkMbWL1rqkzJV96SNMHqfGI908K3WdsOChy1hdSzy9TeWls/UhQKd+cTPjOPG3t9/XeZDCBwCBr7w/tw8a4jhLVT1Q0/2Mkd/It4Tdntb67UcNqyoS7971eNSPdJBQCcVPzjhSU6PQGvdj//H1SvoekHqSOAXEMV1KFjijRlNQFdNnwDJsg3M5sMfVciKy7Yx1gU4M7kImW3VPbyXFrCVb6pBP2Da3Obh/qs9OCc7NqQQADmuWQoaOuQo01njeOc1JqwJzBZZbbP5+ZuNEY7erlz0MGxrPv1ZJNC7yO7QukNuWJX+eUFDBbYPg9iTPf5xk+Gf5JQLuMGCdqLhWtxPv8ILDMlZVONHlHz1gnQXtYHIZOUWcSMkFILB8zxmPbFozT0UMqSs7tJfhM529hPh1e7e/EJ1rkrGKISSHDtSjiQivirD3NcuDAlVqSKqy8GDDY2gqJoF6jZm
 eiVn/ldH
 ELcPqvLewjRH96vwekt73ihVVFkUDNBH+HtT5zFokJ4M8t6IT9ZzRHMexzCETNko1GFMbgiFACcN+TLb0AdBuU1V5dg+wIHoEFszOSF3LxD5SBzMxipix35loU+YcyR56zLjR5P2QMj5qChjUTaoj5ZP9kYagzRVC3K/dpcK2o/g1JPsPAFsnLkFq5qCGVrZkIj75X8EyGXpTV0IVS8yIVf9MWhxZkoDmEg81mxxLoGeGxHzOckQ01NGARaHE82PZlgNRHt9xVSdx7E17SJJXUeQLOTFoibpIMH3+gizjlD8kSZCl8oa6pBIxNzuq0YW1GLreWOZ3oc1gWROJh9vnh2XygFMpz2hjMFDtsXcIhrP+uDQZXOZ4o5FFCVXUQzsZjfdYUV73hzvkf/fOPKBPQm2ueCluFxYdYjgCMScok3HYFTX61pdNrGS0YpKoQYtQC+6cQL9uZG1NwGRh9TdZZxn3cEElkLHDoZAyykpROcC5Qig9un+eZlnpFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 04:14:48PM -0800, Linus Torvalds wrote:
> On Fri, 30 Jan 2026 at 15:55, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > So we have something that does O_NDELAY opens of ep0 *and* does not retry on
> > EAGAIN?
> >
> > How lovely...
> 
> Actually, I think that is pretty normal behavior.
> 
> Generally, O_NDELAY and friends should *NOT* turn locks into trylocks
> - because user space has no sane way to deal with kernel lock issues,
> and user space simply shouldn't care.
> 
> So O_NDELAY should be about avoiding IO, not about avoiding perfectly
> normal locks.
> 
> Of course, that horrendous driver locking is broken, since it holds
> the lock over IO, so that driver basically conflates IO and locking,
> and that's arguably the fundamental problem here.
> 
> But I suspect that for this case, we should just pass in zero to
> ffs_mutex_lock() on open, and say that the O_NONBLOCK flag is purely
> about the subsequent IO, not about the open() itself.
> 
> That is, after all, how the driver used to work.

I'd rather go for a spinlock there, protecting these FFS_DEACTIVATED
transitions; let me try and put together something along those lines.
Matter of fact, I would drop the atomics for ->opened completely
and do all changes under the same spinlock - it's really just
->open() and ->release().  Simpler that way...

The shitty part is that ->set_alt() thing and its callers seems to
be written in assumption that it can come from an interrupt, so we'd
need spin_lock_irq() in open/release and spin_lock_irqsave() in
set_alt/disable...

Another fun part is that we need a barrier on transition from
FFS_CLOSING in ffs_data_reset() - right now it's not even the last
assignment in there.  Same spinlock would solve that - screw explicit
barriers, it's _not_ a hot path and the locking is convoluted enough
as it is.

