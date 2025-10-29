Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2410DCCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 19:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A6A8E00E2; Wed, 29 Oct 2025 15:38:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94AAC8E00B2; Wed, 29 Oct 2025 15:38:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8395E8E00E2; Wed, 29 Oct 2025 15:38:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 701848E00B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 15:38:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 18248140912
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:38:07 +0000 (UTC)
X-FDA: 84052162614.06.3C60256
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 366F3A0011
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 19:38:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gDSHktUU;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761766685;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3wlz2ynSn5ZcGy2srCWEEseivI55gIJnD+HtUPEfxA=;
	b=nsxYfQKg6EYbQRwGZiV3x+3tarPizDLR4faFDHd5KhmwEGwWSA9qiVWHldA27dPtfNT79l
	ZHcJTh8iC2Nz53vMWW1524QyTOV7tTBjCQw63uFJyo2WiSR8WaHW64kkudHuNrkUgcJi2F
	KHN0YscNXSpSwDgr9W7PNwVNxIuhK44=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761766685; a=rsa-sha256;
	cv=none;
	b=olrRpOTc8DbY5/SNXl19ajMC/mfOaLIkiBXRo50eiVwoGr0MGs/3ye5x/Z1KVkvLTr53/n
	HxWP+15G3Z2CGOsXFCbPSG6G8oRZGpUuZF4FnFo7PYS2EzRguMYZBtgIIdbQHO0XRr/emn
	/p1QknqE6CNICLwmQI8ZbQFVQsXtCzM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=gDSHktUU;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O3wlz2ynSn5ZcGy2srCWEEseivI55gIJnD+HtUPEfxA=; b=gDSHktUU6QTsq14G2ZkRn8yePC
	Hzq86cB27L7IDzGmOQ4PgkSiy9xgLfqMgADtMr8DuQqi7m4vB89lz3p+i2NioSQejhH+ZWejmhFny
	5XVnwBvWfeQ4w+DXrBuHtoCWeJpnyp/cRQueiFSYZ2b2I/SZQBRaX7mJNGimhQ9z/QJ3yeRd/s4hb
	58tfvD0mBPxhhc9IfMUHEJ4XM9ximHRwZSuicgtApVI7x/xzSuXRM6l4w07JDKHJUXYpLQIfRUg09
	LpsQni2Q57A0tvpzbusesVftkmD+D02YP3tvEx7+qUqYRvQUcN6KIwG4Ua4Lk/WdekYsnfegMon4+
	NiV/QXvA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vEBzX-0000000F3m8-31yx;
	Wed, 29 Oct 2025 19:37:55 +0000
Date: Wed, 29 Oct 2025 19:37:55 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org, paul@paul-moore.com,
	casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com, selinux@vger.kernel.org,
	borntraeger@linux.ibm.com, bpf@vger.kernel.org
Subject: Re: [PATCH v2 22/50] convert efivarfs
Message-ID: <20251029193755.GU2441659@ZenIV>
References: <20251028004614.393374-1-viro@zeniv.linux.org.uk>
 <20251028004614.393374-23-viro@zeniv.linux.org.uk>
 <66300d81c5e127e3bca8c6c4d997da386b142004.camel@HansenPartnership.com>
 <20251028174540.GN2441659@ZenIV>
 <20251028210805.GP2441659@ZenIV>
 <CAMj1kXF6tvg6+CL_1x7h0HK1PoSGtxDjc0LQ1abGQBd5qrbffg@mail.gmail.com>
 <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f079d0c8cffb150c0decb673a12bfe1b835efc9.camel@HansenPartnership.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: ajnf1s4xy18zfkpriyt88z1wirf8q8a5
