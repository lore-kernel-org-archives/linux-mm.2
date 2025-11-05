Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F18F3CCFA05
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 11:42:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F618E0006; Wed,  5 Nov 2025 06:42:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FE48E0003; Wed,  5 Nov 2025 06:42:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41D7E8E0006; Wed,  5 Nov 2025 06:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 278B68E0003
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 06:42:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CFBC91DFE36
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:42:18 +0000 (UTC)
X-FDA: 84076365156.23.7EFEEBC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3EDBA160004
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 11:42:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAEyUJmK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762342936; a=rsa-sha256;
	cv=none;
	b=G6760g/ye8jwYwQ28nfj0NpaNkiVXTBt1pfkyIoEaqZXEy8o2rNPFOs/ZBjp+5695WFUEv
	JFVli3jJ8ovGF+JOTZgVich4tx+WSkjo0lYLZ6H0qjHKWOipy5Mlp+M5ZGNQy9dN0KD4h8
	hYFZxBQaNQBpseAnzeYUkSlrVez5bYc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YAEyUJmK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762342936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cqj4OVlBy+gvZ7XqMUq9pvYrZ4QvQPUtMEzErvpPvOU=;
	b=sRLiDNgq2E945nFFEsESmTxjT+scPmSlXL+SKk666S6Xpdo4BbhqAoQQIfiGxqqAHPW1b5
	iPueiycf8vdI1u2TzkDglvmiQamrZ+qr24kfGnwczJJDcAzOBV6R4Fd3LUoiD3w63N5jzg
	HE76uP1XWA58oH7+Ic/7JnFmWgBY+sU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762342935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cqj4OVlBy+gvZ7XqMUq9pvYrZ4QvQPUtMEzErvpPvOU=;
	b=YAEyUJmKJ9X8pd9KtpuKNEu3RnmDwBZRtSvSVYoHZLD3uhSz4jXihktMk2XG/NxN/tn6GJ
	YR9msKWDzrQ1kH6y4PPwiqJx9x12fqEIdarCPTLfBDNwvL3lCPGOAxjFOdJnf+4FsUUZP9
	S3hNXYsIPnT9mYieRVk1MJ456YTY3vs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-K74TAuv9Otq27xW_ePkDpw-1; Wed, 05 Nov 2025 06:42:13 -0500
X-MC-Unique: K74TAuv9Otq27xW_ePkDpw-1
X-Mimecast-MFC-AGG-ID: K74TAuv9Otq27xW_ePkDpw_1762342932
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-475dabb63f2so35046385e9.3
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 03:42:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762342932; x=1762947732;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cqj4OVlBy+gvZ7XqMUq9pvYrZ4QvQPUtMEzErvpPvOU=;
        b=ng2kX77MnvTt7sFROCUyPE0yX1Nnih67RZ2mPbYP91o3ACeTsHBL2qwNPMgTNfselp
         FszSxO63EdussnS7XvwLNQ6oIzxogggzU7L1kGOp0o5whDkMCLfnCPYvs4i7RK4+ZrTT
         tZhwk6c/kM5LbHYJ1pzdPn5b+pvFbpwTNtiDgI8uXGAajBSLJ4D8u5JZ9wM7oZHVehiZ
         54LioKq5H736msSmuck3sJ7viqnWv48xduLOedvxKsQRAJ8DqDYLMINgMV1vdRM85wtv
         oQTUzhhasD5g3uE2Tc8GDbBSBPQWYn68z/s/1QjPo2UmYirKh6/D7pDaPxvFgx1zX6P2
         Ac3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXuiZOX6ANOvYSQOru9D+NlMlDrUHPNmfWLRr5MGxrhDrMgOiUvmdPVxcs+oyl5WWN0PTr4sGRYDQ==@kvack.org
X-Gm-Message-State: AOJu0YzMasIc2FyY3N09CLZqPywNAaq/k0zhwJHbczP2UYjga3DqQUE0
	yNF+ViOYYTkN8NOT2IKpuQxIJobQhNU4QdVdyJxwxJLbaHvV02TzjWyritjJ00892MjzHWqmNNP
	gjil8p6odnQ/ek0oUkdZBq/b6didEpjuxmZbdhkBZeiKrfVXr6sFe
