Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6EACD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 09:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FD586B0099; Sun, 14 Jun 2026 05:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE736B009B; Sun, 14 Jun 2026 05:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F06C46B009D; Sun, 14 Jun 2026 05:14:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E2E866B0099
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 05:14:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74F131C2C1C
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:14:45 +0000 (UTC)
X-FDA: 84877958130.06.85B9583
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id DA850C0002
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 09:14:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UMx8Eb/8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781428483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTdII44FGFmJdbMtCPKaS2eB6vk6Xg9WicWBVorhrQU=;
	b=xp+pwooHb1AQxlFat7qFXQSDR+3Mw2XW58GqD/soQHrARYYMR7oMk7gqCZjl+TJcK1iiSv
	jZhL3L07xkDjkVj+0IBFvgZV+qG9XTKdzGkVmUSt9XyxheELW6k5RRuj6GrrSiBM+q52sW
	YcnrwM8WUVy8H+SZxHEAVRwcMWAPC5o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UMx8Eb/8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781428483;
	b=WWN8RreUiykVaJ0C4wNb+iTthlmGlwzkbDgW4sKLM+ehOYjxzIXbNsbgxsGJ3VAiA8ikoA
	/BHn7oaS4pCWQ9HfjVsskCci7pDi2wCIM0NGkxHDx9WrnDzBFLsFPiCuJeTTpzIMJQZq/X
	RzLIKDU8yODavh4tYUmTt1d3a7i6SkA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C84FF44369;
	Sun, 14 Jun 2026 09:14:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9BD81F000E9;
	Sun, 14 Jun 2026 09:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781428482;
	bh=PTdII44FGFmJdbMtCPKaS2eB6vk6Xg9WicWBVorhrQU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UMx8Eb/8JnZEGxjCkj5fbSZIF8ouy/FZaJqolliub6IojIr7yzYw9OXytXU+YyLzG
	 1sfXtl3YbiZTHx4pobKS44wrOe/9MYhm2tWwd31Ert3JNdVaXqg114iI+UWTuy4OjW
	 eEq7hlRisAo9IafOG18VOinIoj/K4b0RqrIZFDM1y5lIoa8PmtHJeKDDrIZSW/aEVw
	 WaSKWCYHK5mZ04tE5rKZ8HuRwYBK/0w2yG1YGIlxnc5hKe4rk9Nn3wgPZK3PHPflvl
	 Us+XMr6qFdCT9iRh/a2jnmp39Sb0AR4c4PW9TiXmXDwBbHO7SOyAGNjWnkqwUDaRak
	 h+seQ0Hl9eOnw==
Date: Sun, 14 Jun 2026 12:14:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>, linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] docs/mm: describe current criteria for enabling split
 page table lock for PTE tables
