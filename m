Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F60CCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 17:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A758E000E; Fri, 12 Sep 2025 13:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411E68E000D; Fri, 12 Sep 2025 13:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EC28E000E; Fri, 12 Sep 2025 13:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 212C28E000D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 13:22:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0478D5B8D7
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:22:08 +0000 (UTC)
X-FDA: 83881266378.17.5660654
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id 261F380005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:22:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mOjVvRyg;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757697727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7/Ce2uFEGoYy9ONGvcPniZfSJV0om/oSbVx5ZmlOg9Q=;
	b=Mvu7PN5evX2eyWLi4YcazdSOf1tE/j0ith17S/eJX/jVaD2mBIOBBP2hzioQ2qsnqk7dgE
	tiCzeXKQfxIHhdyq98hKMPNeuaw5h8t/xM1+9rpHKvMLNNKiQca6ynTC2yjPCpwi8Lr5+A
	nVcli3DLd8ssjggzVz10yhKNWNWwTmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757697727; a=rsa-sha256;
	cv=none;
	b=mpHhkykFOWrFEYhTyO4Pczn3TLZ84Y2bFkXm5DuicC3t+/0f8u182mAZCOHqlrZCGTIwOc
	OOgicRakwba5lyvmS/GHTSOMjAPpfd+xwbp74HvL4kcE7UBgoC6d5weuHT3XX/WKM3y5HL
	oscAcfRs7wc5WrTIudC6t0xOEbVUfcc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mOjVvRyg;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-25d44908648so13907925ad.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757697726; x=1758302526; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7/Ce2uFEGoYy9ONGvcPniZfSJV0om/oSbVx5ZmlOg9Q=;
        b=mOjVvRygxrKx2eJwTLD8u1ANaxVYPAUhdc3Od/3n9QK5zagU0GSDTOwXyRMIQteVIe
         W//RuD01JV1a3nxt4h3SglDLI7xCqind889gCurEah0Nz9e36LaEDnHJ3hNnbUlxjjjp
         4aSFg83IFUubLYpzVc6JT1pIKY2vtRL2Y1uikQ6M2ACgc0dvh384BlH6biQnEapaXRR3
         1NYRgnrQ/YunHXtpQ741iZ8fBRnjcUNrWv0C7qc3wBgUmPjJLi0k9G3zRVekadicgRzJ
         Fb8kUwPrJOucSfwUbXAxR9sCEOS08SiIJrmTTa/yPEtcGamXSWMkrBSjk7x6aKlsMvIc
         Osag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757697726; x=1758302526;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7/Ce2uFEGoYy9ONGvcPniZfSJV0om/oSbVx5ZmlOg9Q=;
        b=WaiENrvy8VEXWO4HCdf2SsG8Hy6wiFoWxd5djngSvFsufeLacLNPmv+xqcGScVw4Fs
         GnvqtAtWecSQhYFkPFcBJC8dh9QlfA84/deMfu9wxnmnPt1xo3yHw6DNMLTgu9uHkleg
         OC5fsW+izcV1zQwpUWueM7WYvoRXTXzbJlTDG/b6b7kUumKCClFNNfY7ar7G4a8jDsAB
         dRZM9gxSCJVl5Ouz02JfYiCIB4gG5pfKTXQz1UU2Iy/PW6KHe3ap2TneVFP7Rv5yT/NY
         KhPo51aVBuAiMS9h45MdKj6rSPPfezHs3qg1jJJpR1WRaj0nep6LBpyPJTyzVTVUuf11
         Z5tA==
X-Forwarded-Encrypted: i=1; AJvYcCXp00WYp+kaTPMNw1Fnn1Dt0YdO+jJ/2Wnqq77rUgaUGuZfkOZ02Tggrll4iWnKaq3P8kORXBmL9g==@kvack.org
X-Gm-Message-State: AOJu0YwqgCbLecdVCjJWagQ2bfE6yrYlyrOOkHBuQYXnoY5VrwuHG0CX
	C5+oSyClPORumJ5+nHf9/3WeXP31IdOtrJd8ZKxAD3GN/Tgq+6Wsknew
