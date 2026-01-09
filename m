Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B53D232C5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 03:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B40546B0088; Thu,  8 Jan 2026 22:28:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B190A6B0089; Thu,  8 Jan 2026 22:28:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44E96B008A; Thu,  8 Jan 2026 22:28:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94FE56B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:28:27 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E97F08B780
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:28:26 +0000 (UTC)
X-FDA: 84310992612.05.DFBF141
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2109880007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:28:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ECAPy3G6;
	spf=pass (imf02.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767929304; a=rsa-sha256;
	cv=none;
	b=x90v2chELljiWWh6t6Qw6aGqwGrsOD2DIBYayy5H7DCqd1z6xxjtM9o0vwX5WRjm5jHIWf
	GXttECq5k/0KEFHjK6qf/OynELpLPrRlJ36XPpkSE+NrV+b7JtNr3lIj7DTfGcY8hYuiOG
	XXEQpTdPq8DfnVyq9kjS/vDveuNROog=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ECAPy3G6;
	spf=pass (imf02.hostedemail.com: domain of baolu.lu@linux.intel.com designates 198.175.65.17 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767929304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=934FMIAHkZdmG/fzMaUyDBNki9zD3MykHmfZ8LCMxGw=;
	b=fkJQ4xy7gR7x5UW6eqETfRv7Mv60ZIk5Q0SxWyhd6nRtjGNwbIsuHg5TVfmtWOXZ5AOYsx
	Iyb5+OwURtllGWzWmEcXOVi7bTAIvWtBfeQGH3X+0P5zQGangFjjvpiJREehFUBB9v0Dtn
	BNx8bmKIb5jUd/44XKvK/g6WM3tMXiA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767929305; x=1799465305;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=y4tYwPF3ZC63Ir+4yC1KcSfjvehP4llbqhsh9Bjl7/k=;
  b=ECAPy3G66miSAeKnSizbhwINhK9R1W+AUphclGN4ns8+CBLu6XNdxl4Z
   wM1vppiFj1zR7whBnZnTgFIDC13f76QMVHxR4C5DoU7w0Xb8lfZzDRUDT
   WZIZ59pzuQf5iDgnbciipCWYzZDpEPkMZ8iPm0XqBF2uRHih2hUmF1dWR
   xSY9fXYui+WCn5Uh5v+qh/fjPqA/5shacBbHuSoPYfa9vr/Urm2lg2Z7a
   GqIEA7/rjMb1HxCJdoT3HiEexKCyPifjk7kOb5uGJxhgehJ/jYdzKEqnF
   +Ze5OPWZtIHVrGqagVRA2Wch3Z9DQ4oL7k56HSsNUZ0NnnvtXBIsBjGrx
   g==;
X-CSE-ConnectionGUID: we5iJ02SSQumsLi4EX6dVQ==
X-CSE-MsgGUID: ES7HiIaQT1uzNodXIGQ3Yw==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="69296295"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="69296295"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 19:28:23 -0800
X-CSE-ConnectionGUID: 2d2ZBL/rTb2r1726moL31A==
X-CSE-MsgGUID: A7Och2SKQ2eaTHkkLOcU4g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="234075920"
Received: from allen-sbox.sh.intel.com (HELO [10.239.159.30]) ([10.239.159.30])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 19:28:18 -0800
Message-ID: <d6236413-7385-45c5-94ad-8b0f2007f1ac@linux.intel.com>
Date: Fri, 9 Jan 2026 11:28:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/4] iommu: debug-pagealloc: Track IOMMU pages
To: Mostafa Saleh <smostafa@google.com>,
 Pranjal Shrivastava <praan@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org, will@kernel.org,
 robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
 rdunlap@infradead.org
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-4-smostafa@google.com> <aV56BWisUQTMK2Gk@google.com>
 <aV-PvBqQ0Ktiha8e@google.com>
 <CAFgf54o4Ja7jQwxo6XyW+JaT+aUuj3O2dvLqOTb+YSVCKTdvyQ@mail.gmail.com>
Content-Language: en-US
From: Baolu Lu <baolu.lu@linux.intel.com>
In-Reply-To: <CAFgf54o4Ja7jQwxo6XyW+JaT+aUuj3O2dvLqOTb+YSVCKTdvyQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2109880007
X-Stat-Signature: ar46937di3hmt9igo1fckf1wiahsgipf
X-Rspam-User: 
X-HE-Tag: 1767929303-495549
X-HE-Meta: U2FsdGVkX191nX2lGojtMF2deipHibgILBNy8c3AnSnmlp6dDhUOO0LfPYuZcBHb83ESrxNBfemlmLLe/7JY+8XmOWBBhtR9XRq51cpFEZ1UhdvZXIuQ5GD2vg2JpHtLLfAP0CEttoJv7M5OnrAVBb+a/zljdizYNrPb7EmGQT3O3JqLkZ58tl1MuRvRCfA70vM7rNzBWTche5Ugnjzuqq8WUTvXxMP3bz1J/1AB6qN80qw8zHj/luoWHCIXTwVSzLovrNDdcKhBig+Qbu4W1oFG5fGno1wrt4ITSbDCZGCCo0lA9yVj4fiHNudeN4NmqmbxgsYKw4T3LfTWjpTz+0zFAPs8+upVsBBN1pDYxrefhlDmSh0ERymIelt8q+RHvGnWNfRUv+Y6//6sR5FM5rZTKGk4VArRF+CqBnQEGeiTY3xGUG+M929vAspgizMI9Moq2HqtAK2q2+ByM3uBbtSFob6DI2/edu79DVknOiSqcbUv409aeM5vHCPEkCWi+7yGWcUAVA992tYuKCSrDSfQ+xDjPQ+lf88C1MzGEm0vG4ewCwQBjYEtRTi+webY58TTBxfAI5iGhA9aZRjptod5xrXvKIYqZ4Xd+P1PisIlGuNxjJExnKpLwZdcteIkwVAELTTg+PloMPuJrbLqqCjysUusuVzbhWde6SNSMq860g0vqnrx6ero244jciUGJyM3EaSQnS0mb8HbIP4pSdUowk71hj8t1Tpp2VJqI31MJPFWwIHtMy8iESAdbUfwNoGW3tY5SNLYRPg4ColqZU0EuDGt2JP3pbmdxiiT5sxjt5ksJVy01ltUCEloFBuNqsEJzhWz8t/ZWtHhr0bDTzvR47U7k5F6Tjv6qNzgJV00VFSbp9Po2jfpW0LW2reTtDtuGzdhhaSCwT+zC03oRd+ZW4dPRgQ2F8Fo2iE1D6l4qw931UhCIkBJtNB72x7UOf/dxRk3lCJ2MkTxznm
 Wnpo3xPB
 tWoQujceo8ZQy6/Nb1+/+mOCmUsvkVXV9CYe6PvM9e08TrSwWadA8WMhQ+9V1e36naZvvn2qNu/8vFkDrth7h6igz8pC6VNc/yyUjwnnUhrM/fcrcu6KaCLwxOdXaXFq5WXJCuHeo2u3g+ShZVrr3wIIad8yNJzRMhBFQncF+xtOru08uslRP1TzRdd95KvZgm+dWZB6q01iW+bw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/8/26 19:33, Mostafa Saleh wrote:
> I have this, it should have the same effect + a WARN, I will include
> it in the new version
> 
> diff --git a/drivers/iommu/iommu-debug-pagealloc.c
> b/drivers/iommu/iommu-debug-pagealloc.c
> index 5353417e64f9..64ec0795fe4c 100644
> --- a/drivers/iommu/iommu-debug-pagealloc.c
> +++ b/drivers/iommu/iommu-debug-pagealloc.c
> @@ -146,16 +146,12 @@ void __iommu_debug_unmap_end(struct iommu_domain *domain,
>          if (unmapped == size)
>                  return;
> 
> -       /*
> -        * If unmap failed, re-increment the refcount, but if it unmapped
> -        * larger size, decrement the extra part.
> -        */
> +       /* If unmap failed, re-increment the refcount. */
>          if (unmapped < size)
>                  __iommu_debug_update_iova(domain, iova + unmapped,
>                                            size - unmapped, true);
>          else
> -               __iommu_debug_update_iova(domain, iova + size,
> -                                         unmapped - size, false);
> +               WARN_ONCE(1, "iommu: unmap larger than requested is
> not supported in debug_pagealloc\n");
>   }
> 
>   void iommu_debug_init(void)

How aobut

	if ((unmapped == size) || WARN_ON_ONCE(unmapped > size))
		return;

	/* If unmap failed, re-increment the refcount. */
	__iommu_debug_update_iova(domain, iova + unmapped, size - unmapped, true);

?

Thanks,
baolu

