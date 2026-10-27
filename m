Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6927606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 12:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nO4zzugW
Received: by kanga.kvack.org (Postfix)
	id E58FE6B06D8; Tue, 27 Oct 2026 08:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A866B06F9; Tue, 27 Oct 2026 08:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D46D86B06FB; Tue, 27 Oct 2026 08:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B492C6B06D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:23:55 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53310C09C0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:23:55 +0000 (UTC)
X-FDA: 85368322830.17.0556CFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9DCF020003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:23:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nO4zzugW;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793103833;
	b=XiZDcbsLbZtggc4SPjds+h3WKPMt8ohmlY03eBsLfMYKqx0gwo2R8I39o5jwJwAtKpKEZt
	mPJBr6Jvr0aVbL/QET+qnb4pMIoiWnxzFDoQyW2uYsBe6ppTxi172asphgZl5lOg+I/hte
	s7HcFw5SqitPdxaGHbbQhUBSsqSluuQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nO4zzugW;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793103833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XMAIi+ms3AozyqZkPgacvobf+nGwdW+Hl+5nrtPKaU=;
	b=K0rF3OzJ1vMhCCM+ClyXTkzLiD6shSKosowX6viJ97PuwTmMcT0urXQY8QSDG4Fy7QkftF
	hlUf6D1+bW7K8tP52fl9UHuHTSr8IbtxSZzYCAYa4F64jGzxIzIPP2HpEc9zJG+p5uRh+V
	mca5PZVY/k7xtG0IuxLOxnwfAO25V98=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C48C74031D;
	Tue, 27 Oct 2026 12:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDF11F031E0;
	Tue, 27 Oct 2026 12:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793103832;
	bh=+XMAIi+ms3AozyqZkPgacvobf+nGwdW+Hl+5nrtPKaU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nO4zzugWouyYcR/L2Y+0RXHZxQVK21ccEHee5lnZn6kJV5CThrVH03KeXr3scy2ve
	 ZxGbjaKBu+xOcKJG0YbRg+MXxMMTWz7nFqZpS9ZwGLvi8481ApkKCsMIYqhFU7We6X
	 iaSYKD6Xe5oAeTK+qcY1L77CUmaRfnFacHejQwT5LweAYcjl8oXUJv3RP/FUlG5P2n
	 VvcxqhY/cct0rUPSl1kRnEiE4QvHlQjxfU6+QrOleMnVAMAXhHQw2ML+3KpQHM5sQa
	 fjimw0OldXyJ+jjXOeLVZTd2OvDBAWeHgIP+6GKqC1YHhQi1lQsH5tq8EmMnoqxxxT
	 p9b/lI05p4djA==
Message-ID: <sashiko-outbox-186543@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] riscv: keep booting if KFENCE pool reservation
 fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jackie Liu" <liu.yun@linux.dev>, glider@google.com
