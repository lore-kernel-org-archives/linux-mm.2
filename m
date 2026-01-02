Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BF9FA3729
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 15:10:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 764CB6B0088; Fri,  2 Jan 2026 10:10:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E81F6B0089; Fri,  2 Jan 2026 10:10:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F9EE6B008A; Fri,  2 Jan 2026 10:10:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCFC6B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 10:10:05 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C65FF13B082
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:10:04 +0000 (UTC)
X-FDA: 84287359128.01.7DD17CF
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id B6C4180010
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 15:10:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MyfeVhTo;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767366602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1eJCz3IMCVzaPFR9n+LpYQ3cFp/Gh9wDP5j0bwatno=;
	b=6BiT/tsOQW1zdAhQajoIKRmtG8UoF/V5CzcNsfW2YK3gDK2ycnc7NtJANNcQ4HQz73oimG
	Dtu3bQvlPj+icOiM81AluqZU33ri2eqFIb+xl7akIb2VvR2Rmp3ysQDds3mhdA/qnrv7DE
	ru5SU4LFZIatYALammFIaZH3SFMOibc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MyfeVhTo;
	spf=pass (imf30.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767366602; a=rsa-sha256;
	cv=none;
	b=VLgDyUTqv/FuVrZm2BGsIQFYoDir3Mvj+VwpUCgnHyvQDX5RPMFSJc7HdFkQYM+5pqzfAF
	6K1ZNJoa2MIvQ+USQC03FqVwGNp9rytb0bI52wJHdzQL7Tut+HywXNH0qFxe9wfynjVWBx
	TEmc8vFuq8nI0LsaB1jJ2wwbnlGWfU4=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4775895d69cso51545425e9.0
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 07:10:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767366601; x=1767971401; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y1eJCz3IMCVzaPFR9n+LpYQ3cFp/Gh9wDP5j0bwatno=;
        b=MyfeVhTo78KQ+VoQ2uWMle5Bak/Rs4IQZHj2PF5yTgyTGPqMgXIW3iwERkL3zSaJB+
         DiK2uvfqj5UcrskoUWykWXk8G6dEGedJFevyWkuqtjyCQVFbseXIcZa6JLdRlXTLMmg2
         vYskNDBsrhdIS+bNH2dl9oByf+xs+vpCO6zUuYx+9VaEfHmRcLx5MhVxqJrJOdMhLB+P
         9w6AXcsHG+yg3r5HehN/pPXZeGdNW4wiOj/JFGJMm2Uliu78quenv5xZdeJMdQvAOuwe
         M1W5nSW+wW2i7LZbYmFxpfVSy8PhegguG9qOo/igq39RKle7A5dMNSKAi1DHIPhk9TeS
         Ba7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767366601; x=1767971401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y1eJCz3IMCVzaPFR9n+LpYQ3cFp/Gh9wDP5j0bwatno=;
        b=GBfk99Me3V6oQJMgeTz3sRs9tjVZLqnk6sCx1eiBw1Hme9sXglDWEB74Ub713Oz20s
         +/h5v4AogkIIMY/DFkBl0032ZnZXevOVY3zKVjfJ3cXjmrIDnrrSfuUGMB50gsdWbwY5
         iarhmp7uNtLUp2V7yPLXZjStpd1w9saNnPtOa+xYrg6AK3fHygQ4G8RwL8BPlxLMOBNu
         8yVVbdB4VIs2+GMmzeopKWkSZSHiDP1GrEIQ89E+Z3IMxuCrm62OaSeUnf2y0r+MeCKa
         TZ7goioSQtyPFdf6t3+Zo3LReOAFeLgVTssdQ9MhGhvPd5QqplRR9olvosrNjlRBZG8L
         j4Xg==
X-Forwarded-Encrypted: i=1; AJvYcCVgDB+TQKZ050m3p/GO4ql6EbRk/Is2KqLrazklvvIQl2OyksjQbJYHBT6a8YSwthrNW2UgoLFyeQ==@kvack.org
X-Gm-Message-State: AOJu0Ywf1Rtun0bUxaS/blH0IswVDWdG4OjX9J9p8o+Ag8xdyfMWPbND
	6J3lzHkuPrS0HJrJfRi6HDuRpujjhxeu9LQuCgAZ1yGu+ZhpEGCSBB2j
X-Gm-Gg: AY/fxX58BlMj7ODOJx0wwWlYfKC8a4UamYJUTQbb7rAYbWKJ/w38Mj29J7LHGegHmsd
	DqIeN65zUX0xy3EFAKpOHlQWva5LjiVH+oqpVDUErvcOtQr0WeTpNthccfNpLtwLjb8jjoOvCu4
	A3F6VdgXsVmLpKMoPcSpDJpIWDBUXh+ssxVVGyjJ/9bnBr9pQzoooNKC6dYizOf+1SUXuipQ5TV
	9CyUNaSlJwt6z0g/ZS6AScHXUZX0cKQ1ojBNEoYCk3vy/D2G0VCy9p0xsrR8DSurdO2NcF4W7Js
	K5RHc19TNNNzFRKWiuWBnvYYWxc544yplxenAI8zkbwt7zkjy6zNWYzTc4/7NpEu7Cyrzs8km+W
	/FhuQvy5OGANOchsqlPpgSlFHX7V0YlyqZS2soi8B4/T7sd38clGtSVDLp24f4YGPa2jhX+BAkU
	FrKRpv3i1DGsYPcGOhksB+XXIv+FTH1ZUKD8UmnmW/zTZNr0nO+WvXjYFng6d+lNX4AxvUuL7oY
	Cg6HURo0bV0
X-Google-Smtp-Source: AGHT+IH3RpKWczLY+gkhjq2AtrhL06nZ1EdBricEWM1SCBl/FAK+3Z835dNOj1erlKquHw/1w2TN/Q==
X-Received: by 2002:a05:600c:4f4f:b0:46f:d682:3c3d with SMTP id 5b1f17b1804b1-47d1955187fmr636047545e9.13.1767366600834;
        Fri, 02 Jan 2026 07:10:00 -0800 (PST)
Received: from ?IPV6:2001:16a2:c8d2:2b00:183a:1350:d3a4:d89? ([2001:16a2:c8d2:2b00:183a:1350:d3a4:d89])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324ea226d1sm87195021f8f.13.2026.01.02.07.09.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 07:10:00 -0800 (PST)
Message-ID: <fc542a5e-db54-4d7e-b363-42cc253b1a8c@gmail.com>
Date: Fri, 2 Jan 2026 18:09:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] kexec: history: track kexec boot counter
Content-Language: en-GB
To: Breno Leitao <leitao@debian.org>, Alexander Graf <graf@amazon.com>,
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-mm@kvack.org, rmikey@meta.com, clm@fb.com, riel@surriel.com,
 kernel-team@meta.com
