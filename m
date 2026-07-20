Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D45C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 05:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F006B0088; Mon, 20 Jul 2026 01:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E12F6B008A; Mon, 20 Jul 2026 01:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884676B008C; Mon, 20 Jul 2026 01:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57A9B6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 01:42:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B6E701406D5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:42:58 +0000 (UTC)
X-FDA: 85008061236.21.F214446
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC3CA80002
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:42:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u+euP0CG;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784526177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+S1mGES7WPFX17qfsQ0UaEG3UvF5m9koKB2T3Ujw8A=;
	b=LWfP42N6jEk5nq7ZyMTm1vzbrrphup+VeR92Dnf38QxbVOM5/7padCfOG6lQW7QhL0ojb0
	xkf+rm6vyHSWL3rGtXrx8JtV/CFsMu0Xewl8SVb6to3gIRg525MNFUB/+XGiUTt5N9JFtf
	9FDNGvFqLscOkDbgoAwSBxVT9lLl3/w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=u+euP0CG;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784526177;
	b=2piOV2HI1fHZ0+0EHFkw8P7S7fbyb5jIJWM+IHYdjFrleZeHRpAU8Zbphq0JTxPI6BE5pc
	vF3NW1ShI7kSw7NMZ2/4iCZc/Sug1bJ4kJeTmQff0QirRFSfiJSRsWT6IuPuqQfXiK5UVQ
	du3DVi/XMXza8vojx64HAp5/AYyLDcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49C3F60103;
	Mon, 20 Jul 2026 05:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A98FD1F000E9;
	Mon, 20 Jul 2026 05:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784526176;
	bh=Q+S1mGES7WPFX17qfsQ0UaEG3UvF5m9koKB2T3Ujw8A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=u+euP0CGJuyGXiEpj1CFp/mtlnGZ8bFF1xr8YiE7rfFZU8pp89brbNM6+s+9hF+Cp
	 qMlBVmrOkt56Kezq8lC4STXPkj7RI8D+bskVdz86DGccjmPXEVEMJ6vugAZSHqzYeX
	 lbrbqmuRTrX86Na7dX/8KvBIJumhyamzMGIb650s=
Date: Sun, 19 Jul 2026 22:42:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 9/9] mm/page_owner: use memcg_data snapshot to avoid
 TOCTOU in print_page_owner_memcg()
Message-Id: <20260719224255.8e2bc60e8a42681fb541e6ad@linux-foundation.org>
In-Reply-To: <e3f17e17-495e-423c-9c21-48aace4367d1@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
	<20260714015117.78351-10-ye.liu@linux.dev>
	<21007313-40dc-46fb-bbf2-453c8eedf3e8@kernel.org>
	<e3f17e17-495e-423c-9c21-48aace4367d1@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CC3CA80002
