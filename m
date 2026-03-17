Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9328AF3382D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8426B0098; Tue, 17 Mar 2026 05:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059496B0099; Tue, 17 Mar 2026 05:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A6E6B009B; Tue, 17 Mar 2026 05:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D84636B0098
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:45:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9DD718BFDD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:45:17 +0000 (UTC)
X-FDA: 84555071874.26.3E8FEC0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id AEBA84000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:45:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D5naFV/+";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=UfLzxo6opJV5z/c0LHKYazhuljbRFbpq8qRAPdwW9bgdKb7b5TuasKvN6jZZGebc4DhMJr
	AR0AEff4rUK87j2BxiMcTsAvX0MYSJbvobsRFStt7NqJBieT5oPlAvvupv6KzTbfiWpReo
	XT6b8XuPQWuP0box5lEbsIbaETTWWjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740715; a=rsa-sha256;
	cv=none;
	b=SQDeJQXL8jKlU6nzf3eWuJRRpM/zgI1vWlpSHQTiw0VrLoCr/QsTE1aAWoq+8qoXjLSFVE
	EPVQlLmw84TeK2spFj3YEG1gdYtW9V0F7xYETiMQakfO1b0+65VVSs1kjP8vThlNXB7wEj
	0FmF9a9OB9d4wQnM67ldnpNm9PWbChs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="D5naFV/+";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf01.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773740715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cP9CaaUU0YGWeU606cF4HfEnHjH3cqBLv/sm6TUkYWs=;
	b=D5naFV/+JHfZhW2nlxwok6DTrlfjl+jlSx+y3p3p8D4JNVto0F9RgdozwAWpjTFIPWou7N
	+tszm0wWL9RMqCzFUQ9cstFSO1LIGlMEbUPrTUCCJgo3GXqXN7NlfakKpIxTalX2X6ziXb
	YTkH4/vvPmZdjRwYZzMBdKlwJxO/F50=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-583-DL5tgSA6MBu6aROkysy7Rw-1; Tue,
 17 Mar 2026 05:45:12 -0400
X-MC-Unique: DL5tgSA6MBu6aROkysy7Rw-1
X-Mimecast-MFC-AGG-ID: DL5tgSA6MBu6aROkysy7Rw_1773740710
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E054A19560A1;
	Tue, 17 Mar 2026 09:45:09 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4AC03000223;
	Tue, 17 Mar 2026 09:45:01 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com,
	Li Wang <liwang@redhat.com>
