Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB97CC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7EC66B0088; Mon, 20 Jul 2026 03:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31276B008C; Mon, 20 Jul 2026 03:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9C36B0093; Mon, 20 Jul 2026 03:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 752206B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:39:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E04CE807A5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:39:24 +0000 (UTC)
X-FDA: 85008354648.07.C348A0B
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7EEDF40006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:39:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=j20OVOzK;
	spf=pass (imf04.hostedemail.com: domain of chenyichong@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784533162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX+1LzALF9JDw6Lg2W617wZtK8rihwWmPIi4u6C6yLc=;
	b=LElzggZ5S3jOXgnrLC131/RJHIolIOHdmx8lb/NXG6rgR3TAKyWsZBzlnFPVa92ZuXR8Pm
	gYL0bUhlnoBby/89mDMA1bd0kKg2y80oApJPGNsJT3kj4UvVe1tZeiV5yMYSkppX/At4MW
	5576cw2KAnA7UMAM28s+f2tlZYDqG6Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=j20OVOzK;
	spf=pass (imf04.hostedemail.com: domain of chenyichong@uniontech.com designates 54.92.39.34 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com;
	dmarc=pass (policy=none) header.from=uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784533162;
	b=jvYSQwu5Ft5C0FI+IKTOlUpKh/1BNPUmjLeUKlmIutRTcDFgiYFplRERFux0k2d3oTnoY+
	OGmUtGxn0nMNphzv9VnRNlkg1MBVLeh8FAID1D0SQpBS9ROiV22N+Nlth2RG7ItO2Y3DiS
	EOikmwDH1V2YVYYN/p3We0nRb9wq9V8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784533145;
	bh=HX+1LzALF9JDw6Lg2W617wZtK8rihwWmPIi4u6C6yLc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=j20OVOzKINOeIqfQQZMYdV//YR8cJKMi2FdN463wfgbqOPQxWcQv77d25ANpCGmuv
	 2CHX30wzchHUVDTLktxpHaV6IWp5jl9jD+Fbgw1psFoqxM2OQFdCPVdavPPdvWYfNq
	 KKA/qRV+7f9y6zJhvlqpZHJUuExoYyxnugFxlPJM=
X-QQ-mid: zesmtpgz7t1784533125t3e58a78d
X-QQ-Originating-IP: Au69oLU4S+S+Cvy3Hhcx2QhwdTZInFFRPyJNpbAU/iI=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 20 Jul 2026 15:38:43 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14676711400642031056
EX-QQ-RecipientCnt: 8
From: Yichong Chen <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	mike.kravetz@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] hugetlb: make hugepage_put_subpool() tolerate NULL
Date: Mon, 20 Jul 2026 15:38:41 +0800
Message-Id: <20260720073841.1389354-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260719225438.041287a56c87effe61796483@linux-foundation.org>
References: <20260719225438.041287a56c87effe61796483@linux-foundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: MQPu5pFEJFN4dTELa9FQfZZyOmGYeTwYFrc8VIn63QCd+HrvrbWvI8jG
	xNe8S9L4x8VuLcjqfCu+dcDdMz3CfyZNru6UQurPZBbaHiOlGMShEqdIzxTfvuIaVU4QkNp
	SsIjptYpNgdeSSl8hTIfkWCT2M58o+HJ6fl6/6XKeQmvcBFHye2zW4snPtUK0IrnZFrZrON
	IK/Bw8YhYXy1AjvPuvuCDU+w7jn6Bo2TE+blxr2KRNbJ1JZpFJoMvpMH7eoTLYGXeWlq4F/
	CBod23GDGPQ191Jh2Vc9gFEBpPkgxvKuv+nlU+1MO+TyxeI/ID/OuWrlvfNgNIlIsC5/f6I
	P2+z6h5ljoe1opvfJZuMNlxtTwxsbc/NZVROd8j8DDNAvGvGIaLAMEoJvXTiy0zRY1BSKij
	ahnZLDqFTKc9ORZj0m0eRHcDPs8EhXobXnzGe0kwQIVChqClC6M5E55PV+fURUwEctFq+ei
	025lvVcYwD2t1k+kPX+hjI9FesIA8cYsfr49x+F1+f68n/iKw2WiritvPdOpLfM3i4Gv8To
	QHtYnhkK4VeDsq2EZNl/5arwBFl5Wkipv9M54btKU2G9IY2BkV2ndm0/dAxgJEWp/Ppcbd0
	swPOGhzEZHbkyZ2BwlUsD4K68Ju5xYCm93WcHXxEc20oAHUChgeWmqSiKNq/+0K78YsUDj6
	b1LzNsMSiAdnGgDXitQSWj4hlReTdoMYF4A+tOUTiSCZEFsBwbGTHTJjzh/bNPbCich6enX
	zNr80CPr44eW4R/cIkHMLbBuwRdKptyKwok0rm3iFzaKBB1zBfdBuYiA5BlnXS956FFe+Vs
	Zzx2yGap2XUSlHNwiRSaBqQUEzOoVbDEYHp7XloRg6S4f102iIuMd2uuJ+Uv5fGQ8Z17Pwf
	2Tkr5Qz+fegXzmw6mqxVdzLTBs4h2LMSJnvxDdwYLuIB9I7SqyT/JHpdSgYXuvwjIctOfvI
	F4RpK8lBi2n4xD+xgjDNhyunc9BU10+8HS3CTkFIMKyDJSTyTDgzgi/SmFF2RQouBTt+Vyp
	eWp/arUYV2hBKLvG0ZHy3FdiJZiE0KylhfBKt/ApEQnL23oSZkLR5Wx2LMHbs=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7EEDF40006
X-Stat-Signature: 68wup5q9mtir639cpascwxagun4pkfb7
X-HE-Tag: 1784533161-219986
X-HE-Meta: U2FsdGVkX1/fCn8QPwzCmsf3mKXK6xckeghPNwQd+JrW1NSIBEVNqNVWazzd09d+4S6tczE7OT0Quw/i7vzO+yV5FRu81xyconXJwRFxPpMuLjLflNlFIDB0dKX6sNRR53wUEcczqIKhExO8P6emkmQ/Z0urJAFHnqtIu2lsyKkhNftDHqkYKR8iYtdd4/8MgrsYwmXCetPVRaatqwTMNagpLt6wveyewN4mK7/LDClv29/bJzzfFDATppkToYKwdeTj12Uf9seOtoo7sLaTzo2Ba1yB5tlfC06k81vgVPahIEs8s1yknhqcmj9P2WMDMMQbaj6/gUSlVmWkeID5fjzXhYJpKEr+DHZHJXl0bdsnRkFYwNWvghM9yNYFCqkNzUWhyHP++s5/XOj397ClSS1S5A09qKnQTLSOAoo7ZGeQ8AMwdPnCc/69O1TwaqQ475mWz95pd5YBNbDdzXEWp244d6a3EoEB3kBsTtaRdJ2jOw/Z7zki3ETkie1d/DxHno97GBgAEtxjlmI03VkskYG2jVvIyPrYkfVeuZ8/HzacwW9JwsiwqCkHqXrJ4U29xBYrb1UO07YbBjPfnO33/f+SdfZnHFGcnje6Fxi/yr3O/cLX8S5DPFVe2hIzDyds0SJbEv6XyMIgpZ47+IgsCc36S7XpX42VLnspi7kpYm5Zn7xgFFcnYwbENpPB6Lre61Aa9McL018vc0DSfP5LyWlSv1nH1VvfFBC3QxfKyMAckaE2NpD9ZNRwTJU8gySAGzD0029jq9ffTo8SH0FTEbD8Esq1fUzGjVxNuzrLkx+owbR3FvEMKrDbVOXQZl9ZlJduuhMQqo/4m5Lvy2gxF0l0GTfffweBnGdGDiZrj8P4tUbWHZshr3pE/srtOM+bH+nXM9S+E4oBIMZdT/UPLaIz9y2BaZGIYvw7NhFooUR81+puujm6qh2Ja4YYBwnlAHMKk1GCzUt212kze6P
 NUvFpK3F
 daahyprYr8dEwoCjqaZBXP7nZYrA7WLbSImBKWd5ek+FStVT+ddmI4U/1RJ+DHL/gY+25C/R6C9BHNf8GeqT74mHYrT/2IklQ3/+4zjwRzKHYRLsog5xO/CJSw0lIwhI798Lx36OffWmWR8tskx+XKyAx67J49hoUBjpL31lTFFB1q5rnAylMaOdgDRVRQDC6Xib74q+vu+pIco+mBK0me9vhH0xzPTuZ8ME7QPWMTzvAEqqVkmJYSC48xKCEXpQxOytdd6CulzywTUcyUMoDAt73LIqGI7NGVKFC/ZmRA1zWUXFmAG7uUBqlCWDrmz/W7PZZT+lpkApwviq4bfHWa7tU5ANkrngkC0PI1o6vBnJA01KsJELtOboOX+CBzjIKe9mSQHykk1osa8c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Both callers of hugepage_put_subpool() check whether the subpool pointer
is NULL before calling it.  Move the NULL check into
hugepage_put_subpool() so callers can use the helper unconditionally.

This is a follow-up cleanup after using hugepage_put_subpool() from the
hugetlbfs_fill_super() failure path.

Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 fs/hugetlbfs/inode.c | 6 ++----
 mm/hugetlb.c         | 3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6a1d7e778cb0..0c125eda16fd 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1129,8 +1129,7 @@ static void hugetlbfs_put_super(struct super_block *sb)
 	if (sbi) {
 		sb->s_fs_info = NULL;
 
-		if (sbi->spool)
-			hugepage_put_subpool(sbi->spool);
+		hugepage_put_subpool(sbi->spool);
 
 		kfree(sbi);
 	}
@@ -1419,8 +1418,7 @@ hugetlbfs_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free;
 	return 0;
 out_free:
-	if (sbinfo->spool)
-		hugepage_put_subpool(sbinfo->spool);
+	hugepage_put_subpool(sbinfo->spool);
 	kfree(sbinfo);
 	return -ENOMEM;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835..e319c6a00555 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -181,6 +181,9 @@ void hugepage_put_subpool(struct hugepage_subpool *spool)
 {
 	unsigned long flags;
 
+	if (!spool)
+		return;
+
 	spin_lock_irqsave(&spool->lock, flags);
 	BUG_ON(!spool->count);
 	spool->count--;
-- 
2.51.0


