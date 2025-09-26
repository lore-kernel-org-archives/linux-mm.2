Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9373CAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 16:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FC9B8E0008; Fri, 26 Sep 2025 12:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D41D8E0001; Fri, 26 Sep 2025 12:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1110F8E0008; Fri, 26 Sep 2025 12:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 005038E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:21:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A77635A89D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:21:32 +0000 (UTC)
X-FDA: 83931916824.23.E0C7DCF
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf23.hostedemail.com (Postfix) with ESMTP id ECA20140011
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 16:21:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=CNm+PbEE;
	spf=pass (imf23.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758903691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i37nP5Fsob6v27s2uWqZghUanMjCFkgfqQelus7jYZk=;
	b=QICAkriG8/JSxkCZJGjS5GDjzEIewlZEMQIttbPXlT0eqgKReUxwG/z6FcnzRj3XpHZAf0
	oJIbk9qjj1IKm93SE2q4H6jif1Jy1U4o8/8cQAaYncNI1kdLBF4aUXiueZglEmlBEJc9Bh
	wl0zuCMb1bG+oxZu0LUXDWG4nOqIUvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758903691; a=rsa-sha256;
	cv=none;
	b=CLZ8AQLar7NPzmIbfDJnWeaDG+iTveO3gFvKtiVbY9K7ujHiakhZ8AIg10cwkix2aoZrnJ
	sk2CRdPc5YHK3h3Zc78auyienCGJC6I69Kq2CMbhcDvCUtdgFnzL9SVMYUuJX9pIwRPMvz
	Hs0amrsSOqdkkNTLMDqOoEXBUogP0gw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=CNm+PbEE;
	spf=pass (imf23.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1758903689;
	bh=i37nP5Fsob6v27s2uWqZghUanMjCFkgfqQelus7jYZk=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=CNm+PbEEeiWQMTxOz2g7X7Au3srI3fYV/lCulXVwtRi05x++a4eF8ooa+ce/5xE7g
	 E9c9TU3m9EGg1Pbf4ecSNQ0MvpmA5cPENTB4M4Tv+X19WgwsqZE/99sPQs5do3TCxO
	 lqQoJCT7a6lUS7J6HoRAN4xbqW/8AZbxkI6Xp1DM=
Received: by gentwo.org (Postfix, from userid 1003)
	id A72E0402AD; Fri, 26 Sep 2025 09:21:29 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id A5BD44028E;
	Fri, 26 Sep 2025 09:21:29 -0700 (PDT)
Date: Fri, 26 Sep 2025 09:21:29 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>, 
    Kiryl Shutsemau <kirill@shutemov.name>, 
    Brendan Jackman <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>, 
    Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
    Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
    kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in
 drain_pages_zone
In-Reply-To: <20250925184446.200563-1-joshua.hahnjy@gmail.com>
Message-ID: <567be36f-d4ef-e5bc-e11c-3718272d3dfe@gentwo.org>
References: <20250925184446.200563-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: ECA20140011
X-Stat-Signature: 638mgewuidja1nib5a73xdghi9jjcw7u
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758903690-990969
X-HE-Meta: U2FsdGVkX19eiqL95ngUkoiSgS6ZN01EErvXncQh6GVmyl2GMto9b+gFvuviCmjIzLhYEAKobRHTMJRceotkBrcs5SPta6dSIim4oLhijbVxWxh+7ZpM/nYY7qpDI/8K5uAjozUVozAwcBhJgo7yBSmsDJvUmtHkMH8HaieZ8bql6YfBTI9YZdJeT/wzmgCicTdA42ux6FKHaXMuKb9u2umcRty/wv5ujigiZwZnwNDnWHx+94vh0zCsPuLIhMYQXn85XWUmfRbIfmeeivvV3FztyV2CYKYasE+3t7JbfTzay7ilzBFeFqaPyeMPoAGAo7u7WwoSF8D1uCqkDMvgbMqbTyrHyPDVUur8c+r2ak3KQxInCbEAFT3QNAreJM4EC14x7RZ69578n0BgE+H0CxNOGUcF0oPXHOmcIM/5wVgZqVR7z7r4u0LtNBvMsp/TPYSmYq4GRorZJmgC1jSlPsvrSbeLPQ8U233WlTrikpqJqYoY1e8E/vH8E2hcMkHMu9rZbH197vByZUbUT4Fl/kYJiTW/4hyks4v8WaWnd+eH1UWeunwNM498FratbTxayPt5NjKhqJuim2EhyenmlJu5z9GD4KbObWuXHz/dQYIfSnZi49SH1uCsC7XXCmmY4lcMOSoT07fTQ7WuvhVzGCx0hA06/fHlE3enZC6Nc0tyuidB0DzrzYwoDcdiZEI/Icp+UCFdyuUHcYGukUsPnBeDT9kxE0+CMUXewqJ26s6c7OTV95rIkmH2DrPJZWZ4bGGfDGnOd+Rdomtt5nmcVb82PH+34KAgV64wmsH4lq9MY3maOiiXw7RAiSiDyYk3DSQC35UINIkuPg6+vvMzvTzto71yS5/SjCofKewf5pV7bfIao0QJjD4KeBJJEyQpwwZpy2FnFhsgFa/Un2MUEVWM63MZSnLDHTrXXgDFPiDVruJfQS0PEm3GLHXULOoCwSmppTcrqtotyFoAzjI
 CL8/yPEX
 ThWv6Wn4oCiUkFsINhOjevZfzLNKe5g4fmtH/kM9Ki5xHPMESPqBcJsYpXhNOxHTDIEruZDVLtIdyYbpghFQ74aIn3zLLLsvI6ZQnWBzbTSejhu7SgZvTlGTcwKiHbOYuuW2YozVsUbM7jPc/zpHaTHwWnE6yuXI3kqssKedZIzFIsxAaRPfy0h+Vt7oO07x4zXb0svWrTQ2UL7DqFlHzEfs9sUkh87eOpwmAYO0BBJIMbeLvPbwZLNtCgcyTk+WjfPKa+9KB5A43E8z0sOrWbkGvz5ZYPkzK/kxUyAEa4VV11/igJ3D5FMAOYWi4swrxmBfbnMhh0vv0n3E4Y46XsCNuok+l8WH22komK39Xxi9uuMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Sep 2025, Joshua Hahn wrote:

> > So we need an explanation as to why there is such high contention on the
> > lock first before changing the logic here.
> >
> > The current logic seems to be designed to prevent the lock contention you
> > are seeing.
>
> This is true, but my concern was mostly with the value that is being used
> for the batching (2048 seems too high). But as I explain below, it seems
> like the min(2048, count) operation is a no-op anyways, since it is never
> called with count > 1000 (at least from the benchmarks that I was running,
> on my machine).


The problem is that you likely increase zone lock contention with a
reduced batch size.

Actually that there is a lock in the pcp structure is weird and causes
cacheline bouncing on such hot paths. Access should be only from the cpu
that owns this structure. Remote cleaning (if needed) can be triggered via
IPIs.

This is the way it used to be and the way it was tested for high core
counts years ago.

You seem to run 176 cores here so its similar to what we tested way back
when. If all cores are accessing the pcp structure then you have
significant cacheline bouncing. Removing the lock and going back to the
IPI solution would likely remove the problem.

The cachelines of the allocator per cpu structures are usually very hot
and should only be touched in rare circumstances from other cpus.

Having a loop over all processors accessing all the hot percpus structurs
is likely causing significant performance issues and therefore the issues
that you are seeing here.




