Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5673CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4926B0092; Wed, 13 May 2026 04:41:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BACB6B0095; Wed, 13 May 2026 04:41:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F88E6B0096; Wed, 13 May 2026 04:41:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC7F6B0092
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:41:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F07A1A07A8
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:41:51 +0000 (UTC)
X-FDA: 84761753622.12.41FB901
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0A4C40007
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:41:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gF1ZrZh2;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2C3fKVu8ZecWuoJ3nOe6Vz6QaIlyNcNPEBJ1uLO+ojw=;
	b=WG2s6MSP8VlQnb6k3JOWBjKdLQEQrbXlYO+MguOcOXIK2lFYRPIinMVJ2EKsci/mkaKoy5
	dmOcbSoZU3ee3ld9Wq2/rHWjp8wsiaZAwMlkEj4purnD8LeNEaYipSxwaJFSicdNL8gapJ
	tfh949pt/bTtwdRu9tnvCrcOVC4UwX8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661709; a=rsa-sha256;
	cv=none;
	b=PegpR8Ohl6fg7exnI7b7cpXPn+GhkNepEqfgrJW0BjPNDUud24yJtegdcGYNTvC+C4eGii
	ER63CueKvC7mISClHq0YI8pr8qPFXmqSEb9hlzx9on66jezqQZdKu9LO/5wphknCFMNhV6
	K/6BgGX1Ur44wawxw/qG8Ne6iStclnw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gF1ZrZh2;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DE2C600CB;
	Wed, 13 May 2026 08:41:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B4BC2BCB7;
	Wed, 13 May 2026 08:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661708;
	bh=G5ge1Ms5w5w/WOlbzkIN+oCsjgnKKihgDEBHNY+4t84=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gF1ZrZh2z0PfjXk/JaTiWJN3Zwq9n1yXdLYSwGgtH/UbaPGBeI1PqTFOWu+uw2fmv
	 Lz2BCj9WAqFkC5+okdC8bt8qsrUwRjoGCTtmIVx421M+sYpp/fzlPQ7U3GqhFJxpOL
	 eWQd+iFykyLefV4HtfewUidnx08Bm8oy069QupPbc0Cg/FoRNW1zMl/3q4Yz+fXTYT
	 9aWTDk2zqKWoB77yQ/FdvQ853sm5qE3FID4NnDWBftlpdWIXTHmYe6kyq1pbxwW53C
	 BpnQCY6u/QtkKHB4t28Ckn7ckSQVCqHqbbhViJQ80UnY04G7AA9ybc8FL5okBUdu1l
	 vjNSlJ6SsWKUg==
