Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57B28606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z7pu2Zcw
Received: by kanga.kvack.org (Postfix)
	id 802036B05B4; Sat,  7 Nov 2026 02:33:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78C1F6B05B6; Sat,  7 Nov 2026 02:33:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C8566B05B9; Sat,  7 Nov 2026 02:33:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF5086B05B4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:33:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 575BE1A0253
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:33:56 +0000 (UTC)
X-FDA: 85407508872.25.25EE7CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B3096140006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:33:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z7pu2Zcw;
	spf=pass (imf09.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794036834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1o7E6/PEZfnHFqDMeLtzchjTUh2bQgzVUzqTp6fm5lQ=;
	b=GlpMWwQoKpcR+D95ugeOqo7E/BNC6my27Dl9nIY0L7e590C+dRyWhjA0GRol86MdfrCi6K
	STVs3gQeZqy+cNnzmqjKAx/hdENyijeav61p2wE/Ht4lzBgyGOxP542R4O58QBv7cydLKA
	pgrJ57ihkEQwsEdua5s3Vx+dD8B62ZQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z7pu2Zcw;
	spf=pass (imf09.hostedemail.com: domain of jszhang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jszhang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794036834;
	b=dsz3XwUPWYy7V2NFfj8lxVTIrJ6aOFuITe1YTw9oQTg2/sg+nzy+3IrX6EXQHprUb0NfYa
	yjmBZP6gcuvdaRVKcNMSl/lGWXYOzeCYZkCMnM2TjmQ7s/DgyBHNSPS0zCNHj3dV90sHwq
	hPSdmOdFpLVlN46WOxV+PbZGUSJAoHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5DE543B18;
	Sat,  7 Nov 2026 07:33:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D261F008A1;
	Sat,  7 Nov 2026 07:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036833;
	bh=1o7E6/PEZfnHFqDMeLtzchjTUh2bQgzVUzqTp6fm5lQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7pu2ZcwoD9OUreYyHE8HU2dJMBtk1hv8qhGCbK5WFxTzxQ/fCQJIjX/XgtL/Z8ap
	 6WtNwMVARJt+lSBu/3YH8/pFiFLqy8RG2C1/tpgIZgNG3WtpSZb2mpwfAYDn0XEqRI
	 eJt5QT1QhFhprtJqgtS24CZEYz8bAzg5u24ARNVM/SJKCsUXyihBZZNYUD44XxHIkO
	 hg5I19k3iUtXfRrjDCGwQ7fop2m8hCf4FsGkAMJNGnguVofPbfM8ntRTgnpveMAJYg
	 dn3J713D3P9N/DmFjaCxDdpubU2gU9vDBy2vE2bgobq5YuoEYiZOCJf0EfY4KY54e2
	 6i9qnERwrEMZg==
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
Subject: [PATCH 1/4] arm64: percpu: Always inline helpers used by noinstr code
Date: Sat,  7 Nov 2026 15:13:36 +0800
Message-ID: <20261107071339.17467-2-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261107071339.17467-1-jszhang@kernel.org>
References: <20261107071339.17467-1-jszhang@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j9cawx91m8hitkxxk4zjg5yyhgw8434b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B3096140006
X-HE-Tag: 1794036834-727451
X-HE-Meta: U2FsdGVkX19lJJjc+xNSgj9TYVdjk0KP6Fg8LZG9JBsm9qUuTCtWWwSQJwENNhqjAZflAoZfyViNcwdeKdRStDyvU7y+oE8Rdj9fxUKlHHIP/Z/N3zhuym97NQ40yaERsslbvZUSaTebY+TBF0Bgbxyo0mFr6iZCC2iUE+nuBNNiN+bpndo7olGv+9R0Co4OwisBq/KgvkNUSAB+bn2O+y21/P+kzSFEMs8fHlMP9XsBZI7/G4NZyW1Z2EsTtQLRasNarj/Fg/Funp9tqiSeBrvdVBY285LWK+2cDHutG3qhwdsoAMLmVhKF8H46Retz3Yij2KV0ZHy+QMDddF76LVtxYQFnLDipCpZt7Se0yNSJOhqKxCg1RF4qMWqnsokhNYuFhuVr1LP/RUJgqYuq+x7c2xErcppnH3rSu3fMfv1HCdKatXymAA8DnmdSJvB5p30uuwQb48871KJA3xRKcSnQajencrKDoWe9Cks4pRB7TIB5pEt0lPWq3EEGHR+j2VIWtGIWZd9Fq3l5zdBclzEAux/sI/1LvER6Aisc1Xstqx1T1VzjWyaLW4H2LVBhFCGSZDU9ekEMDYXxOQNpDbNwM68pkPRcDypZrVWeUISbr0WptNz789mQRLGdo3DrYwhta4r19IeqT9UwDWzd0Qw6K7zM4M7eR03EM6cEACR6QEthv3ffh28b8dy6VP7WDNuWmBPD02hiQK15KlpzZUH4SBZ4rFaRhDprRWtVU4VTYHclfAPtxCzy791WKZw4gwNCagaHxKznAQyBaf/sI4R1uUWQHNiRPVbb1k5JE+e2OOCV3xS79jW1EdlF5NVDZzDkJ6U3/TVqnBavCnkS15jYST+PARq8/FTtidG02Dv/KJ4BEokw5lLdi6tHoeg2ax3zFkWMlo7ao5mB+vkoGrQwSWDK+o5ihJw1hV0BF6sZfzjhc2p9Y6r2hJQX4QRraqzKxU+NosVPC6+hi8n
 mZKBgsoW
 K5m0b4jNk4MWF75U+HBkYfLiJqBnJ+aF/CdhWV1F0u+3l1TOZas+AvAg2tYgioWZb/CFUPDKvrhXzgX5FlckqLQRgSYjaEBYfM7arFf59xIUUi2Gs0wphETdysdp5kOGXQsnyHQz2psBMU3skQduZheVTk9qFBi1xvXIYVn3CpTPJiFvjEMd+3KoEEsSsVPtXbStf2/pcNui+65ar/JMryuVlS6lwQhVRFnDEPymezPLxlOVpEmnYgYdKpG2/sgj+hqeQATOY126uHstqiM4TXFIMZP7HUd5UigbBN00zgMAWwaq9u79abXRLtw==
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
 arch/arm64/include/asm/percpu.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/percpu.h b/arch/arm64/include/asm/percpu.h
index 3cc316091d66..7c344de5052d 100644
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
-- 
2.55.0


