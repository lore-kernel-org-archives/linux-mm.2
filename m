Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34941E66886
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 03:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8560B6B0089; Fri, 19 Dec 2025 22:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FFAA6B008A; Fri, 19 Dec 2025 22:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702456B008C; Fri, 19 Dec 2025 22:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60CCC6B0089
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:20:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07F7A140426
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:20:19 +0000 (UTC)
X-FDA: 84238396158.03.4CF8C63
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 22D0B40005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 03:20:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AqfSN9En;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766200817; a=rsa-sha256;
	cv=none;
	b=fIuP+3dzfk8Z7Inj4cA20RYaUsqfWHZoG3x+Ojl1efx74YGWtEagKKEkvhy2HVGcn8cP/2
	R/BoPBBaFLY3hDIITFg+ngAqHaDkdXWGTocWsIT7Hqgm4CNIuTd9UsuGGROVPl4fnTihat
	tSf0dYE3yONW4x9EQ+8Z9bllR2HDO/Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AqfSN9En;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766200817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSWnxPF7s7XrgaAgGOnY7K1GNIzL+YqDV6JYLvAhZaU=;
	b=Bk3EVGMkVRlJcq43MpLmXZYeUSRrtfnCVlWz1ZeENIissqthe+q/2jx73vJ+Y947OGR/Wx
	JaR8fbZwsEr7EoeME9qiSnxGxLCc74BnB6EZmc/SrvL1FyvmtBr5/TP65B7MmzxyxIFlbR
	weTJA2OS9RHSLiUed3AvlbUD3FNqshY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766200810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KSWnxPF7s7XrgaAgGOnY7K1GNIzL+YqDV6JYLvAhZaU=;
	b=AqfSN9EnBu+pQ+55c6KrxraFWofHwRehkLXlObC2WQPuyODI6sRp51PUDiCH3FSpSQ7hHV
	WCMjBb/r91usuQ1LiKsr/XDzXH2rvZl2CtPrYl/dV9uHmZAF0fjFp3qytDa7/4JaXToPF3
	h06Y8zGnLjlifMc3TK1SqU1GZykFUFQ=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bpf@vger.kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  JP Kobryn <inwardvessel@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Michal Hocko
 <mhocko@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v1 6/6] bpf: selftests: selftests for memcg
 stat kfuncs
