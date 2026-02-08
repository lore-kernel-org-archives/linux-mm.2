Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33660EF06F8
	for <linux-mm@archiver.kernel.org>; Sun,  8 Feb 2026 21:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1C76B00A8; Sun,  8 Feb 2026 16:59:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8811C6B00AA; Sun,  8 Feb 2026 16:59:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3B96B00AB; Sun,  8 Feb 2026 16:59:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E28F6B00A8
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 16:59:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFE88C21FC
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:22 +0000 (UTC)
X-FDA: 84422656164.16.0FB0441
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id 22AF31C0003
	for <linux-mm@kvack.org>; Sun,  8 Feb 2026 21:59:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vb3ehchA;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770587961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEUe6oTCoBFfM+Sx9vNYCw5ijDc8cAJk/jm6jmf+e+o=;
	b=wJQ+vvnqPaaS2ADEsffBgLtsi4gygkTgemwjMMimdIkAOxajm7NpSo8i5wJDutVVcE5KAx
	6RiHpt0YFD9g8IzEQUs500Nnz/bQnzTu31oCPBDThht8IFY0OVKcqpkBk5e6J7rN4Y2687
	vijq8qXRr23dor0tgoy+c7/UKcGdFlM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Vb3ehchA;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770587961; a=rsa-sha256;
	cv=none;
	b=y4bpXe/GBulfgMwccz1lE981zJM78Y9PKQ7p4dhbw5ZDUhL04EHDGc9KElW1AH1sUbdCS/
	EhJ3ZEHAX6U7nYPUeTs7M44K/FErQdgmIwubqcwKQjlzZYUcmc0XOZ8iIIsFXf+7AlAf4r
	qxfDRTQbQ2VOgxXNtAMceG8UYC72xj0=
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-45efe81556fso2601750b6e.2
        for <linux-mm@kvack.org>; Sun, 08 Feb 2026 13:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770587960; x=1771192760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dEUe6oTCoBFfM+Sx9vNYCw5ijDc8cAJk/jm6jmf+e+o=;
        b=Vb3ehchAU7WQLzBFZuhNv1PikQekZYB01+bQuKzxempqfcy+qwyriX824oBm0RXkXs
         MYHMHjyosaNoZF9d1/yuKOuoAhn38rRHUtEM2gCAqpZ0GHexff6Wun5GeCMc5sum+FSE
         Vu/RJYaD/SSC19PQkhivrMt0/e/bhCp+p/u7z0X7T7jXsAXXTqPoT87IU9A1PvW3uhRf
         9WPB6Dr0D5P6fbKX3mTYFScxD1iAN+kOVW4+aPyIUFX8/4y6VLbu5Arvw1idO0pRz+TC
         vmq/gzEmyhZ+3FmvDZXLC72PZgiyCY7hPiLDoPP2f+VDd4QL5E3jXLwDw4civCeG6Rw/
         uN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770587960; x=1771192760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dEUe6oTCoBFfM+Sx9vNYCw5ijDc8cAJk/jm6jmf+e+o=;
        b=SfituvzusM/WWEIKbQNr6rYQGgYScAzhGrMWsI4K88TLx/bM4Tw2L9tfEWcHBM4lyq
         qTgf65X89CkRvFuUqffgqptZhSKkivZuTk/CFVjISZEy4ONp9s0WLhaHVdzvRQB75PJC
         Qj0/ugZPjwdpiW0/TgzprC5e+XYh5NSBLNrQA/T3zXZt4L+FRZR5xj5uxsZDt13dCCg5
         rwqhDxUXrossdddNdKcWKPL1JO0QvdJWN5Mx0cnnA13Hcbq3uySCDunZ2l43dCtVWi6q
         VW+fz5JWEeYmQR19+7ltIPkV0BmttjUIwkq3ZF3j3JZ8UJyeNW96UQY32ubjj6uZTw24
         IvrA==
X-Gm-Message-State: AOJu0Yyg9WSOOPrH3fJ5cBZeGkDG+keViO9P8aEPbKpWfdLNQ5ZnQaKo
	oS94Wz+UyKtY0WWpuI34mJbIr4s4U4UefFzDytSa106FN6mXpsw/+3w2c43oVvHyUpd7Ng==
