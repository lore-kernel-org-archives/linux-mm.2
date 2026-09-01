Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D909EC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:42:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B28D96B0259; Tue,  1 Sep 2026 10:42:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00996B0261; Tue,  1 Sep 2026 10:42:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3DB16B0269; Tue,  1 Sep 2026 10:42:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 844826B0259
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:42:58 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19F628045D
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:42:58 +0000 (UTC)
X-FDA: 85165460436.10.400C197
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5BF0112000F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:42:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fSf+J4Un;
	spf=pass (imf29.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PyIEf+L5wpgMc9pVz0HpDIzIC04Zw4Z63bkTn3LXy6M=;
	b=arWa4iaBL7wADn7A25/+CgVjdkA/+nQWvjVAPEd+VE4isG0BsHKiQ3QRCzxd7Apd4TreS+
	gLGoIPHvbi4A/I2kXOhGh69Iog8CDmN6RKhyYe0570rYSpOKaqBbeymKq8R9pdrB4uEYJ7
	c0rodt1I/n3OE1UHK+CCFtx4zh5ixaY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273776;
	b=Qsp/ggphplwOaBTAXgwwU6tAs+GZfLiCsfxkRRkFIeYazhcwLJzzygw99ZJ2X+sQBK3Fxt
	Xn3zZvgdOohkN4OTiFPFS2tJdkE8DaKmoNz4VRc3GQorje/xOQy46W4GREyi051Nk8MZQ4
	BCabFIniOifrtD5IgZ77g/+mL/a3rpY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fSf+J4Un;
	spf=pass (imf29.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE2BD1756;
	Tue,  1 Sep 2026 07:42:51 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E20CA3F882;
	Tue,  1 Sep 2026 07:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788273775; bh=NZvEgAQVOI7lQrreQcbXEtrWMnYe52kjfKk59Vp8xtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fSf+J4UnW13FN1pFvQV4UEn0YkoWj8JEfy5U3rKMvbTohcXug4Ea3BWkGSt+8ZqZS
	 o5+uj/rcTvrdP0ExVcQ1IlNYH9v/rqsXHNIAm4jVX3qI4omAM3yFbz2Xqd0PButF3W
	 pPrGdJqssc1yVvF6PH0iCjeXSJCJwq2wSyeOvLJ4=
Date: Tue, 1 Sep 2026 20:12:52 +0530
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
Subject: Re: [PATCH RFC v9 04/25] arm64: Introduce por_elx_set_pkey_perms()
 helper
Message-ID: <apbkbH6Q4p5KYmpE@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-4-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-4-743ad31b2c8f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5BF0112000F
X-Stat-Signature: e6tir97zfmstpt96a5ff9ywn7g6ek4ff
X-HE-Tag: 1788273776-954641
X-HE-Meta: U2FsdGVkX1+cbIonaSDNWUonaBYiW9o0qkBPk1IvD6VE0WTKwrbQdBaTyeRuooayCjSh0329MOZJhga2U04/GWGEepflNaqcjzwegZWJAE/doDvbUZP2DPX0yqzGZsr+qq522TuK6bGkOOlgCuvjbG/3ZLUTvwwa8l8ut59Sf+slu7eOsMpY2IQdKGvbnMxtkqp7nSXlwaI1EDZP4XvciaBXmkS6Bow+x0byq+CtLoe9bIE6x0HCstYuUxRUGj7pqs85SbTJbJhnfau41a37jtFSVMmyCqqGm6t1DHMLA0sQt2SaYGMXmW0oLJHdw5b+sELK/6voroAW9tgHGiaJfCKtrDHIu8P3lFD/J/um4IPtsx/qQHLcs/54uTqBOmyvfFRxiPp2xkQ1sqacTGToiQzbokYIydt4AHLEHZrZ1Z7Rx6Fyfcgvtoy2ZcINTYU29y5MtIcsiy7MQwjbiNzjXqnIeOOzbGshx9HhRjrCuehOxQBbjVjkkWeosHEWsG+Q919jU3aY1mSxWoaNIloWWswKEJG/dvi0rR8HG9ZIqwPPQwnj2O8szQNHfdGMUuKBR0oC3dZIzkNReIRVZXf6u/XsN8hmJRvLHC7jJAr3UCW5/Mq1/XrhiS1V3koNejfH3ZBo1CNnJKyZKCewlaWj2hMpQxPw/2zeN7cJFZdQK/4rShF8StNljem4faf2B9u0vp6Rd3rUQMPpuOiNoNHKuiWpjc0uJepJvGYcugN0QvzwJg9OJ1kSgUzzrZxUKGsbu0cYtyen/gAkIxlYu3uXeu3BpqHevAjiLxVook3qNdq8aST3+CEKsim0uBAn5dCsFopWRmyz6/LHuLFgNkf0QBLPEk3smibqs6PFCmmaBKuDqXYKjNGjdhXL8AmVuAYDuKcnq6eJ6LJeHFRvdp19yYeOcXrGwZjnxPOQFOu/HvrcHc3qxYsvy+BkUfeMZMF9/xQbxn1wgcoPPOG5nsK
 OojvnadX
 Ipw9QXPXE9hUSctS6WzRHnNUAXvAjPYgLOfTntt7supDz0vYCO2xRh3fOrTX/3/NGaTPOsSzcv7v5j5J+Kb1ZpneIuU0Qr/puRWXhOJCWJypBCy9XLOC+u6iXiuLEsSKaVJrOgYwAGvs9y1Qlg50etaGbH/7x6wSYbS4Wzkrh/BD+qpjGHYBfq6NUc6rMkYvgxnvcxqwXVehruoGfhvChnjltxHJNH16YopGB4q//NTSadl7zfXzZamKCivtakgkD1x8kFRIOpoSfWYMObZAHycXbe5sP+uD5hBPdpEsI20yVaAChJhKWvLibfbflaELjHEMYARWty8H4wqv0mp2jTWJiFft9+QgiqSjASd4Un12gVnDdQBvFYHPDfWzGfCVtDywZ9reAFjqDg6JWMJ/uawgKWv7+MRy5W7j95E22ePtnCfUq7RYBtrqtSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin,

On Tue, Aug 18, 2026 at 03:08:46PM +0100, Kevin Brodsky wrote:
> Introduce a helper that sets the permissions of a given pkey
> (POIndex) in the POR_ELx format, and make use of it in
> arch_set_user_pkey_access().
> 
> new_por now represents the permissions of a single pkey, so rename
> it to new_perms and change its type accordingly.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/por.h |  7 +++++++
>  arch/arm64/mm/mmu.c          | 26 ++++++++++----------------
>  2 files changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/por.h b/arch/arm64/include/asm/por.h
> index d913d5b529e4..19b3dd1d43a0 100644
> --- a/arch/arm64/include/asm/por.h
> +++ b/arch/arm64/include/asm/por.h
> @@ -31,4 +31,11 @@ static inline bool por_elx_allows_exec(u64 por, u8 pkey)
>  	return perm & POE_X;
>  }
>  
> +static inline u64 por_elx_set_pkey_perms(u64 por, u8 pkey, u8 perms)
> +{
> +	u64 shift = POR_ELx_PERM_SHIFT(pkey);
> +
> +	return (por & ~(POE_MASK << shift)) | ((u64)perms << shift);

We could use standard bit field access macros here ?

--
Linu Cherian

