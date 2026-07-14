Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA65C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B460E6B00CA; Tue, 14 Jul 2026 10:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D796B00CC; Tue, 14 Jul 2026 10:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A339D6B00CE; Tue, 14 Jul 2026 10:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDB26B00CA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:24:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7053D1C0322
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:24:56 +0000 (UTC)
X-FDA: 84987603792.22.C0C482D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AB00940007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:24:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hVUo0AzL;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039094;
	b=YzQVvFUrJJUJKALx3j/5Y7UAlNXyP6vAU3XbBMVrY6afNQxhLbcFVAW19ivNtZdkV+1b+r
	OsYIdW0NAnYueNePUWpo+NpaxaDcd1s96m69ptS+z7Z2w9tSc8YmiGYgstrGoNjL+hD6pj
	KPyu3TNFTCkFdY6Hw+nNY/laE+vBJsA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hVUo0AzL;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pyz6EaO/6llNSaFaKVzJaaM9NbK8ZwsmK152gESqL9k=;
	b=tDUTx0DNr7bNI5q70G1C+SyN71Pkjc8Zt+Xw72zYAjllvrv4typ/mc6hkcYvdugGXQRTU0
	0+6r1dAWct3nzW22pfw3HYg+3insIxg0Gq9qtPCQzoxXsipj2PzsAHz5Gxk4Vu1KP/13jQ
	V91902CA+V0mDi9OMKit2fh9GxrEuPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E03D840E13;
	Tue, 14 Jul 2026 14:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D781F000E9;
	Tue, 14 Jul 2026 14:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039093;
	bh=Pyz6EaO/6llNSaFaKVzJaaM9NbK8ZwsmK152gESqL9k=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=hVUo0AzLzX+R9EBHPvMHuu0cTkQtJ53ePYvEyPjTWz7YiJbTHWxyOHSYmNMfFQmDZ
	 r/FTeA0M/IXuLDuVpVcgzOAWEE5XtGlDITli8gGx3LA5aO3Issy3YPoLcj3PjNQdkL
	 RHGqQVzTKtkw4tbs+S1kvAeVBmspn0RdCpwc6BX1mC5Jwg+bNBUm/MnFwWLOerWGHo
	 VSRpau2/oUjcbMMDULechBup4aW4MCgelmz2WSl/VO1Jfqg9fsUoRe7hW+ezRVDQ4D
	 Qt7homRTMFD+rbEo9flhUpP+J99lOjf83PrPrhkPH6P3t2pVxhGKjQs5x5lJ2SPKEB
	 sN4JImhahLfow==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/kconfig: Drop redundant dependency wrappers
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Julian Braha <julianbraha@gmail.com>, Muchun Song <muchun.song@linux.dev>, 
 Kaitao Cheng <chengkaitao@kylinos.cn>
In-Reply-To: <20260712093326.8313-1-kaitao.cheng@linux.dev>
References: <20260712093326.8313-1-kaitao.cheng@linux.dev>
Date: Tue, 14 Jul 2026 15:24:33 +0100
Message-Id: <178403907335.85099.7801499875058888180.b4-review@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1332; i=ljs@kernel.org;
 h=from:subject:message-id; bh=IJCgrcH6A9ig503egfKPpGBy1RiIJ/iQ0X6c5JCcFWA=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLC3JYb6DxbPsf8lHBIT352kaitznJHs8Y40z3MF286K
 C82qD/aUcrCIMbFICumyPL8i/j+IJGweZ0X/N1g5rAygQxh4OIUgIlMuMrwP+LHUt9eM5dZ/Zuj
 qp+yfg++7f+q4l+h+G69QxXz3yxsSWNkmHxTfp941mbP1qx1F6doP2y6s3frgcaLkjOOvZdfdeH
 xG14A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AB00940007
