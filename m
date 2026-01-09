Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592C2D26D60
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFFD96B008C; Fri,  9 Jan 2026 10:08:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD76E6B0092; Fri,  9 Jan 2026 10:08:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9CB6B0093; Fri,  9 Jan 2026 10:08:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9AAF56B008C
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:08:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F23F1A9ABB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:08:13 +0000 (UTC)
X-FDA: 84312756066.19.92B9FEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 93799100014
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:08:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D5A49i8X;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767971291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2O5PgS3h7rUMfW8zetc6lr+7DUQ51Nxsxl6VimhpPuw=;
	b=cRuCo96UmV7aKrnydAYu7QG8T797cffMTdJEP3vd+vCeSPR1p+7YMsfvXd3AsvEZw0MHYG
	3AqsPevoRJUF2G/GrkoRFisaH7YlE85v2XW8K+FSmzLBuyq1toCd7XPDzvPjwe1bTqPDep
	KFVoql3XryGzQBqhG3ZvofgJAyG7NEE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=D5A49i8X;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767971291; a=rsa-sha256;
	cv=none;
	b=p+yxMM34HY8W8hmBRI3yLUc6bIDIE4+iqTfe5vNJoWfpxL57ltZhQci9RDDRPe+lCguWoh
	Wctos/OvrylDxRUTp6UVsb8BBf/7RzmC1UL3g7bSwqWzGLXoaTpohx5wPN/OjyE2VHgdho
	8QrYuOWC/Q3d9tqxD9VkLkC131zKKgA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CEBC42AC6;
	Fri,  9 Jan 2026 15:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1067FC4CEF1;
	Fri,  9 Jan 2026 15:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971290;
	bh=3Z8L26dcTskZ3ZdCQN0iSI+dIODX6q9MdBtGUwgu/Fc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D5A49i8XZ+WWgc3yo8WpoToMpiFiiYIORsD5kdhtfLHgOWLJ+teHa3YKmPfqvZQto
	 EOjbH06xY/Y2D1tuKVkl4Bn9mfBj2pRUINZJHsmiBlwwDKMfmgPNBdydHY/WcoODaP
	 hXTbfv9bYAipERXqMFeW7thazUf0MBtEe10dcKDUEhB49l5TpS6DuQJGLnLWIPw35L
	 /A7EpMCyhB3OpiWJ4xcCGJauiqHLzHAPYo90gEXDJEGp6mJ/mQ/yOKD0hyaBuAIhmW
	 2g9u3gE5rzMBGVklkmAIGwRJV3u8nzhfd1IwpNssclwPUhgU0okSyNsciYIOrvSviH
	 Q73z6sh0NFzwA==
Message-ID: <1e123306-0efe-457f-953b-d4a27ce6bc60@kernel.org>
Date: Fri, 9 Jan 2026 16:07:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 14/14] mm: Add basic tests for lazy_mmu
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251215150323.2218608-1-kevin.brodsky@arm.com>
 <20251215150323.2218608-15-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251215150323.2218608-15-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pkj1etg5rydqtj49731bktr41p5pqm7x
X-Rspam-User: 
X-Rspamd-Queue-Id: 93799100014
X-Rspamd-Server: rspam08
X-HE-Tag: 1767971291-294875
X-HE-Meta: U2FsdGVkX1/0+ihRYS5uUxnvpMZ39czxA+z5x2N3cOXSRZzHVrL7ESbHQYri/I38bSsir/4hHSz9XDIzX+Ez6FOVhT8QKTQ5jdH/qAUi5mJBwTg6zJ4T/Hq95tkI2R3e4VdPeWmC4A//LuZqeT7mcuOYmALXG2BZerEtjYBK7wC1yaUPaJAv/J2YfYPrt6vbCMzMUlS3BNdwm1cTEC7YvZ/QpYiSZO4+FcmLVBUvmdOPV5Y5vOpc6jgj994WRKx8iH0tUTrXrMfDLT4xrCoZKxzcP48oImjyppzKIj9j0sOyi/kUwjWhZ4NsHTxWYVchp2AJPqjSDP6FEARTIHXJhSPidlVvsp/khq+Uj2CJpJ7NBkCJl1p2Dc6TmYgWBNJEwMGwgU49/MafApfCjyI8eql8JdMmHeAAY/R19zrDvsGveZUQVsTBVx56lOepof4UHBpIIyNopMKYY2DxfKbOk4ybeo6CHJhq6OI6UoWLkAig3dllXK5WMBBTJCWt07Ia/W2We+wxPDA8qRhkd3CoNixAzXEK+1zEoL9QMu0g7rNsPFCjaWw2TQdw2K5E0RgpBnLf8IqDuq/CencCpomg7ir6UtNUxeepyP7s3i8aVR7hT4vp6gZnEVbRmhfgKoKwte3D29ObDGJ7VZznTPMxzdwQjPZ9KVzDi8I+0P8t4WCngCyzwzszFSFphdhTdR9v19L/1HZvPC2wiNKAcE2XiXz6u0wvxOuxMtWCaF3uhYbokgqJ1NzI3nlnrdA9HjAqEfI8Oiy+C8tZDtHsT+rWGZWwiD7cthahyMylbFgen646U9gUr3g6ChYbRuRysofn5JY0PPQuzL9Xe552X/Cf6V6BTYIgErywwi3uao3+x4ePMRBCVoOrHjw8xRVLdDCj6rPGhe2eFv2GWg/TkKEA19hsks9Z2/d6xweMzapWgu1BcX479ZutIx9eAhItSYU8pVZhlXafSiwDl7fJ6Ju
 Sji85KFJ
 kAruY0vryi6BLXhhQBNsZ8G2kpfcNK1sIqSSivUvkGuRnvNl3+uD9V2sKHr5so1pYlDp8Ciozq3tbk6fAEeOHOVGXw1jZEUT0WWHRO8/mV0AOHA7+9+LEtyhGU2vzEaapc/Jq4q+GAJLpSNwLY/hAXFKxG/keIH8tAWi2n2Ak2gt3xVYzqmvj/RsKl1XuShxQhG30WG/h+B9y+MqZHVIluPDuYqOCKCAcI1WBs+Duf9spD/IGH1ylGta/KbWF7cKUeaJ2K7/5O4XBdcBz0tDbbLQnm8IVBByA3HxEThCbpx6QsRtlb8aC0P0E/DY5elZGCHjxQBsHarZDb/kWG2LJ9LsJZH21eunIl+ZiFf/lvxPsjcyYliZ0aDEImXs5enhRZ1Ns0ByxOTJV3X4A/P0soIdJ9Ls5w9S9byddfdeQFjo81E6uIfok30xoqs/HyUGVMkVQyoPPJWfy+dE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 16:03, Kevin Brodsky wrote:
