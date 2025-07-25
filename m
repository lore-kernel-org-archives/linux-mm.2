Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC95C87FCE
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304C46B007B; Fri, 25 Jul 2025 12:13:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B5D06B0089; Fri, 25 Jul 2025 12:13:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A47D6B0092; Fri, 25 Jul 2025 12:13:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0789D6B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:13:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7CC114081F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:13:38 +0000 (UTC)
X-FDA: 83703282516.06.EEA3A0C
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id D2D3340010
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:13:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CEOIj6mL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of samitolvanen@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=samitolvanen@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbMA4/IPXQaEHQepmsbHPY7QV6shrVDJW0bf+hd1ByM=;
	b=fu98cDY+L5jSuYHj1zRNXNjPIC7Z+jW29lcgUWEZFhrWe4DtaxbqcgwGATp21jysqUJzuy
	1ds/k9RJfMdaOSsL4xgArdjGXUJIkaXoPHwMTe+YlfRgX6vvCNo6dWiJzqj0PMyRySGU7H
	sQZeikts+ex+QDS4O0HBR2ovHNlvLCY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460016; a=rsa-sha256;
	cv=none;
	b=yj7Sd/J3bYqoQl0umv9kq+tJFN4+fN4tv3HBEz5LVWU5BvnQKm5kdhY2u/FRvQAQCJ8Dgg
	O4QXe/68Ir5XiYTs43Sr1zG0KANRF+0TpLA3qsZquZ3NWa7vrKvz1ehhHwJFM29jrdWEiP
	6b1cJ2WJD1BlEIvkmSUtfzCrkPsVuk4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CEOIj6mL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of samitolvanen@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=samitolvanen@google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-235e389599fso232125ad.0
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753460015; x=1754064815; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CbMA4/IPXQaEHQepmsbHPY7QV6shrVDJW0bf+hd1ByM=;
        b=CEOIj6mLDAkrGxPM/5ni1sxyv6L8YFAktwtzOTSjbG9otFG2eAVzA4UlOcvKB3PR7Y
         yk5d3kxJbQCKqzAq9MEMRVKdcJHHYry7/9no33JRFN+S88XFWZLpO76+qb4NjUPsHUfn
         Xi7o12TxHDeIcAOp2yc1dqFBrnkXjMeZpY5Xj3aVLYI2c+9BIA71Jh1Ia1q0vGqiHkN1
         pBcANqMaNU23/Z8Vg3FM2VV4PGMS2+ro65VMWWCdGVTOyQYFHze0QXsKSvQ3YYGpo/Ar
         qLVULDUtStftr5f1b2i0C5y7YJoaLSsDhHQlVXU1Ix24JzLCYejqOGfXM5m4u0JYzfSu
         rbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460015; x=1754064815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbMA4/IPXQaEHQepmsbHPY7QV6shrVDJW0bf+hd1ByM=;
        b=BAeb9mvz6yjoX4NCAy0ZKfgmYWClvb5jvDdWw1R2hYfvnwV8H4oFPu3bVCHDp5DzQk
         wFE19R9ofOT0CG14/QIJ0ML2ljjTMiWNbra/BdwwoJvw5qe9OvLkvsWgRGd6XSlflgRJ
         7EmTa6hHj4xzYzGV3OMAp3oNUOsr4hhWW0HYIiBC5q7twzWPbuqCONBmK9bEWSLpS7TF
         YCcy626KZJ6aFAJlapg6BH94dkOu5MQPmX0iD4d0IXkFTj3SGwTwO+uea5WK9TPJeS7S
         pJUKWWHJLNrjzVUY5K4gJWKHpslHUHXSuZkl2ILdeyHfMTBwwylodrlwz32IP9ETclNC
         ccgg==
X-Forwarded-Encrypted: i=1; AJvYcCWGaTWzenGWCTMqmV3MmzTT5HT2MoJAPGLyjtM2KEAMXV+dEPnADc4ONNQesuVB68QJFA8PnaLasA==@kvack.org
X-Gm-Message-State: AOJu0Yz60M5Uac1jEpjinbTD9vDpqh7G3wHq02Ena0Uu5jGLdrn7zX2R
	t146X7ZdV2lwOFMVT5sD1gF35V+t4oIh7a7bsDh7kA5a/sFCdD8SLCcEQOVqtnk4bw==
