Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D44606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iLCBWfvc
Received: by kanga.kvack.org (Postfix)
	id 08A116B05B6; Mon, 16 Nov 2026 06:03:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE0A96B05B7; Mon, 16 Nov 2026 06:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8286B05B8; Mon, 16 Nov 2026 06:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7D786B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:03:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AF4BA06CF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:03:50 +0000 (UTC)
X-FDA: 85440697020.09.68219BC
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6FA121C0009
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:03:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iLCBWfvc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=nakixii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOfHSV/fi0rwB1D9NSo+2tobL9eqrpJMV7aIr3prIfc=;
	b=2jd4Zs+aPm4kqU4BePqVt7doWL5k2/eRnBXJNTv36ZSbJqOMGY6IckEA843hgFcZLOOYBT
	ggwitrIUw/SfDUwVkUzmEdxCwbZBF0BDexXWNwmhXp+cVAQVEFyAqAySmjXzM1tO66vLmZ
	A/BFls4lfKGCEXkKJ7NB4Y/zeSfwWTA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827028;
	b=QwNydMoD7F2n+vsymRB1ASM9bW57UBMmuf/uYST2kpAKOo+4mAxnMIJSwp+DUTd0zjRFgi
	o8frvInMwD2QPeOupJDrlxrFENSU3LR2YBI/7IgByQ5CTS151TgtoK3jsnT1u01CNouCod
	2DHSzFVbKdOKxBzkhFvYrcatehH7/Mk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iLCBWfvc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=nakixii@gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-37628596783so5467029eec.1
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:03:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827027; x=1795431827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FOfHSV/fi0rwB1D9NSo+2tobL9eqrpJMV7aIr3prIfc=;
        b=iLCBWfvcU/mqtz7/WCp6OtvHab8qtTGT4YSOP1pjFBHlvuKC2eXUzURDeGIDi/QnJx
         zG5mp3s4hlrZsuD/clmLWoRzVvoN5RFN7nHodwSud2kMehk1l/esmB6gliTz1CdmZmq8
         mljLSQrgxW+vCTny48gTOORuIsMd1zTX5AiQTmBU5/dDEx7aVWYjy3Lg7znEC97S0qkl
         CFX/IUta/+zmed0+FjNRl8Aord/VDtXahILrfN/TPLDMVecEWEPLhLgIzDxTMyyPioaS
         zQuYwBO3UZryS1QcOOeXvWU1nwfKNJgOCihNxn2m4DsZjefrcQp2vrPJxFz7Kuow0tlR
         d37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827027; x=1795431827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FOfHSV/fi0rwB1D9NSo+2tobL9eqrpJMV7aIr3prIfc=;
        b=Zc3h6vptXcQTY/tEPfI86/kV03yivJkMh3cgv7CSWGEBl+CX9U2fxklyx0my3DQh6D
         TGB+M/ipc2g4LwNPCQA91h2EjABRh3Z9D6S/d7ZiKHDHF9oNWKWcZIIRFpn+9tg5nD6P
         9KPvZcOVrWNtH1v2CHFn+ohynPn+ZanVEQXuoJ3sygnhWtCfWz6mwv2WNVuV6BirgNwx
         AWsE/lbOIcOlkwU5EIcY0PVWyXHvq6GI9mTKKd7CyG2AbdNqBQMZhsdA1mVAJdYydKtx
         LlkmbGpyESPOVbveDz+FmyoCWs37k2tcUggycvogm52lsjL5gr2MdDhT9sRItoPQR627
         7epA==
X-Gm-Message-State: APuU4Z8ca1oHj4B4awRlNgJDoihlCCFwNUUHhZui9G9I8y99qZDXcFLJ
	7atiy+GoCMKS8oY8mHUYAdkDdc9DsSKQYD87KhmtCllC8foRDRJ7Xfe6KxLlMyVz8MYd5JhX
X-Gm-Gg: AYBFou2hVcvpfuHgL8YUt8AJBUtKgGkCtJocMo1D2yg0lXhFUzRGO9fdScxWN2m6IUe
	kqnkIKYkfdFthLqqEkjjIJ/fW7adp+lYB8UDvpBCJU2GBMoLn3s5L102e7N+Ul4MKOZRTXBJniQ
	DINilui18vB9sFdmFqGPtNZcu2l+uu567JHsLVAr0w9yTZ9McSymDwFEPxW0RAGQrEPUxbZ8lQd
	ddItyYsnjbpCiUFOaLwo1t6yRdfowdatgTAVAtDuSTQvej967qQ7u+VNJODCyvRUeRYWeG7MbrC
	jkBq1iJmULFBCZ1KrhN6YcWfM11lFLfPSK2wMHAIBD8ZF1qc/zLPwC7R4hhvczIzEOC4BPB0ZGR
	6QaCldXzSdWszFhJuPyIBlYLntr4nePJhRrQ2TMzSBzHbMPG1zjvKcPVbzKTQLUCiSyOzIDXZWC
	+PcGCGIqY9qJEX2zXOITN34Qct47laS/7a0dqXSFBq4b2Q8rZog6OAlRaY/sMB7XVWoLdRKgTzv
	sXsOmZQ+ZEyYF0924O6Y8c+sS4Fj1a51yAnzcRQS9LlGbchLCnGSYLg+URoadIf1nUFJsOhJVEM
	8pBPGfIj+XiQaKO98RSU2SYg63dgaDOflMl7FDP1HiSDgwg=
