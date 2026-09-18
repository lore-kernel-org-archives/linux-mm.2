Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85A7EC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695906B0099; Fri, 18 Sep 2026 11:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61F1B6B00A0; Fri, 18 Sep 2026 11:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5107B6B00A1; Fri, 18 Sep 2026 11:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A70D6B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:44:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 561EDA0714
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:44:46 +0000 (UTC)
X-FDA: 85227305772.28.35A970B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 873534000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:44:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PVYDC95n;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F5GxhBi0EfK7oYbT1liNeUQi6p7p1t4bIMnqIiho6fI=;
	b=eP20tj6TRYdTkAtX47T0yuDvwSlfK9CrNNO0CVGw4vyvPJ0HzoTai9sX+rUycyIkkFa3mG
	N4sVV5Hyaoe3XhU6BdmWDgEBYarKFd7898RIgFpvvEvLitGroPzgFDyE7coBd6iniUQIzT
	rLjfmpyu6sM3VxjJjTPrxqe4QemWBCk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746284;
	b=vUf5Jj/XsseBuZpvWZPYL7zuM9zeeSW29IcIu30HhSfyzEy1DVdS0bBM5Jpucz5QpfiCd7
	qnP+DJb1NEdp+c0iIc0JL2Nb2/hW0Uqh686sUPHvJYoulGl4p9dgdLgtlMK/woo8hoSy5g
	9NTW9tbvcO+7cZ46wQGCgGIbCloESuI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PVYDC95n;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A85BA406A7;
	Fri, 18 Sep 2026 15:44:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304E71F000FF;
	Fri, 18 Sep 2026 15:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789746283;
	bh=F5GxhBi0EfK7oYbT1liNeUQi6p7p1t4bIMnqIiho6fI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PVYDC95njTGNGSvrI17qkadoaNvtm+GWaVh4lh+NpLDGAcI1tgSaOKNYRFnGebqTY
	 4INwLt2VzXTqAyc75l8cZFUHvX5I0La/UG933dRQz/sa+D4hafDTB/rNL92bx3lAfl
	 2snx0KOs1WrQoTcBm5I7F3gCB4lC9IO+mcBVCdIg=
Date: Fri, 18 Sep 2026 08:44:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org,
 pfalcato@suse.de, xueyuan.chen21@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v5 0/7] read proc/pid/smaps_rollup under per-vma lock
Message-Id: <20260918084442.c95296b529cd8bf003e38bd5@linux-foundation.org>
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 873534000A
X-Stat-Signature: 4ncnetwfrchn769taf8tazoj7xw6hes9
X-Rspam-User: 
X-HE-Tag: 1789746284-230408
X-HE-Meta: U2FsdGVkX18lzzu6lilhNXYueoGAembulxk7uZqp5BD69CCgaysfpUh5mZbxV4KL5mopZMw3nobfkPg/LPA41n+TB6pQds2lgx7mTsP//Jfw/3jV/biutblDvjmXda3ky6wboDjBCDZtO8VpP/kWA12czpEfjs4W+6OywCS/P8vET/ISWPwxXA6xeqvj64iSKyR9hhMMI7LcE4Pv7BWa0fOhN80cNX4bojrVnzOYKw/tCw+zARcdB3Lb2BlYKL+X/Wnze0Jctx4FFPwS0oOqc8mN0I0Rtck7LDXKIshHZOf6a5VXfqJ6b3dHZqL1RiSoe70ewyjQq3syt1l5ircBngZQtmzp9Nf8Ak363p2sXxTYj24L/yQwAFH6TydWiAmH5fm+i3i1RASpv4PSUzHWPWnZBOYaK1H/w7aBk2Z57lUX4I2r+9kHdoxm05mtt2/B8TJIhjfN2R6hyICKUAYdlP7ABa57FpUFbiCbqiBBPdjGh+yUV+iF7UfR85vxq/Iu0tEgdT6XRsou9iKQ/SEeIXyM7+V5f10ryGaW6SyKg2DdyHxKrSEV2gr/BG1H2/CTAg5roKLajV160ez7Lhoik4v7DBR3BImehw4sZB9uG5jWJkPhnYR6aN1mnz7N1//rg2iLX9TLC+2Hq5x31+p//vZhfv2Y9+jkWvyI4NUQp3//9ozhkuv2te/1zYkLppu8BgrRr3XCyJY3ftEQBcWKG+fZiXfWDgTYOtazTxSNNlupiYpGgcAiYXPriv+PcLgM9RSeEBjAFn6tfO586RpQ4eUJaGhy/tfHWguUbvl1LRayAx8NjhMu3C8c8T8pfazH6VHonBkV3MeibFiDXPg84AixgmInEwGhN7437aAhxYvUNzrsRk2+3gkAdfe8g2RT+p5PfGos//o7Kdga/AZ4g4wSpC+U8GzkT7mrZsxy52y3XsIUaiCZTFRZEfN8zBuSOqkn3j5ESel60qbj9kc
 0S0txq62
 +CVKfPdE5L5zXPVcfKxv/1ChosyVKQ8IjyczQH7ZuPonStISj7QVCgrPF/fQlzUoFiQTCoGMxIpDTxtQFlx8RsW7INuwbO93DJ+11MVgLqJP+TMexQfxTEY5s2vjPwXjeAtGlIHcNUbFswzjfTGqSTaOOSJtAXFy6xwBLKAPzU6TIoRjXYd175kXE5THYFSPSr///iO+NY5xcjDmI2HGEDp1zdS+GgXkuzG9dv600AExqAgBcdBn8CeGPa7tJ2ZyjPyS4WbbU+CKKSUeRVE9wCqJQXG9yyOuZuwR8nDMjMvMMYaQAn6F0J/O1rTVAYOj/F4wlxVtWFby0WD35+UUcDAQmp3jfPN/QEu3GCD/A4/TphY1a0Z+qh3U1twJHiZ85NpT7WHMS84lmfamLtNjTZzLiPERk+SYcgXzSIo0J8DHbiCQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 18 Sep 2026 08:33:11 -0700 Suren Baghdasaryan <surenb@google.com> wrote:

> proc/pid/smaps_rollup can be read using the combination of RCU and
> VMA read locks, similar to proc/pid/{maps|smaps|numa_maps}. RCU is
> required to safely traverse the VMA tree and VMA lock stabilizes the
> VMA being processed and the pagetable walk.
> Note that we have to keep the logic to drop mmap_lock on contention
> because even when using per-VMA locks we might have to fall back to
> holding the mmap_lock.
> 
> The first 5 patches are cleanups making later change simpler. The main
> change is in patch 6. Patch 7 extends existing proc-maps-race tearing
> test to verify smaps_rollup content.

Thanks, I added this to mm.git's mm-new branch.

