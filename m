Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 114D0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 08:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B29B6B00AB; Wed,  1 Jul 2026 04:33:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03CCC6B00AF; Wed,  1 Jul 2026 04:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F6E6B00B0; Wed,  1 Jul 2026 04:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C18AF6B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:33:38 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 49E751202C0
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:33:38 +0000 (UTC)
X-FDA: 84939544116.07.6786843
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id DB20420007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:33:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=doTAP4yR;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782894816;
	b=ElGJLzuXWl9SzSSByxthNl22h2fqgoOO524emG5u4W6Cb5cOF9cLKw7FNC5M4hv1km55cx
	L8HkFjjguWqu0miX+lg9wAKY0EuMhxf1YWM0CE5wvZ6A7I8epR+u2kT4a0nzhPaJXIkG+k
	ZjxG3RMPVJgp0E81a/FFxhHv6liGKm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782894816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGIqf/RERDJYkTy1UTY+sb5OW/7mHN3HiL9KZ7p6W40=;
	b=idrnC9cH5AVFiZ1C0FZhba9Y+A/26d+pSTr9nL1V7gyzF0koOzm/0zdaGa/i2ikTODjHvX
	zqAsZzRbTsgTPWjqAPJIFI0woIsiuMnQGgZTFBw9KdFa2pduw3KJnhCo7T4Hjfuz9kaKWZ
	GK1ZLlsj/lCcJt6KEQTIERiJiqavULQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=doTAP4yR;
	spf=pass (imf13.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782894815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UGIqf/RERDJYkTy1UTY+sb5OW/7mHN3HiL9KZ7p6W40=;
	b=doTAP4yRrdwNiNQpMG3QhhlhAf7i3Shnz+w0qGb/k4UEjSfckuJOSs3+1D23M3vKxqHJ2s
	IFRN8mFmmS3jJyE6QI49b2X615tLIo7EjRq1eg51t6gf2EgochTYzWHYBrL5lJroYnw6Tx
	uAONzdqZMRiBVFdLqa50/ZpZdjxVGfo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-YQmp10A0Ow6LENmaXRRToA-1; Wed, 01 Jul 2026 04:33:33 -0400
X-MC-Unique: YQmp10A0Ow6LENmaXRRToA-1
X-Mimecast-MFC-AGG-ID: YQmp10A0Ow6LENmaXRRToA_1782894813
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-493bd52dae6so3012835e9.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 01:33:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782894812; x=1783499612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UGIqf/RERDJYkTy1UTY+sb5OW/7mHN3HiL9KZ7p6W40=;
        b=YdHGF7bz8p+nm9Yzrs6wriP35xGV61bYmzack5eszib1v7ArEh3Luaqu08Mv0tio9b
         PpVHiPc4WnSX8cApqT32b3+eYF78zCUY57h2lHSHcaudJI6ddy+tFPQB8fFJs36/OQgz
         UJh6nbpEqZBxLQLViD+Cacwg2kleOhatRHZw7NcETmLn9ifCOygIRF4N+nApOKnhrhra
         kMn5BWewPQs2xq920iddZrrA3YyRXJDhG6dO0ZZ3VnwqznFoM0LaOic4WE1EcpHxEc/C
         9/Kdk2d2VNWWPUc5CBfTbVQvzD7wfP56LS0mFl2b5JhV4Resf9gDs+J2B3z9HmSPxlw0
         wSaQ==
X-Forwarded-Encrypted: i=1; AFNElJ+/2oK3+1/IdlSX18qESuSx4Pu5z5XdCJIWmRd/DhadnHEaQhcoQkamOH8jxvW3k85D2tJ36FnyAg==@kvack.org
X-Gm-Message-State: AOJu0YzSWJ4Hky80n6ku5FIOVwIGF+wdOLP36gvaYiTLZpqDNS3ehUMa
	ZU3GjjFips+9wrJr149GARSZ10z0s2GCaZ3694/3TDoLksqtzthXssZLpO8r/7BljoS+kLXGijC
	dj6eHbi9mM0CvWt2ZdVkMGO83B+EX3w/VYu80Ut+LK+KiuHhzjpgj
X-Gm-Gg: AfdE7cn9haFmCBJoSKZaXpDWhwokIR3ZiwNV+UH5Cu0x6WoEQCnImQueCgmiyNHQbDW
	js0SdQT7VOz8L1VQdUyEkHz2JklBRDO/acEtCng86E2BSkGtVeTd8x0ktO7SiQmJAcMzY73YMfz
	+VXtuds4nXixGWtIW59Nc+0SsvWm/QTrs6M6xpdXIEa1wJl09SzYoFhWOGN3xbCmVNCFgvaf2ji
	SDjRUEWfPzupsOabXh3q2qnxyyf5XM6ClmzkUerOxxo+HP9grZx6nBCRkdfhkSg3dOMTHer87AY
	LWaCIBtCnmTkUrar6DjSj8280FUK/28soZFYaUx83CMwDIvBrFdaTSHORlKuH/oFwPCX/vF1gta
	FzfNNbmyjG9vS+lfPSJoM98LAAdCLHt4z
X-Received: by 2002:a05:600c:190a:b0:493:c068:db11 with SMTP id 5b1f17b1804b1-493c2b94615mr9321145e9.26.1782894812480;
        Wed, 01 Jul 2026 01:33:32 -0700 (PDT)
X-Received: by 2002:a05:600c:190a:b0:493:c068:db11 with SMTP id 5b1f17b1804b1-493c2b94615mr9320455e9.26.1782894811919;
        Wed, 01 Jul 2026 01:33:31 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4f76a7sm56484595e9.13.2026.07.01.01.33.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 01:33:31 -0700 (PDT)
Date: Wed, 1 Jul 2026 04:33:26 -0400
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
Message-ID: <20260701043024-mutt-send-email-mst@kernel.org>
References: <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
 <20260630174852-mutt-send-email-mst@kernel.org>
 <2f884bfa-3cd5-4fba-8aa4-c2e68890ab64@kernel.org>
 <20260701041112-mutt-send-email-mst@kernel.org>
 <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
MIME-Version: 1.0
In-Reply-To: <d2ce93d9-c3d8-4915-a511-d08eb2c1b374@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nMchRM3I6l26DZxskyWoC0O53Yl59kj9B3GTAuzsXMc_1782894813
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 8gfubjz5fhec9a1ex3a8ghykm8oos6ge
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DB20420007
X-HE-Tag: 1782894815-645750
X-HE-Meta: U2FsdGVkX19GoHj7nWd/NFk9cDYSsIMVGXL1G9OpctS3wiI4bVy8VmuELBQ5ZVL4sMXia/9b9KYJ09YYqEVDMuYJf/ByDDlezL2CCeef/nS7gxTJ1RG4mGOZCbrn61mx00izmlXgkP1AAfD6skmQFyoTNLYQY0aAQB4rAMwaSQChH4nQHlPOgaSS/mpj4XmbOKwiMeMEXKdW9Ln950hWeoLxFaBxGtC0ezi2TuCXunbyLLQHAjbbHx12AmbblQglI9id8qMI+xQ7VCIYibkcsHaE3IG7d9GK5icsztuJfsCLdGRdhwGEsQffp13XeJhhqn+L1jUfVu62PK1lB1fy/h6KfZcOX0PhUFC307f+gYfZJfKTaU4TFG5POw4X9J1YjZ2PgmmClnUCwBka1Txdaf/sj9cYnDD1N2qQRjk1ftCIOD+g0G90CLVUNM3wlxf7mO4r01vbyJDZRDXtCK6brBy6KuddOch4pl2a7shRI0PAT+F84EJY6EFqZ0LHNEoaWkFsNKNzpuDCBiT8/PXt8mZ1hbmaLkJoK+CEV6tJFeOBEyl+Pw8so541jPqW7GTSLpdBdXTNxmM+nQC9HRTtmIGzXoOff0H92fYE959AJA/D4EWCp/sOo4O+Q1DtV0Ov5DS1qzl7zQOAls9CpRen0T1J0Et6ow7GOvyjDJxniduWyvAaWqDk8FRm0EKPC5Q6u0Q6lb7sDbmpGR/aKtJSTpfXWG0lHysu9vh87K9a2/k7TAG6driJlXUdDJWnSwrXVIzk2fJUznbrSD3A1Wnn2/3FdwK4IazpseAXfLGRBH4zOrDFJk43NDppbaupXEGG/h9XanCNIDX9kd+a/NEGBlJDn8WGM5J4dDrpoEVqPyaADLNfmmJa05K2Yx0orvakK9TCQV1TJkaEEuRLTcuqQAajY7SrPoTNa5A4xLYrO2EhB0VXRuJLpK+OO0iakT8fze9Kj8PyiwibVb1ooCg
 E+qQ3dpi
 XyxPqLY0ied0dwuQmQShgQe9FwEXuqPDnrGrYr3lkhZpN6AoybW272zkRqvQ4rtNzPJFXqtQ2h6blHG+gCkqP6ctDBzvhrCFxXqgBiuPLlR331ZD5xjPRmeC0LqwffhniSrPp9H6oqGsoe0u8EIQsi5sguqKWx3rm1+l9JWse9HlE9C31LhMa4RLQCdu+GJCUduFCm+pijamrt+aLr/JAzCueUcjf85hOrpZSwzfFYUoq2ztXpLNOBLnq+JXyudTzB9bv/m4zSS6lLfpXa9kjq06MVvdwROYy1D+3yuqs5gBMRdz39RgAmMkmm1mvz/Y2Df7rZPCLR/z67jkH9PpOnbosfwEHmButMidoo/qa9ZXRtrfTA8Z/n4IG5IAetXq9BdI1qyDnae3Jsgre4d0/Vfpa7AEFQqa5dCg9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 10:26:26AM +0200, David Hildenbrand (Arm) wrote:
> On 7/1/26 10:18, Michael S. Tsirkin wrote:
> > On Wed, Jul 01, 2026 at 10:08:45AM +0200, David Hildenbrand (Arm) wrote:
> >>>
> >>> Yay. I did that + dropped the extra lock/unlock and now it's in the noise in
> >>> my testing. needs much more testing of course.
> >>
> >> Cool. I'd expect that latency-sensitive workloads (PREEMPT_RT) would not want to
> >> have hwpoison handling either way, so using the no_resched variants at these
> >> places might be doable.
> >>
> >>>
> >>> If you want me to post (including addressing your other feedback) let me
> >>> know.
> >>>
> >>
> >> Let's first discuss the options. We essentially have the following one so far:
> >>
> >> 1) Ignore the problem
> >>
> >> It's been there forever ... but I am not quite happy about that.
> >>
> >> 2) Use atomics everywhere
> >>
> >> The easiest+cleanest, but as measured, the performance hit is real.
> >>
> >> 3) Keep retrying for a couple of times
> >>
> >> The big problem is "how long". A CPU in a hypervisor might be stalled for quite
> >> a while (20s? can be longer).
> > 
> > So on this idea. It might not matter. What I had in mind is:
> > 1. run the current logic
> > 2. add page to a list of pages to check, then invoke e.g. call_rcu_tasks
> >    (or call_rcu_tasks_rude) maybe
> > 3. in the callback, recheck and if poison cleared, go back to 1
> > 4. otherwise everyone will see the bit set, remove from list we are done
> > 
> > it seems to not regress anything, and for the rare race, we set
> > the bit eventually.
> > 
> 
> So test-and-set (and friends) would also have to check the data structure that
> remembers bit to set/clear (and possibly update the data structure).
>
> That does seem doable. Do you have a prototype?

what do you think ;) post it?

> -- 
> Cheers,
> 
> David


