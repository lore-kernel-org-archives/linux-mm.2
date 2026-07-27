Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 867EEC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 13:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9206B00E8; Mon, 27 Jul 2026 09:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859796B00EA; Mon, 27 Jul 2026 09:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7475D6B00EB; Mon, 27 Jul 2026 09:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7D36B00E8
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:50:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB2AD140752
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:50:36 +0000 (UTC)
X-FDA: 85034691672.23.CC1F6D2
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 05B4720008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:50:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=m5QDCRHM;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785160235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+6V3TdS0YDSjUJhRfZObdautWIi5ma3BndxnY6cBifE=;
	b=kBX3Sy1NILR56Gv7IeYKXXOsAJzhf3D3RF1LSGlJ0JnyqPMKWqz3/GHrO89YHH8LsRVepy
	/fj+Oav5dbWZceQKRH1aeqbFGk4BdsU3D+gizerkcRRkg6aXOo3PT3LS6OgWRH9pti0DrY
	xhDsphHFO7PjFbyqLVgjG6+I65dnar8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785160235;
	b=kV6F722lfn7cRULIvO9BCncf997Af7yZpAdeEs6U08SmE4bFZZooIPc5Q/hYIkCISjJqYP
	GcDosW3NF8p69K9HN+uFoTLf0Po/1fajq1T9fN9h2iYMFnVNIujjETGD+6z5KbLLjcIibj
	jy7DANY1ikYsR0Ja8Wmie2kga0Sdydg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=m5QDCRHM;
	spf=pass (imf31.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=+6V3TdS0YDSjUJhRfZObdautWIi5ma3BndxnY6cBifE=; b=m5QDCRHMeWDFpZJSbFbV/Tqw6F
	jXnu+vOBupe8oScOnAMlxHUqgZpBcfzSMFZpsowaIGv9NLN5aA2EaTLteok62WRKetJAvCZZukuDa
	bA7sbBtojBOGIk1wgw9y97kaBHUKw93itPnJI1f9qwPt5IFJxtOmAKj6Wmwy49RD8NA5Vvr8T52gq
	Gry4NnhcYz7+ECrY82JETtJH9HCnXvBm4gHVnuLm2aVG0wcoU00y4IzFt4MIZTGdu3xXvhbzRmpTt
	6TJfSz+5iUKt0RHh32aLOHhC/zAfLuvzzJNKpW7Rw1lTe73KcMZqc9/19ssdnnhJHTQ/isLRraeiW
	Jn+6/HBg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1woLiq-006wTB-1J;
	Mon, 27 Jul 2026 13:50:25 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 27 Jul 2026 06:50:19 -0700
Subject: [PATCH] mm/migrate: report RCU-tasks quiescent states in
 migrate_pages_batch()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
X-B4-Tracking: v=1; b=H4sIABpiZ2oC/x3MUQqAIBAFwKss7zthEyzwKtFH2VpLZKERQXT3o
 DnAPCiSVQo8PchyadE9wVNdEcIypFmMTvAEy7bh1rZmDft2DOE0MbJzHAPLOKIiHFmi3n/V9e/
 7ATNfINhaAAAA
X-Change-ID: 20260727-kcompact-ff0550fc0ebb
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, paulmck@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=2086; i=leitao@debian.org;
 h=from:subject:message-id; bh=4F8yLxC+1awu82XnfTaO7vCW1QjPo6xO5LUWzXQAoIs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqZ2Ict8M+uRryQAOiTXZWQuoTGZCqac/XH429v
 vfWLwbJ3D6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamdiHAAKCRA1o5Of/Hh3
 bVJgEACns/hBBLj1C0xnU4aeQ4PXCGgCyJM9z29He1siJFODaAKsUB/bxBNbE510LyRIKTloTVW
 01XjgrVJxlg+srXTP8FK9O/G/rwFDDt3uSohuG/jTN8J/sA4Cm6tqZuROe3tG89TN4DAgVc6n2/
 I+iq/LM0CCiMQ/8LJ4O91+aOElQSAeADWUC6pJiF+8G/zU1dObu/fP2Bd7F4NLBIqZvNbqnlqYG
 oLqaIQkzFa/lZrBejbJV1GKmSt7wrFhkzG6ajtIOoEGR6J/tVTxO6+iq1l13P531qz+31UGzdhC
 JXTjisDasNwB6BKPLwDe6zt9qvJ/Zjx0LY5dtDhgP7lfavom6vKYmpC4SuVliyeb/IGwN7pgWj1
 Sbo2DkD2EL3DytrLseKnlK43SrcFNAyI1SPoqg6WWje388LW20fKcqRswo7FNla1oBRN/1JpjMq
 Os8Az6SiYM5j5MVbWMpL+2cV4fX1DmmRWVZRdjEQfRICMCezsfMJovzdSTlda+v8O+WLLlvygVy
 N1uI20WuB1ILAXkfoSE10N1H9x7eU5wwJgnwaMMtLaMFYhP1wLymvQ3h333nAQ+cHmrwiKj1Nw9
 JscKdBzmmg5HKfUlzDIX+Ng5wI4X6z4bkm1tmTP7nsh824Xg+dv/ShoVtIO10SgG16yibGUfobF
 MOz8rbFF6/Bq4Cg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 05B4720008
X-Stat-Signature: 86uznc8syjptm5xww7b1bqtjs346ji9i
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785160234-30962
X-HE-Meta: U2FsdGVkX19lFtHEbV+PxD2lHbNkgWZiTS2n7/Bk1tvitkcZPuwEoNFHDwFf2EnfheqEg6jxpT1N6gY0ExtiUbaSV6AKxeGQDtaRY3RcR2q7XXITon6FSyZbG+s0LcFeyPHa74SqFypsBEEAAK9bxD0RHGHATYDFWS5BDoyXU70splZ5eQk85Le3m3ci2i0HPGUAIpQln+8BWH7JxOjbJ1SUsm4Fm/+fMYG4aTwl60U3bC1hKJeEtWkS60bWxqywzJ6viIRN3bL4+jwXcdhSD0+F7woT41E8U6tmFt2OhNQMjAsymYM7IRde0FY0mbxb9gNFNWy/eDlHhjJFq1rfjKG1v1JGOU0+6L4GW7fMixOlWPLo1cXCb0/TuMw/Apo0QE5Kfie98KniUWeocCPycI3lyLMumRxnZCBAD/zusbvohGcp4o6EuA/xOlnV58uexKGcIjGe5gkW2I5/3u6ZjfxJCIiYL7t0/OQvtkPcv1fcs/+Qs5tYJfXogryCMTpWZAurFbxw9rUQFX/D7u+HqEWM3YxUh7xQUxq+qQ1OzkTJxniOqQTnYhv5zQIJwOY3XYCPA7GQf9l2apzUTblTUyWzZ44trAp5iWWO28SMC+6WVKEJW4GmK9sGe+WvPaC692TBPggqjZhN4rYScjBSdkkSfCcy7Bfso3AGnqqVJYGk6qKYgEEUjfWnwrWlb9LYeRjqw5QttYIduEvJdW76ENADXtjFs01YUg+pG0nvnXEDwlP7eKo9Ds53vo4oreIY8NcLO5SEAnqxNq1pbMBG2PmgEV0jX3OfY0jWWoyijldVJadbBTY3TykQWENNC8+uu1opj/tUnQV2Q+HZSAppEu6E6tC+MNsWFUAipchU87DYy3ytEcXEz/zEifVGUvWOn3kN0rq9N7Nzjk//TJ6LLQjHIKX3pZUOVNLgZfapOFs96WnQnq52YyJzJ2J2NqzaUQ6y5CaHh9qcwg/iciL
 zkMBKRer
 6/hCyoSY2bvRw8qKHGk70RcdhNiOWkFaJR4CxRooRoq0Rr2LtirK6pdwXW4vLVpduo29TPF0rVYHBcoy5aGml1QDcpA88Q1SRl3QVlcXnKktNj99CKV1DFEdzA1i3YpyZSDkWQhD1qyZf8Y481IRYp3y8aMSO+BsyISyypj+UEYDxG5qiq6dJNiwVbPpGkrnXv2diIXmSB7OXZdcJTF9socU9WD4C+jetLm9oMLTbEwx1/onf1/4y5p4RFcFsuxA7bhjSQ/PqMHm1+iGSAsjZWT5jz0r0B6zk7Y1Z5DbpCOh41yuXcnmb5ok/1b+Vq9D435zt70hsLq4ao3DORQPdjw83QJNonSComz0zSPHdFJNOy8Act9RPIyKDq0195EO1cAaBPKGUY86ga8DebxwlapOwn4KnRE/6sOnlRyhBMzYeyIJIEzJysjZk/ia1hVNpmwG2VkMe2nTD7aM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_pages_batch() unmaps each folio before moving it, and every
unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch keeps
the CPU busy for a long time.

The loop already calls cond_resched(), but on PREEMPTION kernels that is
a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.

A long batch therefore never reports a quiescent state, and the
migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling the
Tasks-RCU grace period for minutes, which is common at Meta fleet:

  INFO: rcu_tasks detected stalls on tasks:
  0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/56 task:kcompactd0      state:R  running task
  Call Trace:
   tdp_mmu_zap_leafs
   tdp_mmu_next_root
   gfn_to_pfn_cache_invalidate_start
   kvm_mmu_notifier_invalidate_range_start
   __mmu_notifier_invalidate_range_start
   try_to_migrate_one
   try_to_migrate
   migrate_pages_batch
   migrate_pages
   compact_zone
   compact_node
   kcompactd
   kthread

Use cond_resched_tasks_rcu_qs() so a quiescent state is reported even
when cond_resched() does nothing.

PS: This has also been discussed at [1]

Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ab15a4dddd047..b937cbd764808 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1843,7 +1843,7 @@ static int migrate_pages_batch(struct list_head *from,
 			is_thp = folio_test_pmd_mappable(folio);
 			nr_pages = folio_nr_pages(folio);
 
-			cond_resched();
+			cond_resched_tasks_rcu_qs();
 
 			/*
 			 * The rare folio on the deferred split list should

---
base-commit: c5e32e86ca02b003f86e095d379b38148999293d
change-id: 20260727-kcompact-ff0550fc0ebb

Best regards,
--  
Breno Leitao <leitao@debian.org>


