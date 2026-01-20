Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD035D262A4
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 21:20:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E77C6B0005; Tue, 20 Jan 2026 16:20:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295136B0088; Tue, 20 Jan 2026 16:20:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176496B0089; Tue, 20 Jan 2026 16:20:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 099726B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 16:20:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B626C160727
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:20:56 +0000 (UTC)
X-FDA: 84353612112.14.862989D
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id DD10EC0006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:20:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c85e1UcQ;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768944055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yb9J55L/oOgj+YxKZBhjF2oPSx3+TwVoTURevVUwM98=;
	b=kGQaDOQB1mgIkDjvIOlZsUhea9B790adeOMFBJEqReurUU7mhY2NozkJmCCxZbXmLX/LQH
	DERHwuhvHvdFypinFUwpJ3D6dQteUoDm9LHzzRYGLTRyRN1t/DTa25CjZCOfIdrgZHhUT0
	QhL7YJtDkl1cVfwlc2jZ96OSe8MfAX4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c85e1UcQ;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768944055; a=rsa-sha256;
	cv=none;
	b=SLkMOWLEpw48SeMXPr8Np2tGjTWA/dPL/y/JyKQMgPtMRuLajK8N22BuSBNFJpcE5fRNK8
	DumM3H3C0AqHwS+7RcyO9XIwrKoG75sfsX7tz5J6FxPM7jNoO6clNye8HMXdg43Fx9hDQL
	heduS38Fhil6RznJ39QZnBbqH8s3tDk=
Date: Tue, 20 Jan 2026 13:20:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768944052;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Yb9J55L/oOgj+YxKZBhjF2oPSx3+TwVoTURevVUwM98=;
	b=c85e1UcQiD93oYWn8CGxFNRUdeC/dijRaVuPuqh/n1pqqs4pLlBB5oXTGsSy1VX4rPt/KA
	cY+uAKK3+ANKyfSoJK1d4RoG9OsWJHnDimqQ9lNQPiGBfCATF9PvPZvDhq6jTMC6/FOTId
	jf4QJhRkdiOL28wH4NTZ8E988vqbaAk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Deepanshu Kartikey <kartikey406@gmail.com>, 
	syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	syzkaller-bugs@googlegroups.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Minchan Kim <minchan@kernel.org>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-ID: <aW_xUoiCM6Po1Pm0@linux.dev>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
 <20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
 <CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
 <CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
 <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: dkg9y7pxewaynpk9yq7ma8x8gqmz9kij
