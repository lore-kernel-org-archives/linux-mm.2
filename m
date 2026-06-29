Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2349CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CFF76B00DC; Mon, 29 Jun 2026 17:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A77C6B00DF; Mon, 29 Jun 2026 17:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8C66B00E3; Mon, 29 Jun 2026 17:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C91A46B00DC
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:50:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C4F81C1EDD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:50:48 +0000 (UTC)
X-FDA: 84934295376.22.0E6E0E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id DB86E20011
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:50:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PcQNpJ8w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782769846;
	b=hxcc6EmtHuPbQqL5piH4ACPP02/t+BgR5V3Vfze7dixwffBxNSSJaeFP5jW3vGkiVHy42r
	rro6ZRkrhO/PPe1gXB6uQ2XwPP5aUibfFrLS1ZV8BQP0TzP1D1K/K2zpTviK/Lq49iRf6Q
	p4r1i+sKTlj9PVK5HfFaqPhEaHUoEgw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782769846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j1BSh5W1gPjYMhKd19XJgXfbVBqQZUI73y0mmOWCqSI=;
	b=tp7X8DZEAywDsvsGDXYuRX0zHQqKqDCFVa5u3sZyxpXUacDgHiY/EK2+yc4IV0XY2eCS28
	D7TCBFj6PP4n15Jk40ZGLamxzhmVq8gRBcqOs+KZ39J9DKc1D8OWcCwNjV52OatT2OPK0f
	rvDwrmEkR6ihLpEga2lTXHch3ELHB8A=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PcQNpJ8w;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782769845;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j1BSh5W1gPjYMhKd19XJgXfbVBqQZUI73y0mmOWCqSI=;
	b=PcQNpJ8wWjuyzmkNXutE+SGi3ydkkp3er7SSzoUYujqUTgsvCSDqWHfLWcWi7mbC/u0G7z
	XvqEUC9iDtlbzjZ+fabLr4GWGRe/Eov19B/B76+j2v5x2csL+HITZ+JFx6Lp2EIC0g7rBc
	VnI3EOSkPabRBlUJTI9v2a75hBzALdc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-U35CFHCFMeKE9TQMtnlm5A-1; Mon, 29 Jun 2026 17:50:43 -0400
X-MC-Unique: U35CFHCFMeKE9TQMtnlm5A-1
X-Mimecast-MFC-AGG-ID: U35CFHCFMeKE9TQMtnlm5A_1782769842
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47416fc1674so876747f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:50:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782769842; x=1783374642;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j1BSh5W1gPjYMhKd19XJgXfbVBqQZUI73y0mmOWCqSI=;
        b=SYclUsqIhiKzyDY7ny3fmxRjLuT/aisgjGMNIzJh2FtdB2X/O4RNF32jrTsERLDIYK
         xWcARTuntFpUas1rW+CU7Tb1ruG35wMBmBs2qJoFI6QHsxr+0P9cJiyI2t6Om2FbDaUf
         YeIDCLEhuDAewXzRqBk9QbdP64s9sg5txcE/F7fRoDPghRgJb4JbU9W+sMmYxLbuKvyT
         UDIYyDoxS0pkaIC8VHHp01sOaQwMCpusjzjDxVucVWDk3UfQ6riBNebf17qNFtRsfg9F
         +qsJCmkMjARmNv7VUlJ7/0YhFVO7ri+b0ot3WmT8tHIQjOUr4TTYwW1Kq0JzV5cfD4SP
         ePYg==
X-Forwarded-Encrypted: i=1; AHgh+Rp5qqeZSQz2Wb1OqKSDnlrF6BrywLmGazkVT6TxeTmXOot1DPZh8LPGyJmottZU0Fk4cw2UP3NEHA==@kvack.org
X-Gm-Message-State: AOJu0YydAbkcRni2A/8ZbWsmQo6R8P/QhT7JHieYkx72Hy9J00QnATy5
	DX36rpFNhHA5gTh8qQE0jy/xsJsY73gS+01vuSBWnf33psFyqyk7+ndfaBwCMhAmH4PGqNoZVJl
	jvYmegslNcwCzmrEiQwq0Ak+8qs1YI1mI8ZriztrWvZGaVWrGbAbC