X-Stat-Signature: nhkgkaga1r5h6jsj5efc4oup4ao7jz49
X-HE-Tag: 1784526176-209588
X-HE-Meta: U2FsdGVkX1/hieTlVQGkiAO26DPLmjoe74kjyHr1Vtathv5kXKB+RhZ/DLWBeRAbY+tFLSW+uPd/tMu+oCvuPQgN/TTozFmdj4i1yCLKtO3Zs1pRtKIL6G2na799P391uaE7h9RggDNGFVkwsli0p2dK66986/wmH+vCu4mt6WCxkFV4467XAHa6JaElXfyRHe6lX38jUAaOoZh6FHqUjWuiOvXqyG9NgXuML4wE28umTkiA6NbFlXmlJZql9Ih0rroJLaV5/6e2nTEjz8B8mIiSOHCtKjf7o8CKjFt+EQRjlXZXqog18tJHNnkOS2kuBbbLIHxGAxQRJOajLFn3J9iXvZGOzO1Vw/EdnIcuJGnqKxKmZrNsLWfxu2V74M3tAvXkE5X0aoKaFaLcGVRhiLiK+CTZCjRckGk1YkvruJtjIN4wJdKZLfZahSPytQzFHbZNM1YheO5US8TC/2kBoIoNxuMKcmtWaGUzlvYt/1WVDUrYTNxNXbOV990/zAAIUepwPE1Nao2H0+CfypNz/lSf58ZeAvqsue3c/c8+ULeKYedIWdtrosTwMMsFtoTTXP8V5zbbYcjaYvUVlKqyYVX8Mk7QGvFZc+QF7M8nMdVnv5CKnAOxBOjXO0Q9QRpkHNLqVhup7Yp+lCetvm5L2wG+ErZ2DJ3AcTwB9ZXzznMejEJ59Tf0ILxk08kgwHexYu41iTziz28jXBZZ8DBoiLdbtt+1UKIlQlZ+7TkmlVBgLclilnQ00WZZQSimHo/Svo8N85lcuTTsEeLAul1DIe9BkW+ODfblDhkSrdYK0t+71OWAkdrypmL1sRQEP6Z8bOiBXQOEYpQJSaS8DMYYMSeUpVTVECbuf5zu4rdVumhZ0bvB2Ttz1aBZEGKX2Cw44ZGmZUxkJ1ja7kUcYhhKksoidSvyrdbovKhrFjj8NKZlxhTXmVOYgq7RKEVAe9GPa5j2klfa/PUwTh/Q6jR
 gm87SK/Q
 FaWT/YVTWjAvlhbg0x3bz5aOLG2dXW9ycirhg28g4HLTP1gv9qz7pLOVq2ijjAgrI5ZuZqExxfQQKIt/qcR7tIhHEx+8whPT9ty1akk815WJ2EXaDXLCe1Bgs3R6QzOL3lBUXx31fMcJUCMAwAxZllkX75l3D88MAKJl4MaOPVttoQ300NuzwzlnngrPH1JkqIevvL/kieyrX1f7EoGa27wq08B0D+QGrQlWbhm0pOeyDpQNkGR9zwXNcWJe5LlOesuYQ/U0ZRwEYgU4VEIF57mKPNroxuLIUmVlSa1j1NiDzBxHZKA4UpuPYyHhcyk19dGL++PjGTpntxC2URSQN3dC9jkvGx0HcJ2Js9m3VEokT7VakHoL1YapDWK89mCmiBFBBybRpKnmpwwcYhXk7V6IXrY0KiIumPz5ejrJUdyBfXz0L3VE8cwzSAlhCfQbRwm4gzQYwkW7FEo0hzpldKJgEwDi9kEsl86gNernSYkdox8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 10:45:56 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> > These points have too much detail that's already in the code. Would just
> > mention that we opencode applicable parts of page_memcg_check() and
> > PageMemcgKmem() using the snapshot?
> Yes,It's a bit wordy.
> > 
> >> This avoids both TOCTOU windows and the assertions entirely.
> >>
> >> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> > 
> > Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > 
> > Was all of this reported by sashiko? At least the new-in-v6 was?
> > Then:
> > 
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > 
> > But it's no longer a cleanup but a fix, so probably this?
> > 
> > Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
> > Cc: stable@vger.kernel.org
> > 
> > It's not fixing a new regression so I think it's fine to keep it part of
> > this series for next release and not need to split out for mm-hotfixes.
> > 
> Hi Andrew,
> 
> Could you please help me revise the above?

Sure, how does this look?


From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: use memcg_data snapshot to avoid TOCTOU in print_page_owner_memcg()
Date: Tue, 14 Jul 2026 09:51:08 +0800

print_page_owner_memcg() reads page->memcg_data via READ_ONCE() at the
start to guard against tail pages and NULL data.  However, it later
re-reads page->memcg_data locklessly in two places:

1: page_memcg_check(page)

2: PageMemcgKmem(page) (via folio_memcg_kmem(), which includes
   VM_BUG_ON assertions for tail pages and MEMCG_DATA_OBJEXTS)

If the page is concurrently freed and reallocated as a THP tail page or
slab page between these calls, the VM_BUG_ON assertions can trigger on
CONFIG_DEBUG_VM=y builds, crashing the kernel.

Fix both TOCTOU issues by using the memcg_data snapshot throughout.

Link: https://lore.kernel.org/20260714015117.78351-10-ye.liu@linux.dev
Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: <stable@vger.kernel.org>

