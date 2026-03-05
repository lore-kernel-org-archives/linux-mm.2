Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A44DF30931
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73A406B0088; Thu,  5 Mar 2026 05:39:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711EE6B0089; Thu,  5 Mar 2026 05:39:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 647F86B008A; Thu,  5 Mar 2026 05:39:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8DD6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:39:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A8335B943
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:39:36 +0000 (UTC)
X-FDA: 84511663152.29.E1BC790
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D35D5180002
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:39:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQbCwe5N;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogDjdSjIzNp47aAjqo3D1Xz4ErfomvJ5HkBg5dLXqFE=;
	b=TVZ5sWYQxxV/cidFlD0odMDE38nZc8HBP2pf8X9+wXBZQLurEnl0bcl05eBBZlkhc/AeQU
	gww0LfItwLbmEZWj5pwG+FWgL6qHfZQRnG4WzRcjsCqX6uR3Uh26SN0Y+NzgebgtYOCH6L
	aVR9Qps0OBXa+2IBHDmrdRKkLIbO+Ho=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707174; a=rsa-sha256;
	cv=none;
	b=DYWboALNic5yg+g8mVP9GYXwXsqlz4xlOVWabexMJ/uF0pRDEiwdjCYIFipNyPhSScjDx9
	+sGeVJ4CxntRx4yl2+RKcR9JUnVZLeykOHjwvgSjB4Ge4HT9YKEJVC7u0S2LeYQqqf9sXu
	qNzvFrPGDA01ggczJmm5TfTA9rMcqX8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IQbCwe5N;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 180F761344;
	Thu,  5 Mar 2026 10:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5AA6C116C6;
	Thu,  5 Mar 2026 10:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707173;
	bh=yLfptqTDk4ppieFzMpM96UgVSqab44mE8I9wfLOH+bc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IQbCwe5Ngtpjc11y94f+iiN0bnx2c6hl5J9XXzGCcGX5Ek/NgjSyC6js5DKRzdIRW
	 gfofayEar1e+FGrRJjJZ8J4hGI6Jc4d3HEysbPobJ6KbR9bepk8mYYNRsdMuNNfhER
	 V8uO2ZExYPS3uS5ncQsdOW/mVOpIu+dxbq0zOm0fgkKf3Ue1nbrE1CxOkZqfNwFFzh
	 JeUTDD9DDcdMJ2a2RqXgJKAKUAQNVaxDCeNSpcatjVu0b3R700v6+VuqYcy4EFKKg/
	 3v5j0nmNtuk8N4pINihLyhRnfFdYYz0evRLP1BaSa0rFuzt6rFPh78W49y2/cZUfXo
	 5bXuXtwxubnHg==
Message-ID: <6b95ce49-383a-4a73-bdea-c3b8c36e9686@kernel.org>
Date: Thu, 5 Mar 2026 11:39:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 12/18] mm/hugetlb: Remove fake head pages
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-13-kas@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260227194302.274384-13-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1f18psom3fqgb9r7wtwqsdsrj147u6qs
X-Rspamd-Queue-Id: D35D5180002
X-Rspamd-Server: rspam03
X-HE-Tag: 1772707174-690138
X-HE-Meta: U2FsdGVkX1/hLE1rlsXqVYNzcYifZlSwXMPyng0jTFJ+XCeMWe3dt9N4ySXQU0NmR9KIQgS6HbpYyiD1JE8sXkvzlWtXnrRZnBTWlHknUInwSaaEquiCyRLFYVthyc8IWNBbwFLf5SjeZiFL6QNu5//rKeXn6hmNDVccOkznIdeMbHwyowLNV6z8yrVXVNvaP/1z95qh8TdQ6lRriC6KWwwJ8WuEgxfStD8sENXunui0OKlTjl35r8owxdxBupDNWNPDVCBy3K1fc5WVkrOQO/BuBvCQWU5rC7YATSHuWeVG9wlDCdBcA1tBQ4KAz2OJYgTLoN0kaTxGWsqp9El5nMT6xQmWBgldscdxk/MRKmipS9SA71EVboKtpf3b/dgOwMhbguQls/YsoQP4vUWoTrYwgkcOIKEZNVxsHDdKht3yCPd1+HhgB8iL9UoPCAe83s+Lrb664O8PINmHbpA4v1MhGqtnjILXyZT6FeuniC9j2ipuNCz/Cs5l/isK/hDxPT/AKgHS1qHHKBrhNtZoAbB6xDyiawVXylWwBAjppKrFJMoY099g/eTsPzM+QBmeRl9GlW5nG88R/oeqIBGyMqOVtoFqfVQeXU0DpReQ4atoXQ7CTmb2C603mrLvOnyLUwWSpXdEdHZbW5IxfscCRXH91+8vlejgt2FYw0v1rl93YCLQW3UEDoTt7f+HdoXkaF1RCdHojYKjG5Pe7kGUP/NeLKSlH2FeG1vQoXaTh7EBiAbttMXlc3w+jrtdYBkx+gqF6iQJ4eu7qIpaFku03/z4ELjqc283VSlSsNacJZfDBUsWnxM6y8mBvhY1aKQoFMk0t+33m5ycZQHkS/K/DNHdabaYshNZZrvinMfmyS4FTMuPC1JoPK44Ymx+XaIt9TSk5Cnio50eiGTuvH4bgGlCpGj2Dwyqu30BhE8G0kaVamUpshXDODJYboTurDUerNUi+xCMxQf1f52z5mD
 e4yQ+PLk
 Kl92kOPcQ1lcRVaGzUidWVk9tgfeidufz1G4SnoUi0Fn3r8+ah1nWSiQ2IP/Kd9GLykU3dJOemdwWbf2W+NtflBehqrMN+J8RMVVNb58qXWc9ii9igZYdzBIuPCNco8D9qBn/zVUAekwXDz4XjCWmzu7kIKfWWdX2I04TuLiL7daXW5a2e3cfGUhL81HUhPeLA2hT6tXJO0qF/frZAKnohSFIWw08xuSbV6aeEqdStfhbD1ggZVBICkBTtoEFWkGA0jwagTv7yDs3k+eTBxto7m83pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 20:42, Kiryl Shutsemau (Meta) wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
> vmemmap pages for huge pages and remapping the freed range to a single
> page containing the struct page metadata.
> 
> With the new mask-based compound_info encoding (for power-of-2 struct
> page sizes), all tail pages of the same order are now identical
> regardless of which compound page they belong to. This means the tail
> pages can be truly shared without fake heads.
> 
> Allocate a single page of initialized tail struct pages per zone
> per order in the vmemmap_tails[] array in struct zone. All huge pages of
> that order in the zone share this tail page, mapped read-only into their
> vmemmap. The head page remains unique per huge page.
> 
> Redefine MAX_FOLIO_ORDER using ilog2(). The define has to produce a
> compile-constant as it is used to specify vmemmap_tail array size.
> For some reason, compiler is not able to solve get_order() at
> compile-time, but ilog2() works.
> 
> Avoid PUD_ORDER to define MAX_FOLIO_ORDER as it adds dependency to
> <linux/pgtable.h> which generates hard-to-break include loop.
> 
> This eliminates fake heads while maintaining the same memory savings,
> and simplifies compound_head() by removing fake head detection.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

LGTM, glad you found a way to do the per-zone tails and not pessimize
page_zonenum().

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


