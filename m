Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE075CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 03:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4359A8E00B1; Mon, 13 Oct 2025 23:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BF698E0007; Mon, 13 Oct 2025 23:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AE9F8E00B1; Mon, 13 Oct 2025 23:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1647E8E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:59:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDE301A06C7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:59:01 +0000 (UTC)
X-FDA: 83995364082.30.4E54367
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id CE103C0009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:58:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f63PKYP6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760414339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIZEfbziMhDeXPLAiUOw0zvjCU/6+aE66j2icymvwcI=;
	b=YqFplZy7eu1YRf8YaO04ikwhH/wA44VrOpvvNRfUSSNZAUslGgCQ89g16WJA+LnTnMaxD2
	5+Etn7MTy8hscK/0HQej3L2EmBhlwOIKjlYNU5QwD2tN97f/WklxQLbHaUeDY3CnECeb4T
	i9r1LHzrid5v6H5otvK/ABNbdlI3jrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760414339; a=rsa-sha256;
	cv=none;
	b=yaBkkxw3CE9ksPypmxEYvwXqypDQU9UvcZ++IozHZuuSiODCl27LqwQPBvOtqwsT4VzsXE
	nBklevdRSNcnZM0HOTOjPnSItym0frN5yMNhJgcabLkk/a8G885WrPTEbPHKS90JpTIpSs
	BHgTpQRDl/fklRm1AytB6TV1/IyY+qo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=f63PKYP6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b553412a19bso3015781a12.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760414339; x=1761019139; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KIZEfbziMhDeXPLAiUOw0zvjCU/6+aE66j2icymvwcI=;
        b=f63PKYP6FOQjqPou6sRcWtBlH3OT2MLFPdiS7FhZdOf6G71DAJpfsf2Ekv2b9xG5iq
         JivCnhXrBzg6WRApU4E+kz1NB2KHLoD77WVqETZVPvBv5k3hO+4IH1JPsilA24YkOdYE
         NJumMc2NmXRtCP7vIcZalbERrPjIL3x5HU8lD1F4gh1WYOMnmo/+V9izct9cV1gV93hR
         Vwn3H1efJrsGS/F5vNp9jZcWZYvBrDyB5G/2VWTfkXYRUF4dT3X+nyibA1mqFkGsGF3B
         PaN7OBUAOIkJA5GDrqWn7WvidZ/ALT5n38NEiahdZkAE7/X/rV4QE1QIq8K+5mNVuY4w
         uLbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760414339; x=1761019139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KIZEfbziMhDeXPLAiUOw0zvjCU/6+aE66j2icymvwcI=;
        b=rCqIKAiKyVrjOg/zrMfXfxe8gdjrW+9H3cJPfeKaDvq76ifMNqna/0AJ2cUKimGVW3
         RYntQzGXB+rXuy83UByryB/aUzKH8EXPJGmOZ+nTR2K6yhlJsA/Zkp0x5hMMMZo2TSMh
         OJiKXbqP9TanX4xYoTvrL2lGzH7azuLkvY3C6X2u4jcpI7ul7F6K0Irrv9jsf9amwCMp
         /L1LBR8WHn5WJ6iKZWV8Hqzsg0jRbCICNfmpLayCt3EMHqnDS0K+/loiyjW26K1T8Td3
         Q9Ir33ZzTlQ7abMqfGfrO6XIUqfwXRm7BXU+iIpXjM7UGKNERy0LQkT85LdMv350n/JZ
         5o5g==
X-Forwarded-Encrypted: i=1; AJvYcCXpsRUmuExE9cEG2PTrP/rfSfN2ANut/EJ2yPgJIUGZJAn3wSk0CnBT2uJAffATOYbKkWughV+35A==@kvack.org
X-Gm-Message-State: AOJu0Yz77rERdO+CjSVwR8j9N+cI66T8SbBHjrFVhfNZzZ3xa+QRHREJ
	01X+WSRYArnMIxyv31RNVbnmq7O02IKnC/BCqLIksWuIZgGYGaOjvb2b
