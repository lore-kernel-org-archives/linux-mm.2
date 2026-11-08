Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F081606A320
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DiNaJml9
Received: by kanga.kvack.org (Postfix)
	id 672956B05B0; Sun,  8 Nov 2026 14:46:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621F96B05B1; Sun,  8 Nov 2026 14:46:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E7A6B05B2; Sun,  8 Nov 2026 14:46:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 316DB6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:46:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCAA4A04AB
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:46:48 +0000 (UTC)
X-FDA: 85412984496.01.3DA7646
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id F386840002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:46:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DiNaJml9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4MXQB0d5OO+Xw7/ROgTp06CLIKVRXeSlRHb44daKF0=;
	b=zg97UfNhBVWV4sXArUsL1Pe09886eu9/WnqhWUsH0WgbsjIvIt+6hkuwOqZpTTGw1pkcDD
	SpZmKN1Xmm+AShBWgPFlcchaCnRvMbeUL0Ogf86+AOFuaUxCgPDCcttXd3PaL8J0cU4ZlI
	YeTj4F+PC+gWRGIbQEZDs8+TVx4Yf38=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167207;
	b=a6WeN6hbVY9ZaMy3E/3sAExkkNPn7VUabVf6otRKhhOVLHIhW+ZUsvwRDy2et5Qbk0/tt3
	Pta2pPrhDxoNKq+IUOT/QTICzlG1iLxN5u6rfERvRHHIQgz2oH1pI3pQ53Q+LSzXsmTlvr
	xaFhvOhvThRjQW9sbc7JUD/Rl/KuXIM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DiNaJml9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AB344369C;
	Sun,  8 Nov 2026 19:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8971F0089F;
	Sun,  8 Nov 2026 19:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167205;
	bh=y4MXQB0d5OO+Xw7/ROgTp06CLIKVRXeSlRHb44daKF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiNaJml9w7xbzmSGW9dLEwANh6uBGKMFncxmKnh5/u7Zb1LovygIjeicXdyolnfcN
	 1rEuoshl3KMJU93O3FTQeMj/H0kZ6/4/aVW2fq04snZ0a2oKoH4m2TdVvRq98fqCOV
	 D6xzC1t0mUrZ6xC01r9H1Vi9HkCipC7CsmyfcEm2R+Y96mU15YfdYtyR1hZKfpjay+
	 ZVw9R+rWwu8941zxQ9QNyvo4CsLVf71ocIJRGPpGVwG0qqnTT1RnAkIagRL8jjEsIP
	 jnhEKiv1W2dBga1C/6emu0QPoVLL3kQyRtjT4jaz217TOh4DvAOk2CF//GMGc+Su6C
	 D6RvwpSPLCrcQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.18.y 1/5] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sun,  8 Nov 2026 11:46:37 -0800
Message-ID: <20261108194639.115062-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203968@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8esh3ijmbg1udx1so4rmcym3w9zuzrf6
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F386840002
X-HE-Tag: 1794167206-51762
X-HE-Meta: U2FsdGVkX18hu2czOYgDI/qgnmwNyXNQKeYGOJwqoXg6XG2MhnUYkqMyvYrMYM04hLtIy5f5kWZaEr8KfiT/2fCqQ7clm/BMOE5aewEtOI6PWDcYytAsv8ak6W7nIx1umhXmv8r9Omoej7X4I3yg0riLtJH4Tz8w8TRDghtKnhx3CS0JMIwjzu0JLzUsoT3u+ymORCIn3GqZ5eZqQEIsDXnIOS+EEsSu7dr8n5MMoclYnQwnV0nEsn0tcZxkXpbZhhq1iNsfPTGdGN5i5bfdxS0j85g89Cz25J6lbFVDkJzInTRuKm4bYQc3BzI8HfXl4Sa7BJyBQc8ec30KRcYHjk+1r6mxTiYkdQ9gZCq7EJE1YOo40E6A/ktHvRJF1TYWNolKEM9eafRFhg4PX7zt6btanZFi2238Db3juj6Gb0zZjDoFg43etcKVOL9qbVNH5ZdlurlpyAFF68XXUppOb3P+k1iNuWps/5qJt6SaV/l2DLsl0fUztNEjXcBBx2xebpHlZpnsPKnoi4+H6VdL16SJFtXm5RNGS2XxvK05LEVMoHrEAuOQ0aFzHT98jKjXncZejS/odLFUN4rVfCFTiYWSnqAZcp9kdsi7ixcVq1F4VmVCerDwrTSlFZGQFFYtWHf94ZpIK0AbRCRvw0BPiylHz/p7N3Y75CY3+7Gjttyx/zIYuAHzB7v+Fw3G67yZMyD57Q+t4FoUBHRrDwiGVILGxQSV//7y6xl3lEw1h30ygEV+qHH8qrgkzTLUexJZ7onZM/q2Ukxm/VEHmmqnNwfzXM354YSHyNM8v7fLi25bj1jSC3ienLxqePlKC6JdX4Rhp9GyL0W45WpCRb0ABBfunXzAQ6vf3Gm4C+DWVf3fmTaqvRzP0iK+Ap4rL1jklHL03F806w+0PkgEVZdRX/k8AqwjA2fuKgUOZXGaGM8Fx82x1lwoiQNAaGke6BapOoqCc7h6xshTnVRj5RQ
 oZWSJMdd
 t65sDfKB/0vghHGx6TZRNhUyrAuleTHlishvoymgne1iMbt/KMqYCypqfAOHgZi+G345Ebv2ObWiYzHM9aGT8p/lhKf9F/h84a6hHG0ydw7VIFejlDAZ33KajCACswDJOlxR5DLlaitfBmVBYmX4FzYOCWEhax2TFOpwhtyGH6P/16Yr2GT+nbINWAa3geAXT9dDYkU1snLKtnKDn5i1MPjX9A2vz8FACm0IDrHvPM86tcDLXsZ+LUOMK7bPNuDqTQLmqQDfO4lL/HEh9/tT5YyfWGk7VTrMsMJHtK2UkeYOgLQ8uqu56fzjWl0+T+IAe2zKw+qhdoOc8XVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 19:35:07 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/damon: damos_apply_scheme() inflates stats on region split
