Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26F0ECCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 15:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7806F8E0003; Wed,  1 Oct 2025 11:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730D48E0002; Wed,  1 Oct 2025 11:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F97C8E0003; Wed,  1 Oct 2025 11:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ACF18E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:28:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF4A513862C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:28:57 +0000 (UTC)
X-FDA: 83949928314.18.615CEC6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 806EC4000D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:28:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tv8UE29f;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759332535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+slWpPA54aYcVOS9FeUlchlk4c0XDL9e2Lcv8RaMd4=;
	b=pc2l05ZV6FSgtIiPNm0/fOEqsC/4W1jX85v8lNjjtmksqSt2MA0p1efY0nB8OetamRX7yB
	60HdUOYWnT4ogHUuXJta+40LarqTvtMHkOyyZzKUmzxOElIh/sTt/rUlUea//mDce6MWDF
	2qQ6f5lBzYSYFLj9xwYlOO8tsdUP1N0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tv8UE29f;
	spf=pass (imf12.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759332535; a=rsa-sha256;
	cv=none;
	b=xivPtDasPdHjYW7jIpFxeAlPcxYP3YrXup+lK655yEW1K5L5Rpp8J//K2P94BdjZVe6gTg
	F9Ksm3HwwChlJXMFlgEk33wZEIzZ9xK9PAuV+sBffJpaUBwTXgONsHFFtQmHaVkIGYnzA9
	qCfPys6h3US5b1TXH/1jhQStec1LnHk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759332534;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=e+slWpPA54aYcVOS9FeUlchlk4c0XDL9e2Lcv8RaMd4=;
	b=Tv8UE29fgeSBqvtOzIIB1JE5k7CpLl71M+2/LhmMS1oFaW0boxjCJHmNqt/s+yI1x+9wnd
	J8uCwZiLtkTA+xF0RMRQjwSFO+AEqTPr/UIAVxMxj4OwfXp/ziKdi12c7Ttv+rQHPNBkdh
	5ucqGpJMM9XVlDAEco9kxM46k45gfmo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-265-ujk1y9ogNqi4MaW4DD5qDA-1; Wed, 01 Oct 2025 11:28:53 -0400
X-MC-Unique: ujk1y9ogNqi4MaW4DD5qDA-1
X-Mimecast-MFC-AGG-ID: ujk1y9ogNqi4MaW4DD5qDA_1759332532
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ecdb10a612so6800602f8f.2
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 08:28:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759332532; x=1759937332;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e+slWpPA54aYcVOS9FeUlchlk4c0XDL9e2Lcv8RaMd4=;
        b=Fec+mahZBLq+z5ft0FBcFlbEsuEcwBOV5wmMBTlmUg3ugzYo5ENE8OHwc7Xk2To15t
         oazm9AkIqc3ved3h9EsEnV1WYz0dImG5WJ7TRkpi6bgzfv8wzCBcYeYZT4Vuipb5xpfu
         yo0aIA/lyC0TjhevXw+i0k9mJ3h3zNXcs+AonMTyxoaGGiWWjv2SFySmx+A0udF9tRO0
         j3QNt1xh+gAMbBPGTduNX1URqJZKyWDU9sZdIBU2BmevgVrtZsk/GEif2v2ASUqaMp0u
         yHTMSHZQfUC2K3eDYC/mWQ1RwsJqQ+Cnrc8zE1S8qd9if6daK0Y/yzhQh8kw3PtiyQTU
         D5Mg==
X-Forwarded-Encrypted: i=1; AJvYcCVUm4b2nMtM5MjyxrV3soJYJTKmU7U1Eo4BA7SXosmGrGsy50KwrXHboP0gI16/bo3pVxXJjp3mng==@kvack.org
X-Gm-Message-State: AOJu0Yy7VAM3lryWWk8haUfoWJUhMGoMzPSWq/AnHPEG4E8FWY1nbmzk
	aYzPdB9hdA05tWXchUW6wGuRNImcUWIwVhLA/CF51VFgolqIoetwpghQ1HH0aKpdRUBspU9liye
	qKHVUpJP2DrLiFWtUClp18eBpJC56gRGG1W9AtNiNNAxC5ON0a2Wx
X-Gm-Gg: ASbGnctvjoxiFdUhdyH+Ns1hhlKseZE5O7tyEYfGToDeSFVyaK365NRyBTaf0+SYrTT
	K0YyEVHGk1JQlOv0OIGQ+mKRj/86WmLMrA4VjPIJs9Z6r1LKHUOAbRGYd+HwfXlh+7xRjmBJcqo
	nTph9rxMvjuY8wjI13Qh1Runzv1w0W8rO5jF/fulE+gM5vEhmXD/KuW5C+dTdWf3NqQaZwBNs+y
	fmtDpcWuz+PFj/p59ej7kC9mjVZ9xhHx4iDmitcmNcfenn8uiC3F2WfqQ96lnaiLzwUW1GFQn4Z
	u411wPBlbv6kRh0+hIyuJNns7vrb1v5E2xiLNoCTyh9CHkLuGrHYQGAbZ/iDDM37jY6RonvlTnI
	avgJvKpq7
X-Received: by 2002:a05:6000:2388:b0:3ea:bccc:2a2c with SMTP id ffacd0b85a97d-425577ed5d2mr3451648f8f.11.1759332532350;
        Wed, 01 Oct 2025 08:28:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdwITK7uCSqv/A/igDjSEGaWLXOD/8b6fdy6NcMUtXataIInxRPW2Ouk591De4Glwn2mQ9Sg==
X-Received: by 2002:a05:6000:2388:b0:3ea:bccc:2a2c with SMTP id ffacd0b85a97d-425577ed5d2mr3451604f8f.11.1759332531757;
        Wed, 01 Oct 2025 08:28:51 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fc5603381sm29816097f8f.31.2025.10.01.08.28.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 08:28:51 -0700 (PDT)
Message-ID: <48ed62b1-cceb-4bce-923c-25c11dbccc37@redhat.com>
Date: Wed, 1 Oct 2025 17:28:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 13/18] mm: Map page tables with privileged pkey
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20250815085512.2182322-1-kevin.brodsky@arm.com>
 <20250815085512.2182322-14-kevin.brodsky@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250815085512.2182322-14-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J5XGZgokIXugtASgzvG4jJDKrSZJINj9FnMIAin1YJU_1759332532
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 806EC4000D
X-Stat-Signature: hxcq98cmagxyt6yn1h9psrggjq1npmeh
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759332535-550278
X-HE-Meta: U2FsdGVkX1904ijWq5hu16aLI0QuI9AUpNjf8wBHj+fkz0gJXGY1olcKoCFB92ZcvhTzh84NGsEFC7ZqNsTfBPx6xgAS691fHMyTlW0MKGdunLNoqeiOAnQOPVf2fPKKPCeGFbl+xE2MqZ0Orn0NNFKd6b6SIP+5ZC/tTxaL3jYLpG5D+GkKQJ1nEWMc+gdiPMK8DjTHae2v6Nl2x6QiSQnG3q8fShLLV6wz+q4gcnXkatbTNdsXfllRlna2Hqh+hFC8t18BqtKhO9Y70NBHawz8x2uWLJPRtT+1e4/46uGa/W5219vLRJC6+clnJzpYywCWw9q21APWM6IqMP7tvGJIbGs0cW5IKern//sogmnkHiXrRtaOlOPrDqGA3akYogN0bz04rpbjK+C2EOS6njWfYoAANwPo/595D4kX579zqjn8ZyO9z/0PI3JGaKEdlrlMpBnPZGUASd5fBBLp30UtDfRrdSWbrul//fb1ZOWzT8S0BMw3XCj9hfokbaU412nkOahI5aNmSS8Tvwx5krAEL9chmgc/1yfVJmpoAEJGXIJHBOrHMIJdl7Pcw/sjQeGh9UoMkz4ILbqYo7PzPYl8WAJz8w0qJsEmAHqitbq4c7ws0Hr0fEwc9W5EpTBcD1DIl05e+Qv7kMGkSPgt5KZ/yJgGgY1HkSuZpE6ECmWldKS3vqcCfJ7c9FaEVV+2uHj5IvwUiT3knr7l/D/Q7GaFBiC3xjVZXT8l7KQmCHJtj1LaZr+HG+gzSJZMHNJLwSdvw/9MjlbyMe3325rdaJdla/nmFi3iHKf4yktVhfXAfxwAY1A2Xl37KLAa/sQFn+WIWoN2DrB3DgLWj27stUV2YgGiRCJvsBVb7lLWT0ZDPM7VEBG1/ghrZXGFl2jFW9Y7xWrwhGb9s57YGOLoBRk3+M0pm7glkH9XvfQqVfqTm6era7D0LnAPWFL49qmqt7wiIqQYU00+11Ft5LV
 nElsCLAz
 B7gEZkEK67S3BghHKQqg6x8ebIYC9PUQVHz3r+zD8LvSloW16fwAXY5yPqpuXULrkl71+kf0R6stnLp+E9j6skOqOqmB8n9MnXtmL9rKHAWpyvHR75emWcwJcfF04ytA8mny/jDp4PJZDvV9rgudeCvp51oG780b4BuNNb3Ksz5UTspbdrjfZx3b8vN7UYcYn4lGMRrDayna8BuiakUQITUo4o4rrT7r+H5XHwczZ0uih4d/4f9uOe/LkeEZnV/G+CjMrWbqck7yNIbQLQfJOqw5stE0ZbYOv7y1bDNnGURttOxCvhXsenXH7kPv50Si5Fkym1/l72vL5KwuELFjGtFiJPzv6WjY8+EgWnM/tgdtR+GwmMVrZ13BuyJ5Q/KInZ2bc6jSYbHJGiSWPXZNpM0TM1tSTe7h5BokL3cg0PmM+cDB0iKLl7oLdxDK4fPA4fEFotulk5VukPc8Qx6KVivW92NCFghmHmnA08btUY+njbOlbm0MkckDsjZFE+XOLbuYxuijc1VHaVHdoh+Jd3DpbtoHQpPzmMRFUJtBx2tAe1Sz80qBHkVfuWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.08.25 10:55, Kevin Brodsky wrote:

Just wondering, should the patch subject be:

"mm: protect page tables with privileged pkey" ?

At least patch #2 tells me that set_memory_pkey() will set the 
protection key, and the function is called "kpkeys_protect_pgtable_memory"?

Just trying to connect the dots here :)

> If CONFIG_KPKEYS_HARDENED_PGTABLES is enabled, map allocated page
> table pages using a privileged pkey (KPKEYS_PKEY_PGTABLES), so that
> page tables can only be written under guard(kpkeys_hardened_pgtables).
> 
> This patch is a no-op if CONFIG_KPKEYS_HARDENED_PGTABLES is disabled
> (default).
> 
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>   include/linux/mm.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index d9371d992033..4880cb7a4cb9 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -34,6 +34,7 @@
>   #include <linux/slab.h>
>   #include <linux/cacheinfo.h>
>   #include <linux/rcuwait.h>
> +#include <linux/kpkeys.h>
>   
>   struct mempolicy;
>   struct anon_vma;
> @@ -2979,6 +2980,8 @@ static inline bool __pagetable_ctor(struct ptdesc *ptdesc)
>   
>   	__folio_set_pgtable(folio);
>   	lruvec_stat_add_folio(folio, NR_PAGETABLE);
> +	if (kpkeys_protect_pgtable_memory(folio))
> +		return false;
>   	return true;
>   }
>   
> @@ -2989,6 +2992,7 @@ static inline void pagetable_dtor(struct ptdesc *ptdesc)
>   	ptlock_free(ptdesc);
>   	__folio_clear_pgtable(folio);
>   	lruvec_stat_sub_folio(folio, NR_PAGETABLE);
> +	kpkeys_unprotect_pgtable_memory(folio);

This is all rather nasty. Not your fault.

In the near future page tables will not be folios, and the whole 
ptdesc_folio() conversion will not make any sense.

Likely you should make kpkeys_protect_pgtable_memory() etc. consume an 
address range, or a page range right from the start.

-- 
Cheers

David / dhildenb


