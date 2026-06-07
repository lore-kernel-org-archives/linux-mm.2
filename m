Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C047CD8C88
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 07:59:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B7E6B0088; Sun,  7 Jun 2026 03:59:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ECC46B008A; Sun,  7 Jun 2026 03:59:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 102C36B008C; Sun,  7 Jun 2026 03:59:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 030E76B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 03:59:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EF661C2458
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 07:59:40 +0000 (UTC)
X-FDA: 84852367320.03.DFA9488
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23F4E100003
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 07:59:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcNguZiA;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780819179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=pY3Syi9J71kcCpYa/qDSw//aIWzv401LmWCaxGFOX9I=;
	b=DnTPfVOo46i6M/UPTGOihSXtPUPBuqeRhIeu1uKmsIy1646Z5nSIMBHAjnW7hXclc9C6O5
	7aoErngBRzjL7T/jWExjfTON47TYbWOxtghNBDtJ8N3RJgvYQJfyxYxMNReOqrOF8sCZO5
	1BW+6zLPJ35Yeot8/puRp1UjUZHGJac=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcNguZiA;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780819179;
	b=Z6WdURI7WPPAbP5itotLemZFNLwHXlydDZoX3Nkhe7V/GEY2pwgH23iHu48y442l1+q0eU
	Z0s/L4+df22r0KzO0E4QrQQXMexr1iq+Yxyr6TQ8EiolcOeCmy75nQImun2o4l51SBZgO2
	+z8OpiFYFlP1PVoW308a7tdNEgXSSi8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 76F4C60008;
	Sun,  7 Jun 2026 07:59:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B795E1F00893;
	Sun,  7 Jun 2026 07:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780819177;
	bh=pY3Syi9J71kcCpYa/qDSw//aIWzv401LmWCaxGFOX9I=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WcNguZiAzEWDEiH6QF9WQwB9orcSb7cwktW/oFZ6a9Om5GynxANuGWzBpCaQ6qYeY
	 PIWx+wgsTgIKl16Y9WwYkW8A275bQ1+k8RmayN3INi2ACrqoUVRM4OFv7QLBl+XF4A
	 vPuOOLoJjVds2WtqNYHRBjx4j/GNtN3UaNZLul2ATHmilucG2njfuTzVDEZsikgjES
	 Nf73jqA49B7A2rNdFIVx3OOIKevWDllJO3anpTyCTmsNfbWX2L1IwuDC/Xn74EGSLQ
	 Sjw4jW+WSIP3b75W4/dPrxVe7jVlY2QVA4rakQDeFQ5Xy5g7cQUJfh60k7rOWpO511
	 FetRX9bgJHlrg==
Date: Sat, 06 Jun 2026 21:59:36 -1000
Message-ID: <088f52fd25860ca961449d53f91b214a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	David Vernet <void@manifault.com>,
	Changwoo Min <changwoo@igalia.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next] arm64: mm: Complete the PTE store in ptep_try_set()
In-Reply-To: <aiRFcz78QTZdIHHB@arm.com>
References: <20260601183728.1800490-1-tj@kernel.org>
	<f45f02410d23c99d14f3577da9b27a327816b5a0904bdeefc8e229eac760d1cf@mail.kernel.org>
	<8f133924fbf8d259340f3057e505f663@kernel.org>
	<aiRFcz78QTZdIHHB@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23F4E100003
X-Stat-Signature: 187qxs4f1trbixpqkf6nqkgqpa4opwoq
X-Rspam-User: 
X-HE-Tag: 1780819178-473787
X-HE-Meta: U2FsdGVkX1++x9c8foo+DxjEIGAee7Jf1QdQLqKvuoUXcmm001CmJ+Rpo8RhMRwd883EK0F9SCurTePkcvbgjUAwCeRJm9L42+Zq0ZUYNyxdnqqPI0twFensCEXL3JAUhN+KV4+A+gXJkuMTZhG5gDmzRmEEPZxUSblVFD+bPMJITD4YT8rmIB0KBLOjSgsztUihcFPnSarTt9OTW6C209c0AeTHr4tUk2t9X/Kq2SmsmuULKxhU3OZDDJFeRVMNmwAa9bqgY7AlLGls1BOZTzHGuc6xOSe79j1wiJeWLlLqbLFGeZYPuXGErA5csyvf50Dd+pw86rtRZWdrLkSjwYdGwuu13AjjHG6FKMLAOB4ZXF9Q+p4WZLQ9Ivw8+gyfd5IlLiYM32rvktux5Zu+ZqY00M4isxx47ueozFoCxHNf+PYfXRac8rIYyAAg44ZiO49Na224JW3Ew7NdO5Y6Veui5IxvzDTXdvvoq7JfL/Xa7bPjlnFZNDl9fEjgnDjgPNvH4bM3fG9wVDfpKXs4Dyp5TYWcJZ739gBZde3INmG4VcP50xEeEXo6ONaMbUNG6gfXyzViwE01yFopDol1ZGKsxuMLgNJR4yhlrIyQuS0PIDOZWKGS69vSocyAAVW0GGYBl0RkqqqjdAsh9DTzJO8gMr+qFWX0SNtMUVZq9yfEOiHy5R9srroF84UHfdS1pTIt/jKVwkpY5Pzca6+B91Do4hpxxFDHtBheZNup8PVG2xZ8lShONRGbFnkabUBUsHz4gs52b9i1sLdKAE0/FHN5G/kM9Uon1Kl6F7quSiUVShn4Z6BzgW6r4st2OtucjHapUGTP4wotMXPw6kvucnyD59TJ6XeQtCsk+R00ADAAUACSM//0U8oale6kOdG3GKQpXJCnH5pUzmzlQUsjZnohMAHub3PJ0IgA0n0tHToMFN1ZAvsqn9DZ04HEVtwTtppGs4x5GbV+3CJkoAZ
 AGb1em7P
 1yMCg73bj+797EDIDkK8K5JuKMerHW6SCLJzs2q6bOQs/PvtSztYkXxxk5DGPUawfQhFTIBSO3FnjmbQFFc2O/gE6QfQ/tSwYNkZJtxkOC2qrYhEUGemxSbQ1rdoBPmFxJQvuIMAnLC1B9FFZxdWXZcPbo28VOntgFB4z22zn3SY/4wDbTqXN5rJodNnC/NA2g1RJ72AONkF0b3PA/KFLSfbp8PrnhlBKjdORLD5NPQydmF/Jg45dCij4H1ToFZILoG9ZGEBvwlQW1M6VM417cxG+IGeejVgTRMfmUDRe7yYrjLhlrG30+So1g1ubV+DFCZndUC5WLM9QwTu3gcOHv2QA5bcIY7Vr/48VHapLOF/YKgCbsypomTBB5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ptep_try_set() installs the new entry with try_cmpxchg() but, unlike
__set_pte(), never calls __set_pte_complete(). On arm64, installing a valid
kernel PTE requires barriers afterward so a subsequent access observes it.
Without them the access can fault instead of reaching the freshly installed
page.

Call __set_pte_complete() after a successful cmpxchg, mirroring
__set_pte().

Fixes: 258df8fce42f ("mm: Add ptep_try_set() for lockless empty-slot installs")
Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/all/aiRFcz78QTZdIHHB@arm.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 3ce0f2a6cab6..dc8525431273 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1838,7 +1838,11 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
+	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+		return false;
+
+	__set_pte_complete(new_pte);
+	return true;
 }
 #define ptep_try_set ptep_try_set
 
-- 
2.51.1


