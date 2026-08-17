Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF57DC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:30:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF5D6B038D; Mon, 17 Aug 2026 00:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0226B038E; Mon, 17 Aug 2026 00:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E836B0390; Mon, 17 Aug 2026 00:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 304026B038D
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:30:53 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3198F1C19ED
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:30:52 +0000 (UTC)
X-FDA: 85109485944.17.2F07551
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5E71B40002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:30:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PCmo9Li5;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786941050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzHa46yoeqtsHFObqgwtZinJ/lnkplRZ68OVnoGli10=;
	b=v0jiWR+APkPmLBkgMfQCgZZAu/n8L2IrgWU2rNEwvPUVYI8ooyX4IKZ00qkP7O54GDELcM
	NJvWdGW9p8tKUTsDmacEOtEKcEzZxlCG7ItrZaSb1Ua/W4ZZRoNW+28d++wded1p6kyEa+
	E49T8OPdqoQ6jcEFNQSsmUH9RrHSybw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PCmo9Li5;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.47 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786941050;
	b=BDmZz3gbZoEQSoLqQKG43XS19sf1FvvOimMzDviS7d5yx8Sfsh8vdsoj/duztfYgf3rrxV
	Rfy40l4Y8+/fPptkMKE141gJuVXRa9tsikCN1Nbg2arxDgpUP2F2kBHUTH+e6pWv4ghO0p
	OTtjM1w/YQG1UmAc4v3jNNONA2SVBZU=
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-44856d185bcso1839290fac.3
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 21:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786941049; x=1787545849; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XzHa46yoeqtsHFObqgwtZinJ/lnkplRZ68OVnoGli10=;
        b=PCmo9Li5yeuLVRQUajh2fEWOrjN2LTb+UuneuA7+c17X0eyiQOgbL8S5hOjKWaWJ2N
         4hn+8aNIDwthbdFH6x7lb0ywLtJWVbHEqrrrNOJ9bOXFpmMsZ8P0dxiPXN/6aD5H6oGO
         EbB8jVpLqRUheEbYY4X4ln/5C8fGnZ2mVZP/rBkvj8Thjwaj169my/wEsR5PPXGv6Me9
         BoewvKmC7GY9yeryjc2f2VM+LzijjWxNMTUSKFg6Vv/7Im6GqR56P4AcFOac8zOWhBvy
         9SPVJ2c267icb4J8lBdFdTj36uqvjtQbHFADmwG8phqxv0avvzFkjsJTPNS3qDAio8ZN
         oB3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786941049; x=1787545849;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XzHa46yoeqtsHFObqgwtZinJ/lnkplRZ68OVnoGli10=;
        b=JDGMy4lOQuL6g4NceYZa9wxQe7pOgEiJuHj/EYKYx+Y/eI08MsJ1GRtQIUrPuE54K0
         yZ3EP+O0ix3g7yLwxXDyfwFq/5HsoH8zE7L9K4XXsMFoFtj9/4lNCcOYJELOcsoiTYEM
         msUtNJHlQEsI0BGUFYD+aoNIUETF0e08grNMkOofMkUbykSUt2RPa0kWng6QvRq0EJ7V
         5Lw8kLDIuOgbun8BDdIxciZKZ34W9t+us/E1pq241RWOIjkCyBNNU5A3NddwAowqtZ4a
         Q0Mmz2Oey9XalpQIauH4K9B6phBR+xAXEuhYiu7WaGs0qL2xKEYmYU68h7OfcKa0DEmB
         3s0w==
X-Forwarded-Encrypted: i=1; AHgh+RoGcuYU4wm1F9Oo59UnbJC6id0EBkzdu5NNDuy1So/YuiKvyQGe3IIht+IPAPYUI9RGxaxKNXbV6Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1TI3u2PPpLmlbd2ZppycFGFGYI3N4ZsYSHohV7wM0DdRnpD0X
	NvWOn1Xuecq7NJinZQvmQCxSK7es0cGQqg6qxCqx/0Sl2KV+5ipJGdnH