> Add basic KUnit tests for the generic aspects of the lazy MMU mode:
> ensure that it appears active when it should, depending on how
> enable/disable and pause/resume pairs are nested.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   mm/Kconfig                     | 12 ++++++
>   mm/Makefile                    |  1 +
>   mm/tests/lazy_mmu_mode_kunit.c | 71 ++++++++++++++++++++++++++++++++++
>   3 files changed, 84 insertions(+)
>   create mode 100644 mm/tests/lazy_mmu_mode_kunit.c
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 62073bd61544..ac48deb44884 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1471,6 +1471,18 @@ config ARCH_HAS_LAZY_MMU_MODE
>   	  MMU-related architectural state to be deferred until the mode is
>   	  exited. See <linux/pgtable.h> for details.
>   
> +config LAZY_MMU_MODE_KUNIT_TEST
> +	tristate "KUnit tests for the lazy MMU mode" if !KUNIT_ALL_TESTS
> +	depends on ARCH_HAS_LAZY_MMU_MODE
> +	depends on KUNIT
> +	default KUNIT_ALL_TESTS
> +	help
> +	  Enable this option to check that the lazy MMU mode interface behaves
> +	  as expected. Only tests for the generic interface are included (not
> +	  architecture-specific behaviours).
> +
> +	  If unsure, say N.
> +
>   source "mm/damon/Kconfig"
>   
>   endmenu
> diff --git a/mm/Makefile b/mm/Makefile
> index 2d0570a16e5b..9175f8cc6565 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) += shrinker_debug.o
>   obj-$(CONFIG_EXECMEM) += execmem.o
>   obj-$(CONFIG_TMPFS_QUOTA) += shmem_quota.o
>   obj-$(CONFIG_PT_RECLAIM) += pt_reclaim.o
> +obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) += tests/lazy_mmu_mode_kunit.o
> diff --git a/mm/tests/lazy_mmu_mode_kunit.c b/mm/tests/lazy_mmu_mode_kunit.c
> new file mode 100644
> index 000000000000..2720eb995714
> --- /dev/null
> +++ b/mm/tests/lazy_mmu_mode_kunit.c
> @@ -0,0 +1,71 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <kunit/test.h>
> +#include <linux/pgtable.h>
> +
> +static void expect_not_active(struct kunit *test)
> +{
> +	KUNIT_EXPECT_FALSE(test, is_lazy_mmu_mode_active());
> +}
> +
> +static void expect_active(struct kunit *test)
> +{
> +	KUNIT_EXPECT_TRUE(test, is_lazy_mmu_mode_active());
> +}
> +
> +static void lazy_mmu_mode_active(struct kunit *test)
> +{
> +	expect_not_active(test);
> +
> +	lazy_mmu_mode_enable();
> +	expect_active(test);
> +
> +	{
> +		/* Nested section */
> +		lazy_mmu_mode_enable();
> +		expect_active(test);
> +
> +		lazy_mmu_mode_disable();
> +		expect_active(test);
> +	}
> +
> +	{
> +		/* Paused section */
> +		lazy_mmu_mode_pause();
> +		expect_not_active(test);
> +
> +		{
> +			/* No effect (paused) */
> +			lazy_mmu_mode_enable();
> +			expect_not_active(test);
> +
> +			lazy_mmu_mode_disable();
> +			expect_not_active(test);
> +
> +			lazy_mmu_mode_pause();
> +			expect_not_active(test);
> +
> +			lazy_mmu_mode_resume();
> +			expect_not_active(test);
> +		}
> +
> +		lazy_mmu_mode_resume();
> +		expect_active(test);
> +	}
> +
> +	lazy_mmu_mode_disable();
> +	expect_not_active(test);
> +}
> +
> +static struct kunit_case lazy_mmu_mode_test_cases[] = {
> +	KUNIT_CASE(lazy_mmu_mode_active),
> +	{}
> +};
> +
> +static struct kunit_suite lazy_mmu_mode_test_suite = {
> +	.name = "lazy_mmu_mode",
> +	.test_cases = lazy_mmu_mode_test_cases,
> +};
> +kunit_test_suite(lazy_mmu_mode_test_suite);
> +
> +MODULE_DESCRIPTION("Tests for the lazy MMU mode");
> +MODULE_LICENSE("GPL");


Very nice test :)

I think I prefer the EXPORT_SYMBOL_IF_KUNIT over disabling the test for 
PPC and over making lazy_mmu_mode_enable() non-inlined functions with an 
exported symbol.

With the EXPORT_SYMBOL_IF_KUNIT stuff added

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

