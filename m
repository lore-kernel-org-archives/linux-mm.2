Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84381103FFAC
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5376B00BE; Fri, 27 Feb 2026 17:24:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C3B6B00C1; Fri, 27 Feb 2026 17:24:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D919E6B00C2; Fri, 27 Feb 2026 17:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2B276B00BE
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:24:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 655E88C8F9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:24:28 +0000 (UTC)
X-FDA: 84491666616.06.9E79169
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	by imf21.hostedemail.com (Postfix) with ESMTP id AFAF21C0004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:24:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=kqcCumOx;
	spf=pass (imf21.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772231066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gAoeFfADvJ86Hh0vJUrgbphPDvQiwv+aA//qYUUm5aM=;
	b=C50lPxsuYgV3Rx5+8K6pnPFjh0n1XQ6wNSwgjavqBxkYahcHHGlVWW60RXA16kRClgnKEa
	y3P2TMzL1b4Lartt3kpI+axMjOI1Kb2wXmH9KharqPDeRmR4nHhiscQVL7/t/n7BDqR+Iu
	KQRNTWTzuVUQ1bEpkv0gzFFYoUyKhOs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=disroot.org header.s=mail header.b=kqcCumOx;
	spf=pass (imf21.hostedemail.com: domain of mcq@disroot.org designates 178.21.23.139 as permitted sender) smtp.mailfrom=mcq@disroot.org;
	dmarc=pass (policy=reject) header.from=disroot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772231066; a=rsa-sha256;
	cv=none;
	b=lPIRZXx19OvQF1ABv9rRmEc7OJdqj2tKSOXPlUy9zQ8qt5CVHS/MsGhgw+3Kw1AIDRvuk5
	5lVbVXoEFr5+QoxFmEPHjkaBnGesm2xZ8wdmy/LnE5OvUTaspfcNBKAIbTQibzohRQS3+z
	Gj/vL0/t1R+51hqXMuSV1vguLNblJfY=
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id B96242675F;
	Fri, 27 Feb 2026 23:24:24 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id OIZYeyILiTmy; Fri, 27 Feb 2026 23:24:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1772231064; bh=SO4P9lTr7kXpn3uXHaW9DqgCN+bZeD2qLCDUrth50ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqcCumOxei8B6l7AtoUXXov41GNcAv8qElgwy0aOZou+Nkp405czy8EBF31mtieh4
	 GiWCaaG8KP90AvipNY3IuAqMoqxAuskX7JgcKlQN0nbpuTVvgBFZb1zPe2UzpfPp08
	 rclF8QjAI0rX/Vd4qxt5VfzUb86s3q7reXC1XVJzQdpDBU0ATYeII6qNe9H2O5FTEf
	 PcD9ybWgsZMQ6QF1ZDDMsW+K7cYWj7nLO0LlroOZOjlcvP6yOzyqXmIIR2Wt8FtNVj
	 iRRDNxKTFlnLLOPUuCDVfNqYwbHJOxAJcfcybh8TcaNtMDTfJZfQIeznouVAydFsmV
	 Vo6fTYj9QozVg==
From: Benjamin Lee McQueen <mcq@disroot.org>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Benjamin Lee McQueen <mcq@disroot.org>
Subject: [PATCH v2] mm/vmpressure: scale window size based on machine memory and CPU count
Date: Fri, 27 Feb 2026 16:24:07 -0600
Message-ID: <20260227222407.30999-1-mcq@disroot.org>
In-Reply-To: <20260227163333.6394-1-mcq@disroot.org>
References: <20260227163333.6394-1-mcq@disroot.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fuuaww159ku9ewdkt88ghxxd19fhq86d
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: AFAF21C0004
X-HE-Tag: 1772231066-389788
X-HE-Meta: U2FsdGVkX18Fr69SWQ5VtvICtAslROkw5pR37kDP/umA73XOGPdXvNhPWGRyj+tEyOQoPBQFGoAc7B8mCvC5I62JKQK4WKyaZ+9gi5zOh2xHqyeZNVWKMn3U1SoAZVtxxIxQ84UD/N11HLj0K3f7MTOA4Nwwhpbc/sKXVsfBLiAOQ6O32wC1tMepY/vo1q7RdSdbOR/rrhgV1twaL63YyJqfm8CO3P775K3/xJ7fSJ71wU+XQ3sUkaoTw8GmoNnmNd4xO8L7lG+czEuDvquRLerWqg2KzAClgG4KeAqBj6QTTqVHYvejsPza38rDe8J2m+lwSOmI5042/0utk+57AUHQJPTl0a/z0UhseuU7l6JbEcADnQlz/xqVatB0zp+IwBor3zz2YIEgazpWXSDqUXkhxqyG0OJP5x9PlHXt+12ArgrbHLA6DktqecIQTxNQR1I4ALGRFSJa1j9apgFG24IuEAu6PmeMy/ya8tf6CP30BCUIoMP6uJO4DDQ3+NnY/8YX1uBF1Uz3G08vPeBT0LgLuhJ0esnWOd3oDFxpj0AMdvQV879QWdpujQskAlyzpK0GdYEjBPe15z/C+sTmM+26WDeH7byhHMi0cy7rsekwcqPR4Lo6SXKDkFG3fF2GZwkg8UlpWmpBX/v/zaZN3GfCex+1fkUIGeq366kui5YA/2CXVZkIYXEZYj1X3UZZkvsshB+S9joY4k633kF5RWMsTuAo+AATnpdV8EkN5Ad7rQ7UuIU+ZeoXE+5pbmVUChcHNMO0mur87QAQYGiU4OqP8CuZxdEOo27J2Nwys7YoyZuCx9o96XxXW31VK+NaHfhp7gxnd/mYZLAf6hNSTxlugGBGXn+XKl7T1wh8pfiXl32ZHdN8MROJz0r18p4+ALB3OjAr8zsEIvI97PVxDXRajn9VLXi3cT+IMu7+TppdJzznYRZlWy/gWEDaKMkhQ4HBDg27Wp+40ATlcRD
 ob9tRWyx
 +SpVF84qzvA7InrZasUa/ivpwifl02NT5DbDTL0/J/HCHMoJD09sIbBQATr53IZgxyDWmfiFnxJScshI7istOYvNF0BuQvE8bThIH+47cuytBkxkW/x4jSWCFxRlL3dshu3hNXDEOB5UKBuiLJu8kZEkxjX265LZ3FE3wUcEEWALsNTxhNp73xXB5b0R82coIYJ+9+GTCPt0Hsxsd/gYy/9/IeZnO4pC78bbU8vyuoZKklR2QJNpnZDsqTmvi8CVQKTQMLE7HEcT8WsYZuCBNNaHZ7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

on systems of different sizes, the fixed 512 page window may not
be suitable and cause excessive false positive memory pressure
notifications.

or should window size be capped to avoid excessive notification
delays on very large systems?

v2: better commit msg, also tried to fix the whitespace.

also my bad for the multiple sends, i couldn't get the format
right..

Signed-off-by: Benjamin Lee McQueen <mcq@disroot.org>
---
 mm/vmpressure.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d..925659f28dcb 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -32,10 +32,20 @@
  * As the vmscan reclaimer logic works with chunks which are multiple of
  * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
  *
- * TODO: Make the window size depend on machine size, as we do for vmstat
- * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
+ * Window size is now scaled based on RAM and CPU size, similarly to how
+ * vmstat checks them.
  */
-static const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
+static unsigned long vmpressure_win;
+
+static int __init vmpressure_win_init(void)
+{
+	unsigned long mem = totalram_pages() >> (27 - PAGE_SHIFT);
+
+	vmpressure_win = SWAP_CLUSTER_MAX * max(16UL,
+		2UL * fls(num_online_cpus()) * (1 + fls(mem)));
+	return 0;
+}
+core_initcall(vmpressure_win_init);
 
 /*
  * These thresholds are used when we account memory pressure through
-- 
2.53.0


