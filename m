Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3C0C88E75
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 07:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014BF6B00A3; Fri, 18 Sep 2026 03:08:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32A66B00A4; Fri, 18 Sep 2026 03:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E439D6B00A5; Fri, 18 Sep 2026 03:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFD286B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:08:47 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E95D01602F1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:08:46 +0000 (UTC)
X-FDA: 85226005452.20.80D7446
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4522C1C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:08:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Awku+uV8;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789715325;
	b=Yhix3FbGaaMW1n0IOO+bb6YOJtlMRJy2PA5OuVISVzH1GgkOSWpi+km8rmlDm6zs5KxLjA
	Z8EGnZjyQ6tl9JaAubK1+WV504jdGYoBTfWWFxG7K1hy8l8KPWp72GX0c13+w5PH2+yarP
	DZJkRB/Q2LjVqHnkGixJOPzgzKuw8Xo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Awku+uV8;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789715325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCL4dePjhuTX+CGE5tvS1dbBZl4n5dA5dLQyhLK3zT8=;
	b=u66x5tkcS4SvbbGWRm+WJDdzr7dswNjdnK9HZZmuM30NY1XERTqQhc8VuKoV+o9R16h1iN
	qhvvztrNS5mawiO0d2B4Gwm/cA1eW0QCqiCsL43wcHvroDGhYehqnLRkZfvvDtRBwOLQ1x
	iBkmGuwx4MvuQPHzKM6FCLdziwBGj1c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C1C3D60A59;
	Fri, 18 Sep 2026 07:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E9E1F000FF;
	Fri, 18 Sep 2026 07:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789715324;
	bh=WCL4dePjhuTX+CGE5tvS1dbBZl4n5dA5dLQyhLK3zT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Awku+uV8pxJg2xgDDCtl5/l75ccjfY+SVllzMvrfHWYiQtLqHtEiXmIY92vIOOLqA
	 sw+p8lDtPlpSpOCo6STc40T4j4ymvTQ8miSZNMQeBBBm5EA7WucrIMgYeH8wuuM/DG
	 +BfgFttLkbWWOmkrZgLyIIMf/YZnzRxDgoxY8eXn76fo0NBew4JbrSvc+cRNfaFiAl
	 QkEWcPh0v2r3CBUEUYOst7UeoaOyYdLc4pb1uRmVVT2l0puoiHyRr+BB00fdwvDOte
	 zMTrahakOeCUcuHDF8D2CjLZFngzAzI+3HVShn15UKErn1OlTsiT38Xn3cVrzIAtYv
	 8z5PR0qB8xmPA==
Message-ID: <8705aa4f-5e02-45e7-ad45-0baa982a8c02@kernel.org>
Date: Fri, 18 Sep 2026 09:08:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SLUB] nfs_page cmpxchg_double_fail and perf lock perturbation on
 dual-socket NFS/RDMA
Content-Language: en-US
To: Tim Menninger <tmenninger@everpuredata.com>, Harry Yoo <harry@kernel.org>
Cc: linux-mm@kvack.org, Chuck Lever <cel@kernel.org>,
 linux-nfs@vger.kernel.org, Jon Curley <jcurley@everpuredata.com>,
 Eric Badger <ebadger@everpuredata.com>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark
 <james.clark@linaro.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <aqvy8NqRRRmUlxjR@thinkstation>
 <20260917162533.600472-1-tmenninger@everpuredata.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260917162533.600472-1-tmenninger@everpuredata.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4522C1C0003
