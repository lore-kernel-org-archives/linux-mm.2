Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C983CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 16:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C79D6B0088; Fri, 19 Jun 2026 12:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 879196B008A; Fri, 19 Jun 2026 12:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 767646B008C; Fri, 19 Jun 2026 12:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4702A6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:07:39 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C735BA044F
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:07:38 +0000 (UTC)
X-FDA: 84897142596.14.8AD1677
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6939140005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:07:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S4LKXqtb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781885257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LRmdbvpjUNJDrBbqYS0bUNkpf5u7O0cpSItf2HAoJHg=;
	b=IBvdHaqa7gqsarYkzOlNKuM5xFHc3pQKN1r9qbPBaeDa7oETaFq//YGfYG4G+Xyin+GBl9
	ZpW0F717crqwKa9JkuXOc7qTEiMOYcJbs/ki86QtQXXnO+5gHllyhn3dO8DoYv7g6OKpOD
	oYvUpWmwUcCf6idlG844ep8qLyf6kak=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=S4LKXqtb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781885257;
	b=SCBVN2i322SXgHPV5jDVpseJjj6ttF88d0upzcU5vWjRUPmEPAnZsR3SksYl2lwb+JjPNh
	OirSoihXq/8wNfTINboZmO1CrHnLMQO3ehl3n3mkmpM3LhBHURIO9I1oH28xn5EzSdgtNQ
	7bQX+NF/OGmTxdpDc67sYVEOtxfr1D8=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-463b2f6fc9dso2323408f8f.2
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 09:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781885255; x=1782490055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LRmdbvpjUNJDrBbqYS0bUNkpf5u7O0cpSItf2HAoJHg=;
        b=S4LKXqtbmhQPqZa542HbvaRyg3UNLZhTMMxTvqY15fJ8OyoSiKigvWzU9aSNRefDC1
         FHBbQUw8Z2jjUiinVPpMywjD/OS4vAuVI6DJE1zgeE7LMEYRY5xZouOyFwKM8Qrbfmci
         bNuPQ7bTi4mByuPcUD+ihB5Qjh4ID7otgKHEDxSgrrgk/Gfska4nBNLlWKwRw8s6nc57
         dZUCOTK76mf0UFTYp1yBY+vzbjGCh8kKSaBsmpJ4qDHuIRs2jepKqDjy3RPwhahVMg0L
         7kut3j73hLopFwMQCglt+OZ3rrqYHhTiX8mTXzSjlLjXeYSMJMg4W1djOUxdMrfchgFV
         xaaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781885255; x=1782490055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LRmdbvpjUNJDrBbqYS0bUNkpf5u7O0cpSItf2HAoJHg=;
        b=Wz2rZn0eIGz9j1maplzIIvIVKuMgit+ZfaGQcrg/sQZ4Rb/n0YCa3f30Y/1LuvcRtP
         CNhPtNO+SZSEj96Oi5100RkBa/TSZ3bIvPj0wq3yo/7g+vdVrsT6sj7RM0N+CQpgNlcX
         i6pQZFauwYnwQNxhIRYY0j3iXfFGfI1wYi7zAcYocQF6qKzRyMCGn9NJlvMZAh+EgNQt
         F570FiFz9iQ0rPW94pbVLFDLuF1k2N89MNbMB8DqnSDQn6ofyZfwAjMERd6+h2OIX5up
         IWig2dBSw890HTuCSPYm7iIy5l+zoMqZmz8fIvcFpsHgXe4Z/mDy1GfIERYfhkoQI43L
         S80Q==
X-Forwarded-Encrypted: i=1; AFNElJ+Va0sQLempCgYmuFgzU3CD7o532L0S78boiuxQN/131Py8jqSwFqj1fpCv1gycK2vF7OTmCA31gQ==@kvack.org
X-Gm-Message-State: AOJu0YzqhbyU4MjjUQZg/atzdji383040k8CLGNgpF0GYTXgASyMsDRE
	le8NxsmS+gYs0bTzse29hqTWDUP4hvLEXGnE+xXE9+ah0AGTRRJ612V4
