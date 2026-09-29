Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89BF4C9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 05:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0B26B0088; Tue, 29 Sep 2026 01:05:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092256B008A; Tue, 29 Sep 2026 01:05:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9596B008C; Tue, 29 Sep 2026 01:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE65F6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:05:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D1E0E403FE
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:05:10 +0000 (UTC)
X-FDA: 85265610780.23.4709272
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id E1F82180003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:05:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=I3FEtuuo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790658309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mv8h/BNUC2P1X2qTS7kKTaK3+olqeqzLr4NeO4aKsi4=;
	b=cys7PTc/Vs2WzByNRgzIWfYYicjqEPq5mrPQRX9iBoWGcijP4BvgoDpYi1To5Q4KGZSFPK
	6LIG5I87WVKLDoV+iNtW0ZuHXFufQ+O7w2EkDdRdRte2GoUI/d56/JWisrFDaRLDdaN6WG
	VPUzjKBfBIdA8mC15Hy8sP2t9xDkOms=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=I3FEtuuo;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790658309;
	b=1xAc5tc81GxiN6keC/3VXZd5Vw/Mymo+kLJZv2rP7uUkJfc/mCUNDiFmtTRIwFBN6zzG6t
	Xj79cVEkTftX0J8+IVLCfpVJvpnFqaV43Wei52kCWpy1t8AgllxKx9pr5lomFH9vA5NgKk
	nY2cD6v3y5od998kvMMknuPqBo/zG/M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 735751D31;
	Mon, 28 Sep 2026 22:05:04 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 285983FB90;
	Mon, 28 Sep 2026 22:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790658307; bh=cQ/BG6TOBdm5HgzpeS1NDsUqN0RS94kKCnbqrv4zAnU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I3FEtuuoavmCwBAEMoK1tMA9B1Ur1L0yeyx10PwOfwgFyiTnp8dWnjfXv+uqFlW+j
	 n8ZCrGPB3AfjI6GWGIl0Ebw8QIzlYHNWktuuiebUlFHglEQQA4vHcLPiplQzDHdIH9
	 ACCeaZGtWYOzIQVNQQenOnAl3PXPWT8z0lNDTvI0=
Date: Tue, 29 Sep 2026 10:35:04 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, David Carlier <devnexen@gmail.com>, 
	Dave Young <ruirui.yang@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] vmcoreinfo: export SECTION_HAS_MEM_MAP
