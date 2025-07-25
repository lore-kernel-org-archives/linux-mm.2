Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC76BC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB246B009B; Fri, 25 Jul 2025 12:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D2836B009C; Fri, 25 Jul 2025 12:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8E76B009E; Fri, 25 Jul 2025 12:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4190C6B009B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:42:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C87FC06E3
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:42:46 +0000 (UTC)
X-FDA: 83703355932.12.E623258
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13C5AA000C
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:42:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=QYk6Px55;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753461764; a=rsa-sha256;
	cv=none;
	b=DAIrkiJmsSELN4Te7LzGrEXdFLwN7eNd8lcvy6kLnd7zipT2RVsgNtE4ihTKKbgVV0SEwy
	/26EDdZydIpw8zKjCqYzM2GZKZcOLv8i7U3eJ9pSmSLnd4ODMOZ6vGjEGVgtWlkK+Xs+Zr
	VyS4ZnUD4xK5vjWPtxJdBDahJNKpt68=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=QYk6Px55;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753461764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8y2TNoIk2wdBhLwSEjjylt9WbC1a8YKSz5ABVX4y0Uk=;
	b=PlxaS4Rbc4JJw/IzFJ16N0xYs6abkq3pWeEF7ius+XHY9+u3hT1KeXIGq31GBwNYZ9WAyh
	EtCenZz0yZ4HXrigyGdYQfD2iiv42Y/rpo1ogL4pKWwZzfgWx/ijHDmH14nJol1728nQdJ
	vTjI6v1T8zjdpjuKLnUL2NP+a/G3aUY=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2349f096605so27885845ad.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1753461763; x=1754066563; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8y2TNoIk2wdBhLwSEjjylt9WbC1a8YKSz5ABVX4y0Uk=;
        b=QYk6Px55djSA16SopT0AXBnjh7xKiQlCDErDzQVKpZ20UHNjenRoQmiJRfoqsM9J7/
         FLMWRLlUChRt62bXGWnqAdi3/Nq2GRELWcWYpUK8c3WxaPjOIJFOVZ14jIEAHkeOqAvj
         QLZC16/P4d11CKUDSXyyRfYcfFSFztbUw8FI6CAX4PSdYNFz1h3VMpB7rnTJYX0zDTcP
         c/PMaRGeaYjOQy82hSmkABtWoNWuO7/Djhel4ge0VhJ/mPGYGDDJamquZ2lg1m+Jx22a
         YFKjrEUrLPDcu8Dl5nbGcMmIrROZzF7KZ/DMGJbM9OQEC4pOQ8gWivOTLOPs3B4JQJZ/
         lRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753461763; x=1754066563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8y2TNoIk2wdBhLwSEjjylt9WbC1a8YKSz5ABVX4y0Uk=;
        b=UDEUN9+OzHxUWg31P8yNkTVKlzRVz8kHV8hJ515lHce1v5AgnvpzFS+adveKAPh72r
         qca7RGl0h1ILgLUoPvUwvC1I3QbIMml/+eelIV7YndejztVpJFOVZ819kyQMVEsn919t
         THnG6D7Yem9HP1Sg4kgHfLzFF8XnKOJVI76SsdMiwhGVE4Xxq3xzpv7lf0w+3CvjGeZH
         XgAHIb1B3TFbA6MBYUayy6g2YJjyRN0vPhZ9p02UtXJVKLi6pJHTC4Hj0vwlI5w6jEZ+
         RmacOjn0yj2lvGtBiytur07OspafSQS7xBQ/2rPnKr3gkuXz8nmh6Kg596yeLqcNPxN5
         /6Bw==
X-Forwarded-Encrypted: i=1; AJvYcCXiuD+3yrckyGxdRRw3yKYe8Qyf5pzLWnTc1UhPGrk/4O5vP/MmKQtFkSZUJ+WgYIl5A8rVZd3+9Q==@kvack.org
X-Gm-Message-State: AOJu0YwF+mEyPWr3IvIPX6k3YHkw0qmBkWtefye9s2FCBgrbJWDrTm2l
	D16KlzGlRtnIq1Wrtaw1N0gwRxuc9hsvzBv+T7Si15bMnjKoCusdHEG+rQhp7PyjceQ=
