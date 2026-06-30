Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E74BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:27:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36DEB6B00A2; Tue, 30 Jun 2026 02:27:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 347B86B00A3; Tue, 30 Jun 2026 02:27:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 235D36B00A4; Tue, 30 Jun 2026 02:27:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E00596B00A2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:27:32 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 454658D7C4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:27:32 +0000 (UTC)
X-FDA: 84935597544.24.500E3A8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8ADB20002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:27:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O2ab3cAT;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782800850;
	b=8VpQQCXhjh5OCu90mO6oQ0Q89Df55+w9T5av9plfyIwqQ1EMaXSWe5N1LrY4A1gHxMUMae
	cJ/LL0qXaDpyi9b9J84OtaSUL1RUlQt2dQTnn8A4kEOEAivuPvVnn9ixGFdaGJYkWr+1zG
	XL1OL4NQsMwEKVFnL1CO+5+I3s1sDVk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782800850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g85B6h0E6wmvIawCj3aK3oknIgQ+/nlCgtdjk9sHnt4=;
	b=WeGCvw8zzERm3SPQPpXBKxxR5qGB95XrVyYorqxvVY+xm3yt1u2F+TQft88AO+DtpzOu66
	omjUnDRlEnUkgDF/LivVtb3/4MVsxylnxOH40iW6B33QnseHrr/8CkfRuiwtFM3K1+0aYi
	MqHo8U5hdEPd+7v3VamZLB5d6BZVv0Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=O2ab3cAT;
	spf=pass (imf03.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782800849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g85B6h0E6wmvIawCj3aK3oknIgQ+/nlCgtdjk9sHnt4=;
	b=O2ab3cAT8rPVgYh6trCvQBG1PdHB/GORqABT8unyUkt3+0OGHqRn7pX8FVVtMbDFaryuqc
	G2o1KvdsmVALnlCugR+3gmU8MFC+mQFApqP3JU1pgz8lPuZrlphRceruxVjt9iQEMwYNFU
	sROKWaVO2FAZNOJqO5QlaoLjmp8GIRc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-175-UL9Qru6CN2e_wqr_j4uD5w-1; Tue, 30 Jun 2026 02:27:27 -0400
X-MC-Unique: UL9Qru6CN2e_wqr_j4uD5w-1
X-Mimecast-MFC-AGG-ID: UL9Qru6CN2e_wqr_j4uD5w_1782800846
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-493b0fe95b6so12431425e9.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 23:27:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782800846; x=1783405646;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g85B6h0E6wmvIawCj3aK3oknIgQ+/nlCgtdjk9sHnt4=;
        b=Cqvl+5F+wJW8+Xy9EXaqLS3JGl9Fbs1+tcJY+CGpMNqwL0Wjepwpft5NqJ/CMqO3uF
         8CJKHvYtGlY+ms3LIwQK65pb7oXGxgeTYuZKAw61sNIrXGeaxyXiaZG+KTLv5i+K86vI
         H5+uqQxqQ1v4VFC2Qr9eonZTO4lmnkwkUa/2sntq+GXGJT8dMJhQxrBFJQ/nFaXpyc4L
         uZklSJ4NyUTfzQTdyhkzl6uJml5Q/cuWRsE77siVE8tOnvWkfv8CE9eKdYbsoi3ZLJC/
         t78++xECGFZvHnKevpjDGVMn8D1hhLdKVq0H4t9kuPBA9hQQaCKaJQ3wTz3PiLxC7Sjc
         KYlg==
X-Forwarded-Encrypted: i=1; AFNElJ+lKaulH8UE8CvRS+D8zs/q7KH7akbhWcOkzKlPHOnrXgNCFy01JQZtQTDCnM1mz2dYoEiygHkQHA==@kvack.org
X-Gm-Message-State: AOJu0YwZzzyhshc+uYchqVu5egc+7aoPSaQz+l/2XWXvDRFuxthgTDNx
	FSmYxSk2C5B/1KYHKGoiERL1scbuOj7A4/VK61yrLwnkQOPJH8Rdp1xDS1hBzQ/o9+UspR/a9mC
	yDoSgFkdK3S8myxwnt6x7EPELKmD3ONFP6NNOAVefrPW6NYxRy1pM
X-Gm-Gg: AfdE7clh0neRZ1SIyFy+DV3kiVaPnpjG8+7Dn/gPlh/BVtlhCbUoKA9jkjwucFk0q9n
	lPyRPcnvFnHrHqCTjiqqS4E32aHplJJgpcUju9sJilo1P7/MCyb8+UzkhfZTI90Ip8XaufQTqTM
	kXcuchNRIlN5VwUu5KGaN0XMWDHVzKfwOflqs0z5CTjvDSuI1VBsMFnp+QUEtAhsML0j9l1b5Mt
	shGr3EcEZZ3ZvNyrEeBPmTPTufnjDTWmzCrVExgJhCot/+1KTBXLQTzqGkCq9c14R+P33Mz83SS
	Wjti63yutdTAajdehZxYfib+E7t9n0PKTn5rKTjWfEyEvhIlQ5UM16ttXiC1HHpoD9gek57tyyo
	c2w==
X-Received: by 2002:a05:600c:a408:b0:492:5bc8:5e77 with SMTP id 5b1f17b1804b1-493b82b8b49mr23585545e9.29.1782800846094;
        Mon, 29 Jun 2026 23:27:26 -0700 (PDT)
X-Received: by 2002:a05:600c:a408:b0:492:5bc8:5e77 with SMTP id 5b1f17b1804b1-493b82b8b49mr23585075e9.29.1782800845541;
        Mon, 29 Jun 2026 23:27:25 -0700 (PDT)
Received: from redhat.com ([31.187.78.205])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bb4f174esm13896245e9.2.2026.06.29.23.27.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 23:27:24 -0700 (PDT)
Date: Tue, 30 Jun 2026 02:27:20 -0400
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
Message-ID: <20260630022129-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <0a309ed3-378e-4d88-95a0-65bf47c5496d@kernel.org>
 <20260629193347-mutt-send-email-mst@kernel.org>
 <5c8ca96b-381a-4fd3-a218-6aaa87a9a3b7@kernel.org>
MIME-Version: 1.0
In-Reply-To: <5c8ca96b-381a-4fd3-a218-6aaa87a9a3b7@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gbDRp3OL8AHdbr65PolL_ZyQA6R5YHr642T_ncvOlwo_1782800846
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: hygauyq5jfz3rhmsucyi97miiunupzwz
X-Rspamd-Queue-Id: D8ADB20002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782800849-31671
X-HE-Meta: U2FsdGVkX187h0F/Gw46nrB2TQwPZKOc1muBHFA0+CCoUkdbwB8QvdOKI9Zh24yoMNIbeANGg1h9arYqB+5238ZcKhmWBFzQnvE33EhSButfuLnqUXlwNvexgw434HiknKTLxMZ5o5u7h5Qv43t9eoDAV1CzLD+ilBs4HTlBugRjonWxW+n+Yo2/SbbjAVAvPa047pmccELBAKnCJwzZIt0jzp9agW4om9XTdTV3Gc77tSE9u2z48wac1Zgy602m9TSany83/xMAGfYWYqJa4uV2BiwYHxbLfiRr1q1pzxR+ZIOyVCgOYF5GX5UawyHGjWl46TaeTbxIUUSZv2xJXcYJwaG5IDbr86R2JtnzkunXiYU4XVrmu9aOhwRQY0xfSfi4Ty9Auz5tfa1xnDfjU5p0tcvmkWIBXBjSSs73zYkYWPIuqakqxZq/R2d/OhVkDOCZdFHAu1i/uCLehf6N+zPgdrujz10K4DV8vuFfq/iNZzrZ2NRJuSO/LfqcGdawB1zYxDhfT90Etk1W8wnm9HvAeeeioG/TsRwqy+mtba1/uIdxezwlJ+AWjUXjEAA4YJaEQ8asS1vow2YIUwyitlLERwGwc6vpHqQb/WijIP84eYJTd9SKdZpKF34VlF+Is8iyXS+N35W8Ie3kBLAlNMYKgmu/eq9KW+65Ho0tnqDjJbeoymefRTj9got+I43aQ59Wfb8fBo+39G1MmeBCe/pFaxj23FhY1asUnJ8WzFq7Y+Ubit6ENnM0JdY3ysT2xNDsnGIbAzmBfPIw88VsG4rXYwakywI4eHcFYnZixvRNUYci2a7/ynGh2oEnXDYrvyILm/7nfMoPTlMqdUpeaNdc9R7zjLOtFiHGl33SJUaXQcFgoIxazhEpmA8S8Ovz7cK2B0z6pqIyBLAUHi+RbAyd2zuzFqgJhr9CKw8cIbO6ULIL17N4ynbymVKvIipu6LAoE4HLOkHcRtsKXAb
 zGgwPf+K
 gPRO4J8uIoB5PFqcWIpr/gJTDqn27mzEZP2NZE9O3XTiDrkx3HCvB3KIhbE9qDVtiLDEnYAue5Q66fWuQmweEtvQYjRuzLgAJF8DVGcnrF0xyqwxgb0+7NrLrFpPJ721WfLqMlq1Zi3wskwmJak4kpzP15eDpufBBZtDp4N4kUvjjjRCZkkbxMZJoHUeF6YWHrj95h+HRy9LOoqydQDPzCLameZtv0j/QW529qCM37iCBjjcNxXYxdGqJZVwnFvwC+1NXRHlcCGy2HaH4U1yhXzyh5WSEGbB5nHitwdW9KBVDpNKWKXgM7Z6WGqHefkUUcjMU5Os+h1Oewh7uyZyFUXp/x84wfVUfnnJTlMrHNLqgt7+V6MjqOXxTsqLiFwf9qevc77A4p8j+FW5T4Qapc29uatvkQxjGZoTWwJGy/IJSVaIMFxrYTfc0GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 08:17:42AM +0200, David Hildenbrand (Arm) wrote:
> On 6/30/26 01:34, Michael S. Tsirkin wrote:
> > On Mon, Jun 29, 2026 at 11:43:32PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/29/26 23:22, David Hildenbrand (Arm) wrote:
> >>> [...]
> >>>
> >>>
> >>> Fully agreed. I was hoping RCU was cheaper (I mean, we were once told that RCU
> >>> read side locking is essentially for free ... well in some configs :) )
> >>>
> >>> The question if we could optimize it reasonably enough ...
> >>>
> >>>
> >>> ... for example, by doing the rcu read lock + unlock around the
> >>>
> >>> 	for (i = 1; i < (1 << order); i++) {
> >>>
> >>> loop on the alloc path. But I suspect it's not going to make that much of a
> >>> difference.
> >>>
> >>> I concluded, similar to Andi, that stop_machine() is too big of a hammer.
> >>>
> >>> I wonder if something could be built out of preempt_disable() and sync SMP
> >>> calls. hmm :(
> >>
> >> Scrap that, shouldn't work I think ...
> >>
> > 
> > Wait a sec, what about call_rcu_tasks? Use that and re-check the bit is
> > still set?
> 
> So, in essence the idea I had yestarday when it was late was the following:
> 
> Assume we
> 
> 1) Can have a way to guarantee that a function on a CPU cannot execute within
> our critical section (while updating the flags)
> 
> 2) We can request to execute a function on each CPU and wait for completion
> 
> I think we could just let each CPU execute our desired action (e.g., try setting
> the bit).
> 
> E.g.,
> 
> 	local_irq_save(flags);
> 	page->flags &= whatever;
> 	local_irq_restore(flags);
> 
> And assume we want to set the bit, do a
> 
> 	SetPageHWPoison(page);
> 	smp_call_function(set_hwpoison_smp_sync, page, 1);
> 
> whereby
> 
> 	static void set_hwpoison_smp_sync(void *info)
> 	{
> 		SetPageHWPoison(page);
> 	}
> 
> 
> The idea is (that needs double checking) that a CPU will execute the
> SetPageHWPoison() either before the local_irq_save() or after the
> local_irq_restore(). So it's own non-atomic update cannot get interrupted.
> 
> Now, IIUC when it comes to "how expensive is this" I think we have (cheap to
> expensive):
> 
> 1) preempt_disable()
> 2) rcu_read_lock()
> 3) local_irq_save()
> 
> 
> So the above wouldn't be better than an rcu-based approach we have right now.
> We'd need something that relies on disabled preemption only.
> 
> Huh, but I read that "anything that disables preemption also marks an RCU-sched
> read-side critical section including preempt_disable() and preempt_enable()".
> 
> So for our use case we should be able to use preempt_disable() instead of
> local_irq_save(). That should already work for your existing implementation.
> 
> -- 
> Cheers,
> 
> David

We have:

#else /* #ifdef CONFIG_PREEMPT_RCU */


static inline void __rcu_read_lock(void)
{
        preempt_disable();
}

...


static __always_inline void rcu_read_lock(void)
        __acquires_shared(RCU)
{
        __rcu_read_lock();
        __acquire_shared(RCU);
        rcu_lock_acquire(&rcu_lock_map);
        RCU_LOCKDEP_WARN(!rcu_is_watching(),
                         "rcu_read_lock() used illegally while idle");
}



So on non-debug build witout CONFIG_PREEMPT_RCU (what I tested), rcu_lock
is exactly same as preempt_disable.  It's relatively cheap but not free.


preempt_disable is not going to be cheaper.

I can test if you want but it seems clear.


But IIUC task rcu might be cheaper - IIUC it does not need rcu
lock/unlock at all, it relies on readers to invoke the scheduler
instead.
No?

-- 
MST


