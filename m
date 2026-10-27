Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB684606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kBIzq5IY
Received: by kanga.kvack.org (Postfix)
	id 684DB6B05F8; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E366B05FC; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523F26B05FE; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8176B05F8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:49:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ADC971A068C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:27 +0000 (UTC)
X-FDA: 85367631174.20.4338AC3
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 78BF51A0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:49:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kBIzq5IY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793087366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqtrTiVGwsNpn71i6YH5euzAwJ7WMZ7rm1kLCewwZ1A=;
	b=zX1ZvBtqn7oqSEOuuia/aClWZ2YPwfa8TTuJDZ28rDmZBMYkEeysIWbbEktV1c8/VuY6Ct
	s4YLbW/h6t7YG2+UuO8ciWy2E+L7ud+evHaaHFdRiTKZJpzKS4kdEW+6ce0uxEONOoMk39
	HoSzw95LuooXmYQwraIbUsqZqBGvDL8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kBIzq5IY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793087366;
	b=XqO0RGh49WLXduaxItntoMZYe7UhWQBXcx9mvu0UGzk6/Ys186lR0JKI6fnfXXJcJZwyMP
	EewYXGaajtwWlx2BxHr3IUXw3Vpz8++hGEKd1yl/UwQeDVPybvlXuyRlHwghZX1wsqxKhU
	s0M0CvfSHhxzGRStTEaPZVjh83MWTlQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793087363; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=BqtrTiVGwsNpn71i6YH5euzAwJ7WMZ7rm1kLCewwZ1A=;
	b=kBIzq5IYA9lk72EvGV+dRcY1h5OClbKb2jw+0y62WZr9OA1Ctzvnkc0d50GOiF9ljf6xWt/SL3pIsrVKuS9n1h09RoT6A0kJNUjtuYrbnQAN1A6IOBH3NUdDI8WeWfqKtLFu0RTjihw3IZHzTDXnlXepJFUpbSvkwUL8S/Dqqug=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XDd8d51_1793087359;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XDd8d51_1793087359 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 15:49:20 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] tools/mm/thpmaps: fix missing mapping names
Date: Tue, 27 Oct 2026 15:49:04 +0800
Message-ID: <20261027074904.3328878-4-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
References: <20261027074904.3328878-1-tongweilin@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 78BF51A0006
X-Stat-Signature: o74fmhyj59bbzikcz8ehfd5grzawjfpm
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793087365-518163
X-HE-Meta: U2FsdGVkX189E1sy1Bp7GM94e6oom9hbS1i1evF5NtIhrgtEnFYgp1MeCmme3HFG9fMqrDyvQBBPrlXVvVNOoUEKS/0HmZDZOD18foYBf6adOwkM8fh2jNWLDeXMmb7BromW6fy8mTWOdcZuUbJBH37fJvjcj7hu/S3ft/TOV8X9BqIjDESrnUkxbkUn40QfuC7u4lk31PL6NLNPtevtY5H63QQSifbNfG6lrsB8tEebdduJWdt/ci2RBmHn4laYSC0+HSCV6IlAHOR104FxUYnvVJo3ibhPjF4OXMlrbLmFDxqGeircHZBkHLf+RV+ShJzmAF6fP23BV3y3Cz1wSwNJPXQEcSz/8Xqz4iSfbw5FAfCMxwJEiZnXbrZ/Z8rta7kLndT7zAhcyZ1kxLqp7bDtcCt4/39TNi0hTL35H3pYli+Q7sCfLShOorrmddzBN6qZl8vua5YABu8CojTOHs1MQyUj/gC2CKPdYKtiBhvRvDMYwrd9WfD8If1AumQzJR0zq93nl5+0q5JkilVcuZWO1eKBdq0oJEOqZrSViHaE2wNuwrsR+2vq/j6drEQGpXAwfBx5eZ0mAxWx/HeilL9CPHAgzZsVtGrtVXaaDdEPn1F5MjZ9F3qDUFBc/m3APMdjGJn/3tU3eC501QzkilloLTMXX45POVyPWmySQrd8BuAuvN2rMjYCHk0SXSEga2Y8B00bKRKAVziUYhHIX6wQMKakSoWJ0uz74DuX9N8fgT3h54c7IfSYkNy0YErn6y5r+cEUSxQhqKtWKPeg+Y3SUBGOgmk4/ldcs+JN2Icc+a3Iqg92rTfKdLxsvF6p3ORAMMR8vus2H1RYEb2Dfp6yL1z8lsI/NKA5PvQpsBOzfT2Q/msb3vPULOXodhy/KQvb+60UU41SqX6vddzKeFujia6z+nxeJDFON3iZGGc+Ba+KYbub7+nJBzlQZEhYnLfy2kl+CF+Q6Zkk760
 Bq8yXy6o
 1bQMdugwOKkasxS9L5Y0qGbervMB8my7EJtqJIUUKwo63K+kAyMwOvs9lHbPTgjR4hxrlH371FksT7Myps3DRA11s/tqA4GaA+ZP3O/tiA3itdTlyhcNAnATSY9oIOM221TiPi30eoyLu0//WRyCXN/dSwB9c1ukshxloEmiSKDfVlyrBcZCs0olIUKmztNg2ZnyUpvb+vFrBED7+abXUaT+mil85juxgZYzXeBqLXsRxvdCKOPA8kvqbQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VMAList splits smaps lines on whitespace and only keeps the mapping
name when there are exactly six fields. Names containing whitespace,
including paths with a (deleted) suffix, are therefore lost.

Limit splitting to the five fixed fields and preserve the remaining
name.

Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Assisted-by: LLM
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 tools/mm/thpmaps | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
index 30a8e915d677..a1a9bc30514f 100644
--- a/tools/mm/thpmaps
+++ b/tools/mm/thpmaps
@@ -198,7 +198,7 @@ class VMAList:
         self.vmas = []
         with open(f'/proc/{pid}/smaps', 'r') as file:
             for line in file:
-                elements = line.split()
+                elements = line.rstrip('\n').split(maxsplit=5)
                 if '-' in elements[0]:
                     start, end = map(lambda x: int(x, 16), elements[0].split('-'))
                     major, minor = map(lambda x: int(x, 16), elements[3].split(':'))
-- 
2.43.7