X-Gm-Gg: AfdE7clw6ox8JLU8+K3kv35Ch7eaKb7N2Y0gNJmmDmavGm63U6dVqOma67r2slUun9e
	T9qcMfK4mcQXQVPkO3WfgHdIQeroVzh9hkITwK1upxBbU35zxA2u4GTxpT8BMw8tkTfWc5mWyfJ
	AqDrfERrsDwcAStCCEcoQf9Huc5b2cwbWHCxnNMirvMTjwxacwCE3NTrxfoqEpIHizaSfT41dUw
	m/il2gLJtHkQwSAO1ilk4af2IlURCmXshskHOAMsdMySOZROsfsJBHxOrJJrl1a67ah/0162vLK
	vCPuSPih3DcyabxOd7YlH8hoU7HRHvxF9NF8iRW0+22ZGaabpomvjFn17lqfRfSu6lcVI9wSJD0
	WYS2j1m557JKy1lVWd/0mNxORdAnddwK10NSPLHnyV1qef3Gs+1cwkkRRA98xoLNVe/H2er7A/R
	U2m0ukqfR0DshUjM5SdF0poBq+QTaDHfyxKOXeME4iq1eorXJpNBlv64Ktv5Oz/lANPy/+PSnqs
	/tQDcnP2u5Un4Y=
X-Received: by 2002:a5d:5f47:0:b0:461:e92e:b8db with SMTP id ffacd0b85a97d-465076ca6f6mr8609051f8f.19.1781885254949;
        Fri, 19 Jun 2026 09:07:34 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-466648c5ddbsm133352f8f.12.2026.06.19.09.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 09:07:34 -0700 (PDT)
Date: Fri, 19 Jun 2026 17:07:25 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: Shivank Garg <shivankg@amd.com>
Cc: akpm@linux-foundation.org, david@kernel.org, kinseyho@google.com,
	weixugc@google.com, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, willy@infradead.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, dave@stgolabs.net, Jonathan.Cameron@huawei.com,
	rkodsara@amd.com, vkoul@kernel.org, bharata@amd.com, sj@kernel.org,
	rientjes@google.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	dave.hansen@intel.com, hannes@cmpxchg.org, jhubbard@nvidia.com,
	peterx@redhat.com, riel@surriel.com, shakeel.butt@linux.dev,
	stalexan@redhat.com, tj@kernel.org, nifan.cxl@gmail.com,
	jic23@kernel.org, aneesh.kumar@kernel.org, nathan.lynch@amd.com,
	Frank.li@nxp.com, djbw@kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/7] drivers/migrate_offload: add DMA batch copy driver
 (dcbm)
