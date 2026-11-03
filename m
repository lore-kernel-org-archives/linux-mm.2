Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EC51606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eWTqrsFV
Received: by kanga.kvack.org (Postfix)
	id A720A6B05B4; Tue,  3 Nov 2026 13:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A423B6B05B9; Tue,  3 Nov 2026 13:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957EA6B05BA; Tue,  3 Nov 2026 13:29:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7924C6B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:29:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00EBE160287
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:29:02 +0000 (UTC)
X-FDA: 85394644566.16.AB6D06F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 154DD20006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:29:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eWTqrsFV;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793730541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A2SxbtdInviKmhuZ6qhITPKihTTKCU8zqlv1zCWXFFY=;
	b=6BB3ztCX4FxmcD81xjLdUypnoeCUosXdXRTVlrnDpVtfz6kMH13Yvmd+/EhG4phCkAk54a
	1jikBwtXc/FvZVB9IK8jh3sW+2KvhVM0HhQs6D8jy62iBsRuqwkWkFRSEVryQIdIV8jpXx
	PWo7wkw0rE4ZhOZFuIgr4CWj22EpN3A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793730541;
	b=CgD9s0D0u879AQ0xf9lNGByR/TGL/McDYU6dHusl63S1ocaPIR6eozvaHf5YcfZPf/kCTL
	nieS2YcrHH1wOw9OSOrF5+mbANsyuIEiWxDFvHfyzcyC6l/KP3s9enaa4kpjn8IZS9aLw5
	eszSyRCbQPgq1bEPcgiBFZETEtR0BKM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eWTqrsFV;
	spf=pass (imf13.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 498A843CDE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:29:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41D61F00A1D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793730540;
	bh=A2SxbtdInviKmhuZ6qhITPKihTTKCU8zqlv1zCWXFFY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eWTqrsFVSCOoYkWO6JKwgxZuZbuyGCUqOjMv2hJ+fgZhXiUMArt90EvcdZH0kBsPm
	 SKpH4PJpntYX3RqET8dHhFZdjNDDCbJ2M2SKJjhf8Q2JAgYkrkte9awr31Hr44qSmq
	 ubysmm8JJKzmgJ3UPwM7S90X8doOeOlcejbs0IeS5W4D/ZU/sgpni+vTjlGPegD2sU
	 d9k5eaYNOJe5pu9tVWan1knYixg7QPfXH61E56pEmGWzVHyXLGd5KgOdGznJvs/1G6
	 +6jPHvaHyZ9aGhQJGPKTO8xZ4TItOjfrAMsZcvKEld2ozllOt+Z2Vc1GeUupBwhDQ1
	 BpcAZvVx6btBQ==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93efc0452b5so292227985a.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 10:28:59 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwfvEL66XNTb/9/8jvVzA1CXsDz1G+GU3Gy/NoEBXRTEIeY6BS+uT5/b5M67j0HVvzuAIiwtcf7Qg==@kvack.org
X-Gm-Message-State: APuU4Z96d+dNYBR0NE2fTUYK0d5DA8OEtMkXzIG+fTfp6RVKAyIU7IK2
	x3Duagnqe2CR4nt0+Eb4ETirL9/ctD+q3Z/R4tFj4X3eG31meswb+av9I+EJZUcKEaxYWfucxud
	wdc5wMvYnpEbDpyE5Op1PRyU77qEPpbo=
X-Received: by 2002:a05:620a:3196:b0:93a:824:ac8d with SMTP id
 af79cd13be357-944216b1afemr2371370885a.27.1793730539153; Tue, 03 Nov 2026
 10:28:59 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev> <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev> <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
 <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
In-Reply-To: <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 02:28:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
X-Gm-Features: AclHuK8ocj8au7qeT_BVvieNJJ4o0s2vwCrhyBoxk-38BXmuY8mPvZOfmLABhGE
Message-ID: <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, 
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kbjrdaaaj4guyjontd1mku73jodh3rpj
X-Rspamd-Queue-Id: 154DD20006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793730540-766996
X-HE-Meta: U2FsdGVkX1+BbOMWo5Ao4c2YClpI8m4AHLlDxx7MtqNwh0LVeVjpHM+DWs8fCmUG0ils/YoEHmke8UreIJYQhD6Eq7/z+FgnQzu2xO3jx71oTZ+yL889DlP+1EmqyR9fYzL6ssqXJ0Ib/y5vcY5GUVDCw3us27Qm4dOqm6JaSn/a6ilPX8Rdkgu7Ze/S+ucpkI2bBVk/QoNydMZSbYgjjCXEHtO+zJe4Z0mIrtVCFJgtUka6VNWaoYL0fmUKgk23mcaUee0NJRfvKLsa7qtGjap7Ho6odimp3gofeAcaQPqDY04tNaHH+RLc9JDjtGH0jX0u0jNDY0cA6riVR6Fkff0PGa2mMfVkxwCvH6+GPmZ4WhqnNQqgaDiM0WNjj9z4zRkOxVIvEwGUluM8CLCoZ0fHd4WyUCSLRGBnNbMRu1Z3JTwjhQYV+b/IDm0DGJnfOksAxYFPUSkSxbQ8QEqBwZL1cUif3hSH1ZhTrdt/Ilgs2Gjrpb4NnOkjU2b1CiWXGdGLtdSktd5PTFnu1+OzGogeD9/2xsd/5vRO3NjM3+vHwrvdbL2ZvNQwuzDp84pv+wRurMA4GxOFS+GzbusWjC/Uc22gIXrs0fyIM5KHCM/Vm0LM2CwxscBdWamCp+gSgWF9kNNPy1opTqZ1746im6Y/g1a868AMyyzVgWnBZD2WYO7UzBTrCHOsyXKt4t6duPSAi5bUGLHcSfP9ZxdkoW0sGgCerzAx4o5o9tfq61rci2vLyIcqqhvNcaxiSHbDtV7U+D++E7LXUOiUeVZ0DM7ZPPnCX/QTUtWb8ftERMP259dMVdBDBWohIpkrXakinGosm7auHscQ3IzDhidQOwdilEfiOgYUl+txGS1xPST3AQe2K/H0oYT4ghVsBne41KH3ec+HkbYGDpuwvex5ehVrXKlF1A9rbk7fDje/QRMbNn2Zhpdp1uwVIt+7Eeff2zaYO2UoY/8c7ka2YR2
 CGyzQjfE
 JwP9Smj26JU872ipqJcf0lZUGXrVB6YGVkLn5H+0W5CTerxmlfzypLV4wHxWWsighGkkvzN4xVVnjUKZgVn293w3OqO7dR65gf0TJNgSpX4WF61hhEeGiMS8OwclhxE+8j6lvTULFl/FH2Thx+GBpABrKqfMAxkFyLLYtBfRGhbt6Xa59bHnnmpwiPOEwqeTaoQawyCkmIeoUfpUpcD/+klCw9wLtXmOroayNe854a1+JNtC87mXYqYmrXCt6KK0wN4kxWC1Wut3P/lQKB9fqNWMKsEY+e43jTQ69Oo9fwPFcuCIQaiJf1eR6b1MMuYTI846fzSvwpRe0fCQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 8:23=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
[...]
>
> Hi Barry,
>
> Agreed, I'll go with option 2. Two things I'd like to confirm first:
>
> 1) To report the reason, should_run_aging() would need to return it
>   instead of a bool, e.g. an enum like:
>
>    enum lru_gen_aging_reason {
>         AGING_NONE,
>         AGING_NO_EVICTABLE,     /* eviction is not possible anymore */
>         AGING_MIN_GENS,         /* better to age, eviction still possible=
 */
>    };
>
> Or just report sc->priority, swappiness, max_seq/min_seq and the
> per-generation nr_pages, and let users derive the reason from them?
> The former is more direct, the latter keeps should_run_aging()
> unchanged.

Right. We can let users infer the reason from max_seq,
min_seq, and nr_pages in each generation. This shouldn't
be difficult, especially since should_run_aging() may
change. We don't need to spell out the exact reason.
Just present users with the overall state of the lru_gen.

>
> 2) try_to_shrink_lruvec() has changed quite a lot recently, e.g.
> Kairui's reclaim loop rework, and your swappiness series also touches it,
> including the aging part. Is it stable enough now to carry a tracepoint t=
here?
>

Yes, I think aging will always be needed, regardless of how
we change the code, so this should remain stable.

Best,
Barry

