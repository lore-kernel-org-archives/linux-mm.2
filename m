Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AC8EC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529A56B00DF; Wed,  2 Sep 2026 15:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DA646B00E0; Wed,  2 Sep 2026 15:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EFCE6B00E1; Wed,  2 Sep 2026 15:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A19F76B00DF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:47:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23523A0384
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:06 +0000 (UTC)
X-FDA: 85169855652.28.65B4F45
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 578A120002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="BAkRO/FO";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VW5hThLcNiS9B9Y8k40LTfPGZJYf7iWoviGkGwyNijs=;
	b=XnK3VgBKyGR91wfQpI2GvS0aNBeICzU+wTqXHTuZSFJ9ZJkL2SRvAhTS+wuGVqpe2hzJLC
	9FyDo+n5uPW16SeM//3WSH9AQlv2OZkSsHrik9hjtoBN4My596nNqCBdUynX1N3ok0NHmG
	mdTwfBnDur2po8VXvgG4PK0g/ePt4d8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378424;
	b=q/OjjxrFydYKwgn5wMJcnWngQkMSDYHOq/goRrlAmjNEc3zFmdqJ4rsOxw+ti4oq0sTXAp
	Lm1GQTZZsPSTf4y3lVSYxFaDVI6N7z4IiiepSqXtl14XT5y5FaeHJHkiF5I6qDa76TjtbY
	xsGRiy4y4TeRyzzIZNJMbLs/iM/KZqA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="BAkRO/FO";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-93905b1dc65so133498585a.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788378423; x=1788983223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VW5hThLcNiS9B9Y8k40LTfPGZJYf7iWoviGkGwyNijs=;
        b=BAkRO/FOc+GrmpdP+PnTnIhUt9SQmhWiRhB+bXBLwECUWwA05E+XW9INVGZ+oegg0g
         uwbKqFqwiLAOmW6b3T+IEZTlFGLNBisxUwMOAcI15pMOR0x1gKig1OLG9E3HRX1KJOoS
         nw+qIpjTL47o7rJ2k7FSGKN1ivIvd83dhSYdOxxZ5G72jbDjBqMjrkzzedFlbR+jxaGF
         YLiU1Qjg6O9FucDbm2CgZld4ZwyLbg3TdtvcQHrrIGVOq4bdQTTMSMTzbv9oJ6d/eRGo
         jE4RySRc+TifUSfqZLYuaILBpzsiQqrASCVsdKROHx8SnX3DlXGo5PXlqgjRBsAB8eOw
         +EeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378423; x=1788983223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VW5hThLcNiS9B9Y8k40LTfPGZJYf7iWoviGkGwyNijs=;
        b=nQjmS/nOjFd9+zyHpZFuWYvsiYdSAOgRCNGkonhj9eFh+RrytkpLs08G3t4jR/Raw/
         EtvFZQcZZmrX7Ve5+KM6wrcAMuqTge73LweUswfHF6YSl29D7Pie+FLRYEzc3N/UjX/d
         sGZthYTWTROoC/bp1fcM8jndgSi9Qb1DE4g61GQ7W0kFBIARDbsMmucoxjPORAgGb3Dc
         RM3FHZRqAERY4ISgT8ZCKJ6KoLBsN+YHbFevoapSGD2o2Fwhoq6+N0+rf1AbG10WSpE+
         qM6CD8JFuSoB0mo//rquL+Lj1+IWKCQcBtaOzhVKWjHPJyNlfwvBszPYgU6nJ521HoVf
         HUFg==
X-Gm-Message-State: AFuF++mag6ZJ7jcVkCh7qSdoIYrCuRBcU6RhcpO50aZaPgbjcNFWTyFd
	VTlh268xZP4nxJbtwlSEueDIgBH90V9NjbfXZCGHNCjcKqSHoh3GYKSCiqwPCjyUd+ws6sBWMM8
	AhF5+XNo=
X-Gm-Gg: AYBFou0Dee+pdbFkLY4nnejnU+PgANRQXjXto/XWOyYYCDq8FaZUUBOK4uxViREYgOu
	5DJHronsHCddQ0H5mqoC3sa3YF5w0rdKuI7YyHeSgLublHufZ27VatHnDeY8O+ZWJm5prvKmLRv
	QCVy8Q6Rp08CIBu/odir7cR3gfa3S6iM/0nI/git8ONDofLBWRLRLgYiM43B5bKeeoboj/6M353
	Io7qz5NNnchona/eMhw94pmy/32881GnCdi/boynBv8YV7oZXsowguBh3vT1eHt3C6Qhs1RsGCc
	tFNi7S15Ey5ZKQDLJLCHlBGXbvbDrhzZjq/VAl7hh3X0YyRPbKpLS1K2ZancPDg13Ep9QsUQzV6
	VQV17KpwfW98n/GXHWN5WoyjMcvQV0xIj49Bl7f8Ys1l5NXigFuyIqTXotXeVaWu/xLjDaqd83e
	MjZf2sMEiE9lpGbWrU2cPl4JttRz902d9EGQwrSDY6D1byd9DsyY4qtTaBZxFUZBY4nujdhFSCv
	vyslKBdyp1IAXe0EfsJowxaHM/f+Ks+BF0q0QC3iIkgqOYEyQ==
