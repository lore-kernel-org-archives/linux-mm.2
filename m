Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5588D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 10:39:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 229826B009E; Mon,  1 Dec 2025 05:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201686B009F; Mon,  1 Dec 2025 05:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E1D6B00A0; Mon,  1 Dec 2025 05:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 041776B009E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 05:39:43 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7F4F1DDD30
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:39:42 +0000 (UTC)
X-FDA: 84170556204.21.B6C060D
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0791C0007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:39:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YRFrmL8h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764585581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eVqlfvbnB6Jt+dwL/fKo+5bkZHEMBBaEcT6SxFkp7bE=;
	b=laq84slhXbkdeHWG/RN4UBnAxlVC/rAiC4dBCb3QARldHmKTfCeeELQPNf3b9dfHdGlpd6
	p/+hlpll2FrDJcrph3mGn5P11Mnn4161cN+9FlbN0jEa0WgSPLLHXg0ZpUM6VhGTCP1Hsh
	CKyt2TWnS4QXgo1NNQkgNRQ9Lswjojc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YRFrmL8h;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764585581; a=rsa-sha256;
	cv=none;
	b=o3KpzO6kE0oqF6p+WjPTcpj87GCADrt/MUEXM3c2wxKzyS+ctL0uNcWFHvAjK4R+JoWLCB
	6pmsCf22vldmr+TqLLtPJoVr7pEdlIriSr7NfHvxay7ANvYHPBGKPTRdzpjSvzf1+kKmHh
	f9wUDvXbCKmQfBRUJ4daN1+KKUDFDj8=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8b28f983333so378404085a.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 02:39:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764585580; x=1765190380; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eVqlfvbnB6Jt+dwL/fKo+5bkZHEMBBaEcT6SxFkp7bE=;
        b=YRFrmL8h/sQDK8lL/2qYTaLG+1tIZLmvySrW075qdGc/hJoQFwmviSR+8CjEg7r8sJ
         iPZ7gMXXJ8b0pC17bv+DMCmVh+Py8o5eOdvupeDnFjAxsP42xgEf8YbgohgqY4b6XMG0
         FonxUHsHPL6AkDJdN+XzA6s5hea2Fbhmp26l5qDRibp88V59x7JAYy8Twh5grqXh3YOe
         5EkEOqrQNkOr8z9bFylTg0bjXYIX+miPT/qdgPxFSH9CkvHFIcBT2LpIzSdLfix/oZpE
         UqSWUpAN+oyZCPbaEFZYFZEQEsJLzLGWLAA31QgQYW/Ia9mnefGpVK7VhMYNBC2t4Nhq
         uizA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764585580; x=1765190380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eVqlfvbnB6Jt+dwL/fKo+5bkZHEMBBaEcT6SxFkp7bE=;
        b=Pi20yp1fVGeba+i+xYO6F/z3JtiN/tFy5HhwbSvNCD+ZRlgCSUoGieywyRL3iN7M5l
         AA+LxKVzz7+mRXsI3MqFoVKNWTAdxQ2dpUEH1fdx0Q62LMuLu9IOeUNVNT7BB5Cxs8aR
         fXRdeeNH90yVfNlsCVm97WQyCmXHGlYVVnCVNDF4A02W1nW2+y5Tgxkg8OBOGu49chld
         3tDFDcLIy2hnD4AFiIKJLwH4B8AhfXKkjTIOEtj5dySIrY7by5lYbufsH4+C2lAODY06
         1phTnvnmdSb4IYNo9809XARDqbzeOb564Y5PjsMh95t/ly7hA2bECfbbXSqnUMwjLOPh
         iOeg==
X-Forwarded-Encrypted: i=1; AJvYcCWPu45/SXnB8FyPg3BXojyUqcOMzbcpPSHeqfTTFObpZb7kq2XCwV2gY2uC/A6Miz88kaCoz/0ULA==@kvack.org
X-Gm-Message-State: AOJu0YzQwJzG4ycrII9TQ9MkN3FgaTE3+bINC31QtaZRNdGnb0n4pKRa
	1BDqWznuX0DcRzthjFyASz0iwGOD0jeW1VNY1VKS1jyP4Wsm4qQrOUKfHRdoatF3XjKa2WuykUd
	Xp7pPuAQTw37PgjSqg8SHi1r4zUtnoiQ=
