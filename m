Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B89B0606E17F
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mQ7IdyS4
Received: by kanga.kvack.org (Postfix)
	id B62926B07E3; Tue, 24 Nov 2026 12:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3A2A6B07E5; Tue, 24 Nov 2026 12:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A501F6B07E6; Tue, 24 Nov 2026 12:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71A936B07E3
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:10:54 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD8C61A0C44
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:53 +0000 (UTC)
X-FDA: 85470652386.27.9037E79
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6779C180019
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:10:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQ7IdyS4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540250;
	b=uOI4MtGBx9ie2wZCYvBNOhYFRqv4ej0jV+DsBmKA+QaLdXSAkNYlormXIgFxMRnHP36YND
	S55BHX0lCvNh9AnS8xsVaks9UppM4vKikGRbXcjzcqpdzHhKJ6fDsAXuUmOjIjjPqIQdHs
	QZXErE/m3i4+3ItVcFCgySF9VDjJXHg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hoi6ZKqF0rWP2dY8L9fi70WXIdQ16OJirLzXOK8DLeI=;
	b=4DVhOAargQ4kLIg+FJdcj/Ze9r1Tfng6bXY9vCkzUL4r0coQYTkbsdwrhaFvYJwoGzhRfc
	yHLrJAQQKhKNE5aGOPvMbRo7A542nnvmEaKvzqGg+MJiQxzGgucy4jqO8Iz1hG6ZigRSPW
	6oaoIqJbshYS4S1zfdIn06KFPWmip6g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mQ7IdyS4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE9016280F;
	Tue, 24 Nov 2026 17:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBC21F000EC;
	Tue, 24 Nov 2026 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540248;
	bh=Hoi6ZKqF0rWP2dY8L9fi70WXIdQ16OJirLzXOK8DLeI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mQ7IdyS49AENVW+aKfDJc1YLjA04/p8tIxN7YRDMM8ueVAsZNqc2KIWGDZ3TZPGty
	 gXMLycS92SL17oxb9pNQUQLbr9BYnh+cML/2JQxhWGRdxcCNG34TvnqPHj++AvZRcI
	 o33kofJHgb0IFg9vyzDiBYV4hAn0XY/Sk18425ehbjJVVj28odQrfwj5Z8yO+gQjhE
	 KLpLeuZ3Il5hlLlMZ1Kg/+btvjNwhLcNVBzd1kF8lsjFQZ2wOGGFFNyNoK+HoQrcGj
	 deyGUfLK3i0oz1rS4zwVcXps7U2kHgDwdvxcey8H2XvzU/DYFD7/9y1q9N/5mNwN4R
	 BsRMnajdG7pUQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:07:59 +0000
