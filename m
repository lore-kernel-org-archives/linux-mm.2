Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1415DCC6B39
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:18:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFB26B008A; Thu, 15 Oct 2026 12:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097FD6B0095; Thu, 15 Oct 2026 12:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFFE6B0099; Thu, 15 Oct 2026 12:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0FA66B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:18:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 62A1BA02FC
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:18:57 +0000 (UTC)
X-FDA: 85325369514.28.D1ACE8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C4436140007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:18:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsIquxPo;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792081135;
	b=fK2uyABoaUQab7esQap9cTyKRPAlJ0vN9Pp7kxsTORJWIwIAIco5jAG/KE4+dnNxraMA/u
	AiS7rCiwBhJEqwiCmsTenjO/bl9ZydEMIBzsL8RRB9x0xRD58y/YnkQkA2kQP/LhLtLtTU
	pZpElpaXg8BBYsYR7MCNWzttdytQBGw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hsIquxPo;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792081135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cz1oUpp56Zew9WMeuLYnFSeLe5kZDdhcep3hXyffVkg=;
	b=BsTSuBdb9TvT9VkJfjTsnxiha77dOc8Ah8ZzB+IvlxqeD7e3WDADOtdC5+90hpM7IUPZJs
	3iXu3Hp8LrQ+TAdLCL6ibAivKZh83gu04n32NNZGNp/06nQAshvTL1/vSYju4YxAtXTUlp
	fSDyd7dLlRLAkxUuEYWBVZ51LgXCRls=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 386C5601EF;
	Thu, 15 Oct 2026 16:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735571F000C4;
	Thu, 15 Oct 2026 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792081134;
	bh=cz1oUpp56Zew9WMeuLYnFSeLe5kZDdhcep3hXyffVkg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hsIquxPo3YGMGU8bVly+ySWIwCtz7VpX7N48Oe57rXA9hkwYB+4/BypRyYw31PusL
	 GqEHOuFLWjk8YwyANJlY6ps9CphdiGMDFWWD3XTLXykR7IP6zPAbBDAyYA9gL7FjGa
	 lCJmVl1nDbglKx7AJS8ow1t5SIwXLZcc16wtXLcnVPwzjL8fkgmkSQ0gbQyEdyz7uc
	 5py8cF3WvepQpTop22peaQh3M01PMEKR1/mKlhkjN3bNHCOSq1bcEM+HNiSaYY+auk
	 BhHtxqdz0usYhDsnqc2B23gp4cA+DFnF4C/LPUbMRYGYhwIfxtP8y4KwSJPYklx9EG
	 eYnilLva2gk+Q==
Date: Thu, 15 Oct 2026 17:18:52 +0100
From: Harry Yoo <harry@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shengming Hu <hu.shengming@zte.com.cn>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: initialize the free pointer of the bootstrap
 kmem_cache_node
Message-ID: <atD8CeImfP79s-9b@thinkstation>
References: <20261010203906.93156-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261010203906.93156-1-kmehltretter@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4436140007
X-Stat-Signature: w3zt7oxdjxhtjt7ccjt9f1ypdyurtidb
X-HE-Tag: 1792081135-938808
X-HE-Meta: U2FsdGVkX19L5r3XTU59ey6+MkWLC7z7mtr+mcYO6ld7xRAKa2UIPwP7bMerdOlaI+Hq8D5DzLdgmDDLvGP4oE0tVboXuitjOrTupB7DKhuKqr7UrHBpiDaTFx73TwgDMb6eBoYAM8+MzpOSqKnzF5uqLiX3Np0MrYLjFCKugVK+1u6o3JGTXDI7w1f/zkYwlyk3YOtx7ZqOguF9dIG3Is9fEYWJG9sUJAfk4438xpQ5ZpjcocyPZhrm6q2hp5YSvSkWYvnGYhcMMJb1s5i0vMrtmaWFg71Mmpj0aZj+05CTYOP1/ew+5lOwrzMVXYgFf6dJp9EcJNd7mJdeEvAOQk/dVTY5f8Ox39f4meqcIkcUQxhpvuiIGDk3nZXCU5do4i5Tvob2DdmyiD2yW/VD7uf3Lfm83Fz2GXai5atUhu80zoTeGDDZbzrpWgG/p99AGKkhkU7iD6zKLttGPoGw9Xs9vxzqOFODAcKiXAA+Tl/99YrYg845qbjLjq4Ko7ua/gpSZKeDhem1z7vLdgU0uSTq06354WC1QVeS+rf0TlEUBDIRgG+3DAbZ/emnNUwfR0PWmq1dwN6FoS8HLLtVDFGsyOTPpunHMwRT6Zg17z5GgW2QupFYVqrrhKuNHJvta53CDV5+bRXX/4Hqocp6Bku3hIOGe0kk9Ds64bSFZF16jGJfuruQqnKX73j8fi7fzvU1dWibNkEUg7xflfmHdR9+mL6jSvumH0Dh6UxnrSQLlBMdCUADzdBXdEhRH5hZDSFPBnGL/qDEgjIug4uG1C47k5vtToXgQIl6Fz1hClL0fJkl0Ed9yYd6+XGQL90dsKQW7IhfqasnFpZutEnXswoj/5NMu1D2VHYC6EeIYfET1BCu9rSfn28dHrInKuyum22mIInBcN+x7aappV/O2QNh6RMjaEtH0hYv6ZjSlBj+59bLgqiyKvunp4yNhM3Y6inug49Xiw7pqp41LP4
 CpAzQ6eh
 1LOO8dhRkiAYGPe/DdTUcF+ryFgIvxXxWGXOAWGFp19JmDN45YbaRhMYcLoGjcCm5vBNGeB+AxOagOCoa8pGSpvrsevkX26DaAX0Hppy6oJtjlxQG0ERWkq5JwXupVoi6sJfwxBbYRMUap4jVLF7So2WqtI1m4z0mM8ruyoknK2GGMcJTY2lxnknXPrgQF6OVoLgXNmmsZwKbs+RH40P0M39tnvf1QCb6VRGMTP0UvjD+C8y7uq8229xacLnUkGhdmoE91avqrwgZifwJxB+q/s825qTo5SsPE5AIE5rINd7g2xe2jKgmOEm0SrlX3cphvYGfNJAsPdvo1BppC2MIvRVwyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 10:39:06PM +0200, Karl Mehltretter wrote:
> With slub_debug=FZPU, validating kmem_cache_node reports
> 
>   BUG kmem_cache_node (Not tainted): Freepointer corrupt
>   Object 0xffff888000140040 @offset=64 fp=0x5a5a5a5a5a5a5a5a
> 
> and taints the kernel. Poisoning places the bootstrap object's free
> pointer outside the object, where check_object() checks it even while
> allocated.
> 
> early_kmem_cache_node_alloc() previously took this object from a
> freelist with an initialized pointer. It now takes it from the slab
> iterator and builds the freelist only for the remaining objects,
> leaving its pointer filled with POISON_INUSE.
> 
> Initialize the bootstrap object's free pointer to NULL.
> 
> Fixes: dc795d4c0282 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

