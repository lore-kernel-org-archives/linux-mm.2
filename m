Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0282CC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 09:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EE96B007B; Fri, 24 Jul 2026 05:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0FD56B0088; Fri, 24 Jul 2026 05:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25B96B008A; Fri, 24 Jul 2026 05:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A8E456B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 05:57:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BED612030A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:57:40 +0000 (UTC)
X-FDA: 85023218280.19.EC0252D
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7260E20003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:57:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LxqBLyNF;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784887058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtzI0WrHpPQ8NxhzSfdbFVkPslhXcvXb+1WfK67Ct6A=;
	b=eARBNkQEFLq3MYCv/OCAyowMUck3E2gDUm9WxDFKhvwOSRtkPK4ZtTMlx4oMoxtUJLlLSi
	IRTOoOC61hLfsYuwjqirIHu0koc1KAspGe8IGe9eUI29jxpxtjUuNFA3CbG4nEtbwQM89i
	bLyy1O39Jj8jzTvaaXYOBOGwvGxSopY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784887058;
	b=EZTtqY5qEgNc6d5DrzywbMP0UCgz9Hgha2nF3VW0s5oEpVMeYBZ1s/Kq7JYBEu3N9P9L/A
	OZivQ3YYmcwaGqDnwSi3PQf7+HFnOoLwZku/ZoEbMV9wS6qUXoRnuST3iEas6MAMLy6nIT
	wKn+pacDBHpjDBS7/TjXBDg493mXRic=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LxqBLyNF;
	spf=pass (imf31.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 24 Jul 2026 17:57:15 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784887056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gtzI0WrHpPQ8NxhzSfdbFVkPslhXcvXb+1WfK67Ct6A=;
	b=LxqBLyNFCuRzvSTEZvQ+k7G4esSrSkIg3NL0E6nP9CWPApkKEhtzDaDQM/QTeJLcnFBqVl
	oHxoQs49THjbvWSHHm3yBfJq52vZKB1Sr2HHwBpnppRGMGUcmb7Xm6Swk5s6TktpmIskll
	agvkNhLDpxuI1IL7m2PtL80iYRQxKYM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 13/13] mm/slab: stop allocating objcg pointers when
 unnecessary
Message-ID: <amM2ybmTYfjlvDV7@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-13-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720-b4-objext_split-v2-13-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7260E20003
X-Stat-Signature: 7hmqn94uqgxfjzfiru595bq9794pdzbi
X-HE-Tag: 1784887058-163928
X-HE-Meta: U2FsdGVkX19wY/mTOojvZ7z2OPirwQTJuwvirmd94wk4z8vNPogyRiqGk08pHrUWD9foWb68VmBW5cvL4Vv2KUSv9YcViLI+JqPWXXR14t0+r/nbIrmK8DHiULBP+2WDWn2Lx+7vzmWapld3VszQCQAwY4sGhi7tTG0ZcYH6L8KtGvxuNLKWnMyxWn3m72HE1lVYnoVzzUgo080KZqhAIRGcbvH/pEU2epHIYZqK4fNujUAl9Feb2+/tKMkHpMVmJjKRBAXxSQf71U7Pcn3sTdsPhWFF/mlUK0g5+6jTCTFekdKksX9pZTx4pWWuHnQ3/ypu5gZQsQrOnKSJ8gVBOzF/hpEzIpkllej5xlcloAXXPmqEeZEpOIToEdgHdhqdOKOybNM3AWVOuMzKxRSKffIOmtCHt0V5S0eNJ9jwycfX95jS0GOvmr1juM8rYpFzAm6ZSlTWTcY+svqZZtvdqULv/M/qKzE5NUp+sJzbd/MUtyWd7N1Q5WpBAXHvkjVV/R5Vl0DGkI39svoHpG6Buh5P/3Pq1ie/FYtfeyFhSpJ/GN4oHjA1AiqrP7sEzOBSa2XQwTCzP3B4qYxkUxsP+M27EMWX3sHQIePBDT6jq23oR7Y5ggYwv0k23pvUylSCSFMN0Vie8Jf06FC4NAWtunFB9P6acfuzxbM+XumgKb+hXogo5BZc3w/3cW4V80+WrT9iThJJzO5OgORXosvZyVIWe9s3A9sKakC+LVyCv//votfoq3fceS4bzI47zxmrhscwlBDP5rAs09i7IGhjfrw3Zo/IGVQ5kniqJMZt1GFWhq1IWTGmlcwpzCjysKqodQ3OE7T6oW/P3XttWSZrQ75OMUs4ro8HI7auejplboNe54I3EHBLW5dhG8XzUIwZCc6IL2n5hPbXvgkMmjTlIN1mw/orMuloV7fJHiVjTQK6X0L4nEac5fmBYRkF4Dfm3Of4QekTgdYPWa0O8KB
 FDzMsiSa
 h1VhA1sbvlN3wPrJhbNACnhUCzLRKuMJ/0itzxL9ec1zasMVdL++VAjkgTeT/53ENlcGvk5ZJP0+Tgs3dxrunM+/70ZS+DNVGycaraChmuOYappG9Bvldl+N8m7oN+qHbae5TaFq26/Gu16dzG9crt5BEsOa97ETfIjoOJiNzVVfeJTbzWHqRx+CuCaLGCngUqRw4m0lz8EvZpIzIn9ECfMGgyOzzx+R/KhIoq0sXHB6asBxMtlWVp/8UzavHwLsevINjmy8ivWjwodkZxypeBBQcFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:27PM +0200, Vlastimil Babka (SUSE) wrote:
> Start using the slab_needs_objcg() helper to calculate slabobj_ext size.
> Caches that we know to never need objcg pointers (currently
> KMALLOC_NORMAL caches) will thus stop wasting memory on them when memory
> allocation profiling is enabled.
> 
> For things to work properly, we need to also add slab_needs_objcg()
> checks to mem_cgroup_from_obj_slab() and memcg_slab_free_hook(), because
> when obj_exts array exists for a slab only due to mem_alloc profiling,
> we would otherwise attempt to access a non-existing objcg pointer in
> that slab.
> 
> The function __memcg_slab_post_alloc_hook() should not be possible to
> call for a slab where slab_needs_objcg() is false, but add a DEBUG_VM
> check there to prevent breaking this assumption accidentally.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

