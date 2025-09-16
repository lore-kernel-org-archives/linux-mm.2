Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9865DCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042EB8E000C; Tue, 16 Sep 2025 12:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A868E0001; Tue, 16 Sep 2025 12:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73218E000C; Tue, 16 Sep 2025 12:01:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D49CF8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:01:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AC3511DD234
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:21 +0000 (UTC)
X-FDA: 83895577962.15.A4ACF14
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id B57E940007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:01:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iAa4eBOS;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758038479;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/10HhICLTBAM9DGxW+AJtzORYwGHaxVefpsLmsvFfE=;
	b=jIFsYl0uCN+m4A1Jb/cOpiYn6WuSUC+o0qPA0PWWd3n7uAA8JcvAIz60+oliCw90fSx9Wo
	u5n5dFk16z95Z8pS/ZGhHHV7UgVUHIZctIKH9FBKZn51kOl7k+PDMyMPYs52U6rPxBgbMh
	l2KZ5KmBb+M1R9D/kWajjOzVVoBBw5I=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=iAa4eBOS;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758038479; a=rsa-sha256;
	cv=none;
	b=enb1NUDGVGuoFR3U1Ypytx+jN/bOMz9B33s14NJeGaMQc0QwzJ/57ENiYj2WK+yVYFS4bo
	LD37SOUN8DEDmeB7oidDNPBlpgHhOu4J0cJ/xLaBSqm3ek0miaEawWvutll3oQZEpkWa1u
	x7dNjQmuyEvwaRAjdsduk4Ao8QtFMos=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8112c7d196eso596082285a.3
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758038478; x=1758643278; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=y/10HhICLTBAM9DGxW+AJtzORYwGHaxVefpsLmsvFfE=;
        b=iAa4eBOSxWtEMlkptNUXBvl1/y+LnQrsVz8ajyCXXnWuN7Q41yiEWIKsEAfhmUj2ap
         y6exX8iXykdLbT0OPYbIjkvS9ORab2U371nOsihQzSqqJEh6goQ3hvULtiFgeDFDlxNR
         nurT8rbYgDe8AmH1xiGTj0ItehE17MfJ0zWupn0700quV2p1JZQ+L8/kYPYDmfza+LRe
         KGT66b6l0ILCxBNzzi4Z1n4LbKZDq0TODlTowIPnTk1LwP+JihKVw7jBiOBCYws/tHZx
         KZAibufGWk6FaEAL6ZnoUsxFGQLg7Y7RsV8qL/csYu0jcp8oJ8eZKonIRIqaBoobQb5F
         eFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758038478; x=1758643278;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y/10HhICLTBAM9DGxW+AJtzORYwGHaxVefpsLmsvFfE=;
        b=g/nvvFS81Wq0ybh5cHIb6aleGJSjkaCbtaBrknOkssNuz06suhcwJ0tnI4UALaMpk1
         T/GnKLWI+A6jjGVFrRNl/O7QfS1KJsqqxAxj1wT96pP8lVeLwRaY6V10XqLS4toDtblp
         GRc2aGtEKlU8Wao36RGe4U9DKW1aoz0n/ZUC4niCYcv52s7Jw8hbFCg4NShfinL984Nz
         aGtM4W3WRaAHI5XjHNiYkq4o06skr6AzwX9KLCta05alRW6e05ukGwNMyV8wF6M7jy/b
         UJnpIBcYGF4JPyvQHLjkmrFGq9JI64SPMxxB2YbX759Z3T4mTAI3z68l9wsgyaFgyvYi
         aFuQ==
X-Gm-Message-State: AOJu0Yyki3XemtEeOdCfnetCpbZpnVeDmL0iMu8+h96eZgLNwU+NwgUX
	+gluRfSZQ6o6AXqT7PDUR/UpQ1NFN5ZejENXHxuxog9t6cki6Lri6rpPEvu8GqSCUtM=
