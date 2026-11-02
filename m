Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26F960A0FF4
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d56wof6w
Received: by kanga.kvack.org (Postfix)
	id F10196B05DB; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA9D6B05DC; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEEC6B05DD; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BA9AE6B05DA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42D42A016A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:09 +0000 (UTC)
X-FDA: 85390509498.24.200EADA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9E31612000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d56wof6w;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632087;
	b=SvObSQ5/gr23Hnq1SktzQHPSDp0/GKzRg4udNXOAZKBa5CV/pnUlkkY8X1r5MnE6B2BL2x
	gYjLOnAkHGKW2V7KeVsFh5mScVmW27kgFSrqfbHRvMj99nfNTsHsp6wxgcIwLJJgGYOefq
	Tbssh/tC2+imkHx2qid3gwqRT8BObKE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d56wof6w;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XuK4d1M7JKzxtXkmylZMVK8sWXtnLYK8j0M8Pc5ofm8=;
	b=3PZtFM46FRIcnPWVu/FEjfNMn0PxabrEgiogrC1QRu7RMrb1w0exRITmppp0v6AOCET57k
	hZyDo+47w7VbHXMPiZ1Y1QeL/geH8OIfT+qpv8L4VOIuoodGDUsvxDBG7pHiN0HsI18neh
	QnLAfS34TUpQ93+kSnsxldCEJp7iNbw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E2C8E42491;
	Mon,  2 Nov 2026 15:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C9C1F00A20;
	Mon,  2 Nov 2026 15:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632086;
	bh=XuK4d1M7JKzxtXkmylZMVK8sWXtnLYK8j0M8Pc5ofm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d56wof6wqHSC2Jccrt0KXPAZZ0jJKKYM00WPVl2hPJUHl9eN14VIGfdC2IRKS6nbu
	 BtPpN4eIrjpqoH8ndJeCNB7CGsPFZ+X9Ph52EOIO5t+CedTH7GujSQdpoMHBEpcmlV
	 cSUp6jDpQ1UdTG2a+UMjrEAQbnTTqYu4eH8muFuWrg4XnaSDr2uUHl5PFm/yaPkBLu
	 YXYqRSrd+GVvivAm3bswv5XNQEARb5XJ7RSXHnv5zIzIYy8k1vL7yOWAbMt85ENR6G
	 9b4Bf36Rs8J6bikuYA7OuvvLN6us5qAvOI0s3S2DkN66zuyOiykckfS1JNUa9gDyO6
	 6K976YpcikCFA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/9] mm/damon/stat: avoid 32-bit overflow in idle percentiles
