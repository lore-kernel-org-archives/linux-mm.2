Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4C98606A89E
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kh0GcdO5
Received: by kanga.kvack.org (Postfix)
	id DE61A6B0633; Fri, 13 Nov 2026 03:52:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD6D6B0636; Fri, 13 Nov 2026 03:52:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA916B0637; Fri, 13 Nov 2026 03:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB1906B0633
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:52:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27BB3C0315
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:09 +0000 (UTC)
X-FDA: 85429478778.07.1618C40
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4BEB480004
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:52:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kh0GcdO5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.131 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794559927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwUDB2KW6o606MZkDo/fjGb0dXbOTwa5lnzMBFGM+38=;
	b=VPsAVq82id59BJlITSKNRkcOv4a2oZ9VjQMPlNP4zW58Sj/SseZMrww2CbwhZQ79elEccg
	hvYzvMlut7fljL0pOrrHDHdPguWIskFWZKATeWOnjXTF1pZDBo6OidYGb/IwIqs8BV25Ae
	x6jxdV/Q99uGwXO2r4x1PKYdacCN4gU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=kh0GcdO5;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.131 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794559927;
	b=IEjIarndYNOIaer8ORtWW4vHpxYjJ6+YjhwxOLOqTU0lrbuCRIywlOT1UWINvx9Id9ZaEy
	fSsLWG3jVSPewkoKI0PiQ1XBInwYHuYSGr38PQqoMT/WybbYacqM+j7KO5aPVo4o/IG/3V
	B+pKKaqAuzRtz/LShYmwitpR/nFd0ZA=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3ada6c66964so190865a91.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794559926; x=1795164726; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bwUDB2KW6o606MZkDo/fjGb0dXbOTwa5lnzMBFGM+38=;
        b=kh0GcdO5V2Pyxx61t/1OzWc6YXSUpvlLmHB5g+/g81iA26eLjjQe+PZtjdGWB9MLAo
         rUfCpQqjnCXOLKB9EsRh+U3stgtbhQrUA7Qw8IqOGeOW+PVtUu9Pz8uYG9cQqg0khQxa
         H84q9ko2vHDXGjGd9BFwLl7yBSP1KM4xbNHbo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559926; x=1795164726;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bwUDB2KW6o606MZkDo/fjGb0dXbOTwa5lnzMBFGM+38=;
        b=goKZYn/CMBEwN4r868PIknTTJ6HO1RDewglsYWAc9avBKzXzfpasjUJ2cXxUo/lbk4
         QIb1zrTNFGZ5tgXBBJK9PwhmdwUWQFdJR17JbhfkELMyAsaC+51IiMmHq7QjV1r0hrwm
         CbLwoSBmkTzYbqYcHxJRuaXjKCcuxI0eS/9yfYhXQ5Re4qHiT8Rb8FaovP1zuqLZGAzU
         37bXDaC3WkFqV3lDr3LQYDcm1UKx2jLvnfffw4LEMvYM2Emn9CIhdwRw3AYQ8M9JU82s
         B9PIU/aLhnskVUFaGOnAVL6+x0Vaz0bn5jyRvjyf69FJPcDgrn6z7NKzML7A9MIM4wIR
         QElQ==
X-Forwarded-Encrypted: i=1; AL+hErEmEKnDiN/4X7oYJQbQ0vZxFp7Cp6zqkd7g0LVfXvUQ7XE3s+TQYIODub+FFJk896MrGna+2lOJ6A==@kvack.org
X-Gm-Message-State: APuU4Z9Rfm6+1I9W5ZMIeJKjVQ58i6S8adhUnLscX1VygnirclaMx6la
	T3B2+6jEQG7e2hjTI63ywP8ULFzmQbs5dCpDXYEO9KKhngYprfxoQ3cPFAP5yON497w=
