Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E0DBC55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F3F46B0095; Mon,  3 Aug 2026 02:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0308E6B0096; Mon,  3 Aug 2026 02:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E122F6B0098; Mon,  3 Aug 2026 02:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAF8E6B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:22:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E5F21405FE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:22:07 +0000 (UTC)
X-FDA: 85058963094.30.61E4604
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf27.hostedemail.com (Postfix) with ESMTP id 004F940006
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:22:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QR4RRCzo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785738125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l14XFaHja8SkCVrzQL34bHRSsjPVNxuVLQml/d9+YaA=;
	b=OSzA6PcrT9MKW851LwjFFzAQVRRhuFQdohD8Kf/48XndHZyTurttqEtmvy8IrhDLvto0ib
	ya+blLoSAT8Ei5LqigBWrnkbBJXxjiFPbCgwd5i7KuDfx/v5YKsY30JMkElRdcid96etkY
	ON+UO1M+iQm+FlJ7QargPB6Sjbspz1o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QR4RRCzo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785738125;
	b=XI91PJwVSzuvXdKZ+bliYBcFG/9XCakGKQdi6R5KbIOg3UutHbDf41GhP7r9HAaZ9/mTXJ
	Tim2RkdGMidaWvEC79GZorjzBuFjrtU6cL8m3p08lUGybPgOxkrbvbwuJYL26xkZRBhjuG
	9y6ZCpL+ldlGEHwN/hPyhjWrz/v8rF0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785738123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l14XFaHja8SkCVrzQL34bHRSsjPVNxuVLQml/d9+YaA=;
	b=QR4RRCzoJMvQic8P0H2GCo2necBHge0T2l4fn2VBtwgq8BASSaU3qhIbt2jHuC1ARmESLP
	XDq7v2vSz4XRM7vXN/Pc2J1+9z+j0yezogPli2LhV8Jl0QSD9h5UdHBx5IhW48my8TRLo4
	JIbg7JU9CGdrCIhEKN3Eecig49j4bMw=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] tools/mm/page_owner_sort: show available sort keys in usage text
Date: Mon,  3 Aug 2026 14:20:56 +0800
Message-Id: <20260803062056.1518070-4-ye.liu@linux.dev>
In-Reply-To: <20260803062056.1518070-1-ye.liu@linux.dev>
References: <20260803062056.1518070-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 004F940006
X-Rspam-User: 
X-Stat-Signature: ywna4w9mzxre1wa5q8stewxntotyd1d7
X-HE-Tag: 1785738124-423582
X-HE-Meta: U2FsdGVkX1+VVAzbfUIzEUfLLT8cII+UPuA8dNwkkj9WKvw7/mvdnLaM4ndaFNQj6CoeBAzFuHbdjX6yLwziV7ocSGHmLQMyhlE9g/C29imhqNIq5MBbQz8+4Te5ok0dfxiB8uvk0UdBCJi6iYmvvuPpjeTmw9VS7LdC7nCS3Ek8t2ntk1WeyI7GDKozUxWMp0iE212ucnIet9WZguGuzvAyBCCK9pFPfj6RxGYJl20r3c4i1XGs1pn+gda8oFiZWABi8Oks74vsoMEG69kmdyd0T6j5YbJngTrULBmCcXSXXkgEFkGJtN6ra+Bcx7aBRqXAywkRkySlWpsoECtRbAQ3aga3qc6SLq5uZlcnUqIbC/My4Q2RjvYxbJNinmVa+nl6hWkoHffW0uxDjjN09CcnDVZkW4uFblylmezu2xnnLFqU3NIFcHs+x4d3wDod9xLBco0ENyFob0+QOWYklSO4naspM9yIFPfSXI4e48DCmBvTqcWij6zCwHXJxpuDIxn+wr4vVsS0mKxFjZDnsFC1HhdMNCMPyF3nWk+vEn5KU/ETHI1uGZ/vFyqVpVtPqcpFw6PsRnk/WWvn7529wmJs6Ln1uAeclwmhI+58vwmXaW/25Y0CfuTxJWPAACb3N+oDG8AQSmZih9rh1lZrf7aXDEwcVTW09askrjMrfapZyslcaSQGeBgOFFvvx9IvMtUQl5ZJAd9bnKblA6H26V3TdHEjNiL2E/vRs+1ijC3nQePQNuL8Q/hrVd4ECVta1hSCiCqeIH7nCbryq+SFitTj2UQByzfFWhd8Mbgq9y3FzCEotGf5vUKuWefZLsjeq1EYW00Qzowe38hnA0I04FpHkJhi05i+HImhLozrzE0+vVE4ivedAHlVntBKaW3sxXI7+14Odsj6ABKkmM5Kguh66pCLM7fQGbyjXc5G06yqK0EC8Sg6J4ZnqzDq164PDvlcoa7OSZBpddbKQpn
 gjvZfHAr
 bRAYjPNyH6X2l6e4wgPauqGuhaV6hbty4Yl1SiRAcLE5uqHfgBHmTHmUmLEIVNfvx6K64Y9xuYRt3PujLS9QAKVXNcZO/L9MSuYzCRggTTBoBaKOZIXxk2f31a8IHoxo9w+z+spmjlljCK1nGF8fmlDvJnAhB6EY+bx+vNFC8BTbKG0TFWH/R95bgPBuewp23lJm4BXDQFokzKAW+cekv9AwmEvxO2/criYCmuK9U++sp1wKhmYq2aYTWig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The --sort option accepts abbreviated or complete key names, but the
usage text never listed them.  Users had to read the source or the
documentation to discover valid keys.

List all available keys (full form and abbreviation) with a brief
description and examples directly in the --sort help section.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/page_owner_sort.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 70d1c76561e8..c5bc3b524c0a 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -772,6 +772,15 @@ static void usage(void)
 		"\t\t\targument in the form of a comma-separated list with some\n"
 		"\t\t\tcommon fields predefined (pid, tgid, comm, stacktrace, allocator, module)\n"
 		"--sort <order>\t\tSpecify sort order as: [+|-]key[,[+|-]key[,...]]\n"
+		"\t\t\tAvailable keys:\n"
+		"\t\t\t  pid(p), tgid(tg), name(n), stacktrace(st),\n"
+		"\t\t\t  txt(T), alloc_ts(at), allocator(ator), module(mod)\n"
+		"\t\t\tThe \"+\" is optional since default direction is\n"
+		"\t\t\tincreasing numerical or lexicographic order.\n"
+		"\t\t\tMixed use of abbreviated and complete-form is allowed.\n"
+		"\t\t\tExamples:\n"
+		"\t\t\t  --sort=n,+pid,-tgid\n"
+		"\t\t\t  --sort=mod,at\n"
 	);
 }
 
-- 
2.25.1


