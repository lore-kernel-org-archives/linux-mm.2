Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 874B9CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 12:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7A06B0088; Wed,  3 Jun 2026 08:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9EC96B008A; Wed,  3 Jun 2026 08:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC4C6B008C; Wed,  3 Jun 2026 08:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF94E6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:07:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 833DCA0342
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:07:13 +0000 (UTC)
X-FDA: 84838475946.28.8B8F728
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id DFA3D140015
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 12:07:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iYm5CHKC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780488431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41Cj/PxB8IV5xLxJUHx++raQ0rPB+IqmfFjkW4NJYZc=;
	b=DQm/J5swmQs25Hy8yWsMAGmvrlUsOxqz3a+bMuC/wHCZYxZTgWlr/x2MrPaC8TEVCUJdF9
	WTUBUohzZfwND2lhbmQsKqzS59cNrHUVG2al1tnc131QbxpPpb/da+0RxgLG4mec4Ko4C9
	/BSptd8qXFD+7Cpaqtcd+D6m+gTIkTI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iYm5CHKC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780488431;
	b=DMaJYbbiA0d9uaadAD9/Wwl0VRaFzT3wnHrCOPKE8FyLyaKLlaTRoxKJQ8z2JLyBghY35U
	IYKl7CjsuMtrxoNZn/DUkciFMYV2gBZuP8QkurSgvMTFNEJ43Z6YyGA0G3AX9s5pT0YRDs
	5xtNiSw/6SK9PHTdSs+sdszEIpQPHgw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AED56021C;
	Wed,  3 Jun 2026 12:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1D1B1F00893;
	Wed,  3 Jun 2026 12:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780488431;
	bh=41Cj/PxB8IV5xLxJUHx++raQ0rPB+IqmfFjkW4NJYZc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iYm5CHKC81StCRxxxKFlG9szspVf4C7KNhgbWzh8h8wwz4fp5dFA1CheUmvOySY+Q
	 k3syGp4c2BYlIYZCBfVP9q25Qqs247hV6hxQsEK1D4+yC30ytHaYjlkNWGaXiSvsc5
	 mX4P1WhonPESIh7xNSbb7mnrbEiSm12M91Rb6WdWS/5T0fM6ayhe/4BImvBac65Q3/
	 ihIAmCXvGamwlcA/8QnUY+rMhTFvOjWhWCqdIgBp7v+K2/IfNZMCYZ/CsZt8DhG7M8
	 MnfW/bRPlmku4SjuqIllzALDAbflZxjXFYrUV2M4U4G0OYHowBIBgR0Z/Sl09eAL7c
	 x3Pr9LQrHIeAA==
Date: Wed, 3 Jun 2026 13:07:04 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Pedro Falcato <pfalcato@suse.de>, stable@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, jannh@google.com, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, vbabka@kernel.org, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP
 guard
