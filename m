Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E80D3CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 14:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC246B008C; Tue, 29 Sep 2026 10:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4F86B0092; Tue, 29 Sep 2026 10:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD0D6B0093; Tue, 29 Sep 2026 10:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D116A6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 10:40:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46AF1A0503
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:40:45 +0000 (UTC)
X-FDA: 85267061250.25.EB438EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7A91E2000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:40:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxZmXfC8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pali@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pali@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790692843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5cHwHJWG+PdvObG6mgULv2DV2MwXG2ifabqUSsYM9g=;
	b=xAmflsgVHoKkEg5kv1CGASFCAk9MbqmVgyS5viL3NXws84Rf5K+eVAYyFlrOc16DwXDQmL
	HASHjRxl0p3/hPzF5IwNBNKR/guPzqcMoWZXLH+nzlM9fy99OYAMq9SqGoWpkAFd2ydL1f
	ZCLC0rvJpd+n2pO+p/j8X00OpC85RuQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PxZmXfC8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of pali@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pali@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790692843;
	b=TQDUTjZ3w5fI7e1FbxlFH+c7gyR5DNbEp92qpsjM65tuPOXkB1wFPhvJtt2NzJ8uDkoBRG
	8Ur/T09yqlpuBz42B2kAczW2F0IxrorWARq1wwKPq9+UG/aSM5eL+kGAk1FIm6RFKP3daJ
	ij7aEn5t7xl6hu951zSvXMkZkrKSrHc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B72F600D1;
	Tue, 29 Sep 2026 14:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915A41F000FF;
	Tue, 29 Sep 2026 14:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790692841;
	bh=a5cHwHJWG+PdvObG6mgULv2DV2MwXG2ifabqUSsYM9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PxZmXfC8YqsppmyjCnfb95WGea1J5Ah6N6sQjZWQXl/5JzSDueg34gZDFv7g3ur2h
	 1CmLjdRUdmbpi0euwALi+zBhQSH9VAeLqHEPb4R0TawXcdwix0M9MAwKZmMeyUu7M3
	 aKD7+yipa6i9FzKrAmi5lZelkEcHC50IC6JorSHnGcsE2OOswpeNV3m9l8TrxmxtGK
	 shWYRf06U05ReKL3CjR1G1goxX7VXGSZlbyaNjAXMK9/t9eCxPTR/VLbP4JAWiOmRd
	 cQBCY789a33BoVd4deCWQglUV0mTgTQoHnjvahwb3xyjR/zEg8esHSJgWi6QDhoAYl
	 sC1Gf/urvDITw==
Received: by pali.im (Postfix)
	id 9882A5F9; Tue, 29 Sep 2026 16:40:43 +0200 (CEST)
Date: Tue, 29 Sep 2026 16:40:43 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Theodore Ts'o <tytso@mit.edu>, Hugh Dickins <hughd@google.com>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	linux-ext4@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org, linux-mm@kvack.org,
	Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH 4/4] ovl: Expose the filesystem encoding through sysfs
Message-ID: <20260929144043.5rg4zf7uth333qke@pali>
References: <20260928213155.2612039-1-krisman@suse.de>
 <20260928213155.2612039-5-krisman@suse.de>
 <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxj7Vx-UGvgGGr9hPC0qUgJZ_WRAv1ZLi=gJ6r=ZJW0QAQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
