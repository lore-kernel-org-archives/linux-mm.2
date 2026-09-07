Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03683C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 13:18:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E81C96B0098; Mon,  7 Sep 2026 09:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E31C86B0099; Mon,  7 Sep 2026 09:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D21B06B009B; Mon,  7 Sep 2026 09:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB7CA6B0098
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 09:18:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26FD31A012E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:18:35 +0000 (UTC)
X-FDA: 85187020590.30.0B83A77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 31BB610000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:18:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7CNazp9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788787113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEWmuW7cufMWV2/b01w8XaTQOw/m9I21NgDQfNHpcUA=;
	b=EakxO+qbeqdBVN3VOaqVBERYQffl2Y2zlNVu1qEaA6yIEQL+LQP/uiH0SnpQ+MbbhAs2Ru
	sYekiEwVFyzt6f3RrV72e8iKNvnnYUHeUeYGO+xi5k2GVM0/uZjfl2QkvaOdYA6LUBT8a1
	K/nDYjVVFx0ZqkBFW2zj9LPQLBvS39g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7CNazp9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788787113;
	b=vTZDUgs95OvE0UtanKPlJsXgF/NUFlQV6WcWwGkKUl7E91Q7H0KvQrxYU3abQEpP1kFshe
	e04RtCbQeFl5Z3kHAu9Jsjl/SSBMSa8kLgIPYIJ9fYqoX4mTs6ttbE+D6LF2YqgF3AHCOa
	I7L178C1EDYrM/jS8wQJi7xrbmaEfjg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59F0542E4A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:18:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395E11F00ACA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788787112;
	bh=hEWmuW7cufMWV2/b01w8XaTQOw/m9I21NgDQfNHpcUA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Y7CNazp9aYy+PdY0qNLl0B7UHZGVyc8NYIl94q4rS75a7fb8BfHqZHqCpHGBY7ozT
	 bpCYs8vIAFiWTPcNj/lChvaKSivlCaFedS6Ze+NtCFryS34HzgcrXFVtO2tOcXATXj
	 aknvYJ11xVYV4y8yNd8VziMCP2T0lBncq/esm+x6+QSPmgy5nksNQSNEfaMp7IoRP9
	 vYRpAABEdC4+WP2xtBFi4jX9ngfv44GbSba9HP9kVPFnxDWZslemR+Fl1L1buFOYDw
	 tuhIDnqUDLUhOdvW78rdgfXZPJD3XBxfgdDBeEEUMsAOf4bwV2JQol8t2DBGFTlthI
	 YPyUwMljIZjdg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c25420fe973so589894766b.0
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 06:18:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzSirIDO1xrAB7faB2yCpclD3sI4tXXqzvP/Ew6Bm6xVc0zt+CXO7SmDTfqCDj2Pt0PxzoaG9wxKA==@kvack.org
X-Gm-Message-State: AFuF++mEsQr59uUcZXbcKXa0ySVLykUEJXtgtmjrd1E0YCvHvp0sEsTp
	yqkwGxUh16UyQ5dJlVdi1ZJorPuE8AMAVCtUz5Ctb/SsNxtGtfU8IOOz8sb1Bp94XebqkjSWX26
	j1FsOYcj5WQZaewvGLoWnV4pZxmNNCZY=
X-Received: by 2002:a17:907:7294:b0:c26:19de:9139 with SMTP id
 a640c23a62f3a-c2619dea0f1mr784114966b.44.1788787111068; Mon, 07 Sep 2026
 06:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260907130821.1726595-1-xialonglong2025@163.com>
