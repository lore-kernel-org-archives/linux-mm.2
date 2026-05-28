Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED33ACD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF996B009B; Thu, 28 May 2026 17:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA9C6B009E; Thu, 28 May 2026 17:30:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52A8D6B009F; Thu, 28 May 2026 17:30:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 363436B009B
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:30:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04B3216219C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:08 +0000 (UTC)
X-FDA: 84818121738.26.DCC0C75
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 25273180012
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:30:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TkV5kzQq;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780003807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4CJlSs8AXl7ZfYRtAD893brHtGG85Zp/rm/ajAW6HQ=;
	b=QT+m6aflClWTwmnrhn6unrC8eRTz3/7WARZXy9fyCJhhowSPItAiU5c0/g2/SddEEnJLdo
	0DUaeHqCQWw71WKfF+KLHJvne4d7rKsRYhlM1QRbdtAKbjy4vazwRe16MAVMAr8GKFUmyy
	K9HAeLXZtrXLcVVTIi2KP3KtSUlVQZU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TkV5kzQq;
	spf=pass (imf06.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780003807; a=rsa-sha256;
	cv=none;
	b=dfnk9fIQVDvdsNYJcFZcxc3MV3cAEzTdvdhwmwPGzxGr8hu8/wCR8qqTnEHi1AOTOlvliH
	PDyxYysckv/UcdkkH/I0bUbN0Hb2bl+xlZSqecfZCS+BppakQ4Ag2k+QJeXsPPGL6pzAQV
	BsXTuOILVSIHqKwoUITCj+V5CaUVFY8=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7de46b8e432so11624291a34.1
        for <linux-mm@kvack.org>; Thu, 28 May 2026 14:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780003806; x=1780608606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4CJlSs8AXl7ZfYRtAD893brHtGG85Zp/rm/ajAW6HQ=;
        b=TkV5kzQq66/WBHyavlBOCv7SLR9lzY+ufekmKI9HDDra1M78N21+M+neLBOf15faCn
         /hQTcCpyCDQCyacOlu5i2AkFoz8y/xxjVp9Dsfp50s4swOMlxxUJ8ldD9paCN89AwUQr
         +A89upDiXTtDYtq8E0gnlMjX2jqCvFxPf+4Mmi9OvDBm/ujBLuYArqBEpzJg3YICQwq1
         w1UhKX6unaKpTDkpubEBg4luYzNzBvaNm6ji/oVd7cQmCReGtpav7x9+yuyiHdR7lmnN
         /QVOgdWdJG2pfJMmFgqqigvNzJ8JLkxSceo81ckMz+m2sjOyskartqS4f3afDbINL+KM
         NQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780003806; x=1780608606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L4CJlSs8AXl7ZfYRtAD893brHtGG85Zp/rm/ajAW6HQ=;
        b=Qifa5tKz6Yo2wTWdbUISPhEj0abQS7q06LgBRVHQl+EFgjL7Ib5TmuCEgWq7i32Uji
         KjVUsVOtcqp03jzDHYAVASfbg3sQVgtHTcu0mhw2YhLOFbBN/YYXbVOrHMecISgjOuEU
         oSwCDmFIwr9WNbJTCLQhaCL2dSZW7+nMDXC/YeipdizBznmca0oUV2hF6FZDxgDyPPs8
         klpEFQsmaGWjV2ryDJIAttvW06MWKYdXhcAC3DkIUQCFe8e29gXlnJP94+wXmmwdhHeE
         Tc16UgURcuwF53Jg7LKlDv2sEC7SZmgba5Ibn8r8drZ6hADDuqaWgckngj8DNr9ZdW+x
         /R9w==
X-Forwarded-Encrypted: i=1; AFNElJ818FKAN1H4HxpsmyZGQ2qgA5hUDbptWcfb+tgusLKcsRWbuquP4njkc9Gmu3Ae6MRJFAk0JcR0qw==@kvack.org
X-Gm-Message-State: AOJu0Yyttxx1JXue9Q+gA2/5Mbvfa8eg11dU7HyJdLh0dFf5lJpJGMhK
	c2dxNVVHbl3cFQzrqnt2awDTZiLIueA/0ykjQ1ZXiMdTPASrNv+FAZbL
X-Gm-Gg: Acq92OHTSSPOIOnYo22sIhP3OB+NC+lalyyCT0WkqCB/O127DwXfH0dGSJN4DM4gf1O
	b3Kwl3Xy1HkyCZYAYaPExyMNu/xYdjKd9Bq/uV/dWeUkz7mryQT/ZFl1VTTAS2v2kFsEhlHF7pt
	519rcxw+Z4FUw+Au1WlexuB6H7YB50yQJPpUNMepMzM4fdwQNuBD6fhMxPLjl/Nn5zpcuwVL8ZL
	+OoBwSP/1poOmmmXwWqh+MS/qf4EGtyh041An2TYPij0hHulezbXobBKs45A4CAXHC+EEMzIYCd
	9p2zbhM3yVMGIcoTHRDSPenO/+LjDP/RXcTik3CuPgd9qNJv10xVP/Akej+Kueeaj1OZmlr+YSg
	mUwjJuhs1l0nO2TTRJFbljYYGuV+lCdj6V2WuMpN1b9xlnQ1JMhvLy4w8CKJzOTPWDDi3BvSSfT
	+YW9WIh3uIT3AY7x2JiM+LKa/Hqje24h0U2KB96ncLTHOf5MWgYB0CpL2m
X-Received: by 2002:a05:6830:6314:b0:7dc:2f4f:17b4 with SMTP id 46e09a7af769-7e694fbdd5bmr187572a34.21.1780003806180;
        Thu, 28 May 2026 14:30:06 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:53::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e6952991c2sm135613a34.26.2026.05.28.14.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 14:30:05 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: kasong@tencent.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	bhe@redhat.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	corbet@lwn.net,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	lenb@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	npache@redhat.com,
	nphamcs@gmail.com,
	pavel@kernel.org,
	peterx@redhat.com,
	peterz@infradead.org,
	pfalcato@suse.de,
	rafael@kernel.org,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	tglx@kernel.org,
	vbabka@suse.cz,
	weixugc@google.com,
	ying.huang@linux.alibaba.com,
	yosry.ahmed@linux.dev,
	yuanchu@google.com,
	zhengqi.arch@bytedance.com,
	ziy@nvidia.com,
	kernel-team@meta.com,
	riel@surriel.com,
	haowenchao22@gmail.com
Subject: [RFC PATCH 5/5] mm, swap: add debugfs counters for vswap
Date: Thu, 28 May 2026 14:29:29 -0700
Message-ID: <20260528212955.1912856-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528212955.1912856-1-nphamcs@gmail.com>
References: <20260528212955.1912856-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: egpcm9etmc1uge8a7jkkay3snx89r7rm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 25273180012
X-HE-Tag: 1780003806-144477
X-HE-Meta: U2FsdGVkX19PRJ5Sm7/ieyVU+DQPB0CCmWiie43Nm8SaeNlp8mchyuJly2vbnkbo+ltoucNJTJtLDgt62Cj0cab3Qf/Uy/6M59XJTvIlG1jGKmzS/5n4AP9+R53n3fCx14LKOKmlilTYki6+01JUJj13TdiMuIseiz/EIvcRoGmfSWU1/Muyqr+Zj4miB4g7yI9OSx18sFuMCNEmOv6LaZf/fhrEJLfTL+iFFaUJjFL3C4JmnTYIFLx0RpkPLtQOdzcPkCnnxq84A5uKtLhd48Odtz3qrSsk2MIq3IkoJ8K44O7FXA/xSx/2jlnbT7Jw+kEUg3EEBAUK6Wb1rNk1/upD1QcIa+u9cDoXHDtB0qvwV/pzm1Z7QFy5uKwoDvRrZSE/kfIyCrMDIoGOlnvnVRT13Mzpl3QC60ok4fss7tT94JhJmRkcu+kIi3PciHosA9SrkeMEy5zE0j5sBQf2R57iSU9IBDYDEoxREtQE/lFtG9lgTOlLn97kr6x1zsDpwgS5/C4/FVUw1psrRDbFSoqEsZt7TdspGGocHjtVLJLq36PF4LunHecSJRiWBPHqf/2J4uBLicZsj2AH+g/RSzmWpsbQmSEnO/KS1cRwelEJVWvCjdGbfS/FqvVOlTu56xRI9Th7Zg7otGweoDgeKc3LXdolVPlw0DXdhlMasUoyEM0u5x6jT4Skps2sIX0vYxS1hJpnDVhjSdQS03SExBdWSoyGr10e0hODl1z/74dM7zOLja80pkb53GmaJw4pA/l8AfKsvSGa/OM/h+TCT128pVmhOk254cD4EZFAWjQ5EylBwzWtUWvdxhpdMdP0lZfpNTk2e/hPjR4vFT18d1oflPn2sb4f1G3QIds+sk9yMQoeU7tlovw9bTmZS+OIP9acQ0pSU3WGDctr2DazJ2Q8CxNcAd340v0HsWNYVVtsXNoAILtl7SratELYGXwMrsEd4u0/Z8YsSd4dRyv
 vysJRMs+
 mF4fvhU7QLho/xJJWJrVpCaFGCBMHmEmlog5mD/tI9VbRQSyn3JtUTd3Ot3TNPBe+hRJVn4VbgwtS9L6Ca6awVlve6D0Q/o4bmCgDMI/Vzi/w/YQhefkyL0Bx0x/rq63bgb+mvu0gANYqxclTuB+/g6T/XUuxScvb8vw9CgzJfc9JLgDO4btC1579P4Ef/kVy7CVHmiKfG5NxRzSjcGTOz8jxvq3lJVH1BsWwC5I1LqEh7CfkjVgS4wWpNdGSvb7R7XEiksHDnmJZOLe1TrvNJiBOYXrwcyCeH3bsxlYQd8Nw3LxXZbVXEzQpJWHb0M1XR/KMEL7LLrVqbQ+Gz2avbBBZlCbl/oY5WHlQtY0hj9thqaLlfCvRjvVRvqA7sc90hrxXHGPRZZvo6aR0RbEHhUVhvi4+5CUWXxuTgT0tx1P7jFe7YcL3xNKjoKSouVur5t19rQEm8rkt/yDZu0BqpfgkMM21KRZouXs1PF8UxGl93rKnxifD0WzwllIqDKo70elra8NpS3b+OfpWfxC3ARl09ds7E71qKgjwrfe0Xs68OCAoI1p8gDXwBxGEIoIyaHXidPAkhfI7SyGgkKv3ET7ULtz7t8uv6I6r7Bg1JiEIm8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add /sys/kernel/debug/vswap/ with two counters:

- used: number of virtual swap slots currently allocated
- alloc_reject: cumulative count of failed vswap allocations

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index be901fb741e5..3740ab764405 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -132,6 +133,9 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_t __maybe_unused vswap_used = ATOMIC_INIT(0);
+static atomic_t __maybe_unused vswap_alloc_reject = ATOMIC_INIT(0);
+
 #ifdef CONFIG_VSWAP
 struct percpu_vswap_cluster {
 	unsigned long offset[SWAP_NR_ORDERS];
@@ -1993,11 +1997,13 @@ static bool vswap_alloc(struct folio *folio)
 	if (folio_test_swapcache(folio)) {
 		/* alloc_swap_scan_cluster updated percpu offset already */
 		local_unlock(&percpu_vswap_cluster.lock);
+		atomic_add(folio_nr_pages(folio), &vswap_used);
 		return true;
 	}
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 #endif
@@ -2554,8 +2560,10 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (is_vswap)
+	if (is_vswap) {
 		vswap_release_backing(ci, ci_start, nr_pages);
+		atomic_sub(nr_pages, &vswap_used);
+	}
 
 	ci->count -= nr_pages;
 	do {
@@ -4793,6 +4801,7 @@ struct swap_info_struct *vswap_si;
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
+	struct dentry *root;
 	unsigned long maxpages;
 	int err;
 
@@ -4819,6 +4828,11 @@ static int __init vswap_init(void)
 	mutex_unlock(&swapon_mutex);
 
 	vswap_si = si;
+
+	root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_atomic_t("used", 0444, root, &vswap_used);
+	debugfs_create_atomic_t("alloc_reject", 0444, root, &vswap_alloc_reject);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 	return 0;
 
-- 
2.53.0-Meta


