Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69720CDE000
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:02:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3503B6B0095; Thu, 25 Jun 2026 10:02:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301736B0096; Thu, 25 Jun 2026 10:02:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217B56B0098; Thu, 25 Jun 2026 10:02:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1BC26B0095
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:02:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89E7087023
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:02:21 +0000 (UTC)
X-FDA: 84918599682.27.A362039
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D5515A0018
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:02:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MlBeAgA4;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782396139;
	b=KsLMKrLjt9GGKSlfo7H5gpAT7gbgatG4301iv0rJqPQE8W4PAkCxL2Z4DA5oVSQPOfBYpC
	Wctp6avB+ONOS72ycV7my9jhB2bNzv3o2xyy/QTBmpOo5WUAiJQY2qeAglcLOZPYhO5Yfe
	sFjxZIiCNHYoV+K6tEDU8oeszAgk4wk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782396139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6zdmiNOAqKGX+1vgc4hu5H1gHAK96iDAcnyfbkz7XMY=;
	b=j6LssszXPcUsrBjyy9lz49/7bmtk5Kyo2vrb6oVlPOgA5dKbPv/ZKwQSG4ieb6vLtJp50j
	Hr53SZL2QnrdfS5aG3+XNcBH3dR7mbl/rh1D46zJOk/ebMr0UIt5itekVL6jVibB0gmCt8
	BzmE30eZHuYktmZNhokflXKIERqSd+U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MlBeAgA4;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CD7360018;
	Thu, 25 Jun 2026 14:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588801F000E9;
	Thu, 25 Jun 2026 14:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782396139;
	bh=6zdmiNOAqKGX+1vgc4hu5H1gHAK96iDAcnyfbkz7XMY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MlBeAgA48j8VO5jAtfgWxcnZXQvmNu++VkSIk+GO4CuQ3EjcyfQL2cdB/WkkIhEZZ
	 c+YqxP3WVizDttlHHqvUt8x/C+u/3BEe5DQF6KxF+rMmCkKG95Pm8noaiIXa9H0IKO
	 7mEjaEGdSkKi2Gi93UGMHyqUtGCAMUZLotM2kFxilG0oyj4V9/NpDx0C41YO8vpweB
	 OITbE5pIxQRfYoq2u18S0dalW6Bu6K+Yogy0cDSN1lHIDoZJNNnYaQADav1Ap6LUjd
	 Rw5zapoN+gk1mHokPVxPhJ44Yu92wJ0COCbkYejznwL4wlK8ZJmaS6jabZ6srHfqCb
	 1aMTJ9/G6C0aw==
Date: Thu, 25 Jun 2026 15:02:11 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org, 
	riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org, 
	jannh@google.com, willy@infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, lance.yang@linux.dev
Subject: Re: [PATCH] mm/page_vma_mapped: guard check_pmd() with
 CONFIG_TRANSPARENT_HUGEPAGE
Message-ID: <aj0zDKEJV35V4kMD@lucifer>
References: <20260624082359.2869-1-richard.weiyang@gmail.com>
 <aj0vjdBN-oNMI2yI@lucifer>
 <c66f4bec-0933-401b-bf2f-a1b2e256023f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c66f4bec-0933-401b-bf2f-a1b2e256023f@kernel.org>
