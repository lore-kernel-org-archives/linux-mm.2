Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F32EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404E76B0005; Thu,  9 Jul 2026 20:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B5856B0088; Thu,  9 Jul 2026 20:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1746B008A; Thu,  9 Jul 2026 20:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 038F96B0005
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:08:20 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81E3D1402FA
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:08:20 +0000 (UTC)
X-FDA: 84970929960.10.EEB5AA5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id CA0591A000A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:08:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2S2q+QsA;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783642098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o1KNst9m0viCssFZX760yV51UEXnWc+mJTMWEKbthB4=;
	b=iIgpQG+5Jbv9ThbNJrGklNg0tXZBhjR5zh8V6DVBzrOMxy+8VuJ0Yqi28pgniD0Yhsu3b1
	1zaCJga2AMhKJxh8u3Q4UuHKA3pXP69yv7O52AA0wzwkLk8aZ37yMnOkZPBgYsagGfGF4x
	5mMQqZFw+QKx24hSG4kxff/L8zAzmhk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=2S2q+QsA;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783642098;
	b=kFTERxx+GRGySMAtDoAjhGBDBVF9xUNC8GvMaCvivn/2+gsl+hNVeXsGcZOIDGyjMT8oGc
	gDsPz7tZ7h1DUnFJix3C18Y+3iiOLPd1eJLuAWUHhtUsTFgwUNKNZD5rYh0toH9koheaX+
	CGL30DSO/UgjxNZjAn82uscIcnqpuSs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E16F5600C3;
	Fri, 10 Jul 2026 00:08:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB971F000E9;
	Fri, 10 Jul 2026 00:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783642097;
	bh=o1KNst9m0viCssFZX760yV51UEXnWc+mJTMWEKbthB4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=2S2q+QsAZMz8+dQethGHyaKFC+9XY9MLQio0kwqC2KSN9Wq4tu95OilsmGvt4leva
	 S9G32VV8l5HLhH9UPJB/g+uKkoTpVwbTYkiK8tmXi46R42gjMqn6xcVC+3hZvq0Qpy
	 DrqnqIfLFJKVe738s0+ckfVVD5ZovjowCdvj7w9Q=
Date: Thu, 9 Jul 2026 17:08:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
 usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
 ryan.roberts@arm.com, "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-Id: <20260709170816.4e876a16eef9a93f41bb1940@linux-foundation.org>
In-Reply-To: <20260709044334.1741263-1-anshuman.khandual@arm.com>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n5earf1taycxmpdgtbr7tugq4h1o6fxz
X-Rspamd-Queue-Id: CA0591A000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783642098-689280
X-HE-Meta: U2FsdGVkX1973x4g/XmG5qfjTs5o+BSGLOl7D3CxuYdgPqAimPG7oSxQClXcKLzKHiGiUMonnIW9VXuvY/+FVh6GfQ77NHH/xrc6436+RWd8VeApH0Z96YB0EcrnXpX8RHlM5gg+VnCHQpEuJ4mpeaY4AL1Cl08w4OccVEeQN0Cm5/d797yfRdJIzW3mXLxl3poW26DjZy2fqpDfYsaMNINWn+bus3/KVGoeEYKegaHFhhoIjUKXj68xFNIhNYf9wiMKVXcdFqJuUO8wWNWuxup6OW5NppbIbeFpRtbDhYRjmFqWFcZDJ8byKXVEcaBAvdI2tboF5ya40+Ve42XHklyyxM3IhAraiRGd1oroDPe2KJQPgE382/JuZVUwYHmvgM5sLCVM0ymOJFvhWJaLIR/cRj5DLeW68CHzM35rn78TM3yIRtHtLsye3q2UX7UM2HyVn+61FDoVV3RHPFGalgwhBcbFfHXadiB3u1RxoQJgmZSSagjci+f1E/vhDjKmLDh4qYTm37NWRJWJ+oM2nehz+7L0v/iFyHb6CZFA3qrC2ILu1KJscbg1icpkuXW65dNUdGI9Fr371xb/KwBftUN0/0QrIi78o67vS6mPUL+Psk59jSnKh9YQOqNvu4k2xH0rSCdH+JUlAEHk64loNY5cCd2DHA/KDRZlR8m8GLw6HQayfmBSgOLQ783yTjwysnt0QjWxHgK7wR9M5wFQtfLilmSaMjhEu00zVKxAn9kkCxG2z3bFhuanDzZstd8aq8jDY2OZpUgPKUDt5PlRaO3u+IgCmOQubKM1mBska7K2AMa15BriOeEWYLG9N4vMRD5krgzMT5IO9mZ5yce47UYOLV2pY0CrbtPJem5Zjggg9M2gBlf9sEG2sjDhK3xQ30Bdt4SS96SyXBMS+rSB3bafhoEJAIgXlS0X3NX8z5fX6MAOuHpMbeAe1fdXwW3LIDl5882GPsd63JrSgzV
 SK6rG2b2
 W4ullVz28CHYBF3VpccF8XFFG1M4WfwOnatDyMkvA7Uwb4SyLYQ7tQiiSgKcNY4nSGWhYIajO3AwixRpEgxifn3vvczWMQ/O/sRazT1hKBYBTAIGVpILNWlYFdJ9+wJRX4T942jHbVbwgO1qNfiPJT1OQu4IM2/gxo+uPBpunDUf1svxznDq38DysqZkrm3tpya9TR0ZtUxAxSesYljABpjZXLt1b+SfgheMPH7BVaRYvjBrBbnNqE94VBrJ/rlEVR8+GRjvt8SHa+LtxvanlaG+XS1ed7/+uiwAlH118duyRoGHqtnSLbyyO/gDFQO8iB0qiufygGxjQF/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 10:13:34 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> From: "David Hildenbrand (Arm)" <david@kernel.org>
