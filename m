Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602CDCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD118E0206; Fri, 15 Aug 2025 13:53:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA4118E0001; Fri, 15 Aug 2025 13:53:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1DD8E0206; Fri, 15 Aug 2025 13:53:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAD178E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:53:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 77B7157D13
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:53:22 +0000 (UTC)
X-FDA: 83779738644.29.1CE4516
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8532614000A
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:53:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=liK6H5OF;
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755280400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JnR+6SXeSTNJPAcPnfPZyM/O5krw9O4MexFcLYOmRkI=;
	b=NLvBSGvLtYbL8EwdeyA3P1MCEHIC4qlBTNIkcWWx8IMFZtNvTfa57Fx3FQA7ozi6EM0AQ2
	52V/XF+nD3LGftWtvD+5tNEA2cYx3q7gBQCwube0bcclzZ6hIlR0Lr36ukemHTxXCU20Pi
	W452vWGEdC7mT7GDo9jZ2QLPoSi6zKQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=liK6H5OF;
	spf=pass (imf26.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755280400; a=rsa-sha256;
	cv=none;
	b=LIVqJCc3QuLawTpvUrQ3YcrJFAcxbCgzu0fuqGdNXT+FwB/HyskgXYHjFAWG/4kk3/sH8b
	PLE4EMevWEJHOFR8oKI6YxeUerJgcS+oFSrI94ZLyirIcfbkHWQxjNhRB80SrsdO7GqoY0
	46B5EpxD9+rQOhveopIBrCC/qZ7E+fo=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3b9d41c0fe4so351557f8f.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755280399; x=1755885199; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JnR+6SXeSTNJPAcPnfPZyM/O5krw9O4MexFcLYOmRkI=;
        b=liK6H5OFVqpgEduHpabQwA18zgCMW+fLO2zMUBJCLWfGdtE3g6GGcRLOQNz0atoIIS
         XzHZnJWLzgg3PqP3GzI4Dg2Dx5YyL8okykXK5JaAusH2Esi/Fbva4z5NRBmnHSX9Q+jN
         xBmeIWEiDcSHprmG3aVvLmT05L1nrqfzZsrbCByJ5+HHeIjTb6JjqCvqEormW8PFEO/Y
         wxpRqDn1S/7zaR/DsS5Ix4HCsTLxxaxdJM7B2DWsUYpNskWJrIW+bF2Ych9OjxaU2HBY
         Jp32fHQ2nxjeCVyxyFE9hSMuzoRTwjjfqttlSUnagk//yWkyz5RZF7vA1y7cTuPFXqgB
         RFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755280399; x=1755885199;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JnR+6SXeSTNJPAcPnfPZyM/O5krw9O4MexFcLYOmRkI=;
        b=B6zsKZS4Kxfnb9oI5trvJ2ZQSXnihyX6ohx1KgL7lVoXgNVlNDs6GWgbjt4F3dZxBl
         ECAsFQ8lB2BDnbrIW+IoEL8bp8tDzTrKrU3Pw7daPJ8Tf20SQ+43z9e0APFHg4KW7PVr
         16IMwbdph/W/3PXdkjIvn9VIhVbWpVq26jbrqY+59MkjwgxJo/7hDv58nOJ/vHXyZtOn
         2XMYwAzM6j3vVLL0jrZ7aY+O0DMITZycMyoi9HB1byuuW9l/bovBT/B8fdFOQKg5+X0w
         +rt8wzwvql/levUqOXhLjuuUEbPBVPO+F7R8rNiRqpe7TdJ094A9VJwGFY9REvhNc7YH
         C41w==
X-Gm-Message-State: AOJu0YxOr+HocAOsJKisWLsZ9j83ZKfrwTQDdlqyJpXRbvroOzPkaSUS
	VRVn4rqtJdBcJz6XyqjH5w9LVRj/Phyyx552zpEIHN4l2d8hIYmRwY6D
X-Gm-Gg: ASbGnctO8Zd5hY4t5WQIhWSR/AKtQyVTAEyKquhg19W8AF22M1A5wW3vgVF4PG4Nx5d
	78+HSd8FwvSI9VC0qqJGobtMjP1EFY2p+A1d0jG8Zzti3f382eybVbWKqnaEXoNd35kQ+uGC8IZ
	RYA8t1rCfPiyUwJNy+UcxS4nP2Q16UCU3hWW91pRA8RXmpBrDLNZ4XEbMxKhjwilap+7AFv5nDF
	VjTfVwE7UyFv5aien5eK3QUOn7M8NpuuhpVaAhgTZxkSIm4zt8ZdJ+Prujxa497S8NchSCMeqSo
	3QW/vHw5WPtA0wueJrIKu8xclnHM7Nb3HZD4QhTnsbiff8z6dmlN/IjqYZ+O/ExMHdUBuvdMBR2
	Fyds6mllDxM8mFhh70lnFrEjrZvLgaYSGPp9swaA=
X-Google-Smtp-Source: AGHT+IGHvEYjsDpgg5kr7y8uLGzdNDDOiuYK8jstfDIjhTKBkrII2jX1JM5xw1E1LLuCJ7d0kCYKZw==
X-Received: by 2002:a05:6000:420d:b0:3b7:88a1:19d8 with SMTP id ffacd0b85a97d-3bb671f50d0mr1170662f8f.6.1755280398846;
        Fri, 15 Aug 2025 10:53:18 -0700 (PDT)
Received: from [127.0.0.1] ([185.70.53.184])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3bb64758441sm2696079f8f.13.2025.08.15.10.53.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 10:53:18 -0700 (PDT)
Date: Fri, 15 Aug 2025 21:53:15 +0400
From: gio <giorgitchankvetadze1997@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, zhongjinji@honor.com
CC: linux-mm@kvack.org, mhocko@suse.com, rientjes@google.com,
 shakeel.butt@linux.dev, npache@redhat.com, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org,
 dvhart@infradead.org, dave@stgolabs.net, andrealmeid@igalia.com,
 liam.howlett@oracle.com, liulu.liu@honor.com, feng.han@honor.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4_3/3=5D_mm/oom=5Fk?=
 =?US-ASCII?Q?ill=3A_Have_the_OOM_reaper_and?=
 =?US-ASCII?Q?_exit=5Fmmap=28=29_traverse_the_m?=
 =?US-ASCII?Q?aple_tree_in_opposite_orders?=
User-Agent: Thunderbird for Android
In-Reply-To: <1CAF2012-C9A4-44E1-BEB1-A1ECE0BC0C3E@gmail.com>
References: <20250814135555.17493-1-zhongjinji@honor.com> <20250814135555.17493-4-zhongjinji@honor.com> <20250814160914.7a4622ae1370092dde11c5f2@linux-foundation.org> <1CAF2012-C9A4-44E1-BEB1-A1ECE0BC0C3E@gmail.com>
Message-ID: <0A987E18-9E43-4ED9-BE02-EFCD8D6BC528@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bxk8zzaamtgah5gxs8j5ney4ssqsjzpu
X-Rspam-User: 
X-Rspamd-Queue-Id: 8532614000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755280400-287752
X-HE-Meta: U2FsdGVkX1/lZSFFWTEKx/USbMO6ZO4ovJyV6niK1m8y+i/NNr/Bdj0++BwJXLXn4odyxMByuD3YI9QvZ63Hn/dnvj6jo1EQF5soBpoRa5cQdXhthkkv3x4J9dG/Xq3y9kTqyX6V0pHCoDHyuP/gakvlFtGD+JoFSYTv0/ifHt4Ora7I/wuOfreSf2buzmQoyhfyXovKpewu9KsqJA0otKNcOxq34hf7/0vHKS2lmxmIyKlLqMsD6FRnNpCPrFVPSdBZOVFoNr7KvWSqEsxNNGMuFe2qEGUMSYqAw/8qd2RsRwr6ZFyyWmCovyl8Rurfx2QlJaVccG4v8ZB6IDeBaaRX6cIsX+hej5di2NTdF+9NE7CinzEI3y4ygkh7OriU7l03V24U6CTRMXyeTRARcpJjx+EznGl2oSZrYqwyRlC4JgmX0pmeafHMrVZFxuuWZ5AApS52cPhjk9lf4RyXIlACC3w4z9jb07jmrzdR8Tru9TwxkR7R/S2Iv+9mhYwD/RRkbtNlYdgIUuIS4F62DeumWesk88TGCHIbjZoGy/v8RfeiEASoqG46JSgjqMKQlL/CuXVZpNFOsXqH1rxO9V2gpOlV939coOLYzTh16nWnb7DDfB2ybIy5EP1BrgX800G4/Kvb0UAGxfUAPdvDWU5bAv1hwDZ+hnVe9pk8QhYJGqJA2ZF+OOOlxGPeWwv5YEVGlhgFx78iomijqewqjFfPIBOweIyUw5zBFC8XLsuBxPF+j53HIEQkyhPEMI82HqTyqnkqcjTWhZm736eIEsbenwuxQiqA8OVAcVrbKA0/r4rgBGu/99hVk/SEF5Ah5pb5NbEJu29DXdz/pk6ZGQ4neGGpzGGnOTHymSgNwOCbCEAuJZadO22pwUKyvEGzCTj2g1ILG/ZBMjii9l2foRq7Z3eUdRI3lKSQtziV2/TKOpQmkWlLQ+zCMNpFKBS5Q9fFv3L+F2GNqMscInP
 wzlGsUNI
 9/3KL6YIjtfaxtYkzZ0sIfQ8Q74eCTcpdQqPZHlj9t1y5mveeik91MaHtM01spzV7zwQh4t4Vs+0LY5Ybq5jxLZZ7PbY3mqdWhUZotSym3sjfa5mGo+Ga7F8THsH/vrF/BI77kH8CoWdCDoU36I87Q/kQF+LRUo0hiB/HgNn+9azI5Ya90X72VK46NSb4eRj4MAmQt02Tokv9lG7cZQCGJ3d3iQV2kgmWplRx6rVJTowTcvRPsMyIvxgBoDTzzfBc5LqBmigB2N3OsEdzIlfaCWmPmriMOMTFkKsq/pIg1CzqHTQMk69z/8ex0189vrXLg1vwrLYoSdypNP7tKHXdqXE3ltkwZkz6mBq9E69RECP4JASUbLaPWPHszkZT7/ANoiAsse3kg/Uu5fgRzDC6euLIdyKrrSBhG92MKUvS1FkkWb2+AT6hLxy0KygJWYrDwLY/QxHL9mbcfW+yY0vK078JHzGWLvIo+DNOl4ugA/ymTVuvqUatOCnRzWaVHA0GOMcUZ2nE8qHIAAy5qWuBbCnZl66UfcEwimfZRgpvdNhtfo7n7nlenVrslLcqpDgAACcVaB0ORMfRIVTwB15iHAvmlGQdzg5J4JvbuAdZPs9slXQJIzi20DSaLz7AdxNQ+POT4V2mBO/2kDAhq+FMkSItLrQtoTY+G++F8Fg51P3HnO9ThH0jE6uDP6bndVmGV0gr1QiqCeImQkZke0ogesYy4zKcqgbP6PFNGzpXU2UQ7DpbBZrHtuCxgcfL29y3T/FJRs4sCe5KS7c0ARCeeBEiK3bKH98gRd2q8q2XNim4w2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I believe the patch should be accepted=2E While the race condition might be=
 rare in simple workloads, it can become significant in containerized syste=
ms or Android devices=2E The proposed solution is simple, low-risk, and dir=
ectly addresses the identified problem with minimal code changes=2E

On August 15, 2025 9:52:17 PM GMT+04:00, gio <giorgitchankvetadze1997@gmai=
l=2Ecom> wrote:
>I believe the patch should be accepted=2E While the race condition might =
be rare in simple workloads, it can become significant in containerized sys=
tems or Android devices=2E The proposed solution is simple, low-risk, and d=
irectly addresses the identified problem with minimal code changes=2E
>
>On August 15, 2025 3:09:14 AM GMT+04:00, Andrew Morton <akpm@linux-founda=
tion=2Eorg> wrote:
>>On Thu, 14 Aug 2025 21:55:55 +0800 <zhongjinji@honor=2Ecom> wrote:
>>
>>> When a process is OOM killed, if the OOM reaper and the thread running
>>> exit_mmap() execute at the same time, both will traverse the vma's map=
le
>>> tree along the same path=2E They may easily unmap the same vma, causin=
g them
>>> to compete for the pte spinlock=2E This increases unnecessary load, ca=
using
>>> the execution time of the OOM reaper and the thread running exit_mmap(=
) to
>>> increase=2E
>>
>>Please tell me what I'm missing here=2E
>>
>>OOM kills are a rare event=2E  And this race sounds like it will rarely
>>occur even if an oom-killing is happening=2E  And the delay will be
>>relatively short=2E
>>
>>If I'm correct then we're addressing rare*rare*small, so why bother?
>>
>>> When a process exits, exit_mmap() traverses the vma's maple tree from =
low to high
>>> address=2E To reduce the chance of unmapping the same vma simultaneous=
ly,
>>> the OOM reaper should traverse vma's tree from high to low address=2E =
This reduces
>>> lock contention when unmapping the same vma=2E
>>
>>Sharing some before-and-after runtime measurements would be useful=2E  O=
r
>>at least, detailed anecdotes=2E
>>
>>

