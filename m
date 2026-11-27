Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D13606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Sh9LJthB
Received: by kanga.kvack.org (Postfix)
	id 1D2406B05CC; Fri, 27 Nov 2026 04:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA9A6B05CD; Fri, 27 Nov 2026 04:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073746B05CE; Fri, 27 Nov 2026 04:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D23B46B05CC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:08:36 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 615E01C2C09
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:36 +0000 (UTC)
X-FDA: 85480323432.14.9DB60B9
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F9CA40010
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Sh9LJthB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770514;
	b=nuGTn9X5DqCbd4xbqmtrXpckydQkYSJwiV23+9y7L0RCTKSXZQfXLc6MxymE4nFyz8EZQ2
	S4gV2tpgtE6mb1O4UxZfWFTVXbWqSDy5cl3Sk13/7RbsZDmHB/NNcb3Jf0C/6UeP08cjZH
	jPgs6jg6Wi4L9FbBY9OaEY3pYSW0De0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
	b=cWectXAYna6XADsQNQXtRTCYEGkh1eyBZhalXV0PIu7pka/7v/cwhGf2q8odGPlAaVz2SO
	mfP5HbVglE5FW933VV6wUy/x+4z3mjfOnAHlTzpmzZMSV83QZL1/UAEx2+/n8LgkcqVYmQ
	tpJ3g9qOrP8Pp3KWH3EBt/ae4tv3/5k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Sh9LJthB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-3b3d125637aso1562509a91.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:08:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770513; x=1796375313; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=Sh9LJthBR3D/foHjts9PSgukigpilVuEbbP3BuA7Q0NGuViNDVTMQ7JqkUlwWtUpXU
         94KR7NmXybtTEbil0z8bhldY4HO10z/kA4suiey9ybU7lrQ/ih6v1V9oLwzHnWToc6JQ
         w5SOa6tzHMI6aPahbsNAc0boZ5JzZZmBQ8qwBF0wbVsU65e88YA6P155+GQlwxQQ6Vqt
         k1kA6XVBrApb/QAOEZF1RCtPnDCNTiSmu0kWiwwcjlYkskn3+bXxvbT7uw6B/vO0+n21
         zTVT8YEZ6SjDIJoA08+NDOa5AyCgayF2Sbpi3b3NVG1MpujoSbgDRNHSryK6PjlpiAR1
         c7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770513; x=1796375313;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s7Fb6KtcWAXnUfcecLaSQ1H6J8YKvEJFUWN8A6hcpOc=;
        b=ZV8vYbn71S5lik7zTMnGFgPB2m7IhQIG9t22moh02HC4c7kMPsTlk9Wd0iPHxTlhDF
         t4KrRA5cb8b3B8S//V4nA3Ffq8i+NGso9pkI+avT5yqo1yW6Az8e8bp4I5quMPfKEQfb
         zlsP2HdFAD468FcpZE0DwaYCIoD/MIqxnzMgK8ngNW74/yFtriCcoJ+YbIsH1iGZwFTv
         3p3GlWlYJftqynn7kbcuYzmQnaxZVAiSqhx4glu8j/mrynDSOPGAp74rkOr+yyzdeW2h
         WK/puy+BNjHCpdXZwPIsOdRjDtMC5ylRiEPNBI7G/9ivYnh4/Zg0kVrz2nFg7HGRLEGY
         Mtdg==
X-Forwarded-Encrypted: i=1; AL+hErGB5TBtrk07A3dhfLjtmfdsSzByCk6OjfSfWMDVTl8pG9xcMr1WRxom9DF12/Mc/4KKArIx7cSr6A==@kvack.org
X-Gm-Message-State: APuU4Z+3PMSkrqZNTzQ93d1rNsGTVK36hnyLDA9jUYrSvCXCLgvzNHkz
	jD8n3K3fO5f+uzipMBK9O2wfLGOVBmaHOtrZpEMDwZg9X63YGUCIyEN6
X-Gm-Gg: AZFdTZfziRzFxiL1/RbRPUgoHE8UsYThorFwCrsLuSihQc0W3pyr/hk1J/t0hmUptG6
	BVWTyiOCOWfW0wYnOBcP3d2HDV4xPxzYgZ/fGQ0BvDfLa7tNEol8orVn2wYfUbKT0Ccg4BjCgEi
	sa5pQFASaH7Kdo5o0+LuqyOLFRjoDSR+CA8ozy0bMhCFFTRVlpV6Ci+MnJcfxFlDISnHBkOiyJ2
	FDfMpuitMwMaXT8mRiNiCJ+CmIpi2TRE/pK5YvJnVPr3RlhIQgjqR4Ztt5L5A/uP9vibwbIZVAS
	hCJJx8LN688bRtXqR51No1CK23RW8YMdYmy7Fm7Zm9bKsrZl34yJPQaJOmlKnK8N22ZoxMPd9Rj
	M9L7bqSZV9rZM6JwmFzCOYCeNJg9CsvheDgIas7lxAhxAGmrmS9thSqMlWuoA2wzmFZ+O6zTmeE
	cIBEaG/txTzrnyNfStQHzwFpNgwEnSjyj+YB5JbiAFkmqdA7YAqzKI8B7n0tSd4q6SRrCELPfI6
	nYTf3BJtNahp12AhVTyU5QrfEEPwF2T8LcexKnP72eIshvtkbtmt7N1S+LICmJP0E/zxOHOzX5w
	ESmHX+mNI45zwGvwSaMySEuGPnT2fnFe/dFHpe1ULg==
