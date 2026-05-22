Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB938CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 04:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7C86B0093; Fri, 22 May 2026 00:02:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 178756B0095; Fri, 22 May 2026 00:02:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0689A6B0096; Fri, 22 May 2026 00:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E540E6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:02:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7BAE41409C3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:02:09 +0000 (UTC)
X-FDA: 84793707978.26.9B2F079
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E6BD88000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:02:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5U8pIq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779422527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFwLqtBegPrYOeSN0ye6SbCQz3TQv1Qmus2tJiQyxPs=;
	b=LHxURVkg72tDOLvpZeIq52xtlRpHBLxIULHBuJ1XT/l6lIV428tnRPzD293ZuX7hJ5joyD
	4xYAqVwQzOz00GUeyUh9zQ1IdxZ5MvMdX0vXkkXKX+iIS7SLx7ZC2vwi8up/5QTfUmViLs
	cjHJASxCP28B1ntBDbXtWMizJRNE8Do=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779422527; a=rsa-sha256;
	cv=none;
	b=xcDlJoQmYfQCC40+ZgI2PzEHa+r8pz0eBYHU4BofukfF6rnsfL07FkY+wxW8CiPoKaDA5n
	QXID7WSLRK08ReeEJvibUn8jujU2p7UE+XNyrOp8hS8t94ELtO72bWPKCe7avcveabxwk9
	atrFAaBr9csr2lS5G+yzduhcKwhLwIo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V5U8pIq9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of jaegeuk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jaegeuk@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E6676014B;
	Fri, 22 May 2026 04:02:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80681F000E9;
	Fri, 22 May 2026 04:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779422527;
	bh=GFwLqtBegPrYOeSN0ye6SbCQz3TQv1Qmus2tJiQyxPs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=V5U8pIq9CYVjKN1M26c9b9NKyxbKNnsst43BpYHw1DsITUIVizoffTmheov44CS5q
	 RC4YKVuVcJV1HeIny7fKMAPNUaVudn/uTOVvE44fxeitC4tGQLrVW5VFS7IbGno+H+
	 cT2aATaZRzZsglm4rt0Y9AF1jrW8fI5GyXvQw0rIyoOyDQW+I92HQ7KEz4K8PpOoiP
	 83HyHOFnC80JpiUmO6zQ2C4JY4DUjKUow0IeN7OzXJfPEspGNm+1XkSkX6RsNMyFZx
	 hWGUUq+V+NminNRePBFveQW0fsFFOrqS7G+6Qjvo70M6y6660opAlN7QRmJHAlwatb
	 Ezhvlm7T0Nwlg==
Date: Fri, 22 May 2026 04:02:05 +0000
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Theodore Tso <tytso@mit.edu>, linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net,
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	Akilesh Kailash <akailash@google.com>,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ag_VPae3w2z_SXD9@google.com>
References: <20260409134538.3692605-1-jaegeuk@kernel.org>
 <adhPZxtbZxgU-37v@google.com>
 <ad30g9xMs9wNJhFb@infradead.org>
 <ad_AVHe7RMnGrGTb@google.com>
 <ad_HwhzlNPUEKQi6@casper.infradead.org>
 <ag7HfNryTmQ-bVIS@infradead.org>
 <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522035331.GE5937@quark>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522035331.GE5937@quark>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E6BD88000D