Subject: [PATCH v3 4/5] selftests/mm: split_huge_page_test: skip the test when thp is not available
Date: Tue, 17 Mar 2026 17:44:18 +0800
Message-ID: <20260317094419.1429259-5-chuhu@redhat.com>
In-Reply-To: <20260317094419.1429259-1-chuhu@redhat.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: Zfh5zv9MIN8DbpykMYFtwwhSXc3wPAEFpSjQxSjdlAs_1773740710
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AEBA84000D
X-Stat-Signature: bwfcnwewb8ha4z9xxeydrqjhp9typdor
X-Rspam-User: 
X-HE-Tag: 1773740715-730253
X-HE-Meta: U2FsdGVkX187+QAbVDAYmT58z2K+CgGJS4dZqvc+uTOpexTwTxuxIFPqhHuiZgC4kNMnCgOibopxpeRQBCfD8NV5GJtvWROT+VeCpO7wiDB+4+XMzuionJt9BhC/Kv/E//h9BE7qFzmk13Dhy0uD+8GtJgw+tOsRBpfZhIx38E+kKNX5VkBIq6scIDw5++rcQYFC/ycelwwAukZ7od9I8QwBUMwy4hyQh+6XDhcLDfrx53UofYDe+Z4F0hqvJgvpOiDmOvojIiIg4x3iakmVKtVB7edflaQN8173v4rVdNK75bHXt1MkLysDEEkW6WuDzS67JhRU2iD/Phh319Zs8NIx7XdoGHQibxK5EgxilE67ArggWoi0BKJL9Hq/6+1Ixk51PJ/CzOMZY61FQSsmEmuiOO7HDBN4gHFpF4HKoV08AVJ0f4DqVoTNdubevjzPmFF9+7xUegN55rM9auvavNM54c95qSkiWvtoS8cq203JDHZ8KRiguZZHZ8dqVPUIjwjigcw1OJ4VphiL6xQgsAFivP/UGs9HRcGdyVd/Sx9UNppCbezoj8KpTih9Wn/8bgvFgUL10ljje7GkAVYEZqqezYH3VbZaGWZLntkgfKQlpg79lX/o8JSjLiTOvVE3AflrcrTeJNA9Uv2D93SqKtiHnvbKOwXcXrAnq9Bydn/zv6eivvbs7rJo9b2XOXR49WqhK9U1GXGnQCGiH7bsEJk8qQq9cFz24TdyEN4Wz7q+TWEsCI1W3M2omWTCOGqaPfLwEz/z3179s+FLcrXaQ3Cp5MzGMXDaz4WQ+cRtrhw0N+Z+HTY+wmgK96fDhF2GcKpJXxXPIz+nRcRnCu8Yxw/G9GmJeAEI7oQkLXHJiMgQ4BJTySYqrwQTNE/GsLGnntIG5oInan38kAvdj8njjHhj66N1FlNF4NEM2qrB8WTTRwjrjULROW9gON4SXhJlJxl+GNP1+/wvYETOhJx
 ea1GO9Rc
 xsdrBvTG5zY+eAnK0fABmWqzKd5jJDT1OZxMuw9fLjxnPCLmjERROUDz1SiIUU/j5WI8rKzH4wKE74rJWUcfK+Uvq1/0vgW8Vtm0PT4f6ye+9kCLMRnVTIANKtmqFKvb46Hlvh2Y6+CEGLUjpxdjjfzZ34+GHWBgC84iJNhL3gq873KcohQ3jXUFVyL+6ImdPf4LF6YNLp9ImycGhZi/tAiEz5lPgLZwQLuj4a0Yc56qQS4IS+Z0I35x9xp3IeSB+i+Jn6fkxONTNmtdP65QNL1Mbvay1lTZ9f41eMOeLbQK7c9JhgJyI5NA5rbl0TfHRLOcQpJd+FVSbs3s7qMNrOhnBjR03uncC2AWz0lSwU+pnE59Wt0A4KSjTD92A2lnXKPavtgTblUL9O9jQQ26xr0Sv7ZooUhg3w27HtuIdToxUz5fxTFcXSxcMVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When thp is not enabled on some kernel config such as realtime kernel, the
test will report failure. Fix the false positive by skipping the test
directly when thp is not enabled.

Tested with thp disabled kernel:
Before The fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_Ywup9p
  # --------------------------------------------------
  # TAP version 13
  # Bail out! Reading PMD pagesize failed
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 61 split_huge_page_test /tmp/xfs_dir_Ywup9p # exit=1

After the fix:
  # --------------------------------------------------
  # running ./split_huge_page_test /tmp/xfs_dir_YHPUPl
  # --------------------------------------------------
  # TAP version 13
  # 1..0 # SKIP Transparent Hugepages not available
  # [SKIP]
  ok 6 split_huge_page_test /tmp/xfs_dir_YHPUPl # SKIP

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
V3 chagnes:
  - add acked-by from David
  - add reviewed by from Mike
V2 changes:
  - removed the {} in if block
  - removed the write_file helper rename chunk, as there's a new patch 3 to
    resolve the conflict with thp_settings.h by moving it to vm_util.
  - Add reviewed by from Zi and Lorenzo
---
 tools/testing/selftests/mm/split_huge_page_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 93f205327b84..500d07c4938b 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -21,6 +21,7 @@
 #include <time.h>
 #include "vm_util.h"
 #include "kselftest.h"
+#include "thp_settings.h"
 
 uint64_t pagesize;
 unsigned int pageshift;
@@ -757,6 +758,9 @@ int main(int argc, char **argv)
 		ksft_finished();
 	}
 
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
 	if (argc > 1)
 		optional_xfs_path = argv[1];
 
-- 
2.53.0


