Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 575F4EBFD2F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:22:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 946AF6B0089; Mon, 13 Apr 2026 06:21:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91DDC6B008A; Mon, 13 Apr 2026 06:21:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85A896B0092; Mon, 13 Apr 2026 06:21:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 77FF56B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:21:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21EAB1B5D07
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:21:59 +0000 (UTC)
X-FDA: 84653141958.06.61C22DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 809201A0006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:21:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=stEoYb+n;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776075717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VREiXEs7J61psqgKlH8svbUoA6MxSMPQI4hSNms/WbA=;
	b=qpO8SSMVrIGGmmWBXGkIZXoLiEmTcmozIR1+ygzauAFTgdgDK709xDOyfVkw7RuzoJXcXg
	LIpWaz3pm+dXAPvQBMSMdMKfYgmHwcI/+h2Ofz7INMzoRaG9j7ZVEHGCGQhM8RwP/mnY7X
	97Bb8wFYncx9WTo+BDdjGI7zneU2VQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776075717; a=rsa-sha256;
	cv=none;
	b=faRL1uCxJuZmksgnmCU0DrqUBNRT5C6AVVHJASiv7zAA0FX6AMwY7QQmOQPUB49D9aVHv3
	wBxKAMEkO6r+p/J5dd/ibHJKZmpfK9i8cF50//Hou40+viTM3oQ8TeG0NIodkLEk7ZzoBT
	UVdWrZDzvY1uAcld5oJV+6aKpxcfNzw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=stEoYb+n;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DC03E6132E;
	Mon, 13 Apr 2026 10:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E54CC116C6;
	Mon, 13 Apr 2026 10:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776075716;
	bh=t+dMFyBnXAkPlXEggFipn30qdiXeTcuiAqliSpvpdMs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=stEoYb+ns0AufBnsVRibEZHRF1EpC6N/W7KCj9Z7vEZGK6qTm1KeoNA9LroQFrLwL
	 eZXvB8UGLYyyKvwZRqWEWZO7I39CuclOa+F2Z3ZZb62XMpRjdQKiOGdgr2I+aQ+8Tz
	 PtzdVrZC3ACBktoVFrbwfurITtplb/YaoiRbLujic6xsOTI6RRzpEVg3BW6xoU+qEw
	 JaA5CvnTU5i5MB/q8ytuYxeDa9JDwrazcefDQZY7u7vrssw8+4B9IFBuWw3Y71bGc9
	 8fGwKB+2BosXWU5bieq0x2PyRd8HsyGxGBw0iVkt17aSMzJatUWQOjY0ySFHr1Eazr
	 cEny9gWhmS2AQ==
Date: Mon, 13 Apr 2026 13:21:45 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 05/53] selftests/mm: merge map_hugetlb into hugepage-mmap
Message-ID: <adzDuePx9lNthity@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-6-rppt@kernel.org>
 <4e364241-aec6-4d28-a878-4fe25f5fcf44@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e364241-aec6-4d28-a878-4fe25f5fcf44@linux.ibm.com>
