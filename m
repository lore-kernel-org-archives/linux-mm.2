Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16FE8CD98E6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BFCC6B00DA; Tue, 16 Jun 2026 17:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06B776B00DD; Tue, 16 Jun 2026 17:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D426B00DE; Tue, 16 Jun 2026 17:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4D076B00DA
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:06:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 76B478B135
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:07 +0000 (UTC)
X-FDA: 84886108734.13.C7F0EA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id DADE4100014
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAD3K1Md;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00MzoIwtac4VFel31/R2yWbFIq9F4yBooTF10PsQck8=;
	b=aRlnIlzF/UEN97Yl2A+X36A+1D/dbUjK05BuYzlcGGauE0om4qPUQZdZGBQyFIWZedB/Rr
	mbVrYLginnWaPuGmNtk5Z772XWRl1XUn0/CtG9GpZmq8Hh9N09ekDa/i5s3X9jQy9WrSBl
	jiAKE61B4EC3G0ssGNWa+C2/UKBAZxQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FAD3K1Md;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622545;
	b=qfRs72H3DzCcw8boDWW5RUMfo26RLZA1jDj549mgU4YwewyEunLpIZ4B3h2APmNRic9iVe
	N/nK653wXmwIB8ezKibHgSEjF/umP4i3UD6ftTDDNks4mcCmLDd9GpxDVBTYT7E7doTjir
	S2y6I3n1dOmqM7lj3WaSbziigQneG50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76A5E600BB;
	Tue, 16 Jun 2026 15:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E7BB1F00A3A;
	Tue, 16 Jun 2026 15:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622545;
	bh=00MzoIwtac4VFel31/R2yWbFIq9F4yBooTF10PsQck8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FAD3K1Md6YPb/FpZc7cRnt2LdPzWoHZVNpKj1Fi2O7ixVXExB/n8X/V2RWXs3KfRC
	 +JiZfdrK9FmXXISraXz7Px/hRnj0PaAL631T1+KiQty2/HqHfOePJ1AmZgRmCh7e0v
	 YCB0N08ZURLiUIR6qoEdFp3iiQb9RRjHHH4WJ0x/KoK7REOLi4nI2lL5pR39LCDqVY
	 8Yo51gmlzavLMXy1PWF+2vnqnIM7e960gHlbQCC9lQJ2MyzT9Pdr9mtIPK9UPXEQJu
	 kBKhCpYsnGNffF5BG613VMupeTblYkWwYL4GcoPPZVquWc9tsBIcXkkUKS3baz2mBs
	 jQAZ8ei42+GoA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/9] mm/damon/sysfs-schemes: kobject_del() scheme action destination dirs
Date: Tue, 16 Jun 2026 08:08:41 -0700
Message-ID: <20260616150844.88305-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DADE4100014
X-Stat-Signature: bhdmkcqxz3zp9tzafdq6toz71pww7wrn
X-Rspam-User: 
X-HE-Tag: 1781622545-353879
X-HE-Meta: U2FsdGVkX1+Uyozoza+LqfNArbonoF4MxfdkMEpNbADfz1IF+AapaVQZ/7fwb6CGA/thVOBwqMr278M4dhPeUixScystOLsaKq4aFpmpKzzX0IBIafm6dYwv8OLq1N8UXAHfrYZdRiXZFBdoPU3Q+RUJGleNHXoht1g6s0392qqbbW7fztiWTTkO3Fe4zPeBDs2ppobjQbEIZm54BnJxN7Dt03c6N5eLTMKPkc1Bn9QDW0PccFEjqEVXHxqxMt/iSLzmrUr8C1xmwxSC/SxvUThgWRcGh0ekOn3DabV1ELZMraLxe7eNPx9N4c70uNHwY+sSEv/3Wgq6p2fc3/98VejWMuEa4U3DuM86dTRIDjQTaOTl9hOIFC820OxuTrCiyKQdMIFsLTLb4NVAQeufVN/kknW7wEdg4nIc3Y9OnLEEalsxfeH79/Mmoqbo4nCSZBsem7QiB9RLxTAuy4ekGfBmoP5+yfxatREWDqlb4OMyWrYgKLDpA+4q2XlR6epbYXiXuQ9MjfaV5ubmSakEP2p5K/xAZYhX5S5E0wnXtrDzPz+ovR5ZINGpATsf1QmKYXHS9T2Sq3GJZk2TOv2LLa3WHj9KqjtJ6raKyvyDnPomlKnfw2KnxpO9aZcG0Qxh7vA+Cnx+g8En4n4o6OS2wfhVV7FvdtN4HrShEQUJGbN3gIsdVYduALwxRjMqBdWB+aifaC+Er3547b66M/B7G9mpks7jPmPLJ7K70TqF0pK2zjuOYlLCi9yuvQru5yJRzdkONG06Gu/hQAt8CkeTfXDlgT+0LbohUDTlGiDCVQLGiqAmqjiihSWeruNhkoU0nsNu+WqHgxcqZxRwwX1FVdMdvceRWzk2UPOGAhLn06K33RfqfHTpiiusZwFveXgYoKecZWU93kti0k6IdM1YSDbVlGievH5M3HW4aBxxfG7IZlCEr3O8oe9QlEaSvMQspfDWXGQkuqgagrFJChz
 Mz9cM/0x
 tqz7I70IYgiA6yJ73YKRsL2BR9bEdNU7d6AMhSQA5ZFcFYfluaU/hCg4JSlnFd67Jr1rG141eceMYVBYwQVy71P3TXiEDGo0MUZVHHYLOPtBsRhrO2ytLyKfJgBCvVINmS+aDqEVmHwzXIdiiVZVg4V6ARPD3XaeSTys97C9oKSqUMUB4Ybru/6zrfFZ4XbjSMDDVQ0jMFe00ESmHYzS41f5eE2oBBoKI1Al2jame8A3ciLQgzwK5W42LvWlkzYSvrhnk3FOOlq2sZlw2nKkFsAWOSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme action destination directories by adding
kobject_del() calls.

Fixes: 2cd0bf85a203 ("mm/damon/sysfs-schemes: implement DAMOS action destinations directory")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 737638be84f15..108f6de32f8c1 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2148,8 +2148,10 @@ static void damos_sysfs_dests_rm_dirs(
 	struct damos_sysfs_dest **dests_arr = dests->dests_arr;
 	int i;
 
-	for (i = 0; i < dests->nr; i++)
+	for (i = 0; i < dests->nr; i++) {
+		kobject_del(&dests_arr[i]->kobj);
 		kobject_put(&dests_arr[i]->kobj);
+	}
 	dests->nr = 0;
 	kfree(dests_arr);
 	dests->dests_arr = NULL;
-- 
2.47.3

