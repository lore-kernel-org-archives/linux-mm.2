Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95530C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ADCC6B0089; Fri,  8 Aug 2025 05:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F066B008A; Fri,  8 Aug 2025 05:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075356B008C; Fri,  8 Aug 2025 05:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EC7CE6B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:55:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71B795FBE3
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:55:04 +0000 (UTC)
X-FDA: 83753131728.30.52AF375
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id 09929140008
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:55:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ASCMsHJm;
	spf=pass (imf09.hostedemail.com: domain of fffsqian@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754646902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fgEIQccnW8nT0HbsPC5z944AQr0c2fBSMFL9YRUiOcs=;
	b=5S6MxvzJ5GS+s7nsD0HwJNCCW/8u5I9v1jQLvo25A8BtENmCTwAoARL4S7hQZOD1//3/oe
	2nRXHc7GqOJIRqxaQmt16Va9j3/F8svAwZSIiET+aIo/cPsbRFpRD6q/DnI9OVvfePyJL2
	4IC24Rn438WCoWs+O8Nz/r5XSYTkWLU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ASCMsHJm;
	spf=pass (imf09.hostedemail.com: domain of fffsqian@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=fffsqian@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754646902; a=rsa-sha256;
	cv=none;
	b=HsGSn2RFl5Ca+14C9ji9uKXF/ONnlewAg8rE/2x7PieugiCO4mpLfDdQa2Oxcj9tdpXX0o
	xY0ihTIKTX/ohlpoucdLRIepBZAsU1sMeLNsAAjsX3j6Wzgnj6CEzyUozHaEgsi7gPXkC7
	sPf8X1vFgkurvR9QX/R2UUeDg5iolZA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=fgEIQccnW8nT0HbsPC5z944AQr0c2fBSMFL9YRUiOcs=;
	b=ASCMsHJmopXVtSvZ2tFEgta7XFidR2shjoHZAPJMZOcrneXecKGH3PCjXj2/Wi
	DXywyhE6I2luQA1qdzSPuYl4nLc9Cas9mVO51D0o1uTKf0404fsD5td2HpbMqyPM
	IUXgUQNZO1Jq458BpgYcfL571Gfuc2bBdqSQczqED3bRE=
Received: from localhost.localdomain (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgDHD5FKyZVoRUzkBw--.6054S2;
	Fri, 08 Aug 2025 17:54:18 +0800 (CST)
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
Subject: [PATCH v2] Fix the data type inconsistency issue of min (tier, MAX_CR_TIERS-1) in read_ctrl_pos
Date: Fri,  8 Aug 2025 17:54:16 +0800
Message-Id: <20250808095416.208289-1-fffsqian@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgDHD5FKyZVoRUzkBw--.6054S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4rtw43KFWfAr43CFW3Jrb_yoW8Jw4rpa
	93G3yqk39xtwn7Kr1qqr4fAw1xWw1vkFWxJrW7tr10kasxGFyktF45Kwn8t3y2yayxX3W3
	Z34IkFW3K3WDAaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUnYwUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/xtbBDg+jymiVwnVE-wACsb
X-Rspam-User: 
X-Rspamd-Queue-Id: 09929140008
X-Rspamd-Server: rspam06
X-Stat-Signature: 1gy9o1wm34b5mbqr9urpfb4rnm4939wx
X-HE-Tag: 1754646901-301793
X-HE-Meta: U2FsdGVkX1930eoPf6H8yRHisQcWiNRF3TbK8/sQspLaEX6wKMZp9mxbbBfYbSXRHCzLGqFy05wQWcMt54dLgNQh4LYdJ4AV9MagFco+J3YMkxPD2BNOFec9jnq5WX2laq0bbuy6OMIXkR9pZKggg99og/nV3dUSkFh7Fg4a5MDm1UTIqeg8hoDNQSbDEpVgmla2fwzQju6X+AgVHPOXK0G3XvnTHL+TPDAFyPXxTm0UUr8VVA8CNQx9VkI/hY/FHVWTtbVtqBYi5PrDkOn7UtBPkzm0SB/0qThiee8Uq8+odqrl3eFdttcucXWz2ne9jT3GWbdO7uyr0diO+m2P2ltJI9rB97u/4J/mXrYvKo6pd7JDhaKRwyfe9Z/hLsiHtZvyrEgFLjm9mxopcqNxNxig+VSkz8ks0iMo4a6k5UC5Qb2VtlACQX55C0R3CvwN9eD5Qfl7JNv+yKWG/ULq0lhEF6MJYtw5G2Ua9JxUiWT6gZpZhS6cU5aENX6gHSqOG5XJEPWRb3m64+0wEVCzALbpxhF2pnxPZm62/fkpRWG3v0dil/EKIGvKwD7ihczldcGotm4nDjsDkAeYK0y57bmcLelxkM33dEHhnRj7Lyyxvkzj6P+E1EkmPEjMhESBmtDfDurftu3Zxehidh4G55GxiCI+o/xhzTAEh0GZydySWqSnY3jgi88bJJgw1UPOBy+8morpG2llHRzOPYGvW85k2dxwQG/fsFhZHjDEEIkO3huUap43H+0WDE/BOXiVOBYCU3w1rcImS+AmP2ikuYTdGb13LT9IZcJFbI7F7myQSSpj71qOPDa1DW8+RFv5GxU1vFaLRlsp7VVRHTfZ9LKwsxSQEtB5F6IOpIOTpBCq0AFN9MuQ5SGx9rMYcelNkj79kCrxHqjsQ/9g0rS+qRl4NlpeFd22DF6MH8J/S2BgiRQYmnH+aPxF7e0AkEBKRFONgvYUfgygKhsuvC6
 qMUT1igD
 iwtEmACcTKigHr7rUE8i67ar546jdkV83+kDGTz7FmF2VmZnaVjBhXQ8rb+1iJHgo3TRavGSaZZkW70akjCiSiuYvtYp9J5Z+y8ai
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

Fixes: 37a260870f2c ("mm/mglru: rework type selection")
Suggested-by: David Hildenbrand <david@redhat.com>
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