> 
> Bad page map reporting currently stores page table entry values in an
> unsigned long long and prints them with fixed 64-bit-oriented format
> strings. This is inconsistent across call sites and does not work well for
> architectures where page table entry values are not naturally represented
> as 64-bit values, such as 32-bit or 128-bit entries.

Well grumble.  It's a lot of fuss for something which nobody is hurting
from.  Or are they?  What's the actual utility here?

> Introduce a common helper to convert raw page table entry values into a
> fixed-width hexadecimal string based on the actual entry size. Use it for
> bad page map reporting and for dumping the page table walk in
> __print_bad_page_map_pgtable().
> 
> Pass page table entry values to the reporting path as raw bytes together
> with their size, instead of forcing them through an unsigned long long.
> It keeps the printed output consistent and avoids truncation or misleading
> formatting for non-64-bit page table entries.
> 
> --- a/mm/memory.c
> +++ b/mm/memory.c
>
> ...
>
> +#if defined(__SIZEOF_INT128__)
> +#define PTVAL_STR_MAX	(32 + 1) /* Max 128-bit value in hex + NUL */
> +#else
> +#define PTVAL_STR_MAX	(16 + 1) /* Max 64-bit value in hex + NUL */
> +#endif
> +
>  static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long addr)
>  {
> -	unsigned long long pgdv, p4dv, pudv, pmdv;
> +	char pgd_str[PTVAL_STR_MAX];
> +	char p4d_str[PTVAL_STR_MAX];
> +	char pud_str[PTVAL_STR_MAX];
> +	char pmd_str[PTVAL_STR_MAX];

That's another 128b of stack, in a potentially deep code path.

Hopefully gcc can reuse the same stack space for some of these but it's
not been good at this in the past.

>  	p4d_t p4d, *p4dp;
>  	pud_t pud, *pudp;
>  	pmd_t pmd, *pmdp;
> @@ -532,34 +575,34 @@ static void __print_bad_page_map_pgtable(struct mm_struct *mm, unsigned long add
>  	 * see locking requirements for print_bad_page_map().
>  	 */
>  	pgdp = pgd_offset(mm, addr);
> -	pgdv = pgd_val(*pgdp);
> +	ptval_to_str(pgd_str, pgd_val(*pgdp));
>  
>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> -		pr_alert("pgd:%08llx\n", pgdv);
> +		pr_alert("pgd:%s\n", pgd_str);

can this do
		pr_alert("pgd:%s\n", ptval_to_str(pgd_str, pgd_val(*pgdp)));

and eliminate a few locals?



