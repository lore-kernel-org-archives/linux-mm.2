Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAD75C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:25:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5796B00A9; Tue, 30 Jun 2026 03:25:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACCE6B00AA; Tue, 30 Jun 2026 03:25:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8765F6B00AB; Tue, 30 Jun 2026 03:25:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB136B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:25:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D988F1C326B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:25:15 +0000 (UTC)
X-FDA: 84935742990.19.8B9E45E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8075C180006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:25:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JvFgJ3kP;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804313;
	b=EUho2sl/tzj9TvLh95bKfkOMOA5feT76a3by4vmsP3GrmwfHi8awrUVj/RLmlU8xlDnU1r
	ms+qpkJVPfMK0yloJqKj0wBUSOUXMzeGQpD9cThgRC3O7UEOAJDCj4zYmhIShOZqbjnaDw
	cq4W3O5fg+hcShpxVrQUMOB42ujc+6Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8IRfAFAOswM/FHwO19+KBl7CbCbKiUJMFkwpdewsoE=;
	b=OFfPIIqCwPvmO4utuAWfIzkdBleUNeLbjropgoQBXWafFI1iNGJvwuxfBF/tv66JpB9s6c
	EVe66Z7PjPplzqvRl/r1AeTqr7ZeKzA0n166d9HUhMgbzrHZPRknDN7kdnYPP6IiiYV4L+
	sBAFfDURbPeK9Ar5NVC751XzT5YZypE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JvFgJ3kP;
	spf=pass (imf06.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782804312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T8IRfAFAOswM/FHwO19+KBl7CbCbKiUJMFkwpdewsoE=;
	b=JvFgJ3kP0t9L9rGb9nNmMR1/83pWXy93TKXzK3TvAJr9ItSBgG/Dm/LJjuDNWfsxRizchZ
	yD//lrjf3r6HJ8jo9Bcnths5sMVL0mxwY1APLwiOL2FpMIMTl8fpisIbkRu5ME/bd3+m+4
	N63qk1oizhqDReUqFx4Bcf24Xd8edUc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-WTsOREyuNVuLvMEXENhCLw-1; Tue, 30 Jun 2026 03:25:11 -0400
X-MC-Unique: WTsOREyuNVuLvMEXENhCLw-1
X-Mimecast-MFC-AGG-ID: WTsOREyuNVuLvMEXENhCLw_1782804310
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47407691804so826253f8f.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782804310; x=1783409110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T8IRfAFAOswM/FHwO19+KBl7CbCbKiUJMFkwpdewsoE=;
        b=n6Or/AZdhIUWDtYshxVk1I6sPR5gQ64vPP2Nn6yVmIlpuiWeu1O3/nUiHrsBHSHT/u
         Tf9Q3ydpBNwfhW6TnK8/9hSf/NSYekJJKb7WFMlft4Y5aENQc9gt1PkjDUAi1Qo3pkKX
         57sgkLp4RG5agFirahqf14trZTsR43Qk3psA6uXoLlLk9mERQJhuM5JHqnInjn4k72T4
         vqqz63P8mf4qXUSEwJUqXmpOWQk4Cuvsg8AqaT23NsAnhNjtpJVoQzjkCjbNyFS1uf94
         CXMJ+GFg0KfH6CR5SZrnKfjI9f19pkBE4tIKxUIC/WIeEH1zAp5qHbvzKs5QVff3aAIo
         f1FQ==
X-Forwarded-Encrypted: i=1; AHgh+RpPJt7fX+/1epm1uQX2oijwpr2h6WA9FBLV0joaMG7hH9C2T/SvuFNbQsaYcEiBVhqSZSX4IgEiLg==@kvack.org
X-Gm-Message-State: AOJu0YwHXJT6M2gMm2E836UyNblaHKcJUtkIqSuNY8SnofrCS9OOTVpK
	1aTgy3oHYKed8HzwGhRmmsydWx3dZYFtNRsk4viMQrIP87/DaLXRs60MYp3Rc9peZUkPDwPVC7g
	oKDeh5Ckm/+oKoV4j/5RzSx5rXVCv0tSuZfEaFFOA9hq+bNwS6rvi
X-Gm-Gg: AfdE7cm6Af8daPPb0iWByqpjQlDYh0Sivxff6g/xAia5jX04hXSwBvHMlKqqVDhCtXf
	aJ4vfY9DFyCFRJZvlytxTGUrzMGVC+c5+BGQTIptdKDBpSDIxM6IDS/1nBpHvXh3Vrnhi+DgcmJ
	bWXODSKs9McI1fLxj+qYGE8nfr1FqmhKxdxmnm6BEEBH3snzSzSjfOcjC+9LepQBjsw1LU6aRX4
	HtyilJwvomEHXdtixsGyeBHlLRLKgQYwdzLfanI0d3PAsX3iuHYg1xjvEKYDIQc/8ugSD0ROIMQ
	oV19OuCLGM4ZR64x0vOEViH3jaxT8JHTTAOxyi4fIjqJupGtG2dIV5bssgAYL7IM8RoLhxDy6Rf
	LSQ==
X-Received: by 2002:a05:6000:27db:10b0:460:2ee5:67b8 with SMTP id ffacd0b85a97d-47552a67f7bmr2268089f8f.36.1782804309970;
        Tue, 30 Jun 2026 00:25:09 -0700 (PDT)
X-Received: by 2002:a05:6000:27db:10b0:460:2ee5:67b8 with SMTP id ffacd0b85a97d-47552a67f7bmr2268047f8f.36.1782804309448;
        Tue, 30 Jun 2026 00:25:09 -0700 (PDT)
Received: from redhat.com ([31.187.78.205])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47563e0eee5sm5074622f8f.5.2026.06.30.00.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 00:25:07 -0700 (PDT)
Date: Tue, 30 Jun 2026 03:25:02 -0400
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
Message-ID: <20260630032001-mutt-send-email-mst@kernel.org>
References: <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <0a309ed3-378e-4d88-95a0-65bf47c5496d@kernel.org>
 <20260629193347-mutt-send-email-mst@kernel.org>
 <5c8ca96b-381a-4fd3-a218-6aaa87a9a3b7@kernel.org>
 <20260630022129-mutt-send-email-mst@kernel.org>
 <0fb36931-9097-43db-98bb-d087b7b0fa12@kernel.org>
MIME-Version: 1.0
In-Reply-To: <0fb36931-9097-43db-98bb-d087b7b0fa12@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: B7hBD0HpZuXOgaFg9DnlY3KmIySV5-RgrMBhrrpdX1E_1782804310
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8075C180006
X-Rspam-User: 
X-Stat-Signature: ehtdct8mxqssc6w7oq3p554bxirb5rs5
X-HE-Tag: 1782804313-741827
X-HE-Meta: U2FsdGVkX19OJFqme8EaWulWRQ2dlpvdWeOu+7OXqYeqHjXWKPLVLr5azu01gjL8JHG8BjI5NJWvbAtKhYUtw1MWlkWW0sELRwfGU02qGHizQyGpFUHk34Liy1nT6RcvDYxS1kDzt5BLqRUPuI3Hr9axgMY6jnoMuzSPkKuO42/jAK1ZTlzhutO+Lauh/NC3DvwcsdHYHNKfoRO4626pzjox+4FNJyElqqhMDu1YOaUQCF79DnWT9+QmL4xzwRaCX5KTszKP2yGba2AMMPzfUDtWI2E1RjJHPVFWxI6uhsNT+JtA2LFAk2NZbVXid5VtwOKJeauV+Z2iO4b5s4HEp/xtUg1HdhzsrNu325ohMxyKTW9NMX7nG119yz6zPEDBbABqxgHFZPflU2Zl1iPgs0KzmFGKy2yWtLJ7fPofvbJI7aotdY5FFDPN427rV26GF3CdG1P5QjMqS/neca1R/SUNgCFFz1+NlQCU4rl0zysWccSl0j6/9BLxeh3IwjyK/Ibnc1HBBWtwF/LooGngJq7n+1JqCwsLzgolYzI5vFYqf1CSRMe+Z5A9Lp6qmWjEqlbWjaoK7nlbxa1XoSf39aVBv0M26YTmpy4HV0BfLEqMih2v6ECiuJfnEsoVi3Ozp1thfLgood/F5VWWVvx+XjVYjsJpnbd5RRC7y13jPqnH2rvnN5TVXIc6mvIR605uSEHgAqaA64UDV6t0TmEoKsJ9/HrR/MRNx1/uHfoPai7RykDm978OXri779iJSLZFa+xjYXZxgtXN0JFPYZHYrzRuO77dx7CqVfcqebE7jxRAq5CjYWacunOl/1C7hjjR7H/iUPrrwHsPpl1dCU88IGX0N6WSrAMX9HbPFrLWW+D6UfPqzHtxTOKu2gqOj+XyQve+yPy66Qo1n5H97LmkgJv2/ESKYHl8I4go2KmrmJsuE8FuluMQetYrohx8xxqvvX9ltHGF9XG51LR56Us
 nATq53oI
 +InlV3GDc3rKtUy/AWFrJg6nN4FiP8QOy9yPY7WwqdIFx3DgnAe3JXYtc3jGBJ8bb6eZwokB88akwv0JEaNgn+4cnMbpUIq1q2jWsVGESip2N7M5W9M0Xq1ZuIDBWdq+z66OQhLUwJFx2bLH1TvFcj/fLHIW3ji9CZTz/nuReODTq95YnPZam52GBlrArAdIeYT2ZKpoTIsHcoZ9A/E96W/g6XokccnCkDJiAk8glNKWi0LakFuxOSJ3ZhAtdMrR1XNpGfktxU7l3G3bmAMBSYe0J9Ejgyqqr1bMO2SbZqTKlxd13aVtxCZr+RLCKsK5DAfJESuR/JJv6nkAG6M0Blk4o3Ang1iuusAK4H0l/PyNsxRIFhMZa9N+rEHaDY4rTy3jAruUWO2o1r7HEqpNrA9zEKsm8K1Atdup5G1kKO1rdj5ij2MxGiLUoXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 08:34:44AM +0200, David Hildenbrand (Arm) wrote:
> On 6/30/26 08:27, Michael S. Tsirkin wrote:
> > On Tue, Jun 30, 2026 at 08:17:42AM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/30/26 01:34, Michael S. Tsirkin wrote:
> >>>
> >>> Wait a sec, what about call_rcu_tasks? Use that and re-check the bit is
> >>> still set?
> >>
> >> So, in essence the idea I had yestarday when it was late was the following:
> >>
> >> Assume we
> >>
> >> 1) Can have a way to guarantee that a function on a CPU cannot execute within
> >> our critical section (while updating the flags)
> >>
> >> 2) We can request to execute a function on each CPU and wait for completion
> >>
> >> I think we could just let each CPU execute our desired action (e.g., try setting
> >> the bit).
> >>
> >> E.g.,
> >>
> >> 	local_irq_save(flags);
> >> 	page->flags &= whatever;
> >> 	local_irq_restore(flags);
> >>
> >> And assume we want to set the bit, do a
> >>
> >> 	SetPageHWPoison(page);
> >> 	smp_call_function(set_hwpoison_smp_sync, page, 1);
> >>
> >> whereby
> >>
> >> 	static void set_hwpoison_smp_sync(void *info)
> >> 	{
> >> 		SetPageHWPoison(page);
> >> 	}
> >>
> >>
> >> The idea is (that needs double checking) that a CPU will execute the
> >> SetPageHWPoison() either before the local_irq_save() or after the
> >> local_irq_restore(). So it's own non-atomic update cannot get interrupted.
> >>
> >> Now, IIUC when it comes to "how expensive is this" I think we have (cheap to
> >> expensive):
> >>
> >> 1) preempt_disable()
> >> 2) rcu_read_lock()
> >> 3) local_irq_save()
> >>
> >>
> >> So the above wouldn't be better than an rcu-based approach we have right now.
> >> We'd need something that relies on disabled preemption only.
> >>
> >> Huh, but I read that "anything that disables preemption also marks an RCU-sched
> >> read-side critical section including preempt_disable() and preempt_enable()".
> >>
> >> So for our use case we should be able to use preempt_disable() instead of
> >> local_irq_save(). That should already work for your existing implementation.
> >>
> >> -- 
> >> Cheers,
> >>
> >> David
> > 
> > We have:
> > 
> > #else /* #ifdef CONFIG_PREEMPT_RCU */
> > 
> > 
> > static inline void __rcu_read_lock(void)
> > {
> >         preempt_disable();
> > }
> > 
> > ...
> > 
> > 
> > static __always_inline void rcu_read_lock(void)
> >         __acquires_shared(RCU)
> > {
> >         __rcu_read_lock();
> >         __acquire_shared(RCU);
> >         rcu_lock_acquire(&rcu_lock_map);
> >         RCU_LOCKDEP_WARN(!rcu_is_watching(),
> >                          "rcu_read_lock() used illegally while idle");
> > }
> > 
> > 
> > 
> > So on non-debug build witout CONFIG_PREEMPT_RCU (what I tested), rcu_lock
> > is exactly same as preempt_disable.  It's relatively cheap but not free.
> > 
> > 
> > preempt_disable is not going to be cheaper.
> 
> Well, it will be cheaper in the general case (CONFIG_PREEMPT_RCU) :)
> 
> But yes, not for this case.
> 
> > 
> > I can test if you want but it seems clear.
> > 
> 
> If you measured only !CONFIG_PREEMPT_RCU, then yes, it won't change a thing for
> that scenario.
> 
> > 
> > But IIUC task rcu might be cheaper - IIUC it does not need rcu
> > lock/unlock at all, it relies on readers to invoke the scheduler
> > instead.
> > No?
> 
> I thought that still requires protection of sorts (preempt_disable /
> rcu_read_lock), because it might fire whenever the task is preempted?

Why do you think so?

From Documentation/RCU/Design/Requirements/Requirements.rst


Note well that involuntary context switches are *not* Tasks-RCU quiescent
states.  After all, in preemptible kernels, a task executing code in a
trampoline might be preempted.  In this case, the Tasks-RCU grace period
clearly cannot end until that task resumes and its execution leaves that
trampoline. 



-- 
MST


