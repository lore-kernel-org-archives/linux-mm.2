Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8679A606A334
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 12:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=irnEG9J2
Received: by kanga.kvack.org (Postfix)
	id A915C6B05BB; Mon,  2 Nov 2026 07:56:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68BF6B05BC; Mon,  2 Nov 2026 07:56:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97FA36B05BD; Mon,  2 Nov 2026 07:56:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 74B116B05BB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 07:56:53 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 160F740CCB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:56:53 +0000 (UTC)
X-FDA: 85390178706.23.5748109
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3E721180003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 12:56:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irnEG9J2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793624211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=blL8YXc+drVTz8krqBB5UB1MrPCv3ruMb4bo9ij/yX8=;
	b=O7BwzrAU+jLkFiAgCR2rn0OIM67b9NLomMz0iEVrOzlKYhLYOn7o10xDE7ZnhZs06OWOzv
	XUYDSDEtJuWtl8l4tHv1Wrf6Nfe7oD6aeYGaRnu6O5xG5AbV4/sn9ew8O0WEjijTb9Dpog
	Sqa0f7fyrBdDtGcnqJRf6zCfomUu+C8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irnEG9J2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793624211;
	b=inpVYwF2CutG2ZLiAV7QAJxyuIPod9lkVswnPEPMNe6c6zny8O0/Ujdwx0WWraqGHEWbrq
	w5ZrOhfKWHnMLDVO6LZIrGqxvIMtaSaL9smCrDZzqbTG+TLdY9e3rRE/QyRiw/dyEq0Sq7
	zKSu1uofD7USc+XvocGZB1QvoOY7ysI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75F14404BE;
	Mon,  2 Nov 2026 12:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D58C1F00A1B;
	Mon,  2 Nov 2026 12:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793624210;
	bh=blL8YXc+drVTz8krqBB5UB1MrPCv3ruMb4bo9ij/yX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=irnEG9J2fS0STJK2Hxj5gTVa481M+mWppQY4mrkdog3E0PEnjFBG4xB6z/22UrzGK
	 pb3izZ4bzSiD8hi/MXvOud4UIGcCNN9fTVaBBuDMNwIqIG7U+0JJnio/4QQwvu74rZ
	 wga0hL5FXQappjSIPyWKosl1EPA7PBD2ixWdyIFOzGo/P1qo/N47zNgfB5dL3N+BYl
	 jKDO9GlLb9kJDLfT/Smrism3UeWT/3M8s2IG/ITMWlNioda+S142G1d6Sa9D3C6vBY
	 swRcYPc6lAJCGNP4p8lRIm+6KkLqM1ZwBKnimhBYVQbkR7uF5J1CfTNOv9qaUVKXAJ
	 gSDT467oYpa4g==
Message-ID: <c6208509-9175-480b-a6f9-f60a999e9317@kernel.org>
Date: Mon, 2 Nov 2026 13:56:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/15] mm/hugetlb: account temporary folios separately
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, Dave Airlie <airlied@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, stable@kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-4-a0a033db180f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261028-fixes_hugetlb-v1-4-a0a033db180f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3E721180003
X-Stat-Signature: faeqjfrc49613n464aqsgomzjrz6igf9
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793624211-626521
X-HE-Meta: U2FsdGVkX18xtVITtIpFlpRFiPkxdMPUh7OZrgt6oDivQYZjGIzvc3jElqt+SNMu12CDknkkSh8chSJYL0vIrDyaLfyE0LscR+r1l3ZmC1xCkliQYpzkkWG58rgATbWusrb9LPZEyXQ2BKlTg6q3IXwFCyS4cWq8u1yDBBJhsn1VAmQSvLBjaIlJyu9qsfSKcPALVN1wCgGFeSqge/Plxgy7U8o6RIogrKReiGy7zcVpVBHkCMKZodzy6ES0dDNZ0n/nmws65NNgxdwo4mU3tlsczlSoPyI+ucmLXFqXGvvFrx+EO32H/oCYWJECHr6uLOjLGqYFAXaI/wLNw5kn5xllAonGO1j4eprUWSo5tnGdNqnR1qDqo2h4JxJUzva1I4GuBr1WSykSyZFWq89vMVY9J3/G9RAxg0v8f+NEOMM6ulBvSYNE1dMEvZs7AOyQUC37rf9rOlPR12r5mNN9K02gFOaWO9sTUwAcNUJ4TSvp8PgyVVAcSNqcj+0LPizH6FZGYvW+UNBRxrbFSFI3dinthUcviA0yDw7S/0P+iHhKNVC8hMaHEcyZ6ZQHlmLSz39iEVMfO41Xy/UbMHxYyTqRm5Kt7TiMzTfwDIZRYDzKN3zQdNMDxNMnSaR8grHxkR2VZAo04A/sOvXQ0XjwZMYcEG5xX87sxtU+IaES/FEHrmxpGbVAs+e3P0dpH4/g6KrVCLiX8cliGFgm5HcvngWFQuRYS3m3axjsVrrip21xWe1iIAjfHG8FLPUcI8e4C7CadjKqH56EO/3jgRtyziy8tMz0AAEWNSzcqX4aHaEPE9OA3j7JynaGqV4kftbLt459HU3R12mpfLmBKiXW4GbuDuDdL6vjEz/wsAqvmeImeylEzDS7mINxqqiXS1WCk1I3VnX9pqm+pC99jqcEMWpYBlNB0Ao4mmIQbl5iGtzZm7uPriWIo2blSVVNwLLo8aT1jZMAN0cNybR5gt0
 XR2rlawL
 tX+uQKfPEQGHeaqZlm7kEln+6dmOr5MiobQkYlqAvErGEbe/zyz8jGIu45EJMOeILoMhFRpk8gXIl3Y2cxXQ42aQ+WFys1Uz3uC/B/pXsMakdOSJ0fi8gI9mzUvUM8jyQO4WOeUIpfGnxe8ZLv8PSQr4bC+gMMtjM5RzqAdiBuuns9n/UPGmD9WtcajW1WRtbazCeOpCPuwkLJR+J1wQzl4SiMmGIxYp5OfKcC//kk+U8uq6K9qp4p7H0oAemV8cdDGm23qh4AbP3zTmQDYC45UG4ts6hxx+FL8UQN1y9In5o7TL4HxAGaOBpFYnZwb8GwKHEgHXc3R15ty5Eb43hgzGXQyzNcixRrr7LwmAObQ8Lp40z4bPFQ9sUTL/WJZOCoqIvL7TFJrUJobLvDpUD1o+N1hS2Y9CtIwxcHfZRK3BGQWI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 21:13, David Hildenbrand (Arm) wrote:
> Hugetlb migration might have to allocate a temporary folio through
> alloc_migrate_hugetlb_folio(). Such folios are currently accounted in
> "nr_huge_pages" but not in "surplus_huge_pages". persistent_huge_pages()
> can mistake them as persistent huge pages, as it merely calculates the
> difference.
> 
> If set_max_huge_pages() shrinks the pool at the wrong time, it will turn
> hugetlb folios into surplus folios until persistent_huge_pages() returns
> the desired number.
> 
> After the migration (successful or unsuccessful) either the new (temporary)
> folio or the old folio gets freed: this will reduce "nr_huge_pages" but
> not "surplus_huge_pages", to undo what was done when allocating a
> temporary folio.
> 
> This can result in having more surplus folios than actually allocated
> folios:
> 
>   HugePages_Total:       0
>   HugePages_Surp:        1
> 
> From then on persistent_huge_pages() returns garbage.
> 
> To fix it, add internal temporary counters and subtract them when
> calculating persistent pool sizes. Update persistent_huge_pages() and add
> persistent_huge_pages_node() to make the code easier to read.
> 
> Count migration targets and rejected surplus allocations as temporary.
> Transfer the per-node temporary count along with the temporary flag on
> migration, such that folio freeing will always do the right thing.
> 
> Take care of calling account_new_hugetlb_folio() only after setting the
> folios to be temporary.
> 
> For now, keep temporary folios in nr_huge_pages, so HugePages_Total and
> Hugetlb continue to include them and overcommit accounting remains
> unchanged. The new temporary counters are internal for now and are not
> exported to userspace.
> 
> Fixes: ab5ac90aecf5 ("mm, hugetlb: do not rely on overcommit limit during migration")
> Cc: stable@kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/hugetlb.h |  3 +++
>  mm/hugetlb.c            | 65 +++++++++++++++++++++++++++++--------------------
>  2 files changed, 42 insertions(+), 26 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 5029c7241863..d49cb15d13e6 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -701,6 +701,8 @@ struct hstate {
>  	unsigned long free_huge_pages;
>  	unsigned long resv_huge_pages;
>  	unsigned long surplus_huge_pages;
> +	/* Included in nr_huge_pages; not exported separately to userspace. */
> +	unsigned long temporary_huge_pages;
>  	unsigned long nr_overcommit_huge_pages;
>  	struct list_head hugepage_activelist;
>  	struct list_head hugepage_freelists[MAX_NUMNODES];
> @@ -708,6 +710,7 @@ struct hstate {
>  	unsigned int nr_huge_pages_node[MAX_NUMNODES];
>  	unsigned int free_huge_pages_node[MAX_NUMNODES];
>  	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
> +	unsigned int temporary_huge_pages_node[MAX_NUMNODES];
>  	char name[HSTATE_NAME_LEN];
>  };
>  
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a78b2487c20c..110a5c2d9e50 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -115,7 +115,7 @@ early_param(str, func##args)
>  
>  /*
>   * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
> - * free_huge_pages, and surplus_huge_pages.
> + * free_huge_pages, surplus_huge_pages, and temporary_huge_pages.
>   */
>  __cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
>  
> @@ -1337,7 +1337,13 @@ static unsigned long available_huge_pages(struct hstate *h)
>  
>  static unsigned long persistent_huge_pages(struct hstate *h)
>  {
> -	return h->nr_huge_pages - h->surplus_huge_pages;
> +	return h->nr_huge_pages - h->surplus_huge_pages - h->temporary_huge_pages;
> +}
> +
> +static unsigned long persistent_huge_pages_node(struct hstate *h, int nid)
> +{
> +	return h->nr_huge_pages_node[nid] - h->surplus_huge_pages_node[nid] -
> +	       h->temporary_huge_pages_node[nid];
>  }

I'll also use const pointer here.

-- 
Cheers,

David

