Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EB3DC88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 04:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2D096B0088; Sun, 13 Sep 2026 00:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDD096B008C; Sun, 13 Sep 2026 00:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC6E6B0092; Sun, 13 Sep 2026 00:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2566B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 00:17:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5615EA0646
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:17:29 +0000 (UTC)
X-FDA: 85207429818.09.7AB5447
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf06.hostedemail.com (Postfix) with ESMTP id 848DC180002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:17:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789273047;
	b=Sbrj0ZE12VZsTHpdwkQ9EjxXzOxXkhHsM6WIQz+JagAFUKTR9t/2bTF/tD9H4lrFoe4AaN
	5eLlakOhvSwvFWcsRwt86N37oNaLYk51wvHwyGREnl7lihQxWbQsH/vUV1v94J/QppMayB
	Eqjss3DXpYq8XtB8+0/oeLd2k5n2PlI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789273047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=doqwSbUkWQz5BhCmeRSqoxndaOdprTiodMv/ppVhnVw=;
	b=WJnSmRACc9IffwRV+kKTpx75DI2Hl6pKH4JHTF8bp6ZSsVxVluWZz4cQvXt3tATPF0Hlqf
	g6CXzy2uWfEDvPpBf+jPTz9GFk+kGXL+kKCzg4nWAXO620AQUMOmNLbG8jmBfKaf1x49y6
	sdIz42OUZ2nIOlkDeoiuefMxetI1Dvo=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4hjFNw44jmz55RGh;
	Sun, 13 Sep 2026 12:17:20 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 68D4HGPL048449;
	Sun, 13 Sep 2026 12:17:16 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 13 Sep 2026 12:17:16 +0800 (CST)
X-Zmail-TransId: 2afb6aa623cc7ea-c3dd5
X-Mailer: Zmail v1.0
Message-ID: <20260913121716693wiN5osmShywgtitghSm7G@zte.com.cn>
In-Reply-To: <40c0c081-d636-407b-898e-f40f3d5d38cb@huawei.com>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,40c0c081-d636-407b-898e-f40f3d5d38cb@huawei.com
Date: Sun, 13 Sep 2026 12:17:16 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <tujinjiang@huawei.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
        <liam@infradead.org>, <surenb@google.com>, <rppt@kernel.org>,
        <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
        <nico.pache@linux.dev>, <dev.jain@arm.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <chengming.zhou@linux.dev>,
        <usama.arif@linux.dev>, <gourry@gourry.net>, <harry@kernel.org>,
        <vbabka@kernel.org>, <peterz@infradead.org>,
        <borntraeger@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCAwLzRdIG1tL2tzbTogdXNlIHBlci1WTUEgbG9ja2luZyBmb3IgZmluZF9tZXJnZWFibGVfdm1hKCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 68D4HGPL048449
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 13 Sep 2026 12:17:20 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA623D0.000/4hjFNw44jmz55RGh
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 848DC180002
X-Stat-Signature: rsq6d4gbakacy4tiqkmakwq37auufnqc
X-Rspam-User: 
X-HE-Tag: 1789273046-941376
X-HE-Meta: U2FsdGVkX18qqafqlGuS8Emp4tl1StKvU35+whJTCPGI66S3wYCccn74C27UJqcp0OwJKwXjlQPYBkFRimAqKZ3KuaT+Z/O4oFEwYfc5AoLbhq87KTTgZNcC5XzbJoFPK9dUhHwKnFawtg1YmKeH4EzHYD3wId0V629MmZ8xpFeSWHhsa0s9KYH7vIlKtGQh0fh7gSiGvKfzEaA+OCMDaeCCE3ZlEBM5z7h8DYLPP2WfWkwjG3i/JSwc+mSrZhwolccmObJGRZ9jTXxQB6GbOlKoyqf3F2yDx7FCu2qlPGeUpNSsnlROshJ9Oo8njU2mNrrR+qujAeMZQ+s/zNN/LnX6yi8JKXqrdPRduq9lqecdnaMdgdsAc8NLHmFXcG7Uv2FTu04gZ9e5Oxs30zKolAM7xl3BpFeQyH9kQrMQYXU/x600uBD7QZbyLsdbJxUADZUaHs9uLBLH88yi+8MvRDVqYJYFzW6b0Kmija1SzpAD8G30x3hpos3etnutbymlSuQn8OF6CrSfM0zP/PjZfwNrTXaAvR0xj0C6jUmsSFgill+qCG1CHrhy2JxhbXvcQQ38/JFvIV7vHtMeVBlvT0BBkiNIUvKCh3tn9vz6BZ4yNuOcO8BCbcpUYTjxsvZs8UAyN4D3qZBp7RRSgQvqTuBN48XKb4ThjUTPAFxJLRRnYr+Eup7OZso2Cs6d2paljzS2GixXpnxBweBo/KBJtvwIqZwmLq0//50sC4vxdHbc92LYJLbUsIxB5R1OqfmQjSI7WKbBRWxnyukm9YUkysfMc8bnq17M7fYk2zBJsVHopW/Cfkhy3Kn8/bTsjN+iz0FmHiPVm91sB86P1tZDYaZ5LmAMQIfu10FzeX86ZVjIhQ9cLvgVa+QYnpcclO2frs7q7CcEX1d7ukMUqo9VsxKlL5odFjSNiYy+C0xIH539lW48EB2tr/9tZ8juD0Ou/QiowGKuk+COmZQ+lKZ
 9PcUXwfp
 AMFSPd+E8OlGr23xalgbKeTRFrojEVx49HOffQRevsh+1m8XFWqdTukFE6sdf28Yf2LRq3RGjjjvsBD5hN3XT60aV1fX9OxVXM0i8gIuFZSKvhqbrMqkDcptxXAshx2oJ0lTAspZl2TFzipvJRMV9iCn6G98LFp9SEH9fIU8fPVmZwIA/ZJt8wnOkjX0hBGfF+xHHDfbkrjJyKm4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >    Patch 1 removes an unused 'vma' member from struct folio_walk.  It has
