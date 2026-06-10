Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E867CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 11:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74FE86B0005; Wed, 10 Jun 2026 07:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7005F6B0088; Wed, 10 Jun 2026 07:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF496B008A; Wed, 10 Jun 2026 07:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4992D6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:13:53 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EAD0C1C32C8
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:13:52 +0000 (UTC)
X-FDA: 84863743104.21.D63E88F
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0DD32120009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:13:50 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0aN4h2i;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781090031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tz1M0e8T/EgKbgpgwsMN3TPc5zEkKMmlMDxPlf4j5nw=;
	b=gm5BREPz203xpMJ9uYv669Zdvp/fB8GsYNbA9PN7ndX/p3xZctqH5XoceH4zp2wbumorxL
	VAC9gXJ9cCi9bfByjtiDg/dhMi1oYOcu7thriRrVU6Di2+L+DOtWOO/mJsPMvZoFjGMjfT
	6ox+UAIF0VYak8J9yFyI4y+ij8bZeZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781090031;
	b=Zi3XYGJGlCquAFTa6IIqlcZ6fBXCCNhJfa1UMcBlQLqoYLQz+7qeOzpM992x6sUlZRV8uX
	KWxD46FFSCTq7MUDUcwwPUbWldVwFtD0v+GsZuJ6UbGseECGXaKDB27lcdWogL+eXlXHCx
	dWyG/aNF6XD7okn9ne7PSyRVfGJqY40=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w0aN4h2i;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781090025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tz1M0e8T/EgKbgpgwsMN3TPc5zEkKMmlMDxPlf4j5nw=;
	b=w0aN4h2iVp540yjSpDVq5LAfaIPC5S7ZhaRdvO+FrwYkC7WY9AXjgPlZZfX+abU+ikyuFR
	kcqVmLTrtAuTzpr/ZKqhAZan4KxOGzwH8aFEdm4oF9EXR3RxVRSeuwEkOWEiS5Yz6sxCy7
	/6XgwW21d5MPjkc5WNDWSZG8OOJwpQY=
