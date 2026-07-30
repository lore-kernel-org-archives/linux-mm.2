Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FA7C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 20:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730266B007B; Thu, 30 Jul 2026 16:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0EF6B008A; Thu, 30 Jul 2026 16:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F63C6B008C; Thu, 30 Jul 2026 16:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DFF16B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 16:30:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B07CA80277
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:30:08 +0000 (UTC)
X-FDA: 85046584896.14.3F1F030
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1B8D320006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 20:30:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFcsGnLo;
	spf=pass (imf13.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785443407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0u6gw/MrFBT1/QNrPa7nLjvLVHSDimbPCCINT1jLXiU=;
	b=yQaKaFzao19yAB7atMc3BFYyvjc8pug3xkRCERoueYjlAdzodUKdclbsWx3319QDixFaDU
	M94/zEfsNRmir3SO4mctUPEWXfAZw5xWn2Tk6zA4KGjw58KPZbTcdVxrj66Hgk7tt6XIs6
	q4+HUUwCNWnazu1EzuoEEEZykDWHBQg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785443407;
	b=s8rmFPjxJdQH5n0CqjVot2LweoDZmzMTJAsbTP9LE+Kr60uIscZJkwqSHpLcNYb1lR2qOP
	3b+00pYB303/OW4yx8d2kFqWo6ivOmA1W+wBfoXcJ9lQMcb77hJyDY+v24FP14LVgGKfZz
	Rw0Amkxe40ci+KE9tJXkkosL5WeowyQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFcsGnLo;
	spf=pass (imf13.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A1AA66004E;
	Thu, 30 Jul 2026 20:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57C31F000E9;
	Thu, 30 Jul 2026 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785443405;
	bh=0u6gw/MrFBT1/QNrPa7nLjvLVHSDimbPCCINT1jLXiU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hFcsGnLovWPcFi+YkFwXfujpvSBlB3iFd7TIwz6cMigymfDKsbs8+aVqBQftTS/Qu
	 1hZlGC2QGQAmc9tlfq8EeyI0yzWmfdfg/4SRB9JmulIAJRqlKp78KxAeBd6CpjMWjA
	 ZzLb6YKmWZwiQ0PQdUG+NckRDmJwdf3ZYIyLPX5wEfHj7EwJohV7fQqRzAzfk6fcaW
	 46rrLmUDHXq1kFeu4lRdAs5HrO2gkrT95BMqbHyLUhf9uMEqaMGfA4hg8gN/vKCD8I
	 JVu6aVSWUfm/WQnFqobITKGHVuPzXNwIhKdA74nXROb9GzBc6/rvfSbhgsEEnUNA6N
	 Rmn+CdkioS94w==
Date: Thu, 30 Jul 2026 20:30:03 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: reject swapon() on filesystem-level encrypted
 files
Message-ID: <20260730203003.GA2459987@google.com>
References: <20260730184853.48347-1-ebiggers@kernel.org>
 <20260730125327.11fc9227d04f659a59136cdd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730125327.11fc9227d04f659a59136cdd@linux-foundation.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1B8D320006
X-Stat-Signature: 9mfhtkmnuktaxj3rjfaxceo4cgbkeb9b
X-Rspam-User: 
X-HE-Tag: 1785443406-927704
X-HE-Meta: U2FsdGVkX19TQTNdQmPeoOOHsh3aYrhYdjriZW1hMGNlcwPaY8gHp6t6aI6TygiazTUnmWQ1n7bjz8aJ5cG9HFoJZ3QYdLHPONzWOs4AOSWOCw8YL8AtV7TiQ3qcHwrXNwnPmBngfYI0k7p83bGLtNqGqT0U6YqRqwA0TMZfB6PmPiMPQvQBrLkQTJZIix5kU6wuqX7UiuAVCoQWxCwLO9qSgJ/ZZKALlSr5FYUC2/hTt5EbwjGa9T5+1thtCAmFvh02n6r7a5G/uHrsrYPmrCloHKZFc8WwdujNaP6WvVCgvNA8kzxhrkn0Hh2znp/kOULdIUxezv7NTh9WzVv5xH/qQdev9/27EO0BiaCXuNH8P7SLJBgvd+K1ZFCpOyRtKwTDHfIGbk+HRgfPYe+vv8dtyw3QJbYqAa3WWy3lATngj18iA0JJDoyuAAdYHgxkITPSAxbEEsXGIgCjtBYUg+nIAy2R5W/VFZb+c6B07NrMrrW1Wm2VlQC68WZ8dp4ouPJLwNcJPy+fp458bQHiodccab86rKxNvw8mcYI6RP8+Q1lwG7MzH49aENZYdkuJY68tmfwbUpj24A8uIk+t5dJljRnpDiqL6ay3NFTcMI5u1EUPQ0zO5RPpNSx9VC2D9pzSflzLbx6FdNNIRaRwBobuxqHixX3ayXzZFE3sUL5ix7LC4HpGWvI73y7mjdf7Hka4g+mGKvNSTDcOjPabW/ptdYtpyHIZuKZZjyRevnnuniPpckZUBWsGjxi+OgUujAOdkxUNHyOtmkMpZ20NT3EDGjWcODGQMogWK7aHiYRnU4YajqU1VYCYol0CiiCHdq7SuA7sEPZM75fO4Jd208nqaGhH1BHWhcNp70fxIzVDqn/I04Fp3MxeA9Vd9YY4CpOZmBXYf6qbqligMqR36BMb/J4iW9UkIOTI9VgzzNilWxixslE9O+3/w+rEy021IXx1f0IKFRDhi/bd+DZ
 uui1U8QX
 6up9zaFASnGUdkKX08+YlpcCBHeUrVUyJ+Enr0Os+U7CQwSLD3D4/E9mlH3uOrE0je6Js4DiQOT+r8r3QW6a3AC15XyeUTDLDThdfYEPdE3QO7k3md0cow0csdU4IBvIFVSOqVAytA8YCk5FHyhsJSpGl9aapdUeNdw41AxWUGFtVOUqwkbXYk98iNxJyCrTS14IyGQiUL+/xQDTj6A45z9fRn+UI720yiRC/9CtgBogzFXmr/CQgFahJaxnURrXPg1d3sHEGFJ3b4Ig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 12:53:27PM -0700, Andrew Morton wrote:
> On Thu, 30 Jul 2026 11:48:53 -0700 Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > ext4 and f2fs don't prevent filesystem-level encrypted files from being
> > set up directly as swap files.  In this case, encryption is bypassed.
> > 
> > No one should be doing this, vs. the methods of encrypted swap that
> > actually do work (such as swapping to a dm-crypt device, or swapping to
> > a loopback device on top of a filesystem-level encrypted file).
> > 
> > Nevertheless, to prevent user error, make swapon() explicitly reject
> > this case.  Document this behavior in fscrypt.rst as well.
> > 
> > Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> > Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
> 
> Ouch.  We are going to break ten year old setups?  I don't think we can
> do this!

That assumes anyone is actually depending on this bug, which they
probably aren't.  Encrypted swap is done in other ways.

> I think the best we can do is to emit loud warnings which point the
> operator to some Documentation/ which tells operator that this
> deprecated configuration will be disallowed in, umm, 2029.

... and if they are, they'll want to fix it right away anyway, not in
2029.

Other fixes to explicitly disallow swapfile activation in various cases
have been merged without a deprecation period, e.g. 36e4d95891ed,
377eeaa8e11f, 51cc3a6620a6, d15cab975459.

I think we should try just doing this instead of dragging it out over
several years.

- Eric

