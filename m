Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593E5C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:59:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36F046B0093; Wed,  9 Sep 2026 05:58:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3463E6B00A0; Wed,  9 Sep 2026 05:58:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238E06B00A3; Wed,  9 Sep 2026 05:58:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EE05C6B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:58:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5E04140166
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:58:57 +0000 (UTC)
X-FDA: 85193775114.04.48CC50B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 28E9C40004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:58:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CDfjT/xT";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947936;
	b=0+QPB07k/9HhAhRBgRduk+2pQUUzQJ4+wKO1+nstiOmIowCM26CZMXwh5I4BzPViwU3EWr
	fXHLb6Iksah4t4KdG9vV2uZE0yH7VYnl6VfCacBhQLKe6u31ZHTawyye1u4lOr4FuqIi6T
	uyVxlJCzvl0WLLMt1VoGHH1dKqk1YN8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CDfjT/xT";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0Z230v0kcWv+KYsA2iisucLz0tAzBFMvCYKOrnjLsE=;
	b=IFLRJFT8uf2G/ePGBP5rCLTsBFNc+bosC6+xBwZovvLswGKeJXOyeoLy0/t1/FJMxMovJT
	PIVBaVrf5oit6cjPCSbM46953epunM9Uvs0WdyqBBmnDuPueUiz/2pSBrDW5nD9B66kTkL
	f5KOuAzmsIwVWS3pEvuGbXlQkvk24Vk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36B7260214;
	Wed,  9 Sep 2026 09:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F541F00A3D;
	Wed,  9 Sep 2026 09:58:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788947934;
	bh=Q0Z230v0kcWv+KYsA2iisucLz0tAzBFMvCYKOrnjLsE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CDfjT/xTNuxQ4VwSHCk/9ETC998WeGmFdDy7oYbTKuIOBhMtZsw7rHkQgNTR8G7MT
	 5lJlaEHbyGnCMAEI+ZrxxFcdCdji+K1gckZFfrY9An68jOVz80B+YypE5mhbkejLwo
	 cSrjkJ/AkIUXSv1j+c1T85DSzFPFb0h3eK/eSzdE7hW1frC7KaN0IUUWJjhNM+9Nmk
	 LlDhuC7QQTfea8b8ocf1A6xJ7pK62u08E85d8ff/W1sTyGLj/tJN67VeKiM+4oZYF2
	 PhFUwmuRU3LkW6hWRP0cAoxmDDEA/wftxR6q3sG/Hg7Se4mH5Htc8NmYcE7B/EMrQg
	 JsW0gwMHhyPlw==
