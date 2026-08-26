Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C0DC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 14:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2E86B008A; Wed, 26 Aug 2026 10:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73B36B0092; Wed, 26 Aug 2026 10:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8BD06B0095; Wed, 26 Aug 2026 10:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99BB76B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:05:20 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BBF4A1A00DF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:05:18 +0000 (UTC)
X-FDA: 85143592716.11.7B502BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0B4A82000A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:05:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HV6638uc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787753117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=899z5FOtzHECz2XWsKWnE5Ec9BBHfzGqQfwyQYF2l+4=;
	b=KLgaLhoIu/hTkhSA2IYH7aiIZ+1dQKAbB0MSv5UobYzcqPmZ3UgWAtUpOJiyh0AmEvLRUc
	okaIQL2SfStt35uR3iNm8qM2lfYN25FCbKTmCdnJvtQbLEQEQJJoxCWgPZeDudjHE4GJ6y
	qybA/HENWFBVzrF4e6lCT5hnvYD2gEQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HV6638uc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787753117;
	b=FsYx5LsS/M5BR2X7KRRHdHl0rPOr/IFRc5vBS4w50r0uH6Op2E2GKwf6FnbXGTmLn0Wuqx
	2/ZoiYrKChDNGxv2Xq+LoGgS1yHDpegJuHcpIgL9U6C6wJ8TEc/w6YNaIVeAR6MRT5Ggmq
	23zKeAPixNZ1hgDS+fPzYC0zmrXGcgs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA05841E98;
	Wed, 26 Aug 2026 14:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9291C1F000E9;
	Wed, 26 Aug 2026 14:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787753115;
	bh=899z5FOtzHECz2XWsKWnE5Ec9BBHfzGqQfwyQYF2l+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HV6638ucyNINBTmK0lEdfSWSwq99c7H7xz4cYjXlLUBJZJ9WaqnhaWV96BDAiQzVP
	 UXUQTCZb+FeccxQm7e3l/m9wq9ffhXi/IGI7IDzMMppk3cyqaVMgU4uSdL4+NIaXQB
	 8pgiRfLD2VOZ0loBSfJcEC1z7bnc8VYL2m9N7I+0LgLsEqtvbghcbl4RWnoTDAtLG2
	 TQ6crBMP0Oe0QM8VhHRnjKCjrCjB4sEFVRC61H2XALqcPuNCxLK6WmK5U61jWTpmvJ
	 Jq2qcpdrT5LyRwyYAln5+OUEdcn0qRyF29arNK2LCYAt6o0Lb7bCRggqhcVqw2Twb6
	 ysSgGJRF6akAA==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Wed, 26 Aug 2026 07:05:08 -0700
