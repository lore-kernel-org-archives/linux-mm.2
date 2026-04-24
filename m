Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F27A5FB44C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287A66B0005; Fri, 24 Apr 2026 03:33:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2126B6B008C; Fri, 24 Apr 2026 03:33:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08BC36B0092; Fri, 24 Apr 2026 03:33:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E70536B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:33:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B2E4A06CD
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:33:55 +0000 (UTC)
X-FDA: 84692635230.03.6327264
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB3C740006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:33:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ET2IVhVP;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777016033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3emymLQKMW5KNMhf0/v5WxkXv+ccDytIAO46/7sqmQ=;
	b=s3sHOFOhpEmWvKMKAPAioptBUeJqwyHrGvol4M+fmwRSprMmg9RS/wHOfCZbT0EyMVIM5F
	pZ7/Sh7exfdo9c+Ns/mOU0DO5PYhrbCvsdM6ls35QV4LfOiDBq1o+YcINfcPpqcfRVQJyt
	7T0vHu00sjcG+uacjrMe4mVpF4gy5xE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ET2IVhVP;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777016033; a=rsa-sha256;
	cv=none;
	b=7a/XNlxSi4Wv1I2vdMp4Q+ot84WL+oVO6DxYRHJprUzBNcCBlAu/+c7W27gWBD4QZoEI/K
	7yyqGltLakrDnelE36KCZZbTWJMRVjoGMHSbecNJhJemTY2peDyRm3c4vrjkhfSuN2xJUE
	K/wEIeS2JdXZc8LkeKb6yq0RgNlwukE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 06B366001A;
	Fri, 24 Apr 2026 07:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E265C19425;
	Fri, 24 Apr 2026 07:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777016032;
	bh=FWUCIjlRnfU0ETPJAkdUekHGrm29nbNvT4ou3u2ZJrI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ET2IVhVPW1Je/rflovdV0szP2Nft7DLDtK4Cjt8gOa3tlrF0PYvVAsdr0AtKcI2nw
	 Nq+tRJktHRoOnrRgLjk5Kv3ysZ2GmBvgxsuvvvVS0TTGEE7lrAaIzb149j1fee4kf4
	 suHj+w2LF9Z9O8b/zefIcUsWF1YP8BPRUf94MHKp5vYpn5HZl+5iwfqHVhO9BKX13G
	 TokYxhGt++juL6hzDh2Tme7OW4r63MYtWKGLTq0MG3pu3l2XBFHr7Tbi8btjUy7Nuu
	 Gn8N/LHbYUCbRCqqvn8DuTdr5+LOL4DK+dRWxwDt3pTs3GTdLY10KD3DuG7COGtHP1
	 QTWokFnUqoNtw==
