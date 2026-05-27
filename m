Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E680CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 08:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785EC6B0005; Wed, 27 May 2026 04:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736F46B008A; Wed, 27 May 2026 04:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CDC6B008C; Wed, 27 May 2026 04:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 537076B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:50:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E9E8C1404F9
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:50:53 +0000 (UTC)
X-FDA: 84812579586.27.6494502
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3DB824000A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 08:50:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=K+Lei1i2;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779871852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wP+eaBcEtoPp/7xKAXoJ6JjcJom+Mzp3XCjO/gK0Apo=;
	b=yM+fqwKXmDMqS94sbNeic/XrGu7/flwQMied+AFxc/NwNrSK/8zq+9GlLMKVk09CuWjC1X
	keJR+3zbiKvl864Z/tjuk3PsqMQeTon3t+oOdkq0+OLtPq5+uFWxnMJV5fgyhaZc8/AUiY
	T/y3ARp0x1a7MO2AIl/3bYfSRfG6l5I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=K+Lei1i2;
	spf=pass (imf17.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779871852; a=rsa-sha256;
	cv=none;
	b=WnQPrNh6zx1f51VxwTrWXlljS21YWW5sLiAJdei9MVGrzEoJO53Xxs58n+w2z503pQA0gO
	tErnp3Q6ZCSnqssofs0Yii6KNOTCcnOliGrjnIeAg8A+YyHqPUspXbJuQhNr0i3eOwVmO1
	ft1cOi5LTzcc7YuAJCX7KTtPAD0O2u4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89262600BB;
	Wed, 27 May 2026 08:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABA61F000E9;
	Wed, 27 May 2026 08:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779871851;
	bh=wP+eaBcEtoPp/7xKAXoJ6JjcJom+Mzp3XCjO/gK0Apo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=K+Lei1i2RUOAYTYZkiOXopxCLHTDTPRpVpJstm6pInlnJQ9qHLOOfWasbnBLkZMM4
	 vXrvnSHqTkxkPy32XlFCSWRCO+yFrXKUrdY4aMgE9d85RXMYr3h2xH3T4VcqEIKQUO
	 gQ/YspVihJ62O1jZUNYdLwkGVyeyuVL/8FBWqxI8=
Date: Wed, 27 May 2026 10:49:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Calum Mackay <calum.mackay@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	linux-fsdevel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
	linux-mm@kvack.org,
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH 1/3] tmpfs: simplify constructing "security.foo" xattr
 names
Message-ID: <2026052722-garlic-worry-03b2@gregkh>
References: <177945382308.2991556.1256192774754909984.b4-ty@b4>
 <5386153f-9112-4971-98fc-de90d7aae2c6@oracle.com>
 <CAJfpegu3PawBxwOPEO-+at-B9zRTJOzY+z4qeV7xOwOQb3Fr7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu3PawBxwOPEO-+at-B9zRTJOzY+z4qeV7xOwOQb3Fr7w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3DB824000A
