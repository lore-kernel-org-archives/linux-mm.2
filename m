Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2A7BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:07:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E2D6B00C5; Mon,  6 Jul 2026 09:07:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34A96B00C6; Mon,  6 Jul 2026 09:07:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B846B00C7; Mon,  6 Jul 2026 09:07:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 997116B00C5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:07:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4BE8414035A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:07:18 +0000 (UTC)
X-FDA: 84958377756.25.8EC4DC1
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7940C140011
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:07:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jovIh7N+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783343236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6Mfmmv9Z1KLwW+rFeY1Xe/RVdzdCKnap/t46NltcPk=;
	b=jToxCU48R5Z+dQdNWNwjeBFcgLmZBlfkbWKLku2VlRdJNRG4RIp9E2iVAvzPH4BYJ+BWaL
	fP/R6nSv6mYqc6bfQFX/XGWqmJNHE9pbVeapQ9ECVOK9iWVQbOkEeodHHLDcDs7c7eQW4u
	DF4rMmcLmtbaWSq38TSoXeo3iMH9ybs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=jovIh7N+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783343236;
	b=IWa2mnqWUSDS8p3oIT6VuMvJAe8TxzcpyWgKAkJoSgRJpFnc6hzTJviyJmkOLSPUpvZyLm
	PSZSp55rPiyNrSgFGhIgr5njS51y+1pKuJTdtATuMYX8lzTLB4M04DxL6Cmo6v41egESrN
	Go6HOwmGlaLqx6e41YkTRn/X1Ky/B8M=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-473987fc217so334748f8f.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 06:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783343235; x=1783948035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N6Mfmmv9Z1KLwW+rFeY1Xe/RVdzdCKnap/t46NltcPk=;
        b=jovIh7N+hakve3qvmhogq3WXyFMm3XRgDXT630Rzjt+z8GakuE5PosiafOYHNTNqOz
         WbpQhP2XczsLrEPICsznZs2IGsArjDlLF3feNciZOhoYiiQWQnaHEwfKWO8peSD8Mn5P
         QvQDEHXeyjDNh5+8mOJAaozFXtLG/J3a1hrYnX/COWWYd9QVdC3JekZLDxWtI75eayI8
         U0u5MiENYrXa26s6+2OtguBmkZAZ0k46Hau6POrKkBQ97hJCyDCWHuClo6zO/GEcS6Js
         Y+/x/GYCOnR6a0i6dvQN1W/hDeWXkK+lu42HAfYqQLoS2EpEf2vVt7f/yTDPJeNbCX29
         uYPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783343235; x=1783948035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=N6Mfmmv9Z1KLwW+rFeY1Xe/RVdzdCKnap/t46NltcPk=;
        b=FAero0al7UbrDr9CPblZo47leim7G3GliQG9UmR3u2KHHu6JU1+KAQgbIUXu/zowtq
         Q0Rs97R79couWGxVMMNCtWMN7lJfp/308ukg0Sn5rU73B3k90MXd5QLAUm1iRrqDe14o
         LNJVr8F63QMFE/IP2neygY0h7RKvQTGJN3Ix/vnW9xp6HqRSB02b+A/Gz2A6n4O9iP4D
         U+xlF9wBG1QuIlVCniVLtKpuDutHNuhWTzuMHqIChM8Ni660p6aRekN2B6rH2UjylMUv
         93IA/vjDSZKxUPkg7j55JVhqXkyom2WkpL7gzkZA7Rokd4qPychpsdQIisnjyGJy4Gnd
         nAeA==
X-Forwarded-Encrypted: i=1; AHgh+Roc7X4KtXfc4vcV+LzNSLOd4gNiwtYW2PUpiG7rCirUy2sERsy3DC8K+cXaVzABJ/6RVC3h2czj5w==@kvack.org
X-Gm-Message-State: AOJu0YxaBdvcVT3LapDch4cccNewyo+FPcZ6XjmCDHcM/dMzBpdqX8Th
	6xPR6htZpd9aMTQ1Jw0mQm4SkaavYquP5M4UJvJpCRnsw6h7OngrZbLn
