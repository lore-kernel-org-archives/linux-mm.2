Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 848BEC44506
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:02:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F726B00AA; Fri, 10 Jul 2026 11:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8102D6B00AD; Fri, 10 Jul 2026 11:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 701CC6B00AE; Fri, 10 Jul 2026 11:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 494166B00AA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:02:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D077CC360A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:02:13 +0000 (UTC)
X-FDA: 84973182546.12.05D567D
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32526A0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:02:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MZROCy6l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783695732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZI5LYV42PS6biPr4EpPtmNA2/Ct3B0vmxWhVv67hMQ=;
	b=Pr0W/E941YUXXK56xMKpJgUxb30U+44amu0mKpZd21PiSqmjuldKQvGZFoWktEedaofegs
	wz1FI6/L3cZsMTywvNEEuc+cg7uKkpwXz/U/DL1WAaPbhroe6pSo6lL1jkDYrdUreJ+ujR
	dhsHWO8IXWXeFs7BAlR2lMFc6IPaG+g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MZROCy6l;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783695732;
	b=IS3ceh5Y/dsMhC4Qw1jxMKhg8ofe5VdEHm551jRx2jv4key1lOkI2wmI2VC3LSzw9pB687
	uLIwoWNI1kDaqdFY/pWYTOnApqESOkKJQ/v3+wCUYD/SlpA4EwyF0bsRGQOAXec8TNUz1T
	EucxfL+iqtX87ucNJ5oNMlDdFGVK8so=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783695730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aZI5LYV42PS6biPr4EpPtmNA2/Ct3B0vmxWhVv67hMQ=;
	b=MZROCy6lL1QQmCPfIUisZeY0kM2GabQXwOtIPP3A3cm+RMRXSOgYac6UptYGQ7VhqXNeyw
	wtutsvb8aPqVZi6zc3EgSwoO0ln7YS4KO4nhj6JIKdxo8xv2KVisPl5jAXmGHUZKQ/nqtB
	2NYd28az7X/hUd6bbc+c0FbG1Akn/0M=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
Date: Fri, 10 Jul 2026 08:02:03 -0700
Message-ID: <20260710150204.1887475-1-usama.arif@linux.dev>
In-Reply-To: <20260709184740.1286561-7-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 32526A0004
X-Stat-Signature: qojse8qu4zzxmce6yeizb7b1pcgkekgc
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783695732-21688
X-HE-Meta: U2FsdGVkX18B7SyawcR4gvuXOIMz+6YmLmSb/bvo3z13u5HDLUDStCUoYooWRAdL9TONOXxA6Hkwkij7xmKnhhYkxCOFFb3ocS13gi7O1JiL69c1VeozSrjpxFh5tHDEenuWxgbXONaQCLQLmNIjGRrbqrHeE19lep37FNIaViqrbT+DKYER+IDVMNKwgXwNTzoOCBeW+f3F4gjsBRHyUCyhZOaUIG6BuABquZQoVsoQbRn3MCVl8pdVfQUcqcOpZzr9OX0OoXnRc22UJURwt+p/Q7fBtpTVsl8TSD8sE0HZpLxjrSDQFA/7hiXjPTFM21pXe7js+SV6rLkpPWIoHi3aIZRmiKnqBvPCxmhpFlFQZ10PXvSsAXo26CLy2Ej3LDf1f0W9rgKyNwwy2FVHF1vaZQZsYr/BWzP9ZwNAldlZ79k6nqEwkCsuArisXXyBc1zT8QXv0Blza2u5Hpj88983Xcfi0IpXIVE6ue/exBRxqBY1hnU2WLfmhV1iPrXth7hoh2N3CF0IusobezQRoY3+U4mLJjaXzLzEU/gQjYMLdyYQ7sJvUDAf226XUOlYzdmb2Z5TGcTcHbzgWKno6XuA9TEcP/OEDkB+Pi7NVWH0ATYTL/+0LYo6mgvivGo0kiU0lqYPbjNd7RocSloTLsw8orYyFCzjQDYly9WU1NkdexXZSXULPhg7KbKrZibST6UbcycOkPBIUYrOf7EzEJGf4YNUnZRDEtaPqUK9YBpr6QX2AJpczRxke68TObNchN4mv34DcjjIWUTzijUfp5FYQ1nPvXWWs2T2QXFHTpsg/O8bw7AxMxO5GfRHAq//A0/zG+hPuehDUZleY7hvF41+7+2GQLh1nTpdtqVSSVoG40WO6JytnZNLdDX3Vt8mLkWL2P4HWKCrlW0G4CcKcHdED5M0hmg7SlX6uWGnsySFFq5GVjIcWyVY1wwPx+nSSUHbxHBG9FOM9LUO3G8
 WESnediu
 vXWF06f9lJE34VuALepVU67e6OI0u8CCXoq1qYrmww40Mgp1Z4cGkOF17B1AydhnJC2ayQ5ZXB/vEM0NnvezkjT6R7sthQ1Ve24ko8rh57AGh5AgQjV/cWmc3Ecw45aHuH6bIf10AU66ks5ddWwmOHAsjOe01P1AMc24PWsbAxXs7OFkjKVacV+S5vX0UcvGWIgQ23AeNjGZ0jkxFHzdLn6Mq8CYkAAenK0ybRTxl0tCAh/kVz1i3ETNz7EVwI6v5G8eiSWbLgMz3oCGntDKP0ap2BNpX/YnpS5mqLm8VpQFlj9mDYdMBFvJCj/Cy41qXRxRJyoQnXZ01elYozDe9N0sUhceOEL3ANefPjcJXy10oYxtT9j+OUnwTMEID25KfCjkg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:47:34 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> Most accesses to the raw_hwp_page list are protected by mf_mutex.
