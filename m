Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73B78606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mnezqKHO
Received: by kanga.kvack.org (Postfix)
	id 9392D6B05B1; Tue, 10 Nov 2026 17:23:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9E96B05B2; Tue, 10 Nov 2026 17:23:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DBCD6B05B4; Tue, 10 Nov 2026 17:23:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4960F6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:23:40 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CBEC180167
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:23:39 +0000 (UTC)
X-FDA: 85420637358.03.B1DC7D7
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id DBEB6100008
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:23:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mnezqKHO;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794349418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MzZ1z0KVM3oeEIZUdt7Z+pU3mVSpY3HkCpsElCBUhqA=;
	b=kvTBUC7hfhOaAi1dYADYBPimumDcQVG90ZA5kN/t3aE7+COInunrhbwIUj5TWoV3HthZwG
	OoFaCTT6kWEIkfnRqOHLgtf0eW0FG5F4KxgUpw2rS9aGEIaV0qiFyAVTN2eMG86e8cR4Ub
	xk7/67Zc9tukDd4gQUBXIr5GItPOpM0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794349418;
	b=c9dFebt4PmiN+cvR7EwXx59fPgqJhGkHXKVfJQU/at7RwaN16CzXv1HMG91HRvn2UPVMuL
	KgjNSgB6Qot29aXGK9q5kEKViYuA/W4vqFmB0f/vGPCKS3fS0QGPsJAOZa4OH/TqxmVPlr
	J/MU9jAIeoyFDmSM3p0Rv6jXahUDVig=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mnezqKHO;
	spf=pass (imf05.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c505186727fso169299766b.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:23:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794349416; cv=none;
        d=google.com; s=arc-20260327;
        b=LYgCPm8LDE6ekzsmQMccwR8TWtgeJbVFChyolNqgt4K+RAzMhFkKtU/ARjc+Ra7ij+
         40Kk0z2w5KYhvXvJdeDmQ1v64UtBw04UfsKU6CZFc+72NMHruCXvI/WQcqWPpEy7VVMc
         8Zzf88xAT4IP3eGZrhnuo65xzaJqXDTHf0RvcZMEPDukL5iDx1VLJNCDKpeRX7AAB5PO
         n+lGTNEP7eookH+DVc9PEbL0GZyHahosFKvY2F9GyciaZuYGBGbHdqZ3bITM9LKQa0Ku
         AW86UdDMauyU0mutF77zRjcacKs6tQabrcjnH8Ni4cPGk9UNXCFc/f6peniRjhqglLSG
         gNPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MzZ1z0KVM3oeEIZUdt7Z+pU3mVSpY3HkCpsElCBUhqA=;
        fh=GJHbsEJ64G7UZTE3BZ6xuEfnCdAY6bo6QeJVSuaziUQ=;
        b=c3jLRLHLPYjeJkkvv5emZkccxqHPFQ8GfgP2MtwSAZJAuYo9O7nQJXHCKeF5Xf3iar
         crD9DBnBrcar1dy4RtnaBvoaKZvmCEY1JjwsIK1YPBXPDzXcC0Znykoq84IGFR1BqRwT
         PUuJT+35m3J9sPLxqowTZL48W7tzVClt1PESaQ+Qx+n6rkLsj5CVKNXzFUZ9Cf38dwFe
         TXH5XAEhf5iefZpORYQ8SMrYHxnM2XDUcy3797qBGnKa83Cb14hCvRkdlEwx6D11Pk8S
         dlsqLWFGZ8hy5Fhu+p3y19P4X4M0SEMYKev2+MaQY+v8n8n2Xpxu/FxD/BF+v9N+nDeG
         cXMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794349416; x=1794954216; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MzZ1z0KVM3oeEIZUdt7Z+pU3mVSpY3HkCpsElCBUhqA=;
        b=mnezqKHOgqRxeSDbd/1sbbbTqtgPbWExKvBFTA0vW4sB5HQDU/UGdWmIIklYLL01qK
         tZbg4FY+CyjuOjRB8/L+sS0BEmFQBABeXuup1eLE7LpFEfePWo1fxHo9Rx47siPWQt2w
         90pgC5mV+ydCAdULN0N/sZTMO1G/lJIy9SrIeELiIS1rD2VLJXfD1wX3P6dswdp3S4kL
         H1tGjH+j6f7n31tkk9ZbIShMUoWQL9maZBMg74FEf3G6Oq2/pakMIb2qLOYuarVwKmK1
         aAYh1wn5FoM0vSx9Vpk90l8BgRh7OLdzfvL6tRs9DoX/VN7g9MyyevKXZnYRc/EXMY4k
         hX3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794349416; x=1794954216;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MzZ1z0KVM3oeEIZUdt7Z+pU3mVSpY3HkCpsElCBUhqA=;
        b=AN2k6ejmGosuJMlH35WmDzGuSwqRCmBIcrXA1oVH8yAXW7FnKaHSSmohuA8cv1sAen
         jKmjPb8Fn/PX/8tAAKOHZlq3it1KsAVgQfjCGGd38mD3TfqC19cjnevfyJ9+wj6Koydw
         Ljzico+kzjJHpa86nSkr15SbGCa/qW9NJbwq2z2HaXXbFBWSxV8q4clYpTd0K0UzaGFO
         YZX8/hXpbXx6H1Tl/E993lSFXCEIWfLR03tgojQ0a/g1OLJcnpqKiNDjdHVoZ0IpaE7Y
         5R2DBU+K8CvrZSUPqOOMGHzwRwF5Ivvcw44DMlW3tF7GiwBsUzLbZB4wUze+IRGg7uPw
         PeiQ==
X-Forwarded-Encrypted: i=1; AL+hErE1yqQltj+GMpaMpQppOjuUVEkf0cl85+YYGdYThu91Jt2S5qDCd+hEVcW8y/9rBeY3dM39bTrlJQ==@kvack.org
X-Gm-Message-State: APuU4Z+uIrSwb7vl2DdDKQwZjtx8CNtLd6KWiQo51XJglTjj4/BzwB8R
	/c9H65GkUa8tR6ZUgJxo6S1M42nrWYGRIvuJfxbqLsyZiviKVCdRIY7q9DSKAH3HnWupTb5neny
	PEy3YUUA5h5fIyDDFDCTzrTYeYm+9oxcP9kteFmyC
X-Gm-Gg: AYBFou32EexveIk6zj/q1qa3/Boz3wOkiIhZixNEgh7sHRvzM6PiCKvzsYC5V0LNWu9
	w8ThUok3wfTchA8saghYATE4r3LZQK9vEXZoLW3DwVkFS4mMEAyR+58UO/BfsHox/enTiydaHpj
	VeMVPtEH12in8FOKJSGSwcGqylYWMbgV0/MGiqXRxWDwLR0oHgmyLWZ9Py7rSIVfwl9H+iO5n2F
	04jzUleuaahzudIUqsnkRYtEqDYzGH3eKLPOyGxGNGd0a6iuZ1JXcWqpqoLldsrMYTVCFNy1gP2
	3geqWMai2QZy8qv+7UYWAiaT2wcsUHVZ2Dh7xj26fFcKOpGQt7ZI43FDaxzNisySsVwEV2aOTU6
	2vHkWPx/USmTMIgs+RjuZ/eWTaiMHzlxfRD7fP0CeZcJM7jNx9sAM+JbXTb+IT9GtmK3Dd93vqS
	I3wNcpqIR6Hx6Rj6Dc0FJIDGRkrtXgj6nuvPvJ8IDRjPlWJ7Ms4Hqa+fnHX4A0uuvy+1d2CMWte
	T6tuKBCbA==
X-Received: by 2002:a17:907:a08a:b0:c2a:b1cc:158d with SMTP id
 a640c23a62f3a-c5066cab80amr34767966b.32.1794349415908; Tue, 10 Nov 2026
 14:23:35 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-14-jthoughton@google.com> <CAF9824D-CDC5-48E6-A1F6-840CB299EADB@linux.dev>
 <3a66ba8f-96dd-4215-8c4d-0cc3c286375a@huawei.com>
In-Reply-To: <3a66ba8f-96dd-4215-8c4d-0cc3c286375a@huawei.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 10 Nov 2026 14:22:58 -0800
X-Gm-Features: AclHuK-LfjoZOtKEGwbFXm4SDbHWSiIOi9H9ah6KA9x7oxgjCWZK8mc2-sY7pxs
Message-ID: <CADrL8HVVLG=MPypRoqC-iGope6tFqpg1Af5hZT=zRk2FFqxYaw@mail.gmail.com>
Subject: Re: [PATCH v2 13/20] arm64: Support hugetlb vmemmap optimization
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: mut8rum14zinass6qr6qe7he438joyk8
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: DBEB6100008
X-Rspam-User: 
X-HE-Tag: 1794349417-385351
X-HE-Meta: U2FsdGVkX19MCjP34QfnhJaHSYvnLR1jM586VQtZ1pRVOIsiRowe4SS8lfK8iKbBvVOUD0KtSjZiOKg0VH8rkCYKMdH3aMxCdjgIOImoe2kfDCejRxEc7LafxUdFiu4ppMTYeSuqaiGRrvNLAh0ylyvtxQZxl1egaVxP887CebDsg34waFWGlXQKFsXHe8IWh+qERvIY0roTsO31W8TJBqQgIQYEqxNeqZO2oxBnnptFmHG42zM2yUEiE4/BAK6CuqdqXQMMpao0hxYOLT5cqqTkeD1abjIF2NnOdZIOzT/Ob/KXmWsYFGO9MHjnAbaAvhEM7sJNkyRPhblKqOb6yttUGkHkF0iASDRF0XpyyPakys9K7CeY/9hF35YHUg02NYT6Hp5BkR2u8kq+XRI1KG/Nqj9co5BpUtQAGvW3WyF3iQbmU5gSo5mnQv/OAu7oixpmc0xCK0zxdMZ7NaJfUB4RoFKg2m9a94ci/7YjaWa3U51qkek/+iNoFFCOoEl0z/kX53FPj6LmtJmcyPlIiJO3U5lNJyI6BEKY3Wv7YVU2PruUCtV7fRUPo/XNF1aEP/vK8SoRdwyJGmd+fK7xvTtzGkCQGkGHVZSTNbUJltQD/2ctNMd9kiuUa7qW1sGTgkOaXg14Cpb6grFI7r0QcO6sO1UCn03TztTn16sqy9Odqk3u4EXvIcx3+1/o190s47vrZycraqH6uj7hvfuC+vgh6BM+2hTj1oUZrMtEG7oEvUFFIZS8TBhz6TZJa1xIN7IANXcnBx9r3Nq9aBdQgV7T0uBhyWbHCyVoZDmFzKuHWKAZRZJ31yyPBE1HvvCwKnIBQ8HyxQrhvtt56H41SKduvN+067yx8WTdoDtGfJ7H1bTj3mxlfc9jWMSB7aODiQf2RoTGgPQT1UxhR53pnJPc3WpaNwxyhXp2iaUVnAgS09DLGjRSl1AvsmmKzi6QeTXhsnvTPTdy29epJzR
 ffqocV7H
 onARRD1g2CVwm0ZweUbIQ6y+oqByk77oEhxu4VATg8s6u4BQ1jQDqLHQilo0Wv69r4lg8kixtUQg8zn0GSITZC2QBfWvz4TiCTF/1h7NrTAseEznbDyKXdnGzfwVkYIZeNyPukI40n4ukyW261JSYIT3h/pV1zfjDglvzYkPS5QVkWqM+ugcmehQ/dvaw0jAWZh/pKIjPiwgOobyrmkRNGWPH1V3WAXsNVJniM+v5NtfJsi5bqead3KuThI78keHXoVTobT13v0Owl9RUtlfG9lOMs4LUS1znxaVm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 1:16=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
>
>
> On 11/7/2026 2:45 PM, Muchun Song wrote:
> >
> >
> >> On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrote=
:
> >>
> >> Support HVO if HW AF and BBML3 are supported. These are the required
> >> features for the vmemmap to be modified in place.
> >>
> >> On arm64 systems that do not have the required hardware features to
> >> support HVO, the HVO sysctl will not appear, and any attempts to enabl=
e
> >> HVO (either via the command line or via
> >> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=3Dy) will have no effe=
ct.
> >>
> >> Signed-off-by: James Houghton <jthoughton@google.com>
> >> ---
> >> arch/arm64/Kconfig               | 2 ++
> >> arch/arm64/include/asm/hugetlb.h | 7 +++++++
> >> mm/hugetlb_vmemmap.c             | 4 ++++
> >> 3 files changed, 13 insertions(+)
> >>
> >> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> >> index b51d23a62c92..e4c87487bc7f 100644
> >> --- a/arch/arm64/Kconfig
> >> +++ b/arch/arm64/Kconfig
> >> @@ -92,7 +92,9 @@ config ARM64
> >>      select ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT
> >>      select ARCH_WANT_FRAME_POINTERS
> >>      select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES || (ARM64_16K_P=
AGES && !ARM64_VA_BITS_36)
> >> +    select ARCH_WANT_HUGETLB_VMEMMAP_RO_AFTER_INIT
> >>      select ARCH_WANT_LD_ORPHAN_WARN
> >> +    select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP if ARM64_HW_AFDBM
> >
> > Because vmemmap optimization depends on compound_info_has_mask(), befor=
e
> > enabling HVO on arm64, its vmemmap start address needs to be aligned to
> > MAX_FOLIO_VMEMMAP_ALIGN. Therefore, a prerequisite patch is required.
> >
>
> Agreed, we tried to enable ARCH_WANT_OPTIMIZE_DAX_VMEMMAP[1] on ARM64.
> If the alignment is not performed, a warning will be triggered with
> DEBUG_VM, see sparse_init(). The same issue applies to
> ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP.
>
>
> [1] enable ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1075bc661833..649244e55c4b 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -94,6 +94,7 @@ config ARM64
>          select ARCH_WANT_FRAME_POINTERS
>          select ARCH_WANT_HUGE_PMD_SHARE if ARM64_4K_PAGES ||
> (ARM64_16K_PAGES && !ARM64_VA_BITS_36)
>          select ARCH_WANT_LD_ORPHAN_WARN
> +       select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
>          select ARCH_WANTS_EXECMEM_LATE
>          select ARCH_WANTS_NO_INSTR
>          select ARCH_WANTS_THP_SWAP if ARM64_4K_PAGES
> diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
> index 4e7682dfe366..6808529873a9 100644
> --- a/arch/arm64/mm/init.c
> +++ b/arch/arm64/mm/init.c
> @@ -91,11 +91,9 @@ phys_addr_t __ro_after_init arm64_dma_phys_limit;
>    * has a direct correspondence, and needs to appear sufficiently aligne=
d
>    * in the virtual address space.
>    */
> -#if ARM64_MEMSTART_SHIFT < SECTION_SIZE_BITS
> -#define ARM64_MEMSTART_ALIGN   (1UL << SECTION_SIZE_BITS)
> -#else
> -#define ARM64_MEMSTART_ALIGN   (1UL << ARM64_MEMSTART_SHIFT)
> -#endif
> +#define ARM64_MEMSTART_ALIGN                                          \
> +       max_t(u64, 1UL << max(SECTION_SIZE_BITS, ARM64_MEMSTART_SHIFT), \
> +               PFN_PHYS(MAX_FOLIO_VMEMMAP_ALIGN / sizeof(struct page)))

Thanks, Muchun and Kefeng. I never hit this warning, I think because I
was only using 4K base pages. I'll make sure to test with 16K and 64K
base pages before sending v3. I'll make the same fix, though I think I
will write it differently.

