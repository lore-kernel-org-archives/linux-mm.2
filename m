Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB80606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 02:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ELqR0vgX
Received: by kanga.kvack.org (Postfix)
	id 1EB046B05B9; Tue, 17 Nov 2026 21:03:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2A76B05BA; Tue, 17 Nov 2026 21:03:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8E56B05BB; Tue, 17 Nov 2026 21:03:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8CCA6B05B9
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:03:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A2C61A0628
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:03:21 +0000 (UTC)
X-FDA: 85446592602.19.6D773CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7AC56C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:03:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELqR0vgX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794967399;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=au8AmWXW7mlY7YeoCYI4sDxSlDz+2rihy6g/zuZYjP0=;
	b=cILecZ2KYGIzJSUgE2DDkssEjLVTNC7FDlnFBUn6CC5HiY+GWsumExjTUsZmBHjJWqIjAf
	OK2SCzUIj7t6MsJzO3JjzAL35+j90+jnM1SFA7O7Y/WZm8XZt46PrIN65DtGDtM7PUGJzj
	bhHuLs94OSJ48OgyVmHmOlfMphhErNo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ELqR0vgX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794967399;
	b=EwWpDGdpQ+hBMMyQxlTwzN78fnUt6XmOMkOFycdaWLlO4co5k3FGT4vrwhW+Nazh9nsubd
	OaqGi1HQpi8XjRHl7iKqwlM+064EtNB4+oIkTcL8I6JsihMvfaXVuxHL5WM94BxQNygBlc
	wRylGo+uUQrfVgvHSM9kNOhmMUBIkeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D8658414DE;
	Wed, 18 Nov 2026 02:03:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282271F000C4;
	Wed, 18 Nov 2026 02:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794967398;
	bh=au8AmWXW7mlY7YeoCYI4sDxSlDz+2rihy6g/zuZYjP0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ELqR0vgX3StbAmI/Oe6yDSc/JJ/mUZXoNG6vfbH/Qx5KY0Q1slSVI742ert1zN1H6
	 26VhF3+0T+Q06nMDwq4awd6A5GfI8GVhoHc2naXm7/7S/vgCnCaF4joB8jIicXO9PA
	 TGLPghO5SMSlP5gMUxOfq8P026NLuSRHuu8848JutRPSOLf5TP0n6uFQbANMLuD/Bv
	 Hk23jFlw3uJedkJDFEPj6QSoiApY9ftIljYR/6fDupea7A3ynzjp8LrghMcHnQr+Bd
	 92PHLg8Ixg6oRpGhad5gVfZH1LlHf8iJZB6TPS+tXB7vTUJfxlkWsWpe5z/hX9wZh4
	 bPdNLmDeOtb9w==
Message-ID: <sashiko-outbox-219925@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/4] mm: add spurious fault fixing support for huge
 pud
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jinjiang Tu" <tujinjiang@huawei.com>, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, ryan.roberts@arm.com, peterx@redhat.com, dave.jiang@intel.com, linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
In-Reply-To: <20261117020237.4037980-4-tujinjiang@huawei.com>
References: <20261117020237.4037980-1-tujinjiang@huawei.com>
 <20261117020237.4037980-4-tujinjiang@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 02:03:17 +0000
