Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EC2FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 01:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD376B00AF; Tue, 30 Jun 2026 21:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3571A6B00B0; Tue, 30 Jun 2026 21:23:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E386B00B1; Tue, 30 Jun 2026 21:23:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EA5936B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:23:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9AC0B8938A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:33 +0000 (UTC)
X-FDA: 84938460306.22.797BD7C
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id EF523A0002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 01:23:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mhkF7e+Z;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782869012;
	b=Qld5K7wFUwwXKlrj8rD1u+lQeJFhwPhqAHwJx1sZS8hRqGC8XUEqSklpXUkBBJR3AYBkWo
	sXyqH6pysDF593olYqRF7m91AEOrunew9dB97SU5LE9iRVHOeE4auKBcyrcQ3ovuGFST7p
	2u2uxpMWrnxlCSmSbRV4IMGRMkFExRE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782869012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=FfArn+REgmXWg8sc8KOMEX63/6e0YCZ2VRJaPY1hz6cdHSoYGqgKfIpi8kS1SyPn7isDtE
	98tvs2xWSiB5BbRou5UzPA4LSz6F5ZC7kHbMPkTfTUCFlLlev4KHkFcUPlqAtFOZ/g+tAN
	ocpRN9DNpxhnAurgbeJU2YSztw/79w4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mhkF7e+Z;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782869010;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=mhkF7e+ZtRDtADqZTMQR9kA74bcsj694LYfnfXrM40E2YA3ig0gYRv+Vqg7qZWXrMXwfHd
	P6B94Lncxm2vCK3nYDaUEcQ5ylkahzYsqWdIZCSGcIRv84igoiPLysiX93rkKkBh3I0upo
	M0U5fZvtWzuZekFjq+eVuyQoTvM+8IE=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/7] mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Wed,  1 Jul 2026 09:22:32 +0800
Message-ID: <20260701012239.315262-7-ye.liu@linux.dev>
In-Reply-To: <20260701012239.315262-1-ye.liu@linux.dev>
References: <20260701012239.315262-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EF523A0002
X-Rspam-User: 
X-Stat-Signature: o7dkooq3jg519qgrwjpphq3t58uxmd1k
X-HE-Tag: 1782869011-526817
X-HE-Meta: U2FsdGVkX18xYPXI6tmtYAtAsxGbZzWwhiyNOpvplJvGG7bTUdiTIiS2Zrv9BezQHWsU6U67CWGAgvly81tCD46uM2ud5giwkKmUXslgR9yhjljrGrtGKgvk294AgwNFQNVG/Mz+u2RAOdNAewqrkVXzpW/ZaDV3IfUNFvWt9X80aHD7BYTWBaSwS6SGunsJ/tK1NFc3AP5Mn3ufuxes2FFsvzu+3RArFB4JVCXHkbO5zbcfISEQ+4DTtKMtrLhjLSmwuq4RsA08+6rSxyJH/1l0hByO1VptqnG2V7LbWOJ1Dx2r9FrjZZ9DTktD6ZTOBNnQM7D0za9QvZsARldXBIq1yELcLP/MBD+/lXJYU8XVdEG1fiYAX5Iw2vVMXgpgJp9O16+R2jf+esiTwcuTfp9IZFLpbG/6T/i1q5Rl1ZJkPcvy3jjZxbAxYf/of8UvBErtJVwUyElAY1PEopmILI8QxBbro4iDIUQFZ37k05Uc2XGakJlBJ0gJn6FGgHL/vnq/tXBrolTz50EkJ9r5Pak6G/mHL8LT1w/HQj8LX/zUqqm5mC+2FxJzkoy/qm2gmwcD+AJ5qp+CrFo3Z9QCT/DgE+Nrgs5Ecrg/tPXG1urq57wO4nMeuOkvrb7tD4RTXis9G+92QCqAYfyluuWaAXGJ+WyMwC4UBD++4E8gX2NiUNu2c4oSkrFCm1Tkn8/iC7ZGcEeF4dro5R6GvLr7ebNaTWYxoFjuGX5zf/ic9beC3K0m9Y5uzhShxahEvV1MubgSMux7kpd8reaInhuCnhksldrrgqrMoDEOADdajrOwp65piJiozKKIRHpvcRVugPMcksauv2UtgBpu9CoRuMhn9d9DjxyINmoN3tGwFCMCOGuq9gQLClt7fPIM+uMCHqwrj92GVbGOqUICZA/I5318G+4fcrv/OnEkrQC8mjenTRngAJgbL2vaALuKed+//wUNZRgRQkC43fx5iUQ
 RBV+QMbO
 DEHFNj/SHh4FnTWhuFPMaZTmWgbbzkVF56V6rWz6SZi4hi/WgTnfgzzU0ZEwR2sWmi6Uz14i43DrTeO16lnlbTHYle654iZBpmyLihjRy5yFCoAXTSW7QX3NSHzNqVmcAwjbJ2xqD1ptZ4Jakl6XgQaP+uCGP8PT3vudruKJnjjXZPHa+nMILvqvP7nVJNAePE9aRbxDjcxbCozJadLC91avI7pnELmJT6uJ6smho33YHCc4XmrDcl4XryCxb2v8c6OOeKVMkS+BJY8rskTQDl1LxMGoC8D5bINnaCZbOKwGjqV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The free_ts_nsec field is a free-event timestamp, but it was printed
in the allocation summary line alongside ts_nsec (allocation time).
Move it to the free section where it logically belongs, together with
free_pid and free_tgid.  This also makes __dump_page_owner() consistent
with print_page_owner(), which only prints ts_nsec in the allocation
summary.

The output now groups all free-related information (pid, tgid,
timestamp, stack trace) in one place.

No functional change except output formatting.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 7520718f63f1..84eb44459478 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -653,10 +653,10 @@ void __dump_page_owner(const struct page *page)
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
 		 page_owner->pid, page_owner->tgid, page_owner->comm,
-		 page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -668,8 +668,9 @@ void __dump_page_owner(const struct page *page)
 	if (!handle) {
 		pr_alert("page_owner free stack trace missing\n");
 	} else {
-		pr_alert("page last free pid %d tgid %d stack trace:\n",
-			  page_owner->free_pid, page_owner->free_tgid);
+		pr_alert("page last free pid %d tgid %d ts %llu stack trace:\n",
+			  page_owner->free_pid, page_owner->free_tgid,
+			  page_owner->free_ts_nsec);
 		stack_depot_print(handle);
 	}
 
-- 
2.43.0


