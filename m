Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBF9606A325
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJ+/FIiU
Received: by kanga.kvack.org (Postfix)
	id 6173B6B05B9; Mon,  9 Nov 2026 07:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1016B05BA; Mon,  9 Nov 2026 07:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DD3F6B05BB; Mon,  9 Nov 2026 07:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 27B3A6B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:05:20 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA9AB1A0691
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:18 +0000 (UTC)
X-FDA: 85415450316.05.C626630
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2D2A220007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:05:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iJ+/FIiU";
	spf=pass (imf03.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794225917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDLLbZHLdq5MhOPUl4urb8863fHk2vd7x0ssvKzjf2U=;
	b=AFz+mm+HE3JjncMHsLA5/m5vVhiuwL6xmhxiALMKKJzT6ObFdPUAFSMY8C404YfGYLodaW
	3LdKJu5g5nvY3OcMRh3JdHvLjboWJGFPYPfr5ngvoeJ35Z2BrfecymCia8mJ1LkR+I0C0c
	7yPz/9wf+wbWmGOJ9Sf/btW0YGAPosU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794225917;
	b=WGNap9t9z75uGNtfOjiM0RzTlYTk44LhluSdH2GkJ113dkIQfcCkMwLmFykNZuArh1QPNC
	KWggKxN7wWzi692x3Wq08h+zyXpAdl7QBgLVPfOyQE1mMJrk5T7TRh3o6X8oo8o34tdt8N
	L6zcGFGGd/9WLrt0gV1VSJY+XlGGdtg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="iJ+/FIiU";
	spf=pass (imf03.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C02DD63191;
	Mon,  9 Nov 2026 12:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971F71F0089F;
	Mon,  9 Nov 2026 12:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794225916;
	bh=jDLLbZHLdq5MhOPUl4urb8863fHk2vd7x0ssvKzjf2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJ+/FIiUC1g6XzTjLwnj6XGPzszrze3zAChLy/4ghxYUT53y7oXHv0nPTPwvAGDd5
	 Y2ML8NJnlrYt2lZp4bQfZ32ARA3YddcGThJGF730a17Jssq3jO9mf5T3rqeN5ruouD
	 I4htAztWuwFT3frhnZJXAnfuKlg4bXY90JL9XVxaHJj+vct0XNDnPI4zf3YtG1mpGn
	 zhPx7XO/S6IAh7yCPqhX+GbkiHC3HfeGAdTRO/v6xGl6kmktyB+jqDcv64t5YT/PlR
	 g1Ehsq3Zng0Wl69d6k0yGBCU4B2M4HwE6GcK7zfNgw2LbvPJwJf059sp8iyJorxEQA
	 mOubsFL9yiUBA==
From: Jisheng Zhang <jszhang@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Tejun Heo <tj@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: [PATCH v2 1/6] arm64: percpu: Always inline helpers used by noinstr code
Date: Mon,  9 Nov 2026 19:44:54 +0800
Message-ID: <20261109114500.20298-2-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261109114500.20298-1-jszhang@kernel.org>
References: <20261109114500.20298-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tqffqt57suk6n5dhf4stshcrasm4r13h
X-Rspamd-Queue-Id: 2D2A220007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794225917-630777
X-HE-Meta: U2FsdGVkX1/X/ZD/aBVGNEQx44QUxz4DMaBUWK/7LibrJdMiKs5wbRqzlHvJ4lBlT0FuEQ3IFPsUD3KQjfbkGKHYrlLncnGQ3QdgejZ3+nPSp9nZUg3UvlACP9v488+pdsw42M7kJNsALkSWp5LAVqJOOM4bVeIWx9MEU80N5FYCBB2ZT9ueCzz+h4qkHuZAUzsbxXPSPIVISd7wmR+4lSMlSpVChspTsusMxSBvlMId92Gvm9soEFcRjCgZItls91ItjgPs8yS5khf3qMXGnp5vSXHSmaKMHwJUDbbPCcHTDMCb/wfPPTAluS3J6FCbWwmN57coXZiHdkklIDEhI22BFQMuuJQjnBM9Fyav+OA74FbsJCcxnJ79d3riJI/bcjjB34IPzkt7u6jNptoCxUg6lpfzUs9h689xafdoBuOUgbKJzv0FMp03J6spWAuFsvzMU3Zm/yfP3hVNtxKSIB0kto5zi2lhVYDUj8RhQODdUkjoWBAbCg7wFc/zSyAC/+bJOM5Ma/W3VphR3Tk/pCELIkUqu9LlFKbUy0k0MyOlqBkOilAdTsSjv3J+Y3oodH3Uh9nl58rQ6ZwABrhgo9kbdwS1HVbKm2dRqjov3MpjO7z0Ej9KkttYQ9Zv9BzY9zxo3QYoO8d7hyHXLxLt3NnXI0jFW9lvsevV+l6bONvm/qcJLw9LyZZvBarTyiLwM7jn5Esud6dm8eJrZwJUN5XQ17zKd5ZiHuSHz2cjA3bZsblfLQtAJoKNPjK7zNS6R+agfM/ADSwe5O8195264xF38Sq6t8z7UrU23TAdtQjGLUbvsXAlccJvHFPE1O50nS909DHYz1cvPmomFWxqmT10LbCFoi2hVc90fU/dUHPJbTs/szeWDOAxON6TbnudOja25SZsrmuqbJSCGMdCJB4+MTQt/Pk3H54N6SHXzxMuBVNdZXNEHUJc3brccRZWl0dwWnOcV8j04FIifcN
 8Q5VPxZb
 MCMkW0dDUmHZErSPkXV72nCDmuy7BcQkoZU7jgNt5uIcaLI5qcXi7BaA8wM/ZWf3RUtaQHMj8pU73t0uShTGLUcI0XasNkzUt0iTPicGjTIfM12AIMKq9wSVntS8261uWYWUn7dQ9Au5kAu3cOBy2vXyN4udX0trpvtzsNdHb1sZtzGIquDM0Xovwy1b/udFAEal3lN3TacDxVbsqYrGgmtoATGHEW4Gtpi5B9Rygxy1wZMmsKsnjEmhQXu0kDgXxOxbwr0Yvibd10Ug5np9pbTqzD66+bHHrm7ixldqIhLZGnlyhw0ipGJtw5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The non-instrumentable entry and stack unwinding paths use the per-CPU
offset and read helpers. Plain inline does not guarantee inlining, so
these helpers can be emitted out of line without inheriting the
caller's instrumentation restrictions.

In a GCC build with CONFIG_CC_OPTIMIZE_FOR_SIZE=y,
__kern_my_cpu_offset() was emitted in .text and called from
.noinstr.text.

Mark the per-CPU offset and read helpers __always_inline to keep their
instructions within their callers.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Assisted-by: LLM
---
 arch/arm64/include/asm/percpu.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 3cc316091d66..40a327df41cd 100644
--- a/arch/arm64/include/asm/percpu.h
+++ b/arch/arm64/include/asm/percpu.h
@@ -23,7 +23,7 @@ static inline void set_my_cpu_offset(unsigned long off)
 			:: "r" (off) : "memory");
 }
 
