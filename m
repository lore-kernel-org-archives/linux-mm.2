Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C012606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ha+KKbl2
Received: by kanga.kvack.org (Postfix)
	id 0ABDF6B05BA; Thu, 26 Nov 2026 08:34:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05C1F6B05BB; Thu, 26 Nov 2026 08:34:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3C56B05BC; Thu, 26 Nov 2026 08:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5A716B05BA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:34:14 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46CE91A02FE
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:34:14 +0000 (UTC)
X-FDA: 85477364028.02.2669684
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9C3C2100006
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:34:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha+KKbl2;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795700052;
	b=PT/DsFsi5vou9AIuoFEylyjuniVVWmsKKuA0RK2DhgpzMBvHaBUITzP4yumBs0QfVrAnlf
	RXsGTPCHSNXUALgoT4H6j0rlBsKyM5Z3gPQWdCAxev6YgLWeXT8kfWwKbQqjzR4F6kE4tE
	IuBO6A6H/TnfYQ1Vc5yM/nb5uT4z5tM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795700052;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qt81+PkfF/9Z5xC1Kl9PJgnaTaMn5I7ubGWJjO0rrEc=;
	b=YRTwDZrjGQ7dpUewRDT+8Nh1swklyi0p4KMlI7ACqOzAFyinWHi1awTI+VTu/NFVD26lx9
	cLJpSVscvHfwoghVYn71wR0q07dUi3Fycou8es/FPut1nwGe/1iHz66GHnRKQzkfx5nVVx
	GwdMb6DtM8/F358S5sMa/v0d9XkJ/lk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ha+KKbl2;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 105E2628D9;
	Thu, 26 Nov 2026 13:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1131F000F4;
	Thu, 26 Nov 2026 13:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795700051;
	bh=qt81+PkfF/9Z5xC1Kl9PJgnaTaMn5I7ubGWJjO0rrEc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ha+KKbl2ndTj9TCuTEs0jZS3FNBiRrrg8VW2eymltHU4oMt0xQJ50hF6GRuI0ZBQP
	 60Gy9op/c1LaJ0HmT6+980bBBuC1o7vdRId5V5ZZLrSZ79wT7q2RO/5iqzh36+VzPz
	 i2NmOeoFP3Ib3KkOuT+UD5Gh7UT4hTNRJGeWLDl020U0mAdqNsQACprEw6AXN8hsS+
	 IlrKZ7au59To+4sVFERuiNqXgMSVNBLuMOUjYAZNmiAblcthDH67rEWqBGCUyDjOjq
	 iV0p77LalShqnRhveyRze6BnJHPLlCjMMrp3j86xch3Fn7p4u62B2T2ROVllF0Xg7h
	 px369jgnu8QNA==
Message-ID: <sashiko-outbox-235616@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/3] mm: move the soft-dirty fallbacks up in pgtable.h
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivank Garg" <shivankg@amd.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Dev Jain" <dev.jain@arm.com>, "Zi Yan" <ziy@nvidia.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Barry Song" <baohua@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Usama Arif" <usama.arif@linux.dev>, "Kiryl
 Shutsemau" <kas@kernel.org>, "Peter Xu" <peterx@redhat.com>, "Shuah Khan" <shuah@kernel.org>,
 =?utf-8?b?TWljaGHFgiBNaXJvc8WCYXc=?= <emmir@google.com>, "Andrei Vagin" <avagin@gmail.com>, "Paul
 Gofman" <pgofman@codeweavers.com>, "Bharata B Rao" <bharata@amd.com>, "Daniel
 Wade" <danjwade95@gmail.com>, "Yin Tirui" <yintirui@gmail.com>, "Muhammad
 Usama Anjum" <usama.anjum@arm.com>
Cc: linux-mm@kvack.org
In-Reply-To: <20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c@amd.com>
References: <20261125-b4-mm-soft-dirty-fixes-v1-0-538e3cdb618c@amd.com>
 <20261125-b4-mm-soft-dirty-fixes-v1-1-538e3cdb618c@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 26 Nov 2026 13:34:06 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 9C3C2100006
