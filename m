Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A74BCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 03:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9B96B0029; Wed, 27 Aug 2025 23:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D14F6B002A; Wed, 27 Aug 2025 23:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E326B002B; Wed, 27 Aug 2025 23:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4051A6B0029
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 23:06:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D932213A3D9
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:06:45 +0000 (UTC)
X-FDA: 83824678770.25.624D386
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf04.hostedemail.com (Postfix) with ESMTP id C87D140006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:06:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VdczDJbb;
	spf=pass (imf04.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756350404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zdy1vHL8hoYAu219m92JWTOObDeLeFpLwc8gGqb8B2M=;
	b=muzhhPS0ZXFPs0yGraXwn+PhfHqU94yySmGpukEedegDBnLhqlCbFZhkHv51x0vSraqV60
	v5B89XE7/Yfh4RiNI2/70cPHQ9vvZFS1lscZ5/9dqSausZOITo4bjIiYe/LkdiG1p2h5T3
	5pp54sI6Gp+zrGNo0caE2z7bqP9Hlqw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VdczDJbb;
	spf=pass (imf04.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756350404; a=rsa-sha256;
	cv=none;
	b=LvOJ6E8ZbdS84nt8+WQbYHeqWYr3zO41OAaCI+Zalvsteu7K0/0sZJcKu7uArPQW/rgofh
	aGbAnLAuJ/sfeVKfcL6z31K44CD5uXvWyKTY8s1PEyJr5YiTL+BgmC//EkNQBiUdOyhglF
	xQmpfDM//MFnLRoxAAN9R4SFM7PuM84=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756350399; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=zdy1vHL8hoYAu219m92JWTOObDeLeFpLwc8gGqb8B2M=;
	b=VdczDJbbAbVoMU9QM8IRtXZ1KHTOQPLNDSZhZiiLR4Y5QawRkgMU5RFihE0JrrH1WYRJf57hrkzo0vJw5MLPxWcSINRpS2o2hK1nv8yQKCRFg2U5axl9t6ZRnNp0DWxe73aoE0UaBGgoLlfEOwPH4gB99HmJ/sFBp/3CNzFZo3g=
Received: from localhost.localdomain(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0WmlD1C-_1756350383 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 28 Aug 2025 11:06:38 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com,
	tongweilin@linux.alibaba.com
Subject: [PATCH RFC] mm: Use pr_warn_once() for min_free_kbytes warning
Date: Thu, 28 Aug 2025 11:06:02 +0800
Message-ID: <20250828030602.204332-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C87D140006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jjcsfw9o1syeizezfw3o48e9qqh1ruug
X-HE-Tag: 1756350402-780114
X-HE-Meta: U2FsdGVkX19xyEuETKTkg4pZPqFkaryzmwQcPZFR1Gdfejqc9AGturByz18/3U7ZlFPlzdIcfdLz9ip/7QFOSReVr6rlV+vks56rVX+1BKF7cOrtaJk9nOmb1/B8sgEGEkzZ8A0/BZNWLRKWNkuJemjecICFz1cEa4CBbde9+uQZN6ttk8LGNCTfQkEVi/2qFQyKRpxe01mH+MEDdEb+pMaeD9S5aRVYJCGYR+VFUUkNM26GWt1mRcRJny8xXbMdauqR75pBll8hROi1e9eR51GoqX9JNxSgyw7D2q5zjgxawpD/jFqjI/yjXwYg4zVYSchwfKimjyp0Mahv3AAU41LyGA8wp+wKHDHbDjHavzF2lC1buVU6LvXMb9KsdrRYgao3XlTK/ZcyUG+EhX37HsJz9C3mf80tITeC/1q+j3QogbWTWHjGwjADA0T/iWuy5RvIhpyEqLxGf9WHJ327kpeuNlIf8D5B5oR7/sfH1uE+Qhv8YYTvaOV9u8IBkgFdq1zRDpNT0/W4KQjPFvpMPEW7hUz7AB0rVe7r7j8yFCY4WCIoZLk8GOZhvTMH12alFU5ei5uUABjEGT4EmdOhv038jr5XgEWZHKkoYiLCFVtREfN+B6KtKq/KOX9vhlhE4J32bsGqaJohnLQvJ/6qvbCvsMqa2Au4honcJL+Ib/5WDpU76Zlmu4amYIkXS8Bn+aBGG9WcJgOBShaaE/0R6kXKZcEQlOwbe/VpkzFnn5BFS8ZN2pJENsG0hihzl1Hh52chWSYE16XyzZEw/SBbFgMf3Z+wfZGJPVhhWwTjbsV3uXy0PtMkHv7cw6onYOGTkYCy4ED8x54P2ZIHx24fuSdIzOSqbMiCEpQQ9UAclfQruID358i9wDb+Oz/DNiIBuHJXaGnY+/ALTwn7vDobLBW+HSIROaU44OXfSyfAKW6yI9BF9HFTpiOh7ZbDcuKaieGJe3/VlUepVBrYoID
 WdT87u/o
 +BrbOir1kS0Iuc2fJvlNhndtfA7LaC9OGgmbuLdSxiSJy3CISTG7r+jmDWsxXgmLwktPof/EYcL0H2VbvnVWrBreRH+YsArlcHyYvfUglmxapBUD9/J1WgPiv/iTMobAz0ts0qGWInoxvmJMnMj1haNZJV89W1gBXzqLjoHBz/YLDez8IgGbdnIyxUhUx+3oiv30xslGTOe9Hw/vIO6/78JjZGwobQyyl3RkV6UbBQPfvGDgs+SrpWrmU6SsX8VsqzvdeqsvzR4EjVagabo1nqlbANE+CNVDd2rE/eleWMVB6zpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When min_free_kbytes is user-configured, increasing system memory via memory
hotplug may trigger multiple recalculations of min_free_kbytes. This results
in excessive warning messages flooding the kernel log if several memory blocks
are added in a short period.

Sample dmesg output before optimization:
...
[ 1303.897214] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.960498] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.970116] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.979709] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.989254] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1303.999122] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.008644] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.018537] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.028054] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
[ 1304.037615] min_free_kbytes is not updated to 126529 because user defined value 1048576 is preferred
...

Replace pr_warn() with pr_warn_once() to ensure only one warning is printed,
preventing large volumes of repeated log entries and improving log readability.

Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index baead29b3e67..774723150e5b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6412,7 +6412,7 @@ void calculate_min_free_kbytes(void)
 	if (new_min_free_kbytes > user_min_free_kbytes)
 		min_free_kbytes = clamp(new_min_free_kbytes, 128, 262144);
 	else
-		pr_warn("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
+		pr_warn_once("min_free_kbytes is not updated to %d because user defined value %d is preferred\n",
 				new_min_free_kbytes, user_min_free_kbytes);
 
 }
-- 
2.43.7


