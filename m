Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54065C53209
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D7D6B0088; Thu, 19 Feb 2026 23:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320D86B0089; Thu, 19 Feb 2026 23:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22C746B008A; Thu, 19 Feb 2026 23:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0016B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:49:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD0A81A0A92
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:49:37 +0000 (UTC)
X-FDA: 84463606794.15.C50A742
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 486D21C000D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:49:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=alnItKrQ;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771562976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4clD1oP+RWxauJpYxliVouI9jYTcopF0KjBePvbepCQ=;
	b=LGX8RA0xGOTGw8lDTPytKyFqy6FTlawdB27x5mdpnRAVfRIWRLzkW3LAMnhXCDYCFg8pg2
	WQA3EeAo7dhDduJA4GKtNby16gyxjkkUxsN+zmEeCDvReTe2sCcv2faCY2LCYqPWlncQSs
	0rujZtzu9y0i3YFXvDl282vYuGSmiEQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=alnItKrQ;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771562976; a=rsa-sha256;
	cv=none;
	b=WAaBst0lE0W4AhQdUMFYNaAXha11KEiaKNwhzzm7lRaZaq04mgF8Ix1TDafSR+uaGd4REI
	PMi8gMV1diqwYaMEWos+PTZYJDEM31ZGW2BBe5eM/+G82jiNpcYXdX9+W5F4zt0izAX933
	98aOVKAllgcf/LZvDO7IrfIxVFk0rMU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=4clD1oP+RWxauJpYxliVouI9jYTcopF0KjBePvbepCQ=; b=alnItKrQeL0jz+SXvBVy2yrBfV
	ETTDZ1canePb7Wo8Vqq9zkt0Q5N39V7OXESlFgJ1Rp3fIHPbUcDAseuJAa/iUoOa2fUHXTJAneivS
	INhMs6GHhA41oaTyxypNK4OjIkEdsiCb9D9aI4WLxA2parzkcdBpiw4o7rdQC1DgvR98dp4q6NK0V
	UN7uSInq5YMlafZpC5ogUCYrBPbcQ7MBocFzr6N8g0/gW/DmiTDttUzDcMmAGBx1ddMYpEdloltvh
	oATOhh0s1XEssJk708Q3VKXE2V6IoKhgkeeHc34SaE5cHdo+4y5vivCn7iqelWZpoQO1eyrFe+ilW
	CI5aCxMg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtISB-00000008roY-0Sne;
	Fri, 20 Feb 2026 04:49:23 +0000
Date: Fri, 20 Feb 2026 04:49:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, lsf-pc@lists.linux-foundation.org,
	ryan.roberts@arm.com, catalin.marinas@arm.com, will@kernel.org,
	ardb@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Message-ID: <aZfn0tbKl_1JD-VM@casper.infradead.org>
References: <20260217145026.3880286-1-dev.jain@arm.com>
 <aZSHvt9Trlq7k7aH@casper.infradead.org>
 <2e68ef61-dcf2-46b2-913f-14980a104faf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e68ef61-dcf2-46b2-913f-14980a104faf@kernel.org>
X-Stat-Signature: 7pzwdoxe6qonfuaqbczj6b54rwexjgiu
X-Rspam-User: 
X-Rspamd-Queue-Id: 486D21C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1771562975-87795
X-HE-Meta: U2FsdGVkX183+cnOOERxC4r305VsSWB/Kz8IfWrhNtk/6KVx9Rj4sftXfZohuGsCEDyHw5cATYXOCCAfo9J7EkB+oL1EtPgAicvJRBAlPEFLwm3Hp7pTnAT6JACE+fwR01nD91LSBz8hv7P37MkfvHb3agZwSo5aytY1BDYE0hyrcgbyhRVqgIwl+F/7qbVXX4CJ80lWFWsMQa0stdPmJ1E3vnZUd70RbaJtz0kilrH9urU46SV0aSzlJR7GGMYwQqJA9/QS+faGRUbZy/weCAUbka9fvMjQaFrjwzPNq2ori5eS3fQuyc2Dg9Bb6kY5hhnc1z0DE1qpx1k59axha8d7zjKnhKSzeTU2PaYve24aRz/wz79l3n2ELBP6sqtoAdKvE5+3sEllp1IjK9t/HsKyaNp3qCnniU4lgtllo1dq4vEkBu+I9ApA5e1BMUQX8IKPENXfauTRDl4LUKd/Hx3Evyll+S879QV3ajSsWqO6wsMKYU4JqZJh1orZJU0Nu6TlJ/ydSXyMWIHU4HPV1FaNLwqWplVT0CxRgdd12el350ukiyG+/cBf1E5FQzxmOhGAJgMoQqD1Ir4ZwaUlvF57tYuglkxerVJ8qWKGlBxoUE4vfCpp1Y94HuaBoVgUY/odaBK0B2mwiIbjQSkNiZO6oTNSAAwGzrunk50NPKEUHYbHiV6h8v9OlK7N2iX/7vUr3VI/1b4OIWEkK3n95VQ4Vfo7R9XXH6eW59ZjOZMJ/PZ8JWfrjkglKWF/VLdROkg6OlYPn5l/Wj2XudysGVk8Qugk9RjZqCKo1NmBNN7l1zJzAn0Furw2ElYWqZhtgylgyGgYbHocQpAqXvOuzB4DA8uV4HMzGYRwWlgOxVG5cEtcVXx0qUha1tq7CnYKj6sFqOUlS47p9/etPq6w7KM2gG4X2O/75y/KXllTEJEdWfwoHK03JcWMn3oxl/zuvLOfJiwqeC1Yjsd9pQS
 k4Ya7b69
 +QtDaE84YkbbzWjCAcCxET6yuguWNKqUPRfiQsRumLt8UPxrNDc4dNrA92h5RvhI0AK0KJ/Un9rXdHO4OI9Sl/is7PNTNtcKRAseKAB4DfR2EshRgPJAlpSPMx4BIZw5RVZDHqUjMGVqsKsN6DSTG9IZdawKfWU5/aKsmEtxrTsRzCU0fr0hPSRlv7wvZQdaioW+eRhZgNrHMwHUuJVHi0qnHW13PGKlXct3A8+ud8D+dre7pBiDzN5ka1EiNPIQY7wbl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 04:30:59PM +0100, David Hildenbrand (Arm) wrote:
> In a private conversation I also raised that some situations might make it
> impossible/hard to drop+re-read.
> 
> One example I cam up with if a folio is simply long-term R/O pinned. But I
> am also not quite sure how mlock might interfere here.
> 
> So yes, I think the page cache is likely the one of the most
> problematic/messy thing to handle.

So what if we convert to max-supported-order the first time somebody
calls mmap on a given file?  Most files are never mmaped, so it won't
affect them.  And files that are mmaped are generally not written to.
So there should not be much in the page cache for the common case.
And if no pages from the file have been mmaped yet, they cannot be pinned
or mlocked.

