Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C95D41D74
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BFF6B0008; Mon, 15 Dec 2025 04:55:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F36356B000A; Mon, 15 Dec 2025 04:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BCA6B000C; Mon, 15 Dec 2025 04:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D5A1D6B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:55:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 744BF160ECD
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:55:30 +0000 (UTC)
X-FDA: 84221248020.02.6123B25
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8A7EB180014
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:55:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DYjRxsHh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3Dts_aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Dts_aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765792528; a=rsa-sha256;
	cv=none;
	b=fUm/3UChPrc5hIu5OPADtY+t8LDXsUPX0fObCyWdiNSgBuVtYtphT2RkIN4ntXL8k7Hgus
	o882sBKtJmGzckjNzVPG3D/hD1X19hIn6dQDTBskhxQXE4MSN3HK4kRVhTH+BLUpg/94ch
	Er1sxYatz2ZIo4mLDkjsLwDS9ilfw7A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DYjRxsHh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3Dts_aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3Dts_aQgKCBU4vx57v8w19916z.x97638FI-775Gvx5.9C1@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765792528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eXmkpglOgTRlWY6ZkKkXvIK9PamZymsXtf90xHcK+6o=;
	b=2H+xV6GwMNnjd1ufQYj18O1iX3Co0nZTVHV6kHElPNps29usz5T+2ISOOuUI688BNQR6OP
	pPRsXyTe0/SjA8BgRrIUdf5Pq6woP3zhmU9Ypg1F8ceCu8/Ld+3GRM3PMxWhIMxHE4qsw8
	8SepsAH/OE0j/BP8Fevfd1dDOZaNQYo=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430fc153d50so606345f8f.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765792527; x=1766397327; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eXmkpglOgTRlWY6ZkKkXvIK9PamZymsXtf90xHcK+6o=;
        b=DYjRxsHhW/zB5/eCrpiyB9U3cQkxVBKXRXcoYHDtB0sWcfS5bQKZE1eoG325r9EpUZ
         gy8FEMy6WUlDVdwA5EYRIjGeJ0M4F1gLWnyac2TbyMEHfiOpfXkuJ6lvwTAu6tQeuLrO
         SHTHyy51Cuxmub5sVnI8hE9tDyTvAnxTWJZ69RsvEkttkOCE7nuYA10Do1PowtCJuRyB
         wPSybECDgRVyvsfAd3VZ2Ol/+Mx+PvRWdHKFqmMxm+xwRwWIys0YjvSCRmP27sQIpyXu
         IXHN7H/XhedrU96KMg7mOSvaaMEMMRJxtADhOigH7nxOiSsNmaAUUJQFHcz3iR9N0OS+
         /YEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765792527; x=1766397327;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eXmkpglOgTRlWY6ZkKkXvIK9PamZymsXtf90xHcK+6o=;
        b=qhHy83ohZXRwafGTmwz/k+CfK/xm1ejoUL+lf8Fi2HKNPmxoefCEX6ZSwlfruBOac0
         kEZK0m91sS4KqAnRTe+GDBoofP1SHQT41UDO60gm1O442v2WzlKPRqN3KzQd59ENaEcn
         ob1wxp38B/K3gqp2v4psKjkfrzIniHIhYoTYGOXBxuh2qycIvC4LorGGbvuazLu6dGCm
         EEOu0RtKTbcMb2hjtrGTkwY7E57BCmOMmMFZdKuO6Kl7bvZLOQDBVq56i5LwBT8gChWB
         xgU3XT0jMDWoAQxQ9QdgNUwhVqhNotWQtDhXNSLnR053Zh+kmrmejPXGlFnyvTQbJ3Qq
         an8Q==
X-Forwarded-Encrypted: i=1; AJvYcCXyKr6jRFnfPDT/Omy/HbkF0ERP3i/8mVBWjQNHrFA9fx7GS8w7ow/5QJaC6DQhGpuWLPOCLYAYWw==@kvack.org
X-Gm-Message-State: AOJu0YzbLi9vejkIKmHqckSblEkbQ/sLrxO1HzbW7Ei0VEWyEt8GN2nR
	u63KCOUQOFFxQu278t42+dI3vXdaKHl6vy49KeQWMiBxTWMQeGnz9JhqPxXRo99Hr/CtnfbfYTf
	YgYvs/NHAbJBmJQ==