X-Gm-Gg: AZuq6aKd5/MafFDDfO65ApaHMAOyU8jePAuSbBfBcB740P7Ddqt+7IIIEr2Uss8fFGg
	ZeUKUgNLJtM/RuoXORRXZCPUroCG3sueGqMdIV9ALz6ho+mfNuKerKAm0jXwC8YbSSReZUSZfmN
	2NtLLyNMftTxCFIWQAnm+wz0KZRcDIG4emFmqxwDG7ncgeCn6/U2nICWXY7YGhUwBUNXfbI6Ouq
	EVejb/jZq0b4x8ibmMKP8x2Ybm2Wx9kEUrGaxu1jtQmwBkCs8PaVoKXWv4imUAl97G4H2x0KCZ9
	CZtdjohXJXiBdVll7Q7wYEJMd+BXatbn0tB+Uk+o7KpyeWOKWf8oBYI9WwyjQqiVd312p5mOKFJ
	Ff5wNO8ZO7BGoDqJ0jcEOiUf3/uM1FFTFoTodlQShYBnuhJLYhgGrUoqSs2sDVW8uSP5TDC58A9
	mVhhVPu+0KijdqEKxm9rZ0WOVKy7EMD7C2
X-Received: by 2002:a05:6808:158e:b0:45e:f0ef:cd75 with SMTP id 5614622812f47-462fcb77c7amr4638475b6e.65.1770587960064;
        Sun, 08 Feb 2026 13:59:20 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:2::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-462fe9df04esm5291448b6e.7.2026.02.08.13.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Feb 2026 13:59:18 -0800 (PST)
From: Nhat Pham <nphamcs@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	hughd@google.com,
	yosry.ahmed@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	len.brown@intel.com,
	chengming.zhou@linux.dev,
	kasong@tencent.com,
	chrisl@kernel.org,
	huang.ying.caritas@gmail.com,
	ryan.roberts@arm.com,
	shikemeng@huaweicloud.com,
	viro@zeniv.linux.org.uk,
	baohua@kernel.org,
	bhe@redhat.com,
	osalvador@suse.de,
	lorenzo.stoakes@oracle.com,
	christophe.leroy@csgroup.eu,
	pavel@kernel.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org,
	peterx@redhat.com,
	riel@surriel.com,
	joshua.hahnjy@gmail.com,
	npache@redhat.com,
	gourry@gourry.net,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	rafael@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: [PATCH v3 18/20] memcg: swap: only charge physical swap slots
