Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E6CC79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 18:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B776B008C; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902196B0092; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2AE6B0095; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CF626B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 14:20:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D412D1601AA
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:20:22 +0000 (UTC)
X-FDA: 85176894684.04.D7CF244
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 25D6940006
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:20:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SZb9kRBU;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788546021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSRixT7jynn3gCypVDydAS92P1PrLhM0zXSgAeyy22g=;
	b=OxJxbopI8dFNkx7PAvs3I5QfHorEC38eC/fyDKQdUGtnmHdifxsm4Rz4nahvzK0ps6NekW
	+NcYQNDZ7WCZt7ccFwSs9TTT7B/Gnml3MYtm14gZqXvBB+N/LcvHIN/PcIKjZmcI1GqaZT
	ChRPySCvBozoptIjj6D7wH6SJIxf2co=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788546021;
	b=dhfDz3KhJWaTKplULa5oofzkGJOMIqu6r2IBXIpn54v/JlJ7JBh7IPZTain3bwmWNxg0vE
	D8MTult0/tKpPkOduG82PksXS4sLo4ApNwPqrXJ7NkRpazZ2lLTwE4cpV5robymrraR6z0
	dWt3XqNz0hoxOG4DJT/u4oyWGK+mvTU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SZb9kRBU;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92ed19f4d60so134423785a.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 11:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788546020; x=1789150820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GSRixT7jynn3gCypVDydAS92P1PrLhM0zXSgAeyy22g=;
        b=SZb9kRBUEu9QAzwXXeDg9pPCWF3vFgBCS6E8ysOMz3+KH9HVHiR+/7i2Fd9gNZ3GVV
         7xLKXDO1b3OyqrgJIcwaDvjx2rwJ7gFe6eO8vJ7xkrVD/cEOJyjqJnXzA3UPof3w+NE4
         U7J6qQHxcIM+e7Et/+Wjem3S8Rl8lBCkiOY/ZlAKQr4rDZ3USOTMx5lS2Gov4QEgn+fy
         cKY1kQ64bwpZmHAcoIQ4v7U7mCXMWvRzfdDBh/tnk+rxGu9UTffAVlvelYzLacmfK6sm
         lqxDtg5KzMJaj7avjw3rsiLOwNROmtCtUZ/BvCK/LrG78VD5ZMnejIAFS+3ftb4G/9Za
         vUhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788546020; x=1789150820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GSRixT7jynn3gCypVDydAS92P1PrLhM0zXSgAeyy22g=;
        b=QuuxoUq6GeKmYVEXbxBGY8Xl/INEEMxCp/IejaTbkee71qp0QzQJa+lJyPvKGVkVH+
         0IzJN/ggp01llNbM8pDwE7JQpuSfnH7STkQd+5JPh4S9Gn1cQ1oh5cxWmoM+uZd/9LUU
         cp8/hyFWSkYzHPMej9W+X6v+KMkVYUhQc4fV/euhef8jDrCW6EjvwJ5jcnCTL1UTpfy+
         35s/lGJwunkv+W98VbTnDwkTI7fYq2JxIHm54MnblEPt5l12WbZC1pqI3ApGiw7uEAV+
         wz7K3Q8v6wcfQbKMUNHZ084DSYK/WAFEcZjOvOCUa4P0gpOdn/g8x9o00YGTNSn+33Hx
         9pOg==
X-Gm-Message-State: AFuF++kgfKfN0nDYYogLdCgHRVgh4a27FrbZ9FmtkenAr8ciLSHS8FwU
	10EiPfUIvhmIsmTjaeibNuFztBnyp4TA+cEuSRyDOHbixRi5rGauyPELXXBh0rp2cxVjckZQPdo
	9VUK7
