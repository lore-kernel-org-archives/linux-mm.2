Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E2DBC83F25
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 22:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2676B0099; Mon, 21 Jul 2025 18:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A9D6B009B; Mon, 21 Jul 2025 18:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0AA6B009C; Mon, 21 Jul 2025 18:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA29F6B0099
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 18:59:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69BE5B6A8F
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:59:48 +0000 (UTC)
X-FDA: 83689790856.01.B31971E
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf03.hostedemail.com (Postfix) with ESMTP id 66F6020009
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 22:59:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PFGH55ER;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753138786; a=rsa-sha256;
	cv=none;
	b=FoiozqJOjdAg10zZhAuY0/VGs5XmSXmSok+e1nFD4G9qYJK2gH1nKRP/qtxntrYv1E/4fV
	7R4oaI/fL8X0yN3UWY+ulGf0dLoWJJ7Iv/xa1d1VSeoZb3Z2Aa60zSr0nBEDVZUNo+dQRZ
	eEhVz2V+eIDcRN8dOVYIAwNItc4S+u8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PFGH55ER;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753138786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qziS/qpONFFAWWmGEcjsGqxLtdqROLsiMhv3HQa+DVo=;
	b=3+GkaAG3Y3P2eZu9wL1vE9t0+RA/PYEKjIxT6OdFXZTKsucbxYKJrrsqqNcTNNTkdnKKLX
	ZG8JAqZNfjsgLBtb3qZmcLiomT5s4nh3nJJWooPHSPTG+R4qhV8HHRzVU6yT5OavkrfWnK
	EyVU6WDVna0Qf9jnJZ3pskvBndsxlTo=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-60fdd24613fso982371a12.1
        for <linux-mm@kvack.org>; Mon, 21 Jul 2025 15:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753138785; x=1753743585; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qziS/qpONFFAWWmGEcjsGqxLtdqROLsiMhv3HQa+DVo=;
        b=PFGH55ERxrkUCZs+DK7eW9emT0nQYfkNcZEaW905OqybO6iygl+oLggzh9D9izhiWz
         RQk85mov4W+tjRGMrq4WOxp6Y6l9LlQ2FOlBhhTXKK5Z6/9FESuF26g/tcN70YgdOuX4
         32DpVxagEG6AdZ6GJj5r8KsgCL7H3BkP8iZ/AyXJ2NuLQwBiKaMNLpW7N4YlMMa/BQLA
         +GHUdyVcORLuh0F/I95wjjxrcHVcM7LxnvuT/SCtykKDR1sGqJl47ueMeVe8Q/Mou7+L
         Hp687UCwCmEASZcEPqMJ1IFoA1BkZLsqKHqAVartIplnZhRE3PR4zuHGhQYAAABVe98A
         amcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753138785; x=1753743585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qziS/qpONFFAWWmGEcjsGqxLtdqROLsiMhv3HQa+DVo=;
        b=AVZilnZ0Z+B475BOsHWZD2+TokaNEKSFrJSlrFqPFKABCz0H3i5vYniJZYMou/Ndbf
         oDzqlJurbvaNSwGraNhIH/96Fv1N2MFY8ORFmWqm3mpSl7a3dQ4WWHb40hhXFYvQ0ZcQ
         YvCJdk/wrnlC+FSUS3fLSu50KRMWsGWoOdkFTCfJSUcKYjgsvzM4AuIUO4JWQ8QtfD/3
         6nt8GrYe2BJxKqsKrTXG9KJUjhXGFSr0qD3Lj/ziVjQtI97l+rYp1GRNtw+mhecv8G4Z
         udsxQHlC/luV3SYdth2oH8AWEg2CR4z/qYQ/G5WFSVgguwP3DSa+qvLQtPeheSf239r0
         jXtg==
X-Forwarded-Encrypted: i=1; AJvYcCXIqmwxk3y12r3IJcxFcGwOth54m3+p9XBghO9+VSBofoJPNMc41lOqZ6iYXp0uDCA5FVUmJILh5w==@kvack.org
X-Gm-Message-State: AOJu0YwIwy3lzMlSlQBUdwZqJKp7Hw1+9BjiWpDq0naWJCnx2q1Jkrag
	TcHt623vBNcltaXTaXHeMCAVBo+zdlJO48IzzvqvxKiCx0/aHLKocXuX
