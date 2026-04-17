Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62709F8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 04:42:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56B56B0089; Fri, 17 Apr 2026 00:42:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07966B008A; Fri, 17 Apr 2026 00:42:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D406B008C; Fri, 17 Apr 2026 00:42:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA0A6B0089
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:42:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2D83A140AC6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:42:50 +0000 (UTC)
X-FDA: 84666802500.23.093B319
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 63DF88000C
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 04:42:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pfGQ5i1V;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776400968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wpj39TGx/mC1IMxjnHryJvwkINMN0YeHEncMqqCr9og=;
	b=d5aKIBornsLtySHuJAr88sJFmyoQ3qhRrYq8t573hq6diCALVqcHCQn/BaSfG5dkeQnNgw
	f8qI6NafXwqOyWCdytmTM1632PMS+tPfB4LBj2eJfI3jzxNtRSLGlsrU66L5QBvTNSiwQK
	dSfSGwo4a9wMi0J610JriewvJBH6Qfc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776400968; a=rsa-sha256;
	cv=none;
	b=0IQ+usD+0EYUWVeHtxuGRwSHjBMAdvc8xYceC1Ft4OwJ2omXWkU/PEfUbpXxBGsNsn2nMb
	hAq7aTT/+pwD9PaBHD2Vnouz4zTombLgue6ACg0g5ZlLde3mecNBbc3maR+LIh3hjo+D2d
	LEQXqLm/VKs9dhr0s2d9DcJJHaPWJi8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pfGQ5i1V;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ECCE5444FF;
	Fri, 17 Apr 2026 04:42:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DAF1C19425;
	Fri, 17 Apr 2026 04:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776400966;
	bh=+kZcyO2YZoRks810z1foc/yqdqsP8AdQc/GigncPdOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pfGQ5i1VLFUUh34+/+2ZJ/V44nhKo2xNclSoGPtwovtCwj1cG6ZQf3ti3r2EXSitX
	 7mJyT9d3TCfs9780go8IhtH920vp4qoBQX/crZM7RcTWAUfaaKUOFLC3mIRX3/KG/L
	 ACBjM+96sMBelsfvWCPPQ3/PUGHEc0GFrCIlNHk+Vrm0hczq+b6Hq6tKw1KVXkac/3
	 Vuk31u6o8Z35yuYIwebWWKYd45HalbXTjzQCVp2BGG4GZchpN7iBVY8ZAkEkVQ7WJn
	 Ghw9ik03Fu3oBmqTiQvABV5dKdd0zntiU0pdUPsA08r7MWtR3DivtjD29SkfohQNsX
	 3drwy+Ol8BqVA==
Date: Fri, 17 Apr 2026 13:42:44 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	stable@vger.kernel.org, Vitaly Wool <vitaly.wool@konsulko.se>,
	Uladzislau Rezki <urezki@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>, rust-for-linux@vger.kernel.org
Subject: Re: [PATCH] slub: fix data loss and overflow in krealloc()
Message-ID: <aeG6RG41sgZuerYa@hyeyoo>
References: <20260416132837.3787694-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416132837.3787694-1-elver@google.com>
X-Stat-Signature: i1xu5ci6mcwzf98gxmbzk9q7zmbws1eo
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63DF88000C
X-Rspam-User: 
X-HE-Tag: 1776400968-93735
X-HE-Meta: U2FsdGVkX19ORQDOVy5SbxjAw0q9GPi4W0LKG1nl1giPygReLPxLT4Qi3nCwakvHLfphXhpvdYIPq5IUxQ0Lh40WzkPnv5GLxmL/o/E537f4Z1+QGJjGAIExLRoyXF+BFoPNtgEioSBb4iTSzIV/xqzozW+yDBiljnFyPfj34J1y4afq6uSp7Xtesl/QAQs0M5494YOn6g9kyW4beT6offZKA5hNmRISAZPkw/W0sMltpIAVv5bYoQ1y0grQsP5b5gQTLsuF2lUDp33YrtdIX7shpCSJqTR9wRPgAUYBbkn4Al0ga+t534TL3shJp4tH79Mp3FkbAfdMMHG3gNaOciHXA3cYPAqZZkvsRN9hgTmi1D6kzcHH1OmSpiLVFNF7VIcwGQnvZx7BPhtJEu3w2Iz+4crdSrjGSwWdFuCDM8PhZymD6/zQN7I8wR+B6CooI/hKXVfV8BY5LrmkkNxYtY+PjZqxrI/QHA9w4jt66z7XJDaD8SYFax8oDGsKcqRYJrRM1iRsH9ctEGBJLYdm1qHHxkJ6srzZuaSfXesCFlS8egX46v/03VKkaNApbBN02LaQjTpYaFnxlnkOkZTsSBQhEepEYn2SuOXpx+e83wbeptymAcLXuOnpUcG25hUySz3ViYJu6liyopV2OtjL0//5X1cmcmJXu1ccNETX0ZsHbbwhsKFBaxa4TNoNhyrNRXE8RvIP326eRVizvmroMjsH9YKjEaLkG28moc0teVi6iw8MmOj29p6WEE2rTXpLMiKTFr7DNRQl5LCp3qDXkxpgTIZRZKA8rW4/N2+Er6/tGhhHb/H1Z9qef8xMwD9VNbXMQUfXTI9uUit925/XYVz2+DOoaPSzJPmQQAt171NuyFapKIzXb/mZnQzkqy2WrgjBWcByhkllEVzNl5/wTSomanaAJdWNahaPwXITZEUOdhgf7i5kebzM+b/jfRRDeEiMVCtmscy7WOPwV11
 ILFvRcym
 2OoZ0ZPYpNxxx7OjEqa6OQQ0C7PO3hEVQ+a7syYAISwaIL0Q6o8u+wUb3O0eb534Qp02NR0DF44jKpZpUnGh4dpXSk4nwUAN8G/OJRApoYfz9gXZVN3/1sK3f4/cfrOpMs00ET0ZP1kI6cFulZiflJvGStcT1phuHyAYi8+88gaSzJkF7dOEEkU1wIUxnDVGxWyZah/pavdBDIpZY5qBvMYdISBDAvkHKmzTg+k8jZHGmfM4wg856rsvM5f+EbZPApg2013ni6+I+HtS5Vt+wY31S6zalR1dJu5FiMpKEZzdEKmsjN1LapCnHN7YfTWFUuZ59KDbKaqi5yE0V2Sb02K+yzc2YRopPYMuhdh3XbsxhpOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[+Cc relevant folks]

