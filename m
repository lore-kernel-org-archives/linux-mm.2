Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FAB3C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ADE86B007B; Fri, 24 Jul 2026 08:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510F06B0088; Fri, 24 Jul 2026 08:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9326B008A; Fri, 24 Jul 2026 08:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AEEC6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:44:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 80CF8803A2
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:44:31 +0000 (UTC)
X-FDA: 85023638742.07.0A17971
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 79AF820006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:44:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gJBYNxC2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784897069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVEMUgfEWnX7KrIQBwc2fvPxeAGABcJWMxwU3Czcuzc=;
	b=Ua2chQusEurjlE1qoznvvo2LRWGD2PVS9TgIc7BsCfbpmHlHkrmD1E8TgPvW4Tvcsfh8fa
	/7ceDCAM0aOUNVr60I5gz6llRkW3mAyLdjAXML6YQHNJmZ7I+90KRaXMKbGcz4jOQAR6+5
	H6HX0Tba9YtRuJtTd3TER+r89WkfTa4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=gJBYNxC2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784897069;
	b=iOIjgA+r7u0ygnrEzZ5D6xmhM+WPd3dzCdhhXgA+LMcqaTEUUGEHRemLGcqlkPxnJaRQGf
	XPm8Ht70Ba9IQ41O95g4FYA/yVx0NRIm2wcSZoE0Qo77xNJ3QDlWv/kFBDdvmdNL9VDljI
	1QrQJ8wv01SUue6/mJ4bzjGTr+dxaTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=lVEMUgfEWnX7KrIQBwc2fvPxeAGABcJWMxwU3Czcuzc=; b=gJBYNxC2k60KiJX6NJdA6zCvdh
	YaJNuoVQX6bSez7pvpgatwKNZs7h2/inypvRWSLFVWXwRv48qS+qxyZmJkV2xokyvrP7hXdnVI0HL
	LDhjviRXJ1Xlt3N9wNfdHdKiIACBNeQmC28r9RVILwR5kTyeWp4n0+vHdjyiu2kpzEfoV9eIzG5XA
	WNaKlL1XdRuFhY2AToIjmLBXIg4aZzr7lRef7SE54cE8ZY5t8nj15KcbgD0UBnKGT5c1u348fin6L
	rQoaMtuzc31gulokYa7zFpKC/3YwQ3+JaQhyjG/yY8/hSCfjA0E50Wihq5AZW425J4NEJIkuwTyEi
	EmoLjwDQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnFGL-00000003TqB-1EmP;
	Fri, 24 Jul 2026 12:44:25 +0000
Date: Fri, 24 Jul 2026 13:44:25 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Michael Roth <michael.roth@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
Message-ID: <amNeKcDZ66VrQ5PL@casper.infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
 <20260723143034.175661-6-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723143034.175661-6-willy@infradead.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 79AF820006
