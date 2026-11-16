Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C66606A883
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ngpSOVeP
Received: by kanga.kvack.org (Postfix)
	id 542306B05B2; Mon, 16 Nov 2026 05:41:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F36D6B05B3; Mon, 16 Nov 2026 05:41:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 409806B05B4; Mon, 16 Nov 2026 05:41:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A66B6B05B2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:41:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A88BC120871
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:41:23 +0000 (UTC)
X-FDA: 85440640446.07.9ED895E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8B9012000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:41:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngpSOVeP;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtA/R92C925aFVKDUjGI6ndZPtLKG+BE7ZufHgCQDo8=;
	b=SkBqkbJh1IS0szw9fRVOASlUoAbFUHE2IjAsujpCAWxNuMyDx/7n3d3vtWqbH37eNEols8
	zz03NuowUmlHonruuw0uxpPYDppMJLW3fZ2CDXmoW+eSjiYbSQgJppwW4nCPDebmu4aLbA
	Lqrxy+p6rmsoy8TPMbdGTUj3YmcTxcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825681;
	b=V7qF7++SSFIwKmtmZIESLZxuIt/3fM5bDPV9l/Ev/Jrokg8An1Wjf78Xljb2UwvcMeU+2y
	jdOg+wuyGiGllCDz702vv0XQUr6SuDm2rSbmeb0iulSKeyrjMXvlVKLJfoh6jCOlHozT0T
	iLdezn9FeLwfS09Pa5gihTlfhobO9TE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ngpSOVeP;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96B27628D4;
	Mon, 16 Nov 2026 10:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937011F000CB;
	Mon, 16 Nov 2026 10:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794825680;
	bh=mtA/R92C925aFVKDUjGI6ndZPtLKG+BE7ZufHgCQDo8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ngpSOVePFMDtjm1DFvzRnPE1XRgzCOD2oFWJ8d4Ream75ZBgI7koYW2I/saxoji/J
	 1+uCmmQeOMgoo+jshQgPUiPmss+TmNaGpwDyvXqgzQe/RWwgu+IJI4m6i6B61JMi/m
	 rCIP5rLDm2h19YGXLN94+rZXkioXU8QE1bQO60M2rkv1BDhCOIcbLLtWS9MRIZtQ+n
	 LLP9cgbpqqeDHbgnkFTAtLiwNRMWICu6dq1X2S88HrqilNbq+a3xMbhBvT3iukTD01
	 8QqpR4gaEllLTdiOPeosh9KJCFvmPbwNeUkZHwsDqSHGyNh/MIyguwDsoN0rsSP6gv
	 wgmqBDkZKRprQ==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 34DBF198003A;
	Mon, 16 Nov 2026 05:41:12 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 16 Nov 2026 05:41:16 -0500
X-ME-Sender: <xms:x936atmzbygUR7XWzOiKGxfcLwKsJOya4h-Ar0Mn3OKoB9QGoFtuug>
    <xme:x936aq0QnYyW5PTqhqHkxOM4CXviJXliGKgeLIWM7tJeecpknpS_Gn1johgvcZVfF
    MhQFhFe-38bbxkDKv_P35jWnBvIgRB3F8t4OtAgvqI68648BrU6ZgX1>
