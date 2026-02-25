Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9B2EFD23D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 11:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A066B00A7; Wed, 25 Feb 2026 06:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 526E36B00AF; Wed, 25 Feb 2026 06:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4619F6B00B0; Wed, 25 Feb 2026 06:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32B066B00A7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:05:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0A3DC1F8A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:23 +0000 (UTC)
X-FDA: 84482697726.14.63087F7
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2016CA0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:05:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cg096q3W;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772017522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oY+WcCKwH30XQgtGlAXxD48kd5JWxreLKyCXwqlGHN4=;
	b=1tcoKLdqnNm23I/WYe16APDNrSHujbxmKVkx/Rc9v2Pyh+OUPXZlUhWDKny5tWn3IZ0Z5I
	eR86NSVBMbqdiN3EveyyofJs8GSApV9doCGMbjKwD6D/Mico3aKamLUi+ZfoB17A5Zryrq
	85hCcOPUFcQmp6J3jGGAMLJ/sUKg6io=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772017522; a=rsa-sha256;
	cv=none;
	b=S0xLzH6dnIjOCChTweBhukZ2S/fphw97G1mLLQI/5ebeVYC6yOplksm8vWF7t0AwfE+1Ny
	ofcnBN9RZx2OhlMgC2dQKrPCTESjZwsd/BsgnzVKuz4TfRNLpaWUOG8cNiPA4owcelGnGN
	au81FR1+7wh9fwV3GYJAccHC3zBZ8N0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Cg096q3W;
	spf=pass (imf25.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ab46931cf1so5004685ad.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772017521; x=1772622321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oY+WcCKwH30XQgtGlAXxD48kd5JWxreLKyCXwqlGHN4=;
        b=Cg096q3WpMJKBerM/CF8ojam9+17Hh+8kphNUDU9GFupaJnr/bk6y4oCMAu6zyh/Xl
         qIpxIUfvQhI12WSpoL9eCVv2fBp6pphaF4Kjw2tIwUIM8D9Ki8xVcLLuiR49oL3gAvuU
         UG65RVXIT+xw+sLR6E2GL+noTvjB7PYZdNd+yntoOJCDEDayz/GDMuwFuL9QOG2qgl7g
         JCO2BRMDW3hWn5sYwoayj/JTV+N8CX+zGnpzNpwQbx9/y2asjPUoYb8YlyEZbqzkkvlN
         ROpQrhumS+IkTrYRGaemOHweDtowgxBwrBQMHEc9kzVojMxHpa6NrK/0Caw6D8MiS0c3
         6jgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772017521; x=1772622321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oY+WcCKwH30XQgtGlAXxD48kd5JWxreLKyCXwqlGHN4=;
        b=ChpxYKz1341K04QPUBpP45EdcEM2+qBxfTl7OLA+eUH6NekC29be3DBFa5SiiwZpSy
         ZxgdU5/1gZ+rjTf4l4WrAIBx13njsZ1tzA8O/KPGv1nom/9e4sWY8kTuY9bW4jJPq9qq
         TGjhmCWLHwA/NlAYoB4veDsQ6Qlo6SzL2u14ivbCINd8b9VY4oKnX3GuGrfyAasRApUh
         eaEL2xF6M+3FWEndnhqaPGaEaEDYW2l2NaGZq6WqctH9lz5yLA60Zqxu7d8zdjVJ3sRC
         JXnWvLQlymCfC6StOsC67abps6u8zijZHdbl8g/o9jTYSfLfSvNFbi8MwIvZYLIxRbj+
         vH7Q==
X-Gm-Message-State: AOJu0YybYnsAz2s/rDfoiaSrgdl4GeDMchi5aq1v8nwe+dET/8ZN9YVg
	vucqc43lyMkGQpMSs3tW3akxQElh+U+KveOwuBSRHx8q++6VfkvLn733
X-Gm-Gg: ATEYQzwNAOxPK5tXcYct3OuqyW+eXBgJi9sSxjZOPWc1409ajZ0r0NpQOg7U5+UhyBf
	vV/kuK7Y8P2aLDXLVRQNPBbhTJTvKGZx/MiG2HOkOsCuJeto21pUMLW+uDRRXijf+ArWBU8VXh9
	2FrcTqk8KUy6Qu6vgydUNtvl9N5pEJqx9TAG4FNzIOszENWlxV1wdBUdtOYIt+2mLuSPbtPiaq6
	o82LNBhwxCSVM6Ip3Yql2w9sydROOYQ5O9hWI3XvD4zj+gMSQwhYn4M+ynscsetUKsW5Hyado+8
	iQ/YvIeQgir+iCtNXI3+4WfTXBP6PGQQb/v3Ps1eCRPBE+Ytwsk8KQQXXAj4seA0J9oMHwRyGZL
	gNduNA6g5MQ0NzM7uaL7gKr9Qoaq9F+IXINjrhj4HHLyZ4h6UxeEksj7wEkp4enQRWBiHvHqgNp
	7HrTymWodb6RUyZKjsRG/gFio1S/rY11DKMm+RCmnZ4g==
X-Received: by 2002:a17:902:f792:b0:2aa:e55b:22c4 with SMTP id d9443c01a7336-2adbdc4a59bmr27149245ad.9.1772017521044;
        Wed, 25 Feb 2026 03:05:21 -0800 (PST)
Received: from dw-tp.ibmuc.com ([203.81.242.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7503f9f5sm138365975ad.77.2026.02.25.03.05.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 03:05:20 -0800 (PST)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <chleroy@kernel.org>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: [RFC v1 08/10] powerpc: book3s64: Rename tlbie_lpid_va to tlbie_va_lpid
Date: Wed, 25 Feb 2026 16:34:29 +0530
Message-ID: <91a6be6c26145dd2ce94d6c1f65aae86d424857d.1772013273.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772013273.git.ritesh.list@gmail.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: z9nuqjk9uduaf1wfb9pf4qo1icpjyzcb
X-Rspamd-Queue-Id: 2016CA0005
X-Rspam-User: 
X-HE-Tag: 1772017521-250581
X-HE-Meta: U2FsdGVkX1+ml/EAwZSNB+ml+mOiJlhCWqPR8t8SL/oYxzyjRxlBDm6xJHWxwKqz9lm9iwM3G20UNGgIEejOI6L36Lwd21Q5K6Ds6na0glCcxbsNLg32hBrNupFJuc+WkuNpoyQ7mN1K/CrKCbNhsaExySyXFnOBPYWdyU2eHq3ss6CtN9VLutKP3KFaU2ZN0WYe4b2ad8Mdc0sUsJqqvSEWYE0iyNkLaIvpeAjxuYmcmz5NWyWJ++ECkPwKrTgooaxA6HeGlTQazVLTfK4ebOfYhbBnKukgFa96mjC8hNGs9JxSuLeFljH0d1NWoVxWvAT+U9z7Teb2ys4Ttu/Fj7KoAnQQ0QyLoJp37+Mt//1tAUsr6IfOl1/E0wGT3CMcAaoM0FKOxcihpUrbW0/EgnsIAX110ZvRySD2tW+//J3urze+Ojc3l9Nu4VvA02gL84B2JNntxhy0IAxHREAaUVJIVkt/G/fIBSjYXSDciykc8JFYgpCWWnma51rysWlqwWFp09jYr0UWGUmgo7Fr2vT+VGP5diPQxGnBsm0+4DlyZuphCC2w+LZI4J4VU8YJ6HuL4MIw37szZuVhC1Cu/ihMgk+XPbtOhA0nIpTtA5uQP86+8fh6CtOv9x8T0toYG3mzFE32FtJ3f6G2QqMUlERlYJFHej2KdiVGFcg96i+5vI+hhgKL4UTj698K2Nh+yc1m+H8lSSYuS3zWJFW1ikg9WWL0Yxw15ZNCqA2Sksd8RegL0ruXjJjRy8Q1gDo/MTMKHiAXPFE+UvP3Rj1keYkkcij9ztqbz5yQ9mr0moW938zFwaA8vGnEYNCqV/Qt0MDW2QoYDVzf9maFhXMPsWSkJbfUj3Vuo75GPOgWGU/0fk3g4Rk0fzlb9ZwOypkOoeKsQHE7RMq8w5x+j9WFLLfF478UlMmiWpxVFEA/F05N/w+HVSfByUy6v7NvkoGPMoBcK4Y/zyJqpoXtMPh
 KxUZyZxb
 kKQTOqqAX4oARVIaxiRq+V7T+y2qaLweXNUhoP2B6Pg4gUv3PiTmjMfudZzbHAv6sjsAxl2k73FWJqMAmcx68MEjk1Uulv0Cfcy/cSqUxnVGgt9uaVJ/SvwQ3n/OZQcCmgL1uzdqQbjJ8ejKNstdFBw70KHcFR9y+BKffbbWLV+YEieYHZo2hDkUyYJpBa2Xia9QwsVIlLU7Ge2TLAtnGmFDditBqsMaEipze3juMkjaNMIUvAumesbl8ky0OGSTjXDuR7t///GG45r+64guqTAPJ+u9lK7pR43klIRM9P4M2ctH+rKpoZgeERfTbOuJwjaZKt/Kc1lUgSKd8zZ0JJwBPyGWZz9Xna1s1Ch4LSBL9zUDRke/M8WeRZ3V8tqXHc/9fin52eBTkrB3BtSU6gr+F0OKws9MFQn02S/pxDR0TBhXuPv1WHSnGEleYWWVrQykUAKinKShdF3u2zDyevVsEdSVp5cbqta28dHRN7OCEtbHAvuQ9LkhakuT5c4nRkGYOnWAn7+L2DE8E3ibRhx+unlijFzP5fO143rDZWZv5dpI1Bw5VR+NcTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In previous patch we renamed tlbie_va_lpid functions to
tlbie_va_pid_lpid() since those were working with PIDs as well.
This then allows us to rename tlbie_lpid_va to tlbie_va_lpid, which
finally makes all the tlbie function naming consistent.

No functional change in this patch.

Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_tlb.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 1adf20798ca6..6ce94eaefc1b 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -185,7 +185,7 @@ static __always_inline void __tlbie_va(unsigned long va, unsigned long pid,
 	trace_tlbie(0, 0, rb, rs, ric, prs, r);
 }
 
-static __always_inline void __tlbie_lpid_va(unsigned long va, unsigned long lpid,
+static __always_inline void __tlbie_va_lpid(unsigned long va, unsigned long lpid,
 					    unsigned long ap, unsigned long ric)
 {
 	unsigned long rb,rs,prs,r;
@@ -249,17 +249,17 @@ static inline void fixup_tlbie_pid(unsigned long pid)
 	}
 }
 
-static inline void fixup_tlbie_lpid_va(unsigned long va, unsigned long lpid,
+static inline void fixup_tlbie_va_lpid(unsigned long va, unsigned long lpid,
 				       unsigned long ap)
 {
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
 		asm volatile("ptesync": : :"memory");
-		__tlbie_lpid_va(va, 0, ap, RIC_FLUSH_TLB);
+		__tlbie_va_lpid(va, 0, ap, RIC_FLUSH_TLB);
 	}
 
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
-		__tlbie_lpid_va(va, lpid, ap, RIC_FLUSH_TLB);
+		__tlbie_va_lpid(va, lpid, ap, RIC_FLUSH_TLB);
 	}
 }
 
@@ -278,7 +278,7 @@ static inline void fixup_tlbie_lpid(unsigned long lpid)
 
 	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
 		asm volatile("ptesync": : :"memory");
-		__tlbie_lpid_va(va, lpid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
+		__tlbie_va_lpid(va, lpid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
 	}
 }
 
@@ -529,14 +529,14 @@ static void do_tlbiel_va_range(void *info)
 				    t->psize, t->also_pwc);
 }
 
-static __always_inline void _tlbie_lpid_va(unsigned long va, unsigned long lpid,
+static __always_inline void _tlbie_va_lpid(unsigned long va, unsigned long lpid,
 			      unsigned long psize, unsigned long ric)
 {
 	unsigned long ap = mmu_get_ap(psize);
 
 	asm volatile("ptesync": : :"memory");
-	__tlbie_lpid_va(va, lpid, ap, ric);
-	fixup_tlbie_lpid_va(va, lpid, ap);
+	__tlbie_va_lpid(va, lpid, ap, ric);
+	fixup_tlbie_va_lpid(va, lpid, ap);
 	asm volatile("eieio; tlbsync; ptesync": : :"memory");
 }
 
@@ -1147,7 +1147,7 @@ void radix__flush_tlb_lpid_page(unsigned int lpid,
 {
 	int psize = radix_get_mmu_psize(page_size);
 
-	_tlbie_lpid_va(addr, lpid, psize, RIC_FLUSH_TLB);
+	_tlbie_va_lpid(addr, lpid, psize, RIC_FLUSH_TLB);
 }
 EXPORT_SYMBOL_GPL(radix__flush_tlb_lpid_page);
 
-- 
2.53.0


