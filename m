Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64C7FC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 337FA6B00D5; Thu,  3 Sep 2026 06:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E8616B00D7; Thu,  3 Sep 2026 06:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D7A86B00D8; Thu,  3 Sep 2026 06:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F2C8C6B00D5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:45:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 902F58048D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:45:57 +0000 (UTC)
X-FDA: 85172120754.30.B49FB41
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id C83F8A0003
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:45:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mmq3evjb;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788432355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cVItOS3d+HSRZzTz2ZIRSaQZZ8Kvrk+kbPyv2r6g/i0=;
	b=f0HpZoue6LGwg28QZ21B/9DnoAEsZuREqXZReH2V6QZQSEJLkRPQN0BIiJgU9uPKJU9QFV
	2MblPJnxTlpj+Mpo/NMPkT13yETTzP4ioBsFD9fdBrb0GcmO+TMaxgO31Q8HrDeYmU4+IH
	82MCbCkq/JmgO1UGDDsdCmRUzU3FYCo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788432355;
	b=rKVCm5DcIMjBovJcZBONMxWrbNeKMqjI3jGTn2QBzEw14oU2AMinlwOMS0bRKfba3HzvYt
	D+n9BfpVkjiodzGKfuCOH4PuqHhitMnCSAsfhuHcVUHQPyuop4u0+EQd+gn7YLmgEqwNjh
	6f1Af6MAKIhU7b5E76Klhog75hAM6TI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=mmq3evjb;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1B2FD1596;
	Thu,  3 Sep 2026 03:45:51 -0700 (PDT)
