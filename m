Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F422DD38FEF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674C86B0089; Wed, 14 Jan 2026 12:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615166B008A; Wed, 14 Jan 2026 12:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7C66B008C; Wed, 14 Jan 2026 12:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 40CE46B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:07:02 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 087761405CE
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:07:02 +0000 (UTC)
X-FDA: 84331199484.27.5ADD82D
Received: from mail-wm1-f67.google.com (mail-wm1-f67.google.com [209.85.128.67])
	by imf09.hostedemail.com (Postfix) with ESMTP id E899614000E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:06:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Mtm3/X2b";
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768410420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W8rPwjfzU+1ry2RQl+0zGZMNXdxcPKW2Gfu/u1uR+Mw=;
	b=m1+4X1gP1aRNeexNkzu9hT6M0/eUe3KKWIoctAcrrxFQRRVsbM3CSC2l6tJLtRsr8b32Kq
	BSQTZVKIN5IiPwhzSS0HyLyDyTOiOjWGb0Zr/HCo4N4m2B53RSI332FjFlPtsGSU9svc0m
	+s368QAU0wJwikmZuRpE+4m8ckSbWWs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="Mtm3/X2b";
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.67 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768410420; a=rsa-sha256;
	cv=none;
	b=68zjfrzyg6rTxYu1DsKweiwbqUQiANEAGAynNLQaoMgyGsyUvozCGW4CXs7Iqlo/cFLDVQ
	FMRtLQmVqpRl/RBNijhFm09c7V88kN5hbr4Ej6dptGppkCZZudh7+YILSrvbFCTkKs3O8R
	P8DGtMkxCBIjQACx79o68sp2D/jm2m8=
Received: by mail-wm1-f67.google.com with SMTP id 5b1f17b1804b1-47f3b7ef761so311695e9.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768410418; x=1769015218; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W8rPwjfzU+1ry2RQl+0zGZMNXdxcPKW2Gfu/u1uR+Mw=;
        b=Mtm3/X2bgQ8+kfiXNpk3TrCWijIjfFa790pIPQE4o/LSCy/qfqvgi96HTv5wNnBniW
         DqCyu7aRiTG/ElNJnyUNvIdWvwe+ffATxynnD4D8AQbkyjhjiohH6snYAGrg/KOmRqm8
         XhUd4XykzGxwSPoSGhm5pEU8EL/YBY+LD9IpaAAQnMEsJhwcGP8wyUtbtkIbxtD345YQ
         zjo77/CGOmF7enKEnZHzWIH1eQF1d+aCc5Zj9ZDUNkEHZTdBbSnwkIicwPnmCva7Gonc
         BLJGdOJ2e9gbaN/18om31E6/lQzMsFfaiuvkQn/dVBuyG3mzOJ101tE+9aVibAvAnMjA
         cZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410418; x=1769015218;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8rPwjfzU+1ry2RQl+0zGZMNXdxcPKW2Gfu/u1uR+Mw=;
        b=tDBuoUMbErjjBEv9ViI1h2gk1OnCl4pO0436913NthwB4T7tRBawBjM345UPwpea9Z
         7KJwgtYUw1WDzqURP9hLZKXKFJWu+EB7TOlkRQ7e0G3FaPP4KaT+3T0m2o9RG/sAtb70
         WNqSzUVF25FMW7W3hVFoq91WT0rphOQElimRXURJG8+NhkQ2QDsAbO8u4afQfzcmyWp8
         Qek74JNBNY5ewLXQs8WCjUgosZ8/ve21Il1FIHEvbBc8dlQqoxDpxzor0xHSWs9BL5wD
         Q/Em7rLNhUy44vFLAVJM3obs+bcBurDf0YnM2RJSufhuUEnpx35tUiiOV6Qt9QDwkzze
         dxeA==
X-Forwarded-Encrypted: i=1; AJvYcCUiH1a9tjVrHsg/t2XrdL5kn2QJpBThHlbMPPQq988j3cZGuuuEDL4fG+Ss0kQWk0hecmH1yDcT9w==@kvack.org
X-Gm-Message-State: AOJu0Ywd7+zsVqJhOrbAZhiIkvTOBwJKM2KBXWD/7+hy9jRTLMAGMMDx
	qzDizLeyqGZRvxd7JWcQG3t/+/fSqkddQS1QqGq7EYSMuGlaC6sPUuWQcTcIbIs5i/M=