X-Gm-Gg: AfdE7cl4tVUYjUmXwq2BtxfiRlSRs6x/h28V/e7pw9CLn4QJmOluEGlzIX6Tp9UD8+O
	Izb9NyDd4i8x/R3s+9ipVNUtLjL6cziveV7p1qevrN00JFUx/61Y/hVngDQ/hHSPqmA6a/lttOy
	GPSnauDzhHhhakOapx8cVvODPEKssyqe62HKvUeI8wB0Hq/MNA7BI2X+6VIGKM9/K0xD80RnfVo
	fhZmUpFdGGVkZws5Jcf9KRaDiFFRm5/0G5ZFlJyeb0k5yIVXad1wAzFawcWCH8kSsIjeOaDzsy4
	imucBpQfbqQ9ajiVHGCCCBgpM57ijRyNmOghq3v532cRDsGJYL0+RwCx0GHuIFmJrmVFyjCly81
	wZssRC0ocqhyx46+NbYwkeGD/ukBMxZjv
X-Received: by 2002:a5d:5d8a:0:b0:474:9991:60d0 with SMTP id ffacd0b85a97d-47550cabbbdmr1238858f8f.12.1782769841915;
        Mon, 29 Jun 2026 14:50:41 -0700 (PDT)
X-Received: by 2002:a5d:5d8a:0:b0:474:9991:60d0 with SMTP id ffacd0b85a97d-47550cabbbdmr1238829f8f.12.1782769841353;
        Mon, 29 Jun 2026 14:50:41 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-475674af239sm1206001f8f.30.2026.06.29.14.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 14:50:40 -0700 (PDT)
