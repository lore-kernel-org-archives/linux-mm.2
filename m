Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A36CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BE706B0005; Wed, 20 May 2026 02:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095E36B0088; Wed, 20 May 2026 02:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F14A56B008A; Wed, 20 May 2026 02:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E09EE6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A76FA160496
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:08 +0000 (UTC)
X-FDA: 84786820776.18.55BA854
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 13AE414000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=auirV4II;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSbRqEC5T6dYNXakSn7tDht38iosa1zNGD4+O+MXPHA=;
	b=QQYtZKmbTJNWSW/OguM+AeP5YUSRUqJQ2hGkgib1utladny+efvCJ9CLXjIDToL7mARPUq
	LEPE2gVTfZA85AcO8XrUQXscOD08lCjuvkB0T1917xJqwCathBmrQ/CwnXcO8hXL+y024u
	7WYdzMbzFvlSGEu6RlRmbQ4C7zW8hIs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=auirV4II;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258547; a=rsa-sha256;
	cv=none;
	b=FNA2AfvKm332DbOj83JEF1O+vnl0y1c8F0Nlx59zNTMAJbnpam0St9DGM0sPDc1z0q6PSk
	NmOKfvxc5Mp1ztDCE+PBk07s+tbfHAM6531YV/UZYpdfcsmZzFjOhjHssgXIVEUJmbv6DA
	CPk690a2ureozrX7+h7tRF1j0yyeQEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 326CA41940;
	Wed, 20 May 2026 06:29:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F11EE1F000E9;
	Wed, 20 May 2026 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258546;
	bh=aSbRqEC5T6dYNXakSn7tDht38iosa1zNGD4+O+MXPHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=auirV4II3QbKxTX+d+7zpQtK5fY7rq65dsLBaigfVB0ntTaQwMIBOA7Ppq1DtEzOb
	 vRy+cVzT1PIr1CBRJlbJz6gJc6wTheqoKxbQRhH+1pgHoPGPbmBUHA/hfD6G2JHgNh
	 t4czeysIGvHeuqSc0+PeULvxGF+GuL3rEk62rFy2WLakuGMRO+Cd9oUZutcpLhtUmQ
	 AbQnZqj0wAB7m7ASUXqrgrvswCsLOrZOmxOc8ez0rQirTc2APtUcnnL34IogxfLqz+
	 SNY85ShVUxv5co6znRIV5maTD9GEkEDLS2Nh9lW8q7iQL32YHcUI6MYV1wLRTnhKvS
	 NVuBfpeptwpJg==
