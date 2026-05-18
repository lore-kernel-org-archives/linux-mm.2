Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD166CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 452516B00A0; Mon, 18 May 2026 02:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403146B00A1; Mon, 18 May 2026 02:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318C96B00A2; Mon, 18 May 2026 02:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2354B6B00A0
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:57:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C04CB1C17E7
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:57:33 +0000 (UTC)
X-FDA: 84779634786.20.52C37EC
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf19.hostedemail.com (Postfix) with ESMTP id DEAD31A0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:57:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bwDefZI+;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779087452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4S2UP+4Ec7pYdgX+oP9rm4DXMaK33zfVzNRRNCKcGSc=;
	b=B5cuCs8wT5pK+JVHRJd0Vdcsf6JqK6jSIrojTl+kAzanPUmWCnkwOsODpK0t3jOq/auUG+
	s8erZ1FRk6VrcoKa5sJL1xJDY62x9XPpZgepEqa34xzCwYnweUUB/M0QIH+0DTh3xR7CZt
	oOjE8xjesWRefa0h8wCIHg7r71icxdQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779087452; a=rsa-sha256;
	cv=none;
	b=C4O55b/sKicMWDjycDH0FtIhdWgNggzq7y7Kmdfrl4WAIzbjpAJaFfBUhBJiJI+wF4KGvR
	WOCnWcxHYkMjbeTOwaL54QsK6snDZtcf2TFCsUdFxHckQ3ec4+TKMBvu8FEv4eumKu2t3g
	eu8xaEoGYWeCMoaoDK6unSG4OS3c3zQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=bwDefZI+;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779087446; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4S2UP+4Ec7pYdgX+oP9rm4DXMaK33zfVzNRRNCKcGSc=;
	b=bwDefZI+zKj3TcwKZ8aJAEfCY9i4WmHW1BmxnBQZ9PzziUM0gSBpOIOl/hOd2fydaZFrYfQeQLHqQuaoHIfByaS3QkI7HPMPCbEtTpG2qW1owFs/d64VYCo34btfQyY0Z0gGUyRu4xMCiuvBhJhg7E6Jji7SoBUr4nE3zukVNkA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X34bSjL_1779087443;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X34bSjL_1779087443 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 14:57:23 +0800
Message-ID: <d1808e75-ccc2-486c-8844-4038e7b707c2@linux.alibaba.com>
Date: Mon, 18 May 2026 14:57:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/4] mm/shmem: optimize file read with folio batching
To: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260515094702.1092355-1-chizhiling@163.com>
 <20260515094702.1092355-4-chizhiling@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260515094702.1092355-4-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DEAD31A0005
