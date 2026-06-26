Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45441CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73C0E6B00F9; Thu, 25 Jun 2026 20:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7136C6B00FA; Thu, 25 Jun 2026 20:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 651316B00FB; Thu, 25 Jun 2026 20:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42B796B00F9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:46:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BD3D51402FE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:46:23 +0000 (UTC)
X-FDA: 84920222646.29.5A6132C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0A91F80011
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:46:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ttuUkkW9;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782434782;
	b=BdNtN+mbw11f1D79jnutQGKnwIzz/mc9q5p2XtEM6woPjFurj5Y7Xh4Ew47GfBK1GpCKdG
	YGoiYns3bum/xSilPrCH6y1O9IW9IH+/xe3NQdqCjlJNgHxnQZ8ZVlU9gJuxCxtmoiS0xQ
	v7BjRpHkK6Neu6HfDf1P5Ur8gEPRH+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782434782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aVwnJDGi7HOXHyeM0jNjwmLxXliLE7L625+/NqaYxmg=;
	b=2UTklTgNyiCY7NrdEIY+WTjGrR4QZwGHE+syqFKIRVAwBd7Rm43ixufpAlPcR2bOgmgfvV
	Xsql3nrnejsHOS2DM3o+vQRYTnkoOEaASZ0AP+yv+GHdOTOjfR9h9K58diLpRNTBr7+EaS
	/jnNJNtfP0ylTkepMvPx4RDfuYtyGfw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ttuUkkW9;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 746FE60098;
	Fri, 26 Jun 2026 00:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903801F000E9;
	Fri, 26 Jun 2026 00:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782434781;
	bh=aVwnJDGi7HOXHyeM0jNjwmLxXliLE7L625+/NqaYxmg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ttuUkkW9XB6RuZTLYjeJ/3uTYeXRf6yq0egZXdrkILgAmZizyGc15vX5NyM2XHWzD
	 tb2k1YiKgsHTU9XgApnhlqlUXzoIYDtrltk0/8s1pLM+JAaHAVeY8PIo2wZL+iaNvF
	 qR60k0TTyAaXwmuUmEv88320MeMUOpwVNwW8AI7A=
Date: Thu, 25 Jun 2026 17:46:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, David Hildenbrand
 <david@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael
 Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, Mike
 Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Ritesh Harjani <ritesh.list@gmail.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, Mike Kravetz
 <mike.kravetz@oracle.com>, Michal Clapinski ? <mclapinski@google.com>
Subject: Re: [PATCH v4 00/19] mm: Refactor bootmem gigantic hugepage
 allocation