X-ME-Received: <xmr:x936an88khMU2qOvRn8b0glhAUvuZM-wtt_kSvhtnOcbNUUNxYco-juxNxk>
X-ME-Proxy-Cause: dmFkZTEpJfblbk62xZOAh/T/EZa08rF7h46EjEoJinMEsXgVXH+bIddNYbMR8VMGVvyjT8
    e0mdxzBtL7KE7zvFOr8XDChSXWMNwAELnNLe6JjwxbgAr66Bmx5PsKcc76FYvA8nBU/xw8
    pAb4ThAd4RJeI6MMqU1Vt3s2dUzLwASTdOnH2qsvH+G1t2n2pTdLQ1t4ndkKRCNCfhFYm5
    GCh3wxhrd7AbePBcsqP2oD6+5F38itLQgjTL/aQUe3o5aSsOW4X+hWPgtwBaNbEwPhFHE3
    eV8SvqS5DvXPD3FVL9DXlExm4dDg7mFNWv8YKZi78rqOBjjaUcFYXUc9s29yi3JEVPEyPl
    NCtaEUv4NsRuQxjeh0Y3twDDIPA9k+soCpWA8q3h9GaJiLplOTLX4GX5j23NNarWS921Io
    J9SUfaeGQ6JyOASSCpZQN4Q9WdvfOxLEVFS0LcH8Apt0YxxJNbvyxL/dB2XzBKeTZkLDg2
    Evv18iMcM24ALKfuzxn1S7QGQxAr5aTUBvoow9y/RTzn6OxJu0wZftggMv9w0yZU9lgp04
    xlCRh+tQJmbaOd9/Xa4r3ZrKdvNQOLGHhEqUvHZqaWUcJCrsp8D3sMciYvyRkqIARnvDj4
    LV7fma3BMYE9FjnYWS8+9epfCGHFlSN/CpHvDJvwZ8kDXvH3GU15VnPCiC4w
X-ME-Proxy: <xmx:x936alz4lcBJrfREqjxlWztg2fzAlF8fd8aA3oJ6dF2QNYaj4N0Yhg>
    <xmx:x936algcb0RdjmMRuoFlqrgKqKoJvecTq7J7OwAjzHkquLxVnRiw3g>
    <xmx:x936aoPUFOLTRHygWjueWYnK7Gu0OKbrLHetD6D8nF_4t0ZqVcAePw>
    <xmx:x936arYS_q73xtLqBDDAESC9ZGUx2P4m_oGvVwn7fPCWUCUUa24WLQ>
    <xmx:x936auJAJr4cKPopqEOgaD1CiQGQmNMwCRCkmixrRIWirSeI9guGVxbS>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 05:41:10 -0500 (EST)
Date: Mon, 16 Nov 2026 10:41:09 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows
 the migratetype
Message-ID: <avrVAUGFUJdoVRG7@shutemov.name>
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-2-kas@kernel.org>
 <7e82bf2d-3a36-46d4-b63e-6b6720620380@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e82bf2d-3a36-46d4-b63e-6b6720620380@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A8B9012000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 7q5srqi1zsp65mu155nzxj9sfe43hmof
