Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67798CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39648E0152; Thu, 18 Sep 2025 11:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10198E00F6; Thu, 18 Sep 2025 11:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4D158E0152; Thu, 18 Sep 2025 11:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A2BF48E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:52:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07FA1C0260
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:52:51 +0000 (UTC)
X-FDA: 83902814142.16.A3C2B69
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf18.hostedemail.com (Postfix) with ESMTP id EEFC41C000F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:52:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ba84fYma;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758210769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4tOEHafOTi5CrXOSO1m8dEnNyNggHvPpDClq9ufaB4=;
	b=z7VSgdK9Bpp2ABzj2nJTWL6CLrcW00UPC4lMrD+fE01ULnKgzwU+jaSurcV82C4b9VbSIJ
	b2SJzus2Z4qlZZWQfUO6j/qKzBstOsvrCseNx8TXCoAT2VVBvi2yozWrOtaM0HMat1Hem3
	FCA2AXPBYODjWjnbwx3aZ+jNv5JH0ZU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ba84fYma;
	spf=pass (imf18.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758210769; a=rsa-sha256;
	cv=none;
	b=2RkPciBsVNarH01Y8FTlqxNFCMs5/g+3pSFtPZak1ZtTDLGVBK72uvR3jNiDIbb2vXRrU6
	O0l5nBVF6NRZ0A6q28JYxyOaBZOFVEGEF++y4AKU+kibiBTO0giDezE77FsRf2m6ETQUAz
	Cfzzj98tx4KMTtVDESPeO7RQdB+cusU=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-46256e402fdso1837495e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758210767; x=1758815567; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b4tOEHafOTi5CrXOSO1m8dEnNyNggHvPpDClq9ufaB4=;
        b=Ba84fYmakR8VhGjcKAcBow6PJ4Q0B16Q5CfyGUvE805m+aUvRyT+fHF38CswTouzmb
         +4JSsJ5dCHpmVsQMWONTwepPMRt+1qqMf4Tk1vZdTP4YcVcmwuNzysjw2OPPu+Q3Sy0k
         HAOPttdoAvzpfaOYHOhcVNzKASzdVzsnayoijJ90x2puzhJDG10889hZHpm94nNmfYXa
         /lQxtdSqGVbfZmzil8OB1MFzmOGxJ1bqGsUE7WgnDOhGDIGGlyahwvDizeyryZLvoapY
         cl1+yZnacCOfqxJDVEfmQNfi84HWv0mDBRP3fIKL3loQh/2qbafobcKnseVhe7rRbLL0
         jZRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210767; x=1758815567;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b4tOEHafOTi5CrXOSO1m8dEnNyNggHvPpDClq9ufaB4=;
        b=vhBXILojX+WYdLS0BSXXWOtRXi/vBrnSGuxZaZYEaHRvCe/8h2Z2d5BaIkyAZRizdQ
         KqiNRs/YvFdkXj1q0ECOU3kXpb9oKvvbVLgcGJdnyqA1PKsJ/6x3GBCd6/GjNBsfjrBy
         QUrBXFnijYYpBdaoQi2c9TIOfnzDxpKIwo+OZXxLkFBDYwaqZB3IzALo6c/JV5V1N3fJ
         E+tTxOwfSFTCoZNT8edRT4LBAPfIEK+6DYHDTMG5aLBQG6v5G4nAwaDAt4+JlVB3Rps/
         I4kQTM5oIoFuCyeX1iqfZIpc4MEYyY4kURzUyA7JvpgzRkaTduQzr6+1+s1CjAXBYc8V
         /Okg==
X-Forwarded-Encrypted: i=1; AJvYcCWs46/xAw0SQNdNKHURIZWteZaviWK/NQof9GoPDNu40hHyfqnGC0njvA7CvFdF5XK3R7nEeJ8rvA==@kvack.org
X-Gm-Message-State: AOJu0YyrBdQ8LGFV7GjONnUVP0D8A+vbkEuIEHzFurbfBnxhPjemahhw
	b9QW8cMghIkpAqMN+K6SjWRtLWF7MOBhwRz4HkJKXP3AWRAIVvbmKeiN
X-Gm-Gg: ASbGncsVYSn7/GJ5ucM115iJy4kFCnVh8dc1GSYOk4B4198s82YmqaQlLzUD8/zaBSZ
	GsecaF5M4XBfD4xYhbiTnWfqT6S06FWWr9nfbhY2snRde42nSPx0XbanORf0yzTWmLwf14OleHL
	U7pynJZ9JUtHlgCdNLUUrrkUG+LNv1wz+zH5ofX4NfSjp48P3gIAmYJwbIgpOaUM7K3kU9rTPjt
	o9ktcIZ6ZrgNKVkdOWAsLNcyanbsCll65XDsa4kaFhQNULViGZBXKVTX8MHPxR752RsrMbnh/2Z
	wX+qpw+ae9NFPp8rHqNBpK4MX1z3IjFJAoX4ypf+St1QmLBgwU6ZDdnZww1AKkmFUm7wS6Q19eo
	+kMgkPBcyZbjI6sn+Z9L3i63XgEUasRm/+PujiA7700s/4gw=
X-Google-Smtp-Source: AGHT+IG0MfbY3dY99xKFXmJfWWQhOAQTGGYXwxyEVK9fIcFhqDqMdo/IcROmJKmQtggm9VagY37U2w==
X-Received: by 2002:a05:600c:6308:b0:45c:b6d8:d82a with SMTP id 5b1f17b1804b1-46206283dd3mr33695135e9.6.1758210767067;
        Thu, 18 Sep 2025 08:52:47 -0700 (PDT)
Received: from [10.214.98.247] ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46138695223sm87677465e9.5.2025.09.18.08.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 08:52:46 -0700 (PDT)
Message-ID: <60b9d835-b164-4775-b9b4-64a523c98879@gmail.com>
Date: Thu, 18 Sep 2025 17:52:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/19] x86: Add arch specific kasan functions
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
 sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com,
 kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com,
 alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
 trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com,
 joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org,
 graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org,
 ardb@kernel.org, thiago.bauermann@linaro.org, glider@google.com,
 thuth@redhat.com, kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
 nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com,
 justinstitt@google.com, catalin.marinas@arm.com,
 alexander.shishkin@linux.intel.com, samuel.holland@sifive.com,
 dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com,
 dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com,
 jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com,
 kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org,
 jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com,
 ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org,
 peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com,
 ziy@nvidia.com, smostafa@google.com, ubizjak@gmail.com, jbohac@suse.cz,
 broonie@kernel.org, akpm@linux-foundation.org, guoweikang.kernel@gmail.com,
 rppt@kernel.org, pcc@google.com, jan.kiszka@siemens.com,
 nicolas.schier@linux.dev, will@kernel.org, andreyknvl@gmail.com,
 jhubbard@nvidia.com, bp@alien8.de
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org,
 llvm@lists.linux.dev, linux-kbuild@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <7cb9edae06aeaf8c69013a89f1fd13a9e1531d54.1756151769.git.maciej.wieczor-retman@intel.com>