Message-ID: <aiAYt2pNBVAIBaFg@lucifer>
References: <20260602172247.279421-1-usama.arif@linux.dev>
 <ah8XqXQycZdbYFG9@pedro-suse.lan>
 <bcf95603-a04b-489e-8edf-b6bc4a42192c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf95603-a04b-489e-8edf-b6bc4a42192c@linux.dev>
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hxqejyzs7g4fmffknt446ce545h3x938
X-Rspamd-Queue-Id: DFA3D140015
X-HE-Tag: 1780488431-156964
X-HE-Meta: U2FsdGVkX18yv04gd17/frmUAJIlbUaejXcxjh4uQXm6NUThgppsT5qvHnjsqu5Wf3wu5gO0W5YHjnbaHJ7qIDXsMbInBGBsZl7kl6BReDXAMsff3kKyxprqYZnm+w/G3IWAeE0gVu08WM046JMFgKg7MIXidstBxFjlOomD8aLLVVCeigjCTwnSW8mBZjl50Hn3msai7ZOPhXUCitF4DQl/dKZvn35VK46C3Qw73UcbqpyZJSrZe05hsTFZDEAD6XBQL4ejpMap9lCsjlRNbUrKBmrASceHUKENnWaKV5OQOvrtT4QOwgmU/3PP/LKU5rImsOJXSX4GYGclKeBhfmYzi1mvQ/e3xPFVrMxBXFJ3PgYfYZuw+u2XNERP9kd3WSM8Ezbgr+cD+V25XmKt+YVMYpSd/xpCRyAKIzaeHFBqMZ5C7S3Q/k8WEwmdl61QOavVS6fi1X8b2ZyciQ5//KpWS+3q7eD2gaNNvRJmZZh6R9ohBejEItZdkEKiI1EPEY+NFYaUBNM5NcbeL/5uOMR/OHfazN8JxdX7FVrbJ6+bGUCcnza2zZPvQ95JrgHus8s72gPH+tf+rMZMPnihbyjsLglkZ6DVu2IKwHgcv5t99KKasoMYuagU22dHYWpronaTmCa7oZccv/5tMFY2Bp7gnXoygLq+kL+AK/lkRDbEh44lnRpOjUHXvdO3e+EKLhG8sRwqtJOsPDnDcSkDP36PtYtSSemqYWWvsSqukgtiGUerpe+Nm8tZuDjyZrXOwuU+S1xt65pGo9/w/z6YtiOAphfRJrltT4xUp7FfY+/XkshvROTewT4Htap5zsBzeFj+RiZ603L1xy2NyDekpxPY6eZAWODth2Gy+QMCz/kv8mouX/aPFSpMuQtdpzZTBhGyygRvw6cLo5T3yLaXdXoXa/i9yZbTU6QdJyIED6l7oAIQdVFetbSHLC5FEcUunQqBVmAQFRJXr1/aC1A
 Gh3ud1/S
 NAchSgP+bC/UpeKmjfAwc2QUYmDMUuLa/lpl8hq877dAzp//w+IpGix8RS2BAfgU65rIC5hUHjKqWCT9w5cOEOaEPgdhqEB+k79nvvX2JCi+O7t9f0Y0cDNpZPMisc/XvpGIUMp5voV3FE1Pyi6bsJMebDuQOyA9BVEbZQHAX78oOqAF+1X2JavZXYtSYw9Hv3k9kL0CiuCwvkUoCghzilx+fg7k803AhlsxLjodzr9zcNtfB6SQO+0Kq22JtLOnzgWA3nm/pUQysNZK/WBbcyAxn02ZJEuV4bJdsMQP9XTp6e9SMbPklCec+SAt81KRZe9+6JJ2nH7cRazUkaqyl5TWJ6XCsnoWza+ySLFsuk7QcQY4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:52:24AM +0100, Usama Arif wrote:
>
>
> On 02/06/2026 18:51, Pedro Falcato wrote:
> > On Tue, Jun 02, 2026 at 10:22:47AM -0700, Usama Arif wrote:
> >> mincore_swap() also fields migration/hwpoison entries (and shmem
> >> swapin-error entries), which can exist on !CONFIG_SWAP builds when
> >> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
> >> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
> >> return, so mincore_pte_range() can spuriously WARN and report these
> >> pages nonresident on !CONFIG_SWAP kernels.
> >>
> >> Move the guard below the non-swap-entry check so only true swap
> >> entries trip the WARN, and migration/hwpoison entries take the
> >> existing "uptodate / non-shmem" path.
> >>
> >> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
> >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >
> > LGTM, thanks!
> >
> > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> >
> > Maybe Cc: stable@kernel.org ?
> >
>
> Ah yes, I have cc-ed stable in the reply to this email, but probably that
> is not enough?

Yeah I think a Cc: in the body is required, but then again Andrew does add Cc's
for Cc'd parties so maybe it'll be automagically sorted out.

Andrew - probably we're good here but just checking to be sure?

>
> Thanks

Thanks, Lorenzo

