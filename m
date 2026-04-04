Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F18E63FF8
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 20:46:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4206B0088; Sat,  4 Apr 2026 16:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1845E6B0089; Sat,  4 Apr 2026 16:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A3D6B008A; Sat,  4 Apr 2026 16:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED2F36B0088
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 16:46:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9623713BBF2
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:46:41 +0000 (UTC)
X-FDA: 84622057002.11.45FE90B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0E1C8C0006
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 20:46:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jr6NkcAX;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775335600; a=rsa-sha256;
	cv=none;
	b=6EetUV2bQj4OE7x5TxtIYMXW6OlXEBA97TjFAxAZPiP0rpn/Zsvc+7zBBt0l6ztvvz03mh
	Bbri8aoroKS/uvtrISv+2sjtdArnpGMZb5/b1ZIk1bUoqBjtx59PXNF7yfjVl0Tl9HvCBf
	1nwoumZKFEeDGsP3vtAT/qEbBsK2Nqs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775335600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mn0LyPfwipRufIZF0xtYAgIwZ5iSBV4GygpXoFoQ6zA=;
	b=UFInIZcYIQkACswAs5H8fRP9SHcvIXL4E4oX6W6B3k98+S4TOMoCTW90yeCo+CirEH5uYM
	kVvmz5DxqXqWabTWDwwAVcgSttMpUxQm4iPXBx35A1/mc0JJg1hvisWkmaWXhLaAtGxwTT
	fF+K7d2HKs1zcfJrEuzMMjj1euZhM/k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jr6NkcAX;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E6D160008;
	Sat,  4 Apr 2026 20:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029FBC19421;
	Sat,  4 Apr 2026 20:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775335599;
	bh=6GEw/iIRX2vINOzRBZ3YUzKWU86XOSxMizIY4SGJ5bI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jr6NkcAXjAPrvjLqWnxTPge4Drw898+ubhpIP31rdJX9Oo/nED0eLm8CFupNM3UNM
	 PhIumEKc8CZOUTA4Ev8KwpFeL23XrvCVas2sz7h3ZHajeDNPn4TyyQHyYMKyrtKQ7k
	 OkIyykgs1hvhXTqkaDfxF0INvNhTVjSlsIm1ExNuJSQRBFX5MvKOlSusQtsq7CZwEp
	 QdAVIc1U0t6nBwkMan5sflw25KOvOHYZF20RjLfrnmUjVp7iFDzLiBIROveHUZCQOw
	 zKdmnO5Wi+/2DXT+kAI2DZX+/DWdXUq6RmwMxg5aSyJlQALATAvYg2EcITxN0jmeNp
	 voViktedxF8cg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 1/9] mm/damon/core: introduce failed region quota charge ratio
Date: Sat,  4 Apr 2026 13:46:30 -0700
Message-ID: <20260404204631.86853-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260404163943.89278-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0E1C8C0006
X-Stat-Signature: wm5mawk4rsnufy4798k6oe4xsiktixxd
X-HE-Tag: 1775335599-142474
X-HE-Meta: U2FsdGVkX18TqykcvHuwD0jShURoSlthEqGRKlxS7liJ+w/mbn6tF4X4sZp7Zy9YhrsPttQY0CCBQ88M+Md+bsn3SraJmS9iKKbREwb+yrRKkXM9ebbr80CFwzy34XIka1485oXdRKL0Qm+FDBAO3NGNjZopj0bNBp0sugS5jpT9RAj6fMCnG0/sgHb5K62mhLrLkLADEhvhr1LLhkWioq+OmETlvfIhbs2kPscMWQVvRNzGowVv7zZlUi6ESEwKZxS6fQSrGDePZlpOow1o8Tvt/KtHcyAZIsfBuB6MlwWX+ym5juq1i5UU4lCGZAwQOrO3ZM47h30Jxj8/hyy2wyfmSRB+D6jimm6oEDmS4Fq6fscCJ92GsVCJr+N++CHDohPuP7Ixn7RdUfTtP/iOSXB51M/eEk5pSawz/iHvfH+mtOk8qgHe2yhh5HL0+I3sd1NOudppG2NBUunlF69llpb9f3htElwEjT7xCjhybiibe114ibPTO7SB3/Ie+nly3zBKGA8iDzefW6vv6bai69DFSGfTXzDUTjJ/ptOhx97+67/9Nuw2AFMqy/fgLAKMQAlFe4Fpgme65aKGmn2pf0refuIkv4ohoQ3hE956X8pz6sMGbVnaMmBlUvuSxgzUBZJof4qSzmOzoSH1i+po82YdlaGRgCYUC7LNkdFlmYJZ1AVBXNDkhEEFwvLjMMAx6/EvUrQIsaZfCx8ObLjOrojnDrqb5lv/2MG5XBe7izCThrHcFd7OmIiqb6w2AuzIef3JQfT3tsqIxIQ+8n/GCqQkJLrpAzTB7L3TYa1HyYrbTzcvqRkeVupka6HQMTytTFBfkaIMwHNVt/yo8Z7N1sskd0UQc2hD5yfSYXtKTLlTuX5mLfb+6VY0ZmKE0jXrIhG7C5d5lJB9QCROQmkCGjfaedx/sWVgmB0PkmtiomO8j89AqheuFhUtAPgHQb8zhzsA8RuvvRDgYjnGk31
 8W3p0KNv
 igbH1k0/Yx6QuMaum954pNjdMLfQJnC8ItEpZLca+Eum1zHLmhXA1/L8gwJ+yJ9l1NVlmh59rgtGhIFTbpgrOMakhvmfWWyb+3DE0P5qP8Jt6LetZxSbnJWGt6WAIimthHd1UVAngb1rS+i+krI6g6+1GMjC1ZZVJdd0AWmGs+P8759KmC1pDp8aCL9CfSsglMIIetLEC6A/KDtlg3wERem0+rbL3yAOiTzUH6J45fIEkLQYFyfPkX7M70gHsEueDMjXwXk6+Eq/IEGH1YpU6k43rbzu9RbBmwDDMrp6bWVTcokMRd+7/t5jE1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko found an issue that better to be fixed.  I will fix it in the next
