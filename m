Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A983FCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 16:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2DCE8E0003; Wed,  1 Oct 2025 12:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE778E0002; Wed,  1 Oct 2025 12:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4228E0003; Wed,  1 Oct 2025 12:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BFED38E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 12:51:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BC8E1A013E
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:51:26 +0000 (UTC)
X-FDA: 83950136172.06.A03E2EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6F26140002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:51:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrLf9AbQ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759337484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlYd+TB5CJeW3VdXGJQ/USyQzlcXjdeIKECVMppL2WE=;
	b=rAFnGGgZCAKJslW+IsZLAKibaXghIBduaI1fnsRec1bOs0lyODLXjidozxawDHf7HkNy0z
	pXzy2mZwLITqInsXEO0BJIL68aNnnd9PKzTWsDnpEtrU375NVuYEHdhKldzDicOurzLNgl
	IMDpifHiR4V6wkf7QodSrqyE9M7gTKk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrLf9AbQ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759337484; a=rsa-sha256;
	cv=none;
	b=a1emZfyk46hctonma4V3ZZKTCQ6zvaZZe350GhhS4nu1nNuog3VjLqgXrv0oOZhZGWVGLl
	g2Z/4HVwofbf17rRQ7Ks7U3QXvKkUwzLRTq+rIJuWTIPPzkLZ0k+cuTXwB9sYWGDXYqlxP
	uRT3yBPWBvScM+bN1lOSaLDAo9rJ+Lc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C85161ED6;
	Wed,  1 Oct 2025 16:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757A3C4CEF1;
	Wed,  1 Oct 2025 16:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759337483;
	bh=sq47SPnNubBaOrDYNmqLZOFhbgnhc5uNep+QUZv1fr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrLf9AbQ0lrvaZltk4zWolRVs+DxIrNghRLqz+NqgIY+KLEdCzqdVHtQSe+jmUWxe
	 DF3qJ27ROq6HsizQbqkhxWz5IshERT8hP0rw7siC50Sk5cfmuezbfpqPBoyLcX17sD
	 J3rtaKGevmQDXOFNmKx7U5s4S30BSI4Mx9MZACFtQTRYds+Z8HVTbWTDX74slWOhFD
	 RoEtEG5B+Hn0EvNxtz903vreJVeXqw//T6ndav7vRRwy0pRCn+1q4JzKusExjbHDmW
	 JG1esOFkVb0Cql53UuxMgTPc6BMoxBk5SKrAXBl/Dm2bX1VGDUOekA7E3w4SlxJ0Dk
	 +H1ICsR4Ik2jQ==
From: SeongJae Park <sj@kernel.org>
To: Jakub Acs <acsjakub@amazon.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	david@redhat.com,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	peterx@redhat.com,
	axelrasmussen@google.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm: redefine VM_* flag constants with BIT()
