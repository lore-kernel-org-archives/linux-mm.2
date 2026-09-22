Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCEAC98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AD4C6B009E; Tue, 22 Sep 2026 08:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585396B00A0; Tue, 22 Sep 2026 08:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BFB6B00A1; Tue, 22 Sep 2026 08:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E23F6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:04:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BA891140448
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:04:53 +0000 (UTC)
X-FDA: 85241266866.24.17910A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1E386140002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:04:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rdc88kZB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790078692;
	b=PmzdgMD+jrIXSdVPICCxXUJmwdzCoR2XAkbIhkwi1hJ3oUlgYZITJ4scqOWQ8486UFO2eV
	e7wsJB1fxpWP8Arhc5IpqEZSNWTvaXiVMzPYRsF77B+6IXRF+P9OpeTGXHIr/rLqjH+bcv
	5N0ZYQOCao7hx1uXLp8FLc9/pbAvv00=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rdc88kZB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790078692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPElUD1AN4csYiU8Npcvuz0fDrD5UVMx4TQaxZOIV1U=;
	b=444zZOMPwKa9U6k54o1fFM3UcGIGPutRYjo6uoc78hYtCQFiFUEu14KJ/SFpy1DD04Wo9F
	zQHJQhaVC0zIe0HUCcJli73AnbK/mbqP8wHphE/HKfmsMr5DDnyhFVL6vnM4jTP6gZi27e
	nJbCdskUnwl5nyx/sqUo/GSNjL1OnbE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 977CC60E16;
	Tue, 22 Sep 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4611F000FF;
	Tue, 22 Sep 2026 12:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790078691;
	bh=BPElUD1AN4csYiU8Npcvuz0fDrD5UVMx4TQaxZOIV1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rdc88kZBDZlRiQhLJ8qJiemv599zvVzqdZ2VhpASPGaRkdknRUOSkv6mz6E61Ks4O
	 KxsEAHjZZGhhtVnhXCVwGDpjMyTxzH24yq+3GOAEPNcKyxfyRdmSmZivfu3Ep1eA+G
	 IzeqXLqIuXzUz5jiZPoPJOCuq2Z3sS9/In2em/s9nqEvIZ1AMnxUtg4YYDFU2C9B4F
	 DXVupjUSLyTLJ5TeVr4Oh0sF2HGBVlhyYSGhN6QDBj+8Kd4AzAoXqrEOu2NOF10Xtr
	 Uv4nY9OtDmyMIzLqNm3QMaw1qEqIbm0BMdn4aufc98759e7FYgW8Jt+tcdZBZbMnSZ
	 92YRGV1NSCIEQ==
Date: Tue, 22 Sep 2026 13:04:48 +0100
From: Harry Yoo <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH slab/for-next-fixes] mm/slab: do not wake up kswapd in
 __kfree_rcu_sheaf()
Message-ID: <arJuhiFk-XOg4Bew@thinkstation>
References: <20260922-kfree-rcu-dont-wakeup-kswapd-v1-1-42d7e2636f9e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-kfree-rcu-dont-wakeup-kswapd-v1-1-42d7e2636f9e@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: itaj6rnkhr5d736h9c4ysgpnbkqbynz5
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E386140002
X-HE-Tag: 1790078691-224329
X-HE-Meta: U2FsdGVkX1+K+Wh4Y9eZYIBBpeuQwZxYRn7S2uVIDI4zcoeAnSHPrGXzBS0n9BAQLOiNnM0vnIHOEpOHtvtMuU8hgGTfw34m6gdYw2D3c8BSvYjk66bTRiukafWz7bfhQEtCsWnSVOx4EsSvzgOtobejcptv4+JJUuPfC0NLJNUbr0IeR7oVltmTrWbSjWam9iWYbLUEEzZdPRVvNzk3ploGWAbIR5Yi8PrbiJsZet4bmNqNsP/4rxahR3XzWBCHhSTN9M0jKi9WkAkjmFKZb9ii83FEePpJhC3MC/nZWR5WUiXaWiohFyed3HtsoYyJgb/Toj+02SFM/bglcLjepMrW9Ck9BhYMB/WbPODoZrnFjrfRR9z/zvdFHW5kLK6jYg/V6EjscLpMwr+Co11PZqVokh0mUuvtfbr7Z4NNa0L7l/LjAvioKqNSyZl55EbKzLqNTBrawOAuBIzGD0zVg9SiDyUxG2+Ua9MmitJP+x/kONSo21HNN1x5CWGyIfYID5RMJSyUMmReJgq+FshO5P+WK9vDD8Inr3lbg1TzMwDciT0X1dV/MfhvnbGTkSM62q5LLPjVwkVin4Uy95W3fw+DUnLktxCP1VSRfhULAges2CZN8/XigVF2GqHPIvxekYC7rJrkbfzdH9PVHh8zBdflGXflfAmqiuHDv2pPGxdlwX1kRKhl3CYcH/HQaNPaYnHJZwHNEwq6IOEJ90h8x5p1FU0HJp59tlbBJ6VulW/r7ZR9r7+AbjuYJGA/ZzCZGxBie5f0iXv64j/Sqn/VdHbXbfsXUEuuIuSZNtXaF7Ys6HeO9c64lmzmmNIyr1Ipcy6WyUneJM6wdhlDwbM5sen75avHyhL0FPqZ6cRRMcwzvp9L51Hc6tiFrudLu5SxROrYma9JtTvTU0O2nnc3NWC0my3OSjNbHotFXbHYuLGAm+X3NYM0utsX27SRqYm0kJBak6GUctPcd9Cvkpt
 nmyqXHnp
 T5JUR782keoKm6XWpzA6Q4xCuvHrhMZ8Fl3qBglKyTVH8C23tMzlzV5iEbDw9G9MLZt1ciO5EbTPTY5LMxPAzc8uU69j/eLndrCFxUd8G3Hy5sem0JitWHKjnPkyrsyHBH3OtdwGZnSQ+FXTaFLn9PANLxI0U6ZKPP6bTLECApBUl76XhC+Y0txwSDrtWsWb9XKSf1aYE5SqpD25+Lxya+Q33A3kf/efsrzpLu98iwN2zkFsgC/LGCloo7ORX1+3fH9PouCppnX0Y8dCNpoA0I2CJtg51KA2eqyPdeLDJnUkUMhxf/qIAqMKQqnHOJlkohcRv9T4jZnUdmzkCsD7N6yVA7ynpFWTboQX4dUgCosYq6iTPqA7Ugh8KfibMC+FgCqUa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 12:56:43PM +0100, Harry Yoo (Meta) wrote:
[ ... ] 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/message/20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b%40kernel.org

Oh, the link to the message does not have inline sashiko review.
Incorrect Closes: link.

it should be
Closes: https://sashiko.dev/#/patchset/20260831-b4-kfree_rcu_hotfix-v1-1-4f0fb882638b%40kernel.org

-- 
Cheers,
Harry / Hyeonggon

