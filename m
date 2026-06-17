Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F475CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 22:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9946B0088; Wed, 17 Jun 2026 18:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459DD6B008A; Wed, 17 Jun 2026 18:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FFA6B008C; Wed, 17 Jun 2026 18:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 092AA6B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 18:13:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 74AEA1C49D6
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:13:45 +0000 (UTC)
X-FDA: 84890807610.15.9D8B1F3
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B3121A000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 22:13:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JQWh5GSN;
	spf=pass (imf19.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781734423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXCtT0v0EUXn/TCjNbtIDqQixZXo8p0dSnCceCqrUHI=;
	b=KqMMwFaRdsAmVC9uEHBoeXtiYWtQtk21ls6E4XeAXbbSzd/LEJFkpyhpMb4N8gs4BTA+zC
	rww4cpuq24x/eFfXWMVgjn1SOXegNdSmNLOLYJiyqGT4dXCxeH+1nX1zj/Tq1aU3dUvZ4T
	HttSlgk2Kuo0u3CVYvGVTnftZ/u5EZc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JQWh5GSN;
	spf=pass (imf19.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781734423;
	b=iIeqvG07WqOXQlDWk7HDaazEt3cVvgPQpSCLgaCrega8AHWBHr80xesTjEP2xRVFMdTo91
	jrUZXIzehrzz+9D6hbhtRHA20GbFPbSZCyOwOouoyi6VWNf+4j67Nmcr/lr9/QuX5PPIHb
	mlcxBoaP/Jdp7s9XMKjJpO1D7dxLVDE=
Message-ID: <326b85af-c41a-4387-90a0-60720111934d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781734420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wXCtT0v0EUXn/TCjNbtIDqQixZXo8p0dSnCceCqrUHI=;
	b=JQWh5GSNswOXAIAtOLthK4YPH2rXesoew2oocgmabfDNY7GrFI8VhZRmTZRJPDLnO1EF9I
	t0DX9XKg74MguhSeDG9tLRPRPOHHoeHsiusXKx78qWz4Waug8hmuYjlw8AJdElsRs+/kv/
	7H6AZ8tLjCt0tjcl4f1LnXwjZfG0Mp8=
Date: Wed, 17 Jun 2026 15:13:33 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v1] kasan: Fix false-positive wild-memory-access on x86
 under 5-level paging
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: bpf@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrey Konovalov <andreyknvl@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Eduard Zingerman
 <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, bpf@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260610175651.647515-1-ihor.solodrai@linux.dev>
Content-Language: en-US
In-Reply-To: <20260610175651.647515-1-ihor.solodrai@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3B3121A000A
X-Stat-Signature: jr66y6uzkanys56p5cnuppktnqjrqwch
X-Rspam-User: 
X-HE-Tag: 1781734423-182494
X-HE-Meta: U2FsdGVkX18zT+Rh2oKmFh6aeTjQvPpols+yTeqci0rXHrJx6cNo1b8cFt+Y9czs/BP+7rDtdjPjeU7ambZzewFTWie5XKYrcGdk0vyRiViqiGLAVhW9BgbxAMZ8xX50pKxms3gxcyHTsoU4qEZuAsec4Ok1gQv/vdMlPFt02tWxndVI/7w0/3eQD5N5GfMtQPybYj/EMKO9OAnOLzhZ7PwHJsEVR9yox3lQBfxB7j4xvF6oEyAk/dXp69fP9yV/i4eg93pruKfjfH80ox1Dx1qesB8ab3bO+S2Rhnpy/a0msebCqyOFbIe+hvqx0T9E1O0jMyXyP+cJSFCR+OjzE7DelC2MrzeJyB7i7nohfhYQCparBqojH0Ttu+gZdtq7Hbml5HYrGFjVgIydHj6VOVTxWwPIulMqcp+5PXNRmEiX92RcoFhFZHhR7wujN9TnM9Wm+2C0ZigUz9NSaMTK9sWBsKG+9JgJUaB7B30BDXCCY/2EVKY9hd1LIfDxBD3qSw3ac3XHHFqHs3HAGE/b8q5Fp/BOoXlV8/4NJW2PG42Iv9Tuarxhs1yChQbDV/bxOw/FWoXzHj9/LxIUpFgeEmiFf8DdoQ2IHsYbO7UMtHDNnVLxuDcgLbDOp53eImlLRc3BEZ53WD7WqMfmcOXX0EefXngPE5EqY6e5zNIwNOP82DgPke2uWcgWS9jXnWcogAdFLEYdlSXwaJqqguvgWzbL9VG3h0l34DCG/kbWunRPawZprnC68oZ4PHalt3aDJNBMmmQjro0F7uq5MhedHtgSP3VbJ2uuCNd6+Ic9GP3eDOGMtSqsm4pQaVTzSr9SplfhA76Kp2g8KJZFid9BdkcY3tUAxAHlQ69EmhJimiL1nKkimF+RavRzKkDnpPaP64CN30Zd07+pzaq4oAgetJsavSKFv+bNNvCV/qZ+kcgk6wm8Vepo+Dmque55mLvsecQkUraqFTmY9cCPzGl
 lEg+XYxz
 ZtrdAzeT54sGev3c2XW5v4kcu4N9bTgQZaYAVgsDH4Yv1CnzotpWNZ77/rn1FZ8Tl9e8pALACavCMddAKi1gBDpZpDePjEkn1q6z76KgDR46mOmTvr4PnJSNVzrHMZdzzB7B0prQrxotq5h3eLYNMBVNbHEc1q9oPOSU2YCabkwiShjV5avOypMTI4bMimkRECLO+qTOrGknI/d3xzlhx8WauLKDsXKQAMe1mgyrbFbaBjyTE8hU4zYpKo7N5BTpzMKfTEdPwM8vwavct4agBi4mNdrSbxl/kzDEQMLFesaNyKm8c8vDOGmm/akuF/WvQ+f6i0rj//2B96fZVtvKe6ZR5UIDEQGpL/6Ak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/10/26 10:56 AM, Ihor Solodrai wrote:
> 
>  [...]
> 
> diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
> index 2b8e73f5f6a7..b5f430f2dbb6 100644
> --- a/mm/kasan/generic.c
> +++ b/mm/kasan/generic.c
> @@ -9,6 +9,13 @@
>   *        Andrey Konovalov <andreyknvl@gmail.com>
>   */
>  
> +/*
> + * check_region_inline() and addr_has_metadata() can run very early.
> + * For example, in an interrupt taken while identify_cpu() has the CPU
> + * capability bits temporarily cleared.
> + */
> +#define USE_EARLY_PGTABLE_L5

Hi everyone.

Bumping the thread, as it's not clear how to proceed.

From the discussion, we've got three approached to the bugfix:

  1. USE_EARLY_PGTABLE_L5 in generic KASAN

  This one is probably the simplest. We add USE_EARLY_PGTABLE_L5 to the
  files that call addr_has_metadata(). It's KASAN / LA57 specific.

  The downsides are a performance hit pointed out by Kiryl, and that
  it's an arch-specific switch in generic KASAN.

  2. local_irq_save/restore in identify_cpu() - Kiryl's suggestion

  This looks like a better fix addressing the actual problem of cleared
  capabilities being accessed from interrupts.

  An open question for me is whether this fix is complete, and whether
  the scope of irq_save/restore is right. We might also be ok with it
  even if it's potentially incomplete.

  3. Static key for LA57 in KASAN - sketched in the thread

  This is essentially a bit better implementation of (1). Still KASAN /
  LA57 specific.

So my question to maintainers is what approach seems best?
I am open to other suggestions if any.

So far this is mitigated on BPF CI with no5lvl boot param, but the bug
is real, and I believe we should fix it in the kernel.

Thanks!


> +
>  #include <linux/export.h>
>  #include <linux/interrupt.h>
>  #include <linux/init.h>


