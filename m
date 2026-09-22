Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22B47C98304
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 13:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF40E6B0095; Tue, 22 Sep 2026 09:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA52A6B009E; Tue, 22 Sep 2026 09:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBB166B009F; Tue, 22 Sep 2026 09:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DA9D6B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 09:45:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 27E1E1204AA
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:45:17 +0000 (UTC)
X-FDA: 85241519874.05.7CB08B9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8656010000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 13:45:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXn4KJ5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790084715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vQogC0AaDJB13p395CjVa0K8IHFuyempieXINkDBjmI=;
	b=2ZkKmCMU/CwdLWpde6+7u0Er+1ljOArIJBKOQRutiQd0G+soMQm8pq8qaJ6j5i5+iluXs1
	EFSSYRP7fLTV3gDCYOZuwf/2ve6uiM1GCLUs/sYfEtNPaE+v1KUM9zTtIhMY/CZespkses
	F7pPH22Tou0kZi/eOrnsTRZW/HecGZ4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nXn4KJ5Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790084715;
	b=5PS1VfIYT+I4Qvah6RPGtSvD4Yy0nKKwP+aGSkTVYjWBKo4cYGedpRuhzw5uPtPRCy+2SP
	SRZp5J2xsk/SH3UB8MPqhOX85kbrefRDcrjQMciNkI8mK73xW4Le5Y08qhAl6AS6L+V6Hz
	AI78CPmJPGVGIe8cJbTv/d9VHO5f3cs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A82EC6024D;
	Tue, 22 Sep 2026 13:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96561F00893;
	Tue, 22 Sep 2026 13:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790084713;
	bh=vQogC0AaDJB13p395CjVa0K8IHFuyempieXINkDBjmI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nXn4KJ5YCt7msZuBG7rmlIi53n8XfETgu6aRe4PZFQxj1jg1WctsRsI2laIFPKxcq
	 KFMjOH9RfXFKsqQOGPuzUbM1RgW0kn9wvT8gHMwy6Ph6yX9efU/mBk0nhmEGM1d23+
	 1u7KQ5pwBezqsOs+QxAjhex7Kad0ZPmmkOhxooTgsWA5epfHfE5rHF+9hp9ODHG9eG
	 wGF9mgKd9HvUwnBMxAUyfAtAv8S4k4QW7tED3m8IwIQnoh+QcXgam+BAV5yJSeZNCv
	 mXg9ZdNE+JflO8CbRUQCBwti/hKJlm1tIbegXIgF56GBM8wz088RoehPQhlg9uCrFf
	 35pYat0LXjbHQ==
Date: Tue, 22 Sep 2026 14:45:11 +0100
From: Harry Yoo <harry@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Breno Leitao <leitao@debian.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
Message-ID: <arKCBl7Ee7fSyKoR@thinkstation>
References: <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
 <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
 <aqvHHHuWJ-y4WRJZ@gmail.com>
 <caac2cb9-8faa-49bc-ae8a-47c5fd7b7e58@kernel.org>
 <aq1RaH0eE0hZfNpr@gmail.com>
 <fb2237be-f7bc-4ad6-bcb0-7c3ef53136ef@kernel.org>
 <arE3UjqPsxctWckg@gmail.com>
 <ad2ed3ed-959a-4af3-a2f5-4c21e5af62d6@kernel.org>
 <arJ5I9QHHBvuGH_F@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arJ5I9QHHBvuGH_F@thinkstation>
