Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D74C0E7DEEF
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D67C86B00B0; Mon,  2 Feb 2026 09:14:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14D26B00B4; Mon,  2 Feb 2026 09:14:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20BE6B00B5; Mon,  2 Feb 2026 09:14:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B07886B00B0
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:14:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3683B14018D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:14:11 +0000 (UTC)
X-FDA: 84399711102.06.F077FEC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id E42B540006
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:14:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Vuf9nYmW;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770041649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wAc1k4+zJsRHlPOaEXkpUDHcRc6VbrRi9Rvm6Gsx3+s=;
	b=5/A3CoF2gZi2edwtgNOlAJYTMrdY2VZIvQnq+ZecnsaiwsghoM4aglC9tTRnHbJqfEJ4+w
	TpeI+LcdhAkft75CmovJeF7kWERLWW+KX4PlDq2f0uLCAizOpkvJSr3DLtHSzuTZKi9ufv
	N74tNmq3qx6vDBVIBeEy6p1GdcSR/Yw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Vuf9nYmW;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770041649; a=rsa-sha256;
	cv=none;
	b=m4e0QaR7T1GoLRnWsB6Oi/YGyl4Nu+BcJvNCG8tKAypkULWYlTNBzarzPdSZgSCrv5gcsQ
	dM/6In1+e4iL7ErZIiutpcKkRLwc0peoleDViaJj+PKlnGwuoEnfhgwCG6/KOuL+kA7xDn
	3JJfQ8X2arA8V+mxpO2fYM7JNlXk2xw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=wAc1k4+zJsRHlPOaEXkpUDHcRc6VbrRi9Rvm6Gsx3+s=; b=Vuf9nYmW73DOvW4W1bCFO/Hxhf
	uedDfAw5PpTFnap8ZcF5G1fMOqOe2VE3qvN/KvhNd6cK/1iX33t9qDefGu5dtybDwg6SHc/mTsaQ3
	4pfJ7q7Q7UW/Fqy7tYwfS+di3ywvNLV6d4u27oBErXywciqNsEyG6fUzAxxvO/DPTJKAQQhnfbGdQ
	4XAG22Ps8Iq9rSuz7NqYPvMUDTfjmzZ2ZNqT89ksZxR5D2Mda66892y7vk+/5MOUllpHQhIGQ/Zbb
	I3M46ENR0WVdvoH/48JMvhlIsSh2JE8qpY1GgUH9yrSJOD8h21d48T4MMyRVu5NO597BRMa2BcCMK
	Xt9iQZtQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vmugo-0000000Gb0L-1joD;
	Mon, 02 Feb 2026 14:14:06 +0000
Date: Mon, 2 Feb 2026 14:14:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: =?utf-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [Kernel Bug] KASAN: slab-use-after-free Read in
 filemap_free_folio
Message-ID: <aYCxLsCVUT_kky4o@casper.infradead.org>
References: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: mc96w3gtp7ny9bay6fx9deb9jqdjkpco
X-Rspam-User: 
X-Rspamd-Queue-Id: E42B540006
X-HE-Tag: 1770041648-284973
X-HE-Meta: U2FsdGVkX1+OZsjl4DgfUMvB9O7YU5b9E7vSKAjBQq6I0qYADe/yiXlG/RvzJzGRtIH8MpTW90bFb+Q0XU8p1GTUJEIudbwcS8Yz2FmPmNHbDSyC3lSpn5rHvD6UQoRYWa1N8uAX59GF90flsPjY3bjed2ytQwc7B2rnze97qqpzP+LrQaledkgoqxzo9TLW/FvqhSsZIMAiFlKL7HpBRKCZ34Arcbxw0OLZn71Jy26gjdAtS/E88zZmMGz6C/vmMFaChkzWQHzs16ktrT9VnWDUquzeId2eT2sDlXrfmW0Rz2xjs+isJbAUVQlm61M927CX1QOUdKfxNCuvcUomcMNRHRuMXRDJBZCFpY+QOZ/n3fJAoFnaeox98zwU8mecTVA3+4WcidbZNHCllwa+Y3aqCo5JsYsrV2vK+rrhIT4dfEkEU8KUpEhZpoIDY3ywF5ptgJ1CvgbYF6KgphkGUut2qt6bjbd8NxdOPWZ31jtr3uHn0H6qW5YFQDYSoXX2O2lq3hLVEdUOULEdR7fYVyjLpjwqVUUsK7btHrkHl6E/u29/VB2/rqWG/5ii4iJ6fCUW5mhwaN5ML4/C6TkFe6VNxShNKuB7H6R4slR5bLpJr9fxFIG3ezxg9O50DFWNgbR7a/Jxxx2g9jubpJWSt8exXOLA5aZHVSs0r4Z4MW00M6sIMnP+TkGanCdjpStZ8oxSkbDEw2ybj9Wt8lnUJvdhXm2+qIABvzP7qvS7Mb4grGzN5v8o435kPs+WCv3PqmsmFi+3AkF/8XvTTLGJhgSzkej26Yu92kMmNjn3nsLc4oq59+i1AwuTXtSfQufHc+0GO8qq5DW3NAL9skWpsA5Gqlq6MyH/MW5X2JdMFJuC/ZrdQ7Ri3SKjOHvjyelc2AljIomAw8m/8imr5jXo47UH7jJOPpsBSfLiuGjZuTd5jt6BrTp+KS5YADgriZzHmBxxXtNxH9d3UaRqAui
 W8Th16en
 9FAzjBdEnT5CIYa5rlrjsz61OcZcQnjOl2DE+Ms0b697J/vtiKSh6j9l1FtTlCvfw47/BfOwzAorxhk2qc+Pjn13vMpqhHVf9IKMntiQtkVq7nf5AQ2HXq8mAtbA84tp2+GR3cgTMz0JPnbI/dM8ipc4JTniER1QVeeaZsoNdh1HvOYq7sDl2Lwjv77/rbfu6B93LF4Qj0Cr0bA2+83I3v2HG8UWejfZABjOY9ojYan8mk+bf9ULKtr4CnTKY5mHjnoJtw8WtBMMltPn4fKuxxrscTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 02:20:50PM +0800, 李龙兴 wrote:
> Dear Linux kernel developers and maintainers,
> 
> We would like to report a new kernel bug found by our tool. KASAN:

Don't be syzbot.  Get your changes into syzkaller upstream and let
syzbot do its thing.

> Allocated by task 49607:
>  kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
>  kasan_save_track+0x14/0x30 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:342 [inline]
>  __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:368
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4978 [inline]
>  slab_alloc_node mm/slub.c:5288 [inline]
>  kmem_cache_alloc_lru_noprof+0x254/0x6e0 mm/slub.c:5307
>  ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393

I'd suggest this is an ext4 problem, not a pagecache problem.

syzbot has good heuristics for this kind of thing now.  You don't.

