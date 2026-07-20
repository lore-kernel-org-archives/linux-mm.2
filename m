Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FFF9C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:52:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685606B008C; Mon, 20 Jul 2026 04:52:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635AD6B0092; Mon, 20 Jul 2026 04:52:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BF96B0093; Mon, 20 Jul 2026 04:52:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E1746B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:52:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9740316075F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:52:01 +0000 (UTC)
X-FDA: 85008537642.28.907F6C3
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by imf02.hostedemail.com (Postfix) with ESMTP id D0FF380006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:51:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=DWqG8oU4;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf02.hostedemail.com: domain of chenyichong@uniontech.com designates 18.169.211.239 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784537519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qwFdiigprnnr+PXeMatxgrhnDGdTJlNK6vXKjM4agmU=;
	b=32/IL7wfywCYDjJ4fnOt0OuEH/xqRU10qLYjxMW3DLpPuZKBaunxTp8cPNIM+DlCYddDU9
	fhysHNUtw2/4lENFj1k4koxNntCM2msFHzMrEGjioJhrNnNKMis8F6oEaV8qlepgw5Sjqw
	sbzj+2mDr99Gs/Kl5ftC+c+mLUFUVFo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=DWqG8oU4;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf02.hostedemail.com: domain of chenyichong@uniontech.com designates 18.169.211.239 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784537519;
	b=jRVSFVam1bExdxchoqLuucb1OW7aEx02JASex0pb/pnas1mt3sOy47voezGTUsoQmYDp2g
	mii9CZI9eGwqVY7jdOeA1izr5BMGWzIn3Ooi0Sjt3MWxEHVCXYoqVM4C2bQtm3+WUM0cJB
	T22Erf3Y61pYHjXxKswGHtbuxam2dZQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784537434;
	bh=qwFdiigprnnr+PXeMatxgrhnDGdTJlNK6vXKjM4agmU=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=DWqG8oU4Qm3K3ng2oxPuV6Ajskl91wnEtDu0nsfiPjyLj96XJJF0tev6uqa+Cb/sk
	 mVK92h13cPbajqtywjAt0adYDHCf0vCRdx6vq6mXdMkX19nTyBpLlhpo/DF0MVA9aJ
	 MNs4mpksGTKT7R5reVT6u4SXAwBQ+eSqXRfqvRH0=