Message-ID: <re5kf3b7352ycybaaj4hb377kp4pic5c46z3gba2623idg7uzs@mvvvg2djilfd>
References: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928-section_has_mem_map-v1-1-4129f6ba2838@kernel.org>
X-Stat-Signature: gkwkhzo3aeho7ey3hc84wubwtxxqjx54
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E1F82180003
X-HE-Tag: 1790658308-110166
X-HE-Meta: U2FsdGVkX193jq3tBeNjiYzN2hmlfaDaIAJFnT7h1VkwZDj5KaE7pGNv06XOhCxmn9Z5bR7cv2G+p2/s3Rhy124H+pJ0iB893PNDxWJ+UAYaNGuZvqyHjWLlGwxFrSQAdFGhCioW4pK+89jDoqYQpK4lBF0+oCbYF5qWQQcz0/xh3o0MDXnIi4OVBvMv1Ec2XOQPkkRpWSehUhRAdAGDRIR0hKI/q0E9JA19wBq41M1U6EDS1xTh8oNomIYadQQGTnSMejRucA9Zp/FboXOQ43YKKrgbWx+peZnyZYxX8H9B0kIoy06eqE8fjXcEJv5J1ma8OtShTnjBHzGHPjwh4/UpbSwlr8H8N71rYe4ua5of9DYsC8v4PplQq6i3ZfMGlyrQ72F4QBeEUUHwCctGIdCoCt56Idqu1WJJXrgau4FtN1RXz0XsiXqXe0m54XcPXw4+871jO+P6JIqf+lXGxQC0Hvo1kH/1OeHMt5xAvoyDNusMJyKhc1CZ07aZ5NaFiOnv4W50b5+NpuAdLAfunuosZbocDFule22fOfkGaCoOYrQqPlRvb9qgXCfH8SWciYes+YbhFr4He6wOtUKZ92mLoJwQrYXluMf9QN+YSwKCAx8YaBPNvSKvPEcfjN0yW3kQ/LEA7llKrfairfTP2ck77LbjOWs90qZa8KMzu6Q/yCglivdg1LTI5dU1JSzqcjk3Gicem/ovDPEMV0kZnSTTbu7cvmHxOOsOTPGePGXtnJcuAvhUvxlaiB9uNfnl6KSggwlHOyuouhIzCmyRJrtpJc0/ZNJvT+o7hOlwP5jZVf0Y6aexmZ6XTY2cWRAKEqjruebiObhTieZTSpGV3bVRQkV2sAkxRex4OqI/k2wRAT1RKoEezL1FpHUvry/GYGNiT6m3Tl0t6/nJ+Mi5ZF6HYom5atmRBLQBDcSXQiJIQMt/5OBaBJg14cC2L3U7Rs/D0qPnkz8tM/H3BJp
 iGAQg43P
 jPdar4n0a21jVgGn/nJTOHByHKku85rNzyWOGXfq0V0it3um9FqPHk0ZwUkoY8S5JgUBODdRXiXsUQIpBJeutNFvWlyDMv/sGsw/z+CiNlQ0JaJOUxZgbup6yY91O+Aj9C0Kw5ZOKh1hwx463KM9NqUVGjIOiSwTqhLKi11PI5HTetiG7k+h8Nr0QQQV4SpI0wY3H/oa67WwDU/PxmMQc7fuf3w/mgOjVq5YedU5QYQb7N9qWNwunExHzAZlAk01eIe3XTG/rQY4gX3fjerAwpp6JyxdLbJVCIEL/zhIymgEUHbBRxtvvy6CTCzpJ+bNBEqselrnLi30Kl3oIho2qLwTlaLuylI5howibcWvFUBG6QgJ7CZG3Ru/eYHF6nkEJF3GpFxuKkiRV0+SVedVPXEVKKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 10:48:21AM +0200, David Hildenbrand (Arm) wrote:
> The crash tool currently hardcodes SECTION_HAS_MEM_MAP, and makedumpfile
> needs similar information (although still relying on
> SECTION_MARKED_PRESENT, it should switch to SECTION_HAS_MEM_MAP).
> 
> Let's just export the value instead, so tools that work on vmcoreinfo
> will not have to guess.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
> Result of the discussion in reply to "[PATCH v2 00/13] mm/sparse: remove
> SECTION_MARKED_PRESENT and further cleanups" [1]
> 
> This patch can go in independently. It would be preferable if both
> go into the same kernel release ;)
> 
> [1] https://lore.kernel.org/r/20260921-b4-sparsemem_cleanups-v2-0-54d81d65e125@kernel.org 
> ---
>  kernel/vmcore_info.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kernel/vmcore_info.c b/kernel/vmcore_info.c
> index 5a417f8a922a..7833a36064a8 100644
> --- a/kernel/vmcore_info.c
> +++ b/kernel/vmcore_info.c
> @@ -182,6 +182,7 @@ static int __init crash_save_vmcoreinfo_init(void)
>  	VMCOREINFO_STRUCT_SIZE(mem_section);
>  	VMCOREINFO_OFFSET(mem_section, section_mem_map);
>  	VMCOREINFO_NUMBER(SECTION_SIZE_BITS);
> +	VMCOREINFO_NUMBER(SECTION_HAS_MEM_MAP);
>  	VMCOREINFO_NUMBER(MAX_PHYSMEM_BITS);
>  #endif
>  	VMCOREINFO_STRUCT_SIZE(page);
> 
> ---
> 
> base-commit: 57e4ac91fc62d75d84b5a03827a19ceb4094ecd9
> 
> change-id: 20260928-section_has_mem_map-6205dc90a09f
> 
> --
> 
> Cheers,
> 
> David
> 

