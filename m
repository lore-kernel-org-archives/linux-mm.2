Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3517D3EE67
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52496B01F6; Thu, 22 Jan 2026 08:35:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFEF56B01F7; Thu, 22 Jan 2026 08:35:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01806B01F8; Thu, 22 Jan 2026 08:35:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0AEC6B01F6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:35:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 732D61AF7D9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:35:47 +0000 (UTC)
X-FDA: 84359697534.06.BDC380E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D9ED01A000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:35:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mrM43KnI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769088945; a=rsa-sha256;
	cv=none;
	b=0TweX7hdc9p7JXCSfOxhvi4nEtc/4jzthvrhTm5F/Y1JG/Ll9mvE9Dg5mGuH7qn1kBLuIx
	E1Fejo3JGLIDrUdZphprW/Y+siEvXBgAWb3tDq/6sA5tXlCrfovJR15uOHuDZMgQIBqcZq
	3Iawn818qwSyl7ReoHhhRkzwtdv/NW0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mrM43KnI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769088945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gh4XtAj9AB3rY76cV8CWTGYjLU/b8KyOlaB0cJ3cxrw=;
	b=lPBDl4XvRnmyZyVdCGqT2Tg77d70z+lJ3+wYNJdAJdcR402XxYw7KoGLo+emfPVtMUIV2x
	XZyGNi4Smcy5U4d0Pk65SzG9PqqgI237RAdLDg/ZN7P4QIewOjsmzYxK5LTGiHCdbojlSI
	0hhSlFf9K/x28gE0tCEMHIf6c37a13w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5034B600C4;
	Thu, 22 Jan 2026 13:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CE5C116C6;
	Thu, 22 Jan 2026 13:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769088945;
	bh=wED3dXV0kHkiBnPWNUBgYlSUdtgP2fArJ/kzjZEMltI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=mrM43KnIhyHDnc8ivUCX5HTrM9Pl42GBN8gXbejQ3Jl7OGoZ6s6TYv7Q9f+Ds41mV
	 +atyWBT9K1XOmZr0pF5xVDisRvZ3G+sA0qlf+8xqzuMhEvZp4UEln1+29gf3zF8UIM
	 hDr0aYGQEDqiPxMYnxspQa3y7BzZqMUsjuoGrP0jIAK+PgK0D2VLGCIn2k5S95TWLs
	 uieNDly2PL9lHs2HFOjsXJgRHIrcw5486a5jYlh+T2wfAUhDov1hXXSAUo6cTbh/uZ
	 yD8mWEN/VEDP5hyMTo/uckvNJclqUK7clMtEpzkS9kYenRw3CDQY2ZRB1Qh1ai61Ql
	 pXhD2DGjTqOBQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: pratyush@kernel.org,  surenb@google.com,  akpm@linux-foundation.org,
  pasha.tatashin@soleen.com,  kent.overstreet@linux.dev,  rppt@kernel.org,
  graf@amazon.com,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  ran.xiaokai@zte.com.cn,
  stable@vger.kernel.org
Subject: Re: [PATCH RESEND v3] kho: init alloc tags when restoring pages
 from reserved memory
In-Reply-To: <20260122132740.176468-1-ranxiaokai627@163.com> (ranxiaokai's
	message of "Thu, 22 Jan 2026 13:27:40 +0000")
