Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 382DCC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 21:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111F46B0112; Mon, 17 Aug 2026 17:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA5D6B0114; Mon, 17 Aug 2026 17:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026BF6B0115; Mon, 17 Aug 2026 17:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D76126B0112
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:53:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D0B4808F1
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:53:42 +0000 (UTC)
X-FDA: 85112113884.12.BA9E0EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9DE0C80002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:53:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rYJfVdrJ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787003620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFdvYbnSNaDyaig6V7v5E+8daoEbZSeLkM7vwKbiaF4=;
	b=dCLUo139kb11RQaTfY393KFsJQjvsaqCaVsaDLBl0yMewvRVAy8MrvPUcFYvEP2DQQmsv4
	Rl4SipYQ3sbxSZtKZHD3UuRHvEmwPaKXKp8pJ+OJBHOjoN47rih84TSXkpoha4rLenKNlu
	sG4ubzdgSPSjDb0+HxO/55c9K6ttK9w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787003620;
	b=H4gpetyLYlB2E6fxRFhs7DefX3PokzpdpMQSjjgmdiN30ZWWEFt27bpZSXCOFM92hqgFWS
	9GJYT3dahcoDOmroZNjRUeEesNH18cCqth7a68ESakJCNny3L9iI4Cdu/mKjHvAH0fLVTG
	GGa14tR0EK1Aj9qYoY+14uD4HPAMUvg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=rYJfVdrJ;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6918404A3;
	Mon, 17 Aug 2026 21:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C0D1F000E9;
	Mon, 17 Aug 2026 21:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787003618;
	bh=QFdvYbnSNaDyaig6V7v5E+8daoEbZSeLkM7vwKbiaF4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=rYJfVdrJRxl3lQ79a0HsX9L2ErzbiqR7gwqtPnZhh375GKWvnMSsMXepJ5zuViQEw
	 TyuraXGEUdfigTfoKbVUclnHfk4Ap2l2nMwZSYuEogPjnavE0lt79oPBjIDSABfhTQ
	 9aq6LmuXxiX34obmbaW7O9F6+Arnw8TjMx1lZ0Sk=
Date: Mon, 17 Aug 2026 14:53:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu
 <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed
 <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 0/3] mm, swap: don't spin or flood the console on a
 bad swap entry
Message-Id: <20260817145337.85c945fbfc7e8165ea016710@linux-foundation.org>
In-Reply-To: <aoL2hgmgQYk8vU8i@gmail.com>
References: <20260813-swap-v2-0-4a625ccabdae@debian.org>
	<20260813133455.3fe770eadcbe640e6f6c46cb@linux-foundation.org>
	<aoL2hgmgQYk8vU8i@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ehaq7s6mtiktcsi6oe8auwb9odhwh7ea
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9DE0C80002
X-HE-Tag: 1787003620-35126
X-HE-Meta: U2FsdGVkX18G91+ykSop8755yWzCTqoNUCkSQcRzFXtQQEzcvDQXcXtF06AI9Q+P1GbFQUpe2SQvfeNMaIi21lKqdQlrIFQSeEeGKKrhQVzpa63ncaZ8IM3wHQlkoXgX1AagBAEmjZ+0wV/OT7nJiCCjmA2o+qgh0O2e07mx5RDCbcrZ5231CixbZ3CTKjtiU7TIB0dTkGsEDPf2nXhMG0fWep4Z9SZ3565EXNOvsGYHNRFo9HwS5cPoxHLMLx7YwWHtIJWgqTimzAzc64vZsB+qKmmo8GdwTX0GaGYW5tL3w/3DKC+Bp7IlBgDPdPetM/brWGnA/iDu7D1PWOoru1w+WiJuxUgjAEpA7AqDdV1zvgWtAKBnxFHuVwdfHVWx/jueYu1UkZiVwv9IohYmNtXF674dURiq7z0SSGbV+QnLOjBrRUJhIHRyccNnrCYCBeID/XE/t6YN25R2Y7In7klaHrIuVFSBPyqq2iu70Yx7qq5zqZ5dZC7mIWt8tmfBz79RGZv3pTyjfuLpTbtwpmpnil64rd3tTVOmCpjJ587FBacBhieIKPxCRPZY47IUyXB6necw1maSkwrBx8KySrV5Oj1EXatmC2qxDwhGea89IU5P0HHVg6xXeB9YmD0pmqz6nHAv7fIk/UhG9LDSM4Xo2xjVdCNPPXUpxBXeAXYvD7c2Nk/YmDOa7Ycvgmhm61dSytILk5ZEuRHoWGeBsuiWoSQ0oDymuDkV0Pf2lS7zmrnTl31WWWUfNZPbo4todd/sygFykVjAyXzrT0UtgJxIYKGvr3sGZUaDPwkr9Dv/grmq1zet2vjIpMHNOgBZJJnN3/NfVCsO5/m77bdX3a8pcPEOqMH1JZWWgZ84HFWsEdfQLSkOtZ9CJZdRXWXqW1SmK6OF6AHMpWoFSLvUY3h5BzGfYt3v9faqPctcvcbHbZs9N2O3rLZegLLpk6uRFh0xnidcm+WFyfPwGH4
 pZ8Fr6h3
 iMbkJstHR24jTidyzzXOAb1Zb3NjFP5mKumYz1iq+IfYalReOmtN2gGie1EzOqoM5OjzzTy/x6Bv6JSkUeg6OMMx8gNpCJNk7e1zMp31Ux9Rk+49bQoGhZRqCHEhfL4wKlrz3NVMzf1zFBJ4f2SWowqJIMDOPwyl60R9u0QguJH0hgInH4/qHQTzE6KTP+WN2/uG25u3xfdI1ZQxPQPcg8OgaroDDqMMJKdy+VYFmjjCwFdFQjKY2eQ5M8HRwKyenOAirydMu8UD64IOO90YHrs7cLr5BIPiUTdCsJy0YW+gznJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 05:21:32 -0700 Breno Leitao <leitao@debian.org> wrote:

> I think only 1/3 should be getting a Fixes: in v3. The message I am
> drowning in is the Bad_offset one:
> 
>   get_swap_device: Bad swap offset entry 3ffffffc043c5
> 
> 63d8620ecf93b5 ("mm/swapfile: use percpu_ref to serialize against
> concurrent swapoff") added the put_out: label with just the
> percpu_ref_put(), so that arm was silent. The pr_err() landed in v5.19:
> 
> So, if I need to update it, I will include:
> 
> Fixes: 23b230ba8ac3 ("mm/swap: print bad swap offset entry in get_swap_device")
> Cc: <stable@vger.kernel.org>

OK, so you think that only [1/3] should have cc:stable?

> > [2/3] is "no functional change" so ideally it simply wouldn't be
> > present in the series - we should aim for minimal changes when fixing
> > bugs, then leave the cleanups for later.
> 
> I need 2/3 to expose the difference in the first place.
> get_swap_device() returns NULL both for a malformed entry and for
> a device swapoff is taking away, so no caller can tell whether the
> failure is worth retrying. 
> 
> 2/3 adds that distinction and converts the callers, but none of them act
> on it yet, so it is no functional change on its own. 
> 
> Then 3/3 is the actual fix, now that do_swap_page() can differentiate
> a retry from give up.
> 
> Do you want me to squash them?

If I'm correct above then please send along [1/3] as a separate thing
and I can queue it as a backportable hotfix.  Then [2/3] and [3/3] as a
separate two-patch series for 7.3-rcX.


