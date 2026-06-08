Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E11F9CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 15:17:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3DD6B008A; Mon,  8 Jun 2026 11:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B886B008C; Mon,  8 Jun 2026 11:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8556B0092; Mon,  8 Jun 2026 11:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 000E86B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:17:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B2C61C08C8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:17:30 +0000 (UTC)
X-FDA: 84857099460.06.7AAC411
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64F78C0003
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 15:17:28 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wTxatEJ6;
	spf=pass (imf28.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780931848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOZ7AW/TQxNVQJPSlsPWX5PMQzNffbEW+fgTz/Ammvw=;
	b=yUp91fJuzFKy3ttGg50dmP4THQk+nZQYOVpLtVqaguz3o2bcSeGQiBIKneRUMe2H2hNhNx
	YyLZ56lfVzAjVbFbmkEs7wHZxQRug+EC5L0uzBa8UXbtwoNptHMrePYm+3fRLt+0i2j2+g
	QMYKw1fNqUy/1OTtV4I4yzAPvRUBMCc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780931848;
	b=6c2o5f8VkJQ5AibY7abDbzPPwYyaddA+VGyPgbWVFHadtkYeCk0tmRYvz8ozrS8e60NHWV
	ITD8HZHH0OyaZT5Ej4tCFbBL+zcA7O+r4oMGpGh5cFNdusl00Gc8lyZpGkK6E4EkU8lw7C
	XgxaXZ0bcSfLNkVAlyaTpY9bZthYHIw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wTxatEJ6;
	spf=pass (imf28.hostedemail.com: domain of sumit.semwal@linaro.org designates 209.85.218.42 as permitted sender) smtp.mailfrom=sumit.semwal@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-becfa735b9aso616077266b.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 08:17:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780931847; cv=none;
        d=google.com; s=arc-20240605;
        b=VlWaAon7shlWwdw83j61ZuRY8+xLq9iPzBARlT3xOmBoV/p/q54v6VnIpbycnwywIY
         nbWBE8rFXAzXAtJ4CxxNZf4oWO6webOFfvrYMDEhRkfa2ZMX/gHYMs4ESZgKVhWiPrq9
         faRY/PAhWr+g9hL/d/ofK3KMw2qk+6bs/fZn6lJGT2IfXgInL+iAgR1/VU5plz/wD/gb
         G6cyhTxAR82WKjVm3geD0QVklKErmm6szjV04OSeHecJYyG/u+cxIeLac7n241QM6Zlc
         /sovWlCZACZW0HFQRzVlSNuwCpZC0k31gses9kqcBLsKmfQZ7W9GqjaWgetqHwfCAgFc
         Mn0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=yOZ7AW/TQxNVQJPSlsPWX5PMQzNffbEW+fgTz/Ammvw=;
        fh=iRKtx0AZUV0N1NSHTnzZjJXWslfCXYHv+v4x0Xy5MMA=;
        b=GA2RIwbh0xgpBo9G/HHmYp+1oTUuAqGGFPydz4iLyMOaBmJMmKgkzfvjPXQcq600Df
         buxQbBmoHbhuN/0p+RKDnnvqTMfh2KtYv56EszVkglB4Gjjw9cxkbcF7+TWf60F7Vt/b
         p0GAD+w3CDWCeaeWnoUF7VweDTSABINnwQDkroPpwQVTKTmPZjE4VTSwB0I5NMYX/WW8
         uMAVpQDruXJUozKXqAvkRRuwAtWtFlZyEgSXmonO16rrKrHOgRGXmHOzppBMevidzgLV
         7kghRUQqBfHOkJ24UbdY8qtl8p9cluP/fslX4JrAcdaNXZsv0FHjDnkKLwIve3Lwh5yx
         J8BQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1780931847; x=1781536647; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yOZ7AW/TQxNVQJPSlsPWX5PMQzNffbEW+fgTz/Ammvw=;
        b=wTxatEJ6mkggzJcNU1VexxSX2tWqvZK75sjBTYNvYyZVni1LdO8nvDgQ0EeA1P6cn6
         ES0sN9j+IBfuNWK3Zn6AcxJG1VGuEvdEbMtqiH/kBjqzZeqNjWe+U9bCUyIouYaUUFxU
         1pLo6jWq3yJFZx8zAhuOy2+Rx+J3CoewoOWyvAhvZhGu952HCzDyt/Ls8vE96TbUlOn2
         vHU/nasEFHLa9wdZgKKJn/E+Ol0yjsOrl6z6bmSEvlL31eJvdelpnKhoOqzl+xCypEvR
         4RcC2e8Z9eOq7weEmRLSN1h/0MRiH0nTJhx/yCTUEinHvTjasyglu25Tbi5a698XGv32
         HB1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780931847; x=1781536647;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yOZ7AW/TQxNVQJPSlsPWX5PMQzNffbEW+fgTz/Ammvw=;
        b=F9plyzD/eM7KC538Pld/2I67/kSoJE1DB+GGK26FUuwym64ZJnxz9EBcBEqv7j2lbq
         miKAjx30ZiyF2p1Q8LoRplwYP8ksIchkGgNYneK0QIeGwv9Yqh1VtaEBG5LsAKTUBVVa
         na8xEeatz/HkeYxy202MLnRPl6GA42+YoucRRD7AYw9XZG42C/BTU2m2ul+GNy4YBv5/
         /Ob2zieDbw0Ai4mVYX8YlMbGC8/Zd56Ly46sN6Oao6O348JePwhu26rMK2l4wiV2upU2
         WqOwqNxoHVFXC3h99XTsIcCNxZobIgy07drnYZkHAW8Np6oTj2baRKPc4wD2a8tjP9Nn
         tzlw==
X-Forwarded-Encrypted: i=1; AFNElJ8kRn8b0JiNNbZu+u0JORdaImDX+FiQlLC8Og1+6dk2GATeCMH3vRN55Y4P0mpVZ9VEo+/M3vperw==@kvack.org
X-Gm-Message-State: AOJu0Yze6KJD7PHKq7qQ8gTdq9K4+mcU0qLq7RPav4qNDYbwqBYelpff
	+tVNvIMdYjIYGM3p/HgqRY03pPpQ/InA9RTBLUVY8gZFJYWEZ37RkxWhma0Tb1gZKNXEJVBVDyR
	sdAZ13T3Il6UcuJfxPxZc8FkkP0dIvrHz56vvu101/A==
X-Gm-Gg: Acq92OE0c78gAojaF1S6S6D/TXE3hY7TqXKhokKHK9hmOqYvTV5cq6jTuF4TnyymvOP
	FCPIse80LP9fOcOVD3/jtYPh3wD9aZLDLC5S7Gs/y6qTJavEck0HijnnAH2hSUUPA/85+m05yaF
	ZGmvA8s1QxQLenuIcj4wGKBRTFTtpAAV3kO1TT4ux24cb6QvfM15WYu1oGb9c6uAR7YjEOowyyW
	v6ntyflbN7jFf5pvHcP2gBKDFvLUnBwUkRPpHwCL+Sn+tExaVzRUnUEYhF6E/yoabwQxYR2QFv1
	JNZam5CgJWDjXPHZIb5EFnqGsoC0a3U82IMyW2isbhp5FsxelDHrvgr20kc=
X-Received: by 2002:a17:907:c22:b0:bec:d077:c4e1 with SMTP id
 a640c23a62f3a-bf373ff1dbdmr731904466b.47.1780931846675; Mon, 08 Jun 2026
 08:17:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260522225853.878411-1-tjmercier@google.com> <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca> <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
 <CAO_48GEJsg4X7++zg-ztQgVibY_FjjManaA5_W3usjicGUQPdg@mail.gmail.com> <20260604135712.GV2487554@ziepe.ca>
In-Reply-To: <20260604135712.GV2487554@ziepe.ca>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 8 Jun 2026 20:47:15 +0530
X-Gm-Features: AVVi8CdcrMng9NlewA5irjsXERkw9Ix0pSFdV0gf1_HiahCuxCNItaDbqkFH3sQ
Message-ID: <CAO_48GH3NP09U6TdB5drbKY0TpwvtBXwrf=Jajsr5ttNbC_u9g@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and set_memory_decrypted
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Maxime Ripard <mripard@kernel.org>, Jiri Pirko <jiri@resnulli.us>, 
	Christoph Hellwig <hch@infradead.org>, "T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, npiggin@gmail.com, chleroy@kernel.org, 
	linuxppc-dev@lists.ozlabs.org, lkp@intel.com, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org, agordeev@linux.ibm.com, 
	gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org, 
	Dan Williams <djbw@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	Arnd Bergmann <arnd@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64F78C0003
X-Stat-Signature: gui5wk1raua1nqe8rd6unx4q9iyx8kgb
X-HE-Tag: 1780931848-120587
X-HE-Meta: U2FsdGVkX1+xygDlw6PF0wHbsTNnOmlAGalPRC+WRHxxLOl25nO3jTumjNS7fMarbHw161PkjUmym2QPhIQ8yXp9rAqMRgGzYx9e1BXdJ4CtV4EfUVMuBWAC+GzlwJUnwuK3XfHKN77GrKHZM56I7vM33dwjtk9sbCQKJM2i7EqOFMyvr3eSk9TMUUh4HSFL4vpRuCr9B+n5rrrkDbMcWT+ixZ59uzgOJZ34LSyg6oGA4KWmK9UKq4OsjgH8tZhtp3AzDLTZZr5AQS7bplmrHOnwlBaZFvVuxHrVgSyh/BUbDLv2+WFLM7auPOorFrTp6f3caQlangpvkAvAON4tMBB+78ghn2bQReRdqveShcqCS9Kbp2MWigq/1rdzLWuHKo28WAJ25gjna3Vcb2vZUNlWnH4MaSzDpt6ukpGkWrhDBe/GMlfOyxddqF5aoaK3yycqVEXxK0FVwkLFdfQKZsxilxswekii4k3yuR3wXVdyJiQ7CLtbacvvHekvxdh+4+5u/A3vPHHE8qGbuvsnhtqV2MYVpBUyAyiN+03AsEfjXvp6xbBBI6aED6sitvi1tquDlifQGKyp+vlzP7s1feA9HXITYZFc6LgpMOMHaq6+l55dTUtReNCLMsU8Hh68+qoupX7aWsQwmDoRZry9jSb2+hfcsInZHcpO84iXfAIR+I9Uc8Z9nHgLJoWj+3sylRTyK3PKm2YDfcthxqVKfYkdIa5BuiMidy+D/b+57MVtlV6ZYhC/cbd/PFsjUCS99RwL9woGQghY1KwCiXcXKIpk+/N6YxTwyEBVrlIlApPhiKhrtPMm9YkoXe17IpCi/jAJ49G/CAKjpO7tx7BdwIfYraKMCLFklJiiPCocsO7Sa6483oWRn8YlcPzmsrcrR2JSm0/JnL+tHlT28EaGSaII/rDTdDDLe9N9wzlv7nA9+BGew+Qv++FCZQnwzCkVkPSJhPEH1dn+AhLIf6+
 zAUusAQ5
 ccsGq0gJTxBuI+UxGiHagw6O4mDUYtYlIr3iXDs5F4+XwQnuXf/VH2mf/6ch6fzvdCwmQ8Fprcm3D4Oru8sSN2waIS1xgN36pX+ZEOqAz/Egwi25V7BuXzntE8S8lvf9oVuY573wkMQPGmPcW/DoPhQRva9oCc8lJPImd+50ziDbbqnZ6PQboBlto/1e2Ve3VZG0EB/e69GIi089T0H0e2ziTAwx4UvmGMyl2HAA531oYoz0wnOzuGWnB1BHI/5+cZ+HkW60fbz3u0v1+/L6RLiroY5Z12on0Z03Hn0VH4Bh3L0vcHMLc7DdSEQfGahcq3pddnOfA5zifuxk/GH278o1fAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Thu, 4 Jun 2026 at 19:27, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Thu, Jun 04, 2026 at 12:51:49PM +0530, Sumit Semwal wrote:
>
> > Given that Christoph's objection is not really about the modules part,
> > but that the set_memory_{encrypted,decrypted} should not be used here,
> > one option is to revert 78b30c50a7ac until that issue is sorted out?
>
> Please no, we have stuff already using this so it would be a
> functional regression. Revert making heaps into a module since that
> doesn't have a functional regression.

Thanks for your comments.

To me, it looks like while system and system_cc_shared heaps share a
lot of code, their user bases have different needs. It's apparent that
system_cc_heap users don't care about it being a module while system
heap users would very much like so.

I also discussed this with Arnd, and he suggested we could rearrange
the code so that system_heap_cc_shared_priv depends on a new Kconfig
symbol like

config DMABUF_HEAPS_CC_SYSTEM
        bool "DMA-BUF System Heap for memory encryption"
        depends on ARCH_HAS_MEM_ENCRYPT && DMABUF_HEAPS_SYSTEM=y

This allows building both into the kernel or leave encryption choice
up to the consumers of the system heap.

If this is agreeable to everyone, I can post Arnd's patch.

>
> Jason


Best,
Sumit.

