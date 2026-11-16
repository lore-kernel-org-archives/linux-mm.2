Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9797B606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=PB6GyIII
Received: by kanga.kvack.org (Postfix)
	id 14E556B05BA; Mon, 16 Nov 2026 06:04:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEEA6B05BB; Mon, 16 Nov 2026 06:04:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08C06B05BC; Mon, 16 Nov 2026 06:04:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D24E66B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:04:06 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65B7B1A090D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:06 +0000 (UTC)
X-FDA: 85440697692.16.32E9E03
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 881421C000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:04:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PB6GyIII;
	spf=pass (imf18.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FOptmx/nKaTXpVpA1qDUtPfxFqOvBUlo8nEFPXsgeb8=;
	b=g9Aajk/5j4AnTL8DB/OMoo6lozt7qH6BQ49X5oMlUh+LLk5pf0jrDJttt01Pu7SSPkzK1f
	6pnkrAe2V7Y1egNkwE8kdMcHKnjrhiB5AHWVLxGEU5nJotfHqK+nxzL73hqseetZEf8RVb
	dOrSaHgip3m2QMfzxbnZJxNWOczltNg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827044;
	b=Sv0/l1DpSbzmTKJp8fNOHWFIPZxzSyGoiDT0gCMV1/HmAmIV7doHOLcGn/8XJPYO3agIcy
	RWrsSROsjBiy8ZsEcrjwUnhz4QvG3fek6KaBsElEC4QrGQX7y2x8IxF9KDrOs7eYh+kX4o
	TyXIexkBP8syyF5sAanSnu/wwfYFe8Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=PB6GyIII;
	spf=pass (imf18.hostedemail.com: domain of nakixii@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=nakixii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-170135e43c7so5232234c88.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794827043; x=1795431843; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FOptmx/nKaTXpVpA1qDUtPfxFqOvBUlo8nEFPXsgeb8=;
        b=PB6GyIIIsxFi0ET6KSxFea1AxM4FA/koySCXdq8Z/jHdPuzkBH69YsNNIaJcrk9IoG
         NCrIyK1UOrh7uXtCHLZKcuWdD6wyxl3v0PRDWkK3IWr3U5+rd1YG+GBeF+sBu3bGS+ur
         8yL6Ofe64wj0TZlfisVGz6s9RRa2X34kbtJArEXn+0QWTO9IgDYJQSvgbINt2D/QEnIh
         WQls+wbqPfFRPF72OYmbBsu5FY9NdEHpPJSjOqE+Q5KpGkWrlkR62Iq5OoETm6E98P7f
         6gsqZTePSYrJDPZDxU7CHBUp1u2rH792pyBTsMmKM4PyLiX7wG+cJTtmAhB+J0fKHe7b
         0z3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794827043; x=1795431843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FOptmx/nKaTXpVpA1qDUtPfxFqOvBUlo8nEFPXsgeb8=;
        b=HZMxkCiuuQue04GZnLKpe0hlxX6n0oql6o0zJI09PTJ++QYYAcfz1r5mx4mm2ndc0j
         N0YTmcSmVJY1i5G3xfr6/YnTdFDfUvLEYNUOGzQ52FcRmzIOM7Z8pNtHC260vat71hKP
         WDv/iSuTk5KD6cvVbNj4umw9xzrhLbHQeht0RxpPjZNHVjjcxBr3W84oSrkdulTNzxp6
         eaQMmZGtY+s9kdeD+7aZX+wYjXOeoBeybKlVzWw80zR1sUfXpzVhxtRVZhhMKCdn+yJx
         2ArPRiZC6sHb7ZdeEDtNChuiA3Sywd7BUXr+YoHyagr7km8PZPF9wCfml8MkH41mHvOR
         p2hQ==
X-Gm-Message-State: APuU4Z+q3eAD3CVnZJ+3ql/NgCNxRhTW9F2mZzRFRM4SJTNOSG/H+/gc
	YA4UYYy0yrpWzClZsa3QdBV01yHJKBfxJwgg4dtIi8OUZJKOKdrmF4S1nXcTOTtwp+EC26N+
X-Gm-Gg: AYBFou1i9DEaQ4kmr1xfMJPuEr/BGZSjgfzq4OFQGHe9t4tpBafpD5ToiNoHlzAoEjq
	eptbg9m0+R2LVHVOV6doxYcTq4SEybDRHhT15KdpzjBpg/GEZ6sHDNyJc/5Fmv4Ho2wlWxTHhgl
	Nj2kNAlCExJVERe7M1ty/s0CYxB3IXbX3KpQGT5pMkvWRbfU6RIRNT0Kn9LkWcvqVP9C2h5kqmz
	G7j49k+zuUsmy52nT7zaYUK9Sh1tvmRDOV3YeaQggQtQrWHZRVbFtvvIl49Ewk1ZWqgtoTcW/O4
	a0YxlwNRTeayCwlu1CrlCw1gOnldd2QXpKNt+Ssr22C6DtE6A/niU/ZYBANurayE50rcBab/4Yt
	2y/4Un2t7482hP/iTEP4vxcnCCmAxxhvNirvc/986jP82l2E3vube6Gc39pjRAbGJvGAD1JvfX4
	qi+sQDmgLGUuozGakTWskrHg/NPA8KY+FEGSY9EMkTuL89Ia+YumMTumxgTT18bR0a6P+dnq2HU
	B+OJADVeJ7BlsZcrf8vhbRHt273LMhWuideblWCXViIZSGeMMtnQyiHwQPeeEcBFiZWHNv4/SNa
	iR92y4+ObMiQTebDM+squV87JIGL0STQPcfw0pO12pwNbNEOQUfWiwMuAvonKPkLuHKU
X-Received: by 2002:a05:7022:f50a:b0:1a4:c892:b130 with SMTP id a92af1059eb24-1b5031152eamr10336840c88.15.1794827043076;
        Mon, 16 Nov 2026 03:04:03 -0800 (PST)
Received: from naki-PC.localdomain ([203.175.14.54])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031918c7sm42999260c88.9.2026.11.16.03.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 03:04:02 -0800 (PST)
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
Subject: [RFC PATCH 05/16] mm: memcomp: charge compressed pages to the source memcg
Date: Mon, 16 Nov 2026 19:01:11 +0800
Message-ID: <20261116110122.309748-6-nakixii@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261116110122.309748-1-nakixii@gmail.com>
References: <20261116110122.309748-1-nakixii@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n3ipra9k3zsdgq3nqfcc91gn7y7fq5yq
X-Rspamd-Queue-Id: 881421C000E
X-Rspam-User: 
X-HE-Tag: 1794827044-430229
X-HE-Meta: U2FsdGVkX18q4YWW/BuKGpzM6QDgj5TAXVVCi4gEJw0vFIT8WvFvcC0D7hzHOgKyqbv1mgT02myM+5hCh4NLe5LWycCM/RtyXjoVKaGGz2my2di5w7pRAUBlC4WWifvqwp8Egt6I6xJMJjomOYpKTJu97ktpOIz7jpxoaCNo2C5/Z9ocapuqH88VENJtbtARYV470Gw4I8h1ucMfQR2ADdb24TGJmHNbbkXiq/y/B/g2C95pqDt2yT5jdsrIbT6dnRdRMCvZRIo2JrAuCDZed4IOcO7TzYXJcyBUood8AKHykZkvjyj1NNNsZF1sKS7FiT3AMtrz8QrHCCVX0IUbUH0o44bt6tS1kQxT4mYw9lGjbqrqf+n4/wgAvtledcZB37g+/E0RpzkcTlDKieM4sQAnhLfw+L8VITMv4LtWsLRSNktG+mHRXnMbGBNrgDAf8fDAoAiGoYQypXCe8/tF6A8R3e1PswHDUlqcite9MfVucNgwqlfQhZ7jI/x8+ozXfkp/d7jhypq5R2coq+YETZOSi1FrKS69BgM8sj4Ttl8DZaXMurKMQnbYWVJa+mWAAWs94bqurDMDfMaNr0jXa2hq/TT/ix9+ed7OvPBj48fI+0sxSfDGb3bLIC8h4V1vrMQwAvR35W4D00Pq9fE2cpiujvhDs1hYOnLJMQFPYDj7JFMWh8zdFwp3UiGzuOx4XZEtsDVibsAa0sih9AVP/7U6UjL77UOL8O85XgDWlTzice+Og+wbpIU5uWMgwRLscug0AguJa3g7GrfzCDScO7o/Rj4VKNxoagDKOHCC+9ls8jZ2WUAQORgguD/o1lLpbfxkRbtn/34HBOzeZpGMjDMJGaKE0Gy+tumeasIAXmvQMdy+9tJiGFCG7ON2GB4AS6h5nMyGusxygm5AtopX6SDwxmqU/Mc0YnzyTdkra1QwN6ypHhg3ZWc82jAAag1XbERRTu1qQ9jymMw+LBI
 NlBznweB
 71cCaJFYq4rDDu7Q5RdEhG3DO5y3wfa2KsHzdbJgMc2vdIf61sSCMEyRM+OEIDSBqZ8pWNjSh++so/w2wlMlzpw7ZF2RqhHmO93w+jEL7jGJya/J/39VP2wKIBBxmEDJuJSSCDQEA80Wnije2yKGkMd9udJ0mPWv1LEN1z6pGvauUxMiUhronJjJ8z/gJDYmR31k1TbdR+mwz8xQfazSRuCmJvFGzKayYyqE1+O9hz3r1LttpVzj/cgKhwMtCH5OVeweduVZ1oYTsiEpYdYgWZGWnQb7g/8MIszaBRNyQxtk1cZ6YcsSmkCjyRNfAOO1FkxnRMvlDFnRae8vWW6ojooP84FX4o3GSZC9srzyNWIscS+sguWHhTal0f3Si/AmNKHuxoZZWqBEtwMjZZLpQwq3s1TzeIV5GQfmDqWoim0bDwMZpM7o/5TLJ41UkVgAfEzXKJPgMXPs5dX5CA3d2tTJ2KeNrb9bBMKiR6Gqex6ll1ZrV+kUhZYtBtt289S2BU1zK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reclaim can execute in a different memory cgroup from the folio that
owns the contents. Charging compressed storage to the reclaiming task
can move memory usage away from the cgroup that supplied those pages.

Capture and retain the source folio's object cgroup for resident records
and per-key storage. Charge allocated metadata and payload bytes to that
owner, including allocator-sized metadata where applicable. Nonzero
same-filled slots have metadata but no allocated payload; the zero
domain has neither a slot nor a payload charge.

Reserve payload charges outside the token lock with non-reclaiming
allocation flags. Transfer a charge only when its payload is published,
and refund it when allocation or revalidation prevents publication.
Refresh releases the superseded payload charge while preserving the
ownership needed by its replacement.

Release payload charges with their backing, and retain metadata charges
and owner references until their corresponding records, segments,
clusters and keys are freed. RCU readers must not outlive the metadata
or its accounting owner. Leave restored-folio charging to the ordinary
memory-management paths rather than adding a separate cgroup quota.

Signed-off-by: nakixii <nakixii@gmail.com>
---
 mm/memcomp.c         | 22 ++++++++++++++++++----
 mm/memcomp/storage.h | 22 ++++++++++++++++++++--
 2 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/mm/memcomp.c b/mm/memcomp.c
index 80b71e217ff5a6a2fa1d033edf6079a670a55020..8944fa081f3e35bfacf00d3a1c09c8bb32a9db18 100644
--- a/mm/memcomp.c
+++ b/mm/memcomp.c
@@ -663,29 +663,43 @@ static void memcomp_zs_free(u8 pool_idx, unsigned long handle)
 
 static struct obj_cgroup *memcomp_objcg_get(struct folio *folio)
 {
-	/* Compressed objects do not have an accounting owner yet. */
-	return NULL;
+	return get_obj_cgroup_from_folio(folio);
 }
 
 /* Hold an additional metadata owner without bypassing the test model. */
 static __maybe_unused void memcomp_objcg_get_ref(struct obj_cgroup *objcg)
 {
-	/* No accounting owner was acquired. */
+#ifdef CONFIG_MEMCG
+	if (objcg)
+		obj_cgroup_get(objcg);
+#endif
 }
 
 static void memcomp_objcg_put(struct obj_cgroup *objcg)
 {
-	/* No accounting owner was acquired. */
+	obj_cgroup_put(objcg);
 }
 
 static int memcomp_objcg_charge(struct obj_cgroup *objcg, gfp_t gfp,
 				size_t size)
 {
+#if defined(CONFIG_MEMCG)
+	if (!objcg || !size)
+		return 0;
+
+	return obj_cgroup_charge(objcg, gfp, size);
+#else
 	return 0;
+#endif
 }
 
 static void memcomp_objcg_uncharge(struct obj_cgroup *objcg, size_t size)
 {
+#if defined(CONFIG_MEMCG)
+	if (!objcg || !size)
+		return;
+	obj_cgroup_uncharge(objcg, size);
+#endif
 }
 
 #include "memcomp/format.h"
diff --git a/mm/memcomp/storage.h b/mm/memcomp/storage.h
index bae605f20e79bec5d6dc5573f3148ef15e95ee84..f11aad87a1773c0e2f16b1bb3d506cb4caeb7386 100644
--- a/mm/memcomp/storage.h
+++ b/mm/memcomp/storage.h
@@ -223,8 +223,26 @@ static inline void mc16_retained_empty_dec_locked(void)
 static inline void *mc16_kmalloc_owner(size_t bytes, gfp_t gfp,
 				       struct obj_cgroup *objcg)
 {
-	/* Metadata remains unaccounted until a source owner is introduced. */
-	return kmalloc(bytes, gfp & ~__GFP_ACCOUNT);
+	struct mem_cgroup *memcg = NULL, *old;
+	void *ptr;
+
+#ifdef CONFIG_MEMCG
+	if (objcg)
+		memcg = get_mem_cgroup_from_objcg(objcg);
+#endif
+	old = set_active_memcg(memcg);
+	/* An unaccounted/root source must not charge the submitting task. */
+	if (objcg)
+		gfp |= __GFP_ACCOUNT;
+	else
+		gfp &= ~__GFP_ACCOUNT;
+	ptr = kmalloc(bytes, gfp);
+	set_active_memcg(old);
+#ifdef CONFIG_MEMCG
+	if (memcg)
+		css_put(&memcg->css);
+#endif
+	return ptr;
 }
 
 static inline void *mc16_owner_alloc(size_t bytes, gfp_t gfp,

