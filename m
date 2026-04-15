Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF08CF531FC
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 09:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4485C6B0095; Wed, 15 Apr 2026 05:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420236B0096; Wed, 15 Apr 2026 05:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35D296B0098; Wed, 15 Apr 2026 05:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2343C6B0095
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 05:21:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3738B9BDA
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:21:05 +0000 (UTC)
X-FDA: 84660246090.24.2A8F564
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id F09814000D
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 09:21:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NS6QT61T;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776244864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/TEMft9/PMqUHmiKPhVIMzXi/K65izkkDIFtpJ0pcw=;
	b=2AGZfxQNOUOgCxhN3e+HH3411PbnwV0kqOw9Pk1ZfZO27HB2gdJ4bYp1iL8yUHjmUaJYSv
	mE7gI/4g1XSfoMS2L5e+f+7a6g4ZibxIKEGH/95vX/HfYzI+lTcPAQw5RmMx1gC+cW7lua
	7LvyByUELFFPAgUkzS86UOhO3bc4L1k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NS6QT61T;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776244864; a=rsa-sha256;
	cv=none;
	b=2dk5iENdoDqFS/eW3a/IyuRunnx74KUJuCg0uXtHzfLI6sEpAlo+xU20Le3icE3/Gda4RL
	VB5GTwbgdM+y18dePaErwn4xfMLTXETJ9cNz1Ok1sous5wYrpE/f6Jw22IXJ+CEusnegKP
	Okp0GYFjJYsn2IBQlojqF21RAH4KqAY=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776244861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y/TEMft9/PMqUHmiKPhVIMzXi/K65izkkDIFtpJ0pcw=;
	b=NS6QT61Tr4egecjIz/IWqLyXbWLG72UKaw4+7vh3Y2pE7zgmwIcgHD099KszHagiV7aTvL
	hNUNbtjlKiun0T1bGqc4DVrGC83iCLlOErmRbX/ZPxM13HCsh9aNQ8mIoaGbLiP0cSKicu
	0O/db+gqzQiQgUIe7F/w/PNEaW7kxFU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <09d1ef13-e02b-41e9-b431-4c3254e42011@kernel.org>
Date: Wed, 15 Apr 2026 17:20:13 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Charan Teja Kalla <quic_charante@quicinc.com>,
 Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B139F2C1-77CB-43A5-8377-4F4BD44ADC6C@linux.dev>
References: <20260415022326.53218-1-songmuchun@bytedance.com>
 <09d1ef13-e02b-41e9-b431-4c3254e42011@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F09814000D
X-Stat-Signature: f6ms8soq596a8ys1aixxe3gfk9mctnc3
X-Rspam-User: 
X-HE-Tag: 1776244863-369642
X-HE-Meta: U2FsdGVkX1+jkDuK98d/NSdZ+JzYci1UZX8LJOQ84dE7I+haEjPYyJZSUOmK1TKor/56XhI3KQvBzXn9QDFf4vNAQ6b/+LE8yU24G6UNgcaInGU0INBmPYKcyXp71+nQlLDZ2yhJ2lFHQxPb2BFRhJcs/1SOVg60JWDxYyCIWngK54zEmgQe3j1bR2TrOTnL4abjKeCtNe2swAlsvWkyZ8aXK31rJwQ35/+nh03swa3saTQzH7D+JVGLwzq+C0MsQojl20kCaPD73TIJxnsc7gQaqK+rezhsVwyklIgMqHxAT2cWFCWEXvRUcjnieEK9elt5JS5/8cREqmPRPBon9q/AuauIdWL/PZsGR3Ec83i1jK+2MwEMoVFQ6/Qmurk9wUagNS+yJ2DNa8r4HqaHv79qXYh8MigEhfJKoFxMXRFqaG0oonvqqnMK3XvXz2VNRnDpqHHFjRqT00K3oclD8fFpO29V9irBtkS26nSO/mEPmcKCHX4jbuksy+FflBMimM1nsmLQkbTQ67rujqbcllqZZG/BUvgU4lWBv9rFw+Znvqj53SVXbxRoPCNRaRcLtQK4W8a4AAibjQdBbEchabUImHb721F3RHsznrs/dihUyA27OU5AIdr984ja8Wu62BHSW9KqhYSUnRfWTnmydfZzzOTQws2h4TUuOllt4FKy9HzaH3+qi7IFdp+qF7xnC6+wwLlR+xXu8qZKWNkoFNQMHhU7XNWPiyPz2PmKZSi+EZP6JRfk6DkbbOHJTqqXovtjDpKkHPmQN97TD33BA7tbIR5twPsXiengRdeHpxH3q00Xij8z9zQCfVH3ZQAq6qHQ+o97/GN1UNKECAmzshoeVUIC6gKz/FSrqrcDroVNr6KyC8hp5hT1m0C3+5Q+SvEpyleAsawHy9q89Z2qK6Tqv1Hr+ar9d1NPIkr3BxHISF9bRRtk9Dy3uVx0a1cahNCnSplIlRBVGpraD7l
 H8L693Qd
 Juvcp2/nYer/cU7FLYFPHzpg8xQXxJk36OmUDmE4F8qFrfo/zN2OpaFff5LF3GHbcRLl2B2aO4hHRbC0j0kwDn/yGZfKDCHS+66FBv9Y1S3GL0ZBpjNS1JOz+00oRRCO3DqZr8HWHh4mCnpRJbv2H7sGzJmPK0H7w8sqDdlpEDlmSeLDMH+PswgSTFaETyOtnbkXXYSn8cAbIteTGnd95aYWS7hdP9fob1eHneoMKApZHccecF4QGxsP8SNnvBw/1uTEtSsNEe3NDd5glFCPmtC0mDh0TVssgZVgoxxMhK82oKITeT7skjSWChQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 15, 2026, at 16:04, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 4/15/26 04:23, Muchun Song wrote:
>> When memory is hot-removed, section_deactivate() can tear down
>> mem_section->usage while concurrent pfn walkers still inspect the
>> subsection map via pfn_section_valid() or pfn_section_first_valid().
>=20
> I'll note that it's all racy either way: someone checking pfn_valid() =
/
> pfn_to_online_page() can race with concurrent unplug.

Agree. When I first saw the commit message for 5ec8e8ea8b77, I was =
curious
because the goal of this commit was to fix an access issue with =
ms->usage.
Looking at the race diagram, I realized that while this only addresses =
the
->usage access, subsequent accesses to struct page will still be =
problematic.
It's just that the former issue happened to be triggered first in this =
specific
commit.

>=20
> We've known that for years; it's hard to fix; it never ever triggers =
:)

Glad to know my analysis wasn't off! It seems I've just stumbled upon a
'well-known secret' within the community. :)

>=20
> So is this really worth it, when we should in fact, work on protecting
> the users of pfn_valid() / pfn_to_online_page() with rcu or similar?

I am not sure if it is worth fixing, especially since I just realized =
the
community has been aware of this issue for many years. If we do decide =
to
fix it, I think the most straightforward approach would be to protect it
using RCU, something like:

# the user side of pfn_to_online_page():
	rcu_read_lock();=20
	page =3D pfn_to_online_page();
	if (!get_page_unless_zero(page))
	    goto out_unlock;
	rcu_read_unlock();


# the vmemmap freeing side should free the vmemmap pages via RCU.


Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David


