Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 193D0CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 23:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 550726B008C; Wed, 20 May 2026 19:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5278F6B0092; Wed, 20 May 2026 19:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A21D6B0095; Wed, 20 May 2026 19:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29DBA6B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 19:50:59 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DF62BC10E2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:58 +0000 (UTC)
X-FDA: 84789446196.23.2D4F929
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4AA1D100003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:50:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqG8AojY;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779321057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aw33Msv3FojgQ5PJ/yDlSFo5ZWq8iJm1lg3DrSxILRI=;
	b=GUfnQXH+GPO2TJQHKTwDyp4rrW829OeJlkwFNmjVUymLARmZRPoliSOFOGGRxtwqBgvHTB
	wprZKqefL6fVJuOXYeAtDkisN/ENpwWdrtJCcGKYMc21KEO3DOF/pksw7EQwnu5Wd0Hisd
	O/TOfVt6DLq20F3elW8pnEPB9cJi7os=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779321057; a=rsa-sha256;
	cv=none;
	b=FSjeXvJ1uzwRaLju4sTZOFL54zG3ZD6bLrrS3ELEgBJwv5tmn2VwPTEcIxNHQfBo8YGJf8
	BNwIZnE/mE12Tp855usiOdcs4cx1douSZr0V1V3wVqS7eq5aQ1kWA/qesuAc2wfAbul0du
	BOIrTqsES0SafIJekq0SPssFetNBkjs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqG8AojY;
	spf=pass (imf14.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB9D460212;
	Wed, 20 May 2026 23:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B20F1F00A3B;
	Wed, 20 May 2026 23:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779321056;
	bh=aw33Msv3FojgQ5PJ/yDlSFo5ZWq8iJm1lg3DrSxILRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jqG8AojYZewGiX1VPBblXeH2xbBlmCgwhm2F9sG4b3VbkvEPFatCTKKt/Wv2NNsNS
	 RAWf8aClxV6wxK166QAMSqq5Wa8cFx9ZNwaXbOf0Zaxq1PiwmOcD587FFogsTZmWJX
	 ll3jQAiMX7Sxk6DdvZyYKCi9RF6MdpxgnHbB1vphmKzgoJheiscV6ugheU1ZrSQPsN
	 2T0G+6iV2O7H4vejiABwq/xNuResfnv67r198fWG3c9entRW8XZT0fzdNziQ6OVako
	 lMrY4wHGG4hzdyrI0sjndDSmOrycc/bK0tlNMpF98hrz2lMlG39HYEFQhb1m5ms+VN
	 FvAkbQ2ZO/RIg==
From: Tejun Heo <tj@kernel.org>
To: David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Date: Wed, 20 May 2026 13:50:47 -1000
Message-ID: <20260520235052.4180316-4-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520235052.4180316-1-tj@kernel.org>
References: <20260520235052.4180316-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AA1D100003
X-Stat-Signature: hcgmi5fu1nmccjk1xntyhn5a1pxcwsyy
X-Rspamd-Server: rspam06
X-HE-Tag: 1779321057-526018
X-HE-Meta: U2FsdGVkX1/LvcRStJYdLwTyUW9S+e5ukvR9CsT4cT0KfGPQjrBoxFlABmp8xqRzk0HM2zS3AhB7kIYiRgmqHjoOWe62/gbo5oPraQopHbVaumSkyyGFqSO65lp5jY4Gshd92om1MiJE8jj3sCjWC5N89rSRfUaAkZ6Hl/7LmGP/TCCib6+uB/KOz3Rnfx9sarJdI8IjJYE6chpl0AB45FczfF1Q5Qs+nPB+vmT6S0khzKnMWDeJLuZ+8QEg8P2ipGDSMWIfoGxI7eqRlxaW4pbpsyedeHaEcxuWlWX1x44u3ZosoXdQ1rynLyYygkdjMYNdpzVnWv9Zqif/iTJyAgjZa5NP5NwWnBJXjQp+Km/P5jXiwpAlRpoJLuku65GRyi1W784i00GGgiRy5UHD1Gem1/8pqs/XSY08PzGy5vKGYmgCH1JYymYJ2X8F2elQPxDZF2/1gLyuDm7DnyV4OadFg/bzpI+2Ux5CYvsXYm9zJY+0rV1ufEGFhIRvttrBsNqj2xmpA4p3ay9KrDPnSThTPJa261wpuKcaoncRCTfRgoOeksAmMdqjNYwj6AfqdDch8JtIajh+ADGFg0Ad2s4f/p1XSEwfE6Pio5sO+gR77fT0eLijtpXIt9gzXX+hLWMKeHlE+d6lVg1E5npeYqxR4hoNxVaHeshOsy4re/3li/HeQzyrgIUtHuaxc5V4CiV9w32eJuy2AQ8DzO7YGzr8i2ht7W/QMXkQ9+MqTqVtilu7jtUJPsad8r/0EWcOBN6uGgiR0GuQYj484Ar2YRlXu79FlmZyX+lChD3TUIa9FHBjU0RaaDQ/nr+p+fxsje33nvzC07mHe+13buszLMl8J/aVIVPowwvdDwJWFmTx7X+c0GFjRhbzQXyZOZMSvrjtOfDYpgOkHOm19sBFl8B1avxMrq+tu5TlmAdzp7tDpPQtJFnVhV4nEh9g0uLSRXTCKaLkC9YguqFksNr
 y4W4qO8a
 eQAXFPxqv5ky+kTi69TDGDkOUQnRKKWK2noq2HI0b9CyZNhvSkmwXfAPCnMbT9HKEPsT7zrt+wwNvFZSAre7O+SW8H/KwBP17BlQckQvP4GelzZH3F6qtXiguBGK1fU7H/g63TlICVBO5PWUXNzgGEukWETwCP7f/04hE8OpOxavhlpo02sVNR8EFFcbJBw7Jrc8NtGT9gf8bsjcuis+9O2v8sPTnK7BVI5eAxeOi9DGp9pb/RZtw8SgFlDUDLcb/BlWWR6MtV3gpYLkBCPbg6QXzzkrTpPvNOQuZ2Icy3cU8kcUn5kyl68xgvCqSEoV7xsW7
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
index 1c0b87ecc817..a811cf6170fa 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -934,6 +934,19 @@ void *bpf_arena_alloc_pages_non_sleepable(void *p__map, void *addr__ign, u32 pag
 
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


