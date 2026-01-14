Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95B0BD38FE9
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7E246B0088; Wed, 14 Jan 2026 11:41:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E066B0089; Wed, 14 Jan 2026 11:41:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BD86B008A; Wed, 14 Jan 2026 11:41:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C041E6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:41:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60EA61405A2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:41:54 +0000 (UTC)
X-FDA: 84331136148.26.D99ABFE
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6DDA4C0010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:41:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YjctXXip;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768408912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5XsqmTd3Wuf5i5kP7cIwbfY5FVmF/Do+b5WJ9+iLQY=;
	b=6+y0ybeh61o/xtF64vVst70OgpI9bxGl69EmKyjYEzDJoiFRsBdS1HHY4+ESUnF1/Bw9hq
	B/D71KNwYvVfQzWMCN+0qDZq/qQs0eiUWWS85dLCT/lcp4D8WzzgBetaa6E+JJ3MzQ9EPk
	bU+HaL77qpQ1TMx1PKHoxGcHK2DuwXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768408912; a=rsa-sha256;
	cv=none;
	b=2CjIDYuv0DDepjoZxtYWXQwlMUvkClKaDHkhXfpYhnUq3q2b9PcRRh1PCKplFB8yMU/u4b
	QYynf7NVDbV4wLTSgLWp3xPM3UzgTSyI+TWSp/pr/vB+d1nOnFQQpdUIlXfdJhfbV1DqoZ
	vDMXOFWGK5kastSnmj0wsY+oUHvhTyY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YjctXXip;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42fbad1fa90so52172f8f.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:41:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1768408911; x=1769013711; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5XsqmTd3Wuf5i5kP7cIwbfY5FVmF/Do+b5WJ9+iLQY=;
        b=YjctXXipEYQ+CkltqbIZgFUgQv2bII14BfJ51oGst9zPTqkdkXOQaygZpWQF4yA59X
         aoCAK4wzvWGIt/dprCv8MzpR3gwxaZrFU0xWyzzgxoF/MWFL9Mg/5ehsWBhq0EtB+sWg
         +v0apdtW30sHBucdQxHOBg5BTF2Hs1BLOOBg7oanhH9ynkNMgXKuHOjxY9nvSBb1LgDH
         +yfNRre/ulQ5KIe4uIRMh5WfH100KBUsVzbKbbblACQo2mRhGBrv+kcWaPK0adW2sqjj
         AocyEv5uVbhF9Sv1W7RQ+6kFKZ1SXU6LE6t3/CVKkWi4LK/hthTYw3I6Y0GKfbAKVStY
         RmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768408911; x=1769013711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a5XsqmTd3Wuf5i5kP7cIwbfY5FVmF/Do+b5WJ9+iLQY=;
        b=ShQtr2yEF+6NjhCddb3kc1dszvQLUoXHRdAGD7VU1e+zNUGo5Ivfo5VmLJ2pCyJHZg
         CNwzZkWZo4GxWtOW7SIpndbJMWFg9ooYW2EBJgI3qm2LHtu2aLUi6l+VhMvZa0J/0AWO
         QO/KaxqYeZAsvp4job2d8kYB3BCBKkNhIfS4+anh1+2NiZIbi8jYpe9ovBUqL8Mq+8qI
         MOWNDfl1Ah+cwcSu33dUQc73BSa2LpAIoKETBX/2ovOsB1nTkF/mOSkYbVKO4Roh2NHj
         bbjUsZeUgnDIFGFFpzQFY6OoEsxWzZskqNrQhQh20DLX4DMNGwGBcBINwu/F5W5gB827
         qAgA==
X-Forwarded-Encrypted: i=1; AJvYcCUT4HeWlIAeo7Zkc8oJYDuz3uORWtMyjNhWgSJomgw87rpm92Tp0XbNyberoDqMXQ4Eld12xXU94Q==@kvack.org
X-Gm-Message-State: AOJu0YyyCPewIf67gzgjpCcd2BJxEvwXYi1UH7VCRKZeEXQIE24QbdjA
	/2M5jEY+7ys8WGh8p35+7FyQi75/TPS2C49E6cnWwlvrP45eBrS4bA25Rc1SDIarh1U=
