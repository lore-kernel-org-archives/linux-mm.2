Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815A0C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 00:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687316B008C; Thu, 23 Jul 2026 20:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 638876B0092; Thu, 23 Jul 2026 20:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527316B0095; Thu, 23 Jul 2026 20:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 34CDF6B008C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:02:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AC1FFA0251
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:02:53 +0000 (UTC)
X-FDA: 85021719426.18.0E21486
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 89D0C180004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:02:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LBcwVAU0;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784851371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c9E04AFsCJ/VZ9edKXAtGVUUjcTIxBBUMYLvzGUzl5U=;
	b=ui0wwcPF+CjwFvEpWb4qH+uk9e+KkTpVCDPNnNJHbLv4PTf6PUV2o/JY9z4XfHOHUnoleE
	OjAMdlXMTI5fw0YVMFRVOuuZbqpO3CB1oq6NK+I3XC1A8tby4I9lrq0AVb8NbQcEtqkjrG
	QGm6cbTCCZftNNTNGPTsbYi4GxeF3es=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784851371;
	b=XqvA2xK0Ke/Y7B6qunmYJzng46Qrd3GC4uhhUH3XYEbxBYNLnxOK3ZlAu/GjBcN4Hs3bBk
	Uv58L2yHEnl1D0t/07iwnmhQy36eRfc5pshQ48uhwSsUl47EAd6uBNDOe9Ytm5vSyGBIGU
	JWXfGXjA68x55uzX0IfBWFV4O0hGX64=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LBcwVAU0;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72EAB41076;
	Fri, 24 Jul 2026 00:02:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB1A1F000E9;
	Fri, 24 Jul 2026 00:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784851370;
	bh=c9E04AFsCJ/VZ9edKXAtGVUUjcTIxBBUMYLvzGUzl5U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LBcwVAU0Maz8s9W9L1HgHkU9+APYMXK0mWzYaa/ZRGIlgln0kLS27D8ggbEblmF0J
	 0QQWnHVI50v4BzgZvGwtfJYCc5Uucl1Dvq2uYu1l7uZZHkYOGJ0psgix6YPjCd+FQR
	 zOxtuggw3kInBwUd7ZsZ5A6Eo9N68yK2Xhp92CqQ=
Date: Thu, 23 Jul 2026 17:02:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-Id: <20260723170249.98d83bd68698fff2629391c4@linux-foundation.org>
In-Reply-To: <00bb7fd0-998b-49f0-9941-cc4d796a8751@kernel.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
	<20260722150006.3848560-5-hannes@cmpxchg.org>
	<20260722162207.31a2c491ffaf36d1e8948c14@linux-foundation.org>
	<67e1219e-9d47-4a30-a8dd-fdcf03229f58@kernel.org>
	<amIgT-l7PExKVJlW@cmpxchg.org>
	<00bb7fd0-998b-49f0-9941-cc4d796a8751@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 89D0C180004
