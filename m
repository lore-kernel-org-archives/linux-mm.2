Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6DBCF6AB9
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 10:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE6C6B0092; Thu,  8 Jan 2026 05:15:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431A56B0093; Thu,  8 Jan 2026 05:15:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3309B6B0095; Thu,  8 Jan 2026 05:15:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1E6756B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:15:47 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7605513B690
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:15:46 +0000 (UTC)
X-FDA: 84308390292.24.700D132
Received: from imap5.colo.codethink.co.uk (imap5.colo.codethink.co.uk [78.40.148.171])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C8111C0009
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 10:15:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=rZCB4ASo;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf20.hostedemail.com: domain of srv_ts003@codethink.com designates 78.40.148.171 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767867345; a=rsa-sha256;
	cv=none;
	b=gQbNf2kAOFCifpCTbfI66jt6AdBylmK9GOdGOUBm5JMizLpijtyXNJ1d0qTbvkl8RV29mt
	uBo7i/ta6EWC0d1HJYt07/fuo0ReSJ6qZDlPP9fXyTtfOzShdKzLpFb5bdDFrMJNpUv4PL
	I8t+M4dR66oL/z6XXdBLJ6RS5zU1x5w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap5-20230908 header.b=rZCB4ASo;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf20.hostedemail.com: domain of srv_ts003@codethink.com designates 78.40.148.171 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767867344;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HcBErMuoKxbW8X5+AK6nWr8Q6elg3ttkpZvtiCgCY20=;
	b=uzBmOeBsrwzuJA4hrIT7g4s6llPYXMatTXQ4VxsFIL9JQfHyo4DTH2yMFEbTHO13rOWe97
	nhY0fgBHrYB/igN5x527O4pqrRFlVaeSbOyQH2WtxeJNeAOeL4bENIEuuCLGkZN0tt6ZT9
	5q7JmqTP6P7EY4KEZf2s/tJ+9IeQw8s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap5-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=HcBErMuoKxbW8X5+AK6nWr8Q6elg3ttkpZvtiCgCY20=; b=rZCB4ASofsI14v
	k9Yki6MT2f5oboMYWNKL8DEmVg1h6RocVQnfZ4h5Gf0tihZLDVCTF6ZM/eVH/qXdhwZVkSrPrkADC
	PDhA5bFVYHPdJlW/PMQtTx3K8LQvflpF1jjr46tWJWlJv+GnamGqEPqwxh/WDZlhY+NNK1e8QUl2m
	zVYFKuzK2MbGw0QNdgsT61OH9TG6GPS4A0cfO1UjOSplZl5LuAMOQ7+wIsImmTzwZQJXHZXs6/TlZ
	yOCMUK42wlF3Lb4KB/n8ie2mHcfwf960x9jQtK0zaHAs5g9Jd/of1FfXXqFOVQkl6OiEEkV4Y8Z94
	iWqbu0HIOnWCAaMoqGtQ==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap5.colo.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vdn3N-00BWZO-QW; Thu, 08 Jan 2026 10:15:41 +0000
Received: from ben by rainbowdash with local (Exim 4.99.1)
	(envelope-from <ben@rainbowdash>)
	id 1vdn3N-00000000xcs-2HO6;
	Thu, 08 Jan 2026 10:15:41 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: akpm@linux-foundation.org,
	linux-kernel@vger.kernel.or,
	linux-mm@kvack.org
