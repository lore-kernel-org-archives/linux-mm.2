Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D8FCCFA00
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 08:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C424C8E008A; Fri, 31 Oct 2025 04:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF2568E0042; Fri, 31 Oct 2025 04:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1358E008A; Fri, 31 Oct 2025 04:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 976198E0042
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 04:32:41 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFFC91A040B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:32:40 +0000 (UTC)
X-FDA: 84057743280.14.DCE25FC
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A848180002
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 08:32:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XQ9DFx0M;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761899558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4h4q0wa7BdASeLKkAa33sOr+LqpNtBVUob6S/qE5mOw=;
	b=e5Gfh6PTMBl1HeHCbx3BE1qHnGkUmj6IZVsOLkVoYqMd62QALDLq7er+at4l+TLD5ontkd
	3Zm5jd5bPh8tqvB6TlqcJUmXtjL8+Bct/sp8BDFirytfq43ZgUK0plwthCEMF20i55Sjo8
	vqdpxOIF2CuxJqjIfvufSqK8nzvI/2Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761899558; a=rsa-sha256;
	cv=none;
	b=w4BqGHhyVfPtUbQu2ixOt4E2ZAZ9KTxm56+X4OIH/8IJHnYUS4x0b/L0IFheK0QFBrROpN
	T4Fh8dfLO3v+S06GIfPcno+zYVeWYgeQ14xCWrRIKjF7Hb8zckpVhOVGiSrRq0xHsR/vGU
	tD+BnTy0M1vIVAfzu4pSUQzh5y/cqHM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XQ9DFx0M;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf24.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47117f92e32so16543605e9.1
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 01:32:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761899557; x=1762504357; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4h4q0wa7BdASeLKkAa33sOr+LqpNtBVUob6S/qE5mOw=;
        b=XQ9DFx0MMDyUlirCbMoHhL6HM1GLTtJECDPbbm9ptCEtM7RNMGE16+f/LRJV7OiSlo
         4Q4wqpzXrK+kbs95G8y5f3F8y/9lRX4f5hvoj/XxOcoPnUqU9tJSfeqQ2mrNgFAJnncK
         p1bBbpz9b7i++IpeGdK4WCaauhwNVTS8ArIzUpmooTenU0+IA5EBwku9c5nQKuT9aqNf
         EqTFrTefQNn84yH/wTQOlDE70Zb2glJ0loiy32GcTEOEagbSJ/kiEm0YsYbsMZvIyanc
         HPuDWSmHo2DRnrP0/iQ7VwX6l00+nMPJ9lriJDS9seV1YTL3FgkFu4JLKeZv2OU9neky
         3fnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761899557; x=1762504357;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4h4q0wa7BdASeLKkAa33sOr+LqpNtBVUob6S/qE5mOw=;
        b=gjZGnmeDgVMXgQPS8/LYjrL81zcHvEiNrBQpfy5oZXZn4oNM7H7VCt8eRggQpwQR9s
         YAmmAeCtrx6mNkiKIP3Ou2AFnjU4cVmQwUknvmcamYQBjdbDUAorudFrEhizRpjjKeAo
         HVgk49aqBnxWXZFzzmeseR0nqG5s9UTOc4xVvE2IqIdOgl4oe1qOiz1sTt4twRov1KCc
         gA2DatdwjDKUmfYPm5BpvRF787ytEwVNaCZuxDJSE8Tz88wMHO1CaArt7mlsIo6QRVii
         ZZfwbW5hqrkE6CZie8A8yjmqzBWA+xJonEUUroxUJlG8N7oQcoznXfhHpJ3Te+OGOArE
         1Qng==
X-Forwarded-Encrypted: i=1; AJvYcCVpIVyzplC/iuSeeyia4+SZvFxChodJ4Jxz0PaQ4i4XxPdb6u9XcYpuo0gew4kIrW9i1s8Oq71aUg==@kvack.org
X-Gm-Message-State: AOJu0Ywip2N0qvaXk/d/pk6ai0Ns+GPgtBNgpKPcWUuLutuToTSfN1sQ
	ZJ8E9/xcsPqz1+U70RvT5W+wHiJ9iNod7waqBqSbW8HZB6YUnbAc9gHZ2tlHoK1+oIw=
