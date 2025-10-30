Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06A4DCCF9FC
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 13:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685008E01CC; Thu, 30 Oct 2025 09:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635298E007D; Thu, 30 Oct 2025 09:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5727F8E01CC; Thu, 30 Oct 2025 09:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45F168E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:36:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D58A9B5EB6
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:36:07 +0000 (UTC)
X-FDA: 84054879174.11.C79286B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 129ED4000D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:36:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mo4w8M+z;
	spf=pass (imf07.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761831366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xhRXZRwTf8Wfm4C/x1JXmtSa/La+hRIdRb6fxoCgqmI=;
	b=iS8S++7TuEbBra1+Hjhg4fEP64Sfw6kAAiJXuhaHGJQ8Lo39wDpusLOtaVy4u3K7L4Rtd7
	oEwTLl+iw86Q64AlwX2Jbonhdf9vq+Sujaq0ScTQg0qweHfxnyiQh1SDL2rX4Jb/CcKX4+
	cCDlpXqkj8OFiIJ+1hNbCGOzATU66UU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mo4w8M+z;
	spf=pass (imf07.hostedemail.com: domain of ardb@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ardb@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761831366; a=rsa-sha256;
	cv=none;
	b=noxVZ6CHTdAPvcLTIfcPmTetJv/9SF8b6O/lOrVSks34h7cBYX1BlnPSf6FaEsW3CSwZk8
	kDOBciyHjWoowAVDhFF517YOyk0n+t6e4l4gZwxhUO8ZUlsbPqlCQSc2oq42b52Gf9upCo
	T+0qjhcJ7KKMzhY/nzLGI4xIPhpiyj4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD6DF45C4A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C388DC116B1
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761831364;
	bh=946tCSyfwkcJEZIYbJYPYmAWxgbWBFpGqs507Chemqs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Mo4w8M+zoG7x4VSKBHFBlkcNbJr8yuOPcibcxBBGoKKL/xxYP6SoTzLLo4MNs3B3W
	 LXBRGiqiBcuymn4pvOVdEzE+RhAUAEeSzEzaMVgkWQfQdcCqM8chFRdyPlB8uyQjhI
	 Sy04DC7qmGww/ewmG6nPtqVrjY2mNjujRFnNwL7bqfm0FwXXsFy8N/4MjZzNCTEKM6
	 AH9cxSZFPyaoQjhLwB8gKrOvY8VBqCrViJzhsfAiHRlbe8Pd48ohtXcde5WYc+J+Ks
	 xtnvYufRNIqRkyzqUNQQ8FGGMaRxPzAYxs8fhTOpNjbPwsbTzNyqAjyH/iSW6qfl8l
	 9rr9LsibKVXjw==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-378d65d8184so13777581fa.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:36:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUv2bmMdKQcDKmtozXe61W9FXho1X/7N1fjA2UVSv62L7TKdXjbQhqfn0V72ulayEdS+XM2uxSGMA==@kvack.org
X-Gm-Message-State: AOJu0YyhW0QrQ6flSL/XCkFW7MOvpsnoJ7/beN/0CpBOG3DF7J+PCq4D
	HDUR+sfKvJr+ioe3ECRsfYAmIRwTQXLmeQsYMnCbN2lfBJjgDDwHSjoOr965xnSD4o1VHbk3H3B
	28dDl8lF4K64jgptECLoZvk5zJJGKNnY=
X-Google-Smtp-Source: AGHT+IHPsQ63GACF+WTAXoqOco8sKMg1RRh6aHz0Br4Fnz15qbhOtOELzGrlJEWp65H1oXl/2WnpIpMcc/ndPgk67GM=
X-Received: by 2002:a2e:9e56:0:b0:376:30c5:66ef with SMTP id
 38308e7fff4ca-37a1094a526mr7884761fa.16.1761831362808; Thu, 30 Oct 2025
 06:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk> <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV> <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com> <20251029193755.GU2441659@ZenIV>
In-Reply-To: <20251029193755.GU2441659@ZenIV>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Thu, 30 Oct 2025 14:35:51 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
X-Gm-Features: AWmQ_bm2LrdVSSm_iuRDZ6ti_gfIvNqTw5CQZuyqzyGspRRRkaM_-X7LCT9AH9Q
Message-ID: <CAMj1kXHnEq97bzt-C=zKJdV3BK3EDJCPz3Pfyk52p2735-4wFA@mail.gmail.com>
Subject: Re: [PATCH v2 22/50] convert efivarfs
To: Al Viro <viro@zeniv.linux.org.uk>, 
	James Bottomley <james.bottomley@hansenpartnership.com>, brauner@kernel.org
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, jack@suse.cz, 
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name, a.hindborg@kernel.org, 
	linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, 
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org, 
	linux-usb@vger.kernel.org, paul@paul-moore.com, casey@schaufler-ca.com, 
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com, 
	selinux@vger.kernel.org, borntraeger@linux.ibm.com, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 129ED4000D
X-Stat-Signature: gykmjhzfmiidi3rk6k1d1rc13dxzu94j
X-Rspam-User: 
X-HE-Tag: 1761831365-836098
X-HE-Meta: U2FsdGVkX19RU6vE/dwBV1KoL4KsFO+QNABg1u4Q1NDIXOwmpJTLFvBmUTk9AxVlVztvzucF9F6u4C32SXeoH0kEGt/SxHhOdS3ZK0t1gHA/yy3K+h9YGqykE/6PvEyFeI2LI+HoAZBHG3farrekQTVUo6iWIwSzKmm4nppE/EtIQcggyrEnADP1kTlYrJWXfwE/anZosJfszeCdjeZavwDF1Sn3OAzjSLFR8quysuM4D+hSMlxPnccgN38ZRRqJRh7LHDvNg5O5TzhKP4u3NCnmLjKhf27Q7A3g07Q4bJKlPFpMjl/YTUaIXOAu9q8DF1Kp2otvxTPYaRnxHq0l4p1fVOXSeC0dk3B+VgCwE3EbqQt4g4RspSvh//GA37nrUAWGug2jV6hRfQdo0LNgUZgbhVgCXM7794CN+OX9LI+AyDCHZOkRh097IJtvSsPPG64yeUCTDbCyTVv+YalreYCZTBYySe7lPZFsrCmhf7pro3hDql8sxwEzNhyQli7T3pss+89JgZJyWN8CDB8KS9kcZUEqMqOhIEm2UYmXdXS6SXKf94JJDI7QCLBSyFNSZ/b6F97ERXm2mix9zEVO6LMHrc8cu56kktktMl4+ovnhDgwF1JrnEIAkgD2BWtvXyzVvezVYz4U/YtVpRdAKdKOYxn3q+6sTx1++HZ8TlLcAfludRcODqbGkWRYPsskaX47UdRYQLBZeYZaMW8dNi/m+Qupr0yq+XVRtCBiaMq1SgUTtFb0mCxRlvpP8M2D64upU9NZg8QRLAGR+AxQTLonE3MfM3SLZs5Y69L7bguALcCPPRqAc9a3sK7vgBgXSfdihfKic/j0diiLjJL6/KTFFi7RWO89hL2iN/MtYsK6HhQ/GBaWmwoAztKfqnt//Yv0o+UgZPJijNsyAW0RZFGjDSYVYbKi/9FuQ/9TmMCMeRWbaeLYFZDxN23INrPCyiu6tlPs1w2PPdv1riLC
 OeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 at 20:38, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Wed, Oct 29, 2025 at 02:57:51PM -0400, James Bottomley wrote:
>
> > I think this all looks OK.  The reason for the convolution is that
> > simple_start/done_creating() didn't exist when I did the conversion ...
> > although if they had, I'm not sure I'd have thought of reworking
> > efivarfs_create_dentry to use them.  I tried to update some redundant
> > bits, but it wasn't the focus of what I was trying to fix.
> >
> > So I think the cleanup works and looks nice.
> >
> > >
> > > Relying on the -EEXIST return value to detect duplicates, and
> > > combining the two callbacks seem like neat optimizations to me, so
> > >
> > > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > >
> > > but I have to confess I am slightly out of my depth when it comes to
> > > VFS stuff.
> >
> > Yes, ack too.
>
>         Umm...  FWIW, I've got a few more followups on top of that (see
> #untested.efivarfs, current head at 36051c773015).  Not sure what would
> be the best way to deal with that stuff - I hope to get the main series
> stabilized and merged in the coming window.  Right now I'm collecting
> feedback (acked-by, etc.), and there's a couple of outright bugfixes
> in front of the series, so I'd expect at least a rebase to -rc4...
>

I pulled your code and tried to test it. It works fine for the
ordinary case, but only now I realized that commit

commit 0e4f9483959b785f65a36120bb0e4cf1407e492c
Author: Christian Brauner <brauner@kernel.org>
Date:   Mon Mar 31 14:42:12 2025 +0200

    efivarfs: support freeze/thaw

actually broke James's implementation of the post-resume sync with the
underlying variable store.

So I wonder what the point is of all this complexity if it does not
work for the use case where it is the most important, i.e., resume
from hibernation, where the system goes through an ordinary cold boot
and so the EFI variable store may have gotten out of sync with the
hibernated kernel's view of it.

If no freeze/thaw support in the suspend/resume path is forthcoming,
would it be better to just revert that change? That would badly
conflict with your changes, though, so I'd like to resolve this before
going further down this path.


I did need to apply a fixup to get the revert to compile:

--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -412,8 +412,7 @@
 {
        unsigned long size;
        struct efivarfs_ctx *ectx = container_of(ctx, struct efivarfs_ctx, ctx);
-       struct qstr qstr = { .name = name, .len = len };
-       struct dentry *dentry = d_hash_and_lookup(ectx->sb->s_root, &qstr);
+       struct dentry *dentry = try_lookup_noperm(&QSTR_LEN(name,
len), ectx->sb->s_root);
        struct inode *inode;
        struct efivar_entry *entry;
        int err;

