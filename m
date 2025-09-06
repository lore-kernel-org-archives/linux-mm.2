Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93CE8CA1002
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 22:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 768AF8E0002; Sat,  6 Sep 2025 18:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7199D8E0001; Sat,  6 Sep 2025 18:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62F1C8E0002; Sat,  6 Sep 2025 18:26:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4F83F8E0001
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 18:26:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D860140605
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 22:26:01 +0000 (UTC)
X-FDA: 83860259322.26.81F28EE
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 24BA1C0004
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 22:25:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=WD3MTiEV;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf28.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757197560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xt7zC4IHQ+iWsE/ZnrUTR3tvhZamW/XzIhStal409Q=;
	b=XP0ds9KgX+kWWyy7Nr/aSGjZ7VyuTSUeuzStxHJDvWB9lO3r3A6DoZdYCD4EiM/iUPdK0I
	y1rny90+22aRPodHirVQGaLOlElDaAVNsbSs7DiH281HaN6ZepVfYXqtFK1z/Wq6Be4Y7C
	6QMg8xHU7osH4+S37HrASl4AWjptdVE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=WD3MTiEV;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf28.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757197560; a=rsa-sha256;
	cv=none;
	b=fyx1hDD7lMIVIuYNFbIRmEHKH5909JQShUTJPz/js2LyiG303CrAA7bbHbCQxXG/7Ovo/1
	tB7okqOZnuPYDxvreag3ilk5AavYNQiXhZ5+OtnpMCQocYLXcFi8oq5KG5qZ+oi+B8t/q/
	LUEUhn81MpMQNouNZvQfvYUyKdsQOzs=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5D1C440E0174;
	Sat,  6 Sep 2025 22:25:55 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id dk2lFWfXvPj3; Sat,  6 Sep 2025 22:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1757197550; bh=+xt7zC4IHQ+iWsE/ZnrUTR3tvhZamW/XzIhStal409Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WD3MTiEV8OF4augBQVbQgNGLghdqY3TGMGBKaP04329b5L0DfzUVoj6QisowlNw4q
	 /IMj/MOBJpym9nNPw614ZhpVoMP5w1yuQF5kPartCXJqMa8Y8XYxvSfck0Q/01W3B3
	 nn8KSHr9Gl9zpWcYyX9FfXtO6rv8Acj0x8J7cOCKSj7mneCH1pBnU4tALMr//aSRiV
	 JsarJg70bFFzngYonXdqFYcd12mk/nnjOgMSn6aBM+bE/OriCnRs6R4Hulgb2qz6O/
	 VW7Lr/J5fCtr7CVUTwUERpePji+KXecc2VZ6m6Qvyhs18CQK1KPjx4x8gXZ046Pk5J
	 3ue3KUJaHHsifVJ3uZy3f1QgGhX0OBZHyL7GvLXsHTTNOuD9O4weesISUfuLDcM5K1
	 OqlaKTYRVzaGe4EITMImM1OnWIUj6FuCaK98tfb5WxnD2Z7ieoNWkgThfI0dvol3Vq
	 YlxqNXWxHfq2LA3HPkRSY65mcoR7Eh6E0HB4bJWEmt5xWen+K9E4umS1F/OD92hhGH
	 x/tsRl/3VkdOQ6cX5+jIkYx3cXzNLyCOeR/mpL4kDIhRgHxR4HfeXCIvAIa8Hi2rTU
	 w+8vl+o4wHFs8OKdpAX5CGtYq90mFZUnHa2qU7Zed/GPtfOzClrq8bmmTPkBK70yan
	 XdV58lIASbpHeb2xhWiQxkN8=
