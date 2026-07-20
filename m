Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EB36C4452E
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9160F6B00D6; Mon, 20 Jul 2026 15:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDEB6B00D8; Mon, 20 Jul 2026 15:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5336B00D9; Mon, 20 Jul 2026 15:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42B9E6B00D6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:36:11 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE22DA086F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:10 +0000 (UTC)
X-FDA: 85010160900.18.5D5E58B
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1A95F1C0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:36:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AEs0ZfNX;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDe0EIY/cD+bqy5JmFZ8sdGZo0VCgkgte/Ch1WssJBA=;
	b=RrbP60Rc86iP4ksc/QthLKqSsS7iSDukmM/p3LWGgXyXg628ynrzZOTI4Sdm7EDfXcr20c
	FhZM+AV2cJ+4dp22smebgKK8HXjUbIfHJB0kjxYRGdfi0bWqjeffjuLRD2nRTJRpUeiYWY
	RSL6WwAx82aZohyHEwoYjbMMXlWPNII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576169;
	b=q4weH7TxVVE1IsWRQfYx1vSIzCGSOskR5fm/Y+k6eGdOQjpNf6J04u+B3NBng7EbAa5mSL
	Es5CYXvgplu7p1x/BWYexvOgzE418gB0k+e85b5fjYJdirO+NuHqL7LN5dR1A4j/2GrD7N
	je5yLVG3sQIB9RawgiPZHxkpRgcpl9w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=AEs0ZfNX;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.171 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9305a2121a1so723011285a.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576168; x=1785180968; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BDe0EIY/cD+bqy5JmFZ8sdGZo0VCgkgte/Ch1WssJBA=;
        b=AEs0ZfNXGRehvaZdE8q76tRALFJWq3eMxJC+6OZ7BPMJaFF8fnUgQPnbhVf79gvukM
         e3XOv0F6GDBnj4w2w6oFr9RXiOFXcZlzBLfkEBHkNO34p7coClS2GmEhp2yUWo4Tq7B4
         2R0CaLwY1jRyam7mQBtSSyoDD+4Pq9vGMmo1kP1oi2PqIFOigJezacQJDJB5hrvexx9Z
         2cdxRN0KufwpTRh0FpmhalwoUQuxCGMzebIB4GKPw7DDV3S6Sf892q9x9E1/65Q2UFA1
         YCAbAjVK2JK8F8fgLkpv9RQUmh/sNJflXWOal5A/66Cg4Q6sWqf++oqh1ZxOsozlPWAl
         Cvzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576168; x=1785180968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BDe0EIY/cD+bqy5JmFZ8sdGZo0VCgkgte/Ch1WssJBA=;
        b=ghRLF2Vb2roBu6XPBfiUHLwyAtT96wUKAwVk9WsU8B69UW//2NTX6csGntsSAAKNur
         OJhFE31zjkl44+p9bX3IQWWW7dciv0HeP/jN7MWjgYG+qCMTe2A6yL+Wq9nSLIMjYYEd
         DDhslh9i0o/tXru3Im96lsIQ4Hjdhhv9/cTPZksahoGT5FZlnpPNlijAb5QxgJxRcgXV
         3tpRFZTby4ZtyqFUNsYrfDyNo/a9/z4d+DzvcWSeqXhASPykEJUzsbD4axqdjZHqnwWN
         WkYEMuCBrAi8IDt/J+MAvjE58gU2gg4bdtHzOiCw2Y0J+Jf6QmvCenHwtlrT+9ydb3MG
         i/Hg==
X-Gm-Message-State: AOJu0Yyw8acpKJ2UKXtPrAbJEQeMADVNXGB0eV0431Yn3eTPjCSYSjRp
	gYQR/ZgwlDz59yQwUAZmLMwVW+eOxIc/3GqjCvr6ob4S9KoVb+5z2nNmugbGYtV7JM8tcokp/rR
	7lMos
