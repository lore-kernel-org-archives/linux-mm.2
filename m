Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE437606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=vW35PPri
Received: by kanga.kvack.org (Postfix)
	id 429486B05C2; Tue, 17 Nov 2026 02:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9FD6B05C3; Tue, 17 Nov 2026 02:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316C46B05C4; Tue, 17 Nov 2026 02:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0148C6B05C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:07:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DC44A0353
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:03 +0000 (UTC)
X-FDA: 85443729126.28.FDAF6B9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id C2F2D40003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vW35PPri;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899221;
	b=hGvAne5ulssdBOA1U0A3/hGW9VoDpRAaatrlpM6iG48dNOsLIdrTGrbPrODcX9yQFmHLme
	oswl3sfKGAx36aXHaDb4O/1mSmudusLbBCqiSj3lVvf+ZoNluUjSPr3TIJH1h+VdkXMehI
	71VepeD2JGmNQBUJOt26jzW2rg7zC/Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vW35PPri;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9XHNTvsxvTs29hz6BcMFjPlN/wv+sbJF4QuCIXu6oQQ=;
	b=KeVv2jAbSMsQyrtbFSJZAVLYNUoe8SxFh6wPFzMN9fnaW+XplrkH7yCybTYY3rmN/cNd2v
	857xDZm9hrY9Upyn5xanVcw/UmFKrRLn3hvLOhVpbnuxNRKwNy4MaeF/9hWckGR93uMST7
	Tc1o5yszpjcZ9UO7x91kTShiu1cdubY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07FBD1BD0;
	Mon, 16 Nov 2026 23:06:58 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DC053F763;
	Mon, 16 Nov 2026 23:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899221; bh=hn3PA/FHiJccaTPVEin+J5IcUo1zFJdOxKnT8wtz+xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vW35PPriYm7NahrJU5oPMNGIRSEKeVAmNAUxuWBxWFPUWYAMtihBpIg3yzJaKagb/
	 hQM249eT2uubKC73o+LX/+Jqtjlz+53e8UAcU7O4EbNPhc3qvDh/MiH4Ru9HVaPnME
	 I/FcwBN/1c/Y8OukF6ZX1zitFJMADP88nzkPO/5U=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Linu Cherian <linu.cherian@arm.com>
Subject: [PATCH V3 10/14] arm64/mm: Add an abstraction level for tlbi_op
Date: Tue, 17 Nov 2026 12:36:09 +0530
Message-ID: <20261117070613.1183243-11-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2F2D40003
X-Stat-Signature: pw8ojwsdu3ubj1hwxmxpjgteeu68ti1b
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794899221-693824
X-HE-Meta: U2FsdGVkX1/blIbu+qzO98eOgXBbsdhlyK19XCBECgcIzA0H1yjA8JJzBeN+8SfMtV8QsCWlQqx7tDYIshG2Mx+/rjnJmqZih0QXTGkz0pey8hStDOj4zExcOCJ+zsSvQ64d82QHmc9tOnv/emCLgbMjuv4C0BaA9RhTaZicb0FqJcbfbJgONfLUeAbSGFrq9LLRTDOwWJ9L03+zUBGE/1ToY1F9I0qfUR5o0vpd38d5kyR6riZ4onUgAQy6fUmXRDMmSqgR4YQXD/uZ4OHq5cxp8O9Qm0LvLBX7vsWoelUEdPJoyUk2hTFUL0jPXiis210Eyky5aqpLkNx06Q35AvQc1OU9FvmzbjCgvZfZFpypsOrgLUFirfZNmOcgMkD/CRCG1cy6d6zfxZ8vHCi41Y2A0gYNvfTM2HCPisiZ9XMppAgGho6yuP9iaNrwuBkzuT6hB+lPN3wS6iFF33nQzjq2ndE94KsHpkFEPvlezIqBT2rn3+htlAV0IlG5fjmMNP4hx6KMN3/FpU6ploJM+rIGf9BSZFe8JgjwtYCP3j3S2RE6MwnZbGWJeOwRqVYyyIGYNWCUqQvqo6SXXp1oN5Jjs6p2qjrTtss/Z+B52VyLnNNVDEToglewIY+cWJJpjwDs86+LWh+9yzPS80oig1IOVIGzCQ4QssczljLBY0QiiKm5aRo7ObWjxyO0GhDSbe9wJKovHlugDB5D5ZqoGkQYwzViMueej3j4J7TMs3LFn1AvcvPuTreVnfUbzGd+zzaGVX1xMv4S1lJm8C15T1AyspyaPKZwuV7I+9+1N3IlMoJE77YIvP2PKraWtvdjbJwVETSbspqAxI0VKSdMQJ0ap/wifP10ayvuC6KDI92yRZiTgEE6byYk74STlPG6b65MoMWQY+SWlkQG/A2THlbqyZBFEUDWZ6NEax+N4CvYrOBd//+FdQBtUOhkt1+xnsZNizdhINgLzjvkPVz
 GBma7mnu
 Xdn41LvG3t2Vu86c3VINbTw+2fV3n+VhOs7xNazOuSN7OoA3+vz39RQW8e2GtTyZtuEvix4kjd0ElC8qDUlY+T+SXhCKXjracUMZuNSGkV4db0NGC5PVP6s+yBPOnCU9ZB7fpvu12lpGIAasW18aYoWHAxXHTgMTQpMxBIgKDRI4PC8f3yK1A1MlM4f3NBsECciOv3ZhNCanpAkARi4H9vaYL1LUsFlXmYq8ELvLNcTEhUXpuHJE1kxStxeJr5tfUk6fr2a0KrmVz+kIrexLRWTZKu4vouGHoj4OqK6Cg8GorW+JH+SLZFOjSsVXEDhtkuMYlSoATzxmz6atpPoDovHMOTtgUVLbcNSTs316WqbilZPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linu Cherian <linu.cherian@arm.com>