Message-ID: <ai5w--zzNaUHuQ6S@kernel.org>
References: <20260613221448.98657-1-enelsonmoore@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260613221448.98657-1-enelsonmoore@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DA850C0002
X-Stat-Signature: px5xt3qyo7nmk7ahx8rpgw7tusmeixb9
X-HE-Tag: 1781428483-331235
X-HE-Meta: U2FsdGVkX19bmCNkug9N3u5KyOL/ZBuRKalEGrIt+YxHLEC9DH84lrII0gnmtJ4MjwtA6IbN9rw8aJnVdGU7rVQaSseHCmCdcZrzy1tiA+3xZ3XOGLDcBFDo/mDdKnMSYnMg/Ydfiynv1c2FR8WcGORbJ3sVZqHc9aYqY80ABnwjkO6IDQPC/Uzot9M7wTQylR61PIBNRisdSBUD96dE7hoYFPcNcQ0bnV34iE6yxuL793o77O203KsfpmNEW465Yx/g5/M+ppQDlZjxgWIL39yAZwAEuKhWSbJTEK5SkUtxTnc8zxvWwQkK5kFDua3L2dAuHlDeyMXWlqZc4jn6QmKb49uj2bwLDYBUcMZXL+nuAT/MS7LlQY8G16BhysYrWAgU3iVvrREBCLsnkXyZQ6i5mLzlymXs65NPJvqHPt6txr7miKQsv51xFbeJTDRRNGbZQdX13a87Uu9Sozj1Y+520hkx538R84d9u1l/+Z9+3NHri3nLm1GkWQUsuDtxhfBuSASWMrRFgskcVpYYMTAY0DVtmUPIlB7x4kt6qjbr6+nrDjGAHbN/OltYFg0rk0J+UWBX4R1cJDP/FOV0knU6z8XjoXLIanDfwyNgDetXGUeEmGxedQ7VvgtNDnnVpKiENkEp8HtYD3+BUV+ZbPsvmcn08rxLkR9zFTtHvzNHNNXJl1wiGlycNKnDUGH2Jq24XJVXcyt2iU8yOAU1LdSOJLXTeQvfrLAyGdvmYXiWg8L+F+cc3dRJvQN40gPjwa2UfZxzDHXYwBCAY2UUnU+po1+BgjQbu3Gk8y/M+0TuuGEp6nWlotZc4PcDUL1krlQbz8TUZuQQlhZqkng8IrXGb/PLW5IcUGfEodvsEYdFjAITihL9R6L5Hzp8ktxrvI6flrGIFRWv3Ms0DVbs3b0+ZKNgR56q/H+NfAK/HXMY+LP216WPMxQ/0DTlWVtVpHeGB9r568jqL6C0pEN
 QsMCliX1
 ePx8mzjoSJACesClDmfhzCT2c5HJWrOwKREqdi4SHS6cixDFO1OgBsrXknhGmnIeCwkUEdXw0Y3thCabaxWh1GlJWDOV4qsHyF3aHY8AD0MTxMiOeoJKa3Ngm4G4u6IFd+/bZHUTGHbbW+8Lsp9v52qTnuxxio0vKI/3PPqNxAcrrQS2Il4QTYdlIRB0x76eY1lxt5fX6tFy4AE14cXLElwvavMkP11ES/uURKEqeGjwsdSbpwZWQ1+53rLsG4bTQfQjB+HPIkjSSNNtSYyq6deADPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 13, 2026 at 03:14:47PM -0700, Ethan Nelson-Moore wrote:
> The mm documentation regarding split page table lock for PTE tables
> refers to the CONFIG_SPLIT_PTLOCK_CPUS config option, which was
> superseded by CONFIG_SPLIT_PTE_PTLOCKS in commit 394290cba966 ("mm:
> turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig
> options"). Update the documentation to refer to the current option and
> document the situations in which this feature is not supported.
> 
> Discovered while searching for CONFIG_* symbols referenced in the
> kernel but not defined in any Kconfig file.
> 
> Signed-off-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
> ---
>  Documentation/mm/split_page_table_lock.rst | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/mm/split_page_table_lock.rst b/Documentation/mm/split_page_table_lock.rst
> index cc3cd46abd1b..c9d16024543b 100644
> --- a/Documentation/mm/split_page_table_lock.rst
> +++ b/Documentation/mm/split_page_table_lock.rst
> @@ -37,9 +37,12 @@ There are helpers to lock/unlock a table and other accessor functions:
>   - pmd_lockptr()
>  	returns pointer to PMD table lock;
>  
> -Split page table lock for PTE tables is enabled compile-time if
> -CONFIG_SPLIT_PTLOCK_CPUS (usually 4) is less or equal to NR_CPUS.
> -If split lock is disabled, all tables are guarded by mm->page_table_lock.
> +Split page table lock for PTE tables is enabled compile-time (via
> +CONFIG_SPLIT_PTE_PTLOCKS) if NR_CPUS is greater than or equal to 4 and an
> +MMU is being used. However, it is not supported on ARM processors with
> +virtually indexed, physically tagged caches, PA-RISC processors older than
> +the PA-8000, or 32-bit SPARC processors. If split lock is disabled, all

"it is not supported on some architectures" would be enough IMO.

> +tables are guarded by mm->page_table_lock.
>  
>  Split page table lock for PMD tables is enabled, if it's enabled for PTE
>  tables and the architecture supports it (see below).
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

