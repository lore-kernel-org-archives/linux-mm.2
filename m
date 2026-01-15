Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 237FCD46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CDC06B0088; Thu, 15 Jan 2026 14:10:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57AD56B008A; Thu, 15 Jan 2026 14:10:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1886B008C; Thu, 15 Jan 2026 14:10:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3967E6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:10:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7AE2C1D3E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:10:03 +0000 (UTC)
X-FDA: 84335138286.09.048DF00
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf29.hostedemail.com (Postfix) with ESMTP id 451A712000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:10:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=iwfKcpSM;
	spf=pass (imf29.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768504202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wz1gwrD9wSWpzyJfhrJeaHZNTHw4Nfnpn8NnUbt6Eeo=;
	b=knc8u4KlEwj4U3IRYnOAIEq5H6t3XyZsiZ9HwQf3i71M3CoUy62ypv1EMAbIk2d7wBhGI7
	0A+4mHMmYT7yc3qYGpm3/WOijPxXbM0L+oFnde2IUSDmVG60sbf7C/Wrf70+sS8uSY8UOd
	0MTNAKoD3capB0H0rgp2bXRYu2EPsiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768504202; a=rsa-sha256;
	cv=none;
	b=uOwlsv5ZY70FR5VLHawoInG9xp205cpHVSqeRrqxBhvs4rnnYb+qy5PuJUo+2138XXUFZZ
	BBjXh4OlO+10u3IfeYPOCTRXxL16xLFwjd0FgYWpI+Dewu7AFYrEudrBh30Fsx0Lg8jzAG
	buMpNL3xpllFyg7KCoKOYMqY4Svgoos=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=iwfKcpSM;
	spf=pass (imf29.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1768504200;
	bh=IcRpG5N8ykceLxD7UQKWgqTZOULO1Y4S9mnEEFi61yw=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=iwfKcpSMFPDxFIoJnyUoD5z+0kXNh1pfpjHwjs7L7u+r7NIfjghj2gEb90+oO9RdH
	 HYCX9nmXqTCsw5XXupqJ1h4BI1YkV34wqYlX3lUvzYndbJZF4L476XRBNY4jKRO/HY
	 tQpM7QzMeMFKHc4a6gnqZ78beXb1JLXB4haLRj/M=
Received: by gentwo.org (Postfix, from userid 1003)
	id E3FA1401EF; Thu, 15 Jan 2026 11:10:00 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id E021F4014B;
	Thu, 15 Jan 2026 11:10:00 -0800 (PST)
Date: Thu, 15 Jan 2026 11:10:00 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Al Viro <viro@zeniv.linux.org.uk>
cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
    Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/15] kmem_cache instances with static storage
 duration
In-Reply-To: <20260115020850.GX3634291@ZenIV>
Message-ID: <806cbde4-fc0b-7bf7-d22a-2205b46eaa96@gentwo.org>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk> <0727b5a1-078f-0055-fc52-61b80bc5d59e@gentwo.org> <20260115020850.GX3634291@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 451A712000B
X-Rspam-User: 
X-Stat-Signature: sdynm35ub5bain3mqxn8hg36y96k5bg8
X-HE-Tag: 1768504202-529618
X-HE-Meta: U2FsdGVkX198OKPdgwgsrH120/u4mfgEyHcxLzzY9A+hi6IN90HdsXk0bMfAjZH3OTOJ4In3p+nrZn0RRn/3j4nhrXdFsnig54Ux7926YLjqGFSatOkIAmTqmryyTENd5PQtci4H4j2Mf5w/JYX+3zeKk92YLlkHhzZN/DNx+OpimsQYGxjM/BrgSFg1rCXrYtghcWMt4Ry9yiywfyHG+aZ1cau1LpJ1coHjkapC+OI9t8rpfRHgD3W60fgRDcJSREX9PIPwA+TPNsiQ2jaA6qVlQ60NH3fTp4xO403ht63kQ5P+pHGmzVnm60nC2KkmVdVgRg2BHjKyZcZaRFQoikfXAGhRfYM4EPiTUeC0fu6BPtf5BULhiqGRJMisrmjFSVjpfZTGJmRPFs6PGKXaJZfbP0DSGm2wFxq9PNpioeiDDbG1Zs8MXUGFZhTahIKCeHmxOvRSM8DX6Gz/NLVcAuh5jhz06095sRb42M0uqYMxtci16spSqnCu6x9BfldGqqt1zjqwYYItOICoAqFLw8RlNtqU62bcRGPxa0wZx5fFDYEBoH+Mv8pg5pB2SUnolshfNh3CpBrHseSUnVpVTZKfPO8s2zFvTR3X2jIgvvs5ydAMJq0b2Je/w4ASiOS41eDT8BjGhTphGuqtQjK3VjCENbyVMmqbu5qrOMMw0Tib0Ufm7qvQQ/9D71njL36WEmxU9Wdb/ICUdKbSyj8+NT+BPeC7ZHvJk000iXgPUvCygZmA4uL/4pfFa11FZTywXBUbO7r5i/xkIr63KzJ6RIYULPQpC/qbxQ8Wl6PU0BFXDLhUNqEOhNRghDGdnz0cJOfW/0cE6VOcxA9nPPpY5JRs1ygcw9GDW4mIDiplktnoghq8rDOmYGJm+vgh9qJDYMBel3/urXhU5Q2XcOV1nJzzyqpkWZvDjoSLCGcIBzut3ETJ37nFCjFtjly8V2k4t4LiZN5kVO2K4IKY+Wq
 7j/wy0Zv
 xcJdY3rB3XPbclh/LFrF6d2+bXgi6fIBR/VUseeB5c8UcffZ8/k9jNyVWQzJmMApx5mCuYRhyERuvNVCTHhxJm0yr+BMWAUSLfFi2+RV61z84UveuLaIyn0vZhTYhB+fYQHiCJpR5NuSW6d7JrsOaMt6bC1b5rKKzrSM8lbnAh28fx/K6kagU6lg1z/AAHtA2Ok2BpiVBcdcZIBSSiYpPk3jDuXmXPS+V5CptQ9Ll7R5EGTnzMtqawuWbWgTHVv9h7GvC6lg/IuzbKGgTRQE1KZcWSpyCOiooOsX1NC89qqMI7Dc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026, Al Viro wrote:

> > Would that an deserve a separate abstraction so it is usable by other
> > subsystems?
>
> *shrug*
>
> Probably could be done, but I don't see many applications for that.
> Note that in this case objects are either of "never destroyed at all"
> sort or "never destroyed until rmmod" one, and the latter already
> requires a pretty careful handling.
>
> If it's dynamically allocated, we have much more straightforward
> mechanisms - see e.g. struct mount vs. struct vfsmount, where most
> of the containing object is opaque for everyone outside of several
> files in fs/*.c and the public part is embedded into it.
>
> I'm not saying that no other similar cases exist, but until somebody
> comes up with other examples...

Internal functions exist in the slab allocator that do what you want if
the opaqueness requirement is dropped. F.e. for the creation of kmalloc
caches we use do_kmem_cache_create():

void __init create_boot_cache(struct kmem_cache *s, const char *name,
                unsigned int size, slab_flags_t flags,
                unsigned int useroffset, unsigned int usersize)
{
        int err;
        unsigned int align = ARCH_KMALLOC_MINALIGN;
        struct kmem_cache_args kmem_args = {};

        /*
         * kmalloc caches guarantee alignment of at least the largest
         * power-of-two divisor of the size. For power-of-two sizes,
         * it is the size itself.
         */
        if (flags & SLAB_KMALLOC)
                align = max(align, 1U << (ffs(size) - 1));
        kmem_args.align = calculate_alignment(flags, align, size);

#ifdef CONFIG_HARDENED_USERCOPY
        kmem_args.useroffset = useroffset;
        kmem_args.usersize = usersize;
#endif

        err = do_kmem_cache_create(s, name, size, &kmem_args, flags);

        if (err)
                panic("Creation of kmalloc slab %s size=%u failed. Reason %d\n",
                                        name, size, err);

        s->refcount = -1;       /* Exempt from merging for now */
}


