Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76E81CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCD768E0008; Tue,  9 Sep 2025 15:48:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D878E0001; Tue,  9 Sep 2025 15:48:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6C658E0008; Tue,  9 Sep 2025 15:48:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 930478E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:48:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44B35BB0DE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:48:17 +0000 (UTC)
X-FDA: 83870748234.19.2F31EF2
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 65A48C000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:48:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p7RNFLVg;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757447295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrojLj/ktXW5xY/NIjNyQYgQaTHve7x8/XiMiaN71uM=;
	b=kL3GB+pJjF+UTOPvDIsa5XYgOvuQWTo9N/c6R0rtzqCxLawl3T2selrFJzpICZVGrfTfYh
	b2O0O0l9imMNk6l1PcXPe0/7Mdb+FdhmXwnx/2Sc3m2uFJzmADgpodQGzz8RnoEhfIo5Wh
	KmfilSrKAnRveF1jxcek3t2zCFtelGY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757447295; a=rsa-sha256;
	cv=none;
	b=UidptMhgN3CSQAs7nC/NQZDZ+V9Zi3q/WRUiGx8R9yJS88osv7tJCJjNa7jXe6plj8Xb6o
	SlxzHZjFpUC2UXK15o9Tvkhhc/zSos5KDoznhwSbIE4seTjkoNUHjaVLRqJQqOhXc5vMnd
	elqAngeTOAtzqBrzGnU5xpViu6L1eaI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=p7RNFLVg;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b4bcb9638aso120111cf.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 12:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757447294; x=1758052094; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RrojLj/ktXW5xY/NIjNyQYgQaTHve7x8/XiMiaN71uM=;
        b=p7RNFLVg3HK4EDfvrqBxvqudikirAB/rITXEgIwMmba43fXuU8ouLkQoIgEqDINkgs
         FEqMxya8uQ9+/E85/XkGKciURpTiXPi7MTzY/0IkNyxxqJtO25rbPrsXKc0xb2Xo6rHL
         miGEjuFOYO+/zXSi1K0/VCb5NK7sdkLPkvJc1uVq0eUA7dBe+xYzYzZKHtOMCsqa5Wzx
         Q+nXZk/dtBg6/KEVsHqLcjTIQGSy7jxeQc78ro7431eQSA0pYH2REbpSj9LkG4rRrfBT
         p7hWSKI8MBbEa4397nXi5hfIogAY+cToo3kgew3JC8f5ZBlc6ju+zBPjV6E3qRoLyu2L
         zIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757447294; x=1758052094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RrojLj/ktXW5xY/NIjNyQYgQaTHve7x8/XiMiaN71uM=;
        b=eIVoSksjFCcF/0uaMEmXDEaNznmAoKcKip4II5y+uTRqun9tCjeB4YXTCCjdCuQIIU
         8lO/QjEAMOSUB3vyMthM67Y14lRidGYCR3angpLN32PfDYMvAZSo2rEmLGWvqB1u7fyR
         6PQig2C46rK7wXgyrfb0rI1fzQ2xzex4F0fU89Rq2v6RMEM//Gc4Cb+LECJXz6N39URN
         rCUd9u7Wx614aTQbDmo/lxpKRJrXDSHhZ2jaYAkUuFt2nov5D56Auh7w8L2DsyRDvGr+
         uI3G7Wxi8TeS9Es2PFrXROIRLr1E4Af3iS/YIsoMADJ5zHF9bAWQq10ZeR/0Lrc2iuSS
         5QVg==
X-Forwarded-Encrypted: i=1; AJvYcCVeNj8p2TJa6agrMulv+w9Hk+EMqBoJugcFcAVCmBoXZRFqNwLkJCRBQLLGvQCKf8GNHE5/5Uu7kw==@kvack.org
X-Gm-Message-State: AOJu0YxxMq4+W1gP0k5+cMQ2tdvoQ6bbOaRjXNqSDkJf5tGF8s2xzVN1
	mXwyVVvajPpT1iURPDGpcNUDRsOD596rhD89zM/1NdQPCL6UYcAEFiiiWdjumPapTnVwIUo9l1b
	ZH5BR5Zx4kew0i9oDLYb0BlsXtNPwR8hZ7FgbmoNT
X-Gm-Gg: ASbGncsRCQsHEeGbWeKo0OL4qbUHUrCuCBdxaOoXa5cK5cC6EB4Br3LS2LkBkYua2P/
	sF2G45GotGt9lF98BxThtSkxPfum6sk+Msy5mvjaw9Q3F5uDFuNhvv/sODQ9/58ahY64JtJnks1
	ANJUGOHYEJJw9fWqmMDFsbfYsQnNucRCpJYYoCTIRFbgGLWhXcmboonKsPbJRqog2fkqeVu/WUB
	Wrgj+YCQy6y9pVvHa5YeHN4JMX7+P1CNDaUKilLcsLY
