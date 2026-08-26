Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D88EC61DC2
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207FF6B008C; Wed, 26 Aug 2026 03:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B9AF6B0092; Wed, 26 Aug 2026 03:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080D36B0098; Wed, 26 Aug 2026 03:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFA8E6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:58:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FA18140286
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:58:01 +0000 (UTC)
X-FDA: 85142667162.03.360F87A
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf31.hostedemail.com (Postfix) with ESMTP id 992B920005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:57:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BXbNQZlj;
	spf=pass (imf31.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787731079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RyPvxdGRgH5h0qjgqPGLBcGenj7IQqwTD2ysSpkPQlk=;
	b=JUWKCpkoq3tcVWdn4XS6P4u8p0kby6vM6+2Hb2V51k2Xa4YBDBmIlZrgn9tkwpInFB+oEN
	GxgPKpNQ5PCXYn8oCn+Me9iBsKpU855rrVO5wLoJK2PMILa/uF2ebGoOwrJnFCbjidezKp
	K0OqgQRokN8+Hubl/z/hpT8eBsE0BD0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=BXbNQZlj;
	spf=pass (imf31.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787731079;
	b=xg08OflumIpV/+N9LBgduoHJXf0iNUub5WuCzlO6WMGk8mmlm55FWfB/LaWhWL9ODOPfjY
	3y05WLV0QeVnfZsv87YSAXGwwdMHjcDHGlN9ODRHsZ4JRbJQ/VszQgj0HYsknn5Q8IFvcu
	ypj0aJndFzchP0BibwHlRexo7OBzUV0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ry
	PvxdGRgH5h0qjgqPGLBcGenj7IQqwTD2ysSpkPQlk=; b=BXbNQZljB8Hq81dl3+
	UBzBkBQnQX08q87b14sr5fY0xXz8yjx4VpKKl4gZiQm2K8kxvnc3Pp3hziGWoKoF
	yUH/iOd1xKg8KTpPFMA5/kLvTmou9fhdI8aymZTgklG63QrNLLGA9aj5sEtKxRQ6
	iBgmwP3wt3bx04XNW4IrhOw5s=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCnK8hnnI5qiaqVRQ--.33731S2;
	Wed, 26 Aug 2026 15:57:28 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	paulmck@kernel.org,
	rcu@vger.kernel.org,
	xialonglong@kylinos.cn
Subject: [PATCH v2] mm/slab_common: fix shrink budget underflow in kfree_rcu_shrink_scan
Date: Wed, 26 Aug 2026 15:56:53 +0800
Message-ID: <20260826075653.3304251-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCnK8hnnI5qiaqVRQ--.33731S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr18JF4rKr4xGF43tw47urg_yoW8Zw17pF
	Wjk34UKr4xJrWkuwnrGa48XFWay39YyFWxKrZrCr43Kwn0q3WrJryIyr4j9rW5KryxXaya
	vr9Ig3WUXFyjya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUIDcUUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+Al-eGqOnGlJDwAA3h
X-Stat-Signature: fpaputzwdz8d99s48wt88uftnjhe1tgu
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 992B920005
X-Rspam-User: 
X-HE-Tag: 1787731078-404559
X-HE-Meta: U2FsdGVkX1/hZHFlZkCthgjYueiHATObX+ZdDmCsU5oQekXs00z+CYD/Npkdt4PIFbO1g8eJrQfNI/Olc0FlKc9q5C1vHtk0+Z4mZKYPrKnQHkZmVtO1scOAmBznVfRTsE5yPJaq5u1WAt3dN5Z5nhjSHGhdr/F3jhptn74jzaYmjFwBVZnyNZf+pj70gBjcT0iezWNIC0eXVKEiTJ4vVQ1bhpi/BHaME3fJxi7r2eaKbaNyXQx0rpVuVPC0mme4kdb1Uu6X88hxRCWngsR/Jhmra4Aof2N1iejaxsnNpScPcVUK/YGF9pKFHuvD5xu+coI97+RcaDZe3Ca2zXMpn7ZAknkBij+xnz/4NgtyMjZMJ7nqHm4w7tAgSOxa7T5bph/KfyBP2Z9wvpf7cQTmdwpdRwV9VdxVjnPjd3eWJcOFFTzxKowGHVc4Fytreyq9OTvbco63cyvHi+utwXTp+/W7TlNW/8TaohinboWnGHfKO49GYKBOO4K2zst7EDBLcCxwH83HJ5f2TYG/XAvyfeRF8dl/VkWfjmmcj67X3PJ/GO4xpDHm27wC7CdmF69Smt60+wkT26blBiu+z8p6IkNEndQU/GX2X1gWCGG+K+y5Rmd5tN32UQDID6kPsOzdRFgpBFX9dHlmtd18z2Cp9RFdWtfK10+6xn05jHXqsYyreyh6Pgx98h2seHqiWLgRchvYDNcAsBi8G9oeQsJDMQehIBEAIoao8geiP5xIfEHmgU30lugmTpG/kWWiM9wMng89Jd4aTePwbJfgxnu+gElPRlpMCd5vqDMwSqkAxWr4NFzv5wDvWM3p1ng5/MqZl0BrTzedqBTA4BPt5we/ua7mqypJ/LIgUoc3T6UbPKRNRQGOWY3n0AtE/UrGDfbQ7MlGRoYA6tJIsdwZlPFOrNFqjiDmjA5lsachZhQTUgEis2Q2wiif9/rI0AvL+c16gymM71zPvTMDeES+afG
 eP4l/rLz
 uCwbroI1q3PkOTZFkYZHqX8cuk3mmWctHo/5Cj69DdwDFlmsArXcNh383N4CRdIqUVHqcK/MvjvwhEuMThUolxB+ZtMDqRIC0bS/TXf8b7Yg0GSdozB3v1jOi+GSpRptrA9WpWlDeoRY1NLEvZ2sdCWkduuVq19FTuOiHVo9DpMnKCtR3zxQJ8OIXBW5Kiq8FoBmHxveeSGDeAZ6Dbnf5xc6oTG0lm4UrEfYKB4pKFZRTObLD/+Fcf9PngfyyAAOVYwerchknWBWF7b1NuwtDcWZVt7giDot0XVP3k3uWGjOJjUy2nRAijRgIkaHw2aSldJoyQMvIdQj03sStecedY5eIOQ9ObSosxzmo3zhxphx5iO4z1tRuAUc0ikJu3ffbmHTgIhVQxuYaWIURf/oUt5ADzhbwyBYlKmc3BWDEGPTW4t6rwKziivsG+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

The kfree_rcu shrinker decremented sc->nr_to_scan (unsigned long)
and then tested the result with <= 0. When a single CPU's object
count exceeds the remaining budget, the subtraction wraps to a large
positive value and the <= 0 comparison, which is equivalent to == 0
for an unsigned type, never fires again. The scan loop then iterates
through every possible CPU instead of honouring the reclaim budget.

Accumulate into freed and stop once freed >= nr_to_scan. The shrinker
core treats nr_to_scan as input-only, so dropping the decrement is
safe; freed becomes unsigned long to match the return type.

Suggested-by: Hao Li <hao.li@linux.dev>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
Changes in v2:
- Rework per suggestion from Hao Li: accumulate into freed directly,
  compare freed >= nr_to_scan instead of decrementing nr_to_scan, and
  drop the per-CPU count local; promote freed to unsigned long.

Link: https://lore.kernel.org/all/20260824091838.1692153-1-xialonglong2025@163.com/
---
 mm/slab_common.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 657fd75776ea..e227c2ef2a4e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2162,20 +2162,17 @@ kfree_rcu_shrink_count(struct shrinker *shrink, struct shrink_control *sc)
 static unsigned long
 kfree_rcu_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
-	int cpu, freed = 0;
+	int cpu;
+	unsigned long freed = 0;
 
 	for_each_possible_cpu(cpu) {
-		int count;
 		struct kfree_rcu_cpu *krcp = per_cpu_ptr(&krc, cpu);
 
-		count = krc_count(krcp);
-		count += drain_page_cache(krcp);
+		freed += krc_count(krcp);
+		freed += drain_page_cache(krcp);
 		kfree_rcu_monitor(&krcp->monitor_work.work);
 
-		sc->nr_to_scan -= count;
-		freed += count;
-
-		if (sc->nr_to_scan <= 0)
+		if (freed >= sc->nr_to_scan)
 			break;
 	}
 
-- 
2.43.0


