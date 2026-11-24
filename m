Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE79606A339
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j2oxXXw5
Received: by kanga.kvack.org (Postfix)
	id 856346B07E5; Tue, 24 Nov 2026 12:11:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82DBD6B07E7; Tue, 24 Nov 2026 12:11:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743FA6B07E8; Tue, 24 Nov 2026 12:11:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F01C6B07E5
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:11:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D9165A0C3F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:11:11 +0000 (UTC)
X-FDA: 85470653142.25.F45D9BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 11568C0009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:11:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2oxXXw5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540270;
	b=3L1lg1pJWwyxL5AL1GhdAelOVi6g62EjC+5AvKoIFgbz8yNmQbpN7vInlAYJF+MWjQOC/b
	t9JhPeHBSdtD/voqohGwjATlxYpw2WfDT2mLgFS3TNj9BBNVd1uIqzomW/WMnvVBjiTS8m
	Or1BSv+CYsj+4NecPICb1cP4r6r5KtI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZ3jLbZRJ/VHth5eaJGnJSAc1BSxLfXRApAmbg64kWY=;
	b=SmD0/dWizqHntX4W1tJ23Iigu8ReXac4cvapbNF9aDfFiRn+/wEoBvj0xyzfPC0PoA46va
	IrE5G3hNo7yswHuqrl7XUi9kigEoCM4pCULLiWqCQBc42lnszoDT/qIHIC+8DaUeyH4ItQ
	4ERCv8FYclBlqIigg7b6VnQ+Hl51LSU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j2oxXXw5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A9104429A;
	Tue, 24 Nov 2026 17:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB03A1F000D1;
	Tue, 24 Nov 2026 17:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795540269;
	bh=kZ3jLbZRJ/VHth5eaJGnJSAc1BSxLfXRApAmbg64kWY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=j2oxXXw5aycUKNOMG1/DLAxgqIp8Sjh0cy1uPDzj0VsLoLzP39KcAhPEhZa91ZbU0
	 H8EWAkRDjjvmeMoDjewdq6ZKK544u5JaiRV4qMMeZJmeHaFIEPNj1UH233/FuATQZm
	 Qdf1Uax5gYT0AAImCi7AZH6Q0Clf8dLZxDGQwMxBZAX/hKNmSBFqQKHZIoPnOSnDDQ
	 2GWVFQHmnLVbUFRtgsGjd/DH82/mDkeubJc+OBMpeUry1qEzZkDHUC8IUi2lj+GwtX
	 dSxYVPdtOe0VauPrsUWxIhV2mkMwY71xKEtg+G7v5M5SGq9FeEfJfWTcp474LhBtqb
	 b5DXkSHEmddVw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 24 Nov 2026 17:08:00 +0000
Subject: [PATCH v2 08/11] selinux: convert VMA flag tests to use
 vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-late-2026-vma-flags-v2-8-bf3fade93064@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1924; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Uj1h40qu7RJJAsenD1k9bntx12XC9vbZ3RhmualmjYU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJZj+SFmM5Y1Pzgkp2azP5dryY4Rs/LY1tiWxhjPEPJc
 SdLquGfjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAExk5VaGf5ZFPTIJ1j1MqvNL
 +sNOd9kt+LBAykL2/5nEi1OCDskHyTMybJnstzHxS/78s/cuWP3pjDfnLdNZL3TE4PfRJ3/ZN0S
 /ZAcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 11568C0009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: dpzo7i8yy99wkz88ccnu7h67tznahast
