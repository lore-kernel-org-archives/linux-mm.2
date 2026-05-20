Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0C8BCD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 07:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0017B6B0088; Wed, 20 May 2026 03:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF46E6B008C; Wed, 20 May 2026 03:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0ABB6B0092; Wed, 20 May 2026 03:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CFFCE6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 03:28:02 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60BD5160515
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:28:02 +0000 (UTC)
X-FDA: 84786969204.20.1C39B3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD470140003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 07:27:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUbzXZ1J;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779262079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fdNCyqGV74cbHs7F0SZMzIf3smavh74AddJTHydkYMc=;
	b=sNQEhVUswxBjHSfsXhJL19oW/YENDef3iErFTMWCJNPTxyX+4+mLTfAg4C5hK2dYZYDgiN
	ycbmFdpREnNnMDkrH7oVmLZMCWo63ZrZadz4gUckd3RvQnPMEGAIFgjTLkVWbM+qiyxKzo
	6L7gpnsD/NJIuiF+V9WgiUulxgqR3OI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cUbzXZ1J;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779262079; a=rsa-sha256;
	cv=none;
	b=0tynSFmpCGuUOtZhXYWftJ2Wgd6dP7M5H7yfizHXUBiZYmatxvg0C8XYdsgctLEhnQdwYA
	yD4q5aCx9kHEkWaTqa8PbDf1SyMRoN0tRqqtqxYdz6ZZiQyqVlmUBaOszlzu6IxiYUCAmB
	uaurVakzYlY+E5ZLjjiRDiVgvrGHqfM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1448B60129;
	Wed, 20 May 2026 07:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9087B1F000E9;
	Wed, 20 May 2026 07:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779262078;
	bh=fdNCyqGV74cbHs7F0SZMzIf3smavh74AddJTHydkYMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cUbzXZ1JQE9hOplo14fkRNL1KuiWzGuRXRatg7w4mliawFyYBAIT8SlveWysOloIH
	 5lsvkPIjDYo2xKQ59XA9is5RnZx90YB7apK/CD4ELVmCZACojyipxSMedutkuFPl7a
	 5WaM6J/Bi2OlPn3tT+zoCGXxUWvoolz+zajgfamRmzJn2IGLUnbVRoXt0PjnieyiHh
	 XsgYxMEQ5edJSdkNxW5+CgjAPBwiv3aoKxwbZnI3kCozH5/ZJJMOqlhZIB7nc5Set/
	 OoBJptdK9TNOW5b+BnqMZ9hGfjpCKziUSc1i0/KLl0LOBrBxQ4BAX8mD9qV73KIi68
	 Z/hnm4+QqVurw==
Date: Wed, 20 May 2026 09:27:44 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	Stefan Strogin <stefan.strogin@gmail.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH] mm/cma_debug: fix invalid accesses for inactive CMA areas
Message-ID: <ag1icL5DPMVXwRta@localhost.localdomain>
References: <20260520061025.3971821-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520061025.3971821-1-songmuchun@bytedance.com>
X-Stat-Signature: atgrhzhe8mpnd7p8w7ycyoy883m8ewfq
X-Rspamd-Queue-Id: BD470140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779262079-986329
X-HE-Meta: U2FsdGVkX19KQakDi0mdQYztXLvl9axvRLTeiJ93NFRnlqCaVBPkZ1efXTyRADMr2lsamll6IVJUvwvOD9AnepAaE4I6LnzUOwK/0J9dTsN0Ar+HO+iVs0JAeF95+kTEk8S2xqOhVcp6rbccCllFv0oA8N/Pfo6TgZ7kfEuEn3JAGan1Zcu2LtVjNXRtAp/eZFMI0ffdCz3Cj7o2kIFLVl9cLnz3D2GnvIyJa54VQKJrM+i3hURLXsxVT2NGPSUITi38Vbdogeh8qiAR181VbZ+7FAJzzSnc+wpoVAYPXtSNEgiv4awwXixcIS6t8DJzXg6G1D6Hi5Wzlt5b8R3f2GdCgIKbPVnbcsuN+sI+Mkb8KlZEfaUMTm1isuBUj0qEiUabtCmCRoLTQ+KctOCE3i3bdd/6oi+WNulVdbnirNYK0phJV9BI72ybJZhrp0USzyAbUYAvJWNjNNgvXzAshagFrKH3jUkuTHqnVRAfpjn8ugN7MOtrPSL7ATBbh1ReT9HCZHppSLM13MpHa6xU16JgOLoUBbhNFQ7Gul0r+YyGVGBxlsXehRZGcOvoDh9WpaUyYPDQk1ZqhJpX9vx6V62jpKOzrTKjTXL/cUW+hjJZJ+O4vpxlgX49A9rvKkajxCOHFUSZZs75NqgC3F9jQ1bi9PqVw12CG3E+yl3JQEyZi7ptAquUAl56mR+QLW9bQRTNFY+gill0oYXtFW6Ut+ldLspXt4cJUm44pTmLHyseAxk3L95QzozlzY/LoOxoX/uEULbF4ARXtjAAZu3sRrK3XSnvViFaruYU5zbBq3lwfjCfDbzyZoaJ5jnCn0HCjIT25+3PTNZ5oFcnyCYqAYACH/kIvk30YkNbf91K/6uUWXdjzczVVwdrqZDSf1DkbMyzKKiUsHhpRHf9APuXsmy9g5A7euV5ce+mT21z1itJfNiH6HDTLwAwI0K7UrvIDjYxaDcNqjABWUsfvsz
 2prXBvAs
 8i7cJ3iDwQbrOoYbBtSMzLiUmoP0Pf/mkDhBR6MvBLG5uQ05p0U1terwKPcVr49Rnj1UtVQg3xKkSyoAFznJijtWhvWd5ubB5CWgVQ/aUcHEyn4mnDIzXSqlQQngpgTAbonkTQwls1d4hSedenJtZtdLuK9B/HIXsgv7zXjNpgGLA5r9EXgQvrAx5XmO227v7j3agWIQA6OhO43LqOARJUnijQH5oSMh/2QoQcs5KEVt9Y153HeNjJ1zFDEPznJ9YLGtRh3Yi4WXFTjiLDuzHSin0ndbpCU5MBF9hIGvaC85cthdgdk4/ln7fd2kPfB/zX85vL9OpcZJtOPtSOLZfbBdNidJseSmA/gDdoYztbeIIPr2puQ1RhWpW6VBWxnhVIpDK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 02:10:25PM +0800, Muchun Song wrote:
> cma_activate_area() can fail after allocating range bitmaps. Its cleanup
> path frees those bitmaps, but only clears cma->count and
> cma->available_count. It leaves cma->nranges and each range's count in
> place, so cma_debugfs_init() can still register debugfs files for an area
> that never activated successfully.
> 
> That exposes two problems. Reading the bitmap file can make debugfs walk a
> freed range bitmap and trigger an invalid memory access. Reading maxchunk
> can also take cma->lock even though that lock is initialized only on the
> successful activation path.
> 
> Fix this by creating debugfs entries only for CMA areas that reached
> CMA_ACTIVATED.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Fixes: 2e32b947606d ("mm: cma: add functions to get region pages counters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

For the change:

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

About Fixes, does this mean that before c009da4258f9 ("mm, cma: support
multiple contiguous ranges, if requested"), this was already triggerable
after 2e32b947606d?
 

-- 
Oscar Salvador
SUSE Labs

