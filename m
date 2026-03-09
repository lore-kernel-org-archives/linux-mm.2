Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 192A5F3C25C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3AC6B0088; Mon,  9 Mar 2026 09:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 481486B0089; Mon,  9 Mar 2026 09:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362716B008A; Mon,  9 Mar 2026 09:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2734D6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:30:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B607D1601B9
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:30:31 +0000 (UTC)
X-FDA: 84526609062.26.06BF89E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF309C000A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:30:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oY6w1Fax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XL7pfplwsQB9mGuD6/uIqTAod6cCszz9L8NOP6nNNs8=;
	b=EU+5dYn7SuWopk3azyKzXVfxFzhhTLLDSS7vnA6bzp3nR/gkT2kDBd2fUZondCt83wByg5
	kl5n1N7/MySIF/uyRIpiq2NnfXx1p+N3CtthjSKo7S99OzyMqwKY4PtdxYyLhgknki3ReX
	mKL+Tz8d+3DgQpyNssMvXqGC+FVcHz0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oY6w1Fax;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063030; a=rsa-sha256;
	cv=none;
	b=YzkVmAdtqUCsL5YGYj9koxqvFC2w95FUEf+D/Wkui8xVOyF/thasWh1jWZKZSN6p1GCQz7
	oSaB3SXeDPbhMMPbDXNpvcwyqkmZH4YUxvJWr6bdffQ5NFhYnXe3FRlhAalF/9nKzoKRq8
	9/T6DVgiqalMGypWss8W75uuDkkIPu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DDBA600AE;
	Mon,  9 Mar 2026 13:30:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C0FC4CEF7;
	Mon,  9 Mar 2026 13:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063028;
	bh=pHTUBl9sBFyykK4Eah/JnIK0+m9Eam7vn9DiKahMACk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oY6w1Faxqo1ryMRKKYGCFAl8caqnd5hyil6uGr6eC+xao37d/1xo0R6NwIvbT7YGE
	 dt45Iy7bOH/SJ1ghSjlrCZ4aRVNc+3JFNo9MY0q2kbZKwuQ/RXXceuS1X4FUi42y3O
	 eJ7pbEuCxnBt2tzq60X4e/YAh0/ASmnimoku7fxdOZTIwFpUHCvTWTRbxiWHlSP8op
	 a65CECSPcI9N+bCi22a5W6+832EpyEfBGa8Fg96sYCX5DnZtBAAkxiam7Be4pzYTTg
	 82+KpwpjrHRllyw0FHsdCflOjGhFY8evHIZDcYWqeQkNpdzhLhtSAuhs7Ln377QK5c
	 bDrwKt7M59a5w==
Message-ID: <31bafdf6-aae0-4a38-bf88-463b2614b21d@kernel.org>
Date: Mon, 9 Mar 2026 14:30:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm: khugepaged: export
 set_recommended_min_free_kbytes()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
 <20260309-thp_logs-v4-1-926b9840083e@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309-thp_logs-v4-1-926b9840083e@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CF309C000A
X-Stat-Signature: hnmzsrmn18c1m7i7ydtjtm75a54616f8
X-Rspam-User: 
X-HE-Tag: 1773063029-346604
X-HE-Meta: U2FsdGVkX1+ROFTfNGl5fHyZNKBII15QeJGt3sRo4aor6dITWG/drp2uJBG/WGqQFXcSDgef8Nfsp4pRes0w7nZgGEl9wX0MbbUDKbCLf9lDarl2J4KELT6KJA4vgXgvFAVK4PY+DwMHBmNmjD7hYaq279QDldJ902qgdFinxGpOyR/w9MZVUKUzqYKoQyQEUiZaPYZmJWESButzN2vVaGhfT7fhev+OSP4iOW7lcPSY1SY80Q52qC3wLO0PfjUiYxlLFm1BLK3sBDb6H8CdspqPvCvC5THMCGtuukoZGeOXXBnnpIHhbN2EdNp3LKUtJ3BzPjZHmRD6O/88winKeOyFugpbEVOhsnmn780Yl726tC4w5uXUKc7oqcfpOhM7u71CADngmOm2GQEcqApZudaw3wTeFl5GecZRctkuGESxtX+sDB8DxWV1OHr21Q4MYzkmBgbSTKjDhaOiC51Q4SdCqCuMGr5dW4R/PfyTGQ6sPZxudSanjJcOGWDD+HYCoWICywQOuBgEOm6cWXOP9frCqUqAJzojn7b+h3qgYh5hG1qq9ZcMRj+RIqn1hXhHwgClWch2Epvvf2E16lda0PEnNsOIYob1actMJO2W6f5gf/YTmnARgpctOFaiN+wiIAHXwnhmJVNczYVMD+YVKs7FtvTaGZgaIKD5jtW39DXgPI0TPdVHxA6gzwypOmhIj5wTLNtLum/Dy7OAFFq8oeV2jW1UMV/diK6sZ+h7W8iOl23Tmqm6g2I/rQN2ysJb5aZXFEP/zhpdpgWoLXVgMB4JoSBXTRHW3ry6bwChl5Yk9UuCWyreglzncviJ5dO/BRHRzBSuzpmhgevwqEQqYyPJLHR5G+RSTHBGU6v+qyPIsM0wlb222ZxAn1Ut+a2hvF+Qkx1PRanrQdn+SKOMBSHRkrQ+yf2HVtKS2IZWfxW5wWK2r1ShX02lU8Vq7F9/XAACP9kvEpvz61G3El1
 uILKZ/BR
 8tf/R0uL1FDePtNjDFtfN4jKDPVWYhvx0K0A6nae2yqrs9f32SI5cXWeFgY5yRW3bxQaXK+KGCZgm7UzjMqgDGbwrbL/d4J9K+da6wiaGJm7Y3/6rbelUbGwPFBHMwES85j1eipbBGkyh7AiO08zRLcxjiruAcv7kLqWu8czocvZ5d9QE9c802j0OBp1pWdaV8gqMoWAoPB1gRWS71l9+OYIk74EM4edOUfBbu6Z9ajRkR0QZR+JgxiSNercn6A6eKSdoT9kz8HW0hx62o8OkHg7v62odRY3bcTeAekjov2jzxI7ae1SGSGj7BbMUMwb6ctDqmk7Ag0HenrPduOfpUVh7IZ/LuxLZO6ltE883hDA8WOHSIsjXhVqVojWWP2uf4qEc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 12:07, Breno Leitao wrote:
> Make set_recommended_min_free_kbytes() callable from outside
> khugepaged.c by removing the static qualifier and adding a
> declaration in mm/internal.h.
> 
> This allows callers that change THP settings to recalculate
> watermarks without going through start_stop_khugepaged().
> 
> Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/internal.h   | 5 +++++
>  mm/khugepaged.c | 2 +-
>  2 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index cb0af847d7d99..7bd768e367793 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -623,6 +623,11 @@ int user_proactive_reclaim(char *buf,
>   */
>  pmd_t *mm_find_pmd(struct mm_struct *mm, unsigned long address);
>  
> +/*
> + * in mm/khugepaged.c
> + */
> +void set_recommended_min_free_kbytes(void);
> +
>  /*
>   * in mm/page_alloc.c
>   */
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1dd3cfca610db..56a41c21b44c9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2630,7 +2630,7 @@ static int khugepaged(void *none)
>  	return 0;
>  }
>  
> -static void set_recommended_min_free_kbytes(void)
> +void set_recommended_min_free_kbytes(void)
>  {
>  	struct zone *zone;
>  	int nr_zones = 0;
> 

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

