Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6812CD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 10:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76596B0005; Sun, 18 Jan 2026 05:58:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DB86B0089; Sun, 18 Jan 2026 05:58:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9307C6B008A; Sun, 18 Jan 2026 05:58:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8080E6B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 05:58:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 18F231604CF
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:58:29 +0000 (UTC)
X-FDA: 84344785938.30.C9F6829
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6AAF41C0006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 10:58:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zx4s0ZJ7;
	spf=pass (imf20.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768733907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=efB5jJg9txWaP3Srv2/3fTGgn87O8iEs9FizbGyzl88=;
	b=Eukgs+hFOQKlRII3yNDTXS0vhUw9bwY2HftnWpfIorfSo7eUmQc2u9i129V7VibXx2tIIY
	od7pMlH6IMUVa+WMXs9fnnf/v+4WdCGHSEXHUTTaWc9jLg1m/QS/+NZfN5LfFVPGTeUXX4
	gqrJx64Dupg62SLUbz4Gf7nrHEBFsrQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zx4s0ZJ7;
	spf=pass (imf20.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768733907; a=rsa-sha256;
	cv=none;
	b=Z9eZkBpYciSBvXfZy6wi5OHlZTz5SHLOfabIwa3a7REk01cHOQ5Sc4t3xqIRmHuXwPoI1o
	g9Hl/75ChDN4Bh3m6u9iSCunC9iMq+rth8Hnm7qwx1mAMtBtOLHVA7DAL1p9vQ7xXrHJid
	eq2JEWrDGx8RfgeIfKODYcXrK85MtTA=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a0c09bb78cso25649585ad.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 02:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768733906; x=1769338706; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=efB5jJg9txWaP3Srv2/3fTGgn87O8iEs9FizbGyzl88=;
        b=Zx4s0ZJ748EWDFk8KTkQXJd5FmTzGGGE5P85eliho3nV0RZqBxyt6BPtW21aNvtX95
         2bNK/Atc6kKoA/fGxavw9PV4TckmZx+KDNaY0Iw2DrzluSZpCCUgYIADhfYmQXrRDd+t
         Mx7xTwayGxFKeNVHnsGCsOn6+Bj/VW7pntXqwW3JHuYmsZ5X1TvzH8YD2zyoAT7jmJ7m
         KaJcEX3L79RzekkpMsBwhp1xZMvMP0rwAgtNMGQWrnnADf1LkX/ZmxizsZcmoZWtzLCK
         fcNuVZK/nQlO/nRsvqI1FqIT8KV3Bzmu9krvufYIWAVf53hccwtMuQ70cTZ/6/j4wLCf
         5gYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768733906; x=1769338706;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=efB5jJg9txWaP3Srv2/3fTGgn87O8iEs9FizbGyzl88=;
        b=ZYSdsiedWe6MEOG7PfpPqNpc60CWoKPZAd4b46R9T9PkZX6AlLGASNMZfShpiYRD5i
         rBL0O3/0KaW7bgN3LEiA116SKQn5LsYDADvQNyeXK7BwhIN0lELNGhX7t4wGsJgl6wos
         QA+WKUG4BJklgrDtSNx85/Ux1jgkC+7Vt59b02lFnGcRBDMFy+0PULIZ7GJHglHUxhV1
         fZHRZsYq/WuPThMUkMilHKvpD1N32f0rPHbKw8+/yXIkWe1qy12VQfqCRjeuuWKLCFf+
         IUMgoSxEC7Eom0nPdlxncxBmyHvRvL7OKc64AIkuIqxHkd13cfaXzUvo1uYhSE3bpzis
         tbkw==
X-Gm-Message-State: AOJu0Yzv6trTfbq5/tBHbzRvSxGszi1SnGCJCvgiRS5sjMrmaf8rsI2c
	PpMALNd5Ip+pR1AYkRl2BaK3oZSVCD3Cnw3bkU82G1/cENEHMxdhNvdo
X-Gm-Gg: AY/fxX4eHaOEBa5Bc1O3Q4QBTxSep4wI1g/XGhZMHUs8S4cdvw0UDrlgFyE1/RR8Wfx
	lYCRLNEFAEWR/XXgDKH/07FaWok3YNdmD23ydgbrKQFGAG1I1BRClSW4m1KzbZCVEJSpEcE9jWA
	J1wRMmy/0Z9YBPR2STyFqAb+l7uaO9FFF2U2/LD+sJa91YVnHOi1UXqczj9QnUoEXes9iW1bQ72
	PsJ1Aq2JRlRtRSWmZ56sxEw6LZwKpzUCVlLxLmMmMYA1kmC7lBwPWOyh+z1RxQ+JXpITpN56yyn
	VJhraFarnGtUopuxcMq9yFi3L+IB1Ill71DsrFvfF7Trm1cDkxKEJJFnaP9K4zo9BfGL6ivoP0K
	5Ij0MoQO9J0X12IObcRrzqtlluqWjTGsAbt5zFm2YQJBR/6AqqFXg0I3viO4IHyDi7pwjLsPQdN
	kVjklFk1Tpx+qy1+f7iSt2y9g3Rq/U+ybvrtXrH/NMFl54q6q5VOSj3SnqE5XkmMqRWwA=
X-Received: by 2002:a17:902:f686:b0:2a0:e5c3:d149 with SMTP id d9443c01a7336-2a71780a3e3mr69817635ad.23.1768733906219;
        Sun, 18 Jan 2026 02:58:26 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:68d0:4222:6b49:f651])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193fb239sm65708265ad.70.2026.01.18.02.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 02:58:25 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
