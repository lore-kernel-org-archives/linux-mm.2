Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CBDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B29B8E0023; Wed, 10 Sep 2025 12:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9888C8E0005; Wed, 10 Sep 2025 12:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5F38E0023; Wed, 10 Sep 2025 12:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 78C2F8E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:05:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1131514014F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:05:21 +0000 (UTC)
X-FDA: 83873815242.26.3C2D9EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2C98180021
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:05:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KRi+0Wwv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520319; a=rsa-sha256;
	cv=none;
	b=qAG5CZz7PUryC0vzObS5rzykL4FPFj/qqr1yZTPTaS7KfXbWRzwh48ljS+SaTYn6g5Vhrf
	ygUnib6ORIJkyggo0Fj95VHWiP84MXpy26gz7zzeg8UgTsA3Of/t0fSe0yEeGpm0vrwEy0
	UdxAjyt+J3EYG1g+CFvEqoCv3BiPMnQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KRi+0Wwv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8WHl/xIk0nqS5I1TpDNZJdY1fN/wk3GEsK4eg0cV/S8=;
	b=hOdZjUlUCXztOHBdHU527WKezQUbBPFcwRManwRCp8BCMkFBgvusB2oOXOb+XZkH53USJS
	/7t4e/5uS7OQs0o15XvxjagH+TQjWYNPg0fpyuikVDqfkRk+j7CX0COxKg+0L5WlWYCOwo
	ibWcq/vtju9nF2DOQ4eSH1H9hCsfcgw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAA4844B9A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949B4C19422
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757520317;
	bh=8WHl/xIk0nqS5I1TpDNZJdY1fN/wk3GEsK4eg0cV/S8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KRi+0WwvygaUhJCBEOTVhyTuslflCWp9uhW8xwngxKn4mR15CCCbVZ9yZzxDdo6zk
	 8NHXLh5/w7IIgQ866U0CKjI756prCvZaI0vgLNcgVJ0qiHqWngJ8mcWZBTu/tJwl0K
	 o9BbDPIJkkQaeCA6g1bPj0A8ZhY0SFd6IT9XaqBr1nIiamx6ib+XmS1595Sf8wK0Wu
	 Hk9SICmEjnaruuBrZbmHQzKiIXBfH7clKvEm4jpYM4Bgh54vpU4rzXI1Ng8XkcWLUD
	 Yah6wIHTD3kq7PzOUHWg/K0CfVgfM+ugDv5oUyVKIjBhfono0MaJbsJ/VuMfPJOYSo
	 r4xFFJ2g/C7Sg==
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45de2856648so78315e9.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:05:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVsQQjcJCu4k3+oaxM9JhLlCvNIo3fDlBxg7P23KBFHarebsT0HAOWT5GjN5c6VSQP+E1pAoTSq4w==@kvack.org
X-Gm-Message-State: AOJu0YyxORg2XKUHqD0/61BI7bgITl4PmIGthDVNZ3rQeE3UqaPfIB0N
	Ajmh/wNL9QBzQsYsKZ9qFBbQ3AJMo7aAByUcqTQVW1ai5gXj7tk44c3lWftWZmBJdDwgFCFs+tV
	Dticxn3aa7aRDBLMuyK6ShuM9qDgcwlSEgpVnS7px
X-Google-Smtp-Source: AGHT+IESOq3n3tIz+SwaQTKfvhmB5ATjB2l2io1gR8G1FJKmUxjLskCRKoulqMeYibuDjpYJTXNcvjM6lLzPh7yScNE=
X-Received: by 2002:a05:600c:12c9:b0:45d:cfca:a92d with SMTP id
 5b1f17b1804b1-45df74af1b6mr1417885e9.2.1757520316107; Wed, 10 Sep 2025
 09:05:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <fszpgct7ywqy6qq3qnjflol3theovmgnau2wgdqqdxin4q7ezm@zumgw533hxon>
 <CAJuCfpFaTj8PsXkoYRQKQ0sOu+mKikUAE8Wbcx+YpZXZ4M7cMA@mail.gmail.com> <b74b1e28-8479-4b14-9210-5b4334d3ce22@vivo.com>
