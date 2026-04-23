Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D91F9937D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3BC96B0005; Thu, 23 Apr 2026 08:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AED0E6B008A; Thu, 23 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02A26B008C; Thu, 23 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF246B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:04:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D99D160146
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:04:58 +0000 (UTC)
X-FDA: 84689689476.19.0A2F399
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D36640012
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:04:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HAbO1lYx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776945896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kC9/9G9yT7dBMIYo1ILSbji9LR62nzrFOTiPGAPN6Pc=;
	b=5hJAEkHoX1wqqTJIJ2pbZGF1In2fZMMXurrON8Wc21X8J7OQbiHeWPxJYt50PyWfyy9BZM
	Oq/VqcH4ploGLwzI5/bTQX/2vlQI5DaqvoEEMuwRxYp8ZjDJrtn+47qWODwKey5icPaLAt
	tXILqwyaZCl/8xOtAFskI4ypW7/a/eE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HAbO1lYx;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776945896; a=rsa-sha256;
	cv=none;
	b=6+Mx9YjkjVHJMW0lezG/AIivBJxjFhmmCA5bf/AF17J3gbsb1vPFlhheuuJU3ViHgo7w3+
	bcipqs+/9ThMW0CCDQvgV2RnwOt7Y2DVcJRKOt4aGCSrxFS9AInSSDmdsYfSymZhvD4QW4
	dNimyky5tIQwz7GDds74r6jg11ft17E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD7DC1C25;
	Thu, 23 Apr 2026 05:04:47 -0700 (PDT)
Received: from [10.164.148.53] (MacBook-Pro.blr.arm.com [10.164.148.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E801C3F7B4;
	Thu, 23 Apr 2026 05:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776945893; bh=hzJ77ASRkCRaSHSjMn47TW+Kuw1n+IH12iv4QHD1qVE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HAbO1lYx2JeLQ3DwNXPZ7qJv+dx1eztGxRc+BfCLCs75zj4s5HbY6wYDO0NwUTOPN
	 jOF/iyBvKKjD74UeIwpsqDDQ4UeVGGgPIqJzmYQ2cnYs9wFuuVaARz8TEq+TQ5Fmky
	 nb3CC2oiEJqaMZcgz8ehDb7wkfOmmAQGXQLvBSFI=
Message-ID: <626b7f63-b165-4e9e-8c18-92cff5aab1df@arm.com>
Date: Thu, 23 Apr 2026 17:34:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs/mm: clarify that we are not looking for LLM
 generated content
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Matthew Wilcox
 <willy@infradead.org>, Harry Yoo <harry@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260420-llmdoc-v1-1-47d2091177c4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9D36640012
X-Stat-Signature: mciamu4e46gsz33e5eehdt1xa9fwfrwc
X-Rspam-User: 
X-HE-Tag: 1776945894-194563
X-HE-Meta: U2FsdGVkX1+biWNSeKKK7BvY0hYHavKB1FtJhVeLFLr9ZBmd4ShPZ5CRwYTS8NTEf43DwMreMYEv6fEMl7YFoW9kjQ4OHHLkWJuhMlSJ9BiEiixbzUvPu8N55wohQ1qwMAlCVHbxLv2pGIbGPkXqEh4q5xCxh9scN2wx5Caj8xdHDe4LlzX4qh+i7FSoD61ujdchBUlhDkZ3Vw4/X1hByezaT9R7sR00UMqmtoHP9OUPHFlTtu8lZaqke3ewWm9IKqxiHAVJekiYJEviPzWanH/XgXZJCcos1GEFY/9t7LF+p7EVNl+38+a1T+D+n2RLZ4CCi0+TouiY4je54pmHj0ugC7w97nSN9HATu5mYXNqWqnTku1y1anyqzpuf8YI8iUBnaQmdcM3z1tk56EwQ4Y0NTQPUV5qGwkWh1/622d+XSOYFphoMvuvAanf4tV80t1GuhqGqlaSw3TLFeXGxLwDdDxbqLDgIUQGCYv1r0WtxfbUZr05OeHNlaxeLJsr2wcRrhr7vAgN66SM1AS5O8sNv/fyJa6ItKx1pmG0CArlhaIt3o6bdHxIQfevsqUjtnoeSmkDxXMCOZul8e2Ri2sm1ZF3gtlPDGhRJI8GIbBjSWfkQ9SxNA+AmuCxT/s7Lk8Ta2Fdw/KPAOtZhcktq4eK4Q3tOY/pOWBSdh0pzsdnhXLlEP6hL6bv3nOG08r4PvxSu6FpGJnUHAYty1d1ANh5+NwCZYuzcAxUoKAh2Odv3sEnzn7bdVLyAmTyMSeRAxgGFmjySN4H8b2YUxaXNMRu97DWQxgV6wCbWgO3pr0rz2DJH9OCJ8lnh9+HYwN5qMwf4Po3hVqpXkYV826/FkuKL864QdxcIixEhEdNfThWDdFTh86YBGi1NBfA824NUhV+z6mAMFwzX74wXDiV3ebY4UOMHCf0W7w7IHq8i+G2Cf1/F6Ao33VVhSLCh+/T40XCcIerr6nB9tCfkkD8
 HvrSzb67
 92mB2st6Ph8b26sLRCvSmLej7NiSUOx2Pl+liZnzYr4705hWuy8GFu81G5VwUm6LEd4l/FxVMD88KsM3q9ghmXKs3a7Rn579f50OiOwjtcGNUGsZD5/vAsX8QG1vPqiDOoxP4wS7sbyNYXlaslWKAhfQlQbYquDXO58cjH8+HMTl/tIlnUfbPgIeQilnlZ1f+IWO8tGAdRXY5Fx2sI8KLbTcUajS0UqqLvxDI6W2uoc+BYRwXO5UKQscBx+Nj3pnwZkNT3gTbJhyyA5gijzju3mw/tMkq1hq0fvuM1jw5ToLCDwFNMeTPsBZoyJXy7DHFKnvT0US6OaUsR7lc3gvS4MOeA+Nif+IE4vpN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/04/26 2:33 am, David Hildenbrand (Arm) wrote:
> Let's make it clear that we are not looking for LLM generated content
> from contributors not familiar with the details of MM, as it shifts the
> real work onto reviewers.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Acked-by: Dev Jain <dev.jain@arm.com>

>  Documentation/mm/index.rst | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> index 7aa2a8886908..13a79f5d092c 100644
> --- a/Documentation/mm/index.rst
> +++ b/Documentation/mm/index.rst
> @@ -7,6 +7,19 @@ of Linux.  If you are looking for advice on simply allocating memory,
>  see the :ref:`memory_allocation`.  For controlling and tuning guides,
>  see the :doc:`admin guide <../admin-guide/mm/index>`.
>  
> +.. note::
> +
> +  Unfortunately, parts of this guide are still incomplete or missing.
> +  While we appreciate contributions, documentation in this area is hard
> +  to get right and requires a lot of attention to detail.  New contributors
> +  should reach out to the relevant maintainers early.
> +
> +  This guide is expected to reflect reality, which requires contributors
> +  to have a detailed understanding.  Documentation generated with LLMs
> +  by contributors unfamiliar with these details shifts the real work onto
> +  reviewers, which is why such contributions will be rejected without
> +  further comment.
> +
>  .. toctree::
>     :maxdepth: 1
>  
> 
> ---
> base-commit: da6b5aae84beb0917ecb0c9fbc71169d145397ff
> change-id: 20260420-llmdoc-21bf5fadbd6f
> 
> Best regards,


