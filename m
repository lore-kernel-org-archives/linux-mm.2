Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DAC9C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 22:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C50B6B008C; Wed,  9 Sep 2026 18:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576046B0092; Wed,  9 Sep 2026 18:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43DD56B0093; Wed,  9 Sep 2026 18:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0C86B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 18:55:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 895AD140357
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:55:04 +0000 (UTC)
X-FDA: 85195730928.21.9B25C64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A103D160006
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:55:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aMaZpOvm;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788994502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJKtsP/R+XzqNSFd2tRI6ryvg6jMdWPMorma0LHyLvM=;
	b=OzzU496faPZAPyEdEljf9H38srZSYFJhEOv+WHbgBvnae/wG9CpMAOMOES4QqImzD/xTF5
	4Sb7cywSL8xdBQY6lka2hVzHTS9Is79niiamzZ6OPTTqm7rsy5/Lm9JNE3hdEcXGWjkDgK
	woawAnZzsESZrIdH66jH/2H8FHUWF3k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=aMaZpOvm;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788994502;
	b=HvpTOMuboPcTIIHTPfoVqCDaL0ei39VrSVf6X+AUgQ0pzAZxruXpoOzSRujaQ73Zzl4byC
	s0jAEpKe8H+1RydjQevLKcWiXREu3K0d1rvaUIKd0hNQwzxI1uiWIRNDBkZvgeIzevkZY2
	aDvsABCAc3qTgjGC3UwnB8l9EQr8zkU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FE2640501;
	Wed,  9 Sep 2026 22:55:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E50C1F000FF;
	Wed,  9 Sep 2026 22:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788994501;
	bh=JJKtsP/R+XzqNSFd2tRI6ryvg6jMdWPMorma0LHyLvM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=aMaZpOvm+QJmid1g9VQpesLwijn9I+3Mz/AtivHJ8/EHdkXOoJaPDgBMaemYqcPFD
	 3JLeqfZWFYUMNaXd92PhUa/bNluE7+9cvlizDnghCFWi6xP6ZeCehyZhYtlUHtGxFw
	 wD1v3gA0Q4uFK8IV9pVCtqjgW3ATTmG6frpHUzfk=
Date: Wed, 9 Sep 2026 15:54:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ackerleytng@google.com
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
 Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>,
 Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham
 <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Shuah
 Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>,
 fvdl@google.com, jthoughton@google.com, rientjes@google.com,
 vannapurve@google.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Zhao Li <enderaoelyther@gmail.com>
Subject: Re: [PATCH v2 3/4] mm: hugetlb: Fix subpool usage leak on
 allocation failure
Message-Id: <20260909155459.dbf9d67ae21a72935bb863d9@linux-foundation.org>
In-Reply-To: <20260909-hugetlb-subpool-always-track-used-v2-3-30c5d83b572a@google.com>
References: <20260909-hugetlb-subpool-always-track-used-v2-0-30c5d83b572a@google.com>
	<20260909-hugetlb-subpool-always-track-used-v2-3-30c5d83b572a@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A103D160006
