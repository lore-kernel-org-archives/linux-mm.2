Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 059D2CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B52C8E0009; Wed, 10 Sep 2025 16:41:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38CB98E0003; Wed, 10 Sep 2025 16:41:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A31E8E0009; Wed, 10 Sep 2025 16:41:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1228B8E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:41:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6790C0249
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:41:44 +0000 (UTC)
X-FDA: 83874511728.16.55EF045
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id A75431C0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:41:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uPYZx/eV";
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757536902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RpQu8B19MEio3rAI2hB/X5DPqqs/M0gi/GwdHg8XiK4=;
	b=KJiAWqCS40U07hwxmT7CQSSx6Vbxmr5jg6gFeCBHoalWqqUNMIMVss2sLmlyX+KtsD1d2n
	i5xPAwP0vWvM7/dXcxUzflLCa1VTcEo9xZcJyiLY3ISQd9Vr9JDkgsqD2PeJkRapcZ4Yvy
	fnjqdB8gJDkRwFsCq6VIvU3HrliH9d8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="uPYZx/eV";
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757536902; a=rsa-sha256;
	cv=none;
	b=mjqc/CCDa2M5jT/hJhjjoJ6cg5Uh68WAbRrEi9UT6LZblI5WgxO7KNIBxUbSrPtj5C70/Q
	+g9mubCx03t6YAne0dbGgCovwEhrYfr9ns7IPtnxvq96e4JIGxvhvqhCRoy83daPK5x5/M
	RIOTlSAn6Wh42WaVCjY83jnDY8Ap26A=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b4bcb9638aso164291cf.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757536901; x=1758141701; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpQu8B19MEio3rAI2hB/X5DPqqs/M0gi/GwdHg8XiK4=;
        b=uPYZx/eVBN91TwxgOaYtjfEXAj+2GYgnobWXxYyLuggxkW6IXfoHjU9GjHrDoRUJ5h
         eoy3mOT1A+3eOfI6B5buyDr1vhyoecuLpejMmWVmJTjegvVIoMI7SGQrihfhj6kf8hMC
         90GzqDXvTTZJufQZCZan/OVEF3kljp5WxzLUt/FhIl0c3MWJ5oMH66lPz/Hoh2tSDO/A
         7o9Ni5z77l1jaykI4jq3be4EAHYKtlsP5SUfawrbYW4larqmQgpkiJVBX5nd2AgLkxh7
         Rx2ELddTAGc3IoEywqomkqOUC3jc7fy4/trkfGo9EzJ7VBIzz1/KG+DKmKCSooQpJcyG
         NrtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757536902; x=1758141702;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpQu8B19MEio3rAI2hB/X5DPqqs/M0gi/GwdHg8XiK4=;
        b=TH1QB3Tn8FtVGhO1evPPxsrDu0WKxKbizlrJeZRKJr0qzsXJ8eF51glzfkbSeE1fsi
         JCx4xbsZXf3OeLqKNIxA9oIXOpHX9UKPVMrWL7TKIMrJfCvinJZ0e69Ph1fnAXgMKN87
         MU5UZtOkAg2f7PtNYj3NoJe2NzRDxFydT+1RMAT+uAJ8Y8/21ByOpA+rwuvf1mYTISja
         UfR66YcOJehbHwLETg4JWr+ctvbCuKjZ6I2FyNZC/JfLezBcLEn/kVdGbo1lO9EH9b7H
         /GJfljYjli0RFNMXSUFRegn1fbfEmWvntbUu12IM/RrTMYeGoR9DmWuzSH0a38Jl4oQx
         SYHg==
