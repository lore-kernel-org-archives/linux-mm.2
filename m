Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060ACC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 12:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6EC6B008C; Wed,  2 Sep 2026 08:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995666B0095; Wed,  2 Sep 2026 08:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2386B009B; Wed,  2 Sep 2026 08:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E9396B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:46:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E17B4A01E5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:46:05 +0000 (UTC)
X-FDA: 85168794690.25.9D59CEC
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	by imf15.hostedemail.com (Postfix) with ESMTP id BA421A0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 12:46:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DLrKtyVC;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788353164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GMtmqQzkAqu3GiOzzvB2iebUpq9kHlu3AyRKU8kybxc=;
	b=Nk/zliNUFtqxDUbbenYSeKi/lpdWPpmE1pa6bnhA3ksnKFoUChUjKlGTCphsR62WL0tU/B
	NXHDb2fzh4hxGv/3ellukyq2tsrS3SSaxlyqqeQH9rta2WJFthoy0bEF+S3EPl6AjGtsE8
	LRedNliLSczG4sp+Acdv1ZweswOry+4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788353164;
	b=lunrUaWYhWl+9fKoL9VWU/LqRsCWuUJQ+EYkLrGQMnmNjG0fcPc0aqBVscQyXfyCA8YKKX
	yeBU3CZVh4iHSm/pEi/7zz2Chp5nMwmqEIUqBJ7egpV3ww6cw4BktaXTMeXbozE6SxDugJ
	RuSsefERACtMWedvlDCqN3jUaUuP38M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DLrKtyVC;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.62 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LIIZ67WyrJ1BbHKsYGuShJUWhBgeY1V01Hjjf2SBjxc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788353162; v=1; x=1788957962;
 b=DLrKtyVCPx5vDxc+7XWqW6om1+OoqLKc9JK/HKEODrmYcmrzL+O1xpf7LsF79/KT4AR/3YOQ
 ILgODtcuiIGXLVQbo4QcIMQ0KO9+H97EV+hziHA+ZNgPeCzPmwcGfaSUfUNkzeNgrqpB9QQJMvt
 wyYO67TRevuZsU7PfWri96n8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f210d0b17b2194c4;
	Wed, 02 Sep 2026 12:46:02 +0000
X-Mizu-Trace-ID: f210d0b17b2194c4
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] Docs/mm/damon/design: fix broken :ref: usage and a typo
Date: Wed,  2 Sep 2026 20:45:50 +0800
Message-ID: <20260902124550.31175-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA421A0003
X-Stat-Signature: amxsntzj43g7bfe3inmwa67cfzr8z7rx
X-HE-Tag: 1788353163-353294
X-HE-Meta: U2FsdGVkX18aJLGgscDZYiUxQVVuIi7WoJHHrHnF/eLgwVfithwzK7LCgBSMXgNEkvjYwlmmh6mzvXsJM57txO0rP4ZSLLDYrA2PhPuTKqHG19zlmqYOy1PQ7I+SQbURTl7vBxgfx0wpfUoP4hXMqpjZrCdxVNXcUNF89JLmUlIFxz7t+kncwtXva1DMpf5FWdnr9TLbd3PBINfeYTZFwdqB2rLgltP6f6mWxIaYevcM5RRlDqIAZw22lAOgFf7KIlyXaDKwNbWVfKnITbGTaeLVJbT3n8XGxtb41gl+PAltuVBS9GNHF4OY2W/I1F1NQnpdvKGKHYfrLAErI7leq6hMnTh754RxmTQc+dIy3B8c558nVKhd29XwChwZnOBQl3SdnrBlUHIGkHlr2RmHZRJeyqbhIQ8mMTA9JMQiZo++eBLdtag88QN4rbfnlosqz2IaSOhCbhXc4jz3pIhZMdCfBqAqwMXIkvk2KUdM1dWe5+uw8/fYpF4TYyOTtH8MdY2rra7u3mPjNZF8T0pSTnbNKvFV3OtjDYzHfchM/4rRLot0TKEGq2MT6jv9K3HiHF2I/vdpWyrusaBoa+eMLgesgUdPSbikb3kTJ1xLuR6jKSLFEjnoQucEd/AxocY+XkJKNdq696H0uaj64Gd4VdDp/bQjFkyRvNXikbE8PBG/rHnI83nLcD6LyaIZFnefpItmTGZBfzw2sMkCsM2CfWZFwnaxB5HzQKAuHTSIESZzeWDwUn2BLizF1nhhXuoyKeV7lz++e7snE8/XCG939YnEjaiV2si6DWgemQdtEvFgG+cFx186g/nr6ske9L6fKpon6ICq0KOg4WnZ0eNqoZCW72j9So3tDPJQ96e0oYuD1ZXfLm0GIwIBrdX/e2H6XKzOX2buu3ZcXMBobycJL9SrPF65sONtq8KBpc9dPuRN7BQKiZcy+w7Vhu8z5wJ0N2j+bmNlpQ3R0ihQcF3
 iWlQ131S
 oUPSP7woPMUW1goFKLebpshoG01Ejdqf1q9mybkwSMV5b/lEt2nf9k+NgxfUHoxb2MTApr43na55YW2xewOsMclyJDliBVXihLCPFOY7hnvVyiU8Tik9QKF68eUiUJtgAWRDt7tupRsWaUoP+LxLuTAFVUSJY/z8rHEKBq//c/YKOxktpPafYCKAVUm/S7G3qJiKoIvFsZXZR4UFZoH9ACdCNAs3u0OlFSsK+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

The Statistics section refers readers to the DAMON sysfs interface
documentation for how to read the statistics, using a ':ref:' role.
However, the role name has a superfluous 's' appended (':ref:s' instead of
':ref:').  Moreover, its target label 'sysfs_stats' does not exist; the
correct label is 'sysfs_schemes_stats'.  Fix both.

Also fix a typo, 'frequenceis' -> 'frequencies', in the Adaptive Regions
Adjustment section.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 Documentation/mm/damon/design.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index aed6cb1cf483..08c981c1dd91 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -249,7 +249,7 @@ For each ``aggregation interval``, it compares the access frequencies
 sum of the two regions' sizes is smaller than the size of total regions divided
 by the ``minimum number of regions``, DAMON merges the two regions.  If the
 resulting number of total regions is still higher than ``maximum number of
-regions``, it repeats the merging with increasing access frequenceis difference
+regions``, it repeats the merging with increasing access frequencies difference
 threshold until the upper-limit of the number of regions is met, or the
 threshold becomes higher than possible maximum value (``aggregation interval``
 divided by ``sampling interval``).   Then, after it reports and clears the
@@ -875,7 +875,7 @@ the scheme is deactivated.  Note that, unlike watermarks, even if a scheme's
 ``nr_snapshots`` reaches ``max_nr_snapshots``, monitoring will not stop.
 
 To know how user-space can read the stats via :ref:`DAMON sysfs interface
-<sysfs_interface>`, refer to :ref:s`stats <sysfs_stats>` part of the
+<sysfs_interface>`, refer to :ref:`stats <sysfs_schemes_stats>` part of the
 documentation.
 
 Regions Walking
-- 
2.53.0


