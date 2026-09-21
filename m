Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CADAAC982F0
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3C36B00CC; Mon, 21 Sep 2026 09:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8562E6B00CD; Mon, 21 Sep 2026 09:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D5B6B00CF; Mon, 21 Sep 2026 09:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 437616B00CC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:42:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CA8ECA4808
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:42:27 +0000 (UTC)
X-FDA: 85237883934.04.7B3711D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3C784180004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:42:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=aY55STBj;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o50iEUUq9Hico4BGWHaX2sieM5OHx8zB4NrvMh/pa/A=;
	b=GaLAnrjKyFCqDhaCY3OxVZ2duVoZy4Xlrifv17GUuioJHoZPOPE0kVtfCwFZboUIK1tidJ
	55M15IhrjCT9cO8jKdq2mmLF8D1t4bp1tG+o8mf1pkuBV0EPK9lD11JHp5qHNrdrX/xvSO
	Z993JoB+rLjFTV3AvqzozQoJ84+h0uU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998146;
	b=aVyzZ6sqxRRYRfsWrVi2EugLRBd6ak//XemAhkIglZluAFuAMmineEwjBWcJ3m84F5Ht1a
	H1Ig0jRXT2hxklkOxj9f6ZbxNcvYqE3MDBxsqkIlSDZmKy4ad7S5yJ85R+Q2y5evFE8hRJ
	LoxgjG7gveTzbO2b7gcJgj09sDEHU2M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=aY55STBj;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o50iEUUq9Hico4BGWHaX2sieM5OHx8zB4NrvMh/pa/A=; b=aY55STBjtzWrl21NLFuecIM9F2
	jXs+e4PqxodBJcqUkj7CChyA5StfbY9Ye42NLiklat4rxvb5NGZj+KQenVRXFpyd3gwomZAJiMWTa
	30JZIjLf1zIPOIlxFA94dAD6Zv/Oznlygw6D/P59egCuoyjOqLsMhlNX0g4Sz9thM6Ca1CQC6thDY
	qR7OSlOY5QEnQ+gQOzFvY0t+AiVC9QzwlWti+PiUTSk2x6MyOWMxqb7wRxThGVrdZwH3wIhoVPM6U
	1NCQrptYHN1ln22pNHWZBnO03VOZxH02emQU031dZRLEU9C8w3Vm8YG28iXUEuoDdHQayV4kv8/Vp
	OQtvJMqw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x8eH2-002F62-2Q;
	Mon, 21 Sep 2026 13:41:36 +0000
Date: Mon, 21 Sep 2026 06:41:27 -0700
From: Breno Leitao <leitao@debian.org>
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 8/9] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <arEz7lp9_nRGwHPm@gmail.com>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
 <aq5jyXzuDAANeCJs@acer-nitro-anv15-41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq5jyXzuDAANeCJs@acer-nitro-anv15-41>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3C784180004
