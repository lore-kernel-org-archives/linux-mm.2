Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83D73C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 15:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 714DB6B00A9; Wed,  1 Jul 2026 11:54:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E9B6B00AB; Wed,  1 Jul 2026 11:54:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 547646B00AC; Wed,  1 Jul 2026 11:54:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1666F6B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 11:54:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 702FD1203FC
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:54:26 +0000 (UTC)
X-FDA: 84940654932.23.3556E1E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1AB7410000B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:54:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A7iWcg2s;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782921264;
	b=lcKKne+sITLeH53YltOCgjilc6B2om8+5G74oqnk0de/SIeAgoGMEWf9FLl86GKLq61q+K
	wNHuO3pUwV1FVocKJF7gKuEGqaBy+NmJraqzCTnNNxdGzyYcc9RDLXasKxh+w60nIc9Ehg
	bZzzEyjAPqxUvVYVwdRxC13U+7zuV2w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782921264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQqt/bByGpZMVaTV47GrHV/MzFjAQYvcctbsvrjGHwc=;
	b=bVKwhbRigqfxtdq2Yf75AnPcdEylB4ECOACE3vg5FgswI4whHU1gOkQh8+dgimtRd1825Z
	c8gKmr8si1mLmBXU5C5SLboSpTBqd/0I7uCua0x4ZCBd5AAEiYVaPf3WrE7W83s95IxDyd
	TawnPDBdMSbkYTdg34YHrovwLwtrX/c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A7iWcg2s;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf05.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782921263;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZQqt/bByGpZMVaTV47GrHV/MzFjAQYvcctbsvrjGHwc=;
	b=A7iWcg2s15SWrCLcvcL5iL1gvKcnPUTcPu81VdD+E641LEKd059mPI9Sd3CKaEN/VOI1Md
	Bq1/22pBQMlFb+LjwWshCSa6zvs6osx2wvl+a8KfS1/fkjdRbbF4BFIsIo18L56PB0/TMT
	1XWyau9FvnN2vOPeYXGebjiEtcdfMvs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-7xEIaMrzPwaVMVX3KZmTow-1; Wed, 01 Jul 2026 11:54:22 -0400
X-MC-Unique: 7xEIaMrzPwaVMVX3KZmTow-1
X-Mimecast-MFC-AGG-ID: 7xEIaMrzPwaVMVX3KZmTow_1782921261
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493b786d550so9386265e9.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 08:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782921261; x=1783526061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQqt/bByGpZMVaTV47GrHV/MzFjAQYvcctbsvrjGHwc=;
        b=YsZuxgGKKA2O/PJS7bE+hwPSNzJAuIRrsbE13VEgz4HAOdgysgWNeReMGcWs6UAQ8n
         KgDkNkc8SGAXRrjIj5j9PrmZ4lHRPeUB61LHQWuinuzh9Fnz7eNo8E8cvxomAE47JEm/
         ZjXWZJdlkTO0Gxwa7Im/gfb4B2djmXZJuCCbpLE2YQJ0DaGKFwCnF7VqP/woxhTIY0d/
         BEdLyFRdxFIfkpM645uKjccDrKzwWEwOtmyeJ0m+EKsIr/TRz+SIIzADbgpiB1OQwKZC
         ZeM23XmOEOpS1Jm1Pc/20EjL54KrJGialngoFSW5L+6ZvTVBcG9+sx5qdMrhdkRSVLuv
         Q/ig==
X-Forwarded-Encrypted: i=1; AFNElJ/WI5x3E1p0BOeLQcnjf7W1u1Y/iFiLA17iQRtQIAZzbRnICR7w/KlOTxi7oIHrTZ3mJA2BXTxSvg==@kvack.org
X-Gm-Message-State: AOJu0YyrgB83mwmK2FcCboSK0MzMfklSFfeDEOQMyG9xqOq03ieIODQa
	qh1RQ7mTXvYF1ewp75oLzICj9cOEaFTRiJwXZfrpX9BNCAK04W58qbJUS64rRynDA0OljSqVh0I
	kze4kFIy0RiwXlb164h0YlaaLjrg88UfA8tFaGoAkNRnciYUgtlQw