X-Rspamd-Queue-Id: 809201A0006
X-Stat-Signature: a3q8driawro56dsboi4og71cq97ncqyd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776075717-649668
X-HE-Meta: U2FsdGVkX184WUMg7nrCsxSevvkep8/+WxOa+Wi2ljQ7g1PubPllrjgtu30UOjRrGeycEa2M4xWQh6Ya29OKqVO2BqSv3E/h4UZO492AhRShHuNtUtburIv6+hKL0JwJDwmK0edX4CEXFhYKHSTJZijkahoRuiSfp3VYMnnTieD+blsOeePE0LRemMExFNZyhdnmkGTjAsuL2EZLqTi0mUMr4kODdYcmsUvCkdwtcANKAUZRu47jWxlVlIaIyFtC7OCXCSvV3HmJSAwaTRMkZxM3xIxZugXN7+yiuf+xtPh9I/Obo8tJKZ0U6GptEgr7Tvru1vg1x5Wjwc8ZAPjvbWxi7yeAcZXpk8uLCLlDWit1gNM3hvDCc886kmr0MHTvTMimnaMjUG5LyQA4Rs9fWpzIlT3NJzCpY5bV7o1G+Zxa42grY7KH2kzLCUdh6j6FhAw+fgLgDBciHJznDmE9ry56JwJw4CfRrlTsL0B8/Z9qaQBtXzjDTw6EfKJaYK4vEVcEOcsS8zanp/4A2TJsZaogjB0BmKrhLfOxqH7mwvsWR1PAwVvJlPFlTqnJCt+ZMSD6JF82sgMXy3VDImwfx0X2MsDqGYBrkToTJ0jv7atmkfOPR2iPjPvkMBQLawdnmzAmHY6i5ltJSetXL6bIzvSNQvrDFPqe5LogR1IcBMyMoObw/EiW2wBPxv17KPVKrU65O+74xaSGVjrvvmFTkxYXS1Z84Z6TCquHaBk6uxJ04VbCMOny4lsYSbQckOVu86dJQxtlQsRqlW7rZcXmHWjItDjJ7hP7H+cnGQyKlFnKG7H8UAEaiwaZpDydzH5czAOrw03t7jNnGboC0myeTmUrQ/fuvxbrPHolKRHUD+5zLHeTPLw5RA7KmekPKFr4WsGa90Z05LHugnW7nmvGiM0O5fIusRlppZRmdINgPw1EDUi13v8bWHlNjW2T3b9mym69sgOieRaQua7ls3E
 67It0TDv
 YZlXliXS87EWDV3UcLxE6ZH3zYQlsg+SqbwubljtU0c7TLV0Pg1qQGbGLzTXUu5WvZh95neRl2BBqazozo11XeeVCcw/pq6uOhpOfp5uULYh41QIYmpjHezHsI2VBQKgL0JY1+GxhaA+idylxyqdPsZ0MSbx/Nt3VxmM0mpnmdGCKH/HyuHDHu2SGbw1GUyyTPQ83rhDCAZEwzbyeO/IdjKpYAmEFdxxx7vzOQn0sUvh0YSBRoWAAVQQFRxS6hZACH3ZyjiOzOEl6O719abAz3PvGXysWyK9a8vNUZ7hqYRWi9h8M+Tm9fKzBRjyjI4c9N4Qb/6C6dnYsh6TFUT/5HE9d7pdh1TkkC+bu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Apr 09, 2026 at 09:35:39PM +0530, Donet Tom wrote:
> Hi Mike
> 
> On 4/6/26 7:46 PM, Mike Rapoport wrote:
> 
>     From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
>     Both tests create a hugettlb mapping, fill it with data and verify the
>     data, the only difference is that one uses file-backed memory and another
>     one uses anonymous memory.
> 
>     Merge both tests into a single file.
> 
>     Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>     ---
>      tools/testing/selftests/mm/Makefile        |   1 -
>      tools/testing/selftests/mm/hugepage-mmap.c | 113 ++++++++++++++++-----
>      tools/testing/selftests/mm/map_hugetlb.c   |  88 ----------------
>      tools/testing/selftests/mm/run_vmtests.sh  |   1 -
>      4 files changed, 86 insertions(+), 117 deletions(-)
>      delete mode 100644 tools/testing/selftests/mm/map_hugetlb.c

...

> It looks like mmap_flags and fd are not used in this function.
> 
>     +                     const char *test_name)
>      {
>     +       int flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB;
> 
> 
> The same flags are being used for both file  and anonymous tests . It seems
> that test_file_mmap may be broken.
 
Thanks for catching this. Will fix in the next version.  
 
>             void *addr;
>     -       int fd, ret;
> 

-- 
Sincerely yours,
Mike.

