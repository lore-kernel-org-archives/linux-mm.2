Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F26CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED0D6B0092; Tue,  6 Oct 2026 05:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19D8C6B0093; Tue,  6 Oct 2026 05:13:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F216B0095; Tue,  6 Oct 2026 05:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8ABA6B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:13:52 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 352881402CD
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:13:52 +0000 (UTC)
X-FDA: 85291639104.20.64D40DE
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16203A0005
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:13:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M YzNnMS";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=e0MmQS2y;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbQD73+crd7vZ9QKN8oet3vSF/p7ePpJtz6mLHHA2fo=;
	b=xBzZgwNevEWU+eilHevIcCYhgtUrtzxE/HisRyk9B/4O1XRynTqV0a0zHV0qtuioHtH5rJ
	qHJ4NzIyw/wlbXVWaAIrgKKC64pQGhAtweBDT9LN2k3Qz5AijXgaj+Mu6fz44m6cUvx0Ey
	CsAXf/vMU0d0qzhE9rjY4SAz7IYMhSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278030;
	b=ubUHJv2HxbHYYYie5tYe4qBUGuA6Xe3mKlAfRzYG3UyyKxsVbcWYtIphB2NPVNLmhwWPW7
	jY4bKPS/udoi+KS246mgJtAMrROVMLVvy+Fpu8GJ4HceJ0n9xDZVC5nDGDd4WKcbzNo4Go
	tF/c6U3ftMVwzWHADvuXtEiAWPtjOmM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="M YzNnMS";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=e0MmQS2y;
	spf=pass (imf25.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.152 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5568B14000B7
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:13:49 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Tue, 06 Oct 2026 05:13:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1791278028; x=
	1791364428; bh=MbQD73+crd7vZ9QKN8oet3vSF/p7ePpJtz6mLHHA2fo=; b=M
	YzNnMS7ZN3wVSn2vEjszZQBWv/gqXaybvo1BuDsA24Dv1uYKul3eMDqRHrZ59TYg
	NtM50AO+2d+0tzTVAU8OZGJhydpPVoNghkJc6ctrvMtP9EcrTenBLFhsNRfnOg67
	RqkkUsqnJdYW8sHuIzL7LEnGDIoc2B1w6eHmwBTOuGI8Yrtx+KV8Ft3Inr3t2qFa
	cmQ0UPhjVoM9AtN09FGMYD/bskoWSGztPDBUg7ez1AI6PJ+n+vgaUitsJZ20jDnw
	Pe/caucJEeirWsGMsWpFyxJ8Pqluw2Sfqcnri6h6Ub3W+QEklscvlFznQdE+6CNJ
	vu9LN2nfJAerHb7zCSJSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1791278028; x=1791364428; bh=MbQD73+crd7vZ9QKN8oet3vSF/p7ePpJtz6
	mLHHA2fo=; b=e0MmQS2yZZ9YatnShEldHczseY8u/Cl142cD7PJEap/5ee30t18
	cCTSQo64oi7NTKBxMWcwM/uwx6zKhYqpjpRQCbL+DS9qTZO8p++CpZm3pFdqy7z1
	m7kGmofudCFATpHNN69DDVYLq0DwBrc+S/Ie7OEPnHE8/LVSZEeFOcmcRUrHyU4V
	Ql2v7l4P5Xr/uAZoJizz0kUFpRNcHPnTQcb36QMhJJDFRnBKolVvdqNbUkQJ5oJF
	6oCn7XckLLuZovW8XclyLNFekxUGgiKqvb75kr1iavPEcP+HZAHk11IKxIALmO+L
	1cPbtmpZr+zsoHTgt6n1yYYbteAZ1PWanrw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=sign d=shutemov.name a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1791278028; d=shutemov.name;
	mf=PGtpcmlsbEBzaHV0ZW1vdi5uYW1lPg==;
	rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm3:rsa-sha256:Jipfw1abZPXoRyFBIbDoqIX0HcbRQRirNonsjCLI5vGHMA9
	/1TJzqvIdS7ZoX65A19PFQV8KYwfVQDYxQQAlu7dJhvTwh1HIMer/KAhegISfQ24
	BZDIm15wVb3CIKl1sAvT9JYnJC+byT4iaUqD5UDFZDf38XTvfckDzxOh+5F3+Jjn
	gjmJY8OnyA3bgqjBURtgqW8sUnNJk3JxQJHjroNIsgCNaUwT27PUeaHauHXQJn8n
	NjceycdgZD6jd9qZg/+fQJ3r6u1IsC+8I19jB8s9yEIYnlbQcTT8+dMfnF4yWAPL
	igh8mF/qpcGAmcSjpFfEhw6ev7MDNBqNvx3IA3A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-06;
	repo=github.com/dkim2wg/interop; date=2026-10-04; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-disposition,content-type,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:3q1TEc8G3uI4UoP5ag6eEF2ixUYiG8Gk1JdkBHKwrdA=:Uzht/gnnalOdKMOxMXIuqX3WZTTWDv2ShAnEFEPyhKE=;
X-ME-Sender: <xms:zLvEaqVNCUxN4ccW14K2KFK0QXb49TzWtFKDF2X0Q3dK_3wtar0Awg>
    <xme:zLvEao9zRkn-NMYh0yjfoAD29xzWXLWX5GSiXabJIt3o3C8UJEVvHM9Qg9LDpmAwo
    l3ibLGfyyBYHdjVTJNh3BlHf_naNTGXJX18e7MHyrO6S291WwAYPac>
X-ME-Received: <xmr:zLvEanqvOAI6cptylGAfXrbHpne4ZOfMbXDqHxPDhrfTykLquREzv-kMKB4>
X-ME-Proxy-Cause: dmFkZTGj5C67xIbzcGLTgoQok/07Sc/orEjUInqIagiNX5tzfNrUnfY1jc1lLJwh2gzo3d
    GB698lLckGkQyvrNDBFvobDZ3AKW7HlEJvdeuEuAlIxo1NdMYrrrtakWUQIQiEjBN1B6ri
    wKi6qEUiJkKlNVegjOAgd0kUGjoPwR2IgA2mVnAWW8VbDla5+6eFmaorfJUN0WOYRndIYz
    ROX+4JJqCmnVpPn32jhHBxpZJszOIgw5BxKJ/vniHlQHUTPspDkZn8zhQw0awtlwixI2g3
    ZQGvwVpHDDhkkyRNR5r0tSVt1oN1XUrc8PaZB0foWj2F5PK6JJDPxdNR/3G99Mnb2qvrMU
    c56mQJWj6ObswPBB90YvyTCtHf3ox7HVMuKz78cItUQKSFqXMvsOUzU1YutPwP6Vp0EtNg
    zvaHKJI42l7V9TJ0PtV+gPEm3VW6l5/XgGbg2LEQIqoNJRWGFRPjO6mVeUFvHnf0OZ+Y/f
    4U0nHEL2QJASnnhk7mRiDdptzT/IKVcoui7jBiKWondtSYcFEB2DTr9KCNiVa0Et8B7VNL
    CCwc12rO2qO9rgrLt9TDix40u9rQecSgc6cc+ZDifD2hr4+OZ8aP4oavNuhISU7/obNUNe
    ypS3e2WxOARZDzI/ev8A/xhnLBLFoVPsYk/rnhA+zd8K2PQGzyCNC4G75z+A
X-ME-Proxy: <xmx:zLvEakf-Avx6HemUgYgNU-z-6nJ1Dj7h71J20c7xNyFzfY5K1YmJmQ>
    <xmx:zLvEam8XoTo7jDk2JIPuEvKlekuwb2Wra6wbYoGndj0ziiLHy6V3Jw>
    <xmx:zLvEaubjvbvOevENtcRI8NnnvuQGwAnSNAYoy3j7xxCeaAi3M-bfsA>
    <xmx:zLvEah1DQVwbKNt_l8_s6Ds1zH6SXTER3iNUcEET-o_Lok2Q9bTT9w>
    <xmx:zLvEaphCg6igknTLamJgXfAoRArks9hx9dtkfEUFwPqBRd26TKKctBxG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 6 Oct 2026 05:13:47 -0400 (EDT)
Date: Tue, 6 Oct 2026 10:13:46 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Harry Yoo <harry@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Message-ID: <asS6uQPZY_9r2uUG@thinkstation>
References: <20260929174553.175333-1-kirill@shutemov.name>
 <arv8J7ysrdazJmfY@thinkstation>
 <ar0NRMxps8UErXaQ@thinkstation>
 <ar0Xbs9mEu-vUHvc@cmpxchg.org>
 <ar5rOHWwc_iPJF6C@thinkstation>
 <20261006081050.GA234057@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006081050.GA234057@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 16203A0005
X-Stat-Signature: at11xrt5tbzafc1rm4pomc87shbkgqpb
X-HE-Tag: 1791278029-96097
X-HE-Meta: U2FsdGVkX19SSwhiRH1yThW5sCAHbredeAYcN2JZNMC2yqkZmLglQIt/XvLrAI7RBIY+F+A1NhvXIE9krHswPvw6ysRPOWBUjEuAwMXnVbsi88gNDJnynnkhD/CfDCmANvOWOeLsOb2J+TTbXEt2akG2VtJmgNKNio0go+C5w3TxZGQKofNTXT8+M9IoUi8YbZYqt/jum66q8r/iiRXTfX5HcsHllASP2dDZoiQc81LscCCfhAIzU6/5lehDKptymWfqQso0aDZ+txLW02T/Z0TICOaCdfbK7ZYVY1oC+6sPqB8DndsTqTFwd5wvl2MYIwZY6VtJzH16w7+qhfDglJpSTClybSFYUY3k+Qt74bPRFCVFOxXXoa5mZ1LqwrusQcSEbJIJvBN5AS3SiijkzL1/YHAYFS5bOdsgg4/kzNlaCOJwUWVvLqnmN1FrSxAVO0J9RKPy/jHQxjnFyVyK03e7xPVFLT5OMlY2hlGljTZ4sSX45BoIp2gqrvs1jHO1y2A+3wxEOubY1N1Tf0Y7OJr6sOqdebHYabDQElh5+58gDqv7/i3KPmhYKjjD09q7ugTcdnCamce03BfpWTMVtXQVTcGsEEA7rT/XIJzc4GVhZSffzEOD93yXDQAvYQ3KXBMsYVx4u+6x4tp8oU7t0wcUSVcohmueKSN3E6R8FKAIZl0KBAwX1dc56DGCk28EjQN8py6r594WjTNHqpN+zhugTqd9VDaI7imazJVtoZ8SRmtZ8ee3ipt9Zto30nPBuh9IMq1v3zWmOPcG3+rnQo6TXpS8qiKHFVW59iXPIRUCk2pcd5YmB+NUD8Pvk2wIvl2bhDUcUd4YqIKMF+3djDXDTwLuR9Lvml/+g6HkWpGLhMxOiTVWLN/NB374ngJyZfrf410Iq8yk/Mwn93k5Q09Pp53WiNYRhAvxe8S3C9t/h0NtWAsXXYaO082HO3azl4B2b1YJ3HxTArpfWq5
 urtw8STn
 qDBjKTmRVmGDiCcjJ4+a4vyLKb6WTF0+BMPz9OMZRDiJfP/P9qjbVAVJit4KF8DK1e0jllt3FnH9KbVdhF9U27CvDhC9dpqYOaHG7iCYD26h/q+NKVEIg6FqwnMKvHlPU2e9OeFYaLICjRWUzR2irFSCOJGO7sunqBJ8Y+oIyN7LvsVYgMPSE9YnCgqDT/o2Gj+HMACC47LWTL6aDyFYvxqu+BJCUcZOpmUs6afssaN/7mbTf535ekQF+Me7A5Pw10/ou23B5F7k54/qxMaamqvo9byqtMNGmQAdHgkJbis7s5IkM9LDEO5jZ5Sb3eG+jvZSC5HL3Kt6WGiASIPnVUU+/iBRsHEwbXzzs8d2kNlzBNMzR2RbSdYU18TL2pu6Bo/jJQujQICWWCK2pJZp3Jiz6DFJeuaggZLcglEAGGV0X9zF1hdd1TMXuRLwSSDRruaU8vP3dARQY/NZIDbY7NnCnFhn99gPcOzGgbxJdNyQQltEFVRJ3wMBmxvT5ltigShoNt/soN1U3Bxd2LQFq9v/vPyVGhnTIdq22AD40I5OAnuT8E4eHJZOrfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 10:10:50AM +0200, Johannes Weiner wrote:
> Without counter indication, I would prefer to keep the tighter
> guarantees. ISTR this mattered on some of my ext4 tests in the past
> with the buffer locking.

OK, v2 takes the priority floor and the COMPACT_SUCCESS retry limit
from the requested order, with the explicit promoted order folded in.

> >     Should defrag_mode treat MIGRATE_MOVABLE like ZONE_MOVABLE there and
> >     move the page out at pin time? Ideally we might want to move it back
> >     on unpin, but it can be done by compaction too.
> 
> Should it even be specific to defrag_mode? I suppose without it, the
> poisoning from fallbacks would dominate by a landslide under
> pressure. But these pins can mess with compactability long before
> becoming capacity-bound.

Agreed, a pinned page in a movable block hurts compaction regardless of
defrag_mode.

It can make longterm pinning more expensive, but it is the right place
to pay the cost.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

