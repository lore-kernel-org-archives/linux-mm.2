Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06274FC5910
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:07:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 672426B0093; Thu, 26 Feb 2026 05:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F7D6B0095; Thu, 26 Feb 2026 05:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56C346B0096; Thu, 26 Feb 2026 05:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44AAA6B0093
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:06:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D1D61CB8E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:06:59 +0000 (UTC)
X-FDA: 84486179358.07.D0E0A4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45D3C180004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:06:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r27eNEsg;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uZ+FcrHvnBOldWUaBXXS/DwJYw9zNqN0B3LIJw8H+U=;
	b=hPTIxkP771kmYGoPfFSIyY3giv5oTK0fUSqGPiFNAEYMqbAV/W4Z8b/NWp7+pK8GYgzNwT
	0VxxtBvOqraLB6A+74zhAvqDHXb4ohb8GUfX1xu1iMuewJtSzNfR1SFJCiheK6DmUwRps5
	OFXJFGPklB6FtQyPf+F+Qzs2VbL5nkM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100417; a=rsa-sha256;
	cv=none;
	b=qnh5UbIJe/jdO02XRbb8rg8KyzIB+/GDJ6AH//KMXG+2NEdO/oTmTtOZkR3v+ubLFPXd7I
	c0d0ShbQbgN8wKUZmlrQ+jtKgjjskaoMCgN0aQOcR51voilOpcHocuHK/fURLjmkAf1ANx
	z8xZ8lkvshiQU/GNEsJnoU8BM1Yaws8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r27eNEsg;
	spf=pass (imf16.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A57F660054;
	Thu, 26 Feb 2026 10:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99115C19422;
	Thu, 26 Feb 2026 10:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772100416;
	bh=354C65bvPjF3i1kcqCpygsKJwJ/HUCRMp6MPAidxgoI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r27eNEsgfjntCCajF+dXVdQZUWZFbywXhb0U9gcJrpEDAEjA8bXUKv2YfiTlfaL+n
	 r5IwOr6WD5aa9wuxvxdKiBnAfYa7Jo1MgICGPG/QjpjQQgSyEg6k6eAwbsQhdC03pt
	 TZb/1IlBr/l6YRrz8+0IQCqBqg2H/VIWs6zDY8bw8Sonc/bMy0oV2k83ZsgMy57zU5
	 lJXB5GKnXD5T0lUSQE2PuJVgki8mwEAST0aH/B7h9FNXXa10t01NON9Cb6L70gDAD4
	 nIvDihMB1suMPRXjbaf/nxMCG3VNWrGBcRC+HuaID1ozdqPMcrK+rLA3tr3g1CT+Hc
	 sQsNvkrmLQLEg==
Message-ID: <05d4df12-f9df-44e4-8df6-04518bb679cf@kernel.org>
Date: Thu, 26 Feb 2026 11:06:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: drop duplicate kernel-doc for ksize()
Content-Language: en-US
To: Sanjay Chitroda <sanjayembeddedse@gmail.com>,
 Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260226054712.3610744-1-sanjayembedded@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260226054712.3610744-1-sanjayembedded@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Stat-Signature: 533qwp4siddfottftz4e98uaxsjnj4ce
X-Rspamd-Queue-Id: 45D3C180004
X-Rspam-User: 
X-HE-Tag: 1772100417-713025
X-HE-Meta: U2FsdGVkX19J9QmsgFYqyd5YG0IeFvn9oVMnzQ25ci6gVMx0USmrxKc7C0SQW6VdNUKr93wei/zKYPgwAlvdyQSig0s/mnAOhAwwg4E7NcOla4Si/sqwk5DFcZWsxV6DqqD/ToXAM0/BIP0WjHrEXLNO+KyECwZbU/jFfAgiccWgfVrSzjmuSpjEyfeZdo6UNLjqtrsKY5uYoI1iydu0OD9AFYfzkcpW7mkzwaUK6q61f+RRPEP7N7iiwJBzoNoJcQsW1zeaAnbVB2GonAqin8bctZGma0QusDMJZU4ybqcQmbwCnrHCN/3pmeS/BbGTlWIhkvW3yY5gw71kEFYkRLM34sxG6xzjjgnVtfC/9xw21elbJjzhwG+3+do+DUhPxqVeLx2+CzTKjrwQm80kwnv6Fv9gbk9u/B7SH24/BqInieXMlb4AeVEaAPZSN6LZMrkEh2xnlvmpNz0eYVwjlLbVdH0wI5VlXl/6FyJk63tHPl9l4qv9G3TKKQ6asKwIQGG7fbQlhIoPw/rkRvwkAwKVLGsIQQ/VYWBt5pOJIuv+6PUKMP+KxNwMM/d+qcEvrwrZpql+eGdrTttPnHdzD13jjXNBptKksKNDj+gXgmffXC7dmzdbhHz9shx0E+KQwx+wH1m8l1RB0FY7xxZith52Y7UwmCzGLoq0SI20LhfW5AqDjpMdlh5xo8q/vUU9pd65+e8FYO6r1vaxCXmtu6+yPKz8PtQHavoxY6NBYX9AFW2W00j4x2yw945Y3u/E+4ciKNj9t3YCZ/dAQCu44/vcoC7lcynXRTY/8T4HF8qy75r4jpljgl1N3EErw39tH+kJRLRPDZVhpVTUV1ok6BSIKyiQG2aDkedecsJua9tgxGHJchY6bGeTnaIbouMRSfhB1wXw0vwdQ3cg9mozXaBj0fjOsg5WFA8cY+97SQq2y11aEU7Jc3MIxvE5GRYejGfH8dWfJWR38lHWK/z
 G4qdRjvz
 0+skg4OiUjL/ZZHWyZbWMJR84GxtqLm0VIy5RKjSH8OvDi8lwv4T9ZWVnuj7RFaa5zvjB9J+cF/54/3zZdRc4uyZSqhmHKjX2siLMcMzOQhZ7dPS3iEaeVuKwqOeSM8g7qMP9hEXxY+g1WFH/CAPoSih/zm0rPvA8/XKdLeYuP3WhaqBiT+ymqulR2JtIZ8b8S4MGt3l/ds7JtNn0vdqoi4CcUCOKoLdnuYYnUPOas3v8Ae+AGHXh1UEm7+ySwWumoR7dCsYJzZH1MFtk0+xetGxOH9s8wdaYuLmu9+Z3gIbQ2rU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 06:47, Sanjay Chitroda wrote:
> From: Sanjay Chitroda <sanjayembeddedse@gmail.com>
> 
> The implementation of ksize() was updated with kernel-doc by commit
> fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
> However, the public header still contains a kernel-doc comment
> attached to the ksize() prototype.
> 
> Having documentation both in the header and next to the implementation
> causes Sphinx to treat the function as being documented twice,
> resulting in the warning:
> 
>   WARNING: Duplicate C declaration, also defined at core-api/mm-api:521
>   Declaration is '.. c:function:: size_t ksize(const void *objp)'
> 
> Kernel-doc guidelines recommend keeping the documentation with the
> function implementation. Therefore remove the redundant kernel-doc
> block from include/linux/slab.h so that the implementation in slub.c
> remains the canonical source for documentation.
> 
> No functional change.
> 
> Fixes: fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
> Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>

Thanks, added to slab/for-next-fixes

> ---
> Changes in v2:
>  - Instead of removing the doc comment from slub.c, remove it from the
>    public header as suggested by reviewers.
>  - Follow the guideline that kernel-doc should stay with the implementation.
>  - Updated commit message accordingly.
>  - Link to v1 https://lore.kernel.org/all/20260220124243.3264133-1-sanjayembedded@gmail.com/
> ---
>  include/linux/slab.h | 12 ------------
>  1 file changed, 12 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index c5fde8740281..1c8c53b068b6 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -517,18 +517,6 @@ void kfree_sensitive(const void *objp);
>  DEFINE_FREE(kfree, void *, if (!IS_ERR_OR_NULL(_T)) kfree(_T))
>  DEFINE_FREE(kfree_sensitive, void *, if (_T) kfree_sensitive(_T))
>  
> -/**
> - * ksize - Report actual allocation size of associated object
> - *
> - * @objp: Pointer returned from a prior kmalloc()-family allocation.
> - *
> - * This should not be used for writing beyond the originally requested
> - * allocation size. Either use krealloc() or round up the allocation size
> - * with kmalloc_size_roundup() prior to allocation. If this is used to
> - * access beyond the originally requested allocation size, UBSAN_BOUNDS
> - * and/or FORTIFY_SOURCE may trip, since they only know about the
> - * originally allocated size via the __alloc_size attribute.
> - */
>  size_t ksize(const void *objp);
>  
>  #ifdef CONFIG_PRINTK