X-Gm-Gg: AYBFou1GetP9L7IhUp8VBsbzCcG8vIFMYg1IQFVS0QlhKoMB7exvIPglcZXsLg4uqez
	VLZA4+gtIhaRMqbV2PuurKTKoUuxXnQ8/yF/gd3zBZphHHKh6+TemibvWLz4KmZo8yKcpzA2xIx
	WjF1IQWxbCGSSixJc0GAOkXY3e8Gs4Bibu50drE17CZh1TuF6EnN2dc1EwRYGEKrUVjNMe7UCNP
	tZyFaPJ2ObGk+QGX//31mTvnaGODF2xBBO+re1beDEIJ4eG9BDgHQMglaWoa8Vd/ZHr5P8xb8qk
	AhLC/QE7FpolpXzeIXYbCzur5bCGlPD7vNEIB0t+QL5GKDGZs04jyJ5jaBRSwEEpZPDdojTLXBL
	XbgXvA0FTl1HHUkNpf6IQu1Sh7V/0AgefAv1TEUAJpeBYM75SJ6pgZLvLnPwoR3muB6ZRhpVpNm
	arxAOrHeBMnwfdXz0XO8w4wQT60/3qy4VIvUCkbws9U3qFepOPZNqhwjWTTdYBlFisL7f1SKz58
	ZMfHLltAz5U/sluoCrujBQw7fKWvq9ZSPKsPMdj1BGTz7wZJxWnxldIbTkVNab+QqFo01yDZUTb
	FxX27EaVeCZGMSog/84Q8/gJpHYk38cwCKxsUku6GkOtKZMYTMN52WaQGt6+gEalkchLer5ip9g
	iUWbTEnloyH3sOuo7JwYCzs6X8vJ0jyUamv+cZIqAz5Z8ImVTNzbY2sY6idRVy9CbLhbvWXmyCE
	KpUwf2mxPNvuOTkqRIw2YNVBc1LRNk1qDX7Vuvs/ArQnxPX6MifkR0EeTcD6I=
X-Received: by 2002:a17:90b:3148:b0:3ab:2d17:51c5 with SMTP id 98e67ed59e1d1-3b1b07ff58amr1597563a91.6.1794559926135;
        Fri, 13 Nov 2026 00:52:06 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197d0f497sm8791005a91.8.2026.11.13.00.52.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 00:52:05 -0800 (PST)
