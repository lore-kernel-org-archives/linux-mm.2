Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CB1FCAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 08:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3478E00DA; Thu, 18 Sep 2025 04:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E727A8E0093; Thu, 18 Sep 2025 04:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF918E00DA; Thu, 18 Sep 2025 04:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA05D8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 04:50:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A20DF11AF14
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:50:04 +0000 (UTC)
X-FDA: 83901748728.30.68793CC
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8FE4E100005
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:50:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VxxU5n2P;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758185402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hDS1lqd8rZbXZbUYB/FWM+UPwaXwxFfwGYspDhm+zY0=;
	b=Wmyy0EMM0uk6hWwXFejaPQD5aa0jPbgR5Afmk+f71Gk2dBgpfucgeHrcTu7fRwR/CoIQqA
	YcLiW/48I0cpRy+RwaQJFAt6piTbOWSRYqgrYrwrhEgwnZENpzchJMjRKhtLLIxqurl8Op
	wPoVxNnCw8mWlt+D9L5KAgVxNAs12Ug=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VxxU5n2P;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758185402; a=rsa-sha256;
	cv=none;
	b=o9jsQZLc+feE9snusVtcLlHmxzvR76KdMFx3FzzxQef985mCp6fVfhGsEQFlf77HIhKhrO
	PDpOUg+jfdjX6lU9zsCjYc8USjrs1cHFkMnC03D+XzhAl7aZASh1lez6AA/8/zWGLCJA4y
	tRwIO3g5gH8xrutDaqwHsBcbd6o0vWs=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b07c28f390eso122341366b.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758185401; x=1758790201; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hDS1lqd8rZbXZbUYB/FWM+UPwaXwxFfwGYspDhm+zY0=;
        b=VxxU5n2P0nOUp8oPFmMSOjtd/tubgRsu881V81YsbrMJEYSJjh7SwcfDksOXYKY5yZ
         M+mpRESA+k99qrVMkEwZkfPFBTXlPrq+NWFv9mDwF0bfu+etGCFdIBo3vyOUGdXs8CDu
         m7wXbpy14escoT8o9gaPPx6RqOUF1oOE6yFEFN92uMupMZnfTU9rTsWuGkumphgbuBC8
         J+upp1QcCYA/sbBNiED9wOUBpMyezPaBkBlRxEkE8z7RCxitHPh4F/ogSARjvkwxHSqE
         8WfGMQTlmY2j1CTzlRCYkXhZ0SzHvrb2XeQwsn1A45tJ1PA1ArwXnm+7XFEX8CKEwflG
         Gxgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758185401; x=1758790201;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hDS1lqd8rZbXZbUYB/FWM+UPwaXwxFfwGYspDhm+zY0=;
        b=eVLj7fhBZmsqZWcb2NeO1Omk3D2xjWkyaiLbGVjVC9ZQRRLu0Q81THaIvyt7mbPRJ/
         KQ5n9e0W7M6JM+F2bUPsJ2+2R1Vin2WF5QbmNMVD69Dsqv9IwqHoLwaAK7gqd2Y+CE0H
         aBSHvrhTKrWmvbsgSRZ+NHDXrzwV8++KwV/6v8IBLTGw1r8djCit/VAaPOLtOcMnPCWL
         E2mJDmsFkHqF3Icn40+GrYo53aIve8NN/zn1Rst5fWsM0MXDrIZby1ug1n4+j1nTfcY1
         gzlPTttOKDLcas50Hk8KwPEh8IEPrSe+EtUzADaxSk9SYgMFTaaArnXSKlhkNtTYXHbH
         /TUw==
X-Forwarded-Encrypted: i=1; AJvYcCU8MRhlE6LNr7TgLSqAkkA+vJ8IzcW1YgKnhey6ZOWKN2N9Zg+7tgMpcGyPO8eM4boF65xRWNpu+Q==@kvack.org
X-Gm-Message-State: AOJu0YxPkze2Fxu2yh4cjYzSXliW6dKaxjMi5c6DHv7AhPe8raTp2ss+
	APe1Pwv18kbQOz6ji72LYW00QV7DAd1OiajNCk6bQc8bmwePZjETc12+Dfy5ghoswhQ=
