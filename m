Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28A9B606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=RIsrkbu3
Received: by kanga.kvack.org (Postfix)
	id 9BFE46B05C4; Sun, 22 Nov 2026 13:45:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C706B05C6; Sun, 22 Nov 2026 13:45:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838BB6B05C7; Sun, 22 Nov 2026 13:45:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50DF06B05C4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:20 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D72E41606FF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:19 +0000 (UTC)
X-FDA: 85463632758.13.33603B4
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id 29C8A10000D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RIsrkbu3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3PDgDawoKCBk8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3PDgDawoKCBk8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373118;
	b=BMZfYHMYSH6MedMPvht56h2BiYXWDPzOeLdZkv3rSznRHxkaIxJlbP//dBpmscoDh4L59/
	Pl04Fxq9SmVX4qbyr6OtZxAbXO2Bwy9y+ea8ZnJOvFHp9XcMbzV/XOA3O5u9a4pHO2LAZM
	KrPRlHVliSUnl6bEeV3voHxLIA4ul/I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqxkE4ochVp788mKakiWH9CZR2y6Ff8i3F/s8pOPTcw=;
	b=NNGffhyUPUaFLXCFDDsk+sU3ySpCnszQiy+qG647UlwncrfURHCefQncQHjMLZDfMpeUar
	GhA6yjrRlLNWc4tZXopsyB9e6rr5Ktckq0zDa9IDzfuhiufmaiyO+SCKDji0OdCC7z8MUq
	V+HoAlx7x7SmdFiTK0OyO21e83Uk8iM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=RIsrkbu3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3PDgDawoKCBk8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3PDgDawoKCBk8I6DJ56IDC5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jthoughton.bounces.google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3b456fee3b2so957033a91.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373117; x=1795977917; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oqxkE4ochVp788mKakiWH9CZR2y6Ff8i3F/s8pOPTcw=;
        b=RIsrkbu3M7nTv5NXwKic/tu34r3eDxc1s2jC0tB4eSDL8XBT5ob0KMdCsHj92IiTxr
         0tBKHJKDg6Tt0FEe9yhVDMwkk0TdS303iqRJPP4GPgktnUiqUr7DsQ8upUjpPxMJ9Iak
         qUyomknz/a11+CRT6GLu4KnFyKYo5Tf4qjS2IXPZLhiC0pSVFltE0RwS6SYfYaDhGk0m
         63alKUXCc3rGeJZ0Wb5E8vgkvT55ZJYsCWDD+hJmWQSh9bYq+GjttXNvW97SIXkfxpPF
         PL4/kC6twgKgHr4WKCfs/K6au4PAPlK7/U5dBnUIZxcCUPDKL1Mhty/SqtJ9w/mMpVDQ
         9Xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373117; x=1795977917;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oqxkE4ochVp788mKakiWH9CZR2y6Ff8i3F/s8pOPTcw=;
        b=pPRaCwoXCLqmFvLORj4wWWQCSRhJyVy1TVRBEReZngzxXh7gXTY6C04Z5EemptqyBO
         iZBuEK0/XjCfT9ZuNEneke0ovrIXf7kIXzjzCp/ialWLsQOscehw3bjHgZQfurq/WCSK
         qh2BZePlTwx8W0oCXSQ0qJznU6JRwAqTvaOifK248zFNsBEkPRMIN5Hv7o7CJAatmaMr
         K146OOlbDQavwd6t4sBi8qCN26SEGwNLLWQ4SSLINl6Pe1/X8lZN46MLmb9mnwZ6WozB
         V/mgI/oEWk3fLbKXS5OiroV8V4D4gHzlx6h0xG8SrNU2h8Qu0HXQD62G6okN+9mMxzWZ
         eViQ==