Date: Mon,  2 Nov 2026 07:07:51 -0800
Message-ID: <20261102150757.93058-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E31612000B
X-Stat-Signature: pakff6n4ubp7xc8pqcp3x74mshezc566
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793632087-750165
X-HE-Meta: U2FsdGVkX18OrUMkawHHFzseAXzDtPOAQvkLuXERECWMUMYCdYDlv5b7yNtLbrUkYyEDiGSAbfu/44hSI6TMRU2LZnFbwZQgKJkb/LMh0YhkcOa7lHtu4af0YZCPa3lWA2HEyyEbs18W8o6+aJz3Wd5a5VPBYDVZuShMNUYGOyjQV2KA7WBNEASyQijDouujw3A14g2z/P5T69XreWd8Raic8ZZq+OgdMUoN4kZHcn5+Kg37iPXr4OB5Bl+COnLQUKLFbVmVup+q0NUScyOlK6/lK+QFW/Atri6uI2oK56RJ8DZnwdiFota1Zqs2uFnyPhHN0tTClvZfasJjQat4UC3DfdGiGGb0huZvLI8h59pvP38IRn8NJgaVr6YKwNiJRQH5a4jMZcBcQJZouosbyrCP8+oUNGjSTQcc/byhTx90ici1nvuuBK6do/RHMZpIxsTPlVeqS7/qh4nly3H4/WzaCtQXVvJYOs9q8q2tv2KcuknJv9QfT3YuTm/iXw6WgNGsGDU0LwfoPMkr2TnDLZZtBz33tQGKxbauo8B0d0Z+dXFXzYNOW1JXY/B4zxyrdrsw/Zd5iIVn8hRz9y06J+SFVVICZozf70rNiZ5i1YiJ22RzN7isbx+LmjBWCuu/t2EOTOeL7pWSoRbVHgDBc6eFQ8QE6PtsOfZiTKUz8kgPowZaxGVeVoL7a++GPi6CQgw8vDFnRgXVb+tIL9Ij42PRoi6xjs+MekDQVnub1of0x55F4NF5/X5duRS81PrXLUM5CvoVUY/A3hbtVFJi4KlfNPcm+EIX44CxpkRG6nzTLU1tjSCrFzaunbXx1t9vqfV3WaBNIGLowrlJVb0ga0sqZ89rJvWSGIwNypmfL77XaW/0vWZxN/Ysy1U/v7foRUD1QNyqJRYN72XvurAKz9bIcB1R/GnD4BtdvOmPBCr66QkzVYjvQtX0B9j9kzBO7fw+bJB2/9dHMuRGo4p
 X61zPb/8
 5B/UkdQ9sVqA9uifKnBnPC7YTy60m+zh2zCm9urmIQ0KHYAqDzakKBSaXFqFaJ/kITTJanG5DPu8RBrQeEN7fIkYUCZbFMA2i1N3A3QdYwIpUaT4c+xAdbvxbvotj53CNGF6UwtBKKP7QxfUcfnWLHayfSVJVmTVurBDHibb1I08nVaHSVuLq5ku5B7flrtpgYso+CPvmar8SqER7zbYiKH8lGIGdf+BVdW85N6LNC8uq/4lEAJC1SAeh0du/x3DR8xTzkcobzL+OP92l59ksUAL2P5QOm7chEoN/BEErh1SFOONtPWQf9mLPRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

On 32-bit, accounted_bytes * 100 can wrap before division by total_sz.
Some entries in memory_idle_ms_percentiles then keep their old values
instead of being updated.

For example, a 256 MiB i386 QEMU guest reported p0=19200 ms, but p50 and
p100 were both zero.  The issue was also shared with another mail [1].

Cast accounted_bytes to u64 before multiplying and use div64_ul() for
the division. Compute the percentage once per region.

Link: https://lore.kernel.org/r/CANOyQmHad1vamnZT12M5yPrJ69==Pt1U0+MGw6u0MuNtr-DRCw@mail.gmail.com [1]
Link: https://lore.kernel.org/179207592479.3.11595453180868898703@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/179207592479.3.11595453180868898703@gmail.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/stat.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index b05b68f73e10d..eccd372810d04 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -114,7 +114,7 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 {
 	struct damon_region **sorted_regions, *region;
 	int nr_regions;
-	unsigned long total_sz, accounted_bytes = 0;
+	unsigned long total_sz, accounted_bytes = 0, percentile;
 	int err, i, next_percentile = 0;
 
 	err = damon_stat_sort_regions(c, &sorted_regions, &nr_regions,
@@ -124,7 +124,8 @@ static void damon_stat_set_idletime_percentiles(struct damon_ctx *c)
 	for (i = 0; i < nr_regions; i++) {
 		region = sorted_regions[i];
 		accounted_bytes += region->ar.end - region->ar.start;
-		while (next_percentile <= accounted_bytes * 100 / total_sz)
+		percentile = div64_ul((u64)accounted_bytes * 100, total_sz);
+		while (next_percentile <= percentile)
 			memory_idle_ms_percentiles[next_percentile++] =
 				damon_stat_idletime(region) *
 				(long)c->attrs.aggr_interval / USEC_PER_MSEC;
-- 
2.47.3

