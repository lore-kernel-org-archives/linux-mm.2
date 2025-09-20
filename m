Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B48A4CAC5A5
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 18:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E32C38E0005; Sat, 20 Sep 2025 14:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0F728E0001; Sat, 20 Sep 2025 14:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D47298E0005; Sat, 20 Sep 2025 14:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C47B08E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 14:09:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CCE2C01A4
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 18:09:28 +0000 (UTC)
X-FDA: 83910416016.22.7C1E13D
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8C5C91C0005
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 18:09:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NM79fJk4;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758391766;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6NL30/0+UZmJ+Ndqi2NTqpdBOV8RvNTpTtq6rtRPK9E=;
	b=LZ2+DnHSTTb5ckyb9SL1KmcdNfmrr5Gepv9szJnphSK0IMslGdSrMvsaNhy5OKDMhfLNDC
	HZDuLmW0LTtesyl1ozB/5Xmz6Ghe1g+7sujj2gXNhUT9I5wQVmoIJuX1w9MjomkqemBnLA
	JsPExpXOQu120HkPD2TOVSfZz6r/B74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758391766; a=rsa-sha256;
	cv=none;
	b=gQW6yzJGd9yWvlkBj0dwbrk8NLNeLTAkJFQE2+Qy4Jmk5jPP6Fxck97Ys5f0Kofj4tkVaH
	HJtE02uNUcI4C8+tXOgHlAG+J8aBAspDAH5RdyPzaMvXXLyLw3wNlQHMEaUqDr/hj5pveU
	itWOA17ln90/laa5QHvBZXwGWL8sSw8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=NM79fJk4;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6NL30/0+UZmJ+Ndqi2NTqpdBOV8RvNTpTtq6rtRPK9E=; b=NM79fJk4vVddI7amyfuuFalCjV
	KCwjdAr3TBi8ShghGh7DNgYuVH9L+WE3QjtxSRg3IZBe1atmcEKyONCQj9I3wo/0CEGQOZou4azRK
	2+7qBlOTxdA1xp127r7u5bM6TjwF9mONn+nwL5XucvYd3CZuGSX3BA5ysms187Yyj/wF6/86/CmTL
	WC2z/0mRVx9nm5VEhTaqI7AesxCZh6k1F+Lpz9Pus6qr4SxsrrMPq2R9tjnbIPN4krYN0ZoLm1Cek
	ZI6tJ4FtKRcLJdSKn5AdIr/wOwwbdc4jFYT2UcYCQC/FIOU5oSOQeuYce7ptP2b4JNzeCtNGNm6Zd
	bQgwQelw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v021O-000000039W5-3GQv;
	Sat, 20 Sep 2025 18:09:18 +0000
Date: Sat, 20 Sep 2025 19:09:18 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>, Ian Kent <raven@themaw.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	Kees Cook <kees@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCHES][RFC] the meat of tree-in-dcache series
Message-ID: <20250920180918.GL39973@ZenIV>
References: <20250920074156.GK39973@ZenIV>
 <CAHk-=wiXPnY9vWFC87sHudSDYY+wpfTrs-uxd7DBypeE+15Y0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiXPnY9vWFC87sHudSDYY+wpfTrs-uxd7DBypeE+15Y0g@mail.gmail.com>
