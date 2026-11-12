Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8183606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HFYgVVR3
Received: by kanga.kvack.org (Postfix)
	id 2196D6B05B4; Thu, 12 Nov 2026 07:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CA486B05BE; Thu, 12 Nov 2026 07:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8C86B05BF; Thu, 12 Nov 2026 07:15:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DF2FF6B05B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:15:08 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78BF3A058F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:15:08 +0000 (UTC)
X-FDA: 85426361496.01.C8C6C97
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9F1064000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:15:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HFYgVVR3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794485706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpDaJnSBpbTWNByfkYn2gGCZr1PGzjLso15YyBRA1S4=;
	b=cBLqdslQ2CWT3nHagq9hgzbp6e+7G6FT9m5V21mGgjJ0lE1VtGo7PhxhFkBnHYBAntLjfd
	WH3kpRpHAwocWBinfHnt46ahd0O8GCS2SeiUfXiwiiqgFHsuijjOjyHx6sn7iJN32DGKMA
	udOg4U9/bu3cY7As5BHpfAHgTUueFSg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HFYgVVR3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794485706;
	b=J7ouU5LW2cBUj4y/OBaU7YSi8Oi3DA3ZU5mDoymiKir9XoRGMsZLFoirJx6vTFY3hopxOv
	bvOXHIDdB6SB3ZM7vP2SLN9r89hyJTIPRJshmvpPD6Yz0ZMP26GEonuWGH7Xsd+JNqSdin
	ZQMV8y2KHLt7T0qsG3NPLKWyFk5t+sQ=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6b75712fb57so4199501a12.2
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794485705; x=1795090505; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cpDaJnSBpbTWNByfkYn2gGCZr1PGzjLso15YyBRA1S4=;
        b=HFYgVVR3yvL3yida32Vp5ta1lWlFhJTkuZgV7vlnsEREJM3WsHcbxck/m6JpF+a63t
         3tpopfSVMZqJaHVuKU6cCrvGj0pJkBHhA9rsPKPELre39f1gHSD6gYlLN5lmO9tMGuGx
         TM0whsPPeEZwOCJIqDyDa6BIIqf9lYhWdeYqTdPb9U9YlSWcXBcrc5FsVnk3K5+Q1jS4
         DnuivW/3YIHs51+Hf9yvYThaMItucWeuETJNbKDbATvXa0sCyI4BbzfeHk460i7x6eJy
         bxLSe80QBkbrll3l6QX23UjYP1EjILz8SrEtm9ScwcQFSr7wYXBGgBljNXqlD+zKkhiw
         m87Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794485705; x=1795090505;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cpDaJnSBpbTWNByfkYn2gGCZr1PGzjLso15YyBRA1S4=;
        b=ss+IC+odA63YE4o61Kx2O04h2TfUflgW6tL3m5YOfNk4P/aFoH3auoKidsKneZqf41
         l9FwilUrOfFRtbBGdi1OQuVXJOyW81z0wjjV8nUGd4FMwEyXvsrTIwzD0CTRdD4broX2
         fnjz8zYabFgxCA3TPGnUi9rNG4Rv5aOZuPE1gYeA1n2innjd9KWvJXbIQmeUedU6/4Fl
         8VLjEQuD4UOHIL9T4RpouA6UU5TGXGlj6IoBIzqQUt4viEo2DHHSmAN9ZEOAg3x5x7PX
         Neo6t/egz5FDMaqo7atSMqdBN7AO7TEjQFn1g9LaIDq5B3jMS5OXh6VuEW5Tte0hadYZ
         aKaw==
X-Forwarded-Encrypted: i=1; AL+hErHhzXMW28Qk0XoXahanhPajdIjx/N8eudF0yXt2qCgq456RzRZHqW5/iah0iduSelc8jUvjG31i0w==@kvack.org
X-Gm-Message-State: APuU4Z/+buT1uJWlxdRdcPoprzrp4n1A/KR5wyvpzHBjATxBWIyMl5//
	oxIThbzIcqcD2o5py3MnUcWEbiAdS8xM/4AyqE1jbCbPktaw9zQocr9e
X-Gm-Gg: AYBFou0GZuuHfv/OVfpdTJW4I3ssgbIx9goCofkM8OHeowkqFaT8CBVbH5Ab0bwEcnh
	UF7Ty8jZbbAEyymyoIefFyVa7Iv4c+d1bvcHJFT1K6i6PRt4BZXIhfiRmtQKkvJgu3CfW3joQLj
	gYqX/NH/pzy10JQMH9eW6NWXkEIzFHpo5wLid0Vai3/1q+2zxpwwKO/O+hi5/0qoH6OlE9QkMDU
	LsLISDPToK3VaoYRz1fGsmkF1zM1WpW4EooKd7Hw4C5aAj19SoK3xqEU+GJcw3DmglOH2IH2Utb
	lThVBXDhtFEBmmoCfFPtCom9YnEbFBHVYacsCgho13/srG7AQ+H/haFWg1KKIpLylA/a6hF7uXd
	mKG51eKObYsNmHm9qOaxDgVEevafntz5efeaIREQMMxcpFMYYS6hPQeycxgO3xqyJYgCjHFGboN
	NENs+BhDZhBu2+9Lt/LVPiK5bZHh/jQjXurjI4Feq16ovKOf70T0/kdwk4+pdgirZ7pCdWNN727
	CU1ytqnB6Zzjdfb7cJtsPZTGg33x1faceXak6MZ06zro7rF6wZO2iKyfICkoEDC9oh7GA==