Received: from [10.164.19.53] (unknown [10.164.19.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B13C3F673;
	Thu,  3 Sep 2026 03:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788432354; bh=B2EGgiinFjR7PIuJDjwPP8zw52e7kf6hQY7DC+ox1r0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mmq3evjbS8hafbKWyN6WfvB9UfVySk+qoHqsF1QzrHYtoeRp/5znyDeIxQ0XWmzpM
	 HmppJc+wsmOrkjn5ugj5vuGdbtya+eR9c57C4aB5SNws+Twq1UmKFOoPZzxS2fmElr
	 iaXr3Hj7l3p0cwNUfXzOQlwUrYPQgaUrPZbbaJFc=
Message-ID: <f4de678d-de34-482e-85c6-0d168af62563@arm.com>
Date: Thu, 3 Sep 2026 16:15:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/vmalloc: constify vm parameter of
 get_vm_area_page_order()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>,
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Len Brown <lenb@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Pavel Machek <pavel@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Sven Schnelle <svens@linux.ibm.com>,
 Thomas Gleixner <tglx@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
 Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
 Will Deacon <will@kernel.org>, x86@kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 loongarch@lists.linux.dev
References: <20260903-execmem-set-vm-perms-v0-2-v3-0-949b64a9f755@kernel.org>
 <20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260903-execmem-set-vm-perms-v0-2-v3-3-949b64a9f755@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ebg7g3o3nme59o347itunecgsfi3frmo
X-Rspamd-Queue-Id: C83F8A0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788432355-177381
X-HE-Meta: U2FsdGVkX1910rq763A4DM8nJefYR6sGDFe8FE/JEnn4gMn+VFFkALXtD4ZgR9c4jLqHbMxc+O/TugPqQn0xvXN2Hu5v7xMUiyqseFOL3CRZgkZTJMamnUt6r//mOGsR82WRFedxp86c6vw68oZuKbdWSzEUVbfOErXPi4bAg1Gm0ar6b4+M+jO6IPHXvOEceiHD5dacprTPEJCw2XlttZDl+Fax7MjwG5sje1JsX7xnwZRUwOxRLVtcPlp6a1W8AMfeHOEaJ+TbVWuFoX+07vplqZYRX3Rek11i4G0JIbmytGR6LjF1q1CCMjFZrEaGB12LwFDtz9z67LiDbzPb/6UJmi2lBl+7mWWzJc2yXUmVpWDLpMJ4/09yhYlNuLM0gpyigAoh1reOoAQ+TZYWIylefTqyLqApVZolBLA+iLk7cpKhbz/a9RojKoj1OheIQGLwb/hodHs/JD38hF9PANqSxisxolaqfGArdBvL7ODvEdTDaXrFlhBDAPKEzN/x+JDJA1Q8yxqAANxzYXUq91W88e4lEB9S7RPn84cGIH6O2eiGXMecbufKytd5aQqxgB0LQpxJeFdA6baviEcSP2Lsa/qWlgx536AovovFJ2IB+ODGm6YOmpk+2nEnodduyQx0DnWBbb4Lld1lNNQ+3roSsMqMK7mCkfvLr5li1aZYloHKdESUYJxpKmVlEqrvlaHOIt1pPU+thK5VzN+6hyYuaE2yplKr5mcLZcTUcbzLl55wKBItpckon+QOrpwfamhCRa8chK/EkztNdGNlvSaESD77CbjltbTMqja/NIHNxOBwXbttbLarTt2zkA+4AlGd2qgpmgBIVXDrg1+FKb22xr/thrtwwK8gembhlJvXPl2sUnT7ZMb/uXkQTn+EeeRXXN3xugWpyffZfAFIlmChV6ni1FCaIK7kivN6I6+7SxYfAcTp0XVMiQW9crBiWcY+31AN8miRlfHTsFi
 xTvXArkf
 A9Ejx/manLufiYbp2sPye9WwnU6tc83puyxPXW0AtEXNdV2zoJwbaatU9/2Y036CME1AqywJ5EZQeOaBDDAoxNvob9DoS5gk5MO3haw5zirDeXgQ0h0CNDl3VEAkkxSjkbrE9k72nDyI9MLEwlB7kqB9AJSnMvpedH2zB8DBtivmuEujH1Lfl3erLtOG9rRhfpM+6fnTvFGJZr4xA45ZCC1b4e/Vugo6cLApcAQoZo2r+DPCP0328c4lmve04URDuveTyMPztxDC6X+qljfMXnHVPUtbOfxHdn9Y65Ae4dPFYHwbEnwYQcKlny6W243Gk0DSF9m0PbJNR6IIJJYQhQ2c8bby2FPOot7uKI6oJJmDkvXNxG5qqoU6O0TYYe+kPPNVak89XXvVH7t8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/09/26 2:58 pm, Mike Rapoport (Microsoft) wrote:
> get_vm_area_page_order() and vm_area_page_order() do not need to modify
> struct vm_struct passed to them.
> 
> Constify the parameter.
> 
> Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 4 ++--
>  mm/vmalloc.h | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 22aa554d123f5..5506b180f5c27 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3130,7 +3130,7 @@ EXPORT_SYMBOL(vm_map_ram);
>  
>  static struct vm_struct *vmlist __initdata;
>  
> -static inline unsigned int vm_area_page_order(struct vm_struct *vm)
> +static inline unsigned int vm_area_page_order(const struct vm_struct *vm)
>  {
>  #ifdef CONFIG_HAVE_ARCH_HUGE_VMALLOC
>  	return vm->page_order;
> @@ -3139,7 +3139,7 @@ static inline unsigned int vm_area_page_order(struct vm_struct *vm)
>  #endif
>  }
>  
> -unsigned int get_vm_area_page_order(struct vm_struct *vm)
> +unsigned int get_vm_area_page_order(const struct vm_struct *vm)
>  {
>  	return vm_area_page_order(vm);
>  }
> diff --git a/mm/vmalloc.h b/mm/vmalloc.h
> index 8866ddcff6681..211869f365095 100644
> --- a/mm/vmalloc.h
> +++ b/mm/vmalloc.h
> @@ -12,7 +12,7 @@ void __init vmalloc_init(void);
>  int __must_check vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages,
>  		unsigned int page_shift, gfp_t gfp_mask);
> -unsigned int get_vm_area_page_order(struct vm_struct *vm);
> +unsigned int get_vm_area_page_order(const struct vm_struct *vm);
>  #else
>  static inline void vmalloc_init(void) {}
>  
> 


