Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4C67C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:36:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C666B008C; Fri, 14 Aug 2026 20:36:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C956B0737; Fri, 14 Aug 2026 20:36:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969D06B0739; Fri, 14 Aug 2026 20:36:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66D5A6B008C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:36:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EFAEE1C0BBC
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:36:39 +0000 (UTC)
X-FDA: 85101638118.21.1668EBC
Received: from mta1.migadu.com (out-98.mta1.migadu.com [95.215.58.98])
	by imf25.hostedemail.com (Postfix) with ESMTP id ADE02A0006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:36:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZXtZQSeP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786754198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svj6eOFrSzzgJ1SOMS5+gToyyJbmaJHTkL+aw8mGFXw=;
	b=vSw7XuHqfmOc9stV1IMMHc/XMtjWaoNaAPuWEIwO4ahA8OrBVGECekGMSkp+w3yyGJulFY
	61xc7sJ67f6KaX4YshcPGWg0RJPHOw/nphLZvSVSc3ldyTBD69mPXLz7yGi8sBI1QvRFst
	fmopUm9abgcIppww1kq1oPnUQ6UEaVU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZXtZQSeP;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.98 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786754198;
	b=oXD/8tFR35l4NI8w/Lt1IUHyzbYZCE1x12ArDbsfkxQndH3hI73h0yph2S5eqprWLDEf4T
	NyGrM9rEsGLxKiC8yfbaRhPISqz70uNdjRTJud6+0f4DMlKxEWLsekZlma3G0Cw3jp+sXH
	2TIKJOLmBmSc6B2S+9DhYKkF+fHs28E=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tQFdd/qDklLAKb6V+af2UY+3ml4uiTf2rWfzA7UGu7k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786754194; v=1; x=1787358994;
 b=ZXtZQSePINP6hmH8ZHrgbAbxxJ2mLa41IjkEm2dUXKLUcHfyBWppffUu/E0xWfmOvbyNqyjl
 PMkAD5Vn2TlQSod2eMCZxJVzzu/dffreRYPoVDTYh2IlWXVKeV4T66p8x4by9Bnx6lFNO6eGS19
 /HpysRbRvp2+SrfXcqgXh5EE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:6::)
	by smtp.migadu.com with ESMTPS id eb90bf85938a14c4;
	Sat, 15 Aug 2026 00:36:34 +0000
X-Migadu-Flow: FLOW_OUT
Date: Fri, 14 Aug 2026 17:36:32 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Barry Song <baohua@kernel.org>
Cc: mambaxin@163.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, 
	akpm@linux-foundation.org, david@redhat.com, v-songbaohua@oppo.com, hughd@google.com, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, jose.fernandez@linux.dev, stable@vger.kernel.org, 
	syzbot+e12bd9ca48157add237a@syzkaller.appspotmail.com, David Hildenbrand <david@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Sasha Levin <sashal@kernel.org>, chenxin <chenxinxin@xiaomi.com>
Subject: Re: [PATCH] mm: swap_cgroup: fix NULL deref in lookup_swap_cgroup_id
 on swapless host
Message-ID: <an-yt4a6td75VvHw@linux.dev>
References: <20260814074705.939721-2-mambaxin@163.com>
 <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4y+kGUH7TjKEGU+hbwCotHeubNdbJtoBExP+Ya-Wf3fWA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: ADE02A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: m1ru4uws46n5k5kz96owoksm4hheof9q
