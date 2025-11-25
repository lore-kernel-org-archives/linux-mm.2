Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47602CFD364
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 07:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C6896B0010; Tue, 25 Nov 2025 02:59:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9768F6B0024; Tue, 25 Nov 2025 02:59:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 865E36B0026; Tue, 25 Nov 2025 02:59:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73B496B0010
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 02:59:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81BB65B267
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:59:18 +0000 (UTC)
X-FDA: 84148379196.23.ACC238F
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id C9287A0004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 07:59:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IIMom7tu;
	spf=pass (imf15.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764057556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKqZiJDOWFEUb0Jp+1ShtqT7/k/ZLsdTXzSUzv5zXso=;
	b=lStSoAOebiOaAnhfQtCITEZ6DNhKC+EX2ZGDF12kXRIW5b3LQ84xFlB1dXBBqllsCgTP1L
	7GNKTrkfJCeSJLRvWGOt9L24mjulOAogSOpQ4gX1CiyynhIbs7QwvrwtVQBX4U3YZxq+fh
	qJHI2j8zv26rQEAj/Y7mk1m5f2u1Z8Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764057556; a=rsa-sha256;
	cv=none;
	b=tkt5X3c8TcdvHHWq07zhUghCheHzjbmXGrWF319BPt5rTCwVaLDDvT6g0ABG1LdjhwNoSt
	/9Z+5RERTV9HKorlewNkxkALoRho0iRnTNQmfix/JODUIHEP5cxT6E9O2smLvzgmhU3x9p
	KaEzLbbHNryh8WlX4upxZrbmQlDgjJA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=IIMom7tu;
	spf=pass (imf15.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764057556; x=1795593556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RGjxKJ2ZxAiE5osguDNbbjhtWqjDFmM8MSebv4rSgVQ=;
  b=IIMom7tuaYvt+mHuqJH1lwFdIeH81Iu0mpQ/hcaiObzaTyOxw1hoyIVg
   Xn0sQysYOMswe6OVAqQjiSYG/vT17ckAFW59SgU4mrOMSYnw84neywklU
   /rU1I5UHSr1i6UPhcvqTw9SaJB7RGxwvvKI/slo5qQFYJSGdGR2UGJWrE
   kHs9Rkk3jfddCwKOmy50pYCkjUemRr1Et0KSiMvGyUqBAcJJbDC6NsF0F
   mozcYrbLYrS03WMsVFhiA2LZimLzBubPUzVSBwq2ZxMKSpc0WmQFKXDcg
   W4QP9jdVye/ugeLxZEGxzE1dDeJ5MjfbIXA3mVrFnKpmvUjP1rm00zU6P
   g==;
X-CSE-ConnectionGUID: 7Rhg9cITQbSqnp0h4lTDgQ==
X-CSE-MsgGUID: MXvxavEKQpKr3ZZdV2FVgg==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="69925593"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="69925593"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:59:14 -0800
X-CSE-ConnectionGUID: ZspEYjjeS9izC1yNOLqMnQ==
X-CSE-MsgGUID: aM4gg/PKSemlzoUv5gQjjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="192647450"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 23:59:09 -0800
Message-ID: <ae535698-33fc-42a1-8a5a-ed8dd192f697@linux.intel.com>
Date: Tue, 25 Nov 2025 15:54:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] drivers/iommu-debug-pagealloc: Track IOMMU pages
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-4-smostafa@google.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <20251124200811.2942432-4-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kb8n3eezsp161679utcotf47d3ubnjze
X-Rspam-User: 
X-Rspamd-Queue-Id: C9287A0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1764057555-136328
X-HE-Meta: U2FsdGVkX1/qvgT/Rosuw29qRWcwb54WFi2FcDQXGnT4PbBOobVq1kyIMXWTzbaUi6f9GFxLqlb+zYhnDc9XjTXFXaQDkxDqvesrNjxeV0Sug8Htr6kWETuCO0H1knI+rjEKLIFopCx0TWWrH5B39hBj1gNdKdiBbEibQDbBha9hKcyzBHyMkCHa9OVRy0M4sFKYTn2XQ3QyqYdVnfUcR7wqTRbn3NsHC1tm0sCojpA9lJh64swiMmMOJfPXQ2E4EvOq5jZZ2gYmZt/X6EThEmUv6n1nQh7dCeOFodgPv257i50leFwFjrEDPKP1GptH5vovoStR79RfwRWAYNpjKaSrg0TyfXXFiTCTNdx4mIEMuagKIdOx68lpx5+vufXmQwb2cU7r2AvKFi47pi0aGALm4BSgT0rUhNa25bq8MVePPxIWghFlw51kb2UA+r6HnmZvwM9yJS3+jvyXnLOiX9tYlezowprO85NWK6VQ6AfKb8Tw0ObeKBTVR2YbcKSsCCp6JUSgCfC6LTExea8jQWNUE0P5ZVMKn2ZcCLa5WpH5lk1CM6JVUMc/Atxk4WErddm9PSgvnkMTrEUfpf9ZD1SVd4b6laNP9mkF5oRfGNcJwWeqAQDPjPFOTmQ4nlQ5RHqFnPm5tZXcM6lV5yUET/ikywyOOeeLmQCGUMUUgkVZuCGJ8mAj4XuiW6pEglNG8ACDHhiO2pB6Uk7CqQmS2WlHnFr/XsM2/me26nMRbaRESuUlduvKjAcyPl5w8Jb0XsERMPnkVGKZhICGq5ZuawbZdd5He+dLAUccN5EMIkdro0UFT2MZItr6hFNg3+Lgg3+HaFDoq3piM2cyJMOjBWvbVlZyJTo1DhM72/82+4c8O+SWcPZgYREh/Lo8KIbUmuaqG87LgPS7jh31v9YvajAbtE2Zv74TSKcaflrbuJ4Wv7w/IVY4hyTewdYtXRTJlRAoCoL6YZ12plHumWe
 LJpRJ7NV
 ruMyNx6g70u+zaSv0aB0hz5VyMB/1O2axRnHS9qHVHlv/Fg3SzWhVaZDsrIi2AEPv6TE6MGOLvFTIJf05qYLJDmueFkAG0/0JyHXWHUNAcBEAe1hf5p+uIxp/Nh5HFhNJVT1pyiQB/AQk80KDhkAqaP3N6WdNYMkJ7nCjAlkGApWKHCmTfyI9iLtTIOWRtMKMj5OXydB6kBb4piQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 04:08, Mostafa Saleh wrote:
>   void __iommu_debug_unmap_end(struct iommu_domain *domain,
>   			     unsigned long iova, size_t size,
>   			     size_t unmapped)
>   {
> +	if (unmapped == size)
> +		return;
> +
> +	/*
> +	 * If unmap failed, re-increment the refcount, but if it unmapped
> +	 * larger size, decrement the extra part.
> +	 */
> +	if (unmapped < size)
> +		__iommu_debug_update_iova(domain, iova + unmapped,
> +					  size - unmapped, true);
> +	else
> +		__iommu_debug_update_iova(domain, iova + size,
> +					  unmapped - size, false);

In any case, could the 'else' branch become a real operation?

In the __iommu_unmap():

         /*
          * Keep iterating until we either unmap 'size' bytes (or more)
          * or we hit an area that isn't mapped.
          */
         while (unmapped < size) {
                 size_t pgsize, count;

                 pgsize = iommu_pgsize(domain, iova, iova, size - 
unmapped, &count);
                 unmapped_page = ops->unmap_pages(domain, iova, pgsize, 
count, iotlb_gather);
                 if (!unmapped_page)
                         break;

                 pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
                          iova, unmapped_page);

                 iova += unmapped_page;
                 unmapped += unmapped_page;
         }

The comments say that it is possible to unmap more bytes than 'size',
but isn't it a bug if this helper unmaps more than the caller desired?

Thanks,
baolu

