Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38363D64099
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A226B0005; Wed, 17 Dec 2025 04:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7FF6B0089; Wed, 17 Dec 2025 04:31:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DA556B008A; Wed, 17 Dec 2025 04:31:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1316B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:31:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CEDFF1A091E
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:31:39 +0000 (UTC)
X-FDA: 84228445518.21.DF824DB
Received: from mail-wr1-f65.google.com (mail-wr1-f65.google.com [209.85.221.65])
	by imf05.hostedemail.com (Postfix) with ESMTP id B50FF10000B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:31:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZdC9oVgd;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765963898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zup+NREwv4bDGFbQ2A2HUXZHOK+ZTfY+5pUYXAKCRlU=;
	b=UD/pNveem3zlzOr6scNPrcIa1kiAtI2X8w/NRIf4jo3+LBZhlEALZKEprgpD5j8y+HfCC8
	sP6aeAsv1rD25SjKbY1S34KuqAnrUOk1Z/wsYkJjG86DLGL58XgToJJ5KRrr23Ls6aWN0Y
	JBoLFwrt8uQQdLdIfAB5PLgms0Wf/Ao=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ZdC9oVgd;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.65 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765963898; a=rsa-sha256;
	cv=none;
	b=W93lvaDKuJ3sWD1ufndeNLXBbcELDTam0h1pfnRmzC6sQJ+DoN8lxOt07thWwH3tnuTuSw
	Aei8r4VcUKixsY9Lt82/RuUda439DSLEsJwNpuR529swyiFdiN8IMPAM5TPpnVLDejZnmm
	KbKw5OoVTMDqWHx1o38sE+AL209heqc=
Received: by mail-wr1-f65.google.com with SMTP id ffacd0b85a97d-430f3ef2d37so2717438f8f.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 01:31:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765963896; x=1766568696; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Zup+NREwv4bDGFbQ2A2HUXZHOK+ZTfY+5pUYXAKCRlU=;
        b=ZdC9oVgdyauwglRZ5BdAdTW0I9v89u30f6UYKVsEP6KGoy4fIyIVcsZF4EA1YQrkEL
         QinrF/Zx79q3vCQggFJLX4liQ0HzooPoJERQzchpbu/NG8V3J+DSK05cV2bmLLsWnJbS
         b+KGiuQE4sB6zUXpfvOKi9oSHPmuG7gPt73A8OqMu/HYKOPyJ/ATqXpVVcrYX7oVfeQe
         mxtOS7uuObC0D5aCVkqNtt9rxvejs70pJf3H3RfQ9QqkbDu4LDN4qledGRKuTwZ35XnS
         RKv0zHvf1C/MMl3TwWDafL3WqJamEjq4zDjhcV/sHxOaMyhRFu+hJszDJ4cNsG6+VeKY
         C5pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765963896; x=1766568696;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zup+NREwv4bDGFbQ2A2HUXZHOK+ZTfY+5pUYXAKCRlU=;
        b=NkARNDbqy35GvNBUZJjrD1My7AOtEVtXOzj42LJKJA+ZM9v6sRjm34t2t7V/TS5/yf
         whlsX3dSH208BFN08vFc+3TzLHQ/FqJ02+oIvEYFl2vzpXneAOnOiBKKqKbUoyS+p+wS
         kAUuYsWhMAB//YIp9lyKroVtjlwpuesnHqUafGQUylJ25x8PNTDoEG2j/jfeIALd+g7b
         KPkT1nKvnVjKsNVrZHmeMNgKp2bsP8VRDsz8VyVLVdZpsiyfliCIa5zgvVFLJoVlGNJe
         CLrZet8DO4X1GBzuYeuxaB9SPd4z/eiKulzdid8hPZfvHL4jig/SNB8L6X/eJSew9Lal
         YfPA==
X-Forwarded-Encrypted: i=1; AJvYcCWjIo1b9Z1j1uCNx6XoKV7w/1xGCzGicfRoP/g5KbHwlLdMQBrEGZGEJvtuNhAkg/R6hUMCFZ0S4A==@kvack.org
X-Gm-Message-State: AOJu0YwoiP44X69DszQ5holy51r/QiMMCwo8hPEt+HSLEHg4NgQwgvbq
	MBK8BJDS5KrNV7HfzXOsMgPtpdwg+d7jcra/dEAyAuT90fZSeI7PuXzwdgKTxbUdlBg=
X-Gm-Gg: AY/fxX5wmRg8lemz8F1sx+0ut0cAQ2Yhh1Nc+loMZiFIvkD2yg32qty/SRqChltzeBJ
	9Jx3FFaiOJ9qK2JvaNiOmAHPLU60ooOyEgmn5R59pZYoLhb5Om20ifAhR8TT1TjBGlIxzQdfGFO
	eHNNaubjjIxWraRNt3Via0IdR8SXXZ2oUYtP5zBTtT4nV5nIYRCuaRtYIOFO/6gMMy/aROOgAdg
	RxuYdu/C+MzCOyoEps80uOcdHNzeDwgJQyUrqHs3gAx4U/MzWfU/yvombO4slf3elx5em2q/DEu
	bvYLzD0x+DpgyBowl1gZESuzP1mqEY90qZvjxN6JnE/16XKXZ0UojjlY8llT+4Au6VOEM5pv8+f
	f2FTiy8M6ol8eyR0D9gsRWnJuSKJ0e6EFsEcge1nrWKcXRw14m5YjR0ZsdpGFX9bQh87OiOki1j
	JeHneXbpPxUeN8P6TxaYSxdxhU