X-Gm-Gg: ASbGncu/+zgfsA/2vKcNS81K0HUdB09QTwEk9do6JHPumO2lsFsQGIq3qKA78SrBm0b
	0qg2ZWXU2ZX0bh0Ip/NtXnFPQD10JMZgKwOXHRH7Day0J4q4IWQY+JQvXI7+teWu4a0uS0rKjI9
	NtCG3XXZHSbwC9z8XrUjvQ3ZK5G4PRS9MpMEyopBS4yDQQa1Lf+jJ9JO76AnDxrhGk4unuEZX8A
	ytyWfz+02z3tNdZXlN6OPQvWCpt5J9IJUaBRcHTsMbl84HTLFSE3F8bX+TnIv0kHlfsVgQ0xD3y
	aRI/uqCVqPe0LzErtyITY8qAFkIccKRyrM5XmYqpjE/mTOHsnoI0Wsixo4grQMtRBPrSOZMiS0K
	oK+hSDS2j/FwpJ4H7wv7OUOSXFGGPZ3/o7AzUmKeVC+xaerQHGWX9FLyZDalRvlhTy14BB29jmf
	rxvXgBn6QMmJ4R5A17nUS6KCvx
X-Google-Smtp-Source: AGHT+IGfDhEwc+4540g9zxrsusq87Jw5oannsM7AsDgvzrefgTdYZ1mcnrXQoAnn7esV8SehlhvpnQ==
X-Received: by 2002:a05:600c:1f91:b0:475:daba:d03c with SMTP id 5b1f17b1804b1-477307c51d5mr21021365e9.13.1761899556870;
        Fri, 31 Oct 2025 01:32:36 -0700 (PDT)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47732cb7f41sm20722905e9.0.2025.10.31.01.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Oct 2025 01:32:36 -0700 (PDT)
Date: Fri, 31 Oct 2025 09:32:35 +0100
From: Michal Hocko <mhocko@suse.com>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	JP Kobryn <inwardvessel@gmail.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 04/23] mm: define mem_cgroup_get_from_ino() outside of
 CONFIG_SHRINKER_DEBUG
Message-ID: <aQR0I9B9b1VvmYl2@tiehlicka>
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
 <20251027231727.472628-5-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251027231727.472628-5-roman.gushchin@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9A848180002
