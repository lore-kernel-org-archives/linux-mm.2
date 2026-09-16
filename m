Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C604C982C3
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 15:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489CE6B0096; Wed, 16 Sep 2026 11:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439876B0099; Wed, 16 Sep 2026 11:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F7F6B009B; Wed, 16 Sep 2026 11:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12DAD6B0096
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 11:22:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 006DC12078A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:22:41 +0000 (UTC)
X-FDA: 85219992564.22.328AD3A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3C2284000B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:22:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTzvFepa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789572160;
	b=2u/S3dlf3I5+VBCTukjrKpg4oNnNUWxziMYroT44NT/mHZHtokNv/rQ2fDQha7S5+LfApq
	Jw39YroypwRVL542Wf5axlptgBTFFheWgKd4jMd+ekOYN8kitFPk2oUhxYDeirtCwCj10s
	qXxwlscEKbAlBW+fOdMfl0XRI4UGjcg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTzvFepa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789572160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuNmQA5s10qS4VTTL4v5s8UJsbG/ZONw29ACJG8o3kA=;
	b=y6E/cfIQGNfsDy9jQ5jZ2ONio9hw7NOfyqIYwllDARihQvOV6BecVhtJD4ukNJ3+BMMVoN
	cCaf5T5ZrSg78BJB7zvu/bdT3sWSeptVMhmmjbu09Hg2/h8lM/Y+IC4csXnA4OJ87uJ7Zg
	MFqjmb6txYycDLApT72OjTG1m6mys2g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D563760234;
	Wed, 16 Sep 2026 15:22:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9981F000FF;
	Wed, 16 Sep 2026 15:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789572159;
	bh=AuNmQA5s10qS4VTTL4v5s8UJsbG/ZONw29ACJG8o3kA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VTzvFepapuMdEsmQOK1nJWTfIC9oryTuBzH3wAtW5cW7djRLKD9vRibINmbgqLfV0
	 Dd1+5D9STEb8HHfB0Kxw4xWx7JfkKyTpPJqU3O8NSDVebC801uRdbYWPcy4SpJLrFQ
	 gdzhpfcn/gcXWbX3Rrz2NiFnZu7LNEadUzvImie2OQbbZTu684/X0ysV0nacmcm0cr
	 FPEo/2C+DtYpM0uQPgqbJpP4KFQUvFpyxTx/KlGlBDJj0+1mhh/ZlvSsjMoq7mDIox
	 TK68BiyrEe2bBcNUlfumABJfDnLuS1yzZZOweN4HPgPz8+pohI7VWRu6j6yD4Zj7O2
	 9m6HQaaXKT4Rw==
Message-ID: <8bdc32dd-9d0a-40c7-908f-6f3a18b46a7b@kernel.org>
Date: Wed, 16 Sep 2026 17:22:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v11 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Hui Zhu <hui.zhu@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 JP Kobryn <inwardvessel@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>, Ihor Solodrai
 <ihor.solodrai@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1789475073.git.zhuhui@kylinos.cn>
 <ee6bcf945910babab2200f05040975492aed21b3.1789475073.git.zhuhui@kylinos.cn>
 <aql_rkQMtlLmMstC@linux.dev> <DLGU6EUUD8HP.3SFNWRU1728IJ@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <DLGU6EUUD8HP.3SFNWRU1728IJ@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C2284000B
