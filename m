Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103B7CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 18:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC62B6B0093; Sun,  4 Oct 2026 14:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C77946B0096; Sun,  4 Oct 2026 14:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F526B0098; Sun,  4 Oct 2026 14:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 860FD6B0093
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 14:38:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D56440BE5
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:38:11 +0000 (UTC)
X-FDA: 85285803582.27.B3AACC8
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 233B8C0009
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 18:38:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m9Kt60Wz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791139089;
	b=xW/i71w/LKnpSGxqJnAMWcBjm3Y18jLvz1o8ajrlTI1QjkN2mWTxpHWrMIami4iAl8URvU
	xcv6ZBJa0M/wsn5+SAafrEBGUsUNGhRkC5XdrgtS6KIoXz2vJrpNXs58p6xlI+dFzR7SoJ
	eP9XxsxZ2+ExGFFFLQLoiCa1pxSaymU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=m9Kt60Wz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791139089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4c7dYjrT6sZNHYJQlTA+JnOu2XHVq9WNP85b0Iivahw=;
	b=lT/U+GfWyTcjdaXAiuALZ4GubvtgtzeZMbWjRELuS7fwBe+xsg9C4ypf7VjfR69r5bf8Xg
	7tqFqPdHz+sQssuhODzciWo40t95zrqoOk/SvVhdcgI6CQ1qjzd4MLm5zPDU1dIFFu06ML
	s7bhTSsbMqv3DeTjoUrcV/IXczipJwY=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5337c7b9937so265341cf.0
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 11:38:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791139088; cv=none;
        d=google.com; s=arc-20260327;
        b=Cib4CVcnPEh92yCGFwZwNmtMMNE1fVnYNHNuezfgShDi3/ABIP0v9F2lum6Zpl+fIC
         oqy7k9T+OmMiEkN0Hse4NJFUQpDwhLJ3cA64L1wwJ8iXbYY79MEQrxnUhJKBphQ5cgc0
         9s6nFkD8uMAmuEtO+CZrt/5tZGDt0tt5S1GH5Y6DlQxoR16j13O0ApmXKKDnMQ5vWZp3
         yhNxMgzJEflYDL5iovIL9cK3JRLHL79CShEHMNaFMa8l8MOu/JjrldgXl3pR450KNcn7
         k0HwDX7bJLgNE8139I3aw2IdZQAEpFaDQ8L84JjP/kFabYYz5pZccqMaXDGiwO4wFhQU
         HA2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4c7dYjrT6sZNHYJQlTA+JnOu2XHVq9WNP85b0Iivahw=;
        fh=w+Mx+Lw7Gcgz/94BhVU3D8XgN3R4qlcS4oyTvBFtv4A=;
        b=nEbaegrc0wc+/xkbrYFM1h17aC4n+o6MXERn6QVpDpfdzhFJsVOk5uPNGCfuVjsiMX
         0fkQrhrzUUs6gjf/kLeOWO8jfuKOGSKe0LaHXjEcwslUow4ugjrfx0YdOnLLVw0SrdFq
         NktnPOh18LnMCb3nkhDhJb3ppBpiQ7Hj3RWGE65n9X3wMlqawMkNBKPLXCQX25PuiirI
         DfXY80kCy+mTDJVONJwpVfbCuk01f5k2LFIqx9+Lbp3eKo5DQUugPbCOMvWbJopG6HGx
         9knRbCFKA/8IFjYXaYN4EH7KhMh1vgLQg2bjthhOTG2kSBsW1c8GKFZNy4YmtYpZYRY8
         5zug==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791139088; x=1791743888; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4c7dYjrT6sZNHYJQlTA+JnOu2XHVq9WNP85b0Iivahw=;
        b=m9Kt60Wz3LYWQOOkqW658ek/vaz5T5ykdgmjtq7/dmkcRkBNOhjvlKf6w80DKGtIQc
         y7cyHrXfrDr/+k1PNNqWLQYktZ8KWXw5xzVBhpcK4Gr1gnbLUtmhTAo0nFLwBaUsoRuw
         E/sG4qiCA0YnrsfBKRR+naa+b2fs58ZAWKUKJ+qhjSvC4r2D1xKY4Ypn9YIR6ZPAd2ci
         8WK0UGdrTb33eOjeZcy/iVLKTb2Yg5sXrtb6zD8cnES1sFZohRk+IvX2kj/Vr1oAfmdX
         hTAWuyyA5ewmBH5dr8YRbUUmjLN++5WdnE93VLYj6np1tfC2fBG+8DPOAjHUv3rYJr82
         7HCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791139088; x=1791743888;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4c7dYjrT6sZNHYJQlTA+JnOu2XHVq9WNP85b0Iivahw=;
        b=qm0N5gGPIyiE4JBd1stIdR+UL0oeJXj2jxs+GRb8ir3Sq0hpELipltnsOdjIDNXwmD
         VBCqTdM6dROxZTtzNZN3wWJCoZV5IiDLzOyBYXn2uNqiBDOR4VIWNyODwv6eZQKxhqGT
         4hwFFRDzOvLRb3ZAn0/bZsEr1MnJ7ODzcySGNh24MGpcyUVQB12mp10EM6gOGIml1EiN
         ALaet6h7+0k5vBJLrgfAHJlYbqvx12JTndC+ijJCZtH1jJHj4r6wenYbhAysnLboiUio
         1RzMKUp/SgpNASJqfQsir3Eo6543aVaSdOW91xjNuz/c1G8B8W3FqbJSOPv4dNMa3IJo
         FeTA==
