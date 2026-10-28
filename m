Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D4A9606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KWbAZ9I9
Received: by kanga.kvack.org (Postfix)
	id 5BB086B05B8; Wed, 28 Oct 2026 07:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 592436B05BA; Wed, 28 Oct 2026 07:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7DF6B05BB; Wed, 28 Oct 2026 07:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B89E6B05B8
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:43:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0924160C8D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:43:39 +0000 (UTC)
X-FDA: 85371850158.26.BD07C52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F191180003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:43:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWbAZ9I9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187818;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WVtKokqXcM85OwTWDP0OGcE54KRFalbPr4wTUTcopSI=;
	b=lwlSJj/UjfU9LTEUXQ5z+V1Kw649N97A1QtkxfMV8nkV1eN4cB6op9TU/xKgOR7uFeLaDe
	o7tC8PmlBmHCoD+98Jl+gqUHsbCMKEZZsgGYBBCoyLOFRtD4CyS/7Ap8ZR8308dNJm2DU/
	G72WO5ye/fn461QcpeiGeL/z2pXLgvQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWbAZ9I9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187818;
	b=plq3ww9F1vxWs0XxhJ1K1iRtrWdkcCjHknqgT8I0SwH3ANxsffI6GGA6NGtQzxROt4nhBQ
	W9NkBVY1/PXIHxltxxa1pVEYYBfRfQVCKzTTnUk3sg8a7ZlzfN8+aNy7urYP9VL+nrTD5y
	eE1oul0TZ3PIrbcQZ4KJiH+M1PaSbBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83B336020A;
	Wed, 28 Oct 2026 11:43:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480F51F031E1;
	Wed, 28 Oct 2026 11:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793187817;
	bh=WVtKokqXcM85OwTWDP0OGcE54KRFalbPr4wTUTcopSI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KWbAZ9I989LkEOCeQPwgr/NwkuOWokbOVkvVJfU2cp1f+zLVYwrgYTTM7YAgJJ/+A
	 9NaICbviEkKlKv2cO6i5CJCNl8JbrerDhSFnSsWlF5WdsOiAjwsiZvU/bB9VRW4Rqj
	 3ErWmaN1/4OVZ3jjXPYeNqc29UZU9IxQhITrasMI2a6ZhRB4ma9WuuQavPeWAg74+T
	 rogKCSl6CXKrblq3SofeNUW+roPaHn3/Tarct4TO+gpeGNVNl/LBNb7yOht+yCK04J
	 pQWubTW0a8XxM18dGrr30uYFCf5usMEovdINlMWlxrU7N1UQ0zSjutiMYzD76w7InH
	 RIDxadJI+Y2rA==
Message-ID: <sashiko-outbox-187839@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/3] selftests/mseal_system_mappings: Test vdso unmap
 and remap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chris Down" <chris@chrisdown.name>, "Andrew Morton" <akpm@linux-foundation.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Lorenzo Stoakes" <ljs@kernel.org>
Cc: "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>, "Kees
 Cook" <kees@kernel.org>, "Jeff Xu" <jeffxu@chromium.org>, "Andrey Vagin" <avagin@gmail.com>, "Alexander
 Mikhalitsyn" <alexander@mihalicyn.com>, "Paul Moore" <paul@paul-moore.com>, "James
 Morris" <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, "Shuah
 Khan" <shuah@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, linux-mm@kvack.org, linux-security-module@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <621847973ba2ec49d0a58e0261da35a9f3a97eda.1793094611.git.chris@chrisdown.name>
References: <cover.1793094611.git.chris@chrisdown.name>
 <621847973ba2ec49d0a58e0261da35a9f3a97eda.1793094611.git.chris@chrisdown.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 11:43:35 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F191180003
