Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3863E606A31D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=b8+aD1KJ
Received: by kanga.kvack.org (Postfix)
	id 3A7816B05B3; Thu, 29 Oct 2026 15:50:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372226B05BC; Thu, 29 Oct 2026 15:50:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B0C6B05BD; Thu, 29 Oct 2026 15:50:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 030B36B05B3
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:50:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54FA7A04A2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:50:50 +0000 (UTC)
X-FDA: 85376706660.08.5706CD1
Received: from mta0.migadu.com (out-117.mta0.migadu.com [91.218.175.117])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25339140002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:50:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8+aD1KJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtEOaWfP8tv9g+g92adSRdR2qBq/UBZnhwhpMjBubc8=;
	b=V2EpxjeHJm8MBvoKb2enZWF5mTQBdiHcgty4tPH1qqV4Bh93PapT6X4yZuQjOhQMBzmutC
	FiTyeBhSJrrV5F6k1zos2BtyxzBFaFSOUrDHqY4sFuDUAWkroZrr81XXdYrrnC48ff4Up6
	1kQ0VIr9x9IFGpBODf/Isdmgw3GwMDU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b8+aD1KJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303448;
	b=VXhlXjtlLwPNN0vve+FwwSGhK3FAG8AJPkCM10h3xp7N6PWLFtRtg1vaPsAAuoDqpIDZX6
	7lnMdt6CCG7MVc5aEP4xFbW+w+l3soJsi70ekPqOAYbIF7+LZPOMtLzIxMAR4wYS2i5LT0
	J1J5bOseB5mu8O/01FeRsggCkk5S0U0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oCF7P8x0NM5ij/TruM3+Ta2vikeg2OnPaSW/zqp0m6w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793303445; v=1; x=1793908245;
 b=b8+aD1KJALXDFdfbJRJ6AOK1uLs3j10fzQ+6XWK3dioQ/YbHWvfKpOLb4xyBKWqZVo//LtMk
 rNHfeh3IuV8Z5sC0ebz2xvai35ySheUYRzUNqTRShcv3ui5Jtrcuoa621buHz6OvudKKjZWdwvd
 QD3h3jVHjpUwyk8S3XZpDWiM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 796089e730b762cd;
	Thu, 29 Oct 2026 19:50:21 +0000
X-Mizu-Trace-ID: 796089e730b762cd
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 12:50:15 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 3/4] memcg: Annotate slow paths in consume_stock() and
 refill_stock().
Message-ID: <auOjX_O3vwou-lJ6@linux.dev>
References: <20261029194452.3189365-1-kuniyu@google.com>
 <20261029194452.3189365-4-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029194452.3189365-4-kuniyu@google.com>
X-Rspamd-Queue-Id: 25339140002
X-Rspam-User: 
X-Stat-Signature: dx5stkrohztw5p774e7943shweqi9uyh
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793303447-378234
X-HE-Meta: U2FsdGVkX1+xNfYAuu0zRR7nMnny6SSPhD4+AGre06m4YquR67B9IYts+/P/fyR8sjyY0XVvZUromdSJlknbV47pLQ1Y//D37OpYXFxSPHgl6CV4z/il0anpxzzABO1cOLrcJbWPREpqInCEHqFtgWYtFIR8uXvZhkRbtK83S4hXNPM48QZDBRhmplTZus8YwGIp/6xwNFCLK9B5K/JQnUzpsA5C3BHKG+dVHgwcemdDB7gFu3EVy9mAg3O/KMgbOOXOIgP5AA3upePV5T75Abr2GAES/+PusEhjYqLTwYLvAop+xkWfZppwxMvHf1ty69K22YohAC7SM2eFuj5aNep6CGZjsIz4CtSP/l33AR/0PeM2KeBgFLwSW07Cz7UoUlzOu2INwhoqJLfVjM+tVV1P0aKwxA/R/idTVVJGlsHLVhQOrl0ZS2gSjlL0UZInOcKDZynGqy7aEQzZhkHFrGU2cc8ixKLweWHroTcvjiWFgmJLAvEt1QCyMVQwN7NbULV+uICxJSOCptGDzTYgVHQHevSQ8fmNFMjPLalzsyczVfFfneQna2X1TPgRwKbYDF82lbM0Zh35IG/jcVYPre5yiNosgJ2Lkgk53F8jsvaeQKb5sWPFF2L1qCPkh7yKlwFiHmAQgtXKWaolDCIYJzSlpZd/bB79RaU7CJml++BvyAYfM93FheEEUluqZN84JOkRZoggbrNzv1lvv6KXI/Sph15gTtfS5qcILRDKMUClpE71nEtLIu2cSfnkxfIvC7M54xuSE3QUsYJkl2xXilbbdSxVHp3IY8Z955oP3PI/8aa6P5ynGVUaC3buGM8Ms54Atu8TYJiCzojye9RLLU3MaFg8GCNDgnpCepAvFGvlFiIuG4tJDdu6QoJTT088/3tAQJPu0+zcjJI+F2cSI4WeclUbj2zttdmlR8Nv7LaxTecXWxCw5uC2lQCv6CjSUycoNLbDvknlcHYv3qK
 U2nhg3YX
 E6IWK6EGS5/d7Rc5EZFaR76Yidczw48reuwDMYb/WyRfnrc8IFwkGA5n2NgI1nVEn0tF3mNV0IhVQNpWpKrQsnDk/QP7Y0tG0wobaB1L8chyh5KfakIMH8iI2APowJ+ekh/gTdd7GPoKcOgITRkc+nHSrPLwig3fUlK7U+MTTjKzKs0/hW5/JNuzhT2YgXb2crUhI8m1fcpJ16/ZNUTUt7JdEENnQ+A4pHPtij53Bavbp40BsomEjjlk7WRz7IfVBo/X0W5Ry8D9t17l/o98scQZorCKD/qNL1mnvUx+B47K1oFvsV4uedIc6w1K6dx6Nil0xJDx1XSfFGkvcjHuq4t/f4AVuwV7dEbe97VyXQRojt0pgTYF/5a2J7wFQS7cnNiG7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 07:44:14PM +0000, Kuniyuki Iwashima wrote:
> In consume_stock() and refill_stock(), each per-CPU stock slot
> holds up to MEMCG_STOCK_HIGH (64) pages, so depleting a slot in
> consume_stock() (!stock_pages) or trimming a slot in refill_stock()
> (stock_pages > MEMCG_STOCK_HIGH) happens at most once per batch.
> 
> Similarly, requests larger than MEMCG_CHARGE_BATCH, local_trylock()
> failure, and insufficient cached pages (stock_pages < nr_pages)
> are all slow paths.
> 
> Without unlikely() annotations (when building without FDO, or
> when an FDO profile does not cover a caller), Clang 23 treats
> these branches as likely and inlines css_put() in consume_stock()
> and memcg_uncharge() in refill_stock() right into the middle of
> the hot path.
> 
> Consequently, the fast path has to jump over the inlined slow
> path and jump again to the function epilogue after local_unlock().
> 
> Let's annotate the slow paths in consume_stock() and refill_stock()
> with unlikely() so that the compiler keeps css_put() and
> memcg_uncharge() out-of-line at the cold tail and lets local_unlock()
> and the function epilogue fall through on the fast path:
> 
> Before (refill_stock):
> 
>   stock_pages = stock->nr_pages[i] + nr_pages;
>    7ab2: 43 0f b6 44 26 01       movzbl  0x1(%r14,%r12), %eax
>    7ab8: 01 c6                   addl    %eax, %esi
>   if (stock_pages > MEMCG_STOCK_HIGH) {
>    7aba: 83 fe 41                cmpl    $0x41, %esi
>    7abd: 72 1d                   jb      0x7adc <refill_stock+0x21c>
>   memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);   # inlined
>    7abf: 41 89 f7                movl    %esi, %r15d
>    7ac2: 41 83 c7 e0             addl    $-0x20, %r15d
>    7ac6: 48 8d bb 00 01 00 00    leaq    0x100(%rbx), %rdi
>    7acd: 4c 89 fe                movq    %r15, %rsi
>    7ad0: e8 00 00 00 00          callq   <page_counter_uncharge>
>    7ad5: be 20 00 00 00          movl    $0x20, %esi
>    7ada: eb 41                   jmp     0x7b1d <refill_stock+0x25d>
>   WRITE_ONCE(stock->nr_pages[i], stock_pages);
>    7adc: 43 88 74 26 01          movb    %sil, 0x1(%r14,%r12)
>   local_unlock(&memcg_stock.lock);
>    7ae1: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
>    7ae9: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
>    7af0: e9 03 fe ff ff          jmp     0x78f8 <refill_stock+0x38>
> 
> After (refill_stock):
> 
>   stock_pages = stock->nr_pages[i] + nr_pages;
>    7b76: 42 0f b6 44 33 01       movzbl  0x1(%rbx,%r14), %eax
>    7b7c: 01 c6                   addl    %eax, %esi
>   if (unlikely(stock_pages > MEMCG_STOCK_HIGH)) {
>    7b7e: 83 fe 41                cmpl    $0x41, %esi
>    7b81: 73 20                   jae     0x7ba3 <refill_stock+0x233>
>   WRITE_ONCE(stock->nr_pages[i], stock_pages);
>    7b83: 42 88 74 33 01          movb    %sil, 0x1(%rbx,%r14)
>   local_unlock(&memcg_stock.lock);
>    7b88: 65 48 8b 05 00 00 00 00 movq    %gs:(%rip), %rax
>    7b90: c6 80 00 00 00 00 00    movb    $0x0, (%rax)
>   }
>    7b97: 5b                      popq    %rbx
>    7b98: 41 5e                   popq    %r14
>    7b9a: 41 5f                   popq    %r15
>    7b9c: 5d                      popq    %rbp
>    7b9d: 2e e9 00 00 00 00       jmp     <__x86_return_thunk>
>   memcg_uncharge(memcg, stock_pages - MEMCG_STOCK_LOW);
>    7ba3: 83 c6 e0                addl    $-0x20, %esi
>    7ba6: e8 15 f2 ff ff          callq   0x6dc0 <memcg_uncharge>
>    7bab: be 20 00 00 00          movl    $0x20, %esi
>    7bb0: eb d1                   jmp     0x7b83 <refill_stock+0x213>
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


