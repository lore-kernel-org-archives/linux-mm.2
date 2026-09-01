Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0EBC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71FD06B0256; Tue,  1 Sep 2026 10:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682906B0258; Tue,  1 Sep 2026 10:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A3E6B0259; Tue,  1 Sep 2026 10:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2624D6B0256
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:33:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 288551203DF
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:33:45 +0000 (UTC)
X-FDA: 85165437210.16.A20C634
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 376FEC0010
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:33:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UYNM6X2z;
	spf=pass (imf28.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BfHpSlsVl9cURa/O0KVf77O7hpqdHfUCsyagMRcBk/g=;
	b=2hYUaXoorGvJwrqgK2zsnNKtnqUeU/l/n4/hbMrh4h/90BodODzl5sFIg1MXHPgnMzJT1b
	dc2tZNaf/hd06z59s5saeBVBzMjby6EzttbLcP8QbSO5SdIT2H//mCjea+GXCcAltnceW9
	OBlWg5ljR/8VmOD06XvXWU1SiBpoa2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273223;
	b=XrCymxdzsZv2AEhICccYfeREmO0yUs+ZlVaCsqS68wIhp+C/wP8SC4zEJHY5yzhhiVr1fa
	ftpCHJ7R/qhmrvvZ8J3YI3YrS9w/MCRJAlK+98D+p/6a0fL2nnxBpB+xeqL2FQIQw2BSxp
	cLyS64RGZ4wjtLW7m4JbO7AgGrFyu48=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UYNM6X2z;
	spf=pass (imf28.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B52B1756;
	Tue,  1 Sep 2026 07:33:38 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5BD543F882;
	Tue,  1 Sep 2026 07:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788273222; bh=1sptuKVyrN75yvJtA/uLN5QzLJtblY/b6d0mqfGbJNo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UYNM6X2zqA6tod+6SjIBW+v6Liwy/ak5LM2gfcF+mXgLfmpQRUpi3xtLiAnTZwdnE
	 pgnAmIpBhiaiN/fvEhj7GZ1T7dsaMhZgszRdRQ4l0RGyAg918/p2d0WlL/uqhcUtTx
	 /asFjuJQcod+c5gT+rGYBCsQ+UeWK4ZxUu1QSuog=
Date: Tue, 1 Sep 2026 20:03:38 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 02/25] set_memory: Introduce set_memory_pkey() stub
Message-ID: <apbiQtt-cAlLkDqV@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-2-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-2-743ad31b2c8f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 376FEC0010
X-Stat-Signature: 5mwzwim1kk31kqc7oku6cwqg9jn9ehwj
X-HE-Tag: 1788273223-829297
X-HE-Meta: U2FsdGVkX1+da6sHa5e07xSVBpVLtWFHIgGGjXPTt1qppvi4T9bINcPHK5ZWZUhqrlx+JDpSPROsqfjEUs45bar7R8vr9QTngQpEkaCPCn0rYTjFw4BrPBMi97rVGEhVRqui+owR6BIARAcVAZvGctB7cs4zA7EPqiPecBMFggUZYYtYRuxWX0ve+ClvwTTMllEQ1EHrcKsX3jUrRI4GJ8H97zjcUVlGFuL8R1A0rb5uXKHaUBEM/vrwd4L/0gq3QRQh1pN9OyV0iN1yZxmabxfPPKsj/7axxvz3TvRwDirsdn7lGqsC0OMghTNbVrcvJwRSOS7eyP4/AsqodcIA9VdI464Eba8wtyceivCnKuRHOJ4UWBQYQ0veUWtGctM3J7Z/5zsLOarbcdsAr+fVc8ElPmaFw0bQvBjKjjZPwPmPtBGAj1Jc5MfuH/EbDtw0XJXQYT6yog+1m6OWXGVQLu83cufG/KVv4FoyLJIVavKEA9KAZBu9IpihVgHc1X4bVm/VjLGHDfuKPP2raHtdn2cN+6koU+xG/ygs7Z+LFDucglUiEuShvZeq9q0gd5r8kcKL1q/JNb6SHgh9/zC07C9lgJhG/VPJtZxCde774jy2GsRIK9NGlO9R31Fyp97pH4cCE9UsTYDVTaZa8hUGPhXqOXYRgxxC+t/+6L7ejBpjVFqnb5bq34LyctW0zQ03oUSnGuSYnqcj8zm5pVjhcLqvBrk/OCX+m58zRCbVYgir8xvt0SjWIn0zOQmm/gYafY5G9gctGJowHf7fx8CEvB1eCH8cnltGhA/RBcF/8VLB4ULeJZw49sBK1u4IU8a0XKLHBCebAOt3IzhNxzgeirDliB254x3vPg4LHO3cCx34TmOhExx7a1RsVaxcm5qhr8xexM9DMBmiZU2xbQcW+kNDqjmLkj6TyhMSIpny3D7oD7cvidsPJB9FqApQyrPzusHBeiYq6bzZbKK2GRn
 do+wlI4o
 t2mGT2NnMEd77gQir00nHJVvL7VBpTBaPbtpeUUY8dP49KBns0y4rP596woIQd0xI1AcQ6OX2WHVJWFZtMfw5jfbAE/WRQe2i+fMn/tYIuPRVEoXbFz5scyBy2DmUT03opbo3y+3Ez7WHP17hMMCQB1QhqdsxcmSsRRGjRiqmg7V5D2SElfzIPLJ7+e0zPE/nTLLsS3zFIlGQoJENh1JzxluDvDuyuIqru8+vkYrJUNB7cTienx+tYo2ngiFqdKAGDPANSeQuySelEEBFTEBlXSC7sOIIjFiYfuNRkLd20ksGVPsuLAx6bPkBCnsaMHyPmPS9cAsiMb30sY/6Ub+YEg6PE14FGFiMYWGJYlTR7A3fLfVwp0dIUzYV9wrYJO2P+AcO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin,

On Tue, Aug 18, 2026 at 03:08:44PM +0100, Kevin Brodsky wrote:
> Introduce a new function, set_memory_pkey(), which sets the
> protection key (pkey) of pages in the specified linear mapping
> range. Architectures implementing kernel pkeys (kpkeys) must
> provide a suitable implementation; an empty stub is added as

Could you make it explicit here why we are restricting this only
to the linear mapping range ? Would be helpful to add the reasoning
in the commit message and as comments.

Essentially we are also making a assumption here that there are no
aliases to the linear map ?

> fallback.
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  include/linux/set_memory.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> index 3030d9245f5a..7b3a8bfde3c6 100644
> --- a/include/linux/set_memory.h
> +++ b/include/linux/set_memory.h
> @@ -84,4 +84,11 @@ static inline int set_memory_decrypted(unsigned long addr, int numpages)
>  }
>  #endif /* CONFIG_ARCH_HAS_MEM_ENCRYPT */
>  
> +#ifndef CONFIG_ARCH_HAS_KPKEYS
> +static inline int set_memory_pkey(unsigned long addr, int numpages, int pkey)
> +{
> +	return 0;
> +}
> +#endif

Would be better to make this (linar map range)constraint on the API name or that passed
as a boolean flag ?

Also, it would be better to have the __is_lm_address checks in this generic wrapper which
then calls arch_set_memory_pkey ?


--
Linu Cherian