X-Forwarded-Encrypted: i=1; AKwUvBxt//hxA/qSi3rvIJ79g21CWFBhMcaCCrL6+Ga5pIMBTBzq8jumTFHqpb+ZmK2b6ynLZ36+Com71Q==@kvack.org
X-Gm-Message-State: AFuF++kVfNd6AeJJcuB1F8ICY94+QydTVdE0LwM2FBoP636Xw5uKjO/V
	kRrTAcFDIOh5s7xW9MLxe0EyzyuWZKDWRUKs4//mwAhc9J31QiWZR6uIWZdhwH7WIesUhcW2g7a
	jkb3ms6A/kNtNxlvbckg7tEMfBTXwNvjXWfGN59mT
X-Gm-Gg: AYBFou0lXHqNKljJsWjnEIWfWiRe09g0lTJLfWpYXNbYx7b3A4uqxQmlZu5J+0RGwpT
	I4zUEf4i3iedRMCyL/LYZoef8DWrQUqPu4m5O2Hn59rO4l2Ag7wXeD/uIK/5LzkwZAjrw5Ib0m+
	Kxovq0P7t6E6PIRh3Qyb+6MgAAwX7a5nVrsdqHkALqA9+wgxpN+6s+sVdXZz9el9N/jcKZQthF2
	+Lgk1zu3NGx86ENWIYIMYWtRw8YhqKV7h7d4M90EGDxl9+aROAEM2EtJXK4R6c0fLs2uzctq5ne
	MOfIck2Yadxx6vlq4X1n+7DJk0iy3fn3LWQjwxjSnXtgemj5NqCJCoBA
X-Received: by 2002:a05:622a:5984:b0:532:858d:e791 with SMTP id
 d75a77b69052e-535131b5a91mr17889301cf.8.1791139087466; Sun, 04 Oct 2026
 11:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260929082014.160587-1-hao.ge@linux.dev> <20260929134401.a1a385ff4369661f879b5d2f@linux-foundation.org>
 <CAJuCfpFRW3uNUW_VrjpOfLwS1LBHqGEpqK3yBTPSpGOORY5jiQ@mail.gmail.com> <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