Received: from zn.tnic (p5de8ed27.dip0.t-ipconnect.de [93.232.237.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id AA3B540E00DD;
	Sat,  6 Sep 2025 22:24:29 +0000 (UTC)
Date: Sun, 7 Sep 2025 00:24:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com,
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com,
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com,
	trintaeoitogc@gmail.com, axelrasmussen@google.com,
	yuanchu@google.com, joey.gouly@arm.com, samitolvanen@google.com,
	joel.granados@kernel.org, graf@amazon.com,
	vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org,
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com,
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com,
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz,
	kaleshsingh@google.com, justinstitt@google.com,
	catalin.marinas@arm.com, alexander.shishkin@linux.intel.com,
	samuel.holland@sifive.com, dave.hansen@linux.intel.com,
	corbet@lwn.net, xin@zytor.com, dvyukov@google.com,
	tglx@linutronix.de, scott@os.amperecomputing.com,
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org,
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com,
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org,
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com,
	mhocko@suse.com, ada.coupriediaz@arm.com, hpa@zytor.com,
	leitao@debian.org, peterz@infradead.org, wangkefeng.wang@huawei.com,
	surenb@google.com, ziy@nvidia.com, smostafa@google.com,
	ryabinin.a.a@gmail.com, ubizjak@gmail.com, jbohac@suse.cz,
	broonie@kernel.org, akpm@linux-foundation.org,
	guoweikang.kernel@gmail.com, rppt@kernel.org, pcc@google.com,
	jan.kiszka@siemens.com, nicolas.schier@linux.dev, will@kernel.org,
	andreyknvl@gmail.com, jhubbard@nvidia.com, x86@kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev,
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 11/19] x86: LAM initialization
Message-ID: <20250906222420.GBaLy0lL5lHcVlYU0C@fat_crate.local>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <ffd8c5ee9bfc5acbf068a01ef45d3bf506c191a3.1756151769.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ffd8c5ee9bfc5acbf068a01ef45d3bf506c191a3.1756151769.git.maciej.wieczor-retman@intel.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 24BA1C0004
X-Stat-Signature: eo5g6kdgykdd7oqqwi81q8ri9qzmqcge
X-Rspam-User: 
X-HE-Tag: 1757197558-285613
X-HE-Meta: U2FsdGVkX1+FcmvpzvXPuDnWyYQQ0uzeb8Oc61kk69zrzrMrIpB/fmepTsf13E1y4x3zE+qo3OgavRHvP+I4RmSVbODZZyC4hU2ZbRpBBp3gHxuBFdMNWp9hNvsJoJzwqWgo4lmxE782dFEtdRCQ5Zwy8KG6P0j/OlhFkB1bealNJMDkJss+98//xMVawVo0xHHPriihgcxbffds0GJIQGKRJc5TLH4KUQ9OVT5h0B09oH/HzQ74FUrgUIxqRmn4TOKJ7rc+OmrCcv8BDVGLvhYlheC9OG4V1JAGrhrwJ271tagaoWxh7ixg2JZjSodg98tjOapYvcGRlUD8hn69JPYJoDQ8bA8ptmh6ssSKcTzycyHCDtsomtXU/CWYJbiXvFy2a4yKeRtLHy/MTu4MF/bmppWpo8mzqMaDXmxdd4xiIPliLeZfqYI/6ozMlyKA4S5qpBz9aDAJQMRjJivDXxLVkxUFi3v25cgJNq1cdebZ0hVB0rgwVi5eVngWwHsv/SJTNB4M0cm2bjZBtIarje0tZsZXs/xbJtXul+YSOaByzD0LgxcWKjvf6hhVWxqbVGvVg/+tG8fj4PZsaO3zF59MSCN5yufaaDBZhN0+PHROac6LP5zH+O549wsfHoH8KO3NBsSd3yV+CmaO47uWsspZIzpGHCydBggH8OhR8jUKhYOEFey8EkBBUo1ROZfx9PWgOQvV+QQHuy8AY7n5KVyOqigmb0fXCajDClXC9wDyjM8vDcrcQCNejuD270HRGuoX20A4tyGBleX2O8kzqA/SBbcS28pn+36O43uT5CK5pZjNFEYGi3x/jKRy33roIN/fpVJAYAr3BLuUDzssNlIwrqB7fUhVLxvZAf/Y131rzYWslYI36z0P7VbVpepxWqqT96SpodR18ETOip9gFL0KEIr8qZe0Li0PTKkuzo5xDHU0WMOdcoJjCkVNZF54jvc+iYG9e9qx1FJyNys
 9XwSZJdQ
 QjMkvZjA7U6fvm/dzhsq3wnCWear/ybc64DElbLhNzMslgjGQfS09jYbPtqnVKAJ7ItTDbG988Hp2P12rHrMtDgirLAwHLkqm0WxZjpP25rADl72fEhHgjGoQqjEogFMezc6S2Z7q4QbBEPGEgvAnztT8s+myiOVKVOFWYcMx3Nu/HuN54SXcIhEA/GNv0hK2TQf2bZNkGe2CCLWA4zs+rYMn0trQOFieA0hgviGDOEZxODQqC0H0ok4iaEkbK9Fgc7hWu5dEr9eRibXYDp6py02egQ6aKvo07URho03i7KrLtvLyqXltONMc+g5VBNyLksGgKBXqRaNJVKgY8hbcUpRRyPH03c6SrAW4ww4YlHAnZg4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 25, 2025 at 10:24:36PM +0200, Maciej Wieczor-Retman wrote:
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index bb57e93b4caf..756bd96c3b8b 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -763,6 +763,9 @@ void __init init_mem_mapping(void)
>  	probe_page_size_mask();
>  	setup_pcid();
>  
> +	if (boot_cpu_has(X86_FEATURE_LAM) && IS_ENABLED(CONFIG_KASAN_SW_TAGS))

cpu_feature_enabled()

> +		cr4_set_bits_and_update_boot(X86_CR4_LAM_SUP);
> +
>  #ifdef CONFIG_X86_64
>  	end = max_pfn << PAGE_SHIFT;
>  #else
> -- 

Also, for all your patches' subjects and text:

Pls read

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#patch-subject
https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#changelog

and fixup.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

