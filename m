Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68D24C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 10:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D32E6B009E; Tue,  7 Jul 2026 06:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 582F86B009F; Tue,  7 Jul 2026 06:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4757F6B00A1; Tue,  7 Jul 2026 06:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15D816B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 06:18:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 90F7D1C3883
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:18:26 +0000 (UTC)
X-FDA: 84961581012.01.398937B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2464BC0006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 10:18:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LX93izZ5;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783419504;
	b=tgOdFVWNCVbT4Kz8XlqPfvyb9luWfNBTvdODIP+P2ouLWjnhRNgPnWubWzIhWX9YrMJfx5
	Cp3eNY9JEGAURKu3abM4KstEbNDqUMAY7GHji2CyX94I8QRlmpJgMg7AmbXXGa/+QZ34CJ
	P2oycr+rGPsUvyhc1GtbEQHN/+cYqxk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LX93izZ5;
	spf=pass (imf28.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783419504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3slwj2XyzWQtqngmhVqaSA6RBHzpXga6waGc30WeTwg=;
	b=I32o2MyAowyaNe8RRSWRGtTdT62jRLOcnsp1Wx+RTRvr6lE269kfPQB5/Ix+9BKL8fFGP4
	8FNC8C18xssSLKq8ga8wF6VRbcuVLcOu6T/BIupza+YY7Yz7nN7u5WeDkAUnrVn11MiGeq
	VpqKgpojBIiSiD4weUUB0YcKtkV9dEw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783419503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3slwj2XyzWQtqngmhVqaSA6RBHzpXga6waGc30WeTwg=;
	b=LX93izZ59NyyNc0z2XAce97IZU+hBG+sTULIlfY9Njefax1cBNzcm3dnLLMJul00XTLCyF
	1CLmJtvOKQhTDlJaRMDHFh9sDgjd1yldmfgkQKHVwqGdr9/bR5F+PrgvkI9oI/jLilfMAM
	BEbsVyXZ4u4VEJdn7Pa9odLlfkwdpR0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-Gg0R-VOgPQK25K6vIHF8wQ-1; Tue, 07 Jul 2026 06:18:22 -0400
X-MC-Unique: Gg0R-VOgPQK25K6vIHF8wQ-1
X-Mimecast-MFC-AGG-ID: Gg0R-VOgPQK25K6vIHF8wQ_1783419501
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-4767036f8faso2340669f8f.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 03:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783419501; x=1784024301;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3slwj2XyzWQtqngmhVqaSA6RBHzpXga6waGc30WeTwg=;
        b=paQuZcg0APSGfSeo12/eIxV9hYeVtzvWGfq/ROOnJILIcVMRvNyMjq+ppS7gDIgHYC
         kLU70kZf8z26nfY+8EF3z39nDI+RVLuv55LsjRf6M8JQRNWsoSr802yfAmW0PWzRrXeR
         Ljrpx/yK4BEHPAGjVhFSDlyAh2P2EI6HJNIUN6x46TFXuLf7R+ZvxoykmobWQJU+O+mg
         qFPELRIQdDjeGkr3PSUUECVNuMpA34V+pc6h07v+pk41Pc6uRsL7YHu0wfdEwAhOP4ZU
         K17hgI0K1/iKrbSOfneieXiOox+85J00tM10oBu08Zwvb/OxN0xopWoZoQwm06AVXSEk
         vd7A==
X-Forwarded-Encrypted: i=1; AHgh+RoAacL0GFc/YaYkoaIyPqHWlprDCjwpqSwOlnauZ0KI4pRw2Lbx/cA9JfGcBF39xU5HgpKDdww78g==@kvack.org
X-Gm-Message-State: AOJu0YxD6Pg1FbJU4V0rsUzf7WD4ZPGmCaul8dJp7jm9IeTb5LjNgE0E
	fdiCMQMoaMuP61nd5CcF5XsYEMjKcY3Xyt6HQmI+tlzOl7MwSAl0K3/LATnq/KIS9hNUpJ1HR69
	xIcjkJv5CcQHg3psLkfDJT3pTIPFyvDR8OOAKEvhlCdO4cFYjhVMB
X-Gm-Gg: AfdE7clZKRUFgdBn/aOC00C/8uPLMmquRQBUhBPVSdhPvhd9+xnZIbA2vgk5DrkgmPM
	UnPMhUlfSAPdJ6gPNsLbV1dgNGiACTpLeCDdddA6IR9L4O9TW1l7b+/SwI0Kg6X4KwRHTJEz9Nm
	iS9NQMLzH8O/8bXjOJvY8vhPhPmX4A1wk2vTGst1f4f0QsbY7L9INT8vmQ5smLx2bcrN9r1wrbN
	aPvn2/b/uiV65CuVB6ehu9IzyxB83hf5a8wtYTri+Bkv8dAAq++YcESczLt8wFEali4Vk1NFGfb
	FQiqUyIYmDVKHZGVu6i2EYNzdy04EbVQfI8DREZiSevOZzcWCXTW8nUQFe0F04d0kB1x97pm4Uq
	fNllBOW462hOb/sUbA4HWhQ/BQPz3bQlR
X-Received: by 2002:a05:600c:c173:b0:493:c98f:12e3 with SMTP id 5b1f17b1804b1-493e3066380mr12490685e9.20.1783419501003;
        Tue, 07 Jul 2026 03:18:21 -0700 (PDT)
X-Received: by 2002:a05:600c:c173:b0:493:c98f:12e3 with SMTP id 5b1f17b1804b1-493e3066380mr12490105e9.20.1783419500441;
        Tue, 07 Jul 2026 03:18:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-68-31.inter.net.il. [80.230.68.31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0078d49sm49438995e9.0.2026.07.07.03.18.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 03:18:19 -0700 (PDT)
Date: Tue, 7 Jul 2026 06:18:16 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sourav Panda <souravpanda@google.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, mhklinux@outlook.com, fvdl@google.com,
	gthelen@google.com, mike.kravetz@oracle.com,
	pasha.tatashin@soleen.com, rientjes@google.com, riel@surriel.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 6/6] mm/hugetlb: support free page reporting for cached
 hugepages
Message-ID: <20260707032839-mutt-send-email-mst@kernel.org>
References: <20260707064235.1386552-1-souravpanda@google.com>
 <20260707064235.1386552-7-souravpanda@google.com>
MIME-Version: 1.0
In-Reply-To: <20260707064235.1386552-7-souravpanda@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: HoOP2jXuLK31SN7zHeNV7T7sYGy2UcHN8axK1SFCpPQ_1783419501
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2464BC0006
X-Stat-Signature: r53oc4dairepfqgw5j7i8s1dudh4w8ta
X-HE-Tag: 1783419504-173530
X-HE-Meta: U2FsdGVkX19OaDhkQm12/3wq5vAd39nztVNTBVQAnMwHHRnbpvmZ8izQfwnl+xM1n0WdlgzBEMc19KJpUrt2ASEWOSCV1hpDdgcVVc56zAB8r7hTGcgFyCmVOKSVEIsR4myPgeu4cIAg3tiOZqc/I/Yo6WcXdWATgklRYM79Cd9wUKTXGAxy6D/QWarzUZ0TgmLNDjvOjx0zHZhvctwvcQ0t+52g3s+HRVjDoT533uwpe/30H1umMN+zbmsRAFr9E3Js/NcHUm7axAdwo0o2C0/5M+rYoqI3+8gGaDpikyvZsDN9ZyZZ0xh8YtGDDFArqbmsXRrmU492+K9BVxyHWz3Tf3RR6/SMahbfoiLMeg86p15NHhDLCjHKNhZmstJn2kpG7apDQM24JjyRrUlE2pT5X9xsEpgayVq8xS4bxBoMrKoES7954+7dmarZRdvGGObC0AHG7+yCoymOJSBaj8rC47m3F7aUsdVR6gzpZrLH3gXOtNWkd6UYPTdatNJeVj/fo6cX6776HRki7lAJAwj96ippTAEgWfB80sQy7GulfaR9OdF4HESvtMVpkfaWvNUWk7NJxrBRiEzw7Li4PuK13coOAMrlIPbvlmCa5iV2j48LBYfvyZpEIfm2rEIApMn3OArGLAmu3q9oe/jStlta5On6ZDabTfRL3stJoXc7Y2JrZ/7mbZ9sPkW5TNq30hO6C9neTQEBMyRLFCAggtY1WzttSr/XJ20XHhJmrFPXdOoNZ36t+3zb0zmljAA68oby2eSMRC+zt3oaxZlvF2wVzz+geWZPJt28UkWF8JCMqnxaofvvWtZhw1E0x/HNYM6ciOLQA9pUu0ODpLqTB6UXgaCWmwKio6c+/v4bAbvx3T8jc2QEwO3Usv1zK5b3KGFF9ONCbr2zonTy/KGESMYU9O1flVooNWdA66D2CdFS4tVVERHx0XS0qX8b3UvPKWqyGpa/0VJg452bG7B
 Kq4xVBZX
 9Bk9AY/EjgAMjlL/evDAuLL9Z/tbXWs3Xy3zzfcmWff0bMSwYJ7D6fbzvy1gPcVC0f2wq+6XnKVmGajmkk41PWkFmEPf/ABOd8kZuCaNcpig7x1g2FsvOzT/L6Tta3NppmqtofiEBX/W1Oamzj5FL1xQqbs8yrV/b55WLxa8PTK1fboZMKdZ7IwcPeqNpnriY6w5Q/glVMuQdh8Kn4YS2lK7ClScATKfD7zsefbi2UuHJkiBMWhH3dtQFpzhE8NqgSFtO2BV7pKE8RaAHtuJ7jA08UcOkKaddc0Q3gi8gYs/4prQJKwDCICU7ujH+kKMyvTIk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 06:42:35AM +0000, Sourav Panda wrote:
> Implement free page reporting for the HugeTLB dynamic cache.
> 
> Register HugeTLB hstates with the page reporting framework if they
> support caching.
> 
> When pages are added to the cache (either via recycling in
> free_huge_folio or direct population via sysfs nr_cached_hugepages),
> trigger a page reporting cycle.
> 
> Page reporting isolates pages from the cache list, reports them to the
> hypervisor via virtio-balloon, and then drains them back to the cache
> list, marking them as reported (HPG_reported).
> 
> If a page is allocated from the cache, or reclaimed, clear the reported
> flag.
> 
> Signed-off-by: Sourav Panda <souravpanda@google.com>

So if you are going to look into this, I feel the 1st step
should be reporting pages from hugepage_freelists - this
can be done independently.

-- 
MST