X-Gm-Gg: AfdE7cloG9279SQ2cmPA/ZdhuEHP/n5FYZzOGMnM5t4aVWu8WisPuP2qRnuq+YaE7sp
	U6d5y9xjRTB4HsXgWSufwT7POFyPQsLL4I5KsxsdLc4I0bhJjOcE6a9VbNKPY186sS/5e6AHllR
	DtQP83rcVP1dnfYK34+W63SbcMTDsiq71dvq7XwupABcVchmdfoQx3EbVfmxipQw8FfinZZ6ckc
	oXzv+A8AsQjhOEfJ9Tm61hqDuodHJg/PpnGwUDixSLHIP5sqhvR59V03lSvoYGAXzOb28M8UFKM
	eJlpwgYZZJyLDgPAgihIo14PJbgT96G+mL/tn9FyQNlI3RDHpo/tcfaAM1v4wYYK9PDUNC9Yl7q
	yNrvlm10IVkfwW4zIHHE02yV25RJCzd5C
X-Received: by 2002:a05:600c:3588:b0:492:59fe:4a15 with SMTP id 5b1f17b1804b1-493c2b84695mr28232005e9.24.1782921260994;
        Wed, 01 Jul 2026 08:54:20 -0700 (PDT)
X-Received: by 2002:a05:600c:3588:b0:492:59fe:4a15 with SMTP id 5b1f17b1804b1-493c2b84695mr28231295e9.24.1782921260379;
        Wed, 01 Jul 2026 08:54:20 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4c89ccsm95218855e9.4.2026.07.01.08.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 08:54:19 -0700 (PDT)
Date: Wed, 1 Jul 2026 11:54:15 -0400
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
Message-ID: <20260701112946-mutt-send-email-mst@kernel.org>
References: <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
 <20260701043024-mutt-send-email-mst@kernel.org>
 <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
MIME-Version: 1.0
In-Reply-To: <c03ec696-d635-4c7f-8c77-89a439d9135b@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Vbr9xoeNokM87iMilBfziAL7BR7u_HMcB0-N1ijdwxs_1782921261
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1AB7410000B
X-Rspam-User: 
X-Stat-Signature: redtihiniayphjzontkfxpdow9k3kreb
X-HE-Tag: 1782921263-354752
X-HE-Meta: U2FsdGVkX18mJNMF4TXmnU4MxXsf5UfO2ckElFICVzjv6zdo+/GP6xuaWfuL6/NKVOYQgtBiXaqbKgYVVpCuCNWf8XErGlwtZq00VLMCFhwJ1tJkJzZvLPvUNls+j/6Lf1lKgAVJi9YpDwpiy1T255W1ea3AQ2yegirZvO/WAxe6APhERQ1I9o+HoDPzbs0FdltnXYNnuPlX1o52alXh6dDYhoxVA2AbkhlkcWOroFJiZqdzISXgMzftSp7lp1Wf/8KhbNsIOwjOhsI8wa1l2X4bJ/f3dHYI2B5mrLF+bpMhsZ3pPcJh6gIzu3Zhlf37prqbCcuLnizqIvOYW09rG8KFyDBQo9saTc71eXsY8qsTE1dgdCZovDe9BVH/rDvrIS9DD5A336T6gkYdnJE5WYrSMI66rOqE9BwVWWWsj6CvaFFFNcat5qfwwxIO5Jr2O9xe9ziJY5KogaUAeExDH0S89bdq6WVLPsJ8iHwik7fZOdmlhKsUeQL7H7UmFNWVgNNctc0o93TMMt8N+Jr5Ea3B8VIRgn+zT9wD8LpDwgGsIAe3o1MEN2sfma9oia48fO0FP+v2wMXT2JT6NwhBtDBsdjQkDE2lZJ8dp/8d0YIKQQDerI34IZ+MJbvjAjFcMeLhAqaiWw1/+Xcky/hgIu6bd8R++OY4B2aM/P4X0eUEnp/gAR7OfFf1rqYjub45lo3/GVTv4KbD6cnoU0Cb35XSTYe1amYvzKNblY0u43nwT9sEUjTaCv49W1wNPbeivnWZiP5F3y4ezF6y2MJRWR6J00d4wK9ALbwi7PKnMTkaXyQNm9PhVJrCS0r6duEhxivPSUb41sLCDUgyGuAbPIRE6PnlSJPUw12puNefQwEUOXTB67F9GKGkkVx8KI4hXKTMziEDb9U7d1LBWxRmGhFrmNfwnQlj37zOpeGMr8IkHX5BFqo3m9Poin5eCuYigyqKDrPolYYZErcl35I
 yDbgdqmg
 zdWwSn8YOOYlJwbIuf5YLyL7+qVlJuwQ/IR9QCLwXQ7G6UvTaLB9f32uGSYK8cc+rNvZg7xwASXuFycBCygKwoqba4sgIwJ5A0punGLfhMUaRMmw5qwkfW985m7zCSO7Hwtp/AZNXSKTRpXaDS8zpk4OBUmjvgvPyQ/B4mqEoy8OccbhTwNeWwMYGS2lR3k2hFzHutWgFeGRsD/gZ7kQF/oZ1BX6uyDcySjCEuCY0UflzBQapClWxsFIQODvInJ3BPhF+NXL5vsT0nXlUHllX7e0Nkr3svNvXWBYBoPzVAimtP7RKotZNkAPOI8LMl6REkKcCzuO7wTFjGCiXBuyXOzuPlEXvHXz5tcouRuKtqJQ9oKi2g6r/IyNX2an6k714AWYOOTQTY5drPVfJ453zoxJu7j0m78EtJ3nt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 10:36:31AM +0200, David Hildenbrand (Arm) wrote:
> On 7/1/26 10:33, Michael S. Tsirkin wrote:
> > On Wed, Jul 01, 2026 at 10:26:26AM +0200, David Hildenbrand (Arm) wrote:
> >> On 7/1/26 10:18, Michael S. Tsirkin wrote:
> >>>
> >>> So on this idea. It might not matter. What I had in mind is:
> >>> 1. run the current logic
> >>> 2. add page to a list of pages to check, then invoke e.g. call_rcu_tasks
> >>>    (or call_rcu_tasks_rude) maybe
> >>> 3. in the callback, recheck and if poison cleared, go back to 1
> >>> 4. otherwise everyone will see the bit set, remove from list we are done
> >>>
> >>> it seems to not regress anything, and for the rare race, we set
> >>> the bit eventually.
> >>>
> >>
> >> So test-and-set (and friends) would also have to check the data structure that
> >> remembers bit to set/clear (and possibly update the data structure).
> >>
> >> That does seem doable. Do you have a prototype?
> > 
> > what do you think ;) post it?
> 
> As RFC please :) [and if it's AI generated, obviously properly reviewed and
> reworked by you]
> -- 
> Cheers,
> 
> David

Not "generated" surely. But assisted, yes. Still hacking on it, but the difficulty
with memory-failure is that fundamentally, it's not 100% robust.

For example, we have a fifo fed by hardware and consumed by a workqueue:

        struct memory_failure_cpu *mf_cpu;
        unsigned long proc_flags;
        bool buffer_overflow;
        struct memory_failure_entry entry = {
                .pfn =          pfn,
                .flags =        flags,
        };

        mf_cpu = &get_cpu_var(memory_failure_cpu);
        raw_spin_lock_irqsave(&mf_cpu->lock, proc_flags);
        buffer_overflow = !kfifo_put(&mf_cpu->fifo, entry);
        if (!buffer_overflow)
                schedule_work_on(smp_processor_id(), &mf_cpu->work);
        raw_spin_unlock_irqrestore(&mf_cpu->lock, proc_flags);
        put_cpu_var(memory_failure_cpu);
        if (buffer_overflow)
                pr_err("buffer overflow when queuing memory failure at %#lx\n",
                       pfn);


if there are lots of these and the scheduler is slow and it overflows,
it's sayonara you have lost the flag, right?


Oh and by the way, I just noticed that when buddy merges pages it does
not check the poison bit. So it looks like there's a simple way to lose
the poison bit - have it merge with a non poisoned page.

I guess maybe we should fix this last one.

-- 
MST