Date: Wed,  1 Oct 2025 09:51:21 -0700
Message-Id: <20251001165121.54258-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251001090353.57523-3-acsjakub@amazon.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 94hopo43kyxzec9fdquw5du3nwr4ucrw
X-Rspam-User: 
X-Rspamd-Queue-Id: A6F26140002
X-Rspamd-Server: rspam04
X-HE-Tag: 1759337484-270342
X-HE-Meta: U2FsdGVkX1/o8mATysCMNxhhvxVHGsDVaE386WJYqRQ+UHp/dyLREqKCfdOsTNeJrIBUpFqlU2yXtoaNV8z8VNfGDAnrCn886iUkGLBuly7rVQy8yV/Mq1SZVNNS53mPEEIG2Wo2sJaKGAcKeqm8LM8V/eZbhvkVF+WlI+glBJl/LGE2Ly8DlnDmGpmusg3C82g8pbKj1tUafjRT0dNBkF35g7pliJuk+rkEYJKqJz4CWQLbr2GC5mPD1QjY+VpG6UUxrjN7VbshmbF1iHpO8EEXymZgWR7EVUznBR6h2YE8+lZ3c79IWl8mJcpfqVdauZx8jGGT3CCndfQBkRb+YE1i9U/zYg+nBxD7ipFZJLBz4O8FDbPncK5pPIIqOO0C8c9Fhukd4HuPR15RIszlA3z/boN+LZsUlGo4h6UUT9SXcb8tp/tDYzLU4jQcu/1ME4S9pWUTP9m8rNjHE+VYyZeugn/44x6nOggIr0tG04S9kvzNZzWBbGMEdqz1AW37iTCnCjiG1kLaNiaNbJGRVapRgdHqecSSzBGRv8t0XcoENSv4R5+otRZPrz5rrXQntMNNu/MHMcdvB9kERQDHttL2IvW2CD/T4M+l0lldevIgupQ98RRmLfHy4f+1RSVUhKwiczW1az13pR0UddhG14hReuuRI3gTdG0WROxmOAsBSFur5diynxzOmBUDRI5sSesZti2T5GFy5XI//IOCT+hrN4HbQOhWuNtcUcmKD5sJ1rF3jffQ7cNsLd9D8IoIofFfuoN1e6CWXOKRuirTMQlawSFNvOaJ053G/B3oBlMRHDnBbVY9ngTQA/QS37l6TjjBa1ZsDd2Fd2OfTdyNwOd+9QNZQ+GicSnIPDLI9lNzdYpHTKMm0Lr2/W5hfcLJioODJESQc31Fa1ZhJhisi+Ixowt465puixZ9nLnnLzA5f6EfkXL++LAmeVYmyd3OxM/HYUR8mp4O72arLmi
 ZpNd54np
 SncQ/HrstjlfUUCn+dF1w5K4BWdBhs62o88YpCWJDZyXW8hzxuUtXU4Wq8myR2BZNcEWeoHpvWX9EmYosa8ritHJrdo8MsXAZkI0IH4BEcuOXv44ZUVtuF+3ULefR9XAlOpDKAI3yxJriJvdYyYpNUUnvT1y6ajPUJ4dm7+H5kAtqQKJSlu29fk+ukW04qrsj6TYYjGsERO71/XjdObXktJlILoC2HEeMkH6X2Xr5pM0oIl3ByEd1HzW4f+U0Y6PyHkswRnzrertFixwdsXZDt1GbgSwq4O4DC28Ag0/4D7ZH5CyFUMyzdRcXsKyqC7n7pRf+RhdtByQHRnY/MixwmdWlKaGlREXiAbJ1LO4fQ33bl5V/qC5aUPV7uC7hgZAwqpcf06zZEBXrnaAD66fQ6Le4U+nIPpKnreHSaHWWv4L/4NLf3LgA1njs4peLHUeX5YR3At8SCjOw4pC/gM/AKLAUCGMrPYY4TzRLlYG7Q2fnKYKFctm42Guy7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Oct 2025 09:03:53 +0000 Jakub Acs <acsjakub@amazon.de> wrote:

> Make VM_* flag constant definitions consistent - unify all to use BIT()
> macro.
> 
> This is a separete follow-up fix after we changed VM_MERGEABLE
> separately to isolate bugfix for easier backporting. As suggested by
> David in [1]. 
> 
> [1]: https://lore.kernel.org/all/85f852f9-8577-4230-adc7-c52e7f479454@redhat.com/
> 
> Signed-off-by: Jakub Acs <acsjakub@amazon.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Xu Xin <xu.xin16@zte.com.cn>
> Cc: Chengming Zhou <chengming.zhou@linux.dev>
> Cc: Peter Xu <peterx@redhat.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  include/linux/mm.h | 66 +++++++++++++++++++++++-----------------------
>  1 file changed, 33 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index c6794d0e24eb..88cab3d7eea2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -246,56 +246,56 @@ extern unsigned int kobjsize(const void *objp);
>   * vm_flags in vm_area_struct, see mm_types.h.
>   * When changing, update also include/trace/events/mmflags.h
>   */
> -#define VM_NONE		0x00000000
> +#define VM_NONE		0

I'm wondering if it could be more consistent to use 0UL instead.

>  
> -#define VM_READ		0x00000001	/* currently active flags */
> -#define VM_WRITE	0x00000002
> -#define VM_EXEC		0x00000004
> -#define VM_SHARED	0x00000008
> +#define VM_READ		BIT(0)		/* currently active flags */
> +#define VM_WRITE	BIT(1)
> +#define VM_EXEC		BIT(2)
> +#define VM_SHARED	BIT(3)
>  
>  /* mprotect() hardcodes VM_MAYREAD >> 4 == VM_READ, and so for r/w/x bits. */
> -#define VM_MAYREAD	0x00000010	/* limits for mprotect() etc */
> -#define VM_MAYWRITE	0x00000020
> -#define VM_MAYEXEC	0x00000040
> -#define VM_MAYSHARE	0x00000080
> +#define VM_MAYREAD	BIT(4)		/* limits for mprotect() etc */
> +#define VM_MAYWRITE	BIT(5)
> +#define VM_MAYEXEC	BIT(6)
> +#define VM_MAYSHARE	BIT(7)
>  
> -#define VM_GROWSDOWN	0x00000100	/* general info on the segment */
> +#define VM_GROWSDOWN	BIT(8)		/* general info on the segment */
>  #ifdef CONFIG_MMU
> -#define VM_UFFD_MISSING	0x00000200	/* missing pages tracking */
> +#define VM_UFFD_MISSING	BIT(9)		/* missing pages tracking */
>  #else /* CONFIG_MMU */
> -#define VM_MAYOVERLAY	0x00000200	/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */
> +#define VM_MAYOVERLAY	BIT(10)		/* nommu: R/O MAP_PRIVATE mapping that might overlay a file mapping */

