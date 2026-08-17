Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E20EC5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 00:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EED16B037D; Sun, 16 Aug 2026 20:47:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5826B0381; Sun, 16 Aug 2026 20:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DB926B0382; Sun, 16 Aug 2026 20:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA426B037D
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:47:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BB66F805C8
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:47:02 +0000 (UTC)
X-FDA: 85108921884.09.6AD3F24
Received: from mta1.migadu.com (out-55.mta1.migadu.com [95.215.58.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD55840005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:47:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Os/xQZJU";
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786927621;
	b=rx3oPbuzwf3R9jFnDwnqIJNvnrD7Nl01nglnBitnI6LCudDbHzdR7lP0HsuHaPSEtsVn6T
	fDY2iRuH9uUDnxnTiXLnD6O5t8ILbgdbDOeCQ9jMLGBQz9mS2FVDXzHjFoA0laR5yeGnSj
	97toV+Tt7/PvCk2VpL/8B+jipm90VkA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Os/xQZJU";
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.55 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786927621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qtt4LQ8cSbLZ9yXXQdEILKcexLawEzM6wRDjI1YA8k0=;
	b=wKWfg2uRsPDvH+glZI6gJu4tNksbqUE3paqgtEVS5fVhATpPK23yOPMi04mZ2NjjX9uJxg
	TkJYVftrHLlxq6B2lXSsHBaNHFi1qijqECUsWk7BVbHXf/LdkRZ2lsTOwqXqaQCn3j/7iD
	RVdJP5Wg10Kur9ky8Ks2wIaVp6fWl3E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RmRDd0T1DmftRn82bVM/bMZ1+VjMHGBKK/DFk8gJdq8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786927619; v=1; x=1787532419;
 b=Os/xQZJULy96p7u/kHwmy9I/lKHDPaEJNqefsi9ovgToZZrPuqLQTpFGsdZ9F+4qJgpVlh8P
 PNQ/WxQOHO7udxmXeK5VHADSQ85vkTxKjHHG/nhSeOAjahd9AA/1qXaFU9IsUsH4OqEJOWUxLCz
 CmhmBJIbZqODNj0EPV5EgXT4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta12.migadu.com with ESMTPS id 35c9ec350a8c0870;
	Mon, 17 Aug 2026 00:46:49 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 08:46:41 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	chrisl@kernel.org, nphamcs@gmail.com, kasong@tencent.com,
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC v3 05/15] mm, swap: add xswap cluster grow via VM_SPARSE
 vmalloc
Message-ID: <aoJZ8QKMhFgwgUFz@MiWiFi-R3L-srv>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
 <20260813104857.3450386-6-hebaoquan@kylinos.cn>
 <an-dmyT37Cq-aYUF@soda.int.kasm.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an-dmyT37Cq-aYUF@soda.int.kasm.eu>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD55840005
X-Stat-Signature: z84y4qzdbaxfk5hf7ax3pcnnbwphq1hs
X-HE-Tag: 1786927620-50030
X-HE-Meta: U2FsdGVkX180o7hiRkmYjXeSD4C4h2mVqJs8k1bgWceMQtT/E6og23/3gfpDnYB2ulpNODA54nl2nM0q6xS4AFV2HhlzIfrSu/QKvBdz1OoSVYiAmToHiqRBaXDSBdbRgFeZ3potk4otc1FRZZKs7tRSUXszyil/11ADuq4yeYL0hyfq+CaRGMUS9xyE722i96ZSLBm6vig9nQAV2JQhoNw8dO3fwubdkRDTYscLZAo4D/I70TqyS/XYybBHtSJQEGzJbkYv/uzE7yvA2Rv0drzrRl2e33UFRvQgMxReTfg4/BLd6arnh0yYZWCd0LRjqkjvcM8AlRN8QKosEwjqA3OqXgt8Wop1vLgy/jl5x5KpExv5KOfRKW5PSRJeRvBrKLZY8TcK0yG8uaLIWVZBBKqN4+X9Fx1BRPOeEPge5qmKeY3uWFYkv8Qzj9nWJh9GRJiBraTlx99/wkMtzJHfGa1cJcl44AnhQTbAHmD2cGPYobpmVCNGK4rgTPQQ6cl9mxkQ3cm53YyqtMEvUljRqBhYOEbk/hVC/NvLxn8V6IquX0FDqpfD7P1pNatIl97NBgKBnQ6zFVP9839LR86BwIcFkUy01DDs1A40W2Nne+jYtB8lnW8HIplj9OymEdQcjKPBLxG0aHxtGj6V+jdYkRnyRPCcg0X0juxFVogAxGWdJtjoJvepqKmkCkVUqZttb5DzjkiSo2kM0XWKI+TNvWNVqskxNvWIyfcrkq2ZF3DksDRNelkVdeo5BiXcnsXCBbalCXujSbVgEc3skHB//CM7bnJL1GnpCA3OdwqDAeUm8stNFlDhukX7ICh5yh/SO2k1wshigPHDBZeDwjxXLaBWDidalO35Ucn8XzmezZSZmP3CQOJgXpZEgR0qzh4sJROeO7+2ZA8qG2WOZEaxGmVpqx4Bl6gHQd/dC+c3nVYLPbfQ5CWD/AkT4YGuZ8Vd9WDHV3x45gviXAsp022
 TfJqBC9f
 7JDs1DgB/mthhY63XlF97au8fXi2t/bxVNmlL52QbDOEm/yP+Fy29olpG5ciqZ7h5RNXA5UY2J6JE/Qw4PT97Oy8l2+UwhRxJj6Oz+4XiRzD97OMdHfhse+IFCKd5JzxYwZH+wKY0wXZfzDRZwB+6fpJoV0eQyewOk8/fzEAPn7HP2qfVb528a69Zbjob1SgmvBhA7FUQqV6yLxmWOCqOVX3rMfN8KP3KPMzqBmFg8puZLJJJjpo7ymNJGWgwpvV1mp/WIduRgJuKe7uzTZDL5qcPSpSSOnFsr9AX1qMNPvfqjmqjGlk8Q9sJvjvqFQnr0yWQnMZbo0vasvcaBEcGL+YGWdWV3In7QvEcwkL0CdJfr/3QqFQRtMie/nrocVuZRrs5ffO3UpLpamo7xZWkNSrS2dfzc7VZp0hSODmdZcnrnBvOhAWeS9tgnsg5ocDApAKI9Am3LBH/LhJdF6hh8uLIr2fXzB36XE6FPggL6GXQp+Sv2EoH+MjJRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/15/26 at 01:09am, Klara Modin wrote:
> Hi,
> 
> On 2026-08-13 18:48:44 +0800, Baoquan He wrote:
> > Implement dynamic cluster_info array growth for xswap devices using a
> > VM_SPARSE vmalloc area:
> > 
......snip....
> > @@ -3562,6 +3757,64 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
> >  	int err = -ENOMEM;
> >  	unsigned long i;
> >  
> > +#ifdef CONFIG_XSWAP
> > +	if (si->flags & SWP_XSWAP) {
> > +		unsigned long size = PAGE_ALIGN(nr_clusters * sizeof(*cluster_info));
> > +		struct vm_struct *vm;
> > +
> > +		vm = get_vm_area(size, VM_SPARSE);
> > +		if (!vm)
> > +			goto err;
> > +
> > +		cluster_info = vm->addr;
> > +		si->cluster_vm = vm;
> > +		si->nr_clusters = nr_clusters;
> > +		si->cluster_info = cluster_info;
> 
> Should probably initialise the mutex here instead since
> xswap_map_clusters() uses it?

Many thanks for reviewing, and you are absolutely right. A real bug is
caught, I will wrap up the fix in the next version as you suggested.

Thanks
Baoquan
> 
> > +
> > +		/* Map the initial chunk (at least cluster 0) */
> > +		if (xswap_map_clusters(si, 0, min_t(unsigned long,
> > +					XSWAP_GROW_CLUSTERS, nr_clusters)))
> > +			goto err_free_vm;
> 
> > +
> > +		/* xswap: only cluster 0 slot 0 is bad */
> > +		err = swap_cluster_setup_bad_slot(si, cluster_info, 0, false);
> > +		if (err)
> > +			goto err_unmap;
> > +
> > +		INIT_LIST_HEAD(&si->free_clusters);
> > +		INIT_LIST_HEAD(&si->full_clusters);
> > +		INIT_LIST_HEAD(&si->discard_clusters);
> > +		for (i = 0; i < SWAP_NR_ORDERS; i++) {
> > +			INIT_LIST_HEAD(&si->nonfull_clusters[i]);
> > +			INIT_LIST_HEAD(&si->frag_clusters[i]);
> > +		}
> > +
> > +		/* Mark mapped clusters: cluster 0 has 1 bad slot, rest free */
> > +		for (i = 0; i < si->nr_clusters_mapped; i++) {
> > +			struct swap_cluster_info *ci = &cluster_info[i];
> > +
> > +			if (i == 0) {
> > +				ci->flags = CLUSTER_FLAG_NONFULL;
> > +				list_add_tail(&ci->list, &si->nonfull_clusters[0]);
> > +			} else {
> > +				ci->flags = CLUSTER_FLAG_FREE;
> > +				list_add_tail(&ci->list, &si->free_clusters);
> > +			}
> > +		}
> > +
> > +		mutex_init(&si->xswap_lock);
> > +		return 0;
> > +
> > +err_unmap:
> > +		xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
> > +err_free_vm:
> > +		free_vm_area(si->cluster_vm);
> > +		si->cluster_vm = NULL;
> > +		si->cluster_info = NULL;
> > +		return err;
> > +	}
> > +#endif /* CONFIG_XSWAP */
> > +
> >  	cluster_info = kvzalloc_objs(*cluster_info, nr_clusters);
> >  	if (!cluster_info)
> >  		goto err;
> > -- 
> > 2.54.0
> > 
> 
> Regards,
> Klara Modin

