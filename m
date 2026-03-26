Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2527E10AB81D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 20:30:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B93846B0005; Thu, 26 Mar 2026 16:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D9B6B0089; Thu, 26 Mar 2026 16:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5336B008A; Thu, 26 Mar 2026 16:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 894716B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 16:30:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 204DE1A0DB8
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:30:52 +0000 (UTC)
X-FDA: 84589357944.13.741378B
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 43FFA1C000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:30:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="kO6Tv/uJ";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774557050; a=rsa-sha256;
	cv=none;
	b=D+tUFoe7oi4oDrXYMjeyRkB2bGLQMMWTyQbrQR94fc25uSJXBm45DUPaHHLak5u2Eg3OBt
	Tfu/GcytEWlPD6W0JXtxa41C4b5H0qQ6IXjMCvk3ZCNGpD4JhE8u0QnVSccagxmqFt4Hwv
	K3hZNnoBoh/6M611R0eXu14PCOeOHOQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="kO6Tv/uJ";
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774557050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtpETcl3yk6gc9JzFTgqg++pyqjs/XxnbLkYQgCVFgc=;
	b=MimT1aXJEFkWRxycPYZtD6r6LsdFQEYUCzL8c05ISEoEkhD5Daf/BP7faQL36MpLROyPve
	N6QvZejopX0YAYyPRPQHGvV6ORgFAA5A7yOA9zz68B92/pmQU7qudRs1MiRXLyDaf8xL5V
	sv+gUfwP4J7ttaNhRtEt/DgAuFyr8wM=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cd7ecedf2cso158269685a.3
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774557049; x=1775161849; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gtpETcl3yk6gc9JzFTgqg++pyqjs/XxnbLkYQgCVFgc=;
        b=kO6Tv/uJHa1X8w+giporYtKImqIseUSUA+3ZEDAVjFv2jq27RWaPYVmci7IJ2nlPqO
         5CgZs0mfkZJw60hsm7lBOECOYaKZyDNUN/lRlxscRqj2e5BIkDdqh/sjC3TPG7OsHqgr
         3NTEMYRJ+K9EJocWtvHtk4AUL/7sJHUHM2U8/uZNdfbqgfY0WzQyKQpnJupuW7/feAp7
         fTzGnQxNjjLt+lk1wl7hAj+b1rwISHau8frgoA8hJLmBv4gX/+R6iLuT7e853wHWCRgv
         Xn+uHjATNf4i70syBvTH++/8NZxDc98bOeuxqZ6SQzuWOH0zrAs3EwJus/psl05V8BTI
         pY2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774557049; x=1775161849;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gtpETcl3yk6gc9JzFTgqg++pyqjs/XxnbLkYQgCVFgc=;
        b=CcxY8uKGXxb1DU75H9Ak5ce2UwUakWbM3ThUAQ9PYKEJ+20kF4M32z1cF3tJDIQdUk
         EvSE4uyMaR5no2Z24cUIj3yzMheNmODwILXoHAHZL3+Zp8ZK6+NYSeU8vMnveiXkVE0T
         nuoni6Ts/pT7oQPZbtIMR9kLU2qcGXJt0s62g3lufhVC2TWChodcxwLBGveI0xFfAEB9
         98mRXojSLBM4KKs2lA8/QVH6rYmIupF7vjvBzruZtFxcEW16UGGgc7SKOIJ0dtj5dIPz
         ZIvkQdoKLvNzdFww/YAh8Pw+MZQ+O0wmJrakHARXgtCZiOpo19QH42Xu1/i/u3ufIkbN
         xjHw==
X-Forwarded-Encrypted: i=1; AJvYcCUQqGO8aEW9vJ7gnDF5+3G62zbji9dWMqr9ydQf1c+M4Jd9X22Z4Q9N63gzcR0Wh6YHJHrJo7nN5A==@kvack.org
X-Gm-Message-State: AOJu0Ywfcfsl0ELn1rixjN96LzbkaiLec7j3etn/UpZvRlOqtIe/4JhO
	bz1wbbrHj5rXgevXI1vx7TTLMFf4A/BdRbASSYqm9hN0FUgMLG7Gdc9Yj83WhUgH6zA=
X-Gm-Gg: ATEYQzwSTaxr5NzPecr0zqgzcvzSjm2QOUXzpG2rZKUG6xaWjqFCf1yRXrIICrxEj8j
	TJVF5enLCLX/ELCZzXjKOeubgsBQc4KrgaH28E3gxetlzuxYfzso6995IhXm1fv9vXTs/h4bZ9B
	XeHNOCYv+ixiDaM6jrNPACyXYtH5i4FbWi+MJ9ROP88oiXiweKC+iA+yCb7djE18hO+htVX85jD
	jeB8M2ROfm4xxxTtNqrKOADz7HAswpzlcUzHDGvFxOcIQrqCegXEyypr/F3JKJguhq81HPCooWf
	bVoTqoPx1sZgfW/12GQfh1Uq/ozlkgSmyt4ZzV5y/qP2E2LjghvIndSKmByNuSM1DSiTap8ScCv
	mrdq01pvu/mfvjmkadkTubDb6q9uFNusDhgZP8Slz9qD84RX/nPFTI4R0rvM0jIsZ74b/BXytXS
	VGzZmwdtNngMiLzF5/Wd0o