From: Usama Arif <usama.arif@linux.dev>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Petr Mladek <pmladek@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andy Whitcroft <apw@canonical.com>
Subject: Re: [RFC V2 1/3] lib/vsprintf: Add support for pgtable entries
Date: Wed, 10 Jun 2026 04:13:36 -0700
Message-ID: <20260610111339.2465922-1-usama.arif@linux.dev>
In-Reply-To: <20260610043545.3725735-2-anshuman.khandual@arm.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0DD32120009
X-Rspam-User: 
X-Stat-Signature: pty8pjd1itas5dj8yrwgg378yhbkuz41
X-Rspamd-Server: rspam08
X-HE-Tag: 1781090030-736072
X-HE-Meta: U2FsdGVkX1+VDK2FJAC+nXdfL9OcjE9UZp+gdoym2ZJY7zTxb7ntkVsPoH6La2BGMwNknBpsfa4HjFlvir3XTlSkmZXV6CC5nS3QZTJlP1WHuwCZBoaiwzqXN5zwSU4nxIxkbV4ArHV5IYnLsndOf2G3aoaQImIIOG1A69W1Z+jhGVIidnSIV03H7SVoe7gFDhr9E2CZ9UJaOCAcFfXVVgcgN06vySRLe5oCs6Iekwh2yLT1lOKW64xbzrWy3kx+hLw3ZBWe+zXnRqErD9P7GjygVyAWspCiIc7KNjJMFdsT7hVh6/ogh8FuQAnVCJJld6rlJHSHzRymPbm6OUVkT1ZGKVlNgX13GYj9gOCHln5cj5WQ9lI/GfY5xwLy9DwhwSaXA7G4ROZf/42blbP9cyw9AtI8b2j66maGiB/mpU/jJPK5VxVW1ItvNmETD9gpLVak20kuXGtSSaXsEXlRsPKaxrMr/YXgDIuqkPIz/3JCtmB34Tq8HRohNko0tC7Fnqkx2GoyoGZY26j9ifiSxs/jGuRzPftDy721DMc7SWIyB+hiaR5ETODBfoYDSgx8p75S6DSvGGTintEMgAPrEvWGxHdQlUrCJsApVygi/xCLX9qCa9QqVGc58uJ95BXbRCpGZJ2D4RJm+m6zXk5oqYUZ6v7fUBzwLCuJPE0UM0kJRIqDoQrRumGmmikUbN2SRtkedvZRpJ6VSGXdEUsThfuYCcZpQanEhJ2wVDDMlPVZxnHAx4OLgM6QTrqgBa+f8HI9XrY52NcO0CFP2vqPxHdapzGzyPuaZ/aeVtssRw2lOTveBf43ODSqqq9kG64szWw3UFO4Rlcq3mtFyroBdr4vMbxFhK2qBBYdlna/N/2+8C68q7DqPqdEGv7AHAFYVqVw33HOb353QSuDKzIJPOYRy8SQB3S+Xdej/36bIhB1L5VDdlCIdWOjLTiko4jr6aiXryAfvUvq0zKlB6P
 jeLTe1p4
 d+dECZWN8hINn/WyhPDAYPOKeL8FNriVATAy/OXOZ/O2v8CtNfu6AywlGBIUtQhstqfLnMgStq9Gap2Rrb8UVhkQdWPv22Ip/lqJlGB0yxtrUXMM+5TU2lej4QYshKcp4eX6N51tvrMns06tS4ioVsJcLd1u6ddEyvLfyLDzByWT0nwqTQy3WCnsYJst7A/tpJkB6JstcP0e+R4KI8hFzvZlAKqP+36ttRb1ILiu8UHHGjnRbRfcmXQTT72Twkin1ptRLuY1I1t3rBeDTyTmr38b+CgboZBRHs/gBu5KZ02jZ6aNs+lJ/9we66thbT9jurq47gt1r4Prx0EOz2a3fhQ9zSURguf9/rm8BbTge9U6YRr4T0wyyU7SDPY8paCHSXDfukqRsunT1hnD9yVtvQeoSipjsRWx02WqJUogAnEG20AM7N79jEd6MX0YdWV+AbNegX4iXooZRMYS1Bg5gnKvpjlWwy3YfIn7vPicS53APmhr5mSaFoJOQGGkddnTwpJmk2OSIzxpClVUUM8/oK6P9apxTaBIaPgY8npo6BbtA70pE0Ea94HW1c+Sv/lUlG1Ay7dAnbIULqwHFPjUCdiemeClTbMKZuTVhXbw9p5EoJO28Ak2/BnFidiz6ZzVjXrDam4OF1zCi7j8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 05:35:43 +0100 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> Add some print formats for pgtable entries at any pgtable level. These new
> formats are %pp[g|4|u|m|t][d|e] i.e %ppgd, %pp4d, %ppud, %ppmd, and %ppte.
> These currently support both 32 bit and 64 bit pgtable entries that can be
> extended up to 128 bit when required.
> 
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Petr Mladek <pmladek@suse.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Andy Whitcroft <apw@canonical.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> 
>  Documentation/core-api/printk-formats.rst | 19 ++++++++
>  lib/vsprintf.c                            | 58 +++++++++++++++++++++++
>  scripts/checkpatch.pl                     |  2 +-
>  3 files changed, 78 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/core-api/printk-formats.rst b/Documentation/core-api/printk-formats.rst
> index c0b1b6089307..e69f91a9dd9d 100644
> --- a/Documentation/core-api/printk-formats.rst
> +++ b/Documentation/core-api/printk-formats.rst
> @@ -696,6 +696,25 @@ Rust
>  Only intended to be used from Rust code to format ``core::fmt::Arguments``.
>  Do *not* use it from C.
>  
> +Page Table Entry
> +----------------
> +
> +::
> +
> +        %p[pgd|p4dp|pud|pmd|pte]

s/p4dp/p4d to match others


