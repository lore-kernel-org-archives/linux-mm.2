Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF193FC6174
	for <linux-mm@archiver.kernel.org>; Sat,  3 Jan 2026 05:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24D6B6B0093; Sat,  3 Jan 2026 00:36:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB436B0096; Sat,  3 Jan 2026 00:36:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FADA6B0098; Sat,  3 Jan 2026 00:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF6BF6B0093
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 00:36:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83D9FCCB07
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 05:36:34 +0000 (UTC)
X-FDA: 84289542708.06.D4F67B2
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 86E19180004
	for <linux-mm@kvack.org>; Sat,  3 Jan 2026 05:36:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VB+b2J98;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of shorne@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767418592; a=rsa-sha256;
	cv=none;
	b=zwsbflVjdqyDM1heshnFnehD9TZgAEDarGvXZwBqb6mkmFU6Hq8dXNS75vOSChlOmI+R6E
	RZGWyvn+GHWsFQMNggXAjb55hcQEmQgVP+c58rJpHGCt+X/Iac7ehYotbNh70m6yx66oYF
	qQhZtSHYF13XgL1oBOL8sfQ8lmmi/Rc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VB+b2J98;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of shorne@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=shorne@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767418592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10gk4kIzv5viXrYP6wsblohOaaYzL8Wh9uCfOfLAyTE=;
	b=uChC9IG36RVgitjUdvgXx0NbiOppCx/WQTjf5aFQDh41t77M77zGqAUo8axJFMZOjIoLMO
	ZcEQ3lMPrM6VRg8kWmX5MDmU20zApPN5j+58ZmJg0Fi7LuEXdUKfgITDTx/NobJNgw0EyR
	zemjGzMj3CuNbrSdeBeFUJokTqhFUKQ=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-42fb5810d39so8128699f8f.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 21:36:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767418591; x=1768023391; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=10gk4kIzv5viXrYP6wsblohOaaYzL8Wh9uCfOfLAyTE=;
        b=VB+b2J98IerAxpzmpm4lvbEoBDJJFhrn06I8HwbFFRfwjYIBKvdPJFvK692Xv5UWnw
         qfHSQlw0gyB6YTMImSj0qvvFqFwW+kI7/Hb40U2QlM0M3Brkw7x2d1sMkX+d4YkKgZ2P
         soNK+mCbaEidX0XMHWkYaWNB/gKxYQj6USZgGYvcmqy8oQ4G5UktVXn+4dZNlzXi9Roo
         CHiB0QpG0c579Fu3hxWfk6rXaoXc0eX1lHj4nTLKsDyLt7b68mCCVjIhMm75DAQFM51e
         x27AVOzrTxWfVlKgZlLFto48AOR1TKp+vw+brqpbKUH+J3ua9LJppKRWj91XzXDmEaEJ
         BaFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767418591; x=1768023391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=10gk4kIzv5viXrYP6wsblohOaaYzL8Wh9uCfOfLAyTE=;
        b=CNE2wuRgk/mbtDEqEFrfistNWkTx3blAKPJvx1uP9at4BzJ/h0WC1Y6VQUwDCSsYNT
         xoOfDrv0ko2jBl5mJzIPy8hp5lRXgDh4DQQuMwht3cAU4S6q8PFGjrb/pAgnfNsPZCNt
         AT4pWnVy3Rq7gtTDHMHhtm48SsnKXpEfsgB4wzxb8gAikNX7mDz2pRbu8QLfnyQ2ProT
         b9Gd8sc9km6HUQucK3HF9Y7Gjcjdkiw+Ny6P7grCCuQyry5nW6H9fk18+xieKOF3OpbH
         0yCcdLeBZML52rhkTm7TUlgYHsBDwsIqgrvwS/1wDX6uaQKE9DoMn4tiLXBSOPyfaAO0
         ts9A==
X-Forwarded-Encrypted: i=1; AJvYcCUJTCUsIFLcMdv8/ElR0R+VZC47rKvrUfosSxX6mEVDoK6yf+H9DcSaNgTQryLc3NaPdWgHiel6yQ==@kvack.org
X-Gm-Message-State: AOJu0YwEzE+V8TlJvdLIVhEbI/h/o9Q6a2u+83iY28xtVBKtBnnT/bHS
	BY4DKU9RSh6I9fTNv3bFHaNSfC0Diil9YuhgjPd8chknL0BUskIzlzRO
