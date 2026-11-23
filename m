Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8D9606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LbxX/HfA
Received: by kanga.kvack.org (Postfix)
	id A46BF6B00EF; Sun, 22 Nov 2026 22:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7AF6B05B0; Sun, 22 Nov 2026 22:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90DC26B05B1; Sun, 22 Nov 2026 22:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB8E6B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:00:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 724EE1A0758
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:00:26 +0000 (UTC)
X-FDA: 85464880452.27.5DC49DD
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf05.hostedemail.com (Postfix) with ESMTP id 935E8100008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:00:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="LbxX/HfA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of bsdhenrymartin@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=bsdhenrymartin@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795402824;
	b=PymtfLLUqMiaLnYYk8W6GR64ALWaEeKr4heFtkgMtj+Zqp2H2hNJ3xGnRe8Xpzg9zplHej
	2+Ojiqy5OG0UVciS17gBv8cq0sADV/FoQ3YYwka/4CvkwG1ri3MIQwXERBhDNhbh0CEEdw
	VIcJl9OFjEKV5/if3UawLpxn4sQbEmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795402824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+FgxJSlCMhr6jcW4y/MvZaUC1tSRD2CiwZ7Xb0DzK+s=;
	b=PSHtXx/gxanLjyuanBrGC8SW+M2sECLYM+OPxpV4IdlHJ5+ATq7NHktNqLqx8fj0ogHzMh
	d7N0h5Xi6iFMAeGRTbnv1mYf+YVxNtRZheW3w84DIPIrGpD6fhE0ZbYgm6xbln+kpqfOp4
	Z3S8X83qhLlUi2IPYJ/SKXLWIMAgZvc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="LbxX/HfA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of bsdhenrymartin@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=bsdhenrymartin@gmail.com
Received: by mail-pj2-f10.google.com with SMTP id d9443c01a7336-2effa00323fso12263205ad.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:00:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795402823; x=1796007623; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+FgxJSlCMhr6jcW4y/MvZaUC1tSRD2CiwZ7Xb0DzK+s=;
        b=LbxX/HfAh9aaXImmvISpOWwy2U4OZU5DkcbPCkr5pK8VsDZttV5+/ole0S/H+zjCPX
         Q2Pq8NOFTEsflbpM0QfxTOzD+aSQrPg04UnxFW4bSolhFXraZPALt96s9pm0c00/xOlC
         t2xNmaMe41D89VSkZR8WItKG5YWz66KQWAiusi07/kiXG2HO+D56bnj4GdbSm9JqJY3K
         tIoscKBUAKR1ZI+cwk/uRVBUwxxRHn3jmGAnOY7hCLnTAgu75N6kbOUE6xJhjPaWAyBV
         7mLXtWjFG3oagNxBhs3IG62KxNK0+ZqtVJSI9RsjeNXL9JS1AO4Otm5r/Z8ZfSS1gVQ9
         Nq5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795402823; x=1796007623;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+FgxJSlCMhr6jcW4y/MvZaUC1tSRD2CiwZ7Xb0DzK+s=;
        b=Kp8oFuqghpdeRzrfltLLaOEmADBMRz7VXxvP/yquscpw39QQol9XHaRi+RloAMnwbf
         Y2+vE3vOh34fjGtZmRkOPEVCbpXqoBj8vrxkxXtzqX4B6oIuambPpHJZXQkpIWKBysE3
         +N80aoEf5dtP4j5wgtVBEHFBZ1Jspn538Ldz5iNzqcnaDzp6RCMfKu77V43N+l3q4U4g
         kW1gsZr4c4X1mF96ohwRUUc1N/KSOlnUThAkmAlZvb/UStmg/BXZQexX+GBbLIX6nzVQ
         loKcLfcyKnW8bCnTJV6SuGxpaiiR+DQE2O9AimZYTcKwRg+pbcffVIeC5Kjift8GLO8s
         EOZQ==
X-Forwarded-Encrypted: i=1; AL+hErH1F9G5sHTalQJd8zGPNC+mQJqWesvn1fimzsXpveZvGL8f2PTO8vACLgAzw/cRCqG5w70fBViuog==@kvack.org
X-Gm-Message-State: APuU4Z/KabBSJOfLFjpfDtPhSJ64JJDEQmLcId6bqS88D9+IWJJWTZ6U
	9K46l8kuYkVoSeSR41axghjroEbKWgdTQsEgAt8ErraQ8Xw+wRxnlzsg