In-Reply-To: <20260907130821.1726595-1-xialonglong2025@163.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 7 Sep 2026 06:18:19 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMhs_DQGah6mRfh2=Q_9WU4tm7SsWWGguUt4h7mXiOFRg@mail.gmail.com>
X-Gm-Features: AcwNN1VW7ax0yb2yZAzS8soWDZl4_rah1ysY0avA1R2-TIGVjOCZmj9VVC6GuJ4
Message-ID: <CAO9r8zMhs_DQGah6mRfh2=Q_9WU4tm7SsWWGguUt4h7mXiOFRg@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm/zswap: publish the initial pool with list_add_rcu()
To: Longlong Xia <xialonglong2025@163.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Longlong Xia <xialonglong@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31BB610000F
X-Stat-Signature: d8wj5xpug9ghwo74m69dknuuir79xm5s
X-Rspam-User: 
X-HE-Tag: 1788787113-965543
X-HE-Meta: U2FsdGVkX18y77tWnqGLLy+cskei2CDvnyk8bArs9YTBpQSG94Gz9hjZs/aMyXbaUtxYCB+7XY+W+TYYYcBeilxfiSeKOK6vIVh7R5DQfAxcOCegGs3Yd9hBc3Lo8rNNtpfZ23hxQT9neEwewzeM7JHYmgTfD7RhO9QwoKsPpVQTRZk89muXjcAsrH7HbDY/G9G14jHXden4OeTGJsfSMsQeY8HRDGuS5Q4UMkCMT99eYD4uZ27bEfyWsGY6Q0COW/zaQROM2FLphBcrqjXYSOIy+mXtW2gvfKkcVEYQkayq2Sxd18mGbAfLEavopmGaNvjaRA3suBRS/TFmUMjORexmm8tEeTiyXX79ODC3idepfLLkOL318BN01Y+uQOXWIfzkve4xHriigHaMEQLMXCUo2HjH0HlMju7vcXgpw8SBOiVSUh9zU1XrdBv6nuYrzhr+CvuHRVs6CsmhBsQ8du9Xrvi9zFt3TKRxxv92/d3EHg1tvkZIaryzTg2kF3lUuZTVoAj5wc40I/tHqS0jPaXw/6Qe6HAuJOGYsLhY7PaXlvxH65BwfvdMBu3FLMfbcg8sMuFNvWhgK/i72e7P4N3fSFFbVo1/lY4CaSi1kd3sKrVvkVWkpmSu/ZqbUtSGm1nGQP5TVMDDU+rYgv9eVjDPoJSu7JtAEuAA9Czmd7J0MCAuurZ0/ws2oDzD+Kvq8Z+uFNEs2ykcmVWrckKJSxPb6s4ptCK1NTvuz0Sb35+PkZ91AVYue4PhDLIEoq8pagCKbQFkwRC74etoNrysy8RKTQX1o/354+ZLnLKJYpWDlmlLtJb7iKCHDswbs736+kFDOmcmQLfE+iBo8SkLQCGxZDHSAQfWcPPL2A87S66yvAzTDTTgcpiy9/OsCJCeiBu6Tw6pwRKGX41BJXgvibkrlE/MAumEp71jRehNVKJdT8cKgh5kdVnEBGmtDA9dn8SyLLY7FS9hqc17MlK
 mCAiV+X9
 AxfPIzRQjtn7uO3GAAfPEttuEqlGgYydhyj88SsilPEaH65IiMuURh9zqvKe7Xz+SEAOc1o3JjqFwbZG8S20ll+RxSh7B66h4wBR3llqN/gztFwi8nSLyq6yOBLI3vOFUuaAeyyl/zuy2hcuKnFtrOfNRc/fj6qKgttma2fDr+9Zyd2sV0XLXHoghN0ngryO3Ue3/e+hmlFvi649/PbsZUI+TP1zOo1obi8oujY4vi4YgfQ8y0GA8xOXCE+T0Sy50NdGi8yVzBEgmapT8I1gzmUoofmdniKIIolvfLm+r1KUdN6BBL6Ti9IeeJl2RRXPIanrYlwQym+8SuRhWFD+B5iuWK2mTqeMQ8UCHT6wRrDwZ+xOugGGu+6ceiOw5vDeA3nR8le7T79UDT3qMdNe4PbMFwbCWN2e6AveS+xIncNlVqjHqujBH1GN4nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 7, 2026 at 6:09=E2=80=AFAM Longlong Xia <xialonglong2025@163.co=
m> wrote:
>
> From: Longlong Xia <xialonglong@kylinos.cn>
>
> zswap_setup() publishes the pool on the zswap_pools list with a
> plain list_add(), but the list is walked by concurrent RCU readers
> holding nothing but rcu_read_lock() through zswap_total_pages(), e.g.
> /proc/meminfo and the shrinker count path.
>
>     CPU 0 (writer)                          CPU 1 (reader)
>     --------------                          --------------
>     zswap_pool_create():
>       pool->zs_pool =3D zs_create_pool(); (1)
>     list_add() -> __list_add():
>       WRITE_ONCE(zswap_pools.next,
>           &pool->list);                (2)   zswap_total_pages():
>                                                 pool =3D READ_ONCE(     (=
a)
>                                                     zswap_pools.next);
>                                                 zs_get_total_pages(   (b)
>                                                     pool->zs_pool);
>
> If (2) becomes visible to CPU 1 before (1), CPU 1 finds the pool at
> (a) but dereferences a wild pointer at (b). Publish the node with
> list_add_rcu().
>
> Fixes: 91cdcd8d624bf ("mm: zswap: optimize zswap pool size tracking")
> Cc: stable@vger.kernel.org
> Assisted-by: Zcode:GLM-5.3
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
> Link: https://sashiko.dev/#/patchset/20260906133601.3563324-1-xialonglong=
2025%40163.com

This should probably be:

Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260906133601.3563324-1-xialonglong20=
25%40163.com

>
>  mm/zswap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 37f34e406c8e..cb5a0855fd2a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1803,7 +1803,7 @@ static int zswap_setup(void)
>         pool =3D __zswap_pool_create_fallback();
>         if (pool) {
>                 pr_info("loaded using pool %s\n", pool->tfm_name);
> -               list_add(&pool->list, &zswap_pools);
> +               list_add_rcu(&pool->list, &zswap_pools);
>                 zswap_has_pool =3D true;
>                 static_branch_enable(&zswap_ever_enabled);
>         } else {
> --
> 2.43.0
>

