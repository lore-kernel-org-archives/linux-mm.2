Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83EB7606A32C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DFmnj2WW
Received: by kanga.kvack.org (Postfix)
	id A3D296B05B2; Wed,  4 Nov 2026 02:56:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D40E6B05B3; Wed,  4 Nov 2026 02:56:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911936B05B4; Wed,  4 Nov 2026 02:56:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 799A96B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:56:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14C4DA82BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:56:47 +0000 (UTC)
X-FDA: 85396680054.15.31D79B2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 285001C0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:56:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFmnj2WW;
	spf=pass (imf18.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793779005;
	b=w8JoJ9S5rTz6MK0prf8S7w3QfImzfqdS93H0+bIy0e8+JKfXGgbyn6LyXS8r1ePsulWQg/
	AUYICB9lKPjyY89ygfExNm7/pfJnCKBCGItO7moSPDtwRXEO04lAShma9DNF0TahXmcPe1
	AJvGu+OIJbjm4uAUCMr/agoI7pPDKww=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DFmnj2WW;
	spf=pass (imf18.hostedemail.com: domain of chenhuacai@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chenhuacai@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793779005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNu4ods6c1120leIpzJBlK6eHIivapUdba0o3Dpccdc=;
	b=O8w7KlXusC50Sz++zw2Zfrh/Btv64VElLClW2dpfjKZVkWkyGAXnqVXi8GoFXvfRNY5Upv
	wfl68vVjaWTIkyWZBAKyoupFLYp9NUzreDkP0PC4wl98kaUKmCpE7COFugPJ0sxsLM+ui7
	kXlb/sJ1YJk9lpWZ3VSRezqqlpVNhuw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49A5F602D3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F36521F00A1B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793779004;
	bh=HNu4ods6c1120leIpzJBlK6eHIivapUdba0o3Dpccdc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DFmnj2WWlx1KGTZnjuTb/vCvUWyc0mm4TI3ehJDrodtFIapozJZBIu79Texq57Qy7
	 CSHjMgKAwY+6sTExq+bwiXe7uDxBxl/9HBCTjQUIr6gX1aj8CQP4HAOYthnWViqYeS
	 2vYOqpAJVr74c94e7J3LkvAdDn0rI8dwQ4VuHKoQV7uSI8T6ag2uI15/5s2RT+XNGB
	 veBzJZ1mNOBldMY3OrrqcAxI2NGipVZdlj9VJpXd5b371UcZTUtaTpx3JZOCMnXYKo
	 Kor9aPRhoi+oo6UWtamL/pIZQwKBdDh9p3tPQq4Uy7Xk6nTsFelARkyIS9VCptvJ0F
	 7nlMLL37Y4TiQ==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6ae14eecc64so431466a12.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 23:56:43 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwdO8FwFdFKdEo1nfE5LteO4F/uQYF5dF8jj47++hYNAdVGDGv0Jy/Ohflz0Haewom1X1S6AUnhiQ==@kvack.org
X-Gm-Message-State: APuU4Z8eeH4BKQ8tDOt03JK7m8HG5YBMYiG8d62O4SbnkCcB1OW3//Tl
	Eybcfg22T8ocoh1I3vCsOFFJ+gXDCEZ4+e3bw+nJ9R18h00ZHxpXbCUUr2Vgrh8leZv9UzyK7aB
	/HMSSnMT2893gaBT3ZBu8HXk3orJOZhw=
X-Received: by 2002:aa7:d386:0:b0:6b3:c422:9257 with SMTP id
 4fb4d7f45d1cf-6b4d4d7c182mr7792710a12.25.1793779002538; Tue, 03 Nov 2026
 23:56:42 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261104071858.757793-1-songmuchun@bytedance.com>
In-Reply-To: <20261104071858.757793-1-songmuchun@bytedance.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 4 Nov 2026 15:56:30 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5iiGZEqf_W2KmtfdqYaKY1HmeK+ZdSz1t+epAhY=X+0A@mail.gmail.com>
X-Gm-Features: AclHuK93_XxdZekUa7K7uSHByhrComWPKbTc4AurJlwH-qxA4RI5N514mVEKT4Y
Message-ID: <CAAhV-H5iiGZEqf_W2KmtfdqYaKY1HmeK+ZdSz1t+epAhY=X+0A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/hugetlb: fix validation of unsupported HugeTLB orders
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Sashiko <sashiko-bot@kernel.org>, linux-mm@kvack.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 285001C0006
X-Stat-Signature: qufk6ay48pi1k13ce9tnqrzn7ktcdrnz
X-Rspam-User: 
X-HE-Tag: 1793779005-815053
X-HE-Meta: U2FsdGVkX1/F/3wVpRvP9fLSKVUTPKXfF4hQ3qKVPzfnIz/0Bl5lllfDiBkH5UXeP/Inz+FOLGEG46rMOWBTZzd8PcgVejMeNEdND3HRqptLS+uZIFDEl8xSzMB/wzv8d3L/xg8/ujGr0eT6yVvAFwLs6PcGT3tH/L1GTQlicSTIUpYdzJAzTAZn1nnbDmWXtGTIdspDTPsfdhvOdZkAIBerHe3zz3GeGPZAkgktMaF5HloOkrk0zJ2m98hvxRNTVDGfLZ0zRHt7W5mh27yleKDvu9JVWwiZwSEG6dy8542Ah6yvlRi/4V4Ltv0Uhu1gkaJCUbcOVLWflRenjDj1nuyr5wp+WPspdgltzxmQucG9fknEm9S4eiUlXdMhblQfDptPUiYYyNRs+lvdldnIBHnn1HLj26wvk5JD4GO+MUrZA9W+iNtWl6kdNN4WjoHxzWao4tWAR3f/d5Tzg1Il59mwBYY8SPKM8VNVdw89cUjWm5iB725Peg2vgvZGjE+QpNOCCv67RPZes/1a3N49xEh5QEq1QWyMkzCrNC2HzozV0w2Zpkdzkbw2JRtfpSpRkhKg1eg3qENMAQB/lzAuPs3VXHN23G/y5s/1hFP4U0p8HMTZpebrUTEReIWtQj+zbG5Iu7Dal9cmp0g+6wF0RxSlR4MxDnSs7k11iYV+zLeHDFIrRGX7EQwV5wn+g/nR1zLX2awuyx+VqPXPnxHc2KP8TRHg7HcIoC9LGQcq6g60Od2PyACo1XQaM+05zeX6MJrhQ4r0KmCDdVs+G9WgOgh+Qwc10vsksibaiXIJfyjKYdTBNLu/0HVEK0eJcX1QfSvgtBOxHUbrXhVVMbfRRUXTix9T34w2zizb06GiupbrXqaNwv3TXOrAdvSDBBbRPBOJdYaEtSms9FejpOKvAL6HRaxuEgr/R1TJcekdcSCJYLb3e9ZD/L3I9m3hrfromCcS9F7peDFVMMAiKrI
 Alr1CNuT
 Q40CVq97HWEkpaSeVnk7qURhaocxRx+2NpRz1evpRrSREZEzwSUK1TDai2tU3SkCLiCk4gUJDv9cPYY2Um05BcNxeOE5z9eSObuD/yW9pK6sk41h0kAHOyJBwzL/VTtf7piwqKfs4D3S+uufUAUI1QaVXc9ssLfIjdMUlFOS0coaAwitT4rSH5KPOvxDfFDdP8qkHhilvslaso9Mx5x1aBtMDzYO5gTTsx+0PRcrmuinEjOMJ2IORp+4PdUTpSW5iT8j84gxvvbv+fiYO7WroALc7o1xaefnzTcIRQVHaUNPbStIQkdzAPuSdd4VTaVDBZHuumIKapUZ+gbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 3:19=E2=80=AFPM Muchun Song <songmuchun@bytedance.co=
m> wrote:
>
> Commit 7ce6048d3a7d ("loongarch: drop ranges for definition of
> ARCH_FORCE_MAX_ORDER") removed the ARCH_FORCE_MAX_ORDER ranges for
> LoongArch. Besides dropping unreasonable upper limits, this allowed
> values below the architecture defaults.
>
> With 16KB pages, LoongArch defaults ARCH_FORCE_MAX_ORDER to 11,
> matching HUGETLB_PAGE_ORDER. Forcing it to 10 while enabling HugeTLB
> permits order-11 HugeTLB folios even though MAX_FOLIO_ORDER is 10.
> LoongArch does not select ARCH_HAS_GIGANTIC_PAGE, so this violates the
> generic MM assumption that folios cannot exceed MAX_PAGE_ORDER.
>
> This invalid configuration is accepted by Kconfig.
> BUILD_BUG_ON_INVALID() does not reject it either because it only checks
> whether the expression is valid and never evaluates the comparison.
> Detection is left to the runtime warning in hugetlb_add_hstate(), after
> earlier boot paths may already have used the invalid configuration.
>
> When an invalid HugeTLB order can be identified at build time, reject it
> there. Otherwise, reject it at runtime before the mismatch propagates
> further. Use MAYBE_BUILD_BUG_ON() so constant violations fail the build
> while dynamically determined orders are checked at runtime.
>
> Fixes: 7ce6048d3a7d ("loongarch: drop ranges for definition of ARCH_FORCE=
_MAX_ORDER")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-192874@kernel.org/
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Suggested-by: Huacai Chen <chenhuacai@kernel.org>

Reviewed-by: Huacai Chen <chenhuacai@kernel.org>

> ---
> v2:
> - Move the order check after hugepages_supported() to avoid a false
>   PowerPC BUG_ON() (suggested by Sashiko)
> ---
>  mm/hugetlb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 779b1de33c78..b49130eb7ad8 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4197,7 +4197,6 @@ static int __init hugetlb_init(void)
>
>         BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>                         __NR_HPAGEFLAGS);
> -       BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>
>         if (!hugepages_supported()) {
>                 if (hugetlb_max_hstate || default_hstate_max_huge_pages)
> @@ -4205,6 +4204,8 @@ static int __init hugetlb_init(void)
>                 return 0;
>         }
>
> +       MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
> +
>         /*
>          * Make sure HPAGE_SIZE (HUGETLB_PAGE_ORDER) hstate exists.  Some
>          * architectures depend on setup being done here.
>
> base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
> --
> 2.54.0
>