X-Stat-Signature: 6umscbo4wnd17jjqy9cz535q81nnx5xs
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793187817-240227
X-HE-Meta: U2FsdGVkX1/U6ntL4TKSt6ydylGM9C4xutXMHI3lPbkWaxjTsTHsvz1xNCRPd4Lakcd2rs1Aqe9hlGDT9Na2dHFB+wFvcnbVsrYCISkCRl0m8/fdUsQQiGyo61uMw298EUaZwqNB+ftVIeP5bTfI64jtt3KcFpbagkloJ5AkhTSe0UKP3U8+Y+m6tBoeoABWk5N00YhQWSoWG95JqmmtVvZ90a2v9vRbVQyoh7MDltERKVix9a2ud8ni120SlMsUZ+mNWR84YXO5cMYhxq3KO6bUOzXGI53tdozmEApQFc4NPmdVMvkqwfM6+4NXDRvpHRfA4BVg2D2bk/I/wEKFifMFg0k3ZkPGsnb9xBlTNmK6t1TZvXW4/c+l/VZgRyeKCb2HGP3YF+OKz6bBpS+QbIqAkmjBIYrZhCDkps9bGOELqvh6UlXDKh+S0PVwg1qQld2onuLzXjEnD9ZBTJ5FaAriBPWfm8lqwVVNsjZrvGpUEziHjnhYABMUpOAO72E9ahTHMmNsaj7p/BwVlZXKk0yPQ96k7M7xu4OVTNQwTJhBj2Qkj5Ubz077XxW2FeqiajxjAshHHyoWbrhtvIRVG3IlYBhCQ6cnrpwu9xbgZEBjZCisJg90fs1PV5R4OqVw2GKN/ngw02LKNY6lwWkWltC9SL9IbmFbtOQjdpqPBeWZPPFj6Rog6vtSCrk/zHTIA2sPOOyMeZw3GHC4eaivCy0PL9hwHdaDT2uLP83aS7BRAGIW7rALERAxR5zTLak0o/QTGr5fZjYJCth0zrweluU11ycG/Lw/6WeIKy9Ej0+M5w1CUZMBzdvOFJ0uBvPLnJMJE6HnKkwaiAIZMJ0OElzsTn6rPjiP8OZ6W/AYceia2bmXsg0Mrm6gd8z87U3e1BPxX+J7gURtObeacnUi0uAfBzcK6KvrKnI5CumIW2m8uyXU3mBkUKFDhc2EROXX5oNpuNPSripFq3GN0oz
 DVY9tAKH
 EcfmOk2YNieuAQSlMOQmnDta9Sx87HbXPiJOL0WOAKFOV9QxUbEpRFxkxULYh6tZYZ+Pyx5THJVmpcB9eUvrIeTGPtcjMmCGW3YxcRZ5aPmSJHYygi8ME6fTmXQ7jEEVOw+asKivkSfHpu9t5UA7YjjYUgdsdzrqsZHBO0HSW57ph9zLedHaZaQlgtY+1wxY+Kxo6jI0R8/CuFGdY1LYXrr8fonpr6DTR2HYUMTpAUJeSrp7XIJC0IIJ/glQRe+npcP2aqDvDds/7ID4vwr4uflwhNda4j2js3OlDEO7w+6oL0tAkErznwxvfDjyR3XqontWTeYqABO8vxOMZiGkxAHIfvDiOkriXUTgq5U0M8BtzfsaBSm+cRYHRYdK1meFakuTWS/laO7cw2CmZfCUHKHM/M6c2/BQGzH6mf5WRrcL3gM6+D0vfNhjeN/b2Mzs4QWej+UysLC2WJdAk7maZw4ymDLSN1USAWirIJj5fTXdY6F8snIeTcYCw2TmBrdqmiVcBUBSO3GUQZTIljlAoNDmssg11oGfXOjQvNtJ6gkpHZHkS6805aL9++hjXjI9CtHgkExZ3qwonnmZJ7dG/3ktisW8o2XmiPDy0tTqI15y0r9I=
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
- [Medium] selftests/mseal: SIGSEGV in vdso_munmap() and vdso_mremap() on 3=
2-bit x86
--

commit c39ca555b3d21581707989b9c4e4f219f86ffc25
Author: Chris Down <chris@chrisdown.name>

selftests/mseal_system_mappings: Test vdso unmap and remap

This patch adds vdso_munmap and vdso_mremap tests to
tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c to verify
that unmapping or moving [vdso] fails with EPERM when sealed and succeeds
when unsealed.

> diff --git a/tools/testing/selftests/mseal_system_mappings/sysmap_is_seal=
ed.c b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
> index ea75ad537620b..83b4fadfbfe79 100644
> --- a/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c
> +++ b/tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c

[ ... ]

