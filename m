Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4593F106FD9B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 07:35:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74F956B0088; Fri, 13 Mar 2026 03:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FD456B0089; Fri, 13 Mar 2026 03:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6096B6B008A; Fri, 13 Mar 2026 03:35:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3986B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 03:35:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B49B4C2AD4
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:35:09 +0000 (UTC)
X-FDA: 84540228738.06.196F7DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F1E12C0002
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 07:35:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N83u8HMX;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773387308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6yBHNyLw/y2vapwOdMtHRlVAC5mZz4SBSyd6QYDwdK4=;
	b=aFJI1h7uqziM12qot2rn4HqaS1njNFGJ/gyKM5v36AVlMTx5qsP0qfdaqJA8Px58EjJsCy
	2jk/KC7llkuOMcOQQHcEdcqRDM4uTVSGDhfmFYj+uAxzjOEClpbEVMQ7BLp42hY1yUt+oe
	0nGmwiOHPkVYHpzxfekNKGMFEw6Wbm0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N83u8HMX;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773387308; a=rsa-sha256;
	cv=none;
	b=R+eU7wGcYuKTMeyUE7BoXNDHbrmArDELse7rofpLj4o7TAPdB7BX9k5mJPp08/095DSKix
	uzjZrqgTg55zJbvU+rmjnuIDqhGn5cflJMfPJ5RQa3GRLVZ1qamHu+opTAmU1H+PuddpaN
	3gpY/PUE0q0Jrx/68XqKlFsb/3ECxhA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C30EE435B6;
	Fri, 13 Mar 2026 07:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EFCC19421;
	Fri, 13 Mar 2026 07:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773387306;
	bh=Hy/mm2FsSo89H25fWq5uQIiSYeWoevbFUmwsH1lsJuw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=N83u8HMXtvCVLJvM0Qtnh7rp8ZYDXDV3zSGJJlxrw7EO3LdCgXskApIiDntE5QLWE
	 bgvfmNy0YBMtskCCSui9ml1GBpso1MZIueVAoF+Crq4Uo97+18N5Da0FjBEyTZU7UH
	 +z0QgiUzwBrp1E3eViLT81M1Lx4SAjJpt7A9PktX3lcrRynB9HARv3ed2ExqZYkTDs
	 chrUBFgVqgbd76j9tINjsN6Q1aWl4Qs/5ymqHl8BSA6KIAf0qywEbAiyV+3pU9vv8l
	 SK59nFuiWD3WE/Xs8NmRQFmBNJPc3CmZXelLF+2VnEL56i7aQwpcl+JZgWaj8+yDWZ
	 6lSMNBz2xwgZQ==
Message-ID: <60f71f4c-71d9-4751-8c6b-10179b98bef0@kernel.org>
Date: Fri, 13 Mar 2026 08:34:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com,
 cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com,
 gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org,
 joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <3a42463b-9ddd-4d64-b64c-6c2e6e4fc75d@kernel.org>
 <343bbd5b-67a0-46c4-8ec4-69158bf26b3f@linux.dev>
 <874imkpba1.fsf@DESKTOP-5N7EMDA>
 <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
