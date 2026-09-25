Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A736AC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 09:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 908536B008C; Fri, 25 Sep 2026 05:33:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B93D6B0092; Fri, 25 Sep 2026 05:33:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6B26B0093; Fri, 25 Sep 2026 05:33:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2A06B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:33:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D7C141C318A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:33:15 +0000 (UTC)
X-FDA: 85251771150.10.B84C68C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4F8E3A0005
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 09:33:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMIVa0BQ;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790328794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zc9n3mJqDMHT63RHHVZQRnyrWAkJ65jwuxAucGKRt8c=;
	b=ZtwiE7tFKvelMnvrESENcnLmuuX2EBiPa1RnG4l63MDi+S+c4MePt+hvxVtGTunDyK8pLR
	+06531GJoJqkWu4Sc7g0J8qK3dtX6p0wP2Mcm3ILBiYj/SPUs6hZvKdKOporwXbd3mp51z
	sK62B+jE+riwcppKd8CszXYik6bZ2IA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790328794;
	b=dML/Fj1OLnGSQS9jXysYPDfeqUyNKdX+pp9CmsUev7hncIYfn3J6k/SrlQ/k0smxQYChut
	DK8dTYH3cahkMSeWqFD8GELgFuLVDaVipDAiVigAYs6T4etaCfkKKfNrtZIqr5tyoaEHnn
	KtpfzreZP87DAe6NjGHP4I1tKd+Gxo8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nMIVa0BQ;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B89BE6022F;
	Fri, 25 Sep 2026 09:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D231F000FF;
	Fri, 25 Sep 2026 09:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790328793;
	bh=zc9n3mJqDMHT63RHHVZQRnyrWAkJ65jwuxAucGKRt8c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nMIVa0BQ18T14JZR4xL9yjqjrPrEX6NpiZ4+6BZJys6GSNo5xl2WmCChPao2jVEIQ
	 jfzbNthAkqojRoRFWj8OIisDLwJKu93jq7ZvFZk9/HuT1pGLId6pg7zYGPGvZEMSco
	 rF01ycq7yBYtgtW9v42VWsXA1GXSTN3tazX8ZhrWn5k4LwGaBT9czRGHFvduLIDxSk
	 jcWV6bRCYd7gFHL4T+HaABcjhJAh8uXt778MyFjuJm17vAPBmd/zhJB0lkOFqBcryy
	 qjxKUZX8Zef3dE5xRk88qPloiyRonEEMoqzqBF0l+ac0e9PcnrLIVx6Rp+T7LgXVlR
	 y+NUjR5s8nnbg==
Date: Fri, 25 Sep 2026 12:33:07 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 4/5] hibernation, KFENCE: explicitly map/unmap KFENCE
 pages
Message-ID: <arY_058nsjb_Ie1l@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org>
 <fec1931b-1173-4e14-b74a-7b3987a9b7bc@kernel.org>
 <arP0-maAEi5yeNnl@kernel.org>
 <d568a29b-5745-4214-96d3-1b635cd46c15@kernel.org>
 <arVJm8CiLG6vpy9-@kernel.org>
 <c01aa1e3-f2cd-4b28-8e6a-8e8a1c36c641@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c01aa1e3-f2cd-4b28-8e6a-8e8a1c36c641@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4F8E3A0005
