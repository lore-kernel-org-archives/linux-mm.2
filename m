Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B51606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=btLwY/D4
Received: by kanga.kvack.org (Postfix)
	id F11FB6B05B4; Wed,  4 Nov 2026 05:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC2B06B05B5; Wed,  4 Nov 2026 05:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD8036B05B6; Wed,  4 Nov 2026 05:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7B5A6B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:14:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 66FD0A831E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:14:01 +0000 (UTC)
X-FDA: 85397025882.09.24A3708
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB5CD180002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:13:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="btLwY/D4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793787239;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wjuPdEIW1r5lz4xv5DqdpCHSpNI3Pzvy2rxa15uD2Q=;
	b=OKjf3SYthZX3L+Uru/DbsoWRmdMF+XVtRSrfCFF2Tuwwb5Ry9ZpkejS1zal3YB29b3cb9+
	IdjbLS8dnnwkfl03IkM2+hKaBgotjFXah7O+StY/MNx4Bk2eLLQcDCgtrHe29ejInaQ9tJ
	Mllksix0FAjaAGVbjeDtuC7Fr0lI0aE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793787239;
	b=jF6nyeDq8b5WKOzLSAqTe/4AW91mZcKbfFNUS+YdG3MrRAx27a7iSRmeAxKNelpz44erqD
	yA9OzgEQCZ+k3xyF2XDUFaze4/3vflzcEQGyU7r/pf2ZfJ4XiZvQz7zxRGSjbqrYPYzLWc
	yXrfHX8zqiRlgFsVoaqQWxhlkvQ5s3g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="btLwY/D4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B348609D5;
	Wed,  4 Nov 2026 10:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB5911F000C1;
	Wed,  4 Nov 2026 10:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793787238;
	bh=4wjuPdEIW1r5lz4xv5DqdpCHSpNI3Pzvy2rxa15uD2Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=btLwY/D4lsJeFzCdcAEzD6wdjTx1dloaXX+ZKmDhCoPvHChoVNNWec7D31VYA5gSA
	 CEcfoRM80lWwZgd5JEx5YrXUAQfGvVqpv8ClnaFi/yU5KyNsytcL2oEuDJN8M5U3hq
	 A0zpAPALizsCrwmKAaGrBOXQ3gEzjZLL3nKahGHku/25b8SIfwmbBmWkfFCpMtf4Ju
	 4GZ8wCVNMqM2QISUHCLaS3MUvvJYTbWbojaagUvLeZTHJV5rm0j+FGHE05jrLKCPsw
	 SR+K+bAvmHbpjph8Tj/BXwNjLMXpJqbWzIdLraYbLhh5m9D2ohbwovruQmr2HNofI7
	 4Hz/g9o32cnlg==
Message-ID: <sashiko-outbox-197069@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] x86/mm: Define the zapped-entry checks only with
 CONFIG_DEBUG_VM
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kiryl Shutsemau" <kas@kernel.org>, "Dave Hansen" <dave.hansen@intel.com>
Cc: "Dave Hansen" <dave.hansen@linux.intel.com>, "Andy Lutomirski" <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Rick Edgecombe" <rick.p.edgecombe@intel.com>, "Thomas
 Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, "Peter
 Xu" <peterx@redhat.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoTWljcm9zb2Z0KQ==?= <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Andrew Donnellan" <andrew+kernel@donnellan.id.au>, "Rohan
 McLure" <rmclure@linux.ibm.com>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Tejun
 Heo" <tj@kernel.org>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <aumzjHyJsshPJBUI@thinkstation>
References: <20261102144001.342837-1-kas@kernel.org>
 <b04316eb-a2f8-4587-9392-e673c7bd2fc8@intel.com>
 <aumzjHyJsshPJBUI@thinkstation>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:13:56 +0000
