Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CD7CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13EF26B0092; Thu, 28 Aug 2025 03:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFE56B0093; Thu, 28 Aug 2025 03:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9656B0095; Thu, 28 Aug 2025 03:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DB9806B0092
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:44:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8883EC0A1A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:44:00 +0000 (UTC)
X-FDA: 83825377440.14.0F2080A
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 89845180006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:43:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ent97ktQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756367038; a=rsa-sha256;
	cv=none;
	b=gaCZbiJokZ7ZKNpaPSfrj0S5pfsBI2kh0vtKyn1lbkUqEplX+s2tJxHY/CNFxTEI9db2cy
	Flgn1vb/2bm9EvpEyBY1xhYtVfSKPW2JrQIKPPuGXKzJdcqBH60XnR3r/Gqgf5p0g5o8ux
	xClm9AM/ZEK5sU+aF5hQaMNV60+76ZI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ent97ktQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756367038;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCyWFKVmsqDpuka3mORfqvZ6ED5815cQsuT83UfJ0fY=;
	b=RgMXD3HUXEWtM8qwQd0nkNTkdm219ZpC6QAazcahg5LU1EkANOdnK6lZtMaR6jTGPmebMO
	jpKrveNeasRA71C9R7rJryp/oEb3ePrk1Z6lRxqF3F3EvXScWRo2KPHEcHlOwaWthBhnwv
	VX0Lk9CNKR/hV9+dGdYHfwkSFtcvvSU=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-61c26f3cf0dso1077710a12.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756367037; x=1756971837; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uCyWFKVmsqDpuka3mORfqvZ6ED5815cQsuT83UfJ0fY=;
        b=Ent97ktQO+LJ1RpWxQYPTM27WbQrzBJjftt2giISDHC/tByGKVzj7vNVaKep6d8Do/
         25P6Mq/PASIgc6xEH2pFsRooyI5+FS7aDeZItJt2uOTZydGFGwClozan5bnMAQQFstGp
         w/+tBLQl0l/mcCGuG7JY7VAkYLINSvdi1wLTMWr/zKvPbq8GbqG0tIRwbDtFd1sth6DC
         Xhz0ZJTQfakaKSBtFzs2F3JB6YExyd32FgGWv7SeNNIe2GDyx9vNBhIVkOwkHEmG2OCz
         ZYkpdRrBNwAWgMDQ5UYFJzfADbI3MFwgyk1Q2OCqa7zgi+UeEjIpf+XtuFCFMrQqE73L
         29+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756367037; x=1756971837;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uCyWFKVmsqDpuka3mORfqvZ6ED5815cQsuT83UfJ0fY=;
        b=P5EX+45DymxMXYXQR0iCInUi6N7m+owLQ5j1XMWxdo7OH0KJrbX7gAIH4LKiaVF94J
         uwxfMDin5sumQ6Rk+pqyhq0Tu1gUWzCVIKPhYx7Yz24ZCDqcmGk7pkwU7vDJhJfQtiVo
         mkCWSeLmAUW9PRegJhYe5c5hJKbzdeIftZfdePPqVkWUJF7ShJw8gdF2PZ4OUdg3tIj+
         cB7Uzu5GJOGQk4L0N4pqEdaAPTOAepHozPmoGQ3rs1FSVmvxr+hfXe3dAVChXrEEYvy4
         aEkrTqjNkiseH9ZHxvK6QnrVeb1ZmKUCTrAEZFJp/1EeNYGcgYSTYRiOh0mLZ0eHxFqb
         8wQQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiKlGmdteeQp/SS25u38zfhq6deSRwA7CQhruCvgQ/s/pfuxoiJdIAaoBclW3GpIvAVIHF6sscEw==@kvack.org
X-Gm-Message-State: AOJu0YzHgyS1gR2X3d+6eHxtVvZ2yrt+Nz6TH95vsflRb6rM7XeESXU4
	w+pYOJuKpFH6+E/B2/Pbwn4Q/L7XgONdh2YxDuqvCf8qfuwgCk/ny0/A
