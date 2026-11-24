Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A650606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=QGEngSdy
Received: by kanga.kvack.org (Postfix)
	id 1921B6B0628; Tue, 24 Nov 2026 03:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1419C6B0629; Tue, 24 Nov 2026 03:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057906B062A; Tue, 24 Nov 2026 03:08:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5E586B0628
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:08:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D441740B05
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:07:58 +0000 (UTC)
X-FDA: 85469284236.03.A04F90B
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf20.hostedemail.com (Postfix) with ESMTP id 31CA21C0006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:07:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QGEngSdy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795507677;
	b=MtNC6LTSq5B92ZJvAmXjwis1YkVtvdqUmrcYpkE1bc9igXEQ4j8+lCSc9y7yOe08MpwmWE
	BXu2KM6xXt6fXcDnhb3lc3t6XotwrEi4zZgcZqb/ssZnlDXmsM4XMnj6JcREjy9i69t3if
	GbtDceiV1xIrSt82X29RYqMYid4KGzo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOD5TK3jDZSV0gxKAkHVgIM6aEdA8CEYNdRPZbFoBkE=;
	b=hDFTvgtwpOM+mgC9LFsA85s2l6XIcyYBMXcbjQ8LJLhPaojyS0sHzpBcXFPnVRukFgwDXg
	o2eDBDQm6xHnM/SqHDS9eZe+Yuqq8rMECPuNm8zIFPbNujjMIZI0Ijk9AiSBkOIJsbpc5X
	GVPRwv19x5JpVsd59frM1dFZ+IC98Rc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=QGEngSdy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-67be1e468a8so3902437d50.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:07:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795507673; cv=none;
        d=google.com; s=arc-20260327;
        b=gXw7MX04608R9E2IFCXJDF6MQljv+F6YAEng5aHQ00pnxZRChxSmvVgU7FRymdVPmt
         BhL7t1yLsZ9lhNKYcJ0HbyFZdg2m6R0QPotsxOKC+G0pR2fgYjrk/fwgeA2xF0SPwJuG
         FOTFDax4TilO+TrYUF8vzOiMZ5H2pFiOoJ/912lEBgKCiPnWDW8LMaw71Jks/lVUscXJ
         6YJT0yvkYnFA7qeB8TenVys76sCLros20JFfv4pRpu+dcMJ0EPRqDUZNkTObQ8+crG+S
         G0BDZiYjaNp53CBfHMgGmIND8IS7Fn4ffOR7J0aDNcfmOKziDys+LOFVAwk9i3NKFG3L
         PETA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OOD5TK3jDZSV0gxKAkHVgIM6aEdA8CEYNdRPZbFoBkE=;
        fh=cflGVd80/FU+jR1qK3VbYenZthiZWxosn/ipXMwW4S8=;
        b=ZixvF4BtCCaa4D+64CRihYnlbWCRCf1pxS4VafuURjMGgLU93nB+hd7wta4jhp5EMX
         XRZuHJYXNV1vzYxFg5ZJxOC6+sx4Fr9Yd4r2EVl7XNtetgS/PWYRd+ZTm6qegJwg7QXu
         gew5ooO1pc/X4ZwdMoOo+5CL9lP7patJ8Kqk60EFNcrDD64LAcmJ88cGO8pSTmQ4slo4
         QCkdFuwgaA5OzIf4wjk2lNsepsO7dqJbHRWBlbkam/JI6DzsvKn1KShTaDrhSoGB0Cpq
         oegUb4toHhXSpAu2aUWd9O7udVXE6uoHUZ09zODTP3x8mVDUOfEiNsjjLvuiXtSjeUEo
         bE7g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795507673; x=1796112473; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OOD5TK3jDZSV0gxKAkHVgIM6aEdA8CEYNdRPZbFoBkE=;
        b=QGEngSdySv/vxamShdlFnnR6xOwZfbBIODWBoCiSxzhPdtIIuQZ0rNDX5XwVVWE1Bh
         UmcQm9UuMwACRxijZDYNVFCITzh5ZFXQDSdgXK+FBfqQNI+ChpevpkEkjN400Zbe5rsz
         7fCpc+suAn8rxMPZlTf1kxLKb6M1B2akPOeKdnOiJqF0+74magpD6YGfBejvWsaFUbWd
         Uc87VmJi7Y/wTGFPffm662alxlfId19Ktmq/0h/u9Qle9K5UVtpzlx48Xtfj9Vq0o8p0
         jzMbRJ0SBqiWHwK8t+aRtOQ7Cu8bzwZ2BuoDkRZOa9wqmibENErCjEcNQF/aCU5ZOkGm
         t9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795507673; x=1796112473;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OOD5TK3jDZSV0gxKAkHVgIM6aEdA8CEYNdRPZbFoBkE=;
        b=JLFfjJUfqyat6hHllLVniahN5TBLPs5wxhVZp+swW7umFboWaTsNUchlkfbP0pAfUr
         XjOWLEft2zyWByAMGOPvxcKKVsVpr6UPyQTvKvCu8QN//Qs9dnMuEkGzFdGIyQQze6+t
         GHT/BFt9IEX2s7bJlDv0rKs1G4DifbVLQwK0V0IsUsXaJrdHuILOsu9dYowMdVUeso2q
         aYbC5Low9tDO50PFAXbNLvmM/9QGO/TbuSWex0B6iYH05LUyMMcxPCr4lPVwZd3iOiR7
         ogsW2Pn5qKXAFf2f5XHlcDF4+7/KAsII+KYxVoZPeWJMt8BpRWEzFIVNVhCUO6auklSs
         /Cwg==
