Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACB7CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3C66B0092; Wed, 17 Jun 2026 09:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88B2F6B0093; Wed, 17 Jun 2026 09:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1A56B0095; Wed, 17 Jun 2026 09:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 572B16B0092
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:27:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1E56165FC0
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:27:39 +0000 (UTC)
X-FDA: 84889481838.07.D1EB44A
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	by imf11.hostedemail.com (Postfix) with ESMTP id F416740015
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:27:37 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=BhJJBEgU;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf11.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781702858;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w8mflvKn0NMwTjHgJdfiDm6HNouGMiUgC+mp/yHQj9c=;
	b=ybAPm/kIKGMFGfte+/l4deWBENLuOvITaxvfxs35M4irbsUmPN/U7e9XK8vBicznrOFKaA
	pa37zGFCIFprpII3MoHBBOSIt5WV6nYAAuRlnjUfdZMoTCcIcALeSbUBU7LUfc6QrqMpSt
	GCYMjVQFIYMYD7QGCKGCiSvYNph664U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=BhJJBEgU;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf11.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781702858;
	b=L7xdLcrJG0pQRqHx4/BXWq3Q+YEotWN3bGU+WQvdo/e3K9hEjvx3NdJmVTytWJRc0NT1C7
	+Yku+sZ2yXhka7KoYjL0XkTu2DQPLdpEb8dtxsJzOIW0rPLxxPiyt8ls808g3Rta8W18L3
	/uKJLniHXMW5sOIErG6kOw5FjSANi0I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=w8mflvKn0NMwTjHgJdfiDm6HNouGMiUgC+mp/yHQj9c=; b=BhJJBEgUkQtGyh
	h3uskq6LDevhoOYkBumeSWmNnXczdCEJ/itr08K3UW6TEdhxQ7MyiQ9rmTf7Eyas3GVfmaMT7ajyv
	7RivJR4lERk4RkOsy+JeBCnXg+NnNG10c/4GVrQTZnKl43INWhnDCLI3MyJ3S/Hw7KxJ6wLM9OU/o
	a8/cOkoDByhRCKqczmKK/WTA975dAJYPviWxpywa4BVvTAoZzZPiVWoJq8bXrWFDnSt9cIRRfpsZ/
	TG41bwav2YNrv0ueCvJgGReNiFqATZqUtTN/R4Z4IrJjwOyrIf1o8U5fYDUtU1I+dWYaisBYbJ39z
	G/JB4gfOxoQQrZEc8buA==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1wZqIi-008fSe-GT; Wed, 17 Jun 2026 14:27:28 +0100
Received: from ben by rainbowdash with local (Exim 4.99.4)
	(envelope-from <ben@rainbowdash>)
	id 1wZqIi-00000004Yfe-15Ox;
	Wed, 17 Jun 2026 14:27:28 +0100
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] mm/page_alloc: include <linux/vmstat.h> for vm_numa_stat_key
Date: Wed, 17 Jun 2026 14:27:26 +0100
Message-Id: <20260617132726.1086576-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: jbpma3tesat9887uf9w36fmjo9ccfhcf
X-Rspamd-Queue-Id: F416740015
X-HE-Tag: 1781702857-435388
X-HE-Meta: U2FsdGVkX18/Yjvj+Ufoi7ve92uqcBnhsjAr32HpSQWaRo2z5BWYCXbVpFhTPmZr2sDYMcYyfYuHchapJ19lWnM4uxT3t37njDe9kg9VQXZ5nW3e/mYW3P78Nr8yM+HuH6Ge+QY9Mk3Owy6ZrOkZiU/Z91M7L3oRFaYiBwuay6nsmyPahK95MwFcQVIjryR/B5zSIxm/pmhH3ljPKffcAVcYNNdU1xkVZsKW2EOFYNEkUxGA1wpAiI0wC5udTh3CAVFYb3MxHD29477Oh4AINqq8GyZF3ZvxBUnUyrzyEb02p7NAhP0IFtRfitzyj39lQc7nuyE7oM5+Gi7CLAnAy+4MEQtwTv8rPfJ+d/gtE1PQZ+yJRh/9rRPEXxA5ZMNnN4Y9g/vnb09wBMEr5ZaXtabxbvXStqFtcwwMrJY0gIpByYfbJaC5OA5uFNU2L3OQ6/gWj5HoGFqFvgUolL7XvClkOTcuaNnpWq5yf5RhRZQEGhUG7L992b9DjDmzQe6/2BqYp2dnhwx+zJiwYZNixEHbphDjJ9Kgk0u+xuHm0R1wJyXRHFU2hxdrZg2A79K+jBTbUFkXrnSEWvQcqgUtDsgEwuWHLEpe85sd4fQX0SzI9nvBi2u/9V5Y210K9ou8Ue77p0XPgLaeF88LN6VYKZXYsPBT4HiZgyu2FF22CCSpcwuMNXXmsUJoO25GzU8+SqdecL1paWQQQYwASP1pNY4+Y6FZI6k5x8GktQ/FAr4ncLuCRaxQtX0EgCegokuEYJXJ2QnA7Z6SOMGsKKAJD85tDIozwaxUSF1xBK12HhJ7h/p/7flwI0Mj3LX1nXMmG9kp3hh2NQa3VLyHb56Y1M/96G/mwJHw8tcWnKm/tXiZlQXFWEPUt1TC0slGcJEBHD6qGHD5BNMIzaaXxcrtG3mq1UpkpxbOQviVhmqTQ2QZNJwwmi148ZPJbbeuKkz+0R8M0FUA2MBS8jlgcDW
 /pt7BN3I
 mpPJSwqdxs3lF3Gvfur90vZyJdNyf6LGlC+E5Kg36XrPlEC9n8hu4xfa+Bs5tYylwLeEltBYagCsr6iArZ0TSSLWIB3m6mK0bkp9585ftA+vQvDL9aK1AFkrq9ISz5Rdc/UtZEqxtuhQG6AFHmO3+Kpve8RbocnYRukcz5Qh9Iw1Q0OKKNGGFrx9EVwr7gWQE10JCvXn9JoJqES/quzqHE82qdezVTujuRR+vG6WhP9yT8kSKH0DvAmHR2j/9Z6Pi6htLoh6397Ip7icmi8rorRN7g6fsYvHuMkwcnzmtdJAyQcYq5WGfuBKuq5UHSWo4iWrvsJjxlKqkSgUROpYFtPBqUWVi6qUMwRE2uEj0JmvC0sambqKB975v7sauyj9znITxfrMj5HiSdB8sYqqyj1XdzRHMEArgzZN0ARExG25A1Dc4O0+L+pGNBuGJn+Oay4kxyrL1Y3fQ+cnCSDcjvNo74i870Tm7vK13KNJYNDK8Fi+HeK4F+r9FLN4cDhx9cz/0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vm_numa_stat_key is declared in <linux/vmstat.h> but this is
currently not included in mm/page_alloc.c so include it to fix
the following sparse warning:

mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d49c254174da..58aa960a8dd0 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -54,6 +54,7 @@
 #include <linux/delayacct.h>
 #include <linux/cacheinfo.h>
 #include <linux/pgalloc_tag.h>
+#include <linux/vmstat.h>
 #include <asm/div64.h>
 #include "internal.h"
 #include "shuffle.h"
-- 
2.37.2.352.g3c44437643


