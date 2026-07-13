Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B5BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F67D6B0005; Mon, 13 Jul 2026 07:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7626B0088; Mon, 13 Jul 2026 07:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE196B009F; Mon, 13 Jul 2026 07:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9F76B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:42:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A32531A0111
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:42:36 +0000 (UTC)
X-FDA: 84983565912.20.6CFA71C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADDD71C0003
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:42:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NfpTX4WX;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783942954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OeXxht4zO4qJTxPARll6C6hUG6HETDvT4L4AW5UaiKw=;
	b=Xhb2a9aXu17i7H2BlxDvSUmjUxlEKqbjq4aobASyr4EsU9no3tHfd92Bnpe0SMevZZF8WY
	lsuc1oVUjsXGmibBzf1+Cb6+ydZidDfplLtC3AfEuImPIrohnY7BZiT6pcbxFhCEn9tioF
	LFbYpV9mvicQ5b3LNC5Pz3uJ4veT5/U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=NfpTX4WX;
	spf=pass (imf20.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783942954;
	b=sOMqyYg4uer+l4GkdzqXxteyVU80WUlc9POjywm6UZz7lCvQ8JEKkiHiTW/wEs9cUXr5SE
	Izq5WSyamv1BYI1BRVdt+ExiJn32yA+QxNyzUtt4o+S4yCP93tv7uga8CuksINarraCs6a
	HXD1+fKmDPhp8z/u+oWGhy4oDoM1bqo=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-493ece78b0cso22460975e9.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1783942953; x=1784547753; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OeXxht4zO4qJTxPARll6C6hUG6HETDvT4L4AW5UaiKw=;
        b=NfpTX4WXZnF/9EgSouzox9Hndl84rzLg5Ga8hY6LjdyMXl5hoRqFTPNhlQo/+3kgnH
         eUClYKJxUS/CS6ZFG0bfHNhjBlNeiuJPKw7q+w7IO2e1Ek6y3dWSJBTed92ARkgLD+LJ
         J8gaxH4n32UAkD6fR2a8D0s74ja0KA+4NuoL/E5xAdItvMR6+F4Cl23tpxhwJjVGjcci
         6UmrgqdOrs1vFfrgzCclVcyp6YOlrdj9Iwr04/vTtwtEBxTD1D5mcX8df/rrfWbZbNhp
         9IOpt6eLQp70JlvV+NAz0uiCnovtHOA9qs5gxwC7YVhdhRcUD6Bhw7n+P1McZaOo+o5J
         bwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783942953; x=1784547753;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OeXxht4zO4qJTxPARll6C6hUG6HETDvT4L4AW5UaiKw=;
        b=J3eFt0lMcSH5PxwMve6fSVhH8s3pUxR71cBz6VI6/U6yFZst76t49Mt9BGsxOhqD7j
         IUl5DHMYJ2iW4dTLVW8YQo8glPadciO7DOBypV288XcHyM7e3QpcL0oRDl7rnR6/ASpL
         aSTyK7GzXXv1TZav6yd6FnTP+5ZvCF+gsAr2yKqLJh5+BNVGKt85hq9lsJkvxamHZJqW
         BnLL+QECQLNjyofSWI9BdLzRNkZV8Ni2fYDM2qJNtDTwHZkOdOqjFuwdLa75OT5gnM8H
         cP8Vw5THLoQpjL2aIjv0cjudZohrtOL5bJRB2LkY63PFE+AEf6G9ByGymPy7uX7bXERb
         k3Pw==
X-Forwarded-Encrypted: i=1; AHgh+RoFTgSMzpvBEm29JtHmErC8/awUUk5hWNj2vqUQ2k4H+WROXhBhH4UZVYbhEpU/TVHfp+g0ZHUxcQ==@kvack.org
X-Gm-Message-State: AOJu0YzdwqE3uSTiyy3OC+D09eeBNz3MInuQ80gx+pxFVpZ0m9w8iHqx
	aGjUQdvOqTU7MqKwpHXdh5oo8pGxChqZl5ROwNNarMOs1/UIkxEQdhbbB5NL69E2yqz7VQ9XQJG
	V1EeZuPg=
X-Gm-Gg: AfdE7cndXGgdXNj0PlkyD3jJpP7ictX9l1DPizFNlELkl+i+zBVeQEVGIiSwqINv4bJ
	H/UvIwLItffBZsCm1GU7Bn0g7LUnbSzRt61qxTMeg78bqPm/MlHSxbx8vFOTo6K72IFXmPgzkft
	Cv04Vk2haFSxnh1b6DbU87lFGcqOVNCXnKwrSXueDXVYh4faEKR7FjgdRn3WwwH4le+sonRV/5o
	Itr8hJhn1QN8le3cWGxhibxbeEY2fr5GkA8yqv58VydmZpuWsAILrMmOv6k+UNwwlDItQQk6o38
	LEcDtyw+ZeKriPNR3biKY4jcygJwBsEOQyDIGUDXQZzE59aYubK1yCrr4ZJHaHacJFipWhy2kcn
	vR6FTt+Ox8GJGotJBUtrm4QFQfLoEgoDbYf5u4kRuPHgSFygfcYTEhpM0NkS0nsKLv/4H4ZAY/W
	9amSHqHH82oQ==
X-Received: by 2002:a05:600c:6989:b0:494:ca0e:5da0 with SMTP id 5b1f17b1804b1-494ca0e5dfamr3772485e9.15.1783942953461;
        Mon, 13 Jul 2026 04:42:33 -0700 (PDT)
Received: from localhost ([2a02:8071:6401:180:d892:bf43:a0b4:83b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493f4f09f89sm551259615e9.10.2026.07.13.04.42.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 04:42:32 -0700 (PDT)
Date: Mon, 13 Jul 2026 07:42:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcontrol: factor out memcg kmem uncharge sequence
Message-ID: <20260713114231.GK276793@cmpxchg.org>
References: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713090304.3015329-1-guopeng.zhang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ADDD71C0003
X-Stat-Signature: jqgcmyqmywihxofrhar539du5ut3k3fz
X-HE-Tag: 1783942954-131345
X-HE-Meta: U2FsdGVkX19fg1Y5tnWhPc1ttzlfI0+Uw+TdMNHDjt5m0wcBPRH75BWgaA4O3VpKkqO7U5QuerrmFuhZQ9KqPA5jlqKZc6mxIOxV84eDGMlzlpPDmuuiCvTjTJ+zceQkHhY+VY89OUhm6ZUBtKdVi6ir4XMJs+MD7Hh80QADGYb+p6aNIoNmOqtGKYhcUolphlF/hom33r46OXWln9SPJgAw4Q4HAhjpplO8u+vU/aum8+1bUwbCcACdJi0psfvQNgOLdoOlk81thUcSm1YwxGYkUFUvr7Q954agSVLnNufVDqeEzHQoMSto7zFiBgUESl8YGONMtCrY0sPvErl4M6dHGR2F9danJ4DChpdBYWaJb6mBoQeK9NLdUw8+gHWien2PmVerXu0hPxz06rX5ua9GkAN0mtuKbjzdffFzSJYHC8TbtAYrgyO7wPZxDCglvtFsS2t2Yh5JkrGX9sRhlozq/xlGPKV3Xd+nFUohOjCG7Gho94zQHY8LSJYJVI3tQROUopAOWwoZvlFLzLBDAFuqx8FYw/MieNeP4UPdMurPtXGSagXeIlY07UIfZdR9ciXCZCMbLQK9Iyli26KrfL0wdk0fj9/0OFoiYLsuCZBl77zCdYUTLmtddfHPU+7rLCfh3zcgnAABlNP40xhjbcb/O93qN2XdownRnsf9jw6kWXwdtKqvWiiO7Rc4ujpt+wAEM5CI85zC7igwCZSPrbFyqI/A/sa+VWH5G9A/a7zeDerSz8kf7yuWAb5kmgd7xb8xglmpy+TuUz8UbvZHABQRNVcWVt1o6hZSa1r5U9mfFpgfF+70wc3gqYtrU8lx7MpIspdKk8ABUvZ+dX0Oo5V5hcnTgcAo6dJQVCudKfjG50uPTUjRIOCRGFZ47pgVmAiCo7q44AxHK0H2cecHSTbD45fmwIquin53aC8qMNPOzQE63jq5+Ajh2YL/R7VeHHJ3Dz39Sesrx4BN+mB
 YXFsyror
 XJySBvfD/Xo9/13C8I1fJs38097uFNdHC0MusXxVZtkI+3uCkoCTlONZO9Sm04UBhtM7egHtb4+67soXBKaEnJ545xO0xRIvHMDQMkvEcDJva3YsRkWpW/zYn6sTLdWFul5It0Ry9N+4Ymy/A0w2Hdq4s+lOYuwzsRD9pn8Ew2L8zYGzY0qab375P8SuilsfUR9LThcC13Nb/c6QpIBVWBRS8+ZGtQ0NeJux3eMWQT0UmINsYBYI1bTPM446SeZgF4S4LqQkKksQfjY+EIXFLHAGxccLRPDBq68F1BIupslsei5YxnVqHBMWI7RrvMD8dOH982qnnntY8PletcJERf/jdQKXMuF5NWeTUq/LrnVMRPgJRe2PAtLIRTw9Z1tKW3ucvAfsVIi+E6TQNmUgGt/yddfyUUYjbA4mjDmQwxFmDDvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:03:04PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> The kmem-uncharge sequence (mod_memcg_state(MEMCG_KMEM) +
> memcg1_account_kmem + conditional memcg_uncharge) is duplicated verbatim
> in obj_cgroup_release() and drain_obj_stock_slot(). Factor it into a
> small memcg_uncharge_kmem() helper. The reference get/put stays at the
> call sites, as they differ.
> 
> No functional change.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