X-Gm-Gg: ASbGncs7KPe8rhLCiXfUiaAE+WLehd1faPQHtD64pkfP7W6vOzxjhx2UoKw66ZsXBXn
	HGMHWNVA+p21lQft91viE+Qw1Z6mBNHHqN2gTO8+PcJM8O6qKxHqY7HzFcg0JeWp0pk4cdyXp68
	0ELxLPi0owVca35gC+liQM+nw2+OVJFBpu8ry3B9KgGeWhSQp6bWOxOcILNYcQ6XQzz2e1Hdn2t
	F6yep1ZvlFPDEX+tLGNsMkXX4FmXSuYV5Eo+3foiF1cfasaT8ndXGOWoPiRFJrbU59IBUovFaLX
	d4aRw0VLr2KjGs/qNrsDxhxy96oY01fpOoR9l2PbH9nJQU33Ko8Wl8TknUF4qAO3f770FNTUShM
	cJlHxXZVteXR8bMsCKJ0cgRKe8j02/td6g8cfGgcJT1CC9IMyEhIx10RQK9uY3lW/77n4GLTrVi
	eNFm+8Zf+cXRcymzGgoFEmmZU=
X-Received: by 2002:a05:600c:4e88:b0:471:13fc:e356 with SMTP id 5b1f17b1804b1-4775cdad3abmr24308305e9.3.1762342931918;
        Wed, 05 Nov 2025 03:42:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE2aR4k/KEuxXU0V5B0fBQhVFJdHvYsc7oYnt0nj/Pl2tNdjM1eHshBthcnnfeWZdiu9Bf6jQ==
X-Received: by 2002:a05:600c:4e88:b0:471:13fc:e356 with SMTP id 5b1f17b1804b1-4775cdad3abmr24307915e9.3.1762342931385;
        Wed, 05 Nov 2025 03:42:11 -0800 (PST)