X-Gm-Gg: ASbGnctFM+M7b52u6WMQucTOS9kSz+t13WYz/vomZnm6VF7Bpdov5Ug8pMHmbG1KJAU
	OOElUQkCgqcgS1JwRabHcIWuQB68LujtW30A4YLdDzRes7X04uZV8Z0zSTpT0zGdCjNlbNIhTDo
	okqGiS/uBP/oEnrnaGaXfqtXFodBEIweMoCn71MWPN6dPiaGUyHdmJr4uOn/QgQOdiJLY0Nf+IT
	kMCmyPvelab5s/cR9nkGHqm55EUhr3CcPCDXDbRTJQ9l/xVkSrKT1A0UMpaHPesyDxQKTDk3ZSu
	aJ88EJV9OClHO3Hg2eJSTfuIk3YGshOm40C30sWu1oIjeLJwysZqltuZclUNmoBu6svN99OAe8o
	i+xopzE4UIKxmD8qjCx9ZDxDeff8FeRSqu4fhaZcT9fNpkDb3/8AASUMHGHZma/4xox3s5/0B7k
	E=
X-Google-Smtp-Source: AGHT+IHVV8Oq30NVewYiHqlKi7iGlJkcPwO+JQbcpr9qwgbiK6Id2zZYBxd9vUZB6T9tg/Dm5oddNQ==
X-Received: by 2002:a17:903:230c:b0:24c:ea17:e322 with SMTP id d9443c01a7336-25d244e6be4mr45981845ad.3.1757697725249;
        Fri, 12 Sep 2025 10:22:05 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-25c37295f9dsm54426275ad.55.2025.09.12.10.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 10:22:04 -0700 (PDT)
Date: Fri, 12 Sep 2025 10:22:01 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, wangkefeng.wang@huawei.com,
	linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <aMRWuS-Ore7jgna3@fedora>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
 <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
 <aMMGbPX9uUj7TfoG@fedora>
 <20250912010721.zd67xbfdava2u26e@master>
 <ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ED7450E4-51F9-4749-A74E-C3AE8927E577@nvidia.com>
