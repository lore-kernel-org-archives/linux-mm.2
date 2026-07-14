Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C72FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801696B0098; Tue, 14 Jul 2026 09:05:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8256B0099; Tue, 14 Jul 2026 09:05:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE4A6B00A0; Tue, 14 Jul 2026 09:05:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 48A416B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:05:15 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0475C0397
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:05:14 +0000 (UTC)
X-FDA: 84987402948.02.C22E340
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AC4EB20016
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:05:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZ0obx5O;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784034312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HhdQiVTu6KA3opOMmKVdmA07qpV4bmi8kt8ZDXJ4P3w=;
	b=B5rbtsq0s7zb+TvmSejxL+2wHL2DjItF0QtfJMny/NUfGAyU8nhGztJ4fPREhzOnkuy5+R
	Qs3ACmm+x6MMZxvdjmMn9YhLI6sOZpW2A9MMGdAd/Estl6izTQbxt+N2ToBS2HJimcWjms
	JwyPuvLP2lgPR4oBHRb6HczSZz3r24w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZ0obx5O;
	spf=pass (imf03.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784034312;
	b=hyLkPuwNqSnQbYfb9rcpuwEtQEs+oXG1882gerZ0vQRlh4zZKWNRPZOM9/dE3iXPQy047y
	KUkddcRdVhU8iv8T4JHeKDcKpiEBWKd/L9I+NTGiMNSKk8wXG5MfKSYJT/Fu1YMQw9xFlo
	LoBHcRcLkeHoR1dERDfOr7fa7g6zSWI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C2E5F40986;
	Tue, 14 Jul 2026 13:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3788A1F00ADE;
	Tue, 14 Jul 2026 13:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784034311;
	bh=HhdQiVTu6KA3opOMmKVdmA07qpV4bmi8kt8ZDXJ4P3w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PZ0obx5O3QFI6l8EJIJYSOahVEPqlrLTU55V39v8H62drxItp5CWFCFACTgEGkN42
	 49T1SvqP9IH9lO7G6gP/vg7eqKISrhHNtrX990wuyt9AX9hZscHITYKWFAiHoj2+xA
	 1NHzriP7pQqqmQhMlAZtwEXkitGoB+Hin5Zbj3F1CgcYoYc6/w82Ihe8jPrKj+mqwd
	 sdCJ7sih4ypqNkUCrfPATiNhD9bR1YGVXxWz0p/feArcgNfFoRB0GPiBkxee9h3xom
	 PB5bmYyXRxQifynJ9kK0RFC6/uxoOPjzaBcvBf2+UecHRpcOp/uhYqtyzcbiR54gtN
	 kgeNloFpdy1RA==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 52E95F40066;
	Tue, 14 Jul 2026 09:05:10 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 14 Jul 2026 09:05:10 -0400
X-ME-Sender: <xms:BjRWagNi83rL4RE4Qzq_CHX1oez7HKXUjA69k5PADjg3PaIWoPBTHQ>
    <xme:BjRWajuX2JbZOFCP_0cGkfRmZeEosQPaK5cnLePrvffit5u1SFwjcehQfsiruyRXE
    dDiJXl5LhOmh4bO0xBsntVijiISR7BYZm6fv9Y5MWgCZ7stuMOp4Q>
X-ME-Received: <xmr:BjRWam0wnS74KGev3VJ4KM43BoAWCs57Lf4nzrXSFn1nu4B6WYly-DlNqVH81A>
X-ME-Proxy-Cause: dmFkZTG2+qoH7YKbDlyzXcMOV8ogYXK4x4YWWZstIygUmJWSdfFUXxfKJXPuuHTq2il8YC
    4dFtu85gFPcaTqNqU3aftuUiHdYh4lvK7JQllt5w6x97pLVFtkNXm61NuG8tobtjLnb1tD
    1hFuzcLAw4HMnUo2y/t/BIi/qcl7+Or33WV0BjsbndomlgUzbeg806UaEqP2eQgCQmppi6
    fTUKJvXwLMnoXzycderldx42CWnKTyFto9X9gefWfYhFuh4G13cjBY7lCc6dm6nJbOdJEr
    QmVRL1usA7cILcT60xIFIxTl8Q2AKHvsb7RObv7EXRP4L0GTAJPp8h0BJTedLoQrWtQZLG
    hDZtzhI3EB7g433rhNA5IWc34XkTIp9Z2/FSm/ysYplg8uDejU5w11BnOdZAWXsIrPya8C
    YmFZHyyuEOGu7e3AJ+kWdN5NaxqHbt77Yc7+dL24yiuoPL1p1Sg5HXcG/roRy0ISvinkhH
    BOnYaQz3bIkTvFYAWS2QBQu7XrGNlfTCgZeOFQaPYwJ0qYCnXbEbP6IXLibUO4AOsNNSYI
    vPav/2j1e4ojOQVJaooohbHypA0+XXKAZScDO6PzZNp++wkgoGrhTfTpxC3hG4LX44v1l5
    Piuqxud9l7rgnbs8VjBA0zGxCJVy1yYr2nlrM+T8Jpp89uG+0pNGRBegyx4w
X-ME-Proxy: <xmx:BjRWahXnTxBvcc7YhMqs8WKsrcQV186pH-2cmMOJIX2iWLEQYcVkog>
    <xmx:BjRWasukaIAcWGkwb_LYkDWN4F6RrN-Pn-ZTxmuZ6wRkecdntjWaxg>
    <xmx:BjRWaszQmfr2r_k1XmGT_xU59KGomGGlQzC-Lyrbb01VG2y6RSLNbQ>
    <xmx:BjRWajkdtz-OXhToMrbPm3KIpaCHey15lyJaI6zfi0t1kLqmaMz5JA>
    <xmx:BjRWaiZR_BGHImDMXqbUM9CSeon3mOfVtcr_uViC4Qam2j0jLwARoLlY>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 09:05:07 -0400 (EDT)
Date: Tue, 14 Jul 2026 14:05:05 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Hao Zhang <zhanghao1@kylinos.cn>, Hao Zhang <hao_zhang_kdev@163.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/memory-failure: keep the folio, not the
 poisoned subpage, locked across split
Message-ID: <alYzJ9-zsTuQl08J@thinkstation>
References: <20260714122344.351895-1-kirill@shutemov.name>
 <20260714122344.351895-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714122344.351895-2-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AC4EB20016
X-Stat-Signature: hu61zud9gaii8qgaxtp9zdc4cmqw49us
X-HE-Tag: 1784034312-688516
X-HE-Meta: U2FsdGVkX183A3yUPF5UbnKI+dkTnyfp49wfenjBC467BzOUcmg/9nULQ+qY/znRVsvMmkaLgL6PyXaPxCH4rhH0EpeufxHmK9dffMqEo+Z/krEe3E0HR92zs3dBmTXBQ+a+RRRfR5UTs/kLAbNV6Xwc2bwc2iWQg0TwVb9OEho0M4r2zMEpQBE1fco8JCzbxTqTZ/R8VDOBEscXK0xhDw9Y6LYPyr1H7gMDKc7XeeZ8+lczbAHB4365MuMIYbyTZDl1ft7hFqZnRJXt6CUc3YhAZSAB7zYbWX4iIHdcKuwr0obLW4vaoFIaEOvLPN9jyUlsF9ldNcOgRmlZgbqTMg2vmP5BvIc41/oW6s75rejMuTGoy4HYOV8uFj7Zk6D2imZAwvwDH/O9QoqXblGXbXwWcIFF/O1x6QSCct2tm/gz9FPGwHU/4L1NxGELoIUKcS43xdCfaGs9oxo7GSLbbhKjZS+/Y0nhXsyWBh5a8Fbv6ij9attEIaO2c5tmnQm9NgsTah7wg3uu8vCU7ecbom2hIMsqwz1llpe114GhGmU4lvcRIwvjD1NGAVgLuRGAtHcmgd9vVTyyr23L4M6SD0qwbVuJLhIonYbVbrvAIwWJWpM699IeIDFUO+3Z5IzohddPPmwaQWJBM3dSTNFbWhEkCpUpnJOHv0IA3CorNoltwaH0mwv16KoB/UiGhUmSdXkp77RPlSVl+5z3ox801/5zJ2UNy6rMMVCDpfTFYVJVvtT/hHorm0AUyi6O5Q5bV3dDHrPbJKpX1tByVMLkH9CpfiTRr4QFEsEUe15vWtK0YSH6jVoB7YbJWqy8H43fPyskk9x8EFnhc1qIYrRoXyPmlxCJeWg0hTVdJjoCsK0HVK4IMXQccMVMwY53PKUyp78SVbz45iQXu1uccbcZ9rjS12aJjchYPs6jsRFA9JdGPhfaIjfzSv6qR9bIDReen8edc76F/++h7RhgeaZ
 0CP9wiHk
 b8h5AxfQ4DTjsJfheGWWmKXcwVqlcL3bVStGrJcFGy1Ufnfl31iAkKpwpgFZM4v3sqlvWFckivdbWaNeCY3605alGTuPJlkQVOLzrvSz0UEq+3viSoehXP9ugcf7GYKrFFDjfsdIc9Y7G3pDubWiWy4kz3uHUcpPn0eQcSCt5dc/rAopFaMGsWeUXZbL6kZYdnyLTd3PzNUW2VyB5QiQU1z3mM1HY4EEKDZ2ThDpbM7kQZtn97PEblOyXnPh4dkjtIM6RAeKjIaUnNHYIajUjpaOeW5prNwqQUUtxVwkGbDYx6Ah77j8v9AS8VR54LJjDT1k31l+B9lfaZECm5hz0eeMub08w2Sf/78fk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 01:23:40PM +0100, Kiryl Shutsemau wrote:
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 51508a55c405..68d42cbed458 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1657,11 +1657,18 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>  static int try_to_split_thp_page(struct page *page, unsigned int new_order,
>  		bool release)
>  {
> +	struct folio *folio = page_folio(page);
>  	int ret;
>  
> -	lock_page(page);
> -	ret = split_huge_page_to_order(page, new_order);
> -	unlock_page(page);
> +	/*
> +	 * Lock and split at the head, not the poisoned subpage: __folio_split()
> +	 * keeps the anchor folio locked and needs it to stay in the page cache
> +	 * to pin the inode. A tail beyond EOF would be dropped yet returned
> +	 * locked, losing that pin. The caller re-locks @page afterwards.
> +	 */
> +	folio_lock(folio);
> +	ret = split_folio_to_order(folio, new_order);
> +	folio_unlock(folio);
>  
>  	if (ret && release)
>  		put_page(page);

Ughh.. This patch is broken, sorry.

Please ignore the patchset. Will follow up.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

