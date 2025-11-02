Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A317CCF9E3
	for <linux-mm@archiver.kernel.org>; Sun,  2 Nov 2025 10:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632528E0007; Sun,  2 Nov 2025 05:36:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609938E0002; Sun,  2 Nov 2025 05:36:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F848E0007; Sun,  2 Nov 2025 05:36:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CF248E0002
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 05:36:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3DE1C08E7
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:36:06 +0000 (UTC)
X-FDA: 84065311932.17.1B42223
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id E0EBA10000B
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 10:36:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/pe4zja";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762079765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ovu4hk1QeQJCG4bKMFk7VDTxcv3q5N8PBdUxZwYYOd8=;
	b=1BpWge21fZT2EobBu4mIEymQc/u/kmUmhXDjemoA5tc+vKY4+HO2ALWJgYJvVGbGb2/tUX
	3N76XWUsDmAc3FHxxTigek8dBDwvOlHkcm7W4Eyqyrold6ZGK+a3DsKnpKJLxSsVvvS5gw
	YDCcanH6CUyw25OinzzKOK5iWsrFMAI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g/pe4zja";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762079765; a=rsa-sha256;
	cv=none;
	b=CT+AuCbV+KWdqVLxmCYqS7eHKQeqtfx7HbNLZlBv9zkEciHhcJCScQyLYueY9rjFVOIzEC
	l8XSJ17N8GgWYVY3QLSfxLTUUXUVOLc4Bv1/P9SyqzE4jR/cuflQ9OID2bDdBpwp2ViOzf
	J7GB2q1Z5FRde7zMJjgzak0re/N3ppY=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4710022571cso34479635e9.3
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 02:36:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762079763; x=1762684563; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ovu4hk1QeQJCG4bKMFk7VDTxcv3q5N8PBdUxZwYYOd8=;
        b=g/pe4zjap08RhAHOH4FQVEauTB86HSAfkxMV45o1vWYm0aOEA6GtyatGonZG2gj1Ts
         NqASVfLxFblITMW100Vr5CG9HPvK5zeDxoJnTvm3rNBqia8u9OYy1ErKDe6ortiqjuj/
         eZz3RS0cPgZd7zaZkF6pbFzDZ99Nh+9Ly0w1Lu2efzSZHegFn96lH4ARDznkut9/z4Ji
         wmIa27OQPNIugSmM7VsLABvNQ59lpfSSqlAXLONHaLQnBXJG1a1E830c9xQ1eAVQKgvl
         xHF18hSWONqXrzrIScUjqhd4GegPpfs+63HF2wTsMmtorVLoy3b7t0AfU8Jx0c6bkLd6
         j7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762079763; x=1762684563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ovu4hk1QeQJCG4bKMFk7VDTxcv3q5N8PBdUxZwYYOd8=;
        b=qU6nRrcIS46DkWwvWZ+/aIc6i3CpBLu+9TzBxczhgc+GKO7MkSaLO41LuqHQwTeaNl
         vndoDS0i44bc+WZxvxG86kQoWqAb9fz88J9Kc8bBNwxtfap8dA8rBPjL7Em5VyoChXa1
         XzLD9+GvG1W14oqNntVwXtbqo+vP//144tnaQDnon400WuJvSnf2ChRv8zkHIKDYjWgD
         ewz/X9zwis6Zq/9b1zzREymcrDeJ6cqBspxzJnD5d+m2tDcZnlVj3pDgwm2sgysun4Vb
         RO5Y8PvD1oZXd9y+MQ2Th1B6Db/tShB+ZQuFWI5EDoNiRf+Cn4D/Lppv4j0ADnqFbkbK
         GxHA==
X-Forwarded-Encrypted: i=1; AJvYcCUBpM8p6wWGVe+uLTzbeHTImkq9kT/p5M4XVMR4RVx6bWt5YoU40A8LSaSYfs3vJ5wwGS8CgBnLUQ==@kvack.org
X-Gm-Message-State: AOJu0YyOdyltkeEA/P6LGURUnlPv6Y/5blb54m/GcWDWf4dcUdbqQZaM
	nn/27lRmGFl2UFL9upBJFnzqTrC3tgmDmI6MvFrEMJcMQrB7scKiZUzH
