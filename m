Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AB61D715F8
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 00:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B866B0005; Sat, 24 Jan 2026 19:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CF556B0088; Sat, 24 Jan 2026 19:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D546B0089; Sat, 24 Jan 2026 19:24:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DEF336B0005
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 19:24:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 380CE1AFFAE
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 00:24:28 +0000 (UTC)
X-FDA: 84368589816.25.511628F
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7151CC0006
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 00:24:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aVifkqhR;
	spf=pass (imf22.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769300666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IudDhyXqckiiU9bY+b5zRXy/CTYJjY9Rh3P/ajW/06k=;
	b=weWO/QGbn9G7qj+L3zGvrTzmgp/Mm9xMV5BhuzeEchBMPmjM0B8TCy7A9RA7rAdzPb1fLf
	11OWzfg7cXHOhz0vpEFTytqUgQbK7N7gVD5cRoCV5Ae6DYn2lpcKNqcDRBi037CWgdWLfk
	7rcJTQrXQoPeDIX6do6f8ufy7jLW5x4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aVifkqhR;
	spf=pass (imf22.hostedemail.com: domain of rientjes@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=rientjes@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769300666; a=rsa-sha256;
	cv=none;
	b=2LduxczfLJxvPQhRVrps/UQ0/+ThvAiuhRYcTy3/+Qr5s0WV7ikUS2AP87q9Bhhg5/np1b
	JaWk7iMFAwd2SDO2SZ+qxN8v+RZVnHg5IJF6mEpYgzWL8w9WK3fDekae7QD30WZsn/cI/w
	Hzr1Xat6kwOIzbq3SDcWKHiAA6rLahs=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a76b39587aso50115ad.0
        for <linux-mm@kvack.org>; Sat, 24 Jan 2026 16:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769300665; x=1769905465; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IudDhyXqckiiU9bY+b5zRXy/CTYJjY9Rh3P/ajW/06k=;
        b=aVifkqhRZs5572h11n542a9FHYTbo2TCI7Ky5eNlNVDwotXgLVwPb87rAiGxa8t/TZ
         HgEVW0PvNO6Q1OQgiESv1Sjz3gBB7tkPD85pNBpvwFOonVrFwDX6g7v/oShPQz961yp0
         kzTH6Wb+Sk9plbccQnuFoNIZS7CudYuKPPcQCnVlMsU4YU9swT+DyRE/Ci0ViicvyfyR
         aTxd6ahhmunOy/wNEXF/FPcnup4M1QOf+0GwE8KJ7KbuUCtUv4SxAj00wRrgzZum00f9
         bagY8pal0ijU51v9x58vSromgMzjRqzrszOALghtK0QyF76w+MpnWiGBoQJ47lj/HNQu
         U0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769300665; x=1769905465;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IudDhyXqckiiU9bY+b5zRXy/CTYJjY9Rh3P/ajW/06k=;
        b=RKTHmCmiH85NNGfaJrCuxMEPDKh+0LFExv76GbCVIDQBIJtuOAoV+Hq4QJfnqN1bXd
         j9EowsJVIrmNs7xS7y4XR3xEvUyuvBTFvgw07Aw8XaWQBuy7D+KWhrCO+sFV8TOBMK5A
         ufySreVWI6BFj+pDigjSX/3041iYNgx0hlut/NTKoQDhFV/hUsa0PttV1dl+FlpRDZfh
         OKzuvvZTJyswnzv2Achk/ThbzV2HlcTcGfwmXRtrEBkCETApySq7EvD69VfbO8V78hB9
         aVFVmMLvpYtdBZZjA7WScdOqDmtvWhefKuBAF2zVFaWCc57Ga4GBIJdOT8ka9esK1/Ns
         CCIg==
X-Forwarded-Encrypted: i=1; AJvYcCW0I38pUaTRhGZF/e11Vr/IZHsmIBeNDoXPYAkbPzWFSJOI0ZVKE2o8VrNh5EOcuQ4+GEZn2NdbvA==@kvack.org
X-Gm-Message-State: AOJu0YxUEboMcgnGVl3A+Dv2xMvm2lZREMq89ZbOhOiqTJQ9mX4eW8V1
	53/BNzUtaojjtjheJVLBEylYgrFiDuAzMkIjxMMJkiHeAc7w47EQadDEs4QdjWEpDA==
X-Gm-Gg: AZuq6aLHaJU4w3Wh3saXOVYFN7SWcLwcCGbm21pb0/ABvDhJeYBB2a5gynQszFvitYc
	nIto93JJGbU8MUC8LvFLG8X+bQCSjelMc1FYXe/UoaAnvvKGlWkiG0TWn+WXWCNWggKgHwxCN+e
	6/KGPMnHEdnxO/8kmp6vgz0onZKmRkkrvcbHvIlIIbhTxQ4qNpUBqdAVOzhQbup1JPfUK+Etjse
	Gj03V+ZiSShiOHW/SzvJATWWiNpO22MVC7RvCYb3NV9nGBhcR6slmNQ/MHzMcfPsuDltemj2x5o
	nIpdUaeeN3dlLINOSGslgBUfiyytrQA/DJQ5XZK+Bz13u3jyHHIl4BGFN4cMKluqieao0zAoswB
	0Kc11g5LVaXa4JAmzmj1biqM64qavovPdgac/in9nYw6P8wkJmJFOmcw26Lo/7jOM0j6PFK/gJP
	Q0quHx8hPbFmBpBOKAiAFvBYwAHQpHttr3yitZM/5P8sCX3vvxyOGAPyXJKSTfrFEyLqGc0T1O0
	RBr7OClDmvhtgIE/kd68v6lE848S9FbUJddOXd2sQ==
X-Received: by 2002:a17:903:1aed:b0:294:ecba:c8e with SMTP id d9443c01a7336-2a8449f6bcamr142175ad.3.1769300664762;
        Sat, 24 Jan 2026 16:24:24 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:817c:d8ee:c019:7966] ([2a00:79e0:2eb0:8:817c:d8ee:c019:7966])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fb03b4sm53766085ad.82.2026.01.24.16.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Jan 2026 16:24:24 -0800 (PST)
Date: Sat, 24 Jan 2026 16:24:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Eric Dumazet <edumazet@google.com>
cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
    Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH v2] slab: replace cache_from_obj() with inline checks
