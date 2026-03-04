Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985F8EF8FF5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAF6D6B0088; Wed,  4 Mar 2026 10:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5CA36B008C; Wed,  4 Mar 2026 10:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68866B0096; Wed,  4 Mar 2026 10:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B28426B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:25:52 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D1DB1A05B1
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:25:52 +0000 (UTC)
X-FDA: 84508755744.28.D7FE181
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6AA8440008
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:25:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DRhtYCgk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772637950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dHp9bCxpQGcBk9L8T5sP4H/+YcADHb57HQaohzDaCM=;
	b=gGNaM/G6mAnRNYidSWbr59zk12LFSZANM9N9+kQ0VMPwv6OicwZ5Qn/mHwOLeJOiRmQxov
	jsUlWF/OWKz6gxK+XJFzQoWZc8ViDBJuRd3GU0lkLX+hsOrv4S5XUPyCEOY260u48oN3+f
	6GeT5EzZW/RHyI+8AC1GrGjUjq2BRuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772637950; a=rsa-sha256;
	cv=none;
	b=xER3kkHgkGQaHbFTsCSsIT3e76n3GYW9pGMqmRQvd9lVUzxjKKwEvASm/0C+mOY/bfCr71
	C+ZHKdhigHoYhlq9qjXy5GJQji+LYgiiVcn0U0MaOpD8KULcVGrCZObotSQvqfU80HNrUZ
	Yzek32aDHK9QxKCDmwAr4umHo+FVdk8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DRhtYCgk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7d4b9c839b1so3627724a34.1
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 07:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772637949; x=1773242749; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0dHp9bCxpQGcBk9L8T5sP4H/+YcADHb57HQaohzDaCM=;
        b=DRhtYCgkZ6wlhZQGbSewRv5NlBDgw9D6oe01ucnLB6wi4ZKT1boqFJN0jsZcHX5Xp1
         zIrB2uOHk7848BZzKplP/qOZbbtsJC//9UwDVMpZQqrLB+vbmwxD4xqiZA3KsgMn3nm3
         ef5G2F1sHKaGdgRIVXXebkJJYloyi7/FHCWkwUdQjobF6NOIrv2Our+dlxIz2q809sli
         zRxQ6ewFc76VIUFrGz4/ZS5Os5Ix/FsWx0lpRfRiwNz8kTwK9sdQz5Ghh+zvEiwEmtiQ
         V9R7zRc92J8We/Bpo2mWcyxtJ3vRp7ah7p+/daXcEwJ4kWOB6zUUw/ZHZlmcnZIEZWz4
         d2SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772637949; x=1773242749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0dHp9bCxpQGcBk9L8T5sP4H/+YcADHb57HQaohzDaCM=;
        b=tiE3cE93YHQ2tMVALnRUY7BsSBvH4Zl/SnUtPgze4xwr4tc5LrSib/gTeoq924HIAn
         YnBhw1x2H6hqfHnxt2GLrq9WNEtx9wNzCzmgG/zGgAX8TW8vEWq5hwx/6RUS4o5gYXrg
         gUItRzluYjyEiwT4VZbq16sPIV9n0USzjHnBwxribjHNQOrkyW0yfOGHwHtduNEadZwj
         0iCTlkqasXN+6LyXJNnqxF+xC1MiaHA2JY55QBJTBUx0P0ezRyOCvZF7bJBQ3eTlVZsT
         wZObJGOgtBibV49d7n86/CEiTIBiDZ7wcnjcbq3A2wR6I/5zIHw3onFx/SfitZWar9hG
         zuIg==
X-Forwarded-Encrypted: i=1; AJvYcCX5epy4WUIkjD3RACOpmqMrIcIo7viinskOVc0n7P7aB0guiRdg1xCWXpWaIAFO5XZtByYqe2571Q==@kvack.org
X-Gm-Message-State: AOJu0YzfvSzmbwS+pYrlrhVkqa9ScK88QyFNU8foIkNHZKd2M8YgesYn
	WlqA1yFTVJpb85JY6Zkznlq0tAE/e9fLF8sG8c2Q7W99lIhDpeDnRCMv
X-Gm-Gg: ATEYQzyWD2C6E0cqiaOo3LSWtL6VASWHmLuBIlK4QzkldpyblmwU9NDVYeThJ5Wfp9t
	lNi0a0psdvfOnKSXVbzcVbVT3trZuCuYu6qLPddULRgtTtmrx0sg/4yhZSwLNkMgs65UVhYcD8P
	2ZqpOUyipdp4DbKz7xXoPhnH44PCRQv2cjy6R6tygLVnsUmI0fL8DwYy0DhsZ04dfHvZJOufHOC
	EjzwzLlr91HBjCfJMIM953Nhk8PORhdHKc/QzXW5vjHPlRqqKQt5McBAY2oMjQQYFPVPBLfgY1h
	CCJ9Ue48oiZCx48bUPtObq/rVb7KrB4rkPyxkrYxjds+Ry+1F5kKGmQL1cDD+GfYhdw3sWcbPZP
	aEU5WY6fkt+DbB6O1nywB0uH64RQ/D8LgBbiWSYDsFXndNWdLLCdIcGYujkF79Z/GDyYokLqca2
	s6LQjSDn504hYxjeD15KDLBeqGRfjUQmc=
X-Received: by 2002:a05:6830:d09:b0:7cf:d1b7:96ca with SMTP id 46e09a7af769-7d6c7f4b450mr1231038a34.6.1772637949342;
        Wed, 04 Mar 2026 07:25:49 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:c::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d58644dd17sm15624459a34.5.2026.03.04.07.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 07:25:48 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [PATCH] mm/migrate_device: fix folio refcount leak on folio_split_unmapped failure
