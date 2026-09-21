Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3FBAC982F1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D182E6B00F6; Mon, 21 Sep 2026 06:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA23A6B00F7; Mon, 21 Sep 2026 06:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB7B16B00F8; Mon, 21 Sep 2026 06:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 970BD6B00F6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:58:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21CFE12012F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:02 +0000 (UTC)
X-FDA: 85237469604.04.34180DE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 534D84000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:58:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Acv2ig2s;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPh7P4/uTe2DdUqFkWDXpxMIk96xx52i1UmgW1/Bvi4=;
	b=u7DNovis+FZeIybkjY6EORkwin9ldcrB/Vl9XrlMxSVMIyum+56VXccDhfRxCwsuK4cGHZ
	4LoOSL4bIZpwcZpDx6iOJurY9cRR3sOMc1EUMRIry/ak7yTWh9UDyfm7k2sxHXDqA3/PdO
	0RhfNz2ittjklN3y5hgIbCMYDkSZXTw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Acv2ig2s;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988280;
	b=ZnW6gNDOLVvFVil/Kz8KkzGUXIR3J207es4/eQhXcx8YMJqoAvg+mqRlVqGodZNK+nzSN3
	pV3i68yeL+VT+nSp85keKVYtCEt6/tF1cE3aWEA3Yf3G2A85u/651bgTJwIBGfrHMGtHOT
	piNEeK1M6dSjOHMXupIBwzYIDwBmsuA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E73E61570;
	Mon, 21 Sep 2026 03:57:55 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3592C3F86C;
	Mon, 21 Sep 2026 03:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988279; bh=Y8EwOxLNbw4UfgGXcWJN4XYR7fgRn1Moj06vSGiaGhw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Acv2ig2sdtBQm1rWWS02siT0WU0ZatIgo532lzW7QnReSNXQH1ySM+8DelzsQa55e
	 0TVi9G11NlTKdUH74Sp6k0cO+qCtLFbvrelhmtDh0SsbAsGd/j0A7ufpMeXn2Es2yz
	 Xmxo3CKqJ1ia+7cA6vpupVw3peojMkInMbV3ExN4=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 21 Sep 2026 11:55:34 +0100
Subject: [PATCH 12/21] mm/pgtable: redefine PGTABLE_LEVEL enum with ascend
 order from PGD
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-dummy_ptxp3-v1-12-cd40cf68242e@arm.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
In-Reply-To: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1282; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=Y8EwOxLNbw4UfgGXcWJN4XYR7fgRn1Moj06vSGiaGhw=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqsQ1QUaPfd/TdZdMCVJig81AKqOVJKDuhmr9iK
 mpmDD+NEl+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCarENUAAKCRBt1cPRWsUx
 MzrLC/9aTw7wgAVsVSkyAx9JoerSy/E93mC4rUycb4dvDtSfmjpnvXqlvMNOZ0X4B5Tw+BHjFpL
 9jH7TfpouVsi3ilgGlYWmhFqe3BTMspr76UeuII7d1gg8OfdV923kIjDcgioZarrRikees4YSip
 5uqKCkUTlyqCGmKOuU7nhOAK7tW4wYh0FmSWSpiG0PLWIeBMOwyBw/zW8ypmQTnMIIB1wuLzs/u
 7ROCVrCCjQ/dan0IYAxg+t7qTPtpD8XuY7kE8NURgpEKId4bCFhy3U/wB3lIQdsLHM2mgGlnKYV
 zy6aNQBGpN9mKjDtE/bZGY6gmk+CVWrUNVbiSTouNAfpiUTsGa+e6Yl0KqWvXhip7lrYnaQWTzm
 Q2l8/kQPPW5++rC7+eeJkINpxVX3PFWYeBJwLOBF75Lr6+GAyvrtK5usO7NuLcJLTYaKd/1JKHL
 OxP80e+rles/44lu4BlVndGbnxkSWb4UFg7VdtjQ5e0MfYATc+XAacUtqoHmAK6Nsi+34=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 534D84000B