X-Gm-Gg: ASbGnctKE7kLwfBhlD4Ve3f2jM16hcv/WsC+4uqMjGzc/WXPhUD3T8Gi0NxzQMpwXFz
	/n+8IRtOdYB6OaEoQR2Ba2/LHX9zWsw3N8C4sWWqPmg4pByN5uGooDBWXUHcuqM8ishhmWyrYQb
	0BiDrCCzb6+ZiZEy82S5EZtXdZ0pXKWj56H5rR/XB1PmOz2xrPoxIIah9+JXnebXR3alV8B5cuh
	VoEXOCDk/KE4rgbRLsv1trwsgkt9onbtMwyucUH1L8acBpA+Sr3/54a5ILKm6lbaXXF+lAZ3rj/
	qda6utLG3pOpgKTdUhn/IRVeR5K1N6ztj4qd7Hr7jBo6YLlm3TS/Uv8MDUBF9FV7D2fPpn94gft
	yM86ancuBU6tRSCAUSCGsnHWkZ9XWjaDdc0ZtPzHyAjb8NvjBGNUCiJQGlp2sCdptaA==
X-Google-Smtp-Source: AGHT+IGq4HV4wynITvP6Q3jQAvqNu8aZGXk3r1rzEnuZDeWdHk39Doexv2T5tkYjqpbpWqlrXy/lSA==
X-Received: by 2002:a17:902:e947:b0:234:b2bf:e67e with SMTP id d9443c01a7336-23fb0309a88mr3165975ad.13.1753460015047;
        Fri, 25 Jul 2025 09:13:35 -0700 (PDT)
Received: from google.com (106.81.125.34.bc.googleusercontent.com. [34.125.81.106])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23fbe4fc7a4sm619335ad.120.2025.07.25.09.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:13:34 -0700 (PDT)
Date: Fri, 25 Jul 2025 16:13:27 +0000
From: Sami Tolvanen <samitolvanen@google.com>
To: Deepak Gupta <debug@rivosinc.com>, Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
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
Message-ID: <20250725161327.GC1724026@google.com>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
X-Stat-Signature: xnwbzbzempzqhrd36hgj8xuqgc1i3der
X-Rspamd-Queue-Id: D2D3340010
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753460016-999588
X-HE-Meta: U2FsdGVkX18UScFoRBBlMO5a6+rd1pjw+uC3ATnjNpGvPOzzQVb1hQZw6upsGf9e8ZtlgClIfLzkjbhcUA0b4vBvW3XfEyJ7b7LyF5wtt2zsBCCbb+TrRMtIQbP+hR3cZoB3nGaMz75XFWfWbgQPk/ip/mQrPAaMj067IF4SjegXvOoCle6z/a83gdL2QHFM8uLD/gqVKbGpJN5Y9fqmNRptmScCPHCRsSuir7f+O3lJqmXRDFSLGKLXsEvTd+Gk3kHrkzNdC1AfpjRr+ZGfWZvya2kVnZrTj//KEVRRBOnuiAKc7pCtXNybzuZcrqSKcdX+QwnoVFLKjwcQZFQWHeEDZuzGhg/O/BnwY/NxI+c3N1ZywMf33WWnvIH7Yp1oEhAAlbrux5eh/bVLZDAJvf+oeucDteCNG5eNqUKdqrP9txN0K7iPJsYQ0r11jAJ8HKMZ/TlwBvS0ukUzt0hCwdcGdO7cW8kUV7DdbRPfCpp2QtW07vCvE87ZLoza4SwgjVWFQUysbBSUVkSfcFr8NcJN9mqbXDF599zGQa21U6p54X3aabMYKGM+e2/5GRi3y7unUuA9uEXYL9TGbvd0lCAD78UvmNiLROATeimE+7W83LCFHP5kiEpU7lZkm7NRjdd1gbw52AWKEKRMVyIdmApBRPSeRUkWMazELopUIbb9huFK20IQqyQ66YaxCcbEXuVTFZNSUKBN3eUrb+O2FEol9X3iOR7/9DWesSZ9Ss6lByO60QFOhqjt4cYtgyXa96JxGZ+h1hTeGGK5+WfzeZNOTCEdk46njOwNrl9FKOq73ZcLS82pDmMqu1kPuzdLch/Qr1x5mUpE+7erPVECd7xKxEL1QxZIqtw0o0x58adsogUG5JBwVUNNbhtt92WQNifZTJrE7fWx85viUW0tRlhUP0bXf+Kd0Mp7CxCsZJzzbm47cIdpj00R9NohCn7iIQ11KjLXwDimyEnCnIr
 IDBRBeW5
 iKkVck6n0gjguBylIUS6Kg/SjXjhIorqRBCEyUkMmHRUogDEJ15vmqP0Qcd3F5E/0m5A5BvWFKg5SX5MH8LXaFx2DBsush19rzbWW9mnO1IQCTH2+lV8DcOI0tMPHq7R7+AvbAMnPMnVUHafY1/c/pIA3GWqQXmSN6U52nAKHTWGMK9/pt23W+3pXePSzEwoU3ScgLX64qQM6PGseEaBD+14jBSQue8THoDInd8QTwOPA9uXiSqcmIoTC+a1hZ+bene/vcnFqscuu0Ro5qGw2RXvFuyswPtOrqPZTsBWimvqE/86DoCCPk1KHQosV8MG8sgq00YDkLX3NMBHoUBQsNXBAmuw1eSJKldEip8rU5Z3HKa6yI3AC7c3j0z4VEvVV2Mov9IFw2zMpWmo0oWFjjZ2QJhZaJY+6OwlIpeQBsFIWM9q6PbZWWP2sYQDQ4ouM1o92awWVHTiBWLmvuEIuXISq0gOhraNolFrYhdeVFls8Q/KPO2QuZZMF+hnW/yS9v5nkTfSr1SFfTyJ1nx97fVwsdnG7Qi/VrTgSYdY6PHRNKyB5+q8sNHuWmw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 04:37:03PM -0700, Deepak Gupta wrote:
> If shadow stack have memory protections from underlying cpu, use those
> protections. arches can define PAGE_KERNEL_SHADOWSTACK to vmalloc such shadow
> stack pages. Hw assisted shadow stack pages grow downwards like regular
> stack. Clang based software shadow call stack grows low to high address.

Is this the case for all the current hardware shadow stack
implementations? If not, we might want a separate config for the
shadow stack direction instead.

> Thus this patch addresses some of those needs due to opposite direction
> of shadow stack. Furthermore, hw shadow stack can't be memset because memset
> uses normal stores. Lastly to store magic word at base of shadow stack, arch
> specific shadow stack store has to be performed.
> 
> Signed-off-by: Deepak Gupta <debug@rivosinc.com>
> ---
>  include/linux/scs.h | 26 +++++++++++++++++++++++++-
>  kernel/scs.c        | 38 +++++++++++++++++++++++++++++++++++---
>  2 files changed, 60 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/scs.h b/include/linux/scs.h
> index 4ab5bdc898cf..6ceee07c2d1a 100644
> --- a/include/linux/scs.h
> +++ b/include/linux/scs.h
> @@ -12,6 +12,7 @@
>  #include <linux/poison.h>
>  #include <linux/sched.h>
>  #include <linux/sizes.h>
> +#include <asm/scs.h>
>  
>  #ifdef CONFIG_SHADOW_CALL_STACK
>  
> @@ -37,22 +38,45 @@ static inline void scs_task_reset(struct task_struct *tsk)
>  	 * Reset the shadow stack to the base address in case the task
>  	 * is reused.
>  	 */
> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> +	task_scs_sp(tsk) = task_scs(tsk) + SCS_SIZE;
> +#else
>  	task_scs_sp(tsk) = task_scs(tsk);
> +#endif
>  }
>
>  static inline unsigned long *__scs_magic(void *s)
>  {
> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> +	return (unsigned long *)(s);
> +#else
>  	return (unsigned long *)(s + SCS_SIZE) - 1;
> +#endif
>  }
>  
>  static inline bool task_scs_end_corrupted(struct task_struct *tsk)
>  {
>  	unsigned long *magic = __scs_magic(task_scs(tsk));
> -	unsigned long sz = task_scs_sp(tsk) - task_scs(tsk);
> +	unsigned long sz;
> +
> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> +	sz = (task_scs(tsk) + SCS_SIZE) - task_scs_sp(tsk);
> +#else
> +	sz = task_scs_sp(tsk) - task_scs(tsk);
> +#endif
>  
>  	return sz >= SCS_SIZE - 1 || READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
>  }
>  
> +static inline void __scs_store_magic(unsigned long *s, unsigned long magic_val)
> +{
> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> +	arch_scs_store(s, magic_val);
> +#else
> +	*__scs_magic(s) = magic_val;
> +#endif
> +}
> +

