Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38531606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 11:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I93vDhKh
Received: by kanga.kvack.org (Postfix)
	id 576F16B05B1; Tue, 17 Nov 2026 06:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501406B05B6; Tue, 17 Nov 2026 06:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9066B05BB; Tue, 17 Nov 2026 06:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B37E6B05B1
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 06:03:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3FD41C3B30
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:02:56 +0000 (UTC)
X-FDA: 85444323552.28.3FC8AFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9B4C6180008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:02:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I93vDhKh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794913374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crEmioOjMzsnzH6L7JboWvkyCFcBX6fDyVf9lGMy6eg=;
	b=RUBXa2sgQ6Qqp9mBx/0OZsD87UW1MTyruxe5/EzF++wmHwD1EBAfefGESDKqjDBSgHMZzm
	fjaUBnqYfGwDtsLeTL8zv3YVyDv60WE63GMcqVp0ptR7UlQidqTXCHmnwpegiLx6+5+FPN
	FUNaooY+LnANkb51XK7CMkGECywLZfw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I93vDhKh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794913374;
	b=6Zelo3cczFZh+nwr0875V9hGQ1aNjwhYx89BCAWKXewfZ1Qopos+/JOzh+e40L00PW5Woi
	3P98LwkXe8PJciG3XdruRrh+C3/HSNi/XbXXue+UCBODXCRMgStIXMuge3nG0i7Hk45HFq
	NBRhKY4c2cDclynVVztIA8LvhRP1qWE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D87E461FC;
	Tue, 17 Nov 2026 11:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AD21F000CA;
	Tue, 17 Nov 2026 11:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794913373;
	bh=crEmioOjMzsnzH6L7JboWvkyCFcBX6fDyVf9lGMy6eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I93vDhKh8vykqmJHCXte86t8kuKnqpYzuSqFE6XpvQ+vS6hcRGkcXXI10Q6p07SUp
	 CnvBUFYiW/24BuiE/x4lgAF4AzRBoZ+0UU+mCoWHoEb6ecDtFmRO7FdAkFLIvpZCgE
	 YP2uBXLYGpXFAz/m7hXfnC7ApgVyztHkH2ihgLUUJCkiN+AHpBECIVRuQJwU9KESW2
	 tGa1F9U5zvnEP1MqrTiD6w0eW3f3WiKj69AvQqYVolhcfjI+v/KO11tl9zkD72ylaF
	 oZvZHosQwvoGTLAT5XtKzz7+7sjviSEwBYiI/iXXCWsVcSrlG6vk1fUNxrORlP0w1h
	 F2EWz5HJyVMoA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0A46D198004A;
	Tue, 17 Nov 2026 06:02:43 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 17 Nov 2026 06:02:49 -0500
X-ME-Sender: <xms:UzT8ajzhIRDuZQmR1yXTDLuGA3b1U0tuSaourJSyrLDTrQ_Um2nlVA>
    <xme:UzT8ah-gVHw4IntEVOfc5Z14VjjzN7T7Q8B2FvFR5VBoen7b-HPD3m7hBY_KVQkTE
    lA5xwY_Wo0lHo-IJ34H8B5KdKsLoJFuxG9Et2vFBrnNw5WdWVHCbak>
