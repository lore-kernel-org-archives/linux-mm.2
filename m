Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E441C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8AB6B0099; Wed,  9 Sep 2026 10:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9476B009B; Wed,  9 Sep 2026 10:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6936B009D; Wed,  9 Sep 2026 10:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54D8E6B0099
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:01:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A2011C18FD
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:16 +0000 (UTC)
X-FDA: 85194385752.23.4AEE292
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id A54AD14001C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:01:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cTCDZr6Z;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZqGD6+EIHmen/yXXRwBLkUFq1BO6jBImOTP5fEBlNDw=;
	b=7pLyryDptx/xsCL0lq0GGc6LsyrDYsn817WYWTTZzqmb1g6bfzaVOZ8TR3u5Is/qTYhzxp
	klzxzmp8vlu9/jL/AGNKQjMh768I5VWjdA9fPdhm/N6TTsxroYQaDnrUHtwqNY6Tfd0CyC
	MbVjW6KkOT+aBXdhxj4H9Vx+qDaIYBQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cTCDZr6Z;
	spf=pass (imf26.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962474;
	b=sumUzDHc+kUIDZyuXgXhINchjgJh9UMD8zQOov6+EySset43PB4Y/NqOhUj8rc7lcSrqxw
	tBkVvc4x/6tbJ9eQW/ba4f7sEeL8Rn9yWFAMxs7Hhul0vJc7ZuuUiUbv+wxGjhhAJrxVEy
	yEfM201YGfSUzK7t4LKQ3RmZicA45Kc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZqGD6+EIHmen/yXXRwBLkUFq1BO6jBImOTP5fEBlNDw=; b=cTCDZr6ZCnhsx+vTe2Bu439RDN
	zgmXwoq1tVj2rx1oPZhMrSaFompcN5ZiFJdN/lhLCVc6R5T3U/Utt6CUPXc2qguLiC9jxT+VCRK/F
	U3ncOktFQ9HN+NnyyZ2Y71JQr6LSiFDnT8eLQMzOY+g97udoqNxU3Fjkl8/RX0cwOuFk45/Cl2qcu
	J+drc+sx7Y2+76t/NIr7LdQcnx66ZNjf3vXefaNaYQXDTvp4kor32JZGM20hxOsmjbCdHPvyiR5XX
	2GFIhX2leHw0/Vg/YI7PM1Vmbtf7uRgGps32nBAS2NlQyuwr3fpCx4xgVi5FR/JZs92o3FEwfD2zb
	H3lcLMpQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x4Iqs-0036XE-0I;
	Wed, 09 Sep 2026 14:00:38 +0000
Date: Wed, 9 Sep 2026 07:00:30 -0700
From: Breno Leitao <leitao@debian.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ard Biesheuvel <ardb@kernel.org>, kas@kernel.org, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, "Liam R. Howlett" <liam@infradead.org>, x86@kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <brendan.jackman@linux.dev>, harry@kernel.org, 
	linux-efi@vger.kernel.org, riel@surriel.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kexec@lists.infradead.org, rmikey@meta.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqFmJao8Os0ySPjF@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <20260909131911.76D361F00A3A@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909131911.76D361F00A3A@smtp.kernel.org>
X-Debian-User: leitao
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A54AD14001C
X-Stat-Signature: 8ehcfukijxmh3djq71qgweusz3cenwrm
X-Rspam-User: 
X-HE-Tag: 1788962474-71766
X-HE-Meta: U2FsdGVkX19dtNuyO5o2Giq3XWAvnw6AHcnCL+a3m/ee5waqq9M/IolEjD/kq65is+pu/8i2g541ckrhIwUkOWawU8X8u+WlrcZbS8AVKaJ3/OL5xdX7D2rOjGEznjFoYO5zjWMsorm6AQMnxOcv/I9h5B751SbnV3d30D8KgsztVtstQYxp62IAVSJ2WTTCRgFrm/FO9p94gmVljKPiwAUtywI5TIiFbDykSb5mGs5n9rnA2pdEPOzqwl6psYPbeYyX4gASNQ8rC9IDVBIy+Rv9FCGCAldHCiyEj89FRVvru8unOb3Mh0EdrgPiCd8fQe3pLm/MGzKU1aEN8HyI7rCoH7lQIC5ZdShVNILuktB1bxLHsjmgxZh9TuDdwaU5OdWdwdhagKwa0zMQy2IQeLxrtsxXGyIJP6k9S+nhiv3tupQvVNIlx1udkBaFsZmcgh60u3Eq+Ky+ymp6eGBDR8Zihku4iim69ctxvU8Nk8a5ougWD33un6kG79iI34z0QpIWeej/XgafyAOIKIvGIUOJko7ilvicPL3XkDxa5+LHarSk5hLPe9JcUMlL5j55ddVRGZX514abeMe652ClC5KlH0uEKxMs8WsoJ1DZ9AmHn/07Axpj1T915mNt8t1+uh/yx1B818usDkVWGrkRAthTDmZv//n4FGIYKM/sx2SES6kRzcUbDIBqCC57N2HNJR9CbibKL2gfkKnRg5y9SaOAUo6dVuGQUnaQpItKdom3U5swEXKVr49vnupMbSZ3gufD7aSEKP2nMq8t2i8HgkKzXfJp3iRdCUCjdjAxxl8mnhP49Ge60VVp6/YZu/4gWBhg1IFMUkMyT3cNRVhcxEbwYNIP8mPiC3SMHxhzEZk/kz9FAQ2woUU6eIgMyErSjHeOjs2ZMHb9m2aUZaZBYy+KYO9Sdvfmjipl0XjtSzDjUrGUexqDVdhUjOI7bVY+O9obGq4+LBJOxxnBytd
 P2LN1I21
 yNrDyspD2kVWU4Q+EdFYCNtti3/ITFV8qbZyosEBg0D82XYsPWF0xa4/IYPK/zwr3ZbwwyDCry3c904trTPhEW2j01drw6ORVtE0+gcjj6kCuVOJ1Rm+JnISyVh1hrVxNPZRV5+csvZ2exCv0zGvcSK1lZ0YgcZTf2LXrQRjmX0TW/AHfxuTOHL5EV6dOB+lX7KmSRQWd6RGp+dnUB9JjH57xw6mWPvPrlJT3wHQtPerpp2+CmxqfnxfFtkU9hKYkkPO6YVBgXXgXRMFitCxOIkd7w9GwxD5pTUI5l5LlfmlSD/21VvZmeOEVPl0AHtNsFlOKEWt84SGI7TC7j8PCm0n/r7HCQ4bxHM/wjOjO6UfORekdttKH/k9s0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 01:19:11PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [Critical] Integer truncation in efi_poison_alloc leads to a massive heap buffer overflow during memset on 32-bit or mixed-mode systems.
> --
> 
> commit 626632820fe1fdcddc73aaeb109705cbddc9828c
> Author: Breno Leitao <leitao@debian.org>
> Subject: mm/memory-failure: libstub: install the poisoned-memory EFI table
> 
> This patch introduces functionality in the EFI stub to create and install a
> poisoned-memory EFI configuration table. It walks the UEFI memory map to find
> the RAM range and allocates a bitmap to track poisoned memory granules.
> 
> > diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
> > index 48f93f7758e9e..5cbe675491333 100644
> > --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
> > +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
> [ ... ]
> > +static struct linux_efi_poisoned_memory *efi_poison_alloc(u64 phys_base,
> > +							  u64 bitmap_size)
> > +{
> > +	struct linux_efi_poisoned_memory *pm;
> > +	efi_status_t status;
> > +
> > +	status = efi_bs_call(allocate_pool, EFI_ACPI_RECLAIM_MEMORY,
> > +			     sizeof(*pm) + bitmap_size, (void **)&pm);
> 
> [Severity: Critical]
> Could sizeof(*pm) + bitmap_size overflow 32 bits on 32-bit or mixed-mode
> systems?

This feature (EFI_POISONED_MEMORY) is only enabled on 32-bits system,
so, 32-bit issues is not a real issue. See very first patch:

	+config EFI_POISONED_MEMORY
	+	def_bool y
	+	depends on EFI_STUB && MEMORY_FAILURE && 64BIT

So, this is a false positive

