Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73262CAC58F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 17:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFF5E8E0005; Thu, 11 Sep 2025 13:27:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD7358E0002; Thu, 11 Sep 2025 13:27:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECAC8E0005; Thu, 11 Sep 2025 13:27:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AED5B8E0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 13:27:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A6CF1DF1D6
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:27:16 +0000 (UTC)
X-FDA: 83877650472.25.644D661
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C087C000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:27:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gvOpePS1;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757611634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tMGmauowOA3MWUf9b16h+wPyqJYbgETKhnspmu2nELg=;
	b=eqeqxJeNwE/T8Q7p/WO7TO5Vkx2WbhBi7Y9QiDmfjIi3anV2MoCIMRLD9+2Rc76OMcySZH
	8YUAfHgecwO3Ya13nz8Agem+TkzVbSrkJ5nidnER03Ee8ydVRWUjiHOyvyurU9k0Ngr8BN
	JLhdvrGzAAX1HcaV8u0Syp4SJcU+1FM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757611634; a=rsa-sha256;
	cv=none;
	b=afXIGoWzPSfLg5RhYJvZsdWaNxkUFQS34hzXzw5pL9oMLgJtxW7oqE6z4WGDFwx8dUpNNx
	rMq28TJdNfgu2biJBkXTBNfhM2M5bkeXXDQRQ5Rj1N3kTr+AsMSbNrTXJga9z1s+fXZ1IN
	bgqsXv0yGQ9ebHRjRYRqn3o/H9yDiK4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gvOpePS1;
	spf=pass (imf28.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-772301f8a4cso1349499b3a.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757611633; x=1758216433; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tMGmauowOA3MWUf9b16h+wPyqJYbgETKhnspmu2nELg=;
        b=gvOpePS1dRgp+Yj/AusxXnFb8dbbr0nCNjSpOnvPySm3Z61GKY+a+n+cLaqTdzTlpV
         DvO4Q0IVmxl5bkBQhPHK/OvF4doYCI7gHZhrDbTlpPjfyCgyLBrNrgtXPWSur8/Gw76T
         cuMdUMZGc5US27Q+jk78WJCcr7jJyrx/8LHNHjOV2zczjPrB7cFkXN/s+/5GXWLlfNfA
         qPIJoAt6V5WxxfJwNbv3ouPP/pM2Qextai0rgTKwCF3BhZ1PlhOROs9kB0oII1fmbKBQ
         QSnSqZe7L8SOgEqBk7QZ7lOeQKvgqzJs6S0B6sPQ2yykzqhVdD/cdaigF63GKbr5qVFH
         HfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757611633; x=1758216433;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tMGmauowOA3MWUf9b16h+wPyqJYbgETKhnspmu2nELg=;
        b=Tc1sIdUFnOuBvYLZMSXeDbwvPPOXkoKxsGxqLx/VxyEyvoyQoSfp63N64Uldu0gavB
         aoagRFG/crXm6jt/ncHOBy4a8FMghnU2UhVX/5WBc3cDjquU2qyY0+sFw72W9Rn5/uoJ
         HOeA1KCRlIhLwlfOrKAXUGI4Ayx2TBOMPl2bND90FouIruIKaWgYrWyph71PcuHgJwKm
         wd6+FIGQkicfLClexGRp5DfiFoI+CvqVwK0Pe9dsmKahnjOQ1dHAzE2KF9ZuZvnE92PZ
         f1QSgQEtIvwvtljoz9zBwGclekNk2XZtT4bEXwPsJr+aQRcv4EVcpxUJ8xhGrgyVEphj
         WUJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqrh4FEj/tYggxsRX9Paai5lCHqFW8uSasT8+YN5SYGH1jm7lH2swFqQ3wESOvEzDZ4gG5sJT4Sw==@kvack.org
X-Gm-Message-State: AOJu0Yz4i6oqGRZ0nm7YY7O3CULEc9og4WuNWquEtOoLuakhn/6BxJhC
	w1fxpI4l0ia3H76M6VxbV4u8iGeMkbLTqpO5fMsdUO/j665BeTG66a2w
X-Gm-Gg: ASbGnctyFR7kkRcH3zXvecUXgh56SLHNmJGOK8vkuww+TfJAtAFs0Vzo9n32Q/H1gf6
	wgmtN3Z4CJcbQurduUbXJflVarB/eQTn4jfBIhGho0q0ojPjODFMpyztfsBWGnFVCuhcw2Fa1xG
	64vuW0eM2xJQz6yRtPRNWRyCrI1mISXfkEc6OLjo+nxwWLg61OmRJaPey8mveKFzljPuOPRgbcb
	fy7cyHoVyjfPEqTDaGjl1S6PFJw200An27H9H+vtbe+TGYynMTlhW5ct7VJTNxLy2HvF4QCK5DZ
	v6Y34i0oNJm5WAsB1E/LOJWtU0okHIlFCR8dPzjUTWXHwzl4v17WmRxt7QvTqoSwMEFdGXxXtV3
	zrh0bvBpix+GzSvwpSVMTVmSq42bigKhn+IehHOI20psi6NgfGKxAkUO6c8nbCik5
X-Google-Smtp-Source: AGHT+IGF2tUvE/Gq5hN9WOCXP/WB7bjb8fSeA/cZ01WaYcNsfLBQ8xYvy+0cJUjDAeb/UBmI19oJMg==
X-Received: by 2002:a05:6a21:6d9c:b0:243:ca71:d972 with SMTP id adf61e73a8af0-2602bb5937fmr137553637.30.1757611633234;
        Thu, 11 Sep 2025 10:27:13 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a3aa1a22sm2323679a12.52.2025.09.11.10.27.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 10:27:12 -0700 (PDT)
Date: Thu, 11 Sep 2025 10:27:08 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, wangkefeng.wang@huawei.com,
	linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <aMMGbPX9uUj7TfoG@fedora>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
 <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7C087C000D
X-Stat-Signature: zpyodjksi3t76edz55upq9smd1i66d84
X-Rspam-User: 
X-HE-Tag: 1757611634-828970
X-HE-Meta: U2FsdGVkX1957TVM6hRD+g0ZtH6EVipXW4+AeQNAg0nphV97G+6knveHNUKMEZOGsmP2W+xsVoFxnAzX/JUdlKdLbdEWEuPtfKkKn5O8gTwmVIAHfWiCdFfGQB3T+e+OssqWkVs0/qKgU1EMFHSg7xLRDgNwYIzDQNmja2MZwaoSO89gZNp49FGzK4oqGjuvfM7I7WiEmY+y5s8vZDo25Yp7bsL2p5ZgBsRwd9YNUrJ8XL0xuiR9BwJ6DR2mPSLF4uj7gXB/ZyZrNXl/EbpG3ZOc9KnVDlDkLobRhxDg3WxMmWGlaV6TtLjQ/TN1J2OpbHY26k6RQNbzW7PWdSWcZpCG+88bwZo4QT1isYJQDbYn07HeYjWgekO6+XV2NYuusRlG/07TfBh8AzBeFd8QB80z82pc0b1XXFDU2d2KbuBsG6Tf5wQKAX2ac/Uq0xgnUeL2cf061U1rHbsbc1OEK9g8PfIC95ivoKBF3PTyZv1FLHKxBRGutFKZxCMKweSgNvDcVfCugq8b9Xp9ER9+DiW/xBFu71/5McQtJxyV9kYdfwAUMqVTJaLVOlRVO9yG1m//Uw0ivthvCVmuycbg5N9nd4ob5Wz+ylt3Bk8ygij3LGpjqVhABMMOlYTBrugdyhw3VVCyh2p9QpBGS2t6L52NNHfW9nPLaSFN4zrcpgDYVt5K4hC56gMmSeE1aVihQpzjOKwry753VwTtkIeg6vTpW6Itw25u9QOtwdfG9pGnIjXtDR7ITWf8f0wJl/Fl2iwUe99k04Wx3DfxmPRv12UgsAQkaRXGH6Wi+jOpibvevl4hysqe8wsvaig3jt+E2HoquyXwz3IEZgljTLREUgiGhre4W09oahPR/So9EIHIpyOp+bhKrD8yRQsxat5/fXtpd2nEnbecAYf40UZHQ4HhXAzT2sEEE8gfqHMCvmTcrLefR48vXe1XIleDED6NT24MUhHxRbJ7XbqBekh
 3Dtu24C+
 XE6SiqyLOG9eE0QCphgNuIsQWzCPtipoZY4tu+KMZ3h64/zhQV9jotS7j2jWr4g4rIiGF3FT5kzxVz5pAvXt9hJiCj3VtQ948AA5HbvX6U8VmsOQHZBGTr0JxX1FqwBxhN1bSGgL0WXeVyBxz3xxy1w5mYuDD7csZsOTKFiYHl496+hs0psnP2n9Hxjcg3uu64+Fhb2J2B9hTLK69NLvpaQ5W+G8WEs9CQOU5R/TUCZJYQE0Qoof1a0wcYGrUpn4knM3FY427IdPjSHaHitXiZOGPHGFXbuBn88lZzdjCCr1h6DnPU6h4s1D8Q0Z3ZPtQ3TMtS3mw1cSkOzxQl3dQUj6tMbCAd5oB4rkMyhCeu/ku3R4D/XzluxRpK70KTmWdMZesswwOltXhsC05h6lHtrx328Bvc1/6QY3zVDRIxaTbK9lO5G8m361Xf30eQlszSOs6fn3UEujm3cJQWJgTiyjxbYNwo6jZM2W3GRRuwdZvT26+X21vT4N10Mw1QQYlVpZVSOLyFH1e4V+WSZTKVEJZNwiQvLMOo7Zq53tVTWo6pfy+I/ImTmhz+UW5oT7y2zTyfhhVVZkJKqmp+M2IWAB5ew88jyxP6/KrbRxyhjU3rG0REPQuygrJzP5e7BV1aLsOO4Azd9bYsGE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 12:19:34PM -0400, Zi Yan wrote:
> On 10 Sep 2025, at 23:27, Wei Yang wrote:
> 
> > On Wed, Sep 10, 2025 at 09:35:53PM -0400, Zi Yan wrote:
> >> On 10 Sep 2025, at 21:25, Wei Yang wrote:
> >>
> >>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
> >>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
> >>>> isolate_migratepages_block()") converts api from page to folio. But the
> >>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
> >>>> to head page.
> >>>>
> >>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
> >>>> which means low_pfn only advance one in next iteration. After the
> >>>> change, low_pfn would advance more than the hugetlb range, since
> >>>> folio_nr_pages() always return total number of the large page. This
> >>>> results in skipping some range to isolate and then to migrate.
> >>>>
> >>>> The worst case for alloc_contig is it does all the isolation and
> >>>> migration, but finally find some range is still not isolated. And then
> >>>> undo all the work and try a new range.
> >>>>
> >>>> Advance low_pfn to the end of hugetlb.
> >>>>
> >>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
> >>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> >>>> Cc: Oscar Salvador <osalvador@suse.de>
> >>>
> >>> Forgot to cc stable.
> >>>
> >>> Cc: <stable@vger.kernel.org>
> >>
> >> Is there any bug report to justify the backport? Since it is more likely
> >> to be a performance issue instead of a correctness issue.
> >>
> >
> > OK, I thought cc-stable is paired with fixes tag.
> >
> > If not, please drop it.
> >
> >>>
> >>>> ---
> >>>> mm/compaction.c | 2 +-
> >>>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>
> >>>> diff --git a/mm/compaction.c b/mm/compaction.c
> >>>> index bf021b31c7ec..1e8f8eca318c 100644
> >>>> --- a/mm/compaction.c
> >>>> +++ b/mm/compaction.c
> >>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
> >>>> 				 * Hugepage was successfully isolated and placed
> >>>> 				 * on the cc->migratepages list.
> >>>> 				 */
> >>>> -				low_pfn += folio_nr_pages(folio) - 1;
> >>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
> >>>
> >>> One question is why we advance compound_nr() in original version.
> >>>
> >>> Yes, there are several places advancing compound_nr(), but it seems to iterate
> >>> on the same large page and do the same thing and advance 1 again.
> >>>
> >>> Not sure which part story I missed.
> >>
> >> isolate_migratepages_block() starts from the beginning of a pageblock.
> >> How likely the code hit in the middle of a hugetlb?
> >>
> >
> > OK, this is a kind of optimization based on the knowledge it is not likely to
> > be a tail page?
> 
> No, it might be that most of the time page is the head, or people assume so.

For compound pages, we will always have tail pfn < head pfn, so we should
always find the head page first.

If you did find a case where we somehow encounter a tail page here, I'd
love to see it. And then you'd also want to make sure the other compaction
trackers are appropriately accounted for.