X-Rspam-User: 
X-Stat-Signature: pmeske5mc5jbwfrnz6rk3wscajtqzpgu
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8656010000B
X-HE-Tag: 1790084715-101706
X-HE-Meta: U2FsdGVkX1/sevBrWtQDuV6r5owNa4wCbFspPgfL2lwSZOEI6pFBWu+7+iihBtdRTnaeHTHTJiKyF3/3pOIvPYt9IW/63m5bZyzIRYt+bbJOgnfhFtME9Uq+zIwtscjKhVDKXZYabazHcJHBqwVeEATMSDcfr2s3syXARoEIQFCiFu3cm98SYox0Rd0d4VbgQxzHFR8rgpwAB+dmk2hK1R6cUiZvL1o7LunyjCSqAuY/YyxEYDD9PdfaEyGA8HmJFp395pXmOV2hjNQ2ghndl4yMcvZnWg3p+FXO/KjiVcgPzQ9eG2CbdvEBEk9U2v1BeBUIdbf7DaQdZ2eP/NU45TXqD8aOzP2LlXE+W5wZp0MAJ60KR03jsYLmuwDI9W2gU3zddebNkRgd4XTwU03TxuRkmjFOCq3qfMKFIt3WFNzGZTcbuDj9dJb9xrWx1bk3fIxM2PF6BDwNmd4xfJLQsvVg6PRBO5wBkpS3TJ4Sbl0lsxbKS2CU9xvvfLYqneVL0toqdaHbiBU1JY1pQSaL3CZecSwuFEZXoRXW3PmwbVFEOEkUesIKFXvbKpQRX8TOw6qTjlCdNdkDiK83wDLfECYxVpvN7Leuim7lo7msyFnBUmtbe5UWqNg0kipkJzyn7V/gkrYLHmNhIq2gLsnPfIdywM5nfxZu/P+U8Sy51peUnX/x05Mc+UI04qGuvY/dzH7iz2ZSSq71eGE7nACHnC5rQoY4vY4i40qPjjU81QO/kXKh3spD+qtvm9xMA5q50rDLTpoFkyyeOza5/DIRgNiBDKSeHMd2sox+zHe3QWicRvXftRNoeAq1Dyio2DKGnE1IYByZowzeO3+V9JfFbJg4yU255qMZoNZ/2XHgHvTOWrYdq8TpBFKGbmM5yDRCwYZnHhVIB5HvnjjUX1oJHD43nrPZ3FlfwWv+iExDyZbnqzpjfSnrqmeUHLxoNXq596QEWsZkPDTlnVe2G2h
 ANgUQtBy
 gRHkZY8Ew641rrDY/6R5zTMHijE+swb2kHG18gACkNL9SsqylUmK6hnGz/fDLvrSFahXTLAl4Lx25M5tDayBNxumSHwzybCP/FED5olMjRNKwkCXSlRpUglL/qEqPhsOErhVycA6e4Pjb3PCZN7sausDQfX9p95ei18KObZY5o5umGfW5zGLBRfEU28o6TmeZ9R6ai78RBz0LmUfhjvnIMiG90I+/rddSictcuofMeeMscJOACuxmhXVo4uhtDl4D46y+tA0jyEQ8wyZOANAGYlhdCIbTbHFGmtX4f1kqXw3XcMRq16RGOZlKqBH2IvU7jBzOPHWZDtAfcE1dDMzeAQ8du2muF0xz+QqU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 01:51:08PM +0100, Kiryl Shutsemau wrote:
> On Tue, Sep 22, 2026 at 01:33:51PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/21/26 16:31, Breno Leitao wrote:
> > > On Fri, Sep 18, 2026 at 10:16:25PM +0200, David Hildenbrand (Arm) wrote:
> > >> On 9/18/26 17:22, Breno Leitao wrote:
> > >>>
> > >>> Right, we have two source for poisoned page information, today.
> > >>>
> > >>> 1) LINUX_EFI_POISONED_MEMORY: Used to track memory block that got
> > >>>    poisioned, and will be passed around during kexec.
> > >>> 2) PG_hwpoison on struct page: Used by the memory subsystem to avoid
> > >>>    touching it.
> > >>
> > >> How are both kept in sync? See below.
> > > 
> > > The EFI table is only written when there is a memory failure. That is
> > > the only thing that writes to it:
> > > 
> > > 	action_result() -> efi_hwpoison_record_pfn() -> set_bit()
> > > 
> > > You can see it on patch "mm/memory-failure: efi: record
> > > hardware-poisoned frames into the poisoned-memory table"
> > > 
> > > Then, when the kernel kexecs into a second kernel, the EFI config table
> > > is queried and the pages are poisoned from it at boot, as they are
> > > getting into the buddy allocator, in __free_pages_core().
> > 
> > I am not sure that is really the right place. That means we only poison free
> > memory. Shouldn't we poison as soon as we initialize the memmap, and check
> > whether any memblock allocations ended up on that poisoned memory and bail out?
> 
> __free_pages_core() is how we hand over pages from memblock to page allocator
> initially -- from memblock_free_pages(), deferred_free_pages() and
> hotplug. It is the right place to never allow them on free lists.

One limitation with that is that (as David mentioned)

by poisoning memory when freeing memory from memblock to the buddy,
the kernel might end up allocating the bad memory from memblock
during the early boot process. I don't think we have a functionality
to poison memory in memblock.

Hmm, will it be a problem if we just reserve area memblock....?
Well, that was the case in v2!
https://lore.kernel.org/all/aohldTtzE2GJ76md@thinkstation

IIUC the problem there was: when the architecture does not keep memblock
metadata, nothing prevents kexec from allocating memory from the
reserved space.

So, what should we do know? Reserve the poisoned areas in memblock AND
free those reserved spaces to the buddy to pass poison information? ;-)

-- 
Cheers,
Harry / Hyeonggon

