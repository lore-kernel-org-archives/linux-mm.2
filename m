Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC1CC982D0
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 10:49:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2801D6B0088; Sun, 20 Sep 2026 06:49:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231606B008A; Sun, 20 Sep 2026 06:49:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145CA6B0096; Sun, 20 Sep 2026 06:49:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB6036B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 06:49:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B480803B7
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:49:29 +0000 (UTC)
X-FDA: 85233819258.15.CB991E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 38D40180002
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 10:49:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ikcr+qnW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ikcr+qnW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789901367;
	b=154RDhRVvx3VfMhUYt/vwoJzZlAEJOfgPKo2RoPk50BpgE/VEx+cCNys8jKxN7ma9EvXJI
	Rin/lh/m9+u58xDiIHkzBXFpe/h4YmR4Z9SKPXAzeq8wMNH4IqeyLpFgKHjP3ivAh3NEE6
	swSoufXmvDlzSIhKxrDiFvV+GEnOIk8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789901367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JicpyNhz6N3EZ+HXyuGJGE/XahAzl0DJVcQ8CuCuwiM=;
	b=qJwDs4ytFdtPFMf+jI7+C0Sbt4uVI+Oa+hh8CqRh/4pCoK5KPHzzMv4+pc/xkTOFhTZdjA
	+3Bg/1VFFPImAjVr4n4HALUu5Dqn20yA9Lns8kMrMFGd+EgKFZCq+gCHY0lSgS/vuOgTDQ
	RI9lKnQ2t24GpFGYKOnBQFHym617xpQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F3C64188A;
	Sun, 20 Sep 2026 10:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF271F000FF;
	Sun, 20 Sep 2026 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789901366;
	bh=JicpyNhz6N3EZ+HXyuGJGE/XahAzl0DJVcQ8CuCuwiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ikcr+qnWJfVqd2AgCrOOBMxrPGowMeVA+uVwPoanYFzc0rIQriUS+gZpQ0B+5RyHY
	 g6qhWeXZkgdllHuM6l1ytBBw/6iIuopCsJgKRfWDeFi4bDbWJQRlMOzfQCGt/Z9IER
	 psptqDk2r8Ot96aMNzlP2+xVQ7LuSKkgkxCPZ98OpnLM7hUKMoV+zvkct16xXcdzjN
	 tvB7ZE0zQ0hikbPrZqjnWzVXrqFtnv5zZROTr1kHkiMv5jJfQ7moCOagMO6xw+558l
	 4GBrOimDySU1V/bzeIEEx9E4NmGlmvCnv8hEiGj5fFDb/zslGvpEKwZRxDhysko1fP
	 PfsLVlMVkSglA==
