Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28241CCD183
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 14:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2DD78E0003; Sun, 19 Oct 2025 10:25:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE578E0002; Sun, 19 Oct 2025 10:25:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCC48E0003; Sun, 19 Oct 2025 10:25:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C92818E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 10:25:28 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AD3C1A0646
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 14:25:28 +0000 (UTC)
X-FDA: 84015086736.09.7E2A488
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8A7782000D
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 14:25:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKpuBT2f;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760883926; a=rsa-sha256;
	cv=none;
	b=OvgS25TLeNhiEqPXmWySmDy/2NxCpZOA9SoSjiIbxSmtzjGQeuMXzZ350QpCjfTKtikos+
	+k/jxQNH7HMkSMlZu0WrUCSIGRoJciZfFt4L3AhnM0jTN2CiVAjbOwM1by3qZQoeXoE8PQ
	Z3E5TAqhpjmuRPQgAUx4P8vZDOcYFgk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XKpuBT2f;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760883926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/lZE72x8w9lJWNgcSmo4DpV2pLuTynNe+ceIOBiIJY=;
	b=DunA2w6kTVmix9Qlc2VvXJhtAq5rJY7VDcyVV8tKuZjMcN8L9/p9bBot6cu2E0XRFLPhty
	uOUUEJSYOegp7ozVd4xnGQkCP6BJMfzIc04dL9WNV60IYlPtsgQHsxRjItaTao/f53HPJb
	q2ZcB1uLmn/HEtXK3eKVRCljpkHGxh4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 34808409E4;
	Sun, 19 Oct 2025 14:25:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343D1C4CEE7;
	Sun, 19 Oct 2025 14:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760883925;
	bh=oHOlqf0ywPUIIQS7WIZUje1x82l1+22hMmrNrvGvwGw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XKpuBT2f9kk33TvypeW9ldST7Hx+ke6eyMKL7CXXKkBNYCFVsMsYMIlidiWX0yD+1
	 fURdxuvGxYJBAN2NpLvaJr3Rbf4WCCjghI3WS9xfmbhr7/csh2qannr6Vg8g8TbFnq
	 o+p6Dx+xUgKLMik70ES3zq57BBhVOhBg/KcCrIaYubdEkSk8o/ulb8ZxOcBrNge6R3
	 5feDRZ0+u/Iu8j+Fp7FtaXtH2YBD6u1EfdtTTTqRCRGv9huCTAyV4mOfor++d06TtO
	 fUy2SaejLi7EVR1NgTRBQYhld3G3WZYHARe5OVXFrvuOCC1+gtz4zvL8KCV3VArjas
	 BzYecLrFNq3rQ==
Date: Sun, 19 Oct 2025 17:25:16 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	David Hildenbrand <david@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Julia Lawall <Julia.Lawall@inria.fr>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
Message-ID: <aPT0zNMZqt89cIXH@kernel.org>
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPQxN7-FeFB6vTuv@casper.infradead.org>
X-Rspam-User: 
X-Stat-Signature: 8jezzzsiztfaugtq4796uq4ts9hwn9fd
X-Rspamd-Queue-Id: 8A7782000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1760883926-880144
X-HE-Meta: U2FsdGVkX190kdZKIlyU34VEY9OgczRMCZlXdJEiS3b3ZL7Z9XZYRkGh9RbiJB6v0rig11ZK37eoW73Mw/mmIE/yfbyqdQnXHZkj2FaAXJjuizByB8SiDNtpIEnMiWjZC3gOdB94nNuaDqxZmRbOOTdsE9o5oI2Nue5f6bkU/LDaisHjiKbNnWXf5oQ1mOVFfl88ochORIBUEf/piwzXPmU6368QUvpu0CyRdaU+UF/CEX4F2rJWfQIm5Dz/CyJ3ssXoDD4iPMlz5H29FBKIyOxRoifnF0eM7HQ7dDSAF3t5QTmGfivxNdQke0/WFdKRdIw6A6JiVtFz5k11/XEqZj1puBNyytitOWqAwUpag+CeD05t1oA++LQg/4omll1yJARWI2zddbsSksB7QlZqDusBrdFePDVDxUkXfjiBucpuyB3neLZYJ6OPqBd1/eS/y5rCPkxcAi73gQzhLzEPNDymx4FoXoiMn6lvpzWZ/3KFAM29VTzKlJ3t1T+H7n0lbA6irhFYrN99iy7OuQ59aQdjbxqheS8Jm3TArCT9oFQMFOBj+1X5CgGPZg8K7l1m51k92f6bXCYnYBGyONJmd+N5XpnVA8ri5tej/q1UPfhFsx5zK9edJ6Zl0BPNEttUH2ARCuigpu4Il8ShQQEsSGC5jSGPOVNW/ug+MnVC3oaXsM3kxAZJSzRf+q22RWaG54mgdzStfkeBSiK2Ze00zxrZJAh8I9coSXTG8Y86sgVtCCvx6z0DEUo8vyKWuDxtDjzt8SxtqBa+Ws2sCA0o/faPLpp14sKrstMzqn99emLjq8cl+K8v9VyXuaCJgo4nuA3DkMAxEiJdSo2lv9IZEsEh/Uq2URPGBqg/P+DAutz+5A1uojDJkHiDCHxmcFZdIyoUj/wdDk0lKXbRfnFgkSM7Aa23Q9JAMmtFA/meYXbqSrXuxQWlQns1BoafwJphzBKn4/Re7bZk2tTFCOU
 LLV9G03j
 y9872mUhzzLT/WJd/annG6/aTTDWD65vJl3tXBlBbMyZDkTXlfW/OQFIjFz4gHCJpTOooEyevAXsgUOh5dCk0hd+D8E/3gyWLSwUs3gmCmG9urMSl33CIXUDGbfrew5Nal7stelP3t+PZdFCq7Y7lX5hUJlBLP+fDzgOlZnFphmt5oVu4zQksw/jGFKJOMuuGT7q6/PhGGblXKrTHaRfZeIjERNSTgIndltEfEen290UrnUoiZuurzv+yIkVjeQtVwi8/6bEmGH8/nyOdCptEemgPwow0fX9G8fKI75F8Tx0uslM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 01:30:47AM +0100, Matthew Wilcox wrote:
> On Sat, Oct 18, 2025 at 12:29:59PM +0300, Mike Rapoport wrote:
> > Vast majority of allocations that use get_free_pages() and its derivatives
> > cast the returned unsigned long to a pointer and then cast it back to
> > unsigned long when freeing the memory.
> > 
> > These castings are useless and only obfuscate the code.
> > 
> > Make get_free_pages() and friends return 'void *' and free_pages() accept
> > 'void *' as its address parameter.
> 
> No.  Linus has rejected this change before.  I can't find it now, it was
> a long time ago. 

If it was a long time ago, he might not object it now.

> Most of them shouldn't be using get_free_pages() at all, they should be
> using kmalloc().

Don't know if most but some of them could. Still, we'd have a bunch of
get_free_pages() users with needless castings.
And converting callers that should use kmalloc() is a long and tedious
process, while here we get an API improvement in a single automated change.

-- 
Sincerely yours,
Mike.