X-Gm-Gg: ASbGncs5XX1Vfez2M4EE3xGMXxnuVixB7ti23gdehXpcCwue6bD22wtH1NVQdM9UFH7
	WVAUuoty6Fzh9L8VaoAVSmswt85SnlZBeWn+QnnCU506SasDg6pgyvMkRPs6z1by9Z/CuOKYd1E
	Un5Hq3n5H0Sd/yHAkbyNUgOPcRJth/ECR4ULWCfPDoA1fas7QRoCaVEQlDNFdnhayKDUBvDJvfx
	k10D7ZQcCZb5UZH2/AiqvnBCd8A1X4NtpTc/EMcTBkGAHtYZYBVCIjyY0GSdL7LULgg8vQ3NhDj
	34wXqxvHo/oRkQKbwdhnVi9/dKxZuNW4yqkY3FsRHLjGc1xY0Hv6TENdO91d86CcBi9KgMdyIHQ
	FjLDV9NlqzOCVfMDJOXuUB23/YvcBdpyw09ehEOv4gz7dBJ0MHQTben1J5CMY9xpVK5it
X-Google-Smtp-Source: AGHT+IFBO2iP/n38Feyyqa7ON62IpV2R/kvBKzJAAeBv02jcMXCr2o0KVEmn950sS2xc+ad0bPTgUA==
X-Received: by 2002:a17:907:1b05:b0:ae3:bd92:e6aa with SMTP id a640c23a62f3a-ae9c99adb7amr852181266b.6.1753138784434;
        Mon, 21 Jul 2025 15:59:44 -0700 (PDT)
Received: from [192.168.0.18] (cable-94-189-142-142.dynamic.sbb.rs. [94.189.142.142])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aec6ca7d330sm755829066b.126.2025.07.21.15.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Jul 2025 15:59:43 -0700 (PDT)
Message-ID: <f10f3599-509d-4455-94a3-fcbeeffd8219@gmail.com>
Date: Tue, 22 Jul 2025 00:59:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/12] kasan: unify kasan_arch_is_ready() and remove
 arch-specific implementations
To: Sabyrzhan Tasbolatov <snovitoll@gmail.com>, hca@linux.ibm.com,
 christophe.leroy@csgroup.eu, andreyknvl@gmail.com, agordeev@linux.ibm.com,
 akpm@linux-foundation.org