Date: Sun,  8 Feb 2026 13:58:31 -0800
Message-ID: <20260208215839.87595-19-nphamcs@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260208215839.87595-1-nphamcs@gmail.com>
References: <20260208215839.87595-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dzhdz8wjrwmd57yf8gqs9jtte3esup9c
X-Rspamd-Queue-Id: 22AF31C0003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770587960-951443
X-HE-Meta: U2FsdGVkX19qCbiUjiEcSkYwn+ghZ2Ac9RV9Ey/hpujmki0vvB5Z7ZmKldWgUB3KK2Ql3d4RIJD/AmzN/cawVrq98p01LUtAO1gssIYqET4dOlILKevJtzqxV1WH9MwAxVY4/lq4/8YBfbodyjGxENJI43iPTmGOGe+i3y8yEH3m+ziRtXZBE/k94RauwQMn+H3isH+kbEgjh7tFEU8M2YsZnTuSQB5F+zm91mLN/q3p5QRKxUAj0pzKFiWzC5v0ga+oSdBPHCFVPC+Ib2krT9STX5sJvnZodHtjEPUIVe3ifwiL+qGXVJlbfle64KiNRcaFI6TH/bMVzVzcrksfs5NBEeUvqvVFFPixip+5B/IPym/xNKcvQh2Ovj/3q7NqwnbOGD+IQzdrhVVisTmy0TlVEt3Flu/SSZ/6KYGejD1FJqN8EFEufC1uZ4Rdpw/mP0OmK+L+QNmkydvSzXsRqgloRWxVC6JTqKvZ2rxk3M5/QI8haZTv14shdXBOzMsa1HitwI1d0dQYFou53PhMKO5Z6mI88taE+V42vSjSBI8MpMHougf/sweyCbiv82VTFmnlM7YzyM0TDgzF2Zv0EJ7CJc3/caWpE6nV3tgCJJ9iXX+rEyqvNE863yRB2RxdUBqF3Pma3oRgNjT/a6PcGmaH+NVy/eeyj+1WSfFAnz39f1xmpxbSmtI9ZqlfRhE8bHHyHqGWenAotIYr3B6RYaZYbb/iMa2gM/iZNC11w3OD0+yuED9tmvfgW+rE7Ljxf94iLSCYW0s27CN+bwYiOERNPcahGXcF/W2Bixtm+xgkjCvvXSCz1z/qe7IkUSCu8t1eOVqApr9Gne6zoKdniwVtNClRn99l+rhrpanGAGCTjaGbjAmOiNFR1En1pH7i7At8Xdedk1dOoqysqpDy3HxdYvC16jyl5pbnhju+M9jvXWbJxYxAD98TmqAWc0eSZ7rvFm2+IGHc85Pe2SQ
 YvQJKi1t
 YbztXovqaaiBmDb7PpozxOFmedD3wkj+Phu7leapJLGdrKx37iJ0eTme8HCcSSQp0a2NpxmILYdQUSfycC+t7xwJ53I6MGtS8jQS/txoJAIvPzDQ9nuGVbkqkLyw3v9UWtywOUpPzeR0MIOujrPvxZBqPw59X5kz6Lw0HJRcZ1y8a0hp+qxBAxkWHhekF16egfVKgveTVIjAG6kbQ8iVBIhZm1IwL32prsKbZmbZ6zV5ziZlY0QZPNaCqPPZxq+BCS3P2NKYhfGfFp/mYu09iq/HqEMKGENbpYACJE3XquiZgTzKKgL4oZsuGvAwI5+Ww7ObjWl8MFJWPPeWdNHpgs8LICkbLKdaxpxZqzHV0Ym3ntVEvEYC2LzmZ0j2WZ3QBFggHhrXJixa6eobFha2vqGHSA9netv3dfiudVC24umCKMQX9YoPfxf7IyX5cA619czOV5MGJN2aapnyc+4z+YJV+zv+784q0/O2DUqIm/w5Qm6OHBPn4yQ4ZTptBq4Jb4QFaqPHRdiYs4dQmtyv/mhDOpghstJO8kFS8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that zswap and the zero-filled swap page optimization no longer
takes up any physical swap space, we should not charge towards the swap
usage and limits of the memcg in these case. We will only record the
memcg id on virtual swap slot allocation, and defer physical swap
charging (i.e towards memory.swap.current) until the virtual swap slot
is backed by an actual physical swap slot (on zswap store failure
fallback or zswap writeback).

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 include/linux/swap.h | 16 +++++++++
 mm/memcontrol-v1.c   |  6 ++++
 mm/memcontrol.c      | 83 ++++++++++++++++++++++++++++++++------------
 mm/vswap.c           | 39 +++++++++------------
 4 files changed, 98 insertions(+), 46 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 9cd45eab313f8..a30d382fb5ee1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -613,6 +613,22 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 #endif
 
 #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
+void __mem_cgroup_record_swap(struct folio *folio, swp_entry_t entry);
+static inline void mem_cgroup_record_swap(struct folio *folio,
+		swp_entry_t entry)
+{
+	if (!mem_cgroup_disabled())
+		__mem_cgroup_record_swap(folio, entry);
+}
+
+void __mem_cgroup_clear_swap(swp_entry_t entry, unsigned int nr_pages);
+static inline void mem_cgroup_clear_swap(swp_entry_t entry,
+		unsigned int nr_pages)
+{
+	if (!mem_cgroup_disabled())
+		__mem_cgroup_clear_swap(entry, nr_pages);
+}
+
 int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry);
 static inline int mem_cgroup_try_charge_swap(struct folio *folio,
 		swp_entry_t entry)
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff7426..4580a034dcf72 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -680,6 +680,12 @@ void memcg1_swapin(swp_entry_t entry, unsigned int nr_pages)
 		 * memory+swap charge, drop the swap entry duplicate.
 		 */
 		mem_cgroup_uncharge_swap(entry, nr_pages);
