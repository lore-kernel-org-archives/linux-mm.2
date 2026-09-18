Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE15C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9259C6B0095; Fri, 18 Sep 2026 09:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBF46B009B; Fri, 18 Sep 2026 09:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812816B009F; Fri, 18 Sep 2026 09:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 681106B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:55:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1A7A12068F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:55:01 +0000 (UTC)
X-FDA: 85227029202.11.C6A91F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 44BF840007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:55:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/n+9Ysn";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739700;
	b=2qOan6gScnKLxdfh2pkN5XbGVfD6vQXZgHvIo1cOPqmjLaEdjvQl+SNo1zxJ7ukfzNCZYP
	6CCJqGiuxlAV9YfNhxih4IplWPmAt4g626Dh8wE1h+6tSpYvFKkEn54s9OfWhwibzZY67y
	mXnyqLhjkEapIQ7rOywzvosuJvx6/l8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/n+9Ysn";
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuewnJ4cX6K+cdzYuqWn1gEacAxYr+xkLgLUiMzhGVY=;
	b=ib6B9Vq0+Sb5b8+CQkWzQOgZmzsFVUD44xwgASm6HY3eOjMYukULGIJGnk0NkRxnlomUML
	dmk86bTJAfOrBD6Wavw0SHKOmzZQQIU1hUQc2vVOIgo08PQ7nXoX+ubDd27b1JI5GKyp91
	3VWx1Af8CeI8FnHdUw/2QNx+ZoZ+TII=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19E4F40C23;
	Fri, 18 Sep 2026 13:54:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596EA1F000FF;
	Fri, 18 Sep 2026 13:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739699;
	bh=SuewnJ4cX6K+cdzYuqWn1gEacAxYr+xkLgLUiMzhGVY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E/n+9YsnFPCJNQYhI2oLS7/TbIxEkc0E9Ejf8j1jZFairtOUrDRIoAuGEEfpmjC25
	 bxYiJwGFBakQUFKjH0nriCu5ra1qurr6rpigZhwxxL3E9JTlAe1lNFeWvxvsNI2HBY
	 f7hRz+GKI/lZAl5ILSkLdoZakD+E0eZ83ZE3TX474Bk+p/6EYYviON/NhiIIx4dYVn
	 P3fOidp+4rJ397iYsXHX5npRSI0E7xsqee9ELH7sf/p1xYJU9BurR9NhH58gw5266L
	 c76NIBAoOau40lvcTHPw4zWzuO+HuRcGUqOYDc05QBigaZFqDp+/bF+rDUAvLT1UM8
	 MbrIIGo3sr2HA==
Date: Fri, 18 Sep 2026 14:54:52 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yuan-Hao Hsu <aa9736195201@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, liam@infradead.org, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Barry Song <baohua@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/memory: reuse the whole exclusive large folio on a
 write fault
