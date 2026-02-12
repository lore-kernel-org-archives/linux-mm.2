Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73D93EB48EA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:58:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B284D6B0005; Thu, 12 Feb 2026 03:58:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFB76B0089; Thu, 12 Feb 2026 03:58:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E20A6B008A; Thu, 12 Feb 2026 03:58:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA056B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:58:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE03EBB08C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:58:45 +0000 (UTC)
X-FDA: 84435204210.26.1D48A02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2FD5C4000A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:58:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HT5R6kpv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770886724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDZYxDalqWS4jpiN6DyzwpwDXVyHMVpKrE+0rILK6hg=;
	b=0f6//u3UjNxPgPS5ugHPzVE+G8PmNq5alLmkokSmyA/0jTncTFjso+SQa7c6DK4xjr6XWq
	+70TVbIhCAwmyBe8ej+K+UpItp6N0+YlNGI50VPHPh4NZtPpeDpQClj8V4RezsVGvMUb2i
	yRI1CXin2yUjC3RLZhL/pr0XiI6wRHc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HT5R6kpv;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770886724; a=rsa-sha256;
	cv=none;
	b=1iaahUfVfUaK5UwbUD63xAIU+qlZMiDHUYhrCDnTbyB9K4MAc3/UJ2Av9/TO4WyFedl4CB
	c9m52fIGkUil9CRItglWLTZVcFkTHvV6Gs9vdtuKJQyXp18e9+iqWdgGO3fKKfzMO9SCWS
	0CDvEUCeRYwqdU3WUOeYzUvtLcjP4Pg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B62960128;
	Thu, 12 Feb 2026 08:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0155DC16AAE;
	Thu, 12 Feb 2026 08:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770886723;
	bh=O72aDxD0jjZlGGwbJFSDSKCAXe0FHSLzulcP/3B+3gA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HT5R6kpvSukfg5IN9nlS4YbpAP2leknMovU4Qa/hAHCkiDLHNZCK/gaEeXQHxyP1T
	 EeaWGdiI6XLZNPc7qylXP4VxUBbfiWCiPR0OOrU3ukw4sHt8o/tbgJHm1EXYuVKv5l
	 TBZNfkmh8mxb3m+xGctyA2sWLPBXy+8bVH6k/ChG6pgU9xLYtMCirmrNSdekZUSMr1
	 rcLqmGD6U2Zf3RltXhzmv3O0aVtAoGjJuEnP61CUcxzzuUEYvxoWOwO1f80x8bs6UX
	 gPY2bh3g5BAn1TNdodmkMMpjKpSAgB1l7qIcZJmbGe5SiaAuLLViJ5jFEfzgOeHrZb
	 3ef+PtYkktc6A==
Message-ID: <a9834da2-67c5-4641-8ca1-fc5ba067572e@kernel.org>
Date: Thu, 12 Feb 2026 09:58:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] mm: don't special case !MMU for is_zero_pfn() and
 my_zero_pfn()
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Larsson <andreas@gaisler.com>, Borislav Petkov <bp@alien8.de>,
 Brian Cain <bcain@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dinh Nguyen
 <dinguyen@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
 Guo Ren <guoren@kernel.org>, Helge Deller <deller@gmx.de>,
 Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Johannes Berg <johannes@sipsolutions.net>,
 John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Magnus Lindholm <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
 Palmer Dabbelt <palmer@dabbelt.com>, Richard Weinberger <richard@nod.at>,
 Russell King <linux@armlinux.org.uk>, Stafford Horne <shorne@gmail.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Vineet Gupta <vgupta@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-sh@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org
References: <20260211103141.3215197-1-rppt@kernel.org>
 <20260211103141.3215197-2-rppt@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211103141.3215197-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2FD5C4000A
X-Stat-Signature: 9dr9uz6jdiaugjj7rmc4k85jf7pzufpb
X-Rspam-User: 
X-HE-Tag: 1770886724-463288
X-HE-Meta: U2FsdGVkX1+RetTkfVo0um8MmD6Uy89kuRrqhCmEoflWyqZz1rF2A+Xbes573g/JcSwXtaOe1XTJfW+zbJJZ7dSPEW/e/DZkEeJuzF5AmhuYuVUJ+/cooaD0GoqAQWGeNSager/BhptHmB2Q3qeqeMDzkJkH8L549KwR66pm0GC+tdUejRA8NPro3pzdmXO6vJ8HC9Utbej9V+mFbdEj3UhZAoulWD2gSJnKZ2im1YzJOclbd61wb70JIB0jIWhzDIyzTHkZ2/A+abDO3wznZcqBQ82QBlaL2qAcIm4olYKOrC23PGuDb3CvIpdhFRwObhCFuN55QSBjAEPykexaaYHXaeHf0rOMFNyEsGq1MAQ8b+IejF4dWZuFzO+koL/iq5tHFjPUoA8tm5MDQeem+kU+GpsRKgSa4aG5HIs/lpZhT+pt/rP5sS2TNxG6NiBOssEc3vmHNvPh/JzPqEX2u6NSlbLZUfsqaiYIrMPTcL1HFNQX8vfp6fYEHTo60Gh2qzu3TgPBmDb/93Ls+6dc2PfoBMi31xc4Zrf0NCxIpe6+okXzBLCMNfWj9nNhHp1wkc8Qb03WRdb5GeSNMVvDxTESrmM1BFkdbn87xz7K4G/uopGBhFXfrv38NtkaqCqLH31M+oWNG0xOcyk/w8lO7sV0qsKr43ZpldLJ2Q4gWpDpKWSfKp2arxnthDJrzbI1sPRV4VyX7ALvz27hVx5kXP1xvgFWs6Lh7HFGlxtGYqpjpPVw9gGkXOHiwPi3xhlHyqYPwdP6L6xhfuyJEn8ugq1FBio3mIYv2WjNz+LQUJapbl01MrfCYVCoW4I5wRGuRJtf7VYrG7j4/1kvHJmX0xAwsqVy+06NNcx0esXfkrlmWbm1YBU4X3rJs3liPrmWdAfeKUUUkcxgVhmVxpFCAno26CSCCpm90eo95JwHvaYdwJ6FkrpcqjB8t7t9h9GoqVEyMeEL6SvK+cgAoCd
 7lKKWEal
 IN+fSVVjaoqnYGk5TuwnJM4Yvaq3nUHeqMRXRzECiadTh/zc9ONFcWWQ98xPhdkZlVpdYX5UJNZ58xRTPgYZTYgBllSOeg0B8vcoLMQFgOwKS1fgSmuvTl7mZKbcp4a6M+fYZ2mipLDd1FIo2KZjjAishr9q4u7P/8g3UadXL3cCkRLkWZvRXmWMgAQQqEg4HX2p0LiEgzQhF1klsAumdw9IYerleSS4eweDtweGPV8O52xrq5kb8fCJ/xJVCJPO3SLTy03hcxdG4L/P9rUTvUPYHbBSeRW1nIi0Az8yVQ/MDHfb7/3mcnZNT1ESLhz9oo+iteKYcLc1OvSRGxrGSc4GuMEoqlACAlJIfl+4ohyR0Uzys0/QeeZdDAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 11:31, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> nommu architectures have empty_zero_page and define ZERO_PAGE() and
> although they don't really use it to populate page tables, there is no
> reason to hardwire !MMU implementation of is_zero_pfn() and my_zero_pfn()
> to 0.
> 
> Drop #ifdef CONFIG_MMU around implementations of is_zero_pfn() and
> my_zero_pfn() and remove !MMU version.
> 
> While on it, make zero_pfn __ro_after_init.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

