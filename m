Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CFCBCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:53:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38236B0127; Thu, 25 Jun 2026 07:53:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F616B0128; Thu, 25 Jun 2026 07:53:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE156B0129; Thu, 25 Jun 2026 07:53:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7426B0127
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:53:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E31791C609A
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:53:23 +0000 (UTC)
X-FDA: 84918274686.01.A061D13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 213F6100013
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:53:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISji3frk;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782388402;
	b=Hb9uRl+kZzObYue5k90n5x0Jynpr83nhSbDOIKLNNGTnPs7vOvmcvJsg4uXaI9bG1OQmtS
	A1k+vgcQCwrRUsUYEs5+BZpBjm23Bj56n+Cmh5684mX9jHZ5N7E5paRYAIuW/n9y3xGILy
	jAPuQFBXzvy1OZqLO12mrM7sNGMAors=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782388402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oRlQaanIhcQcZCf/uwxGFqg8mEsnAVTMqm1vxeHrXU=;
	b=5TfNcVDlPLwUa7pH/1osz9OcCQFASMU+jeaf8QF/8EpuCMO/0mWIbctjUXS2EWfihpSCZg
	0jmd13ovFIhvb4iToO2f0iUvgdHjaaSj6WFfNAWqgKitBBQy9QvIoB2PKcl0batuh7tLNp
	Jbsp8OPNLLq1Zr8q1sKgr34BMW/1Cf4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISji3frk;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 566A6406CC;
	Thu, 25 Jun 2026 11:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6141F00A3A;
	Thu, 25 Jun 2026 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782388401;
	bh=2oRlQaanIhcQcZCf/uwxGFqg8mEsnAVTMqm1vxeHrXU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ISji3frkYd5Fv11tCw0nRVWlXN10RSoUFVewB2TodDuzSIVNkXWEn/nk8Q/LdpoFN
	 HSYXlKPhzp+d22MbRLj4yE8JV7JKxdp6DJDs8fSSZ4namSLkZGXqOfA+NY+D8B37tP
	 Q+i8WackGOB1xIB2yyW8MzVA2Rp2DbBnaP1PNqkwlitIiIOmVEoo+oOMK/CaF+cnmc
	 TDzysx+chWtGVG8Gj2ZcAi1/EfSiS7Cp632tWYP5puumjzOzuXSn3l0fKaS+DjbvQ5
	 yX1V1ea4vyhkzs5JydCeBsSKkfPqupe68Pl7b6rjbGCa0ZbR+UTyd9vvHfGEGt/nXt
	 MehV4UPYEQ/Lg==
Message-ID: <2c4dd46a-4755-4bf5-8f14-2d73eb356e3e@kernel.org>
Date: Thu, 25 Jun 2026 13:53:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm: assert exclusive nid/zonenum bits at the
 page/folio access sites
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <20260625071830.996043-1-hui.zhu@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260625071830.996043-1-hui.zhu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rjxcy3sbad5c3ej43goopmisc3ug31ru
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 213F6100013
X-HE-Tag: 1782388401-778879
X-HE-Meta: U2FsdGVkX18zsDZFzyyV4T38TmM5v0p84aOTONWtl085NJ6qNCnSkQp/snJCg0mCqAobvgiatPWAszrtB5ZCbKfFrkev1VOOrfHoheJwUVncYYSKQpXabmSeKC/CP+Cj8urr8fxmY55Z54DnROusY4pELfR6X0/iYr+cycFGBvTDx+aQeSZ6gS8ejzpsYZdlYk+PtpgSc8EGE7omNtuSzpcJc5Gx1gCBMgJeWfpzrA08hSilp83O0duSdIxw1yUVxUm3xZIX0hHcFgoXfDZlM6f1+NtapNe2wlX4wtNK8d8iz96LWUBdOm64/8kyQFOvn2SXb2vZB8mOazm2E+FtCLVbZmKAlftJz0eBpwC0TiAMbD9RB45B9jFiHvXUHo2lbHFA/9YpqsKfQYp8dllLVV++4boHArSwAdVB1OoDbTp8xlFGbr2NFrTsWY0P32o0WVlYLZ+vmr54R+9xB1ys7YNvKyUWxevWf9BHw+tvUwBrKCfGa7UEIEsPfs/bGnCgpAKt6jMvfve1Iq/7Fv+GK0NqWEENrMDmpDc0mseZ0HCrfsdI7vsWLW5l4kmzCeOCz125RKd7wUZWeMd8iOhomGjMuj7W++P0RN+Gz6h3L6zfWgjLabKbDn0bBhm6qViMshVRWrPSep3smtEI6U7QmdfIotYcZ1c5EhPrNIYTRpiWYn46Am58zKRtcdLgYny93Lh6VfWV9yrjwaQP6Flx9ynMRHAKNup32J1w4eIOMGcWBCyZpa+yiorxIXfALc+KVvNJ/Wbf2YQrrCAqP1F7fhgh8biejJU7QyfihsU6E8fuiQmYEx2YiZmr3l7no2gxQ5w+RoKpWEpBj6/dvtm1bxtjEAE/4opZasH13bbOlY+aSwYfBxji7zBsxxA1rweJNXkfQrCfsadEVnR5bosRPEE0yp+ITysMvZC4kgh/0V72U+QXknV8j7i+frBNUpndI7wD96/RR98azFt1Sho
 KjFcQe+v
 m4tdlYQ3viHBDeufVyslepZrABIeLX88Qd3AO/PCR8FT9VLWjI0O9QZTHThmd2XKXOJynpBwzZNIGo+iaSYe2QdotgeJ1UHBkPJ9pIs2Eb46S/kmT8ubq9dmPYh4rNEUghNRpYt3NOfJDSDFNbhOkqE+lVHeIRMH5SLrNGSktuK3wGU6bEzT6+WFAJ/Q9q94SWVaqy78th7iCt2eRGK/6mZReGt08O3Lv152LhJ2MaP5Io2gyOd7zGSgD8BHO2Zf7f09Ok/TNIFGohRogryAvBOP2U5tdGEQ8AqB8cZJMkTjwHWUR2hzY08Y14rzMBR5JsSVeVfoAc6ZRg0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/25/26 09:18, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> KCSAN reports a data race between page_to_nid()/folio_pgdat() reading
