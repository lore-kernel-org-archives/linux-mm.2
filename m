Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B985BCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 21:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07D58E000C; Fri, 19 Sep 2025 17:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8B48E0001; Fri, 19 Sep 2025 17:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEB08E000C; Fri, 19 Sep 2025 17:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8B7D8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 17:28:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F8751608BE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:28:41 +0000 (UTC)
X-FDA: 83907289242.13.070370E
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id C4432120003
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 21:28:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v6SrtbjR;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758317320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wpUrXb0nSEj/cPg3wNxEbYpjYYIRlz3XIOQouIGdvFc=;
	b=fdMuybgk9QPMAUMa9pUrQ2l/u/Pv95Q3I6+p+yYkqEkitdwWbPJXKj/dHyEOsecKs9Nnwg
	Mrg6ZAji/MPvGz8rkgE9zaGjumnUbUTiExZI+vjsjJig43VIKBPeCrOXWDWVmcGGoDgZdt
	xvkyrei7pIdsJaWxLxzlx46cZ6VIvo0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758317320; a=rsa-sha256;
	cv=none;
	b=WAHib52IgQhkFu7rmn2gKDY/GXO4wBI40u7LJZsTxRH3CnwVZY+11zQTjUeM6koDDAtJvO
	+S3hyCsuKsV1bcaqloK/bo7rdYEgtxTaPNrm7QFaB+e+O8ii+1nXG8OhTNdX1leDx3Q4Ky
	TZQeI6LdHYwI+3wQjsaGGKpOCFZmEUA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v6SrtbjR;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 19 Sep 2025 14:28:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758317317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wpUrXb0nSEj/cPg3wNxEbYpjYYIRlz3XIOQouIGdvFc=;
	b=v6SrtbjRqCDfXhiQdSAabk1SPGZUZSK4EkiadV7EtS8WZGtcorlmLWDFlQfn76YqlG8V8Z
	BEuj2IY2AG2n4i++cj2ijfp9JLEsbwFEIAMKwD1yxss9d8aoOccCtNiyhdsZ2SylL7nEW9
	+fISEIZneAT4IRWLrxdPDOEREDqwqtY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>, 
	Matthew Wilcox <willy@infradead.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 4/5] mm/fault: Try to map the entire file folio in
 finish_fault()
Message-ID: <hbse7gypxkaphzhdwkfw5nzu7oufcbd5iteyqw2nc7j4xptydh@rfympsitxagc>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-5-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250919124036.455709-5-kirill@shutemov.name>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 94y3rdtj8jziuqruzw1hkfuyen385t7y
X-Rspam-User: 
X-Rspamd-Queue-Id: C4432120003
X-Rspamd-Server: rspam10
X-HE-Tag: 1758317319-338276
X-HE-Meta: U2FsdGVkX1+64SlzT2XKIJolJHPu4o5HCKWTNRfiUgfrPd4AndrUFcXsmnJMExQeLag4zeat8nakuAf4c8ynu2FxdBoEJYQ3NN6y3IwQwp/rXpIIHfeHcE7zCOP3/C4aQipTBmBdYQAArS4eZKyesvZLCT2906RTeaKApdV2E9pUYDZxMBbY6dyJzPKng/RvVbeM7eXKwAJbgqR+9HFzRHyJLihEmnUkRmkmMJxEkr7fcuLPYUqvte10Yd/Io8+wAo7esjw3MDeDwHx6NWyRvTrq1N4FK2BeflAfab0p+KGqYTgi0zih1A5VZh5Rt2jgTHbUS1ji1CsmD81pNs4SQMlH8qNyfVvv2heenUC8RfwE/EYeL7vM02yhFv1fHxN33dY2jVl28MzwHGnGl8lIgk8/QRahTeABK8zmAAhYUrGSJH8T0Wju1m6mUOgItoiyofGMuWMGE1hXE2+AALwYuywdfQDLEmSFI2WpI+aSmAe326xJeA5iI0JWunn1JB2rJwgzvhv+REQoRIN2/HmkWoEIdBYKBTrjb8u46BiwOHfTYnBxgI6id4Vu7kQu8lSocn+KJf6gU7EceKbgm4CAvn3By+NZ+DbE97LyYM4MfQIK/oA457eqlcX5imvGqbkh2UwBRcBx85KLr7usoc+iikKuGtjr4XR7uMQzOLx4npVFKJ9bGjCAx4qj2Cuv/U0IssPPsJFUWIRk2gu4fl8co5Ba8zFz90l+Wx3g4TP+JJezkAOIosvD2kjSAH8D5l8SFAawdjGNi4iDowcFBD/4gseXHlmIpASqzXpr0Imb1AvHJXggQsgfbvA3mcAAg8//MGH68qpVff3sR9flg0lSGXGsdBTvYW851jWOCcfM25g8j1wRlV28Y/xm55+zdj34UBz8NViLRezgLGStW7cfFTsfGxwJv9XXvNV+X0k7N2Hl5MWc9QQzzCrEouY7n2MCAN2fwKnnB3cep3nJj4G
 tJf/Y7y4
 5qvkl1xtOzhN3R/aRdkcCQumgDKn1TCMuklTL8rYJxacHma3ZYqbNDzyRJzcrCz9Vf8ajm3FJcYgwT0ey7VwR56fqfgcgP0nJM3qQZ8AhzrkJK5Ggyj1iIJTpTyLPOYbk3yT5+B9Hf32l/EcJ6bJABdOAGyrl1ajNvDBYP/Q2B0tjSPMXfGaSnIN8G7tVPx3vOM5Z8cTltY01evSqr9WO5d7tfU7vTmVCMMoxRwffTsz9A3DHr06ReeGbhIs4Ztmgfwli6xUgu65q0XV/UpUcofENUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025 at 01:40:35PM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The finish_fault() function uses per-page fault for file folios. This
> only occurs for file folios smaller than PMD_SIZE.
> 
> The comment suggests that this approach prevents RSS inflation.
> However, it only prevents RSS accounting. The folio is still mapped to
> the process, and the fact that it is mapped by a single PTE does not
> affect memory pressure. Additionally, the kernel's ability to map
> large folios as PMD if they are large enough does not support this
> argument.
> 
> When possible, map large folios in one shot. This reduces the number of
> minor page faults and allows for TLB coalescing.
> 
> Mapping large folios at once will allow the rmap code to mlock it on
> add, as it will recognize that it is fully mapped and mlocking is safe.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

