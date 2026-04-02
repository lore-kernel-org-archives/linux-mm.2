Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EAC4CC6B03
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:17:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3806B0088; Thu,  2 Apr 2026 03:17:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B83AE6B0092; Thu,  2 Apr 2026 03:17:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99A26B0093; Thu,  2 Apr 2026 03:17:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A5A26B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:17:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6C861B80F9
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:17:36 +0000 (UTC)
X-FDA: 84612760512.28.FB77AD9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 07EDFC000B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:17:34 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWNfxyMb;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYzL/L+qEex3BSBVu+Pk9gG5FMiFEUh6MzbgVG55p28=;
	b=UwehEHD0MT9/78esZyCY0Zn21reh/NtR0H1dVxqXP4zlYvKyz7kRuSMIe3ymvR6aDVAkbi
	F2a1Wmde30TBfIxBuxXtB309ykZhCkWx1CwuCCOxFR8p73la3+xn12Wd+EHiXy2RwE31Ko
	EBNPrBMlc0yRrg/fxNq+nOS9qLPiMKs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tWNfxyMb;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775114255; a=rsa-sha256;
	cv=none;
	b=PDOyw9rT+0VL5mqSoM0bE+TaaxWdHh/Zsji334dXO5sMVvMwobX7gDrnq9IJKhlls3uzlJ
	PGvTk07z9e4nv48HaNf06BOx9RLCEqQ4ZXepEJ57zY/eCk59jbX6H/AOKzCMyRjoed3XdH
	unSPk0lBT1BjQRKXEmbJBf31vloE/44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0295043C9B;
	Thu,  2 Apr 2026 07:17:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75BAAC2BCAF;
	Thu,  2 Apr 2026 07:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775114253;
	bh=9HsfCw1/4CObUXs5PmJd2vxZ2Vdl+sbQLuV7DH+qT+Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tWNfxyMbnz2IZcdaaFxvmnAzxqHY7cqzBad16XaXaQRfDdcpOTSS/Bg9Km+GrIjbw
	 bFnKYln9gEeTPGt+IV1wb/8PMRl2wC3aiCx3KCk3FWRCnWgxnWpfNkEDrEEA+OoN46
	 Bpcw2G//cYWAQ9hA8aWLthqEzLugIgfZ+BbO4qccSsC6Jt9aDUizrzpUmHTqZZ9XpZ
	 dyH421+ruvurQc7C/WgG54ZvhUaoMDE5sU9Yba5Mi/MMOeRFbMTxasoqxh2jLL7ECq
	 H0dmUQB3rf+TIRyR+imIolzd3xaEiFT2EkmIpsYFDoaJ/Z0i7ngw+Pxj3Ia45Xy9g4
	 kTNnsdk9TTB8A==
Message-ID: <ca14b239-26db-479f-ba58-11e15f2379eb@kernel.org>
Date: Thu, 2 Apr 2026 09:17:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not
 supported
To: Andrew Morton <akpm@linux-foundation.org>,
 Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jannh@google.com, pfalcato@suse.de, Jason@zx2c4.com, shuah@kernel.org
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
 <20260402003417.438037-2-anthony.yznaga@oracle.com>
 <20260401174440.0f85ea303f0a027b50d99e5d@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401174440.0f85ea303f0a027b50d99e5d@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 07EDFC000B