Received: from ?IPV6:2003:d8:2f30:b00:cea9:dee:d607:41d? (p200300d82f300b00cea90deed607041d.dip0.t-ipconnect.de. [2003:d8:2f30:b00:cea9:dee:d607:41d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4775ce20ee3sm43411365e9.9.2025.11.05.03.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Nov 2025 03:42:10 -0800 (PST)
Message-ID: <9e29972b-6f72-4228-89bb-0ede44ed5e83@redhat.com>
Date: Wed, 5 Nov 2025 12:42:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] mm/hugetlb: extract sysfs into hugetlb_sysfs.c
To: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Hui Zhu <zhuhui@kylinos.cn>, Geliang Tang <geliang@kernel.org>
References: <cover.1762245157.git.zhuhui@kylinos.cn>
 <6c2479ad2a5227cc025954a68c9f3c43b659b698.1762245157.git.zhuhui@kylinos.cn>
From: David Hildenbrand <dhildenb@redhat.com>
In-Reply-To: <6c2479ad2a5227cc025954a68c9f3c43b659b698.1762245157.git.zhuhui@kylinos.cn>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uoJRck4rT7zZpuBVa0h5hMZKxMUnJ0Ma0qI-pcWt-e8_1762342932
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3EDBA160004
X-Stat-Signature: aoer61m9seoej3g97xscqudmb7tjf5q1
X-Rspam-User: 
X-HE-Tag: 1762342936-588392
X-HE-Meta: U2FsdGVkX18YP6OV0W+QYsb9BkF/OIZo8j6vT048WFwTK4gEj+kQd2hwEILkcpiI1UEJzKys0BiodncXiH/RcR8MOsxZR5vCkok30IBeVoS4RayDIcSdGFiLLusQXlUUj5uCHTGJUoisXf3aNNHtn+6OSq/qg5y/c/eGOOPSLHQerGWWGgCYNlLEN4TFeQDhXUOwS366s3jMoMfa1D1l229v6UaS1TU3ksgUpKMSSXzC9iBpirGgF4mvy4E6tmVRpWlfL3BvBRJvS9G5nubr+/KsEFbP2/mwAgJ3gXAJ1KI9LowqVXnEpblfcsOSwAF/Ys4IpZRst9+rrwwu7ttEQF5SUooR7bmjz78/P0mF1JktDdyLqL19EMemTSCmN2gmSeUpQQuWN0kvgyPpe1uyXgh+oQNBM90U1S5052YUNs2J+DPc2usnYwtqwlE0qWmxALoZYLjm6+EBvcDs6Y0MlqbxU6+7b4RHoWMfWvK7km0/7rVKNOfQQU9rC7v6Ul9UJOK8ha+n5cUwe9DipQMpfpxmALatcAZFoSKNhVDmyPOx63Lf6AaR4IOt6UCrI6PFnJ8aFmLiuFf8leKberRV3DI9hoFD126yeNa7gVpChjFDyeS3X9YawE3ndCm2gPtNG/IXe3zUtiU8pkQqgkTrtF3cGw3veUCNwgegztHMzkiVNP+jKiAn3Tdj3YybbfsiMK+ftN7iteWYnSNX0IhqWs7DGC0yxkGcpl8VJIClyCRn81Gs85YQdSw3n9W0SQa3n65dRvsZ8P2Y6rScs55K5ZNy5cplLURGzYq8zIIAM7Xouatj7RyJzjZpDkqteRGt2aLxeKlEJY19nYkSlw9I8al/8w9o1AIJjUN0gKcOachzMx3NfqhiBD9SttglyqvOPcF3RceGXVNZ1Luwc7CJJQekS+YwWpcrGEL4Fk5qZYJM/9ZJZ6cFDT7Z9dzwlFrnCX9nIJgb3+eKHTy8gzq
 ZuBeyFmZ
 Ki67cYNnEvuGl0hjkvyL8N9uBvKOwjywpq05+XCbo/JRoyQkDzM/kSYzRnLRv2pMyS+nxLb2vvHA188Jh+YP3+elKwPR2+4mei4mG4RtOkA37BuEyKuw5I6xFGzq5zxfFB2+LSZUUyNzkPluwQ9D+Ymjuymex3NzUknFsVGgKcAYwqm2EtP44d5iVRm58thrAsRZCJ3jgcoqrLjqcZBA272u+sgeWB4BPnqaqtT9pHplLHnJncBseDCHRlz/kKvGUHYtryV5ky7y94Lq6nY5zesmgV1H3LE3YAn1dt3MbWC8s+BR/KlCrFfMu8jL6OKMMj/lsDDEX9biIm3buwoC7JR6hn9prLealESQxrMkoUsD4a5yit6fRSSL5u8K6mspqDhPRQ+k6U+iLKIq/h2/7gSSRuSV9hEWDc0GzMwiuudfZKFY/Z3F9yDRUvRHdOWig6ojQJc9Xslh49fUnoBu7ZSG9/Fzg233WA3S2abfw8crY5zzc/yWi30Oi15zY0qsjkQUJHvDUnhB5GIlkjz0F5NAwNA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 09:37, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> Currently, hugetlb.c contains both core management logic and sysfs
> interface implementations, making it difficult to maintain. This patch
> extracts the sysfs-related code into a dedicated file to improve code
> organization.
> 
> The following components are moved to mm/hugetlb_sysfs.c:
> - hugetlb page demote functions (demote_free_hugetlb_folios,
>    demote_pool_huge_page)
> - sysfs attribute definitions and handlers
> - sysfs kobject management functions
> - NUMA per-node hstate attribute registration
> 
> Several inline helper functions and macros are moved to
> mm/hugetlb_internal.h:
> - hstate_is_gigantic_no_runtime()
> - next_node_allowed()
> - get_valid_node_allowed()
> - hstate_next_node_to_alloc()
> - hstate_next_node_to_free()
> - for_each_node_mask_to_alloc/to_free macros
> 
> To support code sharing, these functions are changed from static to
> exported symbols:
> - remove_hugetlb_folio()
> - add_hugetlb_folio()
> - init_new_hugetlb_folio()
> - prep_and_add_allocated_folios()
> - __nr_hugepages_store_common()
> 
> The Makefile is updated to compile hugetlb_sysfs.o when
> CONFIG_HUGETLBFS is enabled. This maintains all existing functionality
> while improving maintainability by separating concerns.
> 
> MAINTAINERS is updated to add new file hugetlb_sysfs.c.
> 
> Signed-off-by: Geliang Tang <geliang@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---

[...]

> --- /dev/null
> +++ b/mm/hugetlb_internal.h
> @@ -0,0 +1,107 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Internal HugeTLB definitions.
> + */
> +
> +#ifndef _LINUX_HUGETLB_INTERNAL_H
> +#define _LINUX_HUGETLB_INTERNAL_H
> +
> +#include <linux/hugetlb.h>
> +#include <linux/hugetlb_cgroup.h>
> +
> +/*
> + * Check if the hstate represents gigantic pages but gigantic page
> + * runtime support is not available. This is a common condition used to
> + * skip operations that cannot be performed on gigantic pages when runtime
> + * support is disabled.
> + */
> +static inline bool hstate_is_gigantic_no_runtime(struct hstate *h)
> +{
> +	return hstate_is_gigantic(h) && !gigantic_page_runtime_supported();
> +}
> +
> +/*
> + * common helper functions for hstate_next_node_to_{alloc|free}.
> + * We may have allocated or freed a huge page based on a different
> + * nodes_allowed previously, so h->next_node_to_{alloc|free} might
> + * be outside of *nodes_allowed.  Ensure that we use an allowed
> + * node for alloc or free.
> + */
> +static inline int next_node_allowed(int nid, nodemask_t *nodes_allowed)
> +{
> +	nid = next_node_in(nid, *nodes_allowed);
> +	VM_BUG_ON(nid >= MAX_NUMNODES);
> +
> +	return nid;
> +}
> +
> +static inline int get_valid_node_allowed(int nid, nodemask_t *nodes_allowed)
> +{
> +	if (!node_isset(nid, *nodes_allowed))
> +		nid = next_node_allowed(nid, nodes_allowed);
> +	return nid;
> +}
> +
> +/*
> + * returns the previously saved node ["this node"] from which to
> + * allocate a persistent huge page for the pool and advance the
> + * next node from which to allocate, handling wrap at end of node
> + * mask.
> + */
> +static inline int hstate_next_node_to_alloc(int *next_node,
> +					    nodemask_t *nodes_allowed)
> +{
> +	int nid;
> +
> +	VM_BUG_ON(!nodes_allowed);
> +
> +	nid = get_valid_node_allowed(*next_node, nodes_allowed);
> +	*next_node = next_node_allowed(nid, nodes_allowed);
> +
> +	return nid;
> +}
> +
> +/*
> + * helper for remove_pool_hugetlb_folio() - return the previously saved
> + * node ["this node"] from which to free a huge page.  Advance the
> + * next node id whether or not we find a free huge page to free so
> + * that the next attempt to free addresses the next node.
> + */
> +static inline int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
> +{
> +	int nid;
> +
> +	VM_BUG_ON(!nodes_allowed);
> +
> +	nid = get_valid_node_allowed(h->next_nid_to_free, nodes_allowed);
> +	h->next_nid_to_free = next_node_allowed(nid, nodes_allowed);
> +
> +	return nid;
> +}
> +
> +#define for_each_node_mask_to_alloc(next_node, nr_nodes, node, mask)		\
> +	for (nr_nodes = nodes_weight(*mask);				\
> +		nr_nodes > 0 &&						\
> +		((node = hstate_next_node_to_alloc(next_node, mask)) || 1);	\
> +		nr_nodes--)
> +
> +#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
> +	for (nr_nodes = nodes_weight(*mask);				\
> +		nr_nodes > 0 &&						\
> +		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
> +		nr_nodes--)
> +
> +extern void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
> +				 bool adjust_surplus);
> +extern void add_hugetlb_folio(struct hstate *h, struct folio *folio,
> +			      bool adjust_surplus);
> +extern void init_new_hugetlb_folio(struct folio *folio);
> +extern void prep_and_add_allocated_folios(struct hstate *h,
> +					  struct list_head *folio_list);
> +extern ssize_t __nr_hugepages_store_common(bool obey_mempolicy,
> +					   struct hstate *h, int nid,
> +					   unsigned long count, size_t len);
> +