X-Google-Smtp-Source: AGHT+IEpsuLg57KeWm89BZgtIm9RkiFt9/IvL1pt8dPdyEbMc9G1YFKO2IdV8XoDjVFZgzs9MuDgCYFK40OVoWDMZKk=
X-Received: by 2002:a05:622a:55:b0:4b1:22f0:8016 with SMTP id
 d75a77b69052e-4b625170bbbmr869751cf.2.1757447293887; Tue, 09 Sep 2025
 12:48:13 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
In-Reply-To: <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 12:48:02 -0700
X-Gm-Features: AS18NWCnZI1Tq2lGwilQ5dvnko06eauIx4vwc90RQw36tzlJKEe_P08UvcGzo3g
Message-ID: <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com>
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
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 65A48C000E
X-Stat-Signature: p8dfcqct4fgayqkiutzrgnnkggdpbeha
X-Rspam-User: 
X-HE-Tag: 1757447295-392566
X-HE-Meta: U2FsdGVkX19pALCYnEGGzOcmgrdzRLzK7uI6DTCabf7R+uy1hUL/N6qE/kP8a5Xm1fD8QbMaRGHeYU6yf6DKNC1gcwwCEZha4YggcwMMW5b0c847emcnUR21pp4Ha28ASm6RtWly98SnPlPM/I9j9AVVywD3fzQwMUd6eBjHB4LYfEeIcPnZIjhwHbjoCvvbFtiG+K7mAqOa/gQVDxszLf/g1JZAGJ6YlEZqRhSYGytiqPz7wrOk5w4wT6nkoy44O34zVdeUqA2LzZnWfTnstGxYK0RNBoek7XxU8QewAyglOuf3bC0z97FTCWkQYGRPjhaaNRkicvtiArm1GMc3HSRaD4fBenXYs/IZbFblQ3OE2aBVG2t0BDw0YBnBgiTLlHnSeahI1O/EXN05aG5pPUAJ7ZOq2pVUYP4oP9wyWZvEx37k7ZFds/pVkauF4HoAcYJJuT4u7RHuQJQfANq/S9nrVNFapnM/9W8iITSpzmOwrJKWe7d0RQlu1e+kDPSvEgprDZKr5aR+HfXAe9iiRcwd4uuid79glvJ3YXBfeZIV9YHd6UcrgWZ9UA7sewV+FSmP8QLU+3XM3ffJ8q40X4H8pYVmUuConlzmMeFUcBpXNhu/s6DGnDvugsy2jC6RXngTspWKROJpXoGapwpxHbBbtqDE2lRD19GWBMau8z6IcuG3gB2uTFGKjCuhDVf5vfMAIfnd9p67mYanXyZoLFDIav7tNEzMQGAMG81OaEzs/yoDZ6+Z0cA7Rzlhp+iMOEpLzg88hvT5qnU4nYva4QdQQL8DN+cHJMSB5sSKBWv5Bbpq6mBOvuP6LpABppWn/p2kEUA9zt2F6IcrMrurVpFtcbwG3OZdQkSeMW+4BaNtxnlbVwH1VM0WZWNPYJTU4p48eiZmtM8fJL/wUvi8IhJcDlLR99EPJTBeqRfPUY/hf32yJ1cQRcJ1Vf3QuLTyG8u/WN1o/zYk4pNWUas
 qUgaA2/e
 zLNLd2UOclm+q+qUM9yuGdGznPl9DtyGqHqY7mL5m9BIT9io1uqAeTuyskCEph0JhiXz5xMu1rrFP65VRjVT7CW/yGwsmXxcrNF+s87dxXcYGjEmTMIry1wIBmMGKaPllfCUdpLqNSOJMlvIciSoJhXWTDenDIrITbcDNkLUXRGOuXpCu0FVydZi2Ck87FC1baX2H
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 12:21=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Sep 09, 2025 at 02:53:39PM +0800, Lei Liu wrote:
> > 1. Problem Scenario
> > On systems with ZRAM and swap enabled, simultaneous process exits creat=
e
> > contention. The primary bottleneck occurs during swap entry release
> > operations, causing exiting processes to monopolize CPU resources. This
> > leads to scheduling delays for high-priority processes.
> >
> > 2. Android Use Case
> > During camera launch, LMKD terminates background processes to free memo=
ry.
>
> How does LMKD trigger the kills? SIGKILL or cgroup.kill?

SIGKILL

>
> > Exiting processes compete for CPU cycles, delaying the camera preview
> > thread and causing visible stuttering - directly impacting user
> > experience.
>
> Since the exit/kill is due to low memory situation, punting the memory
> freeing to a low priority async mechanism will help in improving user
> experience. Most probably the application (camera preview here) will get
> into global reclaim and will compete for CPU with the async memory
> freeing.
>
> What we really need is faster memory freeing and we should explore all
> possible ways. As others suggested fix/improve the bottleneck in the
> memory freeing path. In addition I think we should explore parallelizing
> this as well.
>
> On Android, I suppose most of the memory is associated with single or
> small set of processes and parallelizing memory freeing would be
> challenging. BTW is LMKD using process_mrelease() to release the killed
> process memory?

Yes, LMKD has a reaper thread which wakes up and calls
process_mrelease() after the main LMKD thread issued SIGKILL.

>