X-Stat-Signature: qwr4mqam1u9z4mdc8f5ye19nd56wuk14
X-Rspam-User: 
X-HE-Tag: 1789988280-285638
X-HE-Meta: U2FsdGVkX19p/NdjkKt46prye0qxgXJUM3MPP0q7GiQjifEYepHkhhy6H2J3vbZZiLDEimAdlMtz998zijht73NVuU0uZG2mBhdt/u2JdLwhHP6/FTHl4zjXZUQ3gEXp1TFBA8sRUWKiBfMV8zrrMGgLO55va3BQsZ+wcTSFSHzw/alHARfMTdmSvvdc/RFMB6KVqtziWtSXyeWr/0tTgLN40rtDgf1i5Wg18tDOqZSkhoNx/od7bGKz4ipsZLphQt55Tu1RP9/cMvEwHK4pF7E6zsPDA3WzRzuo2TzvYuIA/ULcFxzTFG69OUB/w1v6nyvSH4jLt52P0n5uBf9LYsabcALY4DF38ntdy7dKq4kNFtyBphB+8FZs8+08z7y9myBrJ8otQ+SpqIjvJJpaRORB7/cetZnYBR5VgtVijUVdnPzmvSfvEojVPfTTr0zt+pGJ4OlnPpeljFwSZgA80IWAzTVPBNJQNZLZnGODmo/AGhfbmZ9jfa2AO2Y0ESfJQD/hFcVZkB6aXMdVSKRJgFKo836ztIfpKw/LUoN1HbT981bNrcKlpL6Q8JEp6cflm6zGFaNecTtnyWCE/crEHWwjYhH8DOnzm8nmW/G8cJzrWAz4XcmxbTDH1pCBfb9TctvnSQ1lOS9slol/1jX+HelxGoIQE0sE7AZlL7M4GXUivu8PlpzdPZDdXNl0jaujaQwkcGCLEQ57xs+IwjZqWsw/jZlZq0M68fBMZRs0XiVvLCI+M2fFfZUim+eoSURG1L7a7CnmMxMXlCtNdTivDaguARh7a8JAG/3WXh2engtvo4SPJHwIE91Blp70mN0FqmKip1G7rhKEpkINkwoF75sj29L3B9+ZQ5RjlhUOJ6YaITY5WLOJNHAbtlzZVhOtWzmHkIl6tuX24Ud1WqHRaTD8cWWj5xQ7exdDvQ4MZU2MqY8uX0YHkEeXqe938VxTwZ+6sPas+9BYBAVRhBQ
 J6SONQ39
 /TYcr8oYxQiXZ9/oDMQ719ca2Rpw4Ax5k4BBu3f33GIziPLNRfjOd06u4sMzhFNPwrq+Jv6+y4DQwTvtEyPelhpodQQB+kiObr4uQi1DrpH2r9bLCF9nmprfalEahshOstebVC5euui2LPbRDmBJ9ZXDkA3o/eEPfjGyLmyQk8caL3ixu+d1v/zHLKgiEy6dNvYJQvzwfuluBnC/CugSTXDO9J+sDllqxUgROwDCp8FGlm3710wg2I688isC3PwX+5xUlW+kjsKyivN92IraN49qMIp53uBbkglIQe30gh6f5IpNRFYNCgtF9uAZOXegzz/H9XuKVX6DOwyQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The PGTABLE_LEVEL enum values appear to be ordered in the opposite direction
from their intended usage.

Intuitively, higher page table levels should have smaller enum values,
but PTE is currently assigned 0.

For consistency and cleanup, reverse the enum value ordering.

Since there is no current user relies on these numbers to be ascending from
PTE->PGD, so it can be changed to be ascending from PGD->PTE, in the
direction of the page table walk.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 include/linux/pgtable.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c5..3186096a6e130 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -2288,11 +2288,11 @@ static inline bool arch_has_pfn_modify_check(void)
 typedef unsigned int pgtbl_mod_mask;
 
 enum pgtable_level {
-	PGTABLE_LEVEL_PTE = 0,
-	PGTABLE_LEVEL_PMD,
-	PGTABLE_LEVEL_PUD,
+	PGTABLE_LEVEL_PGD = 0,
 	PGTABLE_LEVEL_P4D,
-	PGTABLE_LEVEL_PGD,
+	PGTABLE_LEVEL_PUD,
+	PGTABLE_LEVEL_PMD,
+	PGTABLE_LEVEL_PTE,
 };
 
 static inline const char *pgtable_level_to_str(enum pgtable_level level)

-- 
2.43.0