Message-ID: <20260619160725.lfcxrbj5go67qy6u@wrangler>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-14-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428155043.39251-14-shivankg@amd.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6939140005
X-Stat-Signature: xer8jf5xwjo9cmdin3s1c4g649dhkens
X-Rspam-User: 
X-HE-Tag: 1781885256-576040
X-HE-Meta: U2FsdGVkX1/QLWh/+mwhuvzKISRmMjGK5lgh+kUZTVSd130Os6g2b9sdiTZCucPe1AMqncaq9Euh+H9aB1iUtlrDKTZBBVqhBiJQU2HKlavdKfsC4eaEaJefKGlwRu/b9zG4A11RQ+x5UmEnfAfNAeYYnfxjelgEcb5ZDezqJPa++NTtUIWNzOMle9B3/i0ZD0msWrOcAqtpZI92GlcVkJZqYd8UL7jQeexzbt8V+GL2w33yJhIZ4qLAnQKNU6PQDAysyxNvJe8er8SNWUpjw6b2aUeDHUF04pM55wHj6qL99iYUu2O9Bx3HJTvpIJNMWQ9blGZZC/a9WY/zLLgHSOlRjKODLoupEg6G9BR6fATl6W0MWpRfMnjhTUoz38N9BmFDkbM49IIFhtzGtbgNfQOFVg0twt/q2lYgC+xDwOs4lPZb03+7LgbS2trKlW4i2SRiwikfb8iP0dyJQQxymjY7JMYhHXBAs0wm3wvCxgIfa49dJ6S6sVu63q67LPpK58X3Cv1w8v5fEqzxeDEE0FTbLTjEFdLMY2bR7X+j8ciJHISbaWH2qO4EZNCpgc6CFADmLpcMv8FXoYNc3/tJryV2CzFbuFpAMGhG/pDL/nEoLY1ZJYVxi41oItbrYZeWaf1CDL9TQGVi5WY8l8f204Lrc7sWMTnhrWEwwW9oIJlGhJNcNDfqXH3JH0iIQjQO6w6Nr4Ck9npZiaC8j+3SuQZuxkSf05qUXUjxqqmgF0lSuocStxub4whbPqdzFmU5fsRNWAB7jDvnPD1y1/tzxk/wB5P9IR4lLbf6aPFNwsmMk57O95zeek0ys/KXv2svId4jZ5MCn7EbIOmtItno9pVph7VQX1AACp8jsKgsFlel8UnCxtREpGg/6M2gx6u4xf4IcPne7ZMZ+cRJQ+00kFzGL3JIrI9EQxi230vjQO0v5ypldFaJs6jm+Pi///4TdMWA/Tv04Bd4ZPW/zZI
 hMToeb3A
 ZeHPVtLAQR3qWsM30ovPRVUEi98UoWHct7D8/2dO69LrvYdCsn7S9Kipmgz9bV06ZeN+qZkaVm9q2MoDeU8AhflSdGWuzraoVeqQIfdLuiWsmNG1IHzXGf3rg5Tm9HmeD5M6b3n3YhGaVe+t9k9gty88jglh1HLBXuUg24rhWPFqSx5qMoRiCC2Y+7Vpcl9um16TEfbX3hy5rDR0bkRto33/J8gn/P3Jb/j9QT6UjcEET5CRAOT/FP0MwCr0luDf05KVHreBDQCHUkgzxhrJ0ErKWLGaH2vtgwXDbk35/mvt1IDPPy82WXFjb1NKB5oekI8BHFajMdVrv7KFyJ3yWOa/al1Ws1Tg709WjaLO7jBXGGuPSHbJJ2z2LqPr/QJHSVSY9xMHHUmvRqp6riTT8xUWFyzTbP8yVPMyyk3r810fXrCzOVEOIbjATKgJlghQnOU0NwKuRAt2LeZQN10fb9bjO0ATL/mwr29TpRoZnyRvgMTKHyPDdgOQhPgLnGy2D3ysufDOF7NMfDYu+N6QowtNUVPx4Kpl7+ptLU6PN7bSGge1rvHIDzf1jAU8mwHmj6/kHbDaOcWFe/Yc6qMU9GE/tsBuyqnSqZ5Bx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi again Shivank,

I just got some time to resume testing this on Intel Sapphire Rapids and
something caught my attention, below