X-Gm-Gg: AZFdTZeEWuXYiMzWnda7ev8h8S8A6jUk9Q1FjAMWzQaNtrNCi+BdrALUzsc0sTlFl0K
	XIBucyGOiaEqs6WJP4N8aFYpFVrxB7ImgLk89jROdIi5hh90ghKGlQ0lLx7TVetlPZDgCVjR32H
	1vjGHEWFKmCObtH0g+jR5VGuBUm+SGj4sejuzD5lBZHrBstMNyZz2QKwrXPV1GWVpq9JzZSH3/J
	HyyPguznjz8l8A1baF+CwNoqimIpFpMxlrn6qqvtVSvzV6ObzJXSum1FhRpgrwFO96PK2lGSXiB
	dd9KA2EMQfaWAU2cFQhl3p17TzFPPCll4vu2REWu24HAgnKPMOKzJxVUgPJGGGOgsI+TBXfxVzr
	9UBSlagl+r2RnrOa2LuSn08r0NKee0iAFhWFs80sswsmYTrPWFVaUF6IOQHNfEJr+JYz2LLoUJ6
	7oz7kpJIrc+7zWw7fzZLu5HJ+V4s54FpbaZdnQPHWUb29LnCfhap56uGa6iekFQpapWhOUKcT3Q
	usYTxgDcNdcnM8rwHTzXOB/y4XhEabSPLJEFNOlOXWj4/CBURiRkKuLitP2a3hW8qseSP9EzYyz
	TxENmJ0juo25aExwn8SFB7A4Mohvme1VLJkxH/Kv+qEyPGtMLd0g9SDwE0YBTtFGJxfSyfnaiwM
	=
X-Received: by 2002:a17:902:f603:b0:2e9:6788:9381 with SMTP id d9443c01a7336-2f03f0c1f04mr95101065ad.7.1795402823169;
        Sun, 22 Nov 2026 19:00:23 -0800 (PST)
