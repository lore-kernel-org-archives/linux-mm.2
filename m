Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C4BC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B736B0095; Thu, 10 Sep 2026 20:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615066B0096; Thu, 10 Sep 2026 20:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504706B0098; Thu, 10 Sep 2026 20:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E6DD96B0095
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:18:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CC51A0650
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:41 +0000 (UTC)
X-FDA: 85199570442.08.741C0AB
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2A5731C0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mswr0a4x;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789085919;
	b=yDN2Ai/M7PG21O250z8MQgCeQhMC9mic33ISPfE0eDArqXGIfnauX3qH6ftvcUg1TAvVRx
	qXDFGMNiwOrGlu6pOZMsMHH9uNoMcaNkizGFuVnfgeW3TJhMvRafks6sGeopu6D94MniWK
	etsz/S8BVjga/3BQb+bjgnIUqlSisO8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mswr0a4x;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789085919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PdeGUk78rOtPCIG/0kxB5vZ5w0EIZpg3hPrMBzGs7bI=;
	b=uNx9xXXgpcczgprDUczQo8/mAH8VC/ICnK66h4yjPZicMaBiDHx914MVC4MtpXVX5EJ9bt
	5QSFCoWmvCS31grJTnDIsQt9RaWpX4d+Je4WuiXNtMLuOqRc3BSmWCwlrAmbs0rLVpPzg9
	FzsNvxvdOYB3aFWj7RrLxrlOvIA37nU=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910ca5aa8so36289185a.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789085918; x=1789690718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PdeGUk78rOtPCIG/0kxB5vZ5w0EIZpg3hPrMBzGs7bI=;
        b=Mswr0a4xxILNN8b6xa0UPonYvluO1f06k1zucTj0ebe/LZogSsjZ99cGbHd2Zm8nWP
         cx3FR/CBKSpviqMyfdVOP0Z50VzmM8oY1azboVmAh6WL0sUbRc/CRZ1GEzNtuguxQE+s
         /hWwt+GUK4nNOk4JX+ikOFhoffSaDKS5O/5lfhwfTacbz7MfwmHB15ymBIGEIeGr6Uva
         nVMEQAWfqhZGrx/8mPuj1Ez6RcS83mpnlHbx3RDiSXAUcHQMDi41qQAisU08aDKai1B8
         jZpRNzkMva37di9gOrLeFnCV3cRd6wXOwu4/dX3+72GgB9h9dcENBk2J652GoSk/hAw+
         wR1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085918; x=1789690718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PdeGUk78rOtPCIG/0kxB5vZ5w0EIZpg3hPrMBzGs7bI=;
        b=DDJC+cKmf/kywcLsqNbYwMVMWIiAS8Vkl1w72Wg1zD4ZZjSdXDaBBBTrGpCpc/zQnv
         FFmmhZW6yw7IGHLx/waS+fxUrh6xoAnGX3ubtSIzP9UTLisymCp6M2cy7NdZ+b0egI8/
         SjFbNOeQZyBewfyW0H1IOEuFkvkhBSdNIqFpOTeFZ8wNW9NNRgBVCaoZVfkJhDXMYrWM
         +he0aQDIZ/A0A0JQRsMdRTWo86akhokaJqJey2ux2IbuVuxc/wDztke+yUUnFY2jo5Kp
         Ps48Yfq8qAABiqJUwlVkcGPsuLoP6Mh5WhJiqc2Y01ZnvWYWRgzS9wd2wrBJHUcmTLGU
         dG7w==
X-Gm-Message-State: AFuF++nX3Ua9sNNrTO5Aw9L1FbcEMFmqFCARdQXDnQ04r+fNg6gh85qT
	Mgh7Gj/Vt+x4GOUl1Y9FVeyAMrLyEa+f+O05uT+K7FdH+br6tur8SinzRYXyWkcB0GG6IM72xq6
	j+vJ4