X-Forwarded-Encrypted: i=1; AL+hErEmcwrkeJeKgsPUpSPkr0i0V9f00O8E/u2kaDlZRUq37xwjMvHIjs+IsPNap1bxT+OtPwO1itYx9w==@kvack.org
X-Gm-Message-State: APuU4Z+vVw9C3Oe0Zcmg0VY/f0AyC9s11RcWQYdv4Lg64WyEqfTeoih0
	qN1Y8CdHrpcPfReMPLVU2CdVj8lPSszM/ZZ36KLiPkB+6IRZYZwa2fVtPPrTV3lzi/XIyFnZ3GD
	lK6ND+/51rZLQ+N8KFy8CUMA+NJW4NOX0rxbQ3Pu8yv0p3Xz3ZJTKmJbBug==
X-Gm-Gg: AZFdTZdIrsd1zFFcLNN/1Q7jm35iObT5pwKH2QSIFUkIvq5ufWogd5Bdjf9NnoIG8vC
	zTRZ+7xTLJS814F4vJyvecz5ETZEuscOmO+QMEGpN0yN80LNdCOOHFeFQ4b3q1CyaSTvkq3W6Ux
	5T1po/d3YyPLtKhSCTMBWDbO+frVo+zDi2d6Ffy52KsR/Hn8eelhUc7dbyzgLuoKSE5QEPFyV9i
	n3uaNA0qWv1+XXXA4wWg4GlPmF3G6qFTvM4BZ2EVMY5xpEZh3vg078aobcHtLEW39NqXRzEgmFJ
	FQ4fblINDMUCAeYAR2+5oPpCJ1myQWLjz53zuMl8BzThLfTI13PsUw/xeyQfAQ5hkscEdSBIZn/
	iS5ZuBDcD5PXEPm4KPCN2oRb/rnHwr96iRPDU
X-Received: by 2002:a05:690e:150e:b0:67d:eb12:7327 with SMTP id
 956f58d0204a3-67df44790c9mr5429914d50.91.1795507672913; Tue, 24 Nov 2026
 00:07:52 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <202611240743.6AO7homY042860@mse-db.zte.com.cn>
