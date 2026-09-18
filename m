Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94EB1C982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:07:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638F66B008A; Fri, 18 Sep 2026 08:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EA1D6B008C; Fri, 18 Sep 2026 08:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9686B009B; Fri, 18 Sep 2026 08:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25E7D6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:07:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BA2691A0630
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:07:50 +0000 (UTC)
X-FDA: 85226759100.27.7C62EF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EE6F6140002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:07:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLu9XvCO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MD4hJi2bXNYpFbd26ix+qt6QwZiWYCG7rKW/evDfms0=;
	b=AzfD9yDjUFpbLqzqyLf7eUYNkj1I180jM6NxzZU1H1F/bnPXe06Gc8r2kdgcJJyztdR2zC
	9uhtMgKJdbKyOKJgR8aNAH0G2UMvMQ6xWa92qiYvFSHffnS5I7SUH5zXdX4DBtL929l6YU
	NqcV2f3/jxDQc1jNDWuYTWn1F2OfyUA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YLu9XvCO;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733269;
	b=8blEajcqQ1UIA43aY0No6zWgrTl/ZFpL6gWEg+UKE+IEBXf89mokQASABHyufpfBLRKmxl
	VNGCmjejRd98ZoaFmlgpaFJIE1xbH/6ft/Hy7BSTRgG3vh/cHv5RzAAHb7YzM9KiH2ZQ5x
	S7zlNitqd87AKNfNkCeMbRlRVjkOawI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35A2D4027F;
	Fri, 18 Sep 2026 12:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7C31F000FF;
	Fri, 18 Sep 2026 12:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733268;
	bh=MD4hJi2bXNYpFbd26ix+qt6QwZiWYCG7rKW/evDfms0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=YLu9XvCORcN6Ivdeym2gR0aDrJkCTiNqECR/oJkJgcMV1FvnK2E8sQBjnIR2cMLfI
	 P3Z0veZUi1UECpvL1qy+OV9t7Oh/t2Ht3guDujBCLVIkq6x5osih6FyWHQgniShV5D
	 ZSIASKfqH3Vb707QNJDaa0KVy40FKqNXw2Cg1ZkIVnU/VJwgqfySsLqpsvVfhiKp9H
	 s3sM4duiLALyE7m+cFQTs95NORYuAjDE7q/7jZNtTiCGxSU+xhX9TUv+YdZcVgSZ//
	 erPsaoBGf/Kmsu5AwlGISS14CqSTCY55a5h/oGqmGc9tTwtjQCETRMa/3zbeaI6aRi
	 mbXQU0lR5f+Xg==
Message-ID: <f29bdfbc-c35c-4168-8f76-fbb6aaeb6abe@kernel.org>
Date: Fri, 18 Sep 2026 14:07:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm: update comments to refer to anon rmap rather
 than anon_vma
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-vma-is-faulted-v3-3-5c22314a72e7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7ori7ofqmffrfieprb3g6r4h19debz4o
X-Rspamd-Queue-Id: EE6F6140002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789733268-783777
X-HE-Meta: U2FsdGVkX1/4NQE4E5tYUONjryhaMib4Cxz4AGAP1yn9UcHLwDbUP1OBB+ewmnopiq5ZStcSA1SUy+l4ZaLShO8azcsI1LkqGdLe32gceZGyH8HfjqxkeiURNTIvUHJLHcF4OVpse83RtNBlb79OIYlvjo5TyE7jkiZcTwyFUOgE5rCuro6SiNfvUOi5SedgVkcL43LwOqsQ0SGaFLvwmScFniA3dQu3x4rdUHgbQckGX8DRAt2sCAlR1XpKYgTUFPxUMbb1KVzkGN9y778mNYZuWUmuBnizAPv9phcuIFi33QMsY+YuXMTg9QorRTnVAh4+//Yitj5WkfAPDCkbzlmzyUhoWnfUnzkLcq40r/SQuWGyc25GgUmZkaFhJ1zGUXMeQjaPe8D62AnNfrLKL2BwefHMX4xQAedRQ1p7ODFLx2G8O7FtV/eynZhd4Tr/hv/9YQTuoTBWw+Kcivbu/OLgxsLzRlXo6YEbiwlHiNBFHZlZOhcJRWRgjHIm47YNv/8ZqTkk3aPr+pJ4FoEXDhjajwzBZ39m3XeHB8NWMmtMhnahh6HMqTKtFJlO3n3VGfP4SlthgF9xsv+5hLWu3FivxIIIaeULvbI82Q8yH6298EAKbsYYueIWAOes6oa9UghFDLWIYrXs/1sbCbBvLPFQUTIwRnywbFiwfQeCPmDxvNRl5dC2/yAPEECStOYpinDoHOd+/aAn12hI/B4B+6R+46iTdeFzKW9WEwuzccpGkYt9x5pQVIS94x2TuU3VejPyxDK9xJ7JPmuG0kyORwVYHXxNCz6RHHJKp4Kn0jHWlSBbYjltU68YyNEhznZFg2kJmZk17DtayM2KSxL/LlFCiso4ZprAQotJPaWvho4SRBHdVPVEHFjpHRgrS9AgR9bWXfVeDnIFPJePVahpocG5NV9bxyhbHfSOawOSWT/2HyGAFSIO9KPX9kNITynPztLeP9wpP/1ij1e+egY
 5JnB8izc
 IsGlIKp+mSkprdc5b62KRuxEWrRdFZMF464B08Knj/aULJMDP1qq5vTp5X+d0YADwr0VqEqJrBxPNJdS+e73M2M0NsvY9VbtUM8RFEZ4txZ1k/e/MUFxp8yF+OK9VXdrdxJUCQF1kLsYdEZskOoW+8X0SMgmfTFuA4pEJCov5A5YtZ1TG2gqjXf3L/k2s4fQb5tB1hSMHhLO46llSj8y76WNd1tF7ZlthpSYEXPGAgWwy0CuN5IslJuItWy36xjMc0f+B8Cicg/NBLc502n1EnP9nJTosRYhsiunwRk295bTzf2fSTOnhbybYcQygUJU1EkLo762tjwyXqvWCw5Mcx+1FWXiX2kJ4um5/8fROZal0ekopkwam1LWEz3SX77q2CN/ipeHhORDZj28hOI82QpxKUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 21:47, Lorenzo Stoakes (ARM) wrote:
> Now that vma_has_anon_rmap() abstracts whether a VMA has an anonymous
> reverse mapping, remove references to anon_vma and instead reference the
> anon rmap.
> 
> The anon_vma is an implementation detail and should be treated as such.
> 
> Do not update mm/rmap.c which implements the anon_vma mechanism as it is
> reasonable to directly reference it there.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