Using extern for functions is no longer used.

> +extern void hugetlb_sysfs_init(void) __init;
> +
> +#endif /* _LINUX_HUGETLB_INTERNAL_H */
> diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
> new file mode 100644
> index 000000000000..a2567947d32c
> --- /dev/null
> +++ b/mm/hugetlb_sysfs.c
> @@ -0,0 +1,629 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * HugeTLB sysfs interfaces.
> + */
> +

As I said, we usually keep the copyright from the original file.

> +#include <linux/swap.h>
> +#include <linux/page_owner.h>
> +#include <linux/page-isolation.h>
> +
> +#include "hugetlb_vmemmap.h"
> +#include "hugetlb_internal.h"
> +
> +static long demote_free_hugetlb_folios(struct hstate *src, struct hstate *dst,
> +				       struct list_head *src_list)
> +{
> +	long rc;
> +	struct folio *folio, *next;
> +	LIST_HEAD(dst_list);
> +	LIST_HEAD(ret_list);
> +
> +	rc = hugetlb_vmemmap_restore_folios(src, src_list, &ret_list);
> +	list_splice_init(&ret_list, src_list);
> +
> +	/*
> +	 * Taking target hstate mutex synchronizes with set_max_huge_pages.
> +	 * Without the mutex, pages added to target hstate could be marked
> +	 * as surplus.
> +	 *
> +	 * Note that we already hold src->resize_lock.  To prevent deadlock,
> +	 * use the convention of always taking larger size hstate mutex first.
> +	 */
> +	mutex_lock(&dst->resize_lock);
> +
> +	list_for_each_entry_safe(folio, next, src_list, lru) {
> +		int i;
> +		bool cma;
> +
> +		if (folio_test_hugetlb_vmemmap_optimized(folio))
> +			continue;
> +
> +		cma = folio_test_hugetlb_cma(folio);
> +
> +		list_del(&folio->lru);
> +
> +		split_page_owner(&folio->page, huge_page_order(src), huge_page_order(dst));
> +		pgalloc_tag_split(folio, huge_page_order(src), huge_page_order(dst));
> +
> +		for (i = 0; i < pages_per_huge_page(src); i += pages_per_huge_page(dst)) {
> +			struct page *page = folio_page(folio, i);
> +			/* Careful: see __split_huge_page_tail() */
> +			struct folio *new_folio = (struct folio *)page;
> +
> +			clear_compound_head(page);
> +			prep_compound_page(page, dst->order);
> +
> +			new_folio->mapping = NULL;
> +			init_new_hugetlb_folio(new_folio);
> +			/* Copy the CMA flag so that it is freed correctly */
> +			if (cma)
> +				folio_set_hugetlb_cma(new_folio);
> +			list_add(&new_folio->lru, &dst_list);
> +		}
> +	}
> +
> +	prep_and_add_allocated_folios(dst, &dst_list);
> +
> +	mutex_unlock(&dst->resize_lock);
> +
> +	return rc;
> +}
> +
> +static long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
> +				  unsigned long nr_to_demote)
> +	__must_hold(&hugetlb_lock)
> +{
> +	int nr_nodes, node;
> +	struct hstate *dst;
> +	long rc = 0;
> +	long nr_demoted = 0;
> +
> +	lockdep_assert_held(&hugetlb_lock);
> +
> +	/* We should never get here if no demote order */
> +	if (!src->demote_order) {
> +		pr_warn("HugeTLB: NULL demote order passed to demote_pool_huge_page.\n");
> +		return -EINVAL;		/* internal error */
> +	}
> +	dst = size_to_hstate(PAGE_SIZE << src->demote_order);
> +
> +	for_each_node_mask_to_free(src, nr_nodes, node, nodes_allowed) {
> +		LIST_HEAD(list);
> +		struct folio *folio, *next;
> +
> +		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
> +			if (folio_test_hwpoison(folio))
> +				continue;
> +
> +			remove_hugetlb_folio(src, folio, false);
> +			list_add(&folio->lru, &list);
> +
> +			if (++nr_demoted == nr_to_demote)
> +				break;
> +		}
> +
> +		spin_unlock_irq(&hugetlb_lock);
> +
> +		rc = demote_free_hugetlb_folios(src, dst, &list);
> +
> +		spin_lock_irq(&hugetlb_lock);
> +
> +		list_for_each_entry_safe(folio, next, &list, lru) {
> +			list_del(&folio->lru);
> +			add_hugetlb_folio(src, folio, false);
> +
> +			nr_demoted--;
> +		}
> +
> +		if (rc < 0 || nr_demoted == nr_to_demote)
> +			break;
> +	}
> +
> +	/*
> +	 * Not absolutely necessary, but for consistency update max_huge_pages
> +	 * based on pool changes for the demoted page.
> +	 */
> +	src->max_huge_pages -= nr_demoted;
> +	dst->max_huge_pages += nr_demoted << (huge_page_order(src) - huge_page_order(dst));
> +
> +	if (rc < 0)
> +		return rc;
> +
> +	if (nr_demoted)
> +		return nr_demoted;
> +	/*
> +	 * Only way to get here is if all pages on free lists are poisoned.
> +	 * Return -EBUSY so that caller will not retry.
> +	 */
> +	return -EBUSY;
> +}

