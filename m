Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC7A60A380B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eAIMgtL4
Received: by kanga.kvack.org (Postfix)
	id 9306B6B05C9; Tue, 10 Nov 2026 11:03:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908816B05CA; Tue, 10 Nov 2026 11:03:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6266B05CB; Tue, 10 Nov 2026 11:03:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5723B6B05C9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:03:04 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D7A911A04EA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:03:03 +0000 (UTC)
X-FDA: 85419678246.10.ED3083A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 24D711C0012
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:03:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAIMgtL4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326582;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3ReZaQQPjZmOU8RS8gqDiZ2wF6279PSfrVyb8lEiVU=;
	b=0l1VOPyP3ueDk0Xq6G9xf2+3quGYU/1/pGso3dyLcPVIfjWTRSTSWG5SKAfoXgPoQ4dEaG
	3aFDbp/6ww3qHCqzW5FrMLpFOM6VIvX+VCCiSw8yYjq6iSq5tGj/htxb9IxeP0W0W+GzlR
	cknqmYWiDx4gzo2X2UpTR+RPm7jz/yM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eAIMgtL4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326582;
	b=FHUrhwhZwJ2qxXyizieOfaUHUyUytVUx4pVrrYGXAF2qY7SypvyuV4QFiyp4PE/D+fbyzj
	JmHdVgL2+1mhg4bCTPworEGehP9DsKYkvH/r0WmaKmobjt5BD2KR5jhB+IDjlKJK7bm+Rz
	K6B9JqZg1OLSzpupwJDps3GXOC6sO5w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C16163A53;
	Tue, 10 Nov 2026 16:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6C31F0089F;
	Tue, 10 Nov 2026 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326581;
	bh=L3ReZaQQPjZmOU8RS8gqDiZ2wF6279PSfrVyb8lEiVU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eAIMgtL40ZxXpvZ4N3hHS2+eMpvpadtKGz5u1GnfQmIoWlk0nndC7Smmv18fl95tP
	 odpptSt4nPL33hrGDtblkDf3GmOKxZpucou/cB9lShoF58AL3vJ3azWO7eN8pp9HxO
	 DS/UJx+DSXBxnbnxs6AeZ94wixk3t7SQbHrDzJKrGje3tKDajHWQ3suzOK7cK+9F83
	 3qhVe+um5MkEe5SVl2PIf3eKF+MIs7NGRJqeiA8unaU4hJtqkT91l6v6zK3mctFmND
	 V9v9FevTUi/GGPv7UANNqMi3sGmPvL1dM3qPtK+9Keh30R2SMpzlleG/uBtbeS8DVW
	 KrdgUGOLexXIQ==
Message-ID: <sashiko-outbox-207335@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 21/22] arm64: mm: Map kernel image alias of
 init_pg_dir read-only
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kevin Brodsky" <kevin.brodsky@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb+git@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>, "Jann Horn" <jannh@google.com>, "Jeff
 Xu" <jeffxu@chromium.org>, "Joey Gouly" <joey.gouly@arm.com>, "Kees Cook" <kees@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Linus Walleij" <linusw@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Mark Brown" <broonie@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Maxwell Bland" <mbland@motorola.com>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoSUJNKQ==?= <rppt@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Pierre
 Langlois" <pierre.langlois@arm.com>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRv?=
 =?utf-8?b?c2k=?= <ptosi@google.com>, "Quentin Perret" <qperret@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Yeoreum
 Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org, "Ira Weiny" <iweiny@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>
