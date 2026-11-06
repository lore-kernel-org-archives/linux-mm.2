Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789D5606A33C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 06:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=svxIw6BS
Received: by kanga.kvack.org (Postfix)
	id 6AC636B05B0; Fri,  6 Nov 2026 01:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C536B05B1; Fri,  6 Nov 2026 01:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 524846B05B2; Fri,  6 Nov 2026 01:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3250F6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 01:59:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A9E0B1409A6
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:59:40 +0000 (UTC)
X-FDA: 85403793720.28.79A0B43
Received: from mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 674B6160003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 06:59:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svxIw6BS;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793948379;
	b=4bb4VaIif7uWyHO5YikjXVI83dUNomHkkSjBhQh8PTXrFPR+PP/YG9rbsNZfqyu+maYZIE
	9eCx9A+dhgs4IYEDwD4ArHMUp4CcioObDvX3iEupfiWCQhgzwQSVS5GimU+Fz1gPACm70P
	0Afaa8X6PkTpKSeoV0M2tmNi6OErBd8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=svxIw6BS;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793948379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcOt4PX0tQHzNhn0VTU6sv5KTaqGga1IVFO+qQedORk=;
	b=F9yqYQXGSPvR4KGZUm1DFkqW0HBtmZvJo/EFAEt36mJzOD7x97wvhL+A+hYGg+8iBs6HCT
	y3qRCdXSNCN/lRMNZGj3VjiqFydAToo/MupySQXX+FsBUbETZ1huAgterZ+rmwuEelAWhi
	UXDYIxcYwdT+YVp8ipj7pyUfvvfM75k=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=3ZBSNl6NQMmaNPPXZuPSoh3zWTH6z/X2ys0Il7SoJQY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793948376; v=1; x=1794553176;
 b=svxIw6BSwB1b6IK2B8ZemZKLmd0tuuyhYum9YsLFqS8k3sdpspqgDaFtisTNyHh8Y0LP8lfu
 sIF527+CxuNAUFqYriH3YRTSyrMWgjIQB7bzvVdOaIWpgHeeVoRVWifwmixj7PtYI+gcHCiIZ5F
 DKsPB5a8WjPZBH67yl4f8sh4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fab8f084cc4903d4;
	Fri, 06 Nov 2026 06:59:35 +0000
X-Mizu-Trace-ID: fab8f084cc4903d4
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	willy@infradead.org,
	jack@suse.cz,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	maddy@linux.ibm.com,
	npiggin@gmail.com,
	mpe@ellerman.id.au,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	leon@kernel.org,
	sj@kernel.org,
	rakie.kim@sk.com,
	rientjes@google.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	peterz@infradead.org,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	mark.rutland@arm.com,
	alexander.shishkin@linux.intel.com,
	jolsa@kernel.org,
	irogers@google.com,
	adrian.hunter@intel.com,
	james.clark@linaro.org,
	mhiramat@kernel.org,
	oleg@redhat.com,
	john.johansen@canonical.com,
	georgia.garcia@canonical.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	zohar@linux.ibm.com,
	roberto.sassu@huawei.com,
	dmitry.kasatkin@gmail.com,
	eric.snowberg@oracle.com,
	wufan@kernel.org,
	stephen.smalley.work@gmail.com,
	omosnacek@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-security-module@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	selinux@vger.kernel.org
