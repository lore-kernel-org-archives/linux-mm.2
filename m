Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9D7CD98D6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:02:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31D2F6B0093; Thu, 11 Jun 2026 09:01:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CD076B0095; Thu, 11 Jun 2026 09:01:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3826B0096; Thu, 11 Jun 2026 09:01:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 04A6C6B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:01:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BD64BA060A
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:55 +0000 (UTC)
X-FDA: 84867644190.09.2A439E6
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf26.hostedemail.com (Postfix) with ESMTP id E4EFA14000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:01:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eJoURkkc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3v7EqagcKCCYCDCTPCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abarnas.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3v7EqagcKCCYCDCTPCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abarnas.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781182914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0wyflRGzl20RCEe+VjdyZF4sSVExnxs7YpSWyT2xMI0=;
	b=tBQZk0rnu7b5P6VRLwmvzvPPbiinkoAdUN3lPSqZaT046tBftAm22YvqeO5zyIo2YZercQ
	5yryLZI1kTu0OmXhdwiS0XfMZioZ4C4mp48nQ+eniWulKP0C6TM5sAzlCyjSC7YPHQqJo+
	/HWf+m881wzdr7de4oOSV5NW8ng0TqE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eJoURkkc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of 3v7EqagcKCCYCDCTPCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abarnas.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3v7EqagcKCCYCDCTPCUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abarnas.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781182914;
	b=Mlg2O9XCeUEObQ82LRW/0OGviN9JmH1jOm7IxyQYAxwY51IWDyAl0yMiPk89jTgQ8DMrWP
	2GeSy6Gh4qeg7de5xjza8TzA778/PNIG8I3chfWlQbI3lHN/kYnWu8cpdphXBXIBDe/NdC
	Xs6/cFXt+vzAI7TjCTxufDXTsnCsbyY=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-68b6f4f3c06so8106102a12.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781182912; x=1781787712; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wyflRGzl20RCEe+VjdyZF4sSVExnxs7YpSWyT2xMI0=;
        b=eJoURkkcXgZ2UOtdVt30rhR1/I14vFd/w65FDXGS9At6sptPrDNoytubkiYnlG1kmG
         Rv2AHc2xywURRk0dv0x4WTAT0ydfxm5IfErZVtfnl6tAZEgFMnmuvxhjiRZPr5BiU8c8
         elvkTtmaPBMmk0x8luHXj1JppGILAHDiDygSeVE5ze0egZdI/BsfqMw7Sl1kOCiQczpo
         X2xIIe0snrL58dVDr9/nKhwQMXzBgo7K36g5V+pB8oYrBFCaplGX2mci5HUnK8MHgKH4
         nVbXKcOxxhne86knZArEINOkjzIqJichNHFH4FNH4tJC7JARf54JmsPeZ540LoYu4PNE
         LPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781182912; x=1781787712;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0wyflRGzl20RCEe+VjdyZF4sSVExnxs7YpSWyT2xMI0=;
        b=eCpxNlowx+kHIX17NkM9ktVElngnbcdJOD/f5uRZ+Uu0NYHdPBlBHtk8pHYYDVQDcQ
         dh/ntYxVt0Hvl4H8ujvkkEtKj/pTIgDNQeCWByGE/s5xvPq/9y6wXzoMMo+JzZloLv3Y
         HXLpzc2/fCzVFD7zDzXjiQzfgwBrvZ5r0dPy+x80KJynvnIE5bqVOpF0047eu5bqreFg
         OhEThgv7BjEcqgllddphI/SPDqwaIFEGE1IO26lsbFrjMORk1b7+DhYy68K6VP4NVjM4
         3P19YyXBjHi+IeoPZcBjalB4ZNKUVo0ssehTEib751pP3vqSgroI2BK5RyLeuExPzYbe
         qlbw==
X-Gm-Message-State: AOJu0YweBkZOeApWm3Lw8sRc9tnZv9jLm8MwO/onXaSuMY8EJDoZqvXN
	fTrwSfn+Cwak5QibC3mUDRWvTIHTHPi6Gpw4zDeJrM+bD/TIS4+ThY4znodsPJwurKlWD96smyL
	O8vKBW5jM8g==
