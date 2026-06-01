Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30D5BCD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8522F6B048F; Mon,  1 Jun 2026 13:49:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 801EB6B0491; Mon,  1 Jun 2026 13:49:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3336B0492; Mon,  1 Jun 2026 13:49:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 567436B048F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:49:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2C361626D9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:49:57 +0000 (UTC)
X-FDA: 84832082034.09.55F9001
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id D54A9100009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:49:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PLyBvJkw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780336195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pMR+vMx9phwXvzk3LCs0RnCPA1OW1RBGgb6+eYeQRiE=;
	b=MvudjZyCGzF3nP8hoSghLHOtZhxL7x6PNvJIbrhCVmPOABd9S1gtNGvrDc8aU6I+MGCUev
	Kv3+d5Zi0jsiXdRhqPUF+yCAWDdY/KHW546Kj1DT3Ef44V6SD8HN0SM3xrm45xUQIYXzs1
	teit4P5OpJnwfdyEhUQpz8pFBRGGH2c=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PLyBvJkw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780336195;
	b=jCdEeA8uNbx+xon9lINoNlgZQGC9oFfBloQpu/LbHarBo+AlIGFP0JumbAs2NNEY254g3Q
	/f6tmhDRisqo2bjIahGkCknoMSNIf0outujRV6FZircz+lH+KChUa03yB9DEugoMKt01OT
	g9ZJYSJsOn9qT2P2W1Ex9M6203SX7wQ=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-bec49f7e35eso214505566b.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 10:49:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780336194; cv=none;
        d=google.com; s=arc-20240605;
        b=MvXA23+CDlgCCRoueeY01rr5nPx6y8MwC0fxssu8i6XUmBuwkBVntpSo/JCqYb1cfo
         KaOdqhWi3vvNR+cxlE+CD1B43U+dkRHOcnP/kazNItV3pPgK4rl9G1wcsWK2x3p/fS+w
         mycQbTQnPuTYtXiqLEg03xb4ZdMKEVk+m+e4n9PMq/7CJ1dV6cbU04NJ3C8RxAz4Xl/s
         1Iaj9KyWpbAHhCI5fzow8/gz+/GkfLKitOwtgcf9gx25hRr954ACIXKGN38/1+iNr6ub
         qsTUkXPuu2A7Lwa3vAedL+YKhqJgNED0aXuAQOEOLEdHxQdgySG2gWEKKEQDYdQ6F4MA
         vE8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pMR+vMx9phwXvzk3LCs0RnCPA1OW1RBGgb6+eYeQRiE=;
        fh=dx9o0H64lBhZOZP9MFJquIX2gKvy1k6NL0rWXMxQqD4=;
        b=KIc+YnJJjCdjgFUdSf0TlJQJSM+18eEm20IY7H9BbnM99lM3PeEhfX1oImZa9wug8J
         C4qH0+x+FWnOnd4pKpGpZgmOOqHC4ZZAN8MRFnZB86c8oUFVsmdL4Q9BhEjgPtsey90V
         wvThHXotB1OZPoQBWYF9oRsdq9+QQMkd1fdLF78CxADTOd9p3ClGsdal0/DHR7y3y1JC
         BadilOeDvftcKO3IZ5345r6occkj2K3AkKZM0rwa2EdQOsn5fWqhMMSa2cK2I1BwnWTN
         juy1Ko3zf5coTOAURl3W9FSyQIAEq9LHNB6fJEegF6VTIiqkybkIa56KfyG7rST2XFmH
         E6gA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780336194; x=1780940994; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMR+vMx9phwXvzk3LCs0RnCPA1OW1RBGgb6+eYeQRiE=;
        b=PLyBvJkwV30NSwsi2m5kbyf7qaxkBJrnKbv41rcD8ehkPFmiAAZ6DGjrrEUMpq3oHC
         ZPjWxYBINN/dZTByGzio43Sq/xKr0a+yyKqTNL076gs8yrpT5HXLKdJeYs3rQMLbUIzT
         /ayGA6Mg3rUF2HPq/ekqlLF+smym5tIEyj72shdQTIRk2riQjefqvHf8HE4pLV7wKpdL
         y4LGGJtIgamn7BrTEZYKJ6RAgbEUdqrpJetsRFwpUi8dlaeyw2XhEfL0bbHlQIqiAIja
         Qro657LnPB+l6Hgh2OU+u+8bxKKDUPKvLY1G4Mt8iu/cXjzT3hXrKf8CI+JTGdlRzkzc
         kqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780336194; x=1780940994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pMR+vMx9phwXvzk3LCs0RnCPA1OW1RBGgb6+eYeQRiE=;
        b=nybFX9FCP8E0zKneb/cmuwwn6KkoHaJtFh+rfeshgQwIsJgXDNJFpgVULCb8PV06vV
         Gdyz3N4VwN7ogOX0kjOb3yj9I9RQ/J6Mb3AIhJSALZspQZH8nAm/ZFuNkT+7DTrPH+Xr
         vjawMhqXwvQEGWneuaBlaHNX1nibwXR0asFf1BVXckILr682HY9Ok9FClpSiG9XQADlX
         kLaVpJkiulbbK5YE49C8SyabIi3IIknUSaNvLMIdgOoKpT2PyOVob3LEp27JBXv0AQq/
         2z0vj7esDPnNB8OdxXXHizSyN9MTfWW4mXuggzRMhzP27gzwxMFzCC602806xobtB2jL
         gWTQ==
