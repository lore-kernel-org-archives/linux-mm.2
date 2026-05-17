Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26878CD4F3D
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 21:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEE306B0092; Sun, 17 May 2026 17:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC53D6B0093; Sun, 17 May 2026 17:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67E66B0095; Sun, 17 May 2026 17:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC016B0092
	for <linux-mm@kvack.org>; Sun, 17 May 2026 17:12:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4FC721C0559
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:39 +0000 (UTC)
X-FDA: 84778160838.17.64063D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91177100009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 21:12:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1gJ4IlN;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779052357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tQEPRQOZ4rX+g6q3gTj6TNuvogG0oRapFFGY9eXkr/U=;
	b=3gYnon8xW3I2o7J45X0Y3hfsE1CPYMGrQPM2NrPh/7N/eUkmpqGzPODC/xgp4r7IgkwBw/
	3/jkWckgRYRgtpsbWcahCI5wDUMMXySosrNH6UP4mT52Slvx+wjKc/hcDvb+04RZTuSGz9
	DoSEdilP44/1oE14Ud+Dzx9+BPHGDK0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a1gJ4IlN;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779052357; a=rsa-sha256;
	cv=none;
	b=xAPrhJcP/I3hC1X0x96CzfJ+EGCJpBCGznaRy/TnAN+zQHRAWHeyTrMj285X+sj6XfnCXR
	CcIkezhOj3J7/XS4yuvCDQ94OQb5B3vEHM+rrzyCgvTmXJSqla7InXbsfgr/twI8qCE27A
	yJ6wMZxKs/6ThgIR3S4PriDNlAx9UVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A6797445DA;
	Sun, 17 May 2026 21:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AFDC2BCB0;
	Sun, 17 May 2026 21:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779052356;
	bh=sa/XEbVus3j3++neSqYHZhHciwIeY/dNrzAJDzxWUxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1gJ4IlNi4iOIT2mipUyACyecpQa+uIf+XnT7/qQ4vdyxGJ11zcsS17cyZrSj4rPO
	 6vfRZSw9RGeGwRCtlQljfXggM8dW45kuClZyEO+q9fpICwzamys3W1B05zYSgw6TA7
	 MexHFPn5D0tfyYajRXoFzEoZXB4AAyIcRDXUnd1fQZYM6pP/deUCVD/POZ7V2qnzWI
	 kvX0WgD81ybgApTydEkfXU70mtFxID4K6WOQM1hO0AtlHaDYw+mA7+EUbsqMzLA/9O
	 YCdzvRV6dfQfuAMgsBZr9b46TqC4AHRrwtYakUSDz0io38O+mX4zIKHTZRLcrBKnrp
	 yaQ7A8/Nqj86w==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/8] bpf: Add sleepable variant of bpf_arena_alloc_pages for kernel callers
