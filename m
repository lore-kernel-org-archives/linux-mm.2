Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E857C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 13:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 085286B008A; Thu, 10 Sep 2026 09:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D086B0092; Thu, 10 Sep 2026 09:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB49E6B009B; Thu, 10 Sep 2026 09:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C63276B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:44:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DAEF2804E9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:44:05 +0000 (UTC)
X-FDA: 85197971250.19.1B43674
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 34AD91C000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:44:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tvz9goRE;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789047844;
	b=HF0k3soQEUIDN6SNEfhh51p046BJxxGOTb3YYCB8HSNNG3HcDmW31jReilFbWMSLBfn5D5
	G7OUzdCRQ6NHQcBJR0TS3noiAyZoPzSyGgG5HfRixMRdGjw5hna5+qyDHVOL3NYjKSu3L/
	qK9m/OwBAK/lykbdUVkaqhZiii4mkWQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tvz9goRE;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789047844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IF7M+11q+QECLEteqxbNDabGoO0k0KfVFRmy1+hacIU=;
	b=kpMR5uvqEUTbOCno37AuW0yHlPSG1cfokS2bySEzL0ncQC0SsOwkzExWCEy4kz+URy8TRT
	HoZ2YodCJ9xHzbQIMYlJVpmgkXzciiIaSsffI55P/jQXlO5sC1pUDKwF0k9j8v9OMiD9H2
	Nw/szAdA6TOlYd9Kosry4Q3niRD21mQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51BB241411;
	Thu, 10 Sep 2026 13:44:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD331F000FF;
	Thu, 10 Sep 2026 13:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789047843;
	bh=IF7M+11q+QECLEteqxbNDabGoO0k0KfVFRmy1+hacIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Tvz9goRETXsoBH88n/XwxRH7uEZwVgWZml8GL3eYS51YzdH9NIzgyZztJZIXqjTMa
	 ncz6dlvqeXkE5IZweicBq0YTMz0+VVpbN6R++P/ntujkGJHqeXmJg1s5n7HkXeYTu0
	 HGqwjwPVGk+MwNUyqShd7SzXBlY1da//0T1KyO+FgbmbL8BiTsN5XWOeruvei/PTLf
	 pO5ajcD07dyduWDapbbuBL0Y9/PMoKRYlejIf9zEG5Y2ZwQr9OPL6ab6ryoC4okAIa
	 9+Ra2A+1xP2kwFFofz43vWoooWziI0Kwe28C8wIuf6pM++hyKnCPp3OBSiDkkudQkA
	 IR86yvw89VACg==
Date: Thu, 10 Sep 2026 14:43:53 +0100
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
Subject: Re: [PATCH 03/12] mm/sparse: move initialization of section metadata
 to sparse_metadata_init()
