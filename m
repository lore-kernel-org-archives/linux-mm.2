Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E97C5AC81
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 17:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38A306B007B; Thu,  6 Aug 2026 13:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A676B0092; Thu,  6 Aug 2026 13:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205136B0095; Thu,  6 Aug 2026 13:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3F516B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:12:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 715451C004B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:12:43 +0000 (UTC)
X-FDA: 85071489006.01.F4B9358
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C73DD14000F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:12:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c8OYpXn/";
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786036361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i2yjrrVc+H/dOZF8X/JCAszDBzatuRJpY6enVbVkXDU=;
	b=vaTwzR/OB4jScLrFmiegDRtams0fHd4SoFUjCBkujTQIMpYayMbq+EK9Vx6fsMavWSDqoJ
	2tyXlcvvbfXntCW8HAnZ100JuQhsFvsARCw3OOXuBMiJ7Hrq2BgqDKP+5MkCZew6Pxv/ht
	eG5oWjnHMWjbjNngO151xbshF9D/s40=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786036361;
	b=E/Cy26V7VTcPxJhiKgKDS34GGHALxSSRdz/bFKNHkNknlDdFVWC2y+IjZtk3S6um8lFouI
	gcvfmv0z3Ly3PozBSFtET4LGy+utCVd7x5Gc/ltcO5o1xEdGao4nzph8Ug0K7/H0lG2/MF
	4X4P527R8lBRkUwCXsHx5IUKUi+QSjc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="c8OYpXn/";
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4556760AB1;
	Thu,  6 Aug 2026 17:12:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BA71F000E9;
	Thu,  6 Aug 2026 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786036361;
	bh=i2yjrrVc+H/dOZF8X/JCAszDBzatuRJpY6enVbVkXDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c8OYpXn/lbymZWYNNGPbBk8+3HfighE8u/aLjR6Id3SpcMlVswuIxuoFT6i8+sJVG
	 33bgpDZK07lgJdRnLMQQM5x5OHdfGvrUlwrg07n1Vrb5Uhrfcf7XF85qEDFGTpmbzJ
	 qifqGwAx2bDkh0NXTIgleM+IkLM3PHw2BFHX6yZMbeRqljFQbSRqJcqKkhvmOKwx4y
	 8hBZqfwDXrrUJpo3Surfw1/jC6G5IUWLTS95IreVfJCJJxrzmp1dOhdDQ+kcloC6rE
	 eCHWu6iyOrudRbovBNdMtzXkfpZdjrLsc4CWBTA/u9nkgylUVc+I/jIl/BOLL8csMs
	 892czlr7RY3TA==
From: Will Deacon <will@kernel.org>
To: Russell King <linux@armlinux.org.uk>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Bibo Mao <maobibo@loongson.cn>,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atish.patra@linux.dev>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>
Cc: kernel-team@android.com,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-openrisc@vger.kernel.org
Subject: Re: [PATCH RFC v2 00/20] mm: optimize unnecessary loads due to ptep_get() and friends out
Date: Thu,  6 Aug 2026 18:11:50 +0100
Message-ID: <178601690203.388302.5785771709606318463.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
References: <20260722-dummy_ptxp3-v2-0-d9e4bad31e0a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C73DD14000F
X-Rspam-User: 
X-Stat-Signature: gtknibxc1k6hiob7yc9nbinc7k9yhiep
X-HE-Tag: 1786036361-367087
X-HE-Meta: U2FsdGVkX1+o9dWUFlzVBbHezz4wPv/YS4RW2CkrRLs2xl4SWlNThDy3UWHPlbvzmWzFlAu5yih2iOfpW672CHcrBOlxV6aO0pF5UHGJIx3Q+G5LYVmwiByHoWDbLcfNRNdDMSZNP5CZUGrZv3Gv2u+e6CG0O85AV7r8bEDzCd4c1+xtAmT9Qr9hJ033UINrzirSaK9/7Ce9v81DNkwQHV100AiS4yD8/bNIAnrAqMKzM2xPuYvwpj+MPhCu1UuNRgRwXmxFMqm6rjkqws59gO/RZrsxEyAqv2DE8qfb7tR++m6Qja5MsP0EfKUWHbsFrfeozYfP7EuhHj3rw03Jkufd/Jjil2UE1k3/pSg6a8qgVCVnS6DsfXO9rccn0LHWv/iLgBv3K/Jj0/6S7q7fAWFkpPtR4HJxYHR80VWMKgm5dlEV3fTulxM56BBK9QYQGgaMVmju2Bmau/MXte0Xvdf8YxYlXYDM34pHD7cfdbhQQSDzNf25z9n6eTKV2Zm4Hf8EtzdVB8WxLDyhse44lkAtg+KbnqCpL5GSqDmQBMMsjz/+Ar21qvUBSvu0guLAEDpD4e69LKLqq9g8A9BZ8TfbUYH5fcT/ZFpQ9EhIiVFevZy1enQKAM3hJiTi265GRbRwdPQg8ddgCFY7h/Uy9mNqTVpM8GAsoDHcr3FYdVqhrLGGw3rksKZzTeWwUpAkisoKjS3SqN+9a5kb8+mW1Z0YpJtlh4C9Qo/VqnVLMNJnI4m++1eD6zyFkOM07uOT5bAisos8GPFS9tdIkBavq2NvxhTY3zgRSVhjIK3i/GLabugzvinAPMyRGpN8SC4D2Q3Cc9hdusp0sWLsjilOEQem5SRvRapnnldZSEVZDhJI3MStguRSbmW+DhvtuhzBKqyMO5w4OdkpT/9pZsmkmU5HEYVw0FTVaBE837ApggiWhKqIrDtcMMgaUgFZE3Vru453M82BsQyc0qU6A7t
 hyiy2+Rn
 IpK/Y+GcwmZtW8awO98ABcfN/f89f6e7WNJtEQmNGx48u4dGSzNuv7smpqDDbDqdbbZr1pFN/rqPy0lH+uNxO1gH3rC25EpE4vVuELoVI4mrb4AMiKycbKV7LHtPNbHUloLBmv5pSUO5w6FXNatZ+gVA/vNhTfAJD5IoDZiC7RY9kTmv+vXCgCn3CipIHDIFNO0uoN2T1xb3Gui4TmQdo/QZ42Vdt+JNFP0aZXPQCx5mApCCjj3JnEwzInMYkWc5Pavqk6gfxexzTDLUiRB4FkDQSXOI66LuWcG8Byfvk+WT4xzgI6vT/yLkwtPeK8fID/i9QYsI1lixAfvvEZ+uNN4KraxBi9iNfNj3m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 16:30:08 +0100, Yeoreum Yun wrote:
> Using ptep_get() and its counterparts in common code is suboptimal on
> kernel configurations with generic compile-time folded page tables.
> By default, ptep_get() and its friends expands to READ_ONCE(),
> forcing the compiler to emit a load even when the value is not used afterwards.
> 
> This issue was recently reported by Christophe Leroy [1] for ppc32
> preventing futher code conversion to ptep_get()/pmdp_get()/... helper
> and the same behavior can also be observed on arm64 when built with
> 2- or 3-level page tables
> 
> [...]

Applied the arm64 patch on the end to arm64 (for-next/mm), thanks!

[20/20] arm64: pgtable: convert pte_present() from macro to static inline
        https://git.kernel.org/arm64/c/3b56ebafecc4

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev

