Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065BEC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA926B00A3; Wed,  1 Jul 2026 03:52:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81B96B00AB; Wed,  1 Jul 2026 03:52:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D98AD6B00A5; Wed,  1 Jul 2026 03:52:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B41FA6B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:52:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B6831202A3
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:52:49 +0000 (UTC)
X-FDA: 84939441258.06.45F3265
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6B96020005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:52:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfkccUaU;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892367;
	b=8abTbvaG84c1JgsA7Pfkjn3CyGoWtfSjNFB8f0gFrrRL+ero82STE5DXu6MZSwzlm18E6T
	WvVf3n1GsjSylVB4H16CjkgjEpbjj52AccaxHaa4QIBo76lsAnVNrtjYsqlRqxZnETC7GG
	Wq+tdoWD9I/xHyMFpjkyfz4qIwmNo+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKbP//8QY/1Wg8mxCuHp5FUFFSyQtjbWDh9zGpFf3So=;
	b=fw9cxfFriMJh8wpqzoUTwmGNYqd0DK3FMqve4e2JwEVQcprsJ86smcu5EwyUA51uiIBdtb
	fPvMhXwvm5GGMmQW8c8r5MKTMIxG+JZNQzzfr9Ettl2TwzgeSnO7iMgtBNYlkNHjugTx+U
	NZfW7dkWBGV0vbHn+5NwycY0D6TbMQ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BfkccUaU;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 85095401A1;
	Wed,  1 Jul 2026 07:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BC11F000E9;
	Wed,  1 Jul 2026 07:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782892366;
	bh=dKbP//8QY/1Wg8mxCuHp5FUFFSyQtjbWDh9zGpFf3So=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BfkccUaUHNEF3dFaQxfhFNmbE1hneuuMzRIfimnOcg2P32HwBacsPUbASExpHlJdK
	 Y2vhbA8503NFx5NS+gVisL60jOQEnvfnx1A1ZCgCwFAx+h08h9bsS/asVNTEp+gF9V
	 TGqLsLO3z1DBRzKYa5VSGlvDFQFCw1Uhbury5toMFY082g6+ddPHXeG4OKCjrj0ni+
	 n50ynsuZNmW9BZIoMt6QKVzLKSFq+2YugAGjJtKA1C1a4B6eTQnZwUNOMVQRnAhySO
	 ydNB2WgIzAdA8AyrpNeMXgCFBgvP4H7Y/P+KURSkGz7Pfl/ZVzcyn5eeSGq8eBHu7w
	 W4fe81xA5hxWw==
Message-ID: <d7bee578-7f0d-48c3-9eb3-65999476b7f8@kernel.org>
Date: Wed, 1 Jul 2026 09:52:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 11/16] sgi-xp: Use higher-level allocator API
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Robin Holt <robinmholt@gmail.com>,
 Steve Wahl <steve.wahl@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-11-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-11-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: rw9f8oxakzby9bwdtgoru3prip3oh7br
