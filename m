Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C311CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9290C8E0002; Fri, 19 Sep 2025 17:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA548E0001; Fri, 19 Sep 2025 17:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0098E0002; Fri, 19 Sep 2025 17:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1D38E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:04:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 16DAC1603A0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:04:23 +0000 (UTC)
X-FDA: 83907228006.20.6ABAC99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 655ADC000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:04:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ig+49G/2";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758315861; a=rsa-sha256;
	cv=none;
	b=3FDxdgPHVCh3u/sh5h7RAlRylP/21GquOPK4ZcNCqwLN3RyewF1vvFq3eo2j8uLFBZa5In
	cBxZ3E842+vzeGrkAgVUAGVeLW8aT77h7m96BnzLytYvAtfVh4wP5Kfp3lF6kkWODtCwtn
	fyRKfFRyXCJQB/ffI1peBYeOQrnO9XY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="ig+49G/2";
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758315861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qlMt9MKmwF5yNav4ME+Mam5yJ7pa9kcM0iaFRbPE9sI=;
	b=PH+E0KxAvcVaufZzyke0aL5lUBzrd5D5foLBnwVG7PSmlmt7HfNgm/Ig73lqbKt4J6bnEF
	SkEVagQO87qvh9MiaYJnl699f/QnQaicvPZBJJhuKF+tIs5xNYkkYK4lHwul4yTnyASIGH
	+S3Yi5OUx0R/yYf3maLz61l23vpz3RY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C0D2C6013A;
	Fri, 19 Sep 2025 21:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2CBC4CEF0;
	Fri, 19 Sep 2025 21:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758315860;
	bh=EU8zNicQ8eJr5UVkTiOVy8XXNkvx4SqxeyVDnW7wBjs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ig+49G/2yD2qUw19e4LfDCEoMIfKV9Ihzm3yO4WEMdWU9WuivIGAAXNKY9mLRW2b1
	 SxeW+GV4unTN6WxFWVXvzGnETQBqjbxrcuT5nTq0zHYYGTAHDROHMk6SsHpc7E1epB
	 W6GojnyZ0vlmbilrYbJoUlWKMmSWKKUvp5ddLL1o=
Date: Fri, 19 Sep 2025 14:04:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Linux Memory Management List
 <linux-mm@kvack.org>, Mike Rapoport (Microsoft) <rppt@kernel.org>, Pratyush
 Yadav <pratyush@kernel.org>
Subject: Re: [akpm-mm:mm-everything 254/254] kernel/kexec_handover.c:970:50:
 error: passing argument 1 of 'kho_restore_page' makes integer from pointer
 without a cast