Cc: glider@google.com, dvyukov@google.com, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, linux-um@lists.infradead.org, linux-mm@kvack.org
References: <20250717142732.292822-1-snovitoll@gmail.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <20250717142732.292822-1-snovitoll@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: pjdtadaxhqu3mmyb4roj1sap74i1boc6
X-Rspam-User: 
X-Rspamd-Queue-Id: 66F6020009
X-Rspamd-Server: rspam02
X-HE-Tag: 1753138786-853461
X-HE-Meta: U2FsdGVkX18vGZacL6Nps20CEXCLFmCaHANySphf4PcWspqJwQruPsVJysZHusq5a6NckPF9v0NbXJyjJZ3VuHpdWkexh59bDBkxfxg1aS/XRzAqglZll4dzWYF8rfndErLoD8es1VmIn3n7tqoUupRtbEg0iK3kOKOoDWEOLRYGVnAGUQzSYJz7e0UBJ7Hj7YJJFFBCe8moy0AA8XteOLCbR3kTTfmhrlgF8BNZ7S3AFkM7COs+RLB14tQLzlsNddrA5d6xvCTz7Pi2eD6vBKksjT+8RS+Qs7GAwzUBu9J/R1xRNBJo7U31qJCj7YzatUpqsd2t6j3yHLGXiRPWfXNuHGCl//3Wv9rt9H1yX5k6yX/gJY+AqjBQjncAStSrmm+t78ncIcO2RFrJSLjl/PEvsUON8WGRHzLCKMtARfNS+0H6dMD8cb+dELXnqcdnp/s1CQI8DJKgcVPUXkqAedW3KjlwuzQxiy31xbkkudLbbwPS7j0LNyIHp8zGYCnzEtPOU97W69eIyzD0juVKWbIOkmVKiaCDq2dxY9HJ9hChsbnY+PPJ5tsv0ZbU5K1ywHHvYj3PKcuwSREb6G5IJfIP334ZUtyUz6v+vLpN5Xmz3BghgcfwIJmDvJlR0D+MR1gOk8mIh5pxv26gzioEgnISXNpRgm6YOwDNk1gMY81ivxWzq2Jvzc1NRO6Pn81coGBqbNt6bTfDU7AsyYNWG5hRZX8sTEmUT4/aAt+XgRD+/yRha03dt0LqMajmhtaiEV8htrjXD2bPAMPCNGjPGXct1CsVBTro/N7Er+0769YeaNwpUEbcTA3MghEYmGn5rXCExI0NFylf5+8Ph1a4r5ZdAcnvAWy97IvNHBRH+65NcmD7B4uM2bbSHsiMJ7EfWS0sLZc+v4ia44ksE4H+o+TKTzQ87lvwamICA82toOgHkcUFRvE4jS2HZo2nqsODknCsMxw/MBQrbQcO3A1
 IEeqfB12
 2xEExTEKvLUgLttUBuHqfH5xWmk4UrVJQhWzE0/2EVp1MxjawsPEWozMkXJhpqaxFXnekkzhIh6vg1fBGVelGpvI7k3Gz59Z6hngmtSIUXt/LS/vFXsY8ksZt/YPoMekt9otLD7I2SYv2UTKmS7NicEuLymVh5FGQ3cOlWg9V9x8tQWgR0d4FmObTyMU/dwiZyNz6Y3rFbdsDwyuc4eabGMeHBbLQ7ArS0TRK2F7VjwX1JP3Zwl2i+vsDBJKJKjmbd524nu6meKifI6mY2+6My8Thg/c5JJqgodasnQaGrkAMhZH25HWBNda301u87dgbz9t6n/+E7RQy6j8TFRJWrED9GudaRUcgwKhGXZvGigR2OyMKpzgfAAo7X5eG6BKdG8mK21ylcFFuY3Ik6TB7cilhzPJsE+THNn5Y2woqd+3jHg7ged68jAO5wVMml0Fc4LcusJ79W8aW+vN6ahQ6OfYz8evZdy0wnUbxVfV0oH6zrg9Qv7i3q4IiR39Jop3JEN2IDIwBT33tdjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/17/25 4:27 PM, Sabyrzhan Tasbolatov wrote:

> === Testing with patches
> 
> Testing in v3:
> 
> - Compiled every affected arch with no errors:
> 
> $ make CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm STRIP=llvm-strip \
> 	OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump READELF=llvm-readelf \
> 	HOSTCC=clang HOSTCXX=clang++ HOSTAR=llvm-ar HOSTLD=ld.lld \
> 	ARCH=$ARCH
> 
> $ clang --version
> ClangBuiltLinux clang version 19.1.4
> Target: x86_64-unknown-linux-gnu
> Thread model: posix
> 
> - make ARCH=um produces the warning during compiling:
> 	MODPOST Module.symvers
> 	WARNING: modpost: vmlinux: section mismatch in reference: \
> 		kasan_init+0x43 (section: .ltext) -> \
> 		kasan_init_generic (section: .init.text)
> 
> AFAIU, it's due to the code in arch/um/kernel/mem.c, where kasan_init()
> is placed in own section ".kasan_init", which calls kasan_init_generic()
> which is marked with "__init".
> 
> - Booting via qemu-system- and running KUnit tests:
> 
> * arm64  (GENERIC, HW_TAGS, SW_TAGS): no regression, same above results.
> * x86_64 (GENERIC): no regression, no errors
> 

It would be interesting to see whether ARCH_DEFER_KASAN=y arches work.
These series add static key into __asan_load*()/_store*() which are called
from everywhere, including the code patching static branches during the switch.

I have suspicion that the code patching static branches during static key switch
might not be prepared to the fact the current CPU might try to execute this static
branch in the middle of switch.

