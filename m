Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8DB1088E49
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 22:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA54F6B0368; Wed, 18 Mar 2026 18:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 943876B036A; Wed, 18 Mar 2026 18:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771EA6B036B; Wed, 18 Mar 2026 18:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA436B0368
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:30:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 215911A01DE
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:25 +0000 (UTC)
X-FDA: 84560628810.18.BF77737
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 30940140008
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 22:30:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nv1Vq1Go;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773873023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FKrmsaRryTJ5nHXiiuirqMc/v+zxITLhw4bMyN6ZWm0=;
	b=KVxIgVEgH2oaPrRLwuGlmqQioPwdnhNAKRo+rqmNJ9RSeqaJ0HvarHcLruz6PiNFBYH2F1
	7zArfYNPYSmJThd/22lKxPPeVjLaXP82GaIRd3DSNxQOkLnUhTu9x7KdDlMxWAwf7AkeCI
	WIGzJ0ru53XsWxJynxYsjBOhRgGf5CM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nv1Vq1Go;
	spf=pass (imf23.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773873023; a=rsa-sha256;
	cv=none;
	b=iUlGlna+tb3UeIsuJFpUYNqjcnlKK8hU3n/w9zEJuWTxWAcV/vo5wRjTUQEqk/7rhO93to
	vXVJ5Y8d56vJTuTCKOepFtFYVbAnw+QP/JkMOYE+BJXjn80GHOF8CmAADZyczhDv3Frw2o
	3ioG0gsJgPsdiPgXCbCHcj6TEBczcrw=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7d73ccee442so362646a34.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773873022; x=1774477822; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FKrmsaRryTJ5nHXiiuirqMc/v+zxITLhw4bMyN6ZWm0=;
        b=Nv1Vq1GoV1q/0hkoVyyyznXTKL9lcMpoJw88+lOyK/YnLfCx3F1YmqViGYFdJRyiFI
         1MYB7UfCO107lFRsY6VHjDIcy55+NPgaDlV7jbQrz9Gf7bKg72oyT0VgDRDNbpddJ/vB
         tILw/QSF3T8DBhGlcHU9eORERI8zq6/SnY9pPZKwu4GWa4IlYuZTyxAl8uQcA84OVz4y
         6b1RK0OW0TehDd/Cjq1pnlvjh7EPoVguyuG2seaX/haL3sVP2yM+s9u/smP+CQ98gghh
         2gyGeRBsQ95BX2vc2ZSuGXxUo0+QyMTc57VGCXFX6T/nhnAUFLbohkpcQDCS7aYx1AQ7
         t4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773873022; x=1774477822;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FKrmsaRryTJ5nHXiiuirqMc/v+zxITLhw4bMyN6ZWm0=;
        b=YwYmcYeJJxnqVg5hfEHnRIEhEiefbeVXvzCuDbS3hAmOZDU0gmny7IDWXiY50VHDj1
         FlZ0UmMHXr/9BUg1EAH15hdrgKaAKq8/JpN1ZW27RV64YjCf3BAtcablkC2foe1pA6aY
         1I+ESlhUOBaJXJA/+nWFpF5EoELXBl1HxKwiMt300x7qfrZazVQFxYmYYgoMVd9UW3Ux
         wiQ6s+GDf0GwxBE8lh6Xi4Uo+CtPU/GubnfJXP27VO8veEMkiN7/n/ziQTER/cM3ktMG
         ilM/rMoSZ3rW9kXQUtQFGRTkiOlD7xYg/Eeocbpbu50MEmQyT6v4tSTf3/3BALgUc5KU
         wYEg==
X-Forwarded-Encrypted: i=1; AJvYcCVT5MR+nSKDtoyT1+vI/wzYkZFuxhwdPFNdzP9I+mSEg1J4LgXR/6zAlmZHeYw2ABXdHVe1jbToYQ==@kvack.org
X-Gm-Message-State: AOJu0YyvKQbwDTOyr25qhpzWXYbZFufdZzuEWBMvcxxiNh4EfmaxIKwS
	VRljrnyYLQ92nT43V+1z+zTzY8pn7jdHBZAux4yptRjrZ6AcJsEQ0KRc
X-Gm-Gg: ATEYQzwg36cI9hYfM5lTIZvzIp1EttkycIbn6oGGXLrhItXujP3C4pRpEI5XM9i2XtU
	cnc82YC+jQ33oBsaxXHnXgUAOEDfNbIVmR0BHoe7EOGBg1J6G1AVOTQLRfQsE45/VqMaToGZylR
	HRK1EX+jEXgAahTd3FpdQkdE59ppdn2fglb3cf6IwEaX5xjMXTtD7EdKOG5A+dqvYFm4xXzDiLp
	IZBUkcy1oTo0atxsQgY/uPWsg44KTf6kw83fhrT8xF4+za8eCM7mVP8JzIBwiUou2OWELvF1I9f
	2bH2iGwKE/5caOI+0KzNHSnGv1pQqWR9s0+R5KQsjommd3Egq7mte+TN+izmlKB27nUdaVoElB/
	rmkHZo3XU6nCPNd5MG+9igKgLEuUQp8kQqSrzaRkhKsJkTMZYOq30pZyhQIMUiRinvgKq+V28j4
	yudrXQ9NXmFOgbqxtF3MrbuwzC7K0NWf6iIB4Ij2QKBia8Ig==
X-Received: by 2002:a05:6830:6af5:b0:7d7:d217:5116 with SMTP id 46e09a7af769-7d7d21752afmr1935454a34.17.1773873022052;
        Wed, 18 Mar 2026 15:30:22 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d7c9b3696asm3133813a34.16.2026.03.18.15.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 15:30:20 -0700 (PDT)
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
	riel@surriel.com
Subject: [PATCH v4 16/21] swap: do not unnecesarily pin readahead swap entries
Date: Wed, 18 Mar 2026 15:29:47 -0700
Message-ID: <20260318222953.441758-17-nphamcs@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260318222953.441758-1-nphamcs@gmail.com>
References: <20260318222953.441758-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 30940140008
X-Rspamd-Server: rspam08
X-Stat-Signature: 96zagtzuwnz1cpzw8twkh5fewz55o4o6
X-HE-Tag: 1773873022-716457
X-HE-Meta: U2FsdGVkX188LowdA5SgUOXBnhv8xfK9MX6VpSm9Zig982Q1wvAlWqMakP2n1/z5IBc5JTacrYcpdmk66SaVC8KbXsmbc/dmtTivDCaBpIy57kThl5lno0IFjwgQqLSI+oZUfBAXM04/s2JCbzOekkxA4SY6WtLgV7NY3YX2E+77coo/q5c35p/jzB13XVAKSsbL/Bl+BRX7RUBZoS6UCYVPzB0Q8zzLHmhgVIuAZ0P43aL3M3odpbQ42upMUZypS/n4XHQcZwum2af+9wjHl1HqR3R9S1InbDesYM9wdFwWvhHUQUA36nTz3Gvf0DUsM5/jHwtbJOvewCXOX8ycm9ODZs7kgmFk5efoDALKBwO3X9C0MELaSyGwPwTP8UmJroxUcrJX4zUye2rDXcF+aWnbo7zRmlIUkQNVHXe2pphq8MdBRa0WNqsndCb1NLakgmQ7+3WLxmXX85m9q5k8Bb0ujFdgfg1RhtXp6BMzdTc0MbQBZo5qPbN3E80l4/zzQGztOrRFOLxp0iCPqdPXysEGLzm6oDmj0MKlD+r0JuPwe7CcKS/OuswEc2uh4xAlE51e0PK949PAG8DhOY9IxyCtCWvAdEDrK/z+BvKca3AhPKu1QlkMGSGhCCjOSeU8T9CBfPE7JdSO9Qz61C0B07gc3hHVNRPe+XvdfSnXP/+I1ziWGvP18lukI0T06XY2Sq7xUVOXeyCxKex/TgEuC6yAWWHKlDbQAnendJnI4h1r84IjZehuL7PJYJr6pr4+l7EVzbFXEKBZc4VsjtGxLN+y4D9OxagOHcI0ff3LVB8h1n+IEaOfo8w4KgzY8XOvNehLoHKbF+XM9MYltbp7Mz3ZAFl1dSbM36fZNkqMZ9sXovUGMaFDzXt/avCgqwHBdxJkrRL4i8q3FmP65KEJNTefTsXlzP8bOw/PPofYpmkjnc+LyHsripwm02atSCf6M/3RBWZiRk94eS+R8ZI
 0jzm4ANG
 wQQBn3+poDzusbg5sOC1Z8yinQgCgCq0bIe//SMNCjZtIER7FlUBF+vRjXkwam9C0CZHKy7qaJw23CirGpDpr/ntefFjR8JXIG76S6XMxD6Zcgb2rMQB9+bZANwDG+8kLr5TvACmGeeq3SfUOfgxGaWYN8ygnBa+i6sP29lfq3zvIQbQqpT308+20mIJ0qhPE431Ot4atA+OyogsB0KzjcHbuquRZVFDm6xeOF3UFO5R+La1sb9BN6qqlJSevysg1MCSQu4RciwmLbdTAmBw3Gq75FXixHu15viIB32tQRUclkLpo8e6a/vNGcagDSyWQK2af3IezPU41iilcbkdcRPjY9kTwU1mrGzsIuZbBebA8R6tweeDNDPmeC1Pc3XGc8RVtH//0R+nAtWiszgmFQWALbiT/oCL2DOB/b1HvWiZguSjIScUpANn/u28cW0SNMda4takLmPktMkGKC9SOzOlFnsNScEQsZ2EXl8qNElYQPNhdfTczgQh09r/zrvVtH7Nj+VFwIsIf7CYZvmR9+mmw21iaevcV9cn4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When we perform swap readahead, the target entry is already pinned by
the caller. No need to pin swap entries in the readahead window that
belongs in the same virtual swap cluster as the target swap entry.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swap.h       |  1 +
 mm/swap_state.c | 22 +++++++++-------------
 mm/vswap.c      | 10 ++++++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d7981ec82cf49..2229c3485b7e2 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -213,6 +213,7 @@ void swap_cache_lock(swp_entry_t entry);
 void swap_cache_unlock(swp_entry_t entry);
 void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 			   unsigned long vswap, int nr);
