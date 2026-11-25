Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB1EC606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JL3SfCjV
Received: by kanga.kvack.org (Postfix)
	id 048716B092C; Wed, 25 Nov 2026 03:18:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15396B092D; Wed, 25 Nov 2026 03:18:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC0F6B092E; Wed, 25 Nov 2026 03:18:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B52816B092C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:18:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7EBE140E00
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:18:11 +0000 (UTC)
X-FDA: 85472938782.20.ADB041B
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf17.hostedemail.com (Postfix) with ESMTP id 84C8D40008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:18:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JL3SfCjV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795594690;
	b=wkE0fAIiJgrArIvRr/ShgSfr7RyLgu24qQfj8NBMdV4Uxy1O5IavxQoNYulm2JYV7zdMG+
	+OPIs9CVMNyNpQ3EgzPCZkjoHA89IhWsUd66IGUTEGiKj9xcck/qiKhjDPVv1YxMh0skG9
	QZ6tGflq0Kr/QNXwmMqpCvVYiuuw/hQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795594690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQ4PDN/+IecVCHWBDQ0v0hwYyubU4Qhpq8q9f1QbpYY=;
	b=BobRhHO9m+gWmGzSsueP4pILZRxYB13blHHrrRd0bGlZTkNFV9hmLUhf35kpUSQKT+lkTf
	oIassXbTmZg2EUApkehpO0BsMd4P8PN6zCZn5sfhRCTySL2aJT10dEBbx+PdvsCvNzOahz
	A1qJaW2TALdsewRtCFjcpKDFHjEoCPE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JL3SfCjV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Hnn1Upm6og0+ZrW88GDMEcGJ/ZGLLay+qcflC5gxlL0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795594688; v=1; x=1796199488;
 b=JL3SfCjV4080nOi9CL2Q+K936t6S+au5atuKD6XAd3apiOOESRAHmZ0x4F4NXgGc98kRpCxq
 bwK9DlYtw/+U5IMNNX+628MFduzZMqzlSkJYE/Ma8ZgafwvwYunoQzceNShRRKkN5A4TWWH81Ab
 uERyIbgFjLMa6/H3/tiucj8o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id eba729f2d53511cd;
	Wed, 25 Nov 2026 08:18:08 +0000