X-Gm-Gg: AYBFou0X5+6JA+AmdjGjpTT1K2cm5U8Z6T8vsj+LvlkRGKhjIhAhLZ3tkr/EHOZI4jj
	J2sZLlEZQJpQNwJtm6ttJdjJoQf/iYukxQ4XnZjXcQ38WdaMzG83H9M3QhJ+lt7MsHGrQZhxlMu
	UvOCBjsUtuoMMl8rBRa33mpBWkJaZMVGFbIGPyC5ZUgptc9sCVp0L85Tu2aXBNuayyG1cU5r1Zr
	Xm2acySX+bO96QyO/yQ94WjMc5Nbe2iYt1ZAEiy3FWzT1749wgyj0WsQ8Rbet6UrY5hRG8OaiRy
	DuB+vAYgp8zm6Py74/K69grlhRXI9rmP7ui8s7ta8lndnGMHX5RjP+O18UuBvtirSz6jTwBHWPh
	H9sInPeT+dvT+F4zpUKKaEkNc1FJz7m6ameDb3rj9WWhQR2oyIgVE1qg3K+55yDn3YxoQ6ohwAt
	xgg+eznFlvyBfhRCubTv01G1vqVl9F1nojZ65LB+04WUnzQXjQL0CzFwa8GpIS6LQfX9uU3RnCM
	iUhi2tOrcdN6f94+EEld73M1HslIK7Ie3axY+YfQLGm9oe4G/HaxnnMY/2ygm4=
X-Received: by 2002:a05:620a:63c8:b0:939:8d2:325d with SMTP id af79cd13be357-939817398b7mr507496985a.21.1788546020031;
        Fri, 04 Sep 2026 11:20:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93982db6a95sm207374585a.9.2026.09.04.11.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 11:20:19 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	raghavendra.kt@amd.com,
	shy828301@gmail.com,
	baolin.wang@linux.alibaba.com,
	osalvador@suse.de
Subject: [PATCH 2/2] sched/numa: scan read-only file mappings in tiering mode
Date: Fri,  4 Sep 2026 14:20:06 -0400
Message-ID: <20260904182006.1562449-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904182006.1562449-1-gourry@gourry.net>
References: <20260904182006.1562449-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 25D6940006
X-Stat-Signature: wt6hqyjyqrsnpqp3dmo978bkyd41xac3
X-Rspam-User: 
X-HE-Tag: 1788546020-553973
X-HE-Meta: U2FsdGVkX18Dpiiick5/DToBHs7WTF4ta5cCKUoJR5zxCGK1obqAjkuS4ggaI90n52ZTdL5r3K1UxKhw5Yoj7DuNznN7C242uSp4KDmJAhTVyYh8VYgAky9DO40Ba65nKqCJeHChjMxcf8uVR8GaVwlYMLHEP1/RJFcY6Xhv4y/GbKwSp9rm3WbAtYFttg6YMiUQ0fogtrpTuwrTQCGunZbiFTvIEYAjq/LORNIj+pfNJkL2tUKJOvaen9HMW1cKgqiFYtPefUxbyBajY815Km8zqbLd6YgfzYXMmC9b9oYCPFvRHZEMGrYjQ//sSth+Qsu69hxx1OCxtMg1Cc9pI5CbFaSxJF7s7Lwc1GxFocmyBFUQtB/wlM9s4xSXVlORQ8bmy9j//J0CZC/3qYebDtWv8XLRZzg/Ptol/acBpFUPx4ks8MIz2LNKn/yc7MeAwetjP31eHTIjnFV/XlEQDXRiSh7sBe50hLgF3ikOrS7fVjvCwP7rRdFVxpaSsafkCW8i4/EYYc3jJw479sdm2rRDUo1OFUYNaZ+7kT3XeIB7kZVM+HGt0YlbqPEtlWa6RxbhlbAsBMo9abMeRqOGhs3nZkA7e4nY97qRIrJb+fvlQKL9mvu/aPK9I3ln7Tkgs+TpM5rZUlf6VfwDcffwRAGbDYLUHfNGDwpGAgDlUBCNqNcuaEeTdUZrN98Mv45fZxItqpQxYeZxewCgwNk98oSSm5THH7PeFyE/35ObAdJYqS/OyZtE9o8nKn6E5ku2/pzSyR0ubr707Hy2gd+ltAqaBmls8SJuXbXMbYyVn2DChXb/azsguiKTJVNn4fQ46lQPkpyBDfvv3KniQ+p4FRuV17E8lduJRcB5srbHydcoGxLREsPQLaJ84cfTPXrfWIQzTvBYZrsiClqf5qwPyd2MoKptkJ13qnb/XRuhFukOuLC1dPiGiwLovQndQ0/H9Q99FS6MiHjqIBMNTVB
 ulwKfMeU
 KauA3dtib6DEM3FM24O6mtDqMraxv0iPzYeonkQjBTeKNWkc/U4U0xPvvLjUqYbusbdMyUf/lolbmRXJT8gRbxxXQcKxwNcl3Bs/3VqRHbYh/FspiW1dqDuAZU3EW5sdwJoSJMTZbVXTZ80Vt2SFq9Sa3pILYz25zQoVY5hX1C2VkOh86MsRFX6Nt53uB7ICqJD5DVBlgkee1HthmrVRDWSYdafcV1FjrEPGxSvNzjiQSaw/M6GH987QKV5qkoaDpG2R64lF5R83x2sphm8JT9PNy+DZR1TMD9LXhFzG6Y8JJa6CCegBXf6wxMjJCgMnCUfLZzHPCdNxn4y/gSWaywmkUifWH1OmR5q7eRY8OFWkh21B7liLi+fXoWvOuQ0mq/NxQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

