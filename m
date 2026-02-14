Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5521BEF99E1
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 08:45:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F89F6B0005; Sat, 14 Feb 2026 03:45:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5DD6B0088; Sat, 14 Feb 2026 03:45:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AE86B008A; Sat, 14 Feb 2026 03:45:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76B356B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 03:45:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE1C7BB2F9
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:45:21 +0000 (UTC)
X-FDA: 84442428042.19.8388E48
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1CAE2C000D
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:45:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5PTz797;
	spf=pass (imf22.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771058720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xpX6w+exmbmzYP80YKKFeZCWbquQTKNkSqVY1a6AgyE=;
	b=quiDgos/piblIP/UPQfzuBy/RFQLCsYxSDhpUEEr5BG4FAuY3f0gA5mMksNQ4ci8An5LT/
	cnNEJZW3L5S0wUaZ04WuTnmpiVpbN84jQOhV2XDsQ4KTWWruc4nGynNYilhgVDErAhbWJY
	SPz9m2vBDWghfanxotOCefZyVxWhaAg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T5PTz797;
	spf=pass (imf22.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771058720; a=rsa-sha256;
	cv=none;
	b=6onO3hTN1HWqVn6F88jCx84IgOHZQ3kto7J9FEqgogleK4CEiH5zfVRxG0IwOJvFM/YQip
	BDZRhZ2hOJm7yFAc/pY/gFQZ+MeD86PTX68v77hK4JMYUtljzttN6xVJuZg9P9xqmAYpAa
	19rQE09iRNhkk9LEVdQBkymHYAf4nYE=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c61342a69b9so674079a12.0
        for <linux-mm@kvack.org>; Sat, 14 Feb 2026 00:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771058719; x=1771663519; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xpX6w+exmbmzYP80YKKFeZCWbquQTKNkSqVY1a6AgyE=;
        b=T5PTz797Ff23bPvJD+JS4OIe1HXKtywqpRonTc1eXJdr7Y6pfm3HQkRE5JjJCE0Q/x
         o2um1E6glxf2+0udKEZ9jPNL71Xtndy/8yvuHophnerveN42Em5ZsBwOCIrB9sfCg/jN
         WM14JfizahjqmFPuOO6Cu3JqPD6t7TCsM8GnJPQzQ4QlMP+0D38WLRZ5y1k5/hCBTM93
         8VUx491xVRCS+wpSGva9M1cmNMTBUNKvCBWVJQmIQ6Mf5d35UL9t/X9uxx3MZ9m27om9
         CqnutxSvjzq78+nX1wfDlqIICQ/j9EHtUsGgdaSWXfbfJL4egqiukGWYOLOxs/vT7hcg
         h4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771058719; x=1771663519;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xpX6w+exmbmzYP80YKKFeZCWbquQTKNkSqVY1a6AgyE=;
        b=nLgID7z+XV6chfeh9wMUoQT0jzWrdRjNtCM20W5EK3qls7fGSakue3YqGCJFTmdooF
         aZu2aX8nAx+YWVuGtEp87H8mznfkl9jVQaqgRK0wFryd61z/Hjl7b/jf6iWONI8MV0B1
         4t31KoaVb3ly/YCE9BHNBw7Hn5ZjAXF38ZPEWACU+luhDOvcy3xOdRpXOre4Q0P4CjTc
         4gwDWR4bKdgo2o2N+THElFpoIj9jZuvUXtNrm/oeeysxiObOeLqNmxot/rYCwiID2DUQ
         VDXgcXuD9yak8nSH/gcY2YXX/ylBAZ5LT7zwKiaderJOmjjeUA7QNSFQTuX+4YZUy53O
         dMlw==
X-Forwarded-Encrypted: i=1; AJvYcCWm8zhDITnfDGPmRxJnBqNNI0ij6hmOCFdO7K2sbiulxMoBmVdLLHSeQGs3bo4NCTqz8jf99IFFQQ==@kvack.org
X-Gm-Message-State: AOJu0Yxvc2J2hEru76rW+5rHHB50O8ou3aX2msNB2A25FA1IUGsAAbeZ
	0q6yFW0MtejJ9VPUE0FUN+clnvX2o5jkYDsbC0r+NqQZZVc9pGZ1f+Yx
X-Gm-Gg: AZuq6aJ7wUNFnBUkIyp6chzzP4AotUi5rVcA/0I96Dl9INrI8IzZRgeP0LMQ+uX86E2
	7iBaEHbTZB1sgrWMzDU4Wnxv2/UwOqe+QfM5d3R0Xgj58L6bjFNYW2vR38IqVzWk1CwLMNRfJ8u
	mmwwGK5j2XotWFk0kfuOfNfej1JQ0ZVeGzIKGCgC0bbKGKEfOXzJ/A0rD7rwj6TO0AksgTc6CFU
	Sin8pzMT48Czc0xK6NllFZzEGnmXajULU9In1Lf5mM2cCE4IvUDL4kpnfNtIv2QLJeomM1se33v
	3eTMOWNFt6CdHaFheQnKKLsoiUyy64rIzkPIERTvUWAUMzZHIh+etxjtlXvPta4KsTbn1r5oXEu
	IQ6uetrvFYP6Gd2aVn/AWIFpUwR2g3tyqIrlEjWkZNE4oVsXXz6yl4ey+Qr+xnk75FX7B1RIs3k
	JEIPy3LpuAQmGMz/yWNIdx
X-Received: by 2002:a17:90b:57ce:b0:356:22b5:704f with SMTP id 98e67ed59e1d1-35844a4f70emr2165244a91.15.1771058718880;
        Sat, 14 Feb 2026 00:45:18 -0800 (PST)
Received: from localhost ([240e:3a5:3184:2a50:fc86:2a4b:6ee6:4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-356a6a23e55sm3152463a91.0.2026.02.14.00.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 00:45:18 -0800 (PST)
From: Wenchao Hao <haowenchao22@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Wenchao Hao <haowenchao22@gmail.com>
Subject: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous pages
Date: Sat, 14 Feb 2026 16:45:14 +0800
Message-ID: <20260214084514.2842745-1-haowenchao22@gmail.com>
X-Mailer: git-send-email 2.45.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8pnz81d5ze335sy1pmww8nia4rbh49jw
X-Rspamd-Queue-Id: 1CAE2C000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771058719-706361
X-HE-Meta: U2FsdGVkX1+3NTmb3gHP/FjnoLaKA6K7brUdy8Tm8HLGl6v3OS7hpYZlVz2Ov+uf/7DHQVPR9NcTQc+yNrgJ97x6HIpW9jsgmEOea8v0TkkY2u/mPy3qUZBZACdTC1w3oomTHKWSl//3xvrBMPmGYSuBjvKOdEJXiNDJEn4zg9CPpPmkHeN7qCvDtPGZ+PxgHYLsFNfN9XZVMrnzQr3uyivHa+3P8iAtR4+Rmq6zJgvBPCeIrNLjY6Umx5fozkpaQUjJrpncanQyyymOEPKzHQbcZwlACgOFQWkLgMFnYTohAE7cxbzfEB8r7863pFB4w3LHwnaDl5CJgkKbvtqXPlUdWCVdclCbl2MyRv51MynT/BEUUmeMxkEgqwrJab9axhnoTgCWpUofK/ZMkemG+hdGcpMxipJ+ukx2I0EEEnP3a35aBqjdFD+apy4h1Dh9o6xL5YqyJ8+qXgfhfWJPbtWcsDbN771fbNrPurQ9cBoVwCdHOHRMHRX7XA0T1+98TIZSaMjg0xYjHDvV4TlC4oBuAbUOkvi7LG8IMTa7w6uKcTxnkEE93swtqjxWaqxbon8ktu1K8d1hxq2Q7XOJ7jV/n4cLFUQ8jaMdF4W/W8bO1YZimNEDcXHqA/+73g42rlwwmPGfOHffZqxZHKXXEp9JKuGNbrJvoIsNHJnRMerIlw7MEYe3w9xXYNhXneSdpgh/NFXxeqJN3f+9m2BCPknoF2p2iHfJo54dKZmTmqCpiVXGt16wAHnu/5gmKcPeu/JUt3QdCLXuRQoGW3+GxSaYhDRomycd0pk7PW1PyRDCQWEPgpqIproHphRb7T2QdJ2uQqduo9MDmC5x8tcYm3kV9HVsvtpGWkuCqXMp4pyryVpJA9IMqubRhvg2BNwMIUNkgRd5P1cQk+ptaXufgnsXx6bjwWFxSZ3nzDn1Gdl+XcDXa9EWIbD19oltWj8Iy7umdmWg2RY94cPKBHh
 YssX7PJA
 TxlZqogCEL5dFCV1qAFaX/KCu/1PGrWERGAreRDkkPeLG82zIOo0VlwAL406+1v5FukFJnff9gqHCggnfkegFpqdi1rOscMdw6VeBRvh9iWku5DmxI2XBkWs1RdtUzCoP8/CBXVxC1N/RfyX0zLgmQYhZgWMj3NyYFMlELe2q8V+JvcZ8SgccLleFJ49JuMEyO+L2f2ir+DgN4QukMK6L4404Nj42+WgN8aBtO/RgB9Q61tVJmp2EIOHh7CCQqdebkVKEG0Ncq6D0/cDfoOnyVPyO+XimpDs6W+Kem8+Jvw5aJLBqegyeMcSBQJyLt9evT5mWoYwHZw7CKgXiTbl4GLBS7hpfJRxx0ctq5SRnfVO4kFzg/DdOjbgWATYirq/RF8kBpkug9hby9KXOoKpxX3KfTHh4PqCTtGP4XVr/+yTJcRBDuBxnklPcBKhTWMVpaJTleXI6pFmNEesSSkSKLeZPf18xFpQfgI9l+HC4oAb0eKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add kernel command line option "count_zero_page" to track anonymous pages
have been allocated and mapped to userspace but zero-filled.

This feature is mainly used to debug large folio mechanism, which
pre-allocates and map more pages than actually needed, leading to memory
waste from unaccessed pages.

Export the result in /proc/pid/smaps as "AnonZero" field.

Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenchao22@gmail.com/
Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
---
 Documentation/filesystems/proc.rst |  5 +++++
 fs/proc/task_mmu.c                 | 10 ++++++++++
 2 files changed, 15 insertions(+)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index b0c0d1b45b99..573c8b015e39 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -545,6 +545,11 @@ replaced by copy-on-write) part of the underlying shmem object out on swap.
 does not take into account swapped out page of underlying shmem objects.
 "Locked" indicates whether the mapping is locked in memory or not.
 
+"AnonZero" shows the size of anonymous pages that have never been accessed
+after mapping, and it can reflect the memory waste caused by huge pages.
+Implemented by scanning the size of zero-filled pages of the VMA. It
+is default disabled, and enabled via cmdline param "count_zero_page=true".
+
 "THPeligible" indicates whether the mapping is eligible for allocating
 naturally aligned THP pages of any currently enabled size. 1 if true, 0
 otherwise.
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index dd3b5cf9f0b7..c39ebd015724 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -880,6 +880,7 @@ struct mem_size_stats {
 	u64 pss_dirty;
 	u64 pss_locked;
 	u64 swap_pss;
+	u64 anon_zero;
 };
 
 static void smaps_page_accumulate(struct mem_size_stats *mss,
@@ -912,6 +913,10 @@ static void smaps_page_accumulate(struct mem_size_stats *mss,
 	}
 }
 
+/* If scan and count zero-filled pages */
+static bool count_zero_page;
+core_param(count_zero_page, count_zero_page, bool, 0644);
+
 static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		bool compound, bool young, bool dirty, bool locked,
 		bool present)
@@ -931,6 +936,9 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 		if (!folio_test_swapbacked(folio) && !dirty &&
 		    !folio_test_dirty(folio))
 			mss->lazyfree += size;
+
+		if (count_zero_page && pages_identical(page, ZERO_PAGE(0)))
+			mss->anon_zero += PAGE_SIZE;
 	}
 
 	if (folio_test_ksm(folio))
@@ -1363,6 +1371,8 @@ static void __show_smap(struct seq_file *m, const struct mem_size_stats *mss,
 					mss->swap_pss >> PSS_SHIFT);
 	SEQ_PUT_DEC(" kB\nLocked:         ",
 					mss->pss_locked >> PSS_SHIFT);
+	if (count_zero_page)
+		SEQ_PUT_DEC(" kB\nAnonZero:       ", mss->anon_zero);
 	seq_puts(m, " kB\n");
 }
 
-- 
2.45.0


