Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37254606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 06:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Xfyk1eMl
Received: by kanga.kvack.org (Postfix)
	id 58C5A6B05B6; Thu,  5 Nov 2026 01:12:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CB56B05B7; Thu,  5 Nov 2026 01:12:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C616B05B8; Thu,  5 Nov 2026 01:12:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0E2276B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:12:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 884478093A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:55 +0000 (UTC)
X-FDA: 85400047110.11.FA7450A
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35085C0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Xfyk1eMl;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793859173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SKim++0/v959SqW2Qj0ZN00Ia9M3Z26xYKJjxKUd6k=;
	b=Qzdy35LO+gvterCS2iz7e7fanvN7yXqHR+zfr/6779nFih9g1igOT7Y/8p6B4amPkecDBS
	fo6MsA49c27dwfJ7A2OjuoxCL8ErUSA6rKw7QzmVDqzCQ9d1+fxP4YHaiv47rpRB7bHMLo
	wOop5ruTnTiWw83//mURB/yn8HODn5g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793859173;
	b=ABEjkPG3YwL8+43Ki3d+OXMVLyUZcWACMeQChlTRj49Evs0PqvCs//44cKl/9s0uS4Qjm5
	ew+tMEizSYcWhkwC1u6f0pt/sP7RAyRe9QCWPF712vY8f2PFVqurCxJ94w31qotL61TVVP
	YzjZkUzEvwZiWiSOjuyy1iZwYeMpzLk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Xfyk1eMl;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ab41538192so1275149a91.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 22:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793859172; x=1794463972; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/SKim++0/v959SqW2Qj0ZN00Ia9M3Z26xYKJjxKUd6k=;
        b=Xfyk1eMlinxq4Pf5A1Fx3yUGAKnkECVAQ3IqNbWREbfVnoVdGvtOXAdiN6sXftYWzS
         ahd5bFl324cMgVepARZIZjYK9uBCJ7IFWPZgHi6btkuPcJNoiKDPDXSD18DwnfKEsrSs
         XY3GcxLzbxsTYFZn5a67pprcyRE9vcgsnc3YFnCtOHGbOCov8DePiT3XY450tYa5za2k
         cShBSYkZfu7SF92JdIXI8517PeY62yj2ntFm71aSoMZDNecYCXwxARZJ5G8/nTK0NxGS
         UvFVja9Hhqx/r2M7z2QTBA7gtSRzxyuht/cErxrFyHvlKhtDs3Ve92TEEyLv/91Mt0IU
         sLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793859172; x=1794463972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/SKim++0/v959SqW2Qj0ZN00Ia9M3Z26xYKJjxKUd6k=;
        b=c4z1L4oMKgnD0yke5csSQy/szHR5uwDogBlJn1tcz+/sMhcvrbSFy03fVb6faDhj3K
         dARpNfo1gkeziVDmBcaqtOtCuWl7hQbTGUM11Vi9iM383wWLCy2BtJclQZEqMkKXESr1
         vwplb/lopPKzIDulRIjyUrtOlTdw/oeWovO48ooJyffh67eWtozL5/GCsX5EvRB3ojDm
         0EwdUF7NoQQRxJ9MOkCwISsGGVw9j6tZz+txEOLpHluHbBKjmn0f8qZZSbxpyoKA4DJM
         65EiKOrddF7Ks24yBXELQ3JXFBCsUI+5jZwDyzD9of932qYiAMq3w/e/mPVHJGhfbrUZ
         k8Lg==
X-Forwarded-Encrypted: i=1; AKwUvBzwK1b37+1RKQcAsIPnYYPhYYw00XkyyBF4NblsD9inzm2XVGYzpmwom3ngGm496HA6FP9b2xbzuQ==@kvack.org
X-Gm-Message-State: APuU4Z/cnnYj19gU4qZUiDvC/DGpPdcRzlcWQ3503Pz6JO/U6eF+6k+1
	1VRDo/POnqm2HTe0me2PMROKrV5uItGNPJQIMNarmDRnsOFuheRc8r/shwXdTP06zos=
X-Gm-Gg: AYBFou2PP/x7rv7SEzbZ4sWugtpOBLM4PUz1tSMOtmG9h/2GvXtlYzo3MkW3lEDm1e+
	b5cSDRXHKvlxolbGaOpV11A8Yehhj5UUS4zfNoK0rP4EJvVSFWxzF/GanU15AvVWCcGmn5bmEUT
	Ym4vvO4SP3ijao/V8DjRylxNgA/drCIVsyaEMVD6pHvd3cxjq39UTdzKP/NMl6STnDIy13x4yhh
	WSNpsOjH8fTDn1IrrOAVEPG+jG3STNBHSW0sZm5VNsypa0tTp9wVRiyTC7T6ZOMRG5t5Cb4ujwK
	HYf3L/2gzlybauFuheL2d8JvjiJ5/jxZxzOrs8M613yzK92mfGZebcT6jMtKwkZMBD4gEq9Fc90
	OQMXb09XaJArRWpxPTHFqp4Rwl0Lsg5EF6GfNU9++DjtGEyJax39XQwRl//b88eZoYZ1h7FGzCw
	ESaMbSB/5iPbLnAmGG/+8z6e+hgXHPkrCZajTsEVLOF2MciEHi3BNoIe8UM4WDYbN1dvF60VEDS
	p14dTy5igtEFyiLq38+0a0Fob7RPgjU649QEf85sj834OT97nfroo6j1V0mU+f0+F52AlPxtd0L
	Rdt0Tq0KDI2AYDGoqUPA+CqFJDFExTIN/MAogAVfgzAMR5LkEF6K+RA/MtNtbXQbuHte4qdqJNa
	11WTF7unHeb8=
