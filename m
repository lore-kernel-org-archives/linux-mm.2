Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F258CD6E5C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBF168E000B; Thu, 13 Nov 2025 08:54:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F7A8E0002; Thu, 13 Nov 2025 08:54:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C851E8E000B; Thu, 13 Nov 2025 08:54:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B8AE38E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:54:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60EF412E74B
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:54:03 +0000 (UTC)
X-FDA: 84105727566.03.B50BF21
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id DEB611C0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:54:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qt+JW73z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763042041; a=rsa-sha256;
	cv=none;
	b=fN9fq4GJ6y/4a31SM7EDxGjmQpn4ozxKIKzcTIr484Qu7cpuopyqYKtb/wQOSYrf8mM3EC
	OrqnitGifHAb3B6L80w9IA0v4Fq6NRpSA93WPwv5M9qOH91oOH7DTDhvgvduSrcomcZSYT
	NQH9wZzPWVnum8O707VM6DG6TsbI+R4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qt+JW73z;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763042041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8z4JYdWRN4ri/0vMnrQ+NGdcvUWa/3+Fk5kATs52EYk=;
	b=xz9KG1NQpmR+cBsJdiKk7sZ9L5zs55i3E8um0Csk0kDMwQvIm5wG8f7A/mB5eTSxsEN/eV
	DDxmFhQkItejOocdDlmZUaHBXDelQ/84DMCNMCH6nGXuw+Propo3tp2haUjghBoURDOIWj
	9bmb4lvfSMc6sJu76N3Y3hKn1HXeX5I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8z4JYdWRN4ri/0vMnrQ+NGdcvUWa/3+Fk5kATs52EYk=; b=qt+JW73zfmr5T1N5Gxy46IqgUN
	vcuiisSzUZiGWuTjQESTqs5UYc1OaW/4uJRWXzye+eUNv2mdC9SPEt3JOlCBdwiedVVsV+gHv5Vh6
	IwOJLv48vtnGBwHYqpeWswQNnpnytkmHFLy9DvyYpJm5h+SYp3m8nhXscfLNLi34qXymONdbHurGu
	jTksSys9QzAIQXnMHglhNA0Sj9VKBoyY4zjqgvAUqdwtwCGAgne8u92dSZu3xABG5AqREOcgR5mjo
	h21s/KcxLuOqt3y5eCvWdW4dInDUuxgcU8SvUc/XPYczCexX2IWIof4mPlWzFhKW53tpNvzgEGn92
	aoa0DSCA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJXlu-00000007bMk-1ICk;
	Thu, 13 Nov 2025 13:53:58 +0000
Date: Thu, 13 Nov 2025 13:53:58 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Vishal Moola <vishal.moola@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joerg Roedel <jroedel@suse.de>
Subject: Re: [RFC PATCH 5/7] x86: Call preallocate_vmalloc_pages() later
Message-ID: <aRXi9gIwA_eyUFJI@casper.infradead.org>
References: <20251020001652.2116669-1-willy@infradead.org>
 <20251020001652.2116669-6-willy@infradead.org>
 <29319ba1-9093-4ec4-b84a-3c60d2b00264@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29319ba1-9093-4ec4-b84a-3c60d2b00264@arm.com>
