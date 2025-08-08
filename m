Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A4AFC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:34:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1F66B0093; Fri,  8 Aug 2025 03:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099F46B0095; Fri,  8 Aug 2025 03:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19186B0096; Fri,  8 Aug 2025 03:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E19AB6B0093
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:34:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E0671A144D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:34:42 +0000 (UTC)
X-FDA: 83752778004.07.C2D7B8F
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf01.hostedemail.com (Postfix) with ESMTP id D68AA40003
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:34:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=krfOrPBr;
	spf=pass (imf01.hostedemail.com: domain of fffsqian@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754638480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bWqffEK1j65V+npFFXubrmYzyYXvK3w8H6N6TmUJh1I=;
	b=E93Yb6U9WEFMD8DWLP1UcZgQGDC3r7Yp8Ir/VglnQSly8qPlQYjMsuAyJEaeAMH6OO0lGw
	BSLV8fB0qLtFiPv7NiGSAmBIOlLLXKXsdTntff8TNP3N+rp9F8hDMpyG9JdJ1XeiCeevKI
	4jn7HwVb8Wdw2J7CLTaLM22SPSuOFPM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754638480; a=rsa-sha256;
	cv=none;
	b=LRGN/8gVQQovJIMGyZ4Kk1/WR4rQGaDX4AzPP78NcZD8jeZsryD6jI1DF33miVDk80mMF5
	XT5s9Dvjov3QDsCYgzN7Iop5tTAL2gzCcPE934jl01/GlmO/WfgSCPabN99f1GqLqKMjsY
	O/KEorU+LE9CaaKQb6MtH52HVWi/i34=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=krfOrPBr;
	spf=pass (imf01.hostedemail.com: domain of fffsqian@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=bWqffEK1j65V+npFFXubrmYzyYXvK3w8H6N6TmUJh1I=;
	b=krfOrPBruaBySPEdh3nNVpS53n9/+fql/Yi5VfqGv5mnq8IEkwSPwJXbPSHBt8
	e6V0UddHh99v8ExRQkKRXs/F/c2faenQ5cabhSTy1oa71BZC9il4wKCWZRYWUYMO
	y7Dnfsju8NDQPM+qHias/SpuC1sFCAo05zm8JDSdDIHQI=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgC3P8BzqJVodqFcAQ--.4545S2;
	Fri, 08 Aug 2025 15:34:12 +0800 (CST)
From: Qingshuang Fu <fffsqian@163.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: [PATCH] Fix the data type inconsistency issue of min (tier, MAX_CR_TIERS-1) in read_ctrl_pos
Date: Fri,  8 Aug 2025 15:34:08 +0800
Message-Id: <20250808073408.154247-1-fffsqian@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgC3P8BzqJVodqFcAQ--.4545S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4rtw43KFWfAr43CFW3Jrb_yoW8Gr4Dpa
	93C3yqk39xtwn7Kw1qvrWfAw1xWr1vkFW7JFy7KF10k3ZrGFykta1YgwnxKrW2yFWxX3Wa
	v34IkFW3K3WDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUnYwUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/1tbiMRmjymiVo1GsMAAAsS
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D68AA40003
X-Stat-Signature: f4atgibmqe1c7sgz778ri854mgume9eb
X-Rspam-User: 
X-HE-Tag: 1754638479-944349
X-HE-Meta: U2FsdGVkX1+5gnS7cakBgNBof9oXmnyL9tTGmWYKQ/IE9huKJbby69RRrF/jy99IVUEtIxe6qZuRGj19Omg1/nGC5Jy+IUe0Bw4UeWrm4s0a+HU7BQTe0vxIj3RphHBxQu7Jh7pWVwRgocBkpo23u2F1pMDNzNkt5VvzjmN3IH6pH72f3g6KN6+TXWWlkyvO+LlYtWWjIM9+FdASBZ5ODL6q1LZwZiLJpuRNNGQV+zTrXGoMn2q7Az9TihRkOyviRfGnhA6M+SyQ+6lKsAn8/ntsZDzmmx6g7sCJu67lYtNqjmX65s/y6O4qNfjCbO0V5U86FAwiFrQQtdCkfyHcj3L2RgPCeOJodhkhcQwWizrltMgXJ+fDE3/+pYWrSPRIV+4Zn+kiPyU6rx7Fz3KsZo4jadNSE+hx7FjrlYWvKHO8rFk4FRadfLokMP9YjHh6LAA+283Gh2VZIqtZ77V0z+chPhggMHqyiVoxs2EfutXJ/ddOpEEcfsf38nrZgsTVmW0KPHXueqszJAbeHcofYroO1xiokNIV+x5QNhQlpxp7IH1wS/TTN9W0RtLr8c3gpJ9kbv5mQJRswInEmDYn3wxwWIiYJupjsvwzTkEYHsolkdXaXfJhqr4WJBW63Y/mJJNq+D2pEMmEdojHylzbN2prCklR1JsbErc2ZF+9fbHFKNPS+PBQPIoQskLjqiDHHGR5hH1sfxWm1P+Sc6wLQKND+pRo7nTn9QuTSBaaTPm0I4c0GiDHq6BKHwFbbi1UklLWVcjQJyWDTx3yb7dHJvArQoD7jYLFsqvMBwdjfdPIvskNnb4e3+R6RMqx5K80ztZ6LWaYSC6htF4OOj31ct31fE1XZSE4zjPPTSIsW9iwhw3l1jnZTN7d0PBOVcNu0O3QNFCGwoPkwUMWqSOqwXEsSzXY0iH/98N4schvy9hdl7DCdqUg5ls2NSgOm5+PjJHKeLU6p0A4augwdje
 erebT+0B
 zh2j2g08Vv9OooSBN8MDzwVPg4c0AMrtKXjZoKFvYYinAvusM7rhiBgtLDeU4QNxTBKRUn12KoPDLe3fEIJMnDq6RyVR3alw9yRpprAu0os+Q102vq2U6XxfPqU/aF9DAev/5P50wKuyVQ6ySzmGgjed5fs0NGw83jqp+AWiHCBF+DIIAma301K19mcoq6hWGOTR4mkNMXi8iUW9kCoNc/ADz0jPnQh460iCqIcMcM3NcO139eX/ONi4qEK5/PYJgSROITQPugsnTVm/rFJc5eH0lLszPhQMigR4hOPCZm5DMnoOVpnQ74Clk0lP3E46yGKlX5SD43pz2wPXOlSHVtE7Ei7GPr3ZxHazTY+wz1npTzsdMgRnoMIw7YPnZwWA8odwOIEf5MD1aY8UBsYo/l1fTahyvpGN5MJZKvBJrT9+ddm9jvhpFJP0yKe2WrSqb+Prk4M52xqkVSjwMj2xBz1NleKU+J9aLENUm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

Due to the fact that the tier data type in min (tier, MAX_CR_TIERS -1)
is int,but MAX_CR_TIERS is an unsigned type, directly using
the min function for comparison will result in an error:
from mm/vmscan.c:15:
mm/vmscan.c: In function ‘read_ctrl_pos’:
./include/linux/build_bug.h:78:41: error: static assertion failed:
"min(tier, 4U - 1) signedness error, fix types or
consider umin() before min_t()"
And MAX_CR_TIERS is a macro definition defined as 4U,
so min_t can be used to convert it to int type before
performing the minimum value operation.

Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7de11524a936..f991196fd8e5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3194,7 +3194,7 @@ static void read_ctrl_pos(struct lruvec *lruvec, int type, int tier, int gain,
 	pos->gain = gain;
 	pos->refaulted = pos->total = 0;
 
-	for (i = tier % MAX_NR_TIERS; i <= min(tier, MAX_NR_TIERS - 1); i++) {
+	for (i = tier % MAX_NR_TIERS; i <= min_t(int, tier, MAX_NR_TIERS - 1); i++) {
 		pos->refaulted += lrugen->avg_refaulted[type][i] +
 				  atomic_long_read(&lrugen->refaulted[hist][type][i]);
 		pos->total += lrugen->avg_total[type][i] +
-- 
2.25.1


