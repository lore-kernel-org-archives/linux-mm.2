Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88B5AC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 812256B0092; Mon,  7 Sep 2026 21:42:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C3056B0093; Mon,  7 Sep 2026 21:42:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC186B0095; Mon,  7 Sep 2026 21:42:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5D46B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:42:29 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D0249A4626
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:42:28 +0000 (UTC)
X-FDA: 85188895176.08.E204157
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3A68B180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:42:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AUnNf7HB;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788831747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vuvYXO2zojXIeNrpcLKcQQ7TtoojYysUTPVrrXSxdEA=;
	b=iVM52XC+zaiZkWXAcI2bA9W6gNfOTPRQ3fxzxAXqFDzmAJWc3dbtROa0SmWkfmTOePbjxB
	NxTMEYcdr/rEKQ4m48jCXEx31AuQ0FVOaqMRzvN0H53sY0dPo2lrUQHHQf7WQjMRrM0kRM
	XQBxrnmBpbre4cNdZ9jJnefRSRMyPQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788831747;
	b=p6UKIE2JHYE5jkiv8lJG3v4O8Kos28PdcduNGPSJqWxIEvFnrfNFsFrFGooNbhUK42nlGh
	3Tqk5SvBvwQEKo53uCxQLB31EubRYWSK6IwCrtwyZQegKuRkeo6WwjTlPLgSv3hYOdzxsy
	Xi7yle4OXooKPBR3MN49qfjOJL5cwzA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AUnNf7HB;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788831742; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=vuvYXO2zojXIeNrpcLKcQQ7TtoojYysUTPVrrXSxdEA=;
	b=AUnNf7HBwr3WGfZMyF2QzwSodkpW8sLItlkMNH+WD9j+J4f9lA1ZGGXPx0jbljot0ZVvWcvcLix47pMG47K6USyw7sk8uL4R0kBboIhgbYL8pGlSQEiYti/Eh48iTP5T81xm9wylFAWzrge1oNIUgdN17nQboBhSgiziLDosQAQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XAZnZlP_1788831741;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAZnZlP_1788831741 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 09:42:21 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org
Cc: kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add Baoquan and me as MGLRU reviewers
Date: Tue,  8 Sep 2026 09:42:12 +0800
Message-ID: <06e20ef4f603a4ffeafcdbf623ce2936281457bf.1788831480.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3A68B180002
X-Stat-Signature: d6xsx5ue94x6yb5rht9798ews8yfyejf
X-HE-Tag: 1788831744-481941
X-HE-Meta: U2FsdGVkX1/6PZv4Kiu1eu4C7uou8i1YMJ3a+vA1LyKdFxpH6xNBmqeLDWhrmVOmgmTc3KP+qpLpo+Z8HomPvYQSaPa4hGo9jCl4LOQ2o+EaLXbwcDTKvAmTk+SZ7CCtfhiiIsx/NYjZJjWaqrTkf20hP6BF+9CvQhxdjiePxxaTDcezfTkLY511uRHOnklX+S8aWBzcDjoGnDVeTPkSqFKRd0q8Dai+W/Un//kxfm9O+W2PImKgGEKdhI7umu4U/unh6ruCU9Rn6yCK5fltmwfxs0PTXDvhnfyCK9UT2ENairJjOGtUYG6lEg9aCIhPqu7pKKEcpl4ls4yP+3OpyuunLT/jHxDW+kHyDx2FTP8Mccd33FsllDl2g/olJEJHpbhu88rUdtWxm5cEbep5UxXdFMGwlNQghRThDXvNnNGqIZcJfvj9x9aBpuOGZCskXWn/0PkP3fdBKptmUsN6jowl8pAfwDuga1ftNo+rWK//gEGH5dgzeaebJ9a27Iyk9ySph6AocotD1JjhIatugVC/HDxd/Tqt25ibPjuus89bSgdxLMSjdRF5/8xPVz+lclyoKIcpb7Hz6MIHAL3k/HDnYdqasTpfIP5Y3diRkc3gpnEplgQO/LqS5Q32WC1inj8cfxNywPlq1TWGyz7z9XHBn0rUxpp4CJxewAFbFDH2b/5E1KwlTuLH23iLDrM2AZNHXZf6i8K6v+9DJT1L6ul0USKUox3YY2Evy0wiH2lartJMAtJk7r8JZDsxjmFD9TaLVwZ70gtCkrr1s9XG/qtR9tb4P9ckQk9HTeCT73yFEY0OX/YiXPSiHKk/WGBwZYRUeASxN4Wfo8ehZYY43L0S5zkShZ6LOICOr9gWef1sEe/PKF942bwzxDgK7QXF/sUgq/qSNzfQik02zFuSpmq0RgWri8WsAhI9s3KTBEO8r3iXUQuI2zBB+CNRTP4EYTP6rGDI5waBEt2TZiC
 vWAaDm0l
 C6KP3Y+wJCx+Dt+7zpdtTuLLa8Bu59rjN4NclUoqJ4m3ReQ9p0CtkuuPk4LDDi+FquBRDV3PcMhbWEyMu91ERp44FO6RWkIQk+eL3WNBo4QIkb1+hSOdMV+nPek0u15kDnNwxgokklE7QM7qLSe54D8qkEAQ3dGtA3vNM9z+7fwMa+xyUpZ1XOappIyvZ7vuj1180OnhaB8iAGJ2ydVCWkJrFTSF4Di8YIBMYMNRvHq6lAtSx6RrIMbVQD1VHFP49qqH7X5DCAScz/+W3C5rKbyqU/yLDvIAAKwWaWfPk55GoicCtotYY0QCjtD1Aq7ewFFi4PkJqgwsKYWXGbtA4uHlZvoyFzkQop8yi65EXxt+/uLcga86NcwvQKLJyXnQDjB5d0577zHV5AOCGJO88LGVJgDYQO17nVbvh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Baoquan and I have been contributing MGLRU patches and helping review MGLRU
related patches for some time. We will continue to follow MGLRU changes, so
we'd like to be CC'd on MGLRU related patches.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4d1ff4c76496..c558d5370dd0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17242,6 +17242,8 @@ R:	Barry Song <baohua@kernel.org>
 R:	Axel Rasmussen <axelrasmussen@google.com>
 R:	Yuanchu Xie <yuanchu@google.com>
 R:	Wei Xu <weixugc@google.com>
+R:	Baoquan He <baoquan.he@linux.dev>
+R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
-- 
2.47.3