> +
> +Print page table entry at any level.
> +
> +Passed by reference.
> +
> +Examples for a 64 bit page table entry, given &(u64)0xc0ffee::
> +
> +        %ppte   0x0000000000c0ffee
> +        %ppmd   0x0000000000c0ffee
> +        %ppud   0x0000000000c0ffee
> +        %pp4d   0x0000000000c0ffee
> +        %ppgd   0x0000000000c0ffee
> +
>  Thanks
>  ======
>  
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 9f359b31c8d1..d4ad3048a4db 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -856,6 +856,59 @@ static char *default_pointer(char *buf, char *end, const void *ptr,
>  	return ptr_to_id(buf, end, ptr, spec);
>  }
>  
> +static char *pxd_pointer(char *buf, char *end, const void *ptr,
> +			 struct printf_spec spec, const char *fmt)
> +{
> +	if (check_pointer(&buf, end, ptr, spec))
> +		return buf;
> +
> +	if (fmt[1] == 't' && fmt[2] == 'e') {
> +		pte_t *pte = (pte_t *)ptr;
> +
> +		static_assert(sizeof(pte_t) == 4 ||
> +			      sizeof(pte_t) == 8,
> +			      "pte_t size must be 4 or 8 bytes");
> +		return special_hex_number(buf, end, pte_val(ptep_get(pte)), sizeof(pte_t));
> +	}
> +
> +	if (fmt[1] == 'm' && fmt[2] == 'd') {
> +		pmd_t *pmd = (pmd_t *)ptr;
> +
> +		static_assert(sizeof(pmd_t) == 4 ||
> +			      sizeof(pmd_t) == 8,
> +			      "pmd_t size must be 4 or 8 bytes");
> +		return special_hex_number(buf, end, pmd_val(pmdp_get(pmd)), sizeof(pmd_t));
> +	}
> +
> +	if (fmt[1] == 'u' && fmt[2] == 'd') {
> +		pud_t *pud = (pud_t *)ptr;
> +
> +		static_assert(sizeof(pud_t) == 4 ||
> +			      sizeof(pud_t) == 8,
> +			      "pud_t size must be 4 or 8 bytes");
> +		return special_hex_number(buf, end, pud_val(pudp_get(pud)), sizeof(pud_t));
> +	}
> +
> +	if (fmt[1] == '4' && fmt[2] == 'd') {
> +		p4d_t *p4d = (p4d_t *)ptr;
> +
> +		static_assert(sizeof(p4d_t) == 4 ||
> +			      sizeof(p4d_t) == 8,
> +			      "p4d_t size must be 4 or 8 bytes");
> +		return special_hex_number(buf, end, p4d_val(p4dp_get(p4d)), sizeof(p4d_t));
> +	}
> +
> +	if (fmt[1] == 'g' && fmt[2] == 'd') {
> +		pgd_t *pgd = (pgd_t *)ptr;
> +
> +		static_assert(sizeof(pgd_t) == 4 ||
> +			      sizeof(pgd_t) == 8,
> +			      "pgd_t size must be 4 or 8 bytes");
> +		return special_hex_number(buf, end, pgd_val(pgdp_get(pgd)), sizeof(pgd_t));

You mentioned in the coverletter that pgdp_get() is the reason arm32 builds dont work.
Just wanted to check what the issue is?

I had a look at arch/arm/include/asm/pgtable.h and I couldnt understand why
it reads pgdp_get(pgpd) instead of pgdp_get(pgdp)?
   

> +	}
> +	return default_pointer(buf, end, ptr, spec);
> +}
> +
>  int kptr_restrict __read_mostly;
>  
>  static noinline_for_stack
> @@ -2506,6 +2559,9 @@ early_param("no_hash_pointers", no_hash_pointers_enable);
>   *		Without an option prints the full name of the node
>   *		f full name
>   *		P node name, including a possible unit address
> + * - 'p[g|4|u|m|t|][d|e]' For a page table entry, this prints its
> + *			  contents in a hexadecimal format
> + *
>   * - 'x' For printing the address unmodified. Equivalent to "%lx".
>   *       Please read the documentation (path below) before using!
>   * - '[ku]s' For a BPF/tracing related format specifier, e.g. used out of
> @@ -2615,6 +2671,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
>  		default:
>  			return error_string(buf, end, "(einval)", spec);
>  		}
> +	case 'p':
> +		return pxd_pointer(buf, end, ptr, spec, fmt);
>  	default:
>  		return default_pointer(buf, end, ptr, spec);
>  	}
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 0492d6afc9a1..f68955858e29 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -6975,7 +6975,7 @@ sub process {
>  				my $fmt = get_quoted_string($lines[$count - 1], raw_line($count, 0));
>  				$fmt =~ s/%%//g;
>  
> -				while ($fmt =~ /(\%[\*\d\.]*p(\w)(\w*))/g) {
> +				while ($fmt =~ /(\%[\*\d\.]*p(\w)(\w*)(pte|pmd|pud|p4d|pgd))/g) {
>  					$specifier = $1;
>  					$extension = $2;
>  					$qualifier = $3;
> -- 
> 2.30.2
> 
> 

