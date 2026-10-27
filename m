Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B66F606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aFWzAiNO
Received: by kanga.kvack.org (Postfix)
	id 394436B05CC; Tue, 27 Oct 2026 05:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D7E6B05CD; Tue, 27 Oct 2026 05:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E5206B05CE; Tue, 27 Oct 2026 05:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E8A3B6B05CC
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:03:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 77F06140942
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:47 +0000 (UTC)
X-FDA: 85367818494.16.9156648
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7198720002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:03:46 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aFWzAiNO;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793091825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ou2bzquBC/XKiNlDijnd5jSZ8RDQt8o6x/7yZtJfCcI=;
	b=6KzVZHIbDNUOBP7feSY8EcaHunu+WnX8MuEk8BAQnfs0Bp0h2Qtjb0g4Eu3fKjzQZzaMPo
	TFnV1U2VIg0iImlhZhKUQFsyPWy7M2qA6BhSoNcLjsxJcmQBCh08x4e8Tq+lv5Iy5upQP2
	eyTRkhY1RSv8eNXrhDBFN7K0NR6eHko=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aFWzAiNO;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793091825;
	b=snt2RGekNJfJQZPgI1X34GTMh+lFqirY79raysTVoA7C3jOou78G6LJs/dDr7McEwUokT4
	Yq7CTMVPq+thwL5basuzGRt1v0R/pMdRXfBWXn9lgva/s4tEVAqP6Q2O3hCSnH24NICOPp
	JHczjXtHTXQzN6RQxwzpzFnD++QNTKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A9BA60136;
	Tue, 27 Oct 2026 09:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998501F01825;
	Tue, 27 Oct 2026 09:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793091825;
	bh=Ou2bzquBC/XKiNlDijnd5jSZ8RDQt8o6x/7yZtJfCcI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aFWzAiNOHMFBC1Hqm6iDEon6vBAC9RDDXyubdTTqZNLXHwbtQM7QEdi0H5J1GC8XB
	 J/vnQgayLzmTRRsiSNGcjtzHJZxq8iIGsO/UWZFXRJ5+AxiEFdkizoaCAnYjdVChj8
	 3Vdw6XB0ercN9TQJMVEMrof7GNQbDFVVvECOY7Zz6M1kS92GTc+1au6YMtu2XiWv3h
	 DKxlQRvpi0qW97ZuVlUqSlN8si3FhXuyfZrRFJyJ0NSgwW8DSV2hJrHi13NenV0kTl
	 1TSRdB5Aouz6M/rlIzg+FmaxLlaWLPxdBWmIIwyPW3FgXclkHd91Kl2dLWqHmNPgYE
	 QLvdekKEE1fFg==
Message-ID: <d2738c37-7801-4804-bc86-2beb81256171@kernel.org>
Date: Tue, 27 Oct 2026 10:03:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: use account_new_hugetlb_folio() in
 add_hugetlb_folio()
To: Enze Li <lienze@kylinos.cn>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <20261027060446.289404-1-lienze@kylinos.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261027060446.289404-1-lienze@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7198720002
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: n5k9gnzi1djroqd1ueo8d3pos8fi5de6
X-HE-Tag: 1793091826-178764
X-HE-Meta: U2FsdGVkX18eg+o5MH2Z0aACdA6/452rgH34t0ba+ly0/pznv1zKgYlqmmPAA/8q4MIgBs3qLqAghRn+MyFjK9sFZhPnXakKG2Bwe02BMj4fIvtNCVR1K04WHsvngWMsc+dlgBYpojIuaTFuyZEQT2azrLS0toS+my6WH3X6va/WankHJkUd+Xf4rPnVsq2fxWeENGKUrxtwZfT3l7tUNtSpZxn5KqBX3EIiq2q2fE8xQRFQ9OXNn6RETwFbjayBWUC5snn7hKam3lPoOBPnVsvBui9tb+USaMKYOqnxmtMCfd4QazVPeyuqqJZ+1A18kN6fSTUvJlJIAXXKjf7T00h7uJnSvHgck/p03aYg1pmqp6BmjzjpY7pUH6jOvUh5kkN/q0sc7A4QKo1Rv5/T/kN0wCjp5cG5x02TPeupH+IITxA0COHAtc/3UAzkx6rul6DwRzXQV5RJThKPhQ4QFwK4swKG2sUP1VzvVeyYZadeix9si6a989nTEnMra4ejy1UucaTKcyf/mo98vN7ef190iNEBXR7LHw+ru1KTj4vbMggenj/6eDLK6j/7TxMoMBr9ntz+AOHsVAdnoUV3YtSIg6MDEAud9592I2WPG2uLN+TFMpbcecC3xVPYWJf9LhrXkahhTsk/xKvwhQb/6t93FkXcJ0HZ/MerSDU2PZyOQP44CGARGhZCtn2ks/DxaurttcDGCMEATDj5J3iFMmVO4x52aB3gxOHmdnmA5V5eYauMFl60rUvoJeUGpEXT0+g3ApXJL7f/EfltT0Aatv3xGYYZjKkLlUJ0zB80wibSkbUY/3HXZc9YIanX7CFsFTzU8k9qyvrPPMhi1OaFLACw3gOCwag0mHOIKkv6EfF+ix2WUEv3fWf3CYx/eUTCe8fBm1WqShHbRotCj/axJgVG16lP20PLYfalW31w3t95QS6GA6gsX6kYrVfKQDRIz9Sci4CbT+JmHH4as/J
 pdZUT7I+
 oN7cibAiQMV7+r4dfLpXK9ssoJogZmtGeikpn1AoinhV4pBZwLzI0uk5s18ZqPkYShRYyFBbwT7t8LEHs630u2uB2/KbaQgyNYwP6rJfLKD/t1xPfjpoa+FJ8uPTxIT7TQx57ThSuhuph0cobosK31pHVuBUDoJkB3QY4PMyU7UnEtjLI60qUtQul2Y/q0tpVsXEeR0VWkqoAVtS+GAXgLvKzkVAZzexPNPkn2h1yhO72m9nR0vxzPHHycb5ZeomRB67jOSmQ7ABxlu6L+q+1b2QpwqppZtvDIHYI042VUyogVyg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 07:04, Enze Li wrote:
> Every other place that accounts a new huge page already calls
> account_new_hugetlb_folio(), and add_hugetlb_folio() was the odd one
> out, still open-coding the same two increments.  Swap it over.
> 
> The helper is defined further down the file, so add a forward
> declaration for it.
> 
> No functional change intended.
> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>
> ---
>  mm/hugetlb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 4a008afaedf9..a8d162449daa 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -142,6 +142,7 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
>  				unsigned long end, struct folio *folio,
>  				zap_flags_t zap_flags);
>  static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
> +static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio);
>  
>  static inline bool subpool_is_free(struct hugepage_subpool *spool)
>  {
> @@ -1444,8 +1445,7 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>  	lockdep_assert_held(&hugetlb_lock);
>  
>  	INIT_LIST_HEAD(&folio->lru);
> -	h->nr_huge_pages++;
> -	h->nr_huge_pages_node[nid]++;
> +	account_new_hugetlb_folio(h, folio);
>  
>  	if (adjust_surplus) {
>  		h->surplus_huge_pages++;
> 
> base-commit: bae9a042b03b27924c6fd5bdc00a20d6a44d6041

I have a fix in that area planned. So let's revisit that in a couple of weeks.


-- 
Cheers,

David