Message-ID: <aq1CjdaPUg_Fos0t@gremlin>
References: <20260918064238.868-1-aa9736195201@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918064238.868-1-aa9736195201@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 44BF840007
X-Stat-Signature: xti6qdceibgjwt9593ewqpj7mywrsya1
X-Rspam-User: 
X-HE-Tag: 1789739700-656053
X-HE-Meta: U2FsdGVkX1+r7XXpR18z/awEy8lNV3sdu/HSzm9nSg6Xrj7XHnZYwiyVhF721oucRJelY5tZAzyXsyjRi5nIOgX6sGSSP8QcWEMRP7+G4ZDAhSc4v2jFmEnyCbNU6e2C3IqPQgeLhk/XdqLXUWcnQmC+uY02qeIoMDKWHp8kip5X4IvXSjXbPLzLo5UUCX146Jdq3rvqEe8nRd79usqJ/J1ih0Fek8vDPNUAYHAXc4s7uALqwTxJBQRb8h9dVYWUkQAxfEBOznAiFZXucermFPz8g0ls+P9UUfrNyev64+JJzICZxGvnxzhAIs4112451fokV3YNdtVyfDEvEJbAvKM1ggAwzpZmSl1ftvic7fyyCzfALW60HsP3bTzL5UB4mXD4VahtcBULRPJrukHgQ1dLR1EzwHRj5YIwNPE5Npklf40UhAUBVQaisf5qKj0lCTqbIjNhRmBuIW7VKpCtkLbgmXLaF8ee1iE/JDSle/usi0GGpzSrVByTkCNSNL2JSbaFLmHkEHbI6eJ3Q5toS+OlnMnwCK2Ek108Dvxq/zBzP8ORbzRSY3QCh7NItcabSOOe5G99vLrCTYXaSVDHm69kjixBd5exVgMAR96SM5uoneCA2V5QUPOv2lqjqWemBP6PcXzxslrofAK6dqmSPIUyEGpyYvQd9MFmFrfC7IGObNxY8gy3cLoQhJk58q9qyoNsNYnkp2sEcpK0E8cVRUskUaOFRoEb49r79PNYuiV8mEPb9UUr1YsGVyixZ4kihjE2S+bHa2Pc9elNoHitieM2Fqavel871LXS/t9u4lh1l2hbIJcBP8oLHjT7ScB1KVkH1iBVB/KisF16YHk4akQemzyYi8nR9sCtYwyXuv5SokZhzKHICr7qvR9L2I5j2nHGlVwGXqEAvWHfNTUcniCB4cMKW/eLsqzUlUcxhfgfqFb8alYR+4NrxLaGO/TGS9d5HOZbYkMcK2jyYpL
 0iD4oQEf
 uv53tYL5pzdObN+lLoloXJb+a6t1OWdj28RKPdhon/Iv5FgK1n9lRPMGnftHSg6F09dc5dcMCDX7nkdHVn0hvHOsJNAGLZzeOcYQUNAZ1DTbUfTfWui0wV4TQtAS+UMM/HktR9aKYyEgxuDh9FyRldPbVL8BlcIDeAmQDrNwFQm/yF+IWySV2SfmPzfKNgv1sBm4X8rZFf4Vbfldd5Pa/wMKV/vhpoMnYnuMNTwkwRd+rrnU5EhTTkfrtqCkTOMDjC5KW27IaOxrRgoSjQpzlm4mSWcIZGZRybgDJv7Nnt9tbXXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is the friendly patch-bot of Lorenzo Stoakes.

You have sent him a patch/series that has triggered this response.

He used to manually respond to these common problems, but in order to save
his sanity (he kept writing the same thing over and over, yet to different
people), I was created.

Hopefully you will not take offence and will fix the problem in your patch
and resubmit it so that it can be accepted into the Linux kernel tree.

When sending emails to mm:

For one of several possible reasons this mail has triggered an AI
detector script.

Thank you for using the Assisted-by tag to acknowledge this.

However, please do note the policy at
https://docs.kernel.org/process/generated-content.html most notably:

        If tools permit you to generate a contribution automatically, expect
        additional scrutiny in proportion to how much of it was generated.

        As with the output of any tooling, the result may be incorrect or
        inappropriate. You are expected to understand and to be able to
        defend everything you submit. If you are unable to do so, then do
        not submit the resulting changes.

        If you do so anyway, maintainers are entitled to reject your series
        without detailed review.

This change is significant, and you are a relative newcomer to mm. As a
result, I must ask that you provide some details as to how you solved this
problem and your overall understanding of these changes and mm as a whole.

In general, if you are a newcomer to mm, we expect you to do smaller work
before moving on to larger changes, so you build understanding of both the
technical aspects of mm and how we do things.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Lorenzo will reply once he has dug out from the pending patches received
from other developers.

thanks,

Lorenzo's patch email bot

[ Idea shamelessly stolen from greg-kh ]

--
Cheers, Lorenzo

