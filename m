Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFFBBC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88916B0092; Tue, 15 Sep 2026 11:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F726B0096; Tue, 15 Sep 2026 11:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9DEC6B009B; Tue, 15 Sep 2026 11:13:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1AE6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1ACA120457
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:35 +0000 (UTC)
X-FDA: 85216340790.09.CAE62E0
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf08.hostedemail.com (Postfix) with ESMTP id CF81B16000F
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=PxZXa6YZ;
	spf=pass (imf08.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485214;
	b=2rdIOIzKuR+RkimQYJOQPXtAT+YqdX7A1Ogk9s1a3pcA6PYm4dnTjHO9Kc+xNlWhdkW6az
	NxpgDwlI4/oVOlRwivGzOfz8YNe2p3eK4rhPWHnGPaH9Bk7ihICZZkEl7zuf9q21y05b8J
	4/L1Apyh4K9YQ3gmQKidMdrmSikWkmE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=PxZXa6YZ;
	spf=pass (imf08.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzjjP3sMaRbt1nIGZyrCw0oTAfLtKcqQAE2afGv8ruM=;
	b=4KQVEe1SjG9R/98bcP0FnqHFfWt7nCCmkDvLXI20kfkZEIEDQmvCgJDKwUxSGxCBP9DuFh
	WLjPkMPtr2sRA1ln7gtV6UOlL5bEZmbgfy6wAhtkWmDPyuVt1PRsLf16zcz0HxgtAqC/E+
	TBAblhXqzWDz5a9xEQdrJAhgcAE0o50=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=wz
	jjP3sMaRbt1nIGZyrCw0oTAfLtKcqQAE2afGv8ruM=; b=PxZXa6YZ8teADp7KfV
	AqBANt55a9rfnNffg55Wpvejk9AqbXOqaja6NoX9OlDFchABtk9QA0dqOYqxx40c
	qAJI+uTyS4DyFg4EWObY1QuntJAe+gIKX+LlxiBwulxM/+ExJMBWLsfgUpTKP6Hr
	HNg9ww8Q4OBO64P5S1pqmHY0c=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S7;
	Tue, 15 Sep 2026 23:13:21 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] mm/ksm: make remove_stable_node_chain() return bool
Date: Tue, 15 Sep 2026 23:12:19 +0800
Message-ID: <20260915151236.5200-6-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S7
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4xXF4xuw1UXF4fZF4Dtwb_yoWkurg_Kr
	1Sqr92grWUXr4rArWDWrs7Xry3Kw4DGr1UJrySkF48tw1UXr4rCrsa9Fn7Z3yUur4FkryD
	Gw1DAryxKrZ7CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1RVbPUUUUU==
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC3BFBOmqpYJGacgAA3s
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF81B16000F
X-Stat-Signature: q4dnj1jn8wbk3skxinofmj54fzfg886b
X-Rspam-User: 
X-HE-Tag: 1789485212-116428
X-HE-Meta: U2FsdGVkX1/nZYrvpaPjdtcg4zQjUkmrFEePI1jleH0oAESf/pHBW2APNSCjmgNy5MBhoiNHJ7KYy4RDhibUY+GVg6Ras7tCeZAF5AWN1kEUytRR2ja8p+V2gqy5vV0j33b1XuKWhINcupPkyPuMuvvhIueKzqT2luT2ynEIHGdSPV2E6lDF0biXntQfHqsphsP1vSqWkZj+bTvRmyT5AFQxaGtTx9poQlFZ2Hh4puxz+oYFCCWhL8NHdvBdy6MKZ4e49NO7ca6kcL55101MH55cpSdKoA8E5RevfJCe+aSZx1S2jq0prDiicaVSLY8R0w6RYyOn0yVEB9uSMtoi6sZ+b/+sjR/qitcMVVJxnv5pIAM93/2vSWiU3T3zYr7CeU2Tb+NoarrJiC5kZitm/sfP6jb8zXugv1T21gZo4goakYGb8qmVi01889f/7rf82ayQZtyPPypohYCDE9wDcANW/slrsshpET2XDk5FGQRlt3eny/yaHhAG+NTuNEXwG3hQmsT0i/krUau6lCazFuILy4ZwxZO3d93nkZtko9dULJ8kn+4zofcPvqkW3SEWu2NC4Ibe2ifnJLFPBoaMZL8o04xzhxDAJcE9o0XkHoDApAOSfYKpJt8TfFzLASAwxvMPFRGEE3Ze453wc8Ufe0r7TTHZgLCser8x+iijmJZMeG7F3ZrD+zgSX/abbLFqI+cH5zFIFbXLDv7VwW0LSuwpI/D64shAk57Flgjh0QZDKhGXmB7QWmIYJ59JpJG0rotsJdXd/mIbcCrIlFLjsQx+VR1J/ErH8ZvU4Wo1G6T+nujnITN5+lfOMEKjfIyIWxErD26Y4YYUPk2/f0QMUEf1jgWtNnYU2moZqs7LnWBfFgaV3sazWXSwqegQFeoO6A3st662mDX05+Y00feMBdhI6NQvKEj0dY/fUkpxEjqHMm9obHo6tD8+mPhOT2nIYLmp4/j1bZG0ZYnPyHW
 sqlUCqX1
 01Kf3MQAwSJlBfZTvSXeR4TwyDB0lqOKmZTajo0gp2f0vX/D2JeJDtPMfh0QWGOsaSdvKPLIdFUC8StXsq2btbTkTjF2rtNd7QT6G6u+63QTrydVWbUbOk+zszVj0gAFs4R5NRW8u9FnUHqjmiyMKtvbj6KTFTqxyfETSJJJXtUeYhipgsfRkReOi0ZXv0br/xFHqTaByuQ6THovU3JDKDA8JDUyQ+TnuU2tYOUa9JUisS47yKVPIdFfC2yrpzySsthLJVsK6mfvFBVrfjORhI60k8/1kpP407B2F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

remove_stable_node_chain() only returns true or false. Use bool and
return remove_stable_node() directly in the non-chain case.

No functional change intended.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index aa33522627c7..99f0bd3a1ae3 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1177,18 +1177,15 @@ static int remove_stable_node(struct ksm_stable_node *stable_node)
 	return err;
 }
 
-static int remove_stable_node_chain(struct ksm_stable_node *stable_node,
-				    struct rb_root *root)
+static bool remove_stable_node_chain(struct ksm_stable_node *stable_node,
+				     struct rb_root *root)
 {
 	struct ksm_stable_node *dup;
 	struct hlist_node *hlist_safe;
 
 	if (!is_stable_node_chain(stable_node)) {
 		VM_BUG_ON(is_stable_node_dup(stable_node));
-		if (remove_stable_node(stable_node))
-			return true;
-		else
-			return false;
+		return remove_stable_node(stable_node);
 	}
 
 	hlist_for_each_entry_safe(dup, hlist_safe,
-- 
2.43.0


