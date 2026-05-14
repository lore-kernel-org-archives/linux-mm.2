Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4146CCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72AF36B00D0; Thu, 14 May 2026 10:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DBCD6B00D2; Thu, 14 May 2026 10:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CA1B6B00D3; Thu, 14 May 2026 10:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E92C6B00D0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:18:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0271D1202B0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:18:17 +0000 (UTC)
X-FDA: 84766230276.02.4417980
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 389E710000D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:18:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lCrlcOS5;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778768296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Udw7U8NEOe8VBRr2vcKKOP0dv7EjKft6lAXRk6WrK8=;
	b=fmD1mmZFjvSw8uIY5bBpDPM9Y8/xxod2R4w7HXgPIFzrll+FdNoDFQczv1A6R59rWLSMmj
	sei8U1hbyEunPYtVs+JW+Drbl0qCxhsoaJlVzw/hsyuSwbNxuXTX6qyBKJmjIsApWgYlly
	9wRNhFEeiarqcWBi/jFQG2dmHGYociQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778768296; a=rsa-sha256;
	cv=none;
	b=0MyMud4ynKROzl/8EfnD+rwY97z0JphDNKv1aPBbTj8iu6niTDr4Ty2Xo9A9M1YwejPGZr
	YOdqTuE/pBplA3uerX/40zzl3MKASHKqzozymV3G713zQidgFx3wnGTbdgAatXIWn9C4nq
	htsygiS6utE9MFd3LHjAGnMQxh+Zp4E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lCrlcOS5;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-512f09ecc67so56399841cf.3
        for <linux-mm@kvack.org>; Thu, 14 May 2026 07:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778768295; x=1779373095; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Udw7U8NEOe8VBRr2vcKKOP0dv7EjKft6lAXRk6WrK8=;
        b=lCrlcOS5t5hxTi/683JXeJxtiTw7swz2kynJD8oMkn/Lilu/krO9Tj9O2Hwic/BFeR
         vIPgodA9SUhDjagIEJkhkNRfT1FzcyllRLmyZyysw/rWxkMCwPlFnY+lT8ije33yWtkQ
         6Nj2wmGlAwS/aq+BHJtwtWLltsnTyBSAaAF2nBv/Xt7uVWi2/EA6tpd+VkAVMpX84j73
         50Fb35StH4foAeepKf5hKf47mcad/7MIYo4tnYPuIrr+OyqrZs/Fdc3Yvt9c04J7mVnb
         lPEfrd3bAHv1jjPB9SI3/CgP+diMumGGc7h2oRI21abv8+9TeE0c4hXBKwijW3DNCdY/
         xokA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778768295; x=1779373095;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Udw7U8NEOe8VBRr2vcKKOP0dv7EjKft6lAXRk6WrK8=;
        b=igHDWBt7HSXYyZsFAhkfSeGziYV8NvAwNPOvpoWjAxyxlE9jEMBO8lPumhCK1fOjke
         PkUDWYpq5uW1aYNfz5demoCOP3Tmdun1TDF/kj63RYe2Zm4NWu2TW8um4ozgsrbhZbWI
         lHkDerqQp1nnPlxxWrAfUIjF6Px8vtZZ0aUgt9uH++B2QSxxzyUzi80ApEpU+w/1PaDc
         bemTZdLXG1EZlPb9v2pS3G4PlD0uyA35S8wr7c7b1f59EWe7Ssu2eku0SjMM3Tuz0gdA
         lM/h3c5gLkeBOFEAIh29Pj+6/fgUdTzrawpSxB0S4qTPJZwqllV8moD+CvE68NWwsMR1
         6kbA==
X-Forwarded-Encrypted: i=1; AFNElJ+nD1Gw9LP/VOsrnxL7mZp4wyElvR8oi+tw15W22j1dFnAoDCDxwYbYF/jkF/MX6AKpKWEYJ2Z4mQ==@kvack.org
X-Gm-Message-State: AOJu0Yy5GykhfTmNQplOt7ayj//iBPVjDZLo3enHSK21iBS09x/qfYml
	k4ZZE84HkH8sShiXvYWFopDXOHuIIbqH1UTIvCqulthJiPWGtqsE+xX9Hz8BoS50pyE=
