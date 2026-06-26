Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90648CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 10:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68C476B0106; Fri, 26 Jun 2026 06:27:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 663546B0108; Fri, 26 Jun 2026 06:27:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554846B0109; Fri, 26 Jun 2026 06:27:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30FBC6B0106
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:27:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8F948C3E7
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:27:36 +0000 (UTC)
X-FDA: 84921687312.15.ADC323F
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB4DE40007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:27:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782469655;
	b=01yQWIZlQXulO6yQGkChmkRPY/TiQKi79nmeXPYPIG69x/DgF7JEEU4eXEEwkGdHaJwMbv
	/9qac1GTLD2pb6++F/ai57fdMK6m5HCCL4Fd8LANxwvR0DljcFJ7wfNOeWn0o+OAb04h+T
	a7uY1Yaw1MYQlULDhRT08UPwqEGwx/M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782469655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TynSdaQ58qF5cmfO3ktCh6Cq7Zw5aN+HxMRTnMgeCjU=;
	b=H0ljFUS0s1eVslvecjDKB50IcSHnvZFOdqYe/Vy5Nnz/EP+IVkQLeg/7fnF4OEFOrwIGVo
	IhHTxn/zluMCtM6mmIlNi+DQ71wmVlDWPDHpaLVHS7tUpyIZ9cXygTBvB7MEiUg8gAtePi
	Oj7axQRoJ419j+bc+b0GQPhP7gzgtlA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr;
	dmarc=none
Received: by mail.gandi.net (Postfix) with ESMTPSA id 803FE3EB90;
	Fri, 26 Jun 2026 10:27:26 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: alexandre@ghiti.fr,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>,
	Barry Song <baohua@kernel.org>,
	Ben Segall <bsegall@google.com>,
	cgroups@vger.kernel.org,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Hildenbrand <david@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kairui Song <kasong@tencent.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Wei Xu <weixugc@google.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2 3/9] mm: percpu: fix obj_exts metadata charge size
Date: Fri, 26 Jun 2026 12:20:52 +0200
Message-ID: <20260626102358.1603618-4-alex@ghiti.fr>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260626102358.1603618-1-alex@ghiti.fr>
References: <20260626102358.1603618-1-alex@ghiti.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTGnYIDq9A11TftEatbke2wSLsM4U/RRnbCHpAUAIQBwHbVmowa+ke86M8Z6PPn5o7UKBvUMbr2gZWgcRiFc7ixLzqgLUvmoF1f6yq0GAxvM7ym0xa3n5f10aBqF/6aF0YuddnSkH5x50aCnRuJBlmRRybtyRnTHEtDjNABLsbF8/J37ko6Bm3zG+eW4NfAtWrkoIM0OVuVjH1i1R2t7kHuPQJtjQvB5ayDwVI8gcfE8wIDI8ctauyWpfQVDC9X4EX6LKQuBwn+BvrBeBO0dxg0WQvW3qtFakFlV8vs7Ehg02InoNEqwXY73y16xKIg4BKzVJqVRXZF2evXpKGHtjYSRICkDEkROcNVTsGp7+HvytOVWOvqCzJZvFqA9U0asoStphjFxrwjYHTun2FbrP2cY5CUFueIVGpmgGhZ4L+6TjIkJnmqViwrnMGDlAaLFCoLhoilHKmwbT9UclHSoartkKorY0R6ZvVd0TBVsbmy4Eu7EyEQeQd5BQDRpwJKKK2kecd0KDg1QZ9kzEiB2Rbnc5+Nu67xS7KN6EaDvdYpRj9ghoDeQBodD83HNzmpyh1O2Uz56gpM+Ngn5oGOk9F4GhWXeFH2ND/B/ChRfsdIrkV/6jsF0+Y4FG3t6PG7uxYaJYWTANQSlIGADiNiALI5UcEKUddASLwFeS02KeJDvIg
X-GND-State: clean
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB4DE40007
X-Stat-Signature: q1aq8ouj7yfrgrsw8ekqdsoi9gaitmiy
X-HE-Tag: 1782469654-220479
X-HE-Meta: U2FsdGVkX18ngYX4d3Da9U0NUHF8SKPY9BHhDsSMl16wnBIh0itLVZ1bDYYtOKNaovSmo19ZfsQNtBgRibvg8wIWN0KOacI0xAon/Oz7CjIy5ekz33FVHakQY0c+Jxu4Y+NRI9ph97bTRpDr/xh8bABSzY/iekEx1Zr17gynyX/nk1Om7N6uvfiTu6ogHzc5X+Y7eqpZvdlefbcBLr9U/YXxC1AlXQnnil/xeKevAUn5nCZJnxKaIZ7dO/YlqAunIFadoag8hQHKjMpY97tWas7MSyTqq1m7vAUxJEmXaVvTtny/m8TlwWT8VuPbb6B9KDaNkdcuLRe8rx3k6iXJWKAlyJW9YpGPuxeSew2arc1QvT0cVgQaaii2w/i//uKBU+XGopNLP6nmXFbmwRVv8vLmmGGTMZ4IA24g0nRPmLp85FQSZZ1l4GY2L8XMXMYVR/iVuYNri9XJwDxt/J4d6sQHoNBOD2qKFsSiCyZwIZIABQ/zmEEzJiS8jTR5U14WLkpQLz3zc82nNlUzZzCIGMgelaoE1f6qpr+xPflU5rpphQp4C4OPYIg3d3HAl8CbEIcs/i1VtyQS6aymIywmzUv12G13r8zoSd7tAuuXhNhWkc17D93NOQhhRSXgz4mlpFLKmfF9XmdHSq0VgkFqW1jxE/Mtlq2Ij83ogt+xscK1r5jmWt63elBCxrA3yejKbB0n83NnmNmj6F/U2CYabLjC/cnClLzydgWceKpgh5Nr8xcl5lU4Jn2D49BNMaTSkyNuXLdp64XVXevshv/LZOPWottsewjzIXHt4Lj5Svbi0c1FoBys1x1AhhU5UDvEt4uw7Pzdkp7TSWgedMCz6EKOzuBpEFxaHN2KbDXMTu7S3czQPqLVjU+MrnPetGcY5fdrIu83iRcm5sK2iVJTyeXPVKhTDFN8hQ4/+D/W2kghUOsimucp7Oggtpc2r4A/x3L34qIL1fcHeFvCvk/
 0xN2912u
 k8HbvHHYbgowuIi0h/qbS3B83rWaTc2aePlC5+xd4BX2ivF9RByDiLQKIOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pcpu_obj_full_size() uses sizeof(struct obj_cgroup *) to charge the size
of the percpu obj_exts metadata. But obj_exts is actually a vector of
struct pcpuobj_ext, whose size, when CONFIG_MEM_ALLOC_PROFILING is
enabled, is 16B and not 8B like sizeof(struct obj_cgroup *) currently
returns.

Fix that by using sizeof(struct pcpuobj_ext) instead.

Fixes: 8f30d2660a38 ("mm: percpu: introduce pcpuobj_ext")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---
 mm/percpu-internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
index 8cbe039bf847..d1c0a508710e 100644
--- a/mm/percpu-internal.h
+++ b/mm/percpu-internal.h
@@ -156,7 +156,7 @@ static inline size_t pcpu_obj_full_size(size_t size)
 
 #ifdef CONFIG_MEMCG
 	if (!mem_cgroup_kmem_disabled())
-		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct obj_cgroup *);
+		extra_size += size / PCPU_MIN_ALLOC_SIZE * sizeof(struct pcpuobj_ext);
 #endif
 
 	return size * num_possible_cpus() + extra_size;
-- 
2.54.0