X-QQ-mid: zesmtpgz5t1784537428ta2b8478f
X-QQ-Originating-IP: WbfTXFU/kDf3z6rnhpLug4tdERftmKoz3sfgvejAQsU=
Received: from uniontech.com ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 20 Jul 2026 16:50:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12259026264893774996
EX-QQ-RecipientCnt: 9
From: Yichong Chen <chenyichong@uniontech.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Barry <abarry@cray.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yichong Chen <chenyichong@uniontech.com>
Subject: [PATCH] hugetlb: fix subpool release race
Date: Mon, 20 Jul 2026 16:50:24 +0800
Message-Id: <20260720085024.1392261-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: M83iEva+1QDBMc0d6gBK3mGcaHttUzu+k8lpp1/PT19Z6x1nIJwEFSbb
	mRmoTP1bsUQrlO0eYD7jQb6KHdvVDABc95eQcov/LrH1VS0ZL2LigOYm1VxtGBng9DJwR5X
	rymmlWBeFG2GPjNR1zCVIAwcboB8rxw4v5Jy8SAAy/9p+iZ5AsJ9sGUyISExUU9kD/pRnfW
	wmW6z7iUIjGFlxUunAgeYdv33CfmwAVLEkmGyT/dOmLxkp229WhTd6leVg2klQU9CkI/1md
	uRdN3BvsdClxR2ia7MyXvKMoeIelOyw5ppJ+5t3Eypo8FznaiO8/ZKaPvaKeS6tMJsSpNvD
	A9tQxtjJ4YIkEE5+QPTBSEMQwsqjtJzlj/UrOR6Rzf+vQ3qmibjcAUvnd3QK3Yimgo+BRlk
	IeFSf4Fz5clfupnC439e8D6zSWKR1I8gbBg0mnmaCfxO7wlfcejw6oU8h5SH9hywZmVtTQx
	nVRE+F0TmPTeTUa70mfjWIyMbt0gZLgTKNX8q5G59cdylHcVm1/oSl6eJtyE/9Qai5iKh50
	OoubDDuL8aYbUI/ItFIEvOYWRPb4IDSVnJxDX9NCpwp2jABOEN2j6Bx49DJmLDUR93ee3C0
	oDDGdVIILComINOwSgPbpMGMVhfaCzQfOivaOOJxMTz57KQINu+2Et3i/pmehCf9RYeulUj
	NeKFjfFwBgZYeFjvkf9q3Ex4kfy+DSsUzz3BhhGdY5I9pZhxIUYgfqshzsV7rGRtDCZlGOO
	LqY3vHA7AexmTqc7GNvxXIH5tr28cuKOPoqPozs9hDas1zExrDRxapxTC/USuJAtGZ5Fqgz
	6BieZ9OdC2Z287MEzqrL4w41gmnQT2ysbSRJQNju1C+QWmVB13aLh40N9nRC5j9qzZ/glvn
	rxeZmq/99A75Nh7f9iaXeIEC+iGCRE7MCffPdb3vdKJQaX2URDurV9nlcXTcyI+m6xKshck
	O73j42B/0p4t+i18q7Y7cPd2nVaHq3h9U6sI1vG0K2ZK2HJmpoPBppwvxuItvPa/fwcheHu
	wBzFaftm9tHXAwWXBVEtiLIW4Fh6Wez26NXRPSEA==
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0FF380006
X-Stat-Signature: eiqt4yiomc7hzzyjdtsmmdmp5c6jbdap
X-HE-Tag: 1784537517-296398
X-HE-Meta: U2FsdGVkX19B7F6d7DJhjfTmzHxDkjPT4zZfrodx59uRoBGAwt3Yk+DE8l4MGwdyWzq+jLSUJassWTxJS3wx9vxCFXXUe8b9kUJ97BrghVhX35ndOCalbqLhFhzxLL/ruoN3/M6Tj7N9dRkPhkhhjL7sBxAeooM0RzpzF6gFJgyflM6JqMIfU/PXroUUJN93/upveDebDbpGpnVa6RU7yARWJDQC91wrSYax5jfZR/jmN0GIZ1HuDoxmfXTmwfPKGGlt4Zc06At/RJSKIZx3MC6rggKJ53jSwYsRlzxXCYoMGklwbUCJDZTYgr73045dJhBWVjvn5rFm/uzqD5Rubaw7T3c7mnAIKcovmxCQoOPTsnBAaN8X1lP3VlAoZw5ruRHnjIk58vV+7j+n8l2ogjBJ1wg8FBE4ls3sy6jB2EL85pgBZwTBankchNj2CnKkpxuBJR0sX37TTHJ0Myc9nUC+MlExOd39lec2gKAYBEvfwz8cseQfs+8bGvx/5Sl7FsUG0sZPLgsVojM03tG9H6OGpXR/y0015bLLagm1y9ghS2USyf1DgGepuj1N4uSLubywNCAQR+gbX2YbWUHsRw0jYajQrFN3q2zCU3p3+FLr/tErDxDeEEhMUypJVmDZCOA5tZ1L9rAF1ttiNhk/5rZHrfJdjvUn/Qu4b2CbQ0NLOwK7oCcQ0zCfZdBVKRKmrTsbA4ZvMkWoF2K6pPbkiV6cXWByiIQlTNRY70umvJvI4EqCSJu8MUtj2s7bY/jg4Dn6JLSD3qyGbZLr4iF8c6C44CcsD+1ONyupBAJsGFIEzYiWC06rfeKocmHdhufYNxA4AHgXrDb7wVyBlK9L8npIetZOAMLFBsERpP1EyACG4QEd6jRD4oGRtD1xc1VRPqbRHC3EhqPhcT9DbVGKE+D+7L3vESLYYrV74vlHXTwon3RNsMCD5+cQfy53aMY19o+jVoZ8+EuWYSHwRDU
 oAsa/lJ8
 y4iwr9dO6GTQQAe0XAtc+I8p4bpmfX1+SZEAyOWik7fN94g9AuizBh2HS4LsBPFnSEOkUTq/veezQGL6JQywuJdCh1koh1Z2prW5BxEAmTDBP1H25hFeIq+UokYa6mPE6Y5VSqYH+vIGpaPUwxOjQ4EzI/mBDHbUF1JBwlzZzy68ZhIS9NVqH2cZKo9E8+ULqLwhB+RmxLJ1MLQUmzSl1yzDqwCsBj5xbbIzpjTAfZpEEQ7D/olpZ0WWebQVbyhXtOpXeQtc/XRAf9R9pY56VCGOlgz+niaVMMj2Czx970DFDRCR753pYe7Bhejfn/mz7UiBMxgGH3XCtKRa2/iIdPGhskxeREkUc2v71
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

unlock_or_release_subpool() drops spool->lock before checking whether the
subpool can be freed.  However, subpool_is_free() reads fields that are
updated under spool->lock, including count, used_hpages and rsv_hpages.

Another thread can update those fields before the first thread evaluates
subpool_is_free(), allowing both threads to observe the final freeable
state and release the subpool.

Make the free decision while still holding spool->lock.  Keep the actual
hugetlb_acct_memory() and kfree() calls after dropping the lock.

Fixes: 90481622d757 ("hugepages: fix use after free bug in "quota" handling")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
---
 mm/hugetlb.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e319c6a00555..46ab702c0fc0 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -140,12 +140,14 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 						unsigned long irq_flags)
 {
-	spin_unlock_irqrestore(&spool->lock, irq_flags);
+	bool free_subpool = subpool_is_free(spool);
 
 	/* If no pages are used, and no other handles to the subpool
 	 * remain, give up any reservations based on minimum size and
 	 * free the subpool */
-	if (subpool_is_free(spool)) {
+	spin_unlock_irqrestore(&spool->lock, irq_flags);
+
+	if (free_subpool) {
 		if (spool->min_hpages != -1)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);
-- 
2.51.0


