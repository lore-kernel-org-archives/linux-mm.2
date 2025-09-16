Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A3D5CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:52:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C38D8E0006; Tue, 16 Sep 2025 10:52:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773E38E0002; Tue, 16 Sep 2025 10:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 662B38E0006; Tue, 16 Sep 2025 10:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 51DD18E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:52:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF18E1401F0
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:52:12 +0000 (UTC)
X-FDA: 83895403704.23.9FC2466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4A235140002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:52:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3jMv2cp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758034331; a=rsa-sha256;
	cv=none;
	b=XiUnZqpMf3s9sP2qxiXgZOfbzruYGkHclfW2H96oMoiH9FtwuTNc9rRrANQI810uEpv3IY
	4Ydd//RayTuIwN9NDcYx1XcyTR5CfpMzchVaipIj7eSdjFem8lk5FzLS1Zn2PmgXYNma+N
	tLraHBtyTlQXqKWObJ6sfEyjQkWJF1Y=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t3jMv2cp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758034331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ibGBgeNBvWY5S85vCt3WE69YwmMbn65Qdt6TTcBcO8=;
	b=5j/y3dajZolAZt5h5ZM1JHq78JdJWGP0FI39vrMFq/7zeGTVpFcDXm0cVmjL0tMb8mZzHQ
	MJ/jlM9Ls79qiOqhWTVmqhS8AZKtIRuVQWf743CB5zFmmUt/GyqG0+ZqCIc1Mx64SmeajE
	WDJuou9Ozxz/ey0YDVkkEO9WX6uy6Ic=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19D5C447F2;
	Tue, 16 Sep 2025 14:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED19CC4CEEB;
	Tue, 16 Sep 2025 14:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758034330;
	bh=i8NtzmKVeK0CBqBApTYTm3iAf9ez5i62j0SbReGfb7c=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=t3jMv2cpq05jLr5mya8gnqY0LdWfZKH172NqGWZsUQV450OQ7MSecKK/BvQvPsF61
	 +wRfIMDMNu5N52JqAVHgKcJg+2qotenh8Q40u6DpJOiuUnYo86PyubV2WqMSegeBGj
	 /7EIp+/ORtdmETQpkePK3TluVJdEAbAnGdEnNUEoujU0XWKotd4E5E3BzaT5jVeLRq
	 q6m3409DAFi74aePUAzsstLsPnsK+X1OW8V6f3ZUuR0xqUr7IONdQTxe9jWgDC7QYY
	 i4xftMwQ9c57QB47kUCFlPqzeB9DyhXXjJvbEhIrpy8e9Z0pEWN0Zw4oGK9g15NxcR
	 PlII1l1WkPEiA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Pratyush Yadav
 <me@yadavpratyush.com>,  Matthew Wilcox <willy@infradead.org>,  Alexander
 Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,  Changyuan Lyu
 <changyuanl@google.com>,  Andrew Morton <akpm@linux-foundation.org>,
  Baoquan He <bhe@redhat.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Chris Li <chrisl@kernel.org>,  Jason Miu <jasonmiu@google.com>,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org
Subject: Re: [PATCH] kho: make sure folio being restored is actually from KHO
In-Reply-To: <20250916132759.GC1086830@nvidia.com>
References: <20250910153443.95049-1-pratyush@kernel.org>
	<aMGc-ExhkqwAyY_C@casper.infradead.org>
	<mafs08qimjoez.fsf@yadavpratyush.com> <20250910155546.GB922064@nvidia.com>
	<mafs0zfauh6to.fsf@kernel.org> <20250916132759.GC1086830@nvidia.com>
