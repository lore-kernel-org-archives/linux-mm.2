Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 040AEC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BD76B0095; Tue, 21 Jul 2026 12:23:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B338E6B0096; Tue, 21 Jul 2026 12:23:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A704D6B0098; Tue, 21 Jul 2026 12:23:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7861C6B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:23:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D76EE1A01EB
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:23:57 +0000 (UTC)
X-FDA: 85013305314.10.D6842BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 332A310000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:23:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hhew6m2T;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztzLHFgZF1pj4LHMu3VvIZzUHzFoGqe9tmkrlg/P0Q4=;
	b=wdL9dqGBj2ZiwJ8wuEXaNX14nL8qf6CbTukj4Ts06IdWGxQCW6N4qHNXsjnOYpHnW6k9nd
	6YrJHYV9ViIihJ40YcpeYJH8C2BBxqCMLan6xiIYpVtjxVQXlUyqvcqshNWjF0YyhDdqL1
	CF1rSWH/2Y/3RA4pefWwO6Nd1NyAprM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651036;
	b=5FRGTSM7SlCLryAyHBNwiKEti0Hj9ZPT8rWeEooKsNBjjYWjHfeReGPiNfCFPJymraNvse
	WyWl8PWXQWKqtDkDO18+2WU/eJz67KIBfIlzjAds7WyBvTuzYmkg0zH+eRcmdmhuoxTJqK
	LinMaMJD5AqZhaPHj+n7DQQcM1kqSZc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hhew6m2T;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD59B60A5E;
	Tue, 21 Jul 2026 16:23:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E305A1F00A3D;
	Tue, 21 Jul 2026 16:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651035;
	bh=ztzLHFgZF1pj4LHMu3VvIZzUHzFoGqe9tmkrlg/P0Q4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hhew6m2TOv9DRY3CJ5gbegcSEoCRoBYhTbf45iQdRbrMKFcSNrw9pfJTGRkHal5DG
	 pqwwjVVXbCK/99gt0PM3LFTF44MIq8GFR1Ln36lj/2CLq4/MQi2K/EbV75ihicS6s/
	 KZX9AWzzwaf86AoOavdoSUccw18O810scPylB6O2yn2ye8JoGgcA5FlxhKbcuTe+3g
	 0pt009M4LWj4WIRRFBSNZO1cvdBvD/JHkGsywJiS3euU2gHN7KcWgAo+3wnO1a4lJU
	 kOE2hML+o2O5/WqOcYTGrDHVckMtRkBrIsMPIXn7dZVSzhO0n3VARhQSPwyFXlBaxH
	 nLyf675udKYow==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:25 +0300
