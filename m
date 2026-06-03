Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06626CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 20:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A66C6B00AF; Wed,  3 Jun 2026 16:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E3E6B00B0; Wed,  3 Jun 2026 16:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4940D6B00B1; Wed,  3 Jun 2026 16:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 380FD6B00AF
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 16:00:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D733A1C1D7B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:00:02 +0000 (UTC)
X-FDA: 84839667444.14.650F79B
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id B043818000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 20:00:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=X4kisSvI;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780516800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLwU6+VwyCgHprpb82bpoZ1vCU00viaTeQ4mjhQKQr0=;
	b=VTJkuxIuf08NaeuV24t4Ih5u0Eh1z5GW4XPvu8r3VnEJKglijCijmzkD/HCC2PYCQaTfRV
	zd6C4Gc5C+13l/TeuJy3Ze83QjvAw6K6XAnYCohwTehWRW2h0fEgMAf8/VJs1XCQipYIvG
	Wm//KZIvfiHLmae2kypRGNq8rDi1PC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780516800;
	b=3JPLKsVdqFqo9loctEvJrVu/TU4HvRVe5y5H6nWcccWbW6Mksa/4VjSItVi4tgeMwJ/qMu
	Nbho/jjXFz4hO4rLt8/LmPHbPW2fhMJMIIiiy9CrYRczBfailf7RcnVt33/KNR9H6j6SnS
	VF3M6SqAKDEUSm1ek++lRSa2NXSrod4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=X4kisSvI;
	spf=pass (imf16.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.214.178 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c0c3543590so29990505ad.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 13:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780516799; x=1781121599; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rLwU6+VwyCgHprpb82bpoZ1vCU00viaTeQ4mjhQKQr0=;
        b=X4kisSvISDNvyDCPRqvDhQiA9Xc2ymhIV+tQdnOc1n7Pch92bviKMqgr6XklCbIGPE
         4jrgSAewYUig9Z8t9MITlgJJ688YQ9WTTkhyKyJaSA+QH04JU6F3EFywwSDeI6bQhSSM
         UCsXyKvk4jUeANOGfoWgJ0GMquohlGGEUxBO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780516799; x=1781121599;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLwU6+VwyCgHprpb82bpoZ1vCU00viaTeQ4mjhQKQr0=;
        b=svuK+/fChC/6FvPYsnmJbTrrxJs0JUghvBOCanOQQt4HLkw7BcaHQd1KvTqiTNbOtU
         bU5S3aolMl1t2muRFFEfsL+5vXHunLVfj8+T3Z0V5xmKkYUsPzD1wGMYKUFn+DELzItm
         y28qaESi+qZq+IW9JjiurzOctGL+RiGZvqTPI4S9WBCL8FWQy+Mv/YT8J/MOnLyZf50l
         VO63w+TmlTWPlmRo6KkzHdgk5ZLSW3rBfqmp7S87BT9a+hEufTGrbICLPgcl+pIU3XFH
         X5qizmAxAVtuRkkTu24ca7Niw3Ql0ozfOvdlQhrxlQXv9yK76muRRI4y0XoIHuDmQJWt
         K31A==
X-Forwarded-Encrypted: i=1; AFNElJ96DusHj6NutL1NRJHtDkZN8rVJXZBLStBI7Rf9fG0yFuZyFSmJ0Wim1cs/Lz1WfnXLTh8eKyID9w==@kvack.org
X-Gm-Message-State: AOJu0Yy1OItwOia5tS5otsPjzZ+91lQ9bqI2WWLyB2x+NSA0Kcat6lfv
	wloswdmMiPzfzcjRk0A2GG4nQw7AtcbXy3uZeKf9+Xq3NEydnwzS8EvAw9QutvIW9OrW930lizl
	vqoGbQ32CiQ==
X-Gm-Gg: Acq92OFp4nkuZbvDztdxz6bigWMfr/pVO7REK4dvQhaY2R4J06qDQzFuOS6BzkbKXcp
	cMUOarhy/sR+r1xgSQTBtwci6VNvIJMGo7Bv0+yMCrZP8tC18HZmJRKS5NWKCLb4D/gnvENgq7D
	xoyE2839xtNLNJ/KGtBeVFfP4gOC5ovOslMkfdilWEv3LQGJSpWHzZslQt7UBxN66wynrkOI+Cr
	41+glbnM3u5Kaerh6eFeCIi9leG9fsKoFgHjPJAGbCpD0/GCn4AHpE83H6NbfqhvfVGgDhIt9dH
	8Grn+aj/6de/66MYm6hhJiKqjRy6+2tbrlxg6drVHIbPkO8P/EUSdu91sY+fZ01PGnlurDH4Uq7
	CgmAI2yvVDAVmZ14SUVBRAYCMuOot7ieamLiXyWWCYM5BJhsvtoCI/UIf39bE5AuPMuQSLT3tuA
	K6G9YQ6elcMt7F8AiBljqNP78ix1NShCcPBn5bcmDUH1h7LUPrYUyTsLLmLG2DPctmtwlep61W8
	6lDFvtXinU=
X-Received: by 2002:a17:903:b8d:b0:2c0:bcff:e197 with SMTP id d9443c01a7336-2c1644ca3a7mr48942505ad.39.1780516799299;
        Wed, 03 Jun 2026 12:59:59 -0700 (PDT)
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com. [209.85.216.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f70660sm33831495ad.11.2026.06.03.12.59.58
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 12:59:58 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-36b8e1760ccso3901651a91.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 12:59:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/h0j2URfcUT6+ZQbp42gSq0pfoD3IwHRr0YxLW0dZ9mVKgxbG+bvJHChcMZrteR/6j12UJTr6NLg==@kvack.org
X-Received: by 2002:a17:90b:2f86:b0:36b:77b9:5c8c with SMTP id
 98e67ed59e1d1-36e3237e125mr4484034a91.17.1780516797989; Wed, 03 Jun 2026
 12:59:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
 <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
 <CALCETrXzxubt4eWue3+wv7Fq9C2m7uu6bWPstqFh6Mo57bPwQQ@mail.gmail.com> <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
In-Reply-To: <CAHk-=wiEwSjfbjfO74xu=UmkkdHXkJg5QNQ8pP-3iYmunmeV9g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jun 2026 12:59:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=whkGbMoP-Dym8pAd3hV21=BZST+6sK++1X038+9Q-TgeA@mail.gmail.com>
X-Gm-Features: AVHnY4Jw9pwWVUIawcRWYEJbSOr_4eFJHRjDI61fxjs_qgnMfY70yBDODQXhxd4
Message-ID: <CAHk-=whkGbMoP-Dym8pAd3hV21=BZST+6sK++1X038+9Q-TgeA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Andy Lutomirski <luto@amacapital.net>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B043818000F
X-Rspam-User: 
X-Stat-Signature: bkw583y4hdfhi5qhtkj99pdq9cogeuji
X-Rspamd-Server: rspam08
X-HE-Tag: 1780516800-546492
X-HE-Meta: U2FsdGVkX198KEjg+Hj4lDOTheIEEh6/LfAeOmwspDcLS1FKlGtcuwJwcMTyHPZHxig/WpitJkrDC9gcfYa5HmPIgz0hSfAlsUxyozXLnmK+TKtSzJVxvyyWCvoTJ7dWchqnEsDpMo0AT4oY/wdD4qEnDuC0fwo2L91MBDFBc+4g/QFwUSRMc8qaS5wCtxb+n3lNLzZm9lm5wFt4ZE51TW/oq9hXekRFvEGpEFzkl9uslFu1ZkIU3fy2aCYBsrmU2KWNgBXxDyK3+IVxZ8r2IbRnU1yCuAEUeTTvMVeXfagAZ9Bq7CYIENTlzIBS4XNr9Wg+j7Zk2WfguZqfrB8OkW5yiI7ujwKyeVBdSr0jr47tNrYWTrpD+HonYuCJYTAL1NYLvL631TEErHCZAucc83/0s5gWT8QYHLs5z1QOsDNIHksRz4S/btci2ti20tbLn6jTmqgK+YynqDxIoe55hsIKkbZ4dndNipDdyXc8RnbvRbfxqlJQ0CJ8Ypw7kNTqX2WPmYUMz9GFAXLeuukEqgTZGSgefzDRVsfdr2gESKxbnycrttbVu/c/rw+pwwPfDmZWYP6sQp40hu/Usfbhso6TikeffnAJh1wMMigQoTUK8V6dJJadXD0iW/+dnzl7cKKbBJKfe1CA7bFONL7mSFF7G5LspRpJ2RuqTWx/a9McxWF/ISsAGqVBPdGcmRZe+XnDrUGQsvchdXRQkc7JITiYaYDKKoNPzaUYu27LPtyTXW/orHPANRWVSRhUFbHjX65RCUO9ZXqbGJAGaLGddLbSp8INDTDaMl3X2MrBZ0zuAkI7s3J8cbY4Ag5TzccLgIFCYdLs+Ce54u58YCDNQjC/lg87cTMpy/Q0MbaM0MN9FIXWgBp+MAx7F6eUXO1I5CFK63xc60JbJoTncU29qbV+bViQ1QIQ/MNMqHvYVLVm1/y20b6yGjSxIymNdq+5oxpefysn6d7ApK94BWt
 xm61xuvH
 2n1FVlIiAUi4tMDtcpniAYTqAZxaNMcfM/3hxZzbSxU+TdVyhetgX40MnIRBQUDUvecEPJlCMtNFU75KDwF7jRWWMGcznip+IZeRnqoRY7UvP23f917iNPHmIu9bj3Ubbww631saUOYqZocGgzAUPFyMiJ4XG0HarCEKrt3xShkhbTR2b+x/LgLuBnN4yY6CZ81z/VC56cZGM3VGiMS09KnFRRu9I8JxIKBeRpH6qL8THyqPU82tgjdyfbwTUapgUTQTwOnQOkX6Jo1w25xNJVb2qlqxM6VMdVldgEjSdEO17MxacmVjc2qdPTgCGARfA5UCEyotEd5ljXKG2ooeYSEg0cF8MFuOLNFS7K5ks8mNxj/9BeOMgxQrX0/5+o1/t6dzIwAlJCe/dsI0vD+YvnOfA3H5eK2IOud2eF/8EQlo+J5w220VlX/tlnnUPUtOlI1Rzo50hIDwH6AYS5n1tgQhN5zmVh6SV4NIdyLU7227x/c+6j+njf+TRUTjTUoZT+aIBPT/86egJqum01dRd1RnqBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 11:28, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But even then you need to have a *handle* to the buffers for the
> general case, and that's what the pipe fd ends up then still
> effectively being.

Again: for sendfile, you don't need the handle, because you can just
"read the file data again".

But the the handle is needed for any buffering that can't do that -
iow pretty much *any* other case than a file-backed source.

So the original use-cases included things like copying media data from
a TV capture card to a GPU for outputting in a window.

There it's actually the intermediate buffer that is the important
thing, and it needs to have a lifetime that is independent of the
system call itself, because the system call may be interrupted by
signals etc, and you can't just "read the data again" when you
restart.

So the whole idea with splice() is that you have an input, an output,
and a stateful buffer between the two that has a lifetime.

Having just a iov_iter isn't enough - even with the current much more
capable iov_iter we have now (compared to when splice came to be: two
decades ago when the modern iov_iter didn't even exist). You have to
have that notion of a buffer with a lifetime.

(iov_iter came a couple of years later, but it then took many many
years for it to become the powerful thing it is today where you can
put almost arbitrary data into it - it started as purely a user space
iovec iterator, all the bvec/kvec etc stuff that you need for IO
buffering came a decade later)

So there's historical reasons for the use of pipes, but there really
is a very fundamental reason for it too: wanting to *generic* data
transfer between two points, not sendfile.

It's worth noticing that in the generic case, zero-copy isn't really
even an issue.

When you think operations like "splice TV capture input to a pipe",
you typically need to allocate the pages that you then DMA into
*anyway*, and you'd just put those pages into the pipe. And the facty
that you can then just take the data directly from those pages when
you splice from the pipe to whatever GPU engine that does the decoding
is kind of secondary.

So again: the big deal with splice() and the pipe isn't really about
zero-copy. It's the in-kernel buffers where the drivers control the
allocation and you don't have some "user space allocates memory, then
kernel looks that allocation up and uses it" model.

Having less copies is kind of incidental. It *might* happen just
because it's natural when some streaming device just gives it data
away and doesn't care after the fact.

The problem with splicing from a file has been exactly the fact that
it's *not* streaming data, and the filesystem zero-copy case gave
direct access to the long-term cache.

Which is undoubtedly good for performance. But it fundamentally
*requires* that the sink is trustworthy. Which has been problematic.

That's why sendfile() is bad. Not because splice itself is a bad
concept, but because you have to have that absolute trust across
components.

          Linus

