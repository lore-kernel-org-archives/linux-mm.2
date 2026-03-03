Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05040EC1420
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4658A6B009D; Tue,  3 Mar 2026 05:26:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E87E6B00C7; Tue,  3 Mar 2026 05:26:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311B26B00ED; Tue,  3 Mar 2026 05:26:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E5606B009D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:26:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C876916037D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:26:15 +0000 (UTC)
X-FDA: 84504371910.20.9580AB2
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf04.hostedemail.com (Postfix) with ESMTP id C78EA40006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:26:12 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=F9IhknAA;
	spf=pass (imf04.hostedemail.com: domain of maninder1.s@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=maninder1.s@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772533573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=km2T1rE1EqUzcGBR3V84tNhU51XF5smkUTmXLYFyBCs=;
	b=aaKGohYVwaYyYRdeBLbaSqLNK/sLVKLxMU5sEiYNiohGwxESdl9XNZDOX1MjXlAMqQCuAS
	QRTo/jJVUV4lS/4wX8JiNbb/WjnsIzBzGvWXfIDa1gtrxgj3E2XqrRcaAxZVFZ/JwNrN5o
	z6EEQIqXs3iItgT4Yqv7GDYIbsam310=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=F9IhknAA;
	spf=pass (imf04.hostedemail.com: domain of maninder1.s@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=maninder1.s@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772533573; a=rsa-sha256;
	cv=none;
	b=i4/fTGdxuDTdZsDy/WI/gfLUjkNV1OKZ1jgSJrEYz1Y72kTw2Wmr1LUvoEx1XRfXpfJvCI
	Nfbzldudc7BA/h9IZsj8/571wihUdUxLAb1sZ4RH6RlccOEBCkewfjvvrboWAq16VtEbF1
	OdcUaMlgY2wwBEuRxC2LlWUpccg6Ubo=
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260303102608epoutp0168db362126591d621986836a7d661df9~ZTeO7DOHZ0355103551epoutp01O
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:26:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260303102608epoutp0168db362126591d621986836a7d661df9~ZTeO7DOHZ0355103551epoutp01O
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1772533568;
	bh=km2T1rE1EqUzcGBR3V84tNhU51XF5smkUTmXLYFyBCs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=F9IhknAA/ENcmjszQLuLRmMPgBRoIltW9EbAoaUeu1uV8YAYTqSZCzHMWGj+E01Hj
	 VXkxZsj1oJZnZ0PGqmzzHvkqSyT65W3/4bPAYejixcXrWUc1Xn38AcJnJC8lrjKSkV
	 +wNMAL8Z/WMWtEZu3fK+fYq0/jaPxMt2WYNoS5xc=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260303102608epcas5p21d0cdb900de04845ef980ba2eddbc3f0~ZTeOq1qJ91927719277epcas5p2z;
	Tue,  3 Mar 2026 10:26:08 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fQBm03pjGz3hhT8; Tue,  3 Mar
	2026 10:26:08 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260303102608epcas5p159cd0ad7dfd939c4a67fab3c7ecd7bfd~ZTeOav_dV2101221012epcas5p1B;
	Tue,  3 Mar 2026 10:26:08 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.97.243.203]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260303102606epsmtip164b0c8d2353f5ee607eb14611f142159~ZTeNJLWl13124431244epsmtip1t;
	Tue,  3 Mar 2026 10:26:06 +0000 (GMT)
From: Maninder Singh <maninder1.s@samsung.com>
To: mhocko@suse.com, rientjes@google.com, shakeel.butt@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Maninder Singh
	<maninder1.s@samsung.com>
Subject: [PATCH 1/1] mm/oom_kill.c: simpilfy rcu call with guard(rcu)
Date: Tue,  3 Mar 2026 15:56:00 +0530
Message-Id: <20260303102600.105255-1-maninder1.s@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260303102608epcas5p159cd0ad7dfd939c4a67fab3c7ecd7bfd
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20260303102608epcas5p159cd0ad7dfd939c4a67fab3c7ecd7bfd
References: <CGME20260303102608epcas5p159cd0ad7dfd939c4a67fab3c7ecd7bfd@epcas5p1.samsung.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C78EA40006
X-Stat-Signature: gp16e8d74qwnbowo4s5cgr947dajjcek
X-Rspam-User: 
X-HE-Tag: 1772533572-210227
X-HE-Meta: U2FsdGVkX19fU6MEKSruzxhUXRIzfn2yTIEl8AWEol1VCLx/DTkAeYf7rhsOt9n+abKpEco0f056p7gnpDF3nekLsQFmAH35xk5u/4GR+PhiT9JDlYJa9E6s4XTfP+fmGG/i/+LCKeN+rcEQYZMNn1E9EsepzpZh1eCp1Op0qe3plYKjXqUenobZWPytZyC+5v047eG1j+Ed2Oj6WSMKx8Go8rAoejsEqDxkoy5k5+br26DsmaKzMk+ZI1tQkT7thew2hQ+Exuc6yINWDazFDNP6MtavIFczNFmYi+I1XbDN2Ynh8s07Kf8SlVYs6EpEvoEoOjOxchVtCCwA4z3O3S23Fmev6rKRaBmcF4LsMm2lk5s5lgA5crw6niCoI3q3cXFCOUAN0pE/oT4ZvshB6Nm5gXHKNrf42v0j+C2/bIE2YwSddwuGMc0RJZJRd3ZiiuHFfVzrqVguJEc1aNe5sFXXKYHCkraN4zudg+dVhwHGUJD1uULImkMuGIOjaDbdzqw1OUy3aURUYf3S163qECGuW7cj9qDPzSga79Awgf7+afP/CuLnHahYBzgCsMf3xKiwuISNBHIJnKTRVGWDufQXEE9GRL/edsu1AWwj4u8FWXzP9GkzP0foXhwfBNFTxGcpOrbqoVVv+puoDjlmBgpToME5eyFqN4NY9amBQ+L8NlP9hugQR33pKYNuVqfiSK2MoLi9XBSch+TjI9UEfGZ7XSP6JXxWc+HXaiw8jlkbB0GCGtlB4fmnJvay+VyKOmDTj0H9S11PHu6Quc7h4sFTOZQBxjXBCstc3rB93YxOfq9CM1rexN7tT8KtgaulymvSXauFDgjfXP7UBatpLUPeMt0Dg7yOkWsEA9PP2tQBnkoB7SWkKd+M6dN4of0Fxf3d4XM9OcTEtIJWUff0pe4HDQimNOj9GAmrcACXxDfaCxa20Z4dnn78O52w06NN6rVpO96L+sO4lDoPpn6
 ERD1fXAz
 +KKFnuCXexIdFxN/kcmSly7D/YlAvcBSO1x0C+MVxxnzBTVgjvYaq6zbNDla+n9+EndV980Ly0IANw2RsWR2uOGsrIM5YDkcM2C7pXjgF2hI+MAePxmrYnJ0apRxKSCawumv57eSXNIRoTezraMJyNKIpZuIF/z5B0iPYpNrLSCw2TKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guard(rcu)() simplifies code readability and there is
no need of extra goto labels.

Thus replacing rcu_read_lock/unlock with guard(rcu)().

Signed-off-by: Maninder Singh <maninder1.s@samsung.com>
---
 mm/oom_kill.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..9e3e88c06ead 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -135,19 +135,16 @@ struct task_struct *find_lock_task_mm(struct task_struct *p)
 {
 	struct task_struct *t;
 
-	rcu_read_lock();
+	guard(rcu)();
 
 	for_each_thread(p, t) {
 		task_lock(t);
 		if (likely(t->mm))
-			goto found;
+			return t;
 		task_unlock(t);
 	}
-	t = NULL;
-found:
-	rcu_read_unlock();
 
-	return t;
+	return NULL;
 }
 
 /*
-- 
2.34.1