X-Stat-Signature: ssy7y8hquh5de3npc79s3ejxdik4dywj
X-Rspam-User: 
X-HE-Tag: 1788994502-208399
X-HE-Meta: U2FsdGVkX19DcKp47Laabg9ceXJKU0NpgMQ9rLP4QsWJRl93Oma3uvoChtJciRg4ARcQy7Olvr69CTo+XfA+t+MKIbelcbv9ZyPCSdIdtrdvL5L28YY/sMO2ptmAhkjjidkCc1FMVHXxnFP7pL4cbvAUKdu85AkcHzsmr0wkHagjMDErTZEzbuU8ttRSbveVEtv2OJwoNx+hys++cszIQcG69DHaAofvaJiIp/VYpKysDZPFIr6N2e+slHF4vBmwxpfACg7/URb0npbxFmoaNuYMVSJo54QLfBrjAhMF+rINwp7QKZ7QqmkGEqIf+EqSb1GVrUmZYAAQ4lEjYgGNLOaW3LLVYonWxzYCNnFRY6/dOCqC+1iHrRYYFDBTW0RXOTU5j9wy8e6XG4Bzalg99Powk5u2KuE9D76/sTmUlQiiy1mACmN3uvzNf6+qw4cCiwotYdoCukRekAHhPB5xxwIORdb9HRziCKhKZY6eTw6qHcgelmVmTAfoHf/h6bJlPMP7gB1QkD+4qPzq6JStNmvx1cSoMXrHtB6zfTSXQFyR2kdf+Xo4P7onEPtE2ISK7KwrnO6iK7Liu6b6vgszA4/q3yi5leNFxALlFMbUlPDSfaodDWHRz6J1Q4nd4MWND43HjAayIGzHZFjDBZwyT7j/yWN28u/0/e+En3RMEQOJUNSeD8EBS+uEFqCU/Fbbo4Gqjctu4IyWUnD2TzmZXB6bfuDwGU/eX0qQVirqvMnLDH+lInGpLLnfBjaTxCT50DgIqFUoNwma79KhpE/QwC+uOuNLTMQU/Y7glDZcrPeGxbNj6I/3ZUd08MryPZny6pLu8lDHo2fbVlmyM0lb67WvNrIDXWs5QUbaGGnAP2XrGkEj201LuieobzZP5Gt0MlEJu0df6M+xbdmLdO3vVAhSRzx4VHl6ep1CcsoYAwMQaKWrXPkV/0A/I6wHH5tIW1tqc67t1164CMXuKd5
 qCjOz60e
 KFLErtSy9DqINt55Hr1Dz2+5ZgncAQ9kycDWb1x8OHJpijDnUEVELK7Pwazn4gpuAbjCAxYkOivY6YcGXG6gJZTYicfsN6l5+tpQJi/QTX+P6SwdOU0v+4QY+hQeN4yMS/XCdmn1r0ANgo8+xWfVTo/ybAgVudOmCx8F/R0fRFLnF5LrarCEA8MP7AglFKNOJCkm70Xyr16Cbtcrm4xyn+48qxeDXES28VW9vFtiRgtTUTSi5b7e9+P3InGIE+aNe03nHsMlXq4Rrq9C19TkAzSzvylQhtcddq56BKevtTzWA5M99fMC35G9/p/ccr9ftuZe+V2LzOg9qdRMPwB4Kx8U3iS3TMEa4RVEviojTbondBM5vQ/I3nWdoipXF4VCxxM3SfFY6pkf7nHG5NSjm2iOzfbj1frdsCayn5RmLn/j0bOn++z2bbax7NJMylIvxPZPIAlOly/5iRM4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 09 Sep 2026 14:49:28 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> From: Ackerley Tng <ackerleytng@google.com>
> 
> When folio allocation fails early (e.g. buddy allocation failure or
> cgroup charging failure) and a reservation was not used (meaning an
> unreserved global page was needed), the subpool page acquired during the
> allocation attempt must still be returned.
> 
> Currently, the subpool cleanup error path only returns the page to the
> subpool if a reservation was used. If no reservation was used, it skips
> releasing the page back to the subpool, permanently leaking the subpool's
> used pages counter.
> 
> With subpools now always tracking used pages, always release the page
> back to the subpool whenever a subpool page was acquired.
> 
> Opportunistically rename the local variables tracking global reservations
> needed and global reservations returned. This clarifies the accounting:
> a value of zero for needed global reservations indicates an existing
> reservation satisfies the allocation, while a non-zero value indicates
> new global pages are required.
> 
> Adjust global reservations using the difference between reservations
> needed and reservations returned to properly handle races where concurrent
> threads interact with the same subpool.

This one conflicts with "mm/hugetlb: fix max-only subpool accounting on
alloc_hugetlb_folio failure". 
https://lore.kernel.org/20260428113037.88766-2-enderaoelyther@gmail.com.


> @@ -3074,13 +3074,10 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
>  	return folio;
>  
>  out_subpool_put:
> -	/*
> -	 * put page to subpool iff the quota of subpool's rsv_hpages is used
> -	 * during hugepage_subpool_get_pages.
> -	 */
> -	if (map_chg && !gbl_chg) {
> -		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
> -		hugetlb_acct_memory(h, -gbl_reserve);
> +	if (map_chg) {
> +		long gbl_resv_put = hugepage_subpool_put_pages(spool, 1);
> +
> +		hugetlb_acct_memory(h, gbl_resv_get - gbl_resv_put);
>  	}
>  
>  out_end_reservation:

Here.

I presently have Zhao Li's patch staged in mm.git's
mm-hotfixes-unstable branch, awaiting review.

What to do?