X-ME-Received: <xmr:UzT8ahxcJlhvBNfVqovWJPHAn97L8-HJYkti8PJU_65bhna8ykiR1lDXN20>
X-ME-Proxy-Cause: dmFkZTEdL3a0Ww8UBR3R2vq6MmLMcrG/RZX5swqKljzNR9iQbYhJjAbY7PI1ciZ9LK7lxN
    G/X6ntG0iaY30AQsAjEuf57i6CZYjfm+meUK3SNiYXmeCWWUJ6eJZs3up8jphiYl4q8gjl
    jx/Ahq1GKe6I/bXKrTuw70GcxIwNT2jp4gfkCI76UMri6prm91X5ZHCpQ0CSw70eKatw9o
    W897R67TYQMC9tdclNiHUmVbeQonLxDDsNNr0tVhsGpDu129aHDLPo6xC+ZTyK9ZM6Qnnt
    MYuzQ4L/hdyqL+ol7coGPamA67VuEepBf0wI/8gPf+rreyi3dAUVv7YzP/OCpkMvoNRZhV
    YgsKbRCIilSfSP7pZVhBNK5pp+l4zUFWKPr0XsF4c/Rmq0cqJXBoQeoSNFwc2DiFDWZFSg
    NfO+shv886RE5kd2tAFT+FTIarUIaRL9KRbOP0qtmfBkRi5y8jE6SPjvymtIKQCEHqK1h3
    RYgAGGj/RxAuRRjdSRPlvRnDYhwbkOoHHLBugCLRdy6igxtIkdJ8SsiOfdaC9wZow2EeCV
    Ejy4XNZF76vFloczn0M2QIsslwD2xaCsTZRX1OSP+ZOi7OtUBkmhno/iE/fXq03rTXkSbw
    do3CK6UiTx4ST1p3Q59hLB+vj8psXH2OMMFeeHtUpnx+YFCTloQa9ChJJNoA
X-ME-Proxy: <xmx:UzT8aruuJmQ7dDiwarHdYjVtP70RG52TxChOPLKFH7afF7h6-akdFg>
    <xmx:UzT8aryVAcVUMmv2aTlcVJcYor6UcfL9P1w1L0anMWhtGRDIctF4jg>
    <xmx:UzT8altjzJNLBNiYpIhGi_vWWH7VmxarJzm-N-JcvvJ1fgUMEfeHjQ>
    <xmx:UzT8aljV0jDctEZAsJHbv0Ypfdw61mWX4M9wO2EfhtqHNe0Af12BHw>
    <xmx:UzT8atCXyMGt2Yq-MlBZYadsi_cXIiTQmqxJmcETVf2oWtX0YRICrq70>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 17 Nov 2026 06:02:42 -0500 (EST)
Date: Tue, 17 Nov 2026 11:02:41 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com, 
	byungchul@sk.com, david@kernel.org, gourry@gourry.net, jannh@google.com, 
	joshua.hahnjy@gmail.com, liam@infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, matthew.brost@intel.com, 
	mhocko@suse.com, pfalcato@suse.de, rppt@kernel.org, surenb@google.com, 
	vbabka@kernel.org, ying.huang@linux.alibaba.com, ziy@nvidia.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kernel-team@meta.com, 
	baolin.wang@linux.alibaba.com, Nico Pache <nico.pache@linux.dev>, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: don't PTE-batch a swap-in of a folio with a
 hardware-poisoned page
Message-ID: <avwwMyk462raQFy2@shutemov.name>
References: <20261116063624.1382944-1-usama.arif@linux.dev>
 <20261116063624.1382944-3-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116063624.1382944-3-usama.arif@linux.dev>
