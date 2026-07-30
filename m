Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE86C54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 01:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2886B0088; Wed, 29 Jul 2026 21:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0733F6B008A; Wed, 29 Jul 2026 21:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1E06B008C; Wed, 29 Jul 2026 21:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAC776B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 21:58:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4FDB2140894
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:58:25 +0000 (UTC)
X-FDA: 85043783370.27.65F0994
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7460540004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 01:58:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=I3WAuBgp;
	spf=pass (imf07.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785376703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mz/vF1+MIOcbgrfsM9T1ETaqVlnKJAEoM6Ierr9UBVg=;
	b=x2LUTZfdFe6sJIpsmxYWtL8z5Ah6VuO09RkydPznJFwKj1eo4KbPtMRZH2TZW5WmQbZ9c4
	PXxuRRqJz+UxFK+7LWuc3zmhABhLROz0Fldq5AMfh9vjh2lrsYa0P0EuXcgXQYBFsUvAV2
	E9mIwD05EDQo+ONWqlcYWkgKkorfziY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785376703;
	b=F9t0dlfurZmMQhMS7jJvuSv4HI1n7qPWEBCk9+O4nrQFM2OVzsGXcYLvBQKEUCmIwyyHj5
	k3Mzg+dMoX8EqIuba3AFh3MovsyjGFpV/EDjOfEQ+CGi8u5gl4V8+27Yi7Jh5p5JJB3xwM
	ohNwCFv17lvj9vrFswTLg18ngLaEzjY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ugreen.com header.s=pkvm2402 header.b=I3WAuBgp;
	spf=pass (imf07.hostedemail.com: domain of warren.xiong@ugreen.com designates 54.204.34.130 as permitted sender) smtp.mailfrom=warren.xiong@ugreen.com;
	dmarc=pass (policy=none) header.from=ugreen.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ugreen.com;
	s=pkvm2402; t=1785376699;
	bh=mz/vF1+MIOcbgrfsM9T1ETaqVlnKJAEoM6Ierr9UBVg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=I3WAuBgphak9hUgaeKMyhtkbytDBA1vCsfg5JIPDtvqilGi+sa/TJhXVnUJdhldbU
	 jiBAvSOrgri02LEwJV1TMKnxOVb7ymsrBoq8JYLO96ErUneYDsbLunZAz1b2DYx/b3
	 Hd9SOtxY14oxcc5Agjb3OaHi1ruxSNCgvKaJh7bo=
X-QQ-mid: zesmtpgz9t1785376698t57f6e66a
X-QQ-Originating-IP: TuP62bFv3KNDgy434RwiwTPgF3ZWAnB+uhMr4+4GS4M=
Received: from debian12.. ( [14.153.244.156])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 30 Jul 2026 09:58:11 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8791580703209932218
EX-QQ-RecipientCnt: 4
From: Warren Xiong <warren.xiong@ugreen.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Warren Xiong <warren.xiong@ugreen.com>
Subject: [PATCH v2] tools/mm: prevent page_owner_sort from truncating input
Date: Thu, 30 Jul 2026 09:58:09 +0800
Message-Id: <20260730015809.3819606-1-warren.xiong@ugreen.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260729053812.882137-1-warren.xiong@ugreen.com>
References: <20260729053812.882137-1-warren.xiong@ugreen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:ugreen.com:qybglogicsvrgz:qybglogicsvrgz6b-0
X-QQ-XMAILINFO: OO2wLqYBHUeBqYBJX+FmDYsGhQm5jdjufCNlyEe9+ASipmMkSPabawEk
	KAqwFwnZZtja2/J75CS3YVEOgz+A2L/msdH+CBqPBT/Qn14hewICz4LcgxmFdx9VVHeEjoT
	nyjxkt/+hmiEwTCS5k1xSBOzh1k2rcwaU3nKss7QyMi+l4pfpwh7kGegOhDDOCfz/TdZ1TF
	M5LBJ5gLNULH16VrypA4LdCNwqOyHXVVCMlLnH7u3D10CFIjfnKDcur6nkLgMY4wnVCQzcC
	QrmP2wx2dFWcYZRM3XleFMD5u7l03+twhGdj5BKF43ym2/4wt/OyC6KVgsP5FtRae+JykO7
	ahhsuuDs2shyMcwBcHBT9qs2M8h0oaXQImACsp/PZPpBJ2rFh+6Erioha0ZHwhlxy+RLMsD
	IuJCAJDjWj4cM9qRtOEP57/QdD0VuTkxBDT2knRn9RM2OmHr47mft+Uvsyzwz3tTNZJQKeF
	k5bdGIX1cT0AcidI6b2JY5Amk1ylbTR88Dr5oFNfhwJnygPOjUEYnUECoZsRteU6LFqsItY
	SWuN0Iy0FBtbVzPdlOt9yF029p4Clf8irlqqENnzs48vvBCSxQf+5NwJe+3tyN/vQ/6QSi2
	WID+vkaJ4zG9qMvj2gayYj/Tb1g8OGuXrrRpQ7+AuI6ZgvVR0Cq1Qki3P/NkMlq5XaeTU0K
	XxgdiC6/6LMKRgIh2xOa3Rk+/ywvqwWhl9JWngs4tEOgRxC4LxH4dfTfzYtc68GDiFt0DgL
	4631fQFv9fYC53/3MI/ZGXkRuEtmngIO4d1Uno4CvTb0rY9l4B5z5GmJFpltV+pHBUUHxkU
	yKHFe/tUWXU9f/VHpWL4r/OGYr0BCLvpi0UyW/IkElfgJmDaQplznNOvjNN+fPVGcGRHljz
	2EMKjyRWLMT+CO3M78rbIrLI+0iFR2pgE2TKXYAv9Ra4JhNkDwfYweYFSBfq9P0tuom5U9G
	hAZ52fyh5Gtcw0h85DRVnWnhcZsgUvdRWm76zgFFS6DIl34Ia3YyTqqqefqOlM2CYX6K5BC
	Z+GCDsanB01oeGf21FdtapzsxLP7nTxHgLe0lE6duJvqxDYSRB
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7460540004
X-Stat-Signature: y1owcbsw4jck45gijesiihkrwumsco69
X-HE-Tag: 1785376702-571307
X-HE-Meta: U2FsdGVkX19ANhtSy+XNFxyzrbZ/KtUmEuXZZJPFtoeAC+jiGktnCqwI6RjDGwV0NRz5Wu4K7DzR3UmJND6FZm58Viwisc2Wu491COhooB8OllZZCnUVT1Q87wpF/ILIDXEI0ACnzKenL+/++1wn9Ft59NQoYfPX4ms+CmGe0Rurp1/inx+qUbSYcmuGBInSAi9ix2L5Gc2ojHhPMW7Bxc6TX85tZcLlKCkNhJYB5hu9FcvVJpuBXRDmoBw35Iqy+0nA6FX6pyUN9g+zoWKOKgIhGJIMs63Y7X7r1Ora31o4g6Po4nlFcepjMB4TZ+jcCJ/bh5ORkUr9DFyLGx2UiBp6lS7gsgGuQ/cIs65udUWA2mmxloV+Xr48we6r7eWFzB7DQZHyHLXHBoMrxwnxiGYWnmlmyT2OKr/5/sieSCpqBtDudGfFmqwrGCZBz6xrQwt4qJz86WMR2OpOEAcdOlhWQR+W96rhmtVaOdMw3E43sTEAxeJtV4QwM820macsP2SBh4vZUQ8UHCIMgmPymIuR//xC5dkRMbq0klFSqxFHXGjQOMVlC86/jZL6FtNW4Su30Cg3khIw9DY97mvmahpraDWFNpF2PUcwGulMU6MaS1le8wL04kM1XJutuazMe1S6HLUDRoaxHIHOBCEQEneWrcbma232sDLhKAg62dURqucZvEWMqw+eT/plvbult50B7fDWmt41aDwORCP7OI4j7O31LWz/DY+ZZhiAU3pnFXRaJSn1MZzGG27d0nGFwJciNb7Oq3Gupc2POxm2JcwfrAihBoyW4o0H29FyavTpfNuE9zxS7I0XqSrAkxurMLh0ThFd99RyT8mmn3MO8f+kGBqphZHCwynMTlRh/7GeRBCDVxrkFK1919kssmHMgA38KVDpQnmLQNsMSUTSYeux/YU7qtvyc2v4yy8NPZ7YgvexCqd/4yyCO8a7DQ3cXssx83yuObWhv/MIm+N
 NE5hY3ri
 6qdFsP2QbVkihIVSGkOYUB12XBvKrr+4Y84uLb2e2rIBcZnJ6uzm8l8f93wOAhe5ecikpfaubVyGa6cm9dzBSwVgKxbtcoDMlMvW2A3SVk2nK6Dwoe/EqDYUbs9kaZ6tUF9BCfa88r6CutRm1d8Pq+62aNUJheFhF+HhWlvJWew4pErV08KVVh1k3TiFuURsvzwcE4YZqe0EG1Dzyk3jq/SgSUWHVeEIEUmKwxF0I2e5E7rWzUu4i4gZB3T/OOzk7sdkH5dDEysYG8dNcWaeHYNoqo2fW0CTUhvkzxH2o7D0Tf9Ijl2p4o4Xd+0lr4kxXZEU5IbuTNm8moelNKylxkw0hQL0dRSMoFNZYjYLwPQFpfre9BJk2adn93KqAQvQpBNrYlaxjHwgF/62xDMU4gjWXeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

page_owner_sort opens the output file with "w" before reading the input.
If both paths refer to the same file, this truncates the input and the
tool silently processes zero records before returning success.

Delay opening the output file until all input records have been loaded
into memory. This allows the tool to sort a file in place without
truncating data before it has been consumed.

Signed-off-by: Warren Xiong <warren.xiong@ugreen.com>
---
Changes in v2:
- Delay opening the output file until after all input has been loaded, as
  suggested by Andrew Morton.
- Allow in-place sorting instead of rejecting matching input and output
  files.

Tested with distinct paths, the same path, a hard-link alias, and a
symbolic-link alias.

Link to v1: https://lore.kernel.org/r/20260729053812.882137-1-warren.xiong@ugreen.com

 tools/mm/page_owner_sort.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 35d3d2549..22b3b500d 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -836,8 +836,7 @@ int main(int argc, char **argv)
 	}
 
 	fin = fopen(argv[optind], "r");
-	fout = fopen(argv[optind + 1], "w");
-	if (!fin || !fout) {
+	if (!fin) {
 		usage();
 		perror("open: ");
 		exit(1);
@@ -874,6 +873,13 @@ int main(int argc, char **argv)
 			goto out_free;
 	}
 
+	fout = fopen(argv[optind + 1], "w");
+	if (!fout) {
+		usage();
+		perror("open: ");
+		exit(1);
+	}
+
 	printf("loaded %d\n", list_size);
 
 	printf("sorting ....\n");
-- 
2.39.5