X-Stat-Signature: 9sngtxi48dpujmfd3otuqy8uwipie99n
X-Rspamd-Queue-Id: D5515A0018
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782396139-306924
X-HE-Meta: U2FsdGVkX1/wIfMalglVtVmgsPg9VpqQgzBpg+0YmmN4cOYQSNQmJ3J0D5T/d9917m82KsYpG7NRmgESUW0t9v4SZgY/S34gr04FNzhJWB/ryHZqS+F8PjogZIi6wjRqDKarxT/rx/UmFrf2wFBC67FCP/LKtqB3T6v5OeMJpETTSkm5The7uROpXUsEEXkRseFLgr+WTIbv3eA/NlHkUbAQK52hw63cLcdomNICMb/m17XIEOgc3IlPpdMmOVXTEgJ0kyN7O+C79BCkNbLZl65OO5A2eX763ESwlLZxbxBi2Hkt7vp4heNeB1uy1zPAE7tX3VvpCo8e5VB42gij7yDtZlaqf9Bl8aFcf1kTkXSl5mQBnVHkjw09/sVHNHb1b1jDHZiO5wr6xxyFwFOkGXJuDPkeynHT8k42lnAm5AfRGIhDTCVcApcbn/ApLQKCyDqQ4MHsX5XnFGJh0KoE2oZczd2bJWrCPj+2eATL7opGEbTOkYulkTvtwwsvAVE3e4DHQcsOkDK2lAPn9Xgb8hMC3IY9hhW3VlF8s6DCT/8YmlEer2PWjfSF4oP+780ojH/veSmUnIN0iaad3c0aG2L5HLgrd7iScH6XPR9CPY8mCIWfS92HWt6PQYNHS3I6ONlvatHwWhe0kLGTC5bxdDLnVDF3q8HQ5fvp1aMwl+T94MuhGVggZOVRKHYqKPx7Bt38ejnV+ibK7ek1BEqL5GQBaVGyapn3kveH0f1pOWMeIgYxrXo5HEqrbp+ePwWP2qIgX6gQ/Wi7TRjV2IgQe5efRar5as0GZC/glGQTgrU0pZ03+NRAMjF51z1/9v8/2uNjFnwji8t5JURLotzupVHpz03FkOvHz9G3PKHbVQ8zUzhBUNShpyU5ibwRY2HnfT2a8egkPJp47HZDLe7lG6yv4zxSFNojfe/XRnfkMjzpUy5IG8xk7SYk5yPf5utEOCYs5rtqJqEiXA1XgD9
 05uWVLqI
 ovvi9Kmfgd1B5p5taBNZFw7GTLn3darRvrO9qv5pRIM0G5nDStQYdTwcMpnJGFTMk29KU3vLS5U8zdWUXFZYxlgNaMeBU4Q5G0TuYu73ztApSLM3ybCOKRW/uSObSyhzwWTO/VkP4/7g3i1S/m1HKkmdHK8Y9mCDwohLwzu5AKCj4DhPWyaBVOjIryfVomdNdpLPppLbqFVHQ8LusixdPs7fF73tuJugT4WaGv93w7zdemD5VxYLb0BCv87Xprib5EoW4/nhhmlPCgG1Tqj1nC5ImIwU5Iq2hXzyoz9jh8oETlFCGC8YwHKQc6Mv0C4X+deT/TIjy9c3fsjcuj92s+jICiKS0Xvu/yEDbZUKJEI0X7UZNBoclZFQiSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 03:49:59PM +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 15:45, Lorenzo Stoakes wrote:
> > On Wed, Jun 24, 2026 at 08:23:59AM +0000, Wei Yang wrote:
> >> The kernel test robot reported a build failure on the parisc architecture
> >> when expanding HPAGE_PMD_NR in check_pmd().
> >
> > Let me first say that I absolutely hate that we continue to support museum
> > piece architectures to the point that we have to make changes in core code
> > to accommodate them.
>
> I wonder why we shouldn't be able to trigger that on other archs with
> !CONFIG_TRANSPARENT_HUGEPAGE ?

I think this should just use CONFIG_PGTABLE_HAS_HUGE_LEAVES, since that's the
property that literally defines whether check_pmd() makes any sense.

>
> I think the code just relies on pmd_trans_huge() == false, and consequently
> check_pmd will get compiled out completely.
>
> Now, the report was against Wei's new patch.
>
> There is *nothing* to be fixed for existing code.

OK so it's a fix sent in the merge window, against a patch sent in the merge
window. Great.

I mean, let's all chill here. Sip some wine. Some brandy. Some absinthe. Perhaps
even some turpentine* for the connoisseurs!

Slow down a bit Wei!

You're sending a lot of fiddly series that require a lot of review and we're
extremely busy with review already.

Please just relax and maybe go water your garden a bit. Have a cornetto :)

>
>
> Fixes: 2aff7a4755be ("mm: Convert page_vma_mapped_walk to work on PFNs")
>
> is just wrong?

Yes therefore it is indeed.

Though it's really horrible that we relied on things getting compiled out like
that... nasty!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

*Obligatory safety notice for the overly literal: do not do this, this is a
 joke.

