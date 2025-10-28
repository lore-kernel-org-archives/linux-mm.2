Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54406CCF9EB
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03D388019C; Tue, 28 Oct 2025 13:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F306480199; Tue, 28 Oct 2025 13:45:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45B58019C; Tue, 28 Oct 2025 13:45:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1D2080199
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:45:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 838EF14052D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:45:54 +0000 (UTC)
X-FDA: 84048251028.18.55FCD0F
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC11DC000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:45:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=QUl6NIix;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673553;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2mGX18mZZPvHyD8tp/SlP21jzNUQaCksFfGjxcCZFG8=;
	b=XOt4l6qjdH0P4gbhnoMkbO005HCO2NFonyWvmtGGNfm65u7uIQWwjP5E+9cx709m4IsIyq
	Iup4Dh7BAHXn2vCs5H6isy1FHP3W7HGCLLIUXs/y286AIalqi0oaNlTE1tblAtwm5ivAWk
	LeLsiv4h9oHGvt6y5BE7mlEYFfFwZF0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=QUl6NIix;
	spf=none (imf10.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673553; a=rsa-sha256;
	cv=none;
	b=th74HrEdqwMcah/LfaKA8m/A74+PisrpSdNubaH5AJ+S3tpappApBEI/6EuDNmZQMapU/Y
	F85nzugjihtzsgj7iu7HMVmppZxsrq9phKpF6gcjm8Dup7ZDL/tuMFH8UI9Wc2g73xCMTT
	eckLnediISSCsXITAjYjp9vhGkeHh2U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2mGX18mZZPvHyD8tp/SlP21jzNUQaCksFfGjxcCZFG8=; b=QUl6NIixR/oJXVqt4B3YANU+NQ
	An/HOGXy/H+ZiEDYlQgRKgWKwvqssxz+gwDGLAME5GA/P7Qf6W6uPHxh6DWijCwvV4CcNYO/PXoT5
	YxZBFVCaU5Ea98ocoVf+/q91F1LwvtlAEGUyQ8O8zHEb4mZB0k+xjRSVz7F5gofV6A3RIqoPynnN9
	ezVcllUY59AGWdrRcZT+9Oh9asmURfIrTvNXHcX3TNV5V0uHjxp9Dz1RlWKoS/sBrDzfbCjA+ECAd
	RggfScej5M7Nnn6ExkwpClYDvlVq2rJMZSdhEkCYOdEy4KQyfIbMTYNy1dXL1QSfVewkCAh1tyQfP
	dUST2J4w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDnlM-00000008bgd-3GJA;
	Tue, 28 Oct 2025 17:45:40 +0000
Date: Tue, 28 Oct 2025 17:45:40 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org,
	brauner@kernel.org, jack@suse.cz, raven@themaw.net,
	miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, kees@kernel.org, rostedt@goodmis.org,
	gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251028174540.GN2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk>
 <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AC11DC000D
X-Stat-Signature: iz4jfa7nn1wgwrenkd5yu1pp64spawc9
X-Rspam-User: 
X-HE-Tag: 1761673552-306497
X-HE-Meta: U2FsdGVkX1/5cGXfSgJ+kx/fRUlefz1godJSyBYMPWw6qv+8DyJcJHNadBS91z39dmyAEt33GSy/zBk7K61373v8ppMwFUqlehy983uDb2SxLclusWW+ELXCEDtCydKeAguqdzcr3+dxxKWgODT/nkC36wTwrf5y8504NDOyNQwvxfZdSOBlCDALhDE9Fn3AX5QMYhIfrEqFz+eeA9XnY1WDDK22vFc2JmUGTq8yHLJHxSsAs7mSYHYExvQuJ9eiddDW3uBNiXicXibfQRsN8QE4meGWQR7ka80B/e42ak0XsyN5t0orRCOVQ0oGhG6dhPUZJuKn3JPYOukYfHUt1y7856+ln/mnwaXfD+7LUsDaSZ+s8GFtUFZ+d0a+XPpjxmz5SlLhO9lBZn6lo8vYXETv/jbJbNrHQGAfcJ1FUiiDd6vXZgpeM2GNvtBZOch0IJaCly3d+S/WXgxqTj0e0Kqf2L48JOJr16lqn8Q/mUbQhNfvd1kwo0dmg+mU/HQbughpgk2UnPvLuuUbXNgIP3gZPURb1zqBinjyjRl5uVswHo3/WIBDqupd+r4fgbd9mHeicKIbzNDIMHdKhB7mYafy3t14gzvGf2XziAN4TKdI13gXUzwOBOuLQ2/J+gU/8Fo2FvuV94QlvH7vLT+gB0cy43DKpU5DKVpypoqotpdvZPkQadO/wVd+6DKKnUAufIIfOflSkq5TsfTok++arvqFTbHZxQRnLZy/Wku9OGyEH64eXrZ0DNvqnPI5zR06jGc+szHFaGNKtWHx3vN+Hcd6ykyAWPiT9Ofd0Q3H4JjEZQfMk69bdNcy1uPhl9ryOtnvzZNt+4Sy9ZExerbiKXXBum4qPrCcGzVmeGqlgMVnDeyl9DbqR2atXsoqIrzSWfBkOaOL62ZZeIlgZRIcOUcyqNIbHJGAUhglwuu0vyvLBOFsNO0jF/0aAgr1dEVbT0AGTgHRwBvZA6WZ3Jm
 FItdzxlc
 gD4K5R6lKSM6N30IPDUMdWuwTUsXy7kVw+thCN3QKmoHNDKFggxFuwOO4xL+rwgQpM7kfuJfceNqYad3Trs+SOnOnjbt5dJODb9pCx2oEDBbTLoDagvUUlYrnoiafz3aBmIO+XQGD3gaCwPY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 08:53:45AM -0400, James Bottomley wrote:

> That dput looks misplaced in a creation routine and this is a common
> pattern in pseudo filesystems that either pre-populate the dentry state
> or create effectively unused dentries on other changes.  I know not
> every pseudo filesystem does this, but it did make me wonder if it
> should have it's own API, say d_create_persistent()?

That dput() is paired with efivarfs_alloc_dentry(); the real problem
here is different - efivarfs_create_dentry() relies upon the external
serialization.  Have it race with lookup (let alone unlink()) and
there's a lot of headache.

Most of the callers should be safe, but... I'm not sure that unfreeze
case can't run into trouble.

It might need to be fixed; I don't want to mix that with this series,
so I went for the minimal transformation here.  I suspect that we
ought to use simple_start_creating()/simple_done_creating() instead
of those efivarfs_alloc_dentry()/dput(), but I'll need to look at
the locking environments in all call chains ;-/

FWIW, having a special path for "we are in foofs_fill_super(), fuck
the locking - nobody's going to access it anyway" is not a great
idea, simply because the helpers tend to get reused on codepaths
where we can't cut corners that way.

It *may* be useful to grow a set of primitives for something like "we are
forming a detached tree, will splice it into the final position once we
are entirely done", and configfs might shed a lot of kludges if massaged
in that direction, but I'd rather see what configfs massage converges
to before settling on an API for that.

