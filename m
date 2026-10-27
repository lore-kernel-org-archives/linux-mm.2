Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A70E60A2600
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k6+zS+vG
Received: by kanga.kvack.org (Postfix)
	id 1D11C6B06E6; Tue, 27 Oct 2026 08:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A8796B06EE; Tue, 27 Oct 2026 08:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD786B06F0; Tue, 27 Oct 2026 08:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E41356B06E6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:20:46 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72F82A075E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:20:46 +0000 (UTC)
X-FDA: 85368314892.19.341F77B
Received: from mta1.migadu.com (out-168.mta1.migadu.com [95.215.58.168])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D1C7140007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:20:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k6+zS+vG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3uHNkIbz1W2hVmZzTNOsS0vwkqrVetO/PC31U24Oh2o=;
	b=dUnGErX2L/oq1MBiMSeZ6/wyRzd+xw1ZPcOY2/e9vnpDXZeRr6rr4exMHIC+SCL9gEEBk5
	je1gXWNAZVV8bvNi/mPItqR+2BLSW3hraiMLESAIokjmpFnC3+srcn0LICMUiaAHjUj92C
	1ShC6XTMQ+sHT+gLv/3E58CrBX3uT20=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k6+zS+vG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.168 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103644;
	b=1lijLd1sYLxkZgDy6Q8X+BRPPb9SZ4mhMfxyn9mpbUCewhiplcm/Op3qO0U3Dm0QJg6ojR
	h3iaaki2VZzACk7lZ73U9dXmYUfSAjqQQF3mG9zqc9N02alWvEPpEwzEqZA2ZN+B2YHngA
	0fNIOG/oHv3mMewBE5P7Fb4U5ezZUy4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cF4VhcKCkracUo6gNIATmuRN1hHW/I53fxt0RDVbk+M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793103643; v=1; x=1793708443;
 b=k6+zS+vGc0DuFZGWaTqzhdhz1NQwKEixaQvY0If8/c5h9gJnI5Qhrbgys/3hsQWHb+iH8/Ta
 55Hv9OEC+PWZQY4Zmr//7zwrafI66hmZvydjK3xqWB7nXtPcIMS+aeavKFcZt1Gdx7Mo985pjyL
 hh1z0reSYhL/SZIG2GUzq5pg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5ae49ba9d3797755;
	Tue, 27 Oct 2026 12:20:43 +0000
X-Mizu-Trace-ID: 5ae49ba9d3797755
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kas@kernel.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/mm: fix khugepaged_race build with older glibc
Date: Tue, 27 Oct 2026 20:20:13 +0800
Message-ID: <20261027122013.4286-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9D1C7140007
X-Stat-Signature: hsbnsbt4emf884r9zex8nu1i5mf7ynnd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793103644-419227
X-HE-Meta: U2FsdGVkX18B5K7UuI2SiCLJAXU5qdXXFfvT6QMZgpJekXS3KcRTamwPSfa2ell6JNFjdAb/v4d+LvxbRlbDYTQ3LdDCimtuYjNkyMHWQ7Pue6h4gvcv2TtjQ/TYKn/Cams6Z7qX9HoZPyk7IIvdf2Uqlt+qO53FuIZeCOcpVDuOHziEVZN1ddxmKdzPJFbVq4u7rBf/Ur/9uZ0nzpUeNMW6M5S+KKLLR0pDcGYUYmxC3sW2NUX/3pId34SS5ADvan7d231BUAm6T+vKUoyb26kt8LJexRQisKb3wh16cxyV46AzPLR9nUfopeO24QKKfyuFPV4RPDoBnJgJk/RofT8Sq7L58WCLhiHh7XWxCA/Cqsoky+fuIUs5I8k//LQ2vigrd0rP/oDdWgZTnhslem/BYo42PqjTYVHnNAXfs4Ib0eWQhUU8iq4fJWwF0SmK4BQijNJuig/0J18n62aqLtpkRkJsEloUP56ypgmkErGlOJN/D8PXFX8FNrzmJ/1XVHCCfYHoYEAFyOCZ3v45yvBgxwNBS3+lPPAEVKxeVgbVHRG7iU7gDMx5fl1Bihu/D9TNhzHboN7lVGlXsevhj4eZqgdQkooc9bbo9pbZHHquj2Uh/wUtWUrcBD8vrzaaXA44t8VNRvycEtu9B/29xagU+QeOMBmapVoS3Gz2yYqHe9OT59r110VIX/72g8liGPVZZbTSBbVlV++QhNAdHLCDdIHTe8eLpUChfeBpKkQOkJgTSdbFR2VdwwBQ3OGH6FAH3XQ8QQ3CG8sV8Mpb2M++r3I8GiikZLrj8RnqEHreYSOc1YZr6mJ6esAHgeT6pHzn8kCty01h8DnnhRI99OYPoI4UKTNgWkQFekQknZ4tXgAmZ/HZBp0Zo9iwZlnsFBWfv1VD08bCz9zhnx9NFeUGjzFYQ/fAV8cJNLfpE+1jLSn4+yzIkjDVf86zQAXOY7YDjdeIxpbmqcHScRw
 bc9Wp/u6
 wRro74Qok+EhjNDi/KVF6oH7Z49/KfG09vi9d08j1E4XGHZ/shdemyWmUTbYASDuxrK7ZKEIVCzucurU/bngr1AdIZZgvrO+tCvRdMv3YCQnTITzD6oQ1qcqQFIUB/AVf0evDjy+0nwAuib/ksbb/Z7eshYvowJkBUz3i44Yo2Tejq0cWBpY0RfUQzZSCU2ZIfjZ4sbSbzGuET7NF5TMoivbZQrfK5doqKkDkyDCsVaCabHlmPW+/2dM3Ymzg1F0lL3YqduPXBrwEWOdckHyqnddfUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

glibc versions before 2.37 do not define MADV_COLLAPSE in <sys/mman.h>, so
khugepaged_race fails to build against them (e.g. glibc 2.34):

[root@localhost mm]# make
  CC       khugepaged_race
khugepaged_race.c: In function 'main':
khugepaged_race.c:506:23: error: 'MADV_COLLAPSE' undeclared (first use in this function); did you mean 'MADV_COLD'?
  506 |       hpage_pmd_size, MADV_COLLAPSE);
      |                       ^~~~~~~~~~~~~
      |                       MADV_COLD
khugepaged_race.c:506:23: note: each undeclared identifier is reported only once for each function it appears in
make: *** [../lib.mk:225: /data/code/mm/tools/testing/selftests/mm/khugepaged_race] Error 1

Include <linux/mman.h> to get the UAPI definition of MADV_COLLAPSE.

Fixes: 66c374464438 ("selftests/mm: add khugepaged race harness")
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 tools/testing/selftests/mm/khugepaged_race.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/khugepaged_race.c b/tools/testing/selftests/mm/khugepaged_race.c
index abb0678522cd..1a27cb39745b 100644
--- a/tools/testing/selftests/mm/khugepaged_race.c
+++ b/tools/testing/selftests/mm/khugepaged_race.c
@@ -8,6 +8,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <linux/mman.h>
 #include <pthread.h>
 #include <stdio.h>
 #include <stdlib.h>
-- 
2.56.0


