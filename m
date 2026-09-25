Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 060ABC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4F76B0088; Fri, 25 Sep 2026 15:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E674D6B008A; Fri, 25 Sep 2026 15:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D54536B008C; Fri, 25 Sep 2026 15:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A362D6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:21:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19059406E9
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:21:46 +0000 (UTC)
X-FDA: 85253254212.22.64C76CC
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf12.hostedemail.com (Postfix) with ESMTP id 44ADC40005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:21:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PQi5S8KF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790364104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Jb6ew+moeljvdv7wET58Ij2hd/p8EP7Hag+x2wkklw=;
	b=Wvhkb2gWQ9APTpRA38FZpsP9BB5IE42lInZ887ecNnZDbsFVqZgcdjC1NDMlEcPva7SiqQ
	0hdT/aiAPZC/NBQVuIRwVpbs4vRefOBtBUoH5+Y/ajQWFf0FONeOx0rZICf8pdr2om9+L/
	qzlRqSa5huknWuUr+BLViY7SfuMK4Ps=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PQi5S8KF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790364104;
	b=Lim6hPOTQVYgMnTBoJDpMWJU+5I24A0mHAuRqMVt0gKqOD1wjXXjymbgPHqdpBnZZ/i3Qh
	WjsVp8L3UyZE79hpmUZUOa16WFQLq0X7i19TDF8/iygDkhvTPjZFGTq68e+2Qnnvu4E/SY
	OMUxx+Um6DE8Oj3baMwWCU2DMAjGQ1k=
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8631d0023daso699364b3a.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790364103; x=1790968903; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Jb6ew+moeljvdv7wET58Ij2hd/p8EP7Hag+x2wkklw=;
        b=PQi5S8KFT3WmxTVgWQ6OtTglXUdOmrGmaN+lPFhOUcmjqJ0Wyj1/h/Zh/4w1p55vJk
         mX9+eAJC0u0DhUUlRhQxm1+lMIShwwzhN+xmCYcxWTKAFXg8K3U21fZOMZHoLcpleNJZ
         gO1mGWq4nwIObDCkEPXkBEEKP57qSU+A0uqMAc8cvIIwd0wCHJw2S1nSvoB2jvrMWBXB
         cAGqg6vG9wBpigRNPD+UTP+pNvKUFQQaQztYA7FpNynBcvPYVmAAoZfuz6O872SxXuhm
         k0G5pxQWJbxyZNI+xj/ULqU1X0s4NR5c11uS8sRtOJSA4EYnqwvOHpWrRVlVhRKrzme7
         lwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790364103; x=1790968903;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Jb6ew+moeljvdv7wET58Ij2hd/p8EP7Hag+x2wkklw=;
        b=zFP7S4YVJ7OSHayu2WJp6/JT0Ybt2eqKC27VcSXTUGoMfsYOuHE+D81Rj10AyxxSLB
         YDjgOWjeXuG1XmtuwCQ67zP2OQ77DHrn9n0nyR4IdtlKg9D+U0+NiKc8NLGswYuwLYwq
         vmEOduGdizqpWHwRya/z9K+OfH/5OhexgPvEs5sSJPmor4Q2U3+y3kXF35dW7e49w9N1
         vsconoK7B5XqPmDbSG/nZV4nn1bbfUoRacNLOmN2amWczfKdb7WrHnJNdURg+Lu22m4A
         Ff+MvzcjbH5hibiTOtCwuBUfSkuSp0TFgmioCvonqsgY9INiBo9kn2VyOsMtYN8SsrnN
         5MiQ==
X-Forwarded-Encrypted: i=1; AKwUvBx24S17z+nUtY6VhQrcyy8fUh+6KEFRvqwP89bFp/QpdLA9+AtUwzIwzTJRFNNW6j4cnGKJMT2pQQ==@kvack.org
X-Gm-Message-State: AFuF++mrOPoHf9CbsUu/jXfck1jszMmkLU2MMJTwzJ/+hXnN08YQwr5L
	QbaeGfKiW5RmMU5tYag9Ux1WDU8qQDO556A+eXAkM9ytLLLZTzNl5O27
