Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1F8C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 03:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64D96B00C4; Tue,  7 Jul 2026 23:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14F26B00C6; Tue,  7 Jul 2026 23:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04716B00C7; Tue,  7 Jul 2026 23:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 96C0F6B00C4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 23:11:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0C04090376
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:48 +0000 (UTC)
X-FDA: 84964134696.17.6239A69
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id 29377C0009
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 03:11:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uYbkPN5Q;
	spf=pass (imf28.hostedemail.com: domain of 38L9NagoKCAEkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=38L9NagoKCAEkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783480306;
	b=bNVdNkQy66cWM89VNu01RZIiTA7xDPtgaRZWu4Gv3m35yBHsl3NVppIPQtAkULB6+D1Etb
	+at+UtkM93L/tAFhwOZy7nbMKitcLPoG9Jg8DyJhag7rU+ZmaJK+DEY/aFXY5pk5bvo1hS
	JZqCf6EKh6gNzGnDbJatq1+TFOfSIrI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uYbkPN5Q;
	spf=pass (imf28.hostedemail.com: domain of 38L9NagoKCAEkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=38L9NagoKCAEkuipvhiupohpphmf.dpnmjovy-nnlwbdl.psh@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783480306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZhq9cReoiqut1+GTjIpQFS6vd7poDNcxevd58JbT5Y=;
	b=VqY6ESM+yKjeCZ3SqvwKvDpGqZDTVnuqoIqErIzffNotnaaAcTf01EIs3e06Ki+8CbGbbs
	yW+KBncjV6VDgzcnJdZFxxaNvqnAGx8lstdtk970Av3vSSEksymipEy1wm71nut5ajHCRJ
	jRQkwmXqbliNmOH4v6WXt6nRi9koXf0=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-84622d6102dso374481b3a.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 20:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783480305; x=1784085105; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CZhq9cReoiqut1+GTjIpQFS6vd7poDNcxevd58JbT5Y=;
        b=uYbkPN5Qk8wJgrcXTW9el59OCw7zjklkNQ7sG414kl1Z/HfbK7T4ic5TiOWTJVrAbJ
         ES1aM4CCAl8MdJnYv8iTJefXwKb7WL+nbkzLZyOUQbsdCHI9WoJ0oJRN6AxzCnpfaBfn
         abEbWNxpwMyPRU9HqXD38Mqfj/LCLFN2RdIanbQAPWF2Rd6ADsmTEsTAue/r83XrIWwc
         O0uV6VhNiN7jsujhfORl+4BYmH6cFljYZMOLyAEgC2AefanSXB8tzDjhwg9En9qoMcEa
         3I1ZJknsZ/Bi/31o1Ow5WKnOmi0CgQc+G4lAIjZKnN8mM2k4bav3PoM6VCdj+Y4lwi2X
         iQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783480305; x=1784085105;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CZhq9cReoiqut1+GTjIpQFS6vd7poDNcxevd58JbT5Y=;
        b=LOCTkBnIEQUroz47dRH1yiiilBfIAxcs2ynMP9Oisg7G2gcMR5kQJ3lVADNTmdXNRH
         asolADkB7kiu4Y1kVuQxt1BqmvfEzJqUYRvtt2wDGAsMv+twsHPhg5I553vGMGIwGePK
         L1XXHYbNj7izVtj9fTd130kvaaE1LE/YETyjiPzTF7T4MHF4Tv4FqPQNVZKrEpUYzx6w
         vo+M+06gYnfxcrRj2nA9yqaQppu4P/WGFJNKZW+QNulZDhlOIk8AmDaxNqRG5OpE0rnr
         /vSPObgPziooT5fPbjJoDkR2cDvGCnfd452ykG18RVAZXk+ptc/E7YWtVnRz3m5HO0f2
         5ruQ==
X-Forwarded-Encrypted: i=1; AHgh+RqWUAtcFfFXPXE+wNr7Ku++nEhOuPz+idFDQbPp/ivWuAGT4wu90uiCAnnZhrFSBCSifj47LHkU2w==@kvack.org
X-Gm-Message-State: AOJu0YzE7kJ53lctk48Mp/CQAr8kHe5IHkWyihZySL3vXRkzNOWPivWF
	lQLiU1QlZQYvGrcPXhxtllatdhIkpZnSUA6icSsM7nzW4on3MCGyakMqOIauzNukIaoQrutSfNS
	LDYTrPSQblRe0i2rmPbVIRg==
X-Received: from pfes17.prod.google.com ([2002:aa7:8d51:0:b0:848:4733:fed1])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:39a8:b0:845:d285:3b6e with SMTP id d2e1a72fcca58-84842fce41amr674441b3a.58.1783480304616;
 Tue, 07 Jul 2026 20:11:44 -0700 (PDT)
Date: Wed,  8 Jul 2026 03:11:23 +0000
In-Reply-To: <20260708031129.3503195-1-jthoughton@google.com>
Mime-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708031129.3503195-14-jthoughton@google.com>
Subject: [PATCH 13/18] arm64: Drop BBML2_NOABORT requirement for HVO
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29377C0009
X-Stat-Signature: fwwfbwb3pr4d79t9q37gutxtfjyiw6jn
X-HE-Tag: 1783480306-620308
X-HE-Meta: U2FsdGVkX19wtsR1HCSbOzD1E1NFcBUmBEl8PFGhuyHE+QzJXf4bPEr1d2iNEZOHoCCTNaGMdOcisdw7XqGUOMYA7IWnCEX2l04A+Yk8PEMfE/YWZdbPLxbFzMpaF8kOqfOcYF7iKLMsMfw1zIvAka2qlOM63PR7S6et2su4xMRAJNrQbgpCMQU2UG0cXmixAQKKidHch2uOEZykzQkaxisPYQvTjqJ4GI4N77dn9D0zajSOz8zXS3bzJShCS5ZkZEtk8HlGQsF36wEqNqddItcbzPUPzcqnoq/Wu8Lw45VX8I1X525xoAM7I/5j+Ka7iKcC1dRkpN1q5Nvx450n1suNKI6mm6+80M+M6nq7wbE9fryHnDCim+5eS90sz7pOfc+lH95dInrxjLw4CPMnQfzZ6zXWa+iXIeGXS1pe8WYaw8QECLp3J3VZ0+hrNB69NRf3EpmSc36IOE34UsXkQGUJAYCn0tJOwDfGKAvo3phpZZ21gALGuJ11/UejCzVRAWq0UF5kyAk0c1UXuB6je8XiBVDdBjkAaXyuGWgV33VXPMJPEm/FvKWLOS5U+Gk+IWeJAKMYwSSWC8aW4fGgmG7nR/qTVnyCO5MbKOmwCPSccLe5syiAZfzKf6PxcKZjEKa5uhPhIIh1PBCWiIltkKyixjTzhewAZ83f3+OfkdLUM5hGU3/YyExocC9Slw5zHWEC4mAV7+EYVId1ohVih3PUKAPrhqL/HwtRC+r56BnJ4EwDfBxZt3ujsn0SD1vEIdZhP0/RfybvgGBepnX1P0Bw5CXGIfI0JdT3OYmOF7hwbEhhObEE5xNIRNECih28DKBg2xlfXzgrjHYABkS60RzBCSx/965O1AwsWgBUOHtzLgZWupAyHr0ALLv2zC0Plx8WrwjyZX7n7jtNmCTTnS53jWbtoSuZVw1sUNCvbUM6WaYxNqqn8cqy1XNzyLFrtJtDttco2Yno8sdafSc
 JjZgV/Vs
 dZ4O0pRPuRn1Op/bVyJ26r9xP+eopkR5gUoKMQ72GHWdtAdw90ZgimcpfTHHOH9fHSXDslXWt8ULQW+cxiVQjO/ea3ajaEQTU6IK9C2ZI6r1F9EOiSMn+VxWqG2OM2TgrL34jr4k+eMiDR5G56KLI38eEkns4DGw8EhNdo5lD7+EJrBsfqq3YSzQzs8gshCrcTjo2d6m/rR5WRkNC/UhytFcGWKpRaIX0dfQ1ALim3aoodJRM9+2eu8qm4pziJ6QXrpjWua752K5Mzno7C7+s7e6sA2e3DtySFHaDNEmsQ/V0vsqixbK3kjF+kYxqXo6dvrqQFlCJGXP8TfUFocxtqeLjsliX6iWJpaLPgacp0xoUMwTkDJhr0J8hLLWNHixTOnVhpS16JeuJ5Q4sq9JD0mPWvYDse5zyh+KOD76LieqRpLHouTe/SPecARKKtrgOO2qHaACzlYjG1JuqrhU6ePxAFJmr8a9gpFUMKLlIdXBbXfmzfPFyr1M7rFI1h48taLotsLrVtCCBpRMjmRqzknyB7wdKwEZsZCNyCGbDB/dXR1JteIboHweA2usmEFXn3Ll/TzObM/Owa4xz5nBUTRuTvEn8Gyo6u+nY+NvT83kFUbggyfF9g2FLT+z6YhpGfY44STaeUH1hMtNeG84MvYD+KOZ7hCNd3B8y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With PMD updates being done with the Access Flag trick, BBML2_NOABORT is
no longer needed.

Dropping this requirement vastly widens the pool of systems this
optimization is valid for.

Intentionally leave HVO as opt-in, as enabling HVO still introduces the
following regression: if all boot CPUs support HW AF, then any
late-onlined CPUs that do not will not be onlined.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kernel/cpufeature.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 3b9224b99a5f..c13433316e80 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2175,11 +2175,10 @@ static bool has_bbml2_noabort(const struct arm64_cpu_capabilities *caps, int sco
 static bool hvo_compatible(const struct arm64_cpu_capabilities *caps, int scope)
 {
 	/*
-	 * We need BBML2 to support Block -> Table transitions without taking
-	 * faults, and we need HW AF support to support changing the OA without
-	 * taking faults.
+	 * We need HW AF support to support changing vmemmap mapping level and
+	 * OA without taking faults.
 	 */
-	return cpu_supports_bbml2_noabort() && supports_hw_af(scope);
+	return supports_hw_af(scope);
 }
 
 static void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused)
-- 
2.55.0.795.g602f6c329a-goog