X-Rspam-User: 
X-Rspamd-Queue-Id: 366F3A0011
X-HE-Tag: 1761766684-169179
X-HE-Meta: U2FsdGVkX1+BKabNpjZjQS1qnwtJAKFRCJAw/c+WV9z8rWwbHFWqx4et18GqmaPG24hEiEc56XCiRqIOwCAeLUJECegIg67DpECnyqguz7HObuB5wgmlPehUCBectjUJUStO+UhfhoouW3EjHElStAo7PWsjyh4Peq83LmMKfkn/4Tg+/brZGeh3NsH9bppgykJ4YKqkLcNLl2wHEFA8NJakhZXlu61y4snNuGSfTi9FBvfOHOfi3/IL/I19xYQxY1+WqduaE3zaYi0X4+xnTCNYMDDIXZUvM8EG/fceilF26650JT3WKyY/FwMffKdNmUGZZ87oo7q4WYN3/4ofsqRgGxZk83ZkLVJLoDmQB2tscporH0dGjm9He17YQ/Sf910YZAlo3WqwVcqAplaBzxHztpBfFQDx+If6+Oj/LiYZqMoZHzGnANQBxy95XYNRfquOmjQl5UI3rECNAOUMXOUoxezvDDRDoOwomus7IUMzJLRIurUxxiSTMP3FP8cRNHhtKXTNZWxlTTOguE1kaEruIQNXxtg1JhwlG1yHaiWYvEWPVEGCSqsJhudc1rgWcJJEcKoP8DxNrINUSLCpsBzVzsKu2zFIEzFcNs25SWZcYkpsUG8WlTT31rGGq87zb5ANGQp2hosQkT8tWCh9EbR6Zsk7a6hmWoiUhaENHu9aTpfvNWZLQvnOUVAT7gk7sTeq2r4h71izYiuopSyQIKKJTgdGCOpOsDz04b5MTVJyiTB04H8H+BT2kkHbOpbiC6AdGkQvRddUzqcI6XOLj5cNqHNoAvSwrdehX/gttMcpNv1NBuTT3LRcds+ebZClPJjekzGCMziDYyeVem2H7hZkwgrKf10ANhWviXOMzc4CLszJaeo1HmiPiVCTTf/Feg47DeoLPiTcqAN5D/xAibc0+c+eaaNXdeTEHjgseONBGbphBloz+BSaDsJ+mKIOuAVb34ztu7C8P6uK3/w
 6TrXOnH+
 w+fKun//qi0kafhOmuEhB5fYpXj2UVogCjn2+mUyLkOzbxn81acQokTcyDpnPx+/0MHHQtMxosefYwLzFQMBtycLL3jZobodTZOI9pDXXyjSDhHzpP5r7V14pDixi6TcgqJaiGeCqZ52/ejk7IPzwYRagHNGKYQeHWOfTWgMwZBQa7b/8YcrwBqguRpIqtHVfK7ambJyRCyiyXgrGitfDIbVRTpHW6evuKBhiwPAL1jlFQ7Ta7IC8PGPjxQaiLB+5g2uiH+GBBxAYkcDyPVzowlbT+KPITjyi/gGjf8TaSiQlSQOn9SYktdZAfuaR8HxrYZn7h6shZ/yv1SfrM3m5PYBOl44VBTehw2f8qn9tt2yBP4MZjNRahD0Sb7C60ttuJ974mB6MuRWtiPY9RXlj+gVWR2NNu0D/c6/G7rofegdf0nmZrj8FKPeKo07807eaTg8jEuiWqRthAThumaHRIvy0mQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 02:57:51PM -0400, James Bottomley wrote:

> I think this all looks OK.  The reason for the convolution is that
> simple_start/done_creating() didn't exist when I did the conversion ...
> although if they had, I'm not sure I'd have thought of reworking
> efivarfs_create_dentry to use them.  I tried to update some redundant
> bits, but it wasn't the focus of what I was trying to fix.
> 
> So I think the cleanup works and looks nice.
> 
> > 
> > Relying on the -EEXIST return value to detect duplicates, and
> > combining the two callbacks seem like neat optimizations to me, so
> > 
> > Acked-by: Ard Biesheuvel <ardb@kernel.org>
> > 
> > but I have to confess I am slightly out of my depth when it comes to
> > VFS stuff.
> 
> Yes, ack too.

	Umm...  FWIW, I've got a few more followups on top of that (see
#untested.efivarfs, current head at 36051c773015).  Not sure what would
be the best way to deal with that stuff - I hope to get the main series
stabilized and merged in the coming window.  Right now I'm collecting
feedback (acked-by, etc.), and there's a couple of outright bugfixes
in front of the series, so I'd expect at least a rebase to -rc4...

Hell knows - one variant would be a never-rebased branch containing
the introduction of simple_done_creating() + variant of efivarfs
patch (as posted) ported on top of that (with d_instantiate()+dget() in
place of d_make_persistent()), then have both #work.persistency and
efivarfs followups pulling that branch...  Or I could simply hold them
back until the next cycle.  Up to you - the main series is what I really
want to get out of the way ASAP, especially considering the potential for
conflicts with the stuff Neil Brown is playing with.