X-HE-Tag: 1786754197-357541
X-HE-Meta: U2FsdGVkX1/XiUXLNi4BC8mloWLZyfbIFjPKykcHRqdIOX9tt/CDCTt20cNfTAOszoubPJQ2RM3ovp/VdexzspTKqdslcYuGGRzd0fnBi7QG9BalI7PmOOrImRUPgeFiBZIu91Mf/1SjsEBN+sPP8A4ALJRHd2aeaIZe/s7dGduOIvK6sVfZPurHxnkG4iSDYKWf4HdeTueSNpI7g3GLSsDDzqFkIK9WIrY7tlCeGJTMtabOel85a6P05i3uFl5mWWjGEtn23GestsTd8EhpCwzJyL1h4cSo6aDZVBBFUoSTjXaJULkQ/j7ZLwNugfjOhH3a3ui0q6lPlh8/TVSNfTNwcwc4x0GS69X66NilLbP4U17fk/l1Ws46BzY/WRmXSKw4j09BXvVEWVFvxP3HT7zf8IgnJ6n7R1+HSwlFOD4Z0wVG0InfNB7Qk3hhXr2LBx2oMw3nl/UZ8JRExPPr4igT456m3PieQzKEl+6WF3gEujYmrCZmWLVYF9n1S14RkDAFnpxcqsxJzL2Oo23m5tbNasr8X2ZYxiDglLHd4bP8hvq+/83xo3dq6Ciw7kfWqc/S/LkEETF6UpqriESNi4EiEIcLJjDU+zppByGxycMDOEpoQKQ9RyJ47BYTpd7y/pCfIH1Aed/h1KPdijv7FBgAs9sQOzSQKa3k221ejGcS9B/YL1R06bWfnsTq4RX5rC2a/MDOcTc+pH8q51pBufrEh5HitVM6qvNatnI2rDvN+lHUWYey/3zvmU0QhCpH5GMeA0zEonmOhXAaORduYYwz11Y+xRIvFTFddyE8DcQfcameDpPFeH2w5Av4pALkkmyx7gSzxkeDW7Q6QHeTsfwA3dMxV4k29ahC7yB7TCzQLJ+LQzZHQ9t5HaIaECkJ4nooWrDz8GlqFN0nlSaspBRUGTv8mw/E1oBhD/vVDnWpWBb3CwvERlvnm8X0irjuLnNzFUTd+qCa/6S9JSP
 teMcnwDN
 vb17MaG7CJWGyJmz1W95O4/fttfNZa5313g/jzpXsD9KcEk4nCq9yJ/LIbJcyZBQOoZfIhmoivTvHQcjnI9VeQ+NBDwSEgIWAqQuglDCPWfMBHH843SCk4AhYQBVbM/C2bNx7d3aclgBfwkjqnWGodwOM4AtCIgmPR9qbyBAdLE4A9ia4DskWHCBpaELaF+s0iaMbJ1YkTd+79nz1wXUiGLfqTq9CyUrdYnx9nq27MJRUKjRNvv1HZ1na9J3fepOFUJedtz9X/f2URZMT75nNnMSF6lcuCM7DG7KnMH5iOzgwgXqGrtMPoTe5hP/G9G68Cw0NJd37kGRixE+6DB+REjo12T0LNpiCKhtdBrp82Ye86mgxGrQZszRWKvhdHRAp8N5HB+EtnU1twOOEGMmlXdWkXpGMVV2EVQ+870ab0ahFS6O8Az8UI+70kjJsz/eXv9KjcA6jp9pH5yXKGPqOx6iXtJCrlHS9C0kjPf2IlR9QAIdZMgv4ijqFfQcw9Y42RARoWVnPsQBa2la4Dd5gjZCFIgxm47iAGgFZYkhkguqdjZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 07:23:41PM +0800, Barry Song wrote:
> On Fri, Aug 14, 2026 at 3:48 PM <mambaxin@163.com> wrote:
> >
> > From: "Jose Fernandez (Anthropic)" <jose.fernandez@linux.dev>
> >
> > [ Upstream commit 63b02a9409cb5180398491b093e48bcb5315f5fb ]
> >
> > lookup_swap_cgroup_id() passes swap_cgroup_ctrl[type].map to
> > __swap_cgroup_id_lookup() without checking that the type was ever
> > registered via swap_cgroup_swapon().  On a swapless host every ctrl->map
> > is NULL, so __swap_cgroup_id_lookup() dereferences NULL + a scaled
> > swp_offset().
> >
> > Since commit bea67dcc5eea ("mm: attempt to batch free swap entries for
> > zap_pte_range()"), zap_pte_range() -> swap_pte_batch() calls
> > lookup_swap_cgroup_id() on any non-present, non-none PTE that decodes as a
> > real swap entry, without first validating it against swap_info[].  A
> > single PTE corrupted into a type-0 swap entry takes the host down at
> > process exit.
> 
> Thanks for the patch. However, we have a strict check to ensure that
> this is only done for valid swap entries:

This patch is already in the upstream linus tree.

Mambaxin, what do you want to do with this patch? Are you requesting to backport
this to stable tree? Which one? It already had stable CCed, so I would expect
the stable tree maintainers would pick this up automatically.


