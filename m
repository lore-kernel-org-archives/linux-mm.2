Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10828C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:53:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021BB6B0098; Fri, 18 Sep 2026 09:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3AE66B009F; Fri, 18 Sep 2026 09:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50DF6B00A0; Fri, 18 Sep 2026 09:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C49716B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:53:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D9ED16068A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:53:06 +0000 (UTC)
X-FDA: 85227024372.03.8F8AA86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B34C220011
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:53:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f97FyMau;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f97FyMau;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739584;
	b=pOkRCnsF9zOtg0DUhcPG3sOqF+9RNqnyS5ZFIz28Sfu1wCv3X6K+TEh+NeGBIwDM+Tb7DC
	NQBClSaqIOZmw1eJBY81h+MJlp0x8tIOprhzqlCWF9BgjqG3yYRMq/Aue8ts0OlycOADQt
	zEb1gXLn2KdR+lhCLYvQ0j1pShVT/7E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ofE/qDb5J9ar98eMmtKZuvLhg7PBCT+/uutvWytlvs=;
	b=Czu5Bs+kFVsFkUBn4f3PyZvQpa85SDyaya3q4PNnYhy5UOOOLMAw+Zbk4BmZHFed/4Y6cB
	bSqcYg0TxzYBHons18K5R0/H0xvO6tNgbGULAO+lhgwY0jhMF9TgE8MDvMMHE+2C5FIF3x
	v/Jes7W+X43s1nT/VwUI0JKI/bGzkks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EE36601FD;
	Fri, 18 Sep 2026 13:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EA31F000FF;
	Fri, 18 Sep 2026 13:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739584;
	bh=0ofE/qDb5J9ar98eMmtKZuvLhg7PBCT+/uutvWytlvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f97FyMauyGj9dmrCQu8/VUgHVsqfD98mB3R6ooyXX6zZFElQVoVveAYDPw5FmZncy
	 n47bYrTrUw8mQJaj6Lv4gRI4x5JRZWzhYPrIfypqL6H7ef9Azgsx/9agLBWk8/b/RG
	 N5GeNQxoniykBE0BKv+ZA39TBtklWqviLDdCcANZ0jvuDreb+PPMTJXL/QWCXA1s6z
	 +B9pVjrRDFEpRQKtvptO5McpD71THnklpX3j9HGxGzV2o0Ti4LtwG5N7xkhNPW1vCa
	 0Rt+JrMFZQTTC6nF8y86RphpvVsc8Q2IDTwYStn1XDYQCb20PBBRNDTAZLVanIXE0G
	 bLTbRvWWJHx6w==
Date: Fri, 18 Sep 2026 14:52:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@suse.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, xlpang@linux.alibaba.com, 
	liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, chris@chrisdown.name, kasong@tencent.com, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/1] mm: memcg: don't hand out large folios above
 memory.high
Message-ID: <aq1CIf0BPWFZLLmH@gremlin>
References: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260915042546.279410-1-qinyuntan@linux.alibaba.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B34C220011
X-Stat-Signature: o9fzw7i61fafwqezghm47hbiy5kr1sc1
X-Rspamd-Server: rspam01
X-HE-Tag: 1789739584-112490
X-HE-Meta: U2FsdGVkX1/PNuBELRRv0xJIf4GBVdy0GzOtuFGvpv+ZAxY7mqW7uoiseU/7wjhCJ5q1QDOYl1hTftGk0oY01EprsZHCi+rebDW0k5msuGWZjqxv435afFy4QbnMQoutIWXzqe9pZbkD0fqNhBOd3u2lN3owD55a0+XtHjvUw0vL62yF9nekh8RtuFcFJaETGOJDX5L+6QyeD1a8DC3s8EKIAaBQ3a7SegkgUOy2iMNGdzCkEfwI+cQQ2oup6Z85waPFAr3wBgKCJRkS3yz6keoTmqFqgxXzFmpQIlrsRT0cQMPc2yB0XkXQKu3uhJC+slDqdC0t+mI5WsLRIHy2Usg8nSb2Be90yfGW7oBftAIF+n6otSB8IjqlMgw5Zwi2vDzHTIKTVeGqxyhOpPn4o1O69ZRoyaNwlz1msQNHEOSp5QSgdDp88SPjvXjYDnhSHkVt4GAF9sHf5Uwn4TsT9B6KANhT00MSaDJx5PtDn8GiONHK2I2VBq6ZfbLGUUULrFwJTFUsiLOz7zlBZraLbALhO6ZUF0k4D1Ia79nZfnI9Bvj2JnNNI+esF8Hlkq/xV3yfFpC4x+MlCdA5PP3S8+kjAtkXkd0+gqTBadQJOHbS95FGpCxvm1TOHSZzMtJ9fIDVbRnkp2iRDS3l0dNx3bMmcltxLGqasv5ifnNivWnC7Vj3C/fm3bh1H6QLyj/lV5LaAJVRs0pBSUcgReguZGMBi+t3riO/ZG8SsxALWM7ftw+bjaQigXy6WxVugiyWGfPYMffAYy5PQCXsYO4TpIFvahG9UYeRQxjlLZ10XzTK/6b/i/uUWW9HtdWbS9ILiEH66FWTccelYblcexecxPHmBuGK0YndhLll6BT+5t8nrHYFj0f/U/XkgRzbO7iPU3NDYJt7dnXtXFEGEu64J+jRZ+iul8fdFX8XYsdfwfsyAJo2gA99wePErTr/4kAFXz/GhrMgD0HoQJem2K1
 V8rosBde
 7A0KbJOwmuf9QeaoMsJ6p8hElgvJwHDAXtQjwgsQzIR88TpcEjhu1xkKpMZbxPTsHKA54MAS0i5sj0BdwhbW2l1Us8ilyhFEhLC673TX4r+FNackdGA0Rb6u9sQsxRnR4qNVgxAHp8luIZFAyZMTOPlSx4dFc7Pm8g9OZLTXTzSOVDcSMA+beq5NznZh5KzGnTHbT96+8ZXBt9+RZaC107N/8qx8KFB5vMQ34kKcWqxJzz905GwPS5Qy1b4KGC2SO+2nnARs52xRkhLsSX1qEI4QsAVz5rE4nGnjrVBS2C4mEQ+I=
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

1. Patch series with 1 patch sent with cover letter

Please send single patches without a cover letter.

The easiest way of accomplishing this (+ our preference) is to use
b4 [0], otherwise format patches like this:

$ git format-patch HEAD~1

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

2. Missing cc's

You are missing cc's. Fixing this is easy with b4 [0] (the recommended way
of sending patches to mm):

$ b4 prep --auto-to-cc

Alternatively, you can use scripts/get_maintainer.pl:

$ scripts/get_maintainer.pl --nogit-fallback <files-or-patches>

[0]: https://b4.docs.kernel.org/en/latest/contributor/send.html

Specifically, the following appear to be missing:

  chrisl@kernel.org

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Lorenzo will reply once he has dug out from the pending patches received
from other developers.

thanks,

Lorenzo's patch email bot

[ Idea shamelessly stolen from greg-kh ]

--
Cheers, Lorenzo

