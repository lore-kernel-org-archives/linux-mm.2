Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E372CD3439
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 17:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798436B0088; Wed,  6 May 2026 13:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721886B008A; Wed,  6 May 2026 13:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9A16B008C; Wed,  6 May 2026 13:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49D156B0088
	for <linux-mm@kvack.org>; Wed,  6 May 2026 13:50:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E87BFA02B4
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:50:57 +0000 (UTC)
X-FDA: 84737735754.04.D540944
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 750451C0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 17:50:55 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WKubyeQR;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778089855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eggJN5NeK5KdcWJHIvN10Zh1zzswDtzrYj+onxzIjDc=;
	b=V4TIbi6PSZnXqIwWQqLQ7Dv+foOJtMt/VFx8Zer0jCIE9UIC6XdHLHLd9uLdmqEdM/5LZh
	x94t6GdpGdg0R4t5QbMNPdurw6MW2sN77MuqUDEIdxxx4eO5LJmLkT7FkqQzRMa8hLj5hH
	vTGZKyT5Ap5yvQY+TMflU911hmwQLZ0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WKubyeQR;
	spf=pass (imf21.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778089855; a=rsa-sha256;
	cv=none;
	b=xSy0nfJDt/2EgQacaRfQHN7/8eFH58svISNH+ivS4LDkgxTJ5jilMOmKFnoqeI/CVThdnA
	i00YNqXhhoB7+nOo0A/q3kfh9p+UpvC/KdvPVtqB1LHkq1sl3Zxe0trjWL1xfECKOOKkjK
	4LvtrZyrs+Sqqb16AYW3mcZeUw1nu/g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778089854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eggJN5NeK5KdcWJHIvN10Zh1zzswDtzrYj+onxzIjDc=;
	b=WKubyeQR3wU9bssQfLJ3coQQQpvT/5I6V6ZwqRU5kCDLg708siA8+9SJ9hInc78cSV/4mO
	FGqHtxRH1S5ZRY/bIaXTJls6d3KNMYA/PxVuESxVNtt4qjIEj2UuTFcbsnoXHv9ANrYXjs
	gchfHDMGfUjd8avPiafO3zN9XHS8QwA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-292-rqHuu6i2NaK1TdPbw0bAGw-1; Wed, 06 May 2026 13:50:53 -0400
X-MC-Unique: rqHuu6i2NaK1TdPbw0bAGw-1
X-Mimecast-MFC-AGG-ID: rqHuu6i2NaK1TdPbw0bAGw_1778089853
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8eb04352972so1311739685a.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 10:50:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778089852; x=1778694652;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eggJN5NeK5KdcWJHIvN10Zh1zzswDtzrYj+onxzIjDc=;
        b=E8bqV0zj7k6LYI+CZOOn8dN9Dk9WcUiA56NocSk05GT2QJcendjHJdyjvzhD/HeSEP
         dXljHUTCvGHd6CU0D9qEpZUAXDLjk4iroPjA5Qbd7Av8rhfuheIeZkbZffXgF+OcYCW+
         +gDfJoTVY7o71Vo1POCWMJS1n3TvaTbEsQfkJH6TDgUvgRvF0ntsQdkSNw/VwmCw2XCr
         iG+y+TkaF6tjwptfh7t+IOSJkrNLZ2ejdme2YyCib/izw+KqtRN8Z8jTWnq2yAg0lHxY
         SZcVzmC4vU710avigWsAqEtRgkyRoz08k5htFpk1dhDFu7kl0zjv8051UVP88JmOjFsf
         s/gw==
X-Forwarded-Encrypted: i=1; AFNElJ+RIaJPd7XvBgBySTapLnPw299cDB26ISYEtGFMNtsiGTmv4B/G+6WLMssQjibkYMgQYNkc98BZ8g==@kvack.org
X-Gm-Message-State: AOJu0YwC1cw7pdOWrYsOjR9J4BQE9kY5wkbYD3xiOZdLujTylxoMBeZH
	zxKiAsGWhnyXinqIxaPR2W7W9ZmYyWDB/WwsSHaceADy6yGWqebaEXQeoAxbCjcHTaZEVe36Lqo
	g7BMf3G8YbfEIt5cmSV8QTJGLNGVm3UbrV4/ro9ibk5LqGt3jSEsQ
X-Gm-Gg: AeBDievD56TrYWmYLPJfFElHGL5eYduoREZFIQvWxpEdXPxAlpLwofXUUrRyr+qGLy6
	nFe3buDOaCw2cEYgx4czZharP+k4NSY2I+RJ+GVrZAXKdEYQkWuwHnf0SCWoI1Te/0qJWdXHZi7
	1HresXLq2NnOwOrgtg21kFwI6fmRXFpeEr7xgT5llqcwblpb/tHxhKDLcRW2o04va8mdtmOD0iZ
	Hi+pxkSyvD9lfx7v8DA/yRhDt37KwA3YloNU8S5JHB966l2VrB9Ja//wkNgKTUtRrEyI0kQRJv0
	tZ4R8kex/MrCens1iefvPiB3Fxrl0FRhOpfgInpaphWk39uAeHGOz9x6q/UVRRr+bNouVrpCvox
	r0IwyP4t8R4jy+s+486XPOC2UhwDMlm8POLE=
X-Received: by 2002:a05:620a:a2d3:10b0:904:f2cf:f1ff with SMTP id af79cd13be357-904f2cff262mr446155585a.62.1778089851635;
        Wed, 06 May 2026 10:50:51 -0700 (PDT)
X-Received: by 2002:a05:620a:a2d3:10b0:904:f2cf:f1ff with SMTP id af79cd13be357-904f2cff262mr446150385a.62.1778089851032;
        Wed, 06 May 2026 10:50:51 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91cd7dsm1688336485a.37.2026.05.06.10.50.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 10:50:50 -0700 (PDT)
Message-ID: <4cb079c7-c6ed-435d-849f-5828dcdbfda0@redhat.com>
Date: Wed, 6 May 2026 13:50:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: (sashiko review) Re: [PATCH v4 2/9] mm: introduce
 pgtable_has_pmd_leaves()
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
In-Reply-To: <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jh0_4AsVpz3LhrnpMCVDMvIGTa30OyI9eS1lw-ueScA_1778089853
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 750451C0005
X-Rspamd-Server: rspam06
X-Stat-Signature: uwbpjqssiktdzrqfzajgpgxms3qezddx
X-HE-Tag: 1778089855-326089
X-HE-Meta: U2FsdGVkX19r/wgQX9X5BzUYne+L5Fc0JLVE5btgQurnU6W4SwmPRxkUeKWFHPYMc0ZNTJFfIHWAjicHBNylGDY5XH13R07VF1ctSk3BSBWQV/Gg0ga3VTy9420QxufmO8q5asT566Ss4q7aprmciOW52Uvd8sq0W7b2qsofEA0JACVtK+4BMNHkMlnAe3kj9Huh1pJKAKyLFkfqqVwqde8mJTg+2UDFuykdFjMFu3SgY0ie2t1cBjXBC89YKX2s644nRXI+l+//kEdoRLafSGxyDR3eIBFQRBp07mBmtK9ToSECDcFpdrmd1HyXNVtLehz1aubwBKdRjR0r1vl7YRUIHStQPySkAhzaEFrGDxz6ps3g9XvWvaa7KpR1USb7Q2p7CYAmymjf9z6T5Fr7/8xNZM26/KZkdQsFChLesnlQc64vvt9rw26k6AeSnrOGcRZU5nSJ5NzBw6vIC1Nl+3O37oV+dfg+PPeA5cQvOQLW+XYnWOy9lC2dpXR9P51IbKKQs4QGYJZFa65u3Z5cXZMcpw9hy8huLALway97mcmb1bs3q//+HgyL6odoFmzqb626qBSt1QYOChkxxvhD5gP6p+jKYzt0CjgsFHhBNFAULOKe3oCH3+COetSV9dBOrb8BglQicRZKdwT64TNnky2pZ7XXyUew0yZzsyydscP0W2H/BqdFHXVXZGDLuyGarMJGy9DZm1LCgTdJxisd9hf3X9Rowi4dOP/U3mNpl173D7YEuNMr1arLF3nPejMg2xNr9X157R4EUbyx7339u88K3+IdhzNvACstw+ckWfgjGz31nnGRwJenjGttSzJ0CVkat3Zry0rFXKiLq/0myxD7TjCFZsMW0d+KGRSxEb9GO5YZNmjLsHnXgFH7BDti8uRAU+LN8nedJlg0nOt0hJbisAO+267IYuYXBxs5/Y/m1955Pyz/XMh7w1fGR0eE8bOd9EYmb+7fTErQFfT
 292h2spD
 rhoKE/JTL0Odq3htjkvXG036MyZMzdg+2cOP0aWzumujRNFeFlxmcPCwmkXhxNXdZAw5NZ6Hd4s2kvSj2sAX9+2WFwpzbGm3lvDJ1uKd+4GSQUK3j1vRQIYssLOpAmq6lQVbxvXJSiAhFad1G1VN9r0qcVfl2ZRILXs0BVzmmWs1Lt7CXYJRCDgUs1sP/ha1nb0SYosWZrnwNuMvx1qAiE42YqcS6GQiqTwLRl3bywubK7FuKPN/716tgGKPvE/Lrd3Ka7yPmK49iAEZ51HZLdmrB/aCJ3fr0mQBUbmiZ+n611rrIwuUGPfzVQXb5rU3yg4mTt5jUh2jXt+FGpNwLCzCJ+LdFOEmnScDG6LSKjX0rs7hPA2QMtEcKe4yiQTQBYyYg2ab7rn5flAXxRdwxQlzAD0d0KFaAIHfFjkXKK3osO9h23fI0t3AL39CqlXUdiIBiYm/JfbLAXvGEDPC3ed5O1PpaDVylopE6BuNYkH51nZ3C4udu9WvyPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-01 15:18, Luiz Capitulino wrote:
> Currently, we have two helpers that check for PMD-sized pages but have
> different names and slightly different semantics:
> 
> - has_transparent_hugepage(): the name suggests it checks if THP is
>    enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>    implements this helper, it actually checks if the CPU supports
>    PMD-sized pages
> 
> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>    by the hardware, but it just returns a cached value acquired with
>    has_transparent_hugepage(). This helper is used in fast paths
> 
> This commit introduces a new helper called pgtable_has_pmd_leaves()
> which is intended to replace both has_transparent_hugepage() and
> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
> it returns true if the CPU supports PMD-sized pages and false otherwise.
> It always returns a cached value, so it can be used in fast paths.
> 
> The new helper requires an initialization step which is performed by
> init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
> during boot in start_kernel() right after parse_early_param() but before
> parse_args(). This allows early_param() handlers to change CPU flags if
> needed (eg. parse_memopt() in x86-32) while also allowing users to use
> the API from __setup() handlers.
> 
> The next commits will convert users of both has_transparent_hugepage()
> and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   include/linux/pgtable.h | 15 +++++++++++++++
>   init/main.c             |  1 +
>   mm/memory.c             |  9 +++++++++
>   3 files changed, 25 insertions(+)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index cdd68ed3ae1a..b365be3516bf 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2243,6 +2243,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
>   	}
>   }
>   
> +#ifdef CONFIG_MMU
> +DECLARE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);

