Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D91D2C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 10:26:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDC16B0088; Mon,  4 Aug 2025 06:26:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48DE46B0089; Mon,  4 Aug 2025 06:26:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3856B0092; Mon,  4 Aug 2025 06:26:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 241726B0088
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 06:26:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95B09BE527
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:26:05 +0000 (UTC)
X-FDA: 83738694690.15.D72FD71
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0126D80008
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:26:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754303164; a=rsa-sha256;
	cv=none;
	b=bu7fCOWBpeZFt8/VzBaByrvJUcFLS724GY+a3lTftvAiQMQxXFXdo7I76Js5CWdPYkMP+u
	ipgL4tl5gHCxjNOz3LEueKQV7/jfB/iYoD7C49N/uOZxlFCSL/wVKKLnR+6T7Xi33VTwU8
	0Uy5EcZgGYv0UhrHgfYORIQrVAY4zX0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754303164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=diL24rep83d3lVNZ3Gwhnjk3BqrWEfTOm7v1U4jrR1A=;
	b=wBp7ch8lXo+u7Yf93KjlQaiW9RfQTp9lLBLsIi+tyHew9a+pwCeuRZGOeOmI838JgL1JFB
	4aMc8It4ZgZFR5DaKWrSHzRX6IWhGowU+T2Z7Tt7x8FRpBqkasVWbQinWtk2i54VALpSKq
	c3RgMIG+FfXMXVDUpSF3+bdp0fmsu90=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C64D60008;
	Mon,  4 Aug 2025 10:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748D9C4CEE7;
	Mon,  4 Aug 2025 10:26:01 +0000 (UTC)
Date: Mon, 4 Aug 2025 11:25:58 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kuba@kernel.org, stable@kenrel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: avoid deadlock by moving pr_warn() outside
 kmemleak_lock
Message-ID: <aJCKtmtus770t5LA@arm.com>
References: <20250731-kmemleak_lock-v1-1-728fd470198f@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731-kmemleak_lock-v1-1-728fd470198f@debian.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0126D80008
X-Stat-Signature: tmtbdg8osaw6cyu5s3f9h86ms4nzoqar
X-HE-Tag: 1754303163-799977
X-HE-Meta: U2FsdGVkX1/UfQmUzCglQ705yA6nXbocgxLJ5NQnQbTCC7kbfjGpda//RewHYU/KTbAvPlS2RqoAwCWizjpenIm3zFhjQXerU19wmFbVDn/6ZmreKCa77czsooYRC90pkEDV/BczvNYMQJZHN7p4nz3/cGSZtjEKEbocII2sdGensQjTr58Vjltl6Cn63fLiB7ALrmHnYjPhCgU1o2lL7ky7+nKyLZogY1p5YZbcn+97/fkwGaSIHjV+i6WHWAFS+qCHIrTli/+vS7r4Oqy7dFQbXYg151SfTsMzJJfFgnVzelC6ajwBF54kZW5HAseLBmBUhcdR6u0SAFKW/eXZoabiGqxOGYfQU7u1QZbreykEHEvDqj/s8fXc/nyfauIQzKPFvXVe7EU84vpEulR02HvgF2TxgNclHgHeFzPL7s3J+8KWe3ew13Ae7I+r442lD7BLsOrI2mZbg8nAZOkUbwvnsPzh7nmKrqIkPC4fRna4Ls+pW9nZjitlnk/mRNNuwIOhh7hpjYnrqEoMp2nzz30QQXfYmQchUd85uNlP7M4qYf4qwPI4rXVbrcPS//duEt9cv1GaGyo/O9knEUrtzO+KzHtg/Sa2yc/TUbm6WFF/8E/Rz+XZthFU7qi/OneiIpo1589/yOgGhjyNCtM/gJuBGZ3G4j+dQLtsATkMFc7on/JYiM/b6zw5DDcNITG7zL6TuwlBkF6vFwi6t7rZcJeJvvNIbsNPAFXshVscIczIMsUHt1Hd0IqNLMNYDYp5Znu2mAVypBrIiNqwo06Pp2srH2IHV5czybP+BxNYoN7EwxiryEuPpGuRhdqT3i8Gk1SBeuDLD5W69QRo6NG2W3NkC05t6x5aD+iWbkhY4FsQbnNxGV+1IHECWtH8XDw3W4h7Y7pxrtp0gXXGhosQB//m6iW0B7AGb7tqDolwClrd/MrVSrk8e8SENsDHf9jgKyjARhHUG1W+z1nE2vV
 kAqfqgv2
 3cdgO/VNaDbLYVQO171bUKToO7F+dTZbTMHLaS7Kc6o6UExRYPAVRFAnSp+aKkpLdRzcQ9soTl9P9QQ+BMm0K51moU99eI/D+kGIUj46lGKJsub/dFoA+DZKcyzcUODqAaafENS5H5NhF/HaH/0ufU0hg1m10poa8xRAOdBaoIm+OUxba4TGeDmqsh/jLvqCs6OntfaTtsP4Q7Z1FDyQCL6LhYitdUH++Z3GX3saTuDykpK/K0yIhtM/MeI68Y6NM1Ow8yNdQcZvXonPAUEe5ONMIFXOQT4U29OiSsG4vQR5bAAPFTKjEyIEf2kg2J8o3Hp2mqvc7Cda5HgejkTkBwEJJimQADVDdfPjN+WWhTAADwOlFLQkRnGO1HGd55Q7UXTvos2z7J3gHvst6C/TjBTz0EI+ZyAFWcDNNMg4bcQHSqG6BWiJR51Tu3w6Vyc4BQVs5nXMGq3g7HV0sZqMwol0vByAsljJKvjZ28Pqo3wbMgvdO9aJipzD6eQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 02:57:18AM -0700, Breno Leitao wrote:
> When netpoll is enabled, calling pr_warn_once() while holding
> kmemleak_lock in mem_pool_alloc() can cause a deadlock due to lock
> inversion with the netconsole subsystem. This occurs because
> pr_warn_once() may trigger netpoll, which eventually leads to
> __alloc_skb() and back into kmemleak code, attempting to reacquire
> kmemleak_lock.
> 
> This is the path for the deadlock.
> 
> mem_pool_alloc()
>   -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
>       -> pr_warn_once()
>           -> netconsole subsystem
> 	     -> netpoll
> 	         -> __alloc_skb
> 		   -> __create_object
> 		     -> raw_spin_lock_irqsave(&kmemleak_lock, flags);
> 
> Fix this by setting a flag and issuing the pr_warn_once() after
> kmemleak_lock is released.
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Fixes: c5665868183fec ("mm: kmemleak: use the memory pool for early allocations")
> Signed-off-by: Breno Leitao <leitao@debian.org>

I think Andrew already added this to mm-stable but, for the record:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

