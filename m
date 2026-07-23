Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2711C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 11:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C456B0088; Thu, 23 Jul 2026 07:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CFD6B008A; Thu, 23 Jul 2026 07:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE366B008C; Thu, 23 Jul 2026 07:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 032F16B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:29:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B29FA048F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:29:29 +0000 (UTC)
X-FDA: 85019820858.28.7F90BAA
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 283BD14000C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:29:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dmcrERvO;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784806167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XnK5MSZnm10txveKUazi1pt0QZOCFoh2oisogPVwAY=;
	b=wxdIG0Nq8ckM/JcQuflA56Dl2tAMmSa0vsLbtZojJVBcaygmdfmQxFW8+eEv41xX3gRp6u
	FIpRKrHXkNmOnvFy03owdfPh/zr4NWf+b3KxJCUUa1nP/nM9EdFDev5xEcpul2p32D+zfM
	LFCzPedo47vAz+EnmAkecn2QZScs4fY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784806167;
	b=nEhij7aCfvb0vfFReF4CbHP2YiGBjHwwL4pgmULQB4HNG/fIvwL5PKTHslkr5xaV1fMtnb
	H8sYA++jcRdOm2Lu/ho0aVv1aq+8hhD/+BizCgkb68xLMp361tKkPt5oayOqneiA8l5rYi
	wZ+6uLeXNaORVIPLehFimPOTeKpVrUA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dmcrERvO;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 23 Jul 2026 19:29:17 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784806165;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4XnK5MSZnm10txveKUazi1pt0QZOCFoh2oisogPVwAY=;
	b=dmcrERvOOrxVpIfxHgtyEWEvap5lrXEjssBSFtGgA/+fX2aNAs6CQAq9AGzIkJRB1Ch+MU
	T2RdeaIPyWYC++4/ReVAQcWvH1MCnxevqYUO+LzvCgSqfy62lWAkN1cow5j3uoX1hIwuxV
	8ruwfWHStx6xP345j8n5kw5DRBYFKc8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v2 03/13] mm/slab: remove objs_per_slab()
Message-ID: <amH619DxX4_rO6kM@fedora>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
 <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260720-b4-objext_split-v2-3-2fa7c6f60dbe@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 283BD14000C
X-Stat-Signature: b9a1bnpnymibpak787tsd9w6qycc3bgk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784806167-414287
X-HE-Meta: U2FsdGVkX18k50AZ2n4eh4ieWC17zWhJJRT1v0LI50xOoiZIEO79hPSqNvPu+o8FeYj4dRpIWhhjghVdrNyEVcHCCNQShVG+/L4iodkVuP/o1820TrCAIr0qYtxSSgK6laUVtq3Ni3xZf12nFAcxEJfivTj7r+pcXaLDN6FJEYY+wkHyMcIAln7do3L/aexY41pmboXAJEJOoR9RW2MEkH/zmEMfQyN5zL8OJsn/btfuZxDkZG0JNicP88ycMgBYX0hZ0Il+yF4kZI3ix/PbHdza7+oYyJB19wXHSWuTL9rW81RfNIKhxrtJA6fLm14/ywyCELASjzKuoIrtZIU0KxAnBJt6wwqdPQKzsMN271bknYEwAwIZwYP9+izcYdnCN9D+4RaDvkifZxmHbsLKgw73RhgaDBlntImvU8kNIBAz9ZrhJ9EH8J1IAiuu6ZmokTZiG71zq+68cEd1Ju2XXkgcsuUp0w/gwJqTuXobv5LIpzTNMh1Zr1DgAmYzzraZm2dyTGSGvsK23+TGttrO7bCJlD4If3Z7gOiFHapyb/sHA5RqYyuRSKkDJGnVGm5hJz+hF+mEVdkrlks4EKG3HzXK6HoXHVZaT0p0DytfGr71f4fHH3xccOyL6p2QbVMf1ZzkPgpd4ay3n3oq38nIqUTTnZYzvve/m1/lx8O9hX3bsWSGnd2nRpJXLw/tZftm5F3+m2C9ZKPegRYXyZDc5+wJ83q6NM4ATcdhGtAFVnQ3aD16G8pYsbCWIiXqnKMAOXjiMVca+9bwNtXZd8fFlel+NPKjHR/IsCZ/2+Y2jyRk0MCVhbNS4/CYHp6/aowIn6ISWNoBb584vk3PMqE6MfWPNE2CF+W++bfUjRE+/OeglI0rkt8Ny1sI7m65MBXKHDrqAg1Cgw7VlLXy0AV5UsCQDCRnzOOQeVKT0bRbetemIOfoak6goC+TMf1b25fyANiz18FHxAb4pdZitpc
 GNoy089k
 N3cgUv/dh3hVW/4BMsPG34eOFSTZrflK4LgqZH1gXqAuXzwuFc/vU0SY7wA+FqU7poAexeZn+JgH8G1BOaTqF+RKMHTY98THhXJN8qV+Tz4Dp4ClMAwpHVV1O7fOxAIyWtohd8Hd7fMMcPMR4AZBAB2oSUVGPSMbMguvscuQbL6SgBNaviOw17JUbTd9FkH9QaMUpK8O1U97kfxIjR/0ySOm2YcCB2RVqRjsQz0I41Ux5ziVDYvswGqsd92mzMuPdRFZxM7Kb/RhQM2RD56ncEaUfHIUIHCHF5NcWYJLOYHmwfvyRxA/jMCOTQsMaNKwf48UmQ5WXLOVAmZdqPZT48VJbSfl+jHzvQ5Cm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 04:16:17PM +0200, Vlastimil Babka (SUSE) wrote:
> The function has an unused kmem_cache argument and almost nothing uses
> it anyway; doing slab->objects is simpler. Remove it with the last two
> users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
> to a bit-field" but we don't need to keep a wrapper just for that.
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/kfence/kfence_test.c | 2 +-
>  mm/slab.h               | 6 ------
>  mm/slub.c               | 3 +--
>  3 files changed, 2 insertions(+), 9 deletions(-)
> 

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