X-Stat-Signature: cxcmqzyihkeks1bh116th6xoppyinao3
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795700052-95225
X-HE-Meta: U2FsdGVkX194a+6S6FOzHkaYqkU9L/jPYTQ2KyA8ddveJsx5XbOX0geXa5lcGHl/VIiP4IClb2G9cnGVw/wT2Op1khnmQIHROHr0Rn+oZQmf3HAGJ5f/a7WaeJt5K4Bk/xvTkDNv9YtNvY14XJAAiDJP4uUt2tHkWBRRGh4UQhBAhS+0pZIUJKDo5x8N6Nh0HalKCdQZxy5aiIlPn7rejiB3Lo7pxygqO8R5oe67dPGqHAuqKY9q5RJJgKut796rPgZxjqmRy8YbRx5pIt/48GgI3gT6JMzJ7rriXJEnP47YFAZztB/kYdmACP+/aD9XgUbE5qrSrDtA4z/PE4jvCdQzSKH8j0AMRoSmd7Gc8J2p20HlkIjrnedYVP24ulVNVCETWxyitxCp03P27dCoxBNlJCCxpvxdhCniQ5EnD25ohFefkjG9uHP/mvY5SN6TY+KRtK1miNLf9SbX7rcpvc5QqOT9SAN4p7Gb659cKt0h0HrVrCveyE/Wu1O112BTpA9xy8KUEwITTKG8MeWx6nERKe/T0Kc8Lqj6JH0Gi74wJVb1lb+7vykCS3eQGxgZuSudgZyzdAyrhNFIwuADCb2Dn0QuJH3b9D2wTok4D1eLDZzh1L+hcnlJd7Lda7ZY2ladRkXUQiuy6wLEklznKGVKNnna7tMI+Z+HyZvLjdMcLIpqyRyY/1khHe4YsBIOWB03ds7klPwNHO8isy82ziYEDX3qvKM11rCS4L1I9RzWVspPhfHz5mwvnnlJJL0pyR+3k+VjTkYZTbyPcRSbrvdIouH5DZ849YUeDEnQPeZVbzLFSngfK+fQWbyGkdWs3im+D2RYiJ6WZBhnR6UQ9HhWSZ9p/bqD4RrCDOWc8bh2xz/3H/3NoqWJf/H9gL/5vShfpP4mEhzO5mKb7n37q9/fZKOGFcIZGbVq03GrAWIb+z8MURYxxew/a3uU3Ui5UH4qGPCYi6PhdjiD2zj
 rDqIjURl
 PVSsErDdLeDr9iV+kbnPl1xcSAOU0QbalszYhJbgV/FUfWP3GZfE8IWr/qFlxxa66iS3jQFL3OXDtG2IUMDCMZXdeME7YZAZ9Y0zTpPyctoU9Rvsihee2/5IMkOXqZT0HFuPVqf3i9p+MeYl7lG1qd6WNjURr5PN8LVqwTo/PjtTsmhy1fORyx4T1KME6BX2f9s9GLp1XsNWoMoDWFNCtaSs18jiWBwtWC3a+1cgTp24ixeWmpeom8bxPtPML9Xddohc24NLhkDFuffphsaZlZNzOaZhstQs3Wenh3HrSSwJXtTI0W4e9nqK+U42eoggaXlM7Mxxd27dmXnIRaEGNrE9Z/CGOVr00Q8R5PS6F3HvSuYRI8m7VYqG7iDG/vAdgIZLaVdhOu6ZJl3J1gESgodUKtajEKxqFl2JhRUvfy91/MmTYASN3itHJSckQ3KtUmeceg7dlNn+At3Dx0BaIthrw8tTTz44/VJHGOpLT25/K8JCoCbpEYiEEpq6Un9fIAm3+mLF4Jw0wJex/t/01Mkw3f/MMkDAKCPztr57buU8l2UN+Q9+8hhSu/6oHOudYSRitPQurz3d5E5vT3/QgIq5YwTUu9KGqrN7Z8DM0ue15RsJbmKJ0DjNeICSpAIP1WrSyeifmZqNkWF/DajjLejiqC6mjhGY6lL64FVaJBgQl9RCLVbFsC2FnFaBWniHOe0W7xr3g78LIT7aloZBapdddweLS0+UKMoT/NVbkCeOAAwceSk2cdQwHHRXiEEHtyJYLfeF9AbN9IqC6jCS8qmWTZ3ZOnwEHK3WkT8AL6+EtITpK1NTco2J9Rg==
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
- [High] mm: moving soft-dirty fallbacks inside CONFIG_MMU breaks
  !CONFIG_MMU build
--

commit 9116ecffa5341d7e3fa2c316d20e584781fb40ea
Author: Shivank Garg <shivankg@amd.com>

mm: move the soft-dirty fallbacks up in pgtable.h

This commit moves pgtable_supports_soft_dirty() and the soft-dirty PTE/PMD
fallback helpers up in include/linux/pgtable.h so they precede
modify_prot_start_ptes().

> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 66d369870a740..b1db7aec5362f 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -194,6 +194,97 @@ static inline int pmd_dirty(pmd_t pmd)
>  }
>  #endif
> =20
> +/*
> + * Some platforms can customize the PTE soft-dirty bit making it unavail=
able
> + * even if the architecture provides the resource.
> + * Adding this API allows architectures to add their own checks for the
> + * devices on which the kernel is running.
> + * Note: When overriding it, please make sure the CONFIG_MEM_SOFT_DIRTY
> + * is part of this macro.
> + */
> +#ifndef pgtable_supports_soft_dirty
> +#define pgtable_supports_soft_dirty()	IS_ENABLED(CONFIG_MEM_SOFT_DIRTY)
> +#endif
> +
> +#ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
> +#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline pmd_t pmd_swp_mksoft_dirty(pmd_t pmd)
> +{
> +	return pmd;
> +}
> +
> +static inline int pmd_swp_soft_dirty(pmd_t pmd)
> +{
> +	return 0;
> +}
> +
> +static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
> +{
> +	return pmd;
> +}
> +#endif
> +#else /* !CONFIG_HAVE_ARCH_SOFT_DIRTY */
> +static inline int pte_soft_dirty(pte_t pte)
> +{
> +	return 0;
> +}
> +
> +static inline int pmd_soft_dirty(pmd_t pmd)
> +{
> +	return 0;
> +}

[Severity: High]
Does moving pgtable_supports_soft_dirty() and the soft-dirty fallbacks here
break !CONFIG_MMU builds?

These definitions were previously located after the #endif /* CONFIG_MMU */
guard near the bottom of include/linux/pgtable.h, and moving them here
places them inside the #ifdef CONFIG_MMU block.  However, callers compiled
on !CONFIG_MMU, such as vm_flags_init() in include/linux/mm.h (called by
do_mmap() in mm/nommu.c) and vma_soft_dirty_enabled(),
pmd_needs_soft_dirty_wp() and pte_needs_soft_dirty_wp() in mm/internal.h,
still reference pgtable_supports_soft_dirty(), pmd_soft_dirty() and
pte_soft_dirty() unconditionally.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261125-b4-mm-soft=
-dirty-fixes-v1-0-538e3cdb618c@amd.com?part=3D1

