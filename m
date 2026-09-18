Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 197B1C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308EF6B009B; Fri, 18 Sep 2026 06:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9A26B009E; Fri, 18 Sep 2026 06:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A83A6B009F; Fri, 18 Sep 2026 06:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E80CB6B009B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:25:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 713191A05F7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:25:33 +0000 (UTC)
X-FDA: 85226501346.17.B242ECB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D165CC0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:25:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=bgn07gul;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789727131;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCX7OD0MFSj63jeBdnj32V2m69meKqvW8/7zSh3AOsY=;
	b=H4Cg1H48CTRSm/xuZZv9Cq005YJtdgAmlqXtAgUlx+nHd9r2LaNRktcPsXiOA3kkqgfEJo
	Jt+/ZcPKXljchu2nDgJRg+fUc/epcikjjmSYjb5qhMAQzyMyF6d+pn5fXZ7yeTLMZ/ao+h
	W17REK8j6w4tExFCz1LBRssQZn1WGyM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789727131;
	b=UUDeCCMh+dbbtMRG3PXFAaWKVdocgGYkNi68hIqz8Cwcw8osLLtQvlGUOObxAi4oKpqiF2
	j38nSK5UxIpNlT+SEsVCCzghJzIFROT6VMa8oVMcynQqqoHe9b0QbUY239AcCf2/jHaU2l
	oZZHjKrPsTz91wX10Bj90xcrrtYyX7k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=bgn07gul;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B11B41418;
	Fri, 18 Sep 2026 10:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170481F000FF;
	Fri, 18 Sep 2026 10:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789727130;
	bh=XCX7OD0MFSj63jeBdnj32V2m69meKqvW8/7zSh3AOsY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bgn07gul2XbQMTEsRc4NB0SooXCoVClfKj7xYlHbS0pB2k+p9hs37drFAnbcjmF6s
	 4uQTP4i4RTHhMXyDNCKCVqtp09Vt4jf/2sZpt6hXCITDDYmNLKHl/7GEuioB10pBbq
	 KgC8pFhunF4pZVF52aAyqYLmVje7onyZnDtkoMo7M+n8lrWgnW2qD56PzJwaioLm4S
	 fHUW0/h/VQS1YQuMks/Kfw+mvY5dmMgMBMzsknhX/LGDPMoVKKagSg7iLX1wTh+7zx
	 SfTRxREogXbxKWtWO3h7HjVP9J++VI67o4Pb8NZxEUTXLM29u8MBaqpCcwe6O9eeSz
	 2AjhZSXEB/PNg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 14/17] elf: Introduce elf64_phdr_size() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjie Ruan" <ruanjinjie@huawei.com>, lizhengyu3@huawei.com, dave.hansen@linux.intel.com, mark.rutland@arm.com, bgwin@google.com, npiggin@gmail.com, mingo@redhat.com, mclapinski@google.com, thuth@redhat.com, ruirui.yang@linux.dev, sourabhjain@linux.ibm.com, linuxppc-dev@lists.ozlabs.org, catalin.marinas@arm.com, dakr@kernel.org, linux-kernel@vger.kernel.org, vishal.l.verma@intel.com, pasha.tatashin@soleen.com, robh@kernel.org, sshegde@linux.ibm.com, chao.gao@intel.com, rppt@kernel.org, seanjc@google.com, chleroy@kernel.org, liukexin@kylinos.cn, linux-mm@kvack.org, takahiro.akashi@linaro.org, piliu@redhat.com, akpm@linux-foundation.org, pratyush@kernel.org, ruanjinjie@huawei.com, kees@kernel.org, hpa@zytor.com, rafael@kernel.org, ritesh.list@gmail.com, blum@kernel.org, linux-arm-kernel@lists.infradead.org, coxu@redhat.com, maddy@linux.ibm.com, eric.devolder@oracle.com, palmer@rivosinc.com, tglx@kernel.org, adityag@linux.ibm.com, kas@kernel.org, chenhuacai@kernel.org, yeor
 eum.yun@
 arm.com, maqianga@uniontech.com, gshan@redhat.com, guodongtai@kylinos.cn, gregkh@linuxfoundation.org, x86@kernel.org, zhangtianyang@loongson.cn, jbouron@amazon.com, bp@alien8.de, tangyouling@kylinos.cn, loongarch@lists.linux.dev, james.morse@arm.com, ardb@kernel.org, mpe@ellerman.id.au, leitao@debian.org, will@kernel.org, baoquan.he@linux.dev, hbathini@linux.ibm.com, me@linux.beauty, graf@amazon.com, linux-fsdevel@vger.kernel.org, kernel@xen0n.name, driver-core@lists.linux.dev
Cc: kexec@lists.infradead.org
In-Reply-To: <20260918100442.3841135-15-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
 <20260918100442.3841135-15-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 18 Sep 2026 10:25:26 +0000