Cc: dvyukov@google.com, elver@google.com, pjw@kernel.org, alex@ghiti.fr, aou@eecs.berkeley.edu, linux-mm@kvack.org, kasan-dev@googlegroups.com, muchun.song@linux.dev
In-Reply-To: <58e3baebbf4e454725e6bde8b7a267fb71cfdaae.1793017074.git.liuyun01@kylinos.cn>
References: <cover.1793017073.git.liuyun01@kylinos.cn>
 <58e3baebbf4e454725e6bde8b7a267fb71cfdaae.1793017074.git.liuyun01@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 12:23:51 +0000
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DCF020003
X-Stat-Signature: yh3hbgterauduhgoma9b99mzrtgj6k6s
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793103833-290493
X-HE-Meta: U2FsdGVkX19zhPrqBCrdvwlHzUHTACbHACc/G9/bcOwyydVDbmt37IL/lTqEnqKN/65ebR2Wa/Ba+RkhE7zXuX0eTKravZLBZOfractg+8YWU6ddKyuMjbd4/myfWK3HLj1vK7t+PkvtFArIMo9U4khY5cUtsAsMRpYKeXoLi2559HEs66kRP5RYJ/hoSXHB/6LhCyCXbiS2kEbFMUxYn4sYDcDNUJ6I8g9Hh7+n0RVP2Tf2Zy9DtPyKdCF0U6EtKZcZ/jQSo8N++JWNynLEHG+j2bY4O94dwHiXcG2qnRN1oaSxBR6JjJ0IedLfmBVScalTSBOnWqcmH7MRfQ8qFOlJoi3VzamU8alFt3d5fOEfND5xNdhq1fRuJtR6F5worVeSJ7OnLgttNClQeZQACJTytSRlOhPdYHJyBtmrX7r045p76W3EkBC6biDkRYpx6qkDGZd2J0dpAYp0p08rpffPxpUTrJgDh9MKzMqQNK6ldp6WO4oKtdYdHfDix/Ix+CZbhccJCTaIvzIFUO+zcvn9U81jCEK6Xlp08nVdLOBfZYNGrQWGp+eQSGdG+b29rYpJcO3Yarghe7c+iGH5mvFI+gtGeS9fOaP5gh2CAfG2QNiUWtOGDn3yIQqBem1LKZssnycLcsudAgNhARG50KtulthGUDFqgIIC5KTucb0AJBia8Vhb2IVliXGIUoMuuuW5+IMY4FIdAFGpUgrfInxdCtsQMsKeMpjTB4HS8GpwNR/DpmmrpfkfqBswPNwdsWRsyH4Od/JLZtMBvWqKWCqDsM4uJ3zCmkDztvJ5Fp0lEOv0820JMYYxSa1ztGZBSfUgFuBaND2c8sP5tZKfXY800F2PkViohxH0u6QtkrL2iiGoxhOGTk9F09wXBWmHTRi/f+xuBO2rxff3L+wmZHRcVa/kzYQ2GgW3vz1yis7ksySFgod9a9IWAIN7tauKYX7QHBhz723tCki2z1F
 gA5dwMKz
 QLGuCnZ4Uxw21nP2Zp9/myCXXaSzfbppBHpYRzgswzGsL1E9Aysnv9asTBWfKSzEshzbKfHYbg7yGR5IxTybXJOGZdWv18NC1/P75jZxsZM77iQmtMDrX4Aaik2ocr6itx6AWSHN3SKuJxup5dDBCTTwDetrDZpW8QGUn0BpTl6Y41woGQM0IcGfqdoea0X7Ah55rN2810ILA324ObCgSP2PPf1eXUln/86lC7qkybDTWKRopTccBo4E0p9h+U6Yw100qb8/tZqfFPYp0uqgQtKunSg7WPA3p6yNZjjBIjX6v5tY7Z7/GJHh1EwTZ52eLGWDZOWAg5SjKTyq5QG4EV5W8myYI6wUZb+9MPvzjW5EBmCHl9aY2Ei/n+aoYqS7LZdAX1rIdIZNBXlh4/MObjIzsfbPoW/LM6wnhunYn1u9ekYIRbr/P4fD8BC84tDY5QzPUW2fZS0eq6BZrjcpyWtHlQqgOhUBuxEDmlmGgkxkAU5DQfWPP0X6qjJgvI2C+eK7lW9qxgW07u13mfKtVucXIb3E3XyJBtXzf/s0uWnsrat/AJy6KjMEq5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] riscv: build failure on 32-bit and NOMMU from including asm/kfence.h
--

commit d964a4c4107a3db6e2c99928c0888060598196ba
Author: Jackie Liu <liuyun01@kylinos.cn>

riscv: keep booting if KFENCE pool reservation fails

This commit avoids hitting BUG_ON() when the early KFENCE pool reservation
fails in create_linear_mapping_page_table(), disabling KFENCE instead so the
kernel can continue booting.

> diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
> index fb37b0b67efec..393106cd25ba0 100644
> --- a/arch/riscv/mm/init.c
> +++ b/arch/riscv/mm/init.c
> @@ -27,6 +27,7 @@
>  #include <asm/fixmap.h>
>  #include <asm/io.h>
>  #include <asm/kasan.h>
> +#include <asm/kfence.h>

[Severity: Low]
Does including asm/kfence.h unconditionally in arch/riscv/mm/init.c break
32-bit (CONFIG_32BIT=3Dy) and NOMMU (CONFIG_MMU=3Dn) RISC-V builds?

arch/riscv/mm/init.c is built unconditionally for all RISC-V configurations,
whereas HAVE_ARCH_KFENCE is only selected when MMU && 64BIT. In
arch/riscv/include/asm/kfence.h, kfence_protect_page() is defined outside of
any CONFIG_KFENCE guard:

arch/riscv/include/asm/kfence.h:
static inline bool kfence_protect_page(unsigned long addr, bool protect)
{
	pte_t *pte =3D virt_to_kpte(addr);

	if (protect) {
		set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
	} else {
		set_pte(pte, __pte(pte_val(ptep_get(pte)) | _PAGE_PRESENT));
		mark_new_valid_map();
	}

	preempt_disable();
	local_flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
	preempt_enable();

	return true;
}

On 32-bit builds, mark_new_valid_map() is not declared because
arch/riscv/include/asm/cacheflush.h guards it under
#if defined(CONFIG_64BIT) && defined(CONFIG_MMU) with no fallback stub.

On NOMMU builds, virt_to_kpte() in include/linux/pgtable.h,
set_pte() / __pte() / pte_val() / ptep_get() in
arch/riscv/include/asm/pgtable.h, mark_new_valid_map() in
arch/riscv/include/asm/cacheflush.h, and local_flush_tlb_kernel_range() in
arch/riscv/include/asm/tlbflush.h are all guarded by #ifdef CONFIG_MMU and
are undeclared when compiling kfence_protect_page().

Should the include in arch/riscv/mm/init.c or the contents of
arch/riscv/include/asm/kfence.h be guarded by #ifdef CONFIG_KFENCE?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793017073.gi=
t.liuyun01@kylinos.cn?part=3D3

