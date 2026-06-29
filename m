Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B8C2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 21:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009226B00E4; Mon, 29 Jun 2026 17:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFC8B6B00E7; Mon, 29 Jun 2026 17:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEE2B6B00EA; Mon, 29 Jun 2026 17:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC8476B00E4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 17:18:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0E031140177
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:18:27 +0000 (UTC)
X-FDA: 84934213854.22.2CAD3F6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B41EC000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:18:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YNzhWpIj;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782767904;
	b=N4sVmCnD+4RXDRAFOZkdeb2E+EoVvXNh5Po0h1T8MFLdiL+G47tyCTT+D+V7Du7r9FaBdl
	Lgem5QwEzZx+z1wsJ9Vlw6Q8mteo/IUnnqqkf866UPFOAZWHEz86e6FTnfSR4wVo24N8XB
	YkuUrwxsN89WZ8G6J6BMFa6T5Yw+fxE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782767904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzdqyZy9DNYqylcD+hVN5qW7Qehzih+rIpwh8CvpRNI=;
	b=sKRz0LVMxpiSUxkqQnvsGEEYlRJtY5D1vh6zwz5pzf/xO1pbxDMOKzQldoAxAnBSys/hTX
	JgHG1x3yhwXzkAa7z+xsa5XcVMdDUdpjRLn+d4I4GU3yLe9Dmj5l5zxR1NIh9TLsvF2np4
	gcTxQ7ESUa+G75dLzpHwRuuQQhMNzP0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YNzhWpIj;
	spf=pass (imf22.hostedemail.com: domain of mst@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782767904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bzdqyZy9DNYqylcD+hVN5qW7Qehzih+rIpwh8CvpRNI=;
	b=YNzhWpIjCUz0mAUtYzsuIMRj9QY717MXtg1G6z3p3Uu/g+KbRp0XGMRSgHxLBNEmNdfhTS
	vr+J7E9mPDBFFm2pFjbHzigzB5Oh7t7a2Lg1qspeIjnpB0WMl/5CWMmT4928C8u4stvUvc
	r7WIGr39aK/rV9qCRdA3U05lWnwUHDQ=
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com
 [74.125.82.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-_c6RVRbKMrCBr5hlULhUYw-1; Mon, 29 Jun 2026 17:18:22 -0400
X-MC-Unique: _c6RVRbKMrCBr5hlULhUYw-1
X-Mimecast-MFC-AGG-ID: _c6RVRbKMrCBr5hlULhUYw_1782767901
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30c0d568830so16487903eec.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:18:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782767901; x=1783372701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bzdqyZy9DNYqylcD+hVN5qW7Qehzih+rIpwh8CvpRNI=;
        b=s3OQHRZU601uK3cP4TX9Sc9VEtF2lQSNpWAfr8E+uABF+SxK+tjBdVMYcqUfSSGdBZ
         dKK5MJYZew+GQ2+UcZx5TAnu5ryS0hBRHikJyltH5dqaXQw8miBI+B6YKCkwCgJ1827Q
         Br6gzkyuVwFvLmekgULJBqTMCQvh0tHjkFS6aO5/Gxf/g8/j5ACXedFlv3nli2FMHqgE
         txYIgrp/qrR3maZs+cPWS4qz3/6KtfyTfi8AlDMggzsljBFcIKSzIYF8v1guSlMIUE0d
         fxYg7F9MquCe3ghLXpOpmipVYlD6AmitowhFG/avlB74r+1qxBkV6sjOmjE+RRGtfPO/
         d5oQ==
X-Forwarded-Encrypted: i=1; AHgh+RoEOd43qYaUT0+IoARtOjf8crFd860sfvgiKK8WcxIcWBUrH/d/064sR+TLNR4PITra2wRiERBv7g==@kvack.org
X-Gm-Message-State: AOJu0YxyGDF9TBq9JSqQso2FxYWEOS6/Be0hX/AJTStGatv8wV5OH6fI
	SjXWZ8tlnUBCeDtF+YaQWFIotn6MKHJFJ4chLng1R57UWtZdwy9ohx4eN/zacAJZI8RtEdIa7bM
	YKox9nxc8jKDXNKRzdl3ZJHqI3pCrEhl1JJmj+70kDvoIDGKtVsP7
X-Gm-Gg: AfdE7clH8pU9EWYqkqI9UN8RVL/2nMm1h2JovIK20kJH2toxzo4dYkI6Enp0S3BBB1n
	kGKdtTHwkFj6TBNu4+HLp4DEfpL/o75BiY/zwDg0R9EGOoT0OFfVyrBCDzwO9jxZGckOpmGK+dV
	zAE39YN4rRnxvanS3/imBehQUpsamaC2cjqNX1VXWcjAExS3ivQ0nqNGtyJoSAoSHoKDfOMX/Q5
	X5jfjecwE4kIvc2a7Jj+rzLltxVzx4qIwKSOwPqvpujOMXst5qTh+2QWRrqKYHj3hqofmL+ftKq
	hRJg/XeHItPE/dJ8w/I07Kky2coOUC0rGUN52F6iuyaoJ/uQk2ObIt28Udi35F8zPW5/JLf1/W9
	vgvpRK0rtAhsW0/BdPKJxyvGPCeuY0jIs
X-Received: by 2002:a05:7300:8b22:b0:30b:9b64:4a3e with SMTP id 5a478bee46e88-30ee121a822mr831099eec.1.1782767900930;
        Mon, 29 Jun 2026 14:18:20 -0700 (PDT)
X-Received: by 2002:a05:7300:8b22:b0:30b:9b64:4a3e with SMTP id 5a478bee46e88-30ee121a822mr831042eec.1.1782767899621;
        Mon, 29 Jun 2026 14:18:19 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-85-71.inter.net.il. [80.230.85.71])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30ee2f5ed29sm1122815eec.1.2026.06.29.14.18.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 14:18:19 -0700 (PDT)
Date: Mon, 29 Jun 2026 17:17:55 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
	Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>, Byungchul Park <byungchul@sk.com>,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
Message-ID: <20260629171727-mutt-send-email-mst@kernel.org>
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <akLb3WW1nJBaIBwc@firstfloor.org>
MIME-Version: 1.0
In-Reply-To: <akLb3WW1nJBaIBwc@firstfloor.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Z6PcwtD4Wn9OoQ1kvarDybsu3egh2qCFVc4wpoxKIS0_1782767901
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 9B41EC000C
X-Stat-Signature: zkd8f874puskq46rjijh9ow8h4ez7e33
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782767904-333881
X-HE-Meta: U2FsdGVkX1/0lCAZCblBdNT4JrjdyBESZhMbUaOvFXHdJE4iCcArhOR0VvLh/X4ShCNUL/3UqUgSQUXxRbxUG4joxI7ipSpKvHUMixIG3NYp7r95tRPGT59xulfsc8VnstZPqLSoCh0OSLhjFcuhhq2rd8Q5dXCy2cWNRQa5YoDEdMRZZ4jANwuAWD9WuPfAE+TkPJU0rGRMO5hFR/4gB/dpFMWiOj5UYlrkhnd2r28AfqiyUo0MSDYer7E5VeHnHcDLw0/hY8aIJJPIZKjxmKSnHudSqoB1jrwEkZ5/VfoRLRXiGPYJNIMxmwDZBRIwY/PBK7W6O/9w7uJXZdnp5Qw92SZE65x6Yk+GAVfEzOvfz3yt1EIZUWIL4ZVvW+Hzmx2PFwj2PSEfvRJuQvRYzvGp7rrJSWNHps9ifPMvaplTqyH07J91W1yT95YbFNhY2qGaJEw9qvzo3/lhd+INMV9g64GOFC727RHifi058uZWXpxNBvRB/vlct4CfDT9uFsgqvN9ffbWWhlz90A/mzwapatlKNl3QP5IShIydb4PMJ1Bd77lZNt7qThKPiIdNkUCTs/cWd38oL8fTeUIgYPIKpmM6byOfiDEh5XAW0wR52zRQDsyxFjgxkz7ohrhngLB4hpx7McymraveU0JCOSgmmuPsljlNG9MCCi69y57TEiEtRwsQ9/KmKicsty+ymHjs414dc+Pxl/jTCxeqB3xLeoTvjjXuyX526j8F8CpwRj6PYat8PQpYkiYMdsRajXAekAXI2rS4tqqzQqsTQZKMMV04AwgKPN6ptJSvoRSWb3hIhxR8ML6imL/LWu4PPwMBdxmBwLRiyFofn71qCmOiPucnHx9lXPUPlPfo3tVGygo2ZiHyUQYh/6B/nZyNuMJ7dSGPkjp3nLE+vvOeSvXSUnJdaqx9Xx7ScKZ3Rn94gPb2K5ACAGj+x/orYnpMucqSZC9tGMR17XtKRxs
 SAUQZuhh
 BofLCnULMbZCiPo1ODWg+TKPvCzkvfBLhebbm/nFbUpsKW1nlmmujuJLtboygqqzR7ZiDLLKgpW4YEnvBBqM9Lmz1mKY3a9h+no/glkDPyLgfm0ZOTQprwmpfZp4UrDPKVxou853t2AkMy/ZoWpUBv4EOkctjTVc3kZ7sOFL9eqaD2yvQ/u99Qk5mxtSszo+1RhNRC8Jz/bbYx8cs5v2HOUGzl8gtVsiifmVo3EI3iUVzyvahChe02heC5Ulhgv6s0Jolm40kth8sohOn0HjjVJ/foWYumT2uYIUuNMpK6oZpLcFk+9qM3eYiyzecZgRMTfvYcuAL7sY7qp6TNjY1wlAhmGnc/A6P9Sy1ueXPcRhWtlJKXcm3R+9O/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 01:55:57PM -0700, Andi Kleen wrote:
> > > Or if there are actually more performant alternatives that we could use. (I
> > > still doubt that using atomics is ok in general)
> > 
> > Right now I'm thinking of looking at something like stop_machine maybe.
> 
> There can be (rare) cases where yoy get a lot of memory errors in a
> flood. While memory-failure doesn't need to be particularly optimized,
> it shouldn't be excessively slow or impact the rest of the machine.
> 
> stop_machine is a big hammer that is likely to violate most of this.
> 
> -Andi

We can maybe batch a bunch of these, and do stop machine once?

-- 
MST


