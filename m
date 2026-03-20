Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490921099B4C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACC176B011F; Fri, 20 Mar 2026 18:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3F46B0123; Fri, 20 Mar 2026 18:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0AE6B0124; Fri, 20 Mar 2026 18:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 912E06B011F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56514140408
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:20 +0000 (UTC)
X-FDA: 84567911400.07.C9F21E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C2197180003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFVvmSaq;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vjmAJmRriGIkjTJEXlps/glrnONwGx7qrrGBi55DrfU=;
	b=A/oeYvZTp05bUxsgSoOR0ZOgyeGETo5l62xzHJ/f6zwRvoMWrj7dU9F36x46daxItSNsOG
	DkItHsNRMlJ1RjGNjV5rDOGfilQG44h+i4UWHlB6nStq1huv78w5sUooacOLz2vVP8qXie
	JORu2elpLES7ARsFk9XZdKNMYs1C3Hk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bFVvmSaq;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046418; a=rsa-sha256;
	cv=none;
	b=gSKqj61GpHCQgFDBfjZ/+mcYm7kxUCUWzY7qRmzyHZLbkMxpUlO9qwjq8GsDcM5r9oiOCC
	WqvnlyICuqsrrO9uKFEHv05W9rBobyJBmYtikuhc4BwM5KJtP7DdFGF6VgpXTomaZwt11V
	33N4WghTaIzdmmTFlyzFrneYHy7hypo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2B97F60154;
	Fri, 20 Mar 2026 22:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A85C2BC9E;
	Fri, 20 Mar 2026 22:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046417;
	bh=L0GQ2G+rRvGPAFrt5sDMa8oj/FKKHLhal+DfkgK7NEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFVvmSaqDqJLoDlg+6noI1Wxcf1pqHJkBZjp3o48gNpg4DH44rSaBGPbLYz/qYZkM
	 Nd8QwUFV1MaXSsj8jMMIjACmWtdO9Y/w9/2x+JJoanOvv9XyP9qFBdKZZkxb1A4iHC
	 tkLQhKpN3alMVayVyEb9I/udX19c+sGN7XDtcaIOMLn6nekaglVJYw11nFmLwGrBc4
	 hsCpEv1VvOJUhXrUrciA2il+pJ/sMHTGafOaYgDrjovh6SCT8n/MXsfdX3tgBGQOS2
	 ldB6CM957Gunm1xRN2e3elhZJR5PM4eGqJVCx4WeRxsCBdQ44ZurTnPnt2jh0taBlN
	 sszGTQBOqqiOA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 04/21] mm: avoid deadlock when holding rmap on mmap_prepare error