References: <20260102-kho-v2-0-1747b1a3a1d6@debian.org>
 <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20260102-kho-v2-2-1747b1a3a1d6@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B6C4180010
X-Stat-Signature: ut8gpmd3npindi3h9rmu3ht1rnza3u71
X-HE-Tag: 1767366602-220518
X-HE-Meta: U2FsdGVkX196azHa58N8yM3KcLbWANyzEHAdJrWty1nE95I3TWsf1r5pduAjnc00WsqRkljM+Mp0LNwoB7vigDY/b7cbGr8ZeJush5UcIHACr8SkwSvtU6z7LB8qtJQCIiwamUhIsI61skVC4ZJ7Eskq3LmyO4jyIF8aqmNOYK1+wDl9FnjXHWRlIa1ue0Uk61cDuWrD0ZxfiF1Cxl7kfd1VDlhi5dLJ0UzBC9aiJgFUenklm/7C9a7+B5bOyMsgQPFXWxdS2TgGTMiorKM4Rnl5jjwZVEIZhNHpXP/n3/3BIeB5rjyMZM/D0FJmIPSt7WKXU3RS6Gu/epsqU+whU6pjzjcDvxbJWUAv76eNUafe509eM/waK8hAwkSMxYBVQPlxnpHp/WbEppCS7FF63LP3nEFmMCnemwVtdWKHhUHy6N7O8YNEOoYvcx5jM/b/OcCeJs1zPRl96oSYOa/NxBUA64gFGF2LP6HG6YVIJbs04Tu+75ARw7H3MRzhVtb9M9EyJbgTi+XKUpylTXdTyo7zx4EyHW7o4HCT0MdWPQRs1/GXtdb6xzJ4MJZ5ZGfjOlC8XkW46jqSxX/rZZWCkKsN9aFc4N4Ds3O1HXRns2DgIHQZSg+qdzbkGo9qkSDDpUSOfG4TjL7XRXvsqGZLdKDqXqFJ/1mwveKs+F50YvZ7NwZIbxzxtKTMeUmi9x80EmKWUs37Whex07w66OiAN1AZYDjsc8VxOGXBPse3/rZz0gFLBwfbRPdEgmOhBB35aL4esx1jGVCqAoh/LwmgB/lnPM76vYrRQ0CMV5GKrhoKrBDmx99ud0AEddbqbPe3xUdCsCbug7tJ2TmtQOmpp+J4j4UOSKCS97DthdqlqzoOxJrHcnsGJGuo91TqUtL2Y18UXcpCTazz+vuKDpOD0UiAScldlQj8aNuGS5qQH7sWKEY0eo11745hibfXqkRJSUngkQFrxhtIhmNel8V
 W5dolg0d
 bh27X5u5wR7oq64ipKXrNmx+1g8hJZTnRYW/mULR2U3CWtaVeiKkd+xtB8XMVW20yTFbiyb210q1DdUR+qRAWpIlqXPm8I6zufa+t/kAFjY0Z0vcPW2Y542JYan6VWWH24LyZLQgk7+luqCsEhbkYIALQgDMiIYBq5EqPLyZtuPkizRKpc1IEJtzaOiiIXVJ565imsI0ag2abw44y+tEMMNVJfr201QHga5gOIXRhA0O4BuqKxEpUo6EbaYTUUOqM0AEygvMqQwsyLOqP1+apYWs5BJ4VwUREwZ57AbNa4ezegKwcBWVOHO4Iu7oejQiDXHo6k5u6LwD+gQWxPuT7QtxEwuwp5S0eATtNsrd7Sh7IiyQTgikvaFHGj7ly+uoYKRUiY1oAkNLYyIQSLuLPtvRYc36Df7Y+oqcuW65QkrvZvIBw2cyPfv11s7j2ZYu81O1UQI2BOZ8g3gDkjTM4zqSX9s3mdDiIAFGZjf6Rz9hCYSsMHVR6p/hNPH6Qakatj1a5pxlTlX3rZuNPdMscPb1QfpSzdUyU02OL9jK4hEMn3uCOjv9hGQjm8O+S8snYL93xQpVgEtB0wZlWAF2lo+mijg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/01/2026 17:53, Breno Leitao wrote:
> Track and display the number of kexec boots since the last cold reboot
> when CONFIG_KEXEC_HISTORY is enabled.
> 
> This extends the previous kernel release tracking feature by adding
> a counter that increments with each kexec boot. The counter provides
> visibility into the kexec chain depth, which is useful for understanding
> boot history in production environments.
> 
> Add a new property, "kexec-count" in KHO FDT alongside the existing
> "previous-release" property. The counter is:
> 
>  - Initialized to 0 when kho_in is instantiated.
>  - Incremented by 1 on each subsequent kexec.
>  - Printed alongside the previous kernel release version.
> 
> The counter is stored as a 32-bit unsigned integer in FDT format and is
> only active when CONFIG_KEXEC_HISTORY is enabled.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 25 +++++++++++++++++++++++--
>  1 file changed, 23 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 06d99627bb3c..fe5a2c5c4c86 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -38,6 +38,7 @@
>  #define PROP_PRESERVED_MEMORY_MAP "preserved-memory-map"
>  #define PROP_SUB_FDT "fdt"
>  #define PROP_PREVIOUS_RELEASE "previous-release"
> +#define PROP_KEXEC_COUNT "kexec-count"
>  
>  #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>  
> @@ -1257,6 +1258,7 @@ struct kho_in {
>  	phys_addr_t scratch_phys;
>  #ifdef CONFIG_KEXEC_HISTORY
>  	char previous_release[__NEW_UTS_LEN + 1];
> +	u32 kexec_count;
>  #endif
>  	struct kho_debugfs dbg;
>  };
> @@ -1330,6 +1332,9 @@ static __init int kho_out_fdt_setup(void)
>  	void *root = kho_out.fdt;
>  	u64 empty_mem_map = 0;
>  	int err;
> +#ifdef CONFIG_KEXEC_HISTORY
> +	u32 kexec_count;
> +#endif
>  
>  	err = fdt_create(root, PAGE_SIZE);
>  	err |= fdt_finish_reservemap(root);
> @@ -1340,6 +1345,10 @@ static __init int kho_out_fdt_setup(void)
>  #ifdef CONFIG_KEXEC_HISTORY
>  	err |= fdt_property_string(root, PROP_PREVIOUS_RELEASE,
>  				   init_uts_ns.name.release);
> +	/* kho_in.kexec_count is set to 0 on cold boot */
> +	kexec_count = cpu_to_fdt32(kho_in.kexec_count + 1);

Should this be kexec_count = cpu_to_fdt32(kho_in.kexec_count) + 1; ?

> +	err |= fdt_property(root, PROP_KEXEC_COUNT, &kexec_count,
> +			    sizeof(kexec_count));
>  #endif
>  	err |= fdt_end_node(root);
>  	err |= fdt_finish(root);
> @@ -1468,6 +1477,7 @@ void __init kho_memory_init(void)
>  static void __init kho_print_previous_kernel(const void *fdt)
>  {
>  	const char *prev_release;
> +	const u32 *count_ptr;
>  	int len;
>  
>  	prev_release = fdt_getprop(fdt, 0, PROP_PREVIOUS_RELEASE, &len);
> @@ -1476,8 +1486,19 @@ static void __init kho_print_previous_kernel(const void *fdt)
>  
>  	strscpy(kho_in.previous_release, prev_release,
>  		sizeof(kho_in.previous_release));
> -	pr_info("This kernel was kexec'ed from kernel release: %s\n",
> -		kho_in.previous_release);
> +
> +	/* Read the kexec count from the previous kernel */
> +	count_ptr = fdt_getprop(fdt, 0, PROP_KEXEC_COUNT, &len);
> +	if (WARN_ON_ONCE(!count_ptr || len <= 0))
> +		/*
> +		 * PROP_KEXEC_COUNT should exist if PROP_PREVIOUS_RELEASE
> +		 * exists.
> +		 */
> +		return;
> +	kho_in.kexec_count = fdt32_to_cpu(*count_ptr);
> +
> +	pr_info("This kernel was kexec'ed from kernel release: %s (kexec count: %u)\n",
> +		kho_in.previous_release, kho_in.kexec_count);
>  }
>  #else
>  static void __init kho_print_previous_kernel(const void *fdt) { }
> 


