Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2A3D6D220
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D430B6B0088; Thu, 18 Dec 2025 08:45:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6C56B0089; Thu, 18 Dec 2025 08:45:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA85E6B008A; Thu, 18 Dec 2025 08:45:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA09D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:45:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D368134AE5
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:45:52 +0000 (UTC)
X-FDA: 84232714944.06.34E773A
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id 461881A000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:45:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Qt19l1mi;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766065550; a=rsa-sha256;
	cv=none;
	b=eSaclhWWQxYKx8CTvhfZGKOw9+XThR3HEPz5O6dEH7ORzXw4Jnscww8KLhPx33wLrxd8ky
	EYZ0roO4ZaHxdEb6EBQGNBsCUWIKAxvU/b6CKL2wz5Vm7QlX7SR4Y/3WEyRg6LIGDgQyOA
	O7UV6U2zXLnS+BIbIhM5d6YdxYbkMAA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=Qt19l1mi;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.181 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766065550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pvIGD3XhABoeshtW2+k0QV9MFWwD4zZ6lmu7IG4CN2c=;
	b=TcNUXka0A6BNbnacldhkD7LQywaOx5urSMqnbCwafn2Zw/0qXLMdtZIltNzo/1oMUY5M1z
	aUEvv4EeckkQjoCjDx8D0h+0MHaKTaCaAUJ3DTaX5xnqsHKXKhmb/zpG00t7d0ETaJqEJa
	iSQo6BhHggQOqAMtljWjzYOjkKrLOaU=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b23b6d9f11so65645385a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766065549; x=1766670349; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pvIGD3XhABoeshtW2+k0QV9MFWwD4zZ6lmu7IG4CN2c=;
        b=Qt19l1mijht6cqJg9GbJf2zNKgVpdQVTyDDdiYL3axohyIntkgbR0LPxy50nFeAOCw
         MHjbqQE1AALHZy/Io786Ahg/v9K0QQG0FOkK9+p9cY0oCSLi2V7yQKrong7ycEnDh6bq
         SnOWw5sSJFlgkTG3bln1oMIx0a3eHscnVvjAD917vApqwkUDw6M7moX5x6MFtVzWN4dO
         R41aTUb4JohHDJl8bhujrxqsGW9wR1p2nXQb/dqXJaFms7QugJ8Wq0zMdt3zZXvQKWDk
         NgGZcLQAzBwiT3zVBYj96fabGTkZkZVIgZuuWYrdN7TARGfwDBUMZ4Kt+9rHvtbUKT+O
         kEpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766065549; x=1766670349;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pvIGD3XhABoeshtW2+k0QV9MFWwD4zZ6lmu7IG4CN2c=;
        b=VEIRzcluprQHgoUE6VvrBPqu9gNnGWl2GtAPZ1kgwWt9563ukgjL2PHgXqGuGUmbG5
         5cOgn4SQTPgkIsKYSVDg0j1H3rRR1htiSW+95JBJ4pRuKVbR12ffURxnFWKUjaF9swP6
         NbK/1/YKP03cGBGizDacmFnXlPN1hReNBH+6RoRNh6h9i8WrAYw4OI5rGG6RE9x4nIlv
         hSHY2CMG7/BaSjpHvA1vmRLN4aGItHDASICP1FrW+KrxqO/FcmOt3Z4IIJrt8+xrAyPf
         ArYzgqLQIc9jgdSxmFAizvciRzWVdL26IzRfOeww11hn1NqkS2CSxf2HALi1bruqBbE1
         PAbQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW7p9QgrUeyqYPJyQaV1XZjVYlw9Y1EpID9+K5wOPtLoUgnDoDu6m2MCtEjlc1SDE/4yIbo837Eg==@kvack.org
X-Gm-Message-State: AOJu0YxhUBcUoGoQWQJ8cUyBJ9INs1lOT3KJKjfRSu/vzzdO9Gbn6ZZj
	TetAWLjO1TJyzp8XDcUfjCH7If1ueCbs0yWhWICyBaXxA6vVGBx132U5P+fFhOg4Vxk=
X-Gm-Gg: AY/fxX4SVxsySbA0/8OGQsfIotOCGQlcp0N4Spcpie0Akqylzd6MPDf5oudjAhX4Z4C
	IK9PmrJvEiLY304GtkGblfCROWYjNgxuBHNucuWBaDhfgbfD5yng38xBAKXwR/KeovHkazqFAGW
	BTncjdqkd3eAUX4wnJ3tOToZ4n7AikVahRgeYDyqQS+kZLGGiJfTlMl2r+vr3Frct24so60l7nZ
	T4nGMZUj9hKXTY+T+tcG8F+4H9A9cj1yxvLLSbF/nq7oER/as4bwzG+Wiy/4PXiOuXM5e27LD4a
	zvLx5k078hGs49TQOxkoVuJoUMypVkBAGdYTePVlEapeaMNYvCl1jhXQq4OZZcEMSkU5JtUso8V
	PKEVo9byKPcgIUq1grs70n4rPkkpUKixpOwksa7OLMYg2uebYMQj+BPBx6POMhv/95smewLAdoP
	8FBBgrzxTJig==