X-Forwarded-Encrypted: i=1; AFNElJ8BP9CZMYeOna89Mv4dhuNhYomi54IRZXOKU0FMADxPGF6Fu2zxSzT0ddI9S4aT9lDXhf9XEioM5Q==@kvack.org
X-Gm-Message-State: AOJu0Yzi4PFlmQmuOFJEWISoZxSKMKC4cPTLuBl/m8EwoEgHmTjTFuUB
	tJYb3xzUanELcnjV6VdUFvuJgbEyTXWukWt2UEAQsZwHyqPolA2nlO8dwIZe2Sho26bd7urvVQG
	ldJI2OFFfLCuW2wEb5JG/oG75ORZf/fA=
X-Gm-Gg: Acq92OFczzlIA6cob0QxEu33XaFCCjG2lzrFdo/bL/bmXIRwn8YR5iB/4p2aI8nH9U4
	FL4JIRzZNuA0KPYZ/JU85cJ010B5uHII/l2lcrZ8sCIDlMHel01WSPBN2+YUbIRiBhboS1I4eHw
	2o+nxe+02xcgWUMsKZTPPxs8Pu3nBOLtpukataciTK1MNdIQdyjhs/bDuYB9KPdVg8SiAbxAJcW
	917DAhaCdv8JI4G20yrhGC3Xhaje63mDPY4VY1WoyVvb7CAN1Hb4PW5UBkJdjuhMvYnOsW5lOVV
	T85q7O6txCZIJurhgP5vK43BZpsBFycm1sMif43SGNQpn+wwmls=
X-Received: by 2002:a17:906:1ba9:b0:beb:e13b:b3eb with SMTP id
 a640c23a62f3a-bebe13c09c8mr420086866b.9.1780336193926; Mon, 01 Jun 2026
 10:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ahz_iYG4lqWL4g-J@KASONG-MC4>
 <CAKEwX=PzMwXXgq=ULAkFD9UqMz+ewLqhKt+xdGxkV7OmA2QG6w@mail.gmail.com> <CAKEwX=NNNf0KCZC0ph7VRW0gjnbXd4W5NKEaHM4XzPdN03Ek3A@mail.gmail.com>
In-Reply-To: <CAKEwX=NNNf0KCZC0ph7VRW0gjnbXd4W5NKEaHM4XzPdN03Ek3A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Jun 2026 01:49:16 +0800
X-Gm-Features: AVHnY4KkMWDCgqvQ0VtgzLPCLTVcd18CUg6LbNn4WT1rDML5IaDfG1WZK2GBXNs
Message-ID: <CAMgjq7CT0ccCnzmpRGjTGPnNEn4eK==5A-OFbr3+p465dQMH4A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, apopple@nvidia.com, 
	axelrasmussen@google.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	bhe@redhat.com, byungchul@sk.com, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jannh@google.com, joshua.hahnjy@gmail.com, lance.yang@linux.dev, 
	lenb@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mhocko@suse.com, muchun.song@linux.dev, 
	npache@redhat.com, pavel@kernel.org, peterx@redhat.com, peterz@infradead.org, 
	pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9bdf9sut6x3fm79urmj145rw7w9jtixj
