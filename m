Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46ABF606A338
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 15:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=oXy4o77N
Received: by kanga.kvack.org (Postfix)
	id CE3D56B05CC; Tue, 10 Nov 2026 10:05:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C94E56B05CD; Tue, 10 Nov 2026 10:05:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA836B05CE; Tue, 10 Nov 2026 10:05:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 97E6C6B05CC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 10:05:12 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2E2A31608E1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:12 +0000 (UTC)
X-FDA: 85419532464.30.40CA0D1
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5250440007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:05:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oXy4o77N;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794323110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2e1bpjGT+eR4C4dYYlQalUYG3DRy3QidLDmMcITtjh4=;
	b=3m7qc6uF8AbpfsJH+YW4VNkHqmdpcl7CDqSaUx5rXSiqI9FOdnEQ6t7c2bgM5AXuBYq3Ro
	VM34pNmA9ZJzWZjjhpmw11hic7P96FzX8cUZrv09yWOrsp7OsWMmm6HDlBpykdh0mMojCU
	0Jl5jWYJLsZ9XyRtwwOoTgrJQ/ZJPKc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794323110;
	b=ec2UnJoTlnpHynzRTSO0TvREwibTmikConOwvGzXY3e/YBgvEgnEt4S8rWJFknXs1/uM1o
	KR26CmLMYOrPUGrHvmoC2JuolTE2y63ltFMG7yZdx8zCvSaQrGF0uPJY7k9HA8arFeHvQx
	vaDn1Vr5OR8m3bBLHFX37olNBjxmoMM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=oXy4o77N;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91ec08f71daso16144686d6.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794323109; x=1794927909; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2e1bpjGT+eR4C4dYYlQalUYG3DRy3QidLDmMcITtjh4=;
        b=oXy4o77NlN/9vVmhMj/iUg9erUctJ/eimLV686JWgpi/A97I28Y3GRkIpZkMagDBTs
         gyL3siQdfNVUHAbvzm8vI1jy6Q0D8qrVR9yK+65CuQV31kQnJCcglaptApGzUxYESDX7
         Ycnr3IHLejCcuqTk6KgYQGSOjJGwC+mvvSG5Af0CO7oX+YnnNYQ774gXPdE8qSDZH5s8
         uNC+R+LF0p4HY6YrZg0vTKknlT15jfrqeua+SjLJtzUzOuhXjxYEZt4ZXBqVxaf/dMng
         2E/mDVzGDpMe2E97ZvnIEo7623GADioQwtm4y9bZa9o9OqdaqauoqNNY+GXUDTtOkB1Q
         0V8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794323109; x=1794927909;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2e1bpjGT+eR4C4dYYlQalUYG3DRy3QidLDmMcITtjh4=;
        b=uk2nHwMjB/WKf2nZ66Rshmjw0LjAN7AGkf6aXc+1kf0eE1LGz2/kUDPohQ2mmHz/8F
         V3VWm+4uDvU6JSzsqHYOTTO+7/b1ZQeJaUauBHV7VrsY1dldvJSC/XPgopdtm6kmAVdB
         3uxlk7Wvu3uEJKDDS2uHRPGH2oIJqVmbxYkr4xkLIserTQ5mll1+0TMMx+1fRZ6HN02t
         W/VxIDbSCg2MSjOKz59GFgBdgbfMOR6gBZIStkZHYuJ1aHPUzGpY1OeBEoBkLS4hIZsH
         vDtFMcJiDIke/MZie+2YNf6GgAmWLlfUB2+lEab3Gg6ivlbe7LWyiGtLJOPUJwj2gq/v
         4+eg==
X-Gm-Message-State: APuU4Z/1a0CeP5zbhqwEwgw3F4bV+v3kaqfYG4Oo2byjsAoO6LRsLr70
	CqBfaOLD4Wptg6iO/l9rLVgmBA+Nag5mzqx7S2UlC5ub6gdGflYJLmzJv4Agj6nMNg9FpsfSCsN
	hlvKT
X-Gm-Gg: AYBFou0QwdCUCWJhVAwNePfMnKvVDCr+sowtveAJCzJSDmMwvAEiOr7a+uLaJm3t3bu
	7T7KoRcWLjUUYUBTAl82jifFrEGxMDKXy6pLxHbAzabkNGJ68XrE9vebV23nOaMW6VRezi0h36t
	V4+yryB/xJdVBwfPKq6o8sdhbSDJjuH6ayv66opoy+dKo4D9Dw5JDPf0r9xBIANY6nZHycO9Ema
	OKlWuOPnPlvjcmIFMdAkZ11bl93T3mRS9KKVjm/nO02REAdMdkSeoLRNuLZqFXc2kkJcHR7mN3F
	G9Phfe4h06LZPKB/ePiPYBlxYbfYj1wrHhjmaZIUiZpjADUTrdC/Yrc1c8jQ2ngoCKi2UbUue0O
	UVBfs+Lzs2g4U76t96BX+esreoPgqgOHr/3o8R1Dq3eTXMwr84p+tOQsERVkOta2cizyCwkSS1U
	xLEGVhEmznnFHhGSj07TBSVVM/AsTDOxwX8qt3TPK+5pDHfGgoJwgNTl2Q22kUTTNEC0VhyNnSp
	vZbQphiZvLp/7TYupTaKrxIAPynW3Q2nC9FOouUPo9yQ693nkkbCEiCMzYZPixjBBxoVS998qLn
	C5aZayGvzURe11mYWOXQgPp8C7PWXruBGUTvfTVZ7cXi793FTo/emmbhuhni56LvlQyrmqfw06R
	WHQZ4Msr9HVoOBa4=