X-Gm-Gg: AY/fxX5gwvhjP6Qj+MSD9gzKRnsPknQffrF3q1xVjEHClW2eA2EyTbYMqBJN8iPBG7s
	3mOPxfN/S0s0aTcXZzMryq4eAzjffXdBrNfK6CGdj/qkAJagXloJMwZgThyHA3NQAwsf9OnW8gT
	vC8TUcZSjnS6zPLZ1qmrussMJ6/x0YJaO0KpDQGH6x/Hr1ZEYDFbh5ztQRrphTzkQ2XEcDJ6gce
	sL31Uayp8/+huXT6ykkQhlQzpGI985REr1RSM83ecZrt7bTEF/VJcOfoym/BYExZnJfxbd9dffI
	lubEWpSZWHecV+HRSmccjWO+sLCkVfNX3a27TRm2uw2OnwyhrKtFJXs6QsAD391yYabZ09RmbdK
	4XJeNHjyGkjijn3924aYZRMxXMfg81Yb1FnLFMhT9COMdexoCH8YLHXNMA8t0u48d7cD11Diodg
	3IgQXFIqmjVc/rVJ7v/0m/g4YVzmVIa2HhJA/aXx0BJ1B5U2j8jUpxv+oj4DNg8xW+
X-Google-Smtp-Source: AGHT+IGVfFhDmvRzquITceR9a5MtoKyW2aPxvUx0HbCgVxiLGpVVcSZGOqzt3JsoKLBzXfIUaXLywg==
X-Received: by 2002:a05:6000:178f:b0:430:fd84:317a with SMTP id ffacd0b85a97d-4324e4fb825mr53362620f8f.38.1767418590643;
        Fri, 02 Jan 2026 21:36:30 -0800 (PST)
Received: from localhost (brnt-04-b2-v4wan-170138-cust2432.vm7.cable.virginm.net. [94.175.9.129])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa4749sm89007161f8f.37.2026.01.02.21.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jan 2026 21:36:28 -0800 (PST)
Date: Sat, 3 Jan 2026 05:36:26 +0000
From: Stafford Horne <shorne@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alex Shi <alexs@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Borislav Petkov <bp@alien8.de>, Brian Cain <bcain@kernel.org>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Guo Ren <guoren@kernel.org>, Heiko Carstens <hca@linux.ibm.com>,
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>, Max Filippov <jcmvbkbc@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Michal Simek <monstr@monstr.eu>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, Vineet Gupta <vgupta@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	x86@kernel.org, linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-hexagon@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-openrisc@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-snps-arc@lists.infradead.org, linux-um@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	sparclinux@vger.kernel.org
Subject: Re: [PATCH v2 12/28] openrisc: introduce arch_zone_limits_init()
Message-ID: <aViq2vsMk5tltK0f@antec>
References: <20260102070005.65328-1-rppt@kernel.org>
 <20260102070005.65328-13-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260102070005.65328-13-rppt@kernel.org>