> @@ -232,4 +233,95 @@ TEST_F(basic, check_sealed)
>  	EXPECT_EQ(expected, sealed);
>  };
> =20
> +static bool find_vdso(unsigned long *start, unsigned long *end)
> +{
> +	char line[MAX_LINE_LEN];
> +	bool found =3D false;
> +	FILE *maps;
> +
> +	maps =3D fopen("/proc/self/maps", "r");
> +	if (!maps)
> +		return false;
> +
> +	while (fgets(line, sizeof(line), maps)) {
> +		if (strstr(line, "[vdso]") &&
> +		    sscanf(line, "%lx-%lx", start, end) =3D=3D 2) {
> +			found =3D true;
> +			break;
> +		}
> +	}
> +
> +	fclose(maps);
> +	return found;
> +}
> +
> +static int vdso_is_sealed(void)
> +{
> +	int sealed =3D -1;
> +	FILE *maps;
> +
> +	maps =3D fopen("/proc/self/smaps", "r");
> +	if (!maps)
> +		return -1;
> +	if (has_mapping("[vdso]", maps))
> +		sealed =3D mapping_is_sealed(maps);
> +	fclose(maps);
> +	return sealed;
> +}
> +
> +/*
> + * Unmapping or moving [vdso] must fail with EPERM when it is sealed. Wh=
en it
> + * is not sealed, it succeeds and leaves glibc with a stale vdso pointer=
, which
> + * is fine because each test runs in its own forked child.
> + */
> +TEST(vdso_munmap)
> +{
> +	int sealed;
> +	unsigned long start, end;
> +	int ret;
> +
> +	if (!find_vdso(&start, &end))
> +		SKIP(return, "could not find the mapping, [vdso]");
> +	sealed =3D vdso_is_sealed();
> +	if (sealed < 0)
> +		SKIP(return, "could not read the [vdso] sealing state");
> +
> +	ret =3D munmap((void *)start, end - start);
> +	if (sealed) {
> +		EXPECT_EQ(-1, ret);
> +		EXPECT_EQ(EPERM, errno);
> +	} else {
> +		EXPECT_EQ(0, ret);
> +	}
> +	EXPECT_EQ(sealed, find_vdso(&start, &end));
> +}
> +
> +TEST(vdso_mremap)
> +{
> +	int sealed;
> +	unsigned long start, end, size, new_start;
> +	void *dst, *ret;
> +
> +	if (!find_vdso(&start, &end))
> +		SKIP(return, "could not find the mapping, [vdso]");
> +	sealed =3D vdso_is_sealed();
> +	if (sealed < 0)
> +		SKIP(return, "could not read the [vdso] sealing state");
> +	size =3D end - start;
> +
> +	dst =3D mmap(NULL, size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	ASSERT_NE(MAP_FAILED, dst);
> +
> +	ret =3D mremap((void *)start, size, size, MREMAP_MAYMOVE | MREMAP_FIXED,
> +		     dst);
> +	if (sealed) {
> +		EXPECT_EQ(MAP_FAILED, ret);
> +		EXPECT_EQ(EPERM, errno);
> +	} else {
> +		EXPECT_EQ(dst, ret);
> +	}
> +	ASSERT_TRUE(find_vdso(&new_start, &end));
> +	EXPECT_EQ(sealed ? start : (unsigned long)dst, new_start);
> +}

[Severity: Medium]
When sealed =3D=3D 0 on 32-bit x86 (__i386__), will vdso_munmap and vdso_mr=
emap
in tools/testing/selftests/mseal_system_mappings/sysmap_is_sealed.c crash
with SIGSEGV and cause the test harness to report a failure?

On 32-bit x86, the kernel passes AT_SYSINFO in the ELF auxiliary vector
pointing to __kernel_vsyscall inside [vdso], and glibc caches this pointer
in %gs:0x10 and routes all system calls through it.

Neither vdso_munmap nor vdso_mremap skips on 32-bit builds or when
CONFIG_MSEAL_SYSTEM_MAPPINGS is disabled (which depends on 64BIT, or may be
disabled via CONFIG_CHECKPOINT_RESTORE=3Dy or mseal_system_mappings=3D0).

In vdso_munmap, when sealed =3D=3D 0, calling munmap() via glibc enters the
kernel through __kernel_vsyscall inside [vdso] with the userspace return
address pointing to the landing pad in [vdso]. Once [vdso] is unmapped,
returning to userspace or calling find_vdso() and _exit() in the child jumps
to the unmapped [vdso] range and faults with SIGSEGV.

Similarly, in vdso_mremap, when sealed =3D=3D 0, arch/x86/entry/vdso/vma.c
updates the return instruction pointer for the mremap() syscall itself via
vdso_fix_landing(), but glibc's cached %gs:0x10 pointer still points to the
old unmapped start address. The subsequent find_vdso() call (which invokes
fopen(), fgets(), and fclose()) and _exit() in the test harness jump through
the stale pointer into the unmapped address and fault with SIGSEGV, as noted
in tools/testing/selftests/x86/test_mremap_vdso.c:main():

#ifdef __i386__
		/* Glibc is likely to explode now - exit with raw syscall */
		asm volatile ("int $0x80" : : "a" (__NR_exit), "b" (!!ret));
#else /* __x86_64__ */
		syscall(SYS_exit, ret);
#endif

Should vdso_munmap and vdso_mremap be skipped on 32-bit x86 or when
[vdso] is unsealed on __i386__?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793094611.gi=
t.chris@chrisdown.name?part=3D3