> However, the call to folio_clear_hugetlb_hwpoison() in mm/hugetlb.c
> does not.  This is probably OK today as this is in the freeing path and
> I think all current calls to is_raw_hwpoison_page_in_hugepage() hold a
> reference to the folio.  However, the next patch will call this function
> without holding a reference on the folio, which will expose this race.
> 
> Rename the current folio_clear_hugetlb_hwpoison() to
> __folio_clear_hugetlb_hwpoison() and wrap it with a new
> folio_clear_hugetlb_hwpoison() for the benefit of external callers.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/memory-failure.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 53063e2a1f97..353288cce1b2 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1935,7 +1935,7 @@ static unsigned long folio_free_raw_hwp(struct folio *folio, bool move_flag)
>  	return __folio_free_raw_hwp(folio, move_flag);
>  }
>  
> -void folio_clear_hugetlb_hwpoison(struct folio *folio)
> +static void __folio_clear_hugetlb_hwpoison(struct folio *folio)
>  {

Good to add lockdep_assert_held(&mf_mutex) here, but there is a issue below.

>  	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
>  		return;
> @@ -1945,6 +1945,13 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>  	folio_free_raw_hwp(folio, true);
>  }
>  
> +void folio_clear_hugetlb_hwpoison(struct folio *folio)
> +{
> +	mutex_lock(&mf_mutex);

This wrapper can now sleep, but its external caller is the hugetlb free
path.  __update_and_free_hugetlb_folio() is reached from
update_and_free_hugetlb_folio(), which has a comment saying
"Defer freeing to avoid using GFP_ATOMIC"

> +	__folio_clear_hugetlb_hwpoison(folio);
> +	mutex_unlock(&mf_mutex);
> +}
> +
>  static int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  				 bool *migratable_cleared)
>  {
> @@ -2051,7 +2058,7 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>  	folio_lock(folio);
>  
>  	if (hwpoison_filter(p)) {
> -		folio_clear_hugetlb_hwpoison(folio);
> +		__folio_clear_hugetlb_hwpoison(folio);
>  		if (migratable_cleared)
>  			folio_set_hugetlb_migratable(folio);
>  		folio_unlock(folio);
> -- 
> 2.47.3
> 
> 

