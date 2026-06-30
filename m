Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43A22C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:58:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E856B00A6; Tue, 30 Jun 2026 17:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0751F6B00A8; Tue, 30 Jun 2026 17:58:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDD86B00A9; Tue, 30 Jun 2026 17:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA6676B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:58:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26D871A0133
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:58:47 +0000 (UTC)
X-FDA: 84937944294.21.7211580
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id AF93A80004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:58:44 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tr2iUe97;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782856725;
	b=2qA8r3yxlhxDx5ay/d40S4IjehAkvj0a2TBfL0UXZHQ4GIzs/Ws1FrHl7xHJVotpjgowg2
	U7b1mhlC5XWX6ccYuOteOBOrTJ6iUbCX8quYFomC26/915AKH3KAu9TSJZOudErE86xU5I
	UK0tU6DaQqkKgjb6JaIsWXrYoyIyXco=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782856725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3TpDHKeSg3hCaDbNSxrROf4Ku8OcMO3gdNHwndIgX4=;
	b=BU4CZiO7BAKMIXQYjUOtbAGfw2G7/a8msESDnFKU7bgcz1OWBrBKXgRIsxyGHbyC6mirWj
	mKAXMziwqio7NzSAZx44DkRek427aR7N2tHYuXu7uNM5oa6bu3ybRgXycVLRWh+jtzlEBL
	N7nAOCB931h5/vJ0VJvDk9Wf1/HtRxo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Tr2iUe97;
	spf=pass (imf30.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782856724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z3TpDHKeSg3hCaDbNSxrROf4Ku8OcMO3gdNHwndIgX4=;
	b=Tr2iUe97KElbUl+5vA1yS+vWYIrAr4nDtry9hzVj8LmexgJvUnCh3aMSym8yEVg+YwEg/g
	rooUz/hyxFQhwJ7TyYODboODD1BjSmST29AP7qaUDUmQExPFFTP2DtxLYSicgbJTvneTN3
	GPvW+J7blhMZoOeyp4TZxD95JxoSrjk=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-346-_x41CDFSNnSG2JifvwErOg-1; Tue, 30 Jun 2026 17:58:42 -0400
X-MC-Unique: _x41CDFSNnSG2JifvwErOg-1
X-Mimecast-MFC-AGG-ID: _x41CDFSNnSG2JifvwErOg_1782856722
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4767036f8faso292533f8f.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782856722; x=1783461522;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z3TpDHKeSg3hCaDbNSxrROf4Ku8OcMO3gdNHwndIgX4=;
        b=a3MxFIvSXEwiIE2tH0nmnsfx3E2Xg0tE4QqGV+HJTIunLgQyLo9wpOUSdP/AkHpFQZ
         ajxwoVOVO3Nk4uvWY6LIJAw7/S39PTs16V4pL7R/L8u91nJbA/nkznzTg1eMvASkt/wk
         na93B5y2kmkNC/mXSjHIMY8O+9o9y8zX8AA2ady6EJDv83pY8HkezNWxpQ6uCnqXsdNs
         t9fL0M/WarodsoEz3b1uREN8OMDaNi6gNZzKOgfIzBFJK7RB/gvxj+3NgsnIzV0sx9xu
         ma6HZKVSC8h0Ja6j4dRW18rcmDjYigKvKeRgaK4dLpI6j6IhD6Yv+Vd1/QfV8nsbfhCZ
         LTlw==
X-Forwarded-Encrypted: i=1; AFNElJ+8ihrG3D7lB5vycD3/ZfOOpB7Lx97h3Se/hXdf3Po8RbTeRxGrYwFjRumHn94EsPXdMc7OJR97LA==@kvack.org
X-Gm-Message-State: AOJu0YzSLznCcGwjUgdBusbBv64NgDxCO29pxho7waX+h3D3PHqmMgS9
	m+rKMYYeKD9Rpo6A6+bqtm4hLuc4K5mDyR3kO2a+KwTWc4JgwDmP6tKE7jli4PCuvzJABa+Lnw0
	UYjmb1zP7fcVAQouuWsQZ02TbzLGFpdWPsslV1/F+IY/Q6IiuVKES
X-Gm-Gg: AfdE7cnvBKEZmoo1441MXyJ1Ny3DSYEYpcF8JZ5nCe84Jx/qSC2b+LYzR4rSOF4BQia
	OFZBYdwntNK1nLyZAEJZxSE/D2P05wlisPI5syKtJHqsFvFxJvgink/VonFE9RvAyB6P7ZzJ8vO
	l9ks7xeGtK5YRprcA3EE5NnOZiP6SWT+AOQZZLHGNWmbobFzBvp9+NKW8+Xtv//pf0CXrps94iT
	lIKSrV3Bf3MC1uBq+2PpozBzbrlAabz7wBfAGdOPoevcE6UNUJ2KkWg91rigCInsRKcxuNJhrkX
	WaQ9oZUy36BnNdCmNCEOZ8CvBfK3owDs0WXEF0AdK9NE9o8vznuSGhQDTepOBlF3AKye+ly3uHC
	JPjAlLvxpI6uSt9aizL9Yj6knLeT53MNQ
X-Received: by 2002:a05:600c:83cd:b0:493:bb23:152a with SMTP id 5b1f17b1804b1-493bda7e355mr34314655e9.34.1782856721667;
        Tue, 30 Jun 2026 14:58:41 -0700 (PDT)
X-Received: by 2002:a05:600c:83cd:b0:493:bb23:152a with SMTP id 5b1f17b1804b1-493bda7e355mr34314205e9.34.1782856721167;
        Tue, 30 Jun 2026 14:58:41 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4bfdb4sm27279365e9.3.2026.06.30.14.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:58:40 -0700 (PDT)
Date: Tue, 30 Jun 2026 17:58:36 -0400
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
Message-ID: <20260630174852-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <20260629174225-mutt-send-email-mst@kernel.org>
 <cbab829a-3e65-4b4f-a2e2-704e88a611a0@kernel.org>
 <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
MIME-Version: 1.0
In-Reply-To: <f6d8354c-2f79-4a48-934c-cbeb335765e2@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: aMHsn0XttU1P5xKJnAogJxsziU08yEGvql360w85hdM_1782856722
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: rjjnsya3dzay1amgbt8fo9nro64qatwg
X-Rspamd-Queue-Id: AF93A80004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782856724-714161
X-HE-Meta: U2FsdGVkX1+KFGLBO/JnPUDtRzwivG9z0g9eaUtzvz/wW4gWJVIZ11tDEYSTlwl83xMFTX6UaA5d54Z8HHrrWPfEo1+LAFZ2sTY7Y03UGarJxKTs3vAKc96+bPZQwwnxTXgWcJGdgYPxod2hPtH5kL7mi1TjMCfb67SJ1I6EmUvA7VpbeaZleFiuJBssQT0tG1YDCgCiIXa3n0wD1ELY6k4YKLi4BUcL3mIq6XQiRAm+hpuozeAqmHxkJoY4EN6IBysqx6AfvShDXChU8h28tuGPq+QnwDdi/4oCU6GQAesq2nJLZh87UyT0eh7L1JFxq5sFbt8dPzJ+AwefM8+J8TkliBPjjp7/h33V2BCANjLYb3c8LdQPU1+tw/eNrIOl8O/ij7A522NtvXH0olPhcvhkupP8kW+abbrplwUg3w8wRzhOD6ZHYvkMGucbPBWOQK+w9sdUY0eH7YFgjX6jtGQEu9LZT8DyRGRXZtoDOrtSoxpW8/lsKPXDpyyFn5leGD0LwNJ8UCipfhxZK8CU47oWJDBXxYKHSr5FRrmimnP3towJ84EqluuPOyOzdPR6JwZUGadrYMln/+7J0DiQmmuzOUuCtLMoQcCCzN4CmasuvDD05STIx7IuAqfR6App1kQv0vasKr5YPsyCT6Cnyd2Ne9CRf1sdq/8kdGbmyMFnHuXNmbiJCp7Af97mKafW60J1FAI0Y+UtaKxn3Z+MRiSIOwZ8eTfjJ3fXlByuz5qjY3AlxfPrkAP3wLHTN8g2j3SaqiOiNWSH2WIpbfC6QCIE+GLQ7vP7jnJd7aqcY7H4hOg2l1RlpIRQ5ymtOlH2n41UGW+xywiXj8vB88tiUuoKlyegs/+v5qOaFANP/dMmTvCvIMijxHAmHECWh2ZN8pnNOKzf0R9IHzasiSGwlBrRKSkjCzvj5WoFVzzygALJWhiVZUCKstt6duQ/YrL1+3RFRJf8svvhJG/mwpS
 Gd1MgzM+
 Miqwa3DUcaZIdjIERNicVDTwEXMuLfJihuwgCl4I7eNuzlXy7jLHMyv+1Imvir7zMdO5u2e61j3IMDOgSpogUQxEL1QKRr7jYV7Sl8jJXEyIPvSKWLn+24LLnBEMIqN+muM1TCdiILFk2b5JaYykVpSE/N42Co3ZfqLXtTuIpAQrBtrJZ5TQS43Axa8L4A8MF654dxKPbvplS1p/c0xpshC/Bns9lwOQ2jYFi6Rz3rMExGlPr4ev+v8Kmh8D8+cvMypkQMpLL0BiO6rFt6CCPnZLXfXWiKLsHULYb01fgWkhcr9UNUYy4P3W4MEy8Kmc/ky+su8nVUvIs1Vu/Ka2d6Tjxd0P5yubvNVSFmCJAaCO8ATVZdPd/88UywVJUx9b+WZMvgObgb47G9F2QkAiPikeDpRgBaAi+CzcG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 08:41:08AM +0200, David Hildenbrand (Arm) wrote:
> On 6/30/26 08:30, David Hildenbrand (Arm) wrote:
> > On 6/29/26 23:50, Michael S. Tsirkin wrote:
> >> On Mon, Jun 29, 2026 at 11:22:11PM +0200, David Hildenbrand (Arm) wrote:
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
> >>> loop on the alloc path.
> >>
> >> Is this different from what this patch is doing?
> > 
> > Ah, I missed that we batch this already. We could make it include the
> > 
> > page_cpupid_reset_last(page);
> > page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> > 
> > As well, to reduce from 3 to 1 locks.
> > 
> > So I guess there is potential for optimization.
> > 
> > [...]
> > 
> >>
> >>> I concluded, similar to Andi, that stop_machine() is too big of a hammer.
> >>>
> >>> I wonder if something could be built out of preempt_disable() and sync SMP
> >>> calls. hmm :(
> >>
> >> rcu_lock is basically same as preempt_disable if rcu is non preemptible,
> >> no?
> > 
> > Yes. See my other mail, I learned that preempt_disable() should likely just do
> > for our use case. So the preemptible RCU case would not matter.
> > 
> > I assume that's as good as it gets.
> > 
> > 1) Use preempt_disable/preempt_enable to protect
> > 2) Batch as good as possible in the page allocator
> > 
> > If the overhead is then still noticeable, there is not a lot we can do to handle
> > this cleanly I'm afraid.
> 
> FWIW, there seems to be preempt_enable_no_resched() that is a bit more
> lightweight. I'm sure there is some downside, but it might be worth a try.
> 
> -- 
> Cheers,
> 
> David

Yay. I did that + dropped the extra lock/unlock and now it's in the noise
in my testing. needs much more testing of course.

If you want me to post (including addressing your other feedback) let me know.

Or look into call_rcu_tasks/call_rcu_tasks_rude which might work without
changes in mm.

Or if someone else is gonnu work on this, absolutely fine too.

-- 
MST


