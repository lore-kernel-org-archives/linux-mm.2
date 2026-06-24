Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80EF1CDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 09:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F8056B0088; Wed, 24 Jun 2026 05:19:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A99E6B008A; Wed, 24 Jun 2026 05:19:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1990E6B008C; Wed, 24 Jun 2026 05:19:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2B076B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 05:19:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70B1E1A02A1
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:19:05 +0000 (UTC)
X-FDA: 84914257050.06.1ED5508
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8AD3B160003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 09:19:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Wux0JzQd;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782292743;
	b=hZ4/zwzmPL/jC2g/ZTbJxqT5eAmYL3/VtCSycUfG7RGcr0dRj9SH8UKAFpV6H62IIpaAFy
	G/N+ON8bML0YhH+dw2nZXl09QaH0EtVb+LVZ3HLuD8WFBllKrzer/jjW0Arp8nLlm0NFdH
	M1Ep6UO3jXjCm3JcbfvWGPooN7XxS0E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782292743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldR4cYvsBUeIZJnqOTXRNfR+NaL//Mv2RcuUTuKrZGI=;
	b=EdGKnnzZdNcXty8SbTR02LGybx2TLD7rVHU62fJzlalbUE1O8+ciI9D2HqZhBvvuVfqwV8
	KuCT8SD0l/rwvpaEBWE3mHweKnbhGUIi/KAarF3Yi6f4Tl7foilcK7pJXl+6N/o7lDHDrD
	ewnuwZ2gGVwbD2fM+WgkGf/GPTYhR1g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Wux0JzQd;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf08.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1782292740;
	bh=UbFfQafZq6sBdbOyPZkrwg5hrZbp8Tvb3WKRWbqkRyo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Wux0JzQdrDmpxjr9HtQosDURIf4Z76zUI4I0Bw6QizM6aBn3VUUJtdxkelUFWRSj/
	 F5cb+rzCZq7E700W7xKZjSagCIiyrIzvfA5ZmZlEPst0iO25pQq+OfE8R0HaPSVMgv
	 MnqfmQQ0cI7lpit44S4/YvB4wUc29FJHTB07IEKLUp9RWR0Rz82lzMAFFhSd4A6GBy
	 zBu9DBjiqKogByXEqnnVQtZyb96ANxAejP1n4xOxxd44XUUF+XsD5z4YFRFUg/F5ju
	 8I2817BYOW6i6KK5wyxdS1U+qowAOh0qT2fQ7D+21I26A5EWQECmopqVU3YYu8kMw7
	 0rM0uEjdsbjFg==