X-Received: by 2002:a05:6214:1d0c:b0:91e:b7fd:b35f with SMTP id 6a1803df08f44-91eef8e19d0mr48737926d6.30.1794323109417;
        Tue, 10 Nov 2026 07:05:09 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91ef031c7dasm22902406d6.1.2026.11.10.07.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 07:05:08 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
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
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@techsingularity.net,
	mingo@kernel.org,
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
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	osalvador@suse.de,
	raghavendra.kt@amd.com
Subject: [PATCH v5 7/7] mm: use VMA flag helpers in NUMA balancing
Date: Tue, 10 Nov 2026 10:04:46 -0500
Message-ID: <20261110150446.2452975-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110150446.2452975-1-gourry@gourry.net>
References: <20261110150446.2452975-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: ug943cn44idyfhm9b4ugopxbbou6uctd
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5250440007
X-Rspam-User: 
X-HE-Tag: 1794323110-363557
X-HE-Meta: U2FsdGVkX1+ENxIS9BMear9HtCt0kWex6B9zYpItDzYRmnzZgY8BBSYOfij1jFWEfju8tatcguqc1nEAYaf/5hVL8M6WTdR2Bu+lOVICy5I41O7uPphX8BYJK2+DJqZV9RdFWCsocKcC/3o1kAtc7EnuwkTTqknupGE3qulcqLiOlurRHk0OQOKdOLJTFA8PgApRZEM/h/7ArZYeerdjai73w38Nr4BL+d1vVQTRG2ROp9th8FBOKGa+zITgB7S0t3iEj38gDl/mxSEN3kIKx6w73ZpIAQ9nsj+tDEMfi0qeQjRL1a9no73SB6j7CRSrWO5cHcA8NHTXFPuLfIw0loPebpHThXQNXT/MgPgUm9G/Z/Hq6/VBe7mJV+LiBBNSuxhIZaKzvFC4A1DX7rsSpDGqrqXyS091RNm4JJ29v5B1bYx5ZwkEz4fnirpcsnm2UQsbQiPteMtkx9v53D3pQGR8UPz6zYcum1Qs2f7h8GrrhJjEgKm/lB8iuz2SzcWX7oTQ3moheW/WUiSrWkRXDpiuZEk+MsHKU+nqr2p4allMI5E0fQGxaMAa1qsO6p8qoC47Yld4rNORFlX/LY0oJoVgH+okkBeiWQd4vCffiu7vTLnxi4n3i7Ln9uOoWQid02/Ytvck91WCysmIuX1vZ9Jad3fqgRnqccDj1CoSoJSMI5S0wIY9yiGKzduCNS3puFwVkB//XPoj8sm3Rm8cJ3YsgOPvsZB0YsxATl790Lu0N9Cf8ry6j+61UtfQhUeRXc3JqmGm8gRJaEa8uxe+lO4mrdAVeiC+lLjaVTOxi0YzgVwy6LMZRmwVzANyM8YQDunPPXe1QZdYtyozxVVqm9dnCivIHHbzcGqA4YBVn6bsxq7eMcrdUo+O32H7n3xRkrmk00XBAbJn6zUnNrP7RZxM/TP9b/a7HtF8gyuXIj3DU+Cq5GJsklvb2DGhMn7sxUTi/yA4JtIXTBeARre
 daqApzI+
 SKOOrfge6FLnL8qAKkOoXz1AZbeK6SNSC7Rs8UJCPFjZgPa4bhm/K9Ih5ZfdVBULkw273ojAfQEuRvQtAIi+F3EfyxMplmiNlPOH6n9qrlXeXOzq3tGHU2IAoIc0gMqsn40IbbS2Y1PWtubo7USYdF4kII7ShaYuYF24ivuhYcsfSkbD3xSqgIqhCYM2jWqBFfon9q0AkxKTYUiF0NksrJc/mNxx1A3GmGB4SR71n7/e4nfFCJ9WiDvOjmusjIxO6v7DmJ0bNTyyUwOZNtMSmgWRW9WxYnB2tZdqtMwaoJ8B4VNc5BrTkCoFtPtuG1KcjEwObeohwynOou5iR9WT3/shTFdi4A8krLjrY8BLq2/yNAx4hcqNPbV7hv+DQBBazaBdVSlMaz8PJhc/wtKmhNm0ZMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Use vma_test() instead of accessing vm_flags directly in the NUMA
balancing code touched by the preceding fixes. Keep the existing flag
predicates unchanged.

No functional change intended.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Link: https://lore.kernel.org/r/aq1FDhy00epXXtgd@gremlin
Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 2 +-
 mm/internal.h       | 2 +-
 mm/migrate.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 279bf12b74b64..cf3e3657e9533 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4378,7 +4378,7 @@ static void task_numa_work(struct callback_head *work)
 		 */
 		placement_scan = balancing;
 		if (placement_scan && vma->vm_file) {
-			if ((vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ)
+			if (vma_test(vma, VMA_READ_BIT) && !vma_test(vma, VMA_WRITE_BIT))
 				placement_scan = false;
 		}
 
diff --git a/mm/internal.h b/mm/internal.h
index 6e7c247781a16..7fc34d084697e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1248,7 +1248,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return atomic_read(&vma->vm_mm->mm_users) == 1;
diff --git a/mm/migrate.c b/mm/migrate.c
index 50a0a2e11a353..796d98d1c116c 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2715,7 +2715,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio) &&
+		if (vma_test(vma, VMA_EXEC_BIT) && folio_maybe_mapped_shared(folio) &&
 		    (!folio_numab_promotable(folio) || !node_is_toptier(node)))
 			return -EACCES;
 
-- 
2.53.0-Meta