X-Google-Smtp-Source: AGHT+IGJNUQ3yCE5dAMJ9tGmUAnyfo5RpFowfQkzScccNTMlw3Eak2tuYu3AGem3xCXRYZD9qM+KN+pYSar9uQ==
X-Received: from wrp13.prod.google.com ([2002:a05:6000:41ed:b0:430:fcc8:d29e])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:40df:b0:430:f68f:ee97 with SMTP id ffacd0b85a97d-430f68ff1b5mr5631418f8f.40.1765792526655;
 Mon, 15 Dec 2025 01:55:26 -0800 (PST)
Date: Mon, 15 Dec 2025 09:55:26 +0000
In-Reply-To: <aT/WOAr4osoJWaMS@e129823.arm.com>
Mime-Version: 1.0
References: <20251212161832.2067134-1-yeoreum.yun@arm.com> <20251212161832.2067134-3-yeoreum.yun@arm.com>
 <CA+i-1C2e7QNTy5u=HF7tLsLXLq4xYbMTCbNjWGAxHz4uwgR05g@mail.gmail.com>
 <aT5/y3cSGIzi2K+m@e129823.arm.com> <DEYOI8H2OESD.1H56D3H8HKILB@google.com> <aT/WOAr4osoJWaMS@e129823.arm.com>
X-Mailer: aerc 0.21.0
Message-ID: <DEYP7JSVTB9D.3EFN2KEHH3O79@google.com>
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while stop_machine()
From: Brendan Jackman <jackmanb@google.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, Brendan Jackman <jackmanb@google.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ast@kernel.org>, 
	<daniel@iogearbox.net>, <andrii@kernel.org>, <martin.lau@linux.dev>, 
	<eddyz87@gmail.com>, <song@kernel.org>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jolsa@kernel.org>, <hannes@cmpxchg.org>, 
	<ziy@nvidia.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>, 
	<rostedt@goodmis.org>, <catalin.marinas@arm.com>, <will@kernel.org>, 
	<ryan.roberts@arm.com>, <kevin.brodsky@arm.com>, <dev.jain@arm.com>, 
	<yang@os.amperecomputing.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, 
	<linux-rt-devel@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A7EB180014
