Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EF74CAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAB956B000E; Tue,  9 Sep 2025 03:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83556B0010; Tue,  9 Sep 2025 03:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998E26B0011; Tue,  9 Sep 2025 03:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 892436B000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:40:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29F851A03F2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:40:56 +0000 (UTC)
X-FDA: 83868915312.22.942BFE6
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3689B140010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:40:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=E91I0yrD;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757403654; a=rsa-sha256;
	cv=none;
	b=IUTAqXTnMflRKtrjpYKfwoC+JqjYpTpI+zpltTPqwBhnKD3tIr8yUI7yr7Z99FwdbJ3RnT
	wZ/zhIJYE7EB9c3dYdb7BIw1v476WNLQgrUUlP0KW97PEzkDGTmjKTJGpr4xS7a0JGEiHR
	WkR0cDcj3pBLmrl/Zs7r7bg156FkpLI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=E91I0yrD;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757403654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u22boo28UvFDQfs2oEw/hxJdzWFKv2Wia7rhjSS9eNo=;
	b=5DXMJF+apPN3dlYJ7vyasRyh73avlJhey81aLRxV6Gxzg6W1K5l2ZXXZy8HIhXntUV/DKS
	pvCJHZXtww6PJYpATHOVjgXKq/JKQtzcBki33aLWilWNN+cMOZui9bazkbZ7qiNIixabDg
	pg1FaFz1F+l7/pDilH2ESOO4XV0TOzo=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b04163fe08dso898461266b.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 00:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757403652; x=1758008452; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u22boo28UvFDQfs2oEw/hxJdzWFKv2Wia7rhjSS9eNo=;
        b=E91I0yrDbcu48Yq65g4shdImQlxfN73AII4X+4jAYZCHwwarOHyDCajDqlUkl8CbMo
         JRrY2rZxWjAm43lVAhV5C8fvvt1tknmQCxSuSeUBtlArsFpBlEeaMYfHobJN71RtvLhM
         PrCvImgFMhxKJBiifbImQIZVbrP27fjKIknYKrjy5WBdk12WzO28n/PLVspYa2dFNdy6
         fWZXzZ6qNGEDYyFC5QU0AXIQqz2V6Mz0i/MM2Pg8WOBKQL2fdB4VqRZBaaFlyivRJVza
         jL31IxuXyci++Ydd3KBPWpNMKA/amR7MAHyr82rA1BFVmLPYSvxWnnovmImL3b02QJdv
         ZKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757403652; x=1758008452;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u22boo28UvFDQfs2oEw/hxJdzWFKv2Wia7rhjSS9eNo=;
        b=qk1K1kIZIGCe7BcSe64LXJQE2MUuPwA3E9LMjcUqkunh4+NeKnOmBPXZAvUes675/P
         Epv3VixGLZr5XHOUeUqhf4z3IuPNlzVeM+Ixh32QSNFOI1Xw2TNOry1mJTt7S4GWV2x9
         ZDL5HVN0EqoVWWTezvf8F0zy2eUW/0T/sF0SBDjAURJUsVv1ymnmV7YqsZNY8HcitrUM
         Sp5fsGcJltNd9vKotA5V5zhMW0iApyE6KVXoY1mbbWX2OB2BP+reCM89T8O6PT3sgaIp
         z5lUFWviNQrIpp8v82K0AcrmsOhgixzCCqMNZn9e39+QzrdUIeL1/Ur60u9UV7Iu5zZp
         w30g==
X-Forwarded-Encrypted: i=1; AJvYcCVbGnFI4u/k2CrQxip9dCD0lHpPIGOL2XoMy0/isGqpZ0cwcCFnwKov4I4CtF3CMtrewD6XkTGadw==@kvack.org
X-Gm-Message-State: AOJu0Yyt6X6bbyYwOusvERwcStZMIzsnUarzHumn4q+FatnK5I3edhOR
	pDq5SZuz1JvOYvA95JcPXKA/Evt6og0kjfwm3ib5w+8zMOn0kBoTcnecBoqHx2FRKIc=
X-Gm-Gg: ASbGnctQ/BNDmnAqLctNhCxM5lr+wu8IXFKxUqaEBvi1CEpUwv82tTQK9AvUCwiY6cz
	mV3/8sad5k4ClKe+I4dC4NTaifNQcZzUOeXhA5s1zBw2MPiGbG1DGDy+QdpQV4LqH4uvqciiO5+
	HkcvJJw+EJPq3TMLFtPiWRu2Rq94viehjVlmgqtCimEumtI68vroi1KTOu8HNBmOSJkiupaBjrf
	V3MP8mjZKNMnVY2nmQub2SCzSkLo+e6fnGb0u+9TJoY+3+OA4Stnyp8LaaMeVkEGEydvhTCxNJU
	WtSuYBAQmvB3zy75TnqpIq0ACo0bj3mZAjFQKeZskVCVu3eaWCYOf5ABh/iv71ZNkGt0npXhGWo
	22MOcYgzjwC4v66q65WU/jPx0F52KjYCNaAzlfVlJ7p9e
X-Google-Smtp-Source: AGHT+IHDPUSJwJ09FmuKcRHCbVb4TRocjJO5VHcQQhngEcihEY5pYVTneb2uR9H+cbvN0Kp9WTpARw==
X-Received: by 2002:a17:907:d2a:b0:afa:1a67:e012 with SMTP id a640c23a62f3a-b04b13c1530mr865161366b.8.1757403652476;
        Tue, 09 Sep 2025 00:40:52 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-aff0ed6ffebsm2543940966b.32.2025.09.09.00.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 00:40:52 -0700 (PDT)