X-Stat-Signature: oyj9n1o4p1tncnqyxyng34sgmpod9p36
X-HE-Tag: 1784039094-903409
X-HE-Meta: U2FsdGVkX1+eHoFLcHnb9wwIyRipDzC1T1vW7UCRdoW90qQjjvdXWmECxj+sL/MJ+5ACrjSANCguhZz3UzNJkgO3GE3Gnv6aLA1uiiAtFXEisDD1gtdqluqGkTtlxcvxk/GNPfdoJO0puqEnvw1plZ8pXjwK8v1nmKY8zVPC53l08qYBGpUdNCFHeQTKTteI5VE8Q/amcgTFkIKiJv79CZK9U/6uD1FeroeWa+m/Pp9qN1o2tx32Pf1xNC3gnmFnYXLKI0sV1ZoYFymS3BfANzXxhgysLFmjT6fHx53Brz0RcudSo/h1uvHoNi7Zuja3LXOzprDiT4l/HF3ipZdtGZ1Bw+VxYG2pVxAAadTI+VOunIi1A2+mamntou+oLuKTLajxK0e0WYAeWKJ1FAdTK+ii88xLqGhpP2aBPa2T3UzxNaPTGsV6OsBuNNrTk3Mdc2VXWUqVKx6j0rbjzpSOw1qjMk/VPCyV6e/+qev25F1WLouGYxa9YyTFdSt132W3z37PjFq/+jTVU6WaTO07bRlDtK7b3uGOYi2RkzgZWyV7jT99x+IRU+QPDRal8590vTZqIGIjGEeOjMab1wnkDXXkCuVmuOyA1GHmi4EUZOyR6grStGA4TCMN0vyC9FiIDCKEZgjvVNOEMvsBKXzULL4xVeeurJkTxVQEIqW1JgupuCzCCcEbgcULoBEiacBmpDX3dHVPo+NtEkj4TLGhdIy6sNgD52RI1leKmlZSK727VwnpU5/vPrJIIoHJlqWjlWoLic5KTmO2ibvsGXI/K3lCCZtRsey3udSYQvskQR4/mab+aFwSdTKASgLv5O965aSid6Q1Jpuz/xsL0KI2YdJ3oUbwCLOdIgkDbVcY8LVQlwiLtzpweMOldvHkAWt8FcLSzgO+SFT3dnPwM6+5EgudGPuFw38dMqJl4GiGBLEZOt/UvunfqjaFyuvN3wE9g+yHDe6DYf7nBjSNpeM
 iGVn0EoL
 dAzuyovenRkglyEFXowbMGq+8ggpnp8EUY62DVZE+vInvkrp7dUkp1vQBASu0PZtHWmn42hkdxyZZDk905HjhTKMYLpQ2Ljpj0tryhclQO1TCeRG+rFCfZNxkHNfXF6Q8JkHqes4dWXlUtA5V258B2ZPMc2U5recjs8PtzHGp64W4uDL1h9OylB6NI0jg21c/534mLWUsH6h1pQrKR7B7AX/t19pQGJsippo3aQx3nZPeLkdfbTDLhpS0U6SOKglo7ygrUWo2bRONELY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 12 Jul 2026 17:33:26 +0800, Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> [...]
> 
> This keeps the same visibility and defaults while avoiding duplicate
> dependency expressions.
> 
> Suggested-by: Julian Braha <julianbraha@gmail.com>
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

LGTM!

>
>
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 4efff892820d..eaff45c9f7b7 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -591,12 +587,10 @@ endchoice
>  config MEMORY_HOTREMOVE
>  	bool "Allow for memory hot remove"
>  	select HAVE_BOOTMEM_INFO_NODE if X86_64
> -	depends on MEMORY_HOTPLUG
>  	select MIGRATION
>  
>  config MHP_MEMMAP_ON_MEMORY
>  	def_bool y
> -	depends on MEMORY_HOTPLUG

Honestly I hate that we have both if and depends on, I'd rather we just had
depends on so we had consistency everywhere :) but it's not your fault, just a
gripe with Kconfig in general! :)

> @@ -1391,17 +1385,15 @@ menuconfig USERFAULTFD
> [ ... skip 12 lines ... ]
>  	  purposes.  It is required to enable userfaultfd write protection on
>  	  file-backed memory types like shmem and hugetlbfs.
> -endif # USERFAULTFD
>  
>  # multi-gen LRU {
>  config LRU_GEN

Cheers, Lorenzo

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>

