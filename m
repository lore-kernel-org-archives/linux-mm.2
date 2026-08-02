Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D1F5C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 12:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC006B007B; Sun,  2 Aug 2026 08:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D2C6B0088; Sun,  2 Aug 2026 08:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4276B008A; Sun,  2 Aug 2026 08:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E51A56B007B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 08:16:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3D8018048B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:16:24 +0000 (UTC)
X-FDA: 85056227088.24.48C0247
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5BA0320004
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:16:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m9RfD4K1;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785672982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3oeIu1NO1s3LH22n1O12mVtuttJMeqOoFdM19I5ia0=;
	b=m1dVIDFiqqnGW8Su0VNEWsNiqyq91mDTbBjtEJrvoGKGJEw6lrT2/lzl2JUobCQRhwkukI
	7JtzYDhpVJKwvnueHkT6PghjkKJFmxELmIxbOD1DlAVDWd1T/Z9cE2g46mFxHwtoWJ07TK
	SFn8vUDNAB/9JQIN0utaJllwruw+vrc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785672982;
	b=8S7uz0FTa15MSW3PPY1kQK/Q4TyoB+xrW+ya587xwGi4YoWlwaKHAbaybbo0KejXFj1StU
	s8HVnlUNJHx8mJYHFWZLB6Lr0LZsu9IqxjuDbEE4RPDdd8AlpoE8PM2kALVm0pavO0dWfR
	mWwchAx2pNio68jJexNYn1U5i1K7Eqk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=m9RfD4K1;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785672980;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3oeIu1NO1s3LH22n1O12mVtuttJMeqOoFdM19I5ia0=;
	b=m9RfD4K1o5ZHsE+3Sj33aVH5mGou/ZnrDu+jrIoNw6LfiuPjpRUWrO9vlbO8q6fHgSadH8
	xPt4D7A0BcDKrfEKpmPi0RVOMcS5nkw9ihECZXvoRJW2Vk4Fg4Z2WuWUuenlXQkLacStHQ
	wTOwDN+GA7Y7+unHikiw7354IdBKdjM=
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH RFC 05/14] mm/hugetlb: use direct assignment instead of folio_change_private()
Date: Sun,  2 Aug 2026 05:16:12 -0700
Message-ID: <20260802121613.1590412-1-usama.arif@linux.dev>
In-Reply-To: <20260731-remove-pg_private-v1-5-142c97ba3562@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5BA0320004
X-Stat-Signature: wrmxrzayeim7r9g6m8qgqwugeoixycxw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785672982-952505
X-HE-Meta: U2FsdGVkX1+BBAr3UtPiIToTAiaoMbFCHAIJPdRn+T2hTFT5C4Z+pDTHLbO7yFrZWe8QBVwPZfAmTgmr/zaNWbDlTTxpdqPLDdXk3xFwL8/BaYEJ66dnO9YyFpJHPpcWEoaoECD+ok8CJV3YNLjl+IEg/P3nS9zmdEEs3riNio+08aL/delCuVE4MDZCAkundA4kLvMTrut5Jy5WV8ung6WpWK7QXY8A7gdSxhZFC9gRkha0gKMvgdbHF3evJHSYjm6dvlBGelEZzatFTe8MYM/Zr2Em7I7MecbtHYbhArTtpL/ZsvbQ/S5yq+aRfKuQSuG7VTfLnt5AkChd9OfS6W5MebeqVohn66PtCf9+GTxuz2babKWgBeIN3oti2exZRlv7ea7iU/bmbwocQ/qf7AC2ZliDuzhVgOR+Kz227IFhkrMpVl3J5OHkwu9bSQF1+31fiaV75SNJH0iZUiYLtdsClbVPAye52XHM68qkO3sq2WXY95kK8U0Ipz3wSdwdoqS/HjJhQsZyzoql0+cPCbhBS3kiUFwlu6HJpIjU1ZNEVM9Z57Mg8X7swC9CZyJbvIRqMmq3Wo59cviDmj64IggecSKJQXI6oNmGpjYWFeK4/hzW6CKj7GJvA4sAm/8f95fK9rgIoIo5fo6TKbwiSFGi4KkkjN6JNcQ4iNZEs9J0BWOGSIaXgRJH+bYOf4BedNkJrWZNv4cMnl3k0O2p5nGIo0lNvwFOPiRh02bO9cpzYNYmTVX17IopwGtH6MvxAzjKyk+4bOhB5wIUmLo6D6MHNLk9qsSnyQLimU+uO7WJpyzigu8Qo2Ob47gMsHBYkng12Nnwy/VGahDRqaIwK8LOP0AdWFwJ0WITEVIVRJi5OmnNy8DJjmzCASMyKNluOL/R7fUC9dwTWcZwWNmGZtBdLGru2wueOhmiF0CEOK7lqlxwMKmdViahGcwe/C4gKTeBIamMG+1pzyYy3NG
 NDAQFGZF
 ecXTAmM0HUVGmUNRB9p5kwDTLye9lHCBNh5u9MBSg7ov6RKJ34Vus2mRZ9DGM3kmexLmkhY06VHjhMp3c3fmZ23iU0+rrn98BuAAoe6cRNnHPauYBR51Y0/kcEhVHNnfZmCCm6vtOUclGr8DsLchzLXKm5HbDTdFr+PW5Yg1vSKBaZMmSHLkWVuSjKDhi3mtGJ5psSQHcu1x3Db//UVUooEaWV86wvi6zmc9PO+t79jp0RaPw8dXgmjNXUMt22slScEczUxRcAF3tWowossolRMRuN0tlyYKc8VxG388szmZkrNdzIliRROHakC+aw5tux4gaW4AzAMALePdUsJ3x6pHX1iqgUtPi5UdoEvTogreJb88FOadzBqJo8XJNlMjyUAirMVRocxpFI9F4UKr/5uRcRKloApmOzOFN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 31 Jul 2026 22:13:28 -0400 Zi Yan <ziy@nvidia.com> wrote:

> folio_change_private() should be used along with folio_attach_private() and
> folio_detach_private(), where adding and remove ->private content requires
> folio refcount change. add_hugetlb_folio() simply sets folio->private to
> NULL without refcount manipulation. Change it to direct assignment to avoid
> semantic confusion.
> 
> It prepares for a future commit that remove PG_private.


> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Muchun Song <muchun.song@linux.dev>
> To: Oscar Salvador <osalvador@suse.de>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  mm/hugetlb.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a77c3c1cb8943..0abaeb47890cb 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1433,10 +1433,10 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
>  	}
>  
>  	__folio_set_hugetlb(folio);
> -	folio_change_private(folio, NULL);
> +	folio->private = NULL;
>  	/*
> -	 * We have to set hugetlb_vmemmap_optimized again as above
> -	 * folio_change_private(folio, NULL) cleared it.
> +	 * We have to set hugetlb_vmemmap_optimized again as hugetlb page flags
> +	 * are all cleared above.
>  	 */

The return value of folio_change_private() is never checked so LGTM.

In the comment, saying "above" is not very clear. How about something like:

        /*
         * The hugetlb flags live in folio->private, so the assignment
         * above cleared them all; restore hugetlb_vmemmap_optimized.
         */

With the comment clearer, feel free to add

Acked-by: Usama Arif <usama.arif@linux.dev>


>  	folio_set_hugetlb_vmemmap_optimized(folio);
>  
> 
> -- 
> 2.53.0
> 
> 