X-Received: by 2002:a05:620a:a40f:20b0:939:191c:cac7 with SMTP id af79cd13be357-93960e19503mr738239685a.13.1788378423217;
        Wed, 02 Sep 2026 12:47:03 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f18801asm299300585a.16.2026.09.02.12.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:47:02 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	shuah@kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 2/5] mm/mempolicy: add mpol_set_shared_policy_range()
Date: Wed,  2 Sep 2026 15:46:54 -0400
Message-ID: <20260902194657.79075-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902194657.79075-1-gourry@gourry.net>
References: <20260902194657.79075-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t1hitn1n5c46zfmam1u8a43fdkxt43t8
X-Rspamd-Queue-Id: 578A120002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788378424-100282
X-HE-Meta: U2FsdGVkX18s/70OrR9iJdN07Og7qX5qnwvw/NlE5nrzg2VNKTZTZycM5fxekTZCZ/oJ4ZXgmCfnCj7DjomCGhH15337PwVP8bxIGVODa3iDez1g7kiR2683+XxL6LNMDOVU9bPTepO5VuP7NM19T1fDskSC6ZJFH1ZavvHQ7u26HLw1SxNvKqB2hJD21Zv4TaR5y/WqzHyoTMMJEH3sWpXkNXtLjdreWhHqB9xNvbo3JV+jI/HfY6UjIUHkxLPdpkfzz7C6WETuX7EQtVJqadf6MypyBm6pYCFTuCyXVQzxnFfQiZpiglqceuzCpYTh7Qt27wRP6r3duSqtlnbIgaETxfHxtiNPqj4JOoBESYIXoaJqAudUlzWacKdV/cZNTef4QDapd43Z9WnUcPUEKAWgNU/PJnXNXPRxu+nKMSegKXgAkgaenr4wT6yNtyQ3nhPZ9oKJ3aTrXZZy7ho4uJQ2+Dk6az32+0L3DXo7gwGuh9Vi4kg3Hzi1zDGhRR+TCmm3IPCZqJi18HLAl+LuXkn4f8ijVujqN8Wlaat/BRjXVhCfn+rzAXUft7MiG8QZCH84I87QkFf1dWrhTZL5vvzHzHwHQUbzZ78tc26XTDBFcQ/RwHhhj4/K0k/WvL1Ajr5jMxHvW1YlQ2QGhf8qaWZZGsarOdeFxH/X1EzoqKetkCyFkP4qKFSj8bgdkOMwmltkCp5HHO74W6epcA5obudNocPyukdxMFRtF24mBiPSGBS3uNO2sbD1ixVC+r3qNgENyKnhAti4SeZ9ZP3z7jaZgG+0a8YPyXefyOkTl1aEsFLYwFtwLD10+iTQ+koJ2BA7sgSrHuf0ImwoAdiwclWJQyF/hEMVXB61KH6ABeKPgPsbjYcL1Yhg+J+lDAo+fHozDPxsX6o732TDkNhbSnLDbHx5sFAsfBbRKkIOc7913tn0f0K/7Gd1RVvvuCHkbVKptiYCk+u6buv8KeU
 f14OY8xv
 X0UalOd9KzF4iyo1P2h0HsMf3ORpe89XztXsR9m6DrWjH0WuFIQuN8Lo0PCoqb0jdo7wiatmBFjSSM6Baw7eiFOTSRlNCio7p30lnsaViuNNeILz4ZRyzXmMfWrcjglyOTByg3UIwVCMi80C34avU1Pp008nclgEpiWdyeHrjiMHf3WlXffE796uAAgYKVb/QAF5Uz7oVAtgRT88PDBMfNe/ORSEed1jYzIEAfRfvrOdFnrT3vCdusGTrmOzJChDEi7nwY3n+ojznCG0VHAMVPZO1uXwLRMl9xU6g3ZGTBWxPz3x7c7dcsGu+m82/c4nousHA6ym7nzocwlygutBmx15ta339ySwTgKEF9HG8EcFPhZ6pDqTnjHQaFYmDc+b+JNGifY88lKemD8fKdS22FI2DjUnT86nInO1ojlsLqdqqWbfW1FuA7YX81LtNvnErmP4Z
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

  a policy built programmatically (e.g. by mempolicy_create()) leaves it
  empty and stores w.cpuset_mems_allowed instead and _init mangles it.

Both matter to a caller that wants a whole inode bound at creation.
guest_memfd is one: it has no VMA at that point and may never gain one
for a given offset, and it builds its policy in-kernel rather than from
a mount string, so neither existing installer can express it.

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
index aef018ad92317..398318175cec7 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -124,6 +124,8 @@ int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *dst);
 void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol);
 int mpol_set_shared_policy(struct shared_policy *sp,
 			   struct vm_area_struct *vma, struct mempolicy *mpol);
+int mpol_set_shared_policy_range(struct shared_policy *sp, pgoff_t start,
+				 pgoff_t end, struct mempolicy *mpol);
 void mpol_free_shared_policy(struct shared_policy *sp);
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    pgoff_t idx);
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index da133ffe0b1c8..ce10ce4374643 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -3312,24 +3312,47 @@ void mpol_shared_policy_init(struct shared_policy *sp, struct mempolicy *mpol)
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


