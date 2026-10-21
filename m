Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2847606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 00:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=exUnIpcg
Received: by kanga.kvack.org (Postfix)
	id 99B096B058A; Tue, 20 Oct 2026 20:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973796B058C; Tue, 20 Oct 2026 20:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887B16B058D; Tue, 20 Oct 2026 20:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6637C6B058A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 20:12:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD1411203F6
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:12:17 +0000 (UTC)
X-FDA: 85344706314.23.16DF7B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 43CDF20006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 00:12:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exUnIpcg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792541536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cOxbniIZrsE6Og7OO2rhA2lJPg4qjRGzVzOR2aSt5t0=;
	b=SlRZom7+R2wNDxdFRXjEkoQGiYbk+dHsH0UtPOxJB+HmGBmCrQEAvXnvQxTZZrZG+rb1V7
	ac9lQoibTo3LI6KteeM04YyHrFrEGRia5twOrWIxBKfTIHpf2hl4bVKosN4sxP1a6q5aVv
	zcZbDRep00SWhbNoCFaWkUeKrDN4/uY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=exUnIpcg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792541536;
	b=QFNYrBpvd1VnOSIVg7PFQIppZadFW7/qIhQe8BfWwvZDc+ZZKM+0FjQgloPbE6Sl8Hs6ar
	bPvPUYIDsmKyENRM603V5oRG1x3KRFd1YjhugKha850yGhgil3yEsoEkdLj+qrqkQcB6Ae
	Bd7jJAQR12skOYQMpq+7cF0EltAPcO0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDE4060098;
	Wed, 21 Oct 2026 00:12:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B731F000C9;
	Wed, 21 Oct 2026 00:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792541535;
	bh=cOxbniIZrsE6Og7OO2rhA2lJPg4qjRGzVzOR2aSt5t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exUnIpcgy8YrF3HQV1sjeuWXOi/pQ7hYlvdW4SH44TO/9Wz91OVgCaRDtpuW7cwKi
	 mt83i9iLn7TQ8rlR1BqaaUJj7yj43EyTZwDbmxgRDQpRmISrS9WpeFuPXI/ArtavIH
	 dYEWmu5pMBvpj4F7yOkvbZHUI7/vn++z9ZhnmoWwI0cO+MjAIS7K9fD38UY50hMwRc
	 TZFUOGg4b3lnt4kF9YX+dTrElDQx50MnVoaEbHRUKua2GnoElNDvMrrpX6WhyUN/mm
	 fYSxU61fqAJZ0/ssxPy3emvmND4VWvlzDf67iGRMGBHy7DyV8rHZjRZo6xmvuvcmpH
	 CGcsdZUEKekMQ==
From: SJ Park <sj@kernel.org>
To: "Liam R. Howlett (Google)" <liam@infradead.org>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/testing/shared: catch a failed posix_memalign()
Date: Tue, 20 Oct 2026 17:12:07 -0700
Message-ID: <20261021001208.93708-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261020033128.1934349-1-liam@infradead.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 43CDF20006
X-Stat-Signature: 4cjt9jybfj5w38k1czki1jymr3wxkqin
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792541536-19025
X-HE-Meta: U2FsdGVkX18ITYXkXhBFqhA+9lEJSd9tarhEwvPSakx7fzL+lMPIuLQ3pqsHadXwkWDIW0I0UkorEliEhBgF6cOkKF6B/0oTMvOiTGtHlMC7+YIZqq1hNFl2dXkBMRY735PMmAaU9PQPZTbAQlnm+9ivQZuzQIu0tEe9yzRz96zR4iMDaPQf74Hqc7TB9JXI+MmZr66nVOV589BHybVTuUKIvwrkneEAsAuHasGaIoGh7MLGJWw0FukqfAi5LI+d8+vcr4aBrRPLaq23sdQd4Sj2i1uITamlKCNypGUYdMj53IN2IoZcOeqqkuGmuK+GH+L5zYVXl+8B5Y6H6a8x4eKqKrlAJS3wdVpwkwospHA6MAl3CFS80EHniMcJB8+cw+57wrBPuUR28mW9Oe1917DKUCyhszuo/fkcggjwqS1nnFg5u5PurrJ6PAmP/XSix6mXfwgBIOWqzmN8D1/QJIJWm4o3AXTq8kxPumpq3zN3Lg1krPbLB/qwvTGMSbHg+ALJzhMurSj5z/HWCBWbVUHuznlR94mKZa+dMSjTt7U3/6h0vZaw87+JcFI8H+ZCJBSUcixXd/hhEov/s/R2dSi9eeHc3TPx5YeJlgNCgSMwK0MvA/d/YiXk9ktYp0w6i6pY+dV3OrzbwoNQSn0R+SsRLGbVbwA6zTfXvjtJ8mjvwpjnW4tIF15dETtsIlAXiXTnsnFYOGAUluYRwL2jLJHv/qURQOTfBldYcJRNdf5+M5cq2ikJ6IE8vuDt1b9fmZvUf63B4VYhUMqRl9phXwA/UP0mmJk34Sua3gVoZ0mEaT3gSW92c/tlY1nziR8jJMEFe+1yNTxIFFa+cufXlP9WxDCyoQ93Vx6KDtfeN6/ZG63EVzXf1+iR7Hzu2sWEisSTKxjDk9pncXx8kEBOPQcn8Oftx1OYRDM0YnrisJMHR3vyvNMM4VVJ0KTeJLvCQo01Q2iP7yTt56GU5wX
 pSMnivyD
 1/worVmoqmRD0lWkQzZrPZRlE7+/jD/psv1I5SiXVC9zVtAHvefp8SYc4sjhJhi/VV3UlpTBk9ElbbiIJkchVdJDO5Ra1nIWjNP7A1gABir+i4l7nu9nt7aTBt6JQH2zur2fg6FqjESUIp/3A05mchWCC+/RPqxAzvaj8nb6raS+zCy1JNniTMERVQm++x7hFw82OoCzwMVSH5Lvrz43JzD+9S+OT3feK56L6V28dUwcmFcHafkju8KiOA39A2yb1ooWUsQ1nPRRb0vzCuAddPZSifShRaLWzg51PNeVSpl+b+AAuQYwRHSSmZms/esTUoa6MWElOde6jalhBEMnWd6dapw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 19 Oct 2026 23:31:28 -0400 "Liam R. Howlett (Google)" <liam@infradead.org> wrote:

> posix_memalign() returns zero or a positive error number and never sets
> errno, so the checks for a negative return in kmem_cache_alloc_lru() and
> kmem_cache_alloc_bulk() is not possible.  A failed aligned allocation
> carries on with the pointer unset, into the constructor or the memset().
> 
> Test for any non-zero return.

Nice catch, makes sense to me.

> 
> Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