X-Stat-Signature: 1ij8owq1eorwd5aifjupc7p64d1x6mtp
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9B4C6180008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794913374-118038
X-HE-Meta: U2FsdGVkX1+aGVm8QinQkO9/ky8Jn6hyXxuGIO2z9RjP1YGnb2807aa02f4V1GCaF/X49CrLMZAgwZ9aevMkEi/tv5iF7d//13H+eQkdoWAHbGIdf2YisH9mA0rV04mNvuAFvjtfUeDZ6kIGaIwRZZ+INjzLNZKCLIk3G28bUEQrN2mD/idEPBL9gMtVfScdIJ8uJmk+v6GcYtdFz2ptjsHa5SRHNRoywLOQbePCyFis6FCF23JnCLr8auNw7qjlqIM3cZP2YNS4CPhgErgufdoAXlcZiCfoZ5P4/wo0qN3dW4BZAr0aUgz8Li5y97InUGs9eF16pipxxYY3oOGLQ7StZKwp3G9q04Fz/7/yxmEjsKYyPxRX7uLcb2dg/Ltn65oPcLVjn4yhcD5IPloAZYA7qJjfoQi6ZnA4ViwtQRj+lUIVkUqFSg4zErP6wWN0UC4s7nfG191GLyn6h2QYK4EblCyfvE1491+6hZVRmHIU0D+AQQiYhCHai+66A71E35o+/tD2wL7l9rfSZkTS6qvKMhRNObbMRn1GG44qjl6nzOgjQuYUndc/7hx7TRpBCM9vAnYdETVHPk8YN85SzsCq1n2jwmH4TzO/t9FBjoSAHkJ984hm9swiWpNFSsECoChpOVymlVNgP51DareLr16mg5oWE+ryw4gkOAitTbLJY2xpUctd/GLyl3oj68+7cgv1w7L0ejIQnp6D7V8mIhIFkmmE94C0AnAdXvSGphRkn/mxIDCDwDxVF0DittClz1XIggiSH1o6YF4laGcQ0a/fLYsYbvAaHAyDYwjYzcpup5DLTU3oengrJ45Rp1k7NPn1AioH8tQPnenxpy170OwfNwzzr31jkwuPKWS82iN3KwIl0ysNUuKXdKUELQC+55LkVuYcgeQrmZRH6uocvQvjLvUhFgLzjTVlPfMLhtanY8luIyNQHmBApmUdSViekm2yNAmO9be8nU5u1bW
 GsGvzEi4
 j/kHG15/EXG8P581zfShkS0JAHQle6gM3Q32M3mv+iinNUbF+KcTPW5Z79Fn0ROPpPzEeidE7cQkpBPHCcQ1Ao4uE2jco86PRkUkn0X9i7/R0KeBxAstncx42oB7n28Fot6QTKgqzIzuwBrlBNqXvdo/7h9gqqoi5zApQdjttg6/y+ihoZJOqlTbBQDpEG4ZvXhOEtKJK/x5p7ztwjCs6+Kc3iY1967W3dfaaesEuY2crFkEZU62Q5dTsdixzpudlZp0RXmKhjuRXKehom4mu6I/PNcH4A90w7sawtZGF70uMb0jr0LcMgaEPuDfop2c0iagXZkAjkJZAraqYu4gThbp7qu7jxN+s2C5SyijSP4ZIk+w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 10:34:56PM -0800, Usama Arif wrote:
> do_swap_page() checks PageHWPoison() on the faulting page, but the
> large-folio batching path then maps the rest of the folio without
> looking at its other pages. A poisoned page that is not the one being
> faulted gets mapped anyway, and the fault that would have reported it
> never happens.
> 
> Skip batching for such an anon folio and let each page take its own
> fault, where the existing check catches it. do_set_pmd() already backs
> off the same way.
> 
> Leave a freshly read folio alone: it is not anon yet and can only be
> mapped as a whole, and falling back would free it with the poisoned
> page still in it, which the retried fault can then get back from the
> page allocator.
> 
> Fixes: 508758960b8d ("mm: swap: entirely map large folios found in swapcache")
> Cc: stable@vger.kernel.org
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

With the check moved up as David and Zi suggested:

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Do we have the same problem on the file side?

If memory_failure() cannot split a large file folio, it stays in the
page cache with the poisoned page in it.

Consider a write fault through MAP_SHARED on a good page of that folio:

  do_shared_fault()
    __do_fault()
      PageHWPoison(vmf->page)
        // checks the faulting page only
    finish_fault()
      do_set_pmd()
        folio_test_has_hwpoisoned(folio)
          // backs off with VM_FAULT_FALLBACK
      set_pte_range(vmf, folio, &folio->page, folio_nr_pages(folio), addr)
        // maps the poisoned page as well

Possible fix is below. I can post a proper patch if the analysis looks
correct.

diff --git a/mm/memory.c b/mm/memory.c
index fb76d8922e37..25b53847943f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5893,6 +5893,10 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return ret;
 	}
 
+	/* A poisoned page must take its own fault */
+	if (folio_contain_hwpoisoned_page(folio))
+		needs_fallback = true;
+
 	if (!needs_fallback && vma->vm_file) {
 		struct address_space *mapping = vma->vm_file->f_mapping;
 		pgoff_t file_end;
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