X-Rspamd-Queue-Id: 6B96020005
X-Rspamd-Server: rspam06
X-HE-Tag: 1782892367-567174
X-HE-Meta: U2FsdGVkX1+QmLk7rOK2eZBVHCyo/UDCQdWUWeR8G1KKIKntCQABK4vCtEsf1eVzIHj7ik8Bw3Ror+nDbEkNdMA3V7rYudhl6svZnWJLESUZTiLzz9+z+lvMdPRS/Zxf4J+PiSWRUV1/NrEJ95b0p8bNSHvSa+Wb/D1b0SIxYDfbNHZqMOWUomd//Q2uFXdkxxTvqOReYXjFCB+Z+lPHognssBsz+dvlV4c2uIM2cNPahfEZqN+GJrCLj0GufXr31ut/aUlbHOOTz3Gms6oTcXIcymD4qpCHC6TxS8gAA9pf4KknZJXjK+sd8AQBy5MPp4wp+fELRTna++2QEXA9UDn/TXCicxZvHTAPzlosZFczUcOnwrnCN3eMmHEwgKfZBahID3LZuhnd9jFV+uXhjGy+fxDhZYmkWR7t3XQmIK8XKt2tH/BXsMdXb4yjo0uPyWEIeMuurWvPVZRX06nk4ZthFIly+D3FYEqm+6dQzNEBKXdcqwTMw1lWlmpKM2yZXYBvWNhZM3GDWN+GdqD1Uon2h2GG7zhYTmlmgdQPPdxMddm5KOX74I7RjhZPrMhnwY5F9u8CNr+qPqrpCWyGHYtccMGXrVgGyYB4zlSY0ufh80W8Zq8Me5ZxthWG2y39PCMByuOFRR2eNCvZ4i+34CFybVXElZqEWB02fenXVtFez7eOkGmZootpqKmHIoiRjk1Hqc+yMJwUyNw6lXOUmBsBFNr4DgYKZk2A2ZRxbhr6QTV8YnY+kbwy+Hky6fe6R8szhZtdwx7Etdf5p3p8whKRglLYcerXEWQEMIQcZ3W2JDNu6QmynG1ahSCjzZ2YbgVIjsPrUJhDKD+4bEAn4JJG0EE+a9h1XH4N0kheMTQBbwxpcDVK4LikiYkt/jR0T9QRfXdE8NAGmhbi7Ic5hqY+5twSlGlEe1FsqX1hyiRDlHX5nS7bcbADKOcuU1A1dtebOc7SEWK1540Zuu9
 wNasuN6W
 H5JwheBzSOsQuH4Mp35tMFGI3+DnhM+OcOb2Sd8OoACO31MP+ihiW3/xvN1ljVemKBFtegWJEtdgVk+9GVJCbk5D+2u9ksn7BuYvc/SehNMrJPv7hsTaxHT5GRU83X3F/R1u31zWa7DySu/VotzFEXhhH2hBe+SN3RiHWITsRgZ3t8f6O7tkye8aYzdL5SqR1YMN2xm7/A1jhSDkUTkmZZ/mQuqn0gzIURP+5rC/jCc3SAdgVj5nw+heHRMg62Py7Gz5DdVkd5hzArpLgeWMA/qehfU8tmMF/Bp62n3ki6RTFiJXPjVsZcRdhkYrA/wejfDa//Cd9HTdWYnrI0lscENQK8hljhyJPFPrVTVAYBJr9uvcMvZLfbvXvWlPHM2yWzDoYBeLrJM4ueOn7X45PSfGNyHpmHtvXjUsCgbjX8c0rXRhfXjIifcUWNQCHMSWBjnPOF9tfiuX5e5tJ+0u3VqfNFpjN1KnG7TeUd6pUX6Dwvag=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:12, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> No functional change intended.
> 
> Cc: Robin Holt <robinmholt@gmail.com>
> Cc: Steve Wahl <steve.wahl@hpe.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Assisted-by: Gemini:unknown-model
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Nit:

> ---
>  drivers/misc/sgi-xp/xpc_uv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
> index 772c787268932..aacff70204241 100644
> --- a/drivers/misc/sgi-xp/xpc_uv.c
> +++ b/drivers/misc/sgi-xp/xpc_uv.c
> @@ -170,7 +170,7 @@ xpc_create_gru_mq_uv(unsigned int mq_size, int cpu, char *irq_name,
>  	mq->mmr_blade = uv_cpu_to_blade_id(cpu);
>  
>  	nid = cpu_to_node(cpu);
> -	page = __alloc_pages_node(nid,
> +	page = alloc_pages_node(nid,
>  				      GFP_KERNEL | __GFP_ZERO | __GFP_THISNODE,
>  				      pg_order);

gfp flags can now fit on the line above?

>  	if (page == NULL) {
> 


