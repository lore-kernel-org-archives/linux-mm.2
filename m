Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A3BC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7943F6B008A; Tue,  8 Sep 2026 03:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744BA6B0092; Tue,  8 Sep 2026 03:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6338C6B0093; Tue,  8 Sep 2026 03:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3C2BF6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:12:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C9556C03EC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:12:44 +0000 (UTC)
X-FDA: 85189727448.20.12BB14C
Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id C3C82140006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:12:42 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pyARTjKr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788851562;
	b=BbMi7bs1JASYmsuroMNKQ0B+d3gtQ9o8J3UEurJi9Xq7PxHnTatmwTMPm4BjjGiqHQzBOp
	/UJ4ZvJ0QxY+ZFUj9djVtW1CkmCZ9T+bmujfgWO9haIkMtGq2+FEJBqduLPSXFFyg1jgPb
	hUfpqUyBLj40cvqKsZnQG7wYCpr6Kmg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pyARTjKr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.222.43 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788851562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qsLaUxYbGMpI4z4uQbUiwjTKmX/vPTtkRhbslycMFDU=;
	b=btpLF16uhOGQ0sdCLoazJ0m4aKmX/eMB9i9Eet82uZautd1Z0xP4X06Toj4VCVHwke4SBm
	c/JgwVIpMZj62nGP3occrsP+DxKN6sRLO7hLecsi/vXspLz2nhdP6KSwEaDG6+rEo1VtCm
	EgAL/opDrwn6cys2IrwBS41S8A1vH5M=
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-97cbbdfc2e0so1263413241.0
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 00:12:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788851562; cv=none;
        d=google.com; s=arc-20260327;
        b=ZItw25AdnKqJ59E2vRg+Qwqe74gsyCT1ZxJ1OGcxYFprqVZdo2khr4nYEIwcc1YKZ2
         Rhwve9NTPf1Adwcn5wKburAepVilZNGaEHF+2wp8SAsPBfc+WGit3BPshxr8H/MPpFcg
         Vn1ttdZDv/7H5n1CKxKxjukuxoA/2Y9cqNKiw/Rubl01qbrS6eJtVO+gBElRzQlSgGSL
         +3Y6D7qIX+g7xMz0qgTjtzuzQX5rAf0HPfH1HqS5mnm8NvxOogkEbENll9ze0OPWyGxl
         w8lwraqzNOKdlOV0Q7ngndh2w6sAjqZk1Q3lcEdZOoYtuHhoaJc5sdSHo6zM9RlIXeh/
         NEvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:references:in-reply-to:from
         :mime-version:dkim-signature;
        bh=qsLaUxYbGMpI4z4uQbUiwjTKmX/vPTtkRhbslycMFDU=;
        fh=DWwdbbU3O/AzXXOR/eMXERBWKAWjQEiFFeCAlB0+r4M=;
        b=ZKgWn+B7lRogrIfCs6SPuOvmYQjFnAucAZZcFSisVbwYDxfOvGQTBpAc4UECnGaSkX
         4v/ugFgkedjdygDwvPylJlggvCfUrbr72hNi3NsmKAPdc9q9TH0kLGNEALV3lEOPnFkS
         KaYuZW/Ma5K2YAcm2irZRn1xlWiQ8keKE1Gp6GV+fyJMPo1FNAww8oh3MSZ2SNOmVGEQ
         lvlFkZy9geM8cf3u/Ghf8knWILJeDFp4SVn1uBl1xgVun+DsXz5H/2xYPWDgQbZTIwVa
         eXODTRz4yrGzyxYK4/3Zde9/dslJyngryIPtX+1g4bsBtw7GogI/n0TAQ50EOk0xSDUg
         RAMg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788851562; x=1789456362; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qsLaUxYbGMpI4z4uQbUiwjTKmX/vPTtkRhbslycMFDU=;
        b=pyARTjKrOF0G1uZrG2SsI9/X1QSOBG045f+G2ze2FHZyry52Zom+yN3795HUCNlIVo
         sMfy2b9dbI7aLzXSCP0iP7lCFnPcghPU84fUJ8b6AtFIRkgoOGZZvrk4xnqN6yicsajG
         Leu/rgapdulwlIKyXpsvQuoOVMLTmCuKWxCXgVPBOaX9y70nlHajETzOGDNAEoUYhsr4
         HvTUWrzvy8nnAkrmOJbJeW7Z6ffP2feWhNj0fdvm7zu3tUUEhTVF8eQxFwj4hY6ZwaHH
         z9W4Wq+B61PYxK4nHz63v5kjmLzwv58fCF726P5HgklqjKaxgSVcNtnVIWYjsrcR2yx6
         +Ftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788851562; x=1789456362;
        h=content-type:cc:to:subject:message-id:date:references:in-reply-to
         :from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qsLaUxYbGMpI4z4uQbUiwjTKmX/vPTtkRhbslycMFDU=;
        b=JPDzJe24z92wEGq6Xyoi1Yh9xTJrH5+6hhl/RZ75rP+Zwc3j3HJNAZfLqGsl5lygot
         g3GK/mQgzyGM7nUPd0upv9gGEefM3bMYDVrKmXJhtA+OY2N+cHjYEWbltaDyXTVJJAik
         iO73/rcrdBlBT8o0EpJwf8rPqfMyCn21E3TtFsM1off72tqm9nRNWyGXGXP3YG5IgvnC
         +gHrGEBBB2S6WzEq4y3ix6sP3ZoFZCNXR2b84OY1j2DHw85ZJFUOlzrUNJY/4n0Lbv7a
         Luk9JOChzpRh9WybbyzQ4YE37IvHdI0TTZQlZDfNTN030OrNfAL88OJVt93ux2qp2q1l
         OA7Q==
