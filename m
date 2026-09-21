Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E12ECC982F1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 031196B0099; Mon, 21 Sep 2026 03:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23B86B00E2; Mon, 21 Sep 2026 03:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E123B6B00E3; Mon, 21 Sep 2026 03:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD36A6B0099
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:00:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EAF081604A1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:43 +0000 (UTC)
X-FDA: 85236871566.04.A98E8C3
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id C9969160011
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:00:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I6PFtfnL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789974042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQVZJ78aP0lkQNEjnZpNMmJch3AXFfyZ7AVo3FFpGzY=;
	b=bW7YmZxfyOypnfLSPdDeRHw/yWn1gVxWYRYhpUB9Bzw3qgXDTXpS7OBFUNPDluEn8nwNdA
	zqlgQFoGqtw3uoI88ltZvoNPUjixlsKoNJPdW401F75dJjUOQcx2nmivC8+6U7qC3Vp6CI
	1sLP2C+67zITuRgHCcE+qwO9pkzQze0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789974042;
	b=4ow6mbRv1iUDwTV2Ly0cJkJVmwg/LBDnhGBK5ycAf7aSg2iktHhh8LPOE1QKdMSWZYML3a
	q57RnTylLB4e/2EbJs3pgTUG1Oq9eMcJ1fOzv/umokPhZ+A9gRAePDezgXh9WpJjPr1gHR
	xK8+vVkWnza7SJaMxUeIbcqPgnE7BrU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I6PFtfnL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TLZQlQIDzt2OohWOO5wD38jaj3Gdn2F1Ht1VsE34Ej0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789974040; v=1; x=1790578840;
 b=I6PFtfnLwAItmk5ez6jrUL842Fp5IqmdFIy/CLempbTd9dRNLwt0e1m45kgHAwjtXINEYp0O
 Y0Q2roic6ZdTUhReWoIjh7sxlul64e4Ki/jC7lQNY2VSG21brJpeAgfPjvkyCG2+gB6ry4aGB/q
 6in6CziMVVAW4Eh9y8dfa9Gg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6ebfb9316ecf8394;
	Mon, 21 Sep 2026 07:00:40 +0000
X-Mizu-Trace-ID: 6ebfb9316ecf8394
X-Migadu-Flow: FLOW_OUT
Message-ID: <01cfa2f8-753b-428b-932f-470a46221b4d@linux.dev>
Date: Mon, 21 Sep 2026 15:00:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/17] xen/grant-table: stop setting PG_private on
 pages for grant mapping
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Suren Baghdasaryan
 <surenb@google.com>, Muchun Song <muchun.song@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nico Pache
 <nico.pache@linux.dev>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Kairui Song <kasong@tencent.com>,
 linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Juergen Gross <jgross@suse.com>,
 Gregory Price <gourry@gourry.net>, Qi Zheng <qi.zheng@linux.dev>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org, Ying Huang <ying.huang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-3-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-3-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C9969160011
X-Stat-Signature: 96rex671tfgyhd189sc3urc9b4smqke4
X-HE-Tag: 1789974041-724526
X-HE-Meta: U2FsdGVkX1+kxxlgx1UerCS9qtY9qLf4//tnH9ziJpFJg2E2DsjHgAuhlFXVrB0InWrMx3A7cVASAnJS1MtFREu09kTX3iPQ+dRNeb8RYjHN3n8A9V6afiCNtNWaIlQpTUtTndcuEyYmC4vq5zkOXweoR8ZV4JsexWHAMWOoTr+eRkEseHSsm3Kp7hw6gnOuYSlyod2YkIZ2aVIwG7ox4/i1BqotlkbtvuvtN5//0BqYyydutMaM6hhf+QDUtwDWIoAJEv1Qoy/0Q0oYB7m502TK6lzvkP6pGZn0Wy7HrwHLiAZ23Oul5E/KGuj4CmdxJIXouDwMhaKAfFtMiEjl8HT9b1NVEiuBHRXIcaNVPIgLhrcMtggfgk/XBEI8hOrX1xAeyYyNGD33H5H5oVd/xJztB/p50HBgyJS0hNN3nsn2E/I+VvH6rgn+XjBp3qajILc5JW8Fy17n6SZgkmhblNECHN4UFf2XFN+OxEFNK6pfRc3tlaNPobdhPmMQW9ogKnG9qdEF29eiN2Y0MpeJVcx5FUzNkF2qc8rVBaCFaEKrh4SBeYB+I2ue8pet05KUyYsl3ron/LbsBC92CowQhyOPKuU3ADwJyt+HkVFxEe5RLMEx5ygm6D8HvXL3DDUz+gPaubGfURiyDkO1aBq6cfJ5FGlaXWGoMYh5D+OihmdowPjRTZooVF4rZduolV6FypvpCWSNjL5XzWcv08Ot6t7hAqofK0ykstmS1+4vpwFBMQ5/IzGg7KB04mFMOxrX3Lyu9vBI0ZbGd8owdoK+CituUEAxcHevpO3ntSGlWHVyehVU+S4ftE6NAm5It1+r6P3MBNvdvKndOeVMtFkQ04j3R2iLuGLQYlGj3ZdiuIF5cdLGXUjD8K2uCNzz0F2uNrKI76Dv11U50pTNB6LNxAFQZpMVk1bIyS9anJCbyvpLV0iqopJveDqFxnbSjrZZUzn6zhcWD+TKh1mDbuN
 EE42+gW7
 0DVhCBTafZt5/NFx2apn3E5TRY90FZDRecPzoFoDnQRrUogVNv1iNhnKJ6lo6rA9hHIPpv5gUUBXhYx1kG0whC3ENfhcPRldtol6WKlszoVOF32qnpIHFcgo1hNPQACzAyUhhR0JPY7gTWrrsWHgJhXiL+Dbzx4UTw1X1UTbYlnBmDgyL2S0RYpJ/xzDyf1EVYM6FN2H3wH/9yffEr2AyQT7DTDNlbLDyPfgF5lGop9ft0RCxsqRxFxvaSkvby6tX6SlODRlNbAh0SzYCDhLKtXdDFik3OmT1YtG+cXa1EY8SK4fudjfK0Uzmvh/K8Uny0DBuf+BgQo5EJxEyH1fSS45tqPWV1KaknIlmh7Fnc+yrtzRByF367jPs/Xxu7IgAlyLRR3skAYnegMnRA2gfSRURA5K3xLKeYhnbgwkhENrgKDH6gKNat6IiyPJZq81FqwnrnJn2v6RtH20G/Bq4X5ZnOTIcYz2oX4zXACgfk1S0d57sqbqEn34NDPjmQBuo57KcGOYMygInVDAcEm66gkPIJVFTcsWR1p7D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:27, Zi Yan wrote:
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
> To: Juergen Gross <jgross@suse.com>
> To: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: linux-kernel@vger.kernel.org
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Nothing jumped out at me, feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