Content-Language: en-US
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
In-Reply-To: <7cb9edae06aeaf8c69013a89f1fd13a9e1531d54.1756151769.git.maciej.wieczor-retman@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EEFC41C000F
X-Rspamd-Server: rspam05
X-Stat-Signature: t9nck79574ufu36z46hgrm7xx65z91hw
X-Rspam-User: 
X-HE-Tag: 1758210768-527319
X-HE-Meta: U2FsdGVkX1+Z90MGNxWi/ciW8OTHGRCXBbS2NJFak97E0VvUqx+Abfxpl2rSWOFJfdNmcNNMInwUX9uTVCuy7lTwtXBgueADCxxmhZjZW0VGbGIyV+Juw+7BH4ODj+YsnNi5RhoXfP8dQtXATPeSzUPbSC0BuJYJp4dqDj9zl+62zk2Tj1ktTDezXs+J+ZEyt39Gfnye7jYhBy30OSoVpMgwecX/Hgco8XBuZWzILWMVsVFBZ2hW3wKFM3aNTg9j4yHo+XnjcXxK4IEbGd3A9XPbr6Mn7iK2YzSQQVEVZj+qURY5w1ZKwwBDBI9lA6a9dc69mJS6aPNvso9BIGW+H6cO0zZwJJIz61wgWGEXzDAVwXsKjxJMXBpOi2RyB8Z/BEQpoqXJvKa8iu6j4b0YhoFU7TIrT+oEtPTP8cLOkZshbJ4DF44Ly+EAutm2rK9PTUNr63pC83fjN7wNgxbizQUZvZzyYbNCJIg6VOf8ZIbqrIaJYCnOesNNa+xbnqUoye65vyHL9m36P/s+pP17ivI+4UZQPqQc99xOMkxPI68uPcZcD7LJ4FxzIqW53XehmydR45XagNzXcaOgYSUN0DWg5Irnyc2u5Gy4z1xx415u/OKvv6EPNTo25f9bntZ/f23cUQroHZd66ZhMisI6PSCaeigtAaGeIWHm65TaplShsyD6V6qRd/iWlImAtX88HyfMA0Ktg7Lix/fXTnXXbvplCT37kHMfIr45ZXkvWDghWx3YN024A+Sw9D0rw0+EyyABanumi3WFoDvvxXQOJmH1Mvi3RgSbJjrHbrwRnSG8sVlBMP7bdYqBD6dSnAkEQRVjwo+Y4rLO/AxlG5Mtm8HHNaqvExFzfDOANHtSsdp/QBLxxcNSvjLmskI81Sx4GLgfp19cCJcPRC0cLZywlYTySzh3hHcGg8X5ZqAXCSHkwwHcco4Da/Zekc/hPYpNh5aU41eFE5jplZhvIdN
 RTcooCC9
 wP47O9Jfx0ebxFzkc6V6qY/Uplc7zesVcM/8avdSvMUkOjWaOsbMRvKxUJu2JqlVIhLokm8FJk8WTF3TSUdLKqaPvi/uSVtfmdOdLUc7WfG7W+1Hs6uS2nxRTf7kko/9aN8igPSMiF/XNgC9GyKJduTIuYTdXjvQ/128/fNR3oY8H3iNn0lwoZnXbAh7CU9Sdbe6N5q+/76braQwKNTVKrQdRWDgTn85TtCrIzCvFXKHnqfpF5dSSuH/r0KQ7huYeyBTL5Ul8IhDKq/Zijjsfv6w9SLY7CXLxy9zzUKiOnzSZcbcG2gyphxM7gONK+vCj4YaATnItrHnO7PBa2Qt+faUQSBb7/SX/qdaISfewsfauNTABkBwdSFONigpH3p+wuyPHeNDJOIz7FcPKI8504Kln0/fTV5ZG2UG6yFDC6hZe6pM22+NJP9dfb9tSXk1L7hXqF1PyMMoYvHWWbe0feAV7Mr9aUBKrFCcKHpD+T175KwZBd3CnIah/NUw9D/Spzrt6A7/I6WzCOvmndOC+rOfjfdVICn5gNwFYn+l1q04Jdmm1Xqjj/OyZpCqqAa3/SNEQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/25/25 10:24 PM, Maciej Wieczor-Retman wrote:

> +static inline void *__tag_set(const void *__addr, u8 tag)
> +{
> +	u64 addr = (u64)__addr;
> +
> +	addr &= ~__tag_shifted(KASAN_TAG_MASK);
> +	addr |= __tag_shifted(tag);
> +
> +	return (void *)addr;
> +}
> +


This requires some ifdef magic to avoid getting this into vdso32 image build process,
otherwise we'll get this warning:

CC      arch/x86/entry/vdso/vdso32/vclock_gettime.o
In file included from ../arch/x86/include/asm/page.h:10,
                 from ../arch/x86/include/asm/processor.h:20,
                 from ../arch/x86/include/asm/timex.h:5,
                 from ../include/linux/timex.h:67,
                 from ../include/linux/time32.h:13,
                 from ../include/linux/time.h:60,
                 from ../arch/x86/entry/vdso/vdso32/../vclock_gettime.c:11,
                 from ../arch/x86/entry/vdso/vdso32/vclock_gettime.c:4:
../arch/x86/include/asm/kasan.h: In function ‘__tag_set’:
../arch/x86/include/asm/kasan.h:81:20: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
   81 |         u64 addr = (u64)__addr;
      |                    ^
../arch/x86/include/asm/kasan.h:86:16: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
   86 |         return (void *)addr;
      |                ^