Date: Wed,  4 Mar 2026 07:25:46 -0800
Message-ID: <20260304152546.3719551-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304120132.3973445-1-usamaarif642@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6AA8440008
X-Stat-Signature: 189hrzftdx8bq64y5zggugot85ibxg8w
X-Rspam-User: 
X-HE-Tag: 1772637950-644611
X-HE-Meta: U2FsdGVkX181TW8lUNSTd9u+3GrZFoh8u7xJm3ycEzp+7fkW6qsostekZlbUQ0g4sJtUB56AW7H6H4f4X5PvQXdMayN53sL/MRoqudxjx/IkVnQLlwGtaaYGWy4rbjGS+h2aS4psWJZKre4r87qEYsrOzyvSBG6RNoYKrpaBC8K0JXXx5c89cDMJcp4cq0e8e+sT1oSe0STZsX/hLafkeZFUUuI88JcQGf02UzP0L6XizAAyp4KmNGWt76yQpcTOJMbw6+E3NPRvJqJwN0eNXGzU3t425jtKaiVWLzbhwMlT2F1dJBoPhgfI/mJLA0pdGTBenGdpWgYRcBuk3FTLrqXqWU0IMze0VsyrquC+Jun5MgDQjw4gyx7PaUX/oum68NBWj1ErbomI2z7gP9wmy8RlOqJqTiyXJfL3CwQ5exCqnKc0WeoPycyCGV8Eh6EHpDT954KA16hNZUg1+Xg5zrii/ZpKJyC7glEASXDivoQIr+I6wC7uY1+/h6oNXofOTP+VYxKepQfSs7VoLodMan9bPH4AG5c+HHQrp1hXCTBwnqAQ4i1W8ra8biGxvYvj7PZI+Y+1z361uPKNQrFhTAc90JALBfbUvxK7pWDVGJZsji3KWdk6nBvQTfQlhpTPUkujNjvak1CNQFnWLYB3HbXCTcH1OURbuvymZYQvFiDoqkRyfbJzqEjrF4+6dlaLD/41godFPsP5/sJuLbg5ZAeV2oGdwOhliB6koVUXY/dh4DWFK1nGjx5bJDDDDsP0StH5ZbL5jkZvgV44C9lSZNyVceHsyLL7A/q2i/QjLjeOXgUvrGbpkE3NJAPlU6l7P4FN7L9xXIERoLCeh4RzuxhtksaE6ReQ3JUzsrP8BG8Tu/k0Ebj9mov8PLgBT46F+Y+TaZ4RZCvxZEUVZ54/lhI2mLegINkak5mEJJ6s7X9ylt9If/3A0Racy7dkfpDxR0MbXcYEUhW/PA3hSL9
 WxQz1SV1
 3KdpqxlH2cTtOyVPreJVbWumOTpwrgqT7hJUFZYzKxrGyBkMBOW7tTUbZsYQuQCtFegu/87APV0AVXZSOxm//2MyZkiMonD699enc5Bz8ntIK/AzXtjIbqVZNEAUp72ogQFdtvIRYTdTri2zNl3dR0gxB/8Orw1NMKL0oqC0sTsZql2p8T2gX4/TRiZO0jvRc+5jSi357aWT33I5XFPXVoeA43GTp6mAqHbtO1LDjIfPEeJ98tAdtzXn9I4pYvpq8waqcj5/sBX8Zs6KkW+qyIdiBSc5DpdHrPGcrW4cSnHrJXTdM21I3nQb8xuAWxc8TUJMTWS6ctDypeYeg5N7rpbSewUgRyruDBdKr+kIMNh2iy+AGZcCOGYNG7jT3S+Pg0Qq5igN92S3d84fxVAYXnDLXd7dkjRvE+mAhLU3L8riqTrknVgF1tbRw4ymHo/CpZ407ZM78owXk21QC65Ih8Yek5tPHscPUO/nq6qa9zwLNlT/Urafc10u7I2JGvxdpoQkhk+X0oRLzVgcCWAlzyJbAbqft5SlYZwQNt4o+hx4mX7ltpJbkF86o+Jx0+vLEox6a7sSx85jK7GBETrOCZS98eB/P4cLZFrbPStSMRem4gLrNj5109K9SyXN49FhtsoK8m9DGIrqSQkJj7mjFwr0HSvsdWd9DQuiw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Mar 2026 04:01:32 -0800 Usama Arif <usamaarif642@gmail.com> wrote:

> From: Usama Arif <usama.arif@linux.dev>
> 
> migrate_vma_split_unmapped_folio() takes an extra reference via
> folio_get() before calling folio_split_unmapped().  On success, the
> split consumes this reference: __folio_freeze_and_split_unmapped()
> expects the +1 in its folio_ref_freeze() check, and distributes it
> across the resulting sub-folios via folio_ref_unfreeze(...+1), which
> are later balanced by folio_put() calls in __migrate_device_finalize().
> 
> If folio_split_unmapped() fails (e.g., unexpected pinning returns
> -EAGAIN), the function returns without calling folio_put().  The extra
> reference is never released.
> 
> Add the missing folio_put() on the error path.

Agreed with Kiryl that maybe there is an opportunity to do additional
cleanup. But as a fix for the issue, I think that this patch looks good
to me. We can send a follow-up patch in the future if we want to
clean this area up : -)

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

> Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
> Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
> Reported-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 0a8b31939640f..351ecd9065d13 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  	folio_get(folio);
>  	split_huge_pmd_address(migrate->vma, addr, true);
>  	ret = folio_split_unmapped(folio, 0);
> -	if (ret)
> +	if (ret) {
> +		folio_put(folio);
>  		return ret;
> +	}
>  	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
>  	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
>  	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
> -- 
> 2.47.3