X-Stat-Signature: z7dotsmiarit6zzdfdntxp1mh8f4f9qn
X-Rspam-User: 
X-HE-Tag: 1789715325-942635
X-HE-Meta: U2FsdGVkX1+4GlzKaOJvXYX/RAPK716qV4/eprm+lBJPtbHu8LbHgonG2qKyGxuhWex1ZnRGjHOAA1klevvzB3M32RSKynBTR6xpuhAk6KtMFWSNOtiiDHYlLRxAcS3kGMQBcS749wpBSua6TqHB1Bqp5xBrD224qSCgOn3s/ZNbv6wvFlK7G32WgxTeQ7g1pOwuKbdr9Y6kTeI1y1tVtSb/6CWUv91tma9G+0kX/5L8HTAj7FcVnpKCx3nDVEwdDMxVR78GO7ROQuD8IVTWuJIC0gRX+GY23ag9UqCNDVaznJubHbFW2uc5kJnT06CvU4oafR7afydKQWODUfqrkozvPqda3/S2/yI2456aHpIKisCx1OntgUpUNckl0L5QqEXXVO8gDgM5CnLnoUS7TFwunscB2IqZ3nQADNq1+xo/hCZQTG4nrQ+f9DQIjAg+MMunan7OKot7cVpsFTBRCXeWc7uQyxfWFqgOUiLkU6CsrfRSRDmoi0UwX4UMI+g/scTdF+r3sw7nrzwY1fN/wFUKdn8FOvkSAr6hEHVAsJYrcCvRf5MYgJE6XXFsMheQfmDh8IOKq/Pfrfo3UlNmP6lu+GNQ3sqPTM+T4m6anUSJllIUjPISni2PAHoIpmAGSMuBhWC8MWLsFU4hvuNb/D1vqeHUz27xBQO8QybFhXllpiLEc4j+NHo6TCSctnv2WSUAm2qhykT0T7qgz/KKi4DhBh405e3C/PchFRXy2PF5jNVqqNGtpWG2WqCQGFXV2JbfRSomGGkVYFzLcEGpjj154ulpgYmBLg3vmhmO1ex7oPNM+Qh2AO3pxleHbnABnA7B7h1PDdiNIxpOOq1yQA05SxIdlmp70m+ILq5kUw8tF+whWp18ZalTKGLC1PYcDqfAJ+nai6g34YqDZkI11JUCzwMAEECbnJMr+hJf+FVOv59iN8TmRH2H69d39k16uuN/Q/1xbI6HJpq7zen
 TjYlpYmz
 MvbRlkuBYiOQpXgK6IHQDimgXBjBQ02K2ks8zY/gYLq9F9mCFGcQMflW0V74ToHUNI7fBkoIJf3r6OyzeG9geM06sNKRlMe3OC7gfTVFUKdTALMyKnYeHu2XDNDk+0JoF2sAdG35sET6SQxCFT88A9ehDZaBEjrbp89UWYhiyRVES6BQzf4c9723gmmkg07PJnHNx9mAh/RwRc+BYKQFVFfAQAAGCkinB7kZqjRq+J5YigvKkntvlRQlfya2kerQe6OOKnvmWHjLY3uZf6lFVM59aUr79fR/Vs0s59qdquHEpmX76nw900Qy+aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 18:25, Tim Menninger wrote:
> It reproduces with slab_nomerge.
> 
> I booted the same kernel with:
> 
>     $ cat /proc/cmdline
>     ... slab_nomerge ...
> 
> Uninstrumented throughput remains in the high-45 to low-46 GB/s
> range, as before. During perf lock it was around 30 GB/s in these
> runs, versus roughly 25 GB/s previously.
> 
> The dominant lock measurements are essentially unchanged:
> 
>                          default             slab_nomerge
>     unpinned/node0
>       contentions        4,782,839             4,858,759
>       total wait          14.39 min             14.26 min
>       average wait       180.47 us             176.13 us
> 
>     node0/node0
>       contentions        4,582,012             4,686,729
>       total wait          14.13 min             14.34 min
>       average wait       185.05 us             183.53 us
> 
>     unpinned/balanced
>       contentions        4,572,196             4,544,677
>       total wait          12.81 min             12.56 min
>       average wait       168.14 us             165.84 us
> 
> The uninstrumented cmpxchg_double_fail deltas were:
> 
>                          default     slab_nomerge
>     unpinned/node0          7,471          8,892
>     node0/node0               713            457
>     unpinned/balanced       1,503          1,504
> 
> The CPU-utilization change while perf lock is active also remains.
> System-wide %idle for uninstrumented/instrumented windows was:
> 
>                            default                  slab_nomerge
>                        uninstr.   instr.         uninstr.   instr.
>     unpinned/node0      31.46%    3.60%           23.02%    2.15%
>     node0/node0         84.26%   12.07%           84.62%   11.85%
>     unpinned/balanced   66.86%   14.83%           66.58%   14.78%

I believe the weirdest part in the original report was how slub stat
counters such as free_fastpath etc got order of magnitude higher with
instrumented vs non-instrumented.
Did any of that change with slab_nomerge?

> Thanks,
> Tim