In-Reply-To: <2xhmcrporen72rskghn6hmg6obnojptuerwzqgu7mqzhnxaxs5@33dxlwa6rqlh>
	(Shakeel Butt's message of "Fri, 19 Dec 2025 15:07:11 -0800")
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
	<20251219015750.23732-7-roman.gushchin@linux.dev>
	<2xhmcrporen72rskghn6hmg6obnojptuerwzqgu7mqzhnxaxs5@33dxlwa6rqlh>
Date: Fri, 19 Dec 2025 19:20:04 -0800
Message-ID: <87cy49g7q3.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 22D0B40005
X-Stat-Signature: 8oej84nxu8nms8cpranhkuayuodzse3k
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766200816-244508
X-HE-Meta: U2FsdGVkX1+ESYN3KHVJnyfbUSkDJA6cJA8snxwhhsFpLyX6MCsHUqYG6csVskWRRpQlTotbyt2AQUMzgdOfdOPfNxq6Yjpb6nc9SW+fO31m5qBrftMrxga2XhczPEmbQkc6F47ubqggrrxbtOEJmYGbJa48TGZZoUjkfFy80hKwOLXsrjz4wmCAovhle91cihKV05b1/4LCoHc2Q9+wGXj5wjhZy4iD78VqFcnIs15VIPi8NyV/nF7G9btNDs0q0owWut3vyYiedY2IRa630Jfcz163In7tJcz9lU/ea0+jit65sIYIX181wie0APqRoxTc4v1uj25BPsYz5u9haV79afO0cO2TeecZ2qFgcUFvn7oVNfcqkfdoGa/OEQQtfWrXTAWwnQu3CtjVPCOXwJzcZNfefiFfOKu5dRYVSNiLefMS+QJqzBdHM0dvjh6M3zVi5G9wsfI+UWkIa25sBDV01o4JHeFUgV3ljDoyKxWSXrUc0EHqUIIo1BCOVnrFeUl2Sp2cTFah+JNKDJu9QqA5TxTq8qVArK+2lzrLkvRP0w2UPBEsAqFEui/Ho6pr9/5HNIYLVk+YVJ/NHecaWz6yp8To5RuT+1xgid+wjPcavRtVPaZd62dTa9yGU+o6oxQ51DfWEAqblpr2kDc5rPE0MzGP2NZOGicvsODcTnqLEDd6ns8TxmR2tXLC+hr5NAk0OhE06sbbabPB7Yc5U8LlbRsSfmSDq9Ov7iuCc5QNLkamtMxegKNVYNYAlACzukKDmIoOVjC6jvz4q5sKN/u9/lI+1GCm/t1AfZtXUUFnFjLRgr/8R3lS40Klzxr6ofj4uabVsrtHCQUBULm7KJdZVfxgo57PWhOBxZPNZVFfMcjsoJAcKea/YSg7OkTVm/R+bpiF50UkC/JwVsl1G4cBSJQJiNT567rKtZsPQNdatdTSTMW+myKEejwdfIlEskfmP7SZ6fA8aAtA0zu
 m3IcToAv
 H8DtR2QotoQqdKm3cInTe3mnPGqyeEUSfQCdV3NH3asHDxJQxKrZrj0fnQ6xoKwOL4LOy4rSh37UUAOJbEnXh9jXNz3FoKShb1zNzuMGUbEbqNfSDwgE1tBsx3ZdzlbajJQdZ4X/ZX4bNe6Y1iyCeNK94lE3Qd6OlPVNVdkkMuLR07aPi/E5tqu8auBvFEL7fhp6LvxTOucfhhzf1dNdVGyxirQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Thu, Dec 18, 2025 at 05:57:50PM -0800, Roman Gushchin wrote:
>> From: JP Kobryn <inwardvessel@gmail.com>
>> 
>> Add test coverage for the kfuncs that fetch memcg stats. Using some common
>> stats, test scenarios ensuring that the given stat increases by some
>> arbitrary amount. The stats selected cover the three categories represented
>> by the enums: node_stat_item, memcg_stat_item, vm_event_item.
>> 
>> Since only a subset of all stats are queried, use a static struct made up
>> of fields for each stat. Write to the struct with the fetched values when
>> the bpf program is invoked and read the fields in the user mode program for
>> verification.
>> 
>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
>
> Need your signoff

Sure, will add, thanks.

>
> [...]
>> +
>> +#define NR_PIPES 64
>> +static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
>> +{
>> +	int fds[NR_PIPES][2], i;
>> +
>> +	/*
>> +	 * Increase kmem value by creating pipes which will allocate some
>> +	 * kernel buffers.
>> +	 */
>> +	for (i = 0; i < NR_PIPES; i++) {
>> +		if (!ASSERT_OK(pipe(fds[i]), "pipe"))
>> +			goto cleanup;
>> +	}
>> +
>> +	if (!ASSERT_OK(read_stats(link), "read stats"))
>> +		goto cleanup;
>> +
>> +	ASSERT_GT(memcg_query->memcg_kmem, 0, "kmem value");
>> +
>> +cleanup:
>> +	for (i = 0; i < NR_PIPES; i++) {
>
> Instead of from 0 to NR_PIPES, we need to go from i-1 to (and equal to) 0
> otherwise we can potentially close() junk values.

Good catch, will fix.

>
>> +		close(fds[i][0]);
>> +		close(fds[i][1]);
>> +	}
>> +}
>> +
>
> [...]
>
>> +
>> +SEC("iter.s/cgroup")
>> +int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
>> +{
>> +	struct cgroup *cgrp = ctx->cgroup;
>> +	struct cgroup_subsys_state *css;
>> +	struct mem_cgroup *memcg;
>> +
>> +	if (!cgrp)
>> +		return 1;
>> +
>> +	css = &cgrp->self;
>> +	if (!css)
>
> Will css ever be NULL here?

Hm, I think previously the verifier wasn't smart enough to understand
that it's always a valid pointer, but I just tested it with linux-next
and it worked well. I'll drop the check.

Thanks!

