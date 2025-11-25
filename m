Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD194D0E6C3
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 10:50:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10CDA6B000C; Tue, 25 Nov 2025 05:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EA8C6B008A; Tue, 25 Nov 2025 05:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0215A6B008C; Tue, 25 Nov 2025 05:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9EAD6B000C
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 05:50:35 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 961C01A06A8
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:50:35 +0000 (UTC)
X-FDA: 84148810830.11.B849CAC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 794B5A0015
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 10:50:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764067834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pie72MIuVJEX1KVkI+wlq+1ve8OCAK8hEKXxt+xKxQA=;
	b=AP3bg8nVmxGu0209/drE5A8MJwcG0a4CbTbOuyamLuF+/dCZ//xCY1E6zzMcrP7AwRyhEA
	OTGRb1MlDsM1jWJepcQ3m8+Hvp0F603uwUB1KcoOZO3dAVzYD5xgLVn0JM08h6Rb5AbLs8
	wrCLWSRxEYPRogQreu8wrIlg2Qmg8w8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764067834; a=rsa-sha256;
	cv=none;
	b=Xs5LKxvo6Oc52/pb/m33ty8PuU7FfInWt/+/Rugyt7cL97M4iapH9YxG+SjqhIZlTd+EOo
	QOUzx615cjUVyRTd5jNakjCAnLrU6BPIsiHUA/3otL7+6UyT/UhG/vL+Wx+rf+D8fvxjbO
	Ai91GhPpvKLaxn3wKHjQbY/3AOSqpCA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F28E014BF;
	Tue, 25 Nov 2025 02:50:24 -0800 (PST)
Received: from [10.163.47.245] (unknown [10.163.47.245])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D61AA3F86F;
	Tue, 25 Nov 2025 02:50:28 -0800 (PST)
Message-ID: <44c43197-e881-458e-837e-2aec673aaf97@arm.com>
Date: Tue, 25 Nov 2025 16:20:26 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Fix DEBUG_RODATA_TEST indentation in Kconfig
To: Geert Uytterhoeven <geert@linux-m68k.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Jinbum Park <jinb.park7@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <74f39b1bffc6ed802088cb3e7d17b4c82330e8b3.1764058676.git.geert@linux-m68k.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <74f39b1bffc6ed802088cb3e7d17b4c82330e8b3.1764058676.git.geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ncu9hjdeqacra1p7ynfxtumdf5x9prjd
X-Rspam-User: 
X-Rspamd-Queue-Id: 794B5A0015
X-Rspamd-Server: rspam01
X-HE-Tag: 1764067833-523181
X-HE-Meta: U2FsdGVkX1+Iu+uNQCzp2i2FQoNa0oL+zwat8VZIMGwlvp4Qt5OVfY9+UGF4ml4JAlPv/BZJfGaOWXuOr2d0ztxE8niXZli+PDkQ50xEzxC3ae5gtvaomPokY0yK4QAGyaznqZG1zbBtm2PeHMvsnkHLFy4LopSPfQgJ5I2RW5jRF1uQuaQUaDZPVJqdWpHcRR+YWT8wKyv3MeG/SsJCnnX0A7TJ38Uwp3EOHINsxgbwIPai/LAc1TQR8QObunaHttWn6a62QD5ch6SU1uyrAp3WWTARnnXeV5Foi9EhuqWTqpb5P/5UlCRzAkqCUNwL6DGIN2VFwdRuA6z6Y5qrQjoBRBpmtjWArYfTggVKjkpMDzPEmorOtSVSkRpMrbmNsd3K+89kuUphrB6mzp7mDvh6bEoQ/43801ZZcL7s1BrUyQsCoKONy/FGZCQTXy6ZOVIjst4ZlcXVZb58+r07KSmkZS6HQHrl1WxKC+0DRuqVzVfY83EtuKcLIRZd5Nmud2GJ8q72kmO34+gvwdj1sd5uz619k+6t4Xf4OdAApvuF0aQomxuTR1t8R0zUyyZTdHFr7kfmS4So2A+5zzrA5uVZ37P/ay0kBREWjwiqsJRim/aswa9cq8iWj6IIAWCnWFbakgLmjtCUs2r+4XbdDAX0q1pYV5vC3cjQpyl+qsgMEJYkigVi9fb2zwFxnko4elRhCdxKyew/3yNxY8p4/eoLLHwSJGchnhsAS1ptzpnwtXEyFlDBMAd5mzEk07Q04LDotspoeik9jEIkkz9FWgTZGyl6LazTEX23yA/3zUyYcLip91aG4iFnttlwZxDkMhs0R4pEUeF+8Q02aRQlA7eGeDkxq3/cZAz9A/CAUsVMph2xz+Lx4iF+sSfbqpfIyyCtSADM23csfbNgHwfZQsmT5akpvLzN3ysSQu3NOvj81OP4w1C+8OVGZs6mFOAnMi/0ZTAl9U57Ury3i6d
 olHzg//P
 sYlJymY+DcJIWv2P0tobc7LvodTgg0NQZkzmrmArgAAXDwzMCWW+lMcyfuObqbffO3RDnHlGQplCQcVorpSXTwwD6cOWuznnEnIRSj5PLtcMKJKnYxCoehwqXhyfmkj8S2q2eylgXb1hfUXCJBGxLo6h0h3NJ5hm4cj6VOnNNDT4kqV9Rm1qulXR4o7FzhVbd8xSWNCzQy4qiWgW/skwnqlMsj8IYvo2K79aREw17rlkXz86JIFhhgnKp4JB3csCMbiYLvxH7k00CFd7hJVeHV633sgAAT5EH5/jJNXbGUI7vh14u8VitkL5VsmznnEuKlIBdAQKOaWN6JfLX3OSn9vDAiXOnqYzBi7G7PMMwi+mcQi2nnXfWk/+s4GoB1jSn3IQB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 25/11/25 1:49 PM, Geert Uytterhoeven wrote:
> Most of the DEBUG_RODATA_TEST section is indented by four spaces instead
> of the customary single TAB.
> 
> Fixes: 2959a5f726f6510d ("mm: add arch-independent testcases for RODATA")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/Kconfig.debug | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
> index 32b65073d0cccaf5..7638d75b27db8cf1 100644
> --- a/mm/Kconfig.debug
> +++ b/mm/Kconfig.debug
> @@ -175,10 +175,10 @@ config DEBUG_PAGE_REF
>  	  nil until the tracepoints are actually enabled.
>  
>  config DEBUG_RODATA_TEST
> -    bool "Testcase for the marking rodata read-only"
> -    depends on STRICT_KERNEL_RWX
> +	bool "Testcase for the marking rodata read-only"
> +	depends on STRICT_KERNEL_RWX
>  	help
> -      This option enables a testcase for the setting rodata read-only.
> +	  This option enables a testcase for the setting rodata read-only.
>  
>  config ARCH_HAS_DEBUG_WX
>  	bool