X-Stat-Signature: tnpe7ammtrmnf9hzuqiauin1anj8fyac
X-HE-Tag: 1789998146-678776
X-HE-Meta: U2FsdGVkX18Z4c3StJpLW7HNiZtBtvX46dFdhG4M9Oo49ENyYxXUUJsQHtLASvoPSxL4qRNbxKtkfEjTLYnGohldygOGNUfe4ceZUMoK0phoXJeptskCMZqIzko1iGe4WTeVqU5eN89JYZxZHlNJuPPBojJQDkEhjajZEVoAcesoCB632rRVycwdeWxfjtXe/Rjpc6bVYOBr3UoIOJ7/ahZdEuXtimgxgrsmvL2SzY5gSNnRyLZuAIfDT4SGHNCtlawd4yZfW0Jde65kzF0cQibtFbECp33FO/DYPkbu+kYioJ3mntv8gC5VA3RxagMpvMzcFMZL3N0PZIgxOKzKuZN+SloxLGeuTm0HkM+QrKxX7Jp9ljHZEgGZyP0FU+A5Rr+rCm6GKDBFtgNSTLwrMpr21iGIcJiEzqUXxZf6AeW9XqwdTQY/7jdHjcPP7kHasCQLfeL64tBbjm95Yl7rTzn5gnIOkYdH2GrkZ2iJv/IZBWxyyPpRz1mThbAKg7L9m7Z6f0/gso5JpJHBL//fCfhRlaf3bUkBhCb+7zZWLO6ZHgcY9KgPGnCELscMeT/JeX97E6P635RDA/jqP81oYpP7b1SrW4tCDDJ9BdAfB7g7L+mMErDSrBJpI/WSSuwFaqEFhhMJivB2SFuuaPRC+cQkLIvQeUV8M7+gxJgzj6hgg/LEfqgWg4UFlHdlDtenHP2znmgFcQBWxzmq17bxYYnMPXtnSsn7oUMaUG6XnnD0dKz8SavBm9pjRNomfz9xWhUkv6ABY+jVfw4HvbKaZ5ele0jX+/U9SqOjwPSd2f5n1u1uX1lpSO7QCClh7oDTtqANsoY/vXk11eHl5z2OY0UfDlu03NV9/SkZiOgqiploy/IRH7yPEX54wajS3MHzbaJcGNhXbi5sVhrPQ2wjzr8wWiCzI/K9Fsi8z2OTfOa1piz4grToqliclUjr8AYHFWIFQ2CX/Q1f1gtD3AY
 9IHnYgY7
 ANz80c5NG6llVjXtjF09WcgHc/bOIqXiyfp4lenop5v5i2cTJhLvOOZ0CVeHHr5yPBpDknd9868W/ygpb5U0W7pDNCYdfIr/l1vsoajdHu6WPnNU9qNiotx4xeFBJyjz907KqHiybYgMQ17o7Wxtp1gOMUfBPcQKmhv/bjqkKvZfP5lcQIgwOcExFeQNvYpus/8BO2Wt0gZogOKwXtksAwyTzW6RxeyyXa5T6LPsoHZzWyZnb1QIvbRndlPqkWQbIC9LB4jnylzLqx4F/ZajXwti09hHiwcIcpeRQlUUwp5aeH3nHAB53EAT199W3T7Fu6NoTdXC6u0HOeGeD/eiioDORWOcIT3uSuu7eSeWafhgfs8kcs/nSmMCxVAI5nL0/vYzAQPlWKM4wiNR5KpeafY5C5TdDvy4djoAB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 03:58:25PM +0530, Shaikh Kamaluddin wrote:
> On Tue, Sep 15, 2026 at 05:53:42AM -0700, Breno Leitao wrote:
> > +
> > +	/*
> > +	 * The per memory block half of num_poisoned_pages_inc() has no block to
> > +	 * find at boot, and divides by zero looking for one. A hotplugged block
> > +	 * is already there.
> > +	 */
> > +	if (context == MEMINIT_HOTPLUG)
> > +		num_poisoned_pages_inc(pfn);
> > +	else
> > +		atomic_long_inc(&num_poisoned_pages);
> > +}
> 
> Hi Breno,
> 
> num_poisoned_pages_inc() currently assumes that the supplied PFN can
> be used for per-memory-block accounting and therefore calls
> memblk_nr_poison_inc() unconditionally. The early-boot path needs
> global-only accounting because the memory-block infrastructure is not
> initialized yet.
> 
> Could num_poisoned_pages_inc() treat -1UL as global-only accounting,
> matching num_poisoned_pages_sub()?
> 
> Example as below:
> 
> void num_poisoned_pages_inc(unsigned long pfn)
> {
> 	atomic_long_inc(&num_poisoned_pages);
> 
> 	if (pfn != -1UL)
> 		memblk_nr_poison_inc(pfn);
> }
> 
> 
> The caller could then use:
> 
> num_poisoned_pages_inc(context == MEMINIT_HOTPLUG ? pfn : -1UL);
> 
> This would keep updates to `num_poisoned_pages` encapsulated rather than
> manipulating the counter directly here, while also making the increment
> and decrement interfaces consistent.

Good point, and it is a better fit than what I have.

-1UL already means "global only" on the sub side, and it is not just a
convention on paper: remove_memory_block_devices() calls
num_poisoned_pages_sub(-1UL, memblk_nr_poison(mem)) when a block goes
away. Teaching inc() the same thing costs a branch and keeps
num_poisoned_pages behind the two helpers instead of growing a third
place that pokes the atomic directly.

I will fold this into v6:

      void num_poisoned_pages_inc(unsigned long pfn)
      {
              atomic_long_inc(&num_poisoned_pages);

              if (pfn != -1UL)
                      memblk_nr_poison_inc(pfn);
      }

Thanks for the review and suggestion,
--breno