X-Stat-Signature: zktesbxjpohm5mawimejaz3k7qq7bt6x
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB5CD180002
X-HE-Tag: 1793787239-267488
X-HE-Meta: U2FsdGVkX18n3sDVTKR6DR6gnEZVgPiYfEQtCEpydKVpopd6bulfhCAbNwKwuS5SPRLfnxR6ADI87xKI4VGMw0OIOZGZxVt56D5M74lNW82z7agouQ3zhOysAi2PROT2IPDxKxr8VzgG2wQkudyYUcOGIJ5MXMrmiOOehhs0DBU5BD5N9ue2MAZd2cBWGa46IjDHYS79r6flW48236bg/xGjys/xN0Ww2xXXE36W4B8hy5lmGwbqkxGAAYWNRWwmoAWr+O77CaE5bhb1JawUnG1FBztYH/HDli2XpNKdo90mq3bWsdlQJ8NXD7xoKxemqiBCZLlMP03DXV2gckCrssRsIvqaCYM7KTB/gwdA9bgQ1laTSJRoRCEYHOSrWzVVQtO7A8JvWdMYKSZ4lsHaw6dpwhy1Wl8amjBEhcRHM4ZtkkuSNj3GmVW2zFGddjvO6hNe0Y1q1t6wD6pYtkGNb5SHj7T5O0zJ6hcOHq7qVAp+8F+pGmVZy2lT17Q8Y7NPpndpsIUHSyqsygCsYXZ3bGDmSJJsy1y1+XESMFFFhUhdeEwcGLYoQWB8NEUN1dt65EfXaJ7zdba3LZEwEnF2AO2+to7V+0GB+r3pwlzb7muAMji/H56odw4oq5dGteubPOlIYm84Vg+UNQVMAMesL+o3okK1N8YDQEzF4jKdeF4VNxb3qnh+Xzj/Rhd+7jvGMO0FlVDOb9+uThyDx0WQR0vMjSHIULPGS7QLXi2fNBTMW12QWXUcyqPGCCqDRg97yJ02xRs7fjVos7ilji3JSf12PlsD8isx3edkRgP1CuUHl2eBJCbBK7g2IDXJTCT281Oq/5exW3QDtvFnOuz5BthXqARe7QNxgEOcpjGV4Qa6BG7TmItHUqZRUpKcp/3rglA8akoka4brx6XT5/uDkRI0fG2WfMJVjNtoXKJesttdv2X83XaMr3n036dBygiiIZLG/tFv/uDWKXuKROu
 73c0Ey9x
 asJxc6Mtt99iaq3MN9Lhk2gR1YVOGMUx4ULdVfmMNVHQ2VRt7+b9xcDBYsVVi+nmcPtQxSGsSfAbMSSS8J+dyb3YVWRtbu1xNKJPq7aAqRwVeNmxQ4hiCKyxCZD5AGT5LW0it1DE8sFAoOunMRN01D0XaCr1Q0s4cV+pgvYRnUnt/O/PpGHZVfcYtwryFHLtQyLdrJi2ufA1aA0lmj4LzZQLhID3654DkkHciuP5g3YWXebw2/auMdd2MsrsiGstuIQQu9Q0pUWa39QzZKyZywZSnIpHkpu8Yh7T/KtTUJSeeEKGpvDF8PqcroHYTLnKhcVGBhlTC+1eGX5EF2FJ27EGjJWu97FiZRQdum0437iT4lFwgetPpWNI8UPE/bMWeSLueYD0VeHUAjC99gblfPvo/Qss34nhw5QfMvo0Oe4kqceGGs2uB471oOXTmQw+qYRusrRuAT6FHEmxkTHDYPgXKilm05iN6KUr6mcNvN3anZ+sg4SJQjKM/Tm0hupbofJ0HoD2NGAsUqjfqgl33EqD7zWNcRwOQ5bHEngMpqV4Ec+ymuFlCuW+J4jcfO3msSRP6KJ28LAfCNz3ws+45wt9TZXI6abklxJ16V+nyj/1RhwNxoz1qCXI+VMhqQpUXz/clMbO/6+FyZ2ylm6c+/uv2r6e3MuTIIbUPmS0MXsl40voupLywpesfGrWoo0+ptRp60jlJMQo3h4TR4CJsaPrACjR/h/TLyuAdM2qjcGunybQO4GOqq+4A1efsg4nhSeCklj7iUXPyyIfPkdVd8dEr3qy5lqk8c0SPtsa6/OUxuS5yNo0RPAV4zQ==
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
- [Medium] x86/mm: commit title contradicts code and changelog has unstripp=
ed scissors
--