X-Forwarded-Encrypted: i=1; AL+hErGwGELO5UUdrM/M4gznW3El/FIv3CCOQFFg5OwTVsPwS/sVugK+XbyIo5MBcZvE28NmB5ynQcuOwQ==@kvack.org
X-Gm-Message-State: APuU4Z/tb5zCr/V7/QlpRv/TK6NTdhNCygnHmwB7R+d8yrePBibTK6gh
	MfTd/I2tBFZiDO+XRpX0nKcXh5aaFe4Gf5bjJbPhb6WtQco3sggv43B5Z7WBx6/MdPTg3e+ilNv
	TctJzli8gMRRQRrZ7GriaZA==
X-Received: from pjyl12.prod.google.com ([2002:a17:90a:ec0c:b0:3b4:2165:2e77])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5543:b0:3ac:6fcf:81a2 with SMTP id 98e67ed59e1d1-3b41cb33a0dmr7946054a91.57.1795373116556;
 Sun, 22 Nov 2026 10:45:16 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:50 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-17-jthoughton@google.com>
Subject: [PATCH v3 16/19 DO-NOT-MERGE] arm64: Implement try_populate_vmemmap_pmd
 using AF trick
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29C8A10000D
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: rp684z4yz3bc7cmgnybtp9hippnzc6nd
X-HE-Tag: 1795373117-259430
X-HE-Meta: U2FsdGVkX1+9MT5coeRUl6596a5eaN2NuvLnJmtn2npv3WOHVmLntaIzxwrbAt2xIeP4Vav98uc2esa4Y11dIQkoHOgR7zm+/szTh3iyiVJZttvcOocUtq3HtWtKsyxtt2UowI5ia6R5B2XvqpSCquwksqOTGVzuU34mKPjv6rmjmG3RsU4MxJ11VVrVveow4MEs1oNgpGj2+r9Jw3ipHAnHi641mdP01MNoIIm+oXCe43th8cucxr5/9eC3IimC5MaxNzsymKoUae7FxWodhC5Ecll3pqxDn2VjPBIrCAyb0mHKzxifj1luP/VcrPzzh7Z/31ZdrhfFtpQLu9SY8HGcYD6om5hLXgDErU1naLcX0JSJ2XuxXycAvB0oXoyM6RTiKKkZCkTyrrXlKcu58NQJNZhA8ZDsOZE3TuWH+ZHHbv/xetPXoLxZCwq+cngeIhUnbIYcySUazvV9hSKy351skCychYdCdEBZELzr+96qiEauxoCabR4hFpS0HX/libqQjaLG5e/6GY7/wVjLBWmFgERChEZtvWPr57VjYTQk3ZJd1lI6mAMauUXBwyUbeRKKRIUFSzoCnTVF3DkIP9/BQPhLWLgc8aAWHtJLFiawqd5FJ7H5Gk9bxUC1ZX8ZlBMxdYvwHJpxa5UhY8zKgDEzcIunpmSuRsnmi3T2lzFlH8e80YB6+0DdtekM75qzWcVsNA5aZccK2wkoH2mtecu3ix+cdopcqA7E4bi+ee/p+2j3EWcdINUi0teP0xIWJAnyCqnd463oxd8cav5pXE2MdinyXNKL8XZwhbFsFUgo/dpkRFjmkXLSbwHg+OyQ+BPgAHJuxrzUyv5knxOPvxk5kcp6Az8Ps4PhE0EFC5UIwybU6bUlfn952lPjiLsQXJdTa4J1+gD3HfyY6apet6z7NV/YRHgYjI6lgx3u6I+dWDkCXrORy52iB5yKFwEhKkAVx+2S5BGbQVZ3YyB
 w8bHv4gB
 g+PjvD2IrnM9AxQQoHvSMXtm9evahtiF/L9dWLL0D0epBW49/6yjumre2oxhTUCg8xK5XkP2zqix19IDPRcSSk35NehcPezpagyhf6wFlE/gEcKrMZJ2KoeqhRqG+RxSYKE756ip5G8QX2XhTiPxJ6nzOrkufsNzD2LuqoAu0KYzLknIGi5RzrKdgdsOKdI/XbmtjWzP0Y917D2JVW5pj0In6m1JhuZYkrSRDyLEkwv9ogsgC5CMdpy+riWNlWEaJ1aY8rxa9quwTcR0mDAbUhI1ubz4Mpx1+b3JYuawkjznsrpmz0aTPDaY8gNeKgTCxfk6/yhbOyNYmdXf85Puc5hVrjRrkaFCha8NJP/ceQ5pNp1T70+XYUEKe/2zrEG0ky09y9rppf8it3ET2QK0ExfCJsnbQTlNWiDhMbApz+FHCtn+Gsr/ajDIYNPcc2HpoyCFq3IiQPnMiKOURUTzyYeCKJJWV3GOtyKKrI2mnGz6agymIFXM0bgJBwtOJ34CqyVEaNQuXzgpshPWT27xKYKLSc27/q09EthYDKj/vnr0IUGEiSmoRBMBFAoe5Mya39LkJnIsNY1zH1wwmxeko57uTh/p7w9NwR+ne9CDZBjqM8kAKAL918siXdDtXRkv77d14ao83X26VkF0b/Wm79wzg24ILD8zHeZ8Yw7s+oh9xJ1EpdjjDi9MlyO1auRy7wx/5umvxDaZTMCBj3bq+pnS6gbL31bOSII6UE81OBbYdBXLblhF4jN3hr+kSBSF8NsGJTBX5A8+Lx8TXVXuBQ0mNJACIeR9FIp2bs9UyXViDxKXXfz+JAeNOtOnQaDUyGzco/Ig5+nf56kpCcVgegFdHTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This routine is to be used for updating in-use, leaf-level PMDs in the
