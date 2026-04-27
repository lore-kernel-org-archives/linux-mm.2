Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5D3EFF8868
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24EF16B0088; Mon, 27 Apr 2026 12:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 226386B0093; Mon, 27 Apr 2026 12:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162D36B0095; Mon, 27 Apr 2026 12:31:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A02C6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:31:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 00DF71B907B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:31:07 +0000 (UTC)
X-FDA: 84704875416.25.22150C0
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2114A000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:31:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a89ihRpL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777307466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMolR2fifT8xuTtrcKtIWiBhTS5Vkvrx+dwt/cFeq2Q=;
	b=COnr8aKM/Hom9hN4d5HejaycDwjQMy1+nN4gxzjcemjPtMep7HHS9IVUntyvxp+HgVZthm
	4Ecl1k6YCj99mVULj5TQor/NThzuuGETeU9Bmp5y8QbSwqvfSP5lAcSdQF9b1V21xZPv3R
	9D9PwUwjw1EqavxqTUc5yW5GzB4fnU0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777307466; a=rsa-sha256;
	cv=none;
	b=qFjq9AWbvW06sfcyIxeBY0iBnvc19HC69xzbGbeq2Pxt7Gel/mgmyxlEoMbkqBM8GRSm0k
	RCoO4wfD86ptxCl8YYjz7YmzXOxFK4ZJq0QkBwH+0i7r49jcMh8RIjMS8e3p1wyl6gAO8y
	mM/NiV0YX2AjfrqpnD/hGG1LtJnNJq4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=a89ihRpL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8dbbc6c16b2so1317407485a.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777307465; x=1777912265; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OMolR2fifT8xuTtrcKtIWiBhTS5Vkvrx+dwt/cFeq2Q=;
        b=a89ihRpLj867zFF8LUO+7zNKJNsin+pxz+77i9KAXTvIjl5mGO8H00/pWKoER4kie7
         Mx89NzORTrnQCHdXtbm/DgEzYDetcJX0zx6lHwylgJdskakDR/T5v8lxOSWvuDF9MOL6
         sEQgG/i3b32EioPTwKGqoddz+dclNIeBbGAOWezbua/AwaJn1YwWPF9ZJw/OaE5xw8oT
         LJTxxjJp/81UArSfQSgRTFlmtRLfkSm4GpR4uKJyNgJhSqQgJwct5lYSS+xZto9LHmMN
         F8rTLnngFPfhIQURrOQAYsuJvCKvdErehNdL4irkYeWmOxdPZ60zea8gnjUHTAz0KQVN
         Jnhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777307465; x=1777912265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OMolR2fifT8xuTtrcKtIWiBhTS5Vkvrx+dwt/cFeq2Q=;
        b=pwl+QJfNP3igM+EnPHAmvjxXuFiOIik7rx9ntgQzbiiRXw3WD0pdJbDo3YL6z8GiyX
         GFN8SW4uCrTS5YWBR9MeyJVZ11TLhRU0xkoYaqKsis3M46+mrHPxWXFo4aZ2DL9Ckt/s
         zD5/li8W0pzQeiUveGjlC1zdUcvuF+Yq1z9O/LZ4y/gsQLuIIsHx0UtiY4GlgWnxsr+C
         W/TA0uSrPV/+6OCqcP+qZKCcLokS/Gcm7oAspSutoxlKTh2+PlGOWtrcADV6hmCzPizp
         PQtSRRW+ryrj/Vj42pLJHpuca8EJdmtzAHazepO9ePaUddEnciz7Xr3icIPwH/eXvvs8
         0mgQ==
X-Forwarded-Encrypted: i=1; AFNElJ/DU/DXgGdBJrd7ADgW7P9OcMw7pcMh/mOmm2rMvQmfjzXpaBlQsUs3Z/OZ1Y8ebIQXd2lVucRObw==@kvack.org
X-Gm-Message-State: AOJu0YyYZI7EicRLLBfQ1Ns6nc4rJSQ+1mitRXpMAQvzjy07BgpYqKzf
	fVeODHssF3PlqVRpvX3c8ZREgg+tj1DhnCXvV6IHAgPuGVDGdYQ5E+BnwZyw+/WeEMw=