X-Received: by 2002:a05:7022:3a8b:b0:182:94d7:f76a with SMTP id a92af1059eb24-1b5031562c3mr10836837c88.43.1794827026953;
        Mon, 16 Nov 2026 03:03:46 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:03:46 -0800 (PST)
From: nakixii <nakixii@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Barry Song <baohua@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 02/16] mm: add a swap entry type for in-memory compressed pages
Date: Mon, 16 Nov 2026 19:01:08 +0800
Message-ID: <20261116110122.309748-3-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n1gtnqskhypqnbfd7g6g6w9fakiuyfrx
X-Rspam-User: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FA121C0009
X-HE-Tag: 1794827028-854117
X-HE-Meta: U2FsdGVkX19y3Jed/UQkW3uGkBFCXeK/QVL1Dtm3Dw7DjDCwTxy/P++beYRSpjUCVRNkB1LJxNLwUEE9W7efjFQ3mWuDNuCjOPLYp59pAiLfUmdsbEU4AIRqZqyTmf9q8zenago7r7h1YHh2GbGJwOu+YSBNQYrACrFRodjIV8IEMDqwUIdaFXL2rJcrT9Js4Y1oWgev77CJf4vTscNcDtQwTFKpr2VlSbOOUQhNnBLzHyQwnRPXyFfUVmyKJlkIbLB7Nj2P5PtTPkgo1G3RsIinU9x8w1wd5z/RhwK+ydP4QMhH1XM9V/CdbV2r6ekc0ktzmGWmIdgD5NS1zZf4l9W+BMlMsAZHCu7ijUMkAnKLQOMl+WH8Trnp2bXVcti56llfZrUEhMYGwFkjgqciphm20DzrPS2g8sJqvsEbLT5ETbDQ8ccUKeIlDTRkiKjbkrxTzYmtfk0rhIATzB7Lp10AzGcNrpvIJXwkvViSkFCYQK9AY4l3re+JbYr0y+I9pVhpsOs9FuFYyua9Rxr73AeeTXD9JxKnRkDXhFCz7evPgtl996tKkWbdey3JVxwKqhq1Lp7GPLYNAad04v9tbxc3BpvF4PLYkDlXIHB2EFmcjIl99v+/N3wM07vBeSU7kk/jUoWbjp/du7Dw6UvD8bls/JVF4qpx3nMa+sjZSa06C4bYAh+CT0m16iJmm/aNb+PP4j+JjqFZ5EuWOMGrr44oC9/tg3h3uVz2k6K0wVdOO/tKAqUPf1qIRP7BXseRmXhBF6z5zbrJrizpukjNM0qbEfpfRj6VD21OFtYOLloQFzIhXkw3BPUWa5hdzJL4xiZopAm9UQxNyL5WRluvzrdyjnJWzTlTvkuvvS68xqoGUgZAZqcAkSJ3YKM8fssSbH7+i2TiwepJZ1uukx3u/BxRuE0LvNE+FsLCssFo/DTLvlsAwuUsJZe7FHiQxo78DjPOjBB3n2SgbOPwAJw
 y/D2FAxF
 93RR3lNd/qluBSfuHWTl0LrEQjdT7i4j+oJjv3DdX52e8ujDq4PtO7WvzIYqSNarK5lKtzE9U5jcEIU0/af7vGdWinlCLBTSbMDeeApdfS4F2fzG6izB4bhkH+rahvOmmrZij67224mgDoBWs4cvSisFiimOc2ceLVgtJW1cX2H5kK/kznzOzqrhtGshyNpr+MSYk+GhUxYL8gKLnCvBgOKBva5uMIGHtjEyiDrEjqD7trX6FIWhrRIEopS9ir8AtIWYsEl3k5fG4Lm2OZtwj3u1qsz0JvEiCxCLa0aR5VFo6ei4s334ioNrOwxzYGLV0zfVerJUG8ktV6An13aFpMJVvCe4WBFBODQrclTKuXLkH1Q/lux4mnYm9HC4En1xNx1iEJqPwoKWP37AwDtSOVyPAhEpDGblZAcRJEzPv10tgA8EiHZu2g0dIAtm9S50Um4KLBPAd9P18Dq6UOv9nL6p+gy80ZYAxTYM9X/49NqIHOQtNJ4LAVVUKy1+y6P8DxBa5XXVR2rygLE1fVRaipahoPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