X-Gm-Gg: AfdE7cm/fCmeAx2bhmzkQARAhMroQxHKH9Kvid8pAkJkCQY5AjyXs/irKa8OkSt0EeY
	kHn5256sIsHLyh+m4I4mDIhjq4KzielFEfhOxkP/5IAFrLvoamfjL0QgCPBNHk5wbHUIq1PNwvN
	RxExoimzGKPOiST6HbeCa+S/uDPsS/LCpYvFspkgp+RWbrNS8GI6k+21d4jQBjsyhAMB4jcOlp/
	TUC1CuAUvEshKdwORA3n0w/wzGHapaIWECk0N8BoEMy6WWDXWhesCd367nJKpOxTBOhNJf/BQp6
	R6y9JSa8rNKNb5yAvIUUFl4bAcq2LToaAzv1CQebJWe8weWD4rDSRfk4JdmmWIVlvEvklw3gQrX
	Z2X13I6ajYvIYkxq+0dlwJS2NcJyQA9uAVfUT1WZim43LgqNhPzlCBNGQcjvd9GBC4aG+/WQHR5
	dGUSBQJH609n7U0yH0QCdsljYlP67h5WERC1LD9hGaO16TZuDbX0KJecraus/MtyKa2/7RQu9uJ
	4fApCRIdWY/UV1eKzHDDucYFgcwLVgixtM=
X-Received: by 2002:a05:6000:46ca:b0:474:2edc:c0a8 with SMTP id ffacd0b85a97d-47aab57d3admr4208341f8f.4.1783343234997;
        Mon, 06 Jul 2026 06:07:14 -0700 (PDT)