Subject: Re: [PATCH 09/13] fs/proc/task_mmu: convert VMA flag tests to use vma_flags_t
Date: Fri,  6 Nov 2026 14:59:25 +0800
Message-ID: <20261106065925.50906-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261105-late-2026-vma-flags-v1-9-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-9-0d3cd15ab75f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w16n9huo57jewawqrk73toqy4uupquos
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 674B6160003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793948378-29706
X-HE-Meta: U2FsdGVkX1/M5HVCL/oCzpqaLIy7CahXbRFL/s84OFQm5JrNI7DqUWC2xK6n58GDJ3BpCSuqA6OGFbSIw3omMdwLClpZJu7Ee9WRf/pZsnXruY3837BHlHUePi+AQCxBCafsX+VtvgU8gCG+3uJqRTMNaICW4IvxYSgGpN54Qo1ub/wKJhuKAWgm3zsPGNk+bv09fYasii0zYu0a/KwpzG16R0FYZ1rsM7po0/u5QARtknzCHhKJeFrzAfaODNjEeq9AJd+GScMiGKKJM9xbBd7UeKtJWhhBYJI98xsPR8w1BcRxWDhqvEr11D+F50EEyx0sFc9IQsd3nw0qTcSG4S8y+8+60/DTcZW/pS4c2hX2IGgvligFR0Aejqp6N8lgz/yhlA33SgZjrj/f4YcsxpKp/WsdRLIr4x9NvN1VNzh9vSUNJWqKyAoD3b7mOZbTQysKWwU4yoKUuOp0PXuWhZ9AMUd5kfhsUeoSkJvhKjij1H6Am8AslsaCRXAyd4c8g6Mz47m/qBkexIc21Swjk4PwxVTEtbJtrAX6MhQ32VMhj/2oKghiEw96UfYJfdkSTerhV6v5WPwt/gpVSAEx2JSCL2PUUXfMvGkDKbuhwExvuUO2C3zDOrHMdGVYSizvOtJ60uFYVoQ9V0iYt+PDrvk54GFkviM3ygrjBWvpBhyIV34EwBjydbaIbOAbowRFpPgaDT+bgmqmCTOe4ZCxGR4i/HrG4sESTnkmeGg+gx1qA79MNF4OMbXBjyQJwE8UEyci2Z7VVSIUK/fevqLNxCsgQ5mTgWWZ/oV8mLcnvovUUuQW1ipouy6rjrnWhmIBVe51Iy9NlAytQ5YwvRoWXkAWNLZ81Wr54Y9L2Ji4RnysDblGFglauviBY631WgaQi65LjA+ZKZmlimCAaFWCOFC4NnxqU0Kb6DIJj2zv7Ss1yYVFkNk7Cb08Ss+ds1oSrSBgYB+YeSCPaDMyykw
 fw94tU1d
 HR+ovpbisqaX+UZmfUtAPHcVyF4SrGflIOD4mA6+d3Ft8o/tjy73HyY1iZBkIjMxZ4G2FH1Ofqq/NCYMc6EcE6buPXDTdsx1E47ibMEMYnlDanZUc1zIPslcRX9hpBUXOVAfi0G+9KF7OC0smg0j3vApTyfAzKHzXb6nqveU5olXWz2fwDrjrt9i78dgofFa/s63OUH6p3GdtwJ64DvDRDSZuJ2fQo5Ztacb5u1HQmGxEOCAEcsPUh6Fv4Fxo+Wxmdp0MOBJdHdH/xZSd3PNsc3mG4NWL3mqeBWeV0+uKesrhlmFDd7YKj2S/nJk3vmsaPSftFyOHejT+4flPmwICWUQiNgd8oLQH0Z7WNGZ15t9PAkZVRDIIQmcOfsh4IKxxEy/Dm215YkC74832U9fvgCoel0TuePqKaxsuCtBaMDNbYDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Thu, Nov 05, 2026 at 09:31:00PM +0000, Lorenzo Stoakes (ARM) wrote:
>Replace use of the legacy vm_flags_t flags with vma_flags_t values where
>VMA flags are tested directly in /proc/$pid/[s]maps, pagemap, clear_refs
>and PROCMAP_QUERY.
>
>In replacing vm_flags_clear() (which takes the VMA write lock) with
>vma_clear_flags() (which does not) in clear_refs_write(), we explicitly
>write lock the VMA. The mmap write lock is already held at this point.
>
>The show_vma_header_prefix() and show_smap_vma_flags() output functions and
>the thp_vma_allowable_orders() call continue to use legacy flags for the
>time being.
>
>No functional change intended.
>
>Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>---
> fs/proc/task_mmu.c | 43 ++++++++++++++++++++++---------------------
> 1 file changed, 22 insertions(+), 21 deletions(-)
>
>diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
>index 22361607020d..b6e8ef15e40e 100644
>--- a/fs/proc/task_mmu.c
>+++ b/fs/proc/task_mmu.c
>@@ -569,18 +569,18 @@ static struct vm_area_struct *query_matching_vma(struct proc_maps_locking_ctx *l
> 
> 	/* VMA permissions should satisfy query flags */
> 	if (flags & PROCMAP_QUERY_VMA_FLAGS) {
>-		u32 perm = 0;
>+		vma_flags_t perm = EMPTY_VMA_FLAGS;
> 
> 		if (flags & PROCMAP_QUERY_VMA_READABLE)
>-			perm |= VM_READ;
>+			vma_flags_set(&perm, VMA_READ_BIT);
> 		if (flags & PROCMAP_QUERY_VMA_WRITABLE)
>-			perm |= VM_WRITE;
>+			vma_flags_set(&perm, VMA_WRITE_BIT);
> 		if (flags & PROCMAP_QUERY_VMA_EXECUTABLE)
>-			perm |= VM_EXEC;
>+			vma_flags_set(&perm, VMA_EXEC_BIT);
> 		if (flags & PROCMAP_QUERY_VMA_SHARED)
>-			perm |= VM_MAYSHARE;
>+			vma_flags_set(&perm, VMA_MAYSHARE_BIT);
> 
>-		if ((vma->vm_flags & perm) != perm)
>+		if (!vma_test_all_mask(vma, perm))
> 			goto skip_vma;
> 	}
> 
>@@ -647,13 +647,13 @@ static int do_procmap_query(struct mm_struct *mm, void __user *uarg)
> 	karg.vma_end = vma->vm_end;
> 
> 	karg.vma_flags = 0;
>-	if (vma->vm_flags & VM_READ)
>+	if (vma_test(vma, VMA_READ_BIT))
> 		karg.vma_flags |= PROCMAP_QUERY_VMA_READABLE;
>-	if (vma->vm_flags & VM_WRITE)
>+	if (vma_test(vma, VMA_WRITE_BIT))
> 		karg.vma_flags |= PROCMAP_QUERY_VMA_WRITABLE;
>-	if (vma->vm_flags & VM_EXEC)
>+	if (vma_test(vma, VMA_EXEC_BIT))
> 		karg.vma_flags |= PROCMAP_QUERY_VMA_EXECUTABLE;
>-	if (vma->vm_flags & VM_MAYSHARE)
>+	if (vma_test(vma, VMA_MAYSHARE_BIT))
> 		karg.vma_flags |= PROCMAP_QUERY_VMA_SHARED;
> 
> 	karg.vma_page_size = vma_kernel_pagesize(vma);
>@@ -970,7 +970,7 @@ static void smaps_pte_entry(pte_t *pte, unsigned long addr,
> {
> 	struct mem_size_stats *mss = walk->private;
> 	struct vm_area_struct *vma = walk->vma;
>-	bool locked = !!(vma->vm_flags & VM_LOCKED);
>+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
> 	struct page *page = NULL;
> 	bool present = false, young = false, dirty = false;
> 	pte_t ptent = ptep_get(pte);
>@@ -1017,7 +1017,7 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
> {
> 	struct mem_size_stats *mss = walk->private;
> 	struct vm_area_struct *vma = walk->vma;
>-	bool locked = !!(vma->vm_flags & VM_LOCKED);
>+	bool locked = vma_test(vma, VMA_LOCKED_BIT);
> 	struct page *page = NULL;
> 	bool present = false;
> 	struct folio *folio;
>@@ -1728,7 +1728,7 @@ static int clear_refs_test_walk(unsigned long start, unsigned long end,
> 	struct clear_refs_private *cp = walk->private;
> 	struct vm_area_struct *vma = walk->vma;
> 
>-	if (vma->vm_flags & VM_PFNMAP)
>+	if (vma_test(vma, VMA_PFNMAP_BIT))
> 		return 1;
> 
> 	/*
>@@ -1798,9 +1798,10 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
> 
> 		if (type == CLEAR_REFS_SOFT_DIRTY) {
> 			for_each_vma(vmi, vma) {
>-				if (!(vma->vm_flags & VM_SOFTDIRTY))
>+				if (!vma_test(vma, VMA_SOFTDIRTY_BIT))
> 					continue;
>-				vm_flags_clear(vma, VM_SOFTDIRTY);

vm_flags_clear() still warns on VM_SOFTDIRTY when pgtable_supports_soft_dirty()
is false. Did you mean to drop that?

(Vaguely recall you weren't too keen on that warn, though I could be wrong.)

Otherwise, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