X-Gm-Gg: ASbGncvL97hatEMrh7MgAXKRgYdVnq2QMgCNbcwRIPis3BgACIVqSKKSpkb2ZfyGpbV
	K6kzrcntLOMVZ1UgDD8kGqCjG2WC72gzbUcj7T61RMQBnfzpZhMBjBjS1aGIXxrGEpGp83MyMcl
	LlVvmVpYqDUu3hlW8Q8ExZziIBoJxmnwXbd7GZoUwZs8ygLB3n75yMwNljlMmng6VmUHOkC+XJl
	M+eN8qCaBmqdgGKSSewfitHgwG4GmT6tGm1t+MrZFW0MLHsy/tr9gjChp7uDwqmIzWNmZXoZIy5
	wtUyweitC+OYiSMT9dZvJpwJ0POoU8HXqnRiE7wZKNWZ+vbM3S5Wshweyj+xufatjFHnJU9N22w
	jgmA1N51FC6EdposCdO7BA1UhJRCdsD1wk+V3tMART+YkEEhfQ7RzyWAAHYywV2F9BpnBcV8wZN
	RpXmGHOXVqX6Y/DZNZZYVb9AEWqRBAF5/b4uUekVqUDSqVH/gfjVUv
X-Google-Smtp-Source: AGHT+IHL30gVPu+1tpP35sbbUpZLKsl40U91AdkYUoDD4qFiMCXwuao1AO3rSfpQub8UcTTdTBgniA==
X-Received: by 2002:a05:600c:1c1d:b0:46d:cfc9:1d0f with SMTP id 5b1f17b1804b1-4773086e04fmr100701075e9.19.1762079762968;
        Sun, 02 Nov 2025 02:36:02 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fbeef62sm64496655e9.1.2025.11.02.02.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 02:36:02 -0800 (PST)
Date: Sun, 2 Nov 2025 10:36:00 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, Linux Memory
 Management List <linux-mm@kvack.org>, u.kleine-koenig@baylibre.com, Nicolas
 Pitre <npitre@baylibre.com>, Oleg Nesterov <oleg@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Biju Das <biju.das.jz@bp.renesas.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Thomas
 Gleixner <tglx@linutronix.de>, Li RongQing <lirongqing@baidu.com>, Yu Kuai
 <yukuai3@huawei.com>, Khazhismel Kumykov <khazhy@chromium.org>, Jens Axboe
 <axboe@kernel.dk>, x86@kernel.org
Subject: Re: [PATCH v4 next 6/9] lib: test_mul_u64_u64_div_u64: Test both
 generic and arch versions
Message-ID: <20251102103600.65754bf2@pumpkin>
In-Reply-To: <202511020421.ZZPBAIIw-lkp@intel.com>
References: <20251029173828.3682-7-david.laight.linux@gmail.com>
	<202511020421.ZZPBAIIw-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E0EBA10000B