> page->flags and folio_trylock()/folio_lock() concurrently doing
> test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:
> 
>   BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp
> 
> The node id and zone id occupy fixed bit-ranges of page->flags that
> are set once at page init and never modified afterwards, so they can
> never overlap with the low PG_locked/PG_waiters bits touched by the
> folio lock path.
> 
> ASSERT_EXCLUSIVE_BITS(mdf.f, ...) inside memdesc_nid()/memdesc_zonenum()
> checks a by-value copy of the flags word, not the actual shared
> page->flags/folio->flags being modified concurrently, so it doesn't
> reliably assert anything about the real race. Move the assertion to
> page_to_nid(), folio_nid(), page_zonenum() and folio_zonenum(), where
> flags is dereferenced directly from the page/folio.
> 
> On CONFIG_NUMA=n, NODES_MASK is 0 and the old memdesc_nid() body
> folded to a constant, so page->flags/folio->flags was never actually
> read. ASSERT_EXCLUSIVE_BITS() is a real runtime check that can't be
> folded away, so doing it unconditionally would add a pointless read
> of page->flags/folio->flags and a check that can never fire. Keep
> page_to_nid()/folio_nid() as plain "return 0" static inline stubs
> under CONFIG_NUMA=n instead.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> Changelog:
> v5:
> According to the comments of Sashiko, guard the ASSERT_EXCLUSIVE_BITS()
> calls with #ifndef NODE_NOT_IN_PAGE_FLAGS (for nid) and #if
> ZONES_WIDTH != 0 (for zonenum).
> According to the comments of David, avoid calling
> PF_POISONED_CHECK(page) twice in page_to_nid().
> According to the warning of lkp, switch the CONFIG_NUMA=n
> page_to_nid()/folio_nid() stubs from macros to static inline functions.
> v4:
> According to the comments of Andrew and Sashiko, set
> page_to_nid()/folio_nid() as static inline stubs returning 0
> under CONFIG_NUMA=n.
> v3:
> According to the comments of Andrew and Sashiko, move
> ASSERT_EXCLUSIVE_BITS out of memdesc_nid()/memdesc_zonenum()
> into the page/folio call sites.
> v2:
> According to the comments of David, remove useless comments and use
> ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
> page_to_nid().
> 
>  include/linux/mm.h     | 23 ++++++++++++++++++++++-
>  include/linux/mmzone.h |  7 ++++++-
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..772bd1fc6fe7 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2294,15 +2294,36 @@ static inline int memdesc_nid(memdesc_flags_t mdf)
>  }
>  #endif
>  
> +#ifdef CONFIG_NUMA
>  static inline int page_to_nid(const struct page *page)
>  {
> -	return memdesc_nid(PF_POISONED_CHECK(page)->flags);
> +	const struct page *p = PF_POISONED_CHECK(page);
> +
> +#ifndef NODE_NOT_IN_PAGE_FLAGS
> +	ASSERT_EXCLUSIVE_BITS(p->flags, NODES_MASK << NODES_PGSHIFT);
> +#endif
> +	return memdesc_nid(p->flags);
>  }
>  
>  static inline int folio_nid(const struct folio *folio)
>  {
> +#ifndef NODE_NOT_IN_PAGE_FLAGS
> +	ASSERT_EXCLUSIVE_BITS(folio->flags,
> +			      NODES_MASK << NODES_PGSHIFT);
> +#endif47

This is getting ugly, really. We're leaking implementation details from
memdesc_nid() into folio_nid().

Maybe just turn memdesc_nid() into a macro where we can just do that check
internally? Not the best thing in this world, but better than this here.

-- 
Cheers,

David

