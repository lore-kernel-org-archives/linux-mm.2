Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316FA109316E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D2F6B042D; Thu, 19 Mar 2026 23:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE756B042E; Thu, 19 Mar 2026 23:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613BE6B0431; Thu, 19 Mar 2026 23:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2A96B042D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:31:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E034B5B698
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:31:13 +0000 (UTC)
X-FDA: 84565015626.04.EB3C898
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2057D1A0008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:31:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HNYgj+Sn;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773977471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1IpKc1z71M2a6tWj6gvBg0vIBIO9A8U3Xv2HaNRDwQ=;
	b=Pd946NEdY2SA7bL7V9FLhFB+FJAyuUHSks7hq4ys3S/sC4HYb2tSswYpzEtZRqlSlEmE5w
	e+XB4vJfIwOSNWBsb9LUV+ax90HobvwT89rV171u62r4MEVyTuhftNlgOQWCpra5gIfkjd
	8Cn4qX7X6YAlM54PKeiqD+jUEM7I2V8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=HNYgj+Sn;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773977471; a=rsa-sha256;
	cv=none;
	b=5auZ7wOD4CA6liOI4BPfwXcmrREgGSP4/ia6pAsob2aavwxlq3xOSwNnbHa8TFxdr4bFew
	OyU9ixZo1oC/nnMQZNoDTnO35yNqtjVPWVXv+CaCwnwIkm9b40nQGoat9ahmUUd7ADoAO/
	cmAFE3A6sQk5EuVTrWYn0CLYhV9BmYY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773977466; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=e1IpKc1z71M2a6tWj6gvBg0vIBIO9A8U3Xv2HaNRDwQ=;
	b=HNYgj+Sn/3strUsAp0D7nMOr71RTG+Zj5qRNdmKOz1ppDCSsxvqbxLff8QbHJQxw3RncJaMLbLrhmzqsbJ7Dw8EkKBk5i3XjY2dhtxg38rY0DPeV9ZJ1+/wtT1r1oF9fjYEkgApAgkEcckwO2psCt3ggMK1e7vtft7Nm2ydO/5w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R431e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.KLaDi_1773977465;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.KLaDi_1773977465 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:31:05 +0800
Message-ID: <435be208-8d04-4e9e-9b00-9d2b754aeef4@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:31:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] mm/huge_memory: remove unnecessary
 VM_BUG_ON_PAGE()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773924928.git.ljs@kernel.org>
 <3fcbddfbfd0408364fad4548be83455a59d17f79.1773924928.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <3fcbddfbfd0408364fad4548be83455a59d17f79.1773924928.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2057D1A0008
X-Rspamd-Server: rspam08
X-Stat-Signature: 38iypjzzzkwgsa7pp48utm5h6ft1smgz
X-HE-Tag: 1773977470-963084
X-HE-Meta: U2FsdGVkX19+Xaff1ZyHua44H2Rm6H9RQFPz8ksH3WyPjxFNJd8nkG/HC39hEW0b/zy0syCYGix2uo+KNm2y3IflW/itSiDF7NBrLYTyq6gZaX1te2kQtRrVy8tBUQMC6QfEI88HiRY+AAagseA70vg74IfGxySbZfjUvv2IUMchn3SOyOWXxtRruMlPSI2SrrAASfu38IWoaPMReqNjT6VKHZNrwhqsNOHlqn3yrUpmh/GKYmMuGU15nUNNErJwGrSRmoBHjZS4tUAAt5LnEAUibx3hQPoT3hhn2c6L25y4KLNvMTIylo6lYBNA8W62ZHb8KaiVKm1H3YEYE6ytaTzj6N6vgiQMNPs6HE9BqtmoKo3Ffy5sJfmDTnTixsCSy7CnP1CrXRDtG57hYa0vKqTr7+pHR3oYGLtiWZV9/YX9A+f7Z3bBYxJeMdVt6L6r4IUEjYWE861XLvWk8KsXGsk9NzRSy1rsiv1tTczxJ+QDgwjzzOjA3cIGGAHL/jNCOGsAHzDui4KSHJzwwHy1HRlLJvY5zNuFk+InVUzDhQk3Njdfpx5UPYVeGW2doVdwj38hYbdqewuS2VEfH5VAmJ0/5+e97B61xML1VYeufLgCXXypKlPT4NXf8pHxM+OuxHi+pY1YqNpVSdp9d6MWOFha2cpmvwZazwqYanLtv/wDDEEBXPgDuIoSO+W183ZfLPyZcW/5yNYM6etLAY9mOB+A1F8VQBtI5NHJnvxKQ2lhq2JSLTbotSEheNcZqHwSixUqo2nVtaCRHQh0h96uu7+x7/melDIFwMMWu2YLXj4NrMQqKKcGWGEUQUO9tlzAw2X39GhyOIpKaE7lUP3O7L1jJAejXnkepB1FxPI5wgWkTGo1oiR0cYQag1YAdyx6ozDsVmhf32r3nY8wlAWwpbcFe/SzEyzGKJckjSCvElQMqVpjuGlb1CPOeFgP8GfkL1CsWo6MTl/trclawwu
 xqhWZLMy
 LtuePVipPTeBLxNQ6r9qzw1MhaWGes93WMLFT2P7dpKwFTqryFax17+0u0UBl5DFCCLuulQ1tD8RchzY08XYVNNYZlbaBOKJf4sQ1vdUzKDtqTMPgr0qCKe/QPbpI8U9uUG3EtcoSsiKB0iQUem3jfQqfZk+0XTtLAJn7rN+KwZ49HVN6SbQxEcxXs62rMwp6HkyVlYQ4EUCfs9iKdnhguT575iS0JEn7YTWt28fvxGCruDdKkgm3pcZSTF+2MI3RSBsxBKujOCkO2DusLNDaIYVWXn+D/KbdioA4pzytaKXIq16TXAzQ+KPkcF4xjJBfVKvFh701j7y0k9DjekSzPCl1UWSUIx1qT2ULnI5JX/B9VCbe+2XQSJz05g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 9:00 PM, Lorenzo Stoakes (Oracle) wrote:
> This has been around since the beginnings of the THP implementation. I
> think we can safely assume that, if we have a THP folio, it will have a
> head page.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

I think I reviewed this patch before[1]:)

Anyway, LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

[1] 
https://lore.kernel.org/all/07368afd-05c3-48f4-89a0-c1349784f62b@linux.alibaba.com/

