Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4800ED3E793
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 05:38:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFC26B0005; Thu, 11 Dec 2025 00:38:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D74C6B0007; Thu, 11 Dec 2025 00:38:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED466B0008; Thu, 11 Dec 2025 00:38:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0169D6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:38:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9AD06BA759
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:38:11 +0000 (UTC)
X-FDA: 84206084382.16.516DB45
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5D8D240006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:38:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RzKDUUTv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=enhJYY3w;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GeSjbtlv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wnSsMKH1;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765431489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPZrLEmjQ4PxA/58AozD92W3ErV/wZxGz5NUQYproPQ=;
	b=nBjcHqjQy5ezVcB8w9o4liYyp91OGGyygsDzhHsmscjOHkJk1EQaodcKpCcEJfA+76ilwA
	mtFkWhu4dI6NsavXvnLlxQIxYtHa4qQANFsEZQeAe/fIkHsmKCakUtYsE9pbZAT+p+yil6
	Irn+I1SD0wevPHucP5IotSbH5MlOHiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765431489; a=rsa-sha256;
	cv=none;
	b=5T51cVVQPr3iE5SP6dqqSksyECs8ILcRRQBhI4jPBy6bGUJbjJiSPwagQLufBEyEIgDi5i
	GexVBKQN2/EYL1BX4YZht4oD965dsXr5M4d8Lm9gM/ZIXAHd8aWsNO6izRiVN9TlkPYJk1
	pxe94w4TXjgJaC53pxkyNGQNeNjXK8E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RzKDUUTv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=enhJYY3w;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=GeSjbtlv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wnSsMKH1;
	spf=pass (imf01.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 864105BDA6;
	Thu, 11 Dec 2025 05:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765431487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPZrLEmjQ4PxA/58AozD92W3ErV/wZxGz5NUQYproPQ=;
	b=RzKDUUTvktb6lu4JXR3lHWXoaWHxP2wTZGqQgbFD3xDriMqu6T4saOyqou9uV02lpE6aOu
	S3WX5pcqjd8ZgSoXS2lsfEFNObYyWhI/Id1+mFWvlNrA63JOBfPr/5l2v23upkAcrDiZ82
	+Dz0D2vwO15nDzDVlt5V8Lp/BPkVm4A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765431487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPZrLEmjQ4PxA/58AozD92W3ErV/wZxGz5NUQYproPQ=;
	b=enhJYY3wXxqj14AbSbTlday5ZXhDXMxtnh7uphmTAr7wJFIVbDfHLbq9upeDMjHgbUOUzg
	eQc1Ic/BhfKK9hDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765431486; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPZrLEmjQ4PxA/58AozD92W3ErV/wZxGz5NUQYproPQ=;
	b=GeSjbtlvbpFSEkYqxK/4MCNW46dr2r39hdVHZsWc1Ja/5wGht0GP2mRrH4+M38jGMrX2sn
	8UGnwPJ74asGzaTRh0bn/dFKLJPiwiSUyeH3rOK0NaPLP4wd75wX6AsGFsrsfg0zbx7J+e
	6RkUB1/DXfkQZrcf1lR9hEtdMUYV32c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765431486;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPZrLEmjQ4PxA/58AozD92W3ErV/wZxGz5NUQYproPQ=;
	b=wnSsMKH1sAnyC1qqq1pPo9t5dEHQP3gNip9KHlpJzy97LupYGirH5A1RZ7dr/vhQbhiOfs
	hgVDQuoyDZcb0gCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4020B3EA63;
	Thu, 11 Dec 2025 05:38:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fuLNC71YOmkmLwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 11 Dec 2025 05:38:05 +0000
Date: Thu, 11 Dec 2025 06:38:03 +0100
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>, stable@vger.kernel.org,
	Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH v1 1/4] mm/hugetlb: fix hugetlb_pmd_shared()