Subject: [PATCH] mm/rmap: fix unlink_anon_vmas() handling of error case from anon_vma_fork
Date: Sun, 18 Jan 2026 16:28:17 +0530
Message-ID: <20260118105817.1270617-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4pnndbtgwzgez73qtee5dtjgxdz61u4b
X-Rspamd-Queue-Id: 6AAF41C0006
X-Rspamd-Server: rspam04
X-HE-Tag: 1768733907-43750
X-HE-Meta: U2FsdGVkX18Q9EhnVqHqgNSMeiLE7VN9hnQ6a4HZq835/kVsDbYKxTz910XM2jkTPxLOMeulqKpIRhqzd45r9+9Y72E4oR/EUXLd81KQGB6UWRYdn31EdGK6bO1zVFl1qDhSEu+fIGiHlS/iqWg+afdxq9PVzPzJQnV9KuuMBUuCspCaFF8zsfap0rYJAcNkd6iXXb2WAvRwDH46tO5XZ8oIJqKOEqGQh8wY+zvtkYYBLqdS3eGYOB2cvruw6WW91dJxe1Zr0saqeRVjneT3e1fsUiy3sJq/gid9F36jCnKnzp3FEKTr9XVK0kfCeNcVyt46w4Is8JbeVOPgmR4RaS5/JrJss76/JNQaKctbUkgVSUZdCNP1rv22IrpKYDlxbooMJKdeqq7gQzaNuxPoO/UN58GabsFZuFKan9RJGb5O2ByqLXn86EbYqpDKuEKcBT8eOu11oGwQaZh28PHCes6FaS/Is1jW3+KshsI6UXhvzmKjTd9doFJFWwPCo59POnFzC17FZ0TD9xunD4w8gWAbpAS1sO18T3GTmZY02GeWY3O2wak8U01e6CwcwH4OEn8LB4gIQCHydear/D6AWr+r1OWGmdQbclDPBJ5swGXVZeSORC1Kam4IOnjdnVr23Rngzxm/UsmpgGvrwhWabxqQo4z0zTzKHhu0S8Py+yyWS0E6uurN6cJJY0YZPys44u3FnSWoEqoC4QTlxjCIbhVrr6hh1ryjhcUbLQ8fEkhpccRuJSgyZzhMJy+HJSyCkwlxAUNlcvBmog7SBMlsNRvmINvrIJfJg/R/ICXqgZc/OfnWYmAX7dP1LvcGT6MksmVrmu0SpjSHjrLXINnGx5Cqq5xhMiJupngiri50TKXzJ6uUv/5EWdHUPNjfrFp+JfO216JBxWZqC55zP/jxmr9w9kt60YlHzqiV6OVlM0pDkva/xoy97y5OcleZVw4Rd0y/qyCN6kk9JJTUoMi
 jq8ugrtT
 bz1AUrvQDHl4VyJ3QDGnl1qyDR5iGYKmSxUqre40cddiWfVdCCQhZOBzrHQto1+grVaPpcrj6s43uGDDFs5vl/22LsmxiU6ItLzvth85f4Yx9kWLzTrxmDVbqF9nRiPTYz9CFws8CuRKwoUoVYQAwfnq3x8vl9ASaT03Kdqvuk02E6cPxKKKVnkyysXBRQbaBiSqn+3/fLR0/N+1VmYhAxXSBtHQeSJlpephpFurMbEhp0xsJaHWyxspQO2cNbxVV06xzSA77t+ynrEfMqTFNupKPIhDQhihPgzw7ep+CxMuodnPBZ9fypS4O0mQAHyrITCKqPW7OcMnDN19JqNYAMNa0qI6daDRymkiUinaP4SRsElwFN2Q/6Ygjhu9WS9lU5AVB5ICOvuc27BPiHsRRpZB7iI2WQBddeA6dpmEI2IN7IydXGPsFrrVohrf2toMFM4lE7Ks0Ci1Go/9TW69SaCtg2eh0MwMUyL/UWemyJhn+CHL0EvwUwGa6antLTALysrXEWWnUgBVA9HNxm7JRldJv9YDRq2ESHtt2IwJbgKoBiiziUXrYChgOO9e+9Cq6enJBHa3i6hVer4ZJRDi6o1kyEPJvNQeT2ng53DySSIdoaiVejhHWzDewtXmjqBDdHLXhMCqdnSemx3sSuzk2fdAMs6mwNRtj3dDEp3UJD0iMb8479KHsg3kv9fQX8CISjoUGXwUfkgoUgQc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When anon_vma_fork() encounters a memory allocation failure after