Message-Id: <20260625174619.45d7b772b69b7b54b7f3bae1@linux-foundation.org>
In-Reply-To: <20260612035903.2468601-1-songmuchun@bytedance.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0A91F80011
X-Stat-Signature: fufbo5xfuc5apht64md56ro9nrh8ohoi
X-HE-Tag: 1782434781-727338
X-HE-Meta: U2FsdGVkX1+EB+DWpg92BPnF8wI15aKDyJpk/dTZ1SY3tTpEkIhP5AMQD/G+9wixHO6GIGMvF9oMCjwylPMKv/B9YIaAPw+foQh6iNSTtEQSpwBZdEXL2If4gL4qs8ODpM6T9iy6kwn4ZXDAL8PMFpVGJxjdisYWVM3apC2GFn2HHEo8Hs/IA5IEFtkz+vdUcRXurcN3FclpD5XXzcd+9aUwqHVNk9bVO/EfAcfuw0HygDY1oy/elbAyTuu/AYc7uolt970aTl6STu/VvQSsO2BSNZqU/DASR9Nq82ltG3J34LrkAljMaX+PiOaKwlGDrVqsmW5g8IhBy1DRhBd+WhdbFKiz6+bnMDrQkSOJ9DJ8NcamBeeGRjhkPy613sH2RRJNmBgjZk9o72SXR0ZMmwNqNdAnG4Q1CPZlCYNN7UBWaElCDsnegiaqlE+Zs++OMEeV6kNQMcwdkIBULqdbx7DxeAkuLXOE82es/RRt727WTkKb2GP3P5Rcv8XoCRvTz/XUCorvN/7wwgQJc+2kvRxEVapNWDEd0sHoW77GOtvQOHOUfaO/27mVgEx6CKrHvH+HWQOdTknT2nvcuO/sOdYHh1dDYEno93b+AlX2Y0wtnZwKyiMFFdoPvyLUPmA98QIWJrkUWeXJ7imY5dk4CQBrvfeylxWC1vshEOd/qYIKkx6d8L462gAufmJ7hnuyRigtkU+GC6NDD2J/R7vEu8SNIRyF0hZrUN0zLOvdR83o7mK+JHIdM1Nxi62fmquSQF72/YgHttTpsmjM1rpOBHH30wcJnAAKI8jscy5f3QTVCSdyYRaupPW0aE5WC7puf0dwbXQTXTff6OFa+euSp/S0oPOZrnuoD+V8blypVEqvWz5KL075s4wT4LmVj6/wJ1e+1ahnaU3a1iBJtAC2FgqIAfVIwv7fOiW70R4AreNGXDYDWKaszcI5QdOzLyKAbygeqLH/J87AW3PKTH4
 NtViOTD9
 LYk0pDpjPCykRhavai/86uKW5jglm2qntgbXMUFkow3B/1cz5RdDrUQ5rHWN/ejVQwYpobZmwCC6lYSqrztWIXxJ62kJFNdcfC8BCtkboAE3QJIqtaYgIFS8CBhEjZMLUE1U3BhV+Pymy6uqc4LcFve2ErM5UEN2Gf7pQf/pSVLzpdxjgEViBSF+zgSaq5LWMtKQiP3sq1iX2lD1lpxubGf1JNcOvZWXs/kEFO/Ld5Xnezht1LIyHlCpDDrCOaDFgbJHzAVrX64gRMTMO05ohcB7nWD1s/QM9Akaz64b5y/5nCdkYFpJ/9EasHvM4C5RYoQg+08oXnk/0p2dgk03kFpi0ab3SpJ99iiAiOOIwL6Jp04CAGWnflywbFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 12 Jun 2026 11:58:44 +0800 Muchun Song <songmuchun@bytedance.com> wrote:

> This series is split out from the earlier larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. It collects the first 19 patches of
> that series as a standalone set of fixes and preparatory cleanups around
> bootmem HugeTLB handling, sparse initialization ordering, and related
> vmemmap setup.
> 
> The first patches fix a few bugs found while reviewing the existing
> code, including incorrect bootmem HVO handling, wrong vmemmap
> registration arguments, a powerpc compound-vmemmap tracking bug, and
> too-late initialization of gigantic bootmem HugeTLB struct pages.
> 
> The rest of the series reorders early memory initialization so the
> relevant zone state is available before sparse and HugeTLB boot-time
> setup runs, then simplifies the remaining bootmem gigantic hugepage
> allocation path and removes code made obsolete by that rework.

Thanks, I added this to mm.git's mm-new branch.


As requested, I dropped Michal's "mm/hugetlb: init tails before
init_migratetype" from the mm-hotfixes-unstable branch.  Michal, can
you please review and perhaps test [01/19] "mm/hugetlb: fix boot panic
with CONFIG_DEBUG_VM and HVO bootmem pages"
(https://lore.kernel.org/20260612035903.2468601-2-songmuchun@bytedance.com)?
Thanks.


I added cc:stable to [01/19], as CONFIG_DEBUG_VM is not uncommon.


I added this series as-sent.  This means that the four cc:stable
patches won't be offered to -stable maintainers for 2+ months.  If you
feel that some/all of them should be upstreamed earlier than this,
please let me know and I'll make the necessary reorganizations.


And thanks for checking the Sashiko report.  Dang thing ;)