X-Gm-Gg: AfdE7cnEX2xqA0t7WmPiVHCtLb7L4LzJ5gLjSFS7GKElJPnYOkco7JYVIZQUWUDC2tE
	d8O7Fy72l3WSoGeQ2mrQGo3ajZAl5Gc0+b+uXCnr5UuNRg5cnEn+MXyklAC3vdsDdXqs42UcvJO
	pmJ72KTztlPdG/TEVWBjRYXNjT6nWr6vPOG7ME/1xM8njIRkknmMvQyemfp8CstQ6txrwJl721b
	Wcq5W0HDW98GhXaSAdzY7p5IfpCKsmXCB/XnPVO/lfCuBXylqk74lmkn4uN1a4jF6m+Wfi2TTX5
	zOhRGgJU+UxPvJpSfhiX9huEAR3ZhUAmisAT43Ks5mVNsjIvehu5ArYSGs68U3tSRpAaZwUTQWO
	vOs+9VGMtpS+1jFUe2YWvSZw0bYuokVmoEI9hQw587FXsN0XiK7EWNZE71I9aKihD5/3hhP41vj
	av+0ioOvcERhKsvgi/8O9iass5DiWmc4pBawAr7/h4FFvYl9Dm9u91HVIV5deMOSQ=
X-Received: by 2002:a05:620a:28c7:b0:92e:c118:18b7 with SMTP id af79cd13be357-930b43c37e0mr1448114585a.86.1784576168124;
        Mon, 20 Jul 2026 12:36:08 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:36:07 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 34/36] mm/mempolicy: add mpol_set_shared_policy_range()
Date: Mon, 20 Jul 2026 15:34:28 -0400
Message-ID: <20260720193431.3841992-35-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1A95F1C0007
X-Stat-Signature: d8birtmheiwnt3a7twbrzh9jj5r886yt
X-HE-Tag: 1784576168-572874
X-HE-Meta: U2FsdGVkX19AK1/HzqUii3o+V8yKNV5NNdxSK8U1XC2tyw0FmYPN6pFg9WM0s+5kMmUpNX64LJU5VUjvd6u/aEpzZZnMT7hHajS8FXNU+LcG1/rzK1yax/OGP5Q5yFdPbYXIXPMPx8fg85lCUY3mQ0KHIkY9yauNr/+Jxs68nmynZ40R6M2El/cq9OsRwNtp89A3V1AJMGtTR3TWXbJKAaeffFpsX4CMBApXTBDVpSJHVzSiLKUVigCK9nVD19RLIKx6eUeOM0JNbP6kvgYDh5ze8XNd6409daVbdKOMX+QE4DkCDW0HLKETC0E57aghHZiChBfMKLc0sNqkX0xjhoQsHaeZol6eQNykXoE53h2cd/A1aXA4Rjxkuz1uVtHQBqNhqFRfp/dlAs9tWDDfbGH2IPzLv+SQy6dIJvVuDKf0bMe/5YMgUs40CdK4fSjDfK+o62YGsM/bTPTJHCXTSgzE4YynCSN4CUqjMqvr7M6aRafEXIS2H+jIc1SS+UupkNtQ6bQGO/G26eAK1/1N+SIxcInJSN/QEoE+kImT2kj35UxVoWxdznEE9+tJGocw9/uquGKL93B4fvq/s4HYEYMAc7+8M0ZyOthdciIV2zdri1gTCSui9w9xHyL0kzt8H7tsO75+ptFNjkPzAWkHkgApxOAn2FSy7GlziOw0U106nfBapOl2t5dxz4tXr+nUCfyt27TInL6YRtEmKE6JwIoX/JogzKaPKeybwekFSJKHUHipE1LA8bPeolCLPU3z9CJ+Dbnh4oZJCjPOTYnBQNGU4Rp4QUXVcvFwK5nLvBF+XyjnV4HaUMj3N2iFgrX1VDWXRpctVZqgJHGA5d6BguOSjrRTQXocHlb79/6FUduq/nmviz5hb5f+g6vM+BaBilXBJrvQsv7eCLtcuSA/2qUv7xSu9X/MsgXgvLDPwVTZQ8YMjk0kr1KOk8mK4pLMmVp9+/o5rUXb0M24LDF
 Mue3Y69A
 PEgishvwhXhf+egkvV6GKDM+sh88LmI2iyZ9kAmvU8qWh0opkZ86zSlUKzvz3FsNGRH8PhfAcpHJDtSzO+sRzdhUshpsX1GN7zNs4/hnTejuLfR7/8z0sFUDoVwu5wrzxZzeEchDrmLdav+YZQhNr975+DUZhoU37RKFvDxtmIEHYfmDnSwZYmPnXuF4sh899p/8zk/Po1f9CP+PuBaRm5MklLb3AWEKgoZYUqhugaSs/T9kmdAiA43RFy7qTws2D+nJXblPzJ84lnOp3mWI0S0M8JCnWVcsTQLxX1d9vy0Vi1IR8vIiQauF7pxtRnLgjhRk3EOx4iRMD2jZzEfcwDow0llFSS0g/VsXQBAKjPyaRXcCLjoA7OAHJjtG7K5sdx3/rbfohLgg7dk70Qn4coosqb9adCc4JmPlyEPz1CA9htSVgqL4Axm2NFktEUE7+eRYf5KDdd5weslI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mpol_set_shared_policy() installs a policy over a VMA's page-offset