X-Gm-Gg: AeBDietICKahXw5q27lGsbQEx2NOqd15/K6xxz7E2NopQaxFNTDEAQJSucnfr+Qqssq
	lLIfn6KnyZCsd9tqyWN4P4qETc7BIiEYEv3Inw6PkzBPpyd66YRysk4Ay2Vv0Cfq1osxqzCmc7C
	ezwzAIbzAfX2FzGJ3aP0ZmSaZYHTsDCfxPsJBtbhubgGOQiuzdzHsWLFCFdQehkhtoP5mgA8cxp
	NdOnUJGsxkqnRSwQHbTNbVw4EVfndZv3uM3mxEkKj/nWbJLkkYDwucGzCCut5A+lPLlJuvDqYe6
	gUkmabkZk8Rv5tmgS97YeIhgra9AVqlK26B84VKZqegh2v6FeGtQYChWSaDpr1BVvar195PHOjB
	/Q7+nEuM0uyDTJx97jw0Wb02cqk2AOHThGztoIlKSBTdr4lguIi08r0getnASRD5zZvGvAhEzxb
	LjQx66G35HojlwLKqRSOMe+ooFFDhBWvxaV3PEHQCcoicRtGC4jCFETtIvD1AOIzj30AMdZKGM
X-Received: by 2002:a05:620a:31a0:b0:8cf:c537:e0a2 with SMTP id af79cd13be357-8e78a52c89amr5128094985a.15.1777307464610;
        Mon, 27 Apr 2026 09:31:04 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8e7d64caf37sm2595104485a.11.2026.04.27.09.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 09:31:04 -0700 (PDT)
Date: Mon, 27 Apr 2026 16:31:02 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Hansen <dave.hansen@intel.com>, 
	David Stevens <stevensd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, 
	Quentin Perret <qperret@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, Andy Lutomirski <luto@kernel.org>, 
	Xin Li <xin@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <ae-DE1lC6-zEA8Zi@plex>
References: <20260424191456.2679717-1-stevensd@google.com>
 <da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
 <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2114A000F
X-Stat-Signature: acggnqor4gupi4kk4y9ykpmarfxobwn3
X-Rspam-User: 
X-HE-Tag: 1777307465-165784
X-HE-Meta: U2FsdGVkX1/KdLuU3jR1WSYCAjz0WOc5Y4LpDqydzlwN7fiu8kQVpTfscbgZ7Yk/HmgOQDCc1Nug6f6rfdM5jd+04Mx9CqAUUku4Heml8rm+8xgru+mTvuT/c4Xft9DqILwDEYnaGaWOAQiqT8/nxiLqtDTZzmyt9NFGlic3Hj10Q93zkWhwovgqr6i1RbtT8eyU+nDnDIB3u4I75Y2+uYoOkON+TeqFK3aLwe4XeF5ROr5MkNVioFfRj7Bi04nULeWD3N2AfCntDKd1l7H4Jf6LCgePiPPPjpkDkNvIYpprEoanZrZMib7Zs4X0xET0pr6dDHwqSGr9Zf0rbwEwPjWkKuhyWAXE9Ne3E37aguPsqQ5rdXE9+Zv2kaTcM24PwvgEyGffhh9DFVMzB8gzZFgKec9THHM1dHcJuf6HBCply5L47/Vrw3+Ei1BSu2oGq2CXQibJuMjhGfm2qScHSxRP3DY4oEi204VUznIMlG/XvCterLxovvVV02Gf9DvJ/tYzYoT2d2rGC6V18bQKFvAlHrGYcngVnpQbSkxp+l+jd9oSSJwSk1/vYyWibOu30upP7tcSVArXxq/sEffqfUSFPQjFkrgqjAN74LUQCO6KQcvxnJun7djATkMJUjlZKyaQbeTao8wQ5uiyjTWs3mDtF/jHiRkiQ1V5yWOX0w1M1FIqsG3MtWAFn9DTr4nJAwMPs4BidlNietPmuueXlr295MG1LH0zHeQnOT0GJ2caA1mCZH9pr0MNagIMC3dmecTB26jn+d5nefWHqm05RKrI8s7L/b3tIqhI77jTCcIP60oKeRRKY2HwWfiDhDH83KMjJCniznzxG4AUqx5sZfDIB6Qe2Cs7xIc3fdlIZrYqCSXTant0DZyeF8dNkqQtNxBi0ifWDx+jhj0mRwR5jf3lqWnCrIiJYV1brfmUswXUPhqayV5OlMqG2kwkPpVo7aKIZyQ0HXLnJiSM39H
 3C1nJqoe
 TmshleH5VRuz7fHCtj4iCsYxUGBCsqJhw5n4ZZ+0eqQuJWrqOkEgTZb3XbZov2YPQmR788kQ6o9bH/V5FbzvOv+YAAHvntJPkcxKDmuvHiXlJH+dkkM23vLBa+bCvePD0q1FHo256bOoRDzRS7YvvDy36fdxbREqRuVz1CC/qUBlnLecP7zCzm0jF6SxDipdu1GvydC1TDbicRUHdljj51eesILGKum7t0/EyanUAy4rBjP69SbcvOW5+d0kP169BkoQjxrrTH77jMVsnDyIRugg18RLmlsw7TzGw/NabHnLrmi0oqu1/piv53A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-25 02:19, H. Peter Anvin wrote:
> On 2026-04-24 12:41, Dave Hansen wrote:
> > On 4/24/26 12:14, David Stevens wrote:
> >> The question is then: is this approach something that is fundamentally
> >> untenable in the kernel
> > 
> > Yes. Fundamentally untenable.
> > 
> > Not allowing stack faults has been a wonderful simplification. It's one
> > of those things that just plain makes the kernel easier to maintain.
> > Saving low single digits of system memory is not exactly making me eager
> > to go back to the harder-to-maintain days.
> > 
> > I seriously doubt that this 1% is the lowest hanging fruit for memory
> > bloat on these systems. ;)
> 
> It is worth noting that this was one of the VERY early design decisions that
> has shaped Linux from the beginning:
> 
> - No swapping of kernel memory
> - Kernel stacks are statically allocated
> - Physical RAM is mapped into the kernel at all times
> - A "monolithic" kernel using function calls, not message passing
> - A kernel interface that closely maps to the low-level application API
>   (e.g. each user space thread is a kernel thread.)
> - Kernel ABIs and APIs are subject to evolution; stability is only guaranteed
>   in user space.
> 
> Those design decisions are, by and large, what has made Linux Linux: a
> relatively simple, highly performant, and reliable system.

I think there is a bit of survivorship bias in that list. Originally,
there were many other foundational assumptions that have since evolved
as hardware and requirements scaled.

For example, there were assumptions about no dynamic hardware
reconfiguration (no memory/CPU hot-plug), uniform memory access (no
NUMA), and fixed page sizes (no THP or HugeTLB). All of those have
changed, and you, better than most, know of many other such examples.

A more recent example is PREEMPT_RT: the Linux kernel was originally
designed to be non-preemptible.

Even the assumptions in your list, such as "physical RAM is mapped into
the kernel at all times," are evolving: emulated pmem is not mapped, and
guestmemfd plans to allow unmapping memory from the direct map for
security reasons.

Aside from trying our best not to break user space and allowing the
internal kernel API to evolve, the other items are architectural
decisions that can and should adapt to new requirements.

We now have machines with thousands of hardware threads. Running
millions of software threads on such machines is a practical reality,
and at fleet scales, statically allocating kernel stacks for all of them
wastes a massive amount of memory.

The proposed solution won't affect Linux as a whole. It can be
optionally enabled for targeted configurations. Additionally, the max
stack size is still statically set; it simply isn't populated until
actually used.

Pasha