X-Stat-Signature: pk3ktu5agkpccztsc5zcqnmc4hkt9jqg
X-Rspam-User: 
X-HE-Tag: 1765792528-660897
X-HE-Meta: U2FsdGVkX19q0LQhoAmT2d2+wvaBxZZgIufJZaQZpm3nJsbICZbI693oOFiBG38cumoDNy4cqYUt6I+HvLhKxVGXuUs/OKPpsDwbiRzAaqDs8JP2OH6lB84YFHdHMAgm30W0U3c0JikPj5A0g04y9eDTVakRVnSWXsgeeYM87roBq3CygBangyZw8MJ5hkgAB6382ZQTyDiAEuY83DFW8WrS2SKAlyxOXLKgvqZfwHhjsmam7Xc12skM/Igqlu5G06f/KdopA1rXg62i6mbulyBIINrsEuMX/JwcOXLcIUdK1SUkho0Z7hSqXuKgv1xZKHFV6hlIIdv0FeDAvMa9a+1t5TIO+rwjdOWUoJg5idoY+Sl5tpogtXqnB6bh4wrWj5IipO5HI6Wkp4mqtg8Vv6dlSld4MG+/ICAPFwOvlw0n/HyiGbZcuZ5Z+NAyn0feZOa9n8y0gwFxt6+//kvslLsH9468wmsOBdcaBma6gSF1bNK75myKRMztPNxSmhtV5WEL3Yl/FNlvQ3n1lN+NYJjhnt/yj3yiOXnBzDinSDQ44Gd1yNC8YfPhbljbNm6Ij2yLpZFeBPpTuXEtDTi3aGM9Yj+EN9yBi+3N6o1nL0Su4N1YszXDVwiVL7JR1VlnUdb6NW9Ngx7auC2Cm6hqdXof7U6rbqUOJym/wc3GZ+OCXdZW+0l0EblqakySPSSSA4UIjisGGSEEvgi2G5ZqScV5soer2EbrcNbrnDDk9Z7DfWoNlPIQ1YGaXN5zORYh8CF+6b3WcHX3gYhAv8bjlSmV47qKtDdQFao8YcwqS5yvupF1YYOzdJpFmKUa9/sLIaxY07k7N9ZR1yEYhHGh0X4Q9eMbuZ5OR3/sx36lovG5Eie2u7sgmC6bLsh65LQ330VAJJEUuG+30Te60Ha5kHe0tmjfq70X5lXv8emOS4+vE9RYxxxVqQu90YErfWlWoVIl9RD3OI4QUBohFz/
 2iFsCpCF
 XyWIVUeSUQseROaN72nkocelrMLhs7/8A5oEGngmEMiHOw+zSauyGESVEhnW3y6MYbJxxyXkmvo7oayqn3WVkJJ45I7cI2jWuJ73u1xEi2fcbToBcWjcD9BB+jM8PIPwKwqkfgdn5Wf9sH7LGVOKXVkds2iCwzCgkvF0xCBa1xkPYMEhGAfUzEM/l7GeZOBNuJUNTMQwnifMviFAfHhDpbDuJdoeu6Qi1TITfuNARUFMSauI6k5/VbjCmm1Dgev/69NG/03f14+yPyUtpJSagfwcax8y3a2UxkH32i4GtCwkv7XNV0rLqM5l/JItQ/EPfo1gOluozxProHj54tvdmSKZMNsZ5hQMv/V6l3SC1VDwG9+91QXtbUaliBD9Q+90J6TW++hAcaZ/2imkE0h3fF78hnuqhJmFp4ZKbE/vq/CmuXd0m65qiHGuDg7IPo/E4ZYB3BQRKUXfNxPZ08B5jkwfRr4qIp0fNhEuYd1XNsVCrk/w7c+4OgVz9CmK2WmzBNtw73m8uH6G9oRdUQKNnbfeI5PgxYWk/OjoOfmndmBK89wftNyFLUWTpNgH+yp0H7bM1uonwru2pmd7cqtWp4D5SOgf48I7ScBFfHfs5RwxkgPnFScubk1PZ8A2JL8OvSUZBajvbq8imXw/cijaMEOmUtKrfux1e3q1HhQ0OScV1RThJih/2SSgGYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Dec 15, 2025 at 9:34 AM UTC, Yeoreum Yun wrote:
> Hi Brendan,
>> On Sun Dec 14, 2025 at 9:13 AM UTC, Yeoreum Yun wrote:
>> >> I don't have the context on what this code is doing so take this with
>> >> a grain of salt, but...
>> >>
>> >> The point of the _nolock alloc is to give the allocator an excuse to
>> >> fail. Panicking on that failure doesn't seem like a great idea to me?
>> >
>> > I thought first whether it changes to "static" memory area to handle
>> > this in PREEMPT_RT.
>> > But since this function is called while smp_cpus_done().
>> > So, I think it's fine since there wouldn't be a contention for
>> > memory allocation in this phase.
>>
>> Then shouldn't it use _nolock unconditionally?
>
> As you pointed out, I think it should be fine even in the !PREEMPT_RT case.
> However, in case I missed something or if my understanding is incorrect,
> I applied it only to the PREEMPT_RT case for now.

Hmm, I don't think "this code might be broken so let's cage it behind a
conditional" is a good strategy.

1. It bloats the codebase.

2. It's confusing to readers, now you have to try an understand why this
   conditional is here, which is a doomed effort. This could be
   mitigated with comments but, see point 1.

3. It expands the testing matrix. So now we have code that we aren't
   really sure is correct, AND it gets less test coverage.

Overall I am feeling a bit uncomfortable about this use of _nolock, but
I am also feeling pretty ignorant about PREEMPT_RT and also about this
arm64 code, so I am hesitant to suggest alternatives, I hope someone
else can offer some input here...

