Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D564C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 22:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5EE6B008C; Wed, 22 Jul 2026 18:48:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43E6D6B0096; Wed, 22 Jul 2026 18:48:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 309266B0098; Wed, 22 Jul 2026 18:48:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E52816B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:48:22 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59FC01C05EC
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:48:22 +0000 (UTC)
X-FDA: 85017902844.28.6C00DE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1A9FF1C000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 22:48:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ey11rnFQ;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784760500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNgL8SYp9VI1NhjQT8Ovt6BfZV4gAJBoTR6QXW/SnYQ=;
	b=mdQRt2ib+GLe/AUe7Wc7pxtLp4XFBT6ii+kd3BEId0HA0T6cC/GbNGFVXbvR2AwBykGV++
	hmWV54nDGoPEEGQc3+t60V2MY6hBiCUlyy9/kEg6bMzhNzOZbRX66cbU6Z5XD0DIg0Kxt1
	9qXd3VJjax2QSWds1r+H7t95n+TnL68=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ey11rnFQ;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784760500;
	b=CJ4NHVnj6uA5lYajmtykhjfXpRdyRQ8vwdS7N6fJC1LjCkUPphbU6FSwUzQ+1EpVDtaLAz
	gG2kzdL/XiaVoQiLCpGiNFFkCDlDjvaeRUNoGUa2ropw6TOww5Ih5Xy3yLXqiegh+5ji2w
	X6T9Vs7uf0k3Sdees+Zp+2rCf9W+2qY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F298742DC4;
	Wed, 22 Jul 2026 22:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A931F000E9;
	Wed, 22 Jul 2026 22:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784760498;
	bh=PNgL8SYp9VI1NhjQT8Ovt6BfZV4gAJBoTR6QXW/SnYQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ey11rnFQSaKacaNArWVfr0eeKP+Coih9IwasoSNFGEWkgFxEAp6Gj30weTETOSTMu
	 Kb3glBybuhz+H4qunDZQxS9olJTmLRVgjyXlAi+i+JjF52ZA7V5vh6IJduz1xNJhqy
	 6T2KvTOpUyORKJL9JJtXt564uLU4rprlu8gbdCNE=
Date: Wed, 22 Jul 2026 15:48:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan
 <shuah@kernel.org>, "K. Y. Srinivasan" <kys@microsoft.com>, Haiyang Zhang
 <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui
 <decui@microsoft.com>, Long Li <longli@microsoft.com>, Lyude Paul
 <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Min Ma <mamin506@gmail.com>, Lizhi Hou
 <lizhi.hou@amd.com>, Oded Gabbay <ogabbay@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-hyperv@vger.kernel.org,
 dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH v10 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260722154817.8c036f2d007edccbd7ab84c7@linux-foundation.org>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A9FF1C000B
X-Rspamd-Server: rspam01
X-Stat-Signature: tt3gt158aftj3fuisgz8ob6oj5xbcsms
X-HE-Tag: 1784760499-224568
X-HE-Meta: U2FsdGVkX19Iv7nwLI1HFtZLSED38lmfSuJmEofSWA0RPdZGpq6i4vG9JWS3AzLjOWWV4wvSw2qlfB/zc4XeUdwkCPs943SPijCZWxJiyyPktqBPxAXU/+3qmHd5Z8uNmPKf32iqSOBsa3ofWGJ0/2XroH8kstDsQDmmJDL5twXzwnMY9cJUDCUVTHWwrkdCmAa9q7mzpBlQD7gZQkYKV/WicYnVczZ13gfGUGNpdfNdgl52LZkVdHXuJ3ZUC/689nnV4NqtjEA2LFZv7qCpVMq9fP4QihwFJxu1EPMvss1PdC4Q4MO7GKO5BzHyFSJNaQp7l/9ts2aMi3eymoPz2elMvoC2DDTWUWnHc6cb7zNWuLCMr4jBPZ2U8g2qUV5v9cGnoSqlfafWEbQpgfffd6qjpV/mQ0Ju5X/lRWOQ3qRTRG+z5jKYhDDGFu0aujrpQAS1kx5rqV7ECmmm4skgCkgIAv6EWEIXU1avspq3JIPPwg98qNB+L7b5r3hVj3IEpJptQ4c5evh/jBr0xOz9eA6Fba6rCAun0vZhh/VpJMK01NVhVrI3qu1tWpA3+VMIa6ug3SwJTHyGp+M1v9w4eYJTVaprQ4FmBgVmsSYdWosmm91ivbKRyBG8UpuuIjYwk2N/wjds6LJaCSAjTnLaMJ9X9T96jo4RN+wNb7qeHtfoCMlCpFbJP591rS2iZSEkqt4Xj3yU31Z3qUnYyCY4V1tzj2qwBX5WHuN3qcwGRRNzxVHc5Hl2UdseSxeGk22PcGa4aIbZ3OcsRYExGQ7iwG8UidVPlAM5uQW/9uMgUe/wqboP6Y2YcMYud1ep/HdLfHyvtOo9TNCyg8lwP+yveXyIUkDbbX+DGMJedONhopsvuURPi8xIFyZfE2yiksZHZnThN3/wh1sPLjPKNs3zlCN2DT5ndrkHX+D34MFEXGkVcuDZbBjnWpV+7bZgE9UEtwIdp53PGsml0+4ljPe
 g2nLkuUs
 30IqOIXiHMRFeRzXnYe5cL8OomNUTRn6R6buRk33fL9Xxb7pslyNkZWkStbcX0949m9iA5DVGJ//RP+0XEiznwA79JW1Z9jnc8ryf2gw3bnGQtexx4FUs71hD6ZL4MUJ/qiayfgQ97LUkDnLZj6+1U0UAa/guWbDcY1AHHHfLUupNW6DgzF2Qs0f2+XekEcTf2NQqbagi6MIq45TxnFTW5fqUMJmTOR9tfWZWMMKFOzslFCe3KWZvrvImUebQv1TSRnOopkpU4+BG5XBQ4QwrRIyhszpuYy55XgI/QyPJ/fxO7IoIetLLIVamMuTj+ovpcFFQGSZofufWUnRUUEserMY+63FZRDIpLj2ToQKH50h3luY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 14:44:22 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().

