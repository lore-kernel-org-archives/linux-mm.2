Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37268D2ED12
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218CE6B040F; Tue, 20 Jan 2026 08:57:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EC46B040D; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD7A6B040F; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 638806B0413
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:57:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F271F594CD
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:57 +0000 (UTC)
X-FDA: 84352495794.28.D3B0075
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6215C8000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:57:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768917476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TuwhUf5eSY+S/rzbsKgR1yCIgVkIjYH+iCJ65tb6H7A=;
	b=KtC46XZPQ3MN9Sd79NMRUfeRQP1ZbEBbKhJc8JdqPGku960ra6jNSBuMRPTIcYB2rfgoMj
	j7UNXj2NdCzU2Bj9WcFULT8loMRgiPjK2d1Vo2azmUscLkOGr6knzCh2AFuN7tTORkyons
	DnMXRZ6dyTkpv5uMddN35as8FpA/UxA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768917476; a=rsa-sha256;
	cv=none;
	b=zPNJRUiXRQW74Or3tzt1vPpkQigl9VxRg8KhEPf7CqfCGXcnZiQvqCsvPqbj02Jjp9kQMI
	abH1k3ZhIjMWbD+BYaSGr2vPYIGM2GjrqkqJ5twddKjS39mH//DmUYjsnrkgiZQiw3JdAr
	OB1Mh/QyMbsLInICbke0+m/wpyj8HZ8=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dwTQP5cBrzKHMkg
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:56:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 23B284058C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:57:47 +0800 (CST)
Received: from hulk-vt.huawei.com (unknown [10.67.174.121])
	by APP4 (Coremail) with SMTP id gCh0CgCnCPnQiW9pwhTxEQ--.10691S6;
	Tue, 20 Jan 2026 21:57:46 +0800 (CST)
From: Chen Ridong <chenridong@huaweicloud.com>
To: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	hannes@cmpxchg.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	lujialin4@huawei.com,
	chenridong@huaweicloud.com,
	ryncsn@gmail.com
Subject: [RFC PATCH -next 4/7] mm/mglru: extend lru_gen_shrink_lruvec to support root reclaim
Date: Tue, 20 Jan 2026 13:42:53 +0000
Message-Id: <20260120134256.2271710-5-chenridong@huaweicloud.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260120134256.2271710-1-chenridong@huaweicloud.com>
References: <20260120134256.2271710-1-chenridong@huaweicloud.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCPnQiW9pwhTxEQ--.10691S6
X-Coremail-Antispam: 1UD129KBjvJXoWrKF4xKF1rJrWUWFWrWw4kJFb_yoW8Jr1rpa
	9xW3y5Za4rAr4ag3s3Xa1kWa4F9w48GFyxJrZxXr1rAF1fXFy5K3y2kr4UCrW5Aw4kXry3
	XFyYgryUX3WUXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRiF4iUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: nknq6oojx43hh4ysufiuizae7b1wx8tx
X-Rspamd-Queue-Id: 6215C8000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768917471-606717
X-HE-Meta: U2FsdGVkX1/OGHKr88nYQ7vED313r7aiZyfwiOTK8bqveMvrKREcHn7O1yQHGdGd1O+s7ECUBjwwLKdR9O13Fyl1l/EqNlf5gjJ8bf6fJo++xpXx5l0C3y/Husn3FB7+i2h6PTyscLd+QOT3M8UJfGRWCoHBxxFTfZlvdnrn66AB9Lw5nq+ThDPnKKideZIIcOtNjoPICiWfZTat1qQp63k+3u1bZskamN2Sv72vkUINaP0e7ye15Qa8/5TSjndYJus0hTe2jtns4DyFZV+pfFLCKLuy+TeI16kvSSZcwSyicVay8+2IveaRr/lPgTRZ423GPM1xEQKJyUqnYiKWjffEP80DWEJVqsLJVUQNdqTcZqpOhKfqLsfxze3OAuFfdhgaUYi3iy4opOlyVwXtSSppYr/f1ElDx6US2zdKRi26nPjPqoUSOR0dP7n2fy73Bg5SgI5HcVCmgClsrERaWk0w3PS6SffuDZDdK1/6+fkgWdMRnC/eKdvyVXJocPIOFNryrHJRmuGKL8MhAlBruGxDjVl3bUeJ/TcE6JwZyKvH9KmxXxgBBTxAOEQTGrosukFsUJwxdMb0XzBeTT0dn/tE8NK+n7SMtTPUYNUDjhVhQIbFkTdCOj5Cwml9nhR4lWJE44upVW66UbR0IAl+iJ41dXHPS3BoI/RRQXWfsi1vtZdDn1dyxbs2F0U3NJPuETPCaBpIbw4lJSyNKo3qRooi7pY8M3oor02c3a/+70xBfkOWW9jpZyEfnQ+u+hFjg3Jr1yzlmx9cJ/3BQkkMqcpqcVaV3GFmeC6gz3xGoNZYjyc87YN4K4MDUsp8gybzcn0W3SScttvfpy+4BWAX/M3jHBqemm87vfO1CnnP+5Cz7t/lVUtwdnUVb5xgvCsjxwP2u4XZzothTaqLG94Stw1uW+Svjfq+GFyIW3aatG3RZvJDY8WTzXht9OAeMeogl8/4XbATt1mAqXrbiAf
 VdijlunZ
 rkHsz2Ho55Yj6qeYeWIgwaM59q+oty5iSoR9M1oWCNN78Z/xoi2z8Ff17uMX2HOkd8wAmesMnbRTAsvrOgbV8JnV4UjFDgPVk4EdvMo1u5Pq6s9LC1Hd4REJy5lQmfjXBtHeUTiUYyOIEGAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Ridong <chenridong@huawei.com>

The upcoming patch will integrate shrink_many and shrink_node_memcgs.
Currently, lru_gen_shrink_lruvec only supports non-root reclaim invoked
from shrink_node_memcgs. This patch extends it to also handle root reclaim.

Since the initial setup for root reclaim is already completed in
lru_gen_shrink_node, we can simply call try_to_shrink_lruvec within
lru_gen_shrink_lruvec for root reclaim.

Signed-off-by: Chen Ridong <chenridong@huawei.com>
---
 mm/vmscan.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ab7a74de80da..27c6fdbc9394 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5039,7 +5039,15 @@ static void lru_gen_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc
 {
 	struct blk_plug plug;
 
-	VM_WARN_ON_ONCE(root_reclaim(sc));
+	/*
+	 * For root reclaim, the initial setup has already been completed externally;
+	 * proceed directly with the shrinking operation.
+	 */
+	if (root_reclaim(sc)) {
+		try_to_shrink_lruvec(lruvec, sc);
+		return;
+	}
+
 	VM_WARN_ON_ONCE(!sc->may_writepage || !sc->may_unmap);
 
 	lru_add_drain();
-- 
2.34.1


