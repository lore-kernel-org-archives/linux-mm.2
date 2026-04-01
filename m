Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8CA410F6FB3
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 188B16B0005; Wed,  1 Apr 2026 11:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 139A76B0088; Wed,  1 Apr 2026 11:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050216B008C; Wed,  1 Apr 2026 11:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9DED6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:01:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F0565B6C5
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:01:41 +0000 (UTC)
X-FDA: 84610301202.18.FD1AC95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7422F180016
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:01:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XtDUqcg+;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775055699; a=rsa-sha256;
	cv=none;
	b=Ur/6zil9pzb7DUPQ9gyIRZacl+EDL0Rtrdvr0TPc5z1AcTUx4LTRoWM/plaow3NQcDmHta
	GI/nWmcUFHuq+HEzbmGGRR6eI4ZYkg1BPNhdp7zpFieJuRNBCFcwAZ3a/y8dO7wY8fvdo8
	I8bALoOw82LW6FLNwAyUllz7B3hXh9g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775055699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+z3dYGlkY6P444uNhJjcU/Cu0lajLFIylE8PpccdWzo=;
	b=PXTsbx4UnXPv2gY9PvM5ByvG/aLQsNnJmLYqHolnyH7tlHKG7HL3+Jj86AZVwOQU70J5Xm
	c+ioCGzAKtdJyTzVos2/e/sTTm6JEyprMNupiBW1//19nS/XUiujl+eoGk+fby6u4zeAbO
	VGQd9k635GebNr+f4a3GxXtGyHAQLp4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XtDUqcg+;
	spf=pass (imf24.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 48BE240B54;
	Wed,  1 Apr 2026 15:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FE4C19421;
	Wed,  1 Apr 2026 15:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775055698;
	bh=m5cXrw/+u7nKwxTo1ZXueSC2bQlHWB3BDoYUE/63wdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XtDUqcg+8C7Lr5ORoq5jgXq4ExL7mkdYBbI+HbXbD+EiIrifX22GTsHVvdlpNiGI1
	 t9bbkkZTKUEymM1JgJ1rAUK3MEO69/FH+B4etlOCtQOzRaxHfevMK99UfmgFWXZ87A
	 L+HvGcSazTrwMCUS7jBXENLt76CvS6yyOFkV334Y74UlKInUtcegg5X5Nc9U8AMRfu
	 Ev/GLbMxVgvlDdE27R9aOnmPRKRhsL1D5FHRzhMz3nwQCosP1viDjzE43zm0Qnj+h8
	 mz9T/NO4JldZ2zkylMEMqt0aX5un1QE5V32uvZU2cjPGOJMwjW8ujNMiHTPV2x8hBc
	 1O1aLQ1sEf+nQ==
Date: Wed, 1 Apr 2026 17:01:35 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	Leonardo Bras <leobras.c@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Waiman Long <longman@redhat.com>, Boqun Feun <boqun.feng@gmail.com>
Subject: Re: [PATCH v3 3/4] swap: apply new queue_percpu_work_on() interface
Message-ID: <ac0zT4FaL2ZwN4Sq@localhost.localdomain>
References: <20260323175544.807534301@redhat.com>
 <20260323180150.304067458@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260323180150.304067458@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7422F180016
X-Stat-Signature: afe1omfsbg3orrmqc7zt6n6fprcwjto9
X-HE-Tag: 1775055699-211159
X-HE-Meta: U2FsdGVkX1/Yrse3L6cWDoL1eZpp5o6rPrNxE1O9Iyo4x2JR93YlGCnz/uOTsJKxWgZf37VONEH0YBYgkV5AUC0ta43fjPG134uq2stCmD0Wk0MxN3OIG8LrIxr178MQVd4hhifg6QywLA8kvhjE8HlqfzTJGEPp/3ujQ6Idhp+j4ysFQhlFTtfgxms4vu8fb5TiJY7WgKeOXAKpGnsROB9kAmY/8WevQzrjonaGg0ae2zY53Ysn+CKtrQfKjdbHsLHnb0kyvozlYZxs9B+ftuIyNqEYk+xVKgwD4gTSAoD9Lp5kqjmP560SruWtxlwmA1vg4uA4MBbfXExPqsKNfQyTceFjg96Ygi0JYyqfm1G4+wT65/djxBbhuIUiV8LKUy61V/pLI/xvw8PRlV+3d6+Sic6sb7Zrhby2rdxhyWECrdxmk52X8uFQMu42k6fhh5gLOfO5hXx2E2xVQu2vsZ1QNRBFxnsRN1ruG1TSzLS8HUrqwjP6lahu5A1pZ43ogjIeKd/dWU/KQr1/8TRtHZP/4Hr674CFUxJmTlmqzvunCCJY3VhSxyHSIU4vVg3R1r1P0R2f/gdhrXx8HIhKVB1YW1+oINO14qIw5t/rzixvvvE4/TULl4dLMdk0CUssgMF09KpkpEd96KzS2GFRq1MTHGc7Q7U4UXsIDozHkX6hyDw1ng2O/rfYSzkkTxPrbpjeCHlGB77AwjtdoP1rhhmteptEt56GfJ65UJXlHB10u1QQU/VFqIa0i1BPpDS28klBqr9KPJV5vDh+FNA3L/zsaEr50b+SxW+HI3EuSMUGqc+PWJxT1dsJwFl6xn1ujZ9eKYzK7bLFzRouOrx5dMFZoyGgZCkyxpEt1GpHLKpd4V4rXGRr9nOWRHOeliZwrnXNDQGp4j4oLfKq2X8Uu8PD5jb5zGMCvXenygUbIoGwNNmT2TPHamHvumuywhADSXoOb0rUAurQ04ippa5
 b6clgv6y
 Wj0Iczxqu0mm5+EuArdAycpwbZsIICrEmKkhMdE7SX4g7TvcIxL12lS+l+rL03ieM624CEygllETsPZeJvdmb5uMWX/mk+BP/IpOojbMSmwIStCWWc+STxiiIsHSM9fv1w4wiCKcbXP4/9NDSpLpgNhF2JPvWPqVfNFgV4zvormu9SE9aI9WdT9MeCYpWUlLfjibp25LYwAcSUnnhM5mhW/GVt+e+Dql0eqHDveCPZEwYSUSrbLh8R2deZ5/sDwk6LzPNSXI6mmiegl98p5M+UYzcrflBH0qUAfNf61S832Ncg/PIkF9ZpOC4ma8yx6DoyxmqkRBadW0ij7Kh8HPGymE6rodwkB2LwfF2JAyeiBOKN/UhzmJHUavg1ZSd5tY/3YSYB/SEn9YLySuQvv+Dz8savgd3BwxI2UhoO6PZYBgPNdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Mar 23, 2026 at 02:55:47PM -0300, Marcelo Tosatti a écrit :
> Make use of the new qpw_{un,}lock*() and queue_percpu_work_on()
> interface to improve performance & latency.
> 
> For functions that may be scheduled in a different cpu, replace
> local_{un,}lock*() by qpw_{un,}lock*(), and replace schedule_work_on() by
> queue_percpu_work_on(). The same happens for flush_work() and
> flush_percpu_work().
> 
> The change requires allocation of qpw_structs instead of a work_structs,
> and changing parameters of a few functions to include the cpu parameter.
> 
> This should bring no relevant performance impact on non-QPW kernels:
> For functions that may be scheduled in a different cpu, the local_*lock's
> this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).
> 
> Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

I can't review that thoroughly because it's not my area of expertise.
But I'm fine the approach. Just please consolidate that qpw_* prefix based
namespace.

Acked-by: Frederic Weisbecker <frederic@kernel.org>

-- 
Frederic Weisbecker
SUSE Labs

