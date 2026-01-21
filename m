Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F171AC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 20:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662966B0005; Wed, 21 Jan 2026 15:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 610176B0089; Wed, 21 Jan 2026 15:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 550356B0092; Wed, 21 Jan 2026 15:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4F86B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 15:08:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB297D3FB3
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:08:08 +0000 (UTC)
X-FDA: 84357057456.19.F71ED68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id BB91D4000A
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 20:08:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e4uPDbwG;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769026086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kxc8fbJ+YY/2mA4Y0hAPpk62i8tV5kY4KJhCC1TX1jI=;
	b=TYt5rsuAuB2Mou4NvmPG8T5ygD/aszxpm4E4a/ccCiGJFGHSNoxNGps1ISejujO4tWLJyw
	F3zf3PlFHv2GLVJJSFjLdUc7mkAMhQN7hPrUfVEZnWx16KxVp+VFS8tUoFMimaRC8x2DPq
	rLwDLCU9o6aZOXGL3IWifHOmOE7NY4s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=e4uPDbwG;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769026086; a=rsa-sha256;
	cv=none;
	b=N5A/nMp3K9DMow9KisWS/du3vHzTPMbPU420MxEZdEGD4y1w+kdmwga6pkEhQgTf6wsTzT
	+rQSo1Gz93wH1bqIgLOFsb7DwkRD/95XsVE35sU1HvwaglCCwUFgPchzEoOclEJuNehBak
	pr1X+RMFUEQJ1aC1DqneJkuyZAPolP4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D8874409E;
	Wed, 21 Jan 2026 20:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE712C16AAE;
	Wed, 21 Jan 2026 20:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769026085;
	bh=yqttsfp1H+CLzQVJq0KmeD/aQFf9NmqtJ1yLdINQEtg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=e4uPDbwGhe7WwGvbYMTyV0bUrH75qbZWQcxDllCsYJ3ZkNm/b4OHV9tHT2+IDNwoD
	 b0nb18sh7q+FJR9OgdJzD4TarzbY27ukhztPDZOvSKu/hHD+YluhAk5Rm6AKHXs+yu
	 R3JGxuBJgjd7278oNPiMQk2w7xbICOJVhyHvtMZA=
Date: Wed, 21 Jan 2026 12:08:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: ranxiaokai627@163.com
Cc: pratyush@kernel.org, surenb@google.com, pasha.tatashin@soleen.com,
 kent.overstreet@linux.dev, rppt@kernel.org, graf@amazon.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, ran.xiaokai@zte.com.cn
Subject: Re: [PATCH v3] kho: init alloc tags when restoring pages from
 reserved memory
Message-Id: <20260121120804.d1334ea0cc66b4a6de691cbf@linux-foundation.org>
In-Reply-To: <20260121143430.175294-1-ranxiaokai627@163.com>
References: <20260121143430.175294-1-ranxiaokai627@163.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n5169h1ixk4oejbhdsxu1t9k15yy4yot
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB91D4000A
X-HE-Tag: 1769026086-208700
X-HE-Meta: U2FsdGVkX1+LpaGmWJNM+bECEs4VaO4K4alt33vouP47xH9Q9qbOmmxIhO58etJj3mb9mU7ve/2yGw2OP2Lk7Hmw3TgiBc+9dSw8r0gYq96oeSIQ1FOZitiweAd1JFkaI0XqBG8Ez7HSeVxX3JdTUVLIlstGjYu7OFWpYetJu3NAZoC6rws+CkhZS3KeT+RWbmXohviqxbGuvNL698d6SMVHY9NJCnYaNyi7ExKUL0BU0xAh8UJJGK0aYsEfRxE54gBZQTB82F8KygQqKsOOMotwGTbX3xc+as/cucJSWkyHP2op6alHvhotOuFa/6pWWuBXe/6jkHzvdqyCNOAd6HpLPtoyTuLpK33JaXF+l9YQqI7I4BLDN0a1RkBPp7MvUuUU/Wj21splgv4I1SL34Bn9t9d9Oc6JDlwAPPo6fjO/O9u6aqkp338cke2fjK8mySplioBiA7f2UQlFDFxv6cZuwF5qKeC0PalWkrSvTnogek61Hozn60EhTMW0WNf5nU3LLdZKxkR3eoWZUXs7gcEBA9kINmJQUEStFnE9JeboNqGfO0/fkwB7uZ+KCxi6AixTKBXqjgAPBBAKjdhcyJqMmMy53835y3XESXnYEF6FER702cW50tteGHtKzxkHs+VtuVTsEAaVSv29savvNJnLAFSvIgm+WiYGJ4bEWHcHaDMnLoVtOd7fwhb8iIhVvDiBjry0RKY7PkJ2CL0+qf6xrPF5ZDSNw040eFY1Umqg7l9fBAU3y7PPD3ChnP7JYy+JQH7SAAW0hiUpjPuZD7rZxq6VaR0LIMTAP1k60CxPXp65tBhVw8OUMV4KovNvqCXSUOjgqwCn0Mua02oGiYF00c66us5eAB1FXKtkECMFbs0QwGqpB6UlcumUtdF5wfo33SPB5vqLJxQEipRY8ZP3JpWELqziMhX+qHTYEvVybxj0+swEyQaDW8WJjB3ebr+Yh0rakp6ve01TNA8
 /Apea3jl
 PECt7XifE07j8X1IMx3Du7hvg43TO/FG6WGy1vTu7utv7UNM+pKlLDKSCVqo+Q0jJ68HaqzaRm5zURZgNk2fKJLAvpnUtjQwDzemVxPsvzMF0mnJDNU5kd3kbmVGH4lXV643kvA7FD1ne4mYj1aa1X2Dt/1DrGqITaRyye0kwBts4FpfU78dbjg80UlQR+Xm2otsP+RsDXMLYb15GLyOJa7+PqGiT8aVqRa4QkdCpgfkRiQJu7wwZ3h4oJXmdm6/PBDg2cXdvrhk2+ainY0DgK1RXAKmPu9bt4JstvrrCxa75oQs3zf5PCo6OT16gkj1xl828MANHT87c5hw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026 14:34:30 +0000 ranxiaokai627@163.com wrote:

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
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
> It is based on linux-next 20260120. I dont konw whether this base is ok ?

It's awkward.

Your v2 patch was based on Linus mainline.  This is appropriate, as the
patch should be sent to Linus soon and it has cc:stable, so -stable
maintainers will try to backport it into earlier kernels.

However your v3 patch is dependent upon other material ("kho: simplify
page initialization in kho_restore_page()") which is scheduled for
6.20(?)-rc1.

For a prompt, backportable merge it's best to base the fix on latest
Linus mainline, please.

You didn't actually describe why v3 is different from v2.  If the
v2->v3 changes are just nice-to-have then let's redo those and base
them on linux-next in the usual fashion.

Unless I'm missing something, your well-reviewed, decently-tested v2
patch remains suitable for upstreaming during 6.18-rcX?

