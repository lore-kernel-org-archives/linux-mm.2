Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DAA2CD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 12:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47236B00AC; Sun, 14 Jun 2026 08:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E186B00AE; Sun, 14 Jun 2026 08:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C34AE6B00AF; Sun, 14 Jun 2026 08:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B28AA6B00AC
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:02:45 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58AFBA06A3
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:45 +0000 (UTC)
X-FDA: 84878381490.11.E8AD092
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9E1FF140013
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 12:02:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jb7lERXF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781438563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gl5ds15gT9RFvuhue7k9Gt63HWYs40W/pdel7lx10/0=;
	b=XmQ8pxfTvoBwyTTwD7XhnW/1l6AjpwNI7fuLi1QKeNElr5imZTGiWkJddNzFOcudk0xXhr
	rg7CgVcPXeZBUCa0IgY++ut1hJhFRA5YjdxilI6sXzFaFTi7R0sEm6orsQAdEsdZtreQTh
	TlUufUIBqQx0rKUpwnj3d6ay6fy9H5g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jb7lERXF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781438563;
	b=5H6UCT/d3BOOtHiWsrhJ3utlJ44OBdRaNG2SvPvgL+vTaxcI2WeNz+1IPmtXlYTjC0IjY2
	N8HzakHcirgrEpUVt0bvMamUbygfiOljKSrMvSAbz7Yh1Z51ndwCKlug6mVunysTNgIBHp
	3YTwXqyAqd3OUV+z8FNJqJIpJAhOiJ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 84E7E44320;
	Sun, 14 Jun 2026 12:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FFAC1F00A3A;
	Sun, 14 Jun 2026 12:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781438562;
	bh=gl5ds15gT9RFvuhue7k9Gt63HWYs40W/pdel7lx10/0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=jb7lERXFQWPWiFKuoEQWK3dwXE0EVHY9MLhD7x4o1f+V+UgQPXoyycKGHV1lyiH3X
	 5kCaenQFiSnCnQKkTRRg015XK4h/QSIKlHIOnjggvI7YqPrT3e1pGOvTC5V3Ec7XhU
	 J6hI0C2BykWEFcHz7F53lNyB8aUwmfdhoWTUdCrr1Obrr2Iz44zqK3zHVIlhkLhKjq
	 5GfUW4VrR1zBxor97aep4DY8KQPwALzNE82T95aztQVjMrk0DqKGwO+pX7l56neOb7
	 yq/0WCgsVD0Ornp5y0xZ7wNGPc49jLZ/h22naKyKkGAX6nb/Iah7HSBVcQwQllO4xM
	 q0tqSF2rSyLpw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 03/18] kho: return virtual address of mem_map
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Alexander Graf <graf@amazon.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Jason Miu <jasonmiu@google.com>, 
 Jork Loeser <jloeser@linux.microsoft.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260605183501.3884950-4-pratyush@kernel.org>
References: <20260605183501.3884950-1-pratyush@kernel.org>
 <20260605183501.3884950-4-pratyush@kernel.org>
Date: Sun, 14 Jun 2026 15:02:31 +0300
Message-Id: <178143855111.2123877.6067087545413454825.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 9E1FF140013
X-Rspam-User: 
X-Stat-Signature: oap7wr93quequc7rdwnwkr71ee4wmxc3
X-Rspamd-Server: rspam09
X-HE-Tag: 1781438563-295150
X-HE-Meta: U2FsdGVkX1/ShGrpkCM0eT1K3U9BOJxhsbQCGrx6Cc3VaBODQpBKSjj63wRLF2p87g0WZWHWcp9m0MrIqOdmFfOnWDTcKjwLW3q+R4k7C/VxG7tRQzPkBbpixKvrQrj4qilSpj4b/FzrKwUHjeIAGMiSm71gcUJb40qXrhk6E8CuCQoOFfFyEZXu0v9fRrVovM4BXQv89AgrldmFknxGvpmZP7OlXjRO1pWGqxVw27tmMlWepTCK3d6SUw4czyTXhMPkpYUONgJ7JNl/otiDRckZwLjFt5a56c5q6GDZ6KYWdhqG1WI3e0/uXO+wKer82oo4EGYoWZx0mzjM3wPu0uFPMY0AljnBHcDA9KJE8X/CPXh+HWW2LWtTHyzHTJD24KNFFBIVviKot7+CNeJGvvo159e5Y7n1+kVPSZUU4OI5bhz8HcVIZho8bbyJ3bForFyfLoTmK50w6F1cz53KOhK+aLPSWOyoB0gqH2szS1g5+EhSRwRRQxFZ/sdqr0Zgbs722i/S/yy+Z+zecBhvepSzZjp3fMS4tZNxi3L4HournyKFH2dSHUn3CdMs668Fm5NbVPGzTedO6Yh0Kl0T/4BbSylHk5p3k+W/v4h1XkvH+k0jrvnZpIJMDKO2AFgMAPQsaFRnYNuJpsSNtqaYUqM+0UJvKf6oSZI5128atDp9p7L9VEOj1Kat3kft4wySuhBLwD3Vr+lbC1lCSWd9IyuKCtXr6aUb/TrTg0kmSMB8/GRObwRADYmXc6wRRosa0GH0BVsJGcaeMjzVc+X/eQTFaHznN4Vep/GXpKsU5D6H2iL1JC/DYkxicF32PTMYqtPFV9ZdF5dJXNdxZDb2CYR+v+rHXLcgf0HDc7JBV3x8M5eINti/T4PJMBBY4QhiPMgoexkLUIbMbAzGLEwSp2oTuOsi4KUjhrXpfg5+RlkIcACoBXJ6IA5eJ2Rtfiq30SCPFsfZ2IpeBJ3Z9xb
 lZ9ofAGS
 65XCfdWZL5tObeW8bCp37RmGN/6uzajetotT3YQtLEbBkNPvYJK7+pG/+Y1BpvOIN7ghEtigRUCsbRvXmpZWIU/UkU1xxSRSrY2mW4cJkNgWSH5N91IB58OsKglVGhY60DujORyR+ZB5qTvnEt1MHhdE68bTjgHMddk/Fmbt4kcIa9xJmHtNmnAnBb4y+b1qj7F9lSEp2PpxHsnbDse6vjhNZZRFgeAqMSd+gOVecS9bSRljRUPcuh5zUpyF6q9dLAYUt4IR6YTnp0C2SQoAa5ImP2nF4MGdVF/Jj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 05 Jun 2026 20:34:36 +0200, Pratyush Yadav <pratyush@kernel.org> wrote:
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index e8454dc5b489..d8dd0ede4f87 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -521,7 +522,11 @@ static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
>  		return 0;

sashiko:

  Does this error path need to be updated to return NULL?
  Since the function signature was changed to return a void pointer
  instead of phys_addr_t, returning a plain integer 0 instead of NULL
  might trigger static analysis warnings.

> @@ -1668,8 +1672,8 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  		goto unmap_fdt;
>  	}
>  
> -	mem_map_phys = kho_get_mem_map_phys(fdt);
> -	if (!mem_map_phys)
> +	mem_map = kho_get_mem_map(fdt);
> +	if (!mem_map)

Here we can't use mem_map as an actual pointer because phys_to_virt()
returns pre-KASLR addres.

Since we only call get_mem_map() here to verify that it's available in
the FDT and don't care about the actual virtual address, let's add a
comment about that, drop the mem_map varialble and directly check

	if (!kho_get_mem_map_phys())

-- 
Sincerely yours,
Mike.