X-Stat-Signature: x3t83fnruhrpu1d664xno1wymxh3wmwn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A91E2000C
X-HE-Tag: 1790692843-326553
X-HE-Meta: U2FsdGVkX1/k3PQlfLZmQnYahUhGU7XECdDoNGtsSviQFCold58rFomNuj4+ixeII8elBlbQKLxqOtHN5t3nVKyNekpQVTXe+gc+Y1nHYGfS3pwdmEn8KKcCY4N7oOdbU0gTmtCYI7otqFT9G4VyMExhbBnycUrOXHUjFoPmObT2oLdRRBN6iVO6l5v9vTzFZzAd0e2grGu9Ml45tOn6EYkWowLAD7/7amlwJH6RD1xiWJg73UE99Pak4KEsnx/LZNJB1jwVGgBuCDBfFUpqcy4cJZR/5KluwwXE74beby9FJ6SCs57XAqxC8OgNkC99m5gs73VGkWYrOKz7MGRg1LwdkxA6ScP4T5pi8ZtIHVKfAa13D1RIeVMe/Rllbntv2dJZV8TyI4AH4vPtpeFd264rPyF896B833wrHEDxWIy7eUPiX4PLTchGnYLO26DtWJ0WdyEdvi6ZY93qXxCdNvtmARdThs4ruawLtl2bwOqM0eGsfUrMBaGIcp+chVJVCY0C34gLiJ2ZfAbjUHMNH5BFHwd4lBTlIXxrMP4qSO5ZBVjdDnrmLPVML6MdbI5V3CsSk5loPk4BUuEFWixjLgKPPTLRY5bk9ZzkzysTjqMy56+JUBXVJBFFvRiBJWpOzZqXPtNJcZhuQlT+ikebPvrPaHGjmcvQI5WjZmZQ8mfp+M4fBQKtbv7qqhlc/De+BaHRbebLS7v8oTq1qhE6hATCvvHW2YBTUDj8HRl+m04mIkouYHxcrxcgFar039AYLwZtZkpmICXnLZ2RnFjMr5Qo9wh6JO7evtRUhrxFLlOnGe0yc+b2ids93ghixv1Qp9AkUQLv00ePE5l6ek58oNceCKZJnzy4beWX6gxNAtsomvK9KNWGfUhwxGi/BGMoTvdl+Tl+tKL3oUfw3ArepxTzIL6SezlDqMqa6+bWCkrL94xD+ZuESE3nAcxG3zMkTUB7JkGiKY3CA0o/3ir
 czgX9XQ9
 nc6IPM1GIvym4/vLVt2tnPWE2xQoeYGYYFyKryJzYBA7ITY2dHPRYcjsHqlEPzNn4s5l1u8ENnQ3eg5BtBkbklrPzu+AZpPLq7fQexeq5Y89xWmdGYYELaPRyst6P/J9wX2a74SAhNK8UjQZJXCNvQSMe6LXuoY7Ki6PidrmiNSz4iRdW8Fmd6nGagA3eUTjsTo6j0c1ZADh4L2B4wowxu09I6/CVEz7Bir8eN64+6oCQFkdvrI7qn73bTuGEWPyGJpn8dc5Z4FLpnTindrDFgbQsLojpVP0vHcJBa8LCejRtRBAJ+obhkg7zX09SwUqUAanHg2Zz+YifwafJJSUFC6Re5AaYm7lOerlZlHE4pnWd21TmDZr2iYb1Wlr3qg5I6LGmI5TOyJYloHMMTK4iCcvlskMT5kXKLHvG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tuesday 29 September 2026 16:15:04 Amir Goldstein wrote:
> On Mon, Sep 28, 2026 at 11:32 PM Gabriel Krisman Bertazi
> <krisman@suse.de> wrote:
> >
> > This patch reproduces the same interface from ext4/f2fs to have feature
> > parity, so users don't need to rely on parsing dmesg or trying +F on a
> > temporary directory just to check for support.  Note there is no
> > encoding_flags file, as none are supported by ovl.
> >
> 
> Gabriel,
> 
> I am not ok with this API.
> It is wrong in several ways.
> It is not generic, we have already file_getattr() to get casefold status.
> There was a suggestion by Pali [1] to get the supported xflags - statx style,
> which can be a way to say if a fs could return FS_XFLAG_CASEFOLD.

Yea, sorry for that. I have not finished it, I did not have time. But I
would like to address this as this is something was was asked more times...

> In Chuck's v2 [2] FILEATTR_CASEFOLD_TYPE was already suggested
> as an extension to file_getattr(). I think we can still do that if we include
> proper versioning in the casefold type.
> 
> TBH, I don't think anyone requested this - you only mentioned
> the need to know if tmpfs was mounted with casefold on and that
> doesn't mean that etx4/ovl patches are justified, but ext4 can decide
> for themselves.
> 
> The point is that this sysfs is not going to be the standard for all the
> fs that can return the FS_XFLAG_CASEFOLD, so I see no reason
> to add this sysfs interface to ovl.
> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20250216164029.20673-4-pali@kernel.org/
> [2] https://lore.kernel.org/linux-fsdevel/20251211152116.480799-2-cel@kernel.org/

