Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5153E606A32A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ldFyW8Sv
Received: by kanga.kvack.org (Postfix)
	id 606526B05B7; Wed, 18 Nov 2026 09:42:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD7A6B05BA; Wed, 18 Nov 2026 09:42:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD186B05BB; Wed, 18 Nov 2026 09:42:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8D76B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:42:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5142BA831E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:42:06 +0000 (UTC)
X-FDA: 85448504652.10.252B28E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 98978C000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:42:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldFyW8Sv;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QT+a4lJEqwyl0jCFNYDDkazhdWIsc4Kyy0uQnU2xGfA=;
	b=lm/+eN5VM8z/c128qLP0ni89N9pxZxVeQIlJabmgFB7TXVYNqwDniu5XaG2tcqT0dTD+pS
	GHAclWxd40QqN3upeTXDWopJvEjxA+d5BhhJaXreFxnHmAbfFsWTfm0lx64hR+xBtMwd+J
	39+12NOpnBMwSLMno1CWZ4woEQYTz5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012924;
	b=qKp+CuQgQO7iOBtJC4MQVj8slrPNfs9TcUelzSeGZM89CwX1cv49qUCoWvvR6IzN06/JPV
	sIKzo2PgCWsqv4Ay2sei5tChgAnhGUlfWf+vs3WuigAz2UnDiCBTh88G68UCc5UzO17PNt
	hAtYuSQYZdWXklgqUN2RnNyC2jw4Sww=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldFyW8Sv;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC96645FE6;
	Wed, 18 Nov 2026 14:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962D71F000C4;
	Wed, 18 Nov 2026 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012923;
	bh=QT+a4lJEqwyl0jCFNYDDkazhdWIsc4Kyy0uQnU2xGfA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ldFyW8SvbFTu9lKav0563xlXtSIQDbuyg1xw2e1nayTCk55kJzo/1oIgWmE26bdOW
	 I8FzmF9aprimQoIkvuWBfuRY1tWhSSga7PfFDuWSQ6p27JjzMI1gpVFv7QncfHIceS
	 Zg39lJed+6fQnfUKqsghD2+ChKDtMGhkscJqAmH6f/MUVEVwDQ8iubpD1Uqgg84icI
	 kqWCa6Fp6kVxQMdfkTTMTddleIftE+RdOCb0XKwdKuTAap/o5R3JPQ1qou/Bm2QEb2
	 G69xSnyim1VrnLrmx+XsOW/vLjQquvVTdfu7545IancepkA4OFfUHYuBPgSrwAt3ax
	 uu7WGXF8ov5zA==
Date: Wed, 18 Nov 2026 16:41:49 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 6/9] mm/huge_memory: build the moved huge zero PMD
 from the destination VMA
Message-ID: <av25LTtBq1hWfEIC@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-6-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-6-b617009d1a4a@columbia.edu>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 98978C000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: z1go9878egj7e6yb3bi7iatp467qdzeg
X-HE-Tag: 1795012924-137508
X-HE-Meta: U2FsdGVkX19vw09thHuqZjp+Fx+vlJQXsqjJADfvKSUfcnRKembe9P1e1RPi4/DBWMCqnRFhLa2ZkE+YYGotc7YrDsl9HL+LgR5lXosZY2jypRu4e4BW+5GaEqX/xZcEpgYcoSvIUsuK0+Ta3P8NKZh3jiQtiZMc5sBpPGGwIhHDACrW+B8+h3IhXpLcPkiOrJvGcESbgs4TJPMZAd54t6WZ3+QInxHwcbNCTtRL85jp9vGLNDgjAi7ePAYRA+iaiIonhlfY/PLyN9dAN9itnjCosD2My+P784siziKSDV7/2PfD+gEoPfVDj+2crdZq+49HJi2R5lQ4i0/osQNaNdoAkQZbdkq7VsMgjykZSWtym/1VeX9+0qukOyvZafgrh+LEflm1bbqWdJgTl3iZ2hriUXg7+QNbGF2J4RO+52wXeaVgqbx3ceUT+50FRPm9LFczUoCly+3UVGxnimRx3Jn4g/FW/4LI557kunoKi7+TzgkBr9PdoEyo3qH77EvSRdl2hGhQm0+fjPX/hFQflf350i0i1jRnJfwLw/ULN9MCdHWO3k2EG1BK0BecvH1B8T23HTO463QTT3XoVBUyhv0odnVZV/JgRjJGdIYqzdxxk0yC5+64In1Ku2TasytMKWRSbewbmvyttjZubz5EfL0di9sxZ/UD88I4zg8aj+lnWM007xJzfYSBwuKVfomQSH2q0jMYRZZLGacLS1F05Hb/nC00aDY6QTSVS4bYRAYFUpvmqEOqwNTBhSfKa2KFYAftMWpYTkJZbDTGr9lZu+yomYugdaI8tGdpJpbHM+1OgbsTjhMwyDYNAEP6UpRyGbNYHda4B0TvE4SbqwVgTrS0lw+FcwEthq9KJWRbO7tWoOw7/J7KyhUWnVaTANwgpP1mS4oKceFnWz8H0iETn9T3ZBIjCFG/NcvRgZSDHXwcvsPQkQnt9TpBF58ycnaKeAHtj9T1pB6itYyw+kU
 ryh4KzDi
 uetr5gR1v484TOOh3zYz7Dgv5XjQuPqnFLbcCPRMnCApCbWQjG7bP7yv9HYRzToOWbqKcht4blYhVO7fIU0LjGnblJNxSoIZAZar4gUOBKfBO9oiauGZxETx58gzK/F0Uj+B8BeM2Iz6Mtoi3xlp6Aq736nzigQa/6gKW2ftw/vkwkPOwxN3fiGPmn61tOCeT0aKw2IEHPa9GOfyfQwCFrArTK13n9ubYjzR8m0ijqhsj2ir1lhhfuBLnGC32ZhkZx8jRBe6mDKMww9HLXxL98rOLQILgzEJpgr7saZK7Y4xqOI7UQUxc7Oo1HJtnmlCIkPPAQ24E++4JhVFeMCRK1Cx7Jxthyi9+5Gu7BinlP0S22QCRM8x2jmtmFpGeswmKvPMQg5cuK+dClfXoQcUMZYKOQWqQc5yZgJWEZUQYZYtVQaBq69hZJBdzyG3dl+7w+p337SjU9Ve3w5fi6E+9OovwiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:46PM -0500, Tal Zussman wrote:
> move_pages_huge_pmd() builds the destination PMD for the huge zero page
> by copying the source PMD and clearing its uffd bit, so the destination
> keeps the protection of the source.
> 
> A source VMA registered for RWP can map the huge zero page with a
> PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
> registered. The destination then gets a PAGE_NONE PMD without the uffd
> bit, although nothing asked for that in the destination VMA.
> 
> The next access fixes it up through the NUMA hinting fault path. Until
> then, the first access to the destination takes a spurious fault and GUP
> has to take the fault path. The impact on userspace is small.
> 
> The moved entry must have the protection of the destination VMA. To fix
> it, build the entry from the vm_page_prot of the destination VMA, as
> move_zeropage_pte() does for the small zero page, and keep marking it
> soft-dirty. A destination VMA registered for RWP still gets its PMD
> re-armed afterwards.
> 
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/huge_memory.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

