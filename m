Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09160CD37AC
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 02:35:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68456B0088; Thu, 14 May 2026 22:35:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1A196B008A; Thu, 14 May 2026 22:35:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2EB36B008C; Thu, 14 May 2026 22:35:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A10D46B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:35:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2F2D71C19BE
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:35:18 +0000 (UTC)
X-FDA: 84768087516.16.45E7F16
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf16.hostedemail.com (Postfix) with ESMTP id 18A9A180002
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:35:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uU7Xozkq;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778812516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJuI5cWrLjqZSC4epLlJmsrMKuvGRGnaD22IsmKq7IU=;
	b=aAZGkjSIFQsbxtAJj1AEgzmYnJuiQLg7OP0RSRjkTyZuORWdOYSVSAlik+wwLwHvjkQiGZ
	5KLfpFHuIh4PtdzZ1iNlASpG/jy/X2rIm5H9OdJO+bB/BRIUukDL2+5TJvXtzCcRCyrGKE
	uoILhqSwlPE9kyXewlHmLIv4MOjHyPI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=uU7Xozkq;
	spf=pass (imf16.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778812516; a=rsa-sha256;
	cv=none;
	b=IbK2OANvqBNgWp4jr7weepyAbxtd9qdtQkzhbh38IObc8lrGAB7lpHDo1ctGSZu0RFhxQV
	W81q/A5ZvXhVBs0LFfsTcPKD8IIDIx7Mbpuz0ZbhwzrRTlZna9BClAOxaQKsNSqXyfH8fT
	dEafFXfpZSO1db+pWibyTyOVp/XgI9U=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=UJuI5cWrLjqZSC4epLlJmsrMKuvGRGnaD22IsmKq7IU=;
	b=uU7Xozkqz53qyBulJ2VsTWTzWin2hHPdatulQ5prdouo5zABK+pvcV1+ZXCrTJNebatf2jd0N
	PE+eBlXg1iMgx/T2pXxUuWm1dX4wY98ETBfhG382mqOHW/mtgwWFqDZw2lvbJa4xADrFQR82KdU
	gkp4rdPKBNNat9tw2LR9uzc=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gGrhm4GcSznTVq;
	Fri, 15 May 2026 10:28:08 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 639E040571;
	Fri, 15 May 2026 10:35:10 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 10:35:06 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 15 May 2026 10:35:05 +0800
Subject: Re: [PATCH] mm/memory-failure: Use zone_pcp_disable() for poison
 handling
To: Kaitao Cheng <kaitao.cheng@linux.dev>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Kaitao Cheng
	<chengkaitao@kylinos.cn>, <nao.horiguchi@gmail.com>,
	<akpm@linux-foundation.org>
References: <20260514085754.84097-1-kaitao.cheng@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <bc86b3ad-884b-100f-b6ad-a395ba879f54@huawei.com>
Date: Fri, 15 May 2026 10:35:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260514085754.84097-1-kaitao.cheng@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18A9A180002
X-Stat-Signature: zib49ot3m7u5cns9xmimqo1f4bxexdnr
X-HE-Tag: 1778812514-761090
X-HE-Meta: U2FsdGVkX182PSX38WYVyOFYn3K4cQmJNK9B0wSq0GLfasiPC+INMTL8UgLdxmqZMQna7hc3u3QhQHaw5MwLwgT7fEe9NxlItemIfZijB2T6uhcAHvtWMv/R6FIT1Qp8zAeAIt9/Cgga0ecsEKw9vrbqsvLG/JY+nI7QEE9ZfmydyV8GYD2f/H3NJFPI3hmtM5+CTXWcBB/v2thZ7ofZWcYP+ozf7bEGyBVx97d7YdQ4wGd2x7odxTqKaRPGnMmtTbDENU54x2BM+c0fcCt5NVKEUE1+gX3TJSG2Z/d1ZWRTgdWlkGymssyiEdIgbY8ixk6EJSH0Qnuvn+sW85pzINyrU7bPWLuNR03eUYPwgDrRAi377zLVHEfEMfWMQyNxidBsrnRii5PV1e5pXSq00mYD3XQXzABR9F8ayXqZStS2JLqCIPN/1SV9LEvGu5uv6LT6tJ+05hxhjJy65+nMhGTI6U/XLg0iFMK6Y5DeNgpohiM5CSIa6VVOsLhoGOfaHT5JB0a5hVfbmnGHWvdWIfC3CMJMCzy7G/Np2Ni8QRxPvalHJVT99CCVnnOCUC7ZB1wp+wFopikFgY+oGnRDgSB8juZT4A0H9onNbpa3PdVqINjxQVby2dYg72cjxiuekyM0RtmchSrmqYelEKrRHVeYmEtvp/nAo62c2SaKN62EruGHYbKmbgBC6HBd/+y3BYe19zMSwtjea531eG5QC5DYKme5TguZej5QY3zXglRXuSnfQKhthPoQ5q/fz7e6hs/2GsW0idyiBX3Lp9oW2mL8vjW2aV2+XUpZg5qqiowtV+QVXEJU4dPVsC6OJV2R9b/b5tf+1nIm1MvJ80e2Fjl0ssVwE/UJnHBQjtyyvWyeEzuoQYWJD3HqIgWSqEy2D3YZluBDvOksRY71eThNwzvBofUrMg608sAu8RLivyBEuY/+j40IL36MPOs2qB+guwQ3Cj5uKwRsRXDkN1m
 wRX16sgO
 b6x2RFNJVLJHZwAHmT8GInwbkTmFrx1m0LNdjuSAhfAfkn9gU6Ezjhx5wPPwJ9GqqnsLb1XSPtc90qxnKucEsBGUdx9VY3dZw9krWNhf0ixBck6mo9AIA8F4xJ1U3zDk6ZgQE9ds77kH1aGbgAsnwqBR/wlyxTn+Zi1IuanGJjvFc0SURE6LKXm6IVE7+03zH7QHO2Je6l5yX0eFryr3SAiJARVi+rjGHJxnjIEBHG8pR+dkgxtfdsVu6rj4aq9nc8kFJ07IKHArZDU5vG+dmyC5Ps08lin0h1XcvsdiJDwpLI3ET7CBc+NIkxsFaC3W+hqc/5S9ujpB9Pha17IAOPYOnp69KDB0dlwRA1bvto21tbYTCnkMLkb5XhOl23BMI+s2FcBdUaAtZJx6wosWGf5MlL6WjmnLvzeGD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/14 16:57, Kaitao Cheng wrote:
> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> 
> __page_handle_poison() used drain_all_pages() instead of
> zone_pcp_disable() because dissolve_free_hugetlb_folio() could restore
> HVO vmemmap pages and decrement hugetlb_optimize_vmemmap_key. That static
> key update took cpu_hotplug_lock through static_key_slow_dec(), while
> zone_pcp_disable() holds pcp_batch_high_lock. CPU hotplug takes the locks
> in the opposite order through page_alloc_cpu_online/dead(), so the
> combination could deadlock.
> 
> That dependency no longer exists. Commit da3e2d1ca43d ("mm/hugetlb:
> remove hugetlb_optimize_vmemmap_key static key") removed the HVO static
> key and the static_branch_dec() from hugetlb_vmemmap_restore_folio().
> The dissolve_free_hugetlb_folio() path no longer reaches
> static_key_slow_dec().
> 
> Use zone_pcp_disable() again while dissolving the hugetlb folio and
> taking the target page off the buddy allocator. This prevents the drained
> PCP lists from being refilled before take_page_off_buddy() runs, making
> the page isolation deterministic.
> 
> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