X-Gm-Gg: ASbGncvO7hVCwOlANmjaTeWcP71J7qsUkmUq0dQ2IhmHybIynQh/IjaHZNFM1s4+b+U
	8+kZDcfgZg+b7gK/6WgA9xkAoBoOGWyWmQG+QgAK8zYbv5202UDzLf3jUd32Kxie9jmtucPafz3
	B+ok/sYJ/L97u2Zw+jC+Uoytu3EG3NpDhHeL193VdVknKCo/p6Ibo2+igfn+uGNUpis0UYtYxAr
	O7BV6CJnYWI4JR3CUfARYvFRE5QICCUSKSIhgC0RgaIYDIYfXzjHrfAL26d0YCRLrIGl1gEI9z3
	oQTpeaEaO0GTdgdjA5krDowdzzyCAFYlTIM5P3m5JQpgKbSK4tMMfGmxhpG5j6Y+3aQN13sH5Dg
	WcfO0dG7W/foAJjZQ1WgFXnIzq2ZNeFJrQO2LbCz/547kEGfPAHmhlDOarmgFvGVfEa1RrOlAq2
	3wmczx5tjv
X-Google-Smtp-Source: AGHT+IGL3EC7uzisf8wnwsneVP9C7iO5pEmo4F4CA0O58hvdMK9aZKrTbYI/GrA5pn66KoRLAHTokA==
X-Received: by 2002:a17:902:f641:b0:27e:edd9:576e with SMTP id d9443c01a7336-290273ef199mr269866415ad.30.1760414338517;
        Mon, 13 Oct 2025 20:58:58 -0700 (PDT)