-static inline unsigned long __hyp_my_cpu_offset(void)
+static __always_inline unsigned long __hyp_my_cpu_offset(void)
 {
 	/*
 	 * Non-VHE hyp code runs with preemption disabled. No need to hazard
@@ -37,7 +37,7 @@ static inline unsigned long __hyp_my_cpu_offset(void)
 		    "mrs " dst ", tpidr_el2",				\
 		       ARM64_HAS_VIRT_HOST_EXTN)
 
-static inline unsigned long __kern_my_cpu_offset(void)
+static __always_inline unsigned long __kern_my_cpu_offset(void)
 {
 	unsigned long off;
 
@@ -129,7 +129,7 @@ static inline unsigned long __kern_my_cpu_offset(void)
 #endif
 
 #define PERCPU_RW_OPS(w, sfx, sz)						\
-static inline unsigned long __percpu_read_##sz(void __percpu *pcp)		\
+static __always_inline unsigned long __percpu_read_##sz(void __percpu *pcp)		\
 {										\
 	u16 *gprs = &current_thread_info()->pcpu_gprs;				\
 	unsigned long off;							\
@@ -149,7 +149,7 @@ static inline unsigned long __percpu_read_##sz(void __percpu *pcp)		\
 	return val;								\
 }										\
 										\
-static inline void __percpu_write_##sz(void __percpu *pcp, unsigned long val)	\
+static __always_inline void __percpu_write_##sz(void __percpu *pcp, unsigned long val) \
 {										\
 	u16 *gprs = &current_thread_info()->pcpu_gprs;				\
 	unsigned long off;							\
@@ -167,7 +167,7 @@ static inline void __percpu_write_##sz(void __percpu *pcp, unsigned long val)	\
 }
 
 #define __PERCPU_OP_CASE(w, sfx, name, sz, op_llsc, op_lse)		\
-static inline void							\
+static __always_inline void					\
 __percpu_##name##_case_##sz(void __percpu *pcp, unsigned long val)	\
 {									\
 	u16 *gprs = &current_thread_info()->pcpu_gprs;			\
@@ -200,7 +200,7 @@ __percpu_##name##_case_##sz(void __percpu *pcp, unsigned long val)	\
 }
 
 #define __PERCPU_RET_OP_CASE(w, sfx, name, sz, op_llsc, op_lse)		\
-static inline u##sz							\
+static __always_inline u##sz					\
 __percpu_##name##_return_case_##sz(void __percpu *pcp, unsigned long val)	\
 {									\
 	u16 *gprs = &current_thread_info()->pcpu_gprs;			\
@@ -270,7 +270,7 @@ PERCPU_RET_OP(add, add, ldadd)
 #undef PERCPU_RET_OP
 
 #define PERCPU_XCHG_OP(w, sfx, sz)					\
-static inline unsigned long						\
+static __always_inline unsigned long				\
 __percpu_xchg_case_##sz(void __percpu *pcp, u##sz val)			\
 {									\
 	u16 *gprs = &current_thread_info()->pcpu_gprs;			\
@@ -307,7 +307,7 @@ __percpu_xchg_case_##sz(void __percpu *pcp, u##sz val)			\
 }
 
 #define PERCPU_CMPXCHG_OP(w, sfx, sz)					\
-static inline unsigned long						\
+static __always_inline unsigned long				\
 __percpu_cmpxchg_case_##sz(void __percpu *pcp,				\
 			   u##sz old,					\
 			   u##sz new)					\
@@ -463,7 +463,7 @@ PERCPU_CMPXCHG_OP(x,  , 64)
 
 #define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
 
-static inline u128
+static __always_inline u128
 __percpu_cmpxchg_128(void __percpu *pcp, u128 old, u128 new)
 {
 	u16 *gprs = &current_thread_info()->pcpu_gprs;
-- 
2.55.0