X-Gm-Gg: Acq92OEcQlT7n/t7gJTqI7u5d8CjIFNpDi1UeR/awLlnlGBF/Rj5xVH/bvS9MNLqQ+p
	rQAvDHxfQCzrzLJVdsZoSeBonbttF1j3NjW1UV23NQlFd+g+rmKJd5JYizaNKxgVahQLFu/7Swn
	xEbk8z5LHiX+J7cDHDVDvDjU7lFBfw4k/uLkk2cDzgzmZeM8PwzVc3qubKvxxCVqBzenQF6OA/a
	Rf6+Ks3Y1RrSVk/MkP+F5VBd2KAcSNa+Jy7e9WmWwZzrTIhmDGfe3sO40k9Ng76LOk63O2wkUPI
	LH9XSPG+Z99m8od3jKu/9qBjb0qZM5pRTwuVtXd6DlLLjKTPbvq6hhkbESEClLr2prqWoyD7Fgv
	s8Kb4/O6OmY50AyvZh1DqwtE5qQR3/IIEMByOELmvNeQxYVbaLw3XvRJPPSe3+8UuyFY0Dgm0eB
	DDEcdPk+u7yhcWckz+gKDqE0aJcoXYmmQQri7JkCnhBXXmmeUSxIS+6keqSsrinLD3euQsFvbGX
	4J5U9Emb+NhGIiP9rogHlE=
X-Received: by 2002:a05:622a:13d2:b0:50f:b904:457 with SMTP id d75a77b69052e-5162fec90b0mr101142431cf.25.1778768294997;
        Thu, 14 May 2026 07:18:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516460cda02sm17671591cf.18.2026.05.14.07.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 07:18:14 -0700 (PDT)
Date: Thu, 14 May 2026 10:18:12 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v7 25/31] mm: page_alloc: propagate PG_zeroed in
 split_large_buddy
Message-ID: <agXZpHKe6zwxnGgr@gourry-fedora-PF4VCD3F>
References: <cover.1778616612.git.mst@redhat.com>
 <2db0d124c647e711c0bf95b1c7f1316a0d1408ae.1778616612.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db0d124c647e711c0bf95b1c7f1316a0d1408ae.1778616612.git.mst@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 389E710000D
