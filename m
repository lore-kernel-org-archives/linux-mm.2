Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A1F3CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501DE6B0098; Mon, 18 May 2026 05:50:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D986B009D; Mon, 18 May 2026 05:50:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4B76B0098; Mon, 18 May 2026 05:50:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BB416B0098
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:50:54 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3D8D92000
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:53 +0000 (UTC)
X-FDA: 84780071586.19.74099B3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf09.hostedemail.com (Postfix) with ESMTP id D8EED14000F
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:50:51 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Rbh0C5wX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=o5rEHMOA;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779097852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eoryIgzXF/oIa33zui9MlTduEZDwQ60Yge75gzlAI50=;
	b=j72NtP2lMN7aBsy2dSirRsQsRZrUWyuLRj5IokXaGip9mbzWatMLU1DOkY9rIBluD/SVlk
	bXcL93JlAxTUZHiGuogr36Js8BxffZMyxEd//d2Fz2x08Q5hUd1YMrDmNATHBmZl3J0GqX
	lUmzGUt6QkfllqtWiYmV+FV2qiJJX1c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Rbh0C5wX;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=o5rEHMOA;
	spf=pass (imf09.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779097852; a=rsa-sha256;
	cv=none;
	b=jsjDOVFxv+SWGDbt+zIFisfEEyvssqzNgqIaOGo/ol0S2SdNRVDoaZy5ZM+X3TDcVYiAJ4
	d3Z4q/rIc9XIyGKuTgA1viid7OoKKT+9VhY8EesVvAhI1L8Sg6AxXS4l7z+91neF2x/sVd
	OwTi76rHyVhQulQehfrThGyplUcCrEg=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1779097850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eoryIgzXF/oIa33zui9MlTduEZDwQ60Yge75gzlAI50=;
	b=Rbh0C5wXKorBFppJBF1BYLRhWQkZwOQEMIVdFCWM2Kn2Dwrrp41Zkqcl992JI4UK67ryLn
	fACK+stDxFS2SU2WxAU5EG1E8Fb/1EFQS7DalLfbGaGDFXi7cfa88KByGN0hGNe7v8cCbI
	7QG94wVvIRMs/IQLOW7TlM54S+vJSWFMotOP3YpKv8m9REAeO7yT8TWv0sWb+gY3BWDdf7
	sMpKtUa4t/YA9jyhHtIqsVs8lkwEScXj76SV+WA6ErBMwcMGTYt90qHaJdW42BHKJUXBi1
	/Qu2v5ecWBTDC64Jg0elTTMifp+tCexQulStkjIPTQtIMB2sxWplaawuu/g7gw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1779097850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eoryIgzXF/oIa33zui9MlTduEZDwQ60Yge75gzlAI50=;
	b=o5rEHMOAoSaZSnblbe7t66JQZ78Sna7tcTnG/RLzSjyNF+gFFT3fYLDOp4elRXN8kCqhgk
	/MROBOf8F8i5xOAg==
Date: Mon, 18 May 2026 11:49:42 +0200
Subject: [PATCH v3 4/6] vdso/datastore: Explicitly prevent remote access to
 timens vvar page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260518-vdso-mlockall-v3-4-bf4f2af2b41f@linutronix.de>
References: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
In-Reply-To: <20260518-vdso-mlockall-v3-0-bf4f2af2b41f@linutronix.de>
To: Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Andy Lutomirski <luto@kernel.org>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Thomas Gleixner <tglx@kernel.org>
Cc: Nam Cao <namcao@linutronix.de>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779097846; l=1920;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=IV1AOHFxFtPMDWIuw8YM0qfvmYEK6TUnKOoH3bZ1kc8=;
 b=mwlMV5qGf3DE/o8vp+sBUofrQvPITNJqFDZVoJnzPQTMcKlAFbYvOBGJQCmc6tMj4QnN26AlC
 u26yl4VQgCzAWxB8PzMusFV3pN/RDkiGzXa7F7qJ7wmkjmw9xBU1Z9A
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D8EED14000F
X-Rspam-User: 
X-Stat-Signature: yebjrw74cgmfsoor615iy3qjoekweyi7
X-HE-Tag: 1779097851-51032
X-HE-Meta: U2FsdGVkX19uZf7YsTHzT8tlhrMh2L9xCVlmAZE8VPVmWtn8pGLZ3wiKvolN9IYi1h9gicA51IWU0ZBaK1aQHMd3WXhxKb3RTfqpuvDpYnT7BVRmCc6PSGoj/zGVf7iwriz5WL5n1I4P50iW8tvjoVDSPP1rh8L3fxmmCErnCADBK+5GSwCYO+kRw1INOOMQCRDifhPYx0W1wCSfs+Q/Ly44PsHVSDxIfOGGPFYBPR/DK7hircq6NhTrp8ihby61xUT7k3cOoABPmRGpB+IE/IuK3qgAwzL+n5Cf5RH9U6FHava0Zj6txBmkeGWW5aIhIEFCORO6L0Y2i5CHWMVltNDTlCZO9IEifK99hIFRgI1q5RrrJxlLW3sY7ueb7/8DfX5ZxQE6OGMBUdFX5qZQjVZh0xr/Pkyu63Z0uaIAzlvOMYGMX72/doOV2Far8bov36fpmwaPD4AEQ712HVqkOsTwvatqVizlvTLloGDQ4XBKEkQMpy7foGM1Mgs+bB2j7hkczZ0ByS0L/WCxDoOPBVR7IjLBVFDZqbSrdeM//sM5yhzBjm82JWSlP2OKkbfnzU+ENNx3UbIJ5PCcenH2QBqLeRprxbLNUTGthnfWyJrMl89BvvSURa6L8i7aqXJ6m9M09Sj5NIFU7W9XmrBqpmbe3cg2VgP+mWnO6zuSX/cPnkkm9uoAdlKg0CXxzsUt9eiIMOywWSWHE7dYC6JjDk1FBEZ6ww+OnUdvwdWKddEUg7NLsa8nvx8JmJN8z8ubF3+uZGyNfkkNYkypacVl9ciyjle35YLVqCIQBluc4j2BpmQHK/4VtA4C1nHcD0Z6ksd+2bALFmH6NLFZxPI87y++SJAiIUvm7FtxNqd3Sc9nNdvfYtHEY3bAZP55YaYYKfOJaGdbiWO0st6/mFWI2tU92ZZd1SIA1Q/YgeOjlFZhpm1NsF6qzEJS3L520O6s5m3KO8QSaon6DP11ZTe
 LNaP+WuF
 /1htgPhfkGw5vKydM3hAp8fp2VkWIJIuwp7ZAi5/90LIs4lG5GTqtuu5MGBg7O7fgAU2DdGMQWwpvBkBYYCDaMD6rJRfZvbsRwZB0+QASFm6sU2cqDVKfE9Gx/lTUGVYfAyWPjCwRNR4Q0aix2BqDFRDz59n899JwPf8XPn2RO8Bgq/PREhfZeCyZlczXg9PD4DefM/l9f6sGXFL1u1ZOaT7lnzEhQCq+P0+NRMh6IGUOYVWIm1gnrVX960mzJs5SL1CY7bPX0OKZ3evPxOoLG/ghIaoLMkVDuDCEcrN03KK3XAo8qJ0C49AgDvZ4kIqIVCh/BmJ4Rk2YpF6rx2dtEdRJj2wFxIemtGJ7TP3F2a+Q1M3yxOxgoZB19GqZGKFh7XC65DOx2UD76ExIlxF+8rThw3UekJiTZ2glhd6jeAMuJ0+2xPAOxKLAhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The fault handler for the timens page does not have access to the target
task and therefore can not be invoked remotely.
Currently the handler relies on the fact that the vvar mapping is marked as
VM_IO and VM_PFNMAP for which the mm core always prevents remote access.
However the VM_IO and VM_PFNMAP flags are going to be removed.

Add an explicit check to prevent remote access to the mapping.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Tested-by: Nam Cao <namcao@linutronix.de>
---
 kernel/time/namespace_vdso.c | 7 ++-----
 lib/vdso/datastore.c         | 3 +++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/time/namespace_vdso.c b/kernel/time/namespace_vdso.c
index 0d74d160eec9..5ac7b6a6d3a8 100644
--- a/kernel/time/namespace_vdso.c
+++ b/kernel/time/namespace_vdso.c
@@ -74,11 +74,8 @@ struct page *find_timens_vvar_page(struct vm_area_struct *vma)
 		return current->nsproxy->time_ns->vvar_page;
 
 	/*
-	 * VM_PFNMAP | VM_IO protect .fault() handler from being called
-	 * through interfaces like /proc/$pid/mem or
-	 * process_vm_{readv,writev}() as long as there's no .access()
-	 * in special_mapping_vmops().
-	 * For more details check_vma_flags() and __access_remote_vm()
+	 * vvar_fault() protects this from being called through remote interfaces like
+	 * /proc/$pid/mem or process_vm_{readv,writev}().
 	 */
 
 	WARN(1, "vvar_page accessed remotely");
diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index f9a1f0fb7ccd..3381ccf9edb1 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -68,6 +68,9 @@ static vm_fault_t vvar_fault(const struct vm_special_mapping *sm,
 {
 	struct page *page, *timens_page;
 
+	if (unlikely(vmf->flags & FAULT_FLAG_REMOTE))
+		return VM_FAULT_SIGBUS;
+
 	page = vdso_data_pages + vmf->pgoff;
 	timens_page = find_timens_vvar_page(vma);
 

-- 
2.53.0


