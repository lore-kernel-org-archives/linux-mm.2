Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF52F606A33F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bX7M+EsR
Received: by kanga.kvack.org (Postfix)
	id 5A14C6B05BB; Tue, 17 Nov 2026 07:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52AE36B05BC; Tue, 17 Nov 2026 07:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2D16B05BD; Tue, 17 Nov 2026 07:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0542A6B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:50:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97F361A0417
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:50:03 +0000 (UTC)
X-FDA: 85444593486.15.0924ECD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F3DE41A000B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:50:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bX7M+EsR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919802;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+qenZh5ABWGqZjqa+cTps4vg5GIiQZQjGsfuTxWSEc=;
	b=JqGu5sV1UUfmRYlgxAXOwmoSwoOkMK/zEkbpLDydlIzV9qJyDhbHwYqSi8pAbYG0YzMDKW
	4+O71JL1+E9T0sNDlZ4cTovrGtEEjcohu8CQ5jQ0fQGW/NWvbx1cz/uHQi8TVRRjddgy4t
	apuZIN9MxXfXhX9A3uOrx1tlDCIheUY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bX7M+EsR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919802;
	b=0MzfbpCTVXX47Gl7J67jcuBPa0xJ/YEc25c88sDiDSX9VG7K4LpH/a6csGmCelOdV0u2SZ
	oVv37dkaPzPeAzZ3+2p9OAY5gIwVGe/bupP0eeSgjkl4dXxCMOPCkYyYw/JJqm8+Wmdh17
	JrxgtZB5Id4XHFD1IXwFxrhbgu++pv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 844616347D;
	Tue, 17 Nov 2026 12:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC731F000C4;
	Tue, 17 Nov 2026 12:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919801;
	bh=G+qenZh5ABWGqZjqa+cTps4vg5GIiQZQjGsfuTxWSEc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bX7M+EsR6RXGnhdGFFU6VJBC/bH+3iqEBC2aaQnENG8UrOcYS76WBVG1s4H0unuAl
	 yq/1SwpzGWn5MPrI65kwok0JKCOCwjRv1aaneCq2LNX+Ubnzlwe88Dinff79ahD0ds
	 fph7Z/iknr989RVKRNxvDyEzfP8CWZQdQnVPCByrSEVhjv6KKHZSifSqJXna4+t2WZ
	 boZV6nVvbVK5Fwdc7+htBWRgPQrucFwLVwlJpMr9xoLbPXZcysYHVeiYgAQlOfiZJP
	 vwxDjD5FuXagXje3C71nN6eQARgZwcBAEjsAvd3D6BgCxd4jwa5icV2fZfvKNcSdoX
	 sd/0CQgWtseIg==