Date: Tue, 9 Sep 2025 09:40:51 +0200
From: Michal Hocko <mhocko@suse.com>
To: cuishiwei <cuishw@inspur.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
	hannes@cmpxchg.org, weixugc@google.com, david@redhat.com,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] disable demotion during memory reclamation
Message-ID: <aL_aA2HKjfmwBaJ-@tiehlicka>
References: <20250909012141.1467-1-cuishw@inspur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909012141.1467-1-cuishw@inspur.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3689B140010
X-Stat-Signature: h37uhk6yojahdhcuxmaq99kor65eygck
X-Rspam-User: 
X-HE-Tag: 1757403654-156395
X-HE-Meta: U2FsdGVkX1+8Wqq8YWdCCFgnRD+NMeXyiWwbmT9s1rFCExx3/Zx9EOh1PCHpNid4XzHO/73H0wHktT1XQYcao/1fDfYDjxOKZ3X9BtDzskeJSObgs3LrOpOSlSty/pnKudeCZbSAN8xFH4JIRaAdvOmdggDsyLcAFlcer8npkiFwFl9ehPuRYIFTuzkdwrbkwMwIynV9LIF3/ghEr25mnXdxQup8zWoMMm2rvYLrWbqrV6KtxUcNIvmRanp5nuaUK+v2zqD+raFHkX9fa1pw/Bx/jMNZq93G4+2sZEzNHvAI87VKIuUznzT1XPb0oO7ikn+8PCSDm+WnLJOI5FL/OlXtYjRBkainvi2aS8Ua91uz4bMpM6ed6vdvTRvNaM1eG/Fjj92qKCPHztW8bGdRqj8/AnJMA1JwxuXd6jHdlei/71K0Y3ilZBV2zXjT8oWk6xxvd6NggQ9cmd2PpIuNnywAIqhpcIyOPkoiJfe5FHeNaGrTLfulk3rnKaUyOHtC2LzDPuYisDemCAXFYKvOG7gj2pUO4j/l2XktbxVi54lnX8utVOV1Co4hBpTghCOy19rdwTQBlwaIsKLIlA5dqssCGU9RM/B6Xz8NRsfrg6LJSnnaJ74oVE/+j8ABrrDuJSsXEAY/1MDqz0QhsIjmkgHyFYQAwSEkzpMdc4nxRGCRtNHnkgMKtZX/qPKRfVPKI/DZYo2yGFhjMYW1wvsjDbKx7SrTw2wBtf9L0l2dF1EySSY3doLH8U6wyH9XTHh6Ej3/NYrj7nx+Wr5WbIMWCwAynOZP5vgLQmOjusJ6yctPmdtrpFTxC5Bt8DdDxS8UnbYz+Q5rnuA4NGyxUeSMjU3ExXBkej6z0GgzQyupB2ujkM3MHXf/rW2wZPGG3D7BaBQLjc4YtiEBhzrlriEC2NzptrlYzh7qYIio/p+HDZS9THg3NDL7ut1s0wijt14UvBoK1wjDi6FL1nO6TYf
 cNltn6Aw
 PAVEvlUQkdWDUlabC6JgxZfPjNhlMdOShiBw6s4T1Fn85PDLWV1eI7EEAealdbDFCT+GumisEOhLlLpVUV3XXL9yS9RlRvyPP9seVN4ZOHNKnNzG3mINgylSWXoYbUjc3R+HfCotsB7HDBHri5LUitQ2sJqRbl/QnqB9+B1vEqsCM20+ZOAS7pHif5ylwM5MxBVWq4VbBBpa8HPdY2mkqhZAsSn0kjx3pAmmzrenMCmKlqSzMYu4rtRcfptVA0Ffi6XTCStQMiiTeuimO2IevCazeUyJGs+tSi9zU1XeklgzXa0WRHE6Uy9bPnuzRFQRgpnPC9SjeSmiaii2Jz8TacRgKd+YHaLHLWhaxzMNIm9K4SRxMuAYC9bmoUw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 09-09-25 09:21:41, cuishiwei wrote:
> When a memory cgroup exceeds its memory limit, the system reclaims
> its cold memory.However, if /sys/kernel/mm/numa/demotion_enabled is
> set to 1, memory on fast memory nodes will also be demoted to slow 
> memory nodes.
> 
> This demotion contradicts the goal of reclaiming cold memory within
> the memcg.At this point, demoting cold memory from fast to slow nodes
> is pointless;it doesn't reduce the memcg's memory usage. Therefore, 
> we should set no_demotion when reclaiming memory in a memcg.

We have discussed this in the past and it is my recollection that we
have concluded that demotion is a part of proper aging and therefore it
should be done during the limit reclaim. Pro active reclaim through
memcg.memory_reclaim has a slightly different semantic (see
6b426d071419a).

I can see you have replied with more details to Andrew but in general it
is always better to describe your usecase and why the current behavior
is unexpected. Is the memory limit not being enforced? Do you see
unexpected memcg OOM situations? What is the actual problem?

> Signed-off-by: cuishiwei <cuishw@inspur.com>
> ---
>  mm/vmscan.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ca9e1cd3cd68..1edf618a3604 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6706,6 +6706,7 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
>  		.may_unmap = 1,
>  		.may_swap = !!(reclaim_options & MEMCG_RECLAIM_MAY_SWAP),
>  		.proactive = !!(reclaim_options & MEMCG_RECLAIM_PROACTIVE),
> +		.no_demotion = 1,
>  	};
>  	/*
>  	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
> -- 
> 2.43.0
> 

-- 
Michal Hocko
SUSE Labs

