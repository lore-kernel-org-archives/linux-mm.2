Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B308CDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08ACC6B00BA; Thu, 25 Jun 2026 22:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062D46B00BB; Thu, 25 Jun 2026 22:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE1836B00BC; Thu, 25 Jun 2026 22:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBC736B00BA
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:46:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A2A1C1AA3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:25 +0000 (UTC)
X-FDA: 84920525130.08.A756295
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF847A0003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:46:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=md0wF0PG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441983;
	b=RhIoJCvub+bXK2FCa3u0+c5fFT+swn+xuZm0/tw6u2D7n2W3OkQ38wVvxqhaMus48iZQ0b
	vkBdCWpyuOEb/PuA0CWxzNrLuF0JWFNlCayoWmXFC6v3Bccv8zIH+/uOM848GeGhfkznpn
	2ttFaxDXosIEZ6HXrz5TnUrJIrKNS2g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yky0pLEqAno5O+v3VI+smdGn9aRO7GVsVIMrBB77xuM=;
	b=M9FqnRyu6QJHDl525O+4BSMv2mbZ6cRr0JONJogpRpY51h/yNYmb/YZTs8P6Uir4S5bSsc
	Ls4jUZGleejowTIdVggvF4riO/MAwEeTRE40NXLn5aWQRQfPboQADPPURAJhY6rptRIjCj
	JfK7eNMc35O1zAh6oiik0Jq4NpxL0Ms=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=md0wF0PG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yky0pLEqAno5O+v3VI+smdGn9aRO7GVsVIMrBB77xuM=;
	b=md0wF0PG5I5TUsMKIw7geqmwSK+Z1TNDUySKuqgj32O4byLR0iczfBoRYQM24zoALjslN0
	IhwuMeRRdFU/ywk6RcyL4p5MU1n2Z0/gWiEIuCWx4b1EEDfIbleIiLee/VvuSe+7oO7LdH
	UHJCTu1g4PlC6G5XBcpzZc0XUtQyWYQ=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/6] mm/page_owner: move free_ts_nsec output to free section in __dump_page_owner()
Date: Fri, 26 Jun 2026 10:45:44 +0800
Message-ID: <20260626024550.25677-6-ye.liu@linux.dev>
In-Reply-To: <20260626024550.25677-1-ye.liu@linux.dev>
References: <20260626024550.25677-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AF847A0003
X-Stat-Signature: p4iujtziywt5aydfetqtm1tqq3a1oebp
X-HE-Tag: 1782441983-941756
X-HE-Meta: U2FsdGVkX1/3wzhqnYFHrvcii4G8y1QywiAS86HCD4AY2gxC7h2HV1YFgaJJVAau0SZGHlU3VHXEqwmXoUbjDWt5zyUeyv3ooBDU/jOkDqIpwaucHjmPa5E8DAi7ksI82c5uUp1Vw+1yQ3/istFkfKHWk9PpS/NqIsf+y7frlFvHFWQ5FDWOTMTC2Gzzwxcx8MFGqbpjNuRmdfoSdgmmbA6Qw/mHwB4DVx4otmWOqNk84XHundp3TC6JeUzO1dNuLi6p8zK7GnxCLwLkurCCaf2Eq/vWbJKcErs01XrO2jOe5maRgqNOB/C/YyF5jA1njpCt+fwVHGI3648i0I8mV/H3uaCUbFexl+2vqbynvj7nvGtU5SRes5Q6PS3N1g2UjGN2wlj9vdWxo7m2ZvsW3NwHT4E0P5P3Pr4KYQioZYcIEgsyXYOjcCP5naPoO0Wzbc5u/v1sbG4RTbwmWrmkt9Mga00u4t8O/uX2H8ywpzoKtx48evkFDAINAYLPtNnW80jWhoiUPfgTRrN1mrnmBeUArFC2wHLr2+ZogjcDsk1bQ+jv9QDYMl4XsQMUCsQ//4M/b3oKsA2eopKRXaNw3ngBmCPEex0E683YDdFSGQuf3AdDRd5BH+DltVQuqkryKpcUJP2LEBnvLE2FTxkXvX+KP2yWtqak1unByznUIGkA8ocDSGvMKwpfMH7rmTmZvbs1oMYeSJiRR5s2SnCNa8BN4ZaRToO+WMD7WKQFmOttUEuCoUvZ2MAvHPveostbT+Y7z+Z+gFeahSU0VfxjMMGo9dyBbCH3qPDkmUG8C6J9JdDSoZgVpKhorUkEyzqZr1iVYV6oynR2Hl/PWu59T4sMwhPplbegtBzbem8cHXoLFqlnBRRaOWa8Z+e3XkNoYZnVcrXRGIwIRRJk4Ioahp/EOGGwHAWPff1tgO8b3QDeX40G2Av8/Uz9i/y7VN8kgICPQdCrA0fp36pjz7e
 dk2hAuOP
 x2XlAwaB2LaYzMbrzhH6xguITQz4u6MbXmlB16LVMoqsxaBZh5bDCsR2MYkAFshPwKBoqSAX3rLAOk6FMc+HKWglnMB/VagMPR58UjE9oiVBhxR76UMT8I+5tzeEGKcy91L7kliw3UlsFimP8niJ0FJ5VUZL9fJ43XOtlxPaT8GYB4ReiPg210FcoGF+/nUBIaPhZHExY///YTb3e9tDxbRuTdv7zNRGTrwZgIzIjhaJU6N2xVK1VEf1PiQ==
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
---
 mm/page_owner.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 958151ccb587..eaccff355cb4 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -660,10 +660,10 @@ void __dump_page_owner(const struct page *page)
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
@@ -675,8 +675,9 @@ void __dump_page_owner(const struct page *page)
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


