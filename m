Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DE0A10F3DC8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 02:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DB66B0096; Fri, 27 Mar 2026 22:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F404D6B0098; Fri, 27 Mar 2026 22:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56926B0099; Fri, 27 Mar 2026 22:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CFFDB6B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:30:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C1885F76E
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:30:00 +0000 (UTC)
X-FDA: 84593891760.26.777C992
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B57641C0004
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:29:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OqawpK+/";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774664998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7cUyENVu5MYdDxHW4xQ7I+HKzYgey048X3SQy48A9LE=;
	b=IOMez7HtY9C8xTHCb4WyDT9K94Fw9lsbDU6b/8UoCbctSxETY/i3ZxzHJ3rA4ccXGhJTuT
	xmye9YsFwA115hqUUrYXCSNsUICCPBYAT3HQnhQJqTHbHODUwcQDNhdNBFnw1T64FrHvGI
	UGMh6xbi7JD/2fpjFvGHqdew2QGhqXQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="OqawpK+/";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774664998; a=rsa-sha256;
	cv=none;
	b=CvB3ZSJ9qK2JJhfPjk4cPIJeRs5fwxRYKOyIgL4x0eRhz01d9rng0fEPs3Hsy5y3ITZuE7
	sv1q6ya/i0bX/hABKCpcJCrWDHUmMTeEHOUZzAAzqAe2zBwaYt87dMV/rIvZC4KkiNOyn1
	S2cLARpg/8CLiWo7cbie/Wo+tELNpxc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A4FC44130;
	Sat, 28 Mar 2026 02:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DE7BC19423;
	Sat, 28 Mar 2026 02:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774664997;
	bh=bqKBVgP0GGKpU0TaTWYEwXrufG6jKo1LCp5yvqXfj/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqawpK+/SGjuCXHUlp66L4kMt2l6aphRZIb86IfgL+Q4msKLilvBNA44o2k/R14wj
	 QPOBjd5EpwRnZYYjwIkgckwuWRgjql6ZsYlQw4bqGCi/pAM21nPkHMrewRBGZGZ//2
	 C2mCimvMmGqENeI5QlbVAVYt6cYl1rRHr5mfNWTllBd6HOvnfGrhKuREe5gFygVUHE
	 S/aFkpXGv2x0cXyNbHgxqynIvIYspwR9/PT2FyrAhzAESqwQxCY/ADxUQ5VXT35K4T
	 0BHvUi1e9QwUIrSWYAJOjrYOEth55ALeBDdEmPyK6pgv1ISanWHHS1UZTygtXgxnrI
	 ZmmIW92P0D8DA==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 1/2] mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp
Date: Fri, 27 Mar 2026 19:29:55 -0700
Message-ID: <20260328022956.8415-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328005412.7606-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B57641C0004
X-Stat-Signature: 6jsr4nkij4c5j4rrdbza94bc7jqmfshb
X-Rspamd-Server: rspam06
X-HE-Tag: 1774664998-569559
X-HE-Meta: U2FsdGVkX1+h48pF8KUNcSmaUd0bZQ9RPZ+JXZp1G/MXs1/JxkegxhpVE6jCDPLrVB626KLA2ToYm/lqOM9r7JGaK7U/Nq1R64ik+wxgguZLQJ5BmFqfaZbfXZ2t4fghSiiUEHr7IqpdczlA0cxWNYUBfva5IwiCekMfhbYdqo3rHHDPwYGw13+YQcEZadFtTHZByzBmdrBMLjFsjkz2aEj7NGDBBLhD6teXReSzRdzC9M4Mjv2Seo/zgfJGzkqdkhEORdu1Yg1Rf/TnrTtc+0DOhllgymHQ5slWmdfi1dkhH4iXWrArtilTNe5K+wkmmY+4Sg8mtWlmqYil6i7a5unhDU20UTVfkp9GX0VuyZEJJuneidBylKlFZjpuexhKIAPyTsTUVvhlgBzzH6RQukQ2MnMW5iKtU8n4wmmyI80X4Rnqu11K8CmNuSujRLWDHaWRvtO1oT4UTTabl/Xw/fLqF15quVJXvp36SIVk7+Uw61sUEulBw73mX4Qjbc50oz+eqrnBsENCzqN3bTQWjiQ6SU93IivApW3HubDVkgeg5dVw5og+i9TvGnZRCc4n+Flf84NS9WqEjlpFy4XHSsGKmTu57SLKDrBRl4L00IgKS8LGROzlqnIZdDvQoIYJOoPUWDFZ6pD6yhPt4rBf/64cs6N635viQBA7oFJGgB3+uZlOIJ+LMFcbtJ1Lila61zwV30nXaED+u9ULDEITq4yqcKJQ8b8rPgGnqO3gD3ZaW41DVDDKY9CdRI/7oE21cbZpmTfVIrHYNNcQ6S7kHMjeWRtAKnf/4Ym7GYw7IsWzkmL5E3qvNl6DRANcDm8nmAZcTWvD3Y5hG6xjN5Fj+CM4OzvXt3UTPsFUKP4vJyZUHUsUv6AMxqRpgrUJMs1lSd4wIGyVTUehEBXdKndS5m9q/tWQfVVWWuWbr5oVb05HpFlJtIxCqueE2xWGum/YGnIkPLVBNSg9J1YqMk2
 vFMuRK9Z
 VfvtYJCT1tK6JvhBr6Dib5ALb8eFD01xN/feB0fxTVzpxlV7WIO6LEiHYS5be31MhbSMrBviq2q+81H8U8uZoiuTcIlD8ln0KulGPtAjdKGdjdJsiiyU7wd2h0D0gHMQkyyDLJXDolAO6Av0xq1MA4MX+hiCEzEYhITCJ0gcT9fj2GxZQeFdBegVNspP9sX4IR+pDHUwYGZgbNVW0mXjw/5Oh4OAqT/pNwfpqpWE2tqGY84S7Jif75aLBgP8/1VxR0ivlWNi8XxzWgkYLouztUx5tBT0gKHmClBxbxZDjthI53Fz254wiS95a4NYOYPGuQQI26Zqd/epnKgHaN2FESXjO53o4OyEOP91uR5DVuDtd/4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260328005412.7606-2-sj@kernel.org
# start of sashiko.dev inline review
commit add63112781ae04626ae6cb9bce55a85234f6e49
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: validate damos_quota_goal->nid for node_mem_{used,free}_bp

This commit adds validation for the given memory node id to prevent out of
bounds access when calculating node memory metrics. If an invalid node id
is provided, it defaults to returning 0% used or 100% free memory.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -2239,12 +2239,24 @@ static inline u64 damos_get_some_mem_psi_total(void)
>  static __kernel_ulong_t damos_get_node_mem_bp(
>  		struct damos_quota_goal *goal)
>  {
>  	struct sysinfo i;
>  	__kernel_ulong_t numerator;
>  
> +	if (invalid_mem_node(goal->nid)) {
> +		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
> +			return 0;
> +		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
> +			return 10000;
> +	}
> +
>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
>  		numerator = i.totalram - i.freeram;
>  	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
>  		numerator = i.freeram;
>  	return mult_frac(numerator, 10000, i.totalram);

Could this result in a division by zero panic?

While invalid_mem_node() checks node_state(nid, N_MEMORY) to ensure the
node has present memory pages, si_meminfo_node() sets i.totalram based
solely on managed pages. If all memory on the node is reserved, i.totalram
could be 0.

Additionally, since the node_state() check is lockless, memory could be
concurrently offlined after invalid_mem_node() but before si_meminfo_node(),
also resulting in i.totalram being 0.

Would it be safer to explicitly verify i.totalram is greater than 0 before
calling mult_frac()?


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260328005412.7606-2-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260328005412.7606-2-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

