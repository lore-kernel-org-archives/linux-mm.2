Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA440C88E45
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:55:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA566B009D; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2CB56B00A0; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A95116B009E; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 632B56B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:55:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97EB18024B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:22 +0000 (UTC)
X-FDA: 85201628484.26.B21B2F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0890F80006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:55:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NU0P7Axr;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789134921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6W4HqJKZTtS8lrUgM9flAHj2CUZu3m4em5eZnB2Nzv8=;
	b=QzOraaGf9CowI09Qcn2tIZjadCO6+D/sowsTJMFHWxbt6NUZ6pnNzCBg5r/RYJK4FlrGgt
	8bccnxxK6GBqq/a7SVGAOQyjnIztwlr2i/L75regOUmGAGLkluBlGupm5X5dpXwdhCjKqh
	yDJgpiCSt/ouVQk6AN4Rmv9sbNRM/pk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789134921;
	b=S4J9yLimvaBKIzA6ASPR91dOASFtuK4txgmr/zkqNtTG3GPl+JNEKKBdPU5N8wDj3C77So
	YbEHLqV/7HwWeDPMvBvDPp4Af5PNEgnHXGT4+28VWvNQjx3ZYkfAHJfpgZctVKNXgSISSj
	eaEIbJOSKmYFACa6c7ADiQ9s3QhNbzw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NU0P7Axr;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 968DA60A64;
	Fri, 11 Sep 2026 13:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261761F0089B;
	Fri, 11 Sep 2026 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789134920;
	bh=6W4HqJKZTtS8lrUgM9flAHj2CUZu3m4em5eZnB2Nzv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NU0P7AxrYc+voy7CArjQOzT031tyquUxRxUaXq91eK1BFeMsptWJjuHqwA1J2bp+V
	 SR1IP55BmRk4qQG/4RuFK6592fScGB2LpUDAF5IS+D1jbftjeI7cwvLDVJMCl/RgNi
	 DEewYwtF57tb80a71l5MQH7WS9uQT1x0bLcOsQIUmC/MC2vIMcRK6xsZl5sTc416ic
	 sgNrTe8w26wFHyjDa+g+nzPl+z2SjbncXkfk4cgVfxcPkRkKA8oSD051s00MePEXwL
	 5gsoD492CpL41HcDSBBexUCV7vjf4W+1UojqMH+ahI2ksmVF+YTYcA1zU/Z0i3pGDd
	 ASeu+Pgx0PqIw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 5/7] mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
Date: Fri, 11 Sep 2026 06:55:07 -0700
Message-ID: <20260911135510.96914-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260911135510.96914-1-sj@kernel.org>
References: <20260911135510.96914-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0890F80006
X-Stat-Signature: 13n397txxqkbaubwocy3p4fmkgsn6my9
X-Rspam-User: 
X-HE-Tag: 1789134920-542707
X-HE-Meta: U2FsdGVkX1/aTPu3p0IDGyOxyrf9F8bm8opdwBibeq7uoK+qAtg6+ysnVdkdkvhakGv55PjHTODh8rivDZecjOJRrkgxyH4z3QIKo0LE/w0E2kcKuJ4TNYJWFh84TO4cJk60divC0KnLGJq6iRGoPIhBXTsMW4wbKjzajZApFNUgburKDZIIK98CCML7afSLzemiBwtRTb+N1WsieBYO3dQtsi4dYMU9SRnHX5in44MVngn+yH4tSXYDKFOPYivjucTCOyqoui1b0jVc6iLTdiHFWPFcsdO2rwPmNdU7+LfNMPFKLDQ13ZNT8rA2d337Vv0r+TM9Rqrn143k2FRt6Fw0uaTDiCo4Gy+//bdDLXkOf8GQsWHEiwOES7dkfqmvq0VHLFkmqEBfAc3BiVS6oDkwR/GbDUqWIROgXckaj2XcBWxIUMewY5bnQF6bbb9g57eZQzLYTW3VbVK9Sdn32TecX730gcqUwW2I40xEF9DaUXCmTCPwTKOrPzER6tvnRHTtVdL5w1OKXQ0dcuyYhSp8s1NWdBmcTFTc1oFD4JnHhNwY75DSlfBPRMxxZI1AsK2f0fceDU0+fVgF4JYBo8N+6ui4OqVDiCgn3x8lmpMWMkVZCxdib0dexDGJgTl4wWgzUgRl9OrRfJX2+9FFGu4Wjfxgv5lQBLFlSAIORC+Ibya3qAefJYJMneAODDN3E00ALe3ozNL/0yOVjoCrH5ouUVg69FXTeYrUdKqR3C2TCGDWWM47ToDaymtMzFgjEpTru2DyCYRqzhRJeigZ40zKzSciQQ/4gv5tsDPEzUaDSvaMuFiyhA/kGyvP/3HZ+QJO5xtmR4oZpAysyVsoZm+YgoLO2OTxT/Wq5wKvLUDli8LxBTcce/gUkInycGyPX1V20mhncfQkW/LTz/3wUhT5IiB4uDKOnfTJOELf3RgnaLY9lBR4I1NUgU+pOfLBcqSWpWICegzg3C3/1pg
 dCWgwEje
 uJ9sgR3rBdmFDj4C0AUY4drxZIR6oNcAY1kvcGGWJRsT1xpL29RWUp/FklhHsXt0zwVy+atEyLo8GLyMZg8AodQhFa98XGcduOdP6XiJxjjOwQBn/UShhGX5ZEjut/C9SJa8E4qdaRWBiAF7QNmMlrxs0lvEUS/eZ/4gQtQ+4wMHMgrBjz38s1FBV5ipBpm53y0XOMWNzZFcrmPlAjdA1J8MRTJpATc3VUIzXJU4AnMc5Y9vwTO8WnkbbmYh4FoDgOkCtNioCiJEBbI6gj1clvxhiIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support probe_hits_wsum input.  Also
update sysfs input based scheme build logic to setup the min/max probe
hits weighted sum range as user provided.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 4d9147d2a269e..3de4d804e049f 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -589,7 +589,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
-
+	{
+		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+		.name = "probe_hits_wsum",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2844,6 +2847,13 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
+		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			filter->range_min = sysfs_filter->range_min;
+			filter->range_max = sysfs_filter->range_max;
+			if (filter->range_min > filter->range_max) {
+				damos_destroy_filter(filter);
+				return -EINVAL;
+			}
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