Message-ID: <20260826140508.74447-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260826102413.8466-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jwus55bxm8cqd9z6my7yywjucnn6wahg
X-Rspamd-Queue-Id: 0B4A82000A
X-HE-Tag: 1787753116-54217
X-HE-Meta: U2FsdGVkX1+YtjjY4+vL6s+90gD56sWGJEK74pqxDVEJlNRStsVNGaplsDeQm8xt+A/buym/Q5DWgvsZbQS90IW2pOs8OFWmfCiNMcx0jwoDk/llx7OZ/BYlzic08/btuSVBpYs7lLd7QHO36h4Ry/UhMSJgx6/1bvxku8DgqXwFgcFMxoNp9wleyXwEpUSzevvNveZ8Pz7MMgLgoFBFS7gZXH86P8pZSNe2urvsdZKVmergFCcoeLXUjIV3uI+tR4TGr7VWZa3IzAUlFRHdUqn3BjA9/VmfNYzcQRr2ab2RYJIUfDLDeQBLlJFQJk0vDFtjxEtvTTFTQlP0zKcZteF6s+8drF5RoJfIqNtO6Q19fBQaJxl40momLGiUX+1JmAHuY2qUM4UUJV/Rz65wpm1GjdFCty1nwOXnb3771QnzGMzxWi4P/Z4Y2tXsejPjKNPqRK9xEfw/uT+JMaNxYCn+MY/S+WxX5dMN+v+qPU9vYIfAyTdoP/Hg5K0BSis4EXj8yPWboqdbs9RC8f0NeGSwHqtsB1RuPVszijltilRDdXWgxPMkjjCt9aorC8R//4lX2SS/nDhR5+AonU2QPN+Q4SUssyozKObQFa1l9wzIvdH0qfEzDJRTFq2uGm/sqpW2tDLco1kk8QC/0QB4hCPfbOEVQNq612REthX3C+ZZ3MvdPiQL0ke2ejBkgqJSoSe0518PkWiv8URJ+MajWzveaNoBAZ1sqf/NZ4EHjGxQZ/JRjDsBjtYZSzaQMfHa6iM/SnRQ+DgsYC1xfomHaddAAQjSNIIjQkhhdohqabdesjnsnHwCzxvEgt/RmgcIBRe+1sh+P+gAoSfMftPi1cP8OnaCZS5rBv+ton0n5EyKIl5Z5+iqWtQ34ThM1vCIrfArM5CdgQqS6rN0M0uQN4YmxeZP8C83BIXSTxNuE55k09YgVj9hlCn/mFMwwDJasxihsTHEPmj0LJEYPB0
 m6wk75tA
 dDvOLjyrWHfYJX1cC98Q2LVedllUBggWVVAgf2rG2Qe2wyLb9cLZEPPO3KmPZtJSa3jX7aKk4jb9HOFKdTyP+1z1ydj7vkmxZ41QIhhut4pXxXU4BCAGLM1OoHdWHV1WxvYTBn2swyvM5vcJNtIV2fCGofXfK5Tgto68Kv2ucPNs525IVmexdNM5btgBXv/CexUX9LO+PfshJNbGRjPhNX2JyWZzI4rjvFJBvD3iLIjy/V+ZOupM5HODqBx39bulxvbrm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 18:24:13 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Tue, 25 Aug 2026 06:54:57 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Tue, 25 Aug 2026 20:46:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > DAMOS uses charge_target_from/charge_addr_from to remember how far a
> > > quota-limited walk has progressed.  The current implementation has two
> > > problems:
> > > 
> > > 1. Once set, the cursor unconditionally skips and resets at the last
> > >    region of the tracked target, so the last region can be skipped even
> > >    when it has not been processed.
> > 
> > I don't fully understand this.  Could you please clarify more?  Maybe adding a
> > realistic example scenario would be helpful.
> > 
> 
> Problem: Unconditional skip of the last region
> 
> In the current damos_skip_charged_region(), there is this logic:
> 
>     if (r == damon_last_region(t)) {
>         quota->charge_target_from = NULL;
>         quota->charge_addr_from = 0;
>         return true; /* Skip */
>     }
> 
> Scenario:
> 1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> 
> 2. Quota is configured to process only 50 bytes per window.
> 
> 3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved at
>    (Target, 50).
> 
> 4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is full.
>    Cursor is saved at (Target, 100), which is exactly the start of R2.
> 
> 5. Window 3: The loop reaches R2.  Because R2 is damon_last_region(t),
>    the old code unconditionally returns true, skipping R2 entirely and
>    resetting the cursor.
> 
> Result: R2 is permanently skipped even though it has never been
> processed.

Ok, makes sense.  The user impact should be not that big, though.

> 
> To fix this, the patch advances the cursor every time a region is
> walked, regardless of whether it is applied or filtered out.  This
> allows DAMON to accurately track whether the last region has already
> been visited, eliminating the need for the unconditional reset.

Sounds like a big change compared to the problem.  Why we cannot modify the
last region case?  Have you also considered other possible simpler approaches?

> 
> > > 
> > > 2. The cursor only advances when the quota becomes full.  Regions that
> > >    are filtered out do not move the cursor, and the scheme can remain
> > >    stuck on the same regions.
> > 
> > I don't fully understand this, either.  Could you pleae clarify more?
> > 
> 
> Problem 2 is a false positive.  As long as the quota is not full, DAMON
> will continue iterating to find applicable regions.  I mistakenly
> assumed in the commit message that encountering filtered-out or invalid
> regions would cause the cursor to stall.

Thank you for clarifying.  Please try to reduce this kind of false positives
from the next time.

> 
> This patch ensures that every target is traversed sequentially and
> deterministically, even when the quota is set very low.  I omitted this
> benefit in the initial problem description.  If you think it is okay, I
> will add it in the next revision.

What's the problem and benefit?  I still don't get it.  More clarification
would be nice.


Thanks,
SJ

[...]