X-Stat-Signature: gwu9kdd8oykobpewhgeucocnffnk6q7f
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775114254-159192
X-HE-Meta: U2FsdGVkX1+42j/dBxRbYrnaltjTGcsecLUokxXSoXGjItcDVJcVGM/RC3XcrshwkaReaT5xhbIKTXRmc5fFVWuRtWW8kg6GtFLXiMwoYLNGlC0ynq435uOTUhnMOziXsWG/lWIoQQwPfGNapNkIZ9MJlQSH0E2JkZZJolbQkvTjjNk7yEH7edNnsrmoPvoEOlNKQwoLJsdHBIAmiXcL10LF36cl2jZiaIYzM91iGxG3VqeUE/MdgnFVBcVII00+ofeQeIaE+/r60Y0Xxkb+2pP6gExEetY7MzCQ4Z5GJBHnmjbNirH6NRKUJsrta94Tya7whknWGfLrDJX3a+DQSIPE9hDenKYj08/1NGHHkjeRfLoRu+t6NimUgzn6rUsYx5o2EvQKfcUyYhJ3n1sQkJLvmhNb50TsjEMsRiD4nPbk/hkCptk6axZQWs8NT10V9GSrRuWCLxWr5iy1cCLEj94macHoMqogHv0NBN5AKoOLHF/6tQH4C9pn9EQoUQwzxJ2XME53W413xrW9OJWyeYz0xT4kLg+ppbSM8py4/UI1LLHDX7mnvgv7aCx398e5ULgBT38+4nGLLKJHAmFSqFkNiVT9lM7qcmXLeZ9zuWC8yUlE4VVqJmrai1VkAdp3VqBTrzFQhQLC6wm9SRTK1G/BKmE6ja2pW+hDdIYwsyu/neXE49SvlfYl9PSjGAN1fEfPBLjrV0PEWmWEYr/5bDeJIzVCOtZqMoD6Kptgr+O+CzWUor8EZ6Tl0AlOJetwhvYK+95fC5MQxOM8cpgUyH10YedFSwqHYDMBBoLexDjTywZX+CXz//M3IRleetrJl22FNkZ1/mhI/jzZYw0ovG1rcXWppNrVcbJHajPo2rQj4DW8lgxpqbE9yAwHzdMZDwHn4m7psXrkEFKchj9bUcQmo5bU7lBqY99PxnGPwRPlzXxA1R2dXOH8+B1UBH2/9Md42gvOCxyEr02HnBi
 06nSkK9O
 iJVRu2riTiEDKz/RiroM3iVIaaaMbYEy0z0HetdYa5msoKNw/MTHhiF9JMotZdxH1XwMOcy1lCihT2XxuYnig/UV75SZ+A180D2NT321IZT9pSjTXi4NE6jFhBDHuUBTVvP6Q36gpXs1EIgkxaqlyoyOvd7K10CX1m2wtOrZGHEmBZ7M/Fs6xfN7DlwwoEGeAR5cNf8SzGAyKYEKCJF0DP9gH+YtITvoHPyCom7uJGDj3hg4I3TTR7tVIQ4+imzuiks+UDwDMjPWOhlUlv0MwuF2rynAol4euwGtFbg/3DhQonxh2CFsfxAG4Q3ArzjEZFrIgYmqo6UCq7ynHjR7jc+7oUL0G6hFc+j/n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/2/26 02:44, Andrew Morton wrote:
> On Wed,  1 Apr 2026 17:34:16 -0700 Anthony Yznaga <anthony.yznaga@oracle.com> wrote:
> 
>> On configs where MAP_DROPPABLE is not supported (currently any 32-bit
>> config except for PPC32), mmap fails with errno set to ENOTSUPP.
>> However, ENOTSUPP is not a standard error value that userspace knows
>> about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
>> checkpatch.pl has a warning to this affect.
> 
> Sounds very reasonable.
> 
> EOPNOTSUPP is clearly a networking thing so what on earth is it doing
> coming out of mmap code?  Our poor operator is now looking at a networking
> error code and wondering what this supposedly non-networking
> application is up to.
> 
> But just that's a pet peeve - I lost that one decades ago.
> 
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> 
> Nearly two years ago so I think I'll add this to mm-unstable for
> 7.1-rc1 and shall let it trickle back a little more slowly than might a
> 7.0-rcX hotfix.
> 
> 


Acked-by: David Hildenbrand (Arm) <david@kernel.org>


But

~/git/linux/mm$ git grep ENOTSUPP
hugetlb_vmemmap.c:                      ret = -ENOTSUPP;
mmap.c:                         return -ENOTSUPP;


Should we fix up the other one as well?

-- 
Cheers,

David