s/10/9/ ?

>  #define VM_UFFD_MISSING	0
>  #endif /* CONFIG_MMU */
> -#define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> -#define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
> +#define VM_PFNMAP	BIT(11)		/* Page-ranges managed without "struct page", just pure PFN */

s/11/10/ ?

> +#define VM_UFFD_WP	BIT(12)		/* wrprotect pages tracking */
>  
> -#define VM_LOCKED	0x00002000
> -#define VM_IO           0x00004000	/* Memory mapped I/O or similar */
> +#define VM_LOCKED	BIT(13)
> +#define VM_IO           BIT(14)		/* Memory mapped I/O or similar */
>  
>  					/* Used by sys_madvise() */
> -#define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
> -#define VM_RAND_READ	0x00010000	/* App will not benefit from clustered reads */
> -
> -#define VM_DONTCOPY	0x00020000      /* Do not copy this vma on fork */
> -#define VM_DONTEXPAND	0x00040000	/* Cannot expand with mremap() */
> -#define VM_LOCKONFAULT	0x00080000	/* Lock the pages covered when they are faulted in */
> -#define VM_ACCOUNT	0x00100000	/* Is a VM accounted object */
> -#define VM_NORESERVE	0x00200000	/* should the VM suppress accounting */
> -#define VM_HUGETLB	0x00400000	/* Huge TLB Page VM */
> -#define VM_SYNC		0x00800000	/* Synchronous page faults */
> -#define VM_ARCH_1	0x01000000	/* Architecture-specific flag */
> -#define VM_WIPEONFORK	0x02000000	/* Wipe VMA contents in child. */
> -#define VM_DONTDUMP	0x04000000	/* Do not include in the core dump */
> +#define VM_SEQ_READ	BIT(15)		/* App will access data sequentially */
> +#define VM_RAND_READ	BIT(16)		/* App will not benefit from clustered reads */
> +
> +#define VM_DONTCOPY	BIT(17)		/* Do not copy this vma on fork */
> +#define VM_DONTEXPAND	BIT(18)		/* Cannot expand with mremap() */
> +#define VM_LOCKONFAULT	BIT(19)		/* Lock the pages covered when they are faulted in */
> +#define VM_ACCOUNT	BIT(20)		/* Is a VM accounted object */
> +#define VM_NORESERVE	BIT(21)		/* should the VM suppress accounting */
> +#define VM_HUGETLB	BIT(22)		/* Huge TLB Page VM */
> +#define VM_SYNC		BIT(23)		/* Synchronous page faults */
> +#define VM_ARCH_1	BIT(24)		/* Architecture-specific flag */
> +#define VM_WIPEONFORK	BIT(25)		/* Wipe VMA contents in child. */
> +#define VM_DONTDUMP	BIT(26)		/* Do not include in the core dump */
>  
>  #ifdef CONFIG_MEM_SOFT_DIRTY
> -# define VM_SOFTDIRTY	0x08000000	/* Not soft dirty clean area */
> +# define VM_SOFTDIRTY	BIT(27)		/* Not soft dirty clean area */
>  #else
>  # define VM_SOFTDIRTY	0
>  #endif
>  
> -#define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
> -#define VM_HUGEPAGE	0x20000000	/* MADV_HUGEPAGE marked this vma */
> -#define VM_NOHUGEPAGE	0x40000000	/* MADV_NOHUGEPAGE marked this vma */
> +#define VM_MIXEDMAP	BIT(28)		/* Can contain "struct page" and pure PFN pages */
> +#define VM_HUGEPAGE	BIT(29)		/* MADV_HUGEPAGE marked this vma */
> +#define VM_NOHUGEPAGE	BIT(30)		/* MADV_NOHUGEPAGE marked this vma */
>  #define VM_MERGEABLE	BIT(31)		/* KSM may merge identical pages */
>  
>  #ifdef CONFIG_ARCH_USES_HIGH_VMA_FLAGS
> -- 
> 2.47.3


Thanks,
SJ

[...]