Date: Wed, 20 May 2026 09:28:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	Stefan Strogin <stefan.strogin@gmail.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Michal Nazarewicz <mina86@mina86.com>, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH] mm/cma_debug: fix invalid accesses for inactive CMA areas
Message-ID: <ag1UqX7QVErB0oo8@kernel.org>
References: <20260520061025.3971821-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520061025.3971821-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13AE414000A
X-Stat-Signature: h1ad6tz3dafbd4wrm4indus9e9odz5j9
X-HE-Tag: 1779258546-91355
X-HE-Meta: U2FsdGVkX1+kzaJiOD250uyobhZv/xJcFgg+5MrMiTqDLK7ZADc9YfcsGvHT0megkHVO9dIUz0EHFrE8V79ducYhNe0oWZeUZHv3rdFoDDCGFcRHndC1jLxYAGoQ/7m8QL8wJGu045cKP0yYLoRxSqVhos4jkeIH0kGxNtU3M1h3wnjEZabR+qDI3i/yBA7UeBM+B9VptBbxRryUTP3wXCGAeUC6arOceiPV+W6y1tCPtaBtnG3Jw4jC4ENxAjCaZ21kAeWW2Pw3Oxmxlup+UrlqTRCYKFRgvFkA3+A8kIQ92A7DzpxHWbwXXxCco2hbekoK5ljTPlkRsCD5F61HDzCdlowF7S6sfvBipQUCmZk8kurV5bSVYdLLy7RFinjy0Xto+zWF7r6vHjQPjC9sxr0orvDdPG4nvD8kfsaVqvmQu1Rtm4KHr2/EOqVEirXoXkD2Lhw7vxY3xS216vwW7Gx5CNrBgwUo/u8M6K50IU5FvM01mWtIsGZWKpEddZIOIwG3IB5jG8SZsI2Yr1LVFrx/8N5s8JMCzR2On02iTQBeLeLZm43ORQvXYhEjCq5yEIIUHnCYq4f+XH8W4XNw2OTPRTsbc7m3tjXhV4RCj8oScCHiyIAGwgESsNcvLzCdtfH4WomPXGbnWtsRK1pTm0WERheDXesFAY+af4FOll5TpRls3i6/7UQtJKUXBOnp1UPFj1odqLbOCdRg9gpQZQht7WKUAjRmJE1AAFkksXE6xsxW4ksPZe3Z0zbaoXnIXn1306VCly0sf6+j4hwVkbMPHHXZLWjh8AxIZrJVyKU7oNKXsFKL3W13lDStMNUb+nVprJBJyoRtvc/JxxT4K3szm85lwAO2Hi76DnADsc5e21lUQUGcaxdtfQiNBQPsdaMkaTd36zm6NywwpI0J7wQkr2P7Ut7NIWFeufhlaTkpyMk+0kGR2RgF15ri5eA2sGZtOnop/zYsQ3AbypZ
 +3gR7ESd
 ySL21aAfI1EbNgOT+A6E1Cm27G0O741h7G98rRH/F9DFGIK2TY79rMzsos1jYuRyhiAXssMQ3Q+50JhkAZeF1k9KALKCxB28/RzJje6ADGUMQfLLpVp/7WAHH8G6izjCWLPCMh6OeoEQhX1GRalAiuDahUIElcH787oxe+LwDMenBwaBX3F9fPnvBD6YVh4OXDJwE/GxoerXmWJcSH1aDVV5MGVHjR/FHUHU135ky5CTuwlY0DRaduOgi61c5qqeLtwacuwWM4s9rUPafDCsrOW6+BuRhFruM5LlXUGhdOZZsvnpY/FoEx6oYm/DqkHz7vxCPx3t9tu587g8WxRvRBOCr0cCypYA3PTOaGasylFEoP/thXGcfWgxRLLHvSO+3PRP0Z1VISaApCVNDG26ZVL+fScHlgOuYtuS0UvRCkRbGxck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 02:10:25PM +0800, Muchun Song wrote:
> cma_activate_area() can fail after allocating range bitmaps. Its cleanup
> path frees those bitmaps, but only clears cma->count and
> cma->available_count. It leaves cma->nranges and each range's count in
> place, so cma_debugfs_init() can still register debugfs files for an area
> that never activated successfully.
> 
> That exposes two problems. Reading the bitmap file can make debugfs walk a
> freed range bitmap and trigger an invalid memory access. Reading maxchunk
> can also take cma->lock even though that lock is initialized only on the
> successful activation path.
> 
> Fix this by creating debugfs entries only for CMA areas that reached
> CMA_ACTIVATED.
> 
> Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> Fixes: 2e32b947606d ("mm: cma: add functions to get region pages counters")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/cma_debug.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma_debug.c b/mm/cma_debug.c
> index 5ae38f5abbcc..523ba4a0f9f7 100644
> --- a/mm/cma_debug.c
> +++ b/mm/cma_debug.c
> @@ -205,7 +205,8 @@ static int __init cma_debugfs_init(void)
>  	cma_debugfs_root = debugfs_create_dir("cma", NULL);
>  
>  	for (i = 0; i < cma_area_count; i++)
> -		cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
> +		if (test_bit(CMA_ACTIVATED, &cma_areas[i].flags))
> +			cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
>  
>  	return 0;
>  }
> 
> base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
> -- 
> 2.54.0
> 
> 

-- 
Sincerely yours,
Mike.

