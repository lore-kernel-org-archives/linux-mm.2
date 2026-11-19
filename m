Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0754606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U/a7b/tR
Received: by kanga.kvack.org (Postfix)
	id 183586B05F0; Thu, 19 Nov 2026 04:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15B366B05F1; Thu, 19 Nov 2026 04:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0721A6B05F2; Thu, 19 Nov 2026 04:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D294A6B05F0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:25:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26ED31A09F8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:25:34 +0000 (UTC)
X-FDA: 85451335788.16.B9F0181
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5980B4000A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:25:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/a7b/tR";
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795080332;
	b=JG/Rhh7K9XRrfozV3z7Mua1BkCoE1v2o6xtBMCbqpEYM1v8WQDSh9OGEiN/zS2Zh+5KCQQ
	hMY3oUktd2QwEXC/cZJKx3Rw9fzlzJsQPZ8ahdXlKMFFcaIJACufQQSDG9IxUk88FVG4vX
	N47w+/zgjGIcFmpHoHMQl0A/LPw9xCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795080332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykzNXonS4EXpUTddVAokRRmNVBMx3zTvxuXv3tt6jrA=;
	b=vwlLc/ibJNTZD3qoUiepsDDtMMRdISHy7P6wmRR1PS69TUzFghoVtyTK8egCK9XknvXPjQ
	d5kUjaOm1h4yYU+3yJvKIInqaCBpqVyvBGYAO9xFdoOdg9k3MKufow2tnoc1YJ/7RFcFWF
	7bZFBPI7YSZJNC6Qv3VoZE26epKGOSo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="U/a7b/tR";
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 826B545FB8;
	Thu, 19 Nov 2026 09:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2281F000C5;
	Thu, 19 Nov 2026 09:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795080331;
	bh=ykzNXonS4EXpUTddVAokRRmNVBMx3zTvxuXv3tt6jrA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=U/a7b/tRhB8CSGT20eIHplkYFnOjIl0jl1P2BKWpqserpdTar8rZB/iL+28k4xgEX
	 RAe4srUmFH860mmQuuqauf+aCBEZMA05LBWTZJeFuWc4/pDEw7H4zNwyJ9jjFBkEgO
	 P1oN9DABuhlAvY9p6B9nv+OU3L2aK6i2S3Z5jBQRrL3hBhH6u7EDKVIkeVQpciiQ3s
	 gzclqEsBfSrLpqV19oScY15ygIOAL6spSiDl9Ma8gcJSmE8KSomJVIfweRJutFtVJ2
	 gFuDyLF9ZxXpXQaziu8mrHK12yt2wZuazhsdwVwHpf+Sge8TYoD6aWdk9lFGdz4FmE
	 XzmO5ASh87W4w==
Date: Thu, 19 Nov 2026 10:25:18 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	Chris Mason <mason@kernel.org>, stable@kernel.org,
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v2 13/15] mm/hugetlb: fix reservation leak on min_size=
 mounts