X-Gm-Gg: AYBFou3b2FsFiZk/CuQxtIyfQC4j3tP/JobuF0ZnWedToGBnHydjpHz0iMzBMnH91XU
	jFQVcj131olZCYxg/Dp60hMD5SC4Laiyk3Y6V9l3AeVHOSGVvOOEb4pn1bgsbK3RjcKyFbrtXdX
	Tr/LwWyUHZTlggid9gUNTah2SMaIe70mzb8iHRg26/VOvHE+bBP9d5xv86TfFxemsi4JfRJ6NG0
	LkSqXur373ysILBO0Q+iydz9DwNnxBFCPmiz9kwdTbZspRzhWxPxBm79NCYjpe7ZCXBFunc3Fqw
	rTDl88TjwSsh//oZkarKTr46rLfi2sCgsWO5+Ej1CoP4mQqvUlbac5W/Xz2bxKLdOnZwKB9Qdb9
	yEDd1IMP7hp52VzD9Q83rkek7ucZkEdzPSW+tCawew+gU31c9mSuDipJNlNdRXGquUkB27m2wZs
	GlywHksPKh/xun2b0yv+GJ6KGNX54vX2SoPgFpjt+QsrkwkR771cQCtMuQA2dYR4zY3VqvWvlca
	y49oZf/rqc8FX4fd5WIiI0yZx9IvxFbk6PriCA=
X-Received: by 2002:a05:6a00:10d2:b0:87c:9094:b72f with SMTP id d2e1a72fcca58-87e98789dbdmr5541733b3a.12.1790364103038;
        Fri, 25 Sep 2026 12:21:43 -0700 (PDT)
Received: from KASONG-MC4 ([1.203.116.237])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feaf83e0fsm1597652b3a.37.2026.09.25.12.21.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 12:21:41 -0700 (PDT)
Date: Sat, 26 Sep 2026 03:21:30 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, 
	YoungJun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Rik van Riel <riel@surriel.com>, Baoquan He <baoquan.he@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Gregory Price <gourry@gourry.net>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arbHLt-iB4RHXyWt@KASONG-MC4>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araWKyJ5MENBwXCL@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <araWKyJ5MENBwXCL@cmpxchg.org>
X-Rspamd-Queue-Id: 44ADC40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: aa6mti1zymc5zsan9rddpbqwdrwos18e
X-HE-Tag: 1790364104-123311
X-HE-Meta: U2FsdGVkX1/NN4qeKhdjJdfM1ZRHZ9kKsXePXlfG+jK9mOKaTS5h09SUBLCkM5nxNTWvWc82kFBDuNpC+fMZn7YlSBlreYpgZvuPXQjl/5eC2BakWgYbRFFeQyUcxTTdMJxIZY/wF87ro+4jIPO4k6R0Syb5qFdXrNmMbXRvYGG1BBGCCsDBHvHAkh1s7Ds2GpMWp8zROC4QAsXLaboW9J/oTMiQ2amkpHo2hOxUNy3pDlNn96cydGxvQwTY9qsvtckbUkJKa6FLbnCiHKplJ3K8aZyzTJZ03IQBB4tHIyjJqEtxsXIWM8BPzfDhR+LgEH/v2G6ywcKS4djAvhZyxvroYqR8Wypaz99nEOgPz1sz/aad0LlsZDI9zjPa+F+gR5OzlPqyxdTPFYq9wvWTJ1yArFuAGYMcCMGhLxN3RmmDJXvczOyVSZWLG7s6I+mq61EL4MSbRyPaDTt9fA3rBFKtI8xg6k/AqvieN/owcmnuYGxyfHDHf/Y7ER3tg/Y5Im0CBUEBnUhYIE7iIJIp/WzGvGJ5bRP4oQWrs7+bVEcGOq1vs/AMUsuWUIDvjBfBapsr3B6TBbKG08F86YRCfE6NbhwJyyZs1AtuIPNhQ3bwY5KM2qOfmvvuEFllFZJIwsYGkCGJ3CwxxZzCKMu89HcFeLjHh3OUgSDsSLo3FokbqSN1Qw3qGLT7+rO4iG0/Iw+FxR4xL9oPsrI+Ld+CNJjAdEeiiwoVfJaxECgVBgMG3YK0LhPysGjDSascsTjk+Pt6y6roFkq4n8fM8wA5fyjxODZZZ8ewfqESBpk5ndKzY5VPG2DhpuLltLkh0FwVhpuhjdSqV78GWNsxZy2F/olhl1qoYBdGXaBfFFp6DtrmocovJuZdBCs7bHsRu55wf9gvxl95FgNdCcxVgxws7tAX4iKW27OsFdPWQa9lhW6qTU/COtxO8bFPEMFhkBXk9H5uF7wMEL5B6xdSxgC
 Nvh7IfAY
 OAvX7I9ovQqd/IDVVA5iozYf+y1XRZZvq8CdZncyorpanivc+XJVnVaIq9lFOA/XGAfQbb6o8ovpVKjoOirWc/NZbtPC2zhP26J2kaUx2kDne/KkK8vQru93fhsv0omWGy6ljNLtiGJ9eKvdJ+ovrmIMOZ88dmFirKGl9op+Yn9NO2B7CGnskcnybj/Uzsov+GbDP0bN9sO5npiYQBH8F31Jte2ZZsfnPQ5jQFjYtWssxYuApOCHpRE85ZgsHdACbbIoUAQ7xcexZohZtlX+2jia5k9SU8aXtERUePAw52KIGrpenYkke1UmrtFb/zNO0MM5dN7Qm7nNgsuIaU/twqfee818F/O/IACsC9P8VCMc9B6Klz8X1mgq8WdnJCXvT5YdYVRh83Nn3bdiQOKxVxVu5CojZ+Rkr0enANxDQjsjRkpwXchvntF/rnKJyWtjlzkIYI3+dU3ntvMPy/zaXGfSvGERkIwEm6QnZ4iOU5/5k/FFB9gI4lpmoOX9fusEWv1aglBBnk/GO7Ylp70KgjMgQPTzcyCNncd1lptfLPeZeC74=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 11:41:31AM +0800, Johannes Weiner wrote:
> 
> Thanks for your thoughtful email, Kairui.

Hello Johannes,

> > I also want to separate two things that I think got bundled together
> > here: not requiring a physical slot behind a compressed entry, and not
> > charging the raw size to the swap counter. The first one is great, yeah,
> > and it's exactly the part we want, it's what makes compression usable
> > without provisioning disk. The second one is a policy change, maybe it's
> > not needed for the first stage, charging a cgroup for the
> > memories it has offloaded doesn't require any slot to exist behind them.
> > If someone wants to run memory compression with no disk at all,
> > memory.swap.max defaults to max, so that still works fine, right?
> 
> I think what we found out over the course of this discussion is that
> people have been using memory.swap.max in two ways. Regardless of what
> we do, we will "break" one side.
> 
> (1) The usecase you're describing. Use memory.swap.max, combined with
> memory.max, to set a "total", predictable footprint of in-use
> application address space. You can mmap whatever you want, but the
> number of unique pages you can touch is limited to this sum. And you
> can control residency vs non-residency through the invididual values
> of those settings. If compressed entries are not included, this
> usecase will break.

Right, thanks for the reply! residency vs non-residency is one of
the issues here. It's also about how we consider these two kind of
resources to balance the scheduling of containers.

> (2) The use case we have. Use memory.swap.max to divide a finite space
> in storage. We only have so much space on disk, and we need to manage
> fair access. Note that this isn't about speed. We have a mix of
> containers where some use writeback and others do not. The ones who

Same for us, the usage is mixed.

> write back to the swapfile need to be able to get their fair share -
> not more, not less. Including something that doesn't actually consume

Is that writeback compression rate based? I mean for zswap, you have to
writeback uncompressable part, and then also do cold writeback through
shrinker. The compressable part is hard to predict and control though?

> this separate finite resource is also a behavioral change that would
> break that usecase. And arguably it's a deviation from how the control
> was intended and from the broader cgroup design philosophy.
> 
> I think we need to build tools to support both cases. But somebody
> will have to change how they're doing things... :/
> 

In the long term we might need something like tier or xxx_ext for
cgroup for better control of different resources? In either case I
think if we could get the building blocks more flexible, and this
actually sounds like a tiering issue? I remember Youngjun once
mentioned a memcg X tier limit which sound a bit similiar.