From: SJ Park <sj@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 3/3] Docs/admin-guide/mm/damon/usage: document the temporal tuner's quota limit
Date: Sun, 20 Sep 2026 03:49:20 -0700
Message-ID: <20260920104921.48065-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260920023111.2466265-4-donggeunyoo.kernel@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 38D40180002
X-Stat-Signature: k89j944bsouka3u1ciui1f1k1q4eye6g
X-Rspamd-Server: rspam01
X-HE-Tag: 1789901367-500171
X-HE-Meta: U2FsdGVkX19oBd33GY8jQ7si7GEDiHECR8SP1L9Jpf56/dhX2RUQGaTziZHJu3Y6noh+ByYfNULGXZdPXzPMMMZqk6ilyVJ3jLZdQ+aT1pM65cwitHZpUBQE1xtlwSHNBhdHTYqBREy7+kimaqjPTZKuBxo4iIGQkGcamQ3Pc16r3wywE+S/X9gzwKMbpGGQmP3fUMBZT3bpG7l1oyqlVNdHiuL+GHe8OX/8+Wo+E0o79lgiV1xR6JGvqKwEjCe9w3+9jqeQpaYhcFygHHkVM01/iVGl//6qclv55XEWpFuNKJlVBfZqPzM9VN5MvhSdgq8ZNnUuD4BsaDl+EEkv5qAlLnG28Z3cCm8yVWSFDVs932EwlRf40PqUgLVMFxGSTbmzIcq63gvqsGmKvdtzXnW3g0wSaRPkZKh0eYEnf5M9/YgkxbDdzGWBG/D5pZ/+WjiIxQ3X5uyClMFRycMxbFgwA2sOypzVGZqhFq00RFoUESGrLdp4DaITf8wd28oIzPQQmWsdVnpZgmXziiasR1tqHoI7ZCgdgW1d61j6Nq8H1fjGTgvywfKT/JnvPxpmZA+/pKJG0upRBbHObzPO4Q1GA7/SYk2gfbHTtVJ4dAqYi0FIhzgUb660hSFm8Rbn4w6BSeFsQYSCmOOIpt1q4IXkV4885A2nRmjYuQ/fnMbt85uDvbdtIYBSeaBpzPzfd2lXkuZz/jTaPz7fW3clrEJnD5YkSNIdEYDAX5ssLqYDPfeaf1Cxcs/7HcOdAm8pzCzxxUVU8dGhYsnYT/lInAv7qfn1+YwZHMEQioq93NOf/9YRxP5e8CVoX2ELr7bAX1T98YEL2tEgLS7BabtSHY/7k1vu3iZtQ9afRlfxcXL48OXmESuKJ7qLN4MqVJco9GSiuwDaFBa2I8Arg0S0gOCJ458AWZess47iugNF0aQpBVQOa6L+iJq/lKY2mt3sn6Unjkkr+s3oRrp9T0v
 KzKAGwCg
 guv9D1+r3e0O67EZ7B0ZBFcRKRG9aRMihY4vYPqJypLOtWd9PxsD1J4O1cHPuSVVFGbn48oDN7HQZgGyRLpUuQJUJDxD+bFmMaDEgyakv8xS1NX3HhbzyiTu9iWaZBhEr5ko3aSgz/60rG8XCKYU4bDI1CSPVBsW6aoQfxSLx47WGUnmmev7VtsEcV+L4sQ8GOwhhvXwIijyXSYDk7M8mKV91nlrdCJcE6t9p0+EQBhud3M3pAieK5ASWSumxcCykjV1mXdURVv1iwkaMBHqLTgwz8o/RMN7aGUsb+oT05u+YtLjh8rtfNnfZ+gdMtcffqBxJYLwviConGbPEbTP08shynQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 20 Sep 2026 11:31:11 +0900 Donggeun Yoo <donggeunyoo.kernel@gmail.com> wrote:

> The temporal goal tuner converts the size quota into basis points in an
> unsigned long, so a quotas/bytes above ULONG_MAX / 10000 does not fit,
> and is handled as if no size quota were set.  On 32-bit that is 429496
> bytes, well below the "echo $((1024*1024*1024)) > quotas/bytes" this
> document instructs.  addr_unit does not raise the limit, though a larger
> unit does make it harder to reach.
> 
> Note both in the goal_tuner description.
> 
> Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
> ---
>  Documentation/admin-guide/mm/damon/usage.rst | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/admin-guide/mm/damon/usage.rst b/Documentation/admin-guide/mm/damon/usage.rst
> index ba47255448564..ea7443b307826 100644
> --- a/Documentation/admin-guide/mm/damon/usage.rst
> +++ b/Documentation/admin-guide/mm/damon/usage.rst
> @@ -455,6 +455,13 @@ the background design of the feature and the name of the selectable algorithms.
>  Refer to :ref:`goals directory <sysfs_schemes_quota_goals>` for the goals
>  setup.
>  
> +The ``temporal`` algorithm converts the size quota into basis points, so it
> +cannot represent a ``bytes`` value larger than 429496 on 32-bit kernels, or
> +1844674407370955 on 64-bit ones.

This feels like too much implementation details.

> Larger values are handled as if no size
> +quota were set.

I don't get what this means.

> :ref:`addr_unit <damon_design_addr_unit>` does not raise the
> +limit, but it does make the limit harder to reach: with a larger unit, the
> +same amount of memory is written to ``bytes`` as a smaller number.

I suggested it might make sense to document this problem, but now I doubt if
this is really helpful for users.  Given the fact that the issue can happen on
only untested setups, I now think this documentation change is better not to be
made.  Correct me if I'm wrong.  If I'm not incorrect, could we drop this
patch?


Thanks,
SJ

[...]

