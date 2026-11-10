Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B50606A32E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrTLwSLE
Received: by kanga.kvack.org (Postfix)
	id A4C906B05B9; Wed, 11 Nov 2026 05:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24306B05BA; Wed, 11 Nov 2026 05:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93A406B05BB; Wed, 11 Nov 2026 05:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 72D636B05B9
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:30:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EC1CBA0278
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:30:39 +0000 (UTC)
X-FDA: 85422469398.21.6134C07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 374F8180005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:30:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrTLwSLE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794393038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxrhFMa8/sp9xXjPYISbhRzyRkp2BmT2lD81VC2uH5g=;
	b=lU1QguqoD3RLH4BhSCCXKs3x90P7tfNrOXGSmUeu5eyXLDv1ICn23S5mH6I5xrBnwLpLxd
	jy3eb2z8yrcO/laftzCyjgZuths2T+mfC4HmJusyw/D4vwxz6IVXDG+GPLhDTqM0Iz699E
	LU3Q5nIR6vagO4zOjNdmQ5d1LFKz+cs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrTLwSLE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794393038;
	b=qNfplCBeXV2K19P2ZNaZM+9HbVoeWr+wrjA6cn3K+vN8uXVyDioQjF0C3WoNv2aI9IgW4L
	B3AByQ6/GFGgy1xatKxNxtk3+hwz1CxOIMHN89AoojHcVRpUJU4EWi1RSXj9YpR1KMhAOT
	1W2rm7Xgppta/0Ae0W0Q74e1ALIsn1A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B350B63C31;
	Wed, 11 Nov 2026 10:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB69F1F00A05;
	Wed, 11 Nov 2026 10:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794393037;
	bh=KxrhFMa8/sp9xXjPYISbhRzyRkp2BmT2lD81VC2uH5g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JrTLwSLEd+YvzAemdyR51xbG4OegeC7uVGwCapD1h/0s5JMcEnFwWTDyHw8hxhFYc
	 Yceo4rD3o841E85q5UtJ63r9LzJ+/IPSvgm54TH6mNqnP/tb0WyhsqEDBspvr1nMgU
	 Hu4Q34UrszFwNjN+s0A0uWuX0SBJx41Hhlkwlrl2IZ2jWWBFyeM5f6ONI7me+XJd2x
	 tDLrSIQN0h+XzgIJDmF0lUAShZ6b6bEeZ/g2Px2DPD5n88Mxnvvk5FF5+ArOFgekE3
	 KuBbgHWL/Op3aP1kzP2GjMevvmUd+kFCCVz2h+/uqELmyOPdyL+R577xO/dD9peHYL
	 sFm19EJSuqEpQ==
