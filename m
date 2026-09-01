Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A9BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3567F6B00A5; Tue,  1 Sep 2026 04:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 306E26B00A7; Tue,  1 Sep 2026 04:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CEE26B00A9; Tue,  1 Sep 2026 04:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E26326B00A5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:35:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64A22160171
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:35:10 +0000 (UTC)
X-FDA: 85164533580.22.49AED29
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id A66B520002
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:35:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O4JL6jpa;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788251708;
	b=ADPYVPWs7zQftCWQQORivlR+T4dq0P9IcUZqAjUzYfrhkSlpAU6hx5tXHGUS6rKwES78yd
	8mpOa2WIZTHjoOoibigtPGX5WnaLGtSNDWZYwrHLsPQfW4RGD9ZgBDGnVg/vY/PZf34tVL
	kfmdaEwbAidb9wyk4jFH4/K02AVvAa8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=O4JL6jpa;
	spf=pass (imf13.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788251708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vWmDuGu2C8GsQhqeiaROh/RTcyLd9b8SuD7Alh5Ou8I=;
	b=0Z7tcqYzVofXD1tvNc/3Z8CBLsC5jq0OXlhl1ozz2nnaBDxK4zKNXoLDGfBcU5r+GuVJ9o
	aNiq711YO6R8PHX6PSVYok/YgmviPEmXcmNk9npuoutLlvEnP8pNwqPuYkxxSkIMz0hDkd
	sqAl3cJEdfQMrN3UL6MpiVbfHHtw5oQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D6513143D;
	Tue,  1 Sep 2026 01:35:03 -0700 (PDT)
Received: from a081061.blr.arm.com (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 00C053F882;
	Tue,  1 Sep 2026 01:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788251707; bh=GvLjJUcXhtcVH8wJW846Q0j/NBaak9ZJzUMfNxwi5y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O4JL6jpav4DOxUbUtj6dHl9/2XGZ0dy6ktHBRQzd6qiG/7S+BKcnt/QSqp+AMtziH
	 W6KpXsJBUyv3fP0pZav4p0c2jn26hAQ52OjbFLADmdG3oSviStp10QcfnbNiMZGwmG
	 XjPlU1KItQWTnsvW0AZE7qcUrI7KWI+rGIj410Ws=
From: Sarthak Sharma <sarthak.sharma@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: [PATCH v3 2/2] mm/gup_test: report actual pinned bytes
Date: Tue,  1 Sep 2026 14:04:52 +0530
Message-ID: <20260901083452.115365-3-sarthak.sharma@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901083452.115365-1-sarthak.sharma@arm.com>
References: <20260901083452.115365-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9auxw6fix9s8awac7jeo83pq69ire36n
X-Rspamd-Queue-Id: A66B520002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788251708-420881
X-HE-Meta: U2FsdGVkX1/K0GVpXrAnaBcAofRuwyQ0BkpFV82lhK5gVYTYK9VWcW9Eb6c/L/0JTUBSAGdG/SiY1p/xUClwuOatcz1WL+Fh3j+bZ08eNqj8Sd59f6XPEo9eTOg5lMuS4tJn4kEWn+3eMpqMeZxsvlewcFiLn2M+PX86bpS02wHI5F5+R7V6t4KIeTbMGsaGHPBoaNR/GFPyODndVGiI6AtEqFS+6ZhTEda9eAmxeQqtDbSpU5Osj6RTFRPbR+PSyFJ+xIammkfJt48v2LI085/3OhqWiGl5nV4younwx+id0Rvjx1OgDkRJgn+Vyyhf61fvLqCdwCaQeXJ1JyjgkN7XhpB2s4IboN9bSniyiZUAmwhAXIwVbT75lrGRrjijcvldEdjhsItULiTUpJilFtsicq3pqWaRv0UaHH33Ng0bCVByaZOvwVtA2CDoPaof9tFKasOXCpidSBjWKo9NdxtkMig58uXrUz65jQ24tPK2TlBWNnYVhQfAy0gD8JC3IX5uqk5BnNz0fGyrQr3+7yL7ATnJj/7SZOBzkLss3BgXlW73UVFU57O/+H5ziDIN1GaolLloCYEFyk58KcPpoN+/UTqsVjSYnTUidSJ3/7rMlwEPqJez2gnWgTG4M3TLtss88Xkw3YLukbWr5BPSt28k3IUc6EYbqlhSToTgAus68ecxtd1zlcSVhMKiu3Ds1kzfVufWUwjWrNODVdkrj3S8YRB/XEzgh+L1HOetJR8iYV7j1Lgf8c9rcnn8ffOpFJSjArmWZ9gorJF44vz3R504IgpUswRm/TUhGL8QxT5Jzgz9MCF8VHh+ZitjMdJqkto/A07BGKpGHVy+mfDBUW5ZlhLY/cAPACoEo7fhlCjcodDap42IKJVzLB101cVEa+RB+enq87cghKGc5QFVuMRyP5wSEpezqFIvxrlC1HRCVdMTZjF/9mHNGenzfAowKv4wpNoV22HdunojjYd
 gwuI4gNZ
 JjK7SSrO0lgxs+sA9zc7iBaNibH8sZhu/S/vBPCqnU+XrAnoJSEYB4diD2OlzEiWOpIUO6iVf0bMjzl2FgJz7h/uJBHWK7IYtB/RBbySHfFzQJmmTIX+YqWnfKnfRtvrT53AtARSyQwRhSZhYK4RSC10qa0RUISl1PgHkiKLk9uaXwYqsasdAilnk2FXeWrmiAQZrGzAIhBepdOOWHG4gl96DoA6wwwzYZ4FAB6rfDNBghd0TfUzeUAdmgoktKiyPOI7aYQTGgmdCrFl8EWBznqxCyR17Cn7NacLZM+fi2waGS/00fwZIX2+QZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__gup_test_ioctl() advances addr to the end of the current batch before
checking if GUP pinned the entire requested batch. If GUP pins more than
0 pages but less than the requested batch size, addr still advances by
the requested batch size.

The next iteration detects the partial pinning and breaks out of the loop.
Again gup->size is calculated using addr - gup->addr, so it also includes
the unpinned pages of the requested batch.

Calculate gup->size using the actual number of pages pinned multiplied
by PAGE_SIZE.

Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 mm/gup_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/gup_test.c b/mm/gup_test.c
index 910cbef709b4..b72f59a89c1c 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -189,7 +189,7 @@ static int __gup_test_ioctl(unsigned int cmd,
 	nr_pages = i;
 
 	gup->get_delta_usec = ktime_us_delta(end_time, start_time);
-	gup->size = addr - gup->addr;
+	gup->size = nr_pages * PAGE_SIZE;
 
 	/*
 	 * Take an un-benchmark-timed moment to verify DMA pinned
-- 
2.53.0