X-Google-Smtp-Source: AGHT+IHUg2s9qNRy2h8qzqEF7qPvmz9s/zPHkKaoW/kuwR3Q+5QdFqNBmMhrQm4/Lja8vlq0ergnFA==
X-Received: by 2002:a05:6000:4285:b0:431:3a5:d9b2 with SMTP id ffacd0b85a97d-43103a5db00mr6698510f8f.39.1765963896012;
        Wed, 17 Dec 2025 01:31:36 -0800 (PST)
Received: from localhost (109-81-92-149.rct.o2.cz. [109.81.92.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4310adad05fsm3888033f8f.15.2025.12.17.01.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 01:31:35 -0800 (PST)
Date: Wed, 17 Dec 2025 10:31:34 +0100
From: Michal Hocko <mhocko@suse.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Chris Mason <clm@fb.com>
Subject: Re: [PATCH] mm: memcg: fix unit conversion for K() macro in OOM log
Message-ID: <aUJ4dsVxsUj52hnz@tiehlicka>
References: <20251216212054.484079-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216212054.484079-1-shakeel.butt@linux.dev>
X-Rspamd-Server: rspam02
X-Stat-Signature: tsyjhofkbgk1gzjznpkya9bgiyho6798
X-Rspam-User: 
X-Rspamd-Queue-Id: B50FF10000B
X-HE-Tag: 1765963897-68130
X-HE-Meta: U2FsdGVkX1+jViPb1ySDM5WvU8tW49Gs8Kg3d2ihXq1UBO7sWd+GjrGvy7KFCO+j1oE3Sj1FNupZt7kfyvwDtnjU+mrA58E03qf3JvITxSrhWzmIRakbrSkmiQyBAFrClmMzaXcL1zIlRvc+XbtiLMy9CQ1IHo9FUJoqT/15cu/0iey+qltEz2UKY4bYnUYTdYUASQ4QtRNL9qSFUt/i3f7Tw/zEnpDyWVGbx86y7SZ7UO66amg0w3XXcXxCpFSrQF98vKG/L+OwEV1Fh+O/g0gY6ldP2nuErGLbYstrhLfY7N71wO+a7c1cKoNbHBv3bKwSBNzThAPpV0wgOfdhw04VsauAeDnsEvNsJLexYbgEBXvlZpJFC2JSbeKqGkQ3yDjNZPM2vJp9OakHxpCuzIaOhgJEEEIRy41jPI2xFyBfCHi9Fn9N7uBqXbttQNqQ5QQQ0MIKlWekn+7ek2l56Lql+YRo1Ber7lIbKiIIpOr4J56yQkr022BwC4RMWQiO9jwfFazKWhcSXYk/IZoAFIi0Ey2L09/qAeYznH9BvXivA46MaU9Q8SLkRFCXMGB8/b4eFyLl8YjcXTa+y1zY9zi/JeD+e6S8s/Un64TXYOuCyM5eAMyumxWVuy/nXoSaoAgSPoF5nHRH0z12xnTze8YePrZP2i42b5sNmqfL6mWE1qHRO0FmZpVqM6Nk60S7sYXiBfp3NJSFCBChOiWxF1l1jSBe8DD4mRR979r86dKpawZGvzBkMDImk9gQrEf5yZTDQ4qx4qmXKMa8Rb9QwDHe98wS25+DgQMltO3mxjWrOF9Hfr7/Ub+VfIm7x1yBdMJ7M6wNszD0pvU3co3pFRQvUyiJM8JW4H9tnjmWUsGDo9qeSvQvpH0UIC++Xz1VWd5Wdi/Kul9nBgvdfj6pqOxK7HsFqto8p4wGVhZFwlIV6h7XKDifikEJgRgICgvb7SOygLUWYJndku/IKdb
 nfxosfZb
 avkbhep1WvxZ7QqW9pWaxWxQHp9eylsR+VE4d9VSUADwnAXSIZxjsbSpAwOu7B1e37NVjWPp2oIMHATHFTI3zPeInSi38wd982LwU6upUaKAu+x5P4B6iHVBNnO9Jut/nKAHVAMoVCd0wX93Dq65l6boVPRDc/9o55NJ2C/RCwE7oa63XGC0FLMGIKO0UaxXJOxBALD09dY+1sel0u9GWF/VWWufD6sJp1hEcq8ZedfDpEDsxh0EM7SZditXJ7CaB9h2LedrDuZecTj2Mkzm1FJab2gURuj5Q8Cqyr4gafQinSSpBrJpasNDFXauEXl3xrKkcCrB40cLREuSvnLtckKy77c0/U94Zo0iayz4wnicpf+mA9jGYv+y9Fvl5WPDF16yRFCnY9nGPb1iP2a2jvrKvkTHpCHroznjsJ9rwiU4DoYLbBqiq+r5jupC889Fjr9olVRso2Oi7hhrRP5NOVoMx073tYchz9DkQTct3DaEAyoAMm2XOgMTFVH7fLk++paII4FBX3XF6bsTYPOP/Mc+XEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 16-12-25 13:20:54, Shakeel Butt wrote:
> The commit bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom
> or alloc failures") added functionality to dump memcg protections on OOM
> or allocation failures. It uses K() macro to dump the information and
> passes bytes to the macro. However the macro take number of pages
> instead of bytes. It is defined as:
> 
>  #define K(x) ((x) << (PAGE_SHIFT-10))
> 
> Let's fix this.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Chris Mason <clm@fb.com>
> Fixes: bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or alloc failures")

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
> ---
>  mm/memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index e2e49f4ec9e0..6f000f0e76d2 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5638,6 +5638,6 @@ void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
>  		memcg = root_mem_cgroup;
>  
>  	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
> -		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
> -		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
> +		K(atomic_long_read(&memcg->memory.children_min_usage)),
> +		K(atomic_long_read(&memcg->memory.children_low_usage)));
>  }
> -- 
> 2.47.3
> 

-- 
Michal Hocko
SUSE Labs