Subject: [PATCH RFC 02/18] x86/mm/pat: fix effective RW computation in
 lookup_address_in_pgd_attr()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-2-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org, 
 Juergen Gross <jgross@suse.com>
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 332A310000D
X-Stat-Signature: bg1m8tynqwuxxitsbxg7btfp3ng63deu
X-HE-Tag: 1784651036-747392
X-HE-Meta: U2FsdGVkX18NZZ80fJ77frhJuue+DgOheCqLdidKNvQ4Ob4qaeM2BkqSWQI1XnzYnWYZ/+XLjTOqNx9oEJuqF0JPo/znYZUAeuO0QG319UgJqGY28aikml7MPVNMkvtuoMJq+dKj6io9Mwm6pWY8z8TFCzwlYwoSq3oxpABWt768a+2duYCz0mNYMnJWa6aJcBRh8PkusosC5aEmJwyTSCWz5SAyvqS3YJ1iMG4Kct/OM3N4Bk5LCkTWDEqSUbxZrAuged40o5B4zgYJO/isWo71OKOMIVCOZOgVaScj732UXmHaxMogoju7tYpUFH3Xb8uESTlae6c2JK50KfUSQsGqJHkypePh+8bYCmpHoFbuN+MxoXj1tT31BlTtdvjcgwAQgrQJ9J2ywOFmUkT6+VNJJRs1V+zhaTgb2JbyGYNezVInsQNV8BuZeQMBM97509ifM0j+Sfg6dcZHpkgvS8JDzXl3pSiqgrFHtozq/AF5BY7jtiINTDvmKHL4OzH87Z9Z/TnwxKrzB3xskv3mlC/pGt4McJv24Ptt6HOgwDFHygctc9oUkG/fvU2Gy6xkpXBmNnYrkkVn5Q5tkaIzKC2CU046fyeSY9qi6pBfFTjCQw+YaDvpRxZbtiaxlpmhe1BWmBfizsbX7WLMts3/lTROmbZB8rO0wj1aI7RpthD31L9GasLB3a5Bx89Z5ffrMpLb6qchW4qFeJt46lRBMWpnSkCK42vB68jSEVHU5T2XOheGWoRNrRihhuxDRjC7in/m2HKeL0LhekTR3V4u0LuhqGMz7ViBvZzbOFFstnRGbxEjq8N0C8mgv3eAEXHsO8rHuGE0SfFRuKai9E7av5O18e5nRQM1Pj67pK5w/j00S/J4Jlwhb6E9tmJccvppd7b2orozVoga6tsUFzK4FlANUUIYKgJSSsdwfqES03wDlzRs3v73xlE6b+hFfovXdVzBmzmHvk6pv1HJxfb
 5M3EQVel
 G6gccyRtFZmYfrtgsaoQwgKFFT3c+Ue/ztlXhca0RIcPlejLYLM1Ji9Fp82Bo7+l5kvybz1QVFXefqe7m/ppJSJ4YENHn8RK+YUgMG/3FbAelpN92MdMqIDEsApfXaOkypR8tIChUAcWdesOgokJZk3cCwI6ufZbbCiIceKygdbmf/ChX5Xp6/Cn9IbObsw0iv8fn+jz7hDAW/vhan110+FRaEvE5xfmTyvZTepCr07CRydge9OKlcTzJvYsK77BpXQbSx8jj+2vRGdpMw8i4ZmCsDDF7l8wlpJBCs03ZmVyNMpefpYkMHd2/hJ0yPa9WmEhfXu6yxoDOFGe6I7MqzXNLvmYPzFFP3syZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

lookup_address_in_pgd_attr() accumulates the effective NX and RW bits of
the walked page table levels so that verify_rwx() can detect mappings that
are both writable and executable.

The RW bits are folded into a bool with

	rw &= pXd_flags(*pXd) & _PAGE_RW;

but _PAGE_RW is 0x2. So consider the accumulation line:

        rw &= pXd_flags(*pXd) & _PAGE_RW;

where rw=0x1 and the right side evaluates down to 0x2. It'll end up doing:

        rw = 0x1 & 0x2

and rw always ends up 0.

This way rw becomes false at the first level walked, regardless of the
actual permissions, and verify_rwx() treats every mapping as non-writable
and never reports a W^X violation.

Add double negation to the right side to normalize the _PAGE_RW flag to
0 or 1.

Fixes: ceb647b4b529 ("x86/pat: Introduce lookup_address_in_pgd_attr()")
Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/mm/pat/set_memory.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index e8316f5ffa8a..9382f1d6194f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -730,7 +730,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_512G;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= pgd_flags(*pgd) & _PAGE_RW;
+	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -741,7 +741,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_1G;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= p4d_flags(*p4d) & _PAGE_RW;
+	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -752,7 +752,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_2M;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= pud_flags(*pud) & _PAGE_RW;
+	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -763,7 +763,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t *pgd, unsigned long address,
 
 	*level = PG_LEVEL_4K;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= pmd_flags(*pmd) & _PAGE_RW;
+	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
 
 	return pte_offset_kernel(pmd, address);
 }

-- 
2.53.0


