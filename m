Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB26EC5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D59D6B00F1; Wed, 12 Aug 2026 07:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913BA6B00F3; Wed, 12 Aug 2026 07:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DAA56B00F4; Wed, 12 Aug 2026 07:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54BC26B00F1
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:12:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C505B1601FC
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:19 +0000 (UTC)
X-FDA: 85092353598.15.980B623
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D42720003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:12:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="o2/oPsgT";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786533138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfAKwb7BHAfKwks4BwOH8LurhNbOUrjBmbZm8v/M8ho=;
	b=Rxz3djWX1xgxdZ714J/YnQIgHlw0XXrhkLmW6mqYmLnCSwQZfJFNbPklbatUYyfhQpSs1C
	ohN5suqFX6mAZfoILL62gA7wHvAh1uCm8Ee56XDBs0RRfnlx5ZEiI6tlkLkIF1Wt05ORzq
	a8yWO1e1gG8eT9OivGilnTKnYKueT+Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="o2/oPsgT";
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786533138;
	b=6BuJqDzni8LPRRc4yu36lv+s5VakJ4fO6JcsKVXiccUw2zj/nBgWIp0Sj2m2GeyQO4xIlS
	oWZonaQ0IJ8woULbsHNlZzFagAP+5FBua3sLyBpYpHCNq7NjGt4ZDp7FikJo7JeVrUuy74
	SI1tEXvuRrhJ7ga543Pa8LsJXubc+ec=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wfAKwb7BHAfKwks4BwOH8LurhNbOUrjBmbZm8v/M8ho=; b=o2/oPsgT8gcfdJPToPnecYrXEY
	JESoF7pDhaqGxbh9ocFyX3YVUH/FjZuDIMgtE8vfuQEIj70ltqRFqBjiIcDWdegYRMCqRYVdVuYl4
	UlDTVngR5rQP97DrXqNPuQdNunlIJa7ZDeNlVB1FfnQN0PJGV8e4tpypn9hUMpwmHpR29xidDMEJU
	WTHogF/NFBajrCoiytFW3YQfECpHTAfXHEtxyWh/8rSTzrSR4SZwXkojbSAsw9bQ1t3J1TBRcjy5Q
	AoStvSzvaSIfQD2VqXmQbfl9y9x77/1080CcswJUXIj1gsFMVybP5PXZA11/KnbSgKk4nP7jAVCKo
	5VEGAkAg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wu6sK-004Ifd-32;
	Wed, 12 Aug 2026 11:12:01 +0000
Date: Wed, 12 Aug 2026 04:11:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, rmikey@meta.com, riel@surriel.com, kernel-team@meta.com, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v5] kexec: keep the next kernel off hardware-poisoned
 pages
Message-ID: <anxUnuML9UTepBTu@gmail.com>
References: <20260810-kexec_posioned-v5-1-95e1b5e2e656@debian.org>
 <ann9Kcesyb4T9Z8b@kernel.org>
 <anr59P1ZCAuHxv6x@gmail.com>
 <2vxzldac51om.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzldac51om.fsf@kernel.org>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D42720003