X-Stat-Signature: 4hnr4jsxpe78a9czr5igtszaj4nai47w
X-Rspam-User: 
X-HE-Tag: 1779422527-651111
X-HE-Meta: U2FsdGVkX1/PDrd7AfqZSihJgktAFEgBUDyWIB4dSM2i8/4fXIH/dDrxJ+T2WHdTdNi0B2coHiNf+KHXv2cxo8Q3FpeZkXyjk7JEb1Ze5BV6Ne1RWx31sLs2NzXzKv1vonzxkHwQ0hqbd3oIZ5RSb7LXkc7afY2OliZ3IJXuTpteBYeWZyRH+e+wJ+CKXWhgeWjxZdM8YzrNqQ78S2rKv0EvGXUyK8uUwxexYjz59vfpHoAqg2orax2qFypQhFZVif8T/O85k1f6gNcpy5bDJorWzQs+rp2usqY5I/GPkBZRllI0FJ1Cav9xEBjUnQZe85UU1kZ/5VZ9eFFQwLvAooCY6xvSTxbNFoIZvqVyHa+OHFxd8RRp5IWogIm0Q1gdl52v1v2gusciK8DjU70QenLThq8HHnkoyMPF1u3HJgc3TBCFfJsYPF75g4kgvqOYv5m1OjbmdfxAbhH0OoSBr30gVqpzYl8aYGglYLvJwITEv9HNJvyS9iySSMX/O6UR2Af+8RCQd6dq6FB0QGj1PvvnMmJ/PbIZO6qjIIc+R2jpiOZhZjEznsesTrbz79zTs3yfyCUUC3vUH/MAaJpMOR8GyhxqVU5U6jZm6l88V3itcryKN5abiO/hrPIUWualhylS2wfMw+8X2nixnhwGoXrJXOKzhxJN71HYd2Db3iasorw8kQC1Mee7dBCmY872l+uq/QZ2+MIkZScrBljzHmsVEVujqEuQOwJPeck5/XxUC7vxQJumx0Yi9OgKsILpUUxDdQdv7jgVbhpFuJ2EeotdiKqzo8wnMvq0pNlm71/IKT2DRfgvAfIUTPAsT4Q8ayy06CEB1HGUZrYUgkePZDjrewDCAZFED9WqwyWMy1zVW7uWPU5gHQnPUKqV2PA00mZcuXVc5mgcurmaXaW+DNl8yjVFQLAmOwqtw4PShew//lSSnYMHOt2iCv5uoruolDXwNmt8sbIEVhXVZJ+
 yiHNfYz/
 0zKxBS6yQeKFuiJYEFbN3yjWxYTI33a5bZRHEx5uPC3INrRWMLED+vsuMcaXgkqkBUOQ6AFM88/zTVObjhjbm2VS9YuiZNzzy199dkXHJKPZ1GkPkdcmrx6nBUhJ79kgoCDyUJViPDiYH6faX4stl7KbXCpoZLuvGdHe08BxkQ/9Wtbi9msnIzVoBqCx2MACJvLtP/TvbhSj5DxILSXeZjR8U+GLzxRaMLMzeFfNILq5ltjN8/8Y/q66EfOoFqxmdYMvOi1Vphx687lE8DV6XwdbVI97ipUHz4B4K4bNwHbdNHCqHKkYANEqIAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/21, Eric Biggers via Linux-f2fs-devel wrote:
> On Fri, May 22, 2026 at 03:32:39AM +0000, Jaegeuk Kim wrote:
> > On 05/21, Theodore Tso wrote:
> > > On Thu, May 21, 2026 at 01:51:08AM -0700, Christoph Hellwig wrote:
> > > > > You haven't sent a proposal.  This is a reply to a reply to a reply of a
> > > > > patch.  There's no justification for why f2fs is so special that it
> > > > > needs this.  What the hell is going on?  You know this is not the way to
> > > > > get code merged into Linux.
> > > > 
> > > > None of this got properly answers, and this broken interface now landed
> > > > in linux-next. IT is offloading a user.* xattr which is free-form
> > > > user data with semantics that are weird to say it very nicely.
> > > > 
> > > > All this was done against the advice in the mailing list discussion.
> > > 
> > > So let me get this straight.  This is a magic xattr interface which is
> > > not even persisted in the file system, but instead sets a 32-bit
> > > bitmask in the struct inode which disappears once the inode gets
> > > flushed from the inode stack.  And it uses a generic xattr name,
> > > "user.fadvise".
> > > 
> > > There's no way in *hell* any other file system is likely to adopt such
> > > a broken interface, so why didn't you just use an ioctl to set this
> > > magic f2fs-specific flag?
> > 
> > I went this route because Android heavily restricts ioctl() permissions
> > and we needed broader access for this to work within the framework.
> 
> It's straightforward (2 lines I think) to update Android's SELinux
> policy to allow an ioctl in all domains.  So that doesn't seem like a
> reason to not use an ioctl.  In fact this is actually a reason *to* use
> an ioctl, as it shows that ioctls can be allowed/denied independently as
> needed, whereas xattrs just use the file write permission.

Ok, that's also great news to me.

> 
> - Eric
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

