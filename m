Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D50606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 23:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=F+wBtb0Q
Received: by kanga.kvack.org (Postfix)
	id 60C9B6B05B0; Thu, 26 Nov 2026 18:32:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE1D6B05B1; Thu, 26 Nov 2026 18:32:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485AA6B05B2; Thu, 26 Nov 2026 18:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9BF16B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 18:32:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5132AC0124
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 23:32:24 +0000 (UTC)
X-FDA: 85478871408.18.575CDB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9387B40004
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 23:32:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+wBtb0Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795735942;
	b=UelIAUN+Vdpt9mYmxTDNN1K9YoLSXuAaECIeY5S8Fa7UEytXVg12H4iiDs3R5yekdTxP9H
	iBNqi8npCmgNLGqdq/IqWy79XRz/wBlI6C1dX/xLIKklM6j4JBOokeH4d1qd+gCRirSjxk
	oR4nxPhuf/l/1ZyVA861uazxCe25I7w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795735942;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FVpohG1VZmuUl18pFfPOZ4Do8lMHBffThJLIzZLJQY8=;
	b=F4Zi9mHhJmM5QqFZahM3qFLIdP8PK6+e1ERLsPx/0Ik3RqUcFV+v7wQN0GTkvhYo4sHOzE
	DfnC2rNbgcvrlXwL4SZDrYwxevFuAfxnIRzXg9FVBwN1ppWXcGYKGRR4XpBkpmF2dXv+eo
	SewpA7NvMMqWCSpOCgkHYh3tum3vnZY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F+wBtb0Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 076A0403A9;
	Thu, 26 Nov 2026 23:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3FF1F000C1;
	Thu, 26 Nov 2026 23:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795735940;
	bh=FVpohG1VZmuUl18pFfPOZ4Do8lMHBffThJLIzZLJQY8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=F+wBtb0QKwbvfQdbBFIofeI/wNEJN/mk0Z51SqixQW+2S6wlikO6XkUcjLoXwEAbN
	 OrqF02ehLZ5i1zHzdCdzB0ofx48YOL8PocnBNUUrxelnIQcrRIX2XbkS4OMMDNKA5Y
	 8zDPk4juSSd/gsRTsNgOXjfzMBEzsrPgdwax7XQ0xDSFcpF+LswaOaHm/qWy5Woo2C
	 yP9hzSFVW+C2Gtr6LfebR+2NJj2tr2G15cdRb3nOAYyu1owzUNRX5/3RVp4R/mtXKi
	 WB2lxdoKFDU4Ffnk7HnC8pDOcDqmWOtdBwYpbSn4oLEteB8svq+KBfTFvkzFyFeT0o
	 J/Ok/ET9RqXxQ==
Message-ID: <sashiko-outbox-236336@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC 14/19] riscv: Synchronize instructions written to
 ESP32-P4 PSRAM
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?VsOtdG9yIEh1Z28gU2lsdmE=?= <vitorhg20080@gmail.com>
Cc: devicetree@vger.kernel.org, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Alexandre Ghiti" <alex@ghiti.fr>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>, "Jan
 Kara" <jack@suse.cz>, "Kees Cook" <kees@kernel.org>, "David Hildenbrand" <david@kernel.org>, linux-mm@kvack.org
In-Reply-To: <20261125233020.1380594-15-vitorhg20080@gmail.com>
References: <20261125233020.1380594-1-vitorhg20080@gmail.com>
 <20261125233020.1380594-15-vitorhg20080@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 23:32:19 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9387B40004