Message-ID: <0fe62163-cdfd-47e4-bc88-df7a69dc5a6d@kernel.org>
Date: Fri, 24 Apr 2026 09:33:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 4/7] mm/sparse-vmemmap: Fix DAX vmemmap accounting with
 optimization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
 <20260424025547.3806072-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260424025547.3806072-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: od4oc1muxtqk9t1sy4bdjfyq57ceicga
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CB3C740006
X-HE-Tag: 1777016033-377460
X-HE-Meta: U2FsdGVkX1/IqkQXsJEeaqXfxJUMNRTZ3OD7draVeK0HZ30ef1eJZPmooNTruW4v6uECf6hsOvdpYnniFX6YNsp+Bk507Xr2CvBbzMJDsVweDNclsAkqEUCeYIz0POnY30R86JW8BA4IhR5R9AqJ/6SP3xyxWfk9NuwrVm7yWCQ+c/694jUkfUUAfm405f3WsKe5pbFHZ9CBnDTVVy/8vrpshq3mUEU5B8rPVw06dgjW+QKrwlTwtsfUqnMPPpa+aps0/Lu7DxfAffVaBj8+hNAbqDYcEtnqerAxIR5mJrpLtV6h3jqgyUZyWxMhr9FGRc+ozNzTPS81J1OV41S2TF1d4Oby9jTp6KQzL39v9T+3JWNWTnUvpZ6VflT6KWpTB9dbXYjT15l5bB4miFuJkaLJw3uWNI+DKjBaXjHJRyUr39GEsGgv/hYKegLWv/KJL0M+nhm1SWVSds8KCq0c3E/e5Oa+yWDgss3wdQ0+cbcO+mVn4PBXuT4gHQ+6U+T+W0N1bIcK1hRsryZMsg2AU6dV1GtzTZtt2WIQqXDld+x6gHye47NiJ4m5WkHLZo7Pzd6a4Zit6u/torih0tO51Itt83HnAGSenye7xQ2rRcdjRe87CigUO3VcaqDQQOXgmS8bZm4yDjKRfOLxGgxcgc2mHUZU+RFG5lI+nIUuS428Vya3WEPMmwhi7pSSHRK1+u0ncTeHiYlQUlacNqgPQ5q1ne7NlOEyDgd7/hSknsWTHsKrPN9tY1YYDTzGLNHrRFffb5ICkbZsnS5j8uGGkmDNeLm36U9oGATbwxmtEvJqixlLtdp0cVwXXPr5lSxu6jAx5gfDnNU+tuWors+wB3wVmIr1Kllh7lMgpOjj21L/RcrL4uILZ3PiAtx9ZsKD2ZXUVDlMaHwA/L2v8AGZFtSD+LcXVfd37UN8HiAIRY02OwXzqpC9JHh11F1DO7uRhNBvb6YYDc01KP3QTvX
 pRiqy/Kn
 Ti/N2kr4YXnxH4uhhfmH7VPx60VldwgrWrX76rBzEBEF2TrPExU+hmb5QVVzbij3WSdjORWP8mK7CiXDmDOkm+Hczrj3CApuyRPbZb0PBUcCxXEV3z4fL2NJCyajlQoBvSAmZ3OI/1n0qDLhv1eHquZdkrRc6pYgCeJ2wFfux9rltpLCP24bnSe+leqoiY2vGQzoIUxuoZTOu5kmCszXNZ7sbyCH0GG8ODiXvHLwXMmQYhUVHgKFIJw/xrrE6TKByOA2LpO4RUxee5pXNFGNhmotfixqq70uFEMmr3dfKrBmhB+diLV3PrWXNHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/24/26 04:55, Muchun Song wrote:
> When vmemmap optimization is enabled for DAX, the nr_memmap_pages
> counter in /proc/vmstat is incorrect. The current code always accounts
> for the full, non-optimized vmemmap size, but vmemmap optimization
> reduces the actual number of vmemmap pages by reusing tail pages. This
> causes the system to overcount vmemmap usage, leading to inaccurate
> page statistics in /proc/vmstat.
> 
> Fix this by introducing section_vmemmap_pages(), which returns the exact
> vmemmap page count for a given pfn range based on whether optimization
> is in effect.
> 
> Fixes: 15995a352474 ("mm: report per-page metadata information")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---
>  mm/sparse-vmemmap.c | 31 +++++++++++++++++++++++++++----
>  1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 3340f6d30b01..2e642c5ff3f2 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -652,6 +652,28 @@ void offline_mem_sections(unsigned long start_pfn, unsigned long end_pfn)
>  	}
>  }
>  
> +static int __meminit section_nr_vmemmap_pages(unsigned long pfn, unsigned long nr_pages,
> +		struct vmem_altmap *altmap, struct dev_pagemap *pgmap)
> +{
> +	const unsigned int order = pgmap ? pgmap->vmemmap_shift : 0;
> +	const unsigned long pages_per_compound = 1UL << order;
> +
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages,
> +				    min(pages_per_compound, PAGES_PER_SECTION)));

FWIW, I though the right thing to do here would be:

	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, pages_per_compound);
	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn | nr_pages, PAGES_PER_SUBSECTION);

I don't really see how PAGES_PER_SECTION make sense given that
PAGES_PER_SUBSECTION are the smallest granularity we allow adding/removing.

Also, the "min()" implies that there is a connection between both properties,
but there isn't to that degree.

If order == 0, then you'd only ever check alignment for ... 1, not
PAGES_PER_SUBSECTION, which already looks weird.

So you really want to check "max(pages_per_compound, PAGES_PER_SUBSECTION)", but
just having two statements is clearer.

Or am I getting something very wrong here? :)


-- 
Cheers,

David