Message-ID: <aTpYu4gQmFCFh69X@localhost.localdomain>
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-2-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205213558.2980480-2-david@kernel.org>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5D8D240006
X-Stat-Signature: 55jhcxxuifh1obca1joz7rpd4fem31am
X-Rspam-User: 
X-HE-Tag: 1765431489-34557
X-HE-Meta: U2FsdGVkX1+di7PpsiZKJ4fb6uBohxolAGlE14V8vb/7iOZdffL85JUPiUssN+1/McXwhqIFv/38qt4cJl/YT+kY04IlnrHU1QdEgk+EWRkjz4XO+SfXcL3f7rKMSIidiZauDH3YfrS599K/LX6KMdNxoKP+IRNJainEKy7vtBBryflfSzxs3aJ+gMOML5y9ojDUs6cxkQPub8GUjziJxPRIrMjy8xdKPyY3Mn5u2D6CZI9eF04es5JkHUefnt/D7bvX7+4vMaZ4ISG5AzZDoig0ar618WsjW0XwOPT0+eMjhMgtVfsUl5idMhPV3ZW+luBWcrwD2iSEccCg3ml6PFEvpdjYzzQxLEgI35hYB+jDBMGId86ZR8caAXuo1MxnqEwK0L1U0Rmet17SMkK8tLDS7bE+9bsCxMwoLRClmtLA75+TsvJWWv4V03V0wdRmstyOkoPx70i6IOixFW6mh1T4u3nzgNB9T4VobY0TJ284bhm34XwSMFF2Pqe8zEGtR65W24UhhrBCVXD8L1wz50nlWIy6aAwojNPU+vGa+5/2sZGY/rVJwkS+kPfPiL7b/T+2KwD8XBhTJPgTN9k4MRs+eDGlRsrbFR3rg1un+dICW1YAPbuIqzc0zoaa1GZ+WeEiygkj7Xyv3nOYOmAw/AZLc6PpuBDJx2Zmcs42JhPDqn73ITvyZmwRgy3uGRasLyyzUNNkg2Tt9GcOPzn6Aw3qbTSjA+w6cIQkIshqEgAINFVh2QKHTCtVYrY3XmM5zw200gYXBQrIss64AkfWpTfchOSO8P/yXBkQ3L3rjVyWRsWLwxz34laBrZ9e9E7WcTBT1lcwxAKPE4quT+zKTxrLHK/cDnGzF+oah1Y1njHERkeARtFKsWRtS+L/9vaQ6UOpu/Y9eJlHoPE7rK7aIzKxmqPQlRyiJgz60Pi+Xtlxo0ittIcDVypHg+1mnu74TCdI8eM01qAIDrYmfb0
 0dqkKvZ6
 GybbkCbkbPK36k0rLDSvN8hdpDNqRGIYUnEk/kAALXveub2SKKVBdryEmGJ14h/jZkliVrHutzaJu9m/MbVVh25+fsG0ASiIvVnk78y1f+iaqQLyev3EDBO1Pne2YdKmp6dwUuFSidCx3W4obvjxR9k2BQGR6hu2bPFH8rItIbZvf/NgcG9dCIVZesLSq/4MmFnJwHeBBWhaPaQsONHDuv6sFaUDZ2Nty4tMIzC671L3nHRJKxvzZ3yOCg77BHK2htTqsBNQKFyaK5C84cGXEJtbtk3FY9XRYkgsVNiT+x8JAt9/wx7WN18uB/kN3fG24j+wGmyQsDTLjBc0xvo3TUakQqsCuIaXx/0ZQlsM+5/23DWQHiOXczyUjJ3VDaAzPZJXPbHWlqUs3UQ+EsgGPLWpmAW/yjKB6sdLsCZCYnnLeAebGDxGVDwK/1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 10:35:55PM +0100, David Hildenbrand (Red Hat) wrote:
> We switched from (wrongly) using the page count to an independent
> shared count. Now, shared page tables have a refcount of 1 (excluding
> speculative references) and instead use ptdesc->pt_share_count to
> identify sharing.
> 
> We didn't convert hugetlb_pmd_shared(), so right now, we would never
> detect a shared PMD table as such, because sharing/unsharing no longer
> touches the refcount of a PMD table.
> 
> Page migration, like mbind() or migrate_pages() would allow for migrating
> folios mapped into such shared PMD tables, even though the folios are
> not exclusive. In smaps we would account them as "private" although they
> are "shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
> pagemap interface.
> 
> Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().
> 
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
> Cc: <stable@vger.kernel.org>
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Good catch David,

Acked-by: Oscar Salvador <osalvador@suse.de>

> ---
>  include/linux/hugetlb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 019a1c5281e4e..03c8725efa289 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1326,7 +1326,7 @@ static inline __init void hugetlb_cma_reserve(int order)
>  #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>  static inline bool hugetlb_pmd_shared(pte_t *pte)
>  {
> -	return page_count(virt_to_page(pte)) > 1;
> +	return ptdesc_pmd_is_shared(virt_to_ptdesc(pte));
>  }
>  #else
>  static inline bool hugetlb_pmd_shared(pte_t *pte)
> -- 
> 2.52.0
> 
> 

-- 
Oscar Salvador
SUSE Labs