+
+		/*
+		 * Clear the cgroup association now to prevent double memsw
+		 * uncharging when the backends are released later.
+		 */
+		mem_cgroup_clear_swap(entry, nr_pages);
 	}
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2ba5811e7edba..50be8066bebec 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5172,6 +5172,49 @@ int __init mem_cgroup_init(void)
 }
 
 #ifdef CONFIG_SWAP
+/**
+ * __mem_cgroup_record_swap - record the folio's cgroup for the swap entries.
+ * @folio: folio being swapped out.
+ * @entry: the first swap entry in the range.
+ */
+void __mem_cgroup_record_swap(struct folio *folio, swp_entry_t entry)
+{
+	unsigned int nr_pages = folio_nr_pages(folio);
+	struct mem_cgroup *memcg;
+
+	/* Recording will be done by memcg1_swapout(). */
+	if (do_memsw_account())
+		return;
+
+	memcg = folio_memcg(folio);
+
+	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
+	if (!memcg)
+		return;
+
+	memcg = mem_cgroup_id_get_online(memcg);
+	if (nr_pages > 1)
+		mem_cgroup_id_get_many(memcg, nr_pages - 1);
+	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
+}
+
+/**
+ * __mem_cgroup_clear_swap - clear cgroup information of the swap entries.
+ * @folio: folio being swapped out.
+ * @entry: the first swap entry in the range.
+ */
+void __mem_cgroup_clear_swap(swp_entry_t entry, unsigned int nr_pages)
+{
+	unsigned short id = swap_cgroup_clear(entry, nr_pages);
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(id);
+	if (memcg)
+		mem_cgroup_id_put_many(memcg, nr_pages);
+	rcu_read_unlock();
+}
+
 /**
  * __mem_cgroup_try_charge_swap - try charging swap space for a folio
  * @folio: folio being added to swap
@@ -5190,34 +5233,24 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
 	if (do_memsw_account())
 		return 0;
 
-	memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg, folio);
-	if (!memcg)
-		return 0;
-
-	if (!entry.val) {
-		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		return 0;
-	}
-
-	memcg = mem_cgroup_id_get_online(memcg);
+	/*
+	 * We already record the cgroup on virtual swap allocation.
+	 * Note that the virtual swap slot holds a reference to memcg,
+	 * so this lookup should be safe.
+	 */
+	rcu_read_lock();
+	memcg = mem_cgroup_from_id(lookup_swap_cgroup_id(entry));
+	rcu_read_unlock();
 
 	if (!mem_cgroup_is_root(memcg) &&
 	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
 		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
 		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
-		mem_cgroup_id_put(memcg);
 		return -ENOMEM;
 	}
 
-	/* Get references for the tail pages, too */
-	if (nr_pages > 1)
-		mem_cgroup_id_get_many(memcg, nr_pages - 1);
 	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
 
-	swap_cgroup_record(folio, mem_cgroup_id(memcg), entry);
-
 	return 0;
 }
 
@@ -5231,7 +5264,8 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 	struct mem_cgroup *memcg;
 	unsigned short id;
 
-	id = swap_cgroup_clear(entry, nr_pages);
+	id = lookup_swap_cgroup_id(entry);
+
 	rcu_read_lock();
 	memcg = mem_cgroup_from_id(id);
 	if (memcg) {
@@ -5242,7 +5276,6 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
 				page_counter_uncharge(&memcg->swap, nr_pages);
 		}
 		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
-		mem_cgroup_id_put_many(memcg, nr_pages);
 	}
 	rcu_read_unlock();
 }
