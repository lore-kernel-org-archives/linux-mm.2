Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BA4CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 11:04:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684806B008C; Mon, 24 Nov 2025 06:04:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C166B009B; Mon, 24 Nov 2025 06:04:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FD9F6B009D; Mon, 24 Nov 2025 06:04:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 38F1D6B008C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:04:45 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07C23B8345
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:04:45 +0000 (UTC)
X-FDA: 84145217730.25.A463010
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2913A14000B
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:04:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h/v0K3u4";
	spf=pass (imf26.hostedemail.com: domain of smostafa@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763982283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IxY0zFsSsb4UvWV8JkswEu93uViR5DhGzNdHTRi5eEs=;
	b=yTTkf0d5a8HcsTam4YtS14hqQKLRcZjYyycaozC5KmeLK6wU2j5fHqcDMDtH16fim4NfXy
	IkQupo0ju48eS3yrTNsDr+lrgCPe+WKoqGeFSaq6NeMJUUHw2hb5jH0kmF3/Vkaf10xH0Q
	sg7GNKQnYvD8fK0TffQoZbW2t9xC0wA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="h/v0K3u4";
	spf=pass (imf26.hostedemail.com: domain of smostafa@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763982283; a=rsa-sha256;
	cv=none;
	b=MgR+MV9IonhKyc2ql1cdrgG8QM5FZzxDU9FOPhER4P8o8PtIxznHGUL8TwC9k8zsJO2nE7
	KkYNcbjH0A0C2a9eEg6yNOtGtlmlvsOt1wZSuie5FRG09PfItzJ1GkaSjvv1CCnIk4hccd
	C4Jl/2P+ICzEtFEnA7E7r6Hq61sBw+4=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4779a4fb9bfso90835e9.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 03:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763982281; x=1764587081; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IxY0zFsSsb4UvWV8JkswEu93uViR5DhGzNdHTRi5eEs=;
        b=h/v0K3u4RtLE74ZPfVj/CizrDO//8YczDoBiwSMUJlMW35OnArUfy/bxAmmmdECK9q
         c/SVg1blAOffQIkZbaZSblMJn0ExqnStTc1pmh4qJtOdr8QHDSUy0LseAS+B8kArm94t
         WZlV9s3R52UH5BVJZAB8vrbR1jJN2/uivOlM0Muf2i2CqMwlqUYNVaOuvj1R7myVigYr
         rNBzhQFQDKr1zMzXR5SiWNKmUFVN3f4SAt6EuKCGvE0wgtB9b1dkgtK9naOgu3EnTJIP
         isI+rxAwHXnd61yGUW5JQXTI6HLNyiJfPSW91mSuylY2QqQ5kUqLMQZQ8sfkH/rd+w3e
         DN7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763982281; x=1764587081;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IxY0zFsSsb4UvWV8JkswEu93uViR5DhGzNdHTRi5eEs=;
        b=MKbiPmbtVjrs3eoUXVNCaBvb1aPK1pzUghRMSb2w87XOP5WjnFu6q97hWF3W37HpIo
         UsZVq9mbi2rIXRkhNl920lFuka0OzVTL9P/3M1zyPvlOuU1cCZPbOL0QTGoPGJ+G2bBY
         J6qgYpVLJfKOAd62eu+JtsAHh8pdo35Nr8O+WzvMwkr8PBJPamCU8m4yqM4nPe2VbUeJ
         dHv7V1s3l1uYrr8d9v4O7uJ/gm5Li+tTBOA+9I6CL4RxES+Vun0tzgYDljAqH+r/cGJF
         5aM8mNOnlqV54GXvig1NNYyfvvGAYPvYyfEpDSnJukFCjOhqvEKxiWVy8scHmd+h+LLS
         eZ7w==
X-Gm-Message-State: AOJu0YwM2lMfRKBEUYiTBnAahITXDcdT7+8+Ilg2GXt81VRj60Wy8mci
	zhv/0kzw73ZlqrBz6AhooBUeB8pWwqSe4kJOGhapzZ/ggIZRt+weWpp19DMsb9LdPw==
X-Gm-Gg: ASbGncumJYPIL3lM8FWPofGbAKdmcRIqW9TnMLY2HPzddZkFJ2sOWnLMAhrxosD8Evm
	2ffQCO7TWNKE4qErRuSZw+7NTaa4qyZ+1rQgtmNV/LsBntIrl0hCDJWs+1v+gDl1VL8+yR3sbC5
	YVUIeZBQS1mtPDB8ElzwoN5MZvmccNU62pTpxVE0vw+kv9671aQ7i5WXtQmJx1s/DRmsomZRuF4
	JjJsRy6jBZkHhyY9cxOVt0S0MO3wgTn9JZ210p/7zYes7ERezZzQHeQf3/ngab432g+w5ePmzOE
	3Ftdb+f01CV34ECaoc586vuOGR8gPlOyBoLV9fgRSvtfJ1IHtOK5H9z1rnn/BWEY2R6VvbrxYiM
	RMC5OoVYhY9ASNf4NVzJj9/T6clpTVWRiC0ZxzcOFbiSuYEXrlQw2UXPOU8h67aM0Z/01FrFlcc
	354QXoTww3CUm9U0VyN1RHURPtgGf2XDdlHCCbUXusBIFStfLy8Q==
X-Google-Smtp-Source: AGHT+IHfC/zx3CtUqS+QNQEXWjnlvj8ok2cj2JsEBQqJZIsdvVIDhcfsaBV55OT3BOjTGNisyGw1Aw==
X-Received: by 2002:a05:600c:a402:b0:477:2f6f:44db with SMTP id 5b1f17b1804b1-477c5ea4a1fmr1591355e9.5.1763982281333;
        Mon, 24 Nov 2025 03:04:41 -0800 (PST)
Received: from google.com (54.140.140.34.bc.googleusercontent.com. [34.140.140.54])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf226c2asm188677715e9.10.2025.11.24.03.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 03:04:40 -0800 (PST)
Date: Mon, 24 Nov 2025 11:04:37 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org,
	Qinxin Xia <xiaqinxin@huawei.com>
Subject: Re: [PATCH v2 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
Message-ID: <aSQ7xfQjkeAMHiLC@google.com>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-2-smostafa@google.com>
 <55391dad-339b-47f8-8996-afe337b238e0@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55391dad-339b-47f8-8996-afe337b238e0@infradead.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2913A14000B
X-Stat-Signature: x5cmw3xw73xuudrmx87esckoomt4z5ps
X-Rspam-User: 
X-HE-Tag: 1763982282-69556
X-HE-Meta: U2FsdGVkX1+5KE4JVkre9pMhwYFAwT+vjp58aB7TGfEc+IvDRQz7TFAeq1C7gH0yEwES3bqAG5KZ3d5S9UF85qOE23N7rdtwPsFhSy2/Jwk93Ug9FFqgK840K4zhqrd8pKDKjQve7rNRpNxqu6C00Qu+Qi5rANu0b1vKVPYezlSawXNghNjo9ea6DOc2tQPnFc66UC6vrJ4rVI6r4WOgU7cRI7Uq8ghv/2MAMe2MetcZCREBv3Dm4nUeGkTVhqByDLdApdhoD66obNK0Jgo2q8gQIFBiAqIEo07TE3bEOH/j6qek3P8gqcdVVOqOm99x29wSDiLAHwwSrupUSnRs13IM6UHn6ZiWIl6V9Aqa6wh/xJcTIMauCorsETl3QIyGhiUlxosP/k3y7GRFlXbd6M+1YyuNXlwvO3ZwApv2ABV5yWBhHlUNvw5NUzBhf8FNIGLNAaMFZ4w3L3FeFs1wQ/A6IdfYqM8jVtCbPTsP7DGxL8teOk/z6UAiab/LvmCOeLFPJYESGIrk3JKjsSurd93lU95hbkYTp82/aJFTT4Et+LeE/fcSUkc/H1crSnDRegz26XS/K9IQqFhBB0y/72uya9+sGSiGybNJ/9pSgCcdOZYs6bz/f8BlJHTmu6NoFvEiVn2GzlFYtagv0biBvQJg92IgEwnmfX84m0AbPrOZRMyYqJDZQycPI17wM6H9om+6pkkAkW7jJOYdNTpJEhm4IMWLS/rCgKeh7zyaLo0w/c/fzYxCHCNDXvBrlfnKU7jZALjUZ1JTBkSLlWNB1qezVRhsj1syXJaIdicSmpTM3KK1YdhGNVjiikiWj+uHx7qq3My+ccv7IBtxhl1PJrpXLSisUDed05V0g+PdPxhMGA9qFX+BkKUAybYW5rBOfl2SNT8qtbdLUBI3i7ARKaayLml0dzOC415yuYw0VRH376bPyJTdsc9YNXPY5oH8WeFBXTuN2qXsr/RSKYQ
 Kv/mK1f6
 0KabS+6UA9vy58K7IuuL6lUIg5+cKCerai8gnaU2OI1j+HGj8kDkt5dUBrmcUPOMD6N7BgslFlewf5refHthMHbtvdTohu95hySfPaUjQ0fGhYgVln92Le52asJUaTGomtxxWrybliggDEengaZ2Uaojm6/P/QZiNFmvZZQf4en1MBtLVj0FzkavIhfsg1joDujtujsWG5wGSgjloJTXHnoPNXeiZVrdw2dq7ldPIhUm9RrBk0/A5g1VDK8AL8x4P6Gat4Dkc0qn3ZNllUDuol5tckB2fa5gl3laMHzfHSRjH62kOoITsXALNArhDIP+IF7JpgNKJ8h9L/YyJiTTQqS1BFLSAjdCuxE9lykn3zkdp3uqgenEAyw2K5tV8kCM3wB5QTqSKCmzWHoReUuVT9agmJXQixndEswdY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 11:50:11AM -0800, Randy Dunlap wrote:
> 
> 
> > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > index 70d29b14d851..6b5e9a2d936a 100644
> > --- a/drivers/iommu/Kconfig
> > +++ b/drivers/iommu/Kconfig
> > @@ -383,4 +383,19 @@ config SPRD_IOMMU
> >  
> >  	  Say Y here if you want to use the multimedia devices listed above.
> >  
> > +config IOMMU_DEBUG_PAGEALLOC
> > +	bool "Debug page memory allocations against IOMMU"
> > +	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
> > +	help
> > +	  This config checks that a page is freed(unmapped) or mapped by the
> > +	  kernel is not mapped in any IOMMU domain. It can help with debugging
> > +	  use-after-free or out-of-bound maps from drivers doing DMA through
> > +	  the IOMMU API.
> > +	  This santaizer can have false-negative cases where some problems
> 
> 	       sanitizer

I will fix it.

Thanks,
Mostafa

> 
> > +	  won't be detected.
> > +	  Expect overhead when enabling this and enabling the kernel command
> > +	  line iommu.debug_pagealloc.
> > +
> > +	  If unsure, say N here.
> > +
> >  endif # IOMMU_SUPPORT
> 
> 
> -- 
> ~Randy
> 