On Tue, Apr 28, 2026 at 03:50:49PM +0000, Shivank Garg wrote:
> +static int submit_dma_transfers(struct dma_work *work)
> +{
> +	struct scatterlist *sg_src, *sg_dst;
> +	struct dma_async_tx_descriptor *tx;
> +	unsigned long flags = DMA_CTRL_ACK;
> +	dma_cookie_t cookie;
> +	int i;
> +
> +	atomic_set(&work->pending, 1);
> +
> +	sg_src = work->src_sgt->sgl;
> +	sg_dst = work->dst_sgt->sgl;
> +	for_each_sgtable_dma_sg(work->src_sgt, sg_src, i) {
> +		if (i == work->src_sgt->nents - 1)
> +			flags |= DMA_PREP_INTERRUPT;
> +
> +		tx = dmaengine_prep_dma_memcpy(work->chan,
> +				sg_dma_address(sg_dst),
> +				sg_dma_address(sg_src),
> +				sg_dma_len(sg_src), flags);
> +		if (!tx) {
> +			atomic_set(&work->pending, 0);
> +			return -EIO;
> +		}
> +
> +		if (i == work->src_sgt->nents - 1) {
> +			tx->callback = dma_completion_callback;
> +			tx->callback_param = work;
> +		}
> +

Here, you are submitting the descriptors one after the other and only
the last descriptor has a callback, which in theory sounds correct as
you expect the DMA engine to complete the descriptors in the same order
they were submitted. However, in reality that's not really gauranteed.

Intel DSA in particular can complete descriptors out of order. That
means, the last descriptor submitted may not necessarily be the last
descriptors that completes. In that case, you will return in
folios_copy_dma() before the copy truly completes for all the folios.

For correctness, we have to add a callback to every descriptor and
initialize work->pending to the number of descriptors submitted then
every time a descriptor completes, you call atomic_dec(&work->pending)
and only complete the completion the moment it reaches zero.

Btw, waiting for an interrupt adds massive scheduling overhead. If we
also add the logic above, it'll get even worse. In my measurements, this
can easily add up to 6ms, by which CPU page copy have easily completed
the entire copy, which again adds to the list of latency concerns I
raised in my other reply.

> +		cookie = dmaengine_submit(tx);
> +		if (dma_submit_error(cookie)) {
> +			atomic_set(&work->pending, 0);
> +			return -EIO;
> +		}
> +		sg_dst = sg_next(sg_dst);
> +	}
> +	return 0;
> +}
> +
> +/**
> + * folios_copy_dma - copy a batch of folios via DMA memcpy
> + * @dst_list: destination folio list
> + * @src_list: source folio list
> + * @nr_folios: number of folios in each list
> + *
> + * Return: 0 on success, negative errno on failure.
> + */
> +static int folios_copy_dma(struct list_head *dst_list,
> +		struct list_head *src_list, unsigned int nr_folios)
> +{
> +	struct dma_work *works;
> +	struct list_head *src_pos = src_list->next;
> +	struct list_head *dst_pos = dst_list->next;
> +	int i, folios_per_chan, ret;
> +	dma_cap_mask_t mask;
> +	int actual_channels = 0;
> +	unsigned int max_channels;
> +
> +	max_channels = min3(nr_dma_channels, nr_folios,
> +			(unsigned int)MAX_DMA_CHANNELS);
> +
> +	works = kcalloc(max_channels, sizeof(*works), GFP_KERNEL);
> +	if (!works)
> +		return -ENOMEM;
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_MEMCPY, mask);
> +
> +	for (i = 0; i < max_channels; i++) {
> +		works[actual_channels].chan = dma_request_chan_by_mask(&mask);
> +		if (IS_ERR(works[actual_channels].chan))
> +			break;
> +		init_completion(&works[actual_channels].done);
> +		actual_channels++;
> +	}
> +
> +	if (actual_channels == 0) {
> +		kfree(works);
> +		return -ENODEV;
> +	}
> +
> +	for (i = 0; i < actual_channels; i++) {
> +		folios_per_chan = nr_folios * (i + 1) / actual_channels -
> +				(nr_folios * i) / actual_channels;
> +		if (folios_per_chan == 0)
> +			continue;
> +
> +		ret = setup_sg_tables(&works[i], &src_pos, &dst_pos,
> +				folios_per_chan);
> +		if (ret)
> +			goto err_cleanup;
> +	}
> +
> +	for (i = 0; i < actual_channels; i++) {
> +		ret = submit_dma_transfers(&works[i]);
> +		if (ret)
> +			goto err_cleanup;
> +	}
> +
> +	for (i = 0; i < actual_channels; i++) {
> +		if (atomic_read(&works[i].pending) > 0)
> +			dma_async_issue_pending(works[i].chan);
> +	}
> +
> +	for (i = 0; i < actual_channels; i++) {
> +		if (atomic_read(&works[i].pending) == 0)
> +			continue;
> +		if (!wait_for_completion_timeout(&works[i].done,
> +				msecs_to_jiffies(10000))) {
> +			ret = -ETIMEDOUT;
> +			goto err_cleanup;
> +		}
> +	}
> +
> +	cleanup_dma_work(works, actual_channels);
> +
> +	atomic_long_add(nr_folios, &folios_migrated);
> +	return 0;
> +
> +err_cleanup:
> +	pr_warn_ratelimited("dcbm: DMA copy failed (%d), falling back to CPU\n",
> +			ret);
> +	cleanup_dma_work(works, actual_channels);
> +
> +	atomic_long_add(nr_folios, &folios_failures);
> +	return ret;
> +}

-- 
~karim

