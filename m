Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F8FDC88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 14:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D7526B008A; Fri, 11 Sep 2026 10:25:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6881E6B008C; Fri, 11 Sep 2026 10:25:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E3E6B0092; Fri, 11 Sep 2026 10:25:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 384736B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 10:25:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7EE97A02A6
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:25:32 +0000 (UTC)
X-FDA: 85201704504.05.061075B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CA0C840007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 14:25:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9HYc2BH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789136730;
	b=18uxhftM2wNc3k5f4/1FWZk2VaHGmT6DTl23/THaPDt6oK8dL5knjIxvphzKXqErRMp0I1
	SqK3hnOgLfU1G0Y0zh3Pe8OZ9Qd2k/pN+jYenlzi4jJ7lnpyAD57zml3WT3cJX1AQb4mTM
	zhcEHxUj4Ola4B7+t9j0VNLzPXxc3X8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9HYc2BH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789136730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UWnB1+LHCrUWvW0DYQclwKKSDqJPcdee5LBGVppRb50=;
	b=AWWfXytPnkNjkpF+3KJEfiDUHSIc7KVLGT6ue3Vn/mPt6sXnLkDazWq0pS8Yy9zaJlzZsI
	VTeAEXPbM4o2emsQuYS3f0VYJNW4jXLaFLwsDL81Y88s8ZmiUDeH67xLPJVd/ZcpXT5f44
	Y5IXXQWyru1QJWcfRgLp1FOORpIslxc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E94640285;
	Fri, 11 Sep 2026 14:25:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBC01F000FF;
	Fri, 11 Sep 2026 14:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789136729;
	bh=UWnB1+LHCrUWvW0DYQclwKKSDqJPcdee5LBGVppRb50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9HYc2BHkIpkXbRx3zT79clZlV0VQtq0mhtO0jud9OHUaUCKW+LFtATJ0JJCcLmqW
	 32U0Pjz8d6MvglKVDkLWGy3uljiLOWAhk/Rn/mDTzdAbIzRnXzgq1GSUvOdPjAx0xJ
	 PY7nU6mVO0s/lZFxK6Zi9MKEQWONuJNh+NI15nfZrEyBfEYb1g6D84ItB2Wp8S5CPy
	 cfsng1L4wIIEJuKkSYKVgN/TMeK8Oq9BdGc1loa2bh7Y+EmslWSJsWSMKftIUqTjrg
	 ZLMyJVomRZJwstJ1eG8ZfasXc3rYGoipzquGKR10h705ZSFgh2oxxw9qK6+ULvZRk1
	 2uKNsxiIxqPFw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 1/7] mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
