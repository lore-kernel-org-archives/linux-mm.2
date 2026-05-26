Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 787F5CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 18:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C8246B009D; Tue, 26 May 2026 14:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978FE6B009E; Tue, 26 May 2026 14:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88ED26B009F; Tue, 26 May 2026 14:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 799B96B009D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:29:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1AB4A4038E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:29:39 +0000 (UTC)
X-FDA: 84810409278.08.9453623
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E3BE41A0002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:29:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="N4EdRD/0";
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779820177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O5eXUrKnetgtJ3OgaH9ilju2x9X0gZP/DkKCYpLF5xo=;
	b=e0rAK9fzT7kZIK2paJwKkmjejaorxDIiSjDnbw4Nj7LUl/9MT1/5B44G1rptZFxDm8nGj+
	OEajV2fP4e4o7VLD/ND8DcoUlms0t/rB2/SWqImlhV+0M+5HhVjhGcxwvVB5aGDlOOQBnz
	FKn6L/WsdqBPu80pvJ4Llzt6EVptiD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779820177; a=rsa-sha256;
	cv=none;
	b=ONE5GFaL4l4JiMWLN26FrfFhk6WrFAsnMJ8ugxqV/qUG+U+PI7RWe3FuyI2v2uI5aEXAqW
	dbRhVppPTrNUtEGOXJPbfoho8VQlxjhBFMBNa90YJap3mkutzbZ2V5+sO6q1yieww5Rjm1
	luCq04XdIFTFSTSmhBZfa66GrGq6MrI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="N4EdRD/0";
	spf=pass (imf19.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EE702936;
	Tue, 26 May 2026 11:29:30 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CB51C3F7B4;
	Tue, 26 May 2026 11:29:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779820175; bh=KpUppVZ8QZSoZsraIQoIJK5QdakJlsWa/Qre1zpsV2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N4EdRD/0ShkZ57IyNX70SdcB/Q5k0LEXw52dLQVujI+Vwslvq6V1hDq1tpeG1/aaX
	 BAZ3BhKUpKgUUaSLG9f2Swj9DLuk3/9X8+1V4sGBWT+MZ8xj7+w4G+uyn9TryisCLu
	 ucEf7pUjmBDQD08PtnyFBfYqcdTlbaDowEHWfCLU=
Date: Tue, 26 May 2026 19:29:24 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	workflows@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev
Subject: Re: [PATCH v12 01/15] kasan: sw_tags: Use arithmetic shift for
 shadow computation
Message-ID: <ahXmhNvFbIq-mvfP@arm.com>
References: <cover.1774872838.git.m.wieczorretman@pm.me>
 <c36fe46e1dde1a759e8ffdd0fe9439bdf2c66dd8.1774872838.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c36fe46e1dde1a759e8ffdd0fe9439bdf2c66dd8.1774872838.git.m.wieczorretman@pm.me>
X-Rspam-User: 
X-Rspamd-Queue-Id: E3BE41A0002
X-Stat-Signature: uof6hiwmd8x8c1kdk3s854fou7ghdi9c
X-Rspamd-Server: rspam06
X-HE-Tag: 1779820176-69607
X-HE-Meta: U2FsdGVkX18aLqcIaPFq9h/fDYC7mVXP+iRyc0hhx7WOIwlTdpANFtlHzrqrnl8HN/FSPf/2DfXzL94yXWJZGXZ59JekveKmMPojs3SF1bsSFgm+14qyM1kOKws5CYH5ZbeHaDgkE17RREi3vyDDAhifeDZw9wCSZoVQZH2ZsiU30DEKCLyVbT+6Orn/tGTbtWJnxxJtXzzFvGXKrskpssfY8Nd3FK8bb190SPk1RatPufkJMStzWsqutipOkGSe9IIQCAWNlULVPv/ULubJGh7h0SO+TQbclUi30czCQRJfj0QPhyx3AIB1TTQaBNU4nZxc8k6L5b1B5JwIhLXBvnIT89YVxcYT15snHjxmQV7He+dv68xcWEGlSTeZjljyR/Nr0oPZDl7b+SSd5b5blkysShMsP6zYkHbyxACJxMlDAyHGPYne8Pbm+ymVUfi+q+ItD+kM/VtsaNF4awgCgS+XJ0Ye/wTFEtDtIAuNnHd/rJiW5Fb9e0Z7n1WEXGyUdbFi7Z4VOrYLEO8uSc0sqT4Ao2Ct/j1nu3aMLeNokmlNz+q3COyt6YKYtgsSe3mVYe4NqsFs5f1ITOKqwd9aYbIczpt5SjNVwjYUCIRyYQujr/OX42yeP4o4A9Hl2z9pjuq5dnSE+XK38uuG6ZVWE3TVa3SWi+LB7PGUzkC/MEERoLwyLc2UEGIuJnd7OO8k1mJ7UYss8rwEWG40O/UAaFgJG0EWlb7/7Dlz8mqS7gPUO5Ji3xWvBgwcwpasqkxFAiPujjRh7kzQjUJSpFxwyiTBH5zBEXdzZFyD8zZbrUXLk7PPVCREi+9uwPRRyLq3+9xM7k8mq3+/E7R6PCVTs/T5XuFqyNRIj3xKEYLpregTbZuU1OXG2OZJ6Vgsm7EUDchW9RbM4by+MRa88ufG6DhnSHPOyPeCPQn0SThYHCzxU6O5FEGat4OJc/U/qlfGd2zTuvvhCfIgkwfOiFU
 2eVKn055
 3I3ftg2kFVK54X948cERZuq/bzscxhWkfk99icYvvjvwbKxpODmeHvS4+mIv5zS3zA4bDmHK1SVeV5CixvFpqIaH82ytH6bwefwaH2OAaVXHipV3S+2/rwkc00RiJnT18ao7Z6DP4yexc2dRa51zkwGCaOmq+u+XaQTlqPRWgzrLI4HRZ7uCaAL4+CDXLv2q3kdCRlZl5nzX/pcYlJcTdHTeAMCL28iR5+wH85QVr7QEHtQ4dtTNrIUUhpqRIFBXL9g7ReIaf2INf2kjjuyPkXvDkbGeKHHZEE8wMna+Yglgx40XStAwnzJZOSwSalcN43KmnVeR+2GEcdFPJ7wBXkD1dKb/BCH62pYu04E5zTAcoUCaihmvz6TFWhCJXoY1Ckghlodc74pG1KawBewAxbzHJtHdVWG2qdV5OT8wN5glKu+MijJ0PhnxTQf68spGIKcS0VK/f1jFUxN+VSzTtho8xUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 30, 2026 at 02:33:05PM +0000, Maciej Wieczor-Retman wrote:
> diff --git a/Documentation/arch/arm64/kasan-offsets.sh b/Documentation/arch/arm64/kasan-offsets.sh
> index 2dc5f9e18039..ce777c7c7804 100644
> --- a/Documentation/arch/arm64/kasan-offsets.sh
> +++ b/Documentation/arch/arm64/kasan-offsets.sh
> @@ -5,8 +5,12 @@
>  
>  print_kasan_offset () {
>  	printf "%02d\t" $1
> -	printf "0x%08x00000000\n" $(( (0xffffffff & (-1 << ($1 - 1 - 32))) \
> -			- (1 << (64 - 32 - $2)) ))
> +	if [[ $2 -ne 4 ]] then

Nitpick: does this need a semicolon before 'then'?

I can see Sashiko raised it here:

https://sashiko.dev/#/patchset/cover.1774872838.git.m.wieczorretman@pm.me

> +		printf "0x%08x00000000\n" $(( (0xffffffff & (-1 << ($1 - 1 - 32))) \
> +				- (1 << (64 - 32 - $2)) ))
> +	else
> +		printf "0x%08x00000000\n" $(( (0xffffffff & (-1 << ($1 - 1 - 32))) ))
> +	fi
>  }
>  
>  echo KASAN_SHADOW_SCALE_SHIFT = 3
[...]
> diff --git a/scripts/gdb/linux/kasan.py b/scripts/gdb/linux/kasan.py
> index 56730b3fde0b..4b86202b155f 100644
> --- a/scripts/gdb/linux/kasan.py
> +++ b/scripts/gdb/linux/kasan.py
> @@ -7,7 +7,8 @@
>  #
>  
>  import gdb
> -from linux import constants, mm
> +from linux import constants, utils, mm
> +from ctypes import c_int64 as s64
>  
>  def help():
>      t = """Usage: lx-kasan_mem_to_shadow [Hex memory addr]
> @@ -39,6 +40,8 @@ class KasanMemToShadow(gdb.Command):
>          else:
>              help()
>      def kasan_mem_to_shadow(self, addr):
> +        if constants.CONFIG_KASAN_SW_TAGS and not utils.is_target_arch('x86'):

Does this need to be constants.LX_CONFIG_KASAN_SW_TAGS? I don't claim I
fully understand this script but the other constants.* use LX_*.

> +            addr = s64(addr)
>          return (addr >> self.p_ops.KASAN_SHADOW_SCALE_SHIFT) + self.p_ops.KASAN_SHADOW_OFFSET

And, again, Sashiko mentions that the bitwise right shift here will fail
after the cast to c_int64. I just tried this in python:

>>> from ctypes import c_int64 as s64
>>> s64(0xffff000008eca008) >> 4
Traceback (most recent call last):
  File "<python-input-1>", line 1, in <module>
    s64(0xffff000008eca008) >> 4
    ~~~~~~~~~~~~~~~~~~~~~~~~^^~~
TypeError: unsupported operand type(s) for >>: 'c_long' and 'int'

I guess it's hidden by the wrong check on
constants.CONFIG_KASAN_SW_TAGS.

Otherwise I think the changes are fine. If you fix the above, feel free
to add:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>

