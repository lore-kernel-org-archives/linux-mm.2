Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0F3606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=L/X2KpGK
Received: by kanga.kvack.org (Postfix)
	id 0BDB46B097D; Wed, 25 Nov 2026 05:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0468A6B097F; Wed, 25 Nov 2026 05:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDB3B6B0980; Wed, 25 Nov 2026 05:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C7086B097D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:01:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D4D89A82F6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:22 +0000 (UTC)
X-FDA: 85473198804.21.5FA5F41
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 03968180010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:01:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="L/X2KpGK";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600881;
	b=8a/4j+J+gp6GvCU8PGJbosbtzAbQIOjfzKzOTtO0npx8o3h93sxqZWB3XbrM1JMEVImivs
	QBx9mHg6mu7vfWIbx92U2QKWYCDrG/S8wWWYsveZ5IdLK3OaCMDN6uwUQwxxm0q/Z5pzXV
	fR/e1Wn82eky5dhBHXmxlQWbvFNrFEE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9xyug7w8UPX5id/mH4z9jTfhNm5yOqqDRPZIS2Gdo4=;
	b=2411l762ObmGEX0RaQGW6rXfQIoR6Lp0+qq3B3LAR15LHEGVo11mDV51q0xHLcJy7mOQY7
	9Ppd/tkGWAU6fHmgoLBuPl0IZ5/YhfVGtaMiVYDe1JlpWplrpEaKPV1qe0/Z3XUEeDQdac
	/Ov6WpGRb+FnVbxeHlQO6gBXyuinaUY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="L/X2KpGK";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2153c8525so44439345e9.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795600880; x=1796205680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N9xyug7w8UPX5id/mH4z9jTfhNm5yOqqDRPZIS2Gdo4=;
        b=L/X2KpGK9nTwm8DIXSq84ieU7ZbVAFuRsipPVZCeMAJGEyT2XQT0tfevbnyx5qRrWq
         kbH44trMxkxuqFZKyX+mDSJhTUtWL0P+Zy87t20iqDSON4/cteey4y0guuZXKKtQcTMd
         M6CNoyOdE61atRUUUB9eiUxwU1ZC9DrEVJ/KG1ZWk3LCyg1rugCJTLBjbNVV+Y1KXL5v
         klKDJVEWuuKmtScG5WWdggykriXtzrIBjwSh62eUbjID2NyyLFc4g2OUMKnnfmA+uVye
         PFGMGMosfSKqcxqIc2qtoYrQCz1J7kfrL33PemjxvWyC/QKZZkSDxvhmfv7NOKze01PM
         pLCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795600880; x=1796205680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N9xyug7w8UPX5id/mH4z9jTfhNm5yOqqDRPZIS2Gdo4=;
        b=B0XvXJDh9I8XWObpTr5VG0JciP3zt9lixahfeenxfwDSEt/mTnabe0raOaouJ35RHv
         PtdXtgEc3OPRjooEvyD3OVF4A5AKgvORCeEsfy6PRrn+Nk9NupzSyIRsHzAfYiB97Zgy
         z5gT1XJVG2eJNW07k70fo82DXrAaJLQ5zoPc8lZfTfyd9ZsbCzhBBq1ZxWONQ4fV9pBB
         9EuK3OBA7YSE+sjG+D1fdScPLlBuB8t5rELpzrdz6H3QSyPjPWSERJ6H6SD1Q2vZ5Vun
         ExMWoMDK6py8sL6vYVq8eoU0B1GJp+gJ2M9vFtNH67CPmd6mTZ64LBymUc36620T7WzH
         jxKg==
X-Forwarded-Encrypted: i=1; AL+hErHBXpA08G1p6XZ3pv0WtbvjsAwceZY2ZDo+fNXNyxjyXpkJcLMlCZWqGN29/nh/Qgyc/WcGRlJpZw==@kvack.org
X-Gm-Message-State: APuU4Z9pB5zrTpXhf2URiGlyvboTk69HAcRL5OBvhF2lgFAANQytO8Qn
	gKRX3/AMnR8mNtyMrTz3ySGUoaYdK6j8pKsv1Im6a4cT5qg7b3Buo+lg