Date: Tue, 16 Sep 2025 16:52:06 +0200
Message-ID: <mafs0ldmeh2ll.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A235140002
X-Stat-Signature: uw6z4tibsx9ypoyhy9jpnajha31j9rah
X-Rspam-User: 
X-HE-Tag: 1758034331-325986
X-HE-Meta: U2FsdGVkX1/5mAm6GYLslX6LV0fcj7dlD8vFrvlZwzXc4IzMyXbZIycSEhh9nrsD6pnwQysB0n2MnBWZiBAa3BElYqOliwcmAjJ6LuNOKfdGWLl2dBlqCgJpRCH+uaN/wffidEnh4Xk16UZd1AV9qB4LcvZFoIPtK5M762DzggPab87LgniEvTS/weJO13BMjuW0G/FkdKvV3t10HimGu6sIiXcJ/xMlrSOeGUgKIOqEYved9pWrqRMR4EjQmzG4nFP1Uh2rwpkAhoLZfM4vAJDymtQ20mL4NhgZ7d8eeoe4OvnhdTeFchwBScNfqfE1VzVEd5gfQ9+bHb6z1tfGIwBA0WEqm2YiyzqBtFlZHTsYd8kblBAyES34W8BEkjSZPVGmwlg+WNki5cHoM+Yb4jsWSsN1zfsYml6+oIYE/UXT7/1SOd5QMGPDSHiqXofCXBnOOH7cRF8jyY+5u6EtLpIOGrTqaklJ1AQMMAjRW/4UMmDLILWGJifLm2Itelv7AaJgAd8XhSBJ2Itmfk/PILenhQgeHyY/484dUIIaQx+2gmzAjJuzpPzq6ALRS3XxYmG7wJ/S4Av4PAD0TmviiUciYfXO2CMxc5YhO2B1MlqN9bgm17+160/3UiUOjU1+gbnKNluNv34zhtu5e8podPXFB6p2BRJdXQLjtDH6HXkHjkhedaWydKjASlUibSJOx+3gvlPbpdG/SI1C5mbpdR9hH6fppLQZi6SDsTr0yGwTSBPdfS146YWDH8c2EGUy0X0Vzj+cekT3oXi49+lphEqUXUVPBkYDKOau5vNHnvgfa+QGeS3qB9m+6GzeHdxCUSr7iIL3eqzhcPmgdJJ6gSW/exa1pggPbwCim0TOMTC/hHie6UDf04503nOrV8IUqb9ZuLltkA/qt05Xgb0HEiIEtuO16eB6Yu3sr3J3vPcdB8ZvL3kvPVpumi/oBgnm8qk6Aa/DxsEyTa02/Lw
 18D4XvTP
 KThcXJSjmNMM+iU3dMc08aWFi3L6ZoIkE4Vtw9xOxH/CyyqVcUZvym9qUs6STSTGC2ItIzVaqcogMYZTawcVVX/aQcTxBgdxZOhgM98ryGA4y34a7uCCvt2l9pQXGoNHa0mmogz1LEXw2Mc00WxO38gBd0IaX4DRjJpHPY02dGHCAVrg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16 2025, Jason Gunthorpe wrote:

> On Tue, Sep 16, 2025 at 03:20:51PM +0200, Pratyush Yadav wrote:
>> >> >> @@ -210,16 +226,16 @@ static void kho_restore_page(struct page *page, unsigned int order)
>> >> >>  struct folio *kho_restore_folio(phys_addr_t phys)
>> >> >>  {
>> >> >>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
>> >> >> -	unsigned long order;
>> >> >> +	union kho_page_info info;
>> >> >>  
>> >> >>  	if (!page)
>> >> >>  		return NULL;
>> >> >>  
>> >> >> -	order = page->private;
>> >> >> -	if (order > MAX_PAGE_ORDER)
>> >> >> +	info.page_private = page->private;
>> >> >> +	if (info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER)
>> >
>> > All the impossible checks shoudl be WARN_ON()
>> 
>> The mental model I have is that the place that introduced the
>> "impossible" situation should get the WARN(). So for an incorrect phys
>> address (leading to magic mismatch) or incorrect order (say preserved
>> big range using kho_preserve_phys() and restoring it using
>> kho_restore_folio()), the caller is responsible so it should do the
>> WARN(). Does that make sense?
>
> Callers should not pass illegal phys here, WARN at this point is
> appropriate, and maybe under a debug #ifdef or something like that.
>
> This is to make it clear that "test and fail" is not an acceptable way
> to use this API.

Okay, makes sense. Will add.

>
>> Actually, on another look, this patch implicitly makes sure that
>> unaligned phys always fails. This is because deserialize_bitmap() only
>> sets the magic on the head page which is always aligned by the order.
>> For any unaligned phys, the magic will not match.
>
> Makes sense, maybe a comment?

Will do.

>
>> Makes sense. Do you suggest the magic and order checks to also be under
>> KHO_DEBUG, or should they always be done? I am of the opinion that it
>> makes sense to do them always, but I can also understand the argument
>> for disabling them in production for better performance.
>
> I'm ambivalent :)
>
> For now I'd do it always and leave some debug optimization to a future
> project.

Sounds good. Will add them as always for now.

-- 
Regards,
Pratyush Yadav

