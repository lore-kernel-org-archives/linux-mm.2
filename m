Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 476CAFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 14:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F2486B0092; Mon, 27 Apr 2026 10:50:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2C16B0093; Mon, 27 Apr 2026 10:50:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8927A6B0095; Mon, 27 Apr 2026 10:50:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 798EA6B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:50:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E55D48D35F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:49:46 +0000 (UTC)
X-FDA: 84704619972.09.6824DBA
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25762C001A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:49:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="C/1RKnHQ";
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777301385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2vkZ5y2qzYA8iDKm7xA23S0ULNqG/MU/Wg90CpRlXE=;
	b=xzaP89zl08M9nMxNjvVRFMDT1xZEOFRWkQNeOrZlPbxCGwAfpX1piotAgubEhrI9LOJCEm
	J263UJzS/BVceJE1OZk48EgSb+2oDWRjCAgysQAaaO2/yGTnGSvyyZOqHtzyvWxP5dhbvu
	A+CqCqqABTiWi4h+PWjuk4RCAnl5FiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777301385; a=rsa-sha256;
	cv=none;
	b=erC4jZ3jkOykMZsGLacaZfM8tTjWrmL9k3sNohUcvcVBE3o5qNcFrOJxe2H5TosLtx9I6+
	vFYtK7yIGCbMD2bjajZ8TreZ64Nter/dzQMzNiFrukmOwOcNNmP/6BAztpX4eZrh41hgsA
	/x3OopSHy3GKkN5MnttBUh0B2pp9MJQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="C/1RKnHQ";
	spf=none (imf22.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=o2vkZ5y2qzYA8iDKm7xA23S0ULNqG/MU/Wg90CpRlXE=; b=C/1RKnHQJ6cE7e0H0oYf278wCF
	Vv46Ir52iXcfmt1pWngYUoMRBu2uwl7EeJUUbB1Avgq3gBnGU6vNG3kKEPCvLYZnUzaLbHdtz8OtH
	Ed6s1e2huhHvR7Uncot4hDG3aJ8OxNT2HgElFQ6pRlZQcUqUZyNZ44tGASC5MujhwAMERW4YxNbsr
	qaCUAvXQ2foyNmU1FAQQ6IrkbH81zY7LuSTgwh/f9ZKKvjR+Ol5FePUE8+bU7Pd7fh06yqhmIc8mH
	lwUcagqd3QcoAwYIB2XQQxR/DlSxfqSHU6HPt3CPRmRrCeh28bW9oPiVd0Yd61ZoPCcdwQ4Ep35Tj
	tmG7Ah9w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wHNHI-005YaE-0a;
	Mon, 27 Apr 2026 14:49:40 +0000
Date: Mon, 27 Apr 2026 07:49:34 -0700
From: Breno Leitao <leitao@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kernel-team@meta.com, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v4 2/3] mm/memory-failure: add panic option for
 unrecoverable pages
Message-ID: <ae93PTScNGzxo7aR@gmail.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
 <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
 <aejlg62nxcF_5g2v@gmail.com>
 <c1517ad3-91d1-2ea1-efa7-0f29415d513d@huawei.com>
 <aeta8Ifvmqi6-E8w@gmail.com>
 <5e05384e-740e-b374-2370-01f96d1dac9f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e05384e-740e-b374-2370-01f96d1dac9f@huawei.com>
