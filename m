Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F734C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A3EF6B008A; Thu,  9 Jul 2026 03:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B0F6B0092; Thu,  9 Jul 2026 03:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590A06B0093; Thu,  9 Jul 2026 03:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 390F66B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:59:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4D8E40465
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:59:08 +0000 (UTC)
X-FDA: 84968487576.27.62F51D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 13DB1180004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:59:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUUATdfN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783583947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oWwbm+zwEQ+hKtiYKEe/Fy+CBUoPDFgh3D2WLIb/mrw=;
	b=TRfnfm6KmLOBHUpk77d48RA3CFtG2xlvqtC28yxkx1WNyc4cqlPMFUWkYw6/8nMp14RMmm
	3Jn8nZJneFD/p9ytfByjffB2Pj6jmGYNKwU5D0k8prVGF4E0a3CMHyRTQBot8ypX+VNCCP
	aiuhxGEAg4hOZ5p/cNDss9kJ/qvaNaI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUUATdfN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783583947;
	b=xMGBK0frxIKQOp4uXzpGKmiSE/rUCcV/lsRg+vkaC397JnRdIJpFMryKLhDDeB8LWp7c0+
	b0oKHJVLNNH9sJvM/tI5KL9nRYa1ST3N2KI3oKRnIwnHWhh7F2lP7ynqnEhL2yYQfkXbc8
	8P0+tC3UFqFCXmbyuz9w4OzZTBNGG6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6119E600C3;
	Thu,  9 Jul 2026 07:59:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083FF1F000E9;
	Thu,  9 Jul 2026 07:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783583946;
	bh=oWwbm+zwEQ+hKtiYKEe/Fy+CBUoPDFgh3D2WLIb/mrw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OUUATdfNZxV7YJWwlf5dZ9aP+RuPXbX1D1M4n3pTKC/QdSRi9kpL0Dfay2ab1/95T
	 HZoYHz6ytOk0z4Ck27144zYmn+4ZOiazDR3h/rKXkrMsRYqcJ7LMDqwlBhkYYEEx1M
	 KCLc/JcRLM2Q+ymVtGLbxEiWmuNoS2tiFrKXhRb2HWCW7hooTd5Y5pNN4BfY/7cpJz
	 G0lu/XmZ5yvbghgKFMP4/JzL70GS4H0gG7sDVAIkezBekGYbjpj+ZqkCtMW1PlqLhF
	 M+pHWuWyjXml6bEKtIEIxa4bokofQgmMVJWfZ41nbodkn0UEtPqVrlaj9AAoxFcRBm
	 7NInRHIeUd6wA==
Message-ID: <706d312e-2509-459f-9339-3743d18f0ce5@kernel.org>
Date: Thu, 9 Jul 2026 09:58:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/percpu-km: clear page->private before free them
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-1-2970fe777dd6@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260703-keep-subpage-private-zero-at-free-v2-1-2970fe777dd6@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 13DB1180004
X-Stat-Signature: d53jq5rn6mdq1g5o4goc3dist3g8ytow
X-Rspam-User: 
X-HE-Tag: 1783583946-884716
X-HE-Meta: U2FsdGVkX1+baOFAvnmQafbYIebiYtqWwd/s+Ticx+womy5kzC7nV9SOspyTJVah6OgRV8GNMlPFvFaGUnEWAAkxn6A4CSUwWOlXl+IB3MCuKPDiC6dGKr+9E6LcRfQrED52HfcLPKOSLcfV9U8KW3rccRCkYZ6bIPe5V/9ZJXO7zbUu2T4pV/cFzZIUaxuzwX8KMx5HFRrgmt0+tajEw/bh9ioySk39ezN0KBN8zNMHbHSLYG4Zc2VHCvb67XhPmnVfMATe2CPABddSPR3r+CeGrkHgQLVFSaNRiLTUQWhjpNx4YLv8NhTqe2X7NkS2kcsErjOhL5rdZBWNAvKkedecdz2uRMcgjHUzuHTQ5Gxv+3EXM7gbeUGN/H4PJl/fiWow07BiAbUZF1JOhg++RUjufKzkUSN1z6zNylG/uXHctRA0er/ofpSVW97UCw3JcbMKVIUL1Jo+ZNHaK2csJ4D5VQ5btvoCyb6FzCZEirbNY86iJcIE2daixowRUX2HZ0NInIfBmbE0yoZ7mI17+vkjJEPEi3M+QDYbjyCbw+h25+YhBoxExk0QXU949isLcMaZdqB3/avaBCzdZZ2GuJr8OsPbH2HmMSrZ2TwdD8JXM02aEFlPD7eVuEHW6uw+4d/ArFKUD6e1qW2+SQxL6G1soZRKD3xir9s9ldYM7S4w293PjqIlnZHxuVXm7Jh+vfhUWjZtntF4h+0ByZ6lgavqU4/OoHb36qrjzdJPwGcyU5yMv2c1W/W3roMmmnpPR7KaaYPVVuGs8vOnl6Qwe598j3F/fhCgYrD1PeU3M9Y8nEThYrkj4jGt/vGOUZAi/KUthCLKPeNbX77sHURq03/gykSBf+1ITkIOzDDV0uulc1028SB4X6fFTKrzgNZBiBN86j/+eaHMKRcg4vAmS/4at18oHnxklm1/d4JyqqPk4astJ2fV4w5x1kvIDEu4tLbHFC5+Xkua9FPLR8V
 U59y1/Ve
 kDsA8l6VS8ZwjaPxtPQi2lknt6WUKcK5z/1hlgoZL9touvtDYwl5Qrx4BD4e8vvG14CA3GpevnRKTjuXz6CweVphOLtsMf6NAcmKmO4SLKiEdEDqqpqMcMFH+WiqIGTdSWN8U2KC+K7/mEou0wh0EpIcWcwU60J+uOmbHQadFO4Yp/INPx7NYeHpqOUX3BBhA11iq8OmCBbnTgXIqaUrNuSVNE2b/yKNpKD/Z76UMBl+AwZnFPpcXOe9kr21z8EWXf9G5yUh/UaSKt2CarW3kXFT7mTPf1323l0R7oHQV5XqEerU1idy3TEX4kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 15:47, Zi Yan wrote:
> page->private is cleared in free page path. In a subsequent commit,
> tail_page->private will be checked and ensured to be zero. Clearing
> percpu-km allocated pages' ->private to prevent triggering warnings later.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/percpu-km.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/percpu-km.c b/mm/percpu-km.c
> index 4efa74a495cb6..7ffe84adadb9d 100644
> --- a/mm/percpu-km.c
> +++ b/mm/percpu-km.c
> @@ -94,8 +94,15 @@ static void pcpu_destroy_chunk(struct pcpu_chunk *chunk)
>  	pcpu_stats_chunk_dealloc();
>  	trace_percpu_destroy_chunk(chunk->base_addr);
>  
> -	if (chunk->data)
> +	if (chunk->data) {
> +		struct page *pages = (struct page *)chunk->data;
> +		int i;
> +
> +		/* clear chunk info from each page before free them */
> +		for (i = 0; i < nr_pages; i++)
> +			pcpu_set_page_chunk(pages + i, NULL);
>  		__free_pages(chunk->data, order_base_2(nr_pages));
> +	}
>  	pcpu_free_chunk(chunk);
>  }
>  
> 


