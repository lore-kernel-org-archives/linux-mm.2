Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04B94C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:29:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23966B008C; Thu, 10 Sep 2026 09:29:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4E96B0092; Thu, 10 Sep 2026 09:29:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEA776B0093; Thu, 10 Sep 2026 09:29:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A87D36B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:29:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 36EC0404D9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:29:27 +0000 (UTC)
X-FDA: 85197934374.18.1B7CADD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A81A380006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:29:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U5UTPdk7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789046965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ir7eimU1apz9Pvr6jWkaXNCy6uCyut+eQPKcl0CYQWY=;
	b=z7SmFOIDiSpWHcewbnrE4yveyaEUyl8mmq0UiTN24EsbxzPpMUPrShJXl/9bBzgA/SSEhL
	ShPPIF25NWHYjpp5tjF2F8w2rVrhAGm85w6wUxUum/koNmtVJxGy4hheZI/nSLUWM845ql
	3h0IM05irSZm+kdCQlI4V4WvhSwSI2I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789046965;
	b=UVdWq8EqASEJmCa2ljewaBnUnbMvlsWjXT6yGs/p/iAtKYWNkpzuyXcFvl2gYGm1Cz45Wd
	TWZMFfUvZI1F6Dsv+XlpIFPhUo/qI+G6vUmuHbCrfcZIWovFnHV5zUI/PoBMGMALwd7DDE
	M2SpgIxotZTnYBevosJ7QYVIFz/Vw9s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U5UTPdk7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 828146022C;
	Thu, 10 Sep 2026 13:29:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02D731F000FF;
	Thu, 10 Sep 2026 13:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789046964;
	bh=Ir7eimU1apz9Pvr6jWkaXNCy6uCyut+eQPKcl0CYQWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U5UTPdk7aT/x2ouT3O6/in3VwRXn5hAs7cUpuk3jAnYXplgvLacmjKgvqvJBjWS4x
	 KuxbACU5JVdddACYkuyQ9smO9BFj1g7h/mqRCTdMuHiHqbZCjm2uSCHG3fYX5DHsex
	 mzXm31T6RC1ELgUg48geyqgpP6KWo8rEEj3jq6i4NBElQMX1R6FVdZrPrOu1IeXudz
	 dBc4rV7qKVQk64xkFr6cMsG0z1blhllDzxR5VKjujCzm+h/mCfYclVP3Gox6+46ZL9
	 yqOQytzr/PfVw+kZWcOqHLlA2zH3P5DPsLCnA0RBsSw2q1EpmHQO5RH2jWwF66cA/5
	 H10vodQtSQuvQ==
Date: Thu, 10 Sep 2026 14:29:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-cxl@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/12] mm/sparse: refactor sparse_sections_init()
Message-ID: <aqKo5vHZbDhzrUZL@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-2-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A81A380006
X-Stat-Signature: otc347re9w8oo6xui8a9doaj5wuabytn
X-HE-Tag: 1789046965-697261
X-HE-Meta: U2FsdGVkX186oicXGLZyTrb2/RFXW044wo2IwcZa39aTQNs6LICp5QgYCBNNk7ccK5mP/7plip+rmmi+2BcvT50VPQ3FMkRoQbkCub3swqYyKaEabosruQhMEY3A2PDs8JzLbm00hql1u+DmejyXRsrCQZZaaa4c0lOnxK5SQMLb1xg4Wji9GOSBYQbfNG9/yK3fSjHG5SsICKFM2HMib58p/bwbhPcNGcRi0IFpMRmHwpwtIUR0YcNhMH4M3Ji9vog4A8ab8s4z1tWJ/QxizRDT+PuiLZTNkCTCANSpK0XfAqkmUQ6ENRMmN3LX9WXE/Tuf+R7hr5bnXogFQLjOFI2eaR7nDO8WHHkbKClR1kihl5arZEbCLiQHImGH5AttlzQopD3kOK/+vzgH1kd/K0Rn5FnnvLpj7jvH6YMKXNf4TS0oUT3Az3lasBIDQtOf9VmpBTSR8UuqCLZ9EsMjJ9Yw3VC8R3AyL4+1/Ii5nK2zJoEW2jexHQfGU9ToN2WMj4S4wrMlZ/GaMdeQVxXLTMeMdZh/haFBSG9Lr/uYyUJG4vPEFHAidVOLZ+fRispUCP2YUzydXIpEU4FsXgUBLabBMVHQcE5hX9T+BFBZKG0qqiTz7Gmm0P0FYsSRNC4KxrGNYQfGKE1hMkiDYhtwka+fM40NtFZsqvVBGFpA9Z2685y8TAJ9Ae7udwoqMkPtlHPxhzURNJsNhwW4e9NyVsHvuTNzIuIpR53tuI/gWz0yGMsL3a90n95qhLrj5XZgNKKKdGt5OtSaw4H7wzTJeXS0iUj3K55xmIP9UzIhPVv3KfEgs2dA1KNKdxlRj0NOeVV3lVhiffg/oqNaHqjbmWP1kd8b+yqfa4/VYQowtT2/bRJtRA/l25EqbBT6toGHedpzNTJxI78YhqccRGfJhTCSXsnHP3rLN2NIzwB8B44a9eVj7SdQ4IFN44iPxOnCWfy3tiYIegAxXKNZbEg
 NctoZ48J
 xaHNyJ9fRmzSlIuiKGqwaL49MEmT/Cac7b2XxEHl/CF6n43tw/VWDSILa6zcGqs8Q60oAP83lBug0RiFTT2H0KthNF8PlBXfcX98euC+hms3tUevZ88hQuHXluZMS7egivUZPkITAjmvktcURIXb9LnVHpfKI0b15UvTJBychFKU4r2kxsZmPo2mcQnXdSrfZ13maCFtEhXBImKyWUGpleeC0h3COUJ3hVAwp04urffairthHwBKZ4spDSFbPDTgI6Sr3pza9R0LDZTz3T2NlPKGnuswr/zQlpThEJJJeqjt73AiCWqUhjZIQWHao3PsI0+FTRTsmPj8EvoS9T5HlG5nGtNA2aInckim2Tvrfq3FTjWY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:55PM +0200, David Hildenbrand (Arm) wrote:
> memory_present() really identifies+prepares all early sections so the
> initialization in sparse_init() can properly iterating them to
> initialize metadata.
>
> Let's just inline memory_present() into sparse_sections_init() and
> cleaning up the code a bit while at it: make it clear that we are operating
> on pfns.
>
> Note that we call set_section_nid() now only if the section
> was not already created earlier. Now, there is no more inconsistency
> between what we (temporarily) store in ms->section_mem_map and what
> we store in our section->nid array.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

In general please keep move/refactor steps separate. It makes it harder to
review when two things are going on at one time.

But I guess in this case the diff wouldn't be that different.

Anyway seems reasonable so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/sparse.c | 41 +++++++++++++++++------------------------
>  1 file changed, 17 insertions(+), 24 deletions(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 6a6d258862904..36e3d854febc5 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -179,22 +179,27 @@ static inline unsigned long first_present_section_nr(void)
>  	return next_present_section_nr(-1);
>  }
>
> -/* Record a memory area against a node. */
> -static void __init memory_present(int nid, unsigned long start, unsigned long end)
> +void __init sparse_sections_init(void)
>  {
> -	unsigned long pfn;
> +	unsigned long pfn, start_pfn, end_pfn;
> +	int i, nid;
> +
> +	sparse_extreme_init();
>
> -	start &= PAGE_SECTION_MASK;
> -	mminit_validate_memmodel_limits(&start, &end);
> -	for (pfn = start; pfn < end; pfn += PAGES_PER_SECTION) {
> -		unsigned long section_nr = pfn_to_section_nr(pfn);
> -		struct mem_section *ms;
> +	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
> +		start_pfn &= PAGE_SECTION_MASK;
> +		mminit_validate_memmodel_limits(&start_pfn, &end_pfn);
>
> -		sparse_index_init(section_nr, nid);
> -		set_section_nid(section_nr, nid);
> +		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
> +			unsigned long section_nr = pfn_to_section_nr(pfn);
> +			struct mem_section *ms;
>
> -		ms = __nr_to_section(section_nr);
> -		if (!ms->section_mem_map) {
> +			sparse_index_init(section_nr, nid);
> +			ms = __nr_to_section(section_nr);
> +			if (ms->section_mem_map)
> +				continue;
> +
> +			set_section_nid(section_nr, nid);

So the main change seems to be calling set_section_nid() only if
!ms->section_mem_map (and obv. calculating ms earlier), as described in the
commit msg.

>  			ms->section_mem_map = sparse_encode_early_nid(nid) |
>  							SECTION_IS_ONLINE;
>  			__section_mark_present(ms, section_nr);
> @@ -202,18 +207,6 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
>  	}
>  }
>
> -/* Initialize memory section metadata for all system memory. */
> -void __init sparse_sections_init(void)
> -{
> -	unsigned long start, end;
> -	int i, nid;
> -
> -	sparse_extreme_init();
> -
> -	for_each_mem_pfn_range(i, MAX_NUMNODES, &start, &end, &nid)
> -		memory_present(nid, start, end);
> -}
> -
>  #ifndef CONFIG_SPARSEMEM_VMEMMAP
>  struct page __init *__populate_section_memmap(unsigned long pfn,
>  		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