+bool vswap_same_cluster(swp_entry_t entry1, swp_entry_t entry2);
 
 static inline struct address_space *swap_address_space(swp_entry_t entry)
 {
diff --git a/mm/swap_state.c b/mm/swap_state.c
index ad80bf098b63f..e8e0905c7723f 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -553,22 +553,18 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
 		pte_unmap(pte);
 		pte = NULL;
 		/*
-		 * Readahead entry may come from a device that we are not
-		 * holding a reference to, try to grab a reference, or skip.
-		 *
-		 * XXX: for now, always try to pin the swap entries in the
-		 * readahead window to avoid the annoying conversion to physical
-		 * swap slots. Once we move all swap metadata to virtual swap
-		 * layer, we can simply compare the clusters of the target
-		 * swap entry and the current swap entry, and pin the latter
-		 * swap entry's cluster if it differ from the former's.
+		 * The target entry is already pinned - if the readahead entry
+		 * belongs to the same cluster, it's already protected.
 		 */
-		swapoff_locked = tryget_swap_entry(entry, &si);
-		if (!swapoff_locked)
-			continue;
+		if (!vswap_same_cluster(entry, targ_entry)) {
+			swapoff_locked = tryget_swap_entry(entry, &si);
+			if (!swapoff_locked)
+				continue;
+		}
 		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
 						&page_allocated, false);
-		put_swap_entry(entry, si);
+		if (swapoff_locked)
+			put_swap_entry(entry, si);
 		if (!folio)
 			continue;
 		if (page_allocated) {
diff --git a/mm/vswap.c b/mm/vswap.c
index fbb7c6003ad8c..b391511e0f0b9 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -1418,6 +1418,16 @@ void put_swap_entry(swp_entry_t entry, struct swap_info_struct *si)
 	rcu_read_unlock();
 }
 
+/*
+ * Check if two virtual swap entries belong to the same vswap cluster.
+ * Useful for optimizing readahead when entries in the same cluster
+ * share protection from a pinned target entry.
+ */
+bool vswap_same_cluster(swp_entry_t entry1, swp_entry_t entry2)
+{
+	return VSWAP_CLUSTER_IDX(entry1) == VSWAP_CLUSTER_IDX(entry2);
+}
+
 static int vswap_cpu_dead(unsigned int cpu)
 {
 	struct vswap_cluster *cluster;
-- 
2.52.0