X-Gm-Gg: AR+sD136mDLko/elbyxN43rn8iBhwF6zGK6TvEF9K25fNy+wX6F9GmKYcQ5gAKQY5gi
	6r6AVQN9mYNtRdTt7YQYHIiAhggswL0ILCTiDg290WJbz58hczrho9FaTj4PM9V6l8ZoQgSOwfU
	SMQiZv/l+61MKbJTlNsIiIkHq8TdBtfRzeehYUPyzRiJQJI3bOeNtT2+N6iH7D8HAn7qbLzV9mc
	4FYceyiFg952jvx9sQgAt0FpvHsmtpxorpuGuQ60cSiXh5Ct5zdSVzBetlqb0Zq0r0UFeMk31k5
	dm/Bikt8tE4IgVvW/S/99ZmtjROCNVDnd0ZQJEbydPZl60XVcmPXqRNOYBc/N8Vm6kOKF36+mJ1
	2ccKvx5ptkvy9yGw+IGl51xvWbuH/mXQq+DeJUc/juWTTNd8B+51EHApyqcQkHNXaeTD5wf1dZJ
	toV30rHVXj0QO7+5ulFqvEWwUDthoPmofLD1LFLrlKlP3P4FN36fQO93Y2X6HGkGBaByI2kdNxg
	WBBWPfHGrY/4MgYPX7TdnJQ79gqePy3Iw==
X-Received: by 2002:a05:6870:a085:b0:442:175:cea9 with SMTP id 586e51a60fabf-45e91df60e8mr22649897fac.7.1786941049279;
        Sun, 16 Aug 2026 21:30:49 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-45f22a7f3dbsm274098fac.1.2026.08.16.21.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 21:30:48 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Song Hu <husong@kylinos.cn>
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	zhuhui@kylinos.cn,
	joshua.hahnjy@gmail.com,
	audra@redhat.com,
	bingfangguo@tencent.com
Subject: Re: [PATCH] mm: memcg: flush empty per-cpu stock slots on memcg offlining
Date: Sun, 16 Aug 2026 21:30:45 -0700
Message-ID: <20260817043047.1553572-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260817025917.66233-1-husong@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E71B40002
X-Stat-Signature: czxi15ug9dyj4wazhbj6qorqua5irp33
X-Rspam-User: 
X-HE-Tag: 1786941050-648354
X-HE-Meta: U2FsdGVkX19Ri42784AriKYm3lRt+88n9NA25WMVomH1OfCEAJp+kBgHZt2iDYvglYh4Ej35DLW4qlG+H4ns4FLic1V83CgklSHsbq7xZJzV9V3qKOEfIy6ssZkBnHBLnT7ILnpczzw9PseXbqyNVMP5rOXmEgYAjx3HRYL0xchAg7JYesr1O45I0DLGIzSOfmS8+XIFOzdBAaUvP3pDfaKo+cmvOstxdFedcKk44PBSfvA/W8YOaUGT5urqv4cXyDvVvQB6uzpNhSZGmj5YRYGBIPvmnoiddl7hRasMk0GM+LtpdEPWwUJcRIf6WlrvufJzFaB48ysZpUJXeomEr4OBdqR8TobFMoyEXN0dM3b1jiYrGMH/iHDnF2hWjEHnKoDDdOF0YEsRJZ+e6TL3HDotIiMFL1tyK3Ig8fhKeX9ZF8KReRNiqpMinQpEAA4XwMSzRkWxRpNyRJKdedtvY49o84k9CAaQBIuakdtMGAl4HWLXbYeoODWpfdq5jfVeoZAZIzywzr6QfHdbEQMLeIu0+FZZPvgxVO4jmnVIFZEuJViV95W1RySFPoNgBAKXPw1q3JL8DDtM0cwVCTSlXTE0IhGhERcjH+MyT7XI5C4gWSb3i4jWKZJB6ljUn4EfxsaF63QFZ/M5lzaJ1gOCpN34vrAiLKGOZHm8Wjm/iWt4YzG4q2c5kPYzJvw2KBzTQ8cjCmMCNICpKGPqXliYrGeVtRMiF6lE6R+LQXkoOog1AcRiu2V/4tJPljVomrTmcBPdLrPQ7YxA+6c/CLJjSkOtHtHOuP2Dym17GyJdEkHIntoTSjxj+aELufNwTlcBxr93ItcTuOZ1xrSu+2bE0uRWbNKsRbZQDsb9SYXDhjX5De9HdGVRtmdlL3BuJA9UUEwqZq2zHRopw84lpzC9a2ZF/z9Tj+hznTPW8DOwC6LRpCxNkEAbR70p9Ss98IkIb/SXkkJjvO5/VYRIST2
 7zgTVjOG
 Fxlr70wncchKGGqTYvARqd7F+jeQ9mHUoin/T8lLqk7eqbxrFHLHA4kfqOCBJVgJYR6CuhkXuT8e4agZsRmFa+s/5d98JdJiUQyPs1kWy8kCsBkGxWdcANL/E8Hwk897vJ8JYVT4htVuWOjr2zkIcAzC3AJlJB4wxOKrrxOUkqBPGX02OEgwDj9nSbGtliQcx317q74nsNI46rYxSD5tAEZsLBuaJ2hLbspGI1yWFt1qEV2EkYO5l+Knlceab1tsXFdIkYI7Rf0nDm5h+yxCjiKu3u1QDN2MThxbSHgpzGTad8bSN0x1rQEUO7vTcwjIJTnN2dXvmd3HPIndWGJQU6UvQAR2UFGd/kol8XOaHxy49dE+/Qk+ZbA3uV0Dc7d996+vQJ+e1wq7KrCkMF+F2FtMHjuBgvp2iGw6jIV/QgmZWJXFo6bIHFLlApmvKPR985kdn9fH4I4B1pXfeE7nhkRzy7Unkk7HLiFD793xg+mEnvjd9LEepODYfe/2FaWkKydhTN4GOl4D8NsbBXTaGuUCc3VLFQ38PSfgAIYJxzX+AtX6NRIF6KlCW3TJXerjK/LzxibcW+l+fLUmPPG20gqfnmfeh8lty+oHP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 10:59:17 +0800 Song Hu <husong@kylinos.cn> wrote:

> refill_stock() takes a css reference for each cached memcg slot and
> mem_cgroup_css_offline() relies on drain_all_stock() to release those
> references before the cgroup can finish dying.
> 
> consume_stock() can drive a slot's nr_pages to zero while its cached[]
> pointer stays set.  is_memcg_drain_needed() skips such empty slots, so
> the offlining drain is a no-op for them: the pinned css reference is
> released only if the slot happens to be evicted by later unrelated
> charges on the same CPU, or by CPU hotplug.  The memcg then lingers
> in the dying state indefinitely.  On a CPU with container churn, a
> per-cpu stock can pin up to NR_MEMCG_STOCK (7) zombie memcgs.
> 
> The sibling obj_stock_flush_required() has no such gate: a cached
> objcgs slot is flushed regardless of its byte count.  Drop the
> nr_pages gate from is_memcg_drain_needed() accordingly.  Draining an
> empty slot is a single css_put() and a NULL store, and it happens at
> most once per slot per drain, so the extra work is negligible.

Hi Song,

I feel that this above statement is quite misleading.
Scheduling a drain on a memcg that doesn't have stock eventually
performs a drain operation on every memcg cached in that CPU.

drain_local_memcg_stock
  drain_stock_fully
  {
    for (i = 0; i < NR_MEMCG_STOCK; ++i)
      drain_stock(stock, i);
  {

Sure, for any empty stock during this iteration drain_stock is trivial,
but for nonempty stock that happen to co-exist on the CPU, it's forcing
a cache miss on the next charge.

The problem that you note does seem quite real though. I think a less
invasive solution could be something like

if (mem_cgroup_is_descendant(memcg, root_memct) &&
    (READ_ONCE(stock->nr_pages[i]) || css_is_dying(&memcg->css))

By the way, I think the argument that "obj_stock_flush_required has no
such gate so is_memcg_drain_needed doesn't need one too" is also not
really correct since a dying objcg doesn't flush anyways. 

I hope you have a great day,
Joshua

> This is easily reproduced with short-lived cgroups pinned to one CPU:
> 12 charge/exit/rmdir cycles leave nr_dying_subsys_memory at +2, stable
> across later slot displacement.
> 
> Fixes: d1a05b6973c7 ("memcg: do not try to drain per-cpu caches without pages")
> Signed-off-by: Song Hu <husong@kylinos.cn>
> ---
>  mm/memcontrol.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 17da1f43b7d3..b931ec16bb82 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2291,8 +2291,12 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  		if (!memcg)
>  			continue;
>  
> -		if (READ_ONCE(stock->nr_pages[i]) &&
> -		    mem_cgroup_is_descendant(memcg, root_memcg)) {
> +		/*
> +		 * An empty slot still pins a css reference which
> +		 * mem_cgroup_css_offline() relies on drain_all_stock()
> +		 * to release.
> +		 */
> +		if (mem_cgroup_is_descendant(memcg, root_memcg)) {
>  			flush = true;
>  			break;
>  		}
> -- 
> 2.43.0