In-Reply-To: <CANn89iJhz9RfpG62kW1XmL1=cTKvVN5kS-KM+TpzE-mPW4WhUQ@mail.gmail.com>
Message-ID: <3212f83f-960b-9a8c-2cb8-d617a201f094@google.com>
References: <20260121-b4-remove_cache_from_obj-v2-1-7213d36b89d5@suse.cz> <CANn89iJhz9RfpG62kW1XmL1=cTKvVN5kS-KM+TpzE-mPW4WhUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: erfhiir7sw8tk5frf3r6zpqn5oo9eito
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7151CC0006
X-HE-Tag: 1769300666-860249
X-HE-Meta: U2FsdGVkX1/vUHTOTpBvIp68OEgoHmVIUFLcpvsycj9pFk9Oz2gyh4SeGGZn+Glb53MnuHtebFDfp12J6IcUQBC0t6fytfnOOfafgXT2QjfMPL7FVEVtcIhDQogkn1eKEUuCW3Nl3Ycx4jCq4rt/YGSOQZmSLDOFJqYQ5meCdJjrR5C47JyPAyQdh4WhVdTWePgSSUtjIq3ljAiEQr6yByCJ4f6LdULYlJ0DzVVnLwblOfvEx030TTYvUedQ+/fYKxW7bdVwQpqvoUIyVo4XUsZCJWewsszooXMM2ONIJKIfTr1sEZshhjAkIDDWfIlrQFSkSxpmBqCL0O+aO7rj9hfemGZ0JdPtLMiE5ZuUlXxX7ZvI1aGctH6oYYQyh1sDyu7vE7+fZeedKTrX7t/yu4NHoXtNGfAZcuVj+jnVq2GOtqKQQrC10eyUdrVjWt+16GemaVvYor9bFUVZH+LAwA2fHkzXF0wnf+CAQ7VX+JyCbdLS5oRNiisuD0INtY9TKdvfis2HOpr2iC2Uv5snEauhqBUJWyCmQM6zV3XN/6yfZN8o7X4UymCESMv1rU83yotPJAcygrYOIv3zAi65rkjsHehtEZ+k/+qDIJaCqpfjlhcfr7SeFtpEpuit6yoHP0MjbkLdHcw/mcOJ4+DREbrUUp0bwIk0CRJjnTHxbI7aPGa2+cpd3ZXhi09aNBmNEAav+rV4D/+Vs1S9syMrJxgeqYCGeN5g619bX+CSLD98kGLzPBfRhiJl1w+WMsMOC6Z6NBeIqEjen7KRfgAxmoGvU9+zSMdnj5zRtJjP9coGdr+HqgO5NsNBZ+HVtWcb5Rbr6RBtYozGzgKytWT7+EQX5RHgWCRvtHPIaejEZ52Ect/FjzzFR3k5xwwpJQJAPAqyolAzebw9yQ4W6oN+9cD6iZrdClpj+GiSWkS1HfoOvR3Pl5yHlm0Oqw/GFYoVfiv6higlNl+jZQEGM8x
 5CLc9ear
 Fyv7QEOn3j3CXNb85vXmuaXijRPWZ3YDWrvc3xFboApZGRSOQgtAQM5roT/lfusENHo8l5lihRz2uC78Uh0KujEy2aPfcnDple/uLsBF4Jzcd+ea/dZgtMT39WYPmb0/cma5ssnJ/2iZb/Sa5rdgHHP3ytxL4xqc8Oer3pGZkEmMzim9wD45UkeFJnwCixlONUrtBGSY7YJJjzh+/uj8DycLMs16oLpvlwJ6d0bEXisNuIWYuI1SkpAT8QlkLTpOLonyFklYZIk8El7r9sIlycoWHRN7n2QD6lXLsbS8rpNKV9sk2/NZliLEMNxvrjF8ZpXxPq+0pBdCXNSMSxauI+YXKjjC3adLxGurZJsFdLTh1YUopTvbxMJyZTNLHCqc+G8hA2/GtBWzsRlj3hGv5/YcFWhaqSFqxKDfYA3g71eTKB+bCMyXG7DTyIxwVoVRNNMXy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 21 Jan 2026, Eric Dumazet wrote:

> > Eric Dumazet has noticed cache_from_obj() is not inlined with clang and
> > suggested splitting it into two functions, where the smaller inlined one
> > assumes the fastpath is !CONFIG_SLAB_FREELIST_HARDENED. However most
> > distros enable it these days and so this would likely add a function
> > call to the object free fastpaths.
> >
> > Instead take a step back and consider that cache_from_obj() is a relict
> > from when memcgs created their separate kmem_cache copies, as the
> > outdated comment in build_detached_freelist() reminds us.
> >
> > Meanwhile hardening/debugging had reused cache_from_obj() to validate
> > that the freed object really belongs to a slab from the cache we think
> > we are freeing from.
> >
> > In build_detached_freelist() simply remove this, because it did not
> > handle the NULL result from cache_from_obj() failure properly, nor
> > validate objects (for the NULL slab->slab_cache pointer) when called via
> > kfree_bulk(). If anyone is motivated to implement it properly, it should
> > be possible in a similar way to kmem_cache_free().
> >
> > In kmem_cache_free(), do the hardening/debugging checks directly so they
> > are inlined by definition and virt_to_slab(obj) is performed just once.
> > In case they failed, call a newly introduced warn_free_bad_obj() that
> > performs the warnings outside of the fastpath, and leak the object.
> >
> > As an intentional change, leak the object when slab->slab_cache differs
> > from the cache given to kmem_cache_free(). Previously we would only leak
> > when the object is not in a valid slab page or the slab->slab_cache
> > pointer is NULL, and otherwise trust the slab->slab_cache over the
> > kmem_cache_free() argument. But if those differ, it means something went
> > wrong enough that it's best not to continue freeing.
> >
> > As a result the fastpath should be inlined in all configs and the
> > warnings are moved away.
> >
> > Reported-by: Eric Dumazet <edumazet@google.com>
> > Closes: https://lore.kernel.org/all/20260115130642.3419324-1-edumazet@google.com/
> > Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> > Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Acked-by: Eric Dumazet <edumazet@google.com>
> 

Tested-by: David Rientjes <rientjes@google.com>