References: <20260122132740.176468-1-ranxiaokai627@163.com>
Date: Thu, 22 Jan 2026 14:35:41 +0100
Message-ID: <2vxzcy31bwia.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D9ED01A000E
X-Stat-Signature: nb45yjgjc654sbomy7oc9idpj5ep9ig3
X-HE-Tag: 1769088945-162528
X-HE-Meta: U2FsdGVkX18H/PwIGSSpcUFgTFawWTU1VM9lAfItgoj+OdY5u0LvIonF1sd4jnOixF03J8ZqdhxIX4uxBcUXp1lbF70P8rAeEt9/p6xhDv3/ZdFzdtxcIsRfEMaI6bUN0u/Hu+44Xg3V9W+Vg8U9RIz1bhIXsIfy4Cp0f55aXzOS/RP/jQ+seQ5fKM0r5uMQv6F2reINMcXQeo34EOHu5vRq/jWmgIL+RiRPK4h2KD9Byk+ugDODbolTES0I+RHxtmDVfpEQoGLtyIyJ8B+sKauPmgbTry7c65Em/MgTbuetVDcVmeCO0lKOCW5fe0P4OnrfXiueFg19y4syEgwTojzT7Dw1SR+WUks845bipwpHRabyr0iO9YeOcoCddECHq49jRh9YWvOeVzKOymceNpbwAew4IKWLijEK5+Mi/S8UMwlO2+0vuRce8eGzz3VCVMqgOmwHCaEv+c9OBIO8/YRQpO1f2qE4jufmzmngr+Jt/O1WVL0nAneC/uZhWlBYDStYTJUP6AxTKMgtVUWU8PQgtL5T7CET7PWZvHyCAFD/v2vO1cJx/bnK+Q0IzGksSUubbewVFYPCrZoXOeLcrCmwYdo6Ooe9RFpF7BiVzx8CW6PweiQExzf8L6kj6B1o+DRKpTtSIJVcIZgApMJlXdBNP6LCgo4dNToNz4rJw+Sl19gEzOlXz0KyQMJ6+hjhhTKIh1G4M+ODXoYZ23YgixzXxHRfBjQlyZBMhwG3lwonOiDNwliLbimqsn4QQnIneAsE/EJKAgiEfKjUaHZmHfQyb/v1Fq5xGPjgH5B6HDn5klKsHpSGdWLG3iKnV6jyiHI5h9GMMAyUQarrVM38IbrmKI0wVoRcoatmCYcwO/z+/Wo0UWZcW2/Ij2C31QmaytTvmMjerjYiDpLFZgWr8U+FGyPICWy2S4Bp5gOU3FX6banemT72d3ub2bLm+Q6rRt9dRJ+TcFahKkhsNEF
 aEumlbTm
 n/Djk2ghZXVYFlkm8qXVroLpNFwqVTL3RdU2hYP5y44hwmF5nlygv356Z6o1R65j+a3YAxa8y9GS+Mv77kUxkspep9R29N5d6lL4kisB9l2/+zzMmIVj0SRNTHXcc6OpStd7LLm+aiir5qXbCMZbllGzFunoVDKWxJwrBsw+uDbV96Dr4fkGmVpLkc/3GYVjdIov2qQNsdMQBFfoZKwJ5V+MExPAMxoedagK4OKRltwaKI9Sar8/vmyHMcV/DAXzHVLiXZkvZfYyWZO3D/702XRT8sg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22 2026, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> Memblock pages (including reserved memory) should have their allocation
> tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
> released to the page allocator. When kho restores pages through
> kho_restore_page(), missing this call causes mismatched
> allocation/deallocation tracking and below warning message:
>
> alloc_tag was not set
> WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
> RIP: 0010:___free_pages+0xb8/0x260
>  kho_restore_vmalloc+0x187/0x2e0
>  kho_test_init+0x3c4/0xa30
>  do_one_initcall+0x62/0x2b0
>  kernel_init_freeable+0x25b/0x480
>  kernel_init+0x1a/0x1c0
>  ret_from_fork+0x2d1/0x360
>
> Add missing clear_page_tag_ref() annotation in kho_restore_page() to
> fix this.
>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>
> v2 -> v3: 
>  - also call clear_page_tag_ref() for non-compound order-0 tail pages
>
>  kernel/liveupdate/kexec_handover.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index d4482b6e3cae..96767b106cac 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -255,6 +255,14 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  	if (is_folio && info.order)
>  		prep_compound_page(page, info.order);
>  
> +	/* Always mark headpage's codetag as empty to avoid accounting mismatch */
> +	clear_page_tag_ref(page);
> +	if (!is_folio) {
> +		/* Also do that for the non-compound tail pages */
> +		for (unsigned int i = 1; i < nr_pages; i++)
> +			clear_page_tag_ref(page + i);
> +	}
> +

I think it would be a little bit better if we just did this in the loop
above instead of looping again. But I think it is fine for now. I can
fix it up in the next release.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>  	adjust_managed_page_count(page, nr_pages);
>  	return page;
>  }

-- 
Regards,
Pratyush Yadav