With FEAT_D128, a new instruction aka TLBIP is being introduced for the TLB
-by-range operations which has an argument size of 128 bit.

Add an abstraction level to void (*tlbi_op)(u64 arg) helpers to support the
D128 variations when applicable.

No functional changes are introduced with this patch.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Linu Cherian <linu.cherian@arm.com>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/include/asm/tlbflush.h | 70 ++++++++++++++++---------------
 1 file changed, 37 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index a05520d3a0131..e46bebeb230d6 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -130,49 +130,53 @@ static inline void sme_dvmsync_batch(void)
 
 #define TLBI_TTL_UNKNOWN	INT_MAX
 
-typedef void (*tlbi_op)(u64 arg);
+typedef u64 tlbi_arg_t;
+#define __tlbi_wrapper(op, arg)		__tlbi(op, arg)
+#define __tlbi_user_wrapper(op, arg)	__tlbi_user(op, arg)
 
-static __always_inline void vae1is(u64 arg)
+typedef void (*tlbi_op)(tlbi_arg_t arg);
+
+static __always_inline void vae1is(tlbi_arg_t arg)
 {
-	__tlbi(vae1is, arg);
-	__tlbi_user(vae1is, arg);
+	__tlbi_wrapper(vae1is, arg);
+	__tlbi_user_wrapper(vae1is, arg);
 }
 
-static __always_inline void vae2is(u64 arg)
+static __always_inline void vae2is(tlbi_arg_t arg)
 {
-	__tlbi(vae2is, arg);
+	__tlbi_wrapper(vae2is, arg);
 }
 
-static __always_inline void vale1(u64 arg)
+static __always_inline void vale1(tlbi_arg_t arg)
 {
-	__tlbi(vale1, arg);
-	__tlbi_user(vale1, arg);
+	__tlbi_wrapper(vale1, arg);
+	__tlbi_user_wrapper(vale1, arg);
 }
 
-static __always_inline void vale1is(u64 arg)
+static __always_inline void vale1is(tlbi_arg_t arg)
 {
-	__tlbi(vale1is, arg);
-	__tlbi_user(vale1is, arg);
+	__tlbi_wrapper(vale1is, arg);
+	__tlbi_user_wrapper(vale1is, arg);
 }
 
-static __always_inline void vale2is(u64 arg)
+static __always_inline void vale2is(tlbi_arg_t arg)
 {
-	__tlbi(vale2is, arg);
+	__tlbi_wrapper(vale2is, arg);
 }
 
-static __always_inline void vaale1is(u64 arg)
+static __always_inline void vaale1is(tlbi_arg_t arg)
 {
-	__tlbi(vaale1is, arg);
+	__tlbi_wrapper(vaale1is, arg);
 }
 
-static __always_inline void ipas2e1(u64 arg)
+static __always_inline void ipas2e1(tlbi_arg_t arg)
 {
-	__tlbi(ipas2e1, arg);
+	__tlbi_wrapper(ipas2e1, arg);
 }
 
-static __always_inline void ipas2e1is(u64 arg)
+static __always_inline void ipas2e1is(tlbi_arg_t arg)
 {
-	__tlbi(ipas2e1is, arg);
+	__tlbi_wrapper(ipas2e1is, arg);
 }
 
 static __always_inline void __tlbi_level_asid(tlbi_op op, u64 addr, u32 level,
@@ -447,32 +451,32 @@ static inline void arch_tlbbatch_flush(struct arch_tlbflush_unmap_batch *batch)
  *    operations can only span an even number of pages. We save this for last to
  *    ensure 64KB start alignment is maintained for the LPA2 case.
  */
-static __always_inline void rvae1is(u64 arg)
+static __always_inline void rvae1is(tlbi_arg_t arg)
 {
-	__tlbi(rvae1is, arg);
-	__tlbi_user(rvae1is, arg);
+	__tlbi_wrapper(rvae1is, arg);
+	__tlbi_user_wrapper(rvae1is, arg);
 }
 
-static __always_inline void rvale1(u64 arg)
+static __always_inline void rvale1(tlbi_arg_t arg)
 {
-	__tlbi(rvale1, arg);
-	__tlbi_user(rvale1, arg);
+	__tlbi_wrapper(rvale1, arg);
+	__tlbi_user_wrapper(rvale1, arg);
 }
 
-static __always_inline void rvale1is(u64 arg)
+static __always_inline void rvale1is(tlbi_arg_t arg)
 {
-	__tlbi(rvale1is, arg);
-	__tlbi_user(rvale1is, arg);
+	__tlbi_wrapper(rvale1is, arg);
+	__tlbi_user_wrapper(rvale1is, arg);
 }
 
-static __always_inline void rvaale1is(u64 arg)
+static __always_inline void rvaale1is(tlbi_arg_t arg)
 {
-	__tlbi(rvaale1is, arg);
+	__tlbi_wrapper(rvaale1is, arg);
 }
 
-static __always_inline void ripas2e1is(u64 arg)
+static __always_inline void ripas2e1is(tlbi_arg_t arg)
 {
-	__tlbi(ripas2e1is, arg);
+	__tlbi_wrapper(ripas2e1is, arg);
 }
 
 static __always_inline void __tlbi_range(tlbi_op op, u64 addr,
-- 
2.43.0


