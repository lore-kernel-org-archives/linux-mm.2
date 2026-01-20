Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 178ACD2628B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 18:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692CE6B0491; Tue, 20 Jan 2026 13:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F896B0492; Tue, 20 Jan 2026 13:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54C216B0493; Tue, 20 Jan 2026 13:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D7696B0491
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:47:51 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4F271AF5BB
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:47:50 +0000 (UTC)
X-FDA: 84353226300.01.2A3258B
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id EB62B1C0002
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 18:47:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768934869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cyvv5bVOKq5q2ikgZwkotwgP6l+kB/mtu+tHV4I/d8o=;
	b=VXMhSN7+qqMhcoxYJS6knQoowGRsvHyq1Ex9HLG4FrzSAsa/lc6rhR/2Fi/NiF9m+M7vLv
	PMPz9v76Xq8DlVYNvhjdAafA5DoSUOtbMPEzvj0xQm01ClyjPiFzk5hgbgeJyJZCgdh0OD
	RiK1P/0bG+fZ3i+udRZsAjPY5pJNfO8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.210.53 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768934869; a=rsa-sha256;
	cv=none;
	b=tekARE450z674YBsGY3H53QLwOH+Osn4Jx0gFoJHP3tbphcioQH+4dkiFsAWg3RleG4ySx
	m/14fz6aBmkDY+8VG9mmgpY2MGjEJLob6sD4iNuCJ4E9i3tz7go7mGTZJagmpkr7lahsJH
	IlkO3ZnwCIvXx0g8H8XtXGXBZK0+bLA=
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7cfd9b898cdso3228659a34.2
        for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:47:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768934868; x=1769539668;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cyvv5bVOKq5q2ikgZwkotwgP6l+kB/mtu+tHV4I/d8o=;
        b=r1TmHV3I/5njXy1iiYXqmkVtgkTwbQthOS19oTHXBslfsydtBs8eoNR/3Cr6cPuoQn
         mdz9uaHtvYNICBzfbtpjVBQgSSIlzx9aYqwsC4yWu91gix1/kRYKgUoWog2n7eCZwNoB
         NEnz1V3Xlr6I+0Zkla0cPpe5ChPpHDWJOz0jYZUAqBPuJBt+GFBD/A+vdl7lsSmGGz94
         Gz/mzQuuIri49GvZYuQN7stHXqNXAr7rZdwXRCmDFtZeF7kEvNAZlGWi62OZfPiTmdzt
         UwFsbpzygjUPyRjt3Re8Srww5sKAnU6lXseT3F8B2g5d+ie40qsMOl2fLTnCW+xhsnvn
         o/6w==
X-Forwarded-Encrypted: i=1; AJvYcCWoXYw8kKP15ktqTqv3UP2iAMuE3mDdEyFRdwGNK02HN6j03SpSYCoj2FWoi70WitYMdKgSN0dzSg==@kvack.org
X-Gm-Message-State: AOJu0YyTJKEGuWwDgsaZLQkrZCMCh+eJMIbFz5WpYgwC/OpfOSWH6ctD
	9FlwbzC4wqhiFwr5AymngskBmvuCg3wPxz2Kh9ID7PKA7mXTzYDjQhQp
X-Gm-Gg: AY/fxX6uW4AlK8lYSCk+JrwXXfzKiOqhD4FljE4AkL6PZ76DVk2MOBtd8uzrD9Dofqz
	TvsyXoOUeDsIwVeNXn6U+M5/orEsiIo48YHR0oBfFb/UfEmROEsI9LcBd9aeuYdfZ6N+Sk3k9kR
	4OgrQMQ+vVB0MJfpvqygmcw5eGIKPPPcYpQ8KVolENwaAnWem2o9uVvx9iIIV+8y52B/3A+TBSo
	zw8YiOrpIHo6upb6yq8h8X7inD/+9sW/S3de/GWf2xFbxKev+tlc6veLJc28LDVTvEqfs9JxUV0
	b2Cg9j3+/tKYxkA+1AIesU7nXztXT1wkQAUBeYBeAYUXwCjWKYe9cW7HJW2XrY7/F4R+uteS4p9
	svVb6KICga0nhY9+R4CT45JP/s9pRuPu9YoxC0oPoYupuqBLJv15e/gW9iQNhXBvxgC126SVyQh
	gluA==
X-Received: by 2002:a05:6830:3986:b0:7cf:da97:57d6 with SMTP id 46e09a7af769-7d140a3d3c9mr1655270a34.6.1768934867912;
        Tue, 20 Jan 2026 10:47:47 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:52::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0e956esm8985236a34.10.2026.01.20.10.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jan 2026 10:47:47 -0800 (PST)