[...]

The core demotion logic should stay in hugetlb.c. In egenral, I think 
hugetlb_sysfs.c should not contain any actualy hugetlb logic, but 
primarily only the sysfs interface.

This will also avoid having to export low-level functions like 
init_new_hugetlb_folio() in the internal header.

Likely, demote_store() should simply call a new function 
demote_pool_huge_pages() that ...

> +
> +static ssize_t demote_store(struct kobject *kobj,
> +	       struct kobj_attribute *attr, const char *buf, size_t len)
> +{
> +	unsigned long nr_demote;
> +	unsigned long nr_available;
> +	nodemask_t nodes_allowed, *n_mask;
> +	struct hstate *h;
> +	int err;
> +	int nid;
> +
> +	err = kstrtoul(buf, 10, &nr_demote);
> +	if (err)
> +		return err;
> +	h = kobj_to_hstate(kobj, &nid);
> +
> +	if (nid != NUMA_NO_NODE) {
> +		init_nodemask_of_node(&nodes_allowed, nid);
> +		n_mask = &nodes_allowed;
> +	} else {
> +		n_mask = &node_states[N_MEMORY];
> +	}
> +


... encapsulated the locking + loop below.

> +	/* Synchronize with other sysfs operations modifying huge pages */
> +	mutex_lock(&h->resize_lock);
> +	spin_lock_irq(&hugetlb_lock);
> +> +	while (nr_demote) {
> +		long rc;
> +
> +		/*
> +		 * Check for available pages to demote each time thorough the
> +		 * loop as demote_pool_huge_page will drop hugetlb_lock.
> +		 */
> +		if (nid != NUMA_NO_NODE)
> +			nr_available = h->free_huge_pages_node[nid];
> +		else
> +			nr_available = h->free_huge_pages;
> +		nr_available -= h->resv_huge_pages;
> +		if (!nr_available)
> +			break;
> +
> +		rc = demote_pool_huge_page(h, n_mask, nr_demote);
> +		if (rc < 0) {
> +			err = rc;
> +			break;
> +		}
> +
> +		nr_demote -= rc;
> +	}
> +
> +	spin_unlock_irq(&hugetlb_lock);
> +	mutex_unlock(&h->resize_lock);
> +
> +	if (err)
> +		return err;
> +	return len;
> +}
> +HSTATE_ATTR_WO(demote);



-- 
Cheers

David