X-Rspam-User:
X-Stat-Signature: iiwxu5fmcyyo6r6f53wuemp7azzdzuow
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795735942-6203
X-HE-Meta: U2FsdGVkX1/Nsh8pBNVm247EImQyepbBURZV7qKaTZlTtLt/i17457DrgZE87xROHlmcWU9hVdE90xmuVS4O2X1ZcLjXP15rgI/HgADYQ+dqWoM8TT7ao3CFCwH1WScrwXTQ4iqNa9En+rHpAjcP3OMSn4Gtz3xyXPLtk2sy6HGHsEVQsCmLZfAVNAeVYyRQB0WpMx3qt33Yo5AWtS7oW42s0W9BktyJb9cfDWbigCtnjb+uwLYlG7UQ/IJqo/xKB7K6gUmVhgmttCWYyjtr2PmZGRRW7Qe/4Qml2cAbvVWAljMlKfiRs7YT1QKMRkgjr+JnxKqota+ZBivj66vdEBgwifc2I5jght40FvIH4KskidA3iB/vth7tkYo/TqWo5muK7TEAmwbPZu1YUgiI5Gvo6T6B1VavD06Q/2XDG17UQJ26iJrL6vHcwd+jEVxofSlMrJEO4nNO6TPg+lTRZHynaHc4NuIgYANudKF3lrq9bvssyRTcHQcV4t5RzAtAt9RkhR+gYBxhAzrHqPqdOJKPEuYGTrjqKt9OEIX5YI7Di9WNi93pPjaPdrBQxOeKYpnqe7dgpc8YJ2bBx9LMr2MjoQxyk7oiB60eHYsiNJ99de1DpBsKAGYkdTYDamcVvLP/XaoHV4laD6BvjMFf8oypNV1M+mri6r0Jd0o2+LG4uGHfK3n/6MLWfkECth5oqtYDp6Kg/Ogee11YZIgtp1wQlLPgD31z0h+0/oTmJTTCxt5K5A+aIau7rkFQJIzlheQ2gVaXfTSuJgf++lPNoOyUdJqzyrZRe4wwlwsTcuB/ZPjs1uDc8KrqiVcOcIl1gYor2AG3pp2pwS1k0diJTU48ey78dseaKniz0BkJCUqdrkeLaqIZs7yJqYuEGNaOomNcORrJ/YKY8qKb5OtCtMVMsb5uBWV3MrtdYTed2VDOuvnEf77A7G9e+Ex4srMx//MJv9B5WkzvByRnh2N
 5YLYDeQG
 TPpxuP0c0yBwuZ8UgS3XeKAggXVikkBm2gFb+IJtId3+AAgk12WbXmxF/XQR11koAexoPh8vAv0ObyZHgLXgsQ5i82QMGyhO14WAPJ5QbVkTKakbQEU47Xe7m0vQRQS00wWzVsCAKPXnSE2+rf0dhUcKGUVI5Cftvixlk0aFA3jPJOdBn4kRuJCw9e30RE3Jue62u4VgBzeHOqGkdYr2U/clqF7QJOhxPQMWd34xpFhKEsInA09M3ELRM6HmvhvRaisvVcQEG2ORgMst8XVrU1wD14EWJ4bivm9YcytcEZ9Yh9QakkG6vRqjOYxq/Hj5RKtpg0+lcT0kc+PBqMurplwrgElu5G2f/GvBRG7fQekbnFMGsDz4PKCrdScO/cv+tKDQ6XeiQEi6vebuOeywFbW5BB1WMAoweWxXGS6sJ6dgjzPhQ6Sqpjbc8ex6xnBvFmgrK+4RXYnoj6lgjVWly0vVsilOCeJ9t4aPRuTzt+ff1SVUt2J8eq4MQGCnCrZ6X3NfSHPZD2IlLZBXxWFwe+nKgGDFFszsJQRmPCb8Srh0C2tm/QYdAfwd9PScUhcPMB1CI616TGyPGGM9NRNfTReH7k0lc/CiJT+SiGLmn+KVbplJqiu337301Wu2MpDwljjnbEp0E2kHozWX0bLL80NBrj97btp5omdLk621KIV4+0068z81RLk0O7yZpIfpC3AzmPIrLbha+2/2XSbFytzIbOZjngaXka2D431s8YxGDQN/DJD+/a26lVsBmGPWpvxg8SoQngVWpPYmy6NpkhJgCGpSJpsUGOwuQt2kbY5BTDPxUzkSyDlreYkwBTBpuom2MKQxkMDqCA2dDApMJ6bO7jQTNBrNYkXbrVzByBlZZqq6KQG+sS0Cq8r5ycHs5gmTsGS1RDqROEsrz+AP2//Zg85gY+Dt/QYmuPaHUFK+dqaBwV2CqY5GowmV+Lyyrcdb1pVTec7o4XWURgETcPKZ2zOu1
 ljrExlQn
 BrIKheSGdeitw6mH/bs/L5aZ+mguf7n2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [Medium] riscv: missing ESP32-P4 icache sync in NOMMU mmap/brk and
  flush syscall
- [Medium] riscv: missing esp32p4_sync_text() in NOMMU
  __patch_insn_set()
- [Medium] riscv: missing NOKPROBE_SYMBOL() on ESP32-P4 text sync
  helpers
--

commit 7842ba5a926e273d15f8232bcb20b17ab7d9d227
Author: V=C3=ADtor Hugo Silva <vitorhg20080@gmail.com>

riscv: Synchronize instructions written to ESP32-P4 PSRAM

This commit adds ESP32-P4 PSRAM L1D/L2 writeback and L1I invalidation
helpers and wires them into NOMMU kernel instruction patching, executable
loading, and signal frame setup.

Link: https://docs.espressif.com/projects/esp-idf/en/stable/esp32p4/api-ref=
erence/system/mm_sync.html