X-Rspamd-Queue-Id: 86E19180004
X-Rspamd-Server: rspam03
X-Stat-Signature: 7oq7ds1pdbnswbpf7163xn9j6fifj99k
X-Rspam-User: 
X-HE-Tag: 1767418592-409640
X-HE-Meta: U2FsdGVkX18N9gEGrcDQxiDQ19kSv1oNjuJDRcoNugxDezrzUKbCn5kyLsLc0B4KpR1pSkNWzclDNlb5EZoCiY1g6Xn5IkqXT5MSsaza2002AyFvdqn2IsS29yXQ9uhHVhVhYdSyf/CP2yLOVsawicsJ93XSLzfoxHG6hKUXi4XvdIniXlqwVxmUuk+jaJFCjCS3gkPGjbCXQupAr7PnxP77liU0dkXXh8ccPSdNB20lYVrQjAQmkMIinTgqe2CVQ1pJZFNnFb+7Z8GArvaGI+G3MaU2g2pADszeEAeUGqZ92LAlhy0GvRbw7f/1aDsseV61eXAhFGoxx2A38Mh+cIGyfX5YEg/Pa+zc93gS5Yju6Nm3lCHUGP3dtgKBQVgbm9d5OSwxpTr0bBDgMZhpfpcZt4JKJ491sOjuLl+VNKEVW+h85p3YgRpZPat7Mi5krlidtMCpL8DDYTsHi9ZuBk3Voo4A+K1Cu8BWbBubSHLFV2sIH7zPAs+dTDVCT5gKSmWtSa/HPbpRNKM5xUwwyVpDjOYDDRoZeZUoIJK14qDxsPB+Ae/EjreQe2MpZysZUfUulS68g5NoLy6OW2VjMV4N8miAyI8DbdmkEdHprCE4fTBSJT9/wFXo5PGmn7YE9XQ5giG+1zUIUkldL4AnF6n4FXXlpotpzd8z5vL4ghtpEVp8aW5+3oOw94h4KzAHSu278bjL0CEjfpKkgwJgSKppKSqKNV9C5oVTux3kTOGt0X3jNxViohVKE6i/yjDxq3Zp8bQuOoz+z16csmibkNiSQwhS1kmMQge9jrCBjLBtDfBMBrMVNWWCwMg046vONwlbxzXuZECajgRSuRKI9vVmeJ0J4NrJsbA/X0HDUflqAVBX6Il1nmxj5hPbQn1+7OK1NRr8q/70/tTct9oFlP+gtiM45GZ5qO1n0X/ZV7oOL/a6la/PIbrrq51sRhJHgr8BED1dpbf2YDv6Z7e
 L9biE38d
 h5SvBpzXpVgeGWSpEBnqNCQfyeq1HZjCCsFpfNktDBuZ5Fns6ElaFskubfQFrDSxssEgf0q1Pzbm3MbspHvdlDK5NaopqKTVuWPe32D9xrK1hLJoac8FvCK5cQiRl3usVIPOM0QN6FlNW6BcBqNScrC9Y6hdkVjVd3Rt2+ea/ishu5iCIhFjYL5yu9oaFQUuV/umdA5MMyYNQOALOe+T/IlivaiSkdrovddcJqzoBGdLikhQwPvrH3PKoP9W/R08vkmkURMCjFuxYIHw4bTkPsnQE6E+Hhr6CEOz/0eOlSUv0nnWheq1aMjuVrayeIq9kG8fKQzld1ydPjlfCFhK6rNPe8pFsFOOLqGgw5TKZ3FUWsOLAcDlOZ32piACMW5bZ4DUwlPqjWB5y2kNbYI7MJB4/Lec3IBCbCOENpJt1k/6ugCC9KnPxAUMTuMMaDWnUM8vIAIsGUJp9iwNBwd7cMcOgVg9d8M1hP6FsQYqsDyof1o+GU5vK1ToZ8J0bwrjOghSl0zS8zIECrn/mya3CvtLbg3EYd6yGE0Frga/vSe35zHdZE28/d0lzHXt7NpwltN7x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 02, 2026 at 08:59:48AM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Move calculations of zone limits to a dedicated arch_zone_limits_init()
> function.
> 
> Later MM core will use this function as an architecture specific callback
> during nodes and zones initialization and thus there won't be a need to
> call free_area_init() from every architecture.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/openrisc/mm/init.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/openrisc/mm/init.c b/arch/openrisc/mm/init.c
> index 9382d9a0ec78..67de93e7a685 100644
> --- a/arch/openrisc/mm/init.c
> +++ b/arch/openrisc/mm/init.c
> @@ -39,15 +39,19 @@
>  
>  int mem_init_done;
>  
> -static void __init zone_sizes_init(void)
> +void __init arch_zone_limits_init(unsigned long *max_zone_pfns)
>  {
> -	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
> -
>  	/*
>  	 * We use only ZONE_NORMAL
>  	 */
> -	max_zone_pfn[ZONE_NORMAL] = max_low_pfn;
> +	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
> +}
> +
> +static void __init zone_sizes_init(void)
> +{
> +	unsigned long max_zone_pfn[MAX_NR_ZONES] = { 0 };
>  
> +	arch_zone_limits_init(max_zone_pfn);
>  	free_area_init(max_zone_pfn);
>  }

Thanks, this looks like a good cleanup.


Acked-by: Stafford Horne <shorne@gmail.com>

