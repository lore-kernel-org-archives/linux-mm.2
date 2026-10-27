Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61757606A332
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RhL4d8Zu
Received: by kanga.kvack.org (Postfix)
	id 62A236B070E; Tue, 27 Oct 2026 08:51:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DB606B0710; Tue, 27 Oct 2026 08:51:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1C36B0711; Tue, 27 Oct 2026 08:51:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2833D6B070E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:51:40 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 84BDA1606A9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:51:39 +0000 (UTC)
X-FDA: 85368392718.07.3CAFA93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id ACA1A20003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:51:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhL4d8Zu;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793105497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+uXv1eTUrQghL/izDMabbpVY73PTdHTwOJoJlIUerY=;
	b=zpkUk1d9aASC5zKNm8L3I8ZK0imu4iXQ0hG8DUQxWlKeCe5rDTXMQh0/7sclaZOAgcJhr1
	5Q0tI7CC0WBEZmQRWNkMBJxLkTQPGXk1vGmMglQpB6Jf4VcGkGZaeRFHiXg/1cPWuY2OJv
	FxAdS2hG8OZqB/aQ00FKGXHbBZMFIxc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RhL4d8Zu;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793105497;
	b=mrzneBfeScrqfLn+S10XrWMGTJcXtA6pcBoFrIiPmIHQ+4JjdDtkP5QYPgpnvsBkPRV6Zt
	BN6ZfQ5BvMk+8VRPe9UrapmElvS2HW86Rz0RKDgIhTBCl6Hdi8Hf4FL7FMq+OTVdp2a0TT
	63AxhDrbw1hVDZsg61AlSBuHLmJEw6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0E0742B03;
	Tue, 27 Oct 2026 12:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC36D1F01825;
	Tue, 27 Oct 2026 12:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793105496;
	bh=8+uXv1eTUrQghL/izDMabbpVY73PTdHTwOJoJlIUerY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RhL4d8Zu1trOGOtBxu31hp1z9kcJI8StIU9PdApiow/lWbyJJBgk7hPgSOjQi+nAE
	 AKRePsFov/ULoC1TkpsBYIh6pWvxp8cze0hi1b2Wj8sLc9y3xwHg8T0wDhk0ansqEn
	 xFcuEFexIhMX1R7GeGxuEMbA0gzNR2uL86P4NnOrvqPqGKbhNY533fFW5lgDp3HMkO
	 504rU/EFttXr0YSzHwfQbLXRy4PfREzzWOw4vyCXu8y4Crjzx/Lypni7HK9LVH3BLR
	 jeWfadnld7ZEOg5OWEy6erd+YZ29bgw202P1j9QdjZ/At4MBlPey/BdaPcmJfXSfIR
	 LjesHhmkVS7rQ==
Message-ID: <9051ac3d-60b9-4ed2-b781-b7191898bc83@kernel.org>
Date: Tue, 27 Oct 2026 13:51:28 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/6] mm: fix pfn walker races with memory offline
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, osalvador@suse.de,
 muchun.song@linux.dev, iamjoonsoo.kim@lge.com, anshuman.khandual@arm.com
References: <20261027042204.3741307-1-gourry@gourry.net>
 <01d7d54d-0047-4eb6-a1d2-5b3f113f26cf@kernel.org>
 <179310071902.664110.12994053710961856591.b4-reply@b4>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179310071902.664110.12994053710961856591.b4-reply@b4>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACA1A20003
