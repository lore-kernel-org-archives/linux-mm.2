Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57767CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503296B009D; Wed, 14 Oct 2026 10:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA066B009E; Wed, 14 Oct 2026 10:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F01B6B009F; Wed, 14 Oct 2026 10:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D84A6B009D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:56:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A0B9B120570
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:56:11 +0000 (UTC)
X-FDA: 85321532142.01.C3E93DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 148ED2000D
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:56:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okqV2nzQ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791989770;
	b=MqO8iaapWZ6IjmxTyoB3UKfnJbXWj6VjLtPmWwZ0OzImZvt9Dpr4OMtNbQ+1gXcCu0yCGY
	fgG5NWpKzLLHZ3eo5WSBg+PE8D1TI+KAnwQ5YoxeNHNBSEAOb6rzhBUUetiv5GPo2NImYt
	f49PKhs7a1tkDEbYx+rHpoOzxxZVkfw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=okqV2nzQ;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791989770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Re8GJbdhl5QjVvoUI2rtJjUCyF0iWbGuReuk1JeK0as=;
	b=xIWzODJvg2P7ce8MD8yVYVABMiswZrr+wR/RtXyMVb9v/r23wcFm4cnZ94YEl827jk0jP/
	fKQR6GUbo+hKPp5zxLhssyZ1Wl9k5vUTiOAhj81RHNWo68laMx4H3XCF/0GN1F5Pw43s1l
	0paVB31E5nViMgyxkbPVTQT4dVF62qI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ECE9F40B1A;
	Wed, 14 Oct 2026 14:56:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12291F000C4;
	Wed, 14 Oct 2026 14:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791989768;
	bh=Re8GJbdhl5QjVvoUI2rtJjUCyF0iWbGuReuk1JeK0as=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=okqV2nzQ+YeNHZZ4PAdi+2zs9E6BjLN0y3+24X96ykEz4tM8JTnoxD9cqhN0+FQLC
	 wqnCwx+ZncTNSm03hEGxeujWLAcq4wMBvJVboK+94QqAgNjgko+DuXV5YDpFnAsVp4
	 Pd/2v/4/ultfuC9mru+g8VW4vlz9VkgA8Wj6WoENEUCKPCL1QyWv96+GU3rkyDx+4Z
	 +uqmmCqp6hS6zim6u4hISNm52CxsGNis7O9RFq7UvNx+1X9dTKa0f/NySGeGaP08Rv
	 luYLtxDrLyV2CcZgmmEmjXl+cSNyzELMpio5BPuMjF1ZyaHsNKOa5Fy4f1HVXsNmm7
	 GJu7ysP+uLPWA==
Date: Wed, 14 Oct 2026 15:56:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Ying Huang <huang.ying.caritas@gmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Chuanhua Han <hanchuanhua@oppo.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Kyle Zeng <kylebot@openai.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix address wraparound when scanning large folio PTEs
Message-ID: <as-XYuUJdeHD3W9p@gremlin>
References: <20261013-folio_pte_scan_range-v1-1-c50dc30bf6ad@kernel.org>
 <as4kvHe9IFZH5qrC@gremlin>
 <9add8400-66c1-47e9-b5af-7a4081ebf3c4@kernel.org>
 <as-BZibPscw4cxsD@gremlin>
 <06930044-4bcb-4478-8a6f-2dd3cf6d290e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06930044-4bcb-4478-8a6f-2dd3cf6d290e@kernel.org>
X-Stat-Signature: 87xc6kc5ykjgney4367jiuowwmdfako4
X-Rspamd-Queue-Id: 148ED2000D
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791989769-532089
X-HE-Meta: U2FsdGVkX19K/90c+xOshWZm19ZSC2HqsVtzGRsiaIjCF3GZx/g8k1poSWhpJr+V8fqLgBQ3vFE2syj5uLTi0KkYqFD7EBFYvjysuLoIejTR0PrZVfIvqWB/eTlwRYvmpBbHLwsy/iP12dae5LwFvU0icMMqVIAfp8UmVY8sdppNpQI7dCVMi/IFfMiU5yU56cQLHdSsfejNtpIXo1sx37witikb8pVjrlDI/lttyeLgX4AYtCF344yrpJHOVHQqXA6HO/NotfPu7KKd2zPK5x3965zSj/TZnjdZDBLyo19C7MSN3STHDWOqyKhTkrF/Tj9jEMeoCR5IWlC27+R8m0WMkp2TNOQIQuaKUJwbjQAcqFbGAJVRyt6zFvTrELSj7zsyfPGH/m751Ukhc0BAS+CQ2XJEjm9oPYsD8tffqSpPgEuoB1CyEAIkdXiWvsOeUQPRRYa5C6E2JQ3kaiyxJsTOmq45A0ov4HfW33zW2EUYN0w+/tsrdXhNLZpm/ABT/SSFz32DGwajePreTdwiSpkRr5VLrp3ZfKO75g3hb6Couh0MbzLH1Cr6QgBnudJKnXf2wAMIXNPFJe2pPmNQgDQY5AlyzKt5W/lOyjOP8HHlmcE1kiBV0Y9zbpWKieWquk+VIFwN6abIPS36OIQPsSxd5B7rX2aIprSD3DP/y8JP6bfR6d4lhYYGVQ4nGlYtmcc7QPPi1rlvO2mXgPd2ondkFj+sgOrIo1avZEWKmpP7QzjnlX2ea/lqlURX2ds5MTGe0OGVkv2aDYGFibTAn7BudE4LF6MQOH5J0nIXev3Dr07tpAbgJ42arcCOqABqQrdf66Rj9nuhR/j3IRQTBkRjwz/hKj8n5nC+u77G/sJgue2jU0LmrtHm3Emokvfo1GKTyQfo5xuxlWDFFVXHCQWw5gOFRWC06cxBJUYQaAqrN7AkVz0qApwxmqLnuv39eJRfrUmnzZ7x93irVxI
 prfnPi05
 +4uZaS/MnoRa61xU/t9UZGsF1+/z+l5sKH5mT8HBHUxEiwmQB9ZDiAWlIdZa080711H4057DXtOEldMGsTHYzG2shzt4F1at0JnMdYj9Y8RRCSQC3z1q3hUyDdLWJLpfVSIF4L5MjmpleCzcuYzIPWXWzabzAF/EftJHvc1NI5fG/abLaYt/MCR/MR/L4/Jpzp1F1ihezUETFrO4kH/bmrPTGARYcBAoOF1WFqz6+wkPBdiDlciz/9GUwokGQPFdRXp4DonhrjEAVNirqau6aOZFVlZV+0Ya/5Z62T0aEvYRiKqQkxo29vFH1mZXbk1rjuoArAZQRodW+4azUZhLe7m58gbmhxfXPObIk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 03:45:41PM +0200, David Hildenbrand (Arm) wrote:
> It's the following thing that adds confusion:
>
> include/asm-generic/pgtable-nopmd.h:#define pmd_addr_end(addr, end)
>        (end)

Ah ugh :) of course.

> What I am saying is that I don't agree with adding another two const variables
> with names that are less intuitive than just saying the computation. Let me try
> to improve the comment:
>
> /* Avoid address wraparounds by not adding/subtracting beyond limits. */

The variables are a (possibly) neat way of self-documenting that, but then
possibly adds complexity by having yet another variable :)

A comment works for me, though the confusing bit I guess is knowing which bit
exactly might overflow.

So maybe saying 'avoid wraparounds of <variable that can wraparound>' and a
brief bit about how would help?

--
Cheers, Lorenzo

