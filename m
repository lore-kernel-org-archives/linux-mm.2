Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A081560A3812
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l+Q1RsYq
Received: by kanga.kvack.org (Postfix)
	id BF0006B05B1; Thu, 12 Nov 2026 11:40:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0F56B05BC; Thu, 12 Nov 2026 11:40:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB68C6B05BD; Thu, 12 Nov 2026 11:40:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8FFD66B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:40:12 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3712B1A06B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:40:12 +0000 (UTC)
X-FDA: 85427029464.02.5A1B8F4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 707AF80010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:40:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l+Q1RsYq;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/y7Uwn+oYzUTWr8Qk21aG5gEd4/XpyC+An9k7mgPHU=;
	b=ZD5qgnz9LqSMOotl7GRZr6GRKgOby9Pt8CXl1C4Gsce9iAFgndsHV8orlK8osL5DRygrHA
	LUxnufaD3hPCOSV+SSxzXj5tJFrqIvN/rmw4fl34TZ7gnbU48coTJWfbRBT58NoVF6T15a
	0jcG06ELkVI1XHNkLgA0zuwjw/sQzyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501610;
	b=kc6gLU9w0GAwu2r/qBdvZDaZsl2X9BPe311edR9hgO+WeMWLehTZsoSbLDPpge9FTFYE7F
	Rd/ydgGB8Mgbh/n2Lk2rxZcRoZvhcGqGg4Dh29f9L6kTFQhFyip3SgNNYnY8+wj6hqNX7/
	5WiB0+XT2OavsWUcG8bIGnNi85QHTzc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l+Q1RsYq;
	spf=pass (imf30.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7DE811516;
	Thu, 12 Nov 2026 08:40:06 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 232B23F673;
	Thu, 12 Nov 2026 08:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794501609; bh=OJf9vH/UgjbPnMOOD4wehtLjTNHfSY54RGcIkGkVj5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l+Q1RsYqmctClM4wHH70rhdR+HU8l3Kg7ueSQCCj6M/lsoXW/qFh42720oSelH2GM
	 JhQXQQCr16wIWjJDJ2zx1hNlB/x3J6qZhH1su+womvkbU7Ez3JFeN0hyByCHApTd3o
	 ZcLq8SbN47HvFupyhUkfKC4cIsm+8vL3/4W5TAJk=
Date: Thu, 12 Nov 2026 16:40:05 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Breno Leitao <leitao@debian.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] slab: allow sheaves for SLAB_NOLEAKTRACE caches
Message-ID: <avXr5f2pe5lXpDN2@arm.com>
References: <20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112-kmemleak_sheaves-v1-1-e40e3d73b253@debian.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: nr7pdio3sezftzr44383no8guhjih9cy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 707AF80010
X-Rspam-User: 
X-HE-Tag: 1794501610-37558
X-HE-Meta: U2FsdGVkX192RTuxxOdZXdMV3RcOAq4CWBL4RG7RMthKd4hFCvz2CD37jjiIesFiiNwlVK2e1BidlsRjKYl7V8Vcbkp3ZQOJ7h1ewpRyhQmF6yrFxKPLOGPbJVBORekeg7VGxvylu9Vml67cWoAoVzAo4rpDBeVwwA61sf883wRh0AqfIkVqAM+3zKrmd5um2Ygwtzn9aN50IMrdsc0N39hTHOZ4B6ZFTrkxh0i2NIj3QLdIg6vfKTlgxeY6ksXEv7KzQzMiEAwBw9QjtDkfyj0E0zVaYhMUx4tkYPWwA8Bp43l8DPIq4AnmZhiMDOsafF0OZjpJflWuSG1+EdMXJ1OYTOm4Rz5DtUczqt36OAT7HhniIYrR2rSbh+dwe8g6VOGtB1QA3qgEPz7AwOIACiTv7w6+SEdwX++Ev4PUqsEofBDocs526IY1jML9a5bj1j3IegUT3QDP+b8KL1+tamfmfNEhAdrXOGsGSFDQM2qkfh3yOMb0J1EcVHjxmhYsE9f1lQyg2ySG1l5ZZl/maaqx0dK2QLdAO0pyjp8YYAHc+h9Vw/Ljj5Re+8zmgL9m/hHdItTPbOP9F9A61/qWEjbWUo8Xr6N2ywJeeT9ehJ6X8LqI0Ouz4Rzrv+WlKveUtgBrcprHp2u39Ivg3D5hyvsLLlw6W4TiMTG7m2KtO3uKZGWm+oGL9TPRKAu1MZLPbf4FWHAZrXHtk9UdB75Pio9YWMEgrjRs29GS8g0ruPXgDU0q1DDp8nsYkQNCGKP8uQK/9IDKBWRFaafsCwqENSiWyGvbI+ezwbO1yjBryo7GaeANFd+64pfWpLk/Ve35qNpi8lPo/ZG+YTGNMEPBpKQGfQaGyFggGj7celm+vXA1Y/W8QprEPxL1smT6mv2757F2RoKSxxXC0JWYEQsItqa9TQTLygqIl22TNY5tzoJxl6GKN88rEfaGFhOlLq58WYUxnwixijqvAkiz+Mu
 sffYzUAE
 0DkPd0HMuEssCfz5IFMJdem4DqFQyEiP0vr0i62dJTXInvcscJ1pmlnY192+x7K0wv64fxqKBGfIxf1+fEVDZK0I6vvYsket9bkJ9FeWpQaagSHPRRAyIu0GN/NJfDPZBy9byjal0Idsz7TFNZyOhVVPUZa4kbcncG5dyHXvX8+958R2g04UALXNTeq5kRije4EVRo7uKcm+a4cj40Aa/7RVnya7e8uGaEknmHM6ua3Ok4Af1Zv0dY4KWmnY2lTLGuxD+0mz1j0BE2iU+hFeHGRlSlxFkufjbcuUBC1vSZ1oy+N7mAo/COywA4jUmH3gfRSmu980viUCDigp51pMqZ7r+rINUxkXDyjZGr+xEL+IQz6rDjitoV36oBH2QZO0CuBzdmD79njZVlnBZHlKKPiSMSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 02:04:18AM -0800, Breno Leitao wrote:
> This is a patch that makes kmemleak cheaper to run, by letting
> kmemleak's own metadata cache use a _new_ sheaves type. The flag only
> makes that possible without recursion.
> 
> The cost today:
>   * every allocation kmemleak tracks needs one kmemleak_object from
>     object_cache. An RCU callback frees it later.
> 
> Why that's slow:
>   * object_cache has no sheaves, so each of those allocations and frees
>     goes to the shared slab lists under n->list_lock.
>      - On meta's fleet kmemleak kernels, list_lock is the second most
>        contended lock, after kmemleak_lock.
>      - About 88% of that wait is RCU callbacks freeing kmemleak objects.
> 
> Why sheaves aren't allowed:
>   * a sheaf is a kmalloc object. Tracking it makes kmemleak allocate
>     another kmemleak_object, which needs a sheaf, and so on.
> 
> When I reported the recursion in [1], I suggested keeping
> SLAB_NOLEAKTRACE caches away from sheaves, and commit e47c897a2949
> ("slab: add sheaves to most caches") did that. It stopped the
> recursion, but it took the sheaves away from the whole cache, although
> only the kmemleak tracking of the sheaf itself recursed.
> 
> Commit 17c38c88294d ("slab: remove cpu (partial) slabs usage from
> allocation paths"), from the same series, then left these caches with
> no per-CPU caching at all.
> 
> In hindsight, skipping kmemleak only for the
> sheaf itself, as the new SLAB_ALLOC_NO_LEAKTRACE does, would have been
> the better fix.
> 
> Link: https://lore.kernel.org/all/aW_NK2NXVgtuzCVH@gmail.com/ [1]
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

