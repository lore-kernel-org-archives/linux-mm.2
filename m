Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A14FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 14:36:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 365696B0092; Wed, 29 Apr 2026 10:36:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CC26B0093; Wed, 29 Apr 2026 10:36:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252136B0095; Wed, 29 Apr 2026 10:36:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12FD86B0092
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:36:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA1501A02C6
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:36:08 +0000 (UTC)
X-FDA: 84711843216.16.5DB94AA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E87A1C0019
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:36:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Vsi/Jt3D";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777473366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQE2N9uDqo+wCoggLYHS+nb5L2Ud6xbnNHLN8AB2tr4=;
	b=27BvcYXKjWhnSIFT/J4n4o5ZXjdrbbj7PHC3z6FQQPYQ+eBKaUdC/Atv5e+xuYiOWGdVNk
	TRr5zGJG/KTFdWWmakeXk3W6ZuA+G3mQR1beCeIG/3DGDnS0IL2I8crJ5OrIbvsfk5i6AP
	blS5psesVLYXHx1GlW7f+B+LWFzd7bY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777473366; a=rsa-sha256;
	cv=none;
	b=rk0cAYT0mf6QHto/icSFSMg9a9uUPMmkO7+SLaaEi+0X2sFVPH1wSRBtYfPPYhriAafj0y
	C+v39qQFdWRepxRGhHucmaII8u2qkuc/2FVDMsCKT1Or3WFHfAWLMdfqA8Lumy6S2mQosG
	3o7sKKO5nkgxWxHsOOViKRBZ+JHxcL0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Vsi/Jt3D";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777473365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iQE2N9uDqo+wCoggLYHS+nb5L2Ud6xbnNHLN8AB2tr4=;
	b=Vsi/Jt3DF9kOwjg9GLMNx+uORcddHrQrGYHfQ3pYgq58HjLe4G58J2pJjx0+x/tyj4+Wqs
	F8Zwh0Ve9F2Y8BN4vgeX+IpI+a3h/SCcZxYpxeL7qSHzWZ9DnFZqInKmokYtEqwNX2Yagt
	dQ4RmTypt8kSTPVa5QKm4zUMpuidC6U=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-495-BsYXoyuNPCeR7O9qEq7Aeg-1; Wed, 29 Apr 2026 10:36:04 -0400
X-MC-Unique: BsYXoyuNPCeR7O9qEq7Aeg-1
X-Mimecast-MFC-AGG-ID: BsYXoyuNPCeR7O9qEq7Aeg_1777473364
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-65036e62f9bso1266772d50.3
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 07:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777473364; x=1778078164;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQE2N9uDqo+wCoggLYHS+nb5L2Ud6xbnNHLN8AB2tr4=;
        b=oGVRXaskj+X8/yVsaRk4kMe2hBq8zx4I1WS5S0hgk4XDyF/RovEK10ousfvKfS/6TO
         tidhcHeF5Gn8RDdZRj6ipGzTqiXdjdem6fkpR+ZQloUFMvXKbvTwp//Xt757xD/pxSNg
         9pfyVvrUU6xMt83zaWHqcgdu87rrNmsVpMIAxsjkcokRywRPtrdEVrrknyPD3PRpdCUJ
         UGx/xdyG9KbEt1RkgaXEMJMriZ7YDEftFtLTgsSFHLDnS9zcVBwARvLTcNPSUPvdy2OG
         4SKw44JPvKLywo9Z19F7a/zQygI2KM472dET9zqSP5BboGj5DZZL7UKO0xGPGbz+AFaO
         KyNg==
X-Forwarded-Encrypted: i=1; AFNElJ+BpLJeCu5Kksouh/HtaT0NTAa/qARrjvWHUTuVNV+AVyueSrUk/ESTJo6+zYCgMO32A6lWOpTHZg==@kvack.org
X-Gm-Message-State: AOJu0YwCn9ivohsu8gxBUQbn0+EZ0FT5IboKxAfE2oNTlQiJ3yTwB2yf
	PWTrvH6IOyLN+sg6jJQfphOsromK7eJpr1ux+IlsBmQZUcazkzDaDRuAsT/VOWa/LWwxVBpn3yk
	WCOHmxuDndVJaQIwA1Kspw7+yf3wrbupkzKDOisHkJNoTqH9Lv1d9PEN9fMcphVeRGBK64785nm
	xJ/zUToSlAOXuTkYyL/sI6gtByd+M=
X-Gm-Gg: AeBDietfDlfrScR1PMej4rm4qnCPm+H1ULMtHTmOr6V7UOB7wsxDUYG1JXBFCdHGpOx
	E3lfa++EgrYbT4gsOle3jedaTpTlj401OxlGFhbHQQHKGJ+KGTksF0O/2Ghwk/73iLGIGEQXlD/
	emy3Xy+RY+xRTGG3YT7QeoRod5PaCTMzhWBIBNmCIH0Go36YY4cW8Zy9XjQHFJCeI0AI9KdB0aK
	AqWLFSL/2lvprqE50gbg5TKyG96s8puozW1IzT1h6AyFaCDxjo=
X-Received: by 2002:a05:690e:12c3:b0:64a:d479:bfbe with SMTP id 956f58d0204a3-65beed4aa28mr7450076d50.11.1777473363624;
        Wed, 29 Apr 2026 07:36:03 -0700 (PDT)
