Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E01FCC050
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 183CF6B0099; Fri,  6 Mar 2026 13:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1073E6B009B; Fri,  6 Mar 2026 13:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 013016B009D; Fri,  6 Mar 2026 13:18:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE7F46B0099
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:18:15 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 89BF71B84EF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:18:15 +0000 (UTC)
X-FDA: 84516447750.10.03ED5A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E3753140010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:18:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1Ayp72B;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772821093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EuJR00hUt04QoNApNlznZtS1I7+jMDRWkhzjLlyoimM=;
	b=26Z9Y9nt0sNPJadxewoLnF4Fw7/4JI74g6YFwQb7usNcpBxIX3QWooH4I8PfN7jEhwUEhZ
	8STWGc/GZbQ6RK62n1qlrCYpx3SnhYhYZtJ4OCMgzw0yhjUpQL9o1+hE7ByCBSAnF/yiiC
	wT9ck38x1NxzSR4PxljoNCOKabmc3uw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i1Ayp72B;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772821093; a=rsa-sha256;
	cv=none;
	b=zmSTDUqTuzLFNH6vifXZtRwvC7RVD/WVVgyO3kMphNQdkm3Oa3xZPHrZAh5kDy2vQzL27M
	sVbVTV7ezfyfKaxNOt5lBEX7oCDU4MB32E+jJkpS6aZLEmVqR56X5B0dSm5qj2yKBKl37y
	yQFMSbz3sjZO43fPxJCVtfi6md1pFTE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 596CF6001D;
	Fri,  6 Mar 2026 18:18:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5ACC4CEF7;
	Fri,  6 Mar 2026 18:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772821093;
	bh=LGJoIhaPN4vcLHk+shRkzT22dEbiZVJHIM/1T8T4pEU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i1Ayp72BZbuYLQE0lVVk2Lky0EhTAO2r9+AAc+KMSjFgLMkq2o4nerRky+emaIT8w
	 dujYlvks+UlDKBxYk3Nif4jS6xYb6QTYPLrKhpp6e5+T4U4RjWRPSMIPWEufnD4NeQ
	 EZz73t+YQY6I6dLZu+1w7i4kA4+E5WJBURbfgi5p1qaDCXbr3G+3qppPy+CngKfOj3
	 4UQzFHYPvf3E/jvD2P5suXYiqb/BJ9hfzkoGRRUZT0XKaO7l3aQsqfcZeM8ml1rbGD
	 E/pX6SSlkeVjo6qlBoipZff0BEaXJ+XdfvokCXGLTTpO72u54jqEgAfojnfNOUqfUZ
	 OV7ohYwHxklgg==
Date: Fri, 6 Mar 2026 20:17:59 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com,
	reijiw@google.com, Will Deacon <will@kernel.org>,
	rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	Andy Lutomirski <luto@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH RFC 00/19] mm: Add __GFP_UNMAPPED
Message-ID: <aasaV4N4tr9u5ONL@kernel.org>
References: <20260225-page_alloc-unmapped-v1-0-e8808a03cd66@google.com>
 <daac1fce-e3a1-4be3-a016-ca0fcfc5f851@arm.com>
 <DGUZ17MAFAMD.30IHZ1KYDRM5E@google.com>
 <d6db1cc9-6df5-43d7-92b3-bd60707d9538@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d6db1cc9-6df5-43d7-92b3-bd60707d9538@arm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3753140010
X-Stat-Signature: sgn6t6y3s3eo489jnjw3owkjbk4qsy7d
X-Rspam-User: 
X-HE-Tag: 1772821093-344441
X-HE-Meta: U2FsdGVkX19V4bCuj8IddzdQWA6iRwWTWnThC74r5IHOYOeVCBetXxMIq72HhLJluCMQQjA8wA52x71VCpIbC3OLAURKD8uL/No2PF1Pq6LYhg6QcsHBxoyjFVFGKkFhOoQMcHU+VE5HWPFjvXjYWajG3d+/QnhIUnyg3m8sQWfFnAap0TZtCKdoIj7cjUOICpuxYnZCNTLWb1V5fW+YPm8mcnyT0Z1dvU/91ZOszbp8YdEXDIztBBVJRIgtSNwvLeST5df1/cFgWU5BsW7vqLgfeOad2/FhwxYkC69MgmDz62Tyrf5rNBn4gBDRkfTQ5Ild9ngbLUW7FhYzzZBwpolKFoWWZ7DHlj6OV6sQ/x2RJYVfE1vUv5p2RoKLot4ZffHvb0WIaQd9bFTXP14uke/k58R4odhY/9FEj1FdB6WfjrVvcX4CN/oHiVvSlBtzfdT3IZb9zQFN6cqp4gKY0amOnNjPSLuxTV9Yp3m+yzNT1k45W9Lcx1JVEZZZZrrul44G6K1hFWSqtnuwqUCgzMEgCyg8dldyAkLR9FqFlnsPXgzJNz+d/WGdtOq4ATqLf6sxovJLADoRwxpskfHl44MLzlzkIvBJaVt8FvlRSxsQjvByxqZ7ZKO6tCRO6yf/5xLsVFOQ7Lwbc42f6pJ7X3cI/3mP/t9g+VJQNzXnDbAppMcAveuAz+LUHmrSOPQMwoMLXF7Lwl+d+0+vNAg7N1Itxy4uEaCI1g+b1Hvssnb6UBb8ptLcy5iZ5J0mTS2enQ6ewHlei/j6TQcvEk46MINrRUvIpqRV3vL5wZ67nsqV5AhVizqymIZb6S16oTveJZXgJy+UyJEYVHpkB8Yu8rsXh0uN8fUbGR7KrVzBaiA7D2e3zUGJqWenjlzN2F/SFFGNfQvsYh7elUoznyDZ1k2qdiBzApPvDXIIMStyjWtWAMb0EUiYbZ+WiC76ICiVOghPFiwkeoTriW8ZvfY
 HPNhxlmC
 32Uje3LgtELJU/KCb5XkF+9yH5NDR9bc5JSpVKCWQ/L/g3LFWWNkKY936aoLjDFW3MwVYPk5y+Tpm76PG0qwMfA1BBCkvsENySmLyBNiybVJ/hHNaYr8BpdiRWVW8PuFZ9TNJUsGXO6uuSKCpxVt3lQ7lb6QeGE/tD4BnftwdR+qEWT6/DHFDXyU6llhLjo/Ah2xrPMAKDMrPNMcgJIBL/hs+hWu0Hy6LGW7yVFhKG2Sn/w4VwY44J19R2OusL4EnSVaHXTn9fcmidHquQ4X6JnVPcmlsJ3iCg1DI/dsiNalIPss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 01:31:15PM +0100, Kevin Brodsky wrote:
> On 05/03/2026 16:58, Brendan Jackman wrote:
>
> > Right, and actually just today someone pointed out mm/execmem.c to me, I
> > think execmem_cache_populate() is basically doing the same thing
> > (although it's also creating a separate virtual mapping).
> 
> Ah interesting I didn't know about that cache. It does have
> similarities, and the motivation seems similar too.

The motivation for execmem cache is slightly different. The goal there was
to ensure kernel's executable memory (modules, kprobes, ftrace and
potentially BPF) is mapped at PMD level at vmalloc address space.
And the removal of the direct map alias for execmem is rather a side effect :)

But sure, there are similarities.

-- 
Sincerely yours,
Mike.