X-Stat-Signature: rp9pdxgkupa5e6c5rkuh1wruq7dz1oud
X-Rspam-User: 
X-HE-Tag: 1790328794-764848
X-HE-Meta: U2FsdGVkX181TcidwFwoEqSrAO/iScgFSlOLeRZEdfqmLSvAiPrpOpzq1q4NyxrjZ6BfhQptRcjvjwjVUri3Hdaqm7w/DJvo/D465wA4arSxO0TRzW60LRGGH6WbmpDeEd5y6B+WLGUI1caovRHKnQ0gC2VoeHNfi3YNK10oWuhHS69j3WS4sIrt4Hr1WWBCvPAw/Ik0887nJW2EkAW8iY9UqTZUDEVy2PmP8KGstxezQTiBK5HL9Y8NiQP/IrQEv1lUjrka/gJ53eypF54PR/k8QijNj7wPIWcxkevMQqM0jZXn/ANZljemxVMyQNeWEpy29Y5QMDBEMFj4w4hGACPPPFaP1uAJRxKt1CzhLqvlQXqK0X2VLfX3QJGAiau6PR9BjkK9lGsYr7mMxzorlhg49QJ+eoEW/pd+yKqKtJy77cQQIQkMov/Lw6BtLllohPQd8gcIgZsQYbcn12RzCQDxeNLOsybCf0lEJAgY3NMnwPgYBZDTMCidAdBYE0jU3pRp8Uiubl0W1MvwdsuKmSloCELMNcq5i84cLmQ2nInCXKyaNPVgJav2sv7ZM3/zQ2lBsU6A+DUov7VlgnBEHxgMWYBuZWlrRq1QlWJkpVOxAo3y0IyhGkEGbBtywgEpf8ltD7ImdT/hgIAgSfe/6c7x86NYSTQXLpbj0O58iYEuBcNBotYuDLnvntJ99ZO/YoYNUrk0bSc/TQ9mVK9p5yJ0kgYjF4JNeGHok3QVQptk69K78cr97pVMiu1nIMlVHAoboJ+WU4mqgq4qKgXso/Ad28kMZO0V09vHH6bMaOuQ+GY//GV7xE35BDKCyiDwdCPW6wUMlfqmiSgxtd/ey6ULFrkgZkVNQi/rnuKwABNEop5KWNwj5dVTzjr9NHAy9PXPSzwWxcXjOZjEHu6bT2U4Sk3b7/eDYfSo2v+je0k70PPQV88oAANnylUVPh6sep/ZRtC0uU0/uwDIhVt
 HcBTNFDR
 F+GKvjrZ2nHLoAuLatwCNdCyP4t2P94ci9zmlD3q0UIDpdhPGciszsUFoxTFsXFxsgotmKESGtArHFnxlTAq92amPMJvmjTfYfT4igfwtB1oIYzcroK9hbCpv4OOmFyJOg/bm2Gx948NuU2772QPR6iJdUCSPm2lUraJJwy7g5OnOct97VHVygRVmqpD6IiyNFxjcne6nLRa7bcCp0K6nTh145cbqxSbW8YyUO+AOHIxNFbFojyqV+9vBKvqqSAzVFCUr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 08:49:13PM +0200, David Hildenbrand (Arm) wrote:
> On 9/24/26 18:02, Mike Rapoport wrote:
> > On Thu, Sep 24, 2026 at 10:19:33AM +0200, David Hildenbrand (Arm) wrote:
> >> On 9/23/26 17:49, Mike Rapoport wrote:
> >>>
> >>> Naming is hard :-D
> >>>
> >>> I feel that _copy_page() is to vague and adding hibernation there is to
> >>> mouthful :(
> >>
> >> Yeah, I wouldn't mention hibernation.
> >>
> >>
> >>
> >>>
> >>> And these could be used outside of safe_copy_page() someday.
> >>>
> >>> How about 
> >>>
> >>> kfence_set_page_present()
> >>> kfence_set_page_default()
> >>
> >>
> >> Maybe spell out "direct_map" ?
> >>
> >> kfence_set_direct_map_present()
> >>
> >> kfence_set_direct_map_default()
> > 
> > They are not necessarily in direct map :)
> > loongarch does not have direct map, but still supports kfence
> 
> Ugh :D
> 
> But where are the pages mapped/unmapped then?

loongarch remaps them into vmalloc address space and sets page->virtual for
page_address() to work.
 
> (I know, I should read your doc patch)
> 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