In-Reply-To: <202611240743.6AO7homY042860@mse-db.zte.com.cn>
From: Muchun Song <songmuchun@bytedance.com>
Date: Tue, 24 Nov 2026 16:07:17 +0800
X-Gm-Features: Aa3M54qVy_ZTjDekbWEQZL4rKpZRExSUgAWOCJOur9_RjV78JSMUFlskTD39pac
Message-ID: <CAMZfGtX4E96XN7suB9=0=xg8k9=S9Qe9otWYjH02oDtKPyXbkA@mail.gmail.com>
Subject: Re: [PATCH v3] riscv: mm: Fix split linear map page table allocation
To: li.hanting@zte.com.cn
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: eig99yh6ufsqtcojpwp899ydhf73673q
X-Rspamd-Queue-Id: 31CA21C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795507674-936866
X-HE-Meta: U2FsdGVkX18uSrqeVoxhMtUPSr4kufX5XK6RGZRGTRxzwqBBd3ishKRQGxL44cKhpbHVzRUSFr+YeZPTaWhxUKQTNGBVazeSGRWRC57mmiQaLw8mvgVU2J0NyCIhEWHropzE/LIE5YS453gpoQ8NjjW/uR0dnzleeJHmDegPpH2sv1IE7ghUKVeKNEbXyqwmBhXk6+hyhy4yGJymLOut52n/1fi2nTw0NuhQo1vRx2xBGBN3kbo2FFvgxMJmjRaOH1dsddpw1TVmWsVtxkoh7vTWUqw/swvBsObfgJHdWFib9/IObW+Tb8Xfdo7PnQCcyhEZZyF1SbVM4MjppFHdNC73XacxU7CvOzk4XNdsEk7Zl+c7UvGQcguBSH/HfQG6qmUMsZr3dHwnhbKn1iCtVDe39XJqgKyNVcP93XsuaQ+6peYxDWJs8yQkIPk9oCw+yrXCRz9BDWiHvq4iiLuDu6KZV5Tk33uswPNXnVmIE1BEZmWhenK740ZLtO/tIiiEbp5a2AUPAc2teNC36ECGLwrwNq9S9JDhfBbjiVT1HdHUNY3aR0nnIVG4WKxTuIlp9hTcLqD8+lcgTcQEmf5ImvFxi6yz+tDPVZ25NLGX93Jx5ITQl78eJGAReou5uirSiyjlWxQroH0WbhO2v/6VKFxIK5xFrwYpmILsS1v2HtKrC4ZmlDbI+5VKclkpNT8lwF34ubMGYMI7Vdt+o8/+cJjEv0WdTv7KXmihxLo3OdT8THXteBbs7i12XP/PINcDevNIfOcda/TrSuOCyW039a+R9ClJCfaHY2DFRN1QNT1mdqq21e6H8TRIaOsgusvB+vvJdMQ0bTphv7vH53eoVLWJNBYYMVWbnGApUS5Ro8o+WvflYcGHxwEg4VUMr49Vn+Yg9QVNER6Kgq13v9silmcTawAH931VXp45GDev75yVGYHcoCUVtcYk2RDsHaQ5cK4sRIx/oip0C8wxH3V
 dzDVQSEh
 zNUdSHpor122v8DDFySDKbJaNrU8oZCTq+SN9BjQO3CqeR76T+3oLRvfWILu4n5ES+4sEjNSqQQcSBXQQpbSiguxiQWYQ4GKvhBO3P6zkuKMPz5/BK3iI27mDzSyX66qXCk3WJiPyPsJ4e6H8W7j0ocbtAP/E2f8ag6oAgQP7vJalPRH/4UbjGX9MBlfTnZx7iI2QXVCZ74jZCQhpYwmCY7whM0cSRDlTt6d4EDENECLjNtlad1x7H72e96LN2Xee1cV5Ko2/EFtUuZfCyVcBZYg7z4Iw/+bTvWe1ecWSXZlOyQ36bqEE4oFjd+5VB/q0WhTdXo+sFLIxENJ95BqZaA793eNJh1+Kafa+w+6tCji4tOzwWb9JmDq4vi8QW5Pl1hzldsLH37PhyYS/FKeiUWbtODR7g6fUm5WZyctqAB1+1TAMqHeNYQOb+4q3lzK1maeuHWeznwTkSbCq/N7zrLKTd5dF0NnekNsSbaIlAS2fPbA/qoJ/JgtGk1bUCOcPowXm0YmUS1Vi4E7BcZ89YgKH76XrjasbmPhMW8ha9JS6ZePOChIwX4yV5IFomrKWcr/wKu8Rb1pqJ14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 3:44=E2=80=AFPM <li.hanting@zte.com.cn> wrote:
>
> Commit 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel
> page tables") recently fixed a latent inconsistency in the x86 CPA code
> (assigned CVE-2026-97525): __split_large_page() allocated the new PTE
> page with a bare pagetable_alloc(), bypassing pte_alloc_one_kernel(), so
> the page table constructor never ran and the resulting page was neither
> flagged PG_table, nor accounted in NR_PAGETABLE, nor marked as a kernel
> page table.
>
> RISC-V open-codes the same pattern when splitting the linear mapping on
> behalf of set_memory_*(): __split_linear_mapping_{pmd,pud,p4d}()
> allocate the new page table pages with bare alloc_page(GFP_KERNEL) -
> three call sites in arch/riscv/mm/pageattr.c, introduced by
> commit 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX()
> by splitting huge linear mappings").
>
> As on pre-fix x86, the resulting pages live in init_mm without the
> PG_table flag, without NR_PAGETABLE accounting and without the kernel
> ptdesc marking. Under CONFIG_MEMORY_HOTPLUG, hot-removing memory tears
> down the linear mapping of the removed range via arch_remove_memory()
> -> remove_linear_mapping() -> free_p*d_table(), which releases these
> page tables through pagetable_dtor() even though the constructor never
> ran, underflowing NR_PAGETABLE on current mainline. Muchun Song's
> series "mm: Fix page-table teardown during memory hot-remove" [1]
> fixes the freeing side by skipping the destructor for pages without
> the PG_table flag, but the root cause remains: the allocation side
> still bypasses the page-table constructors, so these tables are
> unflagged and unaccounted for their entire lifetime.
>
> Align the three sites with the standard page-table allocation and
> population helpers:
>
>  - the PTE level switches to pte_alloc_one_kernel(&init_mm), exactly
>    like the x86 fix, and installs the new table into the parent entry
>    with pmd_populate_kernel();
>
>  - the PMD and PUD levels switch to the generic pmd_alloc_one() and
>    pud_alloc_one(), which already handle the init_mm case by selecting
>    GFP_PGTABLE_KERNEL, running the level constructors and marking the
>    ptdesc as a kernel page table, and install the new tables with
>    pud_populate() and p4d_populate().
>
> No change to the resulting linear mappings is intended; the observable
> difference is that split linear mapping page tables are now properly
> flagged and accounted, so /proc/vmstat:nr_page_table_pages no longer
> under-counts.
>
> Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() =
by splitting huge linear mappings")
> Signed-off-by: Hanting Li <li.hanting@zte.com.cn>

It's annoying that you didn't cc my linux.dev mail, because I used this ema=
il
in v2.

The changes looks good to me.

Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>