Received: from BSDHENRYMA-PC1.localdomain ([43.132.141.16])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f070a12491sm21615055ad.8.2026.11.22.19.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 19:00:22 -0800 (PST)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm: fix cachestat NULL pgdat dereference on DAX mappings
Date: Mon, 23 Nov 2026 11:00:14 +0800
Message-ID: <20261123030014.3116755-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 935E8100008
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: i63z1aeikajngcjoxq7t6xsq4ns4uya3
X-Rspam-User:
X-HE-Tag: 1795402824-556109
X-HE-Meta: U2FsdGVkX181s8fJR3S/rgdA4hxiEp/QGqVz4JgcRxybh4ZZrgAg+2llHj1rj4QX3AA9ffMQ6gq+dNdWPRcz+SLwamDBAtOvqEKaPVgqLmxgx9wTI8ZnjbX9SAB5bj0j/0/3UuzhWZcPRxpi8x84CGCPSjltd46/eJN2RMzY0dmq3tRdZ4MqQitH6jFYeQktk+WUMAThyBNjnnKkemn3agud/oRxz4Ez6w4uKEB2OqOeYf8s1gKwwArxQaBtGnmNJvTJoUjOKEprNUOpm36Ry/T2VvmT1pTrtYr7YGhQc1TQrV32TFY1UxIqKXoBWVaTObgRzfEMf6vKkWOKVWEFfBWRMj+oQ2YX1ZlCfBuLrWrXxAbiq4DjKVwPC1MtoD/l6C9EwxbH2bk2/rPjUOwjNhZRyKZvASvfhFBjO7oXqbtPs73DEuVNbPO9STLN3L0tnR7r4ZkDKkBTumCCX0tvWlL/ZuFfHdP3h9/KBjgqlPTNcV5a9uGZh8vIoiRFx+NcyZmk5aBvODawwe+rSgbILrrXDZU/obIwGkbSv23nqEW72unp9LmU/TSDr1XwqLshZmKuuYW064hDchwMmsg/NFJmHwkZN4o82wXyjzyQlojy9ckDSt6n/xvJ5XLcWbJyTZTLzC45ywvcyS2r8BHzh97O3fXQ1kRbY9j2D4nqT7/YfEjloYgoVBl+9+i27IOJ+JfjKnGa6HNGiwULZcNNNu1mCEo4aPh8DcSTG83JhkpvTSJO+aBuBvyOXMmOpIR8eBfEvpLJ5hZAAAu0TX4wy1iYTCai4fNEvF0EzUtix48efP9rz9vlxw+SbDrf5ptfK4ERy1thngRYOD8w1zop94atdYoHP0LnHTW6LC0SzdrA8GHUapEBufjY44TJuS59zuH3tnj6Av9hBQ8sXnx/o+L/FBL6QJynyK3HN5Xaf4y8+XPog7INtDNNbODQY7kpzfWQ0+cTOud73K7Ax5N
 0l7eB1+1
 DO2nibTV7j3Jq6V7N992K/ZNK4oGIya5RZVfBkp47sK0aRDZoNRnVW88Pr0jFDAVqpUGwEhe4Z/bA/8oSq1QBs8AXefZDVx43q/C0zyX8yMUqxMl27TN7/oKyLDxjwK2e2v7dh+DApXkpShDVQdS4SpQo/+KgDPAw09EJUhXmzx5Vl6FYEFeV8oF10Gi9vwCZpGL3vv59rZLr2uFAwQrIiLp4bRGaS6U0+NcyV3YySxWdHPgLMIMqxf2JuJmlQ2aiGEpRf5loOsfiW0xY1xEcOhMgK+V5qXyzeCeabSFNjc+wlvyHCyItnFb2TSv0hIeLH7En+h+JSMbOOwBtqLoxrMgG+cjEw/3mW+2kGmfRXrvBD1ZzSqyfwwPs0rYZG8PpGJcpR83MC4UCEQ78T6gd4ngjfE1es9WcWtSDBzWOpfrmgqqzHvVdKjAoGzr22L1nKfDmVy3C61RXMR8uuYetuUB94DeWi2djD4/4fAmgg+1OlgwEMilKNucCkWx6Ce9js29CrHnkRXOCgSxjSkXidtad2E9avpz/L3biK1/qTNed0N0xiv4nSHf0+3ZG0jc62SL6wFVrGTAthDNY/j7ARxNjI0I9W2+Kz+3xnZsTiVjuLRueSOYmtMXKUlGYAc9RsBDb4r82uEise9eCAvIXzzm0jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_cachestat() treats every xarray value entry as a workingset
shadow.  On DAX mappings, value entries are DAX exceptional entries:
same value bit, different bit layout (flags in the low bits, pfn
above).  Decoded as a shadow, a DAX entry yields a bogus node id;
NODE_DATA() for it can be NULL, and lru_gen_test_recent() then
dereferences it:

  Oops: general protection fault
  RIP: 0010:lru_gen_test_recent+0xde/0x300
  Call Trace:
   workingset_test_recent
   filemap_cachestat
   __x64_sys_cachestat

Any writable file on a DAX mount triggers this once an mmap write
fault has populated entries.

DAX entries track present pages, not evicted folios.  Count them as
cached and skip the workingset decode, mirroring the dax_mapping()
split in the invalidation paths in mm/truncate.c.  PMD-order entries
are counted as one page, as value entries carry no order information.

This issue was discovered by Tencent CodeBuddy Security.
Cc: stable@vger.kernel.org
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 mm/filemap.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index a1b2ca5b933c..caad0adde792 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4694,6 +4694,16 @@ static void filemap_cachestat(struct address_space *mapping,
 			void *shadow = (void *)folio;
 			bool workingset; /* not used */
 
+			/*
+			 * DAX exceptional entries track present pages, not
+			 * evicted folios.  They must not be decoded as
+			 * workingset shadows.
+			 */
+			if (dax_mapping(mapping)) {
+				cs->nr_cache += nr_pages;
+				goto resched;
+			}
+
 			cs->nr_evicted += nr_pages;
 
 #ifdef CONFIG_SWAP /* implies CONFIG_MMU */
-- 
2.53.0