In-Reply-To: <fc4f3d08-393f-43ed-934b-e7e1ba6d0137@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 20:37:54 +0200
X-Gm-Features: AclHuK-tgnRy3c8tRpdQgoIviLT7ezLMAJcWRyqSp8rv6XK6Qm-JduLkT1yGnnc
Message-ID: <CAJuCfpGAZUcQnursYh=rvp+EzckvDmXX_KveJvEuyjzzG=9mww@mail.gmail.com>
Subject: Re: [PATCH v11 0/7] alloc_tag and module codetag section fixes
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-modules@vger.kernel.org, kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: bxessce31jd77jis6zeoewjnnt4famgb
X-Rspam-User: 
X-Rspamd-Queue-Id: 233B8C0009
X-HE-Tag: 1791139088-618008
X-HE-Meta: U2FsdGVkX182xURygDVIBbUH2igugnEpQLA+Kgfb+SWfH8kwEomnpNc/am3ObmFEQYfHhrAHtO8clbv4WSDAImSys0sQO9XRmIu6UG9GEX7B5lHHlbGzmmMKGa8nGojkLjNpMmhsg2EQNtZfpJPIP3pI0SgkstC0+ujXPWgTiXnziabFjJdeKS1In3vvkxoaLsUfeahl9dp6YN12uSl5dKBGKHSJbCvi9oteeueegGGd5RRmAvC0rIbq4mjHi1cCfXcSWDq6UoL0yf8IxoC/vX6DUxvtEK5rQO32rkaYx6V8ezGgpYuRWsHaFwSwXOlRHfYp8IxaiXEJxuAE6f/8E8r2rhmIe7GJzOvXGQZ/yBk6ht3aSbdq15LFfRWOGKN/KkVUgXSLt9JhYxQ8vpehAFfZRB/nM+LWi4nGfIIQ7HIyPXhpogtgBk2QLceC/seSrM4fY9Aix9dwcuqnhl0Isrn+D3/4Ezbbtp6pfAqH+Riw/DCGtFQp4qj1BRUjmm2XPFKmig0hOSXkHD6q1JN0oDw00wS1WZS15QvVZe3ek6IeB9thFk1aIGxqdmalPMzFj+DIE7jTtd2A49iRJTBbC6P5WUWXSn89Lb/a4LOcgWrRHS5TjTBuWE7ZiAgqPRfiiPHYxrVayQnQ4/OgrCI93tJtSJTESbQwcBrQDtBkmoB6tyuD6dPp6kjbrbK7nNqk5ZRU7R+lSLiID4IxCsah9Rrsh1rL6X3vwVZQZ7MKOIggwSMcNmikyVzDNvG/MU54G7qX86KdEz0MnjrDULqn/5vg7bvW4Ealt9uzurbKv3Fybc7q0AimNLOtl3oC72oR9DXzFP3xPzSx4/0xYajccpIwOPn9seUDMhlQTaXI9aIRNDecS0Nf3dXoQPsfYhtIwvNIMkKandz0cYNZ1uGuYJ/X6PwYLqrZ69kiRbVjH1bi1uWnOlR9ciaC/Acl+9f7jQqsU0zj18uupGDBlkA
 qXkSQoUj
 aTGSVepNH2ydFzsXt4tvTGiWyXfwLqjjKAQDptWdNaqHl6N4pm1g+nKEZooVScTSmrACscgpJhMOGubV8rS/ouaIkkTAq5/aF5aDKLeofk1i5i7b/lE8C3zgpBgXfni+wvn8J4Onl0nV+JoMDgs4QPRqvP2uMJheE+GEsBEmyt2Qi+87UpgFakKlbSJsSFpkpziXwJ3PM/mmKU098frqNtwsDGDL/J1XJ7cCu+cCD/8aMoWrnzl6p6XihzX9gI9dbbURUxtoDWjQgHWuiWaA8uXQim+yceIcR7xsZSBR8BexJWTcbowB5P0WLXipccr5gUH91lbF+hxdysOQvYyJN2C+lq7T9FaYxgyNUIWGWVw8FOK7k6mLaGByea4BYV1mQ8InhkhMtaU+AkGLvCFqmiwVyYeMNMB9xwjfNG/U9XA3P61k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 5:25=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren and Andrew
