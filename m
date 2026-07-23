Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98204C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 21:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 752FB6B007B; Thu, 23 Jul 2026 17:22:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7035C6B0088; Thu, 23 Jul 2026 17:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F4966B008A; Thu, 23 Jul 2026 17:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35DAE6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:22:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4E36A0899
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:22:47 +0000 (UTC)
X-FDA: 85021315974.03.C327240
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 02EF8180005
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 21:22:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PqDGtK1y;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784841766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LsF46xxakxlsARFJxGTWxEVy+kM0PIVoXm+jBklc8Q=;
	b=pv6G3qIfu21V3Gsda9mqDb9pSuP7ETRiXGfMzxqkXyZLI5qlPywoqDcgg8FIlz1hFjJjHP
	O9mG6xUpSCbpKX8eYD7/YGEAhdvVWyPxJwpdN4iHeXMza5wGK6LLMlDSpWxOnwoE2RKTrp
	sacosyxFfj6Q7I3YRO7FBe2YCx6X/eI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784841766;
	b=UQuofJTRoWV673mKTiZHOuYlPWaEYYFGDUWX+K0GEoN3VfKYw+XKTYSIF3dp0n0Xe+Lc7w
	pt+YFcsXZQ6wNmnAykLOSgSvgTqUpqqnS6vWNpsqkuuy2tqDxSosCsJ5mDi5PzLqtuPblR
	fjfm+oTF9KoCF/h+lCgLH//dspaz4OM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PqDGtK1y;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 738B8408E9;
	Thu, 23 Jul 2026 21:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E381F000E9;
	Thu, 23 Jul 2026 21:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784841764;
	bh=8LsF46xxakxlsARFJxGTWxEVy+kM0PIVoXm+jBklc8Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PqDGtK1ymZc6iwXzb09CtmFYmLViI3ZUzwC4EZJzeq9zwSf91u2vNh/4wCIJIHPWO
	 e15iO8gkDRLbbRBA2tojf2jKWmot7imPS0HbTnDJI9D1VtypOpQwHATciE7rioefeK
	 s0fKBNhwMPvzspt/Hs40GfWyqW0dMZJpQhg7C0tk=