X-Rspamd-Server: rspam07
X-Stat-Signature: b71g6dhinfakoxjegexha1c7rer6cuaa
X-HE-Tag: 1786533138-90160
X-HE-Meta: U2FsdGVkX18rzkCmcQVBDr+boCqmkdR6HfuCJR5EhWsFSX8K0/UGOSM5jWAszO9g7mtLXrWGnbFB+pqfPj6KbfrRiNXgoKV3n7lzME9I53cWMCTPRo+Hao109BhD57aZX70jGpn14YIaPHVoPPulDS5QNggL8tpGs+lMERs9rzu9FAOR9R5c7h8GCWiXIsjH1ccSWSyR/J1APIMpCCFnp7ANhXvOYJ7FdnM9VJ/PncFwNxxTSWoIcBj2KqrjuZRFUTiCZdkjzv3Yztdn6gLf2TQHj39yJftEmqXLkH2dAQL5FuhKOYmuh1MiW0UfrbdYDewZi8uUC/4RPvyScpmHf7FJcLS4TFjNtxi5ti5YBl3vwiA2FvmlF5n54Xd1FGmYpVOsBKXXd/uHmKLEJZpTJlQdIhb7zyf93GiESsurRHXW3b5/XZL2UexJjni/NLfDwsfV+YuOsBel5kKg5dZexZtJTos2aywTWb0qcWFcUem7KEO2VhKt6vpfe1zadPwElIOFQyxA2mpujtITj+iu0hlLbXsf3zoIDnoxqhdXylAToyHfIoBWiBlw+8Xrq50zqmWL1i9snJXlkqr73mV8OFNJk5kY4POjNAZ9b5hYkx1Hx6bYpSM29GCTBgo+AqkytyJJwjO54BY36ZalBJeXXJR3oXp5YnfVRe0c/qGW0bbDJDhsoHHLG60IfK03kzWBhOw38aFYPZmpNaO8JEDXSFpXJ9BOXcjmnxTjz+IXy0X4JXO4hO6gJkxg2p0He/Mpl4y5u/Dad+HxR3KqFItz147lqkAJK2tci4SY/N7s/pv+ONTUxWkplitndFcmgh5c3xk5zhvc00Snrc7hBa4b7AytcXQsIw9CngrwGEnc9893wunZKTXXCnrXlAsZycWdG3xei665bBVA9FfBRSbHCfWmQ+59ejtjKRCSxY8JzR+prG9zDanXuTIEHb35P9cgWEWhFG+UWo8E5JmcFkA
 Y/nngKlU
 SdR27gw9bbbnmHmdRJGfCwuIcuS634l8efJE32pG6sz/078Q3Qq7tTtEi+nbhs6S7zGbEtEzpJQ0oB+w+Tk7U5pHaMfKDx4ThsiWTxmqxlr2UtdoDhOjZ6v48J3qwAo8EO5B3o0cWvZlatHyUSavn/24TlYrOFm2z+7jqOVXMjai5q75dhJBzl1xAUbs+7PrtvD+A/PC3uZqCgKQO3tl9JNauI4g9Knzf166HGPHaSu/fE6YaYpksH1B/6rG+wr1xf2WrnVZj0FahYkw6CYg3YoQelYQojxJyQe9+5VHMQSt+RM7P7OtZt2RxBmaBB7OnA1jfwHatZvx0XYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 01:36:25PM +0200, Pratyush Yadav wrote:
> On Tue, Aug 11 2026, Breno Leitao wrote:
> 
> > On Mon, Aug 10, 2026 at 07:32:41PM +0300, Mike Rapoport wrote:
> >> Hi Breno,
> >> 
> >> On Mon, Aug 10, 2026 at 06:32:04AM -0700, Breno Leitao wrote:
> [...]
> >> > +	for (pfn = PHYS_PFN(start); pfn <= end_pfn; pfn++) {
> >> > +
> >> > +		cond_resched();
> >> 
> >> cond_resched() for every pfn is too much, isn't it?
> >
> > It is what the other pfn walkers do: the kpageflags read loop in
> > fs/proc/page.c and read_page_owner() in mm/page_owner.c both call it
> > once per pfn. 
> >
> > But I honestly don't have a strong opinion here, though, happy to batch
> > it if you prefer. Would this one look better?:
> >
> > 	if (!(pfn % MAX_ORDER_NR_PAGES))
> > 		cond_resched();
> >
> 
> Now that we are looking at this, Sashiko also complains about a race
> with memory hotunplug.
> 
>     Can the page pointer become invalid here due to concurrent memory hotplug?
> 
>     The loop retrieves the struct page pointer using pfn_to_online_page() and
>     then yields the CPU with cond_resched(). Since this iteration runs without
>     holding get_online_mems(), could a concurrent memory hot-unplug event offline
>     and remove the memory section while the thread is sleeping?
> 
>     If the vmemmap backing the struct page is freed and its page tables torn
>     down, dereferencing the pointer in is_page_hwpoison(page) upon waking
>     could cause a use-after-free regression.
> 
> Kind of makes sense at first glance but I didn't go and look. Perhaps it
> is better to do the cond_resched() at the end of the loop?

Agree. I was calling cond_resched() earlier because I wanted to call it
before the "continue", but it is rather unusal. Let me move it at the
end of the loop.

Thanks for the review,
--breno

