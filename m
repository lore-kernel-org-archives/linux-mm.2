Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E973ACA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 08:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9F56B0088; Wed, 30 Sep 2026 04:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AB16B008A; Wed, 30 Sep 2026 04:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880286B008C; Wed, 30 Sep 2026 04:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52CED6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:08:50 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 315C9140600
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:08:48 +0000 (UTC)
X-FDA: 85269702336.07.50B189F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 88CF5C0007
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 08:08:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XggV0HEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790755726;
	b=ajhe7W7o2OTX1aOeektOu3VPdz4HQoN0rtdPWOZXURrVEjKWq9mwc8jtu4Qht5RMovngeq
	EdjUjRXWzr/N2lgHChUF0NP28T9rBsfXNgtuWLUbSELYXNf+KQUirwHFkfBteiR3lU8/NE
	lfihrsEIa0Ew6xK95CaPw30pQKM7nG0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XggV0HEx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790755726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgiI2zzwe8TB/ZW7XItAedr7ZYnB5/cnPC/QFupZv60=;
	b=yLXYPf/59tT+DrCGtdqckCeAMKyvdUlvSEL31A2MvVKTy+nhCym/oYrqCwtUbutalDOiJ5
	C13Xyn40LpORIWSF63nKppoKqKKEQOMi0BxaGxy/cmqYQgIDlfbu+/bhDcDOpbpM3lbLiZ
	1M3nmwRPNkvuHocMcvg5rIEXNvHGhJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BC9DE436E6;
	Wed, 30 Sep 2026 08:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652C11F000FF;
	Wed, 30 Sep 2026 08:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790755725;
	bh=EgiI2zzwe8TB/ZW7XItAedr7ZYnB5/cnPC/QFupZv60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XggV0HEx4iFhJNOcs0B7+qgnbnzi6NXR5MD9WbJ7i65myhUAHSTmNy6Ac7ZhgF93d
	 2vR5/dLU6+PjoDXGP0wPigAZTRWnD4cYe93FRgqToAC/9KtR1TRCOPpUfK1jTaFzcg
	 3QSk8SN+ocw23C9X3rs/lQqj5dU9+xFAZcjAq0qKugUCSA5GX3Lg/OQCQNttM5ycih
	 yIRoFMzfv495BHVUK4a4Mbe5MWHkXqbu779h24yeOclupcxVOTD6VmFgL9EsiFqOtM
	 VrzmxBcdP4ebr6Sk9sQI/LUDhMnozE4r0E2FYr9xxMez6HkxaAA5nDEzc8expHpxR2
	 P8GOR9B/XDPtA==
From: SJ Park <sj@kernel.org>
To: Lian Wang <lianux.mm@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Jialiang Huang <huang-jl@deepseek.com>,
	lance.yang@linux.dev,
	KunWu Chan <kunwu.chan@gmail.com>,
	baohua@kernel.org,
	damon@lists.linux.dev,
	david@kernel.org,
	linux-mm@kvack.org,
	mst@redhat.com,
	ryncsn@gmail.com,
	virtualization@lists.linux.dev,
	xueyuan.chen21@gmail.com,
	xiang@kernel.org
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Date: Wed, 30 Sep 2026 01:08:38 -0700
Message-ID: <20260930080838.10887-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260930030747.47294-1-lianux.mm@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: rh9a5z46tumieffbgwxpdzzpummi9znh
X-Rspam-User: 
X-Rspamd-Queue-Id: 88CF5C0007
X-HE-Tag: 1790755726-969041
X-HE-Meta: U2FsdGVkX1/liABhBKFs13jSYItXnC02pbbR77sSkilwo8czoxTnRcid/GwVClKOJh7F+SydqxT20YVYoGEb2Xj2pChz3gxnX4woYyuImrCYCrQj3Qrar4LT3q0pU5HTw/aV6SYfA1TmwLX+g1+VF9YeeoQKwcu3rfLm1kFc5wdLqLd14yteLul0QYPp8PMzudlUmcSxZjrKBzC3hwzCh+DFtY9U0JRVg+JjstASCbyVC7rV1pOTGywdWHv5HjMbAwXI7EMsGlNzuDMiQ4mPZAz4Fl3j6SM6nbRX29z2FB4/PSmqUq9zEbK7NtXnvpT+9PR04imkmHqf9a/DvL+coIJzegIfjS/dCuzXbyd+vFeLyUNF+O/ohFol0ee9eKygsN1qBWY/m3vtwQwJyvjZxAqqiDi5msMB55WUiAnB828K7l/wCXXOBGm5jb3FBvTsM/co7GWrmd6rVvvLGY7VByE1Y3c+8VZs6Sw+GMPuSpsVPMrhy0fYb7pYUUIlhCwCcygvVcz2Ylmq7jwdrx2dEKNz0+wMdRWf53LedM4npKeuI7I2QZfkiZaQEwcYMeqqSDirc0tk3ukFuzI2rlsHKobMMrDSd3ge4FaJw9ttHS0bt9HhhS1F183WtkGOuotGhKoIrM+VKysMelpWy7klWCsFSMenL0vP7sinDlpr9MKwXPpgC/G1IkAPyD4JAjgk1BjFD0QdOIHMQxRGjgSzVOmcmS9dXhOlkq/e+XGtSte0+GbrHeAOQscG4yARcUNEH9J+ePVli3PBXgyxsjAwJHE2iMNyl9rmjEl6o/85VjjrDLK36+0CTlt5QKe0GmBjQk/7lQ091ueKziFQeJSd+bbWu7rret52qsKYZkhvcspGIbxFOJEeciOegSXuZvSClILThE/Vucc/G7GQsCVDZluWv8wtMs7pWm+DExM+Ydsa/OGYGZx04VzZ/LhbKcZOgxJkrPRXNslvYEgquwl
 nrBMdRL9
 hUeqT4JyDBW8/wO24nrXVc/rYGU+3fDDMf+Tp73mo9kv/uxuoag033Z0H9r6EDYPbs/Lr7o1mP5Izyt8kcF05hCL/kd74ctOai6sTA4grV/6Ngsmr1T2SJA69olOkxMmgR/vlnFNBGta8L+rE7/aYig47d0JTmleSa77VYmlFOQ7rQ+sg7m3sdOIwr+huLCY1/zOQ4zI3MtssSCWpGah8x7BhOr29vx6Ytx5QTytmKAkIb7880U7dSmYSpp01wjQSse+PdSmQAcg5kzlRrc3bJwqgYOdIDaPQCaQaYYiaRrFFKzPMxnudn/OocG90wr+t9Enz6tugl3plTsY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lian,

