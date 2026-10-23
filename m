Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEC1606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 14:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jApyfLSG
Received: by kanga.kvack.org (Postfix)
	id 232096B0B7A; Fri, 23 Oct 2026 10:22:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E2396B0B7C; Fri, 23 Oct 2026 10:22:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D18C6B0B7D; Fri, 23 Oct 2026 10:22:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E472F6B0B7A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 10:22:14 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82DD44045B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:22:14 +0000 (UTC)
X-FDA: 85354105788.14.414546B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EA5511C0005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:22:12 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jApyfLSG;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792765332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HfmmYlqiiP4jalwWqUANyRmxPgjfk/Z/q+o2q0RLes=;
	b=pXdj5ueIebNRi6e8IucYlZMl3GFaIjv2M11vKveVcFyFzgWOurYKurFGxc7LiRuc0GYRC2
	gxH0S9qBSCmVb7JZjIXjsYeoCYKw57YRKEg8GJvzC+dnSbE4X5XqcEDmOIrWiD9l2K2fuL
	oyq30gMTKzWxCWVq2CYqmmNXCBM59IU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792765332;
	b=lo/cT3CeXd3AKGgMV9d6UwSkd4ZkMlHHcPiVrwUXzQGH4FsoihF4c9dSbOjAtvnHV0BXYq
	Eh8aR+dduN4nJs+rb0TwrjZ8rpWS8xXNg4EfxQeBroDStY1kvJsa1YGOhd1wrSLPZh2N5y
	JWPDqyVoSf4naTz1f2yNV0NhZaz9708=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jApyfLSG;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BD7260142;
	Fri, 23 Oct 2026 14:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE2451F01825;
	Fri, 23 Oct 2026 14:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792765331;
	bh=/HfmmYlqiiP4jalwWqUANyRmxPgjfk/Z/q+o2q0RLes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jApyfLSGiPS84kYB+liZcP1w29V8W514VORp+A4UcSvyS/iAQfrLBszs7g9P9qOCV
	 ytH2FXO3V/7w+sfVM3aloQgb7EGzbmmvB67bcaTEEf5XfxuxMMvcJ1oSJC0QnvWxoL
	 ws29x8lMfdhpzaKbKCC7GlrTR800w7yUMURB6BUDqIW+KeVuKjrmT04HLzPK7lLNqt
	 pckImXTFhuL+QJTur40oNyPqljxzH7cU4zOHAChFQkOuTLLyR+YP1XJ1ZyO4xNJtA5
	 DPwxwemSUnnc+K813/P0Cm3c73gF+JSuNu9WyQVjfEFK2jJ1oygAQ1XCeUAF7rXCj6
	 kODTzJ5Cw8OGg==
Date: Fri, 23 Oct 2026 15:22:09 +0100
From: Harry Yoo <harry@kernel.org>
To: Qing Wang <wangqing7171@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab: only require the requested size when refilling
 prefilled sheaves
Message-ID: <attrLy_Q-53FnjhL@thinkstation>
References: <20261023094401.2042862-1-wangqing7171@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023094401.2042862-1-wangqing7171@gmail.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA5511C0005
X-Stat-Signature: 5owkosgggpimwyazfsr5k8cufrmmocnc
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792765332-587357
X-HE-Meta: U2FsdGVkX19gkZAo63p4w4fRm92StVMeugXEVPUbTsynhm3CKFg1DFDeXVukND3xeb95QeRXmHzeGSdVM4S21NHgMPYpp0tPr7UuL437PhYKUaQ8T3dKQD1XX4EfT2lp5WMKP+B3qqHKfKruVZ7jXnuODWY8l7RD/CUdkEHaRAHekgvMAcGoF5+RjfUSldD0h6qXJeSjMuH/22VOejE5ZK/nBHJg1UHZAM4zb+CSe9vXe3zBnSIfIhIa8O21cF43qHCqup2HbDk4bPu5bHgmIV/Ov1tqGjzkEs7wI75ayfrEppNw8uLjc06LGpRiNP11qGzYXPKIxs9Gk8Dw6kVRU02MTvJmHiRcgshWTt4zVpm3/YdEsz+0d1zDanJfQbAphkDpZMRudRfQ3NvjR5gtoRLruuur4SjUI30xH5/VLmiMKWTXWHrLG6E0uJ/wQINn4FDf11WgWMeYQzzoUXI9TtrvjZbJ9drXAztKvrtjtBXJ5InRJfN/KCEbsqgrKytZOXZc9APJxRgSCX7TJTPJxk17yp7u6+4h9JsUNNL4/ZXaZuoP0S9hysTuXpg1UFYF42bVCrBmNUyujlVn9mTAyEbhccZMpeclSdKP1CKA2nrcT2WRQKdWL+PZvIshGD4pdB+QyyWhKRZZJr0f8VTGHoFsf76R6lS35ZFH7k+dN/hOKpu0Q4tl6KpBrc8VJaKqqJq8qcspfV4Vt+N++3pWC8vYkzNW9onAtkFbkAyndPthQwswV8foSYMfVs+68VwYb5i50S+9FDiZ4wNW2mjifUGoPRZbiKGfYz4y7YNQRtExBCHielfxOKy7lUCnDiC8TkufoItefZK84fTkWzrHVtwOdvyFPdLXqCPrsS28SCwzHc+bwT2X+Y7MoGFWwcHiSfZdbsvgRsxICe5SxvpdRrqoxwjIUipSY4HFhg0xJsGmbJdT9Uln8zWTQlRoMLeFAYN5KaWfZzOp++zY6kN
 hh0GmisJ
 xxGo3+H3wRZ34UJhN6pKjoDp90B6FZQOLHn4ZziyysN5SE5D+U77xM8QJn0uTTll3LF1intlSUe+QxfRSjNckRikk6YZXbpPNrbGtkm/zNMnOa1mQpoR1P1Wd5qmE28o6+MogwbcBuW24gQrKQbqPe5jBYFUe6e3W4gbeLihcBtWYH5GAeoBo9/ON/IRWVnD53JpocepIunvJmGvP0Jy78TyvGnsWUNHdV5v0y5qJUGHptoB8Fu6AXIn1NlTmRsMby52QRVqbVsIG0HbM6MMzQmm7/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 05:44:01PM +0800, Qing Wang wrote:
> kmem_cache_prefill_sheaf() and kmem_cache_refill_sheaf() only guarantee
> @size objects, but for standard capacity sheaves
> __prefill_sheaf_pfmemalloc() uses refill_sheaf(), which actually fills
> the sheaf up to s->sheaf_capacity.
>
> The call thus fails with -ENOMEM > whenever the sheaf cannot be filled
> completely, even when @size objects were already obtained.

This is extremely rare condition to happen, and so...

> This leads to needless flushing of the partially
> filled sheaf in kmem_cache_prefill_sheaf(),

It doesn't make much sense to micro-optimize slab in low or out of
memory situations.

> and may use pfmemalloc
> reserves to fill the sheaf beyond what was requested.

But the request size itself is a speculation and unused objects will be
returned back to the allocator anyway.

> Pass the @size from kmem_cache_prefill_sheaf() and
> kmem_cache_refill_sheaf() down to __prefill_sheaf_pfmemalloc(), and have
> it use the newly added refill_sheaf_min(), which returns success once
> the sheaf holds @min_size objects while still trying to fill it up to
> s->sheaf_capacity.
> 
> refill_sheaf() remains the full-capacity variant for
> __pcs_replace_empty_main() and kmem_cache_return_sheaf(), because sheaves
> on the barn's full list must be full.
>
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>

-- 
Cheers,
Harry / Hyeonggon