Thanks, I've updated mm.git's mm-unstable branch to this version.

Sashiko pointed at a few things, some pre-existing.  The jiffies race
in [8/8] looks legit.

	https://sashiko.dev/#/patchset/20260722-hmm-v10-v1-0-606464dd601a@gmail.com

> Changes in v10:
>   - Included contended mmap_lock acquisition in the
>     hmm_range_fault_unlocked_timeout() retry budget.
>   - Dropped the redundant top-level fatal_signal_pending() check in the HMM
>     unlocked retry loop; mmap_read_lock_killable() now covers that path.
>   - Restored the absolute outer timeout in drm_gpusvm_get_pages(), since it can
>     run from GPU page-fault workers and must not rely on the worker task’s fatal
>     signal state to stop invalidation retries.

Here's how v10 altered mm.git:


 drivers/gpu/drm/drm_gpusvm.c |   11 +++++++++--
 mm/hmm.c                     |   29 +++++++++++++----------------
 2 files changed, 22 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~b
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -1405,7 +1405,9 @@ int drm_gpusvm_get_pages(struct drm_gpus
 		.dev_private_owner = ctx->device_private_page_owner,
 	};
 	void *zdd;
-	unsigned long timeout = msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long timeout =
+		jiffies + msecs_to_jiffies(HMM_RANGE_DEFAULT_TIMEOUT);
+	unsigned long remaining;
 	unsigned long i, j;
 	unsigned long npages = npages_in_range(pages_start, pages_end);
 	unsigned long num_dma_mapped;
@@ -1420,6 +1422,11 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
+	if (time_after_eq(jiffies, timeout))
+		return -EBUSY;
+
+	remaining = timeout - jiffies;
+
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
@@ -1434,7 +1441,7 @@ retry:
 	}
 
 	hmm_range.hmm_pfns = pfns;
-	err = hmm_range_fault_unlocked_timeout(&hmm_range, timeout);
+	err = hmm_range_fault_unlocked_timeout(&hmm_range, remaining);
 	mmput(mm);
 	if (err)
 		goto err_free;
--- a/mm/hmm.c~b
+++ a/mm/hmm.c
@@ -790,22 +790,14 @@ int hmm_range_fault_unlocked_timeout(str
 	int ret;
 
 	do {
-		if (fatal_signal_pending(current))
-			return -EINTR;
-
-		if (timeout) {
-			/*
-			 * If the previous fault dropped mmap_lock, then the fault
-			 * handler made progress. Restart the retry timeout in that
-			 * case, but keep the existing deadline for ordinary -EBUSY
-			 * retries.
-			 */
-			if (!locked)
-				deadline = jiffies + timeout;
-
-			if (time_after(jiffies, deadline))
-				return -EBUSY;
-		}
+		/*
+		 * If the previous fault dropped mmap_lock, then the fault
+		 * handler made progress. Restart the retry timeout in that
+		 * case, but keep the existing deadline for ordinary -EBUSY
+		 * retries.
+		 */
+		if (timeout && !locked)
+			deadline = jiffies + timeout;
 
 		range->notifier_seq =
 			mmu_interval_read_begin(range->notifier);
@@ -814,6 +806,11 @@ int hmm_range_fault_unlocked_timeout(str
 		if (ret)
 			return ret;
 
+		if (timeout && time_after(jiffies, deadline)) {
+			mmap_read_unlock(mm);
+			return -EBUSY;
+		}
+
 		locked = true;
 		ret = hmm_range_fault_locked(range, &locked);
 		if (locked)
_