Received: from fedora-2.home (unknown [100.64.0.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 402AF17E0191;
	Wed, 24 Jun 2026 11:19:00 +0200 (CEST)
Date: Wed, 24 Jun 2026 11:18:56 +0200
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Christian A. Ehrhardt" <lk@c--e.de>, dri-devel@lists.freedesktop.org,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
Message-ID: <20260624111856.11210c19@fedora-2.home>
In-Reply-To: <20260623224421.56dba65d@fedora-2.home>
References: <20260623181942.1536598-1-lk@c--e.de>
	<ajrRhpVH6uhOABnV@casper.infradead.org>
	<20260623220341.7ad4a0e2@fedora-2.home>
	<20260623224421.56dba65d@fedora-2.home>
Organization: Collabora
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8AD3B160003
X-Stat-Signature: s8e94fhkdsjrtytsxzahum1c1wi369m1
X-HE-Tag: 1782292743-388606
X-HE-Meta: U2FsdGVkX18cbkToaZGmfyyqgRwdSB8DdBherg0o9fRyMsg2HSCkjKQQpMNgcbUm8BOy4+djHNhuGnfvRWaFNoT0dFs95fiGguYxxi3zAF77qo9P2z8EfvMvp65SFwk4fz+KhbJcOYGwZ4nosCI+YD9VVtCXKZgov66TncT//NhlfP9wZstmzfTaCDq9mZJPQ+hK8MbpFPe+aQsR7+zX8VmK8/thuxwY8brTVlsns1tlCifwUaobieY+nX63wH5i0+Qenem4354RE5Cv2EYZjEhFGf1gDBULAGpey56ILcXmzJbPZEsR7y7wHe7Naf4baelc5+FbWZY/IR5VE2pSlfmsodr+q+tjjjXFwcGyZDlUMrBUVM8Unmq2MxXb0zogki+q5nwaUqn4hStHaLiBdQjmlHCNaMTkZnj52KdHpBa0IoUDyqsKCbQS19Y1w1tw48Wl5QBEgpxf7MWEwPWkHD1u5bvAQWK/5T7+Zi6ruj/7RSf0HK3fb7xARUcmF5eqEdlqzqjs8sVJF/5s++YFgA1SXs6IV+CI7dCOFLQPzEHM5Ca4WS/+vcuIaYmGbSEWhorswMPFnNPm4jm8EUGpxsG0UrRXuW/3+RAgBvBPYwQPBcAmKcRVkrlcsnVXUkdlyinvFMewgrmxHg9VN5V1K3KUiWKI1gHWagwKuvPCpautN0+3t3lnSnAGoaR0hi2i+eX8Eew19pWCORDvPrd0Ukh9QKwzE8n6Y3/+1xK/8/iIdsZJFMIfg+MHez1Jn7Ywfwi931hX+zkHze0EWfcZ7nVSQjCsPRhT0JrDF361Ke9mRd2BcoUoVZEXhYMNIjFsB2vILKJb/owaEp2BV5+a36jz7bUfqFN6PPqsjpQ4ozFR1st5tFTWvOdL2BAlQNkt+akrXr7e+i40GAIcsK5KnAOpn/JYxleGAMKxyH3Roydy+5dev0KGloPkv0YgIo3ILPXTyK6OiDPksJSdXsa
 iIz9sIff
 ksJEXhE/zJpFQ67EYoSwHkVeqtyEqAYVawfTw4WqTVQyFzrYhMjlq16Ku9o7xX7i74Gtsja3uofDpMl9B4Sz+CNhBvZB7cfPOrUetM10/5DsJIPQfmwhiXDxfdRy1Ckpfes1Y3Pu8cfN2EWiOao4FUijh4PTdv71G0zsqZYluOezNWW6Q/hW5aOyBf1j764kWhWd0UIo+iuXk2I/1ERiOtKF26pCk7BgQ4/snJP1FNiXR87LP5hs29UGum+YV0m2+2R0G6FdLj3Cc7NPz0urgdUxul77YPqCeEYC5vomFNYdi8r+xygfzOVnf8Co2hYStSL7YfZWvQuIPOD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 22:44:21 +0200
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> On Tue, 23 Jun 2026 22:03:41 +0200
> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> 
> > Anyway, I'll try to get back to this map_pages() implementation, and
> > see how we can handle the fallback when locks can't be acquired in that
> > path (I assume this would mean no PMD mapping in the fallback path if
> > we get rid of huge_fault()).  
> 
> More on that. I had a brief look at map_pages()/fault_around(), and it
> seems it's only meant to populate PTE entries, not PMDs.

I was wrong, filemap_map_pages() clearly attempts a huge_page map if
the conditions are met (proper alignment of VMA, folio is huge, ...).

Now, I have several questions around how to implement map_pages()
properly in our case.

Ideally we would use a generic helper like filemap_map_pages(), which
basically all implementer of .map_pages() are using, because the loop,
checks and locking is far from trivial there. Unfortunately we can't
really use that one because
   a. in our case, the vm_file attached to the vma is a pseudo file that
      doesn't really back the data. Things are redirected internally to
      another file object that's backed by shmem, meaning the
      vmf->vm_pgoff and vmf->vma info are unusable as-is
   b. we use PFN insertion instead of page insertion since [1]

I'm sure we can hand-roll our own map_pages() implementation, but
again, we would need custom versions of the vmf_insert_pfn() to have an
optimal version that can batch multiple PTE updates (just like
filemap_map_folio_range() does). The pte/pmd locking also looks a bit
different too in map_pages(). These are all rather tricky details that
are hard to sort out when you don't know MM internals and the various
pitfalls around page table updates. Long story short, if you really want
us to move away from .huge_fault(), we're gonna need a bit of
hand-holding, because otherwise we're shooting in the dark.

[1]https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v7.1&id=8b93d1d7dbd578fd296e70008b29c0f62d09d7cb