X-Gm-Gg: AY/fxX4cjmeuWci5JrAmGfmDoBWmNosA+Q81PgwPkCUScc3rCG48uGVqcMGnkVBQZJo
	y5qNCrNf/pzIXgtS/mfZJCIqtoNg0PcQcPf0WnFX0Mn8SGlCIbwNIdSDXNA0R7Ud21BeZNYaxPH
	kIlz8KuCSOcTtV1CsXxO+2Pu6x6JbwCDd1NBB/EZN/tnSAW8OKOujqVTbV2sAKYo6hB/EAm7E5m
	4p7+ZREMS5M8Vyp20xM+Sni00HTEmpSj3eZ2QXyiFu5LmCd/2E/UU5zVQ2Ei2Fp0wSlrRJ55hK8
	WRhK6tCB0BV3/zlb6vBokNa9dsbOBFxuMedpsY7xhWPzBOiVQlAPzlvFYvCv/rB+NsAPZEqum64
	NGsTBelXYPvb44ODKjSky5LjN+lGSc4APtH00ph00152Tm61YqcthehsMs0DERTYUC0u343EYYn
	eI3sRqaxnjpb1YOgwhTx4ON0IYj45Rk8hqIHU=
X-Received: by 2002:a05:6000:4387:b0:432:c092:ee3b with SMTP id ffacd0b85a97d-4342d5dd58cmr4121853f8f.62.1768408910801;
        Wed, 14 Jan 2026 08:41:50 -0800 (PST)
