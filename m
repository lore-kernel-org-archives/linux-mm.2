Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E938CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52108E0012; Thu, 25 Sep 2025 10:51:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C023A8E0006; Thu, 25 Sep 2025 10:51:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1008E0012; Thu, 25 Sep 2025 10:51:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9BF9D8E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:51:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6BC04C034B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:51:03 +0000 (UTC)
X-FDA: 83928060006.24.BFE6601
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4CF4C000E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:51:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIupcSCT;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758811861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Nm7KkRF3KWMNrOa4fDQBFrmMYTVBsI2qgUFaE+AmVo=;
	b=ocg1ipzjmGcFsY0AAd20WZFxrGuIYOxGBJlrGX+H9F32OuTvthQluuy4BevpkTgLztBR/o
	hHYqmKf4gWnsAlyG8JamnQYgjwELTklQG/emSaXQbMe9TpjoiobGTpjoqHKefo+1bk5S7R
	UtUpTvHw/rsUjdQo5s9IezDhntDRiGc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VIupcSCT;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758811861; a=rsa-sha256;
	cv=none;
	b=dmI2SDqxm2jvue5dUkHxpOAnlJEGNVnmfn93ikPq2Zzy4NgnY5qC459vj7CWHw85GoPrHs
	bnOE6VitWV65AlZ2/pGqDaS5uWbAn8yh0GB+7vIe76/KeI0rHAB1cdv4be3r0mBh5TbCFJ
	SCW8+oPB9lfKunjbymzCOpgo9knMRm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33CED605E9;
	Thu, 25 Sep 2025 14:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53405C4CEF0;
	Thu, 25 Sep 2025 14:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758811860;
	bh=DG2szuPxxWOHgNT641pBDumcSqXth3pE37RvglgNcHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VIupcSCTrVT0YiVHqMeNRGIe/vr4LAnwufvWyVQeLdEWcQwSFVC2jTtzVOn3K9btF
	 omG8wlNRw5mDIWRVhKDd5bmAeX/nRPN++AytukjHVzHmIdqd3iMEzu4R1Y0ExOXnLF
	 VmFIdOmH7Kv35IVJgOShYC/JYj8b4MSf4HrmePnC8ywzvjZUj7oF5C5gBjVRDWCq73
	 N7uaKlPORfA0S9bpy4Tj+cBnOcNQut+e5rNeUMrzRCTdwzzCshobDgJDU1ila4SxrR
	 S+0w79fE1fKKhWzORLWq++nfH+8LE6kmOrCrP7CvqBMysOuua3P4TzzBNXj922B2d2
	 1yCq4SNlcdCMg==
Date: Thu, 25 Sep 2025 17:50:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org,
	david@redhat.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, elver@google.com, dvyukov@google.com,
	kasan-dev@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH v2] mm/memblock: Correct totalram_pages accounting with
 KMSAN
Message-ID: <aNVWzaxq82UI3wWO@kernel.org>
References: <20250924100301.1558645-1-glider@google.com>
 <20250925123759.59479-1-sj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250925123759.59479-1-sj@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D4CF4C000E