X-Gm-Gg: ASbGncsed5qzOheFelwqIgokgjKuJT/StiUTlbOoPgGlRBcfbggEmeYKe8U2q7Wbn9Q
	oWAWZbJTOlv2E8VDXLVX/bDWC4WoG/POB4yLVJaOL7jCr4lnSXl4F7ehlPIEZcAPs8580yBQwKH
	XazmZEDdoSvyLyHryRM6QYIwohh5+SrU4eLttaHaAlsWvGLsCBKIisPBWKADpCw31ZuGe+FZkwA
	pZMFxZ/mwCWpzz8zTCfMtLQ8AhGRl5OALfBB52TsFIJbwgzB/I0GHZiw/oqGge1e3k8OSPI5fDe
	MJRuR0fGkkuuhky/wdyE/9CmLswN6NK0WcA0uo2OBN6ndUwszMhFAyJE9fmIrHhiy47JmRAHotJ
	0gYCi65m2H5qwahwdUFRCHPMjFlRTif5bKCsoeY9n5jgl9Xo=
X-Google-Smtp-Source: AGHT+IFCWGCB9w3JZkSqlrk4a0OYpaWYnOsewLh1z3k9Jb7NB4buZSqln74MwC7LX4UWbpbQGZTMJw==
X-Received: by 2002:a17:906:3717:b0:afe:764d:6b31 with SMTP id a640c23a62f3a-afe764d736dmr1280383766b.4.1756367036783;
        Thu, 28 Aug 2025 00:43:56 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afe48fae316sm1165798866b.28.2025.08.28.00.43.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 28 Aug 2025 00:43:56 -0700 (PDT)
Date: Thu, 28 Aug 2025 07:43:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org
Subject: Re: [PATCH v1 12/36] mm: simplify folio_page() and folio_page_idx()
Message-ID: <20250828074356.3xiuqugokg36yuxw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-13-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827220141.262669-13-david@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 89845180006
X-Stat-Signature: 6ayqhmgymjrsrxxsuyn1a4mj46san1ki
X-HE-Tag: 1756367038-915360
X-HE-Meta: U2FsdGVkX18RqTaYrHlqMjpepftRqf9kp38kRGkdiGfFa3edmdj4kbQz7L94dQtZT3+oSr3JmIkTlP+wf6bllvgu/1k24giPQoskrqhkOaPYHqLLGIoTPt2l1Jvr7kQq5hU8aOUoSkt5dExfK4gMDbRz86jl88GqPuVMOXyO3dhIlO4yO00ewHrAMZIIekFBd/FA9m+U5Jv/i9BcLyB919o/NQORLMGN9195DWQi0sZITJwVZ5oCljiS87JSup5el+M3vPYCzFuSFfoM1FuP29KfHj4X3Cdrre50K+2McETSJH2kK+OWzY7PjeQZK7ndXsf+f0mqnIOPDkp/E+VDACqFwr6JzJUqmFEYCsad/UbYjAY9XaxE0S3gEoUnpJM6nIShPU5fxanUCLzow6KdQBYa07USzfRxrwxDkV/1PrnpqMXr7kE6+lXSvglg75yTY+bDP6O3uYt2I8QJeGCKy9TwcND774CVV3HfVm7lQaQI2kulF3Afn+t9oQJHAO7eyqMmrBIhwjqMshwXKk/XeKeB1q7Y/DWgeLl4bhBBcMjSFmvWVDSnJHikBnFAxbc3i8BcqxN1qOSgvm+8R9cqJCQ6Pws0cjSZPXijjLMCWI/0TZbdTE8MW3BkBaaS1Xf52TISAfQO4/4ttDU55eu1pdJkQSHJGWjHT5wyh/nh03V40sN/XOVdl3P59rDi3trhGzVKn6ESrXe3glUa0MxhWVftArOG4Q13T2sQZns/xB1Vxn0BR69twN1bWn5b8wJeZQZoqW+Es8vA9BRB7f2likAK/TBMYL7oIzCCJITVr28oePWAwsz2EkcXugsX2452nWoKtHzZHwqj1SI1toFslmNOs4jcs9ssaEvgLgLePewW+Mvs5koTiZDpSDaZXP9TbMw7utdaGY6WehQf6mEph+IEBDt0fNg3rwArgY7c05TeZNd8d6XmTbLxMuQhZnll3JbGuQP5ccnApsf1vmR
 p863rOxP
 fWOv6ZGqKOCcLTBbDeDb2I48emw22fcdLDFrx4XG4MwzIeV0xZjyWVkYKrA77GCJjh2r8H7Ywa8P+egQmVS2CVTC92fm3vK0tCaJL45RWcIwuOX4b7qe+z0LUQH040ULSoPyDlu9qrxKLnDkL1MiQ8Z1f3n2JCUpxLc3MLKlE5zLZMkvDpocjG/pAKdL3oM06L2i+toJ42fTw+sAv1QNs+20twrkeE2tHFdxcuA6J7CSElxzH/IB6wpa27oCPX/M9foWH96nA5xYw+mUNHwMWTpVd5d6Xyf6tVh/nYwd0co5soMtA58ZY5K+F2OCDO7KI/uPhs6pdrJHbl+A/fLzl9/FUCWz7Wj1Acefhw5g96/SIxnroTatnU/JkAEjHTmLY8JpthRICcfQmS++0MRS/bwykPST1jABww7nDzKXC5bu5c/Qke7jCxRfqkTys1bq/y6PKpqTtGKZ9RHZ7S3AI24z41Q26jhFeU2zLRAIFHrGm5RbJTRkLUyRgk2yJFAspkxFDZalYfv9m9Mxr1YOy+NhJriFfii8PoeDS8bcDsn7bIrHAOqdX6i5mSeptthOd4+DVfaXDcmZ8jfUz39nalBkWsDeWwgijI2qlEawzJGlbXKszyTirajjsi7WzGZfhPPRSaVjpEOMVEPC47z1ZDnNALEJO3Q0m98xOZcarhFvhleUihXfc6aWfABxF7ruOUy7CLUz5F56/rR7Rlc+HOh8KR8cPvzzgWQO1GhXz3VFtJGVt2nYGY0Mv9mz2sxnrAz3lGB4sMe8s7peO7Ccr9fEvXF91uiKW1UiR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 12:01:16AM +0200, David Hildenbrand wrote:
>Now that a single folio/compound page can no longer span memory sections
>in problematic kernel configurations, we can stop using nth_page().
>
>While at it, turn both macros into static inline functions and add
>kernel doc for folio_page_idx().
>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

The code looks good, while one nit below.

>---
> include/linux/mm.h         | 16 ++++++++++++++--
> include/linux/page-flags.h |  5 ++++-
> 2 files changed, 18 insertions(+), 3 deletions(-)
>
>diff --git a/include/linux/mm.h b/include/linux/mm.h
>index 2dee79fa2efcf..f6880e3225c5c 100644
>--- a/include/linux/mm.h
>+++ b/include/linux/mm.h
>@@ -210,10 +210,8 @@ extern unsigned long sysctl_admin_reserve_kbytes;
> 
> #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>-#define folio_page_idx(folio, p)	(page_to_pfn(p) - folio_pfn(folio))
> #else
> #define nth_page(page,n) ((page) + (n))
>-#define folio_page_idx(folio, p)	((p) - &(folio)->page)
> #endif
> 
> /* to align the pointer to the (next) page boundary */
>@@ -225,6 +223,20 @@ extern unsigned long sysctl_admin_reserve_kbytes;
> /* test whether an address (unsigned long or pointer) is aligned to PAGE_SIZE */
> #define PAGE_ALIGNED(addr)	IS_ALIGNED((unsigned long)(addr), PAGE_SIZE)
> 
>+/**
>+ * folio_page_idx - Return the number of a page in a folio.
>+ * @folio: The folio.
>+ * @page: The folio page.
>+ *
>+ * This function expects that the page is actually part of the folio.
>+ * The returned number is relative to the start of the folio.
>+ */
>+static inline unsigned long folio_page_idx(const struct folio *folio,
>+		const struct page *page)
>+{
>+	return page - &folio->page;
>+}
>+
> static inline struct folio *lru_to_folio(struct list_head *head)
> {
> 	return list_entry((head)->prev, struct folio, lru);
>diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>index 5ee6ffbdbf831..faf17ca211b4f 100644
>--- a/include/linux/page-flags.h
>+++ b/include/linux/page-flags.h
>@@ -316,7 +316,10 @@ static __always_inline unsigned long _compound_head(const struct page *page)
>  * check that the page number lies within @folio; the caller is presumed
>  * to have a reference to the page.
>  */
>-#define folio_page(folio, n)	nth_page(&(folio)->page, n)
>+static inline struct page *folio_page(struct folio *folio, unsigned long n)
>+{
>+	return &folio->page + n;
>+}
> 

Curious about why it is in page-flags.h. It seems not related to page-flags.

> static __always_inline int PageTail(const struct page *page)
> {
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

