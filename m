Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8558E606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OVPYEOJF
Received: by kanga.kvack.org (Postfix)
	id 89E0F6B025C; Wed, 21 Oct 2026 16:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 875406B0266; Wed, 21 Oct 2026 16:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D4B6B026B; Wed, 21 Oct 2026 16:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5446B025C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:41:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CA60CA0699
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:41:46 +0000 (UTC)
X-FDA: 85347804612.13.11E06DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34492100006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:41:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OVPYEOJF;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792615305;
	b=5+wi0SJr8cKO/N3xeLmrNVdHghUa7kMiVl2YYBD7BxiNCDdJk/Jd2gJOLtCbB2Mzs6Lw4p
	OUUfejBDjOu7RVhVnPEH+yPceoKE5U31TbNqsep0qf1yYFuX72ZC6H9l4QOsMbPXYH7MDM
	Zx/g5Jy33/+MbsVXPG03OeXOCLpTjh8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OVPYEOJF;
	spf=pass (imf05.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792615305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bq3V9J9F4ZHKrQtjacM7Tw7YXz58yMhcGPTw8dbAFrA=;
	b=R0ImgTfp9xFFRK4H/N7Ihbj9yy0pS72RcjgwC4dRIHcz2uMvvkvXfXaf1n+qpB079P1ZW3
	nzhSUmz2uJBZryqWuNJWcA84ugNgr8sJWdOBjkP7xREJj6SUl+QQtm9FqsWO+t+k7q5IW3
	NGjQcZFz6EEqE5u4AEZz1g1kEBX2KlE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5ED1441A43;
	Wed, 21 Oct 2026 20:41:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE1411F000C1;
	Wed, 21 Oct 2026 20:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792615304;
	bh=Bq3V9J9F4ZHKrQtjacM7Tw7YXz58yMhcGPTw8dbAFrA=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=OVPYEOJFHxyq2Jn+Mw16KBU0u4plWBYpqFAxZfQIetwIc4UlXVDL+weM0LK9cj2UC
	 RC8KozZM3bGjca4q5PGzfvxdvRwJkWOWFr6SOq4BzyWUPITiKI+LTe8X4uRMjUNDux
	 o0kFUr2WR0J0IuQvKhY7daAWRScMmQNEfuGX59yDrN/yz3Hl/bb5wylqgz1rXnJ+Ur
	 /wF7jX7kB1baY0FPJKzEoyCnvxxQdcgleWPu3ZsAxN84jz62ON9Shl1lw5DnEbGgH1
	 K1xe68vud9jyiFi7OU8IJFoVYDnBTVZsrdy2H4RReHnjjJZsPrfO+X/SdQsVJCsXVB
	 B/Xex9h+p1tyg==
Content-Type: multipart/mixed; boundary="===============3655339663897498520=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <ff53ef1657f7ecedb34c148ab05588f657dac0d092ffb55923d7bc6fd375bf84@mail.kernel.org>
In-Reply-To: <20261021195759.119421-5-jolsa@kernel.org>
References: <20261021195759.119421-5-jolsa@kernel.org>
Subject: Re: [RFC bpf-next 4/9] bpf: Add kfuncs to allocate and seal user pages
From: bot+bpf-ci@kernel.org
To: jolsa@kernel.org,ast@kernel.org,daniel@iogearbox.net
Cc: bpf@vger.kernel.org,andrii@kernel.org,eddyz87@gmail.com,memxor@gmail.com,linux-mm@kvack.org,akpm@linux-foundation.org,liam@infradead.org,ljs@kernel.org,linux-kselftest@vger.kernel.org,shuah@kernel.org,john.fastabend@gmail.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Wed, 21 Oct 2026 20:41:43 +0000 (UTC)
X-Rspam-User: 
X-Rspamd-Queue-Id: 34492100006
X-Stat-Signature: 1xz5tespzs9ucij9cfkgrn1dnqx8mw3h
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792615305-644474
X-HE-Meta: U2FsdGVkX1+nC9KNiY+vw2JFzmB1EgIrfXN5x4wQnN5aNlNdTxNMEatVtFA6ZVGfioKyIZeMyceyBHpn5GcrCa76BvJEA5Tnzb8mshILcCyCzaXHvF0buskTfRFJIGBWrwGgY2j6DjzqVivpXS5nzPzkiGR0fvg8oeJYGw5b8xIf8FEWspF9AKKodcr4Z4ih7EzJcQGyNZ9S5VtvLjg2dCHteaPBCS8Ka4+jljgXLvN0nQJT7yPVwJ8irPyUwzFnsEY19koIVGxv/QXaX83XtLN17BdMJulQF9HLw/ZK8M63ERq+TAys0CSm5CqlbJ8LneUEpFxgIjKcRATFELiwX3flA54mqZ8n4KvJbxxYHmrCzotfkxqrpDEeS9r5+ziYUN+ot0r5H055mLT/naa1ZTQzdVLPLxJDcQBH36erBsRlIQmR8/NuPuMl7zV+y0IpeKgmpbNXnCptkVr8uN2vXO9Z51KuUvn7s1+MGE/U+qkbar6ku/+4qxhP52Y+DUsE+/kflGHSECVyQ590sxKvhEvy9fr/L9FZ8qY2f+kDjHKvRSkkf+xYEnlHLimmZ46gq1iMlqq91CLpqXfEDbqJZ6yZ9DbXRHJnB0Mny6gXJyLc+1IWuSWh+iprAocgiYxImn0Iuaeh5uK1GJrgFWazjH/XJCMjH6inhlT2k7OeE9OV6pdoa5PwjMald6SoCeT4lRaZY8jpYEExIH1gDawYCrdKn/5/BcSp8NFVJvwrsrPr5tDLFZhvueL6yWIPDFLgqT2AHl0WWGKnMj4RCO9Hk6GeQ10dUE46VOr+iGH0bZyk5EXYuYnGk7Z/vXY0o8e+IFAu/YBTWmIniMYc/22ZnA0vNnfjiVVKnOIP/g/Eoz+FYFGVHrmY1zOc7lVtXi+y+NdckvBGwtjTDzd5HCeXPWFYm89iSOO0nxPEarRhjsFK7dvmQc9r0AuKGq5cW1LEB/EZ/9Ptn+ELO98+yso
 yW0pR3+1
 UvYjhc5+61JjPUrEdwmLsmNReLYMilw8Vw29V9lGJD/e8OT7lNUz71DeeR0lVgdXw4xZbWpx9pE72zY6KHf75kOUgLbJmvvLeCV1Zauoyy2K0qw/uax1GexaN0TjQ/l64nFSFYtq+c37VoidhRNQxo2NJeKcuS3HXfnfyelRcG92U/aNNgPyH3EYmF2IdJAkulZEvV4HY8aYHh2QGMZqYJ8e+gi3C3hs45xaw932uDLVy2MUuzf2R8s6x37889foT2YcGY5O+Kok5Z3KhAl72TYBQrfUeO0UcchbdifI0nuV2lzOmo29y3e75LZ16VZw/1fyeASmqL+5Knfw54XPvFIMhM2QfbCzPsSqdQ66PKSoRnhiyNweOXgWSsqtThFQMlbVJL85/j/sDZN86kb4nusN6jbBy2Cca8jRkDA5cX1Smmm4DB7Vsl1opRAaMB7O44oy7yR6CUtmPcW2Bz4m/N6JScM75rnnP9I33dNeF98+NXx64p2Cu7NLIe4NZ8rKtq43ovh1Nb3tFBGM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============3655339663897498520==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> bpf: Add kfuncs to allocate and seal user pages

TL;DR: bpf_user_page_exec() may skip the icache flush on arm64/riscv, since
flush_icache_user_page() runs before VM_EXEC is set, so with THP a task could
execute stale instructions.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 4d9e9423826a..246f4969a144 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -3739,6 +3743,127 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u32 dst__sz,

[ ... ]

> +__bpf_kfunc int bpf_user_page_exec(unsigned long addr)
> +{

[ ... ]

> +	err = get_user_pages(addr, 1, FOLL_WRITE, &page);

[ ... ]

> +	flush_icache_user_page(vma, page, addr, PAGE_SIZE);
> +	err = do_mprotect_pkey_locked(addr, PAGE_SIZE, PROT_READ | PROT_EXEC, -1);

Does flush_icache_user_page() do anything here on the architectures that
need it?

At this point the VMA is still the read/write mapping created by
bpf_user_page_alloc(), so VM_EXEC is not set yet.  On riscv the macro is:

    #define flush_icache_user_page(vma, pg, addr, len)  \
    do {                                                \
            if (vma->vm_flags & VM_EXEC)                \
                    flush_icache_mm(vma->vm_mm, 0);     \
    } while (0)

so it is skipped, and VM_EXEC only gets set by the
do_mprotect_pkey_locked() call on the next line.  arm64 does not define
flush_icache_user_page(), so it falls back to the empty stub in
include/asm-generic/cacheflush.h.

That leaves only the set_ptes() hook that runs when change_pte_range()
installs the read/execute PTE.  On arm64 it is
__sync_cache_and_tags()->__sync_icache_dcache(), and on riscv it is
__set_pte_at()->flush_icache_pte().  Both only do cache maintenance when
PG_dcache_clean is clear on the folio, and then set it for the whole folio:

    if (!test_bit(PG_dcache_clean, &folio->flags.f)) {
            sync_icache_aliases(folio_address(folio),
                                folio_address(folio) + folio_size(folio));
            set_bit(PG_dcache_clean, &folio->flags.f);
    }

The BPF program writes the instructions through the user address with
bpf_probe_write_user_faultable(), which uses copy_to_user() and never calls
flush_dcache_folio(), so PG_dcache_clean is not cleared again after the
first exec mapping of the folio.

With THP enabled (arm64 or riscv, 4K pages), can this sequence happen?

  bpf_user_page_alloc(512) returns a PMD-aligned address
  the program writes page 0, and the fault maps a 2MB anonymous THP
  bpf_user_page_exec(addr) splits the VMA and the PMD, the read/execute
    set_ptes() for page 0 syncs the whole 2MB folio and sets PG_dcache_clean
  the program writes code into page 1, which is still read/write
  bpf_user_page_exec(addr + PAGE_SIZE) calls flush_icache_user_page() again
    as a no-op, and the read/execute set_ptes() sees PG_dcache_clean set and
    skips maintenance

The task would then execute page 1 without a D-cache clean to the point of
unification and I-cache invalidate (arm64 without CTR_EL0.IDC/DIC), or
without fence.i (riscv), and could fetch stale instructions.  mTHP sizes
give the same result for smaller allocations.

The uprobe XOL code, which also writes instructions for user space, does
explicit maintenance through the kernel alias: arm64 arch_uprobe_copy_ixol()
calls sync_icache_aliases(), and riscv, loongarch and mips call
flush_icache_range() on the kmap address.

Should bpf_user_page_exec() do the same, for example with
kmap_local_page(page) followed by flush_icache_range()?  Alternatively,
would calling flush_dcache_page(page) before the mprotect, so the arch
set_ptes() hook redoes the sync, be enough?  Either way the flush would no
longer depend on VM_EXEC being set at the time of the call.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/39668036298
--===============3655339663897498520==--

