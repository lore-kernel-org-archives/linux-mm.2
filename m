Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A82C624A5
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F65C6B008C; Mon, 31 Aug 2026 11:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180F36B0099; Mon, 31 Aug 2026 11:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04A1E6B009B; Mon, 31 Aug 2026 11:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D19816B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:35:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BFFC2C0133
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:35:45 +0000 (UTC)
X-FDA: 85161964650.16.5AD1B09
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id E42BF40013
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:35:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NiZ7OBLg;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788190544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dO5NARjIPnbddOZBqS6Mw077IVWkSrTQV6zN63iQdEw=;
	b=Nxf5eWGKAVfMeE7aRpRR85anfbA1MOaz5RSQnevVVU0UY2cbeVyitJZGBa6aRlnyBA9PVJ
	9yAr4Wosx8PM6RkWizWm+Ue9jDDFsbnYHbg620gVS6WwMDPscuj68lD6lukUYJLBHNrz0y
	yYNPZgTMsOcyAOvBeRpUZ2rzjQPfEnM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788190544;
	b=wEMx9cQrbTzmWEU3QHSzXuM4Kf/tbacD6vyEk9I8p4T5kS0zbtacgOCYwI4D73VIfKEZta
	OnGQykOVQoe37qKqEt37Bz2aN8v/B2O+acRZkvSckt6AUP5x4ah8iAnk3VNDlfN2+C9rZs
	BWsCxywcByPvxc+duYsQ1XhO321mDVs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=NiZ7OBLg;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F29315A1;
	Mon, 31 Aug 2026 08:35:39 -0700 (PDT)
Received: from [10.57.6.141] (unknown [10.57.6.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2598D3F882;
	Mon, 31 Aug 2026 08:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788190543; bh=dO5NARjIPnbddOZBqS6Mw077IVWkSrTQV6zN63iQdEw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NiZ7OBLg9FgNOdnwafeP8+TkHYvmSGkO090szXGMy+MnpplKYOpWuYI1HsHwzEF/T
	 aAL1/ib5Dn9d2tgjkf3EaC2Bnqm+69lSFSxVdYrBehQ+B5lYvj2Ku425wASs32W6/s
	 FyLaXKRQFipKixyjJCom9cJkBsrwl7/vgjh1lXL0=
Message-ID: <8264a299-139e-40ea-be84-3be06adea564@arm.com>
Date: Mon, 31 Aug 2026 17:35:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 00/25] pkeys-based page table hardening
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <apBy3nB3_GgBvYpB@e129823.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <apBy3nB3_GgBvYpB@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E42BF40013
X-Stat-Signature: 74rjjxm4fotirh6iptsuypgawifwwgfh
X-HE-Tag: 1788190543-65795
X-HE-Meta: U2FsdGVkX19gw8srWzsiqFIpiWiT2lx0yxcrFYlPNHxo37vU5rB9L6RFreNsM7nVEqjS20w0UbpWoQ9LwUC9oiMlcpVdiKAKmwkN1jLEBNLOzRjzpAr0dR8+YWzI8wnHm3Ypi4xCNlcetFDryTY2Rq5xha8ZExWFaUcDz7yOlMz46oKkjdix8ns5KCU4JvDM4tC+hfLm0BZZJGvqGkNvc1WZ1M0VqpP1B//28XsMYCmtVr+S1aCnqEL95Ja/nK429/FnXmEWJcbVonMpxArzUu7ytGD+aTSX340fKWofOlE2cW9NOh4J5pS9H/YiWMkTdYwIqbfaVsPvDj9IJ/g1ZHX5ZdqDal9WCjrk72cYnZftvYvzrc01ceazf4v6P7wPJv6ir0YzAJW/9VtdHLnBvcylKvbD23Gi2hBFDahbM2KA7MTZvtB6ObNYRNIKlWnZaBU3qvdk40SELwTuY+bfkCIvPmXh1F05Lx0pBd8SlD8bmfEqGo7dR0Kg01jl7TGhnu5jlnCITC1Nt5jDbBaZceBAKMYOVvDBGoMJ1wbyboSFBkdr889GzvI1eSdBtdFP723JJP9PjgdVo7zFKlXu2Km9fcc8Z5K9viZbc3mjj1asb/zxi0lZ1ZpH2UrXwBMZ9bqb5qHas/3dD1esH+CsraYMEbMKA29rXNN/5pSDeHfMh/1i5BMKdRN6Zs+ytyALJOU98ZsqjKHe80+qQXE6a26NaeinSlKdrV12W8+S3klNO76Qj/p1snsvYIJYnIUuJPykYPQud430X2DBLCAJJ0cuZjGtFXLELfBYj0jcG0X+rB0Vj59HxtposcCzjw1z0ZvLS5RtUNMwBpZhhJPR42SVeiZOXoHh9NKLOXN3c6nLA0MuSSm7OdNS+vJj0eNcaAdmcWNoCMqDKvlCI/oixrKwxtALjfUY7r8HPbOv7j6jUjai38qrB7jmurUqlFqD3AYQYKRf8jb/ijWXNu7
 5ObEBfNU
 q6OYJptHfkqhkX4FWjC2TNNH4vN5+b7WDZfX4n+RWcgZXWlcn8j44mpHUK86I6vBwfSK4ZuAovzlj9/AlT4TmnBbmbcPh7V82JP75NrRIrabLDL6IyBFOEX6r/G3abABh+F9wHGXnavpZargCR/Ct627jjXCKNA1fxz9//CqHdEowTO+s3BjIdBhAG2lU/OoFfrqUft61mJVKwyTV7Ueu+am+Gl800Kz9PbarwvWnTl/XoQeJ5fWkLHjZGJI29XoOLxHJ462cM1OGybWCs4z5OnKsNSkOlyFx5TwE2QhnFqTZ4KPhFcWFmJk8RjdtyeLZIijQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27/08/2026 19:24, Yeoreum Yun wrote:
> This series looks good to me.
>
> Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

Thanks for the review! The series is (again) going to change quite a bit
in the next version, I'll apply your R-b on the patches that remain
mostly unchanged.

- Kevin