Message-ID: <aqKzPw763WQR9eCf@gremlin>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-3-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-3-008fc8d579fe@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 34AD91C000A
X-Rspam-User: 
X-Stat-Signature: k1utcmh6tt6nfjg38kete131qudh6zqa
X-HE-Tag: 1789047844-954643
X-HE-Meta: U2FsdGVkX1+0GRhWb7szjgH9y5nC5+QTUHsinBqCyuDMIv36WQnIAciiXVGOfi8d7Mdo2KLJzufojrkjOLaRXUBUdoGa4Ep5NwQx9pwmrU2UcRAl/o5C0hvSBVQjD71TUbjFTvIaX+2Wveo4qxDaHJFxy/VWW736PKyIAd646wz4gU0df1baTjNqRneHVeSqW7YgmKB4YasHQCAgxBn4fGIxjdsgfO7MSuQNs1VQyF3lLL1eAtxLJ0wyahhdV8K4ScRqJQDGHSfcT6ZKtZwunAmUzKN6foibngipF4bC4K5v4zVkRia8NXK/DN3c33o5Dr1ayMd8MXZc7YiwOOkQpiY3poifqkIM4f23ZSNT8LYDcw0qg5TzvXyfNq1L4nw2HSt2GGW79zhLT/TY2L9xk+oFD7MLRKV1mRQX/MD7rcHij8mz4ue9OqPIQcRRQrGDh6YyL+pZlrSGUe8PoTy5IdomUNH0E9im5VI4WuVKdGaMY6Wt+5oR4/hY8vbJFMl5YvRYs7+8G3F9uT3x0gpYxL4gqYWIapm7so593v+CDb3zq9h4MQBIefuxY8B5w7CzV3j+SZEHmAY9a93ayhYeQNymQzzy2Rc4ceuk5fiDZTcbYJPMQG9YmWDhoTNAcRH1MiBJ2NdvsCeFpPvVMJYOSdMf6Ns2b56y7SNZYb68szqBbgeilH5iymcGvlGE+coyuN6yOxVaDt4L0GIIbOselRNkqhKxCdV6ZLe0My+iXa77hWBKTCcghIt+7PPISnywCkBzGAeizRkhJ6XIl5UiqmIgHqBQWvoFIvyfzhnPsuSGhOcKgsA4DrqxvsEcRb86GxagdT3n3e5ikaLUIDiYsJK5K6ba5CG+6eAWXIhQi+J/ZrSvuE2OAItn1iG7vM6YyttpN7AOa/wygHheZ4YKvCHXEXxbr1utHpzo/pzWORX3plMPgDGU7WvRa+fVZhTe3WBBp3bhaudE3RD1fR7
 sp2GGw8S
 f1NyRXU6FMfoVME2BF7yi6RDJVuFDh3Db/Z4f1R9il+KhdGeWchXZciIlUzRvECue82X/gommNCgkOnZzvup2BqNhNums2J5ttDY/5C1XOeI5hcynJdO7HRxhacDoMqXce0vuIAP04iKMXiy+x+yHrAcdXKn/UcL1ggouYvbpy8a/Ny+ItTc4vc62QVeiJtFNMFi4Y9gWx792BhWczsGrAzNY8G/zy3G8vAojGYanw1xbptTYo89hEWEcpUjfn5pNHSH4teyz1Ify3GtrWmM/NXnGwV9qF67FkJ+ZQ8GgdDGAjvQDqlCLDo71VN6kEk/U389G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:56PM +0200, David Hildenbrand (Arm) wrote:
> Let's move the code responsible for initializing sparse metadata (usemap,
> memmap) into a helper. Cleanup the variable while at it (e.g.,
> "map_count").
>
> Drop the rather obvious code comments.
>
> No functional change intended.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Similar comment to last, the move screws up the diff a bit, but staring at
git-delta it looks ok and the renames are good so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/sparse.c | 43 ++++++++++++++++++++++---------------------
>  1 file changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/mm/sparse.c b/mm/sparse.c
> index 36e3d854febc5..a85a9c3840f6c 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -257,38 +257,39 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
>  	}
>  }
>
> +static void __init sparse_metadata_init(void)
> +{
> +	unsigned long start_section_nr = first_present_section_nr();
> +	int nid_begin = sparse_early_nid(__nr_to_section(start_section_nr));
> +	unsigned long section_nr, nr_sections = 1;
> +
> +	for_each_present_section_nr(start_section_nr + 1, section_nr) {
> +		const int nid = sparse_early_nid(__nr_to_section(section_nr));
> +
> +		if (nid == nid_begin) {
> +			nr_sections++;
> +			continue;
> +		}
> +		sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
> +		nid_begin = nid;
> +		start_section_nr = section_nr;
> +		nr_sections = 1;
> +	}
> +	sparse_init_nid(nid_begin, start_section_nr, section_nr, nr_sections);
> +}
> +
>  /*
>   * Allocate the accumulated non-linear sections, allocate a mem_map
>   * for each and record the physical to section mapping.
>   */
>  void __init sparse_init(void)
>  {
> -	unsigned long pnum_end, pnum_begin, map_count = 1;
> -	int nid_begin;
> -
>  	if (compound_info_has_mask()) {
>  		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
>  				    MAX_FOLIO_VMEMMAP_ALIGN));
>  	}
>
> -	pnum_begin = first_present_section_nr();
> -	nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
> -
> -	for_each_present_section_nr(pnum_begin + 1, pnum_end) {
> -		int nid = sparse_early_nid(__nr_to_section(pnum_end));
> -
> -		if (nid == nid_begin) {
> -			map_count++;
> -			continue;
> -		}
> -		/* Init node with sections in range [pnum_begin, pnum_end) */
> -		sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
> -		nid_begin = nid;
> -		pnum_begin = pnum_end;
> -		map_count = 1;
> -	}
> -	/* cover the last node */
> -	sparse_init_nid(nid_begin, pnum_begin, pnum_end, map_count);
> +	sparse_metadata_init();
>  	sparse_init_subsection_map();
>  	vmemmap_populate_print_last();
>  }
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

