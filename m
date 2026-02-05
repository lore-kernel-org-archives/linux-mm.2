Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B4FEA795B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:13:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 616C96B0093; Wed,  4 Feb 2026 22:13:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599466B0096; Wed,  4 Feb 2026 22:13:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BD96B0098; Wed,  4 Feb 2026 22:13:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37D496B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:13:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD6D3C1988
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:13:13 +0000 (UTC)
X-FDA: 84408931866.29.641B0F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3EB0C2000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:13:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n7SeFapV;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770261192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEtqPtk7GvCpHPDIpeP/K+Mu8H0SJxu2B93D5gQMKjY=;
	b=MzsTi4WnysfJeJKip5UQGzWR7wQ3tGQbrHXGT01KM5fz3dYrfzjMJlscl+9kHDZ+O6LXMe
	ynS8KCwC1TzoDGIb41SO2QfY9+kbb0isCbysIzPfI4dX6nDi6GIc1AnoeSlQmi6u1g6vL5
	9TFcZqUCQYdIQMEk1zzlnnVNsiPpoR4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=n7SeFapV;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770261192; a=rsa-sha256;
	cv=none;
	b=58ZdwZrayrVO/BcYmlf5MAEWOgX5KkjV8rvsBYPFkd/1J1vvGs+GNp0dTC6JliL043Uue/
	5uRkRZoC98fSCu8y3Omw5vn52CqeMizJ5vX3XPs5A9AbNnAcuxeptsKOLJJl6PFqkpou8+
	tGuhwlDiF40f/pxNJxPa7uWGoCV5GJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 060184343D;
	Thu,  5 Feb 2026 03:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C94EC4CEF7;
	Thu,  5 Feb 2026 03:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770261190;
	bh=HDN75FDUo5Qy2KldHx4LIkZkOb9M+7wUHDms5Y7mFs0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n7SeFapVpA0FVa0rBcWMRcqmtGXhKF4SUKqa6WYkxg3xN0Hzhk+bD4Sky5jqyzz8i
	 XrqwGPUGg1xCPw7eLbUS5wdpQeBTknZ8sef8am4JZu5wQad/bJvSThYaWvVQWHBHZn
	 onA9ZqZCPSsmKqrx5TWnRVy7wi9D6Ji2AbfoUcYM=
Date: Wed, 4 Feb 2026 19:13:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, ziy@nvidia.com, gavinguo@igalia.com,
 baolin.wang@linux.alibaba.com, linux-mm@kvack.org, Lance Yang
 <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-Id: <20260204191309.5c61a11ddfbb71f6a1672c12@linux-foundation.org>
In-Reply-To: <20260205030421.zz72iie5bwvgxlsj@master>
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
	<20260204114217.6da3e05ee5fbfac3a5f4c16a@linux-foundation.org>
	<20260205030421.zz72iie5bwvgxlsj@master>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r431eprzzim135wum9rztf4xojb6u56s
X-Rspamd-Queue-Id: 3EB0C2000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770261192-414851
X-HE-Meta: U2FsdGVkX19RddZDpZ2uZ2CQm/ZJi2SA525xbzbVzc4/J0t7V6X9l0uEbuWzdN4/5l6n6l8c147XampqbhcvmVOFLagN0MoyStnK18RauI0OJ4Mlm80YY333XAKa6IWmms+tO6kfE8rrxu1dT0IAe0HVbCAu+/TpupcvOusc/Fc8Pg86RduIovU8/oKDEwXA7bsv3iVWtp/mrGyctMJ9qVf0AmghGgA8II540cMWLKIcYOfLdqkvbjK6jsyyB9pr1fa0XlYFrO3PdSnLbfVzFETtyVPWlnVSfAwTJtbX84zSVL8v4ryUfp8gt8OPMVOhD0aVPXS5gs+Pi79HKzOE4ZyX5KNT8t6YJNnrnd0NcrxkfliFoFOmcVGDfcGlip3nf/9rWYPibv51D56vj9gyhPNJEPKvVeFRIkr/m2wkRz9V+VEOz/5gNO3TYr+HqjUsd3EzZ+GlFwC+b6cUlTtDoO10zHE0nq1vI93/FMxJ5Z0p9UpiD3g7KFxWJJACa237McspMMpezY+Lvr64mUIISWvfdi2LzOkunoTxGisq+2UZ4rMoAaVY5eCTfMljs/Gi2qE0LjOt5W/xeNTp2+Es+vZvvL/lKC7GVakxwX4k5iSB77djbpR+bplGvwE6Mc7quHQgaz++tDi3S0VVw5EdRBkYPx61V7gS8HgI4zIBvQZQsiuHglMLKuM9H6Wx0wmWbANB5Hg3CjWUKzg1MQ71uJJNeoba5UPN+wMCRJT7GcL3EaHpGAxezlfEQGnLs8eUqDZhpsWq+iM5WAC8DjbgMte15+/JtQmOgsQ/pE9ju0YYEq1edBZlJoZN60dqPbyZSMggW1gZuqb7Sjf3DNAo95cuDI5vEbPqfQoaL8dDp8ZrppY9CDo+wPrkeVtr61A8ggqD8hVbaTE38/Mjb7ktkO2e3+9yCM+w6T/HMGPzdNaC14tarHc+QmAbqSHAPnE/iIdtkUbaU07TUUXJdFp
 emCeXtgR
 CSJiUB15kYIk33Hp8a4EFGjjuqKfZKsPgDm00b4XLjI/9Qa3442eA2R0FYv7i5j8TkI9MY4+nWeA83sY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 5 Feb 2026 03:04:21 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> >> Cc: Gavin Guo <gavinguo@igalia.com>
> >> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> Cc: Lance Yang <lance.yang@linux.dev>
> >> Cc: <stable@vger.kernel.org>
> >
> >Why cc:stable?  In other words, what is the userspace-visible runtime
> >effect of this bug?
> 
> On memory pressure or failure, we would try to split folio to reclaim or limit
> bad memory. If failed to split it, we will leave some memory unusable.
> 
> I would put this in change log, if it looks good to you.
> 
> As David mentioned some change in comment and change log, do you prefer a v3?

v3 would be good please.  If the patch(set) was large and had been
under test for significant time then I think a delta is preferable. 
But that isn't the case here.