X-Rspamd-Server: rspam02
X-Stat-Signature: cfux8ajmfraehjwi9h17x8rmbfrjp9ri
X-HE-Tag: 1761899558-910052
X-HE-Meta: U2FsdGVkX1/wrXlt0uGVfbuHA9DuNN04ujAdfY5gSZV1lXKEHuNaPUlON0BlgqPebha5IaLsZz4zc5JZhtmpGMyleWPv3hhy6KnXXMiZ/xq0aDuK/JV5Bmg3+5HrCVAC1ht2Q4GuQYBDD2IlW5p5EzoVTFiEUhq+m7b7s7G2lWg7nyRBGi8/eIAkPMiwauYMzQ52IeYSRVOQMtvop06/QfkpnJms3SqvroDJrBFSuSTiBuimZqyNBDM1bfYCGCrEBFcx0Wl5S7uDDOKVtHUwFGH2TlMxV7hQIATqFQYn/tjs9jmVfPopzQNhobeY+Pe3uobkBL75OtjdEsyiiThXjCsVOzox0dYj4kkbFk24D1YPMGQpPNLVUHcCK3DqjNp/kLXIG1GeCC3mihq9FVARkLt4d/XNw9goPR2FaVHQSWcOGJk4kSjemwPbjm2lq22EniIdZtUp7phCsOZWtBYojIgtWy6kRuQarUAPFQLGYnREhebA7sFlWqmnaD9Qv6dLIs+fcYPlSvr0ZvLd0fsQoQjL3piGik1eaBrcjNpNnzLY1OWibZuUsmhIpriK6P/ozgPtpcU25zWx1q8BQ1jYqabfkWzYYCReEM0zko7LEZaeJVKno1kOq9GarIqJF4rCm99Sx3CIBMVBTeq9CqFtT7jMlzjHRcDaOjDG09PLxzzGg+P2IdeDeinboel2Fxm2BPb8KYThBeCnFOUTvxHrikApkhQPAy2iIfQ3Kq+dcu9ZhIt6Y8PQoRMxq9KLj0Y2fzh3u+/a9IeghGOtgHjeC/mjR8S7bk3tTW+3R9+5TunpCx3Zsq50uvVGxu33AH5DnweaKRWYdqK2xT6Gft0Ny0ApX2747WpP7u1mPvO+GGblMkhOzw8uxG0ijjsod4prwB9ZFFy1INEXqumLK44uVfuG8ZvvpGdwNfcglas7skur/5KmAH2LHraKeDDdw/pe1gVppYziS+XifDG16rt
 M38LH+/M
 eY2YpRhoW9qCrYLDSNzCqXxaEP2juamk8ijQ7IwDq8Lxb+S5RzfWCMS7oQj1ixHks5TTxbf8dudkPzpscKeZjHODdvE5N9sRKaLRVB8F7IQ7x3cUrFCykkR7KpKu0H2jXVPGi7DvD8adlIDiDv1xzwxVm2EstU5MlPtZ+vCgLdO6RSeG9MucHesIJ+lRVLIs82m/GFg9pOnG/IF2XrOxJJ/54FoTB81DDdCAVhIyT55ecfg7rTezngud3YM5H9DCr0LtQj0ffxm4DjMqyNkR+7CjoazIoDCDfaKcTkNnNc8GD8r3ZvXgyxPorshJj3QglX27/wb//6c3i+27rmL9Q576QoJMik5yhWsLhght0EFQXSkXeM/M4XF/DEji4m5y7wLgqmijSa0S2sGS2scZ6jXyQ3di1+BbrFywCflQyAonr7lHd6uaR7q9iZ08K+09rALBYU44m8G6Q20362Zdx5+p3nq++6Zzienp8YsuCpAxAY/Rg7W7f2ez5Eg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 27-10-25 16:17:07, Roman Gushchin wrote:
> mem_cgroup_get_from_ino() can be reused by the BPF OOM implementation,
> but currently depends on CONFIG_SHRINKER_DEBUG. Remove this dependency.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  include/linux/memcontrol.h | 4 ++--
>  mm/memcontrol.c            | 2 --
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 873e510d6f8d..9af9ae28afe7 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -832,9 +832,9 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
>  {
>  	return memcg ? cgroup_ino(memcg->css.cgroup) : 0;
>  }
> +#endif
>  
>  struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino);
> -#endif
>  
>  static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
>  {
> @@ -1331,12 +1331,12 @@ static inline unsigned long mem_cgroup_ino(struct mem_cgroup *memcg)
>  {
>  	return 0;
>  }
> +#endif
>  
>  static inline struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
>  {
>  	return NULL;
>  }
> -#endif
>  
>  static inline struct mem_cgroup *mem_cgroup_from_seq(struct seq_file *m)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4deda33625f4..5d27cd5372aa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3618,7 +3618,6 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
>  	return xa_load(&mem_cgroup_ids, id);
>  }
>  
> -#ifdef CONFIG_SHRINKER_DEBUG
>  struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
>  {
>  	struct cgroup *cgrp;
> @@ -3639,7 +3638,6 @@ struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
>  
>  	return memcg;
>  }
> -#endif
>  
>  static void free_mem_cgroup_per_node_info(struct mem_cgroup_per_node *pn)
>  {
> -- 
> 2.51.0

-- 
Michal Hocko
SUSE Labs