X-Gm-Gg: AY/fxX6StYPHPu2jcCkEXmVDVbWaJlcDMpZo+O4VmSEcObGFW14Mm13kVZdbncEXOBp
	DlHm1Ece12p3Pa/VFXtPTnhohFSk7SDGb6HtlK/pBmsODwJv8wmNhKAJln/khgV4G2JzrdpVX9H
	mZ+pr9ocb/PRYijxVQMb3yHsxNsVz7yKNvyNYu+B+QouYLcUsVtqnSJ/eJC+sqSVASmq/+TSsmf
	/ZPWlpCGlQT4a4LYjxlm198SxAWLS0xB+LP3GW4kDb5IIG59LwuJa/U0vhAaSPfzxRVN7Il1YLd
	whGgbESTwN66p/x1RcJb7TW0puaOTtxwxTmW/6ftyQjbOhea2yP58nrO9gW1bRHkP10SZdF8bt8
	fvDYCW1E3f9G/yW9AKYo5u5ZJXfiNZ4eLjTqXyG8gZjUxEBIJ5OwmlqTKg/uAd0Vzx790s3hwH/
	7Gt3InTAEloCA8GIbYVJBHAEfi
X-Received: by 2002:a05:600c:4f4d:b0:477:b48d:ba7a with SMTP id 5b1f17b1804b1-47ee338a84cmr41858385e9.32.1768410418292;
        Wed, 14 Jan 2026 09:06:58 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f428cc338sm1933365e9.11.2026.01.14.09.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:06:57 -0800 (PST)
Date: Wed, 14 Jan 2026 18:06:56 +0100
From: Michal Hocko <mhocko@suse.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v16 3/3] mm: Reduce latency of OOM killer task selection
 with 2-pass algorithm
Message-ID: <aWfNMKCoEp2LuA2v@tiehlicka>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-4-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114145915.49926-4-mathieu.desnoyers@efficios.com>
X-Stat-Signature: 4g1bumsnndgx9w5s3gxkh438qrx3qjf3
X-Rspamd-Queue-Id: E899614000E
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768410419-44019
X-HE-Meta: U2FsdGVkX18R/ZvUwu4FtvtGmLCIgXDoTOQg/DIdS1SYzmJDkm7Bj6/rOWI7lKSmheX/5uZ/Vbuy+fofcgXsy7AA5ILB5LYnR7pwP5DDW1vJEk1EcniDkIO9RbW2lxq6LlhK3XlzKCEEdffgiC/SnW+8KjmSVM2N4VQsLDZoPDJWqsqvlFw5sm5RF3AtVOpK+e//kCWmQY++mgTXNDbsJrMkKdJlCyx+WFVcOWxeZgshx9Mr6vEye0mYHCzU5V/4/CXBnZGBVv2FZAbkUx4CUaNzPl1XOQg/nVyQnbN33fIJqpCeBxb5FCz5fyQi7cjM3tAd43T14K/2OT057+QhBHar+W0OaIOAfgA0bvFgs4xlBHTKWesfoMJ8tnPq63UWsR5oCZuQC6N8NIqKALo9PXiBG0lR3cn/jDjFe7ixcJDKGtm72N3Wi0cvjuy8TAJmAdX8OY0DOzFjX8X/PMYV5/cmH1lAsWUX26Lw6Bq22PoRxEH8/130R79N+6d3D42bLRbu+k411I+EuiPLptQWCj/5w2FKgXTRXKqRCKjpZWb52xuztAz5G2tCL4il2yeu0rqy0VhafUqaNidOzVWDoXmP2za0eMGK/c5J3d73evCiV6GA94pbhD5HsnIe3zZFgKNl1g70rBf9WvlYfrmFn7qnoPkV2YBRSt3j+JTVvaXxiJMGn0KjixmijciMkn7nJr2FOFz9SIdLkmRrwKpXtUdkZ2635ENRWAxyKn/RMez/qPs9uY8xEBDKMLHTtGTJxH06sMfpOU3gS3KBYsoogKUTkIWWGKhAdxi9hp3F+1/U39ddSmeB1vHwvm9EOkRnUzgTSlD0s+RaRAd0tSH3QHPA8zAEIsRNGOrhTK8Q9+gY4rLBLCz6cW3haPdDTW3+7vJ9eoE1FMlQrHN2ArV0FHMMygx3H3ktZcMeuEMvxL2gZeL8EDZcGuRQbhD2T3DJQhgbfdYHWJLXtF9eHlf
 Zr6l3FxO
 GWeJt5vFf1TR2aAOJBX7JnLPHB2VaaASuEDdQT7+pT6Cbaa0RmosSOEOWuajJIJIsDLiBHmgdTYpcMtPD8Cq9jWM+gH/Oa7TYM1RV1hfhGSmm0Al13RJ18XcizifYhJHtLxSqkgsweBvenWw5alJMhH/Az06n3Xi7bxcJ3N4TypKbJZjYxQksnyrvki9dxNcYlrcm+ZrlEPDUd6QnhbXakeXDYqWocuI6wf6SGWEJrgs8mRMfq7Yx5qA4DTgtzTC10HlzElZd0ZfDk2T2AvsvFO6DhULN8Pv75ViWpMWfdfNBQYrU2jaHMoXbD+X1ELRV4CGoyPaCzEMYzx6AhTxGLQi8Tkhoag3gAKJQT90aqIJNBXMRsXUisSfYDb7YlgTh0ONalrC9uQSjn9wFm8LSH6BqAqnXyfXbyCyd6iLVWlwRquGSR9GoQjzsNuDjNd84GPLY0GtSyKcfK8l3X5qdDXIJO8tG9w6wS0c7dgb07KkZtBa+Qt+j6lNjCV1X8m3rT0B12anuKC4Pi3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-01-26 09:59:15, Mathieu Desnoyers wrote:
> Use the hierarchical tree counter approximation (hpcc) to implement the
> OOM killer task selection with a 2-pass algorithm. The first pass
> selects the process that has the highest badness points approximation,
> and the second pass compares each process using the current max badness
> points approximation.
> 
> The second pass uses an approximate comparison to eliminate all processes
> which are below the current max badness points approximation accuracy
> range.
> 
> Summing the per-CPU counters to calculate the precise badness of tasks
> is only required for tasks with an approximate badness within the
> accuracy range of the current max points value.
> 
> Limit to 16 the maximum number of badness sums allowed for an OOM killer
> task selection before falling back to the approximated comparison. This
> ensures bounded execution time for scenarios where many tasks have
> badness within the accuracy of the maximum badness approximation.
> 
> Testing the execution time of select_bad_process() with a single
> tail -f /dev/zero:
> 
>     AMD EPYC 9654 96-Core (2 sockets)
>     Within a KVM, configured with 256 logical cpus.
> 
>                                       | precise sum |   hpcc   |
>     ----------------------------------|-------------|----------|
>     nr_processes=40                   |    0.5 ms   |   0.3 ms |
>     nr_processes=10000                |   80.0 ms   |   7.9 ms |
> 
> Tested with the following script:

I am confused by these numbers. Are you saying that 2 pass over all
tasks and evaluating all of them is 10 times faster than a single pass
with exact sum of pcp counters?

> 
>   #!/bin/sh
> 
>   for a in $(seq 1 10); do (tail /dev/zero &); done
>   sleep 5
>   for a in $(seq 1 10); do (tail /dev/zero &); done
>   sleep 2
>   for a in $(seq 1 10); do (tail /dev/zero &); done
>   echo "Waiting for tasks to finish"
>   wait
> 
> Results: OOM kill order on a 128GB memory system
> ================================================

I find this section confusing as well. Is that before/after comparision.
If yes it would be great to call out explicit behavior before and after.

My overall impression is that the implementation is really involved and
at this moment I do not really see a big benefit of all the complexity.

It would help to explicitly mention what is the the overall imprecision
of the oom victim selection with the new data structure (maybe this is
good enough[*]). What if we go with exact precision with the new data
structure comparing to the original pcp counters.


[*] please keep in mind that oom victim selection is by no means an
exact science, we try to pick up a task that is likely to free up some
memory to unlock the system from memory depletion. We want that to be a
big memory consumer to reduce number of tasks to kill and we want to
roughly apply oom_score_adj.
-- 
Michal Hocko
SUSE Labs