X-Mizu-Trace-ID: eba729f2d53511cd
X-Migadu-Flow: FLOW_OUT
Message-ID: <195d7fbd-5538-41ee-828a-92e5f400917c@linux.dev>
Date: Wed, 25 Nov 2026 16:17:49 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/18] mm/memcontrol: allow update of LRU statistic
 without holding LRU lock
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261124-mglru-fg-v6-2-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 84C8D40008
X-Stat-Signature: ohrxoxbmhzi4rqkbmo6qz7fiwken5p4r
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795594689-984312
X-HE-Meta: U2FsdGVkX1/ln1nyQ+xzcX01fGo1GcoZQBF/qxYcofUQv3HcZ7pERNg1B4NKhDNeYBfvu2t1fjro7VsZErDZynLG10GzprRXfUnG6+s4I5COxsPa4UqdRX4djVm+eyHfkeB56eiN+0rMTWEGIyksQ3lhZtlpNXtJ7ghpM1HRUHO+Mik8LsbKAL6UJDtRTHaYN+hTdyLRa6TXQxIEkMCkfF9WjOv4k7sdx3PtQJky2GxjiCt6WhrLFfhfNS0qgeKFimp8AbxGWvrPDU8fbR+8Qe/D+Kn9E8NO8sSUthX0a4OKBwe9643S4tIEfpS7DzrXdaSessxzVAZatHszr7C3iL+eXecYhq+leAj72uH0rjO7cw7t8Qv+8Tw6LYyDudJeffvFsReWnxiAw6aOlT6GYhg+DKf/D8N5EaC9bqxdXggxac69e+8CxMSkIzA/B1LM+yRleONuOzp0cQUvizvwilzd3W4ll8+uc3se33p74jSI6RguyiFt+HSZS5pR2+WIKJQDBKMwXgx/OdsbHpvZOFZY+tNIt8pdapwvO6n4q+2ZSD7JfTOoFJY1qpmcWhbvSVSfbSFmb6/lw3jHmMD0EDwHi8EzpOxzH7Ns+U+eE0S33PLBYgA7jI01ReH67D95QPAkhvKAmmQuI9u1XQNqHWu536nrkjm6seZ3wbJ21jEGrl4+PPbfctJhIqR2lJA/Kxb2l7ZIEgl0zZy9Py6vjOXwkXrPFHZM3CE2cyEe9TTZ79Fua8zw5vI1Ht9tq9BWgWTfOOsbOzOvltMdAsSQQxWXXQmJLifS8tQO6Qneh6lVwj+7HBh2iv/RbZZAxzLpgYqr1P/jHg1lYP+JgomL9KpAMI6mmYgWWrrLxirAEe3AkkbbAnSykW1NVpL4PrX9K+hsIpkVg22hIgZ1+MGDLQ4CE4UgSC7YMuEXNUw8JCfoY7hg2jDXTUOKnsn4Zm6Ch/urNKtt7DWok8pIbBg
 fr0kfGDf
 Gr8vQ6yCCGuO4vCD/UGmizbyU6Rm3YLAIVAKsZ3K6KZWNxGSfTx10gzTI7PdpA1VemQh4yJQxO+MhJKQLmjfhxfaHZCOir4fnBEL2u7qgNEXRYIgb++pjqI+1oluf36W3011/FWx95Zga/CV9Sm9C6ORTdIPrZ+mHvgXioFh6O8gDWv5/xlP/5sz2SVV94zcI6JBVBTwEARWfyLtOTEMpBRGKMEJ6t1bnCyj//wF3E7d0y2cBOYx0VwYak85MYi8eqSsKA5rwK8+p3lYzDyM2JZMFr4GpniAQevI+KF56DXnAmjIDlsuxQ8RXi4gTDCGAahxBqCV4ynceyFwCF97bqYqBSFigwGaxNsAI7DEoR/06Ig3mgQYxPcT/8XBT4U+xpBfGlAM4S1Uh6WqPFzG1DYh/OKhExcFPC2bbuvE5gEDV4QX7AKko+D3sFlUnJff6532HIMb6iZ91Zsft8n7EnYMDmUPzSjrqfSasL89v7i2GmTwl88040M28k+nmcd7OIcPajqqCULdv/7wUy+9SO4DPOkiulNbIQVNJAMcdv2VLBw5GRxzc7cWOyERTXl8ODs183eiYcPQNlTF263f+CIwoPiVXl6US2XX+0Vf6wI7wtjWl/NGF7lMXjIjzTbWmnYphFiJ0wRbtId//A11fCx69GtUwT7x2OW85NTIpAMw9wB5fvGAugzEqBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/24/2026 2:52 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> To enable moving file pages in folio_mark_accessed directly and lazily
> for MGLRU, allow updating the LRU statistic atomically without holding a
> lock. It may cause temporary counter underflow, which should be fine as
> the counter is eventually consistent and only serves as an estimate.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 2395ca8ee305..2edb9beef6d3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -47,12 +47,11 @@ static __always_inline void __update_lru_size(struct lruvec *lruvec,
>   {
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
> -	lockdep_assert_held(&lruvec->lru_lock);
>   	WARN_ON_ONCE(nr_pages != (int)nr_pages);
>   
>   	mod_lruvec_state(lruvec, NR_LRU_BASE + lru, nr_pages);
> -	__mod_zone_page_state(&pgdat->node_zones[zid],
> -				NR_ZONE_LRU_BASE + lru, nr_pages);
> +	mod_zone_page_state(&pgdat->node_zones[zid],
> +			    NR_ZONE_LRU_BASE + lru, nr_pages);
>   }
>   
>   static __always_inline void update_lru_size(struct lruvec *lruvec,
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