X-Rspamd-Queue-Id: 7AC56C0009
X-Rspam-User: 
X-Stat-Signature: yodj9otfk99xo1xgn3pmtgsbju1txscg
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794967399-886245
X-HE-Meta: U2FsdGVkX1+pNKhnFOPFeuvf5tSzcIqBI0WwLPVv6WI9FQeDjWygs6s90g2SkWjNmKC0Th+Kcazkv/rhDQ05hg7dk8VZCXudW8QRa3iu5/LmZrv2ssqYlKAOK1ErpcsAAvDHKeLzDxIIuT/a+2zf6gI3n8R675NYuc4fIzrLZTDcSQhxWDyHZ91NELkYKtERQOrYCGS/idbHZMX2bisDj8JquwukWTNiymd3uyoKZbofYaUSNl1lPWPHgocpiVLxbZT7Vhdjq5egyTqreQDa2V2HI/4aonTr7vEqXuOhH/4RZs5uV4mdzi5X5VwFnsH4tg3imdDgmJJSpucI7Wpq5lxmRK13EBnnSRqLA9+EN+QS+Y1/Tb4fmebGNyW0Bp1JrEhccxrToq4MtR5L1snOIfTsC0AbkhaQsrVyPIAsQozMi50JiSCoTFnEQ+zmEkZ/GcSvBPNALDbKL5KoKiJ4uCm3DwKHiTzbzvwmkqMNKTvYfI7ZP39KEI5HooZDayhn5ideJDkOjVn37Baus8oNwqxgThfgKDddhWsaMUa5dEhmbadORPQz9SvErpemWZO2evfL2zCFUM4j+heglQqDSVFW49vUA1r1ZN6y2nLYJv23LDFMjz9pGf0T7x3uAzQsC6ChtYF4yRaGUBifbxGEtQVK+3EC4MsMXPyr5nEad7LQqRuUVgGkzjqCssuO/c3M1GBdwruTAPXoGRQw0zZvtYHFtF/FUl6aRrNxlVpVhz6AxdsJODkoiCT5YVMdkqIrhmFujTaA8oxhF+J+LGUY/NzOYkQVZPEttx+n4knGzses+u9DQCJh6ZapP//ik8CWTPOpdiud/a5xm4KBhDfg7fzFj/FhS281QEtMpbr2Au+wTgrXa61YHKFFaOfbxBNZ5R5vSAyWRLrxl1mb70VUfE0Csq8uIHeFwh58UUC7+MtQknkqkxhN2nMXYx5MF67F6grDYDZh5vCbBVWjEL7
 ycjljpU+
 CGRIsIvmbSi2JCEnA7ZbdpDjHeYXxFVZYDMHhMbhYNdo5EwWFs5w5wvap72sQoo8z64hD8jo9REiT6n94aalUt9icFGhlsE2gMzfVYSEzjF96VP9dg65bRiT8OwTguqZCntX1nczJtIYwX31GeGpBhtr0zmrOplBBBNohS2bP2GTnC7da8xHYQEDDYBopAdA0qU3MHEMzPFGf5h0E4YYZYAD7MeURFC0sGUEFsrVU3a41TilrsSSYN8PsqeIqXU0eMiyq39GB/xbRGw8DAu+/OGGLFbXRUI6sdO6CZ1iRSAse6kY+6SNska91XCvgpPW4EfCQI221QUrlNqe6isZwvlwbqSiJwSX9FptfuhG9MliTFqSGPDxxQvdZTjReUA7bVkSE/ris0JFA/Aw2IqnNWAC09hq9G9bedKiZQ4z91dELN3vWu7eNWCRbGmfs7pIo/ePyjIPEgIG+V4WNzZx4v1VKfioBieFmruUgNw8qjav7Rvu44W9XsQ0ouI9xgsa1LYTp9P6IUFmTGI0qwS5nDaEltSgGj+7HT0JYO7uESete27cgLwtZQATYwgEixFihtFvTgWVkVNBOZbYhDisiXSMFgQ==
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
- [Low] arm64: mm: unaligned address in
  flush_tlb_fix_spurious_fault_pud() flushes 2 PUDs
--

commit 89132c364112921acce9427dab367c258f86db04
Author: Jinjiang Tu <tujinjiang@huawei.com>

mm: add spurious fault fixing support for huge pud

This commit adds spurious page fault TLB flushing support for huge PUD
mappings and implements flush_tlb_fix_spurious_fault_pud() on arm64.

> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pg=
table.h
> index a06b0f5c34111..3c1c000cc5dd1 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -107,6 +107,10 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  	__flush_tlb_range(vma, address, address + PMD_SIZE, PMD_SIZE, 2,	\
>  			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
> =20
> +#define flush_tlb_fix_spurious_fault_pud(vma, address, pudp)			\
> +	__flush_tlb_range(vma, address, address + PUD_SIZE, PUD_SIZE, 1,	\
> +			  TLBF_NOBROADCAST | TLBF_NONOTIFY | TLBF_NOWALKCACHE)
> +

[Severity: Low]
Does flush_tlb_fix_spurious_fault_pud() flush two PUDs instead of one
when the fault occurs at a non-zero page offset within the huge PUD?

fix_spurious_fault() passes vmf->address, which is only aligned to
PAGE_MASK.  __flush_tlb_range() then aligns start and end to stride
(PUD_SIZE):

arch/arm64/include/asm/tlbflush.h:__flush_tlb_range() {
    ...
	start =3D round_down(start, stride);
	end =3D round_up(end, stride);
	__do_flush_tlb_range(vma, start, end, stride, tlb_level, flags);
}

Whenever address is not PUD_SIZE-aligned, round_down(address, PUD_SIZE)
and round_up(address + PUD_SIZE, PUD_SIZE) span 2 * PUD_SIZE,
invalidating the adjacent PUD range on the local CPU as well.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117020237.4037=
980-1-tujinjiang@huawei.com?part=3D3