X-Stat-Signature: s6xbcyy6j8yechxrfcpi1k38koxpnxy1
X-HE-Tag: 1758811861-438273
X-HE-Meta: U2FsdGVkX18Lu5t9FUwQAG9I6A9xB5TPlMvadhQu7VwzCFvJfQ57Rp6x4JMdYue49HmqTvRb7P3OVKz2juq8UmeRYEMmBY+mJ13GgXeGNaXpF61S/Fa0c2DVhIrPLCqAozV89woFIqqI79HdO6h0W5D+LaNYZMe3x6A4kx3PNqoqL9N5bMpPHEXpwW9UFSi0lr1miWy+tcbm7E7zfrnV1qXN06/jth7m61iq77Qg/q+QSLFASLMBXsDZ1dxsgyukG3S1Bg3Aq4bLAvQPLf1epz2d7cCPW1vx5YRmJg0HsWfNrVUXj9stTJKz+oUUw5l2f8jB2gswPRu2MIpD9gmqHwdYUYbC0AEFeufkr3bAuqAeyMc6A0w05dkjpEgm64HzGdKgOKE2n9a+FwOBYhFOaZ6GraajuZtAQ/lH8hCJ2zGuJJHCQsdPud0QEprKBRi7lGV5hO2xTe7oBHqyJ83y8A11oFIXzrDz5hVyznMrqj4O/h4rwN5GSVAcQZ7VrCfZEPz+7PIziPGLi54VsVvLoD4jHPUCEPh3BCyy5jXWzgO1m2kUn7I7a5c5DcZtNu1W+JKR3da2/HW6E4ffjVsvC0kEKPeCbm0gN2SeTEmVASpEMY/H3jmME4SmBb9XwsL9hVJKFjAPRraeqGOjXmzqqfjPI2Y47EPADev0OocfJj6wKOT6MOOF+XekmyjjPdVDNQrR9xkguIHhIwHNx1DtN/ScfvlfQFC5LKt/sd4i2qogqRvP3hvrtJqpYZ9dClAas59YZKIofAzgy1Iui8lrneJ2RNchIEPhiS7pl0JPfX/RJo/i206BtVG28wUwuErXTwY0YoNfMt2/wzOf4nBByqJdgjUh3yXYSFVCHd8GsDR15FoJETk8widcJA3rPKNI48KuKBzGd09fK428NZj6Oq/QSMKJDNGty8AZ9RmvV9kBGm4vGyfqYl3KQ/SxXeNW5B8QwXBed860OoTxMI0
 Yl/K2I76
 G51BaK38/MtCvOYzYHev2rtJURbFvdvyzKfhuNPaJ9rNxnTI3O8CRYR7IzkN+bRzAuJkTCfXXSRvB7gW56v1VyzXutRXMrmbxd2udooy9QV0CXDc0vH/cHS40ZoCme/JXi3uJ4FJtNiE6c05r1Dvv2ehKZZGVTU/YLTs+s3Kp/bQ6ZhyOegjbGm1GDO3W8bNopKDfGSfm4FPPdkMgnASmBZvchP7K3t4bdVm4ZmbUjmOQPptc1KX3aPpDD9OnIJJFsrYY+ckB+RdKveBjBMQtNtuFdRxk4yvEOwRd3JayZGNXlhHJVJJe++o4QIhIcUnti56FmbyT8DtXmW5yCWxtPNKQd76T9/hpE9XH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 05:37:59AM -0700, SeongJae Park wrote:
> Hello,
> 
> On Wed, 24 Sep 2025 12:03:01 +0200 Alexander Potapenko <glider@google.com> wrote:
> 
> > When KMSAN is enabled, `kmsan_memblock_free_pages()` can hold back pages
> > for metadata instead of returning them to the early allocator. The callers,
> > however, would unconditionally increment `totalram_pages`, assuming the
> > pages were always freed. This resulted in an incorrect calculation of the
> > total available RAM, causing the kernel to believe it had more memory than
> > it actually did.
> > 
> > This patch refactors `memblock_free_pages()` to return the number of pages
> > it successfully frees. If KMSAN stashes the pages, the function now
> > returns 0; otherwise, it returns the number of pages in the block.
> > 
> > The callers in `memblock.c` have been updated to use this return value,
> > ensuring that `totalram_pages` is incremented only by the number of pages
> > actually returned to the allocator. This corrects the total RAM accounting
> > when KMSAN is active.
> > 
> > Cc: Aleksandr Nogikh <nogikh@google.com>
> > Fixes: 3c2065098260 ("init: kmsan: call KMSAN initialization routines")
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> [...]
> > --- a/mm/mm_init.c
> > +++ b/mm/mm_init.c
> > @@ -2548,24 +2548,25 @@ void *__init alloc_large_system_hash(const char *tablename,
> >  	return table;
> >  }
> >  
> > -void __init memblock_free_pages(struct page *page, unsigned long pfn,
> > -							unsigned int order)
> > +unsigned long __init memblock_free_pages(struct page *page, unsigned long pfn,
> > +					 unsigned int order)
> >  {
> >  	if (IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT)) {
> >  		int nid = early_pfn_to_nid(pfn);
> >  
> >  		if (!early_page_initialised(pfn, nid))
> > -			return;
> > +			return 0;
> >  	}
> 
> I found this patch on mm-new tree is making my test machine (QEMU) reports much
> less MemTotal even though KMSAN is disabled.  And modifying the above part to
> be considered as free success (returning '1UL << order') fixed my issue.
> Because the commit message says the purpose of this change is only for
> KMSAN-stashed memory, maybe the above behavior change is not really intended?
> 
> I'm not familiar with this code so I'm unsure if the workaround is the right
> fix.  But since I have no time to look this in deep for now, reporting first

With DEFERRED_STRUCT_PAGE_INIT we count totalram_pages in
memblock_free_all() but actually free them in deferred_init_memmap() and
deferred_grow_zone().

So returning '1UL << order' is a correct workaround, but the proper fix
should update totalram_pages in the deferred path IMHO.

-- 
Sincerely yours,
Mike.