X-Forwarded-Encrypted: i=1; AJvYcCXTCmUP3C/iBwvI289Z1vc7D1i1IWzwpIkrxg1qbyZFDF8ow4T4GURSVgoo6E/YRvKXJZIRnZbgDA==@kvack.org
X-Gm-Message-State: AOJu0Yzp33vL1KdQXtRPfMxNuAObfut1wZX1LDK71OB3/fcvXm3IE9nU
	HchEow0gsJoGrhP4Huog2Dtn8/9RwmDbQlMXWUIeR8ZrN9KAEIdxVw8BnD6cLry1T8EVkiR8aIh
	wrNfgpYhEmxT3lYg4tj6rnqqDpH+E/3Wh2tYNKNd0
X-Gm-Gg: ASbGncuvcqsmUnu97Szc9J0PeFqSRWqjaSNbWqh34lqL4/AAnlb+iAgZ6t8njEUHo47
	7n3oDA94sa00NxLC+FWdFyVPzO7sL0xOUsWV7obZ2Vz9xM31LoZSfPxnCaaJy4GXC+7erJ/aN6/
	1tyG4krB5DYKVuw4YI8NZT8618Td4x0/DcNaG5s5hrcuC6AxZVfwSBJBwn8txtl53cB8xTF4RyB
	dDZBLg7MJjuexjbTbf+DbNSTCIyDGcForSiNiMuBD5S85m+xOSNYg==
X-Google-Smtp-Source: AGHT+IHbQlhskzm2umaiSCVK7F4asqf8KLiAUVgJOpxaNfiXFJRF7QoxeR9wlR3GvPVF+MNtKa/jSV5VrLPSsQR7N2s=
X-Received: by 2002:a05:622a:311:b0:4b0:85b7:ea77 with SMTP id
 d75a77b69052e-4b626dac8a6mr7249681cf.3.1757536900773; Wed, 10 Sep 2025
 13:41:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com> <qisfqncqgkgxh2nj5axafunlfjen6oiciobcrmpus6l3xwrbyj@blxv73pbhzez>
In-Reply-To: <qisfqncqgkgxh2nj5axafunlfjen6oiciobcrmpus6l3xwrbyj@blxv73pbhzez>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 10 Sep 2025 13:41:29 -0700
X-Gm-Features: AS18NWANf9zf8-wwlTuHfifwdfaJCLJSeFkghtgQl5BDc45w4ZtnmTyIc9pxfNM
Message-ID: <CAJuCfpF1deAfZfWQZkAdws9FDNsmZp3KMQap-LqcX1NzOoknhA@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Lei Liu <liulei.rjpt@vivo.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, "T.J. Mercier" <tjmercier@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A75431C0012
X-Stat-Signature: f8ukh9jtar4exah3b3zup93jjbx3mwfz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757536902-922500
X-HE-Meta: U2FsdGVkX19IOuWZOeKRxSE34dD+1HN+Fsu0rrbH4Q2u1/iWvDQmoRvJDroQfQoXz8nKTVTBeePaa9Dmy+HNddg9t3KgzJ4s2A4iTjMIQfBOXyp6K/iJMONQZQQY8dvRD+LPzoPU2gE4kMdohaj2pmJtF/n9GiB4ygp7oBwYRtlS+YOegGZdMMg6Q54rLrkttfgIUJ0uhoJntGf1qPMibOUN6S78qjsCN34K6dlnGhq3GB97rpp14y7ev4BsVsGK3glo0cO/asT1zJ94NebZ+5hi8+pDxsj5g7PvncG1/YWmebWxvNim4CoL1WN5rPcKmPyyGqWTEIvxooQbU988ei70Sk4EwOnJUAGsaN341l0BwC+NOi4wSBf8Sk978FNDsbiYBfAyQhAKQceak/HTMAtYA9Nzpz6fcBnID6ic6EL6jxniPSH9vq/F85e6O3RIUmBVtdqd0mtbw7FUuQ75ziNSctjlJxU1AE8R5Nh6TZTncARpV8j3Mat5RXLNggJUDO5IEjZBoSvkoQ/Q/6sJP5gX4AtAETA2PdEEmbgP/Ee5aAnqKeJPS8jC5RfG6yB4fS6qRbUdoki6AY5lFfw0X5H43j7EzALNTcE9EbkxgSeaO0GYZe/fq2y3CENcmt4jTS36P91ESU7c2o/zZGydvIE7TXi4t0h0xh2vyithCOUlGUo1Li/kprkBZU1Dy4hzzin5M9P8yvUocv0twCheYlv9axZ+iZZ1Tiio+b1IOofkOVlCXoGJMVC5RPEHlD7+u7AkPRPrQeBaoBncIiS6dVjU9daTMgbEOLf30So7qehLrdd4w55uV79wYQNiuqk/uy1eMbOGPg9MjsUXuBvnQGJk9tkUlPhGUKcDxRPKd454bt6AqMmazGCUcgueSp7VtpS+nSMyAZBDC7U2Y+7ByATGD9yqYagnu3f/WwxvWV3x0jtKGV5zXb8Bqi684TrMIS157/4DNPp68Q6Q/gr
 KHtngMWp
 7KgUWKLZVfz5hhkxx7y0vccsktsS3wtcOQHkWjjt+IwIGlbQ+U12j7UBph8nW6o29scB01ijB7JYRXlEBr7QIhsKW7qpidONTx691N7jVADmAbluYCu2yOnHPcXkx40dV3hdt3QJOSUNBhLb4oVVbaON1Q2jfgqBldoKtXUOdCkduouUaFYUIv6PDcSvj78aqohJ2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 1:10=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Sep 09, 2025 at 12:48:02PM -0700, Suren Baghdasaryan wrote:
> > On Tue, Sep 9, 2025 at 12:21=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> > > > 1. Problem Scenario
> > > > On systems with ZRAM and swap enabled, simultaneous process exits c=
reate
> > > > contention. The primary bottleneck occurs during swap entry release
> > > > operations, causing exiting processes to monopolize CPU resources. =
This
> > > > leads to scheduling delays for high-priority processes.
> > > >
> > > > 2. Android Use Case
> > > > During camera launch, LMKD terminates background processes to free =
memory.
> > >
> > > How does LMKD trigger the kills? SIGKILL or cgroup.kill?
> >
> > SIGKILL
> >
> > >
> > > > Exiting processes compete for CPU cycles, delaying the camera previ=
ew
> > > > thread and causing visible stuttering - directly impacting user
> > > > experience.
> > >
> > > Since the exit/kill is due to low memory situation, punting the memor=
y
> > > freeing to a low priority async mechanism will help in improving user
> > > experience. Most probably the application (camera preview here) will =
get
> > > into global reclaim and will compete for CPU with the async memory
> > > freeing.
> > >
> > > What we really need is faster memory freeing and we should explore al=
l
> > > possible ways. As others suggested fix/improve the bottleneck in the
> > > memory freeing path. In addition I think we should explore paralleliz=
ing
> > > this as well.
> > >
> > > On Android, I suppose most of the memory is associated with single or
> > > small set of processes and parallelizing memory freeing would be
> > > challenging. BTW is LMKD using process_mrelease() to release the kill=
ed
> > > process memory?
> >
> > Yes, LMKD has a reaper thread which wakes up and calls
> > process_mrelease() after the main LMKD thread issued SIGKILL.
> >
>
> Thanks Suren. I remember Android is planning to use Apps in cgroup. Is
> that still the plan? I am actually looking into cgroup.kill, beside
> sending SIGKILL, putting the processes of the target cgroup in the oom
> reaper list. In addition, making oom reaper able to reap processes in
> parallel. I am hoping that functionality to be useful to Android as
> well.

Yes, cgroups v2 with per-app hierarchy is already enabled on Android
as of about a year or so ago. The first usecase was the freezer. TJ
(CC'ing him here) also changed how ActivityManager Service (AMS) kills
process groups to use cgroup.kill (think when you force-stop an app
that's what will happen). LMKD has not been changed to use cgroup.kill
but that might be worth doing now. TJ, WDYT?


> > >

