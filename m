Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E8C5CD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 20:14:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49CA66B0088; Tue,  2 Jun 2026 16:14:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475246B008A; Tue,  2 Jun 2026 16:14:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A686B008C; Tue,  2 Jun 2026 16:14:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2636A6B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 16:14:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11F2B40133
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:14:46 +0000 (UTC)
X-FDA: 84836075772.02.432F531
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E13A1C0010
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 20:14:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CeC4PRz1;
	spf=pass (imf21.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780431284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXf/DhYEKv4KfJHG3trdQ5N+MNYdsl2DFczEDRjtzB8=;
	b=q7WjcKtpsh5bEH3FtQR/mqvCor3LqR+ojhB9IC8nQROBX9hyQCD9US9q/EUU95hwEL56R7
	MJJUfpbsIDsNv/rRRbpD/6qGFT4/htOn1Masn4AE5zg3qH6CFFOY9Z3St8gkH1851lXero
	rMK+vS0D1pCGPlnSqr54lCV8dELMnaQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CeC4PRz1;
	spf=pass (imf21.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780431284;
	b=dPwNyniureim66E+H99GveSr4SM8gZL+mDmtKPmz4VAvugL1JDJ6cj19FdbUT3NQnA5kk6
	eUnV+9AJXUoFTXY0VJS8O0m/qQ/boeZXGlCtBwdDw8UUMXtYx5b+FzMaH81VTWSJ0P9TEI
	+IA9L0ZguYeWLRTGw1lYwUlbyg3Zv2k=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2bf2d865383so4805ad.1
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 13:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780431283; x=1781036083; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AXf/DhYEKv4KfJHG3trdQ5N+MNYdsl2DFczEDRjtzB8=;
        b=CeC4PRz1HJsNRx9qmdmY63z25kkMwlrCjwK3FuO+/IBehsgXEKGmWQ8s4Vea0U+2Il
         982BdA9ekxLb2Nx9vhd6ZmDp/bkT0nqmg582BNy94qwSOaMCX6cl+YaIzYxznUiSypqK
         Nq3S6rsAhzy/0vSvEiT9s9hN8tpoILeIwqlovjMv3w8jqg/hJolAFwYORocB0g4dyrXt
         I5cgZyWMR0yTe6vwpSslYXfD+wIpx7rb6ZbjMxkjQVxTEYvZ5ucfa8lmQfJMJhgUgDaG
         Y1pX5gnD3IfoK3But8O6aNYHgBx+tdSAhu3NHhBuPP2eEbrfXbB/ap/CONy0VO8ouoLT
         l/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780431283; x=1781036083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AXf/DhYEKv4KfJHG3trdQ5N+MNYdsl2DFczEDRjtzB8=;
        b=naXBE375LQH4as0CP/zhJiayJ+cAmaBdNN0NYOJUaVno2p72fCcJyNfj4QuE1O23mZ
         ky/aEyNdijtaWRx/Oxl+C2f6DXmES1B9TRRV881sIdBmlFnFai3TCduN16+0fFofK32B
         VrGDvne+w/OqVKHboOPBfn+tW15TQDioxTV2ob2QsVgv+D68qLJKikgo3CcZrJ2yF51e
         RvWG1G2iR7KPLtKKyfXF+R95Q7wSWnJ/n7RukxuRLwv6zzjA0uxywe0OR/i/gn1RENys
         CZGAstkNw613ZxRjtDaidQtu6drl8OBEI/ivEq8N4chyhqZxhLGpje+f+N9jj0pR5QEH
         +OQw==
X-Forwarded-Encrypted: i=1; AFNElJ8u0SutkxzhJ83l/4T/qNfTDy/teOKl2TyZTG+w0rJPWJQDT+hJ99o2AP2bxd+lM+clR/OT+SZO+A==@kvack.org
X-Gm-Message-State: AOJu0YzO9hOPbyEbAHJGRmxP+RuAY0nyViMtPe1dzypG4y3UEmd5UX0C
	uYZQGpL2FS8hRcp+tBtz3eiE4aKqVpALfQPp7+sTvEV+YJNHVr2sPzbiiStv0LYbJw==
X-Gm-Gg: Acq92OFyxbmSo9Tyn9xmDhxRE4MVsRhDZaZvHtF3tOcVGV5R4kcbFYyJ/QYOLCTdnHP
	CcmTAPYRL8rLe9ULv4YzjE/uRLyIz+EVJt62rb4aqW+WskNqfhhHXsskn/3VvYfryZ782O4e7jC
	xrqQBUV7JQb6Ys3JOjTFRi+KgYe85GQkm8xA3NaAJDMYKtWGpeO0EhW841DsC6R8SBj29EBerwy
	9e+0Ld01l4ym9MXxFdzzYLzV1mO6lu9OGohQ5pxyZCmTP/AfCFDpiL0LlDoTSBIK8rVfbtnEfIf
	e1PW3nHZD+wbKQw7FKEvbeKLtzWIMf0cItkr+u1cpIKgfMfq0q0gVZuD5Ttxz0lWTkQxSZqFXxj
	p5MM33Vc4hZQva0xK4HYcn49/TOIFsyyagPAKHLFdmKOxD4FExJGO7Xid45xug+vULi10k2XUOn
	kj6p4JTgMNKzCLYzj6Fp6g2TVx0kIftyax6LWGOU2B/GAjrtGMhMLkAsFy4xFHZYdRqYVMv4O9N
	+oSLyMHAC2KV5yKY4fUo//MrM9mCQ==
X-Received: by 2002:a17:902:f70c:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2c10e8606b5mr4060495ad.10.1780431282360;
        Tue, 02 Jun 2026 13:14:42 -0700 (PDT)
Received: from google.com (25.75.145.34.bc.googleusercontent.com. [34.145.75.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c85df0a63b3sm90737a12.21.2026.06.02.13.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 13:14:41 -0700 (PDT)
Date: Tue, 2 Jun 2026 20:14:37 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Will Deacon <will@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, 
	Alexander Graf <graf@amazon.com>, Robin Murphy <robin.murphy@arm.com>, 
	Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 3/4] dma-direct: Add API to preserve/restore
 allocations
Message-ID: <ah8srv7dvO4OIii8@google.com>
References: <20260505002737.2213734-1-skhawaja@google.com>
 <20260505002737.2213734-4-skhawaja@google.com>
 <ah18hDhjSLxIvb-Y@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ah18hDhjSLxIvb-Y@willie-the-truck>
X-Rspamd-Queue-Id: 2E13A1C0010
X-Stat-Signature: jkitafzuaqucjg6mc6435jskb8zkbyhm
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780431283-777985
X-HE-Meta: U2FsdGVkX1+Ff5Xy2GTFMuK2DuZcCM7/P45xhu+clocuASaLhzxllWlMQWzZr8tu8PJvrYu4nEjFqm4l+zmMubWZWLCntx2elfSkFb5eb0NcKIRxBQ7VS4Rg3GhJ0PMOKxAV8JIch8E2uGsS/s0yti/DnaENf0BO9J8mE7VryYVC3BPU3JOScRT9hf4QiQMEMAlRS84tSNorN+24ayHqecH4Cy7nOGlr/7o6Ywz19wCI8MJ5dYpHg4vphzHxIBorR/zWRUpk9iYNrWruZQmKaucpen06jgGOliaidZ8HqSs01g3zV7eC7pbNXrA5Xy9CarxSnLCrbbmAhNyz609aQEWeJBQbihzgievTRTNFBP7P7fWpeNb8xN6pc09ZU+hfE0pS9SfLANW6nyhvnnRNhfzyfFQNwoSXn5A/KRR1i9dXb/1WLUvLdpwqNjVUaBe7YZtig2tkcDWp0RKYXnCpiVnjH1ikOdHj/8cA+0QkB9Znpt6E7dWZNiDufbBm7mLqWEh5n3dPugvbqZOn1NKv5hBZnhSyJanQV8KTJcmR+drc2/hlG6YF8pL5b52TbKkSmrEBy9sjmmtIf0QBbwxxGxWASFpmvc40GnQ60KVKieGfEvJgx9n5Vm1DLTZLW4St00qP3yqfHXZsAr6fA484GRqHZ4PE8TYtW3aEpKL+uweL8OKihvX3ce+4vq47gPJR7+b6Llk+Crv8/LVlgyZ67yukzFRNfXZbYJ5MxLMFWgc/4qwvf93mH2YNNjx/pdC+i4dXNdpi4T19TjpePuHt4Ih5l91y7Xl5hSS5pKaqrzlWq7Y6ktZBRFXDQKoWOlMEZNUVUiMoChZlqbtXUrMIgua9htwZsu0Aa/PIzXZpUuPEd8J+e6pZt4XuB8OeXEm9So6GA/T8xHLP2nu92Qn2xIFEQg/3KH944kt82ZrHBXc1N9NdIVl6ArxdjL9naAAb9zYxnMN0X8Hxf92rT1A
 kGad5kzP
 VsELnXArB3cNyRfEo31FHNDvSVmpHaUWGf/2oNBZGY3N7ZoSJbNLBWSY1ygY518eN1qa5iBHQ4Fzg+8gXzNvwzlsme9Iz4Eae8jBY73m5qsOf8fP2vyf3aYxfU1puH+wmrQwRqB5xcc1MM1G/RdTnJOjYGGlRGhEivapUKp2K0zSdWlVi/nw6y7fZSyfiWLPZPb/R9vemFFcLEvpNF9MGBH/YLDssuokukA2mPVuD04QpXzqnBkOhVyBUOvZ1ebopf5Z5g9oa0mNsHXBttU30l61l+MiO+H4Ig6Af7AtA9DpXjScHS4SGfFk6MSo3s+A5AgwjeV42uxR7q3n6NT7vjCVD17xYJmxNvLDFSvknX5sdreU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 01:35:16PM +0100, Will Deacon wrote:
>On Tue, May 05, 2026 at 12:27:36AM +0000, Samiullah Khawaja wrote:
>> diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
>> index ec887f443741..c2b98f91900a 100644
>> --- a/kernel/dma/direct.c
>> +++ b/kernel/dma/direct.c
>> @@ -6,6 +6,8 @@
>>   */
>>  #include <linux/memblock.h> /* for max_pfn */
>>  #include <linux/export.h>
>> +#include <linux/kexec_handover.h>
>> +#include <linux/kho/abi/dma_alloc.h>
>>  #include <linux/mm.h>
>>  #include <linux/dma-map-ops.h>
>>  #include <linux/scatterlist.h>
>> @@ -307,6 +309,167 @@ void *dma_direct_alloc(struct device *dev, size_t size,
>>  	return NULL;
>>  }
>>
>> +#ifdef CONFIG_DMA_LIVEUPDATE
>> +int dma_direct_preserve_allocation(struct device *dev, void *cpu_addr,
>> +				   size_t size, dma_addr_t dma_handle,
>> +				   unsigned long attrs, u64 *state)
>> +{
>> +	struct dma_alloc_ser *ser;
>> +	int ret;
>> +
>> +	if (!kho_is_enabled())
>> +		return -EOPNOTSUPP;
>> +
>> +	if (IS_ENABLED(CONFIG_DMA_CMA))
>> +		return -EOPNOTSUPP;
>
>Hmm, it seems a bit overkill to do this just because CMA is compiled
>in, especially as it's user-selectable in kconfig.
>
>Maybe you need to iterate over the CMA areas using cma_for_each_area(),
>similarly to how you do with the pools?

Agreed. So basically return error if the range belongs to one of the
CMAs. I will update this.
>
>Will

