Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B43A606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=n9w9ghqs
Received: by kanga.kvack.org (Postfix)
	id 4A3576B0676; Wed, 21 Oct 2026 04:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 453F56B0678; Wed, 21 Oct 2026 04:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 343666B0679; Wed, 21 Oct 2026 04:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CFA56B0676
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:32:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 059CB1404A5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:32:38 +0000 (UTC)
X-FDA: 85345967196.22.367FE68
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3E063A0008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:32:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9w9ghqs;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571556;
	b=0q0OwSfoUgIGIc40sAs41XS3eFGuQtcPk4J12dCMTqnfUyUSwG4hxruNSyyOitGaT0vWxY
	3Hk5s1R6IYTXYIopYMIDHecwDa0DC2Cv15pGfvJqPAOk9l2fcucg7rYuTKUJ1B0UenSeGf
	9TGJddQaGXJIlnr4isV4h93vjmC8w8s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9w9ghqs;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
	b=Hpn2iOvmyoyJY9GJbX0ciI3CC5WvbMvKARRdrd1YPk2pBB6SDSjlTdJDtzEPKy2tXL/bxB
	P/x4aTj3Dv6kzdcd7vH8414psX+SHHyeaJiOrq0jZRdzsNLMovQdZ9mjz8X82GoCXSMDoo
	vizJs0tOp7WhqE8wrcQRu5LcB8viXJ8=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-cd63952c9f2so54632a12.1
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 01:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792571555; x=1793176355; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
        b=n9w9ghqsiPjOgwE+Bkfqkhw4xgBHYz68VexvV1rq6/QuN7CqH+z1AiC5wn8q0SKhIr
         8pIDX7BKNpgYxM/mGjtWeEMOmkvNBdzFq5uKzEvruGukHKSD+fxm2MS8iar+dYe2VQX9
         0YuIcof6Hq/Mog68wa02oRK3uwzJYOOiSGjDFebzNf6BxSAWsVoRQG/8p9RRRPUE9uac
         /R5bWwJDAAUoR4TbQdM5TrCBjPNRK8gu40+t5TqUpIEngZdrrqN//scQCsi+yYVMsoAc
         siV1G3wbuyGyv9jzyfp6KEYTVAncnZDnv//e/UaA4WUHpl/5SWaYWHhHPEth1KIDFTAb
         YUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792571555; x=1793176355;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
        b=1KYtzlwQe7DJJ9kUNGnJ2ps55Tj+g1oUDM2rPCoEb75pEZ//3WctlVeMKKUmY/YnQi
         WexD90PxGN7GwA2uu3SWR1BJE+8giAJ2QUiuqPwpKRwPlv0WFzXg6GJaohoN8vWuEnl0
         NJDFNX4E38IGjU8yEfAvmRTIUH5OvwjKZ2mc3KC6zTi7ltXYcG6vsAY54V309OAUceZv
         jqyU17M1ebnENG0rBdmXxqnbpi6X/vLrpYdavryg3CeWRMkcfeBtRw0SPypBw/4ocxDF
         cTjFnW/p3pM2e6ae78J/0gmVBr/00yxC9NWQcT/G52pqFAQKjO/rBJReobMueh7WuT4C
         s/Vg==
X-Forwarded-Encrypted: i=1; AKwUvByw9wvekL5/oF2I9ykonKSS5bftq2jncfN+dxkFWluLLkG7aaZNROEiMxz7ESRY1HIZgU9mpXTUqw==@kvack.org
X-Gm-Message-State: AFq9FYIULEHWWXO2RqN8y7ImnuAr3xyFMND0I9HdT1bqqX2Vh9KecOPE
	MnFXygAqWxeUW7KYhOU4m9bMyLrufUL2AJYngXgWze6R2RUrDHywSgg3
X-Gm-Gg: AYBFou0CZ99PY5Cl8GgekfDFqC+8DvWg/udzYyvKl/S9ib8fVPALQyDqpu6Y8JYSv7k
	t3yHgBWWVSfyCOfzroylpfWLr+AFnkn63nnDGI3iERJq9Qar4yeJIwirf9UrD63sIhpZ+aAMVA5
	oRPg2Xa/rpRIK8Nq1raq4oVDRJoEtbpzQYn3rTSmQsOiJ3kopgVxgTDuCRuWF+oXMLlbu9tk3F6
	sJcwI4g4GPjAcEoARulaGFWKiSK2pndHeDtgPEot2Qk+pFSYrxKsJVgNjFm+tNVSJKgCbwcDUIJ
	tPi9LAiZiA0G4NdjEsjiIFkZnaQrgrCTcxDlm0e6X24d7F1lqCB9hIs19ON2tPEfIeIrKpBLjEC
	qh/KPwGQaJHaESl2mhhZDIn4UKVy6eisatR2SqZ5FkRrcRD9kVC+GhDi9tkhaq7zVJJu0gMVDKC
	/Kt3MPC3pu4XT4e/OpE/XocgNRsUI9MpJlEBobM6cxvuiHvvTssXw9A4RMZMzPYSiHqjOyRhAJc
	RHdDC34wKV1KVDvAiG83r7trRpLXqawMzWNTuqOZZfsQ89xRdHHeDUDgdbzxTwV901l