range, which is the only programmatic way to populate an inode's
shared policy after init.

Two limitations make it unusable for binding an entire backing inode
from in-kernel code:

  - It requires a VMA, so it cannot cover unmapped offsets.
    (e.g. unmapped file folios faulted by pagecache)

  - mpol_shared_policy_init(), the only no-VMA installer, reconstructs
    the policy from mpol->w.user_nodemask.  That field is only populated
    for static/relative or mount-string policies.

    a policy built programmatically (e.g. by mpol_bind_node()) leaves it
    empty and stores w.cpuset_mems_allowed instead, so _init mangles it.

Add mpol_set_shared_policy_range(), which installs an already-built,
fully contextualised policy verbatim over an arbitrary [start, end)
page range with no VMA.

Reimplement mpol_set_shared_policy() as a thin wrapper that derives
the range from the VMA, so both share a single underlying path.

Suggested-by: Dave Jiang <dave.jiang@intel.com>
Co-developed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Assisted-by: Claude:claude-opus-4-8
---
 include/linux/mempolicy.h |  2 ++
 mm/mempolicy.c            | 35 +++++++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 715951a5b03c1..1348e9f5f2cf9 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -125,6 +125,8 @@ int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst);
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
 int mpol_set_shared_policy(struct shared_policy *sp,
 			   struct vm_area_struct *vma, struct mempolicy *mpol);
+int mpol_set_shared_policy_range(struct shared_policy *sp, pgoff_t start,
+				 pgoff_t end, struct mempolicy *mpol);
 void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    pgoff_t idx);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4daba81fff7c7..23c4c25097450 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3424,24 +3424,47 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
 }
 EXPORT_SYMBOL_FOR_MODULES(mpol_shared_policy_init, "kvm");
 
-int mpol_set_shared_policy(struct shared_policy *sp,
-			struct vm_area_struct *vma, struct mempolicy *pol)
+/**
+ * mpol_set_shared_policy_range - install @pol over [@start, @end) of @sp
+ * @sp:    the shared policy tree
+ * @start: first page offset (inclusive)
+ * @end:   last page offset (exclusive)
+ * @pol:   a fully-built, validated policy, or NULL to clear the range
+ *
+ * Installs @pol over the given range, replacing any overlapping policy.
+ * @sp takes its own reference, the caller retains its reference on @pol.
+ *
+ * The policy is not reconstructed, so the policy is preserved exactly.
+ *
+ * Unlike mpol_set_shared_policy(), no VMA is required, so a range that
+ * is never mapped into a VMA can be covered, including the whole file.
+ *
+ * Return: 0 on success, -ENOMEM on allocation failure.
+ */
+int mpol_set_shared_policy_range(struct shared_policy *sp, pgoff_t start,
+				 pgoff_t end, struct mempolicy *pol)
 {
-	const pgoff_t pgoff = vma_start_pgoff(vma);
-	const pgoff_t pgoff_end = vma_end_pgoff(vma);
 	struct sp_node *new = NULL;
 	int err;
 
 	if (pol) {
-		new = sp_alloc(pgoff, pgoff_end, pol);
+		new = sp_alloc(start, end, pol);
 		if (!new)
 			return -ENOMEM;
 	}
-	err = shared_policy_replace(sp, pgoff, pgoff_end, new);
+	err = shared_policy_replace(sp, start, end, new);
 	if (err && new)
 		sp_free(new);
 	return err;
 }
+EXPORT_SYMBOL_FOR_MODULES(mpol_set_shared_policy_range, "kvm");
+
+int mpol_set_shared_policy(struct shared_policy *sp,
+			struct vm_area_struct *vma, struct mempolicy *pol)
+{
+	return mpol_set_shared_policy_range(sp, vma->vm_pgoff,
+					   vma->vm_pgoff + vma_pages(vma), pol);
+}
 EXPORT_SYMBOL_FOR_MODULES(mpol_set_shared_policy, "kvm");
 
 /* Free a backing policy store on inode delete. */
-- 
2.53.0-Meta