Date: Fri, 11 Sep 2026 07:25:22 -0700
Message-ID: <20260911142522.98013-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-2-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CA0C840007
X-Stat-Signature: i8crxdjfm676now5b7kmk5op18z9sa9g
X-HE-Tag: 1789136730-500215
X-HE-Meta: U2FsdGVkX18au9MfZKXibQA5xBFiBE3ZKfBci6QHrp7Ns88QBYZTVXCQAeWaTNVMD/yZg0ZjD95HOUCWzX5am79ybDPC8yXZWZdmlm9aVYwBUmS+1O42z9Y7VjyHVm97+tGzPLeukW8TKXBmIwTd2IPXR7TDecg+QPXRkmnAwMd0Avzkonp3PhfWRDOJ8wBnvRQ3VWo8cjhpCTMvOI++hK79AWSWNUY/MzqGfqQOTuybg4qGeSAZdnO2Iy6gUJs+jr4GbiL+g6TqLc27HNGPw6MIhS7GnGIuKyv3tyzMe/q+i9wV3VJXmC1/8lIswh1DS/7cwl6tAs6Z+pv0ofRQnV5a5KAfSRCsB39gc8qLdMvBkrDchLGTYTCoT4etYOL5RwEOnUBkKuqIfCtYLCFnjB+sxsYcMjGqphCk4sBApfu+S6hsPEjeHnqvvc5WofFpEBnzFNXCijJu0ZdhgKEBlxhO+EdRbth6ZFN6fNGu7EgOffVF/FirXVK9Dq7tizUlrOrMfJLrQVorFvd2XEYrPzXBWU2BcZn5opMxAeor5R2P4kDvwTnlEW6XXk2kyrwaD/DeHjC50fmhvmnZmGOs6tIdCEnFUsCf6XCTY/BCzjbmQXGhgu7OxdILoWGuXkImmtJ6R9D9ypAcLmUhcJstG2l9G34r1cqgFhIOID/L6/Llni1C4PAheAkU8Ud1tQd34aY13lgs+IBf6mlae8kFpBUGm0GitvVvtC+WKb3PGDdQU2B7KHGgpTICKkjtk2tV7kyuzLq6YMUl/MJeijP1pO+qxK9xdxSt15yKYB+87p8kxNIJI8E6NcLtEdKWW9q3R3PWSWrrCHh05FRofPAk6sBE/aUaNH/GrF89jLObIFy8T1fGjdDN5cDVCTIbUuhvlEWX4n5YtyeyvpmkzJmaEyOoe5cyRapEhsP7y06CXfOEUKIZOvAVqkQOuUQsjZs8HtpEBkrwvx/TdpWQpnW
 WAQhoPC4
 aMidtpIJ4qI1GfKASupzE+ERcCLvARLf5KubxwlmFMnLO1KG2iu6jYWLMqAzkHqC/pjXr+D/0n+N4ZRrgXeJ2LYAfWXbWsyXfU3LfGaGGRmCbCGcRT8yL1cP4lyz6Ror2jhiE3BWKucDk5UqUl1EwFbSjibtFRewsK70aO7lI88iotjxltxLxZZfKGknZePdAaKePGfI+/p77plukIURF2XP7jQpYy6jK95sZ1Bd4FCZuOVB1jEKP86NFoPOAZHAjU0ANneBVwlUXvRpEIGebx6H54A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 06:55:03 -0700 SJ Park <sj@kernel.org> wrote:

> Update DAMON kernel API to introduce new DAMOS core filter type,
> PROBE_HITS_WSUM.  It will allow API callers to describe the DAMOS action
> target regions based on their probe_hits weighted sum.  For describing
> the filtering target weighted sum range, add two type-dependent union
> fields to damos_filter.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 16800b3dc379b..9e84bdeb5616d 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -399,14 +399,15 @@ struct damos_stat {
>   * @DAMOS_FILTER_TYPE_UNMAPPED:	Unmapped pages.
>   * @DAMOS_FILTER_TYPE_ADDR:	Address range.
>   * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
> + * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
>   * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
>   *
> - * All types except &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET
> - * are handled by the underlying &struct damon_operations as a part of scheme
> - * action trying, and therefore accounted as 'tried'.  In contrast,
> - * &DAMOS_FILTER_TYPE_ADDR and &DAMOS_FILTER_TYPE_TARGET filters are handled
> - * by the core layer before trying of the action, and therefore not accounted
> - * as 'tried'.
> + * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
> + * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
> + * damon_operations as a part of scheme action trying, and therefore accounted
> + * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR and
> + * &DAMOS_FILTER_TYPE_TARGET filters are handled by the core layer before
> + * trying of the action, and therefore not accounted as 'tried'.

Sashiko found [1] the second sentence is also better to be updated.  Reposting
this patch only for the trivial change feels too much to me.  Andrew, could you
please add attaching patch as a fixup?  Please let me know if you prefer
reposting the series.

[1] https://lore.kernel.org/20260911142049.97838-1-sj@kernel.org


Thanks,
SJ

[...]
=== >8 ===
From 8095628debba5ececa0664314ef4a3b777ef0fbf Mon Sep 17 00:00:00 2001
From: SJ Park <sj@kernel.org>
Date: Fri, 11 Sep 2026 07:20:01 -0700
Subject: [PATCH] mm/damon/api: clarify DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
 behavior

Clarify it's behavior.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 33929a400aa7a..23df189015198 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -440,9 +440,9 @@ struct damos_stat {
  * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
  * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
  * damon_operations as a part of scheme action trying, and therefore accounted
- * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR and
- * &DAMOS_FILTER_TYPE_TARGET filters are handled by the core layer before
- * trying of the action, and therefore not accounted as 'tried'.
+ * as 'tried'.  In contrast, &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET
+ * and &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM filters are handled by the core layer
+ * before trying of the action, and therefore not accounted as 'tried'.
  *
  * Support for the operations-handled filters depends on the running
  * &struct damon_operations.
--
2.47.3