On Wed, 30 Sep 2026 11:07:29 +0800 Lian Wang <lianux.mm@gmail.com> wrote:

> Hi SJ,
> 
> On Tue, 29 Sep 2026 09:56:03 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > I agree the reclaim-reporting granularity mismatch could be a room to improve.
> 
> Thanks for pointing us back to the Access/Contiguity-aware Memory
> Autoscaling proposal. Jialiang's description gives us a useful deployment
> context and a concrete problem to investigate.
> 
> The guest reclaim/reporting case and our host-side THP/tiering case are
> different, but both raise questions about how workload behaviour and
> monitoring granularity should guide kernel actions.
> 
> KunWu and I would like to help move this work forward together, alongside
> the existing DAMON roadmap. For now, I would like to share a few possible
> areas for discussion:
> 
> 1. Workloads, DAMON policies, and tiering. My current work includes
>    improving masim-based experiments and studying TPP-inspired memory
>    tiering. We would like to make the workloads more representative and
>    better understand how DAMON's observations and policy settings affect
>    placement decisions. The aim is to understand where configuration
>    changes are sufficient and where code changes, if any, would help.
> 
> 2. Testing and contributing to the existing PMU work. Our initial focus
>    would be on helping with the Arm SPE integration and testing the IBS
>    and PEBS work on x86, in coordination with the people already working
>    on these. The experiments could evaluate whether finer-grained
>    sampling provides useful additional information, and at what CPU
>    cost. We could leave huge-page-specific mechanisms for a later
>    discussion, guided by the results.
> 
> 3. Following up on the DeepSeek workload. If the team is interested, we
>    could learn more about the workloads and tuning questions they can
>    share, and study the path from workload behaviour and monitoring
>    parameters through reclaim and free-page reporting. Pratyush's
>    reporting-delay suggestion adds another useful dimension. This may
>    provide a practical starting point for revisiting parts of the
>    access/contiguity-aware autoscaling work and evaluating their
>    relevance to the reported workload.
> 
> Could we discuss whether some of these could become follow-up milestones
> in the DAMON discussions at LPC, or here on the mailing list?

Thank you for adding topics to discuss.

Of course we could disucss anywhere anytime.  I think Access/Contituity-aware
Memory Autoscaling (ACMA) could be just a parallel project.  It doens't need to
be an extension of, or blocked by "beyond-page table access bit" project, in my
humble opinion.

ACMA is still on my TODO list.  It is mainly a matter of prioritization.  As it
becomes clear it requires more attention, I could allocate more time for the
project.  There was a user showing interest recently.  I'm planning to
prioritize it more.  If DeepSeek could confirm their interest, it could help me
prioritizing it further.

As always, coding may not be that difficult and take that long time.  Testing
might be the biggest challenge.  I don't have good test infrastructure now.
Actually the lack of good test infrastructure is one of my biggest DAMON
maintenance concerns nowadays.  Others' help on testing or test infra would be
super helpful.

If someone wants to implement and contribute it based on the proposed idea, it
would also be nice.

> We would be
> happy to help organise the discussion and take on agreed pieces of
> testing or development. We would also welcome closer collaboration with
> DeepSeek and other interested MM developers, including Muchun, where our
> work overlaps.

Sounds great.  That would be super productive collaborations.

> 
> This is only a brief outline for now. I plan to bring the experimental
> results and remaining questions to LPC. After discussing and aligning on
> the details there, we plan to share a more detailed proposal with the
> community and write up the planned work and experimental findings in
> blog posts.

We could keep discussing in mailing list, but of course in person discussions
are always helpful.  I'm eagerly looking forward to the next week :)

> 
> I appreciate how much is already on your schedule. We hope to support
> the existing plans and help with agreed tasks as the scope becomes
> clearer. There is no urgency to reply; we can discuss these ideas
> whenever it fits your schedule.

Appreciate your continued and grateful contributions, Lian.


Thanks,
SJ

[...]

