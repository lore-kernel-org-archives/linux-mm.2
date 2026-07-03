Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81BF3C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 03:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17CF66B014C; Thu,  2 Jul 2026 23:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1559F6B014D; Thu,  2 Jul 2026 23:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0920A6B014F; Thu,  2 Jul 2026 23:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE5C96B014C
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 23:09:56 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 387371C718C
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:09:56 +0000 (UTC)
X-FDA: 84945985992.24.AA4DC96
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7ADE140004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 03:09:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GvZ8vFTm;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783048194;
	b=U39CQoHi1yU/jQOd39ZMDD4WdxpZZz676uErTBhfQX+k+f5GUTmgKHHdOGmOzHvmT6Ey+Y
	ELbu50hT58EMo+1FtKUXojMsf92ep8/26tVIyQ/8B1iqyoTeOFjwmByUdfbuKWjuqjHJsD
	hbaQX1QsaLk3HQXki/ofSTFI5KOL+iY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783048194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7uolXzW07Pm2e3aGYT6OhAKNBbvwp/mtfuLmB1Lsck=;
	b=aUHbg/Z8h+Z6ZxqHL8Lo+wEXZhyrZwBTzRaExclmFQBelTp3H9Sbu4SuEOOxuATFpf6fhf
	P7Lq+BYthxaEXMjbsWsPtAg+75OtRKFl2GBYX2BVyaO9X/66xWRLnoY2D6hQpE5/FIuy8N
	4VqMwq8mYqHf/TOT8vo60gf5yB3Gygo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GvZ8vFTm;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783048189; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=U7uolXzW07Pm2e3aGYT6OhAKNBbvwp/mtfuLmB1Lsck=;
	b=GvZ8vFTm3g7xX0nPOUomm8Ct6G3rRThtwddgHakTzShKn6G9g0G7ginZ9GgILKr4AKkfbBJ0LNwWbHcCN04JBLlAHrTieS2CTBY88OANKF193EcfKyKyDVZ/mzquy3xfiynlOJT139P+TFx+TyU/DZ2F/wsWmnf7Xg8Nw1u5ohk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X6HYWUr_1783048187;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6HYWUr_1783048187 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 03 Jul 2026 11:09:47 +0800
Message-ID: <4c67ac7b-e021-4e4c-ae5c-07bfc0fba9c6@linux.alibaba.com>
Date: Fri, 3 Jul 2026 11:09:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/migrate: exclude hugetlb folios from
 MTHP_STAT_NR_ANON accounting
To: Nico Pache <npache@redhat.com>, Barry Song <baohua@kernel.org>,
 David Hildenbrand <david@kernel.org>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: ljs@kernel.org, willy@infradead.org, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20260702172548.37075-1-npache@redhat.com>
 <20260702172548.37075-3-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260702172548.37075-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: 1e68jbxem3s1z91its3xywc89jrxacyf