anon_vma_clone() has succeeded, unlink_anon_vmas() is called with
vma->anon_vma being NULL but the anon_vma_chain populated with entries
that are present in the anon_vma interval trees.

This happens in the following sequence:
1. anon_vma_clone() succeeds, populating vma->anon_vma_chain and
   inserting entries into interval trees
2. maybe_reuse_anon_vma() does not set vma->anon_vma because reuse
   conditions are not met (common case for active processes)
3. anon_vma_alloc() or anon_vma_chain_alloc() fails due to memory
   pressure
4. Error path invokes unlink_anon_vmas() with vma->anon_vma == NULL

The existing code triggered VM_WARN_ON_ONCE and returned without
performing cleanup, leaving entries in interval trees and causing
memory leaks.

Fix this by detecting the condition and properly cleaning up:
- Iterate through the populated chain
- Lock each anon_vma
- Remove entries from interval trees
- Unlock and free chain entries

This prevents both the warning and the resource leaks.

Reported-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c27fa543e10a45d4e149
Tested-by: syzbot+c27fa543e10a45d4e149@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/rmap.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index f13480cb9f2e..acc8df6ad4a7 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -477,7 +477,31 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
 
 	/* Unfaulted is a no-op. */
 	if (!active_anon_vma) {
-		VM_WARN_ON_ONCE(!list_empty(&vma->anon_vma_chain));
+		/*
+		 * Handle anon_vma_fork() error path where anon_vma_clone()
+		 * succeeded and populated the chain (with entries in interval
+		 * trees), but maybe_reuse_anon_vma() didn't set vma->anon_vma
+		 * because reuse conditions weren't met, and a later allocation
+		 * failed before we could allocate and assign a new anon_vma.
+		 *
+		 * We must properly remove entries from interval trees before
+		 * freeing to avoid leaving dangling pointers.
+		 */
+		if (!list_empty(&vma->anon_vma_chain)) {
+			struct anon_vma_chain *avc, *next;
+
+			list_for_each_entry_safe(avc, next, &vma->anon_vma_chain,
+						same_vma) {
+				struct anon_vma *anon_vma = avc->anon_vma;
+
+				anon_vma_lock_write(anon_vma);
+				anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
+				anon_vma_unlock_write(anon_vma);
+				list_del(&avc->same_vma);
+				anon_vma_chain_free(avc);
+			}
+		}
+
 		return;
 	}
 
-- 
2.43.0