X-Gm-Gg: ASbGncuwL+W0f6UX7zJ88ArfYF2OkUnDKeqoFtsJE7i2bjulDb2E79Wf1Rfaom3lCnb
	VKtKdD0ugKPMwPvFNcll8DoM9a2rVddWTN2cGD46iiGSbZYPiAGGF4RAdKjO/KsHXtXU0Uya/Dx
	6yhONndJhEz8mBZJ5WpOG1Be30cREPpjkQ4M535obkzPxwiIbrBCNb5L28exearU+iO+oiRNOUD
	wPdeqC8a29eVJuv2Ny85v8STpvg0ohY7eiAeZvVLPBO3cDlRTIy59D/ByA1D1H0l0oY2M7ZP43H
	GwZlap6P655oLLs5qK1J8e/pPxpu15dxjhu8x63qlZKBRkXNR8BWUPmWm0naG47fOJIgCZBWAyf
	+CuRJ8CaxhUV7Sml1o2aiUktWKpY8VW9r
X-Google-Smtp-Source: AGHT+IESsSEPy/ac8F6mWdBj6vdPwp9s3VzEdxE6SjFz3Dg1QtfJX8WaXR44J4QcA36ULd9Dz05/pg==
X-Received: by 2002:a17:902:e891:b0:236:94ac:cc1a with SMTP id d9443c01a7336-23fb3179530mr40948875ad.27.1753461762804;
        Fri, 25 Jul 2025 09:42:42 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe30bbc4sm1244165ad.29.2025.07.25.09.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:42:42 -0700 (PDT)
Date: Fri, 25 Jul 2025 09:42:39 -0700
From: Deepak Gupta <debug@rivosinc.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
Message-ID: <aIOz_wxxCr8tPgXz@debug.ba.rivosinc.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <20250725161327.GC1724026@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250725161327.GC1724026@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 13C5AA000C
X-Stat-Signature: 51rxny8h7f7hdmsdpch4jtszpegi468f
X-Rspam-User: 
X-HE-Tag: 1753461763-620847
X-HE-Meta: U2FsdGVkX1/WuYeYlE8qVkXdFe9S/4kmdAjq2o11+6Ap2myFV8wpiDNDDhGuT3+v5nKB1sYJgJcwuqvnGUTm1IcEaq+6wquUF62CMBwjAZh4ittEt8Y/dsOIPK8EX4TJd+1BOn9AkGPLg0XnxbZDU9vqQVX/D1l/9jv8V+/xfGtD69LOqpubQ0lnXhaJcesScT388obFrSPpn01Hu98DZ+tZNcag09szFpJ+rzfPHt2VXlr7YDYXe8uAq95MTBXBuEHFqRmVH6p+yifW16KjdJCff4TMSg3z5guRw7HrKj0RJj2aYz11003twvRhTz8mkI3aL+iycknv50FLIJLQv1riUiy/Z213PUWpNqxgUUTeaY/HvHRxP4LyZ4zgoIXXQUqVeEW2PMRQ0nV6SqlqlLSgtD/VYOYpx4A7u5LkCC3bppqtBsR2q2O+zZcVhZhX5mFdIct2Q6h/NE9qTVx3ShJhO4f2Va1lHsYv+HmCjk9ZD35kf+R9TXPtAhe3eA8HFET+RB0Z6ZAZviWsrGwDkK+ZPaKq89MdAUW9r4b+cbQ7x0hXvNKZrlsTVgxXE8/nPTO0uTUg+tJEVdRmkxX8B6uVcfoHidJzvuezVeRjB3s/9TX+wtWl2fufWdtjCtDDn6DDrS3dppG7I//ChuaDE5eKvjMpF84w9W+lWV2IrJydRCwZLad3A5a1K19ZvsYi+Xj5adXMgonrftnuuyard6jYTsDY3zHnxKTFijBx/rJgBMg5HXyZG2J4O2v17YzLvY757u2pA4jGuiGUhfTLfll359izkmPoklo/XzcgIKvWYqfe7ux/RZ0ktEsxSIuqekvMXwxuTSgY0QCfmf7LGFBZbgFp8oROXNuY/H63I8fSXuUWd+p9HkkyXagjhdGKLOgZh0Trbk8jRnunbIoBLmEmZkUIzGHWKY/FCYYtrtUlhRVaww5guMxqeTFR7SoisblKUSzWYcq7mur4siU
 9LUVbdWS
 EotPGOlXzxurtJf3lETIFrN2UHks/jQJbz+XLHGS+JAejMUI9Qy9+GDAypybRhEnz1pujo7ShiyOiT78W6K7tMJvycqyNObGqeDt5IDyvLGnasq0m691WJS/nuYT6ZuUjrYIrMoonDEoeT890Rf4kAUzX/2Jy8fOeTh1moIN5Tww3ZqF1FIcuBasx3Fm/sLnm5AKgtA5edZTYyRuxhCfZ9vlY6vi7OO6v2PAjP4XdQeG6503JfPO/pw3X6X2iP4X5zGAANaj++8d0Uov53UdxSirlIHwGUGcO0Alzw0CltI26KVf9V5iSzBNH7AczJJWniIvv+FwvMBjs5mwQgR1+c5k4VtAURmBEZl4tlVC3G5D60IEDjLRJnDJPOoeFXxewgI3rV44VFvvOqiVyVaR3KdSWyR9p1ucaLXsJE97EpJ78Hho2ijjauD6q4jjcULj1aDn6tDGEQRoUpxL6DBNKw2S0SiD0xDAbBFKSMCBKjwi76adWJrsLbRSkq2OEF+cZ/51mEgLxwIHY8Kn8rJHfzIS7HUOnm2nZ++YA62RqMUXKO2MD6bJcRdzdt9AGwqD4MtcsLPRUoj0Z2fJgroD1U/GaUFaKh8t7Wy6P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 04:13:27PM +0000, Sami Tolvanen wrote:
>On Thu, Jul 24, 2025 at 04:37:03PM -0700, Deepak Gupta wrote:
>> If shadow stack have memory protections from underlying cpu, use those
>> protections. arches can define PAGE_KERNEL_SHADOWSTACK to vmalloc such shadow
>> stack pages. Hw assisted shadow stack pages grow downwards like regular
>> stack. Clang based software shadow call stack grows low to high address.
>
>Is this the case for all the current hardware shadow stack
>implementations? If not, we might want a separate config for the
>shadow stack direction instead.

Is there something like this for regular stack as well?
I could copy same mechanism.

>
>> Thus this patch addresses some of those needs due to opposite direction
>> of shadow stack. Furthermore, hw shadow stack can't be memset because memset
>> uses normal stores. Lastly to store magic word at base of shadow stack, arch
>> specific shadow stack store has to be performed.
>>
>> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
>> ---
>>  include/linux/scs.h | 26 +++++++++++++++++++++++++-
>>  kernel/scs.c        | 38 +++++++++++++++++++++++++++++++++++---
>>  2 files changed, 60 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/scs.h b/include/linux/scs.h
>> index 4ab5bdc898cf..6ceee07c2d1a 100644
>> --- a/include/linux/scs.h
>> +++ b/include/linux/scs.h
>> @@ -12,6 +12,7 @@
>>  #include <linux/poison.h>
>>  #include <linux/sched.h>
>>  #include <linux/sizes.h>
>> +#include <asm/scs.h>
>>
>>  #ifdef CONFIG_SHADOW_CALL_STACK
>>
>> @@ -37,22 +38,45 @@ static inline void scs_task_reset(struct task_struct *tsk)
>>  	 * Reset the shadow stack to the base address in case the task
>>  	 * is reused.
>>  	 */
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	task_scs_sp(tsk) = task_scs(tsk) + SCS_SIZE;
>> +#else
>>  	task_scs_sp(tsk) = task_scs(tsk);
>> +#endif
>>  }
>>
>>  static inline unsigned long *__scs_magic(void *s)
>>  {
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	return (unsigned long *)(s);
>> +#else
>>  	return (unsigned long *)(s + SCS_SIZE) - 1;
>> +#endif
>>  }
>>
>>  static inline bool task_scs_end_corrupted(struct task_struct *tsk)
>>  {
>>  	unsigned long *magic = __scs_magic(task_scs(tsk));
>> -	unsigned long sz = task_scs_sp(tsk) - task_scs(tsk);
>> +	unsigned long sz;
>> +
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	sz = (task_scs(tsk) + SCS_SIZE) - task_scs_sp(tsk);
>> +#else
>> +	sz = task_scs_sp(tsk) - task_scs(tsk);
>> +#endif
>>
>>  	return sz >= SCS_SIZE - 1 || READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
>>  }
>>
>> +static inline void __scs_store_magic(unsigned long *s, unsigned long magic_val)
>> +{
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	arch_scs_store(s, magic_val);
>> +#else
>> +	*__scs_magic(s) = magic_val;
>> +#endif
>> +}
>> +
>
>I'm not a huge fan of all the ifdefs. We could clean this up by
>allowing architectures to simply override some these functions, or at
>least use if (IS_ENABLED(CONFIG...)) instead. Will, any thoughts about
>this?
>
>>  DECLARE_STATIC_KEY_FALSE(dynamic_scs_enabled);
>>
>>  static inline bool scs_is_dynamic(void)
>> diff --git a/kernel/scs.c b/kernel/scs.c
>> index d7809affe740..5910c0a8eabd 100644
>> --- a/kernel/scs.c
>> +++ b/kernel/scs.c
>> @@ -11,6 +11,7 @@
>>  #include <linux/scs.h>
>>  #include <linux/vmalloc.h>
>>  #include <linux/vmstat.h>
>> +#include <asm-generic/set_memory.h>
>>
>>  #ifdef CONFIG_DYNAMIC_SCS
>>  DEFINE_STATIC_KEY_FALSE(dynamic_scs_enabled);
>> @@ -32,19 +33,31 @@ static void *__scs_alloc(int node)
>>  {
>>  	int i;
>>  	void *s;
>> +	pgprot_t prot = PAGE_KERNEL;
>> +
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	prot = PAGE_KERNEL_SHADOWSTACK;
>> +#endif
>
>I would rather define the shadow stack protection flags in the header
>file and allow them to be overridden in asm/scs.h.
>
>>  	for (i = 0; i < NR_CACHED_SCS; i++) {
>>  		s = this_cpu_xchg(scs_cache[i], NULL);
>>  		if (s) {
>>  			s = kasan_unpoison_vmalloc(s, SCS_SIZE,
>>  						   KASAN_VMALLOC_PROT_NORMAL);
>> +/*
>> + * If software shadow stack, its safe to memset. Else memset is not
>> + * possible on hw protected shadow stack. memset constitutes stores and
>> + * stores to shadow stack memory are disallowed and will fault.
>> + */
>> +#ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>>  			memset(s, 0, SCS_SIZE);
>> +#endif
>
>This could also be moved to a static inline function that
>architectures can override if they have hardware shadow stacks that
>cannot be cleared at this point.
>
>>  			goto out;
>>  		}
>>  	}
>>
>>  	s = __vmalloc_node_range(SCS_SIZE, 1, VMALLOC_START, VMALLOC_END,
>> -				    GFP_SCS, PAGE_KERNEL, 0, node,
>> +				    GFP_SCS, prot, 0, node,
>>  				    __builtin_return_address(0));
>>
>>  out:
>> @@ -59,7 +72,7 @@ void *scs_alloc(int node)
>>  	if (!s)
>>  		return NULL;
>>
>> -	*__scs_magic(s) = SCS_END_MAGIC;
>> +	__scs_store_magic(__scs_magic(s), SCS_END_MAGIC);
>>
>>  	/*
>>  	 * Poison the allocation to catch unintentional accesses to
>> @@ -87,6 +100,16 @@ void scs_free(void *s)
>>  			return;
>>
>>  	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
>> +	/*
>> +	 * Hardware protected shadow stack is not writeable by regular stores
>> +	 * Thus adding this back to free list will raise faults by vmalloc
>> +	 * It needs to be writeable again. It's good sanity as well because
>> +	 * then it can't be inadvertently accesses and if done, it will fault.
>> +	 */
>> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>> +	set_memory_rw((unsigned long)s, (SCS_SIZE/PAGE_SIZE));
>> +#endif
>
>Another candidate for an arch-specific function to reduce the number
>of ifdefs in the generic code.
>
>Sami

