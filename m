Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0110606A891
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 18:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZcvV3dLs
Received: by kanga.kvack.org (Postfix)
	id CF3CD6B05CE; Wed, 11 Nov 2026 13:16:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3756B05D1; Wed, 11 Nov 2026 13:16:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B866B05D2; Wed, 11 Nov 2026 13:16:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93FA06B05CE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 13:16:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3280E1403B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:16:16 +0000 (UTC)
X-FDA: 85423642752.22.87F43B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6266480002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:16:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcvV3dLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794420974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W5Kck5YNf4KPNvVOCAM53kpmBQSPtv2CXzpfW0fAD8g=;
	b=Cpd6BftyW0Gc+MjGkg5nZJkUl8/SRhenoUyWZE9Jrfnxlw4iElfPEmODQ72OYJrKswfYLs
	IxbhUPJowY7vd6zZh0Ri8f4niXRq5z8O/j20MG8cll4wJT2ag3YQfPhFq1Xk19uykwvIcw
	woQFuCfqnUOxq2TtywMGeiiaMiwCtpM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZcvV3dLs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794420974;
	b=zM/1B9/6fTZO+EevLN2E7tMMyHMpAqwYCW1Qwpq37dHxppdGhzQP1SEGQzVMWOWfEpf5tA
	YF28LBrGe4wsu5RT3qHpwi2mRmAO22bGH+ssdJfKBHjxDo19qu31hEICBSaLETlFyufHVp
	R4wWwSgy4YErQEcsFKf7dn3wnv67BaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F328562C78;
	Wed, 11 Nov 2026 18:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD2B1F00A06;
	Wed, 11 Nov 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794420973;
	bh=W5Kck5YNf4KPNvVOCAM53kpmBQSPtv2CXzpfW0fAD8g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZcvV3dLsSQCPwYRfwfBoW9wgX+tlTKex0lW6/HkaY7UnfPnnj+6kUKMoD5rFcH2bF
	 xP4P67afZJe9pNORZivFELHciaf7tS2Z2TASh9kQDaYY3gDDva/rFJuk+i02Opp1O/
	 nkkIe2J5MmM35zITdLFLEyxWMSvV/NWY99d7kFrCEAfsLyaxvvmi63S0WTMgZwO8UR
	 7MBllNME2pvpSio2/CLGLC0oheSYfAeYEP1D4FrbfKa8/l7u0VD+BukRrPvryjEYKX
	 tHojfGafL1MrUubKAKZgcS383wZJ0qPuCx1gpNeAOLbT1hMzTfoshn4tljEaDTpNy4
	 v32YuTt84iVTA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 11 Nov 2026 18:13:27 +0000
Subject: [PATCH 13/13] percpu: queue the balance work on an unbound
 workqueue
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261111-mason-migrate-et-al-fixes-v1-13-3d2454362e8d@kernel.org>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2070; i=ljs@kernel.org;
 h=from:subject:message-id; bh=BxMz+HNaCub+x4LAfh02Pe+wON0sxJRzEGhBuO9wXJM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK+bMg5NH1VhvAmlnkvc+v1WVSan1o9aPq3hkM+e+XDo
 Ccd/6696ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEpOoZ/meIdTzfcvoJ7xa/
 f/vVvXh+J09bviTWneX55UMKIU4OdcsZGf4yL71fdMNv4dzKrcFxRfs8prTH1vzby6feJ/pmS+F
 XPxYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6266480002
