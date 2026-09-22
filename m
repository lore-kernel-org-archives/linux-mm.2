Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65AFC982FF
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEA696B009E; Tue, 22 Sep 2026 08:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9ABE6B009F; Tue, 22 Sep 2026 08:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B89DA6B00A0; Tue, 22 Sep 2026 08:13:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B16B6B009E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:13:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 18AA41A0433
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:13:53 +0000 (UTC)
X-FDA: 85241289546.29.FE25FDB
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3C4D4C000A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:13:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDMOk4rW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790079231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjbpV8gXw6DnzPOP9Yav5BVijNjxxO/HGQyrKRqAqnI=;
	b=GSb1ny43SlJi5RHQEmrsWt1EVs22sGCVY40zoGq2uqj6xraFfTV+6pmEFTweYZjCXzNvxN
	7Oux6Fhm0NovG0pzWzaSOvY2oku8nV5Oai6U6grg9nYClW9b8cN3WHKQd1BMIh2D6n60JT
	Izv2IzGleWezLBiKQafx84NbiPQqQ0c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FDMOk4rW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790079231;
	b=chv4S/DzGd9jU+aliBzMS07XW9hy6Q3iT582EBy4iEeE7LzNrALO+wPCFMhHd7HVH9qOcq
	9HSItBJzwg2YRrbTa9rEm07Fm68t6FzbA0+yhOspYB3skPhsHxrjt3RDdOZGu1y0C93M26
	Wwb8qOgfvaEYp7SHYpenTHOc9ZE4oe4=
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a60591ae52so6440934a12.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790079229; x=1790684029; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OjbpV8gXw6DnzPOP9Yav5BVijNjxxO/HGQyrKRqAqnI=;
        b=FDMOk4rWLgM9VtmJYxdOsHGpmwH7ww3LIRqENBlSuA4ULelUvv3IR3iVPFzjW1SPAD
         kNVQOs+StuGFHwgdqDnRKlBiu4V4xSuUW17+eicBbNg8MpiiyEhfW//5y+LRX4SX7QWb
         tMZbB93S+b41VuMPL2DkxBF8V9+im42AFBho+i5/SrG8Czjy1zcIrjCPGqMuo9eiFYMp
         jXjtCmk7Sbcp5wrbdZtxivKKzwh7tqlmY0qCZWTylVW6nir9kP9cljOGSFauKy4lr4eT
         kXxrwn5G5lZ/B8WXPyWy0iQmqtB9LwVaWpSvhbOebu6cWd7HTMQCefBF0fz01ST5vmg+
         OWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790079229; x=1790684029;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OjbpV8gXw6DnzPOP9Yav5BVijNjxxO/HGQyrKRqAqnI=;
        b=kNugkY4yy2+RasLdlD6YVRG2pQV8L++rAdzFZZX0pkILYhw7Uw1/LfXmIQC1nQad4q
         B+EeyQyiXji4WLoLm56xjkGsMrK97I1kPkvhXsJmJLZ9bidzquEg716qQO8kWHO+y98F
         v+MTJfWEDl4IS+fh4ep3Buq1U2E3faiJQhmsW2ysEZKfv7YEWNjHP8TamUOczEFQp10d
         cOcyzO/Rz6ZYtNQP38WnMu4qFmyKHY5Sf0/R8UJ08yO3DH+Ky67/PoIe/vjtbNkkcmBS
         g65wjxRT3qVKBhrPyn/RHcWhWHkVgQoLuS5v5bHmOojOI7q/YD3ronVxOLOHln2M8P1q
         HsEg==
X-Forwarded-Encrypted: i=1; AKwUvBwfe13s3w+dOxip6xOmzpB9yf8RQvoIndxw7SI/ab5LJ1SS2xO8Bu8F+YdZTn310b6LDUAAd/CHVA==@kvack.org
X-Gm-Message-State: AFuF++nvh9kRU9MX4gD9kR0rUFdDzvBQRZfzeC+hmaK9A2a0d57145dp
	b2LrI2vg+UqyExgC9QKpPcA3Xs+OJrfW5F8fJIrX8i7BnP1U/yDrvbA9