X-Rspamd-Queue-Id: 8C5C91C0005
X-Stat-Signature: 9kr7jy8ihm3eop3ohts4wtz1151mk88i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758391766-797443
X-HE-Meta: U2FsdGVkX1+gg0AtHTZHj5MQkeJkhMYXtM3tVxgt9JtBEGkmladLLcCCZeztjl2bXS3DetxNhIK7tX8YUGQgjOoimNApp4DkttvikYVfO4aBf7YlcKan3X4M/uNAtZFaFA9rdRNfMGY+rg/Vx9G48VqbS3ZyuigPdz3FbRvBl4UptcyW+ENd4bQUW0V3yMXtxYEd6aBR146RouCbiBLhsAfMROIw91pLjoPdq4kwECwVcop0RGsP5YqeUsXX8SKbMp+AktjLn4gAYX18mPsVBRDPlM9eiPzcb1sYEW687lwVtDqlO04fq3EsNbBaL9PcVrCbFS/P0AFHMX2f82XBPtcyqhAr9gs6+A2lzrjpni2OQhUWhdzKhY+UvmdoMJ5lh5LUX6xTHr0VjCesUbsMT2g9PwBDA87XAO4FYGTdyN1hZ8nxnUG4pOCk585OjnhdyAfz6dCib4ZSU4SmFeNxFXvbJjusek0o79NZ38Hp0GUCwQCmZ79rzqzhjjyipWDmaGtBA0Sq+ddXoP8GuW1Z4frmMCO+jETYTuSjRrVV06CMXWI2r54pruGDnB3h7nXrzu4ouHDDIDZcjJdnPb3RawZnbDw13nqKXqt6z0xpDhibsulG0ICXKQJ2+2u1E6wRQ8oBLrfWTyWdJ7/YYlLBt0bk3k/9jpDdj5YBux9M1KjwIbDyAgpLFL1qIgnrN5+ROhBY+WZOPXcDyCAMIP/QtwYe/roAeY0g8JDVHoe5i9XuinHlRcSQaAB03CHWifkNFZcxaAuniyaeo5BwaN5ISKYwnmGHMiLZpGCVNdv9z0r/otijlo/I4MdvVkIC4rZCC8vnXwnIHGyTvPHHRAIa1FMeQzOCv7zPw/NhkPiqf1aSprsWDV7Gi8HdWL6In2tO6GinTdPiMb9OZSKrqk8JHZwH631lAGKxY6sqqD18q3CTA/tE8gcilfb6Gr2Kd5j0sS/92HyUNGGrMuAUBjX
 BPL1Yve7
 cQHFFJkDFuRvK4LH2bjkl1lTdk1cYnTi9bKyRLlRYur3LBd8dcdlPHhCzKkw0XwuPHJ/Jmmj4/OWjCFNhTdABb3AZtcLIxfADxrX75HLOKPzzVJEuCD6/vehManYKM1auv327nrnPuy78ohUanIEA4TYo0FxNvSXdezeSsVOiGX12MAoplUXJnnYVIbKirgjE2nkz0v1b2xTVSoc6/VO38Z1Dt2N1Ukq6GzUldOHKJeLuVNISkJ2oDW5d7SqeMjWpvg5M+QBtiR/u1JBJk8zkI9W8NV0PJIxuKPrZax6esGFKh8YSUj3lgky0KiNA1nzV9Oqms+/vadqRGvb5wy1j9FztXx0SWqa85/1l6/dOtvPJLD/H4kvQq47tTPMtz7gg4P1MpyUi6LY06W46BXDjHiLzoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 09:26:27AM -0700, Linus Torvalds wrote:

> Anyway, apart from that I only had one reaction: I think
> d_make_discardable() should have a
> 
>         WARN_ON(!(dentry->d_flags & DCACHE_PERSISTENT))
> 
> because without that I think it can mistakenly be used as some kind of
> "dput that always takes the dentry lock", which seems bad.
> 
> Or was that intentional for some reason?

In the end - sure, we want that.  But in the meanwhile that would require
separate variants of simple_unlink()/simple_recursive_removal()/etc.
for those filesystems that are already marking persistent ones, with
the only difference being that warning.

A lot more noise that way.

So I'd prefer to put a warning in the source for the time being.  In principle,
by the end of series as posted we are down to very few filesystems that use
simple_unlink() and friends without having marked them persistent in the
first place, so it would be possible to put a "make d_make_discardable() warn
if it's not marked persistent, add variants of simple_unlink()/simple_rmdir()/
simple_recursive_removal()/locked_recursive_removal() that would *NOT* warn
and switch the handful of unconverted users to calling those", but...

By the end of series as posted that's down to nfsctl, rpc_pipe, securityfs,
configfs and apparmorfs.  The first 3 - because they used to have subseries
of their own in separate branches, with corresponding conversion commits
sitting on top of merges (#work.nfsctl is the last of those branches).
No real obstacle to moving them into the queue, I just wanted to post it
for review before we get to -rc7.

The remaining two (configfs and apparmor) are special enough to warrant private
copies of simple_{unlink,rmdir}().  So I'd rather have that in patch adding
the warning - simple_recursive_remove() wouldn't need a separate copy that
way at all.

configfs has a separate series untangling it, but that's a separate story -
that work goes back to 2018; I want to resurrect it, but I'm not mixing it
into this pile.

appramor is... special.  They've got locking of their own, completely broken and
interspersed with regular directory locks.  John Johansen, if I understood him
correctly, has some plans re fixing that, and I'm happy not to have analysis
of their locking on my plate.  _Maybe_ it will end up close enough to the usual
tree-in-dcache to switch to that stuff, but at the moment I'd rather open-code
simple_{unlink,rmdir} in aafs_remove() and leave it at that.

