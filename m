Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8915C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99A096B00A8; Wed,  1 Jul 2026 14:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9720C6B00A9; Wed,  1 Jul 2026 14:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AFCC6B00AB; Wed,  1 Jul 2026 14:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68DAC6B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:26:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF9A38DE33
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:26:31 +0000 (UTC)
X-FDA: 84941038182.24.24DB067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 25C5F1C000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:26:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YNwgVQ9I;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782930390;
	b=ZsNpQphN0c5Jr8P6g/NoGz/dEZpvcSv1dyhgjyTELGIz7G+P+NU5inrpyKLS+93X5SX+i5
	W61XlG9/4/DUE/9RUKMxvgMvPtQUQjU2o+S4MtszQwgeaAGrV59kAqT4BP1WxmzdxMpkH8
	xkhCRMKwC+ar+q7NfEKdSHj2tbhu8f4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782930390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g9i06FIH0E9eZuhdoALhn5vbpf3Afs02wevJ92Wu4uw=;
	b=z10zRrsn/BeJ6PuYhvFnQab+4sW7escNXRlo2oIpHwvM/XpQXD0qoPdbpJCy346k3BSUom
	Tpf2o3N29Na/n5SQXvJyuAbCUpZ7qC6+nufMyqiupXTjgiT6ysCP671NeJ0zXEOoWrP6mH
	qKsZsKoWM66pDB+FGday5G/4fI40aO4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YNwgVQ9I;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5896440782;
	Wed,  1 Jul 2026 18:26:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F052C1F000E9;
	Wed,  1 Jul 2026 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782930389;
	bh=g9i06FIH0E9eZuhdoALhn5vbpf3Afs02wevJ92Wu4uw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YNwgVQ9I4yYUv4Nx9sgChnHGJe0glWe80sv6ZIeLAU4jOtnBO+AeAEF9JTLZUGRJ/
	 pL2X1NXlIaMIAEyAZ/9BcQBN4iFQs85miKy3JPq4WZiCvCs/wEHKHmhdgi5X/2fXz9
	 PFHtMOGxfFa0ukFJQmGDr8MAa32Rai1NRdgPvGT4=
Date: Wed, 1 Jul 2026 11:26:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <linux-mm@kvack.org>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, David Hildenbrand
 <david@kernel.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH mm-new 3/5] mm: mincore: replace __get_free_page() with
 kmalloc()
Message-Id: <20260701112628.7e22f17c6ef12771cd3d3649@linux-foundation.org>
In-Reply-To: <20260701144047.3786939-4-wangkefeng.wang@huawei.com>
References: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
	<20260701144047.3786939-4-wangkefeng.wang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sfnx67ey97bju3hdqjm5z536i9nmjybr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25C5F1C000A
X-HE-Tag: 1782930390-418879
X-HE-Meta: U2FsdGVkX18B7tqPwsEXDVtKD/BF+ArrBVCrTSube1vNBOo/yfPUcOmnyw9FmexrIIfNqc9Z9kdu88l4ulh0lPNVi8tEXzftPjWNlA2VktKgz69b+qkd9s6X7W+u/GBbkS6zrno86cJyiQOOUFyTjj35EOg/TqqjGu7iYOHIq1wRsaaCM/dp/I8kUGYAgNaBVrJnaYbTPbYG+jpSJBTf9H4xVMr/E+d8vM/YWnABLr85Dj9ydoZlh8MtVHQFoOi2CimQjYCJqwyt7/IiT2neWPtCWSXWhugtBiU3vm+JP8sruTk30I6Lb0Y5GHm5eaA+Xjq+hZ+hbLHcehobkvyjlQcGWHbHDNBV58P5o4IZRXTIhRhCG8hsTB1AGDLVyFmndD5bPyNIKUz2A5bynVPisM3ZCyMNQiO0vw2ItQQqauMFhw/1xn1dCIra++gT+KnHc9NPsx3VjHsAVzLYS6IAt/cpqLBRHYpg8UuomNXzisgp35Vz5RHw5cIS/mp7I2yfnfo3n0DfVEYWCvAFQIE/VHeiPwS7/nQqGjk9AR7GEzrybHnBKROE6QlZ+qLaY1k02VLiOnGqbEMYsHgQclajztCeM7RcOmIMteqekpG0ueZpAI7NuSLE1AJvadLd8iqWb6FoqEgqWDOlCcO/H+OlanHCY6fvpLKDcOlbxZcIFgeSBTKGG8VldpOpACsg8mD8jmaz42TENmpRgwmjK88Lw6B8RY72pDwgwk4OHhk4Enh1NRn4CSrQHmlU1nyHPre0up7n+zUi8ANBz3VPjR6MzkTgCLXqBmqtbKDZumYP+fgFw3P/5TfSy0BwJ+L60aPnwti63yTVT4/gOEWOiknc5KSoi+Inrdrmcwi8HUBgHRP3YK2EnPo+3hmhhvi+o7uNZpEvjeeZimdYh0+w8oUze5bxyRN1rUsBtLLcWCIyaLFXLePp/TX1/tyBd+tf4oLkB4tU5zqySDqUyxLdZqD
 wMzS+bHG
 QS4AbhpXnIToSzOTAVNUaHGBgCLioclkmzoHDqe5qR2beLw8G/kr1E4lTmyehh654jrsa1YxZ6UCykc+hpyxgELXuQqVqlW2f8O1TlKSpp68iOqzwmNTgjwuQHONjRBLPcphLTosD1CnlWfMvPDOAA8lfT+xg1SIARp+0jmrRMIcDltRFXLwqE09+AnjmUprPCpVzcb7MxylRwpKx42Um2AmhZBxyxOczZvcGq/esJOQgeySzBMUO7rwSrnz2dSWLTLn+7HoAJGJ6mxQch4UM4VSho26G9mIQH22KCjf0aLKpYJREw2LjzG0O0b5DogC+Vlpd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 1 Jul 2026 22:40:45 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> Remove ugly casts by using the more natural kmalloc/kfree allocation.
> 
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -13,6 +13,7 @@
>  #include <linux/pagewalk.h>
>  #include <linux/mman.h>
>  #include <linux/mmap_lock.h>
> +#include <linux/slab.h>
>  #include <linux/syscalls.h>
>  #include <linux/swap.h>
>  #include <linux/leafops.h>
> @@ -312,7 +313,7 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
>  	if (!access_ok(vec, pages))
>  		return -EFAULT;
>  
> -	tmp = (void *) __get_free_page(GFP_USER);
> +	tmp = kmalloc(PAGE_SIZE, GFP_USER);

kmalloc(GFP_USER) is a weird combination.  I don't think GFP_USER ever
made sense in here.

>  	if (!tmp)
>  		return -EAGAIN;
>  
> @@ -358,6 +359,6 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
>  		start += retval << PAGE_SHIFT;
>  		retval = 0;
>  	}
> -	free_page((unsigned long) tmp);
> +	kfree(tmp);
>  	return retval;
>  }


