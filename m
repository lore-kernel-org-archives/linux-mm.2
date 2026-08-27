Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD43C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DB76B008A; Thu, 27 Aug 2026 07:11:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7453C6B0095; Thu, 27 Aug 2026 07:11:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6831B6B0096; Thu, 27 Aug 2026 07:11:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7526B008A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:11:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD5731A03AD
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:11:37 +0000 (UTC)
X-FDA: 85146783834.25.1E8DE14
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0A438140006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:11:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J5h76EDg;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787829096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QC3BIZDZe5nQFldfAX05XhgyHJ18yU9SPBq5s1DSw/c=;
	b=cIDT5/LHumg6+y2Cbomi7OJcojdlXM3Deo7caltJt3rIQg5M050+/7Ek7LB+6u4SxWzG6r
	K+goP7D4dwoLKbF75W+FCeFhoMLVByjj5lP7ERQsom9m0l4Y5HGASKlZAp5FdAiQbj9U4T
	hdnPEz9HoQ4UpFBFdmvZ//izzLwBME8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787829096;
	b=lGKD94aNEhkGCoLEo74GhGgIvZMZ5PBFUj27yVv+qtP0b/qapxvUVD0wFLzgbAtGvL2TqQ
	bVpoL/zvURwsHAuVqCItue5Y8LaAW4pmM2YfCzFuLiOqu4jzYnGacE5OG4XZzxfZwjvj9N
	2J8MpgU5PKZ94FXO3/ydhpgcffi83lg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J5h76EDg;
	spf=pass (imf26.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23CD51688;
	Thu, 27 Aug 2026 04:11:31 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 596433F66F;
	Thu, 27 Aug 2026 04:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787829094; bh=y4Ltva00upZxLtDuluXaAsdt9DyR/JLUL3X5FOumC40=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J5h76EDgUE0FZPkTnAGVaoJ7EKVyyZtoH9BAVzPXg1MD7e27Oa4E3uJ5alXx+G3bo
	 Pc7jiGS2F43frLNC3KOB3rr9BpljHw2b6IGEOhzvlnvPoJBLVz2+9ZZwgEUKLbLasB
	 eE5rAPXN+Joia7vMnv7p8ldUdwHuvNA/sq/H4PGg=
Date: Thu, 27 Aug 2026 12:11:30 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] kselftest: mm: prevent random failure of huge
 page split for khugepaged
Message-ID: <apAbYl_g8pXlFesg@e129823.arm.com>
References: <20260826-fix_split-v2-0-71153c7f579a@arm.com>
 <20260826-fix_split-v2-1-71153c7f579a@arm.com>
 <36c54170-f7cb-4b1e-a1fd-50544390632b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36c54170-f7cb-4b1e-a1fd-50544390632b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A438140006
X-Stat-Signature: kmor8hipn38ih1akfphdg77f8wysekqx
X-HE-Tag: 1787829095-551558
X-HE-Meta: U2FsdGVkX1/whu8Xue9gouuGCQthqDMZokgwadeywsuTaHRsv5q3jEkV684UBDzzZ5TIxJ/TDFrORxvBxEtT3D6wUZbtjpC/TfQW8Eh4HwWzn6XIEO6DHGP47rvTsnJE2wIi9W6Uw8KhVvb9Rml4B/RLNwVThgmfV8kPEZnKYe6e7m5c1qkMFz5F9eG4TWsB4HWVTkJZysk692hPuxd+1ZvRPS1LqaeSZBUzpqHuBneAtlBNbjyvbPr2aOU3tafMNFEbj9sKF65tKgPazi0lZ3Fz+RjkDcveAcIDbxmC6uDB0gkg9SyzoRAjO6QPtbZyihXIR7GHC0kueFHYk0Af9pPQCaP37ciXf8rShu+/hUXwWEefYF5vdmVzgsZNSuoYBviPcY8vYwgGvrKRGFaaAb9rabQeeqaaAX88jAgd5JbcnfaoqnMTLYLGGeBKPnMEQE4quTp5QMGakKd6e3nzaj+pixyifEoLPWVr/B/+gZBw4D90bu5GhNdmF3V+4doG06Hi+4M5cG33GcUQl6RHkb2EhNiCCIB3H1vRKAFZAfEMAMC8lfGsJyKcJ12rqKj63rJ/5f+GMFyAXGYyO4mbYJscLgAeyh4z8Iuzfw+0TjxPbszX25M3z9LreNMCnrylylDjpOUDeY6DYwpTzXuJd8ghzs+6NwwZlbAl9YOXS+eDeb3AkLTVwbDJLWnk25Et1plmDMryzkfHEuWDixF2RYBGPkjOVfopwyES7kDTZAsBJttQqYGWziTsILUVwNPOrRGaLqqrLM/PEIT6AhECKVUvCwKcxOyrkUs3ibHz1rP1W+zR7AwMCFZ65LPvdl5fwqIqyDtY6SEfxu7RNS7MHnLcmpbM9lGn+Nrv7cqVHqsYQkNFgKuBB33IYVysAZm53xMw7+aq0sRBKSAN/6mDmx9s7kQMr1i2DGeLv907GTdu/DzP3k9VYSiSR9CCQ45LZ2mFBfGZ854n1ZCUNTN
 sveB/v23
 kijLG6PkSH5jmJb6CTg5av/o7U25IOUz1I9b0wseKWbUbN3fEmVbl5BaaxeG+QKLb+/KqIgv6/OWeA+dKpuyoYOIH3uu08LAdPq6mdh8eszWUNa+9cid0Gy/uQVKpBrCjjjc5qaGU9VAhm6Pnkw0qEHp6wyKGUYX+EerzwwMoZVlz9NtMWYMuuseDOBav+JybvQTo+csa5wNIqnpXTkpia5QOmfkI/DS5/9AtP0Fwo9xOhhLdtgwS0bGGJb9UOEw21xMX9cXC+1hnGA09pVJ4SWQT7IcXMaqZDS3QqgQHBem3/mSyqZ94gr6dFzUkliFvY6vL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On 8/26/26 14:24, Yeoreum Yun wrote:
> > There're some random failure for split_huge_page_test when khugepaged
> > collapses pages into pmd again which had split by the test.
> > 
> > Prevent the khugepaged's collapses for split page by setting the
> > mapped pmd-huge-page with MADV_NOHUGEPAGE before split.
> > 
> > Reported-by: Kevin Brodsky <kevin.brodsky@arm.com>
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  tools/testing/selftests/mm/split_huge_page_test.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> > index 86a603692826..8f68bc94a5ca 100644
> > --- a/tools/testing/selftests/mm/split_huge_page_test.c
> > +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> > @@ -180,6 +180,10 @@ static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hp
> >  	if (!rss_anon_before)
> >  		ksft_exit_fail_msg("No RssAnon is allocated before split\n");
> >  
> > +	/* Prevent khugepaged from collapsing the pages. */
> > +	if (madvise(one_page, len, MADV_NOHUGEPAGE))
> > +		ksft_print_msg("MADV_NOHUGEPAGE failed to prevent khugepaged from collapsing pages.\n");
> > +
> 
> Ok, this is really only expected to fail on extremely old kernels or kernels
> without CONFIG_TRANSPARENT_HUGEPAGE (where we should never get to that point :) ).
> 
> Can we just turn that into a
> 	ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
> 
> I'm okay with a ksft_print_msg() as well, but would shorten the message quite a
> lot ("MADV_NOHUGEPAGE failed" or sth).

Thanks. I'll change the message only then.

-- 
Sincerely,
Yeoreum Yun