X-Received: from edrs20.prod.google.com ([2002:aa7:c554:0:b0:67d:8c66:91])
 (user=abarnas job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4307:b0:691:b5aa:5a5c
 with SMTP id 4fb4d7f45d1cf-6930e2d10d3mr1376617a12.20.1781182911975; Thu, 11
 Jun 2026 06:01:51 -0700 (PDT)
Date: Thu, 11 Jun 2026 13:01:41 +0000
In-Reply-To: <20260611130144.1385343-1-abarnas@google.com>
Mime-Version: 1.0
References: <20260611130144.1385343-1-abarnas@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260611130144.1385343-4-abarnas@google.com>
Subject: [RFC PATCH 3/6] arm64: mm: fix restoring linear map permissions on
 execmem cache clean
From: "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, David Hildenbrand <david@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: b7gr361kxokruerf8y94tpphjutrt8wz
X-Rspamd-Queue-Id: E4EFA14000F
X-HE-Tag: 1781182913-465585
X-HE-Meta: U2FsdGVkX1/kDJ3K+1h6K0VTQpq9bBbuLnxlU2PWA01tiWYcM1+hS8Fu5WvSmdjQz50igMmk09bQDfEdpUVdNe4vzB9WJWDX8eljOeznANLyvvesuQbpxTv0MN0DlUjw8UVwxsS4P24QpjW8tLGbcOv4fRRQjAxMfHr9hOsnPcjsxDPYBZYBb35CG4fUEOGwIWR/RyxjIzyGR6Q23ifBQyfBINF3ltAbnx66chmy2ca9NF9OPGVBLmSEaS10V+XYrGovr4hFpKlVYhwPYqvkMvnDGdlFTpgbl6Y+MAVN+iEbXTUupVlSqaQ8RmBS1OXzzee1UhH2v47byBh5L75pihCR0KaSoR/ZSPo+BufH46deWYTlfTk6+onygGDjl2r30jrKN1HTENi//QGk3+hIqX+sE70g+mxvx2CrZr9/LPgw1+3YTx6ON3yaHeY2n/a2FXkmBfKNBa9IXeCzl6dX26gxPaVkjxms20YLGKRGBGhY6wVfinNAX2hZcyMTsWsN1yAAdU97whsXkCYvmYjodkpdZd85BKOqnip9Cs0MvrhGLJ+K7p9CsnHtQZ0L5DNLFkPnM6Vh6wyozxD8MDXI4MoYufwNgx+MUEG4cJ0joGViCSFBV3KB5Qcah/v2xlmtx4zW9P05WokMB1r2TH4199XGYXcm7ixxnFNgs8CLNhUPUP7yPrnJhV26XnRrhVVkOvaMWv+mACKyT+sGLir7DC8EmLKQAyYHa+9AMoeRLO3vAvCFOXs8j/LH81uDci3OExE8onxxkk1Z672ivJJuGSTKKIN9zO3ACq00TzuT+sZtSXwbshSGF3qzPLHcTqwzP3sIJJ68gF6mu0M1G/avcr7ueFKnSurG23R4F0WDmgpbdIpb9Gv7F1eaLLEUdCVfadyFMHb5UpeQLpU4hzKmFhAw1u0sGTRSaElfIyOxpG8konzAL0KicO62yNVk6Lj9z/TmmgjVdwwsllQJHb0
 +qMiAxrC
 os2ysTJMKEmPR3AlDgjXiYSIpnTx5pkIXUidRnt0yZSrgC49q+kD61AlEXE0mn65HkUNkz7m6N76TmPztd2j28BL2nB5OYVT8RP8LgR1TN5KG+GxIdjAy4BF2+6e8IMIHoyxNAyNp0qon5rTcDKPh2Xv3HA7CK97fw5zo5xUe2EZpJqSHVJcnkRLaewKkmac0HW4pEnY4bicLQmhsuJ7e+rMF36Qr+CbbcdCelRFajCddf+fEnTymwkV8zGrVu0Rd8ixxI0WbOLMJN2X6wsHR5Znf6kQorIbhPWycigqQNxyZdE8KtT6a/u2+NO2HtCt+gGpm6tpuJJrRV3Hnz8k+cr+ed/8g+m9lEeMvaHFFFjcewCSaVzH38dLWJLlQ4Grn5g06S0ZvIV3d0Bz3IxAu6q1eckZQ2AlKVhYuE/HWX79ihswIQp96NpkQZy1R9Z2C9/9LB6+wLcOQKOm84zhTD/nSyn6l+lTzy9ugY/oLUb4HU2o1mKfDo0o819gUwtbGBMCcpQ8tw/I0bHlFLqDC1fdAaNoSYHH6hF+YOPsNbgZgh7vJcqOIb3C/oh9oTHrEZpM0Iaw6E1wd3Dc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Strip the read-only attribute from the selected memory range when
restoring the linear map after an execmem cache clean.

An execmem cache clean is performed when a cache block becomes empty
after unloading a module. When making the memory valid again, the linear
memory alias must also have its read-only attribute cleared.

Without this change, the linear memory alias remains read-only even
after the execmem cache block itself is freed, which prevents subsequent
allocations from writing to that memory.

Signed-off-by: Adrian Barna=C5=9B <abarnas@google.com>
---
 arch/arm64/mm/pageattr.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 88720bbba892..eaefdf90b0d5 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -239,6 +239,13 @@ int set_memory_x(unsigned long addr, int numpages)
 					__pgprot(PTE_PXN));
 }
=20
+static int set_memory_default(unsigned long addr, int numpages)
+{
+	return __change_memory_common(addr, PAGE_SIZE * numpages,
+				      __pgprot(PTE_VALID),
+				      __pgprot(PTE_RDONLY));
+}
+
 int set_memory_valid(unsigned long addr, int numpages, int enable)
 {
 	if (enable)
@@ -362,7 +369,15 @@ int set_direct_map_valid_noflush(struct page *page, un=
signed nr, bool valid)
 	if (!can_set_direct_map())
 		return 0;
=20
-	return set_memory_valid(addr, nr, valid);
+	/*
+	 * Execmem cache uses this function to reset permissions on linear mappin=
g
+	 * when freeing unused cache block. On x86 it makes memory RW which is
+	 * desirable. On ARM64 set_memory_valid() just change valid bit which
+	 * leave direct mapping read-only so use set_memory_default instead.
+	 */
+
+	return valid ? set_memory_default(addr, nr) :
+		       set_memory_valid(addr, nr, false);
 }
=20
 #ifdef CONFIG_DEBUG_PAGEALLOC
--=20
2.54.0.1136.gdb2ca164c4-goog