Content-Language: en-US
In-Reply-To: <cd3d7e2c-79fa-4c00-89ad-83beddf98bae@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F1E12C0002
X-Stat-Signature: mzkapck5u17k9nzi4hynbjuyc6ihftns
X-Rspam-User: 
X-HE-Tag: 1773387307-206543
X-HE-Meta: U2FsdGVkX1+xVqbOkOqwpMpy6QNtTq+u30HYNFM1hMG0n1gn8gZ5W+BrbtkpdS0Ub2qgALNMuRavknJdT+zCjP7sp9gAmB5dMCtsGXu1PYlOW0+8Q88aMWwXTmHIqG5DM9zwNxWniZpIVr4a5P7zMS6kp48pnINzFwEUR6IRxjkbv2z1dg8/Skn70/D6q7LrbyOU8FgZ+URnuSrHcdhih8/O0wNdkGsfByoC2GkS93CzduU4ZMHL1trNzZrWnAZkmng3ZyeWZCiwQeqDrUZFvWnbIS6IbIyBymhDFH7Uw6UcKoL28z6Zl/eYlHYnlMLmN1DwGPIX9nMj9vRGlxevxiOyx010C2UFIkyeTjQbQ2MVexAWNd3katH0emDk0MF1d2/UavpRIosCmfpFf/PTTza2VFpDF/OGcFmTAtTmHwsSn9ptUNNNMoBrkH/Ev+AdBcXH/l13eEQc9ABM1js1Bghsvp3RKXTNqESWFgnW5p5BQCfiMJ8o2DxJE5lubx+eCU0bY9mmRNAeOZI34hSAGeJUW3M6rDCLzph+x/Jb1Fn4Iz+RJP0/NVHMNQx21HBRz1zUQwmHh3L/r+V253+eE56vYaz/oqdHE66d+gWZI8ERgfI0FkPwUolX1CI9omgyml8ESDP4vCocEAeMSqtLPLlakSxOD2W+wl5uK3IkfM3MevRumD55KvwIx7+FlO/VVdLgeX9iJF1y1kK2b7u4pz2pfkjZgzKlFyfr6bjYCZfm73cpPeRY8SZwNjvn2QIkmg1lAi07Kyg88SRUw/hOB9eoNWEvo5wE7vaNTwh4KiDRVnxAqdzyZoguyv7438uNEvIYpMhuI+M3qYr8eF703+Gn2q5j7snWBPQyfUEHZvNhuH6m3onqln7UwgxXLluOAb7Rq9yABQbK0XtQpq7MuN9RRcTSFWullz7/tV/H49q1s8kmHS1OwUKFK07cL7BKpLRjihI6afU0SjtBoLW
 cKsrAjpE
 2rGJ/axp/RhBSgeBP3ctvhR4SjBWKsGWSouhhfx/xSQVHiayXZHegbPqVEWvBxAnKWjpcR8uIYHfXpxF+J+le6quk+TpFHCU1VSr6haQbmxS6LARgPK3PTcqDEGXazW32em0frbSRkq0CWYop0uZGeVNmfF3nFmBcC/fsnOMcQGKjuM/4CjXTglHfYl/t6pPrzpBARXkp4e4ZG0LSPyJNb1/x2DfXXp+x8x+QrynjUL7JNkMF9CVJB2rXnVrQwNGRM6u4PL/VAUMdlDxt3LJ8KdEtwwEcsqj/EawMTDNGs+BzKwO7+f9Z/nhusMrAGuVYHPDqZtWJq8RcD7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/13/26 07:14, JP Kobryn (Meta) wrote:
> On 3/12/26 10:07 PM, Huang, Ying wrote:
>> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
>> 
>>> On 3/12/26 6:40 AM, Vlastimil Babka (SUSE) wrote:
>>>
>>> How about I change from per-policy hit/miss/foreign triplets to a single
>>> aggregated policy triplet (i.e. just 3 new counters which account for
>>> all policies)? They would follow the same hit/miss/foreign semantics
>>> already proposed (visible in quoted text above). This would still
>>> provide the otherwise missing signal of whether policy-driven
>>> allocations to a node are intentional or fallback.
>>>
>>> Note that I am also planning on moving the stats off of the memcg so the
>>> 3 new counters will be global per-node in response to similar feedback.
>> 
>> Emm, what's the difference between these newly added counters and the
>> existing numa_hit/miss/foreign counters?
> 
> The existing counters don't account for node masks in the policies that
> make use of them. An allocation can land on a node in the mask and still
> be considered a miss because it wasn't the preferred node.

That sounds like we could just a new counter e.g. numa_hit_preferred and
adjust definitions accordingly? Or some other variant that fills the gap?

