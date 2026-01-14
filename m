Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5511AD29FED
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F4CE6B0005; Wed, 14 Jan 2026 06:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CB3E6B0088; Wed, 14 Jan 2026 06:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D40D6B0089; Wed, 14 Jan 2026 06:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD476B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:08:08 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 17CF8C1C39
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:08:08 +0000 (UTC)
X-FDA: 84330295056.11.F500CE2
Received: from mail-wr1-f68.google.com (mail-wr1-f68.google.com [209.85.221.68])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D8851A0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:08:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RcSG6S0o;
	spf=pass (imf19.hostedemail.com: domain of pmladek@suse.com designates 209.85.221.68 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768388886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsZRaUIv311mQjR1/d/UwzmBCVEkDM2qHnJQZ9QsbMg=;
	b=Zkjsj4Hybv4v1eagU2Rgro5FdoGSH+nP0SYCkyeT4yFGTiuAKt3JVxIajZXsKE9rec4dHG
	rm8R22O79Z08Io8M1qhn21VNSWiXbf7fBAljUcmzwE4Ch3wjEtWqg31ZUvUkcJk9H5RP+B
	8gCF6CaJyfKVCDv2BoCcXtq4r0M0Sn8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=RcSG6S0o;
	spf=pass (imf19.hostedemail.com: domain of pmladek@suse.com designates 209.85.221.68 as permitted sender) smtp.mailfrom=pmladek@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768388886; a=rsa-sha256;
	cv=none;
	b=WLerHT7hk/QvHxCkvv5DHxNzShQSPN1NzUVhpxHrMQqykheOmP8AzIdlEVOKRy5dr0t4L+
	D4I5j4cLatYE6uhlh/pFw9MG0dtyVtiLcUzplx8Hw3T3K4UUEpE9X1vhw3PRG/71zSWGNS
	Pfeck160FJQkol4JcU6gg+hkISTGuFM=
Received: by mail-wr1-f68.google.com with SMTP id ffacd0b85a97d-432d256c2a9so4754697f8f.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:08:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768388884; x=1768993684; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zsZRaUIv311mQjR1/d/UwzmBCVEkDM2qHnJQZ9QsbMg=;
        b=RcSG6S0owALjwPPCvXzeTejCyuVP4Mvk4RAJbXoXCwSaY9aViH1Jk4QC3ruy3krmz4
         1/2Qs5KgtYtckfTL1veY+xZeSBZbEwNKZTptqXPZbjz/JaXp/WtqPAN8YAgG6/u9nwq4
         DlD/eAvTcib7WposdUux05rvn/p9y9lCw82CPoJI+xf8+bIw1QEWN9eYWCqzw0CpuE2z
         cm8w08qb+f4opLGK4TmnTZuZnFECrJ4p1ZmiSLzUmBzCub5IP06GqGqtJFv8qeZJykYX
         wqL7JllWWwDtjTsgxA8U7t6yf0/hsTMEzdhtvuvx7yqHI0nFioqWGg9N7md8z+/SdYRT
         RdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768388884; x=1768993684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zsZRaUIv311mQjR1/d/UwzmBCVEkDM2qHnJQZ9QsbMg=;
        b=R+9qMKyO8WQIENXsNnJAYEPH1eVmxxKP8w1me5wNyiEX8OIGQiE5n8QuesWqH0aL6b
         mA/v/aV1zs/PNp9c7pFehe7UxpzWG4mEGVc7jADRZsvrzyNP2GcNbxky8cK4B9kkiYqq
         4eHuPJJrvN0I8RhHBL09jyFyXD6WFi18BnxgmjQ3qWxGWpxih6Y2Z33SVCnNedaaan+d
         3vjPqtAkCXaNJC8Iul3tk3IQEcNJ3Z4lS90+HwuHtuPIAt3cbXqgZJHgVucZ4M7Bom06
         L3UNrpa5nIzr1bK6gA2NYfEMYpC+NJ3vdTL0AnM97GwBodgDOMB70gVI/scM7tNKdYfW
         BWQw==
X-Forwarded-Encrypted: i=1; AJvYcCWE6cgrOKoS9uFEFjrbGvkudEuOwvh1o2p7Pro/F5uxJQyMzh5XhkC2l6jEjBP67svsqilGfaGXLw==@kvack.org
X-Gm-Message-State: AOJu0Yzo+l8sIf9wBrUmK9sRxTs4XOxQvGsC3PrJRcwIhuNjd549K/mL
	kTrSUgttfGul655HXwZtYCvMJ8eQQosEeBdLcD56ilQGmGtpRLO9qlc7DRdZRX+RRjA=
X-Gm-Gg: AY/fxX4pIJiU6fMfsubcpBOTsJS7sxdy0grMWOD8G0sNlYKDs7dyGzaj4QSwLNDs+TH
	EkVcTba3/vBqQpcz7OQpjD/N52Dkoby1xMjMU74ggPo6ejnMHRK0n2JFUMKflCA9PjmTdHEfkAx
	/j+xO6/8tVPMi6uenCj7QIutV8S3JrmJHsMt8qG/q6HXFIWvZFpT8HQ7hxQyDHgAwTCBr5Z/XA3
	8nCdDa2XELd2qzZytWD1CEU2egP0+jKTbIXrzHFPmst2lNNsAH+gtwOQQxOdGBynjQY4D4g+ATK
	hiyV5OCwRmeYxmg66jSviaI0K39oXysH0vazjBCHGEnbCUdi+3+Bo9xe/w9JpCtyS//VQFx/hm4
	7z5YMTkeWeVmB7rPHGK6G/i2ChvmI9fp+RyCwmIXLZHu3kCaPoXhBZa6E+p4WL6kAuqJgldeSek
	e2Nnn/AlOE4uSzJg==
X-Received: by 2002:a05:6000:402b:b0:430:f41f:bd5a with SMTP id ffacd0b85a97d-4342c5727bamr2462178f8f.57.1768388884316;
        Wed, 14 Jan 2026 03:08:04 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432d286cdecsm35938006f8f.7.2026.01.14.03.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 03:08:04 -0800 (PST)
Date: Wed, 14 Jan 2026 12:08:02 +0100
From: Petr Mladek <pmladek@suse.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
	oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-nonmm-unstable 77/129]
 arch/loongarch/net/bpf_jit.c:1322:7: error: call to undeclared function
 '__bpf_address_lookup'; ISO C99 and later do not support implicit function
 declarations
