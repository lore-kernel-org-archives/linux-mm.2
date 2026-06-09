Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB0DCD98C5
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 16:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED016B008C; Tue,  9 Jun 2026 12:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4136B0092; Tue,  9 Jun 2026 12:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DBC86B0093; Tue,  9 Jun 2026 12:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5F4196B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:17:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0824E1206D2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:17:49 +0000 (UTC)
X-FDA: 84860880258.25.7C950D3
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id A617F80011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 16:17:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q17QO1Oo;
	spf=pass (imf02.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781021866;
	b=7DedHJO7orj/VZWDzHOQ185oesH+keFDST9edl68I/QeGqgXzz0mzVk6EzlcBuovwiu2x2
	3Bq72h470bmwziC66RW07NvpmUEH5rDH6JmCXxkYNgG6ToQflIvBxTF0QfVxhSHx+BI9eK
	ThnpehW4+hOENB8TbrcVtJbr17PYAXM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q17QO1Oo;
	spf=pass (imf02.hostedemail.com: domain of kmanaouil.dev@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=kmanaouil.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781021866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcNntx/NGAvfH+oGg7l4M6S28fmu1J5RocdEzpCM4Lw=;
	b=YZKD6zjVrwYqQcktQrd1+xUygEev87AHJl/j5pELWJ8oxl1Lyuz0A2Ijx1b/5CE7VR8+1M
	FpTrZwoVDMvqwZytlHS/aan4Rb6gLy4tRC7ndCoegXoZzI2+oLDUOVCucDzlR1ScfzpxAL
	zHMcGacFN33dLPSKrpvWyfIYHgllUmQ=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490b613a17bso56686615e9.3
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 09:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781021865; x=1781626665; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VcNntx/NGAvfH+oGg7l4M6S28fmu1J5RocdEzpCM4Lw=;
        b=Q17QO1Oor3SGy2uJPKyvyqHT7Bf8ZDZ8/z12aswdhxKTifNJXydT+JRx37WVjRSrCC
         QXqFpEEyKjBxIzAgc5PPsgVsqeJNDsyaLJ6AHHWtb2pkJIVSlYGokZ6K8XYxnQY7Hk3N
         gaGX6sWLpxaKWeqFeh1B8NJ0AGTsfu00v3fGvGGeLl4Da7/Isi8iJ28eBb31D9YuN4Ls
         lQrzTlpsTKLxSx/SSHLn6+L0jETbjtPeofxFgR1q9Gwo2juEU7B9bkYWDrMSYH6SvfAO
         CXPVTollQyMald5vrlbaw8negjUI+f2V855Gr7X0Z+z5sfHhQub+gbR72aub3diBaDng
         Ld/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781021865; x=1781626665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VcNntx/NGAvfH+oGg7l4M6S28fmu1J5RocdEzpCM4Lw=;
        b=bm6IugMlaPdYJ1MaPppOgIe+ld4NB7wAdlGtYBLvNiMN2cFpdPQ5tOMalmLWQBS+r/
         KCcTfkwOBHZQYlIYa2o94mFqIMUNo+vgctwv/Fr39K8WzsyMh1Bvu02JMNtsfQj8uYZT
         pbJIMDz915nAVyjpquGdBrvG9BMMOnx8li60oCjBhFuzXXzBKMc26boaXCopfen9ORPl
         oqcfeHETTqwNMQW+fz4QF4CWhAAnuk1nIC8u5A260RVqW/Vu5hIhqLxQnGh/4FeVzcqd
         VWw24lHTtpbHkjJWi0WZchGrVH14Qxp+BuAmNkFNWJZZq8wNcJUUF6Ob6KjfozahYk1p
         xv1A==
X-Forwarded-Encrypted: i=1; AFNElJ/Vy8actPYTy7ZesxwVS3YaQHd8pWGNdII7rbVDQGEJT+VTgV05I2iSA7I7a43vRVgjzPL+/rSkXg==@kvack.org
X-Gm-Message-State: AOJu0Yze3apWYx97iGQtc80toXUL2d1SCaesne03uRLP0IfXSkLC+Cpu
	56qEZM42F2zBdOE/gVoGQvSxIsna9t4DxhZPntq6Xt3eOjiQNeDRCLdy
X-Gm-Gg: Acq92OH9X1nIuqpngnp68TvQzPpLjn+K1I5vOtL4L+SC/TgsGHypmFhANtccULudh8Y
	ajEYpQDUMOgfpwq2zwIjiMhB95biHI3IRKuHYzXpu14ruUKcZgHfjLpX3wTVkH7AmDtgekkx/Sp
	2+O6XblRYYa22IyrAuxY3Ggp1ZaTFM3fm+DblRk3Lr4suU7VALMfh2WpgVJ5iP5Ft6Pog4KvRcb
	y/8f9QCaRq02+Z01zY6PzGAtW6YOqKsAcxtK6amWa0JfK5Z9YP9rDgHtmpNjzVAFv1ElUap++rz
	1fLoAs6j87lsfi2KjREbicTsnwJjOzWbivxsx7ScZeu/nLlo5iAD/cqDgP46WeN6bGiG7/I6eg/
	MmEqG2A7Ovg5yfIwUl+5lGliBFC+wsRpkWSLO8B+afuBfu0Q+kQfzo6R6tk5P6R9j96ekwe97BN
	RaWZdfdcrc4jM+4IKwRgO//OuhAkwGWyMKRQq1l44tv00uV81ANoh85lxsalpmHDAFFsTa2+cqK
	RLJUE+My55vrm+NI7NT9osGMl0PvA3fPsc=
X-Received: by 2002:a05:600c:5292:b0:490:688b:f9f8 with SMTP id 5b1f17b1804b1-490d722e5ffmr47179415e9.27.1781021864447;
        Tue, 09 Jun 2026 09:17:44 -0700 (PDT)
Received: from localhost (pat-125-253.wlan.net.ed.ac.uk. [192.41.125.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3fd502sm492555605e9.11.2026.06.09.09.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 09:17:43 -0700 (PDT)
Date: Tue, 9 Jun 2026 17:17:42 +0100
From: Karim Manaouil <kmanaouil.dev@gmail.com>
To: "Garg, Shivank" <shivankg@amd.com>
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
Message-ID: <20260609161742.phipg7eid3yy4j7f@wrangler>
References: <20260428155043.39251-2-shivankg@amd.com>
 <20260428155043.39251-14-shivankg@amd.com>
 <20260609000009.dvh7gfbmiz76eliu@wrangler>
 <a5777c52-9af5-43c0-93a7-dbe4d41f9e86@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5777c52-9af5-43c0-93a7-dbe4d41f9e86@amd.com>
X-Rspamd-Queue-Id: A617F80011
X-Stat-Signature: fyqpq1xg7imwzwcs8nxmicphuzz33szp
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781021866-522759
X-HE-Meta: U2FsdGVkX1+DUpqcBH8fHfjaC/LyDmLMiYbH4e8p1d8VTG4sv43y9s+U9/bv5SnKdaGt+uR5Tvy33EJ3b8aicrFVNxLM2/8lyaXZBPoTaNY+ToXy3qxU4ckCQzLOiQEv7JIITcRCnKhAbkgsct1zB2PKXw1KVn33SVuZ9ekEDujFNrToB8sEypB2b95Vd/8PiFF+Jr5Z4zPr0W7Tp8w2efJFHS+87IN9HmJOyWkPp3tfle/WGeLYYsRT7TAlwPMgD7/SmEVssXZL+Q9zfy8LyVmO3l9fbdy6LtPsoahfUjAEOMKX4g9YUQtpcuZtFJJFFfhAiXk9moNLj21mjzQf5FTfIfi1cwfDWkPfcSX3dHzcq6VpSg4gOuO3JNi+Vc6zR8UW/HVfM1Gw8wS+/L4+1vAVaeUc3QML+CpEMrF4rxa+j9yvUMU2nq0LuqTLfy0aMrC7t9qKKLBm8jYByiDlYxLEADrKusxSfW5jJefDJ9zb2luX+gH0fWDY5++xZoaDrUoKo4H0UGaSlLyJ2lQm4hLZ1p2XAiI+v6usC/mdibS+a44+ZnVD0z77tiHukY393Bbe38w6qLTTepW5O3uqhz2TR9rJ2XNklW+96BWXVsuQPcnxvmcASiDczbHxYMRvbkFOFrWUaEaEkx9XYHsFwONZNv1DQjC1UEsF2KX/yZKcgmhROFCewDMs/4X8ukQp5ym3AXfCIqVOO6Yz86C+qcHCMBtCkW0NeX5aj8LvL9+8eNI+22ZHgWNUFTxBRgNZgJ5tJRHApjbF9T3iMSFtgF71UtRo2b0g2L7Sl/lxphIwsuFBAPMY2t/cBU3OlBHbARJ67flf1dv1fjBDp0gpYyvuXw8HSwgqs0bdkuWInZ92pc7gS2CD3ZIFShw3R32Ki/iv6Zn4sz4v6a0aJaSu51LkhWLUFAMm+7cuRQtInfbl8M94h2bhwzVNaMwxP0un8D2eKJ9TKibpbl0Vw3F
 Dk+9BAOO
 J42ZgeOrdph2hi1/yukJ7MiSU9rdB9qcMLFAIA77Ng1OS2v8tYU9OqTNDVdgybXIYqVjoySIN5eg0fr/I1zQIM5nHkQKVAON4TGd9OEfVu6trYcugOm5QhatNOucjJ5M5PPazntn0xU4owkNlXgNFj7o+ySj3m2zGkuUXftbqbLznyDrRVMt9dcdL2KsfmW6LODNTsE88OaTDKLA7afH01cdrf/K2ye3SbU0Za20Bpyv2JFIQj8wdA+s/SmfSKhwQyCkJAnlqA7N9pt13lEXO4eNvzpOCteIu2s7/i3/KiIxo/t7lhmDrXX6J4v7R1OUL1Ur+MAIRKbTvS/b+2BbLXH332OlW7EeWkUMHbYJq5ubmAJ1qh6EF7C1jXT8z6sts5Wx6q7hTNYYecVtiZl4tNV/N6RJ2ZaYkGMHYG1xXJzNxUEEv+FvJ0/OrQ5OyKrKS3/zpbHXcwcocAOlUAuUpfV5ki6pL93h09uHOnS+LHgOH8NYNiyTXw98E7LJFKw5AOjmklyTxbcDh7s6tSNHOiXLsYoc85SJFezh3sWwtIhLvRFH5+LWhGVeXEQBy6ij58b4Xks2t4q6GoTJiFCOYlZ3CDLt23hwp3Apd9IymckQod9XkQT86gQU83uBKiWJLPwRpebZBzfqIOymkbmO8JuLxexJoDGzZLkiWcnUem4Pp8AU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 01:01:21PM +0530, Garg, Shivank wrote:
> 
> 
> On 6/9/2026 5:30 AM, Karim Manaouil wrote:
> > [You don't often get email from kmanaouil.dev@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > In my opinion the driver should be at drivers/dma/dcbm, other DMA drivers
> > in the same directory like idxd and sdxi can just export a struct
> > dma_migrator. It makes it easy to have everything in the driver's own
> > directory. For example, idxd has some internals headers as well as an
> > already existing dmaengine implementation in drivers/dma/idxd.
> > 
> > PS. I am writing an implementation of this based on idxd. I'll try to
> > post it soon with numbers.
> > 
> > You can add
> > Reviewed-by: Karim Manaouil <kmanaouil.dev@gmail.com>
> > 
> 
> Hi Karim,
> 
> Thanks for the review.
> 
> I'm excited to see your idxd based implementation.
> 
> For plain memory to memory copy, which is all migration needs right now,
> the public dmaengine API is good enough, and idxd/sdxi/ptdma ... can
> all work through it. I'm curious which features you're planning to use
> from idxd internal headers that dmaengine can't provide?

Hi Shivank,

I'm still testing, but the initial implementation I wrote with
DMAEngine had too much overhead because of the sgtable allocations
and the conversion between kernel scatterlists to device descriptors.
So I entirely bypassed the DMAEngine API by directly passing the folios
lists to the driver.

I know it depends on the use case. If you just want to offload with no
latency requirements, then DMAEngine is fine, but if the goal is to
achieve high bandwidth with minimal latency, then it's a problem.

Another example, if you have to do several independent copies of 256 or
512 4KiB pages in a short period of time, there will to much stress on
sgtable allocations.

Another problem for low latency is DMA mapping.

Anyway, I need to collect more numbers. I will try to share my insights
with idxd asap.

> Also, my understanding is that driver/dma houses DMA providers,
> whereas DCBM would be consumer of DMAengine APIs. So is that right
> place for it?

I think you're right. It makes more sense when viewed from that
perspective. In fact, maybe at some point we will have some more generic
memory offload infrastructure to support sharing, load balancing across
several acceelrator instances, numa-awareness, handling batching for drivers
and asynchronous offload (to workqueues with completions).

-- 
~karim