X-Gm-Gg: ASbGncuxfSWMEga0jve46ko8EtlQRd+BHRNBEAUi52HQYMnZCy0nImzOSTl+9mILVkx
	Lm9K5z12yjsfvNf/1kJTuTEooyvbfVMf0eUB3UaWYOBgvX1aF/odetvz8dbEiir2wMKWb4eT4Gu
	UK/aLHzpJ5qZxjlPnWq6cxlRY4pSuuhK4e56aW0DRysdu7fKB6wnG7vyueuoeUw/qlqtLEhEJnX
	g2rYF7h+BTjRVaeAhddaGKdBW42XRat/ffa0rNlDVaodB3wQHG8Kc5nL8DHK8OFOV89Srz5cQaX
	uHY8Kxty3Lo5IKlFUihzbcawzvl4Nbibkmv9PYLtWzBkHsXOHvpOQyxO44Uw6mrymSEsRfRorXM
	RAleIwCSuGV2cUXgv+NXPlE5bZ0t45GOunh4vtIpvx9OLQNI=
X-Google-Smtp-Source: AGHT+IEk/B7drObHLtIjBOcJtdSnUnQFiVQtqdOA5y3ysTkFfJWgXvqapxngSvusLiINI+bB9tXJnQ==
X-Received: by 2002:a05:620a:7112:b0:82f:4be4:3788 with SMTP id af79cd13be357-82f4be438e1mr36800185a.45.1758038477821;
        Tue, 16 Sep 2025 09:01:17 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-820cd703f54sm969765485a.37.2025.09.16.09.01.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Sep 2025 09:01:17 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v4 01/15] docs/mm: add document for swap table
Date: Wed, 17 Sep 2025 00:00:46 +0800
Message-ID: <20250916160100.31545-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250916160100.31545-1-ryncsn@gmail.com>
References: <20250916160100.31545-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B57E940007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 458g8irzt7y8nk66ysw5di1ofd5qbzad
X-HE-Tag: 1758038479-526748
X-HE-Meta: U2FsdGVkX1/pDj+0M1Yyqj3C7NlJEaSuFwh4e8Kr+CVPV5echwJ3pWSwpzu2hhx+qR8j3BMnc/69Hy1lz0DikyoWEJR3Nhx8D2BDMIW0cArHDAr9XHRDWcS6VmX49M9QDQ3tM7K0pcp5RkYbzoNhv/55EZEg/4ag4pkhqzkNLBudLJqboq/bNWzntJIvRVHd2laXiOK3DD7aSm/UH0kzWoPS1fGwoap4rtBfGjK6Z97uG2YY7QiVeindGMNoftcUPurFA0X9VgMuTtgtFSIVXlzWg007e/A1JYA4NMQDMUzziVxxkLd4Ctz4ZsgROK6jH5f2BlDc7gSi+ENWdWPoqmBXYXxXx6PvmSr5Br4qR5YZTbjl6jt4ejhQilAAa9jKzhp+5EmoNe7dfYooqeGNmGbHd1UAWRmea8DhTOB+TQ1NKbr2PP1DgPSPIBaefHapeAnSPtbYNrA1hI0FeLq+5wMbs76WPWsutQsQFCPV0Y4/KirCS6sIwR7E95aL3TVKRb7p3MDkqEaPMSYmhDAPgiJeQKX++J6fkVeDXbS9c/Bi3meBm+pDtwcUoRmKdwGilD2fIGiUZWPxElcBRh3bQ+rNQzhvugWNNH5wv52gUDhorulwf2FR1PvwS5VPXo13hhhz0xGgEOK0cNq1vkF66iDROLhahwhm6OW6n+3ovxaFoANfz4hNfIDvEb9r/VKOeNPnqKoP6BxJh9LSqOfidKbG9SnmG0oMhlIELNYUkMHCXWpmMARMU5YwDIoPl9UNzdvqqZwegKK32P3v04aXw52s/LdONSOyBOwxznwQJEXht5F7NqEN5iPGI6DFdIBN1sxaGBXF7ysfEz3kei5fQI2o9ip4lJntlD911w2vhswvV0WX7cm74f4VMonL1NlAXVSaiwJl9KLPFClscFODR2/4MJIoUIqMMPobA+lQziyXMjfDHjmt8mmhcixJnHqvm3AzTerIEPcNd1ejTSB
 YNzB33lC
 e+oPOB2iQaEIyuJumcnMBU28jADPRpebdf2/LIYKqURm5smvHzJbrvYQtaf2qpvMZqBmACcIu8I2kIXXrWjN0Fv4ohond+2uta+9jpP/eaQneHVYt1Hof1doCvs3u8shJGb1Knpil1PocQ9GuOGOV7MyDdnsv2404cZXmM7uM7np74yBgt7iU6R5milx7H/1fX3KAN9Z8WyamJQQ7qSEd1p1vvm7zgq37lwMhh17yU0VaQ0IjAxc0PMPahQwLzGCG+OXksn7RwUZlf7eeP8awbolHa5SdFFloeDb10vB1cH3Fw8OyPdz+zKX5RQzqZaJfj55eG62isbEgF8Jiax0jLciKE2OOKdXpMkGF3hRpGJMstCsSHFmtANXGtcYWxSEUh/Wu7Hjh/03i8VGxKxOQ5Cv++VlVulRK0hAzRnPueEF6PwcqEXMIeFaW54Foc7FTdK1CvayqJ/DykM6vjw/qZO3dFNlL2VO3Eujzq7toeRS6CiTweAEYWVslw2/pO4Uo0bLq5VGQ/YK/SVPXkeD8t6YUtFKFfdNrzHqy6GASr2jHMbBMsrOhVeYA2ZgYpJEAab2wnyMSMcEE4b6vTzb1Wmg+LQGfd/z8yYDz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chris Li <chrisl@kernel.org>