X-Gm-Gg: AYBFou2gA6r0xvclPbFm3K2OpjckQydBQz2mHLpXMEOT0Il0pkga4v+g1Hvh5OhBhky
	1mKKI0Xon8WOh73JphzVFclllXn9N8OdlFArVUU/sK2DVy3VU/LDFIbWx3hFtDIIFzvR7pgBdc6
	MnrBLjId6wAMVsQCWjeS2YvD62asEDdZ+LMCIhE1TvARIup7/L0UItkBUig+epJRvc1okI420ex
	kdaP6z86vD35wiojN2rdxATOSgQ+2TvY+N5LNrmZcilnxcb5RfZdOfNexYxs1QTtJR3GkSK/RuG
	ZfXT50AZEgNv6d9c3g8z64p3ifr9AAkEAC6wuxAHwiGytwk9+whGK8QNkZpK7I/QUwv+yFC72cp
	p/wrrHCH0gULqDXF7L2wb8MfeG3dlkWrJeZle2VoCZBmkhzyLw0w4o0XUCbqmd1EjyvyKf2xx8M
	kanWhSWB2Jb/jK6y2ouZJL6sKvMZppIBtk/nx+NkjYVw/Zn7CwYqpvYb7Kw2xeNZQrPyB8YnKed
	TioqGWgObhR7iGewbLbGr8eMbxAPNX3aBsXIQ+mJ+G4TWwDHErckpxwcYnZ
X-Received: by 2002:a05:620a:472b:b0:939:d440:e530 with SMTP id af79cd13be357-939ea0e3717mr224092885a.9.1789085918183;
        Thu, 10 Sep 2026 17:18:38 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80e4c36sm108896485a.40.2026.09.10.17.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 17:18:37 -0700 (PDT)
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
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	osalvador@suse.de,
	hannes@cmpxchg.org,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v2 3/4] sched/numa: scan read-only file mappings in tiering mode
Date: Thu, 10 Sep 2026 20:18:25 -0400
Message-ID: <20260911001826.2109390-4-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911001826.2109390-1-gourry@gourry.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A5731C0008
X-Stat-Signature: ziz7uqm7zhtkh56sd4ogdz84xpxdq55f
X-HE-Tag: 1789085919-411844
X-HE-Meta: U2FsdGVkX19zXyXdt0e7jzONrZDiFN1OPNKvm6vi/TNTzlu5dzSSFCKXD6+8N8w5IfZVbAbf65PGuX2KDlGaTHFezAX8QYKaXtPRJ3M0nPrgmn0mOFUbbeef1czcNpNOanXR+DVAOIiXs198Z3C9Zb0AtAHMSxGkSHuo31Lb6nQ+dKIJiGYr8LGCBCCpFrAXbRquSDdeym+msi2iKZVtobJa/3Bqwz2Jnk3u2UXCk1wL10e8JyEOFfMT+F6d0MUlBg7hITK+v69zWLr+8umMTP4QzTGzzhBb77KYMEAZau1qe5aqyhwb0//5n1PZ+KXI0B3+4azirw5oPvdqAb2wO2Pq0P6Re3S+7lXROJRQM9PpN6YZp3PcQEeZxql+8m1JJEI0LFTYKXVJA/oqkTfCKjMQUx2RtryIzycS0QFN67fPkrom76LSEPrQSHURlYjU+pdMP0tJECR4EAc/i//7746uotapn/8mgW3VocXnpwcbVlFCslPk6yKagR2dTN7sNqA6g0A2zISNPObqwdkLTaf6M0K5dBZHL2J44K3K/NaKnHC+F8H7/cXJln5ebrRNrEy4lsngtd/IPiN+JSFJlcvZWUklblin73oQibEWPbjVWebrffjuw7Y7jJnxDJemWrcXbpduj705r5aDglk2j4I6bYMXef1NryR3Ub9bdk2XowyncO78kOjxIntPlxuXyJcIncBx9rny1F3K1vAhWJk5hyaQdrSiE82Nd4Oe3yjhat5DRCkwLsRLgOt5BZd06WqMAmYX3T7UnEGKT41rkmvRE6H4Fq3ZPhRlCWhwbJPp8pcIYay4awxw4ddkp1exza0UnzJe6Pi5TDtezC+oo+Wdrqc5Nc6DwV1TgKQQd6yIWt1VQ4T+AJYTujsCUYWoxlCiLUklN0IdXEL49aMedIKsWDGysw+DoaANYNG/xoO8hvoRgjgu7vU6CE7K5dHEelSngmrOmS3aSDBKo5G
 D0BhGY0C
 BJV0vANe85F7VI4Odqv91ZVxHpQ6Ml4k9LdcSdQ3khOnU3O+kCKt2xbFYVPDiZq77GN2e0PzKWieoat86mXoHKO2qWlw/xWbVtbitW2m3uD/Qhgpo+p2cvUpmnfXbUm3cqnXkhTHT+3ZcPbpM6/NKCQfORts4LTZVtGVGirjUUhE5VK8LqNVvbBw0WbWN3ww2QKdVbi2t0dDj/z/734KE4bnLlrVFd3J4+qQtnqQQMkx+4n/hUYciqVLa1d1nJ/XEo3VWQU96GHxo/26zC+D+BkK559wDGZKiucbjumpGyUAr88M+EyQ1sPXsdIh5I7lyxefICXH1bPb1aPOjevLrtWbfL1vzh+GIOxX9nL18uKZPtyijlCmyG70do8PV0chNvOynrSdVmbdGT20UjZuGegmwPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