In-Reply-To: <b74b1e28-8479-4b14-9210-5b4334d3ce22@vivo.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 10 Sep 2025 09:05:02 -0700
X-Gmail-Original-Message-ID: <CAF8kJuMJCHJwNtnPiBKz=OJg8L7m7MVWydWRoQMK1HpiFvLDpQ@mail.gmail.com>
X-Gm-Features: AS18NWAODLU4l_N1iDuC58AkueksUH14mA7pKjigM1COfFIYTDTArxE3zeEj-wg
Message-ID: <CAF8kJuMJCHJwNtnPiBKz=OJg8L7m7MVWydWRoQMK1HpiFvLDpQ@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Lei Liu <liulei.rjpt@vivo.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2C98180021
X-Stat-Signature: pk48uif9y8hgffer9fye646e53ormdn7
X-Rspam-User: 
X-HE-Tag: 1757520318-69739
X-HE-Meta: U2FsdGVkX1+R8vmkx55ejJNjulUsBRkZ+1K82E9yJx0CgJ5X3QL9jka+zYGjkGT5k/wRaje14NEmbDCoDgdN6IQwlRE0+Tysj0/HmhmZ08E4D/LMPSRtO/7fh4ycVY3ClwLAHIymQ62UaGnni7M6lsgOCUhlvnPxjE41LI6X+5cs3BpFEW1gmPGd7ToL5TOCkw2ovwOfnMPH+WWXgNVowAxrq6QgvjyAndzGpfSwhmW07AN5iSBE69+3LKfHqEkGrt9tnmnOIgE7Nr4Iqnpw5EfaGqTLMY+KD4ImX2u4FWIlAbBzD/4XKviMQ/7oLccmfI+DXIIS7XbDwr8lanaibF4CnJVGhzh/x0S96VOFREzDF4YSSzJxTYaoCCOACbxuYMZi82ZfAzDI1XlHlvMwsL23m5wX3AbKTe40lWrAg75yImMCvpeRvGaNGJmhSc35xw5CqBvg/gf60DCBRo2wfL3DPQvGbxp3jIw2V0NMzkq9midGQryQu7n+a8F29QFRK0pW7rXNDAj2lD3cnjXC6xirmeBbWO5FJLfAuiF251seEsvj1YeYaqleuLXxuN6TeY5VGNzffKVtKsXCx0ifr5VTU8zmWgCEM/bfoeEsfd0YyyajcYBs8PUIR6BwMSVB0gNRjsoZFM9cl1Qqb2Lv0KKVI7CUHqefwXxrhgcHaFATBBxcvHzuMoB2hW8V5dB/t4Hi7MkpezuiUbSJFXyi7f9ye2nl2DDcKa4F72BWVMlA6RsnsSt0OjP51ashqVRF2RLfG7AFMI52YOPrCvxiMSkDLGBAoSMXHaCn22oWFvbVMMm8dGoqlRjQJDhPgkUNYDKZjN2nClC9VCddJjPh9/80q6j6vW4kakKWbs2wrhfp3wJ3NN1fRq8se7aToxZ53HokP2jLyYJSB0MzO4ksgQGpZh0pLlEbzI6j0gmngz97ynes5bTy2bc+W/fqqnSFCIT7hBUfQbQVRrii6MJ
 Rt/JgA/l
 S4F1nHdzIu4kJUOGa1ki4dbZsHalDxuihm7A4YAvtmxIcVTZd7iwKBvEhkOyyW198OPVMyL1YMtk1CEhanWSBCJ7nafKsEherqAuCFfeOHs68zIciYikaON5Gbn4wChEDdPOj73rm1wSJyzUXrbiEVFg4EOTaffE5A5wjvPQXnD4jz1h9l6Ba7IuI20IuJmXgtMLtwwPLdharnEGPOhmjM9GbaJZhMyYSkfCjmJi6vY6RiUQVqiaLvVGZpPsjitaSXldH7loXNmwjgMOzb1Jxq19VJqWdsZij4H1HqMELihQKUSVFn4CdZ8hSj+nLSNZu0KhI83Fb7RwlHDc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 7:14=E2=80=AFAM Lei Liu <liulei.rjpt@vivo.com> wrot=
e:
> >> On Android, I suppose most of the memory is associated with single or
> >> small set of processes and parallelizing memory freeing would be
> >> challenging. BTW is LMKD using process_mrelease() to release the kille=
d
> >> process memory?
> > Yes, LMKD has a reaper thread which wakes up and calls
> > process_mrelease() after the main LMKD thread issued SIGKILL.
>
> Hi Suren
>
> our current issue is that after lmkd kills a process,|exit_mm|takes
> considerable time. The interface you provided might help quickly free
> memory, potentially allowing us to release some memory from processes
> before lmkd kills them. This could be a good idea.
>
> We will take your suggestion into consideration.

Hi Lei,

I do want to help your usage case. With my previous analysis of the
swap fault time breakdown. The amount of time it spends on batching
freeing the swap entry is not that much. Yes, it has a long tail, but
that is on a very small percentage of page faults. It shouldn't have
such a huge impact on the global average time.

https://services.google.com/fh/files/misc/zswap-breakdown.png
https://services.google.com/fh/files/misc/zswap-breakdown-detail.png

That is what I am trying to get to, the batch free of swap entry is
just the surface level. By itself it does not contribute much. Your
exit latency is largely a different issue.

However, the approach you take, (I briefly go over your patch) is to
add another batch layer for the swap entry free. Which impacts not
only the exit() path, it impacts other non exit() freeing of swap
entry as well. The swap entry is a resource best managed by the swap
allocator. The swap allocator knows best when it is the best place to
cache it vs freeing it under pressure. The extra batch of swap entry
free (before triggering the threshold) is just swap entry seating in
the batch queue. The allocator has no internal knowledge of this batch
behavior and it is interfering with the global view of swap entry
allocator. You need to address this before your patch can be
re-considered.

It feels like a CFO needs to do a company wide budget and revenue
projection. The sales department is having a side pocket account to
defer the revenue and sand bagging the sales number, which can
jeopardize the CFO's ability to budget and project . BTW, what I
describe is probably illegal for public companies. Kids, don't try
this at home.

I think you can do some of the following:
1) redo the test with the latest kernel which does not have the swap
slot caching batching any more. Report back what you got.
2) try out the process_mrelease().

Please share your findings, I am happy to work with you to address the
problem you encounter.

Chris

