Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFA9C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 01:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31FB06B008C; Mon, 10 Aug 2026 21:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D6D76B0092; Mon, 10 Aug 2026 21:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E79C6B0093; Mon, 10 Aug 2026 21:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F1B926B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 21:47:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80133C02F7
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:47:34 +0000 (UTC)
X-FDA: 85087301628.30.FA6F9CA
Received: from out-175.mta1.migadu.com (out-175.mta1.migadu.com [95.215.58.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 42F4E18000C
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:47:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fni5WM2z;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786412852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vXSP3rMmLOlY5oMvjw5F843dB49FoaX+dyKSJWS/MBA=;
	b=yfg8+eXgEyKL6QIwfr2BVAVvBW5ky2NZELWKw32fQsSWX0gcTPnoWLJZOwXlOpcGGqOFyZ
	s+jRk5H3pHgHLQGQIe/VYxn4HRVr5+XA5EPO8TCQr3vtI0q8lMOMAiyrFYsqkfQr9+paAA
	qhT/xEKBYd+jgOFKpXKyguGFMbVVhL4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786412852;
	b=12QEPwu5AGhqSX4hWLU4Tyt98g4F4q6Kw/bWYTHzoM+3ZG3gbuKLKSoptLHmBL1YActNUe
	2Ax9BpLrhRDr/m6BsqHYI7iK8qBEvoLcV+N6lvIJONr4JEhsjvEoEuUwf6acla9/YmGF5b
	5EupdAmgz2AeLIWfhR+v5zDCgKEwL1U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fni5WM2z;
	spf=pass (imf24.hostedemail.com: domain of guopeng.zhang@linux.dev designates 95.215.58.175 as permitted sender) smtp.mailfrom=guopeng.zhang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <39efdcc9-3dea-4669-bb82-04568fe2c58d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786412848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXSP3rMmLOlY5oMvjw5F843dB49FoaX+dyKSJWS/MBA=;
	b=fni5WM2zXzlCkn/LRqi7o4f3BY91YWHhHUStmRfuCHNIhly1vQnlVkgIlL6WWuSqEYxXvp
	RMecZgI+XxCyjF5/foVr/aPN2g4K6IiTg0SlHBl7i9D2WAUiA2SkjCvVKtpj2Qj/zpEzcm
	DPr+ezJIC+HKxyhn7KLuFyo8U2HFoAY=
Date: Tue, 11 Aug 2026 09:47:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
 <20260810114749.368140ad5be4fa10085bbee0@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20260810114749.368140ad5be4fa10085bbee0@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 42F4E18000C
X-Rspam-User: 
X-Stat-Signature: ea98zwjbopji1kczea5epaxewkqm6opc
X-HE-Tag: 1786412852-230838
X-HE-Meta: U2FsdGVkX19FeRnYRK0cNDpYNykClWXOXE5s5se5uUHxcpszXRBdlLkE/+t4/MFDD8pT+jHc316g6GmgZJ17VCFldvKRD00/0qnvvmOZqyn4hbiiVBLEdRI8rpesBnhm5quS2UJlJMpN6kfRdFsDyH0na2L6T6DvgGk4rhMQQe5Y0wD+cPKOGiKtXV8yCXDv0mI0nnXz7oiCFwjd3zPKkdCPrz4527rMjk/phKHKB/Hgjlnhq5wCuuyJtHY0Yt4ZcOZj8eY4HR1Z3xFCE2vpFEcvNWyHcdKnpjx39AEXudIiBr8f6o54dT4dLJzXlQVsQIXz18Eqthrpj/TSBnYwUgjBJQ1/0pUfFzjc3BqZQf50GE3Q+ilg37PIwyWuH8wEG4emklzDFYSTZXqQ83F2v/0PbAgnrnxpTem+3uBG5mRZXtN+zpW8av3PnmzERY5ZbYBPd82J6IPcIcb8MK1Gl/73cQ4mGh+C9ii2bP7dcWQhMWXluchgWNWnaFwIZENIBu+cyXOgxbIhf4Rg9+afSJPy5nccMswF7Xz6p4utxjGCCogGzIyAjv2bwKzeUTNXCeKHD/vtSaDdx5TI7ZLlsthm3HB/Pvmt+Y9RCzqXZ4ORhV6NeSxtzHiwg9kXjQy0pI1nqlDlBPl5XAm5NhizMYQ8kNgiw/nesJH+RF0eDgvIvMZRArsPsREO0+nZbvOA8y1BDPXVLz4tIvgzqNXoaiG2yMscXkq0cfsjAKkHTfyEsm8Si29DPe76ZwVq3mtLQBvtKkfTgW2ippDf9JcZ8fWh0jh4LxeIMTZwJndHGA9s0vtrgUQFRDbugkSNE58KsHY3dM5wxcJWTMwPiHSvCwNed7LPmodismZmGRh79W38Io5uRkHV5/+C3oszGoT4+5rrOM0GysfQv7wpq86wa4DeEDZ8Ik3PP3HXcN+hAIhtuVMMSGc4+1zGKsgvMOUDEkgLc5Kv+SbZWqeUPoN
 k6Ya/HKX
 8J2voIXDyoQnLeQNQOJN6ANh63f+z69Gw3LHgy+f148YktrDtM7Z5f5qH40mu+hClvh5S/l3Vx2hi4OVWL2PHith6gNOV0xJVPJZUlpcrlOmu0tkr7/+PV4QhlWurBGVUutIdp3eHox+FKpu2MHdCCXg61/QCZ/hl3Quv1eEpTXgwrnA5SGCfsQ51sLMV874v6b/KCaPqmNQd9MgM8Vlgl9sCkAePEh4hyw5VaJ8n1isvvRmTgmXtbYFxDmubaX+xp4cVuQ9k3OdT6fbQQZWufJTUgNnrXjOSFYWdppSJ86RQqt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/8/11 02:47, Andrew Morton 写道:
> On Mon, 10 Aug 2026 15:42:47 +0800 Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
>> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
>> cgroups") made failcnt accounting conditional on track_failcnt. It
>> enabled the flag for memcg->memory, but not for memcg->memsw.
>>
>> Consequently, memory.memsw.failcnt remains zero when the memory+swap
>> limit is hit. Enable failcnt accounting for the v1 memsw counter.
>>
>> Reproducer:
>>
>>     CG=/sys/fs/cgroup/memory/memsw-test
>>     LIMIT=33554432
>>     mkdir "$CG"
>>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
>>
>> Start a child process in the cgroup and make it allocate and touch 96 MiB
>> of memory, causing a memcg OOM.
>>
>>     cat "$CG/memory.memsw.failcnt"
>>
>> Without the patch, memory.memsw.failcnt is 0. With the patch,
>> memory.memsw.failcnt is greater than 0.
> 
> Thanks.  Nice changelog.
> 
>> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> 
> I'll add cc:stable to this.
> 
> AI review thinks that memcg->tcpmem.track_failcnt should receive the
> same treatment:
> 
> 	https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev

Yeah, tcpmem has the same issue.

I'll add

    memcg->tcpmem.track_failcnt = !memcg_on_dfl;

and update the changelog accordingly in v2.

Thanks,
Guopeng


