Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36763C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 233CC6B00B7; Thu,  3 Sep 2026 02:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B266B00B9; Thu,  3 Sep 2026 02:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 122546B00BC; Thu,  3 Sep 2026 02:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2EAB6B00B7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:17:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 710EDA0481
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:17:40 +0000 (UTC)
X-FDA: 85171444680.11.0183548
Received: from mta0.migadu.com (out-37.mta0.migadu.com [91.218.175.37])
	by imf20.hostedemail.com (Postfix) with ESMTP id 70A3C1C0004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:17:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=COF3tCID;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788416258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pI7psLuIzv/f0vOp0s6lo3Vp7VxghrQS4rSe5ajWdbc=;
	b=IBrP7pnb8oWdqJuk/I6Yypeng9SiUWmy4wfL/EGL1OesrnD78MPbwBaEM54g9lePTwK/U9
	7AukwYP+ST+37xR8kOBrVwJrfq/SXI15/PKiDefbzJNbTrUMCa6a6sVqWNRAernXoWj8hV
	89xyS+0oBbx7G12o82d25jKiQ1sBjek=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=COF3tCID;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.37 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788416258;
	b=8Xqq+QM/cvDlQNA9EWd0ZHIdzf0efCytQGOcargKDY3bvUffGSYKoP8vaco1v9uSvbayVK
	spa9S46t1QuL1+WwXjbQ9WhBvw2vHY5QrNtk9W2/ws9WfMonXuoZ+jVZbMSNctDsVWm/oE
	O8rof9whbw+dv9DRMRljDc81mowW0UY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qfDv57uIWsnOlT1w0+UzNsl5Tfmu4rytKxkaLXjRnNY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788416257; v=1; x=1789021057;
 b=COF3tCIDTOSDXzADGQry3tyJwYwceLvp4DXycmm/DJ0ob1i22DzIw7kTMSbS8uFek0eb/SS5
 kTVU9vywrF3yeaZXpR+yWeEQGOFEUPP+hXU2YAuh8dUGasnmsfOkgF2hnqZKqwvOuI1890sy1RR
 gLJnaiDRLizPVyw3H7yiaNmw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 015fc451421f2d60;
	Thu, 03 Sep 2026 06:17:36 +0000
X-Mizu-Trace-ID: 015fc451421f2d60
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] nvdimm/pmem: Remove test_and_clear_pmem_poison()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260903053535.17611-3-kaitao.cheng@linux.dev>
Date: Thu, 3 Sep 2026 14:17:19 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Dan Williams <djbw@kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Ira Weiny <iweiny@kernel.org>,
 linux-mm@kvack.org,
 nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <E350C4C9-ECB1-46D7-B712-351D01C06C71@linux.dev>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
 <20260903053535.17611-3-kaitao.cheng@linux.dev>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: bei7jjanectji7n5pgozbda65up7m9ao
X-Rspamd-Queue-Id: 70A3C1C0004
X-HE-Tag: 1788416258-508775
X-HE-Meta: U2FsdGVkX1/amBX1S2itRZYptiBF7ijFJEzxJQenMdzYGlwC8sKm4k/mSN7NRssO6qsipMyswrfPZlBBmcRN1DlESVUctv729Vru8LyIfDWTCE2EjJnN9S4wUxBdQafcSTt5vC+aWfIdw2KwYG7in518nGAj4n2KKGpbRsetoDUOIns/rNX4LxoB5jJWrTXLhPWJsxj/3nGaJw2lxytSqMAxGVai8FErMblb8bXUbQFHRYyZuK9f7n9iuPiENXQHMxzpEPJZtp7o0mXG0WIK/W/DyZAV9ASc1sB6MoKUN9ukO2xeczuxe70voXxwtLBbjJFXFhCmWkQI9XMSvVqODXPrS02fgKQe+SeXAsDsyeQsG79rEXLjynR2DnlJ9GVBGVjYG/c9DYid5vbH1jMUGQSx4UQ7vJVjsPNxt74rZ0gXoCjdq7/CnbRcbKvnLDw+DddJYIlYhNdCb7IGlytpKdOoT6JOZNVSe5GiWiRi5o/UwOAJkVRC48e9nyixQOoFvXjRwWStZHGXw8KpZfTdvJDwrj/8nD0jXC9mFWPgDInNfWKkPDnLUSbbSt4VfOtFHN+pRbuihcmQmGoLagbsndGrcvA/VRD14bWQl252dJ+BhZqaFKGh84eacljqnZYCf9yn+EroE18OeqyUW35GX65PWdBMD02aunGsjos2xsBX4HHKQSkFpS51EmnB37q6W/jS/escPr7WZUSkdmU1ZM/HmvzmPstab9xPD2qFZEevBNrVsjRo8IYPrJDXibbKx9ZuDkn6RmFDwGyaxR6bolwRUfKMbexP3VV655O5QoM578QSpGR709R+5WYDnSajub0AWAkguwwFiFSlk0tB8d42XvUHT2ZtbTdRJAYiIjuDGFFJPmMREJP70wocSM+xRw34JjrkBeMPmUVX2wrYOiKmdZuaMEjNVpIjlx0FI29AYt7zL9WzGGw470CqcKo6FLg3bQdGxQnRGZSYooH
 RyUbEL+I
 6JlRFWcgIht8tS5o4oaU9v2DCB3mE7cgrZXWo2kJ/ZdCTUIF9gcmCsTq8dmSci7ULKQ8r+3VZrAQ36jRkkKbn4m8JpAZugzE9Zj1q1tT1smbjWa16YNSnBDo9dNzrwjYNxc6Q1B6o1Pcbv4+1TvTAoOmP0sIoAT9484rOSn8FLLcC1hvMGrNO/VqnvlNrnm4Dmo2x3hdsmQd4z8MOw0gDq4Yh4D0ou6myHc9Xlv9i/3rCXJZyTnoSX1W83uS79s8VW+Jy9IISTivl8y+NOt17DnCUNUXZl5JU7cfKUVN6AFMM0gk0AMoslWjg2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 3, 2026, at 13:35, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> TestClearPageHWPoison() is now defined regardless of whether
> CONFIG_MEMORY_FAILURE is enabled, returning false when memory failure
> handling is unavailable.
> 
> The test_and_clear_pmem_poison() wrapper duplicates this configuration
> handling and has no other pmem-specific behavior.
> 
> Call TestClearPageHWPoison() directly and remove the redundant wrapper.
> This also removes the need to include page-flags.h from pmem.h.
> 
> No functional change is intended.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

The code becomes simpler.

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