X-Stat-Signature: zy9p4t8nb5xu3u816j5q6xq7athi3h8h
X-Rspamd-Queue-Id: 261F380005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757697726-184602
X-HE-Meta: U2FsdGVkX18/vz96UrTM1tlkBkX/XfUi4Bgq7Jh+vXq7/ggcji2k4meZMfMh6L2iYSImDOJ5Cueiff1Vqm9F1yQpGcl84XfY2E2+6efoX6FJTjsK+QvPui/KV4R23uC4VkBG4hb2xkVHSEsYmKyN3GjhCP7rSbCHtmqhOjj+6ghNmf/AaFNgv9lvSPREVkscXJR8YUOfhMLQncAQszxW7VJVyS044bN+s6dteQDBXSxB1+YxuLHrHTKSJwTkEkT9QIhe5cl84ZRgmi0TRFl112SSLtGsnXQyz6SKp3F6r+NiEvvvjNnvfhi/R1LEA58s373VAxCWv5k4Wjls3fT1VaHHLNUl2j9pzcbPHM14dgvbzdNuapWS1e4/L7FCBi8oNG/4SqrrAYe4zYif71skehpOZfw87usvTN7C0UT0WqsoA1YqtAcwfQrq39Jkgz87G/alojhX+3XHEO9AUxW6bgPlkiug1ZHMeuvIq7RmuOmd5jo4F46Uix1p8BABkJUC7hUJtEe1glwg4801nNuKFjRvyl39efSppJ50Z4cpUMhQ+cvPrgYSAA/jKrNCdsHaP7XPhiSgYL7L+Ow1hE+pWdUn+yBuQlgwbd6JFkiHOmDR1nk9WUyCJXbcsXXFa/rOut9CnbTjrEl5k4kI8gvYkfyUm7qlXtskHfLIUfCWQdh7tbmrQCf1TvzUUFLpcIvflq+c3ncut5V9SlVCkIoVblgryA4lWsqrD9m9YsDkLUWBf5/R9ZQ27CE0hRxjy4+3aT+SQ6N2RYhHO5TZ0MeuAsmADaEGnWZUFBm6dODOYKSSdL8it5RI2l+PDfKkioLSrj88XCMyfuX7yom1KiifZMUwITeS5bggEvQ3QGQZbsDj9SfbpwU7mmL9/h6B/qSvKD68QeqRYDkaE7cAoTk7RnREJ73b7NchnS7e+jynhPCdkcKdViUCiuvv8dE4/vWHJmGG6yfKlyUDyYvTiei
 zZiAg3/h
 2RLzdC7rBdPHUXHsn8QJmzFm3Xu67eMVuJtluvQnm501m8Q/zQhZTN9zCfkW7bqnrE7KdddefK6Bqa3irCS+NfquDk0vjQtBqT9DrxSc1uVAiDiQGzB3Oq5bi9PKJHkn/1WpAocLHgrjxZm2rAb831EPdzaFhLqm8fGdbaTxqBw7zG+fhVuq7m25hHZbt/Oh2hAVvqeSljjCy5PihJU/Lxj+mpWY8+vNd3Q8ahhVSzB3dXjGZtkQ8v0Wn8GoenxFaq/te45ULTNKFHCFpPVn+0un4Z46t5pMBZip+cLtbgvZD4fSnAQFNj9R5Hu7WJ9XD+W3Ny26lr9UM3KWPwGS/IICJoFeY0wjOnG8tFNATvE+zB3WpB50m8Tw2T0ezu7H8SQum+yl+ERXS7gLL8tzAw4ArwnsmBYhhUqpcYcAp21np/G8Kp0KSYlUQ19v79/CjYjGP2pzImABXiBWr7z0ZAheux5j6Z2B4PC7/zzKbGace0q7LsfOkGdB7c9qOgrtoNXvLM02Zfam10FhnTcVr4hWEfAD928ecOUSVJElgVE/UzOZjY8P+qdneipOeY+RROktoH+AZAH6p8VVN2a3hEwyiJR9nMolTZg5pJxDJ3y8ZED6i2kTaaye4eIDYGy5oQoLKFw4QZeIbwEk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:29:39PM -0400, Zi Yan wrote:
> On 11 Sep 2025, at 21:07, Wei Yang wrote:
> 
> > On Thu, Sep 11, 2025 at 10:27:08AM -0700, Vishal Moola (Oracle) wrote:
> >> On Thu, Sep 11, 2025 at 12:19:34PM -0400, Zi Yan wrote:
> >>> On 10 Sep 2025, at 23:27, Wei Yang wrote:
> >>>
> >>>> On Wed, Sep 10, 2025 at 09:35:53PM -0400, Zi Yan wrote:
> >>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
> >>>>>
> >>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
> >>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
> >>>>>>> isolate_migratepages_block()") converts api from page to folio. But the
> >>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
> >>>>>>> to head page.
> >>>>>>>
> >>>>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
> >>>>>>> which means low_pfn only advance one in next iteration. After the
> >>>>>>> change, low_pfn would advance more than the hugetlb range, since
> >>>>>>> folio_nr_pages() always return total number of the large page. This
> >>>>>>> results in skipping some range to isolate and then to migrate.
> >>>>>>>
> >>>>>>> The worst case for alloc_contig is it does all the isolation and
> >>>>>>> migration, but finally find some range is still not isolated. And then
> >>>>>>> undo all the work and try a new range.
> >>>>>>>
> >>>>>>> Advance low_pfn to the end of hugetlb.
> >>>>>>>
> >>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> >>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
> >>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
> >>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
> >>>>>>
> >>>>>> Forgot to cc stable.
> >>>>>>
> >>>>>> Cc: <stable@vger.kernel.org>
> >>>>>
> >>>>> Is there any bug report to justify the backport? Since it is more likely
> >>>>> to be a performance issue instead of a correctness issue.
> >>>>>
> >>>>
> >>>> OK, I thought cc-stable is paired with fixes tag.
> >>>>
> >>>> If not, please drop it.
> >>>>
> >>>>>>
> >>>>>>> ---
> >>>>>>> mm/compaction.c | 2 +-
> >>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>>
> >>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
> >>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
> >>>>>>> --- a/mm/compaction.c
> >>>>>>> +++ b/mm/compaction.c
> >>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
> >>>>>>> 				 * Hugepage was successfully isolated and placed
> >>>>>>> 				 * on the cc->migratepages list.
> >>>>>>> 				 */
> >>>>>>> -				low_pfn += folio_nr_pages(folio) - 1;
> >>>>>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
> >>>>>>
> >>>>>> One question is why we advance compound_nr() in original version.
> >>>>>>
> >>>>>> Yes, there are several places advancing compound_nr(), but it seems to iterate
> >>>>>> on the same large page and do the same thing and advance 1 again.
> >>>>>>
> >>>>>> Not sure which part story I missed.
> >>>>>
> >>>>> isolate_migratepages_block() starts from the beginning of a pageblock.
> >>>>> How likely the code hit in the middle of a hugetlb?
> >>>>>
> >>>>
> >>>> OK, this is a kind of optimization based on the knowledge it is not likely to
> >>>> be a tail page?
> >>>
> >>> No, it might be that most of the time page is the head, or people assume so.
> >>
> >> For compound pages, we will always have tail pfn < head pfn, so we should
> >> always find the head page first.
> >>
> >
> > I think you want to say tail pfn > head pfn?
> >
> >> If you did find a case where we somehow encounter a tail page here, I'd
> >> love to see it. And then you'd also want to make sure the other compaction
> >> trackers are appropriately accounted for.
> >
> > I may not follow you here, below is the call flow for
> > isolate_migratepages_block() invoked during __alloc_contig_pages().
> >
> > __alloc_contig_pages(nr_pages, ..);
> >     start = ALIGN(zone->zone_start_pfn, nr_pages);
> >     alloc_contig_range_noprof(start, ..);
> >         __alloc_contig_migrate_range(.., start, ..);
> >             pfn = start;
> >             isolate_migratepages_range(.., pfn, ..);
> >                 isolate_migratepages_block(.., pfn, ..);
> >                     page = pfn_to_page(pfn);
> >     start += nr_pages;
> >
> > In the loop of __alloc_contig_pages(), it iterate on each nr_pages range. And
> > nr_pages seems could be any positive number, so it looks the first pfn checked
> > by isolate_migratepages_block() could be not aligned with page order or less
> > than MAX_PAGE_ORDER. This mean it could be a tail page per my understanding.
> >
> > Maybe I missed some point here?

That looks right, I missed the comment:
        /* Scan block by block. First and last block may be incomplete */

> You are right.
> 
> But nr_pages cannot be any positive number, since ALIGN only accepts
> power of 2 as the alignment. So alloc_contig_pages() might need another
> fix to handle the case nr_pages is not power of 2.
> 
> Oh, after I checked pfn_range_valid_contig(), I find your example does not
> apply, since it returns false when any page in the range is PageHuge.
> This means with your example, PageHuge branch will never be executed.
> But alloc_contig_range_noprof() is exported and can be used directly,
> the @start input can be any pfn, which can be in the middle of PageHuge.
> So your fix is still needed for this case.

Makes sense to me.