X-Gm-Gg: AYBFou0WSOYywA7a9L//ukNqX5+roscHyfRPuE8I2TFLgynn+P85d004tLhJzpvVAHO
	Zh+D1g1ztE3V5im/qeFwz6Xe43MSiPUckbxeKS8zVTGxHotC/y138laY7IfY2PDil1UAh2syNoj
	BqJNrB9acOzqcHd56HGtFTvnqTomaA/bKvW3ZXT0w4ZGE16dL336lp69N+RaRmSlLGXm4vCf2ib
	2Wfc7PmIjvL8p7paN2laYYr1xpoZR4Qezva7MYq8Hwx/h2iw6FuYuLtjI6ZnNOonlUJnmYvbwk1
	uI8NVsBtXCs/BpkOKxIMTmWugNnW8RjFDAG59hrmK/qOx3MzG3dnTn1S1J6BBWxx+h5T0qZa89t
	7m7PO4XFsbbM21+McnBbnJWowmZRoIW8k7hiQ+x4yd/jk8r0/Dwjiix2PJ2c/dAlvi3uzdFX60p
	xpl1f/sMhuqG+yJeibkyeyretZ+5CDJ3bxePX7
X-Received: by 2002:a05:6402:249a:b0:6aa:734a:a08f with SMTP id 4fb4d7f45d1cf-6aa734aa2b2mr8449809a12.38.1790079228363;
        Tue, 22 Sep 2026 05:13:48 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaa44e6abdsm917994a12.13.2026.09.22.05.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 05:13:47 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Tue, 22 Sep 2026 14:13:45 +0200
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH v2 3/3] mm/vmalloc: skip vmalloc_dump_obj for non-vmalloc
 addresses
Message-ID: <arJw-VKQNxWA0RSc@milan>
References: <20260921-vmalloc_dump_obj-v2-0-73fceb3ed1c8@linux.dev>
 <20260921-vmalloc_dump_obj-v2-3-73fceb3ed1c8@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921-vmalloc_dump_obj-v2-3-73fceb3ed1c8@linux.dev>
