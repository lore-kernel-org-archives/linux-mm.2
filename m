Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F84AC5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9DB6B0539; Thu, 13 Aug 2026 12:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390DA6B0541; Thu, 13 Aug 2026 12:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FF06B0543; Thu, 13 Aug 2026 12:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 085FC6B0539
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9116BC01EF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:18:00 +0000 (UTC)
X-FDA: 85096752720.12.EA479FC
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf26.hostedemail.com (Postfix) with ESMTP id B4574140008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:17:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Icyie6iqKeeeM/yHnGjppFziBJm96uBgX62zqkHxlaY=;
	b=R7Zzj4tzC8kkgu1AsBBRq098ezZHHMqv1ZGtCqthk3uoLJlBpkvC9AzgvYqUDZxfF+JL6V
	iDhFAMcGpNd7Zyqbr9UybGbE8NuxnFNOfMH2lWbhor93HsOLchXtA3zA2r6j8WqWB7rJNq
	doQ2VTg73x+ssIFBC7zC6776FCm7DcE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637878;
	b=o5BqyTTbj5Mc7xBlCWF+vKZyBgPi5PQg/xfVs8scgD/w3CjCh328zXkiohOUqZ5KWmlyh0
	gXpAwLKvBAdikL4KgcNveoU7mLoNGeypQ6PdJ0BQvDcdv0X5kVCiDiQHnxLXrc/P9E7eFq
	S8Mgq9n+tJ4+8zXeDVveLMfkiqs6nYc=
Received: from localhost.localdomain (unknown [111.196.241.250])
	by APP-01 (Coremail) with SMTP id qwCowAAHofQt7n1qad57BQ--.20463S2;
	Fri, 14 Aug 2026 00:17:50 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH v2 4/4] Documentation/mm: describe SLUB previous lifetime tracking
Date: Fri, 14 Aug 2026 00:17:48 +0800
Message-ID: <20260813161748.76447-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
References: <20260813160825.73031-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAAHofQt7n1qad57BQ--.20463S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WryfuFW5tr1ktw4xuFy8Krg_yoW8ur15pa
	9rGw1xta4UGrn2kr95Ar1rKF1Sqan5uay3CF4UKr48uwn8JwnFyF4Fkrn8ZFn5AFWkCaya
	vrWvv3Wayw1qyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9S14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gr
	1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv
	7VC0I7IYx2IY67AKxVWUAVWUtwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4
	IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1r
	MI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCV
	W8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_
	Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr
	1UYxBIdaVFxhVjvjDU0xZFpf9x0pRLIDwUUUUU=
X-Originating-IP: [111.196.241.250]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Queue-Id: B4574140008
X-Stat-Signature: fu7h3yaws93z9xn3a3tpp1oy1sjtidyz
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786637877-338028
X-HE-Meta: U2FsdGVkX18dGMGTsP3zOqoIuADcpn6+ko2XqfPZS5L8SX0TxNMf1HrbMd551aJ4DzxbRA7rEqF1TRq8PgJ6TyXpW5Xb0wcge06uJTXW3rjoEeio4/Q1sjdTmctbZjss02JIlyI8ISqqxIGzCNogbWxkf1Y7Rdle0hPCz8X+xSZbJGJFXLX4GNot+SCWv14vOJnG5JDAl9dJq9jk+Lfh3MejOLkrE3ehZAp4b2MKFaADGM9HALa1SZ9ypjBmXIEjnAZ09M9jtqH+X8Ac59TBrsymToSFOVNTnrff3XJ6HDZMezYkhnnmqs0nhYw3PP+KCXEPjFqD5aIdLnBzsnz8lwoKoUi4JHqPaO0pax27ViBk6v5JrkJVx6ojqD20UFDIYZYBuVTWNwjnvf7+e/KbmTqqzBRmSRfgaDF+QoxMqwOya1w4aVd7OmBWy3bH1ytgpoUmGAS5U5xe1RKIzfqT7bDmlLQ375oGwE5TNrvqf/HmDv4cA65iNHjqanTkbl5sLgWyuCsEpclLdDT++pftp6uHREMhAdC47DXbPxm1G5MI31Xosa0rWkaiPvgUCkM0cVqZe6whMPYF2QE46e5VOhSreh0bCIYiHwkUpD4D+gakigvOpg/fAVtCjmDkcAdItYDg+7H4/5jpWE+t2tSNGjRdywcmYiCn6EWbJDh+BQmZ0lGy1RKwoIAQIavFwxWinK+nGkNs69TbUrkhcdrGSEy8HsrmCiaFfoIK4KZ7+SrpwS++DCavNlbkA1PPLuC8n0czUgqSl6QFtRw7GbJJeS0lZNyYutJI3+bgUrFkGe3bhzoG+AE4Crkfgya40wL7dyvlD6TOlKgTZb44ZBkGl24B4SGVL1CG5HskG3kiQP2IMlqzIg9G9J5xpxIMTwdmM/LJUSm3y9AdrElZifoYB/VmOB8VuIGw1FzL7YFCRNOCuYuYsJabbRk8wYQRnmPsnnkkc9A3f/PpPJIFgtb
 Ugi3hCQ6
 WMe0Cd8q96mKtEOii4qKUdCgu+7ffYITuHvtFERC60bNbRQRxraChR23ebqfU6rOGKEmIc7lcCCcnFiIshmqRxjxfjZN9fVvdgGCl/xSr5NWv7S9tfEMYH9RU3s60zAGokqeYLytNB14n2UHGKXtawvc5U9IvSPLKpXNg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document that SLAB_STORE_USER now retains one previous completed
allocation/free pair, show the additional report section, and state that
address history is diagnostic evidence rather than semantic ownership
attribution.

Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 Documentation/admin-guide/mm/slab.rst | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
index 14429ab90611..5f60904b1e0b 100644
--- a/Documentation/admin-guide/mm/slab.rst
+++ b/Documentation/admin-guide/mm/slab.rst
@@ -49,7 +49,8 @@ Possible debug options are::
 			Sorry SLAB legacy issues)
 	Z		Red zoning
 	P		Poisoning (object and padding)
-	U		User tracking (free and alloc)
+	U		User tracking (free and alloc, plus one previous
+			completed object lifetime)
 	T		Trace (please only use on single slabs)
 	A		Enable failslab filter mark for the cache
 	O		Switch debugging off for caches that would have
@@ -245,10 +246,20 @@ into the syslog:
 	cpu> pid=<pid of the process>
      INFO: Freed in <kernel function> age=<jiffies since free> cpu=<freed by cpu>
 	pid=<pid of the process>
+     INFO: Previous object lifetime:
+     INFO: Allocated in <kernel function> age=<jiffies since alloc> cpu=<allocated by
+	cpu> pid=<pid of the process>
+     INFO: Freed in <kernel function> age=<jiffies since free> cpu=<freed by cpu>
+	pid=<pid of the process>
 
    (Object allocation / free information is only available if SLAB_STORE_USER is
    set for the slab. slab_debug sets that option)
 
+   If an object with a completed allocation/free pair is reused, user tracking
+   also retains that pair as the previous object lifetime. This address history
+   can help diagnose stale references after reuse, but it does not establish
+   semantic ownership or identify a use-after-free root cause by itself.
+
 2. The object contents if an object was involved.
 
    Various types of lines can follow the BUG SLUB line:
-- 
2.50.1 (Apple Git-155)