revision.

Forwarding sashiko review in a reply format with my inline
comments below, for details of my view and doing discussions
via mails if needed.

> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-2-sj@kernel.org
> # start of sashiko.dev inline review
> commit a0c4b65226ecf5534b53ebac64430db94a861d2c
> Author: SeongJae Park <sj@kernel.org>
> 
> mm/damon/core: introduce failed region quota charge ratio
> 
> This commit introduces a mechanism to specify how much of a DAMOS action's
> failed memory should be charged to the quota. It adds numerator and
> denominator parameters to allow flexible charge ratio configuration.
> 
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index f2cdb7c3f5e6c..df7b0340965f9 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> [ ... ]
> > @@ -276,6 +282,9 @@ struct damos_quota {
> >  	enum damos_quota_goal_tuner goal_tuner;
> >  	unsigned long esz;
> >  
> > +	unsigned int fail_charge_num;
> > +	unsigned int fail_charge_denom;
> 
> Is there a guarantee that fail_charge_num is less than or equal to
> fail_charge_denom?
> 
> If fail_charge_num is larger, the added charge will be greater than sz.
> When a region is split to exactly fit the remaining quota, could this make
> quota->charged_sz strictly greater than quota->esz?
> 
> If so, would the remaining quota calculation in the next iteration underflow
> and lead to corrupting the damon_region boundaries when splitting?

No.  Existing charged_sz vs esz comparison code allows charged_sz be larger
than esz, using '>=' operator.  And when the next charge window starts,
quota->charged_sz is reset to zero.  So I show no problem here.

> 
> > +
> >  	unsigned int weight_sz;
> >  	unsigned int weight_nr_accesses;
> >  	unsigned int weight_age;
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index 3bc7a2bbfe7de..f468c0257a3ec 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> [ ... ]
> > @@ -2097,7 +2099,12 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
> >  		ktime_get_coarse_ts64(&end);
> >  		quota->total_charged_ns += timespec64_to_ns(&end) -
> >  			timespec64_to_ns(&begin);
> > -		quota->charged_sz += sz;
> > +		if (quota->fail_charge_denom)
> > +			quota->charged_sz += sz_applied +
> > +				(sz - sz_applied) * quota->fail_charge_num /
> > +				quota->fail_charge_denom;
> 
> If memory management operations backing apply_scheme (like damon_pa_pageout)
> process whole folios, can sz_applied be strictly greater than the region's
> size sz (for example, when a 4KB region overlaps with a 2MB THP)?
> 
> Does this cause the unsigned subtraction (sz - sz_applied) to underflow
> into a very large positive value, exhausting the quota prematurely?

Good point.  The premature quota exhaustion should not be a critical issue, but
better to be avoided.  I will fix this in the next revision.

> 
> Could the multiplication (sz - sz_applied) * quota->fail_charge_num overflow
> before division?
> 
> On 32-bit architectures, or with a large fail_charge_num, could this wrap
> around and result in a much smaller charge than expected, allowing the scheme
> to bypass the quota limits?

I will use mult_frac() to avoid unnecessary overflow.

> 
> What happens if an action fails, and fail_charge_num is set to 0?
> 
> Does quota->charged_sz remain unchanged while the region is split to fit the
> remaining quota?
> 
> Since the remaining quota stays the same, could this cause the subsequent loop
> iterations to continuously split the remainder of the region into identical
> small chunks, allocating a massive number of damon_region structures?

That could happen, if that's what the user intend to.  That's no problem.

> 
> > +		else
> > +			quota->charged_sz += sz;
> >  		if (damos_quota_is_set(quota) &&
> >  				quota->charged_sz >= quota->esz) {
> >  			quota->charge_target_from = t;
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260404163943.89278-2-sj@kernel.org

Thanks,
SJ

# hkml [1] generated a draft of this mail.  You can regenerate
# this using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260404163943.89278-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