X-Gm-Gg: ASbGncsTzvSIYA1hoVC9YLaairGw5LtjStgX7D1ugiIY4cZCr4NmfrsfcwsEdXr+fZs
	VtzECuXZnQQwLT3sIDmqEObTdYg/M7V3rWqtP+jW+OeYzcKbkwR/7oqZNiocQDSEBdHYSTjmxwl
	GMQx5xnVcL7I1LCXljNtVMxpXsv1F0x4rQfM2Nvh4mps+FP4HO9VUcEBwj+F+UOjEHnPAA2HeJM
	/ACgfU2ak6+Y5brPT6ZLIUwyWQgNMRoA64KBBO5xjGVW5nUuvC+O3naq1BLLawSKcoHYg==
X-Google-Smtp-Source: AGHT+IG74z3lES06shc6Abrf2jDP6OsXw1j4gHSocVERkFq+qiAhZ6poKfIcf1RE4S08qMyz8qmfiB3xfZ6p/IR252U=
X-Received: by 2002:ac8:7c53:0:b0:4e8:a850:e7db with SMTP id
 d75a77b69052e-4efbdad7f96mr396585221cf.71.1764585579826; Mon, 01 Dec 2025
 02:39:39 -0800 (PST)
MIME-Version: 1.0
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org> <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com> <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
 <66c62243a510421db938235a99a242bf@honor.com> <CAGsJ_4x0aVkDf-AhhGbBLU=LCxYFqYoFL0ovij-vFEQeJ46jYQ@mail.gmail.com>
 <dc8ce4f329d74a24bde62c93818df44a@honor.com>
In-Reply-To: <dc8ce4f329d74a24bde62c93818df44a@honor.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 1 Dec 2025 18:39:28 +0800
X-Gm-Features: AWmQ_bl8cG_eW-1XhcPjhfAlyIHR_s3L1DahRCe_je2wzBXNhrB7Ynb2hmqyutM
Message-ID: <CAGsJ_4w16G+AngPu48SEy1H+ZuE1AQngiY=cSfEs9V6=OUKX_Q@mail.gmail.com>
Subject: Re: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
To: wangzicheng <wangzicheng@honor.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, 
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com" <axelrasmussen@google.com>, 
	"yuanchu@google.com" <yuanchu@google.com>, "mhocko@kernel.org" <mhocko@kernel.org>, 
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, 
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, 
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, 
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net" <corbet@lwn.net>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao <tao.wangtao@honor.com>, 
	wangzhen 00021541 <wangzhen5@honor.com>, zhongjinji 00025326 <zhongjinji@honor.com>, 
	Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: F0791C0007