Date: Sun, 17 May 2026 11:12:27 -1000
Message-ID: <20260517211232.1670594-4-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260517211232.1670594-1-tj@kernel.org>
References: <20260517211232.1670594-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91177100009
X-Stat-Signature: dteu5m8ebt4kjprkbpbgu7eckokk7xet
X-HE-Tag: 1779052357-809699
X-HE-Meta: U2FsdGVkX1/+Ty0t9DEY+ALJ/WSxw2a01IUb36ObEfGYP3h/Eg8Lo6tFf3PlfM90MHbe6QYUUcOYN/edLSVEowzINrGh2zv7arGiFiniqA57sdQTyZZRViazbEKesL68rtcdkR3Y6hrbksRb+jx4LCz4MiihGZVegpuTxn4KTta+/YW99eQp/GB9XMhTIJ1he7Rex4/YYQULE43xw2op8J9ki2CUam4JjQQE5VXVw5Ojn1xVxV+1MxSgzNwmt7tI53aZ9MLvRsKEI0vkpiZ+mwRfUv5egan1C5/wF3kSokosQLLb2ldWf2KDKTBn5x6QzukS9Ezvc2bRpUzePK1t9k9H7P8hR3eR1QJ34PmeLHFQWOs9NKm0zvt758G8Kk62aVuV5HyulAQTteYoCcIyxpOgFjO2Z2BJPLojdyQxuPKjShmz9WdQHYylaJqkaC91L40sNtTjUUTiEOEXyIZ3YqCk4fpk4i/52xL8xaAGw0eIGtxLpF6y6AppVg3TGyvWvF36L8Pmgiocm2vhk33ER8Ef8S0S0DE0blwdvKiu2SrySVJiLhFPxKHTPKCz/AQMB7YcA32i3PdXZKgR8J6aTz5NxOU24cYsvTMof3yE9haulnmr1oRmh3FW3zT4PuNpkGcz6TaS3oPF8Gz0sckHCsDoX7yJtjiJh3ECuSulF+bZOAob4s3uXUIIPtENxdtlWPIW8ykGfAMSyLlf6KOneb3lxiwN2uOoeanEfhNQve699vztOLHHf55iWmOE5mbTKa6MBGsZdBLIosbggylmGTYyA4Gnp2NrP0DzzbZyLnK9UKDviZQfSmU5+5W0n7xHW9Nq3AbTEeyJbDAriqcUU5T+vu5QnhCcl5decyYemJIC3QMLa4TTdMYRMTf0DayryJXlpBwKKqATNrJB6LFp9qJg+TRO56vsyI0OCyJhfDXCTzxr/eDE02bKtCiMe5zPN9+/zlSRvRfrRQjPBI0
 CUaK4EJD
 gIQjLO/WCupDyDaGjsnCUi7Dh4Z2od57JtoFJltd9UGPtsMOu+PTrnd9ib58PeuL90Tuf7nZPQVjPZ1AGTCpu3M1eP/NbuwLKBfGs4xV5zRrhQ5aUI3fD7VU7AaqQf9yYYmRx0MyKHywcVUEK6REE3mXq/5//Z0Itx+kbcHTNa2YENbq/Dlqr5Vykgjx+OdnshbAVQBAMwzzQxKSaNj/p+9C8OSWMYsFPnvNRpETOpJQFuw4i1nzJKlzfyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing kernel-side export of bpf_arena_alloc_pages is _non_sleepable
only - it's used by the verifier to inline the kfunc when the call site is
non-sleepable. There is no sleepable equivalent for kernel callers; the
kfunc bpf_arena_alloc_pages itself is BPF-only.

sched_ext needs sleepable kernel-side allocs for its arena pool init/grow
paths. Add bpf_arena_alloc_pages_sleepable() mirroring the _non_sleepable
wrapper but passing sleepable=true to arena_alloc_pages().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/bpf.h |  8 ++++++++
 kernel/bpf/arena.c  | 13 +++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 831996c411cf..64968ca6db51 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -679,6 +679,8 @@ int bpf_dynptr_from_file_sleepable(struct file *file, u32 flags,
 void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr__ign, u32 page_cnt, int node_id,
 					  u64 flags);
 void bpf_arena_free_pages_non_sleepable(void *p__map, void *ptr__ign, u32 page_cnt);
+void *bpf_arena_alloc_pages_sleepable(void *p__map, void *addr__ign, u32 page_cnt, int node_id,
+				      u64 flags);
 #else
 static inline void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr__ign, u32 page_cnt,
 							int node_id, u64 flags)
@@ -689,6 +691,12 @@ static inline void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr
 static inline void bpf_arena_free_pages_non_sleepable(void *p__map, void *ptr__ign, u32 page_cnt)
 {
 }
+
+static inline void *bpf_arena_alloc_pages_sleepable(void *p__map, void *addr__ign, u32 page_cnt,
+						    int node_id, u64 flags)
+{
+	return NULL;
+}
 #endif
 
 extern const struct bpf_map_ops bpf_map_offload_ops;
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index bc696bef7104..8eb7b95f4999 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -937,6 +937,19 @@ void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr__ign, u32 pag
 
 	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id, false);
 }
+
+void *bpf_arena_alloc_pages_sleepable(void *p__map, void *addr__ign, u32 page_cnt,
+				      int node_id, u64 flags)
+{
+	struct bpf_map *map = p__map;
+	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
+
+	if (map->map_type != BPF_MAP_TYPE_ARENA || flags || !page_cnt)
+		return NULL;
+
+	return (void *)arena_alloc_pages(arena, (long)addr__ign, page_cnt, node_id, true);
+}
+
 __bpf_kfunc void bpf_arena_free_pages(void *p__map, void *ptr__ign, u32 page_cnt)
 {
 	struct bpf_map *map = p__map;
-- 
2.54.0


