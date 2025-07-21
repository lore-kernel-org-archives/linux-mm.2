Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA51C83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 23:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDB0F6B00A6; Mon, 21 Jul 2025 19:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B7A6B00A7; Mon, 21 Jul 2025 19:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7A2B6B00A8; Mon, 21 Jul 2025 19:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93F396B00A6
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:19:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 119391401E6
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:19:17 +0000 (UTC)
X-FDA: 83689839954.07.3255999
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0BD168000C
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 23:19:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bF7K84Ju;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753139955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7uUxr86UctpR4wo5BHRFyvrfjd8nsrpfmZh9G1fUjI=;
	b=r1JQMbNCLCWyfeA0Hy4LStbwlLIC/dfoMGyA8gof2jhe7SerONY/LpnR9HClyBVHzhB8jd
	cfHxWM7jTEpROp96Z+3nYK9vXzAJQ2sdMoKpAjq5MxfQstnMppVrXPo2G+FfFpHVPUWEMZ
	cGNDeV0Sb3s1FtGB6weR9RrF7fdDNHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753139955; a=rsa-sha256;
	cv=none;
	b=sgO3769mruYgF4wkjx8kN/RCzPf6TrM+MDUpJxTfNAPPf8kanXzV+TsFs6RUEqO8eLKVEX
	2AOHvcAQI67Cg+T0oTMFiXOcGvOy41amWgwpyXKQtHfrM0LF/tLhOA+HFcaBxKHed3D7Ar
	6S4LPpEDSWiI3fibZUiEepLH/fQfnqw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bF7K84Ju;
	spf=pass (imf02.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ae6d8584e08so5028966b.2
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 16:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753139953; x=1753744753; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k7uUxr86UctpR4wo5BHRFyvrfjd8nsrpfmZh9G1fUjI=;
        b=bF7K84JukLyQaZueHoviZIamcrZ4cUn5pdmgPbfnh/icdwU3MoNMmS4zZV4RRKbGBA
         psPyfQ4yAPcXeRGiqpXV+gOtbesO8v33jZkGFQS32jnNCSc9rGDLZG1mJYfV139Sauhs
         aKl+eHR+lJWJYjLobDx1i+j42T5/tYfOhm4EGNLbyUqg9IDWSNWQzf3uvmUj18WFB/4n
         uZHNiKsPqJwFzZQ6EMHKzkIvRF3MhJ+OmxW4pE3n2La1cuE1Kbi6XdKH/WSxVosqsgP7
         RCo61Se58x9dsPjF80oRn2RtvFzGje09j+/y3e+O9tV+I1FBv19I2MMBZHbPrYEUJRL4
         0T7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753139953; x=1753744753;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7uUxr86UctpR4wo5BHRFyvrfjd8nsrpfmZh9G1fUjI=;
        b=ARw3FNE4aMqqh3NppHlidS8SLtgL6WFNi/MgEYHKSaGtdwj/ANQEY+PIyodnRrx5A3
         Xm4rpJk6dqlMxq2QdAWBBzsmp7EWGyWwOZl1qgp3ENHRCZmvQ9RIv85LK3hRXXIfAoEo
         RtY3O2cv0k5RYrK+bHjFfTRlwYE5wqhhKTU7SPsZTh3crfKECvj9l+h0A1wEeh/rb6aY
         9sDlzOAHmDmQGD5cDujqk9PycSFMbXsZhh8iK+bPQcsqUBCmOhxvLrnWkRrT8/W8pB4G
         YbFm0jFdZ6M6tRZP0xx2LZnY4yW8SzrJMiByAd09SEJOuTZKyFBiPluUWpua5qlUZ2HZ
         ymeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVavfpgkKlVBJG32Oo7ozu9nZQrhpICcCpKPVzmsdTbHWKbRDVRTfakbFF5VQjEV20X2e8cgX6sMg==@kvack.org
X-Gm-Message-State: AOJu0Yw8HE9ijBtK6J3p5cferu6hu6FjM67TEYh91jAsvKDZ9Giw4kTV
	mmb2S334C/cH3Fh7vRB8DHhITgKE3Nn93HoKuTbaq6uWaaLjn+6xz+Z1
X-Gm-Gg: ASbGncvMWPtOUFYffQReHA0PviqO30gfefvQuSBjV8s3gnmZeS/jWg7mTHadaV8BINh
	F85+h8E/HMJU3W8GYxF5wQijoGdY9cGZwdgYdJYEhO2cWr0imKRMmq/FEQ5l7X7vd+mmz5MumMl
	20U+RMTbpJviGcgmBFkc4+mapdlq8eNveJFVCp9xKB0Onxym5nAYHouogI+aDQmZ5Ibp7wcB/dk
	ChvQOfpgks+LnUZOw+yRzh6b9PabpB7eAAMfT/JCOebc+lHSArI2MdhIytV4/PXkIeGbLbzNSmP
	38DYNPbL34j1JnzKJ6DJ9xVsMqtoM8FSCTtidZ81ySk+QeIVUtWaYx7riGYjAV8PlS9C58sysi2
	oYL5nqFboIA6Xwdtz1JQmoXsfdNim6Mp/6lHcjxQnVmkLfVrP013P6E0oBkh3a0iJxUQA
X-Google-Smtp-Source: AGHT+IEyAyDIGzGDBFvxWK+s5z/H1D9rPFTjwAnBXhww3QxIrjDEOAm8ilmaU8TjGW6AeZa6UNDATw==
X-Received: by 2002:a17:907:706:b0:ad8:8200:ecf7 with SMTP id a640c23a62f3a-ae9c99aa29fmr821747766b.4.1753139953227;
        Mon, 21 Jul 2025 16:19:13 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-142-142.dynamic.sbb.rs. [94.189.142.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6ca7ea53sm757005366b.133.2025.07.21.16.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 16:19:12 -0700 (PDT)
Message-ID: <a1bc7a9d-817d-49cc-b7f1-79a900090136@gmail.com>
Date: Tue, 22 Jul 2025 01:18:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/12] lib/kasan: introduce CONFIG_ARCH_DEFER_KASAN
 option
To: Andrew Morton <akpm@linux-foundation.org>,
 Sabyrzhan Tasbolatov <snovitoll@gmail.com>
Cc: hca@linux.ibm.com, christophe.leroy@csgroup.eu, andreyknvl@gmail.com,
 agordeev@linux.ibm.com, glider@google.com, dvyukov@google.com,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250717142732.292822-1-snovitoll@gmail.com>
 <20250717142732.292822-2-snovitoll@gmail.com>
 <20250717151048.bb6124bea54a31cd2b41faaf@linux-foundation.org>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250717151048.bb6124bea54a31cd2b41faaf@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0BD168000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: idemboohi31yi5wjn4q8ob5b736xktp1
X-HE-Tag: 1753139954-260951
X-HE-Meta: U2FsdGVkX1+UqF8fPeDcMc7SzfsSpikWfejeIpxWKK2Bh5DkzVyEl7usrmrDaDuKXR4MiKFYpw6Zgk4awqm2l9GWaTQo/ASprMqiY4sNk2yQuPC1u220UB4Jp2CEpG2EAtZMHBzu8tzWXJsgb7TwDaqmslzWTtSWckNKB6gRlL7DAt/3igKnurR1Mi5HpYJGVpchhxR7v2vZ3LFfRQZorCMYIwhi6L4aYyo0hegF7xR/ziicgclkTCItrA5gfotdFUVMfDvQQ1ZzoHlutkSg3Oo5WEyFe5Gx7BxRDlBlnfDTyBxcciWX6aiKYfDxb6D2VKrtx1lL3DFItqcSR6mFeNsSkDNr+EiZg7AX9zlLySf3QNMJ+C5fOgF84oxp/PbqPB4cF/h0U1LGU2M7zDfsC6h9Ta7OVbHKtFpLdSipWnvaThjIeaHomW/MucsnAnhAkYA/2LSLOrcoKpuQYIVGBwqL2XdzrEoAVAE7djcyU2ra3gU49Mxo/giBvv1wMne+b/hT1qkwm9ePDHe1qLRpz5cquGleeFIqm3fRhvDugDZotwFXRwmOZIQ69UdVYL3oc2lLd8C+CKs5Ewza/JzW8PGy5IcGESTJ6+HKg83xbNfrCdokyAnimMSM1LCiqjU5uGHYnt/woV5njyU/ESQiLW7OW58d47DNeWS+/cHs4fG4nEWtKFYgTtM45ktplAAXPdniEePDEWIP8SG8ffxDh4JoQyn6Bhz00QsWq4kVUch40CRoARgjAgigq3rY5c68Eu+Yvclyv7zY8TWbqb0H9cumS+i5EO0B5UDVOK9vcT3gTKUNnhFRYxMNM9UG51keYaSABC5+orZ/covd4Qk21va/y66sn0pls+mJpoJ4nEwVM4iHtb8ISFhhlYFfVnksq80jbSIwRnnmXgCGRYIg6XBPWQVax3vf7jN6sZdt70UB0DThQp7GPBhjpj/I8PLKHlXbdXwsdKVcpDKAKJ7
 0ipEhCjf
 EXacEfgMdH+hMrbwBeZ0sHNGMigaBUdh+tdLw+yDOCqjP+Jr4gdOH8D55vnlsn6QHx2gYzOzH8zhr+WmjCcegGM/zNHXMJrty8vwGlGpnogZzjboASCj6h/IyI88HpXX0iY1evSaENF8cK107hi2fQY9uEKmQDG514hetRGL2qC8k96ESfUqIfPTllU6K1punZNNeRfx5RfBwn3v3Q7xP3kiKk7ckp+x8jS+7OS1atlAoTeqxPtXDMfjHU7S0RkvAc9w8R+xRKbJoH23nUkgJLlZXjdBLErf8sKkIy5LOMHilHIHy1IWjHUGAIqFm3ucOSTbHwKv74hryDzUYLSOZ41omKgjqhhPqHpPsuRpxTXJPC93XybbLK61SvP7vwF4W9+0e/0cQfCiGCcHAbiPfvfPyxinsD0n31EEtp4LpSTT8Ik4V+mTa581haDRW/1dsFvbkVM+m0Qtkmci3Vkn8bOu08yoUhUmT7HmW3wwTkvPT03laYO5cgx63RsKShUwU+h4Hm5R6tJ6SCWPd73+3LUnYxwOx4LT/Gtdt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/18/25 12:10 AM, Andrew Morton wrote:
> On Thu, 17 Jul 2025 19:27:21 +0500 Sabyrzhan Tasbolatov <snovitoll@gmail.com> wrote:
> 
>> Introduce CONFIG_ARCH_DEFER_KASAN to identify architectures that need
>> to defer KASAN initialization until shadow memory is properly set up.
>>
>> Some architectures (like PowerPC with radix MMU) need to set up their
>> shadow memory mappings before KASAN can be safely enabled, while others
>> (like s390, x86, arm) can enable KASAN much earlier or even from the
>> beginning.
>>
>> This option allows us to:
>> 1. Use static keys only where needed (avoiding overhead)
>> 2. Use compile-time constants for arch that don't need runtime checks
>> 3. Maintain optimal performance for both scenarios
>>
>> Architectures that need deferred KASAN should select this option.
>> Architectures that can enable KASAN early will get compile-time
>> optimizations instead of runtime checks.
> 
> Looks nice and appears quite mature.  I'm reluctant to add it to mm.git
> during -rc6, especially given the lack of formal review and ack tags.
> 
> But but but, that's what the mm-new branch is for.  I guess I'll add it
> to get some additional exposure, but whether I'll advance it into
> mm-unstable/linux-next for this cycle is unclear.
> 
> What do you (and others) think?

After looking a bit, it breaks UM and probably LoongArch too.
I'd say it needs more work and not ready even for mm-new.