>
>
> On 2026/9/30 10:39, Suren Baghdasaryan wrote:
> > On Tue, Sep 29, 2026 at 8:44=E2=80=AFPM Andrew Morton <akpm@linux-found=
ation.org> wrote:
> >>
> >> On Tue, 29 Sep 2026 16:20:07 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> >>
> >>> With profiling toggled off, the overflow check in
> >>> reserve_module_tags() did not run, a module could load with more
> >>> tags than the page flags can address, and re-enabling profiling
> >>> then silently corrupted /proc/allocinfo. On overflow the fix shuts
> >>> profiling down, releases the reservation and returns -EAGAIN, and
> >>> the codetag section lands as regular module data in the same load,
> >>> so the module loads without profiling.
> >>>
> >>> Review of the earlier series by Sashiko turned up more problems.
> >>>
> >>> One is a race. layout_sections() and move_module() both asked
> >>> codetag_needs_module_section() where a codetag section goes, and
> >>> mem_profiling_support can change between the two calls, for instance
> >>> when another module load overflows the tag index and shuts profiling
> >>> down. move_module() then copied the codetag section to offset 0 of
> >>> its regular destination and clobbered the first section placed in
> >>> that region.
> >>>
> >>> v7 reworks where codetag sections are allocated, on a prototype by
> >>> Petr Pavlu [1]. The allocation runs before layout_sections() and the
> >>> placement is decided in one step, so nothing re-asks the question
> >>> and the race is gone. The retry is gone too, on -EAGAIN the section
> >>> is laid out as regular module data right in the same load.
> >>
> >> Thanks.
> >>
> >> Seven patches, all cc:stable.  Why is a backport proposed?
> >> Documentation/process/stable-kernel-rules.rst gives guidelines - does
> >> this series meet them?  Does Suren have thoughts?
>
> Thanks, I've just gone through this carefully.
>
> >
> > I think vmalloc fix in patch#2 should be posted separately and clearly
> > quialifies for backporting as if fixes issues Hao found at [1].
>
> Agreed. Patch #2 was added to this patch series because vm_module_tags_po=
pulate
> suffers from the same issue. If we want to be more conservative, I'd pref=
er to keep
> vm_module_tags_populate as it was in V10:
> https://lore.kernel.org/all/20260915070001.113559-3-hao.ge@linux.dev/

I disagree with this approach. That means we are introducing an extra
code inside vm_module_tags_populate() only to clean it up later.
Instead please post Patch #2 separately. That posting should have your
current patch that changes vmap_pages_xxx() to clean up on failure,
followed by patch(es) which remove unnecessary cleanup that some
functions currently perform by themselves. This patchset should
definitely be tagged for stable.
Once that patchset is accepted, the rest of your current patchset
fixing alloc_tags can be posted with correct assumption that
vmap_pages_range() cleans up its partial mapping when it fails.

I know this sequence will take longer to upstream but I think it's the
right way to go.

>
> Then we can submit a fix for __GFP_NOFAIL retry loop in __vmalloc_area_no=
de() as a hotfix together
> with our new patch #2. While at it, we can also check if there are any un=
necessary calls to
> vunmap_range family functions that can be cleaned up now that patch #2 is=
 applied.
>
>
> >
> > The rest are also bug fixes but their size is concerning. I'll review
> > them first before advising on which ones should be backported. Some
> > fixes address issues that happen very rarely and if a fix is too
> > complex it might make sense to leave it be or fix it some other way
> > with less churn. Please give me a couple of days to review them. With
> > the upcoming LPC I'm trying to multiplex between several projects.
>
> Thanks, sorry for all the hassle on you folks.
>
> Thanks
> Best Regards
> Hao
>
> >
> > [1] https://lore.kernel.org/all/b8005c24-ecac-45c4-840a-fd282f9693b5@li=
nux.dev/
> >
> >>
> >> Also, Sashiko has been busy again:
> >>         https://sashiko.dev/#/patchset/20260929082014.160587-1-hao.ge@=
linux.dev

