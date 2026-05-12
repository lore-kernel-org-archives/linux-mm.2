Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE1ACD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD826B0093; Tue, 12 May 2026 04:43:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5646B0095; Tue, 12 May 2026 04:43:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EE456B0096; Tue, 12 May 2026 04:43:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6D66B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:43:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C83DF1C02CC
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:43:34 +0000 (UTC)
X-FDA: 84758129148.28.EFA7CF9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id A030F4000A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:43:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Jyj/SB+C";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uHPvgflS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0T9CA8lU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A3zfqhPU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778575413; a=rsa-sha256;
	cv=none;
	b=NXUB9jZexTkfgSGm9VZxjwdUTWaY4IiJw6qO7osxnT3JnNMLJoXx0flAO5MSoRV7dU+Wzt
	0asoa7xyxShVSqu7L8D1+tO80INd5U16Bksv8oTxhk+xQIAQgsr9/wZSiAUvd/7zfK42Fr
	jZ0y/gNisAG78gEzcY1HRf3tMWaHgk8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="Jyj/SB+C";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=uHPvgflS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0T9CA8lU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=A3zfqhPU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778575413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=29b8Duc4D+FvzOXVRuZz1VlOr/VXWhIuNt0lSvWwvds=;
	b=Zx8MzSRO96FzAFMZUVZfc+cm8Jb7mkhu+fp2PqQ5e048L9Muf4myXTKY8XlHzcTOe/t8fW
	S4TfmHc8P+tafb5JugV/TaBvUsGT6rRRxyHetciBDo6IflqA747nN9+fiGl7bFfesrfRhz
	wlpwN7iBRi1A7fr5n9OI88Uh7KMdX6A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 12BA46C03E;
	Tue, 12 May 2026 08:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29b8Duc4D+FvzOXVRuZz1VlOr/VXWhIuNt0lSvWwvds=;
	b=Jyj/SB+Cj0ycIn6iy8AirBgulA6woT7s7jmXHjjxlRIXRCVzsL6L8KCyFx0VmNqINjW+Bd
	fhe2neyAlpOi8KZqoA127vAVVcGFSUGufO3DYQu9FCiXiSgA0rWidbHoptSnYRs4onmu6C
	PN421IzXHTv3Mt9DUQwcjpW2lPi8GJw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29b8Duc4D+FvzOXVRuZz1VlOr/VXWhIuNt0lSvWwvds=;
	b=uHPvgflSxr1f21qR9SmbrNgQVen1f+3vhIPieRLWMld01iYwwQiqW1lWb5qjTqEV++QpjZ
	P9ahR7tCkwfmtKCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1778575407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29b8Duc4D+FvzOXVRuZz1VlOr/VXWhIuNt0lSvWwvds=;
	b=0T9CA8lUeaTSCvXnCWFLGeD+LEPDue/aNB43knGlbA4F86IRy7dtWguts2d6AfqI2klKZS
	WYm3JaJXzqdRIpHnu38kmGpnJK9452IJ65qb+UasIJRLB1ZPVD33kAJowFuAKhI9cH9tBW
	ufEMI5OiM1Uh6TdRERinXKYvWpRKahk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1778575407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=29b8Duc4D+FvzOXVRuZz1VlOr/VXWhIuNt0lSvWwvds=;
	b=A3zfqhPU29cjLTrw7wX35axoGznxQqTbC6ajU+CyBOykK0HUW7zpfn7gd/5crHxz+VlE+f
	//4KXicVjO4LUJBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D7BC8593A9;
	Tue, 12 May 2026 08:43:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aOwfMi3oAmqfCgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 12 May 2026 08:43:25 +0000
Date: Tue, 12 May 2026 10:43:20 +0200
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Mike Rapoport <rppt@kernel.org>,
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
Message-ID: <agLoKNAFMGPXFSqC@localhost.localdomain>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-8-3fb0be6fc688@kernel.org>
X-Stat-Signature: hufn31cmepwugkcb8zfh8knzybkwm69g
X-Rspam-User: 
X-Rspamd-Queue-Id: A030F4000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778575412-436688
X-HE-Meta: U2FsdGVkX1+v4ra81F0ffAC5BwcyuAgStJ/YXzBub06nbYFWUSS8gibq0lbXLuUlolmw82xXBPyLNHsj5kLZ4YjuhlAViv+MovSGP4ifUyjwJdo6xcyOBRnx+OR2qPA4dEAUgYNowSNZwI17xHJbSGyaz/pqvKmWUCikielMBsq7MEj1FA51EtGA7pO1tRF2Imp8/kgEkOmMe5gwrg6RYZqcQagZmAs8SO8F5BV0ZqnXD9NEerPAOm9JIoL+0AQPqNXG4CrJigvzNcK+U5wrGCcGY42C7O05ozdxtcxo9ELp2WhZo455AkqgJi+I3NbDzAd12xuXMbEQG05pIkYk1KVg0+mQ+LOO61cJNxSngc7ykwWlm4n32ly9yPGQyQUw4IIY2sKzkGLjckJnD3EBQB5ANxUVgMhcb5C7efexapfSJ3gX6s+NwMiRyWH1pCRJVx7HTosGBxS/WAVPJ4OSrlBiWWJ6+cbFxfYRgT2l/h7UWXcYe2hc0qESvMgxdx65ZVVqs06/vJaB8EwNxSBFtRM5FVnJiGorV3Fy7105Bh0iRDWL0hIj6wuwS3wcGwcPLCT8yoANqAwQURNeD9Olw9W+hHoerZ5jxWjjbKCUz54nyWTjx7S4MeyennwW9AhFbJTi52bIr/9OiQLFAUPCN1Y2m5Z2THssDDgoZMQU715eFF75vRIk/AoQiuoEgPab8Ham6EdQeYZvk00CXSzwXDaW4MTTfhzN0EzjtVcLivYAWa750TmEYQ8EC1cyr2vcGzvEJqClRd4CnXJttNM968wOxQ0ueGwOP6LqiahaEptx0zHv6SweTfKmQoOe17ABsZKHl3kY2R50+8NHXUESlX87tMTVqpzetVQaz/FIsCDw+Mm7NVy48bjw++5EN/E6W8+tsmOuv4GiV9Bh1n9sa39MmC1bv1X/F0GyaC9MQ5XdyzjN5hpV1uk4pUNGnCAcxx/WGLVpy2Jbuq1eFhq
 Wiz7YYbU
 peDB/l37hOrlv6bithADbZ42uLcKWHMQN3A/lyLEdoCHiixTvvFsTa64VPZGHXWfMBDbtoLJQvVmlhiHPw58/cFMyxUBJHEB5pkqIiNQKeFzeadx2e2dcu0hZk1Yftv7WN1jgfhjs3ZvLReZ2cc3VBC//EU1P5sLa823sxoz5tJgnavuFjC4PmTkN08tRD1p2lrB2YXp0JNp82uK5VQHdVIdQnqafurfsCcGOqJju+zNkMJarLyjbR3oJ/5bitjZlbD7G+9y7AZiiPcmkegx886Afm6X0DRmX/sH6EDCFH7My2HwcVDU0vl97+YOg+URQRbowpwhSYwWVdkSYTFjiEi6RiZlCGrnlM+WQOGQfNc7grEeDkuWzI+YOmQ==
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

Acked-by: Oscar Salvador <osalvador@suse.de>

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
> 

-- 
Oscar Salvador
SUSE Labs

