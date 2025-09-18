Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91AFACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 03:47:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D592A8E00A9; Wed, 17 Sep 2025 23:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DE88E00AA; Wed, 17 Sep 2025 23:47:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B858E006B; Wed, 17 Sep 2025 23:47:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFE4E8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:47:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04414C0767
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:47:07 +0000 (UTC)
X-FDA: 83900985336.18.74605A8
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf02.hostedemail.com (Postfix) with ESMTP id 98E1C80009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:47:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=a1m1+e9y;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758167226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N8Di7nDWsF0cDcwinPGup3Ryve0dphjG1epFEprr/8c=;
	b=eCMXvBKlx/6i/787Kdimme2nTvXVdBOyKhNqIWVwE2rfaEDb85SXrNB7WXHSke2u29cIuH
	zd1YcN6IP/pKp3sXvaoU4iUGBlfF3QFyIGM+HViH+y57MSBLQlykD2IDY2O1obuqBEhvgB
	2TRXQZ8gBZfDIVZpUGMZQS5k5ZGgEJY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=a1m1+e9y;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758167226; a=rsa-sha256;
	cv=none;
	b=4wOhBreLpoMSl2a9Pr9i2/QEjJemBD1UO+2d/Fvaa5mT7YzMIC7xFiddT2ijyWSaRp19BI
	lhL6AnKeqrasog4BvGPjHZmYrm7IGyLKnR5gtqpe1wGOeHlM4FaE6V3noSNPP4tGfaJNwQ
	SFMW3sUwGucNAkq4jDssEvy/brkRNik=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758167221; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=N8Di7nDWsF0cDcwinPGup3Ryve0dphjG1epFEprr/8c=;
	b=a1m1+e9yCt89iIfTNkNpBCZUl8KHuc0izW8uRvJM5Je/Bh1WfLt7BW10TXa3Oi0AJgENRYwpmCBJyLA4irlFKiWUy0piecUgwrAvDIvf7H1ME8f0tZdLlpcU1EhfzF2Y+gtXxXqvPzUaRmWEGuTixxfM3hb3LUf54LAONuaE/2U=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoEQhD5_1758167219 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Sep 2025 11:47:00 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	hughd@google.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] some cleanups for pageout()
Date: Thu, 18 Sep 2025 11:46:52 +0800
Message-ID: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 98E1C80009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9z36ufjmrr7xshh588b7sgefdpc5y7cw
X-HE-Tag: 1758167225-906426
X-HE-Meta: U2FsdGVkX1+a474+rCu9XkFXSUlxa0E04kqOeHdfKOc3c8urzB1eRNZHAIjQiIRwWM2OZIgfawsJ/pHD5iikRxpF9nhCBK4kD2uFZs1bLkHr9WDOlisE2I7Ctfo2AJt6Ytssmy7P1Et3CI7THbImpkIkyXTOcubCmFQH1sNq+adceiE6GtkaVsC2rx81EIfauWd3yZXt4YOd1M9TRMUcdUVvIGwrYa0Q5cZPAM2avxfyu5X84E9+dInu+NBlBhbBszyfkZnx7kk4wTYoEV9jYSxPHySoCuVi9E/wluRLu7NoUraa4mNLowFjVx1G5UEDz/GlK2oeLkIIkG4SWJHLnGi0TeFoi5oOw3d7IYyuUCvYCaWZbBH8LenQO8ZpiBK7uoajIB5d4NqvALMmFCa84ZBNgxc54U7MD/fJI8P5uxLwghFvMLBEyn3VAWUjbUkSKXt2Pt9EJ4/yOVe4te/pHYOe/CSlttw3ynC3zKj/XGOiRfqId0Q/zxOer4rrbxliwQ5ZjeR3eQjor/W/ChtBLhsJ+BfEl3E3THggrNiF3udl9l4CHBFP40yQ9mFEzHf8zOeJtvi8SDwcFuS7yZ9leTQyFvW9J9l0WsWSi1qwQEmv3dD8wdRy55gLggqPKVhrZErMgSme6jPpg4LfTP44y1ZcxyIwEl2VAtIqf7RXCT4WYYSHSh4NCCC5TLFla29SCWHS/G5tp/liA8K1leNaTtQJi41jHEyZL8eijNSU6VGQ3/wRKD18qFPdcsKRMI0FXu3RRsAxmRe9YNridjSmenwHfCyhIMB+O25ObxB8mTbQkJ8eL3malm7Pg17D7kBZjcRHMgJsykrDwEULlrY2ztpAXwh4OhJZ3JYrnUhkxIoVgZ5zWbpZ7CkO8Vq4asB8ptARIrqLk3CKH+ygT24bEfgpJYoBdLENxmrwqCnFHe/f+IpFw1koMuB7Fz7LpZDCZ1xS8mlpkFsmMmGEXkx
 6xe6zkA2
 LnQYvirtr94EzFg8MUIEV6A/w/wJwub+F+xFFdDbMu2qGqP3gYc+W3eRuvaRtj9x3K8d/Q3RlORWi35VU9SGUo2tnXU5e7VYb6Qbpevnyr88CRnEwT4SJ4ZCrNLPkek98PbYwXUDU65gutlUlk4XAn9VKo+aGW+0WjNZVJjcdRpvCWRuTtppff6AHeNO9ViaBRkjftvo6WC/u9tON5KvRbxnK4uBF9zfremWnyMcXmUnPONCtfWQsqWUz3VCvb+FNMU66piu4vpYBu1Coa++EiLH60SdDYR7SyTiG5LY0njAux2sWKKrIJ3UvQaKpS1wtpSOy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since we no longer attempt to write back filesystem folios in pageout(),
and only tmpfs/shmem folios and anonymous swapcache folios can be written
back, we can remove the redundant folio_test_private() related logic to
simplify the logic of pageout(), as tmpfs/shmem and swapcache folios do
not use the PG_private flag.

Changes from v1:
 - Re-write the commit message for patch 1 after discussing with Hugh. Thanks.
 - Add a warning to catch this unlikely case.
 - Add acked tags. Thanks.

Baolin Wang (2):
  mm: vmscan: remove folio_test_private() check in pageout()
  mm: vmscan: simplify the folio refcount check in pageout()

 mm/vmscan.c | 28 +++++++---------------------
 1 file changed, 7 insertions(+), 21 deletions(-)

-- 
2.43.7