Message-ID: <e66b6c19-95d2-459a-926c-8429df693acb@kernel.org>
Date: Tue, 10 Nov 2026 14:06:23 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/6] mm: gup: introduce gup_unshared_pages()
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109-refactor_gup_fast-v3-5-2aaef02df0e1@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 374F8180005
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kbbo6g9z6h3acgzzi3rdfmnp3k1sxqs9
X-HE-Tag: 1794393038-553400
X-HE-Meta: U2FsdGVkX19o6BzS8HiYwE9jP4sqSs/0z4RJMztGY8ZD++QO++OQ7IsBXEI7setnsvxQURTNuyJdAuv9k7ETUKbWc8nc7+P5ErDQrRVx3t4gPEh1H6KYPRBi+FOAit6UWGZD0oNSOmWVSkmMhnJTACN7qocdCIHSVJ0eTRA9EM9DxjahsJeOZFD3DuUPTb/oyTHxdxHS6o4JkUNKqBzyNVv4sGjoafpEcwuhShm5mk/zR6/W0b2GAcX/wRMKkiiIEHIamPJ4e7zVbIRqa+tZ//sgrYUrWHJAjKjJ5n5GNnC+jgiFGWy0+PWVUhcKkd1A1bzsAN6Tvy/Rw3edNdlwQK8e3unv5wxa/EE+t6qEdudYE/1/3dB7fo4lZ3F4WQ1k62nQ0UQli22Wxr8lsj4Rf1hpqDkqZ47NFc5UlAO3OsaXhgWYsR2tEaoeyK2UpU9QKtNjmESN1u7pY31XX8YVpdYezX7dPnOxOA296zKq6olqEgOcct9uMScNP/N1WKK4Yfl198m8rBm9IbfFffgV50u86sR1zV5xkaZ4wuEWa2E9gACaEV0OgL/cwNe+N3jaZEXtDAeec+QZ6gM0lTVjWhyfYvV1GuFg6C4AVyrhR0whNgSp0JG8IET3YYNmcDUqehyOfT6tw7V8+YjP1ey4WMV7vo8rfVgdWT53+WVsOapH/Lb2W5FIkcXElDm70jCgVwY6Im0YwPkq2n+sXuWyAFC4GTPy+WcSryQ7fqyFrxwl+lYb49kpa5bth5PiufbTdPcSHwR93NedNK2e3WL6ItVqTNFXbNsQa1d/Cp4KTB76FB9rEdMOZxmAzQmbPsEHEzv/rFWZbwnJEhs99KK4EBdwOAVo2sgz26D8JazGLdhBv9p7GE/jVa3GTY3YltLhpVGApVQ4OiFATpXr5yTyANfsSl4UzyghHSMwBB3/svJF7HnBEwzNjdrgztMXE2df8zOyUSuBIi/vfUTSX6t
 lfG3H9hs
 M2ACSOVFj7spwMcqxSE7BSzvZZMohcPK7PRyCUIYXk+bFWkD4Yq6OVeyCPxmUzXR0WWwzEoMwPHh9u9uoBw19fTO0cqYgH1YzkanIg3vZltFumGcHA0V189u3nZsB1vWOS1Po9aOVdwZ+rBFp8IUTouDV4JdKJgQeMwxmMBfD4zql/CnX72U9Z159qylZ+4Hn56732w5Gr04gIDTQ+9HnCqUaM8IrmlqRvWGXHhH8j3MLqwjerqkK88Ckwwl4ZZzW71uv5W1UMupC/7VB3ibs+a0JIL68ogRsYFnUKEEkWDgnI/xaJhsFOXapQjbAzc7m2+rcuuS7HPefyas5vhcikUNOcGQoYxuGt7KQo2Ui/PXvn4c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 13:32, Yeoreum Yun wrote:
> This is preparatory patch to make gup_fast_pte_range() batchable.
> 
> Introduce gup_unshared_pages() to count consecutive pages within a folio
> that do not require unsharing, and use it to implement gup_must_unshare().
> 
> Also add a folio argument to gup_must_unshare() so callers can reuse an
> existing folio and avoid the compound_head() call implicit in PageAnon().
> 
> There is no functional change.
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/gup.c | 111 +++++++++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 66 insertions(+), 45 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index bfe83ce1411d5..c863bae33e2f1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -633,58 +633,39 @@ static struct page *no_page_table(struct vm_area_struct *vma,
>  	return NULL;
>  }
>  
> -/*
> - * Indicates for which pages that are write-protected in the page table,
> - * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
> - * GUP pin will remain consistent with the pages mapped into the page tables
> - * of the MM.
> - *
> - * Temporary unmapping of PageAnonExclusive() pages or clearing of
> - * PageAnonExclusive() has to protect against concurrent GUP:
> - * * Ordinary GUP: Using the PT lock
> - * * GUP-fast and fork(): mm->write_protect_seq
> - * * GUP-fast and KSM or temporary unmapping (swap, migration): see
> - *    folio_try_share_anon_rmap_*()
> - *
> - * Must be called with the (sub)page that's actually referenced via the
> - * page table entry, which might not necessarily be the head page for a
> - * PTE-mapped THP.
> - *
> - * If the vma is NULL, we're coming from the GUP-fast path and might have
> - * to fallback to the slow path just to lookup the vma.
> - */
> -static inline bool gup_must_unshare(struct vm_area_struct *vma,
> -				    unsigned int flags, struct page *page)
> +static unsigned long gup_unshared_pages(struct vm_area_struct *vma,

Besides the function name, LGTM.

gup_pages_requiring_unsharing() ? Don't quite like it, but something along those
lines.

-- 
Cheers,

David