I'm not a huge fan of all the ifdefs. We could clean this up by
allowing architectures to simply override some these functions, or at
least use if (IS_ENABLED(CONFIG...)) instead. Will, any thoughts about
this?

>  DECLARE_STATIC_KEY_FALSE(dynamic_scs_enabled);
>  
>  static inline bool scs_is_dynamic(void)
> diff --git a/kernel/scs.c b/kernel/scs.c
> index d7809affe740..5910c0a8eabd 100644
> --- a/kernel/scs.c
> +++ b/kernel/scs.c
> @@ -11,6 +11,7 @@
>  #include <linux/scs.h>
>  #include <linux/vmalloc.h>
>  #include <linux/vmstat.h>
> +#include <asm-generic/set_memory.h>
>  
>  #ifdef CONFIG_DYNAMIC_SCS
>  DEFINE_STATIC_KEY_FALSE(dynamic_scs_enabled);
> @@ -32,19 +33,31 @@ static void *__scs_alloc(int node)
>  {
>  	int i;
>  	void *s;
> +	pgprot_t prot = PAGE_KERNEL;
> +
> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> +	prot = PAGE_KERNEL_SHADOWSTACK;
> +#endif

I would rather define the shadow stack protection flags in the header
file and allow them to be overridden in asm/scs.h.

>  	for (i = 0; i < NR_CACHED_SCS; i++) {
>  		s = this_cpu_xchg(scs_cache[i], NULL);
>  		if (s) {
>  			s = kasan_unpoison_vmalloc(s, SCS_SIZE,
>  						   KASAN_VMALLOC_PROT_NORMAL);
> +/*
> + * If software shadow stack, its safe to memset. Else memset is not
> + * possible on hw protected shadow stack. memset constitutes stores and
> + * stores to shadow stack memory are disallowed and will fault.
> + */
> +#ifndef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
>  			memset(s, 0, SCS_SIZE);
> +#endif

This could also be moved to a static inline function that
architectures can override if they have hardware shadow stacks that
cannot be cleared at this point.

>  			goto out;
>  		}
>  	}
>  
>  	s = __vmalloc_node_range(SCS_SIZE, 1, VMALLOC_START, VMALLOC_END,
> -				    GFP_SCS, PAGE_KERNEL, 0, node,
> +				    GFP_SCS, prot, 0, node,
>  				    __builtin_return_address(0));
>  
>  out:
> @@ -59,7 +72,7 @@ void *scs_alloc(int node)
>  	if (!s)
>  		return NULL;
>  
> -	*__scs_magic(s) = SCS_END_MAGIC;
> +	__scs_store_magic(__scs_magic(s), SCS_END_MAGIC);
>  
>  	/*
>  	 * Poison the allocation to catch unintentional accesses to
> @@ -87,6 +100,16 @@ void scs_free(void *s)
>  			return;
>  
>  	kasan_unpoison_vmalloc(s, SCS_SIZE, KASAN_VMALLOC_PROT_NORMAL);
> +	/*
> +	 * Hardware protected shadow stack is not writeable by regular stores
> +	 * Thus adding this back to free list will raise faults by vmalloc
> +	 * It needs to be writeable again. It's good sanity as well because
> +	 * then it can't be inadvertently accesses and if done, it will fault.
> +	 */
> +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> +	set_memory_rw((unsigned long)s, (SCS_SIZE/PAGE_SIZE));
> +#endif

Another candidate for an arch-specific function to reduce the number
of ifdefs in the generic code.

Sami

