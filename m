Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0904C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 21:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 069206B0099; Fri, 18 Sep 2026 17:50:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 040866B009B; Fri, 18 Sep 2026 17:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9ADF6B009D; Fri, 18 Sep 2026 17:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB12D6B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 17:50:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 52C688010A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:50:09 +0000 (UTC)
X-FDA: 85228226538.12.E623497
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77D1440008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 21:50:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i91R2tZq;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789768207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7ccuuw5WPtG4HrizN7+nr+XZ3f4qN8Ifd/iDDA2sCA=;
	b=Hd3oFui7gNoLSKnmats2JqLin5UdnjxcmKP8vJw6yOToDo4L8NEYP+F3IV2QHjB0/1JSJH
	xZNG7q8q9WDEGZ2hWzD5wCTxz+5mfgO/tNz9a39E+JhFlD618Z3crDISTY4dCY57xambI8
	hMARVesz7ZCOCA43njwi5E6nsqxVS8M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=i91R2tZq;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789768207;
	b=M//vj8tZWt5wS9Xo90o3h+91DrCLiOUzDSXFlL14hMCRJRD7FpxtnQJCLRODtd1QelylMe
	b7aJ0M4RhKsAV44K1UJUOYLRGmDAdjtvuBQ0WnM0IBO3WtuHBt/Cj5WV8Lzir6p2k7teh8
	afchh0j/P4d0O/cOpwfpaqAKhHzCNZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C8B6419CB;
	Fri, 18 Sep 2026 21:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D3DB1F000FF;
	Fri, 18 Sep 2026 21:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789768206;
	bh=Y7ccuuw5WPtG4HrizN7+nr+XZ3f4qN8Ifd/iDDA2sCA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=i91R2tZq1oqgXyNTYm47di7DloFGCS9Gs1JFSlQKGWdWTZ153GHc4qwhSAE+yq2rY
	 DVa0IoIjxaClfQuBvT/Ywmudd7ISQlwjmqnyOg5dzx0nsNNK7om8dx2t6hzyAO3FAN
	 lMkKoaH06YfRnSDgk/Z8/sY+kCZDbqVjs5ccAuKU=
Date: Fri, 18 Sep 2026 14:50:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 david@kernel.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com
Subject: Re: [PATCH v2 0/2] mm/mempolicy: stop copying state in the
 interleave paths
Message-Id: <20260918145005.236264772edf83e1b6f728b0@linux-foundation.org>
In-Reply-To: <20260918001203.3389165-1-gourry@gourry.net>
References: <20260918001203.3389165-1-gourry@gourry.net>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 77D1440008
X-Stat-Signature: gox1s37a4f7gat5ymjkizfusyjeeri54
X-Rspam-User: 
X-HE-Tag: 1789768207-952788
X-HE-Meta: U2FsdGVkX1/B5vSXbCbh3tO4BS2JR6vLDn5DdL91RJ+tpM63DKfLyyW/S9eoaX17HtO8KZwnnYio4q4cqKAgU5VoOAZSUQlO5oOq481E+2x3cl2zpfzJ1Ffrk/TY30Yp7I5xFyz4WnqPWT5hrteBBsl6+DcKoY2EwjM5UKxkkuKGFcfrHRGeZ09C4pmBIqsgwC5xp0ieH7uSpZZu3jC840fWHmEmidmX9EShjaf0I1MtaL0VE6frFFFEiQGOriaLehdlz8fJS3v1QrVTz8Rr5IK3d07tzutLnJ+dK+Oc4PwSYbRdhQM4noxMESKRjwgKhg/NFu+QT7P7NiP0Ca7opNMK18nbmO0VmY8PZ9pbw/gglfx0mBJ7xFp7kRzBAZM08ffLRNtjArhQgv9bREbBSJU9f7eqTOFTnhVcFuoHcZ81oBGE5HrwqZ2dmvOrT+zCCiCCb5c3o+6sTXoBupDdfVc2DOl5FYln2tmalZTUzF2xK8MscO2G1Iev7qsI7h5/7r76froPfC7xsuYAZWu4CKpwKTfT2Z9aCC0O8igJszT/eDoPyDLJ8ayxGgqH1kMkoT6eHHn0TMZPDW7xbmqpbXWmhUR9TET/IEqE3gofqgwrL4uAVQI+GWp81Fy1tEGU/GuDvlsB7rqau6HgpiwJuQd+p7iT3J0zMD+aUnbIBx8WzbXsxT1dxR3ghJ6APnLS36i1e0AN0vY60oGFw1hVX9ge4sFeUfmthqiZWDJWLrQleIkKZGx9cFqP/9hJoefct4qdsnXoyIed5mF+xriYacJwRrWLwaiJ5nly7Y/4pAi7hDFNlG4BdHHpDumAx5ctpM2MxLltVeDZbDhZaVDMI1H5SbFR2kTvXVqbizntYytkh2TFlM8u5dnO1gne2eMorRAQcG93pCTMNhEE1w8jYPCQtQ5OSSiB0QGwYuRmmV+TWIz3TeH3WxL/ifQbmjq3+pp2N/w3MuOiG8jfu1P
 yHuq/Ysr
 I4Acsu8QhGGrkn5f+GXlOz+/+ayCxowkjQzdB9h/ukjuPAgVG7k4ajyibk2xqipas4v8gF9T0bOJsB7ybHp8nHeBpPjiPA/oASrnyfk8VBPSJKVcX73Ac2yTLUVzp/KpTe0qIsdY5J0A+Ofq9f+9XoRI79JKT7lnt40sPa4xp4wRgtHvbbrVWx/5PQDLV7TkqJ/YtR984uXRSUZzGy8fYwFRE5ey77xgE0hWufsjVurvPm5JM2Ki9WxdQq6Ge3KS3fLnHO+Qi2CSQUcdkLa3InRWdHd3XqhtNmgkYyFrWZ5dRHbJwL+rOqskmiFyvxgLzgqhqFp5ETTYEvFdJ9LXfcGKhzYlX5yCBFO/CdaECLUbP0VlxrUlxuwCKEC33kC42n5wQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 17 Sep 2026 20:12:01 -0400 Gregory Price <gourry@gourry.net> wrote:

> The interleave node selectors and bulk allocators take copies of
> nodemasks and node weights (for weighted interleave) in the fault path.
> Both of these copies can be entirely eliminated.
> 
> For node weights, use SRCU to pin the weights in place.  This eliminates
> a copy and a kmalloc from the bulk allocator path.
> 
> For nodemasks, we can operate directly on pol->nodes as long as we bounds
> check the walk.  A concurrent rebind can shrink the mask, or tear the read
> of it so the mask appears empty.
> 
>  - The interleave node selectors fall back to numa_node_id() when that
>    happens, which is what they already did when a copy came back empty.
> 
>  - The bulk allocator simply returns what it managed to allocate.
> 
> The node count and weight totals are read separately from the nodemask
> walk that consumes them - creating a time-of-check / time-of-use race.
> Just clamp the walk to a single pass (number of nodes), and clamp each
> bulk allocation chunk to the space left in the request.
> 
> The cost is distribution accuracy during a rebind.  The copies never
> corrected for that either - they only kept the code from dividing by
> zero and overrunning the allocation request.

Thanks, I updated mm-unstable to this version.

> v2: Comments and commit message [David]

Here's how v2 altered mm.git:


 mm/mempolicy.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/mempolicy.c~b
+++ a/mm/mempolicy.c
@@ -2231,8 +2231,13 @@ static unsigned int weighted_interleave_
 
 	/*
 	 * The target was calculated in a separate loop, and a concurrent
-	 * rebind can change the total number of nodes.  Clamp this loop to
-	 * a single pass (nnodes) to keep the walk bounded by node count.
+	 * rebind can change the contents of pol->nodes as we calculate.
+	 * Access is safe, in the worst case we suddenly perceive an empty
+	 * nodemask and return numa_node_id() below - otherwise we may
+	 * simply cause a skew in allocations.
+	 *
+	 * Clamp this loop to a single pass (nnodes) to keep the walk
+	 * bounded by node count.
 	 */
 	while (target && nnodes-- && nid < MAX_NUMNODES) {
 		/* detect system default usage */
@@ -2266,6 +2271,8 @@ static unsigned int interleave_nid(struc
 		return numa_node_id();
 	target = ilx % nnodes;
 	nid = first_node(pol->nodes);
+
+	/* A concurrent cpuset rebind may cause us to see an empty nodemask */
 	for (i = 0; i < target && nid < MAX_NUMNODES; i++)
 		nid = next_node_in(nid, pol->nodes);
 
_