An in-memory compressed page has no swap device or swap offset. Encoding
its reference as an ordinary swap entry would direct faults to the swap
cache and allow swap-device lookup to interpret an unrelated token.

Reserve a non-swap entry type for memcomp and provide helpers to
construct and recognize it. Account for the reserved type when locating
PTE markers and computing the maximum number of swap areas, keeping
these encodings disjoint. A build without MEMCOMP reserves no additional
entry type.

Provide the disabled-backend interface needed by callers without sending
these entries through the ordinary swap-device paths. The compression
backend and its reclaim hooks are introduced separately.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 MAINTAINERS             |  1 +
 include/linux/memcomp.h | 13 +++++++++++++
 include/linux/swap.h    | 13 +++++++++++--
 include/linux/swapops.h | 22 ++++++++++++++++++++++
 4 files changed, 47 insertions(+), 2 deletions(-)
 create mode 100644 include/linux/memcomp.h

diff --git a/MAINTAINERS b/MAINTAINERS
index de04c7ba8571bdd79d564393847d32cc2f18a07d..dc29bbc6e53547cba9fc1763104463bb1091f7ec 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14852,6 +14852,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
 T:	quilt git://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new
 F:	include/linux/gfp.h
 F:	include/linux/gfp_types.h
+F:	include/linux/memcomp.h
 F:	include/linux/memfd.h
 F:	include/linux/memory.h
 F:	include/linux/memory_hotplug.h
diff --git a/include/linux/memcomp.h b/include/linux/memcomp.h
new file mode 100644
index 0000000000000000000000000000000000000000..d399e76bd6b62fdbe377b905cd649960d802bcec
--- /dev/null
+++ b/include/linux/memcomp.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_MEMCOMP_H
+#define _LINUX_MEMCOMP_H
+
+#include <linux/types.h>
+
+/* The encoding reservation alone does not provide a compression backend. */
+static inline bool memcomp_available(void)
+{
+	return false;
+}
+
+#endif /* _LINUX_MEMCOMP_H */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index f3e0ac20c2e8c91f75d1afd62d736cce113e5fad..83d188e927e0af6dd356d39c33026f860082056e 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -62,7 +62,8 @@ static inline int current_is_kswapd(void)
  */
 #define SWP_PTE_MARKER_NUM 1
 #define SWP_PTE_MARKER     (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
-			    SWP_MIGRATION_NUM + SWP_DEVICE_NUM)
+			    SWP_MIGRATION_NUM + SWP_DEVICE_NUM + \
+			    SWP_MEMCOMP_NUM)
 
 /*
  * Unaddressable device memory support. See include/linux/hmm.h and
@@ -86,6 +87,14 @@ static inline int current_is_kswapd(void)
 #define SWP_DEVICE_NUM 0
 #endif
 
+#ifdef CONFIG_MEMCOMP
+#define SWP_MEMCOMP_NUM 1
+#define SWP_MEMCOMP (MAX_SWAPFILES + SWP_HWPOISON_NUM + \
+			 SWP_MIGRATION_NUM + SWP_DEVICE_NUM)
+#else
+#define SWP_MEMCOMP_NUM 0
+#endif
+
 /*
  * Page migration support.
  *
@@ -116,7 +125,7 @@ static inline int current_is_kswapd(void)
 
 #define MAX_SWAPFILES \
 	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
-	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - \
+	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - SWP_MEMCOMP_NUM - \
 	SWP_PTE_MARKER_NUM)
 
 /*
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index cb468e418ea11444ad0fe4be3b551787ba26947f..0327ccc7a6bc808b08780c6d3848d86dee59c213 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -109,6 +109,28 @@ static inline pgoff_t swp_offset(swp_entry_t entry)
 	return entry.val & SWP_OFFSET_MASK;
 }
 
+#ifdef CONFIG_MEMCOMP
+static inline bool is_memcomp_entry(swp_entry_t entry)
+{
+	return swp_type(entry) == SWP_MEMCOMP;
+}
+
+static inline swp_entry_t make_memcomp_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MEMCOMP, offset);
+}
+#else
+static inline bool is_memcomp_entry(swp_entry_t entry)
+{
+	return false;
+}
+
+static inline swp_entry_t make_memcomp_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+#endif
+
 /*
  * This should only be called upon a pfn swap entry to get the PFN stored
  * in the swap entry.  Please refers to is_pfn_swap_entry() for definition

