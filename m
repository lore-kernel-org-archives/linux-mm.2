Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA7DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37D16B009E; Mon, 13 Jul 2026 21:52:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D108E6B009F; Mon, 13 Jul 2026 21:52:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27046B00A0; Mon, 13 Jul 2026 21:52:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97EE36B009E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:52:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D7118020C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:06 +0000 (UTC)
X-FDA: 84985706652.24.08996DC
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7A0E2100005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:52:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqfByGfY;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=CjGQHsXeUXW0Ogk58KYQjBdqAVg2+/ufH/vWVCpr4vVaNNDaymWYf2Zc7+wd4EM9JRzD6c
	F2Tyrg7W4KaAytKKumwWdEqtomPTi6JAN54Kz/jtw5/9JYUHsjGWfVFJYiYB8K858eGE8/
	CC8QK0U/UUKCmMHd9J3n9RJxjmk9rxc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fqfByGfY;
	spf=pass (imf14.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993924;
	b=MQlgU41ncaD7/CyCA/mpPDmBRbDKqzbN/T+f0tXl7iF9U8HlCbSdmcnKEIGzOrmiF0DJ0x
	BBBTh8+TVuPiBm+W+6buUia4UlPEGFbhtmX4EVVBlMOyRjoNO/RUzyzJq1Ki/AyltGjd63
	k082WZyU5ra1nu2Ewd4KkZ5nD+rWEEU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993923;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7AeQBR8Jr8+xBr3Mb/Jq7ZoDTM1Fuhu9AGQLRB/s3dg=;
	b=fqfByGfYsNTihfrSrwhbwzZuoH3xxwVyI/5JThH+K2q/+S9OM5Ma7Q+cUJ5wJL3qsaVQ5z
	m3K3G/vVFDw8SXDZ7EcNv9hwp7FN+cJFsz4NqChgwMYjDyCzmownulJMQidYu37fUjyskH
	SO5zlTYhqwlwyEKSB19qlNCNHyvsrIA=
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
Subject: [PATCH v6 6/9] mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Tue, 14 Jul 2026 09:51:05 +0800
Message-ID: <20260714015117.78351-7-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A0E2100005
X-Stat-Signature: ftfezmns5jdkhi97wfmskuextchmpm1s
X-HE-Tag: 1783993924-19956
X-HE-Meta: U2FsdGVkX19rDS1+YG7R8WiGUPPB3qqWcj9QQB1Ol7VXVkWjbMIiuapedUgkfTc5/GnDWtc1OfU2U2/JH0++LL6xjQTkhuJcdZTUEGcINyvi3sgl3+SfO/DwYzwwtOAZrUOqbJSTH4sSYe0F/LOh2cDoiPaCA884VSneNwWipiQVb2qHZBDJtCiq8LmZKKd3fXSs0giZfnj8TwlE7oKqZxMfC7rGU72jsetJ8X+kMZdkTt1kzoG5ZBChgnZErOBNQ+AWuJ/CzOO8J7oStnE4Q2wz+ScU0LyRtfvx5OBnQW8l3r6Lkj5BlU7+aAc4x36YBuKCOBkvzMJPiIc5kzemXG5HuicIuln5KPtTX8gyZmIHzVNAv9Ic6EkCHZ5jgWfhkK85gSZ/HePIRmGDtdxZWIO776PzG+QtAOwxdZbw10bLkgvRRA0GcZ3e2cQV8Ktk4akj0Jom2HEScQRDVhAp6eD23b5TiuTKx+Vhj7fpIOigUhAW4H8TkAW3qU27DurdeguWmgjqdHMZm1kr4rUFTqtfpugEQ4XGywGfyqaV+2P+fjYfoWF+bIV82yf1glb0UStVOOSh4/4/42UJGZFvBeESr7dl+lspk4dD3g9Xr9IJI7/k5Vg+2fL42cIffxc3xb6bdrIhgRp5aNjVrucipOHecjwiUwXx3IvBxX0C2prX4PqHa75xIlDTrAMNqE1zpAI9QKOgJGiSwelXM6cRGLyA6HRD8pBWolEmUNVwEXKQDJKBe6w2OTfXmpCQJXE7ZZrZ5rY4iyS+LfeJyxad3+2hmJFYjvlCcHFp5g8khIFikglSQorSK8WqPBiGaKWd9Zn9Lse0kZyp9LWFqBRtp1aXq7YtN4fy0+POrVx6gYCujo4I7EcAW+MhkNuAusTyMndWBntHZ39RXHbRJFtKuNGwSKY7h/9n6g4bUm6+Pl4jE6xcce7wGcaQ/jXvU293nFwjrQ6Y42LcRNFMSQk
 X1AwJwtI
 2R1cw8dWYg4RfpH2i277ZwnhEOwaIwP+Bbs7JfDY+XfseRvv7kaX0iO4NMeC3niCgdIeHpCBtnlvlVwWJqnVQ+WZwDSNWt+pv7f5enVkb/llqswwLqdXc9tROFNy58qadF6dktL/rTSbWcyqkUFN0Qfic2xaYqHVkqHPAr19vjGmbQHpM3UHGZDOGRxK0sqEZFAN4Bw7A2STIl7kpWm7/fHoliE1DIYb0cIfYuHtkZWpn/S7Vd7PvjPJmsXYJekspgve9EBP9SuOmRXJ7a3jwZBXqhVBmgekQwCyLlwvGsoBA7AE=
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


