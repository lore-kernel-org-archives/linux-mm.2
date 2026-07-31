Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C32E9C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 03:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F3E6B008A; Thu, 30 Jul 2026 23:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C0066B008C; Thu, 30 Jul 2026 23:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5AD6B0092; Thu, 30 Jul 2026 23:49:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 583A86B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 23:49:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3AE8CA02C4
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:49:35 +0000 (UTC)
X-FDA: 85047692310.06.222BBCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94EC41C0002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 03:49:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwTJNs5V;
	spf=pass (imf21.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785469773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8q+CEcjT0/iBfHUwPXNhK8ziLF4oFgSoOjKvD4YWaGY=;
	b=E648op7bpgGLDxOCjLJneij4D6CVIFsYJMh5MtwAcBAUr9R9+nSzHDqXhV1SLFrIb0yuJX
	uzWqr4p8Slt05WFzzUaH3gPDhgCxIa5WrakZwBcGkiUTfE00EOq5kuZ0h9yCRfe7tXCo7n
	EEfvHlOuHFP9oryiyS3AKARLyJvQyt4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785469773;
	b=OL9cAMhKNwEhdRsBvQv5LOo7zVRERNORe4dXDeO7CFv9BP5u+RWd1pl+tUTFQqvnKsQ5IN
	b4osh/5qeIAWf1FpjRLgZJiNTEgsb4gA3spfXjYzpPqp6LgqFvF8qkaO855nF/CDmp0zWY
	cePcsef9LtOj3uy8DUomGwffwSQ1Eck=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwTJNs5V;
	spf=pass (imf21.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 41A32419E8;
	Fri, 31 Jul 2026 03:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 166521F000E9;
	Fri, 31 Jul 2026 03:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785469772;
	bh=8q+CEcjT0/iBfHUwPXNhK8ziLF4oFgSoOjKvD4YWaGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FwTJNs5Vumh3CUVcguBi+5yKoJxMTtilqRiJuDvone6PZJcbDbmMEHpl1Z7iq9rsE
	 6k6RiSo6KxwvDvHKmoW45fM/wgMISyE14ExPq+sNfEPbTgtRwLqz4JlSImEA2+JbQ+
	 bB5t4T1gzwpajNR6w86Iy2wFmC20uaYQ3YAkkU5fR7ofK+oT+ZiO4N+dUCrW1pq2Bd
	 /EFi7S3O+giNTmCitLkwkXsMZiJeIiWcY+IxIZETcT+vzTTtYB+1qtNHpgZ0HiZnKd
	 RaWTtZIRvcAJWa1M24ky031D9SxNY31Y3NYwjtESZz8wkqq05zS8S2YE1ChAUZ7YqS
	 sN7F0nocCgRLg==
Date: Thu, 30 Jul 2026 20:49:31 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: reject swapon() on filesystem-level encrypted
 files
Message-ID: <20260731034931.GA3560112@frogsfrogsfrogs>
References: <20260730184853.48347-1-ebiggers@kernel.org>
 <20260730125327.11fc9227d04f659a59136cdd@linux-foundation.org>
 <20260730203003.GA2459987@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730203003.GA2459987@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 94EC41C0002
X-Stat-Signature: pn5n4rt915qzawrxtt1d97445zsiwj5f
X-Rspam-User: 
X-HE-Tag: 1785469773-958299
X-HE-Meta: U2FsdGVkX1+LD4taiWMiCiw+W5gXYm7Tzx0UEqEem7rWTTLlQV1hLyBVOWBJ1PpAgeVIQAIsqN8uqz46uz9HfVU9TwwdA4SGHlhTSv4BMQzbQMa4Ogc4ZR+I5QmTwS+FsL5FLDg8HEOOr1yetHKK4w3K1qSlZH2qUngowwp8AVi/WOJRP2YCk1cu/HL8Q1XKSC88RPIZMnN3pBwJ/ZinVSh9dKMlqszD8FtUgL2ds+ylQC4k68KwX5C3kHzzuN0Jh+tUV8l9NNOZtw9BaZAco4V4TPBjQxKR+AJbhESyaDz8/tfkqzUWjiaeE7f5L6zbDlRauOVHXQzqMjgyhZyvXC4+CiYnqSSn9jelmRBKN+4zOtpu7VHU9Cbyv/IZ0tMfYHv7Am02Vs6c+VutGsWLaEsVxrpN4kdHhHZgDeVVOQdpQmw+9EjwSetXRTcE2MxN45GxDdMfrapBYPVQPUCQxt9/RnXBsbzsJIRE31IBtXJ1dUf9lwcW/q1tPqo4nmp458jvpQfLU7wRzyOWVHn6Ej9mvjtcvWcaSw5X338IzAGQDNE5skz1TDJK+2lQDftPM/2aEpG9iaTjpaY3Z/UBhG9+NMqgcX/igZUG6+22G/O2SN8ceB7F8o0d4Lk82UgTIEk7JSGgkusLwioLASm1PZTQAb1JyuRZGepncszaI0VhYITTkg1fDV8M3E5A/e9ohenh6KiurucGiSQZTsJZl47I9v3JbbixgC8f0dSwRB5x1yBR9ywwSdd/93ctRdmPEGX0Swu/roKSyf6wsmhHUN9CPMwGgx1fCt/1iyN0ZHTHs2h1XQFCJxU6N7Jd1IsWRdBB1GA0qF5DBvK+C9CZT1N0PkUWtz9o26nV9qjiQXBqJW4ARvlrI7Id34j4YmDGBpAo8DftXdBWpP49Laydv3zNdiPVfpEgkVqh3ns88az3oDtI135T6mGvKf9ec4booAEODA7nQVEaL9RZln4
 TcxyfP5d
 AyZfbQcMv9KGF24Dcz+yuyyFbxsjVaQFWFHhGaar88knHeoBLicf/ebrcixHY+5AjAfa4Isgbl0hrkCwEiZ+1J8QTMk0l0HSeHLVmN/YAeISmZ7wgr2nH4X0LTSHS/lGDGsGCQljoTVQDhJohT4Y3pnNps5MIALJTBGfv2HfCt18w8ptoQ9fsrom0DA4X/JPL957PheeWKoJyvnvHSvDIzAO0615X4P3K3qDAtJSGb+K82Lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 08:30:03PM +0000, Eric Biggers wrote:
> On Thu, Jul 30, 2026 at 12:53:27PM -0700, Andrew Morton wrote:
> > On Thu, 30 Jul 2026 11:48:53 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> > 
> > > ext4 and f2fs don't prevent filesystem-level encrypted files from being
> > > set up directly as swap files.  In this case, encryption is bypassed.
> > > 
> > > No one should be doing this, vs. the methods of encrypted swap that
> > > actually do work (such as swapping to a dm-crypt device, or swapping to
> > > a loopback device on top of a filesystem-level encrypted file).
> > > 
> > > Nevertheless, to prevent user error, make swapon() explicitly reject
> > > this case.  Document this behavior in fscrypt.rst as well.
> > > 
> > > Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> > > Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
> > 
> > Ouch.  We are going to break ten year old setups?  I don't think we can
> > do this!
> 
> That assumes anyone is actually depending on this bug, which they
> probably aren't.  Encrypted swap is done in other ways.

Hmm.  swapon() seems to read the swapfile header via read_mapping_folio,
which means that fscrypt will read the encrypted block 0, decrypt it,
and hand the mm a valid swapfile header, right?

For blockdev filesystem, the setup_swap_extents code will set up a file
range -> LBA mapping, and the swap code issues bios directly to the
bdev.  Ondisk contents aren't encrypted, and read()ing the swapfile will
produce garbage because we're decrypting something that isn't encrypted.

So I guess the bug here is that the ondisk swapfile contents aren't
encrypted?  Can we fix the swap code to call fscrypt_set_bio_crypt_ctx?

Though, you probably don't want anyone to read the non-header swapfile
contents, so can one create an ephemeral encryption key for the swap
code?  Or do you not want crypto engines in the swap path?

(Apologies for my unfiltered idiot thoughts :P)

--D

> 
> > I think the best we can do is to emit loud warnings which point the
> > operator to some Documentation/ which tells operator that this
> > deprecated configuration will be disallowed in, umm, 2029.
> 
> ... and if they are, they'll want to fix it right away anyway, not in
> 2029.
> 
> Other fixes to explicitly disallow swapfile activation in various cases
> have been merged without a deprecation period, e.g. 36e4d95891ed,
> 377eeaa8e11f, 51cc3a6620a6, d15cab975459.
> 
> I think we should try just doing this instead of dragging it out over
> several years.
> 
> - Eric
> 