vmemmap without introducing a window where vmemmap accesses might fault.

Implementing this on arm64 requires some care: use the same access flag
trick that is used for vmemmap PTE updates. HAFT is not needed and the
TLB flushing routine remains identical, as we are not overwriting a
non-leaf PMD.

For systems that support BBML3, there is no need to use the AF
trick.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/include/asm/pgalloc.h | 51 ++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 0263329fb7b3..7e304f01ce6d 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -124,9 +124,54 @@ pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 static inline int try_populate_vmemmap_pmd(unsigned long addr, pmd_t *pmdp,
 					   pte_t *pgtable)
 {
-	/* BBLM3 is required. Its presence has been checked. */
-	pmd_populate_kernel(&init_mm, pmdp, pgtable);
-	return 0;
+	const int max_attempts = 16;
+	int attempts = 0;
+	pmd_t old_pmd, new_pmd;
+
+	if (!system_supports_bbm_through_af())
+		return -EOPNOTSUPP;
+
+	if (system_supports_bbml3()) {
+		/*
+		 * BBML3 allows block->table transitions if the PTEs underneath
+		 * do not conflict with existing, potentially cached
+		 * translations.
+		 */
+		pmd_populate_kernel(&init_mm, pmdp, pgtable);
+		return 0;
+	}
+
+	new_pmd = __pmd(__phys_to_pmd_val(__pa(pgtable)) |
+			PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
+
+	old_pmd = pmdp_get(pmdp);
+
+	do {
+		if (WARN_ON_ONCE(!pmd_valid(old_pmd)))
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(!pmd_leaf(old_pmd)))
+			return -EINVAL;
+
+		/* We should never get a contiguous PMD here. */
+		if (WARN_ON_ONCE(pmd_cont(old_pmd)))
+			return -EINVAL;
+
+		if (pmd_young(old_pmd)) {
+			/* __ptep_clear_young() returns the overwritten PTE */
+			old_pmd = pte_pmd(pte_mkold(__ptep_clear_young((pte_t *)pmdp)));
+
+			flush_tlb_kernel_range(addr, addr + PMD_SIZE);
+		}
+	/*
+	 * Translations without AF cannot be cached, so we can replace
+	 * them without BBM.
+	 */
+	} while (!try_cmpxchg_relaxed(&pmd_val(*pmdp), &pmd_val(old_pmd),
+				      pmd_val(new_pmd)) &&
+		 ++attempts < max_attempts);
+
+	return attempts == max_attempts ? -EAGAIN : 0;
 }
 
 #endif
-- 
2.56.1.809.ga0b61035b5-goog