X-Gm-Gg: ASbGnctOpjw0rC8PXJAjOgz995Gk2gitVARoHCdME1hPHZzCbaxScrqB7GuIcv9MmE4
	u13Mnlzb1S3J+7gS3Hfxb/oNfwsv7W4hz/s/1yiZxsooJWqTKt59btUwMxF8e98wdV07QPsXweA
	pDs7gV7lruYp5y3bni7JJo/OKt4rGpjea6JeAW5ehh9Oz/AevjX2kdP2juEB18JVlh1pTnma+D/
	UVJWQAc6wVSr4xOtoUe5RaOrV4WYg6JOe+KiivUroXDRybxPJH98tqAibyB167z3Gr1GRfLoTCf
	BnWx6wL3h8YwP0bZYa5FrxoaydzLPxvAG7FV2uM5FDcSB+Bbr5mN7r3G01hqBH/KDJkvDYaVUwQ
	QPJfzd+Nrcn5JyJvnCQ9cUssM4xizTuilVwnozrlDqJK5ILia07cs
X-Google-Smtp-Source: AGHT+IHJ6xSlvwBJIDdm09ENnEV7apeA12zqjKVNjvrbj9aWgSqDk9GVscCBVpWo2sK3SG+bEj7tEg==
X-Received: by 2002:a17:907:dac:b0:b04:4975:e648 with SMTP id a640c23a62f3a-b1bbd49ae49mr599268466b.35.1758185400841;
        Thu, 18 Sep 2025 01:50:00 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id a640c23a62f3a-b1fc73ba1e8sm148009566b.31.2025.09.18.01.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 01:50:00 -0700 (PDT)
Date: Thu, 18 Sep 2025 10:49:59 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ye Liu <liuye@kylinos.cn>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmstat: add header line to /proc/buddyinfo output
Message-ID: <aMvHt7Z2PMuZaned@tiehlicka>
References: <20250918071741.526280-1-ye.liu@linux.dev>
 <aMu01xIkj-3hgW88@tiehlicka>
 <1a9f44a1-855c-450e-9dc4-415a29b90011@linux.dev>
 <780aa9d6-a85c-4050-820e-c0ca9f5bb658@redhat.com>
 <6d6e2e33-c221-4ab8-a29b-3d14fb1a592c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6d6e2e33-c221-4ab8-a29b-3d14fb1a592c@linux.dev>
X-Rspamd-Queue-Id: 8FE4E100005
X-Stat-Signature: kcnbxka9rctpatjqsnj3po4mbwteacfa
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758185402-621900
X-HE-Meta: U2FsdGVkX1+rHTgXo2bmo3HhVYbsq9L4EL3Yvn5tF3CI22pWVojlfXr3FVUVU+FTrKLiZJvzJoWHeCGRaChaZytUS7lBw+czou4pxdpXVSvJBWtEcbhwza6LohX/oyXzJGQlIHMyFTHVgfcLdrlLcrKRrrMMRQZrRMfahPPvhZ4Lc99JzSqs4nTMBbrBuZqjUhxbmVc9YJuckt0QhIxDzEC5bSNfws+WHfKyhqgq2ROVMbOJ/kVHjkoSuluU+Dda0bt5OdWWGgQO8v6GIdix9uyz8tnkvu1sWuiUqo28Jo1HoLFANZHLV3huDdPSv/unDOQZyUUQKFN0V/0iCVwgaU1eiwhPM+pPqRPtcu/EV1GUpg3Fn9ekLlVGD0ED8mWDsmIBs7L+i7qtgi5w+Y6Pil5oSCnhOdyyKH5NUr+GTcApSNRJJgc+4X5SR44MpXf8I5ZyoJsQ9ZwWKpWMIAhKBHbhxfF2YOFyd9MFzzWLIho5BlwOgELPjEpN3uQoz5KzYgDWJ4c8oVD4TprA22jtImmGmowrifmxqNbWWrrk6rNQ/k1PTb6Wwn+n+6UHiIAY/rTGdxoQj/+pCLKZ8y+lHVUu0DA/Dkt30iwFnNeKwrJ5oAqfz3L3dpa/k2EKrBxQSfP9U5deZA7omJ84oVzOGybR/8ZLV/zq1XvIAio3XEK5nEjVDk2Nk7n/+84pCPWSOiyoBxND+Qpy69H+Yaxg87yQ8KwN9TrFkRGG4xJTMPO4tbqu5NGQ03I478b/53URjuQI3CNgzUyK7c1QD78+K+nQS8pwZ2WJey1cqFOnp4Oc92uQvtrS5e0ZrpOw+uwThDMW51JGdfrc/4c8GmxLG8zw9dzt3oKqr7YBdHSV0h+6MpJz6KjbZFC0+XsxO8JAI3UtmxzYmdT90/EATsZDP7q23RsedJOAMagLXiS0QwIvdVvBG3gj1pxybi0bxOXvLMCe+NdfoFuUywPGFj+
 GBI+M3ev
 JhPY5lxsQV5/0HPyTC2jtl9NAqT3uL30cmX1e3r78cK+oYGpmL2sJAvOIkq6YQtAJFz7pYzLHRVU6aAC776gMmWVzzwHMARedoABhDnP4I6yjWoU04WctjUEtg85a38+HQHMFfK2vjdLUy9J6MrzYK3RcJCDAiBGRiV3UOweIQot5keJ9mZJ9DDc6DGcGtULtN2DUEOMh+fJ5VzwQ6Cw+KBkdOY4jIwMu8fUvm8bLAm97PNXSJj9pFjA8iVSYRGyDcWsejhsu4QukHV0kJLc53eQ7JZPIQMNkECcyQ3SM8KyYLMKfa+w0v8rcRGge7xNDA+3QYuKXQ6N+Ze6HTxrw+5V1Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 18-09-25 16:31:22, Ye Liu wrote:
> 
> 
> 在 2025/9/18 16:16, David Hildenbrand 写道:
> > On 18.09.25 10:11, Ye Liu wrote:
> >>
> >>
> >> 在 2025/9/18 15:29, Michal Hocko 写道:
> >>> On Thu 18-09-25 15:17:40, Ye Liu wrote:
> >>>> From: Ye Liu <liuye@kylinos.cn>
> >>>>
> >>>> Add a header line to /proc/buddyinfo that shows the order numbers
> >>>> for better readability and clarity.
> >>>>
> >>>> Before:
> >>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
> >>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
> >>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
> >>>>
> >>>> After:
> >>>> Free pages per order       0      1      2      3      4      5      6 ...
> >>>> Node 0, zone      DMA      0      0      0      0      0      0      0 ...
> >>>> Node 0, zone    DMA32      5      8      6      6      7      5      8 ...
> >>>> Node 0, zone   Normal   1113    351    138     65     38     31     25 ...
> >>>
> >>> Why is this needed? And have you considered tha this might break
> >>> existing parsers of the file?
> >>>
> >>
> >> Thanks for the review.
> >>
> >> The reason for this change is simply to make /proc/buddyinfo self-describing.
> >> Right now you have to know which column is which order; with a header it’s
> >> obvious. This is similar to what /proc/pagetypeinfo already does, e.g.:
> >>
> >>    Page block order: 9
> >>    Pages per block: 512
> >>
> >>    Free pages count per migrate type at order   0 1 2 3 ...
> >>    Node 0, zone DMA, type Unmovable             0 0 0 ...
> >>
> >> Regarding existing parsers: the patch does not change any of the existing
> >> “Node … zone …” lines, it only adds a single header line before them. Most
> >> parsers match “Node” lines and ignore everything else, so the risk should be
> >> low. If you know of any existing parser that this would break, please let
> >> me know so I can address it.
> > 
> > What if there is a single one out there that has hardcoded to skip the first line only?
> 
> I understand there may be no way to be fully compatible with all existing
> parsers. However, /proc/buddyinfo is essentially raw data intended for
> human and tool consumption, and parsers are expected to be robust against
> format changes.

I am pretty sure you can create a trivial wrapper to print that header,
right?

> Adding a '#' prefix to the header would allow most parsers to skip it,
> but it still changes the file output and cannot fully guarantee that no
> external tool will be affected.                                          

That still assumes that they expect something like that.
We are trying really hard to not break existing userspace even if it is
not written in a robust way. That is simply how Linux kernel handles all
the existing interfaces. There must be a very serious reason to add a
change that might _theoretically_ breaker existing userspace. What you
are proposing here is not such a reason as it is trivial to achieve what
you want from the userspace.

NAK to the change.
-- 
Michal Hocko
SUSE Labs

