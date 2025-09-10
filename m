Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86680CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A608E000B; Wed, 10 Sep 2025 11:40:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95298E0005; Wed, 10 Sep 2025 11:40:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82BB8E000B; Wed, 10 Sep 2025 11:40:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B07BC8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:40:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67DC81A0109
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:40:53 +0000 (UTC)
X-FDA: 83873753586.24.C3DAB99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7EAD2160004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:40:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J76m1Yza;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757518851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRgAHBWf24BTGFBuYhLJzHxAVS+bdjD+/zjBvEVUqW4=;
	b=3ckq4DaF/uhhHUi8nC76DjoxdI8qpnHbuzN1/yNv4TB0IL5gzxVgFEPt5E47G/qdA+31kp
	VCKztDxb8uVb32z/uK4Edg8rUq0SH3/P1NvnQIq9J4LU9Wvb7IFQfFG3qwgVVv5UCqDojU
	IbwKFkBxM/zBBMhkhrPbOBB16wTeQ8g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757518851; a=rsa-sha256;
	cv=none;
	b=dkCuRF6mNzl6l9wGDsmhBPt6vqwrFodyp82C/sP/MH+1VIVmKo7+Vf0/8tUolQfuiI2166
	MtCdHJYKt0697HnoLlDPhNZxAp6fY+GWIe/OzIRddoT4C80civvrqoArCsj1dqErpzW48z
	NsRTn8KsQEGCN/bospVh401PA7f03kc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J76m1Yza;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55A7644C31
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:40:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A53EC4CEEB
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757518850;
	bh=bRgAHBWf24BTGFBuYhLJzHxAVS+bdjD+/zjBvEVUqW4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=J76m1YzaWMVu8gZMrw+H4quqgApxvXcymv2X1ZHk6ayyYh55sAOLp/ig36mIDk3fH
	 Lxtr8qCWU57ri8RbJRbk/SHl2fhRnjRMeIAvnDvbgw8YUn3PKYW/zmRjngC2pb9utg
	 WChyhKddsnJYRRKL+oe1OgAsk49Jee8P/epyDFTXzuNYe9IruQgn1rHswkewWBaoM9
	 15tZ3+DVU/eEYf1T9pnfsRl0RldAF/Wfpu9z9Kw9kA/WvjsLRaoyb2W0UxLCnIIoaS
	 Wgwlz6pr/hVEdxIXWIpXzR8l0ca5RD5KTNAxNlzjPdRPiLEOWXRDjMfY7VbseQvGqj
	 a3/aWKSi1+DCg==
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45de54bfc36so82075e9.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:40:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXA/eDSwsqJPq6L4nH0IhGiL7gO7SbHmqh7WIcZYsjxvbOMX4cVpSLCx7tPCNluu+RJ/Sq2u54QyA==@kvack.org
X-Gm-Message-State: AOJu0YxegAg5Zn6HoalAQMnrVJ7Zr76//pecOuJtz9aqPuNH52q6vZBD
	PNbZSu7AHQkEIz5KfUzfX1DiqXSQHHb3SZS2BpkMI7TywWTbern05qeJIrnyej9/1puSzrZyqLQ
	hBuPZXe9D0hdunZrBX/0uoHGLBdY3aGBVdVsZXqVo
X-Google-Smtp-Source: AGHT+IFzQFxctqHRUP+7gGGNT/cgajA5FhoYSBtLF9Qnh83FEO2IIPJiyqIgLr5qEirjnieHoVaR1O9ffHFb7IrurfM=
X-Received: by 2002:a05:600c:a59a:b0:45b:92a6:4972 with SMTP id
 5b1f17b1804b1-45df74f7e52mr1533855e9.6.1757518848231; Wed, 10 Sep 2025
 08:40:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
