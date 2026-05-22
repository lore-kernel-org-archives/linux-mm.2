Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65FEECD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:22:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349146B00B8; Fri, 22 May 2026 13:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281FC6B00B5; Fri, 22 May 2026 13:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176916B00B1; Fri, 22 May 2026 13:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02F206B00B1
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:22:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 440DAC332B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:26 +0000 (UTC)
X-FDA: 84795724692.04.B2F4DCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 916C2C0007
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:22:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X8XKFMuw;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779470544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYTgH2xtVYKFN0341M351MazQSuqnbXnfu3i4Yl+9Pw=;
	b=hehuq51DdzB2qXCxhoApNoP6E2cfIXkhm3UT6uVJMx441du4q4HMcsKCAwDJSRYLgdj/ai
	kSeVTuJTjJ5kjafUXE23UPiWtfiW7yIuDDLFyxDEQzSQaC7jqXBlJHcxkhkpFG5sbkILD8
	uWdC5fYWdO573rWtzsPqupMxksVD1NU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779470544; a=rsa-sha256;
	cv=none;
	b=cS5Bb/c+kXphwdgIl5bzxpXv7vnc/jOROEkngFhW8P9ngoUwUECeP/1hJ0DBVMpzA7Ig6t
	dhTmdFKfyvqPh05I5TP49OHUNve2XCXQLlqlqlbI4nfza90gmotpEYoBG1eDfYSC0DTr1p
	ZOMFmIN+W2U1DrTgRmvo3P/JLeQSI/w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X8XKFMuw;
	spf=pass (imf28.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DC3740DA3;
	Fri, 22 May 2026 17:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19CB61F00A3F;
	Fri, 22 May 2026 17:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779470543;
	bh=VYTgH2xtVYKFN0341M351MazQSuqnbXnfu3i4Yl+9Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X8XKFMuwjEr4wId3sNSvzIMlmB6jWIHHlCuAdoSuTyQ7faKiaUWIVv9wkDoKCvn2l
	 i+p/yJC3VT96PiU4F1h7mS9Yrrj05R3SgmfwqK4h28RW+5boMfKiFf0HV8q7KJML4+
	 4cFjQcBw9Iqrbp2WdNGYNDi6TyzspRrUvroNGH6jodxa99h1O5JouDL2VZB6mJaT6y
	 7AhmoezrI2Ss07m+XtqFePlNk+tXJXgqRceRdUW+NStFczPoN/FzKJv1/hvskf5mIs
	 N1gSiWUbsG2JdifBzUcnX2lGtFuAXkzrv+7uGTDTgpoIsugAocGreRP1Pfoj2aJG6c
	 Q2DlK/UjH9hIg==
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
Date: Fri, 22 May 2026 07:22:14 -1000
Message-ID: <20260522172219.1423324-4-tj@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260522172219.1423324-1-tj@kernel.org>
References: <20260522172219.1423324-1-tj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 916C2C0007
X-Stat-Signature: m9tkrotftwf3nszi8fejxykrwsq1ashx
X-Rspamd-Server: rspam06
X-HE-Tag: 1779470544-332812
X-HE-Meta: U2FsdGVkX18ft4BDycWYglNdm5cpH/EqvNItnRhxOvH8wtEa4+DXMz8cRYij4Z2eI4J21F+6R1plOZgD8wimwLZEPsj1BZjfU5hMA2MarcPm9LfVG6Po4hJWHMsan80PFBc2XKNoZVFk3OUmpFlrOJfn05lxiwdiVtfan+JSv19DjqRMyDfS11tYuLfL+Ah7w65F4MshUFKFur2F9/aoSX41dTwylLrHcPiZNmBE3RBxA+V+dNtCyqBuGWvf23dtZMD9RMjq1zDvBsQbGjqAWYlc3IVbAaCRh3+zr8CYC0QR+kt0I1pGuLnT1cpHfKjltZE8UbXe60V1Ahgffhpe1CAiIJdo1TnuLDlGG7G2+ZFWF3FFwmvkrcFRKg9MQNX1Il9QWFtaOOdAbNSOhwxBR9fSYqHnWu+RyUhKQ3ibEq6WBNGtyfJmvem8O8UFRDPSTqMGpeP0nFN39KIXmyJTA/ZmkFhxvsMWy6tQHNBHI+uO8JiB3TKwH1WpOhPBE4jXjytvQ9/RY6cQCWqmNDK8ccXDEr6Q9c3jYi1W1hEZxgu+Y5xafghbH+eweXsxXi9t7nHJ1JMkznsRJ2lUv80+nNMzVFx+EPvNk5U/TaNAJfm9PbFxTyE3MJKlkpRt32a9MR+qwZTyKlX42Nx1qogwBbLYwT+sXQVArjjPgYidckKnPeYv4DJd4OYPsuFeKDENYwCz/Vz8fI9ND49y3hvSyTqdK7YVvWLpdHFBGj2gLS7Q5xSzYVXFC0Sw8Cfu1/r28VKB0oFeLAtYGWI27ukSIROV7otOxtUfwDy0A1t4DBnJ+OSA0hK96bC4mOKSXelJyC1a0u5mkzPWdam0x9nxpl3EUCrFMTFFTZuPW44gtSlijzpe9GQzDFIiVRl9emx0n+VPLFggM/+K4liVx5y4WXUaFH79tIL7dtapgiAd09bJWh93a4QictfafVH2YvRnPWS0jQ0AZqcPAAD8Inp
 qrN6RMbn
 qcBPD8kx5C965iOVkcaQiHhRAHe2NTDn/sL+RPMNGWpEifLHbjVKyDQ12yYqkSitk7uFn3YwkZGTYkW00xaGW9APOr11lhPv4fZZUm01PxlbACg9IEam5WQAyb7C44oCOf/dAglv66DiSI8Cw0TZAwSTGY49zgaqUJDgNrtlgGDMxDQ+wXCVdZUL35V2yJ58/vq0rUrlCzZwUUFg54E5m7yP4bncoA98QNrhBGzhTpmWsld2iP4Z/wiB+L6MYWd6evxJ7A3hQ6NXzJcslhSbdNBAYYZtR1Uh94f4OJCFztSwjMkwZ33xcTYhGhzfMZSPGrhG8Nbjw7HdWq1NAHCwd8Jv7GeU17xUsRIYRtnzMFLKCUUlz0LKMEaKj/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing kernel-side export of bpf_arena_alloc_pages is _non_sleepable
only - it's used by the verifier to inline the kfunc when the call site is
non-sleepable. There is no sleepable equivalent for kernel callers. The
kfunc bpf_arena_alloc_pages itself is BPF-only.

sched_ext needs sleepable kernel-side allocs for its arena pool init/grow
paths. Add bpf_arena_alloc_pages_sleepable() mirroring the _non_sleepable
wrapper but passing sleepable=true to arena_alloc_pages().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
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