X-Debian-User: leitao
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 25762C001A
X-Stat-Signature: ns8ykdtc6hiexud1w4yck7n4fcnoqro3
X-Rspam-User: 
X-HE-Tag: 1777301384-583334
X-HE-Meta: U2FsdGVkX1/nV7h7dzta0qLGXgiNM5b2azBq/MR4PXpLsVU0GhHelCmDTB7pAWpepxboab93vJmWuBCr37d4m6L9tbV3OLOhLsBZk8+KVoMk31m0scZaWIEUvaurD2P8VwOOGeS4V8LbXtEW/Q9mcEFbYqetp9fryVpexuVRp7STmuVn/fgPjmypqIiCf0pRHn2iwcsrmD9NjU47Ayz51iqTZphBNFjHKr77N0gTjIVouMSE2eHVL1rP8a8t32dDB4QslKHzX06PVLpHMR/3VhBKRbT4hiIAm/YQ5HwaAUFqmmY/A1CtabwQLRCKEMHRJxOsXv4Vk6dTzqnUrVVjy+ElSmKsInSRsHpfSfzeXMn6dOU3VH300A5ta3CBpauAc/hfDfaSZKEgHheogxGbY+XOaSeNR3k6f8J3KTDYX1wqCmtOVXP/05w8xPmbpY3/+Uqpx2meGASwri9VUznZ/wrzBc09r9Ti2ECHUehAUvXaZnpDZvkidQ1/8UwMxy0+CBYkIWa8/mIZazki4hoGd7jcuisYYt607EpN5w6bHwf/GXiE5ddv7zq2VR3ft9HydayhPzaGLvs1QUiEmDyazLg5KAlcxXdTDHURvkGntQaYYUnDDQgoKOcfXj6tJ/ZsfSS20esGRmn6ZAKqlP4TGwGZVGdZF8Sf87SwXAkC0bBggAXEEnAnmAUMImsiGgXc10/BxjP7M3fqaR8JeE1xGucwxpIAvu8Wl4K5KXkVrO9ThBO/k4XHWHtYEAY30IkWQeY0fIWwV6C1ViMKv/jff2nwV8Tu/t7Fptjxh4c1qwrWnRwt8BH8waDH/oDBosHwFidrTBnQADyg9DhkX6HsFKl2cigs/d4fw3QBBskcVyKJi4ZAkTOeMDtAfSkNR2wXR1a+VayOwkJDcSUtJzW/vxmcb9g4TmVdlnDVxfiCnJ/HKpxH40EptCtbXiYn5/mFWWYCKm3h1CKKNDFjk2g
 s3/vNlIc
 WVCcLv8baWIstDcO/bqbSDmZcGK1kQ9GCxrlE5+ftbajxFYEebGV5iGwdedo0q0aBNAHwqkHCzsRAuHh6DOjBLvwnCHxkhxqgPevSbLSq5HbZGqRCTGe7rlsqBoMTh1MmG+j4MPuszCaZA1kAuQvDIMhtBdQfmdvOIycrRHYRe5nraWm0MNyLl9LClTi0oZWpkLG6Q5XJs01TtoR4eBuveFncX7tgusQl7F5MwF4ObOSih2cwudVC8xVOGxwgIFCzUkcMkaeGnNCFnGYTpeb/o0611n3OHSZDkakY0Il37AOsmzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 10:44:55AM +0800, Miaohe Lin wrote:
> On 2026/4/24 20:01, Breno Leitao wrote:
> > On Thu, Apr 23, 2026 at 10:38:19AM +0800, Miaohe Lin wrote:
> >>> are you suggesting I drop MF_MSG_KERNEL_HIGH_ORDER from here, or, document this
> >>> will not hit userspace pages?
> >>
> >> No, maybe we should rule out or document above rare case if I'm not miss something.
> > 
> > Good catch. A buddy page being concurrently allocated to userspace can
> > briefly satisfy get_hwpoison_page() == 0 && !is_free_buddy_page(), and
> > that page is recoverable via the standard SIGBUS path — panicking on
> > it would be wrong.
> > 
> > The page allocator can't filter it out either.
> > 
> > check_new_pages() is gated by is_check_pages_enabled() and is a no-op
> > when CONFIG_DEBUG_VM=n.
> > 
> > For v6 I'll try to rule out the race inside panic_on_unrecoverable_mf() so
> > action_result() stays unchanged:
> > 
> > 	case MF_MSG_KERNEL_HIGH_ORDER:
> > 	p = pfn_to_online_page(pfn);
> > 	if (!p)
> > 		return true;
> > 	cpu_relax();
> > 	return page_count(p) == 0 &&
> > 		!PageLRU(p) &&
> > 		!page_mapped(p) &&
> > 		!page_folio(p)->mapping &&
> > 		!is_free_buddy_page(p);
> > 
> > 
> > A buddy page being allocated must transit rmqueue() → prep_new_page() →
> > post_alloc_hook() before the caller can use it. Each step either bumps
> > _refcount or sets state we can observe (PageLRU, ->mapping). cpu_relax()
> > lets that remote-CPU progress become visible before we resample.
> > 
> > A genuine non-buddy high-order kernel tail page stays unowned across the
> > recheck, so the panic still fires on the case this series targets.
> > 
> > The window is much narrowed now, not eliminated — I'll say so in the changelog.
> > 
> > I also added a selftest that enables the sysctl, injects MADV_HWPOISON
> > on a userspace anon page in a forked child, and asserts SIGBUS (not a
> > panic). I've been running this in a loop for hours, and I haven't seen any
> > false positive.
> 
> The userspace anon pages are already allocated. Those pages are in a stable state.
> So your selftest cannot test above window. Or am I miss something?

You're right, the test doesn't directly hit the race window. By the time
madvise(MADV_HWPOISON) runs the page is fully owned by the process and goes
through the steady-state SIGBUS path; the buddy→user transition that the
recheck guards is already over.

What the test actually proves is the negative: the recheck didn't break the
common, non-racing path — i.e. a normal recoverable userspace page still
returns SIGBUS instead of panicking. It's a smoke test against gross
regressions of the recheck logic, not a reproducer of the original race.

Reproducing the race from userspace is hard because the window is
microseconds wide inside the allocator.

If you think this test doesn't bring any value, i am happy to just drop it.