X-Received: by 2002:a05:6402:c4ca:10b0:6b3:c422:9257 with SMTP id 4fb4d7f45d1cf-6b777702f43mr2869009a12.25.1794485705031;
        Thu, 12 Nov 2026 04:15:05 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7578d57c4sm3241614a12.18.2026.11.12.04.15.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 04:15:04 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 12 Nov 2026 13:15:01 +0100
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org
Subject: Re: [PATCH v4 5/9] mm/vmalloc: BUG_ON() on an unaligned range in
 __vunmap_range_noflush()
Message-ID: <avWtxcH2mKw7dgbp@milan>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-6-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110112546.261415-6-hao.ge@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9F1064000A
X-Stat-Signature: abizj8m8ujnzykjwmbeuj4ke9xk6ymng
X-Rspam-User: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794485706-286145
X-HE-Meta: U2FsdGVkX19QRogxKo41un2YqNxbq4XSBpNxyel4+oRyDtl0cmiJ1AVejXPS+6XamsAng1oZDjX8BG9szVxX+YI08aySITj0YMPQD9/5+YssQsjUI9tAPlvO/9Hhej+bAf74x1o+CU6zMLJK3jf39Ue/8TwtoZoM+t6l9TXhg8AVxGIv3Bg7Hl0rnWoSMrAhx5uwru69nmc01jhQwwz/zrGTz9ibbADvXtlsph7BwuAJxV98tM7bHO5eLvr51lwu9DyzXswepu6CLxHum7q9a8Qx3uax2EQjB1RJclp0RDq7+2vrtQuCsFz+n/uikOsPnnfLh5uh/Bmq7TSvnGI9cxGVRqLJRRGmy7Rf2zN1jmvAuh1QPNRhihzkA+PU5QTfmbGFLpCf4eebXJtY3lxTJshgMhpB+R5cLm8JjgeC/8QoCD6tDHr46Jz41td7N/rO69iVEcsf+FkuAk5b/nEEPU+bMSbqAHi+4oxWWc3Voj0ZCl6MG2E9Oem7GHCB/859De8T2cOOJS5MTUPxufJ6X3PIZpXfo8BBB2DRv0LO3GJnZ2FiQpVxcMqQWV6eNRWpfMk+K/HHgQKV1SvrQq+RuI08dpnXZJwOZEOhNBpdc7ciWZPlBzhJ7o2mmz5CAVrPBLYe8YawNh5xi8WDnwV3r6HQE6zYFnQP1A9eXyDrMjqw96w1RH215WrgBQFWWKP7hJhrVWxo617BE2wioPjy+1hkN+2oqVuwXhB74Ys/j+YMyGR0+VARW7jJ2nacwuGIEZRNM+X7RQB3OyFgI76If/gqEbnmfXB6AiHUP5sbQGA4uaRcXS9X3rGlhymh2XcKLj28n76EhOzD/5TUMe7see3E77vM2EQEZg+4qqCjzGe/IV87OjlmSP9zmoaqhqGUITcHg2ujI0sQ2DyfUca/KbhyDHz/Ufk4i+QXGU4+5RLR4Yxs85cHuGf6mhGW/15phCxuG20IwQ/Jk2CN34m
 zhA8Wpif
 PgLk0i81Ta8Z0+PUw/kdD7sU2SdOAyPZH+AisvckxcSMZbTKjUpjZVnBZASpOdOHHGuutHJ5FktsRcQWSXDLRQmw75SuBT07ONV2C0+zlcd2KhK4zyRwhhEpznJ1vQlDehsAeDHttsHIq+/W3QCz6ZXf4ILTnZSkKiCJjVmy/VhqTtvcv/u/Zm/OJ0eoGQHfR++NQ6ZobOKQSHB4HxcI57xh8WhqFCJMuYSAjXiEpE/v34CQL4zsXfNkW2u1E/KBF/1j8658s4AV2MaxauA5fbeStXiIQvieZRu+1N+hENBRQ5K3KmqLzCjLAtmq6tnq/9Dzy/K1w2S4PV3AwiCODrB2mLcLpn/YaR/QLbC/DxLZyrNEPqd/nLoFCG2VHBrMwUKxiW6pWExO5CO7lMyygORcCuQv6BmGa62H58eogS+kP2ycG7cIAPgYA0zINcCLJ7PHDfYZPZ6kUQVofq3jiTQGkDVORQECbwPfuYAe5+CL/VVRzX0Rrh241isMqwXoa3FtihevGqr1jpw+i1Am29zC+brBenCGXkw3muu7p+CWihk9RjyMoAWAJZqJKsIhsqi3ckCbWTwVkDpnkIAqaJYNLgZuLvEsjvMOJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 07:25:42PM +0800, Hao Ge wrote:
> The PTE loop of the unmap path stops only at addr == end.  With an
> unaligned end addr never lands on end, so the loop walks past the
> range and keeps clearing.  With an unaligned start the loop begins
> in the page containing start, which extends below the range.  Either
> way the unmap clears the mappings adjacent to the range, and that is
> nearly impossible to debug afterwards.
> 
> vmap only installs page-aligned, page-granular mappings, so an
> unaligned unmap request is never a legitimate teardown, and there is
> no way to tell which pages the caller meant.  Check addr and end at
> the entry of __vunmap_range_noflush() and bug out before any PTE is
> cleared.
> 
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 86fbb1d2b27a..0565cbfe325c 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -518,6 +518,8 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>  	pgtbl_mod_mask mask = 0;
>  
>  	BUG_ON(addr >= end);
> +	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
> +
>  	pgd = pgd_offset_k(addr);
>  	do {
>  		next = pgd_addr_end(addr, end);
> -- 
> 2.25.1
> 
I am not sure this is good to stop machine at all. WARN_ON_ONCE()
and return?

--
Uladzislau Rezki

