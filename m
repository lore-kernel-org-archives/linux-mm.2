Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4FCDC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937AC6B0088; Wed,  2 Sep 2026 07:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8986B008A; Wed,  2 Sep 2026 07:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800936B008C; Wed,  2 Sep 2026 07:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F13F6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:12:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EDE991C0243
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:12:55 +0000 (UTC)
X-FDA: 85168559910.08.42B161C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5551E40008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:12:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wy7NQKj3;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788347574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A41e8mG5Gaj1F62VVkEOiclvFz4X0/9Pn21XkgxCZAU=;
	b=vBatWHSVao8cwYtwIsYFgktBPwe2KKKb+r2iWLBfxMYmXpHjx/qX1JpdD4QwzV3bHSwRQo
	SkCCyyh+9+mVbJ3ZwRhG69rtTqsQhKfoljGQ6S7QdhUW/cmezDtGG5P2Y2a7JvpL6HHWJn
	GegnedRh8iP9hMXiBNLR9WB+A8Q+GXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788347574;
	b=rphSi8l9LsX0HXRTt2mWMliwrvqPfhpMaa/Oo30iSm36jSDlOsrPdVqUe3yXuBa7oM4wdP
	QJUY2oEDXCvBqTgfU4uF/4ceQU2GykKBo5XwGsDHRVYzTe+VDkMPqBHb17WbAFrJCzXsz7
	sRIdhSFNPicBGKdbbEGZKwC/FdIFYLM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wy7NQKj3;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74DF942A7C;
	Wed,  2 Sep 2026 11:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A961F000E9;
	Wed,  2 Sep 2026 11:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788347573;
	bh=A41e8mG5Gaj1F62VVkEOiclvFz4X0/9Pn21XkgxCZAU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Wy7NQKj3fhyw22FiWKKToNQI4Z6x9WLayrVH4AboIYUcVruYvgI3GGcGVq3IQqhS1
	 fnkCwqUTHk/rgvNiiADE+hlhHxyXXbHv9N9d59HRWskgxPVdU1i98zDzKuyqLinoLL
	 HzDVwlp0D4xqbtUBwnmZI6Lx0Y3B4Bop08EH8ZEWLNnJ2xPFL0tMfs16ItYVD3H9Qf
	 oosSM5ewYZuLTicqSEaf+TI08RqxEjKHl2pXFwHO6CIWGkGiVKf8XbOO2tKzr91OOc
	 5SOzxxRTlQ8rldNaR5UmoXFJyKm9BJORfQ+r5JhTp370iMGxL6ICiERHP5feSeHDg7
	 owJRKAHIoZSMg==
Date: Wed, 2 Sep 2026 12:12:50 +0100
From: Harry Yoo <harry@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slab: reject unsupported kmalloc() sizes
Message-ID: <apgEYg6IdJlBmUwE@nixos>
References: <20260830-limit_kmalloc_size-v2-1-bf4ca9c63c88@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830-limit_kmalloc_size-v2-1-bf4ca9c63c88@nvidia.com>
X-Stat-Signature: 3jd49swj7h8rei8tw7z7rj9upfrgbi1u
X-Rspamd-Queue-Id: 5551E40008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788347574-931868
X-HE-Meta: U2FsdGVkX1/ATmPWRmpzuYnzRLfEnOdf2ytDbK63Z7NCRSCjmug+AOx0fTtlVQV/rpLjDyibDJtLDOrbrxYmYgwa6lPO6bIJkxWoDA72gXgxjdzY4zokSvmExxrYuirlHE5iQM4PA/X4zzGh2Ep4dNKn6QQ1oHJMT2y5YNmw+mZ1EQx6+8CIEPrVhCT4UIZJPHDivss9iLxN39JcDidSC6NVQ6kiVjQin24DV345JcwVWdc2krX57+C7oaRlRxBv1dxtvrnCqcNLkzvBrlPkusfYI5HoA0Mqy+nIROaU0nznZts6tJvPy6/s1g4VnMA5JwpGUXiDb4p66yKCh6VklZFGaikn1TP8SZmzTXdULeZJK+GT7NvkUVrnVmRBfxhPDAkDJ5mXk1hWK/p8hO4e1Lj4xXGFuI+jF8qDovh9Z3oXhV7uqyN/++9wxjK9Y6eVXXD8mc4CvocGl79hZoK1tpPkTtutcd+mL3xEyzy5rS9630DZs2yVSXomYLYoI77pSZLhumA68suhNS9dCO9fNaC+pLvowtffNWqo+oE7Qk/T5AcWYg4AqhiRFjV7InyvjrlnIudaudw/pRsrX/D85Z+8R8vzgjWas9Rb+P3VT7TZE6srOEURfoBnLMCY/BOftPiEGECyYED5kG7MJbhmKkbWbuRtQ7LcW50xmCy7HXi9DJHeH3wqlcVaYX+mgY2et9r2N5gnrq8dHJESXfPQIeNPB66NBA8Zikl1NytcuuoWT88Hh4VS9YFMrmWIJ6QzCHLd+rBSshyM6C0tUtInb++hm+/r+B2qh/+7RpkweJaHa90QKIIbbpCZvteG6lS7U0wpZsUVmqI8Js3imf8BzZxqxT3Fg+BZYFyJB7y4d9G0uJBzfiQ8K/KxdqxdN8V5rTAwsr94Ea/k/IYUO3/CvElZfGEbkL2kGpk2LzLLT/F/NWCe0M2GwDa/H7jY3/M8E6mGAeU98lXjZ95Mj45
 VoGUsGfO
 Bx0M7S3x4SJClnTvqgWXESgDUr0OAgBUrxK9HqxQzAAmg+WsDg+P6GRntFRdTw+ueFqCpuYSzSxCGMMbYXbPQvv2bRaf0f4AvLlLaF/Qwy3pV0u4T7x/u3uCfHV4RtJqKjIE9hQaQQpWxZlB3welj9crVw2UNiiNe4bAfMg46x/SXbxMLOG+xzNtcNIvxXljtjxattKBIGb7QTgK3QFquSPuZHIijK4XmLpjCZIWqI9p2H2i9JqQ9OQOPBWBwiSZ3AGRLOu8YqolAii60AxeMn8Mp0gMzO5P5Sj/K0I6IgV5nG8uR1lMbIbPdTGSveN2A3jE6piQS3/3yieE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 10:23:23PM -0400, Zi Yan wrote:
> kmalloc() is used to allocate physically contiguous memory for kernel
> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc()
> uses the page allocator and can only support up to KMALLOC_MAX_SIZE. For
> request sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a
> WARN because kmalloc() allocates an order greater than MAX_PAGE_ORDER. To
> make the KMALLOC_MAX_SIZE limit more explicit instead of relying on the
> page allocator check, add a KMALLOC_MAX_SIZE check inside kmalloc() to emit
> a WARN and return NULL for requested sizes bigger than KMALLOC_MAX_SIZE.
> Like the WARN in the page allocator and kvmalloc(), allow __GFP_NOWARN to
> suppress the WARN.
> 
> Suggested-by: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