X-Stat-Signature: j9t1pym8rxacrtiq4ksnusrowrw9awgn
X-Rspam-User: 
X-HE-Tag: 1778768296-379191
X-HE-Meta: U2FsdGVkX19qTPyN1VgGqO6y2EW2SmqQQzQrYpM+JFUMtmoM3bHroCNAfE1qKiMlLjuWbYU+OL2ijSiwajb+/K5TMJHvnvS0wI56GZTyGrWbJkhU1qLOS8JBW63p8+ZZ9Pg4GxaxmR0HqD1/ufdU9T9uZrAfMo2m9cz6uqxqre2eqObT0kuNVmLQXPXCNAD1YWRqgVNXVkI7JQ5pPr0uL3Csqc2sRxo+6/H7CAo7bIEV0gXTrPMutnTyiWCHganZiLMkauQajW7CH0I9DUYScy8vQxHebrLRqxbnWOTu1rP5vQJJA0K5h9/IfxtGvsRkanXXAPgUibtMdDmzgsd9zvD44yZC7YU9ipBZ6t6KJciGJAz7VAADQgEDHLGvY0Lo/V38zZRM5/uCQF/EMbnlkIDTEVM/Ij1yNmVOt96lZHfwGMbburkbsCWnaopo4pK6U1iWj6lq2yu8la0sLIUa48ZxwDFp3IgFleEjG1y4dHckdqCdSo6O0OMfXpKoqrTsbv7tbxi704kjn3KemhS9KXO+mGj1Z269GyWQPuFEI8QDKM19QNIW/PEIvX29zDFHb6KaToiosp++CMtCyPJGK/7Gossay9f+ACKEXJKZJJKyjvpuD5OyxduOuPxMJ48ieRGj2VAMTaK1oEvt+LLB0+PRNaN5hYnLgAs8WutBOE/LE5EbFZ0OZFpREIq14ZATtVLg/UTVXk2j5y9zzS7IqDkrDACybuto5cXtKmQfOf+0+LMiy1Y2jXKFoZJK3BZGpqCMydXoQgxXQYSLCLPhM5tz6S0iKS4Qvog/TylITVb9dz/ZQDywcCslf48UqmklBX1T3kVKQrWWceRnxT83iNOHWwuwAfi/qENM8KGCx/PJ61IJ67jBI61hUkVQaeoKxyrJSR2k0iX6/zdZND/mb0rpQo9BVjLRmKCs/oBYXsFH1Fm9loNq0dyQekN3spadcRu4eYOEoIOF6cU53WE
 FDAJFByB
 Kg+ubNC2kadRCjVv3UdDvGrkTZNkSk0tleLjJF0OWDpG/VM5masbcTN6uoFJQsBLlZfjhjy93xMB+Ph9ZrPCBSHv0okOwi+sxmRVVKPcrWvHKAzFBHKqrqD+LhnDxdl8V7HW2OGXEb53fzITHRsxtBTHUb4AnObrnmuDKqybt3BVUPlbz2dUkLY3A1Vs4WQ0FgeqbINRpLUsQdF4XDToC8t7nwBY31bAeRXNHcC1c6xvzBrMtha4MNy9KgYAk2kCpwp7EITb20h+X7AND0FoYxR00n1W7ANwxQdcNZz2deZe1/4JqM2qzE0YiI8Yi+sUYxkCZPIql6RZMmc2HECE5WdHNmpTnj7hpfKA0DWk8iG4/LKM2jB/fjvcHaeoeH83qaZfUMWB4u7daT0THNV2EHSkcNBElpWPCj739Zrdhy3gKQbwUIBiuuLJaMuphgPEB0dHWQq15hFcDiglc1WC/h1mlAduvPqNRl1//upiwrZLX5oO1eawFIqi0Qoz5abWN1wiTq9YPcphglOaAaqenEP/kJthEXWZH6eXUTYP2UFz3Y8b6oCDqQf1TWtLi9TJDqytg3/LcpwsZjtpOt11tWq7xoyAnpZZVyX7Q3mi6eT9OKssCpWRbIKvqNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 05:07:20PM -0400, Michael S. Tsirkin wrote:
> When splitting a large buddy page, propagate the PG_zeroed flag
> to each sub-page before freeing it.  __free_pages_prepare clears
> all flags (including PG_zeroed), so the flag must be re-set on
> each fragment after the split.  This ensures that the buddy merge
> logic can see PG_zeroed on pages that were part of a larger
> zeroed block.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh

Reviewed-by: Gregory Price <gourry@gourry.net>

> ---
>  mm/page_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 468e8bde7d34..ce43f5a3dbaa 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1523,6 +1523,7 @@ static void split_large_buddy(struct zone *zone, struct page *page,
>  			      unsigned long pfn, int order, fpi_t fpi)
>  {
>  	unsigned long end = pfn + (1 << order);
> +	bool zeroed = PageZeroed(page);
>  
>  	VM_WARN_ON_ONCE(!IS_ALIGNED(pfn, 1 << order));
>  	/* Caller removed page from freelist, buddy info cleared! */
> @@ -1534,6 +1535,8 @@ static void split_large_buddy(struct zone *zone, struct page *page,
>  	do {
>  		int mt = get_pfnblock_migratetype(page, pfn);
>  
> +		if (zeroed)
> +			__SetPageZeroed(page);
>  		__free_one_page(page, pfn, zone, order, mt, fpi);
>  		pfn += 1 << order;
>  		if (pfn == end)
> -- 
> MST
> 

