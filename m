Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BFC1C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 17:16:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B8D16B0088; Mon, 31 Aug 2026 13:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7900D6B008C; Mon, 31 Aug 2026 13:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EC46B0092; Mon, 31 Aug 2026 13:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4935D6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:16:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6674C01FE
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:16:39 +0000 (UTC)
X-FDA: 85162218918.29.F345C51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1C40020003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:16:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EzzJsIrV;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788196598;
	b=MNLt5cfgHtwz1ZbdOubH92U5an2zz8LVlJbvcJX+4RjsjnPPH51fskoHCzhIQrEHFhxkxl
	McLXpRMwZPnDD0yqy2tq8/IHzZzq11a+DjuCb5FMsYZsljnHRWI5yVXOIv37sgH/xSn2BN
	pgBOvnbet9CQLRLyQzKSIFUnTLDpd34=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EzzJsIrV;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788196598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kUaWdR9O4HzkDC+DSBrS4R/dmcOoGGm7UramsGCwQrU=;
	b=8brBiYhFBlarLjC/nRbXirCiH/PJSMQee00ldKT2Qy1GETM4qHszOBWkh/C7v5oAHtvFXq
	SvhaE3xePopOm4XH7iBph05UlkJ5SPQo+3dlffHfuhkM+P165BPU8r5GTYv/6HkKYuOJ3F
	RyhdLKdaQ64V4MKSuaOrY/aKGKT1jj4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FE7E60120;
	Mon, 31 Aug 2026 17:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EC31F000E9;
	Mon, 31 Aug 2026 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788196597;
	bh=kUaWdR9O4HzkDC+DSBrS4R/dmcOoGGm7UramsGCwQrU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=EzzJsIrVgH3Wyi7L4/wU3Cyz6vEsvdK7ZdVuf3tlrOItrdEPGhti+wiObeuHCtMDw
	 O7B4xl5+NNRTjhTwWoVZ+UG7Yh1v0a7jHtkkbI/wubyeWn6REdP9VZM4JHbSVfq9ga
	 u7syyMwRhz82tT4Pr3td9WK77+mNTWWaDLHlKtGc=
Date: Mon, 31 Aug 2026 10:16:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmpressure: remove window size TODO
Message-Id: <20260831101636.a714f7171af108d520d4848c@linux-foundation.org>
In-Reply-To: <20260831-remove-vmpressure-todo-v1-1-498515e59cdf@kernel.org>
References: <20260831-remove-vmpressure-todo-v1-1-498515e59cdf@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C40020003
X-Stat-Signature: bsjyx6s5uaoh86tie8e4xpor1hdtt44b
X-HE-Tag: 1788196597-553956
X-HE-Meta: U2FsdGVkX197RXBwMt1jx8w3DSh4i3wMR9ZpHLNEO2IRcBkzQZYBNfYKjMQeE4l926qkeXohsuMIZOKK7GS+TSnJTzeFvhWbNbA9McYIBSZXuF3QVQH7PC5C0f/k2ZtU5BCXVjRd6o+Qh/I6tuZS8e1N1+FRbcLGou05orCxImN2UgQoKvM014HUx2h3o5Qrk3co5TUkl9Loi0aqiSlS05c4ByVRMgUcKXMYbkFbb6gdXXzz07oe/oosRwTQjvlyKx9Fx1Kmxh3eTtarytLqpbQIauULx9up66pShlTcF0Jj+SJQKH289EGdRN47rHik0CJv2FtV/piYjqXg7rZj3G/D7HeFLYXK7xR/onKbVPC/RgqMI+oVR4iF3G/r3mphiRfPXeoe7iDZSO3EqM3dgaw+xKBMHmCQPpXKWBiAYjpJ9JUCGSNqEp5jye6MjsaDOplehl034lus1eoXxhJkMBsjsWRmd+24imZB8DMgA5YRH99Z+631dPHvQn9bJVIUUYg4JqjjWwSJWjU19jaTj+iX3TH5Ag7Rtny91p6rjMdKfqVlTLVW7VxHJBKX0IB3o+u8wnam0VJkIy7Kr5AQVAuLhPLkCUFgk2uQCLwy3nvqKny/3aJ0xEHt5Bvo4AuY6deM5bcokkVGkr2hbh1tv+VagbAIEt1wa5bk0tIV/GyP49WYAOONtcQ5ZCU32i+NS5YS8YONQ+YPi2AJH7sJABd78RlnEehvX7HYSsNJ5uKn6eV/hWSQqlHHtSOsEZ3TcoiqnHWeEZX9XwmPmEUx85MI4Tn5xSgkHBsfgqufyvLLSyCj4h98Hk38cfc49BKB6mNUGPWmbkkP/L8gciF3HWunfuk2M4RLaP0sisTyshH3zX+kMQR1e/hfRxkCYWRG1EHpexl1LhBhW3py81Awenp0O/fW9hfCGMMN9kHUp+GcrTbul+wFABQUR8vCDSKLWLI6Wpb+HAfmDuinnHg
 7J0UyhTB
 ZWbf1MVFGc8pupv5me/SjtB3gxfjOTfaG4kg0M7Tgz1t+vS8k4FomIBkLv8O1Z990HOAK2RkmzsXkeYSdKFagmnyblVlxeD5rqsa5A0ZpjzaeK4gfEjouXu+va3yQMNUfoa966e79z049EG09CopnpqT0NsBUn5Jq9gsGFmarVI9zx2Zeo6unGOvPkFleu2Ss5Y4f8H1hna7nhaYMmOfV2qAPPNSXtR8f3tV70WpTQqtG9Q6FrgQs9bUBc/fLep5cG4I+QtzQdS2b7ec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 31 Aug 2026 14:42:11 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> There has been a steady stream of patches that have been submitted by
> newcomers to core mm 'fixing' this TODO, with all but the original having
> very likely been generated by LLMs.
> 
> It appears that TODOs to LLMs are like red rags to a bull.
> 
> In addition, TODOs in code often bitrot and are distracting - those who
> understand the code know what could be improved in future.
> 
> Therefore remove the TODO.
> 
> The work required to actually fix this TODO requires somebody who both has
> understanding of the code and significant real-world data to back their
> changes.
> 
> Such a person doesn't require a TODO prompt to implement this change, so
> nothing of value is being lost here.
> 
> ...
>
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -30,9 +30,6 @@
>   *
>   * As the vmscan reclaimer logic works with chunks which are multiple of
>   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
> - *
> - * TODO: Make the window size depend on machine size, as we do for vmstat
> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
>   */
>  const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;

otoh, we could enhance the TODO to explain these considerations.  This
might result in the LLM warriors submitting more usable work.  

It would be a strange place to socialize these things but as you said,
red rags.