>   failure
> It also noticed 1 related pre-existing issue this patch does not
> introduce:
> - [High] mm/damon/core: total_charged_ns overflow in
>   damos_apply_scheme() [1]
> --
> 
> commit 9174bd7b58d2e2acd57046175fb6abb05138bbb9
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/core: skip applying scheme if region split for quota fails
> 
> This commit updates damon_split_region_at() to return an error code on
> allocation failure and skips applying a scheme in damos_apply_scheme()
> when splitting a region for quota enforcement fails.
> 
> Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
> Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
> Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 8fa788b0d709c..4c536a9b958e4 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> 
> [ ... ]
> 
> > @@ -2000,7 +2000,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  					c->min_sz_region);
> >  			if (!sz)
> >  				goto update_stat;
> > -			damon_split_region_at(t, r, sz);
> > +			if (damon_split_region_at(t, r, sz))
> > +				goto update_stat;
> >  		}
> >  		if (damos_filter_out(c, t, r, s))
> >  			return;
> 
> [Severity: Low]
> Does jumping to update_stat when damon_split_region_at() fails inflate
> s->stat.nr_tried and s->stat.sz_tried?
> 
> At this point sz is the non-zero aligned remaining quota size.  Jumping to
> update_stat calls damos_update_stat(s, sz, 0, 0), which increments
> s->stat.nr_tried and adds sz to s->stat.sz_tried even though
> damos_filter_out() and c->ops.apply_scheme() were skipped.  Because
> quota->charged_sz is not updated on failure, subsequent oversized regions
> in the walk that also fail to split will repeatedly add sz to
> s->stat.sz_tried.

User impact is trivial and the same behavior exists in the mainline.  No
blocker.

> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can
> quota->total_charged_ns overflow on 32-bit architectures [1] in
> damos_apply_scheme()?

Known low priority issue.  No blocker for this patch.

> 
> struct damos_quota defines total_charged_ns as unsigned long, which wraps
> around zero after roughly 4.29 seconds of accumulated scheme execution on
> 32-bit platforms:
> 
> include/linux/damon.h:struct damos_quota {
>     ...
> 	unsigned long total_charged_ns;
>     ...
> };
> 
> mm/damon/core.c:damos_apply_scheme() {
>     ...
> 		quota->total_charged_ns += timespec64_to_ns(&end) -
> 			timespec64_to_ns(&begin);
>     ...
> }
> 
> mm/damon/core.c:damos_set_effective_quota() {
>     ...
> 		if (quota->total_charged_ns)
> 			throughput = mult_frac(quota->total_charged_sz, 1000000,
> 							quota->total_charged_ns);
>     ...
> }
> 
> When total_charged_ns wraps to a small value, damos_set_effective_quota()
> computes an inflated throughput and effective size quota (quota->esz),
> causing DAMOS to process far more memory than allowed by the time quota.
> 
> [1] https://sashiko.dev/#/bug/linux-c8969436-aa48-48c6-9f46-a12a64361494
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261108192221.114362-1-sj@kernel.org?part=1
> 


Thanks,
SJ

