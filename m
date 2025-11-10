Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2EEBCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0749A8E0025; Mon, 10 Nov 2025 10:28:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C168E000B; Mon, 10 Nov 2025 10:28:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB7A8E0025; Mon, 10 Nov 2025 10:28:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCC068E000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:28:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C07B85A90
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:28:23 +0000 (UTC)
X-FDA: 84095078886.09.5710DAC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D0CF140013
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:28:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762788501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zNKuDCBjNIz74iFWXc8ju2XO+IyvwhvbKIRqT39/VCg=;
	b=EwQjbGWQfQaMixN6Py/8k5SnwJb51TTaPiDnNH+/0T43yUMyAqoMMlXePWLkvhRHQuos9R
	SrDxGEg14t4hlD8Zck/8eeeXgdMnttO2+cvcusb6CAmW91SZwllvMl+Un8irZPrhZdoiIN
	Z2OTs7HxEYBNLt8njaj7CRXrX1mR/mw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762788501; a=rsa-sha256;
	cv=none;
	b=OP7Qry6iS71L7HyqzCw4V7WnBf1tkM+4k/F3uhtyxB2JwpoZK7BpZT9yNq3ANFGYx8zqtY
	YcCwIJNk/pJNaQsZou+29m5TuA7t8iK2YxIRii8IWNaPRmn0v9k9JFVYiOrj2dd/yJz+0I
	yImmbVU6hiNCkn96ZbNJSgIB2XzNzY8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 054BE601A6;
	Mon, 10 Nov 2025 15:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73275C19422;
	Mon, 10 Nov 2025 15:28:19 +0000 (UTC)
Date: Mon, 10 Nov 2025 15:28:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>
Cc: Jan Polensky <japo@linux.ibm.com>, akpm@linux-foundation.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	will@kernel.org
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
Message-ID: <aRIEkLw7BofLjOWs@arm.com>
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
 <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
 <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D0CF140013
X-Stat-Signature: aq3i5jpojmo99c64kw9kkdjwmmgrx68o
X-Rspam-User: 
X-HE-Tag: 1762788501-680465
X-HE-Meta: U2FsdGVkX18kZb3Yjn0nGgFJN3BGIAC7JpfTDVKEjfbeP9Keeo0q7zhaiodMTJqd3QXbBufNsx8hcowNXVmXKnJPniwSRFBWwO9C7ncNQ9JY+eOh/ALXsn1cisZygVMWUZ7IwljLZ4fDmU5+wL+4hrDcV/j/tskkILQo6TqeB57XZKZXo45+q7TY2cYv2gt0fHdIqHPZIuFcp7donil6z9LNzAGRryEAKA9m3yJu+ObYtSzbPbXi4b3QstMyJRUQ0Q80A9EQHAtscnX21+BkuMI5Dk27o6b+8nJ73N3UVQ3KTvlnnfHev7AWMg8SCKy6l9KZnxC29VO/0H/8w4l4dHgjVBsyfo/BGenqsxcJdyG+9j+q34kbHrt2gbdBtnqwG4R4dqP50vVDgtY72cq+Svq5PrZMiib2KZ+3bWzqW6x50mgGGB6QLKHv8gNIR/c+xUA/preq043arehthppCLE469uf5bCS7jksBQaDFPu0nfPFOTG5NY6c6LHZECqdJLSRyHVZiU0d9NJEHpNtuxEZYNamsGrdguS/jkP1Y/AuICSJG0aDYJQqbp7NQ2UDKecsm9ULU5WkufFA0+o4qD3n/FbqCohC1LkCw2xWV2vub7izV4mOiWSEBLcETZa0kxiI8yklXLO5zfDA1NxsaDOV4G5dLGh1PNPZXxv9J/2JmvQ8DyyThmyf6aKSjoSTmf5naAg4VHGmzwUXD5qqqkR7SrdxHqW7gTfH0eAi2nPElPHGfupTDKvtrW/lYJMVUyT5gOTKZT4Z6t3XjlgkCKgMEBhRaWx+8XEeVx9ouEJtE/MAI+NBFcteBUt6wAEYnzXHL4p7sSIRbepUbYc+7Hskww9yoxyCBdP8TvlkBaS42kwnrYIwypeLP5ETyiHiRlHJnjQolPrjMLmdrST5fZ35ySR4gA6gpAKOjbT/KbZtDUf3wTf4QEJBS6ijlRJ327kchQtZqotD5pkBlx2R
 MGyrjSRU
 7/TxJgLHdu5XwWn88g948MmoUAHAjIUaaqJICTUPRCLI0wAzc1z58Y2nvkO+iblUKcalomW9OtNhFUhkSqZMd93hPti+aZUfTVH0xaAfwpihkBcFbLYEk40g1u2gVuJNSTM9MSxzIvgbH/HpAT554HS+VNvWJOKRHDledPPjIxrCW3MVsJnKEyoarOjL21qFloUbVAyV/PHc6VTnlnFX0HEH90kaMzPhtFEV1g8gFcA9La63kJ/lebFeAOHIsXms+mopGQf5v2aIMpSkvEiEa4dKW70QeKIhL2dyfIGLhwRaQRVIM1OxnGIF/xxWFu9x10W0kavk8g6up1UQ+rESy23YqOoviKnerF2ICUtC7zYeg1/csdbsvwrYH52Jw5vbx31003LifjXOHd7uFrqQIznlm5r9ZocwPb2CANyq6nfFJsCFYtawCzVHvKnXtppFymja5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 10:53:33AM +0100, David Hildenbrand (Red Hat) wrote:
> On 10.11.25 10:48, Jan Polensky wrote:
> > On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
> > > On 09.11.25 01:36, Jan Polensky wrote:
> > > > The previous change added __GFP_ZEROTAGS when allocating the huge zero
> > > > folio to ensure tag initialization for arm64 with MTE enabled. However,
> > > > on s390 this flag is unnecessary and triggers a regression
> > > > (observed as a crash during repeated 'dnf makecache').
[...]
> > > I think the problem is that post_alloc_hook() does
> > > 
> > > if (zero_tags) {
> > > 	/* Initialize both memory and memory tags. */
> > > 	for (i = 0; i != 1 << order; ++i)
> > > 		tag_clear_highpage(page + i);
> > > 
> > > 	/* Take note that memory was initialized by the loop above. */
> > > 	init = false;
> > > }
> > > 
> > > And tag_clear_highpage() is a NOP on other architectures.

Hmm, another thing I missed. Sorry about this.

> > Which works by the way for our arch (s390).
> > 
> >   include/linux/gfp_types.h | 4 ++++
> >   1 file changed, 4 insertions(+)
> > 
> > diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> > index 65db9349f905..c12d8a601bb3 100644
> > --- a/include/linux/gfp_types.h
> > +++ b/include/linux/gfp_types.h
> > @@ -85,7 +85,11 @@ enum {
> >   #define ___GFP_HARDWALL        BIT(___GFP_HARDWALL_BIT)
> >   #define ___GFP_THISNODE        BIT(___GFP_THISNODE_BIT)
> >   #define ___GFP_ACCOUNT     BIT(___GFP_ACCOUNT_BIT)
> > +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
> >   #define ___GFP_ZEROTAGS        BIT(___GFP_ZEROTAGS_BIT)
> > +#else
> > +#define ___GFP_ZEROTAGS        0
> > +#endif
> >   #ifdef CONFIG_KASAN_HW_TAGS
> >   #define ___GFP_SKIP_ZERO   BIT(___GFP_SKIP_ZERO_BIT)
> >   #define ___GFP_SKIP_KASAN  BIT(___GFP_SKIP_KASAN_BIT)
> > 
> > This solution would be sufficient from my side, and I would appreciate a
> > quick application if there are no objections.
> 
> As raised, to be sure that __HAVE_ARCH_TAG_CLEAR_HIGHPAGE is always seen
> early in that file, it should likely become a CONFIG_ thing.

I'm fine with either option above but I'll throw one more in the mix:

--------------------8<--------------------------------
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 2312e6ee595f..dcff91533590 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -33,6 +33,7 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 						unsigned long vaddr);
 #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
 
+bool arch_has_tag_clear_highpage(void);
 void tag_clear_highpage(struct page *to);
 #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
 
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 125dfa6c613b..318d091db843 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -967,18 +967,13 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
 	return vma_alloc_folio(flags, 0, vma, vaddr);
 }
 
+bool arch_has_tag_clear_highpage(void)
+{
+	return system_supports_mte();
+}
+
 void tag_clear_highpage(struct page *page)
 {
-	/*
-	 * Check if MTE is supported and fall back to clear_highpage().
-	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
-	 * post_alloc_hook() will invoke tag_clear_highpage().
-	 */
-	if (!system_supports_mte()) {
-		clear_highpage(page);
-		return;
-	}
-
 	/* Newly allocated page, shouldn't have been tagged yet */
 	WARN_ON_ONCE(!try_page_mte_tagging(page));
 	mte_zero_clear_page_tags(page_address(page));
diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 105cc4c00cc3..7aa56179ccef 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -251,6 +251,11 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
 
 #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
 
+static inline bool arch_has_tag_clear_highpage(void)
+{
+	return false;
+}
+
 static inline void tag_clear_highpage(struct page *page)
 {
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e4efda1158b2..5ab15431bc06 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1798,7 +1798,8 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 {
 	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
 			!should_skip_init(gfp_flags);
-	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
+	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS) &&
+		arch_has_tag_clear_highpage();
 	int i;
 
 	set_page_private(page, 0);
--------------------8<--------------------------------

Reasoning: with MTE on arm64, you can't have kasan-tagged pages in the
kernel which are also exposed to user because the tags are shared (same
physical location). The 'zero_tags' initialisation in post_alloc_hook()
makes sense for this behaviour. With virtual tagging (briefly announced
in [1], full specs not public yet), both the user and the kernel can
have their own tags - more like KASAN_SW_TAGS but without the compiler
instrumentation. The kernel won't be able to zero the tags for the user
since they are in virtual space. It can, however, continue to use Kasan
tags even if the pages are mapped in user space. In this case, I'd
rather use the kernel_init_pages() call further down in
post_alloc_hook() than replicating it in tag_clear_highpage(). When we
get to upstreaming virtual tagging (informally vMTE, sometime next
year), I'd like to have a kernel image that supports both, so the
decision on whether to call tag_clear_highpage() will need to be
dynamic.

[1] https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/future-architecture-technologies-poe2-and-vmte

-- 
Catalin

