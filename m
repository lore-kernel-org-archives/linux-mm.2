Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D1ACA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 03:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC0A26B0088; Sun,  4 Oct 2026 23:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71996B008C; Sun,  4 Oct 2026 23:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987306B0092; Sun,  4 Oct 2026 23:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6176B0088
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 23:14:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E77F7C0C5C
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:14:27 +0000 (UTC)
X-FDA: 85287104574.02.8BE4EB9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2E757100005
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 03:14:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oa7+Ev3a;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791170066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XXlpucTuM2Y7J659tudsG5fCcp4t5Gm17zw/UMZGcRY=;
	b=Wdf2VhBm6kT42fojVBuWX4GhgZejkkzwsj5e57gK+KkvsS1ADAwKQDqLKRl1xbabFFEXKA
	xxB68fUBuodRWuEgT3Y9XULSQ7d37JOWs8f+KkzzYC1FgWXCtLv9mA3CMULb4Ijyk+mV7f
	BZV1VI74lBe/mo+W7OniiMDYuz0+MOA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oa7+Ev3a;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791170066;
	b=JdeDmpq9hJdmOvCDZ/9hFP3knKKE4K7YIScVxSk+S+KDDCixsGSY8q5+y70KbSb60krbLf
	r6dqqhOqn/MOrKM2K3elruT/1HhCrgq6vtcecjEiU9ACf+4oe1Zvyb4Jxd+BphqKoiJosQ
	8JtPF421yONzdjOEek59hOHC6iw/Qm4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E00CF1595;
	Sun,  4 Oct 2026 20:14:21 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AA703F66F;
	Sun,  4 Oct 2026 20:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791170065; bh=RwRpQ6j7Lh8Cw0VxVyBV2Ml57YHE5z8+0pVEOB0/zWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oa7+Ev3aFSuAcjDxN++3JTFT/7QLfaF0ONAhnlcbnovBD+A+ezJ0eOKSGpysU5g9C
	 /5OW1eJMf6ZA0AKa+qr/tuCSfRnU8RmC3Ng9Hk8SHMCPxugcJ2R7bl87JbpiAXPPQh
	 JJ46vqfpSHuZ8Xw+lkp4h5+64vLNio1IJg0+xzkc=
Date: Mon, 5 Oct 2026 08:44:21 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Jose A . Perez de Azpillaga" <azpijr@gmail.com>, 
	"Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 3/3] mm/memory: merge __vm_insert_mixed() into
 vmf_insert_mixed()
Message-ID: <5rttqmps6cycg7pxlsvynfilvt3auj3isl2prhv7ay6epel32x@nyezrhn4wut6>
References: <20261002160535.661399-1-ekffu200098@gmail.com>
 <20261002160535.661399-4-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002160535.661399-4-ekffu200098@gmail.com>