Date: Fri, 13 Nov 2026 00:51:59 -0800
From: Chris Down <chris@chrisdown.name>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Marco Elver <elver@google.com>, GONG Ruiqi <gongruiqi@huaweicloud.com>, Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/6] mm/slab: Support disabling SLAB_BUCKETS at boot
In-Reply-To: <202610302115.8C7AD110@keescook>
References: <cover.1793253633.git.chris@chrisdown.name> <9a68a4d95830352ad3821437c2e22c30a673055b.1793253633.git.chris@chrisdown.name> <202610302115.8C7AD110@keescook>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113005159.840c7b1a6049a81b@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4BEB480004
X-Stat-Signature: aygnefu8fjgrzdgbt5eitxrwda54j5eb
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794559927-194014
X-HE-Meta: U2FsdGVkX1+lzOG+YgWH416q5sN4kag2pq+5dL8kvkbJkP6PE3sRrUk9XS/SfkAvOUC7wXu+12IdZ/DKw/xw29B9fLhgIE/yfgqmfQ6sP4D47VPh2M8oXIOThJAaAs9MrL0OiddQSMJ+4xjdO390Go3gou4wGuXyOpAsvS48gtXI0Q3wscTliP9QkqVU85q4vc2mxIGVz1YjzX++XNcCF2z2zlG/R3NSKWsgZNtCkSkW0EmCk/DAvyyznyPcDlk6Lw2QKC1Kefy4Yv8utBTCr8dQRZKE1ebMW4Y48kEegCh5BrNaKussdPfFGH8SJAf+GkBd9/+/NIqqwUJd1Z3PIEmSKf2QZ2wzU/Nf6ro2dZjvqdikvEHzdioThupnS8Z9GlRiQQh3xQEHby7czq+mfluTz+nYPemz2RURYNrAfbQ2pH7xH9GJ1ZqhCRU//hxvk9YYMqTBQfPpUxCGrSjJyRC0RWqe3x4k1IQG2U1DO33NXZU07m5A+qKy0O+MsnEIm4PVKYvy135qn46t4UbvARxIUicnBSRTZKOtMB9xiSTyE5lxRycvPS4Aoklk6FIWEwSQK8FwYUZobcf6F94RyRGyMtv5OV8hDh+aGMkrBjrPqjkOd7kUvu0xiDlQy3O3S/F0W3+gO7OXzdYdEcdVyfMlX+nhc6rwkIblRe6SSMe//Zq48bGHg6PUDB0/IGYFPPNKSXbdSJsKgRVtll/ngHTqvIqXa8rkhrFEUF1tqzNRTm1y7Y3xtpuqWW0yC9TEyZe+AEqsZCKah2/A6CHeFHoKF4jnUWXzzi2en/QJozy3SZUHxg7zQ2aElgK+X23Lk/IndA3fW+fejtfgci9bUuhaIEbUYKMg2Eho6aECCD9MfRjzcSsMvcY/PKRdzzWHPDBVn57eypBtZPRChjCWwOwvErM0uqSjSxf7LlKMDGu0A9g+gnCXPTmhce83z1qbD3bekC18ohfHKyJnOTJ
 dHzZgHbR
 sf813Yu+81Dee1hFLa58hRXgXWud949zbp2q5gvpY4lwRL2Ip1eYq6Ms8b909J/S/hmvPOweriby1tK5ytyq0XAeZcI2k7Tt39DEmWoJWZ2Esb01sR1cTwhaq0Xwsgj+h3lkCeBk8/HhcVOcO8kjkPuTg/v1RNj4+K49/7nlY+8Q3D7KXjOG09CMh9ZZhZQ8OSe1He4hmqeIfJgYliSeENocNRJ0HM3nBXWog2ybjscpMTO9idcE2tXWk2s64t3bHpMD19V8q6OkZyH6N2ipXSMu7cRETwq/CSJxqmiR1GPJozUC0qlpsw///4UwJCh/DCKs7BXxWrxUy6RPDCzSqh9ZPf7S9Y2uTnSGgFI8IKMHuL7rUccBYVaOx4wRhmVGabMjW3GCpvWpkh3DymwFFhAP+/12gY8a1LE45STLixP1FG35skEpGTSvAeoJHHH1Hzev33m+n01yFK8krRg9nfEayrLuSygD4EMWtSd/j0KuYvW8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Kees,

Kees Cook writes:
>I thought the issue here was about calling convention (i.e. with
>CONFIG_SLAB_BUCKETS Vlastimil had suggested making the argument lists
>for the call chain shorter by dropping the bucket argument entirely).

I think you might be thinking of Harry's kmalloc_params idea from the
slab_alloc_context thread [1], which would fold the bucket and token
arguments into one struct. That's a separate thing. This patch can't
change the calling convention: with slab_buckets=0 the kmem_buckets
argument is still passed down, it's just NULL, so kmalloc_slab() picks
the normal caches.

What this patch is about is being able to build one image with
CONFIG_SLAB_BUCKETS=y and not pay for the separate caches on hosts which
don't want them. Harry measured that at about 1 MiB after boot [2], so
it's the smaller of the two, but it's the same "needs a separate kernel"
problem as kmalloc_partition=.

>Regardless, I still prefer this being a static branch so we don't end
>up with a needless rodata global check.

The flag is only read in kmem_buckets_create() and
create_kmalloc_caches(), when a set of buckets is created. It isn't read
on the allocation path. Allocations never look at it: they just get the
NULL that kmem_buckets_create() returned. So a static key wouldn't save
anything at runtime. Also, some architectures (arm, for example) parse
early params before jump_label_init(). So we'd still need the bool, and
would have to flip the key later as init_on_alloc does.

Is there somewhere else you had in mind for it?

[1] https://lore.kernel.org/r/e650e125-5f6c-4de7-88b5-9da666bb0a4e@kernel.org
[2] https://lore.kernel.org/r/179312451613.474906.1475329637924619088@kernel.org

Thanks!

Chris