X-Rspamd-Server: rspam11
X-Stat-Signature: o61rfjy68jquybmkfas86cdkbyqq8frw
X-HE-Tag: 1764585580-512096
X-HE-Meta: U2FsdGVkX1/CF/XPHGbROQY01f79uyKgR1ClVv4EVbvyCUyyh+8u8kFRn/Tf5/SgKVvGbeLUlB1esKqDlilTLv4LCFiK2JbYk4bobedhHorq06LjG8bUbt3KTiGOUT+hjz4dWCAS+lpYp9J7pPJh8dm2g1C6ZEiUiJcOdOWNDYy+BUJQgLqOz5+YslgRp+exqO2nLeSZN6zS9H/QtRIF/HaPYLbe1EsB0Vlx9Wn890DcA0jG4wnVApsm1qpeh+2bm0uiKmkNnZiKhIE8EPoHPVkDVSiyYY3PdkkDH4MSsLZZMo8revEScZt4pcEAqcNRVmhW2G8rA66zJaPvOSO41lTQL6CdR5RVEamtQzWzsYf2UAq04wzSF3BFpgBbXbR4AYvjbD74fVLGhfj3Ung6+C6fSJ9HpKNXewGgTDcoIvjm/onHPyvsJINll79X9AMRFOAevxPxBCsoi/d6C+hNykKnGPod7TdKmbfgxcYJyjHjJAMneDsoe6q+h9WtRkzBk5osz1GLAyyC4J4yvOMBG3Ljp7DOKDDMApczvP7G5IXbgIw3ruKgU/BKS7GrOkWfkPCglhwJyYFDTaUSpCfpVW4c8R88BX6T69a6b2UPYXmIYwMvqcUUyuKIo3BOxNzrz4wtM8ZxXzLljhDZ88YbmgoDKHLebcpxTU8ADZt9YmQHV/GgqVe09FWFNnV7KjUPuAq8p7u45ps6+ROSsQ2HKWC3OFNVBZtbL3kCJFCililPLqcos6MQHhmaCii5bri34mhB+7TrwQHtTbQ9t+MxIRVMk40qnMyRaoT3kX4zFSklIw+S6bF6o8NGY6THLYQV6SpYtWgI9uoopJXuzyObDOGbXVCWyJ73iLao6MBH4SFAyf9cCXU8C532ZEwHZ7rzaXXbCvaMJ3yoTfn3uixLiyfbVdP6eC7nB+C5LTu8JqcK4L//uq9OEirSKh5auYECvzcMa56ES/U1yhvwjyu
 /lLZJ6MM
 UbBUHFz2e52J1pzcEsUT9qsyaQM6yod9M8YrTDKHppZtiMAK3iFr+ADGJ8uwY7zDDB8y1zrzqBGYs758fLVJbK7lTjQ5pwyUIhpEw7jnMgzq+lRw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zicheng,

On Mon, Dec 1, 2025 at 5:55=E2=80=AFPM wangzicheng <wangzicheng@honor.com> =
wrote:
>
> Hi Barry,
>
> Thank you for the comment, actually we do know the cgroup file.
>
> What we really need is to *proactive aging 2~3 gens* before proactive rec=
laim.
> (especially after cold launches when no anon pages in the oldest gens)
>
> The proactive aging also helps distribute the anon and file pages evenly =
in
> MGLRU gens. And reclaiming won't fall into file caches.

I=E2=80=99m not quite sure what you mean by =E2=80=9Creclaiming won=E2=80=
=99t fall into file caches.=E2=80=9D

I assume you mean you configured a high swappiness for MGLRU proactive
reclamation, so when both anon and file have four generations,
`get_type_to_scan()` effectively always returns anon?

>
> > Also note that memcg already has an interface for proactive reclamation=
,
> > so I=E2=80=99m not certain whether your patchset can coexist with it or=
 extend
> > it to meet your requirements=E2=80=94which seems quite impossible to me
> >
> > memory.reclaim
> >         A write-only nested-keyed file which exists for all cgroups.
> >
> >         This is a simple interface to trigger memory reclaim in the
> >         target cgroup.
> >
> >         Example::
> >
> >           echo "1G" > memory.reclaim
> >
> >         Please note that the kernel can over or under reclaim from
> >         the target cgroup. If less bytes are reclaimed than the
> >         specified amount, -EAGAIN is returned.
> >
> This remind me that adding a `memor.aging` under memcg directories
> rather than adding new procfs files is also a great option.

I still don=E2=80=99t understand why. Aging is something MGLRU itself shoul=
d
handle; components outside MGLRU, such as cgroup v2, do not need to be
aware of this concept at all. Exposing it will likely lead to another
immediate NAK.

In short, aging should remain within MGLRU=E2=80=99s internal scope.

But it seems you do want some policy control for your proactive
reclamation, such as always reclaiming anon pages or reclaiming them
more aggressively than file pages. I assume Zhongkun=E2=80=99s patch [1] we
mentioned earlier should provide support for that, correct?

As a workaround, you can set `swappiness=3Dmax` for `memory.reclaim` before
we internally improve the handling of the aging issue. In short,
=E2=80=9Cproactive aging=E2=80=9D and similar mechanisms should be handled =
automatically
and internally within the scope of the MGLRU code.

[1] https://lore.kernel.org/linux-mm/cover.1744169302.git.hezhongkun.hzk@by=
tedance.com/

Thanks
Barry

