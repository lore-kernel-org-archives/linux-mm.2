Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24961112588E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 20:19:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1B06B009B; Wed, 11 Mar 2026 16:19:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A6516B009D; Wed, 11 Mar 2026 16:19:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E0276B009E; Wed, 11 Mar 2026 16:19:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 399366B009B
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:19:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DABF48B75A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:19:57 +0000 (UTC)
X-FDA: 84534898434.28.BD06FAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E6F804000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:19:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IiIVDxS/";
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773260396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fkRrO1FIhf1XZUOOD2/4H4AAO3+yjDIWwnQVBW3QLc=;
	b=naEp9o4iM6JBm2Ajoz0IM1GUUEeqGgX3xN4xqdGlpGHJ4jAqBjEYsUF+wQopNIIPCp2lzW
	oZKY7m/vTYE4So55NM+lgtRDEkuXN5h5I6I3QIKU1l+VpWt5SH/yxMHwZ7OMzOk3ljopZz
	YfE5xDbJOwIqUIGkKYNfff59+QwpodU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="IiIVDxS/";
	spf=pass (imf17.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773260396; a=rsa-sha256;
	cv=none;
	b=u+u5bZn7iuXR0eaasV38IPh3Fz0FRWwdOwIuSr8NUV8mud8orl53DjZFruQRO6kQmzhWuQ
	iPi9WTVunpZl57q1R8V27TAcSbT5mwhOz07JcBgGEOqEH+WmZnOPF4tfdEWMxm0byvpZer
	43AFbYobX3dAuzRxFzwCQiDyFEtHi+4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A88464416A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89343C4AF09
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773260394;
	bh=Pa2jL2apofSyxbio8rnUG2GbSKIL5k8URnG7ZyGge7k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IiIVDxS/a0quM8sXkb3+BEwJwyCZipD9xI4sUfSzdMuygf1qn8RLEMjY1dGhV1zAi
	 iK/a3jClhSnzSax7jy7mne/oaT89N4DfPKWJbADyUqsEKEP0gyALW4uyTp49EZboAb
	 A59P5lZgJhwfOjbmjb5ewa28Bx7v7QYtdEXGgNZOuNLJhMzafGSzg2XxVNqsoM7g9Z
	 gcuyygEy1RIkJh/oGcdJfWjKbV1Q0ebKm515Jlx8M0ZT6rXKGA4Y0xllvmsTLXBxRZ
	 wlqgCQpCHQ3G5PEZtDkh76y9Rzx+D69hDt81xa5c+zfVAknzFhfXOAFGE6/HUVxdXd
	 t0rnnPMgUz6dg==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b9434f706a2so29096166b.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU9/78/+EEAbe73Qq7OSaIpW9GiiG5ehkmF0lOva/yJwmyhKf9HdiPm1jteprIBiEBrMiuEvia2GQ==@kvack.org
X-Gm-Message-State: AOJu0Yzgzr8cj4fLoOwessj6VLtUf5Mx9gOjWImE6pMTMjbWJO8UtUNX
	vqXIK07b1hEhpkmbsWv3ubxTi/HWykD7hv/H2gOow9YuTcnN3KpZ7Hd6tso9b07HzZhQdcciYCA
	Yo7bMDbBAJYo9mimlVQQIRZzimEVV18o=
X-Received: by 2002:a17:907:da17:b0:b96:d6cd:29e6 with SMTP id
 a640c23a62f3a-b972e1b00e0mr194279666b.2.1773260393379; Wed, 11 Mar 2026
 13:19:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260311195153.4013476-1-joshua.hahnjy@gmail.com>
 <20260311195153.4013476-4-joshua.hahnjy@gmail.com> <abHNog8CV0mWummY@cmpxchg.org>
In-Reply-To: <abHNog8CV0mWummY@cmpxchg.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 11 Mar 2026 13:19:41 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPeL9j81bYMZ+8DGGj8KbUxh36RQXVwTxqHve_7nHV1JQ@mail.gmail.com>
X-Gm-Features: AaiRm52cagu4YYiBOSaKEy5MarD058OxU_wI3U6DBSzp2_XvMZJFVYn8nici7_Q
Message-ID: <CAO9r8zPeL9j81bYMZ+8DGGj8KbUxh36RQXVwTxqHve_7nHV1JQ@mail.gmail.com>
Subject: Re: [PATCH 03/11] mm/zsmalloc: Introduce conditional memcg awareness
 to zs_pool
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nhat Pham <hoangnhat.pham@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ft5thouy3cbrry3ybbmf43cy8996twey
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E6F804000A
X-HE-Tag: 1773260395-553989
X-HE-Meta: U2FsdGVkX194mn35lscUPoZNNI5wMWJIrLOm+VY8oWCe1ANxjNCX7Fqv2ta4l3CfRubmLDHD9zMX6str15Eq5MI9EJAfzJdhzasgyV2HewaTdjHwa55Ib/ZQub7GijxECUG2xXKjDzCHaHQ+U4f0OohndF+M94QejhbB2cwetL0Cmn0h99cowzFFI2SUVzepmeIMBSV9AWopYwJfG23/xxGsbD2iiDb3u4i+RugpE0B+cM4nXQqIb+yiZ1m4W+kyuiLWfcr15gcScgqll0sItl4q3jnAnRBqnuJCl28B2NO4053b8niRCMi0+FenaE9Fm35YTWIsQl64cd8/wVisI5x6xu8vPjFeVpi/RKjGrvtXrGA/srBJBJFjS3PeVYwZ9hvxVZ5mloir5gGclaQ88/DTs7xK3BUGclelsGc3jeA6PDJzqCk42mAvOzu1JZmeBSQGnSnkqRt1xCT/iQlTpKpEmXRgb9U3cYken2cod6iUf9Wxp9SMdB0I4GWEU+Ms07UBeXBCazGls9f7mK7z9E+8PAkF+Fc4BoXlkGYp6rvMlwN5X00y2HyKqUdn+Rz315xInYgHShcsbE4gKK5lTbr9Fq0+Y8UfgmQuyG+2tZEq+B7+C9PMNA8yo09TaSM99rB6FjxDSsmrZJjEIiwttOt/hAjfxZHE6XHmqY7thD8/fWuVCoiba1wPkwhLA0PjAISKKHkIitqg5CmDGIme92xbh2pRdEMNFMJwsIQHjlwwBjnp30jVPCRTq9Z09InUAbk/DLeYfv2aViG9YUD9rqqeylBSvpMQy52Ie19H9sZ/JAKi36pYYcCUoy2w0bKpGm9LaqhJV1t3t3xN7SsDaNlYFs+2CaKcZ2LxlGjx01veYAhB7nkm9g00ypbMJS4ozn5uodq3GL3QJwj7DX98Z4y1NPkcpmgj+2SZrRNkWGNyrU4RAny3F4mum4KacbLTHM/MRo8cTX5hNAoVJoJ
 ynARVFkj
 767O3uD1B75w5i+r/LNBf1+RPyop+f50ytqcR2ye5cjuMEwhZFrI2pP56Xn7ci8sq6UDeOGhE8K+3uolrnil0NdtNtl8t761BzGLOK20cDJuA/QQ9DH6l7FScv/yHbJvda34T7Puc4Dnfc1UzFpdKlc4dg6lmnwnja/6a53GyxpWO0uHP+ER7+4Rgq6KfMvINn0oYC+TCflb+SftEnhhAI5K1aukif55rULlgmPoNetgVvXeGiS4/zUzkX8DqWuZXizxUp3l78guDTH7mI2vSh5Z0hQZvxeTVESdNpo5LUtOZ7KUX9sK0Jg6GCas/+MC/S+dVBiFrjaU5g9fZJRqFO6auuyldKWBksRAGl+cy/vRfH7pIzMAlkAebP2zrvrKOrOAvyG6PhOH+92jVVQwJprtIwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> It's a bit awkward that 0 is valid (MEMCG_SWAP). Plus you store these
> values in every pool, even though they're always the same for all
> zswap pools.
>
> How about:
>
> /* zsmalloc.h */
> struct zs_memcg_params {
>         enum memcg_stat_item compressed;
>         enum memcg_stat_item uncompressed;
> };
> struct zs_pool *zs_create_pool(const char *name, struct zs_memcg_params *memcg_params);
>
> /* zswap.c */
> static struct zs_memcg_params zswap_memcg_params = {
>         .compressed = MEMCG_ZSWAP_B,
>         .uncompressed = MEMCG_ZSWAPPED,
> };
>
> then pass &zswap_memcg_params from zswap and NULL from zram.
>
> > @@ -2071,6 +2079,9 @@ struct zs_pool *zs_create_pool(const char *name)
> >       rwlock_init(&pool->lock);
> >       atomic_set(&pool->compaction_in_progress, 0);
> >
> > +     pool->memcg_aware = memcg_aware;
> > +     pool->compressed_stat = compressed_stat;
> > +     pool->uncompressed_stat = uncompressed_stat;
>
>         pool->memcg_params = memcg_params;
>
> And then use if (pool->memcg_params) to gate in zsmalloc.c.

I like this.

I also didn't like the suggested prototype for zs_create_pool(), and
didn't like that compressed_stat and uncompressed_stat did not have
memcg anywhere in the name. Was going to suggest adding a warning if
memcg_aware=false but the stat indices are non-zero, but your
suggestion is so much cleaner.