X-Stat-Signature: apriupr1wsdye4o8t763o8751yqkqbfu
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794420974-763140
X-HE-Meta: U2FsdGVkX1/Cef0GTgvp+0Pb4zh0QDIQj7vOYGtfYeZZHy/9kzsaaX75DI6XLrDtOvBgLd2AYNDmtIo4VrH4S1sBAL4UQy0uuv/kD/HgZMlJUuQvRM4TdbG14VhkElNQixbi9vZlP0k+1WJ+cd/BRHDnjl7gAIfHyrptBY1h+WLUUeB1HQRkzxDd2juQmpCXWNSVFO/V6OBspf3DlRWsyWSmF0/bBKNTEoRMd0SCjGCOfRPYo+QV/dkYvb/mPp0OgD6q9pSNRqUzLNnCbbtx6f6aGj9xectvjev8OZnCJcqrvku+4CvxjhONea8QPQu3bx/0VH8AClG7IDsf8PGqsD9ECDF3jLGm1wK3SMCJ5wLBsFWRDxXSr3djw849iE8elso7/4nOXWGYAc0spDxoRfMqd5PLH9cGwwrivqIU8x/2TqKxmn4yC5H6kPyXJ/6ioz0+71MLsLfKOHHlKOnaT8KXih36xsK0oT2+mjPXmX81H2UUnMj2QrcAg4MU2vtzk7G72dFURimiOJLxsoDXTHG4lWsV/A6OI4xmE5UBICKof8SjLVgOcfLMeGJOqVMNWpm+fFKr32o7RHwlxUrH0VRKr/AITyLyxzFI7NHk9PvBDS/uPQtyoSyHnOkgabWCTIk2wuSPlE1WfA+bBSfDsyS3uYVZZDhHryo/jTSxKnFJmxaBvzUxzizdSQtvBr/d0DsP5lVdjcxi/rMw72IBDHujatkhg3uu+yLgzog91l44EdbTeUI0c7vbapXA0q8DHJKPJ9Ft5Xp8iaSX+9unjI8MWgo94dlB7hO+wdLlb+VeKGcnpkrA5h00CYUYaGWoKPMRdpjJXvLAhQNwndd4yaHe1sTswE8QpmkOsnTlGqEoFB1eA55FFbuAaa7TBz+9P90C1TymYrFkQXzwYfBXQHCysuiaEhqPJA6C0oUcYYCZIiowP283PTJ20prqEQPhd1X04V1xMchkjorB+AV
 cA1FYOhs
 ELNHVhoopKjjEmOnvCvQHCSxKiOQp1ghAogYHA3BKnoQp325MWsoPsWzVuAVAL4kVqnhxBdMFO3igI7Auok/SO3hI+CSp0hB3k/kUJHAQ2gxdYx0iYlkGD2WWKtyU/tk0ABhBH2pXrx8h3qAmg/MEd6RT1v3F7xoPV20lHOBNLhyD8e2CbvK5bRBEaz6OsWHYqJYeD7Csf2hDvqSXiiCwrMWHYkNH4RdaJCsCvDXpDRqZOKJzGtKdePzVEwsIJ0flsWo0Ht1yUOZXSYfPY31vJP60VxzPxIgiYEUmnmf5Iw3jDh9IbBeY7RfPux1KmSileJcS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A burst of small atomic per-CPU allocations can fail with -ENOMEM while the
machine has free memory and idle CPUs, as atomic per-CPU allocations are
only served from pages that are already populated, and those can be used up
before a worker gets to populate more.

Consider:

    caller on CPU 1                     kworker bound to CPU 1
    ===============                     ======================
    allocates 8 bytes, which leaves
    one empty page and 4088 bytes
      schedule_work()                   woken, waits for CPU 1
    allocates 8 bytes, 1023 times
    next allocation: "no space left"
    gives up CPU 1                      populates pages

The allocator keeps a few empty populated pages in reserve, and the work
item pcpu_balance_work refills them.

pcpu_alloc_noprof() queues the work item using schedule_work(), so only a
worker bound to the CPU of the caller can run the work item.

The issue is that the caller keeps that CPU - a task keeps it for the rest
of its time slice, and a softirq keeps it until the softirq ends.

In that time the caller can use up the reserve, resulting in an atomic
per-CPU allocation failing.

Fix the issue by queueing the work item on an unbound workqueue so that
another CPU can populate pages while the caller keeps allocating.

Fixes: 1a4d76076cda ("percpu: implement asynchronous chunk population")
Signed-off-by: Chris Mason <mason@kernel.org>
[ ljs: tweaked commit message, comment ]
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/percpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index f87813e6ad73..39cba1710383 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -200,8 +200,9 @@ static bool pcpu_atomic_alloc_failed;
 
 static void pcpu_schedule_balance_work(void)
 {
+	/* Unbound, so another CPU can populate pgs if caller keeps this one. */
 	if (pcpu_async_enabled)
-		schedule_work(&pcpu_balance_work);
+		queue_work(system_dfl_wq, &pcpu_balance_work);
 }
 
 /**

-- 
2.56.0