In-Reply-To: <20261109-kpkeys-v10-21-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-21-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:59 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 24D711C0012
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b1extrrzo69eafgsaxw5cgt9ki3rspiy
X-HE-Tag: 1794326581-149788
X-HE-Meta: U2FsdGVkX1/EPAcvUzL/HN68dJMWoBoOCbhOUhjIZU3Wncnx7Vri1/gKnLVqHlmCl9POan5T2vt3iSgQb7qv6ezZwKMxMj5HXiTg2EcL0XFgkALEEJ9jiZyLrGW8t7lWWu7dFV18lcV3dEKp7zkhjWYnb/1NuIAtjLiRUrSPNgDR7QsxNMkCo90PvY7TX3gjWGoLrAxXrAqW+CmRqQnGYYouCj3aGLfGXTinWSK0FXX4auhlwDkY+/qWqjiwswqKa/AipzqR31yH8EaL+ToRBx7yL+dDlL+gYVm3RvnK85yk9MHAhtye63OlUOb6X6HYOPN4korvecL185bx+uuU8mRDRY2CEHCEZqZMNyWL9Ofkr2fKeVUH6Txn/AgyKAMkpRkc64gfq5/ddFCm8Lin6AiO20LrEqyDXwQ1TA69PkuynH/HDLLcAac+Vo5jB9lwKD9Egx3peq1AZhGrGOJ6GfzUl9RcRTPcB17TMb5FhXyzaTV6h3lBnKzWyV56o5/YjYWh6pwItMyvOf3mz4nxy9vUT82hLdhJbQOfcpET/uUhekE23UdWLwsZnqt699OKklzUp7GAQZwRngKMrgW15s3hJnk5fskJzBNh8as/IrqAOGbTF7xdeOyY3B2xq6+1zxB63vs1H8zrG9XRvkr8VCh/yD0KNYX7aprMVp5XYh8OyajJbs0aZemubDwAV+6oid+YzkhfA0QR+3uWMO9+Wq0c10S2i17JSTSwX7jhc1Tl7R6+SUUAzS3EHJyNkXFoexwzJaipzHzOqklKAHs3+5h/oe5kx8uU4JuDxTD534tGG9PnaKU/4MZca0SIqqnwjsNSaThDWg4PV57xpMEsVrN4N9wW+xiTIyrljfwcQfmGsHbwqs0mBMY2G+rFX+OORCxCofjb98+vZrVzMXtzUP+M99zHwHjDnsrhSXujkugdjYVdrFoR315I25SFp6XR64GO+O63OqOkRzIzG6R
 NW3voRtt
 wVxwkWRw9lOKqqVVDPoQpJOTQo56FqTEG8oKkkKRsLqHKYohm4DbWLPhU82H3mKO9z2dJoEWXixMq2x8jFckbeCUcPhUa22WVXwnqJZhBwd43QrR2tPMbuQ3r7ofxShhoR2p5YoqdzCrbHVA6Pl4kMfTHvAhd2deYi2WznQkMOasrCBDIJftlSr8Sgh+s3O6L18VROfGmZluzDR5jrcpEG+JQlT3DaFlASEa+KSJNdwYpf9Dljoib2FCM+SE5pwY5VEYGT9cyJBADrN0CTS/RR3Ld4BlNMPJSpAGwq/W+A4K/gFrL6sitTWY8E8c2z/Zaqiz69ui5nu4HVnlsWnqNymJnnX4l7MHMRGUinGlx2KrjGX5BRV41+sR5ccPKOXBVhA3G2sEv+a16nZhA30rubWU+/JabQnyfXTP0x/Enqr54s1c4edkQDg33/8NioLbt72Mk9A2pCSFLk2LgfilkfuF3irF6JIZJjoRWuM1sntwKicDSG9N+64v4dzflE1mhxVPvdRwN3HoIMT6g5CEeSNM34PBq7kTZiGnBX5rTDXyBT1WMX0If4sxwwOSGchnRwakFbUGyeBRpPHfcBIvnFk8Ir+FBeDzGlwPA8RqfWyMvmPx9Cf4FiGft6jpKgYHsWAVmwzS2o43YOzdsi/eMgq8gPNeK+uYbeP4oA00zTaotwPjTHmVpelS7I0dzwPvsdXjjg8E5bhMg/n0c3FyVyeeMBB9WiT2o15CmFufVAy+m/kO6gkvtvf2yd2g8syHLlCHMACR2IebzYemo/h17LnHNwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] arm64: mm: init_pg_dir split in map_kernel() overflows
  INIT_DIR_SIZE
--

commit 3e7fce4327f018b992b775d63738a09b4b86a015
Author: Kevin Brodsky <kevin.brodsky@arm.com>

arm64: mm: Map kernel image alias of init_pg_dir read-only

This commit splits the early mapping of [init_pg_dir, init_pg_end) from
[_data, _end) in map_kernel() and remaps the kernel image alias of
init_pg_dir read-only in mark_rodata_ro().

[ ... ]

> diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map=
_kernel.c
> index fb44cbdd2f292..81ca3e98f0f7b 100644
> --- a/arch/arm64/kernel/pi/map_kernel.c
> +++ b/arch/arm64/kernel/pi/map_kernel.c
> @@ -92,8 +92,13 @@ static void __init map_kernel(u64 kaslr_offset, u64 va=
_offset, int root_level)
>  		    __inittext_end, prot, false, root_level);
>  	map_segment(init_pg_dir, &pgdp, va_offset, __initdata_begin,
>  		    __initdata_end, data_prot, false, root_level);
> -	map_segment(init_pg_dir, &pgdp, va_offset, _data, _end, data_prot,
> -		    true, root_level);
> +	map_segment(init_pg_dir, &pgdp, va_offset, _data, init_pg_dir,
> +		    data_prot, true, root_level);
> +	/* Map init_pg_dir separately as we will remap it read-only later on */
> +	map_segment(init_pg_dir, &pgdp, va_offset, init_pg_dir, init_pg_end,
> +		    data_prot, true, root_level);
> +	map_segment(init_pg_dir, &pgdp, va_offset, init_pg_end, _end,
> +		    data_prot, true, root_level);
>  	dsb(ishst);
> =20
>  	idmap_cpu_replace_ttbr1((phys_addr_t)init_pg_dir);

[Severity: High]
Can splitting [_data, _end) at init_pg_dir and init_pg_end cause pgdp to
overflow INIT_DIR_SIZE on CONFIG_ARM64_4K_PAGES kernels?

With 4K pages, map_range() uses 2MB PMD block mappings where possible and
allocates a PTE table from pgdp whenever a segment boundary falls inside a
2MB block.  EARLY_SEGMENT_EXTRA_PAGES only reserves PTE tables for
KERNEL_SEGMENT_COUNT plus the [_text, _stext) split added in
4d8e74ad4585 ("arm64: Reserve an extra page for early kernel mapping"):

arch/arm64/include/asm/kernel-pgtable.h:
/*
 * KERNEL_SEGMENT_COUNT counts the permanent kernel VMAs. The early mapping
 * has one additional split, [_text, _stext). Reserve one more page for the
 * SWAPPER_BLOCK_SIZE-unaligned boundaries.
 */
#define EARLY_SEGMENT_EXTRA_PAGES (KERNEL_SEGMENT_COUNT + 2)

When _data lies in an earlier 2MB block and a 2MB boundary falls between
init_pg_dir and _end, splitting [init_pg_dir, init_pg_end) out of
[_data, _end) forces map_range() to allocate an extra PTE table for the
2MB block containing init_pg_dir.  That advances pgdp past __pi_init_pg_end
into the adjacent early_init_stack page, corrupting the active early boot
stack and placing the new PTE table outside the [__pi_init_pg_dir,
__pi_init_pg_end) range that mark_rodata_ro() remaps read-only.

EARLY_SEGMENT_EXTRA_PAGES should be increased to account for the extra
split.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D21