X-Stat-Signature: pg75qgmt95dqthfmdixiiue8jgmedbp7
X-Rspam-User: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793105497-335131
X-HE-Meta: U2FsdGVkX1/GgiVCz8GSSaHQp5zg4oQZhlFsiI+iYk7HAisuUOR95MeiYbbv1T36M/Wqnac3j0ujubUzdruuVCc0seKNSqiMRuacQ8Sx73KB5rCDTPGO+FWrKZrrzKwXHO4hRjqCZommdv29Z8Yh69TpCoWrD3ZFRi4eJXgnPkxLI2N0yYZS3bkx5sVqH0+abJaCLjhBkOGTiLXmK3EtrA7Xd7dwzYfMvtgxzR9BQzunSyZcegr7BoC8HAqQnJlCp+BeB7YqnjcaoVQVSRKEu8aAO1okGXilMNAj/zqK3Ch8qb5nrqaQbLilPiDVmiGRgUyRVKjHqDfpth+CkTcrfZA8Z/P+3zkvJ0PaUfd6Ry12yyhi2GsBRxlx1Gljs/FM3destPumjvHmqySQQ1ob/+3HFT64SeJaz5t6Em+VD1VxO5CxBAbYVs0nVAM+J7e4F62QDUSOk46aDf//wL/c+H8qOoF321XRwt8j8s+lDQHXH317TPshMXFUYpdrpieQizDyr2BFBMiwgvQpG4UNR9S+3uy6STVPHgXZDeQnobPcQWrBIjZtGT6fB6p9iXNbZR8QPxnhi4rN5WpnoiUvppuZvRKbO2e/TXqG5zswS5YwraN/PCcghTqbbO4BAqcPb2TycUipy0zrYrBLK892fbXKv632DWFmGJQOEDpy2nUOkUncddG/wrb+oJT+hi6XWIDIRneRKhCQdoh/tosKMOVSRRXFWM7akLjIzXFyAINK0i/liFSIypXnPPhWr51U6GEiFUcHULXepCRFj3cCPWdZ1pfRHtinGVjlRXK1OY3CcstR8FmK6tHzVEnGZBWj7nHctoNb39eUovHq/cj+a/fsnbSQMnMU1ZEZnAQQtGoPGvljWXSh2jBEVEw7cfJWSbIWr4SF0NbSRMdI4iXOLP9PQtq/eNyrs21NzKHnCXZiGY9LpL5b1mS9ey/mryR3psn5ZrlYb+NfKyneFYS
 2r5RcMjn
 Kv8strdHhKvA2yTQR8y/yW2kVaCdeZiThoGqVU+4ulD0yILIYpAA6Xj/8p7By+eqhNLj7KW6qmd+mvptRvQb72BcQR48s1iitguQtXkRkzCn/UxZHH2luVTUKs4pzo3EudGhlzHeQwXdvdmiri79w9I8Jefr4AfseONw3LI4PX7P7DE7Gy0IyM7IVaWWy5RBsuNn0BlmdIFMDeprX/EZECtPuUYsHvbb6OlL74bkEtwuvHbISxSUlhW6XEChIK2Zvkz8+kbPlwFUXFOFNDZX5eaI8vxHsHagoSAR/ngPWJTA2cUfw3V7JlXC/ApNVjuSGPa09ZlgL68ZSfcX7ln7Nez0aY35ns7xldwhMWnncqLdyzmAN9WHOjbi2AiEry2JKM9Y+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 12:31, Gregory Price (Meta) wrote:
> On 2026-10-27 09:57 +0100, David Hildenbrand (Arm) wrote:
>> On 10/27/26 05:21, Gregory Price (Meta) wrote:
>>> Several pfn walkers check that a struct page is online, then use it
>>> after memory offline has poisoned it (CONFIG_DEBUG_VM) or removal has
>>> freed the vmemmap.  Five of the races crash the kernel; the sixth leaves
>>> an offline spinning with the device hotplug lock held.
>>
>> I have roughly the exact same list of AI garbage fixes here from a certain company.
>>
>> And I consider this all extremely low priority.
>>
>> So this is something to discuss throughout the next months and do it properly.
>>
> 
> I actually have a reason for these fixes other than "bot said bad".

So you found them on production kernels?

We did not have a single real report of that for probably a decade or
even longer in production.

Recently, we had the single first report about the compaction case from a
stress test (no production):

https://lore.kernel.org/all/20260903095543.3752338-1-yuan1.liu@intel.com/

"We are not sure whether this race is reachable under realistic
workloads or only under this synthetic stress test."

Where I motivated that we need something clean.

> 
> We leverage ballooning and hotplugging as VM memory overcommit tools
> and are finding that some of these race conditions crash them with
> large MTBF.

yeah, that makes sense.

> 
> While most of these are insanely narrow, they are not as unlikely to
> happen as you think. A vCPU can take a vmexit in these windows much
> more easily than a host can take an NMI or other interrupt.

Jup, that's what I would expect.