>
> ---
> Changes since v2 [2]:
>
> - Install the new page tables with pmd_populate_kernel(),
>   pud_populate() and p4d_populate() instead of open-coding the
>   virtual-address-to-PFN conversion, as suggested by Muchun Song.
>
> - Reword the intended-behaviour statement: the accounting, PG_table
>   state and hot-remove destructor behavior are intentional functional
>   changes, so "no functional change" was misleading; it now states
>   that no change to the resulting linear mappings is intended. Also
>   suggested by Muchun Song.
>
> - Shorten the subject and drop the greeting from the commit message.
>
> [1] https://lore.kernel.org/r/20261008073021.2512665-3-songmuchun@bytedan=
ce.com
> [2] https://lore.kernel.org/r/<202611230851.6AN8pFDD065900@mse-fl1.zte.co=
m.cn>
>
> Hello,
>
> Thank you for the review, Muchun. All four suggestions are
> incorporated in this version.
>
> One detail worth spelling out about p4d_populate(): unlike the
> previous open-coded set_p4d(), which falls back to writing through
> the pud alias when 4-level paging is disabled, p4d_populate() is a
> no-op in that case. The difference is not reachable here: with
> 3-level paging, best_map_size() caps the linear mapping at PMD_SIZE,
> so a leaf p4d entry can only exist when 4-level paging is enabled,
> where p4d_populate() matches the open-coded write exactly.
>
> The discussion about deferring this change until free-path work
> lands is now settled by Muchun's series [1] being queued for
> mainline: this patch fixes the allocation side of the same lifetime
> mismatch.
>
> (Note: the generic CPA rework series "[PATCH RFC 00/18] arch, mm:
> create a generic set_memory/change_page_attr core" would eventually
> replace this code entirely; this patch is intended as a small fix in
> the meantime.)
>
> Comments welcome.
>
>  arch/riscv/mm/pageattr.c | 38 +++++++++++++++++---------------------
>  1 file changed, 17 insertions(+), 21 deletions(-)
>
> diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
> --- a/arch/riscv/mm/pageattr.c
> +++ b/arch/riscv/mm/pageattr.c
> @@ -3,9 +3,11 @@
>   * Copyright (C) 2019 SiFive
>   */
>
> +#include <linux/mm.h>
>  #include <linux/pagewalk.h>
>  #include <linux/pgtable.h>
>  #include <linux/vmalloc.h>
> +#include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include <asm/bitops.h>
>  #include <asm/set_memory.h>
> @@ -109,23 +111,21 @@
>                         continue;
>
>                 if (pmd_leaf(pmdp_get(pmdp))) {
> -                       struct page *pte_page;
>                         unsigned long pfn =3D _pmd_pfn(pmdp_get(pmdp));
>                         pgprot_t prot =3D __pgprot(pmd_val(pmdp_get(pmdp)=
) & ~_PAGE_PFN_MASK);
>                         pte_t *ptep_new;
>                         int i;
>
> -                       pte_page =3D alloc_page(GFP_KERNEL);
> -                       if (!pte_page)
> +                       ptep_new =3D pte_alloc_one_kernel(&init_mm);
> +                       if (!ptep_new)
>                                 return -ENOMEM;
>
> -                       ptep_new =3D (pte_t *)page_address(pte_page);
> -                       for (i =3D 0; i < PTRS_PER_PTE; ++i, ++ptep_new)
> -                               set_pte(ptep_new, pfn_pte(pfn + i, prot))=
;
> +                       for (i =3D 0; i < PTRS_PER_PTE; ++i)
> +                               set_pte(ptep_new + i, pfn_pte(pfn + i, pr=
ot));
>
>                         smp_wmb();
>
> -                       set_pmd(pmdp, pfn_pmd(page_to_pfn(pte_page), PAGE=
_TABLE));
> +                       pmd_populate_kernel(&init_mm, pmdp, ptep_new);
>                 }
>         } while (pmdp++, vaddr =3D next, vaddr !=3D end);
>
> @@ -149,24 +149,22 @@
>                         continue;
>
>                 if (pud_leaf(pudp_get(pudp))) {
> -                       struct page *pmd_page;
>                         unsigned long pfn =3D _pud_pfn(pudp_get(pudp));
>                         pgprot_t prot =3D __pgprot(pud_val(pudp_get(pudp)=
) & ~_PAGE_PFN_MASK);
>                         pmd_t *pmdp_new;
>                         int i;
>
> -                       pmd_page =3D alloc_page(GFP_KERNEL);
> -                       if (!pmd_page)
> +                       pmdp_new =3D pmd_alloc_one(&init_mm, vaddr);
> +                       if (!pmdp_new)
>                                 return -ENOMEM;
>
> -                       pmdp_new =3D (pmd_t *)page_address(pmd_page);
> -                       for (i =3D 0; i < PTRS_PER_PMD; ++i, ++pmdp_new)
> -                               set_pmd(pmdp_new,
> +                       for (i =3D 0; i < PTRS_PER_PMD; ++i)
> +                               set_pmd(pmdp_new + i,
>                                         pfn_pmd(pfn + ((i * PMD_SIZE) >> =
PAGE_SHIFT), prot));
>
>                         smp_wmb();
>
> -                       set_pud(pudp, pfn_pud(page_to_pfn(pmd_page), PAGE=
_TABLE));
> +                       pud_populate(&init_mm, pudp, pmdp_new);
>                 }
>
>                 ret =3D __split_linear_mapping_pmd(pudp, vaddr, next);
> @@ -198,23 +196,21 @@
>                         continue;
>
>                 if (p4d_leaf(p4dp_get(p4dp))) {
> -                       struct page *pud_page;
>                         unsigned long pfn =3D _p4d_pfn(p4dp_get(p4dp));
>                         pgprot_t prot =3D __pgprot(p4d_val(p4dp_get(p4dp)=
) & ~_PAGE_PFN_MASK);
>                         pud_t *pudp_new;
>                         int i;
>
> -                       pud_page =3D alloc_page(GFP_KERNEL);
> -                       if (!pud_page)
> +                       pudp_new =3D pud_alloc_one(&init_mm, vaddr);
> +                       if (!pudp_new)
>                                 return -ENOMEM;
>
>                         /*
>                          * Fill the pud level with leaf puds that have th=
e same
>                          * protections as the leaf p4d.
>                          */
> -                       pudp_new =3D (pud_t *)page_address(pud_page);
> -                       for (i =3D 0; i < PTRS_PER_PUD; ++i, ++pudp_new)
> -                               set_pud(pudp_new,
> +                       for (i =3D 0; i < PTRS_PER_PUD; ++i)
> +                               set_pud(pudp_new + i,
>                                         pfn_pud(pfn + ((i * PUD_SIZE) >> =
PAGE_SHIFT), prot));
>
>                         /*
> @@ -224,7 +220,7 @@
>                          */
>                         smp_wmb();
>
> -                       set_p4d(p4dp, pfn_p4d(page_to_pfn(pud_page), PAGE=
_TABLE));
> +                       p4d_populate(&init_mm, p4dp, pudp_new);
>                 }
>
>                 ret =3D __split_linear_mapping_pud(p4dp, vaddr, next);