X-Forwarded-Encrypted: i=1; AKwUvBxBQQ4iCN37Lmx2qfaq8uqWz82SMiWsGXbZfv1oZiprasaEhaM8XmLjAgm5c4eHG2AHwnxhrWGDKA==@kvack.org
X-Gm-Message-State: AFuF++mR6tcas3+AdyJLm1mTGaty0iZ2r8/77EbWLheEIqcc6ko2hVnz
	quUQ0fkrZPZtKscGURydrZ9fGTw4qnnuI0Ziz2XVeGB6jJgkdE1Husnzf/6CcYfDmSJuqLJtTM3
	FL5S2CF4pkicYlPkf60xIRXn/ICobuWo=
X-Gm-Gg: AYBFou39dWG8LdNxB7DK4jCvj9BxHJFsoDEI1y/CqkF5CfQhj5j9RHn+zyu1PcqvQFq
	H/0q9FAiHfVT1jEw3zAVgjzzOKsGoE6yXoYtkmHLKAReklyiDAytl3tR5Tr1eHqodvaNDt1T3QZ
	NRUnCMe+hXWfPX1zrXxbGHQbqPqkNU4J7WZa3593mVmV07Y31GjbU8tdfJaNhMrXY1LDmSvPSsL
	gGl5wRq6qtLOxgAKjqJrwYQTum4dEwps8hcchl0IgI6R8DBI5bDPtPHQ/lBRWwnd6Q92qlLbrqz
	R5pPCGNnz/k/ROHldM4Rr6N7eeA4CF3A+vcMi8xYlPQ4hTy1r2dfsA==
X-Received: by 2002:a05:6102:61db:20b0:78a:700c:ad84 with SMTP id
 ada2fe7eead31-78a700cc36fmr3564272137.9.1788851561548; Tue, 08 Sep 2026
 00:12:41 -0700 (PDT)
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 8 Sep 2026 02:12:39 -0500
Received: from 77377267392 named unknown by gmailapi.google.com with HTTPREST;
 Tue, 8 Sep 2026 07:12:14 +0000
MIME-Version: 1.0
Received: from 77377267392	named unknown	by gmailapi.google.com	with HTTPREST;
 Tue, 8 Sep 2026 08:49:32 +0200
From: Zhao Li <enderaoelyther@gmail.com>
In-Reply-To: <20260905193122.76f5d3245cd2e0603e7743b7@linux-foundation.org>
References: <20260427145247.84157-2-enderaoelyther@gmail.com>
 <20260428030712.66256-2-enderaoelyther@gmail.com> <20260428113037.88766-2-enderaoelyther@gmail.com>
 <20260905193122.76f5d3245cd2e0603e7743b7@linux-foundation.org>