Date: Wed, 13 May 2026 11:41:37 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 8/8] powerpc/mm: remove CONFIG_HAVE_BOOTMEM_INFO_NODE
Message-ID: <agQ5QVEyMsEcKbxa@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0A4C40007
X-Rspam-User: 
X-Stat-Signature: s9euu1rejzpeta335gmjajjk6wfsyida
X-HE-Tag: 1778661709-913004
X-HE-Meta: U2FsdGVkX1805OMRw3OHXGGQAoys2VW3LF7b/NCZS8AwU6H1+bpZ/LObHK2X8CIypySTLUHvEM+mOWWlM9q71QlbyzOmhWzkFvAHH/bOefP+xwZ2nJ2qWJ4vdoGHoIwgtCDuw7Bb/u1AYkw5/a58IEds2ycYXc0C+4FR0XRegdsDG+c+ysjLRPp5HXWw+oPyGfQ2iKzTcqUW99hvbiaeGLk1lu0eL54Y+oDXmSvf1Jb1hGy8KmB09sHE02pBhj85rwCN7GSkBE//1MLkmuIEHyq8RVthwcXDu/dZ4kitrtmKr/ZMWiz+D88fdHb+faKOqd4kfFEzJH1u9D9o6mHPygZdtal/DH+88by+R/kyJ7wFXq7/hwS9bU3vrGG81r2gxxtzwt8TSxcIeFF8gCuMROaWA/CY/aBJVakNIoTqw5zZG70oJbk2Yv5wduOu5onA9RtnpaIFJ+lq4KcAu4XrzJIVBZooebDLrxCcPI7PWa4cU11xUSNcg3DVc4eQceCXpBZf8UnFVlXSJz6USbO9EkwS56V2ECRL8U1ZmdEDZ1YyEmoCysCo+4tgGPf92AQMoqbFMJjOHv7RMkuRybMFzd1J4zhYpcqcynJ5dPwu1X6UbYzOgiUDDfy0c8oxl7Mm0hdcRdCKzcTMeSoa+IlZq82un4RwyYwRyr8tVus3WrIszzYjFTR0cJd5/VLrRPmb1tmFNW/khmfyvqVd4xK0G+mNfdlFFeMhvWngw5n4J2GGM62WN4PF2wtq6Mdm8xaSVLNkw4d7b5uQQUVzfZZ0tP/8kJ/x8c5l/vHG1v86XzzUFsSiFNevHCrtEpA+hqFbQLie0DxoT8/BH+kfQ4281IJ77u+KoneOaTVUW3+SM6pFUpluHgMkwwB4bMn0uBAuojE87cXZuWcOejTqNThBHtB63FSVYwLldT+gy+3f9pGr5SzGXWrv2zVTl2iZxYMUP3ujPrjtnJUOKMmtWJY
 f/AaFMiM
 fCWGWlK1+fJlqEOIBbqcXscj11/lsFEbcCgNXZ/3BDQyxYIUyGOJ3CNbtKNtvMCIYF4nrgBA41cVRLxBK6CiOtKnQxHFQbG+4ySJ1dCeNybsuMmbDnk/4ZM3uwrDjS7twz5zRt+l74NTOUl7ggQNTpCXME71NN7YzEkXDrB+eXovwWcbMauTPkNZsoEKY0sVKDga/iy6OETpJTu9W0W5x30yKXYausipyZgudFgf7D4GchWJmA5xPEEADkrGzhQmvqLRamSWVQPiiD7Q08DzIgC4NuEWm3COZgc8jEFIopRZp0/d223UzodgQMFQnM35BE5I9jLADgLdokSeosT8m8zHMu20t+PgLHxvR665X75hilj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:36PM +0200, David Hildenbrand (Arm) wrote:
> register_page_bootmem_info_node() essentially only calls
> register_page_bootmem_memmap(). However, on powerpc that function is a
> nop. So there is not benefit in using CONFIG_HAVE_BOOTMEM_INFO_NODE
> anymore, let's just drop it.
> 
> We can stop including bootmem_info.h.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/powerpc/mm/init_64.c | 8 --------
>  mm/Kconfig                | 2 +-
>  2 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
> index b6f3ae03ca9e..64f0df5bb5cd 100644
> --- a/arch/powerpc/mm/init_64.c
> +++ b/arch/powerpc/mm/init_64.c
> @@ -41,7 +41,6 @@
>  #include <linux/libfdt.h>
>  #include <linux/memremap.h>
>  #include <linux/memory.h>
> -#include <linux/bootmem_info.h>
>  
>  #include <asm/pgalloc.h>
>  #include <asm/page.h>
> @@ -388,13 +387,6 @@ void __ref vmemmap_free(unsigned long start, unsigned long end,
>  
>  #endif
>  
> -#ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
> -void register_page_bootmem_memmap(unsigned long section_nr,
> -				  struct page *start_page, unsigned long size)
> -{
> -}
> -#endif /* CONFIG_HAVE_BOOTMEM_INFO_NODE */
> -
>  #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>  
>  #ifdef CONFIG_PPC_BOOK3S_64
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e221fa1dc54d..97b079372325 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -537,7 +537,7 @@ endchoice
>  
>  config MEMORY_HOTREMOVE
>  	bool "Allow for memory hot remove"
> -	select HAVE_BOOTMEM_INFO_NODE if (X86_64 || PPC64)
> +	select HAVE_BOOTMEM_INFO_NODE if X86_64
>  	depends on MEMORY_HOTPLUG
>  	select MIGRATION
>  
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