X-Received: by 2002:a05:620a:198c:b0:8cf:d804:4567 with SMTP id af79cd13be357-8d000f20fcfmr1253345285a.23.1774557049133;
        Thu, 26 Mar 2026 13:30:49 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2620:10d:c091:500::2:e5e8])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8d00e4ca250sm323370585a.25.2026.03.26.13.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 13:30:48 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:30:46 -0500
From: Gregory Price <gourry@gourry.net>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	lsf-pc@lists.linux-foundation.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kairui Song <ryncsn@gmail.com>,
	Matthew Wilcox <willy@infradead.org>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
	Vernon Yang <vernon2gm@gmail.com>,
	David Rientjes <rientjes@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	wangzicheng <wangzicheng@honor.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory Reclaim
 (reclaim_ext)
Message-ID: <acWXdvHx9mYqvT2w@gourry-fedora-PF4VCD3F>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
X-Stat-Signature: 6438bgq8jkoeeusti7oanog8qq9cez7c
X-Rspamd-Queue-Id: 43FFA1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774557050-874635
X-HE-Meta: U2FsdGVkX1+ifVv8Vtg35UdFwEbZeBlV6k+dKZJ9AG841/MSio/GoDS/bjrsnGGO+pxVrNBsS43xuHRJNN99hkNlGH/i3W2lhZ4Wt9J2HCYOfnWMzgIt3I9VHTJgnsF4Q2tkX7RZgpR5HirGHKvFOY3rBfMYaWzYMF+jaYjzM4lymfGncB5tIsKLTKvJP4W5KmoX65Ho+rNUhUWXo1DSS7hSCNy39smk8kQTza5eH92qhmfU2zFy82DR1tUl4ZvTQZRwYbX182x2Mt2KTzoENZOo5GJ4CRf863U++cknsvFhmw5RNvebgGeB0PKOQIVKbKg0L+MGZ+QoBqvenHjK4YBsJS/99enJ+EerFQAW6Efc9m2uvelVbGBgft9iO44NkjMX47+1taPGaJUHMrX9L/dTo1ub46QD7GHOieogRUDfXaWCyharFW+LJn0YNADW34Z+loODCFh9JQ4iiOI4T+4RijT5blq74L+Bn2dE9aT19953t/MbuQ9oea3a4+2dQmV4+qN0BoFhyeJTvJrtJI4iDNMKnH9MNYuaRhP59D5Lyk8c/NZj81PEsmthnQGc2T7sjYEqOT8XlzYQBd0GIbooiNxYbdmF2fp4QHJmxZN7vnT6bRdmfvt0+RQJIwzU8GEAvWa0S/q6dd00jhnEb9ljNl45dQy114uTsOQf5xeqacXF42+qnqYgmVyn6RKCm7MXO2gs257uqsE37yaTT0VGLI5CifdIgvrWhN9WL7xmXFi5eLtZY4vtgTuSAUSNRa4sEeMXAAMf6kGGV8uPqSCCZXzVJ8oaBbQGRSXvejh629OP9AYb6aqj/zrMjP/K+WrygKuFxB0kwj6psL53xlFx8zJsBBfG3UMMPz9cDXl1bdHZSd2PAeaw7xRDuJIcyHLsN0OxVsQJpo9roR4im26PE4lLMGfvMB2ViCLpewYpdhU/C55VkhKpvDjqSKu82UguFhYlY1SWBeaQKqh
 LzR03GTG
 +u1Wnvt8vLcY7cbiGVETTtC7N4l7p42Ish1yz676TF/aGwCDnPCXJHjnJea8BQuiTw5ktGboMfom5h9Qmoya2KWQlQayeiYexIWNcqLM2Sjlet7xYCI81eI0Y2xCczlsgMqha2777ce7zJvSDa5+kn6yFMerDYtmQAmmb4Krv4xFV4mxg7GDAdcZH5v/TKPL5sSCQcJlMsoUywf4dEu+O1Q4JMTJgzVED+oTr+JZoABPfFDRIP5Ezxj/DCkd5Yvg/rCQYN4DlU05b9PYnEtlY/3wRxlH2xIPsSQ6PXb6VZHUAABmviJTYd+yfiUfuGOGzMzd+2XQb/qfXOzKD9PQm/51oriBc9pPS8PyvweG1NyywYUHiYfjhualZYT5iO2GasR21LLVZW0n1awaOJkDpMYAX2Tk+VPQdrttJ2+CO+E0ay56w13S0CVc8yxBifONrUjgVccTws0javwhh+3i0V/TeD/mj8xzBxVbDgyWZzvzFI12+FmT2N96iso6pZpDEzk5o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 01:02:02PM -0700, Axel Rasmussen wrote:
> 
> I think one thing we all agree on at least is, long term, there isn't
> really a good argument for having > 1 LRU implementation. E.g., we
> don't believe there are just irreconcilable differences, where one
> impl is better for some workloads, and another is better for others,
> and there is no way the two can be converged.
>

I absolutely believe there are irreconcilable differences - but not in
the sense that one is better or worse, but in the sense that features
from one cannot work in the other.

> - My sense is MGLRU is "close", meaning as Kairui said in "average"
> cases it is substantially better, and the gaps are both fairly narrow
> / edge-casey, and very solveable.
> 

This is a really, really bold claim.  So much of this is workload
dependent, and LRU has decades of battle-testing while MGLRU has barely
been around 4 years.

~Gregory

