Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38985CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EAA26B0191; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995FF6B0193; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D2656B0194; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D98B6B0191
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:36:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F322E5ACAE
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:36:46 +0000 (UTC)
X-FDA: 83818404012.13.E2C55F2
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC64640009
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:36:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nrMAKG99;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756201004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJ3nbOWerhjrpDMiqY4o+NaxmH89+vOJFKoUh/ymCog=;
	b=KA8pZ8EmEod5hIxng8GEZFZWJnoUBLuP9q9eUGypcd35sr+6GvlLN7B1YGID2jqftPcg7W
	C6dAloi5Pr4E+64GiI9j4Y1oTTheF1sYbrAadnTxyzUvXgVxsE4Wo+4zaSsYF2flg4DxhM
	f3sgD9M1+OPJbGv6kygkFXvsiJM8Yq8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nrMAKG99;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756201004; a=rsa-sha256;
	cv=none;
	b=OGsr5+Uw0NxsMMxbIZt6sxD4fNUaO4DRG8oIQ/ArjBQwM8Cr26TsF3It1QG6fxwvVTOBjo
	W7Zaxd8UIavA7wll9gUBdwXbHASLbnbN66aqdXE/8gs323BlEGuygQUCtT/qw5h20mlWCf
	cN27XUif5pS3ugPwkhPrve+YRxUIKho=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756201000; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=tJ3nbOWerhjrpDMiqY4o+NaxmH89+vOJFKoUh/ymCog=;
	b=nrMAKG99yhnEBmwKymQiMPFE4T6O4l4EhRnkL9Zhlh0NgmwNbH15sTdark8ChQf78N/tIRgrKsbXb8f1bQTVjGaJEjXgiZqDz9xpJIGNW3RqDcwtJIZeZkAg0cvzcqPUOvt18eBWDES4bcFl5Z1uI3NtLDgtdKAsw9Bb9pTZX2E=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmeSenJ_1756200998 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 26 Aug 2025 17:36:39 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: shmem: drop the unnecessary folio_nr_pages()
Date: Tue, 26 Aug 2025 17:35:55 +0800
Message-ID: <67c80182ebd949e3894908e01e224697c143aabb.1756200587.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <a2d39608d99cba1130cacd9cffbafc6949193c08.1756200587.git.baolin.wang@linux.alibaba.com>
References: <a2d39608d99cba1130cacd9cffbafc6949193c08.1756200587.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1stqo5n67etpzbgq1ssyk88ab1s8zum4
X-Rspam-User: 
X-Rspamd-Queue-Id: AC64640009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756201003-209124
X-HE-Meta: U2FsdGVkX1+Wxfxg2bo84o6XmIFDDpAedeNEt4ZLUYC1jU58txPPm1bQVBjQhRhU7papTHYDyWBlPoL7Xg4fAPsROooZ9obYyoFb7lfLL2oYgz3adT7S4yo3DY5JC5aHn9qE14rm0mLcqtD8/qAKnvcFFV5ABKUKJVwV5MShfL6DEUwYAlP6JQ5f+gKK9e9RFqhzT0ThZOgY8I4yMVV7/bubPb4oheEswYroZ/WR9dCOAjKcYzzjtsTr67eCUoJGQT020fhoXPCRtSxUaYzKKqn1zRG9FhMtIdxtjZOJ46CscID5+/lu6s/iE1KwGMvlAGCokdgGK3MrANvOoIqfNoo8tk7Oetyz67vzl5c9cOQxtSOfq3ZSMPtEIYgI8aduCybdNT2NaruVCKoYBxncDmweg1R4GRMfxSRKOWOAJ9DO6/FFrsTawr4v+Kxvpu4rTMD7pbxgFq4sAFhbHTQs1mB7bEfT3LKPlNiJupzITwfEVKcF9AvTgx3wCZ8mKUVH99AkI2V4WkHfJTI465gO1K/8YP8iCHTX0w3YuFENi/RQmku1YRmpWjzjRQS4nX0sM/qU6//PTlD3ZNQ9nVf1D3oTt4V4boGizUWzyv+IXTAWjFkkTuK+prGPQ8Pmd30gDU5Cmy0kX9RRL2259UqX73KmaIvmHe9TNsQi+ErDLMNfXHyVvSVbdebOiTMVJRpP9biB4Y8jzpoVmVT62ti65zkIR2QiOmKi6SYXa1zsThME42bbenwpZAdP/3SXM8hR3k37Kj91EZIGKB95btvEhbSHXMaxi9dJH0grWHBxHbMmNG+SNkFSNrDO81/GsC3QdQ/5mvBL0TaFsSg1BOUanUJsK2bZ6Ervw28CXEFzuINawmmVcL5LouvFZE0gdmhZYhSItAA9gchnfhIYy1YgbXEoJQdAh+AaNtzEuiWYWyvCwIYJkv5hx7+rOJhG7eccgRNo22Ix1/OyX/xyCYF
 yXym3NdU
 BcpnVga2jzjmsD8MIqsumUUfnbevYtgSmsZ4WQ5+CYM+sEsvfEyHsLUvYTjRHLJsYpqpU22wdkXRFCUU2j1xfUYiZ0LvKLIYAbx8HEjrj6QMd2XNOsQaS4FXY6Yb0q36k3VzLZl7EwpFSRX0Eg3mh9xRUh3zabEDju4Gmi4TAujM3HgRdKbSpuz6fl6/xt0Lxm2HK/YEV0HfggAIqvGziqJoSoNLVDrEm7kF+KbUAdUZi6taq0DXsUqe/wxORhKrTiFcYij6kS/9+KNyh0dWOG/w5baw2lxMhH07ycRJ+PoIZ5EM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We've got the number of pages in the folio earlier, thus remove the redundant
folio_nr_pages() function.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b3c6de84dd27..f45292bac32d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2430,7 +2430,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
 		goto failed;
 	}
 	folio_wait_writeback(folio);
-	nr_pages = folio_nr_pages(folio);
 
 	/*
 	 * Some architectures may have to restore extra metadata to the
-- 
2.43.5


