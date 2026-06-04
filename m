Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9172CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 23:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FC36B0005; Thu,  4 Jun 2026 19:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD516B0088; Thu,  4 Jun 2026 19:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABEC6B008A; Thu,  4 Jun 2026 19:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7B36B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 19:05:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A6B391C12CA
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:05:55 +0000 (UTC)
X-FDA: 84843764670.28.9776B76
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44749A0006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 23:05:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IyxmXxsa;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780614353;
	b=fQGDtfKh6UK2L6HXrwE41WEPgqSGEzelhBnhNuXfnodJqvbrQ1DgXkZGhKSBjj9R/z1UcF
	LkTHkAwhnz6CWXnwFdClsmlFG0q9N4lCJydMn5/Jm/wneepkZU10pgUwzwroQCOaAulld7
	KKN0V+Mn2MZoeoIna1cBCGDwCATljP0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=IyxmXxsa;
	spf=pass (imf25.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780614353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3xuVttDa/ePoOCg+osbAeIVl7fadBj8JC1EuaI1kX+U=;
	b=8UPnUA/3YRrL2mPy8NDA3Vf/26BCj3kKjiX2xDPYGuTsV2yYtxNP4J7dq2RZMtm7BVkBmv
	+2yoPXAQNz0DisT0nfyWvMJsKt23eyG8BEig45GgdwywuQpd3YIReVmtyG+kOVndYzrqH+
	csn2Ix0Sx8S0rzIU0TwiTphl9yproUQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780614352;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3xuVttDa/ePoOCg+osbAeIVl7fadBj8JC1EuaI1kX+U=;
	b=IyxmXxsa7Jdjn3sQdugc7hkEMddhWf7dLAxYTusniMaDF9RmEm2F/gNuQnl52V1g0XCzvr
	+nibOhu8DRaYCm+F1yWKMrhowoygYiNCpy9DzJwR05RlO4Ij9/IwVuDlciti06ck30Rr2V
	VGFTPaPMqLm9cQ/BI+b6QvwmkU0Q6LE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-367-Gj0hE4-UPDOuWSTWOqFCmw-1; Thu, 04 Jun 2026 19:05:51 -0400
X-MC-Unique: Gj0hE4-UPDOuWSTWOqFCmw-1
X-Mimecast-MFC-AGG-ID: Gj0hE4-UPDOuWSTWOqFCmw_1780614350
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4601c9b630fso517808f8f.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 16:05:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780614350; x=1781219150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3xuVttDa/ePoOCg+osbAeIVl7fadBj8JC1EuaI1kX+U=;
        b=rLwNqY1kdX0u97OqzTr6gB8lfdM+RLu3Pk8f2hBtDWXcgVNb5LkyP23AbrDJVmySSc
         23FlI4XDYLQcN62xjKCSAZnV9KaPgC4BQwPlUjAt+qL9Cgb9ohTyDsA0veYuEQszcLyZ
         SvntfJstAJlB00GEPE6KXAH7ZgGPA2Ap+KYzWSa3WDRSXI19Kyuk8t6GnWrpIZDSKCEC
         VVrSN1C6lGrLUnYc5XhFktqDs9vJROeewJf4k581B8aSxhxtg4Qa6RzOshBElJvz8Mj/
         cd+xY3qwR4CbZecRwI9GkW4j9/1Uaw4et0BKk89P+R5jmx9E0ZZhiwxYsHNU8zhV8c35
         PDQQ==
X-Forwarded-Encrypted: i=1; AFNElJ9lK2lEnBmt2dii4G7KBnSGPo/c9eP1E7vtvhhsq7cFiYAf+0lK5YJ0XX7l6KKsZnwHGtxYX2FEvA==@kvack.org
X-Gm-Message-State: AOJu0YxAoTItyFOcVB+PsI9WWmPmd+kVIKx4Jn6VCRRUAiE4QtEu1A91
	6LNHQcriR6vGEZWxd8Vflfm6Hss+/jMrNxEVyyNsJeQfdSuXuFgBKbRWHaeB/Iq9PbLYBp44vsA
	vkJYSuHlWS8N/GMjI7SJBD+Ks0sev0/vLgBiIcDeESyn6Ckgo10uX
X-Gm-Gg: Acq92OGzzyqqdxDzAOgdpvD1nOC+1POWVCFFnBQNi3YcBckSZfczBo5OMrPvbYAWWOW
	Bbb1dU3cfR9auHdbuIBNFRQ63BBpXw8ohYu8itxmE6XRxcsNR2VBNICteSTK56IeZIlJxLujzi+
	kLPCXpsBWUKUmnnhnDWNm1sqeSwiCAjX1zz6UQWCJIpxP1G6Rz6ctJaMH/pNvCuyxyZg98Xc8xb
	TMIXbtJbcZmJvSNpfgyFNUP7/7r1mNCHShPBXpsfYrU7tNwdY2ZpP8C0rsC++R7sx3QNf+kC9kD
	P/bUH7ieilZVYow7x9ek9EQuTfGoNOQcTsi7FVLDs+mYxspEykYZQFgai93i7Qjr9zkotXgrPZU
	Wc3tUeYjRVSx1VT+wTN8NtxT8xAP4QAMdOABucTb9oM2wqFJYPjIKmfc=
X-Received: by 2002:a05:600c:4708:b0:490:bde3:d112 with SMTP id 5b1f17b1804b1-490c26038e1mr8614365e9.30.1780614349940;
        Thu, 04 Jun 2026 16:05:49 -0700 (PDT)
X-Received: by 2002:a05:600c:4708:b0:490:bde3:d112 with SMTP id 5b1f17b1804b1-490c26038e1mr8614035e9.30.1780614349509;
        Thu, 04 Jun 2026 16:05:49 -0700 (PDT)
Received: from redhat.com (ppp-94-66-118-61.home.otenet.gr. [94.66.118.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f35fd33sm22019539f8f.35.2026.06.04.16.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 16:05:48 -0700 (PDT)
Date: Thu, 4 Jun 2026 19:05:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, david@kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BUG: mm: VM_BUG_ON_PAGE in post_alloc_hook() via
 __ClearPagePrezeroed() on compound pages
Message-ID: <20260604190521-mutt-send-email-mst@kernel.org>
References: <aiFZeSKzb4HLfjFm@gmail.com>
MIME-Version: 1.0
In-Reply-To: <aiFZeSKzb4HLfjFm@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CgVGs26LGIDzimrJTvW-n6TQVT3PgP8qBZwNFjwFvgI_1780614350
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44749A0006
X-Rspam-User: 
X-Stat-Signature: r76sp1m55c7az8roqrs7hg7gc8xzyq4x
X-HE-Tag: 1780614353-70013
X-HE-Meta: U2FsdGVkX1+iRze+ZmNCkHQgvrue7xY2SftSDIkisu6/HyEajwsD27D1uh2c3CZybkU84tb/ODnUAQWpt2yesolVo/yLsjR+g/CN6PsTd8tbB0tOksWljBS63ZZ5TS4ShqR9DPX/U7MwyEDv8P24uzzTY0lRMQyQaHkK3Ld6KkHQRgnK/lPb4pkVflInWYFsKoOaiifv0xBRc9vGYprR9PChiXdsLvBF1EbjT7MUI6KiiZLkWXAKjn7zQabakgr4t4ObuYWjdjd/gKL8oTOBAAjluzJzcfy10kBsfEuJh+iBLkI0lUQu/mAHP+TCLSz6yfZWqc2tTJs0qW7OpdyqqkuNAksqyXaupQTneWASt9WnLR9bYIuPNhNyO7uhCAomH2Py5RsJI1fzxMcO6UkiQIVX2CNMakOkk7Gv1zR1ABBwWoP9cjp3CGEL9e+hCdANaeFgkDlI8oVlmV0/7e7eRX5PMvx7lBhNEMUU0DpT/Dv/Q+tQPuVG0azZe0jBmEr04U2oX6cM3pc+2tA/jbTXdzVNBZNgWXRjfWo2B95Gw7vYsk69ihrStOjXbPgRIL/+/BvINhBhHf1l+7hRJYYkRGqNzM0rMW5qoGdQPYnXKXSPXSjzpXhQNyaVd8HKlx0BosqZp/VqcEi/BbXUz1sFpHV3WydxvyRvedRtECaoyjTHto0Of/KUaqUQ71auh+cyLb4Be7ZEcyDVxLmgAG7nRQpgUoJbZu49WVltiD9fD3qXG0tL6xmz8NrtJyHJxAYdjsutDsZZ5TYS77PTgemomgCShm0gAOF+UMq6VN8AsGfbn5c0SoXqkc2FtSLPQdlq8UmfU+zsHwUaxunHL/2EtRtuiu+DtaSEt7Hv27FYqKR+ShSP2RJ/OrJHaMI0FM58gE9i+Oibo6NNCEc6E2BhaDv4CBt8K0iem7NTj4BruUD+0tLW3PaL9KmUBcL7BWXs2i0dgmnTsxt0n7ZLbeY
 ShupNLK2
 /DyP0zl0rHL0CBvHw/r5dCvgzu5Z/DDierEzMm2kjDYspEYtZ9h2t4swiGVQvXhZtMFyQDfOCGnzvTu79wotoWOnP9lEqKt9HKkBhl4Uh9B9be3F4NEwi7ft70ZzR9ZvwUV6ZP92MD4XmMm6gjAfon7vY+oBH+y+yrembD1SlopLaPqRFQ+W/ndxTGwDb0xo4dbJAQglAl6F6vUJHePQso1P9ojcdU0bWC3dUrlRRSx0weUiEYFNSk4/qBDPTpblCM+oxWw96xRp7AYoOtF15SrX9dXt8ShHFIQEcYQE53sobWU2NnFn6cZvyQegGDbl8eM/iZUlIPnqfQKj/QrQ/ePJ4cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 03:59:06AM -0700, Breno Leitao wrote:
> Hi Michael,
> 
> Booting next-20260603 (a225caacc365) on arm64 with CONFIG_DEBUG_VM=y
> panics in start_kernel() during kmem_cache_init():

it's my bad i pushed a wrong branch to next. Sorry.

>   page dumped because: VM_BUG_ON_PAGE(1 && PageCompound(page))
>   kernel BUG at ./include/linux/page-flags.h:682!
>   Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>   CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.1.0-rc6-next-20260603
>   Hardware name: linux,dummy-virt (DT)
>   pc : post_alloc_hook+0x224/0x2b8
>   Call trace:
>    post_alloc_hook+0x224/0x2b8 (P)
>    get_page_from_freelist+0x18a4/0x1b18
>    __alloc_frozen_pages_noprof+0x1b0/0x2068
>    __alloc_pages_mpol+0x130/0x2d0
>    alloc_frozen_pages_noprof+0x64/0xe8
>    alloc_slab_page+0x88/0x140
>    new_slab+0x11c/0x680
>    ___slab_alloc+0x18c/0x7f0
>    __kmalloc_noprof+0x534/0x938
>    do_kmem_cache_create+0x724/0x890
>    create_boot_cache+0xc8/0x148
>    create_kmalloc_cache+0x5c/0xc8
>    new_kmalloc_cache+0x274/0x438
>    create_kmalloc_caches+0x2c/0x88
>    kmem_cache_init+0x228/0x2e0
>    mm_core_init+0x74/0xa0
>    start_kernel+0x1cc/0x4d0
> 
> Bisected (by inspection) to:
> 
>   504f40f6bda6 ("mm: page_reporting: skip redundant zeroing of host-zeroed
>                  reported pages")
> 
> Reproducer:
>   - linux-next 20260603, arm64 defconfig + DEBUG_VM=y (any debug-heavy
>     config will do; mine also has PROVE_LOCKING/DEBUG_LOCK_ALLOC, but
>     those are not required to trip the BUG once an order>0 __GFP_COMP
>     allocation hits prep_new_page).
>   - Boot under qemu-system-aarch64 -M virt with earlycon enabled.
> 
> I've tested something like the following and  I was able to boot the host:
> 
>   --- a/include/linux/page-flags.h
>   +++ b/include/linux/page-flags.h
>   @@ -679,7 +679,7 @@ FOLIO_FLAG_FALSE(idle)
>     * PagePrezeroed() tracks pages known to be zero.  The allocator
>     * uses this to skip redundant zeroing in post_alloc_hook().
>     */
>   -__PAGEFLAG(Prezeroed, prezeroed, PF_NO_COMPOUND)
>   +__PAGEFLAG(Prezeroed, prezeroed, PF_ANY)
> 
> With that change the lockdep+DEBUG_VM kernel boots all the way through
> SMP init and hands off to PID 1 on arm64.
> 
> Happy to test a follow-up patch if you'd prefer a different shape.
> 
> Thanks,
> --breno


