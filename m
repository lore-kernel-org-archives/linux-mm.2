Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD7F6C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4846B012D; Thu, 16 Jul 2026 11:07:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D056B012F; Thu, 16 Jul 2026 11:07:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F4EC6B0130; Thu, 16 Jul 2026 11:07:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D576A6B012D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:07:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 182741A01A9
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:48:29 +0000 (UTC)
X-FDA: 84994769538.06.E9EED9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7835F40006
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 13:48:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vw6wLQEi;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784209707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=688ykzG8ykPiM0npkBRxxK87841vXMSxY8kc1hKMOxA=;
	b=681YcRj7wfOkn7NNsG8nVVdJOcOrNUzhD7Yc/RdK1UpOU5Mr4IyZAHbSooi0avzna/ltnO
	XI4Mm4+MYxttZ+JzInk/zAHFuaeO5SeQ1/TYbFSjN6w+2UTTol/Gj4KfZu+FJ4Ck7QWkGL
	CgZjqC895za0htdcx22rrH3dkbgk0XI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vw6wLQEi;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784209707;
	b=d27+R6PPQ+gTgm0nKR/645/6sOj1dE5N2q/Ku2qQtEfPSkyBlab7Sap1si0YYuwTgpDcU6
	c3gKVEj1qYIVCtbcfvVf2HX7sSOIahrSCk6B8U0e2IsLrJ4qxyUgmehmiTkkA/R0GrEfSR
	/FnO2Kx2U6yyfm+7Pa05gwinz5A/6Wo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B2A241656;
	Thu, 16 Jul 2026 13:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77D31F00ACA;
	Thu, 16 Jul 2026 13:48:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784209706;
	bh=688ykzG8ykPiM0npkBRxxK87841vXMSxY8kc1hKMOxA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Vw6wLQEiSYMMzvpHWNRYt+3s4FDZunFyyV5t8QSapGHwdOhsx77TqN+bQNN/7FMEb
	 L4GQgT4YO+vgjsmgBgdlJoVoQ5ZTswchVmEhk5RFQAHrVxr/b6PH9oN5nBy9dgGlbt
	 dSvlgfGIR3yl0s/aQVSi6WTTjE3Kyw7dsElMXq7CaCIKdmBRp8bRnb3ZnSD1hlJsDx
	 E3Shg91EctjhSOsnfJaxcg5IQOeFJ67cr/t30QEEQnQRQAGAtgl0NC0qGRQ6JmrPn5
	 hEhM+hu9x8pLt6UFbvfDoJm6yd8sUGeKX7E8Vs6lhu/lZt7cPVlykVglllQaXLyMS0
	 cRFOKSMgrYgdg==
Date: Thu, 16 Jul 2026 14:48:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm/mseal: further cleanups
Message-ID: <aljhBBTRUtLs-N76@lucifer>
References: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716-mseal-fixups-v1-0-3a9609bf041b@kernel.org>
X-Stat-Signature: 377h16npzd8dy7efsuisn5ia8h8j3wtd
X-Rspamd-Queue-Id: 7835F40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784209707-331353
X-HE-Meta: U2FsdGVkX1/pZFxH9cugU981LanxkmgX/pXBvY2FFVCoFAk0As4/alr9PbI8DEXoUCXtTKF4mjR9mLF0vnnn6r0t+53F9vluibSiNWxMLbIvDNDVTN9Rd7pJhuqP3BHfLgcehvUjj5Cpu0ZM66JzezvwPPntvSNCCT4oaxBTZEf7cDT9LlswOjDZzmzXQASEDdehAFLCiUy6xKxLnuRBlh4m92I9nLOs7nqgxrfNvjIu2XXz30YPzY5Ef5CYOWXeuIhONROdnm7XsItpcOTLFlyjdY/d9LX7vy7vv4pgZnIappZeknsi3DjI3hK93/Zzd6lhwdxwjBcDh26g6QROSTvINCHi0MOsZhq0UR3/fT1yozW7hUL+YyFFdJ7wOsGVOGGiSybNcV00a6jAnY23fl1ls7MpRwJKGFXMtBmIVLDv1VOesGc/jFEDzLduGciJAPY4p/LjIXWI1XYOa7oVjOwVyyuaF+K75XBk5avuKo7iM+m7o2BhkvyiJ6+SQQH7jppvH7jTx64E+LCbkiRcTwpliTFYzjv6YpJTgnjCUk/D0Nn2pHXwNomKABwfomNsSq4QX1ssnFYxEnyhy+ynTFMnR6gbxcROS2cdFNqnPfVlINnX9IcYM4vMAau9I0ckgblEQ2WxqUxIbbcZGURU4Qs0Mk8W/5P9L8Rx/JquYX5z+ab4IvVEX60aITDhoK8n9LFjKjwrqHFHH+52n62UaVrxR+/tRpdGI9vMqTigFAbr9osnIM+e9Rq/VyWLLMkuLpauL4hxwdkVlPoDwg1iQZYcn3dHrmbtkfEjty97L6eWbIBiuXUaJnJ6DSOI+xhG/+3zgschKHfgguyOBXnI10YxJnWR5iNDCUSDxgPDF/MSe1AfrCuX8zqQQi/0e2orTP2cPTzKtDW0XJ8Lbb/O+rGZd8wPzh1fsrskE6D9wI5c0CuIQNACu+UzcU7LHBPiC25Lznb1iki1oIy6MnG
 Ixw9qRWh
 j7ZGP9M/B00R2LTDrGfMbV10g0opHIsF8sDHQMxJdxfHHyMb97dD6eQln9NzyzoQIRoq0J2Kqsyv+NvA0VESN4/6bvhedvM2ZCodsD1+hpAasYP13yrp4eZmhkKDbiJyXdUjzXqspHFTI5hGVocVwzlMn9HsT9mtlHch2Ppr3NxjaoZwez5tk4jo0oRVqFMY0CqPJ6hPuZHS1SYpWOj3uFFnb/eAUh58VPB6gQz8CsowVUCAeUUzTBNV+eDiA/hiw1mT0kv9zq2oY/cxZQhURJxr3Eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 02:43:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> The mseal implementation is still rather confusing, so tighten things up a
> little.
>
> The only user of do_mseal() outside of the system call is the MMAP_PAGE_ZERO
> process personality - retain better control over how mseal is utilised by
> providing mseal_mmap_page_zero() for this instead.
>
> The comments are overly long and confusion, so cut them down so they're a lot
> clearer.

s/confusion/confusing/ :)

>
> Remove confusing mm_struct params (mseal can not be used on remote mm's) and
> wrap the actual system call logic into the system call declaration.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Lorenzo Stoakes (ARM) (3):
>       mm/mseal: remove superfluous comments, fix confusion around mm
>       mm/mseal: limit scope of mseal address zero to address zero
>       mm/mseal: remove further superfluous comments, do_mseal()
>
>  fs/binfmt_elf.c    |   7 +--
>  include/linux/mm.h |   8 +--
>  mm/mseal.c         | 156 ++++++++++++++++++-----------------------------------
>  3 files changed, 56 insertions(+), 115 deletions(-)
> ---
> base-commit: 59c684a9908d2e6f7a791f7f033eae57ec2b3a61
> change-id: 20260716-mseal-fixups-131ad0939de2
>
> Cheers,
> --
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
>