Message-ID: <av7Afqpp-C9pqcR3@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-13-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-13-4dd9e94ea9ac@kernel.org>
X-Rspam-User:
X-Stat-Signature: eikncrhunfe8xmhod59arnfzk433opz5
X-Rspamd-Queue-Id: 5980B4000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795080332-581843
X-HE-Meta: U2FsdGVkX1/3QCZyxx/RLGJuYd4zoEh0Ecnd8LYCGdKE8xfxd++Ea1QHxKRaEtecycRJywvoSRngk1EdKnUCx0+0meJsudXtzF7+BVI5/06VMVCzTaWSPkuIG655CCCOgYin2FWgZRugPqYaB+9xvN8CDHNsWkS+dcwCbwLSjSRKip3d51IsFLe33gW987OP8jFHq67gBOIx3kZAFQw1iWuMkeKhrbK/mZFItKWhV1gnQaqbGWkfwexWLS8uaT3J+p6YW/IDzlTCi6kOUcB+2zYzdNUMmW6AU0uKjfxBO4225QC/KnX5Y8UhxjOz6dOc0U/ilHSi48bA0kPxRNGrbIqOQA5y8AyeLI1r2gTrY4nRXw1Q5+Y3hUb+6wVWH6uaAo9ivA0J3wvFgeVF0VO7hR2DEhXpiVCDRXS2l2xR7XIGtwL81GZDp95Pcg1Su8Cy4yJB3DrLVf9uRpbj3NY53xUM9tR1pUE0iCLjWDFkCmKGMsnvCc0SfwGTXSMJYhOuhhuqGt5jgGfh7X4DN9uyCWVGfpVsf+39jhSSaQ5ITOJQsnTMjKM7B1VAglH2zFzISAfLdIJDJdKZcBlfmh5vFd5mPg12QHQ0TsD5koiudjeJH0/u+sQepWRp6LZYf94OELi6cCQNq1RoDpUiE4pDVYuaMJVtNNuLX2q1bwR+N6OyyAmTpnaumEHUV54PIQqoopY67Z3X3dCHfQ1APxuF1QbUHwSUPIn/A/DLaF/cqfP8U2cJ+LrZAVYXVVucr/XUUjhM5L0MiUYu20XNaHr7vitWGNXO8IUqRtMJnr0VmPXHIMhWtLN5MdIZhy7tr0KMCvwBsi10g3woHzwxdNqP48+ezQlDWVJWj52Y+MFmZC0M/eCxi6PD6t5nijAqyJHWR44asclJ5uOop/DFd6ijh1bOMI+OQs7fD2S31moPTvoZzmz9ifk8ftQCwGAefeW24aM/s2zwSl53WXRPTij
 fbqAfzHG
 AZmKEvh932ryuRXgsjM2A92EhfRr+GhqWIMNBmWlScEP5lIjzlc/1eKqNET4Bc3KAo3MPh6w+5Giv+Ht7kcZpYwq93YZv7QtSsClP8FEXK0lWE3/gqsjJpFPisZHJwVAOxB5EXnJwp7kc3wO5hcLLowrNvOdkTPLnFqlIau7fKRSxjJW7GqYmt5j4R8x880GOlTG4DL5VraKwtviowzP7f5uSYLKflV2vcNxXhRFScZ+Ef7mPPIDPbnaw9UoDPgO0HMR6foNGjFZmOKakpw7kjn1buVV4qefyI+7ZpwMQi7W//SgPGFugP/61HAY1EHQ+WW/6wpm7loSdPb6al5Q+zVajlQyAl8JVlfFtMPbLxpsmEu+n+mpEqMSV6kgEXxNwwPTIvdieruU4egoKeE0BUbQ+hNulI95oOYS4D8jUT1XZgBi7UC5JJEFDlkCUu9UlBLi4MdBrPhc+8SOZd2lKY9Ts87vkI7sX8zdwOo/7pc2RBsqQuytT146MbWA3QEMoAv8Y5293He4dcK7uw2zzBcXrjMs7KhxQlnktb8aa9sX+0DLZ0woVb/wxrOWj/13sxdC4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:34PM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Failed allocations for CoW mappings can leak reservations on hugetlbfs
> mounts with min_size= and no size=. The leaked reservations survive
> unmount.
> 
> Note that this is only an accounting error and not a memory leak.
> 
> HPG_restore_reserve makes free_huge_folio() restore the global
> reservation without returning it to the subpool. This assumes the
> reserve map holds the reservation. However, a CoW mapping may have no
> reserve map, or the map may already account for another folio at the
> same index.
> 
> Commit 58db7c5fbe7d ("mm/hugetlb: fix avoid_reserve to allow taking
> folio from subpool") allowed owner CoW allocations to consume subpool
> reservations. Commit 51e1de00acdb ("mm/hugetlb: simplify
> vma_has_reserves()") later extended this to CoW mappings without a
> reserve map.
> 
> For example, with a subpool minimum of one page and a
> MAP_PRIVATE|MAP_NORESERVE mapping:
> 
>                                       subpool       global
>                                       rsv_hpages    resv_huge_pages
>   1. Mount                             1             1
>   2. Allocate using subpool reserve    0             0
>   3. Free on error with flag set       0             1
>   4. Allocate without a reservation    0             1
>   5. Free and return to subpool        1             2
> 
> Call folio_clear_hugetlb_restore_reserve() for CoW mappings when
> map_chg != MAP_CHG_REUSE, meaning no reserve-map reservation was consumed.
> This lets free_huge_folio() return subpool reservations to the subpool
> on error.
> 
> Do not set the flag again if region-cache allocation fails during
> rollback: that would undo the flag clearing and skip returning the
> reservation to the subpool. This also fixes the older case where setting
> the flag invents a reservation for an unreserved allocation for a CoW
> mapping.
> 
> The doc still mentions PagePrivate at various places: future work should
> clean that up.
> 
> Fix generated by an LLM and sent by Chris Mason in private.
> 
> Fixes: 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error functionality")
> Fixes: 58db7c5fbe7d ("mm/hugetlb: fix avoid_reserve to allow taking folio from subpool")
> Cc: stable@kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: simplify comments and improve description; updated Fixes ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