X-Rspamd-Queue-Id: DD10EC0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768944054-566826
X-HE-Meta: U2FsdGVkX18ugItIa+WblBlJPTfXxav2wqF/z5GyHrehNAePTSsP0DOb2WsDf9vop/uB97OO0nrx4c6dScgtdgvZK/FH2D03PsBCVQUkZUYKmYio7kUaumrIf14Ki3lu9xbbL7d5MOxlIHlHtceked+/zz7xoWk98RNEB1L1o1rzc2XHpok9AwhtZjrZre59zuCZpBIEPG4x1kV1fAbuB4bZTEFD/Y1M0AjB7GLmuhAfU8SiN5djkFtQC7fZgjNFvKPQm7mbXEox5KA0aZMqz2J2Kd+6ZWHwNtc5MD+2A+kZHeNm699ZMTzeon/R44ikIDw+gTM+PPGCTQXz4aFz5Qj2ToRy36l/76ahZBn1JiaH0Qnsz9X6uPiV/sAitD+Pk+mULRgruVNHhgZJpInipFF1FPUuffthRHmWOyJMwjVcwG5qwas8sPDd5543DolL8O/GSdV86h6BESV5tZcBMVCmAy3cmqJH04wGDJc8Y1vpJsJnxANLNPP+4tkfiwfqcAxKnbwvD5BTlS1Q4SgBEob/qsUZMGYPwotV1GRUUxkyDxwU2TR+EaEgpaj7mSnSR7+ihtQn0VVb5K82dmogY27ga9wqn2LkXTT39wJCjg27NISbQAy3qXZXYt59aezs3nHV+MsfXsMPLT7cl9+x477gfv/VtCV6pLL5Owtf7dZYaKAu1S4rISKp8z/HrVrwWhL0tfNocRQSV0UWv1PI5ZnEgjO56k37ZT4EWGAamzvrc7taEdcknj3Ynr3DdtVDyHMMW2utmQiySH5iCEkC31l89x67nbj5hgIJq2V7jyIFVmXbOmWdhr6VBK8639dfhGxqtkCmoac15ITMER0vZ2gZKhk2/v5XKKr5QpuO9msETQFJl+2hqhryIzdMQm+oIb4Xn+MSgrD8uyYsQz9e8RaWmFu8byoW2Ltm/RvKvEFL6/draqSmcTSH0h9u+lt+OF1LMKzEBS28lLL0jdz
 NYhOcK8u
 mfkV9qjIdVoWJ9IoR9ttHaCGqf4GbYL1pAjYG5MK7CIlI2WT8wiU/aHt1cw2GgLeo16F6uekiNxgCphBKpH8zmV1dWl45C4D4U69XQ79PZpYJ/JX6wK7UgOMEgzj0VpFxI9EA/mSUdiNUXzpL6r8XeZ0nKWDS+fsVWbM2p6OIiPxGBtFs/ingdEuV3mwMgm2gtqGJC6vi1CRPQgHjHpDza91Ez4V/vBAySBXYfC7Tarho06SCHPwLxovuFXeQYPY/gmOIg6JU12vnqrXdAswMFbNoA+ift/3T1YKwKGE4bImso+PgjnyYvVGnxIYgoUGW6n7hGsjOXQ0TZuG4mlWqPVAD5XXS9EBAmQIa9VqLrlrmuhcSUxFYS3jHeOyAOzGibaypvLeqgvIy25tRax8TR4Dbkly9Et5uk4xTynCzVGYV2kOQqUMTMEq86RVTqw2LZCLt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 18, 2026 at 12:53:11PM -0800, Andrew Morton wrote:
> On Sun, 18 Jan 2026 12:31:43 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:
> 
> > > >
> > > > That's
> > > >
> > > >         VM_WARN_ON_ONCE(oldid != 0);
> > > >
> > > > which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> > > > swap_cgroup_record".
> > > >
> > > > This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
> > > > which is six years old.  For some reason it has no cc:stable.
> > > >
> > > > Deepanshu's patch has no reviews.
> > > >
> > > > So can I please do the memcg maintainer summoning dance here?  We have a
> > > > repeatable BUG happening in mainline Linux.
> > > >
> > >
> > > Hi Andrew,
> > >
> > > I checked the git blame output for commit 0f853ca2a798:
> > >
> > > Line 763: memcg1_swapout(folio, swap);
> > > Line 764: __swap_cache_del_folio(ci, folio, swap, shadow);
> > >                     (d7a7b2f91f36b - Kairui Song, 2026-01-13 02:33:36 +0800)
> > >
> > > Kairui's reordering patch appears to have been merged on Jan 13.
> 
> Eek, there are many patches, it helps to identify them carefully.
> 
> I think you're referring to
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch
> 
> > > The syzbot report is also from Jan 13, likely from earlier in the
> > > day before the reordering patch was merged.
> > >
> > > So this report is from before the fix. The warning should not appear
> > > in linux-next builds after Jan 13.
> > >
> > > Thanks,
> > >
> > > Deepanshu
> > 
> > Hi Andrew,
> > 
> > I tested with the latest linux-next in sysbot. It is working fine
> 
> Great, thanks.  But we still don't have review for this one.
> 
> For some reason I don't have cc:stable on this - could people
> make a recommendation?
> 

I will get to this in couple of days (hopefully sooner). I think
Johannes was looking into this as well.