Message-ID: <67dc7ac8-b39d-4354-8cbf-f2a1c3a369ee@kernel.org>
Date: Wed, 9 Sep 2026 11:58:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 10/17] mm/hugetlb: switch HugeTLB to section-based
 vmemmap optimization
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-11-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28E9C40004
X-Stat-Signature: wsp9p4jycedh7frp1azypbs3pto6zxds
X-HE-Tag: 1788947935-750549
X-HE-Meta: U2FsdGVkX1+zUQ1gcfNXqBUVp012idagA1P+G7HTQaKfJxK/RScMT7h6SKYLO/r/rChSHWKcH+9K/gACYTphp0Pr0SsdsVVuOOwXPqvNYSllrguA78Y7cUasDjgktRa5oJXC+D5AIZgoQXBBfMVzL+VJS6QN0qkE+7wTySZHDE4mEiBx129x9GRxJ6joJDBPcyKZIFVPJhUZ23etELB9OiaiZZuXOT5eyH9qBj01OFOj3nxzeidf1DluuH4Ap7gHvWvhW67xvnFdIa+2siHN/VZ6OXXjzrdtNfAVqBTQH/tbbFWEQMNwtTHtPsq3SQB1HU64mXZElF4DWkEAZAhgcGbuX4dtnE/IJnquRnCILohr/Qmm4T5AEKP8T24enWSmjr/7l/HiV1gVxhMRpawBgcmXgvgl1vpCYE7CCTHiDytIoElHRwaqz3s42DkOVmKtZvv7m4NKiMdCbP7PJBPL+aTBU5MN54qp29wN/UTe1EIIjrY8LtHrl6ZV+55BC+lQKY8ZBU6cySL0iDvFq+eDGBAksLjl/m8ytmHmfGFOWJuR8QMxEu+H4gjmxw5WjJfTWBGqOrK731CilL0RWnEipB5SrmHV2/t6FA3/TcouEUgMBnmp39C1tqEoUzZNqGs1M5neUgROHUfBrxqeStovf0R4HnhSiQPEaYVB/L2s/xYLPEByh6dMOCNj34pJ3kWNwH54lsPL2oBu+O0MaBUTCOfxjj34TCzfHiBhi0WNHp1zIBS0YXg4k8nocMeMYhNzqTo3ziSEahUM3m9bYrD88pDO53qoAztrvMEs9QdS6UHqdgmHO9ovhZjuQ8oVnQn8Pi7JRDxtCOzwIToVZW0BJIKHoC+A7ejhM21pp1nu0Xk8m0NM7RG7Yl10lZGj7cELeM5udPsroe4brBWKIFgf850cNaw1uNottbf3Wt4edCX5ZsKStzHY4L0FawwhmfweWTKmZk4xaxCclE9BSnX
 /wvIqn/k
 RzxFMSL+BO1SVdtsfCQuyIjj9lQLn2ol9bzfmKZISfJuhQ+9e+H4AlTv+te6/LS8oT7qBepOGui5l1u6y2J0yOBbFuhxpL9zX55PQgoXBEIb3EBP2ye9y0G2TtF4fhqI+OrD1nVY7kP2TMFbC3rW+7kXCPJzd7upjNJs4kMp1Dk2m1BVnkyQpO9lepGxsBHDbfxP33wwJqv+PIk3voSoKYuzNx7cpUxkXLh/ZBNjBAo8HaiD+3uFj8s3paSk6FXQfBmcNC07RSBWU1noWBum14ZWrJMOGh0uxJS4U7pJJPoz7SEsaJ1sU5V/b6IYmHulSv2+2YRPphDumjukBClqaPzLm2GH18OV6+c37ew+PVqQFkGJP1aetELBp950MzJLRwUX6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:46, Muchun Song wrote:
> HugeTLB bootmem vmemmap optimization still carries its own early setup
> path, including pre-populating optimized mappings before the generic
> sparse-vmemmap code runs.
> 
> Now that the section-based vmemmap optimization can derive HugeTLB
> vmemmap deduplication from section metadata, HugeTLB only needs to mark
> the bootmem huge page range with the appropriate order. The generic
> sparse-vmemmap population path can then allocate and map the shared tail
> vmemmap pages without any HugeTLB-specific early population code.
> 
> Do that by setting the section order when a bootmem huge page is
> allocated and dropping the dedicated pre-HVO helpers and related
> special-casing.
> 
> This removes duplicate early setup logic and switches HugeTLB to the
> section-based vmemmap optimization path.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v3:
> - Use the order-based helper for the bootmem vmemmap-optimized check
> 
> v2:
> - Collect Acked-by from Mike Rapoport
> ---
>  include/linux/hugetlb.h |  1 -
>  include/linux/mm.h      |  3 --
>  mm/hugetlb.c            | 30 ++------------
>  mm/hugetlb_vmemmap.c    | 90 +++--------------------------------------
>  mm/hugetlb_vmemmap.h    | 14 +++----
>  mm/sparse-vmemmap.c     | 31 --------------
>  mm/sparse.h             | 27 +++++++++++++
>  7 files changed, 42 insertions(+), 154 deletions(-)

Nice cleanup.

>  
> diff --git a/mm/sparse.h b/mm/sparse.h
> index e4617f9c8876..049272aba84e 100644
> --- a/mm/sparse.h
> +++ b/mm/sparse.h
> @@ -16,6 +16,24 @@ static inline unsigned int section_order(const struct mem_section *section)
>  	return section->order;
>  }
>  
> +static inline void section_set_order(struct mem_section *section, unsigned int order)
> +{
> +	VM_WARN_ON(section_order(section) && order && section_order(section) != order);
> +	section->order = order;

As raised previously "section order" is entirely unclear. If this is a compound
page order we should spell that out.


-- 
Cheers,

David

