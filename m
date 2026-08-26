Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E5FC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D1E6B008A; Wed, 26 Aug 2026 09:36:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E156B0096; Wed, 26 Aug 2026 09:36:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33CDD6B0098; Wed, 26 Aug 2026 09:36:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2496B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:36:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 727B4A038D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:36:51 +0000 (UTC)
X-FDA: 85143521022.03.7383408
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9D7EE1A000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:36:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lb6yp46u;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787751409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iac2l5x1G2euKklhoCcR1PZsgghWHKyc8OBHeXTFnfU=;
	b=OcR92540TtnT+HDmcNOLijQNRT+IGc0qeOfBFreo41dSusFhQ3V/rb+JUO5KB6MuoII6L5
	kczAwhoP95aBzd48SNr02OUdMpnVQLLNItDiZPhQh4Ay/ulPIvKgSzSpJoHp/78vF7iCAs
	r6pK4hRToueKV7wtNezgima2iS1jI98=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787751409;
	b=uE7IfMMaZKO8rEIQ6Xy/sZPFkbS68v1E9jfwt4hziOpuJpvOn2NEVUp2seUXNBG3aoCd5w
	qGBMxUTVVPDd6Cq+Sj884s3fl0cESS/iMmnHg1IzuknWpPLmy+bmwXDJfu1sTcCjyyzMgM
	z7yOPjSd3uDP27oPXnrbLwUnIC8uQa8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lb6yp46u;
	spf=pass (imf19.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47fe2d179e2so508057f8f.1
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787751408; x=1788356208; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iac2l5x1G2euKklhoCcR1PZsgghWHKyc8OBHeXTFnfU=;
        b=Lb6yp46u9fjTZtyz5YvOdflzHEXW9x9hCqLg4oqoU0GQyu43V8Mv+Vf0fvIxo6kGa2
         I+UVgAdGWSbW+/gkkq7tjCPgNTcWS9ovj8NIQvmgbzZSO+d9pt8h4pipwuGMx30skNzd
         zS6NHDZtrM8td9iruDg1etkn95wPgVwx9DzvWpUXI8OePxZeHzxFMutOB74XvdKPJixC
         byoyEaeOQ/DhpdYm6O+UNy0hwj8JYSzHP00dM5ZE0aW03NMpJpzS9h5Oe9Fm6xYppc1Y
         3OsGoL9bwOIXIbKK3AAWUpW+E5hmYSNXZQO2B+1ttz5TLqHwiXeNJ8sqZHWoX8b8PcHv
         VWVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787751408; x=1788356208;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iac2l5x1G2euKklhoCcR1PZsgghWHKyc8OBHeXTFnfU=;
        b=gJzIx6bc1TDFS4mpGoJXIkLM4b4EVE12QCKVwdYJ1ye17CsBwctpVIIMpiiBJ4KVv8
         3cYhwMW9iVpcIBl/oJSLsXr6eKJ5ARoekC1D2wG37ZdOdJUyk/7l4Qm8M8TAbQt9oFTc
         lBjhP3PkxxG+PwCS/5kB5qOktDHAzl3jZthm3irmsRSntwqkPF/s/mkwfxCtqOHYh/BJ
         gDWVioEfp1oKOBwtEbHxPDvnKy4z8Inx9F76HYWNX3pPg4hNWF9MBvb+vCEvENMywsaY
         CdEOul26/nAgwy+V/P2eNRuIUcFuoPC9Kt4IRDuRJ8nBfO5PNUHTWdpVT3YNS/mvcANE
         yrjg==
X-Forwarded-Encrypted: i=1; AHgh+RrlWKwBsrY/63D9NGEHaemumEsjSDjmGyJeZBUX20SrMDnR04YkAKUmJzAwz4SyJ0dvI7YDDv01vg==@kvack.org
X-Gm-Message-State: AFuF++kPcidlpSW5vmmZVvZjm7OCtMI0aWb6kFOkA4U+m0Y8diaPEtyt
	3gMlTfJsiaAqMLoDqUIGS0ECKBDHDeCIu7Yl3TVkL44OVS1kApB/AlNF
X-Gm-Gg: AR+sD11S4LMvDDl1nx2qx+QjSdbYaSfWOUnTrj6Iy+c7lDgG8eDt+1jfogFeo4+EFBm
	zATvtUjUzVLqQ+p3kiX6DvQZerOGa9hSgMR5J5ytjL2v3PAkiHicExD19JHtRx78hHa+qZDdpmN
	s6oGs6gib/tSVoPEMolMjso76TJq7EjEZbYMCpiRqUzK2oybIK/vxVMkQ8SXYqmF/Y4F0i7tVXj
	Zgi3YZkJJXr7sU8bTfdXTndrOGpeq505qcwYFb0XcQuSGTlNNOgsO7tUGvS3AIkpoXFYGcjhjCQ
	ksfWSDEiZuSFrKcmbcmyFm6aWpp9dPUu+CVXYp2LbYH0XfgNzINHOiT+uBAPAYJsG6FD5HIq2M0
	sKY1sPmU3NoIh2ir5cTKRXtW/uWeu17cjDRuqGq4s4SJTbxaTB2oPeDCZe2NTfj7qBrHyRnDOpd
	/1CExzxqEFn4E6F2TEUIamnD3k6l829oXcS4Roj0MIGadPjpn8Wo7SzNxkzi8Bp06Bi1h12LkAu
	RUTPRSvaGMOU1xRmbNadzeLxw==
X-Received: by 2002:a05:600c:a0d:b0:499:bdf1:7578 with SMTP id 5b1f17b1804b1-499dc6e9b00mr69476415e9.3.1787751407615;
        Wed, 26 Aug 2026 06:36:47 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499dcad0cbasm26303825e9.10.2026.08.26.06.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 06:36:47 -0700 (PDT)
Date: Wed, 26 Aug 2026 14:36:44 +0100
From: David Laight <david.laight.linux@gmail.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, Alan Stern <stern@rowland.harvard.edu>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 syzbot+805630f1453e490427fa@syzkaller.appspotmail.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: reject unsupported kmalloc sizes
Message-ID: <20260826143644.5b3de07a@pumpkin>
In-Reply-To: <82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
References: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
	<82f138f5-11d4-4839-94a3-c226fd982715@kernel.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9D7EE1A000D
X-Stat-Signature: rkt93ezzz1453rrr5k5y5fp6femiqq5p
X-HE-Tag: 1787751409-601842
X-HE-Meta: U2FsdGVkX1+AsQpQLo4A42TDuplZBk/wEXtS4uWn27COw+ZqDQ+o5z8crjiw3qb4nDRm2Oq67t4STzFRE6WSCaKZx4MZkA2Oelw/dJZdOQeYrcFA79k5EIidQUbGJYg0y4MDnjnXLF5bUyCKJawb5JVFRxXhQEC+QBeIY5IVo4gXifmS6RxJYeUtAaaInZL+CwqRM5RQztvUvSskd4KDXNOP0KAQkEsXyP0SKYSiAAvu3oIdkX+gsr2JWbAmkS1VVqcpTozsGLSUMAofpo4ch75kb0lz5Rid5gFVDWEWiWmYbgTm+U8ovfzyJ77EOjg/XZ7sbH6T7DpTt5oG4u7WIMeTOP8diUAvV0wzGQQR9cO0+cc3I0xf2TFy9UzC/82Kx7paKut+E+kUvwJdzTmsfc6ACAyf9xhi0machMxRQc8wmoKzgTO+dBfxkIX5VkHj6Nx9QyjX3id6dx8a6GZBr8ePlyNYs3F7eNv3nr0JjIh3WNHVTeap6n8qC3jDkwwFnwW3NYn3Tjbfsd/gdVYNhMLBJnwtsIkQI9qMy27GlOEHjSBIPEevyRAvoJqrsYtp20vH0zmuLgKPZrLSLMsqKs3FxyKnXVdyVp65i+V9km/Hx6eRC40zPDvMcrCn5unUd4as/1tddla6AkeQPI5c4DevhgBAtHN8WpLP2XwIf3krCFYktXy07uFgCUWwskkpwzlg4yr4W4d70xl0/Ctos9tg6lmCCPrJ4gM0RoHmCXXifGQnnnNqcRYVnZpqsykfe7XBrZjkSwLy9RDXTGXM9IDFqfhcHTpjRXXlomd+NH//GUAVmf0sJ+R+uohazIyY1yhPG2zi8QTcXvwCvkC+1wGyl8LEfpSWSaApXKXcFpacn1W5EapXtyjkmX53YZR/iNqdTS0EQ6GcReS7zDbmo0as0tad/wOetJmBXWeHrnaAinHSUesEUVASo8xYqZtfovdmoQhKQmXZn2guABk
 6jXSkADo
 KxsKmSugdoQfbBW43nulZC7ymeUb7Xr3Qj2c/E9OM7qek6ODx8tyAD9Mbv+PNFlgzGcB9mxogmlculiWrQOMuE1pgXk5+OEfxcH+35MYhtZ2wAEc+hRhit7CBJEJ84KKHLIbhueTgfgcE+annBD1B+JAtNKbnPYnPFSm+2EL38TLx25f3IRS0xoYcnFpp3pufG8WhMf24M9cKws8AYpy/ZWxQ6r1S//CQjk0FR2sP7imwV7RsLd5JaVPX8rqbgZVVyGIHF+Zr0bIVYiGQ+FwhimwSZNblGfeQX12ve9RdkzLI0djgs0gDh50AXxXgNtRkWH5Fa1gkKapTy7k9bQjXiaTI91A9ryQcOV3kO3coYf4iFGiG30k7ZPBSwWI5w45Xmp+Xg6ZejeDBMYZPEPT9SdiHFmFzRkdeTF9LpZtTcQvM08LcHqr7/kztlGXY6m4zSNcP22BV+sONVwktum1EykppXUhIgWKQowB72a+0fJy4g8NR2ei7dUfJcpVOl6ekskbHEC6pOP0nfOR/Vf+Wv6klTqi/UhlCOAe8YaV0QFCIcf/ZBXRSeRy6ybxKx/Ta2qw375woZ3tpWhcFyY3raOxQIxaZYSpxHyGDHyuG3+YCIVvGX+MioO6Fp7ygfxggTivcqOvXlvRI3924lNQUd+FlWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 11:28:12 +0200
"Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> On 8/17/26 22:40, Zi Yan wrote:
> > kmalloc is used to allocate physically contiguous memory for kernel
> > allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
> > the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
> > sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
> > because kmalloc allocates an order greater than MAX_PAGE_ORDER. Systems
> > with panic_on_warn=1 crash because of this WARN. Fix it by rejecting any
> > kmalloc size bigger than KMALLOC_MAX_SIZE.
> > 
> > Fixes: aadb4bc4a1f9 ("SLUB: direct pass through of page size or higher kmalloc requests")
> > Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
> > Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> > Signed-off-by: Zi Yan <ziy@nvidia.com>
> > Cc: stable@vger.kernel.org
> > ---
> > It fixes a page allocator warning (order > MAX_PAGE_ORDER) when gadgetfs
> > requests excessively large memory from kmalloc. Instead of adding
> > __GFP_NOWARN to suppress the warning, as was done for usbfs[1], change
> > kmalloc to return NULL without a warning for this specific issue.
> > 
> > [1] commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively large memory allocations")  
> 
> So I checked and for kvmalloc() we have in __kvmalloc_node_noprof()
> 
>         /* Don't even allow crazy sizes */
>         if (unlikely(size > INT_MAX)) {
>                 WARN_ON_ONCE(!(flags & __GFP_NOWARN));
>                 return NULL;
>         }
> 
> This comes from Linus in commit 7661809d493b4. I'd do the same thing here
> then. Thus there would be a useful warning for e.g. development mistakes
> resulting in the size to be unexpectedly high.
> 
> Callers passing size that comes from userspace or similar untrusted source
> can either pass __GFP_NOWARN or sanitize the size to what they expect to be
> sane (which is context dependent and I assume actually way lower than
> kmalloc limits in practice). Note that passing even sizes within but close
> to/at the limit, trusting blindly some external source, can succeed the
> allocations but effectively DoS the system with heavy reclaim/compaction. So
> caller sanitization should still be preferred IMHO.

Indeed, and sanitising the values early on saves all the size_add() and
size_mult() operations (that are just saturating maths) but still let
through the 'DoS the system' sizes.
Mostly the actual maximum size is actually small. I suspect limits like
64k, 1M or 16M would be appropriate.

David

> Some of the recent
> arguments from Linus [1] would apply to this too, I think.
> 
> [1]
> https://lore.kernel.org/all/CAHk-=wiSmgwwLKCqJwGS-dVHnSLU8W+7q1UQq-G9=TBGGZbuhQ@mail.gmail.com/
> 
> > ---
> >  mm/slub.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/slub.c b/mm/slub.c
> > index 0337e60db5ace..a3071f4ef1945 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5263,7 +5263,12 @@ static void *___kmalloc_large_node(size_t size, gfp_t flags, int node)
> >  {
> >  	struct page *page;
> >  	void *ptr = NULL;
> > -	unsigned int order = get_order(size);
> > +	unsigned int order;
> > +
> > +	if (size > KMALLOC_MAX_SIZE)
> > +		return NULL;
> > +
> > +	order = get_order(size);
> >  
> >  	if (unlikely(flags & GFP_SLAB_BUG_MASK))
> >  		flags = kmalloc_fix_flags(flags);
> > 
> > ---
> > base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> > change-id: 20260817-limit_kmalloc_size-3a4a2c73beac
> > 
> > Best regards,
> > --  
> > Yan, Zi
> >   
> 
> 