On Thu, Apr 16, 2026 at 03:25:07PM +0200, Marco Elver wrote:
> Commit 2cd8231796b5 ("mm/slub: allow to set node and align in
> k[v]realloc") introduced the ability to force a reallocation if the
> original object does not satisfy new alignment or NUMA node, even when
> the object is being shrunk.
> 
> This introduced two bugs in the reallocation fallback path:
> 
> 1. Data loss during NUMA migration: The jump to 'alloc_new' happens
>    before 'ks' and 'orig_size' are initialized. As a result, the
>    memcpy() in the 'alloc_new' block would copy 0 bytes into the new
>    allocation.

Ouch.

> 2. Buffer overflow during shrinking: When shrinking an object while
>    forcing a new alignment, 'new_size' is smaller than the old size.
>    However, the memcpy() used the old size ('orig_size ?: ks'), leading
>    to an out-of-bounds write.

Right. before the commit we didn't reallocate when the size is smaller.

> The same overflow bug exists in the kvrealloc() fallback path, where the
> old bucket size ksize(p) is copied into the new buffer without being
> bounded by the new size.
> 
> A simple reproducer:
> 
> 	// e.g. add to lkdtm as KREALLOC_SHRINK_OVERFLOW
> 	while (1) {
> 		void *p = kmalloc(128, GFP_KERNEL);
> 		p = krealloc_node_align(p, 64, 256, GFP_KERNEL, NUMA_NO_NODE);
> 		kfree(p);
> 	}
> 
> demonstrates the issue:
> 
>   ==================================================================
>   BUG: KFENCE: out-of-bounds write in memcpy_orig+0x68/0x130
> 
>   Out-of-bounds write at 0xffff8883ad757038 (120B right of kfence-#47):
>    memcpy_orig+0x68/0x130
>    krealloc_node_align_noprof+0x1c8/0x340
>    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
>    lkdtm_do_action+0x3a/0x60 [lkdtm]
>    ...
> 
>   kfence-#47: 0xffff8883ad756fc0-0xffff8883ad756fff, size=64, cache=kmalloc-64
> 
>   allocated by task 316 on cpu 7 at 97.680481s (0.021813s ago):
>    krealloc_node_align_noprof+0x19c/0x340
>    lkdtm_KREALLOC_SHRINK_OVERFLOW+0x8c/0xc0 [lkdtm]
>    lkdtm_do_action+0x3a/0x60 [lkdtm]
>    ...
>   ==================================================================
> 
> Fix it by moving the old size calculation to the top of __do_krealloc()
> and bounding all copy lengths by the new allocation size.
> 
> Fixes: 2cd8231796b5 ("mm/slub: allow to set node and align in k[v]realloc")
> Cc: <stable@vger.kernel.org>
> Reported-by: https://sashiko.dev/#/patchset/20260415143735.2974230-1-elver%40google.com
> Signed-off-by: Marco Elver <elver@google.com>
> ---

Looks good to me, but I think we still have a similar issue in
vrealloc_node_align_noprof()? (goto need_realloc; due to NUMA mismatch
but the new size is smaller)

-- 
Cheers,
Harry / Hyeonggon

