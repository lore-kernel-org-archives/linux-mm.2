Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D7CCD8C8E
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 08:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396D76B0088; Mon,  8 Jun 2026 04:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347CF6B008A; Mon,  8 Jun 2026 04:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DB26B008C; Mon,  8 Jun 2026 04:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17B6E6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 04:17:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D3FA409BF
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:17:10 +0000 (UTC)
X-FDA: 84856040220.23.5657C79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 035C940006
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:17:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEWBxu5K;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780906629;
	b=F19x8HaccjGyDSetpeBZP8DqSuLptDR98P17Q3iOGgBbjS+aMqW0kyurISywNfyHU24STg
	Fx5Fv1lKxnoLLWCuqacYslZQ94gVGmxzBtJea6YatTlkVZNHyRS2hUwWtbM62jQA3Gkfxg
	Qzt1Wl5xBioyTkDrqSYwwEaA0J99qI4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEWBxu5K;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780906629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2CGzJHMR082CZEaBJvYYklEx/AUabVfo33DoJiswTsg=;
	b=5OUTvXO5AWqdjPe8chRS6xpVK5sWNf+4XE10K+h+5gDx3PKKmEoM56nQGJJLb5oYcBU32b
	mL/iUSGvpZMtdPaiZ4A9oAv1jtlCHnkZ6fuJ2wBHyz2LHZPmIwXNkWAPwIKjWVdNfhYa3Y
	sQ9YuqBDJDot64Hj5DKr46yjx5hX46A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32EBF40245;
	Mon,  8 Jun 2026 08:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973671F00893;
	Mon,  8 Jun 2026 08:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780906628;
	bh=2CGzJHMR082CZEaBJvYYklEx/AUabVfo33DoJiswTsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OEWBxu5KnEguBwQsJmXEOlLVlzd41WaccgHCS8VR/HX3KoqArK5AD3XyC4v/449Rw
	 h4QokdvZhHHmCVVCXc1m12gHafV1segbzIfA8uFZKOjsWfIHlf8H6w2Xjd6HPlD+AF
	 /4+OJEnpyV1GKW2Di/dSvT6HvNQrPdUwHpPzLfi0hik9/0VRnBU0/s8XkFkfu8by20
	 sQiCyOtUtmP0znCP62oXgEI4eEQLRsOwVNv2yNi3bWFZTys6z56zW5JhOYXOep6QrT
	 CPvnTTDNz38OyCIF5AFykhFHD2yabhfoFfW4Tmg7oEZRK1RBBIaUzDU54/eXJV/VcC
	 lwlYJJazkHi/Q==
Date: Mon, 8 Jun 2026 09:17:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Imran Khan <imran.f.khan@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: avoid taking zone lock in /proc/buddyinfo
 reads
Message-ID: <aiZ6bgmgh6LHHlWj@lucifer>
References: <20260604134245.1580287-1-imran.f.khan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604134245.1580287-1-imran.f.khan@oracle.com>
X-Rspamd-Queue-Id: 035C940006
X-Stat-Signature: wqumziyhaza49cwigrnm84kyhps6izut
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780906628-585352
X-HE-Meta: U2FsdGVkX19Wy7NsHQb16iQk1Ptm830g0VaTdffGGRtWyBK7PcNIN7c98cN/KJo1mf8Q/3lRHJXxPAaxxq5J87f9iyVZiVMjXkjIK7Bt1VlnNHvMCFkvkB1TDREp8Ir5UeWsXTvJWKmMm8b5M9j49QDgH/tn7f+21P2YX6WI3Kzg74UYCkU7cyGzBNPTFdTakqdILcJUN43e5sCsrofywKmwaVtLiVAjMdrFTVo60scGK8QH5TKrTkJmIv4iUysuZax98ylYIhzb43rEJ1FpHlW53vnFtVFijtFdLhPnOa7rgNt3rUamX9C0S/otLA0EQw13KkecxP2jFVVsXXpm4X5OL/kLu5O4H3Y67zpsP/N0xwfaDKIUEC2dJtqpDhnXhwV+7r3OkQvBcwU8LibntgI6/v0Udxj0FtboLP70WqpI3YyTHhl5FsVlF2rPKazGqFcEhrD78hfko0f1n8EvFS3dFOob38WeZKPAF6tDXDnTOJGm1mWM3lu4DZdmhbGjOfs0AKJTFyAnRDlZ1nl8Mau8n7DfdjFHXayg5pau5bN6j1x1/CbK/74UvXdg5pYmj0+7+fMxvWsfSqD0AfWbXaaqYpny49DwM9FQbkqed4BJMTYggu8HoXgxEA51d7i94ZSh2dsDOu9suJVR/sr8VF6czVq+ZIVj8ShTQcQVNfa1YV16xuLUp3BYjD0Ma2BXDuLLnbacBZy53Ea21WvvvqMDvXzn/vHhia2OTn/4qUNdXUUXgwpL2myM57YUSooRWewxzaLWLoknTJpcGpshkhEC+j0+0I0bjZG/Bo9rdaczIyyln6YG+xrxSP1kN38IPVCNEw9l8Rg1+j4BClAtIjpAdPKahYTEKnDVnbq2uTJCTVyl12zxVMX92MqmWeBbeXIle88j6et62kc0dwd795TQ7JpN9v93CkMjT/1mOB5y1VaYgQmFwiAg+jvmUfLAYpVdIfnp2PfL7Egtqq1
 iaT5lDZw
 YZeMU4PfWOX8JKwu16GbUaVtRlKMf0eLcW+Nrnkww1H2HyYigeSnZ33qzdWEYm/d9Soooe2NYTd2dF43xQf7F+gz/NBiwC/cYmhW6SFqQDuf3O1LUW1nVefllI1kOZlCVi6D7FiiUgB/ZpiqnSMXMFZMRtNzJb/3xTthnV9YRnnURBtBsTWmaPG8wDi37Yw3FKMD367fCXkDoYSFt0Fe/okcQxWuE9UkGBui6sQuJzxO33Zu5BUjOE2h0WDjRDXt0r6N+J5AujLIPFdLKO0WR/9qv5QEEjXCnzwEtOFs9DWHUzYc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 04, 2026 at 09:42:45PM +0800, Imran Khan wrote:
> frag_show_print() just reads zone->free_area[order].nr_free, so
> it can safely do this without needing the zone->lock.
>
> Pass nolock=true from frag_show(), so that walk_zones_in_node()
> can skip the zone->lock acquisition.
>
> Signed-off-by: Imran Khan <imran.f.khan@oracle.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index f534972f517de..7b93fbf9af092 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1568,7 +1568,7 @@ static void frag_show_print(struct seq_file *m, pg_data_t *pgdat,
>  static int frag_show(struct seq_file *m, void *arg)
>  {
>  	pg_data_t *pgdat = (pg_data_t *)arg;
> -	walk_zones_in_node(m, pgdat, true, false, frag_show_print);
> +	walk_zones_in_node(m, pgdat, true, true, frag_show_print);
>  	return 0;
>  }
>
>
> base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
> --
> 2.34.1
>

Cheers, Lorenzo