task_numa_work() refuses to scan any read-only file-backed mapping:

  if (vma->vm_file &&
      (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ)) {
          trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
          continue;
  }

commit 4591ce4f2d22 ("sched/numa: Do not trap hinting faults for shared
libraries") added this because such pages are expected to be cache
replicated and bounce between accessor nodes, so:

  If we are never going to migrate the page, it is overhead for no gain

Memory tiering broke that premise.  A slow tier folio is promoted on
hint fault based on hotness, so these can migrate now - they just never
get the chance, because the VMA is never scanned.

Observed on a 768G DRAM + 256G CXL host running a ~430G database service:

  91% of its main binary (169M of 185M) accumulated on CXL.

After this patch the binary's tier residency tracked runtime load.

Scan these VMAs with the slow_only restriction. Only non-toptier folios
are made hint-faultable, so the scan never marks a toptier folio in a
read-only file mapping in any mode.  A page already on the fast tier costs
nothing, and a page on the slow tier costs one hint fault, which is what
buys the promotion.

That fault is not free of placement effect: a successful promotion reports
its toptier destination node to task_numa_fault(), so it lands in
numa_faults[] like any other promotion.  Only the set of VMAs that can
produce one changes.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Assisted-by: Claude:claude-opus-5
---
 kernel/sched/fair.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 990af0e45d69..5c5c80b17649 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4075,6 +4075,11 @@ static void reset_ptenuma_scan(struct task_struct *p)
 	p->mm->numa_scan_offset = 0;
 }
 
+static bool vma_is_ro_file(struct vm_area_struct *vma)
+{
+	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;
+}
+
 static bool vma_is_accessed(struct mm_struct *mm, struct vm_area_struct *vma)
 {
 	unsigned long pids;
@@ -4211,6 +4216,8 @@ static void task_numa_work(struct callback_head *work)
 	}
 
 	for (; vma; vma = vma_next(&vmi)) {
+		bool ro_file;
+
 		if (!vma_migratable(vma) || !vma_policy_mof(vma) ||
 			is_vm_hugetlb_page(vma) || (vma->vm_flags & VM_MIXEDMAP)) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UNSUITABLE);
@@ -4222,9 +4229,16 @@ static void task_numa_work(struct callback_head *work)
 		 * migrated as it is expected they are cache replicated. Avoid
 		 * hinting faults in read-only file-backed mappings or the vDSO
 		 * as migrating the pages will be of marginal benefit.
+		 *
+		 * Tiering still wants them.  A read-only mapping strands just
+		 * as much on the slow tier as any other, so scan it for slow
+		 * tier folios alone.  Nothing on the top tier is marked here,
+		 * in any mode.
 		 */
+		ro_file = vma_is_ro_file(vma);
 		if (!vma->vm_mm ||
-		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ))) {
+		    (ro_file && !(sysctl_numa_balancing_mode &
+				  NUMA_BALANCING_MEMORY_TIERING))) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
 			continue;
 		}
@@ -4302,7 +4316,7 @@ static void task_numa_work(struct callback_head *work)
 		 * VMA can cause others to become "permanently unaccessed" if a scan
 		 * cycle is consumed entirely by the large VMA.
 		 */
-		vma->numab_state->slow_only = false;
+		vma->numab_state->slow_only = ro_file;
 		if (!vma_pids_forced && !vma_is_accessed(mm, vma)) {
 			if (!(sysctl_numa_balancing_mode &
 			      NUMA_BALANCING_MEMORY_TIERING)) {
-- 
2.55.0


