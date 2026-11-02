Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0084460A2635
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KZZ2pULE
Received: by kanga.kvack.org (Postfix)
	id 80B436B05C7; Mon,  2 Nov 2026 06:22:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BB726B05C8; Mon,  2 Nov 2026 06:22:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634DE6B05C9; Mon,  2 Nov 2026 06:22:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6556B05C7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D193A40CC0
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:54 +0000 (UTC)
X-FDA: 85389941868.04.86A9763
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 205A820006
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KZZ2pULE;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618573;
	b=PrrqWeYRq8uiUtWUKBfVhFbTLOFuCiRapgnYsbWp1IWAch1YgF4EtQ26Q3zSLgqtH59DFE
	8Jz7bNvBL7uzAAYGu86sl9AF+hO+LCVaXot43DZZPYktLkkpGnD1gyw1C/lRCercDq823l
	KlC7gm9NU+cR5NGw752/BM5FUtdxsqk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tsb7ch0fkVycRE8l4lzI8CP6E88GuMX71rxiGXcRyD0=;
	b=qCxlCDYuTcv8p/cu8GgWftQgOP29gUEp4fTALjVZiH3CnuDjWmwwH/EiY2yFft816BN7jx
	B4HBVnD5O87e16oyC7WhcuG/q+nCq0tZ2MsUAsSrnkve8X1Z1+jdfi1UU4Oh6jTN/x/hBr
	+1YAX8Jv+6MUFRFuk8UeNYBz2+zJyY8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KZZ2pULE;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 42E7A2A31;
	Mon,  2 Nov 2026 03:22:49 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 37B4F3F632;
	Mon,  2 Nov 2026 03:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618572; bh=60Xa9B2iUtyR3r8ioE+XTXe+blj+2dKI9yzxVIZr1t0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KZZ2pULEBctEsGAXVrvXT+Vel6lV2ylQM7v0lus5odxyD77t9mWOEHrZc49tBaniz
	 nQ+V1k58GA0+D6TwKZwG0X5N6Rgew97i5ygFK83+IXfvCKtCKCzyF/kY02GLCg4Hkk
	 VwkyuVCUKrSmbbb+nsizpCRap0p4iBkAG7tU2GwE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:25 +0000
Subject: [PATCH RESEND v2 12/21] mm/pgtable: redefine PGTABLE_LEVEL enum
 with ascend order from PGD
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-12-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
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
 h=from:subject:message-id; bh=60Xa9B2iUtyR3r8ioE+XTXe+blj+2dKI9yzxVIZr1t0=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HI0QV4ojpgcFbw7NYJO5M3UEa0V4ttsQ5fcX
 PLtIuFXA9+JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyNAAKCRBt1cPRWsUx
 M5ZvDADXVkFHHBDnee5VQHc1URqbVSLnRmZQGtwzLqlg+CacOzVx4f7Diht4dzRAiiK+1m9UF01
 wRfNSyqT67w0dI1bwZt6KHNKRN+XFKnks05m3unYkdsH3JMDguBAe8SXxh/WUsURKuHCFf/9FHS
 JE5HMbsaUR8G6yz3LC36b96W0UCpRr/7EQOLZ6PHOYoCayzJauK/OB58CtSVxuWSzi2sNEjL164
 3edL/DfNEjgvKH6m2eaH35w6admU/hQvZmWxMa6KbJN8bT5DZyzVo3tNRhmJGQkqGAaAW4egus2
 Ew8qNAr2sofw58ojK3Wec9idGsNAMVs5eaDhV/V+4XtuXB9aUY4wNVPUTouQtD+hOIM7bgv5msO
 M7P5Xb6PZcHXVtsDFOZFKgoj69nU3EGPXYrfSQ7shRw9Mc+7k0eqPaSEEIlD1mUn0Cs9peZCsro
 zWNQBVLh7Nn3TSK8C1Y/FKdh3N26DPsAkAb/jVrnq8PoxftkHncsqMLPSsZNp68ShBSVE=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Stat-Signature: ytjd5nrswpp34ofip1pwuydch3u65ww7
X-Rspamd-Queue-Id: 205A820006
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618572-493528
X-HE-Meta: U2FsdGVkX19/DD8UIotYVIXCROsGQYd6amPJ+PSmAhtqc6lK17jYYP7WniBpTISprbmkKXINzpnJq6aSH5qZaXqgvwQ2UV3bP9kquL0rlbw57eQ1ufqgLLEloyirMr4DngMmq3WPdAl+WoB2YFOOxDNzrnM72A7YwA1kDPaPC80BnHub9VET5b88sfox6n4qSdL/p/M/gqIzuml6rqdFBmV0zk7ihe1ldG40ckbg+65ngduvPnsSc2KGqFK8LO+hJWpLy3OLi8NZG/Ak1X7vBddsSTrNLMhu4y+BvoE53AaOv39mL86r7Mzj4WVsXr+7Ao5a/tTaR5ub1yzW8s8dz7xbVOXP+afcsFRE7Jj7xu3kFkDC/i1ggALlUu4yV0xqm4qch6GuXROJpvl5qs6ShzZ5silkdEAAa0A1DKiCaoLz2gx6W8S7OuIskOUhTct126a1P4zqUdaGseXpVJAHIEuaLTTsquc1RCpb4j/yfekF1VkZnoD6s1/3k6RyeRnh5N2NKKDQiCcA+rVUxGR2oNHvaUyyDJl+O/6e8UtmBwden4VrrW4mMa68LSwB8Rm3ULO+uNv+EpYV7EsS3DQ0AyjCKkgqBeHgsJC5XqeVhWPPobYAv8As62EQgutlsnyT5PbUP7E97SjAra+6065u20SHh9ICJmCrBrcXNIUZRAnnM2oBDVjeJlQvmdEa49wcI34YA9p1LYwa9pSgO2VkV/w52KbkAA76FZN/hLbDv80pwWgkSU5h1bECueuWFIhx42+EfjRUUjiKIfx3xH7uVIAqdsOJ4nuT9wM8MhZOvla185xZN/okV7EpPVGSihQeCn3rYjIhZubVOm8LMWiVPUk5sZs2DDSUA0yyhAWPXjb87WvjY27/g73GHuwPhNFIw/jI0iYCbzP3xhyLtay/InWgwgBcMu19szBGSooDCmahDYJyqhf5gjbX50tNWUVcRoGp8o+JyfNlLisug8K
 k1iD30EJ
 wtDAytwmSoLo0FPREu30XKip3kbuUWQXu80S/r0fl0rcpu1dYxKUdtXfJiwOLWwg5ljjM3ZY0Uqph40eS07EQ1pvCZqgQGCmudK7VYJCTS+sAroQm531JCc0ZcM7BZ1GnSxEInGzKJ7oydgZHkCEa2RvF7LFGPuyVSJZiuZYacxACcz5xpexez0KJilhZYJjB/4vswaEWhocIbdFy9/iJjqikY3d6akDFVpuBHjqg65ddoy/GXDPj17GxQGfzj+BmJQ6zwUiLR53kXnCrHW34NZnjbXO4fyRVxj6AZ/sUYrXXJyR1MMQfvp/oKkfML1UTxHPCczS5BVPl68pxZr9pqtKQ4BdOMDIOtVTFO26x91YjTdobzmForI3mKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index 780fe849ff8b7..a032f95943357 100644
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