Subject: [PATCH v2 07/11] perf: convert VMA flag tests to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-7-bf3fade93064@kernel.org>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
In-Reply-To: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4026; i=ljs@kernel.org;
 h=from:subject:message-id; bh=q20FVgbTncUenAoabJhU/UxTd+TaqPmkjn0LMdXaCOg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+RF2V0qzp2xM3oL74zmDK+Z+RnTxFOPPFVP9luzJ
 jDCKeRXRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbiq8zwT+vOYc6+XYVPrHo8
 OWZ+OPZ28utjqd2p/7Z4WG7T+u1SE8jIcKHchD2gyiI/9KzN/XOBF34rtFxkrHpYcjxYlL2Z392
 AFQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6779C180019
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: itpxyzfuba4taeraw6cwghjg41g1xizw
X-HE-Tag: 1795540250-482534
X-HE-Meta: U2FsdGVkX1/GxY/JFS3zhpcOn3b5dB72RWDZEd/Lt/IcpIKk0htHMcSdZ9LO5WrBha2/OHd5HwrIkpiUbcaju9NNg+PQUOPqCvhYnH++vWm2TCpqorUzXqdPpxSskEakItGEtsONo50b205Gv6pmAgz395+8nhpxhhXExjblY68jGOnWfLXPmhAMkThrWcujXN5gI0GlvZPZKxUYu3wAlcBGRN5W5I4imzDLeQeOxC30o6z0IdSBQo70YehnBsx1knQ/EBuw41v+R57aOX9lwfD19C2Mlm2gWfLWFJ5fzus63FihTbBonBMfelp9vkk4iAsnABdUbW9s+Yumb7kQIJAJgnxDxmvy5Q3E81jIwdXM02cmnFOtEn6Ny/T2CTRaxLevzTYnLLhPL49sCCCaeU524wFTqPhx7eDlUyiEKmRX4f48pJR1rVJl8bqbpTVRbvPyfpomhN8agDXtKDbRWqmfAKQ8lGHxa1RkHtwaV0NdWFXMGy3c3ZyHrjrCWL0X01WlvFZ8M+o/t3BIqU0WoNyDw0ETXBICDtKUxk3vgdjZoo0GJGUFDIkC6qAci5m0MSiqUZvhPvkruVLbJrTtsnUrACMYxalhB1EKXhWEZJCgG+gJrr3la06ThaBVInzJ4tAsd2paKXbpVNFiV4YO8gW8udEbt2XTGhgsMASglRwUDRJoGBIbpAlzAAH7dzQq7fpMWt3a+C+fK6CX9+29WfrvNHJ9sOJ+62wclGUsObrj63LiimjhSoSD+1IlKKm0tyrsBOwPRiZ5OCjFO10OxQ4YlcwuXQMeAC6jwvaEgBCyldCZS6CAGXkfSIRI5PP7fTTUV7sntIx9VDDtnt1pAyUB/is7LiwdKfoDvvfhcOpL8a7206IDk0S38ZSDjTxl0fKte/Veyu9FSJeurTVRqF5XXjZIgpgfCuVnZDZPCnFneF2uvz49gWMm3/+TENw/1eGCCafK9LdZ36vTWt9
 Ayz27rNz
 Wp0un2zDzosLViN3jIscI9fIq3KMxzToFEs8MDqDPBUlmbzZqSjRHFD7LsLBq6U7nooKyu9z35N9HFrfX/Rp2YLXcRoiJzItSOQpCZL5yQaiicdTbgPXaBtDmWoDItnjZfEKw9f+i3gQ/uCU9liATHw3X8Nd/XgqOPJLDNCBxIQmHzC0aMLykze6dvy8XN0hg+QxcEOmfWA+EtKuxQYmINisBXttPIKS46USuRoqELIWcOAXVOWVq3fLQ6wfqMEdzsjiyMbMwVNirV/AnNOSkMg2JLwmS8CusJAgT9TS3TYeGX1KJXg7M6w3WQm5NzPsJ6adb7nc2c+ARPK49JGy3bYYBLPcR6kpHsBu7PfkrUUNBWtytt0NhCdz6Qfa849KBHP1aDSHy5oSDOW75HRNk3xLntm9X4NouoYF3RFQz77qkynJoEN+qjqWp3YDSOz7LrWnsVMqYOlE3pggAmVIQb7bUXjm4MJuaAUYcwZ9O6iWcgxViwZN54AUP9fLh0VEd4YmrXnnmup3JdzcEfZdRpISS0l5hwy5DL0YhYOIBcNhiSEvHRFVoxYkp/rSsXk3J8e39oON4pTdHNRVkazb0hPqo3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
perf mmap and mmap event logic.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 kernel/events/core.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e870f12c3ad8..219b7af9a632 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7234,6 +7234,7 @@ static int map_range(struct perf_buffer *rb, struct vm_area_struct *vma)
 		unsigned long va = vma->vm_start + PAGE_SIZE * pagenum;
 		struct page *page = perf_mmap_to_page(rb,
 				vma_start_pgoff(vma) + pagenum);