Date: Mon, 29 Jun 2026 17:50:35 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andi Kleen <andi@firstfloor.org>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629174225-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
MIME-Version: 1.0
In-Reply-To: <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: wCigkWjQXSeaIdfK5v-bftxhScGE5GPSt-RqIemDaTQ_1782769842
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB86E20011
X-Rspam-User: 
X-Stat-Signature: e6mcfbx7bcx81fg87iupnaw3ntcy6di4
X-HE-Tag: 1782769845-114936
X-HE-Meta: U2FsdGVkX18PFHob+nLgSFSfD7KXgCq5dK182fuvjCYcQAe5gCw5TiJ6v85mE6C6oHt71kOztP/wI24JDUajt5mlnZ91ZvSNwSuOsPOvE66bUBOJI9FNg4J46lWvz6oLzYiuPWXcPUmAhJ3KJDqWRATtTxyrBDNvC6bDBXzHMTAsxzd7Bb5zKs5lQiRavd5KW11bfYbD6V5/yPz+887tR9Nibo0R7nYN90VG6+uortJHcZTq3JTvV3s5bJ005UssCsgX8Wve+kQ5obFz9yMY/iQUVBkhJNauOuZqjW7OgmMsFdRtXl3uCZ6bTPJ1hEFJejtsk5s3m3vv944OOWJcgWImG+JQbMG4O1K+CBDTPDoIIqcBzDnUB8vKth0d6Hy2NOEQqmtP9du8Gp8olifoK3i8bcToJO0oUm956+fYNi4sSK1ufOgAJ85OheeDG67nkLMPRrV7et1QS76ngbtlWMXj5XsWUkxlDHCrK6Tk+yK2/EAucNZcHfWnVPPqsg7DHOkA9gL3kjpLVNQv66zPm+UV29ofmzOzWGKZaM43sRa7jSvoxQHWH076iLxr0Jwt+yX1p+3IqKknDxvOP6fAoiBDZF+YOaFNDtM/HiMoavmdsa2t+kyDvvT81GUyNoD/pA0DCn8INCtxnAWglWoQ+LXaYYyAt4LkW6Sw16TwsdFf+DwovrTTHByRPmUxbzRz+cP/OazMO3yRVWaGIuUyCfX3YFAqKmS56pt01dn9SiwKCbbkjD0RYmEdUA1UoMixoI6A/NgC4G0inOt7JH7J86T2NteT2ONY4dHCk8rU7T5cXtqiwvZgyBa6ab8XB23lqDfaKwyG7w1aWVGcas/iz968UEWbS1X6atsEUClxtvTNtOCxDrpbSLXDj9GbgpB8YA6h5ALSwfquk5RCfQdydWt+oEuK4PvcRcVAK0IaXONTpeuijB/cjoqh57kzBU1m6VvCSS/8WegwhO4y23O
 6/zxxrel
 9Y2NXxIzqLAyWi0UbSXwIeXQ5XNTbTloQ+4jipvyqdaxgG4gdDekLmkniOZ3BqM8uwSWaBzzjudZhT6TFU7dBfxoIWDjIa2qcPWEe6USXROschLC3uIMnjFzR6esRSrM8qa8lCDNGwSSEOwVnrwdSo/GB738iOX1f1zXtC1I2PmAqTRz8VpSYBYXQsuwd3VsI742/fjgIUNBI21AlhZe5Yn8RK46nShcbZa7fDFG8aL9x5wWHWPpqvCHB4gS1rV6SgZw1xXh83H70ksy/rrBc4FvS8Cx8l9qrljZJ8JA/5lzbTMTb4nQz43c1/nONy8lymqfnfWBaJFnZdOAAsJnKmzfbEw4vqj2SBMIuBj7vejqVuEM7G1Riy/5QmsE+NeTGd1xj0zViIFSYu3Uke9x2jR8DusS+7LQoW6Qy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 11:22:11PM +0200, David Hildenbrand (Arm) wrote:
> [...]
> 
> > 
> > And again, I'm really not sure fixing a theoretical race when memory
> > is failing is worth slowing the world by 0.1-1% for.
> > 
> 
> Fully agreed. I was hoping RCU was cheaper (I mean, we were once told that RCU
> read side locking is essentially for free ... well in some configs :) )
> 
> The question if we could optimize it reasonably enough ...
> 
> > 
> > From what I saw in my testing, if we allocate 4k pages
> > it's hidden by the overhead. With hp and thp it's measureably
> > worse than rcu on !preempt config.
> 
> ... for example, by doing the rcu read lock + unlock around the
> 
> 	for (i = 1; i < (1 << order); i++) {
> 
> loop on the alloc path.

Is this different from what this patch is doing?

        if (unlikely(order)) {
                int i;

                hwpoison_rcu_lock();
                if (compound) {
                        page[1].flags.f &= ~PAGE_FLAGS_SECOND;
  #ifdef NR_PAGES_IN_LARGE_FOLIO
                        folio->_nr_pages = 0;
  #endif
                }
                for (i = 1; i < (1 << order); i++) {
                        if (compound)
                                bad += free_tail_page_prepare(page, page + i);
                        if (is_check_pages_enabled()) {
                                if (free_page_is_bad(page + i)) {
                                        bad++;
                                        continue;
                                }
                        }
                        (page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
                }
                hwpoison_rcu_unlock();
        }
  


> But I suspect it's not going to make that much of a
> difference.

It makes a difference! Just not enough to make it completely unmeasureable.


> I concluded, similar to Andi, that stop_machine() is too big of a hammer.
> 
> I wonder if something could be built out of preempt_disable() and sync SMP
> calls. hmm :(

rcu_lock is basically same as preempt_disable if rcu is non preemptible,
no?


> -- 
> Cheers,
> 
> David


