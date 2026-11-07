Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAC1E606A32C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OrpxnUKZ
Received: by kanga.kvack.org (Postfix)
	id D09C56B05B0; Sat,  7 Nov 2026 02:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1946B05B4; Sat,  7 Nov 2026 02:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1FB96B05B6; Sat,  7 Nov 2026 02:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92F3B6B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:33:52 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07656120274
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:33:52 +0000 (UTC)
X-FDA: 85407508704.16.1F60D16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 85DF7140006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:33:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrpxnUKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794036830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YFZRmCfQkWp9l98IMbH5VkBf2tDBMZN1QOvzm/n0/Ek=;
	b=EHZZ8oWqETTyjJyidm08WNZwv68kGtp7c79vF2RSI5KJ+TeBHlrlmHG05Xi3QO5dOgb2Y7
	uekkpikQMNwFeXfr6G75LuVEHaaSoIRMWQP28OFtWi44bSwoQV+zDBHVloL6K8+8U594l6
	+TZnkX+qb35DvUL73tYmKkcdNROggYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794036830;
	b=i7GtVm9jhgYFtEIARKjq2mOxte6sdKh5pfQmAQqPQlnifa/JQkFQZfF0ZvH4IUp0vq7+O0
	E6d/oRgA28uq+U8m59qS+rXBPZPOMvBfoVzfCyi8CYVx1sKQw1v+hLHOWBhtzG6Mu31RPF
	DNRBDMFq2kS6kk3ZSv/M9Bb9FF07O7o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OrpxnUKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of jszhang@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jszhang@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1226460A50;
	Sat,  7 Nov 2026 07:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E091B1F0089F;
	Sat,  7 Nov 2026 07:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036829;
	bh=YFZRmCfQkWp9l98IMbH5VkBf2tDBMZN1QOvzm/n0/Ek=;
	h=From:To:Cc:Subject:Date;
	b=OrpxnUKZ9n9S2pN6xJmZV65t8uBDUFiJ4lH0YwEi2xm3FWo8q+0fcd+4HzXfczeoP
	 2uutuIREt3xoDSKJzOlrSJu2lZNdHg7uOQlMwzXOFkADgWCq3QCYGpCzHN2kNIAwdC
	 15u3DioQMCR41YjiXY/FKcKdcshWKH6myFG2ziGYD4OadAFCOyPVBCA6eYv21eZrPw
	 NMCP+FELW1efVOmW2gvhmW9pzkxozKYI6mjYSWgJkyJAcOXdNBt/s/cRPEl6TnKiib
	 k1lqCbtLnrA7K4/gdFk1diN7VwBaFIp70t3VuFWeikG5C6o8kHcvRhPIGU7hgoHNEQ
	 yFnbSQmlKpCqg==
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
Subject: [PATCH 0/4] arm64: Fix instrumentation escapes from noinstr path
Date: Sat,  7 Nov 2026 15:13:35 +0800
Message-ID: <20261107071339.17467-1-jszhang@kernel.org>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r43yenat188fjbha6kxnj9uwc5cti97a
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 85DF7140006
X-HE-Tag: 1794036830-762840
X-HE-Meta: U2FsdGVkX19nFdu8u8lF7ITiGp9yOGQViTF9m5xSH0FKbrep80uVeoEF0dIGPKXb0x+0k0kdIXsx9GM9HONRNVs8QFuFoxA+mBQn4M48xNAYCKfpXEY5D7c8fdLqI+9SlkDnFKYguzrjnE60+3L1lbnUmTlzgrAe1nZpRlVBrq3KjXaJdEETxGrQbWmtb7I67VjmgYrBBG0d9YAVv5vPj0E+4++mZEu1DoVL9wcKG+GeaBDj0OfYg2HGx+YXpPeCzffL6hZsOqRv+h7h8N3xRpc1Cmp8ovhUyCvEx5PktqZDGSncD9kFXH37qNtRyNimZ6Lww9hs/B5gPa7zCTtSGGuL28vPX0UR0p8xSDwWii/VyU9/IAEqWj3QuRQKomMyeYdW9X8utd1IdWdu7FrWFHfB4E6uYB/hm/25ohnjY9rk+neAmU2V35qmoymywjxaLXEOEoOYos1Uoc1SOkBWhrug1NQLu1GxAPoii/xI52yOxLL8hx1QhuwGeS6hy1oBV1ORmasEIQG4FS2a+IljpwZ20tLQiNi9lywUusigfKsg0miqJAo82it22QtN+zL3HPMqvyCFO59B4WNYhVGdjVLPLyaGPuYQ0IjmGJ/uvTUWqmi9OnG8pH0rJemfivayqiS2hrC441aiPz2mZwqzVdkTrC95KFrLnwV7fV0I4YoSuvOMKNuFkImnYIS6tFHRJ3hCCJaLMvAk6cmaqXxE8XoF7k3oLYcE1mHldtXuPt0UDH9ONYSDKsY8RK2jPK39ejA/jlWS528CLG8mam3czrHqmYijcIRT0FyMr8TR3bc25lmzkG1g8gI95fJxFFTNTP8reLJZ/RhKkw3XnNpEbT7c2oAekdfiK+ZMo/JwK1CfceamPynwS9dULJnoQYxgfWZbyyGZ15SjPDMD5Mv3s8xRwV39Ai+WSDVJtzI1v3ekB4vbgiVO1m93xGWqtvw6JurKnvq1qzuEoi91tQI
 +mvxTPRs
 /mBJoXGW2j0AqAuJz56xV+OcQ6AEurLNmCzxgKAM5xk/MpkeJpeV7WNDc4iMtkrkxo4RXcWa64iSYBgdMBvLvlb0draqwEBgpVM7audqPYCH2Sz8gmG1CTppgHn295MtklT8zbliA6fB+rlhwcUNg7wqZLg/PKQHpjciNl2WJicOVOF52LFPDa7CTtxvqwFt7kV9DxHg5Z5MXKvCYAByBZXleoRG8AgSuwKyeh+CIZSSbgkhh0EYPXaCrgybMIGMoZPNSCk8EoNRDmwrYZAp77OPzny85BQZWwZtr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Code marked with noinstr can only safely call other noinstr or
__always_inline functions. When reading arm64 source code, I found
necessary noinstr markers is missing somewhere. So I asked AI to scan
the arm64, this series is the result.

Jisheng Zhang (4):
  arm64: percpu: Always inline helpers used by noinstr code
  arm64: entry: Always inline helpers used by non-instrumentable paths
  arm64: stacktrace: Always inline internal stack boundary helpers
  arm64: alternatives: Make branch and ADRP offset helpers noinst

 arch/arm64/include/asm/cpufeature.h        |  8 +--
 arch/arm64/include/asm/entry-common.h      |  2 +-
 arch/arm64/include/asm/fpsimd.h            |  4 +-
 arch/arm64/include/asm/mte-kasan.h         |  4 +-
 arch/arm64/include/asm/mte.h               |  6 +--
 arch/arm64/include/asm/percpu.h            |  6 +--
 arch/arm64/include/asm/stacktrace.h        | 16 +++---
 arch/arm64/include/asm/stacktrace/common.h | 12 ++---
 arch/arm64/lib/insn.c                      | 57 ++++++++++++++--------
 9 files changed, 66 insertions(+), 49 deletions(-)

-- 
2.55.0