In-Reply-To: <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 10 Sep 2025 08:40:36 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPmp9_uS_AE2FkAy+--PhCadspSRO6osEvK9gTqWEn_ng@mail.gmail.com>
X-Gm-Features: AS18NWAa_U7BDSFPnyN8FeQb4fRXFRsmriu4wTPjiduKLAM37lIhjuNUw2KPbFA
Message-ID: <CAF8kJuPmp9_uS_AE2FkAy+--PhCadspSRO6osEvK9gTqWEn_ng@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Lei Liu <liulei.rjpt@vivo.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
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
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: o79ayxa3ibr3ixzmacsxqrim1eh56f6r
X-Rspamd-Queue-Id: 7EAD2160004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757518851-49530
X-HE-Meta: U2FsdGVkX1+mVzXdtaRC8iTguOUJuBKKXKyxPgb3nxv2lMd9Cp6S9SW4Mx5Xsbm3a8/CFKzhQPyfv4jJPZGsr40zpqCIjR9/wmspiFZPQJGGrK+Zrx99VlXaV4b0SnNUKUyvL8KHpHgju+5ORyzlQeXKYXr5hwPgLmm4bAhRTzV6gWAwDmguWir6MGVYuBkLcWMJVo5avBWFpjhxVm8Ygrmfs8hYeVdyBFaSbR/nQ4d1204Kq1ZOUFVio0f/tCOe8a8Yfvbm25g+TlwmHu2k4iQtDfrxxnYXVk4TO0W0MbpKjjaZgjIFnX8FJkObBHriwa5bcVox79QDa5nGC2IyDUIr9NX021X5MczbQUR+ifyHWfEtIXUHMwpUvZ93Ff0oXRKPvqWBNoYSYIaOEwQln5Arvmc0WCehxJGzbaRlYScP99uROXU4Pf2K6aAAJZhqCTKH+x6HEcKEzBSHS3mbmoqXshGrAxGd7tpQp4X64SYdldvo7FcZN30F2Tc13gjGqrqhfzVMTy8/vQUGROnE0BvhvN03i6JLzWymPeqcGtVmseR7d2uJlDPKSeB7kqjFeN8ct9madvpI/x+McLCELRocmJ4EMwS+ylP6L5arK19+lWFPW8gOPVd8vKwNm95zMahNW0/jE9Fo46LXQFGvChakqyEBYs6b/erGZgxWfL33W5N+wYDsZ12KUXpXHSvBWL1XRSNYS9Qld1n4iZLxY7qU8G362hrAsPAkPrfDIlWb3PIkzsmkHYuN5DquzWqbjts/rnIebMgTOpFrncdTAOPcW2IWPMUQ+VK8gEN/huZfeZc7n3+EC+T6HLebP/O7TJszieBgQdkDD86gW0FU1CCxtMm90oiv/DSs+atJXSeB5v5GlZ1ACE7jp6cBPYlJ0vxWBYWRfEGtNW1NBhdPKX3ikznEpZ73gxUMC/v2XvsGDfn54eacY6NY04QCeiq7u12amAABXgI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:48=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
> > > Exiting processes compete for CPU cycles, delaying the camera preview
> > > thread and causing visible stuttering - directly impacting user
> > > experience.
> >
> > Since the exit/kill is due to low memory situation, punting the memory
> > freeing to a low priority async mechanism will help in improving user
> > experience. Most probably the application (camera preview here) will ge=
t
> > into global reclaim and will compete for CPU with the async memory
> > freeing.
> >
> > What we really need is faster memory freeing and we should explore all
> > possible ways. As others suggested fix/improve the bottleneck in the
> > memory freeing path. In addition I think we should explore parallelizin=
g
> > this as well.
> >
> > On Android, I suppose most of the memory is associated with single or
> > small set of processes and parallelizing memory freeing would be
> > challenging. BTW is LMKD using process_mrelease() to release the killed
> > process memory?
>
> Yes, LMKD has a reaper thread which wakes up and calls
> process_mrelease() after the main LMKD thread issued SIGKILL.

I feel this is a better solution to address the exit process that is too sl=
ow.

We are basically optimizing the exit() system call, I feel there
should be something we can do in the userspace before exit() to help
us without the kernel putting too much complexity into exit().
process_mrelease() souds fit the bill pretty well.

Chris