Date: Tue, 20 Jan 2026 10:47:45 -0800
From: Breno Leitao <leitao@debian.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 05/21] slab: add sheaves to most caches
Message-ID: <aW_NK2NXVgtuzCVH@gmail.com>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-5-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-5-5595cb000772@suse.cz>
X-Stat-Signature: npc8eigigtrd1ygfowc5mxessy8qbpoc
X-Rspamd-Queue-Id: EB62B1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768934868-755177
X-HE-Meta: U2FsdGVkX1/tgY8569y2IJWDchXuUid1D5KUFSun5xLzgpTe9GFuVwXDXHDp3HoyPT+E9rrRohWddfQf2AR8KX+gfWCrc2nxaoc7TPpMA3dkHhxDTTK1+vT11B2VgwZTrDbCjK8/wAipbeazaBKhKR5y5mRF+YQy7Rb8CD8RAX/r5Ixa7nKmXJkqJYKNLi0YVbaDx0AS0e5rHKaqGv7semI6gZJKoY0yOIiabdv6MIRe0iEgXY4UX3yopmtaEq9h3Zio7WJ0xJnYpi2FDeelqUdFotKn6J0E6jJLtC+JEnGhanqlLdfHaDKnDwqgZHTE91RK5ddekmhuzzXlFaaCo4f4CMz/cRrK0SXAc0/IBg2BE/5tiinqbVc7RWq6GZHMHNEWMYICwIa/0nrEDdyFyXQIKuLrkUs02MubgFwyMdrNwSE1EMnsq6uSt1HfYFRMSl6qlG8W/U8SXPqk5c8U3JmzOHRzgjJcLmX2hRpQ3UCm3s9FYd+nalJnNFi74a5YNHQw9IDClRc4ZveOC9lrXEXFgDmkMd/D05mzsyFcgGjK5SBXIarWyzoJL6R1lPLRWoPPae6s3botoxFPJLryV/vD8kbpi5SguT8IUUOA73yCcQjG6KNB4lIILT2dy5sZZI4Hqske612VAr9iANyb3MVAP6+o1zjzRWLLhK/b4Cc+ZwDzbE6lRQuWSxvJgWk7/m0mkpwpy5DZTD5Vwhk2fGGFDsoL+ZpVMfClt0dHhg2dSA53/eGyehkOI4hmF49iuR9NhGRiqqxRXdfIfzTNgWD1SS/b7DQTGm0a9e7veYlTQYz1140ogU0+uMURtHATYcwDqMe8WCRwToErGNBdDMgPC3o7fAey4n65fMr1HG9apasLkmX08h9+dfZgF7n/mdVLLK1KAvhtIjXN+FGbI7tEfs7vsl87dnaJBRU64rwk3zYQM7WH09XE9Q1NWm8Yye0Ifd2VQNTLchBqoCq
 nRixCyvt
 rjfFNTZPegcRQZBmhrt8qJtx2E/ZLAOK7gw80RE1MFioqi+1Z+Z6GVPRhtIv4CbUAVnZhDG3nl2LyH0x+FHHIYXgqbIR+sIgWvO1dWYCxWecBsIGN05wK5Tvdlj/4/L1eLoHjLsExiqDMHnr0jOaq5yO1GqVQ0YFyeyOy/61KSe0LkjbLpJ2RIdHfdWQbFWuavzHxp4tdd3Ivufnr8G6ZrG7hNQ6XOZ10EhI1ECwZJkqbQ3efmgcQXcaCXB3Y+iVQM2JNM7HnBfF8QMX98QrdB0qTDVD4rwd/4fRsx1DGYgJwBHgPudpSEfE28/NuiNA3mDekWZseCZwaqZ9lIMuAyV3uFG7xdAOYEUps41LuKWks5UntFsO7NRqIt+n3M36iapczxe2EwA0ivXTqeJk4UI/rwwLYYWuuPYnl3ThwxidpqZzEN36bjk7mZcQ0rDRyN/UV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Vlastimil,

On Fri, Jan 16, 2026 at 03:40:25PM +0100, Vlastimil Babka wrote:
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7863,6 +7863,48 @@ static void set_cpu_partial(struct kmem_cache *s)
>  #endif
>  }
>  
> +static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
> +					     struct kmem_cache_args *args)
> +
> +{
> +	unsigned int capacity;
> +	size_t size;
> +
> +
> +	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
> +		return 0;
> +
> +	/* bootstrap caches can't have sheaves for now */
> +	if (s->flags & SLAB_NO_OBJ_EXT)
> +		return 0;

I've been testing this on my arm64 environment with some debug patches,
and the machine became unbootable.

I am wondering if you should avoid SLAB_NOLEAKTRACE as well. I got the
impression it is hitting this infinite loop:

        -> slab allocation
          -> kmemleak_alloc()
            -> kmem_cache_alloc(object_cache)
              -> alloc_from_pcs() / __pcs_replace_empty_main()
                -> alloc_full_sheaf() -> kzalloc()
                  -> kmemleak_alloc()
                    -> ... (infinite recursion)


What about something as:

diff --git a/mm/slub.c b/mm/slub.c
index 26804859821a..0a6481aaa744 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7445,8 +7445,13 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
        if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
                return 0;

-       /* bootstrap caches can't have sheaves for now */
-       if (s->flags & SLAB_NO_OBJ_EXT)
+       /*
+        * bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
+        * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
+        * have sheaves to avoid recursion when sheaf allocation triggers
+        * kmemleak tracking.
+        */
+       if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
                return 0;


