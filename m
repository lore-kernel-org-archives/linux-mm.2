Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 310DFCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 15:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 168476B0007; Thu, 11 Sep 2025 11:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1404D6B0008; Thu, 11 Sep 2025 11:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056426B000E; Thu, 11 Sep 2025 11:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E75856B0007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:47:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1EA3140354
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:47:31 +0000 (UTC)
X-FDA: 83877399102.14.1624987
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id B8340100005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 15:47:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/5quSOM";
	spf=pass (imf14.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757605649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wFx9oDnda6VBYzco4HQeSyIICMaeMRy33Q5Glx2a6V4=;
	b=gfaTfQZgjEiiKx8Nmdj2eMHbrpV7HAZrSHCL+EJ/3JdLNBXngtPOa54CEolqZ3Zd5e2pjb
	QIfAwNGeMEtWDzlZeifeE0Nlm+czNvuHRksIw/nJVLVQQI5ZnylF0cix7JGeX7UojnJ1Pb
	TzsPb/fL6+tQnka/rQvZIBDPdDarBAU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="e/5quSOM";
	spf=pass (imf14.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757605649; a=rsa-sha256;
	cv=none;
	b=VCpEFn2YCTGP7gilXx534WiEDvr3wIJTg+dIhdsEo1xYeJCA2X9NWnEr/nu+FCo/cH57YS
	iDPjjldF/wfC3sswvy1/Zru5Y0WbKPa8gGsoCUrT5H0hDbllHc68/dWsp+5SXrobtpdK0u
	V60C9ny48rZxUocY23HuBINjP/4svJA=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45ed646b656so3027505e9.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757605648; x=1758210448; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wFx9oDnda6VBYzco4HQeSyIICMaeMRy33Q5Glx2a6V4=;
        b=e/5quSOMx2Sjqlw2kA0WxQyaEw1ocW2NvKd/uw/zWXAZ1owCu6/UQRpdxq5LulcMl7
         PZSKYRMDaHuLbbPAY500SclR8y3fMf/wmnpVasCZf7MaaPc7f2u6QHN8gqKjpwc5n75c
         eBnvCl7gofQeWyTHK07dx++LsL+1XRqZcMdpfmEIFtE6wyFrqlAVsyy7pQKSJpHABCsn
         fuTzSUI1moDyyrEN8+PIZdyua7F4KCuSV1hRibj2SbpO7LcpF2QFXo0SWehZsg/gTmMM
         5ReTLuIo0IqWAHxo5FmwpsyK44vTdntwoPxLwI+077sxQZYbg0X+JqGW7as+qZlwp2N7
         I16w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757605648; x=1758210448;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wFx9oDnda6VBYzco4HQeSyIICMaeMRy33Q5Glx2a6V4=;
        b=C8oFA0r7uHSQJyFBvfm42ofX/HNNKZ6GmQsl2BhI4r06JWhPPuVqChTgLdUs/J5hBK
         Ho4e8S82ELb31M7gmu77m8fCa/IXZxchutOofAjIH+YrSn5shh7JYUbm3h3jHQbHXW36
         ZXEg1IoXR7rAWBAqduM/IhXK583dcwtf+wgl+GLJmi6DK4sot8wBthJYDKHHCMEZiknc
         Ob8ocgCsGuH3V0MUQtYecrivfzEqY+dX0avkpfymVh5X8EtU8uFNXjq5bjzAzsoQIGns
         Oez7q8NPF3s/DvIDtZ2vYKXK68MK2a462QGymlRB4Q2tTdC1Zd4FPOLao5/POEwbqZYF
         t7Ng==
X-Forwarded-Encrypted: i=1; AJvYcCXih0C74Oj2EYYxuLbg54HmhoyXqZxMPJoyuSyZBAidKyy9AVhq4Zvg5SVQIjq6YVK3c9fXYqbSWA==@kvack.org
X-Gm-Message-State: AOJu0YwwZXrvgTsANxgJWWr1W0RqiWjYZNhOj0ofTLmyWuv5fWvdJz1Q
	dg9rS2p17+znSPm2Bxe4vtkIXQf060fi9md7MKB/1Gcybpq/Fx3fbIV/
X-Gm-Gg: ASbGncuEzB3H4G8Be5d+2U+IrsGnZ8HfnpyE34sfDIizRbZs7Vs3Rk2lg7BqcKZ+4p8
	9bFotZD6HwBAZE2BcRt6h73TuWyXC3SwPyn/lNCow/D08LzbfzbnIXPd1GVe5SxBHVp2E1Q0Yy/
	7Pe6umjjfdxjucD9Qn/v9tjGpOAaataRyt/4vbho9doSDS+R23dGSgHyYCdbJ1GVg36kZQkZtcJ
	ElOZcSMNnj1NpEijBMQNwlMC0hNmhXXPxFdtzlrxAjDPuoWj/VHzSUmUPKCts7s2yZe/cdM8Spt
	YAIBdHAuyPyAq37JsDf/oQh3IqkUdSDuxUEtx3tereIAh9ApC7L/5YRvxtjbgoZ8jv/oqhTIKV8
	i5rVToU0kz5/UNjLe51pUvKeajhl3hqT13hsriMLY+OHr0JcZ
X-Google-Smtp-Source: AGHT+IFwYbz7NjDqxXwpnaGQMVwcC9yGmE42myK59UTXFjX0Z6krF3VrWIOyB5o/f16GdxD74dmXBw==
X-Received: by 2002:a05:600c:5493:b0:45d:98be:ee9e with SMTP id 5b1f17b1804b1-45ddde6a3f0mr164977525e9.1.1757605647599;
        Thu, 11 Sep 2025 08:47:27 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:6::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e0152ffc1sm16239635e9.3.2025.09.11.08.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 08:47:26 -0700 (PDT)
Date: Thu, 11 Sep 2025 08:47:20 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: David Wang <00107082@163.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org,
	kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
	usamaarif642@gmail.com, rientjes@google.com,
	roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-ID: <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
References: <20250909234942.1104356-1-surenb@google.com>
 <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B8340100005
X-Stat-Signature: x947co5z8yg7udn5dfzph79b1jm4o7y5
X-HE-Tag: 1757605649-54652
X-HE-Meta: U2FsdGVkX1+J3sDim6ELsbUHeax1+aFl61ZHcBmD5o5Hun4e7PXQmBtTYhIaFFXm9yfxXKGqdgRQtVUNJBiSIcMgjdGcUIkyBSgk1+5ly02Lh5Vzh8g6/G3HwyQAoOl2M6CEBlhc+w4X9eYm+5luj46Qrk60T7n7BUiQO3LlQIWpR6Tmrg+gZIiwCGyD7U7sCdm/NjyLkOUubOGJKYhmun+wjtFD5kY3IwwQV/Eh0ujoIr3ElzZAJE9eRStCIy21GwI+YXXB5D6tXR6eJhKEz1Fkr8EkQBWNNiOt6e0ZW9gkfPPKZIqw3KcTbFUevKzjORGVnWbX0Ah998v1nqkG8VB9CR0+shIxPpi7EzBDYQqR+/HioyBL6v5yBReRY7dx/Tj2WEHLAhMeJ6bYti6kGAVO9LHae9dgyRYzDwrsfY0+CYjBM7/vtQ+sV3U1A8NMJKvqo/RFPXLbl2JUX6L13zAvlyRacLesWC5PeGnfjAfP5xB6kSU7kVwUTNNY4FNZhTI+Frwj3bQbfA78JIhFyfsednVIiBfG0QIqMw6wRfWEvYAeeXSQ9al4eHavbRQg/qRyfo9luPUVjTjsznxvMwKo4SSebbPDIeDZhvoZO0OzT5brN0i4x1pG0eHfX/+rwwrzxpN3LuIAPPbkY5F0o6XgDgTM1GkazLYkIN1cQztdXIGI2/XdeFMr5PaRzCjSm6f+nuwTXzRfWIZzoDlFjGcHq3rSZU12LxjsYhvsG9J4KYbogsSoLRbZ6zWPtWGGBra+G/SiUDsQZRRn6kFvr+TmIx9o7bpincCC//mccTnz2Qo9iFjFazPQFqaLiLWlhEiS2ymXVaz95q+0uGLlKSW/opt65iJE1/z+oZJdjUbeAq9LtOsRdrxIYFRdvmkOC5gFU7TfeYra9Ni2j4MlQDJ/rJ5LzlM7112AseI7QHk19aYx+F/ORhSeeDw9QZAYeupFZ0IDKHvndTfdLmB
 Ezwao2iu
 roLY9z5lf7L1z7FieBXbxHPtPGPddeNat7qyaMtguX9VhTeiFocz0+lK4GXdLurVcOPKVPJ54V2zTb6rrHgVy8jwhmccYLO+xyPUyRLzEkJO2ZPOch798LfB3og42oVBlbXwrG2sXU9y+1/ZwPOdvmcTHK521OOfaEopXqZKuVvqUvjkowlH/m/GDQP42w2ZqaKgR7zVYriBdg7uIkuqqTJ3Fm+QvahNcXNfKM4qK4kFDxZnQwopAJPI/5P7keY8IyoKIXGKnp2bqsiHhctalgF3kIWBi9u2LEk717h8lidxGxgHxiIaDR3SoOtylFe/0Cc9Ik9wZ7FHYuSsb3UdFqZjmfCTBlPCcqcwDj730YNs2neU2QX5wDsBbTlWPeRhAeyo+tOI4l2eq7BXz/9UXrANmZC4Y474lBxhXNkSjQ4KYeSRZVITm4y7x9to4+VATLydL93VNLtwpUqkD1gYYYvSSIzH7DGTZXZiDsY27ULmM7wzRGNY4bHprpj7icN25po5+opCbEHDxIgLRCbjZ3YcXzn0ZuZMKJgdPgt+b3z+OLd9VidDpeXiD+0onYYXL9xnn2buz8bFb86Fwp3pRMoHJp/3T2iNgtZvs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 11:03:50PM +0800, David Wang wrote:
> 
> At 2025-09-10 07:49:42, "Suren Baghdasaryan" <surenb@google.com> wrote:
> >While rare, memory allocation profiling can contain inaccurate counters
> >if slab object extension vector allocation fails. That allocation might
> >succeed later but prior to that, slab allocations that would have used
> >that object extension vector will not be accounted for. To indicate
> >incorrect counters, mark them with an asterisk in the /proc/allocinfo
> >output.
> >Bump up /proc/allocinfo version to reflect change in the file format.
> >
> >Example output with invalid counters:
> >allocinfo - version: 2.0
> >           0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setup_data_nodes
> >           0        0 arch/x86/kernel/alternative.c:2090 func:alternatives_smp_module_add
> >          0*       0* arch/x86/kernel/alternative.c:127 func:__its_alloc
> >           0        0 arch/x86/kernel/fpu/regset.c:160 func:xstateregs_set
> >           0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_realloc
> >           0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_enable_hybrid_capacity_scale
> >           0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 func:init_amd_l3_attrs
> >      49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> >       32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_gen_pool_create
> >           0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_threshold_create_device
> >
> 
> Hi, 
> The changes may  break some client tools, mine included.... 
> I don't mind adjusting my tools, but still
> Is it acceptable  to change 
>       49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> to
>       +49152      +48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create*
> 
> The '+' sign make it still standout when view from a terminal, and client tools, not all of them though, might not need any changes. 
> And when client want to filter out inaccurate data items, it could be done by checking the tailing '*" of func name.

I agree with David on this point. We already have monitoring tool built on top 
of this output across meta fleet. Ideally we would like to keep the format of 
of size and calls the same, even for future version, because adding a * will 
change the format from int to str, which leads to change over the regex parser 
many places.

I think simply adding * to the end of function name or filename is sufficient 
as they are already str.

> 
> (There would be some corner cases, for example, the '+' sign may not needed when the value reach a negative value if some underflow bug happened)
> 
> 
> Thanks
> David.
> 
> 
> >Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >---
> 

Thanks
Pan