Message-ID: <sashiko-outbox-218801@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 06/10] arch/*: increase lowmem size to avoid highmem
 use
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Andreas Larsson" <andreas@gaisler.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, =?utf-8?b?Q2hyaXN0b3BoZSBMZXJveSAo?=
 =?utf-8?b?Q1MgR1JPVVAp?= <chleroy@kernel.org>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>, "Jason Gunthorpe" <jgg@nvidia.com>, "Linus
 Walleij" <linusw@kernel.org>, =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Lucas
 Stach" <l.stach@pengutronix.de>, "Madhavan Srinivasan" <maddy@linux.ibm.com>, "Malin
 Jonsson" <malin.jonsson@est.tech>, "Matthew Wilcox" <willy@infradead.org>, "Michael
 Ellerman" <mpe@ellerman.id.au>, "Michal Simek" <monstr@monstr.eu>, "Mike
 Rapoport" <rppt@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>, "Nishanth
 Menon" <nm@ti.com>, "Richard Weinberger" <richard@nod.at>, "Russell King" <linux@armlinux.org.uk>, "Thomas
 Gleixner" <tglx@linutronix.de>, x86@kernel.org, "Borislav Petkov" <bp@alien8.de>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil
 Babka" <vbabka@suse.cz>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>
In-Reply-To: <20261116124832.662455-7-arnd@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-7-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 12:49:59 +0000
X-Rspamd-Queue-Id: F3DE41A000B
X-Stat-Signature: 568ae8gh7q8y65n1zexm8kj9kt3ey4yh
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794919801-979231
X-HE-Meta: U2FsdGVkX1/zrqjQCBHxRzh6mrbkrvHGVZ3f9nkhH+3A3BB4BvFCFmts4vOLN00jusC3Sjswd8BCFrIjrkCGK8vHD4IHjBztyP2Z5TZPPGtlMpY9pn88cChuoqJDxyd/qa+/4AxxgApP/pq/eqD4jVOWF+PHMTYdx0we4A/zrUmQNBttHnpqFj4xNRnvC9CEAkslAJwWAOPQKdOTJ1R4fn6ZUuWVvTZhHEJMClVPYBJEiLcCtNhqos6Ol1yw5dvPHwXJjE7lLvcRH4cYelgq5+PUcUKhd14VqBdukorXbraZi90bBqU5jSBgkDfnM8xu9uk2huNzwPIhwIjxHlh9Q5tbbtLDVepur2EGzLuHdtoxSFsERkts0OK0cCglshh60ZN2FSP4DWBmu6OBNw2xHEYRXmpp6d2lmThq31GiFuqe0LXhiCaQyj3ZrRdfdU7aOFFIeNa0QDrbGqFdflGTvONbuEtMcBNztg/JRm3I1eOgtlILdHUL6Z02dHmjQVhq9OYzZD65uZEiO24tYufwNvZExSbngPdXhxVMGVEuZLlk7Tzo6YmF2fhV44H1swnHjQMSOwfRly5ccMmASM7KgCkpPyPXk8wjaeI7EgFMo3HhjBqJKCfs9TCCYD67h1tiPauvbJvjJfl14WDqIaEwqYRyaNhZs60Lt+aEbxFCFOIiW9PA5+oaqK7jEzfcsdWUp7TA226IoaHHI9MyCltjo1podkTAHxMOt1fyR5gCPQzblaBz6fpfCwAum2PtGPymStK3xz2lvpcVu4v3x0DcianDVJJecCzXfw1XYHoiUqyrB7GmkUP+KfC/vJJP7M00TE+Zs6ihfQB2NaHCRMH1bWM+pICGwban4E/GZznkrKo9VcsGR5rOG0p68jPK2tyI5NzKQaEgFNalZA/DsjZBFd0wZt6LnOb4xYZMk20rX7kp/RPL2lt17HAB0DiTuhnm8QCAMLE0yUfoDE3JOB6
 lDNw8XyK
 ZkDJLKwfoT5qJAt5CL5ALVzi8/Uzf47f8cO2u5K41iLnY1yT6nWX/bb/hFBGFy3hjUH9AMWQAnRkNy7U4iXcY6q60KbccoKL7qQN34tktO1kbJYfpf6NyewBPfdtP3AFY7MXfKuQb5ZdS9OrbQwoV2726uTkGMOMBsOBWbsi7jarJ5SO0YELYtxIoyVEEvlgczllTYHYqvunvmwuMalQFjkVadUIUCRfOA/BQ2cGBqE4ZsVm3yXvnraS7DMbImtnHSEZxtOIgEF5NjkI0wmuUrZFEmjfmC9cwI4Ke7rOSTUW8ZepbCq8ixYi24ZLo89668VeXHjPs0q4dK/y6G8ESErPRs923a2iQ87/0REG3QZdsuXYwon1gZhEEli/MExwsls56TmJDXB1sF7mM5vqJOKyUG7uU/KB/nGypEiwgB45WDemaz+7i3ziDz+akuk1cgMn+50BlG+hqKvNKTaG0EG3OH0KHKGKmr+sK91HMoV8+QuBYXulLswf2njgpqEtKdTrix99gzlNyGz/q5VZIszX2IrWWLSqeCS1rgCC2++gwIqYmLBMapoOiMQ/hwl/wkNErBaqtFxB5EsLFOtbdQgaY72ueeOdYrSdbPGVmSy+hgWlzgTf7Vk7Hk8+W/2Hbvmxg2W3DFMbIUnyYsRE68zXdMVO/IPLMxR7N7K9XtlRFJct75zwB8+QPIKa309D16lg4PiIQTJi9bwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] KVM: PPC: Book3S: LOAD_HOST_SEGMENTS only restores 4 kernel SRs
  on exit
- [Medium] powerpc/85xx: LOWMEM_CAM_NUM defaults exceed 16 TLB1 entries
  on e500v1/v2
--

commit f9466fba88fe066bf9e204a300df08d4c66f1149
Author: Arnd Bergmann <arnd@arndb.de>

arch/*: increase lowmem size to avoid highmem use

This commit increases the default lowmem size across 32-bit architectures
(arm, microblaze, powerpc, and x86) to 1GiB for non-highmem builds and up to
2GiB for highmem builds, and drops CONFIG_HIGHMEM from several board
defconfigs that have at most 1GiB of RAM.

> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index c3b6cd6556069..1eef831faf3a7 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig

[ ... ]

> @@ -1207,10 +1211,10 @@ config LOWMEM_CAM_NUM_BOOL
>  config LOWMEM_CAM_NUM
>  	depends on PPC_85xx
>  	int "Number of CAMs to use to map low memory" if LOWMEM_CAM_NUM_BOOL
> -	default 3 if !STRICT_KERNEL_RWX
> -	default 9 if DATA_SHIFT >=3D 24
> -	default 12 if DATA_SHIFT >=3D 22
> -	default 15
> +	default 8 if !STRICT_KERNEL_RWX
> +	default 14 if DATA_SHIFT >=3D 24
> +	default 17 if DATA_SHIFT >=3D 22
> +	default 20

[Severity: Medium]
Can the new default values of 17 and 20 for LOWMEM_CAM_NUM exceed the 16
hardware TLB1 entries on e500v1 and e500v2 cores (CONFIG_PPC_85xx=3Dy with
CONFIG_PPC_E500MC=3Dn)?

During boot in adjust_total_lowmem() and secondary CPU bringup in
__secondary_start, switch_to_as1() uses the last hardware TLB1 slot (entry
15 on 16-entry e500v1/v2) for its temporary AS=3D1 mapping while
map_mem_in_cams_addr() populates up to CONFIG_LOWMEM_CAM_NUM slots starting
from 0 without clamping against SPRN_TLB1CFG:

arch/powerpc/mm/nohash/e500.c:map_mem_in_cams_addr() {
	...
	for (i =3D 0; boundary && i < max_cam_idx; i++) {
	...
	}
	for (ram -=3D amount_mapped; ram && i < max_cam_idx; i++) {
	...
	}
	if (init) {
		loadcam_multi(0, i, max_cam_idx);
		tlbcam_index =3D i;
	}
	...
}

Because PAGE_OFFSET is now 0xb0000000 or 0x70000000 (an odd multiple of
256MiB), calc_cam_sz() caps each CAM at 256MiB even on e500v2.  When
CONFIG_STRICT_KERNEL_RWX=3Dy and CONFIG_DATA_SHIFT is set below 24, mapping
1GiB or 2GiB of RAM reaches index 15 and overwrites the active AS=3D1 entry=
 in
TLB1[15] (and wraps the 4-bit MAS0[ESEL] field at index 16 onto TLB1[0]),
crashing during boot.  Also, increasing all defaults by 5 unconditionally
reserves CAMs for 2GiB of lowmem even when CONFIG_HIGHMEM=3Dn caps
LOWMEM_SIZE at 1GiB.

>  config DYNAMIC_MEMSTART
>  	bool "Enable page aligned dynamic load address for kernel"
> @@ -1242,7 +1246,8 @@ config PAGE_OFFSET_BOOL
> =20
>  config PAGE_OFFSET
>  	hex "Virtual address of memory base" if PAGE_OFFSET_BOOL
> -	default "0xc0000000"
> +	default "0x70000000" if HIGHMEM && !44x
> +	default "0xb0000000"

[Severity: High]
With PAGE_OFFSET lowered to 0xb0000000 or 0x70000000 on 32-bit Book3S, does
LOAD_HOST_SEGMENTS on KVM guest exit leave the upper host kernel segment
registers holding guest values?

Commit "powerpc: kvm: allow flexible PAGE_OFFSET" updated the starting
segment and address in LOAD_HOST_SEGMENTS, but kept the loop count hardcoded
to 4:

arch/powerpc/kvm/book3s_32_sr.S:LOAD_HOST_SEGMENTS {
	...
        li      r0, 4
        mtctr   r0
	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * (PAGE_OFFSET >> 28)))
        lis     r4, (PAGE_OFFSET >> 16)
3:      mtsrin  r3, r4
        addi    r3, r3, 0x111     /* increment VSID */
        addis   r4, r4, 0x1000    /* address of next segment */
        bdnz    3b
	...
}

LOAD_GUEST_SEGMENTS overwrites all 16 segment registers on guest entry.
When PAGE_OFFSET is 0xb0000000, the 4-iteration loop only restores SRs
11..14, leaving SR15 (0xf0000000..0xffffffff, used for vmalloc, ioremap and
fixmap) with the guest's SR15 value; when PAGE_OFFSET is 0x70000000, SRs
11..15 (0xb0000000..0xffffffff) remain unrestored.  In addition, when
CONFIG_EXECMEM=3Dy places MODULES_BASE in the 256MiB segment below
PAGE_OFFSET, NUM_USER_SEGMENTS is (PAGE_OFFSET >> 28) - 1, so starting the
restore loop at PAGE_OFFSET >> 28 instead of NUM_USER_SEGMENTS (for
16 - NUM_USER_SEGMENTS iterations, as load_segment_registers does at boot)
also leaves the module segment register unrestored.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116124832.6624=
55-1-arnd@kernel.org?part=3D6