X-Rspamd-Queue-Id: B7ADE140004
X-HE-Tag: 1783048192-97891
X-HE-Meta: U2FsdGVkX19TdfhKaFyysEoiKM/KKz2srQLFkESOPV/MC6D5l6KiRLacTxyez2BwMmlSZcJB8zJd+yq/XQXeXkxHzEVGeNyq4pA7kvMNXvZU/4O41i0Wpf9R8o5pu60G8O9+EWB7RMgE9bKiamhAxEzfd3nSv/H5dA1yt9nJ/OV5btdaHiG1ciDNK6s84uOu1+yCDyMOTCh/IoeYfu57KG6pChiaJrCs4s/ID1saKD1yl97OMeXAp5ZRtcLzMZszFZai6qGFH0hNYyD2v8RweCk1Kv+sIkE9RaQGKBZmvBsIoFfxCwQ3gwsvPqIY45cf6wIWj9uxnqJt/ITQUo1YAbnuFv9rhIgIxYRQiwf6y93QnAQPytaKtFzLslJjsifBtT/4U/zH8MJdeUBQLYIMkFT39oPOTkOMb4DyQN3WrHmg5h6Zx+UEIgOhc1iQGiGwacgnnMfCn3oEyUPTtw/M3BfA550/WhXZsxCDkfH8wIibo8YW7KmQ3w66V9l8YprPw3iLWL2bEyhWHglyDVhOa5vJxGUDOp+HrXldXhTWha97hb/RWuqfmh7dzEoxK1+5uVxzVQltNcEyho2me+KOBVFEB4zB+EssIswaVyaXZ/EF6ALuQzMuYBPqRNcj2hh9ao5hmDtPQgGnPNyxzyzMlLtua9wMpyDFOYquJPwNHaHuXAwiJ+QxVff8bmoprux1O+6Y+dZBtTNcjnwhX2el1IIUN5tVTAGF3oWPLT19aHCUuWKg8djzgXfnWdYppBA2X86O7/ALNkHC4r2uQsIbNVdLLHu3cF/YNudyJsVSFMrT8LNxTZ7tjjygb6vjsWAw5YPRSZT6MQZVgH1r4NaXZ8PRiaiKkooReYzDZV/+aPkF5idlPaipDlQOBHYL4kntLVL8eHLORHfvol4XHHT3mBE7oJ4K0thbJ+PHOOOy15BElDMrRLsCgJOVQjuhdaotgUc5TCk7JaC8XtH4i2t
 AJN1eRU/
 ehxhJ10r4ZeNT4QmMHZka2U1WVwAtB6zGyu5MCHQVuXjtcnkKCW1OPExT4ur256pE3kAzHH+sFNrmH6fxz11Vt8btdwPWt9gb9rn4pQ899rwlLl+OBEHxouFr1lSraW96A3CueNpL4PjgU0mm6wzK8RokAV6WssPIwWHyXRXog6etR7AipnFN+l6RHUbd9QCtOgwRc+xpTVn4wBOneXyIH1/lbH73xE5Noo+p4sQYWeWNmzv10ZCKArSh/B4mv5MQnSn1HsCVaVHhg+PRjjeYUiovg1ZmHb9raO1RvL7MwCSfa41VdMjphQ/bbDpKWZMrvw/AimOOESVrKI0cZsgXiZIEAPD8Vt+m15h+dUd8f08yG5gQ1U5GkHjl2vr/CtC5UfMd2+N3OeD0r6xNjblaC5US7PkZ53gSp3easGrBZFvPt8ggqOMhQrygnzNia9E6DsV2//pusPYkWRIr92MEJTKY4jth1d5cEZhLVHXP88PZAA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/3/26 1:25 AM, Nico Pache wrote:
> __folio_migrate_mapping() increments MTHP_STAT_NR_ANON for the
> destination folio when `folio_test_anon(folio) && folio_test_large(folio)`
> is true. However, hugetlb folios satisfy both conditions despite having a
> completely separate accounting system; they use hugetlb_add_anon_rmap()
> which does not touch mTHP stats, and their free path also bypasses the
> mTHP decrement in __free_pages_prepare().
> 
> This causes MTHP_STAT_NR_ANON to be incremented on each hugetlb
> migration without a corresponding decrement, permanently inflating the
> nr_anon counter.
> 
> Add a !folio_test_hugetlb() check to both places in
> __folio_migrate_mapping() so that only actual mTHP folios are counted.
> 
> Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
> Co-developed-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>   mm/migrate.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index d9b23909d716..9fd50ea25d2d 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>   		/* No turning back from here */
>   		newfolio->index = folio->index;
>   		newfolio->mapping = folio->mapping;
> -		if (folio_test_anon(folio) && folio_test_large(folio))
> +		if (folio_test_anon(folio) && folio_test_large(folio) &&
> +		    !folio_test_hugetlb(folio))
>   			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);

Yes, anonymous hugetlb mappings can reach here, so this check looks 
reasonable to me.

>   		if (folio_test_swapbacked(folio))
>   			__folio_set_swapbacked(newfolio);
> @@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struct address_space *mapping,
>   	 */
>   	newfolio->index = folio->index;
>   	newfolio->mapping = folio->mapping;
> -	if (folio_test_anon(folio) && folio_test_large(folio))
> +	if (folio_test_anon(folio) && folio_test_large(folio) &&
> +	    !folio_test_hugetlb(folio))

If the hugetlb folio has a non-NULL mapping (i.e., it's a shared 
mapping), we should migrate it via 
hugetlbfs_migrate_folio()->migrate_huge_page_move_mapping(). In other 
words, shared hugetlb mappings should not reach this path, so this 
hugetlb check can be dropped. Or am I missing something?

>   		mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
>   	folio_ref_add(newfolio, nr); /* add cache reference */
>   	if (folio_test_swapbacked(folio))