Received: from debian.lan (vmi1894487.contaboserver.net. [154.26.158.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1d8f1sm24515956f8f.3.2026.07.06.06.06.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 06:07:14 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH v3 3/3] x86/mm: add set_direct_map_ro_noflush()
Date: Mon,  6 Jul 2026 21:04:40 +0800
Message-ID: <20260706130440.9295-4-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706130440.9295-1-xueyuan.chen21@gmail.com>
References: <20260706130440.9295-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7940C140011
X-Stat-Signature: 8umhoatr9hjiamgajtjcigsyhqg49rqj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783343236-396820
X-HE-Meta: U2FsdGVkX1/r047TVdCszPTECv7+OU53PbXy5jaqMH4x7JjrSoLeU96DhSFcOoodJ6UJPEvucHCvVMtSXKwRqJw7YS0mpVfhDFFXGcyUFHASu/yE3lKEjTMyEkd+/N69ZMyGei/FozGmj6bPV2tY0TO11iSajN7VgVm66J6rVFiUzouIhE8JaMV7B34rjc75sETtu3mrZUJV9RT2UdWYvN7ud6Rr/wMk3yr7L3olM/JdVcskbZC8Z8i9CHl8MayZoSdlTcTV1Ky+5k+j9kIEYkFIa6BSC6lfEF0PFJUAAb+GcbxQz9ao+KeVeWgqtMmuTRwQ0yw5szywB5HWDv67vHZ05Jh4cbfTvdVV8V2Zu62sTeMjwU2tMms7WFNCCkx45WAeBMRYmQp4oaH14eML9r2CnGK0TcaQP3+q/Ywe3Gw1E9MYFsT0cl8SL3KEsg35XucV7aPZwQ7Aq58Ba5TYFmWIRmdAYHKgl9peuZLwK7eP3H4kCyQo3jgI4ik7pr3ls3pqeVXF0kiSudsGcAH3s4oA6fvYAukSyU1Xo71m7i+oGva5BsP7V6ayxBQsd+AKGDa+fAgi7vCCEEK/LFCQbpfyHyfj+AVH1iO0YrPjAIOIY0DVFpwnDQOwm8LG4qSnUy8heUfSQ0p8WpG3WifG0eNQxPHsEz7xvN0TE0vjSy0Dr9Cn0UCfTfFHswJkQ06+t9xBqbXeMAbUl9HKYfq+9tM6T2mBOl3X02oohim949LGOKj0udiR8Mmt5pHRoj25wFHkeeio//W8V+NNwTR88ZZPgO1cOYC7ojNRatLWELafIKcQLJkXLiz3gFDN9TsW4tFT5AJPpDH+DK7y7qETx0+xY4ualCN0mFbhBoR1KxhEvNoCNe9FA2h+eMe03tfajOGTq5ib24rNg6E5ZNogjUa5fD2UUSsTSBv8btMiL8ssVPTaWjWDTzUt/qpNVOd1/w5dSBtVsxd+DH0wUZd
 BTQwa5Np
 2OR+dxvjPt9T2hNpfiZRpl0qluUgL7vBNOTjM6M0I/NMuMJ/cEQUMAT+ThSrq53urRoDxA6VNAHr1fskbqoLM4lqqSmv9gMFe4GLlCvBCirkNSjbYlWp2ROlRZ/QntWcPd6yE6E2W7lsevJdkl97a4bi0FzA9y1fC1R8z5EbiJPMzZauqZ5DhnA6MCvi1CI+lq8+kAqSPIPzx6qu5K4KfYFYqnteA2MI3y4Tz2n2rfgKesQJNoPL5nOHE9LtDUA8cUUEoUdZrWB3DLikjqa1r7drOpDZcmyuhshRptPkxQm06XeFk4710QShp/b6GHO1RGCrH9r0b5lfY4qfw6uTPk114ICfd/CLsiwi/MgIHU3sGhhOuDcJBzs3jb2NXMf2w5qJb9RILrdnx7yhzBSEWujwFdok1/xnBkqt9A3pCtgQ+UqD3LRmJoXa8gBJ7mFUFL9LfKNIWeqsq3cvjMUUD2uf2mp2+uImyO50gu2IE0SDAn3goYFEXQOuKOsmdLMXDQn4xFbqqYmm1o/GTDEu4kWCOJP3DD/zCD0/HBJShmPePLl2N4KV2lGISqKozMChBMXYQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Implement set_direct_map_ro_noflush() for x86 using CPA directly on the
passed direct-map address. Clear _PAGE_RW and _PAGE_DIRTY, keep alias
checks disabled like the existing direct-map _noflush helpers, and leave
TLB invalidation to the caller.

Co-developed-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 arch/x86/include/asm/set_memory.h |  2 ++
 arch/x86/mm/pat/set_memory.c      | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 4362c26aa992..bd3817e06052 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -89,6 +89,8 @@ int set_pages_rw(struct page *page, int numpages);
 int set_direct_map_invalid_noflush(struct page *page);
 int set_direct_map_default_noflush(struct page *page);
 int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid);
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages);
+#define set_direct_map_ro_noflush set_direct_map_ro_noflush
 bool kernel_page_present(struct page *page);
 
 extern int kernel_set_to_readonly;
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..5987f4c84f6f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -2662,6 +2662,21 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
 	return __set_pages_np(page, nr);
 }
 
+int set_direct_map_ro_noflush(const void *addr, unsigned long nr_pages)
+{
+	unsigned long tempaddr = (unsigned long)addr;
+	struct cpa_data cpa = {
+		.vaddr = &tempaddr,
+		.pgd = NULL,
+		.numpages = nr_pages,
+		.mask_set = __pgprot(0),
+		.mask_clr = __pgprot(_PAGE_RW | _PAGE_DIRTY),
+		.flags = CPA_NO_CHECK_ALIAS,
+	};
+
+	return __change_page_attr_set_clr(&cpa, 1);
+}
+
 #ifdef CONFIG_DEBUG_PAGEALLOC
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
-- 
2.49.0