X-Stat-Signature: 7h386paxb5chxy9fzj3xmibjddrymyhu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E757100005
X-HE-Tag: 1791170066-198106
X-HE-Meta: U2FsdGVkX192OyO/+aGMVbE2YW4Rp7Sz04aaTBzIAcYYWOLrzWMi1NqSiQgouCZFGfk5GUOFvRoRV1N1YXOfZHthTRN2mQnf3nberPmZuJM32frgUYIhEbpfXV7gMHBnJCVkM7cZ6CNtRq739wCDqTariz7jNfWe0U9RPTa/7vWItDBEE3SnweHEVxYaYEvFkM+9yxpYv7jGyUlqts8vpEB9ZxaHG08FR6krbsxsZRKqqkdr1yHpkJA7AHNTTXfk2zKOMeRiTexe33m4iJFkiallIfiaxex6bCDeWGQ2bFaDHwaDbDdQzNPJu4Smy/CVvFa9dV5QVQRiPutx2UI772j4oD4xPz6u6PenR18HeE7SAvLAXOXSa30rIQB7MwdcUMfeMNlW6/gDfs688i9sI2YEsNIoeQbQr/gKIvimNO78Nmykd2iD8vjaqCBsPKQaO7eyXQLNNix6XPQlQj68TDKYLmmlN7fvGFQj5dL/M3hsK13zYTJWP6532nXEkZAKA6YTKmJAZCSmp3QX7zg7ivwganQiy7M7XwvdB4K+SOYQunCk5OzsUMcK4cnNpUA/w2WEySlrDakLe49Xe40Bogr9Ur33SjQWW+kqcYHajlfDed/wTa0GX7kX4WHObPwB/TCfN0m/m2F5bLxxOCmMVlLYYPf/yQ9llAUPe+amq5eBECIo7KkN3mSLYVd7qi1S6DWXaPBReGIqgVHvrlftZ1V0l7TDA7L/KlxbjJOGrR13219FYYvhqAzV0g7VAcQiwtPJo0NZVxuH4LVFfxdsacB9scvrNmI3uLWEht51ihrMIFASWA7TncG9+fnHmxuH6D0XcYayZIYrb23IAqWkr8abVahmUg4DBg8ZE5pKt03Ko5itnM4jlnSfK+2qsJxLQNi0ovEMyfLzpY7t9LGS0laADViUfQpHK4tqD5NRuUHprUPubUVEkU1HsO5Ud7a2hjGhuKzM52K9XOb1UOv
 J7GQE64G
 VfvxmJrbYUQRRv9Fus5J4/orvDzjarbj+k72WDosMO5Lq69xSYlRKZO4ia3adTY71yvjF4qoruRbMGdglKrxxCM6iccVmyLbHdeQMUkr1TTndbIXoK7RrxHo43KZ065X7LUDjLD7Ti6OugfRFg+nDIhgXHsWM62/7hnXmR3Cjod/8Zg1xNrIdMMmzyVoiAvgLA+4eZyfZ916YRhboA1EhIAPog7SNf5kjyEUFJKGeAmXz5xBDNr55KcDbPB+1/U+C77IO+uSPnNzerdfpoIVeXBMvQAwbYumGFO9/nIn+Gop3Tn1f5XC6o6i4DRX1xt3sLRjy9tSUFqyaBEpbrYSjt39AePRXVv/aBWJW3Sx7yGIcFC2Y+Ug/4aZ5bYwwFunzC9uADN9C3ucgcBUtxYOXMQESIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 03, 2026 at 01:05:34AM +0900, Sang-Heon Jeon wrote:
> vmf_insert_mixed() just calls __vm_insert_mixed() with the same
> arguments.
> 
> So merge __vm_insert_mixed() into vmf_insert_mixed().
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/memory.c | 12 +++---------
>  1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 6c1d38eba7b2..bde650e207c9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2991,8 +2991,8 @@ static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn)
>  	return false;
>  }
>  
> -static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long pfn)
> +vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> +		unsigned long pfn)
>  {
>  	pgprot_t pgprot = vma->vm_page_prot;
>  	int err;
> @@ -3041,6 +3041,7 @@ static vm_fault_t __vm_insert_mixed(struct vm_area_struct *vma,
>  
>  	return VM_FAULT_NOPAGE;
>  }
> +EXPORT_SYMBOL(vmf_insert_mixed);
>  
>  vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  			bool write)
> @@ -3062,13 +3063,6 @@ vm_fault_t vmf_insert_page_mkwrite(struct vm_fault *vmf, struct page *page,
>  }
>  EXPORT_SYMBOL_GPL(vmf_insert_page_mkwrite);
>  
> -vm_fault_t vmf_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> -		unsigned long pfn)
> -{
> -	return __vm_insert_mixed(vma, addr, pfn);
> -}
> -EXPORT_SYMBOL(vmf_insert_mixed);
> -
>  /*
>   * maps a range of physical memory into the requested pages. the old
>   * mappings are removed. any references to nonexistent pages results
> -- 
> 2.43.0
> 