> diff --git a/arch/riscv/include/asm/cacheflush.h b/arch/riscv/include/asm=
/cacheflush.h
> index c2b0a2928f067..a5c20d7d1c9d8 100644
> --- a/arch/riscv/include/asm/cacheflush.h
> +++ b/arch/riscv/include/asm/cacheflush.h
> @@ -85,6 +85,12 @@ static inline void flush_icache_range(unsigned long st=
art, unsigned long end)
>  	flush_icache_all();
>  }
> =20
> +#ifdef CONFIG_RISCV_ESP32P4_CLIC
> +int esp32p4_sync_user_text(unsigned long start, unsigned long end);
> +
> +#define flush_icache_user_range_checked esp32p4_sync_user_text
> +#endif
> +
>  extern unsigned int riscv_cbom_block_size;
>  extern unsigned int riscv_cboz_block_size;
>  extern unsigned int riscv_cbop_block_size;

[Severity: Medium]
Does leaving flush_icache_user_range() as a plain fence.i miss executable
NOMMU mappings created via do_mmap()?

In mm/nommu.c, do_mmap_private() populates private mappings in PSRAM with
kernel_read() and do_mmap() then flushes them via
flush_icache_user_range():

mm/nommu.c:do_mmap() {
    ...
	if (vma->vm_flags & VM_EXEC && !region->vm_icache_flushed) {
		flush_icache_user_range(region->vm_start, region->vm_end);
		region->vm_icache_flushed =3D true;
	}
    ...
}

When an ELF FDPIC binary is loaded via elf_fdpic_map_file_by_direct_mmap()
or userspace creates a PROT_EXEC mapping, instruction fetch can still
observe stale PSRAM instructions because L1D/L2 are not written back and
L1_I0 is not invalidated.  The NOMMU brk() path in mm/nommu.c and
sys_riscv_flush_icache() also still only execute fence.i without
synchronizing the ESP32-P4 caches.

> diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
> index 2b5adf01c5502..e0687c943358e 100644
> --- a/arch/riscv/kernel/patch.c
> +++ b/arch/riscv/kernel/patch.c

[ ... ]

> @@ -173,9 +180,132 @@ static int __patch_insn_set(void *addr, u8 c, size_=
t len)
>  }
>  NOKPROBE_SYMBOL(__patch_insn_set);
> =20
> +#ifdef CONFIG_RISCV_ESP32P4_CLIC

[ ... ]

> +static int esp32p4_cache_sync(u32 map, u32 start, u32 size, u32 op,
> +			       unsigned int count)
> +{

[ ... ]

> +}
> +
> +static int esp32p4_cache_writeback(u32 start, u32 size)
> +{
> +	int ret;
> +
> +	/* Repeat writeback to avoid losing a sync with conflicting writes. */
> +	ret =3D esp32p4_cache_sync(ESP32P4_CACHE_L1_D, start, size, ESP32P4_CAC=
HE_WRITEBACK, 2);
> +	if (ret)
> +		return ret;
> +
> +	return esp32p4_cache_sync(ESP32P4_CACHE_L2, start, size, ESP32P4_CACHE_=
WRITEBACK, 2);
> +}
> +
> +static int esp32p4_sync_text(void *addr, size_t len, bool fatal)
> +{

[ ... ]

> +}

[Severity: Medium]
Should esp32p4_sync_text(), esp32p4_cache_writeback(), and
esp32p4_cache_sync() be marked with NOKPROBE_SYMBOL()?

__patch_insn_write() is marked NOKPROBE_SYMBOL() and is called when arming
or disarming kprobes and preparing single-step slots.  If a kprobe is
placed on any of these three helpers, patching kernel text for kprobes
will recursively trap into the kprobe handler while reprogramming the
cache controller.

[ ... ]

> +int esp32p4_sync_user_text(unsigned long start, unsigned long end)
> +{
> +	int ret;
> +
> +	if (end > start) {
> +		ret =3D esp32p4_sync_text((void *)start, end - start, false);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	flush_icache_range(start, end);
> +	return 0;
> +}
> +#endif
> +
>  static int __patch_insn_write(void *addr, const void *insn, size_t len)
>  {
> -	return copy_to_kernel_nofault(addr, insn, len);
> +	int ret =3D copy_to_kernel_nofault(addr, insn, len);
> +
> +#ifdef CONFIG_RISCV_ESP32P4_CLIC
> +	if (!ret)
> +		esp32p4_sync_text(addr, len, true);
> +#endif
> +	return ret;
>  }
>  NOKPROBE_SYMBOL(__patch_insn_write);
>  #endif /* CONFIG_MMU */

[Severity: Medium]
Should the !CONFIG_MMU implementation of __patch_insn_set() also call
esp32p4_sync_text(addr, len, true)?

__patch_insn_set() modifies kernel text with memset(addr, c, len), and its
caller patch_text_set_nosync() only calls flush_icache_range(), which
issues fence.i without writing back L1D/L2 or invalidating L1_I0 on
ESP32-P4.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125233020.1380=
594-1-vitorhg20080@gmail.com?part=3D14