+		vma_flags_t vma_flags = vma->flags;
 
 		if (page == NULL) {
 			err = -EINVAL;
@@ -7241,8 +7242,9 @@ static int map_range(struct perf_buffer *rb, struct vm_area_struct *vma)
 		}
 
 		/* Map readonly, perf_mmap_pfn_mkwrite() called on write fault. */
+		vma_flags_clear(&vma_flags, VMA_SHARED_BIT);
 		err = remap_pfn_range(vma, va, page_to_pfn(page), PAGE_SIZE,
-				      vm_get_page_prot(vma->vm_flags & ~VM_SHARED));
+				      vma_flags_to_page_prot(vma_flags));
 		if (err)
 			break;
 	}
@@ -7360,7 +7362,7 @@ static int perf_mmap_rb(struct vm_area_struct *vma, struct perf_event *event,
 	if (!perf_mmap_calc_limits(vma, &user_extra, &extra))
 		return -EPERM;
 
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		rb_flags |= RING_BUFFER_WRITABLE;
 
 	rb = rb_alloc(nr_pages,
@@ -7441,7 +7443,7 @@ static int perf_mmap_aux(struct vm_area_struct *vma, struct perf_event *event,
 
 		WARN_ON(!rb && event->rb);
 
-		if (vma->vm_flags & VM_WRITE)
+		if (vma_test(vma, VMA_WRITE_BIT))
 			rb_flags |= RING_BUFFER_WRITABLE;
 
 		ret = rb_alloc_aux(rb, event, pgoff_start, nr_pages,
@@ -7476,7 +7478,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (event->cpu == -1 && event->attr.inherit)
 		return -EINVAL;
 
-	if (!(vma->vm_flags & VM_SHARED))
+	if (!vma_test(vma, VMA_SHARED_BIT))
 		return -EINVAL;
 
 	ret = security_perf_event_read(event);
@@ -9848,7 +9850,7 @@ static int perf_event_mmap_match(struct perf_event *event,
 {
 	struct perf_mmap_event *mmap_event = data;
 	struct vm_area_struct *vma = mmap_event->vma;
-	int executable = vma->vm_flags & VM_EXEC;
+	bool executable = vma_test(vma, VMA_EXEC_BIT);
 
 	return (!executable && event->attr.mmap_data) ||
 	       (executable && (event->attr.mmap || event->attr.mmap2));
@@ -9881,7 +9883,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 		if (use_build_id)
 			misc |= PERF_RECORD_MISC_MMAP_BUILD_ID;
 	}
-	if (!(mmap_event->vma->vm_flags & VM_EXEC))
+	if (!vma_test(mmap_event->vma, VMA_EXEC_BIT))
 		misc |= PERF_RECORD_MISC_MMAP_DATA;
 
 	perf_event_header__init(&mmap_event->event_id.header, &sample,
@@ -9932,19 +9934,19 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 	char *buf = NULL;
 	char *name = NULL;
 
-	if (vma->vm_flags & VM_READ)
+	if (vma_test(vma, VMA_READ_BIT))
 		prot |= PROT_READ;
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		prot |= PROT_WRITE;
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		prot |= PROT_EXEC;
 
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (vma_test(vma, VMA_MAYSHARE_BIT))
 		flags = MAP_SHARED;
 	else
 		flags = MAP_PRIVATE;
 
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		flags |= MAP_LOCKED;
 	if (vma_is_hugetlb(vma))
 		flags |= MAP_HUGETLB;
@@ -10110,7 +10112,7 @@ static void perf_addr_filters_adjust(struct vm_area_struct *vma)
 	 * Data tracing isn't supported yet and as such there is no need
 	 * to keep track of anything that isn't related to executable code:
 	 */
-	if (!(vma->vm_flags & VM_EXEC))
+	if (!vma_test(vma, VMA_EXEC_BIT))
 		return;
 
 	rcu_read_lock();

-- 
2.56.1


