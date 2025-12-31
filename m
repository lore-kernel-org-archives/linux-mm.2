Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC398EE57CE
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 02:50:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0F4E6B0088; Tue, 30 Dec 2025 21:50:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCED6B0089; Tue, 30 Dec 2025 21:50:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC9B66B008A; Tue, 30 Dec 2025 21:50:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9914D6B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:50:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B2A0CB820
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:50:51 +0000 (UTC)
X-FDA: 84278238702.19.C59A094
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47EDD140009
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 02:50:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WucivJ5O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767149449; a=rsa-sha256;
	cv=none;
	b=plBvl/aFW7tS0p5UA2L4I3dWt2hlh48wgdxMBseJMrleH47yk/sbcj62PLTyaF4C+gfm2w
	Ge/rxgPS82b+ERYa0cy4PpGcxCQFus/royN4rvvd/Kr2gof5OcDqIcvJzl49m/yldy8Gyv
	bPgc8uVrGHPWUjYEC2SbZtDEzi1zS2c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WucivJ5O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767149449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mnekp8j1WxTQ4hJG3hWSmIW7URQ749K4JNBDhqyh+Qs=;
	b=sGKw0fw+Ph7w5z4lTd8QzPe1Y0dcy7J3/y/cdO2Yr0upBoJObhO4s/y22f5j0pdUOGrkzP
	dU5mKKA7F7Qwz0kyEdDtXtDO71A3UJ9HgQpJ0RafRi6l4VqKR5/M6VKGLkRgYaHgVgTpCV
	BSbfJeXEGhLeiV/RPcNQfA6WW9L4yGs=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767149447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mnekp8j1WxTQ4hJG3hWSmIW7URQ749K4JNBDhqyh+Qs=;
	b=WucivJ5OUG8aNye7276oRlIOZp91/no3ZbB5yODJnY6Ye26wyp7WTnniMuj9O7CbC96wOW
	XVGWrbyio5YpIRfU+FXVNhgJ4ASpzCXYE9bbJ6sw6ewRBgVWccglLABIERv9yz9Vg5A7u6
	0O+sLxyWZnqZ/7hnj3L9UHRt1d8An08=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v5 6/6] mm: hugetlb: allocate frozen pages for gigantic
 allocation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251230072422.265265-7-wangkefeng.wang@huawei.com>
Date: Wed, 31 Dec 2025 10:50:08 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 sidhartha.kumar@oracle.com,
 jane.chu@oracle.com,
 Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Wilcox <willy@infradead.org>
Content-Transfer-Encoding: 7bit
Message-Id: <4C12581C-30F4-4BE3-AB30-CAC98697414A@linux.dev>
References: <20251230072422.265265-1-wangkefeng.wang@huawei.com>
 <20251230072422.265265-7-wangkefeng.wang@huawei.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47EDD140009
X-Stat-Signature: dy1bhsewcitkp7s4ucs5pqybemz38mje
X-Rspam-User: 
X-HE-Tag: 1767149449-778797
X-HE-Meta: U2FsdGVkX1/86UQSawkuz5MEByH+C/US7sBfdaIRqouC+ODt8se5PyehVJA+POe0gZDB+ZrLclriLuGZE6CbQ8Rlb6tEqY9cyUROen//3nc6fcDAF9lWSpXmJGajMEW9CRnTO0W2Ix0tPe1i1lhTvis7UEye0YvJMgwgtpud8HZWHm+MG2ZWCeB/LrGDOUJ6evFnP4sCUigeIowPU9x/gAIEBjVbhQfabiPDqgdQVObnRzz7theWLcal+2p1rwls5I1Y/Fr2m7zcoWDBcfdHCfZcCu13s+bz4sVCKusItqost2AU11qi2k0+Sq/nVqM5JOHeSKcQIV0khR3o7AGF0NqmUsjcYr1kPoJzaaT4eb2pfSdg2TYojBKTKukPgfY4aS59gx9jjabyxZVf7MeIe1bf3TtXRWHPS/Ot2CPwZjtL2ezwIx0bCoo/NxL1hoNzlfpCL0PcnHSqOs5CFvXOqkiVmJtaZAsZyTmtHg63ahzX1swCqDLiC2n9MFXfzls13AAmPXBgi8oYvJS1/oWwUjPmimBnGSahGlRRj8baKmW3q/BTkRhJbOPREsfSw4YudFE522ChRYFXTEvAVUGrnhmwy+4nXL0Sps+5eeWyxLXSPeqXA7zdnseTwVlQLjU/CfbMkn4L3a4XHGxuhfxv5aYkQi6GUoJsTKbn1k1itgr9j3anRV94Ywj6TWcwieeBH2kVG6qQZBF2kYwLfd3b03p1e4JkDaHIGq6zfSX9chkGvdIs+gtSGqMsEQysp3xY3+Yb6IWfCE5sEFzh7oL6rdp4imVzVAoEJ4HfIKy/l15BdVSDvP7tPxzgGdtivkOsE11lNfH6q3iKu3LS64mkIIWvHrQZVQQi6PYpjjnb6WNhuzFTm6Z6AUo9r/Qzok8e8J5UG7NioB7PKF8D7dSLNEkGc7hWvzwUoJjgX4RtInL4ko6llNyJjqP7lnjuVPlZ4a+Npxcre+/wZ2Mq/BH
 6lNKgKxg
 1ZpUesaBiRMKv1XppagegWx6PbIh09phQARdbJYqSrkTQmicSUIgZGpRzhcxMkenFQ7/LnIieiuEujY/U22ovWX6fcz0sKp89frANzitdHHS1mCbyp3tzc2irtiTXnCESn0uVo3u7A3kr/A8TZjjzZIX5olz9U3LwQLXhsqRtBiv0juElfPuTm+k+DDtVVWS3xyIcm/SN0mWA4YavQ5v4JBfaHU6UANuCytJkh1N7kOMgQC0NFf13f6GZMTht98YPoZPnc5m9bcUXpHmOTJgzeoEZIxZysS2QlIRZX+i1AxmxOyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 30, 2025, at 15:24, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
> The alloc_gigantic_folio() allocates a folio with refcount increated
> and then freeze it, convert to allocate a frozen folio to remove the
> atomic operation about folio refcount, and saving atomic operation
> during __update_and_free_hugetlb_folio() too.
> 
> Besides, rename hugetlb_cma_{alloc,free}_folio(), alloc_gigantic_folio()
> and alloc_buddy_hugetlb_folio() with frozen which make them more
> self-explanatory.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