X-Gm-Gg: AZFdTZd+Havaz9gwxOhBnRDlixbDW1HAPysjy+IS9KIcsRs+xlY7BPmuzk47YMdu0zs
	AL5R28YaVkRKlzqC9iN1h8apzKxDQ5sigKhR4OFO070TaaipMPIosD4ScClhewLpjZhjqJvPTFf
	/sOtYzhWrQt8i+LtE6/plsJ1HhS1Uzyh8BZXnScoz5GMjfI/lsyuwQrbqiWQLY5FrLwD9+/1cUy
	AkYlK8gYI48/FlTmZt8W7owmicVGGXgheUCUQaG8l7JRsejkUspdvEMtKGf6Ctnr8K4k4ZZZcUJ
	yIZsCT7l6QuKd0wbxbgoeq1cWTz8g+YqmYBnfRzfQGMeJzK/Fc6RFM5e932dwPORmOz/5LnZinD
	LDy9wLk+17D+K83vauovKD6xBzb6qqkeo2WsN3WB7pU9P3ET8euhfkbU7oTa3Bu4IIwKzFjMqS3
	0pmOVHA5nBu28kUygqp8qMuiJRSZAh/YW6c1YBPYjQT+IYxMyeMMibSJ21NkCmOmeQUVS9SKMee
	noeo0tD80Lq8yoIsJwUbOP4jbLJLBaMu7j9X4InFrawHWHyUi9fvQdGY36uu3D+uUf0jV8Rzi2m
	VTqE+DsSdPbw/g==
X-Received: by 2002:a05:600c:848d:b0:4a4:3a2d:15da with SMTP id 5b1f17b1804b1-4bb88812026mr328104725e9.15.1795600879563;
        Wed, 25 Nov 2026 02:01:19 -0800 (PST)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853a1e8bsm423898125e9.9.2026.11.25.02.01.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 02:01:17 -0800 (PST)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	"Zach O'Keefe" <zokeefe@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Rik van Riel <riel@surriel.com>,
	Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH 4/4] mm/khugepaged: use NOFS while collapse_file() holds folio locks