X-Rspamd-Queue-Id: D54A9100009
X-HE-Tag: 1780336195-306430
X-HE-Meta: U2FsdGVkX1+/4Yj6DHuu9Os80m+bSCzBw7ihRZXHh+kbeDHO7cHbUFeI/gXcKE/w7JZUMW/De83LSoF5w840OqVHaNDx518owjX/TCL2weCQtiFRD9QU8Zxeb7UPmk2aSBSNQn+n6NolkuUo/k6cC7xGMebYC71bg8Z2iadVR+qrUaNLme0aBCFW1SuwyChF0x9WsBEchqEGf4e749axzefSgHbm8OBTho6yhvmf46TP8oJPMWdM+EOiJuCYvwPonzvkN5Eq+IJS6qfj1LW6YIg/SwwcaFyLgtg9GCVbebrF6ja40/ZOX1FV30KF89IVEW5e0pWJVFEstWLIMdQHdVQ+hhqspLkgeRwvp1fFqq/v7JRAwS0tlVyVSEbG+qtWtt/1tBP2f8rqexgQl5tKvzrWC7KesAv7+dt2sJFdwpQhqDbPeWjfYokQbKeAHGl7eM53xPBv8tdLW+O+4fegwHOadS/mmPHZdSD7AXPD+PtUavTc1TL9T4W7w65ARo7LkYI0Ua/ebx52r2y8A8wGIpk3sjmti00W6K0qNT3PR9anCu+ipT1vVrXjdERTORqtTiqMAZ8yMLYY26g3uNqhYnyvuOdRj0Fhshao05ceml9lZfwgf3aLyX7uKzwYImk3i8+6l5qpOO71861OImqpicx5oXAUHEcpmo2/Ndud/1wUvvMtJrPC2TbjbRQTFdGeux5IQnvTFhcD8s1y1qkfpn4ez9lu5qTytfEYaxP+v3UvrC65DgGv4iSddrAAHePWfjOj5Sef8MTIVrqUd6NnxjY2allv9WGZKtsyXnf4aEaOziy9HzrIDGCPwDnGsQm5KwK9u8q+vreiLdvHj02uRIIABCjCNxeNB4vLtsD7VmaQNG1lTnvBd0pQXjXUAeQ8CsDs6vsV1MBzxaXv5zUolvYEU1lOJFPFnQtCsxWmxfc7KsyBJmXAmURAPVPUIr3sdhGtFNYiPXxG+kBP7k2
 Ly1K4DdG
 Ke3r7Xv+8fWRN+PzLNYfY3B/kAVPdaoZYempKeucu3s/B4DR2h5JLp53rV6vfyyQQ6bRfq4dzZO/zSQjXhuKFz1aQ4BtEGWQudh2xox4Wgowds6DhBfk2i++s0wUPD/RMWxpDHGC0VlQRVBde86ffEO2B0ST3ao1XsmGFCiccYXgIKRqyufVHEq52npwpyzIqCQjC4mL8m8C3DWdSC7izJtRgULwX5E1Dqg2VZqyKrEjUpaHps635oYzhEiGUmYQu1I1bhgHrDCOWKAUGGjVSomMf1oB8FtbovrrUcNQXyWB64z3mUVEf4IHLvrZRUS3QorXqGgBL8aFmrf+QDduQ53V+R6RtVs/vzPiKJqqO5IAq3YvypFnD84ZmrQk7qf9b4ue5wSGl6c8o4MMfttYv0KCF/X+la4WD5bKjbtQi6NCJQUfRhbk4SXRLuJbBiXCGnrsTxX925ytXUiyXDRuoplYMqwxfn7fA7kzcQsLac0K+Fl7WE40knNznLpmYn88B5I/+ri5ESCWpUyVooP8ewhWc7Ho+YuoDZbCDB9VRRlijr8T30eATzQtKBd7D+rlp3CoIUpKyWTJEgUs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 12:22=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Mon, Jun 1, 2026 at 8:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
> >
> > On Mon, Jun 1, 2026 at 12:34=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > On Thu, May 28, 2026 at 02:29:24PM +0800, Nhat Pham wrote:
> > > > III. Follow-ups:
> > > >
> > > > In no particular order (and most of which can be done as follow-up
> > > > patch series rather than shoving everything in the initial landing)=
:
> > > >
> > > > - More thorough stress testing is very much needed.
> > > >
> > > > - Performance benchmarks to make sure I don't accidentally regress
> > > >   the vswap-less case, and that the vswap's case performance is
> > > >   good. I suspect I will have to port a lot of the
> > > >   optimizations I implemented in v6 over here - some of the
> > > >   inefficiencies are inherent in any swap virtualization, and
> > > >   would require the same fix (for e.g the MRU cluster caching
> > > >   for faster cluster lookup - see [8] and [9]).
> > >
> > > This could be imporved by per-si percpu cluster. Both YoungJun's
> > > tiering and Baoquan's previous swap ops mentioned this is needed,
> > > and now vswap also need that. If the vswap is also a si, then it will
> > > make use of this too.
>
> Oh and the MRU cluster caching I mentioned here is not the allocation
> caching. It's the lookup caching, basically to avoid doing the
> xa_load() to look up clusters for consecutive swap operations on the
> same vswap cluster (which is the common case with vswap). For v6, it
> massively reduces this indirection lookup overhead. Performance-wise
> it's an absolute winner, just more complexity (because I need to
> handle reference counting carefully).

Ah alright, that's interesting. And I think we can keep things simple
to start, since sensitive users is stil able tol use plain device this
way.

BTW maintaining MRU is also an overhead, I'm not sure if the lookup
pattern always follows that?

> I also just realized we'll induce the indirection overhead on
> allocation here too, even if the cached cluster still have slots for
> allocation, because we look up the cluster (which is basically free
> for static swap device, but not free for vswap devices). Might need to
> take care of that to maintain vswap performance (but it will then
> diverge from your existing code...).

That part should be indeed coverable by the si->percpu cluster though, I th=
ink.

