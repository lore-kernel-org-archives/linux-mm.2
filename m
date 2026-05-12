Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1649CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202216B0088; Tue, 12 May 2026 04:56:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C076B008A; Tue, 12 May 2026 04:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 053D76B008C; Tue, 12 May 2026 04:56:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E47206B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:56:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93F5E8CCAB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:56:02 +0000 (UTC)
X-FDA: 84758160564.08.8912D81
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0BA9F1C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:55:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=f7UOccn0;
	spf=pass (imf21.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=18810879172@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=V16wZi8CBWGVKQz5HIr9HIpmeN9JoxIt+vJ9yUUV56k=;
	b=aRq6A9mSRaebkQTxilQIs0or18iyOlayWwjDd5tCSFvyt8oYJquW1Wna2mgzlHLTD9rxBW
	0V+mKjw9G/T68zXo7f9Zyg4jqHqyikqsKo66uW6/Bo0VCjW92pti4zizhQC1EQWeB4hanA
	XD71zpYU6Ce4Rdx0hitC3zPqTlbLVQE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=f7UOccn0;
	spf=pass (imf21.hostedemail.com: domain of 18810879172@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=18810879172@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576161; a=rsa-sha256;
	cv=none;
	b=cQ69EOoP5vwr3txVLc+ab7227EzEzwlWsAJRvdIQzdIMg8rSZzWHWpvnv90aCB3m8i0K/D
	OK3EkCap8P1neSmnoj00O0CIm+9uPrXXAN6mapVAnCzbrQpxp1B74vFAHVjEqit+o9MiD7
	Mn5HiGfrkS9jE6ujt/xebqjj4BPusac=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=V1
	6wZi8CBWGVKQz5HIr9HIpmeN9JoxIt+vJ9yUUV56k=; b=f7UOccn07rljwYUahg
	TNDFhkc/5Xq16htcqjb5QOpdHPempZMNLRrQ48oUdRQYJUvN8JaX1N6058bY0K7S
	hQRew6sPUT8BqxY2hAVaGcRR9qXMzj73MsRNSl4jBdX99tkBs0NJ/NkDAVs49yVO
	aAYKWF9kco3GeTgLK1p5H1xe4=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDX98YU6wJqUtDoDQ--.152S2;
	Tue, 12 May 2026 16:55:51 +0800 (CST)
From: wangxuewen <18810879172@163.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <18810879172@163.com>,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: [PATCH v1] mm/shrinker: simplify shrinker_memcg_alloc() using guard()
Date: Tue, 12 May 2026 16:55:46 +0800
Message-Id: <20260512085546.368911-1-18810879172@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDX98YU6wJqUtDoDQ--.152S2
X-Coremail-Antispam: 1Uf129KBjvJXoWrtry5uw15Jryxuw13KrW3Wrg_yoW8Jr1xpF
	W7GrZrJa1rAFnYqFy7AFnxXF1UAw48uay8Gr97XFy5t34fXF13Wr17tF47tFy8Ga4fXFyq
	qryUWr1Y93WUJw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0JUUDG5UUUUU=
X-Originating-IP: [39.156.73.13]
X-CM-SenderInfo: rprymiyqyxmiixs6il2tof0z/xtbC7xcbEWoC6xdN7AAA3H
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BA9F1C000B
X-Rspamd-Server: rspam06
X-Stat-Signature: xmsuhc11kcns4cpfcstfdiahe3yi1to5
X-HE-Tag: 1778576159-445378
X-HE-Meta: U2FsdGVkX19J3l8wPWHxUBwDuRb23xX+vMrS0PZTXFZhPsfkDBB3qIsXDKqAePRUdzLulRrgB7p1jcvKcJSdq0e2FNaVPRgQ4EWpd0lWLgT/xCscTV2NNuTB+ggW3YWFuhVoBBjmMkRJPNYWMX/CnxtZR9ra1H3EGbHRqCVAIz/Awl2hxYaLyUBYQNM+omOMwWWRJtmwKSb4iys/gEkHS1m/Nvab3DBqB2nPDLjC+gcVS54qhjRtxRhU/04NDWqvnZKeb7i1s5k40XE5xxy/ZiV/Ux08ChKxpUWCsfcjp3aAE/R6Qmtxe8ppKJH6kiSWpFmr8HGXJZzp+Ckk/YlwnBBHNZnP0N8DUU9VLe/NwrwQfMxvVlbkWkI4RuJ5wqTIVYDjBE9P71EgXsSogq4eukNZ5Ccpv+R6DP3FvwQCH/dJLu9FOHmZLJOE0BEVhkmOrHbsh01buTaL/j6Lu2Vbw9uCNwQnXaXwKOKoZGYQyfjRi3/q3d6URN+mIaOQ0T+8u3QqscOPN46nshv9Y7oaarQZU6Coq8rWVZt6df7nvhiA1qaNbN2hDSKV7jpl33jAqfWwjUVT1JyHY/Wol8RgMQZlbhlcYWpg6aQMPgu24qD4z5jKYqmfzXEu8lflPRoffYywPn2KzqfYzJaF0vOewce5J/TUaxxE2iJ8JSoJuzCn22RCE2lM/UNXnO9TCIR+hpgZMpU2ESxtx7S4NGt9S1bCNr7G/ToA8/BV4x2jykFZa9ahpynT38HIrG9UzWlkZ3vF7cmtwr0+DQzbZc7L74l1680FxwjP28MwVq65bVb77Ja/tU6pUTzhFf7mnllrUEWxJFet04udsfctOMCyoYxV5ytUqAwyZBqQhuKE+rz1ESwb/Zj40nc3GxGyESBx5afUtbeAyDiGWlMuwYbHX4+T3iYvnbMRgp6XiuPc4BNH8XbdShOmBQqUOhdM83sOaTkatMhNU/NBiBYF6bF
 URFWcRrk
 vIHe4Nf610VxxZDYhvuLbVYLEpEwmj+A6UbdMLeL0akO7JQ6wp1vNjZ870heyt8kf9HmFcn22uJEWyR1pL+k49/Ozvrm4NPeT8LCZ43XDwTSrwKt+QWdD71yJO8Kt4Kr82NAf7TDnyWnuCvvoI9zYjmpR5pPttqKuqlPI5JyxKCiSRf/HkNjwOGCAQFzkAv40dHZ0h51jerE5ocljzMO4AOwkrd9ROnX7LojEYusvKhyk7UbroEDWs0lnliQMwJ2PbNuT4A1R90F8f6ExEiiag55AZrTtfgbu584fnrewpfxEGUl/BRjFaSba0qrsf1G6BYtUhbfnuZgLuLJgr65f2Q0d+zilAa+RF72qBMabiEF/HIE2AwR2sU3ghXGFQPp8hU3h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use guard(mutex) to automatically handle shrinker_mutex locking and
unlocking in shrinker_memcg_alloc(). This removes the explicit
mutex_unlock() call, the goto-based error path, and the redundant
ret variable, resulting in cleaner and more concise code.

Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
---
 mm/shrinker.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 76b3f750cf65..1274130323bf 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -222,22 +222,19 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
 	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
 		return -ENOSYS;
 
-	mutex_lock(&shrinker_mutex);
+	guard(mutex)(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
-		goto unlock;
+		return id;
 
 	if (id >= shrinker_nr_max) {
 		if (expand_shrinker_info(id)) {
 			idr_remove(&shrinker_idr, id);
-			goto unlock;
+			return -ENOMEM;
 		}
 	}
 	shrinker->id = id;
-	ret = 0;
-unlock:
-	mutex_unlock(&shrinker_mutex);
-	return ret;
+	return 0;
 }
 
 static void shrinker_memcg_remove(struct shrinker *shrinker)
-- 
2.25.1