X-HE-Tag: 1795540269-322423
X-HE-Meta: U2FsdGVkX1+ETEtQSuvuUJa0t/2jt4PlkOERmq8h3wrMtA+dsdpwVMZqMghr9BWm3GM7M43Ua4fXI7u/gqHj8clrmGCaE2ZGB2qYuZ08ElneIdjQbuWdIcrJjul02yRbqZFpXBmMI0Oz/B+p653shahOHp3JTj1lw2Ct3G65xU7gh41hzje9PLm4aedor376wgHQcMB5Q09JvQBu3KAOPdpwEHWSTa8bJXJS14qIYwWhcCGmUAf9hDn4/3G+wrroo3QtTi0Qu0mN/aDDYHWROVHCLup9S823a6tT5f66ZkMh+/Vbd95zuCCvajpeCVrLiSyixTzwA0n11fHm90asV8l8VlYv1rfKKuZnccVODTf+OGkD4sn5Qid+3IVlYSfBgahlG1fQy8y87UztoMjxWDjk2YqqLMbS3iryQs1vaxzarbTBUBgLLPjThLy7p6DrYISfdeXUYwPAgbn/HEQWx1dnhN4tvhlke8BtFrFxWloqg5Qd6f6NWj1OpcgcqEhDWNbSb8GIWq4OCWD/P23dk7QQJbHyLZ6yJ8ERup+Dz8eLNnX9UKrr20rHzy2hjrlFRugEQkRm9NFoKDdmZ2cEenz/eAoYAwyO2I8jZ8nUrQr82xilNwPSYDtoklb0h2HUDVpIvrtHYF/rR/xiQdEgtFgcKNljxhEIdWl/wgtVXYHFr+2YjkWM8k9U7aVCug8v+Ce67E9VkGOfx6VkbMRTzpOsmD+bGt/YsI1AYOOaRiwRWmZJc03ZFMR9S6RDxKffmZDRqizHF3lt6YbeNb0XUrnQSBms8Ocv3LAU9gXHOmv9UJuVWwvBlRdVZQOELRgmlC1SE77REmlORWafeUwGRWIZu8HYfoDRO2GcZqMrxlrsDm2tqbZ1Gvf+FtS0ox82KMc6OGqWUj7YTX+P0bimBAScKAopi+OfW10d0PsZ5oOS2xFqnH8rqf1c8ycOp9jHoirbFjrWJrz2o3Q03Ih
 cKLhHGAJ
 QsoZlOusUeTWHlPVVyTv2NKb6ZMH2M5fcTgnY8NPEa2mxLr9mFM5LCUYwGpr7Ifm+NmR3hajLbBXw3wsIgbiVftVO+8Xt5EGi1XLeNjmDcKFNNIPP/K/fNnLYjdWsntl77cJRKtRuX45HLPwBjI+JT4GWWO2iZbSvkC2Rabwx720HmNK5WN3UBJkGx7j+O66v5Ev39FEa/ETptCFxDjljGBi7Fbwal2is7g1DyW67jzxsUqbMAEtdfb0/V+NnB7frWewdewOifylsSbTQP/8n6k8ochBYdtxBzjbmDFUAvrtoWItxP1f6TDCSYO7x1RlwZuQ+D3k4x0gPRS+JxqC/A1L/8rsR0ADCcTBusrHgVmvUlu3YLEQCkPlT6Pszup7Ctv1N62fR4DohSbbKR5v/QeYjQWQnw2Cv4S+1aAzE/86WAET27f1JwHXNpayUey51kCbjACKc7ChhYSIv7MHAxCBP1H9AKNG2BeyU2b4X7sPXHJsAb9nS9h8njCSKk9c5XsZwOa81x/Y7vWDsjjBiDVVGQ4hlXj1iRAViyRr3aCuO7AIWVyhh+C4Oj8faIpau1GER1pvT0zRx6H0W5piOBXgzAE5eeddngFT8ngF3HLQhI0s3+aNH+R3hBm2Pb/0t6jetrOBiXAs2yZI5/2UYkCjDkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
SELinux mmap backing file and mprotect LSM hooks.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Paul Moore <paul@paul-moore.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 security/selinux/hooks.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9950f89dfaa2..5198a66b624b 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4205,16 +4205,16 @@ static int selinux_mmap_backing_file(struct vm_area_struct *vma,
 {
 	unsigned long prot = 0;
 
-	/* translate vma->vm_flags perms into PROT perms */
-	if (vma->vm_flags & VM_READ)
+	/* translate VMA flag perms into PROT perms */
+	if (vma_test(vma, VMA_READ_BIT))
 		prot |= PROT_READ;
-	if (vma->vm_flags & VM_WRITE)
+	if (vma_test(vma, VMA_WRITE_BIT))
 		prot |= PROT_WRITE;
-	if (vma->vm_flags & VM_EXEC)
+	if (vma_test(vma, VMA_EXEC_BIT))
 		prot |= PROT_EXEC;
 
 	return selinux_mmap_file_common(backing_file, prot,
-					vma->vm_flags & VM_SHARED,
+					vma_test(vma, VMA_SHARED_BIT),
 					true);
 }
 
@@ -4228,13 +4228,13 @@ static int selinux_file_mprotect(struct vm_area_struct *vma,
 	u32 av;
 	const struct file *file = vma->vm_file;
 	bool backing_file;
-	bool shared = vma->vm_flags & VM_SHARED;
+	bool shared = vma_test(vma, VMA_SHARED_BIT);
 
 	/* check if we need to trigger the "backing files are awful" mode */
 	backing_file = file && (file->f_mode & FMODE_BACKING);
 
 	if (default_noexec &&
-	    (prot & PROT_EXEC) && !(vma->vm_flags & VM_EXEC)) {
+	    (prot & PROT_EXEC) && !vma_test(vma, VMA_EXEC_BIT)) {
 		/*
 		 * We don't use the vma_is_initial_heap() helper as it has
 		 * a history of problems and is currently broken on systems

-- 
2.56.1