"""
This adds DECLARE_STATIC_KEY_TRUE and static_branch_likely but doesn't
explicitly include linux/jump_label.h. Can this cause build breakages in
compilation units that include linux/pgtable.h but do not have
linux/jump_label.h in their dependency chain?
"""

I've built this series for a few archs and I'm sure the kernel bot built
it too, so I'd assume this is not an issue. But since adding the header
doesn't hurt, I can do it.

> +static inline bool pgtable_has_pmd_leaves(void)
> +{
> +	return static_branch_likely(&__arch_has_pmd_leaves_key);
> +}
> +void __init init_arch_has_pmd_leaves(void);
> +#else
> +static inline bool pgtable_has_pmd_leaves(void)
> +{
> +	return false;
> +}
> +static inline void __init init_arch_has_pmd_leaves(void) { }
> +#endif
> +
>   #endif /* !__ASSEMBLY__ */
>   
>   #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
> diff --git a/init/main.c b/init/main.c
> index 96f93bb06c49..eea7c5bdddf7 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1053,6 +1053,7 @@ void start_kernel(void)
>   	print_kernel_cmdline(saved_command_line);
>   	/* parameters may set static keys */
>   	parse_early_param();
> +	init_arch_has_pmd_leaves();
>   	after_dashes = parse_args("Booting kernel",
>   				  static_command_line, __start___param,
>   				  __stop___param - __start___param,
> diff --git a/mm/memory.c b/mm/memory.c
> index ea6568571131..90b2d9e84320 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -164,6 +164,15 @@ __setup("norandmaps", disable_randmaps);
>   
>   unsigned long highest_memmap_pfn __read_mostly;
>   
> +DEFINE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
> +EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
> +
> +void __init init_arch_has_pmd_leaves(void)
> +{
> +	if (!has_transparent_hugepage())
> +		static_branch_disable(&__arch_has_pmd_leaves_key);
> +}
> +

"""
Will this unconditionally disable the static key when
CONFIG_TRANSPARENT_HUGEPAGE is not enabled, since has_transparent_hugepage()
evaluates to 0 in that configuration?
This seems to contradict the commit message's goal of decoupling the hardware
capability check from THP enablement.
I see this is fixed later in the patch series in commit 4782375d13da
("treewide: introduce arch_has_pmd_leaves()"), but could this cause
regressions for non-THP PMD users if they test at this point in the series?
"""

There's no users of the new API in this patch and all converted users in
the following patches are protected by #ifdef
CONFIG_TRANSPARENT_HUGEPAGE so it's not an issue.

>   void mm_trace_rss_stat(struct mm_struct *mm, int member)
>   {
>   	trace_rss_stat(mm, member);