X-Received: by 2002:a05:690e:12c3:b0:64a:d479:bfbe with SMTP id
 956f58d0204a3-65beed4aa28mr7450052d50.11.1777473363147; Wed, 29 Apr 2026
 07:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260419185750.260784-1-npache@redhat.com> <20260419185750.260784-3-npache@redhat.com>
 <06c7e6a7-60af-480e-afd9-700e985ca2ba@kernel.org>
In-Reply-To: <06c7e6a7-60af-480e-afd9-700e985ca2ba@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 29 Apr 2026 08:36:09 -0600
X-Gm-Features: AVHnY4LbQydeCo7Rl7wn3Z-HpTNHjOIv16EQn1nxmeiXqcsqhcLw56FreBf18Fc
Message-ID: <CAA1CXcA9GzJbfBhJo6yEahnTvUz=xzfzMkhi+KmpuzfNEb7Qbw@mail.gmail.com>
Subject: Re: [PATCH 7.2 v16 02/13] mm/khugepaged: generalize alloc_charge_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, ljs@kernel.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6deNrLfI3L_dOc11xjEX9Dr-bBZ5TaADSPVj1Vxgrx4_1777473364
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E87A1C0019
X-Rspamd-Server: rspam04
X-Stat-Signature: qm7z9zue49dduoc9gox1w3s3okenxqan
X-HE-Tag: 1777473366-690860
X-HE-Meta: U2FsdGVkX1+kAmsBISxkJihAgIhfYdp0BhGQPpULer3ass8uRL4Y+OlJrGUYiMO3ZnWGtIVyhdefrxsMrqbpu2UKFvC4/u9hfq5VynKQMOlhQP39iJO9Mgy6hSO9tD/XaM7MjcoNqMXvosBfhXVCq0A024joqUy2hHHv7jbUupoDVIM0dnGix7rJt+Mny+IX6drC8uDLdnVVCE1fG9pSqUJEdIkh0cPeFrMfl0s6gIhaapGEDg6HC48mcXrEw2y0F6Z7tiTNanbe2/joKFrPtO8SGvuTPOF5Mh/GZO49aZntD4VVzwBEY7bdHvkcyOJJqMMHic0lQYSadoRn3OHgb9eafIAgiyZ4jjYW4CWgQ6uuWddagK4fyO+hKglK7qOdqgEpy2XSpet1K58oSUpx+SRmjPR0y99D4Y216Q93JucFtp2ur9GHEdrbGgvOr3WIuy4Eb7GBWE1yxlPvXp31rwMfvcEkIYVGlInVJLaGt/F1Ow/KrqMzSGZBL24c3OiBbYPgAk3o9Vp/wjWCTv8JPxsvU9M5WMBX26zwkhJiNw1VtVqZezTiV/eMleRO8VP0HCWPDoZcP+RejTEx8Y/4rdxu+0O2YfDi6HknL2WohbdIxfcHQyoYYNa6ZwlazkVN9TERzloAb7+Gifb0ZV9dfwZZiqU/E87ojW130cWtOBFKkDmL8eQDErTwDns9U5ExdNPeRg+RvtxzVQ3JW+FduK8gyraYsusgPahXSf1wkb0EGyfjjxP4IMuwf4aiNxnY8lSsyc/FYt2qsnBtWf5KpWAmbT4lxri8XBlilE/NzDuyS6h+tcX3f0HobDG7AZB4oShp0xhHVOBWy1V9GcUd0RCtK9LZJYonTYu3bk4PY88ZbBLpejnXplif3Q4B+FdKGB1LiFo1xWV9WIyuME039QZb3Ng55OZGHZt1HeXn0lsrYUr/A2eA1sZSBuOLBnyh+oRLIZaIjp0CcQqqV0V
 vRnt4y2d
 PDGcVnpkfmpH3s9vZWK6DiTpgdOp9U/1GnNQILCW73lE9NoglKqn5D471yFhcYMpQyP54wi2/W8D/kYZelwLEz3YrbhtitwJMbVeiY/fHXKxDTNokapLxmwj4KzfYBmjy/N9z8sFNEgiD8Cl3fYA7jgkKVsox1rCVJIFgHkI6eKwl4aODGYctZ6eUi+QFFdaigyb0mgJ8YG7Eve48v3Cr2KqldAVfgFzuzFFcIFeFRD81qbitJwNxmtqQ2k3aYWTUDwcaMY6j5akzWn2ct94duE4WyDi4TgdJyclw/7uaAgJhudlFRNbkdPqVBJ5kHMFLZg2/S5i54w/DvTmrExyiRMdB8xZbSC4zZRKC1CTtvJ6YwsUUAsFVcEuWFtx9Sa1rY243lNpcpIkjdWU5UqmTEDRBT1bq3YFVWlZi7nDGNSdXIMGuwrOV7ZNiO5y0ZKXt2NsZBvzId+hzsH/fyB3+mfcb5w+6a1CxNcHji4+SUZcNfvPjeb2ed89E7XH83GEbHnqmFApkJKTbhv7yaAdqyyIVsChxdJ7KhUvKeWD9e4wl1n4Ej2NARvITr2lv1IoykqHbfYV0Zn0inzUiMhtn5hJhHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 1:41 PM, David Hildenbrand (Arm) wrote:
> On 4/19/26 20:57, Nico Pache wrote:
>> From: Dev Jain <dev.jain@arm.com>
>>
>> Pass order to alloc_charge_folio() and update mTHP statistics.
>>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Co-developed-by: Nico Pache <npache@redhat.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>
> Your SOB should come last, the order represents the history of this patch

Ah ok thank you, sorry about that.


>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Co-developed-by: Nico Pache <npache@redhat.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
>


