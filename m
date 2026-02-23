Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3132EC1127
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 19:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA91E6B0005; Mon, 23 Feb 2026 14:39:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57236B0089; Mon, 23 Feb 2026 14:39:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38E66B008A; Mon, 23 Feb 2026 14:39:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF1876B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:39:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D8F41B5B3F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:39:43 +0000 (UTC)
X-FDA: 84476736246.29.8750916
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C2E614000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 19:39:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MJS3c3CP;
	spf=pass (imf26.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771875581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=67ebD5htsI6tjAjswLGtA5uaDjUqlsPp6plwpaEU6dc=;
	b=uw1vMd933ibyL6tHVW6tOmFz1coD8bHDlUqDSahXrge6hUa0ztHE4JbZ5CprwFCOU9V+e2
	1D3Hu3BKee6ZUCQ0kkN8pbqjTZllBexkr/tk/Bxnwc0AVF18i27u+3g9qYr96VBFakyYon
	Zj5ENZYV9eHPP+yRdaWmRMUoYFhGLs4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MJS3c3CP;
	spf=pass (imf26.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771875581; a=rsa-sha256;
	cv=none;
	b=vlaRYJSnNOXuynO2lGOtkyoI3nHTL/+w+OEn71HjLdBmneV5CqRWbwBsVRgnSSMa35leLo
	KYupoP7VGCoJCuGFLSWaMfkoM+1LoLYs9Sg7/ub+IFf+aTBgIiRjQ2OSinkcACQx3uktSz
	kIRvN+Gb1LlhJRKFxjgAsbFva7Q8CbQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771875580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=67ebD5htsI6tjAjswLGtA5uaDjUqlsPp6plwpaEU6dc=;
	b=MJS3c3CPHIGLssrQBUJq6kMDK3U+tvMIsU5El5N7e5+iIniMf7FKnzHNlxGYAVC46tBFWm
	6aQu8ORETCjUNrQf0PZMjFGudSVH1qIppHqihD2RjlwjDu9TDQQjt/tOiKfVZmozSQt9nn
	T4PQSgE5pNiFZ2m2cUYTpLOqn9TXfuc=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-611-NjCdlLZQO8K4o5pFfFhYcg-1; Mon, 23 Feb 2026 14:39:38 -0500
X-MC-Unique: NjCdlLZQO8K4o5pFfFhYcg-1
X-Mimecast-MFC-AGG-ID: NjCdlLZQO8K4o5pFfFhYcg_1771875578
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-89473f5a755so582760926d6.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:39:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771875578; x=1772480378;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=67ebD5htsI6tjAjswLGtA5uaDjUqlsPp6plwpaEU6dc=;
        b=pcZYdVCMPCLrElZcHFdlJ/EvVxKsX31UK/UxFZ7vMmSJ2N6pRhM5G9r/mOF938Jc7v
         Rj/zARJqXSqqzRIiRBSUALTlJRfIxdoU/dyPHaUf7XtGgcQzr1dSp0Hj5caQwflFcawe
         DBOqmBJJLXs/kLr+rZSif0Sgl3Crqe5n33hs+oaE5kBKTplSC+Y12swIM1KlkLz1SCIT
         srYzBq1AxgHMTBSRGtTk64X3yo7n7xD0RzvXXemsG0G6SRQa/MJoqcjVc5RTmgPAoKKU
         ILZMTHvId7F36Oq7ZpMLmQ4KTnJDK8T7Jj/YScy0m+ohkrntB8mCNZCkIq67qvdkru+C
         lcWw==
X-Forwarded-Encrypted: i=1; AJvYcCXyYTpNZT6ZJMyFjLuFuMcD0cRKqhcNNKhtc97C4O7HQy14C9mfA5h4Bn6IkEKjY942DXmZzEiWpA==@kvack.org
X-Gm-Message-State: AOJu0Yylz0dLmjFTXVg3Wy4QmIb54z0CN8sB0buBG20AWJTzoNMWhvse
	iPhlOGkAPiE7KhmwDQy61uqFGUTlihOI2CtLS4YPJOxm7YnnzYGUwxVRu7C2X/1ZD8sp7m0KnvV
	uVZvVa4W4hdnMGekHQcCzyGk1NybstyLrts51+X2pN6pfhxW/W2am
X-Gm-Gg: ATEYQzypvT9piJQXc8/lmXvNPxDlPW3L+i2R7o+eCW6/lcJCc0/XZsnfp2INPsSlhcq
	M5Ieh6y5ddts8mgWqDA4xEeXmVMrlfMx28cJhZysDD+Ig3Otskbl0cvhrvnTuaO2lCq5+yHA8Hf
	J3dvqfvq95tUio5C/UL7AoAA7gyvGeSsZoVWX33BFgdqe9nMYXGGlrJHwuU6RUNMM9WQiKn+Z33
	G6HrNPdG+Q9mm6NCGWIMBJm8TCwB2iIPslc4NrYwgYNmbyDVolPCrzc7cXPDj8QCTqt1/yTGh8/
	1VQHtKOT4bkkVx2hkwNsg/QucwdPzmYGXO3JpElx4f/lkva/HnbkVhwEVABkC7FMG6p7yMggbnx
	Crf+2XHe+NbR+JHI29i1fhGTyaLuL7GAR+RGB8qfofxXqnnn0iriR+vw1YWoc0jM=
X-Received: by 2002:ad4:5e8d:0:b0:897:306d:98be with SMTP id 6a1803df08f44-89979efc4a9mr154810676d6.55.1771875578029;
        Mon, 23 Feb 2026 11:39:38 -0800 (PST)
X-Received: by 2002:ad4:5e8d:0:b0:897:306d:98be with SMTP id 6a1803df08f44-89979efc4a9mr154810126d6.55.1771875577480;
        Mon, 23 Feb 2026 11:39:37 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d544cb8sm74614481cf.12.2026.02.23.11.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 11:39:35 -0800 (PST)
Date: Mon, 23 Feb 2026 14:39:34 -0500
From: Eric Chanudet <echanude@redhat.com>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: "T.J. Mercier" <tjmercier@google.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, linux-mm@kvack.org, 
	Maxime Ripard <mripard@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
Message-ID: <aZoHfloupKvF2oSu@fedora>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
 <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com>
MIME-Version: 1.0
In-Reply-To: <a446b598-5041-450b-aaa9-3c39a09ff6a0@amd.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: L6V3CYxZvvW8vwOBGuYMz_82rH31gFPD2V7UzhogKeg_1771875578
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7jyhy17m7bzy19oycrtywcsec7s391j9
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C2E614000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771875580-510667
X-HE-Meta: U2FsdGVkX18+x19NFVyMPN4gtltyaH8AI4I8o22RoQERa1mF6akgV8OLGeSkj0qKALcpbKc7CbKs02niIwl2fPPFQeO3UVWpdlD9K3HBdCXOAV2gKAwtaRDh1T1BJLWiE1b47gsJtj4Jv7MA4yAiBpzoOKOei5o2P0Jts4F3FjQ7S59zV6tWdlFZDrmUQvVK7zvNmbur/8OhbEIDLFx/ajzj4CLBt2kyP1/z7SNWYr8CQelxH0PYKvWQcwdr1YGdKaKVAm1mUoQFeGYnCDZasTK9egBrH4r2AldndlSO5KsLLaqyahj5cXftkq2BW80Vg9P0zCS3/rQo/Rsm3NPJRE9Jlqe2Zql72TiyWdRTs406nT8yH+rU/Mns/hh3E8Kx6W5h7QD9HqnPLW6cTEc1AWYcyjwimReIwuQkKpE529suu9QMTDpMSMM7T05PDo66vjVdf5TTsMzQWgoCp2r/ix9qY7nTkCf0mnZTVIRK/7n60+DfylmCkMIn2hW++D9nvgFA0dTaAvExAdkRVxurvCU86sH2ou6YFZR50KEVooHPtIYBZj99o4e9d536xghyw5RrS91uDHCwCT8JxXMdyI/0CXRKp2f/luYI4yI8Sdmt6TQrHyVr+5f3hI/fII0V7SF+AsNjkFkaUCWAaB/Kr16LlDAfYbP/ZWyVuL4wuLbm9Qwi2b0HZR0BHhHAko+CO/gEL4ntTZo76JK1X96jbBQTyhG6Wisq1ayD+eJxZIclbXW5UwYhMDgUgnFyYPA7mqX91jyfYvpLas9lheu4VJphOtztOhfGkUnCxkuLA12GkbEVXEIEPePXjqgn/47EcEpbwNelxzsqDoQDzNHA52dqfnrOkExfmGD9qK6QCf15aYdF09C/bVBQl0nQXLRtjW/oTS04wjHukm3CkEQ+bdeOEPtb7xL+Z+GkuawNRsIOFn4fZSr57nGQ56GzZe6qogsrkv8O/jh73Yu3yl/
 2dDNs5ES
 sEUAvP1fGXclE2cWljWpci//RwG7hIgA51jf9whpDLkvdVsntHtIANQP5mPOZzkqnSgKADvfd1wSydDYhjNzwmCPY/V1aq2PIaNEJn8NvVVX87jhHAfiQ+PEZYBZS5Dn/HQRHsZaDlzlCI3uqPL4yLH3ZHqcQFO3pYZeop7oE23KgvktDqOzTN4G5ao5Pv5XaeW1YlQOzFG06m7uYdrAgbpxWSu8p9F9ZLNGsCQ3Ku4ul+wLgd7FRAGGt/m0sunKktk2MNrpvb6omzj+w8YMz+QzX3cCvNmnLOuEKI5Ov6w81PZUhWbLy+mwghf1pHrmXHLW3WzZwagoX7M9vJn0U2fmiy8lMn8UrorWeiyg8cedXqaOawuo2JXNDjwpRjXZApStckuSAsB5fxssvY5tq4wpO3ttfSPo2iZJ5/GY/m63/OwNTJt/GTJ5zV5gQIz0KV3HvQDUSfLz/q2734TYmwtPG0tRylhJF86lHOC/dWIsv5j4xBWj65MiiS7pcT8uJyepwrKAE14frAtfVCJmDTn5ji6Tmp/IomfsH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 20, 2026 at 10:45:08AM +0100, Christian König wrote:
> On 2/20/26 02:14, T.J. Mercier wrote:
> > On Wed, Feb 18, 2026 at 9:15 AM Eric Chanudet <echanude@redhat.com> wrote:
> > 
> > Hi Eric,
> > 
> >> An earlier series[1] from Maxime introduced dmem to the cma allocator in
> >> an attempt to use it generally for dma-buf. Restart from there and apply
> >> the charge in the narrower context of the CMA dma-buf heap instead.
> >>
> >> In line with introducing cgroup to the system heap[2], this behavior is
> >> enabled based on dma_heap.mem_accounting, disabled by default.
> >>
> >> dmem is chosen for CMA heaps as it allows limits to be set for each
> >> region backing each heap. The charge is only put in the dma-buf heap for
> >> now as it guaranties it can be accounted against a userspace process
> >> that requested the allocation.
> > 
> > But CMA memory is system memory, and regular (non-CMA) movable
> > allocations can occur out of these CMA areas. So this splits system
> > memory accounting between memcg (from [2]) and dmem. If I want to put
> > a limit on system memory use I have to adjust multiple limits (memcg +
> > dmems) and know how to divide the total between them all.
> > 
> > How do you envision using this combination of different controllers?

We are trying to control each CMA heap use of their CMA regions.

Regular allocation would be migrated out should CMA allocation require
some space already taken in the region (bare, I suppose, if these end up
pinned...) so I didn't think it needed to account for these in dmem.

As for accounting for CMA allocations in memcg, I suppose that's the
question prior discussions explored as well.

> Yeah we have this problem pretty much everywhere.
> 
> There are both use cases where you want to account device allocations to memcg and when you don't want that.
> 
> From what I know at the moment it would be best if the administrator could say for each dmem if it should account additionally to memcg or not.
> 
> Using module parameters to enable/disable it globally is just a workaround as far as I can see.
> 

So, for example, adding a dmem knob so one can:
echo "cma/reserved $SIZE" > /sys/fs/cgroup/user.slice/dmem.max
echo "cma/reserved 1" > /sys/fs/cgroup/user.slice/dmem.charge_memcg

I'll take a look.

> Regards,
> Christian.
> 
> > 
> > Thanks,
> > T.J.
> > 
> >> [1] https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@kernel.org/
> >> [2] https://lore.kernel.org/all/20260116-dmabuf-heap-system-memcg-v3-0-ecc6b62cc446@redhat.com/
> >>
> >> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> >> ---
> >> Changes in v2:
> >> - Rebase on Maxime's introduction of dmem to the cma allocator:
> >>   https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@kernel.org/
> >> - Remove the dmem region registration from the cma dma-buf heap
> >> - Remove the misplaced logic for the default region.
> >> - Link to v1: https://lore.kernel.org/r/20260130-dmabuf-heap-cma-dmem-v1-1-3647ea993e99@redhat.com
> >>
> >> ---
> >> Eric Chanudet (1):
> >>       dma-buf: heaps: cma: charge each cma heap's dmem
> >>
> >> Maxime Ripard (2):
> >>       cma: Register dmem region for each cma region
> >>       cma: Provide accessor to cma dmem region
> >>
> >>  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
> >>  include/linux/cma.h              |  9 +++++++++
> >>  mm/cma.c                         | 20 +++++++++++++++++++-
> >>  mm/cma.h                         |  3 +++
> >>  4 files changed, 45 insertions(+), 2 deletions(-)
> >> ---
> >> base-commit: 948e195dfaa56e48eabda591f97630502ff7e27e
> >> change-id: 20260128-dmabuf-heap-cma-dmem-f4120a2df4a8
> >>
> >> Best regards,
> >> --
> >> Eric Chanudet <echanude@redhat.com>
> >>
> 

-- 
Eric Chanudet