Cc: rppt@kernel.org,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] mm: numa,memblock: include <asm/numa.h> for 'numa_nodes_parsed'
Date: Thu,  8 Jan 2026 10:15:39 +0000
Message-Id: <20260108101539.229192-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C8111C0009
X-Stat-Signature: kwepc6kqe5chuqtcudgbodyeh8sgf8ny
X-Rspam-User: 
X-HE-Tag: 1767867344-544260
X-HE-Meta: U2FsdGVkX18cjA9M7v1hPkYG9k2aAjiNVRj2tokS7MP/DK5f5mqAhnwwSE3ecI6dVEiB2JisEIzMQzzot3mWb9s4onlNwWydRKKur498ceo4EEcsEZpTnhga5qQR/F6Btc+5KqBUDg8RZ7deaGTUp3c5w+2Ih/wLNdXVkK59/DiyXl/OYVlIqlIvUbR7TqHQaVADZE1wLVyW229Ao5ia1NdQOFiTsnaHA821b9EwTS5FbQ9G7g8zGT6cX2miXZHCPmFif+XPJjWoLjfwi8x2JZSPCfiLVfFf0UlN2oLLB86JnUb96ne47+7Y1r17FQbu6wmMNjxxOg7TWtzdb2PyrdtXsmjoHFcdipi3cqBMua0f7w4XCkZ4GIq9P9l6MbKl4Zla3JWLib9Fn+lSzyRagDewtGshslVMFc+ky7vtBECt60nSJLGK1MFGnQMxe/PD2SxV6yJw3zSzIYhZE6aq+HrFor/9LiUxLND7GXBJF1Q4vQzJDa0sQDtagGGViCv7+cWgYGZQmel7xwbsBD4LIeqOvNQmve8JBYqUKr7PprKaNzvosFgZyQK05ooF0M10PE6q0KIokXjjM6C493BaBQ+ygqXnoNgn0xxgTjhGVvQnDXnWczJYLKjmqAE9MUXFQU5pzINFLOu/kgL05hs3QfXc/eTvvNrQQaEdpM1GXaSZW3vtHtBXLR1D6utvsQc0UCVBcvfGuW+pA7MUVJVEfZpIsZZEFAazhxhHTbOAXsHVMlhm5pPm7sxmTVJJn5lOb9y0zsWlb6XMQy757bLdduR7pB7DMhtm9KERzG0LLumx/21lwTcS9z54ZhPE8Tk/z9+rU+/E63ssox1ZLu5tY/uUNYA7WPVRDB42ZQf6XGCQEsl2B8GhRNl/rDoub7Xubw+966WHoU4fR0+iPHAWl6H87i6bwJ53Vh/xh1fB2N73nnXpak/dCRwi35LKPswxy941eA5lB8whk4MNRXT
 TI9xx3bo
 ysjGndFGih9mnq3kolr/cUaxIqJB5CIYx5P8i/w+dbQLMAs/5M4aEmIySyJKVuzvS/lcu7BhI4eKj9qCAjCnrfZA0gImjttEA7PUwaw09esbIOqaGh+v5LvfwTerku8gGpmLpPmaFdXxrgfcL7/2lHSvbO1fbKqgjOMYax5YG36RvpfnSNKHhvGFXu4uamo0x+z9TsRvgJnqfo57HTxx7xPLZSV4n4ZgYFQMPiHXOdYW3+v0POSN6f2mS6jBBFY3BvMzN7v3/WY3PlH809BZtRkaMtAWdU4duAr++XgLwLB43HwBhfybUh2aeRobPxwGIXb6RwyVKnfZc6aTnOHaN5v6plFQd9T3EqOMsCDYmSF7oBwEnhhFy9iSB6b27j8GADLhzRzcNpyFH00DEbgteUDea+lE8N9Mka3cpPVXCa15YUyyeJpNPqwxEahcHhE43eEx2VpxWsZqFG9DtrVr9NNwIsRuxtNZtoB33dM507ZLnimYCPvCYhSeHbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The 'numa_nodes_parsed' is defined in <asm/numa.h> but this file
is not included in mm/numa_memblks.c (build x86_64) so add this
to the incldues to fix the following sparse warning:

mm/numa_memblks.c:13:12: warning: symbol 'numa_nodes_parsed' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 mm/numa_memblks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 5b009a9cd8b4..8f5735fda0a2 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -7,6 +7,8 @@
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
 
+#include <asm/numa.h>
+
 int numa_distance_cnt;
 static u8 *numa_distance;
 
-- 
2.37.2.352.g3c44437643