X-Rspamd-Queue-Id: DEB611C0003
X-Rspamd-Server: rspam07
X-Stat-Signature: 9ary8fxkeb7wawb4u9yu7j8rzwhkz4ty
X-Rspam-User: 
X-HE-Tag: 1763042040-670304
X-HE-Meta: U2FsdGVkX18SOpgcOL978iTxqVAKhItC4DePWIX6aORt52y0ACnNlOhruxx0MJ+tSgt5jmV8BkW3VxYv1uIaygMOuXOmB0EsES93UV4IDswhpJIMz0zGGrnpte+Y7uojQb+HcLtYVkKQU7rWTOj0uzpaUbTWvwRr+x2oTjamaG9AqLkuW/3cd71Q8dhZcpqxdbyC0SU1xGrWDPupwSuLJB2XWeJ5CJuEYkuks/ltPFTbgYfDDL1dgnIQ0mwMDUvlUaI57W8ADw6CgMKQdYP208a3kqBNJPBVq9HjWRzg0fPHiI96kPoxVkL2TZvQkkhgnNEMZrXuEgzvVEYxXYGAaMJkdfyQLryQMoLhxBAk2Rd1L5wH4MYY8dK32FCdgcKMP9Hlt00CIVRnoE8DdIaX7r2ff5LdjRvWe492A3Rw+au18ni/rl6Igcpre3kTENLh22VaWX7JqkaYsuU8MTTiYjon0saxIm7ymvK4JN0+5HLYq8nfNa9/eGwnnt3io3MX7ufOo2MVgBMAefqLXo9IGb7kdjPxEiT8n/pV0oLnEwrmXS899J7rlfnH0niQF4gF/KoMZy2TrvjmXB9huCEpJLESbLBCWaKrWneFpC/f7Tdeh3175RgiFLzAuvLxGJLSxJmTTENSwSuU4abUKyCfNdzDfooDujpZEaz84NiQ2HI/ThW7XejqVGuCJwYnNr/SVHF+L7nin23Yq/mWCCPnWo/iXOiN+wYJpLCZ7c9IJRmBXOmQX3IEVFmf6ko0NX9uE/KuQhscksbMl3QJwaKH+hn2y+tD7JjD+COI6pO9P3QtWs6oLTxF5ZW92xZ7RIO4wcEZJJfpTy9wFIVrkUaenF3aMOFEHR6C2gSOuXK4zWaMaaSWNLJ4f4HWhJaKLUTEfK0DN0c1GsMPRVDgg5DERBdsXpah+MOfZRayQHxaRiABNL/9JeX5tCNp7/rkJD8TwXAYIvPoviBURWz3Y6S
 ztV6D9fZ
 yAbd9MuP5jW+P9BLDUQ3y7SxHDaqQZ9sTa20uHkvaq9jit++ggc2gWoC7CkwKzUVzHDLCL9jZG4izAhyPgYMuTBVpkEZbV59oLt3eyqIZ+c12+BJ0efq7fnmGBscRNTYEHq4GevRc5ZzwIKh0w0t2dUbdLjHoYSTYYJ8h27+NgJkNXqhqm9K1zXEFAfKVnAK7GqAxbJEJuBafovqb+qZI5Njw6lTeG8z6tJIXTVa8a8rWN3pzGfG2H6JXlQuwP3XY5Hz+dXCIlyhRlLMBSNfgVuW818YBAcgy5Nfy3tT4lhrisR8kO7qKvHnxcdrsQ4zE0gNAwrp53qT3cTgUhTlpCet49SJRx9jjrQxA2TLrYV3YzvoZsn2lZ5Bz9E7nDeX1w8hDwmPbG+Ngkt40Hf7R8g/prrhQzI4i7agSwSW5kzLSlHpg0JSJ3qtDt7IMArfD+nk3PLWXQWo7SMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 02:29:44PM +0530, Anshuman Khandual wrote:
> pt_page has not been added as an element into ptdesc and hence
> the build fails upto this patch.

Right, sorry, looks like the commit went astray.  Those lines should
have been in a lter patch, and this patch should have been as below.

Adding Joerg to the cc to see if this invocation of
preallocate_vmalloc_pages() is early enough.  Also I'd like feedback on
whether we want to expose preallocate_vmalloc_pages() like this or if we
want something more bland as a name like arch_vmalloc_init().

commit b34c228df965
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Sun Oct 19 18:34:36 2025 -0400

    x86: Call preallocate_vmalloc_pages() later
    
    When separately allocating ptdesc from struct page, calling
    preallocate_vmalloc_pages() from mem_init() is too early as the slab
    allocator hasn't been set up yet.  Move preallocate_vmalloc_pages() to
    vmalloc_init() which is called after the slab allocator has been set up.
    
    Honestly, this patch is a bit bobbins and I'm sure it'll be reworked
    before it goes upstream.
    
    Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3d9a5e4ccaa4..0006b2880bc0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1322,7 +1322,7 @@ static void __init register_page_bootmem_info(void)
  * Only the level which needs to be synchronized between all page-tables is
  * allocated because the synchronization can be expensive.
  */
-static void __init preallocate_vmalloc_pages(void)
+void __init preallocate_vmalloc_pages(void)
 {
 	unsigned long addr;
 	const char *lvl;
@@ -1390,8 +1390,6 @@ void __init mem_init(void)
 	/* Register memory areas for /proc/kcore */
 	if (get_gate_vma(&init_mm))
 		kclist_add(&kcore_vsyscall, (void *)VSYSCALL_ADDR, PAGE_SIZE, KCORE_USER);
-
-	preallocate_vmalloc_pages();
 }
 
 int kernel_set_to_readonly;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3111344b8d05..00ea79340c0c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1177,6 +1177,12 @@ static inline int is_vmalloc_or_module_addr(const void *x)
 }
 #endif
 
+#ifdef CONFIG_X86
+void __init preallocate_vmalloc_pages(void);
+#else
+static inline void preallocate_vmalloc_pages(void) { }
+#endif
+
 /*
  * How many times the entire folio is mapped as a single unit (eg by a
  * PMD or PUD entry).  This is probably not what you want, except for
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0832f944544c..8af051136211 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5385,6 +5385,8 @@ void __init vmalloc_init(void)
 	struct vm_struct *tmp;
 	int i;
 
+	preallocate_vmalloc_pages();
+
 	/*
 	 * Create the cache for vmap_area objects.
 	 */