X-Received: by 2002:a05:6a00:1786:b0:89f:3f60:cd81 with SMTP id d2e1a72fcca58-8a089d539cdmr1130152b3a.51.1792571555108;
        Wed, 21 Oct 2026 01:32:35 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a0895e273bsm600653b3a.41.2026.10.21.01.32.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 01:32:33 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
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
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v9 8/8] crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF header
Date: Wed, 21 Oct 2026 16:30:11 +0800
Message-ID: <20261021083011.2170525-9-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hiimrj1xra5kdw1hhsc33718gf988bjz
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3E063A0008
X-Rspam-User: 
X-HE-Tag: 1792571556-583113
X-HE-Meta: U2FsdGVkX18oYcdKlYUoM2D0Duj32Pckmi9pN4U4Ix/UsS07i9O3IN4QHGlR5T7GvnYcy8IPRoeBPor3MwCSOKUn+FCfh9PpgbUytoHrflhfMZR8eiLCT3gtAnUs0xm5qNNKKEx/RVyQpZN9drf+jHs+MyCbkoh+KsgWXkdESwOgvF0YGxvq66hztKng3oND+RgbCnvu5aKtG0LSWLced66yF7tqHtNVf/NheaMQuvmnHRXiWtu57RSQsbGXp/VPZCKb3NY7LEYHSOmWCqG5elS5d0wZ1eaHTzNIfp0D+FdAa5CJgtf6t6CE3EezDIONVS9DHpW1gXa0XxgCy1o1Gpnwb/arXDyBS4gm11lDVtnNsY9wTU790fTqUU0IMP1K5FlDFBvaaD4xKZh/Hla9CTtlX7wttik6kZlK8DfGsel3sohwtki1uyjLwt510quB1ekNt68pC6XWp+5qF0cEoQKRRYkYn5SPdGzFWeuurWKcuudp0Qm8Wy5CDDVOdceCh69tdavNGFkWssRbXm8kW0o7hdUQ4j1AVPzhkJnBlBkHJ4zDo6s/nIEhFaZMi6DaJQ5Y06SsQJi77+3JsRAzyfAphJX9xJTn8J9tlUMOvUZM7wgRoaRDa2a1QImqXmydY4oYBAUJkHDTl8mIDhueLZp4hc87nhiU1qJpQ1O7lYQm2yCWK8sHA70/4kTW63WWrh85qNLbeQXQWDPaQRvoe8ofbiQq2+Qa9GtUzfKs1Vv0ZThmtJAukK84BYwdBs/uPP7u7WVMwNdufG3PhxUM/Vek6exlolYecuI4jZQiTBx9UMipS84OILL5Kg9itKP5SktfdfNrYrd+xpb1uu1eW6jVS7HD1qpFFfKSPaSmG/9HZDNed7YOLjIWfixwCpwXlBpP96FBZ0qgSJj5JGYE6A9DdZYX1fZeydHj1+KmDo9DLh6pDgVcV3gDZLjOAinz8qAJsSJQHTEH64xEGgW
 oO2FUgL1
 3ZoyzP1w5U7KErBCsLylzPoStU/oU2TB4ULAS9GKWrK+ybNn6v6nyC4aq581Sp5kcL/2yDGNZGavBntU53lKt7HMAngi62X4pE0uAIPyugwgv1DLmqXh4Uox5iort3qWfckXh76blP/UcSsRNhKNLagFZkxO3rqB9sd7NKxXZmRzSsKaA7GVS9aSDH09HKe5k/KgC9LrnUc/3KnNlvrkfAncU8D7YydVTX+UV4tdWsGJUEjB2g9gOYkKf7nE2XvnOs5/H5mdzQLyp73T94Y4bsNjyn6rMajq9m3cHRu98c4lzYYg5hgj52T4uulIphUsoxjf2ZVcQC9iwRnyh8jRbrDQDCQV1ZJXEmG7Ue4eUdqvWvzNiQbJQZniO3ADzgkCH5WffCFd1Qx710OSQp1Z6Z5jGpWDzZGZZ425/8MAfan2KlABLAMStu5T0AtI3wLPAttS7u51GX7qNQq7NcnlinKm0vQnpOQm6IGQB7r+EendvTiiF0EqyRJwkRkyQ3t7NG2HWc5B4Rip860nPMYCgHu0dWr4kIaFr78CDH87B68bUMB4P2fawF23NLKxPx00wOM2kLpKvrvJ4Qb4rOee1ye3aZB/J7xpQjrKcfO8bltJG1Oj2pLBPf0Xk11fyyve2938ElopxJkA2Xv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Reserve regions (for GPU, DSP, ...) carry no data useful for crash
analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
reduce vmcore size and capture time. crash_should_skip_region() now also
returns true for MEMBLOCK_NODUMP.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index e161c8b65e00..0e2ddc933b22 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -283,10 +283,10 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 }
 
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
-/* Exclude NOMAP regions from the vmcore. */
+/* Exclude NOMAP and NODUMP regions from the vmcore. */
 static bool crash_should_skip_region(struct memblock_region *reg)
 {
-	return memblock_is_nomap(reg);
+	return memblock_is_nomap(reg) || memblock_is_nodump(reg);
 }
 
 unsigned int __weak arch_get_system_nr_ranges(void)
-- 
2.43.0


