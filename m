Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACE3EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 13:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD7D6B0272; Wed, 12 Aug 2026 09:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87DCA6B0273; Wed, 12 Aug 2026 09:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793D76B0274; Wed, 12 Aug 2026 09:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A47D6B0272
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:26:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2068160365
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:26:12 +0000 (UTC)
X-FDA: 85092690984.10.DC2AB4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 211104000F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 13:26:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMDkp15k;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786541171;
	b=Xie9cXTE9U5a5nfAl3bQY33XKfZzsU8FYo/5c51CWzZSzvKA861b6NbTyfJVqYexrL7Ryb
	Pio4vwLJxFyDaT64/qIk5rdFoMIYOa8oa8upqu8FdkjW7R1WrYxdXdXri4vjSqDPMH7m77
	rGa3mZOPqelC6tjtxJkLMUSyeusYquo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMDkp15k;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786541171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=noiWJOJM3hJi5lUHIQ+tlr86OBu+zb3YIcDPnG12gDM=;
	b=rG/XsZg6nW3pXzUE6wJzUL4K9+ekvyaovCe9NzPtFV+4bG0hRmthOyNSXyLaoUMbITQrPF
	GY9T+4mFGTUw9mH1vaK2zs+nXoXU3Gldc8SAAkFXFXYlFh5OwIYEQ+tsJ1Gav8K6kpzglP
	pFTIoNuc8xQQ2tDHpBFJkqjb5cd2kaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4211241A15;
	Wed, 12 Aug 2026 13:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D271F000E9;
	Wed, 12 Aug 2026 13:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786541170;
	bh=noiWJOJM3hJi5lUHIQ+tlr86OBu+zb3YIcDPnG12gDM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nMDkp15knjWZC7yX3zAZ7N9xzQtXYlbG1cnQGzEOVs6mQtwBzk/Qx88NxIu9lr7oP
	 Fwlph49eZWfPDok40ElYYY8dmJNfm6e596j3vf3Jy0MJA+cUCKHycg+snZU3FUSnX7
	 CBFRweeeRAqoCqx7CyVAM7JjiqF9SmcepBFwWThXXIquH+YHYdrH5RLdDNimkT3bsK
	 DeUET9v20M2eXsyHaNPXVKG+pSDr7R3FWlovc3k/g0ZWCWUgsaD9PqQ/y/y5D2r5B5
	 tv5SZMwE/NKaOZj+9pEzdyC4c6NOdl/XnQhnk+/b+x4Gg5t3/xdu/+3H7hHFc1xdnK
	 Zx5EaoDhPDRqg==
Date: Wed, 12 Aug 2026 16:26:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: replace custom ratelimiting logic
Message-ID: <anx0a1WcWXxBuVG8@kernel.org>
References: <20260811172156.356053-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811172156.356053-1-pfalcato@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 211104000F
X-Stat-Signature: byozkhruwrebi9cksanpx4h651etdfj9
X-HE-Tag: 1786541170-373490
X-HE-Meta: U2FsdGVkX19j3j1D2yZ+WbAsdMJ2R6OW1Crqw2fWpypWmOO69leJo96zakqcYPKCf9tcMQLbY9oJ0KmVCZDGPG+jwAourT7MNt9vm84RXW4tUfLlD988ZO82EOFfzDL/BewThff7p6pIQx4ZALHP9sxdPaULx/xfVGUHPWWEU0OfhU+pX3y1kDI4Ox7PhVU/eyElEte6rpabSv/iWqP58GaD1WCk9e4nHCzh8Q7umHUF8NNnoV7DFfKZtRlZkqWbg/JgaDfSEwJmQY+VuZcLaOjBWvpLDNDKElhLKwy9eiDPDye5z8r/qGQGN8x9wozBStdJsPnMVl9h7yzJMAJKdznb71TPlodkZ64IT5sPy5KcweYGTZAZto5BaFIJfnQBOIFeXliEhJXdCXFJZnSIYAKxe+8cUJlchWWZ+CnNpj4PJzdrt0xwJ7uFp8Yn8Dc0cCE9wKeRs2r4V+dpIKr/XFlsr5zgyrgIkDThhq8uRirKegnMwCOavk8LKvF7Zq3aOLOzAPkcsvIpkBJ8isTsbZFiO7ZfD784NPDkHb1fC6db02NSU4Z/EHVf6kQ0zbGLQAIpbLcroWEH8oMfJa6VjfjJV2HXUAbYArMTyvTBrU2w/Ey1wz5y9Q2ErzS5ychh15GH5cPErQtwzejWQ1Cxhe/Lr9ISOJroKtBrWYeiMYW0kDhSl/Ri8u25Fl+5f7U2Rb7L5s2ZSF8MY0NHLd+p2J245MF/jjMGGMyArd3newLLlQ++rbbUoh6wZWPR55uPcOfqXsVNXIhhqzR2E2t9KzBWIeTc9gIUo/FajqwfNNr4ymN1ex+e395hPZ9OKhl0QX+gg/HKkNhf13ssi1nVgqMqy6Hy3lnbmekYHP0uPC7gDvbEdDLYZKO8jAyHW3KDmmjj/9ONQwtABh11MxYcCI37gouahhR5KkECdNkPhSJ5uyQx7FzErI4r2Kq057SdC699TovNiJl5uKRdeKf
 KaC9hWh3
 /STmAXwU7LD2sboCLPvnO/yEDgd18LXCX1zfSYt0To9rpVwVWqaZ3zLNdbCGqFG5RfwvtS46Z7Rfxto3fSHK69B9OFVWfT65AikAJ6kAm52ET+OKx1rY7leCyVUS3Rx1RIwCQNMTy7gS57Df+eY0VVAfr6UxFif47cHDA8Wf/7XMH6g1lI54vhXGc/8bRpsnjcOYBhueMNFNNhJT1f2cpLvWRwoxSBPSmAI2a97l6YwsSuisx+hRG8e1NMzrhkgVBdsASY1JXq7qb8gokd9zkXDDH525rEla8RvtO6lanhy/xTpKaMwj8tB6ND1b3fo9CBZprXf6j1EPypSAE/UJibQMdA0q3v9mnj+EjxIdimumTNRLKQiCnJj5DMA/2hOmNp3j7tbAl5VJie53XMTp9uaqi3XgDREBEwLNHUNeVzF1axWA9Oqz23eA8mhgla7iQbl9ZDTo5hxMPYcmcRtJCPNdNq0CLKEzQBRW+B+xjF84QJuWcg7rP6PQpJMnOUlSqiexx9Q2ZOZXAMEh6MlTZSXBBoNnmo+W1//n+NeTzQSN2kvmr2AXVye4ixM0w9kfkKx1bqZpHkXzn3/KJOcbypR09BRziULFJVSWUj+bLu5WI70wxJhC5sb+uLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:21:54PM +0100, Pedro Falcato wrote:
> The kernel has a perfectly cromulent and mostly-equivalent variant in
> lib/ratelimit.c that can be used.
> 
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Brendan Jackman <brendan.jackman@linux.dev>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> 
> Pedro Falcato (2):
>   mm: replace custom bad page map ratelimiting logic
>   mm/page_alloc: replace custom bad page ratelimiting logic

For the series: 

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  mm/memory.c     | 30 +++---------------------------
>  mm/page_alloc.c | 28 +++++-----------------------
>  2 files changed, 8 insertions(+), 50 deletions(-)
> 
> -- 
> 2.55.0
> 

-- 
Sincerely yours,
Mike.