commit 1651219a7e4a74c995baa4203be8528bd7cfe1d0
Author: Kiryl Shutsemau <kas@kernel.org>

x86/mm: Define the zapped-entry checks only with CONFIG_DEBUG_VM

This commit removes the arch_check_zapped_pte(), arch_check_zapped_pmd(),
and arch_check_zapped_pud() helpers along with their callers and
pud_shstk() to avoid return mispredictions during page table zapping.

>     x86/mm: Define the zapped-entry checks only with CONFIG_DEBUG_VM
>    =20
>     On Mon, Nov 02, 2026 at 01:12:47PM -0800, Dave Hansen wrote:
>     > Or, heck, I'm not that attached to these checks. Let's just kill th=
em.
>    =20
>     Works for me. x86 is the only architecture with them, although arm64 =
and
>     riscv have shadow stacks too, and the x86 helpers already keep
>     Write=3D0,Dirty=3D1 out of other VMAs. Patch below, without the Fixes=
: tag.
>    =20
>     Rick, any objection?
>    =20
>     -- >8 --
>     From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>     Subject: [PATCH] x86/mm: Remove the zapped-entry checks
>    =20
>     Zapping a range calls arch_check_zapped_pte() for every batch of PTEs,
>     which is every page for small folios, and arch_check_zapped_pmd() or
>     arch_check_zapped_pud() for every huge leaf. Only x86 implements them=
, as
>     out-of-line functions that warn about a shadow stack entry (Write=3D0,
>     Dirty=3D1) in a VMA without VM_SHADOW_STACK.
>    =20
>     The warning is a VM_WARN_ON_ONCE(), so without CONFIG_DEBUG_VM the
>     functions are empty, but the calls remain. With the SRSO "Safe RET"
>     mitigation the return of every such call mispredicts.
>    =20
>     The x86 helpers already keep such entries out of other VMAs.
>     pte_wrprotect(), pte_mkdirty(), pte_modify() and their PMD versions go
>     through SavedDirty, and only pte_mkwrite() and pmd_mkwrite() on a
>     VM_SHADOW_STACK VMA create the combination.
>    =20
>     Remove the checks, their callers and pud_shstk(), which has no other
>     user.
>    =20
>     In a KVM guest on Zen 4 with Safe RET, zapping 4K pages takes one bra=
nch
>     miss per page fewer. MADV_DONTNEED of 1 GiB gets 6% faster on anonymo=
us
>     memory and 8% on shmem, munmap() 5%. THP is unchanged. Without Safe R=
ET
>     the difference is within noise.
>    =20
>     Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
>     Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

[Severity: Medium]
Was this patch applied without passing --scissors to git am?

The commit title still reads "x86/mm: Define the zapped-entry checks only
with CONFIG_DEBUG_VM", whereas the patch unconditionally deletes
arch_check_zapped_pte(), arch_check_zapped_pmd(), and
arch_check_zapped_pud() in arch/x86/mm/pgtable.c, arch/x86/include/asm/pgta=
ble.h,
and include/linux/pgtable.h, along with pud_shstk() in
arch/x86/include/asm/pgtable.h and the callers in zap_present_folio_ptes()
and zap_present_ptes() in mm/memory.c and zap_huge_pmd() and zap_huge_pud()
in mm/huge_memory.c.

In addition, the changelog retains the mailing list reply, the "-- >8 --"
scissors line, and the embedded From and Subject headers ("x86/mm: Remove
the zapped-entry checks"). Should the preceding reply and scissors headers
be stripped and the commit title updated to "x86/mm: Remove the
zapped-entry checks"?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/aumzjHyJsshPJBUI@th=
inkstation?part=3D1