X-Stat-Signature: zt9q4p86sqs5ewttc79txkffc1in55oe
X-HE-Tag: 1779871852-19741
X-HE-Meta: U2FsdGVkX1/XewWeoCsFk+T5CjyGrKLfVSmpkRDnCetCxPMgY0/QML68poAXh9Y761s3Kxgb80ER5xfFyoTGirPP8DsbtQ9XR4yKYE/60pVF6Jzib21cwo9+HaFXpLTBbAnIk6XPymcgTsc6nSuA/p4KSKdhuUBMBHJ4CZLRA7+EFTSMAt9EpC4maNTqtFfEamPyaS8D+y9v1oUXN5l7ED1R7Ny4ObWzbIhosVfKWhjcsIn4Zw81bOIu1sC/Gs2b7OWv6bW+06DSS6BK30yKU2IGv3p482oAxCcIdbiGyhqwl1sD7n2r7GGbbtDJ4+2o7+ucVic3rgD5KlcxRqO+4hr31vx5+hebWuWJylDARmPKEi/BK8QRvXGPHHqwm9K6D2O3MT5vwbcf6TaJdGdtKCCe5AQgzbRrBhbbnd8BVHuhWq97IKBww5yFvR9iUUsnY83iwRC8BUh0bp9oeqE0vDNiSAaAnJblSAiyV2Tu4gSJMQBlYlbB0YMgEdc5R9sq9FQwOc+0XxgZGwnjTApxkeD+IfbnqRhj/dutbeUYY9DLpN+R5WNQSaBm3xcjGpOATR2P7tJ5fnyXQLOl97C31tNYrTw+K/XjsLAjRzDMHFDySZ53jFInF9+gJFFlPlILvgdrYbKVGi3g/TqWAx+C6J1iJCK7tHUBcSB57VvF+YzBlzJsiR7+52e1gCbGjUUMjfWaCH7HigNZF6miStK45iAt4gaecpUo79ogUAW9neBBbhY6MTZW03JwZ2JDeQl78PvUY/eVrQIukGsqIRht1Do3eNs5x7nREJFnvEqVHSAFbW6/IPH67SaJxRP10XwXbzWo5mw+tb/tyy0d0UXJE6ljDIjob/YlXDPvo/2RyrFtafe7wSjQD8PecGAbttJGoQbGGtLE9aLLElUi3hrwQzc/o/J19z54wkqrKWCSq75EJ2smC9/81jQggt9cQJ8FtGn6i56o1nsUpfEkJaB
 8cpoU8Yu
 fbDz+iUKcskbho7xzD/4ganPdKgtc2uYHzXt1zlXqFiNF194JNX+6g46QoPgP4nF6AFM2R0QNHQCchpgqjs9JgSETVHWIKhGh17MgO2TqFGnBo2dX1egNUv4mufjUo9JCJcmIm3nTOAe5RvLfabtPYOBYugycDwCH6wir0ooeAZRRS0hYUuAmqzEYBtfYCk7j34m/V7NYpJzPVbV+iyF8sxmd1AWVuEDII4Hune6eIbI5cyl4Zz9j/T9TyRYcQddLNLLNBS/SSnAn80ymdwMqaFmSMP+PVWBT+/PZSpv3DnxlGkl+/do5TAWUNW56iDdnCgU+m2zgfZdHmrZSxohS6ATPM4zOMa7JArGNNU5C+STf3lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 10:46:12AM +0200, Miklos Szeredi wrote:
> [Cc: Greg KH]
> 
> On Mon, 25 May 2026 at 05:59, Calum Mackay <calum.mackay@oracle.com> wrote:
> >
> > hi Christian, Miklos,
> >
> > https://lore.kernel.org/all/177945382308.2991556.1256192774754909984.b4-ty@b4/
> >
> > > Date: Fri, 22 May 2026 14:43:43 +0200> On Tue, 19 May 2026 10:13:21 +0200, Miklos Szeredi wrote:
> > >> tmpfs: simplify constructing "security.foo" xattr names
> > >
> > > Thanks, this looks great!
> > >
> > > ---
> > >
> > > Applied to the vfs-7.2.misc branch of the vfs/vfs.git tree.
> > > Patches in the vfs-7.2.misc branch should appear in linux-next soon.
> > >
> > > Please report any outstanding bugs that were missed during review in a
> > > new review to the original patch series allowing us to drop it.
> > >
> > > It's encouraged to provide Acked-bys and Reviewed-bys even though the
> > > patch has now been applied. If possible patch trailers will be updated.
> > >
> > > Note that commit hashes shown below are subject to change due to rebase,
> > > trailer updates or similar. If in doubt, please check the listed branch.
> > >
> > > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> > > branch: vfs-7.2.misc
> > >
> > > [1/3] tmpfs: simplify constructing "security.foo" xattr names
> > >       https://git.kernel.org/vfs/vfs/c/aba5853b137b
> > > [2/3] simple_xattr: change interface to pass struct simple_xattrs **
> > >       https://git.kernel.org/vfs/vfs/c/1cd9d2387c05
> > > [3/3] simpe_xattr: use per-sb cache
> > >       https://git.kernel.org/vfs/vfs/c/12e9e3cd03b5
> >
> >
> > I have been doing some testing of Chuck's nfsd-testing tree, which
> > includes some vfs changes.
> >
> > The test systems are reliably crashing, in what looks like it might
> > possibly be something related to these three patches.
> 
> Calum, thanks for the report.
> 
> Relevant part of call trace is:
> 
> kernfs_new_node
>   __kernfs_new_node
>     security_kernfs_init_security
>       selinux_kernfs_init_security
>         kernfs_xattr_set
>           kernfs_root
> 
> Since __parent is assigned after security_kernfs_init_security() gets
> called, kernfs_root() will return NULL.
> 
> Greg, any idea about dealing with this?

Don't call this so early?  :)

I really don't know, sorry.

greg k-h