X-Stat-Signature: m4xz3snkgwihybcpynz4mnsucmo4ifty
X-HE-Tag: 1789572160-169595
X-HE-Meta: U2FsdGVkX19YhafOzA0Qp+Tg/YXIzO+RRl6DJHFMi7Sa09euUTkorxygMLE1AntMKcPbxGacioAjE5TmDaBDp2OpNdXXdvO9zr0jMZBjXGjBX126GFiKky+9u3S1Bn4Ya9/fXzuNNXPu9VisLDhiAomc658TVak7ljr6Ix1rSUtMhxkus1Gi8aNKyr/fTaIKiBCOLs6UeVyhQ1wJEmMpjBM69mLDJNi91mGio1SGt0jCQAMar4ZrZh0lwNLGPXgmTz6Oceu4aZRKN1+eGAbVpk5aAGdzmIQnwGFw9A564mn1/+EIsOVnn5LZeR78nfiHwJyrgP7Qjd7VsJbHvZUVPPFXP8m/ZEKZqVdzMAG7gXhHCChZl3EWFxx5CLrQDB3tlwo8nhcmy4Lz/jZpicBV5IYhABHTCD0xuMpIvhJREwJAYLjR353X86e8BhcciOqcF19uBuYNhzQPUAbHFmnrlnwDdWKaPk9YYGltzt7n7a2yYBPaPKMF6xOwMDcWW0/oWDH0sxgFAApTDxV1kIW4ZsnZBp09aq29vA//FdO16lj/1UfQfe4kpLVfTvQbWtBVUDvMzB/BlTLmlnN/WL8NQP2X5/je7kMk/OfT4eYdFuQ0oMv1ey74EmRz7lzvW92KSoV/+6/OuPT8BifCUmsyn7L+V2eZvgdX1BRIH0H6TUv1wS9dTvhXR2GSmwpez3ua237reuSFyP8/euKgNpKGDV1uKCfhY1T0hfhAMzrHhTCnYdBJmJTI3524AghfXSIa/JDFpw9qhoWPCXuU3JsKZT9cdddnUgnrBhbFpuvxPrNsCGPIkyHZTEZ19ydqbp3wHKl9G+Gipoz4p3oxK/5XNjRs6O1p/C67IWgqrCpr9jieF7oeppqj0xF2wQtCH4/Kt8YQ4Bk1Pl6fttsf2k8NCh4CCI+lyURseyMzNqTapNuLq598hr2M3HT7pym3d2gXGV+xp+gx9tBE1AtRyxS
 jOt/DhF0
 SUXbmWosFI8/hjGE/7RL7YIJ2vN0iJamEFIyZOywnY6A3+fC2vYqQQXzBiyIKcyvZqBqCqDhtCeLVB7dq1lYpy67ZWLG/+BePZr7q7q2D5ttZqOt85gGjFPKJUb4yF02W+kW+6TxtcrKVLJzdRU6zeNNW/ajZDObZYXFpUBkZyN+JOTE3yjwqebH07cWfH1QAStg2e/Sb5bjWul4G0cTd4lhjah/T/ky2A2lNCoexfSrUIu1o7int1Pf2uVsraMGXJgf6L6Iyg89Ik6BYSDnZWcfHDJGebZ2Wx8BilR7JeS1vA6DI+eovWzG6jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 17:12, Kumar Kartikeya Dwivedi wrote:
> On Tue Sep 15, 2026 at 7:26 PM CEST, Shakeel Butt wrote:
>> On Tue, Sep 15, 2026 at 08:29:35PM +0800, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> BPF programs can observe memory pressure on a cgroup, e.g. refault
>>> stats via bpf_mem_cgroup_page_state(), but cannot act on it:
>>> triggering reclaim requires writing to memory.reclaim, which BPF
>>> cannot do.
>>>
>>> Add bpf_proactive_reclaim(), a sleepable kfunc performing one
>>> proactive reclaim pass on a memcg, like a write to memory.reclaim
>>> but without retrying until the target is reached, so that when and
>>> how hard to reclaim is BPF policy rather than hard-coded thresholds.
>>> The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
>>> as high_work_func() does for memory.high; reclaiming more is left to
>>> the program, which can call the kfunc once per bpf_wq callback and
>>> stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
>>> other sleepable programs may run with filesystem locks held, on
>>> which the reclaim path could deadlock via filesystem shrinkers.
>>>
>>> Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
>>> macros to an enum so that they are emitted into BTF and usable from
>>> BPF programs via vmlinux.h.
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> Hi Andrew and David,
> 
> This looks good to me (from BPF side) and Shakeel, Hui might respin once more to
> address some of the selftest concerns.
> 
> After that, any objections to taking this through bpf-next?

Fine with me, I don't expect any conflicts in mm/internal.h.

-- 
Cheers,

David