Received: from localhost (109-81-19-111.rct.o2.cz. [109.81.19.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-434af64a643sm284591f8f.1.2026.01.14.08.41.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 08:41:50 -0800 (PST)
Date: Wed, 14 Jan 2026 17:41:48 +0100
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
Subject: Re: [PATCH v16 1/3] lib: Introduce hierarchical per-cpu counters
Message-ID: <aWfHTLDA8-Fja_gD@tiehlicka>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
 <20260114145915.49926-2-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114145915.49926-2-mathieu.desnoyers@efficios.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6DDA4C0010
X-Rspam-User: 
X-Stat-Signature: sm3zkakbn88ndow3ijd66atimcz4cj9g
X-HE-Tag: 1768408912-783150
X-HE-Meta: U2FsdGVkX18v17gdAwO0jvXru0feEyoYMXwo6uwvh390gOZuNt17gMxDxhbEew0XL+/HWLRLDzFYo9FLyWWAUYXFmtXp5d8g1KSyIDkFZsjFcHnFpIOHIQF85GrSpvBhTNykSDqffZkRI7wF08LGNzZ01AB9xDPbCOVd8s+FydrIfnjPy0u2mQLW/WwB4nPgfPAE3PKCjcxAW+h9Uza83WA3n4AynIDXIURa5cUwIyzH9WpNfZkHnLWZlvCY/nvmyDIV1FzpRsvtVMeodCmeDApPu8yI3cqbixL8i7QEhyKBOj0f20DncGP/KwLgzvr5Y9y2BarYWfchSy+GrBW0z97ER7FQcZ7VPOGNHZ1dORtMHLd5iSe1Hjsk8Q5yMfI8Kos++7NZlD+IFFxxSi7ApCLk6IM/xMWztl7G9L+ekYiC4y07N9WGKOZ3QgzN7ZPmZW51QTadilzE5FC/C7SOEbClL65vn/OwArUVapjgMsS3OTsDuSU07TVhE4Xx3v9EoTAe6UryGXWd5CfqGctawKdO0pwyJgabjBP5qxhejGFRJZKdzeT9XzhX3FSNrTNVr4QAtAyt9TGaWIBvH+uuP6Det/f54MaUlUP7CwA05Hv/hyA0ubgeXCFMnZOlv25BmwbqtLIwKqNqt9pohU/nSKgLqOym/bB1l+SeNqV4dn+DJK0zY848v57BpAfQqnXgjEBjToJhepliwZUoiVIjdQNuqIo/zGgFy9IRGe4WdCGb1fKdKOkDmNnvTc9UHaYPRRfDxwpypXyOMt1itlCz0fcLo/ntmYAhxKa+l6Q3kOp+34DkRFF9ECPpsmNtaMxq5ScmWTHpEva4TShADFX4rnQi/GrzwwpyPh3/ow3Eiqw9Klfz9A56M6J0Feuk69PJL/fkRN8q5FRqrErpBWCzhd8W+MLLApxhylmSKMSEmhCkV/G+L5brhVwCNT3QnzfXOPSkswEQn3ccmC8XKvM
 T04lN56m
 9PrHaJm0qtjBoQfkcBoiTXi37giGy2cdGcE0S5k2kABnuQw+T1RMn0Fv/Btj6Pv0pPxcj2lnwMUycTbjrY1pa85p4tZZLbzVqfKoUTwJ0k/2QAwfr0R5reWpAUlPwjF5C7PtTZCIGm1djRQO1zfEQUymME/AIl6c5iYzBbrLMA/dce1YXDOBwmz9eKyoUHE2/J3WUpyxBDreyakzLQ1nODgICydvjJRtkeHE3mAwlb/Zea/r7ihIRHfdo85+cJgO5sKp2TdxPhWnNyTWkvfvuUS/rMm6geYI6YKDeRLhGtcN9lWOWBXqbh/aKU2H/HMFrITFhtT3E0JpkC61B3s20fg+JKA4Sytj68d2IxCCKHsCuxjD4KzC0URfegZuj5u2b/s+j1vg8JGFiY/bvw9zJudMpS5J28k3BDDBVTF5LlA0JYZY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-01-26 09:59:13, Mathieu Desnoyers wrote:
> * Motivation
> 
> The purpose of this hierarchical split-counter scheme is to:
> 
> - Minimize contention when incrementing and decrementing counters,
> - Provide fast access to a sum approximation,
> - Provide a sum approximation with an acceptable accuracy level when
>   scaling to many-core systems.
> - Provide approximate and precise comparison of two counters, and
>   between a counter and a value.
> - Provide possible precise sum ranges for a given sum approximation.
> 
> Its goals are twofold:
> 
> - Improve the accuracy of the approximated RSS counter values returned
>   by proc interfaces [1],
> - Reduce the latency of the OOM killer on large many-core systems.
> 
> * Design
> 
> The hierarchical per-CPU counters propagate a sum approximation through
> a N-way tree. When reaching the batch size, the carry is propagated
> through a binary tree which consists of logN(nr_cpu_ids) levels. The
> batch size for each level is twice the batch size of the prior level.
> 
> Example propagation diagram with 8 cpus through a binary tree:
> 
> Level 0:  0    1    2    3    4    5    6    7
>           |   /     |   /     |   /     |   /
>           |  /      |  /      |  /      |  /
>           | /       | /       | /       | /
> Level 1:  0         1         2         3
>           |       /           |       /
>           |    /              |    /
>           | /                 | /
> Level 2:  0                   1
>           |               /
>           |         /
>           |   /
> Level 3:  0
> 
> For a binary tree, the maximum inaccuracy is bound by:
>    batch_size * log2(nr_cpus) * nr_cpus
> which evolves with O(n*log(n)) as the number of CPUs increases.
> 
> For a N-way tree, the maximum inaccuracy can be pre-calculated
> based on the the N-arity of each level and the batch size.

One thing you should probably mention here is the memory consumption of
the structure.

I have briefly looked at the implementation and concluded that I do not
have enough time to make a thorough review. Sorry about that. As I've
said in previous version the overall idea is sound. Especially if the
additional memory consumption is not a factor. I will let others judge
implementation details.

Thanks!
-- 
Michal Hocko
SUSE Labs

