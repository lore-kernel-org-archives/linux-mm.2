Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B882C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 502976B00A3; Mon,  7 Sep 2026 08:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA676B00AA; Mon,  7 Sep 2026 08:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 417736B00AC; Mon,  7 Sep 2026 08:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 170176B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:33:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A81E3120150
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:33:02 +0000 (UTC)
X-FDA: 85186905804.02.438864A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 08C85A0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:33:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MR24bwJJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2iHD3gqDKCj2QGR7GYWNFcmLP3k10Fn9vLLIK1hz6Q=;
	b=ZukW9MN2RAG7e0YPnlBTILrComFklbU0HQeHmFlZg70RS7PxorYFtO+50o5rJLU0nSe3cC
	ejUrgwl4wbjsEGli54kN2s26O+5mHB+u4YK9GV6GKKmmHMIwXA7fEqwSe1EsBEcVxq74Ms
	gXWffK/K4P6AY/vXNlPv+LQJ+RpQGSQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MR24bwJJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784381;
	b=ihwqV31AKWqahdi6lgIowby1Wiwos8+BB6g4Z5kOWtaJKdOzZxwmgA3NbtU4UUmKN1TuEq
	hYv9tqL2iuXPfh0UYOochDTQxfSNDwkH9NZHN8T3Ifz7xG6lGU7ld/oOy18XnOXO1F1CP2
	52sCVOgaa4ltw3BTfySnrQrGklAOHKc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27F1340A0F;
	Mon,  7 Sep 2026 12:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D3D1F00A3A;
	Mon,  7 Sep 2026 12:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788784380;
	bh=A2iHD3gqDKCj2QGR7GYWNFcmLP3k10Fn9vLLIK1hz6Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MR24bwJJn3WPSLSaGDC4QmCRAH0ef5go8d+B6Hd8hOAdYfLk3I1XTgLFC+W8oRSlU
	 wYV7gjxDSoo3rZN/buTvNfDA8RrHZ7izDRqPu19IQaMz7pQCA9pPc8Nl9g4H3DFjnG
	 6cQTnDcZCKcsozvUu9zxIiGgHwOISy2a51nuPGV37VgLK7BFgoeHA1iww8WMI64Z60
	 jIyCaxBHh3/3juv45cHnjMvf5u9Y1xhupwy81zFRQg48rh0mXtmv1Bntj3ScGqi+h0
	 6CxXkjQ1jHeSH/BjiMvoR8/h235xKerP8ll7kQyS/lo/4HtnB+uR3zbCguJ9XD9LaM
	 u6Lq4L99cV5qQ==
Date: Mon, 7 Sep 2026 13:32:54 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Message-ID: <ap6u6Ana3MvvIIUe@gremlin>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
 <aprjOxDy3JCPb2oa@gremlin>
 <20260905171757.ba8b0f8f0f18ebd04418bfeb@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905171757.ba8b0f8f0f18ebd04418bfeb@linux-foundation.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 08C85A0002
X-Stat-Signature: dp1nofzrwjo5cksny8pp1m7zsybxyfs6
X-Rspam-User: 
X-HE-Tag: 1788784380-87272
X-HE-Meta: U2FsdGVkX195g6VCDplVVXSU/uAui/CLGC6sPGNWVDpao0GKBs5ttvA7ilEXs9+g5wuKaxWttqeIvgDOcd0ZRsxD7qoMIC2LPQ2NW+XL8LMOyGYY3tqbilmNZBEJWE21KU0cGXOLn0c0BQfjGBPnz7fBenrFe+hVWUzzNkjVEMs9bDbW2+SOuKODIa8yrnauWib/9nB/jCrN5vxFhwtRTLmfI3GFgpCKLf70L4bY/i5HSwBOO+8WD6YIe8RaLLw91liFmhKcUrU499HEZliUGh9K8/2Tt6IqxTGI+s3TdV2SNolMCaALFTeHBhC0/m6EhKPhUiJ7QIBSajNflA+1OdSjkDZ0OCNzFdDepvCZqHDfFQ2/b9rl/rVjth6+92Pm73NlIeFkU5ZL5ujuHCY4iiuTNg2SADzGUaehVtYhb4BKQX+F7hHcGOVUwY/H7L5TOYzu40xQeL8yJ1ScRmX0xE5nzKo99FbcxTHLzfdihjKGLgK/89RwSccZ6HxsGz3Afm/f8iVCl2NJpT4ku6a9u5w9X8hJatWhaM5JKLFgPL9iN0eM39zTxRBjXdKmcp1VE7y1iRqrEsA5IK9gFrtpIu56jSz/fx+jyGP1RDRtlWYZafYCKPTmchFiwR+5gYO//UVnVxaPUF5Zd2xZttY440gCmhhOQL+WhSc8/RTEryISH4eVz6UA9fetWIdeFcjEM8QlTieNUlo1Cgg9onsOPhBb7Adp0DUIwWVY6noW2W4pAuYrmNpKMswEkY52cT+mm+ix+mJt1bddx0TX4Wxb3LJBcK+J3BL/TZAL4YwZhRbVENyZWxDkj3fAfxxJwLoEWueibEFaZAxuteQ9Q5U/zbFH0UQegdQNWgHIeBV827WDdzSvc7mU9qQt8YTp7fOFP0Dy9YuphIn0nk8fUCXAgLG/bez58JFrqUgR3XiI386Bm0SwcLfkiSHxBvGGZT4cb57XwIo7dXLFhaT47IN
 DMGImHNf
 kkXJBa7TwVR9HwzlnYIOiON2A6vyc+GN+0YkymsejkB9V/7RV5C1MRKakfXrC4kas16qZZ6ydf2l3bJ4xF2K8t80Kp0e6RONz17kMxOxBnGMxD8Q8rRatMQ54CKJGS9pdm8fcRvfTSj1lS16//J84RFOX5GKwCgO/CY5YbrXpL1erhXpI0kTMmwQ/ZSgefZDeQuJq/p2MCOc9z/g/rfqsPCz1zJkcc7o22A3VdUWYCSQrt1Ju4ggSEbLPlzZe4MPwvfLCWuMFyRKdNRexrXfzohJdTk+Ob5Z8j6mPlYeyG9g7B5AZkk/x798CPGu5LnDR6QLY+D8nMgPcAhM7DFXIK80wHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 05:17:57PM -0700, Andrew Morton wrote:
> On Fri, 4 Sep 2026 17:01:37 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
>
> > Andrew - could you swap the patch out in-place with below? Thanks!
> >
>
> np.
>
> > Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> > entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> > for the former and a tree walk and swap in to swap cache for the latter.
> >
> > MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> > as if they were purely file-backed, meaning any swapped out private pages
> > remain swapped out.
> >
> > Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> > mappings and performing both walks in this case.
> >
> > Since the logic checks for vma->anon_vma this means un-CoW'd
> > MAP_PRIVATE-file backed mappings retain only the single file walk.
> >
> > Reported-by: Mike Kaplinskiy <mike@recall.ai>
> > Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> The failure mode looks pretty obscure, so I'm thinking that no backport
> is needed.

Well it's not even really a failure mode so much as a 'known limitation' :)
So yeah agreed.

--
Cheers, Lorenzo

