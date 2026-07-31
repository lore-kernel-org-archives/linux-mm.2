Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DB79C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 04:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315786B0088; Fri, 31 Jul 2026 00:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C68A6B008A; Fri, 31 Jul 2026 00:06:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 190FC6B008C; Fri, 31 Jul 2026 00:06:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E45296B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 00:06:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B989A152D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:06:37 +0000 (UTC)
X-FDA: 85047735234.12.96E1DF3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D85BDA0003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 04:06:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7B+fjjE;
	spf=pass (imf25.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785470795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fn6R3CY2DDXWCXfEF8whxcR7qeoOx35W3rFoVjeg1R4=;
	b=XBiic+GENtlSNn+kMD9LmqnTMCmnc3hM+IwEZ6ZMihBNsu8gF7GvCr/rfNsaYv1wnfY5W/
	3gipQx7R3/7JFfCfXFpmyegC7e56t8O+fjixRqXcHTewEBBsUlrxuRJiR8d5DHN0qseJaO
	yJ3YEvkmM6mUamQao7nvsdsrS2Nihww=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785470795;
	b=wfwwguhPtgOtJ7al/GXsiC+NJTAbaPvhibq2DkZGJAqrJi5m9gH5V6KaZwJhh1zk/ljI23
	6N1hCniihxl1BIHVOcW9XPOX4g33AzVWgezTf6Wgnam/NaptLfgBDygNOcT0+uxYkfUvP+
	g6jy25SmoiyQJgLsCTv6tW7Mx47RWUQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7B+fjjE;
	spf=pass (imf25.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B45D5600C8;
	Fri, 31 Jul 2026 04:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F261F000E9;
	Fri, 31 Jul 2026 04:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785470794;
	bh=fn6R3CY2DDXWCXfEF8whxcR7qeoOx35W3rFoVjeg1R4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=m7B+fjjEiGq1rqMarKfoQJQ96mJkrzCxoRde8Udl7TiUxoCJtU/TypNioHp3L+iYu
	 hLo2t58MraJappvVMHjnsGitHOqF5W0wjGzk7GOvzfTVFy7Qx/RL5WmtEs2dw0yVW5
	 X/5s11pJLiivLCbT8OUo1SalZ9VlVQeIPfI+EK4ZG/7ZWy4FgEtr+iy+6XKA0dMVqS
	 n7n+dvfMBWTzi0nHe3BEVxaoZyIjstNS7r4dxs264Ux4cZN5XlFcrk9dHzKSp+HAmI
	 0bOQ9TqmESz1rpQ9X9kJm6iIiEPi2jphSt9RnUqN5IxyRQizFDyp6xumXI86Ge8p8+
	 hkbJfsHCFokQw==
Date: Thu, 30 Jul 2026 21:04:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
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
Message-ID: <20260731040438.GA57540@sol>
References: <20260730184853.48347-1-ebiggers@kernel.org>
 <20260730125327.11fc9227d04f659a59136cdd@linux-foundation.org>
 <20260730203003.GA2459987@google.com>
 <20260731034931.GA3560112@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731034931.GA3560112@frogsfrogsfrogs>
X-Stat-Signature: ti5j6wzy7iibuiiidq9su16465pxd9bx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D85BDA0003
X-HE-Tag: 1785470795-882137
X-HE-Meta: U2FsdGVkX1+9OewQ8sKsdZtM1b4IYFWx+cW19wK2F4XC5FBAx3BQbyld4JN509jdqOCifnTYt9kGibOPh/kUxk7tiDU9198lnJFbbWxIEO3OjNBfD529vwTPPXYd6EIYiduJE2l/smmm04kS/QbZZ2/TGjCEpP75f+RotFgawhEDJSDWsJGG9RK2SHmGYllLa7EER8FMRFe2BRo4TrFrSzsTy6NqhD9k+x/E+AsULBENU0/FCNEcVDaRo21XCDGkpmyaoOtSDtY2Ov8wqGsDR8PS2lV9K2MYNdijWeMEEAFGtQXZLnPNVzrxe5rq4fLO+LrSPLXyQ6O40z16g7XN7qQUfdrrDrvrO+Fk+U1uNq0Qo75vQnCGChfc/5ZmjlLaZIjXPGzPVNETOZ1nLXLGjkZgD5Q82lJxSQTxQfAOwoA2Rug7w+exjImFnmF6xDN80Rwb5ojR9VxJYkWkj6Y2ZWuP/YA8nfa1s3cTyAuxrWDjfuwsW1PJqGFawVtE20hhDJPl58d2Mm2eWcTqy6vWqHseQI+v94H8Pqw3PZHcpS6C2NwEaGqKv7lbbbKkqjFshlLBt5uvCI1C08x3rmnDbiWGq93GwdwyeFkn7o6P3y+g0kHRgVSioW9YckO2Ajs2GHrtbKmCKvgOOF1bJOj4Hs25tK81QSmZM13o/09R2FnlWVXKWjipREkXdCsn5J6zqIp2vqXgAhuCs6pExNxRVE7Ocb7aq5F6+b2+3oi9x9cAA+Oa8NchBifBNV1AbYIAhpp4kUK9Q4T6KWTrcI6o91VEvzRStc0G47mmY2u+DTt33ZdUgf+BG/8MGDMJJPxM45peQ8BbgXLPiL1OF4FGz9EylF44+w09ljez7WT+D+Kasy2vvki8OPyD24Bi5b1ewpB44aAJi7KCKQD2rYXCI76KFORzNIUZNZPNlNIRt/m2iIcEtkC9rX7zTOF6iiuy1yEHhmqQsTAvYNoAOxU
 JWXDG+95
 foH78OClabWBRwiLwofqnr/q+KvVE4RukNzBLuAqLILF8gTYRGghp/fHnVYLmUP+EMNqd2rL+wicAw/OZiqAW1+DcJwW0UnV5GSXLMVcVyNqPmwN0oKwurLnsEEMmxp7XKA4LLa4AenSxQkLRMkCWMcT0t0rTLVGSt19IzraJFkuVXsEpUXP7X6Nds7eSQMQs5rXeRh28UuZx7rrvqOtXCZdf/ze1JWdgCqXId35ZOvvT47NksDFZhOnIsUfC//3W+4EP3tuc7eTsVbuL99vSji1grw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 08:49:31PM -0700, Darrick J. Wong wrote:
> On Thu, Jul 30, 2026 at 08:30:03PM +0000, Eric Biggers wrote:
> > On Thu, Jul 30, 2026 at 12:53:27PM -0700, Andrew Morton wrote:
> > > On Thu, 30 Jul 2026 11:48:53 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> > > 
> > > > ext4 and f2fs don't prevent filesystem-level encrypted files from being
> > > > set up directly as swap files.  In this case, encryption is bypassed.
> > > > 
> > > > No one should be doing this, vs. the methods of encrypted swap that
> > > > actually do work (such as swapping to a dm-crypt device, or swapping to
> > > > a loopback device on top of a filesystem-level encrypted file).
> > > > 
> > > > Nevertheless, to prevent user error, make swapon() explicitly reject
> > > > this case.  Document this behavior in fscrypt.rst as well.
> > > > 
> > > > Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> > > > Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
> > > 
> > > Ouch.  We are going to break ten year old setups?  I don't think we can
> > > do this!
> > 
> > That assumes anyone is actually depending on this bug, which they
> > probably aren't.  Encrypted swap is done in other ways.
> 
> Hmm.  swapon() seems to read the swapfile header via read_mapping_folio,
> which means that fscrypt will read the encrypted block 0, decrypt it,
> and hand the mm a valid swapfile header, right?
> 
> For blockdev filesystem, the setup_swap_extents code will set up a file
> range -> LBA mapping, and the swap code issues bios directly to the
> bdev.  Ondisk contents aren't encrypted, and read()ing the swapfile will
> produce garbage because we're decrypting something that isn't encrypted.
> 
> So I guess the bug here is that the ondisk swapfile contents aren't
> encrypted?  Can we fix the swap code to call fscrypt_set_bio_crypt_ctx?
> 
> Though, you probably don't want anyone to read the non-header swapfile
> contents, so can one create an ephemeral encryption key for the swap
> code?  Or do you not want crypto engines in the swap path?
> 
> (Apologies for my unfiltered idiot thoughts :P)

Well, the direct swapfile implementation bypasses the filesystem after
the header has been read and the on-disk blocks have been queried.  That
seems to be very much what it's designed to do.  It seems out of scope
for it to start trying to implement filesystem features like fscrypt
file contents encryption.  (Note that there's more to it than calling
fscrypt_set_bio_crypt_ctx(), especially in current mainline.)  After
all, we also wouldn't expect it to understand and implement the
compression, checksums, etc. features of various filesystems.

Yes, when people encrypt their swap, they of course use an ephemeral
key.  However, they use either dm-crypt, or a loop device on top of an
fscrypt file.  (Note that if they use zram with a backing file, they
*have* to use a block device anyway.)

Fortunately, I've never heard of someone actually using the direct
swapon() with an fscrypt file, which is what this patch pertains to.
This case was just found by an LLM review.  I don't think we need to add
a new feature here; we should just remove the footgun just in case.

- Eric