X-Rspam-User: 
X-Stat-Signature: x9j44brne41gqnpxexh5ynfqrcrskyks
X-HE-Tag: 1784897069-876428
X-HE-Meta: U2FsdGVkX19tMWSffYTPPFlvQ/tLO0sJKUJOl34wHmBpn2ZYmnRsyIlw3CAFXpxhSzN0NvnJl9IPYIrFEYLW+oalwnTN6Ui9AONn17niLaCEUV5rmI9p1uGj4plfMeCPQ1rn4B1vvT0vmA6KrJINV5IyzfNsysWVU+RNz8dSjPPTxvki3qBzimtqUPWSjbyTTckp7QSdcmI7xcpI4UcoDi1MItRBOiHeJuUB1pLZ1Nkkt0XdXScIGgcTCWS9bc/9T79CU+wU6BTROBIir0/iH6HK8V6NxJIlnj8zk0TlfizLhTwgNVVnCix+I1jpd+Lbw7u47jpv86x7+py98FlVfcuj84A5TUHEgGPg+wdAdgHJNUMacZaySX8KDzmlM5aaJ8Y2caor73hNzQhd17is6Xuks1RsgtOjRIfqnyJ6oMvBkzn5uEOgfHSNOL7Y7PafhXT71DbwlWoS7PlTWWTe7oYB1IGK0uRF2usMLb61bxGpG8WDMt2VSrm68RYKyPbZG4JVh72hyBOvcJhn7kFtzZg2jauchF8+JLQPnzqZe2a744v2Bfh/rMyTn8P4zFrZJZqNv3Wm+OwURmJyYKXBmA0VQkI2lFEyio8JaYiWBZGW+0oVqAOKMUN5TBdltuhtLeTHVu6/52JU1VyAP/F9cCiLO5+dgr9RxPvryu01pH7QJncOJUJYhH/xQP/PjhqNKM7rJ7jtjUw89th1P1wOtQHSeDP+vF+mni0qv9WOnKU0LK/6gyGHf8FNmSMsTI/r9MHdJJSWcQLI1xRlU+3wXbwPwgD+ryFxgoA/UOh+mSXawHeF4r99PzNAkx7mK7DYdwpyfIAnAQc1n6XiF8sSD8RYHY1+zHxZwyjxmJRRrkN41nL2Kd4Zujj5zP4DJBUXHNUHP5I7ceyp14tV1HESdFrJuKEeP/t2ekDcSEavU7T2YWLnHvc/yN1SRTMii+DBJOC85hjJQnnCDPHVzg8
 z/vSuha5
 pIvAsA0ZJurLy7wgxbwNT3e/EX6wZk3BrOcfj3/XlkDnTEW7iQcpjahJYnm7i1Bh6ZhVQ8psLHvmj6ClMrJFQzcBgZCCkRI4rlDduEM379cjied8P1SWjqeYuupmJJvVsarFy6ur0tvHJi0PtWIpUS6d2CILRib+N7SKklx+xolau7p0Yd7UQ34/WCffbqTKbj65DTmxWxryT1SfxgM0n7RXYFnO/yzPdlvc/IaMZoBOQKkmw7m8BUxYxDf3Perz4EmbcFjOtHRNl/ljLl9OrESgqLfZEstXUUic/dSsZF25kROMLBgFSgnQk9QnuMBD0gSHse7abjTsgF2Al/fJXOuM8UuWuB/ii3hluT07VYNP8BL8MTWaVDN46pgms9ySbar07vtnKJGeTJN1n67+aeCFuiu6yAV9cO3GmNak3X2ljQw3kArNqSai9mZNrxvTwqmrBEHkR4BheWGc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko review:
> --- Patch [5]: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page() ---
> commit b4db4098463261fdf87a2e92b28ce2b4c9445e74
> Author: Matthew Wilcox (Oracle) <willy@infradead.org>
> guest_memfd: Use folio_has_hwpoisoned_page()
> 
> This commit changes guest_memfd to use folio_has_hwpoisoned_page() instead of
> folio_test_hwpoison() to correctly detect poisoned pages on all large folios,
> not just hugetlb folios.
> 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index db57c5766ab60..94eedcc7f1a9e 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -774,7 +774,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
> >  	if (IS_ERR(folio))
> >  		return folio;
> >
> > -	if (folio_test_hwpoison(folio)) {
> > +	if (folio_has_hwpoisoned_page(folio)) {
> >  		folio_unlock(folio);
> >  		folio_put(folio);
> >  		return ERR_PTR(-EHWPOISON);
> 
> This is a pre-existing issue, but while looking at hwpoison
> checks in guest_memfd.c, I noticed a missing check in
> kvm_gmem_fault_user_mapping() that might trigger a host kernel MCE panic.
> 
> If a guest_memfd folio is allocated (e.g. via fallocate) but not zeroed, it
> remains in the page cache without the uptodate flag. If a memory failure
> occurs on this page, it is marked hwpoisoned.
> 
> Later, a fault could trigger kvm_gmem_fault_user_mapping() which executes:
> 
>     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
>     ...
>     if (!folio_test_uptodate(folio)) {
>         clear_highpage(folio_page(folio, 0));
>         folio_mark_uptodate(folio);
>     }
> 
> Because there is no folio_has_hwpoisoned_page() check before clearing the
> page, could the kernel-mode write in clear_highpage() to the uninitialized,
> poisoned page trigger an unrecoverable MCE panic?
> 
> Should kvm_gmem_fault_user_mapping() include the same HWPoison check as
> __kvm_gmem_get_pfn() and return VM_FAULT_HWPOISON if the page is poisoned?

I have no idea, but the purpose of this patch is to stop kvm from using
the wrong API.  This is definitely scope creep beyond my level of interest
and the aims of this patch series.  I've added the KVM people to the cc
here, but I'm not going to do anything more with this review.