Received: from Barrys-MBP.hub ([47.72.128.212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f95ecbsm144418965ad.130.2025.10.13.20.58.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 20:58:57 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: edumazet@google.com
Cc: 21cnbao@gmail.com,
	corbet@lwn.net,
	davem@davemloft.net,
	hannes@cmpxchg.org,
	horms@kernel.org,
	jackmanb@google.com,
	kuba@kernel.org,
	kuniyu@google.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linyunsheng@huawei.com,
	mhocko@suse.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	surenb@google.com,
	v-songbaohua@oppo.com,
	vbabka@suse.cz,
	willemb@google.com,
	zhouhuacai@oppo.com,
	ziy@nvidia.com
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
Date: Tue, 14 Oct 2025 11:58:46 +0800
Message-Id: <20251014035846.1519-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
References: <CANn89i+wikOQQrGFXu=L3nKPG62rsBmWer5WpLg5wmBN+RdMqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE103C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: m199pm7gkiffdf7gpxxbcy5t74w55er6
X-HE-Tag: 1760414339-189023
X-HE-Meta: U2FsdGVkX1/Jws2viioZVMb70Serk2A6N0NBZXS/r/M7GuvHKU9K4CV9pyDWrEcplC8Jx0kvt3uv0+SjY5lczlkAMK3EGWPwhBfqLI2eSXusC9X4Snm3mB3mLzQdQlSpPQ5NPLf/Qr4a0JsA2Rs9HXwoN+ceNQbljEv+cf6VCNP27jASAQ8yYYbGBZKkJ/pMglIahws1pBNTVJ+vd5cQ3+acmqSqEXDUIk9J7VhtRL/VUJ4OM2OzBKMwEBcLhmI10i+aG2hxXnufWVaNt5Eb2TCCFk60gTwJuz0jKRlbg7bYsGiOGMxRrC+hFFvTz91Qr4/tB+O2CQLI45uYDtNxgHy8t8OLNa7oDlMbb0rHZDIjtx8GeIzXjsGzPtffgq8LaLu0Fzt53g6Bf8jtdSW0aJDt+9kcS4pbN4Fff0FLFbjKmVzLgf61xcoTVesKfOvhWDWqOXZjLn3WqrxFljNxD4yw6sXbEzYTgvOWi/4gqdImfzav48SblbeARHaFtmbsN6odkqDvlWUVaOV1kPzInafCA1ickOwbNuxbDyhf1a2HsX0iAwdiVkTPC8SZfb+lVUV+7z3sbpebVI4YD10WVW9NOBp1U3p5YJyLPDIHwAhN5xzv9n7Ei+anRHiRMcEhpapfG1eEfalLWYmA/wTlA2hOVL/T2c+AwiPJvjMm1D0W0YwakqWINn/tIAZGlzBCVSk/egM4umOQs7zzOsQidS4BY1Gjva307c4BrPyEbhIGInBe5UDU/Ey57fF/yDI1WVC0q+AGNeWRlPEqzXHcQIhV46AyUSwxBb4kT8TXmneJuNxNoMsxKEC6Wl/y4bLoMUrXLyMb3/fdfjXw3LYZA+dMrKK/h7EXJQsf0COD7+BEyHd25H01Y34CPFeNwQ5BBQt03cYaubAw97DOaN1T2fr236eS/H+85092C+7xsA6fAaPuHBC+WTEWX+zS/vaIhTGvHySr7PTFVbveRxy
 ZW4Syz8C
 /3fa+vYm8XAGTxpFlsGC2nEHgwbfFcLzOtL2YSUdVukUJOqdKOGvhKJai2gpx+Qpb2yzkBT15Amb75iSpOIn+IX5UZXLA0BQbw09NWSyizLOh/Umhn8XJiAR/qZfAHeW0xPX78DeTlJo8QfPpSJkZK4L1c+4nrwQL200JK7fCPpm8DlU+taKWftoycPPWRJUoYgXGwQZg6cvwKzKauC7rxBoQJdWAAxWxsW3VF2a5Mh8/oXg/8hHzbm4yFQdjL83GxD5FNRS5unO8YL6kbsq0IC6s4FITHqJzh/is6Eztx8mZIyicLClcds+YkCCV18ZcUG6Nf4UD9dr+X57zBxXTiE9xZBBbnhwef0hHCQw4cIuigQHazY9yGEx/VWME1pIiANR5M06xp75quaagmrlPzmw3DnhM97EM3B4vqK0hgM4XkYc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> > index 2ef50828aff1..b903bbae239c 100644
> > --- a/Documentation/admin-guide/sysctl/net.rst
> > +++ b/Documentation/admin-guide/sysctl/net.rst
> > @@ -415,18 +415,6 @@ GRO has decided not to coalesce, it is placed on a per-NAPI list. This
> >  list is then passed to the stack when the number of segments reaches the
> >  gro_normal_batch limit.
> >
> > -high_order_alloc_disable
> > -------------------------
> > -
> > -By default the allocator for page frags tries to use high order pages (order-3
> > -on x86). While the default behavior gives good results in most cases, some users
> > -might have hit a contention in page allocations/freeing. This was especially
> > -true on older kernels (< 5.14) when high-order pages were not stored on per-cpu
> > -lists. This allows to opt-in for order-0 allocation instead but is now mostly of
> > -historical importance.
> > -
>
> The sysctl is quite useful for testing purposes, say on a freshly
> booted host, with plenty of free memory.
>
> Also, having order-3 pages if possible is quite important for IOMM use cases.
>
> Perhaps kswapd should have some kind of heuristic to not start if a
> recent run has already happened.

I don’t understand why it shouldn’t start when users continuously request
order-3 allocations and ask kswapd to prepare order-3 memory — it doesn’t
make sense logically to skip it just because earlier requests were already
satisfied.

>
> I am guessing phones do not need to send 1.6 Tbit per second on
> network devices (yet),
> an option  could be to disable it in your boot scripts.

A problem with the existing sysctl is that it only covers the TX path;
for the RX path, we also observe that kswapd consumes significant power.
I could add the patch below to make it support the RX path, but it feels
like a bit of a layer violation, since the RX path code resides in mm
and is intended to serve generic users rather than networking, even
though the current callers are primarily network-related.

diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index d2423f30577e..8ad18ec49f39 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/page_frag_cache.h>
+#include <net/sock.h>
 #include "internal.h"
 
 static unsigned long encoded_page_create(struct page *page, unsigned int order,
@@ -54,10 +55,12 @@ static struct page *__page_frag_cache_refill(struct page_frag_cache *nc,
        gfp_t gfp = gfp_mask;
 
 #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
-       gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
-                  __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
-       page = __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
-                            numa_mem_id(), NULL);
+       if (!static_branch_unlikely(&net_high_order_alloc_disable_key)) {
+               gfp_mask = (gfp_mask & ~__GFP_DIRECT_RECLAIM) |  __GFP_COMP |
+                       __GFP_NOWARN | __GFP_NORETRY | __GFP_NOMEMALLOC;
+               page = __alloc_pages(gfp_mask, PAGE_FRAG_CACHE_MAX_ORDER,
+                               numa_mem_id(), NULL);
+       }
 #endif
        if (unlikely(!page)) {


Do you have a better idea on how to make the sysctl also cover the RX path?

Thanks
Barry