@@ -5251,14 +5284,18 @@ static bool mem_cgroup_may_zswap(struct mem_cgroup *original_memcg);
 
 long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
 {
-	long nr_swap_pages, nr_zswap_pages = 0;
+	long nr_swap_pages;
 
 	if (zswap_is_enabled() && (mem_cgroup_disabled() || do_memsw_account() ||
 				mem_cgroup_may_zswap(memcg))) {
-		nr_zswap_pages = PAGE_COUNTER_MAX;
+		/*
+		 * No need to check swap cgroup limits, since zswap is not charged
+		 * towards swap consumption.
+		 */
+		return PAGE_COUNTER_MAX;
 	}
 
-	nr_swap_pages = max_t(long, nr_zswap_pages, get_nr_swap_pages());
+	nr_swap_pages = get_nr_swap_pages();
 	if (mem_cgroup_disabled() || do_memsw_account())
 		return nr_swap_pages;
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
diff --git a/mm/vswap.c b/mm/vswap.c
index 7563107eb8eee..2a071d5ae173c 100644
--- a/mm/vswap.c
+++ b/mm/vswap.c
@@ -543,6 +543,7 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 	struct vswap_cluster *cluster = NULL;
 	struct swp_desc *desc;
 	unsigned long flush_nr, phys_swap_start = 0, phys_swap_end = 0;
+	unsigned long phys_swap_released = 0;
 	unsigned int phys_swap_type = 0;
 	bool need_flushing_phys_swap = false;
 	swp_slot_t flush_slot;
@@ -572,6 +573,7 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 		if (desc->type == VSWAP_ZSWAP && desc->zswap_entry) {
 			zswap_entry_free(desc->zswap_entry);
 		} else if (desc->type == VSWAP_SWAPFILE) {
+			phys_swap_released++;
 			if (!phys_swap_start) {
 				/* start a new contiguous range of phys swap */
 				phys_swap_start = swp_slot_offset(desc->slot);
@@ -602,6 +604,9 @@ void vswap_rmap_set(struct swap_cluster_info *ci, swp_slot_t slot,
 		flush_nr = phys_swap_end - phys_swap_start;
 		swap_slot_free_nr(flush_slot, flush_nr);
 	}
+
+	if (phys_swap_released)
+		mem_cgroup_uncharge_swap(entry, phys_swap_released);
  }
 
 /*
@@ -629,7 +634,7 @@ static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
 	spin_unlock(&cluster->lock);
 
 	release_backing(entry, 1);
-	mem_cgroup_uncharge_swap(entry, 1);
+	mem_cgroup_clear_swap(entry, 1);
 
 	/* erase forward mapping and release the virtual slot for reallocation */
 	spin_lock(&cluster->lock);
@@ -644,9 +649,6 @@ static void vswap_free(struct vswap_cluster *cluster, struct swp_desc *desc,
  */
 int folio_alloc_swap(struct folio *folio)
 {
-	struct vswap_cluster *cluster = NULL;
-	int i, nr = folio_nr_pages(folio);
-	struct swp_desc *desc;
 	swp_entry_t entry;
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
@@ -656,25 +658,7 @@ int folio_alloc_swap(struct folio *folio)
 	if (!entry.val)
 		return -ENOMEM;
 
-	/*
-	 * XXX: for now, we charge towards the memory cgroup's swap limit on virtual
-	 * swap slots allocation. This will be changed soon - we will only charge on
-	 * physical swap slots allocation.
-	 */
-	if (mem_cgroup_try_charge_swap(folio, entry)) {
-		rcu_read_lock();
-		for (i = 0; i < nr; i++) {
-			desc = vswap_iter(&cluster, entry.val + i);
-			VM_WARN_ON(!desc);
-			vswap_free(cluster, desc, (swp_entry_t){ entry.val + i });
-		}
-		spin_unlock(&cluster->lock);
-		rcu_read_unlock();
-		atomic_add(nr, &vswap_alloc_reject);
-		entry.val = 0;
-		return -ENOMEM;
-	}
-
+	mem_cgroup_record_swap(folio, entry);
 	swap_cache_add_folio(folio, entry, NULL);
 
 	return 0;
@@ -716,6 +700,15 @@ bool vswap_alloc_swap_slot(struct folio *folio)
 	if (!slot.val)
 		return false;
 
+	if (mem_cgroup_try_charge_swap(folio, entry)) {
+		/*
+		 * We have not updated the backing type of the virtual swap slot.
+		 * Simply free up the physical swap slots here!
+		 */
+		swap_slot_free_nr(slot, nr);
+		return false;
+	}
+
 	/* establish the vrtual <-> physical swap slots linkages. */
 	si = __swap_slot_to_info(slot);
 	ci = swap_cluster_lock(si, swp_slot_offset(slot));
-- 
2.47.3