Date: Wed, 25 Nov 2026 10:59:47 +0100
Message-ID: <20261125100058.15200-5-azpijr@gmail.com>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125100058.15200-1-azpijr@gmail.com>
References: <20261125100058.15200-1-azpijr@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03968180010
X-Stat-Signature: stua9tyzd35nnyusikika1eu5oxhynz6
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795600880-783423
X-HE-Meta: U2FsdGVkX1+XSUxZPFbE1OfFyRl2JFn2alu1xRkcv44tP1KyIITiIscBbYd5QZdjFnq5BKtV7CZrL+sXIcZLeB/ZkO16bjbXCtnHzgg6xTX3Zq+q3Z1G2SZf1SOf5oQ8xG+f5LfWPj1K4YjNipYVPOHPKyvXZRjHWh/+DeO2VNU9ErgVXFyAlUFy+1nKATmc4VBHcVHuH7IOZojJSGnIgHlZ2y8t2/AgVfjbUXKfpzUJiY+1K8AVqIHdRuIyfozw0eHapd24a+QWQKB4OYkztPoW95XBCQ33pPLfT6PVzMcU0y6P48G/DlW+zrA5Vl2pgtiwv0V3vhTYGAt0S01MY86kMzNohMewjzwmtNb7azwZGt6yPxKaLgOv828RCnu63vX0IlpV2VHr0wwTCVoFDBQ4CJMlvOWx2A65NbDak1XRbXfxy8CwkJrDOmdMOoX6Mol+Q0KS4vJmgDIIAscH0+9LyVczYFqmLpWJC6PFrrAlQpayf3fRvdtwCsZCU5/8OpImNcNz3niAIwS0Kbj4aKkyNpgXG7EvZcnjDvlEr82dH7Nn1kI472RgQjeQi3A2OOifHtsOeli4XtEwqYXnBmrILmjhdefqcHctPwTQ3bb8PHuENaUNuHX52SaVxBpr7dAWoToWaq/QzTv791DxYsdCybA8A9UE9hoBx3/bICFODv8ZPBhoR2bhSNDfk00VtC2/IMFJm0lkgvzvyAfuzt8c+ubcrn4KJVuImeruTPt7nVFVDaz3ozDolyY6bK7yMoSidBCgN+lQlOO/wNZJ2RP/gGrnWV/lroF8fUZIUfFrYxHBZnMrA1+LE0G5xzgZgAFNQ7HV5UnijvysuZul/urftG0DWoBlq5Eva/roKqdevCSDD3K3pDNQe3VsbP3k58b+lOylocbU34/SHE4UsSSmIfThQ4fqntWuxlz6bNdStgP+X/BzfXzqQqbNcQh72cx4oQEwueECbVL1jwg
 qwiXVxJ0
 CJGny2SKK2Likq8GXuGVZZiSrxULg+MZDiqosJm0/UC+CaeYB4/5NmV2gcH86bFIIcOHuZep6fTWRz4aFi4a2dNqrbPVMLOZ4qnqeP0HBepCxD9uYtc9D3sfPn/CItcv3TC5+/2fNOELGSlzBFSnAnFKb/+kfM1VYmxLg95nHktdY+ckoLr5/FbOd0N0+8O8J7QMq97bA0ROWpFwnxiZTehEe8hYRWO7V/kUk0oQXA/d6olYy2UWkSebPjRuY94lRa9uE3NjMEisBzxe8ltrdb4xZqt61G64nloMo5huKxYuDLkqrk40nv6H2oTzJJ1k08zwzO/uxuupv30cIq3dA/2EatjLZBfDN3kEUydYjm5H7vN2Ei6MH2ZZUp9Qqu+3IebAyxTSR54bGgFwTWgXaDBt/0YFC73ZYgejIYz/PCGQ8b8x4HxkFixNYnJtmH3K8glYqlS4JgBJer7CGh35d9mWhjwT4NWhEY2tFTpNlJPeGLlsnyzQ8ORbRJO5qS0Q44CFRUFS3aPBZS4m8od9LLqh6AH/6KzFAfYb7bI1ibhcrdCi8QKf66NEtUyS7um/KosMqH/h5gkoNvYkWk6rN7gYEuFzwSqV4zZPGCD/vK+3+kiSgwJgn4jk86N2PP4pWWkkubkCbew6uDAIvEDnjKemQlh5aPBErQL7+21rF67fWQAM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

collapse_file() keeps the folios it collapses locked until it is done.
With those locks held, it calls filemap_release_folio() with GFP_KERNEL,
and for shmem it swaps folios in with the mapping gfp, which includes
__GFP_FS.

As when splitting folios, allocating with __GFP_FS while holding folio
locks can deadlock in direct reclaim or compaction, and __GFP_FS also
lets filemap_release_folio() wait on the filesystem.

Run the part that holds folio locks in a NOFS scope, as __folio_split()
does. The huge folio is still allocated before that.

Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem pages")
Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 mm/khugepaged.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6d2431a20bc9..c3c733d3a32b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2302,6 +2302,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	LIST_HEAD(pagelist);
 	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
 	enum scan_result result = SCAN_SUCCEED;
+	unsigned int nofs_flags;
 	int nr_none = 0;
 	bool do_readahead = false;
 	bool readahead_done = false;
@@ -2320,6 +2321,13 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		goto out;
 	new_pfn = folio_pfn(new_folio);
 
+	/*
+	 * We allocate while holding folio locks below, when swapping in shmem
+	 * folios and in filemap_release_folio(). Allocating with __GFP_FS
+	 * there can deadlock in reclaim or compaction.
+	 */
+	nofs_flags = memalloc_nofs_save();
+
 	mapping_set_update(&xas, mapping);
 
 retry:
@@ -2698,7 +2706,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 		folio_put_refs(folio, 2 + folio_nr_pages(folio));
 	}
 
-	goto out;
+	goto out_nofs;
 
 rollback:
 	/* Something went wrong: roll back page cache changes */
@@ -2744,6 +2752,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	}
 out_put:
 	folio_put(new_folio);
+out_nofs:
+	memalloc_nofs_restore(nofs_flags);
 out:
 	VM_BUG_ON(!list_empty(&pagelist));
 	trace_mm_khugepaged_collapse_file(mm, new_pfn, index, addr, is_shmem, file, HPAGE_PMD_NR, result);
-- 
2.56.1