> 
> Thankfully none of these (or the other series) appear to be obvious
> security issues, but they are stability issues.

Right. And DEBUG_VM reports are irrelevant in production.

The thing is that the race between offlining and actual memory removal
is extremely long. Poisoning is just a mechanism to find these theoretical
issues that could cause issues faster.

And with all the other things going on, this has lower priority, and I
wanted to get back to the AI patches I have once the other thing is sorted.

> 
> I have a reproducer for every single one of these (and the other
> series) - but a handful are unreachable due to a 2-statement read
> being emitted as a single read by the compiler (which can be undone
> by a targeted compiler flag). Those were included for completeness.


In general, I think we want something that will protect all
pfn_to_online_page() + zone->contig thingies, not just selected ones.
We discussed in the past using some sort of rcu for that.

get_online_mems is usually the wrong approach.

The infrastructure for that should be added in a clean separate patch, not
mangled into a patch that fixes a DEBUG_VM splat.

This is nothing to rush in or to schlop around.

The AI patch for compaction I have here does something similar to your first
patch, with a bit less churn, and converts a handful more users.

E.g.,


+/*
+ * Nothing keeps a section online once pfn_to_online_page() has returned. A pfn
+ * walker that holds no reference to the page does the check and looks at the
+ * memmap under this guard: remove_pfn_range_from_zone() waits for it before the
+ * memmap is poisoned and can be freed. That wait cannot be interrupted, and
+ * whatever a walker sleeps on under the guard, memory offlining waits for as
+ * well: leave the guard before copying to user space. mem_hotplug_lock is held
+ * during the wait: never take it under the guard.
+ */
+extern struct srcu_struct memmap_srcu;
+#define memmap_walk_guard()    guard(srcu)(&memmap_srcu)


and then


diff --git a/fs/proc/page.c b/fs/proc/page.c
index 260772b20bd99..c5f6d7fe12d9a 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -58,13 +58,39 @@ static u64 get_kpage_count(const struct page *page)
        return ret;
 }

+static u64 kpage_info(unsigned long pfn, enum kpage_operation op)
+{
+       struct page *page;
+
+       /* The page is not ours: keep its memmap until we are done with it. */
+       memmap_walk_guard();
+
+       /*
+        * TODO: ZONE_DEVICE support requires to identify
+        * memmaps that were actually initialized.
+        */
+       page = pfn_to_online_page(pfn);
+       if (!page)
+               return 0;
+
+       switch (op) {
+       case KPAGE_FLAGS:
+               return stable_page_flags(page);
+       case KPAGE_COUNT:
+               return get_kpage_count(page);
+       case KPAGE_CGROUP:
+               return page_cgroup_ino(page);
+       default:
+               return 0;
+       }
+}
+
 static ssize_t kpage_read(struct file *file, char __user *buf,
                size_t count, loff_t *ppos,
                enum kpage_operation op)
 {
        const unsigned long max_dump_pfn = get_max_dump_pfn();
        u64 __user *out = (u64 __user *)buf;
-       struct page *page;
        unsigned long src = *ppos;
        unsigned long pfn;
        ssize_t ret = 0;
@@ -78,29 +104,7 @@ static ssize_t kpage_read(struct file *file, char __user *buf,
        count = min_t(unsigned long, count, (max_dump_pfn * KPMSIZE) - src);

        while (count > 0) {
-               /*
-                * TODO: ZONE_DEVICE support requires to identify
-                * memmaps that were actually initialized.
-                */
-               page = pfn_to_online_page(pfn);
-
-               if (page) {
-                       switch (op) {
-                       case KPAGE_FLAGS:
-                               info = stable_page_flags(page);
-                               break;
-                       case KPAGE_COUNT:
-                               info = get_kpage_count(page);
-                               break;
-                       case KPAGE_CGROUP:
-                               info = page_cgroup_ino(page);
-                               break;
-                       default:
-                               info = 0;
-                               break;
-                       }
-               } else
-                       info = 0;
+               info = kpage_info(pfn, op);

                if (put_user(info, out)) {


protecting individual pfn_to_online_page is just whack a mole. Likely we want a
way to check whether pfn_to_online_page() is called from the wrong context, and
maybe we need a variant that can be called from "wrong context" for a good reason.

-- 
Cheers,

David

