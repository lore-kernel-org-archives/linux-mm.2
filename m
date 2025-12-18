Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AC5D6D224
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5066B0088; Thu, 18 Dec 2025 09:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A633E6B0089; Thu, 18 Dec 2025 09:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944E96B008A; Thu, 18 Dec 2025 09:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84ECB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:00:56 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 308381A018D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:00:56 +0000 (UTC)
X-FDA: 84232752912.08.840AB9A
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18C35C0016
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:00:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SQq0ufzK;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766066454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gia3XsZVU5S68keMVbCpat85CsVkLa/AQdgBIvpcJZo=;
	b=z3d+pqIXhm47S7G0y6g1f37WNWTIHaSUuhrpBEb4z31Ezb7Y8O/KVjBgEd709xIgplU+B2
	fip1+WIjBEmkrO41VYSwJrnW4KsT+3V3IyoY8KsRduBVsYOgG3Xoozm5UqOGrgouIlrIxl
	0rl5gAvSQZTbVbmZ47Z1FpBXLWC79jY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SQq0ufzK;
	spf=pass (imf10.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766066454; a=rsa-sha256;
	cv=none;
	b=c91oXlc6WfjquEQjxn0I7WXr4xHFc9jHv+aXN0rHLVrrBc2oHQ+8vaj1OIqHDzbzCbtswb
	vtNIbz5hPCeT1k1amZjbphL1sVyGZN1cy44gkX6Os/P+Z1FwkVF/SilJPLgmt65HD3a4ps
	WtrNLnAjllOaAgEkDQUbROtZqMjolBw=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-59431f57bf6so703703e87.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:00:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766066452; x=1766671252; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gia3XsZVU5S68keMVbCpat85CsVkLa/AQdgBIvpcJZo=;
        b=SQq0ufzK2ruHqKL/hCQFA+Zj9udfRQaLfjROTlhOYeD1rE2ply5XSvesAUJIA/dWBX
         XDvClupcWnNSkX94qOebNmtU+PuwX0O2rj0Uxo4eh4IwAyQk+qHtCxdUhDJgObFF93jw
         0gaxWEHHKqKdps2+VDlKZq45iNE9pb5myiGq11BP4RqlQVXWjLWNB5TQFtl6SB0sWuvP
         wMgQqQJH9kBfRfxhrhGI6IXBezMAhKFNL3LKb2BOPzuJ64WWQgN9GrfJWJHWLASrhgCu
         HcDfuoBJ6YlP5ouXC9bdPiRFC4XnuhyTu+BnUA+zMUrc9QHjdBoYvjGdYOx96LZS1icy
         HqoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766066452; x=1766671252;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gia3XsZVU5S68keMVbCpat85CsVkLa/AQdgBIvpcJZo=;
        b=LZnGDUa6geCrlG2tRoSLj3d6b2e9uygzG0ajCbLZa3oYI7+14kUjgrGcBDhxW/s76k
         fJTSZs6gSZdAjhjh3DQaWA9NWiQ9Y64Ge5lpJBz9oTx8V/n6LUn0KgQwt37Bp9kDIW8B
         ffoGy52yOqxwzF+fJnVKezx1aYYIZKGkIW1FUzKHKq9ZjnBkB9jeZsIscpm2BUjf1+Ef
         0fWEO7r/fB+LaHjm+hN3msEnJ3U4wX3CZmZGHIrYj5GG5cEZ7tSkoQsQDvE0ZBOnSWT9
         8SxwEZJHj2cJ095xrauPbZV/I7nowiUH+EKq/xGs/hrNY1q+8zhuFRgNATeL7rRtsO3F
         FXog==
X-Forwarded-Encrypted: i=1; AJvYcCVTD1xD6Z8KVGLjQfCgYSz0MBGsKS1vdJETNoC5czJGCJXF4Bn7c+GwZHiEqP3kWEXyXh/kCiSRDA==@kvack.org
X-Gm-Message-State: AOJu0YwrVjg2izW+w7CF9db6+6kX1xfK9U+LphJe59POLakyldqlyRNO
	bnXvUwnSjyH6kvdQJHVEozZ3xE44IbFhYyCNn8sTxqRdbv9BHSr3NVAM
X-Gm-Gg: AY/fxX5OZTiXXPoawD6bYqHJdOQvTdPAFwqM0eeBhTIOGvFBSh15gvExRZ+uq1SKq1D
	iox4/2mLOk7vdxzDlfs4OkxSGUlTC2uxk5o3hncgPhN/DbxbDM6iQjEFEfsy88Ljlvc0aRHLA6Y
	3dDMXr3UUybS3YbWbQCzl3COtJOHPE9z+5yo9p9N/xyjl5HostcAkRaGuusd/5GEmZ4e3wMxgwA
	8Y5x441P3pzMDpamAnUV7wwq05EKo9uLSoYL1Um6jmkxF71kJdz6moX5mkt9Fo2pFApYb/QMv0h
	1MoD/IajGKYBtAIGhJZ24PpVne2bu1l9haQ75beZRYi0Nw/9Xf1ua+3wcMXfbwZ6h7QVLlEXFPZ
	CWUX8g/oDSDbbZb5pVe+b7YOAIh5+gxVouvcotujSxJJ9SzJ4kuCHcr7zZP6xP3o=
X-Google-Smtp-Source: AGHT+IEl4Wys7Q4SsRgNG2E+WQ1GNUkskpWJrAarDBASWdaJXnRcMQIARLijn7oPvUMXkjAijza9bw==
X-Received: by 2002:a05:6512:3ba5:b0:597:d702:58e5 with SMTP id 2adb3069b0e04-598faa8408amr8438081e87.39.1766066451811;
        Thu, 18 Dec 2025 06:00:51 -0800 (PST)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59a132d4109sm1108082e87.41.2025.12.18.06.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 06:00:51 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 18 Dec 2025 15:00:49 +0100
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	dri-devel@lists.freedesktop.org, jstultz@google.com,
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Maxime Ripard <mripard@kernel.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>
Subject: Re: [PATCH] mm/vmalloc: map contiguous pages in batches for vmap()
 whenever possible
Message-ID: <aUQJEa643lQAGK6s@milan>
References: <20251215053050.11599-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251215053050.11599-1-21cnbao@gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: ncatx7bsfkwdun63xm4xcdc9o8t6id5p
X-Rspam-User: 
X-Rspamd-Queue-Id: 18C35C0016
X-HE-Tag: 1766066453-292193
X-HE-Meta: U2FsdGVkX1+A428a5Ve60QX9hyaZz4DEvplt7hM1ZZAqCTn5ygdG6d9Y8zGdvwxF9ligzQ8jY+Z0xowvqumJm6xCQofQJTQ2b0UXwIuy4Sd0xk76Yi1pPTBP+1tQP3iyx1E5LPsJTKevGMO7z/CMViyn8IoykjIDNvsn+12wvypf84NGIQGCjGXkTJzeLiazHWiEqrJaW0DsG9dCZmh7Sn2GhR3/zgilYNR12oHI6/lRgNjYRqcQkRgz9jFMbu2HUiAyq3EXrImYbvxEB8V+rMsf18ONOP9npGLXJwE6vIRukzzGwRXDQShTvDvzDALLvHX06/7WrFn+Xqchz96eVBrlU8YR0ivg0guGFKbIkWF0Q+jouir5gyj1XX+JHEpXBlcaW8Pdvpjncm0uzF1vsmFQesPKdiFEGSikpxcJt8Q4uwndRbGyhGkHRG3G+3PwXqdHQAF7oQdAUgShdE6ELv5cyyMkN9COQFXOlA5hOvdZypCKWQ204yvokeFSYgEtYrJP3304DMoldyBR2uADGlSLc7dtR0Gg1OZaij3non3ue8ec4hBK2P9i4k2niAs97hpiWElMUh8TmBacnKV0cI/PlP0yLm75lz9d+SiLJXt+hhlIcR3m7wJv/0Lup3rz0aW8YZ8BhoaiAWsfV12jAH1vRIlBU3B40BQceAso4H/W+3cRVcU3rYJEc4oNMQTiG+D9rhZzY5uQkhjIB68DRgGEG50r3tiEqzU+Q3qNZVsHDH3kKs7RiXn4iAISIohTYs90oky8WhBPb0NnHStGZfl8Z8d+rpzgN1S2NvLOoCmVD+2PgwmdSqPOs9bXAqAShafo9/UAoo49EDccy7M8oGvyI9570pm3lE8oZ8pKTXFhJGIVaO7GdxYUDf2vfvC7ATKjrnCV2kfoyacVgHZgytGngXFMSk3/sfe2B5Oqu+42LZZADn7YTiNoE/SbXWCNy3FucDWP0j556HWqDlc
 HX/igzFM
 OxjhL2uHRaiyfzCKMqs2TJeCkyONVQEpQfIEBgPrqky7ImPhWxDZnD2wj2gWi2jSUUqzaL98xvfZ5/1vkoEkqYjsHXPIhx9QhhnZCLkustOgdiv1zPar5zjX2MWp0mY4ccLEXZ7ysKRvKKwz21PK2WONKm/GL5b1YaSlDH8+J5wBE81Xtq28BpWYjKYAnkofSirQDlk0ECD3HAd2Krlu3p/QOUPVnM8a1McCPnVWPNokWuIrTFn8G2ecyXAmRC2xQcPcwYPEvOWcYYIWXN7kKrkXdrQj+J4wfH9XD1wezKZ5wzEN8BhVG0NfFNauY0zRLBIDhz21U5MUs7PYJJWmUC2CTewfkyN0PyCdBBgbOw7b53Fc494b+ss9U9XMMhIIHZ3/VYUJ9coU1YH3cUfQBrVP1+CWsXhzZVqm+QXiyyBJosUL8AGsd+PNVu/GWEHoSF41pshQ/EZzs8JVcl3iHMcds4gx/0aTpkDMVkIGV0TmI7hw4alvsIW5UEIrLrI6Yx5rLVkD5m8AZJ4uYvMRcDM156q3sONI4PkmKj6pfRKkEFl8U2SM8RRqubJwSx0y85XAsKpj/a0rQ9prgFvP3jzGJEUWSars7sOflTW02egIHwYg7HrZzfTYWrg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 01:30:50PM +0800, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> In many cases, the pages passed to vmap() may include high-order
> pages allocated with __GFP_COMP flags. For example, the systemheap
> often allocates pages in descending order: order 8, then 4, then 0.
> Currently, vmap() iterates over every page individually—even pages
> inside a high-order block are handled one by one.
> 
> This patch detects high-order pages and maps them as a single
> contiguous block whenever possible.
> 
> An alternative would be to implement a new API, vmap_sg(), but that
> change seems to be large in scope.
> 
> When vmapping a 128MB dma-buf using the systemheap, this patch
> makes system_heap_do_vmap() roughly 17× faster.
> 
> W/ patch:
> [   10.404769] system_heap_do_vmap took 2494000 ns
> [   12.525921] system_heap_do_vmap took 2467008 ns
> [   14.517348] system_heap_do_vmap took 2471008 ns
> [   16.593406] system_heap_do_vmap took 2444000 ns
> [   19.501341] system_heap_do_vmap took 2489008 ns
> 
> W/o patch:
> [    7.413756] system_heap_do_vmap took 42626000 ns
> [    9.425610] system_heap_do_vmap took 42500992 ns
> [   11.810898] system_heap_do_vmap took 42215008 ns
> [   14.336790] system_heap_do_vmap took 42134992 ns
> [   16.373890] system_heap_do_vmap took 42750000 ns
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Uladzislau Rezki <urezki@gmail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: Maxime Ripard <mripard@kernel.org>
> Tested-by: Tangquan Zheng <zhengtangquan@oppo.com>
> Signed-off-by: Barry Song <v-songbaohua@oppo.com>
> ---
>  * diff with rfc:
>  Many code refinements based on David's suggestions, thanks!
>  Refine comment and changelog according to Uladzislau, thanks!
>  rfc link:
>  https://lore.kernel.org/linux-mm/20251122090343.81243-1-21cnbao@gmail.com/
> 
>  mm/vmalloc.c | 45 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 39 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 41dd01e8430c..8d577767a9e5 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -642,6 +642,29 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static inline int get_vmap_batch_order(struct page **pages,
> +		unsigned int stride, unsigned int max_steps, unsigned int idx)
> +{
> +	int nr_pages = 1;
> +
> +	/*
> +	 * Currently, batching is only supported in vmap_pages_range
> +	 * when page_shift == PAGE_SHIFT.
> +	 */
> +	if (stride != 1)
> +		return 0;
> +
> +	nr_pages = compound_nr(pages[idx]);
> +	if (nr_pages == 1)
> +		return 0;
> +	if (max_steps < nr_pages)
> +		return 0;
> +
> +	if (num_pages_contiguous(&pages[idx], nr_pages) == nr_pages)
> +		return compound_order(pages[idx]);
> +	return 0;
> +}
> +
Can we instead look at this as: it can be that we have continues
set of pages let's find out. I mean if we do not stick just to
compound pages.

--
Uladzislau Rezki