Message-Id: <20250919140419.211ec45cae8a479d1e347453@linux-foundation.org>
In-Reply-To: <202509191034.SM82Oaij-lkp@intel.com>
References: <202509191034.SM82Oaij-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 655ADC000D
X-Stat-Signature: nyi5xxz3is7owa51i5mhjxb9e1kq8kuc
X-Rspam-User: 
X-HE-Tag: 1758315861-817087
X-HE-Meta: U2FsdGVkX1/RPTg8bgfGj/eihp/S3Wbnyhig/J1/bvX41rZV8ASEP8qSwv9AwZowtL1HDJp3tY+ywVtAcDNkbFudnjR5CkceCVxKnhIHV63UDzGcVVUn3vhISNguxI4x7a4MLf1fdSZqz7NDJV88oOl0n+n42qinWUZpVM2GLvg84NdW8nJX5KzYJeDayWqPSlJdiEybtF812qMbTEkXsgZ9jOPTqIT9kYQyx/M9xTKpttYV7wJPeYWGtAPn/UnlvXiIG6AoKvVhcmRl8epoVMVLja2kGLlw9VD8Y8H/a/QzPgtoOypMjSZlU0G0NRo8RAy3fZyH4OvuTE9uC/tPQ1tzBGZsm84li49yj7ah2D8nGXbX7XZNw6q4IO2KJiQiKONRGkDBa80qjgqMb02sUtlccCvhkX9tiS38mp1NTQ0/6UK5zidf4wPdYaBSfDTixftXJy/xsBi1vc+u6/uMSLcfZfXUm3/HXqHXuHfy+hH7AGVf7B1KDHYXlyKqO/6WsqUy5I2rogbUK4/A9oUzUAamuqd1dTBFDw+U0SCRWXVp8txAkUNqfrwX6P/DBA2LmxzhtM55vdf2qKpygWIJBsQFO7djxzMbCqcZnL+Oqzlf7nQNTPXe4AnkfHrODdpkIQg2Fy/h9qni3JRbU6jwENpgg4AuIzJd/zzVS3UR83Fr/OIe5itVbhAVl3IoIFz2WEBNxiA/9VSLJcf0tdxhFsnZ+0NHkqNv7wj4S8VnhRX1Rbf4y3nZOGRjDxbZ3ulodAKQf5MjW4KuRkD8JoAuNIUsHIJxgTnue0KhzKNlPMpUU8TSV1qzsbogSBux6rdsKaIEjxQnjBwZMUYG3t011Fhc7ePqrVSAsaF50bQEwT2HG2brHWyqmLMrmlDFn9LJL+ESUhC0Fmf9tkVEV5pkrbd66uv/wZPaYxHuR6yvvez0zhz9v9dqdtGcw8tv2azmGsASSqQnecVgY9NZNf+
 kKtFPWth
 Y53jr9X7UDJn51ofqxVtfiH4ZEdCrV9eis4illWnTsOuUX6n1x/LeuTM5pJT7cLcCBenwlKNiKCR4v7C1F/YaZNaEh1y84XAB0miJb4xUUjiQ0hZIRYo9hIwJFaMPljqiLRhOzCV/G6g3n/7DDheGYQeZX9DL0/35RBR7yKrtmndns4B7S/RKy7esPeZczOWO1IxxNOA35w/Dj7BvQ+mwOFzFr9N3WuXNOQqsoMCrlwYZk40TJZD9/IyTegwpaRXFvB2lxMD35y0aRpo3bUyeuVxNn4hVk9EDrb7pAezlDzof9yZQwvlngujdQJKop5lT2RKO+NvYdwegiCypDBj7x6DxdvKfDDceBTE8EjUL17uqkhX6scBjNs/zbY4IEFGI6Lqd/xGhLaN6Gx5EBAYCuqJtxw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Sep 2025 10:37:27 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> head:   46735c0743fed990d0ed8722a131ef54006c45a3
> commit: 5369505b204b3fc65f839f7558640b6ecd675461 [254/254] foo
> config: x86_64-randconfig-071-20250919 (https://download.01.org/0day-ci/archive/20250919/202509191034.SM82Oaij-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250919/202509191034.SM82Oaij-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509191034.SM82Oaij-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    kernel/kexec_handover.c: In function 'kho_restore_vmalloc':
> >> kernel/kexec_handover.c:970:50: error: passing argument 1 of 'kho_restore_page' makes integer from pointer without a cast [-Wint-conversion]
>      970 |                                 kho_restore_page(page, 0);
>          |                                                  ^~~~
>          |                                                  |
>          |                                                  struct page *
>    kernel/kexec_handover.c:229:50: note: expected 'phys_addr_t' {aka 'long long unsigned int'} but argument is of type 'struct page *'

Added by "kho: add support for preserving vmalloc allocations".

I wonder how this happened - was the correct version sent out?

How about this?

--- a/kernel/kexec_handover.c~kho-add-support-for-preserving-vmalloc-allocations-fix
+++ a/kernel/kexec_handover.c
@@ -967,7 +967,7 @@ void *kho_restore_vmalloc(const struct k
 
 			for (int j = 0; j < (1 << order); j++) {
 				page = phys_to_page(phys);
-				kho_restore_page(page, 0);
+				kho_restore_page(phys);
 				pages[idx++] = page;
 				phys += PAGE_SIZE;
 			}
@@ -975,7 +975,7 @@ void *kho_restore_vmalloc(const struct k
 
 		page = virt_to_page(chunk);
 		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
-		kho_restore_page(page, 0);
+		kho_restore_page(page_to_phys(page));
 		__free_page(page);
 	}
 
_


