Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B82B7606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cBplRVlN
Received: by kanga.kvack.org (Postfix)
	id D62446B05BB; Wed,  4 Nov 2026 08:42:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13F26B05BC; Wed,  4 Nov 2026 08:42:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C503F6B05BD; Wed,  4 Nov 2026 08:42:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A48D06B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:42:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3459DA0715
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:42:38 +0000 (UTC)
X-FDA: 85397551596.19.3F73E21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9999BA000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:42:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBplRVlN;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793799756;
	b=mkCxK2CuWVqA0pehKdlfcvepqrIs+5MHpYbi9WoFEa6L69bHDvhWEEpHJX+CHbq2Rzq/s1
	z+ePeURMKKxrU8YHMhBdUoqA+SmR5aJGppgqPU0RKA3CHxbbNsmrHowVhq4PpynUdPRgDg
	iZPJ9HRBpoedb2f8s3H+ChE8ZaVkZuE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBplRVlN;
	spf=pass (imf25.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793799756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Esj8EGtkHfwSQcmc9iE2KqgGId8com+XiT/w2XhO/5w=;
	b=oXG+H9V0g7PUUHfqrp/rcYTKxyDEwzGrsEkEQcmLDWL2xyvKWSTYx9vBoctVpH7WUpN/Mh
	TIe0AYmO3TdbxFiCDeKY846IO+Lf0ER/7jt4BBH02HYtAXHFMgnG+4Jp2f1EpdeJl4v/K7
	6r+bzz2r8z0w44X04TKzwjD6NhtZ2Nk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAC5C41503;
	Wed,  4 Nov 2026 13:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C011F00A18;
	Wed,  4 Nov 2026 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793799755;
	bh=Esj8EGtkHfwSQcmc9iE2KqgGId8com+XiT/w2XhO/5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cBplRVlNGNXLgcOgO/+NzbxXf7EoY8ccfzz17hLNIISFlErjsDDUxP0r4++GlxKZ0
	 H2LWcO/wR6CNfnZ57fCbZiuucD+u6e3qjQjdbaMMZdgYskVj6G9DOl6VWGND9+QiEL
	 pFnUzmZgJ2HhcuhmC0/n1pUCgQnPKTJARsJ+broVwfYvKznB380+kfP7vESDq/m7My
	 ryQxu1NibOQv+aePOWlK0T0z+qrAITNvbGZwOeQeJms2fAvu2yfulKwl4elPSj5A77
	 YDusCrCkH7AjPYQLm0dZU0F8U/PnKW7y/A90IQUnrKZpyk2+TbGoMMepZcTAOiDtGf
	 IcNB86vyc/ZBw==
Date: Wed, 4 Nov 2026 14:42:30 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 11/12] mm: hugetlb_vmemmap: unify vmemmap range
 restoration
Message-ID: <aus2Ro4lqS3FaPPL@localhost.localdomain>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-12-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104023510.260766-12-songmuchun@bytedance.com>
X-Stat-Signature: h88xmuhbbc9onndmkm9rhers5yko5yiy
X-Rspamd-Queue-Id: 9999BA000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793799756-850371
X-HE-Meta: U2FsdGVkX19oqMNd36lyWd593Q2mWDsMqKWjO2h7dBa+OFLVTQuVUYz89JCNjMaXk7xLkQaIUsb8Zl2xgaLE77Dlvl2ScJE9agxZTYukb2ZGROC0eCcQh6EvQH6qL8ojSjSuPDsT0yXoO4LlbcgB7reitv99lkDMQpmMxpwyhKE/QcrvxCIN6imIBgLENzeN/7v6lOZcU1VGlW2wwDk2IKQYBtcc+RjpN/yf8jfooTSSS9OedXIY7CYObnbXT06r94o3Ej5eux0P6eXISdcGhm3UbtaoyNqgeYFcpHaMoW6k9fYgL/f578TE2AuoMHgtQWq53VIw7g6eyLoebilO1lezImOFdSApVoPMjCOCIacGia/GHdC9oUVV3okYr1pf/AmPeJnNk0SijYAMd456hNhgseQBlpUWGGjNZf1RG0jWAOChAHFxpAp14k/gVdYZ4PnKFANaDofn74AEJYqeCFnmwbEp8r0lNDqhPt+9CYzSGwxhy24EXmeKxzIGQO/SaQzk6SD7UBO5aV3hD1miQs34Ft0k1txoHMEVPhvtYaelBe9ooO7hYnE0u4W6WGGUKUDWcnxSSubxgA90oD3k7YlAyXBfsnAoYdJy2OlrYrG5gOrGCMBxOZzVuav+0UFNDoHxKkSpWIvszXq26zEQxWcPn/zzgmxfSteiiXrPjpIB8dAxteUJWkOpv/R0zK+fSant2MWOqA1LIEfM6BPhvPvzHsK8bBd8KeJkbll1ZDGS6MGIVViwt9HnUWVaKinE8vkn+czzwc41ZG+vLHHrg/nh7/vRVZFw3ITDHaKW+z/RR5416J31csSoRyP18xHIJJXqnfn+K1ciOUZK+ofR8eRILMlEqCHaDmSxZ6sFMFoxcdx16BMsRH5SdX74jIiBDbFO06YbzQelgUGcdC27o++p2SdqmnA8Nl3qioT1Bjy+g31gfhDLkxWvg1NjnKdt0Zhlscq+LGN7RrsBDzv
 rn1RpLlN
 O8H6RSwiHkvydalJt7xM/WTy1syt5JDEYPonGPwLJkKQjhFUS/jjhTHPwGZdC+9XBhCViYA9WRYMsZmSwD3938AImkqDdTOl9od1GGt9JlUTEIrxMbavhQAeaBv+VLKKeBcZhSq1ZQ0/bjjDjcQ+hnk6pb39U5ifjrNducUM2RyvTX7nX73mz9kbjPzYma+T8PhMEDeER9I9Og+9DqEL9CYw5DVoIYE2O2qcNfLQYspwMZ2nCBMDbjkUiMpFJrSEOBji35DwgeEExn5L7586cbI6LSj5MBuk+6JcXR0JoMcbMtxqNGzf+WtINKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 10:35:09AM +0800, Muchun Song wrote:
> Restoring an optimized folio and rolling back a partial optimization
> both restore a vmemmap range, but the operation is currently implemented
> separately in each path.
> 
> Use a single range-restoration path for both cases, making rollback an
> explicit bounded form of normal restoration.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE Labs

