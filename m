Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63509CD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73A86B008A; Sun,  3 May 2026 08:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BA36B008C; Sun,  3 May 2026 08:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B890A6B0092; Sun,  3 May 2026 08:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AC5B66B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:00:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5133D12094D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:00:41 +0000 (UTC)
X-FDA: 84725966682.14.796D36F
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6125414001B
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:00:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wIXVtAlW;
	spf=pass (imf26.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777809639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pRZvSPPWqLXyPtRZ8nBbh3/UHCSg3NOJueIkd/3b2Pg=;
	b=nj1PkiHTF0oxoi0+TZq0cy6KG9veKbBE7KNl2kVkMN5wAONqvNmE3CmFPYTG3C+YaC9M+L
	kK+VPtXt0feFOqeXWec5jn0VthGtQr4+JPEOmL4KyTAzZ45nnl7mSw4t3gFwhpRt6tx2jZ
	W/PAdW3X+FLcyD7UMqdh7Jg6MFUkjPE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wIXVtAlW;
	spf=pass (imf26.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777809639; a=rsa-sha256;
	cv=none;
	b=eIrJw/Sbw8OweX084D7kpRAKwH2FnHcjHly5Ozkio9eoyvcZ2/qWa2JymEeiOqDPTrlxrG
	14OfdkR1FzxWmCnp6Ei0dJQWoUW5v4iVQHuQhiwzF6JV/uxGs2OJk9RuEq8BbCMjJECfOJ
	IvRzDi72RwKxlzqggPpLXGU6fhRbvrU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777809637;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=pRZvSPPWqLXyPtRZ8nBbh3/UHCSg3NOJueIkd/3b2Pg=;
	b=wIXVtAlWxBFb9w1Ba8+VaaIAxbGvlUBUCSvGkdYxHrGAStoYrSB6uxWZMO2T+1y+hCnyq2
	7nxbTSDjzBaPQjZ8PS8eSG0GEOuYOjOE/FbAWMqpXQy2aGgMatLDdbwnK7i4GXPO+OpYyJ
	stmtK3BctIPcJ0zqIIX9+raaURZF1vA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/mseal: use min/max in mseal_apply
Date: Sun,  3 May 2026 13:59:16 +0200
Message-ID: <20260503115915.18680-3-thorsten.blum@linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=997; i=thorsten.blum@linux.dev; h=from:subject; bh=2paXhbLoIUXAKzrmkZ1SyUFZVoM4IeM+V0mucl5lhbA=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDJnfLSYrd89Vn7n6demJKfI2x1uXXzZd0OFs+YVj26bVL Ds/lvuGd5SyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBE9DYy/GYpe3doV+es1RHh yjlHVGZI6725oiJhKRQb+rDW6MfLeFmG/24/lpU2rN5VfUNXa+W6w9ym4ebsly5pZM2wmtI2SfA 5Ky8A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6125414001B
X-Stat-Signature: bndj5hec63uh1rji6qjgitq9uyrc75rp
X-HE-Tag: 1777809639-376977
X-HE-Meta: U2FsdGVkX1/B1Zl5dwwINQwY6smZ/ung7vVr7/Ez/VaTZQdKgEJoRYB0mN0jRbgN7YOposeotedZgPEBllviG3TC84IdM1DbaJc4yWcEDnQt2XRuk5JAjkGLWOO95jBT+r/fOhrlNCw7nZVIgqBDWFhAizMt3/9ZraP9krv6r3L9JcS3Vbck7L3fYpmqGM3CC7lMvxaC5Q5BoKg6kA/hBs8tW+geWw0ped7k5t87BxTUxkEJh8kHFKuxLPxp9Wnpq5c2h43ByvVvqJya4NL4ZKqC4FEzM7HSOqmj9dCEJopb4GklGH6oECU0fZSu1L/b7av4wo9I4UGIYJJMJi2ZGgtbzcze1atFCK+bHa3xnNMMRv2a7aCaHGF4mjuDpUhJYqXaQQosaWfP8bK9/3u01Gg9vlM1Wu5zEnfwzxqryxG/1GNfi0XY8mQBzRR9EhCUZD9RiPiW+FH2OdIilI5Hi/fXXeSCqIwtcB3L0/yLasTnM9wZdVNBJp56zWhxrIW7fZ+BzJswAka4wt/prN1XUlGUFx9DFYpZtV9PL1h1KgbcK2QkWJdst35vWGV60/LlkXlTv0uylAf6/LNpMfav+4YcUSiDbL95VHfxRA+8/49C5jnC17wTGo03bOb4AmUFx0jWHtHRfI8smpcbgycZE4xyPuxyiyfro839ZkztZsSKmgHQDiRiw+rX6unzB0YkKqitG3rO6xZ6v77K/J6Si4+kGSo4rhdEnoO0u2ARs3zUWTi/ST3TAyS31/Gkjrb+cEpMOypmVzrYXgY/fApRG4P5y1uyvkFAgLoy92t2SBE2jXZlZs23k5Cib1RRGwUZehdfl6eQGTFQLPtPBoQIPEKl4MIWe5gpvoFheDfZPvC6N6dSW1H5TmioBAtBWps5soTvg8ipp+cPO5f1YPSc77InHdOnH6ejuufn7ZDoowfVdSARvO3QJ+lE2v5aHm6jVRVz/bjwW2YxG598d/a
 jBrIp6Ss
 DTnyqIhwiLdjExy5DT8d647qjcjKkU7ZiBWwnT1OGhPK+gc0FFqaAtWIAeJX61sUYzo9cAdUxx6nXa05h4QyFwfAUWkqDyn0oigbADhKr4EFPC5ye9vNHcXUKeseFgyIsq/D8cZYZYp7TPrfzKajEiDb2T8/DWq8mPpo0yVEFw7x6QZLAbFNmSV2dFZpeJsCkDRh58AASU27wyMkZsgZBYJ38Gdddjn4IiNJvJWiCYBE2/hRK6hVX2/WbHDF47eRzAuWq0+bS8vTBgL790HkrFfw3fQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the type-checked min()/max() macros instead of MIN()/MAX(), which
are supposed to be used "for obvious constants only".

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 mm/mseal.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index e2093ae3d25c..9781647483d1 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/mempolicy.h>
+#include <linux/minmax.h>
 #include <linux/mman.h>
 #include <linux/mm.h>
 #include <linux/mm_inline.h>
@@ -65,8 +66,8 @@ static int mseal_apply(struct mm_struct *mm,
 		prev = vma;
 
 	for_each_vma_range(vmi, vma, end) {
-		const unsigned long curr_start = MAX(vma->vm_start, start);
-		const unsigned long curr_end = MIN(vma->vm_end, end);
+		const unsigned long curr_start = max(vma->vm_start, start);
+		const unsigned long curr_end = min(vma->vm_end, end);
 
 		if (!vma_test(vma, VMA_SEALED_BIT)) {
 			vma_flags_t vma_flags = vma->flags;