X-Rspamd-Server: rspam03
X-Stat-Signature: kx911e9xnjjeskcuhiwrykk9abiizi3b
X-HE-Tag: 1762079764-4804
X-HE-Meta: U2FsdGVkX1+Ya4a9DLNBupzgjqkSz2pWjmpg6XCuHVpb52++6M0gzVLP2ae7wJt4pedz7UEU7DZ37E90Z2bylud/WphiTFmjKU2h2IzlPD5PxgREC7kGEOorrPjFBfY7Y3tsyzTZ6qJDV85/6kMkQG+s7UuqdMB0tcw1wFEO1TubGePepp/Gs4AZIqAt11Y+zjtK3Xh2denrowPippDMMV2sv7ltLl2KWRTp7Jl4fP0drf3DAisn+rDKGD419tlkv3KDNQKzR6+4mOX3TLCRXFdcRp7u+dRW4qxv2Fq7gCGSCnV3EwPokZpIMCaaOYIu7YbRsXhSs2asA8TTCeggE8ZciHNt/rz7SYetFfVv8tdvlHlxCWw1Zkfp8OERiBS1/UkONnNUnm5vUfNiQ7aJXlrqEWvAfBHF428g/KA1J5d9Qu43maBOvW2YA2UwmktAULigAhALK1XV1ZS5n38M0WoRhEBVxFMLFQABkMDxwsQWJRXyhFu4c83+c1hW80k4dA3YCpNaWWFVpHQX7LSheRoIZkAPRi0gkge1AIHLfoydF8cwYjsqzdT0q/4bagXOdaNEq2vPjR9Lf7GlK64I18ZCEHwrNPUPUSIAXVwnuN3mPr1Gl2EIPdFrADxK7LU9JY6sPdW+zZiBNMTr6fLQVc/Yhr4rP5WFbAeJMmAbynQurKZ4vMRuSLH/JsrrgJcq8tGmtCZahXqkjyKAz4B1wn4PazVJoxHqoPPWArEYdmb9JswX90QtX9qXwf0FQI0hFkCzFmvrWFyW/w7ERV7wB+qCK7QKQ5h9NXQX0wpjaS5+czqUzJrOHDsycUFGu0iSwdrZ38jspiS82t+TD/nqU1lJX8gJxE0isaTFcYU9zqfbW1Zz91y5NivMBM65YgWR/LJVSLRso3fxgY95cn35wG+kJ9VQNk3+xqSsLL9k7NOTTDW2ro1uYyvFf+Io8nw4ZrYbY+v8yxzZgem24YQ
 ihe6gGTx
 K8T9turtkpAJJIyCg+iUAjaVgWC7KSuGYLPMUyPbnJ0EzCh4hDiOpkl5o9XwTrk3fEe73zcv91gZrqONIVDA7hquyu8lwZzBo4WyXCGh8hXpoYIsGHCNQpAC1dMyH6HgFGNzrnHGU8352NevWqy346OJU5dboRPLLq7mrnaAFd5P6YqEyc48Euhs2DwYTwtmEeL6w7/L4249u9pVhW+zZOwilUbLX03HDjnZ8qoFscN56DVFmBsu6l8JuAb6KNxarxuQsP3U92QLmYaIl07vJK4EfLFF/4t5fKkdxx2HAXP/5vPAvHMlilGfCuawnXg65VigkzcHwrDQmCFKU441WV9fC6qikLiH7/prQROWH1ptYHalF2kbtACUCPl+UUYFOXFEIScc/NYc6zWjqwH+phoL43dtsxXsjlzD/mgJy2/FigMi7bYaWK6PsG4i+Cn3LOMbTc7mhZjjh07kpBPyluL/BRMDHAW/W6shYiFOnPjRw6mw1FZBsQEIawgSVRkG5GkD0R7NlwrSvwWpli5L/1iIsGHEXGjegAEFdv9Pxck8UfKEU6MF0SwD3k+fVnzG1yTd5kbxiWljbqpw/rmsmZH1f5Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2 Nov 2025 04:59:10 +0800
kernel test robot <lkp@intel.com> wrote:

> Hi David,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on next-20251029]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/David-Laight/lib-mul_u64_u64_div_u64-rename-parameter-c-to-d/20251030-025633
> base:   next-20251029
> patch link:    https://lore.kernel.org/r/20251029173828.3682-7-david.laight.linux%40gmail.com
> patch subject: [PATCH v4 next 6/9] lib: test_mul_u64_u64_div_u64: Test both generic and arch versions
> config: i386-buildonly-randconfig-004-20251102 (https://download.01.org/0day-ci/archive/20251102/202511020421.ZZPBAIIw-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251102/202511020421.ZZPBAIIw-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202511020421.ZZPBAIIw-lkp@intel.com/
> 
> All warnings (new ones prefixed by >>):
> 
> >> lib/math/test_mul_u64_u64_div_u64.c:142:9: warning: '__div64_32' macro redefined [-Wmacro-redefined]  
>      142 | #define __div64_32 __div64_32
>          |         ^
>    arch/x86/include/asm/div64.h:78:9: note: previous definition is here
>       78 | #define __div64_32

That is preceded by a comment that says it can't happen for x86-64.
I think it would be better as '#define __div64_32 @@@' so that you get a compile
error.
But that isn't part of this change,
>          |         ^
>    1 warning generated.
> 
> 
> vim +/__div64_32 +142 lib/math/test_mul_u64_u64_div_u64.c
> 
>    140	
>    141	/* Compile the generic mul_u64_add_u64_div_u64() code */
>  > 142	#define __div64_32 __div64_32  

It needs a preceding #undef
Although I'm not sure why a normal build doesn't show it.

Looks like I'll need to do a v5 :-(

	David

>    143	#define div_s64_rem div_s64_rem
>    144	#define div64_u64_rem div64_u64_rem
>    145	#define div64_u64 div64_u64
>    146	#define div64_s64 div64_s64
>    147	#define iter_div_u64_rem iter_div_u64_rem
>    148	
> 