Message-ID: <aWd5EoT9dGUwEbE4@pathway.suse.cz>
References: <202601140159.I4b0kwpE-lkp@intel.com>
 <20260113094801.d3c7b9d327959c6bcb8f4db6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113094801.d3c7b9d327959c6bcb8f4db6@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D8851A0004
X-Stat-Signature: c3f1fxd9yoh39fxjqzgxf5nayjszrhcf
X-HE-Tag: 1768388885-248645
X-HE-Meta: U2FsdGVkX1+bmQ6mLLBjg9xfQdHPHjRN4XwbLJvqGEqFtJQ0jgVZqrzpOHrgn/b6ZV0P4jMsplN/Wy6nfS5nCBLqJqeaS/puJU24yNcSvihiAAivMUOcvCsjcpklS33Jj8Vv1lszXE3wWmLVkftXnwj7gZrZmX5j9n1vGyjQsXHif+MkW5oG7vk5Pn6vfq4ECPyiO1mmKkAfzIPTwCuOgkgxH7Uxd4sjVzybMtnCiOVLPo/oxugfVklISirlMYczn21RUVP82rvKDNLdUhWmvtYU1jOLKn9gbgFNQ/iJcGgZ92jwMJnJQil7qOHiD+SfVhyvJj7lZ5v8p6L5/Zz7hqth9c4unOYOd3Vi6YRVKvzvG7p2aDKS2IGmZpcGtpuTVW9kfGdV6HoLvEzPBu1xwY1pkB+U0qc3uVyF4pUKHD4T/QlLcfmDuu34DzGNMJTYjfzgk7qKCYrbPu5WcGjx5WCoqaAbZp0kvtsAgyKNMtW7hFH/DS9o9PZMHyvcfHledkixa6JY7rx6INJK88ztflj85gwyXFUua1rAOiAp9TLWMpQyWgdow35MxgDyq5vPrk34oWW8ekRVgwGPMdOil4HQJn0S1KTcqEYIeJs3AyYz+1rQyADe47ZBM0UuQ/Vb9Y/A08FS9Ioymmsempa6Q4iKCQFy8Io5PdqzavRqE1spWwwx/yIPTKvD75AmDcG30qnnM4FHyxF47Duhqew5I8uQJYqjk+fX/T0FMIfYDZa+0nY3acQj9Suaw68Vv3qCjkbjzMViTVVuWDW1IQbJ+ij+a9EGjVMWjDoKbbKifyNeRyMC+7gnxegy9gzQmsB7r7+gWkOQtkqI45T3TgGm/hFQie7ulXKQFamKxxOpFshbaRjwHz6B1O02cmh7aXuGzdWX1ANX/KfSQ46QfnvANeOsDbgkjZXDsqv9plWjqQ8zSeWy2UWBTf0bJAmP2f980KSc6W3FYHedoqfU/fO
 ID33Op1P
 wvzwEPhaeuoDzwKRGUcWYTNcD2BvfBcseqxuA31ONyMxZno88yI92e+eCcQcnNajyAphDBKSjgfeoeWz/eJFZJvxbM6ZLd6jpBUxqAIuZkzaeqzhUxMiTzdQLMt/h8Q20cZAsgjGt55E5udMyKqINoGDOIQBlK2oA0Ok6fbE+rJrq0VIXNEW84C4FHv6m/51FuLJydsCMJWcYQX9Lb/1D+Rl9LLKKZKcCFiklpPws5TmiHs+xKFQxhef2v7VCIDKsslGUfyttAaX/4pww0+oh3kfPeJzFS0jVQoXji/g20UeaWIrHy6MlALYHpbRzIe62J5lt1dssdr9AQ+F3nvsf8LMPTiPtEj1hkasfDTu9ooWHwwZCKkhD+aYYBSSP/hSK4eZtWlYjeqz7p/6Y5HoJht9xt1RccBvQj9VwlucDvIAoQf+bzkRO9yAm1nvbj0gCCTQef6IPVCYIe2HOBz9aDdbo5vQ5bqvw7Xj508welx9u3hfJTgBNbAU3UEQFlputIFKsr3AfEww1vZIORoexiA+ogz42tnbNh8punsATf/E2aGs9PJd1VbkEBdu+DxxVnb+Z/G8kEEtixt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 2026-01-13 09:48:01, Andrew Morton wrote:
> On Wed, 14 Jan 2026 01:37:38 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
> > head:   01c8de771f4a779caac5d841b1cb2207ac23330a
> > commit: 0f1766dc93f077061bf42cc6222bb2ade96422a4 [77/129] kallsyms/bpf: rename __bpf_address_lookup() to bpf_address_lookup()
> > config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20260114/202601140159.I4b0kwpE-lkp@intel.com/config)
> > compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140159.I4b0kwpE-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202601140159.I4b0kwpE-lkp@intel.com/
> > 
> > All errors (new ones prefixed by >>):
> > 
> > >> arch/loongarch/net/bpf_jit.c:1322:7: error: call to undeclared function '__bpf_address_lookup'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
> >     1322 |         if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
> >          |              ^
> >    arch/loongarch/net/bpf_jit.c:1322:7: note: did you mean 'bpf_address_lookup'?
> >    include/linux/filter.h:1378:5: note: 'bpf_address_lookup' declared here
> >     1378 | int bpf_address_lookup(unsigned long addr, unsigned long *size,
> >          |     ^
> >    1 error generated.
> 
> Thanks.  Presumably this:
> 
> --- a/arch/loongarch/net/bpf_jit.c~kallsyms-bpf-rename-__bpf_address_lookup-to-bpf_address_lookup-fix
> +++ a/arch/loongarch/net/bpf_jit.c
> @@ -1319,7 +1319,7 @@ int bpf_arch_text_poke(void *ip, enum bp
>  	/* Only poking bpf text is supported. Since kernel function entry
>  	 * is set up by ftrace, we rely on ftrace to poke kernel functions.
>  	 */
> -	if (!__bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
> +	if (!bpf_address_lookup((unsigned long)ip, &size, &offset, namebuf))
>  		return -ENOTSUPP;
>  
>  	image = ip - offset;
> _

Yes, this is correct.

JFYI, the "problematic" code has been added into arch/loongarch/net/bpf_jit.c
just a two weeks ago by the commit 73721d8676771c6c ("LoongArch: BPF: Enhance
the bpf_arch_text_poke() function").

The good thing is that it is already in the mainline. It has been
added in 6.19-rc4, see
https://lore.kernel.org/all/CAHk-=wjO7Jq1dR7rdDA2wY=jwg4TTq-C6PjJz0=N=1dSO=3NTg@mail.gmail.com/

I see that you have already pushed a fix into -mm tree.
Thanks a lot for fixing it.

Best Regards,
Petr