Swap table is the new swap cache.

Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 Documentation/mm/index.rst      |  1 +
 Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
 MAINTAINERS                     |  1 +
 3 files changed, 74 insertions(+)
 create mode 100644 Documentation/mm/swap-table.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index fb45acba16ac..828ad9b019b3 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -57,6 +57,7 @@ documentation, or deleted if it has served its purpose.
    page_table_check
    remap_file_pages
    split_page_table_lock
+   swap-table
    transhuge
    unevictable-lru
    vmalloced-kernel-stacks
diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-table.rst
new file mode 100644
index 000000000000..acae6ceb4f7b
--- /dev/null
+++ b/Documentation/mm/swap-table.rst
@@ -0,0 +1,72 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
+
+==========
+Swap Table
+==========
+
+Swap table implements swap cache as a per-cluster swap cache value array.
+
+Swap Entry
+----------
+
+A swap entry contains the information required to serve the anonymous page
+fault.
+
+Swap entry is encoded as two parts: swap type and swap offset.
+
+The swap type indicates which swap device to use.
+The swap offset is the offset of the swap file to read the page data from.
+
+Swap Cache
+----------
+
+Swap cache is a map to look up folios using swap entry as the key. The result
+value can have three possible types depending on which stage of this swap entry
+was in.
+
+1. NULL: This swap entry is not used.
+
+2. folio: A folio has been allocated and bound to this swap entry. This is
+   the transient state of swap out or swap in. The folio data can be in
+   the folio or swap file, or both.
+
+3. shadow: The shadow contains the working set information of the swapped
+   out folio. This is the normal state for a swapped out page.
+
+Swap Table Internals
+--------------------
+
+The previous swap cache is implemented by XArray. The XArray is a tree
+structure. Each lookup will go through multiple nodes. Can we do better?
+
+Notice that most of the time when we look up the swap cache, we are either
+in a swap in or swap out path. We should already have the swap cluster,
+which contains the swap entry.
+
+If we have a per-cluster array to store swap cache value in the cluster.
+Swap cache lookup within the cluster can be a very simple array lookup.
+
+We give such a per-cluster swap cache value array a name: the swap table.
+
+Each swap cluster contains 512 entries, so a swap table stores one cluster
+worth of swap cache values, which is exactly one page. This is not
+coincidental because the cluster size is determined by the huge page size.
+The swap table is holding an array of pointers. The pointer has the same
+size as the PTE. The size of the swap table should match to the second
+last level of the page table page, exactly one page.
+
+With swap table, swap cache lookup can achieve great locality, simpler,
+and faster.
+
+Locking
+-------
+
+Swap table modification requires taking the cluster lock. If a folio
+is being added to or removed from the swap table, the folio must be
+locked prior to the cluster lock. After adding or removing is done, the
+folio shall be unlocked.
+
+Swap table lookup is protected by RCU and atomic read. If the lookup
+returns a folio, the user must lock the folio before use.
diff --git a/MAINTAINERS b/MAINTAINERS
index 68d29f0220fc..3d113bfc3c82 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16225,6 +16225,7 @@ R:	Barry Song <baohua@kernel.org>
 R:	Chris Li <chrisl@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
-- 
2.51.0