Date: Fri, 20 Mar 2026 22:39:30 +0000
Message-ID: <d44248be9da68258b07c2c59d4e73485ee0ca943.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t8tmiznhiwnj4ufj3e71pkjnk1dgkc1x
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C2197180003
X-HE-Tag: 1774046418-932671
X-HE-Meta: U2FsdGVkX18oHXGhS3fKoUhjbmYfL8fC7t5vO8J8V4AE/ZZAzJWliU3WdDLapVr5UjHwoUMulh/nNOj2Slg+2gbFSt6pp8QiHssDr/a0a+dGTJnXDq/OZvPbg2M3ihZKYOlnSuRbst+viqeNwIBnknOXKeAOJjhtIVrCCO/c+UuGNxgRx0K6ACdyOW+Br+UZAHP+lMdDJd42Uf+1TkW95Vs9F6Q6JaFAOtmlcYEXZIHZQqzS0oJ5fLjuKsiyff3ti5M/ihsXaMt3O7r1Ux2BnlSytOvyGyPMunI+7+N3lARNhBxerjHAHli/u9g/6aLOn2NYtL2xAfgvoELjO2HwdyPAzM5vcyU3WZI81KwHxvb7EFQv9/sIe9WnUaH1wP8EmG1WqgsfG7sHHPgH0xlLBlWyPqSyUHntxfac44wzrmoF8D5nr9LQvOrztgfAzFyLDFBkE7EJ8W2ftEKx1y5ykcTlD4wK4Uvjn4Jmpse43+mqs3mTv0utGqSWdRJDrJvypA0tONoycEOPSSM7+u7+Kc7KVF7odLq1szVsibUQftZL4nCaUnatXUO6Gtf3BzUZfTJQuV//VSpyWnh6bfCNfFJOpJPQibgKdz5L2pK+DsxeLwlLj6EHxbNwrFnBt1/WMF3+HmM6CoNYPoroq6O9tDwuH6BWEg56/QEnPCMIdeHc9Pbv38/xjN6OwrcK12ZD4PeJ3XV9T39sZbrrdNUyRDJF3EranHEUQ8xdOkVExtY+yMfw1Zar7b5BPM/YzcjbOzjpmJoj92lGUgs0QK1HQo+iVvS93TXMS5HFZImfb323TlrkkCG4c2FcxDAjn+LcyPeRVs3A7zhK0ojz1ePG27yUKrwrjzWbaQ5Hz4azNJBrzB8Qa3Uy7Pk1tHBGQ6Dlge8CVNIilImvY6KdcVaI3rYXDYX/LLAH1AM9xCR2rgjwsRepmF/uW898CnIk4xWk5JpojU3JzyTAo+wNaD6
 EavgOUnn
 HLGl2CMRSqQComeLuvFH1ztFAEEOZt+jrKVmKXup23WPuZKHJoJZ0e7fj5oQ/+fet9PERR1arSZvBUrmEC+8rObGqMM90o9szTB2YeGRdsUbpt52YyZim5DFb/KbsmAbMLCuYoQF8hjEg+0tlXTcwDwsMxfL7vtio9oRwU7PCfT8nGKNoM+gJ6w5i5m1SQWXjK/+0nc1p6bs8g3naOUon3TPwwyFXqlddQE1gbvfx2wtfKI858xfaXoJzfMJfcI2jXufhIuHPA4M2d3yGYZksbjlX0fjxbzoXWUL2aDVHY1xWFfsFUrmQneWSXsA5dYK14gFvtuTPBHRDjyfb7YXfVT+oWHYGT4G9v8SU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ac0a3fc9c07d ("mm: add ability to take further action in
vm_area_desc") added the ability for drivers to instruct mm to take actions
after the .mmap_prepare callback is complete.

To make life simpler and safer, this is done before the VMA/mmap write lock
is dropped but when the VMA is completely established.

So on error, we simply munmap() the VMA.

As part of this implementation, unfortunately a horrible hack had to be
implemented to support some questionable behaviour hugetlb relies upon -
that is that the file rmap lock is held until the operation is complete.

The implementation, for convenience, did this in mmap_action_finish() so
both the VMA and mmap_prepare compatibility layer paths would have this
correctly handled.

However, it turns out there is a mistake here - the rmap lock cannot be
held on munmap, as free_pgtables() -> unlink_file_vma_batch_add() ->
unlink_file_vma_batch_process() takes the file rmap lock.

We therefore currently have a deadlock issue that might arise.

Resolve this by leaving it to callers to handle the unmap.

The compatibility layer does not support this rmap behaviour, so we simply
have it unmap on error after calling mmap_action_complete().

In the VMA implementation, we only perform the unmap after the rmap lock is
dropped.

This resolves the issue by ensuring the rmap lock is always dropped when
the unmap occurs.

Fixes: ac0a3fc9c07d ("mm: add ability to take further action in vm_area_desc")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/util.c | 12 +++++++-----
 mm/vma.c  | 13 ++++++++++---
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 73c97a748d8e..a2cfa0d77c35 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1215,7 +1215,13 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 		return err;
 
 	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action);
+	err = mmap_action_complete(vma, &desc.action);
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+	}
+	return err;
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
@@ -1316,10 +1322,6 @@ static int mmap_action_finish(struct vm_area_struct *vma,
 	 * invoked if we do NOT merge, so we only clean up the VMA we created.
 	 */
 	if (err) {
-		const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-		do_munmap(current->mm, vma->vm_start, len, NULL);
-
 		if (action->error_hook) {
 			/* We may want to filter the error. */
 			err = action->error_hook(err);
diff --git a/mm/vma.c b/mm/vma.c
index ee91f2b76acf..3fc5fe4f1a7c 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2736,9 +2736,9 @@ static int call_action_complete(struct mmap_state *map,
 				struct mmap_action *action,
 				struct vm_area_struct *vma)
 {
-	int ret;
+	int err;
 
-	ret = mmap_action_complete(vma, action);
+	err = mmap_action_complete(vma, action);
 
 	/* If we held the file rmap we need to release it. */
 	if (map->hold_file_rmap_lock) {
@@ -2746,7 +2746,14 @@ static int call_action_complete(struct mmap_state *map,
 
 		i_mmap_unlock_write(file->f_mapping);
 	}
-	return ret;
+
+	if (err) {
+		const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+		do_munmap(current->mm, vma->vm_start, len, NULL);
+	}
+
+	return err;
 }
 
 static unsigned long __mmap_region(struct file *file, unsigned long addr,
-- 
2.53.0


