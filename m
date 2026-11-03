Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3C8606D80A
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=T8GHUIeu
Received: by kanga.kvack.org (Postfix)
	id 917C06B05B5; Tue,  3 Nov 2026 05:07:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C8786B05B8; Tue,  3 Nov 2026 05:07:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BF066B05B9; Tue,  3 Nov 2026 05:07:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5648B6B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:07:09 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D43D21C393C
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:07:08 +0000 (UTC)
X-FDA: 85393379736.03.81FA728
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3D87C2000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:07:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=T8GHUIeu;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793700427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOEv4rlICtm+9MGZIVJit4iJjbb/HbqDxTBh2E0PNYM=;
	b=ZYtV/oYj5HXiKE0jSRjK3FXrR8G3T+WGqSt8hMrddekussIXHhxquzTTMCTLTvBqrRsI9t
	U4PgC4zVp+RT4K85T78zHbKR2at8oq+s6SyJFphJhbnjsk7BS1b+UxjnXMhwQCcBqHFVuF
	bOSRH4GHCf++mdv6CuWYA51p0I5snCI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793700427;
	b=hphHroqMLVmCKzdOvf2sRxlrJryuUEWYfDtqaXr3kS4LknFTs/YC1MpPsjLEuStyWRYBZp
	tL3kb7DbJCeOLo7mOgYWEyhrhfhFHNdrmYQ8KnUB4VCNMzSYzpJ9BzmOWmSP0GPp3i5oVl
	kAEoCUwagKD8bL6BFemjk+FgC/P2FTw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=T8GHUIeu;
	spf=pass (imf03.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yOEv4rlICtm+9MGZIVJit4iJjbb/HbqDxTBh2E0PNYM=; b=T8GHUIeuwcDQEX7YFBA0dHaPtB
	2kVj9KSOFPEikB0F9pAaccEJIVjNxbKR3+e0f9oaOThinmGoXpI0EvZVDNwsXfU7AGr9ATQG+ak4X
	z2dA0u862tnlHdxULQMW9u6wC8/34oIlt51HyBjY2ZPhPEqEQ7F2QlBBCab/c1vclkwgOD+hM7I5Y
	Apd1Al26l3U1O8FO7cvKq+udwXcUON4wKT7E1OLcFB1DgsHO9juQDwNhoajOQfbR9TQ7vZZE+8K4T
	LmEzS5pvIZvxQ3GwRaJaAmhojV9r2fEIapcI/uXjfq4sDAf9cLR2RFL0jyHQmO9HjiEpQaLi6OAZZ
	0upLu0Xg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xOBPO-006r0Z-0j;
	Tue, 03 Nov 2026 10:06:26 +0000
Date: Tue, 3 Nov 2026 02:06:17 -0800
From: Breno Leitao <leitao@debian.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, 
	kexec@lists.infradead.org, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, shakeel.butt@linux.dev, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <aumvVjoHo4KeuyEp@gmail.com>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
 <aumt-4kfGGtoXuh-@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aumt-4kfGGtoXuh-@kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam06
X-Stat-Signature: 4xhczu6g7gb8a6xq7ds3zi518mg3phwn
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3D87C2000A
X-Rspam-User: 
X-HE-Tag: 1793700427-87920
X-HE-Meta: U2FsdGVkX1+Lg3IwRS6BZlvzhLX16B37Qou+0QZpaGdx7VkpZP489JT8jdP8jeRAId1wB0hcaRaucXBZ4AuVDhvut8v0wMMVG/PQ8dq0TfqfFMGVzZBOuuP3H0KfMP+ETZxW4LtN9d+g52MAEDq2IPzDdTbQhCXP7aSkWM/QHahCa9KLAGr4wZj0XZNd4TfD89JLZWEHmEMqy7ULpnMamlpl0HfXOcxEQPNPVQx6Pf22iDjfLq/1cYU5rBHQO6VB4+CKHrOTM9KMlJXBoqcpaS1rS44lnpybzsNQW+WFqguNcYl5vGAPx9XgvaAryHUez61r0HD0aRrzTmT5cnU43ZB6fnIqewP/B8mT0HwZe0wjR5oLTuMl2XRDy65rjeZxYDDAii1nvJQvUyyPX6B78DMRPyDQLpZ4A4pTVg/N+TqtPSElqPJ6CzYvSsTpylXDJYrwd7Mnj2z2BjRJXfqHQE4W5sNDsCm5gzwxEyTYFamaH+/ychpXVAyka9HunxMM+vu88Y92L0yY59IsI4FH74MYb2dDTZf0R7G6NtAtkzoKQw8gyt6ZJWc0Uxahy3dPmHHyIWWAoRnCngPXZCEwu/x4kKAC2l7K+7tkPxy8/hsUzKmkXpnigtGnA14ZFvV3gmZSxmiM3xZ3mcUdm3tbDxSHqg4HkP7GwxxUsgPunAPUAZ2AzEHhIdXEpdssSZykrnXJUkDvX/oLmxi4RTB7P4IwxpqThDR5ebbH4zwv0xlhOy+feg1QlW788LN6PmUnjYOMdwrMWHUuQJ1Smv9zQWZ7LbFPHXhPpGzCsjqRMSencjBAJ73RxfvRCv0RYWltI3EA2cwIQZXu4w2R7c5pbauW24Ak1MKoQW9Ph+WBOwpm7n3QyoVn/ZAY3qp9veDQy05rKNy08d7UBe3r8ke+pNj1O2p79q2mmnd1uXuOvXVNTN8NVWLM5FLmmHVg2ii2Ed3Bomn3J+OHhgu4M1B
 3kpAMdpt
 DMcaD4NQOBA5mBSF9XQk/7Xz4PsC5ZFCv4/qgc5ePoDPIp2NPi0Q6TACZUoH8eAP+pA2/aFFPZ/02y6fg2Z5ThJbQPD0iPn3LG3WVLX1EVht/IWn3pR2uww5OFPnDtPzw8X9va5i91Rf3W0t+wlIaRyrSwL6VG013TG34cg2SdnUiOcxafE9UJ9EAql7eW895nVzLrFZfhgLf2WhGkD1CjRX33q0GDpF4GAuY98Th0NpKfKJhT4JtVtfoeac23g5Ff0kVYhNVzQwYu5FRl6bFgjLLGR1sxIFLbgbMNERV8JCflMgzm2LfCvCDevO136/XjD7gbNfiAvzLF4FP/cmDRa8l+SXZvIwT32oIQDAQvWH9ADll7R4j8hFGjGg4Tvlka6vX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 11:48:43AM +0200, Mike Rapoport wrote:
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> 
> We've been splitting internal.h to smaller headers, maybe it's time to add
> "memory-faulure.h"?

Ack. I'm happy to move the "mm/memory-failure.c" section out of
mm/internal.h into a new mm/memory-failure.h, as preparation for this
patch.

Since this patchset is moving slowly, I'll start the header split in
parallel as a separate series, and rebase this patchset on top of it
when I respin. Is it this ok?

Thanks,
--breno