X-Rspam-User: 
X-Stat-Signature: fz9jj3oyem8g73rm36g77ndzkje6kdzd
X-HE-Tag: 1779087449-837819
X-HE-Meta: U2FsdGVkX1+hg1UxVaFkKDNOT8S+9lKpQbMQCaNwxxhPC7E8WRGPg+oCNtvDrIG4qIHvRNgl3MG4hO5NMeqX0YSi6SiMqGlO2PMc7+FOHy3bby9nGHA3ARB/M6VUjJYnzofkOsShgu4LfNyRpasKaWPyuI1agZ5XUt/NCRxIsr2uYHY3kZA2BSnKvEzxp+wvMmt5zw81F5ojiiLj6//eNmS7DOmM68FxO5OTQ+FikIGFmHGX0F8OzkAFfZKrSDtX0HN4XQASBlwHnLXdK5co/2Hsuydp+VjxPbQtbqNPxlyreuooP6VLP0QybVh1PTIYmaK6B3whzLJJzenc5in5XgXOUnWd6Swp/mAmXhyMSBsZYkaDRS9EbSon05LSwCOsbrmLGbFGOCg6H4K/LYvgBat0AW6CXTQt1/+OhR5FTCDos8ziWwJYqRlzvXw4RBw15Fepmi8C7P7/v77ngUtoHcC1dX7IkfE8ESUsWfNwZm8jFkHnQELSc7NxTg2Yiu067dcWnTvKvV7AkErRHPJPKhDOvBlRk7HaVpw6s8Nxc43cLD1YM6KYbXnjvJBlKaKtEJngHjO4RfV3RWKGCH80OQi+ReP9SR1DBla1w4v5o8Y0cDZxRcUp0zU/7dqX+XruVGu2BxP/4Cf6y9QmCz4rxJ0MOHBuSdfepjVANf5mlF9yNrivz+9h/qf6aq98lElL1uyzrQ927WsC7YGy1yDtVxI+ASa3pxP+Yx6E6+GhSq6PQOczlGtvaqoMjzoVawcd+lreHKlt2GgAh7uX/4Zvg0od7V0Vw6Mt/tgD2CjKu9qv1fTiS8JNgE61qQgVxjy5I/XB0edZfi85A6es+an06poECXFQOBu+qvrZe+9HJANYY/bTVG14+5s0ErQAXFuW/2ZEcssXLqPs7yDsjaefHLBcrEGS42j7oWRtlOfRvM6gK7qUveaaF8lEynjQ/ejqWW2nRD29+/s9fVRfoM4
 lv7AynSd
 gAZHeHQF65JLwWVkWY0p59zIHeemtxsm/xIRI8mW3CEF7RrVfb51ZfG4rh6AVYgORM4Zj4/vySHqhl83zCbmkayMgAl8ZrxyMhomgfqqkeliHH61G9g4bchUzqD972hHMMVnQkoQLdkXqgV7GF4rY6Vvw4kY2HquJgxCMEuODdqXI+8f77LcFKSnCXJU+Y+ReuZddUbe9Oh7dcyp4F1QlHOnf3KU2ki1zQh4N6jSPvl6x5KxNhmxdc1wg64e6zZexKoz1umqc3Wxhm/Ys3puPk3XBB2rjBZanXbQfSW2smkBJguPoNE2OcRa+wYlq4h1lKG0o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/15/26 5:47 PM, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> Optimize shmem file read by implementing folio batching in the read
> iteration path. Only uptodate folios are added to the batch, ensuring
> all folios in the batch are valid and ready for use without additional
> checking.
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>   mm/shmem.c | 102 ++++++++++++++++++++++++++++++++++++++++++++++++-----
>   1 file changed, 93 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 767610f78d0d..4bc4e463ca97 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3348,16 +3348,100 @@ shmem_write_end(const struct kiocb *iocb, struct address_space *mapping,
>   	return copied;
>   }
>   
> +static pgoff_t shmem_get_read_batch(struct address_space *mapping,
> +		pgoff_t index, pgoff_t max, struct folio_batch *fbatch)
> +{
> +	XA_STATE(xas, &mapping->i_pages, index);
> +	struct folio *folio;
> +	pgoff_t end = max;
> +
> +	rcu_read_lock();
> +	xas_for_each(&xas, folio, max) {
> +		if (xas_retry(&xas, folio))
> +			continue;
> +		if (xa_is_value(folio)) {
> +			end = xas.xa_index;
> +			break;
> +		}
> +		if (!folio_try_get(folio))
> +			goto retry;
> +
> +		if (unlikely(folio != xas_reload(&xas)))
> +			goto put_folio;
> +
> +		end = folio_next_index(folio);
> +
> +		if (!folio_test_uptodate(folio)) {
> +			xas_advance(&xas, end - 1);
> +			folio_put(folio);
> +			continue;
> +		}
> +		if (!folio_batch_add(fbatch, folio))
> +			break;
> +		xas_advance(&xas, end - 1);
> +		continue;
> +put_folio:
> +		folio_put(folio);
> +retry:
> +		xas_reset(&xas);
> +	}
> +	rcu_read_unlock();
> +
> +	return end;
> +}

I haven't looked at this patch in detail yet, but I feel this part 
should belong in mm/filemap.c, or perhaps mm/filemap.c already has a 
similar function implemented? Let's wait for Matthew's comments on this.