Commit 4591ce4f2d22 ("sched/numa: Do not trap hinting faults for
shared libraries") excludes read-only file mappings from NUMA hinting to
prevent placement bouncing. This also hides hot file folios on slow memory
from the tiering code.

Scan these mappings when memory tiering is enabled, but make their scans
promotion-only. Ordinary NUMA placement retains the existing restriction.

On a host with 768 GB of DRAM and 256 GB of CXL memory running a roughly
430 GB database service, 169 MB of its 185 MB main binary accumulated on
CXL before this change. Afterwards its tier residency tracked runtime load.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 81359b414947..e636e8de53f1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4061,6 +4061,16 @@ void task_numa_fault(int last_cpupid, int mem_node, int pages, int flags)
 	p->numa_faults_locality[local] += pages;
 }
 
+/*
+ * Read-only file-backed mappings are expected to be cache replicated between
+ * accessor nodes, so they are not worth sampling for placement.  They can
+ * still strand on the slow tier like anything else.
+ */
+static bool vma_is_ro_file(struct vm_area_struct *vma)
+{
+	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;
+}
+
 static void reset_ptenuma_scan(struct task_struct *p)
 {
 	/*
@@ -4220,13 +4230,13 @@ static void task_numa_work(struct callback_head *work)
 		}
 
 		/*
-		 * Shared library pages mapped by multiple processes are not
-		 * migrated as it is expected they are cache replicated. Avoid
-		 * hinting faults in read-only file-backed mappings or the vDSO
-		 * as migrating the pages will be of marginal benefit.
+		 * Read-only file-backed folios are poor NUMA placement
+		 * candidates, but slow-tier folios still need to be scanned for
+		 * promotion.
 		 */
 		if (!vma->vm_mm ||
-		    (vma->vm_file && (vma->vm_flags & (VM_READ|VM_WRITE)) == (VM_READ))) {
+		    (vma_is_ro_file(vma) &&
+		     !(numab_mode & NUMA_BALANCING_MEMORY_TIERING))) {
 			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_SHARED_RO);
 			continue;
 		}
@@ -4306,7 +4316,8 @@ static void task_numa_work(struct callback_head *work)
 			continue;
 		}
 
-		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
+		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL) ||
+			     vma_is_ro_file(vma);
 
 		do {
 			start = max(start, vma->vm_start);
-- 
2.55.0