X-Received: by 2002:a17:90b:37d0:b0:3ad:c4e9:7beb with SMTP id 98e67ed59e1d1-3ae8979d2d3mr14790005a91.43.1793859171930;
        Wed, 04 Nov 2026 22:12:51 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0b323a1fdsm2107528a91.5.2026.11.04.22.12.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 04 Nov 2026 22:12:51 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	loongarch@lists.linux.dev,
	linux-s390@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 3/5] loongarch/mm: disable device DAX vmemmap optimization
Date: Thu,  5 Nov 2026 14:12:15 +0800
Message-ID: <20261105061217.13302-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261105061217.13302-1-songmuchun@bytedance.com>
References: <20261105061217.13302-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: wm4jjsabaoj1f3gz8ire67s1jkeakku1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 35085C0006
X-Rspam-User: 
X-HE-Tag: 1793859173-610018
X-HE-Meta: U2FsdGVkX1/lDzPDnrrYMbyP50biMA9J8QtlAMtl3DO+TiX63BW3ujnB1BXl9HHomhXboisY0JrAwTiY2k3ZujcrMHXKc6Go7E9l6E5DNqAuY85cimZOiVk/ZCMjs5CPn1I6cBApj7ofv5+5cfKY+2ZJ+suBZ8QcCAcYeWehZFEhno+Ueq+fuzrMzDRViP5A76xBfQQ49CsweLJSmjKviuPNyI2m0JT5lGWWLedo7gdPWqgC5o3E3f58gwB45HjQBbP/96TTe2785lhQQOaNnylM9SEIRNQ860XLpjyI0k0f6ihFYfQYoZGoEHmJmsEP5LmxJQ7aLl7kZLEeZuqLa69fZOFqZHesolPoT4HsYvwRATPWwsDdGyYN8dnUxkZEGdikx60+3flVSCk1Bh7GOXa4Ki5ZzrDgTBYL2ZI24oQffQGGWPGVykujKq56pUt2b9Xpl6nzzC1HRI/Mzb/fMsRmpftw2Hb2C1ZISJQYB5s6b/7znWVKhpb125UTGxFYCo30LlPF430CUuV2coRb1cVvmCosTFvFHLdxI2wo//4BRbYXqNbulIyhcbtEj6sdxNlIIGcZ7kYFLksjf4qwD1eDFDh5IxMEhPVndpvJmQROKVy+hnus9aZHTlTjoSS95FQIXcYrC6uSsi9e5aqoNT/UFFGSk4t21NrXJd3Um6x8p8ZHASXrZIpOkt2QqbMhP6RUegzrD/XMevBB3LyqgG7PABoGn6s0W3eay6t/Cr6SsdswI7uRcjPHDjIWqhuaqcEnZ5X8qgBE95jzpCmZEIMahrg3YF8B7HfPjDjZ99sAAsbLNaaFHnTB9y620udEyAFws8G6JtfK5lTXSpIFYtuU9zfbRXrAvbKNNOmPrul6OBqnlzs4pM7YsyZ4mUk1AW6ZseYzHdoKNvWrLn9SYZcH3gV6KtMMB/hf8OBdVGFqVohb8+4TRFz5MwTqx9vqGqcrd/srS2KqkJSAA5q
 ICl4EkkR
 N2k7BH9lKLukwX8MBJzeSEu13KFcxXcy34jKLyoatWcF7joqJBllWufUGPx4YhmHfbaZHJp0oOuJSCRhqomgfi9SwWen4v3lSaijde7DEqQsS/2bcFV94cmBP/2gylimXGd0vQgSlkXRqQP37O5+ST2JFs5m1IhTkCSck3KMmh89kNzhPwzdQqz4JxdtVSMGrz2Bl6Ffsg3lrbrtUbeUrG4IZPmrgB7e4zfOolZvtaRdccKJ2BOpOfILm5xTFaGgE4IcSm7DbX/jzt3Z+u39E6/+EnKtKjTaFU/zBFsN68Fu5ATNUUkcI5pbOn2tTaCpduESd0eXdJSp8uSUEaWTclqco2uSzAbF3CWPUYP3iO3AM7sKqj76qDDDRuGTiOq3N4wgm1v2qwjbGfq7k/f++44Sh8aG290JVGcty8mSxsOizs8s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

LoongArch selects ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP but not
ARCH_WANT_OPTIMIZE_DAX_VMEMMAP. Its vmemmap_free() implementation is also
empty, so it cannot tear down optimized Device DAX mappings.

A later change removes the generic Device DAX architecture gate and lets
vmemmap_populate() decide whether a section can use optimization. Clear the
section compound order in the LoongArch path so Device DAX keeps using
unoptimized mappings.

This does not affect HugeTLB HVO: LoongArch does not support gigantic
pages, so HugeTLB does not use section-based vmemmap optimization there.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- New patch using section_vmemmap_optimization_disable() to keep Device
  DAX vmemmap optimization disabled on LoongArch (reported by Sashiko)
---
 arch/loongarch/mm/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
index f801f7097f03..ea769e479241 100644
--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -15,6 +15,7 @@
 #include <linux/memblock.h>
 #include <linux/memremap.h>
 #include <linux/mm.h>
+#include <linux/vmemmap-optimization.h>
 #include <linux/mman.h>
 #include <linux/highmem.h>
 #include <linux/swap.h>
@@ -143,6 +144,7 @@ void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
 int __meminit vmemmap_populate(unsigned long start, unsigned long end,
 			       int node, struct vmem_altmap *altmap)
 {
+	section_vmemmap_optimization_disable(start, end);
 #if CONFIG_PGTABLE_LEVELS == 2
 	return vmemmap_populate_basepages(start, end, node, NULL);
 #else
-- 
2.54.0