X-Rspam-User: 
X-HE-Tag: 1794825681-302956
X-HE-Meta: U2FsdGVkX1+pZOFapiRhUSfoF9ILHn3/Ha2wafoNhMfUgqCOS+eFumUlZX0srtQO3ZR6bPwIWQ72Z1XmMTk9S4b6fCzGtp6T1iCV0cwNfl5lazdUJHshiQsw3VjdV/l2+a2vCHGwGwOOr73/4apWU31nKBonoKgPm6xm8TwmFIAIe6x5bzUhyFY6stLj01aK1IHcN6jvTLXY3rDcxmpLloPtrtEqTv0Fge0hGoLtYjVfGTnIo8I43oP8V4FuT47lUvHoH3THnztgEb2GV95t6vQ/e5LC2cYZ34vA2M1JfefCUh8uf9QhblL1N9UuIWBiTqOS/DHXqtAmXY4uc5lcou55bIQBwLlpvzVJr86wlwLwabIu4ydLpNHFbY3ig/kBibcTaqLWdYauYMJjF8j6z1KDvph0CzduRnGSjiPygfdrsuzsCB2EksCPwdzUci8dUSFTzHXba8jWiaIQMjIRxXhXm5njuhjLDrbThEmGPhhpe9HIQdAIKmgxNl0YzZkroRx4mXEa+6oEr3AM4ZdZNldH6PmMiDQ8rzoJEK/+0EWOw47XgdftdF7DkyYwRv9XSdLA75dy6NvxO4SI2vIucx1pQjfcjXTzfvVF+JKrMXgG3qfusHey3/Xkux+T2MnBujPNGIO3g6e3QzjKLJrQBV2kjozOp2lxyEDwKT+T/ZTglUN93dBnmrGmdlVG63OS9m/Cdt+r4lCRWN2POCSgG5vs6XI+S1f/gZXc3LUES63TFOelgx0sRJIWMAEay+aMNKerVZlfMvvGudlPRaTsrtEGy5OzaWrpKT+hWgxevvxDPf7WbOW7xYc3tk12AVSlqv12hlUw8VLre2pm6jBuffX+lAt1OEn0ayy6oBvi3YZ2Geb5F0C03lxoLDSJfeEbYwRX+ESDXolIe1PCJW8AI0pJIt6pt6W3R86udJu4Lc7SZY7r6iGdfQggAGkgH1R9slCSdhc4AGIBTdeyakB
 2N+6Z8a1
 jpAruQLUTvG7UgBOqtRqtFWAAlPJTKGA5h87uH1bKRySdr7MGwJZjOJ7EPqoFEao8YCtPDikbXNScpx3uCwTtrPpTD1vX0J0t207q3SKLVIRNlgdDTUGHqt5axiFmaU5TVTYa7FCfnkCcs78WQZnq6Vs4cyc64FiE0+FMwa7s048z5SwDRtUo4nnL1CKYK+g3jiRldq5/OfZg4ur0v1r7bCgZHYC+D8THYo+C1qjGmew1kezk317EALvogd6dpYQTnAye+FCevw8sG5dpoXaOg15079Kvg+UW2Z0CG2uagR+GP/+64jYq90fKaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 05:51:52PM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/2/26 10:39, Kiryl Shutsemau (Meta) wrote:
> > The high-order check in __zone_watermark_ok() accepts a free page of any
> > migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
> > only take a page of its own migratetype or claim a whole free block, so
> > the check can pass when the allocation cannot succeed.
> > 
> > Telling those apart needs the request's migratetype, but not every check
> > wants them told apart.  A check whether an allocation can be served now
> > has to count only the pages it can take.
> > 
> > A check whether there is enough free memory counts every migratetype:
> > kswapd and kcompactd balancing a zone, order-0 thresholds, the
> > slowpath's forecast whether reclaim and compaction can still make
> > progress.  Reclaim and compaction work across migratetypes to free whole
> > pageblocks.
> > 
> > Move the body of __zone_watermark_ok() into __zone_watermark_ok_mt(),
> > which takes the migratetype as well, and make __zone_watermark_ok() a
> > wrapper around it for the second kind of check.  These use the new
> > function:
> > 
> >   - the allocator fast path, zone_watermark_fast();
> >   - its recheck after node reclaim in get_page_from_freelist();
> >   - compaction's up-front check, compaction_suit_allocation_order().
> > 
> > Declare both in mm/internal.h: nothing outside mm uses them.
> 
> Why not mm/page_alloc.h instead, now that it exists.

Ack. Will change.

> > @@ -3665,6 +3666,21 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
> >  	return false;
> >  }
> >  
> > +/*
> > + * For checks that are not about serving one allocation now: kswapd and
> > + * kcompactd balancing a zone, order-0 thresholds, forecasts whether
> > + * reclaim and compaction can still make progress.  They count free pages
> > + * of every migratetype: reclaim and compaction work across migratetypes
> > + * to free whole pageblocks.
> > + */
> 
> What a slop comment, sigh. Can you rewrite it normally?

/*
 * Return true if free base pages in the zone are above 'mark' regardless
 * of migratetype. Use it to check whether the zone as a whole has enough
 * free memory. Use __zone_watermark_ok_mt() instead to check whether a
 * particular allocation can be served.
 */

Okay?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

