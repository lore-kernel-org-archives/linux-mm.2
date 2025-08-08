Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A96C3C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 07:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EEFD6B0089; Fri,  8 Aug 2025 03:21:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6F66B008A; Fri,  8 Aug 2025 03:21:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC686B008C; Fri,  8 Aug 2025 03:21:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 109296B0089
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 03:21:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1C791DED80
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:21:35 +0000 (UTC)
X-FDA: 83752744950.07.D6727CB
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id ABF6F40006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 07:21:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="A/LmYE1L";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of fffsqian@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=fffsqian@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754637694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bWqffEK1j65V+npFFXubrmYzyYXvK3w8H6N6TmUJh1I=;
	b=hRTpNXlQEVo23oyHx61juyhbym9V6Oado0BizhwAnXdT6gcn13ykrqvQ/ZR0RDcKDuCXhG
	AG+Xin4SUFrTIzEGQyEuKAz3BLFqbGgObYCNZ2xKmr9O48MMqOy6nouuHObKiwEGUgmMMA
	V/aAbqa9A2/Mxi+FznrWDOHvPz51zdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754637694; a=rsa-sha256;
	cv=none;
	b=1KDdZUrw5usQFCU0tuFv4Qsq5kgc+5m1mMXTcoyeY8FQCUKGIgxs/Wn5fXRDH5P3UJ6ttV
	N35AiUVQRRORGFIgKEYHLJepAYa6U2gdo/7Oyb9xMYn/vs4GjefkA3WRzr8mELB34PswGE
	Ghgo5BFmFBg+Qs7tB/q3HqDaRxpPd5g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="A/LmYE1L";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf11.hostedemail.com: domain of fffsqian@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=fffsqian@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version:
	Content-Type; bh=bWqffEK1j65V+npFFXubrmYzyYXvK3w8H6N6TmUJh1I=;
	b=A/LmYE1Lr2AH/EPbHWBzPuUJBPAXBA2e2qlaL5dWvk4nk+awljuVwXmnecXeo/
	rfpWREg7fjgJv0dq9ZfRVOXJuXHepgiphXDko21Fpw87IKOctVLLXK545orIEsc0
	rjEtJrOA9rLkh1Bn2AQICjAW+F0XMbuG06omDyO0WUzh0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3_9NlpZVoS4MlAg--.6902S2;
	Fri, 08 Aug 2025 15:21:10 +0800 (CST)
From: Qingshuang Fu <fffsqian@163.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qingshuang Fu <fuqingshuang@kylinos.cn>
Subject: [PATCH] Fix the data type inconsistency issue of min (tier, MAX_CR_TIERS-1) in read_ctrl_pos
Date: Fri,  8 Aug 2025 15:21:06 +0800
Message-Id: <20250808072106.153449-1-fffsqian@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_9NlpZVoS4MlAg--.6902S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw4rtw43KFWfAr43CFW3Jrb_yoW8Gr4Dpa
	93C3yqk39xtwn7Kw1qvrWfAw1xWr1vkFW7JFy7KF10k3ZrGFykta1YgwnxKrW2yFWxX3Wa
	v34IkFW3K3WDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jUeOJUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5iii21xldqqiywtou0bp/1tbiORSjymiVozZI1wAAsz
X-Stat-Signature: f4atgibmqe1c7sgz778ri854mgume9eb
X-Rspamd-Queue-Id: ABF6F40006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754637692-526892
X-HE-Meta: U2FsdGVkX19/CYW7oN7hFj+zl5p5rEWue3QYTkn4ZtZV5KjePjjGmjMoqXrC8qUlauVunpoGCHS4Gc3mjYC0aTHj3CJSh03p1PjbcRlvUt/0BN02+lIyzNBN+nsGOiE3IKS020sdUhDSgZ1kFx7XmNnW6sH7RXMuYZFSiOnn2F0fol+Tmmus+hYV8GfWpbg7gPR1d8pCM1XkSM7ECJH1WAlFV5wbgWvROS92NcCa/kpk+xs+EbIiJN3510L6VwTjZQprEyIpLUxKgXEAR9d4EAJjdhm9Ggj+uUbwvq8TMLiUZvr3bmKNmSXGXqOblYqckrf89F9atxvkOsh4+1c18yI5LVD4Os7cYhIMz3uYOR6XbSZggfFjEojP/HY4lbrSPYc0yhGnHWx2H6p9MNh1PSXF41Pi2YE0xc8Cug6GeSQJBxeLui8PNeXkATzICxXiQpsk9thPIh0g/pewe+AjYQZ1Resq/xRxbL7DDsS0/IBzOiFUpT5VPm9o4Jn/8BZXlQk43OqSl/SDgNUdbo0QxxL5xTq7eRv9zhDLljN/8AwBZoCH70JarLTaDsky4kC4WEOCJZCmgfpkfu42TXaeCDLard2BkpWDAelbuV3oNhe1pfJdqDvDXk1E0u2O+T41tN4U3NM8MUUuQPQz+dIJ5fYtbiTjyA3hZ8UmPulqTW/R+WEbV6p2enEhfPcB07mcbDeKJDm2VJp1eMsqQRa1lObcozyGFt2OxV7Wb/FkeuYMaIeFDO0gd4K+RSk6z3LHPwNq+/ZNzYVMRhDPMvMcb3fsgHFWC4Koyxj9JzByo6B2lRiTZYRgczPbgsqyjK3Kld0ONAj/C2EZz9P8ReaWF4uB1T3teGKTLT12XKAnHQpn0DPmnGZNR/EUcNZ6FbSQyigDzcbhmCClkYgLeIKaBtxOCGJeP9izleGBuIUJ+k+yThotBwfin1NDTYkDEyhtREEb1LOymc4xUpeD62q
 TaBxz9DM
 WHqSRI8VM42E0D+/+XeNAvFaOzWNts93F2keYht2IjIPOMSv+z2T47yxrKkzJ8IxXxggFSqL+TJBk7S806kPoxtP+J+kW/XjJbu2r9ksMnSgwMVcgvCIbF3F8WBMFnK//46cH8rcSUjbpmZwfRBsaeFAbv6ltp9eQlApjF4GrFciyFgbVXydN0y9kbyDvcKHlmmeyYseB9/jwLr50PGrYF3yoNDajRLfu6VQ4Ktno1YxXSl7qtZP1dXCZDJy6XR0umfde6fSRnPG+9GRNEwEWKyQRkbbmUN7kykGO/2/yssi3HIpJa9MvRzpRSqsGI5q1QiX6bZHJDFs+WpJyqLjmMWBQ3M8KAaS0MxXGLKALkl/6b7i4z3yxF1cUwQAcIIrmcOSfgkXgF4gb1skXhMgm1aUSV0XLWY6gM+Q+8uMna6RsBuWCvYJbDfPSxf22xW72f2KEEgK0JVBs3eF8li4TSIEuqF6QlIlDk+d6
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