X-Stat-Signature: snewjpasw8yh4tac336u8jsy6soph4jp
X-Rspam-User: 
X-HE-Tag: 1784851371-364540
X-HE-Meta: U2FsdGVkX1/3lcIjuEP69s5EDUhATiESpvxLzV6WpWAC9gEYvdhBU2BOJeL/Q0he/lpcQSDyB6vEaCCokxXauHddFLwQPXtpKaX7wRPvxPb72IGLbvKaMgcrhA02DGpWIDZ1Fwd+mgHHYubZ/yzQv/1yG2Qw6OXTWO06h6CP0FpzoE9paN0mQuA5PqEUuKRfcV/rybGTlbgwhH4BoFTj6MFImT/PqcJkch/vgken5Eo0HGP9ExoemEqVLhm+/ykBKcvfs2A7yKsyFnsT7cxCni/yctDM5W0EQ4evR/GN2V9GjsteNjtQxZXjAHn669ehW+7aDIJqaylweoxGXMSafWKMAmgo7tqiHRuWSJZcG/uSAmRLhHEv4fuhTN7jxHYSVzKTp1SNM4wtZwrMhc89dwuIJzp4/tIy1hPmT2iJ35JZ4ebjgJjpTSsKNVYCgsH/sSz9zbR8i9Yc/lNBElwcUkJU2FiGIB2kL5ZGPNO8SwXZH3CrCjMY3Og/OdVjg6L1eMIhCIeT0j2GfqLaJKffSW16taPSWvhS4GVZk1RvOu3qnmr0U2ICqWRCrhauSiAfD4wP/mXmOvOLR1xAc0KqTpL7C8J6MF+QQRQnTefSeWPO31c3SbEOF0zKDx79lmwqiED16gNu6i6lCd6tPTOCQIU0Aw7MxNnDEcwDZQ2LYn8FdnuUAtNjcO0F/NJd9XZT6P5XaFjip6PR6BA17qgurGkhFT27tZQq7cmJMk6bVoFDcfpqjwfVYhm18TRuQQ9iChHtR6sA2qnHeNZA6velDbGgLguTjIn5rLY5NIsrHppevc1Qu//RcCJOXSrBWy+5M486kNTTuSMtgKn2YqemVkPR/DRYD6oRY/AR6bqBhacRz+LI9+1dIiYIPpBXAt7DmvH2W7O9l9i9uiZST7XU795wWKXx9jd8i5rCnMDC7U3ERriKz9UEFm7Z/F45aBPzQYLUBlaWmfks7rDJsZg
 CyxmhUH6
 26BFffzRt6wXPkTunEZinZ+t+DMQ1+6UU/NuGXnnP5UXHripWnyK0XVZifBOneHjob6EzndtmYinxciYP+TP13aunGtrSCx+U+9edwKCn9X4kGZaW2fs0cKtx/+NEI77IUqVFyzZbN3528xwRY1EJo2tHXUOs6qEX0mhhEvvFYs7TTRWQFAtQTZOrFzoDi3YsMCvWJwqI+T60qTEs4Cp4NzytaIRAQCefhOK29SRsw+yMeAYet2KBoEUPvg7imLSP5kO+S3tVahktnNOeDNVeabvJBDQWZC7ir97H2xxONMFOokYjlmyvlsLbTdPCQ9GvBt6F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 16:17:51 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> > 2/4 actually came after 4/4 during development. Without it, compaction
> > cannot make sufficient forward progress on the promoted non-movable
> > requests. So it is a hard functional requirement.
> 
> So that's the tricky part then. If it's a hard functional requirement for
> 4/4 and yet leaving it out results in no conflicts when applying 3/4 and 4/4
> (as it indeed seems so, based on my local test), then it's quite possible
> stable folks will figure out themselves they need 3/4 as a stable-dep-off:
> 4/4 but won't backport 2/4, unless you act quickly enough on their mails.
> 
> > Whether it deserves an independent Fixes: depends on how many
> > GFP_KERNEL pageblock_order requests we have :-) I'm guessing not many.
> 
> I don't know how else to indicate it though. It's kind of a co-fix with 4/4?
> 
> >> > (An alternative would be to put cc:stable on all four patches.  That's
> >> > a bit abusive but we do it rarely).
> >> 
> >> I don't think it's necessary, the stable team are quite capable of figuring
> >> out the deps and backporting them with a Stable-dep-off: tag. IIRC the
> >> "fake" tagging is discouraged? Maybe they can clarify.
> > 
> > Yes, I *think* it should work with tagging just 4/4.
> > 
> > It won't apply cleanly or build without 3/4. So I'd assume if that
> > dependency is lost, the automated backport will bounce and I can send
> > a backport series by hand.
> 
> The way I see if often happen is that Greg sends a mail that it bounced and
> soon after Sasha replies with fixed up version/series. Which could very
> easily be 3/4 + 4/4 without 2/4.

My brain hurts.  I'll include

Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
Cc: <stable@vger.kernel.org>

in all four patches.