Message-Id: <20260918102527.170481F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: uy3sg9wospzo3at5c4ykcjzttpr9qmu5
X-Rspamd-Queue-Id: D165CC0005
X-HE-Tag: 1789727131-506357
X-HE-Meta: U2FsdGVkX19p/RujPp9FtfMw889fAwu/KStZMlteerDZpKDhe2J4huLeCBgaXyUU1Lte/uq29xB59bH8PsIAIrCp7PTSTFSXdo37koiZguprR9ETB5dHiaSZcdfPsWrTUwjX9vyP+2x4QHVUnpKUVCxZAcsCcirpLjLp5gdNmgHFJdP2xs/gj27s6SXaI3w6vYRLzCw2KJ9RpnTY0eovTrPbaTVI4CnJahxCgKcifBAjhMmdIN1lsHAWCbsvmjGf+bk6bteJxB1hW4qbYbstbkCGxeIyhwtNdpj2Gh8L05oQxMQOSHv/rnBcbvrKYC5TkpRFszWNKwLmx5ASWbHQh92UhbYjTW+4M1lO+UyWmSLHLRbRtLLs9/yR4FOKHErJqs+Bzkjn6VtuCsMHAQQ65xa7HkIdgrcE56C0YAoRIten5mrIrGBt+KcfSrDShG1Sn3ieJPVVlTRvrVry/vk3DVRnv+Ofm1KAF9fnR6GIWo39LL5oxYKPQg1kSQqVvpmh1iaAt9ahikuvR7Qu+5VbXmr/XlJSocvI3NKJhJl/j6f87RykWiQWZ/CIMzYRLVfqoCswyn4UtNqguMhirhSyoaym9tlMk2PpND6C84hXDB1AQ5US1l1k11QabRnAuOMBek90NJv4TpnMY5bVP4vbhdnxYNX1lYaZzjfzdgrbBlAb3mYBy2wzpFMJ7tS40bp1cXGksepn9IIWYimyg6HV09SUJFp9QU7uD4+Kk/9oB/rk+1L13qIKuBG9wWrtKg8Kkdi2PiLHEoOT7JXXZZmtwiUqAhm/S0p6mW+yRXe550XuvpgciHgOc82db/vvCBC5q+td//HMqdwrJ//QhVN3v4ZdzXmsld8+w2SI2Ur3GIghJNiuTy2jpR9f8fzgoeHbPd0Ovc2+0lbjQeRoY5BwIj2F6v11RmYhArFOar9/ATyQFke0SCHPi8PTY4ZN+Irl8W8jwn9oLUol4XmLOjB
 O/3abBcl
 I1WqzQabDK8RGoHSP5okQbX6+eLeRrTrjYHNhXWMVbXKwq9kTFHgWVlvpE7GIG7bDFuV6uPjNkfcHwrp0aMEvrmmdeKtFYyjzdY1mIJwY5QMbnaotNMYjNlYK/86VTrWnYzFUfPJ8IEYmrc5dcaIb9ZPrumoaJ5C2Zovlq3W4NcZ08KPVjYJwyR/Vr24xOz4tADS1yTQ6I5jcYZsFSD4Wh7giT+9Bv49yaDNS9JYfrtcHgjKmrx++BovSAsJhZkjiF5tKWR6tdHMsCOAc/KTjvbglOFfGf+ry17HiCbaJJ6ZVzgzYUWer92FTWADkZqTVaozhjOCrw0nRBNWQ8fODI8l1ERTY/DLUrus2RaGcQ1bzKCx/6oiX7TgR9y/O6UcSD5hdPaWfwJqZb4CvOJiDqtbwYHIIPsNvl3vg/Z5fB/rrtZyId1I2TiY6p4dgcBIllEqup5CZFWA2VcpKWasWrIJmPliy3q47Yrfzyx0dVO435jO9hz0K87he9joFldojwNRMoHHvm2hnAk3Np/btyAdwQcOSssPPXjJBf8PxOtqkFdE7MuFXBUz3XAbSssY9D4CHY3rmZEXBeJ/5IHwY81OgyPSdBfwlOxTq66JKjXKD1w7OmEJTR34zTOE6bdZDCHDfBCNkRz9zcBuyjq+WBYuB+EBdA+jysMAm4LHm5jh+bVnsCpG56GN7kDP6OEwera1mTHYcCGXEGYMZHjcEoLXRmNdrWUzvhlgBnv7gLNpz4X4hIVRbn26fPsU5kQEzinXxZJ8Qrgr8LPft+rNvU3Ji6bBqJ5wyHBOWouxlFeKF8xQE2ivVCo6YH2mlFU6EWjy08gE4EbkQka2BaadbHFeuT1wcPahOFCZD+9DlXQ1UUoE/CDP6h85i0YYq0b2X6W+otmouFqPtLEgWsGc4QZDlPF8QNmjySFPKrW4Sfh1A3+c55OmX1KxEFyyr/4WUBzhAgpeLoLWUZhOc7/Tjgjhktmry
 mi1Vj8yj
 O6ZBRwiVe55k/HzA2poYi3B7G+JmiteweLFolsYP6Wwvp+Gwwj9m0FIvY8WFijD63IrZMnibpUrwDdSvNpLpVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Add a common helper to compute the total size of an ELF64 header
> (Ehdr + program headers) from the number of program headers.
> Replace open-coded calculations in powerpc, x86, vmcore,
> and crash_core.
>=20
> On ppc64, struct elfhdr maps to elf64_hdr, so the powerpc change
> is a pure cleanup.
>=20
> No functional change intended.
>=20
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
> Cc: Thomas Gleixner <tglx@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <baoquan.he@linux.dev>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Cc: Kees Cook <kees@kernel.org>
> Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260918100442.3841=
135-1-ruanjinjie@huawei.com?part=3D14