> >    never been used since its introduction and is pure cleanup.
> >
> >    Patch 2 adds a 'walk_lock' member to struct folio_walk and extends
> >    folio_walk_start() to assert the required locking mode.  Existing
> >    callers are converted to pass PGWALK_RDLOCK, so there is no functional
> >    change.  This prepares folio_walk_start() for callers that hold a
> >    per-VMA read lock instead of mmap_read_lock(), which is needed by the
> >    Patch 4. No functional change.
> >
> >    Patch 3 tranforms the boolean 'lock_vma' into the enum 'page_walk_lock'
> >    without any behavior changed, which is prepared for the Patch 4 to use
> >    per-VMA locking. No functional change.
> >
> >    Patch 4 introduces find_mergeable_vma_locked(), which uses the
> >    universal per-VMA locking helper vma_start_read_unlocked() to look up
> >    and read-lock a VM_MERGEABLE VMA without taking mmap_read_lock().  All
> >    KSM call sites that previously used find_mergeable_vma() under
> >    mmap_read_lock() are converted to the new helper, and the locking in
> >    get_mergeable_page() is switched to PGWALK_VMA_RDLOCK_VERIFY so that
> >    folio_walk_start() can verify the per-VMA lock is held.
> >
> > A microbenchmark was run to measure the time KSM takes to merge a
> > victim region under mmap_lock contention. Under interference from 4 churner
> > threads, the merge time of the per-VMA KSM-optimized kernel is
> > significantly reduced by 50%.
> 
> Hi.
> 
> During task exiting, __ksm_exit() uses mmap_write_lock() to synchronize with ksmd.
> see the comment of ksm_test_exit().
> 
> void __ksm_exit(struct mm_struct *mm)
> {
>    ...
> 
> 	if (easy_to_free) {
> 		mm_slot_free(mm_slot_cache, mm_slot);
> 		mm_flags_clear(MMF_VM_MERGE_ANY, mm);
> 		mm_flags_clear(MMF_VM_MERGEABLE, mm);
> 		mmdrop(mm);
> 	} else if (mm_slot) {
> 		mmap_write_lock(mm);
> 		mmap_write_unlock(mm);
> 	}
> 
> }
> 
> When ksmd currently is scanning the exiting mm, we should guarantee the mm pagetable
> still valid (i.e., mm_users > 0). However, ksm_mm_slot only holds mm_count, which only
> guarantees the mm_strcut isn't freed. So, __ksm_exit() uses mmap write lock to synchronize
> with ksmd.
> 
> IIUC, vma_read_lock cannot be exclusive with mmap_write_lock().
>

Nice catch. Thanks for pointing this out. Indeed, the original exclusion between
__ksm_exit() and ksmd relied on mmap_write_lock() blocking mmap_read_lock(),
and per-VMA read locks do not provide that exclusion.

A possible approach to restore the necessary guarantee is to pin mm_users while
ksmd is walking the page tables:

Before scanning a given mm, try to take a reference with mmget_not_zero(mm).
If it fails, the mm is exiting, so we skip it.

Hold that reference for the entire duration of scanning that mm (not per-VMA),
and drop it with mmput() when done.

On the fallback path where we need to acquire mmap_read_lock(), drop the mm_users
reference before waiting, to avoid delaying an exiting mm.

This directly guarantees that mm_users > 0 while ksmd is accessing the page tables,
so __mmput() cannot reach exit_mmap() and free them. It is more precise than the
old mmap_write_lock() synchronization and should not introduce noticeable delay,
since the reference is only held for the scan duration.