Date: Thu, 23 Jul 2026 14:22:42 -0700
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
Subject: Re: [PATCH v11 0/8] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260723142242.5d3f87208d47819d873ae458@linux-foundation.org>
In-Reply-To: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 02EF8180005
X-Stat-Signature: u6wnan9ptdm8uh53uu1pm15smxrb5g6f
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784841765-618278
X-HE-Meta: U2FsdGVkX1+AGp8lrMasl/DzOTHhQ/9QGaZ3ztVNdwF1jFV/X4++WIQMPTkZDBqQmLLIH1CXH0uz5d+qE/bW3Rhg4d1ACIU5wRVxJQLquWTEQMgk2iSoYtu9bVVijOswBvvgpBdFEngH3MKH1LiQlpzV2Cz8orQ0nZpntPCVT82997/2VELhDKeubKVFQIhy7kuoeXhkBo0wQ68/lhokYBJrpOCMpBW+vAPoKg7yCrXG+Cxj9l9kWDt3VpBOSf9hDuEn9e5NGd65gaSIJpyGGOlvAXUAh1glU6bNlxzuNZIFIJLjs7j2mCtUjvgwUGqiCpymvpJyBRu1tyouPS48i4fxdAL7ILraqsEkHmnhNYNcHDiLXW4ypmkGx6KP6RvqgtKxgZc264dlMb16/CowikCCw9aD3gnjIH5HHoNYGBgpgiVh7fCBWMLW10F5GUO4323ijrFW54Eh37EihkpkAHesLC8C1RD9LghXHtM9M7pXxo7/OOO206pSgIDXKDZnDw/omrgUmwMGeHzLjFrum6519lgIqZrOV0HZ2/so00mmUAjzl9tVKjMmtwkFe2Wcig/y2C3g5S1vGi4Y91wDppkCl8hKoMUWnj2nK0ogGEHKnJST0ShFRtWxcm5DAwLPyGtpBa8XVBLj5LA1QFpTZQSqBSX3qrfF/n8gOwTZfNIp1XUKvhtNsFOmwvIb6Q54JgpMJWfZz+MegfAN1mjRnH3Wzag6sQHm0FBVFJDkW5HnT1Gg1JOlg+yJSJXgGhh7+ej9V55gH85w5p7k1BRVP1Ncims0M9AvZIMDWGBqrKHheLxlA7XO5+jhWI8Y4nfcz7n6jchkfR4AYoFVpj4joCjX9hTy3yeqD+BAhqziKs5VIDoBRpdgfA7O6Y4UOXr/ZBD8HQ9Ny1q3oohMg4EKHjpSR1pOxMWZB4YbJpBZNPokRpZbVeF6f/NnhWI6YSOhwipXk6HZ1QUu2kdi9CN
 WyO+EKxD
 Mf1SeUh5vQW3czLyMTc4d4KKuK4xJjmRWEVf5o/DPjMnLwsC7+20OwKB8M/eZF/WCs7BvuHDQ1fCAlRGuOSn/seIzUMfqT2v7UHqKIWMpk3wGaRR/bO+XfeORLAnMlnPL5+1q67ssFadHSgc0IOrAlZk/dZdlGPv0M63o2QqVs7p45a0jYWzZ+nQJJncReuhYixVn+hrdGIWwWCbgJhKMmbnc/fsFp+9hnByu7Jr+9+gbXHQWrfLxaOgGZP7wZyaH0rz027Fr3DJa3AfBFPTD3LoxSpVS13Qq/6CXHNXgf4CF0MYwskfkFlWAiM4txlW1M1e95tg+CAJy3A3IuhcP8fHCJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 10:36:32 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().
> 

Thanks, I've updated mm.git to this version.

AI review suggests there may be some problems.  Sorry, I don't recall if
these were considered in previous versions of the patchset:

	https://sashiko.dev/#/patchset/20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com

> 
> Changes in v11:
>   - Reject unstable address spaces in hmm_range_fault_unlocked_timeout()
>     after taking mmap_lock and before walking page tables.
>   - Compute the remaining HMM timeout budget before the time_after_eq()
>     check in drm_gpusvm_get_pages() to make sure it can't result in zero
>     and lead to infinite HMM range faulting loop.

Here's how v11 altered mm.git:


 drivers/gpu/drm/drm_gpusvm.c |    4 ++--
 mm/hmm.c                     |    6 ++++++
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_gpusvm.c~b
+++ a/drivers/gpu/drm/drm_gpusvm.c
@@ -1422,11 +1422,11 @@ int drm_gpusvm_get_pages(struct drm_gpus
 	struct dma_iova_state *state = &svm_pages->state;
 
 retry:
+	remaining = timeout - jiffies;
+
 	if (time_after_eq(jiffies, timeout))
 		return -EBUSY;
 
-	remaining = timeout - jiffies;
-
 	hmm_range.notifier_seq = mmu_interval_read_begin(notifier);
 	if (drm_gpusvm_pages_valid_unlocked(gpusvm, svm_pages))
 		goto set_seqno;
--- a/mm/hmm.c~b
+++ a/mm/hmm.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/mmzone.h>
+#include <linux/oom.h>
 #include <linux/pagemap.h>
 #include <linux/leafops.h>
 #include <linux/hugetlb.h>
@@ -806,6 +807,11 @@ int hmm_range_fault_unlocked_timeout(str
 		if (ret)
 			return ret;
 
+		if (check_stable_address_space(mm)) {
+			mmap_read_unlock(mm);
+			return -EFAULT;
+		}
+
 		if (timeout && time_after(jiffies, deadline)) {
 			mmap_read_unlock(mm);
 			return -EBUSY;
_