X-Rspam-User: 
X-Stat-Signature: 6hjjmn6tofz1dw7hk7gsp1abtyh9pmi6
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3C4D4C000A
X-HE-Tag: 1790079231-978491
X-HE-Meta: U2FsdGVkX19ZENIiK4dmNhhQEv5hwrKEwvXhEZXUwmiYnmL0GgczY1CX27msaUMa6qz7YU01XzIaFW/iQ5PVn5gfUtmNrSsxnr0YswVNcHg2mwe6njZOG09l10mrfwRBNp+klhobB13nh/cVztI/7XgNk5JnOV86HEYpvjRp4DsJXje6XKX8tDMOprE3ljRtAebzWyGwC5XBkdlM4GxMv3J0RpLZr0Wvi/SVougEZhUMUkqi6v0zLH+nyiPHK6hZLqr2xKGPvKEfGOvADMIJokCZuMb54Zv/wf0DCZr+rK0aw5AzD2ZUYqdIipirG4GBK4BzPyWBZmu+lm2QwSeheK/kbvqhyruLFUpHUwb2lnb3NGnefpVVERxL/21I2W+Vdvm80tGgMxBcMWBoB2kiJtD8+f6Dovjx2BMRy9AOeFIvDw4GGSAFpBLN17s0hBiDSp8Zu9ZNoZfRuScfTdiKcVjgB2dC2oUc+JASDiNmXKkl5Fg4PPuCH85eC5gNzgioyzPpZyBmrBArjHp0xQ3GnUP8Im4Q/yQM2KCxZD7TtsfIvTthGkqVpGbVmYau3V7X0HMDRfq20ikR8vlWrAaNykVc4+JwZPYbH6aKnAOeqdKb3/zY/BzwB5QIM/wkUpYK4Dx9tffdQEYwpS1f99qjxBamJ0Qc0yXORAZgm7M+k0YS4MWScD5iiTrNIPdMHfvDOuQWBeBJjZCEXuVU9XZUPPPqGt3BpLVC/5cXsrPA8MvCy+yGGzKjsY3TCmeRAYcfVW4zv4YvGKUUvnEe66oF8G/6Yq7b24a2fC2Su2LLXwBUyyG/9rQE36q5sWTB2EpKm/JjlotRm15T3/zkmYnUcITz+Yie3HTHXhQIloJRU0LIBYE0nMTW6+ZQb2iF3bDfQq16NT88ZuNiP428/borVCvQk4X2EvX/wk2+DdUgbtXG06dr8gTpvRPizvdRxu7W/gF65jziOPYoIlGCl1+
 l8vJOY/3
 glEpJ2wAIfmggguhPSZDW90WWH2k9iAqqp1+1UegOgqoQY9k4Ub1m7h/qPKr2OmJMcX3jZAIzFGLo1Uusx0LKjGbjEFeQDRaGONmgPPaop04g92rrVi8sbAoK3NYTG/O0VmJjj0jigUmHheek6s9+zGOhq3GrQVLTJjAFByHUc5OQyIZtCtnRJesW2tzlccqrmbzlH200N9DrW22V3CV3eQu+F1m+AsJqcUwS+MF+DMFpquQbT50RuHjHLUfdFu7+i5RL9nbtCFhQJMmNgeXqH/ba94SvDdf8iEi6j9Vy185bwuuMdgU69fgbFrwHx6tDl69xyy/K//AgtJnlD5H/tQ7tuW4ESOhjJCKEa0Wzac+X8HcJHjGYEW28ecGowwkQN5xx+8SndfAKbM/F/JpTA3MJBOkMEjyc84lV2XPE9Snky4BHixiEcDdwILwKt5P0MHjYuUnxqNjrZmw6RbNSsxn7tcgdeVT70b/8yVNE42V316RFv0FYtVINh9hNOj8IX8rPZdwJC2DsfTs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 09:17:23PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> vmalloc_dump_obj() unconditionally searches all vmap nodes even when
> called with a non-vmalloc address (e.g. a slab or stack pointer from
> mem_dump_obj()).  Add an is_vmalloc_or_module_addr() check at the
> entry to avoid the unnecessary per-node trylock and rb-tree traversal.
> 
> Use is_vmalloc_or_module_addr() rather than is_vmalloc_addr() because
> module, BPF, and execmem allocations reside in MODULES_VADDR..MODULES_END
> on x86_64, arm64, and riscv -- outside VMALLOC_START..VMALLOC_END -- but
> are still tracked in the same vmap_nodes rb-tree.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  mm/vmalloc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 30c610f678dc..d8095b558365 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5277,6 +5277,9 @@ bool vmalloc_dump_obj(void *object)
>  	unsigned long addr;
>  	unsigned long nr_pages;
>  
> +	if (!is_vmalloc_or_module_addr(object))
> +		return false;
> +
>  	addr = PAGE_ALIGN_DOWN((unsigned long) object);
>  
>  	/*
> 
> -- 
> 2.25.1
>
Do we need this check? If it is not the vmalloc address, we just return
noting. Another question is why do you want is_vmalloc_or_module_addr()?

vmalloc_dump_obj() is about VMALLOC_START..VMALLOC_END, IMO.

There are only two users of it and both rely on the VMALLOC_START..VMALLOC_END
range:

<snip>
*** mm/kasan/report.c:
print_address_description[403] if (!vmalloc_dump_obj(addr))

*** mm/util.c:
mem_dump_obj[1096]             if (vmalloc_dump_obj(object))
<snip>

	if (is_vmalloc_addr(addr)) {
		pr_err("The buggy address belongs to a");
		if (!vmalloc_dump_obj(addr))
			pr_cont(" vmalloc virtual mapping\n");
		page = vmalloc_to_page(addr);
	}

and

<snip>
	if (vmalloc_dump_obj(object))
		return;

	if (is_vmalloc_addr(object))
		type = "vmalloc memory";
<snip>

--
Uladzislau Rezki

