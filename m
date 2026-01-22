Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42713C44536
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 02:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE326B00B0; Wed, 21 Jan 2026 21:23:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A85706B00B1; Wed, 21 Jan 2026 21:23:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2116B00B2; Wed, 21 Jan 2026 21:23:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8176B00B0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 21:23:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 230C7141546
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:23:17 +0000 (UTC)
X-FDA: 84358002834.11.763A74F
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5666F140007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:23:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bNnN+GwT;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769048595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bmiF8TW43ZnSou9pgCsnR1V6kCn/RdefnmsG8Ds8z2o=;
	b=UzNHB4Oma//BATwsK9W1B0pIUR3/YB46UPeaW0fGyYfbPnKzJWmN3jR9h8FKrT4uinE+OA
	KQCczvYCJTJ6sMZDN05pJrPEMBjDbFwpMO3xCgKZy9o4WBtJekLKT7I725/kqY7oPhRJa/
	3YDDS4g4C0+Ejbcq4nxDup6uuKu4Pes=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bNnN+GwT;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769048595; a=rsa-sha256;
	cv=none;
	b=iTyuW8rPxOD9DSfwNZQe30hWyHaN2r126RgiPVU/MxGFIPXycI+nuEc/fG50k7jvGlTf/3
	JkI/7Dmo6DWDc4zJOJAMnR/ChzRar7n55J+omE1RtsgLgVjEyY8fGBVQe7QQmlCRahzvye
	Xlsup2rwQJcpsCTvCuYw/Y+BTskppQo=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769048593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bmiF8TW43ZnSou9pgCsnR1V6kCn/RdefnmsG8Ds8z2o=;
	b=bNnN+GwT+bN5BoNeArtLq1vGEBoMkCINtSJT2U6wT57wr0hFyp6KTmhsbVQ69A05kmZ0bY
	lXw5fVrGTmsqyClAs8vdbKy/nWbbOuhGxLKtjORbt+pFfMIGbq6ddWUnWZi515oj0sxdA8
	KaAJSttz0Ocbu3sPdlMuKQ7FWrDCIpo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCHv4 14/14] hugetlb: Update vmemmap_dedup.rst
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260121162253.2216580-15-kas@kernel.org>
Date: Thu, 22 Jan 2026 10:22:08 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <17A1336D-2D78-4F00-9164-D90BB7EBB707@linux.dev>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-15-kas@kernel.org>
To: Kiryl Shutsemau <kas@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5666F140007
X-Stat-Signature: yhek77y7q6wp3z9bz95q8ce47a7i83az
X-Rspam-User: 
X-HE-Tag: 1769048595-708940
X-HE-Meta: U2FsdGVkX19/XvzGa6puf7hNjwJvydy0nZCTGTFS0IphQtNFEUjV6qpMykmYf7EKv6EpJ4H7bBBopES58Q+6NYIBkcYEyO6UxP8yiuWtZocKFAWFPvhJt3ahhoF14TNwg9UCQQR6ZadjqA2BuMsyrId+HtsFGlz2LtTMsRe2PSFN42hWAJdfpsg5f1cTevFnAhdpCIKCfSl6Yu/PwE2dupkDYHhm8C69Fwfv8eVYU5lnDKns4m+NEyAt5Np5jDpI2SJu96I1wm/hdB/chl1oC3bJ4a164CAKUE6ojYVL9ac5Q2OctUr/PVxvG7JKhfeGqW2flO9n8tq3Ep4zqfDwitjC+ekLQjcH3ycAIK74ArRH9ejMZBxAjD/VXqSl86z0+93RdlIu9BK9YXbwesIpokiMT5XJ+en6+0wYPjB2piWAvB+bPetE0SI3wQHO6OsWb1T8xG3h1+bcYvEV4q7eF6vPyUlmMWrAmMrhfvuM/2Xpx2mKZALK1PEZ5GxfDLAVq5HQE43GT29SY/PKl1b4bRqMvqmfl8VX1vn0vZsYPQ9w1iUys3zcno2fZw+M4b194czCKSTAkOk50M0TIUNSi/VqhSVeS6IHre1MdcHmONmxa2gE+ftlln1ZBMVWcuuBtmcKIYs1adHwsOPjipOF295oWzX2+/5AuhWjrne4qBnD5kv4dzU77bDYEHzEu7uGx1jvUAv2m/9VyukZc5Lsmz7Mjvmmgio0jUy4frsREHpyp2S9YAbuz4/WFtJtvneJvz4JnMyShm67uoqetcc5kXrWm/MAaS+/MrRejzx27Emt6FEJkz0OcEAQmCk4xF3znD/hnH66GoRSkFhXM22D/sTHPkVxMQdnkNLV8RzJ+Ewt3Pj9cEyBqTB5sR0lYbmXyvvSUFzEF50XKw2mekB19rCx1xj3fXi+XTsUzwp+AYkBAWsCJj/3XCcVCtnQEhUWxTT9Uv/Uh4o8jXxU74c
 c/pm1Qkj
 bBFd1qqF0p8BqSHHvu5UbeE+2FINzXP/XKshaD7vV5v0v22OcHtOhJY4RCAVN7rnDIPYYCv0LX7wTYkA0iliWZHa9Tilux4osqWGJjzNUPZCMdqrrDxq2SMuLIxISD+MKJClSaqi6+wTCr0cDAadtC9vgVOhRX7uskaDrPRmgsgT00qH26KpsMjbWKSmmZt3Yr0l0YKVuUvRKmo7V23sTJVS5XyNEeoZtggEF0bl3KgYI8CX/xZl14/7JieZ9VN6uZKliWVTYBIoeFPOnea0hVp/Uvpbct4Mhfw+8+jLey88b2VuPEsMH4Shg/w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 22, 2026, at 00:22, Kiryl Shutsemau <kas@kernel.org> wrote:
> 
> Update the documentation regarding vmemmap optimization for hugetlb to
> reflect the changes in how the kernel maps the tail pages.
> 
> Fake heads no longer exist. Remove their description.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