Date: Tue, 8 Sep 2026 02:12:39 -0500
X-Gm-Features: AcwNN1XwTG0-VWWtLuCWHyxR5vlmphPm1tauraRmPLL5-TyLDFGlaKBhLxDmXoU
Message-ID: <CACHPgzxQ5ajoo3yrkXZgkmeDgOmOQTZxHpJcDc8P0GBRLvP8FQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/hugetlb: fix max-only subpool accounting on
 alloc_hugetlb_folio failure
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mawupeng1@huawei.com, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C3C82140006
X-Stat-Signature: aidxgwa6k9x8dka5ezjoi3fujoo9nm5i
X-Rspam-User: 
X-HE-Tag: 1788851562-209266
X-HE-Meta: U2FsdGVkX18xWiAqWo/mqS6t21O+OtZklg94Nk3mImqyNvAHLSCtYvKmVdkTUT4tQQJCXOmvDW28iuepsks7TBmaTAalrR2tt5se/2+mxiT618/ADm3MegIWKrETbYTdcPTZ4GoOk5Y6XMxI5RN3TgNyv0OCYB1yKa5DCGQ2YLPG4mUD0ivcHnJiflbHcet2N584FEHxvDvalEqmuT7Cr+b8b7pgpRgzsPj4lZ6SW3Wz6/9vPmMJyrgSTM3l33osMmxU5zDq5ksFLT3gkPWW4nYCFoUB9382p8+ZK1OvYZ1SCXFgmHuJJhWR6QniVbmGTzt4qRz8CPijIflexO/3oBhMxfQSgetlr2lyQTWLHoERgb3KhXmzfd66ZUKPeoSU4CW+dx9NliLV8GyNQhL12ZVawTlsmKkiYJPLgHWEgFmwSaZaPgNd5mNTxcHd0hATli3aNWPoe0f4NmmvBxB8ACtyN/k9VwXlLKAR+lrYmRbycI9ujHX/QdboXVeyur8xuyIC+l7inJofjUwQ6CKniFNaDNocrSB1Vk5/LjZLCJVP4pcoOWcTT6x4WRbRSQvtshKjnvNGnUTJusWKY4QVNQoKd+l3fosJDSUKnccWnqVkXKog5hpgLVRmXBg/WrUkiTu73r/Ds2cwOserR7NVvbomZlGii5IQ1kF2tKRJULX8z+oF0S0VydhnbyEeGWiWLcUBzOhenKW8Gj8flWab2ionTLazxf/1fp2YCaBuaTpUI2oqoEBvKMZ7OGmODEocQvbYRfYJ5C7YQ8J4089+WLohKVC1w7bnR+BImDR9R6M87PseYDTIHrK4/UA/R520ZvZk3asdu1yhbgNm/YnQvPAmIPnra+/PvH3uuu1JRmOB7eBXtBKj/UHTXSRKRfAQT0XHkWjk3k8TY/5WRGI2nMcmikBZod+K/YzMY9wdhNQ+xIXFvveGRzcZbP69+hkqclYhe/9AinmOu5Ouorj
 efhOy0fE
 3+yJgNU9oHTXdilDFG/OVNCKMvFhENWtCnUw4GwtoEvUgHK1C0iq0m1LaOkHa5FZZzS7H+W+bag/fRVnGG9DJadi7gSaUteK+Ww86oyqsLimIary9CQFh+BiRdoaC43VOW11H1WAGbFm0TqCgrJbFkJVd2AxlvAYW9Zr758wvxY2SbhQtEnUoU5nI7u1yU7mHlgZSZNA6hIPn/PS88jgBt+KHNal2xM8pKgqB6eN7D9HEdV0fyz8MhOR4yIXrCuEnpxfjG6kQ3jZn+Cn9bu1EAPwFdpb1sFfWhVN8X49l+byWU5VxtAYiPyOwol15zxjOsuFlzS477ht81v3O5hRmUZkyjuzLMF41f/s31U0OkgKybJTuiutUXK1eQvUQZSjWKb3rx7habENFgczQEd0bEObUA8vIMyygvFHGt/pTA1YE02Nxv/LCFSJnxt/sg5NlX7mb24gINxZH6BbDprtB/vQ07KZmP8Uh4Ltj5ajlkL4bpYwsox9idQn7cf5sqGyMUHFi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 5 Sep 2026 19:31:22 -0700, Andrew Morton wrote:
> I do like to see a clear statement of the user-visible effects of bugs
> when we fix them.  "subpool quota leak" sounds bad, but how does this
> visibly manifest?

Thanks for picking this up. The added description accurately captures
the max-only case.

The leftover used_hpages charge reduces the free space reported by
statfs(), so the mount can appear full despite having fewer allocated
huge pages than its configured size= limit. Later allocations can fail
with ENOSPC, or page faults can result in SIGBUS, even when huge pages
are available.

The patch leaves the min_size= reservation-accounting case unchanged.
I'll make the user-visible impact clearer in future patch descriptions.

Thanks,
Zhao