X-Google-Smtp-Source: AGHT+IHAR30jxVI+lBEnXpDkahfpDPcr5qT9JVMfZp+S17qgX37B1fvWEalT5dou0/zVepFQknr8zw==
X-Received: by 2002:a05:622a:1e94:b0:4f3:4415:e8f4 with SMTP id d75a77b69052e-4f34415eae2mr141964871cf.38.1766065549231;
        Thu, 18 Dec 2025 05:45:49 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f35fd60192sm15091761cf.19.2025.12.18.05.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 05:45:48 -0800 (PST)
Date: Thu, 18 Dec 2025 08:45:44 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 26/28] mm: memcontrol: refactor memcg_reparent_objcgs()
Message-ID: <aUQFiFIsvSez8AAP@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <8e4dff3139390fc0f18546a770d2b35c9c148b8b.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e4dff3139390fc0f18546a770d2b35c9c148b8b.1765956026.git.zhengqi.arch@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 461881A000C
X-Rspamd-Server: rspam10
X-Stat-Signature: qnum13uf6p9xhf6qf3fby7rbzthd3xke
X-HE-Tag: 1766065550-483653
X-HE-Meta: U2FsdGVkX183gTYQ/dSIchNZRatMo24zfHZ9IibbT0MX2yvVBcmbGZvhnEdCHOi3LbiFCaYBraUeSrOq9LuZXhokVnPcvi6jLIOA/hLXMzZZN46+DJGPPgvMUSKCR1Ztkm7fbmwMhL+tKXu3ab37NFYGF1ItJPlboYbFA2+Z4jH0EZyIJTE7483JW6PwgslmDMkIMJLGBcbUFiWLFLHVgulh5XnZ+0j8H9tyWpnmjQ6N1ZET2JHfnAfZj4rCkZLrvZSKoyrN7WySX83dUOWm69mv6PxHVD+sc1sJ43i391buRkDYa7ROmbh69/seS44f9r/jw1ZdBGhq8rTi25LZRziBMmCzWM9d5MtD19et41XM8Iss95F7LpsE1PMoZ+J6Opcln4SLPpFGgYAdBqxcfNrOer+oHFGBY0eDaQrCUNOyTUv6EWZTqSn3iciHS5v4yufWJfxN5NE7V0tqi48s3p9G0ASBOd3vONNWTbO1iIeWT6L9OcT6Wlo5S96xC/LkyhFq16gh8KUn0W1b25YegyxmlNkGqpc0H/hWyJw2Qaz7yJLKrfk0p4bxzuxOgTcZlDySV+mL5fx3maCMzNVuv5v9zqzb52ML7FAvQVygmhxMTfiPVsaz7y0nT81GEhd9U/b+bKs0jJ6Z3cujWou18sDc2/qEhkb35O/4e6WCxuO1jMDbhpmthYJd5F+AXjAwqFPvD1jbZ83QnOqGVzGhxmmA0+mjcgeFI/H2nfgAcBuWLEz7R6TfwzKQoR0eaMXMNtcQ+kU6Aa0GUvdWDKA0pYT+mUU9MVWcTB1MIjVRNuXH7MAvG6pp/TTB4zO/BhRjoxtRNOlTOyqozDDUPfS0rX9hbdXfNsnHMOFXiswHtHZCPKGzIJZNS/jyXfM9fu7ixSsnsY/c0DkM8Rws1y8a8iKfvvIaFnC1jdwPnLt23lv0HZ6d/AgpRcS4euSQqqbR2BeJiR25lomYTnAFM3w
 E7lO9Pug
 4g9nZwTkIWvrbu38C62KNgrPKkazTVAF/CcJ5At+F/hooCoTvx0/w0jXOAOtNNFBIoyolWaUvzOpnViHmStsIzFSBCxRMGRr6gVGyaBzck307q5oBSz6oBplB43bWN6yiWVDPcs+5EpeEXdFuskZ8btpX7Y+2uH0OA1MlTfG+tJalGmTLABJzNpAuANnljfg0OQYPzs6l7QwvUJLTHrOrjSQw5AFLqGIugf41HX7xRyIm4x5exezSLJPGHYk1eAWA/13lUeg08Vu0gbFPc4HKsDO6WmNvo0m0WBi2AUYp6WM2OI2zL6IGpaR+T+q6Q+0srlFIFXX8du8iKXAWi8qnInlJkR2jLJy1F6uzpAa8o7VtlYXVHRx19s9s/ESk1npz2xVrd3QTcX7nfO/Ny8lCBLtir9s3nPcjDjTcAg6T6JrHJB/6X+45OBzxBLA2Wp3ENWda7jfR5gq0ldCCOyftu+RBLNu0WYVqEr1B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:50PM +0800, Qi Zheng wrote:
> +static void memcg_reparent_objcgs(struct mem_cgroup *src)
> +{
> +	struct obj_cgroup *objcg = rcu_dereference_protected(src->objcg, true);
> +	struct mem_cgroup *dst = parent_mem_cgroup(src);
> +
> +	reparent_locks(src, dst);
> +
> +	__memcg_reparent_objcgs(src, dst);

Please have __memcg_reparent_objcgs() return the dead objcg for the
percpu_ref_kill(), instead of doing the deref twice.

And please use @child, @parent (or @memcg, @parent) throughout instead
of @src and @dst.

> +
> +	reparent_unlocks(src, dst);
>  
>  	percpu_ref_kill(&objcg->refcnt);

With that,

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

