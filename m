Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 092E0C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:15:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2397C6B009D; Mon, 14 Sep 2026 09:15:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E9636B009E; Mon, 14 Sep 2026 09:15:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4CF6B009F; Mon, 14 Sep 2026 09:15:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8B946B009D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:15:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0ABCC013E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:49 +0000 (UTC)
X-FDA: 85212415218.04.956B386
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 35E74A0006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrUcY1Z6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391748;
	b=llKE8mSFTygvnGTyY6mgHXYlbeJDy6Sb/LZsYiT9PNlpb3BCxRzAPHu4J5/a2ql6LfpihN
	oFRweZgsVA0UmDLTzttHHwuTVSvXSzT1QoTDRinxJYU+nZsC8e4/2mIVhoAGP2F6Vbd+22
	scTij/9Pr0oesUSgmaO7bj6Dg7B3nHc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nrUcY1Z6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MgZNxAm6rLbdWEaG1tKVLSEArg8sJOE28H+A/hGdqY=;
	b=5i0Q8gLzPJfneyaIWIf3+P2a7wqpc2YNzhcEDbYnM5PhYC46zCnD/rZaFb74beTOhaUo+o
	Uxif6FYfGTU3FDrxz6lN5LlQNwyj4EPIckpb60JV/1m06rRixJsTCbR7GVbihexetLteA/
	c6MkA+K9KF/pJbjgQJ/A5Z22nYC+bl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A339460120;
	Mon, 14 Sep 2026 13:15:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BC7B1F000FF;
	Mon, 14 Sep 2026 13:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391747;
	bh=7MgZNxAm6rLbdWEaG1tKVLSEArg8sJOE28H+A/hGdqY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=nrUcY1Z6EE9Yx3XyardKgLAilyIh7MG7IgdjNN9c8v3syQj4OF+ECl1T9O/tXLQCv
	 UVtqX/wTf76sh1GACfeMRusPbe6Vj5/1dvuMmVo4YB1cwMZck8rrjeFPyGMyokvA0O
	 iAlby2CTO5yt/kB3WNF3NjgTOYDx48nsnszifQkqaqFLCmXQx3e63oyIez2RDF8qmX
	 ml8aUvxpYcLKp85j9j2nc82pVP/v0RMqMq4ZSDblHPVUXXQqzi/VYRtpwP/4EpgwAC
	 VT051wV3YVZ0kc2khK+T8fxTqk4DrLkiyLpI1qQvmkX9U2Hn2fRZDlzVSwfbOGtvgz
	 xUjfBKk257kqg==
Message-ID: <ce7cc93a-a752-463e-a551-fbf138c29916@kernel.org>
Date: Mon, 14 Sep 2026 15:15:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/16] xen/grant-table: stop setting PG_private on
 pages for grant mapping
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913-remove-pg_private-v4-3-848550f7574e@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260913-remove-pg_private-v4-3-848550f7574e@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 35E74A0006
X-Stat-Signature: i3urtefgb5i9sfti8iufb7is81c5agbn
X-HE-Tag: 1789391748-513970
X-HE-Meta: U2FsdGVkX18S9CR3alVa7oJ6oUSnlBlzuiH7h0hGbJmEpEVQ0t+XUEliVFTx8dyT7qzRwaRrOgQ6k6TLT6/qbi2iSmr30wWTT+xeCH6AsCzQzurGm0nJqpCvA3BEUK5sRRpoVQY9j2vHiVZkszU2qNEmVhaifuxnGsZ5ZrImESbm9wBDfQh00FQ+I70nvvJeodQVnKn7zjrsnw44z5/8tqFzmze83/UHWHyXpMPmsasO7K+tY1uLW8AUSqE/qVcGA/u2ZGOXAXYErNik2kqrxbfFKPy0UQjZ5eQ1nRv9pJaYr4R2ttJPhMtt4vpd3V5w3xx5pzLLtUkt4iNT6ozhksxLFrX8O5XMIU6SfCcppteiV8DsRifoEEzNMYqRvpI1ve6s8cZI6tjxTuPYUZ0TVNbiZ6qvTgC38gTuoc574kkGxwJbTNlkP0D/jgMKtUY3hAUidTWxNax/57Y926VHTYFqt3ugECV5MNsVkeVUwH9kqu3w0gdd3zGz5kBP+gXo4iQvEFQY3foV6J+WdDCZ/1pCtsh3EbyscolIbP4esSUMeQj7w8Mi23145m2pRuhEqSiG+t0NR+9RWgU3IR3OeocNqGzm+dzInArXEA7IupB0/YsQisg6nwuZtYg18uTZL3cK7CbnYvXQvkHGQX2lgzV/EWj7r5HmVp26i+efKpUXHzVWNAkivvwE428JwZbV2JOebF3IrwIHhQtp/Y4uRM2AicchwuRUnbNeRmREmjMvRkA/RWmrsncoNQ5Rx6hAov6d3d4c/63rwBi/wsZ9hdTLa/JF3HcBCouBpXJdgoEMQGESjhZvipjCcve4FHiTAoDAgAXzv2O39XZbeJvOHN8cbLNIxWYLUQeDE38gwErtRLmjGokUlhq6WIGzd63Ycx5Rl46JxU+TFW74ONTcDevbWP9fiQg7d6+q+bye5d9T6fGJxJ4T0aLsIjSJEIe7nhIEDPjrR4mZ79xO1T1
 cdw2dJ4C
 G3I89xX2GDWHMvwL1DtidQjhvBUhWrgoKFryU6zF0DIwFgh1zHFuIVDlUEetiRbPv2mgtRNZEEuBX2wKWuG1EWXIESjdKO6H7a5n3QnPVdofBcJPHll+QlL22JbhX2ne2bi13XPByjajeXVBoxeYy6gUJjb4uvebj44yof1plkc37S9zuL+GfBoZSjOE2/JbW6rTXkkQr7m4gbYRLIUharOG3sfZIwvl1P0Z6UrNKbk4OftbDfxVyP+ao0Q5tCL1FPNOYVTYtBQh6kUhM1y9AkJ9uQ37ewPMLVZhrJe5YsD4Vvs24rDUNZZqKIPaYwqIdgCRgDKlxfrAH6NdH+ztt8levTlwipbYz2FWtQ7vCH7IwsbmQuk4gWZz7tQioSnCWd4v0ujr3+Bm1qlBqV+tBOWayCe2Pq6RyWK9cNkwRcz4CKcNAuovZY38Nj1apN6mwkYNFWQzH7cy0ylODBuDyZK0aF+GdNzwZHwQsbHr9fZyWHfQ6GG5RL212QwNjfzeUimQ8mEwTLsrz2lo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 04:24, Zi Yan wrote:
> gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit, a
> pointer to an allocated xen_page_foreign is stored; on 64-bit,
> xen_page_foreign is stored inline. Checking page->private != NULL is enough
> to tell whether a xen_page_foreign needs to be freed on 32-bit and
> page->private is zeroed unconditionally on 64-bit.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Juergen Gross <jgross@suse.com>
> To: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: linux-kernel@vger.kernel.org
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