X-Received: by 2002:a17:90b:554d:b0:3ad:d29c:5e64 with SMTP id 98e67ed59e1d1-3b41c9b361fmr22966937a91.65.1795770513277;
        Fri, 27 Nov 2026 01:08:33 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:08:32 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v10 4/8] crash_core: replace for_each_mem_range() with for_each_mem_region()
Date: Fri, 27 Nov 2026 17:07:19 +0800
Message-ID: <20261127090723.741253-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d84dja4kfd66o1m98sfhbjapjxd4aqrg
X-Rspamd-Queue-Id: 8F9CA40010
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795770514-989748
X-HE-Meta: U2FsdGVkX18zCynFlb6ssvlyjPteexCGf9moQRmeIS79qYFYhZs1B6cqipGfVspueeDSWLi/R8Bzy6gBxSgokaZ6Ph4QDF7c3ry7A8iRsmjSZj32weN0MflKpyxX3VvSBSdNDFNpA8lmeu3u+Z4TmdpV3ToG9Ytwc+DjFCn0yPOE2OAuBCjXKHEA3JOxChetKLPa1S5dN2F8lf587Dkmbez3BsoiTqR9S5DI8vCp9ROeD2+o2RVZN9Vl3MFPl5Xtpe5IVoCYy3bwys5tWMpt1w8milGGq4E0vFpZIKLPZ7Ibu8lyGElLuSmOdaaRxSQObwFGdANQo/AH8n4cmDLveAySrtU+rRUFe0Xs1u/cMhpbVgBJOmXJtgApQHbFK/CG7slcFoDZykwxIH9ZrgDFeAjtFAQqwK47rugenJlmCMEp3KbeBUwMEtLHGCve1yt3ptgS8nljkpSDvZa6DLuEBOqmYQYXUPGezuUoLrz8bvRTMpbzM88iI2o2DCBnsx1uNYS4eVRJB3JV4NL23aj1d4qk5hKT1ipt6uAyn00EnzIrJGyT3VCR2pVraZcMgnZpc7dy95EpcQYxzC5jqxZCT9gX3DDdgH/e9544KBJp7VXjS611DZOFpL/o3MzcDiUmMJaBsFTDCkO63H8ru71k5JIwY6EhkP73q9Fnvu7yTYYvXQtbS1blSe3aWfxAl5KsSwfdfoYuvoE9Rq2rfZdJbmW/ob4Szcq6/PJc0gVUvYf1qv7avRu17S2qtb1OPRNehdQSYWYKl4EVushcKwho5tV59L7l2A/blHZLKedYw9pLOjLgfzoUtu9svrxMIF1cB9zpcpQWTx1I14LF526+4dDHvGxc2j3Nk0QSLP2NzpyRg92FTZHVkqvFA3st9HyTBU4v29b8is7ENULlsC7VKOiYrwgVv9hCmGGl3I6njWq/8G5DZ+WnNesmzSUBZBEcOYb0I8SCbhqjdTVbGen
 LkQQMIpW
 dYpFcvy0GWTBLMhexNYrCM68O5KtFK+3Pn4KA9y9nEzng0m4yVP/oQ5/pGz6AlVgsgNMHLu3dkx81bBcyuxVNvFbYuCj/t/SRHjM4kUGuuui2OWrzlntKwpZL/EdMjapuBp4Puh6l8SBdNHUkB36l4x9n1n+sZb35zY6R1mlUDS2CPFkxFGKpWkfpDa6/k2H6JnioyfDSwdQ2E+fmh0VvmjvatS+4TKDKMixBczj0FmWABBt8+tRQH4GjPqNxrZ2lO9fP0UqDWY3mTmWDs5WZoNz/UdJA5g2kE8mBRT+dqtko9i3/5JQgaY4D1HfYa4gE+iy3cDHNtVDM2DA/rS3fKedt3kDAJ1SyC0fM5xERly99T/xpt4e/rubWhD6GitWLVylOdoZi2SQjgYV6w3S5Aa5QJ+KKfAFgT0gpxfRKr1ompmVPOZEOwQOydl9UPYFtX9G4hYbljUpndLsc6zcyGFwXHN7kuHGavPkx6nDPH1YXtJM52cJm13qjizA6reGLeOXJ8U6tWQ/r0gIh+YPqgNzg1ckoMKbZPOwulrbvMorWmzS+Zj9Hhv5fzASxps5mTEAAQoF5b1oQjWa+NbtuVTk0oC/iUJ4QMfKoYqe502cAB4bZYiXcEj0zmEz8RT7E+xss83GjfxJHnEQu9Ix3vaGI0xvujyC3ZQG3k3YKZ1Wyk/LMlGlNsJTzY/WM0pE07QpVr3JmGgpP0Gr/QhREXsdDdZdtej9hLFGKLfU9ZUjBsilNWe5SqIGPYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
weak defaults to for_each_mem_region(), which exposes struct
memblock_region and per-region flags, and filter NOMAP regions explicitly
via the new crash_should_skip_region() helper. This prepares for a
subsequent patch to extend the skip filter.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 8a861a946e26..e161c8b65e00 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -283,25 +283,34 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 }
 
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
+/* Exclude NOMAP regions from the vmcore. */
+static bool crash_should_skip_region(struct memblock_region *reg)
+{
+	return memblock_is_nomap(reg);
+}
+
 unsigned int __weak arch_get_system_nr_ranges(void)
 {
 	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end)
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
 		nr_ranges++;
+	}
 	return nr_ranges;
 }
 
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
+		cmem->ranges[cmem->nr_ranges].start = reg->base;
+		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
 		cmem->nr_ranges++;
 	}
 	return 0;
-- 
2.43.0


