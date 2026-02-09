Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56273E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 18:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361686B0088; Mon,  9 Feb 2026 13:34:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5276B0089; Mon,  9 Feb 2026 13:34:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1846B008A; Mon,  9 Feb 2026 13:34:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4116B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 13:34:24 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A5A608A249
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:34:23 +0000 (UTC)
X-FDA: 84425768406.25.B3AFD60
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9D724A000B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:34:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770662062; a=rsa-sha256;
	cv=none;
	b=wO6sIaBwQ38a1YFAAGqIVS9hgH106jjG54jt+17sreujDM91ACR0DG6Vn/gdv/lKwcOBEH
	BspGup7yHE+x1RyHDoRcXZktJvczwyAMqhic3t2WE/xYuWwpuAC4vfxFspdjdxuRjINq3+
	et3Gsbl0JKfpYeUSIwq+UlpaNgNPRR8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770662062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Rn3jn/MP9VZpAJet5D9g5sCiSUWEPguYRGjUqBuNhyI=;
	b=LQuYPgEzW3lmimCmmUozbmiMoHgLHcWcqqXGS7ePnHlIrAVPULAaCxHkKCLqdgcSCJJrtv
	qJpPXnFKy7fGIqKuzqVf4N98EJDbl/2syf6ffptg1dPv2Uf+yFdhwvX3uSKyWOZEtYEkwV
	cZgcFQNAN7km3WbIhc29TM2r/Y6nCXA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4B01A339;
	Mon,  9 Feb 2026 10:34:14 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B28E3F63F;
	Mon,  9 Feb 2026 10:34:19 -0800 (PST)
Date: Mon, 9 Feb 2026 18:34:16 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/slab: allow freeing kmalloc_nolock()'d objects
 using kfree[_rcu]()
Message-ID: <aYooqPNGEf3On-W_@arm.com>
References: <20260209121013.50475-1-harry.yoo@oracle.com>
 <20260209121013.50475-2-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209121013.50475-2-harry.yoo@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9D724A000B
X-Stat-Signature: m9zqo18wjqy4838wagiqyzjrcnqb6bgr
X-HE-Tag: 1770662061-996401
X-HE-Meta: U2FsdGVkX19ZqsSVu6qjbFl49rwLfWzXQO0rgRJ49uSAzZnWqGnNnszJjwPDuXccCf25HUxA+V5o+X3//ZBVte8wCZKXqOQLZRj0UaZttaL/s4GSwD43STTg2EoM5FXIYktyBSlhbirS6XIBe6eSgdXZoNSpDqonTsdCBM2xLxUOF29RL6CuzVgU70z8cuDp5YwOa2p9y10x3JRXJF7CM8t66cjCSqwkhDkaxZjCINZmHvTTUDFGksidX/mD5UYHP3OxwjE+i8aJXst7qwttx06KjWSSW8ZyfoZGfjz7d4+IoORbOPck0SvlMUuz1PR6rh8AwypNxZtEj8kxwwl+OXRvh26T3xGbyXY2R5aef38wdoptd9E0E6laUb4448HWGjOWEvOEpPvYpxeMCtEPfz5LvhgZbUuHnGmS24ln0CJgBa+s3BZ5VgcR3HGxjMfgFj9fXO/nc2Sg4IirtZQ48losDIyrV2pRCNP3+ZfYeB1OylPfiXawyb+PBONB1o30ryExz0MXJJtGGsIk5uGxPjEaBR4fgR98YN/0V24YJ7l5oW+UxWBaimmNVlU1IgfJl9JT7QDjsSgxsk9cosi25kIAwM2TbL9I1Bn/m0j1MAr6wdpY+XZlMZNA1TCzJFeX+K89wrvH35e4HKkXUYhpbUuu9pYlEPW6C2v7epW0r9i6Yq6qvuI40WqgYeNjxqoxmjaF8cARZLaIA1dPUtJO0fRa9xE/kY1DLEBdezhRka7d+gLNjkDO2cu2qzf+4nm8itmhylF8Y03segjM2Ul4DF1TS6RXZ5E7PnAWX/kuh/g+gzlPWQcxQun71FvL/pUi30/uegYg6mLLjCgp5rvMN5YtHUBN3N6eLXeIi80Y3hYA/bNrilBlgPFNbS1IJtvlyatThPh3AVzQGXVckquhztXu1DPUL2oKkYmF+tyMFkSvNMhMODURmQcVTAlvz7mjtj1YB5vBgDjGyDk8pQW
 ZWy7aIEs
 USDQuV38h8KahkIKpkoU2+Em8KT0OURTSW0mInmAun08D4dEkeGj096PzFw93xqz03VpEi5/uKlHO/sOwl8M+TtTGjP2k3tZrUVXevFWSwSFKem3cjL8JPB6gNCQX5evEyKxyqVbO2MYJDl2daLKAToq+8D19v7VqC6lwMz7LPxM5MPp0Y8l00AZNHd2JVAZsPH4NY9md7KmJ5tNgccDgjl8MJESX2s24w5fLW2eTPFJdEM8zxiNe1Ha8P6N3B8wHNDtfDnl2hFV/XHxT65O6qoeFo7WIL6db50is
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 09:10:12PM +0900, Harry Yoo wrote:
> Slab objects that are allocated with kmalloc_nolock() must be freed
> using kfree_nolock() because only a subset of alloc hooks are called,
> since kmalloc_nolock() can't spin on a lock during allocation.
> 
> This imposes a limitation: such objects cannot be freed with kfree_rcu(),
> forcing users to work around this limitation by calling call_rcu()
> with a callback that frees the object using kfree_nolock().
> 
> Remove this limitation by teaching kmemleak to gracefully ignore cases
> when kmemleak_free() or kmemleak_ignore() (called by kvfree_call_rcu())
> is called without a prior kmemleak_alloc().
> 
> Unlike kmemleak, kfence already handles this case, because,
> due to its design, only a subset of allocations are served from kfence.
> 
> With this change, kfree() and kfree_rcu() can be used to free objects
> that are allocated using kmalloc_nolock().
> 
> Suggested-by: Alexei Starovoitov <ast@kernel.org>
> Acked-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

It looks fine to me. The alternative would have been to track objects
allocated by kmalloc_nolock() but that's not (easily) possible without
taking more locks in kmemleak.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

