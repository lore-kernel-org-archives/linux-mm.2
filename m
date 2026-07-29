Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B069C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:27:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612186B009F; Wed, 29 Jul 2026 10:27:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5747E6B00A3; Wed, 29 Jul 2026 10:27:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463DB6B00A5; Wed, 29 Jul 2026 10:27:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE6526B009F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:27:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A2BB940642
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:41:23 +0000 (UTC)
X-FDA: 85041321246.24.173AB77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id ED5F818000A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:41:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUN7Mfn7;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785318082;
	b=yrgr++mgjk0+7LrWicJfqOeVRpVXjM4/Zqj1NDyW/22coxyJ7Nr2XOZrzxaKPBzZudIQJK
	bRm6vyrA5Oucu3ReswJiBbN6EDhO+NC+LmSaDrMHqjTXrQmeRw4LejjkGyH6ys0eaA4Vp/
	sQ0sUj/uNzIGpiZNw/VNu8nsDCL3X30=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VUN7Mfn7;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785318082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mxaGiczx5gkbHpM5PSY0gBREJtXKGPCXFXX45B/ohyA=;
	b=C74xjAOYasBNniC7l5/egkIl2EBinaT5K2aLTWjSebPuRPZeSXj7VkgsEhT257Ga0IoiGu
	YtYZOK7nF2shL221gDOLBhVGdJHzjqe+mE73mCB9I+PK8V1/tgOP9qouZvda35sgMy50l0
	CyAW9vMwUqVrfydJiqfdB9URzRbND0w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61959600B1;
	Wed, 29 Jul 2026 09:41:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6633E1F000E9;
	Wed, 29 Jul 2026 09:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318081;
	bh=mxaGiczx5gkbHpM5PSY0gBREJtXKGPCXFXX45B/ohyA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VUN7Mfn75wQck+/cmR1Q00O9D/X4UgC+Mvt3c7bT56wD4x+Ev52a3GsoCVdYyE246
	 6ArAnS+UJAjjuGD2l1iYVS5erhWkNiAY1NCA/IuMarA0ygfzgYS1T9x2LYiVmPb1wa
	 LzekVb/rRgH6NB1SlpAw6raWTCJhivD04R1JiRJ1O7bx+Vk+HXi46CwmHLmFmOKWtP
	 bh7IqPhvYq8irn/dzJCndTHzvEj6/c/tkRoukL/HU4m6bzpZmW1kY16Tk3jptV6S3G
	 nYEn7mMUnzuWzo6e0ffc4Sz8CtVThjL08wo0AJ0FxcRgw0M+pBUjUfvW4/G8IO84eh
	 emlrAy5eeDBdw==
Message-ID: <0ccdda5c-6aba-4375-8a74-f29659d3f89b@kernel.org>
Date: Wed, 29 Jul 2026 11:41:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/7] mm/khugepaged: extract young page check into
 collapse_is_referenced() helper
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-3-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715025941.1571316-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ED5F818000A
X-Stat-Signature: xyoxwu6b6s848s3hzxkko76bdne1wg6w
X-Rspam-User: 
X-HE-Tag: 1785318081-531363
X-HE-Meta: U2FsdGVkX18LEv1lr08VzSMFOasJziY4xIj/rdIzTtPvywTGwBVP1A0P9QfpkoEM6JYuqxRXJ+j9NPljuMGA2go/mp4Dj/gOm9INxERF7tJ7X7207FR47gZj7mdaRFTfQqZE+qsU6s5ZjFE4otW/WwuI1b1aRLosKanjUXzraks5/vmxDOC85ZUXkNt1gLDj7rliKOY5Co3NkSHdtK8UtQXK1nvcqu8pTfuvVkyNuoipRni4COo39CbXfhyG5J1j0c0g4Pa9nGfioqyeWJ4uV0tKG4nL7drlZAwvoON+Nz28IO248SuXE5JpK/SFTnzC4PuxxkSauM/FNxOg/AR7x2xELt5r/hSo1LMye7tEYzmAM5f/jI0UxId67tPRQiXzgPNPQBYD9Tw3NGWpCNr/PEG/pIfDBbziGYC4u6A5eZbClm3cFW7w2Yp3sTidn2/fHfJrU574yJkk5NXy+m58vAIzGLquvOsEJ3q0h4+pH+jlT3jwza6RP55599nYnwWAsauia9cau/ejMVn7wv47CxnqNRvkhXlI9+nEigvDhspJt+Th+KyxArt1klcfA6xIvYzGhV83NJRfR4HqqW+Xg8p37LZcVx8n3Ld6nP39jnkJQqDuKbZTRQh7FHqjOf0EoTMy9pY0BL0Emsmveux1W1toS3RiB21uBTADWg+eCQG5OSO4DgJjtV9aK3PlF2CVibCM9Z2rSypAyMFAUs3JLBQhHd7isu6zW+enUF00bqBWJW/erpe3btT93aaUNOGwvjS4HnHXYfLbeY90HxxJ5QDhyOMrGBmxSXR63YNJUZuNIgxlgE2VJOQM8ketWjf2dPJVD0pjjCva/+pz81Q4QQIg+OwlVPLpoRUqFsNs7OAx2GX5Lb3GgknQKojJX1qqMQKwmUL251apWm4Ye/F6fpC6pDreCvk1Q80mX567A5K/jEQMUq0vkLQgfAKfo2OmRUG1IEjDeVZm2z0EzLp
 XutfYvkb
 7b6wTghJ3tBt/k6CHjYIruLjA2jNG2xxC72nJdkoaxmZLH+0Nlhph5YvCQVwWQAg3qWCIfkBDdC6WAwfWaFOJ3pYiom581Kc7ilnRNHOkgyYLR1hD+cKgqCVOPX7mMi/ys2YSpQNb0DwLLEm+FYpNmGaI3FYdObrVwUub1/sQu8xEnHrtn0D6EURrKwki1lwwIoFFZmYqT/7K4TziFAyEjBjO9lMmOUpVlmrXsq/ZzGYwXeSpm8DoDxdMy7yGP59PG3LbzkGOTAz1IJLRocFqchhjxRH3peqvv3EEA9tL7QQ5WB6n/PNa2lyqZ99x59QfPRDkk/QyGUPjNVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 04:59, Nico Pache wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 35 +++++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6ec0812210b6..e92e2b928f17 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -672,6 +672,23 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>  
> +/*
> + * collapse_is_referenced() - Check for enough referenced PTEs to justify collapsing
> + *
> + * If collapse was initiated by khugepaged, check that the page has been
> + * recently accessed (young pte) to justify collapsing the page.
> + *
> + * Return: true if the page has been recently accessed.
> + */
> +static inline bool collapse_is_referenced(struct collapse_control *cc, pte_t pteval,
> +	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)


The name is absolutely confusing. The "collapse" is referenced? Hugh? :)

I appreciate factoring this out into a helper, but there must be a better name.

-- 
Cheers,

David

